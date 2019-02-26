clear;
clc;

%% Import train_data
train_dataList=[
    "../Data/mat/20110326.mat";
    "../Data/mat/20110327.mat";
    "../Data/mat/20110328.mat";
    "../Data/mat/20110329.mat";
    "../Data/mat/20110330.mat";
    "../Data/mat/20110331.mat";
];
train_data=[];
train_label=[];
for i=1:length(train_dataList)
    counterpart = load(train_dataList(i,1));
    train_data=[train_data;counterpart.Struct.data];
    train_label = [train_label; counterpart.Struct.label];
end

% postive label 1, negative label -1.
train_label(train_label~=0)=-1;
train_label(train_label==0)=1;

% random data order
rand('state',111);
rand_order=randperm(size(train_data,1));
train_data=train_data(rand_order,:);
train_label=train_label(rand_order,:); 
clearvars -except train_data train_label;

%% Import test_data
test_dataList=[
    "../Data/mat/20110925.mat";
    "../Data/mat/20110924.mat";
    "../Data/mat/20110923.mat";
    "../Data/mat/20110922.mat";
    "../Data/mat/20110921.mat";
    "../Data/mat/20110920.mat";
];
test_data=[];
test_label=[];
for i=1:length(test_dataList)
    counterpart = load(test_dataList(i,1));
    test_data=[test_data;counterpart.Struct.data];
    test_label = [test_label; counterpart.Struct.label];
end

% postive label 1, negative label -1.
test_label(test_label~=0)=-1;
test_label(test_label==0)=1;

% random data order
rand('state',111);
rand_order=randperm(size(test_data,1));
test_data=test_data(rand_order,:);
test_label=test_label(rand_order,:); 
clearvars -except test_data test_label train_data train_label;
