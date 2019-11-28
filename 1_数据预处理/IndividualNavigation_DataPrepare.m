function varargout = IndividualNavigation_DataPrepare(varargin)
% INDIVIDUALNAVIGATION_DATAPREPARE MATLAB code for IndividualNavigation_DataPrepare.fig
%      INDIVIDUALNAVIGATION_DATAPREPARE, by itself, creates a new INDIVIDUALNAVIGATION_DATAPREPARE or raises the existing
%      singleton*.
%
%      H = INDIVIDUALNAVIGATION_DATAPREPARE returns the handle to a new INDIVIDUALNAVIGATION_DATAPREPARE or the handle to
%      the existing singleton*.
%
%      INDIVIDUALNAVIGATION_DATAPREPARE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INDIVIDUALNAVIGATION_DATAPREPARE.M with the given input arguments.
%
%      INDIVIDUALNAVIGATION_DATAPREPARE('Property','Value',...) creates a new INDIVIDUALNAVIGATION_DATAPREPARE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IndividualNavigation_DataPrepare_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IndividualNavigation_DataPrepare_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IndividualNavigation_DataPrepare

% Last Modified by GUIDE v2.5 28-Nov-2019 22:59:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IndividualNavigation_DataPrepare_OpeningFcn, ...
                   'gui_OutputFcn',  @IndividualNavigation_DataPrepare_OutputFcn, ...
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


% --- Executes just before IndividualNavigation_DataPrepare is made visible.
function IndividualNavigation_DataPrepare_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IndividualNavigation_DataPrepare (see VARARGIN)

% Choose default command line output for IndividualNavigation_DataPrepare
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%===========================ȫ�ֱ����趨=====================================
%IMU �����������ļ��� �ļ�·�� 
global IMU_FilePath IMU_FileName 
%ѡ����豸���� 1:First(MPU)(Ĭ��) 2:Second(MTi) 3:Third(ADIS) 
global Choose_Device
Choose_Device = 1;
%ѡ��洢���������� 
%   1:IMUA(MPU_Only)(Ĭ��) 2:IMUB(MPU_Only) 3:IMUB(MTi_Only) 4:IMUB(ADIS_Only) 
%   5:IMUB(ADIS)+IMUA(MPU_Magnetic) 6:IMUB(MPU)+IMUA(MPU)
global Choose_DataKinde
Choose_DataKinde = 1;
%ѡ����Ż��ҽ����� 1:���(��UWB)(Ĭ��) 2:���(����UWB) 3:�ҽ�(����UWB)
global Choose_Foot_LeftorRight
Choose_Foot_LeftorRight = 1;
%ѡ��ʱ��ͬ������ 1:�ڲ�ʱ��(Ĭ��)(��0�뿪ʼ��ʱ) 2:�ڲ�GPSʱ��(����Ч��λUTCʱ�������뿪ʼ)
global Choose_Time
Choose_Time = 1;
%�ⲿ�߾��ȶ�λ����(��������) 0:�� 1:��  
%   txt���ݸ�ʽΪ hhmmss.sss ddmm.mmmmmmm dddmm.mmmmmmm ˮƽ����(��) �߳�(��)
%   �������Ϊ: ������ γ�� ���� �߳� ˮƽ����
global Choose_HighGPSData
Choose_HighGPSData = 0;
%�ⲿ�߾��ȶ�λ����(��������) �����������ļ��� �ļ�·�� 
global GPS_FilePath GPS_FileName 



% UIWAIT makes IndividualNavigation_DataPrepare wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IndividualNavigation_DataPrepare_OutputFcn(hObject, eventdata, handles) 
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

% global IMU_FileName;  %�����������ļ��� 
% global IMU_FilePath;  %�����������ļ�·��
% [IMU_FileName,IMU_FilePath] = uigetfile("*.dat","ѡ��ҪԤ�����ԭʼ����");

global IMU_FileName IMU_FilePath 
[IMU_FileName,IMU_FilePath] = uigetfile('*.dat');
if isequal(IMU_FileName,0)
   disp('ѡ���ļ�ȡ��!');
else
   disp(['ѡȡ�ļ�:', fullfile(IMU_FilePath,IMU_FileName)]);
   set(handles.edit1,'string',strcat(IMU_FilePath,IMU_FileName));
