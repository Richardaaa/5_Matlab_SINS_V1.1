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

% Last Modified by GUIDE v2.5 03-Dec-2019 00:11:40

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
IMU_FilePath = []; IMU_FileName = [];
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
%�Ƿ�����ŵ�ѹ�������� 1:������(Ĭ��) 2:����
global Choose_FootPressure
Choose_FootPressure = 1;

%ѡ��ʱ��ͬ������ 1:�ڲ�GPSʱ��(Ĭ��)(����Ч��λUTCʱ�������뿪ʼ) 2:�ڲ�ʱ��(��0�뿪ʼ��ʱ)
global Choose_Time
Choose_Time = 1;
%�ⲿ�߾��ȶ�λ����(��������) 0:�� 1:��  
%   txt���ݸ�ʽΪ hhmmss.sss ddmm.mmmmmmm dddmm.mmmmmmm ˮƽ����(��) �߳�(��)
%   �������Ϊ: ������ γ�� ���� �߳� ˮƽ����
global Choose_HighGPSData
Choose_HighGPSData = 0;
%�ⲿ�߾��ȶ�λ����(��������) �����������ļ��� �ļ�·�� 
global GPS_FilePath GPS_FileName 
GPS_FilePath = [];  GPS_FileName = [];
%Ԥ������ɺ󣬴�ŵ�·��������
global tDataSavePath tPath
tDataSavePath = []; tPath = [];
%ʱ���ȡ�� ��ʼ�ͽ���ʱ�� ��λS
global Time_Start Time_End
Time_Start = 0.0;   Time_End = 0.0;
% UIWAIT makes IndividualNavigation_DataPrepare wait for user response (see UIRESUME)
% uiwait(handles.figure1);

disp('*/\/\/\/\/\/\/\/\/\/\��������/\/\/\/\/\/\/\/\/\/\*');

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

global IMU_FileName IMU_FilePath tDataSavePath tPath
[IMU_FileName,IMU_FilePath] = uigetfile('*.dat');
if isequal(IMU_FileName,0)
   
else  
   set(handles.edit1,'string',strcat(IMU_FilePath,IMU_FileName));
   % 1. ��ȡ�ļ�·��
    tIndex = strfind(IMU_FileName,'.');
    tName = IMU_FileName(1:tIndex-1);  %Ԥ���������mat �洢������
    tPath = [IMU_FilePath,tName];
    tDataSavePath = [IMU_FilePath,tName,'.mat'];
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


%------------------------ ��ȡIMU �� �ⲿ ��ص���������-----------------------------
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 0. ȫ�ֱ�������
global IMU_FilePath IMU_FileName Choose_Device Choose_DataKinde Choose_Time
global Choose_Foot_LeftorRight Choose_FootPressure tDataSavePath tPath

if isempty(tDataSavePath) == 1
    disp('���棺****δ���ñ�������·���������򿪰�ť��*****');
    return;
end

disp('*****************************************************');
disp('*-------------------���ݶ�ȡ��ʼ---------------------*');
%% 1. ��ȡIMU�������
if isempty(IMU_FilePath) == 1
    disp('���棺******δ����IMU����·����******');
