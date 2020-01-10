#define init
    spr = mod_variable_get("mod", "teassets", "spr");
    snd = mod_variable_get("mod", "teassets", "snd");
    mus = mod_variable_get("mod", "teassets", "mus");
    sav = mod_variable_get("mod", "teassets", "sav");

    DebugLag = false;
    
     // Surfaces:
	surfShadowTop = surflist_set("ShadowTop", 0, 0, game_width, game_height);
	surfShadowTopMask = surflist_set("ShadowTopMask", 0, 0, 2 * game_width, 2 * game_height);
	surfPet = surflist_set("Pet", 0, 0, 64, 64);
	with(surfShadowTopMask) reset = true;
	
	 // Top Object Searching:
	TopObjectSearchMap = ds_map_create();
	with(TopObjectSearch) ds_map_set(TopObjectSearchMap, self, GameObject.id);
	
	 // Floor Related:
	global.floor_num = 0;
	global.floor_left = 0;
	global.floor_right = 0;
	global.floor_top = 0;
	global.floor_bottom = 0;

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

#macro surfShadowTop global.surfShadowTop
#macro surfShadowTopMask global.surfShadowTopMask
#macro surfPet global.surfPet

#macro TopObjectSearch [hitme, projectile, becomenemy, Pickup, chestprop, Corpse, Effect, Explosion, MeatExplosion, PlasmaImpact, BigDogExplo, NothingDeath, Nothing2Death, FrogQueenDie, PopoShield, CrystalShield, SharpTeeth, ReviveArea, NecroReviveArea, RevivePopoFreak]
#macro TopObjectSearchMap global.top_object_search_map

#define AlertIndicator_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.GatorAlert;
		spr_alert = spr.AlertIndicator;
		image_speed = 0.4;
		image_alpha = -1;
		alert_ang = 0;
		alert_col = make_color_rgb(252, 56, 0);
		alert_x = -5;
		alert_y = 0;
		
		 // Sound:
		snd_flash = sndSlider;
		
		 // Vars:
		target = noone;
		target_x = 0;
		target_y = -16;
		blink = 30;
		flash = 3;
		
		 // Alarms:
		alarm0 = 90;
		
		return id;
	}
	
#define AlertIndicator_begin_step
	if(flash > 0){
		flash -= current_time_scale;
		
		 // Sound:
		if(flash <= 0){
			sound_play(snd_flash);
			sound_play_pitch(sndCrownAppear, 0.9 + random(0.2));
		}
	}
	
#define AlertIndicator_end_step
	 // Follow the Leader:
	if(instance_exists(target)){
		x = target.x + target_x;
		y = target.y + target_y;
	}
	
	 // Stay Hidden:
	image_alpha = -abs(image_alpha);
	
