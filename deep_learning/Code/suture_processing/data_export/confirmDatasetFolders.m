function [sub_dirs] = confirmDatasetFolders(sub_dirs)
%sub_dirs - a structure array containing directory elements
%
%Confirms that all of the folders belong to a dataset

confirmed_names_logical = arrayfun(@(current_folder) isADatasetFolder(current_folder),...
    sub_dirs, 'UniformOutput', true);
sub_dirs = sub_dirs(confirmed_names_logical);

end

