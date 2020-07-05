#define init
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprTunneller.png",          5, 5);
	global.sprWepHUD    = sprite_add(       "../sprites/weps/sprTunnellerHUD.png",    1, 0, 3);
	global.sprWepHUDRed = sprite_add(       "../sprites/weps/sprTunnellerHUDRed.png", 1, 0, 3);
	global.sprWepLocked = mskNone;
	
	 // LWO:
	global.lwoWep = {
		wep   : mod_current,
		melee : true
	}
	
#define weapon_sprt     return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_name     return (weapon_avail() ? "TUNNELLER" : "LOCKED");
#define weapon_text     return choose("WE'VE COME FULL CIRCLE", `YET ANOTHER @(color:${area_get_back_color("red")})RED KEY @wRIPOFF`);
#define weapon_swap     return sndSwapSword;
#define weapon_area     return (weapon_avail() ? 12 : -1); // 6-1
#define weapon_type
	 // Weapon Pickup Ammo Outline:
	if(instance_is(other, WepPickup) && instance_is(self, WepPickup)){
		return type_bullet;
	}
	
	return type_melee;
	
#define weapon_load     return 24; // 0.8 Seconds
#define weapon_auto(w)	return weapon_melee(w);
#define weapon_melee(w) return lq_defget(w, "melee", true);
#define weapon_avail    return unlock_get("pack:red");
#define weapon_red      return 1;

#define weapon_sprt_hud(w)
	 // Curse Outline:
	if(instance_is(self, Player) && ((wep == w && curse) || (bwep == w && bcurse))){
		return global.sprWepHUD;
	}
	
	 // Red Outline:
	return global.sprWepHUDRed;
	
#define weapon_fire(w)
	var f = weapon_fire_init(w);
	w = f.wep;
	
	 // Red:
	var _cost = weapon_red();
	if("red_ammo" in self && red_ammo >= _cost){
		red_ammo -= _cost;
		
		 // Annihilator:
		with(obj_create(x, y, "CrystalHeartBullet")){
			projectile_init(other.team, other);
			motion_set(other.gunangle + (orandom(4) * other.accuracy), 4);
			image_angle = direction;
			area_goal  = irandom_range(8, 12);
			area_chaos = true; 
			area_chest = pool([
				[AmmoChest, 		 4],
				[WeaponChest,		 4],
				["Backpack",		 3],
				["BonusAmmoChest",	 2],
				["BonusHealthChest", 2],
				["RedAmmoChest",	 1]
			]);
		}
		
		 // Effects:
		weapon_post(12, 24, 12);
		var d = gunangle + 180;
		motion_add(d, 4);
		move_contact_solid(d, 4);
	}
	
	 // Normal:
	else{
		wepangle *= -1;
		repeat(3){
			if(instance_exists(self)){
				 // Shank:
				var _skill = skill_get(mut_long_arms),
					_dir = gunangle + (orandom(15) * accuracy),
					_len = lerp(0, 20, _skill);
					
				with(obj_create(x + lengthdir_x(_len, _dir), y + lengthdir_y(_len, _dir), "RedShank")){
					projectile_init(other.team, other);
					motion_add(_dir, lerp(3, 6, _skill));
					image_angle = direction;
				}
				
				 // Effects:
				weapon_post(4, 8, 4);
				motion_add(gunangle, 3);
				wepangle *= -1;
				
				 // Sounds:
				sound_play(sndScrewdriver);
				
				 // Hold Your Metaphorical Horses:
				wait(4);
			}
		}
	}
	
#define step(_primary)
	var	b = (_primary ? "" : "b"),
		w = variable_instance_get(self, b + "wep");
		
	 // LWO Setup:
	if(!is_object(w)){
		w = lq_clone(global.lwoWep);
		variable_instance_set(self, b + "wep", w);
	}
	
	 // Transition Between Shooty/Melee:
	var	_wepangle = variable_instance_get(self, b + "wepangle", 0),
		_wkick    = variable_instance_get(self, b + "wkick",    0);
		
	if("red_ammo" not in self || red_ammo < weapon_red()){
		if(!w.melee){
			w.melee   = true;
			_wepangle = choose(-1, 1);
			_wkick    = 4;
		}
		_wepangle = lerp(_wepangle, max(abs(_wepangle), 120) * sign(_wepangle), 0.4 * current_time_scale);
	}
	else if(w.melee){
		_wepangle -= _wepangle * 0.4 * current_time_scale;
		
		 // Done:
		if(abs(_wepangle) < 1){
			w.melee = false;
			_wkick = 2;
		}
	}
	if((b + "wepangle") in self){
		variable_instance_set(self, b + "wepangle", _wepangle);
	}
	if((b + "wkick") in self){
		variable_instance_set(self, b + "wkick", _wkick);
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
#define area_get_back_color(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_back_color', _area);
#define pool(_pool)                                                                     return  mod_script_call_nc('mod', 'telib', 'pool', _pool);