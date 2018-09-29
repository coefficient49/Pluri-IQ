ok=false;
while ok==false
    u=uipickfiles;
    RB=[];
    h=waitbar(0,'loading processedData...');
    for i = 1:length(u)
        waitbar(i/length(u),h)
        cd(u{i})
        load('processedData.mat')
        rb1 = processedData.rb1;
        RB = [RB;rb1];
    end
    close(h)
    if length(unique(RB)) == 2
        h=msgbox('Please Compare either Phase or Fluorescent images, not both!');
        waitfor(h)
    else
        ok=true;
    end
    
end


exptName = [];
areaPercP = [];
areaPercD = [];
areaPercM = [];
numPercP = [];
numPercD = [];
numPercM = [];
meanAreaPSC = [];
meanAreaDSC = [];
meanAreaMSC = [];
meanDistRatioPSC =[];
meanDistRatioDSC =[];
meanDistRatioMSC =[];
meanDNARatioPSC = [];
meanDNARatioDSC = [];
meanDNARatioMSC = [];
meanCircularityPSC =[];
meanCircularityDSC = [];
meanCircularityMSC = [];

stdAreaPSC = [];
stdAreaDSC = [];
stdAreaMSC = [];
stdDNARatioPSC = [];
stdDNARatioDSC = [];
stdDNARatioMSC = [];
stdCircularityPSC =[];
stdCircularityDSC = [];
stdCircularityMSC = [];

close all hidden
wb=waitbar(0,'Comparing data');

