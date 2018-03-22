%--------------------------------------------
% USAGE:
% % % This example shows the following functions are equivalent:
% % % extract_patches_lex_col <=> Get_patches_2_lex_col
% % % insert_patches_lex_col <=> insert_patches_Get_patches_2_lex_col
% % %
% % im=im2double(imread('cameraman.tif'));
% % [R,C]=size(im);
% % ps=[8 8];
% % step=[1 1];
% % tic
% % %
% % % X=extract_patches_lex_col(im,ps,step);
% % X=Get_patches_2_lex_col(im,ps);
% % %
% % % im2=insert_patches_lex_col(X,R,C,ps,step);
% % im2=insert_patches_Get_patches_2_lex_col(X,R,C,ps);
% % %
% % time_extraction_insertion=toc
% % figure,imshow(im2)
%--------------------------------------------
% Ashkan
function  [Px]  =  Get_patches_2_lex_col( im, ps )
% this function belongs to the ASDS package. The algorithm that was
% presented by Weishong Dong, 2011.
%     "Image Deblurring and Super-resolution by Adaptive Sparse Domain
%     Selection and Adaptive Regularization", TIP 2011
% Also, An slightly modified version of it is used by the SBSDI algorithm
% of Fang et al. 2013.
%
% I modified it to work similar to the Dr. Fang's implementation.
% Ashkan

% Px:blocks that are extracted from the original image
% im: a grayscale image
% ps: patch size (e.g. ps=[4,4])

[h,w]  =  size(im);

N         =  h-ps(1)+1;
M         =  w-ps(2)+1;
s         =  1;
r         =  1:s:N;
r         =  [r r(end)+1:N];
c         =  1:s:M;
c         =  [c c(end)+1:M];
L         =  length(r)*length(c);
Px        =  zeros(ps(1)*ps(2), L, 'single');

k    =  0;
for i  = 1:ps(1)
    for j  = 1:ps(2)
        k       =  k+1;
        
        % the (i,j)th-pixel of all the patches are extracted
        blk     =  im(r-1+i,c-1+j); 
        Px(k,:) =  blk(:)';        
    end
end
