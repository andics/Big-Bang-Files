function [combo_clustered_pixels] = comboClusterCMeans(input_image, suture_binary_mask, nColors, show)
%Combine cluster results from clusting a suture using a clustering
%algorithm which takes into account only color, and combine the result with
%a cluster which takes into accound color and pixel positions
%Output is a matrix consisting of assigned categories to each pixel (numerical)
combo_clustered_pixels = [];

feature_clustered_pixels = clusterFeaturesCMeans(input_image, suture_binary_mask, nColors, show);
if numel(unique(feature_clustered_pixels)) < 2
   return;
else
   feature_clustered_suture_index = getSutureClusterIndex(input_image, feature_clustered_pixels); 
end

color_clustered_pixels = clusterColorsCMeans(input_image, suture_binary_mask, nColors, show);
color_clustered_suture_index = getSutureClusterIndex(input_image, color_clustered_pixels);
combo_clustered_pixels = color_clustered_pixels;
combo_clustered_pixels(feature_clustered_pixels == feature_clustered_suture_index) = color_clustered_suture_index;

end

