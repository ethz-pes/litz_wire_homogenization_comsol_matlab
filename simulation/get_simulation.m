function [data, model] = get_simulation(type, wire, domain, mesh, f_vec)
% Extract the losses with a strand-level model
%     - name: name of the wire
%     - type: type of the simulation ('single_wire' or 'parallel_wire')
%     - wire: struct with the wire parameters
%     - domain: struct with the domain parameters
%     - mesh: struct with the mesh size
%     - f_vec: frequency vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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