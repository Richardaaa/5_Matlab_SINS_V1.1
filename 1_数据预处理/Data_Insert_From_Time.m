function InsertData = Data_Insert_From_Time(First,Second,Time)
%��һ����ʱ�䣬���������� ���һ��Ϊʱ���
InserData = [];
if abs(Time-First(1,1))<0.00001   %0.01ms
    InserData = First;
    InserData(1,1) = Time;
    return;
end
if abs(Time-Second(1,1))<0.00001   %0.01ms
    InserData = Second;
    InserData(1,1) = Time;
    return;
end
if (First(1,1) < Time) && (Time < Second(1,1))
    [L,m] = size(First);
    InsertData = zeros(1,m);
    InsertData(1,1) = Time;
    InsertData(1,2:m) = (Second(1,2:m)-First(1,2:m)).*((Time-First(1,1))/(Second(1,1)-First(1,1)))+First(1,2:m);
else
    return;
end