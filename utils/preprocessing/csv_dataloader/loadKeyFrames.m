function keyframes = loadKeyFrames(folder)
%LOADKEYFRAMES Summary of this function goes here
%   Detailed explanation goes here

fid = fopen(fullfile(folder,"keyframes.csv"));
%keyboard;
tline = fgetl(fid);

keyframes = containers.Map('KeyType','double','ValueType','any');

while ischar(tline)    
    
    kf = KeyFrame;
    
    kf.readId(tline);
    tline = fgetl(fid);
    kf.readCalibration(tline);
    tline = fgetl(fid);
    kf.readState(tline);
    tline = fgetl(fid);
    kf.readFeatures(tline);
    tline = fgetl(fid);
    kf.readDistortedFeatures(tline);
    tline = fgetl(fid);
    kf.readObservations(tline);
    
    kf.readDescriptors(fid);
    tline = fgetl(fid);
    
   
    keyframes(kf.getId()) = kf;
   
end
fclose(fid);
end

