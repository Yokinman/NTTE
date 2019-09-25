#macro autoReplace (player_get_alias(0) == "Yokin") // u kno im the only one that stores mods in the localappdata

#define init
    with([
        "ntte.mod.gml", "petlib.mod.gml",
        "areas/template.gml", "areas/coast.area.gml", "areas/oasis.area.gml", "areas/pizza.area.gml", "areas/lair.area.gml", "areas/trench.area.gml",
        "objects/template.gml", "objects/tegeneral.mod.gml", "objects/tedesert.mod.gml", "objects/tecoast.mod.gml", "objects/tewater.mod.gml", "objects/tesewers.mod.gml", "objects/tescrapyard.mod.gml", "objects/tecaves.mod.gml", "objects/tepickups.mod.gml",
        "races/parrot.race.gml",
        "weps/merge.wep.gml"
    ]){
        script_set(self, "mod", "telib", "sound_play_hit_ext", ["_snd", "_pit", "_vol"], "return", "");
        //script_remove(self, "scrRadDrop");
        
        //script_remove(self, "obj_create");
    }


//  "
//  #define orandom(n)																		return  random_range(-n, n);
//  #define chance(_numer, _denom)															return  random(_denom) < _numer;
//  #define chance_ct(_numer, _denom)														return  random(_denom) < (_numer * current_time_scale);
//  #define obj_create(_x, _y, _obj)                                                        return  mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj);
//  #define draw_self_enemy()                                                                       mod_script_call(   "mod", "telib", "draw_self_enemy");
//  #define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call(   "mod", "telib", "draw_weapon", _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
//  #define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call(   "mod", "telib", "draw_lasersight", _x, _y, _dir, _maxDistance, _width);
//  #define draw_trapezoid(_x1a, _x2a, _y1, _x1b, _x2b, _y2)                                        mod_script_call_nc("mod", "telib", "draw_trapezoid", _x1a, _x2a, _y1, _x1b, _x2b, _y2);
//  #define scrWalk(_walk, _dir)                                                                    mod_script_call(   "mod", "telib", "scrWalk", _walk, _dir);
//  #define scrRight(_dir)                                                                          mod_script_call(   "mod", "telib", "scrRight", _dir);
//  #define scrEnemyShoot(_object, _dir, _spd)                                              return  mod_script_call(   "mod", "telib", "scrEnemyShoot", _object, _dir, _spd);
//  #define scrEnemyShootExt(_x, _y, _object, _dir, _spd)                                   return  mod_script_call(   "mod", "telib", "scrEnemyShootExt", _x, _y, _object, _dir, _spd);
//  #define enemyWalk(_spd, _max)                                                                   mod_script_call(   "mod", "telib", "enemyWalk", _spd, _max);
//  #define enemySprites()                                                                          mod_script_call(   "mod", "telib", "enemySprites");
//  #define enemyHurt(_hitdmg, _hitvel, _hitdir)                                                    mod_script_call(   "mod", "telib", "enemyHurt", _hitdmg, _hitvel, _hitdir);
//  #define scrDefaultDrop()                                                                        mod_script_call(   "mod", "telib", "scrDefaultDrop");
//  #define in_distance(_inst, _dis)			                                            return  mod_script_call(   "mod", "telib", "in_distance", _inst, _dis);
//  #define in_sight(_inst)																	return  mod_script_call(   "mod", "telib", "in_sight", _inst);
//  #define z_engine()                                                                              mod_script_call(   "mod", "telib", "z_engine");
//  #define scrPickupIndicator(_text)                                                       return  mod_script_call(   "mod", "telib", "scrPickupIndicator", _text);
//  #define scrCharm(_instance, _charm)                                                     return  mod_script_call_nc("mod", "telib", "scrCharm", _instance, _charm);
//  #define scrBossHP(_hp)                                                                  return  mod_script_call(   "mod", "telib", "scrBossHP", _hp);
//  #define scrBossIntro(_name, _sound, _music)                                                     mod_script_call(   "mod", "telib", "scrBossIntro", _name, _sound, _music);
//  #define scrTopDecal(_x, _y, _area)                                                      return  mod_script_call(   "mod", "telib", "scrTopDecal", _x, _y, _area);
//  #define scrWaterStreak(_x, _y, _dir, _spd)                                              return  mod_script_call(   "mod", "telib", "scrWaterStreak", _x, _y, _dir, _spd);
//  #define scrRadDrop(_x, _y, _raddrop, _dir, _spd)                                        return  mod_script_call(   "mod", "telib", "scrRadDrop", _x, _y, _raddrop, _dir, _spd);
//  #define scrCorpse(_dir, _spd)                                                           return  mod_script_call(   "mod", "telib", "scrCorpse", _dir, _spd);
//  #define scrSwap()                                                                       return  mod_script_call(   "mod", "telib", "scrSwap");
//  #define scrSetPet(_pet)                                                                 return  mod_script_call(   "mod", "telib", "scrSetPet", _pet);
//  #define scrPortalPoof()                                                                 return  mod_script_call(   "mod", "telib", "scrPortalPoof");
//  #define scrPickupPortalize()                                                            return  mod_script_call(   "mod", "telib", "scrPickupPortalize");
//  #define floor_ext(_num, _round)                                                         return  mod_script_call(   "mod", "telib", "floor_ext", _num, _round);
//  #define array_count(_array, _value)                                                     return  mod_script_call(   "mod", "telib", "array_count", _array, _value);
//  #define array_flip(_array)                                                              return  mod_script_call(   "mod", "telib", "array_flip", _array);
//  #define instances_named(_object, _name)                                                 return  mod_script_call(   "mod", "telib", "instances_named", _object, _name);
//  #define nearest_instance(_x, _y, _instances)                                            return  mod_script_call(   "mod", "telib", "nearest_instance", _x, _y, _instances);
//  #define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc("mod", "telib", "instance_rectangle", _x1, _y1, _x2, _y2, _obj);
//  #define instances_seen(_obj, _ext)                                                      return  mod_script_call(   "mod", "telib", "instances_seen", _obj, _ext);
//  #define instance_random(_obj)                                                           return  mod_script_call(   "mod", "telib", "instance_random", _obj);
//  #define frame_active(_interval)                                                         return  mod_script_call(   "mod", "telib", "frame_active", _interval);
//  #define area_generate(_x, _y, _area)                                                    return  mod_script_call(   "mod", "telib", "area_generate", _x, _y, _area);
//  #define scrFloorWalls()                                                                 return  mod_script_call(   "mod", "telib", "scrFloorWalls");
//  #define floor_reveal(_floors, _maxTime)                                                 return  mod_script_call(   "mod", "telib", "floor_reveal", _floors, _maxTime);
//  #define area_border(_y, _area, _color)                                                  return  mod_script_call(   "mod", "telib", "area_border", _y, _area, _color);
//  #define area_get_sprite(_area, _spr)                                                    return  mod_script_call(   "mod", "telib", "area_get_sprite", _area, _spr);
//  #define floor_at(_x, _y)                                                                return  mod_script_call(   "mod", "telib", "floor_at", _x, _y);
//  #define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   "mod", "telib", "lightning_connect", _x1, _y1, _x2, _y2, _arc, _enemy);
//  #define scrLightning(_x1, _y1, _x2, _y2, _enemy)                                        return  mod_script_call(   "mod", "telib", "scrLightning", _x1, _y1, _x2, _y2, _enemy);
//  #define in_range(_num, _lower, _upper)                                                  return  mod_script_call(   "mod", "telib", "in_range", _num, _lower, _upper);
//  #define wep_get(_wep)                                                                   return  mod_script_call(   "mod", "telib", "wep_get", _wep);
//  #define decide_wep_gold(_minhard, _maxhard, _nowep)                                     return  mod_script_call(   "mod", "telib", "decide_wep_gold", _minhard, _maxhard, _nowep);
//  #define path_create(_xstart, _ystart, _xtarget, _ytarget)                               return  mod_script_call(   "mod", "telib", "path_create", _xstart, _ystart, _xtarget, _ytarget);
//  #define race_get_sprite(_race, _sprite)                                                 return  mod_script_call(   "mod", "telib", "race_get_sprite", _race, _sprite);
//  #define scrFloorMake(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "scrFloorMake", _x, _y, _obj);
//  #define scrFloorFill(_x, _y, _w, _h)                                                    return  mod_script_call(   "mod", "telib", "scrFloorFill", _x, _y, _w, _h);
//  #define scrFloorFillRound(_x, _y, _w, _h)                                               return  mod_script_call(   "mod", "telib", "scrFloorFillRound", _x, _y, _w, _h);
//  #define unlock_get(_unlock)                                                             return  mod_script_call(   "mod", "telib", "unlock_get", _unlock);
//  #define unlock_set(_unlock, _value)                                                             mod_script_call(   "mod", "telib", "unlock_set", _unlock, _value);
//  #define scrUnlock(_name, _text, _sprite, _sound)                                        return  mod_script_call(   "mod", "telib", "scrUnlock", _name, _text, _sprite, _sound);
//  #define area_get_subarea(_area)                                                         return  mod_script_call(   "mod", "telib", "area_get_subarea", _area);
//  #define trace_lag()                                                                             mod_script_call(   "mod", "telib", "trace_lag");
//  #define trace_lag_bgn(_name)                                                                    mod_script_call(   "mod", "telib", "trace_lag_bgn", _name);
//  #define trace_lag_end(_name)                                                                    mod_script_call(   "mod", "telib", "trace_lag_end", _name);
//  #define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call(   "mod", "telib", "instance_rectangle_bbox", _x1, _y1, _x2, _y2, _obj);
//  #define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   "mod", "telib", "instances_meeting", _x, _y, _obj);
//  #define array_delete(_array, _index)                                                    return  mod_script_call(   "mod", "telib", "array_delete", _array, _index);
//  #define array_delete_value(_array, _value)                                              return  mod_script_call(   "mod", "telib", "array_delete_value", _array, _value);
//  #define instances_at(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "instances_at", _x, _y, _obj);
//  #define Pet_spawn(_x, _y, _name)                                                        return  mod_script_call(   "mod", "telib", "Pet_spawn", _x, _y, _name);
//  #define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc("mod", "telib", "scrFX", _x, _y, _motion, _obj);
//  #define array_combine(_array1, _array2)                                                 return  mod_script_call(   "mod", "telib", "array_combine", _array1, _array2);
//  #define player_create(_x, _y, _index)                                                   return  mod_script_call(   "mod", "telib", "player_create", _x, _y, _index);
//  #define draw_set_flat(_color)                                                                   mod_script_call(   "mod", "telib", "draw_set_flat", _color);
//  #define trace_error(_error)                                                                     mod_script_call_nc("mod", "telib", "trace_error", _error);
//  #define sleep_max(_milliseconds)                                                                mod_script_call_nc("mod", "telib", "sleep_max", _milliseconds);
//  "

