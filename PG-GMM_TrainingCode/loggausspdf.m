function y = loggausspdf(X, mu, Sigma)
d = size(X,1);
X = bsxfun(@minus,X,mu);
%   [R,p] = CHOL(A), with two output arguments, never produces an
%   error message.  If A is positive definite, then p is 0 and R
%   is the same as above.   But if A is not positive definite, then
%   p is a positive integer.
[U,p]= chol(Sigma);
if p ~= 0
    error('ERROR: Sigma is not PD.');
end
Q = U'\X;
q = dot(Q,Q,1);  % quadratic term (M distance)
c = d*log(2*pi)+2*sum(log(diag(U)));   % normalization constant
y = -(c+q)/2;