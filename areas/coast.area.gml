#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.sav = mod_variable_get("mod", "teassets", "sav");

    global.debug_lag = false;

     // Sprites:
    with(spr){
    	CoastTrans  = sprite_add("../sprites/areas/Coast/sprCoastTrans.png",  1, 0, 0);
    	FloorCoast  = sprite_add("../sprites/areas/Coast/sprFloorCoast.png",  4, 2, 2);
    	FloorCoastB = sprite_add("../sprites/areas/Coast/sprFloorCoastB.png", 3, 2, 2);
    	DetailCoast = sprite_add("../sprites/areas/Coast/sprDetailCoast.png", 6, 4, 4);
    }

	 // Surfaces:
	global.surfTrans	= surflist_set("CoastTrans",	0, 0, 0, 0);
	global.surfFloor	= surflist_set("CoastFloor",	0, 0, 0, 0);
	global.surfWaves	= surflist_set("CoastWaves",	0, 0, game_width, game_height);
	global.surfWavesSub	= surflist_set("CoastWavesSub",	0, 0, game_width, game_height);
	global.surfSwim		= surflist_set("CoastSwim",		0, 0, 200, 200);
	global.surfSwimBot	= surflist_set("CoastSwimBot",	0, 0, 0, 0);
	global.surfSwimTop	= surflist_set("CoastSwimTop",	0, 0, 0, 0);
	with([surfTrans, surfFloor]) reset = true;
    with(surfSwim){
	    inst_visible = [];
    }
    with([surfTrans, surfFloor]){
    	border = 32;
    }
    with([surfWaves, surfWavesSub]){
    	border = 8;
    }

    global.seaDepth = 10.1;

    global.spawn_enemy = 0;

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav
#macro opt sav.option

#macro current_frame_active ((current_frame mod 1) < current_time_scale)

#macro surfTrans	global.surfTrans
#macro surfFloor	global.surfFloor
#macro surfWaves	global.surfWaves
#macro surfWavesSub	global.surfWavesSub
#macro surfSwim		global.surfSwim
#macro surfSwimBot	global.surfSwimBot
#macro surfSwimTop	global.surfSwimTop
#macro surfScale	(1/3 + (2/3 * lq_defget(opt, "waterQualityMain", 1)))
#macro surfScaleTop	(1/2 + (1/2 * lq_defget(opt, "waterQualityTop", 1)))

#macro DebugLag global.debug_lag
#macro CanLeaveCoast (array_length(instances_matching_gt(instances_matching(CustomDraw, "name", "darksea_draw"), "flash", 0)) > 0)
#macro WadeColor make_color_rgb(44, 37, 122)

#macro TrenchVisited (mod_exists("area", "trench") ? mod_variable_get("area", "trench", "trench_visited") : [])

#define area_subarea            return 3;
#define area_next               return "oasis";
#define area_music              return [mus.Coast, 0.5];
#define area_ambience           return amb0b;
#define area_background_color   return make_color_rgb(27, 118, 184);
#define area_shadow_color       return c_black;
#define area_darkness           return false;
#define area_secret             return true;

#define area_name(_subarea, _loop)
    return "@1(sprInterfaceIcons)1-" + string(_subarea);

#define area_text
	return choose("COWABUNGA", "WAVES CRASH", "SANDY SANCTUARY", "THE WATER CALLS", "SO MUCH GREEN", "ENDLESS BLUE");

#define area_mapdata(_lastx, _lasty, _lastarea, _lastsubarea, _subarea, _loops)
    var _x = 0.5 + (9 * (_subarea - 1)),
        _y = -9,
        _showLine = (_subarea != 1);

    if(array_length(TrenchVisited) <= _loops || !TrenchVisited[_loops]){
        _x += 18;
        _showLine = true;
    }

    return [_x, _y, (_subarea == 1), _showLine];

#define area_sprite(_spr)
    switch(_spr){
         // Floors:
        case sprFloor1      : return spr.FloorCoast;
        case sprFloor1B     : return spr.FloorCoastB;
        case sprFloor1Explo : return sprFloor1Explo;

         // Walls:
        case sprWall1Trans  : return sprWall1Trans;
        case sprWall1Bot    : return sprWall1Bot;
        case sprWall1Out    : return sprWall1Out;
        case sprWall1Top    : return sprWall1Top;

         // Misc:
        case sprDebris1     : return sprDebris1;
        case sprDetail1     : return spr.DetailCoast;
    }

#define area_setup
    goal = 100;

    background_color = area_background_color();
    BackCont.shadcol = area_shadow_color();
    TopCont.darkness = area_darkness();

#define area_start
	 // Remember you were here:
	with(GameCont) visited_coast = true;

     // No Walls:
    with(Wall) instance_destroy();
    with(FloorExplo) instance_destroy();

	 // Subarea-Specific Spawns:
	switch(GameCont.subarea){
	    case 1: // Shell
	        with(instance_random(TopSmall)){
	            with(obj_create(x, y, "CoastBigDecal")){
                	with(Pet_spawn(x, y, "Parrot")){
	                    perched = other;
                	}
                }
	        }
	        break;

    	case 2: // Cool Wep
	    	if(chance(1, 100)){
	    		var l = random_range(1600, 2400),
	    			d = random(360);
	
	    		with(instance_create(10016 + lengthdir_x(l, d), 10016 + lengthdir_y(l, d), WepPickup)){
	    			wep = "trident";
	    			rotation = 270 + orandom(60);
	    		}
	    		sound_play_pitchvol(sndSwapGold, 0.5 + random(0.1), 1.2);
	    	}
	    	break;

		case 3: // Boss
	        with(obj_create(10016, 10016, "Palanking")){
	            var d = random(360);
	            while(distance_to_object(Floor) < 160){
	                x += lengthdir_x(10, d);
	                y += lengthdir_y(10, d);
	            }
	            scrRight(d + 180);
	            xstart = x;
	            ystart = y;
	        }
			break;
    }

	 // Rock Props:
    with(TopSmall){
        if(chance(1, 80)) obj_create(x, y, "CoastDecal");
        instance_destroy();
    }

     // Spawn Thing:
    if(GameCont.subarea != 3){
        var _forcespawn = false;
         // check for blaac
        for(var i = 0; i < maxp; i++){
            if(player_get_alias(i) == "blaac") _forcespawn = true;
        }

        if(chance(1 + GameCont.loops, 25) || _forcespawn){
            var _n = 10016,
                _f = instance_furthest(_n,_n,Floor),
                _l = 1.75*point_distance(_n,_n,_f.x,_f.y),
                _d = 180+point_direction(_n,_n,_f.x,_f.y);

            obj_create(_n + lengthdir_x(_l,_d), _n + lengthdir_y(_l,_d), "Creature");
            if(fork()){
                wait(30);
                sound_play_pitchvol(sndOasisBossFire,0.75,0.25);
                exit;
            }
        }
    }

	 // Anglers:
	with(RadChest) if(chance(1, 40)){
		obj_create(x, y, "Angler");
		instance_delete(id);
	}

     // Bind Sea Drawing Scripts:
	if(array_length(instances_matching(CustomDraw, "name", "darksea_draw")) <= 0){
		with(script_bind_draw(darksea_draw, global.seaDepth)){
			name = script[2];
			wave = 0;
			wave_dis = 6;
			wave_ang = 0;
			indicate_x = -1;
			indicate_y = -1;
			flash = 0;
			heat = 0;
		}
	}
	if(array_length(instances_matching(CustomDraw, "name", "swimtop_draw")) <= 0){
		with(script_bind_draw(swimtop_draw, -1)) name = script[2];
	}

     // who's that bird? \\
    if(!unlock_get("parrot")){
        unlock_set("parrot", true); // It's a secret yo
        scrUnlock("PARROT", "FOR REACHING COAST", spr.Parrot[0].Portrait, sndRavenScreech);
    }

	 // Reset Surfaces:
	with([surfTrans, surfFloor, surfWaves, surfWavesSub, surfSwim, surfSwimBot, surfSwimTop]){
		active = true;
		if("reset" in self) reset = true;
	}

