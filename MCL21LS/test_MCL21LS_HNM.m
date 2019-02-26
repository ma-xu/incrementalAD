%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% with Hard Negative Mining:
%   Feedback error classification, retain.
%   improve precision recall, F1-measure.
%   *Important*: We should compare F1,recall, precision instead of accuracy here. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;clc;close all;
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

parts=ceil(size(train_data,1)/batch_size);
ends = batch_size*(1:parts)';
ends(end,1)=size(train_data,1);
Error_negative_data=[];
Error_negative_label=[];

for i =1:parts
    i
    x=train_data((i-1)*batch_size+1:ends(i,1),:);  
    y=train_label((i-1)*batch_size+1:ends(i,1),:);
    if(i~=parts && 1==2)
        x = [x;Error_negative_data];
        y = [y;Error_negative_label];
    end
    
    [W] = MCL21LS(x,y,C,W,lr);
   
    pred_label = x*W;
    vector_pred_label = convert_vector(pred_label);
    
    % Retrain error negative classification.
    vector_y=convert_vector(y);
    Error_index = find(vector_pred_label~=vector_y);
    Error_label = vector_y(Error_index,:);
    Error_data = x(Error_index,:);
    negative_index = find(Error_label~=1);
    if(length(negative_index)>0)
        Error_negative_label=convert_one_hot(Error_label(negative_index,:));
        Error_negative_data = Error_data(negative_index,:);
    end
    
    
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