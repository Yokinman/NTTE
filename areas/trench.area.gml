#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");

     // SPRITES //
    with(spr){
         // Floors:
        FloorTrench       = sprite_add("../sprites/areas/Trench/sprFloorTrench.png",      4, 0, 0);
        FloorTrenchB      = sprite_add("../sprites/areas/Trench/sprFloorTrenchB.png",     4, 2, 2);
        FloorTrenchExplo  = sprite_add("../sprites/areas/Trench/sprFloorTrenchExplo.png", 5, 1, 1);

         // Walls:
        WallTrenchTrans   = sprite_add("../sprites/areas/Trench/sprWallTrenchTrans.png",  8, 0,  0);
        WallTrenchBot     = sprite_add("../sprites/areas/Trench/sprWallTrenchBot.png",    4, 0,  0);
        WallTrenchOut     = sprite_add("../sprites/areas/Trench/sprWallTrenchOut.png",    1, 4, 12);
        WallTrenchTop     = sprite_add("../sprites/areas/Trench/sprWallTrenchTop.png",    8, 0,  0);

         // Misc:
        DebrisTrench      = sprite_add("../sprites/areas/Trench/sprDebrisTrench.png",     4, 0, 0);
        DetailTrench      = sprite_add("../sprites/areas/Trench/sprDetailTrench.png",     6, 0, 0);
        TopDecalTrench    = sprite_add("../sprites/areas/Trench/sprTopDecalTrench.png",   1, 0, 0);

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
        global.resetsurfaces = true;
    //#endregion

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus

#macro bgrColor make_color_rgb(100, 114, 127)
#macro shdColor c_black
#macro musMain  musBoss5
#macro ambMain  amb101

#define area_name(_subarea, _loop)
    return "@1(sprInterfaceIcons)3-" + string(_subarea);
    
#define area_secret
    return true;
    
#define area_mapdata(_lastx, _lasty, _lastarea, _lastsubarea, _subarea, _loops)
    return [_lastx + ((_lastarea == mod_current) ? 8.75 : 0.5), -8, (_subarea == 1)];
    
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

    background_color = bgrColor;
    BackCont.shadcol = shdColor;
    sound_play_music(musMain);
    sound_play_ambient(ambMain);
    TopCont.darkness = true;

     // reset surfaces
    for(var i = 0; i <= 1; i++) if surface_exists(global.surf[i])
        surface_free(global.surf[i]);
    
#define area_start
     // Bind pit drawing scripts:
	if !array_length_1d(instances_matching(CustomDraw, "name", "draw_pit"))
    	with(script_bind_draw(draw_pit, 7))
    		name = "draw_pit"
    
#define area_step
     // Run underwater code
    mod_script_call("mod","ntte","underwater_step");
    
     // mess with depth -- temporary fix for scorchmarks showing in the pits
    with(instances_matching([Scorch, ScorchTop], "trench_fix", null)){
        trench_fix = true;
        depth = 7;
    }

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
    
    if random(9) < 1{
        obj_create(_x,_y,"Jellyfish");
    }
    else if random(3) < 1{
        obj_create(_x,_y,"Eel");
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
     // fix b tiles
    with instances_matching(Floor,"styleb",true)
        depth = 8;
     // delete stuff
    with instances_matching(Floor,"styleb",true){
        with(Detail) if place_meeting(x,y,other)
            instance_destroy();
    }
    
#define draw_pit
    if !instance_exists(GenCont){
        var _x = 10000-0.5*global.surfw,
            _y = 10000-0.5*global.surfh;
         // draw pit walls
        if !surface_exists(global.surf[0]){
             // create surface
            global.surf[0] = surface_create(global.surfw,global.surfh);
            surface_set_target(global.surf[0]);
                 // draw pit wall sprites
                var _sprFull = [spr.PitBot,spr.Pit,spr.PitTop],
                    _sprSmall = [spr.PitSmallBot,spr.PitSmall,spr.PitSmallTop];
                for (var _h = 0; _h <= 2; _h++){
                    with instances_matching(Floor,"sprite_index",spr.FloorTrench){
                        draw_sprite(_sprFull[_h],1,x-_x,y-_y);
                    }
                    with instances_matching(GameObject,"object_index",Wall,FloorExplo){
                        draw_sprite(_sprSmall[_h],1,x-_x,y-_y);
                    }
                }
            surface_reset_target();
        }
         // draw pit mask
        if !surface_exists(global.surf[1]){
            global.surf[1] = surface_create(global.surfw,global.surfh);
            surface_set_target(global.surf[1])
                draw_set_color(c_black);
                with instances_matching(Floor,"styleb",true){
                    draw_sprite(sprite_index,image_index,x-_x,y-_y);
                }
        }
        surface_set_target(global.surf[1])
            draw_set_color_write_enable(1,1,1,0);
            draw_set_color(c_black);
            draw_rectangle(0,0,global.surfw,global.surfh,0);
            draw_set_color(c_white);
            
             // > > > DRAW YOUR PIT SHIT HERE < < <
            
            draw_surface(global.surf[0],0,0);
            draw_set_color_write_enable(1,1,1,1);
        surface_reset_target();
        draw_surface(global.surf[1],_x,_y);
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