#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.save = mod_variable_get("mod", "teassets", "save");

    global.catLight = [];

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.save

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)

#define Creature_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd,maxspd);
     // Run away when hurt:
    if nexthurt > current_frame && !scared{
        scared = true;
        instance_create(x+right*65,y-24,AssassinNotice);
    }

     // Pushed away from floors:
    var _f = instance_nearest(x,y,Floor);
    if point_distance(x,y,_f.x,_f.y) <= 128
        motion_add_ct(point_direction(_f.x,_f.y,x,y),3);

     // Push Player:
    if(place_meeting(x, y, Player)){
        with(Player) if(place_meeting(x, y, other)){
            motion_add_ct(point_direction(other.x,other.y,x,y), 3);
        }
    }

#define Creature_draw
    draw_self_enemy();

#define Creature_alrm0
    alarm0 = 30;
    if instance_exists(Player){
         // finds the nearest wading player
        var _p = noone,
            _bigdist = 10000;
        with(Player) if !collision_line(x,y,other.x,other.y,Floor,0,0){
            var _distance = point_distance(x,y,other.x,other.y);
            if _distance < _bigdist{
                _p = self;
                _bigdist = _distance;
            }
        }
        if !scared{
            if instance_exists(_p){
                 // investigate wading player
                if point_distance(x,y,_p.x,_p.y) > 128
                    scrWalk(20+irandom(10),point_direction(x,y,_p.x,_p.y));
                else if random(4) < 1
                    instance_create(x+right*65,y-24,HealFX);
                scrRight(point_direction(x,y,_p.x,_p.y));
            }
            else{
                 // wander
                scrWalk(20+irandom(10),direction+random(20));
                scrRight(direction);
            }
        }
        else{
            if instance_exists(_p)
                scrWalk(999999999, point_direction(_p.x, _p.y, x, y));
            else{
                _p = instance_nearest(x,y,Player);
                scrWalk(20+irandom(10),point_direction(_p.x, _p.y, x, y));
            }
            scrRight(direction);
        }
    }

#define BuriedCar_step
    if(instance_exists(my_floor)){
        x = my_floor.x + 16;
        y = my_floor.y + 16;
    }
    else instance_destroy();

#define BuriedCar_death
     // Explosion:
    repeat(2) instance_create(x + orandom(3), y + orandom(3), Explosion);
    repeat(2) instance_create(x + orandom(3), y + orandom(3), SmallExplosion);
    sound_play(sndExplosionCar);

     // Break Floor:
    if(instance_exists(my_floor)){
        mod_variable_set("area", "coast", "surfFloorReset", true);
        with(my_floor){
            if(place_meeting(x, y, Detail)){
                with(Detail) if(place_meeting(x, y, other)){
                    instance_destroy();
                }
            }
            instance_destroy();
        }
        repeat(4) instance_create(x + orandom(8), y + orandom(8), Debris);
    }


#define CoastDecal_create(_x, _y, _shell)
    with(instance_create(_x, _y, CustomHitme)){
        name = "CoastDecal";

        shell = _shell;

         // Visual:
        if(shell){
            type = 0;
            spr_idle = spr.ShellIdle;
            spr_hurt = spr.ShellHurt;
            spr_dead = spr.ShellDead;
            spr_bott = spr.ShellBott;
            spr_foam = spr.ShellFoam;
        }
        else{
            type = irandom(array_length(spr.RockIdle) - 1);
            spr_idle = spr.RockIdle[type];
            spr_hurt = spr.RockHurt[type];
            spr_dead = spr.RockDead[type];
            spr_bott = spr.RockBott[type];
            spr_foam = spr.RockFoam[type];
        }
        spr_walk = spr_idle;
        image_xscale = choose(-1, 1);
        image_speed = 0.4;
        spr_shadow = mskNone;
        depth = (shell ? -2 : 0) + (-y / 20000);

         // Sound:
        snd_hurt = sndHitRock;
        snd_dead = (shell ? sndHyperCrystalHurt : sndWallBreakRock);

         // Vars:
        friction = 3;
        mask_index = (shell ? mskScrapBoss : mskBandit);
        mask_floor = (shell ? mskSalamander : mskAlly);
        maxhealth = (shell ? 100 : 50);
        my_health = maxhealth;
        size = (shell ? 4 : 3);
        team = 0;

         // Offset:
        x += orandom(10);
        y += orandom(10);

         // Doesn't Use Coast Wading System:
        nowade = true;

        on_step = CoastDecal_step;
        on_hurt = CoastDecal_hurt;

        return id;
    }

#define CoastDecal_step
     // Animate:
    if(anim_end){
        if(sprite_index != spr_dead) sprite_index = spr_idle;
        else{
            image_speed = 0;
            image_index = image_number - 1;
        }
    }

     // Pushing:
    if(place_meeting(x, y, hitme)){
        with(instances_matching_lt(hitme, "size", size)){
            if(place_meeting(x, y, other)){
                motion_add(point_direction(other.x, other.y, x, y), 1);
            }
        }
        if(!shell) with(instances_matching_ge(hitme, "size", size)){
            if(place_meeting(x, y, other) && object_index != Player){
                with(other) motion_add(point_direction(other.x, other.y, x, y), 4);
            }
        }
        with(Player){
            if(place_meeting(x, y, other)){
                motion_add(point_direction(other.x, other.y, x, y), 1);
            }
        }
    }

#define CoastDecal_hurt(_hitdmg, _hitvel, _hitdir)
    nexthurt = current_frame + 6;   // I-Frames
    sound_play_hit(snd_hurt, 0.3);  // Sound

     // Hurt Sprite:
    sprite_index = spr_hurt;
    image_index = 0;

     // Splashy FX:
    repeat(1 + (_hitdmg / 5)){
        var _dis = (shell ? 24 : 8),
            _dir = _hitdir + 180 + orandom(30);

        with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Sweat)){
            speed = random(speed);
            direction = _dir;
        }
    }

     // Damage:
    if(my_health > 0){
        my_health -= _hitdmg;

         // Break:
        if(my_health <= 0){
            mask_index = mskNone;
            sprite_index = spr_dead;
            team = 2;

             // Can Stand On Corpse:
            with(instance_create(0, 0, Floor)){
                x = other.x;
                y = other.y;
                visible = 0;
                mask_index = other.mask_floor;
            }

             // Weapon Drop:
            //pickup_drop(0, 100);

             // Visual Stuff:
            depth = (shell ? 0 : 1);
            with(instances_matching(BoltStick, "target", id)) instance_destroy();

             // Water Rock Debris:
            if(!shell){
                var _ang = random(360);
                for(var a = _ang; a < _ang + 360; a += 360 / 3){
                    with(instance_create(x, y, MeleeHitWall)) image_angle = a + orandom(10);
                }
                repeat(choose(2, 3)){
                    with(instance_create(x + orandom(2), y + orandom(2), Debris)){
                        motion_set(_hitdir + orandom(10), (speed + _hitvel) / 2);
                    }
                }
            }

             // Break Sound:
            sound_play_pitch(snd_dead, 1 + random(0.2));
        }
    }


#define Diver_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);

#define Diver_alrm0
    alarm0 = 60 + irandom(30);
    target = instance_nearest(x, y, Player);
    if(target_is_visible()) {
        var _targetDir = point_direction(x, y, target.x, target.y);

    	if(target_in_distance(60, 320) || array_length(instances_matching(instances_named(CustomProp, "Palm"), "my_enemy", id)) > 0){
    	     // Shoot Harpoon:
    		if(spr_weap = spr.HarpoonGun && random(4) < 1){
    			gunangle = _targetDir + orandom(10);
    			scrEnemyShoot("DiverHarpoon", gunangle, 12);

                wkick = 8;
                sound_play(sndCrossbow);
    			spr_weap = spr.HarpoonGunEmpty;
    		}

             // Reload Harpoon:
    		else if(spr_weap = spr.HarpoonGunEmpty){
    			sound_play_hit(sndCrossReload,0);
    			spr_weap = spr.HarpoonGun;
    			wkick = 2;
    		}

    		alarm0 = 30 + irandom(30);
    	}

         // Move Away From Target:
    	else{
    		alarm0 = 45 + irandom(30);
    		direction = _targetDir + 180 + orandom(30);
    		gunangle = direction + orandom(15);
    		walk = 15 + irandom(15);
    	}

    	 // Facing:
    	scrRight(_targetDir);
    }

     // Passive Movement:
    else{
    	direction = random(360);
    	gunangle = direction + orandom(15);
    	walk = 30;
    	scrRight(direction);
    }

#define Diver_draw
    if(gunangle <= 180) draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
    draw_self_enemy();
    with(instances_matching(instances_named(CustomProp, "Palm"), "my_enemy", id)) draw_self();
    if(gunangle > 180) draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);

#define Diver_death
    pickup_drop(20, 0);


#define DiverHarpoon_end_step
     // Trail:
    var _x1 = x,
        _y1 = y,
        _x2 = xprevious,
        _y2 = yprevious;

    with(instance_create(x, y, BoltTrail)){
        image_xscale = point_distance(_x1, _y1, _x2, _y2);
        image_angle = point_direction(_x1, _y1, _x2, _y2);
    }

     // Destroy Timer:
    enemyAlarms(1);

#define DiverHarpoon_alrm0
    instance_destroy();

#define DiverHarpoon_hit
    var _inst = other;
    if(speed > 0 && projectile_canhit(_inst) && ("my_enemy" not in other || other.my_enemy != creator)){
        var _hp = _inst.my_health;

         // Damage:
        projectile_hit_push(_inst, damage, force);

         // Stick in Player:
        with(instance_create(x, y, BoltStick)){
            image_angle = other.image_angle;
            target = _inst;
        }
        instance_destroy();
    }

#define DiverHarpoon_wall
     // Stick in Wall:
    if(speed > 0){
        speed = 0;
        sound_play_hit(sndBoltHitWall,.1);
        move_contact_solid(direction, 16);
        instance_create(x, y, Dust);
        alarm0 = 30;
    }

#define DiverHarpoon_anim
    image_speed = 0;
    image_index = image_number - 1;


#define Gull_step
    enemyAlarms(2);
    enemySprites();
    enemyWalk(walkspd, maxspd);

#define Gull_alrm0
    alarm0 = 40 + irandom(30);
    target = instance_nearest(x, y, Player);
    if(target_is_visible()){
        var _targetDir = point_direction(x, y, target.x, target.y);

         // Target Nearby:
    	if(target_in_distance(10, 480)){
    	     // Attack:
    		if(target_in_distance(10, 60)){
    			alarm1 = 8;
    			instance_create(x, y, AssassinNotice);
                sound_play_pitch(sndRavenScreech, 1.15 + random(0.1));
    		}

             // Move Toward Target:
    		else{
    		    alarm0 = 40 + irandom(10);
        		walk = 20 + irandom(15);
        		direction = _targetDir + orandom(20);
        		gunangle = direction + orandom(15);
    		}
    	}

         // Move Toward Target:
    	else{
    		alarm0 = 30 + irandom(10);
    		walk = 10 + irandom(20);
    		direction = _targetDir + orandom(20);
    		gunangle = direction + orandom(15);
    	}

    	 // Facing:
    	scrRight(direction);
    }

     // Passive Movement:
    else{
    	walk = 30;
    	direction = random(360);
    	gunangle = direction + orandom(15);
    	scrRight(direction);
    }

#define Gull_alrm1
     // Slash:
    gunangle = point_direction(x, y, target.x, target.y) + orandom(10);
    with(scrEnemyShoot(EnemySlash, gunangle, 4)) damage = 2;

     // Visual/Sound Related:
    wkick = -3;
    wepangle = -wepangle;
    motion_add(gunangle, 4);
    sound_play(sndChickenSword);
    scrRight(gunangle);

#define Gull_draw
    if(gunangle <= 180) draw_weapon(spr_weap, x, y, gunangle, wepangle, wkick, 1, image_blend, image_alpha);
    draw_self_enemy();
    if(gunangle > 180) draw_weapon(spr_weap, x, y, gunangle, wepangle, wkick, 1, image_blend, image_alpha);


