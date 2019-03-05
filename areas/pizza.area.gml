#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");

    spr.TVHurt = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAJAAAAAgCAYAAAD9jPHNAAAABmJLR0QAdwA5AI6TC/eYAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4goaFCcxcngGgAAAAd1JREFUeNrtms9KAlEUxs+NWUURpLOyCBdB0taYoI0v0Mp6gVm5EZ8l2rTyBapNvUCbIMltuAiKwFaaEEbb28ImFEa91/HOPbf5fiAMemf8PHz3/JmRCAAAAHASYeKiUko580uFEMzjIm3EzUX9Im3zOGAiGdYaMxc0L844myhV/SJt4zA2kiQiOjg8Ulr8+HDPLRtZ0S9smoeRieS+v77QiU+9IQcTWdO/gjYQJAEGAjAQsIeHEIzwd/Ja63tv/dE5ox4is/phoDHu2q9K6yrlIgXVkF7aN5nXjxIGYCAbtK6b0A8DLU5QDaEfBgKmpzA8VJxCSg00e/1zM5CfK1BYa5CfK0wcOzOeQ7/9Jvr28ir22BWg314Jo/zmVuz7vY93J4Kvo79SLkK/JvNqqHINZvp3Dp0eQhqK4b/W71kMDocNMsHa6obWxb++PzOvn9OjDOsT33Zhj/qD7tSyEX3WOW9RqR5Q57mVef2s7gNxmTj6g27sK6JUD6BfY1coOTNhDySjHzCjYRSGM1uSHiKz+j3VzHB8evI3QkbH45PAMpphUxOfiv5llJgs6lfKQIZ2ls4uS7SDod+cfs/mzhqntBtfl38bPcExM0D/EnsgxhMY9DswAQMAAAAp8wP+6CZ1H8F9uwAAAABJRU5ErkJggg==", 3, 24, 16);

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus

#macro bgrColor area_get_background_color(102)
#macro shdColor area_get_shadow_color(102)

#define area_music      return mus102;
#define area_ambience   return amb102;
#define area_secret     return true;

#define area_name(_subarea, _loop)
    return "2-@2(sprSlice:0)";

#define area_mapdata(_lastx, _lasty, _lastarea, _lastsubarea, _subarea, _loops)
    return [_lastx+0.5,-8,1];

#define area_sprite(_spr)
    switch(_spr){
         // Floors:
        case sprFloor1      : return sprFloor102;
        case sprFloor1B     : return sprFloor102B;
        case sprFloor1Explo : return sprFloor102Explo;

         // Walls:
        case sprWall1Trans  : return sprWall102Trans;
        case sprWall1Bot    : return sprWall102Bot;
        case sprWall1Out    : return sprWall102Out;
        case sprWall1Top    : return sprWall102Top;

         // Misc:
        case sprDebris1     : return sprDebris102;
        case sprDetail1     : return sprDetail102;
    }

#define area_setup
    goal = 1;
    safespawn = false;
    background_color = bgrColor;
    BackCont.shadcol = shdColor;
    TopCont.darkness = true;

#define area_start
     // Floor Setup:
    with(Floor){
         // Pizza Floors:
        if(place_meeting(x, y, PizzaBox) || place_meeting(x, y, HealthChest) || place_meeting(x, y, HPPickup)){
            styleb = true;
            sprite_index = area_sprite(sprFloor1B);
        }

         // Fix Depth:
        if(styleb) depth = 8;

         // Footsteps:
        material = (styleb ? 6 : 2);
    }

     // Pizza Chests:
    with(HealthChest){
        sprite_index = choose(sprPizzaChest1, sprPizzaChest2);
        spr_dead = sprPizzaChestOpen;
    }

     // Toons Viewer:
    var _x = 10000,
        _y = 10000;

    obj_create(_x - 48, _y, "PizzaTV");

     // Turtles:
    var c = [1, 2, 4],
        a = random(360);

    for(var i = 0; i < array_length(c); i++){
        var _dis = 20 + random(4),
            _dir = a + (i * (360 / array_length(c))) + orandom(10);

        with(instance_create(_x - 48 + lengthdir_x(_dis, _dir), _y + 48 + lengthdir_y(_dis, _dir), Turtle)){
            snd_dead = asset_get_index(`sndTurtleDead${c[i]}`);
            scrRight(_dir + 180);
        }
    }
    with(instance_create(_x + 48, _y + random_range(32, 48), Turtle)){
        snd_dead = sndTurtleDead3;
        right = 1;
    }
    with(instance_create(_x - 80, _y + 16, Rat)) right = 1;
    with(Turtle) alarm1 += 10;

     // Door:
    obj_create(_x + 56, _y - 48, "PizzaDrain");