for i = 1:length(u)
    waitbar(i/length(u),wb)
    cd(u{i});
    waitbar(i/length(u),wb,'calculating.')
    load processedData
    load tDataOut
    field = tDataOut(1,[2:14,21]);
    data =  tDataOut(2:end,[2:14,21]);
    Area = cell2mat(data(:,find(strcmpi('Area',field))));
    Score = str2num(cell2mat(data(:,end)));
    DistRatio = cell2mat(data(:,find(strcmpi('relative distance from center',field))));
    DNARatio = cell2mat(data(:,find(strcmpi('DNA/Cytoplasm ratio',field))));
    circulaity = cell2mat(data(:,find(strcmpi('Circularity',field))));
    
    
    PSC = find(Score==3);
    DSC = find(Score==1);
    MSC = find(Score==2);
    
    
    numPSC = length(PSC)/length(Score)*100;
    numDSC = length(DSC)/length(Score)*100;
    numMSC = length(MSC)/length(Score)*100;
    
    
    Parea = nansum(Area(PSC));
    Darea = nansum(Area(DSC));
    Marea = nansum(Area(MSC));
    
    
    areaPercPSC = Parea/(Parea+Darea+Marea)*100;
    areaPercDSC = Darea/(Parea+Darea+Marea)*100;
    areaPercMSC = Marea/(Parea+Darea+Marea)*100;
    
    
    DistRatioPSC = nanmean(DistRatio(PSC));
    DistRatioDSC = nanmean(DistRatio(DSC));
    DistRatioMSC = nanmean(DistRatio(MSC));
    
    waitbar(i/length(u),wb,'calculating..')
    DNARatioPSC =  nanmean(DNARatio(PSC));
    DNARatioDSC =  nanmean(DNARatio(DSC));
    DNARatioMSC =  nanmean(DNARatio(MSC));
    
    
    circulaityPSC = nanmean(circulaity(PSC));
    circulaityMSC = nanmean(circulaity(MSC));
    circulaityDSC = nanmean(circulaity(DSC));
    
    
    fullDirPath = u{i};
    slashesPos = find(fullDirPath=='\');
    expt = fullDirPath(slashesPos(end)+1:end);
    
    waitbar(i/length(u),wb,'calculating...')
    exptName = [exptName; {expt}];
    areaPercP = [areaPercP; {areaPercPSC}];
    areaPercD = [areaPercD; {areaPercDSC}];
    areaPercM = [areaPercM; {areaPercMSC}];
    
    numPercP = [numPercP; {numPSC}];
    numPercD = [numPercD; {numDSC}];
    numPercM = [numPercM; {numMSC}];
    
    meanAreaPSC = [meanAreaPSC; {nanmean(Area(PSC))}];
    meanAreaDSC = [meanAreaDSC; {nanmean(Area(DSC))}];
    meanAreaMSC = [meanAreaMSC; {nanmean(Area(MSC))}];

    
    meanDNARatioPSC = [meanDNARatioPSC; {DNARatioPSC}];
    meanDNARatioDSC = [meanDNARatioDSC; {DNARatioDSC}];
    meanDNARatioMSC = [meanDNARatioMSC; {DNARatioMSC}];
    
    
    meanCircularityPSC = [meanCircularityPSC; {circulaityPSC}];
    meanCircularityDSC = [meanCircularityDSC; {circulaityDSC}];
    meanCircularityMSC = [meanCircularityMSC; {circulaityMSC}];

    
    nPSC = sqrt(length(PSC));
    nDSC = sqrt(length(DSC));
    nMSC = sqrt(length(MSC));

    
    DNARatioPSC =  nanstd(DNARatio(PSC))/nPSC;
    DNARatioDSC =  nanstd(DNARatio(DSC))/nDSC;
    DNARatioMSC =  nanstd(DNARatio(MSC))/nMSC;
    
    
    stdcirculaityPSC = nanstd(circulaity(PSC))/nPSC;
    stdcirculaityMSC = nanstd(circulaity(MSC))/nDSC;
    stdcirculaityDSC = nanstd(circulaity(DSC))/nMSC;
   waitbar(i/length(u),wb,'calculating....')
    
    stdAreaPSC = [stdAreaPSC; {nanstd(Area(PSC))/nPSC}];
    stdAreaDSC = [stdAreaDSC; {nanstd(Area(DSC))/nDSC}];
    stdAreaMSC = [stdAreaMSC; {nanstd(Area(MSC))/nMSC}];
    

    stdDNARatioPSC = [stdDNARatioPSC; {DNARatioPSC}];
    stdDNARatioDSC = [stdDNARatioDSC; {DNARatioDSC}];
    stdDNARatioMSC = [stdDNARatioMSC; {DNARatioMSC}];
    
    
    stdCircularityPSC = [stdCircularityPSC; {stdcirculaityPSC}];
    stdCircularityDSC = [stdCircularityDSC; {stdcirculaityDSC}];
    stdCircularityMSC = [stdCircularityMSC; {stdcirculaityMSC}];
    
   waitbar(i/length(u),wb,'calculating.....')
    
end
close all hidden
%%
h = waitbar(0,'Generating excel spreadsheet');
newFields = [{'Experiment Name'} {'% of Pluripotency (# of Colonies)'} {'% of Mixed (# of Colonies)'} {'% of Differentiated (# of Colonies)'} ...
    {'% of Pluripotency (area)'} {'% of Mixed (area)'} {'% of Differentiated (area)'} {'mean Area of P.S.Cells'} {'mean Area of M.S.Cells'}...
    {'mean Area of D. S. Cells'} {'mean DNA/Cytoplasm ratio P.S.Cells'} {'mean DNA/Cytoplasm ratio M.S.Cells'} {'mean DNA/Cytoplasm ratio D.S.Cells'} {'mean Circularity P.S.Cells'} {'mean Circularity M.S.Cells'} {'mean Circularity D.S.Cells'}...
    {'SEM Area of P.S.Cells'} {'SEM Area of M.S.Cells'} {'SEM Area of D. S. Cells'}...
     {'SEM DNA/Cytoplasm ratio P.S.Cells'} {'SEM DNA/Cytoplasm ratio M.S.Cells'} {'SEM DNA/Cytoplasm ratio D.S.Cells'} ...
     {'SEM Circularity P.S.Cells'} {'SEM Circularity M.S.Cells'} {'SEM Circularity D.S.Cells'}];
dataComp = [exptName numPercP numPercM numPercD  areaPercP areaPercM areaPercD meanAreaPSC meanAreaMSC...
    meanAreaDSC meanDNARatioPSC meanDNARatioMSC  meanDNARatioDSC meanCircularityPSC meanCircularityMSC meanCircularityDSC...
    stdAreaPSC stdAreaMSC...
    stdAreaDSC stdDNARatioPSC stdDNARatioMSC  stdDNARatioDSC stdCircularityPSC stdCircularityMSC stdCircularityDSC];
%%
waitbar(1/10,h,'Saving spreadsheet');

dataXLS = [newFields;dataComp];

[FileName,PathName] = uiputfile('*.xls');
xlswrite([PathName,FileName],dataXLS)
figure,bar(cell2mat(numPercP))
title('% Pluripotency by # of Colonies')
set(gca,'XTickLabel',[exptName],'XTickLabelRotation',20)
%%
waitbar(6/10,h,'creating diagrams.');
figure,bar(cell2mat(areaPercP))
title('% Pluripotency by Area of Colonies')
set(gca,'XTickLabel',[exptName],'XTickLabelRotation',20)

waitbar(7/10,h,'creating diagrams.');
figure, bar([cell2mat(meanAreaPSC) cell2mat(meanAreaMSC) cell2mat(meanAreaDSC)]);
title('Mean Area')
set(gca,'XTickLabel',[exptName],'XTickLabelRotation',20)
legend('Pluripotent','Differentiated')

waitbar(8/10,h,'creating diagrams.');
figure, bar([cell2mat(meanCircularityPSC) cell2mat(meanCircularityMSC) cell2mat(meanCircularityDSC)]);
title('Mean Circularity')
set(gca,'XTickLabel',[exptName],'XTickLabelRotation',20)
legend('Pluripotent','Mixed','Differentiated')

waitbar(9/10,h,'creating diagrams.');
figure, bar([cell2mat(meanDNARatioPSC) cell2mat(meanDNARatioMSC) cell2mat(meanDNARatioDSC)]);
title('Mean DNA to Cytoplasm Ratio')
set(gca,'XTickLabel',[exptName],'XTickLabelRotation',20)
legend('Pluripotent','Mixed','Differentiated')

waitbar(1,h,'creating diagrams.');
close(h)

PluriIQ