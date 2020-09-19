#define init
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprSuperTeleportGun.png", 6, 8);
	
	 // LWO:
	global.lwoWep = {
		wep  : mod_current,
		inst : []
	};
	
#define weapon_name   return "SUPER TELEPORT GUN";
#define weapon_text   return "POSITION INDETERMINABLE";
#define weapon_swap   return sndSwapEnergy;
#define weapon_sprt   return global.sprWep;
#define weapon_type   return type_melee;
#define weapon_load   return 45; // 1.5 Seconds
#define weapon_melee  return false;

#define weapon_area
	 // Cursed Chest Exclusive:
	if(("curse" in self && curse > 0) || ("curse" in other && other.curse > 0)){
		return 8; // 3-3
	}
	
	return -1;
	
#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Portal Bullets:
	var _off = (10 * accuracy);
	for(var i = -1.5; i <= 1.5; i++){
		with(projectile_create(x, y, "PortalBullet", gunangle + (i * _off), 12)){
			image_speed = 2.5;
			mask_index  = mskBullet1;
			damage      = 25;
			
			 // Remember Me:
			array_push(_wep.inst, id);
		}
	}
	
	 // Effects:
	weapon_post(24, 32, 8);
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