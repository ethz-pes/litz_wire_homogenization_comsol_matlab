function model = get_simulation_model_homogenization(wire, domain, mesh, f_vec)
% Create the COMSOL FEM model for circular coil with a litz wire with homogenized parameters.
%
%    Using 2D rotation symmetric FEM simulation with COMSOL.
%    Define variables for the losses, energy, and induced voltage.
%
%    Parameters:
%        wire (struct): struct with the litz wire parameters
%        domain (struct): struct with the simulation domain and coil geometry
%        mesh (struct): struct with mesh size parameters
%        f_vec (vector): frequency vector
%
%    Returns:
%        model (model): COMSOL model
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% add to path
import('com.comsol.model.*')
import('com.comsol.model.util.*')

% create model
model = ModelUtil.create('model');
model.param('default').label('default');
model.component.create('comp', true);
model.component('comp').label('comp');

% construct the model
get_param(model, wire, domain, mesh);
get_geom(model);
get_sel(model)
get_var_op(model)
get_mat(model)
get_mf(model)
get_mesh(model)
get_sol(model, f_vec)

end

function get_param(model, wire, domain, mesh)
% Add the parameters.
%
%    Parameters:
%        model (model): COMSOL model
%        wire (struct): struct with the litz wire parameters
%        domain (struct): struct with the simulation domain and coil geometry
%        mesh (struct): struct with mesh size parameters

n = wire.n;
d_wire = wire.d_wire;
d_litz = wire.d_litz;
r_dom = domain.r_dom;
r_coil = domain.r_coil;
h_air_max = mesh.h_air_max;
h_air_min = mesh.h_air_min;
h_wire_max = mesh.h_wire_max;
h_wire_min = mesh.h_wire_min;

model.param.set('r_dom', r_dom);
model.param.set('r_coil', r_coil);
model.param.set('d_litz', d_litz);
model.param.set('d_wire', d_wire);
model.param.set('h_air_max', h_air_max);
model.param.set('h_air_min', h_air_min);
model.param.set('h_wire_max', h_wire_max);
model.param.set('h_wire_min', h_wire_min);
model.param.set('n', n);
model.param.set('I_wire_peak', 1.0);

f_vec = wire.f_vec;
mu_vec = wire.mu_vec;
sigma_vec = wire.sigma_vec;

get_interp(model, 'sigma_r_fct', f_vec, real(sigma_vec))
get_interp(model, 'sigma_i_fct', f_vec, imag(sigma_vec))
get_interp(model, 'mu_r_fct', f_vec, real(mu_vec))
get_interp(model, 'mu_i_fct', f_vec, imag(mu_vec))

end

function get_interp(model, tag, x_vec, y_vec)
% Add an interpolation function.
%
%    Parameters:
%        model (model): COMSOL model
%        tag (str): tag of the interpolation
%        x_vec (vector): x data
%        y_vec (vector): y data

data = arrayfun(@num2str, [x_vec ; y_vec], 'UniformOutput', 0).';

model.func.create(tag, 'Interpolation');
model.func(tag).label(tag);
model.func(tag).set('funcname', tag);
model.func(tag).set('source', 'table');
model.func(tag).set('table', data);

end

function get_geom(model)
% Add the geometry.
%
%    Parameters:
%        model (model): COMSOL model

model.component('comp').geom.create('geom', 2);
model.component('comp').geom('geom').label('geom');
model.component('comp').geom('geom').axisymmetric(true);

model.component('comp').geom('geom').create('dom', 'Circle');
model.component('comp').geom('geom').feature('dom').label('dom');
model.component('comp').geom('geom').feature('dom').set('angle', 180);
model.component('comp').geom('geom').feature('dom').set('r', 'r_dom');
model.component('comp').geom('geom').feature('dom').set('rot', -90);
model.component('comp').geom('geom').feature('dom').set('pos', [0.0, 0.0]);
model.component('comp').geom('geom').feature('dom').set('createselection', 'on');

model.component('comp').geom('geom').create('wire', 'Circle');
model.component('comp').geom('geom').feature('wire').label('wire_origin');
model.component('comp').geom('geom').feature('wire').set('pos', {'r_coil', '0'});
model.component('comp').geom('geom').feature('wire').set('r', 'd_wire/2');
model.component('comp').geom('geom').feature('wire').set('createselection', 'on');

model.component('comp').geom('geom').feature('fin').label('union');
model.component('comp').geom('geom').run;

end

function get_sel(model)
% Add the selections.
%
%    Parameters:
%        model (model): COMSOL model

