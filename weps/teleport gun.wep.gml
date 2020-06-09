#define init
	global.sprWep = sprite_add_weapon("../sprites/weps/sprTeleportGun.png", 4, 4);
	global.sprWepLocked = mskNone;
	
	lwoWep = {
		wep : mod_current,
		inst : noone
	};
	
#macro lwoWep global.lwoWep
	
#define weapon_name   return (weapon_avail() ? "TELEPORT GUN" : "LOCKED");
#define weapon_text   return "DON'T BLINK";
#define weapon_swap   return sndSwapEnergy;
#define weapon_sprt   return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area   return (weapon_avail() ? 6 : -1); // 3-1
#define weapon_type   return type_melee;
#define weapon_cost   return 2;
//#define weapon_rads   return 16;
#define weapon_load   return 15; // 0.5 Seconds
#define weapon_melee  return false;
#define weapon_avail  return true; // unlock_get("pack:oasis"); // wtf

#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
	
	 // Projectile:
	with(obj_create(x, y, "PortalBullet")){
		image_speed = 2.5;
		mask_index  = mskBullet1;
		creator     = other;
		team        = other.team;
		damage      = 25;
		
		motion_add(creator.gunangle, 26);
		image_angle = direction;
		
		 // Remember Me:
		w.inst = id;
	}
	
	 // Effects:
	motion_add(gunangle, 4);
	move_contact_solid(gunangle, 12);
	weapon_post(8, 16, 0);
	
#define step(_primary)
	var	b = (_primary ? "" : "b"),
		w = variable_instance_get(self, b + "wep");
		
	 // LWO Setup:
	if(!is_object(w)){
		w = lq_clone(lwoWep);
		variable_instance_set(self, b + "wep", w);
	}
	
	 // Dynamic Reload:
	if(instance_exists(w.inst)){
		variable_instance_set(self, b + "reload", weapon_get_load(mod_current));
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
#define wepfire_init(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepfire_init', _wep);
#define wepammo_draw(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_draw', _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_fire', _wep);