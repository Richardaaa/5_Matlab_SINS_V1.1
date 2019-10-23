% ADIS16467��ֹ���� KF ����
% ���Խ�ʹ��80���������ڵĹ��ƴ�����

profile on

%% 1.��ȡ����
    clear;
    load('�ҽ����澲ֹ_20190716��2��_��ȡ������.mat');
    
%% 2.��ʼ������
%% 2.1 ȫ�ֲ���
    G_Const = CONST_Init();
    G_IMU.Hz = 200;  
    Ts = 1/G_IMU.Hz;  %�������50ms
    [L,m] = size(Data_IMU_R);
%% 2.2 �����Ϣ
    G_Start_Att = [0.065*pi/180;-0.37*pi/180;10*pi/180];
    G_Start_Vel = [0;0;0];
    G_Start_Pos = [34.1*pi/180;114.1*pi/180;50];
%% 2.3 ������Ʋ�������
    %(1)����ʱ��
    L = 80*1000;
    %(2)KFģ�Ͳ���
    KF_switch = 1;  %1 ����KF�˲���0 ������KF�˲�
    %KFģʽ Mode=1 λ�÷��� 2 �ٶȷ��� 3 λ���ٶȷ��� 4 ˮƽ��̬ �ٶ� λ�� 5 ��̬(ˮƽ�Ӻ���Լ��) �ٶ� λ��
    mode = 3;     %ģ��ѡ�� 
    nTs = 1;      %KF�˲����ڣ���λ�ǲ�������  1s�˲��� 200 
    BackCoef = 0.5;   %KF�˲���������ϵ�� 0.0~1.0 0.0��������1.0ȫ����
    %(3)IMU��������
    imuerr.eb = [2.5;2.5;2.5].*pi/180/3600;     %������ƫ ��/h;  �����ֲ��� ת��Ϊ rad/s
    imuerr.db = [13;13;13].*1e-6*9.7803267714;  %�Ӽ���ƫ ug;    �����ֲ��� ת��Ϊ m/s
    imuerr.web = [0.15;0.15;0.15].*pi/180/sqrt(3600);    %���ݽǶ��������ARW du/sqrt(h) �����ֲ��� ת��Ϊ rad/s
    imuerr.wdb = [0.037;0.037;0.037]./sqrt(3600);    %�Ӽ��ٶ��������VRW m/s/sqrt(h) �����ֲ��� ת��Ϊ m/s
%% 2.4 ��ʼ��    
    %(1)�ߵ�����ṹ���ʼ�� 
    INSData_Now = INS_DataInit(G_Const,Data_IMU_R(1,1),G_Start_Att,G_Start_Vel,G_Start_Pos,[0;0;0],[0;0;0],Ts);
    INSData_Pre = INSData_Now;

    %(2)KF�˲���ʼ��
    X0 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0]; 
    P0=diag([0.5*pi/180;0.5*pi/180;1*pi/180;
                1e-2;1e-2;1e-2;
                1e-2/G_Const.earth_Re;1e-2/G_Const.earth_Re;1e-2; 
                imuerr.eb; 
                imuerr.db])^2;
    q0=diag([imuerr.web; imuerr.wdb])^2;
    switch mode
        case 1
            %Mode_1 λ�÷���
            r0=diag([0.01/G_Const.earth_Re;0.01/G_Const.earth_Re;0.01])^2;
        case 2
            %Mode_2 �ٶȷ���  ���ٶȷ���ʱ��Ӧ�ÿ���ϵͳ״̬�����в�����λ�������Ϣ �Ժ���ʵ��
            r0=diag([0.01;0.01;0.01])^2;
        case 3
            %Mode_3 �ٶ�λ�÷���
            r0=diag([1e-3;1e-3;1e-3;
                    1e-4/G_Const.earth_Re;1e-4/G_Const.earth_Re;1e-4])^2;
        case 4
            %Mode_4 ˮƽ��̬�ٶ�λ�÷���
            r0=diag([0.2*pi/180;0.2*pi/180;
                    0.01;0.01;0.01;
                    0.01/G_Const.earth_Re;0.01/G_Const.earth_Re;0.01])^2;
        case 5
            %Mode_5 ��̬(ˮƽ+����Լ��)�ٶ�λ�÷���
            r0=diag([0.2*pi/180;0.2*pi/180;0.5*pi/180;
                    0.01;0.01;0.01;
                    0.01/G_Const.earth_Re;0.01/G_Const.earth_Re;0.01])^2;                
    end
    %KF�ṹ���ʼ��
    KF = KF_Init(mode,X0,P0,q0,r0);

    %(3)���������ݿռ�����
    %������ݴ��
    Result_AVP = zeros(L,10);               %����Ľ�� ʱ�� ��̬ �ٶ� λ��      
    %KF�˲���������ṹ��
    XkPk = zeros(fix(L/nTs),31);
    j=1;
        
%% 3.�������
    for i=1:L
    %(1)��ȡIMUԭʼ����
        INSData_Now.time = Data_IMU_R(i,1);    
        INSData_Now.w_ib_b = Data_IMU_R(i,5:7)';           
        INSData_Now.f_ib_b = Data_IMU_R(i,2:4)';  
        
    %(2)���ݺͼӼ���ƫ����
        %INSData_Now.w_ib_b = Data_IMU_R(i,5:7)'-IMUError_Bias(1:3,1);           
        %INSData_Now.f_ib_b = Data_IMU_R(i,2:4)'-IMUError_Bias(4:6,1);
        
    %(3)�ߵ�����
        INSData_Now = INS_Update(G_Const,INSData_Pre,INSData_Now,Ts);
                    
    %Test
