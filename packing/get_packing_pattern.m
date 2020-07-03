function [n, x_vec, y_vec] = get_packing_pattern(wire, d_wire_target)
% Get the position of the strands for a round litz wire.
%
%    The packing of the strand is hexagonal.
%    All the strands are located inside the given diameter.
%
%    Parameters:
%        wire (struct): struct with the litz wire parameters
%        d_wire_target (float): target for the litz wire diameter
%
%    Returns:
%        n (float): number of strands
%        x_vec (vector): x position of the strands
%        y_vec (vector): y position of the strands
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% extract data
d_litz = wire.d_litz;
fill = wire.fill;

% compute geometry
r_litz = d_litz./2;
A_copper = 2.*((pi.*r_litz.^2)./4);
A_tot = A_copper./fill;
y_dom = sqrt(A_tot./sqrt(3));
x_dom = 2.*sqrt(A_tot.*sqrt(3));

% number of strands to place in x and y directions
n_x = round(d_wire_target./x_dom);
n_y = round(d_wire_target./y_dom);

% keep the strands located inside the given diameter
x_vec = [];
y_vec = [];
n = 0;
for i=-n_x:n_x
    for j=-n_y:n_y
        % get the position of the wire from indices
        [x_tmp, y_tmp] = get_coord(i, j, x_dom, y_dom);
        
        % check if the position is valid
        if is_inside(x_tmp, y_tmp, d_wire_target, d_litz)
            n = n+1;
            x_vec(end+1) = x_tmp;
            y_vec(end+1) = y_tmp;
        end
    end
end

end

function [x, y] = get_coord(i, j, x_dom, y_dom)
% Find the position of a strand from the indices
%
%    Parameters:
%        i (integer): x position index
%        j (integer): y position index
%        x_dom (float): size of the unit cell (x direction)
%        y_dom (float): size of the unit cell (y direction)
%
%    Returns:
%        x (float): x position of the strand
%        y (float): y position of the strand

if mod(j,2)==0
    x = x_dom.*i;
    y = y_dom.*j;
else
    x = x_dom.*i+x_dom./2;
    y = y_dom.*j;
end

end

function is_ok = is_inside(x, y, d_wire_target, d_litz)
% Test if a strand if inside the wire or invalid
%
%    Parameters:
%        x (float): x position of the strand
%        y (float): y position of the strand
%        d_wire_target (float): target for the litz wire diameter
%        d_litz (float): diameter of the strands
%
%    Returns:
%        is_ok (logical): if the wire is inside the given diameter

% compute radius
r_center = hypot(x, y);
r_max = r_center+(d_litz./2);
r_wire_target = d_wire_target./2;

% check validity
diff = r_max-r_wire_target;
is_ok = diff<=0;

end
