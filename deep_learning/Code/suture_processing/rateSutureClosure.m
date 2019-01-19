function [cross_ratio, cluster_info_1, cluster_info_2] = rateSutureClosure(net, imds, index, show, show_text)
%Rate the degree of suture closure in an image
if nargin < 4 
   show = true; 
end

if nargin < 5
    show_text = true;
end 
cross_ratio = [];
cluster_info_1 = [];
cluster_info_2 = [];

[image, cat_mask, scores, allScores] = segmentNet(net, imds, index, show);
cat_mask = filterPrediction(cat_mask, allScores, show_text);
suture_binary_mask = catToBinary(cat_mask);

[bone_mask, bone_mask_smooth, angle_orientation, method] = segmentBone(image, show_text, 'contour');
suture_limit_mask = thinBoneSegment(bone_mask_smooth, show, show_text, method);
suture_binary_mask = suture_binary_mask.*suture_limit_mask;

if suture_binary_mask(:) == 0
    if show_text
   fprintf('No suture found! \n');
    end
   return;
end

if show
B = labeloverlay(image, suture_binary_mask, 'Colormap', 'gray', 'Transparency', 0.5);
figure;
subplot(1,2,2);
imshow(B, []);
title('Neural net detected region');
subplot(1,2,1);
imshow(image, []);
title('Original image');
end

suture_region = image.*uint8(suture_binary_mask);

ab = suture_region;

nColors = 2;


clustered_suture_pixels_1 = comboClusterCMeans(ab, suture_binary_mask, nColors, show);
if isempty(clustered_suture_pixels_1)
   if show_text
   fprintf('No suture found! \n');
   end
   return;
end
suture_detected_mask = extractClusteredSuture(ab, clustered_suture_pixels_1);

suture_detected_mask = threshholdFilter(ab, suture_binary_mask, suture_detected_mask, show_text);
suture_cluster_index = 1;

if show
image_suture_regions = zeros(size(ab));
image_suture_regions(suture_detected_mask == suture_cluster_index) = image(suture_detected_mask == suture_cluster_index);
figure;
subplot(1,2,2);
imshow(image_suture_regions,[]);
title('Segmented suture after color clustering and threshholding');
subplot(1,2,1);
imshow(image,[]);
title('Original Image');
end

%image_suture_regions_bin = seperateBlobs(image_suture_regions_bin);
no_blobs_mask = terminateCircleBlobs(suture_detected_mask, show);
no_blobs_mask = bwmorph(no_blobs_mask, 'skel', 0.5);

if show
figure;
imshow(no_blobs_mask);
title('Mask with no circular particles');
end

if no_blobs_mask(:) == 0
   if show_text
   fprintf('All particles filtered, so no sutures were found! \n');
   end
   return;
end

clustered_suture_pixels_1_no_blobs = combineClusterMatrixWBinary(ab, clustered_suture_pixels_1, no_blobs_mask);
clustered_suture_pixels_1_no_blobs_mask = extractClusteredSuture(ab, clustered_suture_pixels_1_no_blobs);

[num_suture_pixels_1, num_edge_pixels_1] = calculateGrayRatio(ab, clustered_suture_pixels_1_no_blobs, show_text);
mean_color_cluster_1 = mean(ab(no_blobs_mask == suture_cluster_index));
gray_ratio_1 = num_suture_pixels_1/(num_edge_pixels_1 + num_suture_pixels_1);
gray_white_ratio_1 = num_suture_pixels_1 / num_edge_pixels_1;
cluster_info_1 = [num_suture_pixels_1, num_edge_pixels_1, gray_ratio_1, gray_white_ratio_1, mean_color_cluster_1];

if show_text
fprintf('Suture closure ratio x / (x + y): %f \n', gray_ratio_1 );
fprintf('Suture pixels to edge pixels ratio x / y: %f \n', gray_white_ratio_1);
fprintf('Mean color of suture region after first clustering: %f \n \n', mean_color_cluster_1);
end

%{
clustered_no_blobs_img = labeloverlay(ab, clustered_suture_pixels_1_no_blobs_mask, 'Colormap', 'gray', 'Transparency', 0.5);
figure;
imshow(clustered_no_blobs_img, [])
title('Clustered image with no blobs');
%}
%[crossPts] = findCrossLine(suture_limit_mask, no_blobs_mask, show);
[crossPts] = findCrossLine_new(suture_limit_mask, no_blobs_mask, angle_orientation, show);
crossPt1 = crossPts(1,:);
crossPt2 = crossPts(2,:);

cross_ratio = calculateCrossRatio(crossPt1, crossPt2, no_blobs_mask, show, show_text);

if show
figure;
subplot(1, 2, 2);
final_suture_region = maskOverlay(no_blobs_mask, image, show);
title('Segmnted suture final');

subplot(1, 2, 1);
imshow(image, []);
title('Original Image');
else
final_suture_region = maskOverlay(no_blobs_mask, image, show);
end

%clustered_suture_pixels = clusterColorsKMeans(final_suture_region, no_blobs_mask, nColors, show);
%clustered_suture_pixels = clusterFeaturesCMeans(final_suture_region, no_blobs_mask, nColors, show);
clustered_suture_pixels_2 = comboClusterCMeans(final_suture_region, no_blobs_mask, nColors, show);
clustered_suture_pixels_2_index = getSutureClusterIndex(final_suture_region, clustered_suture_pixels_2);

mean_color_cluster_2 = mean(final_suture_region(clustered_suture_pixels_2 == clustered_suture_pixels_2_index));
[num_suture_pixels_2, num_edge_pixels_2] = calculateGrayRatio(final_suture_region, clustered_suture_pixels_2, show_text);
gray_ratio_2 = num_suture_pixels_2 / (num_edge_pixels_2 + num_suture_pixels_2);
gray_white_ratio_2 = num_suture_pixels_2 / num_edge_pixels_2;
cluster_info_2 = [num_suture_pixels_2, num_edge_pixels_2, gray_ratio_2, gray_white_ratio_2, mean_color_cluster_2];

if show_text
fprintf('Suture closure ratio x / (x + y): %f \n', gray_ratio_2 );
fprintf('Suture pixels to edge pixels ratio x / y: %f \n', gray_white_ratio_2);
fprintf('Mean color of suture region after second clustering: %f \n \n', mean_color_cluster_2);
end

if show
clustered_suture = labeloverlay(final_suture_region, clustered_suture_pixels_2, 'Colormap', 'gray', 'Transparency', 0.8);

figure;
imshow(clustered_suture, []);
title('Clustered suture pixels for closure ratio');
end

end

