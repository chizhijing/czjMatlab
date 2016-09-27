clc
clear all
Nr=100;%���Ͷ��������
alpa=3;
nanda=4;
Nm=alpa*sqrt(Nr);%������Ͷ������
p0=1;%��ʼ�г��۸�
x_t=60000;%ʱ������
x_price=zeros(x_t,2);
x=randi([0,1],Nr,1);%������ɳ�ʼʱ�̵�0-1��Ŭ���ֲ�
 for i=1:Nr
    if x(i,1)==0
        x(i,1)=-1;
     end
 end
 x_price(1,1)=1;
 x_price(1,2)=p0;
 sigema=sqrt(Nr);%��������߲����ı�׼��
for i=2:x_t
   demand=sum(x);%t-1ʱ���г���������
   if demand/sigema>=nanda
       y=ones(Nm,1);%ȫ�������Ͷ��������
   elseif demand/sigema<=(-1)*nanda
       y=(-1).*ones(Nm,1);%ȫ�������Ͷ��������
   elseif abs(demand/sigema)<nanda
       y=zeros(Nm,1);
   end
   x_price(i,1)=i;
   x_price(i,2)=x_price(i-1,2)+sum(x)+sum(y);%�г��۸�  
   x=randi([0,1],Nr,1);%�������tʱ�̵�0-1��Ŭ���ֲ�
    for j=1:Nr
        if x(j,1)==0
            x(j,1)=-1;
        end
    end
   
end
 figure;
 plot(x_price(:,1),x_price(:,2));
                
        
