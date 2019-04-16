#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.save = mod_variable_get("mod", "teassets", "save");

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.save
#macro opt sav.option

#macro current_frame_active ((current_frame mod 1) < current_time_scale)

#macro TrenchVisited (mod_exists("area", "trench") ? mod_variable_get("area", "trench", "trench_visited") : [])

#define area_subarea            return 1;
#define area_next               return [3, 3];
#define area_music              return mus101;
#define area_ambience           return amb101;
#define area_background_color   return area_get_background_color(101);
#define area_shadow_color       return area_get_shadow_color(101);
#define area_darkness           return false;
#define area_secret             return true;

#define area_name(_subarea, _loop)
    return "@1(sprInterfaceIcons)2-" + string(_subarea);

#define area_text
	return choose("DON'T MOVE", "IT'S BEAUTIFUL DOWN HERE", "HOLD YOUR BREATH", "FISH", "RIPPLING SKY", "IT'S SO QUIET", "THERE'S SOMETHING IN THE WATER");

#define area_mapdata(_lastx, _lasty, _lastarea, _lastsubarea, _subarea, _loops)
    var _x = 27.5,
        _y = -9;

    if(array_length(TrenchVisited) <= _loops || !TrenchVisited[_loops]){
        _x += 16.5;

         // Manual Line Shadow:
        if(GameCont.area != mod_current || GameCont.subarea != _subarea || GameCont.loops != _loops){
             // Map Offset:
            var _dx = view_xview_nonsync + (game_width / 2),
                _dy = view_yview_nonsync + (game_height / 2);

            if(instance_exists(GameOverButton)){
                _dx -= 120;
                _dy += 1;
            }
            else{
                _dx -= 70;
                _dy += 6;
            }

             // Draw Shadow:
            var _x1 = _dx + _x,
                _y1 = _dy + _y,
                _x2 = _dx + 53,
                _y2 = _dy + 0;

            var c = draw_get_color();
            draw_set_color(c_black);
            draw_line_width(_x1, _y1 + 1, _x2, _y2 + 1, 1);
            draw_set_color(c);
        }
    }

     // Return Map Stuff:
    return [_x, _y, (_subarea == 1)];

