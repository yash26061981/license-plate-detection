function outImg = fineCroppingNP(inImg)

    ver = sum(inImg,2);
    [val1, id1] = findpeaks(ver);
    mval1 = fix(mean(val1)-std(val1)-2);
    [id12,~] = find(val1 >= mval1);
    fvcut1 = id1(id12(1)); %id1(1); %(id12(1));
    fvcut2 = id1(id12(end)); %(id12(end));
    vtemp = inImg(fvcut1:fvcut2,:);
%     figure, imshow(vtemp);
    
    hor = sum(vtemp,1);
    [val2, id2] = findpeaks(hor);
    mval2 = fix(mean(val2)-std(val2)-2);
    [~, id22] = find(val2 >= mval2);
    % figure, plot(hor); grid on;
    fhcut1 = id2(id22(1));
    fhcut2 = id2(id22(end));
    htemp = vtemp(:,fhcut1:fhcut2);
%     figure, imshow(htemp);

    outImg = htemp;
end