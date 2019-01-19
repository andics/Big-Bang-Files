function [] = resizeImages(gTruth, outputSize)
%Uniformly crop images to desired dimensions

[imds,pxds] = pixelLabelTrainingData(gTruth);
imdsPath = [imds.Files];
pxdsPath = [pxds.Files];

imageSize = readimage(imds, 1);
[rows, cols, ~] = size(imageSize);

space_left_horizontal = round((cols - outputSize(2))/2)
space_right_horizontal = cols - outputSize(2) - space_left_horizontal

space_up_vertical = round((rows - outputSize(1))/2)
space_down_vertical = rows - outputSize(1) - space_up_vertical


for i=1:numel(imdsPath)
   currentImds = imread(imdsPath{i});
   currentPxds = uint8(imread(pxdsPath{i}));
   
   currentImds_cropped = currentImds(1 + space_down_vertical:end - space_up_vertical, 1 + space_left_horizontal:end - space_right_horizontal, :);
   currentPxds_cropped = currentPxds(1 + space_down_vertical:end - space_up_vertical, 1 + space_left_horizontal:end - space_right_horizontal, :);
   
   size(currentImds_cropped);
   size(currentPxds_cropped);
   
   imwrite(currentImds_cropped, imdsPath{i});
   imwrite(currentPxds_cropped, pxdsPath{i});
  
   fprintf("Found and cropped image in path %s \n", imdsPath{i});
   fprintf("Found and cropped labeled image in path %s \n", pxdsPath{i});
end

end

