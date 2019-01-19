function [orgImgPaths, labeledImgPaths] = gatherPaths(filePath)
%Load ground truth object if it exists
%If it doesn't, create one from the provided labeled images

   %Accepted labeled image folder names
   labelDirNames = {'PixelLabelData', 'Labeled_Images'};

   %Get the paths of all images in the Labeled_images folder
   files = dir(filePath);
   subDirs = [files.isdir];
   subDirs = files(subDirs);
   index = contains({subDirs.name}, labelDirNames);
   if ~isempty(subDirs(index)) && length(subDirs(index)) == 1
      labelFilesFolder = fullfile(filePath, subDirs(index).name);
   else
       fprintf('Please make sure that a single folder with labeled images exists in the label directory! \n');
       return;
   end
   
   labeledImgNames  = vertcat(dir(fullfile(labelFilesFolder, '*.png')), dir(fullfile(labelFilesFolder, '*.jpg')));
   labeledImgNames = natsort({labeledImgNames.name})';
   labeledImgPaths = fullfile(labelFilesFolder, labeledImgNames);
   
   
   %Get paths of original images
   
   DinPath = strfind(filePath, '\');
   %Return to previous folder
   orgImgPaths = filePath(1:DinPath(end) - 1);
   
   orgImgNames = vertcat(dir(fullfile(orgImgPaths, '*.png')), dir(fullfile(orgImgPaths, '*.jpg')));
   orgImgNames = natsort({orgImgNames.name})';
   
   orgImgIndices = [path2index(labeledImgNames)];
   orgImgNames = orgImgNames(orgImgIndices);
   orgImgPaths = fullfile(orgImgPaths, orgImgNames);
   
end

