function [isADatasetFolder] = isADatasetFolder(dir_object)
%dir_object - a structure responding to a folder
%The requirement for a folder to be counted as a dataset folder is for it's
%name to consists of integers only

dir_name = dir_object.name;
string_contains_numeric = @(S) ~isnan(str2double(S));
isADatasetFolder = string_contains_numeric(dir_name);

end

