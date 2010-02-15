function linregFitL1Test()

% check that different fitting methods for lasso regression give same result

%% Make some data
setSeed(0);
N=50;
%N=20;
D=50; % dinensionality
rho=.5;
correl=zeros(D,D);
for i=1:D
   for j=1:D
       correl(i,j)=rho^(abs(i-j));
   end
end
X=randn(N,D)*chol(correl);
% true weight vector has 3 non zero components
w_true=[3 1.5 0 0 2 0 0 0 zeros(1,D-8)]';
sigma = 1;
y=X*w_true+1*sigma*randn(N,1);

figure; nr = 2; nc = 2;
subplot(nr, nc, 1)
doPlot(w_true, w_true, 'true')

%% Fit
lambda = 10;
methods = {'shooting', 'lars', 'interiorPoint'};
for i=1:length(methods)
  method = methods{i};
  model{i} = linregFitL1(X, y, lambda, method);
  if i > 1
    assert(approxeq(model{i}.w, model{1}.w))
  end
  subplot(nr, nc, i+1)
  doPlot(model{i}.w, w_true, method)
end


end


function doPlot(w, w_true, name)
D = length(w);
stem(w)
err=norm(w-w_true);
nz=sum(abs(w)<10^-3);
title(sprintf('%s, error %5.3f, # zeros %d',  name, err, nz))
xlim([.5,D+.5]);
ylim([0 4])
end