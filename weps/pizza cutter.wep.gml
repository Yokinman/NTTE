#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add(       "../sprites/weps/sprPizzaCutter.png",       3, 2, 7);
	global.sprWepHoming = sprite_add_weapon("../sprites/weps/sprPizzaCutterHoming.png",    2, 7);
	global.sprWepHUD    = sprite_add_weapon("../sprites/weps/sprPizzaCutterHoming.png",    9, 7);
	global.sprWepLocked = sprTemp;
	global.sprWepImage  = [];
	
	 // LWO:
	global.lwoWep = {
		"wep"      : mod_current,
		"ammo"     : 1,
		"amax"     : 1,
		"anam"     : "SAWBLADES",
		"cost"     : 1,
		"buff"     : false,
		"canload"  : true,
		"chrg"     : false,
		"chrg_num" : 0,
		"chrg_max" : 9
	};
	
#macro spr global.spr

#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name        return (weapon_avail() ? "PIZZA CUTTER" : "LOCKED");
#define weapon_text        return "FOR THE CIVILIZED TURTLE";
#define weapon_swap        return sndSwapMotorized;
#define weapon_area        return (weapon_avail() ? 7 : -1); // 3-2
#define weapon_type        return type_melee;
#define weapon_load        return 24; // 0.8 Seconds
#define weapon_auto(_wep)  return lq_defget(_wep, "canload", false);
#define weapon_melee       return true;
#define weapon_avail       return call(scr.unlock_get, "pack:" + weapon_ntte_pack());
#define weapon_ntte_pack   return "lair";
#define weapon_shrine      return [mut_long_arms, mut_bolt_marrow];
#define weapon_chrg(_wep)  return (argument_count <= 0 || lq_defget(_wep, "canload", true));

#define weapon_sprt(_wep)
	if(weapon_avail()){
		 // Indicators:
		if(is_object(_wep) && array_length(global.sprWepImage)){
			var	_ammo = (lq_defget(_wep, "canload", false) ? lq_defget(_wep, "ammo", 0) : 0),
				_amax = lq_defget(_wep, "amax", 1),
				_cost = lq_defget(_wep, "cost", 1);
				
			 // Homing:
			if(_ammo < _cost && array_length(obj.BatDisc)){
				if(array_length(instances_matching(instances_matching(obj.BatDisc, "wep", _wep), "image_index", 1))){
					return global.sprWepHoming;
				}
			}
			
			 // Ammo:
			return global.sprWepImage[ceil(clamp((floor(_ammo / _cost) * _cost) / _amax, 0, 1) * (array_length(global.sprWepImage) - 1))];
		}
		
		 // Normal:
		return global.sprWep;
	}
	
	 // Locked:
	return global.sprWepLocked;
	
#define weapon_sprt_hud(_wep)  
	call(scr.weapon_ammo_hud, _wep);
	return global.sprWepHUD;
	
#define weapon_reloaded(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);
	if(lq_defget(_wep, "chrg", false)){
		wep_set(_primary, "wepflip", -wep_get(_primary, "wepflip", 1));
	}
	else{
		sound_play(sndMeleeFlip);
	}
	
#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	var _charge = (_wep.chrg_num / _wep.chrg_max);
	
	 // Charging:
	if(_wep.chrg){
		 // Pullback:
		var _kick = -3 * _charge;
		if(wkick != _kick){
			weapon_post(_kick, 8 * _charge * current_time_scale, 0);
		}
		
		 // Effects:
		if(_wep.chrg == 1){
			 // Sound:
			sound_play_pitch(sndMeleeFlip, 1 / (1 - (0.25 * _charge)));
			sound_play_pitchvol(sndSwapBow, 0.3 + (2 * _charge), 0.3);
			
			 // Full:
			if(_charge >= 1){
				 // Sound:
				sound_play_pitchvol(sndSwapMotorized, 1.4,               0.5);
				sound_play_pitchvol(sndDiscBounce,    1.4 + random(0.2), 0.8);
				
				 // Flash:
				var	_lx = 18 - wkick,
					_ly = 2 * variable_instance_get(_fire.creator, "wepflip", 1),
					_d  = gunangle + (wepangle * (1 - (wkick / 20)));
					
				with(instance_create(
					x + hspeed_raw + lengthdir_x(_lx, _d) + lengthdir_x(_ly, _d - 90),
					y + vspeed_raw + lengthdir_y(_lx, _d) + lengthdir_y(_ly, _d - 90),
					DiscTrail
				)){
					sprite_index = spr.BigDiscTrail;
					image_speed  = 0.4;
					depth        = other.depth - 1;
				}
				sleep(5);
			}
		}
	}
	
	 // Fire:
	else{
		var _skill = skill_get(mut_long_arms),
			_len   = 20 * _skill,
			_dir   = gunangle + orandom(8 * accuracy);
			
		 // Slash:
		with(call(scr.projectile_create, self, 
			x + lengthdir_x(_len, _dir),
			y + lengthdir_y(_len, _dir),
			Slash,
			_dir,
			3 + (2 * _skill)
		)){
			 // Disc Slash:
			if(_charge > 0){
				sprite_index = sprHeavySlash;
				damage       = 20;
			}
			
			 // Disc-less Slash:
			else{
				damage = 8;
				force  = 6;
			}
		}
		
		 // Sounds:
		var _pitch = random_range(0.8, 1.2);
		if(_charge > 0){
			sound_play_pitchvol(sndDiscHit, 1.7 * _pitch, 1.0);
		}
		else{
			sound_play_pitchvol(sndDiscBounce, 1.2 * _pitch, 0.7);
		}
		sound_play_pitchvol(sndHammer, ((_charge > 0) ? 0.8 : 1.4) * _pitch, 1.4);
		sound_play_pitchvol(sndShovel, ((_charge > 0) ? 1.5 : 0.8) * _pitch, 0.3);
		
		 // Effects:
		weapon_post(-4, -5, 8);
		motion_add(_dir, 3.5);
		if(_charge > 0){
			sleep(15);
		}
		
		 // Fully Charged - Launch Disc:
		if(_charge >= 1){
			if(call(scr.weapon_ammo_fire, _wep)){
				with(call(scr.projectile_create, self, x, y, "BatDisc", gunangle + orandom(4 * accuracy))){
					ammo = _wep.cost;
					wep  = _wep;
				}
				sound_play_gun(sndDiscDie, 0.4, 0.3);
				weapon_post(8, 40, 5);
			}
		}
	}
	
#define step(_primary)
	var _wep = call(scr.weapon_step_init, _primary);
	
	 // Inherit:
	mod_script_call("weapon", "bat disc launcher", "step", _primary);
	
	
/// SCRIPTS
#macro  call                                                                                    script_ref_call
#macro  obj                                                                                     global.obj
#macro  scr                                                                                     global.scr
#macro  spr                                                                                     global.spr
#macro  snd                                                                                     global.snd
#macro  msk                                                                                     spr.msk
#macro  mus                                                                                     snd.mus
#macro  lag                                                                                     global.debug_lag
#macro  ntte_mods                                                                               global.mods
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  current_frame_active                                                                    ((current_frame + 0.00001) % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        if(((_primary ? '' : 'b') + _name) in self) variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);