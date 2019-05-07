function slidingWindow = localiseNP_Level1(edgeImage, bwImage)    
    global MIN_WNDW_H MAX_WNDW_H ASPCT_R ED_THRESH1 TRANS_STEP SIZE_STEP AVG_INTENSITY...
        MIN_ASPCT_R MAX_ASPCT_R
    
    
%     minWindowWidth = MIN_WNDW_H * ASPCT_R;
%     maxWindowWidth = MAX_WNDW_H * ASPCT_R;

    [row,col] = size(edgeImage);
    integralImage1 = computeIntegratedImage(edgeImage);
    cordStruct = struct('minX',0,'maxX',0,'minY',0,'maxY',0,'result','false','ed1',0,'ed2',0,'width',0,...
        'height',0,'edMin',0, 'avgIntensity',0);
    slidingWindow = repmat(cordStruct,1,1);
    winHRange = MIN_WNDW_H:fix(SIZE_STEP*MIN_WNDW_H/100):MAX_WNDW_H;
%     winWRange = winHRange * ASPCT_R; %minWindowWidth:fix(SIZE_STEP*minWindowWidth/100):maxWindowWidth;
    id  = 1;
    for aspectR = MIN_ASPCT_R:MAX_ASPCT_R
        winWRange = winHRange * aspectR; %minWindowWidth:fix(SIZE_STEP*minWindowWidth/100):maxWindowWidth;
        for indx1 = 1:numel(winHRange)
            winH = winHRange(indx1);
            winW = winWRange(indx1);
            stepR = 1:fix(TRANS_STEP*winH/100):row-winH;
            stepC = 1:fix(TRANS_STEP*winW/100):col-winW;
            for r = stepR
                for c = stepC
                    slidingWindow(id).minX = r;
                    slidingWindow(id).maxX = r+winH-1;
                    slidingWindow(id).minY = c;
                    slidingWindow(id).maxY = c+winW-1;

                    slidingWindow(id).ed1 = getDensity(slidingWindow(id), integralImage1);
                    slidingWindow(id).avgIntensity = getAverageIntesnityOfWindow(slidingWindow(id), bwImage);
                    if (slidingWindow(id).ed1 >= ED_THRESH1) && (slidingWindow(id).avgIntensity > AVG_INTENSITY)
                        slidingWindow(id).result = true;
                        slidingWindow(id).height = slidingWindow(id).maxX - slidingWindow(id).minX + 1 ;
                        slidingWindow(id).width = slidingWindow(id).maxY - slidingWindow(id).minY + 1;
                        id  = id + 1;
                    end
                end
            end
        end
    end
    slidingWindow(id) = [];
end