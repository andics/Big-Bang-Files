function [all_assess_folders] = analizeAllDatasets(net, datasets_folder, excel_file_path, sutures_names, num_of_desired_pics)
%datasets_folder - a folder full of dataset folders
%excel_file_path - specifies the exact path of the group_sagittal file
%sutures_names - the names of the sutures which will be analized
%WARNING: CLOSES ALL EXCEL FILES
killExcel();
if nargin < 5
num_of_desired_pics = 'all';
end

default_write_range = 'A17';
[group_excel_file] = verifyExcelFile(excel_file_path);

dataset_folders = listSubDirs(datasets_folder);
dataset_folders = confirmDatasetFolders(dataset_folders);
dataset_folders_names = arrayfun(@(current_folder) current_folder.name,...
    dataset_folders, 'UniformOutput', false);
dataset_folders_paths = fullfile(datasets_folder, dataset_folders_names)
all_assess_folders = [];

for i=1:numel(dataset_folders_paths)
   current_dataset_sub_dirs = listSubDirs(dataset_folders_paths{i});
   current_dataset_sub_dirs_names = arrayfun(@(current_folder) current_folder.name,...
   current_dataset_sub_dirs, 'UniformOutput', false);

   desired_suture_names_logical = arrayfun(@(current_folder_name) strcmp(sutures_names, current_folder_name),...
   current_dataset_sub_dirs_names, 'UniformOutput', false);
   desired_suture_names_logical = arrayfun(@(logical_array) any(logical_array{:}),...
   desired_suture_names_logical, 'UniformOutput', true);

   current_dataset_sub_dirs_names = current_dataset_sub_dirs_names(desired_suture_names_logical);
   if isempty(current_dataset_sub_dirs_names)
       %dataset_folders_names(i) = [];
       continue;
   end
   
   sub_dirs_paths = fullfile(dataset_folders_paths{i}, current_dataset_sub_dirs_names);
   sheet_name = arrayfun(@(folder_name) strcat(dataset_folders_names{i}, '_', folder_name),...
   current_dataset_sub_dirs_names, 'UniformOutput', true);
   current_dataset_sub_dirs_details = [sub_dirs_paths, sheet_name];
   all_assess_folders = vertcat(all_assess_folders, current_dataset_sub_dirs_details);
   
end

all_assess_folders

for i=1:size(all_assess_folders, 1)

fprintf('Assessing dataset: %s \n', all_assess_folders{i, 2});
no_outliers_table = assessGroupDataset(net, all_assess_folders{i, 1}, num_of_desired_pics, default_write_range);
killExcel();
writetable(no_outliers_table, group_excel_file, 'WriteVariableNames', true, 'Sheet', all_assess_folders{i, 2}, 'Range', default_write_range);
killExcel();
end

fprintf('Finished group data assessment! \n')

end

