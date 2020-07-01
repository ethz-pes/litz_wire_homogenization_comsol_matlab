function wire = get_packing(wire, d_wire_target)
% Construct the geometry of the wire
%     - name: name of the wire
%     - wire: struct with the wire parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
