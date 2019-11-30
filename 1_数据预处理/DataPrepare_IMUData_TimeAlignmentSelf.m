function DataPrepare_IMUData_TimeAlignmentSelf(mDataPath,HzIMU,HzMag,mTimeStart,mTimeEnd)
% ����ʱ����Զ���������������
%1.����������ݣ��Ȱ����ڲ�ʱ��(��0��ʼ)�����в������������IMU��Mag�Ĳ��������һ��
%2.��UWB�����ݽ��в�ֵ����
%3.Ȼ���ٰ����趨��ʱ��Σ��������ݽ�ȡ 

HzIMU = 200;
HzMag = 100;
%% 1.ʱ���������
%�������
DeltaT_IMU = 1/HzIMU;
DeltaT_Mag = 1/HzMag;

%��ȡ����
load(mDataPath);
% 1.1 ����IMU����
if exist('IMU','var')
    [L,n] = size(IMU);
    %���ж�IMU�Ƿ���
    j = 1;    
    mLoseRecord=[0,0];
    mLoseTime = 0;
    for i=1:L-1
        tNumber = round((IMU(i+1,1)-IMU(i,1))/DeltaT_IMU)-1;
        if tNumber > 0            
            mLoseRecord(j,1) = i+1;
            mLoseRecord(j,2) = tNumber;
            j = j+1;
            mLoseTime = mLoseTime+1;
        end
    end    
    
    %���������в�ֵ
    mStartTime = round(IMU(1,1)/DeltaT_IMU)*DeltaT_IMU;
    if mLoseTime > 0
        IMUNew = zeros(L+sum(mLoseRecord(:,2)),n);
        if exist('FootPres','var')
            [k,m] = size(FootPres);
            FootPresNew = zeros(L+sum(mLoseRecord(:,2)),m);
        end
        j=1;
        mAddNumber = 0;
        for i=1:L
            if i == mLoseRecord(j,1)
                % ����ȱ�ĸ�����ֵ��
                for k=1:mLoseRecord(j,2)
                   %��ֵ�� 
                   % IMUNew(i+mAddNumber,:) 
                   IMUNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
                   if exist('FootPres','var')
                        %��ֵ�� 
                        % FootPresNew(i+mAddNumber,:) 
                        FootPresNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
                    end
                   mAddNumber = mAddNumber+1;
                end                
                %�����������ֵ                
                IMUNew(i+mAddNumber,:) = IMU(i,:);
                IMUNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
                if exist('FootPres','var')
                    FootPresNew(i+mAddNumber,:) = FootPres(i,:);
                    FootPresNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
                end                
                if j < mLoseTime
                    j=j+1;
                end
            else
               % ������ֵ               
               IMUNew(i+mAddNumber,:) = IMU(i,:);
               IMUNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
               if exist('FootPres','var')
                    FootPresNew(i+mAddNumber,:) = FootPres(i,:);
                    FootPresNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
               end 
            end        
        end
    else
    %���򣬴ӿ�ʼʱ�䰴�յȼ������ʱ�����
        IMUNew = zeros(L,n);
        for i = 1:L
            IMUNew(i,:) = IMU(i,:);
            IMUNew(i,1) = mStartTime + (i-1)*DeltaT_IMU;            
        end  
        if exist('FootPres','var') 
            [k,m] = size(FootPres);
            FootPresNew = zeros(k,m);
            for i = 1:k
                FootPresNew(i,:) = FootPres(i,:);
                FootPresNew(i,1) = mStartTime + (i-1)*DeltaT_IMU;            
            end             
        end
    end
    IMU = IMUNew; 
    save(mDataPath,'IMU','-append');
    if exist('FootPres','var')     
        FootPres = FootPresNew;
        save(mDataPath,'FootPres','-append');
    end
end

