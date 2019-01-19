function [folderName] = getImgDirName(imageName)
%extract the name of the directory that the image name belongs to. It's
%assumed that the image name contains the directory name

folderName = strsplit(imageName, regexp(imageName, '\d+', 'match'));
folderName = folderName{1};

end

