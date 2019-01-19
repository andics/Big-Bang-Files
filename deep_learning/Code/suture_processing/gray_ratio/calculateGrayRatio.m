function [suture_pixels_num, edge_pixels_num] = calculateGrayRatio(input_image, clustered_pixels, show_text)
%Calculate the ratio of darker to lighter pixels in a suture region

cluster_index = unique(clustered_pixels);
clusters_mean_color = cell2mat(arrayfun(@(S) mean(input_image(clustered_pixels == S)), cluster_index, 'uni', false));
[~, clusters_mean_color_indices] = sort(clusters_mean_color, 'descend');

second_max_mean = clusters_mean_color_indices(2);
suture_cluster_index = cluster_index(second_max_mean);

first_max_mean = clusters_mean_color_indices(1);
edge_cluster_index = cluster_index(first_max_mean);

edge_pixels_num = numel(clustered_pixels(clustered_pixels == edge_cluster_index));

suture_pixels_num = numel(clustered_pixels(clustered_pixels == suture_cluster_index));

if numel(cluster_index) < 3
    %This means that there were no pixels classified as surrounding edge
    %pixels in the suture segmentation (clustering and thresholding)
    suture_pixels_num = edge_pixels_num;
    edge_pixels_num = 0;
end

if show_text
fprintf('Number of edge pixels: %f \n', edge_pixels_num);
fprintf('Number of gray (suture) pixels: %f \n', suture_pixels_num);
end

end

