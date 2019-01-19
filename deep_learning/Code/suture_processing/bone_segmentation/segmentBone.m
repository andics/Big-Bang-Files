function [bw, bw_smooth, angle_orientation, method] = segmentBone(imageFile, show_text, method)
%FFunction for segmenting the bone from the background
if nargin < 3
   method = 'contour';
end

imageFile = imageFile(:,:,1);
mask_width = 1;
border_width = 2;
bone_threshold = 19;
bw = padarray(imageFile, [border_width, border_width], 0);
small_image_itter = 651;
large_image_itter = 1100;

if strcmp(method, 'threshold')
bone_threshold = bone_threshold / 255;
bw = imbinarize(bw, bone_threshold);
end

if strcmp(method, 'contour')
mask = zeros(size(bw));
mask(mask_width:end-mask_width,mask_width:end-mask_width) = 1;
if size(bw, 1) > 192
    bw = activecontour(bw, mask, large_image_itter, 'Chan-Vese', 'SmoothFactor', 0.05);
else
    bw = activecontour(bw, mask, small_image_itter, 'Chan-Vese', 'SmoothFactor', 0.05);
end
end
bw = bw(1 + border_width : end - border_width, 1 + border_width : end - border_width);

[bw, angle_orientation] = removeBinarySpots(bw);

bw = bwareafilt(logical(bw), 3);
bw_smooth = smoothEdge(bw);

if show_text
fprintf('Angle oritation of the bone is %f \n', angle_orientation);
end

end