#define AlertIndicator_alrm0
	alarm0 = 2;
	
	 // Blink Out:
	visible = !visible;
	if(blink-- <= 0) instance_destroy();


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

                with(TopDecal_create(0, 0, GameCont.area)){
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

								var n = instance_nearest_array(x, y, instances_matching_ne(instances_matching(object_index, "name", name), "id", id));
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
    				with(instance_nearest_array(x - 16, y - 16, instances_matching_le(instances_matching_ge(Floor, "bbox_top", y - 16), "bbox_bottom", y + 48))){
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
        case 1: /// Bones
        
            repeat(irandom_range(2, 3)) with instance_create(_x, _y, WepPickup){
                motion_set(irandom(359), random_range(3, 6));
                wep = "crabbone";
                repeat(3) scrFX(x, y, 2, Smoke);
            }
            
             // Sound:
            sound_play_hit_ext(sndWallBreakBrick, 0.5 + random(0.2), 1);
            
            break;
            
        case 2: /// Egg Vat
        
            repeat(irandom_range(3, 5)){
                with(instance_create(_x + orandom(16), _y + random(24), FrogEgg)){
                    alarm0 = irandom_range(20, 60);
                    nexthurt = current_frame + 6;
                    sprite_index = sprFrogEggSpawn;
                    image_speed = random_range(0.1, 0.4);
                    image_index = 0;
                    
                     // Space Out Eggs:
                    instance_budge(FrogEgg, 24);
                    
                     // FX:
                    repeat(2) with(instance_create(x + orandom(4), y + orandom(4), AcidStreak)){
                    	motion_add(random(360), 1);
                    	image_angle = direction;
                    	image_speed *= random_range(0.5, 1);
                    }
                }
            }
            
             // Sound:
            sound_play_hit_ext(sndToxicBarrelGas, 0.5 + random(0.2), 2);
            
            break;
            
		case 3: /// Nest Bits
		
			repeat(irandom_range(12, 14)){
                with(instance_create(_x + orandom(24), _y - random(8) + orandom(12), Feather)){
                	motion_add(point_direction(_x, _y, x, y), random(6));
                    sprite_index = spr.NestDebris;
                    image_index = irandom(irandom(image_number - 1));
                    fall /= 1 + (image_index / 8);
                    image_speed = 0;
                    depth = -1;
                }
			}
			
			 // Sound:
            sound_play_hit_ext(sndMoneyPileBreak, 0.6 + random(0.2), 3);
            sound_play_hit_ext(sndWallBreakJungle, 1.2 + random(0.2), 1);
            
			break;
			
		case 4:
		case 104: /// Spider Nest
		
			 // Floorify:
			floor_set_style(1, area);
			floor_fill(_x - 32, _y, 2, 1);
			floor_reset_style();
			with(instance_create(_x, _y + 16, PortalClear)){
				image_xscale *= 1.5;
				image_yscale *= 1.2;
			}
			
			 // Inhabitants:
			repeat(irandom_range(2, 3)){
				var e = "Spiderling";
				
				if(chance(1, 3)){
					e = ((area == 104) ? InvSpider : Spider);
				}
				
				with(obj_create(_x + orandom(32), _y + random(24), e)){
					nexthurt = current_frame + 30;
                    
					 // Props:
					repeat(irandom_range(1, 2)){
						with(instance_create(x, y, choose(InvCrystal, Cocoon))){
							nexthurt = current_frame + 30;
							instance_budge(prop, 24);
						}
					}
				}
			}
			
			 // Effects:
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
			sound_play_hit_ext(sndWallBreakScrap, 0.6 + random(0.2), 0.75);
			sound_play_hit_ext(sndCocoonBreak, 0.5, 2);
			
			break;
			
		case 7: /// Enormous Headphone Jack
		
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
			
        case "pizza": /// Pizza time
        
            repeat(irandom_range(4, 6)){
                obj_create(_x + orandom(4), _y + orandom(4), "Pizza");
                with(obj_create(_x, _y, "WaterStreak")){
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
            
		case "oasis": // Life
			
			 // Floorify:
			floor_set_style(1, area);
			floor_fill(_x - 32, _y, 2, 1);
			floor_reset_style();
			with(instance_create(_x, _y + 16, PortalClear)){
				image_xscale *= 1.5;
				image_yscale *= 1.2;
			}
			
			 // They livin in there u kno:
			repeat(4){
				var _sx = _x + orandom(24),
					_sy = _y + random(24);
					
				 // Enemy:
				if(chance(1, 100)){
					instance_create(_sx, _sy, Freak);
				}
				else{
					if(chance(1, 4)) obj_create(_sx, _sy, Crab);
					else obj_create(_sx, _sy, choose(BoneFish, "Puffer"));
				}
				
				 // Prop:
				with(obj_create(_sx + orandom(4), _sy + orandom(4), choose(WaterPlant, WaterPlant, OasisBarrel))){
					nexthurt = current_frame + 30;
					instance_budge(prop, 24);
				}
			}
			
			 // Effects:
			repeat(20) instance_create(_x + orandom(24), _y + orandom(24), Bubble);
			sound_play_hit_ext(sndOasisPortal, 2 + orandom(0.2), 2);
			sound_play_hit_ext(sndOasisExplosion, 1 + orandom(0.2), 2);
			
			break;
			
        case "trench": /// Bubbles
        
        	 // Explo:
			obj_create(_x, _y, "BubbleExplosion");
			repeat(3) obj_create(_x, _y, "BubbleExplosionSmall");
			
			 // Effects:
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
		layout_delay = 10;
		area = 100;
		
		return id;
	}
	
#define BuriedVault_step
	 // Generate Layout:
	if(array_length(layout) <= 0){
		if(layout_delay > 0) layout_delay -= current_time_scale;
		else{
			 // Away From Floors:
			direction = random(360);
			with(instance_nearest(x - 16, y - 16, Floor)){
				other.direction = point_direction((bbox_left + bbox_right + 1) / 2, (bbox_left + bbox_right + 1) / 2, other.x, other.y);
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
			var _tiles = [];
			for(var _ox = 0; _ox < image_xscale; _ox++){
				for(var _oy = 0; _oy < image_xscale; _oy++){
					var	_sx = x + (_ox * 16),
						_sy = y + (_oy * 16),
						_center = (_ox > 0 && _ox < image_xscale - 1 && _oy > 0 && _oy < image_xscale - 1);
						
					if(_center || chance(1, 3)){
						if(!position_meeting(_sx, _sy, Floor) && !position_meeting(_sx, _sy, Wall) && !position_meeting(_sx, _sy, TopSmall)){
							with(instance_create(_sx, _sy, TopSmall)){
								array_push(_tiles, id);
							}
						}
					}
				}
			}
			TopDecal_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), GameCont.area);
			
			 // Spriterize TopSmalls:
			var _x1 = random_range(bbox_left, bbox_right),
				_y1 = random_range(bbox_top, bbox_bottom),
				_x2 = random_range(bbox_left + 16, bbox_right - 16),
				_y2 = random_range(bbox_top + 16, bbox_bottom - 16);
				
			with(array_shuffle(_tiles)){
				var _vault = collision_line(_x1, _y1, _x2, _y2, id, false, false);
				sprite_index = area_get_sprite(
					_vault
						? other.area
						: GameCont.area,
					(position_meeting(_x2, _y2, id) || chance(2, 3))
						? sprWall1Top
						: sprWall1Trans
				);
				
				if(_vault){
					for(var _ox = bbox_left - 8; _ox < bbox_right + 1 + 8; _ox += 8){
						for(var _oy = bbox_top - 8; _oy < bbox_bottom + 1 + 8; _oy += 8){
							if(!position_meeting(_ox, _oy, id) && chance(1, 10)){
								with(instance_create(_ox, _oy, TopPot)){ // TopPot is so epic
									x = xstart;
									y = ystart;
									sprite_index = spr.BuriedVaultTopTiny;
									image_index = irandom(image_number - 1);
									image_speed = 0;
								}
							}
						}
					}
				}
			}
			
			 // Generate Room Layout:
			var	_fx = floor(((bbox_left + bbox_right + 1) / 2) / 16) * 16,
				_fy = floor(((bbox_top + bbox_bottom + 1) / 2) / 16) * 16,
				_num = irandom_range(6, 12),
				_dir = direction,
				_ped = true,
				_tries = 1000;
				
			while(_num > 0 && _tries-- > 0){
				var	_moveDis = 32,
					_moveDir = round(_dir / 90) * 90;
					
				_fx += lengthdir_x(_moveDis, _moveDir);
				_fy += lengthdir_y(_moveDis, _moveDir);
				
				var	_spawnPed = chance(_ped, 1 + ((_num - 1) * 2)),
					_floorDis = 48 + (32 * _spawnPed),
					n = instance_nearest(_fx, _fy, Floor);
					
				if(!instance_exists(n) || abs(_fx - n.x) > _floorDis || abs(_fy - n.y) > _floorDis){
					_num--;
					
					 // Main Loot:
					if(_spawnPed){
						_ped = false;
						
						var _img = 0;
						for(var _ox = -32; _ox <= 32; _ox += 32){
							for(var _oy = -32; _oy <= 32; _oy += 32){
								array_push(layout, {
									x	 : _fx + _ox,
									y	 : _fy + _oy,
									obj	 : Floor,
									vars : {
										sprite_index : spr.VaultFlowerFloor,
										image_index : _img++
									}
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
				else{
					_fx -= lengthdir_x(_moveDis, _moveDir);
					_fy -= lengthdir_y(_moveDis, _moveDir);
					_dir = direction;
				}
			}
		}
	}
	
	 // Create Vault:
	else if(floor_num != instance_number(Floor)){
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
				var	_x1 = x - 16,
					_y1 = y - 16,
					_x2 = x + 48 - 1,
					_y2 = y + 48 - 1;
					
				wall_clear(_x1, _y1, _x2, _y2);
				with(instance_rectangle_bbox(_x1, _y1, _x2, _y2, [Floor, SnowFloor])) instance_destroy();
			}
			
			 // Generate:
			var	_minID = GameObject.id;
			with(layout){
				 // Clear Space for Special Floors:
				if(obj == Floor && "vars" in self){
					if(lq_get(vars, "sprite_index") == spr.VaultFlowerFloor){
						with(instance_rectangle_bbox(x, y, x + 32 - 1, y + 32 - 1, [Floor, SnowFloor])){
							instance_destroy();
						}
					}
				}
				
				 // Create:
				with(obj_create(x, y, obj)){
					if("vars" in other){
						for(var i = 0; i < lq_size(other.vars); i++){
							variable_instance_set(id, lq_get_key(other.vars, i), lq_get_value(other.vars, i));
						}
					}
				}
			}
			
			 // Wallerize:
			with(instances_matching_gt(Floor, "id", _minID)){
				floor_walls();
			}
			var f = [];
			with(instances_matching_gt(Wall, "id", _minID)){
				GameCont.area = (chance(1, 2) ? other.area : _areaCurrent);
				
				 // TopSmalls:
				if(array_length(instance_rectangle_bbox(bbox_left - 1, bbox_top - 1, bbox_right + 1, bbox_bottom + 1, instances_matching_lt(Floor, "id", _minID))) <= 0){
					wall_tops();
				}
				
				 // Less Softlock:
				else{
					GameCont.area = other.area;
					array_push(f, instance_create(x, y, FloorExplo));
					instance_destroy();
				}
			}
			
			 // Even Less Softlock:
			with(f){ // i dislike walls as objects
				if(position_meeting(x - 16, y, Wall) && position_meeting(x, y - 16, Wall) && position_meeting(x + 16, y, Wall) && position_meeting(x, y + 16, Wall)){
					with([instance_place(x - 16, y, Wall), instance_place(x, y - 16, Wall), instance_place(x + 16, y, Wall), instance_place(x, y + 16, Wall)]){
						GameCont.area = ((id > _minID) ? other.area : _areaCurrent);
						instance_create(x, y, FloorExplo);
						instance_destroy();
					}
				}
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
	
	
#define CustomBullet_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = sprBullet1;
		spr_dead = sprBulletHit;
		
		 // Vars:
		mask_index = mskBullet1;
		damage = 3;
		force = 8;
		typ = 1;
		
		return id;
	}
	
#define CustomBullet_anim
	image_index = image_number - 1;
	image_speed = 0;
	
#define CustomBullet_wall
	instance_create(x, y, Dust);
	sound_play_hit(sndHitWall, 0.2);
	instance_destroy();
	
#define CustomBullet_destroy
	with(instance_create(x, y, BulletHit)) sprite_index = other.spr_dead;
	
	
#define CustomFlak_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = sprFlakBullet;
		spr_dead = sprFlakHit;
		
		 // Sounds:
		snd_dead = sndFlakExplode;
		
		 // Vars:
		mask_index = mskFlakBullet;
		friction = 0.4;
		damage = 4;
		force = 6;
		typ = 1;
		bonus = true;
		bonus_damage = 2;
		flak = array_create(16, Bullet2);
		super = false;
		
		 // Alarms:
		alarm2 = 2;
		
		return id;
	}
	
#define CustomFlak_step
	 // Trail:
	if(super || chance_ct(1, 3)){
		var o = (3 * super);
		scrFX([x, o], [y, o], random(2), Smoke);
	}

	 // Animate:
	image_speed = (speed / 12);

	 // Explode:
	if(speed <= 0 || place_meeting(x, y, Explosion)){
		instance_destroy();
	}
	
#define CustomFlak_alrm2
	bonus = false;
	
#define CustomFlak_hit
    if(projectile_canhit(other)){
		sleep(30);
        projectile_hit_push(other, damage + (bonus_damage * bonus), force);
        instance_destroy();
	}
	
#define CustomFlak_destroy
	var	_dir = random(360),
		_flak = flak,
		_flakSize = array_length(_flak);
		
	for(var i = 0; i < _flakSize; i++){
		var	_lq = _flak[i],
			_lqDefault = {};
			
		if(!is_object(_lq)){
			_lq = (is_array(_lq) ? { flak:_lq } : { object_index:_lq });
		}
		
		 // Defaulterize:
		with(_lqDefault){
			object_index = other.name;
			speed = (other.super ? 12 : random_range(8, 16));
			direction = (other.super ? _dir + (360 * (i / _flakSize)) : random(360));
			image_angle = direction;
			creator = other.creator;
			hitid = other.hitid;
			team = other.team;
		}
		var _lqDefaultSize = lq_size(_lqDefault);
		for(var j = 0; j < _lqDefaultSize; j++){
			var k = lq_get_key(_lqDefault, j);
			if(k not in _lq){
				lq_set(_lq, k, lq_get_value(_lqDefault, j));
			}
		}
		
		 // Create Projectile:
		team_instance_sprite(sprite_get_team(sprite_index), instance_create_lq(x, y, _lq));
	}
	
	 // Effects:
	var n = 1 + super;
	repeat(6 * n) scrFX(x, y, random(3), Smoke);
	with(instance_create(x, y, BulletHit)) sprite_index = other.spr_dead;
	sound_play_hit_big(snd_dead, 0.2);
	view_shake_at(x, y, 6 * n);
	sleep(10 * n);
	
	
#define CustomShell_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = sprBullet2;
		spr_dead = sprBullet2Disappear;
		spr_fade = sprBullet2Disappear;
		
		 // Vars:
		mask_index = mskBullet2;
		friction = 0.6;
		damage = 2;
		force = 3;
		typ = 1;
		bonus = true;
		bonus_damage = 1;
		minspeed = 6;
		maxspeed = 16;
		wallbounce = 0;
		
		 // Alarms:
		alarm2 = 2;
		
		return id;
	}
	
#define CustomShell_step
	image_angle = direction;
	
	 // Disappear:
	if(speed < minspeed && sprite_index != spr_fade){
	    sprite_index = spr_fade;
	    image_index = 0;
	    image_speed = 0.4;
	}
	
#define CustomShell_anim
	if(sprite_index != spr_fade){
		image_speed = 0;
		image_index = image_number - 1;
	}
	
	 // Poof:
	else instance_destroy();
	
#define CustomShell_alrm2
	bonus = false;
	
#define CustomShell_hit
    if(projectile_canhit(other)){
        projectile_hit_push(other, damage + (bonus_damage * bonus), force);
        with(instance_create(x, y, BulletHit)) sprite_index = other.spr_dead;
        instance_destroy();
	}
	
#define CustomShell_wall
	instance_create(x, y, Dust);
	if(speed > minspeed) sound_play_hit(sndShotgunHitWall, 0.2);
	
	 // Reset Bonus Damage:
	if(wallbounce > 0 && !bonus){
		bonus = true;
	    alarm2 = 2;
	}
	
	 // Bounce:
	move_bounce_solid(true);
	image_angle = direction;
	speed = min((speed * 0.8) + wallbounce, maxspeed);
	wallbounce *= 0.95;


#define CustomPlasma_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = sprPlasmaBall;
		spr_dead = sprPlasmaImpact;
		spr_trail = sprPlasmaTrail;
		image_speed = 0.5;
		
		 // Sound:
		snd_dead = sndPlasmaHit;
		
		 // Vars:
		mask_index = mskPlasma;
		damage = 4;
		force = 4;
		typ = 2;
		minspeed = 7;
		minscale = 0.5;
		flak = [];
		
		return id;
	}
	
#define CustomPlasma_step
	var	_width = sprite_get_width(sprite_index),
		_minWidth = minscale * _width;
		
	 // Trail:
	if(chance_ct(_width - 16, 16)){
		var	o = _minWidth * ((_width >= 32) ? 3/4 : 1/2);
		with(instance_create(x + orandom(o), y + orandom(o), PlasmaTrail)){
			sprite_index = other.spr_trail;
		}
	}
	
	 // Shake:
	view_shake_max_at(x, y, floor(_width / 24));
		
	 // Explode:
	if(sprite_width < _minWidth) instance_destroy();
	
#define CustomPlasma_draw
	draw_sprite_ext(sprite_index, image_index, x, y, lerp(minscale, 1, image_xscale), lerp(minscale, 1, image_yscale), image_angle, image_blend, image_alpha);
	
#define CustomPlasma_anim
	image_speed = 0;
	image_index = image_number - 1;
	speed = minspeed;
	
#define CustomPlasma_hit
    if(projectile_canhit(other)){
        projectile_hit_push(other, round(damage * image_xscale), force);
        
         // Shrink:
		image_xscale -= 0.1;
		image_yscale -= 0.1;
		x -= hspeed_raw;
		y -= vspeed_raw;
		
		 // Effects:
		var	_sleep = (10 / 3) * floor(sprite_width / 16),
			_shake = 2 + (4 * floor(sprite_get_width(sprite_index) / 32));
			
		if(array_length(flak) > 0){
			_sleep *= 3;
		}
		if(!instance_is(creator, Player)){
			_sleep *= 3;
			_shake *= 0.5;
		}
		
    	sleep(_sleep);
		view_shake_at(x, y, _shake);
	}
	
#define CustomPlasma_wall
	 // Shrink:
	image_xscale -= 0.1;
	image_yscale -= 0.1;
	x -= hspeed_raw;
	y -= vspeed_raw;
	
	 // Effects:
	instance_create(x, y, Dust);
	sound_play_hit(sndHitWall, 0.2);
	
#define CustomPlasma_destroy
	sound_play_hit_big(snd_dead, 0.3);
	
	 // Cannon:
	var	_dir = random(360),
		_flak = flak,
		_flakSize = array_length(_flak);
		
	if(_flakSize > 0){
		for(var i = 0; i < _flakSize; i++){
			var	_lq = _flak[i],
				_lqDefault = {};
				
			if(!is_object(_lq)){
				_lq = (is_array(_lq) ? { flak:_lq } : { object_index:_lq });
			}
			
			 // Defaulterize:
			with(_lqDefault){
				object_index = other.name;
				speed = 2;
				direction = _dir + (360 * (i / _flakSize));
				image_angle = direction;
				creator = other.creator;
				hitid = other.hitid;
				team = other.team;
				
				 // Big Plasma:
				if(array_length(lq_get(_lq, "flak")) > 0){
					sprite_index = sprPlasmaBallBig;
					snd_dead = sndPlasmaBigExplode;
					damage = 15;
					force = 8;
					typ = 1;
					minspeed = 6;
				}
			}
			var _lqDefaultSize = lq_size(_lqDefault);
			for(var j = 0; j < _lqDefaultSize; j++){
				var k = lq_get_key(_lqDefault, j);
				if(k not in _lq){
					lq_set(_lq, k, lq_get_value(_lqDefault, j));
				}
			}
			
			 // Create Projectile:
			team_instance_sprite(sprite_get_team(sprite_index), instance_create_lq(x, y, _lq));
		}
		instance_create(x, y, PortalClear);
		sleep(10);
	}
	
	 // Normal:
	else{
		with(instance_create(x, y, PlasmaImpact)){
			sprite_index = other.spr_dead;
			creator = other.creator;
			hitid = other.hitid;
			team = other.team;
			if(!instance_is(creator, Player)){
				mask_index = mskPopoPlasmaImpact;
			}
		}
		sleep(3);
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


#define Igloo_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		var _front = chance(1, 3);
		spr_idle = (_front ? spr.IglooFrontIdle : spr.IglooSideIdle);
		spr_hurt = (_front ? spr.IglooFrontHurt : spr.IglooSideHurt);
		spr_dead = (_front ? spr.IglooFrontDead : spr.IglooSideDead);
		sprite_index = spr_idle;
		depth = -1;
		
		 // Sound:
		snd_hurt = sndHitRock;
		snd_dead = sndSnowmanBreak;
		
		 // Vars:
		mask_index = -1;
		my_health = 30;
		team = 0;
		size = 3;
		seal_count = 5 + irandom(3);
		seal_alert = true;
		health_threshold = -1;
		setup = true;
		
		 // Alarms:
		alarm0 = 90;
		alarm1 = -1;
		
		return id;
	}

#define Igloo_setup
	setup = false;
	
	 // :
	var	_igloos = instances_matching(object_index, "name", name),
		_maxHealth = 0;
		
	with(enemy) _maxHealth += maxhealth;
	
	for(var i = 0; i < array_length(_igloos); i++) with(_igloos[i]){
		health_threshold = _maxHealth * (2 / (i + 3));
	}
	
#define Igloo_step
	if(setup) Igloo_setup();
	
	 // No Leaving Bro:
	if(seal_count > 0 && !instance_exists(enemy)){
		portal_poof();
	}
	
#define Igloo_alrm0
	if(alarm1 < 0){
		 // Call in the Seals:
		var _healthPool = 0;
		with(enemy) _healthPool += my_health;
		if(_healthPool <= max(0, health_threshold)){
			alarm1 = 60;
			
			 // Alert:
			with(scrAlert(self, spr.ArcticSealAlert)){
				flash = 30;
				if(chance(1, 10)){
					spr_alert = sprBreath;
					alert_col = c_white;
					alert_x = 1;
				}
			}
		}
		
		 // Carry On:
		else alarm0 = 30 + random(30);
	}
	
#define Igloo_alrm1
	 // Seal Spew:
	if(seal_count-- > 0){
		alarm1 = 2 + random(3);
		
		with(obj_create(x, y, "Seal")){
			type = irandom_range(4, 6);
		}
	}
	
#define Igloo_death
	 // Seal Spew Pt.2:
	if(seal_count > 0) repeat(seal_count){
		with(obj_create(x, y, "Seal")) type = irandom_range(4, 6);
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
        sprite_index = spr.Race.parrot[0].Feather;
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
                        with(charm_instance(target, true)){
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
	    else sprite_index = enemy_sprite;

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
	            my_corpse = corpse_drop(direction, speed);
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
            if(!path_reaches(path, _xtarget, _ytarget, path_wall)){
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
					for(var i = _max - 1; i >= 0; i--){
						if(!instance_exists(ntte_pet[i]) || i == 0){
							with(ntte_pet[i]){
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
		                    ntte_pet = array_delete(ntte_pet, i);
		                    break;
						}
					}
                    
                     // Add New Pet:
                    array_push(ntte_pet, other);
                    with(other){
                    	leader = other;
                    	direction = point_direction(x, y, other.x, other.y);
                    	
                    	 // Auto Revive on Pickup:
                    	if(maxhealth > 0 && my_health <= 0){
                    		my_health = maxhealth;
				            projectile_hit_raw(leader, 1, true);
		                	with(leader) lasthit = [sprHealBigFX, "LOVE"];
                    	}
                    	
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
    	portal_angle -= portal_angle * 0.2 * current_time_scale;
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
	        	instance_budge(_wall, 96);
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
        path_dir = path_direction(path, x, y, path_wall);

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
                        scrWalk(path_dir + orandom(20), 8);
                        alarm0 = walk;
                    }

                     // Move Toward Leader:
                    else{
                        scrWalk(_leaderDir + orandom(10), 10);
                        alarm0 = 10 + random(5);
                    }
                }
            }

             // Idle Movement:
            else scrWalk(random(360), 15);
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
				else enemy_hurt(_hitdmg, _hitvel, _hitdir);
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


#define PetWeaponBecome_create(_x, _y)
	with(instance_create(_x, _y, chestprop)){
		 // Visual:
		sprite_index = spr.PetWeaponChst;
		 
		 // Vars:
		type = 2;
		pickup_indicator = scrPickupIndicator("BATTLE");
		pickup_indicator.yoff = -1;
		
		return id;
	}
	
#define PetWeaponBecome_step
	var _pickup = pickup_indicator;
	if(instance_exists(_pickup) && player_is_active(_pickup.pick)){
		with(obj_create(x, y, "PetWeaponBoss")){
			type = other.type;
			
			 // Push Away:
			with(player_find(_pickup.pick)) with(other){
				motion_add(point_direction(other.x, other.y, x, y), 3);
			}
		}
		
		GameCont.nochest = 0;
		portal_poof();
		
		instance_destroy();
	}
	
	
#define PetWeaponBoss_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
        boss = true;
        
         // For Sani's bosshudredux:
        bossname = "WEAPON MIMIC";
        col = c_red;
        
		 // Visual:
		spr_idle = spr.PetWeaponIdle;
		spr_walk = spr.PetWeaponWalk;
		spr_hurt = spr.PetWeaponHurt;
		spr_dead = spr.PetWeaponDead;
		spr_spwn = spr.PetWeaponSpwn;
        spr_shadow = shd24;
        spr_shadow_x = 0;
        spr_shadow_y = -1;
		hitid = [spr_idle, "WEAPON MIMIC"];
		sprite_index = spr_spwn;
		depth = -2;
		
		 // Sounds:
		snd_hurt = sndMimicHurt;
		snd_dead = sndMimicDead;
		
		 // Vars:
		mask_index = mskFreak;
		maxhealth = boss_hp(120);
		size = 1;
        walk = 0;
        walkspeed = 2;
        maxspeed = 3;
		intro = false;
		corpse = false;
		type = irandom(5);
		gunangle = random(360);
		gunangle_goal = gunangle;
		gunangle_turn = 0.25;
		shootdis_min = 0;
		shootdis_max = 192;
		path = [];
		path_delay = 0;
		cover_x = x;
		cover_y = y;
		cover_peek = false;
		cover_delay = 0;
		setup = true;
		
		 // Alarms:
		alarm1 = 60;
		alarm2 = 30;
		
		 // Weapons:
		with(["", "b"]){
			var b = self;
			with(other){
				variable_instance_set(self, b + "wep",       wep_none);
				variable_instance_set(self, b + "wkick",     0);
				variable_instance_set(self, b + "wepangle",  0);
				variable_instance_set(self, b + "wepflip",   choose(-1, 1));
				variable_instance_set(self, b + "reload",    alarm2);
				variable_instance_set(self, b + "can_shoot", false);
				variable_instance_set(self, b + "wep_laser", 0);
			}
		}
		
		 // Sounds:
		audio_sound_set_track_position(sound_play_hit_ext(sndBallMamaTaunt, 2, 1), 0.2); // don't like the part at tha end but audio_set_gain was being fucky
		audio_sound_gain(sound_play_hit(sndTechnomancerActivate, 0), 0.4, 300);
		sound_play_hit(sndBigWeaponChest, 0);
		
		 // NTTE:
		ntte_anim = false;
		
		return id;
	}
	
#define PetWeaponBoss_setup
	setup = false;
	
	if(type >= 0){
		 // Auto-Wep:
		if(wep == wep_none){
			var t = (chance(1, 10) ? 2 : (GameCont.loops > 0));
			
			switch(type){     // NORMAL //           // LOOP //           // RARE //
				case 0:	wep = [wep_wrench,           wep_energy_sword,    wep_jackhammer         ][t]; break;
				case 1:	wep = [wep_revolver,         wep_heavy_revolver,  wep_minigun            ][t]; break;
				case 2:	wep = [wep_shotgun,          wep_eraser,          wep_heavy_slugger      ][t]; break;
				case 3:	wep = [wep_crossbow,         wep_auto_crossbow,   wep_splinter_pistol    ][t]; break;
				case 4:	wep = [wep_grenade_launcher, wep_blood_launcher,  wep_sticky_launcher    ][t]; break;
				case 5:	wep = [wep_laser_cannon,     wep_plasma_cannon,   wep_super_plasma_cannon][t]; break;
			}
			
			 // Akimbo:
			if(bwep == wep_none){
				var _name = string_upper(weapon_get_name(wep));
				if(string_pos("REVOLVER", _name) > 0 || string_pos("PISTOL", _name) > 0){
					bwep = wep;
				}
			}
		}
		else{
			type = (weapon_is_melee(wep) ? 0 : weapon_get_type(wep));
		}
		
		 // Weapon Setup:
		gunangle_turn = 0.25;
		shootdis_min = 32;
		shootdis_max = 192;
		switch(type){
			case 0:
				shootdis_min = 0;
				break;
				
			case 2:
				shootdis_min = 0;
				shootdis_max = 96 + (64 * (wep == wep_eraser));
				break;
				
			case 3:
				gunangle_turn = 0.5;
				shootdis_min = 64;
				shootdis_max = 320;
				break;
				
			case 4:
				gunangle_turn = 0.1;
				break;
		}
		if(wep == wep_jackhammer) gunangle_turn = 0.1;
	}
	
	 // Melee:
	var w = choose(-120, 120);
	wepangle = w * weapon_is_melee(wep);
	bwepangle = -w * weapon_is_melee(bwep);
	
#define PetWeaponBoss_step
	if(setup) PetWeaponBoss_setup();
	
	if(path_delay > 0) path_delay -= current_time_scale;
	if(cover_delay > 0) cover_delay -= current_time_scale;
	
	 // Animate:
	if(sprite_index != spr_spwn || anim_end){
		sprite_index = enemy_sprite;
		
		 // Boss Intro:
		if(!intro){
			intro = true;
			boss_intro("PetWeapon", sndBigWeaponChest, musBoss1);
			
			 // Swap:
			wkick = -2;
			bwkick = -2;
			sound_play(weapon_get_swap(wep));
			instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), WepSwap);
		}
	}
	bwkick -= clamp(bwkick, -current_time_scale, current_time_scale);
	
	 // Aim:
	if(enemy_target(x, y) && in_sight(target)){
		gunangle_goal = point_direction(x, y, target.x + target.hspeed, target.y + target.vspeed);
	}
	scrAim(angle_lerp(gunangle, gunangle_goal, gunangle_turn * current_time_scale));
	
	 // Weapons:
	with(["", "b"]){
		var b = self;
		with(other){
			var	_wep = variable_instance_get(self, b + "wep"),
				_reload = variable_instance_get(self, b + "reload");
				
			 // Reloading:
			if(_reload > 0){
				_reload -= current_time_scale;
				
				 // Reload FX:
				if(_reload <= 0 && variable_instance_get(self, b + "can_shoot") <= 0 && sprite_index != spr_spwn){
					var _snd = -1;
					
					 // Melee:
					variable_instance_set(self, b + "wepflip", -variable_instance_get(self, b + "wepflip"));
					if(weapon_is_melee(_wep)){
						var	l = 12,
							d = gunangle + variable_instance_get(self, b + "wepangle");
							
						instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), WepSwap);
						variable_instance_set(self, b + "wkick", -3);
						_snd = sndMeleeFlip;
					}
					
					 // Normal:
					else switch(weapon_get_type(_wep)){
						case 2: // SHELL
							_snd = sndShotReload;
							
							 // Epic:
							variable_instance_set(self, b + "wkick", -4);
							repeat(weapon_get_cost(_wep)){
								with(instance_create(x, y, Shell)){
									sprite_index = sprShotShell;
									motion_add(other.gunangle + (100 * other.right) + orandom(20), 2 + random(2));
								}
							}
							break;
							
						case 3: // BOLT
							_snd = sndCrossReload;
							break;
							
						case 4: // EXPLOSIVE
							if(array_exists([wep_grenade_launcher, wep_golden_grenade_launcher, wep_grenade_shotgun, wep_grenade_rifle, wep_auto_grenade_shotgun, wep_ultra_grenade_launcher, wep_sticky_launcher, wep_hyper_launcher, wep_toxic_launcher, wep_cluster_launcher, wep_heavy_grenade_launcher], _wep)){
								_snd = sndNadeReload;
							}
							break;
							
						case 5: // ENERGY
							if(string_pos("PLASMA", weapon_get_name(_wep)) == 1){
								_snd = sndPlasmaReload;
							}
							else if(string_pos("LIGHTNING", weapon_get_name(_wep)) == 1){
								_snd = sndLightningReload;
							}
							break;
					}
					
					if(sound_exists(_snd)){
						sound_play_hit_ext(_snd, 1.15 + orandom(0.25), 1);
					}
				}
			}
			
			 // Ready:
			else{
				var _wepLaser = variable_instance_get(self, b + "wep_laser");
				
				 // Laser Sight:
				if(weapon_get_laser_sight(wep)){
					if(point_distance(x, y, cover_x, cover_y) < 24 || (enemy_target(x, y) && in_sight(target))){
						_wepLaser += current_time_scale / (in_distance(target, shootdis_min) ? 60 : 5);
					}
					else if(_wepLaser > 0){
						_wepLaser -= current_time_scale / 3;
					}
				}
				
				 // Shoot:
				var _canShoot = variable_instance_get(self, b + "can_shoot");
				if(_canShoot > 0){
					var	_minID    = GameObject.id,
						_wepangle = variable_instance_get(self, b + "wepangle"),
						_wkick    = variable_instance_get(self, b + "wkick");
						
					_canShoot--;
					_wepLaser = 0;
					
					 // Mutation Fixes:
					var _muts = [[mut_long_arms, 0], [mut_recycle_gland, 0], [mut_shotgun_shoulders, 0], [mut_bolt_marrow, 0], [mut_boiling_veins, 0], [mut_laser_brain, 0]];
					with(_muts){
						var v = self[1];
						self[@1] = skill_get(self[0]);
						skill_set(self[0], v);
					}
					
					 // Fire:
					with(player_fire_ext(gunangle, _wep, x, y, team, id)){
						_reload = reload;
						_wkick = wkick * 1.5;
					}
					_wepangle *= -1;
					
					 // Reset Mutation Fixes:
					with(_muts) skill_set(self[0], self[1]);
					
					 // Projectiles:
					with(instances_matching_gt([projectile, LaserCannon], "id", _minID)){
						hitid = other.hitid;
						
						 // Specifics:
						switch(object_index){
							case Bullet2: // Nerf Shotguns
								if(string_pos("SHOTGUN", string_upper(weapon_get_name(_wep))) > 0){
									speed *= 0.8;
								}
								break;
								
							case Bolt: // Bolt Marrow Fix
								instance_create_copy(x, y, "DiverHarpoon");
								break;
								
							default:
								 // Time Nades:
								if(instance_is(self, Grenade) && alarm0 > 0){
									var a = (alarm2 - alarm0);
									alarm0 += (_canShoot * weapon_get_load(_wep));
									if(alarm2 > 0){
										if(TopCont.darkness) a -= 40;
										alarm2 = max(1, alarm0 + a);
									}
								}
						}
						
						 // Euphoria:
						speed *= power(0.8, skill_get(mut_euphoria));
						
						 // Enemy Spriterize:
						team_instance_sprite(1, self);
					}
					
					variable_instance_set(self, b + "can_shoot", _canShoot);
					variable_instance_set(self, b + "wepangle",  _wepangle);
					variable_instance_set(self, b + "wkick",     _wkick);
				}
				
				variable_instance_set(self, b + "wep_laser", _wepLaser);
			}
			
			variable_instance_set(self, b + "reload", _reload);
		}
	}
	
	 // Laser Cannon:
	var _laserCannon = instances_matching(LaserCannon, "creator", id);
	if(wep == wep_laser_cannon || array_length(_laserCannon) > 0){
		with(_laserCannon){
			direction = other.gunangle;
			image_angle = other.gunangle;
			time = 1 + floor(abs(angle_difference(other.gunangle, other.gunangle_goal)) / 4);
		}
		with(instances_matching(Laser, "creator", id)){
			image_yscale = 1.4;
			hitid = other.hitid;
			team_instance_sprite(1, self);
		}
	}
	else if(wep == wep_jackhammer){
		with(instances_matching(SawBurst, "creator", id)){
			direction = other.gunangle;
		}
	}
	
#define PetWeaponBoss_draw
	//path_draw(path);
	
	var _hurt = (sprite_index != spr_hurt && nexthurt > current_frame + 3);
	
	 // Gun Drawing Setup:
	var	_wepOffX = 1,
		_wepOffY = ((wep != wep_none && bwep != wep_none) ? 5 : 2),
		_wepDraw = [];
		
	if(sprite_index != spr_spwn) with(["", "b"]){
		var b = self;
		with(other){
			var	_wep = variable_instance_get(self, b + "wep"),
				_wepAng = variable_instance_get(self, b + "wepangle"),
				_wepDir = gunangle + _wepAng,
				_wepLoad = variable_instance_get(self, b + "reload");
				
			array_push(_wepDraw, {
				"sprt" : weapon_get_sprt(_wep),
				"x"    : x + lengthdir_x(_wepOffX, _wepDir) + lengthdir_x(_wepOffY,       _wepDir - 90),
				"y"    : y + lengthdir_y(_wepOffX, _wepDir) + lengthdir_y(_wepOffY * 2/3, _wepDir - 90),
				"gang" : gunangle,
				"wang" : _wepAng,
				"kick" : variable_instance_get(self, b + "wkick"),
				"flip" : ((_wepAng != 0) ? variable_instance_get(self, b + "wepflip") : 1) * ((_wepOffY == 0) ? right : sign(_wepOffY)),
				"blnd" : merge_color(image_blend, c_black, 0.15 * (_wepLoad > 0) * weapon_is_melee(_wep)),
				"alph" : image_alpha,
				"load" : _wepLoad,
				"lasr" : min(1, weapon_get_laser_sight(_wep) * variable_instance_get(self, b + "wep_laser"))
			});
			
			_wepOffY *= -1;
		}
	}
	
	 // Guns in Back:
	with(_wepDraw){
		 // Laser Sight:
		if(lasr > 0){
			draw_set_color(make_color_rgb(250, 54, 0));
			draw_lasersight(x, y, gang, 1000, lasr);
		}
		
		 // Gun:
		if(y < other.y){
			draw_weapon(sprt, x, y, gang, wang, kick, flip, blnd, alph);
		}
	}
	
	 // Self:
	if(_hurt) draw_set_fog(true, image_blend, 0, 0);
	draw_self_enemy();
	if(_hurt) draw_set_fog(false, 0, 0, 0);
	
	 // Guns in Front:
	with(_wepDraw) if(y >= other.y){
		draw_weapon(sprt, x, y, gang, wang, kick, flip, blnd, alph);
	}
	
#define PetWeaponBoss_alrm1
	alarm1 = 10 + random(30);
	
	if(enemy_target(x, y)){
		var	_tx = target.x,
			_ty = target.y,
			_targetDir = point_direction(x, y, _tx, _ty),
			_pathWall = Wall,
			_pathX = null,
			_pathY = null;
			
		switch(type){
			case 0: /// MELEE
				
				 // Movement:
				if(in_sight(target)){
					scrWalk(_targetDir + choose(-60, 60), 5 + random(10));
					alarm1 = walk;
				}
				
				 // Find Player:
				else{
					_pathX = _tx;
					_pathY = _ty;
				}
				
				 // Avoid:
				with(instances_matching_ne(instances_matching(projectile, "typ", 1), "team", team)){
					if(abs(angle_difference(other.gunangle, point_direction(other.x, other.y, x, y))) < 60){
						if(in_distance(other, 96)){
							other.direction += 180;
							break;
						}
					}
				}
				
				break;
				
			case 2: /// CLOSE RANGE
				
				 // Movement:
				if(in_sight(target)){
					scrWalk(gunangle + orandom(60), 20);
					alarm1 = walk;
				}
				
				 // Find Player:
				else{
					_pathX = _tx;
					_pathY = _ty;
				}
				
				break;
				
			case 3: /// LONG RANGE + COVER
			
				 // Go to Cover:
				if(cover_delay > 0 || PetWeaponBoss_point_is_cover(cover_x, cover_y, _tx, _ty)){
					if(point_distance(x, y, cover_x, cover_y) > 8 || cover_peek){
						 // Cover in Sight:
						if(!collision_line(x, y, cover_x, cover_y, Wall, false, false)){
							scrWalk(point_direction(x, y, cover_x, cover_y), (cover_peek ? [5, 10] : 1));
							alarm1 = (cover_peek ? random_range(walk, 30) : walk);
							cover_peek = false;
						}
						
						 // Pathfind to Cover:
						else{
							_pathX = cover_x;
							_pathY = cover_y;
						}
					}
					
					 // Peek Out of Cover:
					else{
						cover_peek = true;
						gunangle_goal = _targetDir;
						
						alarm1 = 15;
						alarm2 = alarm1 - random(3);
						
						 // Peekin:
						var	l = 16,
							d = round(point_direction(cover_x, cover_y, _tx, _ty) / 90) * 90,
							_peekLeft  = !collision_line(cover_x + lengthdir_x(l, d - 90), cover_y + lengthdir_y(l, d - 90), _tx, _ty, Wall, false, false),
							_peekRight = !collision_line(cover_x - lengthdir_x(l, d - 90), cover_y - lengthdir_y(l, d - 90), _tx, _ty, Wall, false, false),
							_peekSide = sign(_peekRight - _peekLeft);
							
						scrWalk(d + (90 * ((_peekSide == 0) ? choose(-1, 1) : _peekSide)), 4);
						
						 // Stay in Cover:
						if(_peekRight || _peekLeft){
							cover_delay = random_range(60, 90);
						}
					}
				}
				
				 // Find Cover:
				else{
					cover_x = _tx;
					cover_y = _ty;
					cover_peek = false;
					cover_delay = 30;
					
					scrWalk(point_direction(_tx, _ty, x, y), 15);
					alarm1 = walk;
					
					var	_coverDisMax = null,
						_targetDisMin = null;
						
					with(instance_rectangle_bbox(_tx - shootdis_max, _ty - shootdis_max, _tx + shootdis_max, _ty + shootdis_max, Floor)){
						for(var _x = bbox_left; _x < bbox_right + 1; _x += 16){
							for(var _y = bbox_top; _y < bbox_bottom + 1; _y += 16){
								var	_cx = _x + 8,
									_cy = _y + 8,
									_coverDis = point_distance(_cx, _cy, other.x, other.y),
									_targetDis = point_distance(_cx, _cy, _tx, _ty);
									
								if((is_undefined(_coverDisMax) || _coverDis < _coverDisMax) && (is_undefined(_targetDisMin) || _targetDis > _targetDisMin)){
									with(other) if(PetWeaponBoss_point_is_cover(_cx, _cy, _tx, _ty)){
										_coverDisMax = _coverDis;
										_targetDisMin = _targetDis;
										cover_x = _cx;
										cover_y = _cy;
									}
								}
							}
						}
					}
				}
				
				break;
				
			case 5: /// ENERGY
			
				 // Movement:
				if(in_sight(target)){
					if(in_distance(target, shootdis_max)){
						if(chance(1, 3)){
							scrWalk(random(360), random_range(5, 20));
						}
					}
					else{
						scrWalk(gunangle, 20);
						alarm1 = walk;
					}
				}
				
				 // Find Player:
				else{
					_pathX = _tx;
					_pathY = _ty;
				}
				
				break;
				
			default:
			
				 // Movement:
				if(in_sight(target)){
					if(in_distance(target, shootdis_max * 2/3)){
						scrWalk(_targetDir + (90 * sign(angle_difference(direction, _targetDir))), 15);
					}
					else{
						scrWalk(gunangle, 20);
					}
					alarm1 = walk;
				}
				
				 // Find Player:
				else{
					_pathX = _tx;
					_pathY = _ty;
				}
				
				break;
		}
		
		 // Pathfind:
		if(is_real(_pathX) && is_real(_pathY)){
			 // Create Path:
			if(path_delay <= 0 && !path_reaches(path, _pathX, _pathY, _pathWall)){
				path = path_create(x, y, _pathX, _pathY, _pathWall);
				path = path_shrink(path, _pathWall, 2);
				path_delay = 30;
			}
			
			 // Follow Path:
			var _pathDir = path_direction(path, x, y, _pathWall);
			if(_pathDir != null){
				scrWalk(_pathDir, [1, 5]);
				alarm1 = walk;
				
				 // Searching:
				if(!in_sight(target)){
					if(abs(angle_difference(gunangle_goal, _pathDir)) > 60){
						gunangle_goal = _pathDir + orandom(60);
					}
					if(in_distance(target, 64)){
						alarm1 += random(random(random(30)));
						gunangle_goal = angle_lerp(gunangle_goal, _targetDir, 1/2);
					}
				}
			}
			else path = [];
		}
		else path = [];
	}
	
	 // Wander:
	else{
		scrWalk(random(360), [15, 30]);
		gunangle_goal = direction;
	}
	
#define PetWeaponBoss_alrm2
	alarm2 = 30;
	
	 // Shootin:
	if(sprite_index != spr_spwn){
		if(enemy_target(x, y) && in_sight(target) && in_distance(target, shootdis_max)){
			if(abs(angle_difference(gunangle, point_direction(x, y, target.x, target.y))) < 30){
				var _shot = false;
				with(["", "b"]){
					var b = self;
					with(other){
						var _wep      = variable_instance_get(self, b + "wep"),
							_reload   = variable_instance_get(self, b + "reload"),
							_canShoot = variable_instance_get(self, b + "can_shoot");
							
						if(_canShoot <= 0 && _wep != wep_none && _reload <= 0){
							if(
								(!weapon_get_laser_sight(_wep) && !in_distance(target, shootdis_min))
								||
								variable_instance_get(self, b + "wep_laser") >= 1
							){
								_shot = true;
								_canShoot = 1;
								
								 // Fire Multiple Times:
								var _wepLoad = weapon_get_load(_wep);
								if(weapon_get_auto(_wep) || _wepLoad <= 10){
									_canShoot += floor(random(30) / _wepLoad);
								}
								if(type == 4 || _wep == wep_jackhammer){
									_canShoot += irandom(ceil(3 * (1 - (my_health / maxhealth))));
								}
								
								 // Shooting Delay:
								alarm2 = 30 + (_canShoot * _wepLoad);
								switch(type){
									case 0:
										alarm2 += 15 + (30 * (wep == wep_jackhammer));
										break;
										
									case 2: // Warning
										_reload = 9;
										with(scrAlert(self, spr.PetWeaponIcon)){
											alert_x--;
											flash = 2;
											blink = 10;
											alarm0 = _reload + 5;
											snd_flash = sndShotReload;
										}
										break;
										
									case 5:
										alarm2 += random(30);
										break;
								}
							}
						}
						
						variable_instance_set(self, b + "reload",    _reload);
						variable_instance_set(self, b + "can_shoot", _canShoot);
					}
					if(_shot) break;
				}
			}
		}
	}
	
#define PetWeaponBoss_hurt(_hitdmg, _hitvel, _hitdir)
	if(type == 0 || type == 2){
		_hitdir = angle_lerp(_hitdir, _hitdir + 180, random_range(0.5, 1));
	}
	enemy_hurt(_hitdmg, _hitvel, _hitdir);
	
#define PetWeaponBoss_death
	 // Pet Time:
	with(pet_spawn(x, y, "Weapon")){
		direction = other.direction;
		speed = other.speed;
		my_health = 0;
	}
	
#define PetWeaponBoss_point_is_cover(_coverX, _coverY, _fromX, _fromY)
	if(in_range(point_distance(_coverX, _coverY, _fromX, _fromY), shootdis_min, shootdis_max)){
		if(collision_line(_coverX, _coverY, _fromX, _fromY, Wall, false, false)){
			if(!position_meeting(_coverX, _coverY, Wall)){
				var	l = 16,
					d = round(point_direction(_coverX, _coverY, _fromX, _fromY) / 90) * 90;
					
				if(
					position_meeting(_coverX + lengthdir_x(l, d),      _coverY + lengthdir_y(l, d),      Wall)	||
					position_meeting(_coverX + lengthdir_x(l, d - 90), _coverY + lengthdir_y(l, d - 90), Wall)	||
					position_meeting(_coverX + lengthdir_x(l, d + 90), _coverY + lengthdir_y(l, d + 90), Wall)
				){
					if(
						!collision_line(_coverX + lengthdir_x(l, d - 90), _coverY + lengthdir_y(l, d - 90), _fromX, _fromY, Wall, false, false) ||
						!collision_line(_coverX - lengthdir_x(l, d - 90), _coverY - lengthdir_y(l, d - 90), _fromX, _fromY, Wall, false, false)
					){
						return true;
					}
				}
			}
		}
	}
	return false;
	
	
#define PickupIndicator_create(_x, _y)
    with(instance_create(_x, _y, CustomObject)){
    	 // Vars:
        mask_index = mskWepPickup;
		persistent = true;
        creator = noone;
        nearwep = noone;
		depth = 0; // Priority (0==WepPickup)
        pick = -1;
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


#define PortalBullet_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		spr_spwn = spr.PortalBulletSpawn;
		spr_idle = spr.PortalBullet;
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
	
#define PortalBullet_anim
	 // Fire:
	if(sprite_index == spr_spwn){
		sprite_index = spr_idle;
		mask_index = mskSuperFlakBullet;
		
		 // FX:
		sound_play_pitch(sndGuardianHurt, 1.5 + orandom(0.2));
		repeat(5) scrFX(x, y, [direction + orandom(60), 3], Dust);
	}
	
#define PortalBullet_step
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
	
#define PortalBullet_hit
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
	
#define PortalBullet_destroy
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
		maxhealth = 55; // 45
		raddrop = 16;
		meleedamage = 2;
		size = 2;
		walk = 0;
		walkspeed = 0.8;
		maxspeed = 4;
		gunangle = random(360);
		
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
	alarm1 = 20 + random(30);
	
	if(enemy_target(x, y)){
		scrAim(point_direction(x, y, target.x, target.y));
		
		if(in_sight(target)){
			 // Attack:
			if(chance(2, 3) && array_length(instances_matching(projectile, "creator", id)) <= 0){
				enemy_shoot("PortalBullet", gunangle, 9);
				
				 // Sound:
				sound_play_pitchvol(sndPortalOld, 2 + random(2), 1.5);
			}
			
			 // Move:
			else{
				scrWalk(gunangle + (random_range(60, 100) * choose(-1, 1)), [20, 40]);
				
				 // Away From Target:
				if(in_distance(target, 128)){
					direction = gunangle + 180 + orandom(30);
				}
			}
		}
		
		 // Wander:
		else{
			scrWalk(gunangle + orandom(40), [10, 20]);
			scrAim(direction);
		}
	}
	
	 // Wander:
	else{
		scrWalk(random(360), 30);
		scrAim(direction);
	}
	
#define PortalGuardian_death
	with(instance_create(x, y, PortalClear)){
		image_xscale = 2/3;
		image_yscale = image_xscale;
	}
	
	 // Pickups:
	pickup_drop(40, 10);


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
			with(instance_nearest_array(x, y, instances_matching_gt(instances_matching(Player, "p", p), "id", id))){
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
	
	
#define TopObject_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		spr_shadow = -1;
		spr_shadow_x = 0;
		spr_shadow_y = 0;
		depth = -6 - (y / 10000);
		
		 // Vars:
	    mask_index = -1;
	    mask_x = 0;
	    mask_y = 8;
		target = noone;
		target_save = {};
		z = 8;
		zspeed = 0;
		zfriction = 0;
		maxspeed = 0;
		grav = 0.8;
		jump = random_range(3, 4);
		jump_x = x;
		jump_y = y;
		jump_time = 0;
		idle_time = 0;
		idle_wait = [15, 90];
		idle_walk = [5, 20];
		idle_walk_chance = 1/6;
		spawn_dis = 0;
		spawn_dir = 0;
		wobble = 0;
		wobble_num = 0;
		override_mask = true;
		override_depth = true;
		is_enemy = false;
		is_damage = false;
		unstick = false;
		search_x1 = x - 8;
		search_x2 = x + 8;
		search_y1 = y - 8;
		search_y2 = y + 8;
		
		y += z;
		
		return id;
	}
	
#define TopObject_end_step
	if(instance_exists(target)){
		if(zspeed != 0) z += zspeed * current_time_scale;
		
		 // Target Management:
		with(target){
			 // Position:
			if(x != xprevious || y != yprevious){
				if(other.zfriction == 0 || !other.unstick){
					if("walk" in self || other.jump_time <= 0){
						other.x += (x - xprevious);
						other.y += (y - yprevious);
						
						 // Depth:
						if(other.override_depth){
							if(depth != other.depth) other.target_save.depth = depth;
							other.depth = -6 - ((other.y - 8) / 10000);
							depth = other.depth;
						}
					}
				}
				
				var _spd = point_distance(xprevious, yprevious, x, y);
				other.direction = point_direction(xprevious, yprevious, x, y);
				if(_spd > other.maxspeed) other.maxspeed = _spd;
				
				if("spr_shadow" in self && other.z <= 8){
					 // Trail:
					if(chance_ct(sqr(_spd), 90)){
						var	o = abs(sprite_width / 16),
							_leaf = (GameCont.area == 105);
							
						with(instance_create(x + orandom(o), y + o + random(o), (_leaf ? Feather : Dust))){
							if(_leaf){
								sprite_index = sprLeaf;
								speed *= random_range(0.5, 1);
							}
							depth = other.depth + 0.1;
						}
					}
					
					 // Push Bros:
					/*
					var	_inst = id,
						_saveMask = mask_index;
						
					mask_index = lq_defget(other.target_save, "mask_index", mask_index);
					
					with(instances_matching(instances_matching_ne(instance_rectangle(x - 32, y - 32, x + 32, y + 32, instances_matching(other.object_index, "name", other.name)), "id", other), "zfriction", 0)){
						with(target) if(instance_is(self, hitme) && !instance_is(self, prop)){
							var m = mask_index;
							mask_index = lq_defget(other.target_save, "mask_index", mask_index);
							
							if(place_meeting(x, y, _inst)){
								var _dir = point_direction(_inst.x, _inst.y, x, y);
								if(x == _inst.x && y == _inst.y) _dir = random(360);
								motion_add_ct(_dir, 1);
							}
							
							mask_index = m;
						}
					}
					
					mask_index = _saveMask;
					*/
				}
				
				 // Update Object Auto-Topify Range:
				var m = mask_index;
				mask_index = -1;
				other.search_x1 = min(x - 8, bbox_left);
				other.search_x2 = max(x + 8, bbox_right);
				other.search_y1 = min(y - 8, bbox_top);
				other.search_y2 = max(y + 8, bbox_bottom);
				mask_index = m;
			}
			if(x != other.x || y != other.y - other.z){
				x = other.x;
				y = other.y - other.z;
				xprevious = x;
				yprevious = y;
				
				 // Update Object Auto-Topify Range (copy-paste edition):
				var m = mask_index;
				mask_index = -1;
				other.search_x1 = min(x - 8, bbox_left);
				other.search_x2 = max(x + 8, bbox_right);
				other.search_y1 = min(y - 8, bbox_top);
				other.search_y2 = max(y + 8, bbox_bottom);
				mask_index = m;
			}
			
			 // Disable Hitbox:
			if(mask_index != mskNone && other.override_mask){
				other.target_save.mask_index = mask_index;
				mask_index = mskNone;
			}
			
			 // Disable Shadow:
			if("spr_shadow" in self && spr_shadow != -1){
				other.target_save.spr_shadow = spr_shadow;
				spr_shadow = -1;
			}
			
			 // Depth:
			if(depth != other.depth){
				other.target_save.depth = depth;
				depth = other.depth;
			}
			
			 // Disable Death:
			if("canfly" in self && !canfly){
				other.target_save.canfly = canfly;
				canfly = true;
			}
		}
		
		 // Jumping:
		if(zfriction != 0){
			zspeed -= zfriction * current_time_scale;
			
			if(z < 8){
				if(place_meeting(x, y, Floor)) with(target){
					mask_index = lq_defget(other.target_save, "mask_index", mask_index);
					if(place_meeting(x, y, Wall)) mask_index = mskNone;
				}
				
	    		 // Depth:
				if(z > 0){
					if(!collision_rectangle(bbox_left + 4, bbox_top + 8 - z, bbox_right - 4, bbox_bottom - z, Wall, false, false)){
						depth = min(-1, lq_defget(target_save, "depth", 0));
						target.depth = depth;
					}
				}
				
				 // Landing:
				else{
					if(!instance_exists(NothingSpiral) || place_meeting(x, y, Floor)){
						instance_destroy();
					}
					
					 // Abyss Time:
					else{
						depth = max(12, depth);
						target.depth = depth;
						if(!point_seen(x, bbox_top - z, -1)){
							with(target) instance_delete(id);
							instance_delete(id);
						}
					}
				}
			}
		}
		
		 // Enemy Stuff:
		else if(is_enemy){
			if(idle_time > 0) idle_time -= current_time_scale;
			else{
				 // Time to Jump Off:
				if(jump_time == 0){
					with(target){
						if("walk" not in self || walk <= 0 || instance_is(self, Freak) || instance_is(self, ExploFreak)){
							idle_time = 10 + random(20);
							
							var n = (instance_exists(Player) ? instance_nearest(other.x, other.y, Player) : instance_nearest(other.x - 16, other.y - 16, Floor));
							direction = point_direction(x, y, n.x, n.y - 8);
							speed += current_time_scale;
							
							if("walk" in self) walk = idle_time;
							if("gunangle" in self) gunangle = direction;
							if("right" in self) scrRight(direction);
						}
					}
				}
				
				 // Idling:
				else{
					idle_time = random_range(idle_wait[0], idle_wait[1]);
					
					var n = instance_nearest(x, y, Player);
					
					with(target){
						 // Face Player:
						if(instance_exists(n)){
							var d = point_direction(x, y, n.x, n.y - 8) + orandom(5);
						    if("gunangle" in self) gunangle = d;
						    if("right" in self){
								if("gunangle" not in self) direction = d;
						    	scrRight(d);
						    }
						 }
						
						 // Wander:
						if(chance(other.idle_walk_chance, 1)){
						    direction = random(360);
							if("walk" in self){
								walk = random_range(other.idle_walk[0], other.idle_walk[1]);
							}
						}
						
						 // Cold:
						if(GameCont.area == 5 && chance(2, 3)){
							with(instance_create(x, y, Breath)){
								image_xscale = sign(other.image_xscale) * variable_instance_get(other, "right", 1);
								depth = -8;
							}
						}
					}
					
					 // Let's Roll:
					if(chance(1, 5) && in_distance(n, 160)){
						jump_time = 1;
					}
				}
			}
			
			 // Time Until Jump Off:
			if(jump_time > 0){
				jump_time -= current_time_scale;
				if(jump_time <= 0){
					jump_time = 0;
					
					 // Cmon Bros:
					with(instances_matching(object_index, "name", name)){
						if(instance_exists(target) && target.object_index == other.target.object_index && in_distance(other, 64)){
							jump_time = 0;
							idle_time = random_range(10, 60);
						}
					}
				}
			}
		}
		
		 // Damage Stuff:
		else if(is_damage){
			with(target){
				var	_inst = id,
					_saveMask = mask_index;
					
				mask_index = lq_defget(other.target_save, "mask_index", mask_index);
				
				with(instances_matching_ne(instance_rectangle(x - 32, y - 32, x + 32, y + 32, instances_matching(other.object_index, "name", other.name)), "id", other)){
					with(target) if(instance_is(self, hitme)){
						var m = mask_index;
						mask_index = lq_defget(other.target_save, "mask_index", mask_index);
						
						if(place_meeting(x, y, _inst)){
							with(_inst){
								event_perform(ev_collision, hitme);
							}
							if(!instance_exists(self)) break;
							if(!instance_exists(other)) exit;
						}
						
						mask_index = m;
					}
				}
				
				mask_index = _saveMask;
			}
		}
	}
	
	 // Target Destroyed:
	else{
		if(target != noone) target = noone; // basically just to give a 1 frame delay
		else instance_destroy();
	}
	
#define TopObject_destroy
	with(target){
		x = other.x;
		y = other.y;
		xprevious = x;
		yprevious = y;
		xstart = x;
		ystart = y;
		top_object = noone;
		
		 // Unwobble:
		if(other.wobble_num != 0){
			image_angle = 0;
		}
		
		 // Restore Vars:
		for(var i = 0; i < lq_size(other.target_save); i++){
			variable_instance_set(id, lq_get_key(other.target_save, i), lq_get_value(other.target_save, i));
		}
		
		 // Not today, Walls:
		if(other.unstick && place_meeting(x, y, Wall)){
			if(point_distance(x, y, other.jump_x, other.jump_y) < 8 * other.speed){
				if(!place_meeting(other.jump_x, other.jump_y, Wall)){
					x = other.jump_x;
					y = other.jump_y;
				}
				else{
					if(!place_meeting(other.jump_x, y, Wall)) x = other.jump_x;
					if(!place_meeting(x, other.jump_y, Wall)) y = other.jump_y;
				}
				if(!place_meeting(x, y, Floor)){
					with(instance_nearest(x - 16, y - 16, Floor)){
						other.x = (bbox_left + bbox_right + 1) / 2;
						other.y = (bbox_top + bbox_bottom + 1) / 2;
					}
				}
			}
			
			 // Emergency:
			if(place_meeting(x, y, Wall)){
				with(instance_create(x, y, PortalClear)){
					mask_index = other.mask_index;
					sprite_index = other.sprite_index;
					image_xscale = other.image_xscale;
					image_yscale = other.image_yscale;
					image_angle = other.image_angle;
				}
				
				 // Emergency+:
				with(instance_nearest(x - 16, y - 16, Floor)){
					var	_fx = (bbox_left + bbox_right + 1) / 2,
						_fy = (bbox_top + bbox_bottom + 1) / 2,
						_wall = noone;
						
					do{
						with(_wall){
							with(instance_create(x, y, FloorExplo)){
								 // Visual Fix:
								with(instances_matching_gt(Wall, "id", id)) visible = false;
							}
							instance_destroy();
						}
						_wall = collision_line(other.x, other.y, _fx, _fy, Wall, false, false);
					}
					until !instance_exists(_wall);
				}
			}
		}
		
		 // Effects:
		if("spr_shadow" in self){
			var _num = abs(sprite_width / 4) + irandom(2);
			for(var d = direction; d < direction + 360; d += (360 / _num)){
				var _obj = (chance(1, 8) ? Debris : Dust);
				with(instance_create(x, y, Dust)){
					motion_add(d + orandom(20), random_range(2, 4));
					hspeed += other.hspeed / 2;
					vspeed += other.vspeed / 2;
					depth = max(depth, other.depth);
				}
			}
			view_shake_max_at(x, y, 6);
		}
		
		 // Sounds:
		if(!area_get_underwater(GameCont.area)){
			if(instance_is(self, hitme)){
				sound_play_hit_ext(sndAssassinHit, 1 + orandom(0.3), abs(other.zspeed) / 8);
			}
			else if(instance_is(self, chestprop)){
				sound_play_hit_ext(sndWeaponChest, 0.5 + random(0.2), 0.8);
			}
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
    instance_create(x, y, ScorpionBulletHit);


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

					with(instance_nearest_array(_x, _y, array_combine(instances_matching(Player, "wep", _wep), instances_matching(Player, "bwep", _wep)))){
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
    
	 // Top Object Floor-Collision:
	var	_topObject = instances_matching(instances_matching(CustomObject, "name", "TopObject"), "zfriction", 0),
		_topRaven = instances_matching_gt(instances_matching(CustomObject, "name", "NestRaven"), "alarm1", 1);
		
	with(instance_rectangle(global.floor_left - 8, global.floor_top - 8, global.floor_right + 8, global.floor_bottom + 8, _topRaven)){
		if(position_meeting(x, y + 8, Floor) && !position_meeting(x, y + 8, Wall)){
			alarm1 = 1;
			force_spawn = true;
		}
	}
	with(instance_rectangle_bbox(global.floor_left - 16, global.floor_top - 16, global.floor_right + 16, global.floor_bottom + 16, instances_matching_gt(_topObject, "grav", 0))){
		if(place_meeting(x + mask_x, y + mask_y, Floor)){
			 // Wobble:
			if(wobble != 0 && place_meeting(x + mask_x, y + mask_y, Wall)){
	    		var	_wobWest = position_meeting(bbox_left, y, Floor),
	    			_wobEast = position_meeting(bbox_right, y, Floor);
	    			
	    		if(_wobWest || _wobEast){
	    			var _wobMove = ((_wobWest - _wobEast) - wobble_num) * 0.1 * current_time_scale;
	    			wobble_num += _wobMove;
	    			
	    			with(target){
	    				image_angle += other.wobble * _wobMove;
	    				image_angle += (other.wobble / 16) * sin(current_frame / 10) * other.wobble_num;
	    			}
	    		}
			}
			
			 // Jump to Ground:
			else{
				if(instance_exists(target)){
					jump_x = x;
					jump_y = y;
					
					 // Find Open Space to Jump, if Possible:
					if(unstick) with(target){
						var	_disMin = 5 * max(speed, other.maxspeed),
							_disMax = 4 * _disMin,
							_dir = other.direction,
							_sx = x + lengthdir_x(_disMin, _dir),
							_sy = y + lengthdir_y(_disMin, _dir),
							_tx = _sx,
							_ty = _sy,
							_saveMask = mask_index;
							
						mask_index = lq_defget(other.target_save, "mask_index", mask_index);
						
						if(!place_meeting(_tx, _ty, Floor) || place_meeting(_tx, _ty, Wall)){
							with(instance_rectangle_bbox(x - _disMax - 1, y - _disMax - 1, x + _disMax, y + _disMax, Floor)){
								with(other){
									for(var _fx = other.bbox_left; _fx < other.bbox_right + 1; _fx += 8){
										for(var _fy = other.bbox_top; _fy < other.bbox_bottom + 1; _fy += 8){
											if(!place_meeting(_fx, _fy, Wall)){
												var _dis = point_distance(x, y, _fx, _fy);
												if(_dis < _disMax || (_dis > _disMin && _disMax < _disMin)){
													if(abs(angle_difference(point_direction(x, y, _fx, _fy), _dir)) < 90){
														_disMax = _dis;
														_tx = _fx;
														_ty = _fy;
													}
												}
											}
										}
									}
								}
							}
						}
						
						mask_index = _saveMask;
						
						other.jump_x = _tx;
						other.jump_y = _ty;
					}
					
					 // Jump to Target Position:
					zfriction = grav;
					zspeed = jump * ((target.speed > 0) ? 1 : 2/3);
					direction = point_direction(x, y, jump_x, jump_y);
					var d = point_distance(x, y, jump_x, jump_y);
					speed = min(maxspeed + target.friction, (sqrt(max(0, sqr(d) * ((2 * zfriction * z) + sqr(zspeed)))) - (d * zspeed)) / (2 * z));
					
					 // Facing:
					if(speed > 0){
						with(target){
							if("gunangle" in self) gunangle = other.direction;
							if("right" in self) scrRight(other.direction);
						}
					}
					
					 // Sound:
					sound_play_hit_ext(sndAssassinAttack, 1 + orandom(0.4), abs(zspeed) / 6);
				}
			}
		}
		
		 // Unwobble:
    	else if(wobble_num != 0){
    		wobble_num -= wobble_num * 0.5 * current_time_scale;
    		with(target) image_angle -= image_angle * 0.5 * current_time_scale;
    		
    		if(abs(wobble_num) < 0.5){
    			wobble_num = 0;
    			with(target) image_angle = 0;
    		}
    	}
	}
	
	 // Top Object Emergency Activation:
	if(instance_exists(NothingSpiral)){ /* Throne II Abyss */
		with(_topObject){
			 // Delete if directly above any floors cause the portal background & floor stalactites draw at the same depth :(
			if(array_length(instances_matching_gt(instances_matching_lt(instances_matching_gt(Floor, "bbox_top", y), "bbox_left", x), "bbox_right", x)) > 0){
				if(instance_exists(target)) instance_delete(target);
			}
			
			 // Fall Into Abyss:
			else{
				zspeed = jump;
				zfriction = grav;
				if(instance_is(self, hitme)){
					motion_add(random(360), 2);
				}
			}
		}
		with(_topRaven){
			alarm1 = 1;
			force_spawn = true;
		}
	}
	else{ /* Not Many Enemies */
		var	_idleTopObject = instances_matching_gt(instances_matching(_topObject, "is_enemy", true), "jump_time", 60),
			_idleTopRaven = instances_matching_ne(_topRaven, "force_spawn", true);
			
		if(instance_number(enemy) - array_length(_idleTopObject) + (array_length(_topRaven) - array_length(_idleTopRaven)) < 5 * (1 + GameCont.loops) * (1 + (crown_current == crwn_blood))){
			with(instance_random(array_combine(_idleTopObject, _idleTopRaven))){
				switch(name){
					case "TopObject":
						jump_time = random_range(1, 60);
						break;
						
					case "NestRaven":
						alarm1 = 1;
						force_spawn = true;
						break;
				}
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
	
	 // Auto-Topify New Objects:
	with(TopObjectSearch){
		var _object = self;
		if(instance_exists(_object)){
			var _lastID = TopObjectSearchMap[? _object];
			if(_object.id > _lastID){
				TopObjectSearchMap[? _object] = _object.id;
				
				var _topObject = instances_matching(CustomObject, "name", "TopObject");
				
				if(array_length(_topObject) > 0){
					with(array_flip(instances_matching(instances_matching_gt(_object, "id", _lastID), "z", null))){
						if(
							!position_meeting(x, y, Floor)
							||
							(place_meeting(x, y, Wall) && (instance_is(self, hitme) || instance_is(self, chestprop) || instance_is(self, Corpse) || instance_is(self, ChestOpen)))
						){
							with(
								instances_matching_ge(
								instances_matching_le(
								instances_matching_ge(
								instances_matching_le(
								_topObject,
								"search_x1", x),
								"search_x2", x),
								"search_y1", y),
								"search_y2", y)
							){
								//if(array_length(instances_meeting(x, y, instances_matching_lt([PortalClear, PortalShock], "id", other))) <= 0){
									if(
										"creator" not in other
										|| !instance_exists(other.creator)
										|| other.creator == target
										|| !instance_exists(target)
										|| ("target" in other && other.target == target)
									){
										with(other){
											 // Effects:
											if(instance_is(self, Effect) && !instance_is(self, ChestOpen) && !instance_is(self, Debris) && !instance_is(self, Scorchmark)){
												if(instance_is(self, MeltSplat)){
													instance_destroy();
												}
												else depth = min(depth, -6.01);
											}
											else if(instance_is(self, SharpTeeth)){
												depth = min(depth, -8);
											}
											
											 // Epic Stuff:
											else if(fork()){
												if(instance_is(self, hitme) || instance_is(self, projectile)){
													var _wall = instances_meeting(x, y, Wall);
													wait 0;
													if(!instance_exists(self) || array_length(instances_matching(_wall, "", null)) < array_length(_wall)){
														exit;
													}
												}
												top_create(x, y, id, 0, 0);
												exit;
											}
										}
										
										break;
									}
									
									if(!instance_exists(other)) break;
								//}
							}
						}
					}
				}
			}
		}
	}
	
	 // Teamify Deflections:
	with(instances_matching([Slash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, LightningSlash, CustomSlash, CrystalShield, PopoShield], "", null)){
		x += hspeed_raw;
		y += vspeed_raw;
		
		var o = 32;
		with(instance_rectangle_bbox(bbox_left - o, bbox_top - o, bbox_right + o, bbox_bottom + o, instances_matching_ne(instances_matching(projectile, "typ", 1), "team", team))){
			if(place_meeting(x + hspeed_raw, y + vspeed_raw, other)){
				if(sprite_get_team(sprite_index) != 3 && fork()){
					var	t = other.team,
						h = other.hitid;
						
					wait 0;
					
					if(instance_exists(self) && team == t){
						if(hitid == -1) hitid = h;
						team_instance_sprite(((team == 3) ? 1 : team), self);
					}
					
					exit;
				}
			}
		}
		
		x -= hspeed_raw;
		y -= vspeed_raw;
	}
	
	if(DebugLag) trace_time("tegeneral_step_post");
	
#define draw_bloom
	if(DebugLag) trace_time();
	
	 // Custom Bullets/Plasma:
    with(instances_matching(CustomProjectile, "name", "CustomBullet", "CustomPlasma")){
        draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
    }
	
	 // Custom Shells/Flak:
    with(instances_matching(CustomProjectile, "name", "CustomFlak", "CustomShell")){
        if(bonus){
        	draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.3 * image_alpha);
        }
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
	with(instances_matching(CustomProjectile, "name", "PortalBullet")){
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
		var _inst = instance_rectangle_bbox(global.floor_left, global.floor_top, global.floor_right, global.floor_bottom, instances_matching_ne(instances_matching(CustomObject, "name", "TopObject", "NestRaven"), "spr_shadow", -1))
		with(instances_matching(_inst, "name", "TopObject")){
			var	_xsc = image_xscale,
				_ysc = image_yscale;
				
			image_xscale = 1;
			image_yscale = 1;
			
			if(place_meeting(x + spr_shadow_x, y + spr_shadow_y, Floor) && visible && variable_instance_get(target, "visible", false)){
				draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
			}
			
			image_xscale = _xsc;
			image_yscale = _ysc;
		}
		
		 // Top Ravens:
		with(instances_matching(_inst, "name", "NestRaven")){
			if(position_meeting(x, bbox_bottom, Floor) && visible){
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
		_inst = instances_matching_ne(
			instances_matching_ge(
				instances_matching(
					array_combine(
						instances_matching(CustomObject, "name", "TopObject", "NestRaven"),
						instances_matching(CustomProjectile, "name", "MortarPlasma")
					),
					"visible", true
				),
				"z", 8
			),
			"spr_shadow", -1
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
#define area_generate(_x, _y, _area)                                                    return  mod_script_call_nc('mod', 'telib', 'area_generate', _x, _y, _area);
#define area_border(_y, _area, _color)                                                  return  mod_script_call_nc('mod', 'telib', 'area_border', _y, _area, _color);
#define floor_get(_x, _y)                                                               return  mod_script_call_nc('mod', 'telib', 'floor_get', _x, _y);
#define floor_set(_x, _y, _state)                                                       return  mod_script_call_nc('mod', 'telib', 'floor_set', _x, _y, _state);
#define floor_fill(_x, _y, _w, _h)                                                      return  mod_script_call_nc('mod', 'telib', 'floor_fill', _x, _y, _w, _h);
#define floor_fill_round(_x, _y, _w, _h)                                                return  mod_script_call_nc('mod', 'telib', 'floor_fill_round', _x, _y, _w, _h);
#define floor_fill_ring(_x, _y, _w, _h)                                                 return  mod_script_call_nc('mod', 'telib', 'floor_fill_ring', _x, _y, _w, _h);
#define floor_make(_x, _y, _obj)                                                        return  mod_script_call_nc('mod', 'telib', 'floor_make', _x, _y, _obj);
#define floor_set_style(_style, _area)                                                  return  mod_script_call_nc('mod', 'telib', 'floor_set_style', _style, _area);
#define floor_reset_style()                                                             return  mod_script_call_nc('mod', 'telib', 'floor_reset_style');
#define floor_reveal(_floors, _maxTime)                                                 return  mod_script_call_nc('mod', 'telib', 'floor_reveal', _floors, _maxTime);
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
#define weapon_decide_gold(_minhard, _maxhard, _nowep)                                  return  mod_script_call_nc('mod', 'telib', 'weapon_decide_gold', _minhard, _maxhard, _nowep);
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