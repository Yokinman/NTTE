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
#macro opt sav.option

#macro DebugLag global.debug_lag

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index + image_speed_raw >= image_number)


#define InvMortar_create(_x, _y)
    with(obj_create(_x, _y, "Mortar")){
         // Visual:
		spr_idle = spr.InvMortarIdle;
		spr_walk = spr.InvMortarWalk;
		spr_fire = spr.InvMortarFire;
		spr_hurt = spr.InvMortarHurt;
		spr_dead = spr.InvMortarDead;
		sprite_index = spr_idle;
		hitid = [spr_idle, "@p@qC@qU@qR@qS@qE@qD @qM@qO@qR@qT@qA@qR"];
		
		 // Sounds:
		snd_hurt = choose(sndBanditHit, sndBigMaggotHit, sndScorpionHit, sndRatHit, sndGatorHit, sndRavenHit, sndSalamanderHurt, sndSniperHit);
		snd_dead = choose(sndBanditDie, sndBigMaggotDie, sndScorpionDie, sndRatDie, sndGatorDie, sndRavenDie, sndSalamanderDead);
		  
		 // Vars:
		inv = true;  

    	return id;
    }


#define Mortar_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
         // Visual:
        spr_idle = spr.MortarIdle;
		spr_walk = spr.MortarWalk;
		spr_fire = spr.MortarFire;
		spr_hurt = spr.MortarHurt;
		spr_dead = spr.MortarDead;
		spr_weap = mskNone;
		spr_shadow = shd48;
		spr_shadow_y = 4;
		mask_index = mskSpider;
		hitid = [spr_idle, "MORTAR"];
		depth = -4;

         // Sound:
		snd_hurt = sndLaserCrystalHit;
		snd_dead = sndLaserCrystalDeath;

		 // Vars:
		maxhealth = 75;
		raddrop = 30;
		size = 3;
		walk = 0;
		walkspeed = 0.8;
		maxspeed = 2;
		ammo = 4;
		target_x = x;
		target_y = y;
		gunangle = random(360);
		direction = gunangle;
		inv = false;

         // Alarms:
		alarm1 = 100 + irandom(40);
		alarm2 = -1;

		 // NTTE:
		ntte_anim = false;

        return id;
    }

