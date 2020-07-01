function model = get_homogenization_model(wire, mesh, f_vec)

import('com.comsol.model.*')
import('com.comsol.model.util.*')

model = ModelUtil.create('model');
model.param('default').label('default');
model.component.create('comp', true);
model.component('comp').label('comp');

get_param(model, wire, mesh)
get_geom(model)
get_sel(model)
get_var(model)
get_mat(model)
get_mf(model)
get_mesh(model)
get_sol(model, f_vec)


end

function get_param(model, wire, mesh)

d_litz = wire.d_litz;
fill = wire.fill;
sigma = wire.sigma;
h_max = mesh.h_max;
h_min = mesh.h_min;

r_litz = d_litz./2;
A_wire = 2.*((pi.*r_litz.^2)./4);
A_all = A_wire./fill;
y_dom = sqrt(A_all./sqrt(3));
x_dom = sqrt(A_all.*sqrt(3));

model.param.set('r_litz', r_litz);
model.param.set('x_dom', x_dom);
model.param.set('y_dom', y_dom);
model.param.set('sigma', sigma);
model.param.set('h_max', h_max);
model.param.set('h_min', h_min);
model.param.set('B_prox', 1.0);
model.param.set('I_skin', 1.0);

end

function get_geom(model)

model.component('comp').geom.create('geom', 2);
model.component('comp').geom('geom').label('geom');

model.component('comp').geom('geom').create('dom', 'Rectangle');
model.component('comp').geom('geom').feature('dom').label('dom');
model.component('comp').geom('geom').feature('dom').set('size', {'x_dom' 'y_dom'});
model.component('comp').geom('geom').feature('dom').set('pos', {'0' '0'});

model.component('comp').geom('geom').create('wire_1', 'Circle');
model.component('comp').geom('geom').feature('wire_1').label('wire_1');
model.component('comp').geom('geom').feature('wire_1').set('r', 'r_litz');
model.component('comp').geom('geom').feature('wire_1').set('pos', {'0' '0'});
model.component('comp').geom('geom').feature('wire_1').set('rot', 0);
model.component('comp').geom('geom').feature('wire_1').set('angle', 90);

model.component('comp').geom('geom').create('wire_2', 'Circle');
model.component('comp').geom('geom').feature('wire_2').label('wire_2');
model.component('comp').geom('geom').feature('wire_2').set('r', 'r_litz');
model.component('comp').geom('geom').feature('wire_2').set('pos', {'x_dom' 'y_dom'});
model.component('comp').geom('geom').feature('wire_2').set('rot', 180);
model.component('comp').geom('geom').feature('wire_2').set('angle', 90);

model.component('comp').geom('geom').feature('fin').label('union');
model.component('comp').geom('geom').run;

end

function get_sel(model)

model.component('comp').selection.create('wire', 'Explicit');
model.component('comp').selection('wire').label('wire');
model.component('comp').selection('wire').set([1 3]);

model.component('comp').selection.create('wire_1', 'Explicit');
model.component('comp').selection('wire_1').label('wire_1');
model.component('comp').selection('wire_1').set(1);

model.component('comp').selection.create('wire_2', 'Explicit');
model.component('comp').selection('wire_2').label('wire_2');
model.component('comp').selection('wire_2').set(3);

model.component('comp').selection.create('air', 'Explicit');
model.component('comp').selection('air').label('air');
model.component('comp').selection('air').set(2);

model.component('comp').selection.create('all', 'Explicit');
model.component('comp').selection('all').label('all');
model.component('comp').selection('all').set([1 2 3]);

model.component('comp').selection.create('bc_sym_all', 'Explicit');
model.component('comp').selection('bc_sym_all').label('bc_sym_all');
model.component('comp').selection('bc_sym_all').geom('geom', 1);
model.component('comp').selection('bc_sym_all').set([1 2 3 4 5 6 7 8]);

model.component('comp').selection.create('bc_sym_up_down', 'Explicit');
model.component('comp').selection('bc_sym_up_down').label('bc_sym_up_down');
model.component('comp').selection('bc_sym_up_down').geom('geom', 1);
model.component('comp').selection('bc_sym_up_down').set([2 4 5 6]);

model.component('comp').selection.create('bc_left', 'Explicit');
model.component('comp').selection('bc_left').label('bc_left');
model.component('comp').selection('bc_left').geom('geom', 1);
model.component('comp').selection('bc_left').set([1 3]);

model.component('comp').selection.create('bc_right', 'Explicit');
model.component('comp').selection('bc_right').label('bc_right');
model.component('comp').selection('bc_right').geom('geom', 1);
model.component('comp').selection('bc_right').set([7 8]);

