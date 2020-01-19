#define init
    spr = mod_variable_get("mod", "teassets", "spr");
    snd = mod_variable_get("mod", "teassets", "snd");
    mus = mod_variable_get("mod", "teassets", "mus");
    sav = mod_variable_get("mod", "teassets", "sav");
    
    DebugLag = false;

	 // Surfaces:
	surfAnglerTrail = surflist_set("AnglerTrail", 0, 0, 0, 0);
	surfAnglerClear = surflist_set("AnglerClear", 0, 0, 0, 0);
	with(surfAnglerTrail){
		if("frame" not in self) frame = 0;
		reset = true;
	}
    
     // Pit Grid:
	global.pit_grid = mod_variable_get("area", "trench", "pit_grid");

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

#macro surfAnglerTrail	global.surfAnglerTrail
#macro surfAnglerClear	global.surfAnglerClear

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
        var _water = area_get_underwater(GameCont.area);
		snd_hurt = sndFireballerHurt;
		snd_dead = (_water ? sndOasisDeath : choose(sndFrogEggDead, sndFrogEggOpen2));

		 // Vars:
		//mask_index = mskFrogQueen;
		maxhealth = 50;
		raddrop = 25;
		meleedamage = 4;
		size = 3;
		walk = 0;
		walkspeed = 0.6;
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
    enemy_walk(walkspeed, maxspeed + (8 * (ammo >= 0 && walk > 0)));

     // Animate:
    if(hiding){
        sprite_index = spr_appear;
        if(image_index > 0){
            image_index -= min(image_index, image_speed * 2 * current_time_scale);
        }
    }
    else if(sprite_index != spr_appear || anim_end){
        if(sprite_index == spr_appear) sprite_index = spr_idle;
        sprite_index = enemy_sprite;
    }

	 // Charging:
	if(!hiding && ammo >= 0){
		speed -= (speed * 0.15) * current_time_scale;
		surfAnglerTrail.frame = current_frame + 30;
	}

#define Angler_draw
    var h = (sprite_index == spr_appear && nexthurt > current_frame + 3);
    if(h) draw_set_fog(true, image_blend, 0, 0);
    draw_self_enemy();
    if(h) draw_set_fog(false, 0, 0, 0);

#define Angler_alrm1
    alarm1 = 6 + irandom(6);
    enemy_target(x, y);

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
            scrWalk((in_sight(target) ? point_direction(x, y, target.x, target.y) : direction) + orandom(40), 5);
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
            scrWalk(direction + 180, 8);
        }

         // Normal AI:
        else{
            alarm1 = 20 + irandom(20);

             // Move Toward Player:
            if(in_sight(target) && in_distance(target, 96)){
                scrWalk(point_direction(x, y, target.x, target.y) + orandom(20), [25, 50]);
                if(chance(1, 2)){
                	ammo = irandom_range(1, 3);
                }
            }

             // Wander:
            else{
            	 // Go to Nearest Non-Pit Floor:
        		var f = instance_nearest_array(x - 8 + (hspeed * 4), y - 8 + (vspeed * 4), instances_matching_ne(Floor, "sprite_index", spr.FloorTrenchB));
            	if(instance_exists(f)){
            		direction = point_direction(x, y, f.x, f.y);
            	}

            	scrWalk(direction + orandom(30), [20, 50]);

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

	 // Appear:
    if(my_health > 0 && hiding) scrAnglerAppear();

     // Hurt Sprite:
    else if(sprite_index != spr_appear){
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
        with(corpse_drop(direction + orandom(10), speed + random(2))){
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
    with(instances_matching(object_index, "name", name)){
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
        type = irandom(2);
        if(type == 0 && crown_current == crwn_guns) type = 1;
        if(type == 1 && crown_current == crwn_life) type = 0;
        spr_idle = spr.EelIdle[type];
        spr_walk = spr_idle;
        spr_hurt = spr.EelHurt[type];
        spr_dead = spr.EelDead[type];
        spr_tell = spr.EelTell[type];
        hitid = [spr_idle, "EEL"];
        spr_shadow = shd24;
        image_index = random(image_number - 1);
        depth = -2;

         // Sound:
        var _water = area_get_underwater(GameCont.area);
        snd_hurt = (_water ? sndOasisHurt  : sndHitFlesh);
        snd_dead = (_water ? sndOasisDeath : sndFastRatDie);
        snd_mele = (_water ? sndOasisMelee : sndMaggotBite);

         // Vars:
        mask_index = mskRat;
        maxhealth = 12;
        raddrop = 2;
        meleedamage = 2;
        size = 1;
        walk = 0;
        walkspeed = 1.2;
        maxspeed = 3.4;
        pitDepth = 0;
        direction = random(360);
        arc_inst = noone;
        arcing = 0;
        wave = random(100);
        elite = 0;
        ammo = 0;
        canmelee_last = canmelee;

         // Alarms:
        alarm1 = 15 + random(45);

        return id;
    }

#define Eel_step
	 // Arcing:
	if(arc_inst != noone){
		var _ax = x,
			_ay = y;
			
		if(instance_exists(arc_inst)){
			_ax = arc_inst.x;
			_ay = arc_inst.y;
		}
		else arcing = -1;
		
	    if(
	    	arcing >= 0											&&
	    	point_distance(x, y, _ax, _ay) < arc_inst.arc_dis	&&
	    	!collision_line(x, y, _ax, _ay, Wall, false, false)
	    ){
	         // Start Arcing:
	        if(arcing < 1){
	            arcing += 0.15 * current_time_scale;
	
	            if(current_frame_active){
	                var _dis = random(point_distance(x, y, _ax, _ay)),
	                    _dir = point_direction(x, y, _ax, _ay);
	
	                with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), choose(PortalL, PortalL, LaserCharge))){
	                    motion_add(random(360), 1);
	                    alarm0 = 8;
	                }
	            }
	
	             // Arced:
	            if(arcing >= 1){
	                sound_play_pitch(sndLightningHit, 2);
	
	                 // Color:
	                if(arc_inst.type <= 2){
	                    type = max(arc_inst.type, 0);
	                    spr_idle = spr.EelIdle[type];
	                    spr_walk = spr_idle;
	                    spr_hurt = spr.EelHurt[type];
	                    spr_dead = spr.EelDead[type];
	                    spr_tell = spr.EelTell[type];
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
	            if(arc_inst.type > 2) elite = 30;
	            with(arc_inst){
	            	lightning_connect(other.x, other.y, x, y, ((other.elite > 0) ? 16 : 12) * sin(other.wave / 30), true);
	            }
	        }
	    }
	
		 // Stop Arcing:
	    else{
	    	with(arc_inst){
	    		arc_num--;
	            repeat(2){
	                var _dis = random(point_distance(x, y, other.x, other.y)),
	                    _dir = point_direction(x, y, other.x, other.y);
	                    
	                with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), PortalL)){
	                    motion_add(random(360), 1);
	                }
	            }
	    	}
	        arc_inst = noone;
	        arcing = 0;
	    }
	}
	else arcing = 0;

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
        	with(enemy_shoot(EnemyLightning, _dir, 0)){
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
    enemy_target(x, y);
    
	 // Search for New Jelly:
	if(in_distance(target, 160)){
		if(arc_inst == noone){
	    	var _disMax = 1000000;
	    	with(instances_matching(CustomEnemy, "name", "Jelly", "JellyElite")){
	    		if(arc_num < arc_max){
		    		var _dis = point_distance(x, y, other.x, other.y);
		    		if(_dis < arc_dis && _dis < _disMax){
		    			if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
			    			_disMax = _dis;
			    			other.arc_inst = id;
		    			}
		    		}
	    		}
	    	}
	    	with(arc_inst) arc_num++;
		}
	}
	else arcing = -1;
	
	 // When you walking:
	if(in_sight(target)){
		scrWalk(point_direction(x, y, target.x, target.y) + orandom(20), [23, 30]);
	}
	else{
		scrWalk(direction + orandom(30), [17, 30]);
	}
	
	 // Stay Near Papa:
	if(instance_exists(arc_inst) && (arcing < 1 || !in_distance(arc_inst, arc_inst.arc_dis - 16))){
		direction = point_direction(x, y, arc_inst.x, arc_inst.y) + orandom(10);
	}

