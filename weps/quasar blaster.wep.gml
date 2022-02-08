#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprQuasarBlaster.png", 4, 5);
	global.sprWepLocked = sprTemp;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name         return (weapon_avail() ? "QUASAR BLASTER" : "LOCKED");
#define weapon_text         return "SO FLEXIBLE";
#define weapon_swap         return sndSwapEnergy;
#define weapon_sprt         return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area         return (weapon_avail() ? 9 : -1); // 4-1
#define weapon_type         return type_energy;
#define weapon_cost         return 3;
#define weapon_load         return 15; // 0.5 Seconds
#define weapon_avail        return call(scr.unlock_get, "pack:" + weapon_ntte_pack());
#define weapon_ntte_pack    return "trench";
#define weapon_ntte_quasar  return true;

#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	 // Quasar Beam:
	with(call(scr.projectile_create, x, y, "QuasarBeam", gunangle + orandom(4 * accuracy))){
		primary       = _fire.primary;
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
#macro  call                                                                                    script_ref_call
#macro  obj                                                                                     global.obj
#macro  scr                                                                                     global.scr
#macro  spr                                                                                     global.spr
#macro  snd                                                                                     global.snd
#macro  msk                                                                                     spr.msk
#macro  mus                                                                                     snd.mus
#macro  lag                                                                                     global.debug_lag
#macro  ntte                                                                                    global.ntte_vars
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  current_frame_active                                                                    ((current_frame + global.epsilon) % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        if(((_primary ? '' : 'b') + _name) in self) variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);