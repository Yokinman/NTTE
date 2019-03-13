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


#define BabyScorpion_alrm1
    alarm1 = 50 + irandom(30);
    target = instance_nearest(x, y, Player);

    if(target_is_visible()) {
        var _targetDir = point_direction(x, y, target.x + target.hspeed, target.y + target.vspeed);

    	if(target_in_distance(32, 96) > 0 and random(3) < 2){
		    gunangle = _targetDir;

		     // Golden poison shot:
		    if(gold) {
		        repeat(6) scrEnemyShoot("TrafficCrabVenom", gunangle + orandom(30), 5 + random(2));
		        repeat(4) scrEnemyShoot("TrafficCrabVenom", gunangle + orandom(10), 10 + random(4));
		    }

		     // Normal poison shot:
		    else {
		        repeat(2) scrEnemyShoot("TrafficCrabVenom", gunangle + orandom(10), 6 + random(4));
		    }
		    motion_add(_targetDir + 180, 3);
            sound_play_pitch(snd_fire, 1.6);

    		alarm1 = 20 + random(30);
    	}

         // Move Away From Target:
        else if(target_in_distance(0, 32) > 0) {
            alarm1 = 20 + irandom(30);
            scrWalk(10 + random(10), _targetDir + 180 + orandom(40));
        }

         // Move Towards Target:
    	else{
    		alarm1 = 30 + irandom(20);
    		scrWalk(20 + random(15), _targetDir + orandom(40));
    		gunangle = _targetDir + orandom(15);
    	}

    	 // Facing:
    	scrRight(gunangle);
    }

     // Wander:
    else scrWalk(30, random(360));

#define BabyScorpion_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    motion_add(_hitdir, _hitvel);	// Knockback
    nexthurt = current_frame + 6;	// I-Frames

     // Pitched Sound:
    var v = clamp(50 / (distance_to_object(Player) + 1), 0, 2);
    sound_play_pitchvol(snd_hurt, 1.2 + random(0.3), v);

     // Hurt Sprite:
    sprite_index = spr_hurt;
    image_index = 0;

#define BabyScorpion_death
    scrDefaultDrop();

     // Effects:
    var l = 6,
        d = irandom(359);

    for(var i = 0; i < 360; i += 360 / 3){
        with instance_create(x + lengthdir_x(l, d + i), y + lengthdir_y(l, d + i), AcidStreak){
            motion_set(d + i, 4);
            image_angle = direction;
        }
    }
    sound_play_pitchvol(snd_dead, 1.5 + random(0.3), 1.3);
    snd_dead = -1;


#define Bone_step
     // Spin:
    rotation += speed * rotspeed;

     // Into Portal:
    if(place_meeting(x, y, Portal)){
        if(speed > 0){
            sound_play_pitchvol(sndMutant14Turn, 0.6 + random(0.2), 0.8);
            repeat(3) instance_create(x, y, Smoke);
        }
        instance_destroy();
    }

     // Turn Back Into Weapon:
    else if(speed <= 0 || place_meeting(x + hspeed, y + vspeed, PortalShock)){
         // Don't Get Stuck on Wall:
        mask_index = mskWepPickup;
        if(place_meeting(x, y, Wall)){
            instance_create(x, y, Dust);

            var w = instance_nearest(x, y, Wall),
                _dir = point_direction(w.x, w.y, x, y);

            while(place_meeting(x, y, w)){
                x += lengthdir_x(4, _dir);
                y += lengthdir_y(4, _dir);
            }
        }

        instance_destroy();
    }

#define Bone_draw
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, rotation, image_blend, image_alpha);

