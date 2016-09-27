clc
clear all
Nr=100;%随机投资者人数
alpa=3;
nanda=4;
Nm=alpa*sqrt(Nr);%基本面投资者数
p0=1;%初始市场价格
x_t=60000;%时间序列
x_price=zeros(x_t,2);
x=randi([0,1],Nr,1);%随机生成初始时刻的0-1伯努利分布
 for i=1:Nr
    if x(i,1)==0
        x(i,1)=-1;
     end
 end
 x_price(1,1)=1;
 x_price(1,2)=p0;
 sigema=sqrt(Nr);%随机交易者产生的标准差
for i=2:x_t
   demand=sum(x);%t-1时刻市场超额需求
   if demand/sigema>=nanda
       y=ones(Nm,1);%全体基本面投资者买入
   elseif demand/sigema<=(-1)*nanda
       y=(-1).*ones(Nm,1);%全体基本面投资者卖出
   elseif abs(demand/sigema)<nanda
       y=zeros(Nm,1);
   end
   x_price(i,1)=i;
   x_price(i,2)=x_price(i-1,2)+sum(x)+sum(y);%市场价格  
   x=randi([0,1],Nr,1);%随机生成t时刻的0-1伯努利分布
    for j=1:Nr
        if x(j,1)==0
            x(j,1)=-1;
        end
    end
   
end
 figure;
 plot(x_price(:,1),x_price(:,2));
                
        
