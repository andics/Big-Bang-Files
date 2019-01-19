function [] = showImage(inputImage, title)
%Show an image in a new Figure

if nargin<2 
    title = 'Image';
end
numOfImages = numel(inputImage);
createFigure(title, 0);

for i=1:numOfImages
    try
    currentImage = inputImage{i};
    catch
    %A single image provided so input image is not a cell
    currentImage = inputImage;
    end
subplot(1, numOfImages, i);
imshow(currentImage, []);
end

end

