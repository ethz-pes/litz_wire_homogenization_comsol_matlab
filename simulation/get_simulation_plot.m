function get_simulation_plot(data)
% Display the results for a particular analysis
%     - type: name of the analysis
%     - losses: struct with the results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f_vec = data.f_vec;
homogenization = data.homogenization;
discrete_strand = data.discrete_strand;

%% losses / energy
figure('name', 'losses / energy')

subplot(2,2,1)
get_subplot_var(f_vec, homogenization.P_dom_vec, discrete_strand.P_dom_vec, 'P [W]', 'losses')

subplot(2,2,2)
get_subplot_var(f_vec, homogenization.W_dom_vec, discrete_strand.W_dom_vec, 'W [J]', 'energy')

subplot(2,2,3)
get_subplot_var(f_vec, real(homogenization.V_coil_vec), real(discrete_strand.V_coil_vec), 'V [V]', 'voltage / real')

subplot(2,2,4)
get_subplot_var(f_vec, imag(homogenization.V_coil_vec), imag(discrete_strand.V_coil_vec), 'V [V]', 'voltage / imag')

sgtitle('FEM Variables')

%% error
figure('name', 'losses / energy')

subplot(2,2,1)
get_subplot_err(f_vec, homogenization.P_dom_vec, discrete_strand.P_dom_vec, 'losses')

subplot(2,2,2)
get_subplot_err(f_vec, homogenization.W_dom_vec, discrete_strand.W_dom_vec, 'energy')

subplot(2,2,3)
get_subplot_err(f_vec, real(homogenization.V_coil_vec), real(discrete_strand.V_coil_vec), 'voltage / real')

subplot(2,2,4)
get_subplot_err(f_vec, imag(homogenization.V_coil_vec), imag(discrete_strand.V_coil_vec), 'voltage / imag')

sgtitle('FEM Variables')

end

function get_subplot_var(f_vec, v_solid, v_strand, str_label, str_title)

loglog(f_vec, v_solid, 'r')
hold('on')
loglog(f_vec, v_strand, 'g')
legend({'solid', 'strand'}, 'interpreter', 'none')
xlabel('f [kHz]')
ylabel(str_label)
title(str_title)

end

function get_subplot_err(f_vec, v_solid, v_strand, str_title)

err = abs((v_solid-v_strand)./v_strand);

semilogx(f_vec, 100.*err, 'r')
xlabel('f [kHz]')
ylabel('error [%]')
title(str_title)

end