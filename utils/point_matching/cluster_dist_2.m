function d = cluster_dist_2(v1,v2);

for i = 1:size(v1,2);
    for j = 1:size(v2,2);
        d(i,j)=brief_dist(v1(:,i),v2(:,j));
    end
end

d_std = (d-127)/22;
d = mean(d_std(:));