#define area_sprite(_spr)
    switch(_spr){
         // Floors:
        case sprFloor1      : return sprFloor101;
        case sprFloor1B     : return sprFloor101B;
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

#define area_setup_floor(_explo)
    if(!_explo){
         // Fix Depth:
        if(styleb) depth = 8;

         // Footsteps:
        material = (styleb ? 4 : 1);
    }

#define area_start
     // Coolin Clammin:
    /*with(WeaponChest){
        obj_create(x, y, "ClamChest");
        instance_delete(id);
    }*/
    
     // Anglers:
    with(RadChest) if(chance(1, 40)){
        obj_create(x, y, "Angler");
        instance_delete(id);
    }

#define area_finish
    lastarea = area;

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
     // Run underwater code:
    mod_script_call("mod", "ntte", "underwater_step");

     // Spawn cool crack effect:
    if(instance_exists(Portal)){
        var _crack = instances_named(CustomObject, "Crack");
        if(array_length(_crack) <= 0){
            with(nearest_instance(10000, 10000, instances_matching_ne(Floor, "object_index", FloorExplo))){
                obj_create(x + 16, y + 16, "Crack");
            }
        }
    }

#define area_effect(_vx, _vy)
    var _x = _vx + random(game_width),
        _y = _vy + random(game_height);

     // Player Bubbles:
    if(chance(1, 4)){
        with(Player) instance_create(x, y, Bubble);
    }
    
     // Pet Bubbles:
    if(chance(1, 4)){
        with instances_matching(CustomObject, "name", "Pet") instance_create(x, y, Bubble);
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
    	    var o = 32;
    	    for(var d = 0; d < 360; d += 90){
    	        instance_create(_x + lengthdir_x(o, d), _y + lengthdir_y(o, d), Floor);
    	    }
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
            with(scrFloorMake(_x, _y, WeaponChest)){
                sprite_index = sprClamChest;
            }
        }

         // Dead Ends (Ammo Chests):
        var n = instance_number(FloorMaker);
    	if(!chance(20, 19 + n)){
    		if(_outOfSpawn) scrFloorMake(_x, _y, AmmoChest);
    		instance_destroy();
    	}

    	 // Branch:
    	if(chance(1, 5)) instance_create(_x, _y, FloorMaker);

#define area_pop_enemies
    var _x = x + 16,
        _y = y + 16;

    if(chance(1, 2)){
         // Shoals:
        if(chance(1, 2)){
            if(!styleb && chance(3, 4)){
                if(GameCont.loops > 0 && chance(1, 2)){
                    repeat(irandom_range(1, 4)) instance_create(_x, _y, Freak);
                }
                repeat(irandom_range(1, 4)) instance_create(_x, _y, BoneFish);
            }
            else{
                repeat(irandom_range(1, 4)) obj_create(_x, _y, "Puffer");
            }
        }

        else{
            if(GameCont.loops > 0 && chance(1, 3)) {
                instance_create(_x, _y, (styleb ? Necromancer : Ratking));
            }
            else{
                if(chance(1, 5)) obj_create(_x, _y, "Diver");
                else{
                    if(!styleb){
                        if(chance(1, 2)) instance_create(_x, _y, Crab);
                    }
                    else obj_create(_x, _y, "Hammerhead"); 
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
    else if(chance(1, 7)){
        var _x = x + 16 + orandom(8),
            _y = y + 16 + orandom(8);

        if(styleb){
            instance_create(_x, _y, choose(WaterMine, WaterMine, OasisBarrel, Anchor));
        }
        else{
            instance_create(_x, _y, choose(WaterPlant, WaterPlant, OasisBarrel, WaterMine));
        }
    }

#define area_pop_extras
     // The new bandits
    with(instances_matching([WeaponChest, AmmoChest, RadChest], "", null)){
        obj_create(x, y, "Diver");
    }


/// Scripts
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj);
#define draw_self_enemy()                                                                       mod_script_call(   "mod", "telib", "draw_self_enemy");
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call(   "mod", "telib", "draw_weapon", _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call(   "mod", "telib", "draw_lasersight", _x, _y, _dir, _maxDistance, _width);
#define draw_trapezoid(_x1a, _x2a, _y1, _x1b, _x2b, _y2)                                        mod_script_call_nc("mod", "telib", "draw_trapezoid", _x1a, _x2a, _y1, _x1b, _x2b, _y2);
#define scrWalk(_walk, _dir)                                                                    mod_script_call(   "mod", "telib", "scrWalk", _walk, _dir);
#define scrRight(_dir)                                                                          mod_script_call(   "mod", "telib", "scrRight", _dir);
#define scrEnemyShoot(_object, _dir, _spd)                                              return  mod_script_call(   "mod", "telib", "scrEnemyShoot", _object, _dir, _spd);
#define scrEnemyShootExt(_x, _y, _object, _dir, _spd)                                   return  mod_script_call(   "mod", "telib", "scrEnemyShootExt", _x, _y, _object, _dir, _spd);
#define enemyWalk(_spd, _max)                                                                   mod_script_call(   "mod", "telib", "enemyWalk", _spd, _max);
#define enemySprites()                                                                          mod_script_call(   "mod", "telib", "enemySprites");
#define enemyHurt(_hitdmg, _hitvel, _hitdir)                                                    mod_script_call(   "mod", "telib", "enemyHurt", _hitdmg, _hitvel, _hitdir);
#define scrDefaultDrop()                                                                        mod_script_call(   "mod", "telib", "scrDefaultDrop");
#define in_distance(_inst, _dis)			                                            return  mod_script_call(   "mod", "telib", "in_distance", _inst, _dis);
#define in_sight(_inst)																	return  mod_script_call(   "mod", "telib", "in_sight", _inst);
#define chance(_numer, _denom)															return	mod_script_call_nc("mod", "telib", "chance", _numer, _denom);
#define chance_ct(_numer, _denom)														return	mod_script_call_nc("mod", "telib", "chance_ct", _numer, _denom);
#define z_engine()                                                                              mod_script_call(   "mod", "telib", "z_engine");
#define scrPickupIndicator(_text)                                                       return  mod_script_call(   "mod", "telib", "scrPickupIndicator", _text);
#define scrCharm(_instance, _charm)                                                     return  mod_script_call_nc("mod", "telib", "scrCharm", _instance, _charm);
#define scrBossHP(_hp)                                                                  return  mod_script_call(   "mod", "telib", "scrBossHP", _hp);
#define scrBossIntro(_name, _sound, _music)                                                     mod_script_call(   "mod", "telib", "scrBossIntro", _name, _sound, _music);
#define scrTopDecal(_x, _y, _area)                                                      return  mod_script_call(   "mod", "telib", "scrTopDecal", _x, _y, _area);
#define scrWaterStreak(_x, _y, _dir, _spd)                                              return  mod_script_call(   "mod", "telib", "scrWaterStreak", _x, _y, _dir, _spd);
#define scrRadDrop(_x, _y, _raddrop, _dir, _spd)                                        return  mod_script_call(   "mod", "telib", "scrRadDrop", _x, _y, _raddrop, _dir, _spd);
#define scrCorpse(_dir, _spd)                                                           return  mod_script_call(   "mod", "telib", "scrCorpse", _dir, _spd);
#define scrSwap()                                                                       return  mod_script_call(   "mod", "telib", "scrSwap");
#define scrSetPet(_pet)                                                                 return  mod_script_call(   "mod", "telib", "scrSetPet", _pet);
#define scrPortalPoof()                                                                 return  mod_script_call(   "mod", "telib", "scrPortalPoof");
#define scrPickupPortalize()                                                            return  mod_script_call(   "mod", "telib", "scrPickupPortalize");
#define orandom(n)                                                                      return  mod_script_call_nc("mod", "telib", "orandom", n);
#define floor_ext(_num, _round)                                                         return  mod_script_call(   "mod", "telib", "floor_ext", _num, _round);
#define array_count(_array, _value)                                                     return  mod_script_call(   "mod", "telib", "array_count", _array, _value);
#define array_flip(_array)                                                              return  mod_script_call(   "mod", "telib", "array_flip", _array);
#define instances_named(_object, _name)                                                 return  mod_script_call(   "mod", "telib", "instances_named", _object, _name);
#define nearest_instance(_x, _y, _instances)                                            return  mod_script_call(   "mod", "telib", "nearest_instance", _x, _y, _instances);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc("mod", "telib", "instance_rectangle", _x1, _y1, _x2, _y2, _obj);
#define instances_seen(_obj, _ext)                                                      return  mod_script_call(   "mod", "telib", "instances_seen", _obj, _ext);
#define instance_random(_obj)                                                           return  mod_script_call(   "mod", "telib", "instance_random", _obj);
#define frame_active(_interval)                                                         return  mod_script_call(   "mod", "telib", "frame_active", _interval);
#define area_generate(_x, _y, _area)                                                    return  mod_script_call(   "mod", "telib", "area_generate", _x, _y, _area);
#define scrFloorWalls()                                                                 return  mod_script_call(   "mod", "telib", "scrFloorWalls");
#define floor_reveal(_floors, _maxTime)                                                 return  mod_script_call(   "mod", "telib", "floor_reveal", _floors, _maxTime);
#define area_border(_y, _area, _color)                                                  return  mod_script_call(   "mod", "telib", "area_border", _y, _area, _color);
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call(   "mod", "telib", "area_get_sprite", _area, _spr);
#define floor_at(_x, _y)                                                                return  mod_script_call(   "mod", "telib", "floor_at", _x, _y);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   "mod", "telib", "lightning_connect", _x1, _y1, _x2, _y2, _arc, _enemy);
#define scrLightning(_x1, _y1, _x2, _y2, _enemy)                                        return  mod_script_call(   "mod", "telib", "scrLightning", _x1, _y1, _x2, _y2, _enemy);
#define in_range(_num, _lower, _upper)                                                  return  mod_script_call(   "mod", "telib", "in_range", _num, _lower, _upper);
#define wep_get(_wep)                                                                   return  mod_script_call(   "mod", "telib", "wep_get", _wep);
#define decide_wep_gold(_minhard, _maxhard, _nowep)                                     return  mod_script_call(   "mod", "telib", "decide_wep_gold", _minhard, _maxhard, _nowep);
#define path_create(_xstart, _ystart, _xtarget, _ytarget)                               return  mod_script_call(   "mod", "telib", "path_create", _xstart, _ystart, _xtarget, _ytarget);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call(   "mod", "telib", "race_get_sprite", _race, _sprite);
#define scrFloorMake(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "scrFloorMake", _x, _y, _obj);
#define scrFloorFill(_x, _y, _w, _h)                                                    return  mod_script_call(   "mod", "telib", "scrFloorFill", _x, _y, _w, _h);
#define scrFloorFillRound(_x, _y, _w, _h)                                               return  mod_script_call(   "mod", "telib", "scrFloorFillRound", _x, _y, _w, _h);
#define unlock_get(_unlock)                                                             return  mod_script_call(   "mod", "telib", "unlock_get", _unlock);
#define unlock_set(_unlock, _value)                                                             mod_script_call(   "mod", "telib", "unlock_set", _unlock, _value);
#define scrUnlock(_name, _text, _sprite, _sound)                                        return  mod_script_call(   "mod", "telib", "scrUnlock", _name, _text, _sprite, _sound);
#define area_get_subarea(_area)                                                         return  mod_script_call(   "mod", "telib", "area_get_subarea", _area);
#define trace_lag()                                                                             mod_script_call(   "mod", "telib", "trace_lag");
#define trace_lag_bgn(_name)                                                                    mod_script_call(   "mod", "telib", "trace_lag_bgn", _name);
#define trace_lag_end(_name)                                                                    mod_script_call(   "mod", "telib", "trace_lag_end", _name);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call(   "mod", "telib", "instance_rectangle_bbox", _x1, _y1, _x2, _y2, _obj);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   "mod", "telib", "instances_meeting", _x, _y, _obj);
#define array_delete(_array, _index)                                                    return  mod_script_call(   "mod", "telib", "array_delete", _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call(   "mod", "telib", "array_delete_value", _array, _value);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "instances_at", _x, _y, _obj);
#define Pet_spawn(_x, _y, _name)                                                        return  mod_script_call(   "mod", "telib", "Pet_spawn", _x, _y, _name);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc("mod", "telib", "scrFX", _x, _y, _motion, _obj);
#define array_combine(_array1, _array2)                                                 return  mod_script_call(   "mod", "telib", "array_combine", _array1, _array2);
#define player_create(_x, _y, _index)                                                   return  mod_script_call(   "mod", "telib", "player_create", _x, _y, _index);
#define draw_set_flat(_color)                                                                   mod_script_call(   "mod", "telib", "draw_set_flat", _color);
#define trace_error(_error)                                                                     mod_script_call_nc("mod", "telib", "trace_error", _error);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc("mod", "telib", "sleep_max", _milliseconds);