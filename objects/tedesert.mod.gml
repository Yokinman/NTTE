#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.sav = mod_variable_get("mod", "teassets", "sav");

    global.debug_lag = false;

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index + image_speed_raw >= image_number)


#define BabyScorpion_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
         // Visual:
		spr_idle = spr.BabyScorpionIdle;
		spr_walk = spr.BabyScorpionWalk;
		spr_hurt = spr.BabyScorpionHurt;
		spr_dead = spr.BabyScorpionDead;
		spr_fire = spr.BabyScorpionFire;
		spr_shadow = shd24;
		spr_shadow_y = -1;
		hitid = [spr_idle, "BABY SCORPION"];
		mask_index = mskBandit;
		depth = -2;

		 // Sound:
		snd_hurt = sndScorpionHit;
		snd_dead = sndScorpionDie;
		snd_mele = sndScorpionMelee
		snd_fire = sndScorpionFireStart;

		 // Vars:
		gold = false;
		maxhealth = 7;
		meleedamage = 6;
		canmelee = true;
		raddrop = 4;
		size = 1;
		walk = 0;
		ammo = 0;
		walkspeed = 0.8;
		maxspeed = 2.4;
		gunangle = random(360);
		direction = gunangle;

         // Alarms:
		alarm1 = 40 + irandom(30);

		 // NTTE:
		ntte_anim = false;

		return id;
	}

#define BabyScorpion_step
     // Animate:
    if(sprite_index != spr_hurt || anim_end){
		if(ammo > 0) sprite_index = spr_fire;
        else{
        	if(speed <= 0) sprite_index = spr_idle;
    	    else sprite_index = spr_walk;
    	}
    }

