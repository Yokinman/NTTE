#define init
	global.sprWep = sprite_add_weapon("../sprites/weps/sprBubbleShotgun.png", 3, 4);
	global.sprWepLocked = mskNone;
	
#define weapon_name   return (weapon_avail() ? "BUBBLE SHOTGUN" : "LOCKED");
#define weapon_text   return "SUMMERTIME FUN";
#define weapon_type   return 4;  // Explosive
#define weapon_cost   return 3;  // 3 Ammo
#define weapon_load   return 23; // 0.77 Seconds
#define weapon_area   return (weapon_avail() ? 8 : -1); // 3-3
#define weapon_swap   return sndSwapExplosive;
#define weapon_sprt   return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_avail  return unlock_get("pack:oasis");

#define weapon_reloaded
	var	l = 16,
		d = gunangle;
		
	repeat(3) with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), Bubble)){
		image_angle = random(360);
		image_xscale = 0.75;
		image_yscale = image_xscale;
	}
	
	sound_play_pitchvol(sndOasisExplosionSmall, 1.3, 0.4);
	
#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
	
	 // Projectiles:
	for(var i = 0; i < 5; i++){
		with(obj_create(x, y, "BubbleBomb")){
			move_contact_solid(other.gunangle, 6 + (i * 8));
			motion_add(other.gunangle + orandom(12 * other.accuracy), 9 + random(1));
			creator = f.creator;
			team = other.team;
			image_speed += (irandom_range(-2, 2) / 50);
		}
	}
	
	 // Effects:
	weapon_post(6, -5, 10);
	
	var	l = 14,
		d = gunangle;
		
	with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), BubblePop)){
		image_index = 1;
		image_angle = random(360);
		image_xscale = 0.8;
		image_yscale = image_xscale;
		depth = -1;
	}
	
	 // Sound:
	var _pitch = random_range(0.8, 1.2);
	sound_play_pitch(sndOasisCrabAttack,        0.7 * _pitch);
	sound_play_pitch(sndOasisExplosionSmall,    0.8 * _pitch);
	sound_play_pitch(sndToxicBoltGas,           0.8 * _pitch);
	sound_play_pitch(sndHyperRifle,             1.5 * _pitch);
	
	
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