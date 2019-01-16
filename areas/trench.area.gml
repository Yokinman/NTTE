#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");

     // SPRITES //
    with(spr){
         // Floors:
        FloorTrench       = sprite_add("../sprites/areas/Trench/sprFloorTrench.png",      4,  0,  0);
        FloorTrenchB      = sprite_add("../sprites/areas/Trench/sprFloorTrenchB.png",     4,  2,  2);
        FloorTrenchExplo  = sprite_add("../sprites/areas/Trench/sprFloorTrenchExplo.png", 5,  1,  1);

         // Walls:
        WallTrenchTrans   = sprite_add("../sprites/areas/Trench/sprWallTrenchTrans.png",  8,  0,  0);
        WallTrenchBot     = sprite_add("../sprites/areas/Trench/sprWallTrenchBot.png",    4,  0,  0);
        WallTrenchOut     = sprite_add("../sprites/areas/Trench/sprWallTrenchOut.png",    1,  4, 12);
        WallTrenchTop     = sprite_add("../sprites/areas/Trench/sprWallTrenchTop.png",    8,  0,  0);

         // Misc:
        DebrisTrench      = sprite_add("../sprites/areas/Trench/sprDebrisTrench.png",     4,  0, 0);
        DetailTrench      = sprite_add("../sprites/areas/Trench/sprDetailTrench.png",     6,  0, 0);
        TopDecalTrench    = sprite_add("../sprites/areas/Trench/sprTopDecalTrench.png",   1,  0, 0);

        /// Pits:
             // Small:
            Pit       = sprite_add("../sprites/areas/Trench/Pit/sprPit.png",      1, 2, 2);
            PitTop    = sprite_add("../sprites/areas/Trench/Pit/sprPitTop.png",   1, 2, 2);
            PitBot    = sprite_add("../sprites/areas/Trench/Pit/sprPitBot.png",   1, 2, 2);

             // Large:
            PitSmall      = sprite_add("../sprites/areas/Trench/Pit/sprPitSmall.png",     1, 3, 3);
            PitSmallTop   = sprite_add("../sprites/areas/Trench/Pit/sprPitSmallTop.png",  1, 3, 3);
            PitSmallBot   = sprite_add("../sprites/areas/Trench/Pit/sprPitSmallBot.png",  1, 3, 3);
    }
            
    //#region SURFACES
        global.surfw = 2000;
        global.surfh = 2000;
        global.surf = [noone, noone];
        global.surf_reset = false;
    //#endregion

    global.trench_visited = [];

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus

#macro bgrColor make_color_rgb(100, 114, 127)
#macro shdColor c_black

#macro TrenchVisited global.trench_visited

#define area_music      return musBoss5;
#define area_ambience   return amb101;
#define area_secret     return true;

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
    safespawn = 2;
    background_color = bgrColor;
    BackCont.shadcol = shdColor;
    TopCont.darkness = true;

     // reset surfaces
    for(var i = 0; i <= 1; i++) if surface_exists(global.surf[i])
        surface_free(global.surf[i]);
    
#define area_start
     // Floor Setup:
    with(Floor){
        if(styleb){
             // Fix Depth:
            depth = 8;

             // Slippery pits:
            traction = 0.1;
        }

         // Footsteps:
        material = (styleb ? 0 : 4);
    }

     // Bind pit drawing scripts:
	if !array_length_1d(instances_matching(CustomDraw, "name", "draw_pit"))
    	with(script_bind_draw(draw_pit, 7))
    		name = "draw_pit"
    		
     // Anglers:
    with(RadChest) if random(40) < 1{
        obj_create(x, y, "Angler");
        instance_delete(id);
    }
    
