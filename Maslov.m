clc
clear all;
% % % % % % % % % % % % ȫ�ֱ�����ʼ�� % % % % % % % % % % % % % % % % % % % % %
time_step=10000;                                                 %����ʱ�䳤��
init_price=100;                                                  %��ʼ�۸�
bid_orderBook=[];                                                %����޼۶�����
ask_orderBook=[];                                                %�����޼۶�����
delta_max=4;                                                     %����deltaֵ
price=ones(time_step,1)*init_price;                              %�۸�����
ql0=0.5;                                                         %�ύ�޼۶����ĸ���

for i=2:time_step
    % % % % % % % % % % % % �ֲ�������ʼ�� % % % % % % % % % % % % % % % % % % % % %
    bid_marketOrder=0;                                           %ÿһʱ������г�������
    ask_marketOrder=0;                                           %ÿһʱ�������г�������
    price(i,1)=price(i-1,1);
    % % % % % % % % % % % % �����ύ����% % % % % % % % % % % % % % % % % % % % %
    if random('unif',[0,1])<0.5                                             %����0,1�������С�ڵ���0.5��������һ��λ��Ʊ
        if random('unif',[0,1])<ql0
            bid_orderBook=[bid_orderBook;price(i,1)-unifrnd(0,delta_max) i];%��ql0�ĸ����ύ�޼۶���
        else
            bid_marketOrder=1;
        end
    else                                                                    %����0,1�����������0.5��������һ��λ��Ʊ
        if random('unif',[0,1])<ql0
            ask_orderBook=[ask_orderBook;price(i,1)+unifrnd(0,delta_max) i];%��ql0�ĸ����ύ�޼۶���
        else
            ask_marketOrder=1;
        end
    end
    
    % % % % % % % % % % % % ����������� % % % % % % % % % % % % % % % % % % % % %
    if ~isempty(bid_orderBook)
        bid_orderBook=sortrows(bid_orderBook,-1);                                %bid�����۸�Ӹߵ�������
    elseif ~isempty(bid_orderBook)
        ask_orderBook=sortrows(ask_orderBook,1);                                  %ask�����۸�ӵ͵�������
    end
    if bid_marketOrder && (~isempty(ask_orderBook))
        price(i,1)=ask_orderBook(1,1);                                          %�¼۸�
        ask_orderBook(1,:)=[];                                                  %ɾ���ѳɽ��Ķ���
    elseif ask_marketOrder && (~isempty(bid_orderBook))
        price(i,1)=bid_orderBook(1,1);                                          %�¼۸�
        bid_orderBook(1,:)=[];                                                 %ɾ���ѳɽ��Ķ���
    end
% % % % % % % % % % % % % % % % %  ����ȡ������% % % % % % % % % % % % % % % % % % %    
    if i>1000
        index=find(bid_orderBook(:,2)==(i-1000));
        if index>0
            bid_orderBook(index,:)=[];                                %1000��ʱ�������δִ��ȡ���ö���
        end
        index=find(ask_orderBook(:,2)==(i-1000));
        if index>0
            ask_orderBook(index,:)=[];                                %1000��ʱ�������δִ��ȡ���ö���
        end
    end
    
end
plot((1:time_step)',price);
