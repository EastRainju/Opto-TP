%% bhv eye position -- laser on
clear,clc
bh = mlread;
laseronEyeX = [];
laseronEyeY = [];
conList = [];
deltaRT = [];
for i = 1:length(bh)
    if bh(i).Condition == 4 && ismember(7, bh(i).BehavioralCodes.CodeNumbers) %&& ismember(12, bh(i).BehavioralCodes.CodeNumbers)
        conList = [conList i];
        LaserOnTime = round(bh(i).BehavioralCodes.CodeTimes(find(bh(i).BehavioralCodes.CodeNumbers == 7)));
%         ReactTime = round(bh(i).BehavioralCodes.CodeTimes(find(bh(i).BehavioralCodes.CodeNumbers == 12)));
%         if ReactTime-LaserOnTime > 50
%             deltaRT = [deltaRT, ReactTime-LaserOnTime];
            xtempMat = zeros(1, 600);
            ytempMat = zeros(1, 600);
            xtempMat(1:min(length(bh(i).AnalogData.Eye)-LaserOnTime+1,500)+100) = bh(i).AnalogData.Eye(LaserOnTime-100:min(length(bh(i).AnalogData.Eye),499+LaserOnTime),1);
            ytempMat(1:min(length(bh(i).AnalogData.Eye)-LaserOnTime+1,500)+100) = bh(i).AnalogData.Eye(LaserOnTime-100:min(length(bh(i).AnalogData.Eye),499+LaserOnTime),2);
            laseronEyeX = [laseronEyeX; xtempMat];
            laseronEyeY = [laseronEyeY; ytempMat];
        for j = 1:length(xtempMat)
            if xtempMat(j)^2 + ytempMat(j)^2 > 1^2
                if j > 100
                    deltaRT = [deltaRT, j-100];
                end
                break;
            end
        end
%         end
    end
end
figure;
for i = 1:size(laseronEyeX,1)
    plot(laseronEyeY(i,:));hold on
end
% set(gca, 'YLim', [-1 1])
mean(deltaRT)
std(deltaRT)/sqrt(length(deltaRT))

figure(4); hold on
set(gcf, 'OuterPosition', [500 500 450 320]);
cdur = 198;
for i = 1:1%ceil(mean(deltaRT)/cdur)
    fill([100+(i-1)*cdur, 100+(i-1)*cdur, min(100+(i-1)*cdur+cdur/3, mean(deltaRT)+100), min(100+(i-1)*cdur+cdur/3, mean(deltaRT)+100)], [-4.8, 1.4, 1.4, -4.8], [.85 .85 .85], 'EdgeColor', 'none');
%     plot([100+(i-1)*cdur, 100+(i-1)*cdur], [-4.8, 1.4], 'k--');
%     plot([min(100+(i-1)*cdur+cdur/3, mean(deltaRT)+100), min(100+(i-1)*cdur+cdur/3, mean(deltaRT)+100)], [-4.8, 1.4], 'k--');
%     plot([100+(i-1)*cdur, min(100+(i-1)*cdur+cdur/3, mean(deltaRT)+100)], [1.4, 1.4], 'k--');
%     plot([100+(i-1)*cdur, min(100+(i-1)*cdur+cdur/3, mean(deltaRT)+100)], [-4.8, -4.8], 'k--');
end
% plot([mean(deltaRT)+101, mean(deltaRT)+101], [-3.9, 2.3], 'Color', [0 0 0], 'LineWidth', 2, 'LineStyle', '--');
for i = 1:size(laseronEyeX,1)
    plot(laseronEyeX(i,:), 'Color', [1 0.5 0]);
    plot(laseronEyeY(i,:), 'Color', [0 0.5 1]);
end
axis([51 450 -5 1.6]);
set(gca, 'LineWidth', 2, 'FontSize', 20, 'XTick', 100:100:400, 'XTickLabel', 0:100:300);
xlabel('Time (ms)', 'FontSize', 20);
ylabel('Eye site (deg)', 'FontSize', 20);
set(gcf, 'PaperPositionMode', 'auto');
print('LaserOnEyeX&Y-66ms-total.tif', '-dtiffn', '-r0');

% sqrt(x^2 + y^2)
figure(5); hold on
set(gcf, 'OuterPosition', [500 500 450 330]);
fill([101, 101, 166, 166], [0.1, 3.9, 3.9, 0.1], [.85 .85 .85], 'EdgeColor', 'none');
eyeDis = zeros(size(laseronEyeX,1), 600);
for i = 1:size(laseronEyeX,1)
    eyeDis(i, :) = sqrt(laseronEyeX(i,:).^2 + laseronEyeY(i,:).^2);
end
eyeDisMean = mean(eyeDis);
eyeDisSe = std(eyeDis)./sqrt(size(laseronEyeX,1));
fill([1:600, 600:-1:1], ... 
    [eyeDisMean-eyeDisSe, fliplr(eyeDisMean+eyeDisSe)], [1 0.6 0.9], 'EdgeColor', 'none');
plot(eyeDisMean, 'Color', [1 0 0.5], 'LineWidth', 2);
eyeBIdx = 0;
for i = 1:size(eyeDisMean,2)
    if eyeDisMean(i) > 1
        eyeBIdx = i;
        break;
    end