#define Palanking_step
    enemyAlarms(5);
    if(z <= 0) walk = 0;
    enemyWalk(walkspd, maxspd);

     // Seals:
    var _sealNum = (seal_max - array_count(seal, noone)),
        _holdx = seal_x,
        _holdy = seal_y,
        _holding = [0, 0];

    for(var i = 0; i < array_length(seal); i++){
        if(instance_exists(seal[i])){
            var _x = _holdx[i] + (1.5 * right),
                _y = _holdy[i];

            with(seal[i]){
                if(hold){
                    if(sprite_index == spr_spwn){
                        hold_x = _x;
                        hold_y = _y;
                    }
                    else{
                        _holding[_holdx[i] > 0]++;
                        if(_sealNum > 1){
                            if(hold_x != _x){
                                hspeed = random(clamp(_x - hold_x, -maxspd, maxspd));
                                hold_x += hspeed;
                            }
                            if(hold_y != _y){
                                vspeed = random(clamp(_y - hold_y, -maxspd, maxspd));
                                hold_y += vspeed;
                            }
                        }
                    }
                }
                else{
                    hold_x = x - other.x;
                    hold_y = y - other.y;
                    motion_add(point_direction(x, y, other.x + _x, other.y + _y) + orandom(10), walkspd);
                    if(distance_to_point(_x, _y) < 8 || distance_to_object(other) < 8) hold = true;
                }
            }
        }
        else if(seal[i] != noone){
            seal[i] = noone;
            _sealNum--;
        }
    }

     // Fight Time:
    if(active){
         // Seals Run Over to Lift:
        if(_sealNum < seal_max){
            with(instances_named(CustomEnemy, "Seal")){
                if(!seal_exists(other, id)){
                    seal_add(other, id);
                    break;
                }
            }
        }

         // Not Enough Seals Holding:
        if(_holding[0] + _holding[1] <= 1){
            if(zgoal != 0){
                zgoal = 0;
                zspeed = 6;
            }
        }
        else{
             // Make Sure Seals on Both Sides:
            for(var i = 0; i < 2; i++) if(_holding[i] <= 0){
                for(var j = 0; j < array_length(seal); j++){
                    if(seal[j] != noone && ((j + !i) % 2)){
                        if(random(3) < 1){
                            var s = seal[j];
                            seal[j] = noone;

                            var o = (2 * !i) - 1;
                            if(j + o < 0) o = 1;
                            if(j + o >= array_length(seal)) o = -1;
                            seal[j + o] = s;
                        }
                    }
                }
            }

             // Lifted Up:
            if(zgoal == 0) zgoal = 12;
        }

         // Constant Movement:
        if(instance_exists(Floor)){
            if(distance_to_object(Floor) > 0 && zspeed == 0){
                var f = instance_nearest(x - 16, y - 16, Floor),
                    d = point_direction(x, y, f.x, f.y);

                x += lengthdir_x(1, d);
                y += lengthdir_y(1, d);
            }
        }
    }

     // Pre-Intro Stuff:
    else{
        x = xstart;
        y = ystart;

         // Begin Intro:
        if(alarm0 < 0 && instance_exists(Player)){
            if(instance_number(enemy) - instance_number(Van) <= 1){
                alarm0 = 30;
                phase++;
            }
        }

        else{
             // Freeze Things:
            with(Seal) alarm0 = 30 + random(90);
            if(current_frame_active){
                with(instances_matching([WantRevivePopoFreak, Van, IDPDSpawn], "", null)){
                    alarm0 += max(1, current_time_scale);
                }
            }

             // Just in case:
            with(instances_matching_ne(enemy, "name", "Palanking", "Seal", "SealHeavy")) my_health = 0;

             // Attract Pickups:
            if(instance_exists(Player) && intro_pan > 0){
                with(Pickup) if(object_index != WepPickup && speed <= 0){
                    var t = instance_nearest(x, y, Player);
                    if(point_distance(x, y, t.x, t.y) > 30){
                        var _dis = 6,
                            _dir = point_direction(x, y, t.x, t.y);

                        if(object_index == Rad || object_index == BigRad) _dis *= 2;

                        x += lengthdir_x(_dis, _dir);
                        y += lengthdir_y(_dis, _dir);
                    }
                }
            }
        }
    }

     // Pan Intro Camera:
    if(intro_pan > 0){
        intro_pan -= current_time_scale;

        var s = UberCont.opt_shake,
            _px = intro_pan_x,
            _py = intro_pan_y;

        UberCont.opt_shake = 1;
        for(var i = 0; i < maxp; i++){
            view_object[i] = id;
            view_pan_factor[i] = 10000;
            if(intro_pan <= 0) view_pan_factor[i] = null;
            with(player_find(i)){
                var g = gunangle,
                    _x = other.x,
                    _y = other.y;

                gunangle = point_direction(_x, _y, _px, _py);
                weapon_post(wkick, point_distance(_x, _y, _px, _py) / 1.5, 0);
                gunangle = g;
            }
        }
        UberCont.opt_shake = s;

         // Enable/Disable Players:
        with(Player) visible = (other.intro_pan <= 0); // REDRAW PLAYER, i will do this later but cant right now so this is a reminder
    }
    else for(var i = 0; i < maxp; i++){
        if(view_object[i] == id) view_object[i] = noone;
    }

     // Z-Axis:
    z += zspeed * current_time_scale;
    if(z <= zgoal){
        if(z < zgoal && zspeed == 0){
            if(zgoal <= 0) z = zgoal;
            else zspeed = (zgoal - z) / 2;
        }
        if(zspeed <= 0){
             // Held in Air:
            if(zgoal > 0){
                z = zgoal + zspeed;
                zspeed *= 0.8;
            }

             // Ground Landing:
            else if(zspeed < 0){
                 // Ground Smash:
                if(zspeed < -5){
                    alarm2 = 1;
                    sound_play_hit_big(sndBigBanditMeleeHit, 0.3);
                }

                zspeed *= -0.2;
            }

            if(abs(zspeed) < zfric){
                zspeed = 0;
                z = zgoal;
            }
        }
    }
    else zspeed -= zfric * current_time_scale;

     // Death Taunt:
    if(tauntdelay > 0 && !instance_exists(Player)){
        tauntdelay -= current_time_scale;
        if(tauntdelay <= 0){
            image_index = 0;
            sprite_index = spr_taun;
            sound_play(snd.PalankingTaunt);
        }
    }

     // Animate:
    if(sprite_index != spr_burp){
        if(sprite_index != spr_hurt && sprite_index != spr_call && sprite_index != spr_taun && sprite_index != spr_fire){
            if(speed <= 0) sprite_index = spr_idle;
            else sprite_index = spr_walk;
        }
        else if(anim_end) sprite_index = spr_idle;
    }
    else if(anim_end) image_index = 1;

     // Smack Smack:
    if(sprite_index == spr_call){
        var _img = floor(image_index);
        if(image_index < _img + image_speed && (_img == 4 || _img == 7)){
            sound_play_pitchvol(sndHitRock, 0.8 + orandom(0.2), 0.6);
        }
    }

     // Hitbox/Shadow:
    if(z <= 4){
        mask_index = mask_hold;
        if(spr_shadow != mskNone){
            spr_shadow_hold = spr_shadow;
            spr_shadow = mskNone;
        }
    }
    else{
        spr_shadow = spr_shadow_hold;
        if(mask_index != mskNone){
            mask_hold = mask_index;
            mask_index = mskNone
        }

         // Plant Snare:
        mask_index = mask_hold;
        if(place_meeting(x, y, Tangle)){
            x -= (hspeed * 0.5);
            y -= (vspeed * 0.5);
        }
        mask_index = mskNone;
    }

#macro Seal instances_matching(CustomEnemy, "name", "Seal", "SealHeavy")

#define seal_exists(_palanking, _inst)
    return (instance_exists(_palanking) && array_find_index(_palanking.seal, _inst) >= 0);

#define seal_add(_palanking, _inst)
    with(_palanking){
         // Generate Hold Positions:
        if(array_length(seal) != seal_max){
            seal = array_create(seal_max, noone);

             // Manual Placement:
            if(seal_max <= 4){
                seal_x = [33.5, -33.5, 30.5, -30.5];
                seal_y = [16, 16, 28, 28];
            }

             // Auto-Placement:
            else{
                seal_x = [];
                var o = 33.5;
                for(var i = 0; i < seal_max; i++){
                    var a = ((floor(i / 2) + 1) * (180 / (ceil(seal_max / 2) + 1))) - 90;
                    seal_x[i] = lengthdir_x(o, a)
                    seal_y[i] = 16 + (lengthdir_y(o, a) / 2);
                    o *= -1;
                }
            }
        }

         // Add Seal:
        var p = max(array_find_index(seal, noone), 0);
        seal[p] = _inst;
    }

#define Palanking_end_step
    with(seal) if(instance_exists(self) && hold){
        x = other.x + hold_x;
        y = other.y + hold_y;
        xprevious = x;
        yprevious = y;
        hspeed = other.hspeed;
        vspeed = other.vspeed;
        depth = other.depth + (0.1 * dsin(point_direction(0, 24, hold_x, hold_y)));
    }

#define Palanking_alrm0
    if(intro_pan <= 0){
        alarm0 = 60;

         // Enable Cinematic:
        intro_pan = 10;
        intro_pan_x = x;
        intro_pan_y = y;

         // Call for Seals:
        if(fork()){
            wait 15;
            if(instance_exists(self)){
                sprite_index = spr_call;
                image_index = 0;
                sound_play(snd.PalankingCall);
            }
            exit;
        }

         // "Safety":
        with(Player) instance_create(x, y, PortalShock);
    }
    else{
        switch(phase){
            case 0: // Wave of Seals:
                var _groups = 5;
                if(array_length(Seal) < seal_max * _groups){
                    var _x = 10016,
                        _y = 10016;

                    scrSealSpawn(_x, _y, point_direction(_x, _y, seal_spawn_x, seal_spawn_y) + (360 / _groups), 15);
                    intro_pan_x = seal_spawn_x;
                    intro_pan_y = seal_spawn_y;

                    alarm0 = alarm3 + 14;
                }
                break;

            case 1:
                if(!active){
                    if(array_length(seal) < seal_max || array_count(seal, noone) > 0){
                         // Seal Plop:
                        //repeat(4) instance_create(other.x + x, other.y + y, Sweat);
                        sound_play_pitch(choose(sndOasisHurt, sndOasisMelee, sndOasisShoot, sndOasisChest, sndOasisCrabAttack), 0.8 + random(0.4));

                         // Spawn Seals:
                        var _seal = obj_create(x, y, "Seal");
                        seal_add(id, _seal);
                        with(_seal){
                            hold = true;
                            creator = other;
                            scared = true;
                        }

                        if(array_count(seal, noone) <= 0) alarm0 = 16;
                        else alarm0 = 8;
                    }

                     // Lift Palanking:
                    else{
                        active = true;
                        zgoal = 12;
                        alarm0 = 30;
                    }
                }
                else{
                    alarm1 = 60 + irandom(40);

                     // Boss Intro:
                    if(!intro){
                        intro = true;
                        scrBossIntro("Palanking", sndBigDogIntro, mus.SealKing);
                    }

                     // Walk Towards Player:
                    target = instance_nearest(x, y, Player);
                    if(instance_exists(target)){
                        scrWalk(90, point_direction(x, y, target.x, target.y));
                    }
                }
                break;
        }
    }

     // Pan Camera:
    intro_pan += alarm0;

