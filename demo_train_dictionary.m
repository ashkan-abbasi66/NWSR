% Set "train_D" to 1 for learning or set it to 0 for displaying atoms of a
% saved dictionary

clear
clc
addpath('E:\mfiles_acode_thesis\005_ksvd\Kafieh_OCT_Denoising\ksvdbox13_OCT');
addpath('E:\mfiles_acode_thesis\005_ksvd\Kafieh_OCT_Denoising\ompbox10_OCT');
addpath('E:\THESIS\Implements\Pedagogical');

% Read training images
Nim=10;
train_pth='./datasets/Images for Dictionaries and Mapping leraning';
Images=load_train_images(train_pth,Nim);

% Parameters
train_D=0; % set 1: to train D (dictionary), set 0: to load D from a file
remove_mean=1;% 1, remove DC (mean of intensity) from training patches

ps=[8 8]; % patch size
KK=128; % number of atoms

% par_trn{i} is a structure to contain parameters for training the i-th
% dictionary. Note that here we just want to learn one dictionary (k=1).
% Thus, the code can be easily extended for learning multiple dictionaries
% provided that you add a clustering/segmentation step.
par_trn=cell(1,1);
k=1;
par_trn{k}.codemode='error';
par_trn{k}.Edata=sqrt(ps(1)*ps(2)) * 4.6*1.65;
% par_trn{k}.Tdata=3;
par_trn{k}.iternum=20;

% dlfile: the dictionary is saved here or load from here.
dlfile=sprintf('dictionary_%dx%d_20it_rand_g165.mat',ps(1),ps(2));
fprintf('dictionary file name: %s\n',dlfile); % for loading or saving

if train_D==1
    % train a dictionary for each cluster.

    % ** Initial Dictionary: CWT 
    % [Faf, Fsf] = FSfarras;
    % [af, sf] = dualfilt1;
    % par_trn{k}.initdict = real(WavMat2DCpxDual(Faf,af, ps(1)))';

    % ** Initial Dictionary: ODCT 
    % par_trn{k}.initdict=odctndict(ps(1)*ps(2),128,1);
    % par_trn{k}.dictsize = size(par_trn{k}.initdict,2);

    % ** Initial Diciontary: Random samples
    if isfield(par_trn{k},'initdict')
        par_trn{k} = rmfield(par_trn{k},'initdict');% causes initialization using random examples
    end
    par_trn{k}.dictsize =KK;

    % extract patches and convert them to vectors by lexicographic ordering.
    fprintf('extract patches ....\n')
    X=cell(1,Nim);
    for i=1:Nim
        X{i}=Get_patches_2_lex(Images{i},ps);
        if remove_mean==1
            m=mean(X{i});
            X{i}=X{i}-ones(ps(1)*ps(2),1)*m;
        end
    end

    % cluster patches. Here, we do not have any clustering/segmentation step.
    % Thus, the labels of all of the extracted patches are the same.
    Label=cell(1,Nim);
    for i=1:Nim
        Label{i}=ones(1,size(X{i},2));
    end
    
    fprintf('Train Dictionaries ...\n');
    [D,~]=train_dicts(X,Label,par_trn,k);
    save(dlfile,'D');
else
    fprintf('Load Dictionaries ...\n');
    load(dlfile);
end

% show learned dictionary
Dtmp=lex2col(D{k},ps);
[~,ind]=sort(var(Dtmp),'descend');
disp_patches( Dtmp(:,ind),16, 1, ps,'gray' );
% Note that here we used the function "disp_patches" to show the atoms of the
% dictionary. beceause this function works with patches that are converted
% to vector by stacking all the columns together, first we need to convert
% the patches from lexicographic ordering to column-wise ordering.