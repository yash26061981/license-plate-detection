function newLabelImg = splitConnectedCharacters(labelledImage)

    sz = [labelledImage.size];
    rat = sz(2,:)./sz(1,:);
    mergedIndx = find(rat > 1);
    if isempty(mergedIndx)
        newLabelImg = labelledImage;
    elseif numel(mergedIndx) == 1
        mergedImg = labelledImage(mergedIndx).candidate;
        [~,col] = size(mergedImg);
        smMerged = sum(mergedImg,1);
        [oldId] = find(smMerged < 3 & smMerged > 0);
        id = deleteCornerIds(oldId, col);
        isCut = false;
        if numel(id) == 1
            f1cut = id/col;
            if f1cut <= 0.6 && f1cut >= 0.4 
                mergedImg(:,id) = 0;
                isCut = true;
            end
            if isCut
                newLabelImg = repmat(struct('candidate',[]),numel(labelledImage)+1,1);
                if mergedIndx == 1
                    for indx = 2:numel(labelledImage)
                        newLabelImg(indx+1).candidate = labelledImage(indx).candidate;
                    end
                    newLabelImg(1).candidate = mergedImg(:,1:id);
                    newLabelImg(2).candidate = mergedImg(:,id:end);
                elseif mergedIndx == numel(labelledImage)
                    for indx = 1:(numel(labelledImage)-1)
                        newLabelImg(indx).candidate = labelledImage(indx).candidate;
                    end
                    newLabelImg(end-1).candidate = mergedImg(:,1:id);
                    newLabelImg(end).candidate = mergedImg(:,id:end);
                else
                    for indx = 1:mergedIndx-1
                        newLabelImg(indx).candidate = labelledImage(indx).candidate;
                    end
                    for indx = mergedIndx+1:numel(labelledImage)
                        newLabelImg(indx+1).candidate = labelledImage(indx).candidate;
                    end
                    newLabelImg(mergedIndx).candidate = mergedImg(:,1:id);
                    newLabelImg(mergedIndx+1).candidate = mergedImg(:,id:end);
                end
            else
                newLabelImg = labelledImage;
            end
                
        elseif numel(id) == 2
            f1cut = id(1)/col;
            f2cut = id(2)/col;
            if f1cut <= 0.4 && f1cut >= 0.25
                mergedImg(:,id(1)) = 0;
            end
            if f2cut <= 0.75 && f2cut >= 0.65
                mergedImg(:,id(2)) = 0;
            end
            
            newLabelImg = repmat(struct('candidate',[]),numel(labelledImage)+2,1);
            if mergedIndx == 1
                for indx = 2:numel(labelledImage)
                    newLabelImg(indx+2).candidate = labelledImage(indx).candidate;
                end
                newLabelImg(1).candidate = mergedImg(:,1:id(1));
                newLabelImg(2).candidate = mergedImg(:,id(1):id(2));
                newLabelImg(3).candidate = mergedImg(:,id(2):end);
            elseif mergedIndx == numel(labelledImage)
                for indx = 1:(numel(labelledImage)-1)
                    newLabelImg(indx).candidate = labelledImage(indx).candidate;
                end
                newLabelImg(end-2).candidate = mergedImg(:,1:id(1));
                newLabelImg(end-1).candidate = mergedImg(:,id(1):id(2));
                newLabelImg(end).candidate = mergedImg(:,id(2):end);
            else
                for indx = 1:mergedIndx-1
                    newLabelImg(indx).candidate = labelledImage(indx).candidate;
                end
                for indx = mergedIndx+1:numel(labelledImage)
                    newLabelImg(indx+2).candidate = labelledImage(indx).candidate;
                end
                newLabelImg(mergedIndx).candidate = mergedImg(:,1:id(1));
                newLabelImg(mergedIndx+1).candidate = mergedImg(:,id(1):id(2));
                newLabelImg(mergedIndx+2).candidate = mergedImg(:,id(2):end);
            end
        else
            % do nothing. We are not handling 4 joint character cases
            newLabelImg = labelledImage;
        end        
    else
        % do nothing. We are not handling more than 2 joint character
        % labels
        newLabelImg = labelledImage;
    end   
end

function newId = deleteCornerIds(id, col)
    for indx = 1:numel(id)
        if id(indx) >=col-2 || id(indx) <= 2
            id(indx) = 0;
        end
    end
    nzId = find(id > 0);
    if isempty(nzId)
        newId = [];
    else
        for indx = 1:numel(nzId)
            newId(indx) = id(nzId(indx));
        end
    end
end