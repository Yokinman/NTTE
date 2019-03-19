#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.save = mod_variable_get("mod", "teassets", "save");

    global.newLevel = false;

    global.surfAnglerTrail = -1;
    global.surfAnglerTrailClear = -1;
    global.surfAnglerTrailX = 10000 - (surfAnglerTrailW / 2);
    global.surfAnglerTrailY = 10000 - (surfAnglerTrailH / 2);

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.save
#macro opt sav.option

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)
#macro surfAnglerTrail global.surfAnglerTrail
#macro surfAnglerClear global.surfAnglerTrailClear
#macro surfAnglerTrailX global.surfAnglerTrailX
#macro surfAnglerTrailY global.surfAnglerTrailY
#macro surfAnglerTrailW 1200
#macro surfAnglerTrailH 1200


#define Angler_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
         // Offset:
        x = _x - (right * 6);
        y = _y - 8;
        xstart = x;
        ystart = y;
        xprevious = x;
        yprevious = y;

         // Visual:
        spr_idle =      spr.AnglerIdle;
		spr_walk =      spr.AnglerWalk;
		spr_hurt =      spr.AnglerHurt;
		spr_dead =      spr.AnglerDead;
		spr_appear =    spr.AnglerAppear;
		// spr_shadow = shd64;
		// spr_shadow_y = 6;
		hitid = [spr_idle, "ANGLER"];
		sprite_index = spr_appear;
		image_speed = 0.4;
		depth = -2

         // Sound:
		snd_hurt = sndFireballerHurt;
		snd_dead = choose(sndFrogEggDead, sndFrogEggOpen2);

		 // Vars:
		//mask_index = mskFrogQueen;
		maxhealth = 50;
		raddrop = 25;
		meleedamage = 4;
		size = 3;
		walk = 0;
		walkspd = 0.6;
		maxspd = 3;
		hiding = true;
		ammo = 0;

         // Alarms:
		alarm1 = 30 + irandom(30);

        scrAnglerHide();

        return id;
    }

#define Angler_step
    enemyWalk(walkspd, maxspd + (8 * (ammo >= 0 && walk > 0)));

     // Animate:
    if(hiding){
        sprite_index = spr_appear;
        if(image_index > 0){
            image_index -= min(image_index, image_speed * 2 * current_time_scale);
        }
    }
    else if(sprite_index != spr_appear || anim_end){
        if(sprite_index == spr_appear) sprite_index = spr_idle;
        enemySprites();
    }

     // Charging:
    if(ammo >= 0){
        speed += ((speed * 0.85) - speed) * current_time_scale;
    }

     // Pit Collision:
    var f = floor_at(x + hspeed, y + vspeed);
    if(instance_exists(f) && f.sprite_index == spr.FloorTrenchB){
        if(floor_at(x, y).sprite_index != spr.FloorTrenchB){
            if(place_meeting(x + hspeed, y, f)) hspeed *= -1;
            if(place_meeting(x, y + vspeed, f)) vspeed *= -1;
        }
    }

#define Angler_draw
    var h = (sprite_index == spr_appear && nexthurt > current_frame + 3);
    if(h) d3d_set_fog(1, c_white, 0, 0);
    draw_self_enemy();
    if(h) d3d_set_fog(0, 0, 0, 0);

     // Canister Bloom:
    if(hiding){
        draw_set_blend_mode(bm_add);
        draw_sprite_ext(sprRadChestGlow, image_index, x + (6 * right), y + 8, image_xscale * 2 * right, image_yscale * 2, image_angle, image_blend, image_alpha * 0.1);
        draw_set_blend_mode(bm_normal);
    }

#define Angler_alrm1
    alarm1 = 6 + irandom(6);
    target = instance_nearest(x, y, Player);

     // Hiding:
    if(hiding){
        if(target_is_visible() && target_in_distance(0, 48)){
            scrAnglerAppear(); // Unhide
        }
    }

    else{
         // Charging:
        if(ammo > 0){
            ammo--;
            alarm1 = 8;
    
             // Charge:
            scrWalk(5, (target_is_visible() ? point_direction(x, y, target.x, target.y) : direction) + orandom(40));
            speed = maxspd + 10;
    
             // Effects:
            sound_play_pitchvol(sndRoll, 1.4 + random(0.4), 1.2);
            sound_play_pitchvol(sndBigBanditMeleeStart, 1.2 + random(0.2), 0.5);
            repeat(4) with(instance_create(x + orandom(16), y + orandom(16), Dust)){
                motion_add(other.direction + 180, random(4));
            }
            sprite_index = spr_hurt; // Temporary?
            image_index = 1;
        }
        else if(ammo == 0){
            ammo = -1;
            alarm1 = 15;

             // Back up:
            scrWalk(8, direction + 180);
            scrRight(direction + 180);
        }

         // Normal AI:
        else{
            alarm1 = 20 + irandom(20);

             // Move Toward Player:
            if(target_is_visible() && target_in_distance(0, 128)){
                scrWalk(25 + irandom(25), point_direction(x, y, target.y, target.y) + orandom(20));
            }

             // Wander:
            else scrWalk(20 + irandom(30), direction + orandom(30));

             // Hide:
            if(!target_in_distance(0, 160)){
                scrAnglerHide();
            }
        }
    }