end

function get_var(model)

model.component('comp').variable.create('var_skin');
model.component('comp').variable('var_skin').label('var_skin');
model.component('comp').variable('var_skin').set('J_skin', 'I_skin/(pi*r_litz^2)');
model.component('comp').variable('var_skin').set('I_skin_tot', 'abs(int_wire_1(mf_skin.Jz)-int_wire_2(mf_skin.Jz))');
model.component('comp').variable('var_skin').set('P_skin', 'int_all(mf_skin.normJ^2/sigma)');
model.component('comp').variable('var_skin').set('W_skin', '0.5*int_all(mf_skin.normB*mf_skin.normH)');
model.component('comp').variable('var_skin').set('p_skin', 'P_skin/int_all(1)');
model.component('comp').variable('var_skin').set('w_skin', 'W_skin/int_all(1)');
model.component('comp').variable('var_skin').set('J_skin_tot', 'I_skin_tot/int_all(1)');

model.component('comp').variable.create('var_prox');
model.component('comp').variable('var_prox').label('var_prox');
model.component('comp').variable('var_prox').set('A_prox', 'B_prox*x_dom');
model.component('comp').variable('var_prox').set('J_prox', '1i*2*pi*freq*sigma*A_prox');
model.component('comp').variable('var_prox').set('P_prox', 'int_all(mf_prox.normJ^2/sigma)');
model.component('comp').variable('var_prox').set('W_prox', '0.5*int_all(mf_prox.normB*mf_prox.normH)');
model.component('comp').variable('var_prox').set('phi_prox_tot', 'int_all(B_prox)');
model.component('comp').variable('var_prox').set('p_prox', 'P_prox/int_all(1)');
model.component('comp').variable('var_prox').set('w_prox', 'W_prox/int_all(1)');
model.component('comp').variable('var_prox').set('B_prox_tot', 'phi_prox_tot/int_all(1)');

model.component('comp').cpl.create('int_all', 'Integration');
model.component('comp').cpl('int_all').label('int_all');
model.component('comp').cpl('int_all').set('opname', 'int_all');
model.component('comp').cpl('int_all').selection.named('all');

model.component('comp').cpl.create('int_wire_1', 'Integration');
model.component('comp').cpl('int_wire_1').label('int_wire_1');
model.component('comp').cpl('int_wire_1').set('opname', 'int_wire_1');
model.component('comp').cpl('int_wire_1').selection.named('wire_1');

model.component('comp').cpl.create('int_wire_2', 'Integration');
model.component('comp').cpl('int_wire_2').label('int_wire_2');
model.component('comp').cpl('int_wire_2').set('opname', 'int_wire_2');
model.component('comp').cpl('int_wire_2').selection.named('wire_2');

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

model.component('comp').physics.create('mf_skin', 'InductionCurrents', 'geom');
model.component('comp').physics('mf_skin').identifier('mf_skin');
model.component('comp').physics('mf_skin').label('mf_skin');
model.component('comp').physics('mf_skin').field('magneticvectorpotential').field('A1');
model.component('comp').physics('mf_skin').field('magneticvectorpotential').component({'A1x' 'A1y' 'A1z'});
model.component('comp').physics('mf_skin').feature('al1').label('ampere');
model.component('comp').physics('mf_skin').feature('mi1').label('insulation');
model.component('comp').physics('mf_skin').feature('init1').label('initial');

model.component('comp').physics('mf_skin').create('bc_sym_all', 'PerfectMagneticConductor', 1);
model.component('comp').physics('mf_skin').feature('bc_sym_all').label('bc_sym_all');
model.component('comp').physics('mf_skin').feature('bc_sym_all').selection.named('bc_sym_all');

model.component('comp').physics('mf_skin').create('wire_1', 'ExternalCurrentDensity', 2);
model.component('comp').physics('mf_skin').feature('wire_1').label('wire_1');
model.component('comp').physics('mf_skin').feature('wire_1').selection.named('wire_1');
model.component('comp').physics('mf_skin').feature('wire_1').set('Je', {'0'; '0'; '+J_skin'});

model.component('comp').physics('mf_skin').create('wire_2', 'ExternalCurrentDensity', 2);
model.component('comp').physics('mf_skin').feature('wire_2').label('wire_2');
model.component('comp').physics('mf_skin').feature('wire_2').selection.named('wire_2');
model.component('comp').physics('mf_skin').feature('wire_2').set('Je', {'0'; '0'; '-J_skin'});

