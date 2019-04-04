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
#macro opt sav.option

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)


#define Bat_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
         // Visual:
        spr_idle = spr.BatIdle;
        spr_walk = spr.BatWalk;
        spr_hurt = spr.BatHurt;
        spr_dead = spr.BatDead;
        spr_fire = spr.BatYell;
		spr_weap = spr.BatWeap;
		spr_shadow = shd48;
		hitid = [spr_idle, "BAT"];
		mask_index = mskScorpion;
		depth = -2;

         // Sound:
        snd_hurt = sndSuperFireballerHurt;
        snd_dead = sndFrogEggDead;

         // Vars:
		maxhealth = 30;
		raddrop = 12;
		size = 2;
		walk = 0;
		scream = 0;
		stress = 20;
		walkspd = 0.8;
		maxspd = 2.5;
		gunangle = random(360);
		direction = gunangle;

		 // Alarms:
		alarm1 = 60;
		alarm2 = 120;

		return id;
    }

#define Bat_step
    enemyWalk(walkspd, maxspd);

     // Walk:
    if((sprite_index != spr_fire && sprite_index != spr_hurt) || anim_end){
        if(speed <= 0) sprite_index = spr_idle;
        else sprite_index = spr_walk;
    }

     // Bounce:
    if(place_meeting(x + hspeed, y + vspeed, Wall)){
        if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
        if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;
    }

#define Bat_draw
    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();

#define Bat_alrm1
    alarm1 = 15 + irandom(20);
    target = instance_nearest(x, y, Player);

    if(in_sight(target)){
        gunangle = point_direction(x, y, target.x, target.y);
        scrRight(gunangle);

        if(!in_distance(target, 75)){
             // Walk to target:
            if(chance(4, 5)){
                scrWalk(15 + irandom(20), gunangle + orandom(8));
            }
        }
        else if(in_distance(target, 50)){
             // Walk away from target:
            scrWalk(10+irandom(5), gunangle + 180 + orandom(12));
            alarm1 = walk;
        }

         // Attack target:
        if(chance(2, 5) && in_distance(target, [50, 200])){
             // Sounds:
            sound_play_pitchvol(sndRustyRevolver, 0.8, 0.7);
            sound_play_pitchvol(sndSnowTankShoot, 1.2, 0.6);
            sound_play_pitchvol(sndFrogEggHurt, 1 + random(0.4), 3.5);

             // Bullets:
            var d = 4,
                s = 2;
            for (var i = 0; i <= 5; i++){
                with scrEnemyShoot("TrafficCrabVenom", gunangle + orandom(2 + i), s * i){
                    move_contact_solid(direction, d + d * i);

                     // Effects:
                    with(scrFX(x, y, [direction + orandom(4), speed * 0.8], AcidStreak)){
                    	image_angle = direction;
                    }

                    if(i <= 2){
                    	scrFX(x, y, [direction + orandom(8 * i), (4 - i)], Smoke);
                    }
                }
            }

             // Effects:
            wkick += 7;
            with(scrFX(x, y, [gunangle + (130 * choose(-1, 1)) + orandom(20),  5], Shell)){
                sprite_index = sprShotShell;
            }
        }

         // Screech:
        else{
            if irandom(stress) >= 15{
                stress -= 8;
                scrBatScreech();

                 // Fewer mass screeches:
                with instances_named(CustomEnemy, "Bat"){
                    stress = max(stress - 4, 10);
                }
            }

             // Build up stress:
            else stress += 4;
        }
    }
    else{
         // Follow nearest ally:
        var c = nearest_instance(x, y, instances_named(CustomEnemy, ["Cat", "CatBoss", "BatBoss"]));
        if(in_sight(c) && !in_distance(c, 64)){
            scrWalk(15 + irandom(20), point_direction(x, y, c.x, c.y) + orandom(8));
        }

         // Wander:
        else if(chance(1, 3)){
            scrWalk(10 + irandom(20), direction + orandom(24));
        }

        gunangle = direction;
        scrRight(gunangle);
    }


#define Bat_hurt(_hitdmg, _hitvel, _hitdir)
     // Get hurt:
    if !instance_is(other, ToxicGas){
        stress += _hitdmg;
        enemyHurt(_hitdmg, _hitvel, _hitdir);
    }

     // Screech:
    else{
        stress -= 4;
        nexthurt = current_frame + 5;

        scrBatScreech(0.5);
    }

#define Bat_death
    sound_play_pitch(sndScorpionFireStart, 1.2);
    //pickup_drop(0, 100);
    pickup_drop(60, 5);

#define scrBatScreech /// scrBatScreech(?_scale = undefined)
    var _scale = argument_count > 0 ? argument[0] : undefined;
     // Effects:
    sound_play_pitchvol(sndNothing2Hurt, 1.4 + random(0.2), 0.7);
    sound_play_pitchvol(sndSnowTankShoot, 0.8 + random(0.4), 0.5);

    view_shake_at(x, y, 16);
    sleep(40);

     // Alert nearest cat:
    with nearest_instance(x, y, instances_named(CustomEnemy, "Cat"))
        cantravel = true;

     // Screech:
    with scrEnemyShoot("BatScreech", 0, 0) if !is_undefined(_scale){
        image_xscale = _scale;
        image_yscale = _scale;
    }
    sprite_index = spr_fire;
    image_index = 0;


#define BatBoss_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
         // Visual:
        spr_idle = spr.BatBossIdle;
        spr_walk = spr.BatBossWalk;
        spr_hurt = spr.BatBossHurt;
        spr_dead = spr.BatBossDead;
        spr_fire = spr.BatBossYell;
		spr_weap = spr.BatBossWeap;
		spr_shadow = shd64;
		spr_shadow_y = 12;
		hitid = [spr_idle, "BIG BAT"];
		depth = -2;

         // Sound:
        snd_hurt = sndSalamanderHurt;
        snd_dead = sndRatkingCharge;

         // Vars:
        friction = 0.01;
		mask_index = mskBanditBoss;
		maxhealth = scrBossHP(200);
		raddrop = 24;
		size = 3;
		walk = 0;
		scream = 0;
		stress = 20;
		walkspd = 0.8;
		maxspd = 3;
		gunangle = random(360);
		direction = gunangle;
		active = true;
		cloud = [];
		cloud_blend = image_blend;

		 // Alarms:
		alarm1 = 60;

		return id;
    }

#define BatBoss_step
	Bat_step();
	if(walk <= 0) speed = min(speed, maxspd / 2);

	 // Disabled:
    if(!active){
        mask_index = mskNone;
        visible = false;
        canfly = true;

		 // hello i am bat:
        var _bat = instances_matching(instances_named(CustomEnemy, "Bat"), "creator", id);
        with(nearest_instance(x, y, _bat)){
        	other.x = x;
        	other.y = y;
        	other.right = right;
        	other.gunangle = gunangle;
        }

         // Reappear:
        if(
        	array_length(_bat) <= 1		&&
        	array_length(cloud) <= 0	&&
        	array_length(instances_named(CustomObject, "BatCloud")) <= 0
        ){
        	alarm0 = 20;
			for(var i = 0; i < 3; i++){
				array_push(cloud, { y_add: 1.2, delay: 5 * i });
			}

			 // Make any remaining bats unkillable:
        	with(_bat) my_health = 9999;
        }
    }

	 // Morph Cloud:
	if(array_length(cloud) > 0){
		walk = 0;
		speed = 0;

		var w = (active ? 24 : 16),
			h = (active ? 32 : 20),
			_x1 = x - (w / 2),
			_y1 = y - (h / 2),
			_x2 = x + (w / 2),
			_y2 = y + (h / 2);
	
		with(cloud){
			if("y"     not in self) y = 0;
			if("y_add" not in self) y_add = 1.5;
			if("delay" not in self) delay = 0;
			if("right" not in self) right = choose(-1, 1);

			if(delay > 0) delay -= current_time_scale;
			else{
				var _y = _y1 + y,
					o = (_y / 2),
					_x = other.x + (cos(o) * ((w / 2) * right));

				 // Visual:
				var d = other.depth + sin(o);
				repeat(3) with(scrFX([_x, 4], [_y, 4], 0, Dust)){
					image_blend = c_black;
					depth = d;
				}
	
				 // End:
				y += y_add * current_time_scale;
				if(y >= h){
					with(other){
						cloud = array_delete_value(cloud, other);
					}
				}
			}
		}

		 // Morphing:
		if(active){
			cloud_blend += 0.05 * current_time_scale;
			cloud_blend = clamp(cloud_blend, 0, 1);
		}

		 // Morphing Back:
		else{
			var _bat = instances_matching(instances_named(CustomEnemy, "Bat"), "creator", id);
			with(_bat){
				walk = 0;
				speed = 0;
				alarm1 = 20 + random(20);
				image_blend = merge_color(image_blend, c_black, 0.1 * current_time_scale);
			}
		}
	}
	else cloud_blend = 0;

#define BatBoss_draw
	 // Cloudin:
	var _blend = image_blend;
	image_blend = merge_color(image_blend, c_black, cloud_blend);

	 // Self:
    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();

    image_blend = _blend;

     // draw_text_nt(x, y - 30, string(charge) + "/" + string(max_charge) + "(" + string(charged) + ")");

#define BatBoss_alrm0
	target = instance_nearest(x, y, Player);
	cloud = [];

	 // Disappear:
	if(active){
		active = false;

		 // Turnin Into Bats:
		var _ang = random(360);
		for(var d = _ang; d < _ang + 360; d += (360 / 3)){
			var l = 8;
			with(obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "BatCloud")){
				target = other.target;
				target_offdir = d;
				creator = other;
				direction = d;
			}
		}

		 // Sound:
		sound_play_pitchvol(sndBloodHurt, 0.7 + random(0.2), 0.8);
	}

	 // Reappear:
	else{
		active = true;

		alarm1 += 30;
        mask_index = mskBanditBoss;
        visible = true;
        canfly = false;
        instance_create(x, y, PortalClear);

         // Poof:
        with(instances_matching(instances_named(CustomEnemy, "Bat"), "creator", id)){
        	repeat(8) with(scrFX(x, y, 3, Dust)){
        		image_blend = c_black;
        	}
        	instance_delete(id);
        }

         // Effects:
		sound_play_pitchvol(sndBloodHammer, 0.5 + random(0.2), 0.8);
	}

	 // Effects:
	with(instances_meeting(x, y, Dust)){
		if(chance(1, 3)) with(scrFX(x, y, [point_direction(other.x, other.y, x, y), random_range(1.5, 2)], Smoke)){
			image_blend = c_black;
			depth = -7;
		}
	}

