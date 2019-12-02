function CutData = DataPrepare_IMUData_TimeAlignmentUTC_Cut(mData,Hz,mStartT,mEndT)
% 0.�ú�������ǰ��ȷ�� �������ʼ�ͽ���ʱ��������Ч��Χ�ڵ�
% 1.�����������ݰ��������յ���нض�
% 2.�����ղ���Ƶ�ʽ��ж���
% 3.�����в�ֵ����
% ���ݵĸ�ʽ��һ���� �� ���� ����.... ʱ��״̬

%% 0. ���ȶ������ ��ʼʱ��ͽ���ʱ�䣬����GPS��ʱ��Ч�Ե��ж�
Second_StartSerial = 0; Second_NextStartSerial = 0;
Second_StartTime = 0;   Second_NextStartTime = 0;
% ���ʱ�����Ч���ж�
[Second_StartTime,Second_StartSerial] = DataPrepare_IMUData_FindSecondSerial(mData,mStartT);
if Second_StartSerial == 0
    %����ʧ��
    fprintf('����:GPS��Ч��Χ�����и������Чʱ���趨���� %d!\n',mStartT);
    return;
end 
if Second_StartTime ~= mStartT
    fprintf('����:GPS��Чʱ��������Ϊ %d!\n',Second_StartTime);
    mStartT = Second_StartTime;
end 
% �յ�ʱ�����Ч���ж�
for s=mEndT:-1:mStartT
    [Second_NextStartTime,Second_NextStartSerial] = DataPrepare_IMUData_FindSecondSerial(mData,s);
    if Second_NextStartSerial ~= 0
        break;
    end
end
if Second_NextStartSerial == 0
    %����ʧ��
    fprintf('����:GPS��Ч��Χ�����и������Чʱ���趨���� %d!\n',mEndT);
    return;
end     
if Second_NextStartTime ~= mEndT
    fprintf('����:GPS��Чʱ��������Ϊ %d!\n',Second_NextStartTime);
    mEndT = Second_NextStartTime-1;
end 
% ʱ�䷶Χ����Ч���ж�
if mEndT <= mStartT
    fprintf('����:GPSʱ���иΧ��Ч��%d %d\n',mStartT,mEndT);
    return;  
end

%% һ������Ч����ʱ��ʼ���յ㷶Χ֮�䣬�������ݴ���
[L,m] = size(mData);
DeltaT = fix((1/Hz)*1000);  %ms��Ӧ���ݵڶ���
CutData = zeros((mEndT-mStartT+1)*Hz,m-1);
CutData_SavedNum = 0;
% ���޶������ʼʱ�䣬��ʼ������ÿһ����GPS��ʱ������
Second_NextStartTime = Second_StartTime; 
Second_NextStartSerial = Second_StartSerial;
Second_StartTime = 0;       Second_StartSerial = 0;
s = mStartT;

while s <= mEndT
    %1.�ҵ���ʱ����ʼ��
    Second_StartTime = Second_NextStartTime;
    Second_StartSerial = Second_NextStartSerial;
    %2.�ҵ���һ����ʱ����ʼ��    
    [Second_NextStartTime,Second_NextStartSerial]=DataPrepare_IMUData_FindSecondSerial(mData,Second_StartTime+1);
    s = Second_NextStartTime;
    
    if Second_NextStartSerial == 0
        break;
    end
    
    %3.��ȡ���ǰ������ʱ��ʱ�� >= 1s 
    %   ��һ�� �� ���һ��(��ʱ��) ʱ����׼ȷ�ģ��м� ���ڲ�ʱ��˳���ۼӣ�û�����㣬�п����ж�������Ҫ��ֵ
    Temp_Data = zeros(Second_NextStartSerial-Second_StartSerial+1,m-1);   %����ת��ʱ��
    Temp_Data(:,1) = mData(Second_StartSerial:Second_NextStartSerial,1)+mData(Second_StartSerial:Second_NextStartSerial,2)./1000.0;
    Temp_Data(:,2:m-1) = mData(Second_StartSerial:Second_NextStartSerial,3:m);
    Last_Data = Temp_Data(Second_NextStartSerial-Second_StartSerial+1,:);
    %4.���������ݣ����ж������,����ֵ���϶�������(ֻ�е�һ��������ʱ�㣬���һ����ʱ�㲻Ҫ����)
    Temp_Data = DataPrepare_IMUData_LoseCheck_And_Insert(Temp_Data(1:Second_NextStartSerial-Second_StartSerial,:),Hz);
    %5.�����󣬼��ϵ�ǰ�ε����һ��(��Чʱ��)������ʱ�����Ĳ�ֵ
    %(��������Чʱ��֮�䣬����ʱ����룬������һ���㣬�����������һ���㣬�Է��ظ�)
    Temp_Data=[Temp_Data;Last_Data];
    Temp_Data = DataPrepare_IMUData_TimeAlignmentUTC_SecondAlign(Temp_Data,Hz);
    %6.���������ݣ����д洢
    [L1,m1] = size(Temp_Data);
    CutData(CutData_SavedNum+1:CutData_SavedNum+L1,:) = Temp_Data;    
    CutData_SavedNum = CutData_SavedNum+L1;
end    



fuck=1;

