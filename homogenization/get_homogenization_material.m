function [sigma_vec, mu_vec] = get_homogenization_material(fem)
% Extract data from the FEM model
%     - model: COMSOL model
%     - wire: struct with the wire parameters
%     - mesh: struct with the mesh size
%     - f_vec: frequency vector
%     - homogenization: struct with the homogenized parameters of the wire
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f_vec = fem.f_vec;
p_skin_vec = fem.p_skin_vec;
w_skin_vec = fem.w_skin_vec;
J_skin_tot_vec = fem.J_skin_tot_vec;
p_prox_vec = fem.p_prox_vec;
w_prox_vec = fem.w_prox_vec;
B_prox_tot_vec = fem.B_prox_tot_vec;

%% circuit
w_vec = 2.*pi.*f_vec;

%% skin
% sigma = sigma_r+1i*sigma_i
% J = sigma*E
% P = sigma_r*(J^2)/(sigma_r^2+sigma_i^2)
% W = 0.5*(sigma_i/w)*(J^2)/(sigma_r^2+sigma_i^2)

sigma_r_vec = (J_skin_tot_vec.^2.*p_skin_vec)./(p_skin_vec.^2+4.*w_vec.^2.*w_skin_vec.^2);
sigma_i_vec = (2.*J_skin_tot_vec.^2.*w_vec.*w_skin_vec)./(p_skin_vec.^2+4.*w_vec.^2.*w_skin_vec.^2);
sigma_vec = sigma_r_vec+1i.*sigma_i_vec;

%% prox
% mu = mu_r+1i*mu_i
% B = mu*H
% P = -(mu_i*w)*(B^2)/(mu_r^2+mu_i^2)
% W = 0.5*mu_r*(B^2)/(mu_r^2+mu_i^2)

mu_r_vec = (2.*B_prox_tot_vec.^2.*w_vec.^2.*w_prox_vec)./(p_prox_vec.^2+4.*w_vec.^2.*w_prox_vec.^2);
mu_i_vec = -(B_prox_tot_vec.^2.*p_prox_vec.*w_vec)./(p_prox_vec.^2+4.*w_vec.^2.*w_prox_vec.^2);
mu_vec = (mu_r_vec+1i.*mu_i_vec)./(4.*pi.*1e-7);

end