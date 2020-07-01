function data = get_simulation_extract(model)
% Extract data from the FEM model
%     - model: COMSOL model
%     - type: type of the simulation ('single_wire' or 'parallel_wire')
%     - f_vec: frequency vector
%     - I_peak: peak current in the wire
%     - H_peak: external peak magnetic field
%     - losses: struct with the extracted losses
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% run
model.sol('sol').runAll;

%% extract
[P_dom_vec, W_dom_vec, V_coil_vec] = model.mphglobal({'P_dom', 'W_dom', 'V_coil'}, 'Complexout', 'on');
data.P_dom_vec = P_dom_vec.';
data.W_dom_vec = W_dom_vec.';
data.V_coil_vec = V_coil_vec.';

end