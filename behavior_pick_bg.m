%%
% author: manu

%%
close all; clear;

%%
opts.dirs_xml_in = ... 
{ ... 
% '/media/manu/samsung/behavior_detection_based/raw_1/xmls_bs_plus' ...
% '/media/manu/samsung/behavior_detection_based/raw_2/xmls_bs_plus' ...
% '/media/manu/samsung/behavior_detection_based/raw_3/xmls_bs_plus' ...
% '/media/manu/samsung/behavior_detection_based/raw_4/xmls_bs_plus' ...
% '/media/manu/samsung/behavior_detection_based/raw_5/xmls_bs_plus' ...
% '/media/manu/samsung/behavior_detection_based/raw_6/xmls_bs_plus' ...
% '/media/manu/samsung/behavior_detection_based/raw_7/xmls_bs_plus' ...
% '/media/manu/samsung/behavior_detection_based/raw_8/xmls_bs_plus' ...
'/media/manu/samsung/behavior_detection_based/raw_9/xmls_bs_plus' ...
% '/media/manu/samsung/behavior_detection_based/raw_10/xmls_bs_plus' ...
% '/media/manu/samsung/behavior_detection_based/raw_11/xmls_bs_plus' ...
% '/media/manu/samsung/behavior_detection_based/raw_12/xmls_bs_plus' ...
% '/media/manu/samsung/behavior_detection_based/raw_13/xmls_bs_plus' ...
% '/media/manu/samsung/behavior_detection_based/raw_14/xmls_bs_plus' ...
};
opts.dir_xml_out = '/media/manu/samsung/behavior_detection_based/raw_15/xmls';

dir_xml_out = opts.dir_xml_out;
dir_img_out = strrep(dir_xml_out, 'xmls', 'imgs');

system(sprintf('rm %s -rvf', dir_xml_out));
system(sprintf('rm %s -rvf', dir_img_out));
mkdir(dir_xml_out);
mkdir(dir_img_out);

idx = 0;

%%
for i = 1 : length(opts.dirs_xml_in)
    dir_xml_in = opts.dirs_xml_in{i};
    dir_img_in = strrep(dir_xml_in, 'xmls_bs_plus', 'imgs');
    
    list_img  = struct2cell(dir(fullfile(dir_img_in, '*.jpg')))';
    paths_img = fullfile(dir_img_in, list_img(:, 1));
    
    for j = 1 : length(paths_img) 
        path_img = paths_img{j};
        [~, name, ~] = fileparts(path_img);
        path_xml = fullfile(dir_xml_in, [name '.xml']);
        
        if ~exist(path_xml,'file')
            path_xml = strrep(path_xml, 'xmls_bs_plus', 'xmls');
            copyfile(path_xml, fullfile(dir_xml_out, [name, '.xml']));
            copyfile(path_img, fullfile(dir_img_out, [name, '.jpg']));
            idx = idx + 1;
        end
    end
end

fprintf('total number of image --> %d !!!\n', idx);

%%