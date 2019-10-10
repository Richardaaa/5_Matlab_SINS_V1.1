% ���ߵ�������ԡ������ߵ��豸
% �������   ADIS16467


%% һ����ʼ��
% 1. ��ֵ��ʼ��
G_Const = CONST_Init();

% 3. ���������趨
G_IMU.Hz = 200;                         %IMU�Ĳ���Ƶ��

% 4. ��ʼ��̬���ٶȡ�λ���趨
G_Start_Att(1,1) = 0.0 * G_Const.D2R;   %��̬ ������ ��
G_Start_Att(2,1) = 0.0 * G_Const.D2R;   %��̬ ����� ��
G_Start_Att(3,1) = 0.0 * G_Const.D2R;   %��̬ ����� (��ƫ��Ϊ������)
G_Start_Vel(1,1) = 0.0;                 %�ٶ� v_e �����ٶ�
G_Start_Vel(2,1) = 0.0;                 %�ٶ� v_n �����ٶ�
G_Start_Vel(3,1) = 0.0;                 %�ٶ� v_u �����ٶ�
G_Start_Pos(1,1) = 34.230511 * G_Const.D2R;   %λ�� γ�� ��
G_Start_Pos(2,1) = 108.963303 * G_Const.D2R;   %λ�� ���� ��
G_Start_Pos(3,1) = 40.0 * G_Const.D2R;   %λ�� �߳� m

%% �����߾��ȹߵ�����
% 1. ����׼��
[n,m] = size(Data_IMU_R);
n = 10000;
Result_AVP = zeros(n,10);               %����Ľ�� ʱ�� ��̬ �ٶ� λ��
Result_AVP(1,1) = Data_IMU_R(1,1);     %ʱ��
Result_AVP(1,2:4) = G_Start_Att';       %��̬
Result_AVP(1,5:7) = G_Start_Vel';       %�ٶ�
Result_AVP(1,8:10) = G_Start_Pos';       %λ��

INSData_Now = INS_DataInit(G_Const,Result_AVP(1,1),G_Start_Att,G_Start_Vel,G_Start_Pos,Data_IMU_R(1,5:7)',Data_IMU_R(1,2:4)',1/G_IMU.Hz);
INSData_Pre = INSData_Now;

% 2. ѭ������
for i=2:n
    INSData_Now.time = Data_IMU_R(i,1);    
    INSData_Now.w_ib_b = Data_IMU_R(i,5:7)';           
    INSData_Now.f_ib_b = Data_IMU_R(i,2:4)';
    
    INSData_Now = INS_Update(G_Const,INSData_Pre,INSData_Now,1/G_IMU.Hz);
    
    Result_AVP(i,1) = INSData_Now.time;      
    Result_AVP(i,2:4) = INSData_Now.att';
    Result_AVP(i,5:7) = INSData_Now.vel';
    Result_AVP(i,8:10) = INSData_Now.pos';
  
    INSData_Pre =  INSData_Now;
end

%% ����MIMU�ߵ�����
% 1. ����׼��
[n,m] = size(Data_IMU_R);
n = 10000;
Result_AVP_MIMU = zeros(n,10);               %����Ľ�� ʱ�� ��̬ �ٶ� λ��
Result_AVP_MIMU(1,1) = Data_IMU_R(1,1);     %ʱ��
Result_AVP_MIMU(1,2:4) = G_Start_Att';       %��̬
Result_AVP_MIMU(1,5:7) = G_Start_Vel';       %�ٶ�
Result_AVP_MIMU(1,8:10) = G_Start_Pos';       %λ��

INSDataMIMU_Now = INS_DataInit(G_Const,Result_AVP_MIMU(1,1),G_Start_Att,G_Start_Vel,G_Start_Pos,Data_IMU_R(1,5:7)',Data_IMU_R(1,2:4)',1/G_IMU.Hz);
INSDataMIMU_Pre = INSDataMIMU_Now;

% 2. ѭ������
for i=2:n
    INSDataMIMU_Now.time = Data_IMU_R(i,1);    
    INSDataMIMU_Now.w_ib_b = Data_IMU_R(i,5:7)';           
    INSDataMIMU_Now.f_ib_b = Data_IMU_R(i,2:4)';
    
    INSDataMIMU_Now = INS_Update_MIMU(G_Const,INSDataMIMU_Pre,INSDataMIMU_Now,1/G_IMU.Hz);
    %INSDataMIMU_Now = INS_Update_MIMU_Test(G_Const,INSDataMIMU_Pre,INSDataMIMU_Now,1/G_IMU.Hz);
    
    Result_AVP_MIMU(i,1) = INSDataMIMU_Now.time;      
    Result_AVP_MIMU(i,2:4) = INSDataMIMU_Now.att';
    Result_AVP_MIMU(i,5:7) = INSDataMIMU_Now.vel';
    Result_AVP_MIMU(i,8:10) = INSDataMIMU_Now.pos';
  
    INSDataMIMU_Pre =  INSDataMIMU_Now;
end

%% ���ƱȽ�
Plot_AVP(Result_AVP,Result_AVP_MIMU);




