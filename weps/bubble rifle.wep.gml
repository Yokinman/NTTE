#define init
	global.sprWep = sprite_add_weapon("../sprites/weps/sprBubbleRifle.png", 2, 5);
	global.sprWepLocked = mskNone;
	
#define weapon_name   return (weapon_avail() ? "BUBBLE RIFLE" : "LOCKED");
#define weapon_text   return "REFRESHING";
#define weapon_swap   return sndSwapExplosive;
#define weapon_sprt   return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area   return (weapon_avail() ? 6 : -1); // 3-1
#define weapon_type   return type_explosive;
#define weapon_cost   return 2;
#define weapon_load   return 9; // 0.3 Seconds
#define weapon_avail  return unlock_get("pack:oasis");

#define weapon_reloaded
	var	l = 14,
		d = gunangle;
		
	with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), Bubble)){
		image_angle = random(360);
		image_xscale = 0.75;
		image_yscale = image_xscale;
	}
	
	sound_play_pitchvol(sndOasisExplosionSmall, 1.3, 0.4);
	
#define weapon_fire(w)
	var f = weapon_fire_init(w);
	w = f.wep;
	
	 // Burst Fire:
	repeat(2) if(instance_exists(self)){
		 // Projectile:
		with(obj_create(x, y, "BubbleBomb")){
			move_contact_solid(other.gunangle, 6);
			motion_add(other.gunangle + (orandom(12) * other.accuracy), 9);
			creator = f.creator;
			team = other.team;
		}
		
		 // Effects:
		weapon_post(5, -5, 10);
		
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
		sound_play_pitch(sndOasisCrabAttack,        1.6 * _pitch);
		sound_play_pitch(sndOasisExplosionSmall,    0.7 * _pitch);
		sound_play_pitch(sndToxicBoltGas,           0.8 * _pitch);
		sound_play_pitch(sndBouncerBounce,          1.2 * _pitch);
		
		wait 2;
	}
	
	
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