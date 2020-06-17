#define init
	 // Sprites:
	global.sprWep		= sprite_add_weapon("../sprites/weps/sprEntangler.png",		  10, 5);
	global.sprWepHUD	= sprite_add(		"../sprites/weps/sprEntanglerHUD.png", 1, 0,  3)
	global.sprWepLocked = mskNone;
	
	global.color = `@(color:${make_color_rgb(235, 0, 67)})`;
	
#define weapon_sprt 	return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_name 	return (weapon_avail() ? "ENTANGLER" : "LOCKED");
#define weapon_text 	return `@s${global.color}`;
#define weapon_swap 	return sndSwapSword;
#define weapon_area 	return (weapon_avail() ? 21 : -1); // L1 3-1
#define weapon_type 	return type_melee;
#define weapon_load 	return 20; // 0.66 Seconds
#define weapon_melee	return true;
#define weapon_avail	return true; // unlock_get("pack:red");
#define weapon_red		return 1;

#define weapon_sprt_hud(w)	
	if(instance_is(self, Player) && (instance_is(other, TopCont) || instance_is(other, UberCont))){
		draw_ammo(index, (wep == w), red_ammo, red_amax, (race == "steroids"));
	}
	
	return global.sprWepHUD;


#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
	
	 // Fire:
	var _skill = skill_get(mut_long_arms),
		_flip  = sign(wepangle),
		_dis   = 20 * _skill,
		_dir   = gunangle;
		
	with(obj_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), "EntanglerSlash")){
		motion_add(
			_dir,
			lerp(2, 5, _skill)
		);
		image_angle   = direction;
		image_yscale *= _flip;
		creator       = other;
		team          = other.team;
		
		can_charm	  = (weapon_red() > 0);
		red_ammo  = weapon_red();
	}
	
	 // Effects:
	weapon_post(-5, 15, 20);
	motion_add(gunangle, 4);
	instance_create(x, y, Smoke);
	move_contact_solid(gunangle, 4);
	
	
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
#define wepfire_init(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepfire_init', _wep);
#define wepammo_draw(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_draw', _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_fire', _wep);
#define draw_ammo(_index, _primary, _ammo, _ammoMax, _steroids)							return  mod_script_call(   'mod', 'telib', 'draw_ammo', _index, _primary, _ammo, _ammoMax, _steroids);