#define Angler_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    motion_add(_hitdir, _hitvel);	// Knockback
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);	// Sound

    if(my_health > 0 && hiding) scrAnglerAppear();

     // Hurt Sprite:
    else{
        sprite_index = spr_hurt;
        image_index = 0;
    }

     // Emergency:
    if(my_health < 30 && random(3) < 2 && ammo < 0){
        walk = 0;
        ammo = 1;
        alarm1 = 4;
    }

#define Angler_death
    pickup_drop(80, 0);
    pickup_drop(60, 5);

    /// Light Broke:
        var _x = x + (20 * right),
            _y = y - 10;
    
        if(hiding){
            _x = x;
            _y = y;
        }

         // it is very broke
        with(scrCorpse(direction + orandom(10), speed + random(2))){
            x = _x;
            y = _y;
            sprite_index = sprRadChestCorpse;
            mask_index = -1;
            size = 2;
        }

         // yea...
        with(instance_create(_x, _y, PortalClear)){
            image_xscale = 0.4;
            image_yscale = 0.4;
        }

         // most important part
        if(raddrop > 0){
            repeat(raddrop) with(instance_create(_x, _y, Rad)){
                motion_add(random(360), random(5));
                motion_add(other.direction, min(other.speed / 3, 3));
            }
            raddrop = 0;
        }

         // Effects:
        sound_play(sndEXPChest);
        with(instance_create(_x, _y, ExploderExplo)){
            motion_add(other.direction, 1);
        }

#define scrAnglerAppear()
    hiding = false;

     // Anglers rise up
    mask_index = mskFrogQueen;
    spr_shadow = shd64B;
    spr_shadow_y = 3;
    spr_shadow_x = 0;
    instance_create(x, y, PortalClear);

     // Time 2 Charge
    alarm1 = 15;
    ammo = 3;

     // Effects:
    sound_play_pitch(sndBigBanditMeleeStart, 0.8 + random(0.2));
    view_shake_at(x, y, 10);
    repeat(5){
        with(instance_create(x + orandom(24), y + orandom(24), Dust)){
            waterbubble = true;
        }
    }

#define scrAnglerHide()
    hiding = true;

     // Anglers rise down
    sprite_index = spr_appear;
    image_index = image_number - 1 + image_speed;
    mask_index = msk.AnglerHidden[right < 0];
	spr_shadow = shd24;
    spr_shadow_y = 9;
    spr_shadow_x = 6 * right;
    walk = 0;

     // Effects:
    sound_play_pitchvol(sndJockFire, 1.6 + random(0.5), 0.2);
    view_shake_at(x, y, 10);
    repeat(5){
        with(instance_create(x + orandom(24), y + orandom(24), Dust)){
            waterbubble = true;
            motion_add(random(360), 2)
        }
    }


#define Eel_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
         // Visual:
        c = irandom(2);
        if(c == 0 && GameCont.crown == crwn_guns) c = 1;
        if(c == 1 && GameCont.crown == crwn_life) c = 0;
        spr_idle = spr.EelIdle[c];
        spr_walk = spr_idle;
        spr_hurt = spr.EelHurt[c];
        spr_dead = spr.EelDead[c];
        spr_tell = spr.EelTell[c];
        hitid = [spr_idle, "EEL"];
        spr_shadow = shd24;
        image_index = random(image_number - 1);
        depth = -2;

         // Sound:
        snd_hurt = sndHitFlesh;
        snd_dead = sndFastRatDie;
        snd_mele = sndMaggotBite;

         // Vars:
        mask_index = mskRat;
        maxhealth = 12;
        raddrop = 2;
        meleedamage = 2;
        size = 1;
        walk = 0;
        walkspd = 1.2;
        maxspd = 3;
        pitDepth = 0;
        direction = random(360);
        arc_inst = noone;
        arcing = 0;
        wave = random(100);
        gunangle = 0;
        elite = 0;
        ammo = 0;

         // Alarms:
        alarm1 = 30;

        return id;
    }

