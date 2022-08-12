%%
% author: manu

%%
close all; clear all;

%%
opts.dir_xml = '/home/manu/data/behavior_detection_based/raw_9/xmls';
opts.dir_img = '/home/manu/data/behavior_detection_based/raw_9/imgs';
opts.dir_out_xml = '/home/manu/data/behavior_detection_based/raw_9/xmls_samplepsplit';
opts.dir_out_img = '/home/manu/data/behavior_detection_based/raw_9/imgs_samplepsplit';

opts.nsplit = 10;
opts.nsample_per_split = 100;

%%
system(sprintf('rm %s -rvf', opts.dir_out_xml));
system(sprintf('rm %s -rvf', opts.dir_out_img));
mkdir(opts.dir_out_xml);
mkdir(opts.dir_out_img);

list_in_xml  = struct2cell(dir(fullfile(opts.dir_xml, '*.xml')))';
paths_in_xml = fullfile(opts.dir_xml, list_in_xml(:, 1));

idxs = randperm(length(paths_in_xml));
paths_in_xml = paths_in_xml(idxs);

cnt = 0;
for i = 1 : opts.nsplit
    
    for j = 1 : opts.nsample_per_split
    
        cnt = cnt + 1;
        fprintf('processing number %d ...\n', cnt);
        
        path_xml = paths_in_xml{cnt};
        path_img = strrep(path_xml, 'xmls', 'imgs');
        path_img = strrep(path_img, '.xml', '.jpg');

        [~, name, ~] = fileparts(path_xml);
        
        dir_out_xml = fullfile(opts.dir_out_xml, sprintf('split_%d', i));
        if ~exist(dir_out_xml, 'dir'),  mkdir(dir_out_xml); end
        path_out_xml = fullfile(dir_out_xml, [name '.xml']);

        dir_out_img = fullfile(opts.dir_out_img, sprintf('split_%d', i));
        if ~exist(dir_out_img, 'dir'), mkdir(dir_out_img); end
        path_out_img = fullfile(dir_out_img, [name '.jpg']);
        
        copyfile(path_xml, path_out_xml);
        copyfile(path_img, path_out_img);
    
    end

end

%%