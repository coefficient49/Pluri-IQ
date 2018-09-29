function varargout = PluriIQ(varargin)
% PLURIIQ MATLAB code for PluriIQ.fig
%      PLURIIQ, by itself, creates a new PLURIIQ or raises the existing
%      singleton*.
%
%      H = PLURIIQ returns the handle to a new PLURIIQ or the handle to
%      the existing singleton*.
%
%      PLURIIQ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLURIIQ.M with the given input arguments.
%
%      PLURIIQ('Property','Value',...) creates a new PLURIIQ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PluriIQ_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PluriIQ_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PluriIQ

% Last Modified by GUIDE v2.5 16-May-2017 11:46:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @PluriIQ_OpeningFcn, ...
    'gui_OutputFcn',  @PluriIQ_OutputFcn, ...
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


% --- Executes just before PluriIQ is made visible.
function PluriIQ_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PluriIQ (see VARARGIN)

% Choose default command line output for PluriIQ
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

p=cd;
% global DNA
% DNA = false;
set(handles.edit3,'String',p)
set(handles.text9,'String',5)

k=mfilename('fullpath');
sl=find(k=='\');
k = k(1:sl(end));

TBpath=[];
try
    load([k 'TBpath']);
catch
    TBpath=[];
end
try
    TBCN = length(TB.ClassNames);
    set(handles.text10,'String','AlkalinePhosphatase training set loaded')
catch
    set(handles.text10,'String','ImmunoFluorescence training set loaded')
end
if isempty(TBpath)
    set(handles.pushbutton14,'BackgroundColor','red')
    set(handles.edit5,'String','No Algorithm Selected');
else
    set(handles.pushbutton14,'BackgroundColor','green')
    set(handles.edit5,'String',TBpath);
end
% UIWAIT makes PluriIQ wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PluriIQ_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.text9,'String'),'5')
else
%     global n1 p1
    [n1,p1] = uigetfile('.tif');
    set(handles.text3,'String',n1)
    set(handles.edit3,'String',p1)
    cd(p1)
end



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% try
    trainer
    
% catch
%     PluriIQ
% end




function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pushbutton3 as text
%        str2double(get(hObject,'String')) returns contents of pushbutton3 as a double

try
    manualGui
catch
    close all hidden
    mh=msgbox('software error try again');
    waitfor(mh);
    PluriIQ
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global n2 p2
[n2,p2] = uigetfile('.tif');
set(handles.text4,'String',n2)
cd(p2)

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global p1 p2 n1 n2 p m
% try
rb1 = str2num(get(handles.text9,'String'));

p = get(handles.edit3,'String');
n3 = get(handles.edit4,'String');
n1 = get(handles.text3,'String');
n2 = get(handles.text4,'String');
logitest = length(dir([p,n3]));
if logitest == 0
    DNA = false
    m = [{n1} {n2}];
else
    DNA = true;
    m = [{n1} {n2} {n3}];
end
ImageSegmentation(p,m,DNA,rb1)



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global n3 p3 DNA
[n3,p3] = uigetfile('.tif');
% try
%     imread([p3 n3]);
%     DNA= true;
    set(handles.edit4,'String',n3)
%     cd(p3)
% catch
%     DNA  = false;
% end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    autoRunAll
catch
    PluriIQ
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton10,'BackgroundColor','green');
set(handles.pushbutton11,'BackgroundColor',[0.94 0.94 0.94]);
set(handles.text9,'String',0);
set(handles.pushbutton1,'String','Phase Image')
set(handles.pushbutton5,'String','Alkaline Phosphatase Image')
% s=get(handles.text9,'String')
% str2num(s)

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton11,'BackgroundColor','green');
set(handles.pushbutton10,'BackgroundColor',[0.94 0.94 0.94]);
set(handles.text9,'String',1);
set(handles.pushbutton1,'String','Cytoplasm Image')
set(handles.pushbutton5,'String','Pluripotent Marker Image')



% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    dataComparer
catch
    PluriIQ
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[name,path]=uigetfile('.mat');
k=mfilename('fullpath');
sl=find(k=='\');
k = k(1:sl(end));
TBpath=[path name];
set(handles.edit5,'string',[path name])
save([k 'TBpath.mat' ],'TBpath')

load(TBpath);
try
    TBCN = length(TB.ClassNames);
    set(handles.text10,'String','AlkalinePhosphatase training set loaded')
catch
    set(handles.text10,'String','ImmunoFluorescence training set loaded')
end
if isempty(TBpath)
    set(handles.pushbutton14,'BackgroundColor','red')
    set(handles.edit5,'String','No Algorithm Selected');
else
    set(handles.pushbutton14,'BackgroundColor','green')
    set(handles.edit5,'String',TBpath);
end


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
