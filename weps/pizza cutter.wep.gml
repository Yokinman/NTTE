#define init
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprPizzaCutter.png",			 2, 8);
	global.sprWepHUD	= sprite_add_weapon("../sprites/weps/sprPizzaCutterEmpty.png",		 9, 6);
	global.sprWepEmpty  = sprite_add_weapon("../sprites/weps/sprPizzaCutterEmpty.png",		 2, 8);
	global.sprWepHoming = sprite_add_weapon("../sprites/weps/sprPizzaCutterEmptyHoming.png", 2, 8);
	global.sprWepLocked = mskNone;

	 // LWO:
	global.lwoWep = {
		wep       : mod_current,
		ammo      : 1,
		amax      : 1,
		anam      : "SAWBLADES",
		cost      : 1,
		buff      : false,
		canload   : true,
		load      : 24,
		bload     : 8,
		chrg      : false,
		chrg_num  : 0,
		chrg_max  : 7,
		chrg_obj  : noone,
		wepangle  : 0,
		primary   : true,
		visible   : true,
		last      : 0,
		disc      : noone
	};

#define weapon_name            return (weapon_avail() ? "PIZZA CUTTER" : "LOCKED");
#define weapon_text            return "FOR THE CIVILIZED TURTLE";
#define weapon_swap            return sndSwapHammer;
#define weapon_sprt(_wep)      return (weapon_avail() ? (instance_is(self, Player) ? (_wep.ammo > 0 ? global.sprWep : (instance_exists(_wep.disc) && _wep.disc.image_index > 0 ? global.sprWepHoming : global.sprWepEmpty)) : global.sprWep) : global.sprWepLocked);
#define weapon_sprt_hud(_wep)  
	weapon_ammo_hud(_wep);
	return global.sprWepHUD;
	
#define weapon_area            return (weapon_avail() ? 7 : -1); // 3-2
#define weapon_type            return type_melee;
#define weapon_load(_wep)
	 // Slash Reload:
	if(is_object(_wep) && instance_is(self, Player)){
		if((wep == _wep && reload > 0 && !can_shoot) || (bwep == _wep && breload > 0 && !bcan_shoot)){
			if _wep.ammo > 0 return _wep.load else return _wep.bload
		}
	}

	 // Normal:
	return current_time_scale;
#define weapon_auto(_wep)      return (is_object(_wep) && instance_is(self, Player) && _wep.ammo> 0) ? true : false;
#define weapon_melee           return true;
#define weapon_avail           return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack       return "lair";
#define weapon_shrine          return [mut_long_arms, mut_bolt_marrow];
#define weapon_chrg            return true; // Defpack 4
#define weapon_reloaded(_wep)  if (is_object(_wep) && instance_is(self, Player) && _wep.chrg_num < _wep.chrg_max) sound_play(sndMeleeFlip);