#define BatBoss_alrm1
	alarm1 = 20 + random(20);
    with(instances_matching_le(instances_named(CustomEnemy, "CatBoss"), "supertime", 0)){
    	alarm1 = 20 + random(20);
    	other.alarm1 += alarm1;
    }

	if(active){
	    target = instance_nearest(x, y, Player);
	    if instance_exists(target){
    	    var _targetDir = point_direction(x, y, target.x, target.y);
    
    	    if(in_sight(target) && in_distance(target, 240)){
    	         // Move Away:
    	        if(chance(1, 5)){
    	            scrWalk(20 + irandom(15), _targetDir + 180 + (irandom_range(25, 45) * right));

    	             // Bat Morph:
    	            if(chance(1, 8) && !chance(maxhealth, my_health)){
	    				alarm0 = 24;
	    				for(var i = 0; i < 3; i++){
	    					array_push(cloud, { delay: 8 * i });
	    				}
    	            }
    	        }
    
    	         // Screech:
                if(chance(1, 3)){
                	if(irandom(stress) >= 15){
    	                stress -= 8;
    	                scrBatBossScreech();
                	}
    	        	else stress += 4;
                }
    
    	        else{
    	        	 // Flak Time:
    	        	wkick -= 4;
    	        	gunangle = _targetDir;
    				scrEnemyShoot("VenomFlak", gunangle + orandom(10), 12);
    	        }
    	    }
    
    	    else{
    	         // Follow Cat Boss:
    	        var c = nearest_instance(x, y, instances_named(CustomEnemy, "CatBoss"));
    	        if(in_sight(c) && !in_distance(c, 64)){
    	            scrWalk(15 + irandom(20), point_direction(x, y, c.x, c.y) + orandom(8));
    	        }
    
    			 // Wander:
    	        else if(chance(2, 3)){
    	            scrWalk(10 + irandom(20), direction + orandom(24));
    	        }
    
    			 // Bat Morph:
    	        else{
    				alarm0 = 24;
    				for(var i = 0; i < 3; i++){
    					array_push(cloud, { delay: 8 * i });
    				}
    	        }
    	    }
    
    	    gunangle = (in_sight(target) ? _targetDir : direction);
    		scrRight(gunangle);
	    }
	}

	 // More Aggressive Bats:
	else{
		with(instances_matching(instances_named(CustomEnemy, "Bat"), "creator", id)){
			alarm1 = ceil(alarm1 / 2);
			
			target = instance_nearest(x, y, Player);

			if(instance_exists(target)){
				if(in_sight(target) && in_distance(target, 128)){
					scrWalk(alarm1, point_direction(x, y, target.x, target.y));
				}

				 // Zoom Ovah:
				else if(chance(1, 3)){
					with(obj_create(x, y + 16, "BatCloud")){
						target = other.target;
						creator = other.creator;
						direction = 90 + orandom(20);
						my_health = other.my_health;
					}

					 // Effects:
					sound_play_pitchvol(sndBloodHammer, 1.4 + random(0.2), 0.5);
					repeat(10){
						with(scrFX([x, 8], y + orandom(8), random(3), Smoke)){
							image_blend = c_black;
						}
					}

					instance_delete(id);
				}
			}
		}
	}

#define BatBoss_hurt(_hitdmg, _hitvel, _hitdir)
     // Get hurt:
    if !instance_is(other, ToxicGas){
        stress += _hitdmg;
        enemyHurt(_hitdmg, _hitvel, _hitdir);
    }

     // Screech:
    else{
        stress -= 4;
        nexthurt = current_frame + 5;

        scrBatBossScreech(true);
    }

#define BatBoss_death
    pickup_drop(100, 50);
    pickup_drop(60, 0);

     // Buff Partner:
    with(instances_named(CustomEnemy, "CatBoss")){
    	maxhealth *= 2;
    	my_health += 0.5 * maxhealth;
    }

#define scrBatBossScreech /// scrBatBossScreech(?_single = undefined)
    var _single = argument_count > 0 ? argument[0] : undefined;
     // Effects:
    sound_play_pitchvol(sndNothing2Hurt, 1.4 + random(0.2), 0.7);
    sound_play_pitchvol(sndSnowTankShoot, 0.8 + random(0.4), 0.5);

    view_shake_at(x, y, 16);
    sleep(40);

     // Alert nearest cat:
    with nearest_instance(x, y, instances_named(CustomEnemy, "Cat"))
        cantravel = true;

     // Screech:
    scrEnemyShoot("BatScreech", 0, 0);
    if(is_undefined(_single) || !_single){
        var l = 56;
        for (var d = 0; d <= 360; d += 360 / 3)
            with scrEnemyShootExt(x + lengthdir_x(l, gunangle + d), y + lengthdir_y(l, gunangle + d), "BatScreech", 0, 0){
                image_xscale = 0.5;
                image_yscale = 0.5;
            }
    }
    sprite_index = spr_fire;
    image_index = 0;


#define BatCloud_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		target = noone;
		target_offdis = 32;
		target_offdir = random(360);
		creator = noone;
		friction = 0.5;
		direction = random(360);
		speed = 16;

		return id;
	}

#define BatCloud_step
	if(speed > 6) speed -= 2 * current_time_scale;

	if(current_frame_active){
		 // Visual:
		repeat(4) with(scrFX([x, 4], [y, 4], 0, Dust)){
			image_blend = c_black;
			depth = -8;
		}

		 // Wobblin:
		direction += orandom(16);
	}

	if(instance_exists(target)){
		 // Get Landing Position:
		var	_dis = target_offdis,
			_dir = target_offdir;

		do{
			var _tx = target.x + lengthdir_x(_dis, _dir),
				_ty = target.y + lengthdir_y(_dis, _dir);

			_dis -= 8;
		}
		until (_dis <= 0 || (!position_meeting(_tx, _ty, Wall) && position_meeting(_tx, _ty, Floor)));

		 // Moving:
		var _dis = point_distance(x, y, _tx, _ty),
			_dir = point_direction(x, y, _tx, _ty);

		if(speed < 8){
			if(_dis > 96){
				_dir = point_direction(x, y, _tx, _ty - 96);
			}
			motion_add_ct(_dir, random_range(1, 4));
		}

		 // Land:
		if(_dis < 8) instance_destroy();
	}
	else instance_destroy();

#define BatCloud_destroy
	instance_create(x, y, PortalClear);
	with(obj_create(x, y, "Bat")){
		x = xstart;
		y = ystart;
		motion_add(other.direction, 4);
		nexthurt = current_frame + 12;
		creator = other.creator;
		kills = 0;

		 // Save HP:
		if("my_health" in other){
			my_health = other.my_health;
		}

		 // Aim:
		if(instance_exists(other.target)){
			gunangle = point_direction(x, y, other.target.x, other.target.y);
			scrRight(gunangle);
		}
		
		 // Effects:
		for(var a = 0; a < 360; a += (360 / 12)){
			with(scrFX(x, y + 6, [a, 2], Smoke)){
				motion_add(other.direction, 1);
				image_blend = c_black;
				growspeed *= -10;
				depth = -3;
			}
		}
	}

	 // Effects:
	sound_play_pitchvol(sndBouncerSmg, 0.2 + random(0.2), 0.6);
	sound_play_pitchvol(sndBloodHammer,  1.6 + random(0.4), 0.4);


#define BatScreech_create(_x, _y)
    with(instance_create(_x, _y, CustomSlash)){
         // Visual:
        sprite_index = spr.BatScreech;
        mask_index = msk.BatScreech;
        image_speed = 0.4;
        depth = -3;

         // Vars:
        creator = noone;
        candeflect = false;

	     // Effects:
	    instance_create(x, y, PortalClear);
	    repeat(12 + irandom(6)){
	        scrFX(x, y, 4 + random(4), Dust);
	    }

	    return id;
    }

#define BatScreech_step
    while place_meeting(x, y, ToxicGas)
        with instance_nearest(x, y, ToxicGas)
            instance_delete(id);

#define BatScreech_draw
    draw_set_blend_mode(bm_add);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha * 0.4);
    draw_set_blend_mode(bm_normal);

#define BatScreech_hit
	 // Push Dudes Away:
    with(instances_matching_ne(hitme, "team", team)){
        if(place_meeting(x, y, other)){
            motion_add(point_direction(other.x, other.y, x, y), 1);
    	}
	}


#define Cabinet_create(_x, _y)
    with(instance_create(_x, _y, CustomProp)){
         // Visual:
        spr_idle = spr.CabinetIdle;
        spr_hurt = spr.CabinetHurt;
        spr_dead = spr.CabinetDead;

         // Sounds:
        snd_hurt = sndHitMetal;
        snd_dead = sndSodaMachineBreak;

         // Vars:
        maxhealth = 20;
        size = 1;

        return id;
    }

#define Cabinet_death
    repeat(irandom_range(8, 16)){
        with(obj_create(x, y, "Paper")){
            motion_set(random(360), random_range(2, 8));
        }
    }


#define Cat_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
         // Visual:
		spr_idle = spr.CatIdle;
		spr_walk = spr.CatWalk;
		spr_hurt = spr.CatHurt;
		spr_dead = spr.CatDead;
		spr_sit1 = spr.CatSit1[0];
		spr_sit2 = spr.CatSit2[0];
		spr_sit1_side = spr.CatSit1[1];
		spr_sit2_side = spr.CatSit2[1];
		spr_weap = spr.CatWeap;
		spr_shadow = shd24;
		hitid = [spr_idle, "CAT"];
		mask_index = mskRat;
		depth = -2;

         // Sound:
		snd_hurt = sndGatorHit;
		snd_dead = sndSalamanderDead;
		toxer_loop = -1;

		 // Vars:
		maxhealth = 10;
		raddrop = 6;
		size = 1;
		walk = 0;
		walkspd = 0.8;
		maxspd = 3;
		hole = noone;
		ammo = 0;
		active = true;
		cantravel = false;
		gunangle = random(360);
		direction = gunangle;
		sit = noone;
		sit_side = 0;

		 // Alarms:
		alarm1 = 40 + irandom(20);
		alarm2 = 40 + irandom(20);

		return id;
	}

