% see 'find_non_local_patches_fast', 'find_non_local_patches_fast_clustering'
%   'find_non_local_patches_euclid', 'find_nl_for_inpainting'
% ashkan
function nlidx3=find_non_local_patches_fast(idx,label,L)
first_idx=idx-L;
last_idx=idx+L;
if first_idx<1,first_idx=1;end
if last_idx>numel(label),last_idx=numel(label);end
nlidx3=first_idx:last_idx;
