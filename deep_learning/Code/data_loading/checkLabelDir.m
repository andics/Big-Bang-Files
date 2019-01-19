function [pixel_label_dir] = checkLabelDir(checkPath, overwrite)
%Check if 'labeled' folder exists in provided folder
%Create one if it doesn't

if nargin < 2
   overwrite = 0; 
end

%Accepted names for a labeled images folder
labelFolderNames = {'labeled'};


files = dir(checkPath);
subDirs = listSubDirs(checkPath);
subDirs = {subDirs.name};

if overwrite == 0
Match=cellfun(@(x) ismember(x, labelFolderNames), subDirs, 'UniformOutput', 0);
r=find(cell2mat(Match));

if ~isempty(r) && length(r) == 1
    fprintf('Found a labeled images folder! Proceeding to download images in the folder \n');
    label_dir = fullfile(checkPath, subDirs{r});
   
    pixel_label_dir = fullfile(label_dir, 'PixelLabelData');
    if ~isdir(pixel_label_dir)
    mkdir(pixel_label_dir);
    fprintf('Found a labeled images folder, however creating a PixelLabelData folder! \n');
    end
    return; 
    
elseif length(r) > 1
    fprintf('Please make sure there is a single label folder in the folder \n');
    fprintf('%s \n', checkPath);
    return;
    
elseif isempty(r)
    fprintf('No label image folder found! Creating one... \n');
    label_dir = fullfile(checkPath, labelFolderNames{1});
    mkdir(label_dir);
    
    pixel_label_dir = fullfile(label_dir, 'PixelLabelData');
    mkdir(pixel_label_dir);
    fprintf('Created required PixelLabelData folder \n');
    return;
    
end

else
    label_dir = fullfile(checkPath, labelFolderNames{1});
    fprintf('Overwriting existing label folder... \n');
    if isdir(label_dir)
    rmdir(label_dir,'s');
    end
    mkdir(label_dir);
    
    pixel_label_dir = fullfile(label_dir, 'PixelLabelData');
    mkdir(pixel_label_dir);
    fprintf('Created required PixelLabelData folder \n');
    return;
end



end

