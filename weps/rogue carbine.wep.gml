#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprRogueCarbine.png", 8, 3);
	global.sprWepLocked = mskNone;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr

#define weapon_name        return "ROGUE CARBINE";
#define weapon_text        return "THERE'S NO TALKING TO THEM";
#define weapon_swap        return sndSwapMachinegun;
#define weapon_sprt        return global.sprWep;
#define weapon_area        return -1; // Don't Spawn
#define weapon_type        return type_bullet;
#define weapon_cost        return 4;
#define weapon_load        return 5; // 0.37 Seconds
#define weapon_burst       return 2;
#define weapon_burst_time  return 2; // 0.07 Seconds

#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Burst Fire:
	with(projectile_create(x, y, "CustomBullet", gunangle + orandom(4 * accuracy), 16)){
		 // Visual:
		sprite_index = spr.IDPDHeavyBullet;
		spr_dead     = spr.IDPDHeavyBulletHit;
		
		 // Vars:
		damage = 7;
		force  = 12;
		gland  = weapon_get_cost(_wep) / weapon_get("burst", _wep);
	}
	
	 // Sounds:
	audio_sound_pitch(sound_play_gun(sndHeavyMachinegun, 0, 0.3), 1.4 + random(0.2));
	audio_sound_pitch(sound_play_gun(sndRogueRifle,      0, 0.3), 0.6 + random(0.5));
	audio_sound_pitch(sound_play_gun(sndGruntFire,       0, 0.3), 0.6 + random(0.2));
	audio_sound_pitch(sound_play_gun(sndIDPDNadeLoad,    0, 0.3), 2.4 + random(0.4));
	
	 // Effects:
	weapon_post(5, -7, 2);
	with(instance_create(x, y, Shell)) {
		sprite_index = sprHeavyShell;
		motion_add(other.gunangle + 180 + orandom(25), 2 + random(3));
	}
	
	
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