#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    
     // Sprites:
    with(spr){
         // Floors:
        FloorLair =         sprite_add("../sprites/areas/Lair/sprFloorLair.png",           8, 0, 0);
        FloorLairB =        sprite_add("../sprites/areas/Lair/sprFloorLairB.png",          2, 0, 0);
        FloorLairExplo =    sprite_add("../sprites/areas/Lair/sprFloorLairExplo.png",      4, 1, 1);
         // Walls:
        WallLairBot =       sprite_add("../sprites/areas/Lair/sprWallLairBot.png",         4, 0, 0);
        WallLairOut =       sprite_add("../sprites/areas/Lair/sprWallLairOut.png",         5, sprite_get_xoffset(sprWall2Out), sprite_get_yoffset(sprWall2Out));
        WallLairTop =       sprite_add("../sprites/areas/Lair/sprWallLairTop.png",         4, 0, 0);
        WallLairTrans =     sprite_add("../sprites/areas/Lair/sprWallLairTrans.png",       1, 0, 0);
         // Misc:
        DebrisLair =        sprite_add("../sprites/areas/Lair/sprDebrisLair.png",          4, 4, 4);
        TopDecalLair =      sprite_add("../sprites/areas/Lair/sprTopDecalLair.png",        2, 0, 0);
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
            w : 6,
            h : 6,
            special : true
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
        },

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

#macro RoomDebug false
#macro RoomList global.room_list
#macro RoomType global.room_type

#macro bgrColor make_color_rgb(160, 157, 75)
#macro shdColor area_get_shadow_color(102)

#define area_music      return mus2;
#define area_ambience   return amb102;
#define area_secret     return true;

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

#define area_transit
    global.resetSurf = true;
    if(RoomDebug) GameCont.area = mod_current;
    
#define area_setup
    goal = 6;
    safespawn = false;
    TopCont.darkness = true;

    background_color = bgrColor;
    BackCont.shadcol = shdColor;

    RoomList = [];

    if(RoomDebug) script_bind_draw(RoomDebug_draw, 0);

#define area_start
     // Fix B Floors:
    with(instances_matching(Floor, "styleb", true)) depth = 8;

     // Bind scripts:
    if(array_length(instances_matching(CustomDraw, "name", "draw_rugs")) <= 0){
        with(script_bind_draw(draw_rugs, 7)) name = script[2];
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
    var _x = GenCont.spawn_x - 16,
        _y = GenCont.spawn_y - 16;

    global.room_center = [_x, _y];

     // Spawn Rooms:
    if(array_length(RoomList) < goal){
        with(Floor) instance_destroy();

         // Create Random Normal Room:
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
                                    for(var _side = -1; _side <= 1; _side += 2){
                                        with(obj_create(_fx + lengthdir_x(16 * _side, a - 90), _fy + lengthdir_y(16 * _side, a - 90), "CatDoor")){
                                            image_angle = a;
                                            image_yscale = -_side;
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
    
    if !place_meeting(x, y, Wall) && random(3) < 2{
        if random(12) < 1{
             // Rat packs:
            repeat(irandom_range(3, 7)) instance_create(_x, _y, Rat);
        }
        else if !styleb{
            if random(8) < 1{
                instance_create(_x, _y, Bandit);
            }
            else obj_create(_x, _y, "Cat");
        }
    }

#define area_pop_props
    var _x = x + 16,
        _y = y + 16;

#define area_pop_extras
     // Populate Rooms:
    with(RoomList){
        room_pop();

    	 // Cat Spawners:
        with(floors) if(instance_exists(self)){
            if(!place_meeting(x, y, Wall) && !place_meeting(x, y, prop)){
                if(random(10) < 1){
                    obj_create(x + 16, y + 16, "Cathole");
                }
            }
        }
    }

     // Important Door Stuff:
    with(instances_matching(CustomHitme, "name", "CatDoor")){
         // Remove Blocking Walls:
        var _x = floor((x + lengthdir_x(8, image_angle - (90 * image_yscale)) + lengthdir_x(16, image_angle)) / 16) * 16,
            _y = floor((y + lengthdir_y(8, image_angle - (90 * image_yscale)) + lengthdir_y(16, image_angle)) / 16) * 16;

        if(position_meeting(_x, _y, Wall)){
            with(instance_nearest(_x, _y, Wall)) instance_destroy();
        }

         // Make sure door isn't placed weirdly:
        var _x = (floor((x + 16 + lengthdir_x(8, image_angle - (90 * image_yscale))) / 32) * 32) - 16,
            _y = (floor((y + 16 + lengthdir_y(8, image_angle - (90 * image_yscale))) / 32) * 32) - 16;

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
            with obj_create(_cx - 32, _cy - 32, "CatholeBig"){
                with obj_create(x + o + orandom(2), y + o - 32 + orandom(2), "NewTable")
                    obj_create(x + orandom(2), y - 16 + orandom(2), choose("ChairFront","ChairFront","ChairSide"));
            }

             // delete this later
            obj_create(_cx, _cy, "Cat");

             // Corner Columns:
            instance_create(_x + 16,           _y + 16,           Wall);
            instance_create(_x + (w * o) - 32, _y + 16,           Wall);
            instance_create(_x + 16,           _y + (h * o) - 32, Wall);
            instance_create(_x + (w * o) - 32, _y + (h * o) - 32, Wall);

             // Spawn backup chests
            var _chest = [RadChest,AmmoChest,WeaponChest],
                _d = irandom(3);
            for (var _i = 0; _i <= 2; _i++)
                if !instance_exists(_chest[_i]) instance_create(_cx + lengthdir_x(80,(_i+_d)*90), _cy + lengthdir_y(80,(_i+_d)*90),_chest[_i]);

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
            break;
        }
        
        case "SmallPillars" : {
             // Walls:
            instance_create(_x + 16,            _y + 16,            Wall);
            instance_create(_x + 64,            _y + 16,            Wall);
            instance_create(_x + 16,            _y + 64,            Wall);
            instance_create(_x + 64,            _y + 64,            Wall);
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
            break;
        }
        
        case "SmallTriangle" : {
             // Walls:
            for (i = 1; i <= 5; i += 2)
                with instance_create(_x + i * 16, _y + (i - 1) * 16, Wall)
                    instance_create(x, y, NOWALLSHEREPLEASE);
             // Props:
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
                instance_create(_x + 48, _y + 16, SodaMachine);
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

#define area_finish
    lastarea = area;

     // Area End:
    if background_color == bgrColor{
        area = 3;
        subarea = 1;
    }

     // Next Subarea: 
    else subarea++;

#define scrFloorMake(_x,_y,_obj)
    return mod_script_call("mod", "ntte", "scrFloorMake",_x,_y,_obj);

#define scrFloorFill(_x,_y,_w,_h)
    return mod_script_call("mod", "ntte", "scrFloorFill",_x,_y,_w,_h);

#define scrFloorFillRound(_x,_y,_w,_h)
    return mod_script_call("mod", "ntte", "scrFloorFillRound",_x,_y,_w,_h);

#define obj_create(_x,_y,_obj)
    return mod_script_call_nc("mod","telib","obj_create",_x,_y,_obj);
    
#define nearest_instance(_x,_y,_instance)
    return mod_script_call("mod","telib","nearest_instance",_x,_y,_instance);
    
#define orandom(_n)
    return irandom_range(-_n,_n);