#define area_finish
    lastarea = area;

     // Area End:
    if(subarea >= area_subarea()){
        var n = area_next();
        if(!is_array(n)) n = [n];
        if(array_length(n) < 1) array_push(n, mod_current);
        if(array_length(n) < 2) array_push(n, 1);
        area = n[0];
        subarea = n[1];
    }

     // Next Subarea: 
    else subarea++;

#define area_transit
	with(instances_matching_ne(instances_matching(GameObject, "persistent", true), "wading", null)){
		wading = 0;
	}

	 // Disable Surfaces:
	with([surfTrans, surfFloor, surfWaves, surfWavesSub, surfSwim, surfSwimBot, surfSwimTop]){
		active = false;
	}

#define area_step
	 // Water Wading:
	if(instance_exists(Floor) && array_length(instances_matching(CustomDraw, "name", "darksea_draw")) > 0){
		with(surfSwim) if(surface_exists(surf) && surface_exists(surfSwimTop.surf) && surface_exists(surfSwimBot.surf)){
			if(DebugLag) trace_time();

			 // Setup:
			var	_surfSwim = surf,
				_surfSwimW = w,
				_surfSwimH = h,
				_surfScale = surfScale,
				_surfScaleTop = surfScaleTop,
				_tex = surface_get_texture(_surfSwim),
				_vx = view_xview_nonsync,
				_vy = view_yview_nonsync,
				_vw = game_width,
				_vh = game_height,
				_x = floor(_vx / _vw) * _vw,
				_y = floor(_vy / _vh) * _vh,
				_inst = [Debris, Corpse, ChestOpen, chestprop, WepPickup, Crown, Grenade, hitme];

			_inst = array_combine(_inst, instances_matching(CustomObject, "name", "Pet"));
			_inst = array_combine(_inst, instances_matching(Pickup, "mask_index", mskPickup));
			_inst = instances_matching(instances_matching(instances_matching_lt(_inst, "depth", global.seaDepth), "visible", true), "nowade", null, false);

			with(instances_matching(_inst, "wading", null)){
				wading = 0;
				wading_clamp = 0;
				wading_sink = 0;
				wading_xprevious = x;
				wading_yprevious = y;
				wading_z = 0;
				wading_h = 0;
				if(object_index == Van) wading_clamp = 40;
				if(instance_is(self, Corpse)) wading_sink = 1;
			}

			with([surfSwimBot, surfSwimTop]){
				x = _x;
				y = _y;
				var s = ((self == surfSwimBot) ? _surfScale : _surfScaleTop);
				w = _vw * 2 * s;
				h = _vh * 2 * s;

				surface_set_target(surf);
				draw_clear_alpha(0, 0);
			}
			surface_reset_target();

			 // Find Dudes In/Out of Water:
			inst_visible = [];
			with(_inst){
				 // In Water:
				var _dis = distance_to_object(Floor);
				if(_dis > 4){
					if(wading <= 0){
						wading_xprevious = x - hspeed_raw;
						wading_yprevious = y - vspeed_raw;
	
						 // Splash:
						repeat(irandom_range(4, 8)) instance_create(x, y, Sweat/*Bubble*/);
						var _vol = ((object_index == Player) ? 1 : clamp(1 - (distance_to_object(Player) / 150), 0.1, 1));
						sound_play_pitchvol(choose(sndOasisChest, sndOasisMelee), 1.5 + random(0.5), _vol);
					}
					array_push(other.inst_visible, id);
					wading = _dis;

					 // Splashies:
					if(random(20) < min(speed_raw, 4)){
						with(instance_create(x, y, Dust)){
							motion_add(other.direction + orandom(10), 3);
						}
					}
				}

				 // Out of Water:
				else{
					if(wading > 0){
						 // Sploosh:
						var _vol = ((object_index == Player) ? 1 : clamp(1 - (distance_to_object(Player) / 150), 0.1, 1));
						sound_play_pitchvol(choose(sndOasisChest, sndOasisMelee, sndOasisHurt), 1 + random(0.25), _vol);
						repeat(5 + random(5)) with(instance_create(x, y, Sweat)){
							motion_add(other.direction, other.speed);
						}
					}
					wading = 0;
				}
			}

			if(DebugLag) trace_time("coast_area_step Wading Setup");

			 // Water Wading Drawing:
			if(DebugLag) trace_time();

			var _charmShader = lq_defget(shadlist_get("Charm"), "shad", -1),
				_charmOption = lq_defget(opt, "outlineCharm", 2),
				_charmCanOutline = (_charmOption > 0 && (_charmOption < 2 || player_get_outlines(player_find_local_nonsync())));

			with(other){
				with(instances_seen(instances_matching_gt(_inst, "wading", 0), 24)){
					var o = (object_index == Player),
						_z = 2,
						_wh = _z + (sprite_height - sprite_get_bbox_bottom(sprite_index)) + ((wading - 16) * 0.2),
						_surfSwimX = x - (_surfSwimW / 2),
						_surfSwimY = y - (_surfSwimH / 2);

					if(!o || !CanLeaveCoast || (instance_exists(Portal) && distance_to_object(Portal) > 64)){
						if(wading_clamp) _wh = min(_wh, wading_clamp);
						else _wh = min(_wh, sprite_yoffset);
					}

					 // Bobbing:
					if(wading > sprite_height || !instance_is(id, hitme)){
						var _bobspd = 1/10,
							_bobmax = min(wading / sprite_height, 2) / (1 + (wading_sink / 10)),
							_bob = _bobmax * sin((current_frame + x + y) * _bobspd);

						_z += _bob;
						_wh += _bob;
					}

					if(wading_sink != 0){
						_wh += wading_sink / 8;
						_z += wading_sink / 5;
					}

					 // Save + Temporarily Set Vars:
					var s = {};
					if(o){
						 // Disable Laser Sight:
						if(canscope){
							s.canscope = canscope;
							canscope = 0;
						}

						 // Sucked Into Abyss:
						if(CanLeaveCoast && (mask_index == mskNone && distance_to_object(Portal) < 64)){
							s.image_xscale = image_xscale;
							s.image_yscale = image_yscale;
							s.image_alpha  = image_alpha;
							with(instance_nearest(x, y, Portal)) with(other){
								var f = min(0.5 + (other.endgame / 60), 1);
								image_xscale *= f;
								image_yscale *= f;
								image_alpha  *= f;
								_wh += (1 - f) * 48;
								_z += (1 - f) * 48;
							}
						}
					}

					wading_z = _z;
					wading_h = _wh;

					 // Call Draw Event to Surface:
					surface_set_target(_surfSwim);
					draw_clear_alpha(0, 0);

					var _x = x, _y = y;
					x -= _surfSwimX;
					y -= _surfSwimY;
					if("right" in self || "rotation" in self) event_perform(ev_draw, 0);
					else draw_self();
					x = _x;
					y = _y;

					surface_reset_target();

					 // Set Saved Vars:
					if(lq_size(s) > 0){
						for(var i = 0; i < lq_size(s); i++){
							var k = lq_get_key(s, i);
							variable_instance_set(id, k, lq_get(s, k));
						}
					}

					 // Offset:
					var	l = min(speed_raw, point_distance(x, y, wading_xprevious, wading_yprevious)),
						d = direction,
						_ox = lengthdir_x(l, d),
						_oy = lengthdir_y(l, d);

					_surfSwimX += _ox;
					_surfSwimY += _oy;

					 // Draw Top:
					var _yoff = _surfSwimH - ((_surfSwimH / 2) - (sprite_height - sprite_yoffset)),
						t = _yoff - _wh;

					with(surfSwimTop){
						var _surfx = x,
							_surfy = y;

						surface_set_target(surf);

						with(other){
							 // Manually Draw Laser Sights:
							if(o && canscope){
								draw_set_color(c_red);

								var _wep = [wep];
								if(race == "steroids") _wep = [wep, bwep];
								for(var i = 0; i < array_length(_wep); i++) if(weapon_get_laser_sight(_wep[i])){
									var	_sx = x + _ox,
										_sy = y + _oy + _z - (i * 4),
										_lx = _sx,
										_ly = _sy,
										_md = 1000, // Max Distance
										d = _md,    // Distance
										m = 0;      // Minor hitscan increment distance

									while(d > 0){ // A strange but fast hitscan system
										 // Major Hitscan Mode:
										if(m <= 0){
											_lx = _sx + lengthdir_x(d, gunangle);
											_ly = _sy + lengthdir_y(d, gunangle);
											d -= sqrt(_md);

											 // Enter minor hitscan mode once no walls on path:
											if(!collision_line(_sx, _sy, _lx, _ly, Wall, 0, 0)){
												m = 2;
												d = sqrt(_md);
											}
										}

										 // Minor Hitscan Mode:
										else{
											if(position_meeting(_lx, _ly, Wall)) break;
											_lx += lengthdir_x(m, gunangle);
											_ly += lengthdir_y(m, gunangle);
											d -= m;
										}
									}

									 // Draw Laser:
									var _ox = lengthdir_x(right, gunangle - 90),
										_oy = lengthdir_y(right, gunangle - 90),
										_dx=[	_sx,
												_sx + ((_lx - _sx) / 10),// ~ ~
												_lx
											],
										_dy=[	_sy,
												_sy + ((_ly - _sy) / 10),
												_ly
											];

									draw_primitive_begin(pr_trianglestrip);
									draw_set_alpha((sin(degtorad(gunangle)) * 5) - (max(_wh - (sprite_yoffset - 2), 0)));
									for(var j = 0; j < array_length(_dx); j++){
										draw_vertex((_dx[j] - _surfx      ) * _surfScaleTop, (_dy[j] - _surfy      ) * _surfScaleTop);
										draw_vertex((_dx[j] - _surfx + _ox) * _surfScaleTop, (_dy[j] - _surfy + _oy) * _surfScaleTop);
										draw_set_alpha(1);
									}
									draw_primitive_end();

									//draw_sprite_ext(sprLaserSight, -1, _sx, _sy, (point_distance(_sx, _sy, _lx, _ly) / 2) + 2, 1, gunangle, c_white, 1);
								}
								draw_set_alpha(1);
							}

							 // Self:
							var	_x = (_surfSwimX      - _surfx) * _surfScaleTop,
								_y = (_surfSwimY + _z - _surfy) * _surfScaleTop;

							draw_surface_part_ext(_surfSwim, 0, 0, _surfSwimW, t, _x, _y, _surfScaleTop, _surfScaleTop, c_white, 1);

							 // Charmed Enemy Eye:
							if("charm" in self && charm.charmed){
								 // Outlines:
								if(_charmCanOutline){
									draw_set_fog(true, player_get_color(player_find_local_nonsync()), 0, 0);
									for(var a = 0; a <= 360; a += 90){
										var _dx = _x,
											_dy = _y;

										if(a >= 360) draw_set_fog(false, 0, 0, 0);
										else{
											_dx += dcos(a);
											_dy -= dsin(a);
										}

										draw_surface_part_ext(_surfSwim, 0, 0, _surfSwimW, t, _dx, _dy, _surfScaleTop, _surfScaleTop, c_white, 1);
									}
								}

								 // Eyes:
								if(_charmShader != -1){
									shader_set_vertex_constant_f(0, matrix_multiply(matrix_multiply(matrix_get(matrix_world), matrix_get(matrix_view)), matrix_get(matrix_projection)));
									shader_set(_charmShader);
									texture_set_stage(0, _tex);
									draw_surface_part_ext(_surfSwim, 0, 0, _surfSwimW, t, _x, _y, _surfScaleTop, _surfScaleTop, c_white, 1);
									shader_reset();
								}
							}
						}

						 // Water Interference Line Thing:
						draw_set_fog(true, c_white, 0, 0);
						draw_surface_part_ext(_surfSwim, 0, t, _surfSwimW, 1, _x, _y + (t * _surfScaleTop), _surfScaleTop, _surfScaleTop, c_white, 0.8);
						draw_set_fog(false, 0, 0, 0);
					}

					 // Draw Bottom:
					with(surfSwimBot){
						surface_set_target(surf);
						draw_surface_part_ext(_surfSwim, 0, t, _surfSwimW, (_surfSwimH - t), (_surfSwimX - x) * _surfScale, (_surfSwimY - y + _z + t) * _surfScale, _surfScale, _surfScale, c_white, (1 - (other.wading_sink / 120)));
					}

					surface_reset_target();

					wading_xprevious = x;
					wading_yprevious = y;
				}
			}

			if(DebugLag) trace_time("coast_area_step Wading Drawing");
		}

		 // Corpse Sinking:
		if(DebugLag) trace_time();
        with(instances_matching_gt(instances_matching_lt(instances_matching(instances_matching_le(instances_matching_gt(Corpse, "wading", 30), "speed", 0), "image_speed", 0), "size", 3), "wading_sink", 0)){
            if(wading_sink++ >= 120) instance_destroy();
        }
		if(DebugLag) trace_time("coast_area_step Wading Sink");

         // Push Stuff to Shore:
		if(DebugLag) trace_time();
		var _inst = [enemy];
		if(!instance_exists(Portal)) array_push(_inst, Pickup);
		_inst = array_combine(
			instances_matching(_inst, "", null),
			array_combine(
			instances_matching_ne(chestprop, "name", "SunkenChest"),
			instances_matching(CustomObject, "name", "Pet")
			)
		);
        with(instances_matching_ge(_inst, "wading", 80)){
            var n = instance_nearest(x - 16, y - 16, Floor);
    		motion_add(point_direction(x, y, n.x, n.y), 4);
        }
        
         // Push Player to Shore
        if(!CanLeaveCoast || instance_exists(Portal)){
        	with(instances_matching_ge(Player, "wading", 80)){
	        	if(visible && distance_to_object(Portal) > 0){
		            var n = instance_nearest(x - 16, y - 16, Floor);
		    		motion_add(point_direction(x, y, n.x, n.y), 4);

					 // Just in Case:
					while(distance_to_object(Floor) > 120){
		        		var l = distance_to_object(Floor) / 120,
		        			d = point_direction(x, y, n.x, n.y);

						if(chance(1, 3)) instance_create(x + orandom(4), y + orandom(4), Dust);

						x += lengthdir_x(l, d);
						y += lengthdir_y(l, d);
	        		}
	        	}
        	}
        }
		if(DebugLag) trace_time("coast_area_step Wading Push");

		 // Set Visibility of Swimming Objects Before & After Drawing Events:
		script_bind_draw(corpse_fix, 10000000);
    	script_bind_step(reset_visible,   0, false);
    	script_bind_draw(reset_visible, -14, true);

         // Fix Spirit:
        if(skill_get(mut_strong_spirit)){
			script_bind_draw(draw_spiritfix, -8, instances_matching(Player, "visible", true));
        }
	}

	if(DebugLag) trace_time();

     // No Portals:
	with(instances_matching_ne(Corpse, "do_portal", false)) do_portal = false;

	 // It's like a portal exists but no it doesn't:
	if(CanLeaveCoast && !instance_exists(Portal)){
	    scrPickupPortalize();
	    with(instances_matching_gt(Ally, "alarm2", 1)) alarm2 = 1;
	}

     // Explosion debris splash FX:
	with(Explosion) if(chance_ct(1, 5)){
        var l = random_range(24, 48),
            d = random(360);

        with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), RainSplash)){
            if(place_meeting(x, y, Floor)) instance_destroy();
        }
	}

     // Destroy Projectiles Too Far Away:
    with(instances_matching_le(instances_matching_gt(projectile, "speed", 0), "friction", 0)){
    	if(distance_to_object(Player) > 1000) instance_destroy();
    }

	 // Player Leaving Level:
    with(Player){
         // Move Camera Towards Sea at Level End:
        if(CanLeaveCoast && !instance_exists(Portal) && instance_exists(Floor)){
            var g = gunangle;
            with(instances_matching(CustomDraw, "name", "darksea_draw")){
                var _x = indicate_x;
                	_y = indicate_y;

				if(_x >= 0 && _y >= 0) with(other){
		            var s = UberCont.opt_shake;
		            UberCont.opt_shake = 1;
	
		            gunangle = point_direction(x, y, _x, _y);
		            weapon_post(wkick, (point_distance(x, y, _x, _y) / 9) * current_time_scale, 0);
		            gunangle = g;
	
	            	UberCont.opt_shake = s;
				}
            }
        }

         // Wading Players:
        if("wading" in self && wading > 0){
			 // Player Moves 20% Slower in Water:
            if(!skill_get(mut_extra_feet) && speed > 0){
                var f = ((race == "fish") ? 0 : -0.2);
                if(f != 0){
                    x += hspeed * f;
                    y += vspeed * f;
                }
            }

             // Walk into Sea for Next Level:
            if(CanLeaveCoast && !instance_exists(Portal)){
                if(wading > 120 || !instance_exists(Floor)){
                    instance_create(x, y, Portal);

                     // Switch Sound:
                    sound_stop(sndPortalOpen);
                    sound_play(sndOasisPortal);
                }

                 // Push Out to Sea:
                /*else{
                     // Check if Player is Controlling Movement:
                    var _moving = false;
                    if(canwalk){
                        _moveKey = ["east", "nort", "west", "sout"];
                        for(var i = 0; i < array_length(_moveKey); i++){
                            if(button_check(index, _moveKey[i])){
                                _moving = true;
                                break;
                            }
                        }
                    }

                     // Go out to the sea pls
                    var f = instance_nearest(x, y, Floor),
                        _dir = point_direction(f.x, f.y, x, y) + (20 * cos(current_frame / 30));

                    if(!_moving || abs(angle_difference(_dir, direction)) > 90){
                        var _dis = 2 * max(sin(current_frame / 10), 0) * current_time_scale;
                        x += lengthdir_x(_dis, _dir);
                        y += lengthdir_y(_dis, _dir);
                    }
                }*/
            }
        }
    }

     // Spinny Water Portals:
    with(Portal) if(!place_meeting(xstart, ystart, Floor)){
        image_alpha = 0;

        var r = 5 + image_index,
            c = current_frame;

        x = xstart + (cos(c) * r);
        y = ystart + (sin(c) * r);

        instance_create(x, y, choose(Sweat, Sweat, Bubble));
    }

     // Spinny Water Shells:
    with(Shell) if(!place_meeting(x, y, Floor)){
    	y += sin((x + y + current_frame) / 10) * 0.1 * current_time_scale;
    }

     // things die bc of the missing walls
	with(instances_matching(enemy, "canfly", false)) canfly = true;

     // Weird fix for ultra bolts destroying themselves when not touching a floor:
    with(UltraBolt){
    	var _x = x,
    		_y = y;

		if(skill_get(mut_bolt_marrow)){
			var n = instance_nearest(x, y, enemy);
			if(instance_exists(n) && point_distance(x, y, n.x, n.y) < 24 * skill_get(mut_bolt_marrow)){
				_x = n.x - hspeed;
				_y = n.y - vspeed;
			}
		}

        if(!place_meeting(_x, _y, Floor)){
            with(instance_create(0, 0, Floor)){
                x = _x;
                y = _y;
                xprevious = x;
                yprevious = y;
                name = "UltraBoltCoastFix";
                mask_index = sprBoltTrail;
                visible = false;
                creator = other;
            }
        }
    }

     // Popo Freaks Can't Spawn After Level End:
    if(CanLeaveCoast){
        with(WantRevivePopoFreak) instance_destroy();
    }

	if(DebugLag) trace_time("coast_area_step");

