function extract_frames()
%Prompts the user to choose a video file, and exports JPG images to a
%directory called 'frame_export' within the parent directory

[file_name, folder_name] = uigetfile({'*.mov', 'Quicktime files only'}, 'Choose a video file');

mov = VideoReader(strcat(folder_name, file_name));
k = 1;

if ~exist(strcat(folder_name,'frame_export'),'dir')
    mkdir(folder_name,'frame_export');
end
filepath = strcat(folder_name, 'frame_export');

h = waitbar(0,'Exporting frames...', 'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)
steps = mov.Duration * mov.FrameRate;

while hasFrame(mov)
    if getappdata(h,'canceling')
        break
    end
    
    waitbar(k / steps)
    imwrite(readFrame(mov), strcat(filepath,'/', num2str(k), '.jpg'), 'JPG')
    k = k + 1;
end
if getappdata(h,'canceling')
    disp('frame export canceled')
else
    disp('frame export complete')
end

delete(h)

