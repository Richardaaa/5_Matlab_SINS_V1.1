function [Second,SerialNum] = DataPrepare_IMUData_FindSecondSerial(mData,mSecond)
% 1.���������ж�Ӧ�������ʼλ��
[L,m] = size(mData);

for i = 1:L
       %û�ҵ��������Ч������
       if ( mData(i,1) > mSecond)
           mSecond = mSecond + 1;
       end
       if  (mData(i,1) == mSecond)&&(mData(i,m)==1)
           %�ҵ�����������
           Second = mSecond;
           SerialNum = i;
           return;
       end
end

%�������ݶ�û�ҵ���Ч���������
SerialNum = 0;

