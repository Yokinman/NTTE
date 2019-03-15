#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.save = mod_variable_get("mod", "teassets", "save");

     // Sprites:
    with(spr){
         // Floors:
        FloorLair =         sprite_add("../sprites/areas/Lair/sprFloorLair.png",           4, 0,  0);
        FloorLairB =        sprite_add("../sprites/areas/Lair/sprFloorLairB.png",          8, 0,  0);
        FloorLairExplo =    sprite_add("../sprites/areas/Lair/sprFloorLairExplo.png",      4, 1,  1);

         // Walls:
        WallLairBot =       sprite_add("../sprites/areas/Lair/sprWallLairBot.png",         4, 0,  0);
        WallLairOut =       sprite_add("../sprites/areas/Lair/sprWallLairOut.png",         5, 4, 12);
        WallLairTop =       sprite_add("../sprites/areas/Lair/sprWallLairTop.png",         4, 0,  0);
        WallLairTrans =     sprite_add("../sprites/areas/Lair/sprWallLairTrans.png",       1, 0,  0);

         // Misc:
        DebrisLair =        sprite_add("../sprites/areas/Lair/sprDebrisLair.png",          4, 4,  4);
        TopDecalLair =      sprite_add("../sprites/areas/Lair/sprTopDecalLair.png",        2, 0,  0);
    }

     // Carpet Surface:
    global.resetSurf = true;
    global.surfW = 2000;
    global.surfH = 2000;
    global.surf = noone;

     // Rooms:
    var L = true;
    global.room_center = [10000, 10000];
    global.room_list = [];
    global.room_type = {
         // SPECIAL:
        "Start" : {
            w : 3,
            h : 3,
            carpet : 1.00,
            special : true
        },
        "Boss" : {
            w : 10,
            h : 10,
            special : true,
            layout : [
                [0,0,0,L,L,L,L,0,0,0],
                [0,0,0,L,L,L,L,0,0,0],
                [0,0,L,L,L,L,L,L,0,0],
                [L,L,L,L,L,L,L,L,L,L],
                [L,L,L,L,L,L,L,L,L,L],
                [L,L,L,L,L,L,L,L,L,L],
                [L,L,L,L,L,L,L,L,L,L],
                [0,0,L,L,L,L,L,L,0,0],
                [0,0,0,L,L,L,L,0,0,0],
                [0,0,0,L,L,L,L,0,0,0]
                ]
        },

         // SMALL:
        "SmallClutter" : {
            w : 2,
            h : 2
        },
        
        "MediumClutter" : {
            w : 3,
            h : 3
        },
        
        "SmallPillars" : {
            w : 3,
            h : 3
        },  
        
        "SmallRing" : {
            w : 2,
            h : 2
        },
        
        "WideSmallRing" : {
            w : 3,
            h : 2
        },
        
        "TallSmallRing" : {
            w : 2,
            h : 3
        },
        
        "MediumRing" : {
            w : 3,
            h : 3,
            layout : [
                [L,L,L],
                [L,0,L],
                [L,L,L]
                ]
        },
        
        "Table" : {
            w : 3,
            h : 3
            // carpet : 0.40
        },
        
        "Toilet" : {
            w : 3,
            h : 2,
        },
        
        "SmallTriangle" : {
            h : 3,
            w : 3,
            layout : [
                [L,0,0],
                [L,L,0],
                [L,L,L]
                ]
        },

         // LARGE:
        "SmallAtrium" : {
            w : 6,
            h : 6,
            layout : [
                [0,0,L,L,0,0],
                [0,0,L,L,0,0],
                [L,L,L,L,L,L],
                [L,L,L,L,L,L],
                [0,0,L,L,0,0],
                [0,0,L,L,0,0]
                ]
        },
        
        "Lounge" : {
            w : 5,
            h : 4,
            layout : [
                [L,L,L,L,L],
                [L,L,L,L,L],
                [L,L,L,L,L],
                [L,0,0,0,L]
                ]
        },
         
        "Dining" : {
            w : 4,
            h : 3,
            carpet : 0.33
        },
        
        "Cafeteria" : {
            w : 4,
            h : 6,
            layout : [
                [0,L,0,0],
                [L,L,L,L],
                [L,L,L,L],
                [L,L,L,L],
                [L,L,L,L],
                [L,L,L,L]
                ]
        },

        "Office" : {
            w : 6,
            h : 4,
            layout : [
                [0,0,L,L,0,0],
                [L,L,L,L,L,L],
                [L,L,L,L,L,L],
                [L,L,L,L,L,L]
                ]
        },
        
        "Garage" : {
            w : 4,
            h : 3
        },
        
        "LargeRing" : {
            w : 6,
            h : 6,
            layout : [
                [L,L,L,L,L,L],
                [L,L,L,L,L,L],
                [L,L,0,0,L,L],
                [L,L,0,0,L,L],
                [L,L,L,L,L,L],
                [L,L,L,L,L,L]
                ]
        }

    };

     // Set Defaults:
    for(var i = 0; i < lq_size(RoomType); i++){
        var t = lq_get_value(RoomType, i),
            _default = { w : 1, h : 1, carpet : 0, special : 0 };

        for(var j = 0; j < lq_size(_default); j++){
            var k = lq_get_key(_default, j);
            if(k not in t){
                lq_set(t, k, lq_get(_default, k));
            }
        }
    }

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.save
#macro opt sav.option

