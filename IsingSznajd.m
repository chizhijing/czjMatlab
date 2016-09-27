clc
clear all
N=2000;%投资者总数
n=10;%基本面投资者数
x_t=7000;%时间序列
x_price=zeros(x_t,2);
x=randi([0,1],N,1);%随机生成初始时刻的0-1伯努利分布
for i=1:N
    if x(i,1)==0
        x(i,1)=-1;
    end
end
for i=1:x_t
    BasePosition=randi([1,N],n,1);%随机决定基本面投资者的位置
    for j=1000:-2:2%信息从中心开始往左传递
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

  
    for j=1001:2:1999%信息从中心开始往左传递
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
                
        
