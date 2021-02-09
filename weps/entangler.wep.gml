#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprEntangler.png",       8, 4);
	global.sprWepHUD    = sprite_add_weapon("../sprites/weps/sprEntanglerHUD.png",    0, 3);
	global.sprWepHUDRed = sprite_add(       "../sprites/weps/sprEntanglerHUD.png", 1, 0, 3);
	global.sprWepLocked = sprTemp;
	
	 // LWO:
	global.lwoWep = {
		"wep"      : mod_current,
		"chrg"     : false,
		"chrg_num" : 0,
		"chrg_max" : 15
	};
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr

#define weapon_name        return (weapon_avail() ? "ENTANGLER" : "LOCKED");
#define weapon_text        return `@(color:${area_get_back_color("red")})YOOOOOOO`;
#define weapon_sprt        return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area        return (weapon_avail() ? 22 : -1); // L1 3-1
#define weapon_load        return 20; // 0.66 Seconds
#define weapon_auto(_wep)  return weapon_get("chrg", _wep);
#define weapon_avail       return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack   return "red";
#define weapon_red         return 1;
#define weapon_chrg(_wep)  return (argument_count > 0 && "red_ammo" in self && red_ammo >= weapon_get("red", _wep));

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
	
#define weapon_sprt_hud(_wep)
	 // Normal Outline:
	if(
		weapon_get_gold(_wep) != 0 ||
		weapon_get_rads(_wep) > 0  ||
		(instance_is(self, Player) && ((wep == _wep && curse > 0) || (bwep == _wep && bcurse > 0)))
	){
		return global.sprWepHUD;
	}
	
	 // Red Outline:
	return global.sprWepHUDRed;
	
#define weapon_swap
	sound_set_track_position(
		sound_play_pitchvol(sndHyperCrystalChargeExplo, 0.6, 0.5),
		1.55
	);
	return sndSwapSword;
	
#define weapon_ntte_eat
	 // Wtf:
	if(!instance_is(self, Portal)){
		with(obj_create(x, y, "CrystalClone")){
			clone   = other;
			creator = other;
			team    = other.team;
		}
	}
	
#define weapon_reloaded(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);
	if(lq_defget(_wep, "chrg", false)){
		wep_set(_primary, "wepflip", -wep_get(_primary, "wepflip", 1));
	}
	else{
		sound_play(sndMeleeFlip);
	}
	
#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	var _num = (_wep.chrg_num / _wep.chrg_max);
	
	 // Charging:
	if(_wep.chrg){
		 // Pullback:
		var _kick = -3 * _num;
		if(wkick != _kick){
			weapon_post(_kick, 8 * _num * current_time_scale, 0);
		}
		
		 // Effects:
		if(_wep.chrg == 1){
			sound_play_pitch(sndMeleeFlip, 1 / (1 - (0.25 * _num)));
			sound_play_pitchvol(sndSwapBow, 0.3 + (2 * _num), 0.3);
			
			 // Full:
			if(_num >= 1){
				var	_l = 16,
					_d = gunangle;
					
				instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), ThrowHit);
				instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), ImpactWrists);
				sound_play_pitch(sndCrystalRicochet, 3);
				sound_play_pitch(sndSewerDrip,       3);
				sleep(5);
			}
		}
		
		 // Fully Charged - Blink:
		else if((current_frame % 12) < current_time_scale){
			with(_fire.creator) if(instance_is(self, Player)){
				gunshine = 2;
			}
		}
	}
	
	 // :
	else{
		var	_mega = false,
			_cost = weapon_get("red", _wep);
			
		if(_num >= 1 && "red_ammo" in _fire.creator && _fire.creator.red_ammo >= _cost){
			_fire.creator.red_ammo -= _cost;
			_mega = true;
		}
		
		 // Slash:
		var _skill = skill_get(mut_long_arms),
			_flip  = sign(wepangle),
			_dis   = 20 * _skill,
			_dir   = gunangle;
			
		with(projectile_create(
			x + lengthdir_x(_dis, _dir),
			y + lengthdir_y(_dis, _dir),
			"RedSlash",
			_dir,
			lerp(2, 5, _skill)
		)){
			if(_mega){
				sprite_index = spr.RedMegaSlash;
				mask_index = mskMegaSlash;
			}
			else{
				//sprite_index = spr.EntanglerSlash;
				sprite_index = spr.RedHeavySlash;
			}
			//image_yscale *= _flip;
			//red_ammo      = weapon_get("red", _wep);
			//can_charm     = (red_ammo > 0);
		}
		
		 // Sounds:
		sound_play_gun(sndChickenSword, 0.2, 0.3);
		sound_play_gun(sndHammer,       0.2, 0.3);
		if(_mega){
			sound_play_gun(sndBlackSwordMega, 0.2, 0.3);
		}
		
		 // Effects:
		weapon_post(-4, 15, 8);
		motion_add(_dir, 6);
		instance_create(x, y, Smoke);
	}
	
/*#define step(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);
	
	 // Unextend While Empty:
	if(abs(wepangle) >= 80 && abs(wepangle) <= 120){
		if("red_ammo" not in self || red_ammo < weapon_get("red", _wep)){
			wepangle = lerp(120 * sign(wepangle), wepangle, power(1 - 0.5, current_time_scale));
		}
		else{
			wepangle = lerp(80 * sign(wepangle), wepangle, power(1 - 0.5, current_time_scale));
			
			var	_goal = -4,
				_kick = wep_get(_primary, "wkick", 0);
				
			if(_kick <= 0 && _kick > _goal){
				_kick = max(_goal, _kick - (2 * current_time_scale));
				wep_set(_primary, "wkick", _kick);
			}
		}
	}*/
	
	
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
#define weapon_get(_name, _wep)                                                         return  mod_script_call     ('mod', 'telib', 'weapon_get', _name, _wep);
#define wep_raw(_wep)                                                                   return  mod_script_call_nc  ('mod', 'telib', 'wep_raw', _wep);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);
#define area_get_back_color(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_back_color', _area);