#macro current_frame_active ((current_frame mod 1) < current_time_scale)

#macro RoomDebug false
#macro RoomList global.room_list
#macro RoomType global.room_type

#define area_subarea            return 1;
#define area_next               return 3;
#define area_music              return mus2;
#define area_ambience           return amb102;
#define area_background_color   return make_color_rgb(160, 157, 75);
#define area_shadow_color       return area_get_shadow_color(102);
#define area_darkness           return true;
#define area_secret             return true;

#define area_name(_subarea, _loop)
    return "2-?";

#define area_mapdata(_lastx, _lasty, _lastarea, _lastsubarea, _subarea, _loops)
    return [_lastx, 9];

#define area_sprite(_spr)
    switch(_spr){
         // Floors:
        case sprFloor1      : return spr.FloorLair;
        case sprFloor1B     : return spr.FloorLairB;
        case sprFloor1Explo : return spr.FloorLairExplo;

         // Walls:
        case sprWall1Trans  : return spr.WallLairTrans;
        case sprWall1Bot    : return spr.WallLairBot;
        case sprWall1Out    : return spr.WallLairOut;
        case sprWall1Top    : return spr.WallLairTop;

         // Misc:
        case sprDebris1     : return spr.DebrisLair;
        case sprDetail1     : return sprDetail2;
    }

#define area_setup
    goal = 110;
    safespawn = false;

    background_color = area_background_color();
    BackCont.shadcol = area_shadow_color();
    TopCont.darkness = area_darkness();

    RoomList = [];

    if(RoomDebug) script_bind_draw(RoomDebug_draw, 0);

#define area_setup_floor(_explo)
    if(!_explo){
         // Fix Depth:
        if(styleb) depth = 8;

         // Footsteps:
        material = (styleb ? 6 : 2);
    }

#define area_start
     // Bind scripts:
    if(array_length(instances_matching(CustomDraw, "name", "draw_rugs")) <= 0){
        with(script_bind_draw(draw_rugs, 7)) name = script[2];
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
    }

     // Next Subarea: 
    else subarea++;

#define area_transit
    global.resetSurf = true;
    if(RoomDebug) GameCont.area = mod_current;

#define area_effect(_vx, _vy)
    var _x = _vx + random(game_width),
        _y = _vy + random(game_height);

     // Drips:
    var f = instance_nearest(_x, _y, Floor);
    with(f) instance_create(x + random(32), y + random(32), Drip);

    return 30 + random(20);

