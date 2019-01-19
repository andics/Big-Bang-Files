function [index] = deleteDirContent(path_str)
%Return numberical index of the provided label

path_str_org = path_str;
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isfolder(path_str)
  sprintf('The following folder does not exist:\n%s', path_str);
  return;
end

% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(path_str, '*'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
theFiles=theFiles(~ismember({theFiles.name},{'.','..'}));
for k = 1 : length(theFiles)
  baseFileName = theFiles(k).name;
  fullFileName = fullfile(path_str, baseFileName);
  fprintf(1, 'Now deleting %s\n', fullFileName);
  delete(fullFileName);
end

end

