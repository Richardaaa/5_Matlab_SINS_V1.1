function   NewData = DataPrepare_IMUData_TimeAlignmentUTC_SecondAlign(mData,Hz)
%����������ݰ��� ��һ���� �����һ���� ��ʱ�䣬���м�����ݽ��ж���
% ����ĵ�һ��Ϊʱ�� 

%1.�жϵ�һ�����Ƿ�Ҫ���������
DeltaT = 1/Hz;
[L,m] = size(mData);

if mod(mData(1,1),DeltaT)==0 
    %����ĵ�һ����Ϊ ʱ�̵�
    Time = mData(1,1);
    StartTime = Time;
else
    Time = (fix(mData(1,1)/DeltaT)+1)*DeltaT;
    StartTime = Time;
end

%2. ��������׼ȷʱ��֮�䣬�ܰ������ٸ� ʱ�̵�
N = 0;  
while Time < mData(L,1)
    N = N+1;
    Time = Time+DeltaT;
end

%3. ��ʱ����ڵ������Ѿ����������䰴��ʱ��ν���ƽ��
AverageTime = (mData(L,1)-mData(1,1))/(L-1);
TempData = mData;
%��TempData�е�ʱ�䣬������β�⣬����ʱ�����ƽ��
for i = 2:L-1
    TempData(i,1) = TempData(i-1,1)+AverageTime;    
end

%4. �����µ�ʱ�����У����в�ֵ������ȡÿ��ʱ�̵������
NewData = zeros(N,m);
for i =1:N
    %��i������ ��׼ʱ��ʱ��
    NewData(i,1) = StartTime+(i-1)*DeltaT;
    %���в�ֵ����
    for j = 1:L
        if abs(NewData(i,1)-TempData(j,1))<0.00001
            NewData(i,2:m) = TempData(j,2:m);
            break;
        end
        if TempData(j,1) < NewData(i,1)
            First = j;
            continue;
        else
            Second = j;
            InsertData = Data_Insert_From_Time(TempData(First,:),TempData(Second,:),NewData(i,1));
            NewData(i,:) = InsertData;
            break;
        end    
    end    
end

fuck = 1;
