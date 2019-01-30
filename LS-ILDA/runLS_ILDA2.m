function runLS_ILDA2()
%test of ILDA
load('reduced_ORL_3parts.mat');
chunksize = 5;
n = size(X_org,2);
[T, Tinv, m, r, W, Y, lab, nc] = initLS_ILDA2(X_org, lab_org);
[d, b] = size(X_inc);
X = X_org; lab = lab_org;
nupdate = ceil(b/chunksize);
times = zeros(nupdate, 1);
precs = zeros(nupdate, 1);
i_ch = 1;
for i = 1:b
    x = X_inc(:, i); p = lab_inc(i);    
    tic
    u = (x - m)/(n+1);
    n = n+1;
    m = m+ u;
    if r < d
        [Tinv, W, Y, lab, nc, T, r] = LS_ILDA2(Tinv, W, Y, lab, nc, u, p, T, r);
    else
        [Tinv, W, Y, lab, nc] = LS_ILDA2(Tinv, W, Y, lab, nc, u, p);
    end
    times(i_ch) = times(i_ch) + toc; 
    if(mod(i, chunksize) == 0)
        X = [W'*X_org, W'*X_inc(:, 1:i)];
        precs(i_ch) = KNN(X, lab,  W'*X_tst, lab_tst);
        i_ch = i_ch + 1;
    end
end
X = [W'*X_org, W'*X_inc];
lab = [lab_org; lab_inc];
if(mod(i, chunksize) ~= 0)
    precs(i_ch) = KNN(X, lab,  W'*X_tst, lab_tst);
end

time_spent_in_each_round = times'
precision_in_each_round = precs'
