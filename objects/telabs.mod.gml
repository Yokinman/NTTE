#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	lag = false;
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#define Button_create(_x, _y)
	/*
		A labs event prop.
	*/

	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle = spr.ButtonIdle;
		spr_hurt = spr.ButtonHurt;
		spr_dead = spr.ButtonDead;
		sprite_index = spr_idle;
		spr_shadow = mskNone;
		
		 // Sounds:
		snd_hurt = sndHitMetal;
		snd_dead = sndServerBreak;
		
		 // Vars:
		mask_index = -1;
		maxhealth = 120;
		size = 2;
		team = 1;
		presses = 0;
		pickup_indicator = scrPickupIndicator("PUSH");
		with(pickup_indicator){
			mask_index = mskReviveArea;
			yoff = -8;
		}
		effect_color = make_color_rgb(252, 56, 0);
		
		 // Alarms:
		alarm0 = -1;
		alarm1 = -1;
		
		return id;
	}
	
#define Button_step
	var _pickup = pickup_indicator;
	if(instance_exists(_pickup)){
		if(_pickup.pick != -1){
			 // Visual:
			spr_idle = spr.ButtonPressedIdle;
			spr_hurt = spr.ButtonPressedHurt;
			sprite_index = spr_hurt;
			
			 // Vars:
			presses++;
			_pickup.visible = false;
			
			 // Effects and Stuff:
			portal_poof();
			
			var _col = effect_color;
			with(instance_create(x, y - 6, FXChestOpen)){
				image_blend = _col;
			}
			
			sound_play(sndIDPDNadeAlmost);
			
			alarm0 = 20;
		}
	}
	
#define Button_death
	 // Effects:
	var d = direction;
	with(instance_create(x, y, Debris)){
		sprite_index = spr.ButtonDebris;
		motion_set(d + orandom(45), 4);
	}
	repeat(10){
		with(instance_create(x, y, Smoke)){
			motion_add(d + orandom(45), random(4));
		}
	}
	repeat(5){
		with(instance_create(x + orandom(20), y + orandom(20), PortalL)){
			image_blend = other.effect_color;
		}
	}
	
#define Button_alrm0
		
	 // Positive Outcome:
	var _col = effect_color;
	if(chance(presses * 2/3, 7)){
		 // alarm2 = 30;
			
		 // Effects:
		sound_play(sndGunGun);
		repeat(15){
			with(instance_create(x, y, Dust)){
				sprite_index = sprSpiralStar;
				image_blend = _col;
				depth = other.depth - 1;
				motion_set(random(360), 5);
			}
		}
		
		 // Open Chests:
		with(instances_matching(chestprop, "name", "ButtonChest", "ButtonPickup")){
			with(obj_create(x, y, "PickupReviveArea")){
				pickup = other;
			}
		}
	}
	
	 // Negative Outcome:
	else{
		 // Better Luck Next Time:
		alarm1 = 40;
		my_health = maxhealth;
		
		 // Effects:
		sound_play(sndComputerBreak);
		with(instance_create(x, y - 6, GunWarrantEmpty)){
			image_blend = _col;
			image_angle = orandom(30);
		}
		
		 // Stupid Idiot Loser Pool:
		var _payout = [],
			_pool = [
			["Turret",		 3],
			["FishFreak",  	 3],
			["RhinoFreak",	 2],
			["Necromancer",  2],
			["FreakChamber", 1]
		];
		repeat(presses){
			array_push(_payout, pool(_pool));
		}
		if(chance(1, 2)){
			array_push(_payout, "Pickup");
		}
		
		 // Locate Floors:
		var _floors = [];
		with(FloorNormal){
			var _cx = bbox_center_x,
				_cy = bbox_center_y;
				
			if(instance_near(_cx, _cy, other, 160)){
				if(instance_seen(_cx, _cy, instance_nearest(_cx, _cy, Player))){
					if(!place_meeting(x, y, Wall) && !place_meeting(x, y, other)){
						array_push(_floors, id);
					}
				}
			}
		}
		
		 // Spawn Stuff:
		if(array_length(_floors) > 0){
			var _blacklist = [];
			
			for(var i = 0; i < array_length(_payout); i++){
				
				 // Locate Floor For Real This Time:
				var _floor = noone,
					_tries = 100;
					
				while(_floor == noone && _tries-- > 0){
					with(instance_random(_floors)){
						if(!array_exists(_blacklist, id)){
							_floor = id;
							array_push(_blacklist, _floor);
						}
					}
				}
					
				if(instance_exists(_floor)){
					var _x = _floor.x + 16,
						_y = _floor.y + 16;
						
					switch(_payout[i]){
						case "FreakChamber":
							with(obj_create(x, y, "FreakChamber")){
								alarm0 = 10;
							}
							break;
							
						case "Turret":
							instance_create(_x, _y, Turret);
							break;
							
						case "Necromancer":
							with(obj_create(_x, _y, "ButtonReviveArea")){
								object_name = Necromancer;
							}
							break;
							
						case "FishFreak":
							with(obj_create(_x, _y, "ButtonReviveArea")){
								object_name = Freak;
								num_objects = 3;
							}
							break;
							
						case "RhinoFreak":
							with(obj_create(_x, _y, "ButtonReviveArea")){
								object_name = RhinoFreak;
							}
							break;
							
						case "Pickup":
							obj_create(_x, _y, "PickupReviveArea");
							break;
					}
				}
			}
		}
	}
	
#define Button_alrm1
	 // Visual:
	spr_idle = spr.ButtonIdle;
	spr_hurt = spr.ButtonHurt;
	sprite_index = spr_idle;
	
	with(pickup_indicator){
		visible = true;
	}
	
#define Button_alrm2
	 // Goodbye:
	my_health = 0;
	
#define ButtonChest_create(_x, _y)
	with(instance_create(_x, _y, chestprop)){
		 // Visual:
		spr_debris = spr.ButtonChestDebris;
		spr_shadow_y = 0;
		sprite_index = spr.ButtonChest;
		
		 // Vars:
		mask_index = sprAmmoChest;
		payout_pool = [
			[AmmoChest, 		 3],
			[WeaponChest,		 2],
			["BonusAmmoChest",	 4],
			["BonusHealthChest", 3]
		];
		
		return id;
	}
	

