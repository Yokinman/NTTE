#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprTeleportGun.png", 4, 4);
	
	 // LWO:
	global.lwoWep = {
		"wep"      : mod_current,
		"inst"     : [],
		"gunangle" : 0
	};
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name   return "TELEPORT GUN";
#define weapon_text   return "DON'T BLINK";
#define weapon_sprt   return global.sprWep;
#define weapon_area   return 7; // 3-2
#define weapon_type   return type_melee;
#define weapon_load   return 10; // 0.33 Seconds
#define weapon_auto   return true;
#define weapon_melee  return false;

#define weapon_swap
	sound_play(sndCrystalTB);
	return sndSwapShotgun;
	
#define weapon_ntte_eat
	 // Unleash da Portal:
	if(!instance_is(self, Portal)){
		with(call(scr.projectile_create, self, x, y, "PortalBullet", random(360), 20)){
			event_perform(ev_other, ev_animation_end);
			move_contact_solid(direction, random_range(32, 160));
			instance_destroy();
		}
		
		 // Effects:
		view_shake_at(x, y, 30);
		sound_play_pitch(sndGuardianDead, 0.6);
	}
	
#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	 // Portal Bullet:
	with(call(scr.projectile_create, self, x, y, "PortalBullet", gunangle, random_range(11, 13))){
		mask    = mskPlasma;
		damage  = 25;
		spec    = _fire.spec;
		primary = _fire.primary;
		
		 // Remember Me:
		array_push(_wep.inst, id);
	}
	_wep.gunangle = gunangle;
	
	 // Sound:
	sound_play_hit(sndGuardianAppear, 0.2);
	var _snd = sound_play_hit(sndClick, 0);
	audio_sound_pitch(_snd, 1.5);
	audio_sound_gain(_snd, 0.7 * audio_sound_get_gain(_snd), 0);
	var _snd = sound_play_gun(sndCrystalTB, 0, 0.5);
	audio_sound_pitch(_snd, 0.6 + random(0.2));
	audio_sound_gain(_snd, 1.5 * audio_sound_get_gain(_snd), 0);
	
	 // Effects:
	weapon_post(5, -5, 2);
	
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
	
	 // Portal Bullet Control:
	_wep.inst = instances_matching_ne(_wep.inst, "id", null);
	if(array_length(_wep.inst)){
		 // Dynamic Reload:
		wep_set(_primary, "reload",    max(wep_get(_primary, "reload", 0), weapon_get_load(_wep)));
		wep_set(_primary, "can_shoot", false);
		
		 // Aiming:
		if(gunangle != _wep.gunangle){
			var _turn = angle_difference(gunangle, _wep.gunangle);
			with(_wep.inst){
				if(hold){
					direction   += _turn;
					image_angle += _turn;
				}
			}
		}
	}
	_wep.gunangle = gunangle;
	
	
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