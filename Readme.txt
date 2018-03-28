% ===============================================================
The code in this package implements the Guided Image Denoising method for
image denoising as described in the following paper:

  Jun Xu, Lei Zhang, Wangmeng Zuo, David Zhang, and Xiangchu Feng,
  External Prior Guided Internal Prior Learning for Real-World Noisy Image Denoising.
  IEEE Transactions on Image Processing (TIP), 2018.

Please cite the paper if you are using this code in your research.
Please see the file License.txt for the license governing this code.

  Version:       1.0 (03/28/2018), see ChangeLog.txt
  Contact:       Jun Xu <csjunxu@comp.polyu.edu.hk/nankaimathxujun@gmail.com>
% ===============================================================
Overview
------------
The code for learning Patch Group Prior is implemented in the folder "PG-GMM_TrainingCode", which relies
on the training images in the subfolder "Kodak24" (please refer to the "Data" section).

The function "Demo_Guided_DND2017" demonstrates real-world image denoising with the Guided Image 
Denoising method introduced in the paper.

The function "Demo_Guided" demonstrates real-world image denoising with 
"ground truth" by the Guided Image Denoising method introduced in the paper.

The function "Demo_Guided_NoGT" demonstrates real-world image denoising 
without "ground truth" by the Guided Image Denoising method introduced in the paper.

Data
------------
Please download the data from corresponding addresses.
1. Kodak24: 24 high quality color images from Kodak PhotoCD dataset
                        This dataset can be found at http://r0k.us/graphics/kodak/
2. NCImages: real-world noisy images with no ''ground truth'' from "NoiseClinic"
                        This dataset can be found at http://demo.ipol.im/demo/125/
3. CC15: 15 cropped real-world noisy images from CC [1]. 
                        This dataset can be found at  http://snam.ml/research/ccnoise
                        The smaller 15 cropped images can be found on in the directory 
                        ''Real_ccnoise_denoised_part'' of 
                        https://github.com/csjunxu/MCWNNM_ICCV2017
                                                The *real.png are noisy images;
                                                The *mean.png are "ground truth" images;
                                                The *ours.png are images denoised by CC.
3. CC60: 60 cropped real-world noisy images from CC [1]. 
                        This dataset can be found at  http://snam.ml/research/ccnoise
                        The smaller 15 cropped images can be found on in the directory 
                        ''Real_ccnoise_denoised_part'' of 
                        https://github.com/csjunxu/MCWNNM_ICCV2017
                                                The *real.png are noisy images;
                                                The *mean.png are "ground truth" images;
                                                The *ours.png are images denoised by CC.

[1] A Holistic Approach to Cross-Channel Image Noise Modeling and its Application to Image Denoising. 
     Seonghyeon Nam*, Youngbae Hwang*, Yasuyuki Matsushita, Seon Joo Kim, CVPR, 2016.


Dependency
------------
This code is implemented purely in Matlab2014b and doesn't depends on any other toolbox.

Contact
------------
If you have questions, problems with the code, or find a bug, please let us know. Contact Jun Xu at 
csjunxu@comp.polyu.edu.hk or the email provided on my website at www.wangliuqing.tk.
