#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.sav = mod_variable_get("mod", "teassets", "sav");

    global.debug_lag = false;

	global.surfShadowTop = surflist_set("ShadowTop", 0, 0, game_width, game_height);
	global.surfShadowTopMask = surflist_set("ShadowTopMask", 0, 0, 2 * game_width, 2 * game_height);
	global.surfPet = surflist_set("Pet", 0, 0, 64, 64);
	with(surfShadowTopMask) reset = true;

	 // Floor Related:
	global.floor_num = 0;
	global.floor_left = 0;
	global.floor_right = 0;
	global.floor_top = 0;
	global.floor_bottom = 0;

    global.poonRope = [];

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index + image_speed_raw >= image_number)

#macro depth_top -6 - (y / 10000)

#macro surfShadowTop global.surfShadowTop
#macro surfShadowTopMask global.surfShadowTopMask
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
		depth = -2;
		
		 // Vars:
		friction = 0.4;
		maxspeed = 12;
		damage = 3;
		typ = 2;
		setup = true;
		my_lwo = noone;
		ammo = 1;
		has_hit = false;
		returning = false;
		return_to = noone;
		big = false;
		key = "";
		seek = 40;
		in_wall = false;
		speed = maxspeed;
		
		return id;
	}
	
#define BatDisc_setup
	setup = false;
	
	 // Big:
	if(big){
		 // Visual:
		sprite_index = spr.BatDiscBig;
		mask_index = mskSuperFlakBullet;
		
		 // Vars:
		damage = 8;
		seek = 64;
		
		 // Explodo Timer:
		alarm1 = 30;
	}
	
