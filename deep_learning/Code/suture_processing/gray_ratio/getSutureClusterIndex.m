function [suture_cluster_index] = getSutureClusterIndex(input_image, clustered_pixels)
%Extrac the index of the suture cluster

cluster_index = unique(clustered_pixels);
clusters_mean_color = cell2mat(arrayfun(@(S) mean(input_image(clustered_pixels == S)), cluster_index, 'uni', false));
[~, clusters_mean_color_indices] = sort(clusters_mean_color, 'descend');

second_max_mean = clusters_mean_color_indices(2);
suture_cluster_index = cluster_index(second_max_mean);

end

