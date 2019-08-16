#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.sav = mod_variable_get("mod", "teassets", "sav");

    global.debug_lag = false;

	global.surfShadowTop = surflist_set("ShadowTop", 0, 0, game_width, game_height);
	global.surfPet = surflist_set("Pet", 0, 0, 64, 64);

    global.poonRope = [];

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)

#macro surfShadowTop global.surfShadowTop
#macro surfPet global.surfPet


#define AllyFlakBullet_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.AllyFlakBullet;
		hitid = [sprite_index, "ALLY FLAK"];

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
		with(instance_create(x, y, EnemyBullet3)){
			instance_change(Bullet2, false);
			sprite_index = sprBullet2;
			bonus = false;

			motion_add(random(360), random_range(9, 12));
			image_angle = direction;

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
		if(other.sprite_index == sprEFlak) sprite_index = sprEFlakHit;
		else sprite_index = sprFlakHit;
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
		seekdist = 40;
		setup = false;
		big = false;
		
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
	 // Setup:
	if(!setup){
		setup = true;
		
		 // Bigify:
		if(big){
			 // Visual:
			sprite_index = sprHeavyBolt;
			
			 // Vars:
			friction = 0;
			damage = 32;
			seekdist = 16;
		}
	}

	 // Trail:
	var l = point_distance(x, y, xprevious, yprevious),
		d = point_direction(x, y, xprevious, yprevious);
		
	with(instance_create(x, y, BoltTrail)){
		image_xscale = l;
		image_angle = d;
	}
	
#define BoneArrow_alrm1
	alarm1 = 5;

	 // Seeking:
	var _seekDist = seekdist * skill_get(mut_bolt_marrow);;
	with(nearest_instance(x, y, instances_matching_ne([Player, enemy], "team", team))) if(point_distance(x, y, other.x, other.y) <= _seekDist){
		other.x = x;
		other.y = y;
	}
	
	 // Live to seek another frame:
	else alarm1 = 1;
	
#define BoneArrow_wall
	if(big){
		friction = 0.8;
		sleep(10);
		view_shake_at(x, y, 10);
	}

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
		friction = 0.1;
		damage = 24;
		force = 8;
		heavy = false;
		walled = false;
		rotspd = 0;
		setup = true;

		return id;
	}

#define BoneSlash_setup
	setup = false;

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

		with(scrBoneDust(x + lengthdir_x(l, d), y + lengthdir_y(l, d))){
			motion_set(d - (random_range(90, 120) * c), 1 + random(2));
		}
	}

#define BoneSlash_end_step
	if(setup) BoneSlash_setup();

#define BoneSlash_step
	 // Brotate:
	image_angle += (rotspd * current_time_scale);
	
#define BoneSlash_hit
	if(setup) BoneSlash_setup();

	if(projectile_canhit_melee(other) && other.my_health > 0){
		projectile_hit(other, damage, force, direction);
		
	     // Bone Pickup Drops:
	    with(other) if(my_health <= 0){
			var _raddrop = variable_instance_get(id, "raddrop", 0),
				d = (size >= 2) ? 2.6 : 1.8,
				n = max((maxhealth / d) - _raddrop, 0);
				
			if(n > 0){
				 // Big Pickups:
				var _numLarge = floor(n div 10);
				if(_numLarge > 0) repeat(_numLarge){
					with(obj_create(x, y, "BoneBigPickup")){
						motion_set(random(360), 3 + random(1));
					}
				}
	
				 // Small Pickups:
				var _numSmall = ceil(n mod 10);
				if(_numSmall > 0) repeat(_numSmall){
					with(obj_create(x, y, "BonePickup")){
						motion_set(random(360), 3 + random(1));
					}
				}
			}
	    }
	}

