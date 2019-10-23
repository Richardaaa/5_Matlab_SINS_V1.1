% ADIS16467��ֹ���� KF ����
% �۲����ݰ��� λ�� �ٶ� 

clear;

load('trj10ms_imuerr.mat');
load('�ҽ����澲ֹ_20190716��2��.mat');
G_Const = CONST_Init();
G_IMU.Hz = 200;  
Ts = 1/G_IMU.Hz;  %�������50ms

[L,m] = size(Data_IMU_R);
%L = 200*30;

% ���ó�ʼ��Ϣ
G_Start_Att = [0.2*pi/180;0.2*pi/180;10*pi/180];
%G_Start_Att = [0;0;0];
G_Start_Vel = [0;0;0];
G_Start_Pos = [34.1*pi/180;114.1*pi/180;50];


Result_AVP = zeros(L,10);               %����Ľ�� ʱ�� ��̬ �ٶ� λ��
Result_AVP(1,1) = Data_IMU_R(1,1);      %ʱ��
Result_AVP(1,2:4) = G_Start_Att';       %��̬
Result_AVP(1,5:7) = G_Start_Vel';       %�ٶ�
Result_AVP(1,8:10) = G_Start_Pos';      %λ��

INSData_Now = INS_DataInit(G_Const,Result_AVP(1,1),G_Start_Att,G_Start_Vel,G_Start_Pos,Data_IMU_R(1,5:7)',Data_IMU_R(1,2:4)',Ts);
INSData_Pre = INSData_Now;

%KF�˲���ʼ��  KF_Init(mode,X0,P0,q0,r0)
%KFģʽ Mode=1 λ�÷��� 2 �ٶȷ��� 3 λ���ٶȷ��� 4 ˮƽ��̬ �ٶ� λ�� 5 ��̬(ˮƽ�Ӻ���Լ��) �ٶ� λ��
mode=4; n=15; m=3;      
X0 = [0.2*pi/180;0.2*pi/180;10*pi/180;0;0;0;0;0;0;0;0;0;0;0;0]; 
%X0 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0]; 
P0=diag([[0.5*pi/180;0.5*pi/180;1*pi/180;0.1;0.1;0.1;0.01/G_Const.earth_Re;0.01/G_Const.earth_Re;0.01]; imuerr.eb; imuerr.db])^2;
q0=diag([imuerr.web/sqrt(G_IMU.Hz); imuerr.wdb/sqrt(G_IMU.Hz)])^2;
%Mode_1 λ�÷���
%r0=diag([0.01/G_Const.earth_Re;0.01/G_Const.earth_Re;0.01])^2;
%Mode_2 �ٶȷ���  ���ٶȷ���ʱ��Ӧ�ÿ���ϵͳ״̬�����в�����λ�������Ϣ �Ժ���ʵ��
%r0=diag([0.01;0.01;0.01])^2;
%Mode_3 �ٶ�λ�÷���
%r0=diag([0.01;0.01;0.01;0.01/G_Const.earth_Re;0.01/G_Const.earth_Re;0.01])^2;
%Mode_4 ˮƽ��̬�ٶ�λ�÷���
r0=diag([0.2*pi/180;0.2*pi/180;0.01;0.01;0.01;0.01/G_Const.earth_Re;0.01/G_Const.earth_Re;0.01])^2;
%Mode_5 ��̬(ˮƽ+����Լ��)�ٶ�λ�÷���
%r0=diag([0.2*pi/180;0.2*pi/180;0.5*pi/180;0.01;0.01;0.01;0.01/G_Const.earth_Re;0.01/G_Const.earth_Re;0.01])^2;

KF = KF_Init(mode,X0,P0,q0,r0);

XkPk = zeros(L,31);
nTs = 10;
%XkPk = zeros(fix(L/nTs),37);
j=1;

IMUError_Bias = zeros(6,1);
%IMUError_Bias(1:3,1) = [-0.86e-3;0.73e-3;0.4e-3];
%  profile on
% ���ٶ��ۻ�
Vel_mean = zeros(L,6);

