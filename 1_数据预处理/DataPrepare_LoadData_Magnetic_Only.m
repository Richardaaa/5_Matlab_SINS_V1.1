function Magnetic = DataPrepare_LoadData_Magnetic_Only(mLoadPath)
% ��ȡ��ǿ������  ��IMUA_MPU9250�ɼ�   ��ǿ�Ʋɼ�Ƶ��100Hz

Magnetic = [];
Temp = load(mLoadPath);

if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;    %��ǿ�Ƶ�λ uT
    Magnetic = zeros(L,5);
    Magnetic(1:L,1) = Temp(1:L,1)+Temp(1:L,2)./1000.0;
    Magnetic(1:L,2:5) = Temp(1:L,3:6);    %����ʱ��״̬
end