#define area_step
    script_bind_end_step(end_step, 0);

#define end_step
    instance_destroy();

     // Yummy HP:
    with(instances_matching(HPPickup, "sliced", null)){
        sliced = true;
        sprite_index = sprSlice;
    }

#define area_effect(_vx, _vy)
    var _x = _vx + random(game_width),
        _y = _vy + random(game_height);

     // Cheesy Drips:
    var f = instance_nearest(_x, _y, Floor);
    with(f) with(instance_create(x + random_range(8, 32), y + random_range(8, 32), Drip)){
        sprite_index = sprCheeseDrip;
    }

    return random(120);

#define area_finish
    lastarea = area;

     // Area End:
    if(subarea >= 1){
        area = 3;
        subarea = 1;
    }

     // Next Subarea: 
    else subarea++;


#define area_make_floor
    var _x = 10000 - 32;
        _y = 10000;

    styleb = 0;
    scrFloorFill(_x, _y, 8, 6);

#define area_pop_props
    var _x = x,
        _y = y,
        _west = !position_meeting(_x - 16, _y, Floor),
        _east = !position_meeting(_x + 48, _y, Floor),
        _nort = !position_meeting(_x, _y - 16, Floor),
        _sout = !position_meeting(_x, _y + 48, Floor);

    if(_nort){
        if(_west) instance_create(_x, _y, Wall);
        else if(_east) instance_create(_x + 16, _y, Wall);
    }
    else if(_sout){
        if(_west) instance_create(_x, _y + 16, Wall);
        else if(_east) instance_create(_x + 16, _y + 16, Wall);
    }

     // Gimme pizza:
    else if(_east){
        _x += 16;
        _y += 16;
        repeat(irandom_range(1, 4)){
            if(random(3) < 1) instance_create(_x + orandom(4), _y + orandom(4), HealthChest);
            else instance_create(_x + orandom(8), _y + orandom(4), choose(PizzaBox, HPPickup));
        }
    }
    
#define area_pop_extras
    


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
#define enemyAlarms(_maxAlarm)                                                                  mod_script_call(   "mod", "telib", "enemyAlarms", _maxAlarm);
#define enemyWalk(_spd, _max)                                                                   mod_script_call(   "mod", "telib", "enemyWalk", _spd, _max);
#define enemySprites()                                                                          mod_script_call(   "mod", "telib", "enemySprites");
#define enemyHurt(_hitdmg, _hitvel, _hitdir)                                                    mod_script_call(   "mod", "telib", "enemyHurt", _hitdmg, _hitvel, _hitdir);
#define scrDefaultDrop()                                                                        mod_script_call(   "mod", "telib", "scrDefaultDrop");
#define target_in_distance(_disMin, _disMax)                                            return  mod_script_call(   "mod", "telib", "target_in_distance", _disMin, _disMax);
#define target_is_visible()                                                             return  mod_script_call(   "mod", "telib", "target_is_visible");
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
#define orandom(n)                                                                      return  mod_script_call(   "mod", "telib", "orandom", n);
#define floor_ext(_num, _round)                                                         return  mod_script_call(   "mod", "telib", "floor_ext", _num, _round);
#define array_count(_array, _value)                                                     return  mod_script_call(   "mod", "telib", "array_count", _array, _value);
#define array_flip(_array)                                                              return  mod_script_call(   "mod", "telib", "array_flip", _array);
#define instances_named(_object, _name)                                                 return  mod_script_call(   "mod", "telib", "instances_named", _object, _name);
#define nearest_instance(_x, _y, _instances)                                            return  mod_script_call(   "mod", "telib", "nearest_instance", _x, _y, _instances);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call(   "mod", "telib", "instance_rectangle", _x1, _y1, _x2, _y2, _obj);
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
#define Pet_create(_x, _y, _name)                                                       return  mod_script_call(   "mod", "telib", "Pet_create", _x, _y, _name);
#define scrFloorMake(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "scrFloorMake", _x, _y, _obj);
#define scrFloorFill(_x, _y, _w, _h)                                                    return  mod_script_call(   "mod", "telib", "scrFloorFill", _x, _y, _w, _h);
#define scrFloorFillRound(_x, _y, _w, _h)                                               return  mod_script_call(   "mod", "telib", "scrFloorFillRound", _x, _y, _w, _h);
#define unlock_get(_unlock)                                                             return  mod_script_call(   "mod", "telib", "unlock_get", _unlock);
#define unlock_set(_unlock, _value)                                                             mod_script_call(   "mod", "telib", "unlock_set", _unlock, _value);
#define scrUnlock(_name, _text, _sprite, _sound)                                        return  mod_script_call(   "mod", "telib", "scrUnlock", _name, _text, _sprite, _sound);