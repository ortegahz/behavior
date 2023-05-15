%%
% author: manu

%%
close all; clear;

%%
opts.dir_xml = '/media/manu/kingstoo/head/SCUT_HEAD_Part_A/Annotations';
opts.dir_img = '/media/manu/kingstoo/head/SCUT_HEAD_Part_A/JPEGImages';

%%
list_xml  = struct2cell(dir(fullfile(opts.dir_xml, '*.xml')))';
paths_xml = fullfile(opts.dir_xml, list_xml(:, 1));

for i = 1 : length(paths_xml)

    path_xml = paths_xml{i};
    [~, name, ~] = fileparts(path_xml);
    path_img = fullfile(opts.dir_img, [name '.jpg']);
    
    img = imread(path_img);

    imshow(img);
    title(path_img)

    hold on; 

    xDoc = xmlread(path_xml);

    objects = xDoc.getElementsByTagName('object');

    for j = 0 : objects.getLength - 1
        object = objects.item(j);

        names = object.getElementsByTagName('name');
        name =  names.item(0);
        name = char(name.getFirstChild.getData);

        bndboxs = object.getElementsByTagName('bndbox');
        bndbox =  bndboxs.item(0);

        xmins = bndbox.getElementsByTagName('xmin');
        xmin =  xmins.item(0);
        xmin = str2double(char(xmin.getFirstChild.getData));

        ymins = bndbox.getElementsByTagName('ymin');
        ymin =  ymins.item(0);
        ymin = str2double(char(ymin.getFirstChild.getData));

        xmaxs = bndbox.getElementsByTagName('xmax');
        xmax =  xmaxs.item(0);
        xmax = str2double(char(xmax.getFirstChild.getData));

        ymaxs = bndbox.getElementsByTagName('ymax');
        ymax =  ymaxs.item(0);
        ymax = str2double(char(ymax.getFirstChild.getData));

        rectangle('Position', [xmin, ymin, xmax-xmin, ymax-ymin], 'Edgecolor', 'g', 'LineWidth', 3);
        
        text(xmin, ymin, name, 'BackgroundColor', 'r')
    end

    hold off;
    
    pause(0.1);

end

%%