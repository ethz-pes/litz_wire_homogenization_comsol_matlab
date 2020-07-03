function run_3_simulation()
% Simulate with FEM a circulate litz wire coil (with and without homogenization).
%
%    Simulate the energy, the losses, and the induced voltage of a circulate litz wire coil.
%
%    Two different methods are used:
%        - simulation with the homogenized material parameters (fast)
%        - simulation of all the discrete strands (slow)
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

close('all')
addpath(genpath('src'))

%% parameters

% load the litz wire geometry and homogenized parameters
wire = load('data/packing.mat');

% simulation domain and coil geometry
domain = struct(...
    'r_coil', 3e-3,... % distance between the wire ('parallel_wire')
    'r_dom', 10e-3... % size of the simulation domain
    );

% mesh size (homogenized material parameters)
mesh_homogenization = struct(...
    'h_air_max', 500e-6,... % max mesh element (domain)
    'h_air_min', 150e-6,... % min mesh element (domain)
    'h_wire_max', 100e-6,... % max mesh element (wire)
    'h_wire_min', 50e-6... % min mesh element (wire)
    );

% mesh size (discrete strands)
mesh_discrete_strand = struct(...
    'h_air_max', 500e-6,... % max mesh element (domain)
    'h_air_min', 50e-6,... % min mesh element (domain)
    'h_wire_max', 10e-6,... % max mesh element (strand)
    'h_wire_min', 5e-6... % min mesh element (strand)
    );

% frequency vector
f_vec = logspace(log10(10e3), log10(10e6), 50);

%% compute

% compute with the homogenized material parameters
[homogenization, model] = get_simulation('homogenization', wire, domain, mesh_homogenization, f_vec);
mphsave(model, 'data/simulation_homogenization.mph')

% compute with the discrete strands
[discrete_strand, model] = get_simulation('discrete_strand', wire, domain, mesh_discrete_strand, f_vec);
mphsave(model, 'data/simulation_discrete_strand.mph')

% save the data
save('data/simulation.mat', 'f_vec', 'homogenization', 'discrete_strand')

end
