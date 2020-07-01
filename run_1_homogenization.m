function run_1_homogenization()
% Main function for computing the homogenized parameters of the wire
%     - built the wire geometry
%     - compute the homogenized parameters of the wire
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close('all')
addpath('homogenization')

%% wire
wire = struct(...
    'd_litz', 200e-6,...% diameter of the strands
    'fill', 0.55,... % fill factor
    'sigma', 4e7); % wire temperature in celsius

%% mesh
mesh = struct(...
    'h_max', 2.0e-6,...% max mesh element
    'h_min', 1.0e-6); % min mesh element

%% freq
f_vec = logspace(log10(10e3), log10(10e6), 50); % frequency vector

%% coupled
[wire, model] = get_homogenization(wire, mesh, f_vec);
mphsave(model, 'data/homogenization.mph');

%% save
save('data/homogenization.mat', '-struct', 'wire')

end