#define ButtonPickup_create(_x, _y)
	with(obj_create(_x, _y, "ButtonChest")){
		 // Visual:
		spr_debris = spr.ButtonPickupDebris;
		spr_shadow = mskNone;
		sprite_index = spr.ButtonPickup;
		
		 // Vars:
		mask_index = mskPickup;
		payout_pool = [
			[AmmoPickup,		  3],
			["BonusAmmoPickup",	  4],
			["BonusHealthPickup", 3]
		];
		
		return id;
	}

#define ButtonReviveArea_create(_x, _y)
	sound_play_hit(sndFreakPopoReviveArea, 0.2);
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.ButtonReviveArea;
		image_speed = 0.4;
		
		 // Vars:
		object_name = Bandit;
		num_objects = 1;
		object_vars = {};
		
		 // Alarms:
		alarm0 = random_range(30, 50);
		
		return id;
	}
	
#define ButtonReviveArea_alrm0
	 // Create:
	repeat(num_objects){
		var o = obj_create(x, y, object_name),
			n = lq_size(object_vars);
			
		 // Variable Time:
		if(instance_exists(o) && n > 0){
			for(var i = 0; i < n; i++){
				var _var = lq_get_key(object_vars, i),
					_val = lq_get_value(object_vars, i);
					
				variable_instance_set(o, _var, _val);
			}
		}
	}
	
	 // Effects:
	sound_play_hit(sndFreakPopoRevive, 0.2);
	with(instance_create(x, y, ReviveFX)){
		sprite_index = spr.ButtonRevive;
	}
	
	 // Goodbye:
	instance_destroy();
	
	