#define Bone_hit
     // Secret:
    if("name" in other && other.name == "CoastBossBecome"){
        with(other){
            part++;

             // Hit:
            sound_play_hit(snd_hurt, 0.3);
            sprite_index = spr_hurt;
            image_index = 0;
        }

         // Effects:
        sound_play_hit(sndMutant14Turn, 0.2);
        repeat(3){
            instance_create(x + orandom(4), y + orandom(4), Bubble);
            with(instance_create(x, y, Smoke)){
                motion_add(random(360), 1);
                depth = -2;
            }
        }

        instance_delete(id);
        exit;
    }

    if(other.object_index = ScrapBoss) {
        with(other) {
            var c = scrCharm(self, true);
            c.time = 300;
        }
        sound_play(sndBigDogTaunt);
        instance_delete(id);
        exit;
    }

    projectile_hit_push(other, damage, speed * force);

     // Bounce Off Enemy:
    direction = point_direction(other.x, other.y, x, y);
    speed /= 2;
    rotspeed *= -1;

     // Sound:
    sound_play_pitchvol(sndBloodGamble, 1.2 + random(0.2), 0.8);

     // Break:
    var i = nearest_instance(x, y, instances_matching(CustomProp,"name","CoastBossBecome"));
    if !(instance_exists(i) && point_distance(x, y, i.x, i.y) <= 32){
        broken = true;
        instance_destroy();
    }

#define Bone_wall
     // Bounce Off Wall:
    if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
    if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;
    speed /= 2;
    rotspeed *= -1;

     // Effects:
    sound_play_hit(sndHitWall, 0.2);
    instance_create(x, y, Dust);

#define Bone_destroy
    instance_create(x, y, Dust);

     // Darn:
    if(broken){
        sound_play_pitch(sndHitRock, 1.4 + random(0.2));
        repeat(2) with(instance_create(x, y, Shell)){
            sprite_index = spr.BoneShard;
            motion_add(random(360), 2);
        }
    }

     // Pickupable:
    else with(instance_create(x, y, WepPickup)){
        wep = "crabbone";
        rotation = other.rotation;
    }


#define BoneSpawner_step
    if(instance_exists(creator)){
         // Follow Creator:
        x = creator.x;
        y = creator.y;
    }
    else{
         // Enter the bone zone:
        with(instance_create(x, y, WepPickup)){
            wep = "crabbone";
            motion_add(random(360), 3);
        }

         // Effects:
        repeat(2) with(instance_create(x, y, Dust)){
            motion_add(random(360), 3);
        }

        //with(instances_named(object_index, name)) instance_destroy();
        instance_destroy();
    }


#define CoastBossBecome_step
    speed = 0;

     // Animate:
    image_index = part;
    if(nexthurt > current_frame + 3) sprite_index = spr_hurt;
    else sprite_index = spr_idle;

     // Skeleton Rebuilt:
    if(part >= sprite_get_number(spr_idle) - 1){
        with(obj_create(x - (image_xscale * 8), y - 6, "CoastBoss")){
            x = xstart;
            y = ystart;
            right = other.image_xscale;
        }
        with(WantBoss) instance_destroy();
        with(BanditBoss) my_health = 0;
        scrPortalPoof();

        instance_delete(id);
    }

     // Death:
    else if(my_health <= 0) instance_destroy();

#define CoastBossBecome_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);  // Sound

#define CoastBossBecome_destroy
    with(instance_create(x, y, Corpse)){
        sprite_index = other.spr_dead;
        image_xscale = other.image_xscale;
        size = other.size;
    }

     // Death Effects:
    if(part > 0){
        sound_play(sndOasisDeath);
        repeat(part * 2) instance_create(x, y, Bubble);
    }
    else for(var a = direction; a < direction + 360; a += (360 / 10)){
        with(instance_create(x, y, Dust)) motion_add(a, 3);
    }