% 1.2 ����UWB����  ����IMU�Ĳ���Ƶ�ʶ���   
if exist('UWB','var')
    [L,n] = size(UWB);
    %���ж�IMU�Ƿ���
    j = 1;    
    mLoseRecord=[0,0];
    mLoseTime = 0;
    for i=1:L-1
        tNumber = round((UWB(i+1,1)-UWB(i,1))/DeltaT_IMU)-1;
        if tNumber > 0            
            mLoseRecord(j,1) = i+1;
            mLoseRecord(j,2) = tNumber;
            j = j+1;
            mLoseTime = mLoseTime+1;
        end
    end    
    
    %���������в�ֵ
    mStartTime = round(UWB(1,1)/DeltaT_IMU)*DeltaT_IMU;
    if mLoseTime > 0
        UWBNew = zeros(L+sum(mLoseRecord(:,2)),n);
        j=1;
        mAddNumber = 0;
        for i=1:L
            if i == mLoseRecord(j,1)
                % ����ȱ�ĸ�����ֵ��
                for k=1:mLoseRecord(j,2)
                   %��ֵ�� 
                   % UWBNew(i+mAddNumber,:) 
                   UWBNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
                   mAddNumber = mAddNumber+1;
                end                
                %�����������ֵ                
                UWBNew(i+mAddNumber,:) = UWB(i,:);
                UWBNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;             
                if j < mLoseTime
                    j=j+1;
                end
            else
               % ������ֵ               
               UWBNew(i+mAddNumber,:) = UWB(i,:);
               UWBNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
            end        
        end
    else
    %���򣬴ӿ�ʼʱ�䰴�յȼ������ʱ�����
        UWBNew = zeros(L,n);
        for i = 1:L
            UWBNew(i,:) = UWB(i,:);
            UWBNew(i,1) = mStartTime + (i-1)*DeltaT_IMU;            
        end  
    end
    UWB = UWBNew; 
    save(mDataPath,'UWB','-append');
end

% 1.3 ����Magnetic����   
if exist('Magnetic','var')
    [L,n] = size(Magnetic);
    %���ж�IMU�Ƿ���
    j = 1;    
    mLoseRecord=[0,0];
    mLoseTime = 0;
    for i=1:L-1
        tNumber = round((Magnetic(i+1,1)-Magnetic(i,1))/DeltaT_Mag)-1;
        if tNumber > 0            
            mLoseRecord(j,1) = i+1;
            mLoseRecord(j,2) = tNumber;
            j = j+1;
            mLoseTime = mLoseTime+1;
        end
    end    
    
    %���������в�ֵ
    mStartTime = round(Magnetic(1,1)/DeltaT_Mag)*DeltaT_Mag;
    if mLoseTime > 0
        MagneticNew = zeros(L+sum(mLoseRecord(:,2)),n);
        j=1;
        mAddNumber = 0;
        for i=1:L
            if i == mLoseRecord(j,1)
                % ����ȱ�ĸ�����ֵ��
                for k=1:mLoseRecord(j,2)
                   %��ֵ�� 
                   % MagneticNew(i+mAddNumber,:) 
                   MagneticNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_Mag;
                   mAddNumber = mAddNumber+1;
                end                
                %�����������ֵ                
                MagneticNew(i+mAddNumber,:) = Magnetic(i,:);
                MagneticNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_Mag;             
                if j < mLoseTime
                    j=j+1;
                end
            else
               % ������ֵ               
               MagneticNew(i+mAddNumber,:) = Magnetic(i,:);
               MagneticNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_Mag;
            end        
        end
    else
    %���򣬴ӿ�ʼʱ�䰴�յȼ������ʱ�����
        MagneticNew = zeros(L,n);
        for i = 1:L
            MagneticNew(i,:) = Magnetic(i,:);
            MagneticNew(i,1) = mStartTime + (i-1)*DeltaT_Mag;            
        end  
    end
    Magnetic = MagneticNew; 
    save(mDataPath,'Magnetic','-append');
end



