function [suture_binary_mask] = extractClusteredSuture(input_image, clustered_pixels)
%Extract a binary mask of the suture from clustered input image
%Use the fact that the mean color of suture pixels will be smaller than
%that of surrounding bone area

suture_cluster_index = getSutureClusterIndex(input_image, clustered_pixels);

clustered_pixels(clustered_pixels ~= suture_cluster_index) = 0;
clustered_pixels(clustered_pixels == suture_cluster_index) = 1;
suture_binary_mask = clustered_pixels;

end

