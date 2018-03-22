function [Xhat,prob_out]=omp_mean_patches_wei_noDC(D,alpha,num,N,h,wei)
Xhat=zeros(size(D,1),N);%restored patches
prob_out=zeros(2,N);
wei=double(wei);% When A is single & B:sparse, then A*B is not supported.
t=1;
for i=1:num:size(alpha,2)
    % similarity measure
    d=exp(-(wei((t-1)*num+1:(t-1)*num+num))./(2*h^2));
    s=sum(d);
    prob=d./s;
    % weighted sparse codes
    weighted_alpha=alpha(:,i:i+num-1)*prob';
    Xhat(:,t)=D*weighted_alpha;
    prob_out(:,t)=[prob(1);sum(prob(2:end))];
    t=t+1;
end
