function [wire, model] = get_homogenization(wire, mesh, f_vec)
% Compute the homogenized material parameters for a litz wire (with FEM).
%
%    Using 2D FEM simulation with COMSOL.
%
%    Extract the losses and energy:
%        - for skin effect
%        - for proximity effect
%
%    Extract equivalent homogenized material parameters:
%        - complex permeability
%        - complex conductivity
%
%    Parameters:
%        wire (struct): struct with the litz wire parameters
%        mesh (struct): struct with mesh size parameters
%        f_vec (vector): frequency vector
%
%    Returns:
%        wire (struct): struct with the litz wire parameters
%        model (model): COMSOL model
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

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