else
%���ݲ������趨����ȡģ���Ӧ������
%   ��ͬģ���ʹ�ã����� IMU �� Magnetic �ϵ�������
    %% 1.1 IMU �� Magnetic ��һ������
    % ��һ�������First IMUB_MPU_Only 
    if Choose_Device == 1 && Choose_DataKinde == 1  
        Path_IMU = [tPath,'_UB_IMU_MPU.txt'];  %������ǿ�� 
        [IMU,Magnetic] = DataPrepare_LoadData_IMU_Include_Magnetic(Path_IMU);
        if isempty(IMU) == 1 
            disp('1.*****IMU����Ϊ��*****');
        else
            save(tDataSavePath,'IMU');                  %�洢
            disp('1. IMU���ݴ洢�ɹ���');
            DataPrepare_PlotData_Original(IMU,1);       %����
            save(tDataSavePath,'Magnetic','-append');   %�洢
            disp('2. Magnetic���ݴ洢�ɹ���');              
            DataPrepare_PlotData_Original(Magnetic,2);  %����
        end
    end
    % �ڶ��������Third IMUB_ADIS + IMUA_MPU_Magnetic
    if Choose_Device == 3 && Choose_DataKinde == 5 
        Path_IMU = [tPath,'_UB_IMU_ADIS.txt']; 
        IMU = DataPrepare_LoadData_IMU_Only(Path_IMU);
        if isempty(IMU) == 1 
            disp('1.*****IMU����Ϊ��*****');
        else
            save(tDataSavePath,'IMU');                  %�洢
            disp('1. IMU���ݴ洢�ɹ���');
            DataPrepare_PlotData_Original(IMU,1);       %����
        end
        %��ȡIMUA_MPU�Ĵ�ǿ������ ���洢
        Path_Magnetic = [tPath,'_UA_Magnetic_MPU.txt']; 
        Magnetic = DataPrepare_LoadData_Magnetic_Only(Path_Magnetic);
        if isempty(Magnetic) == 1
            disp('2.******��ǿ�����ݶ�ȡʧ�ܣ�******');
        else
            save(tDataSavePath,'Magnetic','-append');
            disp('2. Magnetic���ݴ洢�ɹ���'); 
            DataPrepare_PlotData_Original(Magnetic,2);
        end        
    end
    %% 1.2 ��ȡ���ѹ������
    if Choose_FootPressure == 1
        Path_FootPres = [tPath,'_FootPressure.txt'];  
        FootPres = DataPrepare_LoadData_FootPres(Path_FootPres);
        if isempty(FootPres) == 1
            disp('3.*****FootPress���ݶ�ȡʧ��******');
        else
            save(tDataSavePath,'FootPres','-append');
            disp('3. FootPress���ݴ洢�ɹ���');
            DataPrepare_PlotData_Original(FootPres,3);
        end            
    end

    %% 1.3 ��ȡUWB�������
    if Choose_Foot_LeftorRight == 1       %��ź�UWB����
        Path_UWB = [tPath,'_UWB.txt'];  
        UWB = DataPrepare_LoadData_UWB(Path_UWB);
        if isempty(UWB) == 1
            disp('3.*****FootPress���ݶ�ȡʧ��******');
        else
            save(tDataSavePath,'UWB','-append');
            disp('4. UWB���ݴ洢�ɹ���');
            DataPrepare_PlotData_Original(UWB,4);
        end              
    end

    %% 1.4 ��ȡGPS����
    if Choose_Time == 1       %ʹ��GPSʱ�䣬��ζ����GPS����
        Path_GPS = [tPath,'_GPS.txt'];  
        GPS = load(Path_GPS);
        if isempty(GPS) == 1
            disp('5.******GPS���ݶ�ȡʧ��******');
        else
            %��λת��
            GPS(:,2:3) = GPS(:,2:3).*(pi/180.0);
            save(tDataSavePath,'GPS','-append');
            disp('5. GPS���ݴ洢�ɹ���');
            DataPrepare_PlotData_Original(GPS,5);
        end                
    end    
end
 
%% 2. ��ȡ�ⲿ�������µĸ߾���GPS����
%�ⲿ�߾��ȶ�λ����(��������) 0:�� 1:��  
%   txt���ݸ�ʽΪ hhmmss.sss ddmm.mmmmmmm dddmm.mmmmmmm ˮƽ����(��) �߳�(��)
%   �������Ϊ: ������ γ�� ���� �߳� ˮƽ����
global Choose_HighGPSData
%�ⲿ�߾��ȶ�λ����(��������) �����������ļ��� �ļ�·�� 
global GPS_FilePath GPS_FileName 

if isempty(GPS_FilePath) == 1
    disp('���棺******δ���ø߾���GPS����·����******');
