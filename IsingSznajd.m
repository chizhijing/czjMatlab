clc
clear all
N=2000;%Ͷ��������
n=10;%������Ͷ������
x_t=7000;%ʱ������
x_price=zeros(x_t,2);
x=randi([0,1],N,1);%������ɳ�ʼʱ�̵�0-1��Ŭ���ֲ�
for i=1:N
    if x(i,1)==0
        x(i,1)=-1;
    end
end
for i=1:x_t
    BasePosition=randi([1,N],n,1);%�������������Ͷ���ߵ�λ��
    for j=1000:-2:2%��Ϣ�����Ŀ�ʼ���󴫵�
        if  find(BasePosition==j)
            if (sum(x)-x(j,1))/N-1>0
                x(j,1)=-1;
            else
                x(j,1)=1;
            end
        elseif x(j,1)*x(j+1,1)==1
                x(j+2,1)=x(j,1);
                x(j-1,1)=x(j,1);
        elseif x(j,1)*x(j+1,1)==-1
               x(j+2,1)=randi([0,1],1,1);
               x(j-1,1)=randi([0,1],1,1);
               if x(j+2,1)==0
                  x(j+2,1)=-1;
               end
               if x(j-1,1)==0
                  x(j-1,1)=-1;
               end
         end
     end

  
    for j=1001:2:1999%��Ϣ�����Ŀ�ʼ���󴫵�
        if  find(BasePosition==j)
            if (sum(x)-x(j,1))/N-1>0
                x(j,1)=-1;
            else
                x(j,1)=1;
            end
        elseif x(j,1)*x(j+1,1)==1
                x(j+2,1)=x(j,1);
                x(j-1,1)=x(j,1);
        elseif x(j,1)*x(j+1,1)==-1
               x(j+2,1)=randi([0,1],1,1);
               x(j-1,1)=randi([0,1],1,1);
               if x(j+2,1)==0
                  x(j+2,1)=-1;
               end
               if x(j-1,1)==0
                  x(j-1,1)=-1;
               end
         end
    end
  x_price(i,1)=i;
  x_price(i,2)=sum(x)/N;
end
 figure;
 plot(x_price(:,1),x_price(:,2));
                
        
