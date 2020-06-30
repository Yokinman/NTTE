#define init
	global.sprWep = sprite_add_weapon("../sprites/weps/sprBatTether.png", 4, 3);
	global.sprWepLocked = mskNone;
	
	lwoWep = {
		wep  : mod_current,
		ammo : 6,
		amax : 6,
		cost : 1,
		buff : false
	};
	
#macro lwoWep global.lwoWep

#define weapon_name         return (weapon_avail() ? "VAMPIRE" : "LOCKED");
#define weapon_text         return "HEMOELECTRICITY";
#define weapon_swap         return sndSwapEnergy;
#define weapon_sprt         return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_sprt_hud(w)  return weapon_ammo_hud(w);
#define weapon_area         return (weapon_avail() ? 10 : -1); // 5-2
#define weapon_type         return type_melee;
#define weapon_load         return 5; // 0.16 Seconds
#define weapon_auto(w)      return ((is_object(w) && w.ammo < w.cost) ? -1 : true);
#define weapon_melee        return false;
#define weapon_avail        return unlock_get("pack:lair");

#define weapon_fire(w)
	var f = weapon_fire_init(w);
	w = f.wep;
	
	 // Fire:
	if(weapon_ammo_fire(w)){
		 // Projectile:
		with(obj_create(x, y, "TeslaCoil")){
			direction = other.gunangle;
			creator = f.creator;
			team = other.team;
			dist_max = 64;
			time = 7 * (1 + skill_get(mut_laser_brain));
			
			bat = true;
			
			roids = f.roids;
			if(roids) creator_offy -= 4;
		}
		
		 // Refill:
		if(w.ammo <= 0 && instance_is(self, Player)){
			w.ammo = w.amax * (1 + skill_get(mut_back_muscle));
			
			 // Hurt:
			projectile_hit_raw(f.creator, 1, false);
			lasthit = [global.sprWep, "PLAYING GOD"];
			
			 // Hurt FX:
			if(my_health > 0){
				var _addVol = (my_health <= maxhealth / 2) * 0.3;
				
				 // Sounds:
				sound_play_pitchvol(sndGammaGutsProc, 0.9 + random(0.3), 1.1 + _addVol);
				sound_play_pitchvol(sndHitFlesh,      0.8 + random(0.4), 0.9 + _addVol);
				
				 // Effects:
				view_shake_max_at(x, y, 12);
				sleep(24);
				
				instance_create(x, y, AllyDamage);
			}
			
			 // Death FX:
			else{
				sound_play(sndGammaGutsKill);
				sound_play_pitchvol(sndHyperCrystalSearch, 0.8, 0.8);
				view_shake_max_at(x, y, 24);
				sleep(48);
			}
		}
		
		 // Effects:
		if(array_length(instances_matching(instances_matching(instances_matching(instances_matching(CustomObject, "name", "TeslaCoil"), "bat", true), "creator", f.creator), "roids", f.roids)) <= 1){
			weapon_post(8, -10, 10);
			
			 // Upgrade Sounds:
			if(skill_get(mut_laser_brain)){
				sound_play_pitchvol(sndBloodLauncherExplo, 0.7 + random(0.3), 0.8);
				sound_play_pitchvol(sndLightningShotgunUpg, 0.7 + random(0.4), 0.8)
			}
			
			 // Default Sounds:
			else{
				sound_play_pitchvol(sndBloodLauncherExplo, 0.9 + random(0.4), 0.8);
				sound_play_pitchvol(sndLightningShotgun, 0.8 + random(0.4), 0.8)
			}
		}
		if(skill_get(mut_laser_brain)){
			instance_create(x, y, LaserBrain).creator = f.creator; // Upgrade FX
		}
	}
	
#define step(_primary)
	var	b = (_primary ? "" : "b"),
		w = variable_instance_get(self, b + "wep");
		
	 // LWO Setup:
	if(!is_object(w)){
		w = lq_clone(lwoWep);
		variable_instance_set(self, b + "wep", w);
	}
	
	 // Back Muscle:
	with(w){
		var _muscle = skill_get(mut_back_muscle);
		if(buff != _muscle){
			var _amaxRaw = (amax / (1 + buff));
			buff = _muscle;
			amax = (_amaxRaw * (1 + buff));
			ammo += (amax - _amaxRaw);
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
#define weapon_fire_init(_wep)                                                          return  mod_script_call(   'mod', 'telib', 'weapon_fire_init', _wep);
#define weapon_ammo_fire(_wep)                                                          return  mod_script_call(   'mod', 'telib', 'weapon_ammo_fire', _wep);
#define weapon_ammo_hud(_wep)                                                           return  mod_script_call(   'mod', 'telib', 'weapon_ammo_hud', _wep);
#define weapon_get_red(_wep)                                                            return  mod_script_call(   'mod', 'telib', 'weapon_get_red', _wep);
#define wep_get(_wep)                                                                   return  mod_script_call_nc('mod', 'telib', 'wep_get', _wep);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   'mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);