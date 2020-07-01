function get_homogenization_plot(wire)
% Plot the strands of the wire
%     - wire: struct with the wire parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sigma_str = sprintf('sigma = %.2f MS/m', 1e-6.*wire.sigma);
d_litz_str = sprintf('d_litz = %.2f um', 1e6.*wire.d_litz);
fill_str = sprintf('fill = %.2f %%', 100.*wire.fill);
str = [sigma_str ' / ' d_litz_str ' / ' fill_str];

%% plot
figure()

subplot(1,2,1)
semilogx(wire.f_vec, +real(1e-6.*wire.sigma_vec), 'b')
hold('on')
semilogx(wire.f_vec, +imag(1e-6.*wire.sigma_vec), 'r')
legend('+real(sigma)', '+imag(sigma')
xlabel('f [Hz]')
ylabel('sigma [MS/m]')
title('conductivity', 'interpreter', 'none')

subplot(1,2,2)
semilogx(wire.f_vec, +real(wire.mu_vec), 'b')
hold('on')
semilogx(wire.f_vec, -imag(wire.mu_vec), 'r')
legend('+real(mu)', '-imag(mu')
xlabel('f [Hz]')
ylabel('mu [1]')
title('permeability', 'interpreter', 'none')

sgtitle(str, 'interpreter', 'none')

end