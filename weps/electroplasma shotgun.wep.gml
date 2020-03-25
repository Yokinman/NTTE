#define init
	global.sprWep = sprite_add_weapon("../sprites/weps/sprElectroPlasmaShotgun.png", 2, 6);
	global.sprWepLocked = mskNone;
	
#define weapon_name   return (weapon_avail() ? "ELECTROPLASMA SHOTGUN" : "LOCKED");
#define weapon_text   return "WHERE'S THE PEANUT BUTTER";
#define weapon_type   return 5;  // Energy
#define weapon_cost   return 8;  // 8 Ammo
#define weapon_load   return 27; // 0.9 Seconds
#define weapon_area   return (weapon_avail() ? 8 : -1); // 3-3
#define weapon_swap   return sndSwapEnergy;
#define weapon_sprt   return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_avail  return unlock_get("pack:trench");

#define weapon_reloaded
	sound_play(sndLightningReload);
	
#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
	
	 // Sounds:
	var _brain = (skill_get(mut_laser_brain) > 0);
	if(_brain) sound_play_gun(sndLightningShotgunUpg, 0.4, 0.6);
	else       sound_play_gun(sndLightningShotgun,    0.3, 0.3);
	sound_play_pitch(sndPlasmaBig, 1.1 + random(0.3));
	
	 // Effects:
	weapon_post(8, 6, 0);
	motion_add(gunangle, -4);
	
	 // Spread Fire:
	var	_last = variable_instance_get(f.creator, "electroplasma_last", noone),
		_num = 5;
		
	for(var i = floor(_num / 2) * -1; i <= floor(_num / 2); i++){
		var _dir = other.gunangle + (((20 * i) + orandom(6)) * other.accuracy);
		with(obj_create(x, y, "ElectroPlasma")){
			motion_set(_dir, 4 + random(0.8));
			image_angle = direction;
			creator = f.creator;
			team = other.team;
			
			 // Tether Together:
			tether_inst = _last;
			_last = id;
		}
	}
	with(f.creator){
		electroplasma_last = _last;
	}
	
	
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