%% load data!

folder = "/home/patrik/Desktop/data_kalle/2020_03_09_14_13_14/map/csv_format/map_2020_03_09_16_01_15/";
folder = "/Users/kalle/Documents/projekt/mergingmaps/matlab/paperII/kalle_real_data/experiment2b/csv_data/map_2020_03_09_23_24_06/";

[keyframes,objectpoints, keySet_keyframes, keySet_objectpoints] = loadMap(folder);

%%

XX = [];
for i = 1:size(keySet_objectpoints,2)
   XX = [XX; objectpoints(keySet_objectpoints{i}).getX()];
end

figure(1);
pcshow(XX);
axis equal


