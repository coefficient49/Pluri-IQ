% close

if length(plurip)<2
    
else
try
yi =str2num(plurip);
catch
    yi = plurip;
end
wbout = waitbar(0,'saving data...');
yi=reshape(yi,[],1);
yii = str2num([propValues{rrrd(1:i),end}]');
data=data(rrrd(1:i),1:CPi+1);
b=yii;
badData  = find(yi==4);
a=yi;
a(badData,:)=[];
b(badData,:)=[];


accuracy = sum(a==b)/length(b);
waitbar(0.5,wbout,'saving data...')

fDataOut = [data num2cell(yii) num2cell(yi)];
data(badData,:)=[];
fFields = [fields(1:CPi+1) {'Autoscore'} {'Input score'}];
fData = [fFields; fDataOut];
Adx = dir('Validation');
x = length(Adx)+1;
xlswrite(['Validation data_' num2str(x) '.xls'],fData);
waitbar(1,wbout,'saving data...')
close(wbout)
% waitfor(mh)
end
close all

Y=[];
for i = 1:length(a)
    Y=[Y;{num2str(a(i))}];
end

X = cell2mat(data(:,4:CPi));
load TBpath
load(TBpath)

if rb1 ==1
%     load('TB2')
    TBX = TB2.X;
    TBY = TB2.Y;
else
%     load('TB')
    TBX = TB.X;
    TBY = TB.Y;
end

X = [X;TBX];
Y = [Y;TBY];
h=waitbar(0,'Updating Algorithm');
if rb1==0
    TB = TreeBagger(200,X,Y, 'Method', 'classification','oobpred','on','MinLeafSize',1,'OOBVarImp','On');
    k=mfilename('fullpath');
    slashPos = find(k=='\');
    k=k(1:slashPos(end));
    cd(k)
    save(TBpath,'TB')
else
    TB2 = TreeBagger(200,X,Y, 'Method', 'classification','oobpred','on','MinLeafSize',1,'OOBVarImp','On');
    k=mfilename('fullpath');
    slashPos = find(k=='\');
    k=k(1:slashPos(end));
    cd(k)
    save(TBpath,'TB2')
end
close all hidden
% close(h)
mh=msgbox(['Accuracy = ' num2str(accuracy*100) '%']);





