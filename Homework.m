function varargout = Homework(varargin)
% HOMEWORK MATLAB code for Homework.fig
%      HOMEWORK, by itself, creates a new HOMEWORK or raises the existing
%      singleton*.
%
%      H = HOMEWORK returns the handle to a new HOMEWORK or the handle to
%      the existing singleton*.
%
%      HOMEWORK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOMEWORK.M with the given input arguments.
%
%      HOMEWORK('Property','Value',...) creates a new HOMEWORK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Homework_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Homework_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Homework

% Last Modified by GUIDE v2.5 10-Jan-2018 23:17:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Homework_OpeningFcn, ...
                   'gui_OutputFcn',  @Homework_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Homework is made visible.
function Homework_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Homework (see VARARGIN)

% Choose default command line output for Homework
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Homework wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Homework_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1) ; 
cla reset
axes(handles.axes2) ; 
cla reset
axes(handles.axes3) ; 
cla reset
axes(handles.axes4) ; 
cla reset
%*********************************************讀取圖片*********************************************

[handles.filename,pathname]=uigetfile({'*.*';'*.bmp';'*.tif';'*.png';'*.jpg'},'選擇圖片'); %讀取圖片檔案
if isequal(handles.filename,0)
   disp('User selected Cancel');
else
   disp(['User selected', fullfile(pathname, handles.filename)]);
   a = [pathname, handles.filename];
end
Orimage=imread(a);  
coverimage=Orimage; %讀取圖像
axes(handles.axes1);
imshow(coverimage);
coverimage=double(coverimage);%為了計算像素，將unit8轉成double

[x,y]=size(coverimage);
stegoimage=coverimage;
%***************************************************************************************************


axes(handles.axes2);
histogram(coverimage); %顯示此圖historgram


%紀錄0-255的各自數量，以整張圖的hist來看，原始圖像的histogram
histcount=zeros(1,256);%產生1維256格陣列 
for j=1:y
    for i=1:x
        s=coverimage(j,i); 
        histcount(s+1)=histcount(s+1)+1;%因為數值是介於0~255  記錄在1~256上面，所以做+1動作
    end
end

%選擇最高出現的為peakvalue
[,cols]=find(histcount==max(histcount));
peakvalue=cols-1;%找到peakvalue後，選擇左端或右端進行左移.右移

%把stegoimage內所有大於peakvalue的數值做+1動作
for i=1:x
    for j=1:y
        if stegoimage(i,j) > peakvalue
              stegoimage(i,j)=stegoimage(i,j)+1;
        end
    end
end

%判定整張圖改變前後historgram的差別，將數值空出來以便藏匿
histcount2=zeros(1,256);

for j=1:y
for i=1:x
   s=stegoimage(j,i); 
   histcount2(s+1)=histcount2(s+1)+1;%因為數值是介於0~255  記錄在1~256上面，所以做+1動作
end
end
%判定可藏匿的最大數值為多少，產生隨機的0和1
secretlongs=histcount(1,cols)+histcount(1,cols+1);%可產生5447個0.1

secretmessagebits=zeros(1,1000);
for i=1:secretlongs
secretmessage= randsrc(1,1,0:1) ;%隨機產生0.1亂數進行藏匿
 secretmessagebits(i)=secretmessage;
end


%stegoimage2=stegoimage;%比較藏匿前和藏匿後的圖
%將seretbits藏入stegoimage中，遇到155的數值判定secret為0或1,若為0不動若為1則做155+1的動作
t=1;
for j=1:y
for i=1:x
    if stegoimage(j,i)==(peakvalue) 
        if  secretmessagebits(t)==1
         stegoimage(j,i)= stegoimage(j,i)+1;
        end
         t=t+1;
    end
end
end

recoverimage=stegoimage;


%提取藏在stegoimage內的secretmessage
t=1;
extractseceretmessagebits=zeros(1,256);
for j=1:y
    for i=1:x
        if recoverimage(j,i)==peakvalue
             extractseceretmessagebits(t)=0;
             t=t+1;
        end
         if recoverimage(j,i)==peakvalue+1
             extractseceretmessagebits(t)=1;
             t=t+1;
        end          
    end
