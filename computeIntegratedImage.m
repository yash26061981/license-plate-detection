function integralImage = computeIntegratedImage(edgeImage)
    [row,col] = size(edgeImage);
    rSum = (zeros(row,col));
    integralImage = (zeros(row,col));
    
    for r = 1:row
        for c = 1:col
            if edgeImage(r,c)
                toAdd = 1;
            else
                toAdd = 0;
            end
            if c == 1
                rSum(r,c) = rSum(r,c) + toAdd;
            else
                rSum(r,c) = rSum(r,c-1) + toAdd;
            end
            if r == 1
                integralImage(r,c) = integralImage(r,c) + rSum(r,c);
            else
                integralImage(r,c) = integralImage(r-1,c) + rSum(r,c);
            end
        end
    end

end