function get_packing_plot(wire)
% Plot the strands of the wire
%     - wire: struct with the wire parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d_wire_str = sprintf('d_wire = %.2f mm', 1e3.*wire.d_wire);
d_litz_str = sprintf('d_litz = %.2f um', 1e6.*wire.d_litz);
fill_str = sprintf('fill = %.2f %%', 100.*wire.fill);
n_str = sprintf('n = %d', wire.n);
str = [d_wire_str ' / ' d_litz_str ' / ' fill_str ' / ' n_str];

%% angle
phi_vec = linspace(0, 2*pi);

%% wire
x_wire = (wire.d_wire./2).*cos(phi_vec);
y_wire = (wire.d_wire./2).*sin(phi_vec);

%% strand
x_litz = (wire.d_litz./2).*cos(phi_vec);
y_litz = (wire.d_litz./2).*sin(phi_vec);

%% plot
figure()
subplot(1,1,1)
plot(1e3.*x_wire, 1e3.*y_wire, 'b')
hold('on');
for i=1:wire.n
    x_litz_tmp = x_litz+wire.x_vec(i);
    y_litz_tmp = y_litz+wire.y_vec(i);
    plot(1e3.*x_litz_tmp, 1e3.*y_litz_tmp, 'r')
end
axis('equal');
xlabel('x [mm]')
ylabel('y [mm]')
title('wire geometry', 'interpreter', 'none')

%% title
sgtitle(str, 'interpreter', 'none')

end