#define init

#macro bg_color area_get_background_color(101);
#macro shd_color area_get_shadow_color(101);

#define area_name(_subarea, _loop)
    return "@1(sprInterfaceIcons)2-" + string(_subarea);
    
#define area_secret
    return true;
    
#define area_mapdata(_lastx, _lasty, _lastarea, _lastsubarea, _subarea, _loops)
    return [_lastx+0.5,-8,1];
    
#define area_sprite(_spr)
    switch(_spr){
         // floors
        case(sprFloor1): return sprFloor101;
        case(sprFloor1B): return sprFloor101B;
        case(sprFloor1Explo): return sprFloor101Explo;
         // walls
        case(sprWall1Trans): return sprWall101Trans;
        case(sprWall1Bot): return sprWall101Bot;
        case(sprWall1Out): return sprWall101Out;
        case(sprWall1Top): return sprWall101Top;
         // misc
        case(sprDebris1): return sprDebris101;
        case(sprDetail1): return sprDetail101;
    }
    
#define area_setup
    goal = 100;
    BackCont.shadcol = shd_color;
    background_color = bg_color;
    sound_play_music(mus101);
    
#define area_step
     // lightning
    with instances_matching(Lightning,"team",2){
        image_speed = 0.1;
        if floor(image_index) == sprite_get_number(sprite_index)-1{
            team = 0;
            sprite_index = sprEnemyLightning;
            image_speed = 0.3;
            image_index = 0;
            if random(8) < 1{
                sound_play_hit(sndLightningHit,0.2);
                with instance_create(x,y,GunWarrantEmpty)
                    image_angle = other.direction;
            }
            else if random(3) < 1
                instance_create(x+orandom(18),y+orandom(18),PortalL)
        }
    }
     // reskin opened chests
    with instances_matching(ChestOpen,"sprite_index",sprWeaponChestOpen)
        sprite_index = sprClamChestOpen;
        
#define area_make_floor
    var _x = x,
        _y = y,
        _outOfSpawn = point_distance(_x,_y,10016,10016) > 48;
     // make floors
    if random(3) < 1{
        scrFloorFillRound(_x,_y,3,3);
    }
    instance_create(_x,_y,Floor);
     // turn
    var _turn = 0;
    if random(6) < 3
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
    
#define scrFloorFillRound(_x,_y,_w,_h)
    return mod_script_call("mod","ntte","scrFloorFillRound",_x,_y,_w,_h);
    
#define area_finish
     // area end
    area = 3;
    subarea = 3;
    
#define area_pop_enemies
    var _x = x+16,
        _y = y+16;
        
    if random(5) < 1{
        if random(3) < 2
            instance_create(_x,_y,Crab);
        else
            obj_create(_x,_y,"Hammerhead");
    }
    else{
        if random(6) < 5
            instance_create(_x,_y,BoneFish);
        else
            obj_create(_x,_y,"Diver");
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
    
#define area_pop_extras
     // fix b tiles
    with instances_matching(Floor,"styleb",true)
        depth -= 1;
        
#define obj_create(_x,_y,_obj)
    return mod_script_call("mod","telib","obj_create",_x,_y,_obj);
    
#define orandom(_n)
    return irandom_range(-_n,_n);
    
    