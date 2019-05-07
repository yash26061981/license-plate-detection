function avgIntensity = getAverageIntesnityOfWindow(slidingWindow, bwImage)

    xMin = slidingWindow.minX;
    xMax = slidingWindow.maxX;
    yMin = slidingWindow.minY;
    yMax = slidingWindow.maxY;
    
    intensity = 0;
    totalArea = (xMax - xMin + 1) * (yMax - yMin + 1);
    for x = xMin:xMax
        for y = yMin:yMax
            intensity = intensity + (double(bwImage(x,y))/totalArea);
        end
    end
%     totalArea = (xMax - xMin + 1) * (yMax - yMin + 1);
    avgIntensity = intensity; % / totalArea;
end