#define Cat_step
    enemyWalk(walkspd, maxspd);

     // Animate:
    if(sprite_index == spr_sit1){
        if(anim_end) sprite_index = spr_sit2;
    }
    else if(sprite_index == spr_sit1_side){
        if(anim_end) sprite_index = spr_sit2_side;
    }
    else if(sprite_index != spr_sit2 && sprite_index != spr_sit2_side){
        if(speed <= 0) sprite_index = spr_idle;
        else sprite_index = spr_walk;
    }

     // Disabled:
    if(!active){
        visible = false
        canfly = true;
        x = 0;
        y = 0;
    }

     // Off Alert:
    else if(!cantravel){
         // chillin'
        if(!instance_exists(sit) && instance_exists(CustomProp)){
            var n = instance_nearest(x, y, CustomProp);
            if(place_meeting(x, y, n)){
                if("name" in n && (n.name == "ChairFront" || n.name == "Couch")){
                     // Check if someone else sitting there:
                    var _canSit = true;
                    with(instances_named(object_index, name)){
                        if(sit == n) _canSit = false;
                    }

                     // Sit:
                    if(_canSit){
                        sit = n;
                        image_index = 0;
                        if(n.sprite_index == spr.ChairSideIdle){
                            sprite_index = spr_sit1_side;
                        }
                        else sprite_index = spr_sit1;
                    }
                }
            }
        }

         // On Alert:
        if(instance_exists(target)){
            if(
                my_health < maxhealth ||
                in_sight(target)	  ||
                (in_distance(target, 96) && target.reload > 0)
            ){
                cantravel = true;
                sound_play_pitchvol(sndFireballerFire, 1.5 + random(0.2), 0.5);
                with(instance_create(x + (10 * right), y - 5, AssassinNotice)){
                    depth = -7;
                }
            }
        }
    }

     // Sitting:
    if(instance_exists(sit)){
        speed = 0;
        x = sit.x;
        y = sit.y - 3;
        right = -sit.image_xscale;
        if(cantravel){
            sit = noone;
            sprite_index = spr_idle;
        }
    }

#define Cat_draw
    if(!instance_exists(sit)){
        if(gunangle >  180) draw_self_enemy();
        draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
        if(gunangle <= 180) draw_self_enemy();
    }
    else draw_self_enemy();

#define Cat_alrm1
    alarm1 = 20 + irandom(20);

     // Spraying Toxic Gas:
    if(ammo > 0){
        alarm1 = 2;

         // Toxic:
        repeat(2){
            with(scrEnemyShoot(ToxicGas, gunangle + orandom(6), 4)){
                team = 0;
                friction = 0.12;
            }
        }
        gunangle += 12;

         // End:
        if(--ammo <= 0){
            alarm1 = 40;

             // Effects:
            repeat(3){
                with(instance_create(x, y, AcidStreak)){
                    motion_add(other.gunangle + orandom(16), 3);
                    image_angle = direction;
                }
            }
            sound_play_pitch(sndEmpty, random_range(0.75, 0.9));
            sound_stop(toxer_loop);
            toxer_loop = -1;
            wkick += 6;
        }
        else wkick++;
    }

    else{
        target = instance_nearest(x, y, Player);

         // Normal AI:
        if(active){
            if(!instance_exists(sit)){
                if(in_sight(target)){
                    var _targetDir = point_direction(x, y, target.x, target.y);
        
                     // Start Attack:
                    if(in_distance(target, 140) && chance(1, 3)){
                        scrRight(_targetDir);
                        gunangle = _targetDir - 45;
                        alarm1 = 4;
                        ammo = 10;
        
                         // Effects:
                        var o = 8;
                        with(instance_create(x + lengthdir_x(o, gunangle), y + lengthdir_y(o, gunangle), AcidStreak)) {
                            sprite_index = spr.AcidPuff;
                            image_angle = other.gunangle;
                        }
                        sound_play(sndToxicBoltGas);
                        sound_play(sndEmpty);
                        toxer_loop = audio_play_sound(sndFlamerLoop, 0, true);
                        wkick += 4;
                    }
        
                     // Walk Toward Player:
                    else{
                        alarm1 = 20 + irandom(20);
                        scrWalk(20 + irandom(5), _targetDir + orandom(20));
                        scrRight(gunangle);
                    }
                }
        
                else{
                     // To the CatHole:
                    if(cantravel && chance(3, 4)){
                        var _hole = nearest_instance(x, y, instances_named(CustomObject, "CatHole"));
                        if(instance_exists(_hole)){
                            alarm1 = 30 + irandom(30);
                            with(_hole){
                                 // Open CatHole:
                                if(
                                    !instance_exists(target) &&
                                    in_distance(other, 48)	 &&
                                    CatHoleCover(true).open
                                ){
                                    other.alarm1 += 45;
                                    target = other;
                                }
            
                                 // Walk to CatHole:
                                else with(other){
                                    scrWalk(20 + random(20), point_direction(x, y, other.x, other.y));
                                }
                            }
                        }
                    }
        
                     // Wander:
                    else{
                        alarm1 = 30 + irandom(20);
                        scrWalk(20 + irandom(10), direction + orandom(30));
                        if(chance(1, 2)) direction = random(360);
                    }
                }
            }
        }

         // Manhole Travel:
        else{
            alarm1 = 40 + random(40);

            var _forceSpawn = (instance_number(enemy) <= array_length(instances_matching(instances_named(object_index, name), "active", false)));
            with(instances_named(CustomObject, "CatHole")){
                if(chance(3, instance_number(enemy))){
                    if(!CatHoleCover().open){
                        if(!instance_exists(other.target) || in_sight(other.target)){
                            if(CatHoleCover(true).open){
                                with(other){
                                    alarm1 = 15 + random(30);
                                    active = true;
                                    visible = true;
                                    canfly = false;
                                    x = other.x;
                                    y = other.y;
    
                                     // Move:
                                    if(instance_exists(target)){
                                        direction = point_direction(x, y, target.x, target.y) + orandom(50);
                                    }
                                    else direction = random(360);
                                    scrWalk(4 + random(4), direction);
    
                                     // Effects:
                                    sound_play_pitchvol(sndFireballerHurt, 1.4, 0.6);
                                    repeat(4){
                                        scrFX([x, 4], [y, 4], [direction, 3], Dust);
                                    }
                                }
                            }
                            break;
                        }
                    }
                }
            }
        }
    }

#define Cat_hurt(_hitdmg, _hitvel, _hitdir)
    if(!instance_is(other, ToxicGas)){
        if(active){
            my_health -= _hitdmg;           // Damage
            nexthurt = current_frame + 6;   // I-Frames
            sound_play_hit(snd_hurt, 0.3);  // Hurt Sound
            motion_add(_hitdir, _hitvel);   // Knockback
    
             // Hurt Sprite:
            sprite_index = spr_hurt;
            image_index = 0;
        }
    }

     // Toxic immune
    else with(other){
		instance_copy(false);
		instance_delete(id);
		for(var i = 0; i < maxp; i++) view_shake[i] -= 1;
	}

#define Cat_cleanup
    sound_stop(toxer_loop);


#define CatBoss_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
	     // For Sani's bosshudredux:
        boss = 1;
        bossname = "BIG CAT";
        col = c_green;

         // Visual:
		spr_idle = spr.CatBossIdle;
		spr_walk = spr.CatBossWalk;
		spr_hurt = spr.CatBossHurt;
		spr_dead = spr.CatBossDead;
		spr_weap = spr.CatBossWeap;
		spr_weap_chrg = spr.CatBossWeapChrg;
		spr_shadow = shd48;
		spr_shadow_y = 3;
		hitid = [spr_idle, bossname];
		mask_index = mskBanditBoss;
		depth = -2;

         // Sound:
		snd_hurt = sndScorpionHit;
		snd_dead = sndSalamanderDead;
		jetpack_loop = -1;

		 // Vars:
		maxhealth = scrBossHP(200);
		raddrop = 24;
		meleedamage = 3;
		canmelee = false;
		size = 3;
		walk = 0;
        dash = 0;
        super = false;
        supertime = 0;
        maxsupertime = 30;
        superbreakmax = 6; // used in on_hurt to prevent catboss from being locked in the charge animation 
		gunangle = random(360);
		direction = gunangle;

		 // Alarms:
		alarm0 = 300 + random(150);
		alarm1 = 30 + random(20);

		return id;
	}

#define CatBoss_step
    enemySprites();
	enemyWalk(0.8, ((dash > 0) ? 6.5 : 3.0));

	 // Super FX:
	if(super && chance_ct(1, 10)){
		var l = 12,
			d = gunangle;

		instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), PortalL).depth = -3;
	}

     // Bounce:
    if(dash <= 0 && walk > 0 && place_meeting(x + hspeed, y + vspeed, Wall)){
    	if(array_length(instances_matching(instances_named(CustomObject, "CatBossAttack"), "creator", id)) <= 0){
	        if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
	        if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;
	        gunangle += angle_difference(direction, gunangle) / 2;
	        scrRight(gunangle);
    	}
    }

#define CatBoss_draw
    if(gunangle >  180) draw_self_enemy();

	 // Weapon:
    var _spr = spr_weap,
    	_img = (super ? (current_frame * image_speed) : 0);

    if(supertime > 0){
    	_spr = spr_weap_chrg;
    	_img = sprite_get_number(spr_weap_chrg) * (1 - (supertime / maxsupertime));
    }
    draw_sprite_ext(_spr, _img, x - lengthdir_x(wkick, gunangle), y - lengthdir_y(wkick, gunangle), 1, right, gunangle, image_blend, image_alpha);

    if(gunangle <= 180) draw_self_enemy();

#define CatBoss_alrm0
	alarm0 = 150;

	 // Underground Cats:
	if(chance(1, 1 + array_length(instances_named(CustomEnemy, "Cat")))){
		with(obj_create(0, 0, "Cat")){
			active = false;
			cantravel = true;
			alarm1 = random_range(60, 300);
		}
	}

