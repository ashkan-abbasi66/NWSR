% Usage:
%     addpath('E:\THESIS\Implements\Pedagogical');% extract_patches_lex_col & lex2col
%     addpath('E:\THESIS\Implements\ksvdbox13');% showdict
%     im=imread('cameraman.tif');
%     ps=[40 35];
%     step=ps;
%     X=extract_patches_lex_col(im,ps,step);% extract 42 patches
%     out=lex2col(X,ps);
%     d_image=showdict(out,ps,6,7);% this function needs coloumn-wise patches.
%     figure,imshow(d_image)
% Inputs:
%     patches_lex: dxN matrix of N lexicographically vectorized patches
%     ps: patch size
% Outputs:
%     out: dxN matrix of N vectorized patches (coloumn-wise).
function out=lex2col(patches_lex,ps)
[d,N]=size(patches_lex);
out=zeros(d,N);
for i=1:N
    pr=reshape(patches_lex(:,i),ps(2),ps(1))';
    out(:,i)=pr(:);
end