#define Eel_step
    enemySprites();
    enemyWalk(walkspd, maxspd);

     // Arc Lightning w/ Jelly:
    if(
    	instance_exists(arc_inst)							&&
    	point_distance(x, y, arc_inst.x, arc_inst.y) < 100	&&
    	(
    		!instance_exists(target) ||
    		target_in_distance(0, 120)
    	)
    ){
         // Start Arcing:
        if(arcing < 1){
            arcing += 0.15 * current_time_scale;

            if(current_frame_active){
                var _dis = random(point_distance(x, y, arc_inst.x, arc_inst.y)),
                    _dir = point_direction(x, y, arc_inst.x, arc_inst.y);

                with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), choose(PortalL, PortalL, LaserCharge))){
                    motion_add(random(360), 1);
                    alarm0 = 8;
                }
            }

             // Arced:
            if(arcing >= 1){
                sound_play_pitch(sndLightningHit, 2);

                 // Color:
                if(arc_inst.c <= 2){
                    c = max(arc_inst.c, 0);
                    spr_idle = spr.EelIdle[c];
                    spr_walk = spr_idle;
                    spr_hurt = spr.EelHurt[c];
                    spr_dead = spr.EelDead[c];
                    spr_tell = spr.EelTell[c];
                    if(sprite_index != spr_hurt){
                        sprite_index = spr_idle;
                    }
                    hitid = [spr_idle, string_upper(name)];
                }
            }
        }

         // Arcing:
        else{
			wave += current_time_scale;
            if(arc_inst.c > 2) elite = 30;
            with(arc_inst){
            	lightning_connect(other.x, other.y, x, y, 12 * sin(other.wave / 30), true);
            }
        }
    }

	 // Stop Arcing:
    else{
    	if(arcing > 0 && instance_exists(arc_inst)){
    		var _lx = arc_inst.x,
    			_ly = arc_inst.y;

            repeat(2){
                var _dis = random(point_distance(x, y, _lx, _ly)),
                    _dir = point_direction(x, y, _lx, _ly);

                with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), PortalL)){
                    motion_add(random(360), 1);
                }
            }
    	}
        arc_inst = noone;
        arcing = 0;
    }
    
	 // Search for New Jelly:
    if(!instance_exists(arc_inst) && frame_active(8)){
        var _inst = nearest_instance(x, y, instances_named(CustomEnemy, "Jelly"));
        if(instance_exists(_inst) && point_distance(x, y, _inst.x, _inst.y) < 100) arc_inst = _inst;
    }

     // Elite Effects:
    if(elite > 0){
        elite -= current_time_scale;
        if(current_frame_active && random(30) < 1){
            instance_create(x, y, PortalL);
        }
        if(elite <= 0){
            instance_create(x, y, PortalL);
            sprite_index = spr_hurt;
            image_index = 0;
        }
    }

#define Eel_draw
    var _spr = sprite_index;
    if(elite > 0){
        if(_spr == spr_idle) _spr = spr.EeliteIdle;
        else if(_spr == spr_walk) _spr = spr.EeliteWalk;
        else if(_spr == spr_hurt) _spr = spr.EeliteHurt;
    }
    draw_sprite_ext(_spr, image_index, x, y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);

#define Eel_alrm1
    alarm1 = 30 + random(10);

    target = instance_nearest(x,y,Player);
    if ammo{
        alarm1 = 3;
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
        if false && instance_exists(arc_inst) && arc_inst.c == 3 && random(5) < 1 && target_is_visible() && target_in_distance(0,96){
            alarm1 = 3;
            ammo = 10;
            gunangle = point_direction(x, y, target.x, target.y);
            sound_play(sndLaserCrystalCharge);
        }
        else{
             // When you walking:
            if target_is_visible(){
                scrWalk(irandom_range(23,30), point_direction(x,y,target.x,target.y) + orandom(20));
            }
            else
                scrWalk(irandom_range(17,30), direction+orandom(30));
        }
    }

#define Eel_death
    if(elite){
        spr_dead = spr.EeliteDead;

         // Death Lightning:
        repeat(2) with(scrEnemyShoot(EnemyLightning, random(360), 0.5)){
            alarm0 = 2 + random(4);
            ammo = 1 + random(2);
            image_speed *= random_range(0.75, 1);
            with(instance_create(x, y, LightningHit)){
                motion_add(other.direction, random(2));
            }
        }
        sound_play_pitchvol(sndLightningCrystalDeath, 1.5 + random(0.5), 1);
    }

     // Type-Pickups:
    else switch(c){
        case 0: // Blue
            if(random(3) < 2 * pickup_chance_multiplier){
                instance_create(x + orandom(2), y + orandom(2), AmmoPickup);

                 // FX:
                with(instance_create(x, y, FXChestOpen)){
                    motion_add(other.direction, random(1));
                }
            }
            break;

        case 1: // Purple
            if(random(3) < 2 * pickup_chance_multiplier){
                instance_create(x + orandom(2), y + orandom(2), HPPickup);

                 // FX:
                repeat(2) with(instance_create(x + orandom(4), y + orandom(4), AllyDamage)){
                    motion_add(other.direction + orandom(30), random(1));
                }
            }
            break;

        case 2: // Green
            with(instance_create(x, y, BigRad)){
                motion_add(other.direction, other.speed);
                motion_add(random(360), 3);
                speed *= power(0.9, speed);
            }

             // FX:
            repeat(2) with(instance_create(x + orandom(4), y + orandom(4), EatRad)){
                sprite_index = sprEatBigRadPlut;
                motion_add(other.direction + orandom(30), 1);
            }
            break;
    }


