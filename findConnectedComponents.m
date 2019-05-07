function labelledImage = findConnectedComponents(inImage, newFilename)
    global USE_NIBLACK MIN_LABEL_AREA MIN_LABEL_AR RESULTS_DIR
    if USE_NIBLACK
        inImg = niblackThreshold(inImage,[9 9]);
%         inImg = inputImg;
    else
        inImg = im2bw(inImage, 0.5); %graythresh(inputImg));
    end
    figure1 = figure;
    axes1 = axes('Parent',figure1);
    hold(axes1,'all');
    subplot(2,1,1);imshow(inImage);
    xlabel('Deskewed Patch');
    subplot(2,1,2);imshow(inImg);
    xlabel('Thresholded Patch');
%     imshow(inImg);
%     title(str);
    saveas(figure1,[RESULTS_DIR newFilename],'jpg')  % here you save the figure
    
    bmpImg = 1- inImg;    
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
    [xrowLabel, ycolLabel] = size(labelImg);
    for indx1 = 1:length(totalLabels)
        [fidr,fidc] = find(labelImg(:,:) == totalLabels(indx1));
        xmin = min(fidr); xmax = max(fidr); 
        ymin = min(fidc); ymax = max(fidc);
        xsize = xmax - xmin + 1;
        ysize = ymax - ymin + 1;
        sumCharImage = 0;
        for r = 1: length(fidr)
            row = uint8(fidr(r)); col = uint8(fidc(r));
            sumCharImage = sumCharImage + logical(labelImg(row,col));
        end
        if sumCharImage < MIN_LABEL_AREA || (xsize/xrowLabel) < MIN_LABEL_AR || (ysize/ycolLabel) < 0.02
            for r = 1: length(fidr)
                row = uint8(fidr(r)); col = uint8(fidc(r));
                labelImg(row,col) = 0;
            end
        end
    end
    newLabelImg = reAssignLabelsLeftToRight(labelImg);
    totalLabels = unique(newLabelImg(:,:));
    if totalLabels(1) == 0
        totalLabels = totalLabels(2:end);
    end
    offset = 2;
    labelledImage = repmat(struct('candidate',[],'size',[]),length(totalLabels),1);

    for indx1 = 1:length(totalLabels)
        [fidr,fidc] = find(newLabelImg(:,:) == totalLabels(indx1));
        xmin = min(fidr); xmax = max(fidr); ymin = min(fidc); ymax = max(fidc);
        xsize = xmax - xmin + 1 + offset;
        ysize = ymax - ymin + 1 + offset;
        charImage = false(xsize,ysize);
        for r = 1: length(fidr)
            row = uint8(fidr(r)); col = uint8(fidc(r));
            charImage(fidr(r) - xmin +offset,fidc(r)-ymin+offset) = logical(newLabelImg(row,col));
        end
        labelledImage(indx1).candidate = charImage;
        labelledImage(indx1).size = [xsize;ysize];
    end    
end