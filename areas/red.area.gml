#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	lag = false;
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#macro area_active (!instance_exists(GenCont) && !instance_exists(LevCont) && ((GameCont.area == area_vault) ? GameCont.lastarea : GameCont.area) == mod_current && GameCont.subarea > 0)
#macro area_visits variable_instance_get(GameCont, "visited_" + mod_current, 0)

#macro isWallFake ("name" in self && name == "WallFake")

#define area_subarea           return 1;
#define area_goal              return 60;
#define area_next              return mod_current; // CAN'T LEAVE
#define area_music             return mus.Red;
#define area_ambient           return amb104;
#define area_background_color  return make_color_rgb(235, 0, 67);
#define area_shadow_color      return make_color_rgb(16, 0, 24);
#define area_darkness          return false;
#define area_secret            return true;

#define area_name(_subarea, _loop)
	return `@(color:${area_background_color()})???`;
	
#define area_text
	return choose("BLINDING", "THE RED DOT", `WELCOME TO THE @(color:${area_background_color()})WARP ZONE`);
	
#define area_mapdata(_lastx, _lasty, _lastarea, _lastsubarea, _subarea, _loops)
	return [_lastx, 9, (_subarea == 1)];
	
#define area_sprite(_spr)
	switch(_spr){
		 // Floors:
		case sprFloor1      : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return spr.FloorRed;
		case sprFloor1B     : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return spr.FloorRedB;
		case sprFloor1Explo : return spr.FloorRedExplo;
		case sprDetail1     : return spr.DetailRed;
		
		 // Walls:
		case sprWall1Bot    : return spr.WallRedBot;
		case sprWall1Top    : return spr.WallRedTop;
		case sprWall1Out    : return spr.WallRedOut;
		case sprWall1Trans  : return spr.WallRedTrans;
		case sprDebris1     : return spr.DebrisRed;
		
		 // Decals:
		case sprBones       : return spr.WallDecalRed;
	}
	
#define area_setup
	goal             = area_goal();
	background_color = area_background_color();
	BackCont.shadcol = area_shadow_color();
	TopCont.darkness = area_darkness();
	
	 // Skin Time:
	if(variable_instance_get(GenCont, "iswarpzone", false)){
		unlock_set("skin:red crystal", true);
	}
	
	 // Remember:
	variable_instance_set(GameCont, "visited_" + mod_current, area_visits + 1);
	
#define area_setup_floor
	 // Fix Depth:
	if(isWallFake) depth = 10;
	else if(styleb) depth = 8;
	
	 // Footsteps:
	material = 2;
	
#define area_start
	 // Delete SpawnWall:
	if(instance_exists(Wall)){
		with(Wall.id) if(place_meeting(x, y, Floor)){
			instance_destroy();
		}
	}
	
#define area_finish
	lastarea = area;
	lastsubarea = subarea;
	
	 // Area End:
	if(subarea >= area_subarea()){
		var n = area_next();
		if(!is_array(n)) n = [n];
		if(array_length(n) < 1) array_push(n, mod_current);
		if(array_length(n) < 2) array_push(n, 1);
		area = n[0];
		subarea = n[1];
	}
	
	 // Next Subarea: 
	else subarea++;
	
#define area_make_floor
	var	_x = x,
		_y = y,
		_outOfSpawn = (point_distance(_x, _y, 10000, 10000) > 48);
		
	 // Delete B-Floor (game sucks this game suk):
	if(styleb != 0){
		with(instances_matching(instances_matching(instances_matching(Floor, "xstart", xstart), "ystart", ystart), "styleb", styleb)){
			instance_destroy();
		}
		styleb = 0;
		instance_create(xstart, ystart, Floor);
	}
	
	/// Make Floors:
		 // Normal:
		instance_create(_x, _y, Floor);
		
		 // Special - Diamond:
		if(chance(1, 7)){
			floor_fill(_x + 16, _y + 16, 3, 3, "round");
		}
		
	/// Chests:
		if(_trn == 180 && _outOfSpawn){
			instance_create(_x + 16, _y + 16, choose(WeaponChest, AmmoChest));
		}
		
	/// Don't Move:
		if(!variable_instance_get(GenCont, "iswarpzone", true)){
			if("direction_start" not in self){
				direction_start = direction;
			}
			
			var _ox = lengthdir_x(32, direction),
				_oy = lengthdir_y(32, direction);
				
			if(abs(angle_difference(direction_start, point_direction(xstart, ystart, x + _ox, y + _oy))) > 60){
				x -= _ox;
				y -= _oy;
				direction = round(direction_start / 90) * 90;
			}
		}
		
	/// Turn:
		var _trn = 0;
		if(chance(3, 7)){
			_trn = choose(90, -90, 180);
		}
		direction += _trn;
		
