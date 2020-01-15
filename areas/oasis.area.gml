#define init
    spr = mod_variable_get("mod", "teassets", "spr");
    snd = mod_variable_get("mod", "teassets", "snd");
    mus = mod_variable_get("mod", "teassets", "mus");
    sav = mod_variable_get("mod", "teassets", "sav");

	DebugLag = false;

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

#define area_subarea			return 1;
#define area_next				return [3, 3];
#define area_music				return mus101;
#define area_ambience			return amb101;
#define area_background_color	return area_get_background_color(101);
#define area_shadow_color		return area_get_shadow_color(101);
#define area_darkness			return false;
#define area_secret				return true;
#define area_underwater			return true;

#define area_name(_subarea, _loop)
    return "@1(sprInterfaceIcons)2-" + string(_subarea);

#define area_text
	return choose("DON'T MOVE", "IT'S BEAUTIFUL DOWN HERE", "HOLD YOUR BREATH", "FISH", "RIPPLING SKY", "IT'S SO QUIET", "THERE'S SOMETHING IN THE WATER");

#define area_mapdata(_lastx, _lasty, _lastarea, _lastsubarea, _subarea, _loops)
    return [
    	44,
    	-9,
    	(_subarea == 1)
    ];

#define area_sprite(_spr)
    switch(_spr){
         // Floors:
        case sprFloor1      : if(instance_is(other, Floor)){ with(other) area_setup_floor(); } return sprFloor101;
        case sprFloor1B     : if(instance_is(other, Floor)){ with(other) area_setup_floor(); } return sprFloor101B;
        case sprFloor1Explo : return sprFloor101Explo;
        
         // Walls:
        case sprWall1Trans  : return sprWall101Trans;
        case sprWall1Bot    : return sprWall101Bot;
        case sprWall1Out    : return sprWall101Out;
        case sprWall1Top    : return sprWall101Top;
        
         // Misc:
        case sprDebris1     : return sprDebris101;
        case sprDetail1     : return sprDetail101;
    }
    
#define area_setup
    goal = 130;
    
    background_color = area_background_color();
    BackCont.shadcol = area_shadow_color();
    TopCont.darkness = area_darkness();
    
#define area_setup_floor
     // Fix Depth:
    if(styleb) depth = 8;
    
     // Footsteps:
    material = (styleb ? 4 : 1);
    
