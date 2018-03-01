%% Cell response to visual stimuli
clear,clc
load CC.mat;
load ONimage.mat;
load OFFimage.mat;
CellVisualRsp = zeros(CC.NumObjects, 57);
% pickcellnum = [1 5 6 9 10 4 8 7 3 2];
% visualMaxNum = zeros(1, length(pickcellnum));
visualMaxNum = zeros(1, 5);
for i = 1:CC.NumObjects%length(pickcellnum)
    ci = i;%pickcellnum(i)
    for j = 1:57
        on = mean(ONimage(j, CC.PixelIdxList{ci}),2);
        off = mean(OFFimage(j, CC.PixelIdxList{ci}),2);
        CellVisualRsp(ci, j) = on/off-1;
    end
    visualMaxNum(i) = find(CellVisualRsp(ci, :) == max(CellVisualRsp(ci, :)));
%     bw5=zeros(512,512);
%     bw6=zeros(512,512,3);
%     figure(1);
% %     set(gcf,'unit','centimeters','position',[1 2 49 23])
%     bw5(CCtotal.PixelIdxList{ci})=true;       
%     bw6(:,:,3)=bw6(:,:,3)+bw5;
%     bw6(:,:,2)=bw6(:,:,2)+bw5;
%     sumIm=squeeze(mean(double(ONimage))/500);
%     bw3=zeros(512,512,3);
%     imYY4=bw3;
%     bw3=imresize(bw6,1)/2;
%     imYY3=imresize(double(sumIm),1)/10;
%     imYY4(:,:,1)=imYY3;
%     imYY4(:,:,2)=imYY3;
%     imYY4(:,:,3)=imYY3;
    