else
    if Choose_HighGPSData == 1 
        Path_HighGPS = [GPS_FilePath,GPS_FileName];     
        Temp = load(Path_HighGPS);
        if isempty(Temp) == 1
            disp('5.******High GPS���ݶ�ȡʧ��******');
        else 
            L = length(Temp);
            HighGPS = zeros(L,6);
            for i=1:L
                %ʱ�����
                Second = fix(mod(Temp(i,1),100));   %�е�ʱ�򱱶���������Ǵ�ms��
                Minute = fix(fix(mod(Temp(i,1),10000))/100);
                Hour = fix(Temp(i,1)/10000);
                HighGPS(i,1) = Hour*3600+Minute*60+Second;
                %γ�ȼ���
                Degree = fix(Temp(i,2)/100);
                DMinute = mod(Temp(i,2),100);
                HighGPS(i,2) = Degree+DMinute/60.0;
                %���ȼ���
                Degree = fix(Temp(i,3)/100);
                DMinute = mod(Temp(i,3),100);
                HighGPS(i,3) = Degree+DMinute/60.0;
                %�߳�
                HighGPS(i,4) = Temp(i,6);
                %ˮƽ��λ����
                HighGPS(i,5) = Temp(i,5);
                %��λģʽ 0 ��Ч 1���� 4RTK���� 5RTK�̶� 6�ߵ�
                HighGPS(i,6) = Temp(i,4);
            end
            HighGPS(:,2:3) = HighGPS(:,2:3).*(pi/180.0);
            save(tDataSavePath,'HighGPS','-append');
            disp('5.High GPS���ݴ洢�ɹ���');
            DataPrepare_PlotData_Original(HighGPS,6);
        end      
    end
end

disp('*-------------------���ݶ�ȡ���--------------------*��');
disp('*****************************************************');

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
    case 'radiobutton2'
        Choose_Device = 2;     
    case 'radiobutton3'
        Choose_Device = 3;
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
    case 'radiobutton5'
        Choose_DataKinde = 2;    
    case 'radiobutton6'
        Choose_DataKinde = 3;
    case 'radiobutton7'
        Choose_DataKinde = 4;
    case 'radiobutton8'
        Choose_DataKinde = 5; 
    case 'radiobutton9'
        Choose_DataKinde = 6;    
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
    case 'radiobutton11'
        Choose_Foot_LeftorRight = 2;  
    case 'radiobutton12'
        Choose_Foot_LeftorRight = 3;
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%ѡ��ʱ��ͬ������ 1:�ڲ�GPSʱ��(Ĭ��)(����Ч��λUTCʱ�������뿪ʼ) 2:�ڲ�ʱ��(��0�뿪ʼ��ʱ)
%% 0. �Ȼ�ȡ��Ҫ��ȡʱ��ε� ��ʼ�ͽ��� ʱ��
global Time_Start Time_End tDataSavePath
Time_Start = str2double(get(handles.edit2,'String'));
Time_End = str2double(get(handles.edit4,'String'));
global Choose_Time
disp('----------------------------------------------------');
disp('*------------------��ʼʱ��ͬ������-----------------*');
if isempty(tDataSavePath) == 1
    disp('*-----------����·��Ϊ�գ��޷���ȡ���ݣ�------------*');    
    disp('****************************************************');
    return;
end

%% 1. ʹ��GPSʱ��ͬ��
if Choose_Time == 1          
    DataPrepare_IMUData_TimeAlignmentUTC(tDataSavePath,200,100,Time_Start,Time_End);  
    disp('*---------------ʹ��GPSʱ��ͬ����ɣ�---------------*');    
    disp('****************************************************');
end

%% 2. ʹ���ڲ�ʱ��
if Choose_Time == 2
    DataPrepare_IMUData_TimeAlignmentSelf(tDataSavePath,200,100,Time_Start,Time_End); 
    disp('*--------------ʹ���ڲ�ʱ�ӣ�������ɣ�--------------*');
    disp('****************************************************');
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% 1. ����ѹ����������IMU���ݽ��нŲ�״̬�ж�


