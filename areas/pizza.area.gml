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

#define area_subarea            return 1;
#define area_next               return 3;
#define area_music              return mus102;
#define area_ambience           return amb102;
#define area_background_color   return area_get_background_color(102);
#define area_shadow_color       return area_get_shadow_color(102);
#define area_darkness           return true;
#define area_secret             return true;

#define area_name(_subarea, _loop)
    return "2-@2(sprSlice:0)";

#define area_mapdata(_lastx, _lasty, _lastarea, _lastsubarea, _subarea, _loops)
    return [_lastx + 0.5, -8, true];

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
    var _den = {
        cols : 0,
        rows : 0,
        cols_max : 8,
        rows_max : 6
    };
    turtle_den = _den;

    goal = (_den.cols_max * _den.rows_max) + 2;
    safespawn = false;

    background_color = area_background_color();
    BackCont.shadcol = area_shadow_color();
    TopCont.darkness = area_darkness();

#define area_setup_floor(_explo)
    if(!_explo){
         // Fix Depth:
        if(styleb) depth = 8;

         // Footsteps:
        material = (styleb ? 6 : 2);
    }

#define area_start
    instance_delete(instances_matching(Wall, "", null)[0]);
    obj_create(0, 0, "PortalPrevent");

     // So much pizza:
    with(Floor){
        if(place_meeting(x, y, PizzaBox) || place_meeting(x, y, HealthChest) || place_meeting(x, y, HPPickup)){
            styleb = true;
            sprite_index = area_sprite(sprFloor1B);
        }
    }
    with(PizzaBox){
        obj_create(x, y, "PizzaBoxCool");
        instance_delete(id);
    }
    with(HealthChest){
        sprite_index = choose(sprPizzaChest1, sprPizzaChest2);
        spr_dead = sprPizzaChestOpen;
    }
    with(HPPickup) alarm0 *= 2;

     // Turt Squad:
    with(TV){
        x += random(32);
        xstart = x;

        var c = [1, 2, 4],
            a = random(360);
    
        for(var i = 0; i < array_length(c); i++){
            var _dis = 20 + random(4),
                _dir = a + (i * (360 / array_length(c))) + orandom(10);
    
            with(obj_create(x + lengthdir_x(_dis, _dir), y + 64 + lengthdir_y(_dis, _dir), "TurtleCool")){
                snd_dead = asset_get_index(`sndTurtleDead${c[i]}`);
                scrRight(_dir + 180);
            }
        }

         // The man himself:
        with(obj_create(x + orandom(4), y + orandom(4), "TurtleCool")){
            move_contact_solid(random(180), random_range(12, 64));

             // Visual:
            spr_idle = sprRatIdle;
            spr_walk = sprRatWalk;
            spr_hurt = sprRatHurt;
            spr_dead = sprRatDead;
            sprite_index = spr_idle;

             // Sound:
            snd_hurt = sndRatHit;
            snd_dead = sndRatDie;

             // Vars:
            become = Rat;
            right = 1;
        }

         // Hungry Boy:
        with(instance_random([PizzaBox, HealthChest, HPPickup])){
            with(obj_create(x + orandom(4), y + orandom(4), "TurtleCool")){
                snd_dead = sndTurtleDead3;
                right = 1;
            }
        }
    }

     // Spawn Stuff:
    with(instances_matching(Player, "", null)[0]){
         // Open Manhole:
        obj_create(x, y, "PizzaManholeCover");

         // Door:
        with(instance_nearest(x, y, Floor)){
            var p = noone;
            for(var i = -1; i <= 1; i += 2){
                with(obj_create(x + 16 - (16 * i), y - 32, "CatDoor")){
                    sprite_index = spr.PizzaDoor;
                    image_angle = 90;
                    image_yscale = i;
                    y += 3;
                    
                     // Link Doors:
                    partner = p;
                    with(partner) partner = other;
                    p = id;
                }
            }
        }
    }

     // Light up specific things:
    with(instances_matching([chestprop, RadChest], "", null)){
        obj_create(x, y - 32, "CatLight");
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

#define area_end_step
     // Allow Portal:
    if(instance_number(enemy) > 1){
        with(instances_named(CustomEnemy, "PortalPrevent")){
            instance_delete(id);
        }
    }

     // Yummy HP:
    with(instances_matching(HPPickup, "sprite_index", sprHP)){
        sprite_index = sprSlice;
        num++;
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

#define area_make_floor
    var _den = GenCont.turtle_den;
    if(_den.cols <= 0){
        x = xstart - 48;
        instance_create(xstart, ystart - 32, Floor);
    }
    if(_den.rows <= 0){
        y = ystart - 64;
    }
    direction = 90;
    styleb = false;

    instance_create(x, y, Floor);
   
     // Important Tiles:
    var _tile = `${_den.cols},${_den.rows}`;
    switch(_tile){
         /// Corner Walls:
        case "0,0": instance_create(x,      y + 16, Wall);  break;
        case "0,5": instance_create(x,      y,      Wall);  break;
        case "7,0": instance_create(x + 16, y + 16, Wall);  break;
        case "7,5": instance_create(x + 16, y,      Wall);  break;

        case "3,3": /// Toons Viewer
            obj_create(x, y - 16, "PizzaTV");
            break;

        case "6,5": /// Sewage Hole
            obj_create(x, y, "PizzaDrain");
            break;
    }

    if(++_den.rows >= _den.rows_max){
        x += 32;
        _den.rows = 0;
        if(++_den.cols >= _den.cols_max){
            instance_destroy();
        }
    }
    /*var _x = 10000 - 32,
        _y = 10000,
        _outOfSpawn = (point_distance(_x, _y, GenCont.spawn_x, GenCont.spawn_y) > 48);

    styleb = 0;
    scrFloorFill(_x, _y, 8, 6);*/

#define area_pop_props
    var _x = x + 16,
        _y = y + 16,
        _west = !position_meeting(x - 16, y, Floor),
        _east = !position_meeting(x + 48, y, Floor),
        _nort = !position_meeting(x, y - 16, Floor),
        _sout = !position_meeting(x, y + 48, Floor);

     // Gimme pizza:
    if(!_nort && !_sout && !_west && _east){
        repeat(irandom_range(1, 4)){
            if(random(3) < 1) instance_create(_x + orandom(4), _y + orandom(4), HealthChest);
            else instance_create(_x + orandom(8), _y + orandom(4), choose(PizzaBox, HPPickup));
        }
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