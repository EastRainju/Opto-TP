%% Two-photon activation spatial resolution
clear,clc
load optStart53.mat;
load optEnd53.mat;
load CC.mat;
load sumIm.mat;

% Target cortical area and neurons
figure(1), imshow(sumIm/3000000);
cArea = cat(3, sumIm(71:470, 71:470)/3000000, sumIm(71:470, 71:470)/3000000, sumIm(71:470, 71:470)/3000000);
xlist = [49   241   236   358];
ylist = [359   295    84    56];
for i = 1:4
    x = xlist(i);
    y = ylist(i);
    cArea(y-12:y-10, [x-12:x-6, x+6:x+12], 1) = 1; cArea(y-12:y-10, [x-12:x-6, x+6:x+12], 2) = 0.5; cArea(y-12:y-10, [x-12:x-6, x+6:x+12], 3) = 0;
    cArea(y+10:y+12, [x-12:x-6, x+6:x+12], 1) = 1; cArea(y+10:y+12, [x-12:x-6, x+6:x+12], 2) = 0.5; cArea(y+10:y+12, [x-12:x-6, x+6:x+12], 3) = 0;
    cArea([y-12:y-6, y+6:y+12], x-12:x-10, 1) = 1; cArea([y-12:y-6, y+6:y+12], x-12:x-10, 2) = 0.5; cArea([y-12:y-6, y+6:y+12], x-12:x-10, 3) = 0;
    cArea([y-12:y-6, y+6:y+12], x+10:x+12, 1) = 1; cArea([y-12:y-6, y+6:y+12], x+10:x+12, 2) = 0.5; cArea([y-12:y-6, y+6:y+12], x+10:x+12, 3) = 0;
end
cArea(375:380, 380-round(50*512/400):380, :) = 1;
imshow(cArea)
imwrite(cArea, 'FourCellOnePlane.tif');

% Target neurons
cArea = cat(3, sumIm/2000000, sumIm/2000000, sumIm/2000000);
xlist = [49   241   236   358]+70;
ylist = [359   295    84    56]+70;
for i = 1:4
    x = xlist(i);
    y = ylist(i);
    cArea(y-12:y-10, [x-12:x-6, x+6:x+12], 1) = 1; cArea(y-12:y-10, [x-12:x-6, x+6:x+12], 2) = 0.5; cArea(y-12:y-10, [x-12:x-6, x+6:x+12], 3) = 0;
    cArea(y+10:y+12, [x-12:x-6, x+6:x+12], 1) = 1; cArea(y+10:y+12, [x-12:x-6, x+6:x+12], 2) = 0.5; cArea(y+10:y+12, [x-12:x-6, x+6:x+12], 3) = 0;
    cArea([y-12:y-6, y+6:y+12], x-12:x-10, 1) = 1; cArea([y-12:y-6, y+6:y+12], x-12:x-10, 2) = 0.5; cArea([y-12:y-6, y+6:y+12], x-12:x-10, 3) = 0;
    cArea([y-12:y-6, y+6:y+12], x+10:x+12, 1) = 1; cArea([y-12:y-6, y+6:y+12], x+10:x+12, 2) = 0.5; cArea([y-12:y-6, y+6:y+12], x+10:x+12, 3) = 0;
    cAreas = cArea(y-54:y+55, x-54:x+55, :);
    cAreas(110-12:110-10, 10:10+round(20*512/400), :) = 1;
    figure,imshow(cAreas)
    imwrite(cAreas, [num2str(i), '-targetCell-TargetAreaS2.tif']);
end

