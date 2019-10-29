% ��IMU���в����ı�У
%    ���������ٶȼƵ� �������ӡ���������������ֵ��ƫ
%
%


% �� ��20191028_ADIS�廪����Ԥ�Ⱥ�6λ�����ݲɼ�.mat�����ݽ��б�У����
Data_IMU = Data_IMUB_L;

% Ԥ��20���Ӻ󣬽���6λ�����ݲɼ���˳��Ϊ
% X������ X������ Y������ Y������ Z������ Z������
% �ֱ��趨 ÿ�׶����ɼ����ݵ���ʼ�ͽ���ʱ��
Temp_X_Up_Start = 14000;    Temp_X_Up_End = Temp_X_Up_Start + 119999;
Temp_X_Down_Start = 182000;  Temp_X_Down_End = Temp_X_Down_Start + 119999;
Temp_Y_Up_Start = 343000;    Temp_Y_Up_End = Temp_Y_Up_Start + 119999;
Temp_Y_Down_Start = 576000;  Temp_Y_Down_End = Temp_Y_Down_Start + 119999;
Temp_Z_Up_Start = 720400;    Temp_Z_Up_End = Temp_Z_Up_Start + 119999;
Temp_Z_Down_Start = 930000;  Temp_Z_Down_End = Temp_Z_Down_Start + 119999;

% ����ϵ������
Temp_Pos = [40.003575*pi/180;116.337489*pi/180;20]; 
% ���㵱��������ֵ
G_Const = CONST_Init();
g_n = Earth_get_g_n(G_Const,Temp_Pos(1,1),Temp_Pos(3,1));
gn = -g_n(3,1);

%����6�ι۲�Ĺ۲���
a1=[gn;0;0;1];  a2=[-gn;0;0;1];
a3=[0;gn;0;1];  a4=[0;-gn;0;1];
a5=[0;0;gn;1];  a6=[0;0;-gn;1];
A = [a1,a2,a3,a4,a5,a6];

%����6�β�����
u1=[mean(Data_IMU(Temp_X_Up_Start:Temp_X_Up_End,2));
    mean(Data_IMU(Temp_X_Up_Start:Temp_X_Up_End,3));
    mean(Data_IMU(Temp_X_Up_Start:Temp_X_Up_End,4))];
u2=[mean(Data_IMU(Temp_X_Down_Start:Temp_X_Down_End,2));
    mean(Data_IMU(Temp_X_Down_Start:Temp_X_Down_End,3));
    mean(Data_IMU(Temp_X_Down_Start:Temp_X_Down_End,4))];
u3=[mean(Data_IMU(Temp_Y_Up_Start:Temp_Y_Up_End,2));
    mean(Data_IMU(Temp_Y_Up_Start:Temp_Y_Up_End,3));
    mean(Data_IMU(Temp_Y_Up_Start:Temp_Y_Up_End,4))];
u4=[mean(Data_IMU(Temp_Y_Down_Start:Temp_Y_Down_End,2));
    mean(Data_IMU(Temp_Y_Down_Start:Temp_Y_Down_End,3));
    mean(Data_IMU(Temp_Y_Down_Start:Temp_Y_Down_End,4))];
u5=[mean(Data_IMU(Temp_Z_Up_Start:Temp_Z_Up_End,2));
    mean(Data_IMU(Temp_Z_Up_Start:Temp_Z_Up_End,3));
    mean(Data_IMU(Temp_Z_Up_Start:Temp_Z_Up_End,4))];
u6=[mean(Data_IMU(Temp_Z_Down_Start:Temp_Z_Down_End,2));
    mean(Data_IMU(Temp_Z_Down_Start:Temp_Z_Down_End,3));
    mean(Data_IMU(Temp_Z_Down_Start:Temp_Z_Down_End,4))];
U = [u1,u2,u3,u4,u5,u6];

%�����ٶȼ�У׼����
M = U*A'*(A*A')^-1;