#define area_pop_enemies
	var	_x = x + 16,
		_y = y + 16;
		
	 // Big:
	if(chance(1, 7)){
		obj_create(_x, _y, "CrystalBrain");
	}
	
	 // Small:
	else{
		if(chance(1, 7)){
			instance_create(_x, _y, Bandit);
		}
		else{
			obj_create(_x, _y, "RedSpider");
		}
	}
	
#define area_pop_props
	 // Lone Walls:
	if(
		chance(1, 5)
		&& point_distance(x, y, 10000, 10000) > 16
		&& !place_meeting(x, y, NOWALLSHEREPLEASE)
		&& !place_meeting(x, y, hitme)
	){
		instance_create(x + choose(0, 16), y + choose(0, 16), Wall);
		instance_create(x, y, NOWALLSHEREPLEASE);
	}
	
	 // Props:
	else if(chance(1, 4)){
		obj_create(x + 16, y + 16, "CrystalProp" + ((styleb && !isWallFake) ? "White" : "Red"));
	}
	
	 // Warp Rooms:
	if(variable_instance_get(GenCont, "iswarpzone", true) && styleb == 0){
		if(chance(1, 20) || array_length(instances_matching(CustomObject, "name", "Warp")) <= 0){
			var _w = 2,
				_h = 2,
				_type = "",
				_dirOff = 90,
				_floorDis = random_range(48, 96),
				_spawnX = 10016,
				_spawnY = 10016,
				_spawnDis = 64,
				_spawnFloor = instances_matching(FloorNormal, "styleb", 0),
				_floorHallwaySearch = FloorNormal;
				
			floor_set_align(null, null, 32, 32);
			floor_set_style(1, null);
			
			with(floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
				 // Hallway:
				with(instance_random(floors)){
					var	_x = bbox_center_x,
						_y = bbox_center_y,
						_moveDis = 32;
						
					while(
						point_distance(_x, _y, other.xstart, other.ystart) > _moveDis / 2
						&&
						(!position_meeting(_x, _y, Floor) || array_length(instances_at(_x, _y, _floorHallwaySearch)) <= 0)
					){
						 // Floor + Props:
						if(!position_meeting(_x, _y, Floor) || array_length(instances_at(_x, _y, FloorNormal)) <= 0){
							with(floor_set(_x - 16, _y - 16, true)){
								area_pop_props();
							}
						}
						
						 // Move:
						var _moveDir = round((point_direction(_x, _y, other.xstart, other.ystart) + orandom(60)) / 90) * 90;
						_x += lengthdir_x(_moveDis, _moveDir);
						_y += lengthdir_y(_moveDis, _moveDir);
					}
				}
				
				 // Epify:
				for(var i = 0; i < array_length(floors); i++){
					with(floors[i]){
						sprite_index = spr.FloorRedRoom;
						image_index  = i;
					}
				}
				
				 // Portal:
				with(obj_create(x, y - 8, "Warp")){
					
				}
			}
			
			floor_reset_align();
			floor_reset_style();
		}
	}
	
