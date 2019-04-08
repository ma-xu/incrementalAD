%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comparison between traditional online and feedback all predict_negative examples.
% Init to make more data predicted as normal.
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


IF_SMOTE=false;
IF_NORMAL=true;
IF_SELF=true;


%label(label==-1)=2;
C=10;
lr=0.1;
batch_size=300;


if IF_SMOTE
    % get the rate of each class
    % STA Matrix: unique label; conut;rate;
    vector_train_label = convert_vector(train_label);
    STA = tabulate(vector_train_label);
    addpath('../Tools/smote');
    disp("Start smote process");
    disp("SMOTE on anomaly type 2");
    SMOTE2 = smote(train_data(vector_train_label==2,:), 2, 2*100);%round(STA(1,2)/STA(2,2)-1)
    SMOTE2_label = 2*ones(size(SMOTE2,1),1);
    SMOTE2_label = convert_one_hot(SMOTE2_label);
    disp("SMOTE on anomaly type 3");
    SMOTE3 sorted_vector_W= smote(train_data(vector_train_label==3,:), 2, 2*100);
    SMOTE3_label = 3*ones(size(SMOTE3,1),1);
    SMOTE3_label = convert_one_hot(SMOTE3_label);
    disp("SMOTE on anomaly type 4");
    SMOTE4 = smote(train_data(vector_train_label==4,:), 2, 2*100);
    SMOTE4_label = 4*ones(size(SMOTE4,1),1);
    SMOTE4_label = convert_one_hot(SMOTE4_label);
    disp("SMOTE on anomaly type 5");
    SMOTE5 = smote(train_data(vector_train_label==5,:), 2, 2*100);
    SMOTE5_label = 5*ones(size(SMOTE5,1),1);
    SMOTE5_label = convert_one_hot(SMOTE5_label);
    disp("Finish SMOTE. Start incremental training:");

    train_data=[train_data;SMOTE2;SMOTE3;SMOTE4;SMOTE5];
    train_label=[train_label;SMOTE2_label;SMOTE3_label;SMOTE4_label;SMOTE5_label];
    % random data order
    rand('state',111);
    rand_order=randperm(size(train_data,1));
    train_data=train_data(rand_order,:);
    train_label=train_label(rand_order,:); 
end



%w=rand(size(train_data,2)+1,1);
W= unifrnd(-1,1,size(train_data,2),classes);
W=W/norm(W);
if IF_NORMAL
    % init w tomake first predict tobe one,W = pinv(X)*[1 0 0 0 0]
    temp=randperm(size(train_data,1))';
    temp=temp(1:50,:);
    temp = train_data(temp,:);
    temp = temp./norm(temp);
    initY = [ones(50,1) 0.1*ones(50,4)];
    W2 = pinv(temp)*initY;
    %W = rand(651,50)*initY;
    W2=W2/norm(W2);
    W = W+0.07*W2;% tuning in the range of (0.01,0.1), abnormal-normal
end

pred_label = double(test_data*W);
vector_pred_label = convert_vector(pred_label);
vector_label = convert_vector(test_label);
accuracy = 1-sum(vector_pred_label~=vector_label)/length(test_label)
accuracyList=[];
NegNumbList = [];

parts=ceil(size(train_data,1)/batch_size);
ends = batch_size*(1:parts)';
ends(end,1)=size(train_data,1);
ResultList=[];
for i =1:parts
    i
    x=train_data((i-1)*batch_size+1:ends(i,1),:);
    y=train_label((i-1)*batch_size+1:ends(i,1),:);
    
    pred_label = x*W;
    vector_pred_label = convert_vector(pred_label);
    index = find(vector_pred_label~=1);
    length(index)
    NegNumbList = [NegNumbList;length(index)];
    x_train = x(index,:);
    y_train = y(index,:);
    if IF_SELF
        [W] = MCL21LS(x_train,y_train,C,W,lr);
    else
        [W] = MCL21LS(x,y,C,W,lr);
    end
    vector_pred_test_label = convert_vector(test_data*W);
    result = MCmetric(vector_label,vector_pred_test_label);
    result.NegNumber = length(index);
    ResultList = [ResultList;result];
 
    accuracyList=[accuracyList;result.accuracy];
   
end
vector_W = sum(abs(W).^2,2).^(1/2);
[sorted_vector_W,index ]= sort(vector_W,'descend');
load('../Data/mat/titles.mat');
titles = titles(index);
top_20_weight=sorted_vector_W(1:20)
top_20_title = titles(1:20)