#define CoastBoss_step
     // Animate:
    if(
        sprite_index != spr_hurt &&
        sprite_index != spr_spwn &&
        sprite_index != spr_dive &&
        sprite_index != spr_rise &&
        sprite_index != spr_efir &&
        sprite_index != spr_fire &&
        sprite_index != spr_chrg
    ){
        if(speed <= 0) sprite_index = spr_idle;
    	else if(sprite_index == spr_idle) sprite_index = spr_walk;
    }
    else if(anim_end){
        var _lstspr = sprite_index;
        if(fork()){
            if(sprite_index == spr_spwn) {
                sprite_index = spr_idle;

                 // Spawn FX:
                hspeed += 2 * right;
                vspeed += orandom(2);
                view_shake_at(x, y, 15);
                sound_play(sndOasisBossIntro);
                instance_create(x, y, PortalClear);
                repeat(10) with(instance_create(x, y, Dust)){
                    motion_add(random(360), 5);
                }

                 // Intro:
                if(!intro){
                    intro = true;
                    scrBossIntro("", sndOasisBossIntro, musBoss1);
                    with(MusCont) alarm_set(3, -1);
                }
                exit; }

            if(sprite_index = spr_dive) {
                sprite_index = spr_idle;

                 // Start Swimming:
                swim = 180;
                direction = 90 - (right * 90);
                swim_ang_frnt = direction;
                swim_ang_back = direction;
                exit; }

            if(sprite_index = spr_hurt || sprite_index == spr_efir){
                sprite_index = spr_idle;
                exit; }

            if(sprite_index = spr_rise){
                sprite_index = spr_idle;
                spr_shadow = spr_shad;
                exit; }

            if(sprite_index = spr_chrg){
                sprite_index = spr_fire;
                exit; }

            if(sprite_index = spr_fire && ammo <= 0){
                sprite_index = spr_efir;
                exit; }
        }
        if(sprite_index != _lstspr) image_index = 0;
    }

     // Movement:
    enemyWalk(walkspd, maxspd);

     // Swimming:
    if(swim > 0){
        swim -= current_time_scale;

         // Jus keep movin:
        if(instance_exists(swim_target)){
            speed += (friction + (swim / 120)) * current_time_scale;

             // Turning:
            var _x = swim_target.x,
                _y = swim_target.y;

            if(point_distance(x, y, _x, _y) < 100){
                var _dis = 80,
                    _dir = direction + (10 * right);

                _x += lengthdir_x(_dis, _dir);
                _y += lengthdir_y(_dis, _dir);
            }

            direction += (angle_difference(point_direction(x, y, _x, _y), direction) / 16) * current_time_scale;
        }
        else swim = 0;

         // Turn Fins:
        swim_ang_frnt += (angle_difference(direction, swim_ang_frnt) / 3) * current_time_scale;
        swim_ang_back += (angle_difference(swim_ang_frnt, swim_ang_back) / 10) * current_time_scale;

         // Break Walls:
        if(place_meeting(x + hspeed, y + vspeed, Wall)){
            speed *= 2/3;

             // Effects:
            var w = instance_nearest(x, y, Wall);
            with(instance_create(w.x, w.y, MeleeHitWall)){
                motion_add(point_direction(x, y, other.x, other.y), 1);
                image_angle = direction + 180;
            }
            sound_play_pitchvol(sndHammerHeadProc, 1.4 + random(0.2), 0.5);

             // Break Walls:
            with(instance_create(x, y, PortalClear)){
                image_xscale /= 2;
                image_yscale = image_xscale;
            }
        }

         // Visual:
        spr_shadow = mskNone;
        if(current_frame_active){
            var _cx = x,
                _cy = bbox_bottom;

             // Debris:
            if((place_meeting(x, y, FloorExplo) && random(30) < 1) || random(40) < 1){
                repeat(irandom(2)){
                    with(instance_create(_cx, _cy, Debris)){
                        speed /= 2;
                    }
                }
            }

             // Ripping Through Ground:
            var _oDis = [16, -4],
                _oDir = [swim_ang_frnt, swim_ang_back],
                _ang = [20, 30];

            for(var o = 0; o < array_length(_oDis); o++){
                for(var i = -1; i <= 1; i += 2){
                    var _x = _cx + lengthdir_x(_oDis[o], _oDir[o]),
                        _y = _cy + lengthdir_y(_oDis[o], _oDir[o]),
                        a = (i * _ang[o]);

                     // Cool Trail FX:
                    if(speed > 1) with(instance_create(_x, _y, BoltTrail)){
                        motion_add(_oDir[o] + 180 + a, (other.speed + random(other.speed)) / 2);
                        image_xscale = speed * 2;
                        image_yscale = (skill_get(mut_bolt_marrow) ? 0.6 : 1);
                        image_angle = direction;
                        hspeed += other.hspeed;
                        vspeed += other.vspeed;
                        friction = random(0.5);
                        //image_blend = make_color_rgb(110, 184, 247);
                    }

                     // Kick up Dust:
                    if(random(20) < 1){
                        with(instance_create(_x, _y, Dust)){
                            hspeed += other.hspeed / 2;
                            vspeed += other.vspeed / 2;
                            motion_add(_oDir[o] + 180 + (2 * a), other.speed);
                            image_xscale *= .75;
                            image_yscale = image_xscale;
                        }
                    }
                }
            }

             // Quakes:
            if(random(4) < 1) view_shake_at(_cx, _cy, 4);
        }

         // Un-Dive:
        if(swim <= 0){
            swim = 0;
            alarm3 = -1;
            image_index = 0;
            sprite_index = spr_rise;
            scrRight(direction);
            speed = 0;

             // Babbies:
            /*if(GameCont.loops > 0) repeat(GameCont.loops * 3){
                with(instance_create(x, y, BoneFish)) kills = 0;
            }*/

             // Effects:
            instance_create(x, y, PortalClear);
            sound_play_pitchvol(sndFootOrgSand1, 0.5, 5);
            sound_play_pitchvol(sndToxicBoltGas, 0.5 + random(0.2), 0.5);
            repeat(10){
                var _dis = 12,
                    _dir = random(360);

                with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Dust)){
                    motion_add(_dir, 3);
                }
            }
        }
    }

     // Fish Train:
    if(array_length(fish_train) > 0){
        var _leader = id,
            _broken = false;

        for(var i = 0; i < array_length(fish_train); i++){
            if(_broken){
                with(fish_train[i]) visible = 1;
                fish_train[i] = noone;
            }
            else{
                var _fish = fish_train[i],
                    b = false;

                 // Fish Regen:
                if(array_length(fish_swim) > i && fish_swim[i]){
                    if(!instance_exists(_fish) && fish_swim_regen <= 0){
                        fish_swim_regen = 3;

                        if(random(100) < 1) _fish = obj_create(_leader.x, _leader.y, "Puffer");
                        else _fish = instance_create(_leader.x, _leader.y, BoneFish);
                        with(_fish){
                            kills = 0;
                            creator = other;

                             // Keep Distance:
                            var l = 2,
                                d = _leader.direction + 180;

                            while(point_distance(x, y, _leader.x, _leader.y) < 24){
                                x += lengthdir_x(l, d);
                                y += lengthdir_y(l, d);
                                direction = d;
                            }

                             // Spawn Poof:
                            //sound_play(snd)
                            repeat(8) with(instance_create(x, y, Dust)){
                                motion_add(random(360), 1);
                                depth = other.depth - 1;
                            }
                        }

                        fish_train[i] = _fish;
                    }
                }

                if(instance_exists(_fish)){
                    with(_fish){
                        alarm1 = 15 + (i * 4);

                         // Swimming w/ Big Fish:
                        visible = !other.fish_swim[i];
                        if(other.fish_swim[i]){
                            scrRight(point_direction(x, y, _leader.x, _leader.y));

                            if(random(3) < 1 && speed > 0){
                                with(instance_create(x + orandom(6), y + random(8), Sweat)){
                                    direction = other.direction + choose(-120, 120) + orandom(10);
                                    speed = 0.5;
                                }
                            }
                        }

                         // Follow the Leader:
                        var _dis = distance_to_object(_leader),
                            _max = 6;

                        if(_dis > _max){
                            var l = 2,
                                d = point_direction(x, y, _leader.x, _leader.y);

                            while(_dis > _max){
                                x += lengthdir_x(l, d);
                                y += lengthdir_y(l, d);
                                _dis -= l;
                            }
                            motion_add(d, 1);
                        }
                        _leader = id;
                    }
                }
                else{
                    _broken = true;
                    fish_train[i] = noone;
                }
            }
        }
    }

     // Gradual Swim Train:
    if(fish_swim_delay <= 0){
        fish_swim_delay = 3;
        for(var i = 0; i <= 1; i++){
            var p = array_find_last_index(fish_swim, i);
            if(p >= 0 && p < array_length(fish_train) - 1){
                fish_swim[p + 1] = i;

                 // EZ burrow:
                with(fish_train[p + 1]){
                    repeat(8) with(instance_create(x + orandom(8) + hspeed, y + orandom(8) + vspeed, Dust)){
                        depth = other.depth - 1;
                    }
                }
            }
        }
        fish_swim[0] = (swim > 0);
    }
    fish_swim_delay -= current_time_scale;
    fish_swim_regen -= current_time_scale;

