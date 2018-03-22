% INPUTS:
% im: orginal image
% imf: reconstructed image
% imn: noisy image (OPTIONAL)
%
% Usage:
%   addpath('E:\THESIS\Implements\Pedagogical');
%   PSNR=comp_psnr(im,imf)
%   [PSNR,SSIM]=comp_psnr(im,imf)
%   [PSNR,SSIM,ISNR]=comp_psnr(im,imf,imn)
%
% Ashkan
function [PSNR,SSIM,ISNR]=comp_psnr(im,imf,imn)
MSE=mean(mean((im-imf).^2));
if max(im(:))<2
    MaxI=1;
else
    MaxI=255;
end
PSNR=10*log10((MaxI^2)/MSE);
%
if nargout>1
    SSIM=ssim_index(im,imf);
end
if nargout>2 && (exist('imn','var') || ~isempty(imn))
    ISNR=10*log10((mean(mean((im-imn).^2))/MSE));
end