#define CatBoss_alrm1
	alarm1 = 20 + random(20);
	
	if(supertime > 0){
	    alarm1 = 1;
	    supertime -= 1;

	     // Mid charge:
	    wkick = 6;
	    gunangle = right ? 320 + orandom(5) : 220 + orandom(5);

	     // Effects:
	    view_shake_max_at(x, y, 4);
	    if(chance(1, 2)){
	        var _w = (1 - (supertime / maxsupertime)) * 12,
	            _h = irandom(8) * right;

	        with(instance_create(x + lengthdir_x(_w, gunangle) + lengthdir_x(_h, gunangle + 90), y + lengthdir_y(_w, gunangle) + lengthdir_y(_h, gunangle + 90), EatRad)){
	            sprite_index = choose(sprEatRadPlut, sprEatRadPlut, sprEatBigRadPlut);
	            depth = -3;
	        }
	    }
	     
         // End charge:
	    if(supertime <= 0){
	        super = true;

	        alarm1 = 12;
	        wkick = -3;
	        gunangle = right ? 340 : 200;

	         // Sounds:
	        sound_play_pitch(sndLaserCannon, 0.8);
	        sound_play_pitch(sndGunGun, 1.2);
	        sound_play_pitch(sndStrongSpiritLost, 0.8);

	         // Effects:
	        var l = 20;
	        instance_create(x + lengthdir_x(l, gunangle), y + lengthdir_y(l, gunangle), ThrowHit).depth = -3;
	    }
	}
	else{
        with(instances_named(CustomEnemy, "BatBoss")){
        	alarm1 = 20 + random(20);
        	other.alarm1 += alarm1;
        }

        target = instance_nearest(x, y, Player);

        if(instance_exists(target)){
        	var _tx = target.x,
        		_ty = target.y,
            	_targetDir = point_direction(x, y, _tx, _ty);

             // Start Charge:
        	if(!super && chance(1, 5)){
        		alarm1 = 1;
        		supertime = maxsupertime;
        		superbreakmax = 6;

				 // FX:
        		sound_play_pitch(sndLaserCannonCharge, 0.6);
        		sound_play_pitch(sndTechnomancerActivate, 1.4);
        	}
    
            else{
                if(chance(4, 5)){
                     // Attack:
                    if(chance(3, 4) && in_sight(target) && (in_distance(target, 80) || chance(1, 2))){
        				gunangle = _targetDir;
                        var a = scrEnemyShoot("CatBossAttack", gunangle, 0);
                        a.target = target;
                        a.type = super;
                        super = false;
        
                        alarm1 = 10 + a.alarm0;
        
        				 // Effects:
                        sound_play(sndShotReload);
                        sound_play_pitch(sndSnowTankAim, 2.5 + random(0.5));
                        sound_play_pitchvol(sndLilHunterSniper, (a.type ? 0.25 : 1.5) + random(0.5), 0.5);
                        if(a.type) sound_play_pitchvol(sndLaserCannonCharge, 0.4 + orandom(0.1), 0.5);
                    }
        
                     // Gas dash:
                    else if(!in_distance(target, 40)){
                    	alarm2 = 1;
                    }
                }
        
                 // Circle Target:
                else{
                    var l = 64,
                        d = point_direction(target.x, target.y, x, y);
        
                    d += 30 * sign(angle_difference(direction, d));
                    scrWalk(15 + random(25), point_direction(x, y, target.x + lengthdir_x(l, d), target.y + lengthdir_y(l, d)));
                }
                
                gunangle = _targetDir;
                scrRight(gunangle);
            }
        }
    
         // Wander:
        else{
            gunangle = direction;
            scrWalk(15 + irandom(25), direction + orandom(30));
            scrRight(direction);
        }
	}

#define CatBoss_alrm2
	alarm2 = 1;

	target = instance_nearest(x, y, Player);

	var _targetDir = gunangle;
	if(instance_exists(target)){
		_targetDir = point_direction(x, y, target.x, target.y);
	}

	 // Dash Start:
	if(dash <= 0){
        dash = 16 + random(8);
		canmelee = true;
		direction = gunangle + (random_range(40, 60) * choose(-1, 1));

		 // Effects:
        sleep(26);
        view_shake_at(x, y, 18);
        sound_play(sndToxicBoltGas);
        sound_play(sndFlamerStart);
        jetpack_loop = audio_play_sound(sndFlamerLoop, 0, true);
	}

     // Zoomin'
    motion_add(direction, 1.4);
	motion_add(_targetDir, 0.7);

     // Wall break:
    if(place_meeting(x + hspeed, y + vspeed, Wall)){
        with(instances_meeting(x + hspeed, y + vspeed, Wall)){
        	instance_create(x, y, FloorExplo);
        	instance_destroy();
        }
    }

     // Gas:
    repeat(3 + irandom(3)){
        with(scrEnemyShoot(ToxicGas, direction + 180 + orandom(4), 1 + random(2))){
            friction = 0.16;
            team = 0;
        }
    }

     // Effects:
    wkick = 6;
    repeat(1 + irandom(2)){
        with(instance_create(x, y, AcidStreak)){
            image_angle = other.direction + 180 + orandom(64);
        }
    }

	 // End Dash:
	if(--dash <= 0){
		alarm2 = -1;
        alarm11 = -1;
        canmelee = false;

        sound_play(sndFlamerStop);
        sound_stop(jetpack_loop);

        view_shake_at(x, y, 12);

		 // Movin'
        scrWalk(16 + random(16), direction + orandom(20));
	}

    gunangle = _targetDir + angle_difference(direction, _targetDir) * 0.5;
    scrRight(gunangle);

#define CatBoss_hurt(_hitdmg, _hitvel, _hitdir)
    if(!instance_is(other, ToxicGas)){
        my_health -= _hitdmg;
        nexthurt = current_frame + 6;
        sound_play_hit(snd_hurt, 0.3);
        if !dash motion_add(_hitdir, _hitvel);

         // Hurt Sprite:
        sprite_index = spr_hurt;
        image_index = 0;
        
         // Break charging:
        if supertime > 0 && superbreakmax > 0{
            supertime += _hitdmg * 4;
            superbreakmax--;
            if supertime >= maxsupertime{
                alarm1 = 40 + irandom(20);
                supertime = 0;
                gunangle = right ? 300 : 240;
                sleep(100);
                view_shake_at(x, y, 20);
                motion_add(_hitdir, 4);
                 // Sounds:
                sound_play_pitch(sndGunGun, 0.8);
                sound_play_pitch(sndStrongSpiritLost, 1.2);
                 // Effects:
                instance_create(x, y, ImpactWrists).depth = -3;
                
                raddrop = max(0, raddrop - 2);
                if raddrop > 0
                    repeat(2 + irandom(2))
                        with instance_create(x, y, Rad){
                            motion_set(_hitdir + orandom(30), 4 + random(4));
                            friction = 0.4;
                        }
                repeat(3 + irandom(6))
                    with instance_create(x, y, Smoke)
                        motion_set(_hitdir + orandom(30), 4 + random(4));
                with instance_create(x + lengthdir_x(16, gunangle), y + lengthdir_y(16, gunangle), FishA){
                    image_angle = other.gunangle;
                    depth = -3;
                }
            }
        }
    }

     // Toxic immune
    else with(other){
        instance_copy(false);
		instance_delete(id);
		for(var i = 0; i < maxp; i++) view_shake[i] -= 1;
	}

#define CatBoss_death
    pickup_drop(100, 20);
    repeat(2) pickup_drop(60, 0);

     // Hmmmm
    instance_create(x, y, ToxicDelay);

     // Buff Partner:
    with(instances_named(CustomEnemy, "BatBoss")){
    	maxhealth *= 2;
    	my_health += 0.5 * maxhealth;
    }

#define CatBoss_cleanup
    sound_stop(jetpack_loop);

#define CatBossAttack_create(_x, _y)
    with(instance_create(_x, _y, CustomObject)){
         // Visual:
        image_blend = c_lime;
        image_yscale = 1.5;
		hitid = [spr.CatIdle, "BIG CAT"];

         // Vars:
        type = 0;
        team = 1;
        force = 12;
        damage = 8;
        target = noone;
        creator = noone;
        fire_line = [];

         // Alarms:
        alarm0 = 30;
        alarm0_max = alarm0;

		 // Hitscan Lines:
		if(fork()){
			wait 0;

		    var _num = (3 + GameCont.loops) * (type ? 2.5 : 1),
		    	_off = 30 + (12 * GameCont.loops),
		    	_offPos = (_num / 2) * type;

		    repeat(_num) array_push(fire_line, {
		        dir : (type ? orandom(_off) : 0),
		        dis : 0,
		        dir_goal : (type ? 0 : orandom(_off)),
		        dis_goal : 1000,
		        x :  0 + orandom(_offPos),
		        y : -4 + orandom(_offPos)
		    });

			exit;
		}

        return id;
    }

#define CatBossAttack_step
    if(creator == noone || instance_exists(creator)){
    	 // Chargin Up:
	    with(creator){
	    	wkick = 5 * (1 - (other.alarm0 / other.alarm0_max));
	    }

	     // Aim:
    	if(type && instance_exists(target)){
			var d = point_direction(x, y, target.x, target.y),
				m = 60;

			with(creator){
				gunangle += (clamp(angle_difference(d, gunangle), -m, m) / 20) * current_time_scale
				scrRight(gunangle);
			}
			direction += (clamp(angle_difference(d, direction), -m, m) / 16) * current_time_scale;
    	}

    	 // Follow Creator:
        if(instance_exists(creator)){
    		var o = (type ? 28 : 16) - creator.wkick;
	        x = creator.x + lengthdir_x(o, creator.gunangle);
	        y = creator.y + lengthdir_y(o, creator.gunangle);
        }

	     // Hitscan Lines:
	    with(fire_line){
	        dir += (angle_difference(dir_goal, dir) / 7) * current_time_scale;

			 // Line Hitscan:
			var _dir = dir + other.direction,
	            _sx = other.x + x,
		        _sy = other.y + y,
		        _lx = _sx,
		        _ly = _ly,
		        _md = 1000,
		        d = _md,
		        m = 0; // Minor hitscan increment distance

		    with(other) while(d > 0){
		         // Major Hitscan Mode (Start at max, go back until no collision line):
		        if(m <= 0){
		            _lx = _sx + lengthdir_x(d, _dir);
		            _ly = _sy + lengthdir_y(d, _dir);
		            d -= sqrt(_md);
		
		             // Enter minor hitscan mode:
		            if(!collision_line(_sx, _sy, _lx, _ly, Wall, false, false)){
		            	if(position_meeting(_lx, _ly, Floor)){
			                m = 2;
			                d = sqrt(_md);
		            	}
		            }
		        }

		         // Minor Hitscan Mode (Move until collision):
		        else{
		            if(position_meeting(_lx, _ly, Wall)) break;
		            _lx += lengthdir_x(m, _dir);
		            _ly += lengthdir_y(m, _dir);
		            d -= m;
		        }
		    }

			dis = point_distance(_sx, _sy, _lx, _ly);

			 // Effects:
			if(chance_ct(1, 10)){
				var l = random(dis),
					d = dir;

				with(instance_create(_sx + lengthdir_x(l, d) + orandom(4), _sy + lengthdir_y(l, d) + orandom(4), EatRad)){
                    sprite_index = choose(sprEatRadPlut, sprEatBigRad);
                    motion_set(_dir + 180 + orandom(60), 2);
				}
			}
	    }
    }
    else instance_destroy();

#define CatBossAttack_draw
     // Laser Sights:
    var _cx = x,
        _cy = y,
        _scale1 = image_yscale * (1 + (3 * (1 - (alarm0 / alarm0_max)))),
        _scale2 = 2 * (image_yscale * 3);

    draw_set_color(image_blend);

    with(fire_line){
        var	_x = _cx + x,
        	_y = _cy + y,
        	_dir = dir + other.direction;

        draw_line_width(_x, _y, _x + lengthdir_x(dis, _dir), _y + lengthdir_y(dis, _dir), _scale1 / 2);
        if(other.type){
        	draw_circle(_x, _y, _scale1, false);
        }

         // Bloom:
        draw_set_blend_mode(bm_add);
        draw_set_alpha(0.1);
        if(other.type){
        	draw_circle(_x, _y, _scale2, false);
        }
        draw_line_width(_x, _y, _x + lengthdir_x(dis, _dir), _y + lengthdir_y(dis, _dir), _scale2);
        draw_set_alpha(1);
        draw_set_blend_mode(bm_normal);
    }

