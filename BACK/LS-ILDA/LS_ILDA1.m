function  [X1, X1inv, W1, Y1, lab1, nc] = LS_ILDA1(X, Xinv, W, Y, lab, nc, u, p)
%% begin of function
[d, n] = size(X);
s = size(Y, 2);
e = ones(n,1);
X1 = [X - u*e', n*u];
lab1 = [lab; p];
a = Xinv*u;
f = u - X*a;
k = u'*f;

lastcol = f/((n+1)*k);
X1inv = [Xinv - (a + 1/(n*n+n))*(f'/k); lastcol'];

W1 = W - f*((u'*W)/k - sum(Y)/((n*n+n)*k));
% if p>s
%     W1 = [W1, zeros(d, 1)];
%     nc = [nc, 1];
%     Y1 = [Y, zeros(n,1);zeros(1,s), 1];
%     code = 1;
% else
    W1(:, p) = W1(:, p)*sqrt(nc(p)/(nc(p)+1));
     nc(p) = nc(p) +1;
    code = 1/sqrt(nc(p));
    Y1 = [Y; zeros(1, s)];
    Y1(Y1(:, p) > 0, p) = code;
    Y1(end, p) = code;
   
%end
W1(:, p) = W1(:, p) + lastcol*code;