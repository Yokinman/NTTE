#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.sav = mod_variable_get("mod", "teassets", "sav");

    global.debug_lag = false;

	global.surfShadowTop = surflist_set("ShadowTop", 0, 0, game_width, game_height);
	global.surfPet = surflist_set("Pet", 0, 0, 64, 64);

    global.poonRope = [];

    global.pickup_custom = [];

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav
#macro opt sav.option

#macro DebugLag global.debug_lag

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)

#macro surfShadowTop global.surfShadowTop
#macro surfPet global.surfPet


#define AllyFlakBullet_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.AllyFlakBullet;
		hitid = [sprite_index, "ALLY FLAK BULLET"];

		 // Vars:
		mask_index = mskFlakBullet;
		friction = 0.3;
		damage = 4;
		force = 6;
		ammo = 10;
		typ = 1;

		return id;
	}

#define AllyFlakBullet_step
	 // Trail:
	if(chance_ct(1, 3)){
		with(instance_create(x, y, Smoke)){
			motion_add(random(360), random(2));
		}
	}

	 // Animate:
	image_speed = speed / 12;

	 // End:
	if(speed <= 0 || place_meeting(x, y, Explosion)){
		instance_destroy()
	}

#define AllyFlakBullet_destroy
	repeat(ammo){
		with(instance_create(x, y, Bullet2)){
			sprite_index = spr.AllyBullet3;
			motion_add(random(360), random_range(9, 12));
			image_angle = direction;
			bonus = false;
			team = other.team;
			hitid = other.hitid;
			creator = other.creator;
		}
	}

	 // Effects:
	sound_play_pitch(sndFlakExplode, 1 + orandom(0.1));
	view_shake_at(x, y, 8);
	repeat(6){
		with(instance_create(x, y, Smoke)){
			motion_add(random(360), random(3));
		}
	}
	with(instance_create(x, y, BulletHit)){
		sprite_index = sprFlakHit;
	}


#define Backpack_create(_x, _y)
	with(obj_create(_x, _y, "CustomChest")){
		 // Visual:
		spr_open = spr.BackpackOpen;
		sprite_index = spr.Backpack;
		spr_shadow_y = 2;
		spr_shadow = shd16;

		 // Sounds:
		snd_open = choose(sndMenuASkin, sndMenuBSkin);

		 // Vars:
		raddrop = 8;
		switch(crown_current){
			case crwn_none:		curse = false;			break;
			case crwn_curses:	curse = chance(2, 3);	break;
			default:			curse = chance(1, 7);
		}

		 // Cursed:
		if(curse){
			spr_open = spr.BackpackCursedOpen;
			sprite_index = spr.BackpackCursed;
		}

		 // Events:
		on_open = script_ref_create(Backpack_open);
		on_step = script_ref_create(Backpack_step);

		return id;
	}
	
#define Backpack_step
	 // Curse FX:
	if(chance_ct(curse, 20)){
		instance_create(x + orandom(8), y + orandom(8), Curse);
	}

#define Backpack_open
	if(curse) sound_play(sndCursedChest);
	sound_play_pitchvol(sndPickupDisappear, 1 + orandom(0.4), 2);

	 // Merged Weapon:	
	var _part = wep_merge_decide(0, GameCont.hard + (curse ? 2 : 0));
	if(array_length(_part) >= 2){
		with(instance_create(x, y, WepPickup)){
			wep = wep_merge(_part[0], _part[1]);
			curse = other.curse;
			ammo = true;
			roll = true;
		}
	}
	
	 // Pickups:
	var _ang = random(360);
	for(var d = _ang; d < _ang + 360; d += (360 / 2)){
		with(obj_create(x, y, "BackpackPickup")){
			direction = d;
			curse = other.curse;
			if(curse && object == AmmoPickup){
				sprite_index = sprCursedAmmo;
			}
		}
	}
	
	 // Rads:
	repeat(raddrop){
		with(instance_create(x, y, Rad)){
			motion_add(random(360), random_range(3, 5));
		}
	}

	 // Restore Strong Spirit:
	with(other) if(instance_is(id, Player) && skill_get(mut_strong_spirit) && !canspirit){
		var i = index;
			
		canspirit = true;
		GameCont.canspirit[i] = false;
		with(instance_create(x, y, StrongSpirit)){
			sprite_index = sprStrongSpiritRefill;
			creator = i;
		}
		
		sound_play(sndStrongSpiritGain);
	}


#define BackpackPickup_create(_x, _y)
	instance_create(_x, _y, Dust);
	with(instance_create(_x, _y, CustomObject)){
		 // Determine Pickup:
		var _choices = [AmmoPickup, HPPickup];
		if(array_length(instances_matching(Player, "race", "rogue")) > 0) array_push(_choices, RoguePickup);
		
		object = _choices[irandom(array_length(_choices) - 1)];
		switch(crown_current){
			case crwn_life: object = AmmoPickup; break;
			case crwn_guns: object = HPPickup;	 break;
		}

		 // Visual:
		sprite_index = object_get_sprite(object);
		image_speed = 0;
		depth = -3;

		 // Vars:
		mask_index = mskPickup;
        z = 0;
        zspeed = random_range(2, 4);
        zfric = 0.7;
        curse = false;
		direction = random(360);
		speed = random_range(1, 3); // factor in crowns

		return id;
	}

#define BackpackPickup_step
	 // Collision:
	if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
		if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
		if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
	}

	z_engine();
	if(z <= 0) instance_destroy();

#define BackpackPickup_draw
	image_alpha = abs(image_alpha);
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	image_alpha = -image_alpha;

#define BackpackPickup_destroy
	with(instance_create(x, y - z, object)){
		sprite_index = other.sprite_index;
		direction = other.direction;
		speed = other.speed;
		if("curse" in self) curse = other.curse;
		if("cursed" in self) cursed = other.curse; // Bro why do ammo pickups be inconsistent
	}


#define BatDisc_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.BatDisc;
		mask_index = mskFlakBullet;
		depth = -3;
		
		 // Vars:
		friction = 0.4;
		maxspeed = 12;
		damage = 3;
		typ = 2;
		my_lwo = noone;
		ammo = 1;
		has_hit = false;
		returning = false;
		return_to = noone;
		big = false;
		key = "";
		seek = 42;
		in_wall = false;
		
		 // Big Bat Disc:
		if(fork()){
			wait(0);
			if(instance_exists(self) && big){
				 // Visual:
				sprite_index = spr.BatDiscBig;
				mask_index = mskSuperFlakBullet;
				
				 // Vars:
				damage = 8;
				ammo *= 7;
				seek = 64;
				
				alarm1 = 30;
			}
			exit;
		}
		
		return id;
	}
	
#define BatDisc_step
	speed = min(speed, maxspeed);
	image_angle += 40 * current_time_scale;
	
	image_index = 0;
	
	 // Targeting:
	var a = [];
	with(["wep", "bwep"]){
		var i = self,
			o = other;
			
		with(instances_matching([Player, WepPickup, ThrownWep], i, o.my_lwo)){
			array_push(a, id);
		}
	}
	
	if(array_length(a)){
		 // Set return target:
		return_to = nearest_instance(x, y, a);

		if(current_frame_active){
			 // Effects:
			if(in_wall){
				view_shake_max_at(x, y, 4);
				
				 // Dust trail:
				if(chance(1, 3)) instance_create(x, y, Dust).depth = -9;
				
				 // Exit wall:
				if(place_meeting(x, y, Floor) && !place_meeting(x, y, Wall)){
					in_wall = false;
					
					 // Effects:
					var d = direction;
					
					with(instance_create(x, y, Debris)) motion_set(d + orandom(40), 4 + random(4));
					instance_create(x, y, Smoke);
				}
			
				 // Be invisible inside walls:
				if(place_meeting(x, y, TopSmall) || !place_meeting(x, y, Floor)){
					visible = false;
				}
				else visible = true;
			}
			
			 // Disc trail:
			else{
				instance_create(x, y, DiscTrail).sprite_index = (big ? spr.BigDiscTrail : sprDiscTrail);
			}
			
			var m = skill_get(mut_bolt_marrow),
				e = nearest_instance(x, y, instances_matching_ne([enemy, Player, Sapling, Ally, SentryGun, CustomHitme], "team", team, 0));
				
			if(instance_exists(return_to) && !(in_distance(creator, 160) && in_distance(e, (seek * m)))){
				 // Seek creator:
				if(returning){
					if(!big){
						var d = point_direction(x, y, return_to.x, return_to.y);
						
						if(!place_meeting(x, y, return_to)){
							var _speed = friction * 2;
							if(in_distance(return_to, 32)){
								_speed = 2;
								speed = max(0, speed - 0.8);
							}
							
							motion_add(d, _speed);
						}
						
						 // Return disc to gun:
						else{
							var _wep = my_lwo,
								_dir = direction;
								
							with(return_to){
								 // Player specific effects:
								if(instance_is(id, Player)){
									with(["", "b"]){
										var i = self;
										with(instances_matching(other, i + "wep", _wep))
											variable_instance_set(id, i + "wkick", abs(angle_difference(gunangle, _dir)) > 90 ? 6 : -6);
											 // yeah that part is gross i know
									}
								}
								
								 // General:
								motion_add(other.direction, 2);
							}
							
							 // Sounds:
							sound_play_pitchvol(sndDiscgun, 	0.8 + random(0.4), 0.6);
							sound_play_pitchvol(sndCrossReload, 0.6 + random(0.4), 0.8);
							view_shake_max_at(x, y, 12);
							
							instance_destroy();
						}
					}
				}
				
				 // Return when slow:
				else if(speed <= 5){
					returning = true;
				}
			}
			
			 // Seek targets:
			else{
				var d = point_direction(x, y, e.x, e.y);
				
				 // Movement:
				speed = max(speed - friction, 0);
				motion_add(d, 1);
				
				 // Animation:
				image_index = 1;
			}
		}
	}
	
	 // Destroy if no valid target to return to:
	else{
		instance_destroy();
	}
	
#define BatDisc_end_step
	if(current_frame_active){
		 // Go through walls:
	    if(returning && place_meeting(x + hspeed, y + vspeed, Wall)){
	        if(place_meeting(x + hspeed, y, Wall)) x += hspeed;
	        if(place_meeting(x, y + vspeed, Wall)) y += vspeed;
	    }
	    
		 // Unstick:
		if(x == xprevious && hspeed != 0) x += hspeed;
		if(y == yprevious && vspeed != 0) y += vspeed;
	}
	
#define BatDisc_alrm1
	 // Projectiles:
	for(var d = 0; d < 360; d += 360 / 7){
		with(obj_create(x, y, "BatDisc")){
			visible = other.visible;
			in_wall = other.in_wall;
			creator = other.creator;
			my_lwo = other.my_lwo;
			team = other.team;
			ammo *= sign(other.ammo);
			motion_set(other.direction + d, maxspeed);
		}
	}
	
	 // Effects:
	view_shake_at(x, y, 20);
	repeat(7 + irandom(7)) with(instance_create(x, y, Smoke)) motion_set(irandom(359), random(6)); 
	 
	 // Sounds:
	sound_play_pitch(sndClusterLauncher, 0.8 + random(0.4));
	
	 // Goodbye:
	ammo = 0;
	instance_destroy();
	
#define BatDisc_hit
	if(projectile_canhit(other)){
		projectile_hit_raw(other, damage, sndDiscHit);
		
		has_hit = true;
		
		 // Effects:
		instance_create(x, y, Smoke);
		
		var _big = ((other.size >= 3 && big));
		
		view_shake_max_at(x, y, (_big ? 12 : 6));
		
		if(other.my_health <= 0){
			sleep_max(_big ? 48 : 24);
			view_shake_max_at(x, y, (_big ? 32 : 16))
		}
	}
	
#define BatDisc_wall
	if((!returning || big) && !has_hit && instance_exists(return_to)){
		returning = true;
		
		 // Effects:
		instance_create(x + hspeed, y + vspeed, MeleeHitWall).image_angle = direction;
		
		 // Bounce towards creator:
		direction = point_direction(x, y, return_to.x, return_to.y);
		
		 // Sounds:
		sound_play_hit(sndDiscBounce, 0.4);
	}
	
	else{
		if(!in_wall){
			in_wall = true;
			
			 // Effects:
			instance_create(x, y, Smoke);
			
			view_shake_max_at(x, y, 8);
			sleep_max(8);
			
			 // Sounds:
			sound_play_hit(sndPillarBreak, 0.4);
			sound_play_hit(sndDiscHit, 0.4);
		}
	}

#define BatDisc_cleanup
	with(my_lwo){
		ammo += other.ammo;
		if("amax" in self){
			ammo = min(ammo, amax);
		}
	}

	
#define BigDecal_create(_x, _y)
    var a = string(GameCont.area);
    if(lq_exists(spr.BigTopDecal, a)){
		with(instance_create(floor(_x / 16) * 16, floor(_y / 16) * 16, CustomObject)){
		     // Visual:
		    sprite_index = lq_get(spr.BigTopDecal, a);
			image_xscale = choose(-1, 1);
			image_speed = 0.4;
			depth = -7.01;

             // Vars:
    		mask_index = msk.BigTopDecal;
    		area = GameCont.area;

             // Avoid Bad Stuff:
            var _tries = 1000;
		    while(_tries-- > 0){
		        if(place_meeting(x, y, TopPot) || place_meeting(x, y, Bones) || place_meeting(x, y, Floor)){
		            var _dis = 16,
		                _dir = irandom(3) * 90;

		            x += lengthdir_x(_dis, _dir);
		            y += lengthdir_y(_dis, _dir);
		        }
		        else break;
		    }

             // TopSmalls:
    		var _off = 16,
    		    s = _off * 3;

    		for(var _ox = -s; _ox <= s; _ox += _off){
    		    for(var _oy = -s; _oy <= s; _oy += _off){
    		        if(!position_meeting(x + _ox, y + _oy, Floor)){
    		            if(chance(1, 2)) instance_create(x + _ox, y + _oy, TopSmall);
    		        }
    		    }
    		}

    		 // TopDecals:
    		var _num = irandom(4),
    		    _ang = random(360);

    		for(var i = _ang; i < _ang + 360; i += (360 / _num)){
    		    var _dis = 24 + random(12),
    		        _dir = i + orandom(30);

                with(scrTopDecal(0, 0, GameCont.area)){
                	if(sprite_index == sprTopDecalScrapyard){
                		image_index = choose(1, 2);
                	}

                    x = other.x + lengthdir_x(_dis * 1.5, _dir);
                    y = other.y + lengthdir_y(_dis, _dir) + 40;
                    if(place_meeting(x, y, Floor)) instance_destroy();
                }
    		}

    		 // Specifics:
    		switch(area){
    			case 3: // Ravens
					repeat(3){
						with(obj_create(x, y, "NestRaven")){
							var _tries = 100,
								_x = 0,
								_y = 0;

							while(_tries-- > 0){
								_x = random_range(-12, 12);
								_y = (chance(1, 4) ? -12 : random(16));
								x = other.x + _x;
								y = other.y + _y;

								var n = nearest_instance(x, y, instances_matching_ne(instances_matching(CustomObject, "name", "NestRaven"), "id", id));
								if(!instance_exists(n) || point_distance(x, y, n.x, n.y) > 16){
									break;
								}
							}
						}
					}

					var l = 32,
						d = random(360);

					obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "NestRaven");
    				break;

    			case 4:
    			case 104: // Face drill
    				with(nearest_instance(x - 16, y - 16, instances_matching_le(instances_matching_ge(Floor, "bbox_top", y - 16), "bbox_bottom", y + 48))){
    					var _fx = (bbox_left + bbox_right) / 2;
    					if(_fx != other.x){
    						other.image_xscale = -sign(_fx - other.x);
    					}
    				}
    				break;
    		}

    		return id;
		}
    }
    return noone;

#define BigDecal_step
    if(!instance_exists(GenCont)){
         // Area-Specifics:
        switch(area){
            case "trench":
                var _vents = [
                    [  2, -14],
                    [ 15,   8],
                    [  1,   0],
                    [-19,  17],
                    [-12,  25],
                    [ 11,  28],
                    [ 24,  18]
                ];

                // Trench vent bubbles:
                for(var i = 0; i < array_length(_vents); i++){
                    if(chance_ct(1, 8)){
                        var p = _vents[i];
                        with(instance_create(x + p[0], y + p[1], Bubble)){
                            depth = -9;
                            friction = 0.2;
                            motion_set(90 + orandom(5), random_range(4, 7));
                        }
                    }
                }
                break;
        }

         // he ded lol:
        if(place_meeting(x, y, Floor)){
            instance_destroy();
        }
    }

#define BigDecal_draw
	 // Flying Ravens:
    /*
    with(instance_rectangle(bbox_left, bbox_top - 32, bbox_right, bbox_bottom + 64, RavenFly)){
    	draw_sprite_ext(sprite_index, image_index, x, y + z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
    }
    */

     // Bubble Fix:
    if(distance_to_object(Bubble) < 40){
        with(instance_rectangle(bbox_left, bbox_top - 32, bbox_right, bbox_bottom, Bubble)){
            draw_self();
        }
    }

