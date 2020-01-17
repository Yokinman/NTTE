#define init
    spr = mod_variable_get("mod", "teassets", "spr");
    snd = mod_variable_get("mod", "teassets", "snd");
    mus = mod_variable_get("mod", "teassets", "mus");
    sav = mod_variable_get("mod", "teassets", "sav");

    DebugLag = false;

     // Sprites:
    with(spr){
         // Floors:
        FloorTrench         = sprite_add("../sprites/areas/Trench/sprFloorTrench.png",          4,  0,  0);
        FloorTrenchB        = sprite_add("../sprites/areas/Trench/sprFloorTrenchB.png",         4,  2,  2);
        FloorTrenchExplo    = sprite_add("../sprites/areas/Trench/sprFloorTrenchExplo.png",     5,  1,  1);

         // Walls:
        WallTrenchTrans     = sprite_add("../sprites/areas/Trench/sprWallTrenchTrans.png",      8,  0,  0);
        WallTrenchBot       = sprite_add("../sprites/areas/Trench/sprWallTrenchBot.png",        4,  0,  0);
        WallTrenchOut       = sprite_add("../sprites/areas/Trench/sprWallTrenchOut.png",        1,  4, 12);
        WallTrenchTop       = sprite_add("../sprites/areas/Trench/sprWallTrenchTop.png",        8,  0,  0);

         // Misc:
        DebrisTrench        = sprite_add("../sprites/areas/Trench/sprDebrisTrench.png",         4,  0,  0);
        DetailTrench        = sprite_add("../sprites/areas/Trench/sprDetailTrench.png",         6,  0,  0);

        /// Pits:
             // Small:
            Pit             = sprite_add("../sprites/areas/Trench/Pit/sprPit.png",              1,  2,  2);
            PitTop          = sprite_add("../sprites/areas/Trench/Pit/sprPitTop.png",           1,  2,  2);
            PitBot          = sprite_add("../sprites/areas/Trench/Pit/sprPitBot.png",           1,  2,  2);

             // Large:
            PitSmall        = sprite_add("../sprites/areas/Trench/Pit/sprPitSmall.png",         1,  3,  3);
            PitSmallTop     = sprite_add("../sprites/areas/Trench/Pit/sprPitSmallTop.png",      1,  3,  3);
            PitSmallBot     = sprite_add("../sprites/areas/Trench/Pit/sprPitSmallBot.png",      1,  3,  3);
            
         // Proto Statue:
        PStatTrenchIdle     = sprite_add("../sprites/areas/Trench/sprPStatTrenchIdle.png",      1, 40, 40);
        PStatTrenchHurt     = sprite_add("../sprites/areas/Trench/sprPStatTrenchHurt.png",      3, 40, 40);
        PStatTrenchLights   = sprite_add("../sprites/areas/Trench/sprPStatTrenchLights.png",   40, 40, 40);
    }

	 // Surfaces:
	surfPit = surflist_set("Pit", 0, 0, 0, 0);
	surfPitWallBot = surflist_set("PitWallBot", 0, 0, 0, 0);
	surfPitWallTop = surflist_set("PitWallTop", 0, 0, 0, 0);
	for(var i = 0; i < 2; i++){
		surfSpark[i] = surflist_set(`Spark${i}`, 0, 0, 60, 60);
	}
	with([surfPit, surfPitWallBot, surfPitWallTop]) reset = true;
	with(surfPitWallBot) draw = [[spr.PitBot, spr.PitSmallBot], [spr.Pit, spr.PitSmall]];
	with(surfPitWallTop) draw = [[spr.PitTop, spr.PitSmallTop]];

	 // Pit Grid:
	global.pit_grid = ds_grid_create(20000/16, 20000/16);
	mod_variable_set("mod", "tetrench", "pit_grid", global.pit_grid);
	with(Floor) trenchpit_check = null;

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

#macro surfPit			global.surfPit
#macro surfPitWallBot	global.surfPitWallBot
#macro surfPitWallTop	global.surfPitWallTop
#macro surfSpark		global.surfSpark

