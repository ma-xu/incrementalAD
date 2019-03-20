load fisheriris
x = meas(51:end,1:2);        % iris data, 2 classes and 2 features
y = (1:100)'>50;             % versicolor=0, virginica=1
b = glmfit(x,y,'binomial');  % logistic regression
p = glmval(b,x,'logit');     % get fitted probabilities for scores

[X,Y] = perfcurve(species(51:end,:),p,'virginica');
plot(X,Y)
xlabel('False positive rate'); ylabel('True positive rate')
title('ROC for classification by logistic regression')