clc
clear all;
% % % % % % % % % % % % ȫ�ֱ�����ʼ�� % % % % % % % % % % % % % % % % % % % % %
time_step=10000;                                                 %����ʱ�䳤��
initial_price=log(100);                                          %��ʼ�۸�
bid_orderBook=zeros(2,time_step);                                %����޼۶�����
ask_orderBook=zeros(2,time_step);                                %�����޼۶�����
order_sign=zeros(1,time_step);                                   %��������
price_distance=0;                                                %t�ֲ������ļ۸��
price=ones(time_step,1)*initial_price;                           %�۸�����
yi_bid=zeros(1,time_step);                                       %�۸���ָ��
yi_ask=zeros(1,time_step);
imb_buy=0;                                                       %���г���ƽ��
imb_sell=0;                                                      %�����г���ƽ��
best_bid=0;                                                      %�������
best_ask=0;                                                      %��������
Hs=0.88;                                                         %Hurstָ��
a=1;                                                             %t�ֲ����ɶ�
s=0;                                                             %spread
delta_buy0=zeros(1,time_step);delta_buy=zeros(1,time_step);                                      %0��tʱ�̣�bid price����Ѽ۸�ľ���
delta_sell0=zeros(1,time_step);delta_sell=zeros(1,time_step);                                    %0��tʱ�̣�ask price����Ѽ۸�ľ���
alphabet=[-1 1];
prob=0;
A=0;
B=0;
N=0;
s0=zeros(1,1);


% % % % % % % % % % % % %�������Ų���% % % % % % % % % % % % % % % % % % % % %
FBM=wfbm(Hs,time_step);
for m=1:time_step-1
    order_sign(1,m)=FBM(1,m+1)-FBM(1,m);%??���һ���ź�Ϊ0
end

% % % % % % % % % % % % %������ʼ������% % % % % % % % % % % % % % % % % % % % %
l=1;m=1;
while l<4||m<4                                      %�������������޼۶�������С��2
    price_distance=trnd(1.31)/1000;
    if price_distance>0
        bid_orderBook(1,l)=initial_price-price_distance;
        bid_orderBook(2,l)=l;l=l+1;         %������ż�¼
    end
    price_distance=trnd(1.31)/1000;
    if price_distance>0
        ask_orderBook(1,m)=initial_price+price_distance;
        ask_orderBook(2,m)=m;m=m+1;
    end
end
a=bid_orderBook';a=sortrows(a,-1);
bid_orderBook=a';best_bid=bid_orderBook(1,1);           %bid�����۸�Ӹߵ�������
b=ask_orderBook';b=sortrows(b,1);
ask_orderBook=b';j=1;
while ask_orderBook(1,j)==0
    j=j+1;
end
best_ask=ask_orderBook(1,j);            %ask�����۸�ӵ͵�������
s=ask_orderBook(1,j)-bid_orderBook(1,1);            %��ǰ�Ĳ��
for x=1:l-1
    s0=bid_orderBook(1,find(bid_orderBook(2,:)==x));
    delta_buy0(1,x)=best_ask-s0;         %��¼��ʼʱ�̵�delta
end

for y=1:m-1
    s0=ask_orderBook(1,find(ask_orderBook(2,:)==y));
    delta_sell0(1,y)=s0-best_bid;
end


% % % % % % % % % % % % %time evolution% % % % % % % % % % % % % % % % % % % % %
for i=2:time_step
    % % % % % % % % % % % % �ֲ�������ʼ�� % % % % % % % % % % % % % % % % % % % % %
    price(i,1)=price(i-1,1);
    price_distance=trnd(1.31)/1000;
    % % % % % % % % % % % % % ���������жϼ��޼ۡ��г������Ĳ���������% % % % % % % % % % % % % % % % % % % % %
    if order_sign(1,i)>0                                 %���룺+1
        if price_distance<s                              %�����޼۶���
            bid_orderBook(1,l)=best_bid+price_distance;
        else                                             %���������г����������ж������޼۶����������Ƿ����2
            if ask_orderBook<3                           %�����޼۶���������С��2
                delta_sell0=[delta_sell0,ask_orderBook(1,find(ask_orderBook(2,:)==m))-best_bid];
                ask_orderBook(1,m)=best_ask-price_distance;
                ask_orderBook(2,m)=m;m=m+1;
            else                                         %�����޼۶�������������2
                price(i,1)=ask_orderBook(1,1);                 %�¼۸��¼
                ask_orderBook(1,1)=0;                         %ɾ���ѳɽ��Ķ���
            end
        end
    else                                                 %������-1
        if price_distance<s                              %�����޼۶���
            ask_orderBook(1,m)=best_ask+price_distance;
        else                                             %���������г����������ж������޼۶����������Ƿ����2
            if bid_orderBook<3 %�����޼۶���������С��2
                delta_buy0=[delta_buy0,bid_orderBook(1,best_ask-find(bid_orderBook(2,:)==l))];
                bid_orderBook(1,l)=best_bid+price_distance;
                bid_orderBook(2,l)=l;l=l+1;
            else                                         %�����޼۶�������������2
                price(i,1)=bid_orderBook(1,1);                 %�¼۸��¼
                bid_orderBook(1,1)=0;                         %ɾ���ѳɽ��Ķ���
            end
        end
    end
    
    % % % % % % % % % % % % ����ȡ������ % % % % % % % % % % % % % % % % % % % % %
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
    bid_orderBook=a';best_bid=bid_orderBook(1,1);           %bid�����۸�Ӹߵ�������
    b=ask_orderBook';b=sortrows(b,1);
    s=ask_orderBook(1,j)-bid_orderBook(1,1);
end
plot((1:time_step)',price);


