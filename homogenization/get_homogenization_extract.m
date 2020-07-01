function fem = get_homogenization_extract(model)
% Extract data from the FEM model
%     - model: COMSOL model
%     - wire: struct with the wire parameters
%     - mesh: struct with the mesh size
%     - f_vec: frequency vector
%     - homogenization: struct with the homogenized parameters of the wire
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% sol
model.sol('sol').runAll;

%% extract
f_vec = model.mphglobal({'freq'}, 'Complexout', 'on');
fem.f_vec = f_vec.';

[w_skin_vec, p_skin_vec, J_skin_tot_vec] = model.mphglobal({'w_skin', 'p_skin', 'J_skin_tot'}, 'Complexout', 'on');
fem.w_skin_vec = w_skin_vec.';
fem.p_skin_vec = p_skin_vec.';
fem.J_skin_tot_vec = J_skin_tot_vec.';

[w_prox_vec, p_prox_vec, B_prox_tot_vec] = model.mphglobal({'w_prox', 'p_prox', 'B_prox_tot'}, 'Complexout', 'on');
fem.w_prox_vec = w_prox_vec.';
fem.p_prox_vec = p_prox_vec.';
fem.B_prox_tot_vec = B_prox_tot_vec.';

end