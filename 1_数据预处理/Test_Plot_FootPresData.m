%% ʱ�����󣬻������ѹ�������������� �Ӽ����ݣ�������ʾ
%  ѹ��������˳��'�Ÿ��ڲ�6','�Ÿ����7','�����ڲ�5','�������2'

%ԭʼѹ����Ϣ�ıȽϣ���ʱѹ����ֵ����Ļ��ǵ�ѹ
figure;
plot(FootPres(:,1),FootPres(:,2),'k');  %���ѹ��x
hold on; plot(FootPres(:,1),FootPres(:,3),'r');
hold on; plot(FootPres(:,1),FootPres(:,4),'g');
hold on; plot(FootPres(:,1),FootPres(:,5),'b');
xlabel('\it t \rm / s');       
title('�ŵ�ѹ��+����X+���ٶȼ�Z');
legend('�Ÿ��ڲ�','�Ÿ����','�����ڲ�','�������');
grid on;

hold on;plot(IMU(:,1),IMU(:,4)*10+990,'-.');  %�Ӽ�

hold on;plot(IMU(:,1),IMU(:,5)*50+1000,'-.');  %����




