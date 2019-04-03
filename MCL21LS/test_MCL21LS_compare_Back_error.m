%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comparison between traditional online and feedback all predict_negative examples.
% Feedback predicted error negative examples. 
% Date 2019/3/7
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;close all;
addpath('../Tools/');
run('../Tools/load_data_4error');
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
C=0.1;
lr=0.1;
batch_size=300;

%w=rand(size(train_data,2)+1,1);
W= unifrnd(-1,1,size(train_data,2),classes);
W=W/norm(W);


pred_label = double(test_data*W);
vector_pred_label = convert_vector(pred_label);
vector_label = convert_vector(test_label);
accuracy = 1-sum(vector_pred_label~=vector_label)/length(test_label)
accuracyList=[];
NegNumbList = [];

parts=ceil(size(train_data,1)/batch_size);
ends = batch_size*(1:parts)';
ends(end,1)=size(train_data,1);

for i =1:parts
    i
    x=train_data((i-1)*batch_size+1:ends(i,1),:);
    y=train_label((i-1)*batch_size+1:ends(i,1),:);
    
    pred_label = x*W;
    vector_pred_label = convert_vector(pred_label);
    index_neg = find(vector_pred_label~=1 );
    index_error = find(vector_pred_label~=convert_vector(y));
    index = intersect(index_neg,index_error); % get predicted error negative.
    NegNumbList = [NegNumbList;length(index)];
    x_train = x(index,:);
    y_train = y(index,:);
    [W] = MCL21LS(x_train,y_train,C,W,lr);
    
    vector_pred_test_label = convert_vector(test_data*W);
    result = MCmetric(vector_label,vector_pred_test_label);

 
    accuracyList=[accuracyList;result.accuracy];
   
end
accuracyList
plot(accuracyList,'-');
hold on;
plot(NegNumbList/300,'.-');
legend({'accuracy','predict negative rate'});

%validate the row sparsity
vector_W = sum(abs(W).^2,2).^(1/2);
sorted_vector_W = sort(vector_W,'descend');