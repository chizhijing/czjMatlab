clc
clear all;
% % % % % % % % % % % % 全局变量初始化 % % % % % % % % % % % % % % % % % % % % %
time_step=10000;                                                 %迭代时间长度
initial_price=log(100);                                          %初始价格
bid_orderBook=zeros(2,time_step);                                %买价限价订单簿
ask_orderBook=zeros(2,time_step);                                %卖价限价订单簿
order_sign=zeros(1,time_step);                                   %订单符号
price_distance=0;                                                %t分布产生的价格差
price=ones(time_step,1)*initial_price;                           %价格序列
yi_bid=zeros(1,time_step);                                       %价格滑移指数
yi_ask=zeros(1,time_step);
imb_buy=0;                                                       %买方市场不平衡
imb_sell=0;                                                      %卖方市场不平衡
best_bid=0;                                                      %最优买价
best_ask=0;                                                      %最优卖价
Hs=0.88;                                                         %Hurst指数
a=1;                                                             %t分布自由度
s=0;                                                             %spread
delta_buy0=zeros(1,time_step);delta_buy=zeros(1,time_step);                                      %0和t时刻，bid price和最佳价格的距离
delta_sell0=zeros(1,time_step);delta_sell=zeros(1,time_step);                                    %0和t时刻，ask price和最佳价格的距离
alphabet=[-1 1];
prob=0;
A=0;
B=0;
N=0;
s0=zeros(1,1);


% % % % % % % % % % % % %订单符号产生% % % % % % % % % % % % % % % % % % % % %
FBM=wfbm(Hs,time_step);
for m=1:time_step-1
    order_sign(1,m)=FBM(1,m+1)-FBM(1,m);%??最后一个信号为0
end

% % % % % % % % % % % % %构建初始订单簿% % % % % % % % % % % % % % % % % % % % %
l=1;m=1;
while l<4||m<4                                      %买卖订单簿中限价订单数量小于2
    price_distance=trnd(1.31)/1000;
    if price_distance>0
        bid_orderBook(1,l)=initial_price-price_distance;
        bid_orderBook(2,l)=l;l=l+1;         %订单编号记录
    end
    price_distance=trnd(1.31)/1000;
    if price_distance>0
        ask_orderBook(1,m)=initial_price+price_distance;
        ask_orderBook(2,m)=m;m=m+1;
    end
end
a=bid_orderBook';a=sortrows(a,-1);
bid_orderBook=a';best_bid=bid_orderBook(1,1);           %bid订单价格从高到低排序
b=ask_orderBook';b=sortrows(b,1);
ask_orderBook=b';j=1;
while ask_orderBook(1,j)==0
    j=j+1;
end
best_ask=ask_orderBook(1,j);            %ask订单价格从低到高排序
s=ask_orderBook(1,j)-bid_orderBook(1,1);            %当前的差价
for x=1:l-1
    s0=bid_orderBook(1,find(bid_orderBook(2,:)==x));
    delta_buy0(1,x)=best_ask-s0;         %记录初始时刻的delta
end

for y=1:m-1
    s0=ask_orderBook(1,find(ask_orderBook(2,:)==y));
    delta_sell0(1,y)=s0-best_bid;
end


% % % % % % % % % % % % %time evolution% % % % % % % % % % % % % % % % % % % % %
for i=2:time_step
    % % % % % % % % % % % % 局部变量初始化 % % % % % % % % % % % % % % % % % % % % %
    price(i,1)=price(i-1,1);
    price_distance=trnd(1.31)/1000;
    % % % % % % % % % % % % % 订单类型判断及限价、市场订单的产生、交易% % % % % % % % % % % % % % % % % % % % %
    if order_sign(1,i)>0                                 %买入：+1
        if price_distance<s                              %买入限价订单
            bid_orderBook(1,l)=best_bid+price_distance;
        else                                             %产生买入市场订单，并判断卖出限价订单簿数量是否大于2
            if ask_orderBook<3                           %卖出限价订单簿数量小于2
                delta_sell0=[delta_sell0,ask_orderBook(1,find(ask_orderBook(2,:)==m))-best_bid];
                ask_orderBook(1,m)=best_ask-price_distance;
                ask_orderBook(2,m)=m;m=m+1;
            else                                         %卖出限价订单簿数量大于2
                price(i,1)=ask_orderBook(1,1);                 %新价格记录
                ask_orderBook(1,1)=0;                         %删除已成交的订单
            end
        end
    else                                                 %卖出：-1
        if price_distance<s                              %卖出限价订单
            ask_orderBook(1,m)=best_ask+price_distance;
        else                                             %产生卖出市场订单，并判断买入限价订单簿数量是否大于2
            if bid_orderBook<3 %买入限价订单簿数量小于2
                delta_buy0=[delta_buy0,bid_orderBook(1,best_ask-find(bid_orderBook(2,:)==l))];
                bid_orderBook(1,l)=best_bid+price_distance;
                bid_orderBook(2,l)=l;l=l+1;
            else                                         %买入限价订单簿数量大于2
                price(i,1)=bid_orderBook(1,1);                 %新价格记录
                bid_orderBook(1,1)=0;                         %删除已成交的订单
            end
        end
    end
    
    % % % % % % % % % % % % 订单取消过程 % % % % % % % % % % % % % % % % % % % % %
    s=0;
    for x=1:l
        r=bid_orderBook(1,find(bid_orderBook(2,:)==x));
        if r~=0
            s=s+1;
        end
    end
    imb_buy=s;s=0;
    for y=1:m
        t=ask_orderBook(1,find(ask_orderBook(2,:)==y));
        if t~=0
            s=s+1;
        end
    end
    imb_sell=s;
    N=imb_buy+imb_sell;
    for x=1:l
        r=bid_orderBook(1,find(bid_orderBook(2,:)==x));
        yi_bid=[yi_bid];
        if r~=0
            delta_buy(1,x)=best_ask-r;
            if delta_buy0(1,y)~=0
                yi_bid(1,x)=delta_buy(1,x)/delta_buy0(1,x);
                prob=A*(1-exp(-yi_bid(1,x)))*(imb_buy+B)/N;
                if randsrc(1,1,[alphabet;prob 1-prob])<0
                    bid_orderBook(1,find(bid_orderBook(2,:)==x))=0;
                end
            end
        end
    end
    for y=1:m
        t=ask_orderBook(1,find(ask_orderBook(2,:)==y));
        yi_ask=[yi_ask];
        if t~=0
            delta_sell(1,y)=t-best_bid;
            if delta_sell0(1,y)~=0
                yi_ask(1,y)=delta_buy(1,y)/delta_sell0(1,y);
                prob=A*(1-exp(-yi_ask(1,y)))*(imb_sell+B)/N;
                if randsrc(1,1,[alphabet;prob 1-prob])<0
                    ask_orderBook(1,find(ask_orderBook(2,:)==y))=0;
                end
            end
        end
    end
    a=bid_orderBook';a=sortrows(a,-1);
    bid_orderBook=a';best_bid=bid_orderBook(1,1);           %bid订单价格从高到低排序
    b=ask_orderBook';b=sortrows(b,1);
    s=ask_orderBook(1,j)-bid_orderBook(1,1);
end
plot((1:time_step)',price);


