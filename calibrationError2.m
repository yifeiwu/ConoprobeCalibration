%calibration check

% clear all;

fnamesTracker = dir('testpose*.csv');
numfidsTracker = length(fnamesTracker);
fnamesCono = dir('testpose*.txt');
numfidsCono = length(fnamesCono);
fnamesGP = dir('testpoint*.csv'); %calibration points either off tracked probe or board
numfidsGP = length(fnamesGP);

poseTool = zeros(numfidsTracker,7);
poseCono = zeros(numfidsTracker,7);
groundtruthPoint = zeros(numfidsGP,3);
conoMeasurement = zeros(numfidsCono,1);


for i = 1:numfidsGP
    
    % for the NDI file ---------
    
    fid = fopen(fnamesGP(i).name,'r'); % open the file
        if (fid ~= -1)
            InputText=textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s','delimiter',',','HeaderLines',1);
            fclose(fid);

            groundtruthData2 = [str2double(InputText{1,6}) str2double(InputText{1,7}) str2double(InputText{1,8}) str2double(InputText{1,9}) str2double(InputText{1,10}) str2double(InputText{1,11}) str2double(InputText{1,12})];
            gp(i,:) = [mean(groundtruthData2(:,5));mean(groundtruthData2(:,6)); mean(groundtruthData2(:,7))];

        end
    
    % for the conoscope file ....
    fid = fopen(fnamesCono(i).name,'r');                % open the file
    InputText2=textscan(fid,'%s',8,'delimiter','\t');   % extract the header
    InputText2=textscan(fid,'%f',8,'delimiter','\t');   % extract measurement
    conoMeasurement(i) = InputText2{1,1}(3);
    fclose(fid); 
    
    
    % Get the conopose
    fid = fopen(fnamesTracker(i).name,'r'); % open the file
    if (fid ~= -1)
        InputText=textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s','delimiter',',','HeaderLines',1);% pose for conoscope and tool    
        tempData = [str2double(InputText{1,6}) str2double(InputText{1,7}) str2double(InputText{1,8}) str2double(InputText{1,9}) str2double(InputText{1,10}) str2double(InputText{1,11}) str2double(InputText{1,12})];
        poseCono(i,:) = mean(tempData,1);
        fclose(fid);
    end
    
end


for a=1:numfidsGP
    m(:,:,a)=amq(poseCono(a,:));
    conopos=origin+conoMeasurement(a)*direction;
    laserpos(a,:)= m(:,:,a)*[conopos;1];
    
end

laserpos1=laserpos(:,1:3);

 pdist([laserpos1(1,:);gp(1,:)])
 pdist([laserpos1(2,:);gp(2,:)])
 pdist([laserpos1(3,:);gp(3,:)])


