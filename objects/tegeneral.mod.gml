#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.save = mod_variable_get("mod", "teassets", "save");

    global.poonRope = [];

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.save
#macro opt sav.option

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)


#define BigDecal_create(_x, _y)
    var a = string(GameCont.area);
    if(lq_exists(spr.BigTopDecal, a)){
		with(instance_create(_x, _y, CustomObject)){
		     // Visual:
		    sprite_index = lq_get(spr.BigTopDecal, a);
			image_xscale = choose(-1, 1);
			image_speed = 0.4;
			depth = -8;

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
    				my_raven = [];
					repeat(3){
						with(instance_create(x, y, Raven)){
							image_index = irandom(image_number - 1);

							var _tries = 100,
								_x = 0,
								_y = 0;

							while(_tries-- > 0){
								_x = random_range(-12, 12);
								_y = (chance(1, 4) ? -12 : random(16));
								x = other.x + _x;
								y = other.y + _y;

								var n = nearest_instance(x, y, instances_matching_ne(Raven, "id", id));
								if(!instance_exists(n) || point_distance(x, y, n.x, n.y) > 16){
									break;
								}
							}

							array_push(other.my_raven, {
								inst : id,
								x : _x,
								y : _y
							});
						}
					}
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
        	case 3:
        		var _ravenNum = array_length(my_raven);
        		with(my_raven){
        			var _x = other.x + (x * other.image_xscale),
        				_y = other.y + y;

        			 // Fix:
        			if(instance_is(inst, RavenFly)){
        				with(inst){
        					instance_change(Raven, false);
        				}
    				}

        			with(inst){
	        			x = _x;
	        			y = _y;
	        			sprite_index = spr_idle;
	        			mask_index = mskNone;
	        			canfly = true;
	        			wkick = 10000;
	        			alarm1 = -1;

	        			 // Lookin:
						if(chance_ct(1, 80)){
							right = choose(-1, 1);
							if(instance_exists(Player)){
								var t = instance_nearest(x, y, Player);
								scrRight(point_direction(x, y, t.x, t.y));
							}
						}

	        			 // Fly to Player:
	        			if(!instance_is(self, RavenFly)){
	        				if(chance_ct(1, 100) || instance_number(enemy) <= _ravenNum + 2){
								var t = instance_nearest(x, y, Player);
			        			if(in_distance(t, 128)){
									scrRight(point_direction(x, y, t.x, t.y));
	
			        				var _x = t.x,
			        					_y = t.y;
	
		        					mask_index = mskBandit;
									if(place_meeting(_x, _y, Wall)){
										with(instance_rectangle_bbox(t.x - 16, t.y - 16, t.x + 16, t.y + 16, Floor)){
					        				_x = ((bbox_left + bbox_right) / 2) + orandom(4);
					        				_y = ((bbox_top + bbox_bottom) / 2) + orandom(4);
	
					        				var b = false;
											with(other) if(!place_meeting(_x, _y, Wall)){
												b = true;
											}
											if(b) break;
										}
									}
	
									if(!place_meeting(_x, _y, Wall)){
				        				instance_change(RavenFly, false);
				        				sprite_index = sprRavenLift;
				        				image_index = 0;
				        				targetx = _x;
				        				targety = _y;

				        				mask_index = mskBandit;
			        					canfly = false;
				        				wkick = 4;
			
				        				 // Effects:
				        				repeat(6){
											with(scrFX([x, 8], y + random(16), 3 + random(1), Dust)){
												depth = -9;
											}
										}
				        				sound_play(sndRavenLift);
									}
									else mask_index = mskNone;
			        			}
	        				}
	        			}
        			}
	        		if(instance_is(inst, RavenFly)){
	        			other.my_raven = array_delete_value(other.my_raven, self);
	        		}
        		}
        		break;

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
     // Nest Ravens:
    if("my_raven" in self){
    	var r = [];
	    with(my_raven) with(inst) array_push(r, [id, depth]);
	    array_sort_sub(r, 1, false);

	    with(r) with(self[0]){
	    	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * right, image_yscale, image_angle, merge_color(image_blend, c_black, 0.2), image_alpha);
	    }
    }

	 // Flying Ravens:
    with(instance_rectangle(bbox_left, bbox_top - 32, bbox_right, bbox_bottom + 64, RavenFly)){
    	draw_sprite_ext(sprite_index, image_index, x, y + z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
    }

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

		case 3: // Ravens
			with(my_raven){
				with(inst){
					sound_play(sndRavenScreech);

					mask_index = mskBandit;
					canfly = false;
					wkick = 4;

					 // Fly:
					if(chance(1, 2)){
						var _tries = 100,
							_tx = 0,
							_ty = 0,
							o = 96;

						while(_tries-- > 0){
							with(instance_random(instance_rectangle_bbox(x - o, y - o, x + o, y + o, instances_matching_ne(Floor, "object_index", FloorExplo)))){
								_tx = x + 16;
								_ty = y + 16;
							}
							if(!place_meeting(_tx, _ty, Wall)) break;
							o += 16;
						}

						if(_tries > 0){
							sound_play(sndRavenLift);
							instance_change(RavenFly, false);
							sprite_index = sprRavenLift;
							image_index = 0;
							targetx = _tx;
							targety = _ty;
						}
					}

					 // Don Fly:
					if(!instance_is(self, RavenFly)){
						x = _x + orandom(8);
						y = _y + 8 + orandom(4);
						xprevious = x;
						yprevious = y;
					}
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

        if(fork()){
        	wait 0;
        	if(instance_exists(self) && big){
        		target = [];
        		sprite_index = spr.BubbleBombBig;
        		mask_index = mskExploder;
        	}
        	exit;
        }

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
		        with(instances_meeting(x, y, instances_matching_ge(instances_named(object_index, name), "big", big))){
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

#define BubbleBomb_end_step
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
    if(z < 24 && (is_array(target) || !instance_exists(target))){
    	if(place_meeting(x, y, projectile) || place_meeting(x, y, enemy)){
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
	                if(object_index == Flame || object_index == Bolt || object_index == Splinter || object_index == HeavyBolt || object_index == UltraBolt){
	                    with(other) instance_destroy();
	                }
	                else{
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
	                }
	
	                break;
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
             // Call Chest Open Event:
            var e = on_open;
            if(mod_script_exists(e[0], e[1], e[2])){
                mod_script_call(e[0], e[1], e[2], (i == 0));
            }

             // Effects:
            with(instance_create(x, y, ChestOpen)) sprite_index = other.spr_open;
            instance_create(x, y, FXChestOpen);
            sound_play(snd_open);

            instance_destroy();
        }
        break;
    }


#define Harpoon_create(_x, _y)
    with(instance_create(_x, _y, CustomProjectile)){
         // Visual:
        sprite_index = spr.Harpoon;
        image_speed = 0;
        mask_index = mskBolt;

         // Vars:
    	creator = noone;
    	target = noone;
    	rope = noone;
    	pull_speed = 0;
    	canmove = 1;
    	damage = 3;
    	force = 8;
    	typ = 1;
    	blink = 30;

    	return id;
    }

#define Harpoon_end_step
     // Trail:
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

#define Harpoon_step
     // Stuck in Target:
    var _targ = target;
    if(instance_exists(_targ)){
        if(canmove){
            var _odis = 16,
                _odir = image_angle;

            x = _targ.x - lengthdir_x(_odis, _odir);
            y = _targ.y - lengthdir_y(_odis, _odir);
            xprevious = x;
            yprevious = y;
            visible = _targ.visible;
        }

         // Pickup-able:
        if(alarm0 < 0){
            image_index = 0;

            var _pickup = 1;
            with(rope) if(!broken) _pickup = 0;
            if(_pickup){
                alarm0 = 200 + random(20);
                if(GameCont.crown == crwn_haste) alarm0 /= 3;
            }
        }
        else if(instance_exists(Player)){
             // Shine:
            image_speed = ((image_index < 1) ? random(0.04) : 0.4);

             // Attraction:
            var p = instance_nearest(x, y, Player);
            if(point_distance(x, y, p.x, p.y) < (skill_get(mut_plutonium_hunger) ? 100 : 50)){
                canmove = 0;

                var _dis = 10,
                    _dir = point_direction(x, y, p.x, p.y);

                x += lengthdir_x(_dis, _dir);
                y += lengthdir_y(_dis, _dir);
                xprevious = x;
                yprevious = y;

                 // Pick Up Bolt Ammo:
                if(place_meeting(x, y, p) || place_meeting(x, y, Portal)){
                    with(p){
                        ammo[3] = min(ammo[3] + 1, typ_amax[3]);
                        instance_create(x, y, PopupText).text = "+1 BOLTS";
                        sound_play(sndAmmoPickup);
                    }
                    instance_destroy();
                }
            }
        }
    }

    else{
         // Rope Length:
        with(rope) if(!harpoon_stuck){
            if(instance_exists(link1) && instance_exists(link2)){
                length = point_distance(link1.x, link1.y, link2.x, link2.y);
            }
        }

        if(speed > 0){
             // Bolt Marrow:
            if(skill_get(mut_bolt_marrow)){
                var n = instance_nearest(x, y, enemy);
                if(distance_to_object(n) < 16 && !place_meeting(x, y, n)){
                    direction = point_direction(x, y, n.x, n.y);
                    image_angle = direction;
                }
            }

             // Stick in Chests:
            var c = instance_nearest(x, y, chestprop);
            if(place_meeting(x, y, c)) scrHarpoonStick(c);
        }

        else instance_destroy();
    }

#define Harpoon_hit
    if(speed > 0){
        if(projectile_canhit(other)){
            projectile_hit_push(other, damage, force);

             // Stick in enemies that don't die:
            if(other.my_health > 0){
                if(
                    (instance_is(other, prop) && other.object_index != RadChest)
                    ||
                    ("name" in other && name == "CoastDecal")
                ){
                    canmove = 0;
                }
                scrHarpoonStick(other);
            }
        }
    }

#define Harpoon_wall
    if(speed > 0){
        move_contact_solid(direction, 16);
        instance_create(x, y, Dust);
        sound_play(sndBoltHitWall);

         // Stick in Wall:
        canmove = 0;
        scrHarpoonStick(other);
    }

#define Harpoon_alrm0
     // Blinking:
    if(blink-- > 0){
        alarm0 = 2;
        visible = !visible;
    }
    else instance_destroy();

#define Harpoon_destroy
    scrHarpoonUnrope(rope);

#define draw_rope(_rope)
    with(_rope) if(instance_exists(link1) && instance_exists(link2)){
        var _x1 = link1.x,
            _y1 = link1.y,
            _x2 = link2.x,
            _y2 = link2.y,
            _wid = clamp(length / point_distance(_x1, _y1, _x2, _y2), 0.1, 2),
            _col = merge_color(c_white, c_red, (0.25 + clamp(0.5 - (break_timer / 45), 0, 0.5)) * clamp(break_force / 100, 0, 1));

        draw_set_color(_col);
        draw_line_width(_x1, _y1, _x2, _y2, _wid);
    }
    instance_destroy();

#define scrHarpoonStick(_instance) /// Called from Harpoon
    speed = 0;
    target = _instance;

     // Set Rope Vars:
    pull_speed = (("size" in target) ? (2 / target.size) : 2);
    with(rope){
        harpoon_stuck = 1;

         // Deteriorate rope if only stuck in unmovable objects:
        var m = 1;
        with([link1, link2]) if("canmove" not in self || canmove) m = 0;
        if(m){
            deteriorate_timer = 60;
            length = point_distance(link1.x, link1.y, link2.x, link2.y);
        }
    }

#define scrHarpoonRope(_link1, _link2)
    var r = {
        link1 : _link1,
        link2 : _link2,
        length : 0,
        harpoon_stuck : 0,
        break_force : 0,
        break_timer : 90,
        creator : noone,
        deteriorate_timer : -1,
        broken : 0
    }
    global.poonRope[array_length(global.poonRope)] = r;
    with([_link1, _link2]) rope[array_length(rope)] = r;

    return r;

#define scrHarpoonUnrope(_rope)
    with(_rope){
        broken = 1;

        var i = 0,
            a = [],
            _ropeIndex = array_find_index(global.poonRope, self);

        for(var j = 0; j < array_length(global.poonRope); j++){
            if(j != _ropeIndex) a[i++] = global.poonRope[j];
        }

        global.poonRope = a;
    }


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
        charge_spd = 1;
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
        image_xscale += (charge / 20) * charge_spd * current_time_scale;
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
        x -= hspeed;
        y -= vspeed;
        direction = point_direction(x, y, other.x, other.y) + orandom(10);

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

        return id;
    }


#define NetNade_create(_x, _y)
    with(instance_create(_x, _y, CustomProjectile)){
         // Visual:
        sprite_index = spr.NetNade;
        image_speed = 0.4;

         // Vars:
        mask_index = sprGrenade;
        friction = 0.4;
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
    repeat(8) instance_create(x, y, Dust);
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
        o = 8, // Spawn Offset
        f = noone, // First Harpoon Created
        h = noone; // Latest Harpoon Created

    for(var a = _ang; a < _ang + 360; a += (360 / _num)){
        with(obj_create(x + lengthdir_x(o, a), y + lengthdir_y(o, a), "Harpoon")){
            motion_add(a + orandom(5), 22);
            image_angle = direction;
            team = other.team;
            creator = other.creator;
            if(direction > 90 && direction < 270) image_yscale = -1;

             // Explosion Effect:
            with(instance_create(x, y, MeleeHitWall)){
                motion_add(other.direction, 1 + random(2));
                image_angle = direction + 180;
                image_speed = 0.6;
            }

             // Link harpoons to each other:
            if(!instance_exists(f)) f = id;
            if(instance_exists(h)) scrHarpoonRope(id, h);
            h = id;
        }
    }
    scrHarpoonRope(f, h);


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
        stick_time_max = 60;
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
                    var n = instances_matching(instances_matching(instances_named(object_index, name), "target", target), "stick", true);
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
            //var d = (distance_to_object(target) / 50) + 1;
            //x += target.hspeed / d;
            //y += target.vspeed / d;

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
        surf_draw = -1;
        surf_draw_w = 64;
        surf_draw_h = 64;
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
		            motion_add(point_direction(other.x, other.y, x, y), 1);
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
	        with(instances_meeting(x, y, instances_named(object_index, name))){
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
    var	_option = lq_defget(opt, "outlinePets", 2),
    	_outline = (
	    	_option > 0												&&
	    	instance_exists(leader)									&&	
	    	player_is_local_nonsync(player_find_local_nonsync())	&&
	    	(_option < 2 || player_get_outlines(player_find_local_nonsync()))
    	);

    if(_outline){
        var _surf = surf_draw,
            _surfw = surf_draw_w,
            _surfh = surf_draw_h,
            _surfx = x - (_surfw / 2),
            _surfy = y - (_surfh / 2);

        if(!surface_exists(_surf)){
            _surf = surface_create(_surfw, _surfh)
            surf_draw = _surf;
        }

        surface_set_target(_surf);
        draw_clear_alpha(0, 0);

        x -= _surfx;
        y -= _surfy;
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
        x += _surfx;
        y += _surfy;

        surface_reset_target();

         // Fix coast stuff:
        if("wading" in self && wading != 0 && GameCont.area == "coast"){
            surface_set_target(mod_variable_get("area", "coast", "surfSwim"));
        }

        d3d_set_fog(1, player_get_color(leader.index), 0, 0);
        for(var a = 0; a <= 360; a += 90){
            var _x = _surfx,
                _y = _surfy;

            if(a >= 360) d3d_set_fog(0, 0, 0, 0);
            else{
                _x += dcos(a);
                _y -= dsin(a);
            }

            draw_surface(_surf, _x, _y);
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
	with(instances_named(CustomEnemy, "PortalPrevent")){
		instance_delete(id); // There can only be one
	}

	return instance_create(_x, _y, CustomEnemy);

#define PortalPrevent_step
	my_health = 99999;
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
        depth = -1;

         // Vars:
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
        line_dir_goal = 0;
        blast_hit = true;
        offset_dis		= 0;	// Offset from Creator Towards image_angle
        bend_fric		= 0.3;	// Multiplicative Friction for Line Bending
        line_dis_max	= 300;	// Max Possible Line Length
        turn_max		= 8;	// Max Rotate Speed
        turn_factor		= 1/8;	// Rotation Speed Increase Factor
        shrink_delay	= 0;	// Frames Until Shrink
        shrink			= 0.05;	// Subtracted from Line Size
        scale_goal		= 1;	// Size to Reach When shrink_delay > 0
        player_aim		= 1;	// gunangle Turning Speed Multiplier (1=No change)
        hold_x			= null;	// Stay at this X
        hold_y			= null; // Stay at this Y

		on_end_step = QuasarBeam_quick_fix;

        return id;
	}

#define QuasarBeam_quick_fix
	var l = line_dis_max;
	line_dis_max = 0;
	QuasarBeam_step();
	line_dis_max = l;

	on_end_step = [];

#define QuasarBeam_step
	hit_time += current_time_scale;

     // Shrink:
    if(shrink_delay <= 0){
	    var f = shrink * current_time_scale;
	    if(!instance_is(creator, enemy)){
	    	f *= power(0.7, skill_get(mut_laser_brain));
	    }
	    image_xscale -= f;
	    image_yscale -= f;
    }
    else{
    	shrink_delay -= current_time_scale;
    	if(shrink_delay <= 0 || !instance_exists(creator)){
    		shrink_delay = -1;
    	}

		 // Growin:
		if(abs(scale_goal - image_xscale) > 0.05 || abs(scale_goal - image_yscale) > 0.05){
			image_xscale += (scale_goal - image_xscale) * 0.4;
			image_yscale += (scale_goal - image_yscale) * 0.4;

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
			image_xscale = scale_goal;
			image_yscale = scale_goal;
		}
    }

	 // Player Stuff:
	if(instance_is(creator, Player)){
		with(creator){
			 // Kickback:
			if(other.shrink_delay > 0){
				var k = 8 * (1 + (max(other.image_xscale - 1, 0)));
				if(other.roids) bwkick = max(bwkick, k);
				else wkick = max(wkick, k);
			}
			
			 // Slow Aim:
			var a = other.player_aim;
			if(a != 1){
				var _beams = instances_matching(instances_named(other.object_index, other.name), "creator", id);
				if(array_length(instances_matching_lt(_beams, "player_aim", a)) <= 0 && instances_matching(_beams, "player_aim", a)[0] == other){
					var f = min(a / other.image_yscale, 1);
					if(f != 1 && other.image_yscale > 0){
			        	canaim = false;
			        	gunangle += angle_difference(point_direction(x, y, mouse_x[index], mouse_y[index]), gunangle) * f * current_time_scale;
			        	scrRight(gunangle);
					}
					else canaim = true;
				}
			}

        	 // Knockback:
        	motion_add(gunangle + 180, other.image_yscale / 2.5);
		}

	     // Follow Player:
    	var c = creator;
        line_dir_goal = c.gunangle;
        hold_x = c.x + c.hspeed;
        hold_y = c.y + c.vspeed;
        if(roids){
        	hold_y -= 6;
        	hold_x -= lengthdir_x(2 * c.right, c.gunangle - 90);
        	hold_y -= lengthdir_y(2 * c.right, c.gunangle - 90);
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
    var _turn = clamp(angle_difference(line_dir_goal, image_angle) * turn_factor, -turn_max, turn_max) * current_time_scale;
    image_angle += _turn;
    image_angle = (image_angle + 360) % 360;

	 // Bending:
    bend -= (bend * bend_fric) * current_time_scale;
    bend -= _turn;

     // Line:
    var _lineAdd = 1 + max(12, 20 * image_yscale),
        _lineWid = 16,
        _lineDir = image_angle,
        _lineChange = 120 * current_time_scale,
        _dis = 0,
        _dir = _lineDir,
        _dirGoal = _lineDir + bend,
        _cx = x,
        _cy = y,
        _lx = _cx - lengthdir_x((sprite_get_width(spr_strt) / 2) * image_xscale, _dir),
        _ly = _cy - lengthdir_y((sprite_get_width(spr_strt) / 2) * image_xscale, _dir),
        _walled = false;

    line_seg = [];
    line_dis += _lineChange;
    line_dis = clamp(line_dis, 0, line_dis_max);

	if(collision_line(_lx, _ly, _cx, _cy, TopSmall, false, false)){
		line_dis = 0;
	}

    do{
    	var _canBlastHit = false;

        if(!_walled){
        	if(collision_line(_lx, _ly, _cx, _cy, Wall, false, false)){
        		_walled = true;
        	}
        	else{
	    		 // Add to Line Draw:
        		var o = _lineAdd * 2;
        		if(point_seen_ext(_lx, _ly, o, o, -1)){
	        		for(var a = -1; a <= 1; a += 2){
		                var l = (_lineWid * a) + 6,
		                    d = _dir - 90,
		                    _xtex = (_dis / line_dis),
		                    _ytex = !!a;
		
		                array_push(line_seg, {
		                    x    : _cx,
		                    y    : _cy,
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
            _canBlastHit = true;
            line_dis -= _lineChange;
        	if(array_length(line_seg) <= 0) line_dis = 0;
        }

         // Hit Enemies:
        if(place_meeting(_cx, _cy, hitme)){
            with(instances_meeting(_cx, _cy, instances_matching_ne(hitme, "team", team))){
                if(place_meeting(x - (_cx - other.x), y - (_cy - other.y), other)){
                	with(other){
	                	if(lq_defget(hit_list, string(other), 0) <= hit_time){
	        				_canBlastHit = true;
	
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
		                    direction = _dir;
		                    QuasarBeam_hit();
	                	}
	            		if(!instance_exists(other) || other.my_health <= 0 || other.size >= ((image_yscale <= 1) ? 3 : 4) || blast_hit){
	            			line_dis = _dis;
	            		}
                	}
                }
            }
        }

         // Effects:
    	if(chance_ct(1, 160 / _lineAdd)){
        	var o = 32 * image_yscale;
	        with(instance_create(_cx + orandom(o), _cy + orandom(o), PlasmaTrail)){
	        	sprite_index = spr.QuasarBeamTrail;
	        	motion_add(_dir, 1 + random(max(other.image_yscale - 1, 0)));
	        	if(other.image_yscale > 1) depth = other.depth - 1;
	        }
    	}

		 // Move:
        _lx = _cx;
        _ly = _cy;
        _cx += lengthdir_x(_lineAdd, _dir);
        _cy += lengthdir_y(_lineAdd, _dir);
        _dis += _lineAdd;

		 // Turn:
        _dir = clamp(_dir + (bend / (48 / _lineAdd)), _lineDir - 90, _lineDir + 90);

         // Blastin FX:
		if(blast_hit){
			if(_canBlastHit || _dis >= line_dis_max){
				blast_hit = false;
				/*repeat(8){
			        with(instance_create(_lx, _ly, PlasmaTrail)){
			        	motion_add(_dir + 180 + orandom(90), random(8 * other.image_yscale));
			        	sprite_index = spr.QuasarBeamTrail;
			        }
				}*/
				// insert plasma explo stuff?
			}
		}
    }
    until (_dis >= line_dis);

     // Effects:
    if(chance_ct(1, 4)){
        var _xoff = orandom(12) - ((8 * image_xscale) + _lineAdd),
    		_yoff = orandom(random(28 * image_yscale));

        with(instance_create(
        	_lx + lengthdir_x(_xoff, _dir) + lengthdir_x(_yoff, _dir - 90),
        	_ly + lengthdir_y(_xoff, _dir) + lengthdir_y(_yoff, _dir - 90),
        	BulletHit
        )){
        	sprite_index = spr.QuasarBeamHit;
        	image_angle = _dir + 180
        	image_angle += random(angle_difference(point_direction(_lx, _ly, x, y), image_angle));
        	image_xscale = other.image_yscale;
        	image_yscale = other.image_yscale;
        	depth = other.depth - 1;
        }
        instance_create(_lx, _ly, Smoke);
    }
    view_shake_max_at(x, y, 4);
    view_shake_max_at(_cx, _cy, 4);

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

#define QuasarBeam_hit
    if(lq_defget(hit_list, string(other), 0) <= hit_time){
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
        if(place_meeting(x, y, other)){
            _dir = point_direction(x, y, other.x, other.y);
        }
        projectile_hit(
        	other,
        	ceil((damage + (blast_hit * damage * (1 + skill_get(mut_laser_brain)))) * image_yscale),
        	(instance_is(other, prop) ? 0 : force),
        	_dir
        );

         // Set Custom IFrames:
        lq_set(hit_list, string(other), hit_time + 6);
    }

#define QuasarBeam_wall
    // dust

#define QuasarBeam_cleanup
	if(player_aim != 1){
		with(creator) canaim = true;
	}
	audio_stop_sound(loop_snd);

#define QuasarBeam_draw_laser(_xscale, _yscale, _alpha)
	var _angle = image_angle,
		_x = x,
		_y = y;

    draw_sprite_ext(spr_strt, image_index, _x, _y, _xscale, _yscale, _angle, image_blend, _alpha);

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
    var o = 16;
    if(!position_meeting(x - lengthdir_x(o, _angle), _y - lengthdir_y(o, _angle), TopSmall)){
    	draw_sprite_ext(spr_stop, image_index, _x, _y, min(_xscale, 1.25), _yscale, _angle, image_blend, _alpha);
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
        	_ty = target_y;

		if((instance_exists(target) || point_distance(x, y, _tx, _ty) < dist_max + 32) && !collision_line(x, y, _tx, _ty, Wall, false, false)){
			with(creator){
				lightning_connect(other.x, other.y, _tx, _ty, (point_distance(other.x, other.y, _tx, _ty) / 4) * sin(other.wave / 90), false);
			}

			 // Hit FX:
			if(!place_meeting(_tx, _ty, LightningHit)){
				with(instance_create(_tx, _ty, LightningHit)){
					image_speed = 0.2 + random(0.2);
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


/// Mod Events
#define game_start
    with(instances_named(CustomObject, "Pet")) instance_destroy();

#define step
     // Harpoon Connections:
    for(var i = 0; i < array_length(global.poonRope); i++){
        var _rope = global.poonRope[i],
            _link1 = _rope.link1,
            _link2 = _rope.link2;

        if(instance_exists(_link1) && instance_exists(_link2)){
            var _length = _rope.length,
                _linkDis = point_distance(_link1.x, _link1.y, _link2.x, _link2.y) - _length,
                _linkDir = point_direction(_link1.x, _link1.y, _link2.x, _link2.y);

             // Pull Link:
            if(_linkDis > 0) with([_link1, _link2]){
                if("name" in self && name == "Harpoon"){
                    if(canmove) with(target){
                        var _pull = other.pull_speed,
                            _drag = min(_linkDis / 3, 10 / (("size" in self) ? (size * 2) : 2));

                        hspeed += lengthdir_x(_pull, _linkDir);
                        vspeed += lengthdir_y(_pull, _linkDir);
                        x += lengthdir_x(_drag, _linkDir);
                        y += lengthdir_y(_drag, _linkDir);
                    }
                }
                _linkDir += 180;
            }

             // Deteriorate Rope:
            var _deteriorate = (_rope.deteriorate_timer == 0);
            if(_deteriorate) _rope.length *= 0.9;
            else if(_rope.deteriorate_timer > 0){
                _rope.deteriorate_timer -= min(1, _rope.deteriorate_timer);
            }

             // Rope Stretching:
            with(_rope){
                break_force = max(_linkDis, 0);

                 // Break:
                if(break_timer > 0) break_timer -= current_time_scale;
                else if(break_force > 100 || (_deteriorate && _length <= 1)){
                    if(_deteriorate) with([_link1, _link2]) image_index = 1;
                    else sound_play_pitch(sndHammerHeadEnd, 2);
                    scrHarpoonUnrope(_rope);
                }
            }

             // Draw Rope:
            script_bind_draw(draw_rope, 0, _rope);
        }
        else scrHarpoonUnrope(_rope);
    }

#define draw_bloom
    /*with(instances_named(CustomProjectile, "BubbleBomb")){
        draw_sprite_ext(sprite_index, image_index, x, y - z, 1.5 * image_xscale, 1.5 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
    }*/

	 // Lightning Discs:
    with(instances_named(CustomProjectile, "LightningDisc")){
        if(visible){
        	scrDrawLightningDisc(sprite_index, image_index, x, y, ammo, radius, 2, image_xscale, image_yscale, image_angle + rotation, image_blend, 0.1 * image_alpha);
        }
    }

	 // Quasar Beams:
    with(instances_named(CustomProjectile, "QuasarBeam")){
        if(visible){
        	var a = 0.1 * (1 + (skill_get(mut_laser_brain) * 0.5));
        	if(blast_hit) a *= 1.5 / image_yscale;
        	QuasarBeam_draw_laser(2 * image_xscale, 2 * image_yscale, a * image_alpha);
        }
    }

#define draw_shadows
    with(instances_named(CustomObject, "Pet")) if(visible){
        draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
    }

    with(instances_matching(instances_named(CustomProjectile, "BubbleBomb"), "big", true)) if(visible){
    	var	f = min((z / 6) - 4, 6),
    		w = max(6 + f, 0) + sin((x + y + z) / 8),
    		h = max(4 + f, 0) + cos((x + y + z) / 8),
    		_x = x,
    		_y = y + 6;

        draw_ellipse(_x - w, _y - h, _x + w, _y + h, false);
    }

#define draw_dark // Drawing Grays
    draw_set_color(c_gray);

     // Big Decals:
    with(instances_matching(instances_named(CustomObject, "BigDecal"), "area", 4, 104)){
    	draw_circle(x, y, 96, false);
    }

     // Lightning Discs:
    with(instances_matching(CustomProjectile, "name", "LightningDisc", "LightningDiscEnemy")){
        draw_circle(x - 1, y - 1, (radius * image_xscale * 3) + 8 + orandom(1), false);
    }

     // Quasar Beams:
    draw_set_flat(draw_get_color());
    with(instances_named(CustomProjectile, "QuasarBeam")){
        var _scale = 5,
        	_xscale = _scale * image_xscale,
        	_yscale = _scale * image_yscale;

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
    draw_set_flat(-1);

#define draw_dark_end // Drawing Clear
    draw_set_color(c_black);

     // Big Decals:
    with(instances_matching(instances_named(CustomObject, "BigDecal"), "area", 4, 104)){
    	draw_circle(x, y, 40, false);
    }

     // Lightning Discs:
    with(instances_matching(CustomProjectile, "name", "LightningDisc", "LightningDiscEnemy")){
        draw_circle(x - 1, y - 1, (radius * image_xscale * 1.5) + 4 + orandom(1), false);
    }

	 // Quasar Beams:
    draw_set_flat(draw_get_color());
    with(instances_named(CustomProjectile, "QuasarBeam")){
        var _scale = 2,
        	_xscale = _scale * image_xscale,
        	_yscale = _scale * image_yscale;

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
    draw_set_flat(-1);


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
#define array_delete(_array, _index)                                                    return  mod_script_call(   "mod", "telib", "array_delete", _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call(   "mod", "telib", "array_delete_value", _array, _value);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "instances_at", _x, _y, _obj);
#define Pet_spawn(_x, _y, _name)                                                        return  mod_script_call(   "mod", "telib", "Pet_spawn", _x, _y, _name);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc("mod", "telib", "scrFX", _x, _y, _motion, _obj);
#define array_combine(_array1, _array2)                                                 return  mod_script_call(   "mod", "telib", "array_combine", _array1, _array2);
#define player_create(_x, _y, _index)                                                   return  mod_script_call(   "mod", "telib", "player_create", _x, _y, _index);
#define draw_set_flat(_color)                                                                   mod_script_call(   "mod", "telib", "draw_set_flat", _color);
#define trace_error(_error)                                                                     mod_script_call_nc("mod", "telib", "trace_error", _error);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc("mod", "telib", "sleep_max", _milliseconds);