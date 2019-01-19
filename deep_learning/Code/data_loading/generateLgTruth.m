function [] = generateLgTruth(filePath)
%Check for gTruth files in the sub directories of the specified directory
%Combine gTruth files into one LgTruth file and save it in the flePath
%folder

%filePath - Expected to pass a folder only full of labeled dataset folders

    gTruthName = {'gTruth.mat'}

    subDirs = listSubDirs(filePath)
    subDirs = {subDirs.name}
    subDirs = cellfun(@(S) fullfile(filePath, S), subDirs, 'uni', false)'
    
    if isempty(subDirs)
        fprintf('No files found in the specified folder. Aborting gTruth loading...')
        return;
    end
    
    subSubDirs = [];
    
    for i=1:length(subDirs)
        toAdd = listSubDirs(subDirs{i});
        toAdd = {toAdd.name};
        toAdd = cellfun(@(S) fullfile(subDirs{i}, S), toAdd, 'uni', false);
       subSubDirs =  [subSubDirs, toAdd];
    end
    subSubDirs = subSubDirs';
    
    allgTruths = cellfun(@(S) loadGroundTruth(S), subSubDirs, 'uni', false);
    
    dataFilePaths = cellfun(@(S) S.DataSource.Source, allgTruths, 'uni', false);
    dataFilePaths = vertcat(dataFilePaths{:});
    labelFilePaths = cellfun(@(S) S.LabelData.PixelLabelData, allgTruths, 'uni', false);
    labelFilePaths = vertcat(labelFilePaths{:});
    
    if size(labelFilePaths) == size(dataFilePaths)
       fprintf('Data source and label images size matches! \n');
    else
        fprintf('Data source and label images size do not match! Aborting... \n');
        return;
    end
    
    sourceData = groundTruthDataSource(dataFilePaths);
    labelsDef = allgTruths{1}.LabelDefinitions;
    labelData = table(labelFilePaths, ...
	'VariableNames',{'PixelLabelData'});
    
    gTruth = groundTruth(sourceData, labelsDef, labelData);
    
    matFileName = fullfile(filePath, gTruthName{1});
    
    save(matFileName, 'gTruth');
    
    fprintf('LgTruthFile generated and exported in specified path! \n');
   
end