% ���ߵ�����
for i=1:L
    %���ü��ٶȼ��ۻ�ֵ����ˮƽ��̬���
    if i == 1
       Vel_mean(1,1) = Data_IMU_R(1,2);
       Vel_mean(1,2) = Data_IMU_R(1,3);
       Vel_mean(1,3) = Data_IMU_R(1,4);
       Vel_mean(1,4) = sqrt(Vel_mean(1,1)^2+Vel_mean(1,2)^2+Vel_mean(1,3)^2);
       Vel_mean(1,5) = asin(Vel_mean(1,2)/Vel_mean(1,4))*180/pi;
       Vel_mean(1,6) = -atan(Vel_mean(1,1)/Vel_mean(1,3));
    else
       Vel_mean(i,1) = (Vel_mean(i-1,1)*(i-1)+Data_IMU_R(i,2))/i;
       Vel_mean(i,2) = (Vel_mean(i-1,2)*(i-1)+Data_IMU_R(i,3))/i;
       Vel_mean(i,3) = (Vel_mean(i-1,3)*(i-1)+Data_IMU_R(i,4))/i;
       Vel_mean(i,4) = sqrt(Vel_mean(i,1)^2+Vel_mean(i,2)^2+Vel_mean(i,3)^2);
       Vel_mean(i,5) = asin(Vel_mean(i,2)/Vel_mean(i,4));
       Vel_mean(i,6) = -atan(Vel_mean(i,1)/Vel_mean(i,3));
    end
    
    INSData_Now.time = Data_IMU_R(i,1);    
    %INSData_Now.w_ib_b = Data_IMU_R(i,5:7)'-IMUError_Bias(1:3,1);           
    %INSData_Now.f_ib_b = Data_IMU_R(i,2:4)'-IMUError_Bias(4:6,1);
    INSData_Now.w_ib_b = Data_IMU_R(i,5:7)';           
    INSData_Now.f_ib_b = Data_IMU_R(i,2:4)';    
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
     %if mod(i,nTs)==0         
        %KF.Zk = INSData_Now.pos-G_Start_Pos;   %Mode_1 λ�÷��� 
        %KF.Zk(1:3,1) = INSData_Now.vel-G_Start_Vel;    %Mode_3 λ���ٶȷ��� 
        %KF.Zk(4:6,1) = INSData_Now.pos-G_Start_Pos;
        KF.Zk(1:2,1) = INSData_Now.att(1:2,1)-Vel_mean(i,5:6)';     %Mode_4 ˮƽ��̬λ���ٶȷ��� 
        KF.Zk(3:5,1) = INSData_Now.vel-G_Start_Vel;    
        KF.Zk(6:8,1) = INSData_Now.pos-G_Start_Pos;
%         KF.Zk(1:2,1) = INSData_Now.att(1:2,1)-Vel_mean(i,5:6)';     %Mode_5 ˮƽ��̬λ���ٶȷ��� 
%         KF.Zk(3,1) = INSData_Now.att(3,1) - 10*pi/180;
%         KF.Zk(4:6,1) = INSData_Now.vel-G_Start_Vel;    
%         KF.Zk(7:9,1) = INSData_Now.pos-G_Start_Pos;
        KF = KF_Update_TM(mode,KF,KF.Zk);
        
        % ��¼�˲�״̬
        XkPk(j,1) = INSData_Now.time;
        XkPk(j,2:16) = KF.Xk';
        for k=1:15
            XkPk(j,k+16) = KF.Pk(k,k);
        end                  
        
        % �ٶȷ���
        INSData_Now.vel = INSData_Now.vel - KF.Xk(4:6);
        %KF.Xk(4:6)=KF.Xk(4:6).*0.9;
        %INSData_Now.vel = G_Start_Vel;
        KF.Xk(4:6)=zeros(3,1);
        
        % λ�÷���
        INSData_Now.pos = INSData_Now.pos - KF.Xk(7:9);
        %KF.Xk(7:9)=KF.Xk(7:9).*0.9;
        %INSData_Now.pos = G_Start_Pos;
        KF.Xk(7:9)=zeros(3,1);   
        % ��̬����
        Phi = KF.Xk(1:3);
        %KF.Xk(1:3)=KF.Xk(1:3).*0.9;
        INSData_Now.Q_b_n = Math_QmulQ(Att_Rv2Q(Phi),INSData_Now.Q_b_n);
        INSData_Now.C_b_n = Att_Q2DCM(INSData_Now.Q_b_n);
        INSData_Now.att = Att_DCM2euler(INSData_Now.C_b_n);
        KF.Xk(1:3)=zeros(3,1);  
        %��ƫ����
        %IMUError_Bias = IMUError_Bias+KF.Xk(10:15,1);
        %IMUError_Bias(1:3,1) = [-0.86e-3;0.73e-3;0.4e-3];
        %KF.Xk(10:15,1) = zeros(6,1);
        %XkPk(j,32:37) = IMUError_Bias';
        
        KF.Phikk_1 = eye(n);
        KF.Qk_1 = zeros(n,n);
        
        Result_AVP(i,2:4) = INSData_Now.att';
        Result_AVP(i,5:7) = INSData_Now.vel';
        Result_AVP(i,8:10) = INSData_Now.pos';    
        j=j+1;  
     %end   
    
    INSData_Pre =  INSData_Now;
end
% profile viewer
% profile off
% Plot_AVP_Group(Result_AVP);
Plot_AVP_XkPk_Group(Result_AVP,XkPk);