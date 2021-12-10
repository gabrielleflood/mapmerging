function NewU = get_sq_after_merge(SfMs, solopt, data, debug)
% after a merge, collected in solopt and data, this function extracts how
% the auxilliary parameters (s) should be moved along when the map points
% (q) are moved as in the merge. NewU is a struct with the same length as
% SfMs containing only the 3D points (in homogeneous coordinates)

if nargin < 4 || isempty(debug)
    debug = 0;
end


[dq_tot,individual_dqs] = extract_merge_dqs(solopt,data);

for k = 1:length(SfMs)
    res_compressed = SfMs{k}.res_compressed;
    res_all = SfMs{k}.res_all;
    if debug
        res_all.SfM
    end
    solold_k = res_all.solopt;
    this_dq = individual_dqs{k};
    this_ds = res_all.dsdq*this_dq;
    this_dz = zeros(length(this_dq)+length(this_ds),1);
    this_dz(res_all.sind)=this_ds;
    this_dz(res_all.qind)=this_dq;
    solnew_k = updateparam_nonlinear(solold_k,this_dz);
    % move all maps to the coordinate system of map 1.
    Utmp = solnew_k.U;
    Utmp = solopt.T{1}*inv(solopt.T{k})*Utmp;
    NewU{k}=Utmp;
end