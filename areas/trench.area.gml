#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.save = mod_variable_get("mod", "teassets", "save");

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
            
    //#region SURFACES
        global.surfw = 1000;
        global.surfh = 1000;
        global.surfx = 10000;
        global.surfy = 10000;
        global.surf = [-1, -1, -1];
        global.surf_reset = false;
        if(fork()){
            wait 1;
            global.surf_reset = true;
            exit;
        }
    //#endregion

    global.trench_visited = [];

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.save
#macro opt sav.option

#macro current_frame_active ((current_frame mod 1) < current_time_scale)

#macro TrenchVisited global.trench_visited

#define area_subarea            return 3;
#define area_next               return 4;
#define area_music              return musBoss5;
#define area_ambience           return amb101;
#define area_background_color   return make_color_rgb(100, 114, 127);
#define area_shadow_color       return c_black;
#define area_darkness           return true;
#define area_secret             return true;

#define area_name(_subarea, _loop)
    return "@1(sprInterfaceIcons)3-" + string(_subarea);

#define area_mapdata(_lastx, _lasty, _lastarea, _lastsubarea, _subarea, _loops)
    var _x = 36.5 + (8.8 * (_subarea - 1)),
        _y = -9;

     // Manual Line Shadow:
    if(_subarea == 3){
        if(GameCont.area != mod_current || GameCont.subarea != _subarea || GameCont.loops != _loops){
             // Map Offset:
            var _dx = view_xview_nonsync + (game_width / 2),
                _dy = view_yview_nonsync + (game_height / 2);

            if(instance_exists(GameOverButton)){
                _dx -= 120;
                _dy += 1;
            }
            else{
                _dx -= 70;
                _dy += 6;
            }

             // Draw Shadow:
            var _x1 = _dx + _x - 1,
                _y1 = _dy + _y,
                _x2 = _dx + 62,
                _y2 = _dy + 0;

            var c = draw_get_color();
            draw_set_color(c_black);
            draw_line_width(_x1, _y1 + 1, _x2, _y2 + 1, 1);
            draw_set_color(c);
        }
    }

     // Map Stuff:
    if(array_length(TrenchVisited) <= _loops){
        TrenchVisited[@_loops] = (_lastarea == "oasis");
    }

    return [_x, _y, (_subarea == 1)];