#define EelSkull_create(_x, _y)
    with(instance_create(_x, _y, CustomProp)){
         // Visual:
        spr_idle = spr.EelSkullIdle;
        spr_hurt = spr.EelSkullHurt;
        spr_dead = spr.EelSkullDead;

         // Sound:
        snd_hurt = sndOasisHurt;
        snd_dead = sndOasisDeath;

         // Vars:
        maxhealth = 50;
        size = 2;

        return id;
    }

#define EelSkull_death
	for(var a = direction; a < direction + 360; a += (360 / 4)){
        with(instance_create(x, y, Dust)) motion_add(a, 3);
    }


#define Jelly_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
         // Visual:
        c = irandom(2);
        if(c == 0 && GameCont.crown == crwn_guns) c = 1;
        if(c == 1 && GameCont.crown == crwn_life) c = 0;
        spr_charged = spr.JellyIdle[c];
        spr_idle = spr_charged;
        spr_walk = spr_charged;
        spr_hurt = spr.JellyHurt[c];
        spr_dead = spr.JellyDead[c];
        spr_fire = (c == 3 ? spr.JellyEliteFire : spr.JellyFire);
        spr_shadow = shd24;
        spr_shadow_y = 6;
        hitid = [spr_idle, "JELLY"];
        depth = -2;

         // Sound:
        snd_hurt = sndHitFlesh;
        snd_dead = sndBigMaggotDie;

         // Vars:
        mask_index = mskLaserCrystal;
        maxhealth = 52 // (c == 3 ? 72 : 52);
        raddrop = 16 // (c == 3 ? 38 : 16);
        size = 2;
        walk = 0;
        walkspd = 1;
        maxspd = 2.6;
        meleedamage = 4;
        direction = random(360);

         // Alarms:
        alarm1 = 40 + irandom(20);

        return id;
    }

#define Jelly_step
    if(sprite_index != spr_fire) enemySprites();

     // Movement:
    var _maxSpd = clamp(0.07 * walk * current_time_scale, 1, maxspd); // arbitrary values, feel free to fiddle
    enemyWalk(walkspd, _maxSpd);

     // Bouncy Boy:
    if(place_meeting(x + hspeed, y + vspeed, Wall)) {
        move_bounce_solid(false);
        scrRight(direction);
    }

#define Jelly_alrm1
    alarm1 = 40 + random(20);
    target = instance_nearest(x, y, Player);

     // Always movin':
    scrWalk(alarm1, direction);

    if(target_is_visible()){
        var _targetDir = point_direction(x, y, target.x, target.y);

         // Steer towards target:
        motion_add(_targetDir, 0.4);

         // Attack:
        if(random(3) < 1 && target_in_distance(32, 256)){
            alarm1 += 60;

             // Shoot lightning disc:
            if(c > 2){
                for(var a = _targetDir; a < _targetDir + 360; a += (360 / 3)){
                    with(scrEnemyShoot("LightningDiscEnemy", a, 8)){
                        shrink /= 2; // Last twice as long
                    }
                }
            }
            else scrEnemyShoot("LightningDiscEnemy", _targetDir, 8);

             // Effects:
            sound_play_hit(sndLightningHit, 0.25);
            sound_play_pitch(sndLightningCrystalCharge,0.8);
            sprite_index = spr_fire;
            alarm2 = 30;
        }
    }
    scrRight(direction);

#define Jelly_alrm2
    sprite_index = spr_walk;

#define Jelly_death
    if(c <= 2) pickup_drop(50, 2);
    else pickup_drop(100, 10);


#define JellyElite_create(_x, _y)
    with(obj_create(_x, _y, "Jelly")){
         // Visual:
        c = 3;
        spr_charged = spr.JellyIdle[c]
        spr_idle = spr_charged;
        spr_walk = spr_charged;
        spr_hurt = spr.JellyHurt[c];
        spr_dead = spr.JellyDead[c];
        spr_fire = spr.JellyEliteFire;

         // Sound:
        snd_hurt = sndLightningCrystalHit;
        snd_dead = sndLightningCrystalDeath;

         // Vars:
        raddrop *= 2;

        return id;
    }


#define Kelp_create(_x, _y)
    with(instance_create(_x, _y, CustomProp)){
         // Visual:
        spr_idle = spr.KelpIdle;
        spr_hurt = spr.KelpHurt;
        spr_dead = spr.KelpDead;
        image_speed = random_range(0.2, 0.3);
        depth = -2;

         // Sounds:
        snd_hurt = sndOasisHurt;
        snd_dead = sndOasisDeath;

         // Vars:
        maxhealth = 2;
        size = 1;

        return id;
    }


