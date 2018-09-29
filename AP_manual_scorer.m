try
    load('processedData')
    tDataOut= processedData.tDataOut;
    B=processedData.B;
    rb1=processedData.rb1;
    im2 = imread('PLURIPOTENT MARKER IMAGE.tif');
catch
    h=msgbox('please analyze the image before validation, i.e. run "Auto Scoring" or "Training System" ','error');
    waitfor(h)
    
    PluriIQ
    return
end
% if rb1==0
%     set(handles.pushbutton7,'String','-')
% elseif rb1==1
    set(handles.pushbutton7,'String','Mixed')
% end
inData = tDataOut;
fields = tDataOut(1,:);
data = tDataOut(2:end,:);
CPn=find(ismember(tDataOut(1,:),'Phase Image'));
CPi=find(ismember(tDataOut(1,:),'Peak Spread'));
% sortedData = flipud(sortrows(sortData,where));
calcValues = tDataOut(2:end,4:CPi);
calcFields = fields(4:CPi);
propValues = tDataOut(2:end,CPn:end);
propFields = fields(CPn:end);
plurip=[];
r = 1:length(propValues);
i=1;
sam=str2num([propValues{:,end}]');
sam = find(sam==3);
figure(6)
E=imshow(im2,[]);
rrrd = randperm(length(propValues));
while i ~= length(rrrd)+1
    try
        delete(hh)
    end
    id = rrrd(i);
    figure(5)
    bbox=floor(propValues{id,6});
    subplot(2,2,1)
    
    imshow(propValues{id,1},[])
    title('Cell Cytoplasm/Phase image')
    hold on
    plot(propValues{id,5}(:,2)-bbox(1),propValues{id,5}(:,1)-bbox(2),'r')
    hold off
    subplot(2,2,2)
     img = zeros(size(propValues{id,2},1),size(propValues{id,2},2),3);
     img(:,:,2)  = [imadjust(mat2gray(propValues{id,2}))];
    imshow(img,[])
    title('Pluripotent marker image (artificial green color)')
    hold on
    plot(propValues{id,5}(:,2)-bbox(1),propValues{id,5}(:,1)-bbox(2), 'r')
    hold off
    subplot(4,2,7)
    plot(propValues{id,4},propValues{id,3})
    subplot(6,2,7)
    barh(1,'g')
    hold on
    barh(i/length(propValues))
    axis([0 1 0 2])
    hold off
    xlabel(['progress: ' num2str(i) '/' num2str(length(propValues))])
    %     propValues{i,end}
    try
        if str2num(propValues{id,end})==3
            title('Predicted: Pluripotent')
        elseif str2num(propValues{id,end})==1
            title('Predicted: Differentiated')
        elseif  str2num(propValues{id,end})==2
            title('Predicted: Mixed')
        end
    catch
        title([num2str(cell2mat(propValues{id,end}))])
    end
    subplot(2,2,4)
    aV = [calcValues{sam,7}];
    id2 = find(aV==min(aV));

    img = zeros(size(propValues{sam(id2),2},1),size(propValues{sam(id2),2},2),3);
    img(:,:,2)  = [imadjust(propValues{sam(id2),2})];
    imshow(img,[])
    hold on
    bbox=floor(propValues{sam(id2),6});
    plot(propValues{sam(id2),5}(:,2)-bbox(1),propValues{sam(id2),5}(:,1)-bbox(2), 'm')
    hold off
    title('Sample of a pluripotent image (artificial green color)')
    
    
    figure(6)
    hold on
    hh=plot(B{id}(:,2),B{id}(:,1),'r');
    hh2=plot(B{sam(id2)}(:,2),B{sam(id2)}(:,1),'m');
    hold off
    
    uiwait(manualGui)
    
    s = get(handles.text2,'String');
    if strcmpi(s,'back')
        if i ==1
            disp('You are at the first image!!')
        else
            i=i-1;
        end
    elseif strcmpi(s,'out')
       
        break
    else
        v = str2num(sscanf(s,'%s'));
        if isempty(v)
            v=str2num(propValues{id,end});
            try
                plurip(i)=v;
            catch
                plurip = [plurip;v];
            end
            i = i+1;
        else
            try
                plurip(i)=v;
            catch
                plurip = [plurip;v];
            end
            i = i+1;
        end
    end
    
    
    
end
i=i-1;
outProtocol