#define CoastBoss_hurt(_hitdmg, _hitvel, _hitdir)
     // Can't be hurt while swimming:
    if(swim){
        with(other) if("typ" in self && typ != 0){
             // Effects:
            sound_play_pitch(sndCrystalPropBreak, 0.7);
            sound_play_pitchvol(sndShielderDeflect, 1.5, 0.5);
            repeat(5) with(instance_create(x, y, Dust)){
                motion_add(random(360), 3);
            }

             // Destroy (1 frame delay to prevent errors):
            if(fork()){
                wait 1;
                if(instance_exists(self)) instance_destroy();
                exit;
            }
        }
    }
    else{
        my_health -= _hitdmg;           // Damage
        nexthurt = current_frame + 6;	// I-Frames

         // Sound:
        sound_play_hit(swim ? sndBigMaggotHit : snd_hurt, 0.3);

         // Knockback:
        if(!swim){
            motion_add(_hitdir, _hitvel);
        }

         // Hurt Sprite:
        if(
            sprite_index != spr_fire &&
            sprite_index != spr_chrg &&
            sprite_index != spr_efir &&
            sprite_index != spr_dive &&
            sprite_index != spr_rise
        ){
            sprite_index = spr_hurt;
            image_index = 0;
        }
    }

#define CoastBoss_draw
    var h = (nexthurt > current_frame + 3);

    var _leader = id;
    with(fish_train) if(instance_exists(self) && other.fish_swim[array_find_index(other.fish_train, self)]){
        var _spr = sprite_index,
            _img = image_index,
            _xscale = image_xscale * right,
            _yscale = image_yscale,
            _x = x - (sprite_get_xoffset(_spr) * _xscale),
            _y = bbox_bottom - (sprite_get_yoffset(_spr) * _yscale) - 1 + spr_shadow_y;

        draw_sprite_part_ext(_spr, _img, 0, 0, sprite_get_width(_spr), sprite_get_yoffset(_spr), _x, _y, _xscale, _yscale, image_blend, image_alpha);
    }

    if(swim > 0){
        var _cx = x,
            _cy = bbox_bottom;

        if(h) d3d_set_fog(1, c_white, 0, 0);
        for(var a = 0; a < 4; a++){
            var _x = _cx,
                _y = _cy,
                _xscale = image_xscale,
                _yscale = image_yscale,
                _blend = image_blend,
                _alpha = image_alpha,
                _swimSpd = (current_frame / 3),
                _spr = [spr.BigFishSwimFrnt,            spr.BigFishSwimBack                 ],
                _ang = [swim_ang_frnt,                  swim_ang_back                       ],
                _dis = [10 * _xscale,                   10 * _xscale                        ], // Offset Distance
                _dir = [_ang[0] + (5 * sin(_swimSpd)),  _ang[1] + 180 + (5 * sin(_swimSpd)) ], // Offset Direction
                _trn = [15 * cos(_swimSpd),             -25 * cos(_swimSpd)                 ];

             // Outline:
            if(a < 3){
                _blend = c_black;
                _x += lengthdir_x(1, a * 90);
                _y += lengthdir_y(1, a * 90);
            }

             // Draw Front & Back Fins:
            for(var j = 0; j < array_length(_spr); j++){
                var s = _spr[j],
                    _drawx = _x + lengthdir_x(_dis[j], _dir[j]),
                    _drawy = _y + lengthdir_y(_dis[j], _dir[j]);

                for(var i = 0; i < sprite_get_number(s); i++){
                    draw_sprite_ext(s, i, _drawx, _drawy - (i * _yscale), _xscale, _yscale, _ang[j] + _trn[j], _blend, _alpha);
                }
            }
        }
    }

     // Normal Self:
    else{
        if(h && sprite_index != spr_hurt) d3d_set_fog(1, c_white, 0, 0);
        draw_self_enemy();
    }

    if(h) d3d_set_fog(0, 0, 0, 0);

