% estimate noise standard deviation in the training set
% HH: High-SNR High-resolution (HH) image

% Read training images
Nim=10;
train_pth='./datasets/Images for Dictionaries and Mapping leraning';
Images=load_train_images(train_pth,Nim);

% estimate standard deviation of each HH image.
s=0;
for i=1:Nim
    im=Images{i};
    sigma = function_stdEst(im);
    s=s+sigma;
end

str=sprintf('mean std. of noise in HH images:%.4g\n',s/Nim);
msgbox(str);
disp(str)