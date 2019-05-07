function flippedImg = flipDimension(inImg, dim)

    [row,col] = size(inImg);
    flippedImg = zeros(size(inImg));
    
    if dim == 1 % row wise up down direction
        for r = 1:row
            flippedImg(row - r + 1,:) = inImg(r,:);            
        end
    elseif dim == 2 % col wise left right direction
        for c = 1:col
            flippedImg(:, col - c + 1) = inImg(:,c);
        end
    else
        flippedImg = inImg;
    end
        
    flippedImg = cast(flippedImg, class(inImg));
end