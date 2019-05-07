function readFrameFromVideoAndSaveInDir()

    global IN_VIDEO_DATA_DIR RESULTS_DIR FILE_NAME
    
    IN_VIDEO_DATA_DIR = [pwd, '\ANPRDATA\scenario1'];
    
    files = dir(IN_VIDEO_DATA_DIR);
    
    sz = numel(files);
    for k = 4:sz
        if ~files(k).isdir
            file = [IN_VIDEO_DATA_DIR, '\', files(k).name]
            vObject = VideoReader(file);
%             totalFrames = vObject.NumberOfFrames;
            fileName = (files(k).name(1:end-4));
            RESULTS_DIR = [pwd, '\ANPRDATA\'];
            if ~exist(fileName,'dir')
                mkdir([RESULTS_DIR fileName]);
            end
            RESULTS_DIR = [RESULTS_DIR fileName '\'];
            for m = 124:138               
                vidFrame = read(vObject,m);
                newFilename = [fileName '_' num2str(m)];
                FILE_NAME = newFilename;
                candidates = localizeSegmentDetectNP(vidFrame);
%                 imwrite(vidFrame,[RESULTS_DIR newFilename],'jpg'); 
                close all 
%                 clc
            end
            
        end
    end

end