clear;clc;
y=        [1 2 3 4 5 5 5 3 2 1 3 4 5];
y_predict=[1 2 3 4 1 5 5 3 2 1 3 4 1];
[cm,~] = confusionmat(y,y_predict)