model.component('comp').physics.create('mf_prox', 'InductionCurrents', 'geom');
model.component('comp').physics('mf_prox').identifier('mf_prox');
model.component('comp').physics('mf_prox').field('magneticvectorpotential').field('A2');
model.component('comp').physics('mf_prox').field('magneticvectorpotential').component({'A2x' 'A2y' 'A2z'});
model.component('comp').physics('mf_prox').label('mf_prox');
model.component('comp').physics('mf_prox').feature('al1').label('ampere');
model.component('comp').physics('mf_prox').feature('mi1').label('insulation');
model.component('comp').physics('mf_prox').feature('init1').label('initial');

model.component('comp').physics('mf_prox').create('bc_sym_all', 'PerfectMagneticConductor', 1);
model.component('comp').physics('mf_prox').feature('bc_sym_all').label('bc_sym_up_down');
model.component('comp').physics('mf_prox').feature('bc_sym_all').selection.named('bc_sym_up_down');

model.component('comp').physics('mf_prox').create('bc_left', 'MagneticPotential', 1);
model.component('comp').physics('mf_prox').feature('bc_left').label('bc_left');
model.component('comp').physics('mf_prox').feature('bc_left').selection.named('bc_left');
model.component('comp').physics('mf_prox').feature('bc_left').set('A0', {'0'; '0'; '0'});

model.component('comp').physics('mf_prox').create('bc_right', 'MagneticPotential', 1);
model.component('comp').physics('mf_prox').feature('bc_right').label('bc_right');
model.component('comp').physics('mf_prox').feature('bc_right').selection.named('bc_right');
model.component('comp').physics('mf_prox').feature('bc_right').set('A0', {'0'; '0'; 'A_prox'});

model.component('comp').physics('mf_prox').create('wire_1', 'ExternalCurrentDensity', 2);
model.component('comp').physics('mf_prox').feature('wire_1').label('wire_1');
model.component('comp').physics('mf_prox').feature('wire_1').selection.named('wire_1');
model.component('comp').physics('mf_prox').feature('wire_1').set('Je', {'0'; '0'; '0'});

model.component('comp').physics('mf_prox').create('wire_2', 'ExternalCurrentDensity', 2);
model.component('comp').physics('mf_prox').feature('wire_2').label('wire_2');
model.component('comp').physics('mf_prox').feature('wire_2').selection.named('wire_2');
model.component('comp').physics('mf_prox').feature('wire_2').set('Je', {'0'; '0'; 'J_prox'});

end

function get_mesh(model)

model.component('comp').mesh.create('mesh');
model.component('comp').mesh('mesh').label('mesh');
model.component('comp').mesh('mesh').create('ftri', 'FreeTri');
model.component('comp').mesh('mesh').feature('ftri').label('tri');
model.component('comp').mesh('mesh').feature('size').label('size');

model.component('comp').mesh('mesh').feature('ftri').create('size', 'Size');
model.component('comp').mesh('mesh').feature('ftri').feature('size').label('size');
model.component('comp').mesh('mesh').feature('ftri').feature('size').set('custom', 'on');
model.component('comp').mesh('mesh').feature('ftri').feature('size').set('hmax', 'h_max');
model.component('comp').mesh('mesh').feature('ftri').feature('size').set('hmaxactive', true);
model.component('comp').mesh('mesh').feature('ftri').feature('size').set('hmin', 'h_min');
model.component('comp').mesh('mesh').feature('ftri').feature('size').set('hminactive', true);

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
model.result.numerical('eval_int').set('expr', {'P_skin' 'W_skin' 'P_prox' 'W_prox' 'I_skin_tot' 'phi_prox_tot'});

model.result.numerical.create('eval_density', 'EvalGlobal');
model.result.numerical('eval_density').label('eval_density');
model.result.numerical('eval_density').set('probetag', 'none');
model.result.numerical('eval_density').set('expr', {'p_skin' 'w_skin' 'p_prox' 'w_prox' 'J_skin_tot' 'B_prox_tot'});

get_plot(model, 'skin_B', 'mf_skin.normB');
get_plot(model, 'skin_J', 'mf_skin.normJ');
get_plot(model, 'prox_B', 'mf_prox.normB');
get_plot(model, 'prox_J', 'mf_prox.normJ');

end

function get_plot(model, tag, expr)

model.result.create(tag, 'PlotGroup2D');
model.result(tag).label(tag);
model.result(tag).create('surf', 'Surface');
model.result(tag).feature('surf').label('data');
model.result(tag).feature('surf').set('resolution', 'normal');
model.result(tag).feature('surf').set('expr', expr);

end