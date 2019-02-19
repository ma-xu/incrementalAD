clear;clc;close all;
run('../load_data_4error');
data=mapminmax(data');
data=data';

classes = length(unique(label));
if sum(label==0)>0
    label=label+1;
end

% Divide into train and test
test_data=data(end-1000+1:end,:);
test_label = label(end-1000+1:end,:);
train_data = data(1:end-1000,:);
train_label = label(1:end-1000,:);
clear data label;


train_command=['-q',' -t ',1,'-s',0];
model=libsvmtrain(train_label,train_data,train_command);
[predict_label,accuracy,score]=libsvmpredict(test_label,test_data,model,'-q');
accuracy
%accuracyList=[accuracyList;accuracy(1,:)]