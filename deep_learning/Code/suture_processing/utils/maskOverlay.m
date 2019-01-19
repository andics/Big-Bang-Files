function [image] = maskOverlay(binary_mask, image, show)
%Overlay a binary mask on an image
image(binary_mask == 0) = 0;

if show
   hold on;
   imshow(image, []);
   hold off;
end
    
end