#define area_subarea            return 3;
#define area_next               return 5;
#define area_music              return mus.Trench;
#define area_ambience           return amb101;
#define area_background_color   return make_color_rgb(100, 114, 127);
#define area_shadow_color       return c_black;
#define area_darkness           return true;
#define area_secret             return true;
#define area_underwater			return true;

#define area_name(_subarea, _loop)
    return "@1(sprInterfaceIcons)3-" + string(_subarea);

#define area_text
	return choose("IT'S SO DARK", "SHADOWS CRAWL", "IT'S ELECTRIC", "GLOWING", "BLUB", "SWIM OVER PITS", "UNTOUCHED");

#define area_mapdata(_lastx, _lasty, _lastarea, _lastsubarea, _subarea, _loops)
    return [
    	44 + (9.9 * (_subarea - 1)),
    	9,
    	(_subarea == 1)
    ];

#define area_sprite(_spr)
    switch(_spr){
         // Floors:
        case sprFloor1      : if(instance_is(other, Floor)){ with(other) area_setup_floor(); } return spr.FloorTrench;
        case sprFloor1B     : if(instance_is(other, Floor)){ with(other) area_setup_floor(); } return spr.FloorTrenchB;
        case sprFloor1Explo : return spr.FloorTrenchExplo;

         // Walls:
        case sprWall1Trans  : return spr.WallTrenchTrans;
        case sprWall1Bot    : return spr.WallTrenchBot;
        case sprWall1Out    : return spr.WallTrenchOut;
        case sprWall1Top    : return spr.WallTrenchTop;

         // Misc:
        case sprDebris1     : return spr.DebrisTrench;
        case sprDetail1     : return spr.DetailTrench;
    }

#define area_setup
    goal = 150;
    safespawn += 2;
    background_color = area_background_color();
    BackCont.shadcol = area_shadow_color();
    TopCont.darkness = area_darkness();

#define area_setup_floor
    if(styleb){
         // Fix Depth:
        depth = 9;

         // Slippery pits:
        traction = 0.1;
        
         // Get rid of them:
        if(place_meeting(x, y, Detail)){
            with(Detail) if place_meeting(x, y, other){
                instance_destroy();
            }
        }
    }
    
     // Footsteps:
    material = (styleb ? 0 : 4);
    
#define area_start
     // Bind pit drawing scripts:
	if(array_length(instances_matching(CustomDraw, "name", "draw_pit")) <= 0){
    	with(script_bind_draw(draw_pit, 8.5)) name = script[2];
	}

     // Reset Surfaces:
    with([surfPit, surfPitWallBot, surfPitWallTop]) active = true;
    with(surfSpark) active = true;

     // Anglers:
    with(RadChest) if(chance(1, 40)){
        obj_create(x, y, "Angler");
        instance_delete(id);
    }
    
     // Secret:
	if(chance(1, 40) && variable_instance_get(GameCont, "sunkenchests", 0) <= GameCont.loops){
		with(instance_random(WeaponChest)){
			obj_create(x, y, "SunkenChest");
			instance_create(x, y, PortalClear);
			instance_delete(id);
		}
	}

	switch(GameCont.subarea){
		 // Small Pit Boy:
	    case 1:
			with(instance_random(Floor)){
	        	with(pet_spawn((bbox_left + bbox_right + 1) / 2, (bbox_top + bbox_bottom + 1) / 2, "Octo")){
	        		hiding = true;
	        	}
			}
			break;
			
		 // Big Pit Boy:
		case 3:
	    	var _x = 10016,
	    		_y = 10016;
	    		
	    	if(false){
	    		var _spawnFloor = [];
	    		
		    	with(Floor) if(distance_to_object(Player) > 96){
		    		array_push(_spawnFloor, id);
		    	}
		    		
		    	with(instance_random(_spawnFloor)){
		    		_x = (bbox_left + bbox_right + 1) / 2;
		    		_y = (bbox_top + bbox_bottom + 1) / 2;
		    	}
	    	}
	    	
	    	obj_create(_x + orandom(8), _y + random(8), "PitSquid");
			break;
	}

     // Fix Props:
    if(instance_exists(Floor) && instance_exists(Player)){
        with(instances_matching(CustomProp, "name", "Kelp", "Vent", "EelSkull")){
            if(pit_get(x, y)){
                var t = 100;
                while(t-- > 0){
                    var f = instance_random(instances_matching(Floor, "styleb", false));
                    if(instance_exists(f)){
                        var _x = f.x + 16 + orandom(8),
                            _y = f.y + 16 + orandom(8),
                            p = instance_nearest(x, y, Player);

                        if(point_distance(p.x, p.y, _x, _y) > 48){
                            x = _x;
                            y = _y;
                        }
                        else continue;
                    }
                    break;
                }
            }
        }
    }

