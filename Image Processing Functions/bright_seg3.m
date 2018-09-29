function [bw,bw_sum]= bright_seg3(im,f)
%
% bw_sum = localContrast(im,1,0.07);
% bw = haloRemoval(im,bw_sum,20000,'kirsch',200,0.3);
%
%convert to double double precision

if nargin == 1
    f = 0;
end

if length(size(im))>2
    im = rgb2gray(im);
end
im = mat2gray(double(im));
% im = imadjust(im);
% binEdges = 0:0.001:1;
% bin = discretize(im(:),0:0.001:1);
% phaseTest = binEdges(mode(bin));
% if phaseTest<0.1
%     phaseTest = true;
% else
%     phaseTest = false;
% end

%get lp info using fft
lp = fourierLPfilter(im);
% f = [1 0 2 0 1;0 2 0 2 0;3 0 5 0 3;0 2 0 2 0;1 0 1 0 1];

% lp = imfilter(im,f/26,'replicate');

%normalize background using division
im_mbg = im - lp;


%normalize
im_mbg = mat2gray(im_mbg);

%get the high frequency info using spatial filtering
wSize = 5;
kernel = ones(wSize)*-1;
idp = floor(wSize/2);
kernel(idp,idp) = wSize^2-1;
im_hp = mat2gray(imfilter(im_mbg,kernel,'replicate'));

% get the roughness of the image using range filter, gradient and
% morphological operators
im_range = mat2gray(rangefilt(im_hp));

[dx,dy]=imgradientxy(im_hp);
im_grad = sqrt(dx.^2+dy.^2);

im_erd=imerode(im,strel('disk',3));
im_dil=imdilate(im,strel('disk',3));
im_morph = im_dil - im_erd;

% im_ave = imfilter(im,fspecial('average',5),'replicate');
% im2_ave = imfilter(im.^2,fspecial('average',5),'replicate');
% im_LC = mat2gray(real(sqrt(im2_ave - im_ave.^2)./im_ave));


% binarize the morph, range and grad images using Otsu
th1 = graythresh(im_range);
th2 = graythresh(im_grad);
th3 = graythresh(im_morph);
% th4 = graythresh(im_LC);


bw_sum = im2bw(im_range,th1);
bw_sum = bw_sum +  im2bw(im_grad,th2);
bw_sum = bw_sum +  im2bw(im_morph,th3);
% bw_sum = bw_sum +  im2bw(im_LC,th4);
% bw_sum = imfilter(bw_sum,fspecial('gaussian',3,0.1),'same');
bw = bw_sum>1;
bw = bwdist(bw)<=7;

% bw = imclose(bw,strel('disk',3));

bw = imerode(bw,strel('disk',7));
% exclude=max([50,abs(floor(6e-5*numel(im)))]);
% bw = ~bwareaopen(~bw,exclude);

if f==1 
    bwc = imcomplement(bw);
    bg = mean2(im);
    bgstd = std2(im);
    im2 = im>bg+2*bgstd;
    bwc = bwc.*im2;
    bw = bwc+bw;
     bw = bwareaopen(bw,1000);
    
end
bw_noborder = imclearborder(bw);
bw_borderonly = bw-bw_noborder;
bw_borderonly = bwareaopen(bw_borderonly,70000);
bw = bw_borderonly+bw_noborder;
% bw = bwareaopen(bw,1000);
