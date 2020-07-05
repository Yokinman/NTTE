#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprEntangler.png",          8, 4);
	global.sprWepHUD    = sprite_add(       "../sprites/weps/sprEntanglerHUD.png",    1, 0, 3)
	global.sprWepHUDRed = sprite_add(       "../sprites/weps/sprEntanglerHUDRed.png", 1, 0, 3)
	global.sprWepLocked = mskNone;
	
#macro spr global.spr

#define weapon_sprt   return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_name   return (weapon_avail() ? "ENTANGLER" : "LOCKED");
#define weapon_text   return `@(color:${area_get_back_color("red")})YOOOOOOO`;
#define weapon_swap   return sndSwapSword;
#define weapon_area   return (weapon_avail() ? 21 : -1); // L1 3-1
#define weapon_type
	 // Weapon Pickup Ammo Outline:
	if(instance_is(other, WepPickup) && instance_is(self, WepPickup)){
		return type_bullet;
	}
	
	return type_melee;
	
#define weapon_load   return 20; // 0.66 Seconds
#define weapon_melee  return true;
#define weapon_avail  return unlock_get("pack:red");
#define weapon_red    return 1;

#define weapon_sprt_hud(w)
	 // Normal Outline:
	if(instance_is(self, Player)){
		if((wep == w && curse) || (bwep == w && bcurse) || weapon_get_rads(w) > 0){
			return global.sprWepHUD;
		}
	}
	
	 // Red Outline:
	return global.sprWepHUDRed;
	
#define weapon_fire(w)
	var f = weapon_fire_init(w);
	w = f.wep;
	
	 // Fire:
	var _skill = skill_get(mut_long_arms),
		_flip  = sign(wepangle),
		_dis   = 20 * _skill,
		_dir   = gunangle;
		
	with(obj_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), "RedSlash")){
		projectile_init(other.team, f.creator);
		motion_add(_dir, lerp(2, 5, _skill));
		sprite_index  = spr.EntanglerSlash;
		image_angle   = direction;
		image_yscale *= _flip;
		//red_ammo      = weapon_get_red(w);
		//can_charm     = (red_ammo > 0);
	}
	
	 // Effects:
	weapon_post(-4, 15, 8);
	motion_add(gunangle, 6);
	instance_create(x, y, Smoke);
	
	 // Sound:
	sound_play_gun(sndChickenSword, 0.2, 0.3);
	sound_play_gun(sndHammer,       0.2, 0.3);
	
	
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
#define area_get_back_color(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_back_color', _area);