#define area_finish
    lastarea = area;
    lastsubarea = subarea;

     // Area End:
    if(subarea >= area_subarea()){
        var n = area_next();
        if(!is_array(n)) n = [n];
        if(array_length(n) < 1) array_push(n, mod_current);
        if(array_length(n) < 2) array_push(n, 1);
        area = n[0];
        subarea = n[1];

         // Cursed Caves:
        /* fun fact trench used to exit at 4-1 woah
        with(Player) if(curse || bcurse){
            other.area = 104;
        }
        */

         // who's that bird? \\
        for(var i = 0; i < maxp; i++){
            if(player_get_race(i) == "parrot"){
                unlock_call("parrotB");
                break;
            }
        }
    }

     // Next Subarea: 
    else subarea++;

#define area_transit
	 // Disable Surfaces:
	with([surfPit, surfPitWallBot, surfPitWallTop]) active = false;
	with(surfSpark) active = false;

	 // Reset Pit:
	ds_grid_clear(global.pit_grid, false);

#define area_step
    if(DebugLag) trace_time();

     // Player Above Pits:
    with(Player){
    	var _pit = pit_get(x, bbox_bottom);

         // Do a spin:
    	if(speed < maxspeed - friction){
    		if(_pit){
	            var _x = x + cos(wave / 10) * 0.25 * right,
	                _y = y + sin(wave / 10) * 0.25 * right;
	
	            if(!place_meeting(_x, y, Wall)) x = _x;
	            if(!place_meeting(x, _y, Wall)) y = _y;
    		}
        }

         // Pit Transition FX:
        if(speed > 0 && _pit != pit_get(x - hspeed_raw, bbox_bottom - vspeed_raw)){
        	repeat(3) with(instance_create(x, y, Smoke)){
        		motion_add(other.direction, other.speed / (_pit ? 2 : 3));
        		if(!_pit) sprite_index = sprDust;
        	}
        	sound_play_pitchvol(
        		asset_get_index("sndFootPlaRock" + choose("1", "3", "4", "5", "6")),
        		0.5 + orandom(0.1),
        		(_pit ? 0.8 : 0.5)
        	);
        }
    }

     // Floaty Effects Above Pits:
    with(instances_matching([WepPickup, chestprop, RadChest], "", null)){
        if(pit_get(x, bbox_bottom)){
            var _x = x + cos((current_frame + x + y) / 10) * 0.15,
                _y = y + sin((current_frame + x + y) / 10) * 0.15;

            if(!place_meeting(_x, y, Wall)) x = _x;
            if(!place_meeting(x, _y, Wall)) y = _y;
        }
    }

     // Stuff Falling Into Pits:
    with(instances_matching_le(instances_matching([Debris, Shell, ChestOpen, Feather], "trenchpit_check", null), "speed", 1)){
        if(speed <= 0) trenchpit_check = true;
        if(pit_get(x, bbox_bottom)){
            pit_sink(x, y, sprite_index, image_index, image_xscale, image_yscale, image_angle, direction, speed, orandom(1));
            instance_destroy();
        }
    }
    with(instances_matching_ne(instances_matching(instances_matching(Corpse, "trenchpit_check", null), "image_speed", 0), "sprite_index", sprPStatDead)){
        if(instance_exists(enemy) || instance_exists(Portal)){
            if(speed <= 0) trenchpit_check = true;
            if(pit_get(x, y)){
                pit_sink(x, y, sprite_index, image_index, image_xscale, image_yscale, image_angle, direction, speed, orandom(0.6))
                instance_destroy();
            }
        }
    }

     // Destroy PitSink Objects, Lag Helper:
    var s = instances_matching(CustomObject, "name", "PitSink"),
        m = array_length(s);

    while(m > 80) with(s[--m]) instance_destroy();

    if(DebugLag) trace_time("trench_step");

