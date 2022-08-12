%%
% author: manu

%%
close all; clear;

%%
opts.dir_xml = '/media/manu/samsung/behavior_detection_based/raw_14/xmls_bs_plus';
opts.dir_img = '/media/manu/samsung/behavior_detection_based/raw_14/imgs';
opts.time_pause = 0.01;

%%
list_xml  = struct2cell(dir(fullfile(opts.dir_xml, '*.xml')))';
paths_xml = fullfile(opts.dir_xml, list_xml(:, 1));

cnt_err = 0;
num_next = length(paths_xml);
for i = 1 : length(paths_xml)
    
    path_xml = paths_xml{i};
    
    fprintf('processing %dth img %s [total %d]\n', ...
        i, path_xml, length(paths_xml));

    [~, name, ~] = fileparts(path_xml);
    path_img = fullfile(opts.dir_img, [name '.jpg']);
    
    img = imread(path_img);

    imshow(img);
    title(path_img)

    hold on; 

    try
        xDoc = xmlread(path_xml);
    catch exception
        fprintf('empty xml file!\n');
        pause(opts.time_pause);
        hold off;
        continue;
    end

    objects = xDoc.getElementsByTagName('object');

    for j = 0 : objects.getLength - 1
        object = objects.item(j);

        names = object.getElementsByTagName('name');
        name =  names.item(0);
        name = char(name.getFirstChild.getData);

        points = object.getElementsByTagName('points');
        points =  points.item(0);

        points0 = points.getElementsByTagName('points0');
        points0 =  points0.item(0);
        
        x = points0.getElementsByTagName('x');
        x = x.item(0);
        xmin = str2double(char(x.getFirstChild.getData)) + 1;
        
        y = points0.getElementsByTagName('y');
        y = y.item(0);
        ymin = str2double(char(y.getFirstChild.getData)) + 1;
        
        points2 = points.getElementsByTagName('points2');
        points2 =  points2.item(0);
        
        x = points2.getElementsByTagName('x');
        x = x.item(0);
        xmax = str2double(char(x.getFirstChild.getData)) + 1;
        
        y = points2.getElementsByTagName('y');
        y = y.item(0);
        ymax = str2double(char(y.getFirstChild.getData)) + 1;

        try
            rectangle('Position', [xmin, ymin, xmax-xmin, ymax-ymin], 'Edgecolor', 'g', 'LineWidth', 3);
        catch exception
            fprintf('err xml file %s: %f %f %f %f\n', path_xml, xmin, ymin, xmax-xmin, ymax-ymin);
            cnt_err = cnt_err + 1;
            continue;
        end
        
        text(xmin, ymin, name, 'BackgroundColor', 'r')
    end

    hold off;
    
    if num_next < 1
        num_next = input('how many next samples you want?\n');
    else
        pause(opts.time_pause);
        num_next = num_next - 1;
    end
end

fprintf('cnt_err: %d\n', cnt_err);

%%