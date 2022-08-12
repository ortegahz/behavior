%%
% author: manu

%%
close all; clear all;

%%
opts.dir_in = '/media/manu/samsung/behavior_detection_based/raw_2/xmls';
opts.dir_out = '/media/manu/samsung/behavior_detection_based/raw_2/xmls_bs';

%%
list_in  = struct2cell(dir(fullfile(opts.dir_in, '*.xml')))';
paths_in = fullfile(opts.dir_in, list_in(:, 1));

cnt = 0;
for i = 1 : length(paths_in)
    
    info = [];
    
    path_in = paths_in{i};
    [~, name, ext] = fileparts(path_in);
    info.path = fullfile(opts.dir_out, [name ext]);

    xDoc = xmlread(path_in);
    
    filenames = xDoc.getElementsByTagName('filename');
    filename = filenames.item(0);
    filename = char(filename.getFirstChild.getData);
    info.filename = filename;
    
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
    
    depths = size.getElementsByTagName('depth');
    depth =  depths.item(0);
    depth = str2double(char(depth.getFirstChild.getData));
    info.size.depth = num2str(depth);

    objects = xDoc.getElementsByTagName('object');
    
    info.objects = cell(1, objects.getLength);

    for j = 0 : objects.getLength - 1
        object = objects.item(j);

        names = object.getElementsByTagName('name');
        name =  names.item(0);
        name = char(name.getFirstChild.getData);
        info.objects{j+1}.name = name;

        bndboxs = object.getElementsByTagName('bndbox');
        bndbox =  bndboxs.item(0);

        xmins = bndbox.getElementsByTagName('xmin');
        xmin =  xmins.item(0);
        xmin = str2double(char(xmin.getFirstChild.getData));
        info.objects{j+1}.xmin = num2str(xmin);

        ymins = bndbox.getElementsByTagName('ymin');
        ymin =  ymins.item(0);
        ymin = str2double(char(ymin.getFirstChild.getData));
        info.objects{j+1}.ymin = num2str(ymin);

        xmaxs = bndbox.getElementsByTagName('xmax');
        xmax =  xmaxs.item(0);
        xmax = str2double(char(xmax.getFirstChild.getData));
        info.objects{j+1}.xmax = num2str(xmax);

        ymaxs = bndbox.getElementsByTagName('ymax');
        ymax =  ymaxs.item(0);
        ymax = str2double(char(ymax.getFirstChild.getData));
        info.objects{j+1}.ymax = num2str(ymax);
        
        info.objects{j+1}.x0 = num2str(xmin);
        info.objects{j+1}.y0 = num2str(ymin);
        info.objects{j+1}.x1 = num2str(xmax);
        info.objects{j+1}.y1 = num2str(ymin);
        info.objects{j+1}.x2 = num2str(xmax);
        info.objects{j+1}.y2 = num2str(ymax);
        info.objects{j+1}.x3 = num2str(xmin);
        info.objects{j+1}.y3 = num2str(ymax);
        
        cnt = cnt + 1;

    end
    
    behavior_xmlwrite_bs(info);

end

fprintf('total number: %d !!!\n', cnt);


%%