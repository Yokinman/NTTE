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

	global.pit_grid = mod_variable_get("area", "trench", "pit_grid");

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
		maxspeed = 3;
		hiding = true;
		ammo = 0;

         // Alarms:
		alarm1 = 30 + irandom(30);

		 // NTTE:
		ntte_anim = false;
		ntte_walk = false;

        scrAnglerHide();

        return id;
    }

#define Angler_step
    enemyWalk(walkspd, maxspeed + (8 * (ammo >= 0 && walk > 0)));

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
	if(!hiding && ammo >= 0){
		speed -= (speed * 0.15) * current_time_scale;
	}

#define Angler_draw
    var h = (sprite_index == spr_appear && nexthurt > current_frame + 3);
    if(h) draw_set_flat(image_blend);
    draw_self_enemy();
    if(h) draw_set_flat(-1);

#define Angler_alrm1
    alarm1 = 6 + irandom(6);
    target = instance_nearest(x, y, Player);

     // Hiding:
    if(hiding){
        if(in_sight(target) && in_distance(target, 48)){
            scrAnglerAppear(); // Unhide
        }
    }

    else{
         // Charging:
        if(ammo > 0){
            ammo--;
            alarm1 = 8;
    
             // Charge:
            scrWalk(5, (in_sight(target) ? point_direction(x, y, target.x, target.y) : direction) + orandom(40));
            speed = maxspeed + 10;
    
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
            if(in_sight(target) && in_distance(target, 96)){
                scrWalk(25 + irandom(25), point_direction(x, y, target.x, target.y) + orandom(20));
                if(chance(1, 2)){
                	ammo = irandom_range(1, 3);
                }
            }

             // Wander:
            else{
            	 // Go to Nearest Non-Pit Floor:
        		var f = nearest_instance(x - 8 + (hspeed * 4), y - 8 + (vspeed * 4), instances_matching_ne(Floor, "sprite_index", spr.FloorTrenchB));
            	if(instance_exists(f)){
            		direction = point_direction(x, y, f.x, f.y);
            	}

            	scrWalk(20 + irandom(30), direction + orandom(30));

	             // Hide:
	            if(!in_distance(target, 160) && !pit_get(x, y)){
	                scrAnglerHide();
	            }
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
    if(my_health < 30 && chance(2, 3) && ammo < 0){
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

#define ChaserTentacle_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
         // Visual:
        spr_spwn = spr.TentacleSpwn;
        spr_idle = spr.TentacleIdle;
        spr_walk = spr.TentacleIdle;
        spr_hurt = spr.TentacleHurt;
        spr_dead = spr.TentacleDead;
        spr_cntr = spr.TentacleHurt;
        spr_fire = spr.TentacleHurt;
        depth = -2 - (y / 20000);
        hitid = [spr_idle, "PIT SQUID"];
        sprite_index = spr_spwn;
        
         // Sound:
        snd_hurt = sndHitFlesh;
        snd_dead = sndMaggotSpawnDie;
        snd_mele = sndPlantSnare;

         // Vars:
        mask_index = mskBandit;
        meleedamage = 3;
        maxhealth = 40;
        raddrop = 0;
        size = 3;
        creator = noone;
        canfly = true;
        kills = 0;
        walk = 0;
        walkspd = 1;
        maxspeed = 3.5;
        minCounter = 0; // grace period before counters are active
        counterTime = 0;
        doCounter = false; // tracks if the counter is successful
        armor = 0.5; // percent damage negated from creator's health

		 // Alarms:
        alarm0 = 30; // move, start counterattack
        alarm1 = -1; // execute counterattack
        alarm2 = 1; // teleport

        return id;
    }
    
#define ChaserTentacle_step
    if place_meeting(x + hspeed, y, Wall) hspeed *= -1;
    if place_meeting(x, y + vspeed, Wall) vspeed *= -1;
    
    depth = -2 - (y / 20000);

#define ChaserTentacle_alrm0
    alarm0 = 10 + irandom(10);
    maxspeed = 3.5;
    target = instance_nearest(x, y, Player);
    
    if instance_exists(creator) || true{
        if counterTime > 0{
             // Decrement counter startup timer:
            if minCounter > 0{
                minCounter--;
            }
            else{
                alarm0 = 1;
                counterTime--;
                
                 // End counterattack:
                if counterTime <= 0{
                    sound_play_pitchvol(sndOasisChest, 2, 0.5);
                }
            }
        }
        else{
            if instance_exists(target){
                if(in_sight(target)){
                     // Prepare counterattack:
                    if(chance(2, 7)){
                        alarm0 = 1;
                        minCounter = 1;
                        counterTime = 15;
                        
                        sprite_index = spr_cntr;
                        
                         // Effects:
                        instance_create(x, y, ThrowHit);
                        
                         // Sounds:
                        sound_play_pitchvol(sndCrystalShield, 1.4, 0.6);
                        sound_play_pitchvol(sndOasisChest, 2, 1);
                    }
                    
                     // Move to player:
                    else{
                        scrWalk(8 + irandom(2), point_direction(x, y, target.x, target.y));
                        scrRight(direction);
                    }
                }
                else{
                     // Teleport to player:
                    if(chance(2, 7)){
                        alarm2 = 20;
                        
                        sprite_index = spr_dead;
                    }
                    
                     // Move aimlessly:
                    else{
                        scrWalk(4 + irandom(6), irandom(359));
                        scrRight(direction);
                    }
                }
            }
            
             // Despawn:
            else{
                if(chance(1, 5)){
                    // code later lol
                }
            }
        }
    }
    
     // Despawn:
    else{
        alarm0 = -1;
        sprite_index = spr_dead;
    }
    
#define ChaserTentacle_alrm1
    alarm0 = 10;
    alarm1 = -1;
    maxspeed = 5.5;
    doCounter = false;
    target = instance_nearest(x, y, Player);
    
    if instance_exists(target){
        var dir = point_direction(x, y, target.x, target.y);
        with instance_create(x, y, Slash){
            team = other.team;
            creator = other;
            motion_set(dir, 6);
            image_angle = direction;
            image_xscale = 1.2;
            image_yscale = 0.6;
        }
        motion_set(dir, maxspeed);
        scrWalk(alarm0, direction);
        
         // Effects:
        sleep(60);
        view_shake_max_at(x, y, 30);
        
         // Sounds:
        sound_play_pitchvol(sndCrystalJuggernaut, 1.2, 0.8);
        sound_play_pitchvol(sndOasisMelee, 1.0, 1.0);
    }
    
#define ChaserTentacle_alrm2
    alarm0 = 40 + irandom(20);
    alarm2 = -1;
    target = instance_nearest(x, y, Player);
    
    if instance_exists(target){
        var tile = noone,
            dist = 10000;
        with instances_matching(Floor, "styleb", true){
            var _x = x + 16,
                _y = y + 16,
                _t = other.target,
                _d = point_distance(_x, _y, _t.x, _t.y);

            if _d > 64 && _d <= 256 && _d < dist{
                dist = _d;
                tile = id;
            }
        }
        if instance_exists(tile){
            x = tile.x + 16;
            y = tile.y + 16;
        }
    }
    
    sprite_index = spr_spwn;

#define ChaserTentacle_hurt(_hitdmg, _hitvel, _hitdir)
     // Counterattack:
    if counterTime > 0{
        if minCounter <= 0{
            alarm0 = -1;
            alarm1 = 4;
            minCounter = 0;
            counterTime = 0;
            doCounter = true;
            
            sprite_index = spr_fire;
            
             // Effects:
            sleep(20);
            motion_add(_hitdir, _hitvel);
            
             // Sounds:
            sound_play_pitchvol(sndOasisCrabAttack, 1.2, 1.4);
        }
    }
    
     // Don't counterattack:
    else{
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
    alarm1 = 15 + orandom(2);
    ammo = 3;

     // Effects:
    sound_play_pitch(sndBigBanditMeleeStart, 0.8 + random(0.2));
    view_shake_at(x, y, 10);
    repeat(5){
        with(instance_create(x + orandom(24), y + orandom(24), Dust)){
            waterbubble = true;
        }
    }
    
     // Call the bros:
    with(instances_named(object_index, name)){
    	if(hiding && point_distance(x, y, other.x, other.y) < 64){
    		if(chance(1, 2)) scrAnglerAppear();
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
        maxspeed = 3;
        pitDepth = 0;
        direction = random(360);
        arc_inst = noone;
        arcing = 0;
        wave = random(100);
        gunangle = 0;
        elite = 0;
        ammo = 0;
        canmelee_last = canmelee;

         // Alarms:
        alarm1 = 30;

        return id;
    }

#define Eel_step
	var _arcDistance = 100,
		_arcDistanceElite = 150;

	if(arc_inst != noone){
		if(instance_exists(arc_inst) && arc_inst.c > 2){
			_arcDistance = _arcDistanceElite;
		}

	     // Arc Lightning w/ Jelly:
	    if(in_distance(arc_inst, _arcDistance) && in_sight(arc_inst) && in_distance(target, 120)){
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
	    	if(instance_exists(arc_inst)){
	    		arc_inst.arc_num--;
				if(arcing > 0){
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
	    	}
	        arc_inst = noone;
	        arcing = 0;
	    }
	}

	 // Search for New Jelly:
    if(!instance_exists(arc_inst) && (((current_frame + wave) mod 15) < current_time_scale)){
    	var _inst = nearest_instance(x, y, instances_matching_lt(instances_named(CustomEnemy, "JellyElite"), "arc_num", 5));

        if(!in_distance(_inst, _arcDistanceElite)){
        	_inst = nearest_instance(x, y, instances_matching_lt(instances_named(CustomEnemy, "Jelly"), "arc_num", 3));
        }

        if(in_distance(_inst, _arcDistance)){
        	arc_inst = _inst;
        	arc_inst.arc_num++;
        }
    }

     // Elite:
    if(elite > 0){
        elite -= current_time_scale;

         // Zappin ?
        if(canmelee_last && !canmelee){
			var _dir = random(360);
    		if(instance_exists(Player)){
        		var n = instance_nearest(x, y, Player);
    			_dir = point_direction(x, y, n.x, n.y);
    		}
        	with(scrEnemyShoot(EnemyLightning, _dir, 0)){
	            ammo = 6 + random(2);
        		event_perform(ev_alarm, 0);
	        }
        }
        
         // Effects:
        if(chance_ct(1, 30)){
            instance_create(x, y, PortalL);
        }
        if(elite <= 0){
            instance_create(x, y, PortalL);
            sprite_index = spr_hurt;
            image_index = 0;
        }
    }
	canmelee_last = canmelee;

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
                if(!in_sight(other)) instance_destroy();
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
        if(false && instance_exists(arc_inst) && arc_inst.c == 3 && chance(1, 5) && in_sight(target) && in_distance(target, 96)){
            alarm1 = 3;
            ammo = 10;
            gunangle = point_direction(x, y, target.x, target.y);
            sound_play(sndLaserCrystalCharge);
        }
        else{
             // When you walking:
            if(in_sight(target)){
                scrWalk(irandom_range(23,30), point_direction(x,y,target.x,target.y) + orandom(20));
            }
            else{
                scrWalk(irandom_range(17,30), direction+orandom(30));
            }
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
            if(chance(2 * pickup_chance_multiplier, 3)){
                instance_create(x + orandom(2), y + orandom(2), AmmoPickup);

                 // FX:
                with(instance_create(x, y, FXChestOpen)){
                    motion_add(other.direction, random(1));
                }
            }
            break;

        case 1: // Purple
            if(chance(2 * pickup_chance_multiplier, 3)){
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

#define EelSkull_step
	 // Over Pit:
	if(pit_get(x, y)) my_health = 0;

#define EelSkull_death
	for(var a = direction; a < direction + 360; a += (360 / 4)){
        with(instance_create(x, y, Dust)) motion_add(a, 3);
    }
    
     // Hmmm
    with(instance_create(x, y + 8, WepPickup)){
    	wep = "crabbone";
    	motion_add(random(360), 3);
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
        maxspeed = 2.6;
        meleedamage = 4;
        direction = random(360);
        arc_num = 0;

         // Alarms:
        alarm1 = 40 + irandom(20);

		 // NTTE:
		ntte_anim = false;
		ntte_walk = false;

        return id;
    }

#define Jelly_step
    if(sprite_index != spr_fire) enemySprites();

     // Movement:
    var _maxSpd = clamp(0.07 * walk * current_time_scale, 1, maxspeed); // arbitrary values, feel free to fiddle
    enemyWalk(walkspd, _maxSpd);

     // Bouncy Boy:
    if(speed > 0){
	    if(place_meeting(x + hspeed, y + vspeed, Wall)) {
	        if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
	        if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;
	        scrRight(direction);
	    }
    }

#define Jelly_alrm1
    alarm1 = 40 + random(20);
    target = instance_nearest(x, y, Player);

     // Always movin':
    scrWalk(alarm1, direction);

    if(in_sight(target)){
        var _targetDir = point_direction(x, y, target.x, target.y);

         // Steer towards target:
        motion_add(_targetDir, 0.4);

         // Attack:
        if(chance(1, 3) && in_distance(target, [32, 256])){
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

#define Kelp_step
	 // Over Pit:
	if(pit_get(x, y)) my_health = 0;


#define PitSpark_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.PitSpark[irandom(4)];
		image_angle = random(360);
		image_speed = 0.4;
		depth = 5;
		
		 // Vars:
		mask_index = mskReviveArea;
		dark = irandom(1);
		tentacle = {};
		tentacle_visible = true;
		with(tentacle){
			scale = 1;//random_range(1, 1.2);
			right = choose(-1, 1);
			rotation = irandom(359);
			move_dir = irandom(359);
			move_spd = random(1.6);
			distance = irandom_range(28, 12) * scale;
		};

		 // Alarms:
		alarm0 = 15 + random(5);

		return id;
	}
	
#define PitSpark_step
	 // Movement:
	if(tentacle_visible) with(tentacle){
		rotation += right * current_time_scale * 7;
		distance += move_spd * current_time_scale;
	}

	 // Goodbye:
	if(anim_end) visible = false;

#define PitSpark_alrm0
	instance_destroy();


#define PitSquid_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
        boss = true;
        
         // For Sani's bosshudredux:
        bossname = "PIT SQUID";
        col = c_red;

         // Visual:
		spr_maw = spr.PitSquidMawBite;
		hitid = [spr_maw, "PIT SQUID"];

         // Sounds:
        snd_hurt = sndBallMamaHurt;
        snd_mele = sndMaggotBite;

         // Vars:
        friction = 0.01;
        mask_index = mskNone;
        meleedamage = 8;
        maxhealth = scrBossHP(400);
        is_dead = false;
        raddrop = 1;
        size = 5;
        canfly = true;
        target = noone;
        bite = 0;
        sink = false;
        sink_targetx = x;
        sink_targety = y;
        pit_height = 1;
        spit = 0;
        ammo = 0;
        last_electroplasma = noone;
		laser = 0;
		laser_charge = 0;

         // Eyes:
        eye = [];
        eye_dir = random(360);
        eye_dir_speed = 0;
        eye_dis = 0;
        eye_laser = false;
        eye_laser_delay = 0;
        repeat(3){
            array_push(eye, {
                x : 0,
                y : 0,
                dis : 5,
                dir : random(360),
                blink : false,
                blink_img : 0,
                my_laser : noone
            });
        }

         // Alarms:
        alarm1 = 90;
        alarm2 = 90;
        alarm3 = random_range(1, 30);

        return id;
    }

#define PitSquid_step
	var _eyeDisGoal = 0;

     // Pit Z Movement:
    if(sink){
         // Quickly Sink:
        if(pit_height > 0.5){
	        pit_height += ((0.5 - pit_height) / 4) * current_time_scale;
	        with(eye) blink = true;
	        if(pit_height < 0.55) pit_height = 0.5;
        }

         // Start Rising:
        /*
        if(pit_height <= 0.5){
            sink = false;
            x = sink_targetx;
            y = sink_targety;
            pit_height = -random_range(0.2, 0.5);
        }
        */
    }
    else{
         // Slow Initial Rise:
        if(pit_height < 0.5){
            pit_height += abs(sin(current_frame / 30)) * 0.02 * current_time_scale;

             // Prepare Bite:
            if(bite <= 0 && pit_height > 0.3){
                bite = 0.6;
            }
        }

         // Quickly Rise:
        else if(pit_height < 1){
    		if(bite <= 0) bite = 1;
        	else if(((1 - bite) * sprite_get_number(spr_maw)) >= 6){
	            pit_height += 0.1 * current_time_scale;
	
	             // Reached Top of Pit:
	            if(pit_height >= 1){
	                pit_height = 1;
	                alarm1 = 30 + random(30);
	                alarm2 = 30 + random(10);
	            	with(eye) blink = true;
	                view_shake_at(x, y, 30);
	                sound_play(sndOasisExplosion);
	            }
        	}
        }
    }

     // Sinking/Rising FX:
    if(pit_height > 0.5 && pit_height < 1 && current_frame_active){
        instance_create(x + orandom(32), y + orandom(32), Smoke);
        view_shake_at(x, y, 4);
    }

     // Movement:
    if(eye_laser) speed = 0;
    if(speed > 0){
        eye_dir_speed += (speed / 10) * current_time_scale;
        direction += sin(current_frame / 20) * current_time_scale;

         // Effects:
        if(current_frame_active){
            view_shake_max_at(x, y, min(speed * 4, 3));
        }
        if(chance_ct(speed, 10 / pit_height)){
            instance_create(x + orandom(40), y + orandom(40), Bubble);
        }
    }

     // Find Nearest Visible Player:
    var	_target = noone,
		d = 1000000;

	with(Player) if(in_sight(other)){
		var _dis = point_distance(x, y, other.x, other.y);
		if(_dis < d){
			_target = id;
			d = _dis;
		}
	}

	 // Eye Laser Related:
	if(pit_height < 1) eye_laser = false;
	else if(eye_laser){
		eye_dir_speed += 0.1 * current_time_scale;
	}

     // Eyes:
    if(eye_laser_delay > 0){
    	eye_laser_delay -= current_time_scale;
    	if(eye_laser){
    		if(eye_laser_delay > 8){
    			sound_play_pitchvol(sndNothing2Appear, 0.2 + (0.6 * (eye_laser_delay / 40)), 0.5);
    		}
			if(eye_laser_delay <= 0){
				sound_play_pitchvol(sndNothingBeamStart, 1.2 + random(0.2), 0.8);
			}
    	}
    }
    eye_dir += eye_dir_speed * current_time_scale;
    eye_dir_speed -= (eye_dir_speed * 0.1) * current_time_scale;
    for(var i = 0; i < array_length(eye); i++){
        var _dis = (24 + eye_dis) * max(pit_height, 0),
            _dir = image_angle + eye_dir + (360 / array_length(eye)) * i,
            _x = x + hspeed + lengthdir_x(_dis * image_xscale, _dir),
            _y = y + vspeed + lengthdir_y(_dis * image_yscale, _dir) + 16;

        with(eye[i]){
            x = _x;
            y = _y;

             // Look at Player:
            if(!other.eye_laser && !instance_exists(my_laser)){
	            var _seen = false;
	            if(instance_exists(_target)){
	                _seen = true;
	                dir += angle_difference(point_direction(x, y, _target.x, _target.y), dir) * 0.3 * current_time_scale;
	                dis += (clamp(point_distance(x, y, _target.x, _target.y) / 6, 0, 5) - dis) * 0.3 * current_time_scale;
	            }
	            else dir += sin((current_frame) / 20) * 1.5;
            }

             // Blinking:
            if(blink || (other.eye_laser && other.eye_laser_delay > 0)){
                var n = sprite_get_number(spr.PitSquidEyelid) - 1;
                blink_img += other.image_speed * (instance_exists(my_laser) ? 0.5 : 1) * current_time_scale;

				 // Gonna Laser:
                if(other.eye_laser){
                	var _dir = point_direction(other.x, other.y + 16, x, y);
                	if(chance_ct(10, other.eye_laser_delay)){
	                	if(chance(1, 7)){
	                		with(instance_create(x + orandom(12), y, PortalL)){
								if(chance(1, 2)) sprite_index = spr.PitSpark[irandom(4)];
	                			name = "PitSquidL";
	                		}
	                	}
	                	else{
	                		with(instance_create(x + orandom(16), y, PlasmaTrail)){
		                		sprite_index = spr.QuasarBeamTrail;
		                		hspeed += orandom(1.5);
		                		vspeed += orandom(0.8);
	                		}
	                	}
                	}
                }

                 // End Blink:
                if(blink_img >= n){
                	blink_img = n;
                    if(instance_exists(Player) && chance(1, 4)){
                        blink = false;
                    }
                }
            }

            else{
                blink_img = max(blink_img - other.image_speed, 0);

				 // Eye Lasers:
				if(other.eye_laser){
					dis -= dis * 0.1 * current_time_scale;

					if(!instance_exists(my_laser)){
						with(other){
							other.my_laser = scrEnemyShootExt(other.x, other.y, "QuasarBeam", _dir, 0);
						}
						with(my_laser){
							depth = -3;
							damage = 2;
							bend_fric = 0.2;
							scale_goal = 0.8;
							image_xscale = scale_goal / 2;
							image_yscale = scale_goal / 2;
						}
					}
					with(my_laser) shrink_delay = 4;
				}

                 // Blink:
                if(blink_img <= 0){
                    if(chance_ct(1, (_seen ? 150 : 100))){
                        blink = true;
                    }
            	}
            }

			 // Lasering:
			if(instance_exists(my_laser)){
				_eyeDisGoal = -4;
	            with(my_laser){
					hold_x = other.x;
					hold_y = other.y;
					line_dir_goal = _dir;
	            }
			}
			
			 // Effects:
			/* hmhmmm for now i feel like theres too many particles to focus on i will just comment this out for now sorry
			if(other.pit_height >= 1 && chance_ct(!blink, 150)){
				with(instance_create(x + orandom(20), y + 16 + orandom(20), PortalL)){
					name = "PitSquidL";
					sprite_index = spr.PitSpark[irandom(4)];
					motion_add(point_direction(other.x, other.y, x, y), 1);
				}
	        }*/
        }
    }

	 // Spit:
	if(spit > 0){
		_eyeDisGoal = 8;
		
		var _spr = spr.PitSquidMawSpit,
			_img = ((1 - spit) * sprite_get_number(_spr));
			
		if(_img < 6 || ammo <= 0){
			spit -= (image_speed / sprite_get_number(_spr)) * current_time_scale;
			
			 // Effects:
			if(chance_ct(1, 5)) instance_create(x + orandom(4), y + orandom(4) + 16, Bubble);
		}
	}

     // Bite:
    if(bite > 0){
        _eyeDisGoal = 8;

        var _spr = spr_maw,
            _img = ((1 - bite) * sprite_get_number(_spr));

         // Finish chomp at top of pit:
        if(_img < 6 || pit_height > 0.5){
            bite -= (image_speed / sprite_get_number(_spr)) * current_time_scale;
        }

         // Bite Time:
        if(in_range(_img, 8, 9)){
            mask_index = mskReviveArea;
            with(instances_meeting(x, y, instances_matching_ne(hitme, "team", team))){
                if(place_meeting(x, y, other)) with(other){
                    if(projectile_canhit_melee(other)){
                        projectile_hit_raw(other, meleedamage, true);
                        //if("lasthit" in other) other.lasthit = hitid;
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

    eye_dis += ((_eyeDisGoal - eye_dis) / 5) * current_time_scale;


    if(button_pressed(0, "key6")){
        scrBossIntro(name, sndBigDogIntro, musBoss2);
    }
    if(button_pressed(0, "horn")){
        var _num = 4;
        for(var i = 0; i < _num; i++){
            var l = 64,
                d = (i * (360 / _num)) + eye_dir;

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
	if(button_pressed(0, "key7")){
		eye_laser = !eye_laser;
		eye_laser_delay = 30;
	}
    if(button_pressed(0, "key8")){
        sink = true;
    }
    if(button_pressed(0, "key9")){
        bite = 1.2;
    }

     // Die:
    if(my_health <= 0 && !is_dead){
        my_health = 1;
        is_dead = true; // idea is to use this to make death animations before the head disappears
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
	    if(pit_get(x, y)){
			var f = instances_meeting(x, y, instances_matching_ne(Floor, "sprite_index", spr.FloorTrenchB));
			if(array_length(f) > 0){
		        x = xprevious;
		        y = yprevious;

		        if(array_length(instances_meeting(x + hspeed, y, f)) > 0) hspeed *= -1;
		        if(array_length(instances_meeting(x, y + vspeed, f)) > 0) vspeed *= -1;
		        speed *= 0.8;

		        x += hspeed;
		        y += vspeed;
			}
	    }
        
         // Force Tentacle Teleport:
        with(instances_meeting(x, y, instances_matching(instances_matching(instances_named(CustomEnemy, "SquidArm"), "creator", id), "teleport", false))){
        	alarm2 = 1;
        }

         // Destroy Stuff:
        if(pit_height >= 1){
            var _xsc = image_xscale,
                _ysc = image_yscale;

             // Clear Walls:
            if(place_meeting(x, y, Wall)){
                image_xscale = _xsc * 1.6;
                image_yscale = _ysc * 1.6;
                with(instances_meeting(x, y, Wall)){
                	if(place_meeting(x, y, other)){
	                    with(instance_create(x, y, FloorExplo)) depth = 8;
	                    instance_destroy();
                	}
                }
            }
    
             // Clear Floors:
            if(place_meeting(x, y, Floor)){
                var _floors = instances_matching_ne(Floor, "sprite_index", spr.FloorTrenchB);
                if(array_length(instances_meeting(x, y, _floors)) > 0){
                	image_xscale = _xsc * 1.2;
                	image_yscale = _ysc * 1.2;
                    with(instances_meeting(x, y, _floors)){
                        styleb = true;
                        sprite_index = spr.FloorTrenchB;
                        depth = 9;
                        material = 0;
                        traction = 0.1;

                         // Effects:
                        sound_play_pitchvol(sndWallBreak, 0.6 + random(0.4), 1.5);
                        for(var _x = bbox_left; _x < bbox_right; _x += 16){
                            for(var _y = bbox_top; _y < bbox_bottom; _y += 16){
                                var _dir = point_direction(other.x, other.y, _x + 8, _y + 8),
                                    _spd = 8 - (point_distance(other.x, other.y, _x + 8, _y + 8) / 16);

								if(chance(2, 3)){
	                                with(obj_create(_x + random_range(4, 12), _y + random_range(4, 12), "TrenchFloorChunk")){
	                                    zspeed = _spd;
	                                    direction = _dir;
	                                	if(other.object_index == FloorExplo || chance(1, 2)){
	                                		sprite_index = spr.DebrisTrench;
	                                		zspeed /= 2;
	                                		zfric /= 2;
	                                	}
	                                    //image_index = (point_direction(other.x, other.y, x, y) - 45) mod 90;
	                                }
								}
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
                        mod_script_call("area", "trench", "area_setup_floor", false);
                    }
                    mod_variable_set("area", "trench", "surf_reset", true);
                }
            }

            image_xscale = _xsc;
            image_yscale = _ysc;
        }

	    mask_index = mskNone;
    }

#define PitSquid_alrm1
    alarm1 = 30 + random(30);

    target = instance_nearest(x, y, Player);
    if(instance_exists(target)){
        var _targetDir = point_direction(x, y, target.x, target.y);

        if(!in_distance(target, 96) || pit_height < 1 || chance(1, 2)){
        	if(chance(pit_height, 2)){
	            motion_add(_targetDir, 1);
	            sound_play_pitchvol(sndRoll, 0.2 + random(0.2), 2)
	            sound_play_pitchvol(sndFishRollUpg, 0.4, 0.2);
        	}

			 // In Pit:
            if(sink){
            	alarm1 = 20 + random(10);

            	direction = _targetDir;
            	speed = max(speed, 2);

            	 // Rise:
            	if(
            		in_distance(target, 40)			 ||
            		(!pit_get(x, y) && chance(1, 2)) ||
            		(in_distance(target, 96) && (chance(1, 3) || !chance(my_health, maxhealth)))
            	){
            		sink = false;
            	}
            }
        }

        if(pit_height >= 1 && chance(1, 2)){
             // Check LOS to Player:
            var _targetSeen = (in_sight(target) && in_distance(target, 256));
            if(_targetSeen && !eye_laser){
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
                alarm1 = 20;
            }
        }

         // Spawn Tentacles:
        var t = array_length(instances_matching(instances_named(CustomEnemy, "SquidArm"), "creator", id));
        if(t < 3 || chance(1, 5 + (5 * t))){
        	with(obj_create(0, 0, "SquidArm")){
        		creator = other;
        		alarm2 = 1;
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
        	
			 // Electroplasma Volley:
			if(ammo > 0){
				ammo--;
				spit = 0.6;
				
				 // Projectile:
				var _last = last_electroplasma,
					_angle = _targetDir;
					
				if(in_sight(target)) with(_last){
					var d = angle_difference(direction, _angle);
					_angle = direction - min(abs(d), 40) * sign(d);
				}
				
				with(scrEnemyShootExt(x, y + 16, "ElectroPlasma", _angle + orandom(10), 5)){
					tethered_to = _last;
					damage = 1;
					
					_last = id;
				}
				
				last_electroplasma = _last;
				
				 // Sounds:
				sound_play_pitch(sndOasisShoot, 		1.1 + random(0.3));
				sound_play_pitchvol(sndGammaGutsProc,	0.9 + random(0.5), 0.4);
				
				 // Effects:
				instance_create(x + orandom(8), y + orandom(8) + 16, PortalL);
				 
				 // End Volley Attack:
				if(ammo <= 0){
					last_electroplasma = noone;
					
					 // Sounds:
					sound_play_pitchvol(sndOasisDeath, 0.9 + random(0.3), 2.4);
				}
				
				 // Continue Volley Attack:
				else{
					alarm2 = 5 + random(2);
					alarm1 = alarm1 + alarm2;
				}
			}
			
			else if(in_sight(target)){
	            if(point_distance(target.x, target.y, x + hspeed, y + vspeed + 16) > 64){
					
					 // Half-Health Attack Pattern:
					if(!eye_laser && my_health < maxhealth / 2){
						/*
						
						Thinking about a half health attack pattern where he, instead of the volley attack, does the triple quasar spin
						(also thinking make him snipe you with smaller quasars when you're over land)
						
						*/
						eye_laser = true;
						eye_laser_delay = 40;
					}
					
					 // Begin Volley Attack:
					else{
						spit = 1.2;
						alarm2 = 15;
						alarm1 = alarm1 + alarm2;
						
						ammo = 3 + irandom(2);
						
						 // Sounds:
						sound_play_pitchvol(sndOasisHorn, 0.9, 2.4);
					}
	            }
	    
	             // Bite Player:
	            else{
	                motion_set(_targetDir, _targetDis / 32);
	                bite = 1.2;
	            }
			}
        }
        else eye_laser = false;
    }
    
     // Just in Case:
    else{
    	ammo = 0;
    }

#define PitSquid_alrm3
	var _pits = instances_matching(Floor, "sprite_index", spr.FloorTrenchB),
		_sparks = instances_named(CustomObject, "PitSpark");

	alarm3 = random_range(1, 12) + (12 * array_length(_sparks)) + (30 / array_length(_pits));

	 // Cool tentacle effects:
	if(pit_height >= 1){
		var _tries = 10;
		while(_tries-- > 0){
			with(instance_random(_pits)) if(in_distance(other, [96, 256])){
				if(array_length(instances_meeting(x, y, _sparks)) <= 0){
					with(obj_create((bbox_left + bbox_right) / 2, (bbox_top + bbox_bottom) / 2, "PitSpark")){
						move_dir = point_direction(other.x, other.y, x, y);
					}
					_tries = 0;
				}
			}
		}
	}

#define PitSquid_death
     // Boss Win Music:
    with(MusCont) alarm_set(1, 1);


#define SquidArm_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
         // Visual:
        spr_idle = spr.TentacleIdle;
        spr_walk = spr.TentacleIdle;
        spr_hurt = spr.TentacleIdle;
        spr_dead = spr.TentacleDead;
        spr_dash = spr.TentacleDash;
        spr_appear = spr.TentacleSpwn;
        spr_disappear = spr.TentacleDead;
        depth = -2 - (y / 20000);
        hitid = [spr_idle, "PIT SQUID"];
        sprite_index = spr_appear;
        
         // Sound:
        snd_hurt = sndHitFlesh;
        snd_dead = -1;
        //snd_dead = sndMaggotSpawnDie;
        snd_mele = sndPlantSnare;

         // Vars:
        mask_index = mskLaserCrystal;
        friction = 0.8;
        maxhealth = 22;
        raddrop = 0;
        size = 3;
        creator = noone;
        canfly = true;
        walk = 0;
        kills = 0;
        walkspd = 2;
        maxspeed = 3.5;
        meleedamage = 1;
        wave = 0;
        bomb = 0;
        
        teleport = false;
        teleport_x = x;
        teleport_y = y;
        
        ntte_anim = false;
        
        alarm1 = 10;
	
		return id;
	}
	
#define SquidArm_step
	wave += current_time_scale;
	depth = -2 - (y / 20000);
	
	 // Sprites:
	if(teleport){
		if(sprite_index == spr_disappear){
			if(anim_end){
				image_index -= image_speed;
			}
		}
		else{
			sprite_index = spr_disappear;
			image_index = 0;
			
			mask_index = mskNone;
        	canmelee = false;
        	alarm11 = 30;
		}
	}
	else{
		if(sprite_index == spr_disappear){
			sprite_index = spr_appear;
			image_index = 0;
		}
		else if(anim_end){
			sprite_index = spr_idle;
			
        	mask_index = mskLaserCrystal;
		}
	}

	 // Movement:
	if(mask_index != mskNone){
		var _minSpeed = 0.4;
		speed = max(speed, _minSpeed + friction);

		 // Wall Collision:
		if(place_meeting(x + hspeed, y + vspeed, Wall)){
			if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
			if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;
			speed *= 0.5;
			scrRight(direction);

			 // Just in case:
			if(place_meeting(x, y, Wall) && alarm2 <= 0){
				alarm2 = 1;
			}
		}
	}
	else speed = 0;

	 // Dead:
	if(!instance_exists(creator)){
		my_health = 0;
	}

#define SquidArm_end_step
	 // PitSquid Collision:
	if(instance_exists(creator)){
		var l = 48;
		if(point_distance(x, y, creator.x, creator.y + 16) < l){
			var d = point_direction(creator.x, creator.y + 16, x, y);
			x = creator.x + lengthdir_x(l, d);
			y = creator.y + 16 + lengthdir_y(l, d);
			direction = d;
		}
	}

     // Floor Collision:
    if(pit_get(x, y)){
		var f = instances_meeting(x, y, instances_matching_ne(Floor, "sprite_index", spr.FloorTrenchB));
		if(array_length(f) > 0){
	        x = xprevious;
	        y = yprevious;
	
	        if(array_length(instances_meeting(x + hspeed, y, f)) > 0) hspeed *= -1;
	        if(array_length(instances_meeting(x, y + vspeed, f)) > 0) vspeed *= -1;
	        speed *= 0.5;
	
	        x += hspeed;
	        y += vspeed;
		}
    }
    else if(alarm2 <= 0){
    	alarm2 = 1;
    }

#define SquidArm_alrm1
	alarm1 = 20 + random(20);
	
	target = instance_nearest(x, y, Player);
	if(instance_exists(target)){
		if(in_sight(target)){
			var _targetDir = point_direction(x, y, target.x, target.y);
			
			 // Keep away:
			if(in_distance(target, 48)){
				scrWalk(10 + random(10), _targetDir + 180 + orandom(30));
				alarm1 = walk + random(10);
				
				scrRight(direction + 180);
			}

			else{
				 // Get closer:
				if(!in_distance(target, 96)){
					scrWalk(10 + random(10), _targetDir + orandom(10));
					alarm1 = walk + random(5);
				}
				
				else{
					 // Attack:
					if(in_sight(target) && chance(2, 7)){
						alarm2 = 1;
						bomb = true;
					}
					
					 // Wander Passively:
					direction += orandom(30);
					
					 // Effects:
					instance_create(x, y, Bubble);
				}
				
				scrRight(direction);
			}
		}
		
		 // Teleport:
		else{
			alarm2 = 1;
		}
	}
	
#define SquidArm_alrm2
	alarm2 = 0;
	
	 // Effects:
	repeat(2 + irandom(3)) instance_create(x, y, Bubble);

	target = instance_nearest(x, y, Player);
	if(instance_exists(creator)){
		 // Teleport Appear:
		if(teleport){
			if(instance_exists(target)){
				teleport = false;
				
				x = teleport_x;
				y = teleport_y;
				
				 // Sounds:
				sound_play_pitchvol(sndOasisMelee, 1.0 + random(0.3), 0.6);
			}
			
			else{
				instance_destroy();
				exit;
			}
		}
		
		 // Teleport Disappear:
		else{
			teleport = true;
			alarm2 = 20 + random(20);
			
			 // Determine Teleport Coordinates:
			if(instance_exists(target)){
				var _target = target,
					_creator = creator,
					_allPits = instances_matching(Floor, "sprite_index", spr.FloorTrenchB);
				
				 // Bomb Attack:
				if(bomb){
					with(scrEnemyShoot("SquidBomb", point_direction(x, y, target.x, target.y), 0)){
						target = _target;
						ammo   = 4 + irandom(3);
						scale  = 1;
						triple = false;
						
						alarm0 = 10;
						alarm1 += alarm0;
					}
					
					bomb = false;
				}
				
				 // Teleport Closer to Player:
				else{
					var _emptyPits = [],
						_validPits = [];
					
					 // Find Clear Pits:
					with(_allPits) if(!place_meeting(x, y, Wall) && !place_meeting(x, y, FloorExplo)){
						array_push(_emptyPits, id);
					}
					
					var _nearest = nearest_instance(target.x, target.y, _emptyPits),
						_minDist = point_distance(target.x, target.y, _nearest.x, _nearest.y);
						
					 // Find Pits Near Target:
					with(_emptyPits) if(in_distance(_target, [32, max(96, _minDist)]) && in_distance(_creator, [60, 180])){
						array_push(_validPits, id);
					}
					
					 // Teleport to Random Valid Pit:
					if(array_length(_validPits)){
						with(instance_random(_validPits)){
							with(other){
								teleport_x = other.x + 16;
								teleport_y = other.y + 16;
							}
						}
					}
					
					 // Teleport to a Random Pit:
					else{
						with(instance_random(_emptyPits)){
							with(other){
								teleport_x = other.x + 16;
								teleport_y = other.y + 16;
							}
						}
					}
				}
			}
			
			 // Sounds:
			sound_play_pitchvol(sndOasisMelee, 0.7 + random(0.3), 1.0);
		}
		
		alarm1 += alarm2;
	}
	
#define SquidArm_draw
	var h = (nexthurt > current_frame);
	if(h) d3d_set_fog(true, image_blend, 0, 0);
	draw_self_enemy();
	if(h) d3d_set_fog(false, c_white, 0, 0);
	
#define SquidArm_hurt(_hitdmg, _hitvel, _hitdir)
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
        with(instances_matching(instances_named(object_index, name), "creator", creator)){
        	nexthurt = current_frame + 6;
        }
        
        scrRight(_hitdir + 180);
    }


#define SquidBomb_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		hitid = -1;

		 // Vars:
		mask_index = mskBandit;
		creator = noone;
		target = noone;
		team = 0;
		ammo = 0;
		scale = 0.4;
		triple = true;
		
		alarm0 = 3;
		alarm1 = 20;
		
		return id;
	}
	
#define SquidBomb_alrm0
	var _len = 24,
		_dir = direction;
	
	 // Adjust Direction:
	if(instance_exists(target) && instance_exists(creator)){
		var _targetDir = point_direction(x, y, target.x, target.y),
			_angleDiff = angle_difference(_dir, _targetDir);
			
		_dir -= min(abs(_angleDiff), 45) * sign(_angleDiff);
	}
	
	var _x = x + lengthdir_x(_len, _dir),
		_y = y + lengthdir_y(_len, _dir);
	
	if(place_meeting(_x, _y, Floor) && !place_meeting(_x, _y, Wall) && !place_meeting(x, y, FloorExplo)){
		if(pit_get(_x, _y)){

			 // Relocate Creator:
			with(creator){
				teleport_x = _x;
				teleport_y = _y;
				
				alarm2 = other.alarm1 + 10;
				alarm1 = max(alarm1, alarm2);
			}
		
			 // Spawn Next Bomb:
			if(ammo > 0){
				with(scrEnemyShootExt(_x, _y, "SquidBomb", _dir, 0)){
					target = other.target;
					ammo = other.ammo - 1;
				}
			}
		}
	}

	 // Effects:
	repeat(irandom_range(4, 8)){
		with(instance_create(x + orandom(16), y + orandom(16), PlasmaTrail)){
			sprite_index = spr.ElectroPlasmaTrail;
		}
	}
	instance_create(x + orandom(4), y + orandom(4), PortalL);
	
#define SquidBomb_alrm1
	instance_destroy();
	
#define SquidBomb_destroy
	var l = 8,
		_projectiles = [],
		_freeze = UberCont.opt_freeze;
	
	 // I think this works:
	UberCont.opt_freeze = 0; // what u using this for smash brtohers
	
	 // Triple Sucker:
	if(triple){
		for(var d = 0; d < 360; d += 120){
			var _x = x + lengthdir_x(l, d + direction),
				_y = y + lengthdir_y(l, d + direction);
				
			//array_push(_projectiles, instance_create(_x, _y, PlasmaImpact));
			scrEnemyShootExt(_x, _y, "ElectroPlasmaImpact", direction, 0);
		}
	}

	 // Single Sucker:
	else{
		//array_push(_projectiles, instance_create(x, y, PlasmaImpact));
		scrEnemyShoot("ElectroPlasmaImpact", direction, 0);
	}
	
	/*
	with(_projectiles){
		creator =	other.creator;
		team =		other.team;
		damage =	2;
		direction = other.direction;
		hitid =		[spr.PitSquidMawBite, "PIT SQUID"];
		
		image_xscale = other.scale;
		image_yscale = other.scale;
	}
	*/
	
	 // Effects:
	repeat(1 + irandom(2)){
		instance_create(x + orandom(16), y + orandom(16), PortalL);
	}
	
	 // Sounds:
	sound_play_hit(sndLightningReload, 0.4);
	
	UberCont.opt_freeze = _freeze;


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
        alarm0 = 1; 	// Appear:
        alarm1 = 90;	// Disappear:

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
                    if(chance_ct(1, 3)){
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
                            if(object_index != FloorExplo && other.sprite_index == other.spr_spwn && chance(1, 2)){
                                var _ox = choose(8, 24),
                                    _oy = choose(8, 24),
                                    _dir = point_direction(other.x, other.y, x, y),
                                    _spd = other.spd;

                                with(obj_create(x + _ox + orandom(8), y + _oy + orandom(8), "TrenchFloorChunk")){
                                    speed /= 2;
                                    direction = _dir;
                                    zspeed = 3 + random(2);
                                    //image_index = (point_direction(other.x, other.y, x, y) - 45) mod 90;
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
	}
    if(chance_ct(1, 5)){
        sound_play_pitchvol(sndOasisDeath, random(3), 0.3);
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
        depth = -9;

         // Vars:
        z = 0;
        zspeed = 6 + random(4);
        zfric = 0.3;
        friction = 0.05;
        image_angle += orandom(20);
        rotspeed = random_range(1, 2) * choose(-1, 1);
        rotfriction = 0;
        if(chance(1, 3)){
        	rotspeed *= 8;
        	rotfriction = 1;
        }

        motion_add(random(360), 2 + random(3));

        return id;
    }

#define TrenchFloorChunk_step
    z_engine();
    image_angle += rotspeed * current_time_scale;
    rotspeed -= clamp(rotspeed, -rotfriction, rotfriction) * current_time_scale;

     // Stay above walls:
    /*depth = clamp(-z / 8, -8, 0);
    if(place_meeting(x, y - z, Wall) || !place_meeting(x, y - z, Floor)){
        depth = min(depth, -8);
    }*/

     // Effects:
    if(chance_ct(1, 10)){
        instance_create(x, y - z, Bubble);
    }

    if(z <= 0) instance_destroy();

#define TrenchFloorChunk_draw
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, 1);

#define TrenchFloorChunk_destroy
    sound_play_pitchvol(sndOasisExplosionSmall, 0.5 + random(0.3), 0.3 + random(0.1));
    var _debris = (sprite_index == spr.DebrisTrench);

     // Fall into Pit:
    if(!place_meeting(x, y, Wall) && pit_get(x, y)){
        with(instance_create(x, y, Debris)){
            sprite_index = other.sprite_index;
            image_index = other.image_index;
            image_angle = other.image_angle;
            direction = other.direction;
            speed = other.speed;
        }
        if(!_debris) repeat(3){
        	with(instance_create(x, y, Smoke)){
        		motion_add(random(360), 2);
        	}
        }
    }

     // Break on ground:
    else{
        y -= 2;
        sound_play_pitchvol(sndWallBreak, 0.5 + random(0.3), 0.4);
    	for(var d = direction; d < direction + 360; d += 360 / (_debris ? 1 : 3)){
    		with(instance_create(x, y, Debris)){
	    		motion_set(d + orandom(20), other.speed + random(1));
	    		if(_debris){
	    			image_angle = other.image_angle;
	    		}
	    		else speed += 2 + random(1);
	            if(!place_meeting(x, y, Floor)) depth = -8;
	
				 // Dusty:
	            with(instance_create(x + orandom(4), y + orandom(4), Dust)){
					waterbubble = false;
			        depth = other.depth;
					motion_add(other.direction, other.speed);
			    }
    		}
        }
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
	 // Effects:
    if(chance_ct(1, 5)){
        with(instance_create(x, y, Bubble)){
            friction = 0.2;
            motion_set(90 + orandom(5), random_range(4, 7));
        }
        // with instance_create(x,y-8,Smoke){
        //     motion_set(irandom_range(65,115),random_range(10,100));
        // }
    }

	 // Over Pit:
	if(pit_get(x, y)) my_health = 0;

#define Vent_death
    obj_create(x, y, "BubbleExplosion");


#define WantPitSquid_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		
		
		return id;
	}
	
#define WantPitSquid_step

	 // Be more elaborate later:
	if(!instance_exists(enemy)){
		with(instance_random(Player)){
			with(obj_create(x, y, "PitSquid")){
				scrBossIntro(name, sndBigDogIntro, musBoss2);
			}
		}
		
		instance_destroy();
	}

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
        maxspeed = 4;
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
            else if(in_sight(target)) {
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
        else if(in_sight(target)) {
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
    //d3d_set_fog(1, c_black, 0, 0);
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
                _blend = image_blend,
                _alpha = image_alpha;

        	if(_blend == c_white){
        		if("charm" in self && lq_defget(charm, "charmed", true)){
        			draw_set_flat(make_color_rgb(56, 252, 0));
        		}
        	}

            for(var o = 0; o <= _dis; o++){
                draw_sprite_ext(_spr, _img, _x1 + lengthdir_x(o, _dir) - _surfX, _y1 + lengthdir_y(o, _dir) - _surfY, _xscal, _yscal, _angle, _blend, _alpha);
            }

            draw_set_flat(-1);
        }
    }
    //d3d_set_fog(0, 0, 0, 0);
    surface_reset_target();

     // Trail Surface:
    //d3d_set_fog(1, make_color_rgb(252, 56, 0), 0, 0);
    draw_set_blend_mode(bm_add);
    draw_surface(_surfTrail, _surfX, _surfY);
    draw_set_blend_mode(bm_normal);
    //d3d_set_fog(0, 0, 0, 0);

    instance_destroy();

#define draw_bloom
	 // Canister Bloom:
	with(instances_matching(instances_named(CustomEnemy, "Angler"), "hiding", true)) if(visible){
        draw_sprite_ext(sprRadChestGlow, image_index, x + (6 * right), y + 8, image_xscale * 2 * right, image_yscale * 2, image_angle, image_blend, image_alpha * 0.1);
    }

     // Pit Spark:
    with(instances_named(CustomObject, "PitSpark")) if(visible){
    	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * 0.2);
    }
    with(instances_named(PortalL, "PitSquidL")) if(visible){
    	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * 0.1);
    }

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
    draw_set_flat(draw_get_color());
    with(instances_named(CustomEnemy, "Angler")){
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
    draw_set_flat(-1);

     // Jellies:
    with(instances_named(CustomEnemy, "Jelly")){
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
    
     // Squid Arms:
    with(instances_named(CustomEnemy, "SquidArm")){
    	draw_circle(x, y - 12, 24 + orandom(1), false);
    }
    
     // Pit Squid:
    with(instances_matching_ge(instances_named(CustomEnemy, "PitSquid"), "pit_height", 1)){
        with(eye)
            draw_circle(x, y + 16, ((blink ? 48 : 64) + orandom(1)), false);
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
    
     // Pit Squid:
    with(instances_matching_ge(instances_named(CustomEnemy, "PitSquid"), "pit_height", 1)){
        with(eye) if !blink
            draw_circle(x, y + 16, 32 + orandom(1), false);
    }


/// Pits Yo
#define pit_get(_x, _y)
	return global.pit_grid[# _x / 16, _y / 16];

#define pit_set(_x, _y, _bool)
	global.pit_grid[# _x / 16, _y / 16] = _bool;


/// Scripts
#define orandom(n)																		return  random_range(-n, n);
#define chance(_numer, _denom)															return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)														return  random(_denom) < (_numer * current_time_scale);
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