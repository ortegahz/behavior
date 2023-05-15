%%
% author: manu

%%
close all; clear;

%%
opts.dir_root = '/media/manu/kingstoo/yolov5/custom_handsup';
opts.subset = 'train';
% opts.names = {'stand', 'lookback', 'handsup', 'overdesk'};
% opts.names = {'human'};
opts.names = {'face'};
opts.kps = false;
opts.show_label = false;

%%
path_split_file = fullfile(opts.dir_root, [opts.subset '2017.txt']);

fid = fopen(path_split_file);
C = textscan(fid, '%s');
fclose(fid);

for i = 1 : length(C{1})
    path_img_r = C{1}{i};
    path_img = fullfile(opts.dir_root, path_img_r);
    path_label = strrep(path_img, 'images', 'labels');
    path_label = strrep(path_label, '.jpg', '.txt');
    
    fprintf('processing %dth img %s [total %d]\n', ...
        i, path_img, length(C{1}));
    
%     if ~strcmp(path_img, '/media/manu/kingstoo/yolov5/custom_insightface/images/train2017/27_Spa_Spa_27_13.jpg')
%         continue;
%     end

    img = imread(path_img);
    [img_h, img_w, ~] = size(img);
    imshow(img);
    title(path_img);
    
    if ~exist(path_label, 'file'), continue; end
    
    if opts.kps
        fid = fopen(path_label);
        D = textscan(fid, '%d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
        fclose(fid);
    else
        fid = fopen(path_label);
        D = textscan(fid, '%d %f %f %f %f');
        fclose(fid);
    end
    
    for j = 1 : length(D{1})
        l = D{1}(j);
        cx = D{2}(j) * img_w;
        cy = D{3}(j) * img_h;
        w = D{4}(j) * img_w;
        h = D{5}(j) * img_h;
        
        x = cx - w / 2;
        y = cy - h / 2;
        
        hold on;
        rectangle('Position', [x, y, w, h], 'Edgecolor', 'g', 'LineWidth', 3);
        if opts.show_label
            text(x, y, opts.names{l+1}, 'BackgroundColor', 'r')
        end
        hold off;
 
        if opts.kps
            for k = 1 : 5
                idx = (k-1) * 3;
                kx = D{6+idx}(j);
                ky = D{7+idx}(j);
                kz = D{8+idx}(j);
                if all([kx ky kz] > -1)
                    hold on;
                    plot(kx*img_w, ky*img_h, '.', 'Color', 'r', 'MarkerSize', 10);
                    hold off;
                end
            end
        end
    end

    pause(1);
end

%%