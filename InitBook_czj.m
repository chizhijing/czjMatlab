function [bid_orderBook,ask_orderBook,y_bid,y_ask] = InitBook_czj(y_bid,y_ask)
%INITIALBOOK Farmerģ�������ɳ�ʼ�Ķ�����
%   
bid_num=1;                                                                  %bid�������
ask_num=1;                                                                  %ask�������
initial_price=log(100);                                                     %��ʼ�۸�
bid_orderBook=[];                                                           %����޼۶�����
ask_orderBook=[];                                                           %�����޼۶�����

while bid_num<=3                                                            %Ҫ�����������3������
    price_distance=trnd(1.31)/100;                          
    if price_distance<0                                                     %�������Ϊ��ֵ��Ϊ������֮��       
        if bid_num>3                                                        %bid����������3������ѭ��
            continue;
        else
            bid_orderBook=[ bid_orderBook;bid_num  initial_price+price_distance];%��һ��Ϊ������ţ��ڶ���Ϊ�����۸�
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

