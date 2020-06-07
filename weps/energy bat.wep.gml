#define init
	 // Sprites:
	global.sprWep		= sprite_add("../sprites/weps/sprEnergyBat.png", 7, 0, 4);
	global.sprWepLocked = mskNone;
	
#define weapon_sprt		return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_name 	return (weapon_avail() ? "ENERGY BAT" : "LOCKED");
#define weapon_text 	return "LOST BUT NOT FORGOTTEN"; // Rest in Peace stevesteven98
#define weapon_swap 	return sndSwapEnergy;
#define weapon_area 	return (weapon_avail() ? 10 : -1); // 5-2
#define weapon_type 	return 5;  // Energy
#define weapon_cost		return 2;
#define weapon_load 	return 12; // 0.4 Seconds
#define weapon_melee	return true;
#define weapon_avail	return true;

#define weapon_fire(w)
	 // Effects:
	wepangle *= -1;
	weapon_post(5, 10, 15);
	
	var d = gunangle + (60 * sign(wepangle));
	motion_add(d, 4);
	move_contact_solid(d, 3);
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
	
	 // Fire:
	var _skill = skill_get(mut_long_arms);
	with(obj_create(x, y, "EnergyBatSlash")){
		image_yscale = sign(other.wepangle);
		
		creator = other;
		team	= other.team;
		speed	= lerp(2, 5, _skill);
		direction	= other.gunangle;
		image_angle = direction;
		
		 // Schmovin':
		var l = lerp(0, 20, _skill);
		x += lengthdir_x(l, direction);
		y += lengthdir_y(l, direction);
	}
	
	if(skill_get(mut_laser_brain) > 0){
		
		 // Laser Brain Sounds:
		sound_play_pitchvol(sndEnergyHammerUpg, random_range(1.2, 1.5), 0.8);
		sound_play_pitchvol(sndBlackSwordMega,	random_range(0.5, 0.7), 0.3);
	}
	else{
		
		 // Normal Sounds:
		sound_play_pitchvol(sndEnergyHammer,	random_range(1.2, 1.5), 0.9);
		sound_play_pitchvol(sndBlackSwordMega,	random_range(0.5, 0.7), 0.2);
	}
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define wepfire_init(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepfire_init', _wep);
#define wepammo_draw(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_draw', _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_fire', _wep);
#define draw_ammo(_index, _primary, _ammo, _ammoMax, _steroids)							return  mod_script_call(   'mod', 'telib', 'draw_ammo', _index, _primary, _ammo, _ammoMax, _steroids);