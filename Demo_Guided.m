clear;
%% 15 images of CC dataset
% dataset = 'CC15';
% GT_Original_image_dir = 'CCImages/CC15/';
% GT_fpath = fullfile(GT_Original_image_dir, '*mean.png');
% TT_Original_image_dir = 'CCImages/CC15/';
% TT_fpath = fullfile(TT_Original_image_dir, '*real.png');

%% 60 images of CC dataset
dataset = 'CC60';
GT_Original_image_dir = 'CCImages/CC_60MeanImage/';
GT_fpath = fullfile(GT_Original_image_dir, '*.png');
TT_Original_image_dir = 'CCImages/CC_60NoisyImage/';
TT_fpath = fullfile(TT_Original_image_dir, '*.png');

%% 100 images of our new dataset
% dataset = 'PolyU100';
% GT_Original_image_dir = 'PolyUImages/';
% GT_fpath = fullfile(GT_Original_image_dir, '*mean.JPG');
% TT_Original_image_dir = 'PolyUImages/';
% TT_fpath = fullfile(TT_Original_image_dir, '*real.JPG');

GT_im_dir  = dir(GT_fpath);
TT_im_dir  = dir(TT_fpath);
im_num = length(TT_im_dir);

method = 'GID';
write_MAT_dir = [dataset '_Results/'];
write_sRGB_dir = [write_MAT_dir method];
if ~isdir(write_sRGB_dir)
    mkdir(write_sRGB_dir)
end

load PG-GMM_TrainingCode/PGGMM_RGB_6x6_3_win15_nlsp10_delta0.001_cls33.mat;
% dictionary and regularization parameter
par.D= GMM.D;
par.S = GMM.S;
par.step = 3;       % the step of two neighbor patches
par.IteNum = 3;  % the iteration number
par.ps = ps;        % patch size
par.nlsp = nlsp;  % number of non-local patches
par.win = win;    % size of window around the patch
par.En = 54;

if strcmp(dataset, 'CC15')==1
    par.c1 = 0.001;
elseif strcmp(dataset, 'CC60')==1
    par.c1 = 0.0016;
elseif strcmp(dataset, 'PolyU100')==1
    par.c1 = 0.001;
end
%         par.c2 = 0.005;
par.En = 54;
par.PSNR = [];
par.SSIM = [];
CCPSNR = [];
CCSSIM = [];
alltime = zeros(1,im_num);
for i = 1 : im_num
    IMin = im2double(imread(fullfile(TT_Original_image_dir, TT_im_dir(i).name) ));
    IM_GT = im2double(imread(fullfile(GT_Original_image_dir, GT_im_dir(i).name)));
    S = regexp(TT_im_dir(i).name, '\.', 'split');
    IMname = S{1};
    [h,w,ch] = size(IMin);
    fprintf('%s: \n',TT_im_dir(i).name);
    CCPSNR = [CCPSNR csnr( IMin*255,IM_GT*255, 0, 0 )];
    CCSSIM = [CCSSIM cal_ssim( IMin*255, IM_GT*255, 0, 0 )];
    fprintf('The initial PSNR = %2.4f, SSIM = %2.4f. \n', csnr( IMin*255,IM_GT*255, 0, 0 ), cal_ssim( IMin*255, IM_GT*255, 0, 0 ));
    par.I = IM_GT;
    par.nim =   IMin;
    par.imIndex = i;
    % Guided denoising
    t1=clock;
    [IMout,par]  =  Denoising_Guided_EI(par,model);
    t2=clock;
    etime(t2,t1)
    alltime(par.imIndex)  = etime(t2,t1);
    % calc ulate the PSNR and SSIM
    par.PSNR(par.IteNum,par.imIndex) =   csnr( IMout*255, IM_GT*255, 0, 0 );
    par.SSIM(par.IteNum,par.imIndex)      =  cal_ssim( IMout*255, IM_GT*255, 0, 0 );
    fprintf('The final : PSNR = %2.4f, SSIM = %2.4f\n', par.PSNR(par.IteNum,par.imIndex),par.SSIM(par.IteNum,par.imIndex));
    % output
    imwrite(IMout, [write_sRGB_dir '/' method '_' dataset '_' IMname '.png']);
end
PSNR = par.PSNR;
SSIM = par.SSIM;
mPSNR = mean(par.PSNR,2);
mSSIM = mean(par.SSIM,2);
mtime  = mean(alltime);
mCCPSNR = mean(CCPSNR);
mCCSSIM = mean(CCSSIM);
matname = sprintf([write_MAT_dir method '_' dataset '.mat']);
save(matname,'PSNR','mPSNR','SSIM','mSSIM','CCPSNR','mCCPSNR','CCSSIM','mCCSSIM');
