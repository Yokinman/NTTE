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
#macro anim_end (image_index > image_number - 1 + image_speed)


#define InvMortar_step
    if random(3) < current_time_scale
        instance_create(x + orandom(8), y + orandom(8), Curse);

    Mortar_step();

#define InvMortar_hurt(_hitdmg, _hitvel, _hitdir)
    Mortar_hurt(_hitdmg, _hitvel, _hitdir);

    if my_health > 0 && random(1) < _hitdmg / 25{
        var _a = instances_matching([InvLaserCrystal, InvSpider], "", null),
            _n = array_length(_a),
            _x = x,
            _y = y;

         // Swap places with another dude:
        if _n{
            with(_a[irandom(_n-1)]){
                other.x = x;
                other.y = y;
                x = _x;
                y = _y;
                nexthurt = current_frame + 6;

                 // Unstick from walls by annihilating them:
                with instance_create(x, y, PortalClear)
                    mask_index = other.mask_index;

                 // Effects:
                sprite_index = spr_hurt;
                image_index = 0;
                sleep(15);
                view_shake_at(x, y, 12);
            }

             // Unstick from walls by annihilating them:
            with instance_create(x, y, PortalClear)
                mask_index = other.mask_index;
        }
    }


#define Mortar_step
     // Animate:
    if(sprite_index != spr_hurt and sprite_index != spr_fire){
    	if(speed <= 0) sprite_index = spr_idle;
    	else if(sprite_index == spr_idle) sprite_index = spr_walk;
    }
    else{
         // End Hurt Sprite:
        if(sprite_index = spr_hurt and image_index > 2) sprite_index = spr_idle;

         // End Fire Sprite:
        if(sprite_index = spr_fire && (image_index > sprite_get_number(spr_fire) - 1)){
            sprite_index = spr_idle;
        }
    }

     // Charging effect:
    if sprite_index == spr_fire && random(5) < current_time_scale{
        var _x = x + 6 * right,
            _y = y - 16,
            _l = irandom_range(16, 24),
            _d = irandom(359);
        with instance_create(_x + lengthdir_x(_l, _d), _y + lengthdir_y(_l, _d), LaserCharge){
            depth = other.depth - 1;
            motion_set(_d + 180, random_range(1,2));
            alarm0 = point_distance(x, y, _x, _y) / speed;
        }
    }

     // Movement:
    enemyWalk(walkspd, maxspd);

#define Mortar_draw
     // Flash White w/ Hurt While Firing:
    if(
        sprite_index == spr_fire &&
        nexthurt > current_frame &&
        (nexthurt + current_frame) mod (room_speed/10) = 0
    ){
        d3d_set_fog(true, c_white, 0, 0);
        draw_self_enemy();
        d3d_set_fog(false, c_black, 0, 0);
    }

     // Normal Self:
    else draw_self_enemy();

#define Mortar_alrm1
    alarm1 = 80 + random(20);
    target = instance_nearest(x, y, Player);

     // Near Target:
    if(target_in_distance(0, 240)){
        var _targetDir = point_direction(x, y, target.x, target.y);

         // Attack:
        if(random(3) < 1){
            ammo = 4;
            alarm2 = 26;
            sprite_index = spr_fire;
            sound_play(sndCrystalJuggernaut);
        }

         // Move Towards Target:
        else{
            walk = 15 + random(30);
            direction = _targetDir + orandom(15);
            alarm1 = 40 + irandom(40);
        }

         // Facing:
        scrRight(_targetDir);
    }

     // Passive Movement:
    else{
        walk = 10;
        alarm1 = 50 + irandom(30);
        direction = random(360);
        scrRight(direction);
    }

