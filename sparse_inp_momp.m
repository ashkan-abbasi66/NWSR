function codes=sparse_inp_momp(data,D,param)
codes=zeros(size(D,2),size(data,2));
dim=size(data,1);
param.numThreads=-1;
param.L=param.Tdata;
batch_size=param.num*3000;%3000
% ++++++++++++++ for denoising ++++++++++++++++++++++++
if sum(isnan(data(:,1)))==0
    for jj=1:size(data,2)/batch_size
        batch_ind=(1:batch_size)+batch_size*(jj-1);
        Xb=data(:,batch_ind);
        %**************** Sparse coding method *******************
        Gamma=mexOMP(double(Xb),D,param);
        %*******************************************
        codes(:,batch_ind)=Gamma;
    end
    return
end
% ++++++++++++++ for inpainting +++++++++++++++++++++++
p=param.nan_patterns;
Np=size(p,2);
for jj=1:size(data,2)/batch_size
    for ii=1:Np % for each pattern, find 'data' with similar pattern
        batch_ind=(1:batch_size)+batch_size*(jj-1);
        Xb=data(:,batch_ind);
        % find location of the data with pattern p(:,ii)
        loc=single(sum(isnan(Xb)==repmat(isnan(p(:,ii)),1,size(Xb,2))));
        ind=find(loc==dim);% logical indices of the 'data' with pattern p(:,ii)
%         clear loc;
        %---- preparing data for inpainting ----
        d=Xb(:,ind);% a portion of 'data'
        d=remove_nans(d);
        %---------------------------------------
        % Make new dictionary
        DD=D;
        DD(isnan(p(:,ii)),:)=[];
        DD = DD./repmat(sqrt(sum(DD.^2, 1)),size(DD,1), 1);% DD=normc(DD);% new dictionary
        %**************** Sparse coding method *******************
        Gamma=mexOMP(double(d),DD,param);% Julien Mairal, 2009.
%         Gamma= omp(DD,double(d),DD'*DD,param.L);% Ron Rubinstein, 2009. OMP(D,X,G,T)
        %*******************************************
        codes(:,batch_size*(jj-1)+ind)=Gamma;
    end
%     fprintf('.');
end
% fprintf('\n');