#define init
	global.sprWep = sprite_add_weapon("../sprites/weps/sprBatDiscLauncher.png", 6, 5);
	global.sprWepLocked = mskNone;
	
	lwoWep = {
		wep  : mod_current,
		ammo : 3,
		amax : 3,
		anam : "SAWBLADES",
		cost : 1,
		buff : false,
		canload : true
	};
	
#macro lwoWep global.lwoWep

#define weapon_name         return (weapon_avail() ? "SAWBLADE GUN" : "LOCKED");
#define weapon_text         return "LIKE DISCS BUT @ySMARTER";
#define weapon_swap         return sndSwapShotgun;
#define weapon_sprt         return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_sprt_hud(w)  return weapon_ammo_hud(w);
#define weapon_area         return (weapon_avail() ? 7 : -1); // 3-2
#define weapon_type         return type_melee;
#define weapon_load         return 8; // 0.26 Seconds
#define weapon_auto         return true;
#define weapon_melee        return false;
#define weapon_avail        return unlock_get("pack:lair");

#define weapon_fire(w)
	var f = weapon_fire_init(w);
	w = f.wep;
	
	 // Fire:
	if(weapon_ammo_fire(w)){
		 // Projectile:
		with(obj_create(x, y, "BatDisc")){
			direction = other.gunangle + orandom(12 * other.accuracy);
			creator = f.creator;
			team = other.team;
			ammo = w.cost;
			my_lwo = w;
			
			 // Death to Free Discs:
			if(other.infammo != 0) ammo = 0;
		}
		
		 // Effects:
		weapon_post(8, 8, 8);
		motion_set(gunangle + 180, 2);
		repeat(irandom_range(3, 6)){
			with(instance_create(x, y, Smoke)){
				motion_set(other.gunangle + orandom(24), random(6));
			}
		}
		
		 // Sounds:
		sound_play_pitchvol(sndSuperDiscGun,    0.8 + random(0.4), 0.6);
		sound_play_pitchvol(sndRocket,          1.0 + random(0.6), 0.8);
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
	
	 // Encourage Less Hold-Down-LMouse Play:
	if(w.canload){
		if(w.ammo <= 0) w.canload = false;
	}
	else{
		 // Stop Reloading:
		if(w.ammo > 0){
			variable_instance_set(self, b + "reload", weapon_load());
			variable_instance_set(self, b + "can_shoot", false);
		}
		
		 // Smokin'
		if(current_frame_active){
			var	_dir = gunangle,
				_disx = 12 - wkick,
				_disy = 2,
				_x = x,
				_y = y;
				
			if(!_primary){
				if(race == "steroids"){
					_y -= 4;
					_disy -= 4;
				}
				else{
					_dir = 90 + (20 * right);
				}
			}
			
			with(instance_create(_x + lengthdir_x(_disx, _dir) + lengthdir_x(_disy, _dir - (90 * right)), _y + lengthdir_y(_disx, _dir) + lengthdir_y(_disy, _dir - (90 * right)), Smoke)){
				hspeed += other.hspeed / 2;
				vspeed += other.vspeed / 2;
				motion_add(_dir, 2);
				image_xscale /= 1.5;
				image_yscale /= 1.5;
				growspeed = -0.015;
				gravity = -0.1;
			}
		}
		
		 // Ammo Returned:
		if(w.ammo >= w.amax) w.canload = true;
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