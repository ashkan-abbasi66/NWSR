% X: data (N by d)
% C: cluster centroids/ mean of the classes (1 by d)
% cls_idx: N by 1 vector
% Ashkan
function [cls_idx,euc_dist]=euclid_classifier(X,C,param)
% if ~exist('param','var')||~isfield(param,'sort')
%     param.sort=0;
% end
if nargin<3
    param.sort=0;
end
[K,d1]=size(C);% K: number of clusters,d: dimension of the data
[N,d2]=size(X);
if d1~=d2
    error('ERROR: dimension of data and the mean vector must be the same');
end
euc_dist=zeros(N,K);
% euclidean distance computation
for k=1:K
%     % ** first method   
%     diff_vec=X-repmat(C(k,:),size(X,1),1);
%     euc_dist(:,k)=sum(diff_vec.^2,2);% N x 1
    % ** second method - (faster one)
    euc_dist(:,k)=sum((X-repmat(C(k,:),size(X,1),1)).^2,2);% N x 1
    % ** third method
%     euc_dist(:,k)=sum(bsxfun(@minus,X,C(k,:)).^2,2);
end
%
if param.sort==0
%     [~,cls_idx]=min(euc_dist');% row vector 
    [~,cls_idx]=min(euc_dist,[],1);
else
%     [~,cls_idx]=sort(euc_dist','ascend');% row vector, 1 x N
    [~,cls_idx]=sort(euc_dist,1,'ascend');%column vector - ascend
end
% cls_idx=cls_idx';
%{
Euclidean distance classifier
Example: 
assume that the data are stemed from an unknown dist. with m(i) as mean of 
the ith class.
see 'bayes_classifier' for an example.
------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%   [z]=euclidean_classifier(m,X)
% Euclidean classifier for the case of c classes.
%
% INPUT ARGUMENTS:
%   m:  lxc matrix, whose i-th column corresponds to the mean of the i-th
%       class.
%   X:  lxN matrix whose columns are the data vectors to be classified.
%
% OUTPUT ARGUMENTS:
%   z:  N-dimensional vector whose i-th element contains the label
%       of the class where the i-th data vector has been assigned.
%
% (c) 2010 S. Theodoridis, A. Pikrakis, K. Koutroumbas, D. Cavouras
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[l,c]=size(m);
[l,N]=size(X);

for i=1:N
    for j=1:c
        de(j)=sqrt((X(:,i)-m(:,j))'*(X(:,i)-m(:,j)));
    end
    [num,z(i)]=min(de);
end
%}