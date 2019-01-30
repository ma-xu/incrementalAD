function [X, Xinv, m, W, Y, lab, nc] = initLS_ILDA1(X, lab)
n = length(lab);
m = mean(X, 2);
X = X - m*ones(1,n);
s = length(unique(lab));
Y = zeros(n, s);

for i = 1:n
    Y(i, lab(i)) = 1;
end
nc = sum(Y);
Y = normc(Y);
Xinv = pinv(X);
W = Xinv'*Y;