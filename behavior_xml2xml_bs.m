%%
% author: manu

%%
close all; clear;

%%
opts.dir_in = '/media/manu/samsung/behavior_detection_based/raw_1-14/xmls';
opts.dir_out = '/media/manu/samsung/behavior_detection_based/raw_1-14/xmls_voc';
opts.names = {'stand', 'lookback', 'handsup', 'overdesk'};

%%
system(sprintf('rm %s -rvf', opts.dir_out));
mkdir(opts.dir_out);

list_in  = struct2cell(dir(fullfile(opts.dir_in, '*.xml')))';
paths_in = fullfile(opts.dir_in, list_in(:, 1));

cnt_files = 0;
cnt_files_err = 0;
cnt_points = 0;
for i = 1 : length(paths_in)
    
    info = [];
    
    path_in = paths_in{i};
    [~, name, ext] = fileparts(path_in);
    info.path = fullfile(opts.dir_out, [name ext]);
    
    path_img = strrep(path_in, 'xmls', 'imgs');
    path_img = strrep(path_img, 'xml', 'jpg');
    
    fprintf('processing %d/%d xml %s\n', i, length(paths_in), path_in);
    
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
        
        cnt_points = cnt_points + 1;

    end
    
    % filter illegal xmls and imgs
    if flag_err
        system(sprintf('rm %s -rvf', path_img));
        continue; 
    end
    
    behavior_xmlwrite(info);
    
    cnt_files = cnt_files + 1;

end

fprintf('total number of points --> %d !!!\n', cnt_points);
fprintf('total number of files --> %d !!!\n', cnt_files);
fprintf('total number of error files --> %d !!!\n', cnt_files_err);


%%