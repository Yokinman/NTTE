#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.save = mod_variable_get("mod", "teassets", "save");

    global.debug_lag = false;

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.save
#macro opt sav.option

#macro DebugLag global.debug_lag

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)


#define ClamChest_create(_x, _y)
    with(obj_create(_x, _y, "CustomChest")){
         // Visual:
        sprite_index = sprClamChest;
        spr_open = sprClamChestOpen;

         // Sound:
        snd_open = sndOasisChest;

        on_open = script_ref_create(ClamChest_open);

        return id;
    }

#define ClamChest_open
    var w = ["harpoon", "netlauncher", "bubble rifle", "bubble shotgun", "bubble minigun", "lightning ring launcher", "super lightning ring launcher"],
        _wep = "";

     // Random Cool Wep:
    var m = 0;
    do _wep = w[irandom(array_length(w) - 1)];
    until (mod_exists("weapon", _wep) || ++m > 200);

    if(mod_exists("weapon", _wep)){
        with(instance_create(x, y, WepPickup)){
            wep = _wep;
            ammo = true;
            
             // Unlock new weapon:
            if(!unlock_get(_wep)){
                unlock_set(_wep, true);
                sound_play(sndGoldUnlock);
                scrUnlock(weapon_get_name(_wep), "YOU'LL SEE IT AGAIN", -1, -1);
            }
        }
    }

     // Angry puffer cause you dont have cool weapons loaded
    else with(obj_create(x, y, "Puffer")){
        instance_create(x, y, AssassinNotice);
    }


#define HammerHead_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
         // Visual:
		spr_idle = spr.HammerheadIdle;
		spr_walk = spr.HammerheadIdle;
		spr_hurt = spr.HammerheadHurt;
		spr_dead = spr.HammerheadDead;
		spr_chrg = spr.HammerheadChrg;
		spr_shadow = shd48;
		spr_shadow_y = 2;
		hitid = [spr_idle, "HAMMERHEAD"];
		depth = -2;

         // Sound:
		snd_hurt = sndSalamanderHurt;
		snd_dead = sndOasisDeath;
		snd_mele = sndBigBanditMeleeHit;

		 // Vars:
		mask_index = mskScorpion;
		maxhealth = 40;
		raddrop = 12;
		size = 2;
		walk = 0;
		walkspd = 0.8;
		maxspeed = 4;
		meleedamage = 4;
		direction = random(360);
		rotate = 0;
		charge = 0;
		charge_dir = 0;
		charge_wait = 0;

		 // Alarms:
		alarm1 = 40 + random(20);

		 // NTTE:
		ntte_anim = false;

		return id;
	}

#define Hammerhead_step
    if(sprite_index != spr_chrg) enemySprites();

     // Swim in a circle:
    if(rotate != 0){
        rotate -= clamp(rotate, -1, 1) * current_time_scale;
        direction += rotate;
        if(speed > 0) scrRight(direction);
    }

     // Charge:
    if(charge > 0 || charge_wait > 0){
        direction += angle_difference(charge_dir + (sin(charge / 5) * 20), direction) / 3;
        scrRight(direction);
    }
    if(charge_wait > 0){
        charge_wait -= current_time_scale;

        x += orandom(1);
        y += orandom(1);
        x -= lengthdir_x(charge_wait / 5, charge_dir);
        y -= lengthdir_y(charge_wait / 5, charge_dir);
        sprite_index = choose(spr_hurt, spr_chrg);

         // Start Charge:
        if(charge_wait <= 0){
            sound_play_pitch(sndRatkingCharge, 0.4 + random(0.2));
            view_shake_at(x, y, 15);
        }
    }
    else if(charge > 0){
        charge -= current_time_scale;

        if(sprite_index != spr_hurt) sprite_index = spr_chrg;

         // Fast Movement:
        motion_add(direction, 3);
        scrRight(direction);

         // Break Walls:
        if(place_meeting(x + hspeed, y + vspeed, Wall)){
            with(Wall) if(place_meeting(x - other.hspeed, y - other.vspeed, other)){
                 // Effects:
                if(chance(1, 2)) with(instance_create(x + 8, y + 8, Hammerhead)){
                    motion_add(random(360), 1);
                }
                instance_create(x, y, Smoke);
                sound_play_pitchvol(sndHammerHeadProc, 0.75, 0.5);

                instance_create(x, y, FloorExplo);
                instance_destroy();
            }
        }

         // Effects:
        if(current_frame_active){
            with(instance_create(x + orandom(8), y + 8, Dust)){
                motion_add(random(360), 1)
            }
        }
        if !(charge mod 5) view_shake_at(x, y, 10);

         // Charge End:
        if(charge <= 0){
            sprite_index = spr_idle;
            sound_play_pitch(sndRatkingChargeEnd, 0.6);
        }
    }

