%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Self evolve: 
%   semi-supervised
%   add most possible predict data back to training. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;close all;
run('../Tools/load_data_4error');
data=mapminmax(data');
data=data';
classes = length(unique(label));
if sum(label==0)>0
    label=label+1;
end

% Divide into train and test
test_data=data(end-1000+1:end,:);
test_label = label(end-1000+1:end,:);
train_data=data(1:end-1000,:);
train_label = label(1:end-1000,:);
clear data label;


%{
% get the rate of each class
% STA Matrix: unique label; conut;rate;
STA = tabulate(train_label);
addpath('../Tools/smote');
disp("Start smote process");
disp("SMOTE on anomaly type 2");
SMOTE2 = smote(train_data(train_label==2,:), 1, round(STA(1,2)/STA(2,2)-1)*100);%round(STA(1,2)/STA(2,2)-1)
SMOTE2_label = 2*ones(size(SMOTE2,1),1);
disp("SMOTE on anomaly type 3");
SMOTE3 = smote(train_data(train_label==3,:), 1, round(STA(1,2)/STA(3,2)-1)*100);
SMOTE3_label = 3*ones(size(SMOTE3,1),1);
disp("SMOTE on anomaly type 4");
SMOTE4 = smote(train_data(train_label==4,:), 1, round(STA(1,2)/STA(4,2)-1)*100);
SMOTE4_label = 4*ones(size(SMOTE4,1),1);
disp("SMOTE on anomaly type 5");
SMOTE5 = smote(train_data(train_label==5,:), 1, round(STA(1,2)/STA(5,2)-1)*100);
SMOTE5_label = 5*ones(size(SMOTE5,1),1);
disp("Finish SMOTE. Start incremental training:");

train_data=[train_data;SMOTE2;SMOTE3;SMOTE4;SMOTE5];
train_label=[train_label;SMOTE2_label;SMOTE3_label;SMOTE4_label;SMOTE5_label];
% random data order
rand('state',111);
rand_order=randperm(size(train_data,1));
train_data=train_data(rand_order,:);
train_label=train_label(rand_order,:); 
%}


% convert column vector label to one-hot matrix label
test_label=convert_one_hot(test_label);
train_label=convert_one_hot(train_label);

%label(label==-1)=2;
C=0.1;
lr=0.1;
batch_size=300;
self_confidence_threshold_abnormal=0.9;
self_confidence_threshold_normal=0.95;


%w=rand(size(train_data,2)+1,1);
W= unifrnd(-1,1,size(train_data,2),classes);
W=W/norm(W);


pred_label = double(test_data*W);
vector_pred_label = convert_vector(pred_label);
vector_label = convert_vector(test_label);
accuracy = 1-sum(vector_pred_label~=vector_label)/length(test_label)
accuracyList=[];

parts=ceil(size(train_data,1)/batch_size);
ends = batch_size*(1:parts)';
ends(end,1)=size(train_data,1);

% Using 1/2 labeled data to train model.
for i =1:floor(parts/2)
    i
    x=train_data((i-1)*batch_size+1:ends(i,1),:);
    
    y=train_label((i-1)*batch_size+1:ends(i,1),:);
    [W] = MCL21LS(x,y,C,W,lr);
    %if(mod(i, batch_size) == 0)
       pred_label = test_data*W;
       vector_pred_label = convert_vector(pred_label);
       accuracy = 1-sum(vector_pred_label~=vector_label)/length(test_label)
       accuracyList=[accuracyList;accuracy];
    %end
end

disp("Start self-evolve training ");
% Using last 1/2 labeled data to train self-evolve (use predict label) 
for i = ceil(parts/2):parts
    i
    x=train_data((i-1)*batch_size+1:ends(i,1),:);
    y=train_label((i-1)*batch_size+1:ends(i,1),:);
    y=convert_vector(y);
    pred_label = x*W;
    [maxVal,predict] = max(pred_label');
    maxVal=maxVal'; predict = predict';
     
    self_index_abnormal=find(predict~=1);
    [sorted_Val,sorted_index] = sort(abs(1-maxVal(self_index_abnormal,:)));
    self_index_abnormal = self_index_abnormal(sorted_index,:);
    self_index_abnormal = self_index_abnormal(1:sum(sorted_Val<=(1-self_confidence_threshold_abnormal)),:);
    
    self_index_normal=find(predict==1);
    [sorted_Val,sorted_index] = sort(abs(1-maxVal(self_index_normal,:)));
    self_index_normal = self_index_normal(sorted_index,:);
    self_index_normal = self_index_normal(1:sum(sorted_Val<=(1-self_confidence_threshold_normal)),:);
    
    self_index=[self_index_abnormal;self_index_normal];
    
    x_new = x(self_index,:);
    y_new = predict(self_index,:);
    y_new = convert_one_hot(y_new);


    [W] = MCL21LS(x_new,y_new,C,W,lr);
    pred_label = test_data*W;
    vector_pred_label = convert_vector(pred_label);
    accuracy = 1-sum(vector_pred_label~=vector_label)/length(test_label)
    accuracyList=[accuracyList;accuracy];
    
end






accuracyList
plot(accuracyList,'-');

%validate the row sparsity
vector_W = sum(abs(W).^2,2).^(1/2);
sorted_vector_W = sort(vector_W,'descend');