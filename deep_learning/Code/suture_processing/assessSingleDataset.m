function [] = assessSingleDataset(net, datasetFolder)
%Measure multiple features of each image from a suture dataset
%Record values for each image in an excel file
image_file_extensions = {'.jpg','.png'};
excel_file = verifyExcelFile(datasetFolder);
sheet_filtered = 'No_outliers';
sheet_raw = 'Unfiltered_data';
xlRange = 'A17';

white_stuture_color = 231;

variable_names = {'Image_index', 'Cross_ratio', 'Cluster_1_Number_of_gray_pixels',...
    'Cluster_1_Number_of_white_pixels', 'gray_over_total_cluster1', 'Cluster_1_Mean_Color',...
    'Cluster_2_Number_of_gray_pixels', 'Cluster_2_Number_of_white_pixels',...
    'gray_over_total_cluster2', 'Cluster_2_Mean_Color', 'gray_over_white_cluster1', 'gray_over_white_cluster2'};

data_table = cell2table(cell(0,numel(variable_names)), 'VariableNames', variable_names)

imds = imageDatastore(datasetFolder, 'FileExtensions', image_file_extensions);
imds_num_elements = numel(imds.Files);

for i=1:imds_num_elements
    fprintf('Assessing image with index %f \n \n', i);
    
   try
     [cross_ratio, cluster_info_1, cluster_info_2] = rateSutureClosure(net, imds, i, false);
     
       if isempty([cross_ratio, cluster_info_1, cluster_info_2])
        cross_ratio = "-";
        cluster_info_1 = ["-", "-", "-", "-"];
        cluster_info_2 = ["-", "-", "-", "-"];
        cross_ratio = 0;
        cluster_info_1 = [0, 0, 0, white_stuture_color, 0];
        cluster_info_2 = [0, 0, 0, white_stuture_color, 0];
       end
       
   catch
        fprintf('An error occured! Moving to next image... \n');
        cross_ratio = "-";
        cluster_info_1 = ["-", "-", "-", "-", "-"];
        cluster_info_2 = ["-", "-", "-", "-", "-"];
   end
   cross_ratio = string(cross_ratio);
   cluster_info_1 = string(cluster_info_1);
   cluster_info_2 = string(cluster_info_2);
   
   image_variables = {i, cross_ratio, cluster_info_1(1), cluster_info_1(2), cluster_info_1(3), cluster_info_1(5),...
       cluster_info_2(1), cluster_info_2(2), cluster_info_2(3), cluster_info_2(5),...
       cluster_info_1(4), cluster_info_2(4)};
   
   data_table = [data_table;image_variables];
end
outliers_column_names = {'Cross_ratio', 'gray_over_total_cluster1',...
    'gray_over_total_cluster2', 'gray_over_white_cluster1', 'gray_over_white_cluster2'};

fprintf('Identifying outliers for the generated values... \n');
data_table_filtered = identifyOutliers(data_table, outliers_column_names)
writetable(data_table_filtered, excel_file, 'WriteVariableNames', true, 'Sheet', sheet_filtered, 'Range', xlRange);
writetable(data_table, excel_file, 'WriteVariableNames', true, 'Sheet', sheet_raw, 'Range', xlRange);

fprintf('Finished dataset assessment! \n');
end

