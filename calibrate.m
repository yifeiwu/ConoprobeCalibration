% Author: Jessica Burgner, jessica.burgner@vanderbilt.edu
% Vanderbilt University, 2011
%---------------------------------------------------------------------
clear all;

fnamesTracker = dir('tracking*.csv');
numfidsTracker = length(fnamesTracker);
fnamesCono = dir('results*.txt');
numfidsCono = length(fnamesCono);

poseTool = zeros(numfidsTracker,7);
poseCono = zeros(numfidsTracker,7);
conoMeasurement = zeros(numfidsCono,1);


for i = 1:numfidsCono
    
    % for the NDI file ---------
    fid = fopen(fnamesTracker(i).name,'r');             % open the file
    InputText=textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s','delimiter',',','HeaderLines',1);% pose for conoscope and tool    
    tempData = [str2double(InputText{1,6}) str2double(InputText{1,7}) str2double(InputText{1,8}) str2double(InputText{1,9}) str2double(InputText{1,10}) str2double(InputText{1,11}) str2double(InputText{1,12})];
    poseCono(i,:) = mean(tempData,1);
    fclose(fid);
    % for the conoscope file ....
    fid = fopen(fnamesCono(i).name,'r');                % open the file
    InputText2=textscan(fid,'%s',8,'delimiter','\t');   % extract the header
    InputText2=textscan(fid,'%f',8,'delimiter','\t');   % extract measurement
    conoMeasurement(i,:) = InputText2{1,1}(3);
    fclose(fid); 
end

fid = fopen('groundtruth.csv','r'); % open the file
if (fid ~= -1)
    InputText=textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s','delimiter',',','HeaderLines',1);
    fclose(fid);
    
    groundtruthData = [str2double(InputText{1,6}) str2double(InputText{1,7}) str2double(InputText{1,8}) str2double(InputText{1,9}) str2double(InputText{1,10}) str2double(InputText{1,11}) str2double(InputText{1,12})];
    groundtruthPoint = [mean(groundtruthData(:,5));mean(groundtruthData(:,6)); mean(groundtruthData(:,7))];
   
    [origin,direction] = calcono(poseCono,conoMeasurement,groundtruthPoint);
    fid = fopen('cono.ini', 'w');
    fprintf(fid, '%6.5f %6.5f %6.5f %6.5f %6.5f %6.5f\n', origin, direction);
    fclose(fid);

     
    fprintf('Calibration Results\n');
    [origin; direction]

end

