%%
% author: manu

%%
close all; clear;

%%
opts.dir_in_txt = '/media/manu/kingstoo/head/dataset/labels';
opts.dir_out = '/media/manu/kingstoo/yolov5/custom_head';
opts.dir_out_txt = '/media/manu/kingstoo/yolov5/custom_head/labels';
opts.dir_out_img = '/media/manu/kingstoo/yolov5/custom_head/images';
opts.path_out_train = '/media/manu/kingstoo/yolov5/custom_head/train2017.txt';
opts.path_out_val = '/media/manu/kingstoo/yolov5/custom_head/val2017.txt';
opts.rate_val = 0.1;

%%
system(sprintf('rm %s -rvf', opts.dir_out));

mkdir(opts.dir_out);
mkdir(fullfile(opts.dir_out_img, 'val2017'));
mkdir(fullfile(opts.dir_out_img, 'train2017'));
mkdir(fullfile(opts.dir_out_txt, 'val2017'));
mkdir(fullfile(opts.dir_out_txt, 'train2017'));

list_in_txt  = struct2cell(dir(fullfile(opts.dir_in_txt, '*.txt')))';
paths_in_txt = fullfile(opts.dir_in_txt, list_in_txt(:, 1));

fid_out_val = fopen(opts.path_out_val, 'w');
fid_out_train = fopen(opts.path_out_train, 'w');

idxs = randperm(length(paths_in_txt));
paths_in_txt = paths_in_txt(idxs);

for i = 1 : length(paths_in_txt)

    path_in_txt = paths_in_txt{i};
    [~, name, ~] = fileparts(path_in_txt);
    
    fprintf('processing %dth img %s [total %d]\n', ...
        i, path_in_txt, length(paths_in_txt));
    
    path_in_img = strrep(path_in_txt, '.txt', '.jpg');
    path_in_img = strrep(path_in_img, 'labels', 'images');
    
    if i <= opts.rate_val * length(paths_in_txt)
        fprintf(fid_out_val, './images/val2017/%s.jpg\n', name);
        copyfile(path_in_txt, [opts.dir_out_txt '/val2017']);
        copyfile(path_in_img, [opts.dir_out_img '/val2017']);
    else
        fprintf(fid_out_train, './images/train2017/%s.jpg\n', name);
        copyfile(path_in_txt, [opts.dir_out_txt '/train2017']);
        copyfile(path_in_img, [opts.dir_out_img '/train2017']);
    end

end

fclose(fid_out_val);
fclose(fid_out_train);

%%