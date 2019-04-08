%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% 1. Init to make more data predicted as normal.
% 2. 2 classes result.
% 3. Follow the predicted negative rollback manner. 
% 4. Init model result is not added to the resultList
% Date 2019/4/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;close all;
addpath('../Tools/');
run('../Tools/load_data');
clear train_data train_label;
data = test_data;
label = test_label;
clear train_data train_label test_data test_label;


Prone_normal=false;
Save_GIF = false;
IF_SELF=false;
data=mapminmax(data');
data=data';

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
w= unifrnd(-1,1,size(train_data,2),1);
w=w/norm(w);
if Prone_normal
    % init w tomake first predict tobe one,W = pinv(X)*[1 0 0 0 0]
    temp=randperm(size(train_data,1))';
    temp=temp(1:100,:);
    temp = train_data(temp,:);
    temp = temp./norm(temp);
    initY = ones(100,1);
    w2 = pinv(temp)*initY;
    %W = rand(651,50)*initY;
    w2=w2/norm(w2);
    w = w+0.026*w2;% tuning in the range of (0.01,003), abnormal-normal
end

pred_label = double(test_data*w>0);
pred_label(pred_label==0,:)=-1;
metrics = TCmetric(test_label,pred_label);
accuracy = metrics.accuracy

accuracyList=[];
NegNumbList = [];
ResultList = [];

parts=ceil(size(train_data,1)/batch_size);
ends = batch_size*(1:parts)';
ends(end,1)=size(train_data,1);
ROC_distance = [];

for i =1:parts
    i
    x=train_data((i-1)*batch_size+1:ends(i,1),:);
    y=train_label((i-1)*batch_size+1:ends(i,1),:);
    
    pred_label = double(x*w>0);
    pred_label(pred_label==0,:)=-1;
    index = find(pred_label~=1);
    length(index)
    NegNumbList = [NegNumbList;length(index)];
    x_train = x(index,:);
    y_train = y(index,:);
    if IF_SELF
        [w] = L1LS(x_train,y_train,C,w,lr);
    else
        [w] = L1LS(x,y,C,w,lr);
    end
    
    pred_test_label = double(test_data*w>0);
    pred_test_label(pred_test_label==0,:)=-1;
   
    result = TCmetric(test_label,pred_test_label);
    result.NegNumber = length(index);
    ResultList = [ResultList;result];
    accuracyList=[accuracyList;result.accuracy];
    
    % For ROC curve.
    test_distacne = test_data*w;
    ROC_distance = [ROC_distance test_distacne];
   
end


%% for plot
AccuracyList = [];
SensitivityList = [];
SepecificityList = [];
RecallList = [];
PrecisionList = [];
F1List = [];
NegNumList = [];
for i =1:length(ResultList)
    Result = ResultList(i);
    Accuracy = Result.accuracy;
    Sensitivity = Result.sensitivity';
    Sepecificity = Result.specificity';
    Recall = Result.recall';
    Precision = Result.precision';
    F1 = Result.F1_measure';
    NegNumber = Result.NegNumber;
  
    AccuracyList=[AccuracyList;Accuracy];
    SensitivityList = [SensitivityList;Sensitivity];
    SepecificityList = [SepecificityList;Sepecificity];
    RecallList = [RecallList;Recall];
    PrecisionList = [PrecisionList;Precision];
    F1List = [F1List;F1];
    NegNumList = [NegNumList;NegNumber];
    
end

plot(accuracyList,'-.');
hold on;
plot(SensitivityList,'-+');
hold on;
plot(SepecificityList,'-*');
hold on;
legend(["Accuracy","Sensitivity","Specificity"]);
xlabel('Epochs','FontSize',14);
ylabel('Metric values','FontSize',14);


%{
accuracyList
plot(accuracyList,':');
hold on;
plot(NegNumbList/batch_size,':');
plot(SensitivityList(:,1));
plot(SepecificityList(:,1));
plot(PrecisionList(:,1));
plot(F1List(:,1));
legend({'accuracy','predict negative rate','Sensitivity','Sepecificity','PrecisionList','F1List'});

%validate the row sparsity
vector_W = sum(abs(w).^2,2).^(1/2);
sorted_vector_W = sort(vector_W,'descend');



%% Plot ROC curve.
clearvars -except ROC_distance test_label Save_GIF;
close all;
AUCList = [];
for i=1:size(ROC_distance,2)
    
    test_distacne = ROC_distance(:,i);
    % normalize to [0,1]
    test_distacne = mapminmax(test_distacne',0,1);
    test_distacne = test_distacne';
    
    
    [X,Y,~,AUC] = perfcurve(test_label,test_distacne,1);
    AUCList = [AUCList;AUC];
    plot(X,Y);
    title(['ROC Curve for epoch ',num2str(i)]);
    xlabel('False Positive Rate');
    ylabel('True Positive Rate');
    
    % save tmp image for gif
    if Save_GIF
        print(1,'-dbmp',sprintf('image/%d',i));
    end
    
    close;SensitivityList(SensitivityList==0)=1
    
end
if Save_GIF
    for j = 1:size(ROC_distance,2)
        A = imread(sprintf('image/%d.bmp',j));
       
        [I,map] = rgb2ind(A,256);
        if(j==1)
            imwrite(I,map,'ROCall.gif','DelayTime',0.5,'LoopCount',0)
        else
            imwrite(I,map,'ROCall.gif','WriteMode','append','DelayTime',0.5)
        end
        
    end
end
AUCList
%}