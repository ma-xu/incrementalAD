clear;clc;
% load testing data
load Data/usps.mat;
data=fea;
label=gnd;



%mapminmax will remap lines into a resonable scale.
data=mapminmax(data');
data=data';

%devide into init_data and data
% init_index_1=find(label==1,1:10);
% init_index_2=find(label==2,1:10);
% init_data=data([init_index_1,init_index_2],:);
% init_label=label([init_index_1,init_index_2],:);
% data([init_index_1,init_index_2],:)=[];
% label([init_index_1,init_index_2],:)=[];

init_index=1:100;
init_data=data(init_index,:);
init_label=label(init_index,:);
data(init_index,:)=[];
label(init_index,:)=[];


% Divide into train and test
test_data=data(end-1000+1:end,:);
test_label = label(end-1000+1:end,:);
train_data=data(1:end-1000,:);
train_label = label(1:end-1000,:);

% Get data online
batch_size = 50;
addpath('LS-ILDA');

% Divide data into different parts
parts=ceil(size(train_data,1)/batch_size);
parts_end=(1:parts)'*batch_size;
parts_end(end,1)=size(train_data,1);



% T,Tinv: dim*dim, m:dim*1 mean features, r:rank of T, 
% W:dim*class, Y:normaled label, nc: number of each class. 
[T, Tinv, m, r, W, Y, lab, nc] = initLS_ILDA2(init_data', init_label);
n=2;
%train_command=['-q',' -t ',0,' -g ',g, ' -c ',c];
train_command=['-q'];
accuracyList=[];
for i=1:size(train_data,1)
    p = train_label(i);
    u = (train_data(i,:)' - m)/(n+1);
    n=n+1;
    m=m+u;
    if r < size(train_data,2)
        [Tinv, W, Y, lab, nc, T, r] = LS_ILDA2(Tinv, W, Y, lab, nc, u, p, T, r);
    else
        [Tinv, W, Y, lab, nc] = LS_ILDA2(Tinv, W, Y, lab, nc, u, p);
    end
    
    if(mod(i, batch_size) == 0)
        model=libsvmtrain(train_label(1:i,:),train_data(1:i,:)*W,train_command);
        [predict_label,accuracy,score]=libsvmpredict(test_label,test_data*W,model,'-q');
        accuracyList=[accuracyList;accuracy(1,1)];
    end
    
end

accuracyList