#define FreakChamber_create(_x, _y)
	/*
		Creates an epic room on the side of the level that opens to release freaks
		Waits for a certain amount of enemies to be killed or for the Player to pass nearby before spawning
		
		Vars:
			image_xscale - Room's width
			image_yscale - Room's height
			hallway_size - Hallway's length
			type         - The type of room to create: "Freak", "Explo", "Rhino", "Vat"
			obj          - The freak object to create
			num          - How many freak objects to create
			enemies      - How many enemies existed on creation
			spawnmoment  - Opens when this percentage of enemies are left
			open         - Can the room open anywhere, true/false
			setup        - Perform type-specific setup code, true/false
			alarm0       - Delay before opening, is set when a Player passes nearby
			slide_path   - The sliding door's path, see 'WallSlide_create()'
			               The direction value is altered based on the room's angle
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		mask_index = mskFloor;
		image_xscale = 1;
		image_yscale = 1;
		hallway_size = 1;
		type = pool({
			"Freak" : 8,
			"Rhino" : 4,
			"Explo" : 4,
			"Vat"   : 1
		});
		obj = -1;
		num = 1;
		enemies = instance_number(enemy);
		spawnmoment = random_range(0.3, 0.9);
		open = false;
		setup = true;
		slide_path = [
			[30,  0, 0, [sndToxicBoltGas,  0.4 + random(0.1), 1  ]], // Delay
			[16,  0, 1, [sndTurretFire,    0.3 + random(0.1), 0.9]], // Inset
			[10,  0, 0, [sndToxicBoltGas,  0.3 + random(0.1), 0.5]], // Delay
			[16, 90, 1, [sndSwapMotorized, 0.5 + random(0.1), 1  ]]  // Open
		];
		
		return id;
	}
	
#define FreakChamber_setup
	setup = false;
	
	 // Type Setup:
	switch(type){
		case "Freak":
			obj = Freak;
			var _num = num;
			num *= (1 + GameCont.loops) * 2;
			image_xscale *= 1 + ceil(num / 8);
			num += irandom_range(2, 6) * _num;
			break;
			
		case "Explo":
			obj = ExploFreak;
			num *= 1 + ceil(GameCont.loops / 2);
			image_xscale *= 1 + ceil((num - 4) / 12);
			image_yscale *= 1 + ceil((num - 4) / 12);
			break;
			
		case "Rhino":
			obj = RhinoFreak;
			num *= 1 + ceil(GameCont.loops / 2);
			image_xscale *= 1 + floor(num * 2/3);
			break;
			
		case "Vat":
			obj = Necromancer;
			image_xscale *= 3;
			image_yscale *= 3;
			hallway_size *= irandom_range(1, 3);
			break;
	}
	
#define FreakChamber_step
	if(setup) FreakChamber_setup();
	
	 // Force Spawn:
	if(instance_number(enemy) <= enemies * spawnmoment){
		if(!open){
			open = true;
			alarm0 = (instance_exists(enemy) ? 30 : 1);
		}
	}
	
	 // Wait for Nearby Player:
	else if(alarm0 < 0 && instance_exists(Player)){
		var _target = instance_nearest(x, y, Player);
		if(open || (instance_seen(x, y, _target) && instance_near(x, y, _target, 96))){
			alarm0 = 60;
		}
	}
	
	 // Synchronize:
	if(alarm0 > 0){
		with(instances_matching_gt(instances_matching(object_index, "name", name), "alarm0", 0)){
			if(alarm0 < other.alarm0){
				other.alarm0 = alarm0;
			}
			else{
				alarm0 = other.alarm0;
			}
		}
	}
	
#define FreakChamber_alrm0
	alarm0 = 60;
	
	if(instance_exists(Player)){
		var	_open       = false,
			_ang        = round(random(360) / 90) * 90,
			_target     = instance_nearest(x, y, Player),
			_hallDis    = 32 * hallway_size,
			_slidePath  = slide_path;
			
		 // Sort Potential Spawn Positions by Distance:
		var	_fw = 32,
			_fh = 32,
			_spawnFloor = [];
			
		with(Floor){
			for(var _fx = bbox_left; _fx < bbox_right + 1; _fx += 16){
				for(var _fy = bbox_top; _fy < bbox_bottom + 1; _fy += 16){
					var	_cx = _fx + (_fw / 2),
						_cy = _fy + (_fh / 2);
						
					if(!collision_rectangle(_fx, _fy, _fx + _fw - 1, _fy + _fh - 1, Wall, false, false)){
						if(other.open || instance_seen(_cx, _cy, _target)){
							array_push(_spawnFloor, [
								max(64 * (1 + instance_is(self, FloorExplo)), point_distance(_cx, _cy, _target.x, _target.y)) + random(32),
								{
									x : _cx,
									y : _cy,
									w : _fw,
									h : _fh
								}
							]);
						}
					}
				}
			}
		}
		array_sort_sub(_spawnFloor, 0, true);
		
		 // Create Room:
		with(_spawnFloor){
			var _floor = self[1];
			with(other){
				for(var _dir = _ang; _dir < _ang + 360; _dir += 90){
					var	_fx = _floor.x + lengthdir_x(_floor.w / 2, _dir),
						_fy = _floor.y + lengthdir_y(_floor.h / 2, _dir);
						
					if(!position_meeting(_fx + dcos(_dir), _fy - dsin(_dir), Floor)){
						var	_hallW = max(1, abs(lengthdir_x(_hallDis / 32, _dir))),
							_hallH = max(1, abs(lengthdir_y(_hallDis / 32, _dir))),
							_hallX = _fx + lengthdir_x(_hallDis / 2, _dir),
							_hallY = _fy + lengthdir_y(_hallDis / 2, _dir),
							_hallXOff = lengthdir_x(32, _dir),
							_hallYOff = lengthdir_y(32, _dir);
							
						if(
							array_length(instance_rectangle_bbox(
								_hallX - (_hallW * 16) + max(0, _hallXOff),
								_hallY - (_hallH * 16) + max(0, _hallYOff),
								_hallX + (_hallW * 16) + min(0, _hallXOff) - 1,
								_hallY + (_hallH * 16) + min(0, _hallYOff) - 1,
								[Floor, Wall, TopSmall, TopPot, Bones]
							)) <= 0
						){
							var _yoff = -(sprite_get_height(mask_index) * image_yscale) / 2;
							x = _fx + lengthdir_x(_hallDis, _dir) + lengthdir_x(_yoff, _dir - 90);
							y = _fy + lengthdir_y(_hallDis, _dir) + lengthdir_y(_yoff, _dir - 90);
							
							image_angle = _dir;
							
							if(!place_meeting(x, y, Floor) && !place_meeting(x, y, Wall) && !place_meeting(x, y, TopSmall) && !place_meeting(x, y, TopPot) && !place_meeting(x, y, Bones)){
								var	_x = bbox_center_x,
									_y = bbox_center_y,
									_w = bbox_width  / 32,
									_h = bbox_height / 32;
									
								 // Store Walls:
								var	_wall = [],
									_tops = [];
									
								with(instance_rectangle_bbox(_hallX - (_hallW * 16), _hallY - (_hallH * 16), _hallX + (_hallW * 16) - 1, _hallY + (_hallH * 16) - 1, Wall)){
									array_push(_wall, variable_instance_get_list(self));
									instance_delete(id);
								}
								with(instance_rectangle_bbox(_hallX - (_hallW * 16) - 16, _hallY - (_hallH * 16) - 16, _hallX + (_hallW * 16) + 16 - 1, _hallY + (_hallH * 16) + 16 - 1, TopSmall)){
									array_push(_tops, variable_instance_get_list(self));
									instance_delete(id);
								}
								with(instance_rectangle_bbox(bbox_left - 16, bbox_top - 16, bbox_right + 16 - 1, bbox_bottom + 16 - 1, TopSmall)){
									array_push(_tops, variable_instance_get_list(self));
									instance_delete(id);
								}
								
								 // Generate Room:
								floor_set_style(1, null);
								
								var	_minID = GameObject.id,
									_floorHall = floor_fill(_hallX, _hallY, _hallW, _hallH, ""),
									_floorMain = floor_fill(_x, _y, _w, _h, "");
									
								floor_reset_style();
								
								 // Transition Walls:
								with(instances_matching_gt(Wall, "id", _minID)){
									topspr = area_get_sprite(GameCont.area, sprWall1Trans);
									if(sprite_index == sprWall6Bot) sprite_index = spr.Wall6BotTrans;
								}
								
								 // Details:
								with(instances_matching_gt(Floor, "id", _minID)){
									if(chance(1, 5)){
										var s = styleb;
										styleb = false;
										instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Detail);
										styleb = s;
									}
									depth = 10;
								}
								
								 // Reveal Tiles:
								with(instances_matching_gt([Floor, Wall, TopSmall], "id", _minID)){
									var _reveal = true;
									
									 // Don't Cover Doors:
									if(array_exists(_floorHall, id)){
										with(_wall){
											if(rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, other.bbox_left, other.bbox_top, other.bbox_right, other.bbox_bottom)){
												_reveal = false;
												break;
											}
										}
									}
									
									 // Don't Cover Pre-Existing TopSmalls:
									if(instance_is(self, Wall) || instance_is(self, TopSmall)){
										with(_tops){
											if(x == other.x && y == other.y){
												_reveal = false;
												break;
											}
										}
									}
									
									 // Reveal:
									if(_reveal){
										with(floor_reveal(bbox_left, bbox_top, bbox_right, bbox_bottom, 10)){
											flash = false;
											flash_color = color;
											
											 // Delay:
											for(var i = 0; i < min(2, array_length(_slidePath)); i++){
												time += _slidePath[i, 0];
											}
										}
									}
								}
								
								 // Freaks:
								if((is_real(obj) && object_exists(obj)) || is_string(obj)){
									for(var i = 0; i < num; i++){
										with(_floorMain[floor(((i + random(1)) / num) * array_length(_floorMain))]){
											with(obj_create(bbox_center_x + orandom(4), bbox_center_y + orandom(4), other.obj)){
												if(instance_is(self, enemy)){
													walk = true;
													direction = random(360);
													for(var j = 0; j < array_length(_slidePath); j++){
														alarm1 += _slidePath[j, 0];
													}
												}
											}
										}
									}
								}
								
								 // Type-Specific:
								switch(type){
									case "Explo":
										 // Scorchmarks:
										with(_floorMain) if(chance(1, 3)){
											with(instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Scorchmark)){
												sprite_index = spr.FirePitScorch;
												image_index = irandom(image_number - 1);
												image_speed = 0;
												image_angle = random(360);
											}
										}
										break;
										
									case "Vat":
										obj_create(_x, _y - 4, "MutantVat");
										instance_create(_x + choose(-32, 32), _y - 2 + choose(-32, 32), Terminal);
										break;
								}
								
								 // Sliding Doors:
								with(_tops){
									var _wallOverride = instances_matching(instances_matching(Wall, "x", x), "y", y);
									
									 // Resprite Walls/TopSmalls:
									if(array_length(_wallOverride) > 0){
										with(_wallOverride){
											if(instance_is(self, Wall)){
												topspr   = other.sprite_index;
												topindex = other.image_index;
											}
											else{
												sprite_index = other.sprite_index;
												image_index  = other.image_index;
											}
										}
									}
									
									 // Create TopSmall Wall:
									else with(instance_create(x, y, Wall)){
										topspr = other.sprite_index;
										topindex = other.image_index;
										image_blend = other.image_blend;
										image_alpha = other.image_alpha;
										
										 // Resprite:
										if(sprite_index == sprWall6Bot){
											sprite_index = spr.Wall6BotTrans;
										}
										
										 // Slide:
										with(obj_create(x, y, "WallSlide")){
											slide_inst = [other];
											slide_path = array_clone_deep(_slidePath);
											
											 // Adjust Direction / Movement:
											with(other){
												var _slideSide = sign(angle_difference(_dir, point_direction(bbox_center_x, bbox_center_y, _x, _y)));
												with(other.slide_path){
													self[@1] = _dir + (self[1] * _slideSide);
												}
												other.slide_path[1, 2] = 0;
											}
										}
									}
								}
								with(_wall){
									with(instance_create(x, y, object_index)){
										variable_instance_set_list(self, other);
										depth = min(depth, -1);
										
										 // Resprite:
										if(sprite_index == sprWall6Bot && !visible){
											sprite_index = spr.Wall6BotTrans;
										}
										
										 // Slide:
										with(obj_create(x, y, "WallSlide")){
											slide_inst = [other];
											slide_path = array_clone_deep(_slidePath);
											smoke = 1/5;
											
											 // Adjust Direction:
											with(other){
												var _slideSide = sign(angle_difference(_dir, point_direction(bbox_center_x, bbox_center_y, _x, _y)));
												with(other.slide_path){
													self[@1] = _dir + (self[1] * _slideSide);
												}
											}
										}
									}
								}
								
								_open = true;
								break;
							}
						}
					}
				}
			}
			
			if(_open) break;
		}
		
		 // Case Closed:
		if(_open){
			instance_destroy();
			if(instance_exists(enemy)) portal_poof();
		}
	}
	
	
#define MutantVat_create(_x, _y)
	/*
		A giant version of the MutantTube, which can contain special enemies or loot
	*/
	
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle = spr.MutantVatIdle;
		spr_hurt = spr.MutantVatHurt;
		spr_dead = spr.MutantVatDead;
		spr_back = spr.MutantVatBack;
		spr_shadow = shd64B;
		spr_shadow_y = 12;
		sprite_index = spr_idle;
		depth = -1;
		
		 // Sounds:
		snd_hurt = sndLabsTubeBreak;
		snd_dead = sndLabsMutantTubeBreak;
		
		 // Vars:
		mask_index = -1;
		maxhealth = 50;
		raddrop = 4;
		size = 3;
		team = 1;
		wave = random(100);
		setup = true;
		
		 // Vat Pool:
		var _pool = [
			 // Danger:
			[Freak,            3],
			["FishFreak",      2],
			["Angler",         3],
			["PortalGuardian", 3],
			[PopoFreak,        2],
			["CrystalHeart",   1],
			[Bandit,           1],
			
			 // Loot:
			[WeaponChest,      1],
			["Backpack",       1]
		];
		if(unlock_get("crown:crime")){
			array_push(_pool, [choose("CatChest", "BatChest"), 1]);
		}
		
		 // :
		thing = {};
		with(thing){
			type = pool(_pool);
			color = make_color_rgb(40, 87, 9);
			index = -1;
			sprite = mskNone;
			right = choose(1, -1);
			wep = wep_none;
			pet_data = {};
			with(pet_data){
				pet_name = "";
				mod_type = "mod";
				mod_name = "petlib";
			}
		}
		
		 // Alarms:
		alarm1 = -1;
		alarm2 = -1;
		
		return id;
	}
	