#define BigDecal_destroy
     // General FX:
    sleep(100);
    view_shake_at(x, y, 50);
    with(instance_create(x, y, PortalClear)){
        mask_index = other.mask_index;
    }
    repeat(irandom_range(9, 18)){
        with(instance_create(x, y, Debris)){
            speed = random_range(6, 12);
            if(!place_meeting(x + hspeed_raw, y + vspeed_raw, Floor)){
            	speed /= 3;
            }
        }
    }

     // Area-Specifics:
    var _x = x,
        _y = y + 16;

    switch(area){
        case 1: // Spawn a handful of crab bones:
            repeat(irandom_range(2, 3)) with instance_create(_x, _y, WepPickup){
                motion_set(irandom(359), random_range(3, 6));
                wep = "crabbone";
            }
            break;

        case 2: // Spawn a bunch of frog eggs:
            repeat(irandom_range(3, 5)){
                with(instance_create(_x, _y, FrogEgg)){
                    alarm0 = irandom_range(20, 60);

                     // Space Out Eggs:
                    var _tries = 50;
                    do{
                        x = _x + orandom(24);
                        y = _y + random(16);
                        xprevious = x;
                        yprevious = y;
                        if(!place_meeting(x, y, FrogEgg)) break;
                    }
                    until (_tries-- <= 0);
                }
            }
            break;

		case 3: // Nest bits:
			repeat(irandom_range(12, 14)){
                with(instance_create(_x + orandom(24), _y + orandom(12) - random(8), Feather)){
                	motion_add(point_direction(_x, _y, x, y), random(6));
                    sprite_index = spr.NestDebris;
                    image_index = irandom(irandom(image_number - 1));
                    fall /= 1 + (image_index / 8);
                    image_speed = 0;
                    depth = -1;
                }
			}
			break;

		case 4:
		case 104: // Drill Explosion
			var _ang = random(360);
			for(i = 0; i < 2; i++){
				var _dis = 12 + random(8),
					_dir = _ang + (i * 180) + orandom(20);

				with(instance_create(_x + lengthdir_x(_dis, _dir), _y + lengthdir_y(_dis, _dir), Grenade)){
					alarm0 = 1 + (i * 4);
					mask_index = mskNone;
					visible = false;
					repeat(irandom_range(1, 3)) with(instance_create(x + orandom(8), y + orandom(8), MiniNade)){
						alarm0 = other.alarm0 + random(2);
						mask_index = mskNone;
						visible = false;
					}
				}
			}

			 // Sticky Floor:
			/*for(var _ox = -32; _ox <= 0; _ox += 32){
				with(instance_rectangle(_x + _ox, _y, _x + _ox + 32, _y + 32, FloorExplo)){
					instance_destroy();
				}
				with(instance_create(_x + _ox, _y, Floor)){
					sprite_index = ((other.area == 104) ? sprFloor104B : sprFloor4B);
					styleb = true;
					traction = 2;
					material = 5;
					depth = 8;
				}
			}*/

			 // Wall Crystals:
			repeat(irandom_range(2, 3)){
				var e = ((area == 104) ? InvLaserCrystal : LaserCrystal);
				if(chance(1, 3)) e = LightningCrystal;

				with(instance_create(_x, _y, e)){
					nexthurt = current_frame + 30;
					my_health += 16;

					 // Space Out:
                    var _tries = 50;
                    do{
                        x = _x + orandom(24);
                        y = _y + random(16);
                        xprevious = x;
                        yprevious = y;
                        if(!place_meeting(x, y, crystaltype)) break;
                    }
                    until (_tries-- <= 0);

					 // Props:
					repeat(irandom_range(1, 2)){
						var e = ((other.area == 104) ? InvCrystal : CrystalProp);
						with(instance_create(x + orandom(12), y + orandom(12), e)){
							nexthurt = current_frame + 30;
							my_health += 48;
						}
					}
				}
			}
			break;

        case "pizza": // Pizza time
            repeat(irandom_range(4, 6)){
                obj_create(_x + orandom(4), _y + orandom(4), "Pizza");
                with(scrWaterStreak(_x, _y, random(360), 4 + random(4))){
                    image_blend = c_orange;
                    image_speed *= random_range(0.5, 1.25);
                    depth = -3;
                }
            }
            break;

		case "oasis": // They livin in there u kno
			repeat(4){
				var _sx = _x + orandom(24),
					_sy = _y + orandom(16);

				if(chance(1, 100)){
					instance_create(_sx, _sy, Freak);
				}
				else{
					obj_create(_sx, _sy, choose(BoneFish, "Puffer"));
				}

				with(obj_create(_sx, _sy, choose(WaterPlant, WaterPlant, OasisBarrel))){
					nexthurt = current_frame + 30;

					 // Space Out:
					var _tries = 50;
					while(distance_to_object(prop) < 2 && _tries-- > 0){
						x = _x + orandom(24);
						y = _y + orandom(16);
					}
				}
			}

			 // Effects:
			repeat(20) instance_create(_x + orandom(24), _y + orandom(24), Bubble);
			sound_play_pitch(sndOasisPortal, 2 + orandom(0.2));
			break;

        case "trench": // Boom
            var _num = 3,
                _ang = random(360);

            for(var i = 0; i < _num; i++){
                var l = random_range(8, 24),
                    d = _ang + (i * (360 / _num));

                with(obj_create(_x + lengthdir_x(l, d), _y + lengthdir_y(l, d), "BubbleBomb")){
                    image_index = (image_number - 1) - (i + random(1));
                    team = 0;
                }
            }
            break;
    }


#define BoneArrow_create(_x, _y)
	var _shotgunShoulders	= skill_get(mut_shotgun_shoulders),
		_boltMarrow 		= skill_get(mut_bolt_marrow);
		
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.BoneArrow;
		
		 // Vars:
		mask_index = mskBolt;
		friction = 0.6;
		damage = 14;
		force = 8;
		typ = 2;
		damage_falloff = current_frame + 2;
		wallbounce = 4 * _shotgunShoulders;
		alarm1 = (_boltMarrow > 0 ? 5 : 0);
		
		return id;	
	}
	
#define BoneArrow_step
	 // Particles:
	if(chance_ct(1, 7)) scrBoneDust(x, y);

	 // Destroy:
	if(speed <= 3){
		with(instance_create(x, y, Dust)) motion_set(other.direction, other.speed);
		instance_destroy();
	}
	
#define BoneArrow_end_step
	 // Trail:
	var l = point_distance(x + hspeed, y + vspeed, xprevious, yprevious) / 2,
		d = point_direction(x + hspeed, y + vspeed, xprevious, yprevious);
		
	with(instance_create(x, y, BoltTrail)){
		image_xscale = l;
		image_angle = d;
	}
	
#define BoneArrow_alrm1
	alarm1 = 5;

	 // Seeking:
	var _seekDist = 42 * skill_get(mut_bolt_marrow);;
	with(nearest_instance(x, y, instances_matching_ne([Player, enemy], "team", team))) if(point_distance(x, y, other.x, other.y) <= _seekDist){
		other.x = x;
		other.y = y;
	}
	
	 // Live to seek another frame:
	else alarm1 = 1;
	
#define BoneArrow_wall
	 // Effects:
	instance_create(x + hspeed, y + vspeed, Dust);
	
	 // Bounce:
	speed *= 0.8;
	if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
	if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;
	image_angle = direction;
	
	 // Shotgun Shoulders:
	var _skill = skill_get(mut_shotgun_shoulders);
	speed = min(speed + wallbounce, 18);
	wallbounce *= 0.9;
	
	 // Sounds:
	if(speed > 4) sound_play_hit(sndShotgunHitWall, 0.4);
	
#define BoneArrow_hit
	if(projectile_canhit_melee(other)){
		var _damage = damage + ((damage_falloff > current_frame) * 2);
		projectile_hit(other, _damage, force, direction);
	}


#define BoneBigPickup_create(_x, _y)
	with(obj_create(_x, _y, "BonePickup")){
		 // Visual:
		sprite_index = spr.BonePickupBig[irandom(array_length(spr.BonePickupBig) - 1)];
		
		 // Vars:
		mask_index = mskBigRad;
		num = 10;

		return id;
	}


#define BonePickup_create(_x, _y)
	with(obj_create(_x, _y, "CustomPickup")){ 
		 // Visual:
		sprite_index = spr.BonePickup[irandom(array_length(spr.BonePickup) - 1)];
		image_index = random(image_number - 1);
		image_angle = random(360);
        spr_open = -1;
        spr_fade = -1;

		 // Sound:
		snd_open = sndRadPickup;
		snd_fade = -1;

		 // Vars:
		mask_index = mskRad;
		time = 150 + random(30);
        pull_dis = 80 + (60 * skill_get(mut_plutonium_hunger));
        pull_spd = 12;
		num = 1;

		 // Events:
		on_pull = script_ref_create(BonePickup_pull);
		on_open = script_ref_create(BonePickup_open);
		on_fade = script_ref_create(BonePickup_fade);

		return id;
	}

#define BonePickup_pull
	if(speed <= 0 && (wep_get(other.wep) == "scythe" || wep_get(other.bwep) == "scythe")){
		return true;
	}
	return false;

#define BonePickup_open
	 // Determine Handouts:
	var _inst = other;
	if(instance_is(other, Player)){
		if(wep_get(other.wep) != "scythe" && wep_get(other.bwep) != "scythe"){
			return true; // Can't be picked up
		}
	}
	else _inst = Player;

	 // Give Ammo:
	var _num = num;
	with(_inst){
		with(["wep", "bwep"]){
			var w = variable_instance_get(other, self);
			if(wep_get(w) == "scythe" && "ammo" in w){
				if(w.ammo < w.amax){
					w.ammo = min(w.ammo + _num, w.amax);
					break;
				}
			}
		}
	}

	instance_create(x, y, Dust);

#define BonePickup_fade
	instance_create(x, y, Dust);
	
#define scrBoneDust(_x, _y)
	var c = [
		make_color_rgb(208, 197, 180),
		make_color_rgb(157, 133, 098),
		make_color_rgb(111, 082, 043)
	];
	
	 // Create the guy aready:
	with(instance_create(_x, _y, Sweat)){
		image_blend = c[irandom(array_length(c) - 1)];
		return id;
	}


#define BoneSlash_create(_x, _y)
	with(instance_create(_x, _y, CustomSlash)){
		 // Visual:
		sprite_index = spr.BoneSlashLight;
		image_speed = 0.4;

		 // Vars:
		mask_index = msk.BoneSlashLight;
		damage = 24;
		force = 8;
		heavy = false;
		wall = false;
		rotspd = 0;

		 // Events:
		on_end_step = BoneSlash_setup;
		
		return id;
	}
	
#define BoneSlash_setup
	on_end_step = [];
	
	 // Become Heavy Slash:
	if(heavy){
		 // Visual:
		sprite_index = spr.BoneSlashHeavy;
		
		 // Vars:
		mask_index = msk.BoneSlashHeavy;
		damage = 32;
		force = 12;
	}
	
	repeat(3){
		var c = sign(image_yscale),
			l = (heavy ? 24 : 16) + orandom(2),
			d = direction - (random_range(30, 120) * c);
		with(scrBoneDust(x + lengthdir_x(l, d), y + lengthdir_y(l, d))) motion_set(d - (random_range(90, 120) * c), 1 + random(2));
	}
	
#define BoneSlash_step
	 // Brotate:
	image_angle += (rotspd * current_time_scale);
	
#define BoneSlash_hit
	if(projectile_canhit_melee(other) && other.my_health > 0){
		projectile_hit(other, damage, force, direction);
	}
	
#define BoneSlash_wall
	if(!wall){
		wall = true;
		friction = 0.4;
	}

#define BubbleBomb_create(_x, _y)
    with(instance_create(_x, _y, CustomProjectile)){
         // Visual:
        sprite_index = spr.BubbleBomb;
        image_speed = 0.5;
        depth = -3;

         // Vars:
        mask_index = mskSuperFlakBullet;
        z = 0;
        zspeed = -0.5;
        zfric = -0.02;
        friction = 0.4;
        damage = 0;
        force = 2;
        typ = 1;
        big = 0;
        target = noone;
        setup = false;

        return id;
    }

#define BubbleBomb_step
     // Float Up:
    z_engine();
    image_angle += (sin(current_frame / 8) * 10) * current_time_scale;
    depth = max(min(depth, -z), TopCont.depth + 1);

    if(z < 24){
    	 // Collision:
	    if(place_meeting(x, y, Player)){
	    	with(instances_meeting(x, y, Player)){
	    		with(other){
	            	motion_add(point_direction(other.x, other.y, x, y), 1.5);
	    		}
	        }
	    }
	    if(place_meeting(x, y, projectile)){
	    	 // Baseball:
	        with(instances_meeting(x, y, [Slash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, CustomSlash])){
	        	if(place_meeting(x, y, other)){
	        		with(other) if(speed < 8){
	        			direction = other.direction;
	        			speed = 10;
	
	        			sound_play_pitchvol(sndBouncerBounce, (big ? 0.5 : 0.8) + random(0.1), 3);
	        		}
	        	}
	        }
	
	         // Bubble Collision:
		    if(place_meeting(x, y, object_index)){
		        with(instances_meeting(x, y, instances_matching_ge(instances_matching(object_index, "name", name), "big", big))){
		            if(place_meeting(x, y, other)){
		                with(other) motion_add(point_direction(other.x, other.y, x, y) + orandom(4), 0.5);
		            }
		        }
		    }
	    }

	     // Bubble Excrete:
	    if(big && image_index >= 6 && chance_ct(1, 5 + max(z, 0))){
    		with(obj_create(x + orandom(8), y - 8 - z + orandom(8), "BubbleBomb")){
    			team = other.team;
    			creator = other.creator;
    			hitid = other.hitid;
    			image_speed *= random_range(0.8, 1);
    		}
	    }
    }

     // Charge FX:
    image_blend = c_white;
    if(chance_ct(1, 8 + (image_number - image_index))){
        image_blend = c_black;
        var o = image_index / 3;
        instance_create(x + orandom(o), y + orandom(o), PortalL);
    }
    if(chance_ct(1, 12) && speed <= 0){
        with(instance_create(x, y - z, BulletHit)){
        	sprite_index = spr.BubbleCharge;
        }
    }
    
     // Effects:
    /*if(chance_ct(2, (3 + speed))){
    	var l = random_range(24, 32),
    		d = random(360),
    		_bubbles = instances_matching_ne(instances_matching(CustomProjectile, "name", name), "id", id),
       		_canSpawn = true;
    		
    	with(_bubbles) if(_canSpawn && point_distance(x, y, other.x + lengthdir_x(l, d), other.y + lengthdir_y(l, d)) <= l){
    		_canSpawn = false;
    	}
    		
    	if(_canSpawn){
	    	with(scrFX([x + lengthdir_x(l, d), 2], [(y - z) + lengthdir_y(l, d), 2], [d + 90, random(1)], BulletHit)){
	    		sprite_index = sprBubble;
	    		image_blend = c_black;
	    		depth = -3;
	    	}
    	}
    }*/

#define BubbleBomb_end_step
	 // Setup:
	if(!setup){
		setup = true;
		
		 // Become Big:
		if(big){
			sprite_index = spr.BubbleBombBig;
			mask_index = mskExploder;
			target = [];
		}
		
		 // Become Enemy Bubble:
		else if(team == 1){
			sprite_index = spr.BubbleBombEnemy;
		}
	}

     // Hold Projectile:
    var _drag = 4 + (4 * array_length(target)),
    	n = 0;

    with(target){
    	if(instance_exists(self)){
	        //speed += friction * current_time_scale;

	    	 // Push Bubble:
    		with(other){
	    		motion_add_ct(other.direction, other.speed / _drag);
    			if(speed > 2) speed -= 2 * current_time_scale;
    		}

			 // Float in Bubble:
			if(!other.big){
				x = other.x;
				y = other.y - other.z;
			}
			else{
		        var	l = 2 + ((n * 123) % 8),
		        	d = (current_frame / (10 + speed)) + direction,
		        	s = (instance_is(self, hitme) ? max(0.3 - (n * 0.05), 0.1) : 0.5);
	
		        x += ((other.x + (l * cos(d))		   ) - x) * s;
		        y += ((other.y + (l * sin(d)) - other.z) - y) * s;
			}

			n++;
    	}
    	else with(other){
    		target = array_delete_value(target, other);
    	}
    }

     // Grab Projectile:
	if(place_meeting(x, y, projectile) || place_meeting(x, y, enemy)){
		 // Poppable:
		var _meeting = instances_meeting(x, y - z, instances_matching_ne([Flame, Bolt, Splinter, HeavyBolt, UltraBolt], "team", team));
		if(_meeting){
			with(_meeting){
				if(place_meeting(x, y + other.z, other)){
					with(other) instance_destroy();
					exit;
				}
			}
		}

		 // Grabbing:
    	if(z < 24){
	    	if(is_array(target) || !instance_exists(target)){
		    	var	_maxSize = (big ? 3 : 0),
		    		_grab = array_combine(
		    			instances_matching_ne(instances_matching_ne(projectile, "typ", 0), "name", name),
		    			array_combine(
		    				instances_matching_le(enemy, "size", _maxSize),
		    				instances_matching(DogGuardian, "size", _maxSize + 1),
	    				)
		    		);
	
		        with(instances_meeting(x, y, instances_matching_ne(instances_matching(_grab, "bubble_bombed", null, false), "team", team))){
		            if(place_meeting(x, y, other)){
	                    bubble_bombed = true;
	
	                    if(is_array(other.target)) array_push(other.target, id);
	                    else other.target = id;
	
	                    with(other){
	                    	if(!big){
		                        x = other.x;
		                        y = other.y + z;
	                    	}
	
	                        var f = 1;
	                        if("force" in other) f = other.force;
	                        motion_add(other.direction, min(other.speed / sqrt(_drag + 2), f));
	
	                         // Effects:
	                        instance_create(x, y, Dust);
	                        repeat(4) instance_create(x, y, Bubble);
	                        sound_play(sndOasisHurt);
	                    }
	
		                break;
		            }
		        }
	    	}
    	}
    }

