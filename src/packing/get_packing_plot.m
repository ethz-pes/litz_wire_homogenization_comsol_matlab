function get_packing_plot(wire)
% Plot the geometry of a litz wire.
%
%    Plot the following parameters:
%        - the discrete strands
%        - the equivalent solid wire
%
%    Parameters:
%        wire (struct): struct with the litz wire parameters
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% plot init
figure('name', 'packing')

% angle vector
phi_vec = linspace(0, 2*pi);

% equivalent solid wire
x_wire = (wire.d_wire./2).*cos(phi_vec);
y_wire = (wire.d_wire./2).*sin(phi_vec);

% discrete strand
x_litz = (wire.d_litz./2).*cos(phi_vec);
y_litz = (wire.d_litz./2).*sin(phi_vec);

% plot the geometry
subplot(1,1,1)
plot(1e3.*x_wire, 1e3.*y_wire, 'b', 'LineWidth', 1.25)
hold('on');
for i=1:wire.n
    x_litz_tmp = x_litz+wire.x_vec(i);
    y_litz_tmp = y_litz+wire.y_vec(i);
    plot(1e3.*x_litz_tmp, 1e3.*y_litz_tmp, 'r', 'LineWidth', 0.75)
end
axis('equal');
xlabel('x [mm]')
ylabel('y [mm]')
title('wire geometry')

% plot title
d_wire_str = sprintf('d_{w} = %.2f mm', 1e3.*wire.d_wire);
d_litz_str = sprintf('d_{l} = %.2f um', 1e6.*wire.d_litz);
fill_str = sprintf('f = %.2f %%', 100.*wire.fill);
n_str = sprintf('n = %d', wire.n);

str = [d_wire_str ' / ' d_litz_str ' / ' fill_str ' / ' n_str];
sgtitle(str)

end