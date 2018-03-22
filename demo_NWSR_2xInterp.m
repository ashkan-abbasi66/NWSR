clear
clc
testImg_indices=1:18;
scale_factor=2;
experiment_name='NWSR_2xInterp_ps8x8_psnlm6x6'
%
NN=length(testImg_indices);% number of test images
%
% pre-allocating memory for creating a table of measures.
qm_data=zeros(NN,2);% #images by #quality measures & time
row_name=cell(NN,1);
%
for i=1:NN
    strnumber=num2str(testImg_indices(i));
    fprintf('image #%s\n',strnumber)
    pth=['./datasets/For synthetic experiments/',strnumber];
    % ** Load a test and its HH image
    testfile='test.tif';
    cleanfile='average.tif'; 
    imn = single(imread(fullfile(pth,testfile)));
    im= single(imread(fullfile(pth,cleanfile)));
    % the outputs are saved as images in the following folder
    outfolder=['outs/' experiment_name];
    if ~exist(outfolder,'dir')
        mkdir(outfolder);
    end
    outfname=[outfolder '/' strnumber];% output file name
    % 
    ps=[8 8]; % patch size for sparse representation
    psnlm=[6 6];% patch size for NLM filtering
    dlfile='dictionary_8x8_20it_rand_g165'; % dictionary file name
    NUM=6;
    NUM_neighbors=15;
    % run the algorithm
    [im_out,time_end]=main_reconstruct_oct_image(imn,...
        scale_factor,ps,psnlm,dlfile,NUM,NUM_neighbors);
    %
    PSNR=comp_psnr(im,im_out);
    %
    qm_data(i,:)=[PSNR,time_end];
    row_name{i}=strnumber;
    %
    imwrite(im2uint8(im_out/255),[outfname '.tif'],'tif');
end
% Draw a table
f=figure;
colname={'PSNR','TIME'};
colformat=repmat({'short g'},1,numel(colname));
t = uitable('Parent', f,'Data', qm_data,'RowName',row_name,...
    'ColumnName', colname,'ColumnFormat', colformat,...
    'Units','normalized','Position',[0 0 1 1]);
t.FontSize=12;
f.Name=[ experiment_name ' - 18 foveal images'];
