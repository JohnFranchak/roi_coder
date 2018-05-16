function varargout = ROI(varargin)
% ROI MATLAB code for ROI.fig
%      ROI, by itself, creates a new ROI or raises the existing
%      singleton*.
%
%      H = ROI returns the handle to a new ROI or the handle to
%      the existing singleton*.
%
%      ROI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROI.M with the given input arguments.
%
%      ROI('Property','Value',...) creates a new ROI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ROI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ROI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ROI

% Last Modified by GUIDE v2.5 16-May-2018 12:35:41


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ROI_OpeningFcn, ...
                   'gui_OutputFcn',  @ROI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before ROI is made visible.
function ROI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ROI (see VARARGIN)

addpath('util');

% Choose default command line output for ROI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ROI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%Fix font sizes for windows 
if strcmp(computer, 'PCWIN64')
    set(handles.next,'FontSize',10)
    set(handles.copy,'FontSize',10)
    set(handles.prev,'FontSize',10)
    set(handles.clearROI,'FontSize',10)
    set(handles.record,'FontSize',10)
    set(handles.loaddata,'FontSize',10)
    set(handles.savedata,'FontSize',10)
    set(handles.openhelp,'FontSize',10)
end

global detector, global frame, global folder_name, global data, global advance, global dragging, global orPos, global nudge, global coded;
dragging = [];
folder_name = 0;
nudge = 1;

%detector = vision.CascadeObjectDetector; %DEFUNCT FACE DETECTION IMPLEMENTATION

% --- Outputs from this function are returned to the command line.
function varargout = ROI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in loaddata.
function loaddata_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
global frame, global folder_name, global data, global advance, global dragging, global orPos, global file_path, global coded, global files;

%Set all UI controls to default values (axes, display boxes, etc)
%Allow for a cancel option where this is all bypassed

folder_name = uigetdir;

if folder_name ~= 0
    
    filestruct = dir(fullfile(folder_name, '*.JPG'));
    if isempty(filestruct)
        filestruct = dir(fullfile(folder_name, '*.jpg'));
    end
    
    mbox = msgbox('Please wait while images are sorted...');
    files = sort_nat({filestruct.name});
    delete(mbox);
    
    if ~isempty(files)
        frame = 1;
        coded = 1:length(files);

        set(handles.frameslider, 'value', 1);
        set(handles.frameslider, 'max', length(files));
        set(handles.frameslider, 'min', 1);
        if length(files) > 30
            set(handles.frameslider, 'SliderStep', [30/length(files) , 150/length(files)]); 
        end

        %Find existing coding files in directory
        coding_files = dir(fullfile(folder_name, '*.csv'));
        file_path = [];
        abort = 0;

        if ~isempty(coding_files) 
            choice = questdlg('Coding files exist for this video. Load existing data?', 'Data files found', 'Yes', 'No', 'Yes');
            if strcmp(choice, 'Yes')
                [file_name, folder_name] = uigetfile({'*.csv', 'CSV files only'}, 'Choose an output file', folder_name);
                file_path = strcat(folder_name, file_name);
                set (handles.filename, 'string',num2str(file_name));
                set (handles.autosave, 'Enable', 'on');
                data = csvread(file_path)';
                if length(data) ~= length(files)
                    msgbox('Image frames do not match coding file! Exit program, reopen, and save to a new output file.');
                    abort = 1;
                end
            else
                data = zeros(6, length(files));
            end
        else
            data = zeros(6, length(files));
        end

        %Write frame numbers to datafile
        if ~abort
            substrs = cellfun(@split_file,files,'UniformOutput',false);
            fnums = cellfun(@get_frame,substrs,'UniformOutput',false);
            data(6,:) = cell2mat(fnums);

            setFrame(frame, handles);
            dragging = [];
            orPos = [];
        end
    end
end
ReleaseFocusFromUI(hObject);

