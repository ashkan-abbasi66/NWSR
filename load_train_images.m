% N: number of images to read
% pth: path of training images
function Images=load_train_images(pth,N)
fprintf('Load %d training images....\n',N);
Images = cell(1,N);
for i=1:N
    fname=fullfile(pth,sprintf('HH%d.tif',i));
    Images{i} = double(imread(fname));
end