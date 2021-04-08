#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = spr.UltraQuasarRifle;
	global.sprWepLocked = sprTemp;
	
	 // LWO:
	global.lwoWep = {
		"wep"  : mod_current,
		"beam" : noone
	};
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name         return (weapon_avail() ? "ULTRA QUASAR RIFLE" : "LOCKED");
#define weapon_text         return "THE GREEN SUN";
#define weapon_swap         return sndSwapEnergy;
#define weapon_sprt         return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area         return -1;
#define weapon_type         return type_energy;
#define weapon_cost         return 10;
#define weapon_rads			return 60;
#define weapon_load         return 60; // 2 Seconds
#define weapon_auto         return true;
#define weapon_avail        return call(scr.unlock_get, "pack:" + weapon_ntte_pack());
#define weapon_ntte_pack    return "trench";
#define weapon_ntte_quasar  return true;

#define weapon_fire(_wep)
	var	_fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	 // New Beam:
	if(!instance_exists(_wep.beam) || (_fire.spec && _fire.primary)){
		 // Quasar Beam:
		with(call(scr.projectile_create, self, x, y, "QuasarBeam", gunangle + orandom(6 * accuracy))){
			 // Visual:
			sprite_index = spr.UltraQuasarBeam;
			spr_strt	 = spr.UltraQuasarBeamStart;
			spr_stop	 = spr.UltraQuasarBeamEnd;
			
			 // Vars:
			mask_index   = msk.UltraQuasarBeam;
			image_yscale = 0.6;
			turn_factor  = 1/100;
			offset_dis   = 24;
			ultra		 = true;
			damage		 = 48; // 4x
			_wep.beam    = self;
		}
		
		call(scr.projectile_create, self, x, y, "UltraQuasarFlame", gunangle);
		
		 // Sound:
		var _brain = skill_get(mut_laser_brain);
		sound_play_pitch((_brain ? sndLaserUpg  : sndLaser),  0.4 + random(0.1));
		sound_play_pitch((_brain ? sndPlasmaUpg : sndPlasma), 1.2 + random(0.2));
		sound_play_pitchvol(sndExplosion, 1.5, 0.5);
		
		 // Effects:
		weapon_post(32, -16, 32);
		motion_add(gunangle + 180, 4);
		move_contact_solid(direction, speed);
	}
	
	 // Charge Beam:
	else with(_wep.beam){
		if(image_yscale < 1){
			scale_goal = 1;
		}
		else{
			var	_a = 0.25,
				_m = 1 + (_a * (1 + (0.4 * skill_get(mut_laser_brain))));
				
			if(scale_goal < _m){
				scale_goal = min((floor(image_yscale / _a) * _a) + _a, _m);
				flash_frame = max(flash_frame, current_frame + 2);
			}
		}
		
		 // Knockback:
		if(image_yscale < scale_goal){
			with(other) motion_add(gunangle + 180, 2);
			flash_frame = max(flash_frame, current_frame + 3);
		}
	}
	
	 // Keep Setting:
	with(_wep.beam){
		shrink_delay = weapon_get_load(_wep) + 1;
		primary      = _fire.primary;
	}
	
#define step(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);
	
	 // LWO Setup:
	if(!is_object(_wep)){
		_wep = { "wep" : _wep };
		wep_set(_primary, "wep", _wep);
	}
	for(var i = lq_size(global.lwoWep) - 1; i >= 0; i--){
		var _key = lq_get_key(global.lwoWep, i);
		if(_key not in _wep){
			lq_set(_wep, _key, lq_get_value(global.lwoWep, i));
		}
	}
	
	
/// SCRIPTS
#macro  call                                                                                    script_ref_call
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
#define wep_set(_primary, _name, _value)                                                        variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);