#define area_start
     // Anglers:
    with(RadChest) if(chance(1, 40)){
        obj_create(x, y, "Angler");
        instance_delete(id);
    }
    
     // Secret:
	if(variable_instance_get(GameCont, "sunkenchests", 0) <= GameCont.loops){
		with(instance_random(TopSmall)){
			with(top_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), "SunkenChest", -1, -1)){
				with(instance_create(x, y - 8, LightBeam)){
					x = xstart;
					y = ystart;
				}
				with(instances_meeting(x, y, TopSmall)){
					sprite_index = sprWall101Top;
				}
			}
		}
	}

	 // Bab Skull:
    if(GameCont.subarea == 1 && instance_exists(Floor) && instance_exists(Player)){
	    var _spawnFloor = [];
		with(Floor){
			var _x = (bbox_left + bbox_right + 1) / 2,
				_y = (bbox_top + bbox_bottom + 1) / 2;

			if(point_distance(_x, _y, 10016, 10016) > 48){
				if(array_length(instances_meeting(x, y, [prop, chestprop, Wall])) <= 0){
					array_push(_spawnFloor, id);
				}
			}
		}

		with(instance_random(_spawnFloor)){
        	obj_create((bbox_left + bbox_right + 1) / 2, (bbox_top + bbox_bottom + 1) / 2, "OasisPetBecome");
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

#define area_step
	if(DebugLag) trace_time();

     // Spawn cool crack effect:
    if(instance_exists(Portal)){
        var _crack = instances_matching(CustomObject, "name", "Crack");
        if(array_length(_crack) <= 0){
            with(instance_nearest_array(10000, 10000, instances_matching_ne(Floor, "object_index", FloorExplo))){
                obj_create(x + 16, y + 16, "Crack");
            }
        }
    }

	if(DebugLag) trace_time("oasis_area_step");

#define area_effect(_vx, _vy)
    var _x = _vx + random(game_width),
        _y = _vy + random(game_height);

     // Player Bubbles:
    if(chance(1, 4)){
        with(Player) instance_create(x, y, Bubble);
    }
    
     // Pet Bubbles:
    if(chance(1, 4)){
        with(instances_matching(CustomHitme, "name", "Pet")) instance_create(x, y, Bubble);
    }

     // Floor Bubbles:
    else{
        var f = instance_nearest(_x, _y, Floor);
        with(f) instance_create(x + random(32), y + random(32), Bubble);
    }

    return 30 + random(20);

#define area_make_floor
    var _x = x,
        _y = y,
        _outOfSpawn = (point_distance(_x, _y, GenCont.spawn_x, GenCont.spawn_y) > 48);

    /// Make Floors:
         // Normal:
    	instance_create(_x, _y, Floor);
    	
    	 // Special - Diamond:
    	if(chance(1, 3)){
    		floor_fill_round(_x, _y, 3, 3);
    	}

	/// Turn:
        var _trn = 0;
        if(chance(1, 4)){
    	    _trn = choose(90, 90, -90, -90, 180);
        }
        direction += _trn;

    /// Chests & Branching:
         // Turn Arounds (Weapon Chests):
        if(_trn == 180 && _outOfSpawn){
            floor_make(_x, _y, WeaponChest);
        }

         // Dead Ends (Ammo Chests):
        var n = instance_number(FloorMaker);
    	if(!chance(20, 19 + n)){
    		if(_outOfSpawn) floor_make(_x, _y, AmmoChest);
    		instance_destroy();
    	}

    	 // Branch:
    	if(chance(1, 5)) instance_create(_x, _y, FloorMaker);

#define area_pop_enemies
    var _x = x + 16,
        _y = y + 16;

    if(chance(1, 2)){
        var _top = chance(1, 2);
        
         // Shoals:
        if(chance(1, 2)){
            if(!styleb && chance(3, 4)){
                if(GameCont.loops > 0 && chance(1, 2)){
                    repeat(irandom_range(1, 4)){
                    	obj_create(_x, _y, Freak);
                    }
                }
                repeat(irandom_range(1, 4)){
                	obj_create(_x, _y, BoneFish);
                }
            }
            else repeat(irandom_range(1, 4)){
            	obj_create(_x, _y, "Puffer");
            }
        }

        else{
            if(GameCont.loops > 0 && chance(1, 3)){
                instance_create(_x, _y, choose(Necromancer, Ratking));
            }
            else{
                if(chance(1, 5)) obj_create(_x, _y, "Diver");
                else{
                    if(!styleb){
                        if(chance(1, 2)) instance_create(_x, _y, Crab);
                    }
                    else{
                    	obj_create(_x, _y, "Hammerhead");
                    }
                }
            }
        }
    }

#define area_pop_props
     // Coral Wall Decal:
    if(!place_free(x - 32, y) && !place_free(x + 32, y)){
        for(var _x = -1; _x <= 1; _x += 2){
            for(var _y = 0; _y <= 1; _y++){
                if(chance(1, 10)){
                    with(instance_create(x + ((1 - _x) * 16), y + (16 * _y), Bones)){
                        image_xscale = _x;
                        sprite_index = sprCoral;
                    }
                }
            }
        }
    }
    with(Bones) if(!place_meeting(x, y, Wall)){
        instance_destroy();
    }

     // Quarter Walls:
    if(chance(1, 14)){
        if(point_distance(x, y, 10016, 10016) > 100 && !place_meeting(x, y, NOWALLSHEREPLEASE)){
            var _x = x + choose(0, 16),
                _y = y + choose(0, 16);

            if(!place_meeting(_x, _y, hitme)){
                instance_create(_x, _y, Wall);
                instance_create(x, y, NOWALLSHEREPLEASE);
            }
        }
    }

     // Prop Spawns:
    else if(chance(1, 10)){
        var _x = x + 16 + orandom(2),
            _y = y + 16 + orandom(2),
        	_outOfSpawn = (point_distance(_x, _y, GenCont.spawn_x, GenCont.spawn_y) > 48);

		if(_outOfSpawn){
			if(chance(1, 30) && !place_meeting(x - 32, y, Wall) && !place_meeting(x + 32, y, Wall)){
				instance_create(_x, _y, Anchor);
			}
			else{
				with(instance_create(_x, _y, choose(LightBeam, WaterPlant, choose(WaterMine, WaterMine, OasisBarrel)))){
					if(object_index == WaterMine && place_meeting(x, y - 32, Wall)){
						if(!place_meeting(x, y + 32, Wall)){
							y += 32;
							yprevious = y;
						}
						depth = -1;
					}
				}
			}
		}
    }

#define area_pop_extras
     // The new bandits
    with(instances_matching([WeaponChest, AmmoChest, RadChest], "", null)){
        obj_create(x, y, "Diver");
    }


/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  anim_end                                                                                image_index + image_speed_raw >= image_number
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define in_range(_num, _lower, _upper)                                                  return  (_num >= _lower && _num <= _upper);
#define frame_active(_interval)                                                         return  (current_frame % _interval) < current_time_scale;
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define surflist_set(_name, _x, _y, _width, _height)                                    return  mod_script_call_nc('mod', 'teassets', 'surflist_set', _name, _x, _y, _width, _height);
#define surflist_get(_name)                                                             return  mod_script_call_nc('mod', 'teassets', 'surflist_get', _name);
#define shadlist_set(_name, _vertex, _fragment)                                         return  mod_script_call_nc('mod', 'teassets', 'shadlist_set', _name, _vertex, _fragment);
#define shadlist_get(_name)                                                             return  mod_script_call_nc('mod', 'teassets', 'shadlist_get', _name);
#define shadlist_setup(_shader, _texture, _args)                                        return  mod_script_call_nc('mod', 'telib', 'shadlist_setup', _shader, _texture, _args);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define top_create(_x, _y, _obj, _spawnDir, _spawnDis)                                  return  mod_script_call_nc('mod', 'telib', 'top_create', _x, _y, _obj, _spawnDir, _spawnDis);
#define option_get(_name, _default)                                                     return  mod_script_call_nc('mod', 'telib', 'option_get', _name, _default);
#define option_set(_name, _value)                                                               mod_script_call_nc('mod', 'telib', 'option_set', _name, _value);
#define stat_get(_name)                                                                 return  mod_script_call_nc('mod', 'telib', 'stat_get', _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc('mod', 'telib', 'stat_set', _name, _value);
#define unlock_get(_name)                                                               return  mod_script_call_nc('mod', 'telib', 'unlock_get', _name);
#define unlock_set(_name, _value)                                                               mod_script_call_nc('mod', 'telib', 'unlock_set', _name, _value);
#define unlock_call(_name)                                                              return  mod_script_call_nc('mod', 'telib', 'unlock_call', _name);
#define unlock_splat(_name, _text, _sprite, _sound)                                     return  mod_script_call_nc('mod', 'telib', 'unlock_splat', _name, _text, _sprite, _sound);
#define trace_error(_error)                                                                     mod_script_call_nc('mod', 'telib', 'trace_error', _error);
#define view_shift(_index, _dir, _pan)                                                          mod_script_call_nc('mod', 'telib', 'view_shift', _index, _dir, _pan);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc('mod', 'telib', 'sleep_max', _milliseconds);
#define dfloor(_num, _div)                                                              return  mod_script_call_nc('mod', 'telib', 'dfloor', _num, _div);
#define in_distance(_inst, _dis)                                                        return  mod_script_call(   'mod', 'telib', 'in_distance', _inst, _dis);
#define in_sight(_inst)                                                                 return  mod_script_call(   'mod', 'telib', 'in_sight', _inst);
#define instance_budge(_objAvoid, _disMax)                                              return  mod_script_call(   'mod', 'telib', 'instance_budge', _objAvoid, _disMax);
#define instance_random(_obj)                                                           return  mod_script_call_nc('mod', 'telib', 'instance_random', _obj);
#define instance_create_copy(_x, _y, _obj)                                              return  mod_script_call(   'mod', 'telib', 'instance_create_copy', _x, _y, _obj);
#define instance_create_lq(_x, _y, _lq)                                                 return  mod_script_call_nc('mod', 'telib', 'instance_create_lq', _x, _y, _lq);
#define instance_nearest_array(_x, _y, _inst)                                           return  mod_script_call_nc('mod', 'telib', 'instance_nearest_array', _x, _y, _inst);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc('mod', 'telib', 'instance_rectangle', _x1, _y1, _x2, _y2, _obj);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call_nc('mod', 'telib', 'instance_rectangle_bbox', _x1, _y1, _x2, _y2, _obj);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call_nc('mod', 'telib', 'instances_at', _x, _y, _obj);
#define instances_seen_nonsync(_obj, _bx, _by)                                          return  mod_script_call_nc('mod', 'telib', 'instances_seen_nonsync', _obj, _bx, _by);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   'mod', 'telib', 'instances_meeting', _x, _y, _obj);
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call_nc('mod', 'telib', 'draw_weapon', _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call_nc('mod', 'telib', 'draw_lasersight', _x, _y, _dir, _maxDistance, _width);
#define draw_text_bn(_x, _y, _string, _angle)                                                   mod_script_call_nc('mod', 'telib', 'draw_text_bn', _x, _y, _string, _angle);
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
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call_nc('mod', 'telib', 'area_get_sprite', _area, _spr);
#define area_get_subarea(_area)                                                         return  mod_script_call_nc('mod', 'telib', 'area_get_subarea', _area);
#define area_get_secret(_area)                                                          return  mod_script_call_nc('mod', 'telib', 'area_get_secret', _area);
#define area_get_underwater(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_underwater', _area);
#define area_border(_y, _area, _color)                                                  return  mod_script_call_nc('mod', 'telib', 'area_border', _y, _area, _color);
#define area_generate(_area, _subarea, _x, _y)                                          return  mod_script_call_nc('mod', 'telib', 'area_generate', _area, _subarea, _x, _y);
#define area_generate_ext(_area, _subarea, _x, _y, _goal, _safeDist, _floorOverlap)     return  mod_script_call_nc('mod', 'telib', 'area_generate_ext', _area, _subarea, _x, _y, _goal, _safeDist, _floorOverlap);
#define floor_get(_x, _y)                                                               return  mod_script_call_nc('mod', 'telib', 'floor_get', _x, _y);
#define floor_set(_x, _y, _state)                                                       return  mod_script_call_nc('mod', 'telib', 'floor_set', _x, _y, _state);
#define floor_fill(_x, _y, _w, _h)                                                      return  mod_script_call_nc('mod', 'telib', 'floor_fill', _x, _y, _w, _h);
#define floor_fill_round(_x, _y, _w, _h)                                                return  mod_script_call_nc('mod', 'telib', 'floor_fill_round', _x, _y, _w, _h);
#define floor_fill_ring(_x, _y, _w, _h)                                                 return  mod_script_call_nc('mod', 'telib', 'floor_fill_ring', _x, _y, _w, _h);
#define floor_make(_x, _y, _obj)                                                        return  mod_script_call_nc('mod', 'telib', 'floor_make', _x, _y, _obj);
#define floor_set_style(_style, _area)                                                  return  mod_script_call_nc('mod', 'telib', 'floor_set_style', _style, _area);
#define floor_reset_style()                                                             return  mod_script_call_nc('mod', 'telib', 'floor_reset_style');
#define floor_reveal(_floors, _maxTime)                                                 return  mod_script_call_nc('mod', 'telib', 'floor_reveal', _floors, _maxTime);
#define floor_walls()                                                                   return  mod_script_call(   'mod', 'telib', 'floor_walls');
#define wall_tops()                                                                     return  mod_script_call(   'mod', 'telib', 'wall_tops');
#define wall_clear(_x1, _y1, _x2, _y2)                                                          mod_script_call_nc('mod', 'telib', 'wall_clear', _x1, _y1, _x2, _y2);
#define sound_play_ntte(_type, _snd)                                                    return  mod_script_call_nc('mod', 'telib', 'sound_play_ntte', _type, _snd);
#define sound_play_hit_ext(_snd, _pit, _vol)                                            return  mod_script_call(   'mod', 'telib', 'sound_play_hit_ext', _snd, _pit, _vol);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call(   'mod', 'telib', 'race_get_sprite', _race, _sprite);
#define player_create(_x, _y, _index)                                                   return  mod_script_call_nc('mod', 'telib', 'player_create', _x, _y, _index);
#define player_swap()                                                                   return  mod_script_call(   'mod', 'telib', 'player_swap');
#define wep_get(_wep)                                                                   return  mod_script_call_nc('mod', 'telib', 'wep_get', _wep);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc('mod', 'telib', 'wep_merge', _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call_nc('mod', 'telib', 'wep_merge_decide', _hardMin, _hardMax);
#define weapon_decide_gold(_minhard, _maxhard, _nowep)                                  return  mod_script_call_nc('mod', 'telib', 'weapon_decide_gold', _minhard, _maxhard, _nowep);
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
#define TopDecal_create(_x, _y, _area)                                                  return  mod_script_call_nc('mod', 'telib', 'TopDecal_create', _x, _y, _area);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   'mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_instance, _charm)                                               return  mod_script_call_nc('mod', 'telib', 'charm_instance', _instance, _charm);