from __future__ import print_function
import cv2
import argparse
import os
import os.path as osp
import shutil
import numpy as np
import json


def parse_args():
    parser = argparse.ArgumentParser(
        description='convert crowdhuman dataset to scrfd format')
    parser.add_argument('--raw', help='raw dataset dir')
    parser.add_argument('--save', default='data/crowdhuman', help='save path')
    parser.add_argument('--show', action='store_true', help='show results')
    args = parser.parse_args()

    return args


def main():
    args = parse_args()

    if osp.exists(args.save):
        shutil.rmtree(args.save)  # clear up

    raw_image_dir = osp.join(args.raw, 'Images')
    for subset in ['train', 'val']:
        save_image_dir = osp.join(args.save, 'images', subset + '2017')
        if not osp.exists(save_image_dir):
            os.makedirs(save_image_dir)
        save_label_dir = osp.join(args.save, 'labels', subset + '2017')
        if not osp.exists(save_label_dir):
            os.makedirs(save_label_dir)
        anno_file = osp.join(args.raw, 'annotation_%s.odgt' % subset)
        split_file = osp.join(args.save, subset + '2017' + '.txt')
        split_f = open(split_file, 'w')
        for line in open(anno_file, 'r'):
            data = json.loads(line)
            img_id = data['ID']
            img_name = "%s.jpg" % img_id
            lb_name = "%s.txt" % img_id
            raw_image_file = osp.join(raw_image_dir, img_name)
            target_image_file = osp.join(save_image_dir, img_name)
            target_label_file = osp.join(save_label_dir, lb_name)
            img = cv2.imread(raw_image_file)
            print(raw_image_file, img.shape)
            fullbody_f = open(target_label_file, 'w')
            shutil.copyfile(raw_image_file, target_image_file)
            path_r = './images/%s2017/%s' % (subset, img_name)
            split_f.write("%s\n" % path_r)
            items = data['gtboxes']
            for item in items:
                tag = item['tag']

                fbox = item['fbox']
                is_ignore = False
                extra = item['extra']
                if 'ignore' in extra:
                    is_ignore = extra['ignore'] == 1
                bbox = np.array(fbox, dtype=np.float32)
                bbox[2] += bbox[0]
                bbox[3] += bbox[1]
                p1, p2 = (int(bbox[0]), int(bbox[1])), (int(bbox[2]), int(bbox[3]))
                if tag == 'mask':
                    cv2.rectangle(img, p1, p2, (0, 255, 255), thickness=2)
                    continue
                cx = (bbox[0] + bbox[2]) / 2. / img.shape[1]
                cy = (bbox[1] + bbox[3]) / 2. / img.shape[0]
                w = (bbox[2] - bbox[0]) / img.shape[1]
                h = (bbox[3] - bbox[1]) / img.shape[0]
                if not is_ignore:
                    fullbody_f.write("0 %.5f %.5f %.5f %.5f\n" % (cx, cy, w, h))
                color = (0, 255, 0) if not is_ignore else (0, 0, 255)
                cv2.rectangle(img, p1, p2, color, thickness=2)
            if args.show:
                cv2.imshow("show", img)
                cv2.waitKey(0)
            fullbody_f.close()
        split_f.close()


if __name__ == '__main__':
    main()