%     INSData_Now.att = G_Start_Att;
%     INSData_Now.C_b_n = Att_Euler2DCM(INSData_Now.att);
%     INSData_Now.Q_b_n = Att_DCM2Q(INSData_Now.C_b_n);
        
    %(4)���浼�����
        Result_AVP(i,1) = INSData_Now.time;      
        Result_AVP(i,2:4) = INSData_Now.att';
        Result_AVP(i,5:7) = INSData_Now.vel';
        Result_AVP(i,8:10) = INSData_Now.pos';     
        
    %(5)����KF�˲�����Ĳ���
        [KF.Ft,KF.Gt] = KF_Update_Ft(mode,INSData_Now);
        [KF.Fk,KF.Rk,Phikk_1,Qk_1] = KF_Update_C2D(mode,KF,Ts,3);
        KF.Phikk_1 = Phikk_1*KF.Phikk_1;
        KF.Qk_1 = KF.Qk_1+Qk_1;   
        
    %(6)KF���¼���
    if (KF_switch == 1)&&(mod(i,nTs)==0)
        %���ݲ�ͬģ��ѡ��ͬ�۲���
        switch mode
            case 1 %λ�� �۲�
                KF.Zk = INSData_Now.pos-G_Start_Pos;
            case 2 %�ٶ� �۲�
                KF.Zk = INSData_Now.vel-G_Start_Vel;  
            case 3 %�ٶȡ�λ�� �۲�
                KF.Zk(1:3,1) = INSData_Now.vel-G_Start_Vel;    
                KF.Zk(4:6,1) = INSData_Now.pos-G_Start_Pos;
            case 4 %ˮƽ��̬���ٶȡ�λ�� �۲�
                %KF.Zk(1:2,1) = INSData_Now.att(1:2,1)-Vel_mean(i,5:6)';     
                KF.Zk(3:5,1) = INSData_Now.vel-G_Start_Vel;    
                KF.Zk(6:8,1) = INSData_Now.pos-G_Start_Pos;
            case 5 %ˮƽ��̬������Լ�����ٶȡ�λ�� �۲�
                %KF.Zk(1:2,1) = INSData_Now.att(1:2,1)-Vel_mean(i,5:6)';    
                KF.Zk(3,1) = INSData_Now.att(3,1) - 10*pi/180;
                KF.Zk(4:6,1) = INSData_Now.vel-G_Start_Vel;    
                KF.Zk(7:9,1) = INSData_Now.pos-G_Start_Pos;                   
        end
        
        %KF�˲�����
        KF = KF_Update_TM(mode,KF,KF.Zk);        
        
        %KF��������
        XkPk(j,1) = INSData_Now.time;
        XkPk(j,2:16) = KF.Xk';
        for k=1:15
            XkPk(j,k+16) = KF.Pk(k,k);
        end      
        
        %��̬����
        Phi = KF.Xk(1:3).*BackCoef;
        KF.Xk(1:3) = KF.Xk(1:3) - KF.Xk(1:3).*BackCoef;        
        INSData_Now.Q_b_n = Math_QmulQ(Att_Rv2Q(Phi),INSData_Now.Q_b_n); 
        INSData_Now.C_b_n = Att_Q2DCM(INSData_Now.Q_b_n);
        INSData_Now.att = Att_DCM2euler(INSData_Now.C_b_n);
        %�ٶȷ���
        INSData_Now.vel = INSData_Now.vel - KF.Xk(4:6).*BackCoef;
        KF.Xk(4:6) = KF.Xk(4:6) - KF.Xk(4:6).*BackCoef;
        %λ�÷���
        INSData_Now.pos = INSData_Now.pos - KF.Xk(7:9).*BackCoef;
        KF.Xk(7:9) = KF.Xk(7:9) - KF.Xk(7:9).*BackCoef; 
        %������ƫ����
        INSData_Now.eb = INSData_Now.eb + KF.Xk(10:12).*BackCoef;
        KF.Xk(10:12) = KF.Xk(10:12) - KF.Xk(10:12).*BackCoef;
        %�Ӽ���ƫ����
        INSData_Now.db = INSData_Now.db + KF.Xk(13:15).*BackCoef;
        KF.Xk(13:15) = KF.Xk(13:15) - KF.Xk(13:15).*BackCoef;        

        %��¼�µĵ����������
        Result_AVP(i,2:4) = INSData_Now.att';
        Result_AVP(i,5:7) = INSData_Now.vel';
        Result_AVP(i,8:10) = INSData_Now.pos';   
        
        %�������ں󣬲�������
        n = length(KF.Phikk_1);
        KF.Phikk_1 = eye(n);
        KF.Qk_1 = zeros(n,n);
        j=j+1;
    end        
        
    %(6)���µ�������
        INSData_Pre =  INSData_Now;
    end
    
profile viewer
profile off
    
%% 4.���ݻ�ͼ
    %Plot_AVP_Group(Result_AVP);
    Plot_AVP_XkPk_Group(Result_AVP0,XkPk0);
