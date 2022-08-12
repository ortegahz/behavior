%%
% author: manu

%%
close all; clear all;

%%
opts.paths_xml = '/media/manu/samsung/behavior_detection_based/raw_9/xmls/2020-11-26_13_59_52_029775.xml';
opts.path_img = '/media/manu/samsung/behavior_detection_based/raw_9/imgs/2020-11-26_13_59_52_029775.jpg';

%%
    
path_xml = opts.paths_xml;
path_img = opts.path_img;

img = imread(path_img);

imshow(img);
title(path_img)

hold on; 

try
    xDoc = xmlread(path_xml);
catch exception
    fprintf('empty xml file!\n');
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

    rectangle('Position', [xmin, ymin, xmax-xmin, ymax-ymin], 'Edgecolor', 'g', 'LineWidth', 3);

    text(xmin, ymin, name, 'BackgroundColor', 'r')
end

hold off;

pause(1);


%%