% Target cell time curve array
load rspArrayL53.mat;
load rspSeArrayL53.mat;
cellNumList = [1 3 2 4];
for ci = 1:CC.NumObjects
    ii = cellNumList(ci);
    for i = 1:2:7
        subplot(4,4,(ii-1)*4+ceil(i/2));
        if ii == ceil(i/2)
            fill([1:16, 16:-1:1], [squeeze(rspArrayL(ci,i,5:20)+rspSeArrayL(ci,i,5:20)); flipud(squeeze(rspArrayL(ci,i,5:20)-rspSeArrayL(ci,i,5:20)))], [1 0.8 0.8], 'EdgeColor', 'none'); hold on
            plot(squeeze(rspArrayL(ci,i,5:20)), 'LineWidth', 1.5, 'Color', [1 0.5 0]);
        else
            fill([1:16, 16:-1:1], [squeeze(rspArrayL(ci,i,5:20)+rspSeArrayL(ci,i,5:20)); flipud(squeeze(rspArrayL(ci,i,5:20)-rspSeArrayL(ci,i,5:20)))], [0.6 0.8 1], 'EdgeColor', 'none'); hold on
            plot(squeeze(rspArrayL(ci,i,5:20)), 'LineWidth', 1.5, 'Color', [0 0.5 1]);
        end
        axis([0 17 -0.5 2]);
        box off
        axis off
    end
end
hold on
plot([5,12], [1.5,1.5], 'Color', 'k', 'LineWidth',2);
plot([3,3], [0.5,1.5], 'Color', 'k', 'LineWidth',2);

set(gcf, 'PaperPositionMode', 'auto','OuterPosition', [500 300 500 550]);
print([num2str(targetFileNum), '-targetCell-TimeCurve.tif'], '-dtiffn', '-r0');

% Single neuron time curve
cellNumList = [1 3 2 4];
repeatNum = 10;
for ci = 1:4
    offTargetSe = zeros(1,32);
    offTargetMean = zeros(1,32);
    tIdx = 1:2:8*repeatNum;
    tIdx(ci:4:end) = [];
    cci = cellNumList(ci);
    for t = 1:32
        mlTemp = zeros(1, length(optStart));
        for i = 1:length(optStart)
            im = imread(['G:\OptActi\M120543\TP Activation\20180125\FourCellOnePlane\Corr53\', num2str(optStart(i)-9+t)]);
            mlTemp(i) = mean(im(CC.PixelIdxList{cci}));% - mean2(im) + 40;
        end
        offTargetMean(t) = mean(mlTemp(tIdx));
        offTargetSe(t) = std(mlTemp(tIdx))/sqrt(length(tIdx));
    end
    baseLumi = mean(offTargetMean(1:8));
    offTargetMean = offTargetMean/baseLumi-1;
    offTargetSe = offTargetSe/baseLumi;

    figure;
    fill([9, 9, 9+mean(optEnd-optStart), 9+mean(optEnd-optStart)], [-0.1, 1.9, 1.9, -0.1], [.85 .85 .85], 'EdgeColor', 'none'); hold on
    fill([1:32, 32:-1:1], [squeeze(rspArrayL(cci,ci*2-1,:)+rspSeArrayL(cci,ci*2-1,:)); flipud(squeeze(rspArrayL(cci,ci*2-1,:)-rspSeArrayL(cci,ci*2-1,:)))], [1 0.8 0.8], 'EdgeColor', 'none');
    plot(squeeze(rspArrayL(cci,ci*2-1,:)), 'LineWidth', 2, 'Color', [1 0.5 0]);
    fill([1:32, 32:-1:1], [offTargetMean+offTargetSe, fliplr(offTargetMean-offTargetSe)], [0.6 0.8 1], 'EdgeColor', 'none');
    plot(offTargetMean, 'LineWidth', 2, 'Color', [0 0.5 1]);
    if ci ==1
        plot([16,23], [1.5 1.5], 'LineWidth', 5, 'Color', [0 0 0]);
        plot([6, 6], [0.5 1.5], 'LineWidth', 5, 'Color', [0 0 0]);
    end
    axis([4 26 -0.3 2]);
    box off
    axis off
%     set(gca, 'XTick', 1:8:32, 'XTickLabel', -1:1:2, 'FontSize', 30, 'LineWidth', 2);
    set(gcf, 'PaperPositionMode', 'auto','OuterPosition', [500 300 400 250]);
    print([num2str(ci), '-targetCell-ONOFFtargetTimeCurveS.tif'], '-dtiffn', '-r0');
end