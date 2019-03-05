%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% with Hard Negative Mining (weight by smote):
%   Feedback error classification, retain.
%   improve precision recall, F1-measure.
%   *Important*: We should compare F1,recall, precision instead of accuracy here. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;clc;close all;

run('../Tools/load_data_4error');
addpath('../Tools');
addpath('../Tools/smote');
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
%accuracyList=[];
ResultList = [];
parts=ceil(size(train_data,1)/batch_size);
ends = batch_size*(1:parts)';
ends(end,1)=size(train_data,1);
Error_negative_data=[];
Error_negative_label=[];

% Key parameter:
addErrorTimes = 10; % int, smote times for rollback error. (0-5)


for i =1:parts
    i
    x=train_data((i-1)*batch_size+1:ends(i,1),:);  
    y=train_label((i-1)*batch_size+1:ends(i,1),:);
    x_new = x;
    y_new = y;
    % Do not for last epoch, or accuracy will drop very much. 
    if(i~=parts && addErrorTimes~=0)
        x_new = [x;Error_negative_data];
        y_new = [y;Error_negative_label];
       
    end
     
%     rand('state',123);
%     rand_order=randperm(size(x_new,1));
%     x_new=x_new(rand_order,:);
%     x_new=x_new(rand_order,:); 
    
    [W] = MCL21LS(x_new,y_new,C,W,lr);
   
    pred_label = x*W;
    vector_pred_label = convert_vector(pred_label);
    
    % Retrain error negative classification.
    vector_y=convert_vector(y);
    Error_index = find(vector_pred_label~=vector_y);
    Error_label = vector_y(Error_index,:);
    Error_data = x(Error_index,:);
    negative_index = find(Error_label~=1);
    length(Error_label)
    Error_negative_label=[];
    Error_negative_data=[];
    if(length(negative_index)>0)
        Error_negative_label=convert_one_hot(Error_label(negative_index,:));
        Error_negative_data = Error_data(negative_index,:);
        
        %somte for the error (roll back for training)
        if addErrorTimes>1
            SMOTE_data=[];
            SMOTE_label=[];
            unqiue_Error_negative_label = unique(convert_vector(Error_negative_label));
            for u = 1:length(unqiue_Error_negative_label)
                u_index = find(convert_vector(Error_negative_label) == unqiue_Error_negative_label(u,1));
                SMOTE_data_1 = smote(train_data(u_index,:), 2, (addErrorTimes-1)*100);
                SMOTE_label_1 = unqiue_Error_negative_label(u)*ones(size(SMOTE_data_1,1),1);
                SMOTE_label_1 = convert_one_hot(SMOTE_label_1);
                SMOTE_data=[SMOTE_data;SMOTE_data_1];
                SMOTE_label=[SMOTE_label;SMOTE_label_1];
            end
            Error_negative_label = [Error_negative_label;SMOTE_label];
            Error_negative_data = [Error_negative_data;SMOTE_data];
        end
            
        
        
    end
    
    
    pred_label = test_data*W;
    vector_pred_label = convert_vector(pred_label);
    %accuracy = 1-sum(vector_pred_label~=vector_label)/length(test_label)
    %accuracyList=[accuracyList;accuracy];
    result = MCmetric(vector_label,vector_pred_label);
    ResultList = [ResultList;result];
end
%ResultList = roundn(ResultList,-4);
%accuracyList
%plot(accuracyList,'-');

%validate the row sparsity
vector_W = sum(abs(W).^2,2).^(1/2);
sorted_vector_W = sort(vector_W,'descend');