#define area_make_floor
    var _x = GenCont.spawn_x - 16,
        _y = GenCont.spawn_y - 16;

    global.room_center = [_x, _y];

     // Spawn Rooms:
    if(array_length(RoomList) < 4){
        var k = "";
        do k = lq_get_key(RoomType, irandom(lq_size(RoomType) - 1));
        until (lq_get(RoomType, k).special == false);
        room_create(irandom_range(-1, 1), irandom_range(-1, 1), k);
    }

     // Build Rooms:
    else{
        var _done = true;

         // Push Rooms Apart:
        with(RoomList){
            var _x1 = x - 1,
                _y1 = y - 1,
                _x2 = _x1 + (w + 2),
                _y2 = _y1 + (h + 2);

            with(RoomList) if(self != other){
                if(rectangle_in_rectangle(x, y, x + w, y + h, _x1, _y1, _x2, _y2)){
                    if(type != "Start"){
                        var _dir = round(point_direction(other.x + (other.w / 2), other.y + (other.h / 2), x + (w / 2), y + (h / 2)) / 90) * 90;
                        if(random(2) < 1){
                            _dir += choose(-90, -90, 90, 90, 180);
                        }

                        x += lengthdir_x(1, _dir);
                        y += lengthdir_y(1, _dir);
                    }

                    _done = false;
                }
            }
        }
        
         // Special Rooms:
        if(_done){
            var _boss = false,
                _strt = false;

            with(RoomList){
                if(type == "Boss") _boss = true;
                else if(type == "Start") _strt = true;
            }

             // Starting Room:
            if(!_strt){
                var _maxY = 0;
                with(RoomList) if(y > _maxY) _maxY = y + floor(h / 2);
                with(RoomList) y -= _maxY;

                room_create(-1, -1, "Start");

                _done = false;
            }

             // Boss Room:
            else if(!_boss){
                var _maxDis = -1,
                    _furthest = noone;

                with(RoomList){
                    var _dis = point_distance(0, 0, x + (w / 2), y + (h / 2));
                    if(_dis > _maxDis){
                        _furthest = self;
                        _maxDis = _dis;
                    }
                }

                with(_furthest){
                    room_create(x + sign(x), y + sign(y), "Boss");
                }

                _done = false;
            }
        }

        if(_done){
             // Determine Hallway Connections:
            for(var i = 0; i <= 1; i++){
                with(RoomList) if(!is_object(link)){
                    var _minDis = 10000;
                    with(RoomList) if(self != other){
                        var _dis = point_distance(x + (w / 2), y + (h / 2), other.x + (other.w / 2), other.y + (other.h / 2));
                        if(_dis < _minDis && (!is_object(link) || i)){
                            other.link = self;
                            _minDis = _dis;
                        }
                    }
                    with(link) if(link == other) link = noone;
                }
            }

            if(!RoomDebug || button_pressed(0, "east")){
                 // Make Rooms:
                var o = 32;
                styleb = false;
                with(RoomList){
                    for(var _fy = 0; _fy < array_length(layout); _fy++){
                        var l = layout[_fy];
                        for(var _fx = 0; _fx < array_length(l); _fx++){
                            if(l[_fx]){
                                array_push(floors, instance_create(_x + ((x + _fx) * o), _y + ((y + _fy) * o), Floor));
                            }
                        }
                    }
                }
    
                 // Make Hallways:
                styleb = true;
                with(RoomList) with(link){
                    var _fx = x + floor(w / 2),
                        _fy = y + floor(h / 2),
                        _tx = other.x + floor(other.w / 2),
                        _ty = other.y + floor(other.h / 2),
                        _dir = round(point_direction(_fx, _fy, _tx, _ty) / 90) * 90,
                        _tries = 100;

                    while(_tries-- > 0){
                        instance_create(_x + (_fx * o), _y + (_fy * o), Floor);

                         // Turn Corner:
                        if(_fx == _tx || _fy == _ty) _dir = point_direction(_fx, _fy, _tx, _ty);
    
                         // End Hallway & Spawn Door:
                        for(var a = _dir; a < _dir + 360; a += 90){
                            var _dx = _fx - other.x + lengthdir_x(1, a),
                                _dy = _fy - other.y + lengthdir_y(1, a);
        
                            if(point_in_rectangle(_dx, _dy, 0, 0, other.w - 1, other.h - 1)){
                                if(other.layout[_dy, _dx]){
                                    _fx = _x + 16 + (_fx * o) + lengthdir_x(16 - 2, a);
                                    _fy = _y + 16 + (_fy * o) + lengthdir_y(16 - 2, a) + 1;
                                    var p = noone;
                                    for(var _side = -1; _side <= 1; _side += 2){
                                        with(obj_create(_fx + lengthdir_x(16 * _side, a - 90), _fy + lengthdir_y(16 * _side, a - 90), "CatDoor")){
                                            image_angle = a;
                                            image_yscale = -_side;

                                             // Link Doors:
                                            partner = p;
                                            with(partner) partner = other;
                                            p = id;
                                        }
                                    }
                                    _tries = 0;
                                    break;
                                }
                            }
                        }
    
                        _fx += lengthdir_x(1, _dir);
                        _fy += lengthdir_y(1, _dir);
                        if(_fx == _tx && _fy == _ty) break;
                    }
                }
    
                 // End Level Gen:
                with(FloorMaker) instance_destroy();
            }

            else if(RoomDebug && button_pressed(0, "west")) RoomList = [];
        }
    }

