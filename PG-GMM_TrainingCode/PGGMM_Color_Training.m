clear;
TD_path = './Kodak24/';
% Set the parameters
step = 3;
delta = 0.001;
win = 15;
ps = 6;
nlsp = 10;
cls_num = 32;
ch = 3;
% read natural clean images
fpath       =   fullfile(TD_path, '*.png');
im_dir      =   dir(fpath);
im_num      =   length(im_dir);
X     =  [];
X0 = [];
for  i  =  1:im_num
    im         =   im2double( imread(fullfile(TD_path, im_dir(i).name)) );
    [Px, Px0] =   Get_PG( im,win, ps ,nlsp,step,delta);
    clear im;
    X0 = [X0 Px0];
    X   = [X Px];
    clear Px Px0;
end
% PG-GMM Training
[model,llh,cls_idx] = emgm(X,cls_num,nlsp);
[s_idx, seg]    =  Proc_cls_idx( cls_idx );
cls_num = size(model.R,2)+1;
model.R = []; % R is now useless
model.means(:,cls_num) = mean(X0,2);
model.covs(:,:,cls_num) = cov(X0');
length0 = size(X0,2)/nlsp;
model.mixweights = [model.mixweights length0/(length0 + length(cls_idx))]/(sum(model.mixweights) + length0/(length0 + length(cls_idx)));
model.nmodels = model.nmodels + 1;
% Get GMM dictionaries and regularization parameters
for  i  =  1 : length(seg)-1
    idx    =   s_idx(seg(i)+1:seg(i+1));
    cls    =   cls_idx(idx(1));
    [P,S,~] = svd(model.covs(:,:,i));
    S = diag(S);
    GMM.D{cls}    =  P;
    GMM.S{cls}    =  S;
    Xc{cls} = X(:, idx);
end
[P0,S0,~] = svd(model.covs(:,:,cls_num));
S0 = diag(S0);
GMM.D{cls_num}    =  P0;
GMM.S{cls_num}    =  S0;
X0 = X0(:,randi(size(X0,2), [1 5e4]));
Xc{cls_num} = X0;
% save PG-GMM model
modelname = sprintf('PGGMM_RGB_%dx%d_%d_win%d_nlsp%d_delta%2.3f_cls%d.mat',ps,ps,ch,win,nlsp,delta,cls_num);
save(modelname,'model','nlsp','GMM','cls_num','delta','ps','win','-v7.3');
% % save the extracted patch groups
% modelname = sprintf('Kodak24_RGB_PGs_%dx%d_%d_win%d_nlsp%d_delta%2.3f_cls%d.mat',ps,ps,ch,win,nlsp,delta,cls_num);
% save(modelname,'Xc','-v7.3');
