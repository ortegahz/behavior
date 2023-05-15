%%
% author: manu

%%
close all; clear;

%%
opts.dirs_xml_in = ... 
{ ... 
'/media/manu/kingstoo/head/SCUT_HEAD_Part_A/Annotations' ...
'/media/manu/kingstoo/head/SCUT_HEAD_Part_B/Annotations' ...
};

opts.dir_txt_out = '/media/manu/kingstoo/head/dataset/labels';
opts.dir_img_out = '/media/manu/kingstoo/head/dataset/images';

opts.visual = false;

%%
system(sprintf('rm %s -rvf', opts.dir_txt_out));
system(sprintf('rm %s -rvf', opts.dir_img_out));
mkdir(opts.dir_txt_out);
mkdir(opts.dir_img_out);

%%
for z = 1 : length(opts.dirs_xml_in)
    
    dir_xml_in = opts.dirs_xml_in{z};
    dir_img_in = strrep(dir_xml_in, 'Annotations', 'JPEGImages');

    list_xml_in  = struct2cell(dir(fullfile(dir_xml_in, '*.xml')))';
    paths_xml_in = fullfile(dir_xml_in, list_xml_in(:, 1));

    for i = 1 : length(paths_xml_in)

        path_xml_in = paths_xml_in{i};
        [~, name, ~] = fileparts(path_xml_in);
        path_img_in = fullfile(dir_img_in, [name '.jpg']);
        
        fprintf('processing %dth[total %d] image %s ...\n', ...
            i, length(paths_xml_in), path_img_in);
        
        path_txt_out = fullfile(opts.dir_txt_out, [name '.txt']);
        
        copyfile(path_img_in, opts.dir_img_out);

        fileID = fopen(path_txt_out,'w');

        img = imread(path_img_in);
        
        [himg, wimg, ~] = size(img);

        if opts.visual
            imshow(img);
            title(path_img_in)
            hold on; 
        end

        xDoc = xmlread(path_xml_in);

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
            
            xcenter = (xmin + xmax) / 2 / wimg;
            ycenter = (ymin + ymax) / 2 / himg;
            wbox = (xmax - xmin) / wimg;
            hbox = (ymax - ymin) / himg;
            
            if opts.visual
                rectangle('Position', ...
                    [(xcenter-wbox/2)*wimg, (ycenter-hbox/2)*himg, ...
                    wbox*wimg, hbox*himg], ...
                    'Edgecolor', 'g', 'LineWidth', 3);
                text(xmin, ymin, name, 'BackgroundColor', 'r')
            end
            
            fprintf(fileID, '0 %f %f %f %f\n', xcenter, ycenter, wbox, hbox);
        end

        if opts.visual
            hold off;
            pause(0.1);
        end
        
        fclose(fileID);

    end

end

%%