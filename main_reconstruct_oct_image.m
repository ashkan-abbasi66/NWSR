%
% imn: input image
% scale_factor: downsampling factor
% ps: patch size
% psnlm: patch size used for non-local mean denoising method
% (patchfiltering function by [1])
% dlfile: dictionary file name or path
% NUM:
% NUM_neighbors:
% im: 
% down_sample: 
%
% NOTE: if 'im' is available, the algorithm does not use off-the-shelve 
% 
% ashkan
function [im_out,time_end]=main_reconstruct_oct_image(imn,...
    scale_factor,ps,psnlm,dlfile,NUM,NUM_neighbors,im,down_sample)
% num = 4 or 6
% num_neighbors=15
%% set parameters
fprintf('set parameters ....\n');
if ~exist('im','var')|| isempty(im)
    im=[];
end
if ~exist('NUM','var')|| isempty(NUM)
    NUM=6;
    NUM_neighbors=15;
end
if ~exist('down_sample','var')|| isempty(down_sample)
    down_sample=1;
end
% dlfile='dicts_comp_noDC_e9_it10_4x8_odct.mat';
load(dlfile);
% if you want a dictionary with fewer columns
% [U,S,V]=svd(D{1});
% D{1}=U(:,1:63);
%
fprintf('dictionary file name: %s\n',dlfile); % for loading or saving

% number of clusters. Note that we have only one cluster (k=1).
k=1;
% ps=[4 8];
step=1;
% ** sparse coding for inpainting
sparse_func=@sparse_inp_momp;% mexOMP (denoise and inpaint) - minibatch
par_test=cell(1,k);
par_test{k}.Tdata=2; % sparsity level for cluster k. 
%
[R,C]=size(imn);

% downsampling: when the data is missed, we insert not a number (NaN) sign.
if scale_factor>1 && down_sample==1
    % INPAINTING
    valid_cols=uint16(1:scale_factor:C);
    nan_cols=1:C;
    nan_cols(valid_cols)=[];
elseif scale_factor>1 && down_sample==0
    C=C*scale_factor;
    valid_cols=uint16(1:scale_factor:C);
    imn2=zeros(R,C);
    imn2(:,valid_cols)=imn;
    imn=imn2;% Now, size(imn)==size(imn2);
    clear imn2
    nan_cols=1:C;
    nan_cols(valid_cols)=[];
else
    % DENOISING
    nan_cols=[];
    valid_cols=uint16(1:C);
end
imn(:,nan_cols)=nan;

%% extract patches from noisy image(imn) & its reduced noise version (imf)
% Xn & Xf
fprintf('extract patches from imn & imf ....\n');
% Xn=extract_patches_lex(imn,ps,step);
Xn=Get_patches_2_lex(imn,ps);

Xn=single(Xn);
nlabel=ones(1,size(Xn,2));
if ~isempty(im)
    imf=nan(size(imn));
    imf(:,valid_cols)=im(:,valid_cols);
else
    % ** Plug a Denoising Algorithm Here *************************************
%     psnlm=ps;
    imf=nan(size(imn));%---------
    addpath('E:\mfiles_acode_thesis\SBSDI_2013_Fang_2');
    inp=imn(:,valid_cols);
%     Testp{1}=extract_patches_lex_col(inp,psnlm,step);
    Testp{1}=Get_patches_2_lex_col(inp,psnlm);
    [R2,C2]=size(inp);
    wei_arr=ones(1,size(Testp{1},2));
    Xf2= patchfiltering (Testp,wei_arr,psnlm(1), psnlm(2),...
        prod(psnlm),inp);
    imf(:,valid_cols)=insert_patches_Get_patches_2_lex_col(Xf2,R2,C2,psnlm);%-------
    clear Xf2 Testp inp wei_arr
    %~~~~~~~~~~~~~~~~~~
%     imf=nan(size(imn));
%     max_val=255;%max(max(imn(:,valid_cols)));
%     sigma=function_stdEst(im2uint8(imn(:,valid_cols)./max_val));
%     [NA, imf(:,valid_cols)] = BM3D(1, double(imn(:,valid_cols)/max_val), sigma);
%     imf(:,valid_cols)=imf(:,valid_cols)*max_val;
    %**********************************************************************
end
imf=single(imf);
% Xf=Get_patches_2_nofilter(imf,ps);
% Xf=extract_patches_lex(imf,ps,step);
Xf=Get_patches_2_lex(imf,ps);
Xf=single(Xf);
%% @@@@@ compute running time
time_start = cputime;
%%  remove mean of intensity 
% output: Xn
if NUM==1
    [Xn2,dc2]=remove_mean_inpainting(Xn);
    Xf2=remove_mean_inpainting(Xf);
else
    Xn2=remove_mean_inpainting(Xn);
    [Xf2,dc2]=remove_mean_inpainting(Xf);
end
%% find patterns of NaN
% Note that as we mentioned in the paper, we find similar patches for each
% patch that have similar pattern of missing values. In our experiments,
% this has better reconstruction quality.
if scale_factor>1
    Np=scale_factor;%number of patterns
    p=ones(size(Xn,1),Np);
    for ii=1:Np
        p(:,ii)=isnan(Xn(:,ii));
        p(p(:,ii)==1,ii)=nan;
    end
end
%% find similar patches for each patch
% find 'num' NL (nonlocal) patches for each patch & gather them into a big matrix (XX)
fprintf('find similar patches & put them into XX{k} ....\n');
[XX,wei]=find_nl_for_inpainting(Xn2,Xf2,nlabel,1,NUM,NUM_neighbors);
clear Xn2 Xf2
%% OMP for inpainting
% load(dlfile)
fprintf('OMP for inpainting ....\n');
alpha=cell(1,1);
par_test{k}.num=NUM;
if scale_factor>1
    par_test{k}.nan_patterns=p; 
end
% ** Sparse Coding method
alpha{k}=sparse_func(XX{k},D{k},par_test{k});
alpha{k}=sparse(alpha{k});

%% reconstruct patches in each cluster
fprintf('reconstruction ...\n');
Xnhat=zeros(size(Xn));
prob_out=single(zeros(2,size(Xn,2)));
%
id=nlabel==k;
N=sum(id);
% d=size(alpha{k},1);
h=80;
% Compute nonlocal weighted sparse representation (NWSR)
[Xnhat(:,id),prob_out(:,id)]=omp_mean_patches_wei_noDC(D{k},alpha{k},NUM,N,h,wei{k});
%% Add the removed mean of intensity to the patches.
% reconstructed patches are gathered into Xnhat. Thus we need to add mean
% of intensity (DC component) to these patches.
dc1=dc2.*prob_out(1,:)+dc2.*prob_out(2,:);
clear dc2;
Xnhat_dc=Xnhat+repmat(dc1,size(Xnhat,1),1);
%% @@@@@
time_end = round(cputime-time_start);
%% Reconstruction of the whole image from the patches.
im_out=insert_patches_lex(Xnhat_dc,R,C,ps,step);
% toc
% clear Xn id
im_out=double(im_out);