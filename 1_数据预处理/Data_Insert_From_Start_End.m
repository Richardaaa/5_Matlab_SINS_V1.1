

function NewData = Data_Insert_From_Start_End(First,Second,Number)
%���������յ㣬���� Number�����ݲ�ֵ
[L,m] = size(First);
NewData = zeros(Number,m);
%��ֵ�ķ�Χ�� �ӵ�3�� �� ������2��
%1.����ʱ����
DistanceTime = Second(1,1)+Second(1,2)/1000.0 - First(1,1)-First(1,2)/1000.0;
DistanceData = Second(1,3:m-1) - First(1,3:m-1);
for i = 1:Number
    %ʱ�����
    NewTime = (First(1,1)+First(1,2)/1000.0)+DistanceTime*i/(Number+1);
    NewData(i,1) = fix(NewTime);
    NewData(i,2) = round((NewTime-NewData(i,1))*1000);
    %���ݸ���
    NewData(i,3:m-1) = First(1,3:m-1) + DistanceData.*(i/(Number+1));
end
    