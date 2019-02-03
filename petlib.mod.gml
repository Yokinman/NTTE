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

#define chat_command(_cmd, _arg, _ind)
    switch(_cmd){
        case "pet":
            mod_script_call("mod", "telib", "Pet_create", mouse_x[_ind], mouse_y[_ind], _arg);
            return true;
    }

#define CoolGuy_create
     // Visual:
    spr_idle = spr.PetCoolGuyIdle;
    spr_walk = spr.PetCoolGuyWalk;
    spr_hurt = spr.PetCoolGuyHurt;
    depth = -2;

     // Vars:
    maxspd = 3;
    
#define CoolGuy_step
    with(instances_matching(HPPickup, "coolguy", null)) {
        coolguy = 1;
         // Healthy Pizza:
        num++;
        sprite_index = sprSlice;
    }


#define Mimic_create
     // Visual:
    spr_idle = spr.PetMimicIdle;
    spr_walk = spr.PetMimicWalk;
    spr_hurt = spr.PetMimicHurt;
    spr_open = spr.PetMimicOpen;
    spr_hide = spr.PetMimicHide;
    depth = -1;
    
     // Vars:
    mask_index = mskFreak;
    maxspd = 2;
    can_tp = false;
    wep = wep_none;
    ammo = true;
    curse = false;
    open = false;
    hush = 0;
    hushtime = 0;

#define Mimic_anim
    if(sprite_index != spr_hurt || anim_end){
        if(speed > 0) sprite_index = spr_walk;
        else if(sprite_index != spr_walk || in_range(image_index, 3, 3 + image_speed)){
            if(instance_exists(leader)) sprite_index = spr_idle;
            else sprite_index = spr_hide;
        }
    }

#define Mimic_step
    if hushtime <= 0 hush = max(hush - 0.1, 0);
    hushtime -= current_time_scale;

    if(instance_exists(leader)){
         // Open Chest:
        if(place_meeting(x, y, Player)){
            walk = 0;
            sprite_index = spr_open;
            if(!open){
                open = true;

                 // Drop Weapon:
                if(wep != wep_none){
                    with(instance_create(x, y, WepPickup)){
                        wep = other.wep;
                        ammo = other.ammo;
                        curse = other.curse;
                    }
                    wep = wep_none;
                }

                 // Effects:
                sound_play_pitchvol(sndGoldChest, 0.9 + random(0.2), 1 - hush);
                sound_play_pitchvol(sndMimicSlurp, 0.9 + random(0.2), 1 - hush);
                with(instance_create(x, y, FXChestOpen)) depth = other.depth - 1;
                hush = min(hush + 0.2, 0.6);
                hushtime = 30;
            }

             // Not Holding Weapon:
            if(wep == wep_none && !place_meeting(x, y, WepPickup)){
                 // Place Weapon:
                with(Player) if(place_meeting(x, y, other) && button_pressed(index, "pick")){
                    if(canpick && wep != wep_none){
                        if(!curse){
                            with(instance_create(other.x, other.y, WepPickup)) wep = other.wep;
                            wep = wep_none;
                            scrSwap();

                             // Effects:
                            sound_play(sndSwapGold);
                            sound_play(sndWeaponPickup);
                            with(other) with(instance_create(x + orandom(4), y + orandom(4), CaveSparkle)){
                                depth = other.depth - 1;
                            }

                            break;
                        }
                        else sound_play(sndCursedReminder);
                    }
                }

                 // Draw Indicator:
                if(instance_exists(TopCont)){
                    script_bind_draw(Mimic_draw_indicator, TopCont.depth, id);
                }
            }
        }

         // Regrab Weapon:
        else if(open){
            open = false;
            if(wep == wep_none){
                if(place_meeting(x, y, WepPickup)){
                    with(instance_nearest(x, y, WepPickup)){
                        other.wep = wep;
                        other.ammo = ammo;
                        other.curse = curse;
                        instance_destroy();
                    }
                }
            }
        }
    }
    
     // Sparkle:
    if(frame_active(10 + orandom(2))){
        instance_create(x + orandom(12), y + orandom(12), CaveSparkle);
    }

#define Mimic_alrm0(_leaderDir, _leaderDis)
    if(instance_exists(leader)){
        if(_leaderDis > 48){
            scrWalk(20 + irandom(30), _leaderDir + orandom(10));
            scrRight(direction);
        }
    }
    
    return 30 + irandom(30);

#define Mimic_draw
    draw_self_enemy();

     // Wep Depth Fix:
    if(place_meeting(x, y, WepPickup)){
        with(WepPickup) if(place_meeting(x, y, other)){
            event_perform(ev_draw, 0);
        }
    }

#define Mimic_draw_indicator(_inst)
    instance_destroy();
    with(_inst) draw_sprite(sprEPickup, 0, x, y - 7);


#define Parrot_create
     // Visual:
    spr_idle = spr.PetParrotIdle;
    spr_walk = spr.PetParrotWalk;
    spr_hurt = spr.PetParrotHurt;
    depth = -3;

     // Vars:
    maxspd = 3.5;
    tp_distance = 160;
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

#define Parrot_hurt
    sprite_index = spr_hurt;
    image_index = 0;

     // Movin'
    scrWalk(maxspd, point_direction(other.x, other.y, x, y));
    var o = 6;
    x += lengthdir_x(o, direction);
    y += lengthdir_y(o, direction);

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

#define Prism_create
     // Visual:
    spr_idle = spr.PetPrismIdle;
    spr_walk = spr.PetPrismIdle;
    depth = -3;

     // Vars:
    maxspd = 3;
    tp_distance = 120;
    spawn_loc = [x, y];
    alarm0 = -1;
    
#define Prism_step
    repeat(irandom(4)) instance_create(x + orandom(4), y + orandom(4), Curse);
    
    if(instance_exists(leader)) {
         // Aimlessly Floats
        scrWalk(1, direction);
        
         // Duplicate Friendly Bullets:
        with(instances_matching(projectile, "team", leader.team)) if(place_meeting(x, y, other) and "prism_duplicate" not in self) {
            prism_duplicate = 1;
            
             // Duplicate and Adjust:
            with(instance_copy(false)) { direction += orandom(20); image_angle = direction; }
            direction += orandom(20);
            image_angle = direction;
            
             // Effects:
            sound_play_pitch(sndCrystalShield, 1.40 + orandom(0.10));
            instance_create(x + orandom(4), y + orandom(4), CaveSparkle);
        }
    } else {
         // Jitters Around:
        if(random(30) < 1) {
             // Decide Which Floor:
            var f = instance_nearest(spawn_loc[0] + orandom(64), spawn_loc[1] + orandom(64), Floor);
            var fx = f.x + (f.sprite_width/2);
            var fy = f.y + (f.sprite_height/2);
            
             // Teleport:
            x = fx;
            y = fy;
            
             // Effects:
            sound_play_pitch(sndCrystalTB, 1.20 + orandom(0.10));
            repeat(irandom_range(4, 8)) instance_create(x + orandom(4), y + orandom(4), Curse);
        }
    }

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
#define scrSwap()                                                                       return  mod_script_call("mod", "teassets", "scrSwap");
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