#define area_end_step
	if(DebugLag) trace_time();

     // Watery Dust:
    with(instances_matching(Dust, "coast_water", null)){
        coast_water = 1;
        if(!place_meeting(x, y, Floor)){
            if(chance(1, 10 + instance_number(AcidStreak))){
                if(point_seen(x, y, -1)){
                    sound_play_pitch(sndOasisCrabAttack, 0.9 + random(0.2));
                }
                with(scrWaterStreak(x, y, random(360), 2)){
                    hspeed += other.hspeed / 2;
                    vspeed += other.vspeed / 2;
                }
            }
            else{
                if(chance(1, 5) && point_seen(x, y, -1)){
                    sound_play(choose(sndOasisChest, sndOasisMelee));
                }
                with(instance_create(x, y, Sweat)){
                    hspeed = other.hspeed / 2;
                    vspeed = other.vspeed / 2;
                }
            }
            instance_destroy();
        }
    }

     // Watery Explosion Sounds:
    var e = 0,
        s = 0;

    with(instances_matching(Explosion, "coast_water", null)){
        coast_water = 1;
        if(!position_meeting(x, y, Floor)){
            if(object_index == SmallExplosion) s++;
            else e++;
        }
    }
    if(e > 0 || s > 0){
        var _vol = 0.5;
        if(e > 0) sound_play_pitchvol(sndOasisExplosion, 1, e * _vol);
        if(s > 0) sound_play_pitchvol(sndOasisExplosion, 1, s * _vol);
    }

     // Watery Melting Scorch Marks:
    with(instances_matching(MeltSplat, "coast_water", null)){
        coast_water = 1;
        if(!position_meeting(x, y, Floor)){
            sound_play(sndOasisExplosionSmall);
            repeat((sprite_index == sprMeltSplatBig) ? 16 : 8){
                if(chance(1, 6)) scrWaterStreak(x, y, random(360), 4);
                else instance_create(x, y, Sweat);
            }
            instance_destroy();
        }
    }

	 // Ultra Bolt Fix Pt.2:
    with(instances_matching(Floor, "name", "UltraBoltCoastFix")) instance_destroy();

	if(DebugLag) trace_time("coast_area_end_step");