#define area_pop_enemies
    var _x = x + 16,
        _y = y + 16;

     // Rat packs:
    if(!place_meeting(x, y, Wall) && random(20) < 1){
        repeat(irandom_range(3, 7)) instance_create(_x, _y, Rat);
    }

     // Cats:
    if(random(10) < 1){
        with(obj_create(_x, _y, "Cat")){
             // Spawn Underground:
            if(random(2) < 1){
                active = false;
                cantravel = true;
                alarm1 = random_range(30, 900);
            }
        }
    }

#define area_pop_extras
     // Populate Rooms:
    with(RoomList){
        room_pop();

    	 // Cat Spawners:
        with(floors) if(instance_exists(self)){
            if(!place_meeting(x, y, Wall) && !place_meeting(x, y, prop)){
                if(
                    random(16) < 1 ||
                    (
                        random(2) < 1 &&
                        array_length(instance_rectangle(x - 96, y - 96, x + 96, y + 96, instances_matching(CustomObject, "name", "CatHole"))) <= 0
                    )
                ){
                    obj_create(x + 16, y + 16, "CatHole");
                }
            }
        }
    }

     // Important Door Stuff:
    with(instances_matching(CustomHitme, "name", "CatDoor")){
         // Remove Blocking Walls:
        var a = image_angle - (90 * image_yscale),
            _x = floor((x + lengthdir_x(8, a) + lengthdir_x(16, image_angle)) / 16) * 16,
            _y = floor((y + lengthdir_y(8, a) + lengthdir_y(16, image_angle)) / 16) * 16;

        if(position_meeting(_x, _y, Wall)){
            with(instance_nearest(_x, _y, Wall)) instance_destroy();
        }

         // Make sure door isn't placed weirdly:
        var _x = (floor((x + 16 + lengthdir_x(8, a)) / 32) * 32) - 16,
            _y = (floor((y + 16 + lengthdir_y(8, a)) / 32) * 32) - 16;

        for(var i = 0; i <= 180; i += 180){
            if(position_meeting(_x + lengthdir_x(32, image_angle - 90 + i), _y + lengthdir_y(32, image_angle - 90 + i), Floor)){
                instance_delete(id);
                break;
            }
        }
    }

     // Delete stuck dudes:
    with(enemy) if place_meeting(x, y, Wall){
        instance_delete(id);
    }
        
     // Light up specific things:
    with(instances_matching([chestprop, RadChest], "", null)) obj_create(x, y - 32, "CatLight");
    //obj_create(spawn_x, spawn_y - 32, "CatLight");


/// Rooms
#define room_create(_x, _y, _type)
    with({}){
        x = _x;
        y = _y;
        type = _type;
        link = noone;
        floors = [];

         // Grab Room Vars:
        if(lq_exists(RoomType, type)){
            var t = lq_get(RoomType, type);
            for(var i = 0; i < lq_size(t); i++){
                var k = lq_get_key(t, i);
                lq_set(self, k, lq_get(t, k));
            }
        }

         // Randomize Room:
        else{
            w = irandom_range(3, 6);
            h = irandom_range(3, 6);
            carpet = 1/4;
            special = false;
        }

         // Carpet Chance:
        if(random(1) < carpet) carpeted = true;
        else carpeted = false;

         // Floor Layout:
        if("layout" not in self){
            layout = [];
            for(var _fy = 0; _fy < h; _fy++){
                for(var _fx = 0; _fx < w; _fx++){
                    layout[_fy, _fx] = true;
                }
            }
        }

        array_push(RoomList, self);
        return self;
    }

#define create_enemies(_x, _y, _num)
    var _e = choose("Cat", "Bat");
    repeat(_num + round(random_range(1.5, 2) * GameCont.loops)) obj_create(_x, _y, _e);