#define Mortar_alrm2
    if(ammo > 0){
        target = instance_nearest(x, y, Player);

        if(target < 0)
        exit;

        var _targetDir = point_direction(x, y, target.x, target.y) + orandom(6);

         // Sound:
        sound_play(sndCrystalTB);
        sound_play(sndPlasma);

         // Facing:
        scrRight(_targetDir);

         // Shoot Mortar:
        with(scrEnemyShootExt(x + (5 * right), y, "MortarPlasma", _targetDir, 3)){
            z += 18;
            depth = 12;
            zspeed = ((point_distance(x, y, other.target.x + orandom(16), other.target.y + orandom(16)) - z) * zfric) / (speed * 2);

             // Cool particle line
            var _x = x,
                _y = y,
                _z = z,
                _zspd = zspeed,
                _zfrc = zfric,
                i = 0;

            while(_z > 0){
                with(instance_create(_x, _y - _z, BoltTrail)){
                    image_angle = point_direction(x, y, _x + other.hspeed, _y + other.vspeed - (_z + _zspd));
                    image_xscale = point_distance(x, y, _x + other.hspeed, _y + other.vspeed - (_z + _zspd));
                    image_yscale = random(1.5);
                    image_blend = make_color_rgb(235, 0, 67);
                    depth = -8;
                    if(random(6) < 1){
                        with(instance_create(x + orandom(8), y + orandom(8), LaserCharge)){
                            motion_add(point_direction(x, y, _x, _y - _z), 1);
                            alarm0 = (point_distance(x, y, _x, _y - _z) / speed) + 1;
                            depth = -8;
                        }
                    }
                }

                _x += hspeed;
                _y += vspeed;
                _z += _zspd;
                _zspd -= _zfrc;
                i++;
            }
            var _ang = random(360);
            for(var a = _ang; a < _ang + 360; a += 120 + orandom(30)){
                var l = 16,
                    _tx = _x,
                    _ty = _y;

                with(instance_create(_x + lengthdir_x(l, a), _y + lengthdir_y(l, a), LaserCharge)){
                    motion_add(point_direction(x, y, _tx, _ty), (point_distance(x, y, _tx, _ty) / i));
                    alarm0 = i;
                }
                i *= 3/4;
            }
            with(instance_create(_x, _y, CaveSparkle)) image_speed *= random_range(0.5, 1);
        }

        alarm2 = 4;
        ammo--;
    }

#define Mortar_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    motion_add(_hitdir, _hitvel);	// Knockback
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);	// Sound

     // Hurt Sprite:
    if(sprite_index != spr_fire){
        sprite_index = spr_hurt;
        image_index = 0;
    }


#define MortarPlasma_step
     // Rise & Fall:
    z_engine();
    depth = max(-z, -12);

     // Facing:
    if(in_range(direction, 30, 150) || in_range(direction, 210, 330)){
        image_index = round((point_direction(0, 0, speed, zspeed) + 90) / (360 / image_number));
        image_angle = direction;
    }
    else{
        if(zspeed > 5) image_index = 0;
        else if(zspeed > 2) image_index = 1;
        else image_index = 2;
        image_angle = point_direction(0, 0, hspeed, -zspeed);
    }

     // Trail:
    if(current_frame_active && random(2) < 1){
        with(instance_create(x + orandom(4), y - z + orandom(4), PlasmaTrail)) {
            sprite_index = spr.MortarTrail;
            depth = other.depth;
        }
    }

     // Hit:
    if(z <= 0) instance_destroy();

