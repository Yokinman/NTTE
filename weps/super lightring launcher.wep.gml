#define init
	global.sprWep = sprite_add_weapon("../sprites/weps/sprSuperLightningRingLauncher.png", 7, 4);
	global.sprWepLocked = mskNone;
	
#define weapon_name   return (weapon_avail() ? "SUPER LIGHTRING LAUNCHER" : "LOCKED");
#define weapon_text   return "EYE OF THE STORM";
#define weapon_swap   return sndSwapEnergy;
#define weapon_sprt   return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area   return (weapon_avail() ? 13 : -1); // 6-1
#define weapon_type   return type_energy;
#define weapon_cost   return 8;
#define weapon_load   return 90; // 3 Seconds
#define weapon_auto   return true;
#define weapon_avail  return unlock_get("pack:trench");

#define weapon_reloaded
	sound_play(sndLightningReload);
	
#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
	
	 // Projectile:
	with(obj_create(x, y, "LightningDisc")){
		motion_add(other.gunangle, 14);
		creator = f.creator;
		team = other.team;
		roids = f.roids;
		charge *= 2.5;
		charge_spd /= 2;
		stretch *= 1.2;
		radius *= 4/3;
		super = 1.2;
	}
	
	 // Effects:
	sound_play_pitchvol(sndLightningCannon,    1.5, 0.6)
	sound_play_pitchvol(sndLightningCannonUpg, 0.5, 0.4);
	
	
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