function [ output_args ] = ComputeTransformation( PointSizes,Struct )
faceDetector = vision.CascadeObjectDetector('FrontalFaceLBP');

%--------- Find eye centers-----------------------------------------------

for i=1:1
    videoFrame=Struct(i).Im;
    bbox  = step(faceDetector, videoFrame);
    
    noseDetector = vision.CascadeObjectDetector('Nose', 'UseROI', true);
    noseBBox     = step(noseDetector, videoFrame, bbox(1,:));
    
    
    EyeDetector = vision.CascadeObjectDetector('EyePairBig', 'UseROI', true);
    eyeBBox     = step(EyeDetector, videoFrame, bbox(1,:));
    
    
    if ~isempty(eyeBBox) && ~isempty(noseBBox)
        
        LeftEyeBox = [eyeBBox(1,1) eyeBBox(1,2) abs(noseBBox(1,1) - eyeBBox(1,1))  eyeBBox(1,4)];
        
        RightEyeBox = [eyeBBox(1,1)+noseBBox(1,3)+LeftEyeBox(1,3) eyeBBox(1,2) eyeBBox(1,3)-LeftEyeBox(1,3)-noseBBox(1,3) eyeBBox(1,4)];
        
        [rowLeft,colLeft,rowRight,colRight ]=GetPupil(videoFrame,LeftEyeBox,RightEyeBox);
        
        
        
        videoFrame = insertMarker(videoFrame,[LeftEyeBox(1,1)+rowLeft(1,1) LeftEyeBox(1,2)+colLeft(1,1)]);
        
        videoFrame = insertMarker(videoFrame,[RightEyeBox(1,1)+rowRight(1,1) RightEyeBox(1,2)+colRight(1,1)], 'color','white');
        
        
        clear LeftEyeBox RightEyeBox
    end
    figure,
    imshow(videoFrame), title('Detected face');
end


end