#define BubbleBomb_draw
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    //draw_sprite_ext(asset_get_index(`sprPortalL${(x mod 5) + 1}`), image_index, x, y - z, image_xscale, image_yscale, image_angle / 3, image_blend, image_alpha);

#define BubbleBomb_hit
    if(other.team != 0 && z < 24){
         // Knockback:
        if(chance(1, 2) && ("bubble_bombed" not in other || other.bubble_bombed == false)){
            speed *= 0.9;
            with(other) motion_add(other.direction, other.force);
        }

         // Speed Up:
        if(!big && team == 2){
        	image_index += image_speed * 2;
        }
    }

#define BubbleBomb_wall
    if(speed > 0){
        sound_play(sndBouncerBounce);
        move_bounce_solid(false);
        speed *= 0.5;
    }

#define BubbleBomb_anim
     // Explode:
    var _dis = 0,
    	_dir = direction,
    	_num = 1;

	if(big){
		_dis = 16;
		_num = 3;
	}

	for(var a = _dir; a < _dir + 360; a += (360 / _num)){
	    with(obj_create(x + lengthdir_x(_dis, a), y - z + lengthdir_y(_dis, a), "BubbleExplosion")){
	        team = other.team;
	        var c = other.creator;
	        if(instance_exists(c)){
	            if(c.object_index == Player) team = 2;
	            else if(team == 2) team = -1; // Popo nade logic
	        }
	        hitid = other.hitid;
	    }	
	}

	 // Big Bombage:
    if(big){
    	/*repeat(8){
    		with(obj_create(x + orandom(2), y - z + orandom(2), "BubbleBomb")){
    			team = other.team;
    			creator = other.creator;
    			hitid = other.hitid;
    			image_speed += random(0.1);
    		}
    	}*/

		 // Effects:
    	sleep(15);
    	view_shake_at(x, y, 60);
    	sound_play_pitch(sndOasisExplosion, 0.8 + orandom(0.05));
    }

    instance_destroy();

#define BubbleBomb_destroy
	with(target) if(instance_exists(self)){
		bubble_bombed = false;
	}

     // Pop:
    sound_play_pitchvol(sndLilHunterBouncer, 2 + random(0.5), 0.5);
    with(instance_create(x, y - z, BulletHit)){
        sprite_index = sprPlayerBubblePop;
        image_angle = other.image_angle;
        image_xscale = 0.5 + (0.01 * other.image_index);
        image_yscale = image_xscale;
    }


#define BubbleExplosion_create(_x, _y, _small)
    with(instance_create(_x, _y, (_small ? SmallExplosion : PopoExplosion))){
        sprite_index = spr.BubbleExplode;
        mask_index = mskExplosion;
        hitid = [sprite_index, "BUBBLE EXPLO"];
        damage = 3;
        force = 1;
        alarm0 = -1; // No scorchmark

         // Small:
        if(_small){
            image_xscale *= 0.5; // Bad!
            image_yscale *= 0.5; // Lazy!

             // Sound:
            sound_play_pitch(sndOasisExplosionSmall, 1 + random(2));
        }

         // Normal:
        else{
             // Crown of Explosions:
            if(GameCont.crown == crwn_death){
                repeat(choose(2, 3)){
                    with(obj_create(x, y, "BubbleExplosionSmall")){
                        team = other.team;
                    }
                }
            }

             // Sound:
            sound_play_pitch(sndExplosionS, 2);
            sound_play_pitch(sndOasisExplosion, 1 + random(1));
        }

        repeat(10) instance_create(_x, _y, Bubble);

        return id;
    }


#define CustomChest_create(_x, _y)
    with(instance_create(_x, _y, chestprop)){
         // Visual:
        sprite_index = sprAmmoChest;
        spr_open = sprAmmoChestOpen;

         // Sound:
        snd_open = sndAmmoChest;

		 // Events:
        on_step = ["", "", ""];
        on_open = ["", "", ""];

        return id;
    }

#define CustomChest_step
     // Call Chest Step Event:
    var e = on_step;
    if(mod_script_exists(e[0], e[1], e[2])){
        mod_script_call(e[0], e[1], e[2]);
    }

     // Open Chest:
    var c = [Player, PortalShock];
    for(var i = 0; i < array_length(c); i++) if(place_meeting(x, y, c[i])){
        with(instance_nearest(x, y, c[i])) with(other){
             // Hatred:
            if(crown_current == crwn_hatred){
            	repeat(16) with(instance_create(x, y, Rad)){
            		motion_add(random(360), random_range(2, 6));
            	}
	            if(instance_is(other, Player)){
	            	projectile_hit_raw(other, 1, true);
	            }
            }

             // Call Chest Open Event:
            var e = on_open;
            if(mod_script_exists(e[0], e[1], e[2])){
                mod_script_call(e[0], e[1], e[2]);
            }

             // Effects:
            if(sprite_exists(spr_open)){
            	with(instance_create(x, y, ChestOpen)) sprite_index = other.spr_open;
            }
            instance_create(x, y, FXChestOpen);
            sound_play(snd_open);

            instance_destroy();
            exit;
        }
    }


#define CustomPickup_create(_x, _y)
    with(instance_create(_x, _y, Pickup)){
         // Visual:
        sprite_index = sprAmmo;
        spr_open = sprSmallChestPickup;
        spr_fade = sprSmallChestFade;
        image_speed = 0.4;
        shine = 0.04;

         // Sound:
        snd_open = sndAmmoPickup;
        snd_fade = sndPickupDisappear;

         // Vars:
        mask_index = mskPickup;
        friction = 0.2;
        blink = 30;
		time = 200 + random(30);
        pull_dis = 40 + (30 * skill_get(mut_plutonium_hunger));
        pull_spd = 6;

		 // Events:
        on_step = ["", "", ""];
        on_pull = ["", "", ""];
        on_open = ["", "", ""];
        on_fade = ["", "", ""];

        return id;
    }

#define CustomPickup_pull
	return true;

#define CustomPickup_step
	array_push(global.pickup_custom, id); // For step event management

     // Call Chest Step Event:
    var e = on_step;
    if(mod_script_exists(e[0], e[1], e[2])){
        mod_script_call(e[0], e[1], e[2]);
    }

     // Animate:
    if(image_index < 1 && shine > 0){
		image_index += random(shine) - image_speed_raw;
    }

     // Find Nearest Attractable Player:
    var _nearest = noone,
    	_disMax = (instance_exists(Portal) ? 1000000 : pull_dis),
    	e = on_pull;

	if(!mod_script_exists(e[0], e[1], e[2])){
		e = script_ref_create(CustomPickup_pull);
	}

    with(Player){
    	var _dis = point_distance(x, y, other.x, other.y);
    	if(_dis < _disMax){
	    	with(other) if(mod_script_call(e[0], e[1], e[2])){
	    		_disMax = _dis;
	    		_nearest = other;
	    	}
    	}
    }

     // Attraction:
    if(_nearest != noone){
        var l = pull_spd * current_time_scale,
            d = point_direction(x, y, _nearest.x, _nearest.y),
            _x = x + lengthdir_x(l, d),
            _y = y + lengthdir_y(l, d);

        if(place_free(_x, y)) x = _x;
        if(place_free(x, _y)) y = _y;
    }

	 // Pickup Collision:
	if(mask_index == mskPickup && place_meeting(x, y, Pickup)){
		with(instances_meeting(x, y, instances_matching(Pickup, "mask_index", mskPickup))){
			if(place_meeting(x, y, other)){
				if(object_index == AmmoPickup || object_index == HPPickup || object_index == RoguePickup){
					motion_add_ct(point_direction(other.x, other.y, x, y) + orandom(10), 0.8);
				}
				with(other){
					motion_add_ct(point_direction(other.x, other.y, x, y) + orandom(10), 0.8);
				}
			}
		}
	}

     // Wall Collision:
    if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
    	if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
    	if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
    }

     // Fading:
    if(time > 0){
    	time -= ((time > 2 && crown_current == crwn_haste) ? 3 : 1) * current_time_scale;
		if(time <= 0){
			 // Blink:
			if(blink >= 0){
				time = 2;
				blink--;
				visible = !visible;
			}
	
			 // Fade:
	    	else{
	    		 // Call Fade Event:
	            var e = on_fade;
	            if(mod_script_exists(e[0], e[1], e[2])){
	                mod_script_call(e[0], e[1], e[2]);
	            }
	
	    		 // Effects:
	            if(sprite_exists(spr_fade)){
	            	with(instance_create(x, y, SmallChestFade)){
	            		sprite_index = other.spr_fade;
	            		image_xscale = other.image_xscale;
	            		image_yscale = other.image_yscale;
	            		image_angle = other.image_angle;
	            	}
	            }
	            sound_play_hit(snd_fade, 0.1);
	
				instance_destroy();
			}
		}
    }


#define ElectroPlasma_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visuals:
		sprite_index = spr.ElectroPlasma;
		depth = -4;
		
		 // Vars:
		mask_index = mskEnemyBullet1;
		damage = 3;
		typ = 2;
		wave = irandom(90);
		tethered_to = noone;
		tether_range = 80;
		
		on_end_step = ElectroPlasma_setup;
				
		return id;
	}
	
#define ElectroPlasma_setup
	on_end_step = [];

	 // Laser Brain:
	var _brain = skill_get(mut_laser_brain);
	if(instance_is(creator, Player)){
		image_xscale += 0.2 * _brain;
		image_yscale += 0.2 * _brain;
		tether_range += 40 * _brain;
	}
	
#define ElectroPlasma_anim
	image_index = 1;
	image_speed = 0.4;
	
#define ElectroPlasma_step
	wave += current_time_scale;
	
	 // Effects:
	if(chance_ct(1, 8)) 	instance_create(x + orandom(6), y + orandom(6), PlasmaTrail).sprite_index = spr.ElectroPlasmaTrail;
	if(chance_ct(1, 24))	instance_create(x + orandom(5), y + orandom(5), PortalL);
	
	 // Tether:
	if(in_distance(tethered_to, tether_range) && in_sight(tethered_to)){
		var _x1 = x + hspeed,
			_y1 = y + vspeed,
			_x2 = tethered_to.x + tethered_to.hspeed,
			_y2 = tethered_to.y + tethered_to.vspeed,
			_d1 = direction,
			_d2 = tethered_to.direction;
			
		with(lightning_connect(_x1, _y1, _x2, _y2, (point_distance(_x1, _y1, _x2, _y2) / 4) * sin(wave / 90), false)){
			sprite_index = spr.ElectroPlasmaTether;
			depth = -3;
		
			 // Effects:
			if(chance_ct(1, 16)) with(instance_create(x, y, PlasmaTrail)){
				sprite_index = spr.ElectroPlasmaTrail;
				motion_set(lerp(_d1, _d2, random(1)), 1);
			}
		}
		
	}
	
	 // Goodbye:
	if(image_xscale <= 0.8 || image_yscale <= 0.8) instance_destroy();

#define ElectroPlasma_hit
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
	scrEnemyShoot("ElectroPlasmaImpact", direction, 0);


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


#define FlakBall_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = -1;
		image_speed = 0;

		 // Vars:
		mask_index = mskFlakBullet;
		friction = 0.4;
		damage = 0;
		force = 6;
		rotation = 0;
		rotspeed = random_range(12, 16) * choose(-1, 1);
		inst = [];
		inst_vars = {};
		flag = [];

		return id;
	}

#define FlakBall_step
	image_index += (speed / 12) * current_time_scale;

	 // Create Sprite:
	if(!sprite_exists(sprite_index)){
		var	_surfw = 24,
			_surfh = 24,
			_num = 2;

		with(inst) if(instance_exists(self)){
			_surfw = max(_surfw, sprite_width  * 2);
			_surfh = max(_surfh, sprite_height * 2);

			if(object_index == other.object_index && "name" in self && name == other.name){
				if(sprite_width == 16) _num = 0;
			}
		}
		_surfw += 8;
		_surfh += 8;

		if(_num > 0){
			var _surf = surface_create(_surfw * _num, _surfh);

			 // Draw Sprite:
			surface_set_target(_surf);
			draw_clear_alpha(0, 0);
			for(var i = 0; i < _num; i++){
				with(inst) if(instance_exists(self)){
					var	_spr = sprite_index,
						_img = image_index,
						_xsc = image_xscale,
						_ysc = image_yscale,
						_ang = image_angle,
						_col = image_blend,
						_alp = abs(image_alpha),
						l = (sprite_xoffset - (sprite_width / 2)),
						_x = (_surfw / 2) + lengthdir_x(l, _ang) + (i * _surfw),
						_y = (_surfh / 2) + lengthdir_y(l, _ang),
						_pulse = 1 + min(4 / sprite_get_width(_spr), i * (sprite_get_height(_spr) / 64));

					if(object_index == other.object_index && "name" in self && name == other.name){
						_img = i;
						_pulse = 1;
					}

					else switch(_spr){
						case sprGrenade:
						case sprStickyGrenade:
						case sprBloodGrenade:
						case sprFlare:
						case sprPopoNade:
						case sprToxicGrenade:
						case sprClusterNade:
						case sprUltraGrenade:
							_spr = sprClusterGrenadeBlink;
							_img = i;
							break;

						case sprMininade:
						case sprConfettiBall:
							_spr = sprGrenadeBlink;
							_img = i;
							break;

						case sprHeavyNade:
							_spr = sprHeavyGrenadeBlink;
							_img = i;
							break;

						case sprDisc:
						case sprGoldDisc:
							if(i) _spr = sprDiscTrail;
							break;

						case sprLaser:
							_spr = sprPlasmaBall;
							_ysc /= 3;
							_xsc = _ysc;
							break;

						case sprPlasmaBall:
						case sprPlasmaBallBig:
						case sprPlasmaBallHuge:
						case sprUltraBullet:
						case sprUltraShell:
							_xsc *= 0.8;
							_ysc *= 0.8;
							break;

						case sprLightning:
							_spr = sprLightningBall;
							_img = (i * 3);
							_ang = other.image_angle;
							_xsc /= 2;
							_ysc /= 2;
							break;

						case sprTrapFire:
						case sprWeaponFire:
							_img = irandom(3);
							break;

						case sprLightningBall:
						case sprFlameBall:
						case sprBloodBall:
							_img = irandom(image_number - 1);
							break;

						case sprFireShell:
							_spr = sprFireBall;
							_img = 1;
							break;

						case sprBolt:
						case sprBoltGold:
						case sprToxicBolt:
						case sprHeavyBolt:
						case sprSplinter:
						case sprUltraBolt:
						case sprSeeker:
							_img = image_number - 1;
							break;

						case sprScorpionBullet:
							_ysc *= 2;
							break;
					}

					_xsc *= _pulse;
					_ysc *= _pulse;
	
					draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
				}
			}
			surface_reset_target();

			 // Add Sprite:
			surface_save(_surf, "sprMergeFlak.png");
			surface_destroy(_surf);
			sprite_index = sprite_add("sprMergeFlak.png", _num, _surfw / 2, _surfh / 2);
		}
	}

	 // Hold Instances:
	var _vars = inst_vars;
	with(inst){
		if(instance_exists(self) && speed > 0){
			 // Store Vars:
			var _id = string(id);
			if(_id not in _vars){
				var v = {
					mask_index	: mask_index,
					image_index	: image_index,
					speed		: speed,
					alarm		: []
				};
				for(var i = 0; i < 12; i++){
					var a = alarm_get(i);
					if(a > 0){
						array_push(v.alarm, [i, a + 1]);
					}
				}
				lq_set(_vars, _id, v);
			}

			 // Hold Vars:
			var v = lq_get(_vars, _id);
			image_index = v.image_index;
			speed = v.speed;
			var a = v.alarm;
			for(var i = 0; i < array_length(a); i++){
				alarm_set(a[i, 0], a[i, 1]);
			}

			 // Freeze Movement:
			x = other.x - hspeed_raw;
			y = other.y - vspeed_raw;

			 // Object-Specific:
			switch(object_index){
				case Laser:
					xstart = x;
					ystart = y;
					image_yscale += 0.3 * current_time_scale;
					break;

				case Bolt:
				case ToxicBolt:
				case Splinter:
				case HeavyBolt:
				case UltraBolt:
					x += lengthdir_x(sprite_height / 4, image_angle + other.rotation);
					y += lengthdir_y(sprite_height / 4, image_angle + other.rotation);
					break;

				case CustomProjectile:
					if("name" in self && name == other.name){
						rotation = other.rotation;
						image_index = other.image_index;
					}
					break;
			}

			 // Disable:
			if(mask_index != mskNone){
				v.mask_index = mask_index;
				mask_index = mskNone;
			}
			image_alpha = -abs(image_alpha);
		}
		else other.speed = 0;
	}

	 // Spin:
	rotation += rotspeed * current_time_scale;
	rotspeed -= clamp(rotspeed, -friction, friction) * current_time_scale;

	 // Effects:
	if(chance_ct(1, 3)){
		instance_create(x, y, Smoke);
	}

	 // Explode:
	if(speed <= 0 || place_meeting(x + hspeed, y + vspeed, Wall)) instance_destroy();

