function outImage = clusteredSlidingWindow_ConnectedImages(edgeImage, slidingWindow, rgbImage)
    global MIN_NO_PIXELS
    
    newSlidingWindow = slidingWindow;
    sz = numel(newSlidingWindow);
    
    bmpImg = false(size(edgeImage));
    
    for indx = 1:sz
        xMin = newSlidingWindow(indx).minX;
        xMax = newSlidingWindow(indx).maxX;
        yMin = newSlidingWindow(indx).minY;
        yMax = newSlidingWindow(indx).maxY;
        bmpImg(xMin:xMax, yMin:yMax) = true;        
    end
    paddedBmp = padarray(bmpImg,[1 1],0,'both');
    labelImg = zeros(size(paddedBmp));
    eqiv = [];
    mask = [1 1 1; 1 1 0; 0 0 0];
    [row,col] = size(paddedBmp);
    label = 1;indx =1;
    for r = 2:row-1
        for c = 2:col-1
            cropImg = paddedBmp(r-1:r+1,c-1:c+1);
            maskedImg = cropImg .* mask;
            if maskedImg(2,2) == 1
                smNbr = sum(maskedImg(1,:)) + maskedImg(2,1);
                if smNbr == 0
                    labelImg(r,c) = label;
                    label = label + 1;
                else
                    cropLabelImg = labelImg(r-1:r+1,c-1:c+1);
                    cropIndexdLabelledImg = [cropLabelImg(1,:) cropLabelImg(2,:) cropLabelImg(3,:)];
                    uCropLabelIndx = unique(cropIndexdLabelledImg);
                    if uCropLabelIndx(1) == 0
                        uCropLabelIndx = uCropLabelIndx(2:end);
                    end
                    if numel(uCropLabelIndx) == 1
                        labelImg(r,c) = uCropLabelIndx;
                    else %if numel(uCropLabelIndx) == 2
                        eqiv(indx).pair = [uCropLabelIndx(1); uCropLabelIndx(2)];
                        labelImg(r,c) = uCropLabelIndx(1);
                        indx = indx+1;
%                     else
%                         labelImg(r,c) = 255;
                    end
                end
            end
        end
    end
    if ~isempty(eqiv)
        allpair = [eqiv.pair];
        labelImg = mergeConnectedAssignOneLabel(allpair,labelImg);
    end
    totalLabels = unique(labelImg(:,:));
    if totalLabels(1) == 0
        totalLabels = totalLabels(2:end);
    end
%     offset = 0;
    outImage = repmat(struct('image',[],'rgbImage',[]),length(totalLabels),1);
    imidx = 0;
    for indx1 = 1:length(totalLabels)
        [fidr,fidc] = find(labelImg(:,:) == totalLabels(indx1));
        xmin = min(fidr); xmax = max(fidr); ymin = min(fidc); ymax = max(fidc);
        charImage = edgeImage(xmin:xmax, ymin:ymax); %uint8(zeros(xsize,ysize));
        colorImage = rgbImage(xmin:xmax, ymin:ymax,:);
        if numel(charImage) > MIN_NO_PIXELS
            imidx = imidx + 1;
            outImage(imidx).image = charImage;
            outImage(imidx).rgbImage = colorImage;
        end
    end
end
