#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus

#macro bgrColor area_get_background_color(102)
#macro shdColor area_get_shadow_color(2)
#macro musMain  mus2
#macro ambMain  amb102

#macro Rooms instances_matching(CustomObject,"name","RoomGen")

#define area_name(_subarea, _loop)
    return "2-?";
    
#define area_secret
    return true;
    
#define area_mapdata(_lastx, _lasty, _lastarea, _lastsubarea, _subarea, _loops)
    return [_lastx+0.5,-8,1];
    
#define area_sprite(_spr)
    switch(_spr){
         // Floors:
        case sprFloor1      : return sprFloor2;
        case sprFloor1B     : return sprFloor2;
        case sprFloor1Explo : return sprFloor2Explo;

         // Walls:
        case sprWall1Trans  : return sprWall102Trans;
        case sprWall1Bot    : return sprWall102Bot;
        case sprWall1Out    : return sprWall102Out;
        case sprWall1Top    : return sprWall102Top;

         // Misc:
        case sprDebris1     : return sprDebris2;
        case sprDetail1     : return sprDetail2;
    }
    
#define area_setup
    goal = 75;
    maxrooms = 7;
    safespawn = 0; // why does this shift everything around ??

    background_color = bgrColor;
    BackCont.shadcol = shdColor;
    sound_play_music(musMain);
    sound_play_ambient(ambMain);
    TopCont.darkness = true;

#define area_start
     // Fix B Floors:
    with(instances_matching(Floor, "styleb", true)) depth = 8;

#define area_step

#define area_effect(_vx, _vy)
    var _x = _vx + random(game_width),
        _y = _vy + random(game_height);

     // Drips:
    var f = instance_nearest(_x, _y, Floor);
    with(f) instance_create(x + random(32), y + random(32), Drip);

    return 30 + random(20);

#define area_make_floor
    var _x = x,
        _y = y,
        _outOfSpawn = point_distance(_x,_y,10016,10016) > 48;
     // Normal:
	instance_create(_x, _y, Floor);
	
	 // Special - Rooms:
	if random(6) < 1 && variable_instance_exists(GenCont, "maxrooms") && array_length_1d(Rooms) < GenCont.maxrooms
	    scrRoomCreate(_x,_y, choose("Default", "Light"));
	    
	 // Spawn cathole:
    if random(7) < 1
        obj_create(_x,_y,"Cathole");

     // Turn:
    var _trn = 0;
    if(random(3) < 1){
	    _trn = choose(90, -90, 180);
    }
    direction += _trn;

     // Turn Arounds (Weapon Chests):
    if(_trn == 180 && _outOfSpawn){
        scrFloorMake(_x, _y, WeaponChest);
    }

     // Dead Ends (Ammo Chests):
	if(random(19 + instance_number(FloorMaker)) > 20){
		if(_outOfSpawn) scrFloorMake(_x, _y, AmmoChest);
		instance_destroy();
	}
	
	 // Branch:
	if(random(9) < 1) instance_create(_x, _y, FloorMaker);
	
	 // Spawn manhole:
	if !array_length_1d(instances_matching(Rooms,"type","Exit")) && instance_number(Floor) >= GenCont.goal / 2{
	    scrRoomCreate(_x, _y, "Exit");
	}
	
	 // Finishing touches
	if instance_number(Floor) >= GenCont.goal{
	     // Place boss room
	    with instance_furthest(10000,10000,Floor)
    	    scrRoomCreate(x,y,"Boss");
    	 // Destroy overlapping rooms:
        	with instances_matching(Rooms,"important",true){
        	     // Destroy chests overlapping important rooms:
        	    with(chestprop) if place_meeting(x,y,other)
        	        instance_delete(id);
        	     // Destroy unimportant rooms overlapping important rooms:
        	    with instances_matching(Rooms,"important",false) 
        	        if instance_exists(other) && place_meeting(x,y,other) 
        	            instance_delete(id);
        	}
        	 // Destroy unimportant rooms overlapping unimportant rooms:
        	with instances_matching(Rooms,"important",false) 
        	    with instances_matching(Rooms,"important",false) 
        	        if instance_exists(other) && place_meeting(x,y,other) 
        	            instance_delete(id);
         // Destroy catholes inside rooms:
        with(Rooms)
            with instances_matching(CustomObject,"name","Cathole") if place_meeting(x,y,other)
                instance_delete(id);
         // Mark floors according to their rooms
        with(Floor) roomtype = 0;
        with(Rooms)
            with(Floor) if place_meeting(x,y,other) roomtype = other.type;
                
	     // Make new floors
	    for (var i = 0; i < array_length_1d(Rooms); i++){
	        var r = Rooms[i];
	        scrFloorFill(r.myx,r.myy,r.image_xscale,r.image_yscale);
	    }
	     // Floor spirtes:
	    with instances_matching_ne(Floor,"roomtype",false){
	        sprite_index = sprFloor2;
	    }
	     // Populate Rooms:
	    with(Rooms)
            scrRoomPop(self);
	     // Destroy floormakers
	    with(FloorMaker) instance_delete(id);
	}
	