model.component('comp').selection.create('wire', 'Union');
model.component('comp').selection('wire').label('wire');
model.component('comp').selection('wire').set('input', 'geom_wire_dom');

model.component('comp').selection.create('air', 'Difference');
model.component('comp').selection('air').label('air');
model.component('comp').selection('air').set('add', {'geom_dom_dom'});
model.component('comp').selection('air').set('subtract', {'geom_wire_dom'});

model.component('comp').selection.create('all', 'Union');
model.component('comp').selection('all').label('all');
model.component('comp').selection('all').set('input', {'wire', 'air'});

end

function get_var_op(model)
% Add the variables and operators.
%
%    Parameters:
%        model (model): COMSOL model

model.component('comp').variable.create('var_wire');
model.component('comp').variable('var_wire').label('var_wire');
model.component('comp').variable('var_wire').selection.geom('geom', 2);
model.component('comp').variable('var_wire').selection.named('wire');
model.component('comp').variable('var_wire').set('mu_c', 'mu_r_fct(freq)+1i*mu_i_fct(freq)');
model.component('comp').variable('var_wire').set('sigma_c', 'sigma_r_fct(freq)+1i*sigma_i_fct(freq)');
model.component('comp').variable('var_wire').set('E_norm', 'abs(mf.Jphi/sigma_c)');
model.component('comp').variable('var_wire').set('H_norm', 'mf.normH');

model.component('comp').variable.create('var_air');
model.component('comp').variable('var_air').label('var_air');
model.component('comp').variable('var_air').selection.geom('geom', 2);
model.component('comp').variable('var_air').selection.named('air');
model.component('comp').variable('var_air').set('mu_c', '1');
model.component('comp').variable('var_air').set('sigma_c', '0');
model.component('comp').variable('var_air').set('E_norm', '0');
model.component('comp').variable('var_air').set('H_norm', 'mf.normH');

model.component('comp').variable.create('var_all');
model.component('comp').variable('var_all').label('var_all');
model.component('comp').variable('var_all').set('p_dom', 'real(sigma_c)*E_norm^2-2*pi*freq*mu0_const*imag(mu_c)*H_norm^2');
model.component('comp').variable('var_all').set('w_dom', '0.5*(mu0_const*real(mu_c)*H_norm^2-imag(sigma_c)/(2*pi*freq)*E_norm^2)');
model.component('comp').variable('var_all').set('P_dom', 'int_all(p_dom)');
model.component('comp').variable('var_all').set('W_dom', 'int_all(w_dom)');
model.component('comp').variable('var_all').set('V_coil', 'mf.VCoil_wire');

model.component('comp').cpl.create('int_all', 'Integration');
model.component('comp').cpl('int_all').label('int_all');
model.component('comp').cpl('int_all').set('opname', 'int_all');
model.component('comp').cpl('int_all').selection.named('all');

model.component('comp').cpl.create('int_wire', 'Integration');
model.component('comp').cpl('int_wire').label('int_wire');
model.component('comp').cpl('int_wire').set('opname', 'int_wire');
model.component('comp').cpl('int_wire').selection.named('wire');

end

function get_mat(model)
% Add the materials.
%
%    Parameters:
%        model (model): COMSOL model

model.component('comp').material.create('wire', 'Common');
model.component('comp').material('wire').selection.named('wire');
model.component('comp').material('wire').label('wire');
model.component('comp').material('wire').propertyGroup('def').set('relpermeability', 'mu_c');
model.component('comp').material('wire').propertyGroup('def').set('relpermittivity', '0');

model.component('comp').material.create('air', 'Common');
model.component('comp').material('air').selection.named('air');
model.component('comp').material('air').label('air');
model.component('comp').material('air').propertyGroup('def').set('electricconductivity', 'sigma_c');
model.component('comp').material('air').propertyGroup('def').set('relpermeability', 'mu_c');
model.component('comp').material('air').propertyGroup('def').set('relpermittivity', '0');

end

function get_mf(model)
% Add the magnetic field data.
%
%    Parameters:
%        model (model): COMSOL model

model.component('comp').physics.create('mf', 'InductionCurrents', 'geom');
model.component('comp').physics('mf').identifier('mf');
model.component('comp').physics('mf').label('mf');
model.component('comp').physics('mf').feature('al1').label('ampere');
model.component('comp').physics('mf').feature('mi1').label('insulation');
model.component('comp').physics('mf').feature('init1').label('initial');