end

%還原原始的圖像，當數值>peakvalue，就-1
for j=1:y
    for i=1:x
        if recoverimage(j,i)>peakvalue
            recoverimage(j,i)=recoverimage(j,i)-1;
        end      
    end
end

%*********************顯示histogram才有的資訊*********************
axes(handles.axes4);
histogram(stegoimage);%顯示藏匿後圖像的histogram
set(handles.PK,'String',peakvalue);
%****************************************************************


%***********************顯示藏匿後資訊****************************

%計算PSNR,MSE，計算4*4block基準
sum=0;
for i=1:x
    for j=1:y
sum=(coverimage(j,i)-stegoimage(j,i))^2+sum;
    end
end
MSE=sum/262144;
PSNR= 10*log10(255^2/MSE);
set(handles.MSE,'String',MSE);%秀出MSE的數值
set(handles.PSNR,'String',PSNR);%秀出PSNR數值

stegoimage =uint8(stegoimage);%呈現圖片，從double轉回unit8 bit
axes(handles.axes3);
imshow(stegoimage);
imwrite(stegoimage,'stegohistogram.png');

%***********************顯示秘密訊息****************************

set(handles.h1,'String',secretmessagebits(1));
set(handles.h2,'String',secretmessagebits(12));
set(handles.h3,'String',secretmessagebits(51));
set(handles.h4,'String',secretmessagebits(67));
set(handles.h5,'String',secretmessagebits(210));
set(handles.h6,'String',secretmessagebits(350));
set(handles.h7,'String',secretmessagebits(500));
set(handles.h8,'String',secretmessagebits(814));
set(handles.h9,'String',secretmessagebits(1024));
set(handles.h10,'String',secretmessagebits(2250));

set(handles.g1,'String',extractseceretmessagebits(1));
set(handles.g2,'String',extractseceretmessagebits(12));
set(handles.g3,'String',extractseceretmessagebits(51));
set(handles.g4,'String',extractseceretmessagebits(67));
set(handles.g5,'String',extractseceretmessagebits(210));
set(handles.g6,'String',extractseceretmessagebits(350));
set(handles.g7,'String',extractseceretmessagebits(500));
set(handles.g8,'String',extractseceretmessagebits(814));
set(handles.g9,'String',extractseceretmessagebits(1024));
set(handles.g10,'String',extractseceretmessagebits(2250));





% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1) ; 
cla reset
axes(handles.axes2) ; 
cla reset
axes(handles.axes3) ; 
cla reset
axes(handles.axes4) ; 
cla reset

set(handles.PK,'String','None');

%*********************************************讀取圖片*********************************************

[handles.filename,pathname]=uigetfile({'*.*';'*.bmp';'*.tif';'*.png';'*.jpg'},'選擇圖片'); %讀取圖片檔案
if isequal(handles.filename,0)
   disp('User selected Cancel');
else
   disp(['User selected', fullfile(pathname, handles.filename)]);
   a = [pathname, handles.filename];
end
Orimage=imread(a);  
coverimage=Orimage; %讀取圖像
axes(handles.axes1);
imshow(coverimage);
coverimage=double(coverimage);%為了計算像素，將unit8轉成double

[x,y]=size(coverimage);
stegoimage=coverimage;
%***************************************************************************************************
n=str2double(get(handles.edit1,'String'));%輸入n值

if n==2
    t=1;
    secretmessagebits=zeros(1,131072);
    for j=1:512
        for i=1:2:512
            secretmessage= randsrc(1,1,0:4) ;%隨產生亂數進行藏匿
            secretmessagebits(t)=secretmessage;
            %改為能夠重複輸出
            k=mod(coverimage(j,i)+2*coverimage(j,i+1),2*n+1);
            d=mod((secretmessage-k),5);

         if d == 0
                     ;
         elseif d == 1
            stegoimage(j,i)=coverimage(j,i)+1;
         elseif d==2
            stegoimage(j,i+1)=coverimage(j,i+1)+1;
         elseif d==3
            stegoimage(j,i+1)=coverimage(j,i+1)-1;
         elseif d==4
            stegoimage(j,i)=coverimage(j,i)-1;
         end
       t=t+1;
        end   
    end


    %提取藏匿的訊息512*256
    extractsecretmessagebits=zeros(1,256);
    t=1;
    for j=1:512
        for i=1:2:512
            extractsecretmessagebits(t)=mod(stegoimage(j,i)+2*stegoimage(j,i+1),2*n+1);%模出來的數值
            t=t+1;
        end
    end
    
