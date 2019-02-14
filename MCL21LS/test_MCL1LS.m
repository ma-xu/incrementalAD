
clear;clc;close all;
run('../load_data_4error');
data=mapminmax(data');
data=data';
classes = length(unique(label));
if sum(label==0)>0
    label=label+1;
end

% convert column vector label to one-hot matrix label
label=convert_one_hot(label);


% Divide into train and test
test_data=data(end-1000+1:end,:);
test_label = label(end-1000+1:end,:);
train_data=data(1:end-1000,:);
train_label = label(1:end-1000,:);
clear data label;


%label(label==-1)=2;
C=1;
lr=0.1;
batch_size=100;

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

for i =1:parts
    i
    x=train_data((i-1)*batch_size+1:ends(i,1),:);
    
    y=train_label((i-1)*batch_size+1:ends(i,1),:);
    [W] = MCL1LS(x,y,C,W,lr);
    %if(mod(i, batch_size) == 0)
       pred_label = double(test_data*W>0);
       vector_pred_label = convert_vector(pred_label);
       accuracy = 1-sum(vector_pred_label~=vector_label)/length(test_label)
       accuracyList=[accuracyList;accuracy];
    %end
end
accuracyList
plot(accuracyList,'-');