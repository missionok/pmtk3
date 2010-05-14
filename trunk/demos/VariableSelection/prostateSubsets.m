%% Reproduce fig 3.5 on p56 of "Elements of statistical learning" 
%
%%
load prostate
[n, d] = size(X);
mse = zeros(2^8-1, 1); 
ss = powerset(1:d);
ss(1) = [];
for i=1:numel(ss);
    ndx = ss{i};
    model = linregFit(X(:, ndx), y);
    model.w = padZeros(model.w, ndx, [d, 1]);
    model.preproc.Xmu = padZeros(model.preproc.Xmu, ndx, [1, d]);
    model.preproc.Xstnd = padOnes(model.preproc.Xstnd, ndx, [1, d]);
    yhat = linregPredict(model, X); 
    mse(i) = mean((yhat - y).^2);
end
mse0 = mean((y - mean(y)).^2);
mse = [mse0; mse];
sz = [0; cellfun(@numel, ss)]; % sizes of each subset. 
figure; hold on;
plot(sz, mse, '.');
bestScores = zeros(1, d + 1);
for i=0:d
    bestScores(i+1) = min(mse(sz==i));
end
plot(0:d, bestScores, 'ro-', 'MarkerSize', 8, 'LineWidth', 2);
xlabel('subset size')
ylabel('training set error');
title('all subsets on prostate cancer')
box on;    