#define script_set(_path, _type, _name, _scrt, _args, _return, _callType)
    if(!is_array(_args)) _args = [_args];

    wait file_load(_path);

    var _str = string_load(_path),
        _old = "",
        _new = "";

    var p = string_pos("#define " + _scrt, _str);
    if(p > 0){
        _old = string_copy(_str, p, string_pos(";", string_delete(_str, 1, p - 1)));
    }

    _new += "#define " + _scrt + "(";
    for(var i = 0; i < array_length(_args); i++){
        if(i > 0) _new += ", ";
        _new += _args[i];
    }
    _new += ")";
    _new = string_rpad(_new, " ", 88);
    _new += string_rpad(_return, " ", 8);
    _new += string_rpad("mod_script_call" + _callType + "(", " ", 19);
    _new += '"' + _type + '", "' + _name + '", "' + _scrt + '"';
    if(array_length(_args) > 0){
        _new += ", ";
        for(var i = 0; i < array_length(_args); i++){
            if(i > 0) _new += ", ";
            _new += _args[i];
        }
    }
    _new += ");"

    if(_old != ""){
        _str = string_replace(_str, _old, _new);
    }
    else{
        _str += chr(13) + chr(10) + _new;
    }

    string_save(_str, (autoReplace ? "../../mods/NTTE/" : "") + _path);

#define script_remove(_path, _scrt)
    wait file_load(_path);

    var _str = string_load(_path);

    var p = string_pos("#define " + _scrt, _str);
    if(p <= 0) p = string_length(_str);
    _str = string_delete(_str, p - 2, string_pos(";", string_delete(_str, 1, p - 1)) + 2);

    string_save(_str, (autoReplace ? "../../mods/NTTE/" : "") + _path);