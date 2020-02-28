#define init
	global.sprWep = sprite_add_weapon("../sprites/weps/sprNetGun.png", 3, 2);
	global.sprWepLocked = mskNone;
	
#define weapon_name         return (weapon_avail() ? "NET LAUNCHER" : "LOCKED");
#define weapon_text         return "CATCH OF THE DAY";
#define weapon_type         return 3;  // Bolt
#define weapon_cost         return 10; // 10 Ammo
#define weapon_load         return 36; // 1.2 Seconds
#define weapon_area         return (weapon_avail() ? 8 : -1); // 3-3
#define weapon_swap         return sndSwapExplosive;
#define weapon_sprt         return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_laser_sight  return false; // wtf why isnt this just called weapon_lasr/weapon_laser/weapon_sight
#define weapon_avail        return unlock_get("coastWep");

#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
	
	 // Projectile:
	with(obj_create(x, y, "NetNade")){
		motion_add(other.gunangle + orandom(5 * other.accuracy), 16);
		image_angle = direction;
		creator = f.creator;
		team = other.team;
	}
	
	 // Effects:
	weapon_post(6, 8, -20);
	sound_play(sndGrenade);
	sound_play_pitch(sndFlakCannon, 1.75 + random(0.25));
	sound_play_pitch(sndNadeReload, 0.8);
	
	
/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'telib', 'unlock_get', _unlock);
#define wepfire_init(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepfire_init', _wep);
#define wepammo_draw(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_draw', _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_fire', _wep);