%% 2. UWB �����ݵ�ͨ�˲�  �����Կ��� ��ǿ�Ƶ����ݵ�ͨ�˲�


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
    case 'radiobutton14'
        Choose_Time = 2;
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
    else
       Choose_HighGPSData = 1;
       set(hObject,'Value',1);
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
disp('*/\/\/\/\/\/\/\/\/\/\�����˳�/\/\/\/\/\/\/\/\/\/\*');

% --- Executes when selected object is changed in uibuttongroup7.
function uibuttongroup7_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup7 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%�Ƿ�����ŵ�ѹ�������� 1:������(Ĭ��) 2:����
global Choose_FootPressure
str = get(hObject,'tag');
switch str
    case 'radiobutton16'
        Choose_FootPressure = 1;
    case 'radiobutton17'
        Choose_FootPressure = 2;
end






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



function FootPres = DataPrepare_LoadData_FootPres(mLoadPath)
%����·����ȡ���ѹ�����ݵ�txt
FootPres = [];
Temp = load(mLoadPath);
if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;
    FootPres = zeros(L,7);
    FootPres(1:L,1:7) = Temp(1:L,1:7);
end         
        

function [IMU,Magnetic] = DataPrepare_LoadData_IMU_Include_Magnetic(mLoadPath)
% %����·����ȡ������ǿ�����ݵ� IMU ���� ��txt�ļ�
% ע�⣺Ŀǰʹ�õ���MPU9250 IMU����Ƶ����200Hz����ǿ����100Hz������䶯��������Ҫ���иı�
IMU = [];
Magnetic = [];
Temp = load(mLoadPath);

if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;    %���ݵ�λ�Ƕ�/s  �Ӽ� m/s2 ��ǿ�� uT
    IMU = zeros(L,9);       
    IMU(1:L,1:5) = Temp(1:L,1:5);  
    IMU(1:L,6:8) = Temp(1:L,6:8)./(180.0/pi);   
    IMU(1:L,9) = Temp(1:L,13);  %ʱ��״̬
    %��ִ�ǿ������ 
    Magnetic = zeros(fix(L/2),6);
    for i=1:fix(L/2)
        Magnetic(i,1:2) = IMU(1+(i-1)*2,1:2); %ʱ��        
        Magnetic(i,3:5) = Temp(1+(i-1)*2,9:11);
        Magnetic(i,6) = Temp(1+(i-1)*2,13); %ʱ��״̬
    end      
end


function IMU = DataPrepare_LoadData_IMU_Only(mLoadPath)
% ��ȡ��������ǿ�����ݵ� IMU ���� (ADIS)
IMU = [];
Temp = load(mLoadPath);

if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;    %���ݵ�λ�Ƕ�/s  �Ӽ� m/s2 ��ǿ�� uT
    IMU = zeros(L,9);       %���һ�д�ʱ���
    IMU(1:L,1:5) = Temp(1:L,1:5);
    IMU(1:L,6:8) = Temp(1:L,6:8)./(180.0/pi);   
    IMU(1:L,9) = Temp(1:L,11);
end


function Magnetic = DataPrepare_LoadData_Magnetic_Only(mLoadPath)
% ��ȡ��ǿ������  ��IMUA_MPU9250�ɼ�   ��ǿ�Ʋɼ�Ƶ��100Hz
Magnetic = [];
Temp = load(mLoadPath);

if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;    %��ǿ�Ƶ�λ uT
    Magnetic = zeros(L,6);
    Magnetic(1:L,1:6) = Temp(1:L,1:6);    %����ʱ��״̬
end

function UWB = DataPrepare_LoadData_UWB(mLoadPath)
%
UWB = [];
Temp = load(mLoadPath);
if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;
    UWB = zeros(L,4);
    UWB(1:L,1:4) = Temp(1:L,1:4);
end  





