clc
clear all;
% % % % % % % % % % % % 全局变量初始化 % % % % % % % % % % % % % % % % % % % % %
time_step=10000;                                                 %迭代时间长度
init_price=100;                                                  %初始价格
bid_orderBook=[];                                                %买价限价订单簿
ask_orderBook=[];                                                %卖价限价订单簿
delta_max=4;                                                     %最大的delta值
price=ones(time_step,1)*init_price;                              %价格序列
ql0=0.5;                                                         %提交限价订单的概率

for i=2:time_step
    % % % % % % % % % % % % 局部变量初始化 % % % % % % % % % % % % % % % % % % % % %
    bid_marketOrder=0;                                           %每一时刻买价市场订单数
    ask_marketOrder=0;                                           %每一时刻卖价市场订单数
    price(i,1)=price(i-1,1);
    % % % % % % % % % % % % 订单提交过程% % % % % % % % % % % % % % % % % % % % %
    if random('unif',[0,1])<0.5                                             %若（0,1）随机数小于等于0.5，则买入一单位股票
        if random('unif',[0,1])<ql0
            bid_orderBook=[bid_orderBook;price(i,1)-unifrnd(0,delta_max) i];%以ql0的概率提交限价订单
        else
            bid_marketOrder=1;
        end
    else                                                                    %若（0,1）随机数大于0.5，则卖出一单位股票
        if random('unif',[0,1])<ql0
            ask_orderBook=[ask_orderBook;price(i,1)+unifrnd(0,delta_max) i];%以ql0的概率提交限价订单
        else
            ask_marketOrder=1;
        end
    end
    
    % % % % % % % % % % % % 订单处理过程 % % % % % % % % % % % % % % % % % % % % %
    if ~isempty(bid_orderBook)
        bid_orderBook=sortrows(bid_orderBook,-1);                                %bid订单价格从高到低排序
    elseif ~isempty(bid_orderBook)
        ask_orderBook=sortrows(ask_orderBook,1);                                  %ask订单价格从低到高排序
    end
    if bid_marketOrder && (~isempty(ask_orderBook))
        price(i,1)=ask_orderBook(1,1);                                          %新价格
        ask_orderBook(1,:)=[];                                                  %删除已成交的订单
    elseif ask_marketOrder && (~isempty(bid_orderBook))
        price(i,1)=bid_orderBook(1,1);                                          %新价格
        bid_orderBook(1,:)=[];                                                 %删除已成交的订单
    end
% % % % % % % % % % % % % % % % %  订单取消过程% % % % % % % % % % % % % % % % % % %    
    if i>1000
        index=find(bid_orderBook(:,2)==(i-1000));
        if index>0
            bid_orderBook(index,:)=[];                                %1000次时间迭代中未执行取消该订单
        end
        index=find(ask_orderBook(:,2)==(i-1000));
        if index>0
            ask_orderBook(index,:)=[];                                %1000次时间迭代中未执行取消该订单
        end
    end
    
end
plot((1:time_step)',price);
