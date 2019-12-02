function DataPrepare_IMUData_TimeAlignmentUTC(mDataPath,HzIMU,HzMag,mTimeStart,mTimeEnd)
% ����GPS��UTC(������)����ʱ����룬ʹ�����¹���
%1.���趨����ʼ�ͽ���ʱ�䣬����ǰ��1�����չ��
%2.����û���趨��ʼ�ͽ���ʱ�䣬��Ĭ�������������һ�е�ʱ��״̬Ϊ��ʼ��Ĭ�϶�1S
%3.����ʱ�����󣬽��в�ֵ����
%����Ƶ��
HzIMU = 200;
HzMag = 100;
%�������
DeltaT_IMU = 1/HzIMU;
DeltaT_Mag = 1/HzMag;

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

%% ���� �������ݽ�ȡ�׶Σ�����ȱ����ֵ





fuck = 1;



