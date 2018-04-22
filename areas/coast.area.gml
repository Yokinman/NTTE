#define init
    { //sprites
    	global.sprCoastTrans    = sprite_add("../sprites/areas/Coast/sprCoastTrans.png",    1, 0,  0);
    	global.sprFloorCoast    = sprite_add("../sprites/areas/Coast/sprFloorCoast.png",    4, 2,  2);
    	global.sprFloorCoastB   = sprite_add("../sprites/areas/Coast/sprFloorCoastB.png",   3, 2,  2);
    	global.sprDetailCoast   = sprite_add("../sprites/areas/Coast/sprDetailCoast.png",   6, 4,  4);

    	//global.sprFloorCoastTrans = sprite_add("../sprites/areas/Coast/sprFloorCoastTrans.png", 4, 0, 0);

    	global.sprBloomingCactusIdle[0] = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactus.png",     1, 12, 12);
    	global.sprBloomingCactusHurt[0] = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactusHurt.png", 3, 12, 12);
    	global.sprBloomingCactusDead[0] = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactusDead.png", 4, 12, 12);

    	global.sprBloomingCactusIdle[1] = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactus2.png",     1, 12, 12);
    	global.sprBloomingCactusHurt[1] = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactus2Hurt.png", 3, 12, 12);
    	global.sprBloomingCactusDead[1] = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactus2Dead.png", 4, 12, 12);

    	global.sprBloomingCactusIdle[2] = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactus3.png",     1, 12, 12);
    	global.sprBloomingCactusHurt[2] = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactus3Hurt.png", 3, 12, 12);
    	global.sprBloomingCactusDead[2] = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactus3Dead.png", 4, 12, 12);

    	global.sprPalmIdle = sprite_add("../sprites/areas/Coast/Props/sprPalm.png",     1, 24, 40);
    	global.sprPalmHurt = sprite_add("../sprites/areas/Coast/Props/sprPalmHurt.png", 3, 24, 40);
    	global.sprPalmDead = sprite_add("../sprites/areas/Coast/Props/sprPalmDead.png", 4, 24, 40);
    }

     // Sea/Surface Business:
    global.surfW = 5000;
    global.surfH = 5000;
    global.surfX = 10000 - (global.surfW / 2);
    global.surfY = 10000 - (global.surfH / 2);
    global.surfTrans = -1;
    global.surfWaves = -1;
    global.surfWavesSub = -1;
    global.surfSwim = -1;
    global.surfSwimBot = -1;
    global.surfSwimTop = -1;
    global.surfSwimSize = 1000;
    global.swimInst = [Corpse, ChestOpen, chestprop, WepPickup, AmmoPickup, HPPickup, Grenade, hitme];
    global.swimInstVisible = [];
    global.seaDepth = 10.1;

     // Prevent Crash on Mod Reload:
    if(GameCont.area == mod_current){
        with(instances_matching(prop, "name", "BloomingCactus", "Palm")) instance_destroy();
    }

#macro DebugLag 0
#macro CanLeaveCoast (instance_exists(Portal) || (instance_number(enemy) - instance_number(Van) <= 0))

#define area_name(sub, loop)
    return "@1(sprInterfaceIcons)-" + string(sub);

#define area_secret
    return 1;

#define area_sprite(_spr)
    switch(_spr){
        case sprFloor1:         return global.sprFloorCoast;
        case sprFloor1B:        return global.sprFloorCoastB;
        case sprFloor1Explo:    return sprFloor1Explo;
        case sprWall1Trans:     return sprWall1Trans;
        case sprWall1Bot:       return sprWall1Bot;
        case sprWall1Out:       return sprWall1Out;
        case sprWall1Top:       return sprWall1Top;
        case sprDebris1:        return sprDebris1;
    	case sprDetail1:        return global.sprDetailCoast;
    }

#define area_setup
    goal = 100;
    BackCont.shadcol = c_black;
    background_color = make_color_rgb(27, 118, 184);

