#define init
	global.sprWep = sprite_add_weapon("../sprites/weps/sprTeleportGun.png", 4, 4);
	global.sprWepLocked = mskNone;
	
#define weapon_name   return (weapon_avail() ? "TELEPORT GUN" : "LOCKED");
#define weapon_text   return "DON'T BLINK";
#define weapon_type   return 0;  // "Melee"
#define weapon_cost   return 2;  // 0 Ammo
#define weapon_load   return 35; // 1.50 Seconds
#define weapon_area   return (weapon_avail() ? 6 : -1); // 3-1
#define weapon_swap   return sndSwapEnergy;
#define weapon_sprt   return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_avail  return unlock_get("pack:oasis");
#define weapon_melee  return false;
#define weapon_rads   return 16;

#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
	
	with obj_create(x, y, "PortalBullet"){
		image_speed = 2.5;
		mask_index  = mskBullet1;
		creator 		= other;
		team 				= other.team;
		damage 			= 20;

		motion_add(creator.gunangle, 26);
		image_angle = direction;
	}
	
	weapon_post(0, 16, 0);
	
	
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
