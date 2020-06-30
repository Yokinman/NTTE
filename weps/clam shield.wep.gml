#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	
	global.sprWep       = spr.ClamShieldWep;
	global.sprWepHUD    = sprite_add_weapon("../sprites/weps/sprClamShieldHUD.png", 0, 6);
	global.sprWepLocked = mskNone;
	
	lwoWep = {
		wep : mod_current,
		inst : noone
	};
	
#macro lwoWep global.lwoWep

#define weapon_name      return (weapon_avail() ? "CLAM SHIELD" : "LOCKED");
#define weapon_text      return "ROYAL GUARD";
#define weapon_swap      return sndSwapHammer;
#define weapon_sprt(w)   return (weapon_avail() ? ((instance_is(self, Player) && instance_exists(lq_defget(w, "inst", noone))) ? mskNone : global.sprWep) : global.sprWepLocked);
#define weapon_sprt_hud  return global.sprWepHUD;
#define weapon_area      return (weapon_avail() ? 6 : -1); // 3-1
#define weapon_type      return type_melee;
#define weapon_load      return 30; // 1 Second
#define weapon_auto      return false;
#define weapon_melee     return true;
#define weapon_avail     return unlock_get("pack:coast");

#define weapon_fire(w)
	var f = weapon_fire_init(w);
	w = f.wep;
	
	 // Create Shield:
	if(!instance_exists(w.inst)){
		w.inst = obj_create(x, y, "ClamShield");
		with(w.inst){
			direction = other.gunangle;
			image_angle = direction;
			wep = w;
		}
	}
	
	 // Slash:
	var	_ox = 0,
		_oy = 0;
		
	if(instance_exists(f.creator)){
		_ox = f.creator.hspeed_raw;
		_oy = f.creator.vspeed_raw;
	}
	
	with(instances_matching(instances_matching(CustomSlash, "name", "ClamShield"), "wep", w)){
		creator = f.creator;
		team = other.team;
		
		var	l = 8 + (6 * skill_get(mut_long_arms)),
			d = image_angle,
			_x = x + _ox + lengthdir_x(l, d),
			_y = y + _oy + lengthdir_y(l, d);
			
		with(obj_create(_x, _y, "ClamShieldSlash")){
			projectile_init(other.team, other.creator);
			motion_add(d, 2 + (2.5 * skill_get(mut_long_arms)));
			image_angle = direction;
		}
		
		 // Effects:
		repeat(2){
			with(instance_create(_x + orandom(2), _y + orandom(2), Dust)){
				speed += 2;
			}
		}
		with(other){
			weapon_post(-(4 + l), 12, 0);
			motion_add(d, 2);
			sleep(40);
		}
	}
	
	 // Sound:
	var _pit = 1 + orandom(0.2);
	sound_play_pitchvol(sndCrystalJuggernaut,	_pit * 0.7, 0.7);
	sound_play_pitchvol(sndOasisExplosionSmall,	_pit * 2,   0.7);
	sound_play_pitchvol(sndOasisExplosion,		_pit * 4,   0.7);
	sound_play_pitch(sndOasisMelee,				_pit);
	sound_play_pitch(sndHammer,					_pit);
	
#define step(_primary)
	var	b = (_primary ? "" : "b"),
		w = variable_instance_get(self, b + "wep");
		
	 // LWO Setup:
	if(!is_object(w)){
		w = lq_clone(lwoWep);
		variable_instance_set(self, b + "wep", w);
	}
	
	 // Create Shield:
	if(_primary || race == "steroids"){
		if(!instance_exists(w.inst)){
			w.inst = obj_create(x, y, "ClamShield");
			with(w.inst){
				direction = other.gunangle;
				image_angle = direction;
				wep = w;
			}
		}
		with(instances_matching(instances_matching(CustomSlash, "name", "ClamShield"), "wep", w)){
			team = other.team;
			creator = other;
		}
	}
	else with(instances_matching(instances_matching(CustomSlash, "name", "ClamShield"), "wep", w)){
		instance_destroy();
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