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

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)

#define step
    if(button_pressed(0, "horn")){
        mod_script_call("mod", "telib", "Pet_create", mouse_x[0], mouse_y[0], "Parrot");
    }


#define Parrot_create
     // Visual:
    spr_idle = spr.PetParrotIdle;
    spr_walk = spr.PetParrotWalk;
    spr_hurt = spr.PetParrotHurt;
    depth = -3;

     // Vars:
    maxspd = 3.5;
    perched = false;
    pickup = noone;
    pickup_x = 0;
    pickup_y = 0;
    pickup_held = false;

#define Parrot_step
     // Grabbing Pickup:
    if(instance_exists(pickup)){
        if(pickup_held){
            if(pickup.x == pickup_x && pickup.y == pickup_y){
                with(pickup){
                    x = other.x;
                    y = other.y + 4;
                    xprevious = x;
                    yprevious = y;
                }
                pickup_x = pickup.x;
                pickup_y = pickup.y;
            }
            else other.pickup = noone;
        }

         // Grab Pickup:
        else if(place_meeting(x, y, pickup)){
            pickup_held = true;
            pickup_x = pickup.x;
            pickup_y = pickup.y;
        }
    }
    else pickup_held = false;

     // Perch on Leader's Head:
    if(instance_exists(leader) && leader.race != "horror"){ // Horror is too painful to stand on
        var _x = leader.x,
            _y = leader.bbox_top - 8;
    
        if(perched){
            x = leader.x;
            y = leader.y;
            if(leader.speed > 0 || instance_exists(pickup)){
                x = _x;
                y = _y;
                perched = false;
                scrWalk(16, random(360));
            }
        }

         // Perch:
        else if(point_distance(x, y, _x, _y) < 8 && leader.speed <= 0 && !instance_exists(pickup)){
            perched = true;
            sound_play_pitch(sndBouncerBounce, 1.5 + orandom(0.1));
        }
    }
    else perched = false;

#define Parrot_alrm0(_leaderDir, _leaderDis)
    if(instance_exists(leader)){
         // Fly Toward Pickup:
        if(instance_exists(pickup)){
            if(!pickup_held){
                scrWalk(8, point_direction(x, y, pickup.x, pickup.y));
                return walk;
            }
        }
        else{
            pickup_held = false;
            var _pickup = nearest_instance(x, y, instances_matching(Pickup, "object_index", AmmoPickup, HPPickup, RoguePickup))
            if(instance_exists(_pickup)){
                if(!collision_line(x, y, _pickup.x, _pickup.y, Wall, false, false)){
                    pickup = _pickup;
                    return 1;
                }
            }
        }

         // Fly Toward Leader:
        if(!perched){
            scrWalk(10 + random(10), _leaderDir + orandom(30));
            if(_leaderDis > 32) return walk;
        }

        else{
             // Look Around:
            scrRight(random(360));

             // Repeat sound:
            if(random(3) < 1) with(leader){
                sound_play_pitchvol(sndSaplingSpawn, 1.8 + random(0.2), 0.4);
                sound_play_pitchvol(choose(snd_wrld, snd_chst, snd_crwn), 2, 0.4);
                return 40 + random(20);
            }
        }
    }
    else scrRight(random(360));

    return (30 + random(30));

#define Parrot_draw
     // Perched:
    if(instance_exists(leader) && perched){
        var _uvsStart = sprite_get_uvs(leader.sprite_index, 0),
            _uvsCurrent = sprite_get_uvs(leader.sprite_index, leader.image_index),
            _x = leader.x,
            _y = leader.y - sprite_get_yoffset(leader.sprite_index) + sprite_get_bbox_top(leader.sprite_index) - 4;

         // Manual Bobbing:
        if(_uvsStart[0] == 0 && _uvsStart[2] == 1 && "parrot_bob" in leader){
            with(leader){
                var _bob = parrot_bob;
                _y += _bob[floor(image_index mod array_length(_bob))];
            }
        }

         // Auto Bobbing:
        else _y += (_uvsCurrent[5] - _uvsStart[5]);

        draw_sprite_ext(sprite_index, image_index, _x, _y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
    }

     // Normal:
    else draw_self_enemy();


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
#define lightning_connect(_x1, _y1, _x2, _y2, _arc)                                     return  mod_script_call("mod", "teassets", "lightning_connect", _x1, _y1, _x2, _y2, _arc);
#define scrLightning(_x1, _y1, _x2, _y2, _enemy)                                        return  mod_script_call("mod", "teassets", "scrLightning", _x1, _y1, _x2, _y2, _enemy);
#define scrCharm(_instance, _charm)                                                     return  mod_script_call("mod", "teassets", "scrCharm", _instance, _charm);
#define scrCharmTarget()                                                                return  mod_script_call("mod", "teassets", "scrCharmTarget");
#define scrBossHP(_hp)                                                                  return  mod_script_call("mod", "teassets", "scrBossHP", _hp);
#define scrBossIntro(_name, _sound, _music)                                                     mod_script_call("mod", "teassets", "scrBossIntro", _name, _sound, _music);
#define scrWaterStreak(_x, _y, _dir, _spd)                                              return  mod_script_call("mod", "teassets", "scrWaterStreak", _x, _y, _dir, _spd);
#define scrRadDrop(_x, _y, _raddrop, _dir, _spd)                                        return  mod_script_call("mod", "teassets", "scrRadDrop", _x, _y, _raddrop, _dir, _spd);
#define scrSetPet(_pet)                                                                 return  mod_script_call("mod", "teassets", "scrSetPet", _pet);
#define orandom(n)                                                                      return  mod_script_call("mod", "teassets", "orandom", n);
#define floor_ext(_num, _round)                                                         return  mod_script_call("mod", "teassets", "floor_ext", _num, _round);
#define array_count(_array, _value)                                                     return  mod_script_call("mod", "teassets", "array_count", _array, _value);
#define array_flip(_array)                                                              return  mod_script_call("mod", "teassets", "array_flip", _array);
#define instances_named(_object, _name)                                                 return  mod_script_call("mod", "teassets", "instances_named", _object, _name);
#define nearest_instance(_x, _y, _instances)                                            return  mod_script_call("mod", "teassets", "nearest_instance", _x, _y, _instances);
#define instances_seen(_obj, _ext)                                                      return  mod_script_call("mod", "teassets", "instances_seen", _obj, _ext);
#define frame_active(_interval)                                                         return  mod_script_call("mod", "teassets", "frame_active", _interval);
#define area_generate(_x, _y, _area)                                                    return  mod_script_call("mod", "teassets", "area_generate", _x, _y, _area);
#define scrFloorWalls()                                                                 return  mod_script_call("mod", "teassets", "scrFloorWalls");
#define floor_reveal(_floors, _maxTime)                                                 return  mod_script_call("mod", "teassets", "floor_reveal", _floors, _maxTime);
#define area_border(_y, _area, _color)                                                  return  mod_script_call("mod", "teassets", "area_border", _y, _area, _color);
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call("mod", "teassets", "area_get_sprite", _area, _spr);
#define in_range(_num, _lower, _upper)                                                  return  mod_script_call("mod", "teassets", "in_range", _num, _lower, _upper);