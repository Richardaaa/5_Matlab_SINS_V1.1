function NewData = DataPrepare_IMUData_LoseCheck_And_Insert(mData,Hz)
%����������ݰ��������������¼ʱ����ж����жϣ������в�ֵ����,���һ���㲻������ʱ��
% ������ʱ�������ͻ�䣡
% ��һ��Ϊʱ����Ϣ 
DeltaT_ms = 1/Hz;
[L,m] = size(mData);

% 1.���ж������Ƿ���  
% ��Ϊ ѡȡ��������ʱ��֮������ݣ���ˣ�ʱ������Ӧ���ǵ�����
j = 1;    
mLoseRecord=[0,0];
mLoseTime = 0;
for i=1:L-1
    IntervalTime = mData(i+1,1)-mData(i,1);  %��������֮���ʱ���   
    if IntervalTime < 0
        disp("���棺���������ݶ����ж��У����������㣡") 
    end
    tNumber = round(IntervalTime/DeltaT_ms)-1;
    if tNumber > 0            
        mLoseRecord(j,1) = i+1;        %����� i+1֮ǰҪ����
        mLoseRecord(j,2) = tNumber;
        j = j+1;
        mLoseTime = mLoseTime+1;
        if tNumber > Hz/2
           disp("����񣬶������������ˣ�������") 
           return;
        end
    end
end    

% 2. �����Ƿ��������������ݵĿռ�����
if mLoseTime == 0
    %û�ж��� ���ò�ֵ��ֱ�ӷ���
    NewData = mData;
    return;
else
    %�ж����ģ���Ҫ���в�ֵ
    L1 = sum(mLoseRecord(:,2));  %��Ҫ��ֵ�ĸ���
    NewData = zeros(L+L1,m);
    j = 1;
    mAddNumber = 0;
    for i=1:L        
        if i == mLoseRecord(j,1)
            %��i����ǰ����Ҫ��ֵ������ȱ�ĸ�����ֵ�� 
            InsertData = Data_Insert_From_Start_End(mData(i-1,:),mData(i,:),mLoseRecord(j,2));
            NewData(i+mAddNumber:i+mAddNumber+mLoseRecord(j,2)-1,:) = InsertData;            
            mAddNumber = mAddNumber+mLoseRecord(j,2);  %��¼�Ѿ���ֵ�ĸ���
            %�����������ֵ                
            NewData(i+mAddNumber,:) = mData(i,:);              
            if j < mLoseTime
                j=j+1;
            end
        else
           % ������ֵ               
           NewData(i+mAddNumber,:) = mData(i,:);
        end             
    end  
end











