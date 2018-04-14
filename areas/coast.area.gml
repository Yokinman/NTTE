#define init
    { //sprites
    	global.sprCoastTrans = sprite_add("../sprites/areas/Coast/sprCoastTrans.png", 1, 0, 0);
    	global.sprFloorCoast = sprite_add("../sprites/areas/Coast/sprFloorCoast.png", 4, 2, 2);
    	global.sprFloorCoastB = sprite_add("../sprites/areas/Coast/sprFloorCoastB.png", 3, 2, 2);
    	global.sprDetailCoast = sprite_add("../sprites/areas/Coast/sprDetailCoast.png", 6, 4, 4);

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
    global.surfSwimSize = 1000;
    global.swimInst = [Corpse, ChestOpen, chestprop, WepPickup, AmmoPickup, HPPickup, Grenade, hitme];
    global.swimDraw = [];
    global.seaDepth = 10;

     // Prevent Crash on Mod Reload:
    if(GameCont.area == mod_current){
        with(instances_matching(prop, "name", "BloomingCactus", "Palm")){
            with(scrCoastProp(x, y, name)){
                x = other.x;
                y = other.y;
            }
            instance_delete(id);
        }
    }

#macro swimDraw global.swimDraw

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
    with(TopSmall) instance_destroy();
    with(FloorExplo) instance_destroy();

     // Bind Sea Drawing Script:
	if(array_length(instances_matching(CustomDraw, "name", "darksea_draw")) <= 0){
    	with(script_bind_draw(darksea_draw, global.seaDepth)){
    		name = script[2];
    		wave = 0;
    	}
	}

#define area_step
     // No Portals:
	with(Corpse) do_portal = 0;

	if(instance_exists(Floor)){
         // Destroy Projectiles Too Far Away:
        with(instances_matching_gt(projectile, "speed", 0)){
            if(distance_to_object(Floor) > 1000) instance_destroy();
        }

         // Walk into Sea:
        if(!instance_exists(enemy)){
            with(instances_matching_gt(Player, "wading", 120)){
                if(!instance_exists(Portal)){
                    instance_create(x, y, Portal).image_alpha = 0;

                     // Switch Sound:
                    sound_stop(sndPortalOpen);
                    sound_play(sndOasisPortal);
                }
            }
            with(Portal) if(!place_meeting(xstart, ystart, Floor)){
                 // Spin:
                var r = 5 + image_index,
                    c = current_frame;

                x = xstart + (cos(c) * r);
                y = ystart + (sin(c) * r);
                instance_create(x, y, choose(Sweat, Sweat, Bubble));
            }
        }

         // Water Wading:
		with(instances_matching(global.swimInst, "visible", 1)){
		    if("wading" not in self){
		        wading = 0;
		        wade_z = 0; // Up/down draw offset
		        wade_h = 0; // Wade/water height
		    }

			var o = (object_index == Player),
			    _splashvol = (o ? 1 : clamp(1 - (distance_to_object(Player) / 150), 0.1, 1));

			if(distance_to_object(Floor) > 4){
				 // Splash:
				if(wading <= 0){
					instance_create(x, y, RainSplash);
					repeat(irandom_range(4, 8)) instance_create(x, y, Sweat/*Bubble*/);
                    sound_play_pitchvol(choose(sndOasisChest, sndOasisMelee), 1.5 + random(0.5), _splashvol);
				}
				wading = distance_to_object(Floor);
        
                 // Wade Z / Wade Height:
                wade_z = 2;
                wade_h = wade_z + (sprite_height - sprite_get_bbox_bottom(sprite_index)) + ((wading - 16) * 0.2);
                if(object_index == Van){
                    var c = 40;
                    if(wade_h > c) wade_h = c;
                }
                else if(!o || instance_exists(enemy)){
                    var c = sprite_yoffset;
                    if(wade_h > c) wade_h = c;
                }

    			 // Players Moves 20% Slower:
		        if(o && speed > 0 && race != "fish"){
		            var f = 0.2;
		            x -= hspeed * f;
                    y -= vspeed * f;
		        }

				 // Push Back to Shore:
				if(
				    wading >= 80                    &&
				    instance_exists(enemy)          && // Enemies Exist
				    !instance_is(self, Corpse)      && // Don't push corpses
                    !instance_is(self, projectile)     // Don't push projectiles
				){
    			    var n = instance_nearest(x - 16, y - 16, Floor);
    				motion_add(point_direction(x, y, n.x, n.y), 4);
    			}

                 // Set Drawing Script:
				var d = depth - 0.01,
		            _bind = 1;

                with(instances_matching(CustomDraw, "name", "swim_draw")) if(round(100 * depth) / 100 == d){ // Add to existing script
                    inst[array_length(inst)] = other;
                    _bind = 0;
                    break;
                }
                if(_bind) with(script_bind_draw(swim_draw, d)){ // Make new script
			        name = script[2];
			        inst = [other];
			    }
			}
			else if(wading > 0){
			    wading = 0;
			    wade_h = 0;
			    wade_z = 0;
			    wade_b = 0;

			     // Sploosh:
                sound_play_pitchvol(choose(sndOasisChest, sndOasisMelee, sndOasisHurt), 1 + random(0.25), _splashvol);
				repeat(5 + random(5)) with(instance_create(x, y, Sweat)){
				    motion_add(other.direction, other.speed);
				}
			}
		}

		 // Set Visibility of Swimming Objects Before & After Drawing Events:
    	script_bind_step(reset_visible, 0, instances_matching_gt(global.swimInst, "wading", 0));

    	 // Water Wading Surface:
        if(!surface_exists(global.surfSwim)){
            global.surfSwim = surface_create(global.surfSwimSize, global.surfSwimSize);
        }
	}

     // things die bc of the missing walls
	with(instances_matching(enemy, "canfly", 0)) canfly = 1;

#define area_make_floor
    var _x = x,
        _y = y,
        _outOfSpawn = (point_distance(_x, _y, 10016, 10016) > 48);

    /// Make Floors:
         // Special - 4x4 to 5x5 Rounded Fills:
        if(random(5) < 1) scrFloorFillRound(_x, _y, choose(4, 5), choose(4, 5));

         // Normal - 1x1 to 3x3 Fills:
        else scrFloorFill(_x, _y, irandom_range(1, 3), irandom_range(1, 3));

     // Change Direction:
    var _trn = 0;
    if(random(14) < 5) _trn = choose(90, 90, -90, -90, 180);
    direction += _trn;

     // Turn Arounds:
    if(_trn == 180){
         // Weapon Chests:
        if(_outOfSpawn) scrFloorMake(_x, _y, WeaponChest);

         // Start New Island:
        if(random(1) < 1){
            instance_create(_x - lengthdir_x(96, direction), _y - lengthdir_x(96, direction), FloorMaker);
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
    return mod_script_call("mod", "ntte", "scrFloorFill", _x, _y, _w, _h);

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

    if(random(12) < 1){
        obj_create(_x, _y, choose("Gull", "Pelican", "Pelican"));
    }
    else{
        obj_create(_x, _y, choose("Diver", "Diver", "Gull", "Gull", "Gull", "Gull", "Gull", "Pelican"))
    }
    
#define area_pop_props
    if(random(12) < 1){
        var o = choose("BloomingCactus", "BloomingCactus", "BloomingCactus", "Palm");
        scrCoastProp(x + (sprite_width / 2), y + (sprite_height / 2), o);
    }

#define darksea_draw
    var _surfTrans = global.surfTrans,
        _surfWaves = global.surfWaves,
        _surfWavesSub = global.surfWavesSub,
        _surfw = global.surfW,
        _surfh = global.surfH,
        _surfx = global.surfX,
        _surfy = global.surfY,
        _wave = wave;

     // Draw Floor Transition Tile Surface:
    if(array_length(instances_matching(Floor, "coasttrans", null)) > 0 || !surface_exists(_surfTrans)){
         // Surface Setup:
    	if(!surface_exists(_surfTrans)){
    	    global.surfTrans = surface_create(_surfw, _surfh);
    	    _surfTrans = global.surfTrans;
    	}
    	surface_set_target(_surfTrans);
    	draw_clear_alpha(0, 0);

         // Draw Floors to Surface:
    	with(Floor){
    		coasttrans = visible;
            if(coasttrans){
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
        		        var _floors = 0;
            			for(var i = 1; i <= 10; i++){
            				if(!position_meeting(x + (_ox * i), y + (_oy * i), Floor)) _floors++;
            				else break;
            			}
            			if(_floors <= 5) for(var i = 1; i <= _floors; i++){
            				draw_sprite(_spr, irandom(sprite_get_number(_spr) - 1), _x + (_ox * i), _y + (_oy * i));
            		    }
        		    }
        		}
            }
    	}

    	surface_reset_target();
    }

     // Draw Waves Surface:
    if(array_length(instances_matching(Floor, "coastfoam", null)) || !surface_exists(_surfWaves)){
         // Surface Setup:
    	if(!surface_exists(_surfWaves)){
    	    global.surfWaves = surface_create(_surfw, _surfh);
    	    _surfWaves = global.surfWaves;
    	}
    	surface_set_target(_surfWaves);
    	draw_clear_alpha(0, 0);

         // Draw Floors in White to Surface:
    	d3d_set_fog(1, c_white, 1, 1)
    	with(Floor){
    		coastfoam = visible;
    		if(coastfoam) draw_sprite(global.sprFloorCoast, image_index, x - _surfx, y - _surfy);
    	}
    	d3d_set_fog(0, 0, 0, 0);

         // Clear Waves Subsurface:
    	if(surface_exists(_surfWavesSub)){
    	    surface_set_target(_surfWavesSub);
    	    draw_clear_alpha(0, 0);
    	    surface_reset_target();
    	}
    }

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

     // Darken Ocean w/ Enemies Exist:
    draw_set_color(c_black);
    draw_set_alpha(image_alpha);
    draw_rectangle(0, 0, 20000, 20000, 0);
    draw_set_alpha(1);

    var l = 0.02 * (instance_exists(enemy) ? 1 : -1);
    image_alpha = clamp(image_alpha + l, 0, 0.12);

    wave++;

#define swim_draw()
    var _surfw = global.surfSwimSize,
        _surfh = global.surfSwimSize,
        _surf = global.surfSwim;

    with(inst) if(instance_exists(self)){
        var _z = wade_z,
            _wh = wade_h,
            _surfx = x - (_surfw / 2),
            _surfy = y - (_surfh / 2);

         // Bobbing:
        if(wading > sprite_height || !instance_is(id, hitme)){
            var _bobspd = 1 / 10,
                _bobmax = min(wading / sprite_height, 2),
                _bob = _bobmax * sin((current_frame + x + y) * _bobspd);
            
            _z += _bob;
            _wh += _bob;
        }

         // Call Draw Event to Surface:
        surface_set_target(_surf);
        draw_clear_alpha(0, 0);

         // Save + Temporarily Set Vars:
        var s = {};
        if(object_index == Player){
             // Disable Laser Sight:
            if(canscope){
                s.canscope = canscope;
                canscope = 0;
            }

             // Sucked Into Abyss:
            if(!instance_exists(enemy) && distance_to_object(Portal) <= 0){
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

        x -= _surfx;
        y -= _surfy;
        if("right" in self || "rotation" in self) event_perform(ev_draw, 0);
        else draw_self();
        x += _surfx;
        y += _surfy;

         // Set Saved Vars:
        if(s != {}){
            for(var i = 0; i < lq_size(s); i++){
                var k = lq_get_key(s, i);
                variable_instance_set(id, k, lq_get(s, k));
            }
        }

        surface_reset_target();

         // Manually Draw Laser Sights:
        if(object_index == Player && canscope){
            draw_set_color(c_red);

            var w = [wep];
            if(race == "steroids") w = [wep, bwep];
            for(var i = 0; i < array_length(w); i++) if(weapon_get_laser_sight(w[i])){
                var _sx = x,
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
                    _x =[   _sx,
                            _sx + ((_lx - _sx) / 10),// ~ ~
                            _lx
                        ],
                    _y =[   _sy,
                            _sy + ((_ly - _sy) / 10),
                            _ly
                        ];

                draw_primitive_begin(pr_trianglestrip);
                draw_set_alpha(sin(degtorad(gunangle)) * 5);
                for(var j = 0; j < array_length(_x); j++){
                    draw_vertex(_x[j],       _y[j]);
                    draw_vertex(_x[j] + _ox, _y[j] + _oy);
                    draw_set_alpha(1);
                }
                draw_primitive_end();

                //draw_sprite_ext(sprLaserSight, -1, _sx, _sy, (point_distance(_sx, _sy, _lx, _ly) / 2) + 2, 1, gunangle, c_white, 1);
            }
            draw_set_alpha(1);
        }

         // Draw Transparent:
        var _yoff = (_surfh / 2) - (sprite_height - sprite_yoffset),
            _surfz = _surfy + _z,
            t = _surfh - _yoff - _wh,
            h = _surfh - t,
            _y = _surfz + t;

        draw_set_alpha(0.5);
        draw_surface_part(_surf, 0, t, _surfw, h, _surfx, _y);
        draw_set_alpha(1);

         // Water Interference Line Thing:
        d3d_set_fog(1, c_white, 0, 0);
        draw_surface_part_ext(_surf, 0, t, _surfw, 1, _surfx, _y, 1, 1, c_white, 0.5);
        d3d_set_fog(0, 0, 0, 0);

         // Draw Normal:
        var t = 0,
            h = _surfh - t - _yoff - _wh,
            _y = _surfz + t;

        draw_surface_part(_surf, 0, t, _surfw, h, _surfx, _y);

        visible = 1;
    }
    instance_destroy();

#define reset_visible(_inst)
    with(_inst) if(instance_exists(self)){
        if(!visible) with(instances_matching(CustomDraw, "name", "swim_draw")){
            var i = array_find_index(inst, other);
            if(i >= 0) inst[i] = noone;
        }
        else visible = 0;
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