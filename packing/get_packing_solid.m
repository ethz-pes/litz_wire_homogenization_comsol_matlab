function d_wire = get_packing_solid(wire, n)
% Plot the strands of the wire
%     - wire: struct with the wire parameters
%     - n: number of strands
%     - x_vec: x position of the strands
%     - y_vec: y position of the strands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% extract
d_litz = wire.d_litz;
fill = wire.fill;

%% diameter
A_strand = pi.*(d_litz./2).^2;
A_copper = n.*A_strand;
A_tot = A_copper./fill;
d_wire = sqrt(4.*A_tot./pi);

end