#define BabyScorpion_alrm1
    alarm1 = 50 + irandom(30);
    target = instance_nearest(x, y, Player);

     // Attack:
    if(ammo > 0){
        ammo--;
        alarm1 = (gold ? 2 : irandom_range(1, 3));

         // Aim and walk:
        if(in_sight(target)){
            gunangle = point_direction(x, y, target.x, target.y);
        }
		scrWalk(alarm1 + 3, gunangle + orandom(10));
        
         // Golden venom shot:
        if(gold){
        	var o = random_range(20, 60);
        	for(var a = -o; a <= o; a += o){
            	scrEnemyShoot("VenomPellet", gunangle + a, ((a == 0) ? 10 : 6) + random(2));
        	}
        }
        
         // Normal venom shot:
        else{
			scrEnemyShoot("VenomPellet", gunangle + orandom(20), 7 + random(4));
        }
        
         // Effects:
        sound_play_pitch(sndScorpionFire, 1.4 + random(0.2));
        if(chance(1, 4)){
            with(scrFX(x, y, [gunangle + orandom(24), random_range(2, 6)], AcidStreak)){
                image_angle = direction;
            }
    	}

         // End:
        if(ammo <= 0){
            alarm1 = 20 + irandom(20);
            sprite_index = spr_idle;
            sound_play_pitchvol(sndSalamanderEndFire, 1.6, 0.4);
        }
    }

	 // Normal AI:
    else if(in_sight(target)){
        var _targetDir = point_direction(x, y, target.x + target.hspeed, target.y + target.vspeed);

         // Start attack:
    	if(in_distance(target, [32, 96]) && chance(2, 3)){
		    alarm1 = 1;
		    ammo = 6 + irandom(2);
		    gunangle = _targetDir;
            sound_play_pitch(snd_fire, 1.6);
    	}

         // Move Away From Target:
        else if(in_distance(target, 32)){
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

     // Venom Explosion:
    if(gold){
        repeat(4 + irandom(4)) scrEnemyShoot("VenomPellet", random(360), 8 + random(4));
        repeat(8 + irandom(8)) scrEnemyShoot("VenomPellet", random(360), 4 + random(4));
    }

     // Effects:
    var l = 6;
	repeat(gold ? 3 : 2){
		var d = direction + orandom(60);
		with(scrFX(x + lengthdir_x(l, d), y + lengthdir_y(l, d), [d, 4 + random(4)], AcidStreak)){
			image_angle = direction;
		}
	}
    sound_play_pitchvol(snd_dead, 1.5 + random(0.3), 1.3);
    snd_dead = -1;


#define BabyScorpionGold_create(_x, _y)
    with(obj_create(_x, _y, "BabyScorpion")){
         // Visual:
		spr_idle = spr.BabyScorpionGoldIdle;
		spr_walk = spr.BabyScorpionGoldWalk;
		spr_hurt = spr.BabyScorpionGoldHurt;
		spr_dead = spr.BabyScorpionGoldDead;
		spr_fire = spr.BabyScorpionGoldFire;
		spr_shadow = shd24;
		hitid = [spr_idle, "GOLD BABY SCORPION"];
		sprite_index = spr_idle;
		mask_index = mskBandit;
		depth = -2;

		 // Sound:
		snd_hurt = sndGoldScorpionHurt;
		snd_dead = sndGoldScorpionDead;
		snd_mele = sndGoldScorpionMelee;
		snd_fire = sndGoldScorpionFire;

		 // Vars:
		gold = true;
		maxhealth = 16;
		my_health = maxhealth;
		raddrop = 14;

		return id;
    }


#define BigCactus_create(_x, _y)
    with(instance_create(_x, _y, CustomProp)){
         // Visual:
        spr_shadow = shd32;
        spr_shadow_y = 4;
        depth = -1.5;
        switch(GameCont.area){
        	case 0:
        		spr_idle = spr.BigNightCactusIdle;
        		spr_hurt = spr.BigNightCactusHurt;
        		spr_dead = spr.BigNightCactusDead;
        		break;

			case "coast":
        		spr_idle = spr.BigBloomingCactusIdle;
	        	spr_hurt = spr.BigBloomingCactusHurt;
	        	spr_dead = spr.BigBloomingCactusDead;
	        	break;

        	default:
		        spr_idle = spr.BigCactusIdle;
		        spr_hurt = spr.BigCactusHurt;
		        spr_dead = spr.BigCactusDead;
        }

		 // Sound:
		snd_hurt = sndHitPlant;
		snd_dead = sndPlantSnareTrapper;

         // Vars:
        maxhealth = 24;
        size = 4;

		 // Spawn Enemies:
		instance_create(x, y, PortalClear);
		if(!in_distance(Player, 96)){
			repeat(choose(2, 3)){
				obj_create(x + orandom(4), y + orandom(4), ((GameCont.area == "coast") ? "Gull" : "BabyScorpion"));
			}
		}

        return id;
    }

#define BigCactus_death
	 // Dust-o:
	var _ang = random(360);
	for(var d = _ang; d < _ang + 360; d += random_range(60, 180)){
		with(scrFX(x, y, [d, random_range(4, 5)], Dust)){
			friction *= 2;
		}
	}


#define BigMaggotSpawn_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle = spr.BigMaggotSpawnIdle;
		spr_walk = spr_idle;
		spr_hurt = spr.BigMaggotSpawnHurt;
		spr_dead = spr.BigMaggotSpawnDead;
		spr_chrg = spr.BigMaggotSpawnChrg;
		spr_shadow = shd64B;
		hitid = [spr_idle, "BIG MAGGOT NEST"];
		depth = -1;

		 // Sound:
		snd_hurt = sndHitFlesh;
		snd_dead = sndBigMaggotDie;

		 // Vars:
		mask_index = mskLast;
		maxhealth = 50;
		lsthealth = maxhealth;
		raddrop = 6;
		size = 4;
		loop_snd = -1;
		scorp_drop = 0;

		 // Alarms:
		alarm0 = 150;

		 // Flies:
		var f = [
			[-18, -14],
			[  0, -28],
			[ 26, -16 + orandom(6)]
		];

		for(var i = 0; i < array_length(f); i++){
			with(obj_create(x, y, "FlySpin")){
				target = other;
				target_x = (f[i, 0] + orandom(2)) * other.right;
				target_y = (f[i, 1] + orandom(2));
			}
		}
		
		 // Mags:
		repeat(irandom_range(3, 6)){
			instance_create(x, y, Maggot);
		}
		
		 // Clear Walls:
		with(instance_create(x, y, PortalClear)){
			mask_index = mskScrapBoss;
		}

		return id;
	}

#define BigMaggotSpawn_step
	x = xstart;
	y = ystart;
	speed = 0;

	 // Idle Sound:
	if(distance_to_object(Player) < 64){
		if(!audio_is_playing(loop_snd)){
			loop_snd = sound_play(sndMaggotSpawnIdle);
		}
	}
	else if(loop_snd != -1){
		sound_stop(loop_snd);
		loop_snd = -1;
	}

	 // Animate:
	if(image_index < 1 && sprite_index == spr_idle){
		var a = ((loop_snd == -1) ? 0.2 : 0.3);
		image_index += random(image_speed_raw * a) - image_speed_raw;
	}

	 // Clear Walls:
	if(place_meeting(x, y, Wall)){
		with(instances_meeting(x, y, Wall)){
			if(place_meeting(x, y, other)){
				instance_create(x, y, FloorExplo);
				instance_destroy();
			}
		}
	}

	 // True Maggot Spawn:
	if(lsthealth > my_health){
		if(current_frame_active){
			lsthealth -= 2;

			 // Maggot:
			var _loop = chance(GameCont.loops, 3),
				l = (24 + orandom(2)) * image_xscale,
				d = (_loop ? random(360) : random_range(200, 340));

			with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l * 0.5, d), (_loop ? FiredMaggot : Maggot))){
				x = xstart;
				y = ystart;
				kills = 1; // Fix FiredMaggot
				creator = other;

				 // Effects:
				for(var i = 0; i <= (4 * _loop); i += 2){
					with(instance_create(x, y, DustOLD)){
						motion_add(d + orandom(10), 2 + i);
						depth = other.depth - 1;
						image_blend = make_color_rgb(170, 70, 60);
						image_speed /= max(1, (i / 2.5));
					}
				}
				
				 // Sounds:
				var s = audio_play_sound((_loop ? sndFlyFire : sndHitFlesh), 0, false);
				audio_sound_gain(s, min(0.9, random_range(24, 32) / (distance_to_object(Player) + 1)), 0);
				audio_sound_pitch(s, 1.2 + random(0.2));
			}
		}

		 // Stayin Alive:
		if(my_health <= 1){
			nexthurt = current_frame + 6;
			sprite_index = spr_hurt;
			image_index = 0;
			alarm0 = 2;
		}
	}
	else{
		if(lsthealth > 0) lsthealth = my_health;
		else my_health = lsthealth;
	}

