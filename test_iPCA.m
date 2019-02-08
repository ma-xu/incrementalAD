clear;clc;
% load testing data
load_data;
clear train_data train_label;
data = test_data;
label = test_label;
%label(label==-1)=2;

%mapminmax will remap lines into a resonable scale.
data=mapminmax(data');
data=data';
steps=100;

Q=zeros(size(data,1),2);
for i=1:steps:size(data,1)
   XNEW = data(i:i+steps,:)';
   [COEFF,LATENT,Q] =IncrementalPCA(Q,i,XNEW) ;
  % [COEFF,LATENT,Q,m,sqs]=IncrementalPCA(Q,n,xNEW,COEFF,LATENT,m,sqs);
    i
end