#define CoastBoss_alrm1
    alarm1 = 30 + random(20);

    target = instance_nearest(x, y, Player);

    if(instance_exists(target)){
        if(target_in_distance(0, 160) && (target.reload <= 0 || random(3) < 2)){
            var _targetDir = point_direction(x, y, target.x, target.y);

             // Move Towards Target:
            if((target_in_distance(0, 64) && random(2) < 1) || random(4) < 1){
                scrWalk(30 + random(10), _targetDir + orandom(10));
                alarm1 = walk + random(10);
            }

             // Bubble Blow:
            else{
                gunangle = _targetDir;
                ammo = 4 * (GameCont.loops + 2);

                scrWalk(8, gunangle + orandom(30));

                image_index = 0;
                sprite_index = spr_chrg;
                sound_play_pitch(sndOasisBossFire, 1 + orandom(0.2));

                alarm2 = 3;
                alarm1 = -1;
            }

            scrRight(_targetDir);
        }

         // Dive:
        else alarm3 = 6;
    }

     // Passive Movement:
    else{
        alarm1 = 40 + random(20);
        scrWalk(20, random(360));
    }

#define CoastBoss_alrm2
     // Fire Bubble Bombs:
    repeat(irandom_range(1, 2)){
        if(ammo > 0){
            alarm2 = 2;

             // Blammo:
            sound_play(sndOasisShoot);
            scrEnemyShoot("BubbleBomb", gunangle + (sin(shot_wave / 4) * 16), 8 + random(4));
            shot_wave += alarm2;
            walk++;

             // End:
            if(--ammo <= 0){
                alarm1 = 60;
            }
        }
    }

#define CoastBoss_alrm3
    target = instance_nearest(x, y, Player);
    swim_target = target;

    alarm3 = 8;
    alarm1 = alarm3 + 10;

    if(sprite_index != spr_dive){
         // Dive:
        if(swim <= 0){
            sprite_index = spr_dive;
            image_index = 0;
            spr_shadow = mskNone;
            sound_play(sndOasisBossMelee);
        }

         // Bubble Trail:
        else if(swim > 80){
            scrEnemyShoot("BubbleBomb", direction + orandom(10), 4);
            sound_play_hit(sndBouncerBounce, 0.3);
        }
    }

#define CoastBoss_death
     // Coast Entrance:
    instance_create(x, y, Portal);
    GameCont.area = "coast";
    GameCont.subarea = 0;
    with(enemy) my_health = 0;

     // Boss Win Music:
    with(MusCont) alarm_set(1, 1);


/// Mod Events
#define draw_shadows
    with(instances_named(CustomEnemy, "CoastBoss")){
        for(var i = 0; i < array_length(fish_train); i++){
            if(array_length(fish_swim) > i && fish_swim[i]){
                with(fish_train[i]){
                    draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
                }
            }
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