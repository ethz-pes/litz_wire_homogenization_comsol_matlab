function d_wire = get_packing_solid(wire, n)
% Get an equivalent solid wire for a given litz wire.
%
%    Compute the copper area of all the strands.
%    Divide the obtained cross-section with the fill factor.
%    Get a solid wire with the same cross-section.
%
%    Parameters:
%        wire (struct): struct with the litz wire parameters
%        n (float): number of strands
%
%    Returns:
%        d_wire (float): equivalent litz wire diameter
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% extract data
d_litz = wire.d_litz;
fill = wire.fill;

% compute areas
A_strand = pi.*(d_litz./2).^2;
A_copper = n.*A_strand;
A_tot = A_copper./fill;

% compute equivalent diameter
d_wire = sqrt(4.*A_tot./pi);

end
