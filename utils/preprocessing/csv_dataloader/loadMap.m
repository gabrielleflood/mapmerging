function [keyframes,objectpoints, keySet_keyframes, keySet_objectpoints] = loadMap(folder)
%LOADMAP Summary of this function goes here
%   Detailed explanation goes here
keyframes = loadKeyFrames(folder);

objectpoints = loadObjectPoints(folder);

keySet_keyframes = keys(keyframes);
keySet_objectpoints = keys(objectpoints);

for i = 1:size(keySet_keyframes,2)
    keyframes(keySet_keyframes{i}).setIndex(i);
end

for i = 1:size(keySet_objectpoints,2)
    objectpoints(keySet_objectpoints{i}).setIndex(i);
end

end

