function behavior_xmlwrite_bs(info)

docNode = com.mathworks.xml.XMLUtils.createDocument ... 
    ('annotation');
docRootNode = docNode.getDocumentElement;

% owner node
ownerElement = docNode.createElement('owner'); 
docRootNode.appendChild(ownerElement);
% flickridElement = docNode.createElement('flickrid'); 
% flickridElement.appendChild... 
%     (docNode.createTextNode('hiromori2'));
% ownerElement.appendChild(flickridElement);
nameElement = docNode.createElement('name'); 
nameElement.appendChild... 
    (docNode.createTextNode('basic'));
ownerElement.appendChild(nameElement);

% folderElement = docNode.createElement('folder'); 
% folderElement.appendChild... 
%     (docNode.createTextNode('VOC2007'));
% docRootNode.appendChild(folderElement);

filenameElement = docNode.createElement('filename'); 
filenameElement.appendChild... 
    (docNode.createTextNode(info.filename));
docRootNode.appendChild(filenameElement);

% % source node
% sourceElement = docNode.createElement('source'); 
% docRootNode.appendChild(sourceElement);
% databaseElement = docNode.createElement('database'); 
% databaseElement.appendChild... 
%     (docNode.createTextNode('The VOC2007 Database'));
% sourceElement.appendChild(databaseElement);
% annotationElement = docNode.createElement('annotation'); 
% annotationElement.appendChild... 
%     (docNode.createTextNode('PASCAL VOC2007'));
% sourceElement.appendChild(annotationElement);
% imageElement = docNode.createElement('image'); 
% imageElement.appendChild... 
%     (docNode.createTextNode('flickr'));
% sourceElement.appendChild(imageElement);
% flickridElement = docNode.createElement('flickrid'); 
% flickridElement.appendChild... 
%     (docNode.createTextNode('329145082'));
% sourceElement.appendChild(flickridElement);

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
% depthElement = docNode.createElement('depth'); 
% depthElement.appendChild... 
%     (docNode.createTextNode(info.size.depth));
% sizeElement.appendChild(depthElement);

% segmentedElement = docNode.createElement('segmented'); 
% segmentedElement.appendChild... 
%     (docNode.createTextNode('0'));
% docRootNode.appendChild(segmentedElement);

% object node
for i = 1 : length(info.objects)
    objectElement = docNode.createElement('object'); 
    docRootNode.appendChild(objectElement);
    typeElement = docNode.createElement('type'); 
    typeElement.appendChild... 
        (docNode.createTextNode('rect'));
    objectElement.appendChild(typeElement);
    nameElement = docNode.createElement('name'); 
    nameElement.appendChild... 
        (docNode.createTextNode(info.objects{i}.name));
    objectElement.appendChild(nameElement);
    textElement = docNode.createElement('text'); 
    textElement.appendChild... 
        (docNode.createTextNode(' '));
    objectElement.appendChild(textElement);
    strokeWidthElement = docNode.createElement('strokeWidth'); 
    strokeWidthElement.appendChild... 
        (docNode.createTextNode('1'));
    objectElement.appendChild(strokeWidthElement);
%     difficultElement = docNode.createElement('difficult'); 
%     difficultElement.appendChild... 
%         (docNode.createTextNode('0'));
%     objectElement.appendChild(difficultElement);
    pointsElement = docNode.createElement('points'); 
    objectElement.appendChild(pointsElement);
    points0Element = docNode.createElement('points0'); 
    pointsElement.appendChild(points0Element);
    xElement = docNode.createElement('x'); 
    xElement.appendChild... 
        (docNode.createTextNode(info.objects{i}.x0));
    points0Element.appendChild(xElement);
    yElement = docNode.createElement('y'); 
    yElement.appendChild... 
        (docNode.createTextNode(info.objects{i}.y0));
    points0Element.appendChild(yElement);
    points1Element = docNode.createElement('points1'); 
    pointsElement.appendChild(points1Element);
    xElement = docNode.createElement('x'); 
    xElement.appendChild... 
        (docNode.createTextNode(info.objects{i}.x1));
    points1Element.appendChild(xElement);
    yElement = docNode.createElement('y'); 
    yElement.appendChild... 
        (docNode.createTextNode(info.objects{i}.y1));
    points1Element.appendChild(yElement);
    points2Element = docNode.createElement('points2'); 
    pointsElement.appendChild(points2Element);
    xElement = docNode.createElement('x'); 
    xElement.appendChild... 
        (docNode.createTextNode(info.objects{i}.x2));
    points2Element.appendChild(xElement);
    yElement = docNode.createElement('y'); 
    yElement.appendChild... 
        (docNode.createTextNode(info.objects{i}.y2));
    points2Element.appendChild(yElement);
    points3Element = docNode.createElement('points3'); 
    pointsElement.appendChild(points3Element);
    xElement = docNode.createElement('x'); 
    xElement.appendChild... 
        (docNode.createTextNode(info.objects{i}.x3));
    points3Element.appendChild(xElement);
    yElement = docNode.createElement('y'); 
    yElement.appendChild... 
        (docNode.createTextNode(info.objects{i}.y3));
    points3Element.appendChild(yElement);
    angleElement = docNode.createElement('angle'); 
    angleElement.appendChild... 
        (docNode.createTextNode('0'));
    objectElement.appendChild(angleElement);
end

xmlwrite(info.path,docNode);

end