function NewData = DataPrepare_IMUData_LoseCheck_And_Insert(mData,Hz)
%����������ݰ��������������¼ʱ����ж����жϣ������в�ֵ����
% ������ʱ�������ͻ�䣡
DeltaT_ms = fix(1/Hz*1000);
[L,m] = size(mData);

% 1.���ж������Ƿ���  ע�⣺*�˴�͵���������õڶ��е�ms���ݽ����жϣ������� ��������1s�������������*
j = 1;    
mLoseRecord=[0,0];
mLoseTime = 0;
for i=1:L-1
    TempMS = mData(i+1,2)-mData(i,2);  %�������ݵ�ms��ֵ
    if TempMS < -900  %�������
        TempMS = TempMS + 1000;
    end
    
    tNumber = round(TempMS/DeltaT_ms)-1;
    if tNumber > 0            
        mLoseRecord(j,1) = i+1;
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











