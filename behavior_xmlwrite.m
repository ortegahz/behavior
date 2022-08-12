function behavior_xmlwrite(info)

docNode = com.mathworks.xml.XMLUtils.createDocument ... 
    ('annotation');
docRootNode = docNode.getDocumentElement;

folderElement = docNode.createElement('folder'); 
folderElement.appendChild... 
    (docNode.createTextNode('VOC2007'));
docRootNode.appendChild(folderElement);

filenameElement = docNode.createElement('filename'); 
filenameElement.appendChild... 
    (docNode.createTextNode(info.filename));
docRootNode.appendChild(filenameElement);

% source node
sourceElement = docNode.createElement('source'); 
docRootNode.appendChild(sourceElement);
databaseElement = docNode.createElement('database'); 
databaseElement.appendChild... 
    (docNode.createTextNode('The VOC2007 Database'));
sourceElement.appendChild(databaseElement);
annotationElement = docNode.createElement('annotation'); 
annotationElement.appendChild... 
    (docNode.createTextNode('PASCAL VOC2007'));
sourceElement.appendChild(annotationElement);
imageElement = docNode.createElement('image'); 
imageElement.appendChild... 
    (docNode.createTextNode('flickr'));
sourceElement.appendChild(imageElement);
flickridElement = docNode.createElement('flickrid'); 
flickridElement.appendChild... 
    (docNode.createTextNode('329145082'));
sourceElement.appendChild(flickridElement);

% owner node
ownerElement = docNode.createElement('owner'); 
docRootNode.appendChild(ownerElement);
flickridElement = docNode.createElement('flickrid'); 
flickridElement.appendChild... 
    (docNode.createTextNode('hiromori2'));
ownerElement.appendChild(flickridElement);
nameElement = docNode.createElement('name'); 
nameElement.appendChild... 
    (docNode.createTextNode('Hiroyuki Mori'));
ownerElement.appendChild(nameElement);

% size node
sizeElement = docNode.createElement('size'); 
docRootNode.appendChild(sizeElement);
widthElement = docNode.createElement('width'); 
widthElement.appendChild... 
    (docNode.createTextNode(info.size.width));
sizeElement.appendChild(widthElement);
heightElement = docNode.createElement('height'); 
heightElement.appendChild... 
    (docNode.createTextNode(info.size.height));
sizeElement.appendChild(heightElement);
depthElement = docNode.createElement('depth'); 
depthElement.appendChild... 
    (docNode.createTextNode(info.size.depth));
sizeElement.appendChild(depthElement);

segmentedElement = docNode.createElement('segmented'); 
segmentedElement.appendChild... 
    (docNode.createTextNode('0'));
docRootNode.appendChild(segmentedElement);

% object node
for i = 1 : length(info.objects)
    objectElement = docNode.createElement('object'); 
    docRootNode.appendChild(objectElement);
    nameElement = docNode.createElement('name'); 
    nameElement.appendChild... 
        (docNode.createTextNode(info.objects{i}.name));
    objectElement.appendChild(nameElement);
    poseElement = docNode.createElement('pose'); 
    poseElement.appendChild... 
        (docNode.createTextNode('Unspecified'));
    objectElement.appendChild(poseElement);
    truncatedElement = docNode.createElement('truncated'); 
    truncatedElement.appendChild... 
        (docNode.createTextNode('0'));
    objectElement.appendChild(truncatedElement);
    difficultElement = docNode.createElement('difficult'); 
    difficultElement.appendChild... 
        (docNode.createTextNode('0'));
    objectElement.appendChild(difficultElement);
    bndboxElement = docNode.createElement('bndbox'); 
    objectElement.appendChild(bndboxElement);
    xminElement = docNode.createElement('xmin'); 
    xminElement.appendChild... 
        (docNode.createTextNode(info.objects{i}.xmin));
    bndboxElement.appendChild(xminElement);
    yminElement = docNode.createElement('ymin'); 
    yminElement.appendChild... 
        (docNode.createTextNode(info.objects{i}.ymin));
    bndboxElement.appendChild(yminElement);
    xmaxElement = docNode.createElement('xmax'); 
    xmaxElement.appendChild... 
        (docNode.createTextNode(info.objects{i}.xmax));
    bndboxElement.appendChild(xmaxElement);
    ymaxElement = docNode.createElement('ymax'); 
    ymaxElement.appendChild... 
        (docNode.createTextNode(info.objects{i}.ymax));
    bndboxElement.appendChild(ymaxElement);
end

xmlwrite(info.path,docNode);

end