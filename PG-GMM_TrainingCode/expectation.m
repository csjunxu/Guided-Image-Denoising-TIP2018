function [R, llh] = expectation(X, model,nlsp)
means = model.means;
covs = model.covs;
w = model.mixweights;

n = size(X,2)/nlsp;
k = size(means,2);
logRho = zeros(n,k);

for i = 1:k
    TemplogRho = loggausspdf(X,means(:,i),covs(:,:,i));
    Temp = reshape(TemplogRho,[nlsp n]);
    logRho(:,i) = sum(Temp);
end
logRho = bsxfun(@plus,logRho,log(w));
T = logsumexp(logRho,2);
llh = sum(T)/n; % loglikelihood
logR = bsxfun(@minus,logRho,T);
R = exp(logR);
