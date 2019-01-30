function [T1inv, W1, Y1, lab1, nc, T1, r1] = LS_ILDA2(Tinv, W, Y, lab, nc, u, p, T, r)
%% begin of function
n = size(Y,1);
a = Tinv*u;
if nargin > 8
    T1 = T + (n*n + n)*u*u';
    h = u - T*a;
    r1 = r;
else
    h = 0;
end

if sum(abs(h)) < 1e-9 %|| length(argin) < 10
    k = (n*n + n)/(1 + (n*n + n)*u'*a);
    C = - k * a * a';
    G = W - k*a*(u'*W);
else
    k = u'*h;
    A = a*h';
    C = - (A + A')/k + (1+ (n*n + n)*(a'*u))/((n*n + n)*k*k) * h*h';
    r1 = r + 1;
    G = W - h*(u'*W)/k;
end
T1inv = Tinv + C;
a1 = T1inv*u;
W1 = G - a1*sum(Y);

s = size(Y, 2);
W1(:, p) = W1(:, p)*sqrt(nc(p)/(nc(p)+1));
code = 1/sqrt(nc(p)+1);
labp = Y(:,p);
labp(labp > 0) = code;
labp = [labp; code];
Y1 = [Y; zeros(1, s)];
Y1(:, p) = labp;
nc(p) = nc(p) +1;

lab1 = [lab; p];
W1(:, p) = W1(:, p) + a1*(n*code);