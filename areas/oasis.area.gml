#define init

#macro bgrColor area_get_background_color(101);
#macro shdColor area_get_shadow_color(101);
#macro musMain  mus101
#macro ambMain  amb101

#define area_name(_subarea, _loop)
    return "@1(sprInterfaceIcons)2-" + string(_subarea);
    
#define area_secret
    return true;
    
#define area_mapdata(_lastx, _lasty, _lastarea, _lastsubarea, _subarea, _loops)
    return [_lastx+0.5,-8,1];
    
#define area_sprite(_spr)
    switch(_spr){
         // Floors:
        case sprFloor1      : return sprFloor101;
        case sprFloor1B     : return sprFloor101B;
        case sprFloor1Explo : return sprFloor101Explo;

         // Walls:
        case sprWall1Trans  : return sprWall101Trans;
        case sprWall1Bot    : return sprWall101Bot;
        case sprWall1Out    : return sprWall101Out;
        case sprWall1Top    : return sprWall101Top;

         // Misc:
        case sprDebris1     : return sprDebris101;
        case sprDetail1     : return sprDetail101;
    }
    
#define area_setup
    goal = 130;

    background_color = bgrColor;
    BackCont.shadcol = shdColor;
    sound_play_music(musMain);
    sound_play_ambient(ambMain);

#define area_start
     // Fix B Floors:
    with(instances_matching(Floor, "styleb", true)) depth = 8;

     // Coolin Clammin:
    with(WeaponChest){
        obj_create(x, y, "ClamChest");
        instance_delete(id);
    }

#define area_step
     // Run underwater code:
    mod_script_call("mod","ntte","underwater_step");
     // Spawn trench entrance:
    with(Portal) if !array_length_1d(instances_matching(CustomObject,"name","TrenchEntrance")){
        with nearest_instance(10000,10000,instances_matching_ne(Floor,"object_index",FloorExplo)) obj_create(x+16,y+16,"TrenchEntrance");
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

     // Normal:
	instance_create(_x, _y, Floor);
	
	 // Special - Diamond:
	if(random(3) < 1){
	    var o = 32;
	    for(var d = 0; d < 360; d += 90){
	        instance_create(_x + lengthdir_x(o, d), _y + lengthdir_y(o, d), Floor);
	    }
	}

     // Turn:
    var _trn = 0;
    if(random(4) < 1){
	    _trn = choose(90, 90, -90, -90, 180);
    }
    direction += _trn;

     // Turn Arounds (Weapon Chests):
    if(_trn == 180 && _outOfSpawn){
        with(scrFloorMake(_x, _y, WeaponChest)){
            sprite_index = sprClamChest;
        }
    }

     // Dead Ends (Ammo Chests):
	if(random(19 + instance_number(FloorMaker)) > 20){
		if(_outOfSpawn) scrFloorMake(_x, _y, AmmoChest);
		instance_destroy();
	}

	 // Branch:
	if(random(5) < 1) instance_create(_x, _y, FloorMaker);
        
#define scrFloorMake(_x,_y,_obj)
    return mod_script_call("mod","ntte","scrFloorMake",_x,_y,_obj);
    
#define scrFloorFillRound(_x,_y,_w,_h)
    return mod_script_call("mod","ntte","scrFloorFillRound",_x,_y,_w,_h);
    
#define area_finish
    lastarea = area;

     // Area End:
    if(subarea >= 1){
        area = 3;
        subarea = 3;
    }

     // Next Subarea: 
    else subarea++;
    
#define area_pop_enemies
    var _x = x + 16,
        _y = y + 16;

    if(random(2) < 1){
         // Shoals:
        if(random(2) < 1){
            if(!styleb && random(4) < 3){
                repeat(irandom_range(1, 4)) instance_create(_x, _y, BoneFish);
            }
            else{
                repeat(irandom_range(1, 4)) obj_create(_x, _y, "Puffer");
            }
        }

        else{
            if(random(5) < 2) obj_create(_x, _y, "Diver");
            else{
                if(!styleb){
                    if(random(2) < 1) instance_create(_x,_y,Crab);
                }
                else obj_create(_x, _y, "Hammerhead"); 
            }
        }
    }
    
#define area_pop_props
     // coral
    if !place_free(x-32,y) && !place_free(x+32,y){
        for (var _x = -1; _x <= 1; _x += 2)
            for (var _y = 0; _y <= 1; _y++)
                if random(10) < 1
                    with instance_create(x+(1-_x)*16,y+16*_y,Bones){
                        image_xscale = _x;
                        sprite_index = sprCoral;
                    }
    }
    with(Bones) if !place_meeting(x,y,Wall)
        instance_destroy();
    if random(14) < 1{
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
    else if random(7) < 1{
        var _x = x+16+orandom(8),
            _y = y+16+orandom(8);
        if styleb{
            obj_create(_x,_y,choose(WaterMine,WaterMine,OasisBarrel,Anchor));
        }
        else{
            obj_create(_x,_y,choose(WaterPlant,WaterPlant,OasisBarrel,WaterMine));
        }
    }

#define obj_create(_x,_y,_obj)
    return mod_script_call("mod","telib","obj_create",_x,_y,_obj);
    
#define nearest_instance(_x,_y,_instance)
    return mod_script_call("mod","telib","nearest_instance",_x,_y,_instance);
    
#define orandom(_n)
    return irandom_range(-_n,_n);
    
    