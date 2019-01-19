function [] = createGroundTruth(filePath, gTruthName)
%Create a groundTruth object and save it as a .mat file
%Expected to pass a label folder as path

   fprintf('Creating a groundTruth file for the provided images! \n');

   [orgImgPaths, labeledImgPaths] = gatherPaths(filePath);
   
   if isempty(orgImgPaths)
      return; 
   end

   sourceData = groundTruthDataSource(orgImgPaths);
   
   labelsDef = table({'suture', 'background'}', ...
	[labelType.PixelLabel, labelType.PixelLabel]', ...
    {1, 0}', ...
    {'Suture region', 'Background'}', ...
	'VariableNames',{'Name','Type', 'PixelLabelID', 'Description'});
    
    labelData = table(labeledImgPaths, ...
	'VariableNames',{'PixelLabelData'});

    gTruth = groundTruth(sourceData, labelsDef, labelData);
    
    matFileName = fullfile(filePath, gTruthName);
    
    save(matFileName, 'gTruth');
    
    fprintf('groundTruth file created and saved in: \n');
    disp(matFileName);

end

