#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	
	DebugLag = false;
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#macro DebugLag global.debug_lag

#define LabsVat_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle = spr.LabsVatIdle;
		spr_hurt = spr.LabsVatHurt;
		spr_dead = spr.LabsVatDead;
		spr_back = spr.LabsVatBack;
		sprite_index = spr_idle;
		depth = -1;
		
		 // Sounds:
		snd_hurt = sndLabsTubeBreak;
		snd_dead = sndLabsMutantTubeBreak;
		
		 // Vars:
		mask_index = -1;
		maxhealth = 50;
		raddrop = 4;
		size = 3;
		team = 1;
		wave = random(100);
		setup = true;
		var _pool = [];
			/// Danger
			repeat(3) array_push(_pool, Freak);
			repeat(2) array_push(_pool, "FishFreak");
			repeat(3) array_push(_pool, "Angler");
			repeat(3) array_push(_pool, "PortalGuardian");
			repeat(2) array_push(_pool, PopoFreak);
			repeat(1) array_push(_pool, "CrystalHeart");
			repeat(1) array_push(_pool, Bandit);
			
			/// Loot
			repeat(1) array_push(_pool, WeaponChest);
			repeat(1) array_push(_pool, "Backpack");
			
		if(unlock_get("crown:crime")){
			repeat(1) array_push(_pool, choose("CatChest", "BatChest"));
		}
			
		thing = {};
		with(thing){
			type = _pool[irandom(array_length(_pool) - 1)];
			color = make_color_rgb(40, 87, 9);
			index = -1;
			sprite = mskNone;
			right = choose(1, -1);
			wep = wep_none;
			pet_data = {};
			with(pet_data){
				pet_name = "";
				mod_type = "mod";
				mod_name = "petlib";
			}
		}
		
		 // Alarms:
		alarm1 = -1;
		alarm2 = -1;
		
		return id;
	}
	
#define LabsVat_setup
	setup = false;
	
	var _x = x,
		_y = y,
		_canWatch = false;
	with(thing){
		switch(type){
			case "MergedWep":
				wep = wep_revolver;
				var _part = wep_merge_decide(0, GameCont.hard);
				if(array_length(_part) >= 2){
					wep = wep_merge(_part[0], _part[1]);
				}
				sprite = weapon_get_sprite(wep);
				break;
				
			case Freak:
				sprite = sprFreak1Idle;
				_canWatch = true;
				break;
				
			case "FishFreak":
				sprite = spr.FishFreakIdle;
				_canWatch = true;
				break;
				
			case "Angler":
				sprite = sprRadChest;
				break;
				
			case "PortalGuardian":
				sprite = spr.PortalGuardianIdle;
				_canWatch = true;
				break;
				
			case PopoFreak:
				sprite = sprPopoFreakIdle;
				_canWatch = true;
				break;
				
			case "CrystalHeart":
				sprite = spr.CrystalHeartIdle;
				break;
				
			case Bandit:
				sprite = sprBanditHurt;
				break;
				
			case WeaponChest:
				sprite = sprWeaponChest;
				break;
				
			case "Backpack":
			case "CatChest":
			case "BatChest":
				sprite = lq_get(spr, type);
				break;
				
			 // Labs Event Exclusive:
			case "Pet":
				_canWatch = true;
				/*
				with(obj_create(_x, _y - 20, "CatLight")){
					w1 *= 2;
					w2 *= 3/2;
					h1 *= 7/6;
					h2 *= 2;
				}
				*/
				break;
		}
	}
	
	 // Ever Vigilant:
	if(_canWatch){
		alarm2 = 90;
	}
	
#define LabsVat_step
	if(setup) LabsVat_setup();
	wave += current_time_scale;
	x = xstart;
	y = ystart;

	 // Draw Back:
	script_bind_draw(LabsVat_draw_back, depth + 1/100, id);
	
