#define init
	global.sprWep = sprHeavyARifle;
	global.sprWepLocked = mskNone;
	
#define weapon_name   return (weapon_avail() ? "VENOM RIFLE" : "LOCKED");
#define weapon_text   return "A PIERCING STING";
#define weapon_swap   return sndSwapMachinegun;
#define weapon_sprt   return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area   return (weapon_avail() ? 6 : -1); // 3-2
#define weapon_type   return type_bullet;
#define weapon_cost   return 2;
#define weapon_load   return 3; // 0.?? Seconds
#define weapon_auto	  return true;
#define weapon_avail  return true;

#define weapon_fire(w)
	var f = weapon_fire_init(w);
	w = f.wep;
	
	 // Bullets:
	var _dir = gunangle + (orandom(4) * accuracy),
		_num = 3;
		
	for(var i = 0; i < 360; i += 360 / _num){
		var l = (9 * lerp(accuracy, 1, 2/3)),
			d = (_dir + i) + (orandom(2) * accuracy);
		
		with(obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "VenomPellet")){
			creator	= other;
			team	= other.team;
			motion_set(_dir, 16);
			image_speed = 1;
			image_angle = direction;
			sprite_index = spr_spwn;
		}
		
	}
	
	 // Effects:
	weapon_post(4, -2, 0);
	
	 // Sounds:
	sound_play_gun(sndMachinegun, 0.3, 0.3);
	
	
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
#define weapon_fire_init(_wep)                                                          return  mod_script_call(   'mod', 'telib', 'weapon_fire_init', _wep);
#define weapon_ammo_fire(_wep)                                                          return  mod_script_call(   'mod', 'telib', 'weapon_ammo_fire', _wep);
#define weapon_ammo_hud(_wep)                                                           return  mod_script_call(   'mod', 'telib', 'weapon_ammo_hud', _wep);
#define weapon_get_red(_wep)                                                            return  mod_script_call(   'mod', 'telib', 'weapon_get_red', _wep);
#define wep_get(_wep)                                                                   return  mod_script_call_nc('mod', 'telib', 'wep_get', _wep);