%{
Load data from 201110920 to 20110925.
Combine these 6 files.
Disorder the data
Un-normalized.
Label 0-Normal
Label 1-Memory Failure
Label 2-CPU Failure
Label 3-Network Failure
Label 4-Disk Failure
%}

%% Import data in Sep
dataList=[
    "Data/mat/20110925.mat";
    "Data/mat/20110924.mat";
    "Data/mat/20110923.mat";
    "Data/mat/20110922.mat";
    "Data/mat/20110921.mat";
    "Data/mat/20110920.mat";
];
data=[];
label=[];
for i=1:length(dataList)
    counterpart = load(dataList(i,1));
    data=[data;counterpart.Struct.data];
    label = [label; counterpart.Struct.label];
end


% random data order
rand('state',111);
rand_order=randperm(size(data,1));
data=data(rand_order,:);
label=label(rand_order,:); 
clearvars -except data label;