#define FlakBall_draw
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, rotation, image_blend, image_alpha);

#define FlakBall_hit
	with(other){
		var _hit = 4;
		with(other.inst) if(instance_exists(self)){
			if(other.my_health > 0 && (_hit > 0 || (object_index == CustomProjectile && "name" in self && name == "FlakBall"))){
				event_perform(ev_collision, hitme);
				if(instance_exists(other)) _hit = 0;
				else _hit--;
			}
		}
	}

	 // Slow:
	x -= hspeed_raw / 2;
	y -= vspeed_raw / 2;

#define FlakBall_destroy
	 // Activate Projectiles:
	var _vars = inst_vars;
	with(inst) if(instance_exists(self)){
		image_alpha = abs(image_alpha);
		direction += other.rotation;
		image_angle = direction;
		x = other.x;
		y = other.y;

		var _id = string(id);
		if(_id in _vars){
			var v = lq_get(_vars, _id);
			mask_index = v.mask_index;
		}

		 // Activate Lasers, Lightning, etc.
		mod_script_call("weapon", "merge", "proj_post", other.flag);

		 // Object Specific:
		switch(object_index){
			case Laser:
				sound_play_pitch((skill_get(mut_laser_brain) ? sndLaserUpg : sndLaser), 1 + orandom(0.2));
				break;

			case CustomProjectile:
				if("name" in self && name == other.name){
					rotspeed += random_range(12, 16) * choose(-1, 1);
				}
				break;
		}
	}

	 // Effects:
	sleep(20);
	view_shake_at(x, y, (array_length(inst) / 2));
	sound_play(sndFlakExplode);
	repeat(6) with(instance_create(x, y, Smoke)){
		motion_add(random(360), random(3));
	}
	with(instance_create(x, y, BulletHit)){
		sprite_index = sprFlakHit;
	}


#define FlySpin_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.FlySpin;
		image_index = irandom(image_number - 1);
		image_speed = 0.4 + random(0.1);
		image_xscale = choose(-1, 1);
		depth = -8;

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


#define Harpoon_create(_x, _y)
    with(instance_create(_x, _y, CustomProjectile)){
         // Visual:
        sprite_index = spr.Harpoon;
        image_speed = 0;

         // Vars:
        mask_index = mskBolt;
    	creator = noone;
    	target = noone;
    	damage = 8;
    	force = 8;
    	typ = 1;
    	rope = [];
    	corpses = [];
    	pickup = false;

    	return id;
    }

#define Harpoon_step
	 // Skewered Corpses:
	with(corpses){
		if(instance_exists(self) && speed > 0){
			if(other.speed > 0){
				x += (other.x - x) * 0.3 * current_time_scale;
				y += (other.y - y) * 0.3 * current_time_scale;
				hspeed = other.hspeed;
				vspeed = other.vspeed;
				xprevious = x + hspeed;
				yprevious = y + vspeed;
				depth = other.depth - 1;
				image_speed = 0.4;
				image_index = 1;
			}
			else{
				depth = 1;
				var _max = 5;
				if(speed > _max){
					speed = _max - random(1);
					direction += orandom(80);
				}
			}
		}
		else{
			if(instance_exists(self)) depth = 1;
			other.corpses = array_delete_value(other.corpses, self);
		}
	}

	 // Movin:
	if(speed > 0){
         // Rope Length:
        with(rope) if(!harpoon_stuck){
            if(instance_exists(link1) && instance_exists(link2)){
                length = point_distance(link1.x, link1.y, link2.x, link2.y);
            }
        }

         // Bolt Marrow:
        if(skill_get(mut_bolt_marrow) > 0){
            var n = nearest_instance(x, y, instances_matching_ne(instances_matching_ne(hitme, "team", team, 0), "mask_index", mskNone, sprVoid));
            if(distance_to_object(n) < (16 * skill_get(mut_bolt_marrow))){
            	if(!place_meeting(x, y, n)){
            		if(in_sight(n)){
	                    direction = point_direction(x, y, n.x, n.y);
	                    image_angle = direction;
            		}
            	}
            }
        }

		 // Skewer Corpses:
        if(place_meeting(x, y, Corpse)){
            with(instances_meeting(x, y, instances_matching_le(instances_matching_ne(instances_matching_gt(Corpse, "speed", 1), "mask_index", -1), "size", 3))){
            	if(place_meeting(x, y, other)){
            		var c = id;
            		with(other){
	            		if(array_find_index(corpses, c) < 0){
							var _canTake = true;
	            			with(instances_matching(object_index, "name", name)){
	            				if(array_find_index(corpses, c) >= 0){
	            					_canTake = false;
	            					break;
	            				}
	            			}

							if(_canTake){
								 // Skewer:
		            			array_push(corpses, c);
		            			if(hspeed != 0){
		            				c.image_xscale = -sign(hspeed);
		            			}
		            			speed = max(speed - (3 * (1 + c.size)), 12);

		            			 // Effects:
		            			view_shake_at(x, y, 6);
		            			with(instance_create(c.x, c.y, ThrowHit)){
		            				motion_add(other.direction + orandom(30), 3);
		            				image_speed = random_range(0.8, 1);
		            				image_xscale = min(0.5 * (c.size + 1), 1);
		            				image_yscale = image_xscale;
		            			}
		            			sound_play_pitchvol(sndChickenThrow,   0.4 + random(0.2), 3);
		            			sound_play_pitchvol(sndGrenadeShotgun, 0.6 + random(0.2), 0.3 + (0.2 * c.size));
							}
	            		}
            		}
            	}
            }
        }

         // Stick in Chests:
        if(place_meeting(x, y, chestprop)){
        	target = instance_nearest(x, y, chestprop);
        	instance_destroy();
        	exit;
        }
	}
	else if(pickup){
		instance_destroy();
		exit;
	}

	 // Can we have a typ variable for portalshocks or something:
	if(place_meeting(x + hspeed_raw, y + vspeed_raw, PortalShock)){
		pickup = true;
		instance_destroy();
	}

#define Harpoon_end_step
     // Trail:
    if(speed > 0){
	    var _x1 = x,
	        _y1 = y,
	        _x2 = xprevious,
	        _y2 = yprevious;
	
	    with(instance_create(x, y, BoltTrail)){
	        image_yscale = 0.6;
	        image_xscale = point_distance(_x1, _y1, _x2, _y2);
	        image_angle = point_direction(_x1, _y1, _x2, _y2);
	        creator = other.creator;
	    }
    }

#define Harpoon_hit
    if(speed > 0 && projectile_canhit(other)){
        projectile_hit_push(other, damage, force);

         // Stick in enemies that don't die:
        if(instance_exists(other) && other.my_health > 0){
        	target = other;
        	instance_destroy();
        }
    }

#define Harpoon_wall
    if(speed > 0){
        move_contact_solid(direction, 16);
        instance_create(x, y, Dust);
        sound_play(sndBoltHitWall);
        speed = 0;

         // Deteriorate Rope if Both Harpoons Stuck:
        with(rope){
        	if(harpoon_stuck && array_length(instances_matching_ne([link1, link2], "object_index", CustomProjectile)) <= 0){
        		broken = -1;
        	}
        	harpoon_stuck = true;
        }
    }

#define Harpoon_destroy
	 // Pickup:
	if(pickup){
		with(obj_create(x, y, "HarpoonPickup")){
			motion_add(other.direction, other.speed / 2);
			image_angle = other.image_angle;
			image_yscale = other.image_yscale;
			target = other.target;
		}
	}

	 // Stick in Object:
	else if(instance_exists(target)){
		var _harpoon = id;
	    with(obj_create(x, y, "HarpoonStick")){
	    	image_angle = other.image_angle;
	    	image_yscale = other.image_yscale;
		    target = other.target;
		    rope = other.rope;

			 // Pull Speed:
		    if("size" in target){
		    	pull_speed /= max(target.size, 0.5);
		        if(
		        	(instance_is(target, prop) || target.team == 0)	&&
		        	!instance_is(target, RadChest)					&&
		        	!instance_is(target, Car)						&&
		        	!instance_is(target, CarVenus)					&&
		        	!instance_is(target, CarVenusFixed)
		        ){
		            pull_speed = 0;
		        }
		    }

			 // Rope Stuff:
		    with(rope){
				if(link1 == _harpoon) link1 = other;
				if(link2 == _harpoon) link2 = other;
		        harpoon_stuck = true;

		         // Attached to Same Thing:
		        if(instance_is(link1, BoltStick) && instance_is(link2, BoltStick)){
		        	if(link1.target == link2.target){
		        		with([link1, link2]) pull_speed = 0;
		        	}
		        }

		         // Deteriorate Rope if Doing Nothing:
		        if(array_length(instances_matching_gt([link1, link2], "pull_speed", 0)) <= 0){
		            broken = -1;
		            length = point_distance(link1.x, link1.y, link2.x, link2.y);
		        }
		    }
	    }
	}

#define Harpoon_cleanup
	with(corpses) if(instance_exists(self)){
		depth = 1;
	}

#define draw_rope(_rope)
    instance_destroy();
    with(_rope) if(instance_exists(link1) && instance_exists(link2)){
        var _x1 = link1.x,
            _y1 = link1.y,
            _x2 = link2.x,
            _y2 = link2.y,
            _wid = clamp(length / point_distance(_x1, _y1, _x2, _y2), 0.1, 2),
            _col = merge_color(c_white, c_red, (0.25 + clamp(0.5 - (break_timer / 15), 0, 0.5)) * clamp(break_force / 100, 0, 1));

		if(break_timer > 0){
			_wid += (max(1, _wid) - _wid) * min(break_timer / 15, 1);
		}

        draw_set_color(_col);
        draw_line_width(_x1, _y1, _x2, _y2, _wid);
    }

#define scrHarpoonRope(_link1, _link2)
    var r = {
        link1 : _link1,
        link2 : _link2,
        length : 0,
        harpoon_stuck : false,
        break_force : 0,
        break_timer : 45 + random(15),
        creator : noone,
        broken : false
    }

    array_push(global.poonRope, r);

    with([_link1, _link2]){
    	if("rope" in self){
			array_push(rope, r);
			if(!instance_exists(creator) && "creator" in self){
				r.creator = creator;
			}
    	}
    }

    return r;

#define scrHarpoonUnrope(_rope)
    with(_rope){
        broken = true;
		global.poonRope = array_delete_value(global.poonRope, self);

    	 // Turn Harpoons Into Pickups:
    	with([link1, link2]) if("name" in self){
    		if(object_index == CustomProjectile && name == "Harpoon"){
    			pickup = true;
    		}
    		else if(object_index == BoltStick && name == "HarpoonStick"){
	    		with(obj_create(x, y, "HarpoonPickup")){
	    			image_angle = other.image_angle;
	    			image_yscale = other.image_yscale;
	    			target = other.target;
	    		}
	    		instance_destroy();
    		}
    	}
    }


#define HarpoonPickup_create(_x, _y)
	with(obj_create(_x, _y, "CustomPickup")){
		 // Visual:
        sprite_index = spr.Harpoon;
        image_index = 1;
        spr_open = spr.HarpoonOpen;
        spr_fade = spr.HarpoonFade;

		 // Vars:
		mask_index = mskBigRad;
		friction = 0.4;
		pull_spd = 8;
		target = noone;
		num = 1;

		 // Events:
		on_step = script_ref_create(HarpoonPickup_step);
		on_pull = script_ref_create(HarpoonPickup_pull);
		on_open = script_ref_create(HarpoonPickup_open);

		return id;
	}

#define HarpoonPickup_step
	 // Stuck in Target:
    if(instance_exists(target)){
        var _odis = 16,
            _odir = image_angle;

        x = target.x + target.hspeed_raw - lengthdir_x(_odis, _odir);
        y = target.y + target.vspeed_raw - lengthdir_y(_odis, _odir);
        if("z" in target){
        	if(target.object_index == RavenFly || target.object_index == LilHunterFly){
        		y += target.z;
        	}
        	else y -= target.z;
        }
        xprevious = x;
        yprevious = y;

        if(!target.visible) target = noone;
    }

#define HarpoonPickup_pull
	if(instance_exists(target)){ // Stop Sticking
		if(place_meeting(x, y, Wall)){
			x = target.x;
			y = target.y;
			xprevious = x;
			yprevious = y;
		}
		target = noone;
	}
	return (speed <= 0);

#define HarpoonPickup_open
	 // +1 Bolt Ammo:
	var _inst = noone,
		_type = 3,
		_num = num;

	if(instance_is(other, Player)) _inst = other;
	else _inst = Player;

	with(_inst){
        ammo[_type] = min(ammo[_type] + _num, typ_amax[_type]);
        with(instance_create(x, y, PopupText)){
        	text = `+${_num} ${other.typ_name[_type]}`;
        	target = other.index;
        }
	}


#define HarpoonStick_create(_x, _y)
	with(instance_create(_x, _y, BoltStick)){
		 // Visual:
		sprite_index = spr.Harpoon;
		image_index = 0;

		 // Vars:
		pull_speed = 2;
		rope = [];

		return id;
	}


#define HyperBubble_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Vars:
		mask_index = mskNone;
		hits = 3;
		damage = 12;
		force = 24;
		
		return id;
	}
	
#define HyperBubble_end_step
	mask_index = mskBullet1;
	var _dist = 100,
		_proj = [];
		
	 // Muzzle Explosion:
	array_push(_proj, obj_create(x, y, "BubbleExplosionSmall"));
		
	while(!place_meeting(x, y, Wall) && _dist > 0 && hits > 0){
		_dist--;
		x += lengthdir_x(8, direction);
		y += lengthdir_y(8, direction);
		
		 // Effects:
		if(chance(1, 3)) scrFX([x, 4], [y, 4], [direction + orandom(4), 6 + random(4)], Bubble).friction = 0.2;
		if(chance(2, 3)) scrFX([x, 2], [y, 2], [direction + orandom(4), 2 + random(2)], Smoke);
		
		 // Explosion:
		var e = instances_meeting(x, y, instances_matching_gt(instances_matching_ne([Player, hitme], "team", team), "my_health", 0));
		if(array_length(e) > 0 && hits > 0){
			hits--;
			array_push(_proj, obj_create(x, y, "BubbleExplosionSmall"));
			
			 // Deal Impact Damage:
			for(var i = 0; i < array_length(e); i++) projectile_hit(e[i], damage, force, direction);
		}
	}
	
	 // End Explosion:
	array_push(_proj, obj_create(x, y, "BubbleExplosion"));
	if(hits > 0) repeat(hits) array_push(_proj, obj_create(x, y, "BubbleExplosionSmall"));
	
	 // Your Properties, Madam:
	with(_proj){
		creator = other.creator;
		team	= other.team;
	}
	
	 // Goodbye:
	instance_destroy();
	
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
        
        return id;
    }

