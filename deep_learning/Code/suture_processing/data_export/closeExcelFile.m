function [] = closeExcelFile(excel_object)
%Delete and close an existing excel object

invoke(excel_object.ActiveWorkbook,'Save'); 
excel_object.Quit 
excel_object.delete 
clear excel_object

end

