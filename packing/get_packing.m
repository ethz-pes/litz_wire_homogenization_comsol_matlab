function wire = get_packing(wire, d_wire_target)
% Compute the geometry of a round litz wire.
%
%    Get the position of the strands for a round litz wire.
%    Get a solid wire with an equivalent diameter.
%
%    Parameters:
%        wire (struct): struct with the litz wire parameters
%        d_wire_target (float): target for the litz wire diameter
%
%    Returns:
%        wire (struct): struct with the litz wire parameters
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% init
disp('packing')
tic = datetime('now');

% create the packing pattern
disp('    pattern')
[n, x_vec, y_vec] = get_packing_pattern(wire, d_wire_target);

% get the equivalent solid wire
disp('    solid')
d_wire = get_packing_solid(wire, n);

% assign data
disp('    assign')
wire.n = n;
wire.x_vec = x_vec;
wire.y_vec = y_vec;
wire.d_wire = d_wire;

% teardown
toc = datetime('now');
fprintf('    time = %s\n', char(toc-tic))

end