#define area_effect(_vx, _vy)
    var _x = _vx + random(game_width),
        _y = _vy + random(game_height);

     // Wind:
    var f = instance_nearest(_x, _y, Floor);
    with(f){
        instance_create(x + random(32), y + random(32), Wind);
    }

    return random(60);

#define area_make_floor
    var _x = x,
        _y = y,
        _outOfSpawn = (point_distance(_x, _y, GenCont.spawn_x, GenCont.spawn_y) > 48);

    /// Make Floors:
         // Special - 4x4 to 6x6 Rounded Fills:
        if(chance(1, 5)){
            scrFloorFillRound(_x, _y, irandom_range(4, 6), irandom_range(4, 6));
        }

         // Normal - 2x1 Fills:
        else scrFloorFill(_x, _y, 2, 1);

	/// Turn:
        var _trn = 0;
        if(chance(3, 7)){
            _trn = choose(90, -90, 180);
        }
        direction += _trn;

    /// Chests & Branching:
        if(_trn == 180){
             // Weapon Chests:
            if(_outOfSpawn) scrFloorMake(_x, _y, WeaponChest);

             // Start New Island:
            if(chance(1, 2)){
                var d = direction + 180;
                _x += lengthdir_x(96, d);
                _y += lengthdir_y(96, d);
                with(instance_create(_x, _y, FloorMaker)) direction = d + choose(-90, 0, 90);
                if(_outOfSpawn){
                    instance_create(_x + 16, _y + 16, choose(AmmoChest, WeaponChest, RadChest));
                }
            }
        }

	     // Ammo Chests + End Branch:
	    var n = instance_number(FloorMaker);
        if(!chance(22, 19 + n)){
            if(_outOfSpawn) scrFloorMake(_x, _y, AmmoChest);
            instance_destroy();
        }

    /// Crown Vault:
    	if(GameCont.loops > 0){
	        with(GenCont) if(instance_number(Floor) > goal){
	            if(GameCont.subarea == 2 && GameCont.vaults < 3){
	                var f = instance_furthest(spawn_x, spawn_y, Floor);
	                if(instance_exists(f)){
	                    with(
	                        instance_nearest(
	                            (((f.x * 2) + spawn_x) / 3) + orandom(64),
	                            (((f.y * 2) + spawn_y) / 3) + orandom(64),
	                            Floor
	                        )
	                    ){
	                        instance_create(x + 16, y + 16, ProtoStatue);
	                    }
	                }
	            }
	        }
    	}

