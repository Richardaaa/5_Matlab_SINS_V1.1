% KF�˲�����
% ʹ��ģ�����ݣ��� �Ϲ����ĳ������Ա�

clear;
load('trj10ms_imu.mat');
load('trj10ms_imuerr.mat');
load('trj10ms_davp0.mat');
load('trj10ms_avp0_err.mat');
load('trj10ms_GPS.mat');
load('trj10ms_avp_theory.mat');
load('trj10ms_avp_result_LC.mat');
% ��������ת����
Ts = 0.01;  %�������100ms
L = length(imu);
Data_IMU = zeros(L,8);
Data_IMU(:,1) = imu(:,7);              % ʱ��
Data_IMU(:,5:7) = imu(:,1:3)./Ts;       % ���� ���� ����/s
Data_IMU(:,2:4) = imu(:,4:6)./Ts;       % �Ӽ� ���� m/s

Result_AVP_Theory = zeros(L,10);
Result_AVP_Theory(:,1) = avp_theory(:,10);
Result_AVP_Theory(:,2:10) =  avp_theory(:,1:9);

Result_AVP_YGM_LC = zeros(L,10);
Result_AVP_YGM_LC(:,1) = avp_result_LC(:,10);
Result_AVP_YGM_LC(:,2:10) =  avp_result_LC(:,1:9);

G_Const = CONST_Init();

G_IMU.Hz = 100;  

% ���ó�ʼ��Ϣ
G_Start_Att = avp0_err(1:3);
G_Start_Vel = avp0_err(4:6);
G_Start_Pos = avp0_err(7:9);

[n,m] = size(Data_IMU);
Result_AVP = zeros(n,10);               %����Ľ�� ʱ�� ��̬ �ٶ� λ��
Result_AVP(1,1) = Data_IMU(1,1);      %ʱ��
Result_AVP(1,2:4) = G_Start_Att';       %��̬
Result_AVP(1,5:7) = G_Start_Vel';       %�ٶ�
Result_AVP(1,8:10) = G_Start_Pos';      %λ��

INSData_Now = INS_DataInit(G_Const,Result_AVP(1,1),G_Start_Att,G_Start_Vel,G_Start_Pos,Data_IMU(1,5:7)',Data_IMU(1,2:4)',Ts);
INSData_Pre = INSData_Now;

%KF�˲���ʼ��  KF_Init(mode,X0,P0,q0,r0)
mode=1; n=15; m=3;       %KFģʽ λ�÷���
X0 = zeros(n,1); 
P0=diag([davp0; imuerr.eb; imuerr.db]*10)^2;
q0=diag([imuerr.web; imuerr.wdb])^2;
r0=diag(davp0(7:9))^2;
KF = KF_Init(1,X0,P0,q0,r0);

XkPk = zeros(fix(L/G_IMU.Hz),31);
j=1;

IMUError_Bias = zeros(6,1);

% ���ߵ�����
for i=1:L
    INSData_Now.time = Data_IMU(i,1);    
    INSData_Now.w_ib_b = Data_IMU(i,5:7)'-IMUError_Bias(1:3,1);           
    INSData_Now.f_ib_b = Data_IMU(i,2:4)'-IMUError_Bias(4:6,1);
    
    INSData_Now = INS_Update(G_Const,INSData_Pre,INSData_Now,Ts);
    
    Result_AVP(i,1) = INSData_Now.time;      
    Result_AVP(i,2:4) = INSData_Now.att';
    Result_AVP(i,5:7) = INSData_Now.vel';
    Result_AVP(i,8:10) = INSData_Now.pos';
  
    %�ۻ����� KF ��Phi �� Q
    [Ft,Gt] = KF_Update_Ft(mode,INSData_Now);
    KF.Ft = Ft; KF.Gt = Gt;
    [Fk,Rk,Phikk_1,Qk_1] = KF_Update_C2D(mode,KF,Ts,3);
    KF.Fk = Fk;
    KF.Rk = Rk;
    KF.Phikk_1 = Phikk_1*KF.Phikk_1;
    KF.Qk_1 = KF.Qk_1+Qk_1;     
    
    %KF �˲� ����
    if mod(i,100)==0
        Zk = INSData_Now.pos-GPS(i,1:3)';
        KF = KF_Update_TM(mode,KF,Zk);
        
        % ��¼�˲�״̬
        XkPk(j,1) = INSData_Now.time;
        XkPk(j,2:16) = KF.Xk';
        for k=1:15
            XkPk(j,k+16) = KF.Pk(k,k);
        end        
        j=j+1;
        
        % ��¼���ݺͼӼ���ƫ
        IMUError_Bias = KF.Xk(10:15,1);
        
        % �ٶȷ���
        INSData_Now.vel = INSData_Now.vel - KF.Xk(4:6);
        KF.Xk(4:6)=zeros(3,1);
        % λ�÷���
        INSData_Now.pos = INSData_Now.pos - KF.Xk(7:9);
        KF.Xk(7:9)=zeros(3,1);   
        % ��̬����
        Phi = KF.Xk(1:3);
        INSData_Now.Q_b_n = Math_QmulQ(Att_Rv2Q(Phi),INSData_Now.Q_b_n);
        INSData_Now.C_b_n = Att_Q2DCM(INSData_Now.Q_b_n);
        INSData_Now.att = Att_DCM2euler(INSData_Now.C_b_n);
        KF.Xk(1:3)=zeros(3,1);  
        
        KF.Phikk_1 = eye(n);
        KF.Qk_1 = zeros(n,n);
        
        Result_AVP(i,2:4) = INSData_Now.att';
        Result_AVP(i,5:7) = INSData_Now.vel';
        Result_AVP(i,8:10) = INSData_Now.pos';        
        
        
    end   
    
    INSData_Pre =  INSData_Now;
end

% Plot_AVP(Result_AVP_Theory,Result_AVP);
Plot_AVP(Result_AVP_YGM_LC,Result_AVP);
