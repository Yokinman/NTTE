#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    
     // Surface
    global.resetSurf = true;
     
    global.surfW = 2000;
    global.surfH = 2000;
    global.surf = noone;
    
#macro debug false
    
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus

#macro Rooms instances_matching(CustomObject,"name","RoomGen")

#macro roomTypes choose("Table", "Dining", "Office", "Couch", "Lounge")

#macro bgrColor area_get_background_color(102)
#macro shdColor area_get_shadow_color(2)

#define area_music      return mus2;
#define area_ambience   return amb102;
#define area_secret     return true;

#define area_name(_subarea, _loop)
    return "2-?";

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
    maxrooms = 8;
    safespawn = 0; // why does this shift everything around ?? its so the spawn stays at 10016,10016 - that's stupid i hate it

    background_color = bgrColor;
    BackCont.shadcol = shdColor;
    TopCont.darkness = true;

#define area_start
     // Fix B Floors:
    with(instances_matching(Floor, "styleb", true)) depth = 8;
    
     // Bind scripts:
    if !array_length_1d(instances_matching(CustomDraw,"name","draw_rugs"))
        with script_bind_draw(draw_rugs,7){
            name = "draw_rugs";
        }
        
#define draw_rugs
    if !instance_exists(GenCont){

    var _x = 10000 - global.surfW / 2,
        _y = 10000 - global.surfH / 2,
        o = 32;

     // Reset surfaces:
    if(global.resetSurf){
        if(surface_exists(global.surf)){
            surface_set_target(global.surf);
            draw_clear_alpha(0, 0);
            surface_reset_target();
            surface_free(global.surf);
        }
        global.resetSurf = false;
        exit;
    }
    
     // Create surface:
    if !surface_exists(global.surf){
        global.surf = surface_create(global.surfW,global.surfH);
        surface_set_target(global.surf);
        
            with instances_matching(Rooms,"carpeted",true){
                var _s = spr.Rug,
                    _i = 8,
                    _c = [
                        choose(make_color_rgb(77, 49, 49), make_color_rgb(46, 56, 41)),
                        choose(make_color_rgb(160, 75, 99), make_color_rgb(214, 134, 5))];
                for (var n = 0; n <= 1; n++){
                    d3d_set_fog(true,_c[n],0,0)
                    for (var xx = 0; xx < image_xscale; xx++)
                        for (var yy = 0; yy < image_yscale; yy++){
                            if !xx _i = 4;
                            if xx == image_xscale - 1 _i = 0; 
                            if !yy{
                                _i = 2;
                                if !xx _i = 3;
                                if xx == image_xscale - 1 _i = 1;
                            }
                            if yy == image_yscale - 1{
                                _i = 6;
                                if !xx _i = 5;
                                if xx == image_xscale - 1 _i = 7;
                            }
                            if (yy && yy != image_yscale - 1) && (xx && xx != image_xscale - 1) _i = 8;
                            
                            draw_sprite(_s[n],_i,x-_x+xx*o,y-_y+yy*o);
                        }
                }
                    
            }
            d3d_set_fog(false,c_white,0,0);
    }

    surface_reset_target();
    draw_surface(global.surf,_x,_y);
    
    }

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
	
     // Start room:
    if !array_length_1d(instances_matching(Rooms,"type","Start"))
        scrRoomCreate(10000,10000,"Start");
	
	 // Special - Rooms:
	if random(5) < 1 //&& variable_instance_exists(GenCont, "maxrooms") && array_length_1d(Rooms) < GenCont.maxrooms
	    scrRoomCreate(_x,_y, roomTypes); //choose("Default", "Light"));
	    
	 // Spawn cathole:
    if random(7) < 1
        obj_create(_x+16,_y+16,"Cathole");

     // Turn:
    var _trn = 0;
    if(random(4) < 1){
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
	     // Destroy floormakers
	    with(FloorMaker) instance_delete(id);
	}
	
#define scrRoomCreate(_x,_y,_type)
    var o = 32;
    with instance_create(_x,_y,CustomObject){
        name = "RoomGen";
        type = _type;
        carpeted = false;
        important = false;
        myx = x;
        myy = y;
        depth = -10;
        mask_index = mskFloor;
        if debug on_draw = script_ref_create(RoomGen_draw);
        switch(_type){
             // IMPORTANT ROOMS
             
            case "Start": scrRoomVars(3, 3, true, true);
                break;
                
            case "Boss": scrRoomVars(6, 6, true, false);
                break;
                
             // SMALL ROOMS
                
            case "Table": scrRoomVars(3, 3, false, (random(5) < 2));
                break;
                
            case "Couch": scrRoomVars(3, 2, false, true);
                break;
             
             // LARGE ROOMS
             
            case "Dining": scrRoomVars(4, 3, false, (random(3) < 1));
                break;
            
            case "Office": scrRoomVars(3, 4, false, false);
                break;
                
            case "Lounge": scrRoomVars(4,4,false,false);
                break;
                
                
             // DEFAULT RANDOM ROOM
                
            default:
                scrRoomVars(irandom_range(3,6), irandom_range(3,6), false, (random(4) < 1));
                type = "Default";
        }
         // Weird fix for a problem i don't understand
        var xo, yo;
        if !(image_xscale mod 2) xo = o;
        if !(image_yscale mod 2) yo = o;
         // Center on origin:
        x -= floor(image_xscale / 2)*o - xo;
        y -= floor(image_yscale / 2)*o - yo;
    }
    
