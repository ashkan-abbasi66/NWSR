% select_dimension=1, remove NaNs that are stored in rows. 2, remove NaNs
% that are stored in columns of the matrix(Xn).
% 
function Xn2=remove_nans(Xn,select_dimension)
%#codegen
% if ~exist('select_dimension','var') || isempty(select_dimension)
%     select_dimension=1;
% end
if nargin<2 || isempty(select_dimension)
    select_dimension=1;
end
if select_dimension==1
    num_signals=size(Xn,2);
    dim=size(Xn,1);
    num_nans=sum(isnan(Xn(:,1)));
    num_valid=dim-num_nans;% number of valid elements
    if num_nans~=0
        Xn2=Xn;
        Xn2=reshape(Xn2(~isnan(Xn2)),num_valid,num_signals);
    else
        Xn2=Xn;
    end
else
    % signals are stored in rows of the matrix Xn
    num_signals=size(Xn,1);
    dim=size(Xn,2);
    num_nans=sum(isnan(Xn(1,:)));
    num_valid=dim-num_nans;% number of valid elements
    if num_nans~=0
        Xn2=Xn;
        Xn2=reshape(Xn2(~isnan(Xn2)),num_signals,num_valid);
    else
        Xn2=Xn;
    end
end