#define CatBossAttack_alrm0
     // Hitscan Toxic:
    for(var i = 0; i < array_length(fire_line); i++){
        var _line = fire_line[i],
        	_x = x + _line.x,
        	_y = y + _line.y,
            _dis = _line.dis,
            _dir = _line.dir + direction;

		 // Wall Break:
		if(type){
			var o = 24;
	    	instance_create(_x + lengthdir_x(_dis - o, _dir), _y + lengthdir_y(_dis - o, _dir), PortalClear);
	    	instance_create(_x + lengthdir_x(_dis, _dir), _y + lengthdir_y(_dis, _dir), ToxicDelay);
		}

		 // Create Toxic Rails:
        while(_dis > 0){
        	var _lx = _x + lengthdir_x(_dis, _dir),
        		_ly = _y + lengthdir_y(_dis, _dir),
				o = (12 + GameCont.loops) * type;

             // Instadamage:
            if(type && collision_circle(_lx, _ly, o / 2, hitme, false, false)){
            	with(instances_matching_ne(hitme, "id", creator)) with(other){
		    		if(projectile_canhit_melee(other)){
            			if(collision_circle(_lx, _ly, o / 2, other, false, false)){
		    				projectile_hit(other, damage, force, _dir);
		    			}
            		}
            	}
            }

             // Gas:
            with(instance_create(_lx + orandom(o), _ly + orandom(o), ToxicGas)){
            	motion_add(_dir, 1 + random(1));
                friction += random_range(0.1, 0.2);
                growspeed *= _dis / _line.dis;
                creator = other.creator;
                hitid = other.hitid;

				 // Effects:
                if(chance(1, 2)){
                    with(instance_create(x + orandom(8), y + orandom(8), AcidStreak)){
                        motion_add(_dir + orandom(8), 4);
                        image_angle = direction;
                    }
                }
            }

            _dis -= 6;
        }

		 // Knockback gas:
        with(instance_create(_x, _y, ToxicGas)){
        	motion_add(_dir + 180 + orandom(20), 3);
        	move_contact_solid(_dir + 180, 20);
        	friction = 0.1;
        	creator = other.creator;
        	hitid = other.hitid;
        }
    }

     // Effects:
    view_shake_at(x, y, 32);
    sound_play(sndToxicBarrelGas);
    if(type){
    	sound_play_pitch(sndHyperSlugger, 0.4 + random(0.4));
    	sound_play_pitch(sndUltraCrossbow, 2 + random(0.5));
    }
    else{
    	sound_play(sndHyperSlugger);
    }

     // Cat knockback:
    with(creator){
        motion_add(other.direction + 180, 4);
        wkick = 16;
    }

    instance_destroy();


#define CatDoor_create(_x, _y)
    with(instance_create(_x, _y, CustomHitme)){
         // Visual:
        sprite_index = spr.CatDoor;
        spr_shadow = mskNone;
        image_speed = 0;
        depth = -3 - (y / 20000);

         // Sound:
        snd_hurt = sndHitMetal;
        snd_dead = sndWallBreakScrap;

         // Vars:
        mask_index = msk.CatDoor;
        maxhealth = 15;
        size = 2;
        team = 0;
        openang = 0;
        openang_last = openang;
        my_wall = noone;
        partner = noone;
        my_surf = -1;
        my_surf_w = 32;
        my_surf_h = 50;

        return id;
    }

#define CatDoor_step
	x = xstart;
	y = ystart;

     // Opening & Closing:
    var s = 0,
        _open = false;

    if(distance_to_object(Player) <= 0 || distance_to_object(enemy) <= 0 || distance_to_object(Ally) <= 0 || distance_to_object(CustomObject) <= 0){
        with(instances_named(CustomObject, "Pet")){
            if(distance_to_object(other) <= 0){
                var _sx = lengthdir_x(hspeed, other.image_angle),
                    _sy = lengthdir_y(vspeed, other.image_angle);

                s = 3 * (_sx + _sy);
                _open = true;
            }
        }
        with(instances_matching_ne(hitme, "team", team)){
            if(distance_to_object(other) <= 0){
                var _sx = lengthdir_x(hspeed, other.image_angle),
                    _sy = lengthdir_y(vspeed, other.image_angle);

                s = 3 * (_sx + _sy);
                _open = true;
            }
        }
    }
    if(_open){
        if(s != 0){
            if(abs(openang) < abs(s) && abs(openang) < 4){
                var _vol = clamp(40 / (distance_to_object(Player) + 1), 0, 1);
                if(_vol > 0.2){
                    sound_play_pitchvol(sndMeleeFlip, 1 + random(0.4), 0.8 * _vol);
                    sound_play_pitchvol(((openang > 0) ? sndAmmoChest : sndWeaponChest), 0.4 + random(0.2), 0.5 * _vol);
                }
            }
            openang += s;
        }
        openang = clamp(openang, -90, 90);
    }
    else openang *= 0.8;

     // Collision:
    if(abs(openang) > 20) mask_index = mskNone;
    else mask_index = msk.CatDoor;

     // Block Line of Sight:
    if(!instance_exists(my_wall)) my_wall = instance_create(0, 0, Wall);
    with(my_wall){
        x = other.x;
        y = other.y;
        if(other.mask_index == mskNone) mask_index = -1;
        else mask_index = msk.CatDoorLOS;
        image_xscale = other.image_xscale;
        image_yscale = other.image_yscale;
        image_angle = other.image_angle;
        sprite_index = -1;
        visible = 0;
        topspr = -1;
        outspr = -1;
    }

     // Draw Self:
    if(!surface_exists(my_surf) || openang != openang_last){
        if(!surface_exists(my_surf)) my_surf = surface_create(my_surf_w, my_surf_h);
        surface_set_target(my_surf);
        draw_clear_alpha(0, 0);

         // Draw 3D Door:
        for(var i = 0; i < image_number; i++){
            draw_sprite_ext(sprite_index, i, (my_surf_w / 2), (my_surf_h / 2) - i, image_xscale, image_yscale, image_angle + (openang * image_yscale), image_blend, 1);
        }

        surface_reset_target();
    }
    openang_last = openang;

     // Death:
    if(my_health <= 0){
		if(point_seen(x, y, -1)){
    		sound_play_pitchvol(snd_dead, 1.8 + random(0.2), 0.5);
    		sound_play_pitchvol(snd_hurt, 0.6 + random(0.2), 1.8);
		}

		 // Chunks:
        repeat(irandom_range(2, 3)){
        	var l = random(sprite_height / 2),
        		d = image_angle - 90;

        	with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), Shell)){
	            sprite_index = ((other.sprite_index == spr.PizzaDoor) ? spr.PizzaDoorDebris : spr.CatDoorDebris);
	            image_index = random(image_number);
	            image_speed = 0;

				motion_add(random(360), 2);
	            motion_add(other.direction + orandom(20), clamp(other.speed, 6, 18) * random_range(0.6, 1));
	            friction *= 2;
	        }

            with(scrFX(x, y, [direction + orandom(20), min(speed, 10) / 2], Dust)){
	        	depth = 1;
	    	}
        }

        instance_destroy();
    }

     // Stay Still:
    else speed = 0;

#define CatDoor_draw
    if(surface_exists(my_surf)){
        var h = (nexthurt > current_frame + 3);
        if(h) d3d_set_fog(1, image_blend, 0, 0);
        draw_surface_ext(my_surf, x - (my_surf_w / 2), y - (my_surf_h / 2), 1, 1, 0, c_white, image_alpha);
        if(h) d3d_set_fog(0, 0, 0, 0);
    }

#define CatDoor_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    motion_add(_hitdir, _hitvel);	// Knockback
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);	// Sound

     // Push Open Force:
    if(instance_exists(other)){
        var _sx = lengthdir_x(other.hspeed, image_angle),
            _sy = lengthdir_y(other.vspeed, image_angle);

        openang += (_sx + _sy);
    }

     // Shared Hurt:
    if(_hitdmg > 0){
        with(partner) if(my_health > other.my_health){
            CatDoor_hurt(_hitdmg, _hitvel, _hitdir);
        }
    }

#define CatDoor_cleanup
	surface_destroy(my_surf);
    instance_delete(my_wall);


#define CatGrenade_create(_x, _y)
    with(instance_create(_x, _y, CustomProjectile)){
         // Visual:
        sprite_index = sprToxicGrenade;
        mask_index = mskNone;

         // Vars:
        z = 1;
        zspeed = 0;
        zfric = 0.8;
        damage = 0;
        force = 0;
        right = choose(-1, 1);

        return id;
    }

#define CatGrenade_step
     // Rise & Fall:
    z_engine();
    depth = max(-z, -12);

     // Trail:
    if(chance_ct(1, 2)){
        with(instance_create(x + orandom(4), y - z + orandom(4), PlasmaTrail)) {
            sprite_index = sprToxicGas;
            image_xscale = 0.25;
            image_yscale = image_xscale;
            image_angle = random(360);
            image_speed = 0.4;
            depth = other.depth;
        }
    }

     // Hit:
    if(z <= 0) instance_destroy();

#define CatGrenade_draw
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale * right, image_angle - (speed * 2) + (max(zspeed, -8) * 8), image_blend, image_alpha);

#define CatGrenade_hit
    // nada

#define CatGrenade_wall
    // nada

#define CatGrenade_destroy
    with(instance_create(x, y, Explosion)){
        team = other.team;
        creator = other.creator;
        hitid = other.hitid;
    }

    repeat(18) {
        with(scrEnemyShoot(ToxicGas, random(360), 4)) {
            friction = 0.2;
        }
    }

     // Sound:
    sound_play(sndGrenade);
    sound_play(sndToxicBarrelGas);


#define CatHole_create(_x, _y)
    o = instance_create(_x, _y, CustomObject);
    with(o){
         // Visual:
        sprite_index = spr.ManholeBottom;
        image_speed = 0.4;
        depth = 7;

         // Vars:
        mask_index = mskSuperFlakBullet;
        fullofrats = true;
        target = noone;

         // don't mess with the big boy
        if(place_meeting(x, y, CustomObject)){
            with(instances_named(CustomObject, "CatHoleBig")){
                if(place_meeting(x, y, other)) with(other){
                    instance_destroy();
                    exit;
                }
            }
        }

        CatHoleCover();

        return id;
    }

#define CatHole_step
    if(instance_exists(target)){
         // Cat Move to Hole:
        if(CatHoleCover().open){
            var _x = x,
                _y = y - 4;

            with(target){
                if(point_distance(x, y, _x, _y) > 5){
                    sprite_index = spr_walk;
                    motion_add(point_direction(x, y, _x, _y), 1);
                    scrRight(direction);
                }
            }
        }

         // Cat Enter Hole:
        else{
            if(place_meeting(x, y, target)){
                target.active = false;

                 // FX:
                sound_play_pitch(target.snd_hurt, 1.3 + random(0.2));
                for(var a = 0; a < 360; a += (360 / 5)){
                    with(instance_create(target.x, target.y, Dust)){
                        motion_set(a + orandom(20), 3 + random(1));
                        depth = other.depth;
                    }
                }
            }
            target = noone;
        }
    }