#define area_pop_extras
	 // Bone Decals:
	with(FloorNormal){
		if(chance(3, 4)){
			floor_bones(2, 1/8, false);
		}
	}
	
	 // Secrets Upon Secrets:
	if(variable_instance_get(GenCont, "iswarpzone", true)){
		var _floorArray = [];
		with(FloorNormal) if(array_length(instances_matching_lt(instances_matching(FloorNormal, "x", x), "y", y)) <= 0){
			array_push(_floorArray, id);
		}
		
		 // Highest Floor:
		var _floorTarget = instance_random(_floorArray);
		with(_floorTarget){
			var	_w = 3,
				_h = 3,
				_type = "",
				_dirOff = 60,
				_floorDis = random_range(80, 160),
				_dirStart = 90,
				_levelFloor = FloorNormal;
				
			floor_set_align(null, null, 32, 32);
			floor_set_style(1, null);
			
			with(floor_room_create(x, y, _w, _h, _type, _dirStart, _dirOff, _floorDis)){
				var	_minID = GameObject.id,
					_x = x + 16,
					_y = y + 16,
					_moveDis = 32;
					
				 // Create Hallway:
				with(instance_nearest_bbox(x + orandom(1), y + orandom(1), floors)){
					while(
						point_distance(_x, _y, _floorTarget.x, _floorTarget.y) > _moveDis / 2
						&&
						array_length(instance_rectangle_bbox(_x, _y, _x + 31, _y + 31, _levelFloor)) <= 0
					){
						 // Walls and Props:
						with(obj_create(_x, _y, "WallFake")){
							area_pop_props();
						}
						
						 // Move:
						var _moveDir = round((point_direction(_x, _y, _floorTarget.x, _floorTarget.y) + orandom(60)) / 90) * 90;
						_x += lengthdir_x(_moveDis, _moveDir);
						_y += lengthdir_y(_moveDis, _moveDir);
					}
				}
				
				 // Secrets Upon Secrets Upon Secres:
				with(instance_random(floors)){
					var v = y - 32;
					while(place_meeting(x, v, Floor)){
						v -= 32;
					}
					obj_create(x, v, "WallFake");
					with(obj_create(x, (v - 32), "WallFake")){
						 // Secret Chest:
						with(chest_create(x + 16, y + 16, "Backpack")){
						
						}
					}
				}
				
				 // Hidden:
				with(instances_matching_gt(Wall, "id", _minID)){
					topindex = 0;
				}
				with(instances_matching_gt(TopSmall, "id", _minID)){
					image_index = 0;
				}
			}
			
			floor_reset_align();
			floor_reset_style();
		}
	}
	
#define area_effect(_vx, _vy)
	 // Cool Particles:
	var _floor = instances_matching(Floor, "sprite_index", spr.FloorRed);
	with(instance_random(instance_rectangle_bbox(_vx, _vy, _vx + game_height, _vy + game_width, _floor))){
		with(instance_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), LaserCharge)){
			depth = -8;
			alarm0 = 40 + random(40);
			motion_set(random(360), random(0.2));
		}
	}
	
	return irandom(40);
	
	
