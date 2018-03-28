function model = maximization(X, R,nlsp)
[d,n] = size(X);
R = R(reshape(ones(nlsp,1)*(1:size(R,1)),size(R,1)*nlsp,1),:);
k = size(R,2);

nk = sum(R,1);
w = nk/n;
% means = bsxfun(@times, X*R, 1./nk);
means = zeros(d,k);

Sigma = zeros(d,d,k);
sqrtR = sqrt(R);

for i = 1:k
    Xo = bsxfun(@minus,X,means(:,i));
    Xo = bsxfun(@times,Xo,sqrtR(:,i)');
    Sigma(:,:,i) = Xo*Xo'/nk(i);
    Sigma(:,:,i) = Sigma(:,:,i)+eye(d)*(1e-6); % add a prior for numerical stability
end

model.dim = d;
model.nmodels = k;
model.mixweights = w;
model.means = means;
model.covs = Sigma;