#define area_end_step
	if(DebugLag) trace_time();
	
     // Update Pit Grid:
    with(instances_matching_ne(instances_matching_ne(Floor, "sprite_index", spr.FloorTrenchB), "trenchpit_check", false)){
    	trenchpit_check = false;
    	for(var _x = bbox_left; _x < bbox_right + 1; _x += 16){
    		for(var _y = bbox_top; _y < bbox_bottom + 1; _y += 16){
    			pit_set(_x, _y, false);
    		}
    	}
    }
    with(instances_matching_ne(instances_matching(Floor, "sprite_index", spr.FloorTrenchB), "trenchpit_check", true)){
    	trenchpit_check = true;
    	for(var _x = bbox_left; _x < bbox_right + 1; _x += 16){
    		for(var _y = bbox_top; _y < bbox_bottom + 1; _y += 16){
    			pit_set(_x, _y, true);
    		}
    	}
    }

     // Fix scorchmarks showing above pits:
    with(instances_matching([Scorch, ScorchTop, MeltSplat, GroundFlame, BlueFlame], "trenchpit_check", null)){
        trenchpit_check = true;

        var	_kill = true,
        	l = 12;

        for(var d = 0; d < 360; d += 45){
        	if(pit_get(x + lengthdir_x(l, d), y + lengthdir_y(l, d))){
                depth = 9;
            }
            else _kill = false;
        }

        if(_kill) instance_destroy();
    }
	
	if(DebugLag) trace_time("trench_end_step");

#define area_effect(_vx, _vy)
    var _x = _vx + random(game_width),
        _y = _vy + random(game_height);

     // Player Bubbles:
    if(chance(1, 4)){
        with(Player) instance_create(x, y, Bubble);
    }

     // Pet Bubbles:
    if(chance(1, 4)){
        with(instances_matching(CustomHitme, "name", "Pet")) instance_create(x, y, Bubble);
    }

     // Floor Bubbles:
    else{
        var f = instance_nearest(_x, _y, Floor);
        with(f) instance_create(x + random(32), y + random(32), Bubble);
    }

    return 30 + random(20);

#define area_make_floor
    var _x = x,
        _y = y,
        _outOfSpawn = (point_distance(_x, _y, 10016, 10016) > 48);

     // Making Pits:
    styleb = false;
    if(_outOfSpawn){
        var _floorNum = array_length(instances_matching(Floor, "sprite_index", spr.FloorTrench));
        if(_floorNum >= (1 - (GameCont.subarea * 0.25)) * GenCont.goal){
            styleb = true;
        }
    }

    /// Make Floors:
         // Special - Area Fill
        if(chance(1, 7) && _outOfSpawn){
            var _w = irandom_range(3, 5),
                _h = 8 - _w;

            floor_fill(_x, _y, _w, _h);
        }

         // Normal:
        instance_create(_x, _y, Floor);

	/// Turn:
	    var _trn = 0;
	    if(chance(3, 7)){
            _trn = choose(90, -90, 180);
        }
        direction += _trn;

    /// Chests & Branching:
         // Weapon Chests:
        if(_outOfSpawn && _trn == 180){
            floor_make(_x, _y, WeaponChest);
        }

	     // Ammo Chests + End Branch:
	    var n = instance_number(FloorMaker);
		if(!chance(22, 19 + n)){
			if(_outOfSpawn) floor_make(_x, _y, AmmoChest);
			instance_destroy();
		}

		 // Branch:
		else if(chance(1, 5)){
		    instance_create(_x, _y, FloorMaker);
		}

    /// Crown Vault:
		with(GenCont) if(instance_number(Floor) > goal){
			if(GameCont.subarea == 2 && GameCont.vaults < 3){
				with(instance_furthest(10000, 10000, Floor)){
					with(instance_nearest(
						(((x * 2) + 10000) / 3) + orandom(64),
						(((y * 2) + 10000) / 3) + orandom(64),
						Floor
					)){
						instance_create(x + 16, y + 16, ProtoStatue);
					}
				}
			}
		}