#define LightningDisc_step
    rotation += rotspeed;

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
                y = creator.y;
                if(roids) y -= 4;
            }

             // Lightning Disc Weaponry:
            if(instance_is(creator, Player)){
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

                 // Chargin'
                with(creator){
                	var k = 5 * (other.image_xscale / other.charge);
                	if(other.roids) bwkick = k;
                	else wkick = k;
                }
            }
        }

         // Stay Still:
        xprevious = x;
        yprevious = y;
        x -= hspeed * current_time_scale;
        y -= vspeed * current_time_scale;

         // Effects:
        sound_play_pitch(sndLightningHit, (image_xscale / charge));
        if(!is_enemy) sound_play_pitch(sndPlasmaReload, (image_xscale / charge) * 3);
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

             // Player Shooting:
            if(instance_is(creator, Player)) with(creator){
            	var k = wkick;
                weapon_post(-4, 16, 8);
            	if(other.roids){
            		bwkick = wkick;
            		wkick = k;
            	}

                with(other) direction += orandom(6) * other.accuracy;
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
                with(nearest_instance(x, y, instances_matching_ne(hitme, "team", team, 0))){
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
        if (super != -1 && charge <= 0 && image_xscale < super + .9){
            if (chance(1, 12 * (image_xscale - super))){
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
                    sound_play_pitchvol(sndLightningHit, random_range(0.8, 1.2) * _pitchMod, min(_vol, 0.7)*2);

                // DIsplacement:
                speed *= .98;
                y += orandom(3) * _pitchMod;
                x += orandom(3) * _pitchMod;
            }
        }
    }

     // Shrink:
    if(charge <= 0){
        var s = shrink * current_time_scale;
        image_xscale -= s;
        image_yscale -= s;

         // Super lightring split:
        if(super != -1 && image_xscale <= super){
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
            ammo = other.image_xscale + random(other.image_xscale * 2);
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
    if(super != -1)
    {
         // Effects:
        sleep(80);
        sound_play_pitchvol(sndLightningPistolUpg, 0.7,               0.4);
        sound_play_pitchvol(sndLightningPistol,    0.7,               0.6);
        sound_play_pitchvol(sndGammaGutsKill,      0.5 + random(0.2), 0.7);

         // Disc Split:
        var _ang = random(360);
        for(var a = _ang; a < _ang + 360; a += (360 / 5))
        {
            with(obj_create(x, y, "LightningDisc"))
            {
                motion_add(a, 10);
                charge = other.image_xscale / 1.2;
                if(skill_get(mut_laser_brain)){
                    charge *= 1.2;
                    stretch *= 1.2;
                    image_speed *= 0.75;
                }

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
        charge_spd = 1;

        return id;
    }


#define NestRaven_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		spr_idle = sprRavenIdle;
		spr_walk = sprRavenWalk;
		spr_hurt = sprRavenHurt;
		spr_dead = sprRavenDead;
		spr_lift = sprRavenLift;
		spr_land = sprRavenLand;
		spr_wing = sprRavenFly;
		spr_shadow = shd24;
		spr_shadow_x = 0;
		spr_shadow_y = -1;
		sprite_index = spr_idle;
		image_index = irandom(image_number - 1);
		image_speed = 0.4;
		depth = -8 - (y / 20000);

		 // Vars:
		mask_index = mskBandit;
		right = choose(-1, 1);
		targetx = x;
		targety = y;
		z = 0;
		force_spawn = false;

		 // Alarms:
		alarm0 = 1;
		alarm1 = irandom_range(90, 1500);

		return id;
	}

#define NestRaven_step
	 // Flight:
	if(sprite_index = spr_wing){
		var l = 6 * current_time_scale,
			d = point_direction(x, y, targetx, targety);

		if(point_distance(x, y, targetx, targety) > l){
			x += lengthdir_x(l, d);
			y += lengthdir_y(l, d);
		}

		 // Land:
		else{
			image_index = max(2, image_index);
			if(anim_end){
				sprite_index = spr_land;
				image_index = 0;
			}
		}
	}

	 // Lifting:
	else if(sprite_index = spr_lift){
		z += 3 * current_time_scale;

		 // Fly Away:
		if(anim_end) sprite_index = spr_wing;
	}

	 // Landing:
	else if(sprite_index = spr_land){
		z -= 3 * current_time_scale;

		 // Attempt Landing:
		if(anim_end || z <= 0){
			z = 0;

			 // Try Again:
			if(!place_meeting(x, y, Floor)){
				alarm1 = 1;
			}

			 // Landed:
			else{
				with(instance_create(x, y, Raven)){
					x = xstart;
					y = ystart;
					alarm1 = 20 + random(10);
					right = other.right;

					 // Target:
					var n = instance_nearest(x, y, Player);
					if(in_sight(n) && sign(right) == sign(n.x - x)){
						gunangle = point_direction(x, y, n.x, n.y);
					}

					 // Swappin:
					var l = 4,
						d = gunangle;

					instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), WepSwap);
					wkick = 4;

					 // Effects:
					if(point_seen(x, y, -1)) sound_play(sndRavenLand);
					repeat(6){
						with(instance_create(x + orandom(8), y + random(16), Dust)){
							motion_add(random(360), 3 + random(1));
						}
					}
				}
				instance_destroy();
			}
		}
	}

	 // Emergency Flight:
	else if(alarm1 > 1){
		if(instance_number(enemy) <= 2 || (position_meeting(x, bbox_bottom + 8, Floor) && !position_meeting(x, bbox_bottom + 8, Wall))){
			alarm1 = 1;
			force_spawn = true;
		}
	}

#define NestRaven_draw
	image_alpha = abs(image_alpha);

	var _blend = image_blend;
	if(z <= 0) _blend = merge_color(_blend, c_black, 0.2);
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale * right, image_yscale, image_angle, _blend, image_alpha);

	image_alpha = -image_alpha;

#define NestRaven_alrm0
	alarm0 = irandom_range(1, 80);

	 // Lookin:
	if(sprite_index == spr_idle){
		right = choose(-1, 1);
		if(instance_exists(Player)){
			var t = instance_nearest(x, y, Player);
			scrRight(point_direction(x, y, t.x, t.y));
		}
	}

#define NestRaven_alrm1
	alarm1 = irandom_range(1, 100);

	var t = instance_nearest(x, y, Player);
	if(force_spawn || in_distance(t, 128)){
		var _x = x,
			_y = y;

		 // Search Floors by Player:
		if(instance_exists(t) && !chance(force_spawn, 2)){
			scrRight(point_direction(x, y, t.x, t.y));
			_x = t.x;
			_y = t.y;
			if(place_meeting(_x, _y, Wall) || force_spawn){
				var _inst = instance_rectangle_bbox(t.x - 16, t.y - 16, t.x + 16, t.y + 16, Floor);
				with(_inst){
					_x = ((bbox_left + bbox_right) / 2) + orandom(4);
					_y = ((bbox_top + bbox_bottom) / 2) + orandom(4);
	
					var b = false;
					with(other){
						if(!place_meeting(_x, _y, Wall) && chance(1, array_length(_inst))){
							b = true;
						}
					}
					if(b) break;
				}
			}
		}

		 // Random Nearby Floor:
		else{
			alarm = 1;

			var r = 64;
			with(instance_random(instance_rectangle_bbox(x - r, y - r, x + r, y + r, Floor))){
				_x = (bbox_left + bbox_right) / 2;
				_y = (bbox_top + bbox_bottom) / 2;
			}
		}

		 // Take Off:
		if(!place_meeting(_x, _y, Wall)){
			sprite_index = spr_lift;
			image_index = 0;
			depth = floor(depth);
			alarm1 = -1;
			targetx = _x;
			targety = _y;

			 // Effects:
			if(force_spawn) sound_play(sndRavenScreech);
			sound_play(sndRavenLift);
			repeat(6){
				with(instance_create(x + orandom(8), y + random(16), Dust)){
					motion_add(random(360), 3 + random(1));
					depth = other.depth;
				}
			}
		}
	}


#define NetNade_create(_x, _y)
    with(instance_create(_x, _y, CustomProjectile)){
         // Visual:
        sprite_index = spr.NetNade;
        image_speed = 0.4;

         // Vars:
        mask_index = mskBigRad;
        friction = 0.8;
        creator = noone;
        lasthit = noone;
        damage = 10;
        force = 4;
        typ = 1;

         // Alarms:
        alarm0 = 60;

        return id;
    }

#define NetNade_step
	 // Tryin a trail:
	if(speed > 0){
		with(instance_create(x, y, DiscTrail)){
			image_angle = other.direction;
			image_xscale = other.image_xscale * (other.speed / 16);
			image_yscale = other.image_yscale * 0.25;
			depth = -1;
		}
	}

     // Blink:
    if(alarm0 > 0 && alarm0 < 15){
        sprite_index = spr.NetNadeBlink;
    }

#define NetNade_hit
    if(speed > 0 && projectile_canhit(other)){
        lasthit = other;
        projectile_hit_push(other, damage, force);
        if(alarm0 > 1) alarm0 = 1;
    }

#define NetNade_wall
    if(alarm0 > 1) alarm0 = 1;

#define NetNade_alrm0
    instance_destroy();

#define NetNade_destroy
     // Effects:
    repeat(8) scrFX(x, y, 1 + random(2), Dust);
    sound_play(sndUltraCrossbow);
    sound_play(sndFlakExplode);
    view_shake_at(x, y, 20);

     // Break Walls:
    while(distance_to_object(Wall) < 32){
        with(instance_nearest(x, y, Wall)){
            instance_create(x, y, FloorExplo);
            instance_destroy();
        }
    }

     // Harpoon-Splosion:
    var _num = 10,
        _ang = random(360),
        _dis = 0,
        f = noone, // First Harpoon Created
        h = noone; // Latest Harpoon Created

    for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
    	if(_dis <= 0) _dis = 8;
    	else _dis = 0;

        with(obj_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), "Harpoon")){
            motion_add(_dir, 22);
            team = other.team;
            creator = other.creator;

			 // Minor Homing on Nearest Enemy:
    		var n = nearest_instance(x + (3 * hspeed), y + (3 * vspeed), instances_matching_ne(hitme, "team", team, 0));
    		if(instance_exists(n)){
    			var o = angle_difference(point_direction(x, y, n.x, n.y), direction);
    			if(abs(o) < (360 / _num) / 2){
    				direction += o;
    			}
    		}

			 // Facing:
            image_angle = direction;
            if(image_angle > 90 && image_angle < 270) image_yscale = -1;

             // Explosion Effect:
            with(instance_create(x, y, MeleeHitWall)){
                motion_add(other.direction, 1 + random(2));
                image_angle = direction + 180;
                image_speed = 0.6;
            }

             // Link harpoons to each other:
            if(!instance_exists(f)) f = id;
            if(instance_exists(other.lasthit)){
            	scrHarpoonRope(id, other.lasthit);
            }
            else{
	            if(instance_exists(h)) scrHarpoonRope(id, h);
	            h = id;
            }
        }
    }
    if(instance_exists(h)){
    	scrHarpoonRope(f, h);
    }


#define ParrotChester_create(_x, _y)
    with(instance_create(_x, _y, CustomObject)){
         // Vars:
        creator = noone;
        small = false;
        num = 6;

        return id;
    }

#define ParrotChester_step
    if(instance_exists(creator)){
        x = creator.x;
        y = creator.y; 
    }
    else{
         // Feather Pickups:
        if(num > 0 && position_meeting(x, y, (small ? SmallChestPickup : ChestOpen))){
	        var t = instances_matching(Player, "race", "parrot");

	        if(array_length(t) > 0){
	        	if(!small || array_find_index(t, instance_nearest(x, y, Player)) >= 0 || place_meeting(x, y, Portal)){
		            with(t){
		            	for(var i = 0; i < other.num; i++){
			                with(obj_create(other.x, other.y, "ParrotFeather")){
			                    target = other;
			                    creator = other;
			                    bskin = other.bskin;
			                    stick_wait = 3;
			                }
		
			                 // Sound FX:
			                if(fork()){
			                	wait((i * (4 / other.num)) + irandom(irandom(1)));
			                	sound_play_pitchvol(sndBouncerSmg, 3 + random(0.2), 0.2 + random(0.1));
			                	exit;
			                }
		            	}
		            }
	        	}
	        }
        }

        instance_destroy();
    }


#define ParrotFeather_create(_x, _y)
    with(instance_create(_x, _y, CustomObject)){
         // Visual:
        sprite_index = sprChickenFeather;
        sprite_index = mskNone;
        depth = -8;

         // Vars:
        mask_index = mskLaser;
        creator = noone;
        target = noone;
        index = -1;
        bskin = 0;
        stick = false;
        stickx = 0;
        sticky = 0;
        stick_time_max = 60;// * (1 + ultra_get("parrot", 3));
        stick_time = stick_time_max;
        stick_list = [];
        stick_wait = 0;
        canhold = true;

         // Push:
        motion_add(random(360), 4 + random(2));
        image_angle = direction + 135;
        
         // Spriterize:
        if(fork()){
            wait 0;
            if(instance_exists(self)){
                sprite_index = spr.Parrot[bskin].Feather;
            }
            exit;
        }

        return id;
    }

#define ParrotFeather_step
    speed *= 0.9;
    if(instance_exists(target)){
         // On Target:
        if(stick){
             // Fall Off:
            if(stick_time <= 0 || !target.charm.charmed){
                target = noone;
                stick_time = 0;
                if(chance(1, 4)){
                    sound_play_pitch(sndAssassinPretend, 1.70 + orandom(0.04));
                }
            }

             // Decrement Timer When First in Queue:
            else{
                if(array_length(stick_list) <= 0){
                    var n = instances_matching(instances_matching(instances_matching(object_index, "name", name), "target", target), "stick", true);
                    with(n) stick_list = n;
                }
                if(stick_list[0] == id){
                    stick_time -= current_time_scale;
                }
            }
        }

         // Flyin Around:
        else{
             // Remove From Stick List:
            if(array_length(stick_list) > 0){
                with(stick_list) if(instance_exists(self)){
                    stick_list = array_delete_value(stick_list, other);
                }
            }

             // Move w/ Target:
            /*if(target != creator){
	            var d = (distance_to_object(target) / 50) + 1;
	            x += target.hspeed / d;
	            y += target.vspeed / d;
            }*/
        	if("move_factor" not in self) move_factor = 0;

            if(
            	instance_exists(target)			&&
            	distance_to_object(target) > 48 &&
            	abs(angle_difference(direction, point_direction(x, y, target.x, target.y))) < 30
            ){
            	move_factor += ((distance_to_object(target) / 128) - move_factor) * 0.3 * current_time_scale;
            }
            else{
            	move_factor -= move_factor * 0.8 * current_time_scale;
            }

            if(move_factor > 0){
            	x += hspeed * move_factor * current_time_scale;
            	y += vspeed * move_factor * current_time_scale;
            }
            else move_factor = 0;

            if(stick_wait == 0 && (!canhold || !instance_exists(creator) || !creator.visible || (!button_check(index, "spec") && creator.usespec <= 0))){
                canhold = false;

                 // Fly Towards Enemy:
                motion_add_ct(point_direction(x, y, target.x, target.y) + orandom(60), 1);

                if(distance_to_object(target) < 2 || (target == creator && place_meeting(x, y, Portal))){
                	//if(stick_wait == 0){
	                     // Effects:
	                    with(instance_create(x, y, Dust)) depth = other.depth - 1;
	                    sound_play_pitchvol(sndFlyFire,        2 + random(0.2),  0.25);
	                    sound_play_pitchvol(sndChickenThrow,   1 + orandom(0.3), 0.25);
	                    sound_play_pitchvol(sndMoneyPileBreak, 1 + random(3),    0.5);
	
	                     // Stick to & Charm Enemy:
	                    if(target != creator){
	                        stick = true;
	                        stickx = random(x - target.x) * (("right" in target) ? target.right : 1);
	                        sticky = random(y - target.y);
	                        image_angle = random(360);
	                        speed = 0;
	
	                         // Charm Enemy:
	                        var _wasUncharmed = ("charm" not in target || !target.charm.charmed);
	                        with(scrCharm(target, true)){
	                            index = other.index;
	                            if(_wasUncharmed || time >= 0){
	                                time += max(other.stick_time, 1);
	                            }
	                        }
	                    }
	
	                     // Player Pickup:
	                    else{
	                        with(creator){
	                        	if("feather_ammo" not in self){
	                        		feather_ammo = 0;
	                        		feather_ammo_max = 60;
	                        	}
	                        	feather_ammo = min(feather_ammo + 1, feather_ammo_max);
	                        }
	                        //with(instance_create(creator.x, creator.y, PopupText)) mytext = "+@rFEATHER@w";
	                        instance_destroy();
	                    }
                	//}
                }
            }

             // Orbit Enemy:
            else{
                var l = 16,
                    d = point_direction(target.x, target.y, x, y);

                d += 5 * sign(angle_difference(direction, d));

                var _x = target.x + lengthdir_x(l, d),
                    _y = target.y + lengthdir_y(l, d);

                motion_add_ct(point_direction(x, y, _x, _y) + orandom(60), 1);
            }

            if(instance_exists(self)){
            	if(stick_wait > 0){
            		stick_wait -= current_time_scale;
            		if(stick_wait <= 0) stick_wait = 0;
            	}

            	 // Facing:
                image_angle = direction + 135;
            }
        }
    }

    else{
        /*if(stick_time > 0 && instance_exists(creator)){
            target = creator;
        }*/
        if(!stick && instance_exists(creator)){
            target = creator;
        }

         // Fall to Ground:
        else{
            with(instance_create(x, y, Feather)){
                sprite_index = other.sprite_index;
                image_angle = other.image_angle;
                image_blend = merge_color(other.image_blend, c_black, 0.5);
                if(button_check(other.index, "spec")){
                	motion_add(other.direction, 3);
                }
            }
            instance_destroy();
        }
    }

#define ParrotFeather_end_step
    if(stick && instance_exists(target)){
        x = target.x + (stickx * image_xscale * (("right" in target) ? target.right : 1));
        y = target.y + (sticky * image_yscale);
        visible = target.visible;
        depth = target.depth - 1;

		 // Target In Water:
        if("wading" in target && target.wading != 0){
        	visible = true;
        }

		 // Z-Axis Support:
        if("z" in target){
        	if(target.object_index == RavenFly || target.object_index == LilHunterFly){
        		y += target.z;
        		depth = -7;
        	}
        	else y -= target.z;
        }
    }
    else{
        visible = true;
        depth = -8;
    }

#define ParrotFeather_cleanup
    with(stick_list) if(instance_exists(self)){
        stick_list = array_delete_value(stick_list, other);
    }


#define Pet_create(_x, _y)
    with(instance_create(_x, _y, CustomObject)){
         // Visual:
        spr_idle = spr.PetParrotIdle;
        spr_walk = spr.PetParrotWalk;
        spr_hurt = spr.PetParrotHurt;
        spr_shadow = shd16;
        spr_shadow_x = 0;
        spr_shadow_y = 4;
        mask_index = mskPlayer;
        image_speed = 0.4;
        right = choose(1, -1);
        depth = -2;

         // Sound:
        snd_hurt = sndFrogEggHurt;

         // Vars:
        pet = "Parrot";
        leader = noone;
        can_take = true;
        can_path = true;
        path = [];
        path_dir = 0;
        team = 0;
        size = 1;
        walk = 0;
        walkspd = 2;
        maxspeed = 3;
        friction = 0.4;
        direction = random(360);
        pickup_indicator = noone;
        my_portalguy = noone;
        player_push = true;
        //can_tp = true;
        //tp_distance = 240;

         // Alarms:
        alarm0 = 20 + random(10);

		 // NTTE:
		ntte_walk = false;

        return id;
    }