#define Hammerhead_alrm1
    alarm1 = 30 + random(20);

    target = instance_nearest(x, y, Player);

    if(in_distance(target, 256)){
        var _targetDir = point_direction(x, y, target.x, target.y);

        if(in_sight(target)){
             // Close Range Charge:
            if(in_distance(target, 96) && chance(3, 4)){
                charge = 15 + random(10);
                charge_wait = 15;
                charge_dir = _targetDir;
                sound_play_pitchvol(sndHammerHeadEnd, 0.6, 0.25);
            }

             // Move Towards Target:
            else{
                scrWalk(30, _targetDir + orandom(20));
                rotate = orandom(20);
            }
        }

        else{
             // Charge Through Walls:
            if(my_health < maxhealth && chance(1, 3)){
                charge = 30;
                charge_wait = 15;
                charge_dir = _targetDir;
                alarm1 = charge + charge_wait + random(10);
                sound_play_pitchvol(sndHammerHeadEnd, 0.6, 0.25);
            }

             // Movement:
            else{
                rotate = orandom(30);
                scrWalk(20 + random(10), _targetDir + orandom(90));
            }
        }
    }

     // Passive Movement:
    else{
        scrWalk(30, direction);
        scrRight(direction);
        rotate = orandom(30);
        alarm1 += random(walk);
    }

    scrRight(direction);

#define Hammerhead_death
    pickup_drop(30, 8);


#define PetBite_create(_x, _y)
    with(instance_create(_x, _y, CustomSlash)){
         // Visual:
        sprite_index =  mskNone;
        mask_index =    mskWepPickup;
        
         // Vars:
        damage = 8 + (GameCont.level * 3);
        force = 2;
        
        return id;
    }
     
#define PetBite_hit
    if(projectile_canhit(other)) projectile_hit(other, damage, force, direction);

#define Puffer_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
         // Visual:
		spr_idle = spr.PufferIdle;
		spr_walk = spr.PufferIdle;
		spr_hurt = spr.PufferHurt;
		spr_dead = spr.PufferDead;
		spr_chrg = spr.PufferChrg;
		spr_fire = spr.PufferFire[0, 0];
		spr_shadow = shd16;
		spr_shadow_y = 7;
		hitid = [spr_idle, "PUFFER"];
		depth = -2;

         // Sound:
        snd_hurt = sndOasisHurt;
        snd_dead = sndOasisDeath;

         // Vars:
		mask_index = mskFreak;
        maxhealth = 10;
		raddrop = 4;
		size = 1;
		walk = 0;
		walkspd = 0.8;
		maxspeed = 3;
		meleedamage = 2;
		direction = random(360);
		blow = 0;

         // Alarms:
        alarm1 = 40 + random(80);

		 // NTTE:
		ntte_anim = false;

        return id;
    }

#define Puffer_step
     // Animate:
    if(sprite_index != spr_fire){
        if(sprite_index != spr_chrg) enemySprites();

         // Charged:
        else if(anim_end) blow = 1;
    }

     // Puffering:
    if(blow > 0){
        blow -= 0.03 * current_time_scale;

         // Blowing:
        motion_add_ct(direction + (10 * sin(current_frame / 6)), 2);
        scrRight(direction + 180);

         // Effects:
        if(chance_ct(3, 4)){
            var l = 8, d = direction + 180;
            with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), Bubble)){
                motion_add(d, 3);
            }
            sound_play_pitchvol(sndRoll, 1.2 + random(0.4), 0.6);
        }

         // Animate:
        var _sprFire = spr.PufferFire,
            _blowLvl = clamp(floor(blow * array_length(_sprFire)), 0, array_length(_sprFire) - 1),
            _back = (direction > 180);

        spr_fire = _sprFire[_blowLvl, _back];
        sprite_index = spr_fire;
    }
    else if(sprite_index == spr_fire) sprite_index = spr_idle;

#define Puffer_draw
    var h = (sprite_index != spr_hurt && nexthurt > current_frame + 3);
    if(h) d3d_set_fog(1, image_blend, 0, 0);
    draw_self_enemy();
    if(h) d3d_set_fog(0, 0, 0, 0);

#define Puffer_alrm1
    alarm1 = 20 + random(30);
    target = instance_nearest(x, y, Player);

    if(blow <= 0){
        if(instance_exists(target)){
            var _targetDir = point_direction(x, y, target.x, target.y);

             // Puff Time:
            if(in_sight(target) && in_distance(target, 256) && chance(1, 2)){
                alarm1 = 30;

                scrWalk(8, _targetDir);
                scrRight(direction + 180);
                sprite_index = spr_chrg;
                image_index = 0;

                 // Effects:
                repeat(3) instance_create(x, y, Dust);
                sound_play_pitch(sndOasisCrabAttack, 0.8);
                sound_play_pitchvol(sndBouncerBounce, 0.6 + orandom(0.2), 2);
            }

             // Get Closer:
            else scrWalk(alarm1, _targetDir + orandom(20));
        }

         // Passive Movement:
        else scrWalk(10, random(360));
    }

