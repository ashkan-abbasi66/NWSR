% K=2;% number of clusters
% see main_train_D.m
function [D,Gamma]=train_dicts(X,Label,par_trn,K)
Nim=length(X);
D=cell(1,K);
Gamma=cell(1,K);
for k=1:K
    par_trn{k}.data=[];
    for i=1:Nim
        par_trn{k}.data=[par_trn{k}.data X{i}(:,Label{i}==k)];
    end
    par_trn{k}.data=double(par_trn{k}.data);
    [D{k},Gamma{k},err,gerr] = ksvd(par_trn{k},'exact','VERBOSE','i');
    fprintf('........................\n');
end