%%
% author: manu

%%
close all; clear;

%%
opts.dir_in_img = '/media/manu/samsung/behavior_detection_based/voc/VOC2007/JPEGImages';
opts.dir_out_base = '/media/manu/samsung/behavior_detection_based/yolov5';
opts.dir_out_txt = '/media/manu/samsung/behavior_detection_based/yolov5/labels';
opts.dir_out_img = '/media/manu/samsung/behavior_detection_based/yolov5/images';
% opts.names = {'stand', 'lookback', 'handsup', 'overdesk'};
opts.names = {'handsup'};
opts.view = false;

%%
system(sprintf('rm %s -rvf', opts.dir_out_base));
mkdir(opts.dir_out_base);
mkdir(opts.dir_out_txt);
mkdir(opts.dir_out_img);

list_in_img  = struct2cell(dir(fullfile(opts.dir_in_img, '*.jpg')))';
paths_in_img = fullfile(opts.dir_in_img, list_in_img(:, 1));

cnt = 0;
for i = 1 : length(paths_in_img)
    
    path_in_img = paths_in_img{i};
    
    fprintf('processing %dth img %s [total %d]\n', ...
        i, path_in_img, length(paths_in_img));
    
    path_in_xml = strrep(path_in_img, '.jpg', '.xml');
    path_in_xml = strrep(path_in_xml, 'JPEGImages', 'Annotations');
    
    [~, name, ~] = fileparts(path_in_img);
    path_out_txt = fullfile(opts.dir_out_txt, [name '.txt']);
    path_out_img = fullfile(opts.dir_out_img, [name '.jpg']);
    
    % copy image file anyway.
    copyfile(path_in_img, path_out_img);

    if opts.view
        img = imread(path_in_img);
        imshow(img);
        title(path_in_img)
        hold on; 
    end
    
    % ref (if no objects in image, no *.txt file is required)
    if ~exist(path_in_xml, 'file')
        if opts.view, hold off; pause(1); end
        continue;
    end
    
    xDoc = xmlread(path_in_xml);
    
    sizes = xDoc.getElementsByTagName('size');
    size = sizes.item(0);
    
    widths = size.getElementsByTagName('width');
    width =  widths.item(0);
    width = str2double(char(width.getFirstChild.getData));
    
    heights = size.getElementsByTagName('height');
    height =  heights.item(0);
    height = str2double(char(height.getFirstChild.getData));

    objects = xDoc.getElementsByTagName('object');

	fileID = fopen(path_out_txt, 'w');
    
    for j = 0 : objects.getLength - 1
        object = objects.item(j);

        names = object.getElementsByTagName('name');
        name =  names.item(0);
        name = char(name.getFirstChild.getData);

        c = find(strcmp(opts.names, name)) - 1;
        
        bndbox = object.getElementsByTagName('bndbox');
        bndbox =  bndbox.item(0);
        
        xmin = bndbox.getElementsByTagName('xmin');
        xmin = xmin.item(0);
        xmin = str2double(char(xmin.getFirstChild.getData)) - 1;
        
        ymin = bndbox.getElementsByTagName('ymin');
        ymin = ymin.item(0);
        ymin = str2double(char(ymin.getFirstChild.getData)) - 1;
        
        xmax = bndbox.getElementsByTagName('xmax');
        xmax = xmax.item(0);
        xmax = str2double(char(xmax.getFirstChild.getData)) - 1;
        
        ymax = bndbox.getElementsByTagName('ymax');
        ymax = ymax.item(0);
        ymax = str2double(char(ymax.getFirstChild.getData)) - 1;
        
        if opts.view
            rectangle('Position', [xmin+1, ymin+1, xmax-xmin, ymax-ymin], 'Edgecolor', 'g', 'LineWidth', 3);
            text(xmin+1, ymin+1, name, 'BackgroundColor', 'r')
        end
        
        % for yolov5
        xc = (xmax + xmin) / 2 / width;
        yc = (ymax + ymin) / 2 / height;
        w = (xmax - xmin) / width;
        h = (ymax - ymin) / height;
        

        fprintf(fileID, '%d %f %f %f %f\n', c, xc, yc, w, h);
        
        cnt = cnt + 1;

    end
    
	fclose(fileID);
    
    if opts.view, hold off; pause(1); end

end

% number missmatch because of cnt_files_err
fprintf('total number of point --> %d !!!\n', cnt);


%%