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
    if(subarea >= 1) && false{
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
    


#define scrFloorMake(_x,_y,_obj)
    return mod_script_call("mod","ntte","scrFloorMake",_x,_y,_obj);

#define scrFloorFill(_x,_y,_w,_h)
    return mod_script_call("mod","ntte","scrFloorFill",_x,_y,_w,_h);

#define scrFloorFillRound(_x,_y,_w,_h)
    return mod_script_call("mod","ntte","scrFloorFillRound",_x,_y,_w,_h);

 /// HELPER SCRIPTS /// 
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call("mod", "telib", "obj_create", _x, _y, _obj);
#define draw_self_enemy()                                                                       mod_script_call("mod", "teassets", "draw_self_enemy");
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call("mod", "teassets", "draw_weapon", _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define scrWalk(_walk, _dir)                                                                    mod_script_call("mod", "teassets", "scrWalk", _walk, _dir);
#define scrRight(_dir)                                                                          mod_script_call("mod", "teassets", "scrRight", _dir);
#define scrEnemyShoot(_object, _dir, _spd)                                              return  mod_script_call("mod", "teassets", "scrEnemyShoot", _object, _dir, _spd);
#define scrEnemyShootExt(_x, _y, _object, _dir, _spd)                                   return  mod_script_call("mod", "teassets", "scrEnemyShootExt", _x, _y, _object, _dir, _spd);
#define enemyAlarms(_maxAlarm)                                                                  mod_script_call("mod", "teassets", "enemyAlarms", _maxAlarm);
#define enemyWalk(_spd, _max)                                                                   mod_script_call("mod", "teassets", "enemyWalk", _spd, _max);
#define enemySprites()                                                                          mod_script_call("mod", "teassets", "enemySprites");
#define enemyHurt(_hitdmg, _hitvel, _hitdir)                                                    mod_script_call("mod", "teassets", "enemyHurt", _hitdmg, _hitvel, _hitdir);
#define scrDefaultDrop()                                                                        mod_script_call("mod", "teassets", "scrDefaultDrop");
#define target_in_distance(_disMin, _disMax)                                            return  mod_script_call("mod", "teassets", "target_in_distance", _disMin, _disMax);
#define target_is_visible()                                                             return  mod_script_call("mod", "teassets", "target_is_visible");
#define z_engine()                                                                              mod_script_call("mod", "teassets", "z_engine");
#define scrBossHP(_hp)                                                                  return  mod_script_call("mod", "teassets", "scrBossHP", _hp);
#define scrBossIntro(_name, _sound, _music)                                                     mod_script_call("mod", "teassets", "scrBossIntro", _name, _sound, _music);
#define scrWaterStreak(_x, _y, _dir, _spd)                                              return  mod_script_call("mod", "teassets", "scrWaterStreak", _x, _y, _dir, _spd);
#define orandom(n)                                                                      return  mod_script_call("mod", "teassets", "orandom", n);
#define floor_ext(_num, _round)                                                         return  mod_script_call("mod", "teassets", "floor_ext", _num, _round);
#define array_count(_array, _value)                                                     return  mod_script_call("mod", "teassets", "array_count", _array, _value);
#define array_flip(_array)                                                              return  mod_script_call("mod", "teassets", "array_flip", _array);
#define instances_named(_object, _name)                                                 return  mod_script_call("mod", "teassets", "instances_named", _object, _name);
#define nearest_instance(_x, _y, _instances)                                            return  mod_script_call("mod", "teassets", "nearest_instance", _x, _y, _instances);
#define instances_seen(_obj, _ext)                                                      return  mod_script_call("mod", "teassets", "instances_seen", _obj, _ext);
#define frame_active(_interval)                                                         return  mod_script_call("mod", "teassets", "frame_active", _interval);