#define Puffer_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    motion_add(_hitdir, _hitvel);	// Knockback
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);  // Sound

     // Hurt Sprite:
    if(sprite_index != spr_fire && sprite_index != spr_chrg){
        sprite_index = spr_hurt;
        image_index = 0;
    }

#define Puffer_death
    pickup_drop(30, 0);

     // Powerful Death:
    var _num = 3;
    if(blow > 0) _num *= ceil(blow * 4);
    if(sprite_index == spr_chrg) _num += image_index;
    if(_num > 3){
        sound_play_pitch(sndOasisExplosionSmall, 1 + random(0.2));
        sound_play_pitchvol(sndOasisExplosion, 0.8 + random(0.4), _num / 15);
    }
    while(_num-- > 0){
        with(instance_create(x, y, Bubble)){
            motion_add(random(360), _num / 2);
            hspeed += other.hspeed / 3;
            vspeed += other.vspeed / 3;
            friction *= 2;
        }
    }


#define Crack_create(_x, _y)
    with(instance_create(_x, _y, CustomObject)){
         // Visual:
        sprite_index = spr.Crack;
        image_speed = 0;

         // Vars:
        mask_index = mskWepPickup;

        return id;
    }

#define Crack_step
    if !image_index{
        if place_meeting(x, y, Player){
            image_index = 1;
             // Open effects:
            // sound_play_pitchvol(sndFlameCannon,     0.8, 0.3);
            sound_play_pitchvol(sndPillarBreak,     0.8, 1.2);
            sound_play_pitchvol(sndOasisPortal,     1.0, 0.3);
            sound_play_pitchvol(sndSnowTankShoot,   0.6, 0.3);
            
            sleep(50);
            view_shake_at(x, y, 20);
            
            repeat(5 + irandom(5)) with instance_create(x, y, Debris)
                motion_set(random(360), 3 + random(5));
                
            repeat(10 + irandom(10)) with instance_create(x, y, Bubble)
                motion_set(random(360), 1 + random(2));
                
             // Portal
            with instance_create(x, y, Portal){
                sound_stop(sndPortalOpen);
                image_alpha = 0;
                GameCont.area = "trench";
                GameCont.subarea = 0;
            }
        }
        
         // Bubble effects:
        else if(chance_ct(1, 4)){
            with(instance_create(x, y, Bubble)){
                motion_set(90 + orandom(5), 4 + random(3));
                friction = 0.2;
            }
        }
    }


/// Scripts
#define orandom(n)																		return  random_range(-n, n);
#define chance(_numer, _denom)															return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)														return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
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
#define floor_ext(_num, _round)                                                         return  mod_script_call(   "mod", "telib", "floor_ext", _num, _round);
#define array_count(_array, _value)                                                     return  mod_script_call(   "mod", "telib", "array_count", _array, _value);
#define array_flip(_array)                                                              return  mod_script_call(   "mod", "telib", "array_flip", _array);
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
#define array_delete(_array, _index)                                                    return  mod_script_call_nc("mod", "telib", "array_delete", _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call_nc("mod", "telib", "array_delete_value", _array, _value);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "instances_at", _x, _y, _obj);
#define Pet_spawn(_x, _y, _name)                                                        return  mod_script_call(   "mod", "telib", "Pet_spawn", _x, _y, _name);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc("mod", "telib", "scrFX", _x, _y, _motion, _obj);
#define array_combine(_array1, _array2)                                                 return  mod_script_call(   "mod", "telib", "array_combine", _array1, _array2);
#define player_create(_x, _y, _index)                                                   return  mod_script_call(   "mod", "telib", "player_create", _x, _y, _index);
#define draw_set_flat(_color)                                                                   mod_script_call(   "mod", "telib", "draw_set_flat", _color);
#define trace_error(_error)                                                                     mod_script_call_nc("mod", "telib", "trace_error", _error);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc("mod", "telib", "sleep_max", _milliseconds);
#define array_clone_deep(_array)                                                        return  mod_script_call_nc("mod", "telib", "array_clone_deep", _array);
#define lq_clone_deep(_obj)                                                             return  mod_script_call_nc("mod", "telib", "lq_clone_deep", _obj);
#define array_exists(_array, _value)                                                    return  mod_script_call_nc("mod", "telib", "array_exists", _array, _value);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc("mod", "telib", "wep_merge", _stock, _front);