#define MortarPlasma_draw
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

     // Bloom:
    draw_set_blend_mode(bm_add);
    draw_sprite_ext(sprite_index, image_index, x, y - z, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
    draw_set_blend_mode(bm_normal);

#define MortarPlasma_hit
    // nada

#define MortarPlasma_wall
    // nada

#define MortarPlasma_destroy
    with(instance_create(x, y, PlasmaImpact)){
        sprite_index = spr.MortarImpact;
        team = other.team;
        creator = other.creator;
        hitid = other.hitid;
        damage = 2;
    }

     // Effects:
    view_shake_at(x, y, 8);
    sound_play(sndPlasmaHit);


#define NewCocoon_death
     // Hatch 1-3 Spiders:
    repeat(irandom_range(1, 3)) {
    	obj_create(x,y,"Spiderling");
    }


#define Spiderling_alrm0
     // Shhh dont tell anybody
    with(instance_create(x, y, Spider)){
        x = other.x;
        y = other.y;
        right = other.right;
        alarm1 = 10 + random(10);
    }

     // Effects
    for(var a = 0; a < 360; a += (360 / 6)){
        var o = random(8);
        with(instance_create(x + lengthdir_x(o, a), y + lengthdir_y(o, a), Smoke)){
            motion_add(a + orandom(20), 1 + random(1.5));
            depth = -3;
            with(instance_create(x, y, Dust)){
                depth = other.depth;
                motion_add(other.direction + orandom(90), 2);
            }
        }
    }
    for(var a = direction; a < direction + 360; a += (360 / 3)){
        with(instance_create(x, y, Shell)){
            motion_add(a + orandom(30), 3 + random(4));
            friction *= 2;
            sprite_index = sprHyperCrystalShard;
            image_index = random(image_number - 1);
            image_speed = 0;
            depth = 0;
        }
    }
    sound_play_hit(sndHitRock, 0.3);
    sound_play_hit(sndBouncerBounce, 0.5);
    sound_play_pitchvol(sndCocoonBreak, 2 + random(1), 0.8);

    instance_delete(id);

#define Spiderling_alrm1
    alarm1 = 10 + irandom(10);
    target = instance_nearest(x,y,Player);

     // Move towards player:
    if(target_is_visible() && target_in_distance(0, 96)){
        scrWalk(14, point_direction(x, y, target.x, target.y) + orandom(20));
    }

     // Wander:
    else scrWalk(12, direction + orandom(20));


/// Mod Events:
#define draw_shadows
    with(instances_matching(CustomProjectile, "name", "MortarPlasma")) if(visible){
        var _percent = clamp(96 / z, 0.1, 1),
            _w = ceil(18 * _percent),
            _h = ceil(6 * _percent);

        draw_ellipse(x - _w / 2, y - _h / 2, x + _w / 2, y + _h / 2, false);
    }

#define draw_dark // Drawing Grays
    draw_set_color(c_gray);

     // Mortar:
    with(instances_matching(CustomEnemy, "name", "Mortar", "InvMortar")){
        if(sprite_index == spr_fire){
            draw_circle(x + (6 * right), y - 16, 48 - alarm1 + orandom(4), false)
        }
    }

     // Mortar plasma:
    with(instances_matching(CustomProjectile, "name", "MortarPlasma")){
        draw_circle(x, y - z, 64 + orandom(1), false);
    }

#define draw_dark_end // Drawing Clear
    draw_set_color(c_black);

     // Mortar:
    with(instances_matching(CustomEnemy, "name", "Mortar", "InvMortar")){
        if(sprite_index == spr_fire){
            draw_circle(x + (6 * right), y - 16, 24 - alarm1 + orandom(4), false)
        }
    }

     // Mortar plasma:
    with(instances_matching(CustomProjectile, "name", "MortarPlasma")){
        draw_circle(x, y - z, 32 + orandom(1), false);
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
#define area_get_subarea(_area)                                                         return  mod_script_call(   "mod", "telib", "area_get_subarea", _area);
#define trace_lag()                                                                             mod_script_call(   "mod", "telib", "trace_lag");
#define trace_lag_bgn(_name)                                                                    mod_script_call(   "mod", "telib", "trace_lag_bgn", _name);
#define trace_lag_end(_name)                                                                    mod_script_call(   "mod", "telib", "trace_lag_end", _name);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call(   "mod", "telib", "instance_rectangle_bbox", _x1, _y1, _x2, _y2, _obj);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   "mod", "telib", "instances_meeting", _x, _y, _obj);
#define array_delete(_array, _index)                                                    return  mod_script_call(   "mod", "telib", "array_delete", _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call(   "mod", "telib", "array_delete_value", _array, _value);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "instances_at", _x, _y, _obj);