#define area_pop_enemies
    var _x = x + 16,
        _y = y + 16;

    if(global.spawn_enemy-- <= 0){
        global.spawn_enemy = 1;

         // Loop Spawns:
        if(GameCont.loops > 0 && chance(1, 3)){
             // Bushes:
            if(chance(1, 3)){
                with(instance_nearest(x, y, prop)){
                    var _ang = random(360),
                        _num = irandom_range(1, 4);

                    for(var a = _ang; a < _ang + 360; a += (360 / _num)){
                        var o = 16 + random(16);
                        obj_create(x + lengthdir_x(o, a), y + lengthdir_y(o, a), choose("BloomingAssassinHide", "BloomingAssassinHide", "BloomingBush"));
                    }
                }
            }

             // Birds:
            else repeat(irandom_range(1, 2)){
                instance_create(_x, _y, Raven);
            }
        }

         // Normal Enemies:
        else{
            if(styleb) obj_create(_x, _y, "TrafficCrab");
            else{
                if(chance(GameCont.subarea, 18)){
                    obj_create(_x, _y, choose("Pelican", "Pelican", "TrafficCrab"));
                }
                else{
                    obj_create(_x, _y, choose("Diver", "Gull", "Gull", "Gull", "Gull"));
                }
            }
        }

         // TMST:
        if(GameCont.loops > 0 && chance(1, 6)){
            var _dir = random(360),
                _dis = 640 + random(1080);

            for(var i = 1; i <= 4; i++){
                with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Turtle)){
                    snd_dead = asset_get_index(`sndTurtleDead${i}`);
                }
            }
        }
    }

     // Seal Lands:
    else if(GameCont.subarea == 3){
        var _seals = instances_matching(CustomEnemy, "name", "Seal");
        if(random(2 * array_length(_seals)) < 1){
            if(styleb){
            	obj_create(_x, _y, ((random(16) < 1) ? "SealHeavy" : "Seal"));
            }
            else{
            	repeat(4) obj_create(_x, _y, "Seal");
            }
        }
    }

