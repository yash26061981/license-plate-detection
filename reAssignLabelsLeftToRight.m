function newLabelImg = reAssignLabelsLeftToRight(labelImg)
    
    totalLabels = unique(labelImg(:,:));
    if totalLabels(1) == 0
        totalLabels = totalLabels(2:end);
    end
    
    [row, ~] = size(labelImg);
    midScanLine = labelImg(fix(row/2),:);    
    [~, id] = find(midScanLine > 0);
    
    newLabelImg = labelImg;
    f1time = true;
    doneLabel = [];
    labId = 1;
    for u1 = 1:length(id)
        if f1time
            doneLabel = [doneLabel midScanLine(id(u1))];
            f1time = false;
            if ~ismember(labId,totalLabels) 
                [fidr,fidc] = find(labelImg(:,:) == midScanLine(id(u1)));
                for r = 1: length(fidr)
                    row = uint8(fidr(r)); col = uint8(fidc(r));
                    newLabelImg(row,col) = labId;
                end
            else
                [fidr,fidc] = find(labelImg(:,:) == midScanLine(id(u1)));
                [fidr1,fidc1] = find(labelImg(:,:) == labId);
                for r = 1: length(fidr)
                    row = uint8(fidr(r)); col = uint8(fidc(r));
                    newLabelImg(row,col) = labId;
                end
                for r = 1: length(fidr1)
                    row = uint8(fidr1(r)); col = uint8(fidc1(r));
                    newLabelImg(row,col) = midScanLine(id(u1));
                end
            end
            labId = labId + 1;
        else
            if ~ismember(midScanLine(id(u1)),doneLabel)
                doneLabel = [doneLabel midScanLine(id(u1))];
                if ~ismember(labId,totalLabels) 
                    [fidr,fidc] = find(labelImg(:,:) == midScanLine(id(u1)));
                    for r = 1: length(fidr)
                        row = uint8(fidr(r)); col = uint8(fidc(r));
                        newLabelImg(row,col) = labId;
                    end
                elseif ismember(labId,doneLabel)
                    [fidr,fidc] = find(labelImg(:,:) == midScanLine(id(u1)));
                    for r = 1: length(fidr)
                        row = uint8(fidr(r)); col = uint8(fidc(r));
                        newLabelImg(row,col) = labId;
                    end
                else
                    [fidr,fidc] = find(labelImg(:,:) == midScanLine(id(u1)));
                    [fidr1,fidc1] = find(labelImg(:,:) == labId);
                    for r = 1: length(fidr)
                        row = uint8(fidr(r)); col = uint8(fidc(r));
                        newLabelImg(row,col) = labId;
                    end
                    for r = 1: length(fidr1)
                        row = uint8(fidr1(r)); col = uint8(fidc1(r));
                        newLabelImg(row,col) = midScanLine(id(u1));
                    end
                end
                labId = labId + 1;
            end            
        end
    end
end