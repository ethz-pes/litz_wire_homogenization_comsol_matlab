function [sigma_vec, mu_vec] = get_homogenization_material(fem)
% Extract the homogenized material parameters from the FEM values.
%
%    Extract the homogenized material parameters:
%        - such that the energy density is matching
%        - such that the loss density is matching
%
%    Parameters:
%        fem (struct): struct with the FEM values
%
%    Returns:
%        sigma_vec (vector): extracted complex conductivity
%        mu_vec (vector): extracted permeability conductivity
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% extract the FEM values
f_vec = fem.f_vec;
p_skin_vec = fem.p_skin_vec;
w_skin_vec = fem.w_skin_vec;
J_skin_tot_vec = fem.J_skin_tot_vec;
p_prox_vec = fem.p_prox_vec;
w_prox_vec = fem.w_prox_vec;
B_prox_tot_vec = fem.B_prox_tot_vec;

% angular frequency
w_vec = 2.*pi.*f_vec;

% compute the apparent power
power_skin_vec = p_skin_vec+1i.*w_vec.*(2.*w_skin_vec);
power_prox_vec = p_prox_vec+1i.*w_vec.*(2.*w_prox_vec);

% skin effect simulation (match energy and losses)
rho_vec = power_skin_vec./(J_skin_tot_vec.^2);
sigma_vec = 1./rho_vec;

% proximity effect simulation (match energy and losses)
kappa_vec = conj(power_prox_vec)./(w_vec.^2.*B_prox_tot_vec.^2);
mu_vec = 1./(4.*pi.*1e-7.*1i.*w_vec.*kappa_vec);

end