#define LabsVat_draw_back(_inst)
	with(_inst){
		var _imageIndex = (wave * image_speed);
		draw_sprite_ext(spr_back, _imageIndex, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		
		 // Draw Thing:
		var _oc = chance(1, 30),
			_ol = 2,
			_od = random(360),
			_xo = _oc * lengthdir_x(_ol, _od),
			_yo = _oc * lengthdir_y(_ol, _od),
			_sprite = thing.sprite,
			_index = (thing.index == -1 ? _imageIndex : thing.index),
			_x = x + _xo + (sin(wave / 10) * 2),
			_y = y + _yo + (cos(wave / 10) * 3),
			_xScale = (image_xscale * thing.right),
			_yScale = image_yscale,
			_angle = image_angle + sin(wave / 30) * 30,
			_blend = c_white,
			_alpha = image_alpha;
			
		draw_set_fog(true, thing.color, 0, 0);
		draw_sprite_ext(_sprite, _index, _x, _y, _xScale, _yScale, _angle, _blend, _alpha);
		draw_set_fog(false, c_white, 0, 0);
	}
	
	 // Goodbye:
	instance_destroy();
	
#define LabsVat_alrm1
	alarm1 = 10 + random(10);
	
	projectile_hit_np(id, 10, 0, 0);
	view_shake_max_at(x, y, 10);
	with(instance_create(x + orandom(15), y + orandom(20), SmokeOLD)){
		sprite_index = sprExploderExplo;
		image_index = 1;
		depth = other.depth - 1;
		repeat(2 + irandom(2)){
			instance_create(x + orandom(6), y + orandom(6), Smoke);
		}
	}
	
#define LabsVat_alrm2
	alarm2 = 30 + random(60);
	var _target = instance_nearest(x, y, Player);
	if(in_sight(_target)){
		thing.right = (x > _target.x ? -1 : 1);
	}
	
#define LabsVat_death
	 // Effects:
	repeat(24){
		with(instance_create(x, y, Shell)){
			sprite_index = spr.LabsVatGlass;
			image_index = irandom(image_number - 1);
			image_speed = 0;
			motion_set(random(360), random_range(2, 6));
			x += hspeed;
			y += vspeed;
		}
	}
	with(obj_create(x, y, "BuriedVaultChestDebris")){
		sprite_index = spr.LabsVatLid;
		mask_index = mskExploder;
		zfriction /= 2;
		zspeed *= 2/3;
		bounce = irandom_range(1, 2);
		snd_land = sndTechnomancerHurt;
	}
	repeat(12){
		with(instance_create(x + orandom(20), y - irandom(25), AcidStreak)){
			image_angle = 270;
			image_index = random(2);
		}
	}
	repeat(24){
		var	c = random(1),
			l = (48 * c),
			d = random(360);

		with(instance_create(x + lengthdir_x(l, d), (y + 16) + lengthdir_y(l, d), SmokeOLD)){
			sprite_index = sprExploderExplo;
			image_index = 2 + (3 * (1 - c));
			motion_set(d, 2);
		}
	}
	
	 // Drops:
	var _x = x,
		_y = y,
		_minID = GameObject.id;
	with(thing){
		var _wep = wep;
		switch(type){
			case Bandit:
			case Freak:
			case PopoFreak:
			case "PortalGuardian":
			case WeaponChest:
			case "OrchidChest":
			case "Backpack":
			case "CatChest":
			case "BatChest":
				obj_create(_x, _y, type);
				break;
				
			case "MergedWep":
				with(instance_create(_x, _y, WepPickup)){
					wep = _wep;
				}
				break;
				
			case "FishFreak":
				with(instance_create(_x, _y, Freak)){
					fish_freak = true;
					spr_idle = spr.FishFreakIdle;
					spr_walk = spr.FishFreakWalk;
					spr_hurt = spr.FishFreakHurt;
					spr_dead = spr.FishFreakDead;
				}
				break;
				
			/*
			case PopoFreak:
				instance_create(_x, _y, type);
				repeat(2) instance_create(_x, _y, IDPDSpawn);
				with(instance_create(_x, _y - 16, type)){
					my_health = 0;
					with(self) event_perform(ev_destroy, 0);
				}
				
				 // Quality Assurance:
				with(instances_matching_gt(WantRevivePopoFreak, "id", _minID)){
					alarm0 = 120;
				}
				with(instances_matching_gt([PopoNade, IDPDPortalCharge], "id", _minID)){
					instance_delete(id);
				}
				break;
				*/
				
			case "Angler":
				with(obj_create(_x, _y, type)){
					with(self){
						event_perform(ev_step, ev_step_normal);
					}
				}
				break;
				
			case "CrystalHeart":
				with(obj_create(_x, _y - 16, type)){
					my_health = 0;
					with(self) event_perform(ev_destroy, 0);
				}
				break;
				
			 // Labs Event Exclusive:
			case "Pet":
				with(pet_data){
					var _petVars = pet_vars;
					with(mod_script_call("mod", "telib", "pet_create", _x, _y, pet_name, mod_type, mod_name)){
						var _lastIcon = spr_icon;
						for(var i = 0; i < lq_size(_petVars); i++){
							var k = lq_get_key(_petVars, i),
								o = lq_get(_petVars, k);
							
							 // Inherit:	
							variable_instance_set(id, k, o);
						}
						
						 // New Icon:
						var _newIcon = string(spr_icon);
						with(pickup_indicator){
							text = string_replace(text, string(_lastIcon), _newIcon);
						}
						
						 // Quality Assurance:
						team = 2;
					}
				}
				break;
		}
	}
	
	/*
	 // Open the Floodgates:
	with(instances_matching(object_index, "name", name)){
		if(self != other){
			alarm1 += random(10);
			
			 // Effects:
			repeat(8){
			instance_create(x + orandom(20), y + orandom(25), PortalL);
			}
		}
	}
	*/
	
	
/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  anim_end                                                                                image_index + image_speed_raw >= image_number
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
#macro  player_active                                                                           visible && !instance_exists(GenCont) && !instance_exists(LevCont) && !instance_exists(SitDown) && !instance_exists(PlayerSit)
#macro  game_scale_nonsync                                                                      game_screen_get_width_nonsync() / game_width
#macro  bbox_width                                                                              (bbox_right + 1) - bbox_left
#macro  bbox_height                                                                             (bbox_bottom + 1) - bbox_top
#macro  bbox_center_x                                                                           (bbox_left + bbox_right + 1) / 2
#macro  bbox_center_y                                                                           (bbox_top + bbox_bottom + 1) / 2
#macro  FloorNormal                                                                             instances_matching(Floor, 'object_index', Floor)
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define pfloor(_num, _precision)                                                        return  floor(_num / _precision) * _precision;
#define in_range(_num, _lower, _upper)                                                  return  (_num >= _lower && _num <= _upper);
#define frame_active(_interval)                                                         return  (current_frame % _interval) < current_time_scale;
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define save_get(_name, _default)                                                       return  mod_script_call_nc('mod', 'teassets', 'save_get', _name, _default);
#define save_set(_name, _value)                                                                 mod_script_call_nc('mod', 'teassets', 'save_set', _name, _value);
#define option_get(_name)                                                               return  mod_script_call_nc('mod', 'teassets', 'option_get', _name);
#define option_set(_name, _value)                                                               mod_script_call_nc('mod', 'teassets', 'option_set', _name, _value);
#define stat_get(_name)                                                                 return  mod_script_call_nc('mod', 'teassets', 'stat_get', _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc('mod', 'teassets', 'stat_set', _name, _value);
#define unlock_get(_name)                                                               return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _name);
#define unlock_set(_name, _value)                                                       return  mod_script_call_nc('mod', 'teassets', 'unlock_set', _name, _value);
#define surface_setup(_name, _w, _h, _scale)                                            return  mod_script_call_nc('mod', 'teassets', 'surface_setup', _name, _w, _h, _scale);
#define shader_setup(_name, _texture, _args)                                            return  mod_script_call_nc('mod', 'teassets', 'shader_setup', _name, _texture, _args);
#define shader_add(_name, _vertex, _fragment)                                           return  mod_script_call_nc('mod', 'teassets', 'shader_add', _name, _vertex, _fragment);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define top_create(_x, _y, _obj, _spawnDir, _spawnDis)                                  return  mod_script_call_nc('mod', 'telib', 'top_create', _x, _y, _obj, _spawnDir, _spawnDis);
#define trace_error(_error)                                                                     mod_script_call_nc('mod', 'telib', 'trace_error', _error);
#define view_shift(_index, _dir, _pan)                                                          mod_script_call_nc('mod', 'telib', 'view_shift', _index, _dir, _pan);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc('mod', 'telib', 'sleep_max', _milliseconds);
#define in_distance(_inst, _dis)                                                        return  mod_script_call(   'mod', 'telib', 'in_distance', _inst, _dis);
#define in_sight(_inst)                                                                 return  mod_script_call(   'mod', 'telib', 'in_sight', _inst);
#define instance_budge(_objAvoid, _disMax)                                              return  mod_script_call(   'mod', 'telib', 'instance_budge', _objAvoid, _disMax);
#define instance_random(_obj)                                                           return  mod_script_call_nc('mod', 'telib', 'instance_random', _obj);
#define instance_clone()                                                                return  mod_script_call(   'mod', 'telib', 'instance_clone');
#define instance_create_copy(_x, _y, _obj)                                              return  mod_script_call(   'mod', 'telib', 'instance_create_copy', _x, _y, _obj);
#define instance_create_lq(_x, _y, _lq)                                                 return  mod_script_call_nc('mod', 'telib', 'instance_create_lq', _x, _y, _lq);
#define instance_nearest_array(_x, _y, _inst)                                           return  mod_script_call_nc('mod', 'telib', 'instance_nearest_array', _x, _y, _inst);
#define instance_nearest_bbox(_x, _y, _inst)                                            return  mod_script_call_nc('mod', 'telib', 'instance_nearest_bbox', _x, _y, _inst);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc('mod', 'telib', 'instance_rectangle', _x1, _y1, _x2, _y2, _obj);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call_nc('mod', 'telib', 'instance_rectangle_bbox', _x1, _y1, _x2, _y2, _obj);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call_nc('mod', 'telib', 'instances_at', _x, _y, _obj);
#define instances_seen_nonsync(_obj, _bx, _by)                                          return  mod_script_call_nc('mod', 'telib', 'instances_seen_nonsync', _obj, _bx, _by);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   'mod', 'telib', 'instances_meeting', _x, _y, _obj);
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call_nc('mod', 'telib', 'draw_weapon', _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call_nc('mod', 'telib', 'draw_lasersight', _x, _y, _dir, _maxDistance, _width);
#define draw_surface_scale(_surf, _x, _y, _scale)                                               mod_script_call_nc('mod', 'telib', 'draw_surface_scale', _surf, _x, _y, _scale);
#define array_exists(_array, _value)                                                    return  mod_script_call_nc('mod', 'telib', 'array_exists', _array, _value);
#define array_count(_array, _value)                                                     return  mod_script_call_nc('mod', 'telib', 'array_count', _array, _value);
#define array_combine(_array1, _array2)                                                 return  mod_script_call_nc('mod', 'telib', 'array_combine', _array1, _array2);
#define array_delete(_array, _index)                                                    return  mod_script_call_nc('mod', 'telib', 'array_delete', _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call_nc('mod', 'telib', 'array_delete_value', _array, _value);
#define array_flip(_array)                                                              return  mod_script_call_nc('mod', 'telib', 'array_flip', _array);
#define array_shuffle(_array)                                                           return  mod_script_call_nc('mod', 'telib', 'array_shuffle', _array);
#define array_clone_deep(_array)                                                        return  mod_script_call_nc('mod', 'telib', 'array_clone_deep', _array);
#define lq_clone_deep(_obj)                                                             return  mod_script_call_nc('mod', 'telib', 'lq_clone_deep', _obj);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc('mod', 'telib', 'scrFX', _x, _y, _motion, _obj);
#define scrRight(_dir)                                                                          mod_script_call(   'mod', 'telib', 'scrRight', _dir);
#define scrWalk(_dir, _walk)                                                                    mod_script_call(   'mod', 'telib', 'scrWalk', _dir, _walk);
#define scrAim(_dir)                                                                            mod_script_call(   'mod', 'telib', 'scrAim', _dir);
#define enemy_walk(_spdAdd, _spdMax)                                                            mod_script_call(   'mod', 'telib', 'enemy_walk', _spdAdd, _spdMax);
#define enemy_hurt(_hitdmg, _hitvel, _hitdir)                                                   mod_script_call(   'mod', 'telib', 'enemy_hurt', _hitdmg, _hitvel, _hitdir);
#define enemy_shoot(_object, _dir, _spd)                                                return  mod_script_call(   'mod', 'telib', 'enemy_shoot', _object, _dir, _spd);
#define enemy_shoot_ext(_x, _y, _object, _dir, _spd)                                    return  mod_script_call(   'mod', 'telib', 'enemy_shoot_ext', _x, _y, _object, _dir, _spd);
#define enemy_target(_x, _y)                                                            return  mod_script_call(   'mod', 'telib', 'enemy_target', _x, _y);
#define boss_hp(_hp)                                                                    return  mod_script_call_nc('mod', 'telib', 'boss_hp', _hp);
#define boss_intro(_name, _sound, _music)                                               return  mod_script_call_nc('mod', 'telib', 'boss_intro', _name, _sound, _music);
#define corpse_drop(_dir, _spd)                                                         return  mod_script_call(   'mod', 'telib', 'corpse_drop', _dir, _spd);
#define rad_drop(_x, _y, _raddrop, _dir, _spd)                                          return  mod_script_call_nc('mod', 'telib', 'rad_drop', _x, _y, _raddrop, _dir, _spd);
#define rad_path(_inst, _target)                                                        return  mod_script_call_nc('mod', 'telib', 'rad_path', _inst, _target);
#define area_get_name(_area, _subarea, _loop)                                           return  mod_script_call_nc('mod', 'telib', 'area_get_name', _area, _subarea, _loop);
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call(   'mod', 'telib', 'area_get_sprite', _area, _spr);
#define area_get_subarea(_area)                                                         return  mod_script_call_nc('mod', 'telib', 'area_get_subarea', _area);
#define area_get_secret(_area)                                                          return  mod_script_call_nc('mod', 'telib', 'area_get_secret', _area);
#define area_get_underwater(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_underwater', _area);
#define area_border(_y, _area, _color)                                                  return  mod_script_call_nc('mod', 'telib', 'area_border', _y, _area, _color);
#define area_generate(_area, _subarea, _x, _y, _setArea, _overlapFloor, _scrSetup)      return  mod_script_call_nc('mod', 'telib', 'area_generate', _area, _subarea, _x, _y, _setArea, _overlapFloor, _scrSetup);
#define floor_get(_x, _y)                                                               return  mod_script_call_nc('mod', 'telib', 'floor_get', _x, _y);
#define floor_set(_x, _y, _state)                                                       return  mod_script_call_nc('mod', 'telib', 'floor_set', _x, _y, _state);
#define floor_set_style(_style, _area)                                                  return  mod_script_call_nc('mod', 'telib', 'floor_set_style', _style, _area);
#define floor_set_align(_alignW, _alignH, _alignX, _alignY)                             return  mod_script_call_nc('mod', 'telib', 'floor_set_align', _alignW, _alignH, _alignX, _alignY);
#define floor_reset_style()                                                             return  mod_script_call_nc('mod', 'telib', 'floor_reset_style');
#define floor_reset_align()                                                             return  mod_script_call_nc('mod', 'telib', 'floor_reset_align');
#define floor_make(_x, _y, _obj)                                                        return  mod_script_call_nc('mod', 'telib', 'floor_make', _x, _y, _obj);
#define floor_fill(_x, _y, _w, _h, _type)                                               return  mod_script_call_nc('mod', 'telib', 'floor_fill', _x, _y, _w, _h, _type);
#define floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)                      return  mod_script_call_nc('mod', 'telib', 'floor_room_start', _spawnX, _spawnY, _spawnDis, _spawnFloor);
#define floor_room_create(_x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis)         return  mod_script_call_nc('mod', 'telib', 'floor_room_create', _x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis);
#define floor_room(_spaX, _spaY, _spaDis, _spaFloor, _w, _h, _type, _dirOff, _floorDis) return  mod_script_call_nc('mod', 'telib', 'floor_room', _spaX, _spaY, _spaDis, _spaFloor, _w, _h, _type, _dirOff, _floorDis);
#define floor_reveal(_floors, _maxTime)                                                 return  mod_script_call_nc('mod', 'telib', 'floor_reveal', _floors, _maxTime);
#define floor_tunnel(_x1, _y1, _x2, _y2)                                                return  mod_script_call_nc('mod', 'telib', 'floor_tunnel', _x1, _y1, _x2, _y2);
#define floor_bones(_num, _chance, _linked)                                             return  mod_script_call(   'mod', 'telib', 'floor_bones', _num, _chance, _linked);
#define floor_walls()                                                                   return  mod_script_call(   'mod', 'telib', 'floor_walls');
#define wall_tops()                                                                     return  mod_script_call(   'mod', 'telib', 'wall_tops');
#define wall_clear(_x1, _y1, _x2, _y2)                                                          mod_script_call_nc('mod', 'telib', 'wall_clear', _x1, _y1, _x2, _y2);
#define sound_play_ntte(_type, _snd)                                                    return  mod_script_call_nc('mod', 'telib', 'sound_play_ntte', _type, _snd);
#define sound_play_hit_ext(_snd, _pit, _vol)                                            return  mod_script_call(   'mod', 'telib', 'sound_play_hit_ext', _snd, _pit, _vol);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call(   'mod', 'telib', 'race_get_sprite', _race, _sprite);
#define race_get_title(_race)                                                           return  mod_script_call(   'mod', 'telib', 'race_get_title', _race);
#define player_create(_x, _y, _index)                                                   return  mod_script_call_nc('mod', 'telib', 'player_create', _x, _y, _index);
#define player_swap()                                                                   return  mod_script_call(   'mod', 'telib', 'player_swap');
#define wep_get(_wep)                                                                   return  mod_script_call_nc('mod', 'telib', 'wep_get', _wep);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc('mod', 'telib', 'wep_merge', _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call_nc('mod', 'telib', 'wep_merge_decide', _hardMin, _hardMax);
#define weapon_decide(_hardMin, _hardMax, _gold, _noWep)                                return  mod_script_call(   'mod', 'telib', 'weapon_decide', _hardMin, _hardMax, _gold, _noWep);
#define skill_get_icon(_skill)                                                          return  mod_script_call(   'mod', 'telib', 'skill_get_icon', _skill);
#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)                        return  mod_script_call_nc('mod', 'telib', 'path_create', _xstart, _ystart, _xtarget, _ytarget, _wall);
#define path_shrink(_path, _wall, _skipMax)                                             return  mod_script_call_nc('mod', 'telib', 'path_shrink', _path, _wall, _skipMax);
#define path_reaches(_path, _xtarget, _ytarget, _wall)                                  return  mod_script_call_nc('mod', 'telib', 'path_reaches', _path, _xtarget, _ytarget, _wall);
#define path_direction(_path, _x, _y, _wall)                                            return  mod_script_call_nc('mod', 'telib', 'path_direction', _path, _x, _y, _wall);
#define path_draw(_path)                                                                return  mod_script_call(   'mod', 'telib', 'path_draw', _path);
#define portal_poof()                                                                   return  mod_script_call_nc('mod', 'telib', 'portal_poof');
#define portal_pickups()                                                                return  mod_script_call_nc('mod', 'telib', 'portal_pickups');
#define pet_spawn(_x, _y, _name)                                                        return  mod_script_call_nc('mod', 'telib', 'pet_spawn', _x, _y, _name);
#define pet_get_icon(_modType, _modName, _name)                                         return  mod_script_call(   'mod', 'telib', 'pet_get_icon', _modType, _modName, _name);
#define team_get_sprite(_team, _sprite)                                                 return  mod_script_call_nc('mod', 'telib', 'team_get_sprite', _team, _sprite);
#define team_instance_sprite(_team, _inst)                                              return  mod_script_call_nc('mod', 'telib', 'team_instance_sprite', _team, _inst);
#define sprite_get_team(_sprite)                                                        return  mod_script_call_nc('mod', 'telib', 'sprite_get_team', _sprite);
#define scrPickupIndicator(_text)                                                       return  mod_script_call(   'mod', 'telib', 'scrPickupIndicator', _text);
#define scrAlert(_inst, _sprite)                                                        return  mod_script_call(   'mod', 'telib', 'scrAlert', _inst, _sprite);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   'mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_instance, _charm)                                               return  mod_script_call_nc('mod', 'telib', 'charm_instance', _instance, _charm);
#define door_create(_x, _y, _dir)                                                       return  mod_script_call_nc('mod', 'telib', 'door_create', _x, _y, _dir);