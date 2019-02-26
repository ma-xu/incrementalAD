%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add smote (kernel)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load data;
close all;
clear;clc;
run('../Tools/load_data');
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

% get the rate of each class
% STA Matrix: unique label; conut;rate;
STA = tabulate(train_label);
addpath('../Tools/smote');
disp("Start smote process");
SMOTE_data = smote(train_data(train_label==-1,:), 1, 2*100);
SMOTE_label = -ones(size(SMOTE_data,1),1);
disp("SMOTE completed.");

train_data=[train_data;SMOTE_data;];
train_label=[train_label;SMOTE_label;];
% random data order
rand('state',111);
rand_order=randperm(size(train_data,1));
train_data=train_data(rand_order,:);
train_label=train_label(rand_order,:); 


% Init parameters.
use_kernel = 0;
C=10;
lr=0.1;
batch_size=300;
accuracyList=[];
%w=rand(size(train_data,2)+1,1);
w= unifrnd(-1,1,size(train_data,2),1);



pred_label = double(test_data*w>0);
pred_label(pred_label==0,:)=-1;
accuracy = 1-sum(pred_label~=test_label)/length(test_label);
%accuracyList=[accuracyList;accuracy];

% Divide  training data to simulate online learning. 
parts=ceil(size(train_data,1)/batch_size);
ends = batch_size*(1:parts)';
ends(end,1)=size(train_data,1);

if use_kernel==1
    options.KernelType = 'Gaussian';
    options.t =6;
    options.d = 2;
    %x_init = train_data((1-1)*batch_size+1:ends(1,1),:);
    rand_order=randperm(size(train_data,1));
    x_init = train_data(rand_order(1:100),:);
    test_data = constructKernel(test_data,x_init,options);
    %w= unifrnd(-1,1,batch_size,1);
    w= unifrnd(-1,1,size(x_init,1),1);
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
