#define init
    //#region SPRITES
         // Floors:
        global.sprFloorTrench       = sprite_add("../sprites/areas/Trench/sprFloorTrench.png",      4, 0, 0);
        global.sprFloorTrenchB      = sprite_add("../sprites/areas/Trench/sprFloorTrenchB.png",     4, 2, 2);
        global.sprFloorTrenchExplo  = sprite_add("../sprites/areas/Trench/sprFloorTrenchExplo.png", 5, 1, 1);

         // Walls:
        global.sprWallTrenchTrans   = sprite_add("../sprites/areas/Trench/sprWallTrenchTrans.png",  8, 0,  0);
        global.sprWallTrenchBot     = sprite_add("../sprites/areas/Trench/sprWallTrenchBot.png",    4, 0,  0);
        global.sprWallTrenchOut     = sprite_add("../sprites/areas/Trench/sprWallTrenchOut.png",    1, 4, 12);
        global.sprWallTrenchTop     = sprite_add("../sprites/areas/Trench/sprWallTrenchTop.png",    8, 0,  0);

         // Misc:
        global.sprDebrisTrench      = sprite_add("../sprites/areas/Trench/sprDebrisTrench.png",     4, 0, 0);
        global.sprDetailTrench      = sprite_add("../sprites/areas/Trench/sprDetailTrench.png",     6, 0, 0);
        global.sprTopDecalTrench    = sprite_add("../sprites/areas/Trench/sprTopDecalTrench.png",   1, 0, 0);

        /// Pits:
             // Small:
            global.sprPit       = sprite_add("../sprites/areas/Trench/Pit/sprPit.png",      1, 2, 2);
            global.sprPitTop    = sprite_add("../sprites/areas/Trench/Pit/sprPitTop.png",   1, 2, 2);
            global.sprPitBot    = sprite_add("../sprites/areas/Trench/Pit/sprPitBot.png",   1, 2, 2);

             // Large:
            global.sprPitSmall      = sprite_add("../sprites/areas/Trench/Pit/sprPitSmall.png",     1, 3, 3);
            global.sprPitSmallTop   = sprite_add("../sprites/areas/Trench/Pit/sprPitSmallTop.png",  1, 3, 3);
            global.sprPitSmallBot   = sprite_add("../sprites/areas/Trench/Pit/sprPitSmallBot.png",  1, 3, 3);
    //#endregion
            
    //#region SURFACES
        global.surfw = 2000;
        global.surfh = 2000;
        global.surf = [noone, noone];
        global.resetsurfaces = true;
    //#endregion

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
        case sprFloor1      : return global.sprFloorTrench;
        case sprFloor1B     : return global.sprFloorTrenchB;
        case sprFloor1Explo : return global.sprFloorTrenchExplo;

         // Walls:
        case sprWall1Trans  : return global.sprWallTrenchTrans;
        case sprWall1Bot    : return global.sprWallTrenchBot;
        case sprWall1Out    : return global.sprWallTrenchOut;
        case sprWall1Top    : return global.sprWallTrenchTop;

         // Misc:
        case sprDebris1     : return global.sprDebrisTrench;
        case sprDetail1     : return global.sprDetailTrench;
    }
    
#define area_setup
    goal = 100;

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
    if array_length_1d(instances_matching(Floor,"sprite_index",global.sprFloorTrench)) >= (1-(GameCont.subarea*0.25))*GenCont.goal && _outOfSpawn{
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
    
#define area_pop_props
     // top decal
     // how do you do them
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
        obj_create(_x,_y,"Kelp");
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
        
#define obj_create(_x,_y,_obj)
    return mod_script_call("mod","telib","obj_create",_x,_y,_obj);
    
#define orandom(_n)
    return irandom_range(-_n,_n);
    
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
                var _sprFull = [global.sprPitBot,global.sprPit,global.sprPitTop],
                    _sprSmall = [global.sprPitSmallBot,global.sprPitSmall,global.sprPitSmallTop];
                for (var _h = 0; _h <= 2; _h++){
                    with instances_matching(Floor,"sprite_index",global.sprFloorTrench){
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