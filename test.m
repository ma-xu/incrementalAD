% load training and testing data
load_data;


% Get data online
batch_size = 40;
addpath('LS-ILDA');

[T, Tinv, m, r, W, Y, lab, nc] = initLS_ILDA2(X_org, lab_org); 



