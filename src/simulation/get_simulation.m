function [data, model] = get_simulation(type, wire, domain, mesh, f_vec)
% Simulate with FEM a circulate litz wire coil (with and without homogenization).
%
%    Simulate the energy, the losses, and the induced voltage of a circulate litz wire coil.
%
%    Two different methods are used:
%        - simulation with the homogenized material parameters (fast)
%        - simulation of all the discrete strands (slow)
%
%    Parameters:
%        type (str): type of the simulation ('discrete_strand' or 'homogenization')
%        wire (struct): struct with the litz wire parameters
%        domain (struct): struct with the simulation domain and coil geometry
%        mesh (struct): struct with mesh size parameters
%        f_vec (vector): frequency vector
%
%    Returns:
%        data (struct): struct with the extracted parameters
%        model (model): COMSOL model
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% init
disp(['simulation / ' type])
tic = datetime('now');
assert(all(f_vec>0), 'invalid data')

% create the COMSOL model
disp('    model')
switch type
    case 'discrete_strand'
        model = get_simulation_model_discrete_strand(wire, domain, mesh, f_vec);
    case 'homogenization'
        model = get_simulation_model_homogenization(wire, domain, mesh, f_vec);
    otherwise
        error('invalid type')
end

% solve and extract the values from the COMSOL model
disp('    extract')
data = get_simulation_extract(model);

% teardown
toc = datetime('now');
fprintf('    time = %s\n', char(toc-tic))

end