#define room_pop
    var o = 32,
        _x = global.room_center[0] + (x * o), // Left
        _y = global.room_center[1] + (y * o), // Top
        _cx = _x + (w/2 * o), // Center X
        _cy = _y + (h/2 * o); // Center Y

    switch(type){
         // IMPORTANT ROOMS
        case "Boss" : {
             // Spawn boss spawner
            with obj_create(_cx - 32, _cy - 32, "CatHoleBig"){
                with obj_create(x + o + orandom(2), y + o - 32 + orandom(2), "NewTable")
                    obj_create(x + orandom(2), y - 16 + orandom(2), choose("ChairFront","ChairFront","ChairSide"));
            }

             // delete this later
            obj_create(_cx, _cy, "CatBoss");
            obj_create(_cx, _cy, "BatBoss");

             // Corner Columns:
            instance_create(_x + 80,           _y + 80,           Wall);
            instance_create(_x + (w * o) - 96, _y + 80,           Wall);
            instance_create(_x + 80,           _y + (h * o) - 96, Wall);
            instance_create(_x + (w * o) - 96, _y + (h * o) - 96, Wall);

             // Spawn backup chests
            var _chest = [RadChest,AmmoChest,WeaponChest],
                _d = irandom(3);
            for (var _i = 0; _i <= 2; _i++)
                if !instance_exists(_chest[_i]) instance_create(_cx + lengthdir_x(144,(_i+_d)*90), _cy + lengthdir_y(144,(_i+_d)*90),_chest[_i]);

            break;
        }
         
         // SMALL ROOMS
        case "SmallClutter" : {
             // Props:
            repeat(irandom_range(2, 4)){
                var _prop = choose("ChairFront", "ChairSide", "Table", "Cabinet"),
                    _px = _cx + orandom(24),
                    _py = _cy + orandom(24);
                if is_string(_prop) obj_create(_px, _py, _prop);
                else instance_create(_px, _py, _prop);
            }
             // Enemies:
            create_enemies(_cx, _cy, irandom(3));
            
            break;
        }
            
        case "MediumClutter" : {
             // Props:
            repeat(irandom_range(2, 6)){
                var _prop = choose("ChairFront", "ChairSide", "Table", "Cabinet"),
                    _px = _cx + orandom(32),
                    _py = _cy + orandom(32);
                if is_string(_prop) obj_create(_px, _py, _prop);
                else instance_create(_px, _py, _prop);
            }
             // Enemies:
            create_enemies(_cx, _cy, irandom(5));
            
            break;
        }
        
        case "SmallPillars" : {
             // Walls:
            instance_create(_x + 16,            _y + 16,            Wall);
            instance_create(_x + 64,            _y + 16,            Wall);
            instance_create(_x + 16,            _y + 64,            Wall);
            instance_create(_x + 64,            _y + 64,            Wall);
             // Enemies:
            create_enemies(_cx, _cy, 1);
            
            break;
        }
            
        case "SmallRing" : {
             // Walls:
            for (var xx = 1; xx <= 2; xx++)
                for (var yy = 1; yy <= 2; yy++)
                    with instance_create(_x + xx * 16, _y + yy * 16, Wall)
                        instance_create(x, y, NOWALLSHEREPLEASE);
            break;
        }
            
        case "WideSmallRing" : {
             // Walls:
            for (var xx = 2; xx <= 3; xx++)
                for (var yy = 1; yy <= 2; yy++)
                    with instance_create(_x + xx * 16, _y + yy * 16, Wall)
                        instance_create(x, y, NOWALLSHEREPLEASE);
            break;
        }
            
        case "TallSmallRing" : {
             // Walls:
            for (var xx = 1; xx <= 2; xx++)
                for (var yy = 2; yy <= 3; yy++)
                    with instance_create(_x + xx * 16, _y + yy * 16, Wall)
                        instance_create(x, y, NOWALLSHEREPLEASE);
            break;
        }
            
        case "MediumRing" : {
            for (var xx = 2; xx <= 3; xx++)
                for (var yy = 2; yy <= 3; yy++)
                    with instance_create(_x + xx * 16, _y + yy * 16, Wall)
                        instance_create(x, y, NOWALLSHEREPLEASE);
            break;
        }
         
        case "Table" : {
            with(obj_create(_cx, _cy,"NewTable")){
                if(random(5) < 4){
                    obj_create(x + orandom(2), y - 18 + orandom(2), "ChairFront");
                }
                obj_create(x, y-32, "CatLight");
            }
             // Enemies:
            create_enemies(_cx, _cy, 1 + irandom(2));
            
            break;
        }
        
        case "Toilet" : {
             // Walls:
            for (var yy = 0; yy <= 1; yy++)
                with instance_create(_x + o, _y + yy *16, Wall)
                    instance_create(x, y, NOWALLSHEREPLEASE);
            with instance_create(_x + 80, _y + 3 * 16, Wall)
                instance_create(x, y, NOWALLSHEREPLEASE);
             // Props:
            with obj_create(_x + 16 + orandom(2), _y + 8, "ChairFront")
                obj_create(x, y - o, "CatLight");
             // Enemies:
            create_enemies(_x, _y, 1);
            
            break;
        }
        
        case "SmallTriangle" : {
             // Walls:
            for (i = 1; i <= 5; i += 2)
                with instance_create(_x + i * 16, _y + (i - 1) * 16, Wall)
                    instance_create(x, y, NOWALLSHEREPLEASE);
             // Props:
             // Enemies:
            create_enemies(_cx, _cy, 1 + irandom(1));
            
            break;
        }
            
         // LARGE ROOMS
        case "SmallAtrium" : {
             // Walls:
                 // Horizontal:
                for (var xx = 4; xx <= 7; xx += 3)
                    for (var yy = 3; yy <= 8; yy += 5)
                        with instance_create(_x + xx * 16, _y + yy * 16, Wall)
                            instance_create(x, y, NOWALLSHEREPLEASE);
                 // Vertical:
                for (var xx = 3; xx <= 8; xx += 5)
                    for (var yy = 4; yy <= 7; yy += 3)
                        with instance_create(_x + xx * 16, _y + yy * 16, Wall)
                            instance_create(x, y, NOWALLSHEREPLEASE);
                 // Extras:
                for (var xx = 3; xx <= 8; xx += 5)
                    for (var yy = 3; yy <= 8; yy += 5)
                        with instance_create(_x + xx * 16, _y + yy * 16, Wall)
                            instance_create(x, y, NOWALLSHEREPLEASE);
            for (var xx = 5; xx <= 6; xx++)
                for (var yy = 5; yy <= 6; yy++)
                    with instance_create(_x + xx * 16, _y + yy * 16, Wall){
                        if !place_meeting(x, y, Floor)
                            instance_delete(id);
                        else instance_create(x, y, NOWALLSHEREPLEASE);
                    }
             // Enemies:
            for (var d = 0; d <= 360; d += 90)
                create_enemies(_cx + lengthdir_x(80, d), _cy + lengthdir_y(80, d), 1 + irandom(1));
                
            break;
        }
        
        case "Lounge" : {
             // Walls
            for (var xx = 2; xx <= 7; xx += 5)
                for (var yy = 0; yy <= 5; yy += 5)
                    with instance_create(_x + xx * 16, _y + yy * 16, Wall)
                        instance_create(x, y, NOWALLSHEREPLEASE);
             // Props:
            with obj_create(_cx + orandom(2), _y + 16 + orandom(2), "Couch")
                obj_create(x + orandom(2), y + 20 + orandom(2), "NewTable");
                
             // Enemies:
            create_enemies(_cx, _y + 16, 2);
            
            break;  
        }
        
        case "Dining" : {
            with(obj_create(_cx, _cy, "NewTable")){
                for(var _r = -1; _r <= 1; _r += 2){
                    with(obj_create(x + (24 * _r), y + orandom(2), "ChairSide")) image_xscale = _r;
                    obj_create(x + (12 * _r), y - 18 + orandom(2), "ChairFront");
                }
                obj_create(x, y - 32, "CatLight");
            }
             // Enemies:
            create_enemies(_cx, _cy, 1 + irandom(1));
            
            break;
        }
        
        case "Cafeteria" : {
             // Walls:
            for (var i = 0; i <= 1; i++)
                for (var xx = 0; xx <= 7; xx += 7)
                    for (var yy = 3; yy <= 4; yy++)
                        with instance_create(_x + xx * 16, _y + yy * 16 + i * 96, Wall)
                            instance_create(x, y, NOWALLSHEREPLEASE);
             // Props:
                 // Vending machine:
                with instance_create(_x + 48, _y + 16, SodaMachine){
                    spr_idle = spr.SodaMachineIdle;
                    spr_hurt = spr.SodaMachineHurt;
                    spr_dead = spr.SodaMachineDead;
                    sprite_index = spr_idle;
                }
                 // Tables and chairs:
                for (var i = 0; i <= 2; i++)
                    with obj_create(_cx + orandom(2), _cy - 16 + i * o + orandom(2), "NewTable"){
                         // Chairs:
                        if random(5) < 2 with obj_create(x - 20 + orandom(2), y + orandom(2), "ChairSide") image_xscale = -1;
                        if random(5) < 2 with obj_create(x + 20 + orandom(2), y + orandom(2), "ChairSide") image_xscale = 1;
                        if random(5) < 2 obj_create(x + orandom(2), y - 14 + orandom(2), "ChairFront");
                         // Lights:
                        if random(3) < 2 obj_create(x, y - o, "CatLight");
                    }
             // Enemies:
            create_enemies(_cx, _cy, 3 + irandom(1));
            break;
        }

        case "Office" : {
             // Walls:
            for (var xx = 1; xx <= 10; xx += 9)
                for (var yy = 2; yy <= 7; yy += 5){
                    instance_create(_x + xx * 16, _y + yy * 16, Wall);
                    instance_create(_x + xx * 16, _y + yy * 16, NOWALLSHEREPLEASE);
                }
             // Props:
            with obj_create(_cx + orandom(2), _cy - 38 + orandom(2), "NewTable"){
                obj_create(x + orandom(4), y - 16 + orandom(2), choose("ChairFront","ChairFront","ChairSide"));
            for (var xx = -3; xx <= 3; xx += 6)
                obj_create(_cx + xx * 16, _y + 42 + orandom(2), "Cabinet");
            }
             // Enemies:
            create_enemies(_cx, _cy, 1 + irandom(1));
            
            break;
        }
        
        case "Garage" : {
             // Walls:
            for (var xx = 3; xx <= 4; xx++)
                for (var yy = 0; yy <= 5; yy += 5)
                    with instance_create(_x + xx * 16, _y + yy * 16, Wall)
                        instance_create(x, y, NOWALLSHEREPLEASE);
             // Props:
                 // Cars:
                for (var yy = 0; yy <= 1; yy++)
                    instance_create(_x + o + orandom(2), _y + yy * o + o + orandom(2), Car);
                 // Tires:
                repeat(irandom_range(2, 4))
                    with instance_create(_x + 90 + irandom(28), _y + 10 + irandom(86), Tires)
                        if random(10) < 1{
                            obj_create(x, y, choose("ChairFront","ChairSide"));
                            instance_delete(id);
                        }
             // Lights:
            for (var xx = -1; xx <= 1; xx += 2)
                obj_create(_cx + xx * 40, _cy - o, "CatLight");
            
             // Enemies:
            create_enemies(_cx, _cy, 1);
            
            break;
        }
            
        case "LargeRing" : {
             // Walls:
            for (var xx = -2; xx <= 1; xx += 3)
                for (var yy = -2; yy <= 1; yy += 3)
                    with instance_create(_cx + xx * 16, _cy + yy * 16, Wall){
                        if !place_meeting(x, y, Floor)
                            instance_delete(id);
                        else instance_create(x, y, NOWALLSHEREPLEASE);
                    }
            break;
        }

    }
        
