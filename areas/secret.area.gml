#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");

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
        "Table" : {
            w : 3,
            h : 3,
            carpet : 0.40
        },
        "Couch" : {
            w : 3,
            h : 2,
            carpet : 1.00
        },

         // LARGE:
        "Dining" : {
            w : 4,
            h : 3,
            carpet : 0.33
        },
        "Office" : {
            w : 3,
            h : 4
        },
        "Lounge" : {
            w : 4,
            h : 4
        },

         // TEST:
        "Test" : {
            w : 4,
            h : 4,
            layout : [
                [0,0,L,L],
                [0,0,L,L],
                [L,L,L,L],
                [L,L,L,L]
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

#macro RoomDebug false
#macro RoomList global.room_list
#macro RoomType global.room_type

#macro bgrColor area_get_background_color(102)
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
        case sprFloor1      : return sprFloor2;
        case sprFloor1B     : return sprFloor6B;
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
                    var _lx1 = _x + ((x + floor(w / 2)) * o),
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
                    }
                    else{
                        _mx = _lx2;
                        _my = _ly1;
                        if(_ly1 > _ly2) _ly1 += o;
                    }
    
                    for(var _fx = min(_lx1, _lx2); _fx < max(_lx1, _lx2); _fx += o){
                        instance_create(_fx, _my, Floor);
                    }
                    for(var _fy = min(_ly1, _ly2); _fy < max(_ly1, _ly2); _fy += o){
                        instance_create(_mx, _fy, Floor);
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

#define room_pop()
    var o = 32,
        _x = global.room_center[0] + (x * o), // Left
        _y = global.room_center[1] + (y * o), // Top
        _cx = _x + (w/2 * o), // Center X
        _cy = _y + (h/2 * o); // Center Y

    switch(type){
         // IMPORTANT ROOMS
        case "Boss":
             // Spawn boss spawner
            obj_create(_cx - 32, _cy - 32, "CatholeBig");

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
                if !instance_exists(_chest[_i]) instance_create(_cx + lengthdir_x(80,(_i+_d)*90)+o, _cy + lengthdir_y(80,(_i+_d)*90)+o,_chest[_i]);

            break;
         
         // SMALL ROOMS
        case "Table":
            with(obj_create(_cx, _cy,"NewTable")){
                if(random(5) < 4){
                    obj_create(x + orandom(2), y - 18 + orandom(2), "ChairFront");
                }
                obj_create(x, y-32, "CatLight");
            }
            break;
        
        case "Couch":
            obj_create(_cx, _cy, "Couch");
            if(random(5) < 2){
                instance_create(_x + orandom(24), _y + irandom(16), PizzaBox);
            }
            break;
            
         // LARGE ROOMS
        case "Dining":
            with(obj_create(_cx, _cy, "NewTable")){
                for(var _r = -1; _r <= 1; _r += 2){
                    with(obj_create(x + (24 * _r), y + orandom(2), "ChairSide")) image_xscale = _r;
                    obj_create(x + (12 * _r), y - 18 + orandom(2), "ChairFront");
                }
                obj_create(x, y - 32, "CatLight");
            }
            break;

        case "Office":
            for(var _ox = o; _ox < (w * o); _ox += o){
                for(var _oy = o; _oy < (h * o); _oy += o){
                    if(random(4) < 3){
                        with(obj_create(_x + _ox + orandom(2), _y + _oy + orandom(2), "NewTable")){
                            obj_create(x + orandom(2), y - 18 + orandom(2), choose("ChairFront", "ChairFront", "ChairSide"));
                        }
                    }
                    else obj_create(_x + _ox + orandom(2), _y + _oy + orandom(2), "Cabinet");
                }
            }
            break;

        case "Lounge":
            with(obj_create(_cx, _cy - 16, "Couch")){
                with(obj_create(x + orandom(2), y + 16 + orandom(2), "NewTable")){
                    obj_create(x, y - 32, "CatLight");
                    for(var _r = -1; _r <= 1; _r += 2) if(random(3) < 2){
                        with(obj_create(x + (24 * _r), y + orandom(2), "ChairSide")) image_xscale = _r;
                    }
                }
                instance_create(x + orandom(16), y + orandom(16), PizzaBox);
            }
            break;

         // TEST:
        case "Test":
            instance_create(_cx + 32, _cy - 40, TV);
            with(floors) if(y >= _cy && random(3) < 1){
                with(obj_create(x + 16, y + 12, "ChairFront")){
                    with(instance_create(x, y + 16 + orandom(4), PizzaBox)) depth = other.depth - 1;
                }
            }
            break;
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
                var _lx1 = _x + ((x + floor(w / 2)) * o),
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
                }
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
    if(subarea >= 1) && false{
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