#define MutantVat_setup
	setup = false;
	
	var	_x = x,
		_y = y,
		_canWatch = false;
		
	with(thing){
		switch(type){
			case "MergedWep":
				wep = wep_revolver;
				var _part = wep_merge_decide(0, GameCont.hard);
				if(array_length(_part) >= 2){
					wep = wep_merge(_part[0], _part[1]);
				}
				sprite = weapon_get_sprite(wep);
				break;
				
			case Freak:
				sprite = sprFreak1Idle;
				_canWatch = true;
				break;
				
			case "FishFreak":
				sprite = spr.FishFreakIdle;
				_canWatch = true;
				break;
				
			case "Angler":
				sprite = sprRadChest;
				break;
				
			case "PortalGuardian":
				sprite = spr.PortalGuardianIdle;
				_canWatch = true;
				break;
				
			case PopoFreak:
				sprite = sprPopoFreakIdle;
				_canWatch = true;
				break;
				
			case "CrystalHeart":
				sprite = spr.CrystalHeartIdle;
				break;
				
			case Bandit:
				sprite = sprBanditHurt;
				break;
				
			case WeaponChest:
				sprite = sprWeaponChest;
				break;
				
			case "Backpack":
			case "CatChest":
			case "BatChest":
				sprite = lq_get(spr, type);
				break;
				
			 // Labs Event Exclusive:
			case "Pet":
				_canWatch = true;
				/*
				with(obj_create(_x, _y - 20, "CatLight")){
					w1 *= 2;
					w2 *= 3/2;
					h1 *= 7/6;
					h2 *= 2;
				}
				*/
				break;
		}
	}
	
	 // Ever Vigilant:
	if(_canWatch){
		alarm2 = 90;
	}
	