#define BigMaggotSpawn_alrm0
	alarm0 = irandom_range(15, 60);

	 // Fallin Apart:
	if(my_health > 0){
		target = instance_nearest(x, y, Player);
		if(my_health <= 1 || distance_to_object(target) < 64 || (chance(1, 3) && in_sight(target))){
			my_health -= 2;
		}
	}

#define BigMaggotSpawn_hurt(_hitdmg, _hitvel, _hitdir)
	if(my_health > 1){
		enemyHurt(_hitdmg, _hitvel, _hitdir);
		my_health = max(1, my_health);
	}
	else if(alarm0 > 2) alarm0 = 2;

#define BigMaggotSpawn_death
	speed /= 5;

	 // Maggots:
	repeat(2){
		with(instance_create(x, y, MaggotExplosion)){
			creator = other;
		}
	}
	repeat(irandom_range(2, 3)){
		with(instance_create(x, y, (chance(max(0.01, GameCont.loops), 3) ? JungleFly : BigMaggot))){
			creator = other;
			raddrop = 4;
		}
	}
	
	 // Flies:
	repeat(irandom_range(3, 6)){
		obj_create(x + orandom(32), y + orandom(16), "FlySpin");
	}

	 // Scrop:
	if(scorp_drop > 0) repeat(scorp_drop){
		instance_create(x, y, Scorpion);
	}

	 // Pickups:
	if(chance(1, 10)){
		with(instance_create(x, y, BigWeaponChest)){
			motion_add(random(360), 2);
			repeat(12) scrFX(x, y, random_range(4, 6), Dust);
		}
		sound_play_pitchvol(sndStatueHurt, 2 + orandom(0.2), 0.8);
		sound_play_pitchvol(sndChest, 0.6, 1.5);
	}
	else{
		pickup_drop(50, 35);
		pickup_drop(50, 35);
	}
	pickup_drop(100, 0);
	pickup_drop(100, 0);


#define Bone_create(_x, _y)
    with(instance_create(_x, _y, CustomProjectile)){
         // Visual:
        sprite_index = spr.Bone;
        hitid = [sprite_index, "BONE"];

         // Vars:
        mask_index = mskFlakBullet;
        friction = 1;
        damage = 34;
        force = 1;
        typ = 1;
        creator = noone;
        rotation = 0;
        rotspeed = (1 / 3) * choose(-1, 1);
        broken = false;

         // Annoying Fix:
        if(place_meeting(x, y, PortalShock)) Bone_destroy();

        return id;
    }

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

	        var _tries = 10;
	        while(place_meeting(x, y, Wall) && _tries-- > 0){
	            var w = instance_nearest(x, y, Wall),
	                _dir = point_direction(w.x + 8, w.y + 8, x, y);
	
	            while(place_meeting(x, y, w)){
	                x += lengthdir_x(4, _dir);
	                y += lengthdir_y(4, _dir);
	            }
	        }
        }

        instance_destroy();
    }

#define Bone_draw
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, rotation, image_blend, image_alpha);

#define Bone_hit
     // Secret:
    if(other.object_index = ScrapBoss){
        with(other){
            var c = scrCharm(self, true);
            c.time = 300;
        }
        sound_play(sndBigDogTaunt);
        instance_delete(id);
        exit;
    }

    projectile_hit_push(other, damage, speed * force);
    if(!instance_exists(self)) exit;

     // Sound:
    sound_play_hit_ext(sndBloodGamble, 1.2 + random(0.2), 1.5);

     // Break:
    var i = nearest_instance(x, y, instances_matching(CustomProp, "name", "CoastBossBecome"));
    if(!in_distance(i, 32)){
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
    	sound_play_hit_ext(sndHitRock, 1.4 + random(0.2), 2);
    	
    	var p = false;
    	with(["wep", "bwep"]){
    		var o = self;
    		with(Player) if(wep_get(variable_instance_get(id, o)) == "scythe"){
    			p = true;
    		}
    	}
    	
    	 // For u yokin:
    	if(p){
    		repeat(2) with(obj_create(x, y, "BonePickup")){
    			sprite_index = spr.BoneShard;
    			motion_add(random(360), 2);
    		}
    	}
    	
    	else repeat(2) with(instance_create(x, y, Shell)){
            sprite_index = spr.BoneShard;
            image_speed = 0;
            motion_add(random(360), 2);
        }
    }

     // Pickupable:
    else with(instance_create(x, y, WepPickup)){
        wep = "crabbone";
        rotation = other.rotation;
    }


#define BoneSpawner_create(_x, _y)
    with(instance_create(_x, _y, CustomObject)){
    	creator = noone;
    	return id;
    }

#define BoneSpawner_step
    if(instance_exists(creator)){
         // Follow Creator:
        x = creator.x;
        y = creator.y;
    }
    else{
    	if(position_meeting(x, y, Corpse)){
	         // Enter the bone zone:
	        with(instance_create(x, y, WepPickup)){
	            wep = "crabbone";
	            motion_add(random(360), 3);
	        }
	
	         // Effects:
	        repeat(2) with(instance_create(x, y, Dust)){
	            motion_add(random(360), 3);
	        }
    	}

        //with(instances_matching(object_index, "name", name)) instance_destroy();
        instance_destroy();
    }