#define area_sprite(_spr)
    switch(_spr){
         // Floors:
        case sprFloor1      : return spr.FloorTrench;
        case sprFloor1B     : return spr.FloorTrenchB;
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

     // Reset Surfaces:
    for(var i = 0; i < array_length(global.surf); i++){
        surface_destroy(global.surf[i]);
    }

#define area_setup_floor(_explo)
    if(!_explo){
        if(styleb){
             // Fix Depth:
            depth = 9;

             // Slippery pits:
            traction = 0.1;
            
             // Get rid of them:
            if(place_meeting(x, y, Detail))
                with(Detail) if place_meeting(x, y, other)
                    instance_destroy();
        }

         // Footsteps:
        material = (styleb ? 0 : 4);
    }

#define area_start
     // Bind pit drawing scripts:
	if(array_length(instances_matching(CustomDraw, "name", "draw_pit")) <= 0){
    	with(script_bind_draw(draw_pit, 8.5)) name = script[2];
	}

     // Anglers:
    with(RadChest) if(random(40) < 1){
        obj_create(x, y, "Angler");
        instance_delete(id);
    }

     // Fix Props:
    if(instance_exists(Floor) && instance_exists(Player)){
        with(instances_matching(CustomProp, "name", "Kelp", "Vent", "EelSkull")){
            if(floor_at(x, y).styleb){
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

     // Area End:
    if(subarea >= area_subarea()){
        var n = area_next();
        if(!is_array(n)) n = [n];
        if(array_length(n) < 1) array_push(n, mod_current);
        if(array_length(n) < 2) array_push(n, 1);
        area = n[0];
        subarea = n[1];

         // Cursed Caves:
        with(Player) if(curse || bcurse){
            other.area = 104;
        }

         // who's that bird? \\
        var _isParrot = false;
        for(var i = 0; i < maxp; i++){
            if(player_get_race(i) == "parrot"){
                _isParrot = true;
                break;
            }
        }
        if(_isParrot && !unlock_get("parrot_bskin")){
            unlock_set("parrot_bskin", true); // It's a secret yo
            with(scrUnlock("PARROT B", "FOR BEATING THE AQUATIC ROUTE", spr.Parrot[1].Portrait, sndRavenScreech)){
                nam[0] += "-SKIN";
            }
        }
    }

     // Next Subarea: 
    else subarea++;

     // Reset Surfaces:
    for(var i = 0; i < array_length(global.surf); i++){
        surface_destroy(global.surf[i]);
    }

#define area_step
     // Run underwater code
    mod_script_call("mod", "ntte", "underwater_step");
    
     // Fix scorchmarks showing above pits:
    with(instances_matching([Scorch, ScorchTop], "trench_fix", null)){
        trench_fix = true;

        var l = 12;
        for(var d = 0; d < 360; d += 45){
            if(floor_at(x + lengthdir_x(l, d), y + lengthdir_y(l, d)).styleb){
                depth = 9;
                break;
            }
        }
    }

     // Player Above Pits:
    with(Player){
        var f = floor_at(x, bbox_bottom);
        if(instance_exists(f) && f.styleb){
             // Check if moving:
            var _moving = false;
            if(canwalk){
                var _moveKey = ["nort", "sout", "east", "west"];
                for(var i = 0; i < array_length(_moveKey); i++){
                    if(button_check(index, _moveKey[i])){
                        _moving = true;
                        break;
                    }
                }
            }

             // do a spin:
            if(!_moving){
                var _x = x + cos(wave / 10) * 0.25 * right,
                    _y = y + sin(wave / 10) * 0.25 * right;

                if(!place_meeting(_x, y, Wall)) x = _x;
                if(!place_meeting(x, _y, Wall)) y = _y;
            }
        }
    }

     // Floaty Effects Above Pits:
    with(instances_matching([WepPickup, chestprop, RadChest], "", null)){
        var f = floor_at(x, bbox_bottom);
        if(instance_exists(f) && f.styleb){
            var _x = x + cos((current_frame + x + y) / 10) * 0.15,
                _y = y + sin((current_frame + x + y) / 10) * 0.15;

            if(!place_meeting(_x, y, Wall)) x = _x;
            if(!place_meeting(x, _y, Wall)) y = _y;
        }
    }

     // Stuff Falling Into Pits:
    with(instances_matching_le(instances_matching([Debris, Shell, ChestOpen], "pit_check", null), "speed", 1)){
        if(speed <= 0) pit_check = true;
        var f = floor_at(x, bbox_bottom);
        if(instance_exists(f) && f.styleb){
            pit_sink(x, y, sprite_index, image_index, image_xscale, image_yscale, image_angle, direction, speed, orandom(1));
            instance_destroy();
        }
    }
    with(instances_matching_lt(instances_matching(instances_matching(Corpse, "pit_check", null), "image_speed", 0), "size", 4)){
        if(instance_exists(enemy) || instance_exists(Portal)){
            if(speed <= 0) pit_check = true;
            var f = floor_at(x, y);
            if(instance_exists(f) && f.styleb){
                pit_sink(x, y, sprite_index, image_index, image_xscale, image_yscale, image_angle, direction, speed, orandom(0.6))
                instance_destroy();
            }
        }
    }

     // Destroy PitSink Objects, Lag Helper:
    var s = instances_matching(CustomObject, "name", "PitSink"),
        m = array_length(s);

    while(m > 80) with(s[--m]) instance_destroy();

#define area_effect(_vx, _vy)
    var _x = _vx + random(game_width),
        _y = _vy + random(game_height);

     // Player Bubbles:
    if(random(4) < 1){
        with(Player) instance_create(x, y, Bubble);
    }
    
     // Pet Bubbles:
    if(random(4) < 1){
        with instances_matching(CustomObject, "name", "Pet") instance_create(x, y, Bubble);
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
        _outOfSpawn = (point_distance(_x, _y, GenCont.spawn_x, GenCont.spawn_y) > 48);

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
        if(random(7) < 1 && _outOfSpawn){
            var _w = irandom_range(3,5),
                _h = 8-_w;

            scrFloorFill(_x,_y,_w,_h);
        }

         // Normal:
        instance_create(_x,_y,Floor);

	/// Turn:
	    var _trn = 0;
	    if(random(7) < 3){
            _trn = choose(90, -90, 180);
        }
        direction += _trn;

    /// Chests & Branching:
         // Weapon Chests:
        if(_outOfSpawn && _trn == 180){
            with(scrFloorMake(_x, _y, WeaponChest)){
                sprite_index = sprClamChest;
            }
        }

	     // Ammo Chests + End Branch:
	    var n = instance_number(FloorMaker);
		if(random(19 + n) > 22){
			if(_outOfSpawn) scrFloorMake(_x, _y, AmmoChest);
			instance_destroy();
		}

		 // Branch:
		else if(random(5) < 1){
		    instance_create(_x, _y, FloorMaker);
		}

    /// Crown Vault:
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

#define area_pop_enemies
    var _x = x + 16,
        _y = y + 16;
    
    if(GameCont.loops > 0 && random(3) < 1){
        if(random(5) < 1){
            instance_create(_x, _y, FireBaller);
        }
        else{
            instance_create(_x, _y, choose(LaserCrystal, Salamander));
        }
    }
    else{
         // Anglers:
        if(!styleb && random(18) < 1){
            obj_create(_x, _y, "Angler");
        }
    
        else{
            if(random(9) < 1){
                 // Elite Jellies:
                var _eliteChance = 5 * (GameCont.loops + 1);
                if(random(100) < _eliteChance){
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
            else if(random(4) < 1){
                obj_create(_x, _y, "Eel");
            }
        }
    }

#define area_pop_props
     // Quarter Walls:
    var _wallChance = (styleb ? 3 : 12); // higher chance of cover over pits
    if(random(_wallChance) < 1){
        if(point_distance(x, y, 10016, 10016) > 100 && !place_meeting(x, y, NOWALLSHEREPLEASE)){
            var _x = x + choose(0, 16),
                _y = y + choose(0, 16);

            if(!place_meeting(_x, _y, hitme)){
                instance_create(_x, _y, Wall);
                instance_create(x, y, NOWALLSHEREPLEASE);
            }
        }
    }

     // Prop Spawns:
    else if(random(16) < 1 && !styleb){
        var _x = x + 16,
            _y = y + 16;

    	if(random(10) < 1){
    		obj_create(_x, _y, "EelSkull");
    	}
		else{
        	obj_create(_x + orandom(8), _y + orandom(8), choose("Kelp", "Kelp", "Vent"));
		}
    }

     // Top Decals:
    if(random(80) < 1){
        scrTopDecal(x + 16, y + 16, "trench");
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
    image_blend = merge_color(image_blend, c_black, 0.05);

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
    if(abs(image_xscale) < 0.2) instance_destroy();

#define draw_pit
    if(!instance_exists(GenCont)){
        var _surf = global.surf,
            _surfw = global.surfw,
            _surfh = global.surfh,
            _surfx = global.surfx,
            _surfy = global.surfy;

        for(var i = 0; i < array_length(_surf); i++){
            if(!surface_exists(_surf[i])){
                _surf[i] = surface_create(_surfw, _surfh);
                global.surf_reset = true;
            }
        }

        if(global.surf_reset){
            global.surf_reset = false;

             // Center Surfaces:
            _surfx = 0;
            _surfy = 0;
            var n = 0;
            with(instances_matching_ne(Floor, "object_index", FloorExplo)){
                _surfx += x;
                _surfy += y;
                n++;
            }
            _surfx /= n;
            _surfy /= n;
            _surfx -= _surfw / 2;
            _surfy -= _surfh / 2;
            global.surfx = _surfx;
            global.surfy = _surfy;

             // Pit Walls:
            surface_set_target(_surf[0]);
            draw_clear_alpha(0, 0);

            var _spr = [[spr.PitBot, spr.PitSmallBot], [spr.Pit, spr.PitSmall]];
            for(var i = 0; i < array_length(_spr); i++){
                 // Normal:
                with(instances_matching(Floor, "sprite_index", spr.FloorTrench)){
                    draw_sprite(_spr[i, 0], image_index, x - _surfx, y - _surfy);
                }

                 // Small:
                with(instances_matching([Wall, FloorExplo], "styleb", false, null)){
                    draw_sprite(_spr[i, 1], image_index, x - _surfx, y - _surfy);
                }
            }

             // Pit Wall Tops:
            surface_set_target(_surf[1]);
            draw_clear_alpha(0, 0);

            with(instances_matching(Floor, "sprite_index", spr.FloorTrench)){
                draw_sprite(spr.PitTop, image_index, x - _surfx, y - _surfy);
            }
            with(instances_matching([Wall, FloorExplo], "styleb", false, null)){
                draw_sprite(spr.PitSmallTop, image_index, x - _surfx, y - _surfy);
            }

             // Pit Mask:
            surface_set_target(_surf[2]);
            draw_clear_alpha(0, 0);
            draw_set_color(c_black);

            with(instances_matching(Floor, "styleb", true)){
                draw_sprite(sprite_index, image_index, x - _surfx, y - _surfy);
            }

             // Reset Pit Sink Objects:
            with(instances_matching_ne([Debris, Shell, ChestOpen, Corpse], "pit_check", null)){
                pit_check = null;
            }

            surface_reset_target();
        }

        /// > > > DRAW YOUR PIT SHIT HERE < < <
        surface_set_target(_surf[2]);

        draw_set_color_write_enable(1, 1, 1, 0);
        draw_set_color(/*c_blue*/c_black);
        draw_rectangle(0, 0, _surfw, _surfh, 0);
        draw_set_color(c_white);

             // Pit Squid:
            with(instances_matching(CustomEnemy, "name", "PitSquid")){
                var h = (nexthurt > current_frame + 3),
                    _xscal = image_xscale * max(pit_height, 0),
                    _yscal = image_yscale * max(pit_height, 0),
                    _angle = image_angle,
                    _blend = merge_color(c_black, image_blend, pit_height),
                    _alpha = image_alpha;

                 // Eyes:
                with(eye){
                    var _x = x - _surfx,
                        _y = y - _surfy + 16,
                        l = dis * max(other.pit_height, 0),
                        d = dir;

                    with(other){
                         // Cornea + Pupil:
                        if(h) d3d_set_fog(1, image_blend, 0, 0);
                        if(other.blink_img < sprite_get_number(spr.PitSquidEyelid) - 1){
                            draw_sprite_ext(spr.PitSquidCornea, image_index, _x,                                    _y,                                    _xscal, _yscal, _angle, _blend, _alpha);
                            draw_sprite_ext(spr.PitSquidPupil,  image_index, _x + lengthdir_x(l * image_xscale, d), _y + lengthdir_y(l * image_yscale, d), _xscal, _yscal, _angle, _blend, _alpha);
                        }
                        if(h) d3d_set_fog(0, 0, 0, 0);

                         // Eyelid:
                        draw_sprite_ext(spr.PitSquidEyelid, other.blink_img, _x, _y, _xscal, _yscal, _angle, _blend, _alpha);
                    }
                }

                 // Bite:
                if(bite > 0 && bite <= 1){
                    draw_sprite_ext(spr.PitSquidMaw, ((1 - bite) * sprite_get_number(spr.PitSquidMaw)), x - _surfx, y - _surfy + 16, _xscal, _yscal, _angle, _blend, _alpha);
                }
            }

             // Pit Walls:
            draw_surface(_surf[0], 0, 0);

             // Make Proto Statues Cooler:
            with(ProtoStatue){
                if(floor_at(x, bbox_bottom).styleb){
                    spr_shadow = -1;

                    var _spr = spr.PStatTrenchIdle;
                    if(sprite_index == spr_hurt) _spr = spr.PStatTrenchHurt;
                    draw_sprite(_spr,                  image_index, x - _surfx, y - _surfy);
                    draw_sprite(spr.PStatTrenchLights, anim,        x - _surfx, y - _surfy);

                    // i know but base game doesnt use draw_sprite_ext either
                }
            }
            with(instances_matching(Corpse, "sprite_index", sprPStatDead)){
                if(floor_at(x, bbox_bottom).styleb){
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
            with(instances_named(CustomObject, "PitSink")){
                draw_sprite_ext(sprite_index, image_index, x - _surfx, y - _surfy, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
            }

             // Pit Wall Tops:
            draw_surface(_surf[1], 0, 0);

        draw_set_color_write_enable(1, 1, 1, 1);
        surface_reset_target();

        draw_surface(_surf[2], _surfx, _surfy);
    }


/// Scripts
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
#define target_in_distance(_disMin, _disMax)                                            return  mod_script_call(   "mod", "telib", "target_in_distance", _disMin, _disMax);
#define target_is_visible()                                                             return  mod_script_call(   "mod", "telib", "target_is_visible");
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
#define orandom(n)                                                                      return  mod_script_call_nc("mod", "telib", "orandom", n);
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