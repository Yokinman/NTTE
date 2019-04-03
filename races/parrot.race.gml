#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.save = mod_variable_get("mod", "teassets", "save");

    global.chest_list = [];
    global.chest_vars = [];

    while(true){
         // Chests Give Feathers:
        if(!instance_exists(GenCont)){
            with(instances_matching(chestprop, "feather_storage", null)){
                feather_storage = obj_create(x, y, "ParrotChester");
    
                 // Vars:
                with(feather_storage){
                    creator = other;
                    switch(other.object_index){
                        case BigWeaponChest:
                        case BigCursedChest:
                            num = 24; break;
                        case GiantWeaponChest:
                        case GiantAmmoChest:
                            num = 72; break;
                    }
                }
            }
        }
        wait 1;
    }

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.save

#define race_name       return "PARROT";
#define race_text       return "MANY FRIENDS#BIRDS OF A @rFEATHER@w";
#define race_tb_text    return "@rFEATHERS@s LAST LONGER";

/// Sprites
#define race_menu_button
    sprite_index = spr.Parrot[0].Select;
    image_index = !race_avail();

#define race_portrait(p, _skin)
    return spr.Parrot[_skin].Portrait;

#define race_mapicon(p, _skin)
    return spr.Parrot[_skin].Map;

#define race_skin_button(_skin)
    sprite_index = spr.Parrot[_skin].Loadout;
    image_index = !race_skin_avail(_skin);

#define race_sprite(_spr)  
    var b = (("bskin" in self) ? real(bskin) : 0);
    switch(_spr){
        case sprMutant1Idle:        return spr.Parrot[b].Idle;
        case sprMutant1Walk:        return spr.Parrot[b].Walk;
        case sprMutant1Hurt:        return spr.Parrot[b].Hurt;
        case sprMutant1Dead:        return spr.Parrot[b].Dead;
        case sprMutant1GoSit:       return spr.Parrot[b].GoSit;
        case sprMutant1Sit:         return spr.Parrot[b].Sit;
        case sprFishMenu:           return spr.Parrot[b].Idle;
        case sprFishMenuSelected:   return spr.Parrot[b].MenuSelected;
        case sprFishMenuSelect:     return spr.Parrot[b].Idle;
        case sprFishMenuDeselect:   return spr.Parrot[b].Idle;
        case sprChickenFeather:     return spr.Parrot[b].Feather;
    }
    return mskNone;

/// Lock Status
#define race_avail
    return unlock_get("parrot");

#define race_lock
    return "REACH @1(sprInterfaceIcons)1-1";

/// Skins
#define race_skins()
    return 2;

#define race_skin_avail(_skin)
    if(_skin == 0) return true;
    return unlock_get("parrot_" + chr(97 + _skin) + "skin");

#define race_skin_name(_skin)
    if(race_skin_avail(_skin)){
        return chr(65 + _skin) + " SKIN";
    }
    else switch(_skin){
        case 0: return "EDIT THE SAVE FILE LMAO";
        case 1: return "COMPLETE THE#AQUATIC ROUTE";
    }

/// Text Stuff
#define race_ttip
    if(GameCont.level >= 10 && chance(1, 5)){
        return choose("migration formation", "charmed, i'm sure", "adventuring party", "free as a bird");
    }
    else{
        return choose("hitchhiker", "birdbrain", "parrot is an expert traveler", "wind under my wings", "parrot likes camping", "macaw works too", "chests give you @rfeathers@s");
    }

#define race_ultra_name
    switch (argument0) {
        case 1: return "FLOCK TOGETHER";
        case 2: return "UNFINISHED";
        default: return "";
    }
    
#define race_ultra_text
    switch (argument0) {
        case 1: return "CORPSES SPAWN @rFEATHERS@s";
        case 2: return "N/A";
        default: return "";
    }


#define create
    feather_ammo = 0;
    feather_load = 0;
    feather_targ_delay = 0;

     // Extra Pet Slot:
    pet = [noone, noone];

     // Parrot Perch Bobbing:
    parrot_bob = [0, 1, 1, 0];