% --- Executes on button press in savedata.
function savedata_Callback(hObject, eventdata, handles)
global frame, global folder_name, global data, global advance, global dragging, global orPos, global file_path;
if folder_name ~= 0
    if isempty(file_path)
            [file_name, save_folder] = uiputfile('*.csv', 'Choose an output file', strcat(folder_name,'/roi.csv'));
            if file_name ~= 0
                file_path = strcat(save_folder, file_name);
                set (handles.filename, 'string',num2str(file_name));
                set (handles.autosave, 'Enable', 'on');
                csvwrite(file_path,data');
            end
    else
        csvwrite(file_path,data');
    end
end
ReleaseFocusFromUI(hObject);

% --- Executes on button press in autosave.
function autosave_Callback(hObject, eventdata, handles)
ReleaseFocusFromUI(hObject);

function dragObject(hObject,eventdata) %#ok<*INUSD>
global frame, global folder_name, global data, global advance, global dragging, global orPos; %#ok<*NUSED>
    dragging = hObject;
    orPos = get(gca,'CurrentPoint');

% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
global frame, global folder_name, global data, global advance, global dragging, global orPos;
    if ~isempty(dragging)
        newPos = get(gca,'CurrentPoint');
        xdiff = newPos(1,1) - orPos(1,1);
        ydiff = newPos(1,2) - orPos(1,2);
        set(dragging,'Position',get(dragging,'Position') + [xdiff ydiff 0 0]);
        orPos = newPos;
        drawnow;
    end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
global frame, global folder_name, global data, global advance, global dragging, global orPos;
    if ~isempty(dragging)
        newPos = get(gca,'CurrentPoint');
        xdiff = newPos(1,1) - orPos(1,1);
        ydiff = newPos(1,2) - orPos(1,2);
        set(dragging,'Position',get(dragging,'Position') + [xdiff ydiff 0 0]);
        c = get(dragging,'Position');
        data(1:5 , frame) = [c(1) c(2)+c(4) c(1)+c(3) c(2) 1];
        dragging = [];
    end
      
function nudgeROI(xdiff, ydiff, handles)
global frame, global folder_name, global data, global advance, global dragging, global orPos;
if data(5,frame) == 1
    data(1,frame) = data(1,frame) + xdiff;
    data(2,frame) = data(2,frame) + ydiff;
    data(3,frame) = data(3,frame) + xdiff;
    data(4,frame) = data(4,frame) + ydiff;
    setFrame(frame, handles);
end

function resizeROI(xsizediff, ysizediff, handles)
global frame, global folder_name, global data, global advance, global dragging, global orPos;
if data(5,frame) == 1
    data(1,frame) = data(1,frame) - xsizediff;
    data(2,frame) = data(2,frame) + ysizediff;
    data(3,frame) = data(3,frame) + xsizediff;
    data(4,frame) = data(4,frame) - ysizediff;
    setFrame(frame, handles);
end
    
% --- Executes on button press in prev.
function prev_Callback(hObject, eventdata, handles) %#ok<*INUSL>
global frame, global folder_name, global data, global advance, global dragging, global orPos;
if folder_name ~= 0
    if frame > 1 
        setFrame(frame - 1, handles);
    end
end
ReleaseFocusFromUI(hObject);

% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
global frame, global folder_name, global data, global advance, global dragging, global orPos;
if folder_name ~= 0
    if frame + 1 < length(data)
        setFrame(frame + 1, handles);
    end
end    
ReleaseFocusFromUI(hObject);

% --- Executes on button press in record.
function record_Callback(hObject, eventdata, handles)
global frame, global folder_name, global data, global advance, global dragging, global orPos, global file_path;
if folder_name ~= 0
    [x, y] = getPoints;
    data(1:5,frame) = [min(x) max(y) max(x) min(y) 1];
    displayROI(handles);
end
if get(handles.autosave, 'Value') == 1
    csvwrite(file_path,data');
end
    ReleaseFocusFromUI(hObject);

% --- Executes on button press in clearROI.
function clearROI_Callback(hObject, eventdata, handles)
global frame, global folder_name, global data, global advance, global dragging, global orPos, global file_path;
if folder_name ~= 0
    data(1:5,frame) = [0 0 0 0 0];
    setFrame(frame, handles);
end
if get(handles.autosave, 'Value') == 1
    csvwrite(file_path,data');
end
ReleaseFocusFromUI(hObject);

% --- Executes on button press in copy.
function copy_Callback(hObject, eventdata, handles)
global frame, global folder_name, global data, global advance, global dragging, global orPos, global file_path;
if folder_name ~= 0
    if frame + 1 < length(data) 
          data(1:5, frame + 1) = data(1:5, frame);
          next_Callback(handles.next, [], handles)
    end
end
if get(handles.autosave, 'Value') == 1
    csvwrite(file_path,data');
end
    ReleaseFocusFromUI(hObject);

function setFrame(newframe, handles)
global frame, global image, global folder_name, global data, global advance, global dragging, global orPos, global file_path, global coded, global files;
frame = newframe;
set (handles.framenum, 'string',num2str(data(6,frame)));
set(handles.frameslider,'Value',frame)
image = imread(get_file_name(),'JPG');
axes(handles.ax1);
imshow(image);
if data(5,frame) == 1 || get(handles.face_detection, 'Value') == 1
    displayROI(handles)
end

%Update Progress Bar
axes(handles.progress)
prog = coded .* data(5,:);
hist(prog(prog ~= 0),500);
axis([0 length(coded) 0 1]);
set(gca, 'YTick', []);
set(gca, 'XTick', []);
hold on
plot([frame frame], [0 1], 'r', 'LineWidth',2);
hold off
drawnow;

function displayROI(handles)
%global detector
global image, global detected_roi, global frame, global folder_name, global data, global advance, global dragging, global orPos, global files;
image = imread(get_file_name(),'JPG');
axes(handles.ax1);
imshow(image);

hold on
if data(5,frame) == 1
    c = data(1:4, frame);
    plot(c(1),c(2),c(3),c(4));
    a = annotation('Rectangle','ButtonDownFcn',@dragObject,'Color','y','LineWidth',1);
    set(a,'Parent',gca);
    set(a,'Position',[min(c(1),c(3)) min(c(2),c(4)) abs(c(1)-c(3)) abs(c(2)-c(4))]);
end
% if get(handles.face_detection, 'Value') == 1
%     detected_roi = step(detector, image);
%     if ~isempty(detected_roi)
%         for i = 1:size(detected_roi,1)
%             if data(5, frame) == 1
%                 if get(a, 'Position') ~= detected_roi(i,:)
%                     b(i) = annotation('Rectangle','ButtonDownFcn',@selectROI, 'Color','g','LineWidth',1);
%                     set(b(i),'Parent',gca);
%                     set(b(i),'Position',detected_roi(i,:));
%                 end
%             else
%                 b(i) = annotation('Rectangle','ButtonDownFcn',@selectROI, 'Color','g','LineWidth',1);
%                 set(b(i),'Parent',gca);
%                 set(b(i),'Position',detected_roi(i,:));
%             end
%         end
%     end
% end
hold off
drawnow update;

% function selectROI(hObject,eventdata)
% global data, global frame, 
% c = get(hObject,'Position');
% set(hObject, 'Color', 'r');
% data(1:5 , frame) = [c(1) c(2)+c(4) c(1)+c(3) c(2) 1];
        
function [x,y] = getPoints
[x,y] = ginput(2);

function playMovie(handles)
global frame, global folder_name, global data, global advance, global dragging, global orPos;
if folder_name ~= 0
    while advance == 1 && frame < length(data)
        setFrame(frame + 1, handles);
        pause(.01);
    end
end

function rewindMovie(handles)
global frame, global folder_name, global data, global advance, global dragging, global orPos;
if folder_name ~= 0
    while advance == 1 && frame > 1
        setFrame(frame - 1, handles);
        pause(.02);
    end
end

% --- Executes on slider movement.
function frameslider_Callback(hObject, eventdata, handles)
global folder_name;
if folder_name ~= 0
    setFrame(int32(get(hObject,'Value')), handles);
end
ReleaseFocusFromUI(hObject);

% --- Executes during object creation, after setting all properties.
function frameslider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
global frame, global folder_name, global data, global advance, global dragging, global orPos, global nudge;
if folder_name ~= 0
    keyPressed = eventdata.Key;    
    if strcmpi(keyPressed,'d')
      next_Callback(handles.next, [], handles)
    elseif strcmpi(keyPressed,'a')
      prev_Callback(handles.prev, [], handles)
    elseif strcmpi(keyPressed,'w')
      record_Callback(handles.record, [], handles)
    elseif strcmpi(keyPressed,'s')
      clearROI_Callback(handles.clearROI, [], handles)
%     elseif strcmpi(keyPressed,'D')
%         setFrame(frame+5, handles);
%     elseif strcmpi(keyPressed,'A')
%         setFrame(frame-5, handles);
    elseif strcmpi(keyPressed,'space')
        if advance == 0;
            advance = 1;
            playMovie(handles);
        else
            advance = 0;
        end
    elseif strcmpi(keyPressed,'r')
        if advance == 0;
            advance = 1;
            rewindMovie(handles);
        else
            advance = 0;
        end      
    elseif strcmpi(keyPressed, 'e')
        copy_Callback(handles.copy, [], handles);
    elseif strcmpi(keyPressed, 'leftarrow')
      nudgeROI(-nudge,0,handles);
    elseif strcmpi(keyPressed, 'rightarrow')
      nudgeROI(nudge,0,handles);
    elseif strcmpi(keyPressed, 'uparrow')
      nudgeROI(0,-nudge,handles);
    elseif strcmpi(keyPressed, 'downarrow')
      nudgeROI(0,nudge,handles);
    elseif strcmpi(keyPressed, 'downarrow')
      nudgeROI(0,nudge,handles);
    elseif strcmpi(keyPressed, 'delete')
      resizeROI(-nudge,-nudge,handles);
    elseif strcmpi(keyPressed, 'end')
      resizeROI(nudge,nudge,handles);
    elseif strcmpi(keyPressed, 'numpad8')
      resizeROI(0,nudge,handles);    
    elseif strcmpi(keyPressed, 'numpad2')
      resizeROI(0,-nudge,handles);  
    elseif strcmpi(keyPressed, 'numpad4')
      resizeROI(-nudge,0,handles);  
    elseif strcmpi(keyPressed, 'numpad6')
      resizeROI(nudge,0,handles);  
    elseif strcmpi(keyPressed, 'pageup')
      if nudge < 10
        nudge = nudge + 1;
        set (handles.stepsize, 'string',strcat(num2str(nudge), ' pixels'));
        drawnow;
      end
    elseif strcmpi(keyPressed, 'pagedown')
      if nudge > 1
          nudge = nudge - 1;
          set (handles.stepsize, 'string',strcat(num2str(nudge), ' pixels'));
          drawnow;
      end
    end
end      

function filename = get_file_name()
global files, global folder_name, global frame;
filename = strcat(folder_name,'/',char(files{frame}));

function ReleaseFocusFromUI(uiObj)
          set(uiObj, 'Enable', 'off');
          drawnow update;
          set(uiObj, 'Enable', 'on');

% --- Executes during object creation, after setting all properties.
function ax1_CreateFcn(hObject, eventdata, handles)
imshow('splash.jpg'); % initial image I want to display
handles.ax1=hObject; % tag for this axis, which I call axesX in this example
guidata(hObject, handles); % update the handles structure for the gui
%set(hObject, 'Units','Pixel')

% --- Executes during object creation, after setting all properties.
function framenum_CreateFcn(hObject, eventdata, handles)
handles.framenum=hObject;
set (hObject, 'string','NA');
drawnow;

% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
handles.filename=hObject;
set (hObject, 'string','NA');
drawnow;

% --- Executes during object creation, after setting all properties.
function stepsize_CreateFcn(hObject, eventdata, handles)
handles.stepsize=hObject;
set (hObject, 'string','1 pixel');
drawnow;

% --- Executes on button press in openhelp.
function openhelp_Callback(hObject, eventdata, handles)
figure;
imshow('splash.jpg'); 
%web('https://github.com/JohnFranchak/roi_coding','-browser');
ReleaseFocusFromUI(hObject);

% --- Executes during object creation, after setting all properties.
function progress_CreateFcn(hObject, eventdata, handles)
handles.progress=hObject; % tag for this axis, which I call axesX in this example
axes(hObject); hist([]);
guidata(hObject, handles); % update the handles structure for the gui
% 
% % --- Executes during object creation, after setting all properties.
% function face_detection_CreateFcn(hObject, eventdata, handles)
% 
% function face_detection_Callback(hObject, eventdata, handles)
% ReleaseFocusFromUI(hObject);
