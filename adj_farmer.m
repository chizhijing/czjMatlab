clc
clear all
% % % % % % % % % % % % % % % % 变量初始化% % % % % % % % % % % % % % % % % % % 

time_step=10000;                                                            %迭代时间长度
Hs=0.88;                                                                    %Hurst指数
price=zeros(time_step,1);                                                   %初始化价格序列
price(1,1)=log(100);                                                        %初始化为对数价格
y_bid=zeros(time_step,1);                                                   %初始化买方订单编号为1的价格距离
y_ask=zeros(time_step,1);
A=1.12;                                                                     %订单取消过程参数
B=0.2;                                                                      %订单取消过程参数
best_bid=zeros(time_step,1);
best_ask=zeros(time_step,1);
spread=zeros(time_step,1);
% % % % % % % % % % % % % % % % % % % % % % %订单符号产生 % % % % % % % % % % % % 

FBM=wfbm(Hs,time_step);
order_sign=diff(FBM);

% % % % % % % % % % % % % % % % %初始化订单簿% % % % % % % % % % % % % % % 

[bid_orderBook,ask_orderBook,y_bid,y_ask]=InitBook(y_bid,y_ask);            %初始化订单簿，生成各3个报价
[E1,index1]=sortrows(bid_orderBook,-1);                                     %bid从高到低关联排序
[E2,index2]=sortrows(ask_orderBook,1);                                      %ask从低到高关联排序

%订单簿最优报价
best_bid(1,1)=E1(1,2);
best_ask(1,1)=E2(1,2);

bid_delta_0=best_ask(1,1)*ones(3,1)-bid_orderBook(index1,2);                %0时刻买方订单i的delta值，行表示订单编号，t表示时间
ask_delta_0=ask_orderBook(index1,2)-best_bid(1,1)*ones(3,1);                %0时刻卖方订单i的delta值，行表示订单编号，t表示时间

%时间循环前的参数预设
spread(1,1)=best_ask(1,1)-best_bid(1,1);                                         %当前价差
bid_num=3;
ask_num=3;


% % % % % % % % % % % % % % %time evolution % % % % % % % % % % % % % % % % % % % % % % 

for i=2:time_step
    
   price_distance=trnd(1.31)/100;                                           %产生对数价差
   
% % % % % % % % % % % % % 订单类型判断及限价、市场订单的产生、交易% % % % % % % % % % % % % 

 if order_sign(1,i-1)>0                                                     %买入：+1
        if price_distance<spread                                            %买入限价订单
            bid_num=bid_num+1;                                              %买入限价订单号加1
            bid_orderBook=[ bid_orderBook;bid_num  best_bid(i,1)+price_distance];
            y_bid(i,bid_num)=1;                                             %产生初始y值
        else                                                                %产生买入市场订单
             if ask_orderBook>2                                             %要求订单簿中的卖出限价订单簿数量大于2，否则为无效市场订单
                 ask_orderBook(index2(1),:)=[];
             end
        end
 else                                                                       %卖出：-1
     if price_distance<spread                                               %卖出限价订单
         ask_num=ask_num+1;                                                 %卖出限价订单号加1
         ask_orderBook=[ask_orderBook;ask_num  best_ask(i,1)-price_distance];
         y_ask(i,ask_num)=1;
     else                                                                   %产生卖出市场订单
         if bid_orderBook>2                                                 %要求订单簿中的买入限价订单簿数量大于2，否则为无效市场订单
             bid_orderBook(index1(1),:)=[];
         end
     end
 end
 
% % % % % % % % % % % % % % % % % % 订单取消过程% % % % % % % % % % % % % % % % % % % % % % % % %

BidLen=length(bid_orderBook);
AskLen=length(ask_orderBook);

y_bid(i,:)=(best_ask(i,1)*ones(BidLen,1)-bid_orderBook(:,2))./bid_delta_0;  %买单时刻t的y值
y_ask(i,:)=(ask_orderBook(:,2)-best_bid(i,1)*ones(AskLen,1))./ask_delta_0;  %卖单时刻t的y值

Bidnimb=BidLen/(BidLen+AskLen);                                             %买单不平衡
Asknimb=AskLen/(BidLen+AskLen);                                             %卖单不平衡

BidOrderCancleProb=A*(ones(BidLen,1)-exp(-y_bid(i,:)))*(Bidnimb+B)/(BidLen+AskLen);
AskOrderCancleProb=A*(ones(AskLen,1)-exp(-y_ask(i,:)))*(Asknimb+B)/(BidLen+AskLen);
[row,col]=find(rand(BidLen,1)>BidOrderCancleProb);
bid_orderBook(row,:)=[];
[row,col]=find(rand(AskLen,1)>AskOrderCancleProb);
ask_orderBook(row,:)=[];

% % % % % % % % % % % % % % % % % %市场清算% % % % % % % % % % % % % % % % % % % % % % % % % % %

[E1,index1]=sortrows(bid_orderBook,-1);                                    %bid从高到低排序
[E2,index2]=sortrows(ask_orderBook,-1);                                    %ask从低到高排序
best_ask(i,1)=E1(1,2);
best_bid(i,1)=E2(1,2);
spread(i,1)=best_ask(i+1,1)-best_bid(i+1,1);                                        %当前价差

price(i,1)=0.5*(best_ask(i,1)+best_bid(i,1));                               %t时刻的市场价格



end