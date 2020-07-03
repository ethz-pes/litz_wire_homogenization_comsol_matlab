function fem = get_homogenization_extract(model)
% Solve the FEM model and extract the parameters.
%
%    Extract the following parameters:
%        - energy density
%        - losses density
%        - excitation (current density or flux density)
%
%    Parameters:
%        model (model): COMSOL model
%
%    Returns:
%        fem (struct): struct with the extracted values
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% solve the model
model.sol('sol').runAll;

% extract the frequency
f_vec = model.mphglobal({'freq'}, 'Complexout', 'on');
fem.f_vec = f_vec.';

% extract the parameters for the skin effect simulation
[w_skin_vec, p_skin_vec, J_skin_tot_vec] = model.mphglobal({'w_skin', 'p_skin', 'J_skin_tot'}, 'Complexout', 'on');
fem.w_skin_vec = w_skin_vec.';
fem.p_skin_vec = p_skin_vec.';
fem.J_skin_tot_vec = J_skin_tot_vec.';

% extract the parameters for the proximity effect simulation
[w_prox_vec, p_prox_vec, B_prox_tot_vec] = model.mphglobal({'w_prox', 'p_prox', 'B_prox_tot'}, 'Complexout', 'on');
fem.w_prox_vec = w_prox_vec.';
fem.p_prox_vec = p_prox_vec.';
fem.B_prox_tot_vec = B_prox_tot_vec.';

end