#define CatHoleCover /// CatHoleCover(?_open = undefined)
    var _open = argument_count > 0 ? argument[0] : undefined;
    if(is_undefined(_open)) _open = false;

    var r = noone;

     // Find Cover:
    with(instances_matching(CustomDraw, "creator", id)){
        if(script[1] == mod_current && script[2] == "CatHoleCover_draw"){
            r = id;
        }
    }

     // Create New Cover:
    if(!instance_exists(r)){
        with(script_bind_draw(CatHoleCover_draw, 0)){
            sprite_index = spr.Manhole;
            image_speed = 0;
            creator = other;
            open = false;
            r = id;
        }
    }

     // Open:
    if(_open){
        with(r) if(image_index <= 0) open = true;
    }

     // Player Blocking:
    if(place_meeting(x, y, Player)){
        r.open = false;
        r.image_index = 6;
        with(Player) if(place_meeting(x, y, other)){
            motion_add(point_direction(other.x, other.y, x, y), 2);
        }
    }

    return r;

#define CatHoleCover_draw
    if(instance_exists(creator)){
        x = creator.x;
        y = creator.y;

        var _imgSpeed = creator.image_speed * current_time_scale;
        if(open){
            depth = -6;

             // Open:
            if(image_index <= 0){
                image_index = _imgSpeed;
            }

             // Close:
            else if(image_index >= 6){
                open = false;

                 // FX:
                view_shake_at(x, y, 10);
                instance_create(x, y, ImpactWrists);
                if(point_seen(x, y, -1)){
                    sound_play_pitch(sndHitMetal, 0.5 + random(0.2));
                }
            }
        }
        else depth = creator.depth - 1;

         // Animate:
        if(image_index > 0){
            image_index += _imgSpeed;
            if(image_index > image_number - 1){
                image_index = 0;
            }
        }

         // Draw Self:
        with(creator){
            draw_sprite_ext(other.sprite_index, other.image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
        }
    }
    else instance_destroy();


#define CatHoleBig_create(_x, _y)
    with(instance_create(_x, _y, CustomObject)){
         // Visual:
        spr_bot = spr.BigManholeBot;
        spr_top = spr.BigManholeTop;
        sprite_index = spr_top;
        image_speed = 0;
        depth = 8;

         // Vars:
        phase = 0;

         // Cool Light:
    	with(obj_create(x, y - 48, "CatLight")){
    		w1 = 16;
    		w2 = 48;
    		h1 = 48;
    		h2 = 24;
    	}

        return id;
    }

#define CatHoleBig_step
     // Animations:
    if image_index < 1 image_speed = 0;
    else image_speed = 0.4;

    if phase < 2{
         // Begin intro:
        if phase < 1{
            if instance_exists(Player)
                if instance_number(enemy) - instance_number(Van) < 1{
                    phase++;
                    alarm0 = 40;
                    alarm1 = 20;
                    obj_create(0, 0, "PortalPrevent");
                }
                
                 // Close portals:
                scrPortalPoof();
        }
        
         // Mid intro:
        else{
             // safety measures
            with instances_matching([WantRevivePopoFreak, Van, IDPDSpawn], "", null)
                alarm += max(1, current_time_scale);

             // Camera pan:
            var s = UberCont.opt_shake;
            UberCont.opt_shake = 1;
            for(var i = 0; i < maxp; i++){
                view_object[i] = id;
                view_pan_factor[i] = 10000;
            }
            UberCont.opt_shake = s;
        }
    }

     // Hole Collision:
    if(sprite_index == mskNone){
    	var _dis = 24;
	    with(instance_rectangle_bbox(x - _dis, y - _dis, x + _dis, y + _dis, [hitme, Corpse])){
	    	var	_x = other.x,
	    		_y = other.y - (sprite_get_bbox_bottom(sprite_index) - sprite_yoffset),
	    		_dir = point_direction(_x, _y, x, y);

	    	if(point_distance(_x, _y, x, y) < _dis){
	    		if(instance_is(self, Player)){
		    		x = _x + lengthdir_x(_dis, _dir);
		    		y = _y + lengthdir_y(_dis, _dir);
		    		direction += angle_difference(point_direction(xprevious, yprevious, x, y), direction) / 8;
	    		}
	    		else{
	    			motion_add(_dir, 1);
	    		}
	    	}
	    }

	     // Scorchmarks:
		var _dis = 36;
	    with(instances_matching(instance_rectangle_bbox(x - _dis, y - _dis, x + _dis, y + _dis, [Scorch, ScorchTop]), "bighole_check", null, false)){
	    	bighole_check = true;
	    	if(in_distance(other, _dis)) instance_destroy();
	    }
    }

#define CatHoleBig_alrm0
    phase++;

     // Reset camera:
    for(var i; i < maxp; i++){
        view_object[i] = player_find(i);
        view_pan_factor[i] = null;
    }
    
#define CatHoleBig_alrm1
    alarm1 = 30 + irandom(30);
    target = instance_nearest(x, y, Player);
    
    if(instance_exists(target)){
         // Release Bosses:
        if(phase >= 4){
            alarm0 = -1;
            alarm1 = -1;
            alarm2 = 8;
            sprite_index = mskNone;

			 // Bosses:
            obj_create(x, y, "CatBoss");
            obj_create(x, y, "BatBoss");

			 // Chunks:
			with([
				{	"num" : [6, 12],
					"spr" : spr.ManholeDebrisSmall,
					"ang" : 0,
					"spd" : [2, 8],
					"off" : 16
				},
				{	"num" : [3, 6],
					"spr" : spr.ManholeDebrisBig,
					"spd" : [4, 8],
					"off" : 8,
					"ang" : 360
				}
			]){
				var d = self;
				repeat(irandom_range(num[0], num[1])){
					with(instance_create(other.x, other.y, ScrapBossCorpse)){
						sprite_index = d.spr;
						image_index = irandom(image_number - 1);
						image_angle = random(d.ang);
						motion_set(random(360), random_range(d.spd[0], d.spd[1]));
						x += lengthdir_x(d.off, direction);
						y += lengthdir_y(d.off, direction);
						size = 0;
					}
				}
			}

			 // Effects:
			var o = 16;
            repeat(irandom_range(6, 18)) with instance_create(x, y, Dust){
                motion_set(90 + orandom(60), 6 + random(6));
                x += lengthdir_x(o, direction);
                y += lengthdir_y(o, direction);
                friction = 1;
            }
            sound_play_pitchvol(sndExplosion, 0.8, 1);
            sound_play_pitchvol(sndHitMetal, 0.4, 1);
            view_shake_at(x, y, 60);
            sleep(60);

			 // Allow Portal to Spawn:
            with(instances_named(CustomEnemy, "PortalPrevent")){
            	instance_delete(id);
            }

			 // Launch Player:
	    	var _dis = 24;
		    with(instance_rectangle_bbox(x - _dis, y - _dis, x + _dis, y + _dis, Player)){
		    	var	_x = other.x,
		    		_y = other.y - (sprite_get_bbox_bottom(sprite_index) - sprite_yoffset),
		    		_dir = point_direction(_x, _y, x, y);
		
		    	if(point_distance(_x, _y, x, y) < _dis){
					with(obj_create(x, y, "PalankingToss")){
						var f = (point_distance(_x, _y, x, y) / _dis);
						direction = _dir;
						speed = 6 * f;
						zfric = 0.6 + (0.4 * f);
						zspeed = 12;
						creator = other;
						depth = other.depth;
						mask_index = other.mask_index;
						spr_shadow_y = other.spr_shadow_y;
					}
		    	}
		    }
        }
        
         // Increment:
        else if((in_distance(target, 128) && in_sight(target)) || phase < 2){
            if(phase > 1) phase++;

            image_index = 1;

			 // Chunks:
            repeat(irandom_range(1, 3)) with(instance_create(x, y, Debris)){
                sprite_index =  spr.ManholeDebrisSmall;
                image_index =   irandom(image_number);
                motion_set(irandom(359), 4 + random(4));
                x += lengthdir_x(16, direction);
                y += lengthdir_y(16, direction);
            }

			 // Effects:
            var o = 18;
            repeat(irandom_range(4, 12)) with(instance_create(x, y, Dust)){
                motion_set(random(360), random(2));
                x += lengthdir_x(o, direction);
                y += lengthdir_y(o, direction);
            }
            sound_play_pitch(sndHitMetal, 0.5 + random(0.2));
            view_shake_at(x, y, 20);
            sleep(20);
        }
    }

#define CatHoleBig_alrm2
	scrBossIntro("CatBat", sndScorpionFireStart, musBoss2);
    
#define CatHoleBig_draw
    draw_sprite(spr_bot, 0, x, y);
    draw_sprite(sprite_index, image_index, x, y);

#define CatLight_create(_x, _y)
	var o = {
		x : _x,
		y : _y,
		w1 : 12,
		w2 : 32,
		h1 : 32,
		h2 : 8,
		offset : 0,
		active : true
	};

    array_push(global.catLight, o);

    return o;

#define CatLight_draw(_x, _y, _w1, _w2, _h1, _h2, _offset)
     // Trapezoid Bit:
    var _x1a = _x - (_w1 / 2),
        _x2a = _x1a + _w1,
        _y1 = _y,
        _x1b = _x - (_w2 / 2) + _offset,
        _x2b = _x1b + _w2,
        _y2 = _y + _h1;

    draw_trapezoid(_x1a, _x2a, _y1, _x1b, _x2b, _y2);

     // Half Oval Bit:
    var _segments = 8,
        _cw = _w2 / 2,
        _cx = _x1b + _cw,
        _cy = _y2;

    draw_primitive_begin(pr_trianglefan);
    draw_vertex(_cx, _cy);
    for(var i = 0; i <= _segments; i++){
        var a = (i / _segments) * -180;
        draw_vertex(_cx + lengthdir_x(_cw, a), _cy + lengthdir_y(_h2, a));
    }
    draw_primitive_end();


#define ChairFront_create(_x, _y)
    with(instance_create(_x, _y, CustomProp)){
         // Visual:
        spr_idle = spr.ChairFrontIdle;
        spr_hurt = spr.ChairFrontHurt;
        spr_dead = spr.ChairDead;

         // Sounds:
        snd_hurt = sndHitMetal;
        snd_dead = sndStreetLightBreak;

         // Vars:
        maxhealth = 4;
        size = 1;

        return id;
    }


#define ChairSide_create(_x, _y)
    with(obj_create(_x, _y, "ChairFront")){
         // Visual:
        spr_idle = spr.ChairSideIdle;
        spr_hurt = spr.ChairSideHurt;

        return id;
    }


#define Couch_create(_x, _y)
    with(instance_create(_x, _y, CustomProp)){
         // Visual:
        spr_idle = spr.CouchIdle;
        spr_hurt = spr.CouchHurt;
        spr_dead = spr.CouchDead;

         // Sounds:
        snd_hurt = sndHitPlant;
        snd_dead = sndWheelPileBreak;

         // Vars:
        maxhealth = 20;
        size = 3;

        return id;
    }


#define Manhole_create(_x, _y)
    with(instance_create(_x, _y, CustomObject)){
         // Visual:
        sprite_index = sprPizzaEntrance;
        image_speed = 0;
        mask_index = mskFloor;

         // Vars:
        depth = 8;
        toarea = "pizza"; // go to pizza sewers

        return id;
    }

#define Manhole_step
	if(image_index == 0 && place_meeting(x, y, Explosion)){
	    var _canhole = (!instance_exists(FrogQueen) && array_length(instances_named(CustomEnemy, "CatBoss")) <= 0);
	    if(_canhole){
	        image_index = 1;

	        with(GameCont){
	        	area = other.toarea;
	        	subarea = 0;
	        }
	        with(enemy) my_health = 0;

	         // Portal:
	        with(instance_create(x + 16, y + 16, Portal)){
	        	image_alpha = 0;
	        	with(instances_meeting(x, y, [Corpse, ChestOpen, Scorch, ScorchTop])) instance_destroy();
	        }
	        sound_stop(sndPortalOpen);
	    }
	}


#define NewTable_create(_x, _y)
    with(instance_create(_x, _y, CustomProp)){
         // Visual:
        spr_idle = spr.TableIdle;
        spr_hurt = spr.TableHurt;
        spr_dead = spr.TableDead;
        spr_shadow = shd32;
        depth--;

         // Sounds:
        snd_hurt = sndHitMetal;
        snd_dead = sndHydrantBreak;

         // Vars:
        maxhealth = 8;
        size = 2;

        return id;
    }


#define Paper_create(_x, _y)
    with(instance_create(_x, _y, Feather)){
    	 // Visual:
        sprite_index = spr.Paper;
        image_index = random(image_number);
        image_speed = 0;

         // Vars:
        friction = 0.2;

        return id;
    }


#define Pizza_create(_x, _y)
    with(instance_create(_x, _y, HPPickup)){
        sprite_index = sprSlice;
        num++;
        return id;
    }


#define PizzaBoxCool_create(_x, _y)
    with(instance_create(_x, _y, CustomProp)){
         // Visual:
        spr_idle = sprPizzaBox;
        spr_hurt = sprPizzaBoxHurt;
        spr_dead = sprPizzaBoxDead;

         // Sound:
        snd_hurt = sndHitPlant;
        snd_dead = sndPizzaBoxBreak;

         // Vars:
        maxhealth = 4;
        size = 1;

        return id;
    }

#define PizzaBoxCool_death
    var _num = choose(1, 2);

     // Big luck:
    if(chance(1, 10)){
        _num = 4;
        repeat(5) instance_create(x + orandom(4), y + orandom(4), Dust);
        sound_play_pitch(snd_dead, 0.6);
        snd_dead = -1;
    }

     // +Yum
    repeat(_num){
        obj_create(x + orandom(2 * _num), y + orandom(2 * _num), "Pizza");
    }


#define PizzaDrain_create(_x, _y)
    with(instance_create(_x, _y, CustomHitme)){
         // Visual:
        spr_idle = spr.PizzaDrainIdle;
        spr_walk = spr_idle;
        spr_hurt = spr.PizzaDrainHurt;
        spr_dead = spr.PizzaDrainDead;
        spr_shadow = mskNone;
        image_xscale = choose(-1, 1);
        image_speed = 0.4;
        depth = -1;

         // Sound:
        snd_hurt = sndHitMetal;
        snd_dead = sndStatueDead;

         // Vars:
        mask_index = msk.PizzaDrain;
        maxhealth = 40;
        team = 0;
        size = 3;

		 // Cool Floor:
		with(instance_nearest(_x - 16, _y, Floor)){
			image_index = 3;
		}

        return id;
    }

#define PizzaDrain_step
	 // Manual Collision for Projectiles Hitting Wall:
	if(place_meeting(x, y, projectile)){
		with(instances_meeting(x, y, projectile)){
			if(place_meeting(x, y, other) && place_meeting(x + hspeed, y + vspeed, Wall)){
				event_perform(ev_collision, hitme);
			}
		}
	}

     // Stay Still:
    x = (round(xstart / 16) * 16) - 16;
    y = (round(ystart / 16) * 16);
    speed = 0;

	if(!instance_exists(GenCont)){
	     // Floorerize:
	    var _x = x - 16,
	    	_y = y - 32;

	    if(!position_meeting(_x, _y, Floor)){
	    	with(instance_create(_x, _y, Floor)){
	    		sprite_index = area_get_sprite("secret", sprFloor1B);
	    	}
	    	for(var _y = bbox_top; _y < bbox_bottom - 16; _y += 16){
	    		instance_create(bbox_left, _y, FloorExplo);
	    		instance_create(bbox_right - 15, _y, FloorExplo);
	    	}
	    }

		 // Takeover Walls:
		if(place_meeting(x, y, Wall)){
			with(instance_nearest(bbox_left - 16, y - 16, Wall)) outindex = 0;
			with(instance_nearest(bbox_right,	  y - 16, Wall)) outindex = 0;
		    while(place_meeting(x, y, Wall)){
		    	with(instances_meeting(x, y, Wall)){
		    		instance_create(x, y, InvisiWall);
					sprite_index = sprWall102Trans;
					visible = true;
					topspr = -1;
					outspr = -1;
					y -= 16;
		    	}
		    }
		}
	}

     // Animate:
    if(sprite_index != spr_idle && anim_end){
        sprite_index = spr_idle;
    }

     // Break:
    if(place_meeting(x, y, Explosion)){
    	my_health = 0;
    }
    with(instances_matching_le(FloorExplo, "y", y - 320)){
        instance_create(x, y, PortalClear);
        other.my_health = 0;
    }
    with(instance_rectangle(bbox_left - 16, y - 320, bbox_right + 16, bbox_top - 16, FloorExplo)){
        instance_create(x, y, PortalClear);
        other.my_health = 0;
    }

     // Death:
    if(my_health <= 0) instance_destroy();

#define PizzaDrain_end_step
    x = (round(xstart / 16) * 16) - 16;
    y = (round(ystart / 16) * 16);
    speed = 0;

#define PizzaDrain_destroy
    sound_play(snd_dead);
	scrPortalPoof();

	 // Deleet Stuff:
	var _x1 = bbox_left,
		_y1 = bbox_top - 16,
		_x2 = bbox_right,
		_y2 = bbox_bottom;

	if(fork()){
		repeat(2){
			with(instance_rectangle(_x1, _y1, _x2, _y2, [Wall, TopSmall, InvisiWall])){
				instance_destroy();
			}
			wait 0;
		}
		exit;
	}

     // Corpse:
    with(instance_create(x, y, Corpse)){
        sprite_index = other.spr_dead;
        mask_index = other.mask_index;
        image_xscale = other.image_xscale;
        size = other.size;
    }

    /// Entrance:
        var _sx = (floor(x / 32) * 32),
            _sy = (floor(y / 32) * 32) - 16;

         // Borderize Area:
        var _borderY = _sy - 248;
        area_border(_borderY, string(GameCont.area), background_color);

         // Path Gen:
        var _dir = 90,
            _path = [];

        instance_create(_sx + 16, _sy + 16, PortalClear);
        while(_sy >= _borderY - 224){
            with(instance_create(_sx, _sy, Floor)){
                array_push(_path, id);

                 // Stuff in path fix:
                with(instances_meeting(x, y, [TopSmall, Wall])) instance_destroy();
            }

            if(!in_range(_sy, _borderY - 160, _borderY + 32)) _dir = 90;
            else{
                _dir += choose(0, 0, 0, 0, -90, 90);
                if(((_dir + 360) mod 360) == 270) _dir = 90;
            }

            _sx += lengthdir_x(32, _dir);
            _sy += lengthdir_y(32, _dir);
        }

         // Generate the Realm:
		if(!instance_exists(Portal)){
        	area_generate(_sx, _sy - 32, sewers);
		}

         // Finish Path:
        with(_path){
            sprite_index = area_get_sprite(sewers, sprFloor1B);
            scrFloorWalls();
        }
        floor_reveal(_path, 2);


#define PizzaManholeCover_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		sprite_index = spr.Manhole;
        image_angle = 180 + (irandom_range(-3, 3) * 10);
        image_speed = 0;
        depth = 6;

		x += orandom(8);
		y += orandom(8);

		return id;
	}


