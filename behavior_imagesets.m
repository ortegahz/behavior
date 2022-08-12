%%
% author: manu

%%
close all; clear;

%%
opts.dir_xml = '/media/manu/samsung/behavior_detection_based/voc/VOC2007/Annotations';
opts.path_trainval = '/media/manu/samsung/behavior_detection_based/voc/VOC2007/ImageSets/Main/trainval.txt';
opts.path_test = '/media/manu/samsung/behavior_detection_based/voc/VOC2007/ImageSets/Main/test.txt';
opts.length_test = 5000;

%%
list_xml  = struct2cell(dir(fullfile(opts.dir_xml, '*.xml')))';
paths_xml = fullfile(opts.dir_xml, list_xml(:, 1));

fid_test = fopen(opts.path_test,'w');
fid_trainval = fopen(opts.path_trainval,'w');

idxs = randperm(length(paths_xml));
paths_xml = paths_xml(idxs);

for i = 1 : length(paths_xml)

    path_xml = paths_xml{i};
    [~, name, ~] = fileparts(path_xml);

    xDoc = xmlread(path_xml);

    objects = xDoc.getElementsByTagName('object');
    
    if objects.getLength < 1, continue; end
    
    if i <= opts.length_test
        fprintf(fid_test, '%s\n', name);
    else
        fprintf(fid_trainval, '%s\n', name);
    end

end

fclose(fid_test);
fclose(fid_trainval);

%%