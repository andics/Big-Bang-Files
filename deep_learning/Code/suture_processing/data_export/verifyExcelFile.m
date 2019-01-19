function [excel_file_path] = verifyExcelFile(data_folder)
%Verift that an excel file exists in the pointed folder, and if it doesn't
%create one
if ~isfolder(data_folder)
    excel_file_path = data_folder;
    fprintf('Excel file verified! Proceeding to group assessment \n')
    return;
end

data_folder = data_folder

default_excel_file_name = 'data_analysis.xlsx';

excel_file = dir(fullfile(data_folder, '*.xlsx'));

if isempty(excel_file)
        fprintf('\n No excel file found folder, proceeding to create one! \n');
        excel_file_path = fullfile(data_folder, default_excel_file_name);
        xlswrite(excel_file_path, [' ']);
        try
            system('taskkill /F /IM EXCEL.EXE');
        catch
            fprintf('An error occured while trying to close excel \n');
        end
else 
        fprintf('\nExcel file found! Proceeding to image analysis... \n');
        excel_file_path = fullfile(data_folder, excel_file.name);
end

%{
excel_object = actxserver ('Excel.Application'); 
invoke(excel_object.Workbooks,'Open',excel_file_path);
%}

fprintf('Excel file path: \n %s \n', excel_file_path);

end

