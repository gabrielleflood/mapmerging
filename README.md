# mapmerging

This repository contains a method for merging of individual map representations of the same scene. The map is a 3D feature point cloud. The matching is based on a division of the parameters (points and cameras) in two parts, one with main parameters and one with auxiliary parameters[^1].

The code for the merging is presented in the paper *Generic Merging of Structure from Motion Maps with a Low Memory Footprint*[^2]. The experiment in an office environment presented in the paper can be run using the script ```icpr_experiment.m```.

[^1]: Flood, G., Gillsjö, D., Heyden, A. and Åström, K., 2019. Efficient merging of maps and detection of changes. In *Scandinavian Conference on Image Analysis (SCIA)* (pp. 348-360). Springer, Cham.
[^2]: Flood, G., Gillsjö, D., Persson, P., Heyden, A. and Åström, K., 2021, January. Generic Merging of Structure from Motion Maps with a Low Memory Footprint. In *2020 25th International Conference on Pattern Recognition (ICPR)* (pp. 4385-4392). IEEE.
