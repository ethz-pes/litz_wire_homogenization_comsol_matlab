function run_3_simulation()
% Main function for computing the losses
%     - built the wire geometry ('wire')
%     - compute the losses with homogenization ('coupled')
%     - compute the losses with analytical formula ('decoupled')
%     - compute the losses with a strand-level model ('strand')
%
% Two configurations are considered:
%     - single_wire wire with current or external field ('single_wire_wire')
%     - two parallel wires ('parallel_wire')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close('all')
addpath('simulation')

%% wire
wire = load('data/packing.mat');

%% domain
domain = struct(...
    'r_coil', 3e-3,...% distance between the wire ('parallel_wire')
    'r_dom', 10e-3); % size of the simulation domain

%% mesh
mesh_solid = struct(...
    'h_air_max', 500e-6,...% max mesh element (domain)
    'h_air_min', 150e-6,...% min mesh element (domain)
    'h_wire_max', 100e-6,...% max mesh element (wire)
    'h_wire_min', 50e-6); % min mesh element (wire)

mesh_strand = struct(...
    'h_air_max', 500e-6,...% max mesh element (domain)
    'h_air_min', 50e-6,...% min mesh element (domain)
    'h_wire_max', 10e-6,...% max mesh element (strand)
    'h_wire_min', 5e-6); % min mesh element (strand)

%% freq
f_vec = logspace(log10(10e3), log10(10e6), 50); % frequency vector

%% coupled
[homogenization, model] = get_simulation('homogenization', wire, domain, mesh_solid, f_vec);
mphsave(model, 'data/simulation_homogenization.mph')

%% strand
[discrete_strand, model] = get_simulation('discrete_strand', wire, domain, mesh_strand, f_vec);
mphsave(model, 'data/simulation_discrete_strand.mph')

%% save
save('data/simulation.mat', 'f_vec', 'homogenization', 'discrete_strand')

end


