#define init
	global.sprWep = sprite_add_weapon("../sprites/weps/sprBubbleMinigun.png", 3, 3);
	global.sprWepLocked = mskNone;
	
#define weapon_name   return (weapon_avail() ? "BUBBLE MINIGUN" : "LOCKED");
#define weapon_text   return "SOAP EVERYWHERE";
#define weapon_auto   return true;
#define weapon_type   return 4; // Explosive
#define weapon_cost   return 3; // 3 Ammo
#define weapon_load   return 3; // 0.1 Seconds
#define weapon_area   return (weapon_avail() ? 10 : -1); // 5-1
#define weapon_swap   return sndSwapMotorized;
#define weapon_sprt   return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_avail  return unlock_get("oasisWep");

#define weapon_reloaded
	var	l = 19,
		d = gunangle;
		
	with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), BubblePop)){
		image_index = (other.wkick > 0);
		image_angle = random(360);
		depth = -1;
	}
	
	sound_play_pitchvol(sndOasisExplosionSmall, 1.1, 0.4);
	
#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
	
	 // Burst Fire:
	repeat(3) if(instance_exists(self)){
		 // Projectile:
		with(obj_create(x, y, "BubbleBomb")){
			move_contact_solid(other.gunangle, 6);
			motion_add(other.gunangle + orandom(6 * other.accuracy), 10 + random(2));
			creator = f.creator;
			team = other.team;
		}
		
		 // Effects:
		var _pitch = random_range(0.8, 1.2);
		sound_play_pitch(sndOasisCrabAttack,     0.7 * _pitch);
		sound_play_pitch(sndSuperSplinterGun,    1.4 * _pitch);
		sound_play_pitch(sndOasisExplosionSmall, 0.7 * _pitch);
		
		 // Post:
		weapon_post(5, -5, 10);
		motion_add(gunangle + 180, 0.5);
		
		wait 1;
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