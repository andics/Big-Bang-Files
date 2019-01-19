function [data_table] = identifyOutliers(data_table, column_names)
%Identify outliers in the speciffied column names

for i=1:numel(column_names)
   current_column_name = column_names{i};
   
   current_column_org = data_table{:, current_column_name};
   if ~isstring(current_column_org)
        current_column_org = string(num2str(current_column_org));
   end
   
   current_column = data_table{:, current_column_name};
   if isstring(current_column(:,1))
        current_column = str2double(current_column);
   end
   
   current_column_outliers = isoutlier(current_column, 'quartiles');
   current_column_org(current_column_outliers, 1) = "outlier";
   data_table.(current_column_name) = string(data_table.(current_column_name));
   data_table{:,current_column_name} = current_column_org;
end

end

