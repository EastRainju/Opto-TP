%% Long-term Laser Response
clear,clc
load CCD1.mat;
CCD1 = CC;
load CCD2.mat;
CCD2 = CC;
load ONimageLaserD1.mat;
ONimageLaserD1 = ONimage;
load OFFimageLaserD1.mat;
OFFimageLaserD1 = OFFimage;
load ONimageLaserD2.mat;
ONimageLaserD2 = ONimage;
load OFFimageLaserD2.mat;
OFFimageLaserD2 = OFFimage;

% Target neurons
bw = zeros(512);
for ci = 1:CCD1.NumObjects
    P1 = CCD1.PixelIdxList{ci};
    bw(P1) = 1;
end
figure(1), imshow(cat(3, ONimageLaserD1/100, ONimageLaserD1/100, ONimageLaserD1/100) + cat(3, bw, zeros(512), zeros(512)));

bw = zeros(512);
for ci = 1:CCD2.NumObjects
    P1 = CCD2.PixelIdxList{ci}+5; % shift down 4
    bw(P1) = 1;
end
figure(2), imshow(cat(3, ONimageLaserD2/100, ONimageLaserD2/100, ONimageLaserD2/100) + cat(3, bw, zeros(512), zeros(512)));

% Statistics
RspListD1 = zeros(1, CCD1.NumObjects);
RspListD2 = zeros(1, CCD1.NumObjects);
for ci = 1:CCD1.NumObjects
    P1 = CCD1.PixelIdxList{ci};
    on = mean(ONimageLaserD1(P1));
    off = mean(OFFimageLaserD1(P1));
    RspListD1(ci) = on/off - 1;
    
    P2 = CCD2.PixelIdxList{ci};
    on = mean(ONimageLaserD2(P2+5));
    off = mean(OFFimageLaserD2(P2+5));
    RspListD2(ci) = on/off - 1;
end
figure;
scatter(RspListD1, RspListD2, 'Marker', 'o', 'MarkerEdgeColor', [1 0.5 0], 'MarkerFaceColor', [1 0.5 0]);
hold on
plot(0:0.01:8, 0:0.01:8, 'Color', [0 0 0], 'LineWidth', 2.5, 'LineStyle', '--');
[b,bint,r,rint,stats] = regress(RspListD2', [ones(length(RspListD1), 1), RspListD1']);
plot(0:0.01:8, (0:0.01:8)*b(2)+b(1), 'Color', [1 0.5 0], 'LineWidth', 2.5)
axis([-0.3 8 -0.3 8]);
axis square
set(gca, 'LineWidth', 2, 'XTick', 0:2:8, 'YTick', 0:2:8);

set(gcf, 'PaperPositionMode', 'auto', 'OuterPosition', [500 500 400 450]);
print('laserLongTermScatter.tif', '-dtiffn', '-r0');

corrcoef(RspListD1', RspListD2')
stats
r2 = 1 - sum((RspListD2 - RspListD1).^2)/sum((RspListD2 - mean(RspListD2)).^2)
%% Long-term Orientation selectivity
clear,clc
load CCD1.mat;
CCD1 = CC;
load CCD2.mat;
CCD2 = CC;
load VisualRspListD1.mat;
load VisualRspListD2.mat;

sListD1 = [];
sListD2 = [];
k = 0;
for ci = 1:CCD1.NumObjects
    ci
    rspTemp = RspListD1(ci,:,:);
    orienTemp = zeros(size(RspListD1,2),6);
    for i = 1:6
        orienTemp(:,i) = mean(rspTemp(:, i:6:48),2);
    end
    p1 = anova1(orienTemp, {'0', '30', '60', '90', '120', '150'}, 'off');

    xdata1 = (1:size(orienTemp,2)+1)';
    ydata1 = [mean(orienTemp), mean(orienTemp(:,1))]';
%     x_se1 = [std(orienTemp), std(orienTemp(:,1))]'./sqrt(size(ONimageSVisualD1,1)-1);
    x_se1 = (1:size(orienTemp,2)+1)';

    rspTemp = RspListD2(ci,:,:);
    orienTemp = zeros(size(RspListD2,2),6);
    for i = 1:6
        orienTemp(:,i) = mean(rspTemp(:, i:6:48),2);
    end
    p2 = anova1(orienTemp, {'0', '30', '60', '90', '120', '150'}, 'off');
    
    xdata2 = (1:size(orienTemp,2)+1)';
    ydata2 = [mean(orienTemp), mean(orienTemp(:,1))]';
%     x_se2 = [std(orienTemp), std(orienTemp(:,1))]'./sqrt(size(ONimageSVisualD2,1)-1);
    x_se2 = (1:size(orienTemp,2)+1)';
    
    if p1<0.05 && p2<0.05
        k = k+1;
        [OSI1, ttamax1, se1, lsqPara1, adRsquare1] = OsiCal (xdata1, ydata1, x_se1);
        [OSI2, ttamax2, se2, lsqPara2, adRsquare2] = OsiCal (xdata2, ydata2, x_se2);
        sListD1(k) = (ttamax1-1)/6*180;
        sListD2(k) = (ttamax2-1)/6*180;
    end
end
sListD1re = zeros(1, length(sListD1));
sListD2re = zeros(1, length(sListD2));
for i = 1:length(sListD1)
    if sListD2(i) > sListD1(i)+90
        sListD1re(i) =  sListD1(i);
        sListD2re(i) =  sListD2(i) - 180;
    elseif sListD2(i) < sListD1(i)-90
        sListD1re(i) =  sListD1(i) - 180;
        sListD2re(i) =  sListD2(i);
    else
        sListD1re(i) =  sListD1(i);
        sListD2re(i) =  sListD2(i);
    end
end

figure;
scatter(sListD1re, sListD2re, 'Marker', 'o', 'MarkerEdgeColor', [1 0.5 0], 'MarkerFaceColor', [1 0.5 0]);
hold on
plot(-50:0.1:180, -50:0.1:180, 'Color', [0 0 0], 'LineWidth', 2.5, 'LineStyle', '--');
[b,bint,r,rint,stats] = regress(sListD2re', [ones(length(sListD1re), 1), sListD1re']);
plot(-50:0.1:180, (-50:0.1:180)*b(2)+b(1), 'Color', [1 0.5 0], 'LineWidth', 2.5)
axis([-50 180 -50 180]);
axis square
set(gca, 'LineWidth', 2, 'XTick', 0:45:180, 'YTick', 0:45:180);

set(gcf, 'PaperPositionMode', 'auto', 'OuterPosition', [500 500 400 450]);
print('orienSelectivityLongTermScatter.tif', '-dtiffn', '-r0');

corrcoef(RspListD1', RspListD2')
stats
r2 = 1 - sum((sListD2re - sListD1re).^2)/sum((sListD2re - mean(sListD2re)).^2)