#define PitSquid_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
         // Visual:


         // Sounds:
        snd_hurt = sndBallMamaHurt;
        snd_mele = sndMaggotBite;

         // Vars:
        friction = 0.01;
        mask_index = mskNone;
        meleedamage = 8;
        maxhealth = scrBossHP(450);
        raddrop = 1;
        size = 5;
        canfly = true;
        target = noone;
        bite = false;
        sink = false;
        sink_targetx = x;
        sink_targety = y;
        pit_height = 1;

         // Eyes:
        eye = [];
        eye_angle = random(360);
        eye_dis_offset = 0;
        repeat(3){
            array_push(eye, {
                x : 0,
                y : 0,
                dis : 5,
                dir : random(360),
                blink : false,
                blink_img : 0
            });
        }

         // Alarms:
        alarm1 = 90;
        alarm2 = 90;

        return id;
    }

#define PitSquid_step
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
            _y = y + lengthdir_y(_dis * image_yscale, _dir),
            f = floor_at(_x, _y - 8);

        with(eye[i]){
            x = _x;
            y = _y;

             // Eye Under Floor:
            var _cansee = false;
            if(instance_exists(f) && f.styleb){
                _cansee = true;
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
        var _num = 8;
        for(var i = 0; i < _num; i++){
            var l = 64,
                d = (i * (360 / _num)) + eye_angle;

            with(obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d) + 20, "Tentacle")){
                creator = other;
                xoff = x - other.x;
                yoff = y - other.y;
                dir = d;
                spd = 6;
                alarm1 = 5 + random(15);
                alarm2 += alarm1;
                move_delay = 50 - alarm1;
                scrRight(d + 180);
            }
        }
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
                        for(var _ox = 0; _ox < 32; _ox += 16){
                            for(var _oy = 0; _oy < 32; _oy += 16){
                                var _x = x + _ox + 8,
                                    _y = y + _oy + 8,
                                    _dir = point_direction(other.x, other.y, _x, _y),
                                    _spd = 8 - (point_distance(other.x, other.y, _x, _y) / 16);

                                if(random(6) < 1 && object_index != FloorExplo){
                                    with(obj_create(_x, _y, "TrenchFloorChunk")){
                                        direction = _dir;
                                        zspeed = _spd;
                                        image_index = (point_direction(other.x, other.y, x, y) - 45) mod 90;
                                    }
                                }
                                else instance_create(_x, _y, Debris);
                            }
                        }
                        /*repeat(sprite_width / 8){
                            instance_create(x + random(32), y + random(32), Debris);
                        }*/

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

#define PitSquid_alrm1
    alarm1 = 30 + random(30);

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
                alarm1 = 60;
            }
        }
    }