#define area_start
     // No Walls:
    with(Wall) instance_destroy();
    with(FloorExplo) instance_destroy();

     // Top Decals:
    with(TopSmall){
        if(random(80) < 1) obj_create(x, y, "CoastDecal");
        instance_destroy();
    }

     // Bind Sea Drawing Scripts:
	if(array_length(instances_matching(CustomDraw, "name", "darksea_draw")) <= 0){
    	with(script_bind_draw(darksea_draw, global.seaDepth)){
    		name = script[2];
    		wave = 0;
    		flash = 0;
    	}
	}
    if(array_length(instances_matching(CustomDraw, "name", "swimtop_draw")) <= 0){
        with(script_bind_draw(swimtop_draw, -1)) name = script[2];
    }

#define area_step
     // No Portals:
	with(Corpse) do_portal = 0;

	if(instance_exists(Floor)){
         // Destroy Projectiles Too Far Away:
        with(instances_matching_gt(projectile, "speed", 0)){
            if(distance_to_object(Floor) > 1000) instance_destroy();
        }

         // Player:
        with(instances_matching_gt(Player, "wading", 0)){
			 // Player Moves 20% Slower in Water:
            if(speed > 0){
                var f = ((race == "fish") ? 0 : -0.2) + (0.2 * skill_get(mut_extra_feet));
                if(f != 0){
                    x += hspeed * f;
                    y += vspeed * f;
                }
            }

             // Walk into Sea for Next Level:
            if(CanLeaveCoast){
                if(wading > 120 && !instance_exists(Portal)){
                    instance_create(x, y, Portal);

                     // Switch Sound:
                    sound_stop(sndPortalOpen);
                    sound_play(sndOasisPortal);
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

    	 // Water Wading Surfaces:
        var _surfx = global.surfX,
            _surfy = global.surfY,
            _surfw = global.surfW,
            _surfh = global.surfH,
            _surfSwimw = global.surfSwimSize,
            _surfSwimh = global.surfSwimSize;

        if(!surface_exists(global.surfSwim)) global.surfSwim = surface_create(_surfSwimw, _surfSwimh);
        if(!surface_exists(global.surfSwimBot)) global.surfSwimBot = surface_create(_surfw, _surfh);
        if(!surface_exists(global.surfSwimTop)) global.surfSwimTop = surface_create(_surfw, _surfh);

        var _surfSwim = global.surfSwim,
            _surfSwimBot = global.surfSwimBot,
            _surfSwimTop = global.surfSwimTop;

        surface_set_target(_surfSwimBot);
        draw_clear_alpha(0, 0);
        surface_set_target(_surfSwimTop);
        draw_clear_alpha(0, 0);
        surface_reset_target();

         // Water Wading:
        if(DebugLag) trace_time();
        var _inst = instances_matching(instances_matching_lt(instances_matching(global.swimInst, "visible", 1), "depth", global.seaDepth), "nowade", null),
            _lag = (array_length(_inst) > 100), // When there's over 100 swimmable objects, don't draw them swimming when they're offscreen
            _wadeCol = make_color_rgb(44, 37, 122),
            v = 0;

        global.swimInstVisible = [];

		with(_inst){
		    if("wading" not in self) wading = 0;

			var o = (object_index == Player),
			    _splashvol = (o ? 1 : clamp(1 - (distance_to_object(Player) / 150), 0.1, 1)),
			    _dis = distance_to_object(Floor);

			if(_dis > 4){
				 // Splash:
				if(wading <= 0){
					instance_create(x, y, RainSplash);
					repeat(irandom_range(4, 8)) instance_create(x, y, Sweat/*Bubble*/);
                    sound_play_pitchvol(choose(sndOasisChest, sndOasisMelee), 1.5 + random(0.5), _splashvol);
				}
				wading = _dis;

				 // Push Back to Shore:
				if(
				    _dis >= 80                   &&
				    !CanLeaveCoast               &&
				    !instance_is(id, Corpse)     && // Don't push corpses
				    !instance_is(id, ChestOpen)  && // Don't push chest corpses
                    !instance_is(id, projectile)    // Don't push projectiles
				){
    			    var n = instance_nearest(x - 16, y - 16, Floor);
    				motion_add(point_direction(x, y, n.x, n.y), 4);
    			}

                var _draw = !_lag;
                if(!_draw) _draw = point_seen(x, y, -1);
			    if(_draw){
			        global.swimInstVisible[v++] = id;

                     // Wading Vars:
                    var _z = 2,
                        _wh = _z + (sprite_height - sprite_get_bbox_bottom(sprite_index)) + ((_dis - 16) * 0.2),
                        _surfSwimx = x - (_surfSwimw / 2),
                        _surfSwimy = y - (_surfSwimh / 2);
    
                    if(object_index == Van){
                        var c = 40;
                        if(_wh > c) _wh = c;
                    }
                    else if(!o || !CanLeaveCoast){
                        var c = sprite_yoffset;
                        if(_wh > c) _wh = c;
                    }
    
                     // Bobbing:
                    if(_dis > sprite_height || !instance_is(id, hitme)){
                        var _bobspd = 1 / 10,
                            _bobmax = min(_dis / sprite_height, 2),
                            _bob = _bobmax * sin((current_frame + x + y) * _bobspd);
                        
                        _z += _bob;
                        _wh += _bob;
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
                        if(CanLeaveCoast && distance_to_object(Portal) <= 0){
                            s.image_xscale = image_xscale;
                            s.image_yscale = image_yscale;
                            s.image_alpha  = image_alpha;
                            with(instance_nearest(x, y, Portal)) with(other){
                                var f = min(0.5 + (other.endgame / 60), 1);
                                image_xscale *= f;
                                image_yscale *= f;
                                image_alpha  *= f;
                            }
                        }
                    }

                     // Call Draw Event to Surface:
                    surface_set_target(_surfSwim);
                    draw_clear_alpha(0, 0);

                    x -= _surfSwimx;
                    y -= _surfSwimy;
                    if("right" in self || "rotation" in self) event_perform(ev_draw, 0);
                    else draw_self();
                    x += _surfSwimx;
                    y += _surfSwimy;

                    surface_reset_target();

                     // Set Saved Vars:
                    if(s != {}){
                        for(var i = 0; i < lq_size(s); i++){
                            var k = lq_get_key(s, i);
                            variable_instance_set(id, k, lq_get(s, k));
                        }
                    }

                    /// Draw Bottom:
                    surface_set_target(_surfSwimBot);
                        var _yoff = _surfSwimh - ((_surfSwimh / 2) - (sprite_height - sprite_yoffset)),
                            _y = _surfSwimy + _z,
                            t = _yoff - _wh,
                            h = _surfSwimh - t;

                        d3d_set_fog(1, _wadeCol, 0, 0);
                        draw_surface_part(_surfSwim, 0, t, _surfSwimw, h, _surfSwimx - _surfx, (_y + t) - _surfy);
                        d3d_set_fog(0, 0, 0, 0);
                    surface_reset_target();

                    /// Draw Top:
                    surface_set_target(_surfSwimTop);
                         // Manually Draw Laser Sights:
                        if(o && canscope){
                            draw_set_color(c_red);

                            var w = [wep];
                            if(race == "steroids") w = [wep, bwep];
                            for(var i = 0; i < array_length(w); i++) if(weapon_get_laser_sight(w[i])){
                                var _wepspr = weapon_get_sprt(w[i]),
                                    _sx = x,
                                    _sy = y + _z - (i * 4),
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
                                    _dx=[   _sx,
                                            _sx + ((_lx - _sx) / 10),// ~ ~
                                            _lx
                                        ],
                                    _dy=[   _sy,
                                            _sy + ((_ly - _sy) / 10),
                                            _ly
                                        ];

                                draw_primitive_begin(pr_trianglestrip);
                                draw_set_alpha((sin(degtorad(gunangle)) * 5) - (max(_wh - (sprite_yoffset - 2), 0)));
                                for(var j = 0; j < array_length(_dx); j++){
                                    draw_vertex(_dx[j] - _surfx,       _dy[j] - _surfy);
                                    draw_vertex(_dx[j] - _surfx + _ox, _dy[j] - _surfy + _oy);
                                    draw_set_alpha(1);
                                }
                                draw_primitive_end();

                                //draw_sprite_ext(sprLaserSight, -1, _sx, _sy, (point_distance(_sx, _sy, _lx, _ly) / 2) + 2, 1, gunangle, c_white, 1);
                            }
                            draw_set_alpha(1);
                        }

                         // Self:
                        draw_surface_part(_surfSwim, 0, 0, _surfSwimw, t, _surfSwimx - _surfx, _y - _surfy);

                         // Water Interference Line Thing:
                        d3d_set_fog(1, c_white, 0, 0);
                        draw_surface_part_ext(_surfSwim, 0, t, _surfSwimw, 1, _surfSwimx - _surfx, (_y + t) - _surfy, 1, 1, c_white, 0.8);
                        d3d_set_fog(0, 0, 0, 0);
                    surface_reset_target();
			    }
			}
			else if(wading > 0){
			    wading = 0;

			     // Sploosh:
                sound_play_pitchvol(choose(sndOasisChest, sndOasisMelee, sndOasisHurt), 1 + random(0.25), _splashvol);
				repeat(5 + random(5)) with(instance_create(x, y, Sweat)){
				    motion_add(other.direction, other.speed);
				}
		    }
		}
		if(DebugLag) trace_time("Wading");

		 // Set Visibility of Swimming Objects Before & After Drawing Events:
    	script_bind_step(reset_visible, 0, 0);
    	script_bind_draw(reset_visible, -14, 1);
	}

     // things die bc of the missing walls
	with(instances_matching(enemy, "canfly", 0)) canfly = 1;

     // Weird fix for ultra bolts destroying themselves when not touching a floor. doesn't really work well with bolt marrow:
    with(UltraBolt){
        if(!place_meeting(x, y, Floor)){
            with(instance_create(0, 0, Floor)){
                x = other.x;
                y = other.y;
                xprevious = x;
                yprevious = y;
                name = "UltraBoltCoastFix";
                mask_index = sprBoltTrail;
                creator = other;
                visible = 0;
            }
        }
    }

     // Bind End Step:
    script_bind_end_step(end_step, 0);

#define end_step
     // Watery Dust:
    with(instances_matching(Dust, "coast_water", null)){
        coast_water = 1;
        if(!place_meeting(x, y, Floor)){
            if(random(5) < 1 && point_seen(x, y, -1)){
                sound_play(choose(sndOasisChest, sndOasisCrabAttack, sndOasisMelee));
            }
            instance_create(x, y, choose(Sweat, Sweat, Sweat, Bubble));
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
        var _vol = max((20 / (distance_to_object(Player) + 1)) * (0.25 + (distance_to_object(Floor) / 50)), 0.15);
        if(e > 0) sound_play_pitchvol(sndOasisExplosion, 1, e * _vol);
        if(s > 0) sound_play_pitchvol(sndOasisExplosion, 1, s * _vol);
    }

     // Watery Melting Scorch Marks:
    with(instances_matching(MeltSplat, "coast_water", null)){
        coast_water = 1;
        if(!position_meeting(x, y, Floor)){
            sound_play(sndOasisExplosionSmall);
            repeat((sprite_index == sprMeltSplatBig) ? 16 : 8){
                instance_create(x, y, choose(Sweat, Sweat, Sweat, Bubble));
            }
            instance_destroy();
        }
    }

    with(instances_matching(Floor, "name", "UltraBoltCoastFix")) instance_destroy();

    instance_destroy();

#define area_make_floor
    var _x = x,
        _y = y,
        _outOfSpawn = (point_distance(_x, _y, 10016, 10016) > 48);

    /// Make Floors:
         // Special - 4x4 to 6x6 Rounded Fills:
        if(random(5) < 1){
            scrFloorFillRound(_x, _y, irandom_range(4, 6), irandom_range(4, 6));
        }

         // Normal - 2x1 Fills:
        else scrFloorFill(_x, _y, 2, 1);

     // Change Direction:
    var _trn = 0;
    if(random(7) < 3) _trn = choose(90, -90, 180);
    direction += _trn;

     // Turn Arounds:
    if(_trn == 180){
         // Weapon Chests:
        if(_outOfSpawn) scrFloorMake(_x, _y, WeaponChest);

         // Start New Island:
        if(random(2) < 1){
            var d = direction + 180;
            _x += lengthdir_x(96, d);
            _y += lengthdir_y(96, d);
            with(instance_create(_x, _y, FloorMaker)) direction = d + choose(-90, 0, 90);
            if(_outOfSpawn){
                instance_create(_x + 16, _y + 16, choose(AmmoChest, WeaponChest, RadChest));
            }
        }
    }

     // Ammo Chests (Dead Ends):
    if(random(19 + instance_number(FloorMaker)) > 22){
        if(_outOfSpawn) scrFloorMake(_x, _y, AmmoChest)
        instance_destroy();
    }

#define scrFloorMake(_x, _y, _obj)
    return mod_script_call("mod", "ntte", "scrFloorMake", _x, _y, _obj);

#define scrFloorFill(_x, _y, _w, _h)
    return mod_script_call("mod", "ntte", "scrFloorFill", _x, _y, _w, _h);

#define scrFloorFillRound(_x, _y, _w, _h)
    return mod_script_call("mod", "ntte", "scrFloorFillRound", _x, _y, _w, _h);

#define area_finish
     // Area End:
    if(lastarea = mod_current && subarea >= 3) {
    	area = 101;
    	subarea = 1;
    }

     // Next Subarea: 
    else{
    	lastarea = area;
    	subarea++;
    }

#define area_pop_enemies
    var _x = x + 16,
        _y = y + 16;

    if(random(15) < GameCont.subarea){
        obj_create(_x, _y, choose("TrafficCrab", "Pelican", "Pelican"));
    }
    else{
        obj_create(_x, _y, choose("Diver", "Diver", "Gull", "Gull", "Gull", "Gull", "Gull", "TrafficCrab"))
    }

#define area_pop_props
    if(random(12) < 1){
        var o = choose("BloomingCactus", "BloomingCactus", "BloomingCactus", "Palm");
        scrCoastProp(x + (sprite_width / 2), y + (sprite_height / 2), o);
    }

#define darksea_draw
    if(DebugLag) trace_time();

    var _surfTrans = global.surfTrans,
        _surfWaves = global.surfWaves,
        _surfWavesSub = global.surfWavesSub,
        _surfSwimBot = global.surfSwimBot,
        _surfSwimTop = global.surfSwimTop,
        _surfw = global.surfW,
        _surfh = global.surfH,
        _surfx = global.surfX,
        _surfy = global.surfY,
        _wave = wave++,
        _floor = instances_matching(instances_matching(Floor, "coast_water", null), "visible", 1);

     // Draw Floor Transition Tile Surface:
    if(array_length(_floor) > 0 || !surface_exists(_surfTrans)){
         // Surface Setup:
    	if(!surface_exists(_surfTrans)){
    	    global.surfTrans = surface_create(_surfw, _surfh);
    	    _surfTrans = global.surfTrans;
    	}
    	surface_set_target(_surfTrans);
    	draw_clear_alpha(0, 0);

         // Draw Floors to Surface:
    	with(Floor) if(visible){
            var _x = x - _surfx,
                _y = y - _surfy;

    		for(var a = 0; a < 360; a += 45){
    			 // Draw Underwater Transition Tiles:
    			var _spr = global.sprFloorCoast,
    			    _ox = lengthdir_x(32, a),
    			    _oy = lengthdir_y(32, a);

    			draw_sprite(_spr, irandom(sprite_get_number(_spr) - 1), _x + _ox, _y + _oy);

    		     // Fill in Gaps (Cardinal Directions Only):
    		    if((a / 90) == round(a / 90)){
    		        var f = 0;
        			for(var i = 1; i <= 10; i++){
        				if(!position_meeting(x + (_ox * i), y + (_oy * i), Floor)) f++;
        				else break;
        			}
        			if(f <= 5) for(var i = 1; i <= f; i++){
        				draw_sprite(_spr, irandom(sprite_get_number(_spr) - 1), _x + (_ox * i), _y + (_oy * i));
        		    }
    		    }
    		}
        }

    	surface_reset_target();
    }

     // Draw Waves Surface:
    if(array_length(_floor) || !surface_exists(_surfWaves)){
         // Surface Setup:
    	if(!surface_exists(_surfWaves)){
    	    global.surfWaves = surface_create(_surfw, _surfh);
    	    _surfWaves = global.surfWaves;
    	}
    	surface_set_target(_surfWaves);
    	draw_clear_alpha(0, 0);

         // Draw Floors in White to Surface:
    	d3d_set_fog(1, c_white, 1, 1)
    	with(Floor) if(visible){
    	    draw_sprite_ext(global.sprFloorCoast, image_index, x - _surfx, y - _surfy, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    	}
    	with(instances_matching(CustomHitme, "name", "CoastDecal")){
    	    draw_sprite_ext(sprite_index, image_index, x - _surfx, y - _surfy, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    	}
    	d3d_set_fog(0, 0, 0, 0);
        surface_reset_target();

         // Clear Waves Subsurface:
    	if(surface_exists(_surfWavesSub)){
    	    surface_set_target(_surfWavesSub);
    	    draw_clear_alpha(0, 0);
    	    surface_reset_target();
    	}
    }
    with(_floor) coast_water = 1;

    /// Drawing Wave Foam:
         // Surface Setup:
        if(!surface_exists(_surfWavesSub)){
        	global.surfWavesSub = surface_create(_surfw, _surfh);
        	_surfWavesSub = global.surfWavesSub;
        }
        surface_set_target(_surfWavesSub);
    
    	var sfoff = 10, // Does this actually do anything
            _int = 30,  // Interval (Starts every X frames)
    	    _sc1 = 0.5, // Scaler 1
    	    _sc2 = 0.3, // Scaler 2
    	    _len = 8,   // Wave length (Travels X distance)
    	    _siz = 5,   // Wave thickness
            _off = [    // Wave Offsets: !!! Don't edit this !!!
            	    round((_wave mod _int) * _sc1),
            	    round(((_wave - (_siz * _sc2 / _sc1)) mod _int) * _sc2)
            	   ];
    
         // Draw Wave Foam:
    	for(var i = 0; i < array_length(_off); i++){
    	    if(i > 0) draw_set_blend_mode(bm_subtract);
    	    if(_off[i] < _len){
    		    for(var a = 0; a < 360; a += 45){
    		    	draw_surface(_surfWaves, sfoff + lengthdir_x(_off[i], a), sfoff + lengthdir_y(_off[i], a));
    		    }
    	    }
    	}
    	draw_set_blend_mode(bm_normal);
    
    	surface_reset_target();

     // Draw Sea Transition Floor Tiles:
    draw_surface(_surfTrans, _surfx, _surfy);

     // Submerged Rock Decals:
    with(instances_matching(CustomHitme, "name", "CoastDecal")){
        draw_sprite_ext(spr_bot, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    }

     // Draw Bottom Halves of Swimming Objects:
    if(surface_exists(_surfSwimBot)) draw_surface(_surfSwimBot, _surfx, _surfy);
    else global.surfSwimBot = surface_create(_surfw, _surfh);

     // Draw Sea:
    draw_set_color(background_color);
    draw_set_alpha(0.6);
    draw_rectangle(0, 0, 20000, 20000, 0);
    draw_set_alpha(1);

     // Caustics:
    draw_set_alpha(0.4);
    draw_sprite_tiled(global.sprCoastTrans, 0, sin(_wave * 0.02) * 4, sin(_wave * 0.05) * 2);
    draw_set_alpha(1);

     // Foam:
    draw_surface(_surfWavesSub, _surfx - sfoff, _surfy - sfoff);

     // Flash Ocean w/ Can Leave Level:
    if(CanLeaveCoast && !instance_exists(Portal)){
        var _int = 300, // Flash every X frames
            _lst = 30,  // Flash lasts X frames
            _max = ((flash <= _lst) ? 0.3 : 0.15); // Max flash alpha

        draw_set_color(c_white);
        draw_set_alpha(_max * (1 - ((flash mod _int) / _lst)));
        draw_rectangle(0, 0, 20000, 20000, 0);
        draw_set_alpha(1);

        if(!(flash mod _int)){
             // Sound:
            sound_play_pitchvol(sndOasisHorn, 0.5, 2);
            sound_play_pitchvol(sndOasisExplosion, 1 + random(1), ((flash <= 0) ? 1 : 0.4));

             // Effects:
            for(var i = 0; i < maxp; i++) view_shake[i] += 8;
            with(Floor) if(random(5) < 1){
                for(var d = 0; d < 360; d += 45){
                    var _x = x + lengthdir_x(32, d),
                        _y = y + lengthdir_y(32, d);

                    if(!position_meeting(_x, _y, Floor)){
                        repeat(irandom_range(3, 6)){
                            instance_create(_x + random(32), _y + random(32), choose(Sweat, Sweat, Bubble));
                        }
                    }
                }
            }
        }

        flash++;
    }
    else flash = 0;

    if(DebugLag) trace_time("darksea_draw");

#define swimtop_draw
     // Top Halves of Swimming Objects:
    if(surface_exists(global.surfSwimTop)) draw_surface(global.surfSwimTop, global.surfX, global.surfY);
    else global.surfSwimTop = surface_create(global.surfW, global.surfH);

#define reset_visible(_visible)
    var _inst = global.swimInstVisible;
    with(_inst){
        if(instance_exists(self) && visible != _visible) visible = _visible;
        else global.swimInstVisible[array_find_index(_inst, self)] = noone;
    }
    instance_destroy();

#define scrCoastProp(_x, _y, _name)
    switch(_name){
        case "BloomingCactus":
            with(instance_create(_x, _y, Cactus)){
                name = _name;

                var s = irandom(array_length(global.sprBloomingCactusIdle) - 1);
                spr_idle = global.sprBloomingCactusIdle[s];
                spr_hurt = global.sprBloomingCactusHurt[s];
                spr_dead = global.sprBloomingCactusDead[s];

                return id;
            }
        break;

        case "Palm":
            with(instance_create(_x, _y, StreetLight)){
                name = _name;

                spr_idle = global.sprPalmIdle;
                spr_hurt = global.sprPalmHurt;
                spr_dead = global.sprPalmDead;

                snd_hurt = sndHitPlant;
                snd_dead = sndHitPlant;

                my_health = 40;

                return id;
            }
        break;
    }
    return noone;

#define obj_create(_x, _y, object_name)
    return mod_script_call("mod", "telib", "obj_create", _x, _y, object_name);

/*#define area_transit
    if (lastarea != "coast" && area = "bigfish") { //hacky way to make sure you go to the right area
        area = "coast";
    }*/