#define Pet_begin_step
     // Loading Screen Visual:
    if((instance_exists(GenCont) || instance_exists(LevCont)) && instance_exists(SpiralCont)){
    	if(!instance_exists(my_portalguy)){
    		my_portalguy = instance_create(SpiralCont.x, SpiralCont.y, SpiralDebris);
    		with(my_portalguy){
				sprite_index = other.spr_hurt;
				image_index = 2;
				turnspeed *= 1.5;
				dist /= 2;

				if(!in_range(turnspeed, -3, 3)){
					turnspeed /= 2;
				}
				if(in_range(rotspeed, -8, 8)){
					rotspeed += 8 * sign(rotspeed);
				}
    		}
    	}
    	with(my_portalguy){
			image_xscale = 0.85 + (0.15 * sin((-image_angle / 2) / 200));
			image_yscale = image_xscale;
			grow = 0;
    	}
    }

#define Pet_step
    if(instance_exists(Menu)){ instance_destroy(); exit; }

    var _pickup = pickup_indicator;

    if(visible){
	     // Movement:
	    enemyWalk(walkspd, maxspeed);

	     // Animate:
	    var _scrt = pet + "_anim";
	    if(mod_script_exists("mod", "petlib", _scrt)){
	         // Custom Animation Event:
	        mod_script_call("mod", "petlib", _scrt);
	    }
	    else enemySprites();

	     // Push:
		if(player_push && place_meeting(x, y, Player)){
		    with(instances_meeting(x, y, Player)){
		        if(place_meeting(x, y, other) && speed > 0) with(other){
		            motion_add_ct(point_direction(other.x, other.y, x, y), (instance_exists(leader) ? 1 : 0.6));
		        }
		    }
		}

    	 // Custom Step Event:
        var _scrt = pet + "_step";
        if(mod_script_exists("mod", "petlib", _scrt)){
            mod_script_call("mod", "petlib", _scrt);
        }
    }

     // Player Owns Pet:
    if(instance_exists(leader)){
        can_take = false;
        persistent = true;

         // Teleport To Leader:
        /*if(can_tp && point_distance(x, y, leader.x, leader.y) > tp_distance) {
             // Decide Which Floor:
            var f = instance_nearest(leader.x + orandom(16), leader.y + orandom(16), Floor);
            var fx = f.x + (f.sprite_width/2);
            var fy = f.y + (f.sprite_height/2);

             // Teleport:
            x = fx;
            y = fy;

             // Effects:
            sound_play_pitch(sndCrystalTB, 1.40 + orandom(0.10));
            repeat(2) instance_create(x + orandom(8), y + orandom(8), CaveSparkle);
        }*/

         // Pathfind to Leader:
        var _xtarget = leader.x,
            _ytarget = leader.y;

        if(can_path && collision_line(x, y, _xtarget, _ytarget, Wall, false, false)){
            var _pathEndX = x,
                _pathEndY = y;

             // Find Path's Endpoint:
            if(array_length(path) > 0){
                var p = path[array_length(path) - 1];
                _pathEndX = p[0];
                _pathEndY = p[1];
            }

             // Create path if current one doesn't reach leader:
            if(collision_line(_pathEndX, _pathEndY, _xtarget, _ytarget, Wall, false, false)){
                path = path_create(x, y, _xtarget, _ytarget);

                 // Shrink Path:
			    if(array_length(path) > 0){
			        var _newPath = [],
		        		_maxSkip = 10,
						_link = 0;

			        for(var i = 0; i < array_length(path); i++){
			            if(
			                i <= 0							||
			                i >= array_length(path) - 1		||
			                i - _link >= _maxSkip			||
			                collision_line(path[i + 1, 0], path[i + 1, 1], path[_link, 0], path[_link, 1], Wall, false, false)
			            ){
			                array_push(_newPath, path[i]);
			                _link = i;
			            }
			        }

			        path = _newPath;
			    }
            }
        }
        else path = [];

         // Enter Portal:
        if(visible){
            if(place_meeting(x, y, Portal) || instance_exists(GenCont) || instance_exists(LevCont)){
                visible = false;
                repeat(3) instance_create(x, y, Dust);
                
                 // Healo:
                if("maxhealth" in self){
                	my_health = maxhealth;
                }
            }
        }
        else if(instance_exists(GenCont)){
            x = leader.x + orandom(16);
            y = leader.y + orandom(16);
        }
    }

     // No Owner:
    else{
        persistent = false;

		 // Leader Died or Something:
		if(leader != noone){
			leader = noone;
			can_take = true;
		}

         // Looking for a home:
        if(instance_exists(Player) && can_take && instance_exists(_pickup)){
            with(player_find(_pickup.pick)){
                var _max = array_length(pet);
                if(_max > 0){
                     // Remove Oldest Pet:
                    with(pet[_max - 1]){
                        leader = noone;
                        can_take = true;
                    }
                    pet = array_slice(pet, 0, _max - 1);

                     // Add New Pet:
                    other.leader = self;
                    array_insert(pet, 0, other);
                    with(other) direction = point_direction(x, y, other.x, other.y);

                     // Effects:
                    with(instance_create(x, y, WepSwap)){
                        sprite_index = sprHealFX;
                        creator = other;
                    }
                    sound_play(sndHealthChestBig);
                    sound_play(sndHitFlesh);
                }
            }
        }
    }
    with(_pickup) visible = other.can_take;

	if(visible){
	     // Dodge:
	    if(instance_exists(leader)) team = leader.team;
	    if(sprite_index != spr_hurt){
	    	if(place_meeting(x, y, projectile) || place_meeting(x, y, Explosion) || place_meeting(x, y, PlasmaImpact) || place_meeting(x, y, MeatExplosion)){
		    	with(instances_matching_ne(instances_meeting(x, y, [projectile, Explosion, PlasmaImpact, MeatExplosion]), "team", team)){
		            if(place_meeting(x, y, other)) with(other){
		                 // Custom Dodge Event:
		                var _scrt = pet + "_hurt";
		                if(mod_script_exists("mod", "petlib", _scrt)){
		                    mod_script_call("mod", "petlib", _scrt);
		                }

		                 // Default:
		                else if(other.speed > 1 || !instance_is(other, projectile)){
		                    sprite_index = spr_hurt;
		                    image_index = 0;
		                }
		            }
		        }
	    	}
	    }

	     // Pet Collision:
	    if(place_meeting(x, y, object_index)){
	        with(instances_meeting(x, y, instances_matching(object_index, "name", name))){
	            if(place_meeting(x, y, other) && visible){
	                var _dir = point_direction(other.x, other.y, x, y);
	                motion_add(_dir, 1);
	                with(other) motion_add(_dir + 180, 1);
	            }
	        }
	    }

	     // Wall Collision:
	    if(place_meeting(x + hspeed, y + vspeed, Wall)){
	        if(place_meeting(x + hspeed, y, Wall)) hspeed = 0;
	        if(place_meeting(x, y + vspeed, Wall)) vspeed = 0;
	    }
	}

#define Pet_end_step
     // Wall Collision Part2:
    if(visible && place_meeting(x, y, Wall)){
    	x = xprevious;
    	y = yprevious;
        if(place_meeting(x + hspeed, y, Wall)) hspeed = 0;
        if(place_meeting(x, y + vspeed, Wall)) vspeed = 0;
        x += hspeed;
        y += vspeed;
    }

#define Pet_draw
    image_alpha = abs(image_alpha);

     // Outline Setup:
    var _outline = (
    	instance_exists(leader)									&&
    	surface_exists(surfPet.surf)							&&
    	player_is_local_nonsync(player_find_local_nonsync())
	);
    if(_outline){
    	with(surfPet){
            x = other.x - (w / 2);
            y = other.y - (h / 2);

	        surface_set_target(surf);
	        draw_clear_alpha(0, 0);

	        other.x -= x;
	        other.y -= y;
    	}
    }

     // Custom Draw Event:
    var _scrt = pet + "_draw";
    if(mod_script_exists("mod", "petlib", _scrt)){
        mod_script_call("mod", "petlib", _scrt);
    }

     // Default:
    else draw_self_enemy();

     // Draw Outline:
    if(_outline){
		with(surfPet){
			other.x += x;
			other.y += y;

			surface_reset_target();

			 // Fix coast stuff:
			if("wading" in other && other.wading > 0){
				with(surflist_get("CoastSwim")) if(surface_exists(surf)) surface_set_target(surf);
			}
			
			 // Outline:
			d3d_set_fog(true, player_get_color(other.leader.index), 0, 0);
			for(var a = 0; a <= 360; a += 90){
				var _x = x,
				    _y = y;

				if(a >= 360) d3d_set_fog(false, 0, 0, 0);
				else{
					_x += dcos(a);
					_y -= dsin(a);
				}

				draw_surface(surf, _x, _y);
	        }
        }
    }

     // CustomObject draw events are annoying:
    image_alpha = -abs(image_alpha);

#define Pet_alrm0
    alarm0 = 30;
    if(visible){
         // Where leader be:
        var _leaderDir = 0,
            _leaderDis = 0;

        if(instance_exists(leader)){
            _leaderDir = point_direction(x, y, leader.x, leader.y);
            _leaderDis = point_distance(x, y, leader.x, leader.y);
        }

         // Find Current Path Direction:
        if(array_length(path) > 0){
             // Find Nearest Point on Path:
            var	_nearest = 0,
        		d = 1000000;

            for(var i = 0; i < array_length(path); i++){
                var _x = path[i, 0],
                    _y = path[i, 1],
        		    _dis = point_distance(_x, _y, x, y);

        		if(_dis < d){
        			_nearest = i;
        			d = _dis;
        		}
        	}

             // Find Direction to Next Point on Path:
            var _follow = _nearest + 1;
            if(_follow < array_length(path)){
                var _x = path[_follow, 0],
                    _y = path[_follow, 1];

				if(collision_line(x, y, _x, _y, Wall, false, false)){
					_x = path[_nearest, 0];
					_y = path[_nearest, 1];
				}

                path_dir = point_direction(x, y, _x, _y);
            }
        }

         // Custom Alarm Event:
        var _scrt = pet + "_alrm0";
        if(mod_script_exists("mod", "petlib", _scrt)){
            var a = mod_script_call("mod", "petlib", _scrt, _leaderDir, _leaderDis);
            if(is_real(a) && a > 0) alarm0 = a;
        }

         // Default:
        else{
             // Follow Leader Around:
            if(instance_exists(leader)){
                if(_leaderDis > 24){
                     // Pathfinding:
                    if(array_length(path) > 0){
                        scrWalk(8, path_dir + orandom(20));
                        alarm0 = walk;
                    }

                     // Move Toward Leader:
                    else{
                        scrWalk(10, _leaderDir + orandom(10));
                        alarm0 = 10 + random(5);
                    }
                }
            }

             // Idle Movement:
            else scrWalk(15, random(360));
        }
    }


#define PortalPrevent_create(_x, _y)
	with(instances_matching(CustomEnemy, "name", "PortalPrevent")){
		instance_delete(id); // There can only be one
	}

	with(instance_create(_x, _y, CustomEnemy)){
		PortalPrevent_step();
		return id;
	}

#define PortalPrevent_step
	if(instance_number(enemy) <= 1) my_health = 99999;
	else my_health = 1;
	canfly = true;

