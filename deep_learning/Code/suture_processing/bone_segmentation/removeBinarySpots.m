function [finalImage, angle_orientation] = removeBinarySpots(imageFile)
%Remove black spots on a white surrounding in a binary image

bordered_image = zeros(size(imageFile, 1) + 2, size(imageFile, 2) + 2);
bordered_image(2:end-1, 2:end-1) = imageFile;

[is_vertical, angle_orientation] = isVertical(imageFile);

if is_vertical
    bordered_image(1,:) = 1;
    bordered_image(end,:) = 1;
    
    bordered_image = imfill(bordered_image,'holes');

    finalImage = bordered_image(2:end-1, 2:end-1);
    
else
    bordered_image(:,1) = 1;
    bordered_image(:,end) = 1;

    bordered_image = imfill(bordered_image,'holes');

    finalImage = bordered_image(2:end-1, 2:end-1);
    
end


end

