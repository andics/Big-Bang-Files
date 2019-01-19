function [clustered_pixels] = combineClusterMatrixWBinary(input_image, clustered_pixels, binary_combine_mask)
%Combine a binary mask in which only the suture is with a cluster category
%matrix. This is used to apply circle particle termination before
%calculating the gray ratio
%After circle blob termination is applied some of the previously classified
%as suture particles might get removed. To accound for this when
%calculating the gray ratio, those removed pixels should be classified
%neither as suture pixels not as suture surrounding pixels, but as
%background (because they are most likely black diploe)
%Returns a cluster matrix with the binary mask as a suture, where
%everything that originally was a suture in clustered_pixels and was not in
%the binary mask, classified as background (not edge pixels)

cluster_index = unique(clustered_pixels);
clusters_mean_color = cell2mat(arrayfun(@(S) mean(input_image(clustered_pixels == S)), cluster_index, 'uni', false));
[~, clusters_mean_color_indices] = sort(clusters_mean_color, 'descend');

%background
third_max_mean = clusters_mean_color_indices(3);
background_cluster_index = cluster_index(third_max_mean);

%suture
second_max_mean = clusters_mean_color_indices(2);
suture_cluster_index = cluster_index(second_max_mean);

%edge pixels
first_max_mean = clusters_mean_color_indices(1);
edge_cluster_index = cluster_index(first_max_mean);

for i=1:size(clustered_pixels, 1)
    for j=1:size(clustered_pixels, 2)
        if clustered_pixels(i, j) == suture_cluster_index && binary_combine_mask(i, j) == 0
            clustered_pixels(i, j) = background_cluster_index;
        end
    end
end

clustered_pixels(clustered_pixels == suture_cluster_index) = edge_cluster_index;
clustered_pixels(binary_combine_mask == 1) = suture_cluster_index;

end

