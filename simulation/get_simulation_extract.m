function data = get_simulation_extract(model)
% Solve the FEM model and extract the parameters.
%
%    Extract the following parameters:
%        - energy
%        - losses
%        - induced voltage
%
%    Parameters:
%        model (model): COMSOL model
%
%    Returns:
%        data (struct): struct with the extracted values
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% solve the model
model.sol('sol').runAll;

% extract the parameters
[P_dom_vec, W_dom_vec, V_coil_vec] = model.mphglobal({'P_dom', 'W_dom', 'V_coil'}, 'Complexout', 'on');
data.P_dom_vec = P_dom_vec.';
data.W_dom_vec = W_dom_vec.';
data.V_coil_vec = V_coil_vec.';

end