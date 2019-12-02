function NewOneSecondData = DataPrepare_IMUData_TimeAlignment_UTCSecondInsert(mOneSecondData,Hz)
%�мǣ�������������������GPSʱ�������£����ж����жϼ���ֵ
%����������ݰ��������������¼ʱ����ж����жϣ������в�ֵ����

DeltaT_ms = fix(1/Hz*1000);
[L,m] = size(mOneSecondData);

% 1.���ж������Ƿ���  ע�⣺*�˴�͵���������õڶ��е�ms���ݽ����жϣ������� ��������1s�������������*
j = 1;    
mLoseRecord=[0,0];
mLoseTime = 0;
for i=1:L-1
    TempMS = mOneSecondData(i+1,2)-mOneSecondData(i,2);  %�������ݵ�ms��ֵ
    if TempMS < 0
       if TempMS < -900  %�������
            TempMS = TempMS + 1000;
       end
    end
    if TempMS < -900   
        TempMS = TempMS + 1000;
    else
        if TempMS >-10
            
    end    
    tNumber = round(TempMS/DeltaT_IMU)-1;
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
    NewOneSecondData = mOneSecondData;
    return;
else
    %�ж����ģ���Ҫ���в�ֵ
    L1 = sume(mLoseRecord(:,2));  %��Ҫ��ֵ�ĸ���
    NewOneSecondData = zeros(L+L1,m);
    j = 1;
    mAddNumber = 0;
    for i=1:L        
        if i == mLoseRecord(j,1)
            %��i����ǰ����Ҫ��ֵ������ȱ�ĸ�����ֵ��            
            First = mOneSecondData(i-1,:);
            Second = mOneSecondData(i,:);
            InsertData = 
            
            mAddNumber = mAddNumber+mLoseRecord(j,2);  %��¼�Ѿ���ֵ�ĸ���
            %�����������ֵ                
            NewOneSecondData(i+mAddNumber,:) = mOneSecondData(i,:);
              
            if j < mLoseTime
                j=j+1;
            end
        else
           % ������ֵ               
           NewOneSecondData(i+mAddNumber,:) = mOneSecondData(i,:);
        end             
    end  
end
    