#define Palanking_alrm1
    alarm1 = 40 + random(20);

    target = instance_nearest(x, y, Player);

     // Bubble Bomb Burp:
    if(ammo > 0){
        alarm1 = 4;
        with(scrEnemyShootExt(x, y - z + 2, "BubbleBomb", gunangle + orandom(10), 8 + random(4))){
            depth = other.depth - 1;
        }
        motion_add(gunangle + (right * 90), 0.5);

         // Effects:
        sound_play_pitchvol(sndRatkingCharge, 0.4 + random(0.4), 1.8);
        repeat(irandom(2)) with(instance_create(x, y - z + 2, Bubble)){
            motion_add(other.gunangle + orandom(20), 2 + random(2));
            depth = other.depth - 1;
            image_xscale = random_range(0.7, 0.8);
            image_yscale = image_xscale;
            image_speed *= 1.5;
            gravity /= 2;
            coast_water = false;
        }

         // End:
        if(--ammo <= 0){
            alarm1 = 40 + random(20);
            sound_play_pitch(snd_hurt, 0.6);
            sprite_index = spr_hurt;
            image_index = 0;
        }
    }

     // Normal AI:
    else if(target_is_visible()){
        var _targetDir = point_direction(x, y, target.x, target.y);

        scrWalk(60, _targetDir + orandom(30));

         // Kingly Slap:
        if(target_in_distance(0, 80) && random(1) < 1){
            alarm1 = 60 + random(20);
            alarm4 = 8;
            gunangle = _targetDir;
            sprite_index = spr_fire;
            image_index = 0;

             // Effects:
            sound_play(snd.PalankingSwipe);
            instance_create(x, y - z, AssassinNotice);
        }

        else{
             // Call for Seals:
            if(z <= 0 || random(array_length(Seal)) < 1){
                sprite_index = spr_call;
                image_index = 0;
                sound_play(snd.PalankingCall);
                scrSealSpawn(x, y, random(360), 30);
                alarm1 = alarm3 + random(8);
            }

             // Begin Burp Attack:
            else if(random(2) < 1){
                if(target_in_distance(0, 192)){
                    gunangle = _targetDir;
                    alarm1 = 5;
                    ammo = 10;

                    sprite_index = spr_burp;
                    image_index = 0;

                    sound_play_pitchvol(sndRhinoFreakMelee, 0.5, 2);
                    sound_play_pitchvol(sndExplosion, 0.3, 0.5);
                    sound_play_pitchvol(sndBigGeneratorHurt, 0.4, 2);
                    sound_play_pitchvol(sndRatKingVomit, 0.9, 2);
                }
            }
        }
    }

#define Palanking_alrm2
    var m = 2;
    if(ground_smash++ < m){
        alarm2 = 5;

        view_shake_at(x, y, 40 / ground_smash);

        sound_play_pitch(sndOasisExplosion, 1.6 + random(0.4));
        sound_play_pitch(sndWallBreakBrick, 0.6 + random(0.2));

        var _dis = (ground_smash * 24);
        for(var a = 0; a < 360; a += (360 / 16)){
             // Ground Smash Slash:
            with(scrEnemyShootExt(x + lengthdir_x(_dis, a), y + 28 + lengthdir_y(_dis * 0.66, a), EnemySlash, a, 1)){
                sprite_index = spr.GroundSlash;
                image_speed = 0.5;
                mask_index = -1;
                damage = 10;
                depth = 0;
                team = -1;
            }

             // Effects:
            if(random(4) < 1){
                var o = 16;
                with(instance_create(x + lengthdir_x(_dis + o, a), y + 32 + lengthdir_y((_dis + o) * 0.66, a), MeleeHitWall)){
                    motion_add(90 - (30 * dcos(a)), 1 + random(2));
                    image_angle = direction + 180;
                    image_speed = random_range(0.3, 0.6);
                }
            }
            repeat(irandom(2)){
                with(instance_create(x + orandom(8) + lengthdir_x(_dis, a), y + random_range(20, 32) + lengthdir_y(_dis, a), Dust)){
                    motion_add(a, random(5));
                }
            }
        }
    }
    else ground_smash = 0;

#define Palanking_alrm3
    sound_play_pitch(choose(sndOasisHurt, sndOasisMelee, sndOasisShoot, sndOasisChest, sndOasisCrabAttack), 0.8 + random(0.4));

     // Spawn Seals:
    var _dis = 16 + random(24),
        _dir = (seal_spawn * 90) + orandom(40),
        _x = seal_spawn_x + lengthdir_x(_dis, _dir),
        _y = seal_spawn_y + lengthdir_y(_dis, _dir),
        o = obj_create(_x, _y, "Seal");

    with(o){
         // Randomize Type:
        if(name == "Seal"){
            var _pick = [];
            for(var i = 0; i < array_length(seal_chance); i++){
                if(seal_chance[i] > 0) repeat(seal_chance[i]){
                    array_push(_pick, i);
                }
            }
            type = _pick[irandom(array_length(_pick) - 1)];

             // Set Sprites:
            spr_idle = spr.SealIdle[type];
            spr_walk = spr.SealWalk[type];
            spr_hurt = spr.SealHurt[type];
            spr_dead = spr.SealDead[type];
            spr_spwn = spr.SealSpwn[type];
            spr_weap = spr.SealWeap[type];
            sprite_index = spr_spwn;
            hitid = [spr_idle, name];
        }

         // Important Stuff:
        creator = other;
        if(other.active) kills = 0;
        array_push(mod_variable_get("area", "coast", "swimInstVisible"), id);
    }

    if(--seal_spawn > 0) alarm3 = 4 + random(2);

     // Continue Intro:
    if(alarm0 > 0){
        alarm0 += alarm3;
        intro_pan += alarm3;
    }

#define Palanking_alrm4
     // Biggo Slash:
    with(scrEnemyShootExt(x, y + 16 - z, EnemySlash, gunangle, 7)){
        sprite_index = spr.PalankingSlash;
        depth = other.depth - 1;
        image_speed = 0.3;
        friction = 0.5;
        damage = 4;
    }
    motion_add(gunangle, 4);

     // Effects:
    sound_play(sndHammer);

#define scrSealSpawn(_xstart, _ystart, _dir, _delay)
    alarm3 = _delay;
    seal_spawn = seal_max;

     // Find Spawn Location:
    seal_spawn_x = _xstart;
    seal_spawn_y = _ystart;
    var _dis = 40 + random(16);
    if(instance_exists(Floor)){
        with(instance_create(_xstart, _ystart, GameObject)){
            while(distance_to_object(Floor) < _dis + 8 || distance_to_object(prop) < 32){
                x += lengthdir_x(12, _dir);
                y += lengthdir_y(12, _dir);
            }
            other.seal_spawn_x = x;
            other.seal_spawn_y = y;
            instance_destroy();
        }
    }

#define Palanking_hurt(_hitdmg, _hitvel, _hitdir)
    nexthurt = current_frame + 6;	// I-Frames
    if(active){
        my_health -= _hitdmg;			// Damage
        motion_add(_hitdir, _hitvel);	// Knockback
        sound_play_hit(snd_hurt, 0.3);	// Sound

         // Hurt Sprite:
        if(sprite_index != spr_call && sprite_index != spr_burp && sprite_index != spr_fire){
            sprite_index = spr_hurt;
            image_index = 0;
        }
    }

     // Laugh:
    else if(sprite_index == spr_idle && point_seen_ext(x, y, 16, 16, -1)){
        sound_play(snd.PalankingTaunt);
        sprite_index = spr_taun;
        image_index = 0;

         // Sound:
        sound_play_hit(sndHitWall, 0.3);
    }

     // Effects:
    if(instance_exists(other) && instance_is(other, projectile)){
        with(instance_create(other.x, other.y, Dust)){
            coast_water = 1;
            if(y > other.y + 12) depth = other.depth - 1;
        }
        if(random(8) < other.damage) with(other){
            sound_play_hit(sndHitRock, 0.3);
            with(instance_create(x, y, Debris)){
                motion_set(_hitdir + 180 + orandom(other.force * 4), 2 + random(other.force / 2));
            }
        }
    }

#define Palanking_draw
    var h = ((nexthurt > current_frame + 3 && active) || (sprite_index == spr_hurt && image_index < 1));

     // Palanquin Bottom:
    if(z > 4 || place_meeting(x, y, Floor)){
        if(h) d3d_set_fog(1, c_white, 0, 0);
        draw_sprite_ext(spr_bott, image_index, x, y - z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
        if(h) d3d_set_fog(0, 0, 0, 0);
    }

     // Self:
    h = (h && sprite_index != spr_hurt);
    if(h) d3d_set_fog(1, c_white, 0, 0);
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
    if(h) d3d_set_fog(0, 0, 0, 0);

#define Palanking_death
     // Epic Death:
    with(obj_create(x, y, "PalankingDie")){
        spr_dead = other.spr_dead;
        sprite_index = other.spr_hurt;
        image_xscale = other.image_xscale * other.right;
        mask_index = other.mask_index;
        snd_dead = other.snd_dead;
        raddrop = other.raddrop;
        size = other.size;
        z = other.z;
        speed = min(other.speed, other.maxspd);
        direction = other.direction;
    }
    sound_play_pitchvol(snd.PalankingSwipe, 1, 4);
    snd_dead = -1;
    raddrop = 0;

     // Boss Win Music:
    with(MusCont) alarm_set(1, 1);


#define PalankingDie_step
    z_engine();
    if(z <= 0) instance_destroy();

#define PalankingDie_destroy
    sound_play_pitchvol(sndWallBreakRock, 0.8, 0.8);
    sound_play_pitchvol(sndExplosionL, 0.5, 0.6);
    sound_play_hit(sndBigBanditMeleeHit, 0.3);
    sound_play(snd_dead);

    view_shake_at(x, y, 30);

     // Palanquin Chunks & Debris:
    var _spr = spr.PalankingChunk,
        _ang = random(360);

    for(var i = 0; i < sprite_get_number(_spr); i++){
        with(instance_create(x, y + 16, Debris)){
            motion_set(_ang + orandom(30), 2 + random(10));
            sprite_index = _spr;
            image_index = i;
            alarm0 += random(240);
        }
        repeat(irandom(2)) instance_create(x, y + 16, Debris);

        _ang += (360 / sprite_get_number(_spr));
    }

     // Fricken DEAD:
	with(instance_create(x, y, Corpse)){
		sprite_index = other.spr_dead;
		image_xscale = other.image_xscale;
		mask_index = other.mask_index;
		size = other.size;
		depth = -2;
	}

     // Pickups:
    repeat(3) pickup_drop(50, 0);
	scrRadDrop(x, y + 16, raddrop, direction, speed);

#define PalankingDie_draw
    var h = (image_index < 1);
    if(h) d3d_set_fog(1, c_white, 0, 0);
    draw_sprite_ext(spr.PalankingBott, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, 1);
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, 1);
    if(h) d3d_set_fog(0, 0, 0, 0);


#define Palm_step
    with(my_enemy){
        x = other.x;
        y = other.y - 44;
        walk = 0;
        speed = 0;
        sprite_index = spr_idle;
        if(mask_index != mskNone){
            other.my_enemy_mask = mask_index;
            mask_index = mskNone;
        }
    }

#define Palm_death
    with(my_enemy){
        y += 8;
        vspeed += 10;
        mask_index = other.my_enemy_mask;
    }

     // Leaves:
    repeat(15) with(instance_create(x + orandom(15), y - 30 + orandom(10), Feather)){
        sprite_index = sprLeaf;
        image_yscale = random_range(1, 3);
        motion_add(point_direction(other.x, other.y, x, y), 1 + random(1));
        vspeed += 2;
    }


#define Pelican_step
    enemyAlarms(2);
    enemySprites();
    enemyWalk(walkspd, maxspd);

     // Dash:
    if(dash > 0){
        motion_add(direction, dash * dash_factor);
        dash -= current_time_scale;

         // Dusty:
        instance_create(x + orandom(3), y + random(6), Dust);
        with(instance_create(x + orandom(3), y + random(6), Dust)){
            motion_add(other.direction + orandom(45), (4 + random(1)) * other.dash_factor);
        }
    }

