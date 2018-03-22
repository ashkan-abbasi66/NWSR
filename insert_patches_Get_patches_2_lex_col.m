% Function Equivalence:
% insert_patches_Get_patches_2_lex_col <=> insert_patches_lex_col
% Example:
%     im=im2double(imread('cameraman.tif'));
%     [R,C]=size(im);
%     ps=[8 8];
%     step=[1 1];
%     tic
%     X=Get_patches_2_lex_col(im,ps);
%     % im2=insert_patches_lex_col(X,R,C,ps,step);
%     im2=insert_patches_Get_patches_2_lex_col(X,R,C,ps);
%     time_get_insert=toc
%     figure,imshow(im2)
%
% Compare with extract_patches_lex_col.m & insert_patches_lex_col
% this function works better than **_lex_col.m for small patch size.
%
function  im  =  insert_patches_Get_patches_2_lex_col( Px,h,w,ps)
% this function is written to work with Get_patches_2_nofilter
%
% Ashkan
im=zeros(h,w);
counter=zeros(h,w);
if numel(ps)>1 
    ps1=ps(1);
    ps2=ps(2);
else
    ps1=ps;
    ps2=ps;
end
N         =  h-ps(1)+1;
M         =  w-ps(2)+1;
s         =  1;
r         =  1:s:N;
r         =  [r r(end)+1:N];
c         =  1:s:M;
c         =  [c c(end)+1:M];
% L         =  length(r)*length(c);

k    =  0;
for i  = 1:ps(1)
    for j  = 1:ps(2)
        k       =  k+1;
        
        blk=Px(k,:);
        im(r-1+i,c-1+j)=reshape(blk,length(r),length(c));
                
    end
end
