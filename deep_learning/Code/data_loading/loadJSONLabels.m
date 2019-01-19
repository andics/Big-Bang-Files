function [json_content] = downloadJSONLabels(data_folder, overwrite)
%Download and load labels from an online source defined by the JSON file

if nargin < 2
    
    %To overwrite existing image files or not
    %Overwrite by default
    overwrite = 1;
   
end

suture_categ_value = 1;
label_img_prefix = 'label_';
label_img_ext = '.png';

data_folder = fullfile(data_folder);

json_file = dir(fullfile(data_folder, '*.json'));

if isempty(json_file)
        fprintf('\n Please make sure that a single .json file is present in the provided folder! \n');
        abortJSON();
else 
        fprintf('\nJSON file found. Proceeding to image loading... \n');
end

json_path = fullfile(data_folder, json_file.name);

json_content = loadjson(json_path)';

%extract the unique names of the image folders
orgImageNames = cellfun(@(S) S.External_0x20_ID, json_content, 'uni', false);
orgImageNames = cellfun(@(S) getImgDirName(S), orgImageNames, 'uni', false);
folderNames = unique(orgImageNames);
%folderNames = vertcat(folderNames, {'crn_left'});

folderPaths = fullfile(data_folder, folderNames);

foldersExist = double(cell2mat(cellfun(@(S) isdir(S), folderPaths, 'uni', false)));

if ~isempty(find(foldersExist == 0))
    fprintf('The following required folders do not exist:');
    fprintf('%s \n', folderPaths{find(foldersExist == 0)});
    abortJSON();
    return;
end

    fprintf('Required image folders found! Proceeding to download dataset \n');
    
    downloadedLabels = 0;
    totalNumOfLabels = length(json_content);
    
    fprintf('A total of %d number of image labels found in json file \n', totalNumOfLabels);
    
    h = waitbar(0,'Downloading images...');

for i=1:length(folderPaths)
    
    labelSaveFolder = checkLabelDir(folderPaths{i}, overwrite);
    currentImgTag = folderNames{i};
    
    fprintf('Downloading images with tag: %s \n', currentImgTag);
    
    for j=1:totalNumOfLabels
    
    json_cell = json_content{j};
    imageDirName = getImgDirName(json_cell.External_0x20_ID);
    
    
        if strcmp(currentImgTag,imageDirName)
    %        fprintf('It is a match! \n');
            labelImgLink = json_cell.Label.segmentationMasksByName.Background; 
            
            labelImg = loadURLImage(labelImgLink);
            if isempty(labelImg)
                fprintf("Failed to download label image corresponding to %s", json_cell.External_0x20_ID);
                abortJSON();
            end
            labelImg = imbinarize(rgb2gray(labelImg));
            %Switch the white and the black color
            labelImg = uint8(~labelImg*suture_categ_value);
            
            %Extract id of current image
            %The label will contain this number to indicate the image it
            %belongs to
            labelNum = regexprep(json_cell.External_0x20_ID, '^(\D+)(\d+)(.*)', '$2');
            labelImgName = join([label_img_prefix, labelNum, label_img_ext]);
            labelImgPath = fullfile(labelSaveFolder, labelImgName);
            imwrite(labelImg, labelImgPath);
            fprintf('Image %s saved! \n', labelImgName);
            downloadedLabels = downloadedLabels + 1;
            
            waitbar(downloadedLabels/totalNumOfLabels,h)
             
        end
    end
end
close(h);
fprintf('Finished image downloading with %s ', num2str(downloadedLabels));
fprintf('out of %s images downloaded \n', num2str(totalNumOfLabels));

end

function [] = abortJSON()
        fprintf('\n');
        error('Aborting image loading!');
end

