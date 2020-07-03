function get_simulation_plot(data)
% Plot the simulated litz wire coil parameters.
%
%    Plot the following parameters:
%        - energy
%        - losses
%        - induced voltage
%
%    Plot the parameter for:
%        - simulation with the homogenized material parameters
%        - simulation of all the discrete strands
%        - deviation between the two methods
%
%    Parameters:
%        data (struct): struct with the simulated parameters
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% extrac the values
f_vec = data.f_vec;
homogenization = data.homogenization;
discrete_strand = data.discrete_strand;

% plot the variables
figure('name', 'simulation / values')
subplot(2,2,1)
get_subplot_var(f_vec, homogenization.P_dom_vec, discrete_strand.P_dom_vec, 'P [W]', 'losses')
subplot(2,2,2)
get_subplot_var(f_vec, homogenization.W_dom_vec, discrete_strand.W_dom_vec, 'W [J]', 'energy')
subplot(2,2,3)
get_subplot_var(f_vec, real(homogenization.V_coil_vec), real(discrete_strand.V_coil_vec), 'V [V]', 'voltage / real')
subplot(2,2,4)
get_subplot_var(f_vec, imag(homogenization.V_coil_vec), imag(discrete_strand.V_coil_vec), 'V [V]', 'voltage / imag')
sgtitle('FEM Variables')

% plot the errors
figure('name', 'simulation / error')
subplot(2,2,1)
get_subplot_err(f_vec, homogenization.P_dom_vec, discrete_strand.P_dom_vec, 'losses')
subplot(2,2,2)
get_subplot_err(f_vec, homogenization.W_dom_vec, discrete_strand.W_dom_vec, 'energy')
subplot(2,2,3)
get_subplot_err(f_vec, real(homogenization.V_coil_vec), real(discrete_strand.V_coil_vec), 'voltage / real')
subplot(2,2,4)
get_subplot_err(f_vec, imag(homogenization.V_coil_vec), imag(discrete_strand.V_coil_vec), 'voltage / imag')
sgtitle('FEM Errors')

end

function get_subplot_var(f_vec, v_homogenization, v_discrete_strand, str_label, str_title)
% Plot a variable (log scale).
%
%    Parameters:
%        f_vec (vector): frequency vector
%        v_homogenization (vector): variable for the simulation with the homogenized material parameters 
%        v_discrete_strand (vector): variable for the simulation of all the discrete strands 
%        str_label (str): label of the variable 
%        str_title (str): title of the plot 

loglog(f_vec, v_homogenization, '-r')
hold('on')
loglog(f_vec, v_discrete_strand, '--g')
legend({'homogenization', 'discrete strand'}, 'interpreter', 'none')
xlabel('f [kHz]')
ylabel(str_label)
title(str_title)

end

function get_subplot_err(f_vec, v_homogenization, v_discrete_strand, str_title)
% Plot the error for a variable (lin scale).
%
%    Parameters:
%        f_vec (vector): frequency vector
%        v_homogenization (vector): variable for the simulation with the homogenized material parameters 
%        v_discrete_strand (vector): variable for the simulation of all the discrete strands 
%        str_title (str): title of the plot 

err = abs((v_homogenization-v_discrete_strand)./v_discrete_strand);
semilogx(f_vec, 100.*err, 'r')
legend({'error'}, 'interpreter', 'none')
xlabel('f [kHz]')
ylabel('error [%]')
title(str_title)

end