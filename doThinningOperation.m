function bwThinned = doThinningOperation(bwImg)

    flag = 1;
    [row, col] = size(bwImg);
    bwThinned = bwImg;
    bwDeleted = ones(row, col);
    while flag
        flag = 0;
        for i=2:row-1
            for j = 2:col-1
                P = [bwThinned(i,j) bwThinned(i-1,j) bwThinned(i-1,j+1) bwThinned(i,j+1) bwThinned(i+1,j+1) bwThinned(i+1,j) bwThinned(i+1,j-1) bwThinned(i,j-1) bwThinned(i-1,j-1) bwThinned(i-1,j)];
                if (bwThinned(i,j) == 1 &&  sum(P(2:end-1))<=6 && sum(P(2:end-1)) >=2 && P(2)*P(4)*P(6)==0 && P(4)*P(6)*P(8)==0)
                    A = 0;
                    for k = 2:size(P,2)-1
                        if P(k) == 0 && P(k+1)==1
                            A = A+1;
                        end
                    end
                    if (A==1)
                        bwDeleted(i,j)=0;
                        flag = 1;
                    end
                end
            end
        end
        bwThinned = bwThinned.*bwDeleted;
        
        for i=2:row-1
            for j = 2:col-1
                P = [bwThinned(i,j) bwThinned(i-1,j) bwThinned(i-1,j+1) bwThinned(i,j+1) bwThinned(i+1,j+1) bwThinned(i+1,j) bwThinned(i+1,j-1) bwThinned(i,j-1) bwThinned(i-1,j-1) bwThinned(i-1,j)];
                if (bwThinned(i,j) == 1 && sum(P(2:end-1))<=6 && sum(P(2:end-1)) >=2 && P(2)*P(4)*P(8)==0 && P(2)*P(6)*P(8)==0)
                    A = 0;
                    for k = 2:size(P,2)-1
                        if P(k) == 0 && P(k+1)==1
                            A = A+1;
                        end
                    end
                    if (A==1)
                        bwDeleted(i,j)=0;
                        flag = 1;
                    end
                end
            end
        end
        bwThinned = bwThinned.*bwDeleted;
    end
end