#define Pelican_alrm0
    alarm0 = 40 + random(20); // 1-2 Seconds

     // Flash (About to attack):
    if(alarm1 >= 0){
        var _dis = 18,
            _ang = gunangle + wepangle;

        with(instance_create(x + lengthdir_x(_dis, _ang), y + lengthdir_y(_dis, _ang), ThrowHit)){
            image_speed = 0.5;
            depth = -3;
        }
    }

     // Aggroed:
    target = instance_nearest(x, y, Player);
    if(target_is_visible() && target_in_distance(0, 320)){
        var _targetDir = point_direction(x, y, target.x, target.y);

         // Attack:
        if(((target_in_distance(0, 128) && random(3) < 2) || random(my_health) < 1) && alarm1 < 0){
            alarm1 = chrg_time;
            alarm0 = alarm1 - 10;

             // Move away a tiny bit:
            scrWalk(5, _targetDir + 180 + orandom(10));

             // Warn:
            instance_create(x, y, AssassinNotice).depth = -3;
            sound_play_pitch(sndRavenHit, 0.5 + random(0.1));
        }

         // Move Toward Target:
        else scrWalk(20 + random(10), _targetDir + orandom(10));

         // Aim Towards Target:
        gunangle = _targetDir;
        scrRight(gunangle);
    }

     // Passive Movement:
    else{
        alarm0 = 90 + random(30); // 3-4 Seconds
        scrWalk(10 + random(5), random(360));
    }

#define Pelican_alrm1
    alarm0 = 40 + random(20);

     // Dash:
    dash = 12;
    motion_set(gunangle, maxspd);

     // Heavy Slash:
    with(scrEnemyShoot(EnemySlash, gunangle, ((dash - 2) * dash_factor))){
        sprite_index = sprHeavySlash;
        friction = 0.4;
        damage = 10;
    }

     // Misc. Visual/Sound:
    wkick = -10;
    wepangle = -wepangle;
    view_shake_at(x, y, 20); // Mmm that's heavy
    sound_play(sndEnergyHammer);
    sound_play_pitch(sndHammer, 0.75);
    sound_play_pitch(sndRavenScreech, 0.5 + random(0.1));

#define Pelican_draw
    var _charge = ((alarm1 > 0) ? alarm1 : 0),
        _angOff = sign(wepangle) * (60 * (_charge / chrg_time));

    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, wepangle - _angOff, wkick, 1, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();

#define Pelican_death
    pickup_drop(80, 0);
    pickup_drop(60, 5);

     // Hmm:
    if(place_meeting(x, y, WepPickup)){
        with(instance_nearest(x, y, WepPickup)){
            if(wep == wep_sledgehammer){
                sprite_index = other.spr_weap;

                var _dis = 16,
                    _dir = rotation;

                instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), ThrowHit).image_speed = 0.35;
            }
        }
    }


#define Seal_step
    enemyWalk((hold ? 0 : walkspd), maxspd);
    enemyAlarms(2);

     // Slide:
    if(slide > 0){
        speed += min(slide, 2) * current_time_scale;

        var _turn = 5 * sin(current_frame / 10) * current_time_scale;
        direction += _turn;
        gunangle += _turn;

         // Effects:
        with(instance_create(x + orandom(3), y + 6, Dust)){
            direction = other.direction;
        }

        slide -= current_time_scale;
    }

     // Type Step:
    switch(type){
        case seal_hookpole:
             // About to Stab:
            if(alarm1 > 0) wkick += 2 * current_time_scale;

             // Decrease wkick Faster:
            else if(wkick < 0){
                wkick -= (wkick / 20) * current_time_scale;
            }
            break;

        case seal_shield:
             // Shield Mode:
            if(shield){
                 // Turn:
                var t = angle_difference(gunangle, shield_ang) / 8;
                shield_ang += t;

                 // Draw Shield:
                if(t != 0 && point_seen_ext(x, y, 16, 16, -1)){
                    shield_draw = true;
                }

                 // Reflect Projectiles:
                var o = 6,
                    r = 12,
                    _x = x + lengthdir_x(o, shield_ang),
                    _y = y + lengthdir_y(o, shield_ang);

                if(collision_circle(_x, _y, r * 2, projectile, false, false)){
                    with(instances_matching_gt(instances_matching_ne(instances_matching_ne(projectile, "team", team), "typ", 0), "speed", 0)){
                        if(point_in_circle(x + hspeed, y + vspeed, _x, _y, r + (speed / 2))){
                            other.wkick = 8 + orandom(1);
                            speed += friction * 3;

                             // Knockback:
                            if(force > 3){
                                with(other) motion_add(shield_ang + 180, min(other.damage / 3, 3));
                            }

                             // Reflect:
                            var _reflectLine = other.shield_ang;
                            direction = _reflectLine - clamp(angle_difference(direction + 180, _reflectLine), -40, 40);
                            image_angle = direction;

                             // Effects:
                            sound_play(sndShielderDeflect);
                            with(instance_create(x, y, Deflect)) image_angle = _reflectLine;
                            instance_create(x, y, Dust);

                             // Destroyables:
                            if(typ == 2) instance_destroy();
                        }
                    }
                }
            }

             // Sword Stabby Mode:
            else{
                if(wepangle == 0) wepangle = choose(-120, 120);
                shield_ang = 90;
            }

             // Draw 3D Shield to Surface:
            if(shield_draw){
                shield_draw = false;

                var _shielding = shield,
                    _spr = spr.ClamShield,
                    _dis = 10 + (_shielding ? wkick : 0),
                    _dir = shield_ang,
                    _surfw = surfClamShieldW,
                    _surfh = surfClamShieldH,
                    _surfx = surfClamShieldX,
                    _surfy = surfClamShieldY;

                if(!surface_exists(surfClamShield)) surfClamShield = surface_create(_surfw, _surfh);
                surface_set_target(surfClamShield);
                draw_clear_alpha(0, 0);

                var n = sprite_get_number(_spr) - 1,
                    _dx = x - _surfx + lengthdir_x(_dis, _dir),
                    _dy = y - _surfy + lengthdir_y(_dis, _dir);

                for(var i = 0; i <= n; i++){
                    var _ox = 0,
                        _oy = -i;

                    if(_shielding){
                        _oy *= 3/4;
                        var o = 2 * (1 - sqr((i - 4) / (n / 2)));
                        _ox += lengthdir_x(o, _dir);
                        _oy += lengthdir_y(o, _dir);
                    }

                    draw_sprite_ext(_spr, i, _dx + _ox, _dy + _oy, 1, (_shielding ? 1.5 : 1), _dir - 90, image_blend, image_alpha);
                }

                surface_reset_target();
            }
            break;

        case seal_blunderbuss:
             // Powder Smoke:
            if(alarm1 > 0 && current_frame_active){
                sound_play(asset_get_index(`sndFootPlaSand${1 + irandom(5)}`));
                with(instance_create(x, y, Smoke)){
                    motion_set(other.gunangle + (other.right * 120) + orandom(20), 1 + random(1));
                    image_xscale /= 2;
                    image_yscale = image_xscale;
                    growspeed -= 0.01;
                    depth = other.depth + (dsin(other.gunangle) * 0.1);
                }
            }
            break;

        default:
            if(walk > 0) direction += orandom(10);
    }

     // Animate:
    if(sprite_index != spr_spwn){
        image_index += random(0.1) * current_time_scale;
        enemySprites();
    }
    else{
        if(anim_end) sprite_index = spr_idle;
        if(image_index < 2) y -= image_index * current_time_scale;
    }

#macro seal_none 0
#macro seal_hookpole 1
#macro seal_shield 2
#macro seal_blunderbuss 3
#macro seal_chance [0, 6, 3, 4]

#macro surfClamShieldW 100
#macro surfClamShieldH 100
#macro surfClamShieldX x - (surfClamShieldW / 2)
#macro surfClamShieldY y - (surfClamShieldH / 2)

#define Seal_alrm0
    alarm0 = 30 + random(30);

    trident_dist = 0;

    target = instance_nearest(x, y, Player);
    if(target_is_visible()){
        var _targetDir = point_direction(x, y, target.x, target.y);

         // Seal Types:
        switch(type){
            case seal_hookpole:
                alarm0 = 10 + random(15);

                 // Too Close:
                if(target_in_distance(0, 20)){
                    scrWalk(10, _targetDir + 180 + orandom(60));
                }

                else{
                    if(random(5) < 4){
                         // Attack:
                        if(target_in_distance(0, 70)){
                            alarm0 = 30;
                            alarm1 = 10;
                            trident_dist = point_distance(x, y, target.x, target.y) - 24;
                        }

                         // Too Far:
                        else{
                            scrWalk(10, _targetDir + orandom(20));
                            if(random(10) < 1) slide = 10;
                        }
                    }

                     // Side Step:
                    else{
                        scrWalk(15, _targetDir + choose(-80, 80));
                        if(random(2) < 1) slide = 5 + random(10);
                    }
                }
                break;

            case seal_shield:
                if(shield){
                    alarm0 = 15 + random(5);
                    if(target_in_distance(0, 80) && wkick == 0){
                        scrWalk(4 + random(4), _targetDir + orandom(10));

                         // Dagger Time:
                        shield = false;
                        shield_draw = true;
                        alarm0 = 20;

                         // Swap FX:
                        var o = 8;
                        instance_create(x + lengthdir_x(o, gunangle), y + lengthdir_y(o, gunangle), WepSwap);
                        sound_play(sndSwapSword);
                    }
                    else if(random(3) < 2){
                        scrWalk(6 + random(6), _targetDir + orandom(50));
                    }
                }

                 // Sword Stabby Mode:
                else{
                    alarm0 = 20 + random(10);
                    if(target_in_distance(0, 120)){
                        scrWalk(5 + random(5), _targetDir + choose(0, 0, 180) + orandom(20));

                        if(target_in_distance(0, 80)){
                             // Stabby:
                            gunangle = _targetDir;
                            with(scrEnemyShoot(Shank, gunangle, 3)) damage = 2;

                            motion_add(gunangle, 2);

                             // Effects:
                            wkick = -5;
                            wepangle *= -1;
                            sound_play(sndMeleeFlip);
                            sound_play(sndScrewdriver);
                            sound_play_pitchvol(sndSwapGold, 1.25 + random(0.5), 0.4);
                            instance_create(x, y, Dust);
                        }

                         // Slide Away:
                        else{
                            direction = _targetDir + 180;
                            slide = 10;
                        }
                    }
                    else{
                        shield = true;
                        shield_ang = _targetDir;
                        shield_draw = true;
                        wkick = 2;

                         // Swap FX:
                        var o = 8;
                        instance_create(x + lengthdir_x(o, gunangle), y + lengthdir_y(o, gunangle), WepSwap);
                        sound_play(sndSwapHammer);
                    }
                }
                break;

            case seal_blunderbuss:
                 // Slide Away:
                if(target_in_distance(0, 80)){
                    direction = _targetDir + 180;
                    slide = 15;
                    alarm0 = slide + random(10);
                }

                 // Good Distance Away:
                else{
                     // Aim & Ignite Powder:
                    if(target_in_distance(0, 192) && random(3) < 2){
                        alarm0 = alarm1 + 90;

                        gunangle = _targetDir;
                        alarm1 = 15;

                         // Effects:
                        sound_play_pitchvol(sndEmpty, 2.5, 0.5);
                        wkick = -2;
                    }

                     // Reposition:
                    else{
                        scrWalk(10, _targetDir + orandom(90));
                        if(random(2) < 1) slide = 15;
                    }

                     // Important:
                    if(random(3) < 1){
                        instance_create(x, y, CaveSparkle).depth = depth - 1;
                    }
                }
            	break;

            default:
                if(instance_exists(creator) && creator.active){
                    scrWalk(10 + random(10), point_direction(x, y, creator.x, creator.y));
                }
                else{
                     // Don't kill me!
                    if(scared){
                        if(point_distance(x, y, target.x, target.y) < 120 || random(array_length(instances_named(object_index, name))) < 2){
                            scrWalk(20 + random(10), _targetDir + 180 + orandom(50));
                            if(random(3) < 1) slide = walk - 5;
                            alarm0 = walk;
                        }
                        else{
                            scrWalk(5 + random(5), random(360));
                            scrRight(_targetDir);
                        }
                    }

                     // Passive:
                    else{
                        scrWalk(5 + random(5), point_direction(x, y, xstart + orandom(24), ystart + orandom(24)));
                        if(target_in_distance(0, 120)) scrRight(_targetDir);
                    }
                }
        }

         // Face Target:
        if(type != seal_none){
            gunangle = _targetDir;
            scrRight(gunangle);
        }

         // Slide FX:
        if(slide > 0){
            if(hold) slide = 0;
            else{
                sound_play_hit(sndRoll, 0.4);
                sound_play_pitch(sndBouncerBounce, 0.4 + random(0.1));
                repeat(5) with(instance_create(x, y, Dust)){
                    motion_add(random(360), 3);
                }
            }
        }
    }

     // Passive Movement:
    else{
        scrWalk(5 + random(20), random(360));
        alarm0 += walk;
    }

