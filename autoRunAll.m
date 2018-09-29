close all hidden
mh=msgbox('Select all the folders with data to analyze...');
waitfor(mh);


k=mfilename('fullpath');
slashPos = find(k=='\');
k=k(1:slashPos(end));
addpath(genpath(k))
clearvars k slashPos
p = uipickfiles;
% load('TB.mat')
load('TBpath')
load(TBpath)
iD = [];
wb1 = waitbar(0,'checking data...');
for i = 1:length(p)
    waitbar(i/length(p),wb1)
    subfolder = p{i};
    
%     
%     fields = processedData.dataOut(1,:);
    iD(i).rb1 = importdata([subfolder '\mode of analysis check.xls']);
    cd ..
    if iD(i).rb1==0 & exist('TB')
    elseif iD(i).rb1 & exist('TB2')
    else
        h=msgbox('You have loaded the wrong algorithm for these images');
        waitfor(h)
        close all hiddens
        guiV1
        return
    end
end
close(wb1)


wb1 = waitbar(0,'loading data...');
load([subfolder '\processedData.mat'])
fields = processedData.dataOut(1,:);
CPn=find(ismember(processedData.dataOut(1,:),'Phase Image'));
CPi=find(ismember(processedData.dataOut(1,:),'Peak Spread'));
rb1 = processedData.rb1;



for i = 1:length(p)
    clearvars -except p i wb1 rb1 CPi CPn fields TB TB2
    waitbar(i/length(p),wb1)
    subfolder = p{i};
    load([subfolder '\processedData.mat'])
    
    dataOut = processedData.dataOut(2:end,:);
    im2 = imread([subfolder '\PLURIPOTENT MARKER IMAGE.tif']);
    c = processedData.c;
    calcValues = dataOut(1:end,4:CPi);
    X = cell2mat(calcValues);
    waitbar(i/length(p),wb1,'Calculating...')
    if rb1 ==0
        score=TB.predict(X);
    else
        score=TB2.predict(X);
    end
    
    scoreData = ['Score'; score];
    dataOut = [fields; dataOut];
    tDataOut = [dataOut scoreData];
    processedData.tDataOut = tDataOut;
    waitbar(i/length(p),wb1,'Saving...')
    save([subfolder '\tDataOut.mat'],'tDataOut')
    save([subfolder '\processedData'],'processedData')
    x=dir([subfolder '\allDataOut*']);
    s = length(x) + 1;
    xlswrite([subfolder '\allDataOut_' num2str(s) '.xls'],tDataOut(:,[1:CPn-1, end]));
    score = str2num(cell2mat(score));
    blank = zeros(size(im2));
    waitbar(i/length(p),wb1,'creating colormap...')
    for j = 1:length(c)
        pos = sub2ind(size(blank),c(j).PixelList(:,2),c(j).PixelList(:,1));
        blank(pos)=score(j);
    end
    
    ch1 = zeros(size(blank));
    ch2 = zeros(size(blank));
    ch3 = zeros(size(blank));
    
    red = find(blank==1);
    green = find(blank==2);
    blue = find(blank==3);
    
    bl=zeros(size(blank,1),size(blank,2),3);
    ch1(red)=1;
    ch2(green)=1;
    ch3(blue)=1;
    bl(:,:,1)=ch1;
    bl(:,:,2)=ch3;
    bl(:,:,3)=ch2;
    %     setFullScreen
    
    imwrite(bl,[subfolder '\Color Map Showing Distribution of Colonies.jpg'])

    
end
close(wb1)


PluriIQ