end

if n==3
    t=1;
    secretmessagebits=zeros(1,87040);
    for j=1:512
        for i=1:3:507
            secretmessage= randsrc(1,1,0:6) ;%隨產生亂數進行藏匿
            secretmessagebits(t)=secretmessage;
            k=mod(coverimage(j,i)+2*coverimage(j,i+1)+3*coverimage(j,i+2),2*n+1);%模出來的數值
            d=mod((secretmessage-k),7);
            if d == 0
                     ;
            elseif d == 1
                stegoimage(j,i)=coverimage(j,i)+1;
            elseif d==2
                stegoimage(j,i+1)=coverimage(j,i+1)+1;
            elseif d==3
                stegoimage(j,i+2)=coverimage(j,i+2)+1;
            elseif d==4
                stegoimage(j,i+2)=coverimage(j,i+2)-1;
            elseif d==5
                stegoimage(j,i+1)=coverimage(j,i+1)-1;
            elseif d==6
                stegoimage(j,i)=coverimage(j,i)-1;    
            end
       t=t+1;
        end   
    end

    %提取藏匿的訊息512*169
    extractsecretmessagebits=zeros(1,256);
    t=1;
    for j=1:512
        for i=1:3:507
            extractsecretmessagebits(t)=mod(stegoimage(j,i)+2*stegoimage(j,i+1)+3*stegoimage(j,i+2),2*n+1);%模出來的數值
            t=t+1;
        end
    end
end

%～～當為4個1組
if n==4
    t=1;
    secretmessagebits=zeros(1,256);
    for j=1:512
        for i=1:4:512
            secretmessage= randsrc(1,1,0:8) ;%隨產生亂數進行藏匿
            secretmessagebits(t)=secretmessage;
            k=mod(coverimage(j,i)+2*coverimage(j,i+1)+3*coverimage(j,i+2)+4*coverimage(j,i+3),2*n+1);%模出來的數值
            d=mod((secretmessage-k),9);

            if d == 0
                        ;
            elseif d == 1
                stegoimage(j,i)=coverimage(j,i)+1;
            elseif d==2
                stegoimage(j,i+1)=coverimage(j,i+1)+1;
            elseif d==3
                stegoimage(j,i+2)=coverimage(j,i+2)+1;
            elseif d==4
                stegoimage(j,i+3)=coverimage(j,i+3)+1;
            elseif d==5
                stegoimage(j,i+3)=coverimage(j,i+3)-1;
            elseif d==6
                stegoimage(j,i+2)=coverimage(j,i+2)-1;
            elseif d==7
                stegoimage(j,i+1)=coverimage(j,i+1)-1;
             elseif d==8
                stegoimage(j,i)=coverimage(j,i)-1;
            end
       t=t+1;
        end   
    end

%提取藏匿的訊息512*128
    extractsecretmessagebits=zeros(1,256);
    t=1;
    for j=1:512
        for i=1:4:512
            extractsecretmessagebits(t)=mod(stegoimage(j,i)+2*stegoimage(j,i+1)+3*stegoimage(j,i+2)+4*stegoimage(j,i+3),2*n+1);%模出來的數值
            t=t+1;
        end
    end
end

%***********************顯示藏匿後資訊****************************

%計算PSNR,MSE，計算4*4block基準
sum=0;
for i=1:x
    for j=1:y
sum=(coverimage(j,i)-stegoimage(j,i))^2+sum;
    end
end
MSE=sum/262144;
PSNR= 10*log10(255^2/MSE);
set(handles.MSE,'String',MSE);%秀出MSE的數值
set(handles.PSNR,'String',PSNR);%秀出PSNR數值

stegoimage =uint8(stegoimage);%呈現圖片，從double轉回unit8 bit
axes(handles.axes3);
imshow(stegoimage);
imwrite(stegoimage,'stegoEMD.png');

