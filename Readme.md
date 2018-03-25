**Description:**

This repository contains the code associated with the following paper:

Ashkan Abbasi, Amirhassan Monadjemi, Leyuan Fang, Hossein Rabbani, "Optical coherence tomography retinal image reconstruction via nonlocal weighted sparse representation," J. Biomed. Opt. 23(3), 036011 (2018), doi:10.1117/1.JBO.23.3.036011. 

We introduce a method for OCT retinal image denoising and interpolation. If you find it useful, kindly cite the above paper.


**Requirements:**

Before running the code, you need to do the following steps:

1) Download datasets for training and testing from 
    http://people.duke.edu/~sf59/Fang_TMI_2013.htm
2) Create a "datasets" folder and copy the followings two folders in it:
    
    For synthetic experiments
    
    Images for Dictionaries and Mapping leraning
    
3) Install SPAMS from http://spams-devel.gforge.inria.fr/downloads.html
    we called "mexOMP" function from SPAMS toolbox in the "sparse_inp_momp.m"

    Note: it is also possible to use "omp" function which is in the
    "OMPBox v10" toolbox. however, it needs small modifications in our 
    "sparse_inp_momp.m". The "OMPBox v10" can be downloaded from:
    http://www.cs.technion.ac.il/~ronrubin/software.html
4) If you want to train a dictionary, you need to install "KSVDBox v13" 
    which can be downloaded from 
    http://www.cs.technion.ac.il/~ronrubin/software.html

**Important m files:**

demo_NWSR_1xInterp.m:
    Denoising experiment

demo_NWSR_2xInterp.m:
    Interpolation experiment



load_train_images.m:
    training High-SNR High-resolution (HH) images

noise_level_in_HH_training_images.m:
    estimate noise standard deviation in the training set 

demo_train_dictionary.m:
    learn a dictionary from training HH images
    or show the atoms of a saved dictionary.
    
Note: the file "dictionary_8x8_20it_rand_g165.mat" contains the
dictionary that we have trained with this function, as we explained in the paper.
