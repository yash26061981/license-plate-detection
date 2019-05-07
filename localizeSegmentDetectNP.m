function candidates = localizeSegmentDetectNP(inImage)
    global MIN_WNDW_H MAX_WNDW_H ASPCT_R ED_THRESH1 ED_CUTOFF MIN_THRESH1 AVG_INTENSITY SUBWINDOW_THRESHOLD...
        MAX_THRESH1 MIN_THRESH2 MAX_THRESH2 TRANS_STEP SIZE_STEP FINE_TUNING ED_MINTHRESH ED_DIFFMAXTHRESH ...
        PEAK_THRESHOLD MIN_PEAK MAX_PEAK ASPECT_THTRESHOLD USE_ADAPTIVE_CLUSTER MIN_LABEL_AR...
        USE_NIBLACK FINETUNING_LEVEL2 MIN_NO_PIXELS MIN_EDGE_DENSITY MIN_ASPCT_R MAX_ASPCT_R MIN_LABEL_AREA...
        RESULTS_DIR FILE_NAME DRANGE
    
    DRANGE = 100;
    FINETUNING_LEVEL2 = true;
    USE_NIBLACK = true;
    USE_ADAPTIVE_CLUSTER = true;
    MIN_LABEL_AR = 0.4;
    MIN_LABEL_AREA = 10;
    MIN_EDGE_DENSITY = 0.065;
    MIN_NO_PIXELS = 500;
    FINE_TUNING = true;
    MIN_WNDW_H = 20;
    MAX_WNDW_H = 100;
    ASPCT_R = 5;
    MIN_ASPCT_R = 5;
    MAX_ASPCT_R = 8;
    ED_THRESH1 = 0.15;
    ED_CUTOFF = 0.1;
    MIN_THRESH1 = 0.101;
    MAX_THRESH1 = 0.063;
    MIN_THRESH2 = 0.085;
    MAX_THRESH2 = 0.095;
    AVG_INTENSITY = 100;
    SUBWINDOW_THRESHOLD = 5;
    PEAK_THRESHOLD = 0.7;
    MIN_PEAK = 9;
    MAX_PEAK = 40;
    ASPECT_THTRESHOLD = 2.5;
    ED_MINTHRESH = 0.015; %0.3;
    ED_DIFFMAXTHRESH = 0.5; %0.4;
    
    TRANS_STEP = 15;
    SIZE_STEP = 40;
    
    %%% gray image conversion
    [r, c, ~] = size(inImage);
    if r==720 && c == 1280
        [inImage, ~] = imresize(inImage,0.6250);
    end
    imshow(inImage);
    bwImage1 = rgb2gray(inImage);
    bwImage1 = histeq(bwImage1);
    bwImage = bwImage1; %(fix(r/2):end,:);

    %%% gaussian blurring the image.
    if 0
        PSF = fspecial('gaussian',3,3);
        bwImageFiltered = imfilter(bwImage,PSF,'conv');
        imshow(bwImageFiltered);
    else
        bwImageFiltered = bwImage;
    end
    
    %%% apply median filter on the image 
    if 0
        filteredImage = medfilt2(bwImageFiltered,[5 5]);
        imshow(filteredImage);
    else
        filteredImage = bwImageFiltered;
    end

    if 0
        se = strel('rectangle',[2 8]);
        I = imbothat(filteredImage,se);
        imshow(I);
    else
        I = filteredImage;
    end
    candidates = [];
    BW = edge(I,'Sobel','vertical');
%     figure; imshow(BW);

    slidingWindow1 = localiseNP_Level1(BW,bwImage);
    patchedImage1 = bwImage;
    szP = numel(slidingWindow1);
    for k = 1: szP
        xMin = slidingWindow1(k).minX;
        xMax = slidingWindow1(k).maxX;
        yMin = slidingWindow1(k).minY;
        yMax = slidingWindow1(k).maxY;

        patchedImage1(xMin:xMax,yMin:yMax) = ...
            patchedImage1(xMin:xMax,yMin:yMax) + 100;
    end
    figure; imshow(patchedImage1);
    if isempty(slidingWindow1)
        candidates = [];
    else
        outImage = clusteredSlidingWindow_ConnectedImages(bwImage, slidingWindow1, inImage);
        szC = numel(outImage);
        outImage1 = fineTuneClusteredImage(outImage);
        szF = numel(outImage1);
        fprintf('Total Patches = %d, Clustered Patches = %d, Fine Tuned Patches = %d\n', szP, szC, szF);
        pindx = 0;
        for id= 1:szF
            outImg = outImage1(id).image;
%             figure; imshow(outImg);
            newFilename = [FILE_NAME '_' num2str(id) '.jpg'];
            labelledImage1 = findConnectedComponents(outImg, newFilename);
            if numel(labelledImage1) > 0
                labelledImage = splitConnectedCharacters(labelledImage1);
                szConn = numel(labelledImage)
            else
                szConn = 0
            end
            if szConn <= 25 && szConn >=9
                pindx = pindx + 1;
                figure; 
                for idx = 1:szConn
                    subplot(9,3,idx); imshow(labelledImage(idx).candidate);
                end
                figure; 
                for idx = 1:szConn
                    resImg = imresize(labelledImage(idx).candidate,[30 20]);
                    bwThinned = doThinningOperation(resImg);
                    candidates(pindx).candidate(idx).thinImg = bwThinned;
                    subplot(9,3,idx); imshow(bwThinned);
                end
            end
        end
    end
end