#define MutantVat_step
	if(setup) MutantVat_setup();
	wave += current_time_scale;
	x = xstart;
	y = ystart;

	 // Draw Back:
	script_bind_draw(MutantVat_draw_back, depth + 1/100, id);
	
#define MutantVat_draw_back(_inst)
	with(_inst){
		var _imageIndex = (wave * image_speed);
		draw_sprite_ext(spr_back, _imageIndex, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		
		 // Draw Thing:
		var _oc  = chance(1, 30),
			_ol  = 2,
			_od  = random(360),
			_ox  = _oc * lengthdir_x(_ol, _od),
			_oy  = _oc * lengthdir_y(_ol, _od),
			_spr = thing.sprite,
			_img = ((thing.index == -1) ? _imageIndex : thing.index),
			_x   = x + _ox + (sin(wave / 10) * 2),
			_y   = y + _oy + (cos(wave / 10) * 3),
			_xsc = (image_xscale * thing.right),
			_ysc = image_yscale,
			_ang = image_angle + sin(wave / 30) * 30,
			_col = c_white,
			_alp = image_alpha;
			
		draw_set_fog(true, thing.color, 0, 0);
		draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
		draw_set_fog(false, c_white, 0, 0);
	}
	
	 // Goodbye:
	instance_destroy();
	
#define MutantVat_alrm1
	alarm1 = 10 + random(10);
	
	projectile_hit_np(id, 10, 0, 0);
	view_shake_max_at(x, y, 10);
	with(instance_create(x + orandom(15), y + orandom(20), SmokeOLD)){
		sprite_index = sprExploderExplo;
		image_index = 1;
		depth = other.depth - 1;
		repeat(2 + irandom(2)){
			instance_create(x + orandom(6), y + orandom(6), Smoke);
		}
	}
	
#define MutantVat_alrm2
	alarm2 = 30 + random(60);
	
	with(instance_seen(x, y, Player)){
		other.thing.right = ((other.x > x) ? -1 : 1);
	}
	
#define MutantVat_death
	 // Effects:
	repeat(24){
		with(instance_create(x, y, Shell)){
			sprite_index = spr.MutantVatGlass;
			image_index = irandom(image_number - 1);
			image_speed = 0;
			motion_set(random(360), random_range(2, 6));
			x += hspeed;
			y += vspeed;
		}
	}
	with(obj_create(x, y, "BuriedVaultChestDebris")){
		sprite_index = spr.MutantVatLid;
		mask_index = mskExploder;
		zfriction /= 2;
		zspeed *= 2/3;
		bounce = irandom_range(1, 2);
		snd_land = sndTechnomancerHurt;
	}
	repeat(12){
		with(instance_create(x + orandom(20), y - irandom(25), AcidStreak)){
			image_angle = 270;
			image_index = random(2);
		}
	}
	repeat(24){
		var	c = random(1),
			l = (48 * c),
			d = random(360);

		with(instance_create(x + lengthdir_x(l, d), (y + 16) + lengthdir_y(l, d), SmokeOLD)){
			sprite_index = sprExploderExplo;
			image_index = 2 + (3 * (1 - c));
			motion_set(d, 2);
		}
	}
	
	 // Drops:
	var _x = x,
		_y = y,
		_minID = GameObject.id;
		
	with(thing){
		var _wep = wep;
		
		switch(type){
			case Bandit:
			case Freak:
			case PopoFreak:
			case "PortalGuardian":
				obj_create(_x, _y, type);
				break;
				
			case WeaponChest:
			case "OrchidChest":
			case "Backpack":
			case "CatChest":
			case "BatChest":
				chest_create(_x, _y, type, false);
				break;
				
			case "MergedWep":
				with(instance_create(_x, _y, WepPickup)){
					wep = _wep;
				}
				break;
				
			case "FishFreak":
				with(instance_create(_x, _y, Freak)){
					fish_freak = true;
					spr_idle = spr.FishFreakIdle;
					spr_walk = spr.FishFreakWalk;
					spr_hurt = spr.FishFreakHurt;
					spr_dead = spr.FishFreakDead;
				}
				break;
				
			/*
			case PopoFreak:
				instance_create(_x, _y, type);
				repeat(2) instance_create(_x, _y, IDPDSpawn);
				with(instance_create(_x, _y - 16, type)){
					my_health = 0;
					with(self) event_perform(ev_destroy, 0);
				}
				
				 // Quality Assurance:
				with(instances_matching_gt(WantRevivePopoFreak, "id", _minID)){
					alarm0 = 120;
				}
				with(instances_matching_gt([PopoNade, IDPDPortalCharge], "id", _minID)){
					instance_delete(id);
				}
				break;
				*/
				
			case "Angler":
				with(obj_create(_x, _y, type)){
					with(self){
						event_perform(ev_step, ev_step_normal);
					}
				}
				break;
				
			case "CrystalHeart":
				with(obj_create(_x, _y - 16, type)){
					my_health = 0;
					with(self) event_perform(ev_destroy, 0);
				}
				break;
				
			 // Labs Event Exclusive:
			case "Pet":
				with(pet_data){
					var _petVars = pet_vars;
					with(mod_script_call("mod", "telib", "pet_create", _x, _y, pet_name, mod_type, mod_name)){
						var _lastIcon = spr_icon;
						for(var i = 0; i < lq_size(_petVars); i++){
							var k = lq_get_key(_petVars, i),
								o = lq_get(_petVars, k);
							
							 // Inherit:	
							variable_instance_set(id, k, o);
						}
						
						 // New Icon:
						var _newIcon = string(spr_icon);
						with(pickup_indicator){
							text = string_replace(text, string(_lastIcon), _newIcon);
						}
						
						 // Quality Assurance:
						team = 2;
					}
				}
				break;
		}
	}
	
	/*
	 // Open the Floodgates:
	with(instances_matching(object_index, "name", name)){
		if(self != other){
			alarm1 += random(10);
			
			 // Effects:
			repeat(8){
			instance_create(x + orandom(20), y + orandom(25), PortalL);
			}
		}
	}
	*/
	
	
#define PickupReviveArea_create(_x, _y)
	sound_play_hit(sndFreakPopoReviveArea, 0.2);
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.PickupReviveArea;
		image_speed = 0.4;
		
		 // Vars:
		pickup = noone;
		
		 // Alarms:
		alarm0 = 15;
		
		return id;
	}
	
