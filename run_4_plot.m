function run_4_plot()
% Plot the result (homogenization, geometry, and simulation).
%
%    Plot the different results:
%        - homogenized parameters (conductivity and permeability)
%        - litz wire geometry
%        - simulation results (energy, losses, and induced voltage)
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

close('all')
addpath('homogenization')
addpath('packing')
addpath('simulation')

%% plot the litz wire homogenized parameters
wire = load('data/homogenization.mat');
get_homogenization_plot(wire)

%% plot the litz wire geometry
wire = load('data/packing.mat');
get_packing_plot(wire)

%% plot the simulation results
simulation = load('data/simulation.mat');
get_simulation_plot(simulation)

end
