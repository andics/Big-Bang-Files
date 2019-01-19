function [] = imds_to_img(imds, pxds, exportFolder)
%Export images and labels from a ground truth to a specific folder

imds_files = [imds.Files];
pxds_files = [pxds.Files];

export_format = '.png';
imds_save_folder = fullfile(exportFolder, 'image');
pxds_save_folder = fullfile(exportFolder, 'label');

verifyFolder(imds_save_folder);
verifyFolder(pxds_save_folder);

for i=1:numel(imds_files)
   current_img = imread(imds_files{i});
   current_label = ~imbinarize(imread(pxds_files{i}));
    
   img_name = [num2str(i) export_format];
   img_save_folder = fullfile(imds_save_folder, img_name);
   imwrite(current_img, img_save_folder);
   fprintf("Saved an image in path %s \n", img_save_folder);
   
   label_name = [num2str(i) export_format];
   label_save_folder = fullfile(pxds_save_folder, label_name);
   imwrite(current_label, label_save_folder);
   fprintf("Saved a label in path %s \n", label_save_folder);
   
end

   fprintf("Finished image exporting! \n");

end