#define Seal_alrm1
    switch(type){
        case seal_hookpole:
             // Hookpole Stabby:
            var _dis = 24 + trident_dist,
                _dir = gunangle;

            with(scrEnemyShootExt(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Shank, _dir + 180, 2)){
                damage = 3;
                image_angle = _dir;
                image_xscale = 0.5;
                depth = -3;
                force = 12;
            }

             // Effects:
            sound_play(sndMeleeFlip);
            sound_play(sndJackHammer);
            sound_play(sndScrewdriver);
            repeat(5) with(instance_create(x, y, Dust)){
                motion_add(other.gunangle + orandom(30), random(5));
            }

             // Forward Push:
            x += lengthdir_x(4, gunangle);
            y += lengthdir_y(4, gunangle);
            wkick = -trident_dist;

             // Walk Backwards:
            var g = gunangle;
            scrWalk(6 + random(4), gunangle + 180 + orandom(20));
            gunangle = g;
            scrRight(g);

            break;

        case seal_blunderbuss:
             // Blammo:
        	repeat(6){
        	    scrEnemyShoot(EnemyBullet1, gunangle + orandom(6), 6 + random(2));
        	}

             // Effects:
            for(var i = 0; i < 6; i++){
                with(instance_create(x, y, Dust)){
                    motion_add(random(360), 3);
                }
                with(instance_create(x, y + 1, Dust)){
                    motion_add(other.gunangle + orandom(6), 2 + i);
                }
            }
        	sound_play_pitchvol(sndDoubleShotgun, 1.5, 1);
        	motion_add(gunangle + 180, 4);
        	wkick = 10;

            break;
    }

#define Seal_hurt(_hitdmg, _hitvel, _hitdir)
    enemyHurt(_hitdmg, _hitvel, _hitdir);

     // Alert:
    if(type == seal_none){
        with(instances_named(object_index, name)){
            if(!scared && type == other.type){
                if(point_distance(x, y, other.x, other.y) < 80){
                    scared = true;
                    instance_create(x, y, AssassinNotice);
                }
            }
        }
    }

#define Seal_draw
    var _drawWep = (sprite_index != spr_spwn || image_index > 2);

     // Sliding Visuals:
    if(slide > 0){
        var _lastAng = image_angle,
            _lastY = y;

        image_angle = direction - 90;
        y += 2;
    }

     // Item on Back:
    if(type == seal_shield && _drawWep){
         // Back Dagger:
        if(shield){
            draw_sprite_ext(spr_weap, 0, x + 2 - (8 * right), y - 16, 1, 1, 270 + (right * 25), c_white, image_alpha);
        }

         // Back Shield:
        else if(surface_exists(surfClamShield)){
            var _surfx = surfClamShieldX,
                _surfy = surfClamShieldY + 16;

            d3d_set_fog(1, c_black, 0, 0);
            for(var a = 0; a < 360; a += 90){
                draw_surface(surfClamShield, _surfx + lengthdir_x(1, a), _surfy + lengthdir_y(1, a));
            }
            d3d_set_fog(0, 0, 0, 0);
            draw_surface(surfClamShield, _surfx, _surfy);
        }
    }

     // Self Behind:
    if(gunangle >  180) draw_self_enemy();

    if(_drawWep){
         // 3D Shield + Auto-Outline:
        if(type == seal_shield && shield){
            if(surface_exists(surfClamShield)){
                var _surfx = surfClamShieldX,
                    _surfy = surfClamShieldY + 5;

                d3d_set_fog(1, c_black, 0, 0);
                for(var a = 0; a < 360; a += 90){
                    draw_surface(surfClamShield, _surfx + lengthdir_x(1, a), _surfy + lengthdir_y(1, a));
                }
                d3d_set_fog(0, 0, 0, 0);

                draw_surface(surfClamShield, _surfx, _surfy);
            }
        }

         // Weapon:
        else draw_weapon(spr_weap, x, y, gunangle, wepangle, wkick, ((wepangle == 0) ? right : sign(wepangle)), image_blend, image_alpha);
    }

     // Self:
    if(gunangle <= 180) draw_self_enemy();

     // Reset Vars:
    if(slide > 0){
        image_angle = _lastAng;
        y = _lastY;
    }

#define Seal_death
    pickup_drop(50, 0);


#define SealAnchor_step
    if(instance_exists(creator)){
        x = creator.x;
        y = creator.y;
        with(creator){
            x += other.hspeed / 20;
            y += other.vspeed / 20;
        }
    }
    else{
        if(friction <= 0){
            sound_play_pitch(sndSwapSword, 2.4);
            friction = 0.6;
            speed /= 3;
            typ = 1;
        }

         // Explode:
        if(speed < 1){
            var o = 8;
            obj_create(x + lengthdir_x(o, image_angle), y + lengthdir_y(o, image_angle), "BubbleExplosion");
            sound_play_pitchvol(sndWallBreakBrick, 1.2 + random(0.1), 0.7);
            sound_play_pitchvol(sndSwapHammer, 1.3, 0.6);
            instance_destroy();
        }
    }

#define SealAnchor_end_step
     // Effects:
    var _dis = [2, sprite_width - 2],
        _dir = direction;

    for(var i = 0; i < array_length(_dis); i++){
        var _x = x + lengthdir_x(_dis[i], _dir),
            _y = y + lengthdir_y(_dis[i], _dir);

        with(instance_create(_x, _y, BoltTrail)){
            image_angle = point_direction(x, y, other.last_x[i], other.last_y[i]);
            image_xscale = point_distance(x, y, other.last_x[i], other.last_y[i]);
            image_yscale = 0.6;
        }

        last_x[i] = _x;
        last_y[i] = _y;
    }

#define SealAnchor_draw
    if(instance_exists(creator)){
        draw_set_color(c_black);
        draw_line(x, y, creator.x, creator.y);
    }
    draw_self();

#define SealAnchor_hit
    if(projectile_canhit_melee(other)){
        projectile_hit_push(other, damage, force);
    }

#define SealAnchor_projectile
    if(team != other.team){
        with(other){
            if(typ == 1){
                direction = other.image_angle;
                image_angle = direction;
            }
            else if(typ == 2) instance_destroy()
        }
    }


#define SealHeavy_step
    enemyWalk(walkspd, maxspd);
    enemyAlarms(1);

     // Animate:
    if(sprite_index != spr_spwn) enemySprites();
    else{
        if(anim_end) sprite_index = spr_idle;
        if(image_index < 2) y -= image_index * current_time_scale;
    }

     // Anchor Flail:
    if(anchor_spin != 0){
        gunangle += anchor_spin + current_time_scale;
        gunangle = ((gunangle + 360) mod 360);
        speed = max(speed, 1.5);

         // Spinning Anchor:
        var _ang = gunangle;
        scrRight(_ang);

        if(instance_exists(anchor)){
            sprite_index = spr_walk;
            with(anchor){
                direction = _ang;
                image_angle = direction;
            }

             // Throw Out Anchor:
            if(anchor_throw > 0){
                anchor.speed += anchor_throw * current_time_scale;
                anchor_throw -= current_time_scale;
            }

             // Retract Anchor:
            if(anchor_retract){
                anchor.speed -= 0.5 * current_time_scale;
                if(anchor.speed <= 0){
                    with(anchor) instance_destroy();
                    anchor = noone;
                }
            }
        }

        else{
            if(alarm0 < 20) sprite_index = spr_chrg;

             // Stop Spinning:
            if(anchor_retract){
                anchor_spin *= 0.8;
                if(abs(anchor_spin) < 1){
                    anchor_spin = 0;
                    anchor_throw = 0;
                    anchor_retract = false;
                }
            }

             // Build Up Speed:
            else{
                anchor_spin += sign(anchor_spin) * 0.4 * current_time_scale;
                var c = 20;
                anchor_spin = clamp(anchor_spin, -c, c);
            }
        }

         // Effects:
        if(current_frame_active){
            with(instance_create(x, y, Dust)){
                motion_add(_ang, 2);
            }

             // Swoop Sounds:
            if(((_ang + 360) mod 360) < abs(anchor_spin)){
                var _snd = 1.5;
                if(instance_exists(anchor)) _snd = 8;
                sound_play_pitchvol(sndMeleeFlip, 0.1 + random(0.1), _snd);
            }
        }
    }

    else{
         // Unequip Anchor:
        if(anchor_swap){
            anchor_swap = false;
            sound_play(sndMeleeFlip);
            instance_create(x, y, WepSwap);
        }

         // Spin Mine:
        if(instance_exists(my_mine)){
             // Turn Gradually:
            if(my_mine_spin == 0){
                my_mine_ang += angle_difference(gunangle, my_mine_ang) / 5;
            }

             // Spinny Momentum:
            else{
                my_mine_ang += my_mine_spin * current_time_scale;
                my_mine_ang = ((my_mine_ang + 360) mod 360);
                scrRight(my_mine_ang);

                my_mine_spin += 1.5 * sign(my_mine_spin) * current_time_scale;

                 // Animate:
                sprite_index = spr_chrg;
            }

             // Holding:
            with(my_mine){
                var _dis = 16,
                    _dir = other.my_mine_ang;

                x = other.x + lengthdir_x(_dis, _dir);
                y = other.y + lengthdir_y(_dis, _dir);

                if(other.my_mine_spin != 0){
                    image_angle += other.my_mine_spin / 3;

                     // Starting to Toss:
                    if(other.alarm0 < 5){
                        z = sqr(5 - other.alarm0);
                        zspeed = 0;
                    }

                     // FX:
                    if(current_frame_active){
                        instance_create(x, y, Dust);
                    }
                }
            }
        }

         // Pick Up Mines:
        else{
            my_mine = noone;
            if(place_meeting(x, y, CustomHitme)){
                with(instances_named(CustomHitme, "SealMine")){
                    if(place_meeting(x, y, other)){
                        with(other){
                            alarm0 = 20;
                            my_mine = other;
                            my_mine_ang = point_direction(x, y, other.x, other.y);
                            scrRight(my_mine_ang);
                        }
                        creator = other;
                        hitid = other.hitid;

                         // Effects:
                        sound_play_pitchvol(sndSwapHammer, 0.6 + orandom(0.1), 0.8);
                        for(var a = direction; a < direction + 360; a += (360 / 20)){
                            with(instance_create(x, y, Dust)){
                                motion_add(a, 4);
                            }
                        }

                        break;
                    }
                }
            }
        }
    }