#define CoastBossBecome_create(_x, _y)
    with(instance_create(_x, _y, CustomHitme)){
         // Visual:
        spr_idle = spr.BigFishBecomeIdle;
        spr_hurt = spr.BigFishBecomeHurt;
        spr_dead = sprBigSkullDead;
        spr_shadow = shd32;
        image_speed = 0;
        depth = -1;

         // Sound:
        snd_hurt = sndHitRock;
        snd_dead = -1;

         // Vars:
        mask_index = mskScorpion;
        maxhealth = 100 * (1 + GameCont.loops);
        size = 2;
        part = 0;
        team = 0;
        
         // Easter:
        pickup_indicator = scrPickupIndicator("DONATE");
        with(pickup_indicator) on_meet = script_ref_create(CoastBossBecome_PickupIndicator_meet);

		 // Part Bonus:
		if(variable_instance_get(GameCont, "visited_coast", false)){
			part = 1;
		}
		part = min(part + GameCont.loops, 2);

        return id;
    }

#define CoastBossBecome_step
    speed = 0;
    x = xstart;
    y = ystart;

     // Animate:
    image_index = clamp(part, 0, image_number - 1);
    if(nexthurt > current_frame + 3) sprite_index = spr_hurt;
    else sprite_index = spr_idle;

	 // Boneman Feature:
	var _pickup = pickup_indicator;
	if(instance_exists(_pickup)) with(player_find(_pickup.pick)){
		projectile_hit(id, 1);
		lasthit = [sprBone, "GENEROSITY"];

		with(other) with(obj_create(x, y, "Bone")){
			projectile_hit(other, damage);
		}
	}

     // Rebuilding Skeleton:
	if(part > 0){
		 // Break Walls:
		var o = 4 * part,
			_x1 = bbox_left  - o - (o * image_xscale),
			_y1 = bbox_top,
			_x2 = bbox_right + o - (o * image_xscale),
			_y2 = bbox_bottom;

		with(instance_rectangle_bbox(_x1, _y1, _x2, _y2, Wall)){
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}

		 // Complete:
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
	        exit;
	    }
	}

     // Death:
    if(my_health <= 0) instance_destroy();

#define CoastBossBecome_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);  // Sound
    
     // Secret:
    if(
    	(instance_is(other, CustomProjectile) && "name" in other && other.name == "Bone")
    	||
    	(instance_is(other, ThrownWep) && wep_get(other.wep) == "crabbone")
    	||
    	(instance_is(other, CustomProjectile) && variable_instance_get(other, "name") == "BoneArrow")
    ){
    	var _add = lq_defget(variable_instance_get(other, "wep"), "ammo", 1) + variable_instance_get(other, "big", 0);

    	part += _add;
        my_health = max(my_health, maxhealth);

         // Effects:
        sound_play_hit(sndMutant14Turn, 0.2);
        repeat(3 * _add){
            instance_create(other.x + orandom(4), other.y + orandom(4), Bubble);
            with(instance_create(x - (image_xscale * 8 * part), y, Smoke)){
                motion_add(random(360), 1);
                depth = -2;
            }
        }

        instance_delete(other);
    }

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

#define CoastBossBecome_PickupIndicator_meet
	if(other.race == "skeleton") return true;
	return false;


#define CoastBoss_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
        boss = true;

         // For Sani's bosshudredux:
        bossname = "BIG FISH";
        col = c_red;

        /// Visual:
            spr_spwn = spr.BigFishSpwn;
	        spr_idle = sprBigFishIdle;
			spr_walk = sprBigFishWalk;
			spr_hurt = sprBigFishHurt;
			spr_dead = sprBigFishDead;
		    spr_weap = mskNone;
		    spr_shad = shd48;
			spr_shadow = spr_shad;
			hitid = 105; // Big Fish
			sprite_index = spr_spwn;
		    depth = -2;

			 // Fire:
			spr_chrg = sprBigFishFireStart;
			spr_fire = sprBigFishFire;
			spr_efir = sprBigFishFireEnd;

			 // Swim:
			spr_dive = spr.BigFishLeap;
			spr_rise = spr.BigFishRise;

         // Sound:
		snd_hurt = sndOasisBossHurt;
		snd_dead = sndOasisBossDead;
		snd_lowh = sndOasisBossHalfHP;

		 // Vars:
		mask_index = mskBigMaggot;
		maxhealth = scrBossHP(150);
		raddrop = 50;
		size = 3;
		meleedamage = 3;
		walk = 0;
		walkspeed = 0.8;
		maxspeed = 3;
		ammo = 4;
		swim = 0;
		swim_mask = -1;
		swim_target = noone;
		gunangle = random(360);
		direction = gunangle;
		canfly = true;
		intro = false;
		tauntdelay = 40;
		swim_ang_frnt = direction;
		swim_ang_back = direction;
		shot_wave = 0;
		fish_train = [];
		fish_swim = [];
		fish_swim_delay = 0;
		fish_swim_regen = 0;
		for(var i = 0; i < (GameCont.loops * 3); i++) fish_train[i] = noone;

		 // Alarms:
		alarm1 = 90;
		alarm2 = -1;
		alarm3 = -1;

		 // NTTE:
		ntte_anim = false;

		return id;
    }

