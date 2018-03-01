%% Cell responses under optical stimuli
clear,clc
pickcellnum = [2 8 10 14 15 26 13 67 5 1];
crgb = hsv(length(pickcellnum));
load CCtotal.mat;
load solocellrspnorm-778.mat;
load optsti-778.mat;
load optstiend-778.mat;

figure;set(gcf, 'OuterPosition', [1000 500 400 410]);ax = gca;
hold on;
osb = [optsti(1), optsti(4:10)-100, 1000]; ose = [1, optstiend(1), optstiend(4:10)-100];
for i = 1:length(osb)-1
    fill([ones(1,2).*osb(i), ones(1,2).*ose(i+1)], [-1 65 65 -1], [.7 .7 .7], 'EdgeColor', 'none');
%     line(ones(2).*osb(i)+(ose(i+1)-osb(i))/2, [-1 50],'LineWidth',ose(i+1)-osb(i),'Color',[.8 .8 .8],'Parent',ax);
end
stisquarewave = zeros(1, 900*10);
for i = 1:length(osb)-1
    stisquarewave(osb(i)*10:(ose(i+1)-1)*10) = true;
end
plot(0.1:0.1:900, stisquarewave*2, 'k','LineWidth',1.5);hold on;
for i = 1:length(pickcellnum)
    plot(1:900, solocellrspnorm(pickcellnum(i),[1:200 301:1000]) + 5*i, 'Color', crgb(i,:), 'LineWidth',1.2);
end
set(gca, 'XLim', [0 900], 'YLim', [-1, 60], ... 
    'YTick', 0:5:55, 'YTickLabel', {'Laser', 'N1', 'N2', 'N3', 'N4', 'N5', 'N6', 'N7', 'N8', 'N9', 'N10'}, ... 
    'FontWeight', 'bold', 'FontSize', 10);
title('laser stimuli -- 778, 5/5s', 'FontWeight', 'bold', 'FontSize', 12);

fill([20, 20, 30, 30], [54 59 59 54], [0 0 0], 'EdgeColor', 'none');
fill([40, 40, 80, 80], [55 56 56 55], [0 0 0], 'EdgeColor', 'none');
axis off
% saveas(gcf, '778-targetCell-rspUnderLaser.png');
set(gcf, 'PaperPositionMode', 'auto');
print('778-targetCell-rspUnderLaserSimuli.tif', '-dtiffn', '-r0');
%% example cell time curve
clear,clc
pickcellnum = [2 8 10 14 15 26 13 67 5 1];
tc = 5;
tcnum = pickcellnum(tc);
crgb = hsv(10);
load solocellrspnorm-778.mat;
load optsti-778.mat;
load optstiend-778.mat;
optsti(2:3)=[];
optstiend(2:3)=[];
laserTimeA = mean(optstiend-optsti);
rspListNorm = zeros(length(optsti), 64);
for i = 1:length(optsti)
    rspListNorm(i,:) = solocellrspnorm(tcnum, optsti(i)-15:optsti(i)+48);
end
seList = std(rspListNorm, 1)./sqrt(size(rspListNorm,1));
for i = 1:size(rspListNorm,1)
    plot(rspListNorm(i,:));
    hold on
end

figure(1); hold on;
set(gcf, 'OuterPosition', [500 500 400 390]);
fill([16, 16, 16+laserTimeA, 16+laserTimeA], [-0.4, 4.5, 4.5, -0.4], [.85 .85 .85], 'EdgeColor', 'none'); % [-0.5, 9, 9, -0.5]
fill([1:64, 64:-1:1], [mean(rspListNorm)+seList, fliplr(mean(rspListNorm)-seList)], [0.3 0.8 0.3], 'EdgeColor', 'none');%[1 0.8 0.8][0.3 0.8 0.6]
plot(1:64, mean(rspListNorm), 'Color', crgb(tc,:), 'LineWidth', 2);
axis([8 48 -0.5 4.5]);
% xlabel({'Time from laser'; 'onset (s)'}, 'FontSize', 30);
% ylabel('¦¤F/F', 'FontSize', 30);
set(gca, 'XTick', 0:8:64, 'XTickLabel', -2:1:6, 'FontSize', 30, 'LineWidth', 2);

set(gcf, 'PaperPositionMode', 'auto');
print('778-targetCell-5-TimeCurve.tif', '-dtiffn', '-r0');