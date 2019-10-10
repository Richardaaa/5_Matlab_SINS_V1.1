function KF = KF_Init(mode,X0,P0,q0,r0)
% ��ʼ��KF�˲����ݽṹ��
% ���� mode ģ������
% ����ϵͳ��
%  X(t)_Dot = F(t)*X(t) + G(t)*w(t)  w(t)�ķ���Ϊqt
%  Z(t) = H(t)*X(t)+v(t)             v(t)�ķ���Ϊrt
%
% ��ɢϵͳ��
%  Xk = Phikk_1*Xk_1 + Wkk_1   Wk�ķ���ΪQk_1
%  Zk = Hk*Xk + Vk                   Vk�ķ���ΪRk

% ���룺n ״̬����ά��; m �۲����ά��; k ϵͳ����ά��
if(mode == 1)
    % 15γ״̬�� ϵͳ���������ݺͼӼ���ƫ���۲�����λ�÷���
    n = 15;
    m = 3;
    k = 6;    
    KF.Gt = zeros(n,k);         
    KF.Hk = zeros(m,n); KF.Hk(1:3,7:9) = eye(3); 
    KF.qt = q0;         %����ϵͳ ϵͳ�����������
    KF.rt = r0;         %����ϵͳ �۲������������    
    KF.Rk = KF.rt;
end

% ��������
KF.Ft = zeros(n,n);         %����ϵͳ״̬ת�ƾ���

% ��ɢ����
KF.Xkk_1 = zeros(n,1);
KF.Xk = X0;
KF.Zk = zeros(m,1);
KF.Phikk_1 = eye(n);
KF.Pkk_1 = zeros(n,n);
KF.Pk = P0;
KF.Kk = zeros(n,m);
KF.Qk_1 = zeros(n,n);






