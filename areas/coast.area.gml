#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");

     // SPRITES //
    with(spr){
    	CoastTrans  = sprite_add("../sprites/areas/Coast/sprCoastTrans.png",  1, 0, 0);
    	FloorCoast  = sprite_add("../sprites/areas/Coast/sprFloorCoast.png",  4, 2, 2);
    	FloorCoastB = sprite_add("../sprites/areas/Coast/sprFloorCoastB.png", 3, 2, 2);
    	DetailCoast = sprite_add("../sprites/areas/Coast/sprDetailCoast.png", 6, 4, 4);
    }

    global.spawn_enemy = 0;

    //#region SURFACES
        global.surfW = 2000;
        global.surfH = 2000;
        global.surfX = 10000 - (global.surfW / 2);
        global.surfY = 10000 - (global.surfH / 2);
        global.surfTrans = -1;
        global.surfFloor = -1;
        global.surfFloorReset = false;
        global.surfWaves = -1;
        global.surfWavesSub = -1;
        global.surfSwim = -1;
        global.surfSwimBot = -1;
        global.surfSwimTop = -1;
        global.surfSwimSize = 1000;
        global.swimInst = [Debris, Corpse, ChestOpen, chestprop, WepPickup, AmmoPickup, HPPickup, Crown, Grenade, hitme];
        global.swimInstVisible = [];
        global.seaDepth = 10.1;
    //#endregion

    global.shadeWade = shader_create(
        "/// Vertex Shader ///

        struct VertexShaderInput
        {
            float4 vPosition : POSITION;
            float2 vTexcoord : TEXCOORD0;
        };

        struct VertexShaderOutput
        {
            float4 vPosition : SV_POSITION;
            float2 vTexcoord : TEXCOORD0;
        };

        uniform float4x4 matrix_world_view_projection;

        VertexShaderOutput main(VertexShaderInput INPUT)
        {
            VertexShaderOutput OUT;

            OUT.vPosition = mul(matrix_world_view_projection, INPUT.vPosition); // (x,y,z,w)
            OUT.vTexcoord = INPUT.vTexcoord; // (x,y)

            return OUT;
        }
        ",


        "/// Fragment/Pixel Shader ///

        struct PixelShaderInput
        {
            float2 vTexcoord : TEXCOORD0;
        };

        sampler2D s0;

        uniform float WadeY;
        uniform float WadeTop;

        float4 main(PixelShaderInput INPUT) : SV_TARGET
        {
            float4 Color = tex2D(s0, INPUT.vTexcoord);
            float Y = INPUT.vTexcoord.y;
            float A = Color.a;

            if(Y < WadeY){
                if(WadeTop){
                    if(Y < WadeY - (1.0 / 1000.0)) return Color;
                    return float4(1.0, 1.0, 1.0, 0.8 * A);
                }
            }
            else if(!WadeTop){
                return float4(0.17, 0.15, 0.48, A);
            }

            return float4(0.0, 0.0, 0.0, 0.0);
        }
    ");

     // Prevent Crash on Mod Reload:
    if(GameCont.area == mod_current){
        with(instances_matching(prop, "name", "BloomingCactus", "Palm")) instance_destroy();
    }

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus

#macro bgrColor make_color_rgb(27, 118, 184)
#macro shdColor c_black
#macro musMain  mus.Coast
#macro ambMain  amb1

#macro current_frame_active ((current_frame mod 1) < current_time_scale)

#macro DebugLag 0
#macro CanLeaveCoast (instance_exists(Portal) || (instance_number(enemy) - instance_number(Van) <= 0))
#macro WadeColor make_color_rgb(44, 37, 122)

#define area_name(sub, loop)
    return "@1(sprInterfaceIcons)1-" + string(sub);

#define area_secret
    return 1;

#define area_mapdata(_lastx, _lasty, _lastarea, _lastsubarea, _subarea, _loops)
    return [_lastx + ((_lastarea == mod_current) ? 8.75 : 0.5), -8, (_subarea == 1)];

#define area_sprite(_spr)
    switch(_spr){
         // Floors:
        case sprFloor1:         return spr.FloorCoast;
        case sprFloor1B:        return spr.FloorCoastB;

         // Misc:
    	case sprDetail1:        return spr.DetailCoast;
    }

#define area_setup
    goal = 100;

    background_color = bgrColor;
    BackCont.shadcol = shdColor;
    sound_play_ambient(ambMain);

     // Hopefully temporary fix for custom music bug:
    if(fork()){
        wait 2;
        sound_play_music(mus1);
        sound_play_music(musMain);
        exit;
    }
    

#define area_start
     // No Walls:
    with(Wall) instance_destroy();
    with(FloorExplo) instance_destroy();

     // Top Decals:
    with(TopSmall) if(random(200) < 1){
        obj_create(x, y, "CoastBigDecal");
        break;
    }
    with(TopSmall){
        if(random(80) < 1) obj_create(x, y, "CoastDecal");
        instance_destroy();
    }

     // Spawn Boss:
    if(GameCont.subarea == 3){
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
    }
    
     // Spawn Thing:
    if(GameCont.subarea != 3){
        var _forcespawn = false;
         // check for blaac
        for(var i = 0; i < maxp; i++){
            if(player_get_alias(i) == "blaac") _forcespawn = true;
        }

        if(random(25) < 1 + GameCont.loops || _forcespawn){
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

     // Reset Wave Foam:
    if(surface_exists(global.surfWaves)){
        surface_set_target(global.surfWaves);
        draw_clear_alpha(0, 0);
        surface_reset_target();
    }

#define area_step
     // No Portals:
	with(instances_matching_ne(Corpse, "do_portal", false)) do_portal = false;
	
	 // Attract pickups on level end
	with instances_matching(GameObject,"object_index",Rad,AmmoPickup,HPPickup) if CanLeaveCoast && speed <= 0 && instance_exists(Player){
	    var _p = instance_nearest(x,y,Player),
	        _l = 8,
	        _d = point_direction(x,y,_p.x,_p.y);
	    x += lengthdir_x(_l,_d);
	    y += lengthdir_y(_l,_d);
	}
	
     // Explosion debris splash FX:
	with(Explosion) if(current_time_scale && random(5) < 1){
        var _len = irandom_range(24,48),
            _dir = irandom(359);
        with instance_create(x+lengthdir_x(_len,_dir),y+lengthdir_y(_len,_dir),RainSplash)
            if place_meeting(x,y,Floor)
                instance_destroy();
	}

	if(instance_exists(Floor)){
         // Destroy Projectiles Too Far Away:
        with(instances_matching_le(instances_matching_gt(projectile, "speed", 0), "friction", 0)){
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
        var _inst = instances_matching(instances_matching_lt(global.swimInst, "depth", global.seaDepth), "nowade", null, false),
            _tex = surface_get_texture(_surfSwim);

        global.swimInstVisible = [];

        with(instances_matching(_inst, "wading", null)){
            wading = 0;
            wading_clamp = 0;
            wading_sink = 0;
            if(object_index == Van) wading_clamp = 40;
            if(object_index == Corpse) wading_sink = 1;
        }

        with(_inst){
             // In Water:
            var _dis = distance_to_object(Floor);
            if(_dis > 4){
                array_push(global.swimInstVisible, id);

                if(wading <= 0){
		    		 // Splash:
    				repeat(irandom_range(4, 8)) instance_create(x, y, Sweat/*Bubble*/);
    				var _vol = ((object_index == Player) ? 1 : clamp(1 - (distance_to_object(Player) / 150), 0.1, 1));
                    sound_play_pitchvol(choose(sndOasisChest, sndOasisMelee), 1.5 + random(0.5), _vol);
                }
                wading = _dis;

                 // Splashies:
    		    if(current_frame_active && random(20) < min(speed, 4)){
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
        if(DebugLag) trace_time("Wading");

        if(DebugLag) trace_time();
        with(instances_seen(instances_matching_gt(_inst, "wading", 0), 8)){
	        var o = (object_index == Player);

             // Wading Vars:
            var _z = 1,
                _wh = _z + (sprite_height - sprite_get_bbox_bottom(sprite_index)) + ((wading - 16) * 0.2),
                _surfSwimx = x - (_surfSwimw / 2),
                _surfSwimy = y - (_surfSwimh / 2);

            if(!o || !CanLeaveCoast){
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
                if(CanLeaveCoast && distance_to_object(Portal) <= 0){
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

             // Call Draw Event to Surface:
            surface_set_target(_surfSwim);
            draw_clear_alpha(0, 0);

            var _x = x, _y = y;
            x -= _surfSwimx;
            y -= _surfSwimy;
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


            /// Draw Top:
                var _yoff = _surfSwimh - ((_surfSwimh / 2) - (sprite_height - sprite_yoffset)),
                    t = _yoff - _wh;
    
                surface_set_target(_surfSwimTop);

                 // Manually Draw Laser Sights:
                if(o && canscope){
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

                 // Draw Top:
                if(true){ // there's so much lag fluctuation i can't tell which way is faster
                    draw_surface_part(_surfSwim, 0, 0, _surfSwimw, t, _surfSwimx - _surfx, _surfSwimy + _z - _surfy);
    
                     // Water Interference Line Thing:
                    d3d_set_fog(1, c_white, 0, 0);
                    draw_surface_part_ext(_surfSwim, 0, t, _surfSwimw, 1, _surfSwimx - _surfx, (_surfSwimy + _z + t) - _surfy, 1, 1, c_white, 0.8);
                }
                    else{
                         // Activate Shaders:
                        shader_set_vertex_constant_f(0, matrix_multiply(matrix_multiply(matrix_get(matrix_world), matrix_get(matrix_view)), matrix_get(matrix_projection)));
                        shader_set_fragment_constant_f(0, [t / _surfSwimh]);
                        shader_set(global.shadeWade);

                        shader_set_fragment_constant_f(1, [1]);
                        texture_set_stage(0, _tex);
                        draw_surface(_surfSwim, _surfSwimx - _surfx, _surfSwimy + _z - _surfy);
                    }

             // Draw Bottom:
            surface_set_target(_surfSwimBot);
            if(true){ // there's so much lag fluctuation i can't tell which way is faster
                d3d_set_fog(1, WadeColor, 0, 0);
                draw_surface_ext(_surfSwim, _surfSwimx - _surfx, _surfSwimy + _z - _surfy, 1, 1, 0, c_white, (1 - (wading_sink / 120)));//draw_surface(_surfSwim, _surfSwimx - _surfx, _surfSwimy + _z - _surfy);
                d3d_set_fog(0, 0, 0, 0);
            }
                else{
                    shader_set_fragment_constant_f(1, [0]);
                    texture_set_stage(0, _tex);
                    draw_surface_ext(_surfSwim, _surfSwimx - _surfx, _surfSwimy + _z - _surfy, 1, 1, 0, c_white, 1 - (wading_sink / 120));
                    shader_reset();
                }
            surface_reset_target();
        }
		if(DebugLag) trace_time("Wading Drawing");

        with(instances_matching_gt(instances_matching_lt(instances_matching(instances_matching_le(instances_matching_gt(Corpse, "wading", 30), "speed", 0), "image_speed", 0), "size", 3), "wading_sink", 0)){
            if(wading_sink++ >= 120) instance_destroy();
        }

         // Push Back to Shore:
        var _push = [enemy, Pickup, chestprop];
        if(!CanLeaveCoast) array_push(_push, Player);
        with(instances_matching_ge(_push, "wading", 80)){
            var n = instance_nearest(x - 16, y - 16, Floor);
    		motion_add(point_direction(x, y, n.x, n.y), 4);
        }

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

     // Popo Freaks Can't Spawn After Level End:
    if(CanLeaveCoast){
        with(WantRevivePopoFreak) instance_destroy();
    }

     // Bind End Step:
    script_bind_end_step(end_step, 0);

#define end_step
     // Watery Dust:
    with(instances_matching(Dust, "coast_water", null)){
        coast_water = 1;
        if(!place_meeting(x, y, Floor)){
            if(random(instance_number(AcidStreak) + 10) < 1){
                if(point_seen(x, y, -1)){
                    sound_play_pitch(sndOasisCrabAttack, 0.9 + random(0.2));
                }
                with(scrWaterStreak(x, y, random(360), 2)){
                    hspeed += other.hspeed / 2;
                    vspeed += other.vspeed / 2;
                }
            }
            else{
                if(random(5) < 1 && point_seen(x, y, -1)){
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
                if(random(6) < 1) scrWaterStreak(x, y, random(360), 4);
                else instance_create(x, y, Sweat);
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

         // ++B Floors
        else if(!styleb && random(3) < 1){
            styleb = 1;
        }
    }

     // Ammo Chests (Dead Ends):
    if(random(19 + instance_number(FloorMaker)) > 22){
        if(_outOfSpawn) scrFloorMake(_x, _y, AmmoChest);
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
    	area = "oasis";
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

    if(global.spawn_enemy-- <= 0){
        global.spawn_enemy = 1;

         // Normal Enemies:
        if(styleb){
            obj_create(_x, _y, choose("TrafficCrab", "TrafficCrab", "Diver"));
        }
        else{
            if(random(18) < GameCont.subarea){
                obj_create(_x, _y, choose("Pelican", "Pelican", "TrafficCrab"));
            }
            else{
                obj_create(_x, _y, choose("Diver", "Diver", "Gull", "Gull", "Gull", "Gull", "Gull"));
            }
        }
    }

     // Seal Lands:
    else if(GameCont.subarea == 3){
        var _seals = instances_matching(CustomEnemy, "name", "Seal");
        if(random(2 * array_length(_seals)) < 1){
            if(styleb) obj_create(_x, _y, "Seal");
            else repeat(4) obj_create(_x, _y, "Seal");
        }
    }

#define area_pop_props
    var _x = x + 16,
        _y = y + 16;

    if(random(12) < 1){
        var o = choose("BloomingCactus", "BloomingCactus", "BloomingCactus", "Palm");
        if(!styleb && random(6) < 1) o = "BuriedCar";
        obj_create(_x, _y, o);
    }

     // Mine:
    else if(random(80) < 1){
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

#define darksea_draw
    if(DebugLag) trace_time();

    wave += current_time_scale;

    var _surfTrans = global.surfTrans,
        _surfFloor = global.surfFloor,
        _surfWaves = global.surfWaves,
        _surfWavesSub = global.surfWavesSub,
        _surfSwimBot = global.surfSwimBot,
        _surfSwimTop = global.surfSwimTop,
        _surfw = global.surfW,
        _surfh = global.surfH,
        _surfx = global.surfX,
        _surfy = global.surfY,
        _wave = wave,
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
    			var _spr = spr.FloorCoast,
    			    _ox = lengthdir_x(sprite_get_width(mask_index), a),
    			    _oy = lengthdir_y(sprite_get_height(mask_index), a);

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

     // Draw Floors to Surface:
    if(array_length(_floor) > 0 || !surface_exists(_surfFloor) || global.surfFloorReset){
        global.surfFloorReset = false;

         // Surface Setup:
    	if(!surface_exists(_surfFloor)){
    	    global.surfFloor = surface_create(_surfw, _surfh);
    	    _surfFloor = global.surfFloor;
    	}
    	surface_set_target(_surfFloor);
    	draw_clear_alpha(0, 0);

         // Draw Floors in White:
    	d3d_set_fog(1, c_white, 1, 1)
    	with(Floor) if(visible){
    	    var _spr = sprite_index;
    	    if(_spr == spr.FloorCoastB) _spr = spr.FloorCoast;
    	    draw_sprite_ext(_spr, image_index, x - _surfx, y - _surfy, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
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

     // Draw Water Waves Foam Stuff:
    var _int = 30; // Wave Interval (Starts every X frames)
    if(!surface_exists(_surfWaves)){
    	global.surfWaves = surface_create(_surfw, _surfh);
    	_surfWaves = global.surfWaves;
    }
    if((_wave mod _int) < current_time_scale){
        surface_set_target(_surfWaves);
        draw_clear_alpha(0, 0);

         // Floors:
    	draw_surface(_surfFloor, 0, 0);

         // Palanking:
        with(instances_matching(CustomEnemy, "name", "Palanking")){
            if(z <= 4 && !place_meeting(x, y, Floor)){
                draw_sprite_ext(spr_foam, image_index, x - _surfx, y - _surfy, image_xscale * right, image_yscale, image_angle, c_white, 1);
            }
        }

         // Thing:
        with(instances_matching(CustomHitme, "name", "Creature")){
    	    draw_sprite_ext(spr_foam, image_index, x - _surfx, y - _surfy, image_xscale * right, image_yscale, image_angle, image_blend, 1);
    	}

         // Rock Decals:
    	with(instances_matching(CustomHitme, "name", "CoastDecal")){
    	    draw_sprite_ext(spr_foam, image_index, x - _surfx, y - _surfy, image_xscale, image_yscale, image_angle, image_blend, 1);
    	}

        surface_reset_target();
    }

    /// Drawing Wave Foam:
         // Surface Setup:
        if(!surface_exists(_surfWavesSub)){
        	global.surfWavesSub = surface_create(_surfw, _surfh);
        	_surfWavesSub = global.surfWavesSub;
        }
        surface_set_target(_surfWavesSub);
    
    	var _sc1 = 0.5, // Scaler 1
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
    		        var _ox = lengthdir_x(_off[i], a),
    		            _oy = lengthdir_y(_off[i], a);

    		    	draw_surface(_surfWaves, _ox, _oy);
    		    }
    	    }
    	}
    	draw_set_blend_mode(bm_normal);
    
    	surface_reset_target();

     // Draw Sea Transition Floor Tiles:
    draw_surface(_surfTrans, _surfx, _surfy);

     // Submerged Rock Decals:
    with(instances_matching(CustomHitme, "name", "CoastDecal")){
        var h = (nexthurt > current_frame + 3);
        if(h) d3d_set_fog(1, c_white, 0, 0);
        draw_sprite_ext(spr_bott, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
        if(h) d3d_set_fog(0, 0, 0, 0);
    }

     // Palanking Wading Half:
    d3d_set_fog(1, WadeColor, 0, 0);
    with(instances_matching(CustomEnemy, "name", "Palanking")){
        draw_sprite_ext(spr_bott, image_index, x, y - z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
    }
    
     // Thing bottom half:
    with instances_matching(CustomHitme, "name", "Creature"){
        draw_sprite_ext(spr_bott,image_index,x,y,image_xscale*right,image_yscale,image_angle,image_blend,image_alpha);
    }
    d3d_set_fog(0,0,0,0);

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
    draw_sprite_tiled(spr.CoastTrans, 0, sin(_wave * 0.02) * 4, sin(_wave * 0.05) * 2);
    draw_set_alpha(1);

     // Foam:
    draw_surface(_surfWavesSub, _surfx, _surfy);

     // Flash Ocean w/ Can Leave Level:
    var _flash = false;
    if(CanLeaveCoast && !instance_exists(Portal)){
        var _int = 300, // Flash every X frames
            _lst = 30,  // Flash lasts X frames
            _max = ((flash <= _lst) ? 0.3 : 0.15); // Max flash alpha

        draw_set_color(c_white);
        draw_set_alpha(_max * (1 - ((flash mod _int) / _lst)));
        draw_rectangle(0, 0, 20000, 20000, 0);
        draw_set_alpha(1);

        if((flash mod _int) < current_time_scale){
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
                            if(random(instance_number(AcidStreak) + 6) < 1){
                                sound_play_hit(sndOasisCrabAttack, 0.2);
                                scrWaterStreak(_x + 16 + orandom(8), _y + 16 + orandom(8), d + random_range(-20, 20), 4);
                            }
                            else instance_create(_x + random(32), _y + random(32), Sweat);
                        }
                    }
                }
            }
        }
        flash += current_time_scale;
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


 /// HELPER SCRIPTS ///
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call("mod", "telib", "obj_create", _x, _y, _obj);
#define draw_self_enemy()                                                                       mod_script_call("mod", "teassets", "draw_self_enemy");
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call("mod", "teassets", "draw_weapon", _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define scrWalk(_walk, _dir)                                                                    mod_script_call("mod", "teassets", "scrWalk", _walk, _dir);
#define scrRight(_dir)                                                                          mod_script_call("mod", "teassets", "scrRight", _dir);
#define scrEnemyShoot(_object, _dir, _spd)                                              return  mod_script_call("mod", "teassets", "scrEnemyShoot", _object, _dir, _spd);
#define scrEnemyShootExt(_x, _y, _object, _dir, _spd)                                   return  mod_script_call("mod", "teassets", "scrEnemyShootExt", _x, _y, _object, _dir, _spd);
#define enemyAlarms(_maxAlarm)                                                                  mod_script_call("mod", "teassets", "enemyAlarms", _maxAlarm);
#define enemyWalk(_spd, _max)                                                                   mod_script_call("mod", "teassets", "enemyWalk", _spd, _max);
#define enemySprites()                                                                          mod_script_call("mod", "teassets", "enemySprites");
#define enemyHurt(_hitdmg, _hitvel, _hitdir)                                                    mod_script_call("mod", "teassets", "enemyHurt", _hitdmg, _hitvel, _hitdir);
#define scrDefaultDrop()                                                                        mod_script_call("mod", "teassets", "scrDefaultDrop");
#define target_in_distance(_disMin, _disMax)                                            return  mod_script_call("mod", "teassets", "target_in_distance", _disMin, _disMax);
#define target_is_visible()                                                             return  mod_script_call("mod", "teassets", "target_is_visible");
#define z_engine()                                                                              mod_script_call("mod", "teassets", "z_engine");
#define draw_rope(_rope)                                                                        mod_script_call("mod", "teassets", "draw_rope", _rope);
#define scrHarpoonStick(_instance)                                                              mod_script_call("mod", "teassets", "scrHarpoonStick", _instance);
#define scrHarpoonRope(_link1, _link2)                                                  return  mod_script_call("mod", "teassets", "scrHarpoonRope", _link1, _link2);
#define scrHarpoonUnrope(_rope)                                                                 mod_script_call("mod", "teassets", "scrHarpoonUnrope", _rope);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc)                                     return  mod_script_call("mod", "teassets", "lightning_connect", _x1, _y1, _x2, _y2, _arc);
#define scrLightning(_x1, _y1, _x2, _y2, _enemy)                                        return  mod_script_call("mod", "teassets", "scrLightning", _x1, _y1, _x2, _y2, _enemy);
#define scrBossHP(_hp)                                                                  return  mod_script_call("mod", "teassets", "scrBossHP", _hp);
#define scrBossIntro(_name, _sound, _music)                                                     mod_script_call("mod", "teassets", "scrBossIntro", _name, _sound, _music);
#define scrWaterStreak(_x, _y, _dir, _spd)                                              return  mod_script_call("mod", "teassets", "scrWaterStreak", _x, _y, _dir, _spd);
#define orandom(n)                                                                      return  mod_script_call("mod", "teassets", "orandom", n);
#define floor_ext(_num, _round)                                                         return  mod_script_call("mod", "teassets", "floor_ext", _num, _round);
#define array_count(_array, _value)                                                     return  mod_script_call("mod", "teassets", "array_count", _array, _value);
#define array_flip(_array)                                                              return  mod_script_call("mod", "teassets", "array_flip", _array);
#define instances_named(_object, _name)                                                 return  mod_script_call("mod", "teassets", "instances_named", _object, _name);
#define nearest_instance(_x, _y, _instances)                                            return  mod_script_call("mod", "teassets", "nearest_instance", _x, _y, _instances);
#define instances_seen(_obj, _ext)                                                      return  mod_script_call("mod", "teassets", "instances_seen", _obj, _ext);
#define frame_active(_interval)                                                         return  mod_script_call("mod", "teassets", "frame_active", _interval);
