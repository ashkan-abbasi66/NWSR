% num=5;%5
% num_neighbors=15;%20
%  XX=find_nl_for_inpainting(Xn,Xf,nlabel,K,num,num_neighbors);
function [XX,wei]=find_nl_for_inpainting(Xn,Xf,nlabel,K,num,num_neighbors)
% K=2;
XX=cell(1,K);
% coder.varsize('XX');
if nargout>1
    wei=cell(1,K);
end
% num=5;%5
% num_neighbors=15;%20
k=1;

id=nlabel==k;
nlabelk=nlabel(id);
Xnk=Xn(:,id);
Xfk=Xf(:,id);
%     Xfkd=Xfk(:,1:3:end);
N=size(Xnk,2);
XX{k}=single(zeros(size(Xnk,1),num*N));
if nargout>1
    wei{k}=single(zeros(1,num*N));
end
for idx=1:N
    [nlidx,euc]=find_non_local_patches_euclid(Xfk,idx,nlabelk,num_neighbors,num);% ORIGINAL: (Xfk,idx,nlabelk,num_neighbors,num)
%     [nlidx,euc]=find_non_local_patches_euclid_2(Xnk(:,idx),Xfk,idx,nlabelk,num_neighbors,num);
%         XX{k}(:,(idx-1)*num+1:(idx-1)*num+num)=[Xfk(:,nlidx(1)),Xnk(:,nlidx(2:end))];%
    XX{k}(:,(idx-1)*num+1:(idx-1)*num+num)=[Xnk(:,nlidx(1)),Xfk(:,nlidx(2:end))];% ORIGINAL: [Xnk(:,nlidx(1)),Xfk(:,nlidx(2:end))]
    if nargout>1
        wei{k}(1,(idx-1)*num+1:(idx-1)*num+num)=euc';
    end
end
%     ind_groups{k}=int32(0:num:num*N-1); % size(XX{k},2)-1

