function NewData = Data_Insert_From_Start_End(First,Second,Number)
%���������յ㣬���� Number�����ݲ�ֵ ���Բ�ֵ
%��һ��Ϊʱ��  ����Ϊ���� ���һ��Ϊʱ��״̬
[L,m] = size(First);
NewData = zeros(Number,m);
%��ֵ�ķ�Χ�� �ӵ�3�� �� ������2��
%1.����ʱ����
DistanceTime = Second(1,1) - First(1,1);
DistanceData = Second(1,2:m-1) - First(1,2:m-1);
for i = 1:Number
    %ʱ�����
    NewTime = First(1,1)+DistanceTime*i/(Number+1);
    NewData(i,1) = NewTime;
    %���ݸ���
    NewData(i,2:m-1) = First(1,2:m-1) + DistanceData.*(i/(Number+1));
end
    