function trainer
p=cd;
ok=false;
while ok==false
    close all hidden
    mh=msgbox('Select all the folders with data to analyze...');
    waitfor(mh);
    
    p = uipickfiles;
    
    iD = [];
    
    
    wb1 = waitbar(0,'loading data...');
    for i = 1:length(p)
        
        waitbar(i/length(p),wb1)
        subfolder = p{i};
        
        load([subfolder '\processedData.mat'])
        fields = processedData.dataOut(1,:);
        iD(i).data = processedData.dataOut(2:end,:);
        iD(i).c=processedData.c;
        iD(i).B=processedData.B;
        %         iD(i).K2=processedData.K2;
        iD(i).rb1 = processedData.rb1;
        %         iD(i).im2 = imread([subfolder '\PLURIPOTENT MARKER IMAGE.tif']);
        %         iD(i).im1 = imread([subfolder '\COLONY IMAGE.tif']);
        iD(i).pluri =[];
        iD(i).dif =[];
        iD(i).mix =[];
        rb1=iD(i).rb1;
        
    end
    close(wb1)
    
    RB=zeros(length(p),1);
    
    for i=1:length(p)
        RB(i) = iD(i).rb1;
    end
    length(unique(RB))
    if length(unique(RB))==2
        gh=msgbox('You have selected PHASE and IMMUNOFLUORESCENT images, please train one at a time.','color','red');
        waitfor(gh)
        close all hidden
        break
    else
        ok=true;
    end
    
end


iD=iniScoring(iD,p,rb1);


CPn=find(ismember(processedData.dataOut(1,:),'Phase Image'));
CPi=find(ismember(processedData.dataOut(1,:),'Peak Spread'));
calcValues = [];propValues=[];score=[];
h = waitbar(0,'Sorting the scoring data');
for i = 1:length(p)
    waitbar(i/length(p),h)
    pluri=iD(i).pluri;
    dif = iD(i).dif;
    if isempty(iD(i).mix)
        mix=[];
    else
        mix=iD(i).mix;
    end
    calcValues = [calcValues; iD(i).data([pluri;dif;mix],4:CPi)];
    propValues = [propValues; iD(i).data([pluri;dif;mix],CPn:end)];
    s = [ones(length(pluri),1).*3;ones(length(dif),1).*1;ones(length(mix),1).*2];
    score = [score;s];
end
close(h)
vName=fields(4:CPi);
close all
wbtb=waitbar(0,'Constructing Random Forest Algorithm...');

Y = score;

X = cell2mat(calcValues);

choice = questdlg('Do you want to replace the existing trained data, add to the exiting trained data?', ...
    'Training options', ...
    'New Training Set','Add to Existing','Add to Existing');
