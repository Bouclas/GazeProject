function [ PointSizes,Struct ] = CalibrateTake2Dmap( input_args )
PointSizes=zeros(9,4);
Struct(9).Im=0;
cam = webcam('Webcam C170');

f = figure;
set(f, 'MenuBar', 'none');
set(f, 'ToolBar', 'none');

movegui(f,'center');
pos = get(gcf,'pos');
set(gcf,'pos',[pos(1) pos(2) 9 9])
p = get(gcf, 'Position');
PointSizes(1,:)=p;
pause(4)
videoFrame = snapshot(cam);
Struct(1).Im=videoFrame;
pause(3)
% Acquire a single image.


movegui(f,'south');
p = get(gcf, 'Position');
PointSizes(2,:)=p;
pause(4)
videoFrame = snapshot(cam);
Struct(2).Im=videoFrame;
pause(3)

movegui(f,'southwest');
p = get(gcf, 'Position');
PointSizes(3,:)=p;
pause(4)
videoFrame = snapshot(cam);
Struct(3).Im=videoFrame;
pause(3)

movegui(f,'west');
p = get(gcf, 'Position');
PointSizes(4,:)=p;
pause(4)
videoFrame = snapshot(cam);
Struct(4).Im=videoFrame;
pause(3)

movegui(f,'northwest');
p = get(gcf, 'Position');
PointSizes(5,:)=p;
pause(4)
videoFrame = snapshot(cam);
Struct(5).Im=videoFrame;
pause(3)

movegui(f,'north');
p = get(gcf, 'Position');
PointSizes(6,:)=p;
pause(4)
videoFrame = snapshot(cam);
Struct(6).Im=videoFrame;
pause(3)

movegui(f,'northeast');
p = get(gcf, 'Position');
PointSizes(7,:)=p;
pause(4)
videoFrame = snapshot(cam);
Struct(7).Im=videoFrame;
pause(3)

movegui(f,'east');
p = get(gcf, 'Position');
PointSizes(8,:)=p;
pause(4)
videoFrame = snapshot(cam);
Struct(8).Im=videoFrame;
pause(3)

movegui(f,'southeast');
p = get(gcf, 'Position');
PointSizes(9,:)=p;
pause(4)
videoFrame = snapshot(cam);
Struct(9).Im=videoFrame;
pause(3)

movegui(f,'center');
set(gcf,'pos',[pos(1) pos(2) 25 25])


close(f)
clear('cam')
end