#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;

	if (_wep.ammo > 0){
		 // Charge Cutter:
		if(_wep.visible){
			_wep.chrg = true;
			_wep.primary = !(_fire.spec && _fire.roids);

			 // Charging:
			if(_wep.chrg_num < _wep.chrg_max){
				_wep.chrg_num += current_time_scale;

				 // Charging FX:
				sound_play_pitch(sndMeleeFlip, 1 / (1 - ((_wep.chrg_num / _wep.chrg_max) * 0.25)));
				sound_play_pitchvol(sndSwapBow, .3 + ((_wep.chrg_num / _wep.chrg_max) * 2), .3);

				 // Full Charge:
				if(_wep.chrg_num >= _wep.chrg_max){
					_wep.chrg_num = _wep.chrg_max;

					 // FX:
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
			else if(frame_active(12)){
				with(_fire.creator) if(instance_is(self, Player)){
					gunshine = 2;
				}
			}

			 // Pullback:
			if(_wep.last < current_frame){
				_wep.last = current_frame;
				var _num = (_wep.chrg_num / _wep.chrg_max);
				weapon_post(-6 * _num, 8 * _num * current_time_scale, 0);
				wepangle *= -1;
				wepflip *= -1;
			}

			 // Pop Pop, Blood Gamble:
			if(_fire.spec && !_fire.roids){
				_wep.chrg_num = _wep.chrg_max;
			}

			 // Charge Controller:
			if(!instance_exists(_wep.chrg_obj)){
				_wep.chrg_obj = script_bind_step(cutter_chrg, 0, _wep);
			}
			with(_wep.chrg_obj){
				x         = other.x;
				y         = other.y;
				direction = other.gunangle;
				team      = other.team;
				creator   = _fire.creator;
			}
		}
	}
	else{
		
		 // Reload:
		wep_set(_wep.primary, "reload",    _wep.bload);
		wep_set(_wep.primary, "can_shoot", false);

		 // Stabby:
		if(instance_is(self, Player)){
			weapon_post(wkick, -5, 8);
		}

		// Slash:
		var _fire = weapon_fire_init(_wep);
		_wep = _fire.wep;

		var _skill = skill_get(mut_long_arms),
			_len   = (20 * _skill),
			_dir   = gunangle + (orandom(8) * accuracy);

		with(projectile_create(
			x + lengthdir_x(_len, _dir),
			y + lengthdir_y(_len, _dir),
			Slash,
			_dir,
			3 + (2 * _skill)
		)){
			damage = 10;
			force  = 3;
		}
		
		motion_add(_dir, 4);
		x -= hspeed;
		y -= vspeed;
		
		wepangle *= -1;

		 // Sounds:
		var _pitch = random_range(0.8, 1.2);
		sound_play_pitchvol(sndDiscBounce, 1.2 * _pitch,  .7);
		sound_play_pitchvol(sndHammer,     1.4 * _pitch, 1.4);
		sound_play_pitchvol(sndWrench,      .8 * _pitch,  .3);
	}

#define cutter_chrg(_wep)
		if(!_wep.chrg){
			with(creator){
				if(_wep.chrg_num > 0){
					if(wep_get(_wep.primary, "wep", _wep) == _wep){
						
						 // Full Charge:
						if(_wep.chrg_num >= _wep.chrg_max){
						 	if(weapon_ammo_fire(_wep)){
							 	with(projectile_create(x, y, "BatDisc", gunangle + orandom(4 * accuracy), 0)){
							 		ammo = ((other.infammo == 0) ? _wep.cost : 0);
							 		wep  = _wep;
									_wep.disc = self;
							 	}
							}
							
							if(instance_is(self, Player) || instance_is(self, FireCont)){
								weapon_post(-wkick, 40, 5);
								wepangle *= -1;
							}
						}

						 // Cutter Slash:
						else{

							 // Reload:
							wep_set(_wep.primary, "reload",    _wep.load);
							wep_set(_wep.primary, "can_shoot", false);

							 // Stabby:
							if(instance_is(self, Player)){
								weapon_post(wkick, -5, 8);
							}

							// Slash:
							var _fire = weapon_fire_init(_wep);
							_wep = _fire.wep;

							var _skill = skill_get(mut_long_arms),
								_len   = (20 * _skill),
								_dir   = gunangle + (orandom(8) * accuracy);

							with(projectile_create(
								x + lengthdir_x(_len, _dir),
								y + lengthdir_y(_len, _dir),
								Slash,
								_dir,
								3 + (2 * _skill)
							)){
								sprite_index = sprHeavySlash;
								
								damage = 16;
								force  = 6;
							}
						}
						
						x -= hspeed;
						y -= vspeed;
						motion_add(_dir, 4);
						
						 // Sounds:
						var _pitch = random_range(0.8, 1.2);
						sound_play_pitchvol(sndDiscHit, 1.7 * _pitch,   1);
						sound_play_pitchvol(sndHammer,   .8 * _pitch, 1.4);
						sound_play_pitchvol(sndShovel,  1.5 * _pitch,  .3);

						sleep(15);
					}
				}
				_wep.chrg_num = 0;
			}
			instance_destroy();
		}
		_wep.chrg = false;

#define end_step(_primary, _wep, _inst)
	instance_destroy();

	// Wepangle Transition:
	if(is_object(_wep) && "wepangle" in _wep){
		with(_inst){
		if(_wep == wep_get(_primary, "wep", null)){
			wep_set(_primary, "wepangle", _wep.wepangle);

			_wep.wepangle *= -1;

			if(abs(_wep.wepangle) < 1){
				_wep.wepangle = 0;
				}
			}
		}
	}

#define step(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);

	 // LWO Setup:
	if(!is_object(_wep)){
		_wep = lq_clone(global.lwoWep);
		wep_set(_primary, "wep", _wep);
	}

	 // Back Muscle:
	with(_wep){
		var _muscle = skill_get(mut_back_muscle);
		if(buff != _muscle){
			var _amaxRaw = (amax / (1 + buff));
			buff = _muscle;
			amax = (_amaxRaw * (1 + buff));
			ammo += (amax - _amaxRaw);
		}
	}

	 // Encourage Less Hold-Down-LMouse Play:
	if(_wep.canload){
		if(_wep.ammo <= 0 && variable_instance_get(self, "bonus_ammo", 0) <= 0){
			_wep.canload = false;
		}
	}
	else{
		 // Stop Reloading:
		if(_wep.ammo > 0){
			wep_set(_primary, "reload",    weapon_get_load(_wep));
			wep_set(_primary, "can_shoot", false);
		}

		 // Smokin'
		if(current_frame_active){
			var	_x    = x,
				_y    = y,
				_dir  = wepangle + gunangle,
				_disx = 16 - wkick,
				_disy = 2;

			if(!_primary){
				if(race == "steroids"){
					_y -= 4;
					_disy -= 4;
				}
				else{
					_dir = 90 + (20 * right);
				}
			}

			with(instance_create(
				_x + lengthdir_x(_disx, _dir) + lengthdir_x(_disy, _dir - (90 * right)),
				_y + lengthdir_y(_disx, _dir) + lengthdir_y(_disy, _dir - (90 * right)),
				Smoke
			)){
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
		if(_wep.ammo >= _wep.amax){
			_wep.canload = true;
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
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define projectile_create(_x, _y, _obj, _dir, _spd)                                     return  mod_script_call_self('mod', 'telib', 'projectile_create', _x, _y, _obj, _dir, _spd);
#define weapon_fire_init(_wep)                                                          return  mod_script_call     ('mod', 'telib', 'weapon_fire_init', _wep);
#define weapon_ammo_fire(_wep)                                                          return  mod_script_call     ('mod', 'telib', 'weapon_ammo_fire', _wep);
#define weapon_ammo_hud(_wep)                                                           return  mod_script_call     ('mod', 'telib', 'weapon_ammo_hud', _wep);
#define weapon_get_red(_wep)                                                            return  mod_script_call_self('mod', 'telib', 'weapon_get_red', _wep);
#define wep_raw(_wep)                                                                   return  mod_script_call_nc  ('mod', 'telib', 'wep_raw', _wep);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define frame_active(_interval)                                                         return  mod_script_call_nc  ('mod', 'telib', 'frame_active', _interval);
#define player_swap()                                                                   return  mod_script_call_self('mod', 'telib', 'player_swap');
#define wep_set(_primary, _name, _value)                                                        variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);