% Handle response
switch choice
    case 'New Training Set'
        [name,path] = uiputfile('*.mat','Save as');
    case 'Add to Existing'
        load TBpath
        sl=find(TBpath=='\');
        cd(TBpath(1:sl(end)))
        if rb1==0
            [name,path]=uigetfile('*.mat');
            load([path,name])
            X2 = TB.X;
            Y2 = str2num(cell2mat(TB.Y));
        else
            
            [name,path]=uigetfile('*.mat');
            load([path,name])
            X2 =TB2.X;
            Y2 = str2num(cell2mat(TB2.Y));
        end
        
        X = [X2;X];
        Y = [Y2;Y];
        
end


if rb1==0
    TB = TreeBagger(200,X,Y, 'Method', 'classification','oobpred','on','MinLeafSize',1,'OOBVarImp','On','PredictorNames',vName);
    save([path name],'TB')
    close(wbtb)
else
    TB2 = TreeBagger(200,X,Y, 'Method', 'classification','oobpred','on','MinLeafSize',1,'OOBVarImp','On','PredictorNames',vName);
    save([path name],'TB2')
    close(wbtb)
    TB=TB2;
end
TBpath = [path name];
k=mfilename('fullpath');
slashPos = find(k=='\');
k=k(1:slashPos(end));
k = [k '\GUI functions\'];
save([k 'TBpath.mat'],'TBpath')
% cd(TBpath(1:sl(end)))
% nnprimer

output(p,iD,CPi,CPn,rb1,TBpath)


close all hidden
mh=msgbox('done');
waitfor(mh);
PluriIQ
end

%% local functions


function iD=iniScoring(iD,p,rb1)


for i = 1:length(p)
    B=iD(i).B;
    close all
    h = waitbar(0,'loading image');
    im2 = imread([p{i} '\PLURIPOTENT MARKER IMAGE.tif']);
    waitbar(1/3,h,'loading image');
    figure(6);
    K2 = imread([p{i} '\COLONY SEGMENTATION IMAGE.tif']);
    waitbar(2/3,h,'loading image');
    K2 = bwlabeln(K2);
    waitbar(3/3,h,'loading image');
    close(h)
    rgb = zeros(size(im2,1),size(im2,2),3);
    rgb(:,:,2)=imadjust(mat2gray(im2));
    figure(44),imshow(rgb,[])
    set(gcf,'units','normalized','position',[0 0 1 1])
    hold on
    for j = 1:length(B)
        plot(B{j}(:,2),B{j}(:,1),'r')
    end
    hold off
    for z= 1:3
        figure(44)
        if z == 1
            msss = ['select the pluripotent colonies then press enter'];
            mh=msgbox(msss);
            waitfor(mh);
        elseif z == 2
%             if rb1 ==1
                msss = ['select the mixed colonies then press enter'];
                mh=msgbox(msss);
                waitfor(mh);
%             end
        elseif z==3
            msss = ['select the differentiated colonies then press enter'];
            mh=msgbox(msss);
            waitfor(mh);
        end
        
        
        if z==1
            [pos1,pos2] = ginputc('color', 'b', 'linewidth', 1,'ShowPoints', true,'ConnectPoints',false);
        elseif z==2
%             if rb1 ==1
                [pos1,pos2] = ginputc('color', 'y', 'linewidth', 1,'ShowPoints', true,'ConnectPoints',false);
%             end
        elseif z==3
            [pos1,pos2] = ginputc('color', 'r', 'linewidth', 1,'ShowPoints', true,'ConnectPoints',false);
        end
        
        
        
        pos = K2(sub2ind(size(K2),round(pos2),round(pos1)));
        if z==1
            tmp=find(pos<=0);
            pos(tmp)=[];
            iD(i).pluri =pos;
        elseif z==2
            tmp=find(pos<=0);
            pos(tmp)=[];
            iD(i).mix =pos;
        elseif z==3
            tmp=find(pos<=0);
            pos(tmp)=[];
            iD(i).dif =pos;
        end
    end
    
    
    
end
end

%%


function output(p,iD,CPi,CPn,rb1,TBpath)
load(TBpath)
wb1 = waitbar(0,'calculating data...');
for i = 1:length(p)
    waitbar(i/length(p),wb1)
    subfolder = p{i};
    K2 = imread([p{i} '\COLONY SEGMENTATION IMAGE.tif']);
    load([subfolder '\processedData.mat'])
    dataOut=processedData.dataOut;
    c=iD(i).c;
    %     im2 = iD(i).im2;
    TBP = cell2mat(dataOut(2:end,4:CPi));
    if rb1 ==0
        score=TB.predict(TBP);
        
    else
        score=TB2.predict(TBP);
    end
    scoreData = ['Score'; score];
    tDataOut = [dataOut scoreData];
    processedData.tDataOut=tDataOut;
    save([subfolder '\processedData.mat'],'processedData')
    x=dir([subfolder '\allDataOut*']);
    save([subfolder '\tDataOut.mat'],'tDataOut')
    s = length(x) + 1;
    xlswrite([subfolder '\allDataOut_' num2str(s) '.xls'],tDataOut(:,[1:CPn-1, end]));
    score = str2num(cell2mat(score));
    blank = zeros(size(K2));
    wb2 = waitbar(0,'mapping');
    for j = 1:length(c)
        waitbar(j/length(c),wb2)
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
    
    imwrite(bl,[subfolder '\Color Map Showing Distribution of Colonies.tif'])
    close(wb2)
end
end