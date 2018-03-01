%% generating movie
clear,clc;
fileTPCorr = 'G:\OptActi\M130265\20170717\Tseries-CorrImageJ\TSeries-07142017-1129-778\';
NumFrame =length(dir(fileTPCorr))-2;
load optsti-778.mat;
load optstiend-778.mat;
optsti = [optsti NumFrame];
optstiend = [1 optstiend];

baseIm = zeros(512,512, length(optsti), 'uint16');
for i = 1:length(optsti)
    temp = zeros(512,512, 'uint16');
    for j = 6:optsti(i)-optstiend(i)-5
        imfileName = [fileTPCorr int2str(optstiend(i)+j-1)];
        imX=imread(imfileName);
        temp = temp + imX./(optsti(i)-optstiend(i)-10);
    end
    baseIm(:,:,i) = temp;
end

carea = zeros(240, 240, NumFrame, 'double');
for i = 1:1:NumFrame
    imfileName = [fileTPCorr int2str(i)];
    imX=imread(imfileName);
    for k = 1:length(optsti)
        if k<length(optsti)
            if i-optstiend(k) > 0 && i-optstiend(k+1) <= 0
                break;
            end
        else
            k = length(optsti);
            break;
        end
    end
    imY = imX - baseIm(:,:,k);
%     imshow(imX*1000)
    carea(:,:,i) = imresize(imY(17:496,17:496), 0.5);
    disp(int2str(i));
end

for i = 1:size(carea, 3)
    i
    imshow(squeeze(carea(:,:,i))/50);
end

movObj = QTWriter('SPActi.mov','MovieFormat','Photo JPEG','Quality',100);
movObj.FrameRate = 12;
nFrames = 600;  
set(gca,'nextplot','replacechildren');
imshow(zeros(240));
for i=1:2:nFrames
    i
    Img = squeeze(carea(:,:,360+i))/100;
    Img(201:205, 10:10+100/2/800*512) = 1;
    imshow(Img); hold on
    text(3, 188, '100 ¦Ìm', 'Color', [1 1 1], 'FontSize', 12, 'FontWeight', 'bold');
    tempnum = int2str(100 + floor(i/16)*2);
    text(3, 40, ['Time : ', tempnum(end-1:end), ' s'], 'Color', [1 1 1], 'FontSize', 12, 'FontWeight', 'bold');
    hold off

    frame=getframe(gcf);    
    im = frame.cdata;
    rim = im(31:270,83:322,:);
    frame.cdata = rim;
    writeMovie(movObj, frame);
end  
movObj.PlayAllFrames = true;
% Finish writing movie and close file
close(movObj);
