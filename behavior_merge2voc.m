%%
% author: manu

%%
close all; clear;

%%
opts.dir_in_img = '/media/manu/samsung/behavior_detection_based/raw_1-14/imgs_voc';
opts.dir_out_base = '/media/manu/samsung/behavior_detection_based/voc';

%%
system(sprintf('rm %s -rvf', opts.dir_out_base));

dir_VOC2007 = fullfile(opts.dir_out_base, 'VOC2007');
dir_VOC2007_Annotations = fullfile(dir_VOC2007, 'Annotations');
dir_VOC2007_ImageSets = fullfile(dir_VOC2007, 'ImageSets');
dir_VOC2007_JPEGImages = fullfile(dir_VOC2007, 'JPEGImages');
dir_VOC2007_ImageSets_Main = fullfile(dir_VOC2007_ImageSets, 'Main');

mkdir(opts.dir_out_base);
mkdir(dir_VOC2007);
mkdir(dir_VOC2007_Annotations);
mkdir(dir_VOC2007_ImageSets);
mkdir(dir_VOC2007_JPEGImages);
mkdir(dir_VOC2007_ImageSets_Main);

list_in_img  = struct2cell(dir(fullfile(opts.dir_in_img, '*.jpg')))';
paths_in_img = fullfile(opts.dir_in_img, list_in_img(:, 1));

cnt = 0;
for i = 1 : length(paths_in_img)
    
    path_in_img = paths_in_img{i};
    
    fprintf('processing %dth img %s [total %d]\n', ...
        i, path_in_img, length(paths_in_img));
    
    path_in_xml = strrep(path_in_img, '.jpg', '.xml');
    path_in_xml = strrep(path_in_xml, 'imgs_voc', 'xmls_voc');
    
    [~, name, ~] = fileparts(path_in_img);
    path_out_img = fullfile(dir_VOC2007_JPEGImages, [name '.jpg']);
    path_out_xml = fullfile(dir_VOC2007_Annotations, [name '.xml']);
    
    % copy image file anyway.
    copyfile(path_in_img, path_out_img);
    if exist(path_in_xml, 'file')
        copyfile(path_in_xml, path_out_xml);
    end

end



%%