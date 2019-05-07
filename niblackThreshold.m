function outImg = niblackThreshold(inImage, window)
    global DRANGE
    dImage = double(inImage);
    mean = averagefilter(dImage, window);

    meanSquare = averagefilter(dImage.^2, window);
    deviation = (meanSquare - mean.^2).^0.5;

    outImg = false(size(dImage));
%     dRange = 100; % 70
    const_K = 0.5;
    minGray = min(min(dImage));
%     scorefactor = mean .* (1 - const_K * (1 - deviation/dRange));
    scorefactor = (1 - const_K) .* mean + const_K * minGray + const_K .* (deviation/DRANGE) .* (mean - minGray);
    outImg(dImage >= scorefactor) = true;
%     outImg = cast(outImg, class(inImage));

end

function avgImage = averagefilter(image, window)

    m = window(1);
    n = window(2);

    if ~mod(m,2) 
        m = m-1; 
    end
    if ~mod(n,2) 
        n = n-1; 
    end

    [rows, columns] = size(image);   % size of the image

    imageP  = padarray(image, [(m+1)/2 (n+1)/2], 'replicate', 'pre');
    imagePP = padarray(imageP, [(m-1)/2 (n-1)/2], 'replicate', 'post');

    imageD = double(imagePP);
    t = cumsum(cumsum(imageD),2);

    imageI = t(1+m:rows+m, 1+n:columns+n) + t(1:rows, 1:columns)...
        - t(1+m:rows+m, 1:columns) - t(1:rows, 1+n:columns+n);

    avgImage = imageI/(m*n);

    avgImage = cast(avgImage, class(image));
end