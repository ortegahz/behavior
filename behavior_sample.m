%%
% author: manu

%%
close all; clear all;

%%
opts.dir_img = '/media/manu/samsung/behavior_detection_based/raw_3/b';
opts.dir_out = '/media/manu/samsung/behavior_detection_based/raw_3/bs';

%%
list_img  = struct2cell(dir(fullfile(opts.dir_img, '*.jpg')))';
paths_img = fullfile(opts.dir_img, list_img(:, 1));

paths_img = paths_img(1:2:end);

for i = 1 : length(paths_img)
    
    path_img = paths_img{i};
    
    fprintf('processing %dth img %s [total %d]\n', ...
        i, path_img, length(paths_img));

    [~, name, ~] = fileparts(path_img);
    path_out = fullfile(opts.dir_out, [name '.jpg']);
    
    img = imread(path_img);
    
    imwrite(img, path_out);

end

%%