clear;
dataset = 'DND_2017';
Original_image_dir = 'DND_2017/images_srgb/';
fpath = fullfile(Original_image_dir, '*.mat');
im_dir  = dir(fpath);
im_num = length(im_dir);
load 'DND_2017/info.mat';

method = 'GID';
% write image directory
write_MAT_dir = [dataset '_Results/'];
write_sRGB_dir = [write_MAT_dir method];
if ~isdir(write_sRGB_dir)
    mkdir(write_sRGB_dir)
end

load PG-GMM_TrainingCode/PGGMM_RGB_6x6_3_win15_nlsp10_delta0.001_cls33.mat;
% dictionary and regularization Parameter
Par.D= GMM.D;
Par.S = GMM.S;
Par.step = 3;       % the step of two neighbor patches
Par.IteNum = 3;  % the iteration number
Par.ps = ps;        % patch size
Par.nlsp = nlsp;  % number of non-local patches
Par.win = win;    % size of window around the patch
Par.c1 = .05; % this parameter needs to be tuned
%         Par.c2 = 0.005;
Par.En = 54; % the number of external dictionary items

alltime = zeros(1,im_num);
for i = 1:im_num
    Par.image = i;
    load(fullfile(Original_image_dir, im_dir(i).name));
    S = regexp(im_dir(i).name, '\.', 'split');
    [h,w,ch] = size(InoisySRGB);
    for j = 1:size(info(1).boundingboxes,1)
        IMinname = [S{1} '_' num2str(j)];
        fprintf('%s: \n', IMinname);
        bb = info(i).boundingboxes(j,:);
        Par.nim = InoisySRGB(bb(1):bb(3), bb(2):bb(4),:);
        Par.I = Par.nim;
        % noise estimation
        for c = 1:ch
            Par.nSig(c) = NoiseEstimation(Par.nim(:, :, c)*255, Par.ps)/255;
        end
        % denoising
        t1=clock;
        [IMout,Par]  =  Denoising_Guided_EI(Par,model);
        t2=clock;
        etime(t2,t1)
        alltime(Par.image)  = etime(t2, t1);
        %% output
        IMoutname = sprintf([write_sRGB_dir '/' method '_DND_' IMinname '.png']);
        imwrite(IMout, IMoutname);
    end
end