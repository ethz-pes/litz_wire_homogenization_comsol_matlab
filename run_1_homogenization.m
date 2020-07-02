function run_1_homogenization()
% Compute homogenized material parameters for a litz wire (with FEM).
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
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

close('all')
addpath('homogenization')

%% parameters

% litz wire geometry
wire = struct(...
    'd_litz', 200e-6,... % diameter of the litz wire strands
    'fill', 0.55,... % fill factor of the litz wire
    'sigma', 4e7... % litz wire conductivity
    );

% mesh size
mesh = struct(...
    'h_max', 2.0e-6,... % max mesh element size
    'h_min', 1.0e-6... % min mesh element size
    );

% frequency vector
f_vec = logspace(log10(10e3), log10(10e6), 50);

%% compute

% compute the homogenized litz wire parameters
[wire, model] = get_homogenization(wire, mesh, f_vec);

% save the FEM model
mphsave(model, 'data/homogenization.mph');

% save the data
save('data/homogenization.mat', '-struct', 'wire')

end