#define PickupReviveArea_alrm0
	 // Open Button Pickups:
	if(instance_exists(pickup)){
		with(pickup){
			var _sprt = spr_debris,
				_pool = payout_pool;
				
			if(array_length(_pool) > 0){
				
				 // Chest:
				chest_create(x, y, pool(_pool), false);
				
				 // Casing:
				for(var i = 0; i < sprite_get_number(_sprt); i++){
					with(instance_create(x, y, Debris)){
						sprite_index = _sprt;
						image_index = i;
						friction = 0.6;
						depth = other.depth + 1;
						motion_set(random(360), 4);
						
						var l = (sprite_get_width(_sprt) + sprite_get_height(_sprt)) / 4;
						x += lengthdir_x(l, direction);
						y += lengthdir_y(l, direction);
					}
				}
				
				 // Goodbye:
				instance_destroy();
			}
		}
	}
	
	 // New Button Pickup:
	else{
		var o = (chance(1, 5) ? "ButtonChest" : "ButtonPickup");
		obj_create(x, y, o);
	}
	
	 // Effects:
	sound_play_hit(sndFreakPopoRevive, 0.2);
	with(instance_create(x, y, ReviveFX)){
		sprite_index = spr.PickupRevive;
	}
	
	 // Goodbye:
	instance_destroy();
	

