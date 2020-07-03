#define init
	 // Sprites:
	global.sprWep = sprite_add("../sprites/weps/sprEnergyBat.png", 7, 0, 4);
	
#define weapon_name   return "ENERGY BAT";
#define weapon_text   return "LOST BUT NOT FORGOTTEN"; // Rest in Peace stevesteven98
#define weapon_swap   return sndSwapEnergy;
#define weapon_sprt   return global.sprWep;
#define weapon_area   return 10; // 5-2
#define weapon_type   return type_energy;
#define weapon_cost   return 2;
#define weapon_load   return 12; // 0.4 Seconds
#define weapon_melee  return true;

#define weapon_fire(w)
	var f = weapon_fire_init(w);
	w = f.wep;
	
	 // Fire:
	var _skill = skill_get(mut_long_arms),
		_flip  = sign(wepangle),
		_dis   = 20 * _skill,
		_dir   = gunangle;
		
	with(obj_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), "EnergyBatSlash")){
		projectile_init(other.team, f.creator);
		motion_add(_dir, lerp(2, 5, _skill));
		image_angle = direction;
		image_yscale *= _flip;
	}
	
	 // Sounds:
	if(skill_get(mut_laser_brain) > 0){
		sound_play_pitchvol(sndEnergyHammerUpg, random_range(1.2, 1.5), 0.8);
		sound_play_pitchvol(sndBlackSwordMega,  random_range(0.5, 0.7), 0.3);
	}
	else{
		sound_play_pitchvol(sndEnergyHammer,   random_range(1.2, 1.5), 0.9);
		sound_play_pitchvol(sndBlackSwordMega, random_range(0.5, 0.7), 0.2);
	}
	
	 // Effects:
	var _dir = gunangle + (60 * sign(wepangle));
	weapon_post(-4, 10, 15);
	motion_add(_dir, 4);
	move_contact_solid(_dir, 3);
	instance_create(x, y, Dust);
	/*
	var _spr = weapon_sprt(),
		_len = (sprite_get_width(_spr) - sprite_get_yoffset(_spr)) * 3/4,
		_dir = gunangle + wepangle,
		_x = x + lengthdir_x(_len, _dir),
		_y = y + lengthdir_y(_len, _dir);
		
	repeat(3){
		with(instance_create(_x + orandom(4), _y + orandom(4), PlasmaTrail)){
			motion_set(_dir + (30 * sign(other.wepangle)), random(2));
		}
	}
	*/
	
	
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
#define draw_ammo(_index, _primary, _ammo, _ammoMax, _steroids)							return  mod_script_call(   'mod', 'telib', 'draw_ammo', _index, _primary, _ammo, _ammoMax, _steroids);