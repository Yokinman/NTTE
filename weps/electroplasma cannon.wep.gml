#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprElectroPlasmaCannon.png", 5, 6);
	global.sprWepLocked = sprTemp;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name       return (weapon_avail() ? "ELECTROPLASMA CANNON" : "LOCKED");
#define weapon_text       return "BRAIN EXPANDING";
#define weapon_swap       return sndSwapEnergy;
#define weapon_sprt       return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area       return (weapon_avail() ? 14 : -1); // 7-1
#define weapon_type       return type_energy;
#define weapon_cost       return 10;
#define weapon_load       return 50; // 1.66 Seconds
#define weapon_avail      return call(scr.unlock_get, "pack:" + weapon_ntte_pack());
#define weapon_ntte_pack  return "trench";

#define weapon_reloaded
	sound_play(sndLightningReload);
	sound_play_pitch(sndPlasmaReload, 1.5);
	
#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	 // Projectile:
	call(scr.projectile_create, self, x, y, "ElectroPlasmaBig", gunangle + orandom(4 * accuracy), 6);
	
	 // Sounds:
	if(skill_get(mut_laser_brain) > 0){
		audio_sound_pitch(
			sound_play_gun(sndLightningShotgunUpg, 0, 0.6),
			0.6 + random(0.2)
		);
		sound_play_pitch(sndPlasmaRifleUpg, 0.5 + random(0.1));
	}
	else{
		audio_sound_pitch(
			sound_play_gun(sndLightningShotgun, 0, 0.3),
			0.6 + random(0.2)
		);
		sound_play_pitch(sndPlasmaRifle, 0.5 + random(0.1));
	}
	
	 // Effects:
	weapon_post(12, 30, 0);
	motion_add(gunangle + 180, 4);
	instance_create(x, y, Smoke);
	
	
	
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