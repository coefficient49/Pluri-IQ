
im2 = mat2gray(im2);
im1 = mat2gray(im1);
% empty matrixes
area=[];centroid=[];bbox=[];eccentricity=[];perimeter=[];
pixelID=[];imageMode=[];imAverage=[];imVar=[];
HEY=[];HEX=[];im2ROI=[];imROI=[];bwROI=[];
circularity=[];ID=[];outline=[];skew=[];bwrat=[]; spread=[];
DNArat=[];periRat=[];midVars=[];

wb2 = waitbar(0,'please wait, data collecting'); 
for ic = 1:length(c)
    waitbar(ic/length(c),wb2,['please wait: cataloging colonies... ' num2str(ic) '/' num2str(length(c))])
    area = [area; {c(ic).Area}];
    centroid = [centroid; {c(ic).Centroid}];
    bbox = [bbox; {c(ic).BoundingBox}];
    eccentricity = [eccentricity; {c(ic).Eccentricity}];
    perimeter = [perimeter; {c(ic).Perimeter}];
    
    circularity = [circularity;{(c(ic).Perimeter^2)/ (4 * pi * c(ic).Area)}];
    pixelID = [pixelID; {c(ic).PixelIdxList}];
    imList=c(ic).PixelIdxList;
    y=c(ic).PixelList(:,2);
    im2List = im2(imList);
    imageMode = [imageMode;{mode(im2List)}];
    midVars = [midVars;{median(im2List(:))}];
    imAverage = [imAverage;{mean(im2List)}];
    imVar = [imVar;{var(im2List)}];
    ROI = c(ic).BoundingBox;
%     idZ = find(ROI==0);
%     ROI(idZ)=1;
%     im2ROIi = im2(ROI(:,2):ROI(:,2)+ROI(:,4),ROI(:,1):ROI(:,1)+ROI(:,3));
    im2ROIi = imcrop(im2,ROI);
%     imROIi = im1(ROI(:,2):ROI(:,2)+ROI(:,4),ROI(:,1):ROI(:,1)+ROI(:,3));
    imROIi = imcrop(im1,ROI);
    BWROIi = c(ic).Image; %mask of cell cytoplasm
%     BW2ROIi = K2(ROI(:,2):ROI(:,2)+ROI(:,4),ROI(:,1):ROI(:,1)+ROI(:,3)); %mask of pluripotent marker
    BW2ROIi = imcrop(K2,ROI);
    
    crop = BW2ROIi; %AP or Oct4...etc
    mask = BWROIi; %cytoplasm
    [sx,sy]=size(mask);
    [si,sj]=size(crop);
    
    
    x = min(sx,si);
    y = min(sy,sj);
    M = mask(1:x,1:y);
    C = crop(1:x,1:y);
    M1 = C.*M;
    M1 =numel(find(M1==1));
    M2 = numel(find(M==1));
    kk=M1/M2;
    
    ctrCyto = regionprops(M,'Centroid');
    ctrAP = regionprops(C,'Centroid','Area');
    CytoPeri = bwperim(M);
    APc = [];APAr=[];
    for disCtr=1:length(ctrAP)
        APc = [APc; ctrAP(disCtr).Centroid];
        APAr = [APAr; ctrAP(disCtr).Area];
    end
    
    if isempty(APc)
        APc = [Inf Inf];
        APAr = [Inf];
    end
    Cytoc = ctrCyto.Centroid;
    distAPC = [APc(:,1)-Cytoc(1),APc(:,2)-Cytoc(2)];
    distAPC = sqrt(distAPC(:,1).^2 + distAPC(:,2).^2);
    [prow,pcol] = find(CytoPeri==1);
    distPeri = [pcol - Cytoc(1),prow-Cytoc(2)];
    distPeri = sqrt(distPeri(:,1).^2 + distPeri(:,2).^2);
    distPeri = mean(distPeri(:));
    tmp = distAPC/distPeri;
    tmp = sum(tmp.*APAr)/sum(APAr);
    periRat = [periRat;{tmp}];
    
    try if DNA==true;
%             BWIM2 = K3(ROI(:,2):ROI(:,2)+ROI(:,4),ROI(:,1):ROI(:,1)+ROI(:,3));
            BWIM2 = imcrop(K3,ROI);
            crop = BW2ROIi;
            mask = BWROIi;
            [sx,sy]=size(mask);
            [si,sj]=size(crop);
            
            x = min(sx,si);
            y = min(sy,sj);
            M = mask(1:x,1:y);
            C = crop(1:x,1:y);
            M1 = C.*M;
            M1 =numel(find(M1==1));
            M2 = numel(find(M==1));
            dr=M1/M2;
            DNArat=[DNArat; {dr}];
        end
    catch end
    bwrat = [bwrat; {kk}];
    [hey,hex]=imhist(im2List,30);
    hey=hey/sum(hey(:));
    skew=[skew;{skewness(im2List)}];
    HEY = [HEY;{hey}];
    HEX = [HEX;{hex}];
    try
        [PKS,LOCS] = findpeaks(hey,hex,'NPeaks',5);
    catch
        [PKS,LOCS] = findpeaks(hey,'NPeaks',5);
        LOCS = hex(LOCS);
    end
    spread = [spread;{var(LOCS)}];
    imROI = [imROI;{imROIi}];
    im2ROI = [im2ROI;{im2ROIi}];
    bwROI = [bwROI;{BWROIi}];
    ID = [ID;{ic}];
    outline = [outline; B(ic)];
end



try
    if DNA==false
        DNArat = num2cell(nan(ic,1));
    elseif isempty(DNA)
        DNArat = num2cell(nan(ic,1));
    end
catch
    DNArat = num2cell(nan(ic,1));
end

fieldNames1 = [{'ID'} {'Area'} {'Perimeter'} {'Circularity'} {'Average'} {'Mode'} {'Medium'} {'Variance'} {'Eccentricity'} {'Skew'} {'Overlap ratio'} {'DNA/Cytoplasm ratio'}  {'Peak Spread'} {'relative distance from center'}];
fieldValues1 = [ID area perimeter circularity imAverage imageMode midVars imVar eccentricity skew bwrat DNArat spread periRat];





fieldNames2 = [{'Phase Image'} {'AP Image'} {'Histogram Y values'} {'Histogram X values'} {'Outlines'} {'Bounding Box'}];
fieldValues2 = [imROI im2ROI HEY HEX outline bbox];

dataOut = [fieldNames1 fieldNames2;fieldValues1 fieldValues2];

load('processedData')
processedData.dataOut = dataOut;
save('processedData','processedData')

close(wb2)
cd ..
close all hidden
PluriIQ