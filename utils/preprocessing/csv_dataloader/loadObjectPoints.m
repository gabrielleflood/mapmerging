function objectpoints = loadObjectPoints(folder)
%LOADKEYFRAMES Summary of this function goes here
%   Detailed explanation goes here

fid = fopen(fullfile(folder,"objectpoints.csv"));
tline = fgetl(fid);

objectpoints = containers.Map('KeyType','double','ValueType','any');

while ischar(tline)    
    
    objectpoint = ObjectPoint;
    
    objectpoint.readId(tline);
    tline = fgetl(fid);
    objectpoint.readObjectPoint(tline);
    tline = fgetl(fid);
    objectpoint.readReferences(tline);
    tline = fgetl(fid);
   
    objectpoints(objectpoint.getId()) = objectpoint;
   
end
fclose(fid);
end

