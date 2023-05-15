%%
% author: manu

%%
close all; clear;

%%
opts.dir_in = '/media/manu/samsung/behavior_detection_based/raw_1-14/imgs';
opts.dir_out = '/media/manu/samsung/behavior_detection_based/raw_1-14/xmls_voc';
opts.dir_out_imgs = '/media/manu/samsung/behavior_detection_based/raw_1-14/imgs_voc';
opts.names = {'stand', 'lookback', 'handsup', 'overdesk'};
% opts.names_pick = {'stand', 'lookback', 'handsup', 'overdesk'};
opts.names_pick = {'handsup'};
opts.drop_rate_pbg = 0.5;
opts.drop_rate_fbg = 0.8;

%%
system(sprintf('rm %s -rvf', opts.dir_out));
mkdir(opts.dir_out);
system(sprintf('rm %s -rvf', opts.dir_out_imgs));
mkdir(opts.dir_out_imgs);

list_in  = struct2cell(dir(fullfile(opts.dir_in, '*.jpg')))';
paths_in = fullfile(opts.dir_in, list_in(:, 1));

cnt_files = 0;
cnt_files_err = 0;
cnt_points = zeros(1, 4);
for i = 1 : length(paths_in)
    
    info = [];
    
    path_in = paths_in{i};
    [~, name, ext] = fileparts(path_in);
    
    fprintf('processing %d/%d xml %s\n', i, length(paths_in), path_in);
    
    info.path = fullfile(opts.dir_out, [name '.xml']);
    
    path_img = path_in;
    path_img_out = fullfile(opts.dir_out_imgs, [name '.jpg']);
    
    path_in = strrep(path_img, 'imgs', 'xmls');
    path_in = strrep(path_in, 'jpg', 'xml');
    
    if exist(path_in, 'file')
        copyfile(path_img, path_img_out);
    elseif rand() < opts.drop_rate_pbg
        continue;
    else  % keep bg img
        copyfile(path_img, path_img_out);
        continue;
    end
    
%     if ~exist(path_in, 'file'), continue; end
    
    % pre-setp guarantee no empty xmls

    xDoc = xmlread(path_in);
    
    % keep origin name for debug reason
    filenames = xDoc.getElementsByTagName('filename');
    filename = filenames.item(0);
    filename = char(filename.getFirstChild.getData);
    info.filename = filename;
%     info.filename = name;
    
    sizes = xDoc.getElementsByTagName('size');
    size = sizes.item(0);
    
    widths = size.getElementsByTagName('width');
    width =  widths.item(0);
    width = str2double(char(width.getFirstChild.getData));
    info.size.width = num2str(width);
    
    heights = size.getElementsByTagName('height');
    height =  heights.item(0);
    height = str2double(char(height.getFirstChild.getData));
    info.size.height = num2str(height);
    
    depth = 3;
    info.size.depth = num2str(depth);

    objects = xDoc.getElementsByTagName('object');
    
    info.objects = cell(1, objects.getLength);

    flag_err = false;
    idxs_invalid = [];
    for j = 0 : objects.getLength - 1
        object = objects.item(j);

        names = object.getElementsByTagName('name');
        name =  names.item(0);
        name = char(name.getFirstChild.getData);
        info.objects{j+1}.name = name;
%         if isempty(deblank(name)), flag_err = true; end
        c = find(strcmp(opts.names, name));
        if isempty(c)
            flag_err = true; 
            fprintf('[%s] name error --> %s\n', path_in, name);
            cnt_files_err = cnt_files_err + 1;
            break; 
        end
        assert(c >= 1 && c <= 4);
        
        cp = find(strcmp(opts.names_pick, name));
        if isempty(cp)
            idxs_invalid = [idxs_invalid, j+1];
        end
        
        points = object.getElementsByTagName('points');
        points =  points.item(0);

        points0 = points.getElementsByTagName('points0');
        points0 =  points0.item(0);
        
        x = points0.getElementsByTagName('x');
        x = x.item(0);
        xmin = str2double(char(x.getFirstChild.getData)) + 1;
        assert(isnumeric(xmin));
        if xmin < 1, xmin = 1; end
        info.objects{j+1}.xmin = num2str(xmin);
        
        y = points0.getElementsByTagName('y');
        y = y.item(0);
        ymin = str2double(char(y.getFirstChild.getData)) + 1;
        assert(isnumeric(ymin));
        if ymin < 1, ymin = 1; end
        info.objects{j+1}.ymin = num2str(ymin);
        
        points2 = points.getElementsByTagName('points2');
        points2 =  points2.item(0);
        
        x = points2.getElementsByTagName('x');
        x = x.item(0);
        xmax = str2double(char(x.getFirstChild.getData)) + 1;
        assert(isnumeric(xmax));
        if xmax > width, xmax = width; end
        info.objects{j+1}.xmax = num2str(xmax);
        
        y = points2.getElementsByTagName('y');
        y = y.item(0);
        ymax = str2double(char(y.getFirstChild.getData)) + 1;
        assert(isnumeric(ymax));
        if ymax > height, ymax = height; end
        info.objects{j+1}.ymax = num2str(ymax);
        
        voc_w = xmax - xmin;
        voc_h = ymax - ymin;
        if voc_w <= 0 || voc_h <= 0
            fprintf('[%s] voc_w/voc_h error --> %f/%f\n', ...
                path_in, voc_w, voc_h);
            cnt_files_err = cnt_files_err + 1;
            flag_err = true; 
            break; 
        end
        
        cnt_points(c) = cnt_points(c) + 1;

    end
    
    % filter illegal xmls
    if flag_err || length(idxs_invalid) == objects.getLength
        if rand() < opts.drop_rate_fbg
            system(sprintf('rm %s -rvf', path_img_out));
        end
        continue; 
    end
    
    info.objects(idxs_invalid) = [];
    
    behavior_xmlwrite(info);
    
    cnt_files = cnt_files + 1;

end

% result 1-14
% total number of stand points --> 78305 !!!
% total number of lookback points --> 60719 !!!
% total number of handsup points --> 9286 !!!
% total number of overdesk points --> 43518 !!!
% total number of files --> 34223 !!!
% total number of error files --> 8 !!!
fprintf('total number of stand points --> %d !!!\n', cnt_points(1));
fprintf('total number of lookback points --> %d !!!\n', cnt_points(2));
fprintf('total number of handsup points --> %d !!!\n', cnt_points(3));
fprintf('total number of overdesk points --> %d !!!\n', cnt_points(4));
fprintf('total number of files --> %d !!!\n', cnt_files);
fprintf('total number of error files --> %d !!!\n', cnt_files_err);
% result 1-14 w/o actor scene
% total number of stand points --> 55872 !!!
% total number of lookback points --> 50420 !!!
% total number of handsup points --> 370 !!!
% total number of overdesk points --> 38538 !!!
% total number of files --> 236 !!!
% total number of error files --> 3 !!!


%%