function IMU = DataPrepare_LoadData_IMU_Only(mLoadPath)
% ��ȡ��������ǿ�����ݵ� IMU ���� (ADIS)


IMU = [];
Temp = load(mLoadPath);

if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;    %���ݵ�λ�Ƕ�/s  �Ӽ� m/s2 ��ǿ�� uT
    IMU = zeros(L,8);       %���һ�д�ʱ���
    IMU(1:L,1) = Temp(1:L,1)+Temp(1:L,2)./1000.0;
    IMU(1:L,2:4) = Temp(1:L,3:5);
    IMU(1:L,5:7) = Temp(1:L,6:8)./(180.0/pi);   
    IMU(1:L,8) = Temp(1:L,11);
end