%     subplot(1,2,1);
%     imshow((10*double(bw3*5)+10*double(imYY4)-0)/5);
%     set(gca, 'Units', 'normalized', 'Position', [-0.1 0.45 0.5 0.5])
%     subplot(1,2,2);
%     plot(CellVisualRsp(ci,:));
%     grid on
%     set(gca, 'Units', 'normalized', 'Position', [0.3 0.05 0.65 0.9]);
%     pause;
end
save CellVisualRsp.mat CellVisualRsp;
save visualMaxNum.mat visualMaxNum;
%% Taget cell time curve
clear,clc
load CC.mat;
pickcellnum = [1 5 6 9 10 4 8 7 3 2];
Mdir=pwd;
packDir = fileparts(Mdir);
meaPack = dir([packDir '\MEA\']);
fileNEV = [packDir '\MEA\' meaPack(4).name];
fileNS = [packDir '\MEA\' meaPack(5).name];
fileTPCorr = [packDir '\Corr\'];
tpDir = [packDir '\TP image'];
tpPack = dir(tpDir);
NumFrame = size(dir(fileTPCorr),1) - 2;

% targetCellTC = zeros(length(pickcellnum), NumFrame);
% for fi = 1:NumFrame
%     fi
%     imfileName=[fileTPCorr num2str(fi)];
%     imX=imread(imfileName);
%     for ci = 1:length(pickcellnum)
%         targetCellTC(ci, fi) = mean(imX(CC.PixelIdxList{pickcellnum(ci)}));
%     end
% end
% save targetCellTC.mat targetCellTC;

load targetCellTC.mat;
load imClose.mat; 

figure; set(gcf, 'OuterPosition', [1000 500 400 410]);
hold on; ax = gca;
for i = 1:length(imClose)
    fill([ones(1,2).*imClose(i,2), ones(1,2).*imClose(i,2)+8], [-1 65 65 -1], [.7 .7 .7], 'EdgeColor', 'none');
end
stisquarewave = zeros(1, NumFrame*10);
for i = 1:length(imClose)
    stisquarewave(imClose(i, 2)*10:(imClose(i, 2)+8)*10) = true;
end
plot(0.1:0.1:NumFrame,stisquarewave*2, 'k','LineWidth',1.5);
cList = hsv(length(pickcellnum));
for ci = 1:length(pickcellnum)
    plot(1:NumFrame, (targetCellTC(ci,:)-mean(targetCellTC(ci,:)))./mean(targetCellTC(ci,:))+5*ci, 'Color', cList(ci,:), 'LineWidth', 1.2); hold on
end
set(gca, 'XLim', [6320, 6670], 'YLim', [-1, 60], ... 
    'YTick', 0:5:55, 'YTickLabel', {'Visual', 'N1', 'N2', 'N3', 'N4', 'N5', 'N6', 'N7', 'N8', 'N9', 'N10'}, ... 
    'FontWeight', 'bold', 'FontSize', 10);
% title('visual stimuli -- 778, 5/2s', 'FontWeight', 'bold', 'FontSize', 12);

fill([6520, 6520, 6536, 6536], [55 56 56 55], [0 0 0], 'EdgeColor', 'none');
fill([6510, 6510, 6515, 6515], [54 59 59 54], [0 0 0], 'EdgeColor', 'none');
axis off
% saveas(gcf, '778-targetCell-rspUnderVisualSimuli.png');
set(gcf, 'PaperPositionMode', 'auto');
print('TargetCell-rspUnderVisualSimuli.tif', '-dtiffn', '-r0');
%% tc-IDs2-faceColor: 10--[1 0.8 1]; 5-[0.6 0.8 1]
clear,clc
load IDs2.mat;
load imClose.mat;
load targetCellTC.mat;
load visualMaxNum.mat;
tc = 5;
crgb = hsv(10);
tcmat = zeros(10, 48);
frameSTNum = imClose(find(IDs2==visualMaxNum(tc)), 2);
for i = 1:10
    for t = 1:48
        tcmat(i,t) = targetCellTC(tc, frameSTNum(i)+t-16);
    end
end

rspListNorm = zeros(10, 48);
for i = 1:size(tcmat,1)
    rspListNorm(i,:) = tcmat(i,:)./mean(tcmat(i,1:8))-1;
end
seList = std(rspListNorm, 1)./sqrt(size(tcmat,1));
for i = 1:size(tcmat,1)
    i
    plot(rspListNorm(i,:));
    hold on
%     pause;
end

figure(1); hold on;
set(gcf, 'OuterPosition', [500 500 400 390]);
fill([16, 16, 24, 24], [-0.5, 4.5, 4.5, -0.5], [.85 .85 .85], 'EdgeColor', 'none'); % [-0.5, 9, 9, -0.5]
fill([1:48, 48:-1:1], [mean(rspListNorm)+seList, fliplr(mean(rspListNorm)-seList)], [0.6 0.8 1], 'EdgeColor', 'none');
plot(mean(rspListNorm), 'Color', crgb(tc,:), 'LineWidth', 2);
axis([8 48 -0.6 4.5]); % [8 48 -0.8 9]
% xlabel({'Time from visual'; 'stimuli onset (s)'}, 'FontSize', 30);
% ylabel('¦¤F/F', 'FontSize', 30);
set(gca, 'XTick', 0:8:48, 'XTickLabel', -2:1:4, 'FontSize', 30, 'LineWidth', 2);

set(gcf, 'PaperPositionMode', 'auto');
print('Visual-TimeCurve-5.tif', '-dtiffn', '-r0');
%% All cell responses
clear,clc
load CCtotal.mat;
load ONimage.mat;
load OFFimage.mat;
CellVisualRsp = zeros(CCtotal.NumObjects, 57);
visualMaxNum = zeros(1, CCtotal.NumObjects);

for i = 1:CCtotal.NumObjects%length(pickcellnum)
    ci = i;%pickcellnum(i)
    for j = 1:57
        on = mean(ONimage(j, CCtotal.PixelIdxList{ci}),2);
        off = mean(OFFimage(j, CCtotal.PixelIdxList{ci}),2);
        CellVisualRsp(ci, j) = on/off-1;
    end
    visualMaxNum(i) = find(CellVisualRsp(ci, :) == max(CellVisualRsp(ci, :)));
end
save CellVisualRspAll.mat CellVisualRsp;
save visualMaxNumAll.mat visualMaxNum;