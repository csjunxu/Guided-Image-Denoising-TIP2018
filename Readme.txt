% ===============================================================
The code in this package implements the Guided Image Denoising method for
image denoising as described in the following paper:

  Jun Xu, Lei Zhang, and David Zhang
  External Prior Guided Internal Prior Learning for Real-World Noisy Image Denoising.
  IEEE Transactions on Image Processing (TIP), 2018.

Please cite the paper if you are using this code in your research.
Please see the file License.txt for the license governing this code.

  Version:       1.0 (03/28/2018), see ChangeLog.txt
  Contact:       Jun Xu <csjunxu@comp.polyu.edu.hk/nankaimathxujun@gmail.com>
% ===============================================================

Note
------------
Please refer to https://github.com/csjunxu/GID_TIP2018 for the updates of the code.

Overview
------------
Training Code:
The code for learning external prior is provided in the folder "PG-GMM_TrainingCode", which relies
on the training images in the subfolder "Kodak24" (please refer to the "Data" section).

Testing Code:
The function "Demo_Guided_DND2017" demonstrates real-world image denoising with the Guided Image 
Denoising method introduced in the paper.

The function "Demo_Guided" demonstrates real-world image denoising with 
"ground truth" by the Guided Image Denoising method introduced in the paper.

The function "Demo_Guided_NoGT" demonstrates real-world image denoising 
without "ground truth" by the Guided Image Denoising method introduced in the paper.


Model
------------
The trained model "PGGMM_RGB_6x6_3_win15_nlsp10_delta0.001_cls33.mat" can be downloaded from
https://github.com/csjunxu/GID_TIP2018/PG-GMM_TrainingCode


Data
------------
Please download the data from corresponding addresses.
1. Kodak24: 24 high quality color images from Kodak PhotoCD dataset
                        This dataset can be found at http://r0k.us/graphics/kodak/
2. NCImages: real-world noisy images with no ''ground truth'' from "NoiseClinic"
                        This dataset can be found at http://demo.ipol.im/demo/125/

The "CCImages" directory include two parts:
3. CC15: 15 cropped real-world noisy images from CC [1]. 
                        This dataset can be found at  http://snam.ml/research/ccnoise
                        The smaller 15 cropped images can be found on in the directory 
                        ''Real_ccnoise_denoised_part'' of 
                        https://github.com/csjunxu/MCWNNM_ICCV2017
                                                The *real.png are noisy images;
                                                The *mean.png are "ground truth" images;
                                                The *ours.png are images denoised by CC.
4. CC60: 60 cropped (by us) real-world noisy images from CC [1]. 
                        "CC_60MeanImage" inlcudes the "ground truth" images;
                        "CC_60NoisyImage" inlcudes the noisy images;

5. DND_2017: 1000 cropped real-world noisy images from DND [2].
                         Please download the dataset from https://noise.visinf.tu-darmstadt.de/
                         and put the files in "DND_2017" directory accordingly.
6. PolyUImages: 100 cropped images from our new dataset.
                                                The *real.JPG are noisy images;
                                                The *mean.JPG are "ground truth" images;

[1] Seonghyeon Nam*, Youngbae Hwang*, Yasuyuki Matsushita, Seon Joo Kim. A Holistic Approach to 
      Cross-Channel Image Noise Modeling and its Application to Image Denoising. CVPR, 2016.
[2] Tobias Pl?tz and Stefan Roth. Benchmarking Denoising Algorithms with Real Photographs. CVPR, 2017.


Dependency
------------
This code is implemented purely in Matlab2014b and doesn't depends on any other toolbox.


Contact
------------
If you have questions, problems with the code, or find a bug, please let us know. Contact Jun Xu at 
csjunxu@comp.polyu.edu.hk or nankaimathxujun@gmail.com
