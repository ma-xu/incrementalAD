function [T, Tinv, m, r, W, Y, lab, nc] = initLS_ILDA2(X, lab)
n = length(lab);
m = mean(X, 2);
X = X - m*ones(1,n);
T = X*X';
Tinv = pinv(T);
r = rank(T);

s = length(unique(lab));
Y = zeros(n, s);
for i = 1:n
    Y(i, lab(i)) = 1;
end
nc = sum(Y);
Y = normc(Y);
W = Tinv*X*Y;