function [wire, model] = get_homogenization(wire, mesh, f_vec)
% Extract the virtual homogenized parameters of the wire
%     - name: name of the wire
%     - wire: struct with the wire parameters
%     - mesh: struct with the mesh size
%     - f_vec: frequency vector
%     - homogenization: struct with the homogenized parameters of the wire
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% init
disp('homogenization')
tic = datetime('now');
assert(all(f_vec>0), 'invalid data')

% create the COMSOL model
disp('    model')
model = get_homogenization_model(wire, mesh, f_vec);

% solve and extract the values from the COMSOL model
disp('    extract')
fem = get_homogenization_extract(model);
 
% extract the virtual material parameters
disp('    material')
[sigma_vec, mu_vec] = get_homogenization_material(fem);

% assign data
disp('    assign')
wire.f_vec = f_vec;
wire.sigma_vec = sigma_vec;
wire.mu_vec = mu_vec;

% teardown
toc = datetime('now');
fprintf('    time = %s\n', char(toc-tic))

end