%***********************顯示秘密訊息****************************
set(handles.h1,'String',secretmessagebits(1));
set(handles.h2,'String',secretmessagebits(12));
set(handles.h3,'String',secretmessagebits(51));
set(handles.h4,'String',secretmessagebits(67));
set(handles.h5,'String',secretmessagebits(210));
set(handles.h6,'String',secretmessagebits(350));
set(handles.h7,'String',secretmessagebits(500));
set(handles.h8,'String',secretmessagebits(2500));
set(handles.h9,'String',secretmessagebits(4720));
set(handles.h10,'String',secretmessagebits(8001));

set(handles.g1,'String',extractsecretmessagebits(1));
set(handles.g2,'String',extractsecretmessagebits(12));
set(handles.g3,'String',extractsecretmessagebits(51));
set(handles.g4,'String',extractsecretmessagebits(67));
set(handles.g5,'String',extractsecretmessagebits(210));
set(handles.g6,'String',extractsecretmessagebits(350));
set(handles.g7,'String',extractsecretmessagebits(500));
set(handles.g8,'String',extractsecretmessagebits(2500));
set(handles.g9,'String',extractsecretmessagebits(4720));
set(handles.g10,'String',extractsecretmessagebits(8001));   

    
    




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1) ; 
cla reset
axes(handles.axes2) ; 
cla reset
axes(handles.axes3) ; 
cla reset
axes(handles.axes4) ; 
cla reset

set(handles.PK,'String','None');

%*********************************************讀取圖片*********************************************

[handles.filename,pathname]=uigetfile({'*.*';'*.bmp';'*.tif';'*.png';'*.jpg'},'選擇圖片'); %讀取圖片檔案
if isequal(handles.filename,0)
   disp('User selected Cancel');
else
   disp(['User selected', fullfile(pathname, handles.filename)]);
   a = [pathname, handles.filename];
end
Orimage=imread(a);  
coverimage=Orimage; %讀取圖像
axes(handles.axes1);
imshow(coverimage);
coverimage=double(coverimage);%為了計算像素，將unit8轉成double

[x,y]=size(coverimage);
stegoimage=coverimage;
%***************************************************************************************************

t=1;
n=str2double(get(handles.edit1,'String'));%輸入n值
if n==2%只做n=2的部分

    for j=1:512
        for i=1:2:512
            secretmessage= randsrc(1,1,0:7) ;%隨產生亂數進行藏匿
            secretmessagebits(t)=secretmessage;
            k=mod(stegoimage(j,i)+3*stegoimage(j,i+1),2^(n+1));
            d=mod((secretmessage-k),8);
             %將d轉為二進制
            if d==2^n
                stegoimage(j,i+1)=stegoimage(j,i+1)+1;
                stegoimage(j,i)=stegoimage(j,i)+1;
            elseif d<2^n
            d3=fix(d/4);%d3.d2.d1 3bits存放 
                a=mod(d,4);
                d2=fix(a/2);
                d1=mod(a,2);
            if d3>d2
                stegoimage(j,i+1)=stegoimage(j,i+1)-1;
            elseif d2>d3
                stegoimage(j,i+1)=stegoimage(j,i+1)+1;
            end
            if d1>d2
                stegoimage(j,i)=stegoimage(j,i)+1;
            elseif d1<d2
                stegoimage(j,i)=stegoimage(j,i)-1;
            end
    
elseif d>2^n
    d=2^(n+1)-d;
    d3=fix(d/4);%d3.d2.d1 3bits存放 
     a=mod(d,4);
    d2=fix(a/2);
     d1=mod(a,2);
    if d3>d2
        stegoimage(j,i+1)=stegoimage(j,i+1)+1;
    elseif d2>d3
        stegoimage(j,i+1)=stegoimage(j,i+1)-1;
    end
    if d1>d2
       stegoimage(j,i)=stegoimage(j,i)-1;
        elseif d1<d2
       stegoimage(j,i)=stegoimage(j,i)+1;
    end

end


t=t+1;
end
end
%提取數值
 extractsecretmessagebits=zeros(1,256);
 t=1;
 for j=1:512
