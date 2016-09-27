clc
clear all
% % % % % % % % % % % % % % % % ������ʼ��% % % % % % % % % % % % % % % % % % % 

time_step=10000;                                                            %����ʱ�䳤��
Hs=0.88;                                                                    %Hurstָ��
price=zeros(time_step,1);                                                   %��ʼ���۸�����
price(1,1)=log(100);                                                        %��ʼ��Ϊ�����۸�
y_bid=zeros(time_step,1);                                                   %��ʼ���򷽶������Ϊ1�ļ۸����
y_ask=zeros(time_step,1);
A=1.12;                                                                     %����ȡ�����̲���
B=0.2;                                                                      %����ȡ�����̲���
best_bid=zeros(time_step,1);
best_ask=zeros(time_step,1);
spread=zeros(time_step,1);
% % % % % % % % % % % % % % % % % % % % % % %�������Ų��� % % % % % % % % % % % % 

FBM=wfbm(Hs,time_step);
order_sign=diff(FBM);

% % % % % % % % % % % % % % % % %��ʼ��������% % % % % % % % % % % % % % % 

[bid_orderBook,ask_orderBook,y_bid,y_ask]=InitBook(y_bid,y_ask);            %��ʼ�������������ɸ�3������
[E1,index1]=sortrows(bid_orderBook,-1);                                     %bid�Ӹߵ��͹�������
[E2,index2]=sortrows(ask_orderBook,1);                                      %ask�ӵ͵��߹�������

%���������ű���
best_bid(1,1)=E1(1,2);
best_ask(1,1)=E2(1,2);

bid_delta_0=best_ask(1,1)*ones(3,1)-bid_orderBook(index1,2);                %0ʱ���򷽶���i��deltaֵ���б�ʾ������ţ�t��ʾʱ��
ask_delta_0=ask_orderBook(index1,2)-best_bid(1,1)*ones(3,1);                %0ʱ����������i��deltaֵ���б�ʾ������ţ�t��ʾʱ��

%ʱ��ѭ��ǰ�Ĳ���Ԥ��
spread(1,1)=best_ask(1,1)-best_bid(1,1);                                         %��ǰ�۲�
bid_num=3;
ask_num=3;


% % % % % % % % % % % % % % %time evolution % % % % % % % % % % % % % % % % % % % % % % 

for i=2:time_step
    
   price_distance=trnd(1.31)/100;                                           %���������۲�
   
% % % % % % % % % % % % % ���������жϼ��޼ۡ��г������Ĳ���������% % % % % % % % % % % % % 

 if order_sign(1,i-1)>0                                                     %���룺+1
        if price_distance<spread                                            %�����޼۶���
            bid_num=bid_num+1;                                              %�����޼۶����ż�1
            bid_orderBook=[ bid_orderBook;bid_num  best_bid(i,1)+price_distance];
            y_bid(i,bid_num)=1;                                             %������ʼyֵ
        else                                                                %���������г�����
             if ask_orderBook>2                                             %Ҫ�󶩵����е������޼۶�������������2������Ϊ��Ч�г�����
                 ask_orderBook(index2(1),:)=[];
             end
        end
 else                                                                       %������-1
     if price_distance<spread                                               %�����޼۶���
         ask_num=ask_num+1;                                                 %�����޼۶����ż�1
         ask_orderBook=[ask_orderBook;ask_num  best_ask(i,1)-price_distance];
         y_ask(i,ask_num)=1;
     else                                                                   %���������г�����
         if bid_orderBook>2                                                 %Ҫ�󶩵����е������޼۶�������������2������Ϊ��Ч�г�����
             bid_orderBook(index1(1),:)=[];
         end
     end
 end
 
% % % % % % % % % % % % % % % % % % ����ȡ������% % % % % % % % % % % % % % % % % % % % % % % % %

BidLen=length(bid_orderBook);
AskLen=length(ask_orderBook);

y_bid(i,:)=(best_ask(i,1)*ones(BidLen,1)-bid_orderBook(:,2))./bid_delta_0;  %��ʱ��t��yֵ
y_ask(i,:)=(ask_orderBook(:,2)-best_bid(i,1)*ones(AskLen,1))./ask_delta_0;  %����ʱ��t��yֵ

Bidnimb=BidLen/(BidLen+AskLen);                                             %�򵥲�ƽ��
Asknimb=AskLen/(BidLen+AskLen);                                             %������ƽ��

BidOrderCancleProb=A*(ones(BidLen,1)-exp(-y_bid(i,:)))*(Bidnimb+B)/(BidLen+AskLen);
AskOrderCancleProb=A*(ones(AskLen,1)-exp(-y_ask(i,:)))*(Asknimb+B)/(BidLen+AskLen);
[row,col]=find(rand(BidLen,1)>BidOrderCancleProb);
bid_orderBook(row,:)=[];
[row,col]=find(rand(AskLen,1)>AskOrderCancleProb);
ask_orderBook(row,:)=[];

% % % % % % % % % % % % % % % % % %�г�����% % % % % % % % % % % % % % % % % % % % % % % % % % %

[E1,index1]=sortrows(bid_orderBook,-1);                                    %bid�Ӹߵ�������
[E2,index2]=sortrows(ask_orderBook,-1);                                    %ask�ӵ͵�������
best_ask(i,1)=E1(1,2);
best_bid(i,1)=E2(1,2);
spread(i,1)=best_ask(i+1,1)-best_bid(i+1,1);                                        %��ǰ�۲�

price(i,1)=0.5*(best_ask(i,1)+best_bid(i,1));                               %tʱ�̵��г��۸�



end