#define Eel_death
    if(elite){
        spr_dead = spr.EeliteDead;

         // Death Lightning:
        repeat(2) with(enemy_shoot(EnemyLightning, random(360), 0.5)){
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
    else switch(type){
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


#define ElectroPlasma_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visuals:
		sprite_index = spr.ElectroPlasma;
		image_speed = 0.4;
		image_index = 1 - image_speed;
		depth = -4;
		
		 // Vars:
		mask_index = mskEnemyBullet1;
		damage = 3;
		force = 3;
		typ = 2;
		wave = irandom(90);
		tether = 0;
		tether_x = x;
		tether_y = y;
		tether_inst = noone;
		tether_range = 80;
		setup = true;

		return id;
	}
	
#define ElectroPlasma_setup
	setup = false;

	 // Not Tethered:
	if(tether == 0 && tether_inst == noone){
		tether = -1;
	}

	 // Laser Brain:
	if(instance_is(creator, Player)){
		var _brain = skill_get(mut_laser_brain);
		image_xscale += 0.15 * _brain;
		image_yscale += 0.15 * _brain;
		tether_range += 40 * _brain;
	}

#define ElectroPlasma_anim
	if(instance_exists(self)) image_index = 1;

#define ElectroPlasma_step
	wave += current_time_scale;

	if(setup) ElectroPlasma_setup();

	 // Tether:
	if(tether >= 0){
		if(instance_exists(tether_inst)){
			tether_x = tether_inst.x + tether_inst.hspeed_raw;
			tether_y = tether_inst.y + tether_inst.vspeed_raw;
		}
	
		var _x1 = x + hspeed_raw,
			_y1 = y + vspeed_raw,
			_x2 = tether_x,
			_y2 = tether_y;
	
		if(
			(tether_inst == noone || instance_exists(tether_inst))
			&&
			point_distance(_x1, _y1, _x2, _y2) < tether_range
			&&
			!collision_line(_x1, _y1, _x2, _y2, Wall, false, false)
		){
			 // Initialize Tether:
	        if(tether < 1){
	            tether += 0.2 * current_time_scale;
	
	            if(current_frame_active){
	                var _dis = random(point_distance(_x1, _y1, _x2, _y2)),
	                    _dir = point_direction(_x1, _y1, _x2, _y2);
	
	                with(instance_create(_x1 + lengthdir_x(_dis, _dir), _y1 + lengthdir_y(_dis, _dir), choose(PortalL, LaserCharge))){
	                    if(object_index == LaserCharge){
	                        sprite_index = spr.ElectroPlasmaTether;
	                        image_angle = random(360);
	                        alarm0 = 4 + random(4);
	                    }
	                    motion_add(random(360), 1);
	                }
	            }
	
	             // Tethered:
	            if(tether >= 1){
	                sound_play_pitch(sndLightningHit, 2);
	
	                 // Laser Brain FX:
	                if(skill_get(mut_laser_brain)){
	                    with(instance_create(_x1, _y1, LaserBrain)){
	                        image_angle = _dir + orandom(10);
	                        creator = other.creator;
	                    }
	                    with(instance_create(_x2, _y2, LaserBrain)){
	                        image_angle = _dir + orandom(10) + 180;
	                        creator = other.creator;
	                    }
	                }
	            }
	        }
	
			 // Tethering:
	        else{
				var	_d1 = direction,
					_d2 = direction;
	
				if(instance_exists(tether_inst)){
					_d2 = tether_inst.direction;
				}
	
				with(lightning_connect(_x1, _y1, _x2, _y2, (point_distance(_x1, _y1, _x2, _y2) / 4) * sin(wave / 90), false)){
					damage = floor(other.damage * 7/3);
					sprite_index = spr.ElectroPlasmaTether;
					depth = -3;
				
					 // Effects:
					if(chance_ct(1, 16)) with(instance_create(x, y, PlasmaTrail)){
						sprite_index = spr.ElectroPlasmaTrail;
						motion_set(lerp(_d1, _d2, random(1)), 1);
					}
				}
	        }
		}
	
		 // Untether FX:
	    else ElectroPlasma_untether();
	}

	 // Trail:
	if(chance_ct(1, 8)){
		with(instance_create(x + orandom(6), y + orandom(6), PlasmaTrail)){
			sprite_index = spr.ElectroPlasmaTrail;
		}
	}
	
	 // Goodbye:
	if(image_xscale <= 0.8 || image_yscale <= 0.8) instance_destroy();

#define ElectroPlasma_hit
	if(setup) ElectroPlasma_setup();

	var p = instance_is(other, Player);
	if(projectile_canhit(other) && (!p || projectile_canhit_melee(other))){
		projectile_hit(other, damage);
		
		 // Effects:
		sleep_max(10);
		view_shake_max_at(x, y, 2);
		
		 // Slow:
		x -= hspeed * 0.8;
		y -= vspeed * 0.8;
		
		 // Shrink:
		image_xscale -= 0.05;
		image_yscale -= 0.05;
	}

#define ElectroPlasma_wall
	image_xscale -= 0.03;
	image_yscale -= 0.03;

#define ElectroPlasma_destroy
	enemy_shoot("ElectroPlasmaImpact", direction, 0);
	ElectroPlasma_untether();

#define ElectroPlasma_untether
	if(tether > 0){
        tether = 0;
        sound_play_pitchvol(sndLightningReload, 0.7 + random(0.2), 0.5);

		var _x1 = x + hspeed_raw,
			_y1 = y + vspeed_raw,
			_x2 = tether_x,
			_y2 = tether_y;

		with(lightning_connect(_x1, _y1, _x2, _y2, (point_distance(_x1, _y1, _x2, _y2) / 4) * sin(wave / 90), false)){
			with(instance_create(x, y, BoltTrail)){
				sprite_index = spr.ElectroPlasmaTether;
				image_index  = other.image_index;
				image_xscale = other.image_xscale;
				image_yscale = other.image_yscale;
				image_angle  = other.image_angle;
				image_blend  = other.image_blend;
				image_alpha  = other.image_alpha;
				hspeed       = other.hspeed;
				vspeed       = other.vspeed;
				
				with(other) if(!place_meeting(_x1, _y1, Wall) && !place_meeting(_x2, _y2, Wall)){
					other.direction = direction;
					other.speed = max(0, speed - 1);
				}
				image_yscale -= random(0.4);
				depth = -3;
			}
			instance_delete(id);
		}
    }


#define ElectroPlasmaImpact_create(_x, _y)
	with(instance_create(_x, _y, PlasmaImpact)){
		 // Visual:
		sprite_index = spr.ElectroPlasmaImpact;

		 // Vars:
		mask_index = mskBullet1;
		damage = 2;

		 // Effects:
		repeat(1 + irandom(1)){
			instance_create(x + orandom(6), y + orandom(6), PortalL).depth = -6;
		}

		 // Sounds:
		sound_play_hit(sndPlasmaHit,	 0.4);
		sound_play_hit(sndGammaGutsProc, 0.4);

		return id;
	}


#define Jelly_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
         // Visual:
        type = irandom(2);
        if(type == 0 && GameCont.crown == crwn_guns) type = 1;
        if(type == 1 && GameCont.crown == crwn_life) type = 0;
        spr_idle = spr.JellyIdle[type];
        spr_walk = spr_idle;
        spr_hurt = spr.JellyHurt[type];
        spr_dead = spr.JellyDead[type];
        spr_fire = spr.JellyFire;
        spr_shadow = shd24;
        spr_shadow_y = 6;
        hitid = [spr_idle, "JELLY"];
        depth = -2;

         // Sound:
        var _water = area_get_underwater(GameCont.area);
        snd_hurt = (_water ? sndOasisHurt  : sndHitFlesh);
        snd_dead = (_water ? sndOasisDeath : sndBigMaggotDie);
        snd_mele = sndOasisMelee;

         // Vars:
        mask_index = mskLaserCrystal;
        maxhealth = 52; // (type == 3 ? 72 : 52);
        raddrop = 16; // (type == 3 ? 38 : 16);
        size = 2;
        walk = 0;
        walkspeed = 1;
        maxspeed = 3.4;
        meleedamage = 4;
        direction = random(360);
        arc_num = 0;
        arc_max = 3;
        arc_dis = 112;

         // Alarms:
        alarm1 = 40 + irandom(20);

		 // NTTE:
		ntte_anim = false;
		ntte_walk = false;

        return id;
    }

#define Jelly_step
	 // Animate:
    if(sprite_index != spr_fire){
    	sprite_index = enemy_sprite;
    }

     // Movement:
    var _maxSpd = clamp(0.07 * walk * current_time_scale, 1, maxspeed); // arbitrary values, feel free to fiddle
    enemy_walk(walkspeed, _maxSpd);

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
    enemy_target(x, y);

     // Always movin':
    scrWalk(direction, alarm1);

    if(in_sight(target)){
        var _targetDir = point_direction(x, y, target.x, target.y);

         // Steer towards target:
        motion_add(_targetDir, 0.4);
    	scrRight(direction);

         // Attack:
        if(chance(1, 3) && in_distance(target, [32, 256])){
            alarm1 += 30;

             // Shoot lightning disc:
            if(type > 2){
                for(var a = _targetDir; a < _targetDir + 360; a += (360 / 3)){
                    with(enemy_shoot("LightningDiscEnemy", a, 8)){
                        shrink /= 2; // Last twice as long
                    }
                }
            }
            else enemy_shoot("LightningDiscEnemy", _targetDir, 8);

             // Effects:
            sound_play_hit(sndLightningHit, 0.25);
            sound_play_pitch(sndLightningCrystalCharge,0.8);
            sprite_index = spr_fire;
            alarm2 = 30;
        }
    }

#define Jelly_alrm2
    sprite_index = spr_walk;

#define Jelly_death
    if(type <= 2) pickup_drop(50, 2);
    else pickup_drop(100, 10);


#define JellyElite_create(_x, _y)
    with(obj_create(_x, _y, "Jelly")){
         // Visual:
        type = 3;
        spr_idle = spr.JellyIdle[type];
        spr_walk = spr_idle;
        spr_hurt = spr.JellyHurt[type];
        spr_dead = spr.JellyDead[type];
        spr_fire = spr.JellyEliteFire;

         // Sound:
        var _water = area_get_underwater(GameCont.area);
        snd_hurt = sndLightningCrystalHit;
        snd_dead = (_water ? sndOasisDeath : sndLightningCrystalDeath);

         // Vars:
        raddrop *= 2;
        arc_max = 5;
        arc_dis = 144;

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


#define LightningDisc_create(_x, _y)
    with(instance_create(_x, _y, CustomProjectile)){
         // Visual:
        sprite_index = sprLightning;
        image_speed = 0.4;
        depth = -3;

         // Vars:
        mask_index = mskWepPickup;
        rotspeed = random_range(10, 20) * choose(-1, 1);
        rotation = 0;
        radius = 12;
        charge = 1;
        charge_spd = 2;
        ammo = 10;
        typ = 0;
        shrink = 1/160;
        maxspeed = 2.5;
        is_enemy = false;
        image_xscale = 0;
        image_yscale = 0;
        stretch = 1;
        super = -1; //describes the minimum size of the ring to split into more rings, -1 = no splitting
        creator_follow = true;
        roids = false;
        setup = true;
        
        return id;
    }

#define LightningDisc_setup
	setup = false;
	
	 // Laser Brain:
	if(!is_enemy){
		var _skill = skill_get(mut_laser_brain);
		charge *= power(1.2, _skill);
		stretch *= power(1.2, _skill);
        image_speed *= power(0.75, _skill);
	}

#define LightningDisc_step
    rotation += rotspeed * current_time_scale;
    
     // Setup:
    if(setup) LightningDisc_setup();
    
     // Charge Up:
    if(image_xscale < charge){
    	var s = charge_spd;
    	if(instance_is(creator, Player)) with(creator){
    		s *= reloadspeed;
    		s *= 1 + ((1 - (my_health / maxhealth)) * skill_get(mut_stress));
    	}
    	
        image_xscale += (charge / 20) * s * current_time_scale;
        image_yscale = image_xscale;
        
        if(creator_follow){
            if(instance_exists(creator)){
                x = creator.x;
                y = creator.y - (4 * roids);
                
	            if("gunangle" in creator){
	            	direction = creator.gunangle;
	            	
	                var _big = (charge >= 2.5);
	                if(_big){
	                    x += hspeed;
	                    y += vspeed;
	                }
                
	                 // Attempt to Unstick from Wall:
	                if(place_meeting(x, y, Wall)){
	                    if(!_big){
	                        var w = instance_nearest(x, y, Wall),
	                            _dis = 2,
	                            _dir = round(point_direction(w.x + 8, w.y + 8, x, y) / 90) * 90;
	                            
	                        while(place_meeting(x, y, w)){
	                            x += lengthdir_x(_dis, _dir);
	                            y += lengthdir_y(_dis, _dir);
	                        }
	                    }
	                    
	                     // Big boy:
	                    else with(Wall) if(place_meeting(x, y, other)){
	                        instance_create(x, y, FloorExplo);
	                        instance_destroy();
	                    }
	                }
	                
	                if(!_big){
	                    move_contact_solid(direction, speed);
	                }
	            }
                
                 // Chargin'
                var _kick = (roids ? "bwkick" : "wkick");
                if(_kick in creator){
                	variable_instance_set(creator, _kick, 5 * (image_xscale / charge));
                }
            }
        }

         // Stay Still:
        xprevious = x;
        yprevious = y;
        x -= hspeed_raw;
        y -= vspeed_raw;

         // Effects:
        sound_play_pitch(sndLightningHit, (image_xscale / charge));
        if(!is_enemy){
        	sound_play_pitch(sndPlasmaReload, (image_xscale / charge) * 3);
        	view_shake_max_at(x, y, 6 * image_xscale);
        }
    }
    else{
        if(charge > 0){
             // Just in case:
            if(place_meeting(x, y, Wall)){
                with(Wall) if(place_meeting(x, y, other)){
                    instance_create(x, y, FloorExplo);
                    instance_destroy();
                }
            }

             // Creator Stuff:
            with(creator){
                var	_kick = (other.roids ? "bwkick" : "wkick");
                if(_kick in self) variable_instance_set(id, _kick, -4);
                
                 // Player Papa:
                if(instance_is(self, Player)){
                	weapon_post(wkick, 16 * other.charge, 8 * other.charge);
                	other.direction += orandom(6 * accuracy);
                }
            }

             // Effects:
            sound_play_pitch(sndLightningCannonEnd, (3 + random(1)) / charge);
            with(instance_create(x, y, GunWarrantEmpty)) image_angle = other.direction;
            if(!is_enemy && skill_get(mut_laser_brain)){
                sound_play_pitch(sndLightningPistolUpg, 0.8);
            }

            charge = 0;
        }

         // Random Zapp:
        if(!is_enemy){
            if(chance_ct(1, 30)){
                with(instance_nearest_array(x, y, instances_matching_ne(hitme, "team", team, 0))){
                    if(!place_meeting(x, y, other) && distance_to_object(other) < 32){
                        with(other) LightningDisc_hit();
                    }
                }
            }
        }
    }

     // Slow:
    var _maxSpd = maxspeed;
    if(charge <= 0 && speed > _maxSpd) speed -= current_time_scale;

     // Particles:
    if(current_frame_active){
        if(chance(image_xscale, 30) || (charge <= 0 && speed > _maxSpd && chance(image_xscale, 3))){
            var d = random(360),
                r = random(radius),
                _x = x + lengthdir_x(r * image_xscale, d),
                _y = y + lengthdir_y(r * image_yscale, d);

            with(instance_create(_x, _y, PortalL)){
                motion_add(random(360), 1);
                if(other.charge <= 0){
                    hspeed += other.hspeed;
                    vspeed += other.vspeed;
                }
            }
        }

         // Super Ring Split FX:
        if(super >= 0 && charge <= 0 && image_xscale < super + 1){
            if(chance(1, 12 * (image_xscale - super))){
                 // Particles:
                var _ang = random(360);
                repeat(irandom(2)){
                    with(instance_create(x + lengthdir_x((image_xscale * 17) + hspeed, _ang), y + lengthdir_y((image_yscale * 17) + vspeed, _ang), LightningSpawn)){
                        image_angle = _ang;
                        image_index = 1;
                        with(instance_create(x, y, PortalL)) image_angle  = _ang;
                    }
                }
                view_shake_at(x, y, 3);

                 // Sound:
                var _pitchMod = 1 / (4 * ((image_xscale - super) + .12));
                    _vol = 0.1 / ((image_xscale - super) + 0.2);
                    
                sound_play_pitchvol(sndGammaGutsKill, random_range(1.8, 2.5) * _pitchMod, min(_vol, 0.7));
                sound_play_pitchvol(sndLightningHit,  random_range(0.8, 1.2) * _pitchMod, min(_vol, 0.7) * 2);

                // Displacement:
                speed -= speed_raw * 0.02;
                x += orandom(3) * _pitchMod * current_time_scale;
                y += orandom(3) * _pitchMod * current_time_scale;
            }
        }
    }

     // Shrink:
    if(charge <= 0){
        var s = shrink * current_time_scale;
        image_xscale -= s;
        image_yscale -= s;

         // Super lightring split:
        if(super >= 0 && (image_xscale <= super || image_yscale <= super)){
            instance_destroy();
            exit;
        }

         // Normal poof:
        if(image_xscale <= 0 || image_yscale <= 0){
            sound_play_hit(sndLightningHit, 0.5);
            instance_create(x, y, LightningHit);
            instance_destroy();
        }
    }

#define LightningDisc_hit
    if(projectile_canhit_melee(other)){
         // Slow:
        if(image_xscale >= charge){
	        x -= hspeed;
	        y -= vspeed;
	        direction = point_direction(x, y, other.x, other.y) + orandom(10);
        }

         // Electricity Field:
        var _tx = other.x,
            _ty = other.y,
            d = random(360),
            r = radius,
            _x = x + lengthdir_x(r * image_xscale, d),
            _y = y + lengthdir_y(r * image_yscale, d);

        with(instance_create(_x, _y, (is_enemy ? EnemyLightning : Lightning))){
            ammo = min(30, other.image_xscale + random(other.image_xscale * 2));
            direction = point_direction(x, y, _tx, _ty) + orandom(12);
            image_angle = direction;
            team = other.team;
            hitid = other.hitid;
            creator = other.creator;
            event_perform(ev_alarm, 0);
        }

         // Effects:
        with(other) instance_create(x, y, Smoke);
        sound_play(sndLightningHit);
    }

#define LightningDisc_wall
    var _hprev = hspeed,
        _vprev = vspeed;

    if(image_xscale >= charge && (image_xscale < 2.5 || image_yscale < 2.5)){
         // Bounce:
        if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
        if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;

        with(other){
             // Bounce Effect:
            var _x = x + 8,
                _y = y + 8,
                _dis = 8,
                _dir = point_direction(_x, _y, other.x, other.y);

            instance_create(_x + lengthdir_x(_dis, _dir), _y + lengthdir_y(_dis, _dir), PortalL);
            sound_play_hit(sndLightningHit, 0.2);
        }
    }

     // Too powerful to b contained:
    if(image_xscale > 1.2 || image_yscale > 1.2){
        with(other){
            instance_create(x, y, FloorExplo);
            instance_destroy();
        }
        with(Wall) if(place_meeting(x - _hprev, y - _vprev, other)){
            instance_create(x, y, FloorExplo);
            instance_destroy();
        }
    }

#define LightningDisc_destroy
    if(super >= 0){
         // Effects:
        sleep(80);
        sound_play_pitchvol(sndLightningPistolUpg, 0.7,               0.4);
        sound_play_pitchvol(sndLightningPistol,    0.7,               0.6);
        sound_play_pitchvol(sndGammaGutsKill,      0.5 + random(0.2), 0.7);

         // Disc Split:
        var _ang = random(360);
        for(var a = _ang; a < _ang + 360; a += (360 / 5)){
            with(obj_create(x, y, "LightningDisc")){
                motion_add(a, 10);
                charge = other.image_xscale / 1.2;

                 // Insta-Charge:
                image_xscale = charge * 0.9;
                image_yscale = charge * 0.9;

                team = other.team;
                creator = other.creator;
                creator_follow = false;
            }

             // Clear Walls:
            var o = 24;
            instance_create(x + lengthdir_x(o, a), y + lengthdir_y(o, a), PortalClear);
        }
    }

#define LightningDisc_draw
    scrDrawLightningDisc(sprite_index, image_index, x, y, ammo, radius, stretch, image_xscale, image_yscale, image_angle + rotation, image_blend, image_alpha);

#define scrDrawLightningDisc(_spr, _img, _x, _y, _num, _radius, _stretch, _xscale, _yscale, _angle, _blend, _alpha)
    var _off = (360 / _num),
        _ysc = _stretch * (0.5 + random(1));

    for(var d = _angle; d < _angle + 360; d += _off){
        var _ro = random(2),
            _rx = (_radius * _xscale) + _ro,
            _ry = (_radius * _yscale) + _ro,
            _x1 = _x + lengthdir_x(_rx, d),
            _y1 = _y + lengthdir_y(_ry, d),
            _x2 = _x + lengthdir_x(_rx, d + _off),
            _y2 = _y + lengthdir_y(_ry, d + _off),
            _xsc = point_distance(_x1, _y1, _x2, _y2) / 2,
            _ang = point_direction(_x1, _y1, _x2, _y2);

        draw_sprite_ext(_spr, _img, _x1, _y1, _xsc, _ysc, _ang, _blend, _alpha);
    }


#define LightningDiscEnemy_create(_x, _y)
    with(obj_create(_x, _y, "LightningDisc")){
         // Visual:
        sprite_index = sprEnemyLightning;

         // Vars:
        is_enemy = true;
        maxspeed = 2;
        radius = 16;
        charge_spd = 1.4;

        return id;
    }


#define PitSpark_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.PitSpark[irandom(array_length(spr.PitSpark) - 1)];
		image_angle = random(360);
		image_speed = 0.4;
		depth = 5;
		
		 // Vars:
		mask_index = mskReviveArea;
		dark = irandom(1);
		tentacle = {};
		tentacle_visible = true;
		with(tentacle){
			scale = 1 + (0.1 * GameCont.loops);//random_range(1, 1.2);
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
		spr_bite = spr.PitSquidMawBite;
		spr_fire = spr.PitSquidMawSpit;
		hitid = [spr_fire, "PIT SQUID"];
		
         // Sounds:
        snd_hurt = sndBigDogHit;
        snd_dead = sndNothing2Hurt;
        snd_lowh = sndNothing2HalfHP;
        
         // Vars:
        posx = x;
        posy = y;
        x = 0;
        y = 0;
        friction = 0.01;
        mask_index = mskNone;
        meleedamage = 8;
        maxhealth = boss_hp(400);
        tauntdelay = 60;
        intro = false;
        intro_pitbreak = false;
        raddrop = 50;
        size = 5;
        canfly = true;
        target = noone;
        bite = 0;
        sink = false;
        pit_height = 1;
        spit = 0;
        ammo = 0;
        gunangle = random(360);
        electroplasma_side = choose(-1, 1);
        electroplasma_last = noone;
		laser = 0;
		laser_charge = 0;
		rise_delay = 0;
		
         // Eyes:
        eye = [];
        eye_dir = random(360);
        eye_dir_speed = 0;
        eye_dis = 0;
        eye_laser = 0;
        eye_laser_delay = 0;
        repeat(3){
            array_push(eye, {
                x : 0,
                y : 0,
                dis : 5,
                dir : random(360),
                blink : true,
                blink_img : 0,
                my_laser : noone
            });
        }
        
         // Loop
        image_xscale += (0.1 * GameCont.loops);
        image_yscale = image_xscale;
        
         // Alarms:
        alarm1 = 90;
        alarm2 = 90;
        alarm3 = random_range(1, 30);

        return id;
    }

#define PitSquid_step
	var _eyeDisGoal = 0;

     // Pit Z Movement:
    if(sink || rise_delay > 0){
		rise_delay -= current_time_scale;
		
         // Quickly Sink:
        var t = (instance_exists(Player) ? 0.5 : 0);
        if(pit_height > t){
	        pit_height += ((t - pit_height) / (instance_exists(Player) ? 4 : 8)) * current_time_scale;
	        if(abs(t - pit_height) < 0.05) pit_height = t;
	        with(eye) blink = true;
        }

         // Start Rising:
        /*
        if(pit_height <= 0.5){
            sink = false;
            pit_height = -random_range(0.2, 0.5);
        }
        */
        
		 // Intro Dim Music:
		if(!intro){
			var _mus = lq_defget(mod_variable_get("mod", "ntte", "sound_current"), "mus", { vol : 1 });
			if(_mus.vol > 0.3) _mus.vol -= 0.01 * current_time_scale;
		}
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
        	else if(((1 - bite) * sprite_get_number(spr_bite)) >= 6){
	            pit_height += 0.1 * current_time_scale;
	
	             // Reached Top of Pit:
	            if(pit_height >= 1){
	                pit_height = 1;
	                speed /= 3;
	                alarm1 = 10 + random(10);
	                alarm2 = 30 + random(10);
	            	with(eye) blink = true;
	                view_shake_at(posx, posy, 30);
	                sound_play(sndOasisExplosion);
	                
					 // Intro:
				    if(!intro){
				        intro = true;
				        intro_pitbreak = true;
						boss_intro(name, sndBigDogIntro, mus.PitSquid);
						sound_play_pitchvol(sndNothing2Taunt, 0.7, 0.8);
						view_shake_at(x, y, 30);
						
						 // Fix game being bad:
						if(fork()){
							wait 2;
							with(instance_nearest(0, 0, Wall)) event_perform(ev_create, 0);
							exit;
						}
				    }
	            }
        	}
        }
    }

     // Sinking/Rising FX:
    if(pit_height > 0.5 && pit_height < 1 && current_frame_active){
        instance_create(posx + orandom(32), posy + orandom(32), Smoke);
        view_shake_at(posx, posy, 4);
    }

     // Movement:
    if(eye_laser > 0) speed = 0;
    if(speed > 0){
        eye_dir_speed += (speed / 10) * current_time_scale;
        direction += sin(current_frame / 20) * current_time_scale;

         // Effects:
        if(current_frame_active){
            view_shake_max_at(posx, posy, min(speed * 4, 3));
        }
        if(chance_ct(speed, 10 / pit_height)){
            instance_create(posx + orandom(40), posy + orandom(40), Bubble);
        }
    }

     // Find Nearest Visible Player:
    var	_target = noone,
		d = 1000000;

	with(Player) if(!collision_line(other.posx, other.posy, x, y, Wall, false, false)){
		var _dis = point_distance(other.posx, other.posy, x, y);
		if(_dis < d){
			_target = id;
			d = _dis;
		}
	}

     // Eye Lasering:
    if(eye_laser_delay > 0){
    	eye_laser_delay -= current_time_scale;
    	if(eye_laser > 0){
    		if(bite <= 0 && eye_laser_delay < 30) bite = 1.2;
			var s = sound_play_pitchvol(sndNothing2Appear, 0.7, 1.5);
			audio_sound_set_track_position(s, audio_sound_length_nonsync(s) * clamp(eye_laser_delay / 40, 0, 0.8));
    	}
    }
	if(eye_laser > 0){
		if(eye_laser_delay <= 0){
			eye_laser -= current_time_scale;
		}
		
		 // Spinny:
		if(eye_laser > 30){
			eye_dir_speed += (0.1 - (0.03 * (image_xscale - 1))) * current_time_scale;
		}
		else with(eye) blink = true;
		
    	 // Away From Walls:
		if(instance_exists(Wall)){
			var n = instance_nearest(posx - 8, posy - 8, Wall);
			motion_add_ct(point_direction(n.x + 8, n.y + 8, posx, posy), 0.5);
		}
		
		 // End:
		if(eye_laser <= 0 || !instance_exists(Player) || pit_height < 1){
			eye_laser = 0;
			eye_laser_delay = random_range(30, 150);
		}
	}

     // Eyes:
    eye_dir += eye_dir_speed * right * current_time_scale;
    eye_dir_speed -= (eye_dir_speed * 0.1) * current_time_scale;
    for(var i = 0; i < array_length(eye); i++){
        var _dis = (24 + eye_dis) * max(pit_height, 0),
            _dir = image_angle + eye_dir + ((360 / array_length(eye)) * i),
            _x = posx + hspeed_raw + lengthdir_x(_dis * image_xscale, _dir),
            _y = posy + vspeed_raw + lengthdir_y(_dis * image_yscale, _dir);

        with(eye[i]){
            x = _x;
            y = _y;

             // Look at Player:
            if(other.eye_laser <= 0 && !instance_exists(my_laser)){
	            var _seen = false;
	            if(instance_exists(_target)){
	                _seen = true;
	                dir = angle_lerp(dir, point_direction(x, y, _target.x, _target.y),                 0.3 * current_time_scale);
	                dis = lerp(      dis, clamp(point_distance(x, y, _target.x, _target.y) / 6, 0, 5), 0.3 * current_time_scale);
	            }
	            else dir += sin((current_frame) / 20) * 1.5;
            }

             // Blinking:
            if(blink || (other.eye_laser > 0 && other.eye_laser_delay > 0)){
                var n = sprite_get_number(spr.PitSquidEyelid) - 1;
                blink_img += other.image_speed * (instance_exists(my_laser) ? 0.5 : 1) * current_time_scale;

				 // Gonna Laser:
                if(other.eye_laser > 0){
                	var _dir = point_direction(other.posx, other.posy, x, y);
                	if(chance_ct(10, other.eye_laser_delay)){
	                	if(chance(1, 7)){
	                		with(instance_create(x + orandom(12), y, PortalL)){
	                			name = "PitSquidL";
								if(chance(1, 2)) sprite_index = spr.PitSpark[irandom(4)];
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
                    if((instance_exists(Player) || other.pit_height >= 1) && (other.intro || other.pit_height < 1)){
                    	if(chance(1, 4)) blink = false;
                    }
                }
            }

            else{
                blink_img = max(blink_img - other.image_speed, 0);

				 // Eye Lasers:
				if(other.eye_laser > 0){
					dis -= dis * 0.1 * current_time_scale;

					if(!instance_exists(my_laser)){
						with(other){
							other.my_laser = enemy_shoot_ext(other.x, other.y, "QuasarBeam", _dir, 0);
						}
						with(my_laser){
							damage = 6;
							bend_fric = 0.2;
							scale_goal = 0.8 * creator.image_xscale;
        					follow_creator = false;
        					mask_index = mskSuperFlakBullet;
							image_xscale = scale_goal / 2;
							image_yscale = scale_goal / 2;
							depth = -3;
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
				with(instance_create(x + orandom(20), y + orandom(20), PortalL)){
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
		
		var _spr = spr_fire,
			_img = ((1 - spit) * sprite_get_number(_spr));
			
		if(_img < 6 || ammo <= 0){
			spit -= (image_speed_raw / sprite_get_number(_spr));
			
			 // Effects:
			if(chance_ct(1, 5)){
				instance_create(posx + orandom(4), posy + orandom(4), Bubble);
			}
		}
	}

     // Bite:
    if(bite > 0){
        _eyeDisGoal = 8;

        var _spr = spr_bite,
            _img = ((1 - bite) * sprite_get_number(_spr));

         // Finish chomp at top of pit:
        if(_img < 6 || _img >= 8 || (pit_height > 0.5 && (eye_laser <= 0 || eye_laser_delay <= 0))){
            bite -= (image_speed_raw / sprite_get_number(_spr));
        }

         // Bite Time:
        if(in_range(_img, 8, 9)){
        	if(pit_height > 0.5){
	            mask_index = mskReviveArea;
	            with(instances_meeting(posx, posy, instances_matching_ne(hitme, "team", team))){
	                with(other) if(place_meeting(posx, posy, other)){
	                    if(projectile_canhit_melee(other)){
	                        projectile_hit_raw(other, meleedamage, true);
	                        if("lasthit" in other) other.lasthit = [spr_bite, "PIT SQUID"];
	                    }
	                }
	            }
	            mask_index = mskNone;
        	}

             // Chomp FX:
            if(_img - image_speed_raw < 8){
                sound_play_pitchvol(snd_mele, 0.8 + orandom(0.1), 0.8);
                sound_play_pitchvol(sndOasisChest, 0.8 + orandom(0.1), 1);
                repeat(3) instance_create(posx, posy, Bubble);
            }
        }
    }

    eye_dis += ((_eyeDisGoal - eye_dis) / 5) * current_time_scale;

     // Death Taunt:
    if(tauntdelay > 0 && !instance_exists(Player)){
        tauntdelay -= current_time_scale;
        if(tauntdelay <= 0 && intro){
        	if(!sink){
	            sink = true;
	            eye_dir_speed -= 8;
	            sound_play_pitchvol(sndNothing2Hurt,      0.6, 0.4);
	            sound_play_pitchvol(sndNothingHurtHigh,   0.3, 0.5);
        	}
            sound_play_pitchvol(sndNothingGenerators, 0.4, 0.4);
        }
    }

#define PitSquid_end_step
	x = 0;
	y = 0;

	var	_xprev = posx,
		_yprev = posy;

	posx += hspeed_raw;
	posy += vspeed_raw;

     // Collisions:
    if(pit_height > 0.5){
        mask_index = mskReviveArea;

         // Wall Collision:
        if(place_meeting(posx, posy - 16, Wall)){
            speed *= 0.8;
            posx = _xprev;
            posy = _yprev;
            if( place_meeting(posx + hspeed_raw, posy - 16,              Wall)) hspeed_raw *= -1;
            if( place_meeting(posx,              posy - 16 + vspeed_raw, Wall)) vspeed_raw *= -1;
            if(!place_meeting(posx + hspeed_raw, posy - 16,              Wall)) posx += hspeed_raw;
            if(!place_meeting(posx,              posy - 16 + vspeed_raw, Wall)) posy += vspeed_raw;
        }

         // Floor Collision:
	    if(pit_get(posx, posy - 16)){
			var f = instances_meeting(posx, posy - 16, instances_matching_ne(Floor, "sprite_index", spr.FloorTrenchB));
			if(array_length(f) > 0){
		        posx = _xprev;
		        posy = _yprev;

		        if(array_length(instances_meeting(posx + hspeed_raw, posy - 16, f)) > 0) hspeed_raw *= -1;
		        if(array_length(instances_meeting(posx, posy - 16 + vspeed_raw, f)) > 0) vspeed_raw *= -1;
		        speed *= 0.8;

		        posx += hspeed_raw;
		        posy += vspeed_raw;
			}
	    }

         // Destroy Stuff:
        if(pit_height >= 1){
            var _xsc = image_xscale,
                _ysc = image_yscale;
                
            if(intro_pitbreak){
                _xsc *= 1.5;
                _ysc *= 1.5;
            }
            
             // Clear Walls:
            if(place_meeting(posx, posy - 16, Wall)){
                image_xscale = _xsc * 1.6;
                image_yscale = _ysc * 1.6;
                with(instances_meeting(posx, posy - 16, Wall)){
                	with(other) if(place_meeting(posx, posy - 16, other)) with(other){
	                    with(instance_create(x, y, FloorExplo)) depth = 8;
	                    instance_destroy();
                	}
                }
            }
    
             // Clear Floors:
            if(place_meeting(posx, posy - 16, Floor)){
                var _floors = instances_matching_ne(Floor, "sprite_index", spr.FloorTrenchB);
                if(array_length(instances_meeting(posx, posy - 16, _floors)) > 0){
                	image_xscale = _xsc * 1.2;
                	image_yscale = _ysc * 1.2;
                    with(instances_meeting(posx, posy - 16, _floors)){
                        styleb = true;
                        sprite_index = spr.FloorTrenchB;
                        mod_script_call("area", "trench", "area_setup_floor");

                         // Effects:
                        sound_play_pitchvol(sndWallBreak, 0.6 + random(0.4), 1.5);
                        for(var _x = bbox_left; _x < bbox_right + 1; _x += 16){
                            for(var _y = bbox_top; _y < bbox_bottom + 1; _y += 16){
                                var _dir = point_direction(other.posx, other.posy - 16, _x + 8, _y + 8),
                                    _spd = 8 - (point_distance(other.posx, other.posy - 16, _x + 8, _y + 8) / 16);

								if(other.intro && chance(2, 3)){
	                                with(obj_create(_x + random_range(4, 12), _y + random_range(4, 12), "TrenchFloorChunk")){
	                                    zspeed = _spd;
	                                    direction = _dir;
	                                	if(other.object_index == FloorExplo || chance(1, 2)){
	                                		sprite_index = spr.DebrisTrench;
	                                		zspeed /= 2;
	                                		zfriction /= 2;
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
                    }
                }
            }

            if(intro_pitbreak){
                intro_pitbreak = false;
                _xsc /= 1.5;
                _ysc /= 1.5;
            }
            
            image_xscale = _xsc;
            image_yscale = _ysc;
        }

	    mask_index = mskNone;
    }

#define PitSquid_alrm1
    alarm1 = 20 + irandom(30);
    
	if(enemy_target(posx, posy)){
		if(intro || pit_height < 1 || (instance_number(enemy) - instance_number(Van)) <= array_length(instances_matching(object_index, "name", name))){
	    	if(intro || pit_height < 1){
		        var _targetDir = point_direction(posx, posy, target.x, target.y),
		        	_targetDis = point_distance(posx, posy, target.x, target.y);
		
		        if(_targetDis >= 96 || pit_height < 1 || chance(1, 2)){
		        	if(chance(pit_height, 2) || !intro){
			            motion_add(_targetDir, 1);
			            sound_play_pitchvol(sndRoll, 0.2 + random(0.2), 2)
			            sound_play_pitchvol(sndFishRollUpg, 0.4, 0.2);
		        	}
		
					 // In Pit:
		            if(sink){
		            	alarm1 = 20 + random(10);
		
		            	direction = _targetDir;
		            	speed = max(speed, 2.4);
		            	if(!intro) speed = min(speed, 3);
						
		            	 // Rise:
		            	if(
		            		_targetDis < (intro ? 40 : 120) * image_xscale ||
		            		(
		            			intro &&
		            			(
		            				(_targetDis < (160 * image_xscale) && !pit_get(posx, posy)) ||
		            				(_targetDis < (128 * image_xscale) && (chance(1, 2) || !chance(my_health, maxhealth)))
		            			)
		            		)
		            	){
		            		sink = false;
		            		if(!intro){
		            			speed /= 2;
		            			rise_delay = 84;
		            			
		            			var	s = sound_play(mus.PitSquidIntro),
							    	c = mod_variable_get("mod", "ntte", "sound_current");
							    	
							    if(is_object(c)){
							    	audio_sound_gain(s, audio_sound_get_gain(c.mus.hold), 0);
							    }
		            		}
		            	}
		            }
		        }
		        
		        if(pit_height >= 1){
		             // Check LOS to Player:
		            var _targetSeen = (!collision_line(posx, posy, target.x, target.y, Wall, false, false) && _targetDis < 240);
		            if(_targetSeen && (chance(2, 3) || _targetDis > 128) && eye_laser <= 0){
		                var f = instances_matching(Floor, "styleb", true);
		                with(f) x -= 10000;
		                if(collision_line(posx, posy, target.x, target.y, Floor, false, false)){
		                    _targetSeen = false;
		                }
		                with(f) x += 10000;
		            }
		
		             // Sink into pit:
		            if(!_targetSeen && eye_laser_delay <= 0){
		                sink = true;
		                alarm1 = 20;
		            }
			
			         // Spawn Tentacles:
			        else{
			        	var	_ang = random(360),
			        		_num = irandom_range(2, 3 + floor(5 * (image_xscale - 1)));
			        		
			        	for(var d = _ang; d < _ang + 360; d += (360 / _num)){
					        var t = array_length(instances_matching(instances_matching(CustomEnemy, "name", "PitSquidArm"), "creator", id));
					        if(t < 2 + (10 * (image_xscale - 1)) || chance(1, 5 + (5 * t))){
					        	with(obj_create(posx + dcos(d), posy + dsin(d) - 8, "PitSquidArm")){
					        		creator = other;
					        		hitid = other.hitid;
					        		if(chance(1, 2)){
						        		x = 0;
						        		y = 0;
						        		alarm2 = 1;
					        		}
					        		else{
					        			alarm2 = irandom_range(60, 150);
					        		}
					        	}
					        }
			        	}
			        }
		        }
		    }
		    else sink = true;
		}
	}
    
#define PitSquid_alrm2
    alarm2 = 40 + random(20);

    if(pit_height >= 1 && intro){
        
		 // Electroplasma Volley:
		if(ammo > 0){
			spit = 0.6;
			
			 // Aiming:
			var _targetDis = 96;
			if(enemy_target(posx, posy)){
				if(!collision_line(posx, posy, target.x, target.y, Wall, false, false)){
					_targetDis = point_distance(posx, posy, target.x, target.y);
					gunangle += clamp(angle_difference(point_direction(posx, posy, target.x + (_targetDis/12 * target.hspeed), target.y + (_targetDis/12 * target.vspeed)), gunangle) * 0.5 * current_time_scale, -60, 60);
				}
			}
			
			 // Projectile:
			var _last = electroplasma_last,
				_ang = (2000 / max(1, _targetDis)) * image_xscale;
				
			with(enemy_shoot_ext(posx, posy, "ElectroPlasma", gunangle + (_ang * electroplasma_side), 5)){
				tether_inst = _last;
				image_xscale *= other.image_xscale;
				image_yscale *= other.image_yscale;
				damage = 1;
				
				_last = id;
			}
			electroplasma_last = _last;
			electroplasma_side *= -1;
			
			 // Sounds:
			sound_play_pitch(sndOasisShoot, 		1.1 + random(0.3));
			sound_play_pitchvol(sndGammaGutsProc,	0.9 + random(0.5), 0.4);
			
			 // Effects:
			instance_create(posx + orandom(8), posy + orandom(8), PortalL);
			view_shake_max_at(posx, posy, 5);
			 
			 // Continue:
			if(--ammo > 0){
				alarm2 = 5 + random(2);
				alarm1 = alarm1 + alarm2;
			}
			
			 // End:
			else{
				sound_play_pitchvol(sndOasisDeath, 0.9 + random(0.3), 2.4);
			}
		}
		
        else if(enemy_target(posx, posy)){
            var _targetDis = point_distance(posx, posy, target.x, target.y),
                _targetDir = point_direction(posx, posy, target.x, target.y);
                
			if(!collision_line(posx, posy, target.x, target.y, Wall, false, false)){
	            if(point_distance(target.x, target.y, posx + hspeed, posy + vspeed) > 64){
					 // Half-Health Laser:
					if(eye_laser <= 0 && eye_laser_delay <= 0 && my_health < maxhealth / 2){
						eye_laser = 90 + random(450);
						eye_laser_delay = 60;
						right *= -1;
						sound_play_pitchvol(sndGammaGutsKill,      0.6 + random(0.1), 0.8);
						sound_play_pitchvol(sndHyperCrystalSearch, 0.6 + random(0.1), 0.8);
					}
					
					 // Begin Volley Attack:
					else{
						spit = 1.2;
						alarm2 = 15;
						alarm1 = alarm1 + alarm2;
						
						ammo = 3 + irandom(2 * image_xscale);
						gunangle = _targetDir;
						
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
    }
    
     // Just in Case:
    else{
    	ammo = 0;
    }

#define PitSquid_alrm3
	var _pits = instances_matching(Floor, "sprite_index", spr.FloorTrenchB),
		_sparks = instances_matching(CustomObject, "name", "PitSpark");

	alarm3 = random_range(1, 12) + (12 * array_length(_sparks)) + (30 / array_length(_pits));

	 // Cool tentacle effects:
	if(pit_height >= 1 && intro){
		var _tries = 10;
		while(_tries-- > 0){
			with(instance_random(_pits)){
				var d = point_distance(x, y, other.posx, other.posy);
				if(d > 96 && d < 256){
					if(array_length(instances_meeting(x, y, _sparks)) <= 0){
						with(obj_create((bbox_left + bbox_right + 1) / 2, (bbox_top + bbox_bottom + 1) / 2, "PitSpark")){
							move_dir = point_direction(other.x, other.y, x, y);
						}
						_tries = 0;
					}
				}
			}
		}
	}

#define PitSquid_hurt(_hitdmg, _hitvel, _hitdir)
    x = posx;
    y = posy;
    
    my_health -= _hitdmg;
    nexthurt = current_frame + 6;
    sound_play_hit_ext(snd_hurt, 1.4 + orandom(0.4), 2.5);

     // Half HP:
    var h = (maxhealth / 2);
    if(in_range(my_health, h - _hitdmg + 1, h)){
    	if(snd_lowh == sndNothing2HalfHP){
    		sound_play_pitch(snd_lowh, 0.6);
    	}
    	else sound_play(snd_lowh);
    	
    	bite = 1;
    	if(ammo <= 0){
    		alarm2 = max(alarm2, 45 + random(15));
    	}
    }
    
    x = 0;
    y = 0;

#define PitSquid_death
	x = posx;
	y = posy;
	
	 // Sound:
	sound_play_pitch(snd_dead, 0.6);
	sound_play_pitchvol(sndBallMamaHalfHP, 0.6, 2);
	snd_dead = -1;

	 // Death Time:
	with(obj_create(x, y, "PitSquidDeath")){
        eye = other.eye;
        eye_dir = other.eye_dir;
        eye_dir_speed = other.eye_dir_speed;
        eye_dis = other.eye_dis;
        pit_height = other.pit_height;
        direction = other.direction;
        speed = min(other.speed, 2);
        raddrop = other.raddrop;
	}
	raddrop = 0;

     // Boss Win Music:
    with(MusCont) alarm_set(1, 1);


#define PitSquidArm_create(_x, _y)
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
        image_speed = 0.4 + orandom(0.1);
        sprite_index = spr_appear;
        
         // Sound:
        snd_hurt = sndOasisHurt;
        snd_dead = sndMeatExplo;
        snd_mele = sndPlantSnare;

         // Vars:
        mask_index = mskLaserCrystal;
        friction = 0.8;
        maxhealth = irandom_range(20, 60);
        raddrop = 0;
        size = 3;
        creator = noone;
        canfly = true;
        walk = 0;
        kills = 0;
        walkspeed = 2;
        maxspeed = 3.5;
        meleedamage = 1;
        canmelee = false;
        wave = 0;
        bomb = 0;
        bomb_delay = 0;
        
        teleport = false;
        teleport_x = x;
        teleport_y = y;
        teleport_drawy = x;
        teleport_drawy = y;
        
         // Alarms:
        alarm1 = 15;
        alarm2 = -1;
        alarm11 = 30;
        
         // NTTE:
        ntte_anim = false;
	
		return id;
	}
	
#define PitSquidArm_step
	wave += current_time_scale;
	depth = -2 - (y / 20000);
	
	 // Animate:
	if(teleport){
		//x = 0;
		//y = 0;
		if(sprite_index == spr_disappear){
			if(anim_end){
				image_index -= image_speed_raw;
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
		teleport_drawx = x;
		teleport_drawy = y;

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
	if(!instance_exists(creator) || (!bomb && creator.pit_height < 1)){
		my_health = 0;
		snd_dead = -1;
	}

#define PitSquidArm_end_step
	 // PitSquid Collision:
	if(instance_exists(creator)){
		var l = 48 * creator.image_xscale;
		if(point_distance(x, y, creator.posx, creator.posy - 8) < l){
			var d = point_direction(creator.posx, creator.posy - 8, x, y);
			x = creator.posx + lengthdir_x(l, d);
			y = creator.posy - 8 + lengthdir_y(l, d);
			direction = d;
			speed /= 2;
		}
	}

     // Floor Collision:
    if(pit_get(x, y) && sprite_index != spr_appear){
		var f = instances_meeting(x, y, instances_matching_ne(Floor, "sprite_index", spr.FloorTrenchB));
		if(array_length(f) > 0){
	        x = xprevious;
	        y = yprevious;
	
	        if(array_length(instances_meeting(x + hspeed_raw, y, f)) > 0) hspeed_raw *= -1;
	        if(array_length(instances_meeting(x, y + vspeed_raw, f)) > 0) vspeed_raw *= -1;
	        speed *= 0.5;
	
	        x += hspeed_raw;
	        y += vspeed_raw;
		}
    }
    else{
		with(instances_meeting(x, y - 8, Wall)){
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}
        with(instances_meeting(x, y, instances_matching_ne(Floor, "sprite_index", spr.FloorTrenchB))){
            styleb = true;
            sprite_index = spr.FloorTrenchB;
            mod_script_call("area", "trench", "area_setup_floor");
            sound_play_pitchvol(sndWallBreak, 0.6 + random(0.4), 1.5);
            repeat(sprite_width / 16){
                instance_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), Debris);
            }
        }
    }

#define PitSquidArm_alrm1
	alarm1 = 20 + irandom(20);
	
	if(enemy_target(x, y) && sprite_index != spr_appear){
		if(in_sight(target) && (!instance_exists(creator) || !collision_line(x - creator.posx, y - creator.posy, target.x - creator.posx, target.y - creator.posy, creator, false, false))){
			var _targetDir = point_direction(x, y, target.x, target.y);
			
			 // Keep away:
			if(in_distance(target, 16)){
				scrWalk(_targetDir + 180 + orandom(30), [10, 20]);
				alarm1 = walk + irandom(10);
			}

			else{
				 // Attack:
				if(in_sight(target) && in_distance(target, 160) && chance(1, 2)){
					alarm2 = 1;
					bomb = true;
					bomb_delay = 18;
					
					 // Sounds:
					sound_play_pitchvol(sndPlasmaReloadUpg, 0.8 + random(0.3), 0.6);
					sound_play_pitch(sndOasisPortal, 1.1 + random(0.3));
				}
				
				else{
					if(in_distance(target, 96)){
						 // Wander Passively:
						direction += orandom(30);
						scrRight(direction);
						
						 // Effects:
						instance_create(x, y, Bubble);
					}
					
					 // Get closer:
					else{
						scrWalk(_targetDir + orandom(10), [10, 20]);
						alarm1 = walk + random(5);
					}
				}
			}
		}
		
		 // Teleport:
		else{
			alarm2 = 1;
		}
	}

#define PitSquidArm_alrm2
	enemy_target(x, y);

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
		
		else{
			if(bomb_delay > 0){
				alarm2 = 1;
				bomb_delay--;
				
				 // Effects:
				var _depth = depth - 1,
					_yoffset = 8;
					
				repeat(1 + irandom(1)) with(instance_create(irandom_range(bbox_left, bbox_right), irandom_range(bbox_top, bbox_bottom) - _yoffset, PlasmaTrail)){
					depth = _depth;
					sprite_index = spr.EnemyPlasmaTrail;
				}
				
				 // Full charge:
				if(bomb_delay <= 0){
					
					 // Effects:
					with(instance_create(x, y - _yoffset, ImpactWrists)){
						depth = _depth;
						sprite_index = spr.SquidCharge;
					}
					repeat(2 + irandom(4)) with(instance_create(x, y - _yoffset, LaserCharge)){
						depth = _depth;
						alarm0 = 6 + irandom(6);
						motion_set(irandom(359), 2 + random(2));
					}
					
					 // Sounds:
					sound_play_pitch(sndPlasmaReload, 1.8 + random(0.4));
					sound_play_pitchvol(sndCrystalJuggernaut, 1.3 + random(0.4), 0.5);
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
						with(enemy_shoot("PitSquidBomb", point_direction(x, y, target.x, target.y), 0)){
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
							_validPits = [],
							_exploTiles = instances_matching_ne(FloorExplo, "sprite_index", spr.FloorTrenchB);
							
						 // Find Clear Pits:
						with(_allPits){
							if(!place_meeting(x, y, Wall) && (!place_meeting(x, y, FloorExplo) || array_length(instances_meeting(x, y, _exploTiles)) <= 0)){
								array_push(_emptyPits, id);
							}
						}
							
						 // Find Pits Near Target:
						with(_emptyPits){
							if(!place_meeting(x, y, hitme)){
								var	_x = (bbox_left + bbox_right + 1) / 2,
									_y = (bbox_top + bbox_bottom + 1) / 2,
									_targetDis = point_distance(_x, _y, _target.x, _target.y);
									
								if(_targetDis > 32 && _targetDis < 128){
									var _squidDis = point_distance(_x, _y, _creator.posx, _creator.posy);
									if(_squidDis > (60 * _creator.image_xscale) && _squidDis < (180 * _creator.image_xscale)){
										array_push(_validPits, id);
									}
								}
							}
						}
						
						 // Teleport to Random Valid Pit:
						if(array_length(_validPits) > 0){
							with(instance_random(_validPits)){
								with(other){
									teleport_x = (other.bbox_left + other.bbox_right + 1) / 2;
									teleport_y = (other.bbox_top + other.bbox_bottom + 1) / 2;
								}
							}
						}
						
						 // Teleport to a Random Pit:
						else with(instance_random(_emptyPits)){
							with(other){
								teleport_x = (other.bbox_left + other.bbox_right + 1) / 2;
								teleport_y = (other.bbox_top + other.bbox_bottom + 1) / 2;
							}
						}
					}
				}
				
				 // Sounds:
				sound_play_pitchvol(sndOasisMelee, 0.7 + random(0.3), 1.0);
			}
		}
		
		alarm1 += alarm2;
	}
	
#define PitSquidArm_draw
	var h = (nexthurt > current_frame),
		_x = x,
		_y = y;

	if(teleport){
		_x = teleport_drawx;
		_y = teleport_drawy;
	}

	if(h) draw_set_fog(true, image_blend, 0, 0);
	draw_sprite_ext(sprite_index, image_index, _x, _y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
	if(h) draw_set_fog(false, c_white, 0, 0);
	
#define PitSquidArm_hurt(_hitdmg, _hitvel, _hitdir)
    if(sprite_index != mskNone){
    	var _armHealth = my_health;
        my_health -= _hitdmg;
        nexthurt = current_frame + 6;
        sound_play_hit(snd_hurt, 0.3);
    	
         // Hurt Papa Squid:
        with(other) with(other.creator){
        	PitSquid_hurt(min(_hitdmg, max(0, _armHealth)), _hitvel, _hitdir);
        }
        with(instances_matching(instances_matching(object_index, "name", name), "creator", creator)){
        	nexthurt = current_frame + 6;
        }
        
        scrRight(_hitdir + 180);
    }

#define PitSquidArm_death
	pickup_drop(30, 0);
	repeat(3) with(scrFX(x, y, 1, Smoke)) depth = 2;
	
	 // Manual Corpse:
	if(corpse){
		corpse = false;
		with(corpse_drop(direction, speed)){
			if(other.sprite_index == other.spr_appear){
				image_index = (image_number - 1) * (1 - (ceil(other.image_index) / (other.image_number - 1)));
			}
		}
	}


#define PitSquidBomb_create(_x, _y)
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
	
#define PitSquidBomb_alrm0
	var _len = 24,
		_dir = direction;
	
	 // Adjust Direction:
	if(instance_exists(target) && instance_exists(creator)){
		var _clamp = 45;
		_dir += clamp(angle_difference(_dir, point_direction(x, y, target.x, target.y)), -_clamp, _clamp);
	}
	
	var _x = x + lengthdir_x(_len, _dir),
		_y = y + lengthdir_y(_len, _dir);
	
	if(pit_get(_x, _y) && !place_meeting(_x, _y, Wall)){
		 // Relocate Creator:
		with(creator){
			teleport_x = _x;
			teleport_y = _y;
			
			alarm2 = other.alarm1 + 10;
			alarm1 = max(alarm1, alarm2);
		}
	
		 // Spawn Next Bomb:
		if(ammo > 0){
			with(enemy_shoot_ext(_x, _y, "PitSquidBomb", _dir, 0)){
				target = other.target;
				ammo = other.ammo - 1;
			}
		}
	}

	 // Effects:
	repeat(irandom_range(3, 7)){
		with(instance_create(x + orandom(12), y + orandom(12), PlasmaTrail)){
			sprite_index = spr.EnemyPlasmaTrail;
		}
	}
	
	repeat(irandom_range(1, 2)){
		with(instance_create(x + orandom(6), y + orandom(6), LaserCharge)){
			motion_set(_dir, 1);
			alarm0 = 10 + irandom(5);
		}
	}
	
#define PitSquidBomb_alrm1
	instance_destroy();
	
#define PitSquidBomb_destroy
	var l = 8,
		_explo = [];
	
	 // Triple Sucker:
	if(triple){
		for(var d = 0; d < 360; d += 120){
			var _x = x + lengthdir_x(l, d + direction),
				_y = y + lengthdir_y(l, d + direction);
				
			array_push(_explo, instance_create(_x, _y, PlasmaImpact));
			// enemy_shoot_ext(_x, _y, "ElectroPlasmaImpact", direction, 0);
		}
	}

	 // Single Sucker:
	else{
		array_push(_explo, instance_create(x, y, PlasmaImpact));
		// enemy_shoot("ElectroPlasmaImpact", direction, 0);
		
		 // Mortar Time:
		if(instance_exists(target) && GameCont.loops > 0){
	        with(enemy_shoot_ext(x, y, "MortarPlasma", point_direction(x, y, target.x, target.y), 3)){
	            zspeed = (point_distance(x, y, other.target.x, other.target.y) * zfriction) / (speed * 2);
	        }
		}
	}
	
	with(_explo){
		direction = other.direction;
		creator	  = other.creator;
		team	  = other.team;
		hitid	  = other.hitid;
		damage	  = 2;
		
		image_speed = 0.4;
		
		sprite_index = spr.EnemyPlasmaImpact;
		image_xscale = other.scale;
		image_yscale = other.scale;
		
		 // Effects:
		with(instance_create(x, y, Smoke)) waterbubble = false;
	}
	
	 // Effects:
	view_shake_max_at(x, y, (triple ? 5 : 15));
	
	 // Sounds:
	sound_play_hit(sndEliteShielderFire, 0.6);
	sound_play_hit(sndOasisExplosionSmall, 0.4);


#define PitSquidDeath_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		spr_bite = spr.PitSquidMawBite;
		
		 // Vars:
		friction = 0.01;
		eye = [];
        eye_dir = random(360);
        eye_dir_speed = 0;
        eye_dis = 0;
        pit_height = 0;
        raddrop = 0;
        explo = true;
        sink = false;
		
		alarm0 = 30;
		
		return id;
	}

#define PitSquidDeath_step
	with(instances_matching_ge(Corpse, "alarm0", 0)) alarm0 = -1;
	
	if(pit_height > 0.1){
		 // Sinkin:
    	var _pitHeightGoal = (sink ? (explo ? 0.5 : 0) : 1);
    	if(explo && !sink && pit_height != _pitHeightGoal){
    		if(abs(_pitHeightGoal - pit_height) < 0.2){
    			explo = false;
				with(eye){
					obj_create(x, y, "BubbleExplosion");
					sound_play_pitchvol(sndNothingDeath2, 0.6, 0.8);
					
					 // Pickups:
					with(other){
						var	_x = x,
							_y = y;
							
						x = other.x;
						y = other.y;
						pickup_drop(80, 0);
						x = _x;
						y = _y;
					}
				}
				
				 // Rads:
				rad_drop(x, y, raddrop, direction, speed);
    		}
    	}
		pit_height += ((_pitHeightGoal - pit_height) / (sink ? 30 : 4)) * current_time_scale;
    	
    	 // Eyes:
    	eye_dis -= (eye_dis / 5) * current_time_scale;
	    eye_dir += eye_dir_speed * current_time_scale;
	    eye_dir_speed -= (eye_dir_speed * (explo ? 0.1 : 0.05)) * current_time_scale;
	    for(var i = 0; i < array_length(eye); i++){
	        var _dis = (24 + eye_dis) * max(pit_height, 0),
	            _dir = image_angle + eye_dir + ((360 / array_length(eye)) * i),
	            _x = x + hspeed_raw + lengthdir_x(_dis * image_xscale, _dir),
	            _y = y + vspeed_raw + lengthdir_y(_dis * image_yscale, _dir);
	
	        with(eye[i]){
	            x = _x + orandom(2/3);
	            y = _y + orandom(2/3);
	            
            	dis -= dis * 0.3 * current_time_scale;
	            
	            if(chance_ct(1, 16)){
	            	with(instance_create(x + orandom(8), y + orandom(8), PortalL)){
	            		image_xscale = 0.5;
	            		image_yscale = 0.5;
	            	}
	            }
	        }
	    }
	}
	else instance_destroy();

#define PitSquidDeath_alrm0
	if(explo || !sink){
		alarm0 = (sink ? 30 : 33);
		sink = !sink;
		if(explo) eye_dir_speed -= 12 + random(4);
		else vspeed += 2/3;
	}

#define PitSquidDeath_destroy
	instance_create(x, y, Bubble);
	with(instance_create(xstart, ystart, Corpse)) alarm0 = 10;


#define QuasarBeam_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
         // Visual:
        sprite_index = spr.QuasarBeam;
        spr_strt = spr.QuasarBeamStart;
        spr_stop = spr.QuasarBeamEnd;
        image_speed = 0.5;
        depth = -1.5;

         // Vars:
        friction = 0.02;
        mask_index = msk.QuasarBeam;
        image_xscale = 1;
        image_yscale = image_xscale;
        creator = noone;
        roids = false;
        damage = 12;
        force = 4;
        typ = 0;
        bend = 0;
        loop_snd = -1;
        hit_time = 0;
        hit_list = {};
        line_seg = [];
        line_dis = 0;
        line_dir_turn = 0;
        line_dir_goal = null;
        blast_hit = true;
        flash_frame = current_frame + 2;
        follow_creator	= true;	// Follow Creator
        offset_dis		= 0;	// Offset from Creator Towards image_angle
        bend_fric		= 0.3;	// Multiplicative Friction for Line Bending
        line_dir_fric	= 1/4;	// Multiplicative Friction for line_dir_turn
        line_dis_max	= 300;	// Max Possible Line Length
        turn_max		= 8;	// Max Rotate Speed
        turn_factor		= 1/8;	// Rotation Speed Increase Factor
        shrink_delay	= 0;	// Frames Until Shrink
        shrink			= 0.05;	// Subtracted from Line Size
        scale_goal		= 1;	// Size to Reach When shrink_delay > 0
        hold_x			= null;	// Stay at this X
        hold_y			= null; // Stay at this Y
        ring			= false;// Take Ring Form
        ring_size		= 1;	// Scale of ring, multiplier cause I don't wanna figure out the epic math
        ring_lasers		= [];
        wave = random(100);

		on_end_step = QuasarBeam_quick_fix;

        return id;
	}

#define QuasarBeam_quick_fix
	on_end_step = [];
	
	var l = line_dis_max;
	line_dis_max = 0;
	QuasarBeam_step();
	if(instance_exists(self)) line_dis_max = l;
	
#define QuasarBeam_step
	wave += current_time_scale;
	hit_time += current_time_scale;
	
     // Shrink:
    if(shrink_delay <= 0){
	    var f = shrink * current_time_scale;
	    if(!instance_is(creator, enemy)){
	    	f *= power(2/3, skill_get(mut_laser_brain));
	    }
	    image_xscale -= f;
	    image_yscale -= f;
    }
    else{
    	var f = current_time_scale;
	    if(!instance_is(creator, enemy)){
	    	f *= power(2/3, skill_get(mut_laser_brain));
	    }
    	shrink_delay -= f;
    	
    	if(shrink_delay <= 0 || (follow_creator && !instance_exists(creator))){
    		shrink_delay = -1;
    	}
    	
		 // Growin:
		var _goal = scale_goal;
		if(!instance_is(creator, enemy)){
			_goal *= power(1.2, skill_get(mut_laser_brain));
		}
		if(abs(_goal - image_xscale) > 0.05 || abs(_goal - image_yscale) > 0.05){
			image_xscale += (_goal - image_xscale) * 0.4 * current_time_scale;
			image_yscale += (_goal - image_yscale) * 0.4 * current_time_scale;
			
			 // FX:
			if(follow_creator){
				var p = (image_yscale * 0.5);
				if(image_yscale < 1){
					sound_play_pitchvol(sndLightningCrystalHit, p - random(0.1), 0.8);
					sound_play_pitchvol(sndPlasmaHit, p, 0.6);
				}
				sound_play_pitchvol(sndEnergySword, p * 0.8, 0.6);
			}
		}
		else{
			image_xscale = _goal;
			image_yscale = _goal;
		}
    }
    
	 // Player Stuff:
	if(follow_creator){
		with(creator){
			 // Visually Force Player's Gunangle:
			if(instance_is(self, Player)) with(other){
				var _ang = angle_difference(image_angle, other.gunangle);
				if(array_length(instances_matching(instances_matching(instances_matching(CustomEndStep, "name", "QuasarBeam_wepangle"), "creator", creator), "roids", roids)) <= 0){
					with(script_bind_end_step(QuasarBeam_wepangle, 0)){
						name = script[2];
						creator = other.creator;
						roids = other.roids;
						angle = 0;
					}
				}
				with(instances_matching(instances_matching(instances_matching(CustomEndStep, "name", "QuasarBeam_wepangle"), "creator", creator), "roids", roids)){
					angle = _ang;
				}
			}
			
			 // Kickback:
			if(other.shrink_delay > 0){
				var k = (8 * (1 + (max(other.image_xscale - 1, 0)))) / max(1, abs(_ang / 30));
				if(other.roids){
					if("bwkick" in self) bwkick = max(bwkick, k);
				}
				else{
					if("wkick" in self) wkick = max(wkick, k);
				}
			}
			
        	 // Knockback:
        	if(friction > 0){
        		motion_add(other.image_angle + 180, other.image_yscale / 2.5);
        	}
        	
		     // Follow Player:
	        other.hold_x = x;
	        other.hold_y = y - (4 * other.roids);
        	if(!place_meeting(x + hspeed_raw, y, Wall)) other.hold_x += hspeed_raw;
        	if(!place_meeting(x, y + vspeed_raw, Wall)) other.hold_y += vspeed_raw;
	        if("gunangle" in self) other.line_dir_goal = gunangle;
		}
    }

	 // Stay:
	var o = offset_dis + (sprite_get_width(spr_strt) * image_xscale * 0.5);
	if(hold_x != null){
	    x = hold_x + lengthdir_x(o, image_angle);
	    xprevious = x;
	}
	if(hold_y != null){
	    y = hold_y + lengthdir_y(o, image_angle);
	    yprevious = y;
	}

     // Rotation:
    line_dir_turn -= line_dir_turn * line_dir_fric * current_time_scale;
    if(line_dir_goal != null){
	    var _turn = angle_difference(line_dir_goal, image_angle);
		if(abs(_turn) > 90 && abs(line_dir_turn) > 1){
			_turn = abs(_turn) * sign(line_dir_turn);
		}
	    line_dir_turn += _turn * turn_factor * current_time_scale;
    }
	line_dir_turn = clamp(line_dir_turn, -turn_max, turn_max);
    image_angle += line_dir_turn * current_time_scale;
    image_angle = (image_angle + 360) % 360;

	 // Bending:
    bend -= (bend * bend_fric) * current_time_scale;
    bend -= line_dir_turn * current_time_scale;

     // Line:
    var _lineAdd = 20,
        _lineWid = 16,
        _lineDir = image_angle,
        _lineChange = (instance_is(creator, Player) ? 120 : 40) * current_time_scale,
        _dis = 0,
        _dir = _lineDir,
        _dirGoal = _lineDir + bend,
        _cx = x,
        _cy = y,
		_lx = _cx,
        _ly = _cy,
        _walled = false,
        _enemies = instances_matching_ne(hitme, "team", team),
		_wob = 0;

	if(ring){
		_lineAdd = 24 * ring_size;

		 // Offset Ring Center:
		var _xoff = -_lineAdd / 2,
			_yoff = 57 * ring_size;

		_cx += lengthdir_x(_xoff, _dir) + lengthdir_x(_yoff, _dir - 90);
		_cy += lengthdir_y(_xoff, _dir) + lengthdir_y(_yoff, _dir - 90);
		_lx = _cx;
		_ly = _cy;

		 // Movin:
		motion_add_ct(random(360), 0.2 / (speed + 1));
		if(place_meeting(x, y, object_index)){
			with(instances_meeting(x, y, instances_matching(object_index, "name", name))){
				if(ring && place_meeting(x, y, other)){
					var l = 0.5 * current_time_scale,
						d = point_direction(other.x, other.y, x, y);

					x += lengthdir_x(l, d);
					y += lengthdir_y(l, d);
					motion_add_ct(d, 0.03);
				}
			}
		}

		 // Position Beams:
		var o = _yoff + (6 * image_yscale),
			t = 4 * current_time_scale,
			_x = x + hspeed,
			_y = y + vspeed,
			n = 0;

		with(ring_lasers){
			if(instance_exists(self)){
				hold_x = _x + lengthdir_x(o, image_angle);
				hold_y = _y + lengthdir_y(o, image_angle);
				line_dir_goal += t * sin((wave / 30) + array_length(ring_lasers) + n);
				n++;
			}
			else other.ring_lasers = array_delete_value(other.ring_lasers, self);
		}
	}
	else{
		var o = (sprite_get_width(spr_strt) / 2) * image_xscale;
		_lx -= lengthdir_x(o, _dir);
		_ly -= lengthdir_y(o, _dir);
	}

    line_seg = [];
    line_dis += _lineChange;
    line_dis = clamp(line_dis, 0, line_dis_max);
	if(collision_line(_lx, _ly, _cx, _cy, TopSmall, false, false)){
		line_dis = 0;
	}

    if(_lineAdd > 0 && line_dis > 0) while(true){
        var b = _lineAdd * 2,
	    	_seen = point_seen_ext(_lx, _ly, b, b, -1);

        if(!_walled){
        	if(!ring && collision_line(_lx, _ly, _cx, _cy, Wall, false, false)){
        		_walled = true;
        	}

	    	 // Add to Line Draw:
        	else if(_seen){
        		var l = _lineWid,
                    d = _dir - 90,
                    _x = _cx + hspeed_raw,
                    _y = _cy + vspeed_raw,
                    _xtex = (_dis / line_dis);

				 // Ring Collapse:
				if(ring){
					var o = (2 + (2 * ring_size * image_yscale)) / max(shrink_delay / 20, 1);
					_x += lengthdir_x(o, d) * dcos((_dir *  2) + (wave * 4));
					_y += lengthdir_y(o, d) * dsin((_dir * 10) + (wave * 4));
					d -= (_lineAdd / ring_size) * 0.5;
				}

				 // Pulsate:
				else{
					l *= 1 + (0.1 * sin((wave / 6) + (_wob / 10)) * min(1, _wob / 3));
				}

        		for(var a = -1; a <= 1; a += 2){
	                array_push(line_seg, {
	                    x    : _x,
	                    y    : _y,
	                    dir  : _dir,
	                    xoff : lengthdir_x(l * a, d),
	                    yoff : lengthdir_y(l * a, d),
	                    xtex : _xtex,
	                    ytex : !!a
	                });
	            }
    		}
        }

         // Wall Collision:
        else{
            blast_hit = false;
            line_dis -= _lineChange;
        	if(array_length(line_seg) <= 0) line_dis = 0;
        }
        if(ring && place_meeting(_cx, _cy, Wall)){
            speed *= 0.96;
        	with(instances_meeting(_cx, _cy, Wall)){
                if(place_meeting(x - (_cx - other.x), y - (_cy - other.y), other)){
	        		instance_create(x, y, FloorExplo);
	        		instance_destroy();
                }
        	}
        }

         // Hit Enemies:
        if(place_meeting(_cx, _cy, hitme)){
            with(instances_meeting(_cx, _cy, _enemies)){
                if(place_meeting(x - (_cx - other.x), y - (_cy - other.y), other)){
                	with(other){
	                	if(lq_defget(hit_list, string(other), 0) <= hit_time){
		                	 // Effects:
				            with(instance_create(_cx + orandom(8), _cy + orandom(8), BulletHit)){
				            	sprite_index = spr.QuasarBeamHit;
				            	motion_add(point_direction(_cx, _cy, x, y), 1);
				            	image_angle = direction;
				            	image_xscale = other.image_yscale;
				            	image_yscale = other.image_yscale;
				            	depth = other.depth - 1;
				            }
	
							 // Damage:
		                    if(!ring) direction = _dir;
		                    QuasarBeam_hit();
	                	}

	                	 // Hit the BRAKES:
	            		if(instance_is(creator, Player)){
	            			if(!instance_exists(other) || other.my_health <= 0 || other.size >= ((image_yscale <= 1) ? 3 : 4) || blast_hit){
	            				line_dis = _dis;
	            			}
	            		}

	        			blast_hit = false;
                	}
                }
            }
        }

         // Effects:
    	if(_seen && random(160 / _lineAdd) < current_time_scale){
        	if(position_meeting(_cx, _cy, Floor)){
        		var o = 32 * image_yscale;
		        with(instance_create(_cx + orandom(o), _cy + orandom(o), PlasmaTrail)){
		        	sprite_index = spr.QuasarBeamTrail;
		        	motion_add(_dir, 1 + random(max(other.image_yscale - 1, 0)));
		        	if(other.image_yscale > 1) depth = other.depth - 1;
		        }
        	}
    	}

		 // Move:
        _lx = _cx;
        _ly = _cy;
        _cx += lengthdir_x(_lineAdd, _dir);
        _cy += lengthdir_y(_lineAdd, _dir);
        _dis += _lineAdd;

		 // Turn:
		if(ring){
			_dir += (_lineAdd / ring_size);
    	}
        else{
        	_dir = clamp(_dir + (bend / (48 / _lineAdd)), _lineDir - 90, _lineDir + 90);
        }

		 // End:
		if((!ring && _dis >= line_dis) || (ring && abs(_dir - _lineDir) > 360)){
			if(_dis >= line_dis_max){
				blast_hit = false;
			}
			if(ring && array_length(line_seg) > 0){
				array_push(line_seg, line_seg[0]);
				array_push(line_seg, line_seg[1]);
			}
			break;
		}

		_wob++;
    }

     // Effects:
    if(!ring){
	    if(chance_ct(1, 4)){
	        var _xoff = orandom(12) - ((12 * image_xscale) + _lineAdd),
	    		_yoff = orandom(random(28 * image_yscale)),
	    		_x = (_walled ? _lx : _cx) + lengthdir_x(_xoff, _dir) + lengthdir_x(_yoff, _dir - 90),
	    		_y = (_walled ? _ly : _cy) + lengthdir_y(_xoff, _dir) + lengthdir_y(_yoff, _dir - 90);

			if(!position_meeting(_x, _y, TopSmall)){
		        with(instance_create(_x, _y, BulletHit)){
		        	sprite_index = spr.QuasarBeamHit;
		        	image_xscale = other.image_yscale;
		        	image_yscale = other.image_yscale;
		        	depth = other.depth - 1;
		        	instance_create(x, y, Smoke);
		        }
			}
	    }
	    view_shake_max_at(_cx, _cy, 4);
    }
	view_shake_max_at(x, y, 4);

	 // Sound:
    if(!audio_is_playing(loop_snd)){
    	loop_snd = audio_play_sound(sndNothingBeamLoop, 0, true);
    }
    audio_sound_pitch(loop_snd, 0.3 + (0.1 * sin(current_frame / 10)));
    audio_sound_gain(loop_snd, image_xscale, 0);

     // End:
    if(image_xscale <= 0 || image_yscale <= 0) instance_destroy();

#define QuasarBeam_draw
	if(flash_frame > current_frame) draw_set_fog(true, c_white, 0, 0);
	
    QuasarBeam_draw_laser(image_xscale, image_yscale, image_alpha);

	 // Visually Connect Laser to Quasar Ring:
	if(ring){
		with(ring_lasers) if(instance_exists(self)){
	    	draw_set_alpha(image_alpha);
	    	draw_set_color(image_blend);
	    	draw_circle(x - 1, y - 1, 6 * image_yscale, false);
		}
		with(ring_lasers) if(instance_exists(self)){
	    	QuasarBeam_draw();
		}
	    draw_set_alpha(1);
	    
	    var i = 0,
	    	_x1 = null,
	    	_y1 = null,
	    	_x2 = null,
	    	_y2 = null;
	    	
	    with(line_seg){
	    	_x1 = x + (xoff * 2 * other.image_yscale);
	    	_y1 = y + (yoff * 2 * other.image_yscale);
	    	if(_x2 != null){
	    		draw_set_color([c_green, c_blue][i++ % 2]);
	        	///draw_line(_x1, _y1, _x2, _y2);
	    	}
	    	_x2 = _x1;
	    	_y2 = _y1;
	    }
	}
	
	if(flash_frame > current_frame) draw_set_fog(false, 0, 0, 0);

#define QuasarBeam_alrm0
	alarm0 = random_range(4 + (8 * array_length(ring_lasers)), 16);

	 // Laser:
	with(obj_create(x, y, "QuasarBeam")){
		image_angle = random(360);
        team = other.team;
        creator = other.creator;

        spr_strt = -1;
        follow_creator = false;
        line_dir_goal = image_angle + random(orandom(180));
        shrink_delay = min(other.shrink_delay, random_range(10, 120));
        scale_goal = other.scale_goal - random(0.6);
        image_xscale = 0;
        image_yscale = 0;
        visible = false;

        array_push(other.ring_lasers, id);
	}

#define QuasarBeam_hit
    if(lq_defget(hit_list, string(other), 0) <= hit_time){
		speed *= 1 - (0.05 * other.size);

         // Effects:
        with(other){
            repeat(3) instance_create(x, y, Smoke);
            if(other.blast_hit){
        		sleep_max(30);
            	sound_play_hit_ext(sndPlasmaHit, 0.6 + random(0.1), 2);
            }
        }
    
         // Damage:
        var _dir = direction;
        if(place_meeting(x, y, other) || ring){
            _dir = point_direction(x, y, other.x, other.y);
        }
        projectile_hit(
        	other,
        	ceil((damage + (blast_hit * damage * (1 + skill_get(mut_laser_brain)))) * image_yscale),
        	(instance_is(other, prop) ? 0 : force),
        	_dir
        );

         // Set Custom IFrames:
        lq_set(hit_list, string(other), hit_time + (ring ? 3 : 6));
    }

#define QuasarBeam_wall
    // dust

#define QuasarBeam_cleanup
	audio_stop_sound(loop_snd);

#define QuasarBeam_draw_laser(_xscale, _yscale, _alpha)
	var _angle = image_angle,
		_x = x,
		_y = y;

	 // Beam Start:
	if(spr_strt != -1){
		draw_sprite_ext(spr_strt, image_index, _x, _y, _xscale, _yscale, _angle, image_blend, _alpha);
	}

	 // Quasar Ring Core:
	if(ring){
		draw_set_alpha((_alpha < 1) ? (_alpha / 2) : _alpha);
		draw_set_color(image_blend);

		var o = 0;
		repeat(2){
			draw_circle(
				_x - 1 + (o * cos(wave / 8)),
				_y - 1 + (o * sin(wave / 8)),
				((18 * ring_size) + floor(image_index)) * _xscale,
				false
			);
			o = (2 * _xscale * cos(wave / 13)) / max(shrink_delay / 20, 1);
		}

		draw_set_alpha(1);
	}

     // Main Laser:
    if(array_length(line_seg) > 0){
	    draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(sprite_index, image_index));
	    draw_set_alpha(_alpha);
	    draw_set_color(image_blend);

	    with(line_seg){
	        draw_vertex_texture(x + (xoff * _yscale), y + (yoff * _yscale), xtex, ytex);
	    }

	    draw_set_alpha(1);
	    draw_primitive_end();

    	with(line_seg[array_length(line_seg) - 1]){
        	_angle = dir;
	    	_x = x;
	    	_y = y;
	    }
    }

     // Laser End:
    if(spr_stop != -1){
	    var _x1 = x - lengthdir_x(1,				 _angle),
	    	_y1 = y - lengthdir_y(1,				 _angle),
	    	_x2 = x + lengthdir_x(16 / image_xscale, _angle),
	    	_y2 = y + lengthdir_y(16 / image_yscale, _angle);
	
	    if(!collision_line(_x1, _y1, _x2, _y2, TopSmall, false, false)){
	    	draw_sprite_ext(spr_stop, image_index, _x, _y, min(_xscale, 1.25), _yscale, _angle, image_blend, _alpha);
	    }
    }

#define QuasarBeam_wepangle
	if(instance_exists(creator) && abs(angle) > 1){
    	with(creator){
    		if(string_pos("quasar", string(wep_get(other.roids ? bwep : wep))) == 1){
	    		if(other.roids){
	    			bwepangle = other.angle;
	    		}
	    		else{
		    		wepangle = other.angle;
			    	back = (((((gunangle + wepangle) + 360) % 360) > 180) ? -1 : 1);
			    	scrRight(gunangle + wepangle);
	    		}
    		}
    	}
    	angle -= angle * 0.3 * current_time_scale;
	}
	else instance_destroy();


#define QuasarRing_create(_x, _y)
	with(obj_create(_x, _y, "QuasarBeam")){
		 // Visual:
		spr_strt = -1;
		spr_stop = -1;

		 // Vars:
		mask_index = mskExploder;
        follow_creator = false;
        shrink_delay = 120;
		ring = true;
		force = 1;

		 // Alarms:
		alarm0 = 10 + random(20);

		instance_create(x, y, PortalClear);

		return id;
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
        zfriction = 0.3;
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
    z += zspeed * current_time_scale;
    zspeed -= zfriction * current_time_scale;
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
    if(!instance_exists(Spiral)) obj_create(x, y, "BubbleExplosion");


#define WantEel_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		sprite = spr.WantEel;

		 // Vars:
		xpos = x;
		ypos = y;
		x = 0;
		y = 0;
		mask_index = mskNone;
		mask = mskRat;
		maxhealth = 12;
		active = false;
		canfly = true;
		walk = 0;
		walkspeed = 0.6;
		maxspeed = 2.4;
		pit_height = 0;
		alarm1 = 30;
		alarm2 = -1;
		
		return id;	
	}
	
#define WantEel_step
	if(active){
		 // Effects:
		if(chance_ct(1, 30)) with(obj_create(xpos + orandom(6), ypos + orandom(6), "PitSpark")) tentacle_visible = false;
		
	     // Bounce:
	    mask_index = mask;
	    if(place_meeting(xpos + hspeed_raw, ypos + vspeed_raw, Wall)){
	    	if(place_meeting(xpos + hspeed_raw, ypos, Wall)) hspeed_raw *= -1;
	    	if(place_meeting(xpos, ypos + vspeed_raw, Wall)) vspeed_raw *= -1;
	    	scrRight(direction);
	    }
	    mask_index = mskNone;
	    
		 // Rise From Pits:
		pit_height += (0.02 * current_time_scale);
		if(pit_height >= 1){
			 // Become Eel:
			with(obj_create(xpos, ypos, "Eel")){
				
				direction	= other.direction;
				speed		= other.speed;
				right		= other.right;
				walk		= other.walk;
				alarm1		= 30;
			}
			
			 // Effects:
			repeat(3 + irandom(4)) instance_create(xpos, ypos, Bubble);
			repeat(1 + irandom(2)) instance_create(xpos, ypos, PortalL);
			
			instance_delete(id);
		}
	}
	
#define WantEel_end_step
	xpos += hspeed_raw;
	ypos += vspeed_raw;

	if(active){
	     // Floor Collision:
	    mask_index = mask;
	    if(pit_get(xpos, ypos)){
			var f = instances_meeting(xpos, ypos, instances_matching_ne(Floor, "sprite_index", spr.FloorTrenchB));
			if(array_length(f) > 0){
		        xpos -= hspeed_raw;
		        ypos -= vspeed_raw;

		        if(array_length(instances_meeting(xpos + hspeed_raw, ypos, f)) > 0) hspeed_raw *= -1;
		        if(array_length(instances_meeting(xpos, ypos + vspeed_raw, f)) > 0) vspeed_raw *= -1;
		        speed *= 0.5;

		        xpos += hspeed_raw;
		        ypos += vspeed_raw;
		        
		        scrRight(direction);
			}
	    }
	    mask_index = mskNone;
	}
	
#define WantEel_alrm1
	alarm1 = 20 + random(20);
	enemy_target(xpos, ypos);
	
	 // Activate:
	if(!active){
		var _numEels = array_length(instances_matching(CustomEnemy, "name", "Eel"));
		if(
			(chance(1, 3) || _numEels <= 1) &&
			(_numEels + array_length(instances_matching(instances_matching(object_index, "name", name), "active", true))) <= 6 + (4 * GameCont.loops)
		){
			if(instance_exists(target)){
				var _floor = [];
				with(instances_matching(Floor, "sprite_index", spr.FloorTrenchB)){
					if(
						!place_meeting(x, y, Wall)			&&
						!place_meeting(x, y, FloorExplo)	&&
						point_distance(other.target.x, other.target.y, (bbox_left + bbox_right + 1) / 2, (bbox_top + bbox_bottom + 1) / 2) < 160
					){
						array_push(_floor, id);
					}
				}
				
				 // Become Active:
				var f = instance_random(_floor);
				if(instance_exists(f)){
					xpos = (f.bbox_left + f.bbox_right + 1) / 2;
					ypos = (f.bbox_top + f.bbox_bottom + 1) / 2;
					active = true;
					alarm2 = 30;
				}
			}
		}
		else alarm1 = 30 + random(60);
	}

	 // Motionize:
	if(active){
		scrWalk(
			in_sight(target)
				? point_direction(xpos, ypos, target.x, target.y) + orandom(30)
				: random(360),
			[20, 60]
		);
	}
	
#define WantEel_alrm2
	alarm2 = -1;
	enemy_target(xpos, ypos);
	
	 // Watch Out:
	if(in_distance(target, 96)) instance_create(xpos, ypos, AssassinNotice);
	

#define WantPitSquid_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		
		
		return id;
	}
	
#define WantPitSquid_step
	if(!instance_exists(enemy) && instance_exists(Player)){
		with(instance_random(Player)){
			var	l = random_range(128, 256),
				d = random(360);
				
			obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "PitSquid");
		}
		portal_poof();
		instance_destroy();
	}


/// Pits Yo
#define pit_get(_x, _y)
	return global.pit_grid[# _x / 16, _y / 16];

#define pit_set(_x, _y, _bool)
	mod_script_call_nc("area", "trench", "pit_set", _x, _y, _bool);


/// Mod Events
#define step
    if(DebugLag) trace_time();

	 // Bind Angler Trail Drawing:
	var _active = (surfAnglerTrail.frame > current_frame);
	if(_active) script_bind_draw(draw_anglertrail, -3);
	surfAnglerTrail.active = _active;
	surfAnglerClear.active = _active;
	
     // Lightring Trigger Fingers Interaction:
    if(skill_get(mut_trigger_fingers) > 0){
    	var n = array_length(instances_matching_le(enemy, "my_health", 0));
    	if(n > 0){
    		with(instances_matching(instances_matching(CustomProjectile, "name", "LightningDisc"), "is_enemy", false)){
    			if(image_xscale < charge){
    				image_xscale *= (n / 0.6) * skill_get(mut_trigger_fingers);
    				image_xscale = min(image_xscale, charge);
    				image_yscale = image_xscale;
    			}
    		}
    	}
    }

    if(DebugLag) trace_time("tetrench_step");

#define draw_bloom
	if(DebugLag) trace_time();

	 // Canister Bloom:
	with(instances_matching(instances_matching(CustomEnemy, "name", "Angler"), "hiding", true)) if(visible){
        draw_sprite_ext(sprRadChestGlow, image_index, x + (6 * right), y + 8, image_xscale * 2 * right, image_yscale * 2, image_angle, image_blend, image_alpha * 0.1);
    }
    
	 // Lightning Discs:
    with(instances_matching(CustomProjectile, "name", "LightningDisc")) if(visible){
        scrDrawLightningDisc(sprite_index, image_index, x, y, ammo, radius, 2, image_xscale, image_yscale, image_angle + rotation, image_blend, 0.1 * image_alpha);
    }
    
	 // Quasar Beams:
    with(instances_matching(CustomProjectile, "name", "QuasarBeam", "QuasarRing")) if(visible){
    	var _alp = 0.1 * (1 + (skill_get(mut_laser_brain) * 0.5)),
    		_xsc = 2,
    		_ysc = 2;
    		
    	if(blast_hit) _alp *= 1.5 / image_yscale;
    	
    	QuasarBeam_draw_laser(_xsc * image_xscale, _ysc * image_yscale, _alp * image_alpha);

    	if(ring){
    		with(ring_lasers) if(instance_exists(self) && !visible){
    			QuasarBeam_draw_laser(_xsc * image_xscale, _ysc * image_yscale, _alp * image_alpha);
    		}
    	}
    }
    
     // Electroplasma:
    with(instances_matching(CustomProjectile, "name", "ElectroPlasma")) if(visible){
    	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * 0.1);
    }
    
     // Hot Quasar Weapons:
    draw_set_color_write_enable(true, false, false, true);
    with(instances_matching_gt(Player, "reload", 0)){
    	if(visible && array_find_index(["quasar blaster", "quasar rifle", "quasar cannon"], wep_get(wep)) >= 0){
    		var l = -2,
    			d = gunangle - 90,
    			_alpha = image_alpha * (reload / weapon_get_load(wep)) * (1 + (0.2 * skill_get(mut_laser_brain)));

    		draw_weapon(weapon_get_sprt(wep), x + lengthdir_x(l, d), y + lengthdir_y(l, d), gunangle, wepangle, wkick, right, image_blend, _alpha);
    	}
    }
    with(instances_matching_gt(instances_matching(Player, "race", "steroids"), "breload", 0)){ // hey JW why couldnt u make weapons arrays why couldnt you pleas e
    	if(visible && array_find_index(["quasar blaster", "quasar rifle", "quasar cannon"], wep_get(bwep)) >= 0){
    		var l = -4,
    			d = gunangle - 90,
    			_alpha = image_alpha * (breload / weapon_get_load(bwep)) * (1 + (0.2 * skill_get(mut_laser_brain)));

    		draw_weapon(weapon_get_sprt(bwep), x + lengthdir_x(l, d), y + lengthdir_y(l, d) - 2, gunangle, wepangle, bwkick, -right, image_blend, _alpha);
    	}
    }
    draw_set_color_write_enable(true, true, true, true);

     // Pit Spark:
    with(instances_matching(CustomObject, "name", "PitSpark")) if(visible){
    	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * 0.2);
    }
    with(instances_matching(PortalL, "name", "PitSquidL")) if(visible){
    	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * 0.1);
    }

	if(DebugLag) trace_time("tetrench_draw_bloom");

#define draw_shadows
	if(DebugLag) trace_time();

	 // Squid-Launched Floor Chunks:
    with(instances_matching(CustomObject, "name", "TrenchFloorChunk")){
        if(visible && place_meeting(x, y, Floor)){
            var _scale = clamp(1 / ((z / 200) + 1), 0.1, 0.8);
            draw_sprite_ext(sprite_index, image_index, x, y, _scale * image_xscale, _scale * image_yscale, image_angle, image_blend, 1);
        }
    }

	if(DebugLag) trace_time("tetrench_draw_shadows");

#define draw_dark // Drawing Grays
    draw_set_color(c_gray);

	if(DebugLag) trace_time();
	
     // Electroplasma:
    with(instances_matching(CustomProjectile, "name", "ElectroPlasma")) if(visible){
    	draw_circle(x, y, 48, false);
    }

     // Lightning Discs:
    with(instances_matching(CustomProjectile, "name", "LightningDisc", "LightningDiscEnemy")) if(visible){
        draw_circle(x - 1, y - 1, (radius * image_xscale * 3) + 8 + orandom(1), false);
    }

     // Anglers:
    draw_set_fog(true, draw_get_color(), 0, 0);
    with(instances_matching(CustomEnemy, "name", "Angler")) if(visible){
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
    draw_set_fog(false, 0, 0, 0);

     // Jellies:
    with(instances_matching(CustomEnemy, "name", "Jelly", "JellyElite")) if(visible){
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
    with(instances_matching_gt(instances_matching(CustomEnemy, "name", "Eel"), "elite", 0)) if(visible){
        draw_circle(x, y, 48 + orandom(2), false);
    }

     // Kelp:
    with(instances_matching(CustomProp, "name", "Kelp")) if(visible){
        draw_circle(x, y, 32 + orandom(1), false);
    }
    
     // Squid Arms:
    with(instances_matching(CustomEnemy, "name", "PitSquidArm")) if(visible){
    	draw_circle(x, y - 12, 72 + orandom(1), false);
    }
    
     // Pit Squid:
    with(instances_matching_ge(instances_matching(CustomEnemy, "name", "PitSquid"), "pit_height", 1)) if(visible){
        with(eye){
            draw_circle(x, y, ((blink ? 48 : 64) + orandom(1)), false);
        }
    }
    
     // Quasar Beams:
    draw_set_fog(true, draw_get_color(), 0, 0);
    with(instances_matching(CustomProjectile, "name", "QuasarBeam", "QuasarRing")) if(visible){
        var _scale = 5,
        	_xscale = _scale * image_xscale,
        	_yscale = _scale * image_yscale;

        if(!ring){
	        QuasarBeam_draw_laser(_xscale, _yscale, 1);
	
	         // Rounded Ends:
	        var _x = x,
	            _y = y,
	            r = (12 + (1 * ((image_number - 1) - floor(image_index)))) * _yscale;
	
	        draw_circle(_x - lengthdir_x(16 * _xscale, image_angle), _y - lengthdir_y(16 * _xscale, image_angle), r * 1.5, false);
	
	        if(array_length(line_seg) > 0){
	            with(line_seg[array_length(line_seg) - 1]){
	                _x = x - 1 + lengthdir_x(8 * _xscale, dir);
	                _y = y - 1 + lengthdir_y(8 * _xscale, dir);
	            }
	        }
	
	        draw_circle(_x, _y, r, false);
        }
        else{
        	draw_circle(x, y, (280 * ring_size) + random(4), false);
        }
    }
    draw_set_fog(false, 0, 0, 0);

	if(DebugLag) trace_time("tetrench_draw_dark");

#define draw_dark_end // Drawing Clear
    draw_set_color(c_black);

	if(DebugLag) trace_time();
	
     // Electroplasma:
    with(instances_matching(CustomProjectile, "name", "ElectroPlasma")) if(visible){
    	draw_circle(x, y, 24, false);
    }

     // Lightning Discs:
    with(instances_matching(CustomProjectile, "name", "LightningDisc", "LightningDiscEnemy")) if(visible){
        draw_circle(x - 1, y - 1, (radius * image_xscale * 1.5) + 4 + orandom(1), false);
    }

     // Anglers:
    draw_set_blend_mode(bm_subtract);
    with(instances_matching(CustomEnemy, "name", "Angler")) if(visible){
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
    with(instances_matching(CustomEnemy, "name", "Jelly", "JellyElite")) if(visible){
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
    with(instances_matching_gt(instances_matching(CustomEnemy, "name", "Eel"), "elite", 0)) if(visible){
        draw_circle(x, y, (elite / 2) + 3 + orandom(2), false);
    }
    
     // Squid Arms:
    with(instances_matching(CustomEnemy, "name", "PitSquidArm")) if(visible){
    	draw_circle(x, y - 12, 24 + orandom(1), false);
    }
    
     // Pit Squid:
    with(instances_matching_ge(instances_matching(CustomEnemy, "name", "PitSquid"), "pit_height", 1)) if(visible){
        with(eye) if(!blink){
            draw_circle(x, y, 32 + orandom(1), false);
    	}
    }
    
	 // Quasar Beams:
    draw_set_fog(true, draw_get_color(), 0, 0);
    with(instances_matching(CustomProjectile, "name", "QuasarBeam", "QuasarRing")) if(visible){
        var _scale = 2,
        	_xscale = _scale * image_xscale,
        	_yscale = _scale * image_yscale;

        if(!ring){
        	QuasarBeam_draw_laser(_xscale, _yscale, 1);
	
	         // Rounded Ends:
	        var _x = x,
	            _y = y,
	            r = (12 + (1 * ((image_number - 1) - floor(image_index)))) * _yscale;
	
	        draw_circle(_x - lengthdir_x(16 * _xscale, image_angle), _y - lengthdir_y(16 * _xscale, image_angle), r * 1.5, false);
	
	        if(array_length(line_seg) > 0){
	            with(line_seg[array_length(line_seg) - 1]){
	                _x = x - 1 + lengthdir_x(8 * _xscale, dir);
	                _y = y - 1 + lengthdir_y(8 * _xscale, dir);
	            }
	        }
	
	        draw_circle(_x, _y, r, false);
        }
        else{
        	draw_circle(x, y, (120 * ring_size) + random(4), false);
        }
    }
    draw_set_fog(false, 0, 0, 0);

	if(DebugLag) trace_time("tetrench_draw_dark_end");
	
#define draw_anglertrail
    var _surfTrail = surfAnglerTrail,
    	_surfClear = surfAnglerClear;

	if(surface_exists(_surfTrail.surf) && surface_exists(_surfClear.surf)){
		if(DebugLag) trace_time();

		 // Surface Follow Screen:
		with(_surfTrail){
			x = floor(view_xview_nonsync / game_width) * game_width;
			y = floor(view_yview_nonsync / game_height) * game_height;
			w = game_width * 2;
			h = game_height * 2;
			with(_surfClear){
				w = other.w;
				h = other.h;
			}
			
			 // Make sure it clear bro:
			if(reset){
				reset = false;
				surface_set_target(surf);
				draw_clear_alpha(0, 0);
				surface_reset_target();
			}
		}

	     // Clear Trail Surface Over Time:
	    if(frame_active(1)){
	    	with(_surfClear){
		        surface_set_target(surf);
		        draw_clear(c_black);
	
		        draw_set_blend_mode(bm_subtract);
		        draw_surface(_surfTrail.surf, 0, 0);
		        with(other) draw_sprite_tiled(sprStreetLight, 0, irandom(128), irandom(128));
	
		        surface_set_target(_surfTrail.surf);
		        for(var a = 0; a < 360; a += 90){
		            draw_surface(surf, lengthdir_x(1, a), lengthdir_y(1, a));
		        }
		        draw_set_blend_mode(bm_normal);
		    	surface_reset_target();
	    	}
	    }
	
	     // Main Trail Surface:
	    with(_surfTrail){
	    	 // Draw Trails:
		    surface_set_target(surf);
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
		                _alpha = image_alpha,
						_charm = (_blend == c_white && "charm" in self && lq_defget(charm, "charmed", true));
	
		        	if(_charm) draw_set_fog(true, make_color_rgb(56, 252, 0), 0, 0);
	
		            for(var o = 0; o <= _dis; o++){
		                draw_sprite_ext(_spr, _img, _x1 + lengthdir_x(o, _dir) - other.x, _y1 + lengthdir_y(o, _dir) - other.y, _xscal, _yscal, _angle, _blend, _alpha);
		            }
	
		            if(_charm) draw_set_fog(false, 0, 0, 0);
		        }
		    }
		    //d3d_set_fog(0, 0, 0, 0);
		    surface_reset_target();

	    	 // Draw Surface:
		    //d3d_set_fog(1, make_color_rgb(252, 56, 0), 0, 0);
		    draw_set_blend_mode(bm_add);
		    draw_surface(surf, x, y);
		    draw_set_blend_mode(bm_normal);
		    //d3d_set_fog(0, 0, 0, 0);
	    }

		if(DebugLag) trace_time("tetrench_draw_anglertrail");
	}

    instance_destroy();
    

/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  anim_end                                                                                image_index + image_speed_raw >= image_number
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define in_range(_num, _lower, _upper)                                                  return  (_num >= _lower && _num <= _upper);
#define frame_active(_interval)                                                         return  (current_frame % _interval) < current_time_scale;
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define surflist_set(_name, _x, _y, _width, _height)                                    return  mod_script_call_nc('mod', 'teassets', 'surflist_set', _name, _x, _y, _width, _height);
#define surflist_get(_name)                                                             return  mod_script_call_nc('mod', 'teassets', 'surflist_get', _name);
#define shadlist_set(_name, _vertex, _fragment)                                         return  mod_script_call_nc('mod', 'teassets', 'shadlist_set', _name, _vertex, _fragment);
#define shadlist_get(_name)                                                             return  mod_script_call_nc('mod', 'teassets', 'shadlist_get', _name);
#define shadlist_setup(_shader, _texture, _args)                                        return  mod_script_call_nc('mod', 'telib', 'shadlist_setup', _shader, _texture, _args);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define top_create(_x, _y, _obj, _spawnDir, _spawnDis)                                  return  mod_script_call_nc('mod', 'telib', 'top_create', _x, _y, _obj, _spawnDir, _spawnDis);
#define option_get(_name, _default)                                                     return  mod_script_call_nc('mod', 'telib', 'option_get', _name, _default);
#define option_set(_name, _value)                                                               mod_script_call_nc('mod', 'telib', 'option_set', _name, _value);
#define stat_get(_name)                                                                 return  mod_script_call_nc('mod', 'telib', 'stat_get', _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc('mod', 'telib', 'stat_set', _name, _value);
#define unlock_get(_name)                                                               return  mod_script_call_nc('mod', 'telib', 'unlock_get', _name);
#define unlock_set(_name, _value)                                                               mod_script_call_nc('mod', 'telib', 'unlock_set', _name, _value);
#define unlock_call(_name)                                                              return  mod_script_call_nc('mod', 'telib', 'unlock_call', _name);
#define unlock_splat(_name, _text, _sprite, _sound)                                     return  mod_script_call_nc('mod', 'telib', 'unlock_splat', _name, _text, _sprite, _sound);
#define trace_error(_error)                                                                     mod_script_call_nc('mod', 'telib', 'trace_error', _error);
#define view_shift(_index, _dir, _pan)                                                          mod_script_call_nc('mod', 'telib', 'view_shift', _index, _dir, _pan);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc('mod', 'telib', 'sleep_max', _milliseconds);
#define dfloor(_num, _div)                                                              return  mod_script_call_nc('mod', 'telib', 'dfloor', _num, _div);
#define in_distance(_inst, _dis)                                                        return  mod_script_call(   'mod', 'telib', 'in_distance', _inst, _dis);
#define in_sight(_inst)                                                                 return  mod_script_call(   'mod', 'telib', 'in_sight', _inst);
#define instance_budge(_objAvoid, _disMax)                                              return  mod_script_call(   'mod', 'telib', 'instance_budge', _objAvoid, _disMax);
#define instance_random(_obj)                                                           return  mod_script_call_nc('mod', 'telib', 'instance_random', _obj);
#define instance_create_copy(_x, _y, _obj)                                              return  mod_script_call(   'mod', 'telib', 'instance_create_copy', _x, _y, _obj);
#define instance_create_lq(_x, _y, _lq)                                                 return  mod_script_call_nc('mod', 'telib', 'instance_create_lq', _x, _y, _lq);
#define instance_nearest_array(_x, _y, _inst)                                           return  mod_script_call_nc('mod', 'telib', 'instance_nearest_array', _x, _y, _inst);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc('mod', 'telib', 'instance_rectangle', _x1, _y1, _x2, _y2, _obj);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call_nc('mod', 'telib', 'instance_rectangle_bbox', _x1, _y1, _x2, _y2, _obj);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call_nc('mod', 'telib', 'instances_at', _x, _y, _obj);
#define instances_seen_nonsync(_obj, _bx, _by)                                          return  mod_script_call_nc('mod', 'telib', 'instances_seen_nonsync', _obj, _bx, _by);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   'mod', 'telib', 'instances_meeting', _x, _y, _obj);
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call_nc('mod', 'telib', 'draw_weapon', _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call_nc('mod', 'telib', 'draw_lasersight', _x, _y, _dir, _maxDistance, _width);
#define draw_text_bn(_x, _y, _string, _angle)                                                   mod_script_call_nc('mod', 'telib', 'draw_text_bn', _x, _y, _string, _angle);
#define array_exists(_array, _value)                                                    return  mod_script_call_nc('mod', 'telib', 'array_exists', _array, _value);
#define array_count(_array, _value)                                                     return  mod_script_call_nc('mod', 'telib', 'array_count', _array, _value);
#define array_combine(_array1, _array2)                                                 return  mod_script_call_nc('mod', 'telib', 'array_combine', _array1, _array2);
#define array_delete(_array, _index)                                                    return  mod_script_call_nc('mod', 'telib', 'array_delete', _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call_nc('mod', 'telib', 'array_delete_value', _array, _value);
#define array_flip(_array)                                                              return  mod_script_call_nc('mod', 'telib', 'array_flip', _array);
#define array_shuffle(_array)                                                           return  mod_script_call_nc('mod', 'telib', 'array_shuffle', _array);
#define array_clone_deep(_array)                                                        return  mod_script_call_nc('mod', 'telib', 'array_clone_deep', _array);
#define lq_clone_deep(_obj)                                                             return  mod_script_call_nc('mod', 'telib', 'lq_clone_deep', _obj);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc('mod', 'telib', 'scrFX', _x, _y, _motion, _obj);
#define scrRight(_dir)                                                                          mod_script_call(   'mod', 'telib', 'scrRight', _dir);
#define scrWalk(_dir, _walk)                                                                    mod_script_call(   'mod', 'telib', 'scrWalk', _dir, _walk);
#define scrAim(_dir)                                                                            mod_script_call(   'mod', 'telib', 'scrAim', _dir);
#define enemy_walk(_spdAdd, _spdMax)                                                            mod_script_call(   'mod', 'telib', 'enemy_walk', _spdAdd, _spdMax);
#define enemy_hurt(_hitdmg, _hitvel, _hitdir)                                                   mod_script_call(   'mod', 'telib', 'enemy_hurt', _hitdmg, _hitvel, _hitdir);
#define enemy_shoot(_object, _dir, _spd)                                                return  mod_script_call(   'mod', 'telib', 'enemy_shoot', _object, _dir, _spd);
#define enemy_shoot_ext(_x, _y, _object, _dir, _spd)                                    return  mod_script_call(   'mod', 'telib', 'enemy_shoot_ext', _x, _y, _object, _dir, _spd);
#define enemy_target(_x, _y)                                                            return  mod_script_call(   'mod', 'telib', 'enemy_target', _x, _y);
#define boss_hp(_hp)                                                                    return  mod_script_call_nc('mod', 'telib', 'boss_hp', _hp);
#define boss_intro(_name, _sound, _music)                                               return  mod_script_call_nc('mod', 'telib', 'boss_intro', _name, _sound, _music);
#define corpse_drop(_dir, _spd)                                                         return  mod_script_call(   'mod', 'telib', 'corpse_drop', _dir, _spd);
#define rad_drop(_x, _y, _raddrop, _dir, _spd)                                          return  mod_script_call_nc('mod', 'telib', 'rad_drop', _x, _y, _raddrop, _dir, _spd);
#define rad_path(_inst, _target)                                                        return  mod_script_call_nc('mod', 'telib', 'rad_path', _inst, _target);
#define area_get_name(_area, _subarea, _loop)                                           return  mod_script_call_nc('mod', 'telib', 'area_get_name', _area, _subarea, _loop);
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call_nc('mod', 'telib', 'area_get_sprite', _area, _spr);
#define area_get_subarea(_area)                                                         return  mod_script_call_nc('mod', 'telib', 'area_get_subarea', _area);
#define area_get_secret(_area)                                                          return  mod_script_call_nc('mod', 'telib', 'area_get_secret', _area);
#define area_get_underwater(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_underwater', _area);
#define area_border(_y, _area, _color)                                                  return  mod_script_call_nc('mod', 'telib', 'area_border', _y, _area, _color);
#define area_generate(_area, _subarea, _x, _y)                                          return  mod_script_call_nc('mod', 'telib', 'area_generate', _area, _subarea, _x, _y);
#define area_generate_ext(_area, _subarea, _x, _y, _overlapFloor, _scriptSetup)         return  mod_script_call_nc('mod', 'telib', 'area_generate_ext', _area, _subarea, _x, _y, _overlapFloor, _scriptSetup);
#define floor_get(_x, _y)                                                               return  mod_script_call_nc('mod', 'telib', 'floor_get', _x, _y);
#define floor_set(_x, _y, _state)                                                       return  mod_script_call_nc('mod', 'telib', 'floor_set', _x, _y, _state);
#define floor_fill(_x, _y, _w, _h)                                                      return  mod_script_call_nc('mod', 'telib', 'floor_fill', _x, _y, _w, _h);
#define floor_fill_round(_x, _y, _w, _h)                                                return  mod_script_call_nc('mod', 'telib', 'floor_fill_round', _x, _y, _w, _h);
#define floor_fill_ring(_x, _y, _w, _h)                                                 return  mod_script_call_nc('mod', 'telib', 'floor_fill_ring', _x, _y, _w, _h);
#define floor_make(_x, _y, _obj)                                                        return  mod_script_call_nc('mod', 'telib', 'floor_make', _x, _y, _obj);
#define floor_set_style(_style, _area)                                                  return  mod_script_call_nc('mod', 'telib', 'floor_set_style', _style, _area);
#define floor_reset_style()                                                             return  mod_script_call_nc('mod', 'telib', 'floor_reset_style');
#define floor_reveal(_floors, _maxTime)                                                 return  mod_script_call_nc('mod', 'telib', 'floor_reveal', _floors, _maxTime);
#define floor_bones(_sprite, _num, _chance, _linked)                                    return  mod_script_call(   'mod', 'telib', 'floor_bones', _sprite, _num, _chance, _linked);
#define floor_walls()                                                                   return  mod_script_call(   'mod', 'telib', 'floor_walls');
#define wall_tops()                                                                     return  mod_script_call(   'mod', 'telib', 'wall_tops');
#define wall_clear(_x1, _y1, _x2, _y2)                                                          mod_script_call_nc('mod', 'telib', 'wall_clear', _x1, _y1, _x2, _y2);
#define sound_play_ntte(_type, _snd)                                                    return  mod_script_call_nc('mod', 'telib', 'sound_play_ntte', _type, _snd);
#define sound_play_hit_ext(_snd, _pit, _vol)                                            return  mod_script_call(   'mod', 'telib', 'sound_play_hit_ext', _snd, _pit, _vol);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call(   'mod', 'telib', 'race_get_sprite', _race, _sprite);
#define player_create(_x, _y, _index)                                                   return  mod_script_call_nc('mod', 'telib', 'player_create', _x, _y, _index);
#define player_swap()                                                                   return  mod_script_call(   'mod', 'telib', 'player_swap');
#define wep_get(_wep)                                                                   return  mod_script_call_nc('mod', 'telib', 'wep_get', _wep);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc('mod', 'telib', 'wep_merge', _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call_nc('mod', 'telib', 'wep_merge_decide', _hardMin, _hardMax);
#define weapon_decide(_hardMin, _hardMax, _gold, _noWep)                                return  mod_script_call(   'mod', 'telib', 'weapon_decide', _hardMin, _hardMax, _gold, _noWep);
#define skill_get_icon(_skill)                                                          return  mod_script_call(   'mod', 'telib', 'skill_get_icon', _skill);
#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)                        return  mod_script_call_nc('mod', 'telib', 'path_create', _xstart, _ystart, _xtarget, _ytarget, _wall);
#define path_shrink(_path, _wall, _skipMax)                                             return  mod_script_call_nc('mod', 'telib', 'path_shrink', _path, _wall, _skipMax);
#define path_reaches(_path, _xtarget, _ytarget, _wall)                                  return  mod_script_call_nc('mod', 'telib', 'path_reaches', _path, _xtarget, _ytarget, _wall);
#define path_direction(_path, _x, _y, _wall)                                            return  mod_script_call_nc('mod', 'telib', 'path_direction', _path, _x, _y, _wall);
#define path_draw(_path)                                                                return  mod_script_call(   'mod', 'telib', 'path_draw', _path);
#define portal_poof()                                                                   return  mod_script_call_nc('mod', 'telib', 'portal_poof');
#define portal_pickups()                                                                return  mod_script_call_nc('mod', 'telib', 'portal_pickups');
#define pet_spawn(_x, _y, _name)                                                        return  mod_script_call_nc('mod', 'telib', 'pet_spawn', _x, _y, _name);
#define pet_get_icon(_modType, _modName, _name)                                         return  mod_script_call(   'mod', 'telib', 'pet_get_icon', _modType, _modName, _name);
#define team_get_sprite(_team, _sprite)                                                 return  mod_script_call_nc('mod', 'telib', 'team_get_sprite', _team, _sprite);
#define team_instance_sprite(_team, _inst)                                              return  mod_script_call_nc('mod', 'telib', 'team_instance_sprite', _team, _inst);
#define sprite_get_team(_sprite)                                                        return  mod_script_call_nc('mod', 'telib', 'sprite_get_team', _sprite);
#define scrPickupIndicator(_text)                                                       return  mod_script_call(   'mod', 'telib', 'scrPickupIndicator', _text);
#define scrAlert(_inst, _sprite)                                                        return  mod_script_call(   'mod', 'telib', 'scrAlert', _inst, _sprite);
#define TopDecal_create(_x, _y, _area)                                                  return  mod_script_call_nc('mod', 'telib', 'TopDecal_create', _x, _y, _area);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   'mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_instance, _charm)                                               return  mod_script_call_nc('mod', 'telib', 'charm_instance', _instance, _charm);