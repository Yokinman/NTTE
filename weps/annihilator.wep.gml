#define init
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprAnnihilator.png",          8, 2);
	global.sprWepHUD    = sprite_add(       "../sprites/weps/sprAnnihilatorHUD.png",    1, 0, 3);
	global.sprWepHUDRed = sprite_add(       "../sprites/weps/sprAnnihilatorHUDRed.png", 1, 0, 3);
	global.sprWepLocked = mskNone;
	
	 // LWO:
	global.lwoWep = {
		wep   : mod_current,
		melee : true
	}
	
#define weapon_name     return (weapon_avail() ? "ANNIHILATOR" : "LOCKED");
#define weapon_text     return `@wBEND @sTHE @(color:${area_get_back_color("red")})CONTINUUM`;
#define weapon_swap     return sndSwapHammer;
#define weapon_sprt     return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area     return (weapon_avail() ? 21 : -1); // L1 3-1
#define weapon_load     return 24; // 0.8 Seconds
#define weapon_melee(w) return lq_defget(w, "melee", true);//(!instance_is(self, Player) || variable_instance_get(self, "red_ammo", 0) < weapon_get_red(w));
#define weapon_avail    return unlock_get("pack:red");
#define weapon_shrine   return [mut_long_arms, mut_shotgun_shoulders];
#define weapon_red      return 2;

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
	
	 // Red:
	var _cost = weapon_get_red(w);
	if("red_ammo" in self && red_ammo >= _cost){
		red_ammo -= _cost;
		
		 // Annihilator:
		with(obj_create(x, y, "RedBullet")){
			projectile_init(other.team, f.creator);
			motion_set(other.gunangle, 16);
			image_angle = direction;
		}
		
		 // Effects:
		weapon_post(10, 8, 6);
		motion_add(gunangle + 180, 3);
		sleep(40);
		
		 // Sounds:
		sound_play_pitchvol(sndEnergyScrewdriver, 0.7 + random(0.2), 2);
		sound_play_pitchvol(sndPlasmaReloadUpg,   1.2 + random(0.2), 0.8);
	}
	
	 // Normal:
	else{
		 // Slash:
		var _skill = skill_get(mut_long_arms),
			_flip  = sign(wepangle),
			_dis   = 20 * _skill,
			_dir   = gunangle;
			
		with(obj_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), "RedSlash")){
			projectile_init(other.team, f.creator);
			motion_add(_dir, lerp(2, 5, _skill));
			image_angle = direction;
		}
		
		 // Effects:
		weapon_post(-4, 12, 1);
		motion_add(gunangle, 6);
		instance_create(x, y, Smoke);
		sleep(10);
		
		 // Sounds:
		sound_play_gun(sndWrench, 0.2, 0.6);
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
		
	if("red_ammo" not in self || red_ammo < weapon_get_red(w)){
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