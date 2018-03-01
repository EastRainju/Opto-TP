clear,clc
load ONimageTcS.mat;
visualMovie = zeros(512,512,16*6);
for i = 1:6
    baseV = squeeze(mean(mean(mean(ONimageTcS(1:10, i:6:48,1:8,:,:)))));
    for j = 1:16
        visualMovie(:,:,(i-1)*16+j) = squeeze(mean(mean(ONimageTcS(1:10, i:6:48,j,:,:)))) - baseV;
    end
end

movObj = QTWriter('Visual.mov','MovieFormat','Photo JPEG','Quality',100);
movObj.FrameRate = 8;
nFrames = 16*6;  
set(gca,'nextplot','replacechildren');
xlist = [];
ylist = [];
for x = -24:25
    for y = -24:25
        if x^2+y^2<400
            xlist = [xlist x];
            ylist = [ylist y];
        end
    end
end
imshow(zeros(231));

for i=1:1:nFrames
    i
    gratImBase = ones(50)*0.5;
    if mod(i-1,16)+1>8 && mod(i-1,16)+1<17
        for x = 1:50
            for y = 1:50
                if (x-25)^2+(y-25)^2<625
                    if mod(ceil((y+mod(i,16))/5),2) == 0
                        gratImBase(y,x) = 1;
                    else
                        gratImBase(y,x) = 0;
                    end
                end
            end
        end
    end
    gratIm = imrotate(gratImBase, -30*(floor((i-1)/16)));
    
    Img = imresize(squeeze(visualMovie(:,:,i))/500, 0.45);
    Img(216:220, 10:10+round(100*0.45/800*512)) = 1;
    for p = 1:length(xlist)
        Img(ylist(p)+30, xlist(p)+200) = gratIm(round(size(gratIm,1)/2)+ylist(p), round(size(gratIm,2)/2)+xlist(p));
    end
    imshow(Img); hold on
    text(3, 202, '100 ¦Ìm', 'Color', [1 1 1], 'FontSize', 12, 'FontWeight', 'bold');
    tempnum = int2str(100 + floor(i/8));
    text(3, 13, ['Time : ', tempnum(end-1:end), ' s'], 'Color', [1 1 1], 'FontSize', 12, 'FontWeight', 'bold');
    hold off

    frame=getframe(gcf);    
    im = frame.cdata;
    rim = im(31:261,83:313,:);
    frame.cdata = rim;
    writeMovie(movObj, frame);
end  
movObj.PlayAllFrames = true;
% Finish writing movie and close file
close(movObj);
