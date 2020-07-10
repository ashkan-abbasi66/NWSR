% old name: dispImgs
% 
% "Each column is an Image. X=[im1;im2;...;imN]; X: D*N; imsize=[m,n]"
% 
% NOTE: Assumes that the patches gathered from the image is vectorized in a
% columnwise way.
% 
% Example:
%     show all the patches in 16 columns, with 1 gap between them
%     cols=16;gap=1;% gap between each image patches
%     imsize=[patch_size,patch_size];
%     disp_patches( U,cols, gap, imsize,'gray');
% Ashkan
% 
% This function is developed based on 'dispImgs' function of
% Courtesy A. Leonardis, D. Skocaj
% see http://vicos.fri.uni-lj.si/danijels/downloads
function all_images=disp_patches(X,cols,gap,ihw,map,mag)
%
% DISPIMGS  Display images arranged in a matrix-like form. 
% CMP Vision Algorithms cmpvia@cmp.felk.cvut.cz

% XX = dispImgs(X,cols,gap,ihw,fh
%
% Inputs:
% X  [M x N]  An input compound image. 
% 
% cols  (default N^1/2)  Number of columns of matrix. Elements are the images shown. 
% gaps  (default 0)  Size of white gaps between images.  
% ihw   (default [M^1/2, M^1/2])  Vector containing image dimensions.
%


[M,N]=size(X);
if nargin<2 || isempty(cols) cols=floor(sqrt(N)); end;
if nargin<3 || isempty(gap) gap=0; end;
if nargin<4 || isempty(ihw) ihw=[sqrt(M),sqrt(M)]; end;
if nargin<5 || isempty(map) map='gray'; end
if nargin<6 || isempty(mag) mag=1; end

ih=ihw(1);iw=ihw(2);
rows=floor(N/cols);
XX=min(X(:))*ones((rows*ih)+(rows-1)*gap,(cols*iw)+(cols-1)*gap);

for i=1:N
   a=(iw+gap)*mod(i-1,cols)+1;
   b=(iw+gap)*mod(i-1,cols)+iw;
   c=(ih+gap)*(floor((i-1)/cols))+1;
   d=(ih+gap)*(floor((i-1)/cols))+ih;
   XX(c:d,a:b)=reshape(X(:,i)',ih,iw);
end;

xxmax=max(XX(:));
xxmin=min(XX(:));

all_images=(XX-xxmin)/(xxmax-xxmin);
if nargout<1
%     figure
%     imagesc(all_images);
%     colormap(map);
%     axis image
%     axis off;
%     axis square;  
all_images=imresize(all_images,mag);
figure, imshow(all_images),colormap(map);
end

