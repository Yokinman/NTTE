/// Copy-paste and rename this file when you're adding a new area mod

/*  Rules                                                                                           *\
 - All code under a #define should be indented one extra so that it stands out
 - Try to keep all #defines in the order of how this template file has them
 - If you aren't using an event, such as area_begin_step, then remove it
 - If you need to add a script that doesn't follow the '#define area_' naming:
	 Place it between the general area code section and scripts section
	 Add a '/// Misc' (or whatever you want to call it) comment before that section, like with the scripts section
	 Double space the area between that section and the scripts and general area code sections

Example Code (Ignore extra space before #define here):
 #define area_step
	script_bind_draw(draw_sea, 0);

 #define area_pop_enemies
	obj_create(_x, _y, "TrafficCrab");
 
 #define area_pop_props
	instance_create(_x, _y, Cactus);


/// Misc
 #define draw_sea
	instance_destroy();
	draw_sprite(sprSea, 0, 0, 0);


/// Scripts
blah blah blah

\*  ^^ Delete this line and all above after copy-pasting ^^                                         */
#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	
	DebugLag = false;
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#macro DebugLag global.debug_lag

#define area_subarea           return 3;
#define area_goal              return 110;
#define area_next              return [2, 1]; // SEWERS
#define area_music             return mus1;
#define area_ambience          return amb1;
#define area_background_color  return make_color_rgb(175, 143, 106);
#define area_shadow_color      return c_black;
#define area_darkness          return false;
#define area_secret            return false;

#define area_name(_subarea, _loop)
	return "1-" + string(_subarea);
	
#define area_text
	return choose("tip1", "tip2", "tip3");
	
#define area_mapdata(_lastx, _lasty, _lastarea, _lastsubarea, _subarea, _loops)
	return [
		0,
		0,
		true,
		true
	];
	
#define area_sprite(_spr)
	switch(_spr){
		 // Floors:
		case sprFloor1      : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return sprFloor1;
		case sprFloor1B     : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return sprFloor1B;
		case sprFloor1Explo : return sprFloor1Explo;
		case sprDetail1     : return sprDetail1;
		
		 // Walls:
		case sprWall1Bot    : return sprWall1Bot;
		case sprWall1Top    : return sprWall1Top;
		case sprWall1Out    : return sprWall1Out;
		case sprWall1Trans  : return sprWall1Trans;
		case sprDebris1     : return sprDebris1;
		
		 // Decals:
		case sprTopPot      : return -1;
		case sprBones       : return -1;
	}
	
#define area_setup
	goal             = area_goal();
	background_color = area_background_color();
	BackCont.shadcol = area_shadow_color();
	TopCont.darkness = area_darkness();
	
#define area_setup_floor
	 // Fix Depth:
	if(styleb) depth = 8;
	
	 // Footsteps:
	material = (styleb ? 4 : 1);
	
#define area_start
	
	
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
	
#define area_step
	if(DebugLag) trace_time();
	if(DebugLag) trace_time("template_area_step");

#define area_begin_step
	if(DebugLag) trace_time();
	if(DebugLag) trace_time("template_area_begin_step");

#define area_end_step
	if(DebugLag) trace_time();
	if(DebugLag) trace_time("template_area_end_step");

#define area_effect(_vx, _vy)
	var	_x = _vx + random(game_width),
		_y = _vy + random(game_height);
		
	 // Wind:
	var f = instance_nearest(_x, _y, Floor);
	with(f){
		instance_create(x + random(32), y + random(32), Wind);
	}
	
	return random(60);
	
#define area_make_floor
	var	_x = x,
		_y = y,
		_outOfSpawn = (point_distance(_x, _y, 10000, 10000) > 48);
		
	/// Make Floors:
		 // Special - 2x2 Fill:
		if(chance(1, 2)){
			floor_fill(_x + 16, _y + 16, 2, 2, "");
		}
		
		 // Normal:
		else instance_create(_x, _y, Floor);
		
	/// Turn:
		var _trn = 0;
		if(chance(5, 14)){
			_trn = choose(90, 90, -90, -90, 180);
		}
		direction += _trn;
		
	/// Chests & Branching:
		 // Weapon Chests:
		if(_outOfSpawn && _trn == 180){
			floor_make(_x, _y, WeaponChest);
		}
		
		 // Ammo Chests + End Branch:
		var n = instance_number(FloorMaker);
		if(!chance(20, 19 + n)){
			if(_outOfSpawn) floor_make(_x, _y, AmmoChest);
			instance_destroy();
		}
		
		 // Branch:
		if(chance(1, 8)){
			instance_create(_x, _y, FloorMaker);
		}
		
#define area_pop_enemies
	var	_x = x + 16,
		_y = y + 16;
		
	instance_create(_x, _y, choose(Bandit, Maggot));
	
#define area_pop_props
	var	_x = x + 16,
		_y = y + 16,
		_spawnDis = point_distance(_x, _y, 10016, 10016);
		
	if(_spawnDis > 48 && chance(1, 12)){
		if(chance(1, 60)){
			instance_create(_x, _y, BigSkull);
		}
		else instance_create(_x, _y, Cactus);
	}
	
#define area_pop_extras
	with(chestprop){
		instance_create(x, y, Bandit);
	}
	
	
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