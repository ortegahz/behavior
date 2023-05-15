%%
% author: manu

%%
close all; clear;

%%
opts.dir_root = '/media/manu/kingstoo/crhm/save';
opts.subset = 'val';

%%
dir_subset = fullfile(opts.dir_root, opts.subset);
dir_imgs = fullfile(dir_subset, 'images');
path_label_fullbody = fullfile(dir_subset, 'label_fullbody.txt');
path_label_head = fullfile(dir_subset, 'label_head.txt');

fileID = fopen(path_label_head);
C = textscan(fileID,'# %s %d %d\n %f');
fclose(fileID);


%%