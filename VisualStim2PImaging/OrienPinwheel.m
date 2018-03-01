%% colormap raw data & pinwheel
clear,clc
bof=0;  % (blood vessal ON-1/OFF-0) weight from original pic
colornum = 6;

load ONimage.mat; load OFFimage.mat;
OTim = zeros(6,512,512);
oTim = ONimage - OFFimage;
for i = 1:6
    OTim(i,:,:) = squeeze(mean(oTim(i:6:48,:,:)));
end
OTmap1=zeros(512,512,3);
colorOT = hsv(colornum);
for oti=1:colornum
    %H = fspecial('gaussian',100,10);
    imY2 = double(squeeze(OTim(oti,:,:)));%imfilter(double(squeeze(OTim(oti,:,:))),H);
    OTmap1(:,:,1)=OTmap1(:,:,1)+squeeze(colorOT(oti,1)*imY2);
    OTmap1(:,:,2)=OTmap1(:,:,2)+squeeze(colorOT(oti,2)*imY2);    
    OTmap1(:,:,3)=OTmap1(:,:,3)+squeeze(colorOT(oti,3)*imY2);
end

% norIdx = max(cat(3, ones(512)*1000, max(OTmap1, [], 3)), [], 3);
% OOTmap1 = OTmap1./(cat(3, norIdx, norIdx, norIdx));

figure(1);
imshow(OTmap1/800);
saveas(gcf, 'colormapraw.tif');

OTimFlt=zeros(colornum,512,512);
H = fspecial('gaussian',150,30);
for oti=1:colornum
    OTimFlt(oti,:,:) = imfilter(double(squeeze(OTim(oti,:,:))),H);
end

xa=0;
ya=0;
la=0;
anga=0;
pi1=3.1415926535;
th=(0:colornum*2-1)*pi1*2/colornum;
ax=zeros(512,512);
ay=zeros(512,512);
a37=zeros(512,512);

for i=1:512
    for j=1:512
        xa=0;
        ya=0;
        anga=0;
        for ii=1:colornum*2
            if ii<colornum+1
                xa=xa+ OTimFlt(ii,i,j)*cos(th(ii));
                ya=ya+ OTimFlt(ii,i,j)*sin(th(ii));
            else
                xa=xa+ OTimFlt(ii-colornum,i,j)*cos(th(ii));
                ya=ya+ OTimFlt(ii-colornum,i,j)*sin(th(ii));
            end
        end
        ax(i,j)=xa;
        ay(i,j)=ya;
        la=sqrt(xa*xa+ya*ya);
        if la>0
            if ya>=0
                anga=acos(xa/la);
            end
            if ya<0
                anga=2*pi-acos(xa/la);
            end     
        end
        a37(i,j)=anga/pi/2;
    end
end

OTmap=zeros(512,512,3);
colorOT = hsv(21);
nh = size(colorOT, 1);
for i=1:512
    for j=1:512
        if bof == 1
            OTmap(i,j,1)=squeeze(colorOT(round(a37(i,j)*(nh-1)+1),1))*sum(OTimFlt(:,i,j));     
            OTmap(i,j,2)=squeeze(colorOT(round(a37(i,j)*(nh-1)+1),2))*sum(OTimFlt(:,i,j));     
            OTmap(i,j,3)=squeeze(colorOT(round(a37(i,j)*(nh-1)+1),3))*sum(OTimFlt(:,i,j));  
        else
            OTmap(i,j,1)=squeeze(colorOT(round(a37(i,j)*(nh-1)+1),1));
            OTmap(i,j,2)=squeeze(colorOT(round(a37(i,j)*(nh-1)+1),2));
            OTmap(i,j,3)=squeeze(colorOT(round(a37(i,j)*(nh-1)+1),3));
        end
    end
end

OTmapDn0411=OTmap;
figure(2);
imshow(OTmapDn0411);
saveas(gcf, 'color-pinwheel.tif');