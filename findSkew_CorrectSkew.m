function [deskewedImg, skewAngle] = findSkew_CorrectSkew(grayskewedImg)
    
%     skewedImg = rgb2gray(rgbskewedImg);
%     grayskewedImg = flipDimension(grayskewedImg, 1);
    skewedImg = flipDimension(grayskewedImg, 1);
    [row, col]=size(skewedImg);
    edImage = edge(skewedImg,'canny');
%     figure; imshow(edImage);
%     edImage1 = flipud(edImage);
%     edImage = flipDimension(edImage, 1);
    rhoResolution = 1;
    diagonal = sqrt((row - 1)^2 + (col - 1)^2);
    nrho = 2*(ceil(diagonal/rhoResolution)) + 1; 
 
% rho values range from -diagonal to diagonal, where 
%     diagonal = RhoResolution*ceil(D/RhoResolution);
    theta = (-90:1:89);    
    houghTable= zeros(nrho,  numel(theta));
    for i=1:row
        for j=1:col
            if(edImage(i,j)==1)
                for ang = 1:numel(theta)
                    rho = fix(diagonal + i*cos((theta(ang)*pi/180)) + j*sin((theta(ang)*pi/180))) + 1;
                    houghTable(rho,ang)=houghTable(rho,ang)+1;
                end
            end
        end
    end
    [~,id] = max(max(houghTable));
    skew = theta(id);
    str = sprintf('Skewed Angle is %f',skew);
    disp(str)
    if skew < 0
        deskewAngle = skew + (2*abs(skew) -1);
    elseif skew > 0
        deskewAngle = skew - (2*abs(skew) -1);
    else
        deskewAngle = 0;
    end
    deskewedImg = imrotate(skewedImg,deskewAngle,'bilinear','crop');
    deskewedImg = flipDimension(deskewedImg, 1);
    skewAngle = skew;
end