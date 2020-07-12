#define init
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprTunneller.png",          8, 6);
	global.sprWepHUD    = sprite_add(       "../sprites/weps/sprTunnellerHUD.png",    1, 0, 3);
	global.sprWepHUDRed = sprite_add(       "../sprites/weps/sprTunnellerHUDRed.png", 1, 0, 3);
	global.sprWepLocked = mskNone;
	
#define weapon_name   return (weapon_avail() ? "TUNNELLER" : "LOCKED");
#define weapon_text   return choose(`@wUNLOCK @sTHE @(color:${area_get_back_color("red")})CONTINUUM`, "FULL CIRCLE", `YET ANOTHER @(color:${area_get_back_color("red")})RED KEY`);
#define weapon_swap   return sndSwapSword;
#define weapon_sprt   return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area   return (weapon_avail() ? 22 : -1); // L1 3-1
#define weapon_load   return 24; // 0.8 Seconds
#define weapon_auto   return true;
#define weapon_melee  return false;
#define weapon_avail  return unlock_get("pack:red");
#define weapon_red    return 1;

#define weapon_type
	 // Weapon Pickup Ammo Outline:
	if(instance_is(self, WepPickup) && instance_is(other, WepPickup)){
		if(image_index > 1 && ammo > 0){
			for(var i = 0; i < 360; i += 90){
				draw_sprite_ext(sprite_index, 1, x + dcos(i), y - dsin(i), 1, 1, rotation, image_blend, image_alpha);
			}
		}
	}
	
	 // Type:
	return type_melee;
	
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
		
		 // Chaos Ball:
		with(projectile_create(x, y, "CrystalHeartBullet", gunangle + orandom(4 * accuracy), 4)){
			damage     = 20;
			area_goal  = irandom_range(8, 12);
			area_chaos = true; 
			area_chest = pool([
				[AmmoChest,          4],
				[WeaponChest,        4],
				["Backpack",         3],
				["BonusAmmoChest",   2],
				["BonusHealthChest", 2],
				["RedAmmoChest",     1]
			]);
		}
		
		 // Effects:
		weapon_post(18, 24, 12);
		motion_add(gunangle + 180, 4);
		move_contact_solid(gunangle + 180, 4);
	}
	
	 // Normal:
	else if(fork()){
		repeat(3){
			var	_skill = skill_get(mut_long_arms),
				_dis   = 10 * _skill,
				_dir   = gunangle;
				
			 // Shank:
			projectile_create(
				x + lengthdir_x(_dis, _dir),
				y + lengthdir_y(_dis, _dir),
				"RedShank",
				_dir + orandom(10 * accuracy),
				lerp(3, 6, _skill)
			);
			
			 // Sounds:
			sound_play_gun(sndScrewdriver, 0.2, 0.6);
			
			 // Effects:
			weapon_post(-3, 8, 2);
			motion_add(_dir, 3);
			
			 // Hold Your Metaphorical Horses:
			wait(4);
			if(!instance_exists(self)) break;
		}
		exit;
	}
	
#define step(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);
	
	 // Unextend While Empty:
	if("red_ammo" not in self || red_ammo < weapon_get_red(_wep)){
		var	_goal = 6,
			_kick = wep_get(_primary, "wkick", 0);
			
		if(_kick >= 0 && _kick < _goal){
			_kick = min(_goal, _kick + (2 * current_time_scale));
			wep_set(_primary, "wkick", _kick);
		}
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
#define projectile_create(_x, _y, _obj, _dir, _spd)                                     return  mod_script_call(   'mod', 'telib', 'projectile_create', _x, _y, _obj, _dir, _spd);
#define weapon_fire_init(_wep)                                                          return  mod_script_call(   'mod', 'telib', 'weapon_fire_init', _wep);
#define weapon_ammo_fire(_wep)                                                          return  mod_script_call(   'mod', 'telib', 'weapon_ammo_fire', _wep);
#define weapon_ammo_hud(_wep)                                                           return  mod_script_call(   'mod', 'telib', 'weapon_ammo_hud', _wep);
#define weapon_get_red(_wep)                                                            return  mod_script_call(   'mod', 'telib', 'weapon_get_red', _wep);
#define wep_raw(_wep)                                                                   return  mod_script_call_nc('mod', 'telib', 'wep_raw', _wep);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(id, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        variable_instance_set(id, (_primary ? '' : 'b') + _name, _value);
#define area_get_back_color(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_back_color', _area);
#define pool(_pool)                                                                     return  mod_script_call_nc('mod', 'telib', 'pool', _pool);