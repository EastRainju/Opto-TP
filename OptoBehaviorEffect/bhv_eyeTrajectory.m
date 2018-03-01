clear,clc
bh = mlread;
targetColor = [0.4 0.5 0.1];

figure(2), hold on; % optbhv
for i = 1:length(bh)
    if bh(i).Condition == 1 && ismember(5, bh(i).BehavioralCodes.CodeNumbers)
        LaserOnTime = round(bh(i).BehavioralCodes.CodeTimes(find(bh(i).BehavioralCodes.CodeNumbers == 5)));
        if length(bh(i).AnalogData.Eye) > LaserOnTime+1200
            plot(bh(i).AnalogData.Eye(LaserOnTime+1000:min(LaserOnTime+1500, length(bh(i).AnalogData.Eye)),1), ...
                bh(i).AnalogData.Eye(LaserOnTime+1000:min(LaserOnTime+1500, length(bh(i).AnalogData.Eye)),2), 'Color', [0.5 0.5 1]);
        end
%         axis([-5,5,-5,5]);pause;
    end
end
plot([-1/5,1/5], [0,0], 'k', 'LineWidth', 2);
plot([0,0], [-1/5,1/5], 'k', 'LineWidth', 2);

vsSite = [3.3 -1.6];
vsx = cos(2*pi/100:2*pi/100:2*pi)*0.5+vsSite(1);
vsy = sin(2*pi/100:2*pi/100:2*pi)*0.5+vsSite(2);
plot(vsx,vsy,'--','LineWidth',1.5,'Color', targetColor);
rfSite = [0.4 -3.6];
rfx = cos(2*pi/100:2*pi/100:2*pi)*0.5+rfSite(1);
rfy = sin(2*pi/100:2*pi/100:2*pi)*0.5+rfSite(2);
plot(rfx,rfy,'--','LineWidth',1.5, 'Color', [1 0 0.5]);

axis equal
axis([-5,5,-5,5]);
box on;
set(gca, 'FontSize', 20, 'LineWidth', 2,'XTick', -5, 'YTick', -5, 'XTickLabel', [], 'YTickLabel', []);
set(gcf, 'OuterPosition', [500 500 400 400]);
% xlabel('Visual angle (degree)', 'FontSize', 20);
% ylabel('Visual angle (degree)', 'FontSize', 20);
set(gcf, 'PaperPositionMode', 'auto');
print('LineLaserOff.tif', '-dtiffn', '-r0');



figure(3), hold on; % optbhvExpT
for i = 1:length(bh)
    if bh(i).Condition == 4 && ismember(7, bh(i).BehavioralCodes.CodeNumbers)
        LaserOnTime = round(bh(i).BehavioralCodes.CodeTimes(find(bh(i).BehavioralCodes.CodeNumbers == 7)));
        plot(bh(i).AnalogData.Eye(LaserOnTime:end,1), bh(i).AnalogData.Eye(LaserOnTime:end,2), 'Color', [1 0 0.5]);
%         pause;
    end
end
plot([-1/5,1/5], [0,0], 'k', 'LineWidth', 2);
plot([0,0], [-1/5,1/5], 'k', 'LineWidth', 2);
axis equal
axis([-5,5,-5,5]);
box on;
set(gca, 'FontSize', 20, 'LineWidth', 2,'XTick', -5, 'YTick', -5, 'XTickLabel', [], 'YTickLabel', []);
set(gcf, 'OuterPosition', [500 500 400 400]);
% xlabel('Visual angle (degree)', 'FontSize', 20);
% ylabel('Visual angle (degree)', 'FontSize', 20);

vsSite = [3.3 -1.6];
vsx = cos(2*pi/100:2*pi/100:2*pi)*0.5+vsSite(1);
vsy = sin(2*pi/100:2*pi/100:2*pi)*0.5+vsSite(2);
plot(vsx,vsy,'--','LineWidth',1.5,'Color', targetColor);
rfSite = [0.4 -3.6];
rfx = cos(2*pi/100:2*pi/100:2*pi)*0.5+rfSite(1);
rfy = sin(2*pi/100:2*pi/100:2*pi)*0.5+rfSite(2);
plot(rfx,rfy,'--','LineWidth',1.5, 'Color', [1 0 0.5]);

set(gcf, 'PaperPositionMode', 'auto');
print('LineLaserOn.tif', '-dtiffn', '-r0');



figure(4), hold on; % optbhvExpC
for i = 1:length(bh)
    if bh(i).Condition == 5 && ismember(7, bh(i).BehavioralCodes.CodeNumbers)
        LaserOnTime = round(bh(i).BehavioralCodes.CodeTimes(find(bh(i).BehavioralCodes.CodeNumbers == 7)));
        plot(bh(i).AnalogData.Eye(LaserOnTime:end,1), bh(i).AnalogData.Eye(LaserOnTime:end,2), 'Color', [0 0.8 0.8]);
%         axis([-5,5,-5,5]);pause;
    end
end
plot([-1/5,1/5], [0,0], 'k', 'LineWidth', 2);
plot([0,0], [-1/5,1/5], 'k', 'LineWidth', 2);
axis equal
axis([-5,5,-5,5]);
box on;
set(gca, 'FontSize', 20, 'LineWidth', 2,'XTick', -5, 'YTick', -5, 'XTickLabel', [], 'YTickLabel', []);
set(gcf, 'OuterPosition', [500 500 400 400]);
% xlabel('Visual angle (degree)', 'FontSize', 20);
% ylabel('Visual angle (degree)', 'FontSize', 20);

vsSite = [3.3 -1.6];
vsx = cos(2*pi/100:2*pi/100:2*pi)*0.5+vsSite(1);
vsy = sin(2*pi/100:2*pi/100:2*pi)*0.5+vsSite(2);
plot(vsx,vsy,'--','LineWidth',1.5,'Color', targetColor);
rfSite = [0.4 -3.6];
rfx = cos(2*pi/100:2*pi/100:2*pi)*0.5+rfSite(1);
rfy = sin(2*pi/100:2*pi/100:2*pi)*0.5+rfSite(2);
plot(rfx,rfy,'--','LineWidth',1.5, 'Color', [1 0 0.5]);

set(gcf, 'PaperPositionMode', 'auto');
print('LineLaserAway.tif', '-dtiffn', '-r0');