#define area_pop_props
    var _x = x + 16,
        _y = y + 16,
        _outOfSpawn = (point_distance(_x, _y, GenCont.spawn_x, GenCont.spawn_y) > 48);

    if(chance(1, 12)){
    	if(_outOfSpawn){
	        var o = choose("BloomingCactus", "BloomingCactus", "BloomingCactus", "Palm");
	        if(!styleb && chance(1, 8)) o = "BuriedCar";
	        obj_create(_x, _y, o);
    	}
    }

     // Mine:
    else if(chance(1, 80)){
        with(obj_create(_x + orandom(8), _y + orandom(8), "SealMine")){
             // Move to sea:
            if(!other.styleb){
                var d = 24 + random(16);
                while(distance_to_object(Floor) < d){
                    var o = 64;
                    x += lengthdir_x(o, direction);
                    y += lengthdir_y(o, direction);
                }
            }
        }
    }

#define area_pop_extras
     // The new bandits
	with(instances_matching([WeaponChest, AmmoChest, RadChest], "", null)){
		obj_create(x, y, "Diver");
	}

	 // Underwater Details:
	with(Floor) if(chance(1, 3)){
		for(var a = 0; a < 360; a += 45){
			var	_x = (bbox_left + bbox_right) / 2,
				_y = (bbox_top + bbox_bottom) / 2;

			if(chance(1, 2) && !position_meeting(_x + lengthdir_x(sprite_get_width(mask_index), a), _y + lengthdir_y(sprite_get_height(mask_index), a), Floor)){
				var l = random_range(32, 44),
					d = a + orandom(20);

				_x += lengthdir_x(l, d);
				_y += lengthdir_y(l, d);

				if(!position_meeting(_x, _y, Floor)){
					with(instance_create(_x, _y, Detail)){
						depth = ceil(global.seaDepth);
					}
				}
			}
		}
	}


/// Misc
#define corpse_fix
    instance_destroy();
    with(instances_matching(instances_matching_ne(Corpse, "object_index", CorpseActive), "visible_fix", null)){
        visible_fix = true;
        if("wading" in self && wading > 0) visible = false;
    }

