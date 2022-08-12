%%
% author: manu

%%
close all; clear all;

%%
opts.dir_img = '/media/manu/samsung/behavior_detection_based/raw_4567/JPEGImages';
opts.dir_out = '/home/manu/tmp/imgs_quantization';
opts.lst_out = '/home/manu/tmp/lst_quantization.txt';
opts.nsample = 50;

%%
list_img  = struct2cell(dir(fullfile(opts.dir_img, '*.jpg')))';
paths_img = fullfile(opts.dir_img, list_img(:, 1));

paths_img = paths_img(randperm(length(paths_img)));
idxs = randi([1 length(paths_img)], [1 opts.nsample]);
paths_img = paths_img(idxs);

fileID = fopen(opts.lst_out,'w');

for i = 1 : length(paths_img)
    
    path_img = paths_img{i};
    
    fprintf('processing %dth img %s [total %d]\n', ...
        i, path_img, length(paths_img));

    [~, name, ~] = fileparts(path_img);
    path_out = fullfile(opts.dir_out, [name '.jpg']);
    
    fprintf(fileID, './imgs_quantization/%s\n', [name '.jpg']);
    
    img = imread(path_img);
    
    imwrite(img, path_out);

end

fclose(fileID);

%%