#define area_step
     // Run underwater code
    mod_script_call("mod","ntte","underwater_step");
    
     // mess with depth -- temporary fix for scorchmarks showing in the pits
    with(instances_matching([Scorch, ScorchTop], "trench_fix", null)){
        trench_fix = true;
        depth = 7;
    }

     // Above Pits:
    with(Player){
        var _x = x,
            _y = bbox_bottom,
            f = nearest_instance(_x - 16, _y - 16, instances_matching(Floor, "styleb", true));

        if(instance_exists(f)){
            var _x1 = f.x + 0,
                _y1 = f.y + 0,
                _x2 = _x1 + 32,
                _y2 = _y1 + 32,
                e = instance_nearest(_x - 8, _y - 8, FloorExplo);

            if(point_in_rectangle(_x, _y, _x1, _y1, _x2, _y2) && (!position_meeting(_x, _y, e) || e.styleb)){
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
    }

     // Floaty Effects Above Pits:
    with(instances_matching([WepPickup, chestprop], "", null)){
        var _x = x,
            _y = bbox_bottom,
            f = instance_nearest(_x - 16, _y - 16, Floor);

        if(instance_exists(f) && f.styleb){
            var _x = x + cos((current_frame + x + y) / 10) * 0.15,
                _y = y + sin((current_frame + x + y) / 10) * 0.15;

            if(!place_meeting(_x, y, Wall)) x = _x;
            if(!place_meeting(x, _y, Wall)) y = _y;
        }
    }

     // Stuff Falling Into Pits:
    with(instances_matching_le([Debris, Shell, ChestOpen], "speed", 1)){
        var _x = x,
            _y = bbox_bottom,
            f = instance_nearest(_x - 16, _y - 16, Floor);

        if(instance_exists(f) && f.styleb){
            pit_sink(x, y, sprite_index, image_index, image_xscale, image_yscale, image_angle, direction, speed, orandom(1));
            instance_destroy();
        }
    }
    with(instances_matching(Corpse, "image_speed", 0)){
        var _x = x,
            _y = y,
            f = instance_nearest(_x - 16, _y - 16, Floor);

        if(instance_exists(f) && f.styleb){
            pit_sink(x, y, sprite_index, image_index, image_xscale, image_yscale, image_angle, direction, speed, orandom(0.6))
            instance_destroy();
        }
    }

     // Lag Helper:
    var s = instances_matching(CustomObject, "name", "PitSink"),
        m = array_length(s);

    while(m > 80) with(s[--m]) instance_destroy();

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
    y += 1/3 * current_time_scale;

     // Spins:
    direction += rotspeed * current_time_scale;
    image_angle += rotspeed * current_time_scale;

     // He gone:
    if(abs(image_xscale) < 0.2) instance_destroy();

#define area_effect(_vx, _vy)
    var _x = _vx + random(game_width),
        _y = _vy + random(game_height);

     // Player Bubbles:
    if(random(4) < 1){
        with(Player) instance_create(x, y, Bubble);
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
        _outOfSpawn = point_distance(_x,_y,10016,10016) > 48;
     // determine if styleb
    styleb = false;
    if array_length_1d(instances_matching(Floor,"sprite_index",spr.FloorTrench)) >= (1-(GameCont.subarea*0.25))*GenCont.goal && _outOfSpawn{
        styleb = true;
    }
     // make floors
    if random(7) < 1 && _outOfSpawn{
        var _w = irandom_range(3,5),
            _h = 8-_w;
        scrFloorFill(_x,_y,_w,_h);
    }
    instance_create(_x,_y,Floor);
     // turn
    var _turn = 0;
    if random(7) < 3
        _turn = choose(90,-90,180);
    direction += _turn;
     // turnarounds
    if _turn == 180{
        if _outOfSpawn
            with scrFloorMake(_x,_y,WeaponChest)
                sprite_index = sprClamChest;
    }
     // dead ends
    if random(19+instance_number(FloorMaker)) > 22{
        if _outOfSpawn
            scrFloorMake(_x,_y,AmmoChest);
        instance_destroy();
    }
    else if random(5) < 1
        instance_create(_x,_y,FloorMaker);
        
#define scrFloorMake(_x,_y,_obj)
    return mod_script_call("mod","ntte","scrFloorMake",_x,_y,_obj);
    
#define scrFloorFill(_x,_y,_w,_h)
    return mod_script_call("mod","ntte","scrFloorFill",_x,_y,_w,_h);
    
#define scrFloorFillRound(_x,_y,_w,_h)
    return mod_script_call("mod","ntte","scrFloorFillRound",_x,_y,_w,_h);
    
#define area_finish
     // reset surfaces
    for(var i = 0; i <= 1; i++) if surface_exists(global.surf[i])
        surface_free(global.surf[i]);
     // Area End:
    if(lastarea = mod_current && subarea >= 3) {
        area = 4; // crystal caves
        if array_length_1d(instances_matching(Player,"curse",true)) || array_length_1d(instances_matching(Player,"bcurse",true))
            area = 104; // cursed caves
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
    
    if !styleb && random(18) < 1{
        obj_create(_x, _y, "Angler");
    }
    else{
        if random(9) < 1{
            obj_create(_x,_y,"Jelly");
        }
        else if random(3) < 1{
            obj_create(_x,_y,"Eel");
        }
    }
    
#define area_pop_props
    var _wallChance = (styleb ? 3 : 12); // higher chance of cover over pits
    if random(_wallChance) < 1{
         // quarter walls
        if point_distance(x,y,10016,10016) > 100 && !place_meeting(x,y,NOWALLSHEREPLEASE){
            var _x = x+choose(0,16),
                _y = y+choose(0,16);
            if !place_meeting(_x,_y,hitme){
                instance_create(_x,_y,Wall);
                instance_create(x,y,NOWALLSHEREPLEASE);
            }
        }
    }
    else if random(16) < 1 && !styleb{
        var _x = x+16+orandom(8),
            _y = y+16+orandom(8);
        obj_create(_x,_y,choose("Kelp","Kelp","Vent"));
    }
    
#define area_pop_extras
     // delete stuff
    with instances_matching(Floor,"styleb",true){
        with(Detail) if place_meeting(x,y,other)
            instance_destroy();
    }
    
#define draw_pit
    if(!instance_exists(GenCont)){
        var _surfx = 10000 - (0.5 * global.surfw),
            _surfy = 10000 - (0.5 * global.surfh);

         // Pit Walls:
        if(!surface_exists(global.surf[0]) || global.surf_reset){
            if(!surface_exists(global.surf[0])){
                global.surf[0] = surface_create(global.surfw,global.surfh);
            }
            surface_set_target(global.surf[0]);
            draw_clear_alpha(0, 0);

            var _spr = [spr.PitBot, spr.Pit, spr.PitTop];
            for(var i = 0; i < array_length(_spr); i++){
                with(instances_matching(Floor, "sprite_index", spr.FloorTrench)){
                    draw_sprite(_spr[i], image_index, x - _surfx, y - _surfy);
                }
            }
            var _spr = [spr.PitSmallBot, spr.PitSmall, spr.PitSmallTop];
            for(var i = 0; i < array_length(_spr); i++){
                with(instances_matching([Wall, FloorExplo], "styleb", false, null)){
                    draw_sprite(_spr[i], image_index, x - _surfx, y - _surfy);
                }
            }

            surface_reset_target();
        }

         // Pit Mask:
        if(!surface_exists(global.surf[1]) || global.surf_reset){
            if(!surface_exists(global.surf[1])){
                global.surf[1] = surface_create(global.surfw, global.surfh);
            }
            surface_set_target(global.surf[1]);
            draw_clear_alpha(0, 0);

            draw_set_color(c_black);
            with(instances_matching(Floor, "styleb", true)){
                draw_sprite(sprite_index, image_index, x - _surfx, y - _surfy);
            }
        }
        global.surf_reset = false;

        surface_set_target(global.surf[1]);

        draw_set_color_write_enable(1, 1, 1, 0);
        draw_set_color(c_black);
        draw_rectangle(0, 0, global.surfw, global.surfh, 0);
        draw_set_color(c_white);

        /// > > > DRAW YOUR PIT SHIT HERE < < <
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
                        if(h) d3d_set_fog(1, c_white, 0, 0);
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

             // Stuff that fell in pit:
            with(instances_named(CustomObject, "PitSink")){
                draw_sprite_ext(sprite_index, image_index, x - _surfx, y - _surfy, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
            }

            draw_surface(global.surf[0], 0, 0);

        draw_set_color_write_enable(1, 1, 1, 1);
        surface_reset_target();

        draw_surface(global.surf[1], _surfx, _surfy);
    }


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