#define WallSlide_create(_x, _y)
	/*
		A controller that slides Walls around
		
		Vars:
			slide_inst  - An array containing the Wall instances to slide
			slide_path  - A 2D array containing values: [time, direction, speed, sound]
			              Leaving out direction or speed will maintain the current value
			              Sound can be in the form of an index, or an array of [snd, pit, vol]
			slide_index - The current index of 'slide_path' that the walls is following
			slide_loop  - Should the walls continue sliding on their path forever, true/false
			slide_time  - Number of frames until the next sliding motion
			smoke       - Chance to create Smoke, used for Labs freak dispensers
			
		Ex:
			with(obj_create(x, y, "WallSlide")){
				slide_inst = [
					instance_create(x, y, Wall)
				];
				slide_path = [
					[16, 90   ], // Move up 16
					[90,  0, 0], // Wait 3 seconds
					[32,  0, 1]  // Move right 32
				];
			}
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		slide_inst  = [];
		slide_path  = [];
		slide_index = -1;
		slide_loop  = false;
		slide_time  = 0;
		smoke       = 0;
		direction   = 0;
		speed       = 1;
		
		return id;
	}
	
#define WallSlide_end_step
	slide_inst = instances_matching(slide_inst, "", null);
	
	if(array_length(slide_inst) > 0){
		 // Next:
		if(slide_time > 0) slide_time -= current_time_scale;
		if(slide_time <= 0){
			 // Tile Override:
			with(slide_inst){
				if(position_meeting(x, y, Wall) || position_meeting(x, y, TopSmall)){
					with(instances_matching_lt(instances_matching(instances_matching(Wall, "x", x), "y", y), "id", id)){
						var _inst = other;
						with(["image_blend", "topspr", "topindex", "l", "h", "w", "r"]){
							variable_instance_set(_inst, self, variable_instance_get(other, self));
						}
						instance_delete(id);
					}
				}
			}
			
			 // Next:
			var _pathTries = array_length(slide_path);
			while(slide_time <= 0){
				slide_index++;
				
				 // Start Again:
				if(slide_loop){
					slide_index %= array_length(slide_path);
				}
				
				 // Grab Values:
				if(
					_pathTries-- > 0
					&& slide_index >= 0
					&& slide_index < array_length(slide_path)
				){
					var _current = slide_path[slide_index];
					if(array_length(_current) > 0) slide_time = _current[0];
					if(array_length(_current) > 1) direction  = _current[1];
					if(array_length(_current) > 2) speed      = _current[2];
					
					 // Sound:
					if(array_length(_current) > 3){
						var _snd = _current[3];
						if(is_array(_snd)){
							sound_play_hit_ext(_snd[0], _snd[1], _snd[2]);
						}
						else{
							sound_play_hit(_snd, 0);
						}
					}
				}
				
				 // Done:
				else{
					instance_destroy();
					exit;
				}
			}
		}
		
		 // Slide Walls:
		var	_mx = hspeed_raw,
			_my = vspeed_raw;
			
		with(slide_inst){
			x += _mx;
			y += _my;
			
			if(_mx != 0 || _my != 0){
				 // Collision:
				if(place_meeting(x, y, hitme)){
					with(instances_meeting(x, y, hitme)){
						if(place_meeting(x, y, other)){
							if(!place_meeting(x + _mx, y, Wall)) x += _mx;
							if(!place_meeting(x, y + _my, Wall)) y += _my;
						}
					}
				}
				
				 // Shake:
				view_shake_max_at(bbox_center_x, bbox_center_y, 3);
			}
			
			 // Visual:
			depth = min(depth, -1);
			visible = place_meeting(x, y + 16, Floor);
			l = 0;
			r = 0;
			w = 24;
			h = 24;
			
			 // Effects:
			if(other.smoke > 0 && chance_ct(other.smoke, 1)){
				scrFX(bbox_center_x, bbox_center_y, [other.direction + 180, 2], Smoke);
			}
		}
	}
	else instance_destroy();
	
#define WallSlide_destroy
	 // Visual Fix:
	with(instances_matching(slide_inst, "", null)){
		depth = max(depth, 0);
		visible = place_meeting(x, y + 16, Floor);
		l = (place_free(x - 16, y) ?  0 :  4);
		w = (place_free(x + 16, y) ? 24 : 20) - l;
		r = (place_free(x, y - 16) ?  0 :  4);
		h = (place_free(x, y + 16) ? 24 : 20) - r;
	}
	
	
/// GENERAL
#define ntte_begin_step
	 // Weapon Necromancy:
	with(instances_matching_gt(instances_matching_le(ReviveArea, "alarm0", ceil(current_time_scale)), "alarm0", 0)){
		if(place_meeting(x, y, WepPickup)){
			with(instances_meeting(x, y, WepPickup)){
				if(point_distance(x, y, other.x, other.y - 2) < (other.sprite_width * 0.4)){
					if(weapon_get_area(wep) >= 0 && wep_get(wep) != "merge"){
						var _part = wep_merge_decide(0, GameCont.hard + (2 * curse));
						if(array_length(_part) >= 2){
							wep = wep_merge(_part[0], _part[1]);
							mergewep_indicator = null;
							
							 // FX:
							sound_play_hit_ext(sndNecromancerRevive, 1, 1.8);
							sound_play_pitchvol(sndGunGun, 0.5 + orandom(0.1), 0.5);
							sound_play_pitchvol(sprEPickup, 0.5 + orandom(0.1), 0.5);
							sound_play_hit_ext(sndNecromancerDead, 1.5 + orandom(0.1), 1.2);
							with(instance_create(x, y + 2, ReviveFX)){
								sprite_index = spr.PickupRevive; // sprPopoRevive;
								image_xscale = 0.8;
								image_yscale = image_xscale;
								// image_blend = make_color_rgb(100, 255, 50);
								depth = -2;
							}
						}
					}
				}
			}
		}
	}
	
#define ntte_end_step
	 // Fish Freaks:
	if(GameCont.loops > 0 && GameCont.area == area_labs){
		with(instances_matching(Freak, "fish_freak", null)){
			fish_freak = chance(1, 7);
			if(fish_freak){
				spr_idle = spr.FishFreakIdle;
				spr_walk = spr.FishFreakWalk;
				spr_hurt = spr.FishFreakHurt;
				spr_dead = spr.FishFreakDead;
			}
		}
	}
	
	
#define ntte_dark // Drawing Grays
	with(instances_matching(CustomObject, "name", "ButtonReviveArea")){
		draw_circle(x, y, 64 + irandom(2), false);
	}
	
#define ntte_dark_end // Drawing Clear
	with(instances_matching(CustomObject, "name", "ButtonReviveArea")){
		draw_circle(x, y, 32 + irandom(2), false);
	}
	
	
/// SCRIPTS
#macro  area_campfire                                                                           0
#macro  area_desert                                                                             1
#macro  area_sewers                                                                             2
#macro  area_scrapyards                                                                         3
#macro  area_caves                                                                              4
#macro  area_city                                                                               5
#macro  area_labs                                                                               6
#macro  area_palace                                                                             7
#macro  area_vault                                                                              100
#macro  area_oasis                                                                              101
#macro  area_pizza_sewers                                                                       102
#macro  area_mansion                                                                            103
#macro  area_cursed_caves                                                                       104
#macro  area_jungle                                                                             105
#macro  area_hq                                                                                 106
#macro  area_crib                                                                               107
#macro  infinity                                                                                1/0
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  anim_end                                                                                image_index + image_speed_raw >= image_number
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
#macro  enemy_boss                                                                              ('boss' in self && boss) || array_exists([BanditBoss, ScrapBoss, LilHunter, Nothing, Nothing2, FrogQueen, HyperCrystal, TechnoMancer, Last, BigFish, OasisBoss], object_index)
#macro  player_active                                                                           visible && !instance_exists(GenCont) && !instance_exists(LevCont) && !instance_exists(SitDown) && !instance_exists(PlayerSit)
#macro  game_scale_nonsync                                                                      game_screen_get_width_nonsync() / game_width
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
#define save_get(_name, _default)                                                       return  mod_script_call_nc('mod', 'teassets', 'save_get', _name, _default);
#define save_set(_name, _value)                                                                 mod_script_call_nc('mod', 'teassets', 'save_set', _name, _value);
#define option_get(_name)                                                               return  mod_script_call_nc('mod', 'teassets', 'option_get', _name);
#define option_set(_name, _value)                                                               mod_script_call_nc('mod', 'teassets', 'option_set', _name, _value);
#define stat_get(_name)                                                                 return  mod_script_call_nc('mod', 'teassets', 'stat_get', _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc('mod', 'teassets', 'stat_set', _name, _value);
#define unlock_get(_name)                                                               return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _name);
#define unlock_set(_name, _value)                                                       return  mod_script_call_nc('mod', 'teassets', 'unlock_set', _name, _value);
#define surface_setup(_name, _w, _h, _scale)                                            return  mod_script_call_nc('mod', 'teassets', 'surface_setup', _name, _w, _h, _scale);
#define shader_setup(_name, _texture, _args)                                            return  mod_script_call_nc('mod', 'teassets', 'shader_setup', _name, _texture, _args);
#define shader_add(_name, _vertex, _fragment)                                           return  mod_script_call_nc('mod', 'teassets', 'shader_add', _name, _vertex, _fragment);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define top_create(_x, _y, _obj, _spawnDir, _spawnDis)                                  return  mod_script_call_nc('mod', 'telib', 'top_create', _x, _y, _obj, _spawnDir, _spawnDis);
#define chest_create(_x, _y, _obj, _levelStart)                                         return  mod_script_call_nc('mod', 'telib', 'chest_create', _x, _y, _obj, _levelStart);
#define trace_error(_error)                                                                     mod_script_call_nc('mod', 'telib', 'trace_error', _error);
#define view_shift(_index, _dir, _pan)                                                          mod_script_call_nc('mod', 'telib', 'view_shift', _index, _dir, _pan);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc('mod', 'telib', 'sleep_max', _milliseconds);
#define instance_seen(_x, _y, _obj)                                                     return  mod_script_call_nc('mod', 'telib', 'instance_seen', _x, _y, _obj);
#define instance_near(_x, _y, _obj, _dis)                                               return  mod_script_call_nc('mod', 'telib', 'instance_near', _x, _y, _obj, _dis);
#define instance_budge(_objAvoid, _disMax)                                              return  mod_script_call(   'mod', 'telib', 'instance_budge', _objAvoid, _disMax);
#define instance_random(_obj)                                                           return  mod_script_call_nc('mod', 'telib', 'instance_random', _obj);
#define instance_clone()                                                                return  mod_script_call(   'mod', 'telib', 'instance_clone');
#define instance_nearest_array(_x, _y, _inst)                                           return  mod_script_call_nc('mod', 'telib', 'instance_nearest_array', _x, _y, _inst);
#define instance_nearest_bbox(_x, _y, _inst)                                            return  mod_script_call_nc('mod', 'telib', 'instance_nearest_bbox', _x, _y, _inst);
#define instance_nearest_rectangle(_x1, _y1, _x2, _y2, _inst)                           return  mod_script_call_nc('mod', 'telib', 'instance_nearest_rectangle', _x1, _y1, _x2, _y2, _inst);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc('mod', 'telib', 'instance_rectangle', _x1, _y1, _x2, _y2, _obj);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call_nc('mod', 'telib', 'instance_rectangle_bbox', _x1, _y1, _x2, _y2, _obj);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call_nc('mod', 'telib', 'instances_at', _x, _y, _obj);
#define instances_seen_nonsync(_obj, _bx, _by)                                          return  mod_script_call_nc('mod', 'telib', 'instances_seen_nonsync', _obj, _bx, _by);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   'mod', 'telib', 'instances_meeting', _x, _y, _obj);
#define variable_instance_get_list(_inst)                                               return  mod_script_call_nc('mod', 'telib', 'variable_instance_get_list', _inst);
#define variable_instance_set_list(_inst, _list)                                                mod_script_call_nc('mod', 'telib', 'variable_instance_set_list', _inst, _list);
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call_nc('mod', 'telib', 'draw_weapon', _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call_nc('mod', 'telib', 'draw_lasersight', _x, _y, _dir, _maxDistance, _width);
#define draw_surface_scale(_surf, _x, _y, _scale)                                               mod_script_call_nc('mod', 'telib', 'draw_surface_scale', _surf, _x, _y, _scale);
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
#define boss_intro(_name)                                                               return  mod_script_call_nc('mod', 'telib', 'boss_intro', _name);
#define corpse_drop(_dir, _spd)                                                         return  mod_script_call(   'mod', 'telib', 'corpse_drop', _dir, _spd);
#define rad_drop(_x, _y, _raddrop, _dir, _spd)                                          return  mod_script_call_nc('mod', 'telib', 'rad_drop', _x, _y, _raddrop, _dir, _spd);
#define rad_path(_inst, _target)                                                        return  mod_script_call_nc('mod', 'telib', 'rad_path', _inst, _target);
#define area_get_name(_area, _subarea, _loop)                                           return  mod_script_call_nc('mod', 'telib', 'area_get_name', _area, _subarea, _loop);
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call(   'mod', 'telib', 'area_get_sprite', _area, _spr);
#define area_get_subarea(_area)                                                         return  mod_script_call_nc('mod', 'telib', 'area_get_subarea', _area);
#define area_get_secret(_area)                                                          return  mod_script_call_nc('mod', 'telib', 'area_get_secret', _area);
#define area_get_underwater(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_underwater', _area);
#define area_border(_y, _area, _color)                                                  return  mod_script_call_nc('mod', 'telib', 'area_border', _y, _area, _color);
#define area_generate(_area, _subarea, _x, _y, _setArea, _overlapFloor, _scrSetup)      return  mod_script_call_nc('mod', 'telib', 'area_generate', _area, _subarea, _x, _y, _setArea, _overlapFloor, _scrSetup);
#define floor_get(_x, _y)                                                               return  mod_script_call_nc('mod', 'telib', 'floor_get', _x, _y);
#define floor_set(_x, _y, _state)                                                       return  mod_script_call_nc('mod', 'telib', 'floor_set', _x, _y, _state);
#define floor_set_style(_style, _area)                                                  return  mod_script_call_nc('mod', 'telib', 'floor_set_style', _style, _area);
#define floor_set_align(_alignX, _alignY, _alignW, _alignH)                             return  mod_script_call_nc('mod', 'telib', 'floor_set_align', _alignX, _alignY, _alignW, _alignH);
#define floor_reset_style()                                                             return  mod_script_call_nc('mod', 'telib', 'floor_reset_style');
#define floor_reset_align()                                                             return  mod_script_call_nc('mod', 'telib', 'floor_reset_align');
#define floor_fill(_x, _y, _w, _h, _type)                                               return  mod_script_call_nc('mod', 'telib', 'floor_fill', _x, _y, _w, _h, _type);
#define floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)                      return  mod_script_call_nc('mod', 'telib', 'floor_room_start', _spawnX, _spawnY, _spawnDis, _spawnFloor);
#define floor_room_create(_x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis)         return  mod_script_call_nc('mod', 'telib', 'floor_room_create', _x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis);
#define floor_room(_spaX, _spaY, _spaDis, _spaFloor, _w, _h, _type, _dirOff, _floorDis) return  mod_script_call_nc('mod', 'telib', 'floor_room', _spaX, _spaY, _spaDis, _spaFloor, _w, _h, _type, _dirOff, _floorDis);
#define floor_reveal(_x1, _y1, _x2, _y2, _time)                                         return  mod_script_call_nc('mod', 'telib', 'floor_reveal', _x1, _y1, _x2, _y2, _time);
#define floor_tunnel(_x1, _y1, _x2, _y2)                                                return  mod_script_call_nc('mod', 'telib', 'floor_tunnel', _x1, _y1, _x2, _y2);
#define floor_bones(_num, _chance, _linked)                                             return  mod_script_call(   'mod', 'telib', 'floor_bones', _num, _chance, _linked);
#define floor_walls()                                                                   return  mod_script_call(   'mod', 'telib', 'floor_walls');
#define wall_tops()                                                                     return  mod_script_call(   'mod', 'telib', 'wall_tops');
#define wall_clear(_x1, _y1, _x2, _y2)                                                          mod_script_call_nc('mod', 'telib', 'wall_clear', _x1, _y1, _x2, _y2);
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
#define pool(_pool)                                                                     return  mod_script_call_nc('mod', 'telib', 'pool', _pool);