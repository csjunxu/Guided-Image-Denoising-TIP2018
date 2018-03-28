%--------------------------------------------------------------------------------------------------------------------
% External Prior Guided Internal Prior Learning for Real-World Noisy Image Denoising
% IEEE Transactions on Image Processing (TIP), 2018.
% Author:  Jun Xu, csjunxu@comp.polyu.edu.hk/nankaimathxujun@gmail.com
%              The Hong Kong Polytechnic University
%--------------------------------------------------------------------------------------------------------------------
function  [im_out,par] = Denoising_Guided_NoGT(par,model)
im_out = par.nim;
[h,  w, ch] = size(im_out);
par.maxr = h-par.ps+1;
par.maxc = w-par.ps+1;
par.maxrc = par.maxr * par.maxc;
par.h = h;
par.w = w;
par.ch = ch;
r = 1:par.step:par.maxr;
par.r = [r r(end)+1:par.maxr];
c = 1:par.step:par.maxc;
par.c = [c c(end)+1:par.maxc];
par.lenr = length(par.r);
par.lenc = length(par.c);
par.lenrc = par.lenr*par.lenc;
par.ps2 = par.ps^2;
par.ps2ch = par.ps2*par.ch;
% parameters for Pad noisy image
hp = h + 2*par.win;
wp = w + 2*par.win;
par.maxrp = hp-par.ps+1;
par.maxcp = wp-par.ps+1;
par.maxrcp = par.maxrp*par.maxcp;
% positions for integral image
par.x = par.r+par.ps+par.win-1;
par.y = par.c+par.ps+par.win-1;
par.x0 = par.r+par.win-1;
par.y0 = par.c+par.win-1;
for ite = 1 : par.IteNum
    %     noiselevel = NoiseEstimation(im_out*255,8);
    %     fprintf('The noise level is %2.4f.\n',noiselevel);
    % search non-local patch groups
    [nDCnlX,blk_arr,DC,par] = Image2PGs_II( im_out, par);
    % Gaussian dictionary selection by MAP
    if mod(ite-1,2) == 0
        %% GMM: full posterior calculation
        nPG = size(nDCnlX,2)/par.nlsp; % number of PGs
        PYZ = zeros(model.nmodels,nPG);
        for i = 1:model.nmodels
            sigma = model.covs(:,:,i);% + par.nSig^2 *eye(size(model.covs(:,:,i)));
            [R,~] = chol(sigma);
            Q = R'\nDCnlX;
            TempPYZ = - sum(log(diag(R))) - dot(Q,Q,1)/2;
            TempPYZ = reshape(TempPYZ,[par.nlsp nPG]);
            PYZ(i,:) = sum(TempPYZ);
        end
        %% find the most likely component for each patch group
        [~,dicidx] = max(PYZ);
        dicidx=repmat(dicidx, [par.nlsp 1]);
        dicidx = dicidx(:);
        [idx,  s_idx] = sort(dicidx);
        idx2 = idx(1:end-1) - idx(2:end);
        seq = find(idx2);
        seg = [0; seq; length(dicidx)];
    end
    % Weighted Sparse Coding
    X_hat = zeros(par.ps2*par.ch,par.maxrc,'double');
    W = zeros(par.ps2*par.ch,par.maxrc,'double');
    for   j = 1:length(seg)-1
        idx =   s_idx(seg(j)+1:seg(j+1));
        Y = nDCnlX(:,idx);
        [Dn,Sn,~] = svd(cov(Y'));
        Sn = diag(Sn);
        lambdaM = repmat(par.c1./ (sqrt(Sn)+eps),[1 length(idx)]);
        b = Dn'*Y;
        %         soft threshold
        alpha = sign(b).*max(abs(b)-lambdaM,0);
        %         add DC components and aggregation
        X_hat(:,blk_arr(:,idx)) = X_hat(:,blk_arr(:,idx))+bsxfun(@plus,Dn*alpha, DC(:,idx));
        W(:,blk_arr(:,idx)) = W(:,blk_arr(:,idx))+ones(par.ps2*ch, length(idx));
    end
    % Reconstruction
    im_out = PGs2Image(X_hat,W,par);
end
im_out(im_out > 1) = 1;
im_out(im_out < 0) = 0;
return;