#define scrRoomVars(_w,_h,_important,_carpeted)
    image_xscale = _w;
    image_yscale = _h;
    important = _important;
    carpeted = _carpeted;
    
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
        
        with(Wall) if place_meeting(x,y,other) instance_delete(id);
         // populate rooms
        switch(type){
             // IMPORTANT ROOMS
             
            case "Boss":
                 // Spawn boss spawner
                obj_create(myx,myy,"CatholeBig");
                
                 // delete this later
                obj_create(myx+32,myy+32,"Cat");
                
                 // Create walls
                for (var xx = 1; xx <= 10; xx += 9)
                    for (var yy = 1; yy <= 10; yy += 9)
                        instance_create(x+xx*16,y+yy*16,Wall);
                        
                 // Spawn backup chests
                var _chest = [RadChest,AmmoChest,WeaponChest],
                    _d = irandom(3);
                for (var _i = 0; _i <= 2; _i++)
                    if !instance_exists(_chest[_i]) instance_create(myx+lengthdir_x(80,(_i+_d)*90)+32,myy+lengthdir_y(80,(_i+_d)*90)+32,_chest[_i]);
                
            break;
             
             // SMALL ROOMS
            
            case "Table":
                with obj_create(myx+16,myy+16,"NewTable"){
                    if random(5) < 4
                        obj_create(x+orandom(2),y-18+orandom(2),"ChairFront");
                    obj_create(x,y-32,"CatLight");
                }
                
            break;
            
            case "Couch":
                obj_create(myx+16,myy+16,"Couch");
                if random(5) < 2
                    instance_create(x+orandom(24), y+irandom(16), PizzaBox);
                
            break;
                
             // LARGE ROOMS
            
            case "Dining":
                with obj_create(myx+32,myy+16,"NewTable"){
                    for (var _r = -1; _r <= 1; _r += 2){
                        with obj_create(x+24*_r,y+orandom(2),"ChairSide") image_xscale = _r;
                        obj_create(x+12*_r,y-18+orandom(2),"ChairFront");
                    }
                    obj_create(x,y-32,"CatLight")
                }
                
            break;
             
            case "Office":
                for (var xx = 0; xx <= 1; xx++)
                    for (var yy = 0; yy <= 2; yy++){
                        if random(4) < 3{
                            with obj_create(x+32+xx*o+orandom(2),y+32+yy*o+orandom(2),"NewTable")
                                obj_create(x+orandom(2),y-18+orandom(2),choose("ChairFront,ChairFront,ChairSide"));
                        }
                        else obj_create(x+32+xx*o+orandom(2),y+32+yy*o+orandom(2),"Cabinet");
                    }
            
            break;
            
            case "Lounge":
                with obj_create(myx+32,myy,"Couch"){
                    with obj_create(x+orandom(2),y+16+orandom(2),"NewTable"){
                        obj_create(x,y-32,"CatLight");
                        for (var _r = -1; _r <= 1; _r += 2) if random(3) < 2
                            with obj_create(x+24*_r,y+orandom(2),"ChairSide") image_xscale = _r;
                    }
                    instance_create(x+orandom(16), y+orandom(16), PizzaBox);
                }
            
            break;
             
        }
    }
    
#define RoomGen_draw // debug purposes
    var c = (important ? c_red : c_green),
        o = 32;
    draw_rectangle_color(x,y,x+o,y+o,c,c,c,c,true);
    draw_text_nt(x + 35, y, type);
        c = c_blue;
    draw_rectangle_color(myx,myy,myx+o,myy+o,c,c,c,c,true);
        
#define scrFloorMake(_x,_y,_obj)
    return mod_script_call("mod","ntte","scrFloorMake",_x,_y,_obj);
    
#define scrFloorFill(_x,_y,_w,_h)
    return mod_script_call("mod","ntte","scrFloorFill",_x,_y,_w,_h);
    
#define scrFloorFillRound(_x,_y,_w,_h)
    return mod_script_call("mod","ntte","scrFloorFillRound",_x,_y,_w,_h);
    
#define area_finish
    global.resetSurf = true;
    
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
    if random(10) < 1{
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

#define area_pop_extras
     // Populate Rooms:
    with(Rooms)
        scrRoomPop(self);
        
     // Light up specific things:
    with instances_matching(GameObject,"object_index",AmmoChest,AmmoChestMystery,RadChest,WeaponChest,BigWeaponChest) obj_create(x,y-32,"CatLight");
    obj_create(10016,10016-32,"CatLight");

#define obj_create(_x,_y,_obj)
    return mod_script_call("mod","telib","obj_create",_x,_y,_obj);
    
#define nearest_instance(_x,_y,_instance)
    return mod_script_call("mod","telib","nearest_instance",_x,_y,_instance);
    
#define orandom(_n)
    return irandom_range(-_n,_n);
    
    