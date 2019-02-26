
clear;clc;close all;
run('../Tools/load_data');
clear train_data train_label;
data = test_data;
label = test_label;
clear train_data train_label test_data test_label;

data=mapminmax(data');
data=data';

% Divide into train and test
test_data=data(end-1000+1:end,:);
test_label = label(end-1000+1:end,:);
train_data=data(1:end-1000,:);
train_label = label(1:end-1000,:);
clear data label;

%label(label==-1)=2;
C=1;
lr=0.1;
batch_size=300;

%w=rand(size(train_data,2)+1,1);
w= unifrnd(-1,1,size(train_data,2),1);
w=w/norm(w);


pred_label = double(test_data*w>0);
pred_label(pred_label==0,:)=-1;
accuracy = 1-sum(pred_label~=test_label)/length(test_label)
accuracyList=[];

parts=ceil(size(train_data,1)/batch_size);
ends = batch_size*(1:parts)';
ends(end,1)=size(train_data,1);

for i =1:parts
    i
    x=train_data((i-1)*batch_size+1:ends(i,1),:);
    
    y=train_label((i-1)*batch_size+1:ends(i,1),:);
    [w] = L1LS(x,y,C,w,lr);
    %if(mod(i, batch_size) == 0)
       pred_label = double(test_data*w>0);
       pred_label(pred_label==0,:)=-1;
       accuracy = 1-sum(pred_label~=test_label)/length(test_label);
       accuracyList=[accuracyList;accuracy];
    %end
end
accuracyList
plot(accuracyList,'-');