for i=1:2:512
  extractsecretmessagebits(t) =mod(stegoimage(j,i)+3*stegoimage(j,i+1),2^(n+1));
   t=t+1;
end
end
end 
 
 
if n==3%的情況

for j=1:512
for i=1:3:507

 secretmessage= randsrc(1,1,0:15) ;%隨產生亂數進行藏匿
 secretmessagebits(t)=secretmessage;
k=mod(stegoimage(j,i)+3*stegoimage(j,i+1)+7*stegoimage(j,i+2),2^(n+1));
d=mod((secretmessage-k),16);
%將d轉為二進制
%bit=dec2bin(d,4);%固定輸出結果為3bit數
if d==2^n
  stegoimage(j,i+2)=stegoimage(j,i+2)+1;
  stegoimage(j,i)=stegoimage(j,i)+1;
elseif d<2^n
    b3=fix(d/8);%b3.b2.b1.b0   4bit存放
    a=mod(d,8);
    b2=fix(a/4);
    a=mod(a,4);
    b1=fix(a/2);
    b0=mod(a,2);
%改成for方法搜尋迴圈
     if b3>b2
        stegoimage(j,i+2)=stegoimage(j,i+2)-1;
    elseif b2>b3
       stegoimage(j,i+2)=stegoimage(j,i+2)+1;
       end
       if b2>b1
       stegoimage(j,i+1)=stegoimage(j,i+1)-1;
        elseif b1>b2
       stegoimage(j,i+1)=stegoimage(j,i+1)+1;
       end
       if b1>b0
       stegoimage(j,i)=stegoimage(j,i)-1;
        elseif b0>b1
       stegoimage(j,i)=stegoimage(j,i)+1;
       end
    
elseif d>2^n
    d=2^(n+1)-d;

   b3=fix(d/8);%b3.b2.b1.b0   4bit存放
    a=mod(d,8);
    b2=fix(a/4);
    a=mod(a,4);
    b1=fix(a/2);
    b0=mod(a,2);
 if b3>b2
        stegoimage(j,i+2)=stegoimage(j,i+2)+1;
    elseif b2>b3
       stegoimage(j,i+2)=stegoimage(j,i+2)-1;
       end
       if b2>b1
       stegoimage(j,i+1)=stegoimage(j,i+1)+1;
        elseif b1>b2
       stegoimage(j,i+1)=stegoimage(j,i+1)-1;
       end
       if b1>b0
       stegoimage(j,i)=stegoimage(j,i)+1;
        elseif b0>b1
       stegoimage(j,i)=stegoimage(j,i)-1;
       end
       
end


t=t+1;
end
end
%提取數值
 extractsecretmessagebits=zeros(1,256);
 t=1;
 for j=1:507
for i=1:3:507
  extractsecretmessagebits(t) =mod(stegoimage(j,i)+3*stegoimage(j,i+1)+7*stegoimage(j,i+2),2^(n+1));
   t=t+1;
end
 end
end



if n==4%的情況

for j=1:512
for i=1:4:512

 secretmessage= randsrc(1,1,0:31) ;%隨產生亂數進行藏匿
 secretmessagebits(t)=secretmessage;
k=mod(stegoimage(j,i)+3*stegoimage(j,i+1)+7*stegoimage(j,i+2)+15*stegoimage(j,i+3),2^(n+1));
d=mod((secretmessage-k),32);
%將d轉為二進制
%bit=dec2bin(d,4);%固定輸出結果為3bit數
if d==2^n
  stegoimage(j,i+3)=stegoimage(j,i+3)+1;
  stegoimage(j,i)=stegoimage(j,i)+1;
elseif d<2^n
    b4=fix(d/16);%b4 b3.b2.b1.b0   5bit存放
    a=mod(d,16);
    b3=fix(a/8);
    a=mod(a,8);
    b2=fix(a/4);
    a=mod(a,4);
    b1=fix(a/2);
    b0=mod(a,2);
