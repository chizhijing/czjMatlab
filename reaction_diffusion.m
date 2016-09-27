clc
clear all;
N=500;                                                      %噪声交易者的人数
p_UpBound=100;                                              %价格的上界
bid_price=randi([0,floor(p_UpBound/2)],floor(N/2),1);       %初始化买价
ask_price=randi([ceil(p_UpBound/2),p_UpBound],ceil(N/2),1); %初始化卖价
T=1000;                                                     %时间长度
price=zeros(T,1);                                           %价格列向量
for t=1:T
    temp_price=[];
    
    for k=1:(N/2)
        bid_price(k)=bid_price(k)+(-1)^(random('bino',1,0.5));  %买价变动
        ask_price(k)=ask_price(k)+(-1)^(random('bino',1,0.5));  %卖价变动
        if bid_price(k)>p_UpBound/2 || bid_price(k)<0
             bid_price(k)=randi([0,floor(p_UpBound/2)]);
        end
        if ask_price(k)>p_UpBound || asd_price(k)<p_UpBound/2
            ask_price(k)=randi([ceil(p_UpBound/2),p_UpBound]);
        end
    end
    
    for i=1:(N/2)
      [row,col]=find(ask_price==bid_price(i));
            temp_price=[temp_price bid_price(i)];
            bid_price(i)=0;
            bid_price(j)=p_UpBound;
    end
    price(t,1)=mean(temp_price); 
end
