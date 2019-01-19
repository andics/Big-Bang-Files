function [clustered_pixels] = clusterColorsKMeans(input_image, suture_mask, nColors)
%cluster image regions and segment the suture

nrows = size(input_image,1);
ncols = size(input_image,2);
input_image = reshape(input_image,nrows*ncols,1);

input_data = input_image(suture_mask == 1);

% repeat the clustering 3 times to avoid local minima
opts = statset('Display','final');
[idx,C] = kmeans(input_data,nColors,'Distance','sqEuclidean',...
    'Replicates',10,'MaxIter',10000000000,'Options',opts);

clustered_pixels = input_image;
clustered_pixels(suture_mask == 1) = idx(:);
clustered_pixels = reshape(clustered_pixels,nrows,ncols);

end