%改成for方法搜尋迴圈
      if b4>b3
        stegoimage(j,i+3)=stegoimage(j,i+3)-1;
    elseif b3>b4
       stegoimage(j,i+3)=stegoimage(j,i+3)+1;
       end

     if b3>b2
        stegoimage(j,i+2)=stegoimage(j,i+2)-1;
    elseif b2>b3
       stegoimage(j,i+2)=stegoimage(j,i+2)+1;
       end
       if b2>b1
       stegoimage(j,i+1)=stegoimage(j,i+1)-1;
        elseif b1>b2
       stegoimage(j,i+1)=stegoimage(j,i+1)+1;
       end
       if b1>b0
       stegoimage(j,i)=stegoimage(j,i)-1;
        elseif b0>b1
       stegoimage(j,i)=stegoimage(j,i)+1;
       end
    
elseif d>2^n
    d=2^(n+1)-d;

    b4=fix(d/16);%b4  b3.b2.b1.b0   5bit存放
    a=mod(d,16);
    b3=fix(a/8);
    a=mod(a,8);
    b2=fix(a/4);
    a=mod(a,4);
    b1=fix(a/2);
    b0=mod(a,2);
    if b4>b3
        stegoimage(j,i+3)=stegoimage(j,i+3)+1;
    elseif b3>b4
       stegoimage(j,i+3)=stegoimage(j,i+3)-1;
       end
    
    
 if b3>b2
        stegoimage(j,i+2)=stegoimage(j,i+2)+1;
    elseif b2>b3
       stegoimage(j,i+2)=stegoimage(j,i+2)-1;
       end
       if b2>b1
       stegoimage(j,i+1)=stegoimage(j,i+1)+1;
        elseif b1>b2
       stegoimage(j,i+1)=stegoimage(j,i+1)-1;
       end
       if b1>b0
       stegoimage(j,i)=stegoimage(j,i)+1;
        elseif b0>b1
       stegoimage(j,i)=stegoimage(j,i)-1;
       end
       
end


t=t+1;
end
end
%提取數值
 extractsecretmessagebits=zeros(1,256);
 t=1;
 for j=1:512
for i=1:4:512
  extractsecretmessagebits(t) =mod(stegoimage(j,i)+3*stegoimage(j,i+1)+7*stegoimage(j,i+2)+15*stegoimage(j,i+3),2^(n+1));
   t=t+1;
end
 end
end

%***********************顯示藏匿後資訊****************************

%計算PSNR,MSE，計算4*4block基準
sum=0;
for i=1:x
    for j=1:y
sum=(coverimage(j,i)-stegoimage(j,i))^2+sum;
    end
end
MSE=sum/262144;
PSNR= 10*log10(255^2/MSE);
set(handles.MSE,'String',MSE);%秀出MSE的數值
set(handles.PSNR,'String',PSNR);%秀出PSNR數值

stegoimage =uint8(stegoimage);%呈現圖片，從double轉回unit8 bit
axes(handles.axes3);
imshow(stegoimage);
imwrite(stegoimage,'stegoEMD.png');

%***********************顯示秘密訊息****************************
set(handles.h1,'String',secretmessagebits(1));
set(handles.h2,'String',secretmessagebits(12));
set(handles.h3,'String',secretmessagebits(51));
set(handles.h4,'String',secretmessagebits(67));
set(handles.h5,'String',secretmessagebits(210));
set(handles.h6,'String',secretmessagebits(350));
set(handles.h7,'String',secretmessagebits(500));
set(handles.h8,'String',secretmessagebits(2500));
set(handles.h9,'String',secretmessagebits(4720));
set(handles.h10,'String',secretmessagebits(8001));

set(handles.g1,'String',extractsecretmessagebits(1));
set(handles.g2,'String',extractsecretmessagebits(12));
set(handles.g3,'String',extractsecretmessagebits(51));
set(handles.g4,'String',extractsecretmessagebits(67));
set(handles.g5,'String',extractsecretmessagebits(210));
set(handles.g6,'String',extractsecretmessagebits(350));
set(handles.g7,'String',extractsecretmessagebits(500));
set(handles.g8,'String',extractsecretmessagebits(2500));
set(handles.g9,'String',extractsecretmessagebits(4720));
set(handles.g10,'String',extractsecretmessagebits(8001));   




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
