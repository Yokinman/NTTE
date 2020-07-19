#define init
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprQuasarBlaster.png", 4, 5);
	global.sprWepLocked = mskNone;
	
#define weapon_name   return (weapon_avail() ? "QUASAR BLASTER" : "LOCKED");
#define weapon_text   return "SO FLEXIBLE";
#define weapon_swap   return sndSwapEnergy;
#define weapon_sprt   return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area   return (weapon_avail() ? 9 : -1); // 4-1
#define weapon_type   return type_energy;
#define weapon_cost   return 3;
#define weapon_load   return 15; // 0.5 Seconds
#define weapon_avail  return unlock_get("pack:trench");

#define weapon_fire(w)
	var f = weapon_fire_init(w);
	w = f.wep;
	
	 // Quasar Beam:
	with(projectile_create(x, y, "QuasarBeam", gunangle + orandom(4 * accuracy), 0)){
		roids         = f.roids;
		turn_factor   = 1/10;
		shrink_delay  = 8;
		scale_goal    = 0.5;
		bend_fric     = 0.4;
		image_xscale *= scale_goal;
		image_yscale *= scale_goal;
	}
	
	 // Sounds:
	var _brain = skill_get(mut_laser_brain);
	sound_play_pitchvol((_brain ? sndLaserUpg : sndLaser), 0.6 + random(0.1), 1.0);
	sound_play_pitchvol(sndPlasmaHit,                      1.5,               0.6);
	
	 // Effects:
	weapon_post(12, -12, 4);
	
	
/// SCRIPTS
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define projectile_create(_x, _y, _obj, _dir, _spd)                                     return  mod_script_call(   'mod', 'telib', 'projectile_create', _x, _y, _obj, _dir, _spd);
#define weapon_fire_init(_wep)                                                          return  mod_script_call(   'mod', 'telib', 'weapon_fire_init', _wep);
#define weapon_ammo_fire(_wep)                                                          return  mod_script_call(   'mod', 'telib', 'weapon_ammo_fire', _wep);
#define weapon_ammo_hud(_wep)                                                           return  mod_script_call(   'mod', 'telib', 'weapon_ammo_hud', _wep);
#define weapon_get_red(_wep)                                                            return  mod_script_call(   'mod', 'telib', 'weapon_get_red', _wep);
#define wep_raw(_wep)                                                                   return  mod_script_call_nc('mod', 'telib', 'wep_raw', _wep);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);