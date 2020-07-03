function run_2_packing()
% Compute the geometry of a round litz wire.
%
%    Get the position of the strands for a round litz wire.
%    Get a solid wire with an equivalent diameter.
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

close('all')
addpath(genpath('src'))

%% parameters

% load the homogenized litz wire parameters
wire = load('data/homogenization.mat');

% target for the litz wire diameter
d_wire_target = 4.0e-3;

%% compute

% get the packing patternof the litz wire
wire = get_packing(wire, d_wire_target);

% save the data
save('data/packing.mat', '-struct', 'wire');

end