/// SCRIPTS
#macro  area_campfire                                                                           0
#macro  area_desert                                                                             1
#macro  area_sewers                                                                             2
#macro  area_scrapyards                                                                         3
#macro  area_caves                                                                              4
#macro  area_city                                                                               5
#macro  area_labs                                                                               6
#macro  area_palace                                                                             7
#macro  area_vault                                                                              100
#macro  area_oasis                                                                              101
#macro  area_pizza_sewers                                                                       102
#macro  area_mansion                                                                            103
#macro  area_cursed_caves                                                                       104
#macro  area_jungle                                                                             105
#macro  area_hq                                                                                 106
#macro  area_crib                                                                               107
#macro  infinity                                                                                1/0
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
#define chest_create(_x, _y, _obj)                                                      return  mod_script_call_nc('mod', 'telib', 'chest_create', _x, _y, _obj);
#define trace_error(_error)                                                                     mod_script_call_nc('mod', 'telib', 'trace_error', _error);
#define view_shift(_index, _dir, _pan)                                                          mod_script_call_nc('mod', 'telib', 'view_shift', _index, _dir, _pan);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc('mod', 'telib', 'sleep_max', _milliseconds);
#define instance_seen(_x, _y, _obj)                                                     return  mod_script_call_nc('mod', 'telib', 'instance_seen', _x, _y, _obj);
#define instance_near(_x, _y, _obj, _dis)                                               return  mod_script_call_nc('mod', 'telib', 'instance_near', _x, _y, _obj, _dis);
#define instance_budge(_objAvoid, _disMax)                                              return  mod_script_call(   'mod', 'telib', 'instance_budge', _objAvoid, _disMax);
#define instance_random(_obj)                                                           return  mod_script_call_nc('mod', 'telib', 'instance_random', _obj);
#define instance_clone()                                                                return  mod_script_call(   'mod', 'telib', 'instance_clone');
#define instance_nearest_array(_x, _y, _inst)                                           return  mod_script_call_nc('mod', 'telib', 'instance_nearest_array', _x, _y, _inst);
#define instance_nearest_bbox(_x, _y, _inst)                                            return  mod_script_call_nc('mod', 'telib', 'instance_nearest_bbox', _x, _y, _inst);
#define instance_nearest_rectangle(_x1, _y1, _x2, _y2, _inst)                           return  mod_script_call_nc('mod', 'telib', 'instance_nearest_rectangle', _x1, _y1, _x2, _y2, _inst);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc('mod', 'telib', 'instance_rectangle', _x1, _y1, _x2, _y2, _obj);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call_nc('mod', 'telib', 'instance_rectangle_bbox', _x1, _y1, _x2, _y2, _obj);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call_nc('mod', 'telib', 'instances_at', _x, _y, _obj);
#define instances_seen_nonsync(_obj, _bx, _by)                                          return  mod_script_call_nc('mod', 'telib', 'instances_seen_nonsync', _obj, _bx, _by);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   'mod', 'telib', 'instances_meeting', _x, _y, _obj);
#define variable_instance_get_list(_inst)                                               return  mod_script_call_nc('mod', 'telib', 'variable_instance_get_list', _inst);
#define variable_instance_set_list(_inst, _list)                                                mod_script_call_nc('mod', 'telib', 'variable_instance_set_list', _inst, _list);
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
#define boss_intro(_name)                                                               return  mod_script_call_nc('mod', 'telib', 'boss_intro', _name);
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
#define floor_set_align(_alignX, _alignY, _alignW, _alignH)                             return  mod_script_call_nc('mod', 'telib', 'floor_set_align', _alignX, _alignY, _alignW, _alignH);
#define floor_reset_style()                                                             return  mod_script_call_nc('mod', 'telib', 'floor_reset_style');
#define floor_reset_align()                                                             return  mod_script_call_nc('mod', 'telib', 'floor_reset_align');
#define floor_fill(_x, _y, _w, _h, _type)                                               return  mod_script_call_nc('mod', 'telib', 'floor_fill', _x, _y, _w, _h, _type);
#define floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)                      return  mod_script_call_nc('mod', 'telib', 'floor_room_start', _spawnX, _spawnY, _spawnDis, _spawnFloor);
#define floor_room_create(_x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis)         return  mod_script_call_nc('mod', 'telib', 'floor_room_create', _x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis);
#define floor_room(_spaX, _spaY, _spaDis, _spaFloor, _w, _h, _type, _dirOff, _floorDis) return  mod_script_call_nc('mod', 'telib', 'floor_room', _spaX, _spaY, _spaDis, _spaFloor, _w, _h, _type, _dirOff, _floorDis);
#define floor_reveal(_x1, _y1, _x2, _y2, _time)                                         return  mod_script_call_nc('mod', 'telib', 'floor_reveal', _x1, _y1, _x2, _y2, _time);
#define floor_tunnel(_x1, _y1, _x2, _y2)                                                return  mod_script_call_nc('mod', 'telib', 'floor_tunnel', _x1, _y1, _x2, _y2);
#define floor_bones(_num, _chance, _linked)                                             return  mod_script_call(   'mod', 'telib', 'floor_bones', _num, _chance, _linked);
#define floor_walls()                                                                   return  mod_script_call(   'mod', 'telib', 'floor_walls');
#define wall_tops()                                                                     return  mod_script_call(   'mod', 'telib', 'wall_tops');
#define wall_clear(_x1, _y1, _x2, _y2)                                                          mod_script_call_nc('mod', 'telib', 'wall_clear', _x1, _y1, _x2, _y2);
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
#define pool(_pool)                                                                     return  mod_script_call_nc('mod', 'telib', 'pool', _pool);