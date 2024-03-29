function get_homogenization_plot(wire)
% Plot the homogenized material parameters for a litz wire.
%
%    Plot the following parameters:
%        - complex permeability
%        - complex conductivity
%
%    Parameters:
%        wire (struct): struct with the litz wire parameters
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% plot init
figure('name', 'homogenization')

% plot conductivity
subplot(1,2,1)
semilogx(wire.f_vec, +real(1e-6.*wire.sigma_vec), 'b', 'LineWidth', 1.0)
hold('on')
semilogx(wire.f_vec, -imag(1e-6.*wire.sigma_vec), 'r', 'LineWidth', 1.0)
legend('+real(sigma)', '-imag(sigma')
xlabel('f [Hz]')
ylabel('sigma [MS/m]')
title('conductivity')

% plot permeability
subplot(1,2,2)
semilogx(wire.f_vec, +real(wire.mu_vec), 'b', 'LineWidth', 1.0)
hold('on')
semilogx(wire.f_vec, -imag(wire.mu_vec), 'r', 'LineWidth', 1.0)
legend('+real(mu)', '-imag(mu')
xlabel('f [Hz]')
ylabel('mu [1]')
title('permeability')

% plot title
sigma_str = sprintf('\\sigma = %.2f MS/m', 1e-6.*wire.sigma);
d_litz_str = sprintf('d_{litz} = %.2f um', 1e6.*wire.d_litz);
fill_str = sprintf('f = %.2f %%', 100.*wire.fill);
str = [sigma_str ' / ' d_litz_str ' / ' fill_str];
sgtitle(str)

end