#define PortalPrevent_death
	obj_create(x, y, name);


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
        follow_player	= true;	// Follow Player
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
	    /*if(!instance_is(creator, enemy)){
	    	f *= power(0.7, skill_get(mut_laser_brain));
	    }*/
	    image_xscale -= f;
	    image_yscale -= f;
    }
    else{
    	var f = current_time_scale;
	    /*if(ring && !instance_is(creator, enemy)){
	    	f *= power(0.7, skill_get(mut_laser_brain));
	    }*/
    	shrink_delay -= f;

    	if(shrink_delay <= 0 || (follow_player && !instance_exists(creator))){
    		shrink_delay = -1;
    	}

		 // Growin:
		var _goal = scale_goal;
		if(!instance_is(creator, enemy)){
			_goal *= power(1.2, skill_get(mut_laser_brain));
		}
		if(abs(_goal - image_xscale) > 0.05 || abs(_goal - image_yscale) > 0.05){
			image_xscale += (_goal - image_xscale) * 0.4;
			image_yscale += (_goal - image_yscale) * 0.4;

			 // FX:
			if(instance_is(creator, Player)){
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
	if(follow_player){
		if(!ring && instance_is(creator, Player)){
			with(creator){
				 // Visually Force Player's Gunangle:
				var _ang = 0,
					w = (other.roids ? bwep : wep);

				if(string_pos("quasar", string(wep_get(w))) == 1){
					_ang = angle_difference(other.image_angle, gunangle);
					with(other){
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
				}

				 // Kickback:
				if(other.shrink_delay > 0){
					var k = (8 * (1 + (max(other.image_xscale - 1, 0)))) / max(1, abs(_ang / 30));
					if(other.roids) bwkick = max(bwkick, k);
					else wkick = max(wkick, k);
				}

	        	 // Knockback:
	        	motion_add(other.image_angle + 180, other.image_yscale / 2.5);
			}

		     // Follow Player:
	    	var c = creator;
	        line_dir_goal = c.gunangle;
	        hold_x = c.x;
	        hold_y = c.y;
	        with(c){
	        	if(!place_meeting(x + hspeed, y, Wall)) other.hold_x += hspeed;
	        	if(!place_meeting(x, y + vspeed, Wall)) other.hold_y += vspeed;
	        }
	        if(roids){
	        	hold_y -= 4;
	        	//hold_x -= lengthdir_x(2 * c.right, c.gunangle - 90);
	        	//hold_y -= lengthdir_y(2 * c.right, c.gunangle - 90);
	        }
		}
		else follow_player = false;
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
    var _lineAdd = max(12, 20 * image_yscale),
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
        _walled = false;

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
					var l = 0.5,
						d = point_direction(other.x, other.y, x, y);

					x += lengthdir_x(l, d);
					y += lengthdir_y(l, d);
					motion_add_ct(d, 0.03);
				}
			}
		}

		 // Position Beams:
		var o = _yoff + (6 * other.image_yscale),
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

    if(_lineAdd > 0) while(true){
        if(!_walled){
        	if(!ring && collision_line(_lx, _ly, _cx, _cy, Wall, false, false)){
        		_walled = true;
        	}
        	else{
	    		 // Add to Line Draw:
        		var o = _lineAdd * 2;
        		if(point_seen_ext(_lx, _ly, o, o, -1)){
	        		for(var a = -1; a <= 1; a += 2){
		                var l = (_lineWid * a) + 6,
		                    d = _dir - 90,
		                    _x = _cx,
		                    _y = _cy,
		                    _xtex = (_dis / line_dis),
		                    _ytex = !!a;

						if(ring){
							var o = (2 + (2 * ring_size * image_yscale)) / max(shrink_delay / 20, 1);
							_x += lengthdir_x(o, d) * dcos((_dir *  2) + (wave * 4));
							_y += lengthdir_y(o, d) * dsin((_dir * 10) + (wave * 4));
						}

		                array_push(line_seg, {
		                    x    : _x,
		                    y    : _y,
		                    dir  : _dir,
		                    xoff : lengthdir_x(l, d),
		                    yoff : lengthdir_y(l, d),
		                    xtex : _xtex,
		                    ytex : _ytex
		                });
		            }
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
            with(instances_meeting(_cx, _cy, instances_matching_ne(hitme, "team", team))){
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
	            		if(!instance_exists(other) || other.my_health <= 0 || other.size >= ((image_yscale <= 1) ? 3 : 4) || blast_hit){
	            			line_dis = _dis;
	            		}
	        			blast_hit = false;
                	}
                }
            }
        }

         // Effects:
    	if(chance_ct(1, 160 / _lineAdd)){
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
			blast_hit = false;
			if(ring && array_length(line_seg) > 0){
				array_push(line_seg, line_seg[0]);
				array_push(line_seg, line_seg[1]);
			}
			break;
		}
    }

     // Effects:
    if(!ring){
	    if(chance_ct(1, 4)){
	        var _xoff = orandom(12) - ((12 * image_xscale) + _lineAdd),
	    		_yoff = orandom(random(28 * image_yscale)),
	    		_x = _lx + lengthdir_x(_xoff, _dir) + lengthdir_x(_yoff, _dir - 90),
	    		_y = _ly + lengthdir_y(_xoff, _dir) + lengthdir_y(_yoff, _dir - 90);
	
			if(!position_meeting(_x, _y, TopSmall)){
		        with(instance_create(_x, _y, BulletHit)){
		        	sprite_index = spr.QuasarBeamHit;
		        	image_angle = _dir + 180;
		        	image_angle += random(angle_difference(point_direction(_lx, _ly, x, y), image_angle));
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
	}

#define QuasarBeam_alrm0
	alarm0 = random_range(4, 16);

	 // Laser:
	with(obj_create(x, y, "QuasarBeam")){
		image_angle = random(360);
        team = other.team;
        creator = other.creator;

        spr_strt = -1;
        follow_player = false;
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
            	sound_play_hit(sndPlasmaHit, 0.3)
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
	        draw_vertex_texture(x + other.hspeed + (xoff * _yscale), y + other.vspeed + (yoff * _yscale), xtex, ytex);
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
    		if(other.roids){
    			bwepangle = other.angle;
    		}
    		else{
	    		wepangle = other.angle;
		    	back = (((((gunangle + wepangle) + 360) % 360) > 180) ? -1 : 1);
		    	scrRight(gunangle + wepangle);
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
        shrink_delay = 120;
		ring = true;
		force = 1;

		 // Alarms:
		alarm0 = 10 + random(20);

		instance_create(x, y, PortalClear);

		return id;
	}


#define ReviveNTTE_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		creator = noone;
		vars = {};
		p = -1;

		return id;
	}

#define ReviveNTTE_step
	if(instance_exists(creator)){
		x = creator.x;
		y = creator.y;
		p = creator.p;
	}
	else{
		 // Set Vars on Newly Revived Player:
		if(player_is_active(p)){
			var _vars = vars;
			with(nearest_instance(x, y, instances_matching_gt(instances_matching(Player, "p", p), "id", id))){
				for(var i = 0; i < lq_size(_vars); i++){
					variable_instance_set(id, lq_get_key(_vars, i), lq_get_value(_vars, i));
				}

				 // Grab Back Pet:
				if("pet" in self){
					with(pet) if(instance_exists(self) && !instance_exists(leader)){
	                    leader = other;
	                    
	                     // FX:
	                    with(instance_create(x, y, HealFX)){
	                    	depth = other.depth - 1;
	                    }
	                    sound_play_pitch(sndHealthChestBig, 1.2 + random(0.1));
					}
				}
			}
		}

		instance_destroy();
	}


#define TeslaCoil_create(_x, _y)
    with(instance_create(_x, _y, CustomObject)){
    	 // Visual:
    	sprite_index = sprLightningBall;
    	image_speed = 0.4 + orandom(0.1);
    	image_xscale = 0.4;
    	image_yscale = image_xscale;

         // Vars:
        creator = noone;
        creator_offx = 17;
        creator_offy = 2;
        num = 3;
        wave = random(1000);
        time = random_range(8, 16) * (1 + (0.5 * skill_get(mut_laser_brain)));
        target = noone;
        target_x = x;
        target_y = y;
        dist_max = 96;
        roids = false;
        bat = false;

         // Alarms:
        alarm0 = 1;
        
        return id;
    }

#define TeslaCoil_alrm0
	 // Find Targetable Enemies:
	var _maxDist = dist_max,
    	_target = [],
    	_teamPriority = null; // Higher teams get priority (Always target IDPD first. Props are targeted only when no enemies are around)

	if(instance_exists(creator)){
        with(instances_matching_ne(instances_matching_ne(hitme, "team", creator.team), "mask_index", mskNone)){
            if(distance_to_point(other.x, other.y) < _maxDist && in_sight(other)){
            	if(_teamPriority == null || team > _teamPriority){
            		_teamPriority = team;
            		target = [];
            	}

                array_push(_target, id);
            }
        }
	}

	 // Random Arc:
	if(array_length(_target) <= 0){
		var _dis = _maxDist * random_range(0.2, 0.8),
			_dir = random(360);

		do{
			target_x = x + lengthdir_x(_dis, _dir);
			target_y = y + lengthdir_y(_dis, _dir);
			_dis -= 4;
		}
		until (_dis < 12 || !collision_line(x, y, target_x, target_y, Wall, false, false));
	}

	 // Enemy Arc:
	else{
		target = instance_random(_target);
		target_x = target.x;
		target_y = target.y;
		time *= 1.5;
	}

#define TeslaCoil_step
    wave += current_time_scale;

    if(instance_exists(creator)){
    	 // Follow Creator:
		if(instance_exists(creator)){
	        var _xdis = creator_offx - ((roids ? creator.bwkick : creator.wkick) / 3),
	            _xdir = creator.gunangle,
	            _ydis = creator_offy * creator.right,
	            _ydir = _xdir - 90;

	        x = creator.x + creator.hspeed + lengthdir_x(_xdis, _xdir) + lengthdir_x(_ydis, _ydir);
	        y = creator.y + creator.vspeed + lengthdir_y(_xdis, _xdir) + lengthdir_y(_ydis, _ydir);
	        if(roids) y -= 4;
		}

		 // Targeting:
		if(instance_exists(target)){
	        with(target){
	        	other.target_x = x + orandom(2);
	        	other.target_y = y + orandom(2);
	        }
		}
		else if(target != noone){
			target = noone;
			time = min(time, 8);
		}

		 // Arc Lightning:
        var _tx = target_x,
        	_ty = target_y,
        	_bat = bat;

		if((instance_exists(target) || point_distance(x, y, _tx, _ty) < dist_max + 32) && !collision_line(x, y, _tx, _ty, Wall, false, false)){
			with(creator){
				with(lightning_connect(other.x, other.y, _tx, _ty, (point_distance(other.x, other.y, _tx, _ty) / 4) * sin(other.wave / 90), false)) if(_bat){
					sprite_index = spr.BatLightning;
				}
			}

			 // Hit FX:
			if(!place_meeting(_tx, _ty, LightningHit)){
				with(instance_create(_tx, _ty, LightningHit)){
					image_speed = 0.2 + random(0.2);
					
					 // Bat Effect:
					if(_bat) sprite_index = spr.BatLightningHit;
				}
			}
		}

         // Effects:
        view_shake_max_at(x, y, 3);
        with(creator){
        	var k = 3;
        	if(other.roids) bwkick = max(bwkick, k);
        	else wkick = max(wkick, k);
        }
        
         // Death Timer:
        if(time > 0){
        	time -= current_time_scale;
			if(time <= 0) instance_destroy();
        }
    }
    else instance_destroy();

#define TeslaCoil_end_step
	if(bat){
		var c = creator;
		with(instances_matching_le(target, "my_health", 0)){
			with(c) if(my_health < maxhealth){
				my_health = min(my_health + 1, maxhealth);
				
				 // Effects:
				instance_create(x, y, HealFX);
				
				 // Sounds:
				sound_play_pitchvol(sndBloodlustProc, 0.8 + random(0.4), 1.0);
				sound_play_pitchvol(sndLightningCrystalHit, 0.4 + random(0.4), 1.2);
			}
		}
	}


#define Trident_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.Trident;
		image_speed = 0.4;

		 // Vars:
		mask_index = msk.Trident;
		damage = 40;
		force = 5;
		typ = 1;
		curse = false;
		curse_return = false;
		curse_return_delay = false;
		rotspeed = 0;
		target = noone;
		marrow_target = noone;
		hit_time = 0;
        hit_list = {};
		wep = "trident";

		 // Alarms:
		alarm0 = 15;

		return id;
	}

#define Trident_step
	hit_time += current_time_scale;

	 // Cursed:
	if(curse){
		 // Cursed Trident Returns:
		curse_return = (instance_exists(creator) && (creator.wep == wep || creator.bwep == wep));

		 // FX:
		if(visible && current_frame_active){
			instance_create(x + orandom(4), y + orandom(4), Curse);
		}
	}
	
	 // Break Projectiles:
	with(instances_matching_ne(instances_matching(projectile, "typ", 1, 2), "team", team)){
		if(object_index != PopoNade && distance_to_object(other) <= 8){
			sleep(2);
			instance_destroy();
		}
	}

	 // Bolt Marrow:
	if(speed > 0){
		if(skill_get(mut_bolt_marrow) > 0){
			var n = marrow_target;
			if(!in_sight(n)){
				var _x = x + hspeed,
					_y = y + vspeed,
					_disMax = 1000000;

				with(instances_matching_ne(instances_matching_ne([enemy, Player, Sapling, Ally, SentryGun, CustomHitme], "team", team, 0), "mask_index", mskNone, sprVoid)){
					if(in_sight(other) && in_distance(other, 160)){
						if(array_length(instances_matching(PopoShield, "creator", id)) <= 0){
							if(lq_defget(other.hit_list, string(self), 0) <= other.hit_time){
								var d = point_distance(x, y, _x, _y);
								if(d < _disMax){
									_disMax = d;
									other.marrow_target = id;
								}
							}
						}
					}
				}
			}
			else{
				rotspeed += (angle_difference(point_direction(x, y, n.x, n.y), direction) / max(1, 60 / (point_distance(x, y, n.x, n.y) + 1))) * min(1, 0.1 * skill_get(mut_bolt_marrow)) * current_time_scale;
				//rotspeed = clamp(rotspeed, -90, 90);
			}

			var f = min(1, abs(rotspeed) / 90);
			x -= hspeed_raw * f;
			y -= vspeed_raw * f;
		}

		 // Rotatin:
		if(rotspeed != 0){
			direction += rotspeed * current_time_scale;
			image_angle += rotspeed * current_time_scale;
			rotspeed -= rotspeed * 0.3 * current_time_scale;
		}
	}

	else{
		 // Trident Return:
		if(curse_return){
			if(curse_return_delay < 6){
				 // Movin:
				var l = max(5, point_distance(x, y, creator.x, creator.y) * 0.1 * current_time_scale) / (curse_return_delay + 1),
					d = point_direction(x, y, creator.x, creator.y);
	
				x += lengthdir_x(l, d);
				y += lengthdir_y(l, d);

				 // Walled:
				if(!place_free(x, y)){
					xprevious = x;
					yprevious = y;
					if(visible){
						visible = false;
						sound_play_pitch(sndCursedReminder, 1 + orandom(0.3));
						repeat(4) with(instance_create(x + orandom(8), y + orandom(8), Smoke)){
							motion_add(d + 180, random(1));
						}
					}
				}
				else if(place_meeting(x, y, Floor)){
					if(!visible){
						visible = true;
						sound_play_pitch(sndSwapCursed, 1 + orandom(0.3));
						repeat(4) with(instance_create(x + orandom(8), y + orandom(8), Smoke)){
							motion_add(d, random(2));
						}
					}
				}

				 // Rotatin:
				if(in_distance(creator, 40)){
					d += 180;
				}
				image_angle += (angle_difference(d, image_angle) * 0.05 * current_time_scale) / (curse_return_delay + 1);
			}
			if(curse_return_delay <= 8){
				image_angle += orandom(2 + curse_return_delay) * current_time_scale;
			}

			var f = 0.5 * current_time_scale;
			curse_return_delay -= clamp(curse_return_delay, -f, f);

			 // Grab Weapon:
			if(place_meeting(x, y, creator) || (creator.mask_index == mskNone && place_meeting(x, y, Portal))){
				instance_destroy();
			}
		}

		 // Stopped:
		else instance_destroy();
	}

#define Trident_end_step
	 // Trail:
	if(visible){
		var _x1 = x,
		    _y1 = y,
		    _x2 = xprevious,
		    _y2 = yprevious;
	
		with(instance_create(_x1, _y1, BoltTrail)){
			image_xscale = point_distance(_x1, _y1, _x2, _y2);
			image_angle = point_direction(_x1, _y1, _x2, _y2);
			if(other.curse) image_blend = make_color_rgb(235, 0, 67);
			creator = other.creator;

			/*
			if(skill_get(mut_bolt_marrow)){
				image_blend = make_color_rgb(235, 0, 67);
				with(instance_copy(false)){
					image_yscale *= 2;
					image_alpha *= 0.15;
				}
			}
			*/
		}
	}

#define Trident_draw
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * max(2/3, 1 - (0.025 * abs(rotspeed) * min(1, speed_raw / 8))), image_yscale, image_angle + rotspeed, image_blend, image_alpha);

#define Trident_anim
	image_speed = 0;
	image_index = 0;

#define Trident_alrm0
	friction = 0.5; // Stop movin

#define Trident_hit
	if(speed > 0 && lq_defget(hit_list, string(other), 0) <= hit_time){
		projectile_hit_push(other, damage, force);

		if(marrow_target == other) marrow_target = noone;

		 // Keep Movin:
		if(!lq_exists(hit_list, string(other)) && speed > 12){
			speed = 18;
		}
	
		 // Stick:
		if(other.my_health > 0){
			//replacing this interaction for now cause of stabby trident interaction// if(!skill_get(mut_long_arms)){
			if(!instance_exists(creator) || !skill_get(mut_throne_butt) || creator.race != "chicken"){
				sound_play_pitch(sndAssassinAttack, 2);
				target = other;
				speed = 0;

				 // Curse Return:
				if(curse){
					curse_return_delay = 8 + random(2);
					mask_index = mskFlakBullet;
				}
			}
		}

		 // Impact:
		else if(rotspeed < 5){
			x -= hspeed / 3;
			y -= vspeed / 3;
		}
		var f = clamp(other.size, 1, 5);
		view_shake_at(x, y, 12 * f);
		sleep(16 * f);

         // Set Custom IFrames:
        lq_set(hit_list, string(other), hit_time + 3);
	}

#define Trident_wall
	if(speed > 0){
		var _canWall = true;
		if(speed > 12){
			if(skill_get(mut_bolt_marrow) > 0 && !instance_exists(marrow_target)){
				Trident_step();
			}
			if(marrow_target != creator && in_sight(marrow_target) && in_distance(marrow_target, 160)){
				if(in_range(abs(angle_difference(image_angle, point_direction(x, y, marrow_target.x, marrow_target.y))), 10, 160)){
					_canWall = false;
				}
			}
		}

		 // Stick in Wall:
		if(_canWall){
			speed = 0;
			move_contact_solid(direction, 16);
	
			 // Curse Return:
			if(curse){
				curse_return_delay = 8 + random(2);
				mask_index = mskFlakBullet;
			}
	
			 // Effects:
			instance_create(x, y, Debris);
			sound_play(sndBoltHitWall);
			sound_play_pitchvol(sndExplosionS, 1.5, 0.7);
			sound_play_pitchvol(sndBoltHitWall,  1, 0.7);
		}

		 // Marrow Homin on Target:
		else if(instance_exists(marrow_target)){
			var a = angle_difference(point_direction(x, y, marrow_target.x, marrow_target.y), direction) * 0.25 * current_time_scale;
			direction += a;
			image_angle += a;
			alarm0 = min(alarm0, 1);
		}
	}

#define Trident_destroy
	 // Hit FX:
	var l = 18,
		d = direction,
		_x = x + lengthdir_x(l, d),
		_y = y + lengthdir_y(l, d);

	instance_create(_x, _y, BubblePop).image_index = 1;
	repeat(3) scrFX(
		_x,
		_y,
		[direction + orandom(30), choose(1, 2, 2)],
		Bubble
	);

#define Trident_cleanup // pls YAL why did u make portals instance_delete everything
	var w = wep;
	if(is_object(w)) w.visible = true;

	 // Return to Player:
	if(curse_return) with(creator){
		var b = ((wep == w) ? "" : "b");
		if(is_object(w)){
			w.wepangle = angle_difference(other.image_angle, gunangle)
			if(chance(1, 8)) w.wepangle += 360 * sign(w.wepangle);
			variable_instance_set(self, b + "wepangle",	w.wepangle);
		}

		 // Effects:
		with(instance_create(x, y, WepSwap)) creator = other;
		sound_play(weapon_get_swap(w));
		sound_play(sndSwapCursed);
	}

	 // Drop Weapon:
	else{
		 // Delete Existing:
		with(instances_matching([WepPickup, ThrownWep], "wep", w)){
			instance_destroy();
		}

		 // Walled:
		if(!visible && !place_meeting(x, y, Floor)){
			if(instance_exists(Floor)){
				var n = instance_nearest(x, y, Floor);
				x = (n.bbox_left + n.bbox_right) / 2;
				y = (n.bbox_top + n.bbox_bottom) / 2;
				repeat(4) instance_create(x, y, Smoke);
			}
		}

		 // WepPickup:
		var t = target;
		with(obj_create(x, y, (instance_exists(t) ? "WepPickupStick" : WepPickup))){
			wep = w;
			curse = other.curse;
			rotation = other.image_angle;

			 // Stick:
			if(instance_exists(t)){
				stick_target = t;
				stick_damage = other.damage;
				if(max(t.sprite_width, t.sprite_height) > 64){
					rotation += angle_difference(point_direction(x, y, t.x, t.y), rotation) / 2;
					stick_x = x - t.x;
					stick_y = y - t.y;
				}
				else{
					var l = 24,
						d = rotation + 180;

					stick_x = lengthdir_x(l, d);
					stick_y = lengthdir_y(l, d);
				}
				
				 // Bigger Hitbox: 
				image_xscale *= 2;
				image_yscale = image_xscale;
			}

			 // Determination:
			if(instance_exists(other.creator) && ultra_get(char_chicken, 2) && other.creator.race == "chicken"){
				creator = other.creator;
				alarm0 = 30;
			}
		}
	}


#define VenomPellet_create(_x, _y)
    with(instance_create(_x, _y, CustomProjectile)){
         // Visual:
        sprite_index = sprScorpionBullet;
        depth = -3;

         // Vars:
        mask_index = mskEnemyBullet1;
        friction = 0.75;
        damage = 2;
        force = 4;
        typ = 2;

        return id;
    }

#define VenomPellet_step
    if(speed <= 0) instance_destroy();

#define VenomPellet_anim
    image_speed = 0;
    image_index = image_number - 1;

#define VenomPellet_hit
    if(projectile_canhit_melee(other)){
        projectile_hit_push(other, damage, force);
    }

#define VenomPellet_destroy
    with(instance_create(x, y, BulletHit)) sprite_index = sprScorpionBulletHit;


#define WepPickupStick_create(_x, _y)
	with(instance_create(_x, _y, WepPickup)){
		 // Vars:
		stick_target = noone;
		stick_x = 0;
		stick_y = 0;
		stick_damage = 0;

		return id;
	}

#define WepPickupStick_step
	var t = stick_target;
	if(instance_exists(t)){
		speed = 0;
		nowade = true;
		rotspeed = 0;

		 // Stick in Target:
		var	l = 24,
			d = rotation;

		x = t.x + t.hspeed_raw + stick_x;
		y = t.y + t.vspeed_raw + stick_y;
		if("z" in t){
			if(t.object_index == RavenFly || t.object_index == LilHunterFly){
				y += t.z;
			}
			else y -= t.z;
		}
		visible = t.visible;
		xprevious = x;
		yprevious = y;

		 // Deal Damage w/ Taken Out:
		if(stick_damage != 0 && fork()){
			var _damage = stick_damage,
				_creator = creator,
				_ang = rotation,
				_wep = wep,
				_x = x,
				_y = y;

			wait 0;
			if(!instance_exists(self)){
				with(t){
					repeat(3) instance_create(x, y, AllyDamage);
					projectile_hit_raw(self, _damage, true);

					with(nearest_instance(_x, _y, array_combine(instances_matching(Player, "wep", _wep), instances_matching(Player, "bwep", _wep)))){
						if(wep == _wep){
							wkick = 10;
						}
						else if(bwep == _wep){
							bwkick = 10;
						}
					}
				}
			}
			exit;
		}
	}
	else{
		nowade = false;
		if(rotspeed == 0) rotspeed = random_range(1, 2) * choose(-1, 1);
	}


/// Mod Events
#define game_start
	 // Reset Pets:
    with(instances_matching(CustomObject, "name", "Pet")) instance_destroy();

#define step
	if(DebugLag) trace_time();

     // Harpoon Connections:
    with(global.poonRope){
        var _rope = self,
            _link1 = _rope.link1,
            _link2 = _rope.link2;

        if(instance_exists(_link1) && instance_exists(_link2)){
        	if(_rope.broken < 0) _rope.length = 0; // Deteriorate Rope

            var _length = _rope.length,
            	_linkDis = point_distance(_link1.x, _link1.y, _link2.x, _link2.y) - _length,
                _linkDir = point_direction(_link1.x, _link1.y, _link2.x, _link2.y);

             // Pull Link:
            if(_linkDis > 0){
            	var _pullLink = [_link1, _link2],
            		_pullInst = [];

            	for(var i = 0; i < array_length(_pullLink); i++){
            		with(_pullLink[i]) if(!instance_is(self, projectile)){
            			var _inst = noone;
            			
            			 // Rope Attached to Harpoon:
		                if(instance_is(self, BoltStick)){
		                    if(pull_speed != 0 && !instance_is(target, becomenemy)){
		                    	_inst = target;
		                    }
		                }
		                
		                 // Rope Directly Attached:
		                else if(_link1 != _link2){
		                	if(
				            	(!instance_is(self, prop) && team != 0)	||
				            	instance_is(self, RadChest)				||
				            	instance_is(self, Car)					||
				            	instance_is(self, CarVenus)				||
				            	instance_is(self, CarVenusFixed)
					        ){
			                	_inst = id;
			                }
		                }

						 // Add to Pull List:
						if(instance_exists(_inst)){
							array_push(_pullInst, {
		        				inst : _inst,
		        				pull : (instance_is(_inst, Player) ? 0.5 : (("pull_speed" in self) ? pull_speed : 2)),
		        				drag : min(_linkDis / 3, 10 / (("size" in _inst) ? (max(_inst.size, 0.5) * 2) : 2)),
		        				dir  : _linkDir + (i * 180)
		        			});
						}
            		}
            	}

            	 // Pull:
            	with(_pullInst){
            		var _pull = pull,
            			_drag = drag,
            			_dir = dir;

            		with(inst){
	                    hspeed += lengthdir_x(_pull, _dir);
	                    vspeed += lengthdir_y(_pull, _dir);
	                    x += lengthdir_x(_drag, _dir);
	                    y += lengthdir_y(_drag, _dir);
            		}
            	}
            }

             // Draw Rope:
            script_bind_draw(draw_rope, (collision_line(_link1.x, _link1.y, _link2.x, _link2.y, Wall, false, false) ? -8 : 0), _rope);

             // Rope Stretching:
            with(_rope){
                break_force = max(_linkDis, 0);

                 // Break:
                if(break_timer <= 0 || break_force > 1000){
	                if(break_force > 100 || (_rope.broken < 0 && _length <= 1)){
	                    if(_rope.broken >= 0){
	                    	sound_play_pitch(sndHammerHeadEnd, 2);
	                    }
	                    scrHarpoonUnrope(_rope);
	                }
                }
                else break_timer -= current_time_scale;
            }
        }
        else scrHarpoonUnrope(_rope);
    }

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

	 // Enable/Disable Pet Outline Surface:
    with(surfPet){
    	active = false;
		if(array_length(instances_matching_ne(instances_matching(CustomObject, "name", "Pet"), "leader", noone)) > 0){
	    	var	_option = lq_defget(opt, "outlinePets", 2);
	    	if(_option > 0 && (_option < 2 || player_get_outlines(player_find_local_nonsync()))){
	    		active = true;
	    	}
		}
    }

	 // Bind Events:
	script_bind_draw(draw_shadows_top, -7.1);
	if(array_length(instances_seen(instances_matching(CustomObject, "name", "BigDecal", "NestRaven"), 24)) > 0){
		script_bind_draw(draw_ravenflys, -9);
	}

	 // Eyes Custom Pickup Attraction:
    with(instances_matching(Player, "race", "eyes")){
    	if(canspec && button_check(index, "spec")){
    		var _vx = view_xview[index],
    			_vy = view_yview[index];

    		with(instance_rectangle(_vx, _vy, _vx + game_width, _vy + game_height, global.pickup_custom)){
			    var e = on_pull;
				if(!mod_script_exists(e[0], e[1], e[2]) || mod_script_call(e[0], e[1], e[2])){
	    			var	l = (1 + skill_get(mut_throne_butt)) * current_time_scale,
	    				d = point_direction(x, y, other.x, other.y),
	    				_x = x + lengthdir_x(l, d),
	    				_y = y + lengthdir_y(l, d);
	
			        if(place_free(_x, y)) x = _x;
			        if(place_free(x, _y)) y = _y;
				}
    		}
    	}
    }

	 // Grabbing Custom Pickups:
    with(instances_matching([Player, Portal], "", null)){
        if(place_meeting(x, y, Pickup)){
        	with(instances_meeting(x, y, global.pickup_custom)){
        		if(instance_exists(self) && place_meeting(x, y, other)){
		            var e = on_open;
		            if(!mod_script_exists(e[0], e[1], e[2]) || !mod_script_call(e[0], e[1], e[2])){
			             // Effects:
			            if(sprite_exists(spr_open)){
			            	with(instance_create(x, y, SmallChestPickup)){
			            		sprite_index = other.spr_open;
			            		image_xscale = other.image_xscale;
			            		image_yscale = other.image_yscale;
			            		image_angle = other.image_angle;
			            	}
			            }
			            sound_play(snd_open);
			
			            instance_destroy();
		            }
        		}
        	}
        }
    }

    global.pickup_custom = [];

	if(DebugLag) trace_time("tegeneral_step");

#define draw_bloom
	if(DebugLag) trace_time();

	// draw_set_alpha(0.1);
 //   with(instances_matching(CustomProjectile, "name", "BubbleBomb")){
 //       var r = ((image_index / 2) + (image_xscale + image_yscale));
 //       draw_circle((x - 1), (y - 1) - z, r, false);
 //   }
 //   draw_set_alpha(1);

	 // Charmed Gator Flak:
    with(instances_matching(CustomProjectile, "name", "AllyFlakBullet")){
        draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
    }

	 // Crab Venom:
    with(instances_matching(CustomProjectile, "name", "VenomPellet")){
        draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.2 * image_alpha);
    }

	 // Lightning Discs:
    with(instances_matching(CustomProjectile, "name", "LightningDisc")){
        if(visible){
        	scrDrawLightningDisc(sprite_index, image_index, x, y, ammo, radius, 2, image_xscale, image_yscale, image_angle + rotation, image_blend, 0.1 * image_alpha);
        }
    }

	 // Quasar Beams:
    with(instances_matching(CustomProjectile, "name", "QuasarBeam", "QuasarRing")){
        if(visible){
        	var a = 0.1 * (1 + (skill_get(mut_laser_brain) * 0.5));
        	if(blast_hit) a *= 1.5 / image_yscale;
        	QuasarBeam_draw_laser(2 * image_xscale, 2 * image_yscale, a * image_alpha);

        	if(ring){
        		with(ring_lasers) if(instance_exists(self) && !visible){
        			QuasarBeam_draw_laser(2 * image_xscale, 2 * image_yscale, a * image_alpha);
        		}
        	}
        }
    }
    
     // Electroplasma:
    with(instances_matching(CustomProjectile, "name", "ElectroPlasma")){
    	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * 0.1);
    }
    
     // Hot Quasar Weapons:
    draw_set_color_write_enable(true, false, false, true);
    with(instances_matching_gt(Player, "reload", 0)){
    	if(array_find_index(["quasar blaster", "quasar rifle", "quasar cannon"], wep_get(wep)) >= 0){
    		var l = -2,
    			d = gunangle - 90,
    			_alpha = image_alpha * (reload / weapon_get_load(wep)) * (1 + (0.2 * skill_get(mut_laser_brain)));

    		draw_weapon(weapon_get_sprt(wep), x + lengthdir_x(l, d), y + lengthdir_y(l, d), gunangle, wepangle, wkick, right, image_blend, _alpha);
    	}
    }
    with(instances_matching_gt(instances_matching(Player, "race", "steroids"), "breload", 0)){ // hey JW why couldnt u make weapons arrays why couldnt you pleas e
    	if(array_find_index(["quasar blaster", "quasar rifle", "quasar cannon"], wep_get(bwep)) >= 0){
    		var l = -4,
    			d = gunangle - 90,
    			_alpha = image_alpha * (breload / weapon_get_load(bwep)) * (1 + (0.2 * skill_get(mut_laser_brain)));

    		draw_weapon(weapon_get_sprt(bwep), x + lengthdir_x(l, d), y + lengthdir_y(l, d) - 2, gunangle, wepangle, bwkick, -right, image_blend, _alpha);
    	}
    }
    draw_set_color_write_enable(true, true, true, true);
	
	 // Flak Ball:
	with(instances_matching(CustomProjectile, "name", "FlakBall")){
		var _scale = 1.5,
			_alpha = 0.1 * clamp(array_length(inst) / 12, 1, 2);

		if(array_length(instances_matching(inst, "name", name)) > 0){
			_alpha *= 1.5;
		}

		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * _scale, image_yscale * _scale, rotation, image_blend, image_alpha * _alpha);
	}

     // GunCont (Laser Cannon):
	with(instances_matching(CustomObject, "name", "GunCont")){
		if(bloom){
			var _scr = on_draw;
			if(array_length(_scr) >= 3){
				image_xscale *= 2;
				image_yscale *= 2;
				image_alpha *= 0.1;

				mod_script_call(_scr[0], _scr[1], _scr[2]);
	
				image_xscale /= 2;
				image_yscale /= 2;
				image_alpha /= 0.1;
			}
		}
	}

	if(DebugLag) trace_time("tegeneral_draw_bloom");

