function [thinned_bone_mask] = thinBoneSegment(smooth_bone_mask, show, show_text, method)
%Thin a bone segment without thining the bone ends
border_width = 15;

bone_ratio = numel(find(smooth_bone_mask(:) == 1))/(size(smooth_bone_mask, 1) * size(smooth_bone_mask, 2));

if bone_ratio >=0.21 
    thin_value = 6.0;
    if strcmp(method, 'contour')
    thin_value = 5.9;
    end
else
    thin_value = 3.0;
    if strcmp(method, 'contour')
    thin_value = 3.1;
    end
end

if show_text
fprintf('Bone to image pixels ratio is %f \n', bone_ratio);
end

thinned_bone_mask = padarray(smooth_bone_mask, [border_width, border_width], 1);

thinned_bone_mask = bwmorph(thinned_bone_mask, 'skel', thin_value);

thinned_bone_mask = thinned_bone_mask(border_width + 1 : end - border_width, border_width + 1:end - border_width);
%Ensure that if a edge gous otside the image, at least the top and bottom
%row of pixels will serve as a boundary
thinned_bone_mask(end,:) = 0;
thinned_bone_mask(1,:) = 0;

if show
figure;
imshow(thinned_bone_mask, []);
title('Smooth and thinned bone segment');
end

end