#define BatDisc_step
	speed = min(speed, maxspeed);
	image_angle += 40 * current_time_scale;
	
	 // Targeting:
	var _disMax = 1000000,
		_wepVar = ["wep", "bwep"];
		
	for(var i = 0; i < array_length(_wepVar); i++){
		with(instances_matching([Player, WepPickup, ThrownWep], _wepVar[i], my_lwo)){
			var _dis = point_distance(x, y, other.x, other.y);
			if(_dis < _disMax){
				_disMax = _dis;
				other.return_to = id;
			}
		}
	}
	if(!instance_exists(return_to)) return_to = creator;

	 // Effects:
	if(in_wall){
		if(current_frame_active){
			view_shake_max_at(x, y, 4);
		}
		
		 // Dust trail:
		if(chance_ct(1, 3)){
			with(instance_create(x, y, Dust)) depth = -6.01;
		}
		
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
	
	else{
		 // Baseball:
		if(place_meeting(x, y, projectile)){
	    	var m = instances_meeting(x, y, [Slash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, CustomSlash]);
	        if(m) with(m){
	        	if(place_meeting(x, y, other)){
	        		with(other){
	        			speed = max(speed, 16);
	        			direction = other.direction;
	        			with(instance_create(x, y, Deflect)) image_angle = other.direction;
	        		}
	        	}
	        }
		}
		 
		 // Disc trail:
		if(current_frame_active){
			with(instance_create(x, y, DiscTrail)){
				sprite_index = (other.big ? spr.BigDiscTrail : sprDiscTrail);
			}
		}
	}
	
	 // Bolt Marrow:
	var _seekInst = noone,
		_seekDis = (seek * skill_get(mut_bolt_marrow));
		
	if(_seekDis > 0 && in_distance(creator, 160)){
		with(instances_matching_ne(instances_matching_ne(hitme, "team", team, 0), "mask_index", mskNone, sprVoid)){
			if(!instance_is(self, prop)){
				var _dis = point_distance(x, y, other.x, other.y);
				if(_dis < _seekDis){
					_seekDis = _dis;
					_seekInst = id;
				}
			}
		}
	}
	if(instance_exists(_seekInst)){
		image_index = 1;
		
		 // Homin'
		speed = max(speed - friction_raw, 0);
		motion_add_ct(point_direction(x, y, _seekInst.x, _seekInst.y), 1);
	}
	
	 // Return Home:
	else{
		image_index = 0;
		
		if(returning){
			var	_tx = (instance_exists(return_to) ? return_to.x : xstart),
				_ty = (instance_exists(return_to) ? return_to.y : ystart);
				
			 // Returning:
			if(
				instance_exists(return_to)
				? (distance_to_object(return_to) > 0)
				: (point_distance(x, y, _tx, _ty) > speed_raw)
			){
				var _speed = friction * 2;
				
				 // Slow Near Destination:
				if(point_distance(x, y, _tx, _ty) < 32){
					_speed = 2;
					speed = max(0, speed - (0.8 * current_time_scale));
				}
				
				motion_add_ct(point_direction(x, y, _tx, _ty), _speed);
			}
			
			 // Returned:
			else{
				var _wep = my_lwo,
					_dir = direction;
					
				with(instance_exists(return_to) ? return_to : self){
					 // Epic:
					if("gunangle" in self){
						var _kick = 6 * sign(angle_difference(_dir, gunangle + 90));
						if("wkick" in self && variable_instance_get(self, "wep") == _wep){
							wkick  = _kick;
						}
						if("bwkick" in self && variable_instance_get(self, "bwep") == _wep){
							bwkick  = _kick;
						}
					}
					
					 // Effects:
					view_shake_max_at(x, y, 12);
					if(friction > 0) motion_add(_dir, 2);
					sound_play_hit_ext(sndDiscgun,     0.8 + random(0.4), 0.6);
					sound_play_hit_ext(sndCrossReload, 0.6 + random(0.4), 0.8);
				}
				
				instance_destroy();
			}
		}
		
		 // Return when slow:
		else if(!big && speed <= 5){
			returning = true;
		}
	}
	
#define BatDisc_end_step
	if(setup) BatDisc_setup();
	
	 // Go through walls:
    if(returning && place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
        if(place_meeting(x + hspeed_raw, y, Wall)) x += hspeed_raw;
        if(place_meeting(x, y + vspeed_raw, Wall)) y += vspeed_raw;
    }
    
	 // Unstick:
	if(x == xprevious && hspeed_raw != 0) x += hspeed_raw;
	if(y == yprevious && vspeed_raw != 0) y += vspeed_raw;
	
#define BatDisc_alrm1
	 // Projectiles:
	for(var d = direction; d < direction + 360; d += (360 / 7)){
		with(obj_create(x, y, "BatDisc")){
			direction = d;
			visible = other.visible;
			in_wall = other.in_wall;
			creator = other.creator;
			my_lwo = other.my_lwo;
			team = other.team;
			ammo *= sign(other.ammo);
		}
		
		 // Effects:
		repeat(irandom_range(1, 2)){
			with(scrFX(x, y, random(6), Smoke)){
				if(other.in_wall){
					depth = -6.01;
					speed /= 2;
				}
			}
		}
	}
	
	 // Effects:
	view_shake_at(x, y, 20);
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
	if(!returning && !has_hit && instance_exists(return_to)){
		if(!big) returning = true;
		
		 // Bounce towards creator:
		direction = point_direction(x, y, return_to.x, return_to.y);
		
		 // Effects:
		sound_play_hit(sndDiscBounce, 0.4);
		with(instance_create(x + hspeed, y + vspeed, MeleeHitWall)){
			image_angle = other.direction;
		}
	}
	
	 // Enter Wall:
	else if(!in_wall){
		in_wall = true;
		
		 // Effects:
		instance_create(x, y, Smoke);
		view_shake_max_at(x, y, 8);
		sleep_max(8);
		
		 // Sounds:
		sound_play_hit(sndPillarBreak, 0.4);
		sound_play_hit(sndDiscHit, 0.4);
	}

#define BatDisc_destroy
	with(scrFX(x, y, [direction, 3], Smoke)){
		growspeed /= 2;
	}

#define BatDisc_cleanup
	 // Hold up:
	with(instances_matching(Player, "wep", my_lwo)){
		can_shoot = false;
	}
	with(instances_matching(Player, "bwep", my_lwo)){
		bcan_shoot = false;
	}
	
	 // Restore:
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
			depth = -6;

             // Vars:
    		mask_index = msk.BigTopDecal;
    		area = GameCont.area;

             // Avoid Bad Stuff:
            var	_tries = 1000,
            	_dis = 24,
            	_dir = random(360);
            	
			with(instance_nearest(x - 16, y - 16, Floor)){
				_dir = point_direction((bbox_left + bbox_right + 1) / 2, (bbox_top + bbox_bottom + 1) / 2, other.x, other.y);
			}
			
		    while(_tries-- > 0){
		        if(place_meeting(x, y, TopPot) || place_meeting(x, y, Bones) || place_meeting(x, y, Floor) || distance_to_object(PortalClear) < 32){
		            x = floor((x + lengthdir_x(_dis, _dir)) / 16) * 16;
		            y = floor((y + lengthdir_y(_dis, _dir)) / 16) * 16;
		        }
		        else break;
		    }
			depth -= ((y + 12) / 10000);
			
             // TopSmalls:
    		var _off = 16,
    		    s = _off * 3;

    		for(var _ox = -s; _ox <= s; _ox += _off){
    		    for(var _oy = -s; _oy <= s; _oy += _off){
			        if(!position_meeting(x + _ox, y + _oy, Floor) && !position_meeting(x + _ox, y + _oy, Wall) && !position_meeting(x + _ox, y + _oy, TopSmall)){
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
					depth = -6.0001; // Lay flat
					
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
    					var _fx = (bbox_left + bbox_right + 1) / 2;
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
                            depth = -8;
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
        case 1: // Bones
            repeat(irandom_range(2, 3)) with instance_create(_x, _y, WepPickup){
                motion_set(irandom(359), random_range(3, 6));
                wep = "crabbone";
                repeat(3) scrFX(x, y, 2, Smoke);
            }
            
             // Sound:
            sound_play_hit_ext(sndWallBreakBrick, 0.5 + random(0.2), 1);
            
            break;

        case 2: // Egg Vat
            repeat(irandom_range(3, 5)){
                with(instance_create(_x, _y, FrogEgg)){
                    alarm0 = irandom_range(20, 60);
                    nexthurt = current_frame + 6;
                    
                    sprite_index = sprFrogEggSpawn;
                    image_speed = random_range(0.1, 0.4);
                    image_index = 0;

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
                    
                     // FX:
                    repeat(2) with(instance_create(x + orandom(4), y + orandom(4), AcidStreak)){
                    	motion_add(random(360), 1);
                    	image_angle = direction;
                    	image_speed *= random_range(0.5, 1);
                    }
                }
            }
            sound_play_hit_ext(sndToxicBarrelGas, 0.5 + random(0.2), 2);
            break;

		case 3: // Nest Bits
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
            sound_play_hit_ext(sndMoneyPileBreak, 0.6 + random(0.2), 3);
            sound_play_hit_ext(sndWallBreakJungle, 1.2 + random(0.2), 1);
			break;

		case 4:
		case 104: // Spider Nest
			with(instance_create(_x, _y + 16, PortalClear)){
				image_xscale *= 1.5;
				image_yscale *= 1.2;
			}

			 // Sticky Floor:
			for(var _ox = -32; _ox <= 0; _ox += 32){
				with(instance_rectangle(_x + _ox, _y, _x + _ox + 32, _y + 32, [FloorExplo, TopSmall])){
					instance_destroy();
				}
				with(instance_create(_x + _ox, _y, Floor)){
					sprite_index = ((other.area == 104) ? sprFloor104B : sprFloor4B);
					styleb = true;
					traction = 2;
					material = 5;
					depth = 8;
				}
			}

			 // Inhabitants:
			repeat(irandom_range(2, 3)){
				var e = "Spiderling";
				if(chance(1, 3)) e = ((area == 104) ? InvSpider : Spider);

				with(obj_create(_x, _y, e)){
					nexthurt = current_frame + 30;

					 // Space Out:
                    var _tries = 50;
                    do{
                        x = _x + orandom(24);
                        y = _y + random(16);
                        xprevious = x;
                        yprevious = y;
                        if(!place_meeting(x, y, enemy)) break;
                    }
                    until (_tries-- <= 0);

					 // Props:
					repeat(irandom_range(1, 2)){
						with(instance_create(x + orandom(12), y + orandom(12), choose(InvCrystal, Cocoon))){
							nexthurt = current_frame + 30;
						}
					}
				}
			}
			
			 // Webby:
			repeat(irandom_range(12, 14)){
                with(instance_create(_x + orandom(32), _y - 12 + orandom(16), Feather)){
                	motion_add(point_direction(_x, _y, x, y), random(6));
                    sprite_index = spr.PetSpiderWebBits;
                    image_index = irandom(irandom(image_number - 1));
                    fall *= random(2);
                    image_speed = 0;
                    depth = -1;
                }
			}
			
			 // Sound:
			sound_play_hit_ext(sndWallBreakScrap, 0.6 + random(0.2), 0.75);
			sound_play_hit_ext(sndCocoonBreak, 0.5, 2);
			
			break;
			
		case 7: // Enormous Headphone Jack
			 // Explo:
			var	_ang = random(360),
				l = 12;
				
			for(var d = _ang; d < _ang + 360; d += (360 / 3)){
				with(instance_create(_x + lengthdir_x(l, d), _y + lengthdir_y(l, d), GreenExplosion)){
					hitid = 99;
				}
			}
			
			 // Rads:
			repeat(16) with(obj_create(_x + orandom(8), _y + 16 + orandom(8), "BackpackPickup")){
				target = instance_create(x, y, Rad);
				with(target) depth = -6;
				z = random(32);
				zspeed = random_range(4, 8);
			}
			
			 // Sound:
			sound_play_hit(sndBigGeneratorBreak, 0.1);
			
			break;

        case "pizza": // Pizza time
            repeat(irandom_range(4, 6)){
                obj_create(_x + orandom(4), _y + orandom(4), "Pizza");
                with(scrWaterStreak(_x, _y, 0, 0)){
                	speed = 1 + random(3);
                	direction = random(360);
                	image_angle = direction;
                    image_blend = c_orange;
                    image_speed *= random_range(0.4, 1.25);
                    depth = -3;
                	mask_index = mskNone;
                }
            }
            
             // Sound:
            sound_play_hit_ext(sndPizzaBoxBreak,  0.2 + random(0.2), 3);
            sound_play_hit_ext(sndWallBreakBrick, 0.6 + random(0.2), 0.9);
            
            break;

		case "oasis": // They livin in there u kno
			with(instance_create(_x, _y + 16, PortalClear)){
				image_xscale *= 1.5;
				image_yscale *= 1.2;
			}
			
			repeat(4){
				var _sx = _x + orandom(24),
					_sy = _y + orandom(16);

				if(chance(1, 100)){
					instance_create(_sx, _sy, Freak);
				}
				else{
					if(chance(1, 4)) obj_create(_sx, _sy, Crab);
					else obj_create(_sx, _sy, choose(BoneFish, "Puffer"));
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
			
			 // Floorify:
			for(var _ox = -32; _ox <= 0; _ox += 32){
				with(instance_rectangle(_x + _ox, _y, _x + _ox + 32, _y + 32, [FloorExplo, TopSmall])){
					instance_destroy();
				}
				with(instance_create(_x + _ox, _y, Floor)){
					sprite_index = sprFloor101B;
					styleb = true;
					material = 4;
					depth = 8;
				}
			}

			 // Effects:
			repeat(20) instance_create(_x + orandom(24), _y + orandom(24), Bubble);
			sound_play_hit_ext(sndOasisPortal, 2 + orandom(0.2), 2);
			sound_play_hit_ext(sndOasisExplosion, 1 + orandom(0.2), 2);
			break;

        case "trench": // Boom
			obj_create(_x, _y, "BubbleExplosion");
			repeat(3) obj_create(_x, _y, "BubbleExplosionSmall");
			repeat(150) scrFX([_x, 32], [_y, 24], random(2), Bubble);
			sound_play_hit_ext(sndOasisExplosionSmall, 1 + orandom(0.2), 3);
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
		home_inst = noone;
		home_dir = 0;
		setup = true;
		big = false;
		
		return id;	
	}

#define BoneArrow_setup
	setup = false;
	
	 // Bigify:
	if(big){
		 // Visual:
		sprite_index = spr.BoneArrowHeavy;
		
		 // Vars:
		friction = 0;
		damage = 42;
	}
	
#define BoneArrow_step
	 // Bone Marrow:
	if(home_inst != noone){
		if(instance_exists(home_inst) && projectile_canhit_melee(home_inst)){
			 // Homing:
			if(
				abs(angle_difference(point_direction(x, y, home_inst.x, home_inst.y), home_dir)) < 90
				&&
				!place_meeting(x + lengthdir_x(speed, home_dir), y + lengthdir_y(speed, home_dir), home_inst)
			){
				var _tx = home_inst.x - lengthdir_x(speed, home_dir),
					_ty = home_inst.y - lengthdir_y(speed, home_dir),
					_diff = angle_difference(point_direction(x, y, _tx, _ty), direction) * 0.5 * current_time_scale;
					
				direction += _diff;
				image_angle += _diff;
			}
			
			 // Done Homing:
			else{
				home_inst = noone;
				direction = home_dir;
				image_angle = direction;
			}
		}
		
		 // Return to Original Direction:
		else if(direction != home_dir){
			var _diff = angle_difference(home_dir, direction);
			if(abs(_diff) > 10) _diff = _diff * 0.5 * current_time_scale;
			direction += _diff;
			image_angle += _diff;
		}
		
		 // Done Homing:
		else home_inst = noone;
	}
	
	else{
		home_dir = direction;
		
		 // Home on Nearest Enemy:
		var _disMax = 24 * skill_get(mut_bolt_marrow);
		if(_disMax > 0){
			var _nearest = noone;
			with(instances_matching_ne(hitme, "team", team, 0)){
				if(!instance_is(self, prop)){
					var _dis = distance_to_point(other.x + other.hspeed, other.y + other.vspeed);
					if(_dis < _disMax){
						if(place_meeting(other.x, other.y, other)){
							_disMax = _dis;
							_nearest = id;
						}
					}
				}
			}
			home_inst = _nearest;
		}
	}

	 // Particles:
	if(chance_ct(1, 7)) scrBoneDust(x, y);
	if(speed <= 4 && current_frame_active){
		scrFX(x, y, [direction, speed], Dust);
	}

	 // Destroy:
	if(speed <= 2) instance_destroy();
	
#define BoneArrow_end_step
	 // Setup:
	if(setup) BoneArrow_setup();

	 // Trail:
	var l = point_distance(x, y, xprevious, yprevious),
		d = point_direction(x, y, xprevious, yprevious);
		
	with(instance_create(x, y, BoltTrail)){
		image_xscale = l;
		image_angle = d;
		
		image_yscale += (0.5 * other.big);
	}
	
#define BoneArrow_wall
	 // Movin' Closer:
	move_contact_solid(direction, speed);
	
	var l = point_distance(x, y, xprevious, yprevious),
		d = point_direction(x, y, xprevious, yprevious);
	with(instance_create(x, y, BoltTrail)){
		image_xscale = l;
		image_angle = d;
		
		image_yscale += (0.5 * other.big);
	}
	
	xprevious = x;
	yprevious = y;

	 // Big:
	if(big){
		friction = 1.2;
		sleep(12);
		view_shake_at(x, y, 8);
	}

	 // Effects:
	scrFX(x, y, [direction, 2], Dust);
	repeat(3) scrBoneDust(x, y);
	
	 // Bounce:
	var d = direction;
	speed *= 0.8;
	move_bounce_solid(true);
	image_angle = direction;
	home_dir += angle_difference(direction, d);
	
	 // Shotgun Shoulders:
	var _skill = skill_get(mut_shotgun_shoulders);
	speed = min(speed + wallbounce, 18);
	wallbounce *= 0.9;
	
	 // Sounds:
	if(speed > 4){
		sound_play_hit_ext(sndShotgunHitWall,	0.7 + random(0.3), 1.0);
		sound_play_hit_ext(sndPillarBreak,		0.9 + random(0.3), 0.8);
	}
	
#define BoneArrow_hit
	 // Setup:
	if(setup) BoneArrow_setup();
	
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


#define BoneFX_create(_x, _y)
	with(instance_create(_x, _y, Shell)){
		 // Visual:
		sprite_index = spr.BonePickup[irandom(array_length(spr.BonePickup) - 1)];
		image_speed = 0;
		depth = -3;
		
		 // Vars:
		creator = noone;
		delay = 2 + random(4);
		speed = (8 - delay) + random(2);
		direction = random(360);
		
		return id;
	}
	
#define BoneFX_step
	if(instance_exists(creator)){
		delay -= current_time_scale;
		if(delay <= 0){
			 // Gravitate:
			if(!place_meeting(x, y, creator) && !place_meeting(x, y, Portal)){
				x += creator.hspeed_raw / 2;
				y += creator.vspeed_raw / 2;
				
				var d = direction;
				motion_add_ct(point_direction(x, y, creator.x, creator.y), 2.4);
				image_angle += (direction - d);
				speed = min(speed, 8);
				
				xprevious = x + hspeed_raw*2;
				yprevious = y + vspeed_raw*2;
			}
			
			 // Goodbye:
			else{
				scrFX(x, y, [direction, 2 + random(3)], Dust);
				
				sleep(14);
				instance_destroy();
			}
		}
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
	    	var	_max = round(maxhealth / power(0.8, skill_get(mut_scarier_face))),
				_num = ceil(maxhealth / 5);

			if(_num > 0){
		    	if(
					!instance_is(self, prop)
					|| string_pos("Bone",  object_get_name(object_index)) > 0
					|| string_pos("Skull", object_get_name(object_index)) > 0
					|| ("name" in self && (string_pos("Bone", name) > 0 || string_pos("Skull", name) > 0))
				){
					 // Big Pickups:
					var _numLarge = floor((_num - 1) div 10);
					if(_numLarge > 0) repeat(_numLarge){
						with(obj_create(x, y, "BoneBigPickup")){
							motion_set(random(360), 3 + random(1));
						}
					}
		
					 // Small Pickups:
					var _numSmall = ceil((_num - 1) mod 10) + 1;
					if(_numSmall > 0) repeat(_numSmall){
						with(obj_create(x, y, "BonePickup")){
							motion_set(random(360), 3 + random(1));
						}
					}
		
					/*
					 // Reap Soul:
					if(other.heavy && size >= 1 && !instance_is(self, prop)){
						with(instance_create(x, y - 4, ReviveFX)){
							sprite_index = sprMeltGhost;
							image_xscale = other.image_xscale * (("right" in other) ? other.right : 1);
							image_yscale = other.image_yscale;
							image_speed = 0.4 + random(0.4);
							depth = -1;

							 // Ghost FX:
							repeat(3) with(scrFX(x, y, random_range(2, 4), Dust)){
								depth = 1;
							}
							sound_play_hit_ext(sndCorpseExploDead, image_speed * 5, 0.15);
						}

						 // Stat:
						stat_set("soul", stat_get("soul") + 1);
					}
					*/
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
		sound_play_hit_ext(sndMeleeWall, 2 + orandom(0.3), 0.2);
	}


#define BuriedVault_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		var	_w = 6,
			_h = 4;
			
		x = floor((x / 16) - (_w / 2)) * 16;
		y = floor((y / 16) - (_h / 2)) * 16;
		
		 // Vars:
		mask_index = mskWall;
		image_xscale = _w;
		image_yscale = _h;
		floor_num = -1;
		layout = [];
		area = 100;
		
		 // Away From Floors:
		direction = random(360);
		with(instance_nearest(_x - 16, _y - 16, Floor)){
			other.direction = point_direction((bbox_left + bbox_right + 1) / 2, (bbox_left + bbox_right + 1) / 2, _x, _y);
		}
		if(array_length(instances_matching(CustomHitme, "name", "PizzaDrain")) > 0){
			direction = (direction % 180) + 180;
		}
		
		var	_move = 32,
			_dis = random_range(40, 80);
			
		while(distance_to_object(Floor) < _dis){
			x = floor((x + lengthdir_x(_move, direction)) / 16) * 16;
			y = floor((y + lengthdir_y(_move, direction)) / 16) * 16;
		}
		
		 // Create TopSmalls/Decals:
		var _floors = [];
		for(var _ox = 0; _ox < _w; _ox++){
			for(var _oy = 0; _oy < _h; _oy++){
				var	_sx = x + (_ox * 16),
					_sy = y + (_oy * 16),
					_center = (_ox > 0 && _ox < _w - 1 && _oy > 0 && _oy < _h - 1);
					
				if(_center || chance(1, 3)){
					if(!position_meeting(_sx, _sy, Floor) && !position_meeting(_sx, _sy, Wall) && !position_meeting(_sx, _sy, TopSmall)){
						with(instance_create(_sx, _sy, TopSmall)){
							array_push(_floors, id);
						}
					}
				}
			}
		}
		scrTopDecal(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), GameCont.area);
		
		 // Spriterize TopSmalls:
		var _x1 = random_range(bbox_left, bbox_right),
			_y1 = random_range(bbox_top, bbox_bottom),
			_x2 = random_range(bbox_left + 16, bbox_right - 16),
			_y2 = random_range(bbox_top + 16, bbox_bottom - 16);
			
		with(array_shuffle(_floors)){
			sprite_index = area_get_sprite(
				collision_line(_x1, _y1, _x2, _y2, id, false, false)
					? other.area
					: GameCont.area,
				(position_meeting(_x2, _y2, id) || chance(2, 3))
					? sprWall1Top
					: sprWall1Trans
			);
		}
		
		 // Generate Room Layout:
		var	_fx = floor(((bbox_left + bbox_right + 1) / 2) / 16) * 16,
			_fy = floor(((bbox_top + bbox_bottom + 1) / 2) / 16) * 16,
			_num = irandom_range(6, 12),
			_dir = direction,
			_ped = true;
			
		while(_num > 0){
			var	_moveDis = 32,
				_moveDir = round(_dir / 90) * 90;
				
			_fx += lengthdir_x(_moveDis, _moveDir);
			_fy += lengthdir_y(_moveDis, _moveDir);
			
			var	_spawnPed = chance(_ped, 1 + ((_num - 1) * 2)),
				n = instance_nearest(_fx, _fy, Floor);
				
			if(!instance_exists(n) || point_distance(_fx, _fy, n.x, n.y) > (_spawnPed ? 128 : 64)){
				_num--;
				
				 // Main Loot:
				if(_spawnPed){
					_ped = false;
					
					for(var _ox = -32; _ox <= 32; _ox += 32){
						for(var _oy = -32; _oy <= 32; _oy += 32){
							array_push(layout, {
								x	: _fx + _ox,
								y	: _fy + _oy,
								obj	: Floor
							})
						}
					}
					
					array_push(layout, {
						x	: _fx + 16,
						y	: _fy + 8,
						obj	: "BuriedVaultPedestal"
					});
					
					_fx += lengthdir_x(_moveDis, _moveDir);
					_fy += lengthdir_y(_moveDis, _moveDir);
				}
				
				 // Floor:
				else{
					array_push(layout, {
						x	: _fx,
						y	: _fy,
						obj	: Floor
					});
					
					 // Torch:
					if(chance(1, 8)){
						array_push(layout, {
							x	: _fx + 16,
							y	: _fy + 16,
							obj	: Torch
						});
					}
				}
				
				 // Turn:
				_dir += orandom(60);
			}
			else _dir = direction;
		}
		
		return id;
	}
	
#define BuriedVault_step
	if(floor_num != instance_number(Floor)){
		floor_num = instance_number(Floor);
		
		 // Check if Vault Uncovered:
		var	_open = false,
			_sx = (bbox_left + bbox_right + 1) / 2,
			_sy = (bbox_top + bbox_bottom + 1) / 2;
			
		if(place_meeting(x, y, Floor)){
			_open = true;
			with(instance_create(x, y, PortalClear)){
				mask_index = other.mask_index;
				image_xscale = other.image_xscale;
				image_yscale = other.image_yscale;
			}
		}
		with(layout) if(!_open && obj == Floor){
			var	_x = x,
				_y = y;
				
			with(other) if(collision_rectangle(_x - 1, _y - 1, _x + 32, _y + 32, Wall, false, false)){
				_open = true;
				_sx = _x;
				_sy = _y;
			}
		}
		
		 // Uncovered:
		if(_open){
			var _areaCurrent = GameCont.area;
			GameCont.area = area;
			
			 // Clear Obstructions:
			with(layout) if(obj == Floor){
				with(instance_rectangle_bbox(x - 1, y - 1, x + 32, y + 32, [Wall, Floor, TopSmall, TopPot])){
					instance_destroy();
				}
			}
			
			 // Generate:
			var	_minID = instance_create(0, 0, GameObject);
			instance_delete(_minID);
			with(layout) obj_create(x, y, obj);
			
			 // Wallerize:
			with(instances_matching_gt(Floor, "id", _minID)){
				scrFloorWalls();
			}
			with(instances_matching_gt(Wall, "id", _minID)){
				GameCont.area = (chance(1, 2) ? other.area : _areaCurrent);
				instance_create(x,      y,      Top);
				instance_create(x - 16, y,      Top);
				instance_create(x,      y - 16, Top);
				instance_create(x - 16, y - 16, Top);
			}
			
			 // Cool Reveal:
			view_shake_at(_sx, _sy, 20);
			sound_play_pitchvol(sndStatueCharge, 1.6 + orandom(0.2), 1);
			sound_play_pitchvol(sndStatueDead, 0.4 + random(0.1), 1);
			with(floor_reveal(instances_matching_gt([Floor, Wall, TopSmall], "id", _minID), 4)){
				time = (point_distance(inst.x, inst.y, _sx, _sy) - 16) / 4;
			}
			
			GameCont.area = _areaCurrent;
			instance_destroy();
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
							_xsc *= 1.25;
							_ysc *= 1.25;
							_ang = 0;
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


#define Harpoon_create(_x, _y)
    with(instance_create(_x, _y, CustomProjectile)){
         // Visual:
        sprite_index = spr.Harpoon;
        image_speed = 0;

         // Vars:
        mask_index = mskBolt;
    	creator = noone;
    	target = noone;
    	setup = true;
    	damage = 8;
    	force = 8;
    	typ = 1;
    	rope = [];
    	corpses = [];
    	pickup = false;

    	return id;
    }

#define Harpoon_setup
	setup = false;
	
	 // Facing:
	if(hspeed != 0) image_yscale *= sign(hspeed);

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
            with(instances_meeting(x, y, instances_matching_ne(instances_matching_gt(Corpse, "speed", 1), "mask_index", -1))){
            	if(place_meeting(x, y, other)){
            		var c = id;
            		with(other){
	            		if(array_find_index(corpses, c) < 0){
            				if(sprite_get_width(c.sprite_index) < 64 && sprite_get_height(c.sprite_index) < 64){
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
	if(setup) Harpoon_setup();
	
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
        typ = 0;

         // Deteriorate Rope if Both Harpoons Stuck:
        if(array_length(rope) > 0){
        	with(rope){
	        	if(harpoon_stuck && array_length(instances_matching_ne([link1, link2], "object_index", CustomProjectile)) <= 0){
	        		broken = -1;
	        	}
	        	harpoon_stuck = true;
        	}
        }
        
         // Not Roped:
        else{
        	pickup = true;
        	instance_destroy();
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
    		
            image_angle = direction;

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
        if(num > 0 && position_meeting(x, y, (small ? SmallChestPickup : ChestOpen))){
	        var t = instances_matching(Player, "race", "parrot");
	        
	         // Pickup Feathers go to Nearest Parrot:
	        if(small && !place_meeting(x, y, Portal)){
	        	t = instance_nearest(x, y, Player);
	        	if(instance_exists(t) && t.race != "parrot"){
	        		t = noone;
	        	}
	        }

        	 // Feathers:
            with(t){
            	for(var i = 0; i < other.num; i++){
	                with(obj_create(other.x, other.y, "ParrotFeather")){
	                	sprite_index = other.spr_feather;
	                    bskin = other.bskin;
	                    index = other.index;
	                    creator = other;
	                    target = other;
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

        instance_destroy();
    }


#define ParrotFeather_create(_x, _y)
    with(instance_create(_x, _y, CustomObject)){
         // Visual:
        sprite_index = spr.Parrot[0].Feather;
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

						 // Parrot's Special Stat:
						if("ntte_charm" not in target){
							var _race = variable_instance_get(creator, "race", char_random);
							if(_race == "parrot"){
								var _stat = "race/" + _race + "/spec";
								stat_set(_stat, stat_get(_stat) + 1);
							}
						}

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
        		depth = -8;
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
        depth = ((!position_meeting(x, y, Floor) && !in_sight(other.creator)) ? -6.01 : 0);
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
        spr_icon = -1;
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
        walkspeed = 2;
        maxspeed = 3;
        revive_delay = 0;
    	stat_found = true;
        stat = {};
        light = true;
        light_radius = [32, 96]; // [Inner, Outer]
        mask_store = null;
        portal_angle = 0;
        my_portalguy = noone;
    	my_corpse = noone;
        pickup_indicator = scrPickupIndicator("");
        with(pickup_indicator){
        	mask_index = mskShield;
        	creator_visible_follow = false;
        }

         // Scripts:
        pet = "";
        mod_type = "none";
        mod_name = "none";

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
    wave += current_time_scale;

	 // Don't Persist to Menu:
    if(instance_exists(Menu)){
    	instance_delete(id);
    	exit;
    }

	 // Reset Hitbox:
    if(mask_index == mskNone && mask_store != null){
    	mask_index = mask_store;
    	mask_store = null;
    }

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
	        	if(place_meeting(x, y, leader)){
		            with(leader){
		                with(other) projectile_hit_raw(other, 1, true);
		                lasthit = [sprHealBigFX, "LOVE"];
		            }
		            
		            my_health = maxhealth;
		            sprite_index = spr_hurt;
		            image_index = 0;
		            
					sound_play_hit_ext(snd_hurt, 1.1 + random(0.2), 0.8);
	
		             // Effects:
		            with(instance_create(x, y, HealFX)) depth = other.depth - 1;
		            sound_play(sndHealthChestBig);
	        	}
	        }
	    }
	}

     // Player Owns Pet:
    var	_pickup = pickup_indicator,
        _spin = 0;
        
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

        if(visible && can_path && !_targetSeen){
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
        if(visible || (maxhealth > 0 && my_health <= 0)){
        	 // Portal Attraction:
        	with(Portal) if(point_distance(x, y, other.x, other.y) < 64 || (object_index == BigPortal && timer > 30)){
        		if(in_sight(other)){
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
        	}

			 // Enter:
            if(place_meeting(x, y, Portal)){
                visible = false;
                my_health = maxhealth;
                repeat(3) instance_create(x, y, Dust);
            }
        }
        
         // Breadcrumbs:
		if(array_length(path) > 2 && (wave % 90) < 60 && chance_ct(1, 15 / maxspeed)){
		    var	i = round((wave / 10) % array_length(path)),
				_x1 = ((i > 0) ? path[i - 1, 0] : x),
				_y1 = ((i > 0) ? path[i - 1, 1] : y),
				_x2 = ((i < array_length(path)) ? path[i, 0] : leader.x),
				_y2 = ((i < array_length(path)) ? path[i, 1] : leader.y);
				
			with(instance_create(lerp(_x1, _x2, random(1)) + orandom(4), lerp(_y1, _y2, random(1)) + orandom(4), Dust)){
				motion_set(point_direction(x, y, _x2, _y2) + orandom(20), min(random_range(1, 5), point_distance(x, y, _x2, _y2) / 3));
			}
		}

         // Time Stat:
        if(instance_is(leader, Player)){
        	stat.owned += (current_time_scale / 30);
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
                        
                         // Effects:
                        with(instance_create(x + hspeed, y + vspeed, HealFX)){
                        	sprite_index = spr.PetLost;
                        	image_xscale = choose(-1, 1);
                        	image_speed = 0.5;
                        	friction = 1/8;
                        	depth = -8;
                        }
                    }
                    ntte_pet = array_delete(ntte_pet, 0);

                     // Add New Pet:
                    array_push(ntte_pet, other);
                    with(other){
                    	leader = other;
                    	direction = point_direction(x, y, other.x, other.y);

	                     // Found Stat:
	                    if(stat_found){
	                    	stat_found = false;
	                    	stat.found++;
	                    }
                    }

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
    with(_pickup){
    	visible = (other.can_take && (other.visible || (other.maxhealth > 0 && other.my_health <= 0)));
    }
    
     // Portal Spin:
	if(_spin != 0){
		portal_angle = (portal_angle + 360 + _spin) % 360;
		sprite_index = spr_hurt;
		image_index = 1;

		 // No Escape:
		speed -= min(speed, friction_raw * 3);
		walk = 0;
	}
    else if(portal_angle != 0){
    	portal_angle += angle_difference(0, portal_angle) * 0.2 * current_time_scale;
    }
    
     // Going to New Level:
    if(instance_exists(GenCont) || instance_exists(LevCont)){
    	visible = false;
    	
    	 // Reset Stuff:
        portal_angle = 0;
        my_health = maxhealth;
        
         // Follow Player:
        var _inst = (instance_exists(leader) ? leader : instance_nearest(x, y, Player));
        if(instance_exists(_inst)){
	        x = _inst.x + orandom(16);
	        y = _inst.y + orandom(16);
        }
    }

	if(visible || (maxhealth > 0 && my_health <= 0)){
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
    if(visible || (maxhealth > 0 && my_health <= 0)){
	    with(path_wall) with(other){
		    var _wall = other;
		    
	    	if(place_meeting(x, y, _wall)){
		    	x = xprevious;
		    	y = yprevious;
		        if(place_meeting(x + hspeed_raw, y, _wall)) hspeed_raw = 0;
		        if(place_meeting(x, y + vspeed_raw, _wall)) vspeed_raw = 0;
		        x += hspeed_raw;
		        y += vspeed_raw;
	    	}
        
	         // Just in Case:
	        if(place_meeting(x, y, _wall)){
	        	speed = 0;
	        	
	        	var _goal = [],
	        		_disMax = 96;
	        		
	        	with(instance_rectangle_bbox(x - _disMax, y - _disMax, x + _disMax, y + _disMax, Floor)){
	        		for(var _x = bbox_left; _x < bbox_right + 1; _x += 8){
	        			for(var _y = bbox_top; _y < bbox_bottom + 1; _y += 8){
			        		var _dis = point_distance(other.x, other.y, _x, _y);
			    			if(_dis < _disMax){
			    				with(other) if(!place_meeting(_x, _y, _wall)){
			        				_disMax = _dis;
			        				_goal = [_x, _y];
			    				}
			    			}
	        			}
	        		}
	        	}
	        	
	        	 // Reach Nearest Open Floor:
	        	if(array_length(_goal) >= 2){
	        		while(place_meeting(x, y, _wall)){
	        			x = lerp(x, _goal[0], 0.01);
	        			y = lerp(y, _goal[1], 0.01);
	        		}
	        	}
	        }
	    }
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
		_alp = image_alpha * ((maxhealth > 0 && my_health <= 0) ? 0.4 : 1);

     // Outline Setup:
    var _outline = (
    	instance_exists(leader)									&&
    	(maxhealth <= 0 || my_health > 0)						&&
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
		depth = 0; // Priority (0==WepPickup)
        pick = -1;
        text = "";
        xoff = 0;
        yoff = 0;
        creator_visible_follow = true;
        
         // Events:
        on_meet = ["", "", ""];

        return id;
    }

#define PickupIndicator_begin_step
    with(nearwep) instance_delete(id);

#define PickupIndicator_end_step
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

#define PickupIndicator_cleanup
    with(nearwep) instance_delete(id);


#define PortalGuardian_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle      = spr.PortalGuardianIdle;
		spr_walk      = spr.PortalGuardianIdle;
		spr_hurt      = spr.PortalGuardianHurt;
		spr_dead      = spr.PortalGuardianDead;
		spr_appear    = spr.PortalGuardianAppear;
		spr_disappear = spr.PortalGuardianDisappear;
		spr_shadow = shd24;
		hitid = [spr_idle, "PORTAL GUARDIAN"];
		depth = -2;
		
		 // Sound:
		snd_hurt = sndExploGuardianHurt;
		snd_dead = sndDogGuardianDead;
		snd_mele = sndGuardianFire;
		
		 // Vars:
		mask_index = mskBandit;
		maxhealth = 45;
		raddrop = 16;
		meleedamage = 2;
		size = 2;
		walk = 0;
		walkspeed = 0.8;
		maxspeed = 4;
		
		 // Alarms:
		alarm1 = 40 + irandom(20);
		
		 // NTTE:
		ntte_anim = false;
		
		return id;
	}
	
#define PortalGuardian_step
	 // Hovery:
	if(array_length(instances_meeting(x, y, instances_matching(projectile, "creator", id))) <= 0){
		speed = max(1, speed);
	}
	
	 // Animate:
	if(sprite_index == spr_appear){
		speed = 0;
		
		if(anim_end){
			image_index = 0;
			sprite_index = spr_idle;
			
			 // Effects:
			repeat(8) scrFX(x, y, 3, Dust);
			repeat(3){
				with(instance_create(x + orandom(16), y + orandom(16), PortalL)){
					depth = other.depth - 1;
				}
			}
			sound_play_hit_ext(sndGuardianFire, 1.5 + orandom(0.2), 2);
		}
	}
	else if((sprite_index != spr_disappear && sprite_index != spr_hurt) || anim_end){
		if(speed <= 0) sprite_index = spr_idle;
		else sprite_index = spr_walk;
	}
	
	 // FX:
	if(chance_ct(1, 30)){
		with(instance_create(x + hspeed_raw, y + vspeed_raw, PortalL)){
			depth = other.depth + choose(0, -1);
		}
	}
	
#define PortalGuardian_alrm1
	alarm1 = 30 + random(30);
	
	target = instance_nearest(x, y, Player);
	
	if(instance_exists(target)){
		var _targetDir = point_direction(x, y, target.x, target.y);
		
		if(in_sight(target)){
			 // Attack:
			if(chance(2, 3) && array_length(instances_matching(projectile, "creator", id)) <= 0){
				scrEnemyShoot("PortalGuardianBall", _targetDir, 6);
				scrRight(_targetDir);
				
				 // Sound:
				sound_play_pitchvol(sndPortalOld, 2 + random(2), 1.5);
			}
			
			 // Move:
			else{
				scrWalk(20 + random(20), _targetDir + (random_range(60, 100) * choose(-1, 1)));
				
				 // Away From Target:
				if(in_distance(target, 128)){
					direction = _targetDir + 180 + orandom(30);
				}
			}
		}
		
		 // Wander:
		else{
			scrWalk(10 + random(10), _targetDir + orandom(40));
		}
	}
	
	 // Wander:
	else{
		scrWalk(30, random(360));
	}
	
#define PortalGuardian_death
	with(instance_create(x, y, PortalClear)){
		image_xscale = 2/3;
		image_yscale = image_xscale;
	}
	
	 // Pickups:
	pickup_drop(40, 10);


#define PortalGuardianBall_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		spr_spwn = spr.PortalGuardianBallSpawn;
		spr_idle = spr.PortalGuardianBall;
		sprite_index = spr_spwn;
		image_speed = 0.4;
		depth = -3;
		
		 // Vars:
		mask_index = mskNone;
		damage = 2;
		force = 0;
		typ = 1;
		creator = noone;
		
		return id;
	}
	
#define PortalGuardianBall_anim
	 // Fire:
	if(sprite_index == spr_spwn){
		sprite_index = spr_idle;
		mask_index = mskSuperFlakBullet;
		
		 // FX:
		sound_play_pitch(sndGuardianHurt, 1.5 + orandom(0.2));
		repeat(5) scrFX(x, y, [direction + orandom(60), 3], Dust);
	}
	
#define PortalGuardianBall_step
	 // Spawning:
	if(sprite_index == spr_spwn){
		if(instance_exists(creator)){
			var	l = 4,
				d = direction;
				
			x = creator.x + lengthdir_x(l, d);
			y = creator.y + lengthdir_y(l, d);
		}
		else{
			x -= hspeed_raw;
			y -= vspeed_raw;
		}
	}
	
	 // FX:
	if(chance_ct(1, 15)){
		with(instance_create(x + hspeed_raw, y + vspeed_raw, PortalL)){
			depth = other.depth + choose(0, -1);
		}
	}
	
#define PortalGuardianBall_hit
	if(projectile_canhit(other) && !instance_is(other, prop) && other.team != 0){
		projectile_hit_push(other, damage, force);
		
		 // Swap Positions:
		if(instance_exists(creator) && instance_exists(other)){
			if(!instance_is(other, prop) && other.team != 0 && other.size < 6){
				with(other){
					x = other.creator.x;
					y = other.creator.y;
					xprevious = x;
					yprevious = y;
					
					 // Effects:
					with(instance_create(x, y, BulletHit)){
						sprite_index = sprPortalDisappear;
						depth = other.depth - 1;
						image_angle = 0;
					}
					repeat(3) scrFX(x, y, 2, Smoke);
					sound_play_hit_ext(sndPortalAppear, 2.5, 1);
					
					 // Just in Case:
					with(instance_create(x, y, PortalClear)){
						mask_index = other.mask_index;
						sprite_index = other.sprite_index;
						image_xscale = other.image_xscale;
						image_yscale = other.image_yscale;
						image_angle = other.image_angle;
					}
				}
			}
		}
		
		instance_destroy();
	}
	
#define PortalGuardianBall_destroy
	repeat(5) scrFX(x, y, [direction, 2], Smoke);
	sound_play_hit_ext(sndGuardianDisappear, 2, 1);
	
	 // Teleport:
	if(instance_exists(creator)) with(creator){
		 // Disappear:
		with(instance_create(x, y, BulletHit)){
			sprite_index = other.spr_disappear;
			image_xscale = other.image_xscale * other.right;
			image_yscale = other.image_yscale;
			image_angle = other.image_angle;
			depth = other.depth - 1;
		}
		
		 // Move:
		x = other.x;
		y = other.y;
		xprevious = x;
		yprevious = y;
		
		 // Unwall:
		if(place_meeting(x, y, Wall)){
			var	_tx = x,
				_ty = y,
				_disMax = 16;
				
			with(instance_rectangle_bbox(x - _disMax, y - _disMax, x + _disMax, y + _disMax, Floor)){
				for(var _x = bbox_left; _x <= bbox_right + 1; _x += 4){
					for(var _y = bbox_top; _y <= bbox_bottom + 1; _y += 4){
						var _dis = point_distance(_x, _y, _tx, _ty);
						if(_dis < _disMax){
							with(other) if(!place_meeting(_x, _y, Wall)){
								_tx = _x;
								_ty = _y;
								_disMax = _dis;
							}
						}
					}
				}
			}
			
			x = _tx;
			y = _ty;
		}
		
		 // Appear:
		image_index = 0;
		sprite_index = spr_appear;
		sound_play_hit_ext(sndPortalAppear, 3, 1);
	}
	
	 // Creator Dead:
	else with(instance_create(x, y, BulletHit)){
		sprite_index = sprPortalDisappear;
		image_xscale = 0.7;
		image_yscale = image_xscale;
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
        team = -1;
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

    with(instances_matching_ne(instances_matching_ne(hitme, "team", team), "mask_index", mskNone, sprVoid)){
        if(distance_to_point(other.x, other.y) < _maxDist && in_sight(other)){
        	if(_teamPriority == null || team > _teamPriority){
        		_teamPriority = team;
        		target = [];
        	}

            array_push(_target, id);
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
	        var _xdis = creator_offx - (variable_instance_get(creator, (roids ? "bwkick" : "wkick"), 0) / 3),
	            _xdir = (("gunangle" in creator) ? creator.gunangle : direction),
	            _ydis = creator_offy * variable_instance_get(creator, "right", 1),
	            _ydir = _xdir - 90;
	            
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
				var _inst = lightning_connect(other.x, other.y, _tx, _ty, (point_distance(other.x, other.y, _tx, _ty) / 4) * sin(other.wave / 90), false);
				if(_bat) with(_inst) sprite_index = spr.BatLightning;
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
        var _kick = (roids ? "bwkick" : "wkick");
        if(_kick in creator){
        	variable_instance_set(creator, _kick, 3);
        }
        
         // Death Timer:
        if(time > 0){
        	time -= current_time_scale;
			if(time <= 0) instance_destroy();
        }
    }
    else instance_destroy();

#define TeslaCoil_end_step
	if(bat && instance_is(creator, hitme)){
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


#define TopChest_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		spr_shadow = -1;
		spr_shadow_x = 0;
		spr_shadow_y = 0;
		depth = depth_top;
		
		 // Vars:
	    mask_index = msk.TopProp;
		target = noone;
		target_save = {};
		target_x = x;
		target_y = y;
		z = 8;
		zspeed = 0;
		zfriction = 0;
		grav = 0.8;
		jump = grav + 0.4;
		wobble = 0;
		
		 // Away From Floors:
		var	_dis = 8,
			_dir = random(360);
			
		with(instance_nearest(x - 16, y - 16, Floor)){
			_dir = point_direction((bbox_left + bbox_right + 1) / 2, (bbox_top + bbox_bottom + 1) / 2, other.x, other.y);
		}
		
		while(
			distance_to_object(Floor)			< _dis		||
			distance_to_object(PortalClear)		< _dis + 16	||
			distance_to_object(Bones)			< 16		||
			distance_to_object(TopPot)			< 8			||
			distance_to_object(CustomObject)	< 8
		){
			var l = 4;
			x += lengthdir_x(l, _dir);
			y += lengthdir_y(l, _dir);
		}
		
		
		for(var _x = x - 24; _x < x + 24; _x += 16){
			for(var _y = y - 8; _y < y + 24; _y += 16){
				if(chance(4, 5)){
					var	_sx = floor(_x / 16) * 16,
						_sy = floor(_y / 16) * 16;
						
			        if(!position_meeting(_sx, _sy, Floor) && !position_meeting(_sx, _sy, Wall) && !position_meeting(_sx, _sy, TopSmall)){
			            instance_create(_sx, _sy, TopSmall);
			        }
				}
			}
		}
		
		target_x = x;
		target_y = y;
		
		return id;
	}

#define TopChest_end_step
	if(instance_exists(target)){
	    if(zspeed != 0) z += zspeed * current_time_scale;
	    
	     // Hold Chest:
	    var _save = target_save;
	    with(target){
	    	 // Move:
	    	if(x != xprevious || y != yprevious){
		    	other.x += (x - xprevious);
		    	other.y += (y - yprevious);
				other.depth = depth_top;
				depth = other.depth;
	    	}
	    	
	    	 // Follow Controller:
			x = other.x;
			y = other.y - other.z;
			other.target_x = x;
			other.target_y = y;
			
			 // Appear Above Walls:
			if(depth != other.depth){
				_save.depth = depth;
				depth = other.depth;
			}
			
			 // Disable Collision:
			if(mask_index != mskNone){
				_save.mask_index = mask_index;
				mask_index = mskNone;
			}
			
			 // Disable Shadow:
			if("spr_shadow" in self){
				if(spr_shadow != -1){
					_save.spr_shadow = spr_shadow;
					other.spr_shadow = spr_shadow;
	    			other.mask_index = spr_shadow;
	    			other.image_xscale = 0.5;
	    			other.image_yscale = 0.5;
					spr_shadow = -1;
				}
				other.spr_shadow_x = spr_shadow_x;
				other.spr_shadow_y = spr_shadow_y - 1;
			}
			/*else{
				other.spr_shadow = shd16;
				other.spr_shadow_y = -1;
			}*/
	    }
	    
	     // Check Collision:
	    if(zfriction == 0){
	    	if(place_meeting(x, y, Floor)){
	    		if(!place_meeting(x, y, Wall)){
		    		zfriction = grav;
		    		zspeed = jump;
	    		}
	    		
	    		 // Wobble:
	    		var	_wobWest = position_meeting(x - 4, y, Floor),
	    			_wobEast = position_meeting(x + 4, y, Floor);
	    			
	    		if(_wobWest || _wobEast){
	    			var _wobMove = ((_wobWest - _wobEast) - wobble) * 0.1 * current_time_scale;
	    			wobble += _wobMove;
	    			
	    			with(target){
	    				image_angle += 8 * _wobMove;
	    				image_angle += 0.5 * sin(current_frame / 10) * other.wobble;
	    			}
	    		}
	    	}
	    	else if(wobble != 0){
	    		wobble -= wobble * 0.5 * current_time_scale;
	    		with(target) image_angle -= image_angle * 0.5 * current_time_scale;
	    		
	    		if(abs(wobble) < 0.5){
	    			wobble = 0;
	    			with(target) image_angle = 0;
	    		}
	    	}
	    }
	    
	     // Falling:
	    else{
	    	zspeed -= zfriction * current_time_scale;
	    	
	    	 // Depth:
			if(z < 8){
				if(z >= 0){
					if(!collision_rectangle(bbox_left + 4, bbox_top + 8 - z, bbox_right - 4, bbox_bottom - z, Wall, false, false)){
						target.depth = min(-1, lq_defget(target_save, "depth", 0));
					}
				}
				else depth = max(12, depth);
			}
			
			 // Landing:
			if(z <= 0){
				if(!instance_exists(NothingSpiral)) instance_destroy();
				
				 // Abyss Time:
				else if(!point_seen(x, bbox_top - z, -1)){
					with(target) instance_delete(id);
					instance_delete(id);
				}
			}
	    }
	}
	
	else{
		 // Grab Chest (In case it was replaced or something):
		with(instances_matching(instances_matching_gt(instances_matching_gt(instances_matching(instances_matching([chestprop, Pickup, RadChest], "xstart", target_x), "ystart", target_y), "id", id), "id", target), "topchest_grab", null)){
			topchest_grab = true;
			
			 // No softlock:
			if(instance_is(self, RadMaggotChest)){
				instance_delete(id);
				with(other) instance_delete(id);
			}
			
			else{
				other.target = id;
				other.target_save = {};
				with(other) TopChest_end_step();
			}
			
			exit;
		}
		
		 // Time to die:
		instance_destroy();
	}

#define TopChest_destroy
	with(target){
		x = other.x;
		y = other.y;
		image_angle = 0;
		for(var i = 0; i < lq_size(other.target_save); i++){
			variable_instance_set(id, lq_get_key(other.target_save, i), lq_get_value(other.target_save, i));
		}
		
		 // Clear Walls:
		with(instance_create(x, y, PortalClear)){
			sprite_index = other.sprite_index;
			mask_index = other.mask_index;
			image_xscale = other.image_xscale;
			image_yscale = other.image_yscale;
			image_angle = other.image_angle;
		}
		
		 // Effects:
		var _num = abs(sprite_width * random_range(0.5, 1));
		for(var d = direction; d < direction + 360; d += (360 / _num)){
			var _obj = (chance(1, 8) ? Debris : Dust);
			with(instance_create(x, y, Dust)){
				motion_add(d + orandom(20), random_range(2, 5));
				depth = max(depth, other.depth);
			}
		}
		view_shake_max_at(x, y, 6);
		
		 // Sounds:
		if(!instance_is(self, Pickup) && !area_get_underwater(GameCont.area)){
			sound_play_hit_ext(sndWeaponChest, 0.5 + random(0.2), 0.8);
		}
	}


#define TopEnemy_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		spr_idle = -1;
		spr_walk = -1;
		spr_weap = -1;
		spr_shadow = -1;
		spr_shadow_x = -1;
		spr_shadow_y = -1;
		sprite_index = -1;
		image_speed = 0.4;
		depth = depth_top;
		
		 // Vars:
		mask_index = -1;
		object = { object_index : Bandit };
		z = 8;
		zspeed = 0;
		zfriction = 0;
		jump = random_range(3, 5);
		jump_x = x;
		jump_y = y;
		grav = 0.8;
		walk = 0;
		walkspeed = -1;
		maxspeed = -1;
		gunangle = -1;
		wepangle = -1;
		wkick = 0;
		right = choose(-1, 1);
		wander_chance = 1/6;
		wander_walk = [5, 20];
		spawn_dis = -1;
		spawn_dir = -1;
		is_enemy = false;
		is_prop = false;
		setup = true;
		
		 // Alarms:
		alarm0 = 90 + random(90);
		alarm1 = -1;

		return id;
	}
	
#define TopEnemy_setup
	setup = false;
	
	 // Object Vars:
	var _obj = obj_create(x, y - z, lq_defget(object, "object_index", -1));
	if(is_real(_obj) && instance_exists(_obj)){
		is_enemy = instance_is(_obj, enemy);
		is_prop = instance_is(_obj, prop);
		with(variable_instance_get_names(_obj)){
			if(self not in other.object){
				lq_set(other.object, self, variable_instance_get(_obj, self));
			}
		}
		instance_delete(_obj);
	}
	else{
		instance_destroy();
		exit;
	}
	
	 // Grab Sprites/Vars:
	var _grab = ["sprite_index", "spr_idle", "spr_walk", "spr_weap", "spr_shadow", "spr_shadow_x", "spr_shadow_y", "gunangle", "wepangle", "maxspeed", "walkspeed"];
	for(var i = 0; i < lq_size(object); i++){
		var k = lq_get_key(object, i);
		if(k != "spr_walk" || !is_prop){
			if(string_pos("image_", k) == 1 || (array_exists(_grab, k) && variable_instance_get(id, k, -1) == -1)){
				if(!array_exists(["id", "object_index", "bbox_bottom", "bbox_top", "bbox_right", "bbox_left", "image_number", "sprite_yoffset", "sprite_xoffset", "sprite_height", "sprite_width", "speed_raw", "hspeed_raw", "vspeed_raw", "friction_raw", "image_speed_raw"], k)){
					variable_instance_set(id, k, lq_get(object, k));
				}
			}
		}
	}
	
	 // Visual:
	image_alpha = -abs(image_alpha);
	if(spr_walk == -1) spr_walk = (is_prop ? lq_defget(object, "spr_hurt", spr_idle) : spr_idle);
	if(spr_weap == -1 && "gunspr" in object) spr_weap = object.gunspr;
	if(alarm1 > 0) alarm1 = max(alarm1, (image_number / image_speed));
	if(sprite_index == spr_idle && image_index == 0) image_index = random(sprite_get_number(image_number - 1));
	
	 // Misc:
	speed = max(speed, 0);
	if(mask_index == -1) mask_index = (is_prop ? msk.TopProp : mskBandit);
	if(maxspeed  == -1) maxspeed = (is_prop ? 0 : random_range(3.6, 4));
	if(walkspeed == -1) walkspeed= (is_prop ? 0 : 0.8);
	if(gunangle  == -1) gunangle = random(360);
	if(wepangle  == -1) wepangle = 0;
	if(!is_prop) scrRight(gunangle);
	else{
		alarm0 = -1;
		right = 1;
	}
	
	 // Push Away From Floors:
	if(spawn_dir == -1){
		with(instance_nearest(x - 16, y - 16, Floor)){
			other.spawn_dir = point_direction((bbox_left + bbox_right + 1) / 2, (bbox_top + bbox_bottom + 1) / 2, other.x, other.y);
		}
	}
	if(spawn_dis == -1) spawn_dis = (is_prop ? 4 : 16);
	if(spawn_dis > 0){
		while(
			chance(1, 3)											||
			distance_to_object(Floor)			< spawn_dis			||
			distance_to_object(PortalClear)		< spawn_dis + 16	||
			distance_to_object(Bones)			< 16				||
			distance_to_object(TopPot)			< 8					||
			distance_to_object(CustomObject)	< 8
		){
			var l = random_range(4, 16);
			x += lengthdir_x(l, spawn_dir);
			y += lengthdir_y(l, spawn_dir);
		}
	}
	
	 // Underwater Time:
	if(area_get_underwater(GameCont.area)){
		jump /= 6;
		grav /= 4;
	}
	
	 // Insta-Land:
	if((place_meeting(x, y, Floor) && !place_meeting(x, y, Wall)) || (in_sight(Player) && !instance_exists(NothingSpiral))){
		instance_destroy();
		exit;
	}
	
	 // TopSmalls:
	if(is_prop){
		var m = mask_index;
		mask_index = -1;
		for(var _x = bbox_left - 8; _x < bbox_right + 1 + 8; _x += 16){
			for(var _y = y - 8; _y < bbox_bottom + 1 + 8; _y += 16){
				if(chance(4, 5)){
					var	_sx = floor(_x / 16) * 16,
						_sy = floor(_y / 16) * 16;
						
			        if(!position_meeting(_sx, _sy, Floor) && !position_meeting(_sx, _sy, Wall) && !position_meeting(_sx, _sy, TopSmall)){
			            instance_create(_sx, _sy, TopSmall);
			        }
				}
			}
		}
		mask_index = m;
	}
	
	x = round(x);
	y = round(y);
	depth = depth_top;
	
#define TopEnemy_step
	if(setup){
		TopEnemy_setup();
		if(!instance_exists(self)) exit;
	}
	
	 // Animate:
	if(speed <= 0){
		if(sprite_index != spr_idle){
			if((zspeed == 0 && sprite_index == spr_walk) || anim_end){
				sprite_index = spr_idle;
				image_index = 0;
			}
		}
	}
	else{
		if(walk > 0) sprite_index = spr_walk;
		depth = depth_top;
	}

	 // Jumpin:
	if(zspeed != 0) z += zspeed * current_time_scale;

	 // On Walls:
	if(zfriction == 0){
		if(speed > 0){
			 // Friction:
			speed -= min(speed, 0.4 * current_time_scale);
			
			 // Trail:
			if(chance_ct(sqr(speed), 90)){
				var o = abs(sprite_width / 16);
				with(instance_create(x + orandom(o), y - z + o + random(o), Dust)){
					depth = other.depth + 0.1;
				}
			}
			
			 // Push Bros:
			if(place_meeting(x, y, object_index)){
				with(instances_meeting(x, y, instances_matching(object_index, "name", name))){
					if(place_meeting(x, y, other)) with(other){
						motion_add_ct(point_direction(other.x, other.y, x, y), walkspeed);
					}
				}
			}
		}
	}

	 // Landing:
	else{
	    zspeed -= zfriction * current_time_scale;
		mask_index = -1;
	    
	    if(speed > 0) sprite_index = spr_walk;
		
		 // Deptherize:
		if(z < 8){
			if(z >= 0){
				if(!collision_rectangle(bbox_left + 4, bbox_top + 8 - z, bbox_right - 4, bbox_bottom - z, Wall, false, false)){
					var o = lq_defget(object, "object_index", -1);
					depth = min(-1, (is_real(o) ? object_get_depth(o) : 0));
				}
			}
			else depth = max(12, depth);
		}
	    
	     // Trail:
		if(chance_ct(zfriction, 2)){
			var o = abs(sprite_width / 16);
			with(instance_create(x + orandom(o), y - z + o + random(o), Dust)){
				depth = other.depth + 0.1;
			}
		}

		 // We in:
		if(z <= 0){
			if(!instance_exists(NothingSpiral)) instance_destroy();
			
			 // Abyss Time:
			else if(!point_seen(x, bbox_top - z, -1)){
				instance_delete(id);
			}
		}
	}
	
#define TopEnemy_draw
	y -= z;
	image_alpha = abs(image_alpha);

	 // Weapon:
	var _back = (gunangle < 180),
		_drawWep = (spr_weap != -1);
		
	if(_drawWep && _back){
		draw_weapon(spr_weap, x, y, gunangle, wepangle, wkick, right, image_blend, image_alpha);
	}
	
	 // Self:
	image_xscale *= right;
	draw_self();
	image_xscale /= right;
	
	 // Weapon:
	if(_drawWep && !_back){
		draw_weapon(spr_weap, x, y, gunangle, wepangle, wkick, right, image_blend, image_alpha);
	}

	y += z;
	image_alpha *= -1;

#define TopEnemy_alrm0
	alarm0 = irandom_range(15, 90);
	
	 // Idle:
	if(zfriction == 0 && speed <= 0){
		 // Lookin:
		gunangle = random(360);
		if(instance_exists(Player)){
			var t = instance_nearest(x, y, Player);
			gunangle = point_direction(x, y, t.x, t.y) + orandom(5);
		}
		scrRight(gunangle);
		
		 // Cold:
		if(GameCont.area == 5 && chance(2, 3)){
			with(instance_create(x, y - z, Breath)){
				image_xscale = other.right;
				depth = other.depth - 1;
			}
		}
		
		 // Let's Roll:
		if(
			(chance(1, 10) && in_distance(Player, 192))
			||
			(instance_number(enemy) + array_length(instances_matching_gt(instances_matching(object_index, "name", name), "speed", 0))) < (10 * (1 + GameCont.loops) * (1 + (crown_current == crwn_blood)))
		){
			with(instances_matching(object_index, "name", name)){
				if(in_distance(other, 64) && lq_get(object, "object_index") == lq_get(other.object, "object_index")){
					alarm1 = random_range(10, 60);
				}
			}
		}
		
		 // Wander:
		else if(chance(wander_chance, 1)){
			walk = random_range(wander_walk[0], wander_walk[1]);
			direction = random(360);
		}
	}
	
#define TopEnemy_alrm1
	alarm1 = 10 + random(20);
	var _target = instance_nearest(x, y, Player);
	
	 // Travel to Player:
	if(zfriction == 0 && instance_exists(_target)){
		var _targetDir = point_direction(x, y, _target.x, _target.y);
		scrWalk(alarm1, _targetDir);
	}
	
#define TopEnemy_destroy
	if("object_index" in object){
		var o = obj_create(x, y, object.object_index);
		if(!instance_exists(o)) exit;
		
		if(speed > 0 && zfriction != 0 && point_distance(x, y, jump_x, jump_y) < 5 * speed){
			x = jump_x;
			y = jump_y;
		}
		
		 // Transfer Variables:
		for(var i = 0; i < lq_size(object); i++){
			var k = lq_get_key(object, i),
				v = lq_get_value(object, i);
				
			if(!array_exists(["id", "object_index", "bbox_bottom", "bbox_top", "bbox_right", "bbox_left", "image_number", "sprite_yoffset", "sprite_xoffset", "sprite_height", "sprite_width"], k)){
				if(string_pos("Custom", object_get_name(o.object_index)) != 1 || string_pos("on_", k) != 1 || !is_undefined(v)){
					variable_instance_set(o, k, v);
				}
			}
		}
		with(["x", "y", "xstart", "ystart", "direction", "speed", "walk", "right", "gunangle", "sprite_index"]){
			var n = self;
			variable_instance_set(o, n, variable_instance_get(other, n));
		}
		with(o){
			xprevious = x;
			yprevious = y;
		}
		
		 // Not today, Walls:
		with(instance_create(x, y, PortalClear)){
			sprite_index = o.sprite_index;
			mask_index = o.mask_index;
			image_xscale = o.image_xscale;
			image_yscale = o.image_yscale;
			image_angle = o.image_angle;
		}
		
		 // Insta-Die (specifically to fix walltop bonepile bone drop):
		if(variable_instance_get(o, "my_health", 1) <= 0){
			with(o) event_perform(ev_step, ev_step_begin);
		}
		
		 // Effects:
		else{
			var _num = 6 + irandom(2);
			for(var d = direction; d < direction + 360; d += (360 / _num)){
				var _obj = (chance(1, 8) ? Debris : Dust);
				with(instance_create(x, y, Dust)){
					motion_add(d + orandom(20), random_range(2, 4));
					hspeed += other.hspeed / 2;
					vspeed += other.vspeed / 2;
					depth = max(depth, o.depth);
				}
			}
		}
		view_shake_max_at(x, y, 6);
		sleep(12);
		
		 // Sounds:
		if(!area_get_underwater(GameCont.area)){
			sound_play_hit_ext(sndAssassinHit, 1 + orandom(0.3), abs(zspeed) / 8);
		}
	}
	

#define UnlockCont_create(_x, _y)
    with(instance_create(_x, _y, CustomObject)){
         // Visual:
        depth = UberCont.depth - 1;

         // Vars:
        persistent = true;
        unlock = [];
        unlock_sprit = sprMutationSplat;
        unlock_image = 0;
        unlock_delay = 50;
        unlock_index = 0;
        unlock_porty = 0;
        unlock_delay_continue = 0;
        splash_sprit = sprUnlockPopupSplat;
        splash_image = 0;
        splash_delay = 0;
        splash_index = -1;
        splash_texty = 0;
        splash_timer = 0;
        splash_timer_max = 150;
        
        return id;
    }

#define UnlockCont_step
    if(instance_exists(Menu)){
        instance_destroy();
        exit;
    }
    
    depth = UberCont.depth - 1;

     // Animate Corner Popup:
    if(splash_delay > 0) splash_delay -= current_time_scale;
    else{
	    var _img = 0;
	    if(instance_exists(Player)){
	        if(splash_timer > 0){
	            splash_timer -= current_time_scale;
	    
	            _img = sprite_get_number(splash_sprit) - 1;
	    
	             // Text Offset:
	            if(splash_image >= _img && splash_texty > 0){
	                splash_texty -= current_time_scale;
	            }
	        }
	        else{
	            splash_texty = 2;
	    
	             // Splash Next Unlock:
	            if(splash_index < array_length(unlock) - 1){
	                splash_index++;
	                splash_timer = splash_timer_max;
	            }
	        }
	    }
	    splash_image += clamp(_img - splash_image, -1, 1) * current_time_scale;
	}

     // Game Over Splash:
    if(instance_exists(UnlockScreen)) unlock_delay = 1;
    else if(!instance_exists(Player)){
        while(
            unlock_index >= 0                   &&
            unlock_index < array_length(unlock) &&
            unlock[unlock_index].spr == -1
        ){
            unlock_index++; // No Game Over Splash
        }

        if(unlock_index < array_length(unlock)){
             // Disable Game Over Screen:
            with(GameOverButton){
                if(game_letterbox) alarm_set(0, 30);
                else instance_destroy();
            }
            with(TopCont){
                gameoversplat = 0;
                go_addy1 = 9999;
                dead = false;
            }
    
             // Delay Unlocks:
            if(unlock_delay > 0){
                unlock_delay -= current_time_scale;
                var _delayOver = (unlock_delay <= 0);
    
                unlock_delay_continue = 20;
                unlock_porty = 0;
    
                 // Screen Dim + Letterbox:
                with(TopCont){
                    visible = _delayOver;
                    if(darkness){
                       visible = true;
                       darkness = 2;
                    }
                }
                game_letterbox = _delayOver;
    
                 // Sound:
                if(_delayOver){
                    sound_play(sndCharUnlock);
                    sound_play(unlock[unlock_index].snd);
                }
            }
            else{
                 // Animate Unlock Splash:
                var _img = sprite_get_number(unlock_sprit) - 1;
                unlock_image += clamp(_img - unlock_image, -1, 1) * current_time_scale;
    
                 // Portrait Offset:
                if(unlock_porty < 3){
                    unlock_porty += current_time_scale;
                }
    
                 // Next Unlock:
                if(unlock_delay_continue > 0) unlock_delay_continue -= current_time_scale;
                else for(var i = 0; i < maxp; i++){
                    if(button_pressed(i, "fire") || button_pressed(i, "okay")){
                        if(unlock_index < array_length(unlock)){
                            unlock_index++;
                            unlock_delay = 1;
                        }
                        break;
                    }
                }
            }
        }

         // Done:
        else{
            with(TopCont){
                go_addy1 = 55;
                dead = true;
            }
            instance_destroy();
        }
    }

#define UnlockCont_draw
    draw_set_projection(0);

     // Game Over Splash:
    if(unlock_delay <= 0){
        if(unlock_image > 0){
            var _unlock = unlock[unlock_index],
                _nam = _unlock.nam[1],
                _spr = _unlock.spr,
                _img = _unlock.img,
                _x = game_width / 2,
                _y = game_height - 20;

             // Unlock Portrait:
            var _px = _x - 60,
                _py = _y + 9 + unlock_porty;

            draw_sprite(_spr, _img, _px, _py);

             // Splash:
            draw_sprite(unlock_sprit, unlock_image, _x, _y);

             // Unlock Name:
            var _tx = _x,
                _ty = _y - 92 + (unlock_porty < 2);

            draw_set_font(fntBigName);
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);

            var t = string_upper(_nam);
            draw_text_nt(_tx, _ty, t);

             // Unlocked!
            _ty += string_height(t) + 3;
            if(unlock_porty >= 3){
                d3d_set_fog(1, 0, 0, 0);
                draw_sprite(sprTextUnlocked, 4, _tx + 1, _ty);
                draw_sprite(sprTextUnlocked, 4, _tx,     _ty + 1);
                draw_sprite(sprTextUnlocked, 4, _tx + 1, _ty + 1);
                d3d_set_fog(0, 0, 0, 0);
                draw_sprite(sprTextUnlocked, 4, _tx,     _ty);
            }

             // Continue Button:
            if(unlock_delay_continue <= 0){
                var _cx = _x,
                    _cy = _y - 4,
                    _blend = make_color_rgb(102, 102, 102);

                for(var i = 0; i < maxp; i++){
                    if(point_in_rectangle(mouse_x[i] - view_xview[i], mouse_y[i] - view_yview[i], _cx - 64, _cy - 12, _cx + 64, _cy + 16)){
                        _blend = c_white;
                        break;
                    }
                }

                draw_sprite_ext(sprUnlockContinue, 0, _cx, _cy, 1, 1, 0, _blend, 1);
            }
        }
    }

     // Corner Popup:
    if(splash_image > 0){
         // Splash:
        var _x = game_width,
            _y = game_height;
    
        draw_sprite(splash_sprit, splash_image, _x, _y);

         // Unlock Text:
        if(splash_texty < 2){
            var _unlock = unlock[splash_index],
                _nam = _unlock.nam[0],
                _txt = _unlock.txt,
                _tx = _x - 4,
                _ty = _y - 16 + splash_texty;

            draw_set_font(fntM);
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);

             // Title:
            var t = "";
            if(_nam != ""){
	            t = _nam + " UNLOCKED";
	            draw_text_nt(_tx, _ty, t);
            }

             // Description:
            if(splash_texty <= 0){
                _ty += max(string_height("A"), string_height(t));
                draw_text_nt(_tx, _ty, "@s" + _txt);
            }
        }
    }

    draw_reset_projection();


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
    
	 // Delete Revives:
    with(instances_matching(CustomObject, "name", "ReviveNTTE")) instance_destroy();

#define step
	if(DebugLag) trace_time();
	
	 // Find Floor Collision Area:
	if(global.floor_num != instance_number(Floor)){
		global.floor_num = instance_number(Floor);
		if(instance_exists(Floor)){
			global.floor_left   = Floor.bbox_left;
			global.floor_right  = Floor.bbox_right;
			global.floor_top    = Floor.bbox_top;
			global.floor_bottom = Floor.bbox_bottom;
			with(Floor){
				global.floor_left   = min(bbox_left,   global.floor_left);
				global.floor_right  = max(bbox_right,  global.floor_right);
				global.floor_top    = min(bbox_top,    global.floor_top);
				global.floor_bottom = max(bbox_bottom, global.floor_bottom);
			}
		}
	}

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
    
	 // Top Enemies:
	var _topEnemy = instances_matching(CustomObject, "name", "TopEnemy");
	with(instance_rectangle_bbox(global.floor_left, global.floor_top, global.floor_right, global.floor_bottom, instances_matching(_topEnemy, "zfriction", 0))){
		 // Jump to Ground (Code goes here using some instances_matching cause it's just faster than checking in step)
		if(place_meeting(x, y, Floor)){
			var	l = 10 * speed,
				d = direction,
				_sx = x + lengthdir_x(l, d),
				_sy = y + lengthdir_y(l, d),
				_tx = _sx,
				_ty = _sy,
				_disMax = 1000000;
				
			mask_index = lq_defget(object, "mask_index", mask_index);
			
			 // Find Open Space to Jump, if Possible:
			if(!place_meeting(_tx, _ty, Floor) || place_meeting(_tx, _ty, Wall)) with(Floor){
        		for(var _x = bbox_left; _x < bbox_right + 1; _x += 8){
        			for(var _y = bbox_top; _y < bbox_bottom + 1; _y += 8){
		        		var _dis = point_distance(other.x, other.y, _x, _y);
		    			if(_dis < _disMax){
							if(abs(angle_difference(point_direction(other.x, other.y, _x, _y), other.direction)) < 180){
			    				with(other) if(!place_meeting(_x, _y, Wall)){
			        				_disMax = _dis;
									_tx = _x;
									_ty = _y;
			    				}
							}
		    			}
        			}
        		}
			}
			jump_x = _tx;
			jump_y = _ty;
			
			 // Jump to Target Position:
            walk = 0;
            alarm0 = -1;
            alarm1 = -1;
			zfriction = grav;
            zspeed = jump * ((sprite_index == spr_walk) ? 1 : 2/3);
            direction = point_direction(x, y, _tx, _ty);
            var d = point_distance(x, y, _tx, _ty);
            speed = min(maxspeed, (sqrt(max(0, sqr(d) * ((2 * zfriction * z) + sqr(zspeed)))) - (d * zspeed)) / (2 * z));
			
             // Visual:
            if(speed > 0){
            	gunangle = direction;
            	scrRight(gunangle);
            }
            if(sprite_index != spr_walk){
	        	sprite_index = spr_walk;
	        	image_index = 0;
            }
            
             // Sound:
			sound_play_hit_ext(sndAssassinAttack, 1 + orandom(0.4), abs(zspeed) / 6);
		}
	}
	if(!instance_exists(enemy)){ // No Escape from the Top Boys:
		if(array_length(instances_matching_gt(_topEnemy, "alarm0", 0)) > 0 || array_length(instances_matching_gt(_topEnemy, "alarm1", 0)) > 0){
			with(instances_matching_gt(Corpse, "alarm0", -1)) alarm0 = -1;
		}
	}
	if(instance_exists(NothingSpiral)){ // Fall into Portal Abyss
		with(instances_matching(instances_matching(CustomObject, "name", "TopChest", "TopEnemy"), "zfriction", 0)){
			if(array_length(instances_matching_gt(instances_matching_lt(instances_matching_gt(Floor, "y", y), "bbox_left", x), "bbox_right", x)) > 0){
				instance_delete(id); // Delete if directly above any floors cause the portal background & the floor stalactites draw at the same depth
			}
			else{
				zfriction = grav;
				zspeed = jump;
				if("walkspeed" in self){
					motion_add(random(360), walkspeed * 2);
				}
			}
		}
	}
	else if(GameCont.killenemies){ // Someone ended it
		with(instances_matching(_topEnemy, "is_enemy", true)){
			//object.my_health = 0; // hmmmmm should i do this
			if(zfriction == 0 && (alarm1 < 0 || alarm1 > 10)){
				alarm1 = irandom_range(1, 10);
			}
		}
	}
    
	 // Pet Tips:
	with(instances_matching(GenCont, "tip_ntte_pet", null)){
		tip_ntte_pet = chance(1, 14);
		if(tip_ntte_pet){
			var _player = array_shuffle(instances_matching_ne(Player, "ntte_pet", null)),
				_tip = null;

			with(_player){
				var _pet = array_shuffle(array_clone(ntte_pet));
				with(_pet) if(instance_exists(self)){
					var _scrt = pet + "_ttip";
					if(mod_script_exists(mod_type, mod_name, _scrt)){
						_tip = mod_script_call(mod_type, mod_name, _scrt);
						if(array_length(_tip) > 0){
							_tip = _tip[irandom(array_length(_tip) - 1)];
						}
					}

					if(is_string(_tip)) break;
				}
				if(is_string(_tip)) break;
			}
			if(is_string(_tip)) tip = _tip;
		}
	}

	 // Pet Leveling Up FX:
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
    script_bind_step(step_post, 0);
    script_bind_draw(draw_shadows_top, -6.001);

	if(DebugLag) trace_time("tegeneral_step");

#define step_post
	instance_destroy();

	if(DebugLag) trace_time();

     // Pickup Indicator Collision:
    var _inst = instances_matching(CustomObject, "name", "PickupIndicator");
	with(_inst) pick = -1;
	_inst = instances_matching(_inst, "visible", true);
	if(array_length(_inst) > 0){
	    with(Player) if(visible || variable_instance_get(id, "wading", 0) > 0){
	        if(place_meeting(x, y, CustomObject)){
	        	 // Find Nearest Touching Indicator:
	        	var _nearest = noone,
	        		_maxDis = null,
	        		_maxDepth = null;
	        		
	        	if(instance_exists(nearwep)){
	        		_maxDis = point_distance(x, y, nearwep.x, nearwep.y);
	        		_maxDepth = nearwep.depth;
	        	}
	        		
	        	with(instances_meeting(x, y, _inst)){
	        		if(place_meeting(x, y, other) && (!creator_visible_follow || !instance_exists(creator) || creator.visible || variable_instance_get(creator, "wading", 0) > 0)){
	        			var e = on_meet;
	        			if(!mod_script_exists(e[0], e[1], e[2]) || mod_script_call(e[0], e[1], e[2])){
	        				if(_maxDepth == null || depth < _maxDepth){
	        					_maxDepth = depth;
	        					_maxDis = null;
	        				}
	        				if(depth == _maxDepth){
			        			var _dis = point_distance(x, y, other.x, other.y);
			        			if(_maxDis == null || _dis < _maxDis){
			        				_maxDis = _dis;
			        				_nearest = id;
			        			}
	        				}
	        			}
	        		}
	        	}

				 // Secret IceFlower:
	            with(_nearest){
	            	nearwep = instance_create(x + hspeed_raw + xoff, y + vspeed_raw + yoff, IceFlower);
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

	if(DebugLag) trace_time("tegeneral_step_post");

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
	
	 // Portal Ball:
	with(instances_matching(CustomProjectile, "name", "PortalGuardianBall")){
		draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
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
	
	 // Top Objects:
	if(!instance_exists(NothingSpiral)){
		with(instances_matching(CustomObject, "name", "TopChest", "TopEnemy")) if(visible){
			if(place_meeting(x, y, Floor)){
				draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
			}
		}
	}

	if(DebugLag) trace_time("tegeneral_draw_shadows");

#define draw_shadows_top
	instance_destroy();

	if(DebugLag) trace_time();

	var _vx = view_xview_nonsync,
		_vy = view_yview_nonsync,
		_vw = game_width,
		_vh = game_height,
		_inst = instances_matching_ge(
			instances_matching(
				array_combine(
					instances_matching(CustomObject, "name", "NestRaven", "TopChest", "TopEnemy"),
					instances_matching(CustomProjectile, "name", "MortarPlasma"),
				),
				"visible", true
			),
			"z", 8
		),
		_active = (array_length(_inst) > 0 && !instance_exists(NothingSpiral) && instance_exists(BackCont));
		
	with(surfShadowTopMask){
		var	_x = floor(_vx / _vw) * _vw,
			_y = floor(_vy / _vh) * _vh;
			
		if(_x != x || _y != y){
			x = _x;
			y = _y;
			reset = true;
		}
		w = _vw * 2;
		h = _vh * 2;
		active = _active;
		
		 // Drawing Wall Mask:
		if(active){
			 // New Floors:
			with(instances_matching([Wall, Floor], "shadowtopmasksurf_check", null)){
				shadowtopmasksurf_check = true;
				other.reset = true;
			}
			
			 // Reset Wall Mask:
			if(reset && surface_exists(surf)){
				reset = false;
				
				surface_set_target(surf);
				draw_clear_alpha(0, 0);
				
				with(instance_rectangle_bbox(x, y, x + w, y + h, Floor)){
					x -= other.x;
					y -= other.y;
					y -= 8;
					draw_self();
					x += other.x;
					y += other.y;
					y += 8;
				}
				draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
				with(instance_rectangle_bbox(x, y, x + w, y + h, Wall)){
					draw_sprite(outspr, outindex, x - other.x, y - other.y);
				}
				draw_set_blend_mode(bm_normal);
				
				surface_reset_target();
			}
		}
	}
	with(surfShadowTop){
		x = _vx;
		y = _vy;
		w = _vw;
		h = _vh;
		active = _active;

		if(active && surface_exists(surf)){
			surface_set_target(surf);
			draw_clear_alpha(0, 0);

			 // Draw Shadows:
			with(instances_seen_nonsync(_inst, 8, 8)){
				switch(name){
					case "MortarPlasma":
				        var _percent = clamp(96 / (z - 8), 0.1, 1),
				            _w = ceil(18 * _percent),
				            _h = ceil(6 * _percent),
				            _x = x - other.x,
				            _y = y - 8 - other.y;
				            
				        draw_ellipse(_x - (_w / 2), _y - (_h / 2), _x + (_w / 2), _y + (_h / 2), false);
				        
				        break;
				        
				    default:
						var _x = x + spr_shadow_x,
							_y = y + spr_shadow_y - 8;
							
						draw_sprite(spr_shadow, 0, _x - other.x, _y - other.y);
				}
			}
			
			 // Clear Non-Wall Space:
			with(surfShadowTopMask) if(surface_exists(surf)){
				draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
				draw_surface(surf, x - other.x, y - other.y);
				draw_set_blend_mode(bm_normal);
			}
			
			surface_reset_target();
			
			 // Draw Surface:
			draw_set_fog(true, BackCont.shadcol, 0, 0);
			draw_set_alpha(BackCont.shadalpha);
			draw_surface(surf, x, y);
			draw_set_fog(false, 0, 0, 0);
			draw_set_alpha(1);
		}
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