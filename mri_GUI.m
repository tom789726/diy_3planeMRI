function varargout = mri_GUI(varargin)
% MRI_GUI MATLAB code for mri_GUI.fig
%      MRI_GUI, by itself, creates a new MRI_GUI or raises the existing
%      singleton*.
%
%      H = MRI_GUI returns the handle to a new MRI_GUI or the handle to
%      the existing singleton*.
%
%      MRI_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MRI_GUI.M with the given input arguments.
%
%      MRI_GUI('Property','Value',...) creates a new MRI_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mri_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mri_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mri_GUI

% Last Modified by GUIDE v2.5 05-Mar-2020 00:22:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mri_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @mri_GUI_OutputFcn, ...
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


% --- Executes just before mri_GUI is made visible.
function mri_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mri_GUI (see VARARGIN)

% Choose default command line output for mri_GUI
handles.output = hObject;

% TYPE CODE HERE: 
set(handles.original_img_axes,'XTick',[],'YTick',[]);
set(handles.transv_axes,'XTick',[],'YTick',[]);
set(handles.coronal_axes,'XTick',[],'YTick',[]);

% Save ButtonDownFcn first (因為每次plot完BDF會比人洗走)
handles.BtnDown_axes1 = @(hObject,eventdata)mri_GUI('original_img_axes_ButtonDownFcn',hObject,eventdata,guidata(hObject));
% 呢行@後面應該係等於將BtnDown_axes1 變成一舊 function (直接用一行寫完function的input/output arguments)
% i.e. 模擬本身的ButtonDownFcn function內容
handles.BtnDown_axes2 = @(hObject,eventdata)mri_GUI('transv_axes_ButtonDownFcn',hObject,eventdata,guidata(hObject));
handles.BtnDown_axes3 = @(hObject,eventdata)mri_GUI('coronal_axes_ButtonDownFcn',hObject,eventdata,guidata(hObject));


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mri_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mri_GUI_OutputFcn(~, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button1.
function button1_Callback(hObject, eventdata, handles)
% hObject    handle to button1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% BUTTON CLICKED DO THIS: 

% clear all; clc; 
% 唔用得clear all,好似會clear埋d handles

set(handles.edit1, 'String', 'Loading');

% path_header = 'C:\Users\Tom\Documents\MATLAB\mri\IM-0001-';
% info_slice1 = dicominfo('C:\Users\Tom\Documents\MATLAB\mri\IM-0001-0001.dcm');

path_header = 'C:\Users\Tom\Documents\MATLAB\side_DICOM讀MRI\mri\IM-0001-';
info_slice1 = dicominfo('C:\Users\Tom\Documents\MATLAB\side_DICOM讀MRI\mri\IM-0001-0001.dcm');

siz = [
    info_slice1.Width 
    info_slice1.Height 
    info_slice1.ImagesInAcquisition
    ];

for i = 1:siz(3)
    if (i<=9)
        path_img(i,:) = strcat(path_header,'000',num2str(i),'.dcm');
    end
    if (i>=10 && i<=99)
        path_img(i,:) = strcat(path_header,'00',num2str(i),'.dcm');
    end
    if (i>=100 && i<=999)
        path_img(i,:) = strcat(path_header,'0',num2str(i),'.dcm');
    end    
    
    % Dicom Read
    path = path_img(i,:);
    img(:,:,i) = dicomread(path);    
end % for loop end

% Separate 3 planes
for i = 1:siz(3)
    for j = 1:siz(1) 
        img_cr(:,i,j) = img(:,j,i); 
        img_tr(:,i,j) = img(j,:,i);
    end
%   照理講應該coronal同transverse plane用不同for loop，不過反正都係256x256，所以無所謂
%   for j = 1:siz(2)
%       img_cr(:,i,j) = img(j,:,i);
%   end
end


% Image Display (Version 1)
% imagesc(img(:,:,80), 'Parent', handles.original_img_axes );
% title('Sagittal Plane');
% set(handles.original_img_axes,'XTick',[],'YTick',[]);
% colormap gray;
% imagesc(img_tr(:,:,120), 'Parent', handles.coronal_axes );
% title('Coronal Plane');
% set(handles.coronal_axes,'XTick',[],'YTick',[]);
% colormap gray;
% imagesc(img_cr(:,:,120), 'Parent', handles.transv_axes );
% title('Transverse Plane');
% set(handles.transv_axes,'XTick',[],'YTick',[]);
% colormap gray;

set(handles.edit1, 'String', 'Image Loaded, Display on above');

% Image Display (Version 2, with ButtonDownFcn);
% 畫完圖要將ButtonDownFcn set番正常
axes(handles.original_img_axes); % Move Focus to this axes
image_to_display = img(:,:,80);
handles.img_current_1 = imshow(image_to_display,[]);
title('Sagittal Plane');
set(handles.img_current_1, 'ButtonDownFcn', handles.BtnDown_axes1);

axes(handles.transv_axes);
image_to_display = img_tr(:,:,120);
handles.img_current_2 = imshow(image_to_display,[]);
title('Transverse Plane');
set(handles.img_current_2, 'ButtonDownFcn', handles.BtnDown_axes2);

axes(handles.coronal_axes);
image_to_display = img_cr(:,:,120);
handles.img_current_3 = imshow(image_to_display,[]);
title('Coronal Plane');
set(handles.img_current_3, 'ButtonDownFcn', handles.BtnDown_axes3);


% Passing Handles
handles.img  = img;
handles.img_cr = img_cr;
handles.img_tr = img_tr;
handles.siz = siz;
guidata(hObject,handles);
data = guidata(hObject) % data任意名都ok

    


% --- Executes on mouse press over axes background.
function original_img_axes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to original_img_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


pt = get(gca,'currentpoint');
disp(pt);
% pt2 = get(handles.original_img_axes,'currentpoint');
% disp(pt2);

set(handles.edit1, 'String', 'click detected (Sagittal)');

pt_cr = round(pt(1,1));
pt_tr = round(pt(1,2));
disp(pt_cr);
disp(pt_tr);

% Image Display (Refresh Plot)
axes(handles.transv_axes);
image_to_display = handles.img_tr(:,:,pt_tr);
handles.img_current_2 = imshow(image_to_display,[]);
title('Transverse Plane');
set(handles.img_current_2, 'ButtonDownFcn', handles.BtnDown_axes2);

axes(handles.coronal_axes);
image_to_display = handles.img_cr(:,:,pt_cr);
handles.img_current_3 = imshow(image_to_display,[]);
title('Coronal Plane');
set(handles.img_current_3, 'ButtonDownFcn', handles.BtnDown_axes3);

guidata(hObject,handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over button1.
function button1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to button1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function coronal_axes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to coronal_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pt = get(gca,'currentpoint');
% disp(pt);

set(handles.edit1, 'String', 'click detected (Coronal)');

pt_sag = round(pt(1,1));
pt_tr = round(pt(1,2));
% disp(pt_sag);
% disp(pt_tr);

% Image Display (Refresh Plot)
axes(handles.original_img_axes); % Move Focus to this axes
image_to_display = handles.img(:,:,pt_sag);
handles.img_current_1 = imshow(image_to_display,[]);
title('Sagittal Plane');
set(handles.img_current_1, 'ButtonDownFcn', handles.BtnDown_axes1);

axes(handles.transv_axes);
image_to_display = handles.img_tr(:,:,pt_tr);
handles.img_current_2 = imshow(image_to_display,[]);
title('Transverse Plane');
set(handles.img_current_2, 'ButtonDownFcn', handles.BtnDown_axes2);

guidata(hObject,handles);



% --- Executes on mouse press over axes background.
function transv_axes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to transv_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pt = get(gca,'currentpoint');
disp(pt);

set(handles.edit1, 'String', 'click detected (Transverse)');

pt_sag = round(pt(1,1));
pt_cr = round(pt(1,2));
% disp(pt_sag);
% disp(pt_tr);

% Image Display (Refresh Plot)
axes(handles.original_img_axes); % Move Focus to this axes
image_to_display = handles.img(:,:,pt_sag);
handles.img_current_1 = imshow(image_to_display,[]);
title('Sagittal Plane');
set(handles.img_current_1, 'ButtonDownFcn', handles.BtnDown_axes1);

axes(handles.coronal_axes);
image_to_display = handles.img_cr(:,:,pt_cr);
handles.img_current_3 = imshow(image_to_display,[]);
title('Coronal Plane');
set(handles.img_current_3, 'ButtonDownFcn', handles.BtnDown_axes3);

guidata(hObject,handles);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
