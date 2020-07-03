function model = get_simulation_model_discrete_strand(wire, domain, mesh, f_vec)

import('com.comsol.model.*')
import('com.comsol.model.util.*')

model = ModelUtil.create('model');
model.param('default').label('default');
model.component.create('comp', true);
model.component('comp').label('comp');

[x_vec, y_vec] = get_param(model, wire, domain, mesh);
get_geom(model, x_vec, y_vec);
get_sel(model)
get_var_op(model)
get_mat(model)
get_mf(model)
get_mesh(model)
get_sol(model, f_vec)

end

function [x_vec, y_vec] = get_param(model, wire, domain, mesh)

n = wire.n;
sigma = wire.sigma;
r_dom = domain.r_dom;
r_coil = domain.r_coil;
d_litz = wire.d_litz;
x_vec = wire.x_vec;
y_vec = wire.y_vec;
h_air_max = mesh.h_air_max;
h_air_min = mesh.h_air_min;
h_wire_max = mesh.h_wire_max;
h_wire_min = mesh.h_wire_min;

%% set param
model.param.set('r_dom', r_dom);
model.param.set('r_coil', r_coil);
model.param.set('d_litz', d_litz);
model.param.set('sigma', sigma);
model.param.set('h_air_max', h_air_max);
model.param.set('h_air_min', h_air_min);
model.param.set('h_wire_max', h_wire_max);
model.param.set('h_wire_min', h_wire_min);
model.param.set('n', n);
model.param.set('I_wire_peak', 1.0);

end

function get_geom(model, x_vec, y_vec)

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

model.component('comp').geom('geom').create('wire_origin', 'Circle');
model.component('comp').geom('geom').feature('wire_origin').label('wire_origin');
model.component('comp').geom('geom').feature('wire_origin').set('pos', {'r_coil', '0'});
model.component('comp').geom('geom').feature('wire_origin').set('r', 'd_litz/2');

model.component('comp').geom('geom').create('wire_all', 'Copy');
model.component('comp').geom('geom').feature('wire_all').label('wire_all');
model.component('comp').geom('geom').feature('wire_all').selection('input').set({'wire_origin'});
model.component('comp').geom('geom').feature('wire_all').set('keep', false);
model.component('comp').geom('geom').feature('wire_all').set('displx', num2str(x_vec));
model.component('comp').geom('geom').feature('wire_all').set('disply', num2str(y_vec));
model.component('comp').geom('geom').feature('wire_all').set('createselection', 'on');

model.component('comp').geom('geom').feature('fin').label('union');
model.component('comp').geom('geom').run;

end

function get_sel(model)

model.component('comp').selection.create('wire', 'Union');
model.component('comp').selection('wire').label('wire');
model.component('comp').selection('wire').set('input', 'geom_wire_all_dom');

model.component('comp').selection.create('air', 'Difference');
model.component('comp').selection('air').label('air');
model.component('comp').selection('air').set('add', {'geom_dom_dom'});
model.component('comp').selection('air').set('subtract', {'geom_wire_all_dom'});

model.component('comp').selection.create('all', 'Union');
model.component('comp').selection('all').label('all');
model.component('comp').selection('all').set('input', {'wire', 'air'});

end

function get_var_op(model)

model.component('comp').variable.create('var_all');
model.component('comp').variable('var_all').label('var_all');
model.component('comp').variable('var_all').set('p_dom', '2*mf.Qh');
model.component('comp').variable('var_all').set('w_dom', '2*mf.Wav');
model.component('comp').variable('var_all').set('P_dom', 'int_all(p_dom)');
model.component('comp').variable('var_all').set('W_dom', 'int_all(w_dom)');
model.component('comp').variable('var_all').set('V_coil', 'mf.VCoil_wire/n');

model.component('comp').cpl.create('int_all', 'Integration');
model.component('comp').cpl('int_all').label('int_all');
model.component('comp').cpl('int_all').set('opname', 'int_all');
model.component('comp').cpl('int_all').selection.named('all');

end

function get_mat(model)

model.component('comp').material.create('wire', 'Common');
model.component('comp').material('wire').selection.named('wire');
model.component('comp').material('wire').label('wire');
model.component('comp').material('wire').propertyGroup('def').set('electricconductivity', 'sigma');
model.component('comp').material('wire').propertyGroup('def').set('relpermeability', '1');
model.component('comp').material('wire').propertyGroup('def').set('relpermittivity', '0');

model.component('comp').material.create('air', 'Common');
model.component('comp').material('air').selection.named('air');
model.component('comp').material('air').label('air');
model.component('comp').material('air').propertyGroup('def').set('relpermeability', '1');
model.component('comp').material('air').propertyGroup('def').set('electricconductivity', '0');
model.component('comp').material('air').propertyGroup('def').set('relpermittivity', '0');

end

function get_mf(model)

model.component('comp').physics.create('mf', 'InductionCurrents', 'geom');
model.component('comp').physics('mf').identifier('mf');
model.component('comp').physics('mf').label('mf');
model.component('comp').physics('mf').feature('al1').label('ampere');
model.component('comp').physics('mf').feature('mi1').label('insulation');
model.component('comp').physics('mf').feature('init1').label('initial');

model.component('comp').physics('mf').create('wire', 'Coil', 2);
model.component('comp').physics('mf').feature('wire').label('wire');
model.component('comp').physics('mf').feature('wire').selection.named('wire');
model.component('comp').physics('mf').feature('wire').set('ConductorModel', 'Single');
model.component('comp').physics('mf').feature('wire').set('CoilName', 'wire');
model.component('comp').physics('mf').feature('wire').set('coilGroup', true);
model.component('comp').physics('mf').feature('wire').set('ICoil', 'I_wire_peak/n');

end

function get_mesh(model)

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

model.result.create(tag, 'PlotGroup2D');
model.result(tag).label(tag);
model.result(tag).create('surf', 'Surface');
model.result(tag).feature('surf').label('data');
model.result(tag).feature('surf').set('resolution', 'normal');
model.result(tag).feature('surf').set('expr', expr);

end