#define scrRoomCreate(_x,_y,_type)
    var o = 32;
    with instance_create(_x,_y,CustomObject){
        name = "RoomGen";
        type = _type;
        important = false;
        myx = x;
        myy = y;
        depth = -10;
        mask_index = mskFloor;
        on_draw = script_ref_create(RoomGen_draw);
        switch(_type){
            case "Default":
                image_xscale = irandom_range(3,6); // width
                image_yscale = 9-image_xscale; // height
                
                break;
            case "Exit":
                image_xscale = 3;
                image_yscale = 3;
                
                important = true;
                
                break
            case "Boss":
                image_xscale = 6;
                image_yscale = 6;

                important = true;
                
                break;
                
            case "Light":
                image_xscale = 2;
                image_yscale = 2;
                
                break;
        }
         // Weird fix for a problem i don't understand
        var xo, yo;
        if !(image_xscale mod 2) xo = o;
        if !(image_yscale mod 2) yo = o;
         // Center on origin:
        x -= floor(image_xscale / 2)*o - xo;
        y -= floor(image_yscale / 2)*o - yo;
    }
    
#define scrRoomPop(_room)
    var o = 32;
    with(_room){
         // setup variables
        var _allfloors = instances_matching_ne(Floor,"object_index",FloorExplo),
            _roomfloors = [],
            _numfloors = 0;
        for (var i = 0; i < array_length_1d(_allfloors); i++)
            with (_allfloors[i]) if place_meeting(x,y,other)
                array_push(_roomfloors,self);
        _numfloors = array_length_1d(_roomfloors)-1;
        
        // var c = make_color_hsv(irandom(255),255,255);
        //     with(_roomfloors) image_blend = c;
        
         // populate rooms
        switch(type){
            case "Default":
                
                break;
            case "Exit":
                with obj_create(myx,myy,"Manhole") sprite_index = spr.PizzaManhole;
                for (var xx = 1; xx <= 4; xx += 3)
                    for (var yy = 1; yy <= 4; yy += 3){
                        instance_create(x+xx*16,y+yy*16,Wall);
                        instance_create(x+xx*16,y+yy*16,NOWALLSHEREPLEASE);
                    }
                
                break;
            case "Boss":
                obj_create(myx,myy,"CatholeBig");
                
                break;
                
            case "Light":
                obj_create(myx, myy, "CatLight");
                scrFloorFill(myx, myy, image_xscale, image_yscale);
            
                break;
        }
    }
    
#define RoomGen_draw // debug purposes
    var c = (important ? c_red : c_green),
        o = 32;
    draw_rectangle_color(x,y,x+o,y+o,c,c,c,c,true);
        c = c_blue;
    draw_rectangle_color(myx,myy,myx+o,myy+o,c,c,c,c,true);
    //draw_rectangle_color(x,y,x+image_xscale*o,y+image_yscale*o,c,c,c,c,true);
        
#define scrFloorMake(_x,_y,_obj)
    return mod_script_call("mod","ntte","scrFloorMake",_x,_y,_obj);
    
#define scrFloorFill(_x,_y,_w,_h)
    return mod_script_call("mod","ntte","scrFloorFill",_x,_y,_w,_h);
    
#define scrFloorFillRound(_x,_y,_w,_h)
    return mod_script_call("mod","ntte","scrFloorFillRound",_x,_y,_w,_h);
    
#define area_finish
    lastarea = area;

     // Area End:
    if(subarea >= 1) && false{
        area = 3;
        subarea = 1;
    }

     // Next Subarea: 
    else subarea++;
    
#define area_pop_enemies
    var _x = x + 16,
        _y = y + 16;
    
#define area_pop_props
    if random(20) < 1{
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

#define obj_create(_x,_y,_obj)
    return mod_script_call("mod","telib","obj_create",_x,_y,_obj);
    
#define nearest_instance(_x,_y,_instance)
    return mod_script_call("mod","telib","nearest_instance",_x,_y,_instance);
    
#define orandom(_n)
    return irandom_range(-_n,_n);
    
    