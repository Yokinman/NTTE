#define init
	global.sprWep = sprite_add_weapon("../sprites/weps/sprSuperTeleportGun.png", 6, 8);
	global.sprWepLocked = mskNone;
	
	lwoWep = {
		wep : mod_current,
		inst : []
	};
	
#macro lwoWep global.lwoWep

#define weapon_name   return (weapon_avail() ? "SUPER TELEPORT GUN" : "LOCKED");
#define weapon_text   return "POSITION INDETERMINABLE";
#define weapon_swap   return sndSwapEnergy;
#define weapon_sprt   return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_type   return type_melee;
#define weapon_load   return 45; // 1.5 Seconds
#define weapon_melee  return false;
#define weapon_avail  return true;

#define weapon_area
	 // Cursed Chest Exclusive:
	if(weapon_avail() && (instance_is(other, WeaponChest) || instance_is(other, BigCursedChest)) && instance_is(self, WepPickup) && other.curse > 0){
		return 8; // 3-3
	}
	
	return -1;
	
#define weapon_fire(w)
	var f = weapon_fire_init(w);
	w = f.wep;
	
	var d = (10 * accuracy);
	for(var i = -2; i < 2; i++){
	
		 // Projectile:
		with(obj_create(x, y, "PortalBullet")){
			image_speed = 2.5;
			mask_index  = mskBullet1;
			creator     = other;
			team        = other.team;
			damage      = 25;
			
			motion_add(creator.gunangle + (i * d), 26);
			image_angle = direction;
			
			 // Remember Me:
			array_push(w.inst, id);
		}
	}
	
	 // Effects:
	motion_add(gunangle, 4);
	move_contact_solid(gunangle, 12);
	weapon_post(24, 32, 8);
	
#define step(_primary)
	var	b = (_primary ? "" : "b"),
		w = variable_instance_get(self, b + "wep");
		
	 // LWO Setup:
	if(!is_object(w)){
		w = lq_clone(lwoWep);
		variable_instance_set(self, b + "wep", w);
	}
	
	 // Dynamic Reload:
	w.inst = instances_matching(w.inst, "", null);
	if(array_length(w.inst) > 0){
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
#define weapon_fire_init(_wep)                                                          return  mod_script_call(   'mod', 'telib', 'weapon_fire_init', _wep);
#define weapon_ammo_fire(_wep)                                                          return  mod_script_call(   'mod', 'telib', 'weapon_ammo_fire', _wep);
#define weapon_ammo_hud(_wep)                                                           return  mod_script_call(   'mod', 'telib', 'weapon_ammo_hud', _wep);
#define weapon_get_red(_wep)                                                            return  mod_script_call(   'mod', 'telib', 'weapon_get_red', _wep);
#define wep_get(_wep)                                                                   return  mod_script_call_nc('mod', 'telib', 'wep_get', _wep);