function [bid_orderBook,ask_orderBook,y_bid,y_ask] = InitBook_czj(y_bid,y_ask)
%INITIALBOOK Farmer模型中生成初始的订单簿
%   
bid_num=1;                                                                  %bid订单编号
ask_num=1;                                                                  %ask订单编号
initial_price=log(100);                                                     %初始价格
bid_orderBook=[];                                                           %买价限价订单簿
ask_orderBook=[];                                                           %卖价限价订单簿

while bid_num<=3                                                            %要求各生成至少3个订单
    price_distance=trnd(1.31)/100;                          
    if price_distance<0                                                     %若随机数为负值则为订单簿之内       
        if bid_num>3                                                        %bid订单数大于3，继续循环
            continue;
        else
            bid_orderBook=[ bid_orderBook;bid_num  initial_price+price_distance];%第一列为订单编号，第二列为订单价格
            y_bid(bid_num)=1;
            bid_num=bid_num+1;
        end
    end
end

while ask_num<=3  
    price_distance=trnd(1.31)/1000;
      if price_distance<0               
        if ask_num>3
            continue;
        else
            ask_orderBook=[ ask_orderBook;ask_num  initial_price-price_distance];
            y_ask(ask_num)=1;
            ask_num=ask_num+1;
        end        
     end
end

end

