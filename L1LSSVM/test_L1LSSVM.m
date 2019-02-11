% Load data;
close all;
clear;clc;
run('../load_data');
clear train_data train_label;
data = test_data;
label = test_label;
clear train_data train_label test_data test_label;

% Normalize data
data=mapminmax(data');
data=data';

% Paading 1 column value 1, e.
e = ones(size(data,1),1);
data=[data e];

% Divide into train and test
test_data=data(end-1000+1:end,:);
test_label = label(end-1000+1:end,:);
train_data=data(1:end-1000,:);
train_label = label(1:end-1000,:);
clear data label e;

% Init parameters.
use_kernel = 0;
C=10;
lr=0.1;
batch_size=100;
accuracyList=[];
%w=rand(size(train_data,2)+1,1);
w= unifrnd(-1,1,size(train_data,2),1);



% pred_label = double(test_data*w>0);
% pred_label(pred_label==0,:)=-1;
% accuracy = 1-sum(pred_label~=test_label)/length(test_label)

% Divide  training data to simulate online learning. 
parts=ceil(size(train_data,1)/batch_size);
ends = batch_size*(1:parts)';
ends(end,1)=size(train_data,1);

if use_kernel==1
    options.KernelType = 'Gaussian';
    options.t = 2;
    options.d = 1.1;
    x_init = train_data((1-1)*batch_size+1:ends(1,1),:);
    test_data = constructKernel(test_data,x_init,options);
    w= unifrnd(-1,1,batch_size,1);
end
w=w/norm(w);
for i =1:parts
    i
    x=train_data((i-1)*batch_size+1:ends(i,1),:);
   
    if use_kernel==1
        x = constructKernel(x,x_init,options);
    end
    
    y=train_label((i-1)*batch_size+1:ends(i,1),:);
    [w] = L1LSSVM(x,y,C,w,lr);
    %if(mod(i, batch_size) == 0)
       
       pred_label = double(test_data*w>0);
       pred_label(pred_label==0,:)=-1;
       accuracy = 1-sum(pred_label~=test_label)/length(test_label);
       accuracyList=[accuracyList;accuracy];
    %end
end
accuracyList;
plot(accuracyList)
