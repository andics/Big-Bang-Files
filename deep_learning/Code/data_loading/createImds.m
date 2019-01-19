function [imds] = createImds(imagesPath)
%Create an image datastore from inages provided in the specified path

imagesPath = fullfile(imagesPath);
imds = imageDatastore(imagesPath,'FileExtensions',{'.jpg','.png'}, 'IncludeSubfolders', 0);
fprintf('Image datastore loaded successfully! \n');

end

