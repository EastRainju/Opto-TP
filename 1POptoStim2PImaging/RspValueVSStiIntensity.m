%% Response value V.S. optical stimuli intensity
% Series No. -- Laser Intensity
%       771  -- 1.2 mW
%       778  -- 0.8 mW
%       782  -- 0.6 mW
%       786  -- 0.4 mW
%       789  -- 0.2 mW
clear,clc
load targetCellList.mat;
fnPack = dir(pwd);
for i = 1:length(fnPack)
    if strcmp('optsti-771.mat', fnPack(i).name)
        break;
    end
end
optstiList = i:i+4;
for i = 1:length(fnPack)
    if strcmp('optstiend-771.mat', fnPack(i).name)
        break;
    end
end
optstiendList = i:i+4;
for i = 1:length(fnPack)
    if strcmp('solocellrsp-771.mat', fnPack(i).name)
        break;
    end
end
solocellrspnormList = i:i+4;
CellRspTotal = zeros(5, length(targetCellList));
for i = 1:5
    i
    load(fnPack(optstiList(i)).name);
    load(fnPack(optstiendList(i)).name);
    load(fnPack(solocellrspnormList(i)).name);
    for t = 1:length(targetCellList)
        ci = targetCellList(t);
        rspTemp = zeros(1, length(optsti));
        for j = 1:length(optsti)
            rspTemp(j) = mean(solocellrsp(ci, optstiend(j)-8:optstiend(j)+7))/mean(solocellrsp(ci, optsti(j)-15:optsti(j)))-1;
        end
        CellRspTotal(i, ci) = mean(rspTemp);
    end
end

figure(1); hold on;
set(gcf, 'OuterPosition', [500 500 500 400]);
fill([1:4, 6, 6, 4:-1:1], ... 
    [fliplr(mean(CellRspTotal(:,targetCellList),2)' - stdList/(sqrt(length(targetCellList)))), ... 
    mean(CellRspTotal(:,targetCellList),2)' + stdList/(sqrt(length(targetCellList)))], [0.6 0.6 1], 'EdgeColor', 'none');
hold on
plot([6, 4:-1:1], mean(CellRspTotal(:,targetCellList),2), 'LineWidth', 2, 'Color', [0.4,0.4,0.7]);
axis([0.5 6.5 -0.1 1.2]);
set(gca, 'XTick', [1:4, 6], 'XTickLabel', [0.2:0.2:0.8, 1.2], 'FontSize', 20, 'LineWidth', 2);
xlabel('Laser intensity (mW/mm^2)', 'FontSize', 20);
ylabel('¦¤F/F', 'FontSize', 20);

set(gcf, 'PaperPositionMode', 'auto');
print('LaserIntensity.tif', '-dtiffn', '-r0');