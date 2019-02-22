% Load data.
clear;clc;close all;
run('../load_data_4error');
data=mapminmax(data');
data=data';

classes = length(unique(label));
%{
    %PCA
    x_centered = x-mean(x);
    [V,D]=ccipca(x_centered',k,iteration,V,access);
    x=x*V;
%}
if sum(label==0)>0
    label=label+1;
end

% Divide into train and test
test_data=data(end-1000+1:end,:);
test_label = label(end-1000+1:end,:);
train_data = data(1:end-1000,:);
train_label = label(1:end-1000,:);
%clear data label;


% get the rate of each class
% STA M+atrix: unique label; conut;rate;
STA = tabulate(train_label);
addpath('../smote');
disp("Start smote process");
disp("SMOTE on anomaly type 2");
SMOTE2 = smote(train_data(train_label==2,:), 3, 10*100);
SMOTE2_label = 2*ones(size(SMOTE2,1),1);
disp("SMOTE on anomaly type 3");
SMOTE3 = smote(train_data(train_label==3,:), 3, 10*100);
SMOTE3_label = 3*ones(size(SMOTE3,1),1);
disp("SMOTE on anomaly type 4");
SMOTE4 = smote(train_data(train_label==4,:), 3, 10*100);
SMOTE4_label = 4*ones(size(SMOTE4,1),1);
disp("SMOTE on anomaly type 5");
SMOTE5 = smote(train_data(train_label==5,:), 3, 10*100);
SMOTE5_label = 5*ones(size(SMOTE5,1),1);
disp("Finish SMOTE. Start incremental training:");

train_data=[train_data;SMOTE2;SMOTE3;SMOTE4;SMOTE5];
train_label=[train_label;SMOTE2_label;SMOTE3_label;SMOTE4_label;SMOTE5_label];
% random data order
rand('state',111);
rand_order=randperm(size(train_data,1));
train_data=train_data(rand_order,:);
train_label=train_label(rand_order,:); 

clearvars -except train_label test_label train_data test_data classes

batch_size=500;
accuracyList=[];
train_command=['-q',' -t ',1,'-s',0];


parts=ceil(size(train_data,1)/batch_size);
ends = batch_size*(1:parts)';
ends(end,1)=size(train_data,1);

%init W

%{
%PCA
k=10;
iteration=100;
access=100;
init_index = randperm(size(train_data,1), batch_size);
init_X = train_data(init_index,:);
init_Y = train_label(init_index,:);
% centeralize data
init_X = init_X - mean(init_X);
[V,D]=ccipca(init_X',k);
%[V,D]=ccipca(X,k,iteration,oldV,access)
%}





SV = [];
SV_label=[];
SVnumList=[];
for i =1:parts
    i
    x=train_data((i-1)*batch_size+1:ends(i,1),:);
    y=train_label((i-1)*batch_size+1:ends(i,1),:);
    
    if(size(SV,1)~=0)
        SV=SV*pinv(V);
    end
    
    
    % add SV into training
    x=[x;SV];
    
    %{
    %PCA
    x_centered = x-mean(x);
    [V,D]=ccipca(x_centered',k,iteration,V,access);
    x=x*V;
    %}
    
    
    y=[y;SV_label];
    rand_order=randperm(size(x,1));
    x=x(rand_order,:);
    y=y(rand_order,:); 
    
    model=libsvmtrain(y,x,train_command);
    SV = x(model.sv_indices,:);
    SV_label = y(model.sv_indices,:);
    SVnumList=[SVnumList;size(SV,1)];
    
    [predict_label,accuracy,score]=libsvmpredict(test_label,test_data,model,'-q');
    accuracyList=[accuracyList;accuracy(1,:)];
end

SVnumList
accuracyList
plot(accuracyList,'-');