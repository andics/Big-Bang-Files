function [] = killExcel()
%Terminates any excel processes running

try
    system('taskkill /F /IM EXCEL.EXE');
catch
    fprintf('An error occured while trying to close excel \n');
end

end

