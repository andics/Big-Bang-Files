function [gTruth] = loadGroundTruth(filePath, gTruthName)
%Load ground truth object if it exists
%If it doesn't, create one from the provided labeled images
%A suture name folder expected for filePath

try
  gTruth = load(filePath); %Try to load a .mat file input
  gTruth = gTruth.('gTruth');
  fprintf('Loaded a gTruth .mat file directly from \n %s \n', filePath); 
  return;
catch
  fprintf('No .mat files specified in input. Loading automatically... \n'); 
end

labeledDataDirName = 'labeled';

%Check if a labeled folder exists
if ~isdir(fullfile(filePath, labeledDataDirName))
    fprintf(['A label folder not found in the path: %s \n', filePath]);
    gTruth = [];
    return;
end

filePathOrg = filePath;
filePath = fullfile(filePath, labeledDataDirName);

if filePath(end) == '/'
   filePath(end) = ''
end


if nargin<2
   gTruthName = 'gTruth.mat';
end

fileToLoad = fullfile(filePath, gTruthName);
matFileExists = 0;

if exist(fileToLoad)
warning(''); % Clear last warning message
gTruth = load(fileToLoad);
gTruth = gTruth.('gTruth');
[~, warnId] = lastwarn;
matFileExists = 1;
    if isempty(warnId)
        %The founded file gave no warnings!
        fprintf('Ground truth .mat file found and loaded with no issues! \n');
    return;
    end
end

createGroundTruth(filePath, gTruthName);
gTruth = loadGroundTruth(filePathOrg, gTruthName);
   
return;
   
   
   

labelDefinitions = gTruth.LabelDefinitions
dataFilePaths = gTruth.DataSource.Source
labelFilePaths = gTruth.LabelData.PixelLabelData

imgNum = 1;

imgOrg = imread(dataFilePaths{imgNum});
imgLabeled = imread(labelFilePaths{imgNum});



end