end
plot([eyeBIdx eyeBIdx], [0.2 2], 'Color', [0 0 0], 'LineWidth', 2);
text(250, 1.5, num2str(eyeBIdx-100));
axis([81 280 0 4]);
set(gca, 'LineWidth', 2, 'FontSize', 20, 'XTick', 100:50:250, 'XTickLabel', 0:50:150);
xlabel('Time (ms)', 'FontSize', 20);
ylabel('Eye site (deg)', 'FontSize', 20);
set(gcf, 'PaperPositionMode', 'auto');
print('LaseronEyeDis-mean.tif', '-dtiffn', '-r0');
%% bhv eye position -- laser away
clear,clc
bh = mlread;
laserawayEyeX = [];
laserawayEyeY = [];
conList = [];
for i = 1:length(bh)
    if bh(i).Condition == 5 && ismember(7, bh(i).BehavioralCodes.CodeNumbers)
        conList = [conList i];
        LaserOnTime = round(bh(i).BehavioralCodes.CodeTimes(find(bh(i).BehavioralCodes.CodeNumbers == 7)));
        xtempMat = zeros(1, 600);
        ytempMat = zeros(1, 600);
        xtempMat(1:min(length(bh(i).AnalogData.Eye)-LaserOnTime+1,500)+100) = bh(i).AnalogData.Eye(LaserOnTime-100:min(length(bh(i).AnalogData.Eye),499+LaserOnTime),1);
        ytempMat(1:min(length(bh(i).AnalogData.Eye)-LaserOnTime+1,500)+100) = bh(i).AnalogData.Eye(LaserOnTime-100:min(length(bh(i).AnalogData.Eye),499+LaserOnTime),2);
        laserawayEyeX = [laserawayEyeX; xtempMat];
        laserawayEyeY = [laserawayEyeY; ytempMat];
    end
end
deltaRT = 500;
for i = 1:size(laserawayEyeX,1)
    plot(laserawayEyeX(i,:));hold on
end
% set(gca, 'YLim', [-1 1])

figure(4); hold on
set(gcf, 'OuterPosition', [500 500 450 320]);
for i = 1:2:ceil(mean(deltaRT)*30/1000)
    fill([100+(i-1)*1000/30, 100+(i-1)*1000/30, min(100+(i-1)*1000/30+22, mean(deltaRT)+100), min(100+(i-1)*1000/30+22, mean(deltaRT)+100)], [-3.9, 2.3, 2.3, -3.9], [.85 .85 .85], 'EdgeColor', 'none');
    plot([100+(i-1)*1000/30, 100+(i-1)*1000/30], [-3.9, 2.3], 'k--');
    plot([100+(i-1)*1000/30, min(100+(i-1)*1000/30+22, mean(deltaRT)+100)], [2.3, 2.3], 'k--');
    plot([min(100+(i-1)*1000/30+22, mean(deltaRT)+100), min(100+(i-1)*1000/30+22, mean(deltaRT)+100)], [2.3, -3.9], 'k--');
    plot([min(100+(i-1)*1000/30+22, mean(deltaRT)+100), 100+(i-1)*1000/30], [-3.9, -3.9], 'k--');
end
for i = 1:size(laserawayEyeX,1)
    plot(laserawayEyeX(i,:), 'Color', [1 0.5 0]);
    plot(laserawayEyeY(i,:), 'Color', [0 0.5 1]);
end
axis([51 450 -4.1 2.5]);
set(gca, 'LineWidth', 2, 'FontSize', 20, 'XTick', 100:100:400, 'XTickLabel', 0:100:300);
xlabel('Time (ms)', 'FontSize', 20);
ylabel('Eye site (deg)', 'FontSize', 20);
set(gcf, 'PaperPositionMode', 'auto');
print('LaserAwayEyeX&Y-66ms-total.tif', '-dtiffn', '-r0');
%% bhv eye position -- laser off
clear,clc
bh = mlread;
laseroffEyeX = [];
laseroffEyeY = [];
conList = [];
for i = 1:length(bh)
    if bh(i).Condition == 1 && ismember(5, bh(i).BehavioralCodes.CodeNumbers)
        conList = [conList i];
        LaserOnTime = round(bh(i).BehavioralCodes.CodeTimes(find(bh(i).BehavioralCodes.CodeNumbers == 5)));
        if length(bh(i).AnalogData.Eye) > LaserOnTime+1000
            xtempMat = zeros(1, 600);
            ytempMat = zeros(1, 600);
            xtempMat(1:min(length(bh(i).AnalogData.Eye)-LaserOnTime-1000+1,500)+100) = bh(i).AnalogData.Eye(LaserOnTime+901:min(length(bh(i).AnalogData.Eye),1500+LaserOnTime),1);
            ytempMat(1:min(length(bh(i).AnalogData.Eye)-LaserOnTime-1000+1,500)+100) = bh(i).AnalogData.Eye(LaserOnTime+901:min(length(bh(i).AnalogData.Eye),1500+LaserOnTime),2);
            laseroffEyeX = [laseroffEyeX; xtempMat];
            laseroffEyeY = [laseroffEyeY; ytempMat];
        end
    end
end
% for i = 1:size(laseroffEyeX,1)
%     plot(laseroffEyeX(i,:));hold on
% end
% set(gca, 'YLim', [-1 1])

figure(4); hold on
set(gcf, 'OuterPosition', [500 500 450 320]);
for i = 1:size(laseroffEyeX,1)
    plot(laseroffEyeX(i,:), 'Color', [1 0.5 0]);
    plot(laseroffEyeY(i,:), 'Color', [0 0.5 1]);
end
axis([51 450 -2.5 4.1]);
set(gca, 'LineWidth', 2, 'FontSize', 20, 'XTick', 100:100:400, 'XTickLabel', 0:100:300);
xlabel('Time (ms)', 'FontSize', 20);
ylabel('Eye site (deg)', 'FontSize', 20);
set(gcf, 'PaperPositionMode', 'auto');
print('LaserOffEyeX&Y-total.tif', '-dtiffn', '-r0');