function matches = matchDescriptors(...
    query_descriptors, database_descriptors, lambda)
% Returns a 1xQ matrix where the i-th coefficient is the index of the
% database descriptor which matches to the i-th query descriptor.
% The descriptor vectors are MxQ and MxD where M is the descriptor
% dimension and Q and D the amount of query and database descriptors
% respectively. matches(i) will be zero if there is no database descriptor
% with an SSD < lambda * min(SSD). No two non-zero elements of matches will
% be equal.

[dists,all_matches] = pdist2(double(database_descriptors)',double(query_descriptors)', 'euclidean', 'Smallest', 1);

list = dists(dists~=0);
d_min = min(list);

all_matches(dists >= lambda * d_min) = 0;

matches = zeros(size(all_matches));
[~,desc_index,~] = unique(all_matches, 'stable');
matches(desc_index) = all_matches(desc_index);
end 
