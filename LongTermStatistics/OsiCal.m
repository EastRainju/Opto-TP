function [OSI, ttamax, se, lsqPara, adRsquare] = OsiCal (xdata, ydata, x_se)
% Edited 20170315 JNS
% 20170316 add R-square
% Lsqnonlin, confident interval, OSI

% tta = 1:length(y)+1;
% myfittype = fittype('a*exp(-k*(cos(tta - tta0)-1))',... 
%     'dependent', {'y'}, 'independent', {'tta'},... 
%     'coefficients', {'a', 'k', 'tta0'});
% coeffnames(myfittype)
% myfit = fit(tta', [-y'; -y(1)], myfittype, 'StartPoint', [1, 1, 0]);
% plot(myfit,tta,[-y -y(1)]);
len = length(xdata);
g = @(para) ((para(1)*exp(-para(2)*(cos((xdata - para(3))*2*pi/(length(xdata)-1))-1)) - ydata)./x_se);
options = optimoptions('lsqnonlin','Display','none');
[lsqPara,~,residual,~,~,~,jacobian_fit] = lsqnonlin(g, [1 1 1], [], [], options);

chisq = residual'*residual;%chi square
deg_free = size(jacobian_fit, 1) - size(jacobian_fit, 2);%degree of freedom
covar = inv(jacobian_fit'*jacobian_fit)*chisq/deg_free;
var = diag(covar);
se = sqrt(var)';%standard error
correl = covar./(se'*se);

a = lsqPara(1); k = lsqPara(2); tta0 = lsqPara(3);
myfitfun = @(tta) (a*exp(-k*(cos((tta - tta0)*2*pi/(length(xdata)-1))-1)));
% plot(linspace(xdata(1), xdata(end), 1000), myfitfun(linspace(xdata(1), xdata(end), 1000)), 'k', xdata, ydata, 'r');

predictY = myfitfun(xdata);
SSE = sum((ydata-predictY).^2);
SST = sum((ydata-mean(ydata)).^2);
Rsquare = 1-SSE/SST;
adRsquare = 1- (1-Rsquare)*(size(jacobian_fit,1)-1)./(size(jacobian_fit,1)-size(jacobian_fit,2)-1);

negfitfun = @(tta) -(a*exp(-k*(cos((tta - tta0)*2*pi/(length(xdata)-1))-1)));
[ttamax, negymax] = fminbnd(negfitfun, 1, len);
Fmax = -negymax;

if ttamax > (len+1)/2
    ttaOrtho = ttamax - (len+1)/2;
else
    ttaOrtho = ttamax + (len+1)/2;
end
Fortho = myfitfun(ttaOrtho);
deltaF = Fmax - Fortho;
OSI = abs((deltaF/Fmax-deltaF/Fortho)/(deltaF/Fmax+deltaF/Fortho));

% title({['param standard error : ' num2str(se)], ['osi : ' num2str(OSI)]});
end