#define area_pop_enemies
    var _x = x + 16,
        _y = y + 16;
    
    if(GameCont.loops > 0 && chance(1, 3)){
        if(chance(1, 5)){
            instance_create(_x, _y, FireBaller);
        }
        else{
            instance_create(_x, _y, choose(LaserCrystal, Salamander));
        }
    }
    else{
         // Anglers:
        if(!styleb && chance(1, 15)){
            obj_create(_x + orandom(4), _y + orandom(4), "Angler");
        }
    
        else{
            if(chance(1, 9)){
                 // Elite Jellies:
                var _eliteChance = 5 * (GameCont.loops + 1);
                if(chance(_eliteChance, 100)){
                    with(obj_create(_x, _y, "JellyElite")){
                        repeat(3) obj_create(x, y, "Eel");
                    }
                }

                 // Jellies:
                else{
                    obj_create(_x, _y, "Jelly");
                    obj_create(_x, _y, "Eel");
                }
            }
    
             // Random Eel Spawns:
            else if(chance(1, 6)){
                obj_create(_x, _y, "Eel");
            }
        }
    }

#define area_pop_props
     // Lone Walls:
    if(
    	chance(1, (styleb ? 3 : 12)) // higher chance of cover over pits
    	&& point_distance(x, y, 10000, 10000) > 96
    	&& !place_meeting(x, y, NOWALLSHEREPLEASE)
	){
        var _x = x + choose(0, 16),
            _y = y + choose(0, 16);
            
        if(!place_meeting(_x, _y, hitme)){
			instance_create(_x, _y, Wall);
			instance_create(x, y, NOWALLSHEREPLEASE);
        }
    }
    
     // Prop Spawns:
    else if(chance(1, 16) && !styleb){
        var _x = x + 16,
            _y = y + 16,
        	_spawnDis = point_distance(_x, _y, 10016, 10016);
        	
		if(_spawnDis > 48){
	    	if(chance(1, 10)){
	    		obj_create(_x, _y, "EelSkull");
	    	}
			else{
	        	obj_create(_x + orandom(8), _y + orandom(8), choose("Kelp", "Kelp", "Vent"));
			}
		}
    }

     // Top Decals:
    if(chance(1, 80)){
        TopDecal_create(x + 16, y + 16, "trench");
    }

#define area_pop_extras
     // The new bandits
    with(instances_matching([WeaponChest, AmmoChest, RadChest], "", null)){
        obj_create(x, y, "Diver");
    }
    with(Bandit){
        obj_create(x, y, "Diver");
        instance_delete(id);
    }

     // Delete Details:
    with(instances_matching(Floor, "styleb", true)){
        with(Detail) if(place_meeting(x,y,other)){
            instance_destroy();
        }
    }
    
     // Got too many eels, bro? No problem:
	with(instances_matching(CustomEnemy, "name", "Eel")) if(array_length(instances_matching(CustomEnemy, "name", "Eel")) > (8 + (4 * GameCont.loops))){
		obj_create(0, 0, "WantEel");
		instance_delete(id);
	}
	
	 // Eel Party Event:
	if(GameCont.subarea != 3 && chance((1 + GameCont.loops), 25)){
		repeat(20 + irandom(10)) obj_create(0, 0, "WantEel");
	}


/// Pit Code:
#define pit_sink(_x, _y, _spr, _img, _xsc, _ysc, _ang, _dir, _spd, _rot)
    with(instance_create(_x, _y, CustomObject)){
        name = "PitSink";

         // Visual:
        sprite_index = _spr;
        image_index = _img;
        image_xscale = _xsc;
        image_yscale = _ysc;
        image_angle = _ang;
        image_speed = 0;
        visible = false;

         // Vars:
        if(_dir == 0) direction = random(360);
        else direction = _dir;
        speed = max(_spd, 1);
        friction = 0.01;
        rotspeed = _rot;

        on_step = pit_sink_step;

        return id;
    }

