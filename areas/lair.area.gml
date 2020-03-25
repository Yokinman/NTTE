#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	mus = mod_variable_get("mod", "teassets", "mus");
	sav = mod_variable_get("mod", "teassets", "sav");
	
	DebugLag = false;
	
	 // Rooms:
	var L = true;
	RoomCenter = [10000, 10000];
	RoomList = [];
	RoomType = {
		 // SPECIAL:
		"Start" : {
			w : 3,
			h : 3,
			carpet : 1,
			special : true
		},
		
		"Boss" : {
			w : 12,
			h : 12,
			special : true,
			layout : [
				[0,0,0,L,L,L,L,L,L,0,0,0],
				[0,0,0,L,L,L,L,L,L,0,0,0],
				[0,0,L,L,L,L,L,L,L,L,0,0],
				[L,L,L,L,L,L,L,L,L,L,L,L],
				[L,L,L,L,L,L,L,L,L,L,L,L],
				[L,L,L,L,L,L,L,L,L,L,L,L],
				[L,L,L,L,L,L,L,L,L,L,L,L],
				[L,L,L,L,L,L,L,L,L,L,L,L],
				[L,L,L,L,L,L,L,L,L,L,L,L],
				[0,0,L,L,L,L,L,L,L,L,0,0],
				[0,0,0,L,L,L,L,L,L,0,0,0],
				[0,0,0,L,L,L,L,L,L,0,0,0]
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
		
		"Vault" : {
			w : 3,
			h : 3
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

	 // Set Room Defaults:
	for(var i = 0; i < lq_size(RoomType); i++){
		var	t = lq_get_value(RoomType, i),
			_default = { w : 1, h : 1, carpet : 0, special : 0 };

		for(var j = 0; j < lq_size(_default); j++){
			var k = lq_get_key(_default, j);
			if(k not in t){
				lq_set(t, k, lq_get(_default, k));
			}
		}
	}
	
	 // Carpet Surface:
	global.resetSurf = true;
	global.surfW = 2000;
	global.surfH = 2000;
	global.surf = noone;

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

#macro RoomDebug false
#macro RoomList global.room_list
#macro RoomType global.room_type
#macro RoomCenter global.room_center

#define area_subarea           return 1;
#define area_goal              return 110;
#define area_next              return 3; // SCRAPYARDS
#define area_music             return [mus.Lair, 0.6];
#define area_ambience          return amb102;
#define area_background_color  return make_color_rgb(160, 157, 75);
#define area_shadow_color      return area_get_shadow_color(102);
#define area_fog               return sprFog102;
#define area_darkness          return true;
#define area_secret            return true;

#define area_name(_subarea, _loop)
	return "2-?";
	
#define area_text
	return choose("DON'T PET THEM", "SO MANY FLEAS", "ITCHY", "VENTILATION", "THE AIR STINGS");
	
#define area_mapdata(_lastx, _lasty, _lastarea, _lastsubarea, _subarea, _loops)
	return [_lastx, 9];
	
#define area_sprite(_spr)
	switch(_spr){
		 // Floors:
		case sprFloor1      : if(instance_is(other, Floor)){ with(other) area_setup_floor(); } return spr.FloorLair;
		case sprFloor1B     : if(instance_is(other, Floor)){ with(other) area_setup_floor(); } return spr.FloorLairB;
		case sprFloor1Explo : return spr.FloorLairExplo;
		case sprDetail1     : return sprDetail2;
		
		 // Walls:
		case sprWall1Bot    : return spr.WallLairBot;
		case sprWall1Top    : return spr.WallLairTop;
		case sprWall1Out    : return spr.WallLairOut;
		case sprWall1Trans  : return spr.WallLairTrans;
		case sprDebris1     : return spr.DebrisLair;
		
		 // Decals:
		case sprTopPot      : return spr.TopDecalLair;
		case sprBones       : return spr.WallDecalLair;
	}
	
#define area_setup
	goal             = area_goal();
	background_color = area_background_color();
	BackCont.shadcol = area_shadow_color();
	TopCont.darkness = area_darkness();
	TopCont.fog      = area_fog();
	
	 // No Safespawns:
	safespawn = 0;
	
	 // Rooms:
	RoomList = [];
	if(RoomDebug) script_bind_draw(RoomDebug_draw, 0);
	
#define area_setup_floor
	 // Fix Depth:
	if(styleb) depth = 8;
	
	 // Footsteps:
	material = (styleb ? 3 : 2);
	
#define area_start
	 // Delete SpawnWall:
	if(instance_exists(Wall)){
		with(Wall.id) if(place_meeting(x, y, Floor)){
			instance_destroy();
		}
	}
	
#define area_finish
	lastarea = area;
	lastsubarea = subarea;
	
	 // Remember you were here:
	with(GameCont) visited_lair = true;
	
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
	var	_x = _vx + random(game_width),
		_y = _vy + random(game_height);
		
	 // Drips:
	var f = instance_nearest(_x, _y, Floor);
	with(f) instance_create(x + random(32), y + random(32), Drip);
	
	return 30 + random(20);
	
#define area_begin_step
	if(DebugLag) trace_time();
	
	 // Resprite turrets iam smash brother and i dont want to recode turrets:
	with(instances_matching_ne(Turret, "hitid", "LairTurret")){
		hitid = "LairTurret";
		spr_idle = spr.LairTurretAppear;
		spr_walk = spr.LairTurretAppear;
		spr_hurt = spr.LairTurretAppear;
		spr_dead = spr.LairTurretDead;
		spr_fire = spr.LairTurretFire;
		sprite_index = spr_idle;
	}
	
	if(DebugLag) trace_time("lair_area_step");
	
#define area_make_floor
	var	_x = 10016 - 16,
		_y = 10016 - 16;
		
	RoomCenter = [_x, _y];
	
	 // Remove Starter Floor:
	if(instance_is(self + 1, Floor)){
		instance_delete(self + 1);
	}
	
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
			var	_x1 = x - 1,
				_y1 = y - 1,
				_x2 = _x1 + (w + 2),
				_y2 = _y1 + (h + 2);
				
			with(RoomList) if(self != other){
				if(rectangle_in_rectangle(x, y, x + w, y + h, _x1, _y1, _x2, _y2)){
					if(type != "Start"){
						var _dir = round(point_direction(other.x + (other.w / 2), other.y + (other.h / 2), x + (w / 2), y + (h / 2)) / 90) * 90;
						if(chance(1, 2)){
							_dir += choose(-90, -90, 90, 90, 180);
						}
						
						x += lengthdir_x(1, _dir);
						y += lengthdir_y(1, _dir);
					}
					
					_done = false;
				}
			}
			y = min(0 - floor(h / 2), y);
		}
		
		 // Special Rooms:
		if(_done){
			var	_boss = false,
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
				var	_maxDis = -1,
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
					var	_fx = x + floor(w / 2),
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
							var	_dx = _fx - other.x + lengthdir_x(1, a),
								_dy = _fy - other.y + lengthdir_y(1, a);
								
							if(point_in_rectangle(_dx, _dy, 0, 0, other.w - 1, other.h - 1)){
								if(other.layout[_dy, _dx]){
									door_create(_x + 16 + (_fx * o), _y + 16 + (_fy * o), a);
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
	
#define area_pop_props
	var	_x = x + 16,
		_y = y + 16;
		
	 // Top Decals:
	if(chance(1, 50)){
		obj_create(_x, _y, "TopDecal");
	}
	
#define area_pop_enemies
	var	_x = x + 16,
		_y = y + 16;
		
	 // Loop Spawns:
	if(GameCont.loops > 0 && chance(1, 4)){
		if(styleb) instance_create(_x, _y, BecomeTurret);
		else instance_create(_x, _y, choose(Molesarge, Jock));
	}
	
	 // Rat packs:
	if(!place_meeting(x, y, Wall) && chance(1, 20)){
		repeat(irandom_range(3, 7)) instance_create(_x, _y, Rat);
	}
	
	 // Spawn Cats Underground:
	else if(chance(1, 8)){
		with(obj_create(_x, _y, "Cat")){
			if(chance(1, 2)){
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
					chance(1, 16) ||
					(
						chance(1, 2) &&
						array_length(instance_rectangle(x - 96, y - 96, x + 96, y + 96, instances_matching(CustomObject, "name", "CatHole"))) <= 0
					)
				){
					obj_create(x + 16, y + 16, "CatHole");
				}
			}
		}
	}
	
	 // Emergency Enemy Reserves:
	while(instance_number(enemy) < 24){
		with(instance_random(instances_matching(Floor, "sprite_index", spr.FloorLair))){
			if(!place_meeting(x, y, Wall)){
				create_enemies(x + 16, y + 16, 1);
			}
		}
	}
	
	 // Important Door Stuff:
	with(instances_matching(CustomHitme, "name", "CatDoor")){
		 // Remove Blocking Walls:
		var	_ang = image_angle - (90 * image_yscale);
		with(instances_at(
			x + lengthdir_x(8, _ang) + lengthdir_x(8, image_angle),
			y + lengthdir_y(8, _ang) + lengthdir_y(8, image_angle),
			Wall
		)){
			instance_destroy();
		}
		
		 // Make sure door isn't placed weirdly:
		with(instances_at(bbox_center_x, bbox_bottom - 5, Floor)){
			for(var i = 0; i <= 180; i += 180){
				var a = other.image_angle - 90 + i;
				if(position_meeting(x + lengthdir_x(32, a), y + lengthdir_y(32, a), Floor)){
					instance_delete(other);
					break;
				}
			}
			break;
		}
	}
	
	 // Fix stuck dudes:
	with(enemy) if(place_meeting(x, y, Wall)){
		if(!instance_budge(Wall, -1)){
			instance_delete(id);
		}
	}
	
	 // Light up specific things:
	with(instances_matching([chestprop, RadChest], "", null)){
		obj_create(x, y - 32, "CatLight");
	}
	with(obj_create(10016, 10016 - 60, "CatLight")){
		w1 = 24;
		w2 = 60;
		h1 = 64;
		h2 = 16;
	}
	
	
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
		if(chance(carpet, 1)) carpeted = true;
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
	repeat(_num + round(random_range(1.5, 2) * GameCont.loops)){
		obj_create(_x, _y, _e);
	}
	
#define room_pop
	var	_x = RoomCenter[0] + (x * 32), // Left
		_y = RoomCenter[1] + (y * 32), // Top
		_w = w * 32, // Width
		_h = h * 32, // Height
		_cx = _x + (_w / 2), // Center X
		_cy = _y + (_h / 2); // Center Y
		
	switch(type){
		
		/// IMPORTANT ROOMS
		case "Start":
			
			obj_create(_cx, _cy, "SewerRug");
			
			break;
			
		case "Boss":
			
			obj_create(_cx, _cy, "CatHoleBig");
			
			 // Corner Columns:
			instance_create(_x + 80,      _y + 80,      Wall);
			instance_create(_x + _w - 96, _y + 80,      Wall);
			instance_create(_x + 80,      _y + _h - 96, Wall);
			instance_create(_x + _w - 96, _y + _h - 96, Wall);
			
			 // Spawn backup chests
			var	_chest = [RadChest, AmmoChest, WeaponChest],
				_dis = 176,
				_dir = round(random(360) / 90) * 90;
				
			for(var i = 0; i < array_length(_chest); i++){
				if(!instance_exists(_chest[i])){
					instance_create(_cx + lengthdir_x(_dis, _dir + (i * 90)), _cy + lengthdir_y(_dis, _dir + (i * 90)), _chest[i]);
				}
			}
			
			break;
			
		/// SMALL ROOMS
		case "SmallClutter":
			
			 // Props:
			repeat(irandom_range(2, 4)){
				obj_create(
					_cx + orandom(24),
					_cy + orandom(24),
					choose("ChairFront", "ChairSide", "Table", "Cabinet")
				);
			}
			
			 // Enemies:
			create_enemies(_cx, _cy, irandom(3));
			
			break;
			
		case "MediumClutter":
			
			 // Props:
			repeat(irandom_range(2, 6)){
				obj_create(
					_cx + orandom(32),
					_cy + orandom(32),
					choose("ChairFront", "ChairSide", "Table", "Cabinet")
				);
			}
			
			 // Enemies:
			create_enemies(_cx, _cy, irandom(5));
			
			break;
			
		case "SmallPillars":
			
			 // Walls:
			instance_create(_x + 16,      _y + 16,      Wall);
			instance_create(_x + _w - 32, _y + 16,      Wall);
			instance_create(_x + 16,      _y + _h - 32, Wall);
			instance_create(_x + _w - 32, _y + _h - 32, Wall);
			
			 // Enemies:
			create_enemies(_cx, _cy, 1);
			
			break;
			
		case "SmallRing":
		case "WideSmallRing":
		case "TallSmallRing":
		case "MediumRing":
			
			 // Center Walls:
			instance_create(_cx - 16, _cy - 16, Wall);
			instance_create(_cx - 16, _cy,      Wall);
			instance_create(_cx,      _cy - 16, Wall);
			instance_create(_cx,      _cy,      Wall);
			
			 // Enemies:
			switch(type){
				case "WideSmallRing":
					create_enemies(_cx + choose(-32, 32), _cy, 1);
					break;
					
				case "TallSmallRing":
					create_enemies(_cx, _cy + choose(-32, 32), 1);
					break;
			}
			
			break;
			
		case "Table":
			
			 // Props:
			with(obj_create(_cx, _cy, "NewTable")){
				if(chance(4, 5)){
					obj_create(x + orandom(2), y - 18 + orandom(2), "ChairFront");
				}
				obj_create(x, y - 32, "CatLight");
			}
			
			 // Enemies:
			create_enemies(_cx, _cy, 1 + irandom(2));
			
			break;
			
		case "Toilet":
			
			 // Walls:
			for(var _oy = 0; _oy <= 1; _oy++){
				instance_create(_x + 32, _y + (_oy * 16), Wall);
			}
			instance_create(_x + _w - 16, _y + 48, Wall);
			
			 // Props:
			with(obj_create(_x + 16 + orandom(2), _y + 12, "ChairFront")){
				with(obj_create(x, y - 28, "CatLight")){
					w2 = 18;
					h2 = 6;
				}
			}
			
			 // Enemies:
			create_enemies(_x, _y, 1);
			
			break;
			
		case "SmallTriangle":
			
			 // Walls:
			for(_off = 0; _off < min(_w, _h); _off += 32){
				instance_create(_x + _off + 16, _y + _off, Wall);
			}
			
			 // Enemies:
			create_enemies(_cx, _cy, 1 + irandom(1));
			
			break;
			
		case "Vault":
			
			 // Corner Walls:
			instance_create(_x,           _y,           Wall);
			instance_create(_x + _w - 16, _y,           Wall);
			instance_create(_x,           _y + _h - 16, Wall);
			instance_create(_x + _w - 16, _y + _h - 16, Wall);
			
			 // Valuables:
			var	_ang = random(360),
				_num = random_range(2, 4);
				
			for(var d = _ang; d < _ang + 360; d += (360 / _num)){
				var l = random(24);
				obj_create(
					_cx + lengthdir_x(l, d),
					_cy + lengthdir_y(l, d),
					choose("PizzaStack", "PizzaStack", "PizzaChest", MoneyPile)
				);
			}
			
			 // Center Floor:
			with(instances_at(_cx, _cy, floors)){
				sprite_index = sprFloor102B;
				material = 6;
			}
			
			break;
			
		/// LARGE ROOMS
		case "SmallAtrium":
			
			 // Walls:
			for(var _ox = -40; _ox <= 40; _ox += 80){
				for(var _oy = -40; _oy <= 40; _oy += 80){
					instance_create(_cx + _ox - 8,                    _cy + _oy - 8,                    Wall);
					instance_create(_cx + _ox - 8 - (16 * sign(_ox)), _cy + _oy - 8,                    Wall);
					instance_create(_cx + _ox - 8,                    _cy + _oy - 8 - (16 * sign(_oy)), Wall);
				}
			}
			
			 // Center Walls:
			instance_create(_cx - 16, _cy - 16, Wall);
			instance_create(_cx - 16, _cy,      Wall);
			instance_create(_cx,      _cy - 16, Wall);
			instance_create(_cx,      _cy,      Wall);
			
			 // Enemies & Lights:
			for(var d = 0; d <= 360; d += 90){
				var	_ox = _cx + lengthdir_x((_w / 2) - 24, d),
					_oy = _cy + lengthdir_y((_h / 2) - 24, d);
					
				create_enemies(_ox, _oy, 1 + irandom(1));
				
				 // Lights:
				with(obj_create(_ox, _oy - 44, "CatLight")){
					h1 = 48;
				}
			}
			
			break;
			
		case "Lounge":
			
			 // Walls:
			instance_create(_x + 32,      _y,           Wall);
			instance_create(_x + 32,      _y + _h - 48, Wall);
			instance_create(_x + _w - 48, _y,           Wall);
			instance_create(_x + _w - 48, _y + _h - 48, Wall);
			
			 // Props:
			with(obj_create(_cx + orandom(2), _y + 16 + orandom(2), "Couch")){
				obj_create(x + orandom(2), y + 20 + orandom(2), "NewTable");
			}
			
			 // Enemies:
			create_enemies(_cx, _y + 16, 2);
			
			break;
			
		case "Dining":
			
			 // Props:
			with(obj_create(_cx, _cy, "NewTable")){
				for(var _side = -1; _side <= 1; _side += 2){
					with(obj_create(x + (24 * _side), y + orandom(2), "ChairSide")){
						image_xscale = _side;
					}
					obj_create(x + (12 * _side), y - 18 + orandom(2), "ChairFront");
				}
				obj_create(x, y - 32, "CatLight");
			}
			
			 // Enemies:
			create_enemies(_cx, _cy, 1 + irandom(1));
			
			break;
			
		case "Cafeteria":
			
			 // Walls:
			for(var _oy = 1; _oy <= 2; _oy++){
				instance_create(_x,           _y + (_oy * 16) + 32,      Wall);
				instance_create(_x + _w - 16, _y + (_oy * 16) + 32,      Wall);
				instance_create(_x,           _y - (_oy * 16) + _h - 16, Wall);
				instance_create(_x + _w - 16, _y - (_oy * 16) + _h - 16, Wall);
			}
			
			/// Props:
				
				 // Vending machine:
				with(instance_create(_x + 48, _y + 16, SodaMachine)){
					spr_idle = spr.SodaMachineIdle;
					spr_hurt = spr.SodaMachineHurt;
					spr_dead = spr.SodaMachineDead;
					sprite_index = spr_idle;
				}
				
				 // Tables & Chairs:
				for(var _oy = 80; _oy < _h - 32; _oy += 32){
					with(obj_create(_cx + orandom(2), _y + _oy + orandom(2), "NewTable")){
						 // Chairs:
						for(var _side = -1; _side <= 1; _side += 2){
							if(chance(2, 5)){
								with(obj_create(x + (20 * _side) + orandom(2), y + orandom(2), "ChairSide")){
									image_xscale = _side;
								}
							}
						}
						if(chance(2, 5)){
							obj_create(x + orandom(2), y - 14 + orandom(2), "ChairFront");
						}
						
						 // Lights:
						if(chance(2, 3)){
							obj_create(x, y - 32, "CatLight");
						}
					}
				}
				
			 // Enemies:
			create_enemies(_cx, _cy, 3 + irandom(1));
			
			break;
			
		case "Office":
			
			 // Walls:
			instance_create(_x + 16,      _y + 32,      Wall);
			instance_create(_x + _w - 32, _y + 32,      Wall);
			instance_create(_x + 16,      _y + _h - 16, Wall);
			instance_create(_x + _w - 32, _y + _h - 16, Wall);
			
			 // Props:
			with(obj_create(_cx + orandom(2), _y + 26 + orandom(2), "NewTable")){
				obj_create(
					x + orandom(4),
					y - 16 + orandom(2),
					choose("ChairFront", "ChairFront", "ChairSide")
				);
				
				 // Cabinets:
				for(var _side = -1; _side <= 1; _side += 2){
					obj_create(_cx + (_side * ((_w / 2) - 48)), _y + 42 + orandom(2), "Cabinet");
				}
				
				 // Light:
				obj_create(x, y - 30, "CatLight");
			}
			
			 // Enemies:
			create_enemies(_cx, _cy, 1 + irandom(1));
			
			break;
			
		case "Garage":
			
			 // Walls:
			instance_create(_cx - 16, _y,           Wall);
			instance_create(_cx,      _y,           Wall);
			instance_create(_cx - 16, _y + _h - 16, Wall);
			instance_create(_cx,      _y + _h - 16, Wall);
			
			/// Props:
				
				 // Cars:
				for(var _oy = 32; _oy < _h; _oy += 32){
					instance_create(_x + 32 + orandom(2), _y + _oy + orandom(2), Car);
				}
				
				 // Tires:
				repeat(irandom_range(2, 4)){
					with(instance_create(_cx + irandom_range(24, (_w / 2) - 10), _y + irandom_range(10, _h), Tires)){
						if(chance(1, 10)){
							obj_create(x, y, choose("ChairFront", "ChairSide"));
							instance_delete(id);
						}
					}
				}
				
				 // Lights:
				for(var _side = -1; _side <= 1; _side += 2){
					obj_create(_cx + (((_w / 2) - 24) * _side), _cy - 32, "CatLight");
				}
				
			 // Enemies:
			create_enemies(_cx, _cy, 1);
			
			break;
			
		case "LargeRing":
			
			 // Walls:
			instance_create(_cx - 32, _cy - 32, Wall);
			instance_create(_cx - 32, _cy + 16, Wall);
			instance_create(_cx + 16, _cy - 32, Wall);
			instance_create(_cx + 16, _cy + 16, Wall);
			
			 // Enemies:
			create_enemies(_cx - 64, _cy - 64, 1);
			create_enemies(_cx + 64, _cy - 64, 1);
			create_enemies(_cx - 64, _cy + 64, 1);
			create_enemies(_cx + 64, _cy + 64, 1);
			
			break;
	}
	
#define draw_rugs
	if(!instance_exists(GenCont)){
		var	_surfX = RoomCenter[0] - (global.surfW / 2),
			_surfY = RoomCenter[1] - (global.surfH / 2),
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
				var	_s = spr.Rug,
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
								draw_sprite(_s[n], _i, RoomCenter[0] + ((other.x + xx) * o) - _surfX, RoomCenter[1] + ((other.y + yy) * o) - _surfY);
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
		
		var	o = 4,
			_x = game_width / 2,
			_y = game_height / 2;
			
		 // Hallways:
		draw_set_color(c_dkgray);
		with(RoomList){
			if(is_object(link)) with(link){
				var	_fx = x + floor(w / 2),
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
						var	_dx = _fx - other.x + lengthdir_x(1, a),
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
				/*var	_lx1 = _x + ((x + floor(w / 2)) * o),
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
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  anim_end                                                                                image_index + image_speed_raw >= image_number
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
#macro  bbox_width                                                                              (bbox_right + 1) - bbox_left
#macro  bbox_height                                                                             (bbox_bottom + 1) - bbox_top
#macro  bbox_center_x                                                                           (bbox_left + bbox_right + 1) / 2
#macro  bbox_center_y                                                                           (bbox_top + bbox_bottom + 1) / 2
#macro  FloorNormal                                                                             instances_matching(Floor, 'object_index', Floor)
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define pfloor(_num, _precision)                                                        return  floor(_num / _precision) * _precision;
#define in_range(_num, _lower, _upper)                                                  return  (_num >= _lower && _num <= _upper);
#define frame_active(_interval)                                                         return  (current_frame % _interval) < current_time_scale;
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define surflist_set(_name, _x, _y, _width, _height)                                    return  mod_script_call_nc('mod', 'teassets', 'surflist_set', _name, _x, _y, _width, _height);
#define surflist_get(_name)                                                             return  mod_script_call_nc('mod', 'teassets', 'surflist_get', _name);
#define shadlist_set(_name, _vertex, _fragment)                                         return  mod_script_call_nc('mod', 'teassets', 'shadlist_set', _name, _vertex, _fragment);
#define shadlist_get(_name)                                                             return  mod_script_call_nc('mod', 'teassets', 'shadlist_get', _name);
#define shadlist_setup(_shader, _texture, _args)                                        return  mod_script_call_nc('mod', 'telib', 'shadlist_setup', _shader, _texture, _args);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define top_create(_x, _y, _obj, _spawnDir, _spawnDis)                                  return  mod_script_call_nc('mod', 'telib', 'top_create', _x, _y, _obj, _spawnDir, _spawnDis);
#define save_get(_name, _default)                                                       return  mod_script_call_nc('mod', 'telib', 'save_get', _name, _default);
#define save_set(_name, _value)                                                                 mod_script_call_nc('mod', 'telib', 'save_set', _name, _value);
#define option_get(_name)                                                               return  mod_script_call_nc('mod', 'telib', 'option_get', _name);
#define option_set(_name, _value)                                                               mod_script_call_nc('mod', 'telib', 'option_set', _name, _value);
#define stat_get(_name)                                                                 return  mod_script_call_nc('mod', 'telib', 'stat_get', _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc('mod', 'telib', 'stat_set', _name, _value);
#define unlock_get(_name)                                                               return  mod_script_call_nc('mod', 'telib', 'unlock_get', _name);
#define unlock_set(_name, _value)                                                       return  mod_script_call_nc('mod', 'telib', 'unlock_set', _name, _value);
#define trace_error(_error)                                                                     mod_script_call_nc('mod', 'telib', 'trace_error', _error);
#define view_shift(_index, _dir, _pan)                                                          mod_script_call_nc('mod', 'telib', 'view_shift', _index, _dir, _pan);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc('mod', 'telib', 'sleep_max', _milliseconds);
#define in_distance(_inst, _dis)                                                        return  mod_script_call(   'mod', 'telib', 'in_distance', _inst, _dis);
#define in_sight(_inst)                                                                 return  mod_script_call(   'mod', 'telib', 'in_sight', _inst);
#define instance_budge(_objAvoid, _disMax)                                              return  mod_script_call(   'mod', 'telib', 'instance_budge', _objAvoid, _disMax);
#define instance_random(_obj)                                                           return  mod_script_call_nc('mod', 'telib', 'instance_random', _obj);
#define instance_create_copy(_x, _y, _obj)                                              return  mod_script_call(   'mod', 'telib', 'instance_create_copy', _x, _y, _obj);
#define instance_create_lq(_x, _y, _lq)                                                 return  mod_script_call_nc('mod', 'telib', 'instance_create_lq', _x, _y, _lq);
#define instance_nearest_array(_x, _y, _inst)                                           return  mod_script_call_nc('mod', 'telib', 'instance_nearest_array', _x, _y, _inst);
#define instance_nearest_bbox(_x, _y, _inst)                                            return  mod_script_call_nc('mod', 'telib', 'instance_nearest_bbox', _x, _y, _inst);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc('mod', 'telib', 'instance_rectangle', _x1, _y1, _x2, _y2, _obj);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call_nc('mod', 'telib', 'instance_rectangle_bbox', _x1, _y1, _x2, _y2, _obj);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call_nc('mod', 'telib', 'instances_at', _x, _y, _obj);
#define instances_seen_nonsync(_obj, _bx, _by)                                          return  mod_script_call_nc('mod', 'telib', 'instances_seen_nonsync', _obj, _bx, _by);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   'mod', 'telib', 'instances_meeting', _x, _y, _obj);
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call_nc('mod', 'telib', 'draw_weapon', _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call_nc('mod', 'telib', 'draw_lasersight', _x, _y, _dir, _maxDistance, _width);
#define array_exists(_array, _value)                                                    return  mod_script_call_nc('mod', 'telib', 'array_exists', _array, _value);
#define array_count(_array, _value)                                                     return  mod_script_call_nc('mod', 'telib', 'array_count', _array, _value);
#define array_combine(_array1, _array2)                                                 return  mod_script_call_nc('mod', 'telib', 'array_combine', _array1, _array2);
#define array_delete(_array, _index)                                                    return  mod_script_call_nc('mod', 'telib', 'array_delete', _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call_nc('mod', 'telib', 'array_delete_value', _array, _value);
#define array_flip(_array)                                                              return  mod_script_call_nc('mod', 'telib', 'array_flip', _array);
#define array_shuffle(_array)                                                           return  mod_script_call_nc('mod', 'telib', 'array_shuffle', _array);
#define array_clone_deep(_array)                                                        return  mod_script_call_nc('mod', 'telib', 'array_clone_deep', _array);
#define lq_clone_deep(_obj)                                                             return  mod_script_call_nc('mod', 'telib', 'lq_clone_deep', _obj);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc('mod', 'telib', 'scrFX', _x, _y, _motion, _obj);
#define scrRight(_dir)                                                                          mod_script_call(   'mod', 'telib', 'scrRight', _dir);
#define scrWalk(_dir, _walk)                                                                    mod_script_call(   'mod', 'telib', 'scrWalk', _dir, _walk);
#define scrAim(_dir)                                                                            mod_script_call(   'mod', 'telib', 'scrAim', _dir);
#define enemy_walk(_spdAdd, _spdMax)                                                            mod_script_call(   'mod', 'telib', 'enemy_walk', _spdAdd, _spdMax);
#define enemy_hurt(_hitdmg, _hitvel, _hitdir)                                                   mod_script_call(   'mod', 'telib', 'enemy_hurt', _hitdmg, _hitvel, _hitdir);
#define enemy_shoot(_object, _dir, _spd)                                                return  mod_script_call(   'mod', 'telib', 'enemy_shoot', _object, _dir, _spd);
#define enemy_shoot_ext(_x, _y, _object, _dir, _spd)                                    return  mod_script_call(   'mod', 'telib', 'enemy_shoot_ext', _x, _y, _object, _dir, _spd);
#define enemy_target(_x, _y)                                                            return  mod_script_call(   'mod', 'telib', 'enemy_target', _x, _y);
#define boss_hp(_hp)                                                                    return  mod_script_call_nc('mod', 'telib', 'boss_hp', _hp);
#define boss_intro(_name, _sound, _music)                                               return  mod_script_call_nc('mod', 'telib', 'boss_intro', _name, _sound, _music);
#define corpse_drop(_dir, _spd)                                                         return  mod_script_call(   'mod', 'telib', 'corpse_drop', _dir, _spd);
#define rad_drop(_x, _y, _raddrop, _dir, _spd)                                          return  mod_script_call_nc('mod', 'telib', 'rad_drop', _x, _y, _raddrop, _dir, _spd);
#define rad_path(_inst, _target)                                                        return  mod_script_call_nc('mod', 'telib', 'rad_path', _inst, _target);
#define area_get_name(_area, _subarea, _loop)                                           return  mod_script_call_nc('mod', 'telib', 'area_get_name', _area, _subarea, _loop);
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call_nc('mod', 'telib', 'area_get_sprite', _area, _spr);
#define area_get_subarea(_area)                                                         return  mod_script_call_nc('mod', 'telib', 'area_get_subarea', _area);
#define area_get_secret(_area)                                                          return  mod_script_call_nc('mod', 'telib', 'area_get_secret', _area);
#define area_get_underwater(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_underwater', _area);
#define area_border(_y, _area, _color)                                                  return  mod_script_call_nc('mod', 'telib', 'area_border', _y, _area, _color);
#define area_generate(_area, _subarea, _x, _y, _setArea, _overlapFloor, _scrSetup)      return  mod_script_call_nc('mod', 'telib', 'area_generate', _area, _subarea, _x, _y, _setArea, _overlapFloor, _scrSetup);
#define floor_get(_x, _y)                                                               return  mod_script_call_nc('mod', 'telib', 'floor_get', _x, _y);
#define floor_set(_x, _y, _state)                                                       return  mod_script_call_nc('mod', 'telib', 'floor_set', _x, _y, _state);
#define floor_set_style(_style, _area)                                                  return  mod_script_call_nc('mod', 'telib', 'floor_set_style', _style, _area);
#define floor_set_align(_alignW, _alignH, _alignX, _alignY)                             return  mod_script_call_nc('mod', 'telib', 'floor_set_align', _alignW, _alignH, _alignX, _alignY);
#define floor_reset_style()                                                             return  mod_script_call_nc('mod', 'telib', 'floor_reset_style');
#define floor_reset_align()                                                             return  mod_script_call_nc('mod', 'telib', 'floor_reset_align');
#define floor_make(_x, _y, _obj)                                                        return  mod_script_call_nc('mod', 'telib', 'floor_make', _x, _y, _obj);
#define floor_fill(_x, _y, _w, _h, _type)                                               return  mod_script_call_nc('mod', 'telib', 'floor_fill', _x, _y, _w, _h, _type);
#define floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)                      return  mod_script_call_nc('mod', 'telib', 'floor_room_start', _spawnX, _spawnY, _spawnDis, _spawnFloor);
#define floor_room_create(_x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis)         return  mod_script_call_nc('mod', 'telib', 'floor_room_create', _x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis);
#define floor_room(_spaX, _spaY, _spaDis, _spaFloor, _w, _h, _type, _dirOff, _floorDis) return  mod_script_call_nc('mod', 'telib', 'floor_room', _spaX, _spaY, _spaDis, _spaFloor, _w, _h, _type, _dirOff, _floorDis);
#define floor_reveal(_floors, _maxTime)                                                 return  mod_script_call_nc('mod', 'telib', 'floor_reveal', _floors, _maxTime);
#define floor_tunnel(_x1, _y1, _x2, _y2)                                                return  mod_script_call_nc('mod', 'telib', 'floor_tunnel', _x1, _y1, _x2, _y2);
#define floor_bones(_num, _chance, _linked)                                             return  mod_script_call(   'mod', 'telib', 'floor_bones', _num, _chance, _linked);
#define floor_walls()                                                                   return  mod_script_call(   'mod', 'telib', 'floor_walls');
#define wall_tops()                                                                     return  mod_script_call(   'mod', 'telib', 'wall_tops');
#define wall_clear(_x1, _y1, _x2, _y2)                                                          mod_script_call_nc('mod', 'telib', 'wall_clear', _x1, _y1, _x2, _y2);
#define sound_play_ntte(_type, _snd)                                                    return  mod_script_call_nc('mod', 'telib', 'sound_play_ntte', _type, _snd);
#define sound_play_hit_ext(_snd, _pit, _vol)                                            return  mod_script_call(   'mod', 'telib', 'sound_play_hit_ext', _snd, _pit, _vol);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call(   'mod', 'telib', 'race_get_sprite', _race, _sprite);
#define race_get_title(_race)                                                           return  mod_script_call(   'mod', 'telib', 'race_get_title', _race);
#define player_create(_x, _y, _index)                                                   return  mod_script_call_nc('mod', 'telib', 'player_create', _x, _y, _index);
#define player_swap()                                                                   return  mod_script_call(   'mod', 'telib', 'player_swap');
#define wep_get(_wep)                                                                   return  mod_script_call_nc('mod', 'telib', 'wep_get', _wep);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc('mod', 'telib', 'wep_merge', _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call_nc('mod', 'telib', 'wep_merge_decide', _hardMin, _hardMax);
#define weapon_decide(_hardMin, _hardMax, _gold, _noWep)                                return  mod_script_call(   'mod', 'telib', 'weapon_decide', _hardMin, _hardMax, _gold, _noWep);
#define skill_get_icon(_skill)                                                          return  mod_script_call(   'mod', 'telib', 'skill_get_icon', _skill);
#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)                        return  mod_script_call_nc('mod', 'telib', 'path_create', _xstart, _ystart, _xtarget, _ytarget, _wall);
#define path_shrink(_path, _wall, _skipMax)                                             return  mod_script_call_nc('mod', 'telib', 'path_shrink', _path, _wall, _skipMax);
#define path_reaches(_path, _xtarget, _ytarget, _wall)                                  return  mod_script_call_nc('mod', 'telib', 'path_reaches', _path, _xtarget, _ytarget, _wall);
#define path_direction(_path, _x, _y, _wall)                                            return  mod_script_call_nc('mod', 'telib', 'path_direction', _path, _x, _y, _wall);
#define path_draw(_path)                                                                return  mod_script_call(   'mod', 'telib', 'path_draw', _path);
#define portal_poof()                                                                   return  mod_script_call_nc('mod', 'telib', 'portal_poof');
#define portal_pickups()                                                                return  mod_script_call_nc('mod', 'telib', 'portal_pickups');
#define pet_spawn(_x, _y, _name)                                                        return  mod_script_call_nc('mod', 'telib', 'pet_spawn', _x, _y, _name);
#define pet_get_icon(_modType, _modName, _name)                                         return  mod_script_call(   'mod', 'telib', 'pet_get_icon', _modType, _modName, _name);
#define team_get_sprite(_team, _sprite)                                                 return  mod_script_call_nc('mod', 'telib', 'team_get_sprite', _team, _sprite);
#define team_instance_sprite(_team, _inst)                                              return  mod_script_call_nc('mod', 'telib', 'team_instance_sprite', _team, _inst);
#define sprite_get_team(_sprite)                                                        return  mod_script_call_nc('mod', 'telib', 'sprite_get_team', _sprite);
#define scrPickupIndicator(_text)                                                       return  mod_script_call(   'mod', 'telib', 'scrPickupIndicator', _text);
#define scrAlert(_inst, _sprite)                                                        return  mod_script_call(   'mod', 'telib', 'scrAlert', _inst, _sprite);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   'mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_instance, _charm)                                               return  mod_script_call_nc('mod', 'telib', 'charm_instance', _instance, _charm);
#define door_create(_x, _y, _dir)                                                       return  mod_script_call_nc('mod', 'telib', 'door_create', _x, _y, _dir);