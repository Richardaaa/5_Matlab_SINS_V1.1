function DataPrepare_IMUData_TimeAlignmentUTC(mDataPath,HzIMU,HzMag,mTimeStart,mTimeEnd)
% ����GPS��UTC(������)����ʱ����룬ʹ�����¹���
%1.���趨����ʼ�ͽ���ʱ�䣬����ǰ��1�����չ��
%2.����û���趨��ʼ�ͽ���ʱ�䣬��Ĭ�������������һ�е�ʱ��״̬Ϊ��ʼ��Ĭ�϶�1S
%3.����ʱ�����󣬽��в�ֵ����
%����Ƶ��

%% һ�� ׼�������׶�
% 0.�����Ų�
if (mTimeStart<0)||(mTimeEnd<0)||((mTimeEnd>0)&&(mTimeStart>=mTimeEnd))
    disp('����:ʱ�������յ����ô���')
    return;
end

% 1. ��ȡ����
load(mDataPath);
if ~exist('IMU','var')   %���Ƿ����IMU�ж��Ƿ��������
    disp('����:δ��ȡ��IMU���ݣ�')
    return;
end
[L,m] = size(IMU);

% 2. �������ݵ���Ч��ʼʱ��ͽ���ʱ��
% 2.1 ������Ч��ʼʱ��
Temp_Start = 0; Temp_End = 0;
TimeState = 0;  Temp_StartIsFind = 0;
for i = 1:L
    %�״�GPSʱ����Ч
    if(TimeState == 0)&&(IMU(i,m) == 1 )            
        Temp_Start = IMU(i,1)+2; %��ʼ��λʱ�����1s���ӳ�
        TimeState = 1;
    end
    %�ж��趨����ʼʱ���Ƿ���Ч
    if(Temp_Start==IMU(i,1))&&(IMU(i,m) == 1)
        Temp_StartIsFind = 1;
        break;
    end
end
if Temp_StartIsFind == 0
    disp('����:û��GPS��ʼʱ�䣡')
    return;
end
% 2.2 ������Ч����ʱ��
for i = L:-1:1
    if IMU(i,m) == 1 
        Temp_End = IMU(i,1);
        break;
    end    
end
if Temp_Start>=Temp_End
    disp('����:GPS����ʱ����������')
    return;
end

TimeStart = 0; TimeEnd = 0;
% 3. ȷ����Ҫ��ȡ���ݵ���ʼ���յ�
if (mTimeStart == 0)
    TimeStart = Temp_Start;
else
    if Temp_Start>=mTimeStart
        TimeStart = Temp_Start;
    else
        TimeStart = mTimeStart;
    end
end
%��Ϊ���1s ʱ�䲻������ȥ��
if (mTimeEnd == 0)
    TimeEnd = Temp_End-1;
else
    if Temp_End>mTimeEnd
        TimeEnd = mTimeEnd;
    else
        TimeEnd = Temp_End-1;
    end
end

%��ȡ����ʵ��Ч��GPSʱ�䣬
    fprintf('��ȡ��ʵ��Ч��GPS��ȡʱ��Ϊ��%d  %d \n',TimeStart,TimeEnd);

%% ���� �������ݽ�ȡ�׶Σ�����ȱ����ֵ
%��ȫ����ȡ�꣬Ȼ����ƣ������Ƕ�GPS �͸߾���GPS�����ݽ��н�ȡ��
tIndex = strfind(mDataPath,'.');
NewPath = mDataPath(1:tIndex-1);
NewPath = [NewPath,sprintf('_%d_%d',TimeStart,TimeEnd),'.mat'];
%1.�Ƚ�ȡIMU ���洢
IMU = DataPrepare_IMUData_TimeAlignmentUTC_Cut(IMU,200,TimeStart,TimeEnd);
if isempty(IMU) == 1
    disp('1.**** IMU����ʱ���ȡʧ�ܣ�****')
else
    disp('1.IMU����ʱ���ȡ��ɣ�')
    save(NewPath,'IMU');                        %�洢��ȡ���������
    DataPrepare_PlotData_TimeCuted(IMU,1);       %����
end    
%2. ��ǿ������
if exist('Magnetic','var')   
    Magnetic = DataPrepare_IMUData_TimeAlignmentUTC_Cut(Magnetic,100,TimeStart,TimeEnd);
    if isempty(Magnetic) == 1
        disp('2.**** Magnetic����ʱ���ȡʧ�ܣ�****')
    else
        disp('2.Magnetic����ʱ���ȡ��ɣ�')
        save(NewPath,'Magnetic','-append');                  %�洢
        DataPrepare_PlotData_TimeCuted(Magnetic,2);       %����
    end
end   
%3. ���ѹ������    
if exist('FootPres','var')   
    FootPres = DataPrepare_IMUData_TimeAlignmentUTC_Cut(FootPres,200,TimeStart,TimeEnd);
    if isempty(FootPres) == 1
        disp('3.**** FootPres����ʱ���ȡʧ�ܣ�****')
    else
        disp('3.FootPres����ʱ���ȡ��ɣ�')
        save(NewPath,'FootPres','-append');                  %�洢
        DataPrepare_PlotData_TimeCuted(FootPres,3);          %����
    end
end    
%4. UWB����
 if exist('UWB','var')   
    UWB = DataPrepare_IMUData_TimeAlignmentUTC_Cut(UWB,200,TimeStart,TimeEnd);
    if isempty(UWB) == 1
        disp('4.**** UWB����ʱ���ȡʧ�ܣ�****')
    else
        disp('4.UWB����ʱ���ȡ��ɣ�')
        save(NewPath,'UWB','-append');                  %�洢
        DataPrepare_PlotData_TimeCuted(UWB,4);          %����
    end
end 
%5. ģ����GPS����
if exist('GPS','var')       
    [L,m] = size(GPS);
    First = 0; Second = L;
    for i=1:L
       if TimeStart <= GPS(i,1)
           First = i;
           break;
       end
    end
    for i=1:L
       if TimeEnd <= GPS(i,1)
           Second = i;
           break;
       end
    end       
    GPS = GPS(First:Second,:);
    disp('5.GPS����ʱ���ȡ��ɣ�')
    save(NewPath,'GPS','-append');                  %�洢
    DataPrepare_PlotData_TimeCuted(GPS,5);          %����
end
%6. �ⲿ�߾���GPS����
if exist('HighGPS','var')       
    [L,m] = size(HighGPS);
    First = 0; Second = L;
    for i=1:L
       if TimeStart <= HighGPS(i,1)
           First = i;
           break;
       end
    end
    for i=1:L
       if TimeEnd <= HighGPS(i,1)
           Second = i;
           break;
       end
    end       
    HighGPS = HighGPS(First:Second,:);
    disp('6.HighGPS����ʱ���ȡ��ɣ�')
    save(NewPath,'HighGPS','-append');                  %�洢
    DataPrepare_PlotData_TimeCuted(HighGPS,6);          %����
end    
    
    
  


