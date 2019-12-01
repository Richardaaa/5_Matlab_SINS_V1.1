function [IMU,Magnetic] = DataPrepare_LoadData_IMU_Include_Magnetic(mLoadPath)
% ��ȡ������ǿ�����ݵ� IMU ���� 
% ע�⣺Ŀǰʹ�õ���MPU9250 IMU����Ƶ����200Hz����ǿ����100Hz������䶯��������Ҫ���иı�

IMU = [];
Magnetic = [];
Temp = load(mLoadPath);

if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;    %���ݵ�λ�Ƕ�/s  �Ӽ� m/s2 ��ǿ�� uT
    IMU = zeros(L,8);       %���һ�д�ʱ���
    IMU(1:L,1) = Temp(1:L,1)+Temp(1:L,2)./1000.0;
    IMU(1:L,2:4) = Temp(1:L,3:5);
    IMU(1:L,5:7) = Temp(1:L,6:8)./(180.0/pi);   
    IMU(1:L,8) = Temp(1:L,13);  %ʱ��״̬
    %��ִ�ǿ������ 
    Magnetic = zeros(fix(L/2),5);
    for i=1:fix(L/2)
        Magnetic(i,1) = IMU(1+(i-1)*2,1); %ʱ��
        Magnetic(i,2:4) = Temp(1+(i-1)*2,9:11);
        Magnetic(i,5) = Temp(1+(i-1)*2,13); %ʱ��״̬
    end      
end