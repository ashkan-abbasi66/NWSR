function  im  =  insert_patches_Get_patches_2_lex( Px,h,w,ps)
%
% Ashkan
im=zeros(h,w);

N         =  h-ps(1)+1;
M         =  w-ps(2)+1;
s         =  1;
r         =  1:s:N;
r         =  [r r(end)+1:N];
c         =  1:s:M;
c         =  [c c(end)+1:M];
% L         =  length(r)*length(c);

k    =  0;
for i  = 1:ps(1)
    for j  = 1:ps(2)
        k       =  k+1;
        
        blk=Px(k,:);
        im(r-1+i,c-1+j)=reshape(blk',length(c),length(r))';        
    end
end
