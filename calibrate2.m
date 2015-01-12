% yifei wu 2014
% Calibration for conoscope

%---------------------------------------------------------------------
clear all;

fnamesTracker = dir('pose.csv');
numfidsTracker = length(fnamesTracker);
fnamesCono = dir('pose*.txt');
numfidsCono = length(fnamesCono);
fnamesGP = dir('gp*.csv'); %calibration points either off tracked probe or board
numfidsGP = length(fnamesGP);






poseTool = zeros(numfidsTracker,7);
poseCono = zeros(1,7);
groundtruthPoint = zeros(numfidsGP,3);
conoMeasurement = zeros(numfidsCono,1);


for i = 1:numfidsGP
    
    % for the NDI file ---------
    
    fid = fopen(fnamesGP(i).name,'r'); % open the file
        if (fid ~= -1)
            InputText=textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s','delimiter',',','HeaderLines',1);
            fclose(fid);

            groundtruthData2 = [str2double(InputText{1,6}) str2double(InputText{1,7}) str2double(InputText{1,8}) str2double(InputText{1,9}) str2double(InputText{1,10}) str2double(InputText{1,11}) str2double(InputText{1,12})];
            groundtruthPoint(i,:) = [mean(groundtruthData2(:,5));mean(groundtruthData2(:,6)); mean(groundtruthData2(:,7))];

        end
    
    % for the conoscope file ....
    fid = fopen(fnamesCono(i).name,'r');                % open the file
    InputText2=textscan(fid,'%s',8,'delimiter','\t');   % extract the header
    InputText2=textscan(fid,'%f',8,'delimiter','\t');   % extract measurement
    conoMeasurement(i,:) = InputText2{1,1}(3);
    fclose(fid); 
end


% Get the conopose
fid = fopen('pose1.csv','r'); % open the file
if (fid ~= -1)
    InputText=textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s','delimiter',',','HeaderLines',1);% pose for conoscope and tool    
    tempData = [str2double(InputText{1,6}) str2double(InputText{1,7}) str2double(InputText{1,8}) str2double(InputText{1,9}) str2double(InputText{1,10}) str2double(InputText{1,11}) str2double(InputText{1,12})];
    poseCono(1,:) = mean(tempData,1);
    fclose(fid);
end


d = [0 0 0]';
gp=zeros(2,3);
gp(1,:)=groundtruthPoint(1,:);
gp(2,:)=groundtruthPoint(2,:);

% 
% direction= groundtruthPoint1-groundtruthPoint2; %far-near?
% direction=direction/norm(direction);

%--------------



n = numfidsCono;
m = zeros(4,4,n); % pose_drb_in_camera

for a=1:1
    m(:,:,a) = inv(amq(poseCono(1,:)));
end
distance = conoMeasurement';



p=zeros(4,n);
for a=1:2
    p(:,a)=(m(:,:,1))*[gp(a,:) 1]';
end
origin=zeros(4,3);
direction = p(:,1)-p(:,2);
direction(4)=[];
direction=direction/norm(direction);
origin=p(1:3,1)-direction*distance(1);





fid = fopen('cono.ini', 'w');
    fprintf(fid, '%6.5f %6.5f %6.5f %6.5f %6.5f %6.5f\n', origin, direction);
    fclose(fid);

     
fprintf('Calibration Results\n');
origin 
direction


