%% Galvo image
clear,clc
galvoIm = imread('SingleImage-09012017-0948-262-Ch2-16bit-Reference.tif');
% galvoIm = imread('G:\OptActi\M130265\20171128\16x_1024_TargetDepth\SingleImage-11272017-1333-273-Ch2-16bit-Reference.tif');
% galvoIm = imread('G:\OptActi\M130265\20171128\16x_1024_Depth_400\SingleImage-11272017-1333-273-Ch2-16bit-Reference.tif');
% figure(11), imshow(galvoIm*10);
% load imc2.mat;
% figure(12), imshow(imc2/1000);
deltaShift = [136, 400]; %[51 251][41, 221][136, 400];
imcGalvo = galvoIm(deltaShift(2)+1:deltaShift(2)+590, deltaShift(1)+1:deltaShift(1)+590);
imcGalvo(560:570, 570-100/800*1024:570) = 65535;
figure, imshow(imcGalvo*12);hold on;

cellPosi = [39 309 352 525 526 270 497 367 263 36; 82 207 112 261 96 335 394 41 507 379]; % 0901
% cellPosi = [121 129 355 350 396; 538 237 335 487 354]; % 1128
crgb = hsv(10);%[0.8 0.2 0.2; 0.7 0.7 0.2; 0.2 0.8 0.2; 0.2 0.8 0.7; 0.3 0.5 0.8];
for i = 1:size(cellPosi, 2)
    plot(cellPosi(1,i),cellPosi(2,i), 'Marker', 'o', 'MarkerSize', 20, 'MarkerEdgeColor', crgb(i,:),'LineWidth',2);
end
imcdata = getframe(gcf);
im = imcdata.cdata;
imraw = im(31:620, 86:675, :);
figure(14), imshow(imraw)
imwrite(imraw, 'targetLayer-Galvo.tif');
%% Laser stimuli
clear,clc
load ONimage-778.mat;
load OFFimage-778.mat;
deltaFL = ONimage-OFFimage;
figure(3), imshow(deltaFL/100);
imc = deltaFL(166:460, 56:350);
imc(280:285, 285-100/800*512:285) = 65535;
figure(4), imshow(imc/40);
imwrite(imc/50, '778-deltaFLaser.tif');