
function ImageSegmentation(p,n,DNA,rb1)
k=mfilename('fullpath');
slashPos = find(k=='\');
k=k(1:slashPos(end));
addpath(genpath(k))
clearvars k slashPos
close all hidden
% global n3 p3 DNA
% close all
% clc
% disp('loading images...')
wbim = waitbar(0,'reading images...');
im1 = imread([p n{1}]); %image load
im1 = mat2gray(im1);
waitbar(1/3,wbim,'reading images...');
im2 = imread([p n{2}]);
im2 = mat2gray(im2);
waitbar(2/3,wbim,'reading images...');
if DNA==true
    im3 = imread([p n{3}]);
    im3 = mat2gray(im3);
else 
    im3 = [];
end
waitbar(3/3,wbim,'rendering images for display...');

close(wbim)


[im1,im2,im3] = cropImgFun(im1,im2,im3);

%% creating folder
dirName = n{1}(1:end-4);
mkdir(dirName)
cd(dirName)




close all
%% segmentation of colony
segWB = waitbar(0,'segmenting colony image');
rb1;
minimumSize = 1000;
K1 = bright_seg3(im1,rb1);
K1 = bwareaopen(K1,minimumSize);
waitbar(1/2,segWB,'segmenting pluripotent marker image');
K2 = bright_seg3(im2,1);
K2 = bwareaopen(K2,minimumSize);
if ~isempty(im3); K3 = bright_seg3(im3,1);
waitbar(1,segWB,'segmenting DNA image');
end
close(segWB)

classWB = waitbar(0,'calculating features');
% K1l = bwlabel(K1);
% 
% c =regionprops(K1l,'Eccentricity');
% cecc=zeros(size(c,1),1);
% for i = 1:size(c,1)
%     cecc(i)=c(i).Eccentricity;
% end
% notOK = find(cecc>0.95);
% notOK = unique(notOK,'stable');
% 
% badKL = find(ismember(K1l,notOK));
% K1(badKL)=0;

c =regionprops(im2bw(K1),'Centroid','Area','PixelIdxList','Eccentricity','BoundingBox','PixelList','Perimeter','SubarrayIdx','Image');
B = bwboundaries(im2bw(K1));
carea=zeros(size(c,1),1);ccent = zeros(size(c,1),2); cecc = carea;PixelVal=cell(size(c,1),1);
for i = 1:size(c,1)
    carea(i)=c(i).Area;
    ccent(i,:)=c(i).Centroid;
    cecc(i)=c(i).Eccentricity;
    PixelVal(i)={c(i).PixelIdxList};
end
waitbar(4/4,classWB,'drawing outlines');
close(classWB)
plotOutLines(im1,im2,ccent,B)






%% exporting data
processedData.c=c;
processedData.B=B;
processedData.rb1=rb1;


h=waitbar(0,['saving data... ']);

save('processedData','processedData')
xlswrite('mode of analysis check.xls',rb1);

imwrite(im1,'COLONY IMAGE.tif')
waitbar(1/4,h);
imwrite(im2,'PLURIPOTENT MARKER IMAGE.tif')
waitbar(2/4,h);
imwrite(K1,'COLONY SEGMENTATION IMAGE.tif')
waitbar(3/4,h);
imwrite(K2,'PLURIPOTENT MARKER SEGMENTATION IMAGE.tif')
waitbar(4/4,h);
if ~isempty(im3)
    waitbar(4/4,h,'saving DNA image and segmentations');
    imwrite(im3,'DNA IMAGE.tif')
    imwrite(K3,'DNA SEGMENTATION IMAGE.tif')
end
close(h)
% close all
SegmentationDataSorter
end

%%
function [im1,im2,im3] = cropImgFun(im1,im2,im3)
h=imshow(im1,[]);
choice = questdlg('Do you want to segment everything or choose your own region of interest?', ...
    'crop image', ...
    'Segment everything','Choose my ROI','Segment everything');
% Handle response
switch choice
    case 'Segment everything'
        g=1;
    case 'Choose my ROI'
        g=0;
end

while g==0
    mh=msgbox('Click and drag a box over Region of Interest then double click inside the box! Click "OK" to continue...');
    waitfor(mh)
    [imc,rect] = imcrop(im1);

    figure(1)
    imshow(imc,[])

    drawnow
    choice = questdlg('Is the cropped image area acceptable?', ...
        'cropped image', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            g=1;
            im1 = imc;
            im2 = imcrop(im2,rect);
            if ~isempty(im3);
                im3 = imcrop(im3,rect);
            end
        case 'No'
            figure(1)
            imshow(im1,[])
            drawnow
            
    end
end


end


%%
function plotOutLines(im1,im2,ccent,B)
h = waitbar(0,'Drawing the outlines on colony image');
figure(1)
imshow(im1,[])
hold on
for i=1:size(ccent,1)
    plot(ccent(i,1),ccent(i,2),'b.')
    plot(B{i}(:,2),B{i}(:,1),'r')
    text(ccent(i,1),ccent(i,2),num2str(i),'color','b')
    %     drawnow
end
drawnow
shg
hold off

waitbar(1/2,h,'Drawing the outlines on pluripotent marker image');
figure(2)
imshow(im2,[])
hold on
for i=1:size(ccent,1)
    plot(ccent(i,1),ccent(i,2),'b.')
    plot(B{i}(:,2),B{i}(:,1),'r')
    text(ccent(i,1),ccent(i,2),num2str(i),'color','b')
    %     drawnow
end
drawnow
shg

hold off

waitbar(1,h,'saving images');
figure(1)
[img,map]=getframe;
imwrite(img,'COLONY IMAGE OVERLAID WITH SEGMENTATION OUTLINE.jpg')
figure(2)
[img,map]=getframe;
imwrite(img,'PLURIPOTENT MARKER OVERLAID WITH SEGMENTATION OUTLINE.jpg')
close(h)


end