#define CoastBoss_step
     // Animate:
    var s = [spr_hurt, spr_spwn, spr_dive, spr_rise, spr_efir, spr_fire, spr_chrg];
    if(array_find_index(s, sprite_index) < 0){
        if(speed <= 0) sprite_index = spr_idle;
    	else if(sprite_index == spr_idle) sprite_index = spr_walk;
    }
    else if(anim_end){
        var _lstspr = sprite_index;
        if(fork()){
            if(sprite_index == spr_spwn) {
                sprite_index = spr_hurt;

                 // Spawn FX:
                hspeed += 2 * right;
                vspeed += orandom(2);
                view_shake_at(x, y, 15);
                instance_create(x, y, PortalClear);
                for(var d = direction; d < direction + 360; d += (360 / 5)){
                	repeat(2) scrFX(x, y, [d + orandom(30), 5], Dust);
                	with(scrWaterStreak(x, y, 0, 0)){
                		motion_set(d + orandom(30), 1 + random(4));
                		image_angle = direction;
                		image_speed *= random_range(0.8, 1.2);
                	}
                }
				sound_play_hit_ext(sndOasisBossDead, 1.2 + random(0.1), 0.4);

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
                depth = 0.1;
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

     // Swimming:
    if(swim > 0){
        swim -= current_time_scale;

		if(swim_mask != -1) mask_index = swim_mask;

         // Jus keep movin:
        if(instance_exists(swim_target)){
            speed += (friction + (swim / 120)) * current_time_scale;

             // Turning:
            var _x = swim_target.x,
                _y = swim_target.y;

            if(in_distance(swim_target, 100)){
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
        	image_angle = 0;
            var _cx = x,
                _cy = y + 7;

             // Debris:
            if((place_meeting(x, y, FloorExplo) && chance(1, 30)) || chance(1, 40)){
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
                        depth = other.depth;
                        //image_blend = make_color_rgb(110, 184, 247);
                    }

                     // Kick up Dust:
                    if(chance(1, 20)){
                        with(instance_create(_x, _y, Dust)){
                            hspeed += other.hspeed / 2;
                            vspeed += other.vspeed / 2;
                            motion_add(_oDir[o] + 180 + (2 * a), other.speed);
                            image_xscale *= .75;
                            image_yscale = image_xscale;
                            depth = other.depth;
                        }
                    }
                }
            }

             // Quakes:
            if(chance(1, 4)) view_shake_at(_cx, _cy, 4);
        }

         // Manual Collisions:
        if(place_meeting(x, y, Player)){
        	with(instances_meeting(x, y, instances_matching_ne(Player, "team", team))){
        		if(place_meeting(x, y, other)) with(other){
        			event_perform(ev_collision, Player);
        		}
        	}
        }
        if(place_meeting(x, y, prop)){
        	with(instances_meeting(x, y, prop)){
        		if(place_meeting(x, y, other)) with(other){
        			event_perform(ev_collision, prop);
        		}
        	}
        }

         // Bolts No:
        with(instances_matching(BoltStick, "target", id)){
	        sound_play_hit(sndCrystalPropBreak, 0.3);
	        repeat(5) with(instance_create(x, y, Dust)){
	            motion_add(random(360), 3);
	        }
        	instance_destroy();
        }

		 // Disable Hitbox:
		if(swim_mask == -1) swim_mask = mask_index;
		mask_index = mskNone;

         // Un-Dive:
        if(swim <= 0){
            swim = 0;
            alarm3 = -1;
            scrRight(direction);
            speed = 0;

            sprite_index = spr_rise;
            image_index = 0;
		    depth = -2;

            mask_index = swim_mask;
            swim_mask = -1;

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

     // Death Taunt:
    if(tauntdelay > 0 && !instance_exists(Player)){
        tauntdelay -= current_time_scale;
        if(tauntdelay <= 0){
            sound_play_pitch(sndOasisBossHalfHP, 0.8);
        }
    }

     // Fish Train:
    if(array_length(fish_train) > 0){
        var _leader = id,
            _broken = false;

        for(var i = 0; i < array_length(fish_train); i++){
            if(_broken){
                with(fish_train[i]) visible = true;
                fish_train[i] = noone;
            }
            else{
                var _fish = fish_train[i],
                    b = false;

                 // Fish Regen:
                if(array_length(fish_swim) > i && fish_swim[i]){
                    if(!instance_exists(_fish) && fish_swim_regen <= 0){
                        fish_swim_regen = 3;

                        _fish = obj_create(_leader.x, _leader.y, (chance(1, 100) ? "Puffer" : BoneFish));

                        with(_fish){
                            kills = 0;
                            creator = other;

                             // Keep Distance:
                            var l = 2,
                                d = _leader.direction + 180;

                            while(in_distance(_leader, 24)){
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

                            if(speed > 0 && chance(1, 3)){
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
    /*if(swim){
    	if("typ" not in other || other.typ != 0){
	        sound_play_pitch(sndCrystalPropBreak, 0.7);
	        sound_play_pitchvol(sndShielderDeflect, 1.5, 0.5);
		    with(other) if("typ" in self){
		        repeat(5) with(instance_create(x, y, Dust)){
		            motion_add(random(360), 3);
		        }
		
		         // Destroy (1 frame delay to prevent errors):
		        if(fork()){
		            wait 0;
		            if(instance_exists(self)) instance_destroy();
		            exit;
		        }
		    }
    	}
    }*/

    //else{
        my_health -= _hitdmg;           // Damage
        nexthurt = current_frame + 6;	// I-Frames
        sound_play_hit(snd_hurt, 0.3);	// Sound

         // Half HP:
        var h = (maxhealth / 2);
        if(in_range(my_health, h - _hitdmg + 1, h)){
        	sound_play(snd_lowh);
        }

         // Knockback:
        if(swim <= 0){
            motion_add(_hitdir, _hitvel);
        }

         // Hurt Sprite:
        var s = [spr_fire, spr_chrg, spr_efir, spr_dive, spr_rise];
        if(array_find_index(s, sprite_index) < 0){
            sprite_index = spr_hurt;
            image_index = 0;
        }
    //}

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
            _cy = y + 7;

        if(h) d3d_set_fog(1, image_blend, 0, 0);
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
        if(h && sprite_index != spr_hurt) d3d_set_fog(1, image_blend, 0, 0);
        draw_self_enemy();
    }

    if(h) d3d_set_fog(0, 0, 0, 0);

#define CoastBoss_alrm1
    alarm1 = 30 + random(20);

    target = instance_nearest(x, y, Player);

    if(instance_exists(target)){
        if(in_distance(target, 160) && (target.reload <= 0 || chance(2, 3))){
            var _targetDir = point_direction(x, y, target.x, target.y);

             // Move Towards Target:
            if((in_distance(target, 64) && chance(1, 2)) || chance(1, 4)){
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
    with(GameCont){
    	area = "coast";
    	subarea = 0;
    	killenemies = true;
    }

     // Boss Win Music:
    with(MusCont) alarm_set(1, 1);


#define FlySpin_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.FlySpin;
		image_index = irandom(image_number - 1);
		image_speed = 0.4 + random(0.1);
		image_xscale = choose(-1, 1);
		depth = -9;

		 // Vars:
		target = noone;
		target_x = 0;
		target_y = 0;

		return id;
	}

#define FlySpin_end_step
	if(target != noone){
		if(instance_exists(target)){
			x = target.x + target_x;
			y = target.y + target_y;
		}
		else instance_destroy();
	}


#define PetVenom_create(_x, _y)
    with(instance_create(_x, _y, CustomProjectile)){
         // Visual:
        sprite_index = spr.VenomFlak;
        mask_index = mskSuperFlakBullet;
        image_speed = 0.4;
        depth = -3;

         // Vars:
        damage = 2;
        force = 2;
        charge = true;
        charge_goal = 1;
        charge_speed = 1/30;
        image_xscale = 0.2;
        image_yscale = 0.2;

        return id;
    }
    
#define PetVenom_step
	 // Charge:
    if(charge){
        if(
        	image_xscale < charge_goal	&&
        	image_yscale < charge_goal	&&
        	instance_exists(creator)	&&
        	creator.visible
        ){
            image_xscale += charge_speed * current_time_scale;
            image_yscale += charge_speed * current_time_scale;

             // Effects:
            sound_play_hit_ext(sndScorpionFire, 0.5 + (1.5 * (image_xscale / charge_goal)), 1.5);
            if(chance_ct(1, 4)){
                var l = random(sprite_width),
                	d = random(360);

                with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), AcidStreak)){
                    motion_set(d + 180, 2);
                    image_angle = direction;
                    image_xscale = 0.8;
                    image_yscale = 0.8;

					 // Variance:
                    if(chance(1, 2)){
                    	sprite_index = spr.AcidPuff;
                    	depth = other.depth - 1;
                    	image_angle += 180;
                    }
                    else depth = other.depth + 1;

					 // Follow Creator:
                    hspeed += other.creator.hspeed;
                    vspeed += other.creator.vspeed;
                }
            }
        }
        else charge = false;
    }

     // Release:
    else{
        image_xscale -= (charge_goal / 7) * current_time_scale;
        image_yscale -= (charge_goal / 7) * current_time_scale;
        if(image_xscale <= 0.2) instance_destroy();
    }

#define PetVenom_end_step
     // Follow Papa:
    if(instance_exists(creator)){
    	x = creator.x + lengthdir_x(10, direction);
    	y = creator.y + lengthdir_y( 6, direction);
        xprevious = x;
        yprevious = y;
    }

#define PetVenom_hit
    if(projectile_canhit_melee(other)){
        projectile_hit(other, damage, force, direction);
        sleep(20);
    }

#define PetVenom_wall
	//

#define PetVenom_destroy
    var _dir = direction,
        _lvl = GameCont.level;

    sleep(10);
    view_shake_max_at(x, y, 10 + (2 * _lvl));

     // Fire:
    for(var i = -1; i <= 1; i++){
        repeat(irandom_range(4, 8) + (2 * (i == 0)) + (2 * _lvl)){
	         // Main Shot:
	        if(i == 0){
	        	with(scrEnemyShoot(EnemyBullet2, _dir + orandom(12), 8 + random(6))){
	        		force = 12;
	        	}
	        }
	        
	         // Side Shots:
	        else{
	            scrEnemyShoot("VenomPellet", _dir + (45 * i) + orandom(16) + (i * random(6 * _lvl)), 4 + random(10));
	        }
        }

         // Effects:
        with(instance_create(x, y, AcidStreak)){
            motion_set(_dir + (45 * i), 4);
            image_angle = direction;
            image_xscale = 1.6;
            image_yscale = 1.0;
        }
    }

     // Sounds:
    sound_play_hit_ext(sndFlyFire,          1.0 + random(0.4), 1);
    sound_play_hit_ext(sndGoldScorpionFire, 1.6 + random(0.4), 1);


#define ScorpionRock_create(_x, _y)
    with(instance_create(_x, _y, CustomProp)){
         // Visual:
        spr_idle = spr.ScorpionRockEnemy;
        spr_hurt = spr.ScorpionRockHurt;
        spr_dead = spr.ScorpionRockDead;
        spr_shadow = shd32;
        spr_shadow_y = -3;

         // Sound:
        snd_hurt = sndHitRock;
        snd_dead = sndPillarBreak;

         // Vars:
        maxhealth = 32;
        size = 1;
        team = 1;
        setup = true;
        friendly = false;

        return id;    
    }

#define ScorpionRock_setup
	setup = false;

	if(friendly){
		spr_idle = spr.ScorpionRockFriend;
		sprite_index = spr_idle;
	}

#define ScorpionRock_step
	if(setup) ScorpionRock_setup();

     // Slow Animation:
    if(sprite_index == spr_idle){
    	var _img = image_index - image_speed,
    		_fac = 0;

        if(_img < 1){
        	_fac = 0.975;
        }
        else{
            if((_img >= 2 && _img < 3) || (_img >= 4 && _img < 5)){
            	_fac = 0.9375;
            }
        }

        image_index -= image_speed_raw * _fac;
    }
    
#define ScorpionRock_death
    repeat(3 + irandom(3))
        with instance_create(x, y, Debris)
            motion_set(random(360), 4 + random(4));
            
    if(friendly){
         // pet time:
        Pet_spawn(x, y, "Scorpion");
    }
    else{
         // Homeowner:
        obj_create(x, y, "BabyScorpion");
         // Light Snack:
        repeat(3) if(chance(1, 2))
            instance_create(x, y, Maggot);
         // Play Date:
        if(chance(1, 100))
            obj_create(x, y, "Spiderling");
         // Possessions:
        pickup_drop(60, 10);
    }


/// Mod Events
#define step
	if(DebugLag) trace_time();

     // Crab Skeletons Drop Bones:
    if(!instance_exists(GenCont)){
	    with(instances_matching([BonePile, BonePileNight], "my_bone_spawner", null)){
	    	my_bone_spawner = obj_create(x, y, "BoneSpawner");
	    	with(my_bone_spawner) creator = other;
	    }
    }

     // Baby Scorpion Spawn:
    with(instances_matching_gt(instances_matching_le(MaggotSpawn, "my_health", 0), "babyscorp_drop", 0)){
    	repeat(babyscorp_drop){
    		obj_create(x, y, "BabyScorpion");
    	}
    }
	
	 // Separate Bones:
    with(instances_matching(WepPickup, "crabbone_splitcheck", null)){
    	if(is_object(wep) && wep_get(wep) == "crabbone" && lq_defget(wep, "ammo", 1) > 1){
            wep.ammo--;
            with(instance_create(x, y, WepPickup)) wep = "crabbone";
        }
        else crabbone_splitcheck = true;
    }
    
	if(DebugLag) trace_time("tedesert_step");

#define draw_bloom
	if(DebugLag) trace_time();

	 // Scorp Pet Attack:
    with(instances_matching(CustomProjectile, "name", "PetVenom")) if(visible){
	    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * (charge ? (image_xscale / charge_goal) : 1) * 0.2);
    }

	if(DebugLag) trace_time("tedesert_draw_bloom");

#define draw_shadows
	if(DebugLag) trace_time();

	 // SharkBoss Loop Train:
    with(instances_matching(CustomEnemy, "name", "CoastBoss")){
        for(var i = 0; i < array_length(fish_train); i++){
            if(array_length(fish_swim) > i && fish_swim[i]){
                with(fish_train[i]){
                    draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
                }
            }
        }
    }

	if(DebugLag) trace_time("tedesert_draw_shadows");


/// Scripts
#define orandom(n)																		return  random_range(-n, n);
#define chance(_numer, _denom)															return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)														return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define surflist_set(_name, _x, _y, _width, _height)									return	mod_script_call_nc("mod", "teassets", "surflist_set", _name, _x, _y, _width, _height);
#define surflist_get(_name)																return	mod_script_call_nc("mod", "teassets", "surflist_get", _name);
#define shadlist_set(_name, _vertex, _fragment)											return	mod_script_call_nc("mod", "teassets", "shadlist_set", _name, _vertex, _fragment);
#define shadlist_get(_name)																return	mod_script_call_nc("mod", "teassets", "shadlist_get", _name);
#define draw_self_enemy()                                                                       mod_script_call(   "mod", "telib", "draw_self_enemy");
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call(   "mod", "telib", "draw_weapon", _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call(   "mod", "telib", "draw_lasersight", _x, _y, _dir, _maxDistance, _width);
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
#define instances_seen(_obj, _ext)                                                      return  mod_script_call_nc("mod", "telib", "instances_seen", _obj, _ext);
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
#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)                        return  mod_script_call_nc("mod", "telib", "path_create", _xstart, _ystart, _xtarget, _ytarget, _wall);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call(   "mod", "telib", "race_get_sprite", _race, _sprite);
#define scrFloorMake(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "scrFloorMake", _x, _y, _obj);
#define scrFloorFill(_x, _y, _w, _h)                                                    return  mod_script_call(   "mod", "telib", "scrFloorFill", _x, _y, _w, _h);
#define scrFloorFillRound(_x, _y, _w, _h)                                               return  mod_script_call(   "mod", "telib", "scrFloorFillRound", _x, _y, _w, _h);
#define unlock_get(_name)                                                               return  mod_script_call_nc("mod", "telib", "unlock_get", _name);
#define unlock_set(_name, _value)                                                               mod_script_call_nc("mod", "telib", "unlock_set", _name, _value);
#define scrUnlock(_name, _text, _sprite, _sound)                                        return  mod_script_call(   "mod", "telib", "scrUnlock", _name, _text, _sprite, _sound);
#define area_get_subarea(_area)                                                         return  mod_script_call(   "mod", "telib", "area_get_subarea", _area);
#define trace_lag()                                                                             mod_script_call(   "mod", "telib", "trace_lag");
#define trace_lag_bgn(_name)                                                                    mod_script_call(   "mod", "telib", "trace_lag_bgn", _name);
#define trace_lag_end(_name)                                                                    mod_script_call(   "mod", "telib", "trace_lag_end", _name);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call_nc("mod", "telib", "instance_rectangle_bbox", _x1, _y1, _x2, _y2, _obj);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   "mod", "telib", "instances_meeting", _x, _y, _obj);
#define array_delete(_array, _index)                                                    return  mod_script_call_nc("mod", "telib", "array_delete", _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call_nc("mod", "telib", "array_delete_value", _array, _value);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "instances_at", _x, _y, _obj);
#define Pet_spawn(_x, _y, _name)                                                        return  mod_script_call(   "mod", "telib", "Pet_spawn", _x, _y, _name);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc("mod", "telib", "scrFX", _x, _y, _motion, _obj);
#define array_combine(_array1, _array2)                                                 return  mod_script_call_nc("mod", "telib", "array_combine", _array1, _array2);
#define player_create(_x, _y, _index)                                                   return  mod_script_call(   "mod", "telib", "player_create", _x, _y, _index);
#define trace_error(_error)                                                                     mod_script_call_nc("mod", "telib", "trace_error", _error);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc("mod", "telib", "sleep_max", _milliseconds);
#define array_clone_deep(_array)                                                        return  mod_script_call_nc("mod", "telib", "array_clone_deep", _array);
#define lq_clone_deep(_obj)                                                             return  mod_script_call_nc("mod", "telib", "lq_clone_deep", _obj);
#define array_exists(_array, _value)                                                    return  mod_script_call_nc("mod", "telib", "array_exists", _array, _value);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc("mod", "telib", "wep_merge", _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call(   "mod", "telib", "wep_merge_decide", _hardMin, _hardMax);
#define array_shuffle(_array)                                                           return  mod_script_call_nc("mod", "telib", "array_shuffle", _array);
#define view_shift(_index, _dir, _pan)                                                          mod_script_call_nc("mod", "telib", "view_shift", _index, _dir, _pan);
#define stat_get(_name)                                                                 return  mod_script_call_nc("mod", "telib", "stat_get", _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc("mod", "telib", "stat_set", _name, _value);
#define option_get(_name, _default)                                                     return  mod_script_call_nc("mod", "telib", "option_get", _name, _default);
#define option_set(_name, _value)                                                               mod_script_call_nc("mod", "telib", "option_set", _name, _value);
#define sound_play_hit_ext(_snd, _pit, _vol)                                            return  mod_script_call(   "mod", "telib", "sound_play_hit_ext", _snd, _pit, _vol);
#define area_get_secret(_area)                                                          return  mod_script_call_nc("mod", "telib", "area_get_secret", _area);
#define area_get_underwater(_area)                                                      return  mod_script_call_nc("mod", "telib", "area_get_underwater", _area);
#define path_shrink(_path, _wall, _skipMax)                                             return  mod_script_call_nc("mod", "telib", "path_shrink", _path, _wall, _skipMax);
#define path_direction(_x, _y, _path, _wall)                                            return  mod_script_call_nc("mod", "telib", "path_direction", _x, _y, _path, _wall);
#define rad_drop(_x, _y, _raddrop, _dir, _spd)                                          return  mod_script_call_nc("mod", "telib", "rad_drop", _x, _y, _raddrop, _dir, _spd);
#define rad_path(_inst, _target)                                                        return  mod_script_call_nc("mod", "telib", "rad_path", _inst, _target);
#define area_get_name(_area, _subarea, _loop)                                           return  mod_script_call_nc("mod", "telib", "area_get_name", _area, _subarea, _loop);
#define draw_text_bn(_x, _y, _string, _angle)                                                   mod_script_call_nc("mod", "telib", "draw_text_bn", _x, _y, _string, _angle);
#define TopObject_create(_x, _y, _obj, _spawnDir, _spawnDis)                            return  mod_script_call_nc("mod", "telib", "TopObject_create", _x, _y, _obj, _spawnDir, _spawnDis);