#define init
	global.sprWep = sprite_add_weapon("../sprites/weps/sprQuasarCannon.png", 20, 5);
	global.sprWepLocked = mskNone;
	
#define weapon_name   return (weapon_avail() ? "QUASAR CANNON" : "LOCKED");
#define weapon_text   return "PULSATING";
#define weapon_swap   return sndSwapEnergy;
#define weapon_sprt   return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area   return (weapon_avail() ? 18 : -1); // 1-1 L1
#define weapon_type   return type_energy;
#define weapon_cost   return 16;
#define weapon_load   return 159; // 5.3 Seconds
#define weapon_avail  return unlock_get("pack:trench");

#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
	
	 // Projectile:
	var _brain = skill_get(mut_laser_brain);
	with(obj_create(x, y, "QuasarRing")){
		motion_add(other.gunangle + orandom(8 * other.accuracy), 4);
		image_angle = direction;
		image_yscale = 0;
		creator = f.creator;
		team = other.team;
		ring_size = 0.6 * power(1.2, _brain);
	}
	
	 // Effects:
	weapon_post(20, -24, 8);
	sound_play_gun(_brain ? sndPlasmaBigUpg       : sndPlasmaBig, 0.4, -0.5);
	sound_play_gun(_brain ? sndLightningCannonUpg : sndLaser,     0.4, -0.5);
	sound_play_pitchvol(sndExplosion, 0.8, 1.5);
	motion_add(gunangle + 180, 5);
	
	
/// SCRIPTS
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define wepfire_init(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepfire_init', _wep);
#define wepammo_draw(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_draw', _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_fire', _wep);