#define draw_shadows
	if(DebugLag) trace_time();

	 // Pets:
    with(instances_matching(CustomObject, "name", "Pet")) if(visible){
        draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
    }

	 // Bubble Bombs:
    with(instances_matching(instances_matching(CustomProjectile, "name", "BubbleBomb"), "big", true)) if(visible){
    	var	f = min((z / 6) - 4, 6),
    		w = max(6 + f, 0) + sin((x + y + z) / 8),
    		h = max(4 + f, 0) + cos((x + y + z) / 8),
    		_x = x,
    		_y = y + 6;

        draw_ellipse(_x - w, _y - h, _x + w, _y + h, false);
    }

	 // Custom RavenFlys:
	with(instances_matching(CustomObject, "name", "NestRaven")) if(visible){
		if(sprite_index != spr_idle && position_meeting(x, bbox_bottom + 8, Floor)){
			draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
		}
	}

	if(DebugLag) trace_time("tegeneral_draw_shadows");

#define draw_shadows_top
	instance_destroy();

	if(DebugLag) trace_time();

	with(surfShadowTop){
		x = view_xview_nonsync;
		y = view_yview_nonsync;
		w = game_width;
		h = game_height;

		var _inst = instances_matching(CustomObject, "name", "NestRaven", "TopEnemy");

		if(instance_exists(BackCont) && array_length(_inst) > 0){
			active = true;
			if(surface_exists(surf)){
				 // Draw Shadows to Surface:
				surface_set_target(surf);
				draw_clear_alpha(0, 0);

				with(_inst) if(visible){
					if(sprite_index == spr_idle || !position_meeting(x, bbox_bottom, Floor) || (z <= 0 && position_meeting(x, bbox_bottom + 8, Wall))){
						var _x = x + spr_shadow_x,
							_y = y + spr_shadow_y;

						if(name != "NestRaven") _y -= 8;

						draw_sprite(spr_shadow, 0, _x - other.x, _y - other.y);
					}
				}

				surface_reset_target();

				 // Draw Surface:
				draw_set_flat(BackCont.shadcol);
				draw_set_alpha(BackCont.shadalpha);
				draw_surface(surf, x, y);
				draw_set_alpha(1);
				draw_set_flat(-1);
			}
		}
		else active = false;
	}

	if(DebugLag) trace_time("tegeneral_draw_shadows_top");

#define draw_dark // Drawing Grays
    draw_set_color(c_gray);

	if(DebugLag) trace_time();

     // Big Decals:
    with(instances_matching(instances_matching(CustomObject, "name", "BigDecal"), "area", 4, 104)){
    	draw_circle(x, y, 96, false);
    }
    
     // Electroplasma:
    with(instances_matching(CustomProjectile, "name", "ElectroPlasma")){
    	draw_circle(x, y, 48, false);
    }

     // Lightning Discs:
    with(instances_matching(CustomProjectile, "name", "LightningDisc", "LightningDiscEnemy")){
        draw_circle(x - 1, y - 1, (radius * image_xscale * 3) + 8 + orandom(1), false);
    }

     // Quasar Beams:
    draw_set_flat(draw_get_color());
    with(instances_matching(CustomProjectile, "name", "QuasarBeam", "QuasarRing")){
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
    draw_set_flat(-1);

	if(DebugLag) trace_time("tegeneral_draw_dark");

#define draw_dark_end // Drawing Clear
    draw_set_color(c_black);

	if(DebugLag) trace_time();

     // Big Decals:
    with(instances_matching(instances_matching(CustomObject, "name", "BigDecal"), "area", 4, 104)){
    	draw_circle(x, y, 40, false);
    }
    
     // Electroplasma:
    with(instances_matching(CustomProjectile, "name", "ElectroPlasma")){
    	draw_circle(x, y, 24, false);
    }

     // Lightning Discs:
    with(instances_matching(CustomProjectile, "name", "LightningDisc", "LightningDiscEnemy")){
        draw_circle(x - 1, y - 1, (radius * image_xscale * 1.5) + 4 + orandom(1), false);
    }

	 // Quasar Beams:
    draw_set_flat(draw_get_color());
    with(instances_matching(CustomProjectile, "name", "QuasarBeam", "QuasarRing")){
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
    draw_set_flat(-1);

	if(DebugLag) trace_time("tegeneral_draw_dark_end");

#define draw_ravenflys
	instance_destroy();
	with(RavenFly){
    	draw_sprite_ext(sprite_index, image_index, x, y + z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
	}


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
#define path_create(_xstart, _ystart, _xtarget, _ytarget)                               return  mod_script_call(   "mod", "telib", "path_create", _xstart, _ystart, _xtarget, _ytarget);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call(   "mod", "telib", "race_get_sprite", _race, _sprite);
#define scrFloorMake(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "scrFloorMake", _x, _y, _obj);
#define scrFloorFill(_x, _y, _w, _h)                                                    return  mod_script_call(   "mod", "telib", "scrFloorFill", _x, _y, _w, _h);
#define scrFloorFillRound(_x, _y, _w, _h)                                               return  mod_script_call(   "mod", "telib", "scrFloorFillRound", _x, _y, _w, _h);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc("mod", "telib", "unlock_get", _unlock);
#define unlock_set(_unlock, _value)                                                             mod_script_call_nc("mod", "telib", "unlock_set", _unlock, _value);
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
#define draw_set_flat(_color)                                                                   mod_script_call_nc("mod", "telib", "draw_set_flat", _color);
#define trace_error(_error)                                                                     mod_script_call_nc("mod", "telib", "trace_error", _error);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc("mod", "telib", "sleep_max", _milliseconds);
#define array_clone_deep(_array)                                                        return  mod_script_call_nc("mod", "telib", "array_clone_deep", _array);
#define lq_clone_deep(_obj)                                                             return  mod_script_call_nc("mod", "telib", "lq_clone_deep", _obj);
#define array_exists(_array, _value)                                                    return  mod_script_call_nc("mod", "telib", "array_exists", _array, _value);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc("mod", "telib", "wep_merge", _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call(   "mod", "telib", "wep_merge_decide", _hardMin, _hardMax);
#define array_shuffle(_array)                                                           return  mod_script_call_nc("mod", "telib", "array_shuffle", _array);