#define PitSquid_alrm2
    alarm2 = 60 + random(30);

    if(pit_height >= 1){
        target = instance_nearest(x, y, Player);

        if(instance_exists(target)){
            var _targetDis = point_distance(x, y, target.x, target.y),
                _targetDir = point_direction(x, y, target.x, target.y);

             // Tentacles:
            if(point_distance(target.x, target.y, x + hspeed, y + vspeed + 16) > 64){
                var c = id;
                with(target){
                    var f = floor_at(x, y);
                    if(instance_exists(f) && f.styleb){
                        other.alarm2 = 60 + random(30);
                        with(obj_create(x, y, "Tentacle")){
                            alarm0 = 20;
                            team = c.team;
                            creator = c;
                        }

                         // Tell:
                        with(instance_create(x, bbox_bottom - 4, ThrowHit)){
                            image_alpha = 0.5;
                            image_speed = 0.4;
                            image_angle = random(360);
                            image_xscale = 0.5;
                            image_yscale = 0.5;
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


#define Tentacle_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
         // Visual:
        spr_spwn = spr.TentacleSpwn;
        spr_idle = spr.TentacleIdle;
        spr_walk = spr.TentacleIdle;
        spr_hurt = spr.TentacleHurt;
        spr_dead = spr.TentacleDead;
        depth = -2 - (y / 20000);
        hitid = [spr_idle, "PIT SQUID"];
        sprite_index = mskNone;

         // Sound:
        snd_hurt = sndHitFlesh;
        snd_dead = sndMaggotSpawnDie;
        snd_mele = sndPlantSnare;

         // Vars:
        mask_index = mskNone;
        meleedamage = 3;
        maxhealth = 20;
        raddrop = 0;
        size = 3;
        xoff = 0;
        yoff = 0;
        dir = 0;
        spd = 0;
        move_delay = 0;
        creator = noone;
        canfly = true;
        kills = 0;

		 // Alarms:
        alarm0 = 1;
        alarm1 = 90;

        return id;
    }

#define Tentacle_step
    if(sprite_index != mskNone){
        if(instance_exists(creator) || creator == noone){
             // Animate:
            if(sprite_index != spr_idle){
                if((sprite_index != spr_hurt && sprite_index != spr_spwn) || anim_end){
                    sprite_index = spr_idle;
                }
            }

             // Keep w/ Pit Squid:
            if(spd != 0){
                if(instance_exists(creator)){
                    x = creator.x + xoff;
                    y = creator.y + yoff;
                }
                else{
                    x = xstart + xoff;
                    y = ystart + yoff;
                }
                if(move_delay <= 0){
                    xoff += lengthdir_x(spd, dir) * current_time_scale;
                    yoff += lengthdir_y(spd, dir) * current_time_scale;
                    spd -= clamp(spd, -friction, friction) * current_time_scale;
                    if(spd <= 0) with(creator){
                        motion_add(point_direction(x, y, other.x, other.y), 0.4 * current_time_scale);
                    }

                     // Animate:
                    if(sprite_index != spr_hurt){
                        sprite_index = spr_hurt;
                        image_index = 1;
                    }
                    scrRight(dir + 180);

                     // Effects:
                    if(current_frame_active && random(3) < 1){
                        instance_create(x, y, Dust);
                    }
                }
                else{
                    move_delay -= current_time_scale;
                    if(move_delay <= 0){
                        sound_play_pitchvol(sndFastRatSpawn, 0.6 + random(0.2), 3);
                    }
                }
    
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
                            if(object_index != FloorExplo && other.sprite_index == other.spr_spwn && random(2) < 1){
                                var _ox = choose(8, 24),
                                    _oy = choose(8, 24),
                                    _dir = point_direction(other.x, other.y, x, y),
                                    _spd = other.spd;

                                with(obj_create(x + _ox, y + _oy, "TrenchFloorChunk")){
                                    speed /= 2;
                                    direction = _dir;
                                    zspeed = 3 + random(2);
                                    image_index = (point_direction(other.x, other.y, x, y) - 45) mod 90;
                                }
                            }
                            repeat(2){
                                instance_create(x + random(sprite_width), y + random(sprite_height), Debris);
                            }
                            /*repeat(sprite_width / 8){
                                instance_create(x + random(32), y + random(32), Debris);
                            }*/
    
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
            else if(alarm1 > 1 && instance_exists(creator)){
                if(point_distance(x, y, creator.x + creator.hspeed, creator.y + creator.vspeed + 16) < 64 || creator.pit_height < 1){
                    alarm1 = 1;
                }
            }
        }
        else if(sprite_index != spr_spwn || anim_end){
            my_health = 0;
        }
    }
    else my_health = maxhealth;
    speed = 0;

#define Tentacle_alrm0
    if(instance_exists(creator) && creator.pit_height < 1){
        instance_delete(self);
    }

     // Appear:
    else{
        mask_index = mskOldGuardianDeflect;
        sprite_index = spr_spwn;
        image_index = 0;
        canfly = false;

        sound_play_pitchvol(sndBigMaggotUnburrow, 1.5 + random(1), 1)
    }

#define Tentacle_alrm1
     // Retract:
    sound_play_pitchvol(sndBigMaggotBurrow, 2 + orandom(0.2), 0.6);
    with(instance_create(x, y, CorpseActive)){
        sprite_index = spr.TentacleDead;
        size = 0;
    }
    
    instance_destroy();

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

#define Tentacle_death
    //repeat(2) instance_create(x, y, Dust);


#define TentacleRip_create(_x, _y)
    with(instance_create(_x, _y, CustomObject)){
         // Visual:
        sprite_index = spr.TentacleWarn;
        image_speed = 0.4;
        depth = 6;

         // Vars:
        creator = noone;

        return id;
    }

#define TentacleRip_step
     // Effects:
    if(current_frame_active){
        view_shake_max_at(x, y, 3);
        if(frame_active(12)){
            with(instance_create(x + orandom(6), y - 4 + orandom(6), Smoke)){
                image_xscale *= 0.5;
                image_yscale *= 0.5;
                hspeed *= 0.5;
                vspeed = -random_range(1, 3);
            }
        }
        if(current_frame_active && random(5) < 1){
            sound_play_pitchvol(sndOasisDeath, random(3), 0.3);
        }
    }

     // Launch Tentacles:
    if(anim_end){
        for(var i = 0; i < 360; i += (360 / 8)){
            with(obj_create(x + lengthdir_x(12, i), y + lengthdir_y(12, i), "Tentacle")){
                dir = i;
                spd = 6;
                move_delay = 10;
            }
        }

         // Effects:
        view_shake_at(x, y, 30);
        sound_play_hit(sndWallBreak, 0.3);
        sound_play_pitchvol(sndWallBreakCrystal, 2.5, 0.6);
        repeat(6) with(instance_create(x, y, Smoke)){
            motion_add(random(360), 4);
        }

        instance_destroy();
    }


#define TrenchFloorChunk_create(_x, _y)
    with(instance_create(_x, _y, CustomObject)){
         // Visual:
        sprite_index = spr.FloorTrenchBreak;
        image_index = irandom(image_number - 1)
        image_speed = 0;
        image_alpha = 0;
        depth = -8;

         // Vars:
        z = 0;
        zspeed = 6 + random(4);
        zfric = 0.3;
        friction = 0.05;
        rotspeed = random_range(1, 2) * choose(-1, 1);

        motion_add(random(360), 2 + random(3));

        return id;
    }

#define TrenchFloorChunk_step
    z_engine();
    image_angle += rotspeed * current_time_scale;

     // Stay above walls:
    /*depth = clamp(-z / 8, -8, 0);
    if(place_meeting(x, y - z, Wall) || !place_meeting(x, y - z, Floor)){
        depth = min(depth, -8);
    }*/

     // Effects:
    if(current_frame_active && random(10) < 1){
        instance_create(x, y - z, Bubble);
    }

    if(z <= 0) instance_destroy();

#define TrenchFloorChunk_draw
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, 1);

#define TrenchFloorChunk_destroy
    sound_play_pitchvol(sndOasisExplosionSmall, 0.5 + random(0.3), 0.3 + random(0.1));
    var n = 3;

     // Fall into Pit:
    var f = floor_at(x, y);
    if(instance_exists(f) && f.styleb && !place_meeting(x, y, Wall)){
        with(instance_create(x, y, Debris)){
            sprite_index = other.sprite_index;
            image_index = other.image_index;
            image_angle = other.image_angle;
            direction = other.direction;
            speed = other.speed;
        }
    }

     // Break on ground:
    else{
        y -= 2;
        sound_play_pitchvol(sndWallBreak, 0.5 + random(0.3), 0.4);
        repeat(3) with(instance_create(x, y, Debris)){
            speed = 4 + random(2);
            if(!place_meeting(x, y, Floor)) depth = -8;
        }
        n = 6;
    }

     // Ground smacky:
    repeat(n) with(instance_create(x + orandom(4), y + orandom(4), Smoke)){
        motion_add(point_direction(other.x, other.y, x, y), 2);
        if(!place_meeting(x, y, Floor)) depth = -8;
    }


#define Vent_create(_x, _y)
    with(instance_create(_x, _y, CustomProp)){
         // Visual:
        spr_idle = spr.VentIdle;
        spr_hurt = spr.VentHurt;
        spr_dead = spr.VentDead;
        spr_shadow = mskNone;
        depth = -2;

         // Sounds
        snd_hurt = sndOasisHurt;
        snd_dead = sndOasisExplosionSmall;

         // Vars:
        maxhealth = 12;
        size = 1;

        return id;
    }

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


#define YetiCrab_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
         // Visual:
        spr_idle = spr.YetiCrabIdle;
        spr_walk = spr.YetiCrabIdle;
        spr_hurt = spr.YetiCrabIdle;
        spr_dead = spr.YetiCrabIdle;
        spr_weap = mskNone;
        spr_shadow = shd24;
        spr_shadow_y = 6;
        hitid = [spr_idle, "YETI CRAB"];
        mask_index = mskFreak;
        depth = -2;

         // Sound:
        snd_hurt = sndScorpionHit;
        snd_dead = sndScorpionDie;

         // Vars:
        maxhealth = 12;
        raddrop = 3;
        size = 1;
        walk = 0;
        walkspd = 1;
        maxspd = 4;
        meleedamage = 2;
        is_king = 0; // Decides leader
        direction = random(360);

         // Alarms:
        alarm1 = 20 + irandom(10);

        return id;
    }

#define YetiCrab_alrm1
    alarm1 = 30 + random(10);
    target = instance_nearest(x, y, Player);

    if(is_king = 0) { // Is a follower:
        if(instance_exists(nearest_instance(x, y, instances_matching(CustomEnemy, "is_king", 1)))) { // Track king:
            var nearest_king = nearest_instance(x, y, instances_matching(CustomEnemy, "is_king", 1));
            var king_dir = point_direction(x, y, nearest_king.x, nearest_king.y);
            if(point_distance(x, y, nearest_king.x, nearest_king.y) > 16 and point_distance(x, y, target.x, target.y) < point_distance(x, y, nearest_king.x, nearest_king.y)) { // Check distance from king:
                scrRight(king_dir);

                 // Follow king in a jittery manner:
                scrWalk(5, king_dir + orandom(5));
                alarm1 = 5 + random(5);
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


/// Mod Events
#define step
    if(instance_exists(GenCont) || instance_exists(Menu)) global.newLevel = 1;
    else if(global.newLevel){
        global.newLevel = 0;

         // Center Angler Trail Surfaces:
        var _x = 0,
            _y = 0;

        with(Floor){
            _x += x;
            _y += y;
        }
        _x /= instance_number(Floor);
        _y /= instance_number(Floor);
        _x -= surfAnglerTrailW / 2;
        _y -= surfAnglerTrailH / 2;
        surfAnglerTrailX = _x;
        surfAnglerTrailY = _y;
    }

    script_bind_draw(draw_anglertrail, -3);

#define draw_anglertrail
    var _surfTrail = surfAnglerTrail,
        _surfClear = surfAnglerClear,
        _surfX = surfAnglerTrailX,
        _surfY = surfAnglerTrailY;

    if(!surface_exists(_surfTrail)){
        _surfTrail = surface_create(surfAnglerTrailW, surfAnglerTrailH);
        surfAnglerTrail = _surfTrail;
    }
    if(!surface_exists(_surfClear)){
        _surfClear = surface_create(surfAnglerTrailW, surfAnglerTrailH);
        surfAnglerClear = _surfClear;
    }

     // Clear Trail Surface Over Time:
    if(frame_active(1)){
        surface_set_target(_surfClear);

        draw_clear(c_black);
        draw_set_blend_mode(bm_subtract);
        draw_surface(_surfTrail, 0, 0);
        draw_sprite_tiled(sprStreetLight, 0, irandom(128), irandom(128));

        surface_set_target(_surfTrail);

        for(var a = 0; a < 360; a += 90){
            draw_surface(_surfClear, lengthdir_x(1, a), lengthdir_y(1, a));
        }

        draw_set_blend_mode(bm_normal);
    }

     // Draw Trails:
    surface_set_target(_surfTrail);
    d3d_set_fog(1, c_black, 0, 0);
    with(instances_matching_ge(instances_matching(CustomEnemy, "name", "Angler"), "ammo", 0)){
        if(visible && sprite_index != spr_appear){
            var _x1 = xprevious,
                _y1 = yprevious,
                _x2 = x,
                _y2 = y,
                _dis = point_distance(_x1, _y1, _x2, _y2),
                _dir = point_direction(_x1, _y1, _x2, _y2),
                _spr = spr.AnglerTrail,
                _img = image_index,
                _xscal = image_xscale * right,
                _yscal = image_yscale,
                _angle = image_angle,
                _blend = c_white,
                _alpha = image_alpha;

            for(var o = 0; o <= _dis; o++){
                draw_sprite_ext(_spr, _img, _x1 + lengthdir_x(o, _dir) - _surfX, _y1 + lengthdir_y(o, _dir) - _surfY, _xscal, _yscal, _angle, _blend, _alpha);
            }
        }
    }
    d3d_set_fog(0, 0, 0, 0);
    surface_reset_target();

     // Trail Surface:
    d3d_set_fog(1, make_color_rgb(252, 56, 0), 0, 0);
    draw_set_blend_mode(bm_add);
    draw_surface(_surfTrail, _surfX, _surfY);
    draw_set_blend_mode(bm_normal);
    d3d_set_fog(0, 0, 0, 0);

    instance_destroy();

#define draw_shadows
    with(instances_named(CustomObject, "TrenchFloorChunk")){
        if(visible && place_meeting(x, y, Floor)){
            var _scale = clamp(1 / ((z / 200) + 1), 0.1, 0.8);
            draw_sprite_ext(sprite_index, image_index, x, y, _scale * image_xscale, _scale * image_yscale, image_angle, image_blend, 1);
        }
    }

#define draw_dark // Drawing Grays
    draw_set_color(c_gray);

     // Anglers:
    d3d_set_fog(1, c_gray, 0, 0);
    with(instances_matching(CustomEnemy, "name", "Angler")){
        var _img = image_index;

        if(sprite_index != spr_appear){
            _img = sprite_get_number(spr_appear) - 1;
        }

         // Manual buzziness since it's a sprite:
        var o = random(2);
        for(var a = 0; a < 360; a += 45){
            draw_sprite_ext(spr.AnglerLight, _img, x + lengthdir_x(o, a), y + lengthdir_y(o, a), right, 1, 0, c_white, 1);
        }
    }
    d3d_set_fog(0, 0, 0, 0);

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

     // Elite Eels:
    with(instances_matching_gt(instances_named(CustomEnemy, "Eel"), "elite", 0)){
        draw_circle(x, y, 48 + orandom(2), false);
    }

     // Kelp:
    with(instances_matching(CustomProp, "name", "Kelp")){
        draw_circle(x, y, 32 + orandom(1), false);
    }

#define draw_dark_end // Drawing Clear
    draw_set_color(c_black);

     // Anglers:
    draw_set_blend_mode(bm_subtract);
    with(instances_matching(CustomEnemy, "name", "Angler")){
        var _img = image_index;

        if(sprite_index != spr_appear){
            _img = sprite_get_number(spr_appear) - 1;
        }

         // Manual buzziness since it's a sprite:
        var o = random(2);
        for(var a = 0; a < 360; a += 45){
            draw_sprite_ext(spr.AnglerLight, _img, x + lengthdir_x(o, a), y + lengthdir_y(o, a), right, 1, 0, c_white, 1);
        }
    }
    draw_set_blend_mode(bm_normal);

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

     // Elite Eels:
    with(instances_matching_gt(instances_named(CustomEnemy, "Eel"), "elite", 0)){
        draw_circle(x, y, (elite / 2) + 3 + orandom(2), false);
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