#define game_start
    wait 0;

     // Starter Pet + Extra Pet Slot:
    if(instance_exists(self)){
        with(Pet_spawn(x, y, "Parrot")) {
            leader = other;
            other.pet[0] = id;
        }
    }

     // Wait Until Level is Generated:
    if(fork()){
        while(instance_exists(GenCont)) wait 0;

         // Starting Feather Ammo:
        if(instance_exists(self)){
            repeat(12) with(obj_create(x + orandom(16), y + orandom(16), "ParrotFeather")){
                target = other;
                creator = other;
                bskin = other.bskin;
                speed *= 3;
            }
        }

        exit;
    }

#define step
     /// ACTIVE : Charm
    if(button_check(index, "spec") || usespec > 0){
        var _feathers = instances_matching(instances_named(CustomObject, "ParrotFeather"), "creator", id),
            _feathersTargeting = instances_matching(_feathers, "canhold", true),
            _featherNum = 12;

         // Shooty Charm Feathers:
        if(array_length(_feathersTargeting) < _featherNum){
             // Retrieve Feathers:
            with(instances_matching(_feathers, "canhold", false)){
                canhold = true;

                 // Remove Charm Time:
                if(target != other){
                    with(target) if("charm" in self && charm.time > 0){
                        charm.time -= other.stick_time;
                        if(charm.time <= 0){
                            scrCharm(id, false);
                        }
                    }
                }

                 // Penalty:
                if(stick_time < stick_time_max){
                    stick_time -= 15;
                }

                 // Unstick:
                if(stick){
                    stick = false;
                    motion_add(random(360), 4);
                }

                target = other;
                array_push(_feathersTargeting, id);
                other.feather_targ_delay = 3;
            }

             // Excrete New Feathers:
            while(array_length(_feathersTargeting) < _featherNum && (feather_ammo > 0 || infammo != 0)){
                if(infammo == 0) feather_ammo--;

                 // Feathers:
                with(obj_create(x + orandom(4), y + orandom(4), "ParrotFeather")){
                    creator = other;
                    target = other;
                    bskin = other.bskin;
                    array_push(_feathersTargeting, id);
                }

                 // Effects:
                sound_play_pitchvol(sndSharpTeeth, 3 + random(3), 0.4);
            }
        }

         // Targeting:
        if(feather_targ_delay > 0){
            feather_targ_delay -= current_time_scale;
            with(_feathers) target = other;
        }
        else{
            var r = 32,
                _x = mouse_x[index],
                _y = mouse_y[index],
                _targ = [],
                _featherNum = array_length(_feathersTargeting);
    
            with(instance_rectangle_bbox(_x - r, _y - r, _x + r, _y + r, [enemy, RadMaggotChest])){
                if(collision_circle(_x, _y, r, id, true, false)){
                    array_push(_targ, id);
                    if(array_length(_targ) >= _featherNum) break;
                }
            }

            if(array_length(_targ) <= 0){
                with(_feathersTargeting) target = other;
            }
            else{
                var n = 0;
                with(_targ){
                    var i = 0,
                        _take = max(ceil(_featherNum / array_length(_targ)), 1);
    
                    while(n < _featherNum && i < _take){
                        with(_feathersTargeting[n]){
                            target = other;
                        }
                        n++;
                        i++;
                    }
                }
            }
        }
    }

     /// ULTRA A: Flock Together
     // probably incredibly busted
    if(ultra_get(mod_current, 1)) {
        with(instances_matching(Corpse, "flock_together", null)) {
            flock_together = 1;
            // Hacky but me lazy:
            with(other) {
                with(obj_create(other.x + orandom(8), other.y + orandom(8), "ParrotFeather")){
                    target = other;
                    creator = other;
                    bskin = other.bskin;
                }
            }
        }
    }

#define draw
    /*if(button_check(index, "spec")){
        draw_text_nt(x, y - 32, string(feather_ammo));
        
        var t = nearest_instance(mouse_x[index], mouse_y[index], instances_matching([enemy, RadMaggotChest], "", null));
        draw_sprite_ext(t.sprite_index, t.image_index, t.x, t.y, (t.image_xscale + sin((current_frame div (3 * current_time_scale))/2)/4) * t.right, t.image_yscale + sin((current_frame div (3 * current_time_scale))/2)/4, t.image_angle, c_red, t.image_alpha * 0.7)
    }*/


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