#define BoneSlash_wall
	if(!walled){
		walled = true;
		friction = 0.4;

		 // Hit Wall FX:
		var w = instance_nearest(x - 8, y - 8, other.object_index);
		with(instance_create(w.x + 8, w.y + 8, MeleeHitWall)){
			image_angle = other.image_angle;
			image_blend = choose(c_white, make_color_rgb(208, 197, 180), make_color_rgb(157, 133, 098), make_color_rgb(111, 082, 043));
		}
		sound_play_pitchvol(sndMeleeWall, 2 + orandom(0.3), 1);
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
	    if(place_meeting(x, y - z, Player)){
	    	with(instances_meeting(x, y, Player)){
	    		with(other){
	            	motion_add(point_direction(other.x, other.y, x, y), 1.5);
	    		}
	        }
	    }
	    if(place_meeting(x, y - z, projectile)){
	    	 // Baseball:
	        with(instances_meeting(x, y, [Slash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, CustomSlash])){
	        	if(place_meeting(x, y, other)){
	        		with(other) if(speed < 8){
	        			direction = other.direction;
	        			speed = max(0, 10 - (4 * array_length(target)))
	
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
    var n = 0;
    with(target){
    	if(instance_exists(self)){
	        //speed += friction * current_time_scale;

	    	 // Push Bubble:
    		if(instance_is(self, hitme)) with(other){
    			x += (other.hspeed_raw * other.size) / 6;
    			y += (other.vspeed_raw * other.size) / 6;
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
    	else with(other) if(is_array(target)){
    		target = array_delete_value(target, other);
    	}
    }

     // Grab Projectile:
	if(place_meeting(x, y - z, projectile) || place_meeting(x, y - z, enemy)){
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
    				_drag = 4 + (4 * array_length(target)),
		    		_grab = array_combine(
		    			instances_matching_ne(instances_matching_ne(projectile, "typ", 0), "name", name),
		    			array_combine(
		    				instances_matching_le(enemy, "size", _maxSize),
		    				instances_matching(DogGuardian, "size", _maxSize + 1),
	    				)
		    		);

		        with(instances_meeting(x, y - z, instances_matching_ne(instances_matching(_grab, "bubble_bombed", null, false), "team", team))){
		            if(place_meeting(x, y + other.z, other)){
	                    bubble_bombed = true;

	                    if(is_array(other.target)) array_push(other.target, id);
	                    else other.target = id;

	                    with(other){
	                    	if(!big){
		                        x = lerp(x, other.x,	 0.5);
		                        y = lerp(y, other.y + z, 0.5);
		                        friction = max(0.3, friction);
		                        motion_add(other.direction, other.speed / 2);
	                    	}
	                    	if(instance_is(other, hitme)){
	                    		speed *= 0.8;
	                    	}
	
	                         // Effects:
	                        instance_create(x, y - z, Dust);
	                        repeat(4) instance_create(x, y - z, Bubble);
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

	 // Make Sure Projectile Dies:
	with(target) if(instance_is(self, projectile)){
		instance_destroy();
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


#define BubbleExplosion_create(_x, _y)
    with(instance_create(_x, _y, PopoExplosion)){
    	 // Visual:
        sprite_index = spr.BubbleExplosion;
        hitid = [sprite_index, "BUBBLE EXPLOSION"];

         // Vars:
        mask_index = mskExplosion;
        damage = 3;
        force = 1;
        alarm0 = -1; // No scorchmark
        alarm1 = -1; // No CoDeath

         // Crown of Explosions:
        if(crown_current == crwn_death){
        	script_bind_end_step(BubbleExplosion_death, 0, id);
        }

         // FX:
        sound_play_pitch(sndExplosionS, 2);
        sound_play_pitch(sndOasisExplosion, 1 + random(1));
        repeat(10) instance_create(x, y, Bubble);

        return id;
    }

#define BubbleExplosion_death(_inst)
	with(_inst){
		repeat(choose(2, 3)){
	        with(obj_create(x + orandom(9), y + orandom(9), "BubbleExplosionSmall")){
	            team = other.team;
	        }
		}
    }
	instance_destroy();


#define BubbleExplosionSmall_create(_x, _y)
	with(instance_create(_x, _y, SmallExplosion)){
		 // Visual:
    	sprite_index = spr.BubbleExplosionSmall;
    	hitid = [sprite_index, "SMALL BUBBLE#EXPLOSION"];

		 // Vars:
		mask_index = mskSmallExplosion;
        damage = 3;
        force = 1;

         // FX:
        sound_play_pitch(sndOasisExplosionSmall, 1 + random(2));
        repeat(5) instance_create(x, y, Bubble);

		return id;
    }

#define BubbleExplosionSmall_step
	 // Projectile Kill:
	if(place_meeting(x, y, projectile)){
		with(instances_meeting(x, y, instances_matching_ne(instances_matching_ne(projectile, "team", team), "typ", 0))){
			if(place_meeting(x, y, other)) instance_destroy();
		}
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
		force = 12;
		
		return id;
	}
	
#define HyperBubble_end_step
	mask_index = mskBullet1;

	var _dist = 100,
		_proj = [],
		_dis = 8,
		_dir = direction,
		_mx = lengthdir_x(_dis, _dir),
		_my = lengthdir_y(_dis, _dir);
		
	 // Muzzle Explosion:
	array_push(_proj, obj_create(x, y, "BubbleExplosionSmall"));

	 // Hitscan:
	while(_dist-- > 0 && hits > 0 && !place_meeting(x, y, Wall)){
		x += _mx;
		y += _my;
		
		 // Effects:
		if(chance(1, 3)) scrFX([x, 4], [y, 4], [_dir + orandom(4), 6 + random(4)], Bubble).friction = 0.2;
		if(chance(2, 3)) scrFX([x, 2], [y, 2], [_dir + orandom(4), 2 + random(2)], Smoke);
		
		 // Explosion:
		var e = instances_meeting(x, y, instances_matching_gt(instances_matching_ne(hitme, "team", team), "my_health", 0));
		if(array_length(e) > 0){
			var _hit = false;
			with(e) if(place_meeting(x, y, other)){
				if(!_hit){
					_hit = true;
					with(other){
						hits--;
						array_push(_proj, obj_create(x, y, "BubbleExplosionSmall"));
					}
				}

				 // Impact Damage:
				projectile_hit(id, other.damage, other.force, _dir);
			}
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
			                    index = other.index;
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
        sprite_index = mskNone;
        image_blend_fade = c_gray;
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
        canhold = false;
        move_factor = 0;

         // Push:
        motion_add(random(360), 4 + random(2));
        image_angle = direction + 135;
        
         // Spriterize:
        if(fork()){
            wait 0;
            if(instance_exists(self)){
            	sprite_index = sprChickenFeather;
            	if(is_string(bskin)){
            		sprite_index = sprite_skin(bskin, sprite_index);
            	}
            	else if(instance_exists(creator) && is_string(creator.race)){
            		sprite_index = mod_script_call("race", creator.race, "race_sprite", sprite_index);
            	}
                if(sprite_index == sprChickenFeather){
                	sprite_index = spr.Parrot[0].Feather;
                }
            }
            exit;
        }

        return id;
    }

#define ParrotFeather_step
    speed -= speed_raw * 0.1;

     // Timer:
    if(stick_time > 0){
    	 // Generate Queue:
        if(stick){
        	if(array_length(stick_list) <= 0){
	            var n = instances_matching(instances_matching(instances_matching(object_index, "name", name), "target", target), "creator", creator);
	            with(n) stick_list = n;
        	}
        }
        else stick_list = [];

         // Decrement When First in Queue:
        if(
        	(stick && array_find_index(stick_list, id) == 0)
        	||
        	(!stick && stick_time < stick_time_max)
        ){
            stick_time -= lq_defget(variable_instance_get(target, "ntte_charm", 0), "time_speed", 1) * current_time_scale;
        }
    }

    if(stick_time > 0 && instance_exists(target) && (!stick || ("ntte_charm" in target && lq_defget(target.ntte_charm, "charmed", true)))){
        if(!stick){
        	stick_list = [];

             // Reach Target Faster:
            if(canhold){
	            if(
	            	distance_to_object(target) > 48 &&
	            	abs(angle_difference(direction, point_direction(x, y, target.x, target.y))) < 30
	            ){
	            	move_factor += ((distance_to_object(target) / 128) - move_factor) * 0.3 * current_time_scale;
	            }
	            else{
	            	move_factor -= move_factor * 0.8 * current_time_scale;
	            }
				move_factor = max(0, move_factor);
	        	x += hspeed_raw * move_factor;
	        	y += vspeed_raw * move_factor;
            }
            else move_factor = 0;

			 // Reaching Target:
            if(stick_wait == 0 && (!canhold || !instance_exists(creator) || !creator.visible || (!button_check(index, "spec") && creator.usespec <= 0))){
                canhold = false;

                 // Fly Towards Enemy:
                motion_add_ct(point_direction(x, y, target.x, target.y) + orandom(60), 1);

                if(distance_to_object(target) < 2 || (target == creator && place_meeting(x, y, Portal))){
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
                        var _wasUncharmed = ("ntte_charm" not in target || !target.ntte_charm.charmed);
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
                        	feather_ammo = min(feather_ammo + 1, feather_ammo_max * (1 + skill_get(mut_back_muscle)));
                        }
                        instance_delete(id);
                        exit;
                    }
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

			 // Stick Delay:
        	if(stick_wait > 0){
        		stick_wait -= current_time_scale;
        		if(stick_wait <= 0) stick_wait = 0;
        	}

        	 // Facing:
            image_angle = direction + 135;
        }
    }

    else{
         // Travel to Creator:
        if(!stick && stick_time > 0 && instance_exists(creator)){
            target = creator;
        }

         // End:
        else instance_destroy();
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

#define ParrotFeather_draw // Code below is 2x faster than using a draw_sprite_ext so
	var _col = image_blend;
	image_blend = merge_color(image_blend, image_blend_fade, 1 - (stick_time / stick_time_max));
	draw_self();
	image_blend = _col;

#define ParrotFeather_destroy
	 // Fall to Ground:
    with(instance_create(x, y, Feather)){
        sprite_index = other.sprite_index;
        image_angle = other.image_angle;
        image_blend = other.image_blend_fade;
        depth = ((!position_meeting(x, y, Floor) && !in_sight(other.creator)) ? -7 : 0);
    }

	 // Sound:
    sound_play_pitchvol(sndMoneyPileBreak, 1.5 + random(1.5), random(0.4));
    if("ntte_charm" in target){
    	sound_play_pitchvol(
    		sndAssassinPretend,
    		1.5 + random(1.5),
    		(stick_time_max / max(stick_time_max, lq_defget(target.ntte_charm, "time", 0)))
    	);
    }

#define ParrotFeather_cleanup
    with(stick_list) if(instance_exists(self)){
        stick_list = array_delete_value(stick_list, other);
    }


#define Pet_create(_x, _y)
    with(instance_create(_x, _y, CustomHitme)){
         // Visual:
        spr_idle = spr.PetParrotIdle;
        spr_walk = spr.PetParrotWalk;
        spr_hurt = spr.PetParrotHurt;
        spr_dead = mskNone;
        spr_shadow = shd24;
        spr_shadow_x = 0;
        spr_shadow_y = -1;
        spr_bubble = sprPlayerBubble;
        spr_bubble_pop = sprPlayerBubblePop;
        spr_bubble_x = 0;
        spr_bubble_y = 0;
    	hitid = -1;
        right = choose(1, -1);
        image_speed = 0.4;
        depth = -2;

         // Sound:
        snd_hurt = sndAllyHurt;
        snd_dead = sndAllyDead;

         // Vars:
        mask_index = mskPlayer;
        direction = random(360);
        friction = 0.4;
        pet = "Parrot";
        leader = noone;
        can_take = true;
        can_path = true;
        path = [];
        path_dir = 0;
        path_wall = [Wall, InvisiWall];
        path_delay = 0;
        maxhealth = 0;
        my_health = 0;
        team = 0;
        size = 1;
        push = 1;
        wave = random(1000);
        walk = 0;
        walkspd = 2;
        maxspeed = 3;
        revive_delay = 0;
        light = true;
        light_radius = [32, 96]; // [Inner, Outer]
        mask_store = null;
        portal_angle = 0;
        pickup_indicator = scrPickupIndicator("");
        my_portalguy = noone;
    	my_corpse = noone;

         // Scripts:
        mod_type = "mod";
        mod_name = "petlib";

         // Alarms:
        alarm0 = 20 + random(10);

        return id;
    }

#define Pet_begin_step
	 // Reset Hitbox:
    if(mask_index == mskNone && mask_store != null){
    	mask_index = mask_store;
    	mask_store = null;
    }

     // Loading Screen Visual:
    if(instance_exists(SpiralCont) && (instance_exists(GenCont) || instance_exists(LevCont))){
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
    if(instance_exists(Menu)){
    	instance_delete(id);
    	exit;
    }

	 // Reset Hitbox:
    if(mask_index == mskNone && mask_store != null){
    	mask_index = mask_store;
    	mask_store = null;
    }

    wave += current_time_scale;

    if(visible){
	     // Animate:
	    var _scrt = pet + "_anim";
	    if(mod_script_exists(mod_type, mod_name, _scrt)){ // Custom Animation Event
	        mod_script_call(mod_type, mod_name, _scrt);
	    }
	    else enemySprites();

	     // Push:
		if(instance_exists(leader) && place_meeting(x, y, Player)){
		    with(instances_meeting(x, y, Player)){
		        if(place_meeting(x, y, other) && speed > 0) with(other){
		            motion_add_ct(point_direction(other.x, other.y, x, y), push);
		        }
		    }
		}
	    if(place_meeting(x, y, object_index)){
	        with(instances_meeting(x, y, instances_matching(object_index, "name", name))){
	            if(place_meeting(x, y, other) && visible && (maxhealth <= 0 || my_health > 0)){
	                var _dir = point_direction(other.x, other.y, x, y);
	                motion_add(_dir, push);
	                with(other) motion_add(_dir + 180, push);
	            }
	        }
	    }

    	 // Custom Step Event:
        var _scrt = pet + "_step";
        if(mod_script_exists(mod_type, mod_name, _scrt)){
            mod_script_call(mod_type, mod_name, _scrt);
        }
    }
    else walk = 0;

	 // Death/Revive:
	if(maxhealth > 0){
	    if(my_health > 0){
			 // Destroy Corpse:
		    if(my_corpse != noone){
		        with(my_corpse){
		            repeat(4) scrFX([x, 8], [y, 8], 0, Smoke);
		            instance_destroy();
		        }
		        my_corpse = noone;
		        visible = true;
		    }
	    }
	
	     // Ded:
	    else{
	    	visible = false;
	        x += (sin(current_frame / 10) / 3) * current_time_scale;
	        y += (cos(current_frame / 10) / 3) * current_time_scale;

	         // Corpse:
	        if(my_corpse == noone){
	            my_corpse = scrCorpse(direction, speed);
	            motion_add(direction + orandom(20), speed * 2);

				 // Truly Dead:
	            sound_play_hit(snd_dead, 0.3);
	            sprite_index = spr_hurt;
	            image_index = 0;

				 // Manual Drawing:
				script_bind_draw(Pet_draw_bind, depth, id);

	             // Custom Death Event:
		        var _scrt = pet + "_death";
		        if(mod_script_exists(mod_type, mod_name, _scrt)){
		            mod_script_call(mod_type, mod_name, _scrt);
		        }
	        }

	         // Revive:
	        if(!instance_exists(my_corpse) || my_corpse.image_speed == 0){
	        	if(place_meeting(x, y, Player)){
		            with(instance_nearest(x, y, Player)){
		                projectile_hit_raw(id, 1, true);
		                lasthit = [sprHealBigFX, "LOVE"];
		            }
		            my_health = maxhealth;
		            sprite_index = spr_hurt;
		            image_index = 0;
	
		             // Effects:
		            with(instance_create(x, y, HealFX)) depth = other.depth - 1;
		            sound_play(sndHealthChestBig);
	        	}
	        }
	    }
	}

     // Player Owns Pet:
    var _pickup = pickup_indicator;
    if(instance_exists(leader)){
        can_take = false;
        persistent = true;

         // Pathfind to Leader:
        var _xtarget = leader.x,
            _ytarget = leader.y,
            _targetSeen = true;

	    for(var i = 0; i < array_length(path_wall); i++){
	    	var _wall = path_wall[i];
	    	if(collision_line(x, y, _xtarget, _ytarget, _wall, false, false)){
	    		_targetSeen = false;
	    		break;
	    	}
	    }

        if(can_path && !_targetSeen){
            var _pathEndX = x,
                _pathEndY = y;

             // Find Path's Endpoint:
            if(array_length(path) > 0){
                var e = path[array_length(path) - 1];
                _pathEndX = e[0];
                _pathEndY = e[1];
            }

             // Create path if current one doesn't reach leader:
            var _pathWalled = false;
		    for(var i = 0; i < array_length(path_wall); i++){
		    	var _wall = path_wall[i];
		    	if(collision_line(_pathEndX, _pathEndY, _xtarget, _ytarget, _wall, false, false)){
		    		_pathWalled = true;
		    		break;
		    	}
		    }
            if(_pathWalled){
            	if(path_delay > 0) path_delay -= current_time_scale;
            	else{
	            	path_delay = 30;
	                path = path_create(x, y, _xtarget, _ytarget, path_wall);
	                path = path_shrink(path, path_wall, 10);
            	}
            }
            else path_delay = 0;
        }
        else path = [];

         // Enter Portal:
        if(visible || instance_exists(my_corpse)){
        	 // Portal Attraction:
        	var _spin = 0;
        	with(Portal) if(point_distance(x, y, other.x, other.y) < 64){
        		with(other){
        			var l = 4 * current_time_scale,
        				d = point_direction(x, y, other.x, other.y),
        				_x = x + lengthdir_x(l, d),
        				_y = y + lengthdir_y(l, d)

        			if(place_free(_x, y)) x = _x;
        			if(place_free(x, _y)) y = _y;
        			_spin = (30 * right);
        		}
        	}
        	if(_spin != 0){
        		portal_angle += _spin;
        		sprite_index = spr_hurt;
        		image_index = 1;

        		 // No Escape:
        		speed -= min(speed, friction_raw * 3);
        		walk = 0;
        	}
        	else{
        		portal_angle += angle_difference(0, portal_angle) * 0.1 * current_time_scale;
        	}

			 // Enter:
            if(place_meeting(x, y, Portal) || instance_exists(GenCont) || instance_exists(LevCont)){
                visible = false;
                my_health = maxhealth;
                repeat(3) instance_create(x, y, Dust);
            }
        }
        else if(instance_exists(GenCont)){
            x = leader.x + orandom(16);
            y = leader.y + orandom(16);
            portal_angle = 0;
        }
    }

     // No Owner:
    else{
        if(visible) persistent = false;

		 // Leader Died or Something:
		if(leader != noone){
			leader = noone;
			can_take = true;
		}

         // Looking for a home:
        if(instance_exists(Player) && can_take && instance_exists(_pickup)){
            with(player_find(_pickup.pick)){
                var _max = array_length(ntte_pet);
                if(_max > 0){
                     // Remove Oldest Pet:
                    with(ntte_pet[0]){
                        leader = noone;
                        can_take = true;
                    }
                    ntte_pet = array_delete(ntte_pet, 0);

                     // Add New Pet:
                    other.leader = self;
                    array_push(ntte_pet, other);
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

	if(visible || instance_exists(my_corpse)){
		if(instance_exists(leader)) team = leader.team;

		 // Dodge Collision:
		if(maxhealth <= 0){
			if(place_meeting(x, y, projectile) || place_meeting(x, y, Explosion) || place_meeting(x, y, PlasmaImpact) || place_meeting(x, y, MeatExplosion)){
		    	with(instances_matching_ne(instances_meeting(x, y, [projectile, Explosion, PlasmaImpact, MeatExplosion]), "team", team)){
		            if(place_meeting(x, y, other)) with(other){
		                Pet_hurt(
		                	other.damage,
		                	other.force,
		                	point_direction(other.x, other.y, x, y)
		                );
		            }
		        }
	    	}
		}

		 // Wall Collision:
	    with(path_wall) with(other){
		    if(place_meeting(x + hspeed_raw, y + vspeed_raw, other)){
		        if(place_meeting(x + hspeed_raw, y, other)) hspeed_raw = 0;
		        if(place_meeting(x, y + vspeed_raw, other)) vspeed_raw = 0;
		    }
	    }
	}

	 // Disabling Collision to Avoid Projectiles:
	if(my_health <= 0){
		mask_store = mask_index;
		mask_index = mskNone;
	}

#define Pet_end_step
	 // Reset Hitbox:
    if(mask_index == mskNone && mask_store != null){
    	mask_index = mask_store;
    	mask_store = null;
    }

     // Wall Collision Part2:
    if((visible || instance_exists(my_corpse)) && place_meeting(x, y, Wall)){
    	x = xprevious;
    	y = yprevious;
        if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw = 0;
        if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw = 0;
        x += hspeed_raw;
        y += vspeed_raw;
    }

#define Pet_draw
	var _spr = sprite_index,
		_img = image_index,
		_x = x,
		_y = y,
		_xsc = image_xscale * right,
		_ysc = image_yscale,
		_ang = image_angle + portal_angle,
		_col = image_blend,
		_alp = image_alpha * (instance_exists(my_corpse) ? 0.4 : 1);

     // Outline Setup:
    var _outline = (
    	instance_exists(leader)									&&
    	!instance_exists(my_corpse)								&&
    	surface_exists(surfPet.surf)							&&
    	player_is_local_nonsync(player_find_local_nonsync())
	);
    if(_outline){
    	with(surfPet){
            x = _x - (w / 2);
            y = _y - (h / 2);

	        surface_set_target(surf);
	        draw_clear_alpha(0, 0);

	        _x -= x;
	        _y -= y;
    	}
    }

	 // Custom Draw Event:
    var _scrt = pet + "_draw";
    if(mod_script_exists(mod_type, mod_name, _scrt)){
        mod_script_call(mod_type, mod_name, _scrt, _spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
    }

	 // Default:
    else draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);

     // Draw Outline:
    if(_outline){
		with(surfPet){
			surface_reset_target();

			 // Fix coast stuff:
			if("wading" in other && other.wading > 0){
				with(surflist_get("CoastSwim")) if(surface_exists(surf)) surface_set_target(surf);
			}

			 // Outline:
			draw_set_fog(true, player_get_color(other.leader.index), 0, 0);
			for(var a = 0; a <= 360; a += 90){
				var _dx = x,
				    _dy = y;

				if(a >= 360) draw_set_fog(false, 0, 0, 0);
				else{
					_dx += dcos(a);
					_dy -= dsin(a);
				}

				draw_surface(surf, _dx, _dy);
	        }
        }
    }

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
        path_dir = path_direction(x, y, path, path_wall);

         // Custom Alarm Event:
        var _scrt = pet + "_alrm0";
        if(mod_script_exists(mod_type, mod_name, _scrt)){
            var a = mod_script_call(mod_type, mod_name, _scrt, _leaderDir, _leaderDis);
            if(is_real(a) && a != 0) alarm0 = a;
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

#define Pet_hurt(_hitdmg, _hitvel, _hitdir)
	if(visible && !instance_is(other, Corpse)){
		var _scrt = pet + "_hurt";

	     // Hurt:
    	if(my_health > 0){
    		if(!instance_is(other, Debris)){
				 // Manual debris exit cause debris don't call on_hurt correctly:
				if(other == self && _hitvel == 0 && _hitdir == 0){
					if(place_meeting(x, y, Debris)){
						with(instances_meeting(x, y, instances_matching_ge(instances_matching_gt(Debris, "speed", 2), "size", size - 1))){
							if(place_meeting(x, y, other)){
								if(_hitdmg == round(1 + (speed / 10))){
									exit;
								}
							}
						}
					}
				}

			     // Custom Hurt Event:
			    if(mod_script_exists(mod_type, mod_name, _scrt)){
			        mod_script_call(mod_type, mod_name, _scrt, _hitdmg, _hitvel, _hitdir);
			    }

			     // Default:
				else enemyHurt(_hitdmg, _hitvel, _hitdir);
    		}
    	}

	     // Dodge:
	    else if(maxhealth <= 0){
	    	if(sprite_index != spr_hurt){
			    if(_hitvel > 0 && (speed > 0 || !instance_is(self, projectile))){
				     // Custom Dodge Event:
				    if(mod_script_exists(mod_type, mod_name, _scrt)){
				        mod_script_call(mod_type, mod_name, _scrt, _hitdmg, _hitvel, _hitdir);
				    }
			
				     // Default:
				    else{
				        sprite_index = spr_hurt;
				        image_index = 0;
				    }
				}
	    	}
	    }
	}

#define Pet_draw_bind(_inst) // Manual drawing while dead, since visible=false to disable the shadow and stuff
	if(instance_exists(_inst) && _inst.my_health <= 0){
		with(_inst){
			other.depth = depth;
			event_perform(ev_draw, 0);
		}
	}
	else instance_destroy();


#define PickupIndicator_create(_x, _y)
    with(instance_create(_x, _y, CustomObject)){
    	 // Vars:
        mask_index = mskWepPickup;
		persistent = true;
        creator = noone;
        nearwep = noone;
        pick = -1;
        text = "";
        xoff = 0;
        yoff = 0;
        
         // Events:
        on_meet = ["", "", ""];

        return id;
    }

#define PickupIndicator_end_step
    pick = -1;
    with(nearwep) instance_delete(id);

     // Follow Creator:
    var c = creator;
    if(c != noone){
        if(instance_exists(c)){
        	x = c.x;
        	y = c.y;
        	image_angle = c.image_angle;
            image_xscale = c.image_xscale;
            image_yscale = c.image_yscale;
        }
        else instance_destroy();
    }


#define PortalPrevent_create(_x, _y)
	with(instances_matching(CustomEnemy, "name", "PortalPrevent")){
		instance_delete(id); // There can only be one
	}

	with(instance_create(0, 0, CustomEnemy)){
		PortalPrevent_step();
		return id;
	}

#define PortalPrevent_step
	x = 0;
	y = 0;
	if(instance_number(enemy) <= 1) my_health = 99999;
	else my_health = 1;
	canfly = true;

#define PortalPrevent_death
	obj_create(0, 0, name);


#define ReviveNTTE_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		persistent = true;
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
				if("ntte_pet" in self){
					with(ntte_pet) if(instance_exists(self) && !instance_exists(leader)){
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
	        var _xdis = creator_offx,
	            _xdir = direction,
	            _ydis = creator_offy,
	            _ydir = _xdir - 90;

			if(instance_is(creator, Player)){
		        _xdis -= (roids ? creator.bwkick : creator.wkick) / 3;
		        _xdir = creator.gunangle;
		        _ydis *= creator.right;
		        _ydir = _xdir - 90;
			}

			x = creator.x + creator.hspeed_raw + lengthdir_x(_xdis, _xdir) + lengthdir_x(_ydis, _ydir);
			y = creator.y + creator.vspeed_raw + lengthdir_y(_xdis, _xdir) + lengthdir_y(_ydis, _ydir);
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
        if(instance_is(creator, Player)) with(creator){
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

#define Trident_cleanup // pls why do portals instance_delete everything
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
	if(instance_exists(self)){
	    image_speed = 0;
	    image_index = image_number - 1;
	}

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
    with(instances_matching(CustomHitme, "name", "Pet")) instance_destroy();

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

	 // Pet Levels:
	with(instances_matching(LevelUp, "nttepet_levelup", null)){
		nttepet_levelup = true;
		if(instance_is(creator, Player)){
			if("ntte_pet" in creator) with(creator.ntte_pet){
				if(instance_exists(self)) with(other){
					instance_copy(false).creator = other;
				}
			}
		}
	}

	 // Enable/Disable Pet Outline Surface:
    with(surfPet){
    	active = false;
		if(array_length(instances_matching_ne(instances_matching(CustomHitme, "name", "Pet"), "leader", noone)) > 0){
	    	var	_option = option_get("outlinePets", 2);
	    	if(_option > 0 && (_option < 2 || player_get_outlines(player_find_local_nonsync()))){
	    		active = true;
	    	}
		}
    }

     // Bind Events:
    script_bind_end_step(end_step, 0);
    script_bind_draw(draw_shadows_top, -7.1);

	if(DebugLag) trace_time("tegeneral_step");

#define end_step
	instance_destroy();

	if(DebugLag) trace_time();

     // Pickup Indicator Collision:
    var _player = instances_matching(Player, "nearwep", noone);
    if(array_length(_player) > 0){
    	var _inst = instances_matching(instances_matching(CustomObject, "name", "PickupIndicator"), "visible", true);
	    with(_player){
	        if(place_meeting(x, y, CustomObject)){
	        	 // Find Nearest Touching Indicator:
	        	var _nearest = noone,
	        		_maxDis = 1000000;

	        	with(instances_meeting(x, y, _inst)){
	        		if(place_meeting(x, y, other)){
	        			var e = on_meet;
	        			if(!mod_script_exists(e[0], e[1], e[2]) || mod_script_call(e[0], e[1], e[2])){
		        			var _dis = point_distance(x, y, other.x, other.y);
		        			if(_dis < _maxDis){
		        				_maxDis = _dis;
		        				_nearest = id;
		        			}
	        			}
	        		}
	        	}

				 // Secret IceFlower:
	            with(_nearest){
	            	nearwep = instance_create(x + xoff, y + yoff, IceFlower);
				    with(nearwep){
				        name = other.text;
				    	x = xstart;
				    	y = ystart;
				    	xprevious = x;
				    	yprevious = y;
				        mask_index = mskNone;
				        sprite_index = mskNone;
				        spr_idle = mskNone;
				        spr_walk = mskNone;
				        spr_hurt = mskNone;
				        spr_dead = mskNone;
				        spr_shadow = -1;
						snd_hurt = -1;
						snd_dead = -1;
				        size = 0;
				        team = 0;
				        nowade = true;
					    my_health = 99999;
					    nexthurt = current_frame + 99999;
				    }
                    with(other){
                        nearwep = other.nearwep;
                        if(canpick && button_pressed(index, "pick")){
                            other.pick = index;
                        }
                    }
	            }
	        }
	    }
    }

	if(DebugLag) trace_time("tegeneral_end_step");

#define draw_bloom
	if(DebugLag) trace_time();

	 // Charmed Gator Flak:
    with(instances_matching(CustomProjectile, "name", "AllyFlakBullet")){
        draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
    }

	 // Crab Venom:
    with(instances_matching(CustomProjectile, "name", "VenomPellet")){
        draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.2 * image_alpha);
    }
	
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
    with(instances_matching(instances_matching(CustomObject, "name", "BigDecal"), "area", 4, 104)) if(visible){
    	draw_circle(x, y, 96, false);
    }

     // Pets:
    with(instances_matching(CustomHitme, "name", "Pet")){
    	if(visible && light && light_radius[1] > 0){
    		draw_circle(x, y, light_radius[1] + orandom(1), false);
    	}
    }

	if(DebugLag) trace_time("tegeneral_draw_dark");

#define draw_dark_end // Drawing Clear
    draw_set_color(c_black);

	if(DebugLag) trace_time();

     // Big Decals:
    with(instances_matching(instances_matching(CustomObject, "name", "BigDecal"), "area", 4, 104)) if(visible){
    	draw_circle(x, y, 40, false);
    }

     // Pets:
    with(instances_matching(CustomHitme, "name", "Pet")){
    	if(visible && light && light_radius[0] > 0){
    		draw_circle(x, y, light_radius[0] + orandom(1), false);
    	}
    }

	if(DebugLag) trace_time("tegeneral_draw_dark_end");



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
#define draw_set_flat(_color)                                                                   mod_script_call_nc("mod", "telib", "draw_set_flat", _color);
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
#define sound_play_hit_ext(_sound, _pitch, _volume)                                     return  mod_script_call_nc("mod", "telib", "sound_play_hit_ext", _sound, _pitch, _volume);
#define area_get_secret(_area)                                                          return  mod_script_call_nc("mod", "telib", "area_get_secret", _area);
#define area_get_underwater(_area)                                                      return  mod_script_call_nc("mod", "telib", "area_get_underwater", _area);
#define path_shrink(_path, _wall, _skipMax)                                             return  mod_script_call_nc("mod", "telib", "path_shrink", _path, _wall, _skipMax);
#define path_direction(_x, _y, _path, _wall)                                            return  mod_script_call_nc("mod", "telib", "path_direction", _x, _y, _path, _wall);
#define rad_drop(_x, _y, _raddrop, _dir, _spd)                                          return  mod_script_call_nc("mod", "telib", "rad_drop", _x, _y, _raddrop, _dir, _spd);
#define rad_path(_inst, _target)                                                        return  mod_script_call_nc("mod", "telib", "rad_path", _inst, _target);