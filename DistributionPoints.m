imagefiles = dir('./MUCTimages/jpg/*.jpg');

faceDetector = vision.CascadeObjectDetector();


noseDetector = vision.CascadeObjectDetector('Nose', 'UseROI', true);


EyeDetector = vision.CascadeObjectDetector('EyePairBig', 'UseROI', true);


%Load images
nfiles = length(imagefiles);    % Number of files found
for ii=1:nfiles
    currentfilename = imagefiles(ii).name;
    filename =strcat('.\MUCTimages\jpg\',currentfilename);
    currentimage = imread(filename);
    images{ii} = currentimage;
end

EyesYCBCRvalues=zeros(nfiles,3);
SkinYCBCRvalues=zeros(nfiles,3);
i=1;
for ii=1:nfiles
    
    imageCur=images{ii};
    bbox  = step(faceDetector, imageCur);
    if ~isempty(bbox)
    noseBBox     = step(noseDetector, imageCur, bbox(1,:));
    eyeBBox     = step(EyeDetector, imageCur, bbox(1,:));
    
    if ~isempty(eyeBBox) && ~isempty(noseBBox)
 
        LeftEyeBox = [eyeBBox(1,1) eyeBBox(1,2) abs(noseBBox(1,1) - eyeBBox(1,1)+10)  eyeBBox(1,4)];
        RightEyeBox = [eyeBBox(1,1)+abs(noseBBox(1,1) - eyeBBox(1,1))+noseBBox(1,3)-10 eyeBBox(1,2) abs(eyeBBox(1,3)-noseBBox(1,3)-abs(noseBBox(1,1) - eyeBBox(1,1)))+10  eyeBBox(1,4)];
        
        %Conver RGB to YCbCr
        YCBCR = rgb2ycbcr(imageCur);
        clear eyeLeftYCbCr
        clear eyeRightYCbCr
        %Get the regions
        eyeLeftYCbCr=YCBCR(LeftEyeBox(1,2):LeftEyeBox(1,2)+LeftEyeBox(1,4),LeftEyeBox(1,1):LeftEyeBox(1,1)+LeftEyeBox(1,3),:);
        
        eyeRightYCbCr=YCBCR(RightEyeBox(1,2):RightEyeBox(1,2)+RightEyeBox(1,4),RightEyeBox(1,1):RightEyeBox(1,1)+RightEyeBox(1,3),:);
         
        %For the eyes Biatch
       
        EyesYCBCRvalues(i,1)=(mean(mean(eyeLeftYCbCr(:,:,1)))+mean(mean(eyeRightYCbCr(:,:,1))))/2;
        EyesYCBCRvalues(i,2)=(mean(mean(eyeLeftYCbCr(:,:,2)))+mean(mean(eyeRightYCbCr(:,:,2))))/2;
        EyesYCBCRvalues(i,3)=(mean(mean(eyeLeftYCbCr(:,:,3)))+mean(mean(eyeRightYCbCr(:,:,3))))/2;
        
        SkinYCBCRvalues(i,1)=mean(mean(YCBCR( bbox(1,2):bbox(1,2)+ bbox(1,4), bbox(1,1): bbox(1,1)+ bbox(1,3),1)));
        SkinYCBCRvalues(i,2)=mean(mean(YCBCR( bbox(1,2):bbox(1,2)+ bbox(1,4), bbox(1,1): bbox(1,1)+ bbox(1,3),2)));
        SkinYCBCRvalues(i,3)=mean(mean(YCBCR( bbox(1,2):bbox(1,2)+ bbox(1,4), bbox(1,1): bbox(1,1)+ bbox(1,3),3)));
        i=i+1;
        
    end
    end
%         figure,
%         imshow(imageCur), title('Detected face');
%     
%         hold on
%         rectangle('Position',LeftEyeBox,...
%             'LineWidth',2,'LineStyle','--');
%         hold on
%         rectangle('Position',RightEyeBox,...
%             'LineWidth',2,'LineStyle','--');
%         hold off
    
    
end