model.component('comp').physics('mf').create('wire', 'Coil', 2);
model.component('comp').physics('mf').feature('wire').label('wire');
model.component('comp').physics('mf').feature('wire').selection.named('wire');
model.component('comp').physics('mf').feature('wire').set('ConductorModel', 'Multi');
model.component('comp').physics('mf').feature('wire').set('CoilName', 'wire');
model.component('comp').physics('mf').feature('wire').set('sigmaCoil', 'sigma_c');
model.component('comp').physics('mf').feature('wire').set('coilWindArea', 'int_wire(1)');
model.component('comp').physics('mf').feature('wire').set('N', 1);
model.component('comp').physics('mf').feature('wire').set('ICoil', 'I_wire_peak');

end

function get_mesh(model)
% Add the mesh.
%
%    Parameters:
%        model (model): COMSOL model

model.component('comp').mesh.create('mesh');
model.component('comp').mesh('mesh').label('mesh');
model.component('comp').mesh('mesh').create('ftri', 'FreeTri');
model.component('comp').mesh('mesh').feature('ftri').label('tri');
model.component('comp').mesh('mesh').feature('size').label('size');

model.component('comp').mesh('mesh').feature('ftri').create('wire', 'Size');
model.component('comp').mesh('mesh').feature('ftri').feature('wire').label('wire');
model.component('comp').mesh('mesh').feature('ftri').feature('wire').selection.geom('geom', 2);
model.component('comp').mesh('mesh').feature('ftri').feature('wire').selection.named('wire');
model.component('comp').mesh('mesh').feature('ftri').feature('wire').set('custom', 'on');
model.component('comp').mesh('mesh').feature('ftri').feature('wire').set('hmax', 'h_wire_max');
model.component('comp').mesh('mesh').feature('ftri').feature('wire').set('hmaxactive', true);
model.component('comp').mesh('mesh').feature('ftri').feature('wire').set('hmin', 'h_wire_min');
model.component('comp').mesh('mesh').feature('ftri').feature('wire').set('hminactive', true);

model.component('comp').mesh('mesh').feature('ftri').create('air', 'Size');
model.component('comp').mesh('mesh').feature('ftri').feature('air').label('air');
model.component('comp').mesh('mesh').feature('ftri').feature('air').selection.geom('geom', 2);
model.component('comp').mesh('mesh').feature('ftri').feature('air').selection.named('air');
model.component('comp').mesh('mesh').feature('ftri').feature('air').set('custom', 'on');
model.component('comp').mesh('mesh').feature('ftri').feature('air').set('hmax', 'h_air_max');
model.component('comp').mesh('mesh').feature('ftri').feature('air').set('hmaxactive', true);
model.component('comp').mesh('mesh').feature('ftri').feature('air').set('hmin', 'h_air_min');
model.component('comp').mesh('mesh').feature('ftri').feature('air').set('hminactive', true);

model.component('comp').mesh('mesh').run;

end

function get_sol(model, f_vec)
% Add the solution.
%
%    Parameters:
%        model (model): COMSOL model
%        f_vec (vector): frequency vector

model.study.create('std');
model.study('std').label('study');
model.study('std').setGenPlots(false);
model.study('std').create('freq', 'Frequency');
model.study('std').feature('freq').set('plist', f_vec);
model.study('std').feature('freq').label('freq');

model.sol.create('sol');
model.sol('sol').label('sol');
model.sol('sol').study('std');
model.sol('sol').attach('std');
model.sol('sol').create('st', 'StudyStep');
model.sol('sol').create('v', 'Variables');
model.sol('sol').create('s', 'Stationary');
model.sol('sol').feature('s').set('stol', 1e-5);

model.result.numerical.create('eval_int', 'EvalGlobal');
model.result.numerical('eval_int').label('eval_int');
model.result.numerical('eval_int').set('probetag', 'none');
model.result.numerical('eval_int').set('expr', {'P_dom' 'W_dom' 'V_coil'});

get_plot(model, 'B', 'mf.normB')
get_plot(model, 'J', 'mf.normJ')
get_plot(model, 'p_dom', 'p_dom')
get_plot(model, 'w_dom', 'w_dom')

end

function get_plot(model, tag, expr)
% Add a 2D surface plot.
%
%    Parameters:
%        model (model): COMSOL model
%        tag (str): tag of the plot
%        expr (str): expression to be plotted

model.result.create(tag, 'PlotGroup2D');
model.result(tag).label(tag);
model.result(tag).create('surf', 'Surface');
model.result(tag).feature('surf').label('data');
model.result(tag).feature('surf').set('resolution', 'normal');
model.result(tag).feature('surf').set('expr', expr);

end