%%
% author: manu

%%
close all; clear;

%%
opts.dir_in_img = '/media/manu/samsung/behavior_detection_based/yolov5/images';
opts.dir_out_txt = '/media/manu/kingstoo/yolov5/custom_handsup/labels';
opts.dir_out_img = '/media/manu/kingstoo/yolov5/custom_handsup/images';
opts.path_out_train = '/media/manu/kingstoo/yolov5/custom_handsup/train2017.txt';
opts.path_out_val = '/media/manu/kingstoo/yolov5/custom_handsup/val2017.txt';
% opts.num_val = 4758 * 5000 / 118287;  % same rate as coco 2017

%%
system(sprintf('rm %s -rvf', fullfile(opts.dir_out_img, 'val2017')));
system(sprintf('rm %s -rvf', fullfile(opts.dir_out_img, 'train2017')));
system(sprintf('rm %s -rvf', fullfile(opts.dir_out_txt, 'val2017')));
system(sprintf('rm %s -rvf', fullfile(opts.dir_out_txt, 'train2017')));

mkdir(fullfile(opts.dir_out_img, 'val2017'));
mkdir(fullfile(opts.dir_out_img, 'train2017'));
mkdir(fullfile(opts.dir_out_txt, 'val2017'));
mkdir(fullfile(opts.dir_out_txt, 'train2017'));

list_in_img  = struct2cell(dir(fullfile(opts.dir_in_img, '*.jpg')))';
paths_in_img = fullfile(opts.dir_in_img, list_in_img(:, 1));

fid_out_val = fopen(opts.path_out_val, 'w');
fid_out_train = fopen(opts.path_out_train, 'w');

idxs = randperm(length(paths_in_img));
paths_in_img = paths_in_img(idxs);

opts.num_val = length(paths_in_img) * 5000 / 118287;  % same rate as coco 2017

for i = 1 : length(paths_in_img)

    path_in_img = paths_in_img{i};
    [~, name, ~] = fileparts(path_in_img);
    
    fprintf('processing %dth img %s [total %d]\n', ...
        i, path_in_img, length(paths_in_img));
    
    path_in_txt = strrep(path_in_img, '.jpg', '.txt');
    path_in_txt = strrep(path_in_txt, 'images', 'labels');
    
    if i <= opts.num_val
        fprintf(fid_out_val, './images/val2017/%s.jpg\n', name);
        if exist(path_in_txt,'file'), ...
                copyfile(path_in_txt, [opts.dir_out_txt '/val2017']); end
        copyfile(path_in_img, [opts.dir_out_img '/val2017']);
    else
        fprintf(fid_out_train, './images/train2017/%s.jpg\n', name);
        if exist(path_in_txt,'file'), ...
                copyfile(path_in_txt, [opts.dir_out_txt '/train2017']); end
        copyfile(path_in_img, [opts.dir_out_img '/train2017']);
    end

end

fclose(fid_out_val);
fclose(fid_out_train);

%%