function [ rowLeft,colLeft,rowRight,colRight] = GetPupil(image,eyeLeft,eyeRight)

%Conver RGB to YCbCr
YCBCR = rgb2ycbcr(image);
gray=rgb2gray(image);

%Get the regions
eyeLeftYCbCr=YCBCR(eyeLeft(1,2):eyeLeft(1,2)+eyeLeft(1,4),eyeLeft(1,1):eyeLeft(1,1)+eyeLeft(1,3),:);

eyeRightYCbCr=YCBCR(eyeRight(1,2):eyeRight(1,2)+eyeRight(1,4),eyeRight(1,1):eyeRight(1,1)+eyeRight(1,3),:);

%Construct the EyemapC - Left
CbnormLeft=double(eyeLeftYCbCr(:,:,2))./double(max(max(eyeLeftYCbCr(:,:,2))));
CRnormLeft=double(eyeLeftYCbCr(:,:,3))./double(max(max(eyeLeftYCbCr(:,:,3))));


CRcomplement = imcomplement(CRnormLeft);
CRcomplement_norm=double(CRcomplement)./double(max(max(CRcomplement)));

LeftEyemapCLeft=((CRcomplement_norm).^2+CbnormLeft.^2+double(CbnormLeft)./double(CRnormLeft))/3;

%--Left EyeMapI
SEleft = strel('disk',round(eyeLeft(1,3)/10));
IM1 = imdilate(LeftEyemapCLeft,SEleft);
SE1left = strel('disk',round((eyeLeft(1,3)/10)/2));
IM2 = imerode(gray(eyeLeft(1,2):eyeLeft(1,2)+eyeLeft(1,4),eyeLeft(1,1):eyeLeft(1,1)+eyeLeft(1,3),:),SE1left);

LeftEyemapILeft=double(IM1)./double(IM2);

% S- Luminance
 f_l = frst2d(gray(eyeLeft(1,2):eyeLeft(1,2)+eyeLeft(1,4),eyeLeft(1,1):eyeLeft(1,1)+eyeLeft(1,3),:), 13, 2, 0.1, 'both');

%  f_l = FRST(gray(eyeLeft(1,2):eyeLeft(1,2)+eyeLeft(1,4),eyeLeft(1,1):eyeLeft(1,1)+eyeLeft(1,3),:),5);

%S - EyemapI
 f_eyeI = frst2d(LeftEyemapILeft, 20, 2, 0.1, 'both');
%  f_eyeI = FRST(LeftEyemapILeft,5);
Stotal=(f_l+f_eyeI);

[rowLeft, colLeft]=find(Stotal==max(max(Stotal)))


%-------------Construct the EyemapC - Right
CbnormRight=double(eyeRightYCbCr(:,:,2))./double(max(max(eyeRightYCbCr(:,:,2))));
CRnormRight=double(eyeRightYCbCr(:,:,3))./double(max(max(eyeRightYCbCr(:,:,3))));

CRcomplement = imcomplement(CRnormRight);
CRcomplement_norm=double(CRcomplement)./double(max(max(CRcomplement)));

EyemapCRight=((CRcomplement_norm).^2+CbnormRight.^2+double(CbnormRight)./double(CRnormRight))/3;

SERight = strel('disk',round(eyeRight(1,3)/10));
IM1 = imdilate(EyemapCRight,SERight);
SE1Right = strel('disk',round((eyeRight(1,3)/10)/2));
%--Right EyeMapI

IM2 = imerode(gray(eyeRight(1,2):eyeRight(1,2)+eyeRight(1,4),eyeRight(1,1):eyeRight(1,1)+eyeRight(1,3),:),SE1Right);

EyemapIRight=double(IM1)./double(IM2);


% S- Luminance
f_lR = frst2d(gray(eyeRight(1,2):eyeRight(1,2)+eyeRight(1,4),eyeRight(1,1):eyeRight(1,1)+eyeRight(1,3),:), 13, 2, 0.1, 'both');
%  f_lR = FRST(gray(eyeRight(1,2):eyeRight(1,2)+eyeRight(1,4),eyeRight(1,1):eyeRight(1,1)+eyeRight(1,3),:),5);
%S - EyemapI
f_eyeIR = frst2d(EyemapIRight, 20, 2, 0.1, 'both');
%  f_eyeIR = FRST(EyemapIRight,5);
Stotal=(f_lR+f_eyeIR);

[rowRight, colRight]=find(Stotal==max(max(Stotal)))
%--------------------------------------------------------------------------


end

