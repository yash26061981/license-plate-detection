function labelImg = mergeConnectedAssignOneLabel(oldPair, labelImg)
    allpair = oldPair;
%     allpair(:,140) = [5;6]; allpair(:,141) = [6;7];
%     newPair = allpair;
    ind = 1;
    ulabel1 = unique(allpair(1,:));
    for indx1 = 1:length(ulabel1)
        uind1 = allpair(1,:) == ulabel1(indx1);
        uind2 = unique(allpair(2,uind1));
        if indx1 == 1
            set(ind).info = [ulabel1(indx1) uind2];
            ind = ind + 1;
        else
            if ismember(ulabel1(indx1), set(ind-1).info)
                set(ind-1).info = [set(ind-1).info ulabel1(indx1) uind2];
            else
                set(ind).info = [ulabel1(indx1) uind2];
                ind = ind + 1;
            end
        end
    end
    for indx = 1:numel(set)
        f1set = set(indx).info;
        uid = unique(f1set);
        f1lab = uid(1);
        for indx1 = 2:length(uid)
            [fidr,fidc] = find(labelImg(:,:) == uid(indx1));
            for indx2 = 1:length(fidr)
                labelImg(fidr(indx2),fidc(indx2)) = f1lab;
            end
        end        
    end
end