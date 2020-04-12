#define init
	global.sprWep = sprite_add_weapon("../sprites/weps/sprHyperBubbler.png", 8, 4);
	global.sprWepLocked = mskNone;
	
#define weapon_name   return (weapon_avail() ? "HYPER BUBBLER" : "LOCKED");
#define weapon_text   return "POWER WASHER";
#define weapon_type   return 4; // Explosive
#define weapon_cost   return 3; // 3 Ammo
#define weapon_load   return 7; // 0.43 Seconds
#define weapon_area   return (weapon_avail() ? 15 : -1); // 7-2
#define weapon_swap   return sndSwapExplosive;
#define weapon_sprt   return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_avail  return unlock_get("pack:oasis");

#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
	
	 // Projectile:
	var	l = 20,
		d = gunangle + (accuracy * orandom(3));
		
	with(obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "HyperBubble")){
		creator = f.creator;
		team = other.team;
		direction = d;
	}
	
	 // Effects:
	weapon_post(10, 20, 5);
	motion_add(d + 180, 4);
	sleep(35);
	
	 // Sounds:
	sound_play_pitchvol(sndPlasmaRifle,     0.9 + random(0.3), 1.0);
	sound_play_pitchvol(sndHyperSlugger,    0.9 + random(0.3), 0.6);
	
	
/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define wepfire_init(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepfire_init', _wep);
#define wepammo_draw(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_draw', _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_fire', _wep);