#define SealHeavy_alrm0
    alarm0 = 90 + random(30);

    target = instance_nearest(x, y, Player);

     // Lob Mine:
    if(my_mine != noone && my_mine_spin != 0){
        sprite_index = spr_idle;
        with(my_mine){
            zspeed = 10;
            direction = point_direction(x, y, other.target_x, other.target_y);
            speed = ((point_distance(x, y, other.target_x, other.target_y) - z) * zfric) / (zspeed * 2);
        }
        my_mine = noone;
        my_mine_spin = 0;

        scrWalk(5, gunangle);

         // Effects:
        sound_play_pitch(sndAssassinGetUp, 0.5 + orandom(0.2));
        sound_play_pitchvol(sndAssassinAttack, 0.8 + orandom(0.1), 0.8);
    }

    else{
         // Spinning Anchor:
        if(anchor_spin != 0){
             // Throw Out Anchor:
            if(!instance_exists(anchor)){
                alarm0 = 60;
                anchor = scrEnemyShoot("SealAnchor", gunangle, 0);
                anchor_throw = 8;
                if(instance_exists(target)) direction = point_direction(x, y, target.x, target.y);

                 // Effects:
                sound_play_pitch(sndHammer, 0.8 + orandom(0.1));
                repeat(5) with(instance_create(x, y, Dust)){
                    motion_add(other.gunangle, 4);
                }
            }

             // Retract Anchor:
            else{
                alarm0 = 120 + random(30);
                anchor_retract = true;
            }
        }

        else if(target_is_visible()){
            var _targetDir = point_direction(x, y, target.x, target.y);

            target_x = target.x;
            target_y = target.y;

             // Not Holding Mine:
            if(my_mine == noone){
                 // Pick Up Mine:
                if(distance_to_object(Floor) > 24 && random(4) < 3){
                    alarm0 = 20;
                    gunangle = _targetDir;
                    my_mine = obj_create(x, y, "SealMine");
                    my_mine_ang = gunangle;
                    with(my_mine){
                        zspeed = 5;
                        creator = other;
                        hitid = other.hitid;
                    }
                }

                 // On Land:
                else{
                     // Start Spinning Anchor:
                    if((target_in_distance(0, 180) && random(4) < 3) || target_in_distance(0, 100)){
                        alarm0 = 45;
                        gunangle = _targetDir;
                        anchor_spin = choose(-1, 1) * 5;
                        sound_play_pitch(sndRatMelee, 0.5 + orandom(0.1));

                         // Equip Anchor:
                        anchor_swap = true;
                        sound_play(sndSwapHammer);
                        instance_create(x, y, WepSwap);
                    }

                     // Walk Closer:
                    else alarm0 = 30 + random(30);
                    scrWalk(8 + random(16), _targetDir + orandom(30));
                }
            }

             // Holding Mine:
            else{
                if(instance_exists(my_mine)){
                    alarm0 = 20;

                    if(target_in_distance(0, 144)){
                         // Too Close:
                        if(target_in_distance(0, 48)){
                            scrWalk(20, _targetDir + 180);
                            gunangle = _targetDir;
                        }

                         // Start Toss:
                        else{
                            gunangle = _targetDir;
                            my_mine_ang = _targetDir;
                            my_mine_spin = choose(-1, 1);

                            sound_play_pitch(sndRatMelee, 0.5 + orandom(0.1));
                            sound_play_pitch(sndSteroidsUpg, 0.75 + orandom(0.1));
                            repeat(5) with(instance_create(target_x, target_y, Dust)){
                                motion_add(random(360), 3);
                            }
                        }
                    }

                     // Out of Range:
                    else scrWalk(10 + random(10), _targetDir + orandom(20));
                }
                else my_mine = noone;
            }
        }

         // Passive Movement:
        else scrWalk(5, random(360));
    }

#define SealHeavy_draw
    var _drawWep = (sprite_index != spr_spwn || image_index > 2);

     // Back Anchor:
    if(!anchor_swap && _drawWep){
        draw_sprite_ext(spr_weap, 0, x + right, y + 6, 1, 1, 90 + (right * 30), image_blend, image_alpha);
    }

    if(gunangle >  180) draw_self_enemy();

    if(anchor_swap && _drawWep && !instance_exists(anchor)){
        draw_weapon(spr_weap, x, y, gunangle, 0, wkick, 1, image_blend, image_alpha);
    }

    if(gunangle <= 180) draw_self_enemy();

#define SealHeavy_death
    pickup_drop(50, 0);


#define SealMine_step
     // Animate:
    if(sprite_index != spr_hurt || anim_end){
        sprite_index = spr_idle;
    }

     // Z-Axis:
    z_engine();
    image_angle -= sign(hspeed) * (abs(vspeed / 2) + abs(hspeed));
    if(z <= 0){
        friction = 0.4;
        mask_index = mskWepPickup;

         // Movement:
        if(speed > 0){
            var m = 4;
            if(speed > m) speed = m;

             // Effects:
            if(current_frame_active && random(5) < 1){
                instance_create(x, y + 8, Dust);
                if(place_meeting(x, y, Floor)){
                    sound_play_pitchvol(asset_get_index(`sndFootPla${choose("Rock", "Sand", "Metal")}${irandom(5) + 1}`), 0.6, 0.6);
                }
            }
        }

         // Impact:
        if(zspeed < -10){
            if(distance_to_object(Floor) < 20 || place_meeting(x, y, Player)){
                my_health = 0;
            }

             // Splash FX:
            else{
                var _ang = orandom(20);
                for(var a = _ang; a < _ang + 360; a += (360 / 2)){
                    with(scrWaterStreak(x, y, a, 4)){
                        hspeed += other.hspeed / 2;
                        vspeed += other.vspeed / 2;
                    }
                }
                sound_play_pitch(sndOasisExplosionSmall, 2);
            }
        }

         // On Land:
        if(place_meeting(x, y, Floor)) friction *= 1.5;

         // Floating in Water:
        else{
            nowade = false;
            image_angle += sin(current_frame / 20) * 0.5;
        }

        zspeed = 0;
        z = 0;
    }

     // In Air:
    else{
        friction = 0;
        mask_index = mskNone;
        nowade = true;
        wading = 0;
    }

     // Push:
    if(place_meeting(x, y, hitme)){
        with(instances_matching_ne(hitme, "id", creator)) if(place_meeting(x, y, other)){
            with(other){
                motion_add(point_direction(other.x, other.y, x, y), other.size / 5);
            }
            if(!instance_is(self, prop)){
                motion_add(point_direction(other.x, other.y, x, y), other.size / 2);
            }
        }
    }

    if(my_health <= 0) instance_destroy();

#define SealMine_draw
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

#define SealMine_destroy
     // Explode:
    with(instance_create(x, y, Explosion)) hitid = other.hitid;
    sound_play(sndExplosion);

     // Shrapnel:
    for(var a = direction; a < direction + 360; a += (360 / 6)){
        with(instance_create(x, y, EnemyBullet3)){
            motion_add(a + orandom(20), 7 + random(4));
            creator = other.creator;
            hitid = other.hitid;
        }
    }
    sound_play_hit(sndFlakExplode, 0.2);


#define TrafficCrab_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);

     // Attack Sprite:
    if(ammo > 0){
        sprite_index = spr_fire;
        image_index = 0;
    }

#define TrafficCrab_alrm0
     // Spray Venom:
    if(ammo > 0){
        alarm0 = 2;
        walk = 1;

        sound_play(sndOasisCrabAttack);
        sound_play_pitchvol(sndFlyFire, 2 + random(1), 0.5);

         // Venom:
        var _x = x + (right * (4 + (sweep_dir * 10))),
            _y = y + 4;

        repeat(choose(2, 3)){
            scrEnemyShootExt(_x, _y, "TrafficCrabVenom", gunangle + orandom(10), 10 + random(2));
        }
        gunangle += (sweep_dir * sweep_spd);

         // End:
        if(--ammo <= 0){
            alarm0 = 30 + random(20);
            sprite_index = spr_idle;

             // Move Towards Player:
            var _dir = (instance_exists(target) ? point_direction(x, y, target.x, target.y) : random(360));
            scrWalk(15, _dir);

             // Switch Claws:
            sweep_dir *= -1;
        }
    }

     // Normal AI:
    else{
        alarm0 = 35 + random(15);
        target = instance_nearest(x, y, Player);

        if(target_is_visible()){
            var _targetDir = point_direction(x, y, target.x, target.y);

             // Attack:
            var _max = 128;
            if(target_in_distance(0, _max)){
                scrWalk(1, _targetDir + (sweep_dir * random(90)));

                alarm0 = 1;
                ammo = 10;
                gunangle = _targetDir - (sweep_dir * (sweep_spd * (ammo / 2)));

                sound_play_pitch(sndScorpionFireStart, 0.8);
                sound_play_pitch(sndGoldScorpionFire, 1.5);
            }

             // Move Towards Player:
            else scrWalk(30, _targetDir + (random_range(20, 40) * choose(-1, 1)));

             // Facing:
            scrRight(_targetDir);
        }

         // Passive Movement:
        else scrWalk(10, random(360));
    }

#define TrafficCrab_death
    pickup_drop(10, 10);

     // Splat:
    var _ang = random(360);
    for(var a = _ang; a < _ang + 360; a += (360 / 3)){
        with(instance_create(x, y, MeleeHitWall)){
            motion_add(a, 1);
            image_angle = direction + 180;
            image_blend = make_color_rgb(174, 58, 45);//make_color_rgb(133, 249, 26);
        }
    }


#define TrafficCrabVenom_step
    if(speed <= 0) instance_destroy();

#define TrafficCrabVenom_hit
    if(projectile_canhit_melee(other)){
        projectile_hit_push(other, damage, force);
    }

#define TrafficCrabVenom_anim
    image_speed = 0;
    image_index = image_number - 1;

#define TrafficCrabVenom_destroy
    with(instance_create(x, y, BulletHit)) sprite_index = sprScorpionBulletHit;


#define ClamChest_open(_player)
    var w = ["harpoon", "bubble rifle", "bubble shotgun"],
        _wep = "";

     // Random Cool Wep:
    var m = 0;
    do _wep = w[irandom(array_length(w) - 1)];
    until (mod_exists("weapon", _wep) || ++m > 200);

    if(mod_exists("weapon", _wep)){
        with(instance_create(x, y, WepPickup)){
            wep = _wep;
            ammo = true;
        }
    }

     // Angry puffer cause you dont have cool weapons loaded
    else with(obj_create(x, y, "Puffer")){
        instance_create(x, y, AssassinNotice);
    }