end



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
set(hObject,'String','');
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%------------------------ ��ȡIMU��ص���������-----------------------------
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%ѡ����豸���� 1:First(MPU)(Ĭ��) 2:Second(MTi) 3:Third(ADIS) 
global Choose_Device
str = get(hObject,'tag');
switch str
    case 'radiobutton1'
        Choose_Device = 1;
        disp('�豸����ѡ��First(MPU)');
    case 'radiobutton2'
        Choose_Device = 2;
        disp('�豸����ѡ��Second(MTi)');       
    case 'radiobutton3'
        Choose_Device = 3;
        disp('�豸����ѡ��Third(ADIS)');
end


% --- Executes when selected object is changed in uibuttongroup2.
function uibuttongroup2_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup2 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%   1:IMUA(MPU_Only)(Ĭ��) 2:IMUB(MPU_Only) 3:IMUB(MTi_Only) 4:IMUB(ADIS_Only) 
%   5:IMUB(ADIS)+IMUA(MPU_Magnetic) 6:IMUB(MPU)+IMUA(MPU)
global Choose_DataKinde
str = get(hObject,'tag');
switch str
    case 'radiobutton4'
        Choose_DataKinde = 1;
        disp('ѡ���������ͣ�IMUA(MPU_Only)');
    case 'radiobutton5'
        Choose_DataKinde = 2;
        disp('ѡ���������ͣ�IMUB(MPU_Only)');       
    case 'radiobutton6'
        Choose_DataKinde = 3;
        disp('ѡ���������ͣ�IMUB(MTi_Only)');
    case 'radiobutton7'
        Choose_DataKinde = 4;
        disp('ѡ���������ͣ�IMUB(ADIS_Only)');     
    case 'radiobutton8'
        Choose_DataKinde = 5;
        disp('ѡ���������ͣ�IMUB(ADIS)+IMUA(MPU_Magnetic)'); 
    case 'radiobutton9'
        Choose_DataKinde = 6;
        disp('ѡ���������ͣ�IMUB(MPU)+IMUA(MPU)');         
end


% --- Executes when selected object is changed in uibuttongroup3.
function uibuttongroup3_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup3 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%ѡ����Ż��ҽ����� 1:���(��UWB)(Ĭ��) 2:���(����UWB) 3:�ҽ�(����UWB)
global Choose_Foot_LeftorRight
str = get(hObject,'tag');
switch str
    case 'radiobutton10'
        Choose_Foot_LeftorRight = 1;
        disp('�豸��ģʽ�����(��UWB)');
    case 'radiobutton11'
        Choose_Foot_LeftorRight = 2;
        disp('�豸��ģʽ�����(����UWB)');       
    case 'radiobutton12'
        Choose_Foot_LeftorRight = 3;
        disp('�豸��ģʽ���ҽ�(����UWB)');    
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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
set(hObject,'String','0');
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uibuttongroup6.
function uibuttongroup6_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup6 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%ѡ��ʱ��ͬ������ 1:�ڲ�ʱ��(Ĭ��)(��0�뿪ʼ��ʱ) 2:�ڲ�GPSʱ��(����Ч��λUTCʱ�������뿪ʼ)
global Choose_Time
str = get(hObject,'tag');
switch str
    case 'radiobutton13'
        Choose_Time = 1;
        disp('ʱ��ѡ���ڲ�ʱ��');
    case 'radiobutton14'
        Choose_Time = 2;
        disp('ʱ��ѡ���ڲ�GPS������');     
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
%�ⲿ�߾��ȶ�λ����(��������) 0:�� 1:��  
%   txt���ݸ�ʽΪ hhmmss.sss ddmm.mmmmmmm dddmm.mmmmmmm ˮƽ����(��) �߳�(��)
%   �������Ϊ: ������ γ�� ���� �߳� ˮƽ����
global Choose_HighGPSData
global GPS_FilePath GPS_FileName 
Choose_HighGPSData = get(hObject,'Value');
if Choose_HighGPSData == 0
    set(handles.edit3,'string','');
else    
    [GPS_FileName,GPS_FilePath] = uigetfile('*.txt');
    if isequal(GPS_FileName,0)
       set(hObject,'Value',0);
       Choose_HighGPSData = 0;
       disp('ѡ���ļ�ȡ��!');
    else
       Choose_HighGPSData = 1;
       set(hObject,'Value',1);
       disp(['ѡȡ�ļ�:', fullfile(GPS_FilePath,GPS_FileName)]);
       set(handles.edit3,'string',strcat(GPS_FilePath,GPS_FileName));
    end
end



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
set(hObject,'String','');
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear global IMU_FilePath IMU_FileName Choose_Device Choose_DataKinde
clear global Choose_Foot_LeftorRight Choose_Time Choose_HighGPSData
clear global GPS_FilePath GPS_FileName 
disp('*--------�����˳���-------*');