close all
clear all
clc

[ PointSizes,Struct ] = CalibrateTake2Dmap(  );

ComputeTransformation( PointSizes,Struct );


clear('cam');
cam = webcam('Webcam C170');
% Create a cascade detector object.
faceDetector = vision.CascadeObjectDetector();

% Acquire a single image.
videoFrame = snapshot(cam);

bbox  = step(faceDetector, videoFrame);


% Draw the returned bounding box around the detected face.
% videoOut = insertObjectAnnotation(videoFrame,'rectangle',bbox,'Face');


% Get the skin tone information by extracting the Hue from the video frame
% converted to the HSV color space.
[hueChannel,saturChannel,~] = rgb2hsv(videoFrame);

% % Display the Hue Channel data and draw the bounding box around the face.
% figure, imshow(hueChannel), title('Hue channel data');
% rectangle('Position',bbox(1,:),'LineWidth',2,'EdgeColor',[1 1 0])

noseDetector = vision.CascadeObjectDetector('Nose', 'UseROI', true);
noseBBox     = step(noseDetector, videoFrame, bbox(1,:));

EyeDetector = vision.CascadeObjectDetector('EyePairBig', 'UseROI', true);
eyeBBox     = step(EyeDetector, videoFrame, bbox(1,:));

% Draw the returned bounding box around the detected eye pair.
% videoOutEye = insertObjectAnnotation(videoOut,'rectangle',eyeBBox,'Eyes');
    if ~isempty(eyeBBox) && ~isempty(noseBBox)
LeftEyeBox = [eyeBBox(1,1) eyeBBox(1,2) abs(noseBBox(1,1) - eyeBBox(1,1))  eyeBBox(1,4)];

RightEyeBox = [eyeBBox(1,1)+noseBBox(1,3)+LeftEyeBox(1,3) eyeBBox(1,2) eyeBBox(1,3)-LeftEyeBox(1,3)-noseBBox(1,3) eyeBBox(1,4)];

% videoOutNose = insertObjectAnnotation(videoOutEye,'rectangle',noseBBox,'Nose');
    end

figure,
imshow(videoFrame), title('Detected face');
    if ~isempty(eyeBBox) && ~isempty(noseBBox)
hold on

rectangle('Position',LeftEyeBox,...
    'LineWidth',2,'LineStyle','--');
hold on
rectangle('Position',RightEyeBox,...
    'LineWidth',2,'LineStyle','--');
hold off
   end
% Create a tracker object.
tracker = vision.HistogramBasedTracker;

tracker1 = vision.HistogramBasedTracker;
% Initialize the tracker histogram using the Hue channel pixels from the
% nose.
initializeObject(tracker, hueChannel, noseBBox(1,:));


videoPlayer  = vision.VideoPlayer('Position',[300 300 640 480]);
i=1;

% Track the face over successive video frames until the video is finished.
while i~=300
    i=i+1;
    % Extract the next video frame
    videoFrame =  snapshot(cam);
    
    % RGB -> HSV
    [hueChannel,saturChannel,~] = rgb2hsv(videoFrame);
    
    % Track using the Hue channel data
    bbox = step(tracker, hueChannel);
    noseBBox     = step(noseDetector, videoFrame, bbox(1,:));
    eyeBBox     = step(EyeDetector, videoFrame, bbox(1,:));
    
    
    
    if ~isempty(eyeBBox) && ~isempty(noseBBox)
        LeftEyeBox = [eyeBBox(1,1) eyeBBox(1,2) abs(noseBBox(1,1) - eyeBBox(1,1))  eyeBBox(1,4)];
        
        RightEyeBox = [eyeBBox(1,1)+noseBBox(1,3)+LeftEyeBox(1,3) eyeBBox(1,2) eyeBBox(1,3)-LeftEyeBox(1,3)-noseBBox(1,3) eyeBBox(1,4)];
        [rowLeft,colLeft,rowRight,colRight ]=GetPupil(videoFrame,LeftEyeBox,RightEyeBox);
        
        videoOut = insertMarker(videoFrame,[LeftEyeBox(1,1)+rowLeft(1,1) LeftEyeBox(1,2)+colLeft(1,1)]);
        
        videoOut = insertMarker(videoOut,[RightEyeBox(1,1)+rowRight(1,1) RightEyeBox(1,2)+colRight(1,1)], 'color','white');
        
        % Draw the returned bounding box around the detected eye pair.
        videoOut = insertObjectAnnotation(videoOut,'rectangle',LeftEyeBox,'Right');
        % Draw the returned bounding box around the detected eye pair.
        videoOut = insertObjectAnnotation(videoOut,'rectangle',RightEyeBox,'Left');
%         % Display the annotated video frame using the video player object
%         videoOut = insertObjectAnnotation(videoOut,'rectangle',noseBBox,'Nose');
        step(videoPlayer, videoOut);
    else
        % Display the annotated video frame using the video player object
        step(videoPlayer, videoFrame);
    end
    
end

% Release resources
release(videoPlayer);
clear('cam');