#define init
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprTeleportGun.png", 4, 4);
	global.sprWepLocked = mskNone;
	
	 // LWO:
	global.lwoWep = {
		wep  : mod_current,
		inst : []
	};
	
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

#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Portal Bullet:
	with(projectile_create(x, y, "PortalBullet", gunangle, 26)){
		image_speed = 2.5;
		mask_index  = mskBullet1;
		damage      = 25;
		
		 // Remember Me:
		array_push(_wep.inst, id);
	}
	
	 // Effects:
	weapon_post(8, 16, 0);
	motion_add(gunangle, 4);
	move_contact_solid(gunangle, 12);
	
#define step(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);
	
	 // LWO Setup:
	if(!is_object(_wep)){
		_wep = lq_clone(global.lwoWep);
		wep_set(_primary, "wep", _wep);
	}
	
	 // Dynamic Reload:
	_wep.inst = instances_matching(_wep.inst, "", null);
	if(array_length(_wep.inst) > 0){
		wep_set(_primary, "reload", weapon_get_load(_wep));
	}
	
	
/// SCRIPTS
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define projectile_create(_x, _y, _obj, _dir, _spd)                                     return  mod_script_call_self('mod', 'telib', 'projectile_create', _x, _y, _obj, _dir, _spd);
#define weapon_fire_init(_wep)                                                          return  mod_script_call     ('mod', 'telib', 'weapon_fire_init', _wep);
#define weapon_ammo_fire(_wep)                                                          return  mod_script_call     ('mod', 'telib', 'weapon_ammo_fire', _wep);
#define weapon_ammo_hud(_wep)                                                           return  mod_script_call     ('mod', 'telib', 'weapon_ammo_hud', _wep);
#define weapon_get_red(_wep)                                                            return  mod_script_call_self('mod', 'telib', 'weapon_get_red', _wep);
#define wep_raw(_wep)                                                                   return  mod_script_call_nc  ('mod', 'telib', 'wep_raw', _wep);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);