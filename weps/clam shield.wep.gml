#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = spr.ClamShieldWep;
	global.sprWepHUD    = sprite_add_weapon("../sprites/weps/sprClamShieldHUD.png", 0, 6);
	global.sprWepLocked = sprTemp;
	
	 // LWO:
	global.lwoWep = {
		"wep"  : mod_current,
		"inst" : noone
	};
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr

#define weapon_name        return (weapon_avail() ? "CLAM SHIELD" : "LOCKED");
#define weapon_text        return "ROYAL GUARD";
#define weapon_swap        return sndSwapHammer;
#define weapon_sprt(_wep)  return (weapon_avail() ? ((instance_is(self, hitme) && instance_exists(lq_defget(_wep, "inst", noone))) ? mskNone : global.sprWep) : global.sprWepLocked);
#define weapon_sprt_hud    return global.sprWepHUD;
#define weapon_area        return (weapon_avail() ? 6 : -1); // 3-1
#define weapon_type        return type_melee;
#define weapon_load        return 30; // 1 Second
#define weapon_auto        return false;
#define weapon_melee       return true;
#define weapon_avail       return call(scr.unlock_get, "pack:" + weapon_ntte_pack());
#define weapon_ntte_pack   return "coast";

#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	 // Create Shield:
	if(!instance_exists(_wep.inst)){
		_wep.inst = call(scr.projectile_create, self, x, y, "ClamShield", gunangle);
		with(_wep.inst){
			wep = _wep;
		}
	}
	
	 // Shield Bash:
	var	_ox = 0,
		_oy = 0;
		
	if(instance_exists(_fire.creator)){
		_ox = _fire.creator.hspeed_raw;
		_oy = _fire.creator.vspeed_raw;
	}
	
	with(instances_matching(obj.ClamShield, "wep", _wep)){
		var	_l = lerp(8, 14, skill_get(mut_long_arms)),
			_d = image_angle,
			_x = x + _ox + lengthdir_x(_l, _d),
			_y = y + _oy + lengthdir_y(_l, _d);
			
		with(other){
			 // Slash:
			call(scr.projectile_create, self, _x, _y, "ClamShieldSlash", _d, lerp(2, 4.5, skill_get(mut_long_arms)));
			
			 // Sounds:
			var _pitch = 1 + orandom(0.2);
			sound_play_pitchvol(sndCrystalJuggernaut,	_pitch * 0.7, 0.7);
			sound_play_pitchvol(sndOasisExplosionSmall,	_pitch * 2.0, 0.7);
			sound_play_pitchvol(sndOasisExplosion,		_pitch * 4.0, 0.7);
			sound_play_pitch(sndOasisMelee,				_pitch);
			sound_play_pitch(sndHammer,					_pitch);
			
			 // Effects:
			repeat(2){
				with(instance_create(_x + orandom(2), _y + orandom(2), Dust)){
					speed += 2;
				}
			}
			weapon_post(-(4 + _l), 12, 0);
			motion_add(_d, 2);
			sleep(40);
		}
	}
	
#define step(_primary)
	var _wep = call(scr.weapon_step_init, _primary);
	
	 // Create Shield:
	if(_primary || race == "steroids"){
		if(!instance_exists(_wep.inst)){
			_wep.inst = call(scr.projectile_create, self, x, y, "ClamShield", gunangle);
			with(_wep.inst){
				wep = _wep;
			}
		}
	}
	else if(array_length(obj.ClamShield)){
		var _inst = instances_matching(obj.ClamShield, "wep", _wep);
		if(array_length(_inst)) with(_inst){
			instance_destroy();
		}
	}
	
	
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
#define wep_set(_primary, _name, _value)                                                        variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);