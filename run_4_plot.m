function run_4_plot()
% Main function for plotting the results
%     - plot the results (losses, energy, voltage)
%     - compute the maximum error
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close('all')
addpath('homogenization')
addpath('packing')
addpath('simulation')

%% homogenization
wire = load('data/homogenization.mat');
get_homogenization_plot(wire)

%% packing
wire = load('data/packing.mat');
get_packing_plot(wire)

%% simulation
simulation = load('data/simulation.mat');
get_simulation_plot(simulation)

end
