paths = uipickfiles;
h = waitbar(0,'loading images');
for i=1:length(paths)
    waitbar(i/length(paths),h,['loading colony images ' num2str(i) '/' num2str(length(paths))])
    cd(paths{i})
    im1 = imread('COLONY IMAGE.tif');
    waitbar(i/length(paths),h,['loading pluripotency images ' num2str(i) '/' num2str(length(paths))])
    im2 = imread('PLURIPOTENT MARKER IMAGE.tif');
    waitbar(i/length(paths),h,['loading segmentation images ' num2str(i) '/' num2str(length(paths))])
    mask = imread('COLONY SEGMENTATION IMAGE.tif');
    rgb = zeros(size(im1,1),size(im1,2),3);
    waitbar(i/length(paths),h,['making rgb images ' num2str(i) '/' num2str(length(paths))])
    rgb1 = rgb;rgb2=rgb;
    mask1 = bwperim(mask);
    mask1 = imdilate(mask1,strel('disk',3));
    rgb1(:,:,1)=mask1;
    rgb2(:,:,2)=imadjust(mat2gray(im2));
    waitbar(i/length(paths),h,['fusing images ' num2str(i) '/' num2str(length(paths))])
    im1 = imfuse(rgb1,mat2gray(im1),'blend');
    
    im2 = imfuse(rgb1,rgb2,'blend');
    im3 = imfuse(im1,im2,'blend');
    waitbar(i/length(paths),h,['saving images ' num2str(i) '/' num2str(length(paths))])
    imwrite(im1,'im1.tif');
    imwrite(im2,'im2.tif');
    imwrite(im3,'im3.tif');
end

close(h)
    
    