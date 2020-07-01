function run_2_packing()

close('all')
addpath('packing')

%% homogenization
wire = load('data/homogenization.mat');

%% wire
d_wire_target = 4.0e-3;

%% run
wire = get_packing(wire, d_wire_target);

%% save
save('data/packing.mat', '-struct', 'wire');

end