function outImage = fineTuneClusteredImage(inImage)
    global MIN_EDGE_DENSITY ASPECT_THTRESHOLD
    outImage = inImage;
    sz = numel(inImage);
    indx = true(1,sz);
    for id = 1:sz
        tempImg = inImage(id).image;
        imEdge = edge(tempImg,'Sobel','vertical');
        [row,col] = size(imEdge);        
        ed = sum(sum(imEdge))/(row*col);
        
        if ed < MIN_EDGE_DENSITY || (col/row) < ASPECT_THTRESHOLD
            indx(id) = false;
        end
        fprintf('Edge Density = %f\n', ed);
    end
    outImage(~indx) = [];  
    szF = numel(outImage);
    for id= 1:szF
%         img = outImage(id).image;
        [deskewedImg, skewAngle] = findSkew_CorrectSkew(outImage(id).image);
        if 0
            img = contrast(deskewedImg);
        else
            img = deskewedImg;
        end
        str = sprintf('Skewed Patch with Angle = %f',skewAngle);
        figure; 
        subplot(3,1,1);imshow(outImage(id).rgbImage);
        xlabel('Original Cropped Image');
        subplot(3,1,2);imshow(outImage(id).image);
        xlabel(str);
        subplot(3,1,3); imshow(img);
        xlabel('Deskewed Patch');
        choppedImg = fineCroppingNP(img);
        outImage(id).image = choppedImg;
    end
            
end