#define pit_sink_step
     // Blackness Consumes:
    image_blend = merge_color(image_blend, c_black, 0.05 * current_time_scale);

     // Shrink into Abyss:
    var d = random_range(0.001, 0.01) * current_time_scale
    image_xscale -= sign(image_xscale) * d;
    image_yscale -= sign(image_yscale) * d;
    if(vspeed < 0) vspeed *= 0.9;
    y += 1/3 * current_time_scale;

     // Spins:
    direction += rotspeed * current_time_scale;
    image_angle += rotspeed * current_time_scale;

     // He gone:
    if(abs(image_xscale) < 2/3){
    	instance_destroy();
    }

#define draw_pit
    if(!instance_exists(GenCont)){
    	if(DebugLag) trace_time();
    	
		 // Pit Surfaces Follow Screen:
		var _vx = view_xview_nonsync,
			_vy = view_yview_nonsync,
			_vw = game_width,
			_vh = game_height,
			_x = floor(_vx / _vw) * _vw,
			_y = floor(_vy / _vh) * _vh;

		with([surfPit, surfPitWallBot, surfPitWallTop]){
			if(_x != x || _y != y){
				x = _x;
				y = _y;
				reset = true;
			}
			w = _vw * 2;
			h = _vh * 2;
		}

		 // Pit Walls:
        with([surfPitWallBot, surfPitWallTop]) if(surface_exists(surf)){
			if(reset){
			    reset = false;

				var _surfx = x,
					_surfy = y;

				surface_set_target(surf);
				draw_clear_alpha(0, 0);

				var _inst = [
					instances_matching(Floor, "sprite_index", spr.FloorTrench),		// Normal
					instances_matching([Wall, FloorExplo], "styleb", false, null)	// Small
				];
				with(draw){
					for(var j = 0; j < array_length(self); j++){
						var s = self[j];
						with(_inst[j]) draw_sprite(s, image_index, x - _surfx, y - _surfy);
					}
				}

				surface_reset_target();
			}
		}

		 // Pit:
        with(surfPit) if(surface_exists(surf)){
			var _surfx = x,
				_surfy = y;

			surface_set_target(surf);

			 // Pit Mask:
			if(reset){
				reset = false;

				draw_clear_alpha(0, 0);
				draw_set_color(c_black);

				with(instance_rectangle(x, y, x + w, y + h, instances_matching(Floor, "styleb", true))){
					draw_sprite(sprite_index, image_index, x - _surfx, y - _surfy);
				}
			}

	         // DRAW YOUR PIT SHIT HERE:
			draw_set_color_write_enable(true, true, true, false);
			draw_set_color(BackCont.shadcol); // long live blue trench
			draw_rectangle(0, 0, w, h, false);

				 // Pit Spark:
				with(instances_matching(instances_matching(CustomObject, "name", "PitSpark"), "tentacle_visible", true)){
					var _sparkRadius = [[25, 20], [20, 10]],
						_sparkBright = (floor(image_index) % 2);

					for(var i = 0; i <= !dark; i++){
						with(surfSpark[i]){
							var _x = w / 2,
								_y = h / 2;
	
							surface_set_target(surf);
							draw_clear_alpha(0, 0);
		
							with(other){
								 // Draw mask:
								draw_set_color_write_enable(true, true, true, true);
								draw_circle(_x, _y, _sparkRadius[i + dark][_sparkBright] + irandom(1), false);
								draw_set_color_write_enable(true, true, true, false);

								 // Draw tentacle:
								var t = tentacle;
								draw_sprite_ext(
									spr.TentacleWheel, 
									i, 
									_x + lengthdir_x(t.distance, t.move_dir), 
									_y + lengthdir_y(t.distance, t.move_dir), 
									image_xscale * t.scale * t.right, 
									image_yscale * t.scale, 
									t.rotation, 
									merge_color(c_black, image_blend, (visible ? (image_index / image_number) : ((alarm0 > 3) ? 1 : (((current_frame + x + y) / 2) % 2)))),
									image_alpha
								);
							}
						}
					}

					surface_set_target(other.surf);

					for(var i = 0; i <= !dark; i++){
						with(surfSpark[i]){
							draw_surface(surf, other.x - _surfx - (w / 2), other.y - _surfy - (h / 2));
						}
					}
				}
				
				 // Tentacle Outlines:
				var	_arms = instances_seen_nonsync(instances_matching_le(instances_matching(instances_matching(CustomEnemy, "name", "PitSquidArm"), "visible", true), "nexthurt", current_frame), 32, 32),
					_alpha = 0.3 + (0.25 * sin(current_frame / 10));
					
					 // Anti-Aliasing:
					draw_set_fog(true, make_color_rgb(24, 21, 33), 0, 0);
					with(_arms) for(var i = -1; i <= 1; i += 2){
						draw_sprite_ext(sprite_index, image_index, ((teleport ? teleport_drawx : x) - _surfx) + i, ((teleport ? teleport_drawy : y) - _surfy) - 1, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha * (_alpha * 2))
					}
					
					 // Outlines:
					draw_set_fog(true, make_color_rgb(235, 0, 67), 0, 0);
					with(_arms)	for(var d = 0; d <= 180; d += 90){
						draw_sprite_ext(sprite_index, image_index, ((teleport ? teleport_drawx : x) - _surfx) + lengthdir_x(1, d), ((teleport ? teleport_drawy : y) - _surfy) + lengthdir_y(1, d), image_xscale * right, image_yscale, image_angle, image_blend, image_alpha * _alpha)
					}
					
					draw_set_fog(false, c_white, 0, 0);
					
				 // Pit Squid:
				with(instances_matching(CustomEnemy, "name", "PitSquid")){
					var	_hurt = (nexthurt > current_frame + 3),
						_xscal = image_xscale * max(pit_height, 0),
						_yscal = image_yscale * max(pit_height, 0),
						_angle = image_angle,
						_blend = merge_color(c_black, image_blend, clamp(pit_height, 0, 1) * (intro ? 1 : 1/3)),
						_alpha = image_alpha;

					 // Eyes:
					with(eye){
						var	_x = x - _surfx,
							_y = y - _surfy,
							l = dis * max(other.pit_height, 0),
							d = dir;

						with(other){
							 // Cornea + Pupil:
							if(_hurt) draw_set_fog(true, _blend, 0, 0);
							if(other.blink_img < sprite_get_number(spr.PitSquidEyelid) - 1){
								draw_sprite_ext(spr.PitSquidCornea, image_index, _x,                                    _y,                                    _xscal, _yscal, _angle, _blend, _alpha);
								draw_sprite_ext(spr.PitSquidPupil,  image_index, _x + lengthdir_x(l * image_xscale, d), _y + lengthdir_y(l * image_yscale, d), _xscal, _yscal, _angle, _blend, _alpha);
							}
							if(_hurt) draw_set_fog(false, 0, 0, 0);

							 // Eyelid:
							draw_sprite_ext(spr.PitSquidEyelid, other.blink_img, _x, _y, _xscal, _yscal, _angle, _blend, _alpha);
						}
					}

					 // Bite:
					if(bite > 0 && bite <= 1){
						draw_sprite_ext(spr_bite, ((1 - bite) * sprite_get_number(spr_bite)), posx - _surfx, posy - _surfy, _xscal, _yscal, _angle, _blend, _alpha);
					}

				     // Spit:
					else if(spit > 0 && spit <= 1){
						draw_sprite_ext(spr_fire, ((1 - spit) * sprite_get_number(spr_fire)), posx - _surfx, posy - _surfy, _xscal, _yscal, _angle, _blend, _alpha);
					}
				}
				with(instances_matching(CustomObject, "name", "PitSquidDeath")){
					var	_xscal = image_xscale * max(pit_height, 0),
						_yscal = image_yscale * max(pit_height, 0),
						_angle = image_angle,
						_blend = merge_color(c_black, image_blend, clamp(pit_height, 0, 1)),
						_alpha = image_alpha;
						
					with(eye){
						var	_x = x - _surfx,
							_y = y - _surfy,
							l = dis * max(other.pit_height, 0),
							d = dir;
							
						with(other){
							if(explo){
								draw_set_fog(((current_frame % 6) < 2 || (!sink && pit_height < 1)), _blend, 0, 0);
								draw_sprite_ext(spr.PitSquidCornea, image_index, _x,                                    _y,                                    _xscal,       _yscal, _angle, _blend, _alpha);
								draw_sprite_ext(spr.PitSquidPupil,  image_index, _x + lengthdir_x(l * image_xscale, d), _y + lengthdir_y(l * image_yscale, d), _xscal * 0.5, _yscal, _angle, _blend, _alpha);
								draw_set_fog(false, 0, 0, 0);
							}
							draw_sprite_ext(spr.PitSquidEyelid, (explo ? 0 : sprite_get_number(spr.PitSquidEyelid) - 1), _x, _y, _xscal, _yscal, _angle, _blend, _alpha);
						}
					}
				}

				 // Octo pet:
				with(instances_matching(instances_matching(instances_matching(CustomHitme, "name", "Pet"), "pet", "Octo"), "hiding", true)){
					draw_sprite_ext(sprite_index, image_index, x - _surfx, y - _surfy, image_xscale, image_yscale, image_angle, image_blend, visible);
				}

				 // Pit Walls:
				with(surfPitWallBot) if(surface_exists(surf)){
					draw_surface(surf, x - other.x, y - other.y);
				}
				
				 // WantEel:
				with(instances_matching(instances_matching(CustomEnemy, "name", "WantEel"), "active", true)){
					draw_sprite_ext(sprite, (current_frame * current_time_scale * image_speed) % 16, (xpos - _surfx), (ypos - _surfy) + (12 * (1 - pit_height)), ((image_xscale * pit_height) * right), (image_yscale * pit_height), image_angle, image_blend, visible);
				}

				 // Make Proto Statues Cooler:
				with(ProtoStatue){
					if(pit_get(x, bbox_bottom)){
						spr_shadow = -1;

						var _spr = spr.PStatTrenchIdle;
						if(sprite_index == spr_hurt) _spr = spr.PStatTrenchHurt;
						draw_sprite(_spr,                  image_index, x - _surfx, y - _surfy);
						draw_sprite(spr.PStatTrenchLights, anim,        x - _surfx, y - _surfy);
				
						// base game doesnt use draw_sprite_ext either
					}
				}
				with(instances_matching(Corpse, "sprite_index", sprPStatDead)){
					if(pit_get(x, bbox_bottom)){
						draw_sprite_ext(spr.PStatTrenchIdle, image_index, x - _surfx, y - _surfy, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
						if(place_meeting(x, y, Portal)){
							var n = instance_nearest(x, y, Portal),
							    _spr = spr.PStatTrenchLights,
							    _img = 0;

							switch(n.sprite_index){
								case sprPortalSpawn:
								case sprProtoPortal:
									_img = (sprite_get_number(_spr) - 1) - 2 + (2 * sin(current_frame / 16));
									break;

								case sprProtoPortalDisappear:
									_img = (sprite_get_number(_spr) - 1) * (1 - (n.image_index / n.image_number));
									break;

								default:
									_img = 0;
							}

							if(_img > 0){
								draw_sprite_ext(_spr, _img, x - _surfx, y - _surfy, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
							}
						}
					}
				}

				 // Stuff that fell in pit:
				with(instances_matching(CustomObject, "name", "PitSink")){
					draw_sprite_ext(sprite_index, image_index, x - _surfx, y - _surfy, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
				}

				 // Pit Wall Tops:
				with(surfPitWallTop) if(surface_exists(surf)){
					draw_surface(surf, x - other.x, y - other.y);
				}

			draw_set_color_write_enable(true, true, true, true);
			surface_reset_target();

			draw_surface(surf, x, y);
        }

    	if(DebugLag) trace_time("trench_draw_pit");
    }

#define pit_get(_x, _y)
	return global.pit_grid[# _x / 16, _y / 16];

#define pit_set(_x, _y, _bool)
	global.pit_grid[# _x / 16, _y / 16] = _bool;

	 // Reset Pit Surfaces:
    with([surfPit, surfPitWallBot, surfPitWallTop]){
    	reset = true;
    }

	 // Reset Pit Sink Checks:
	with(instances_matching_ne([Debris, Shell, ChestOpen, Feather, Corpse, Scorch, ScorchTop, MeltSplat, GroundFlame, BlueFlame], "trenchpit_check", null)){
	    trenchpit_check = null;
	}


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