#define Hammerhead_step
    enemyAlarms(1);
    if(sprite_index != spr_chrg) enemySprites();
    enemyWalk(walkspd, maxspd);

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
                if(random(2) < 1) with(instance_create(x + 8, y + 8, Hammerhead)){
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

#define Hammerhead_alrm0
    alarm0 = 30 + random(20);

    target = instance_nearest(x, y, Player);
    if(target_in_distance(0, 256)){
        var _targetDir = point_direction(x, y, target.x, target.y);
        if(target_is_visible()){
             // Close Range Charge:
            if(target_in_distance(0, 96) && random(4) < 3){
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
            if(my_health < maxhealth && random(3) < 1){
                charge = 30;
                charge_wait = 15;
                charge_dir = _targetDir;
                alarm0 = charge + charge_wait + random(10);
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
        alarm0 += random(walk);
    }

    scrRight(direction);

#define Hammerhead_death
    pickup_drop(30, 8);


#define Puffer_step
    enemyAlarms(1);
    enemyWalk(walkspd, maxspd);

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
        if(current_frame_active && random(4) < 3){
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

#define Puffer_alrm0
    alarm0 = 20 + random(30);
    target = instance_nearest(x, y, Player);

    if(blow <= 0){
        if(instance_exists(target)){
            var _targetDir = point_direction(x, y, target.x, target.y);

             // Puff Time:
            if(target_is_visible() && target_in_distance(0, 256) && random(2) < 1){
                alarm0 = 30;

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
            else scrWalk(alarm0, _targetDir + orandom(20));
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

#define Puffer_draw
    var h = (sprite_index != spr_hurt && nexthurt > current_frame + 3);
    if(h) d3d_set_fog(1, c_white, 0, 0);
    draw_self_enemy();
    if(h) d3d_set_fog(0, 0, 0, 0);

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


#define Crack_step
    if !image_index && place_meeting(x,y,Player){
        image_index = 1;
        with instance_create(x,y,Portal){
            image_alpha = 0;
        }
        sound_stop(sndPortalOpen);
        sound_play_pitchvol(sndNothingHurtMid,0.6,0.7);
        sound_play_pitchvol(sndNothingBeamEnd,0.4,1);
        with(GameCont){
            area = "trench";
            subarea = 0;
        }
        repeat(10) instance_create(x+orandom(8),y+orandom(8),Bubble);
        repeat(10) with instance_create(x,y,Debris){
            motion_add(irandom(359),3+random(3));
        }
    }

#define Angler_step
    enemyAlarms(1);
    if sprite_index != spr_appear || (image_index < 1 && image_speed > 0){
        if sprite_index == spr_appear && speed > 0
            sprite_index = spr_walk;
        enemySprites();
    }
    enemyWalk(walkspd, maxspd);

#define Angler_draw
    if hiding{
        draw_set_blend_mode(bm_add);
        draw_sprite_ext(sprRadChestGlow, image_index, x + 6 * right, y + 8, image_xscale * right * 2, image_yscale * 2, image_angle, image_blend, 0.1);
        draw_set_blend_mode(bm_normal);
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
    }
    draw_self_enemy();

#define Angler_hurt(_hitdmg, _hitvel, _hitdir)
    if hiding
        scrAnglerAppear();
    enemyHurt(_hitdmg, _hitvel, _hitdir);

#define Angler_alrm0
    alarm0 = 20 + irandom(20);
    target = instance_nearest(x, y, Player);


    if !hiding{
         // Walk:
        if target_is_visible() && target_in_distance(0, 128){
             // Walk towards target:
            scrWalk(25 + irandom(25), point_direction(x, y, target.y, target.y));
        }
        else{
             // Wander:
            scrWalk(20 + irandom(30), direction + orandom(30));
        }
         // Face right:
        scrRight(direction);
    }
    else{
        alarm0 = 6 + irandom(6);
         // Stop hiding:
        if target_is_visible() && target_in_distance(0, 48){
            scrAnglerAppear();
        }
    }

#define Angler_death
    pickup_drop(80, 0);
    pickup_drop(60, 5);

#define scrAnglerAppear
    view_shake_at(x, y, 10);
    with instance_create(x, y, PortalClear){
        team = other.team;
    }
    image_speed = 0.4; image_index = 1;
    mask_index = mskFireBaller;
    spr_shadow = shd64B;
        spr_shadow_y = 5;
        spr_shadow_x = 0;
    hiding = false;

#define Eel_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);

    wave += current_time_scale;

     // Arc Lightning w/ Jelly:
    if(instance_exists(arc_inst) && point_distance(x, y, arc_inst.x, arc_inst.y) < 100){
         // Start Arcing:
        if(arcing < 1){
            arcing += 0.15;

            var _dis = random(point_distance(x, y, arc_inst.x, arc_inst.y)),
                _dir = point_direction(x, y, arc_inst.x, arc_inst.y);

            with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), choose(PortalL, PortalL, LaserCharge))){
                motion_add(random(360), 1);
                alarm0 = 8;
            }
            if(arcing >= 1){
                sound_play_pitch(sndLightningHit, 2);

                 // Color:
                var c = min(arc_inst.c,2);
                spr_idle = spr.EelIdle[c];
                spr_walk = spr_idle;
                spr_hurt = spr.EelHurt[c];
                spr_dead = spr.EelDead[c];
                spr_tell = spr.EelTell[c];
                if sprite_index != spr_hurt
                    sprite_index = spr_walk;
            }
        }

         // Arcing:
        else{
            with(lightning_connect(x, y, arc_inst.x, arc_inst.y, 12 * sin(wave / 30))){
                image_index = (other.wave * image_speed) mod image_number;
                image_speed_raw = image_number;
                hitid = other.arc_inst.hitid;
                team = other.arc_inst.team;
                creator = other.arc_inst;

                 // Effects:
                if(random(100) < 1){
                    with(instance_create(x + random_range(-8, 8), y + random_range(-8, 8), PortalL)){
                        motion_add(random(360), 1);
                    }
                    sound_play_hit(sndLightningReload, 0.5);
                }
            }
        }
    }
    else{
        arc_inst = noone;
        arcing = 0;

        var _inst = nearest_instance(x, y, instances_named(CustomEnemy, "Jelly"));
        if(instance_exists(_inst) && point_distance(x, y, _inst.x, _inst.y) < 100) arc_inst = _inst;
    }

#define Eel_alrm0
    alarm0 = 30;
    target = instance_nearest(x,y,Player);
    if ammo{
        alarm0 = 3;
        ammo--;

        var _dist = irandom(256);
        repeat(2)
            with instance_create(x + lengthdir_x(_dist, gunangle), y + lengthdir_y(_dist, gunangle), LaserCharge){
                alarm0 = 6;
                motion_set(irandom(359), 2);
                if collision_line(x, y, other.x, other.y, Wall, 0, 0) instance_destroy();
            }

         // Shoot:
        if ammo <= 0{
            sound_play(sndLaser);
            with scrEnemyShoot(EnemyLaser, gunangle + orandom(15), 0){
                    alarm0 = 1;
                }
        }
    }
    else{
         // Begin shoot laser
        if instance_exists(arc_inst) && arc_inst.c == 3 && random(5) < 1 && target_is_visible() && target_in_distance(0,96){
            alarm0 = 3;
            ammo = 10;
            gunangle = point_direction(x, y, target.x, target.y);
            sound_play(sndLaserCrystalCharge);
        }
        else{
             // When you walking:
            if target_is_visible(){
                scrWalk(irandom_range(23,30), point_direction(x,y,target.x,target.y)+orandom(20));
            }
            else
                scrWalk(irandom_range(17,30), direction+orandom(30));
        }
    }

#define Eel_draw
    if pitDepth == 0
        draw_self_enemy();

#define Jelly_step
    enemyAlarms(2);
    if sprite_index != spr_fire
        enemySprites();
    var _maxSpd = clamp(0.07*walk*current_time_scale,1,maxspd); // arbitrary values, feel free to fiddle
    enemyWalk(walkspd, _maxSpd);

    if(place_meeting(x + hspeed, y + vspeed, Wall)) {
        move_bounce_solid(false);
        scrRight(direction);
    }

#define Jelly_alrm0
    alarm0 = 40 + random(20);
     // Always movin':
    scrWalk(alarm0,direction);
    target = instance_nearest(x, y, Player);
    if target_is_visible(){
         // Steer towards target:
        motion_add(point_direction(x,y,target.x,target.y),0.4);
         // Attack:
        if random(5) < 1 && target_in_distance(32,256){
             // Shoot lightning disc:
            scrEnemyShoot("LightningDiscEnemy", point_direction(x, y, target.x, target.y), 8);

             // Effects:
            sound_play_hit(sndLightningHit, 0.25);
            sound_play_pitch(sndLightningCrystalCharge,0.8);
            sprite_index = spr_fire;
            alarm1 = 30;
        }
    }
    scrRight(direction);

#define Jelly_alrm1
    sprite_index = spr_walk;

#define Jelly_death
    pickup_drop(70, 2);


#define PitSquid_step
    enemyAlarms(2);

     // Pit Z Movement:
    if(sink){
         // Quickly Sink:
        pit_height -= 0.075 * current_time_scale;
        with(eye) blink = true;

         // Start Rising:
        if(pit_height <= 0){
            sink = false;
            x = sink_targetx;
            y = sink_targety;
            pit_height = -random_range(0.2, 0.5);
        }
    }
    else{
         // Slow Initial Rise:
        if(pit_height < 0.5){
            pit_height += abs(sin(current_frame / 30)) * 0.01 * current_time_scale;

             // Prepare Bite:
            if(bite <= 0 && pit_height > 0.3){
                bite = 1.2;
            }
        }

         // Quickly Rise:
        else if(pit_height < 1){
            pit_height += 0.1;

             // Reached Top of Pit:
            if(pit_height >= 1){
                pit_height = 1;
                view_shake_at(x, y, 30);
                sound_play(sndOasisExplosion);
            }
        }
    }

     // Sinking/Rising FX:
    if(in_range(pit_height, 0.5, 0.9) && current_frame_active){
        instance_create(x + orandom(32), y + orandom(32), Smoke);
        view_shake_at(x, y, 4);
    }

     // Movement:
    if(speed > 0){
        eye_angle += (speed / 3) * current_time_scale;
        direction += sin(current_frame / 20) * current_time_scale;

         // Effects:
        if(current_frame_active){
            view_shake_max_at(x, y, min(speed * 4, 3));
            if(random(10) < speed){
                instance_create(x + orandom(40), y + orandom(40), Bubble);
            }
        }
    }

     // Find Nearest Visible Player:
    var	_target = noone,
		d = 1000000;

	with(Player) if(!collision_line(x, y, other.x, other.y, Wall, 0, 0)){
		var _dis = point_distance(x, y, other.x, other.y);
		if(_dis < d){
			_target = id;
			d = _dis;
		}
	}

     // Eyes:
    for(var i = 0; i < array_length(eye); i++){
        var _dis = (24 + eye_dis_offset) * max(pit_height, 0),
            _dir = image_angle + eye_angle + (360 / array_length(eye)) * i,
            _x = x + lengthdir_x(_dis * image_xscale, _dir),
            _y = y + lengthdir_y(_dis * image_yscale, _dir);

        with(eye[i]){
            x = _x;
            y = _y;

             // Eye Under Floor:
            var _cansee = false;
            with(instance_nearest(_x - 16, _y - 16 - 8, Floor)){
                if(styleb) _cansee = true;
            }

             // Look at Player:
            var _seen = false;
            if(_cansee && instance_exists(_target)){
                _seen = true;
                dir += angle_difference(point_direction(x, y, _target.x, _target.y), dir) / 2;
                dis = clamp(point_distance(x, y, _target.x, _target.y) / 6, 0, 5);
            }
            else dir += sin((current_frame) / 20) * 1.5;

             // Blinking:
            if(blink){
                var n = sprite_get_number(spr.PitSquidEyelid) - 1;
                blink_img = min(blink_img + other.image_speed, n);

                 // End Blink:
                if(blink_img >= n){
                    if(random(4) < 1 && instance_exists(Player)){
                        blink = false;
                    }
                }
            }
            else{
                blink_img = max(blink_img - other.image_speed, 0);

                 // New Blink:
                if(blink_img <= 0){
                    if(current_frame_active && random(_seen ? 150 : 100) < 1){
                        blink = true;
                    }
                }
            }
        }
    }

     // Bite:
    var o = 0;
    if(bite > 0){
        o = 8;

        var _spr = spr.PitSquidMaw,
            _img = ((1 - bite) * sprite_get_number(_spr));

         // Finish chomp at top of pit:
        if(_img < 6 || pit_height > 0.5){
            bite -= (image_speed / sprite_get_number(_spr)) * current_time_scale;
        }

         // Bite Time:
        if(in_range(_img, 8, 9)){
            mask_index = _spr;
            image_index = _img;
            if(place_meeting(x, y, hitme)){
                with(instances_matching_ne(hitme, "team", team)){
                    if(place_meeting(x, y, other)) with(other){
                        if(projectile_canhit_melee(other)){
                            projectile_hit_raw(other, meleedamage, true);
                        }
                    }
                }
            }
            mask_index = mskNone;

             // Chomp FX:
            if(_img - image_speed < 8){
                sound_play_pitchvol(snd_mele, 0.8 + orandom(0.1), 0.8);
                sound_play_pitchvol(sndOasisChest, 0.8 + orandom(0.1), 1);
                repeat(3) instance_create(x, y + 16, Bubble);
            }
        }
    }
    eye_dis_offset += ((o - eye_dis_offset) / 5) * current_time_scale;

    /*if(button_pressed(0, "horn")){
        scrBossIntro(name, sndBigBanditIntro, musBoss2);
    }*/

    if(button_pressed(0, "horn")){
        alarm1 = 4;
        ammo = 6;
        gunangle = point_direction(x, y, mouse_x, mouse_y);
    }
    if(button_pressed(0, "key8")){
        sink = true;
    }
    if(button_pressed(0, "key9")){
        bite = 1.2;
    }

#define PitSquid_end_step
     // Collisions:
    if(pit_height > 0.5){
        mask_index = mskReviveArea;

         // Wall Collision:
        if(place_meeting(x, y, Wall)){
            speed *= 0.8;
            x = xprevious;
            y = yprevious;
            if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
            if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;
            if(!place_meeting(x + hspeed, y, Wall)) x += hspeed;
            if(!place_meeting(x, y + vspeed, Wall)) y += vspeed;
        }

         // Floor Collision:
        if(place_meeting(x, y, Floor)){
            var f = noone;
            with(instances_matching(Floor, "styleb", false)) if(place_meeting(x, y, other)){
                f = id;
                break;
            }
            if(instance_exists(f)){
                speed *= 0.8;
                x = xprevious;
                y = yprevious;
                if(place_meeting(x + hspeed, y, f)) hspeed *= -1;
                if(place_meeting(x, y + vspeed, f)) vspeed *= -1;
                if(!place_meeting(x + hspeed, y, f)) x += hspeed;
                if(!place_meeting(x, y + vspeed, f)) y += vspeed;
            }
        }

         // Destroy Stuff:
        if(pit_height >= 1){
            var _xsc = image_xscale,
                _ysc = image_yscale;

             // Clear Walls:
            if(place_meeting(x, y, Wall)){
                image_xscale = _xsc * 1.6;
                image_yscale = _ysc * 1.6;
                with(Wall) if(place_meeting(x, y, other)){
                    instance_create(x, y, FloorExplo);
                    instance_destroy();
                }
            }
    
             // Clear Floors:
            if(place_meeting(x, y, Floor)){
                var _floors = instances_matching(Floor, "styleb", false),
                    f = noone;
    
                with(_floors) if(place_meeting(x, y, other)){
                    f = id;
                    break;
                }
                if(instance_exists(f)){
                    image_xscale = _xsc * 1.2;
                    image_yscale = _ysc * 1.2;
                    with(_floors) if(place_meeting(x, y, other)){
                        styleb = true;
                        sprite_index = area_get_sprite(GameCont.area, sprFloor1B);
                        depth = 8;
                        material = 0;
                        traction = 0.1;

                         // Effects:
                        sound_play_pitchvol(sndWallBreak, 0.6 + random(0.4), 1.5);
                        repeat(sprite_width / 8){
                            instance_create(x + random(32), y + random(32), Debris);
                        }

                         // TopSmall Fix:
                        if(place_meeting(x, y, TopSmall)){
                            with(TopSmall) if(place_meeting(x, y, other)){
                                instance_destroy();
                            }
                        }
                    }
                    mod_variable_set("area", "trench", "surf_reset", true);
                }
            }

            image_xscale = _xsc;
            image_yscale = _ysc;
        }
    }
    mask_index = mskNone;

#define PitSquid_alrm0
    alarm0 = 30 + random(30);

    target = instance_nearest(x, y, Player);
    if(instance_exists(target)){
        var _targetDis = point_distance(x, y, target.x, target.y),
            _targetDir = point_direction(x, y, target.x, target.y);

        if(_targetDis > 96 || pit_height < 1 || random(2) < 1){
            motion_add(_targetDir, 1);
            sound_play_pitchvol(sndRoll, 0.2 + random(0.2), 2)
            sound_play_pitchvol(sndFishRollUpg, 0.4, 0.2);
        }

        if(pit_height >= 1 && random(2) < 1){
             // Check LOS to Player:
            var _targetSeen = (target_is_visible() && target_in_distance(0, 256));
            if(_targetSeen){
                var f = instances_matching(Floor, "styleb", true);
                with(f) x -= 10000;
                if(collision_line(x, y, target.x, target.y, Floor, false, false)){
                    _targetSeen = false;
                }
                with(f) x += 10000;
            }
    
             // Sink into pit:
            if(!_targetSeen){
                sink = true;
                sink_targetx = target.x;
                sink_targety = target.y;
                alarm0 = 60;
            }
        }
    }

#define PitSquid_alrm1
    alarm1 = 60 + random(30);

    if(pit_height >= 1){
        target = instance_nearest(x, y, Player);

        if(instance_exists(target)){
            var _targetDis = point_distance(x, y, target.x, target.y),
                _targetDir = point_direction(x, y, target.x, target.y);

            if(point_distance(target.x, target.y, x + hspeed, y + vspeed + 16) > 64){
                var c = id;
                with(target){
                    var f = instance_nearest(x - 16, y - 16, Floor),
                        e = instance_nearest(x - 8, y - 8, FloorExplo);
            
                    if((f.styleb || !place_meeting(x, y, f)) || (e.styleb || !place_meeting(x, y, e))){
                        other.alarm1 = 60 + random(30);
                        with(obj_create(x, y, "Tentacle")){
                            alarm0 = 20;
                            team = c.team;
                            creator = c;
                        }
                    }
                }
            }
    
             // Bite Player:
            else{
                motion_set(_targetDir, _targetDis / 32);
                bite = 1.2;
            }
        }
    }

    /*if(ammo > 0){
        alarm1 = 4;

        var _dis = 60 + (24 * (6 - ammo)),
            _dir = gunangle;

        with(obj_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), "Tentacle")){
            creator = other;
            xoff = x - other.x;
            yoff = y - other.y;
            dir = _dir + (90 * (((other.ammo % 2) * 2) - 1));
            spd = 5;
            move_delay = 4 * (other.ammo - 1);
            depth -= y / 20000;
        }

        ammo--;
    }*/


#define Tentacle_step
    if(sprite_index != mskNone){
        if(instance_exists(creator)){
             // Animate:
            if(sprite_index != spr_idle){
                if((sprite_index != spr_hurt && sprite_index != spr_spwn) || anim_end){
                    sprite_index = spr_idle;
                }
            }

             // Keep w/ Pit Squid:
            if(spd != 0){
                x = creator.x + xoff;
                y = creator.y + yoff;
                if(move_delay <= 0){
                    xoff += lengthdir_x(spd, dir);
                    yoff += lengthdir_y(spd, dir);
                    spd -= clamp(spd, -friction, friction);
                    if(spd <= 0) with(creator){
                        motion_add(point_direction(x, y, other.x, other.y), 0.4);
                    }
                    if(sprite_index != spr_hurt){
                        sprite_index = spr_hurt;
                        image_index = 1;
                    }
                    scrRight(dir + 180);
                    //instance_create(x, y, Dust);
                }
                else move_delay -= current_time_scale;
    
                 // Clear Walls:
                if(place_meeting(x, y, Wall)){
                    with(Wall) if(place_meeting(x, y, other)){
                        instance_create(x, y, FloorExplo);
                        instance_destroy();
                    }
                }
    
                 // Clear Floors:
                if(place_meeting(x, y, Floor)){
                    var _floors = instances_matching(Floor, "styleb", false),
                        f = noone;
        
                    with(_floors) if(place_meeting(x, y, other)){
                        f = id;
                        break;
                    }
                    if(instance_exists(f)){
                        with(_floors) if(place_meeting(x, y, other)){
                            styleb = true;
                            sprite_index = area_get_sprite(GameCont.area, sprFloor1B);
                            depth = 8;
                            material = 0;
                            traction = 0.1;
    
                             // Effects:
                            sound_play_pitchvol(sndWallBreak, 0.6 + random(0.4), 1.5);
                            sound_play_pitchvol(sndWallBreakRock, 1 + orandom(0.2), 0.3 + random(0.2));
                            repeat(sprite_width / 8){
                                instance_create(x + random(32), y + random(32), Debris);
                            }
    
                             // TopSmall Fix:
                            if(place_meeting(x, y, TopSmall)){
                                with(TopSmall) if(place_meeting(x, y, other)){
                                    instance_destroy();
                                }
                            }
                        }
                        mod_variable_set("area", "trench", "surf_reset", true);
                    }
                }
            }
    
             // Retract:
            else if(point_distance(x, y, creator.x + creator.hspeed, creator.y + creator.vspeed + 16) < 64 || creator.pit_height < 1){
                my_health = 0;
                raddrop = 0;
                snd_dead = -1;
                sound_play_pitchvol(sndBigMaggotBurrow, 2 + orandom(0.2), 0.6);
            }
        }
        else if(sprite_index != spr_spwn || anim_end){
            my_health = 0;
        }
    }
    else my_health = maxhealth;
    speed = 0;
    enemyAlarms(1);

#define Tentacle_hurt(_hitdmg, _hitvel, _hitdir)
    if(sprite_index != mskNone){
        my_health -= _hitdmg;
        nexthurt = current_frame + 6;
        sound_play_hit(snd_hurt, 0.3);
    
         // Hurt Papa Squid:
        with(creator){
            my_health -= _hitdmg;
            nexthurt = current_frame + 6;
            sound_play_hit(snd_hurt, 0.3);
        }
    
         // Hurt Sprite:
        if(sprite_index != spr_spwn){
            sprite_index = spr_hurt;
            image_index = 0;
        }
        scrRight(_hitdir + 180);
    }

#define Tentacle_alrm0
    if(creator.pit_height < 1) instance_delete(id);

     // Appear:
    else{
        mask_index = mskOldGuardianDeflect;
        sprite_index = spr_spwn;
        image_index = 0;
        canfly = false;

        sound_play_pitchvol(sndBigMaggotUnburrow, 1.5 + random(1), 1)
    }

#define Tentacle_death
    //repeat(2) instance_create(x, y, Dust);


#define Vent_step
    if random(5) < current_time_scale{
        with instance_create(x,y,Bubble){
            friction = 0.2;
            motion_set(irandom_range(85,95),random_range(4,7));
        }
        // with instance_create(x,y-8,Smoke){
        //     motion_set(irandom_range(65,115),random_range(10,100));
        // }
    }

#define Vent_death
    obj_create(x,y,"BubbleExplosion");

#define YetiCrab_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);

#define YetiCrab_alrm0
    alarm0 = 30 + random(10);
    target = instance_nearest(x, y, Player);

    if(is_king = 0) { // Is a follower:
        if(instance_exists(nearest_instance(x, y, instances_matching(CustomEnemy, "is_king", 1)))) { // Track king:
            var nearest_king = nearest_instance(x, y, instances_matching(CustomEnemy, "is_king", 1));
            var king_dir = point_direction(x, y, nearest_king.x, nearest_king.y);
            if(point_distance(x, y, nearest_king.x, nearest_king.y) > 16 and point_distance(x, y, target.x, target.y) < point_distance(x, y, nearest_king.x, nearest_king.y)) { // Check distance from king:
                scrRight(king_dir);

                 // Follow king in a jittery manner:
                scrWalk(5, king_dir + orandom(5));
                alarm0 = 5 + random(5);
            }

             // Chase player instead:
            else if(target_is_visible()) {
                var _targetDir = point_direction(x, y, target.x, target.y);
                scrRight(_targetDir);

                 // Chase player:
                scrWalk(30, _targetDir + orandom(10));
                scrRight(direction);
            } else {
                 // Crab rave:
                scrWalk(30, random(360));
                scrRight(direction);
            }
        }
         // No leader to follow:
        else if(target_is_visible()) {
            var _targetDir = point_direction(x, y, target.x, target.y);

             // Sad chase :( :
            if(fork()) {
                repeat(irandom_range(4, 10)) {
                    wait random_range(1, 3);
                    if(!instance_exists(other)) exit; else instance_create(x, y, Sweat); // Its tears shhh
                }

                exit;
            }
            scrWalk(30, _targetDir + orandom(10));
            scrRight(direction);
        } else {
             // Crab rave:
            scrWalk(30, random(360));
            scrRight(direction);
        }
    }

     // Is a leader:
    else {
        var _targetDir = point_direction(x, y, target.x, target.y);

         // Chase player:
        scrWalk(30, _targetDir + orandom(10));
        scrRight(direction);
    }




#define draw_bloom
    with(instances_named(CustomProjectile, "TrafficCrabVenom")){
        draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.2 * image_alpha);
    }

#define draw_dark // Drawing Grays
    draw_set_color(c_gray);

     // Jellies:
    with(instances_matching(CustomEnemy, "name", "Jelly")){
        var o = 0,
            _frame = floor(image_index);

        if(
            sprite_index == spr_fire                    ||
            (sprite_index == spr_hurt && _frame != 1)   ||
            (sprite_index == spr_idle && (_frame == 1 || _frame == 3))
        ){
            o = 5;
        }

        draw_circle(x, y, 80 + o + orandom(1), false);
    }

     // Kelp:
    with(instances_matching(CustomProp, "name", "Kelp")){
        draw_circle(x, y, 32 + orandom(1), false);
    }

#define draw_dark_end // Drawing Clear
    draw_set_color(c_black);

     // Jellies:
    with(instances_matching(CustomEnemy, "name", "Jelly")){
        var o = 0,
            _frame = floor(image_index);

        if(
            sprite_index == spr_fire                    ||
            (sprite_index == spr_hurt && _frame != 1)   ||
            (sprite_index == spr_idle && (_frame == 1 || _frame == 3))
        ){
            o = 5;
        }

        draw_circle(x, y, 40 + o + orandom(1), false);
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
#macro sewers "secret"