#define draw_rugs
    if(!instance_exists(GenCont)){
        var _surfX = global.room_center[0] - (global.surfW / 2),
            _surfY = global.room_center[1] - (global.surfH / 2),
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
        if(!surface_exists(global.surf)){
            global.surf = surface_create(global.surfW, global.surfH);
            surface_set_target(global.surf);

            with(RoomList) if(carpeted){
                var _s = spr.Rug,
                    _i = 8,
                    _c = [
                        choose(make_color_rgb(77, 49, 49), make_color_rgb(46, 56, 41)),
                        choose(make_color_rgb(160, 75, 99), make_color_rgb(214, 134, 5))];

                for(var n = 0; n < array_length(_s); n++){
                    d3d_set_fog(true, _c[n], 0, 0);
                    for(var xx = 0; xx < w; xx++){
                        for (var yy = 0; yy < h; yy++){
                            if(
                                (yy > 0 && yy < h - 1) &&
                                (xx > 0 && xx < w - 1)
                            ){
                                _i = 8;
                            }
                            else{
                                if(yy <= 0){
                                    if(xx <= 0) _i = 3;
                                    else{
                                        if(xx >= w - 1) _i = 1;
                                        else _i = 2;
                                    }
                                }
                                else if(yy >= h - 1){
                                    if(xx <= 0) _i = 5;
                                    else{
                                        if(xx >= w - 1) _i = 7;
                                        else _i = 6;
                                    }
                                }
                                else{
                                    if(xx <= 0) _i = 4;
                                    else{
                                        if(xx >= w - 1) _i = 0;
                                    }
                                }
                            }
                            
                            with(other){ // cant call draw_sprite in lightweight object, sad
                                draw_sprite(_s[n], _i, global.room_center[0] + ((other.x + xx) * o) - _surfX, global.room_center[1] + ((other.y + yy) * o) - _surfY);
                            }
                        }
                    }
                }
            }

            d3d_set_fog(false, c_white, 0, 0);
        }

        surface_reset_target();
        draw_surface(global.surf, _surfX, _surfY);
    }

