clear;
dataset = 'NC';
TT_Original_image_dir = 'NCImages/';
TT_fpath = fullfile(TT_Original_image_dir, '*.png');
TT_im_dir  = dir(TT_fpath);
im_num = length(TT_im_dir);

method = 'Guided';
write_sRGB_dir = [dataset '_Results/' method];
if ~isdir(write_sRGB_dir)
    mkdir(write_sRGB_dir)
end

load PG-GMM_TrainingCode/PGGMM_RGB_6x6_3_win15_nlsp10_delta0.001_cls33.mat;
% dictionary and regularization parameter
par.D= GMM.D;
par.S = GMM.S;
par.step = 2;      % the step of two neighbor patches
par.IteNum = 4; % the iteration number
par.ps = ps;        % patch size
par.nlsp = nlsp;  % number of non-local patches
par.win = win;   % size of window around the patch
par.c1 = 0.001; % it is better to set different c1 for different images
for i = 1 : im_num
    IMin = im2double(imread(fullfile(TT_Original_image_dir,TT_im_dir(i).name) ));
    S = regexp(TT_im_dir(i).name, '\.', 'split');
    IMname = S{1};
    [h,w,ch] = size(IMin);
    if ch ==1
        continue;
    end
    fprintf('%s: \n',TT_im_dir(i).name);
    par.nim =   IMin;
    par.imIndex = i;
    % PGPD denoising
    [IMout,par]  =  Denoising_Guided_NoGT(par,model);
    %% output
    imwrite(IMout, [write_sRGB_dir '/Guided_' dataset '_' IMname '.png']);
end

