% Author: Jessica Burgner
% Vanderbilt University, 2011

% Accuracy Evaluation
clear all;
%Read Calibration
fid = fopen('cono.ini','r');

InputText=textscan(fid,'%f',6);
fclose(fid);
origin = [InputText{1,1}(1);InputText{1,1}(2);InputText{1,1}(3)];
direction = [InputText{1,1}(4);InputText{1,1}(5);InputText{1,1}(6)];

% Read Measurement
fnamesTracker = dir('tracking*.csv');
numfidsTracker = length(fnamesTracker);
fnamesCono = dir('results*.txt');
numfidsCono = length(fnamesCono);

poseCono = zeros(numfidsTracker,7);
conoMeasurement = zeros(numfidsCono,1);

for i = 1:numfidsCono
    % for the NDI file ---------
    fid = fopen(fnamesTracker(i).name,'r');% open the file
    InputText2=textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s','delimiter',',','HeaderLines',1);% pose for conoscope and tool    
    tempData = [str2double(InputText2{1,6}) str2double(InputText2{1,7}) str2double(InputText2{1,8}) str2double(InputText2{1,9}) str2double(InputText2{1,10}) str2double(InputText2{1,11}) str2double(InputText2{1,12})];
    poseCono(i,:) = mean(tempData,1);
    fclose(fid);
    % for the conoscope file ....
    fid = fopen(fnamesCono(i).name,'r');% open the file
    InputText3=textscan(fid,'%f',8,'delimiter','\t','HeaderLines',1);% extract measurement
    conoMeasurement(i,:) = InputText3{1,1}(3);
    fclose(fid);
end

%Read Groundtruth
fid = fopen('groundtruth.csv','r'); % open the file
InputText4=textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s','delimiter',',','HeaderLines',1);
groundtruthData = [str2double(InputText4{1,6}) str2double(InputText4{1,7}) str2double(InputText4{1,8}) str2double(InputText4{1,9}) str2double(InputText4{1,10}) str2double(InputText4{1,11}) str2double(InputText4{1,12})];
groundtruthPoint = [mean(groundtruthData(:,5));mean(groundtruthData(:,6)); mean(groundtruthData(:,7))];
fclose(fid);


n = numfidsCono;
m = zeros(4,4,n); % pose_drb_in_camera

for a=1:n
    m(:,:,a) = amq(poseCono(a,:));
end
distance = conoMeasurement';

laser_pos_in_cono = zeros(3,n);
laser_pos_in_patient = zeros(4,n);
cartDev = zeros(n,1);
for a=1:n
    % location of point in conoscope's coordinate frame
    laser_pos_in_cono(:,a) = origin + conoMeasurement(a) * direction;
    
    % transformation in patient coordinates
    laser_pos_in_patient(:,a) = m(:,:,a) * [laser_pos_in_cono(:,a); 1];
    cartDev(a) = norm(laser_pos_in_patient(1:3,a) - groundtruthPoint);
end

meanCartError = mean(cartDev)
stdDevCartError = std(cartDev)
rmseCart = sqrt(meanCartError^2 + stdDevCartError^2)
maxCart = max(cartDev)