#define RoomDebug_draw
    if(instance_exists(GenCont)){
        depth = GenCont.depth - 1;

        draw_set_projection(0);

        draw_set_color(c_black);
        draw_rectangle(0, 0, game_width, game_height, 0);

        var o = 4,
            _x = game_width / 2,
            _y = game_height / 2;

         // Hallways:
        draw_set_color(c_dkgray);
        with(RoomList){
            if(is_object(link)) with(link){
                var _fx = x + floor(w / 2),
                    _fy = y + floor(h / 2),
                    _tx = other.x + floor(other.w / 2),
                    _ty = other.y + floor(other.h / 2),
                    _dir = round(point_direction(_fx, _fy, _tx, _ty) / 90) * 90,
                    _tries = 100;

                while(_tries-- > 0){
                    if(_fx == _tx || _fy == _ty){
                        _dir = point_direction(_fx, _fy, _tx, _ty); // Turn Corner
                    }

                    draw_set_color(c_dkgray);
                    draw_rectangle(_x + (_fx * o), _y + (_fy * o), _x + (_fx * o) + o - 1, _y + (_fy * o) + o - 1, 0);

                     // End Hallway & Spawn Door:
                    for(var a = 0; a < 360; a += 90){
                        var _dx = _fx - other.x + lengthdir_x(1, a),
                            _dy = _fy - other.y + lengthdir_y(1, a);
    
                        if(point_in_rectangle(_dx, _dy, 0, 0, other.w - 1, other.h - 1)){
                            if(other.layout[_dy, _dx]){
                                draw_set_color(c_orange);
                                draw_rectangle(_x + (_fx * o), _y + (_fy * o), _x + (_fx * o) + o - 1, _y + (_fy * o) + o - 1, 0);
                                _tries = 0;
                            }
                        }
                    }

                    _fx += lengthdir_x(1, _dir);
                    _fy += lengthdir_y(1, _dir);
                    if(_fx == _tx && _fy == _ty) break;
                }
                /*var _lx1 = _x + ((x + floor(w / 2)) * o),
                    _ly1 = _y + ((y + floor(h / 2)) * o),
                    _lx2 = _x + ((other.x + floor(other.w / 2)) * o),
                    _ly2 = _y + ((other.y + floor(other.h / 2)) * o),
                    _dir = round(point_direction(_lx1, _ly1, _lx2, _ly2) / 90) * 90,
                    _mx = 0,
                    _my = 0;

                if(_dir == 0 || _dir == 180){
                    _mx = _lx1;
                    _my = _ly2;
                    if(_lx1 > _lx2) _lx1 += o;
                    //draw_set_color((_lx2 < _lx1) ? c_purple : c_blue);
                }
                else{
                    _mx = _lx2;
                    _my = _ly1;
                    if(_ly1 > _ly2) _ly1 += o;
                    //draw_set_color((_ly2 < _ly1) ? c_orange : c_red);
                }

                for(var _fx = min(_lx1, _lx2); _fx < max(_lx1, _lx2); _fx += o){
                    draw_rectangle(_fx, _my, _fx + o - 1, _my + o - 1, 0);
                }
                for(var _fy = min(_ly1, _ly2); _fy < max(_ly1, _ly2); _fy += o){
                    draw_rectangle(_mx, _fy, _mx + o - 1, _fy + o - 1, 0);
                }*/
            }
        }

         // Rooms:
        draw_set_color(c_white);
        with(RoomList){
            draw_set_color(special ? c_purple : c_white);
            for(var _fy = 0; _fy < array_length(layout); _fy++){
                var l = layout[_fy];
                for(var _fx = 0; _fx < array_length(l); _fx++){
                    if(l[_fx]){
                        draw_rectangle(_x + ((x + _fx) * o), _y + ((y + _fy) * o), _x + ((x + _fx) * o) + (o - 1), _y + ((y + _fy) * o) + (o - 1), 0);
                    }
                }
            }
        }

         // Tip:
        draw_set_font(fntChat)
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_text_nt(0, 0, "[A] Reset#[D] Generate Level");

        draw_reset_projection();
    }
    else instance_destroy();


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
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call(   "mod", "telib", "instance_rectangle", _x1, _y1, _x2, _y2, _obj);
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
#define Pet_create(_x, _y, _name)                                                       return  mod_script_call(   "mod", "telib", "Pet_create", _x, _y, _name);
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