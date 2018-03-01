%% Orientation tunning total neurons
clear,clc
load CCtotal.mat;
CCD1 = CCtotal;
load VisualRspListD1.mat;

k1 = 0;
rspList1 = zeros(CCD1.NumObjects, 1200);
ttamaxList1 = zeros(1, CCD1.NumObjects);
for ci = 1:CCD1.NumObjects
    ci
    rspTemp = squeeze(RspListD1(ci,:,:));
    orienTemp = zeros(size(rspTemp,1),6);
    for i = 1:6
        orienTemp(:,i) = mean(rspTemp(:, i:6:48),2);
    end
    p1 = anova1(orienTemp, {'0', '30', '60', '90', '120', '150'}, 'off');
    
    if p1<0.05
        k1 = k1+1;
        xdata1 = (1:size(orienTemp,2)+1)';
        ydata1 = [mean(orienTemp), mean(orienTemp(:,1))]';
        x_se1 = (1:size(orienTemp,2)+1)';
        [OSI1, ttamax1, se1, lsqPara1, adRsquare1] = OsiCal (xdata1, ydata1, x_se1);
        
        a = lsqPara1(1); k = lsqPara1(2); tta0 = lsqPara1(3);
        myfitfun = @(tta) (a*exp(-k*(cos((tta - tta0)*2*pi/(length(xdata1)-1))-1)));
        % plot(linspace(xdata1(1), xdata1(end), 1200), myfitfun(linspace(xdata1(1), xdata1(end), 1200)), 'k', xdata1, ydata1, 'r');
        rspList1(k1, :) = myfitfun(linspace(xdata1(1), xdata1(end), 1200));
        ttamaxList1(k1) = ttamax1;
    end
end
figure;hold on
rspS1 = zeros(1, 1200);
for i = 1:k1
    rspTemp = zeros(1, 1200);
    if ttamaxList1(i) <= 4
        dis = round((4-ttamaxList1(i))/6*1200);
        rspTemp(1:dis) = rspList1(i, end-dis+1:end);
        rspTemp(dis+1:end) = rspList1(i, 1:end-dis);
    else
        dis = round((ttamaxList1(i)-4)/6*1200);
        rspTemp(1:end-dis) = rspList1(i, dis+1:end);
        rspTemp(end-dis+1:end) = rspList1(i, 1:dis);
    end
    plot(rspTemp, 'Color', [0.5 0.5 0.5], 'LineWidth', 1);
    rspS1 = rspS1 + rspTemp;
end
plot(rspS1/k1, 'Color', [1 0.5 0], 'LineWidth', 4);
axis([0 1200 -0.1 3.5]);
set(gca, 'LineWidth', 2, 'XTick', 0:200:1200, 'XTickLabel', -90:30:90, 'YTick', 0:1:3);

set(gcf, 'PaperPositionMode', 'auto', 'OuterPosition', [500 500 580 450]);
print('TotalCellOrienTuning.tif', '-dtiffn', '-r0');