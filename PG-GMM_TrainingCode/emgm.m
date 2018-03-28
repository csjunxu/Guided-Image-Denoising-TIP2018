function [model,llh,label]= emgm(X, init,nlsp)
% Perform EM algorithm for fitting the Gaussian mixture model.
%   X: d x n data matrix
%   init: k (1 x 1) or label (1 x n, 1<=label(i)<=k) or center (d x k)
% Written by Michael Chen (sth4nth@gmail.com).
%% initialization
fprintf('EM for PG-GMM: running ... \n');
R = initialization(X,init,nlsp);
[~,label(1,:)] = max(R,[],2);
R = R(:,unique(label));

tol = 1e-10;
maxiter = 100; 
llh = -inf(1,maxiter);
converged = false;
t = 1;
while ~converged && t < maxiter
    t = t+1;
    model = maximization(X,R,nlsp);
    clear R;
    [R, llh(t)] = expectation(X,model,nlsp);
    % output
    fprintf('Iteration %d of %d, logL: %.2f\n',t,maxiter,llh(t));
    % output
    subplot(1,2,1);
    plot(llh(1:t),'o-'); drawnow;
    [~,label(:)] = max(R,[],2);
    u = unique(label);   % non-empty components
    if size(R,2) ~= size(u,2)
        R = R(:,u);   % remove empty components
    else
        converged = llh(t)-llh(t-1) < tol*abs(llh(t));
    end
end

label=label';
model.R = R;
if converged
    fprintf('Converged in %d steps.\n',t-1);
else
    fprintf('Not converged in %d steps.\n',maxiter);
end
