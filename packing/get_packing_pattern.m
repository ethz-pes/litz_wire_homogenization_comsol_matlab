function [n, x_vec, y_vec] = get_packing_pattern(wire, d_wire_target)
% Plot the strands of the wire
%     - wire: struct with the wire parameters
%     - n: number of strands
%     - x_vec: x position of the strands
%     - y_vec: y position of the strands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% extract
d_litz = wire.d_litz;
fill = wire.fill;

%% geom
r_litz = d_litz./2;
A_copper = 2.*((pi.*r_litz.^2)./4);
A_tot = A_copper./fill;
y_dom = sqrt(A_tot./sqrt(3));
x_dom = 2.*sqrt(A_tot.*sqrt(3));

%% grid
n_x = round(d_wire_target./x_dom);
n_y = round(d_wire_target./y_dom);

%% place the strands
x_vec = [];
y_vec = [];
n = 0;
for i=-n_x:n_x
    for j=-n_y:n_y
        [x_tmp, y_tmp] = get_coord(i, j, x_dom, y_dom);
        if is_inside(x_tmp, y_tmp, d_wire_target, d_litz)
            n = n+1;
            x_vec(end+1) = x_tmp;
            y_vec(end+1) = y_tmp;
        end
    end
end

end

function is_ok = is_inside(x, y, d_wire, d_litz)
% Test if a strand if inside the wire or invalid
%     - x: x position of the strand
%     - y: y position of the strand
%     - r_wire: diameter of the wire
%     - d_litz: diameter of the strands
%     - overlap: relative tolerance on the wire diameter
%     - is_ok: if the strand is valid or not
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r_center = hypot(x, y);
r_max = r_center+(d_litz./2);
r_wire = d_wire./2;

diff = (r_max-r_wire)./d_litz;
is_ok = diff<=0;

end

function [x, y] = get_coord(i, j, x_dom, y_dom)
% Find the position of a strand from the indices
%     - i: x position index
%     - j: y position index
%     - x_dom: size of the unit cell (x direction)
%     - y_dom: size of the unit cell (y direction)
%     - x: x position of the strand
%     - y: y position of the strand
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if mod(j,2)==0
    x = x_dom*i;
    y = y_dom*j;
else
    x = x_dom*i+x_dom./2;
    y = y_dom*j;
end

end