#define PizzaTV_create(_x, _y)
    with(instance_create(_x, _y, TV)){
         // Visual:
        spr_hurt = spr.TVHurt;
        spr_dead = spr_hurt;

         // Vars:
        maxhealth = 15;
        my_health = maxhealth;

	    return id;
    }

#define PizzaTV_end_step
	x = xstart;
	y = ystart;
    depth = 0; // why must i force depth every frame mmmm

     // Death without needing a corpse sprite haha:
    if(my_health <= 0){
        with(instance_create(x, y, Corpse)){
            sprite_index = other.spr_dead;
            mask_index = other.mask_index;
            size = other.size;
        }

         // Zap:
        sound_play_pitch(sndPlantPotBreak, 1.6);
        sound_play_pitchvol(sndLightningHit, 1, 2);
        repeat(2) instance_create(x, y, PortalL);

        instance_delete(id);
    }


#define TurtleCool_create(_x, _y)
	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		spr_idle = sprTurtleIdle;
		spr_walk = sprTurtleFire;
		spr_hurt = sprTurtleHurt;
		spr_dead = sprTurtleDead;
		spr_shadow = shd24;
		image_speed = 0.4;
		depth = -2;

		 // Sound:
		snd_hurt = sndTurtleHurt;
		snd_dead = sndTurtleDead1;

		 // Vars:
		mask_index = mskBandit;
		friction = 0.4;
		maxhealth = 15;
		size = 4;
		team = 1;
		right = choose(-1, 1);
		patience = random_range(30, 40);
		notice_delay = random_range(1, 8);
		notice_max = 80;
		notice = notice_max;
		become = Turtle;

		return id;
	}

