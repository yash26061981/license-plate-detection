function outImage = clusteredSlidingWindow_Images(edgeImage, slidingWindow,rgbImage)
    global ASPECT_THTRESHOLD USE_ADAPTIVE_CLUSTER
    
    newSlidingWindow = slidingWindow;
    sz = numel(newSlidingWindow);
    info = struct('indx',0,'Xcentroid',0,'Ycentroid',0, 'label',0);
    slidingSt = repmat(info,sz,1);
    [~,col] = size(edgeImage);
    
    for indx = 1:sz
        xMin = newSlidingWindow(indx).minX;
        xMax = newSlidingWindow(indx).maxX;
        yMin = newSlidingWindow(indx).minY;
        yMax = newSlidingWindow(indx).maxY;
        
        xcentroid = (xMax+xMin)/2;
        ycentroid = (yMax+yMin)/2;
        slidingSt(indx).indx = indx;
        slidingSt(indx).Xcentroid = xcentroid;
        slidingSt(indx).Ycentroid = ycentroid; 
    end
    xid = [slidingSt.Xcentroid]; yid = [slidingSt.Ycentroid];
    uyid = unique(yid);
    if USE_ADAPTIVE_CLUSTER
        if 1
            clubInst = get_clubbed_one_zeros(uyid(2:end)-uyid(1:end-1));
%         uy1 = unique(uyid(2:end)-uyid(1:end-1));
            no_cluster = numel(clubInst); %length(uy1);
        else
            u1 = uyid(2:end)-uyid(1:end-1);
            u2 = u1(2:end)-u1(1:end-1);
            u3 = find(u2>0);
            no_cluster = numel(u3); %length(uy1);
        end
    else
        no = 0;
        for c = 100:100:col
           clust = length(find((uyid < c) & (uyid > c-100)));
           if clust
               no = no + 1;
           end
        end
        no_cluster = no;
    end
%         maxyid = max(uyid); minyid = min(uyid);
%     no_cluster = 12;
%     if (maxyid-minyid) > CLUSTER_THTRESHOLD
%         no_cluster = 2;
%     end
    index = [xid; yid]';
    idx = kmeans(index,no_cluster+1','Distance','cosine');
    for indx = 1:sz
        slidingSt(indx).label = idx(indx);
    end
%     tempImage = false(r,c,no_cluster);
    id = 0;
    outImage = [];
    for clust = 1:no_cluster
        minx = 1000; maxx = 0; miny = 1000; maxy = 0;
        for indx = 1:sz
            xMin = newSlidingWindow(indx).minX;
            xMax = newSlidingWindow(indx).maxX;
            yMin = newSlidingWindow(indx).minY;
            yMax = newSlidingWindow(indx).maxY;

            if (slidingSt(indx).label == clust)
                if xMin < minx
                    minx = xMin;
                end
                if xMax > maxx
                    maxx = xMax;
                end
                if yMin < miny
                    miny = yMin;
                end
                if yMax > maxy
                    maxy = yMax;
                end
            end
        end
        xlen = length(minx:maxx); ylen = length(miny:maxy);
        if ylen >= xlen * ASPECT_THTRESHOLD
            id = id + 1;
            tempImage = edgeImage(minx:maxx, miny:maxy);
            rgbtempImage = rgbImage(minx:maxx, miny:maxy,:);
            outImage(id).image = tempImage;
            outImage(id).rgbimage = rgbtempImage;
        end
    end    
end
