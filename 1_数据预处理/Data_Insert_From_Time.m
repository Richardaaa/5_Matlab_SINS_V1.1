function InsertData = Data_Insert_From_Time(First,Second,Time)
%��һ����ʱ�䣬���������� û��ʱ���־λ 
[L,m] = size(First);
InsertData = zeros(1,m);
InsertData(1,1) = Time;
InsertData(1,2:m) = (Second(1,2:m)-First(1,2:m)).*((Time-First(1,1))/(Second(1,1)-First(1,1)))+First(1,2:m);