#define TurtleCool_step
	if(!point_seen(x, y, -1) && patience > 0) exit;

	 // Noticable Players:
	var p = [];
	with(Player){
		if(point_seen(other.x, other.y, index) && in_sight(other)){
			array_push(p, id);
		}
	}

	 // Notice Player:
	with(instances_matching_gt(p, "reload", 0)){
		with(other){
			notice = max(notice, 8);
			notice += ((other.reload / 3) + random(3)) * current_time_scale;
			patience -= current_time_scale;
		}
	}
	with(instances_matching_gt(instances_matching(p, "race", "steroids"), "breload", 0)){
		with(other){
			notice = max(notice, 8);
			notice += (other.breload / 3) * current_time_scale;
			patience -= current_time_scale;
		}
	}
	var t = nearest_instance(x, y, p);
	if(instance_exists(t) && notice > 0){
		if(notice_delay > 0){
			notice_delay -= current_time_scale;

			 // Initial Notice:
			if(notice_delay <= 0){
				instance_create(x, y, SteroidsTB);
			}
		}

		 // Face Player:
		else{
			notice -= current_time_scale;
			scrRight(point_direction(x, y, t.x, t.y));
		}
	}

	 // Watchin TV:
	else{
		var t = instance_nearest(x, y, TV);
		if(in_sight(t) && in_distance(t, 96)){
			scrRight(point_direction(x, y, t.x, t.y));
		}
	}

	 // Push Collision:
	if(place_meeting(x, y, hitme)){
		with(instances_meeting(x, y, hitme)){
			if(place_meeting(x, y, other)){
				if(!instance_is(self, prop)){
					motion_add(point_direction(other.x, other.y, x, y), 1);
				}
				with(other){
					if(instance_is(other, Player)){
						notice = max(notice, 30);
						patience -= current_time_scale;
					}
					motion_add(point_direction(other.x, other.y, x, y), 1);
				}
			}
		}
	}
	speed = min(speed, 2.5);

	 // Wall Collision:
	if(place_meeting(x + hspeed, y + vspeed, Wall)){
		if(place_meeting(x + hspeed, y, Wall)) hspeed = 0;
		if(place_meeting(x, y + vspeed, Wall)) vspeed = 0;
	}

	 // Angered:
	var _angered = false;
	if(my_health < maxhealth || !instance_exists(TV)){
		_angered = true;
	}
	else{
		with(instances_matching([Turtle, Rat], "", null)){
			if(my_health < maxhealth && in_sight(other)){
				_angered = true;
			}
		}
		with(instances_matching(Corpse, "sprite_index", sprTurtleDead, sprRatDead)){
			if(in_sight(other)){
				_angered = true;
			}
		}
	}
	if(_angered){
		with(instances_named(object_index, name)) patience = 0;
	}
	if(patience <= 0){
		var o = (my_health - maxhealth),
			s = { "x":x, "y":y, "nexthurt":nexthurt, "sprite_index":sprite_index, "image_index":image_index, "snd_dead":snd_dead, "right":right };

		instance_change(become, true);

		my_health += o;
		for(var i = 0; i < lq_size(s); i++){
			variable_instance_set(id, lq_get_key(s, i), lq_get_value(s, i));
		}

		alarm1 = 10 + random(10);

		 // Alert:
		sound_play_hit(sndTurtleMelee, 0.3);
		instance_create(x, y, AssassinNotice);
		if(my_health < maxhealth){
			if(hspeed != 0) right = -sign(hspeed);
		}
	}

#define TurtleCool_draw
	draw_self_enemy();


#define VenomFlak_create(_x, _y)
    with(instance_create(_x, _y, CustomProjectile)){
         // Visual:
        sprite_index = spr.VenomFlak;
        image_speed = 0.4;

         // Vars:
        friction = 0.4;
        damage = 6;
        force = 6;
        typ = 1;
        creator = noone;
        charging = true;

		 // Alarms:
        alarm0 = 15;

        return id;
    }

#define VenomFlak_step
	if(charging){
		speed += friction;

		 // Follow Creator:
		if(instance_exists(creator)){
			xstart = creator.x + (hspeed * 0.5);
			ystart = creator.y + (vspeed * 0.5);
			creator.wkick += random_range(1, 2) * current_time_scale;
		}

		x = xstart;
		y = ystart;
		xprevious = x;
		yprevious = y;
		 
		 // Effects 1:
		if(chance_ct(1, 4)){
			var f = 0.6;
		    with(instance_create(x + (hspeed * f) + orandom(4), y + (vspeed * f) + orandom(4), AcidStreak)){
		    	sprite_index = spr.AcidPuff;
		        image_angle = other.direction + orandom(60);
		    	depth = -2;

		        if(instance_exists(other.creator)){
		            x += other.creator.hspeed;
		            y += other.creator.vspeed;
		        }
		    }
		}
	}
	else{
         // Effects 2:
        if(chance_ct(1, 3)){
            with(instance_create(x + orandom(2), y + orandom(2), Smoke)){
                depth = other.depth + 1;
            }
        }
	}

	 // Effects 3:
    if(chance_ct(1, 3)){
        with(instance_create(x + orandom(6), y + 16 + orandom(6), RecycleGland)){
            sprite_index = sprDrip; // Drip object is noisy :jwpensive:
            depth = 0;
        }
    }

#define VenomFlak_draw
	if(charging){
		var _scale = 0.25 + (1 - (alarm0 / 15)) + random(0.2);
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * _scale, image_yscale * _scale, image_angle, image_blend, image_alpha);
	}
	else draw_self();

#define VenomFlak_alrm0
	if(charging){
		charging = false;

		alarm0 = 40;

		with(creator){
             // Fire:
            motion_add(gunangle + 180, maxspd);

             // Effects:
            wkick = min(wkick + 9, 16);
            sound_play_pitchvol(sndFlakCannon,			0.8,				0.4);
            sound_play_pitchvol(sndCrystalRicochet,		1.4 + random(0.4),	0.8);
            sound_play_pitchvol(sndLightningRifleUpg,	0.8,				0.4);

            repeat(3 + irandom(2)){
            	scrFX([x, 6], [y, 6], [gunangle + orandom(2), 4 + random(4)], Smoke);
            }
		}
	}

	 // Explode:
	else instance_destroy();

#define VenomFlak_wall
	if(!charging && speed > 1){
		 // Bounce:
	    if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
	    if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;
	    speed = min(speed, 8);
	
	     // Effects:
	    with instance_create(x, y, AcidStreak){
	        motion_set(other.direction, 3);
	        image_angle = direction;
	         // fat splat:
	        image_yscale *= 2;
	    }
	
	    sound_play_pitchvol(sndShotgunHitWall,	1.2, 1);
	    sound_play_pitchvol(sndFrogEggHurt,		0.7, 0.2);
	}

#define VenomFlak_destroy
    instance_create(x, y, PortalClear);

     // Effects:
    for(var a = 0; a < 360; a += (360 / 20)){
        scrFX(x, y, [a, 4 + random(4)], Smoke);
    }

    view_shake_at(x, y, 20);

    sound_play_pitchvol(sndHeavyMachinegun, 1,					0.8);
    sound_play_pitchvol(sndSnowTankShoot,	1.4,				0.7);
    sound_play_pitchvol(sndFrogEggHurt,		0.4 + random(0.2),	3.5);

     // Projectiles:
    for(var d = 0; d < 360; d += (360 / 12)){
         // Venom Lines:
        if((d mod 90) == 0){
            for(var i = 0; i <= 5; i++){
                with(scrEnemyShoot("TrafficCrabVenom", direction + d + orandom(2 + i), 2 * i)){
                    move_contact_solid(direction, 4 + (4 * i));

                     // Effects:
                    with(instance_create(x, y, AcidStreak)){
                        motion_set(other.direction + orandom(4), other.speed * 0.8);
                        image_angle = direction;
                    }
                }
            }
        }

         // Individual:
        else{
            with(scrEnemyShoot("TrafficCrabVenom", direction + d + orandom(2), 5.8 + random(0.4))){
                move_contact_solid(direction, 6);
            }
        }
    }


/// Mod Events
#define step
     // Reset Lights:
    with(instances_matching(GenCont, "catlight_reset", null)){
        catlight_reset = true;
        global.catLight = [];
    }

#define draw_shadows
	 // Fix Pizza Drain Shadows:
	with(instances_named(CustomHitme, "PizzaDrain")) if(visible){
		draw_sprite_ext(sprite_index, image_index, x, y - 14, image_xscale, -image_yscale, image_angle, c_white, 1);
	}

#define draw_dark // Drawing Grays
    draw_set_color(c_gray);

     // Cat Light:
    with(global.catLight){
        offset = random_range(-1, 1);

         // Flicker:
        if(current_frame_active){
            if(chance(1, 60)) active = false;
            else active = true;
        }

        if(active){
            var b = 2; // Border Size
            CatLight_draw(x, y, w1 + b, w2 + (3 * (2 * b)), h1 + (2 * b), h2 + b, offset);
        }
    }

	 // Manhole Cover:
	with(instances_named(CustomObject, "PizzaManholeCover")){
		draw_circle(xstart, ystart - 16, 40 + random(2), false);
	}

     // TV:
    with(TV) draw_circle(x, y, 64 + random(2), false);

     // Big Bat:
    with(instances_named(CustomEnemy, ["BatBoss", "CatBoss"])){
    	if("active" not in self || active) draw_circle(x, y, 64 + random(2), false);
    }
    
     // Big Manhole:
    with(instances_named(CustomObject, "CatHoleBig")){
        draw_circle(x, y, 192 + random(2), false);
    }

#define draw_dark_end // Drawing Clear
    draw_set_color(c_black);

     // Cat Light:
    with(global.catLight) if(active){
        CatLight_draw(x, y, w1, w2, h1, h2, offset);
    }

	 // Manhole Cover:
	with(instances_named(CustomObject, "PizzaManholeCover")){
		var o = 0;
		if(chance(1, 2)) o = orandom(1);
		CatLight_draw(xstart, ystart - 32, 16, 19, 28, 8, o);
	}

     // TV:
    with(TV){
        var o = orandom(1);
        CatLight_draw(x + 1, y - 6, 12 + abs(o), 48 + o, 48, 8 + o, 0);
    }

     // Big Bat:
    with(instances_named(CustomEnemy, ["BatBoss", "CatBoss"])){
    	if("active" not in self || active) draw_circle(x, y, 28 + random(2), false);
    }

#define draw_bloom
    with(instances_named(CustomProjectile, "VenomFlak")){
        draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
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
#define in_distance(_inst, _dis)			                                            return  mod_script_call(   "mod", "telib", "in_distance", _inst, _dis);
#define in_sight(_inst)																	return  mod_script_call(   "mod", "telib", "in_sight", _inst);
#define chance(_numer, _denom)															return	mod_script_call_nc("mod", "telib", "chance", _numer, _denom);
#define chance_ct(_numer, _denom)														return	mod_script_call_nc("mod", "telib", "chance_ct", _numer, _denom);
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
#macro sewers "secret"
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
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc("mod", "telib", "scrFX", _x, _y, _motion, _obj);
#define array_combine(_array1, _array2)                                                 return  mod_script_call(   "mod", "telib", "array_combine", _array1, _array2);