#define Mortar_step
     // Animate:
    if(sprite_index != spr_hurt && sprite_index != spr_fire){
    	if(speed <= 0) sprite_index = spr_idle;
    	else if(sprite_index == spr_idle) sprite_index = spr_walk;
    }
    else{
         // End Hurt Sprite:
        if(sprite_index = spr_hurt && image_index > 2) sprite_index = spr_idle;

         // End Fire Sprite:
        if(sprite_index = spr_fire && (image_index > sprite_get_number(spr_fire) - 1)){
            sprite_index = spr_idle;
        }
    }

     // Charging effect:
    if(sprite_index == spr_fire && chance_ct(1, 5)){
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
    
     // Curse Particles:
    if(inv){
		if(chance_ct(1, 3)) instance_create(x + orandom(8), y + orandom(8), Curse);
    }

#define Mortar_draw
     // Flash White w/ Hurt While Firing:
    if(
        sprite_index == spr_fire &&
        nexthurt > current_frame &&
        (nexthurt + current_frame) mod (room_speed/10) = 0
    ){
        d3d_set_fog(true, image_blend, 0, 0);
        draw_self_enemy();
        d3d_set_fog(false, c_black, 0, 0);
    }

     // Normal Self:
    else draw_self_enemy();

#define Mortar_alrm1
    alarm1 = 80 + random(20);
    target = instance_nearest(x, y, Player);

     // Near Target:
    if(in_distance(target, 240)){
        var _targetDir = point_direction(x, y, target.x, target.y);

         // Attack:
        if(chance(1, 3)){
            alarm2 = 26;
	        target_x = target.x;
	        target_y = target.y;
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
	target = instance_nearest(x, y, Player);

	 // Start:
	if(ammo <= 0){
		if(instance_exists(target)){
	        target_x = target.x;
	        target_y = target.y;
		}
        ammo = 4;
	}

    if(ammo > 0){
        var	_tx = target_x + orandom(16),
        	_ty = target_y + orandom(16),
        	_targetDir = point_direction(x, y, _tx, _ty);
        	
         // Sound:
        sound_play(sndCrystalTB);
        sound_play(sndPlasma);
        
         // Facing:
        scrRight(_targetDir);
        
         // Shoot Mortar:
        with(scrEnemyShootExt(x + (5 * right), y, "MortarPlasma", _targetDir, 3)){
            z += 18;
            var d = point_distance(x, y, _tx, _ty) / speed;
            zspeed = (d * zfriction * 0.5) - (z / d);

             // Cool particle line
            var _x = x,
                _y = y,
                _z = z,
                _zspd = zspeed,
                _zfrc = zfriction,
                i = 0;

            while(_z > 0){
                with(instance_create(_x, _y - _z, BoltTrail)){
                    image_angle = point_direction(x, y, _x + other.hspeed, _y + other.vspeed - (_z + _zspd));
                    image_xscale = point_distance(x, y, _x + other.hspeed, _y + other.vspeed - (_z + _zspd));
                    image_yscale = random(1.5);
                    image_blend = make_color_rgb(235, 0, 67);
                    depth = -8;
                    if(chance(1, 6)){
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

		 // Aim After Target:
		if(in_sight(target)){
			var	l = 32,
				d = point_direction(target_x, target_y, target.x, target.y);
	
			target_x += lengthdir_x(l, d);
			target_y += lengthdir_y(l, d);
		}

        if(--ammo > 0) alarm2 = 4;
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
    
	     // Cursed Mortar Behavior:
	    if(inv && my_health > 0 && chance(_hitdmg / 25, 1)){
	        var _enemies = instances_matching_ne(enemy, "name", name),
	        	_x = x,
	        	_y = y;
	
	         // Swap places with another dude:
	        if(array_length(_enemies) > 0){
	            with(instance_random(_enemies)){
	                other.x = x;
	                other.y = y;
	                x = _x;
	                y = _y;
	
	                 // Unstick from walls by annihilating them:
	                instance_create(x, y, PortalClear).mask_index = mask_index;
	
	                 // Effects:
					nexthurt = current_frame + 6;
	                sprite_index = spr_hurt;
	                image_index = 0;
	            }
	
	             // Unstick from walls by annihilating them:
	            instance_create(x, y, PortalClear).mask_index = mask_index;
	        }
	    }
    }

#define Mortar_death
	pickup_drop(30, 35);
	pickup_drop(30, 0);


#define MortarPlasma_create(_x, _y)
    with(instance_create(_x, _y, CustomProjectile)){
         // Visual:
        sprite_index = spr.MortarPlasma;
        mask_index = mskNone;
	    depth = -8;

         // Vars:
        z = 1;
        zspeed = 0;
        zfriction = 0.4; // 0.8
        damage = 0;
        force = 0;

        return id;
    }

#define MortarPlasma_step
    z_engine();

     // Facing:
    if((direction >= 30 && direction <= 150) || (direction >= 210 && direction <= 330)){
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
    if(chance_ct(1, 2)){
        with(instance_create(x + orandom(4), y - z + orandom(4), PlasmaTrail)) {
            sprite_index = spr.MortarTrail;
            depth = other.depth;
        }
    }

     // Hit:
    if(z <= 0 || (z <= 8 && position_meeting(x, y + 8, Wall))){
    	instance_destroy();
    }

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
        
         // Over Wall:
        if(position_meeting(x, y + 8, Wall) || !position_meeting(x, y + 8, Floor)){
        	depth = -8;
        }
    }

     // Effects:
    view_shake_at(x, y, 8);
    sound_play(sndPlasmaHit);


#define NewCocoon_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
         // Visual:
		spr_idle = sprCocoon;
		spr_hurt = sprCocoonHurt;
		spr_dead = sprCocoonDead;
		spr_shadow = shd24;

         // Sound:
		snd_dead = sndCocoonBreak;

         // Vars:
		maxhealth = 6;
		nexthurt = current_frame;
		size = 1;

		return id;
	}

#define NewCocoon_death
	 // Bits:
	var _ang = random(360);
	for(var d = _ang; d < _ang + 360; d += (360 / 5)){
		with(scrFX(x, y, [d, 1.5], Feather)){
			sprite_index = spr.PetSpiderWebBits;
			image_blend = make_color_rgb(165, 165, 165);
			image_angle = orandom(30);
			image_index = irandom(image_number - 1);
			image_speed = 0;
			rot /= 2;
		}
	}
	
	 // O no:
	if(chance(1, 30)){
		with(obj_create(x, y, "Seal")){
			nexthurt = current_frame + 15;
		}
	}
	
	 // Hatch 1-3 Spiders:
	else if(chance(4, 5)){
		repeat(irandom_range(1, 3)) {
			obj_create(x, y, "Spiderling");
		}
	}
	
	 // Normal:
	else{
		instance_change(Cocoon, false);
		instance_destroy();
	}


#define Spiderling_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
         // Visual:
        spr_idle = spr.SpiderlingIdle;
		spr_walk = spr.SpiderlingWalk;
		spr_hurt = spr.SpiderlingHurt;
		spr_dead = spr.SpiderlingDead;
		spr_hatch = spr.SpiderlingHatch;
		spr_shadow = shd16;
		spr_shadow_y = 2;
		mask_index = mskMaggot;
		hitid = [spr_idle, "SPIDERLING"];
		depth = -2;

         // Sound:
		snd_hurt = sndSpiderHurt;
		snd_dead = sndSpiderDead;

		 // Vars:
		maxhealth = 4;
		raddrop = 2;
		size = 1;
		walk = 0;
		walkspeed = 0.8;
		maxspeed = 3;
		nexthurt = current_frame + 15;
		direction = random(360);

		 // Cursed:
		curse = (GameCont.area == 104);
		if(curse){
	        spr_idle = spr.InvSpiderlingIdle;
			spr_walk = spr.InvSpiderlingWalk;
			spr_hurt = spr.InvSpiderlingHurt;
			spr_dead = spr.InvSpiderlingDead;
			spr_hatch = spr.InvSpiderlingHatch;
			snd_hurt = choose(sndHitFlesh, sndBanditHit, sndFastRatHit);
			snd_dead = choose(sndEnemyDie, sndBanditDie, sndFastRatDie);
		}
		
         // Alarms:
		alarm0 = irandom_range(60, 150);
		alarm1 = irandom_range(20, 40);
		
		var n = instance_nearest(x, y, Player);
		if(instance_exists(n)) alarm0 += point_distance(x, y, n.x, n.y);

		return id;
    }

#define Spiderling_alrm0
     // Shhh dont tell anybody
    var _obj = ((GameCont.area == 104) ? InvSpider : Spider);
    with(instance_create(x, y, _obj)){
        x = other.x;
        y = other.y;
        creator = other;
        right = other.right;
        alarm1 = 10 + random(10);
    }

     // Effects:
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
        with(obj_create(x, y, "CatDoorDebris")){
            sprite_index = other.spr_hatch;
            image_index = irandom(image_number - 1);
            direction = a + orandom(30);
            speed += 1 + random(4);
        }
    }
    sound_play_hit(sndHitRock, 0.3);
    sound_play_hit(sndBouncerBounce, 0.5);
    sound_play_pitchvol(sndCocoonBreak, 2 + random(1), 0.8);

    instance_delete(id);

#define Spiderling_alrm1
    alarm1 = 10 + irandom(10);
    
    target = nearest_instance(x, y, [Player, CrystalProp, InvCrystal]);

	 // Cursed:
	if(curse) instance_create(x, y, Curse);

     // Move towards player:
    if(in_sight(target) && in_distance(target, 96)){
        scrWalk(14, point_direction(x, y, target.x, target.y) + orandom(20));
        if(instance_is(target, prop)){
        	direction += orandom(60);
        	alarm1 *= random_range(1, 2);
        }
    }

     // Wander:
    else scrWalk(12, direction + orandom(20));

#define Spiderling_death
	pickup_drop(15, 0);
	
	 // Dupe Time:
	var _chance = 2/3 * curse;
	if(chance(_chance, 1)){
		speed = min(1, speed);
		repeat(3 * max(1, _chance)) with(obj_create(x, y, "Spiderling")){
			sprite_index = spr_hurt;
			alarm0 = ceil(other.alarm0 / 2);
			curse = other.curse / 2;
			kills = other.kills;
			raddrop = 0;
		}
	}


#define SpiderWall_create(_x, _y)
    with(instance_create(_x, _y, CustomObject)){
         // Visual:
        topspr = spr.SpiderWallFakeTop;
        botspr = sprWall4Bot;
        topindex = 0;
        botindex = 0;
        
         // Vars:
        mask_index = mskWall;
        creator = noone;
        special = false;
        setup = true;
        
        return id;
    }

#define SpiderWall_setup
	setup = false;
	
	 // Sprites:
	topspr = (special ? spr.SpiderWallMainTop : spr.SpiderWallFakeTop);
	botspr = (special ? spr.SpiderWallMainBot : sprWall4Bot);
	topindex = irandom(sprite_get_number(topspr) - 1);
	botindex = irandom(sprite_get_number(botspr) - 1);
	with(creator){
		topspr = other.topspr;
        topindex = other.topindex;
        sprite_index = other.botspr;
        image_index = other.botindex;
	}
	
	 // No Duplicates:
	with(instances_matching_gt(instances_matching(instances_matching(CustomObject, "name", name), "creator", creator), "id", id)){
		instance_destroy();
	}

#define SpiderWall_step
	if(setup) SpiderWall_setup();
	
	 // Sparklin:
	if(special && chance_ct(1, 90)){
		with(instance_create(x + random_range(-4, 20), y - 8 + random_range(-4, 20), CaveSparkle)){
			sprite_index = spr.PetSparkle;
			depth = -9;
		}
	}
	
	 // Spawn:
    if(!instance_exists(creator) && !place_meeting(x, y, Explosion)){
    	 // Spawn:
    	if(position_meeting(x + 8, y + 8, FloorExplo)){
    		
	         // Special Spider:
	        if(special){
	        	with(Pet_spawn(x + 8, y + 8, "Spider")){
	        		sprite_index = spr_hurt;
    				sound_play_hit_ext(sndSpiderMelee, 0.6 + random(0.2), 2);
	        	}
	        }
	        
	         // Spiderlings:
	        else repeat(irandom_range(1, 3)){
	        	if(chance(3, 5)){
	        		with(obj_create(x + 8, y + 8, "Spiderling")){
	        			sprite_index = spr_hurt;
    					sound_play_hit_ext(sndSpiderHurt, 0.5 + random(0.3), 2);
	        		}
	        	}
	        	
	        	 // Sparkle:
	        	with(instance_create(x + random(16), y + orandom(8), CaveSparkle)){
					sprite_index = spr.PetSparkle;
					depth = -3;
				}
	        }
    	}
        
        instance_destroy();
    }


/// Mod Events:
#define step
	script_bind_end_step(end_step, 0);

#define end_step
    if(DebugLag) trace_time();

     // Spider Cocoons:
    with(Cocoon){
    	obj_create(x, y, "NewCocoon");
    	instance_delete(id);
    }
    
     // Scramble Cursed Caves Weapons:
	with(instances_matching(WepPickup, "cursedcavescramble_check", null)){
    	cursedcavescramble_check = false;
    	if(GameCont.area == 104){
			if(roll && wep_get(wep) != "merge"){
				if(!position_meeting(xstart, ystart, ChestOpen) || chance(1, 3)){
					cursedcavescramble_check = true;
					mergewep_indicator = null;
					
					curse = max(1, curse);
	
					var _part = wep_merge_decide(0, GameCont.hard + (2 * curse));
					if(array_length(_part) >= 2){
						wep = wep_merge(_part[0], _part[1]);
					}
				}
			}
    	}
	}
    
    if(DebugLag) trace_time("tecaves_end_step");
    
	instance_destroy();

#define draw_shadows
	if(DebugLag) trace_time();

	 // Mortar Plasma:
    with(instances_matching(CustomProjectile, "name", "MortarPlasma")) if(visible){
    	if(position_meeting(x, y, Floor)){
	        var _percent = clamp(96 / z, 0.1, 1),
	            _w = ceil(18 * _percent),
	            _h = ceil(6 * _percent),
	            _x = x,
	            _y = y;
	            
	        draw_ellipse(_x - (_w / 2), _y - (_h / 2), _x + (_w / 2), _y + (_h / 2), false);
    	}
    }

	if(DebugLag) trace_time("tecaves_draw_shadows");

#define draw_dark // Drawing Grays
    draw_set_color(c_gray);

	if(DebugLag) trace_time();

     // Mortar:
    with(instances_matching(CustomEnemy, "name", "Mortar", "InvMortar")) if(visible){
        if(sprite_index == spr_fire){
            draw_circle(x + (6 * right), y - 16, 48 - alarm1 + orandom(4), false)
        }
    }

     // Mortar Plasma:
    with(instances_matching(CustomProjectile, "name", "MortarPlasma")) if(visible){
        draw_circle(x, y - z, 64 + orandom(1), false);
    }

	if(DebugLag) trace_time("tecaves_draw_dark");

#define draw_dark_end // Drawing Clear
    draw_set_color(c_black);

	if(DebugLag) trace_time();

     // Mortar:
    with(instances_matching(CustomEnemy, "name", "Mortar", "InvMortar")) if(visible){
        if(sprite_index == spr_fire){
            draw_circle(x + (6 * right), y - 16, 24 - alarm1 + orandom(4), false)
        }
    }

     // Mortar Plasma:
    with(instances_matching(CustomProjectile, "name", "MortarPlasma")) if(visible){
        draw_circle(x, y - z, 32 + orandom(1), false);
    }

	if(DebugLag) trace_time("tecaves_draw_dark_end");


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
#define instances_seen_nonsync(_obj, _bx, _by)                                          return  mod_script_call_nc("mod", "telib", "instances_seen_nonsync", _obj, _bx, _by);
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