#define darksea_draw
    if(DebugLag) trace_time();

    wave += current_time_scale;

	 // Water Surfaces Follow Screen:
    var	_surfScale = surfScale,
		_vx = view_xview_nonsync,
		_vy = view_yview_nonsync,
		_vw = game_width,
		_vh = game_height;

	with([surfTrans, surfFloor]){
		var	_x = (floor(_vx / _vw) * _vw) - border,
			_y = (floor(_vy / _vh) * _vh) - border;

		if(x != _x || y != _y){
			x = _x;
			y = _y;
			reset = true;
		}
		w = (_vw + border) * 2 * _surfScale;
		h = (_vh + border) * 2 * _surfScale;
	}
	with([surfWaves, surfWavesSub]){
		x = _vx - border;
		y = _vy - border;
		w = (_vw + (border * 2)) * _surfScale;
		h = (_vh + (border * 2)) * _surfScale;
	}

    var _wave = wave,
        _floor = instances_matching(instances_matching(Floor, "coast_water", null), "visible", true);

	if(array_length(_floor) > 0){
		with(surfFloor) reset = true;
		with(_floor) coast_water = true;
	}

     // Draw Floors to Surface:
	with(surfFloor) if(surface_exists(surf)){
		if(reset){
			reset = false;
			with(surfTrans) reset = true;

			surface_set_target(surf);
			draw_clear_alpha(0, 0);

			 // Draw Floors in White:
			with(instance_rectangle_bbox(x, y, x + (w / _surfScale), y + (h / _surfScale), instances_matching(Floor, "visible", true))){
				var _spr = sprite_index;
				if(_spr == spr.FloorCoastB) _spr = spr.FloorCoast;
				draw_sprite_ext(_spr, image_index, (x - other.x) * _surfScale, (y - other.y) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, image_blend, image_alpha);
			}

			surface_reset_target();
		}
	}

	 // Underwater Transition Tile Surface:
	with(surfTrans) if(surface_exists(surf)){
		if(reset){
			reset = false;

			surface_set_target(surf);
			draw_clear_alpha(0, 0);

			 // Main Drawing:
			var _dis = 32;
			with(surfFloor) if(surface_exists(surf)){
				var _x = x - other.x,
					_y = y - other.y;

				draw_surface(surf, _x, _y);
				for(var a = 0; a < 360; a += 45){
					var	_ox = lengthdir_x(_dis, a) * _surfScale,
						_oy = lengthdir_y(_dis, a) * _surfScale;

					draw_surface(surf, _x + _ox, _y + _oy);
				}
			}

			 // Fill in Gaps (Cardinal Directions Only):
			var	_spr = spr.FloorCoast,
				_sprNum = sprite_get_number(_spr);

			with(instance_rectangle_bbox(x - _dis, y - _dis, x + _dis + (w / _surfScale), y + _dis + (h / _surfScale), instances_matching(Floor, "visible", true))){
				var	_x = x - other.x,
					_y = y - other.y;

				for(var a = 0; a < 360; a += 90){
					var	_ox = lengthdir_x(_dis, a),
						_oy = lengthdir_y(_dis, a);

					for(var f = 1; f <= 5; f++){
						if(position_meeting(x + (_ox * f), y + (_oy * f), Floor)){
							for(var i = 2; i <= f; i++){
								var	_dx = _x + (_ox * i),
									_dy = _y + (_oy * i),
									_img = floor((_dx + other.x + _dy + other.y) / 32) % _sprNum;

								draw_sprite_ext(_spr, _img, _dx * _surfScale, _dy * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
							}
							break;
						}
					}
				}
			}

			 // Details:
			with(instances_matching(instances_matching_le(instances_matching_ge(Detail, "depth", global.seaDepth), "depth", ceil(global.seaDepth)), "visible", true)){
				draw_sprite_ext(sprite_index, image_index, (x - other.x) * _surfScale, (y - other.y) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, image_blend, image_alpha);
			}
	
			surface_reset_target();
    	}
    }

     // Wavey Foam stuff:
    var _waveInt = 40,															// How often waves occur in frames, affects wave speed
        _waveOutMax = wave_dis,													// Max travel distance
    	_waveSpeed = _waveOutMax + 0.1,											// Wave speed
    	_waveAng = wave_ang,													// Angular Offset
        _iRad = _waveSpeed * cos(((_wave % _waveInt) * (pi / _waveInt)) + pi),  // Inner radius
        _oRad = _iRad + min(_waveOutMax - _iRad, _iRad),						// Outer radius
        _waveCanDraw = (_oRad > _iRad && _oRad > 0);							// Saves gpu time by not drawing when nothing is gonna show up

    if(_waveCanDraw){
		 // Draw Raw Foam:
		with(surfWavesSub) if(surface_exists(surf)){
			var	_surfx = x,
				_surfy = y;

			surface_set_target(surf);
			draw_clear_alpha(0, 0);

			draw_set_flat(c_white);

			 // Floors:
			with(surfFloor) if(surface_exists(surf)){
				draw_surface(surf, (x - _surfx) * _surfScale, (y - _surfy) * _surfScale);
			}

			// PalanKing:
			with(instances_matching(instances_matching(CustomEnemy, "name", "Palanking"), "visible", true)){
				if(z <= 4 && !place_meeting(x, y, Floor)){
					draw_sprite_ext(spr_foam, image_index, (x - _surfx) * _surfScale, (y - _surfy) * _surfScale, image_xscale * right * _surfScale, image_yscale * _surfScale, 0, c_white, 1);
				}
			}

             // Thing:
            with(instances_matching(instances_matching(CustomHitme, "name", "Creature"), "visible", true)){
                draw_sprite_ext(spr_foam, image_index, (x - _surfx) * _surfScale, (y - _surfy) * _surfScale, image_xscale * right * _surfScale, image_yscale * _surfScale, image_angle, c_white, 1);
            }

			 // Rock Decals:
			with(instances_matching(instances_matching(CustomProp, "name", "CoastDecal", "CoastDecalBig"), "visible", true)){
				draw_sprite_ext(spr_foam, image_index, (x - _surfx) * _surfScale, (y - _surfy) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, c_white, 1);
			}
			with(instances_matching(instances_matching(Floor, "name", "CoastDecalCorpse"), "visible", false)){
				draw_sprite_ext(spr_foam, image_index, (x - _surfx) * _surfScale, (y - _surfy) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, c_white, 1);
			}

			draw_set_flat(-1);
		}

		 // Animate Foam (Part player sees):
		with(surfWaves) if(surface_exists(surf)){
			surface_set_target(surf);
			draw_clear_alpha(0, 0);

			with([_oRad, _iRad]){
				var r = self * _surfScale;
				with(surfWavesSub) if(surface_exists(surf)){
					for(var a = _waveAng; a < _waveAng + 360; a += 45){
						draw_surface(surf, lengthdir_x(r, a) - (border * _surfScale), lengthdir_y(r, a) - (border * _surfScale)); 
					}
				}
				draw_set_blend_mode(bm_subtract);
			}
			draw_set_blend_mode(bm_normal);
		}

		surface_reset_target();
	}
	else{
		wave_dis = round(5.5 + (0.5 * sin(_wave / 200)) + random(1));
		wave_ang = round(random(45) / 15) * 15;
	}

	 // Draw Sea Transition Floor Tiles:
	with(surfTrans) if(surface_exists(surf)){
		draw_surface_cropped(surf, 1 / _surfScale, x, y);
		// draw_surface_part_ext(surf, (_vx - x) * _surfScale, (_vy - y) * _surfScale, _vw, _vh, _vx, _vy, 1 / _surfScale, 1 / _surfScale, c_white, 1);
	}

	 // Submerged Rock Decals:
	with(instances_matching(instances_matching(CustomProp, "name", "CoastDecal", "CoastDecalBig"), "visible", true)){
		var _hurt = (nexthurt > current_frame + 3);
		if(_hurt) draw_set_fog(true, image_blend, 0, 0);
		draw_sprite_ext(spr_bott, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		if(_hurt) draw_set_fog(false, 0, 0, 0);
	}
	with(instances_matching(instances_matching(Floor, "name", "CoastDecalCorpse"), "visible", false)){
		draw_sprite_ext(spr_bott, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	}

	 // Bottom Halves of Things:
	draw_set_flat(WadeColor);

		 // Palanking:
		with(instances_matching(CustomEnemy, "name", "Palanking")) if(visible){
			draw_sprite_ext(spr_bott, image_index, x, y - z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
		}
		with(instances_matching(CustomHitme, "name", "Creature")) if(visible){
			draw_sprite_ext(spr_bott, image_index, x, y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
		}
		
		// Most Swimming Objects:
		with(surfSwimBot) if(surface_exists(surf)){
			draw_surface_cropped(surf, 1 / _surfScale, x, y);
		}

	draw_set_flat(-1);

     // Draw Sea:
    draw_set_color(background_color);
    draw_set_alpha(0.6);
    draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, 0);
    draw_set_alpha(1);

     // Caustics:
    draw_set_alpha(0.4);
    draw_sprite_tiled(spr.CoastTrans, 0, sin(_wave * 0.02) * 4, sin(_wave * 0.05) * 2);
    draw_set_alpha(1);

     // Foam:
    if(_waveCanDraw){
        with(surfWaves) if(surface_exists(surf)){
        	draw_surface_ext(surf, _vx, _vy, 1 / _surfScale, 1 / _surfScale, 0, c_white, 1);
        }
	}

     // Stuff w/ Level Over:
    if(!instance_exists(Portal)){
	    if(flash > 0 || ((instance_number(enemy) - instance_number(Van) <= 0) && !instance_exists(becomenemy))){
	    	 // Rogu:
	    	if(flash > 15 && !heat){
	    		heat = true;
	    		if(!instance_exists(WantPopo)){
		    		for(var i = 0; i < maxp; i++) if(player_get_race(i) == "rogue"){
		    			instance_create(x, y, WantPopo);
		    		}
	    		}
	    	}

			 // Setup Portal Indicator:
			var _x = indicate_x,
				_y = indicate_y;
	
			if(_x < 0 || _y < 0){
				with(Player){
					_x = x;
					_y = y;
				}

				var _cx = _x,
					_cy = _y,
					_tries = 100,
					_moveDis = 8,
					_moveDir = 0;
	
				with(Floor){
					_moveDir += point_direction((bbox_left + bbox_right) / 2, (bbox_top + bbox_bottom) / 2, _x, _y);
				}
				_moveDir /= instance_number(Floor);
	
				while(_tries-- > 0){
					var n = instance_nearest(_x - 16, _y - 16, Floor);
					if(instance_exists(n)){
						_cx = (n.bbox_left + n.bbox_right) / 2;
						_cy = (n.bbox_top + n.bbox_bottom) / 2;
	
						if(point_distance(_cx, _cy, _x, _y) < 160){
							_x += lengthdir_x(_moveDis, _moveDir);
							_y += lengthdir_y(_moveDis, _moveDir);
						}
	
						 // End:
						else{
							indicate_x = _x;
							indicate_y = _y;
							break;
						}
					}
				}
			}
	
			 // Flash Sea:
	        var _flashInt = 300, // Flash every X frames
	            _flashDur = 30,  // Flash lasts X frames
	            _max = ((flash <= _flashDur) ? 0.3 : 0.15); // Max flash alpha
	
	        draw_set_color(c_white);
	        draw_set_alpha(_max * (1 - ((flash % _flashInt) / _flashDur)));
	        draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, 0);
	        draw_set_alpha(1);
	
	        if((flash % _flashInt) < current_time_scale){
	             // Sound:
	            sound_play_pitchvol(sndOasisHorn, 0.5, 2);
	            sound_play_pitchvol(sndOasisExplosion, 1 + random(1), ((flash <= 0) ? 1 : 0.4));
	    
	             // Effects:
	            for(var i = 0; i < maxp; i++) view_shake[i] += 8;
	            with(Floor) if(chance(1, 5)){
	                for(var d = 0; d < 360; d += 45){
	                    var _x = x + lengthdir_x(32, d),
	                        _y = y + lengthdir_y(32, d);
	    
	                    if(!position_meeting(_x, _y, Floor)){
	                        repeat(irandom_range(3, 6)){
	                            if(chance(1, 6 + instance_number(AcidStreak))){
	                                sound_play_hit(sndOasisCrabAttack, 0.2);
	                                scrWaterStreak(_x + 16 + orandom(8), _y + 16 + orandom(8), d + random_range(-20, 20), 4);
	                            }
	                            else instance_create(_x + random(32), _y + random(32), Sweat);
	                        }
	                    }
	                }
	            }
				repeat(3) scrFX(indicate_x, indicate_y, 3, Dust);
	        }
	        flash += current_time_scale;
	    }
	}
	else if(instance_exists(WantPopo) || instance_exists(IDPDSpawn)){
		if(heat == true){
			heat = 2;
	    	with(IDPDSpawn){
	    		if(elite) sound_stop(sndEliteIDPDPortalSpawn);
	    		else sound_stop(sndIDPDPortalSpawn);
	    		instance_destroy();
	    	}
		}
		else if(!heat) heat = true;
	}

    if(DebugLag) trace_time("darksea_draw");

#define swimtop_draw
	if(DebugLag) trace_time();

     // Top Halves of Swimming Objects:
    with(surfSwimTop) if(surface_exists(surf)){
    	draw_surface_cropped(surf, 1 / surfScaleTop, x, y);
    }

	if(DebugLag) trace_time("coast_swimtop_draw");

#define reset_visible(_visible)
    instance_destroy();

    with(surfSwim){
    	var _inst = inst_visible;
    	with(_inst){
	        if(instance_exists(self) && visible != _visible) visible = _visible;
	        else _inst[array_find_index(_inst, self)] = noone;
    	}
	}

#define draw_spiritfix(_inst)
    with(instances_matching_gt(_inst, "wading", 0)){
        if(canspirit){
    		draw_sprite(sprHalo, -1, x, y + sin(wave / 10));
        }
    }
    instance_destroy();

 // Draws only the visible parts of a larger surface, with scaling and offset options
#define draw_surface_cropped /// draw_surface_cropped(_surf, _scale = 1, _xoffset = 0, _yoffset = 0)
	var _surf = argument[0];
var _scale = argument_count > 1 ? argument[1] : 1;
var _xoffset = argument_count > 2 ? argument[2] : 0;
var _yoffset = argument_count > 3 ? argument[3] : 0;

    draw_surface_part_ext(_surf, (view_xview_nonsync - _xoffset) / _scale, (view_yview_nonsync - _yoffset) / _scale, game_width, game_height, view_xview_nonsync, view_yview_nonsync, _scale, _scale, c_white, 1)


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