#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Gather Objects:
	for(var i = 1; true; i++){
		var _scrName = script_get_name(i);
		if(is_undefined(_scrName)){
			break;
		}
		call(scr.obj_add, script_ref_create(i));
	}
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
	
#define Button_create(_x, _y)
	/*
		A labs event prop.
	*/
	
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle     = spr.ButtonIdle;
		spr_hurt     = spr.ButtonHurt;
		spr_dead     = spr.ButtonDead;
		spr_shadow   = mskNone;
		sprite_index = spr_idle;
		image_speed  = 0.4;
		
		 // Sounds:
		snd_hurt = sndHitMetal;
		snd_dead = sndServerBreak;
		
		 // Vars:
		mask_index = -1;
		maxhealth  = 40;
		raddrop    = 0;
		size       = 2;
		team       = 1;
		prompt     = call(scr.prompt_create, self, " PRESS?", mskReviveArea, 0, -8);
		
		return self;
	}
	
#define Button_step
	if(instance_exists(prompt) && player_is_active(prompt.pick)){
		 // Visual:
		spr_idle = spr.ButtonPressedIdle;
		spr_hurt = spr.ButtonPressedHurt;
		sprite_index = spr_hurt;
		
		 // Effects:
		sound_play(sndCrownAppear);
		with(instance_create(x, y - 10, SmallChestFade)){
			image_blend = make_color_rgb(252, 56, 0);
		}
		
		 // Prompt:
		instance_delete(prompt);
	}
	
	
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
		
		return self;
	}
	

#define ButtonOld_create(_x, _y)
	/*
		Depricated version of the Button object.
	*/

	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		spr_idle = spr.ButtonIdle;
		spr_hurt = spr.ButtonHurt;
		spr_dead = spr.ButtonDead;
		sprite_index = spr_idle;
		spr_shadow = mskNone;
		image_speed = 0.4;
		
		 // Sounds:
		snd_hurt = sndHitMetal;
		snd_dead = sndServerBreak;
		
		 // Vars:
		mask_index   = -1;
		maxhealth    = 120;
		raddrop      = 0;
		size         = 2;
		team         = 1;
		presses      = 0;
		effect_color = make_color_rgb(252, 56, 0);
		prompt       = call(scr.prompt_create, self, "PUSH", mskReviveArea, 0, -8);
		
		 // Alarms:
		alarm0 = -1;
		alarm1 = -1;
		
		return self;
	}
	
#define ButtonOld_step
	 // Alarms:
	if(alarm0_run) exit;
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Stay Still:
	x = xstart;
	y = ystart;
	speed = 0;
	
	 // Animation:
	if(anim_end){
		sprite_index = spr_idle;
	}
	
	 // Press:
	if(instance_exists(prompt) && player_is_active(prompt.pick)){
		 // Visual:
		spr_idle = spr.ButtonPressedIdle;
		spr_hurt = spr.ButtonPressedHurt;
		sprite_index = spr_hurt;
		
		 // Vars:
		presses++;
		alarm0 = 20;
		prompt.visible = false;
		
		 // Close Portal:
		call(scr.portal_poof);
		
		 // Effects and Stuff:
		with(instance_create(x, y - 6, FXChestOpen)){
			image_blend = other.effect_color;
		}
		sound_play(sndIDPDNadeAlmost);
	}
	
	 // Manual Death:
	if(my_health <= 0){
		instance_destroy();
	}
	
#define ButtonOld_destroy
	 // JW's Been Slackin':
	sound_play_hit(snd_dead, 0.2);
	call(scr.corpse_drop, self);
	call(scr.rad_drop, x, y, raddrop, direction, speed);
	
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
	
#define ButtonOld_alrm0
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
		with(instances_matching_ne(call(scr.array_combine, obj.ButtonChest, obj.ButtonPickup), "id")){
			with(call(scr.obj_create, x, y, "PickupReviveArea")){
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
			array_push(_payout, call(scr.pool, _pool));
		}
		if(chance(1, 2)){
			array_push(_payout, "Pickup");
		}
		
		 // Locate Floors:
		var _floors = [];
		with(FloorNormal){
			var _cx = bbox_center_x,
				_cy = bbox_center_y;
				
			if(point_distance(_cx, _cy, other.x, other.y) < 160){
				var _player = instance_nearest(_cx, _cy, Player);
				if(instance_exists(_player) && !collision_line(_cx, _cy, _player.x, _player.y, Wall, false, false)){
					if(!place_meeting(x, y, Wall) && !place_meeting(x, y, other)){
						array_push(_floors, self);
					}
				}
			}
		}
		
		 // Spawn Stuff:
		if(array_length(_floors)){
			var _blacklist = [];
			
			for(var i = 0; i < array_length(_payout); i++){
				
				 // Locate Floor For Real This Time:
				var _floor = noone,
					_tries = 100;
					
				while(_floor == noone && _tries-- > 0){
					with(call(scr.instance_random, _floors)){
						if(array_find_index(_blacklist, self) < 0){
							_floor = self;
							array_push(_blacklist, _floor);
						}
					}
				}
					
				if(instance_exists(_floor)){
					var _x = _floor.x + 16,
						_y = _floor.y + 16;
						
					switch(_payout[i]){
						case "FreakChamber":
							with(call(scr.obj_create, x, y, "FreakChamber")){
								alarm0 = 10;
							}
							break;
							
						case "Turret":
							instance_create(_x, _y, Turret);
							break;
							
						case "Necromancer":
							with(call(scr.obj_create, _x, _y, "ButtonReviveArea")){
								object_name = Necromancer;
							}
							break;
							
						case "FishFreak":
							with(call(scr.obj_create, _x, _y, "ButtonReviveArea")){
								object_name = Freak;
								num_objects = 3;
							}
							break;
							
						case "RhinoFreak":
							with(call(scr.obj_create, _x, _y, "ButtonReviveArea")){
								object_name = RhinoFreak;
							}
							break;
							
						case "Pickup":
							call(scr.obj_create, _x, _y, "PickupReviveArea");
							break;
					}
				}
			}
		}
	}
	
#define ButtonOld_alrm1
	 // Visual:
	spr_idle = spr.ButtonIdle;
	spr_hurt = spr.ButtonHurt;
	sprite_index = spr_idle;
	
	with(prompt){
		visible = true;
	}
	
#define ButtonOld_alrm2
	 // Goodbye:
	my_health = 0;
	
	
#define ButtonPickup_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "ButtonChest")){
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
		
		return self;
	}
	
	
#define ButtonReviveArea_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.ButtonReviveArea;
		image_speed  = 0.4;
		
		 // Vars:
		object_name = Bandit;
		num_objects = 1;
		object_vars = {};
		
		 // Alarms:
		alarm0 = random_range(30, 50);
		
		 // Sound:
		sound_play_hit(sndFreakPopoReviveArea, 0.2);
		
		return self;
	}
	
#define ButtonReviveArea_step
	 // Alarms:
	if(alarm0_run) exit;
	
#define ButtonReviveArea_alrm0
	 // Create:
	repeat(num_objects){
		var o = call(scr.obj_create, x, y, object_name),
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
			styleb       - The room's floor style
			area         - The room's area style
			type         - The type of room to create: "Freak", "Explo", "Rhino", "Vat", "Popo"
			object       - The enemy to create
			num          - How many enemies to create
			enemies      - How many enemies existed in the level on creation
			spawnmoment  - Opens when this percentage of enemies are left
			open         - Can the room open anywhere, true/false
			setup        - Perform type-specific setup code, true/false
			alarm0       - Delay before opening, is set when a Player passes nearby
			slide_path   - The sliding door's path, see 'WallSlide_create()'
			               The direction value is altered based on the room's angle
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		mask_index   = mskFloor;
		image_xscale = 1;
		image_yscale = 1;
		hallway_size = 1;
		styleb       = true;
		area         = GameCont.area;
		type         = "";
		object       = -1;
		num          = 1;
		enemies      = instance_number(enemy);
		spawnmoment  = random_range(0.3, 0.9);
		open         = false;
		setup        = true;
		slide_path   = [
			[30,  0, 0, [sndToxicBoltGas,  0.5 + orandom(0.05), 1.0]], // Delay
			[16,  0, 1, [sndTurretFire,    0.3 + random(0.1),   0.9]], // Inset
			[10,  0, 0, [sndToxicBoltGas,  0.3 + random(0.1),   0.5]], // Delay
			[16, 90, 1, [sndSwapMotorized, 0.5 + random(0.1),   1.0]]  // Open
		];
		
		 // Determine Type:
		switch(GameCont.area){
			case area_hq:
				type = "Popo";
				break;
				
			default:
				type = call(scr.pool, {
					"Freak" : 8,
					"Rhino" : 4,
					"Explo" : 4,
					"Vat"   : 1
				});
		}
		
		return self;
	}
	
#define FreakChamber_setup
	setup = false;
	
	 // Type Setup:
	switch(type){
		
		case "Freak":
			
			var _add = irandom_range(2, 6) * num;
			
			object        = Freak;
			num          *= (1 + GameCont.loops) * 2;
			image_xscale *= 1 + ceil(num / 8);
			num          += _add;
			
			break;
			
		case "Explo":
			
			object        = ExploFreak;
			num          *= 1 + ceil(GameCont.loops / 2);
			image_xscale *= 1 + ceil((num - 4) / 12);
			image_yscale *= 1 + ceil((num - 4) / 12);
			
			break;
			
		case "Rhino":
			
			object        = RhinoFreak;
			num          *= 1 + ceil(GameCont.loops / 2);
			image_xscale *= 1 + floor(num * 2/3);
			
			break;
			
		case "Vat":
			
			object        = Necromancer;
			image_xscale *= 3;
			image_yscale *= 3;
			hallway_size *= irandom_range(1, 3);
			
			break;
			
		case "Popo":
			
			object        = choose(Grunt, Grunt, Shielder, Inspector);
			num           = ((object == Grunt) ? irandom_range(2, 3) : 1) + GameCont.loops;
			image_xscale *= 2;
			image_yscale *= 2;
			hallway_size *= 0.5;
			styleb        = false;
			
			 // Freak:
			if(GameCont.loops > 2){
				object = PopoFreak;
			}
			
			 // Sliding Door:
			slide_path = [
				[45,  0, 0,   [sndToxicBoltGas,    0.6 + random(0.1), 1  ]], // Delay
				[ 6, 90, 0.5, [sndIDPDPortalSpawn, 6.0 + random(0.1), 1.4]], // Open Slightly
				[15, 90, 0                                                ], // Delay
				[13, 90, 1,   [sndIDPDNadeAlmost,  1.4 + random(0.1), 1.2]]  // Open Full
			];
			
			break;
	}
	
#define FreakChamber_step
	if(setup) FreakChamber_setup();
	
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Force Spawn:
	if(instance_number(enemy) <= enemies * spawnmoment){
		if(!open){
			open   = true;
			alarm0 = (instance_exists(enemy) ? 30 : 1);
		}
	}
	
	 // Wait for Nearby Player:
	else if(alarm0 < 0){
		var _target = instance_nearest(x, y, Player);
		if(open || (instance_exists(_target) && point_distance(x, y, _target.x, _target.y) < 96 && !collision_line(x, y, _target.x, _target.y, Wall, false, false))){
			alarm0 = 60;
		}
	}
	
	 // Desynchronize:
	if(alarm0 > 0){
		with(instances_matching_ne(instances_matching(obj.FreakChamber, "alarm0", alarm0), "id", id)){
			alarm0 += 30;
		}
	}
	
#define FreakChamber_alrm0
	alarm0 = 60;
	
	if(instance_exists(Player)){
		var	_open       = false,
			_ang        = pround(random(360), 90),
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
						if(other.open || !collision_line(_cx, _cy, _target.x, _target.y, Wall, false, false)){
							array_push(_spawnFloor, [
								random(32) + max(
									64 * (1 + instance_is(self, FloorExplo)),
									point_distance(_cx, _cy, _target.x, _target.y)
								),
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
		var _spawnAvoid = (
			(_hallDis < 32)
			? [Floor, Wall, TopPot, Bones]
			: [Floor, Wall, TopSmall, TopPot, Bones]
		);
		with(_spawnFloor){
			var _floor = self[1];
			with(other){
				for(var _dir = _ang; _dir < _ang + 360; _dir += 90){
					var	_fx = _floor.x + lengthdir_x(_floor.w / 2, _dir),
						_fy = _floor.y + lengthdir_y(_floor.h / 2, _dir);
						
					if(!position_meeting(_fx + dcos(_dir), _fy - dsin(_dir), Floor)){
						var	_hallW    = max(1, abs(lengthdir_x(_hallDis / 32, _dir))),
							_hallH    = max(1, abs(lengthdir_y(_hallDis / 32, _dir))),
							_hallX    = _fx + lengthdir_x(max(32, _hallDis) / 2, _dir),
							_hallY    = _fy + lengthdir_y(max(32, _hallDis) / 2, _dir),
							_hallXOff = lengthdir_x(32, _dir),
							_hallYOff = lengthdir_y(32, _dir);
							
						if(!array_length(call(scr.instances_meeting_rectangle,
							_hallX - (_hallW * 16) + max(0, _hallXOff),
							_hallY - (_hallH * 16) + max(0, _hallYOff),
							_hallX + (_hallW * 16) + min(0, _hallXOff) - 1,
							_hallY + (_hallH * 16) + min(0, _hallYOff) - 1,
							_spawnAvoid
						))){
							var	_yoff = -(sprite_get_height(mask_index) * image_yscale) / 2,
								_spawn = true;
								
							x = _fx + lengthdir_x(_hallDis, _dir) + lengthdir_x(_yoff, _dir - 90);
							y = _fy + lengthdir_y(_hallDis, _dir) + lengthdir_y(_yoff, _dir - 90);
							image_angle = _dir;
							
							for(var i = 0; i < array_length(_spawnAvoid); i++){
								if(place_meeting(x, y, _spawnAvoid[i])){
									_spawn = false;
									break;
								}
							}
							
							if(_spawn){
								var	_x = bbox_center_x,
									_y = bbox_center_y,
									_w = floor(bbox_width  / 32),
									_h = floor(bbox_height / 32);
									
								 // Store Walls:
								var	_wall = [],
									_tops = [];
									
								if(array_find_index(_spawnAvoid, Wall) >= 0){
									with(call(scr.instances_meeting_rectangle, _hallX - (_hallW * 16), _hallY - (_hallH * 16), _hallX + (_hallW * 16) - 1, _hallY + (_hallH * 16) - 1, Wall)){
										array_push(_wall, call(scr.variable_instance_get_list, self));
										instance_delete(self);
									}
								}
								if(array_find_index(_spawnAvoid, TopSmall) >= 0){
									with(call(scr.instances_meeting_rectangle, _hallX - (_hallW * 16) - 16, _hallY - (_hallH * 16) - 16, _hallX + (_hallW * 16) + 16 - 1, _hallY + (_hallH * 16) + 16 - 1, TopSmall)){
										array_push(_tops, call(scr.variable_instance_get_list, self));
										instance_delete(self);
									}
									with(call(scr.instances_meeting_rectangle, bbox_left - 1, bbox_top - 1, bbox_right + 1, bbox_bottom + 1, TopSmall)){
										array_push(_tops, call(scr.variable_instance_get_list, self));
										instance_delete(self);
									}
								}
								
								 // Generate Room:
								var _lastArea = GameCont.area;
								GameCont.area = area;
								call(scr.floor_set_style, styleb, area);
								call(scr.floor_set_align, 16, 16);
								
								var	_minID     = instance_max,
									_floorHall = call(scr.floor_fill, _hallX, _hallY, _hallW, _hallH),
									_floorMain = call(scr.floor_fill, _x, _y, _w, _h);
									
								call(scr.floor_reset_style);
								call(scr.floor_reset_align);
								GameCont.area = _lastArea;
								
								 // Transition Walls:
								with(instances_matching_gt(Wall, "id", _minID)){
									topspr = call(scr.area_get_sprite, other.area, sprWall1Trans);
									switch(sprite_index){
										case sprWall6Bot:
											sprite_index = spr.Wall6BotTrans;
											break;
									}
								}
								
								 // Resprite Explo Tiles:
								with(instances_matching_gt(FloorExplo, "id", _minID)){
									switch(sprite_index){
										case sprFloor106Explo:
											sprite_index = spr.Floor106Small;
											depth = 10;
											break;
									}
								}
								
								 // Details:
								with(instances_matching_gt(Floor, "id", _minID)){
									if(chance(1, 5)){
										var _b = styleb;
										styleb = false;
										instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Detail);
										styleb = _b;
									}
									depth = 10;
								}
								
								 // Reveal Tiles:
								with(instances_matching_gt([Floor, Wall, TopSmall], "id", _minID)){
									var _reveal = true;
									
									 // Don't Cover Doors:
									if(array_find_index(_floorHall, self) >= 0){
										with(_wall){
											if(rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, other.bbox_left, other.bbox_top, other.bbox_right, other.bbox_bottom)){
												_reveal = false;
												break;
											}
										}
									}
									
									 // Don't Cover Pre-Existing TopSmalls:
									if(instance_is(self, Wall) || instance_is(self, TopSmall)){
										if(place_meeting(x, y, TopPot) || place_meeting(x, y, Bones)){
											_reveal = false;
										}
										else with(_tops){
											if(x == other.x && y == other.y){
												_reveal = false;
												break;
											}
										}
									}
									
									 // Reveal:
									if(_reveal){
										with(call(scr.floor_reveal, bbox_left, bbox_top, bbox_right, bbox_bottom, 10)){
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
								if((is_real(object) && object_exists(object)) || is_string(object)){
									for(var i = 0; i < num; i++){
										with(_floorMain[floor(((i + random(1)) / num) * array_length(_floorMain))]){
											var _obj = other.object;
											
											 // Elite IDPD:
											switch(_obj){
												case Grunt     : if(chance(1, 5)) _obj = EliteGrunt;     break;
												case Shielder  : if(chance(1, 3)) _obj = EliteShielder;  break;
												case Inspector : if(chance(1, 3)) _obj = EliteInspector; break;
											}
											
											with(call(scr.obj_create, bbox_center_x + orandom(4), bbox_center_y + orandom(4), _obj)){
												if(instance_is(self, enemy)){
													walk = true;
													direction = random(360);
													
													 // Delay:
													for(var j = 0; j < array_length(_slidePath); j++){
														alarm1 += _slidePath[j, 0];
													}
													
													 // No Roll:
													if("roll" in self){
														roll = false;
													}
												}
												with(instances_matching_gt(PortalClear, "id", id)){
													instance_destroy();
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
										
										 // Vat:
										call(scr.obj_create, _x, _y - 4, "MutantVat");
										instance_create(_x + choose(-32, 32), _y - 2 + choose(-32, 32), Terminal);
										
										break;
										
									case "Popo":
										
										 // Center Piece:
										if(_w > 1 && _h > 1){
											with(instance_create(_x, _y, FloorMiddle)){
												if(_w < 4 || _h < 4){
													sprite_index = spr.FloorMiddleSmall;
													mask_index   = msk.FloorMiddleSmall;
												}
											}
										}
										
										 // Prepare Troops:
										with(instances_matching_ne(instances_matching_gt(enemy, "id", _minID), "gunangle", null)){
											direction = point_direction(x, y, _hallX, _hallY);
											enemy_look(direction);
											alarm1 = max(1, alarm1 - 30);
										}
										
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
										topspr      = other.sprite_index;
										topindex    = other.image_index;
										image_blend = other.image_blend;
										image_alpha = other.image_alpha;
										
										 // Resprite:
										switch(sprite_index){
											case sprWall6Bot:
												sprite_index = spr.Wall6BotTrans;
												break;
										}
										
										 // Slide:
										with(call(scr.obj_create, x, y, "WallSlide")){
											slide_inst = [other];
											slide_path = call(scr.data_clone, _slidePath, 1);
											
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
										call(scr.variable_instance_set_list, self, other);
										depth = min(depth, -1);
										
										 // Resprite:
										if(!visible){
											switch(sprite_index){
												case sprWall6Bot:
													sprite_index = spr.Wall6BotTrans;
													break;
											}
										}
										
										 // Slide:
										with(call(scr.obj_create, x, y, "WallSlide")){
											slide_inst = [other];
											slide_path = call(scr.data_clone, _slidePath, 1);
											smoke      = 1/5;
											
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
			if(instance_exists(enemy)){
				call(scr.portal_poof);
			}
			instance_destroy();
		}
	}
	
	
#define Igloo_create(_x, _y)
	/*
		Buildings for the Frozen City bro, seals live here
		
		Vars:
			num   - Number of seals that live here
			type  - The main type of seal that lives here
			alert - Alert the player before releasing seals, true/false
			chest - Drops a chest on death, true/false
	*/
	
	with(instance_create(_x, _y, CustomProp)){
		 // Facing:
		front = chance(1, 3);
		with(instances_matching_ne(obj.PalankingStatue, "id")){
			if(other.x >= bbox_left && other.x < bbox_right + 1){
				if(y > other.y){
					other.front = true;
				}
			}
			else if(other.y >= bbox_top && other.y < bbox_bottom + 1){
				other.front = false;
				if(other.x != x){
					other.image_xscale = sign(x - other.x);
				}
			}
		}
		
		 // Visual:
		spr_idle     = (front ? spr.IglooFrontIdle : spr.IglooSideIdle);
		spr_hurt     = (front ? spr.IglooFrontHurt : spr.IglooSideHurt);
		spr_dead     = (front ? spr.IglooFrontDead : spr.IglooSideDead);
		sprite_index = spr_idle;
		depth        = -1;
		
		 // Sound:
		snd_hurt = sndHitRock;
		snd_dead = sndSnowmanBreak;
		
		 // Vars:
		mask_index = -1;
		maxhealth  = 30;
		team       = 1;
		size       = 2;
		num        = irandom_range(5, 6);
		type       = irandom_range(4, 6);
		alert      = true;
		chest      = chance(1, 5);
		
		 // Alarms:
		alarm0 = irandom_range(150, 240);
		
		 // No Portals:
		with(call(scr.obj_create, 0, 0, "PortalPrevent")){
			creator = other;
		}
		
		return self;
	}
	
#define Igloo_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Allow Portals:
	if(num <= 0){
		with(instances_matching(obj.PortalPrevent, "creator", self)){
			instance_destroy();
		}
	}
	
#define Igloo_alrm0
	if(num > 0){
		alarm0 = 60 + random(60);
		
		if(instance_exists(Player)){
			 // Seal Spew:
			if(!alert || chance(num, 16)){
				num--;
				
				if(alert) alarm0 += random(30);
				else alarm0 = 2 + random(3);
				
				 // The Boys:
				with(call(scr.obj_create, x, y, "Seal")){
					type = choose(other.type, 4);
				}
			}
			
			 // Alert:
			if(alert){
				var	_player = instance_nearest(x, y, Player),
					_enemy  = instance_nearest(x, y, enemy);
					
				if(
					my_health < maxhealth
					|| !instance_exists(_enemy)
					|| point_distance(x, y, _player.x, _player.y) < point_distance(x, y, _enemy.x, _enemy.y)
				){
					alert = false;
					alarm0 = 30;
					
					with(call(scr.alert_create, self, spr.SealArcticAlert)){
						flash = other.alarm0;
						if(other.chest){
							alert = { spr:sprBreath, x:1, y:2 };
						}
					}
				}
			}
		}
	}
	
#define Igloo_death
	 // Seal Spew Pt.2:
	if(num > 0){
		repeat(num){
			with(call(scr.obj_create, x, y, "Seal")){
				type = choose(other.type, 4);
			}
		}
		if(alert){
			with(call(scr.alert_create, self, spr.SealArcticAlert)){
				vspeed = -3;
				if(other.chest){
					alert = { spr:sprBreath, x:1, y:2 };
				}
			}
		}
	}
	
	 // Pickups:
	if(chest){
		var	_num = 1 + skill_get(mut_open_mind);
		if(_num > 0) repeat(_num){
			var _obj = (chance(1, 5) ? "Backpack" : choose(WeaponChest, AmmoChest));
			if(crown_current == crwn_life && chance(2, 3)){
				_obj = HealthChest;
			}
			with(call(scr.chest_create, x, y, _obj)){
				motion_add(random(360), 1);
			}
		}
	}
	else for(var i = 0; i < 2; i++){
		pickup_drop(50, 20, i);
	}
	
	 // Effects:
	for(var _dir = 0; _dir < 360; _dir += (360 / (12 + num))){
		with(call(scr.fx, [x, 4], [y + 6, 4], 0, Smoke)){
			direction = _dir + orandom(10);
			speed = random_range(1, 3);
			sprite_index = sprSnowFlake;
			image_index = irandom(image_number - 1);
			image_xscale *= 2;
			image_yscale *= 2;
			//friction *= 2/3;
			vspeed -= 1.5;
			gravity = 0.085;
		}
	}
	call(scr.sound_play_at, x, y, sndMaggotSpawnDie, 1.2 + random(0.2), 7);
	
	
#define MutantVat_create(_x, _y)
	/*
		A giant version of the MutantTube, which can contain special enemies or loot
	*/
	
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle     = spr.MutantVatIdle;
		spr_hurt     = spr.MutantVatHurt;
		spr_dead     = spr.MutantVatDead;
		spr_back     = spr.MutantVatBack;
		spr_dude     = mskNone;
		spr_shadow   = shd64B;
		spr_shadow_y = 12;
		sprite_index = spr_idle;
		depth        = -1;
		color        = make_color_rgb(40, 87, 9);
		face         = choose(-1, 1);
		
		 // Sounds:
		snd_hurt = sndLabsTubeBreak;
		snd_dead = sndLabsMutantTubeBreak;
		
		 // Vars:
		mask_index = -1;
		maxhealth  = 50;
		raddrop    = 4;
		size       = 3;
		team       = 1;
		wave       = random(100);
		setup      = true;
		wep        = wep_none;
		pet_data   = ["", "", "", {}];
		
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
		if(call(scr.unlock_get, "crown:crime")){
			array_push(_pool, [choose("CatChest", "BatChest"), 1]);
		}
		type = call(scr.pool, _pool);
		
		 // Alarms:
		alarm1 = -1;
		alarm2 = -1;
		
		return self;
	}
	
#define MutantVat_setup
	setup = false;
	
	var	_x = x,
		_y = y,
		_canWatch = false;
		
	switch(type){
		case "MergedWep":
			wep = wep_revolver;
			var _part = call(scr.weapon_merge_decide, 0, GameCont.hard);
			if(array_length(_part) >= 2){
				wep = call(scr.weapon_merge, _part[0], _part[1]);
			}
			spr_dude = weapon_get_sprite(wep);
			break;
			
		case Freak:
			spr_dude = sprFreak1Idle;
			_canWatch = true;
			break;
			
		case "FishFreak":
			spr_dude = spr.FishFreakIdle;
			_canWatch = true;
			break;
			
		case "Angler":
			spr_dude = sprRadChest;
			break;
			
		case "PortalGuardian":
			spr_dude = spr.PortalGuardianIdle;
			_canWatch = true;
			break;
			
		case PopoFreak:
			spr_dude = sprPopoFreakIdle;
			_canWatch = true;
			break;
			
		case "CrystalHeart":
			spr_dude = spr.CrystalHeartIdle;
			break;
			
		case Bandit:
			spr_dude = sprBanditHurt;
			break;
			
		case WeaponChest:
			spr_dude = sprWeaponChest;
			break;
			
		case "Backpack":
		case "CatChest":
		case "BatChest":
			spr_dude = lq_get(spr, type);
			break;
			
		 // Labs Event Exclusive:
		case "Pet":
			_canWatch = true;
			/*
			with(call(scr.obj_create, _x, _y - 20, "CatLight")){
				sprite_index = spr.CatLightBig;
				image_xscale *= 0.75;
			}
			*/
			break;
	}
	
	 // Ever Vigilant:
	if(_canWatch){
		alarm2 = 90;
	}
	
#define MutantVat_step
	if(setup) MutantVat_setup();
	
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Wave:
	wave += current_time_scale;
	
	 // Stay Still:
	x = xstart;
	y = ystart;

	 // Draw Back (Change this later):
	script_bind_draw(MutantVat_draw_back, depth, self);
	
#define MutantVat_draw_back(_inst)
	with(_inst){
		var _img = (wave * image_speed);
		draw_sprite_ext(spr_back, _img, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		
		 // Draw Thing Inside:
		var _oc  = chance(1, 30),
			_ol  = 2,
			_od  = random(360),
			_ox  = _oc * lengthdir_x(_ol, _od),
			_oy  = _oc * lengthdir_y(_ol, _od),
			_spr = spr_dude,
			_x   = x + _ox + (sin(wave / 10) * 2),
			_y   = y + _oy + (cos(wave / 10) * 3),
			_xsc = abs(image_xscale) * face,
			_ysc = image_yscale,
			_ang = image_angle + sin(wave / 30) * 30,
			_col = c_white,
			_alp = image_alpha;
			
		draw_set_fog(true, color, 0, 0);
		draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
		draw_set_fog(false, c_white, 0, 0);
	}
	
	 // Goodbye:
	instance_destroy();
	
#define MutantVat_alrm1
	alarm1 = 10 + random(10);
	
	projectile_hit(self, 10);
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
	
	 // Face Player:
	var	_disMax = infinity,
		_target = noone;
		
	with(Player){
		var _dis = point_distance(x, y, other.x, other.y);
		if(_dis < _disMax){
			if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
				_disMax = _dis;
				_target = self;
			}
		}
	}
	
	if(instance_exists(_target)){
		var _face = sign(_target.x - x);
		if(_face != 0){
			face = _face;
		}
	}
	
#define MutantVat_death
	 // Effects:
	repeat(24){
		with(instance_create(x, y, Shell)){
			sprite_index = spr.MutantVatGlass;
			image_index  = irandom(image_number - 1);
			image_speed  = 0;
			motion_set(random(360), random_range(2, 6));
			x += hspeed;
			y += vspeed;
		}
	}
	with(call(scr.obj_create, x, y, "BuriedVaultChestDebris")){
		sprite_index = spr.MutantVatLid;
		mask_index   = mskExploder;
		zfriction   /= 2;
		zspeed      *= 2/3;
		bounce       = irandom_range(1, 2);
		snd_land     = sndTechnomancerHurt;
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
			image_index  = 2 + (3 * (1 - c));
			motion_set(d, 2);
		}
	}
	
	 // Drops:
	switch(type){
		case Bandit:
		case Freak:
		case PopoFreak:
		case "PortalGuardian":
			call(scr.obj_create, x, y, type);
			break;
			
		case WeaponChest:
		case "OrchidChest":
		case "Backpack":
		case "CatChest":
		case "BatChest":
			call(scr.chest_create, x, y, type);
			break;
			
		case "MergedWep":
			with(instance_create(x, y, WepPickup)){
				wep = other.wep;
			}
			break;
			
		case "FishFreak":
			with(instance_create(x, y, Freak)){
				fish_freak = true;
			}
			break;
			
		/*
		case PopoFreak:
			var _minID = instance_max;
			instance_create(x, y, type);
			repeat(2) instance_create(x, y, IDPDSpawn);
			with(instance_create(x, y - 16, type)){
				my_health = 0;
				with(self){
					event_perform(ev_destroy, 0);
				}
			}
			
			 // Quality Assurance:
			with(instances_matching_gt(WantRevivePopoFreak, "id", _minID)){
				alarm0 = 120;
			}
			with(instances_matching_gt([PopoNade, IDPDPortalCharge], "id", _minID)){
				instance_delete(self);
			}
			break;
			*/
			
		case "Angler":
			with(call(scr.obj_create, x, y, type)){
				with(self){
					event_perform(ev_step, ev_step_normal);
				}
			}
			break;
			
		case "CrystalHeart":
			with(call(scr.obj_create, x, y - 16, type)){
				my_health = 0;
				with(self){
					event_perform(ev_destroy, 0);
				}
			}
			break;
			
		 // Labs Event Exclusive:
		case "Pet":
			with(call(scr.pet_create, x, y, pet_data[0], pet_data[1], pet_data[2])){
				call(scr.variable_instance_set_list, self, other.pet_data[3]);
				call(scr.pet_set_skin, self, bskin);
				history = [];
			}
			break;
	}
	
	/*
	 // Open the Floodgates:
	with(instances_matching_ne(obj.MutantVat, "id", id)){
		alarm1 += random(10);
		
		 // Effects:
		repeat(8){
			instance_create(x + orandom(20), y + orandom(25), PortalL);
		}
	}
	*/
	
	
#define PickupReviveArea_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.PickupReviveArea;
		image_speed  = 0.4;
		
		 // Vars:
		pickup = noone;
		
		 // Alarms:
		alarm0 = 15;
		
		 // Sound:
		sound_play_hit(sndFreakPopoReviveArea, 0.2);
		
		return self;
	}
	
#define PickupReviveArea_step
	 // Alarms:
	if(alarm0_run) exit;
	
#define PickupReviveArea_alrm0
	 // Open Button Pickups:
	if(instance_exists(pickup)){
		with(pickup){
			var _sprt = spr_debris,
				_pool = payout_pool;
				
			if(array_length(_pool)){
				 // Chest:
				call(scr.chest_create, x, y, call(scr.pool, _pool));
				
				 // Casing:
				for(var i = 0; i < sprite_get_number(_sprt); i++){
					with(instance_create(x, y, Debris)){
						motion_set(random(360), 4);
						sprite_index = _sprt;
						image_index  = i;
						friction     = 0.6;
						depth        = other.depth + 1;
						
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
		call(scr.obj_create, x, y, o);
	}
	
	 // Effects:
	sound_play_hit(sndFreakPopoRevive, 0.2);
	with(instance_create(x, y, ReviveFX)){
		sprite_index = spr.PickupRevive;
	}
	
	 // Goodbye:
	instance_destroy();
	
	
#define PopoSecurity_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		var	_wepList  = [spr.PopoSecurityMinigun, spr.PopoSecurityCannon],
			_wepIndex = irandom(array_length(_wepList) - 1);
			
		 // Visual:
		spr_idle     = spr.PopoSecurityIdle;
		spr_walk     = spr.PopoSecurityWalk;
		spr_hurt     = spr.PopoSecurityHurt;
		spr_dead     = spr.PopoSecurityDead;
		spr_weap     = _wepList[_wepIndex];
		sprite_index = spr_idle;
		spr_shadow   = shd24;
		spr_shadow_y = 3;
		hitid        = [spr_idle, "SECURITY GUARD"]; // let it be known, smash brothers almost left this as "SECURTY GUARD"
		depth        = -2;
		
		 // Sounds:
		male = choose(true, false);
		snd_hurt = (male ? sndEliteGruntHurt : sndShielderHurtF); // (_male ? sndShielderHurtM : sndShielderHurtF);
		snd_dead = (male ? sndEliteGruntDead : sndShielderDeadF); // (_male ? sndShielderDeadM : sndShielderDeadF);
		
		 // Vars:
		mask_index = mskLilHunter;
		friction   = 0.4;
		maxhealth  = 95;
		raddrop    = 0;
		team       = 3;
		size       = 2;
		ammo       = 0;
		walk       = 0;
		walkspeed  = 0.8;
		maxspeed   = 2.5;
		freeze     = 0;
		wkick      = 0;
		right      = 1;
		gunangle   = 0;
	//	grenades   = 3;
		wep_list   = _wepList;
		wep_index  = _wepIndex;
		queueswap  = false;
		swap_kick  = 0;
		aim_x      = xstart;
		aim_y      = ystart;
		
		 // Alarms:
		alarm1 = 60;
		alarm2 = -1;
		
		return self;
	}
	
#macro PopoSecurity_minigun 0
#macro PopoSecurity_cannon  1

#define PopoSecurity_step
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Animate:
	sprite_index = enemy_sprite;
	if(swap_kick != 0){
		swap_kick -= clamp(swap_kick, -current_time_scale, current_time_scale);
	}
	
	 // Sense Danger:
	if(instance_exists(Player)){
		with(Player){
			if(speed > 0 || my_health < maxhealth){
				other.freeze += current_time_scale;
			}
			if(can_shoot == false){
				other.freeze += 3 * current_time_scale;
			}
		}
	}
	
	 // No Vans:
	/*if(instance_exists(WantVan)){
		var _inst = instances_matching(WantVan, "canspawn", true);
		if(array_length(_inst)) with(_inst){
			canspawn = false;
		}
	}*/
	
#define PopoSecurity_draw
	 // Back Weapon:
	var _flash = (sprite_index == spr_hurt && image_index < 1);
	if(_flash){
		draw_set_fog(true, c_white, 0, 0);
	}
	call(scr.draw_weapon, 
		wep_list[(wep_index + 1) % array_length(wep_list)],
		0,
		x,
		y + swap_kick,
		90 + (20 * right),
		0,
		0,
		right,
		merge_color(image_blend, c_black, 0.25),
		image_alpha
	);
	if(_flash){
		draw_set_fog(false, c_white, 0, 0);
	}
	
	 // Self Behind:
	if(gunangle > 180){
		draw_self_enemy();
	}
	
	 // Primary Weapon:
	call(scr.draw_weapon, spr_weap, 0, x, (y - swap_kick), gunangle, 0, wkick, right, image_blend, image_alpha);
	
	 // Self Above:
	if(gunangle <= 180){
		draw_self_enemy();
	}
	
#define PopoSecurity_alrm1
	alarm1 = 30;
	
	 // Swap Weapon:
	if(queueswap){
		queueswap = false;
		wep_index = ((wep_index + 1) % array_length(wep_list));
		spr_weap  = wep_list[wep_index];
		swap_kick = 1;
		
		var _len = 10;
		instance_create(x + lengthdir_x(_len, gunangle), y + lengthdir_y(_len, gunangle), WepSwap);
		sound_play_hit(sndSwapEnergy, 0.3);
		
		alarm1 = 10;
	}
	
	 // Normal:
	else if(ammo <= 0){
		if(enemy_target(x, y) && (target_visible || chance(freeze, 600))){
			alarm1 = random_range(10, 20);
			
			enemy_look(target_direction);
			
			if(target_distance < 128){
				 // Begin Attack:
				if(chance(2, 3)){
					alarm2 = 1;
				}
				
				 // Strafe:
				else enemy_walk(
					gunangle + (random_range(30, 90) * choose(-1, 1)),
					random_range(10, 20)
				);
			}
			
			 // Move Closer:
			else enemy_walk(
				gunangle + orandom(30),
				random_range(10, 20)
			);
		}
		
		 // Wander:
		else if(chance(2, 3)){
			alarm1 = random_range(20, 30);
			enemy_walk(random(360), random_range(20, 40));
			enemy_look(direction);
		}
	}
	
#define PopoSecurity_alrm2
	 // Setup:
	if(ammo <= 0){
		switch(wep_index){
			case PopoSecurity_minigun : ammo = irandom_range(8, 12); break;
			case PopoSecurity_cannon  : ammo = 1;                    break;
		}
	}
	
	 // Attack:
	if(ammo > 0){
		alarm2 = 1;
		
		 // Retarget:
		if(instance_exists(target)){
			enemy_look(target_direction);
			var _dis = target_distance + 48;
			aim_x = x + lengthdir_x(_dis, gunangle);
			aim_y = y + lengthdir_y(_dis, gunangle);
		}
		
		 // Fire:
		switch(wep_index){
			
			case PopoSecurity_minigun:
				
				 // Delay:
				alarm2 = 5;
				
				 // Sound:
				call(scr.sound_play_at, x, y, sndEliteShielderFire, 1.4 + random(0.2), 2);
				
				 // Effects:
				wkick = 8;
				motion_add(gunangle, 2);
				move_contact_solid(gunangle, 2);
				var _len = sprite_get_width(spr_weap) - sprite_get_xoffset(spr_weap) + 4;
				repeat(irandom_range(2, 3)){
					call(scr.team_instance_sprite, 
						3, 
						call(scr.fx, 
							x + lengthdir_x(_len, gunangle) + orandom(3), 
							y + lengthdir_y(_len, gunangle) + orandom(3), 
							[gunangle + 180, random(2)], 
							PlasmaTrail
						)
					);
				}
				
				 // Vlasma:
				with(call(scr.team_instance_sprite, 
					3,
					call(scr.projectile_create, self, aim_x, aim_y, "VlasmaBullet", gunangle + 180)
				)){
					target	 = other;
					target_x = other.x;
					target_y = other.y;
					my_sound = sound_play_hit(sndEliteGruntRocketFly, 0.3);
					
					 // Sound:
					call(scr.sound_play_at, x, y, sndPlasmaReload, 1.3 + random(0.3), 0.5);
				}
				
				break;
				
			case PopoSecurity_cannon:
				
				 // Sound:
				call(scr.sound_play_at, x, y, sndGruntFire, 0.6 + random(0.2), 4);
				call(scr.sound_play_at, x, y, sndPlasmaBig, 1.4 + random(0.2), 2);
				
				 // Effects:
				wkick = 8;
				motion_add(gunangle, 4);
				move_contact_solid(gunangle, 4);
				var _len = sprite_get_width(spr_weap) - sprite_get_xoffset(spr_weap) + 4;
				repeat(irandom_range(4, 7)){
					call(scr.team_instance_sprite, 
						3, 
						call(scr.fx, 
							x + lengthdir_x(_len, gunangle) + orandom(5), 
							y + lengthdir_y(_len, gunangle) + orandom(5), 
							[gunangle + 180, random(2)], 
							PlasmaTrail
						)
					);
				}
				
				 // Big Vlasma:
				with(call(scr.team_instance_sprite, 
					3,
					call(scr.projectile_create, self, aim_x, aim_y, "VlasmaCannon", gunangle + 180)
				)){
					target	 = other;
					target_x = other.x;
					target_y = other.y;
					my_sound = sound_play_hit(sndEliteGruntRocketFly, 0.3);
					
					 // Sound:
					call(scr.sound_play_at, x, y, sndPlasmaReload, 1.3 + random(0.3), 0.5);
				}
				
				break;
		}
		
		 // Done:
		if(--ammo <= 0){
			alarm2 = -1;
			
			 // Swap Weapons:
			if(chance(2, 3)){
				queueswap = true;
				alarm1    = 10;
			}
			
			 // Take a Break:
			else alarm1 = random_range(20, 30);
		}
	}
	
#define PopoSecurity_death
	 // Pickups:
	for(var i = 0; i < 2; i++){
		pickup_drop(50, 60, i);
	}
	
	 // Activate Popo:
	with(instances_matching_ne(enemy, "freeze", null)){
		if(is_real(freeze)){
			freeze += 100;
		}
	}
	with(WantVan){
		canspawn = true;
	}
	
	 // Backup Incoming:
	with(call(scr.alert_create, self, spr.PopoAlert)){
		vspeed      = -1;
		image_index = 0;
		image_speed = 0;
		alert.col   = make_color_rgb(245, 184, 0);
		alarm0      = 30;
		blink       = 10;
		flash       = 6;
		snd_flash   = sndEliteIDPDPortalSpawn;
	}
	var _ang = random(360);
	for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 2)){
		with(instance_create(x, y, IDPDSpawn)){
			elite = true;
			freak = false;
			
			 // Reposition:
			x = other.x;
			y = other.y;
			move_contact_solid(_dir + orandom(30), random_range(32, 128));
			
			 // Alert:
			with(call(scr.alert_create, self, spr.PopoEliteAlert)){
				vspeed      = -0.8;
				image_speed = 0.1;
				alert       = { spr:spr.AlertIndicatorPopo, x:-5, y:5 };
				alarm0      = other.alarm0 + 15;
				blink       = 15;
				flash       = 10;
				snd_flash   = sndIDPDNadeAlmost;
			}
		}
	}
	
	
#define PortalBullet_create(_x, _y)
	/*
		A projectile that teleports its creator to itself when destroyed
		Also teleports non-prop hitmes that it damages to its creator's position, basically swapping their positions
	*/
	
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		spr_spwn     = spr.PortalBulletSpawn;
		spr_idle     = spr.PortalBullet;
		sprite_index = spr_spwn;
		image_speed  = 0.4;
		depth        = -5;
		ntte_bloom   = 0.1;
		
		 // Vars:
		mask_index = mskNone;
		mask       = mskSuperFlakBullet;
		damage     = 2;
		force      = 0;
		typ        = 1;
		offset     = 12;
		creator    = noone;
		portal     = false;
		hold       = true;
		spec       = false;
		primary    = true;
		
		return self;
	}
	
#define PortalBullet_anim
	if(sprite_index == spr_spwn){
		sprite_index = spr_idle;
		mask_index   = mask;
		
		 // FX:
		var _snd = audio_play_sound(sndGuardianHurt, 0, false);
		audio_sound_pitch(_snd, 0.4 + random(0.1));
		audio_sound_gain(_snd, 0.3, 0);
		repeat(3){
			call(scr.fx, x, y, 3, Smoke);
		}
	}
	
#define PortalBullet_step
	 // Charging:
	if(hold){
		 // Hold Still:
		var _wep = variable_instance_get(creator, (primary ? "" : "b") + "wep");
		if(
			sprite_index == spr_spwn
			|| (
				instance_is(creator, Player)
				&& creator.visible
				&& array_length(instances_matching(CrystalShield, "creator", creator)) <= 0
				&& button_check(creator.index, (spec ? "spec" : "fire"))
				&& is_object(_wep)
				&& is_array(lq_get(_wep, "inst"))
				&& array_find_index(_wep.inst, self) >= 0
			)
		){
			if(instance_exists(creator)){
				var _lastMask = mask_index;
				mask_index = mskAlly;
				
				x = creator.x;
				y = creator.y;
				move_contact_solid(
					direction,
					offset - variable_instance_get(creator, (primary ? "" : "b") + "wkick", 0)
				);
				
				mask_index = _lastMask;
			}
			call(scr.motion_step, self, -1);
		}
		
		 // Fire:
		else{
			hold = false;
			
			 // FX:
			var _kick = (primary ? "" : "b") + "wkick";
			if(_kick in creator){
				variable_instance_set(creator, _kick, 10);
			}
			sound_play_pitch(sndGuardianHurt, 1.5 + orandom(0.2));
			repeat(5) call(scr.fx, x, y, [direction + orandom(60), 3], Dust);
		}
	}
	
	 // Slow Down:
	else{
		var	_slowMax = 0.5,
			_slowDis = 32;
			
		if(distance_to_object(hitme) < _slowDis){
			with(call(scr.instances_meeting_rectangle, x - _slowDis, y - _slowDis, x + _slowDis, y + _slowDis, instances_matching_gt(instances_matching(hitme, "team", team), "size", 0))){
				if(_slowMax > 0){
					if(distance_to_object(other) < _slowDis){
						var _slow = min(_slowMax, size / 20);
						with(other){
							_slowMax -= _slow;
							x -= hspeed_raw * _slow;
							y -= vspeed_raw * _slow;
						}
					}
				}
				else break;
			}
		}
	}
	
	 // FX:
	if(chance_ct(1, 15)){
		with(instance_create(x + hspeed_raw, y + vspeed_raw, PortalL)){
			depth = other.depth + choose(0, -1);
		}
	}
	
#define PortalBullet_end_step
	 // Mid-Air Collision:
	if(place_meeting(x, y, object_index)){
		with(call(scr.instances_meeting_instance, self, instances_matching_ne(obj.PortalBullet, "team", team))){
			if(place_meeting(x, y, other)){
				if(instance_exists(creator) && array_find_index(obj.PortalGuardian, creator) >= 0){
					with(creator){
						implode   = true;
						my_health = 0;
					}
					with(other){
						if(instance_exists(creator) && array_find_index(obj.PortalGuardian, creator) >= 0){
							with(creator){
								implode   = true;
								my_health = 0;
							}
						}
						else creator = noone;
						instance_destroy();
					}
					instance_destroy();
				}
			}
		}
	}
	
#define PortalBullet_hit
	if(projectile_canhit_np(other) && other.my_health > 0){
		if(instance_is(creator, Player) || (!instance_is(other, prop) && other.team != 0)){
			projectile_hit_np(other, damage, force, 80);
			
			 // Implosion:
			if(creator == other && array_find_index(obj.PortalGuardian, creator) >= 0){
				with(other){
					implode   = true;
					my_health = 0;
				}
				
				 // BYE:
				creator = noone;
				instance_destroy();
			}
			
			 // Swapping Positions:
			else{
				 // Portal:
				var _portal = (portal && instance_is(other, Player));
				if(_portal){
					with(creator){
						speed     = 0;
						my_health = 0;
					}
				}
				
				 // Swap Positions:
				with(other){
					if(size < 6){
						if(
							(!instance_is(self, prop) && team != 0)
							|| instance_is(self, RadChest)
							|| instance_is(self, Car)
							|| instance_is(self, CarVenus)
							|| instance_is(self, CarVenusFixed)
							|| instance_is(self, CarThrow)
							|| instance_is(self, MeleeFake)
							|| instance_is(self, JungleAssassinHide)
						){
							if(instance_exists(other.creator)){
								x = other.creator.x;
								y = other.creator.y;
							}
							else{
								x = other.xstart;
								y = other.ystart;
							}
							xprevious = x;
							yprevious = y;
							
							 // Flip:
							if(instance_is(self, Player) && other.creator == self){
								angle += 180 + orandom(10);
							}
							
							 // Effects:
							with(instance_create(x, y, BulletHit)){
								sprite_index = sprPortalDisappear;
								depth        = other.depth - 1;
								image_angle  = 0;
							}
							repeat(3) call(scr.fx, x, y, 2, Smoke);
							call(scr.sound_play_at, x, y, sndPortalAppear, 2.5, 2);
							
							 // Just in Case:
							call(scr.wall_clear, self);
						}
					}
				}
				
				 // Portal:
				if(_portal){
					instance_destroy();
					if(instance_exists(other)){
						instance_create(other.x, other.y, Portal);
					}
				}
				
				 // Death:
				else instance_destroy();
			}
		}
	}
	
#define PortalBullet_destroy
	repeat(5) call(scr.fx, x, y, [direction, 2], Smoke);
	call(scr.sound_play_at, x, y, sndGuardianDisappear, 2, 2);
	
	 // Teleport:
	if(
		instance_exists(creator)
		&& (creator.visible || ("wading" in creator && creator.wading > 0))
		&& (
			position_meeting(x, y, Floor)
			|| place_meeting(x, y, Floor)
			|| (
				point_distance(x, y, creator.x, creator.y) < 512
				&& !collision_line(x, y, creator.x, creator.y, Wall,       false, false)
				&& !collision_line(x, y, creator.x, creator.y, InvisiWall, false, false)
			)
		)
	){
		with(creator){
			 // Disappear:
			if(array_find_index(obj.PortalGuardian, self) >= 0){
				with(instance_create(x, y, BulletHit)){
					sprite_index = other.spr_disappear;
					image_xscale = other.image_xscale * other.right;
					image_yscale = other.image_yscale;
					image_angle  = other.image_angle;
					depth        = other.depth - 1;
				}
			}
			else with(instance_create(x, y, BulletHit)){
				sprite_index = sprPortalDisappear;
				image_angle  = 0;
			}
			
			 // Move & Avoid Walls:
			x = other.x;
			y = other.y;
			if(!call(scr.instance_budge, self, Wall, 40)){
				call(scr.wall_clear, self);
			}
			xprevious = x;
			yprevious = y;
			
			 // Appear:
			image_index = 0;
			if(array_find_index(obj.PortalGuardian, self) >= 0){
				sprite_index = spr_appear;
			}
			else with(instance_create(x, y, BulletHit)){
				sprite_index = spr.PortalBulletHit;
				image_angle  = 0;
			}
			call(scr.sound_play_at, x, y, sndPortalAppear, 3, (instance_is(self, Player) ? 0.5 : 1.5));
			
			 // Move Shield:
			with(instances_matching(CrystalShield, "creator", self)){
				instance_create(x, y, CrystalShieldDisappear);
				x = other.x;
				y = other.y;
			}
			
			 // Player Impact Zone:
			if(instance_is(self, Player)){
				var _minID = instance_max;
				with(call(scr.projectile_create, self, x, y, "BatScreech")){
					image_alpha = 0;
					damage      = 4;
					force       = 1.5;
				}
				with(instances_matching_gt(Dust, "id", _minID)){
					instance_delete(self);
				}
				
				 // Effects:
				sleep(80);
				view_shake_at(x, y, 40);
				motion_add(direction + 180, 4);
				var _ang = random(360);
				for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 5)){
					with(instance_create(x, y, PortalL)){
						mask_index = mskAlly;
						move_contact_solid(_dir + orandom(30), random_range(32, 40));
					}
				}
			}
		}
	}
	
	 // Can't Teleport:
	else with(instance_create(x, y, BulletHit)){
		sprite_index = sprPortalDisappear;
		image_xscale = 0.7;
		image_yscale = image_xscale;
	}
	
	
#define PortalGuardian_create(_x, _y)
	/*
		A rare palace enemy, shoots a projectile that swaps positions with itself and whatever it hit
	*/
	
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle      = spr.PortalGuardianIdle;
		spr_walk      = spr.PortalGuardianIdle;
		spr_hurt      = spr.PortalGuardianHurt;
		spr_dead      = spr.PortalGuardianDead;
		spr_appear    = spr.PortalGuardianAppear;
		spr_disappear = spr.PortalGuardianDisappear;
		spr_shadow    = shd24;
		hitid         = [spr_idle, "PORTAL GUARDIAN"];
		depth         = -2;
		
		 // Sound:
		snd_hurt = sndExploGuardianHurt;
		snd_dead = sndDogGuardianDead;
		snd_mele = sndGuardianFire;
		
		 // Vars:
		mask_index  = mskBandit;
		maxhealth   = 55; //45
		raddrop     = 16;
		meleedamage = 2;
		size        = 2;
		walk        = 0;
		walkspeed   = 0.8;
		maxspeed    = 4;
		gunangle    = random(360);
		portal      = false;
		implode     = false;
		
		 // Alarms:
		alarm1 = 40 + irandom(20);
		
		return self;
	}
	
#define PortalGuardian_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Hovery:
	if(
		!instance_exists(projectile)
		|| !place_meeting(x, y, projectile)
		|| !array_length(call(scr.instances_meeting_instance, self, instances_matching(projectile, "creator", self)))
	){
		speed = max(1, speed);
	}
	
	 // Animate:
	if(sprite_index == spr_appear){
		speed = 0;
		
		if(anim_end){
			image_index = 0;
			sprite_index = spr_idle;
			
			 // Effects:
			repeat(8){
				call(scr.fx, x, y, 3, Dust);
			}
			repeat(3){
				with(instance_create(x + orandom(16), y + orandom(16), PortalL)){
					depth = other.depth - 1;
				}
			}
			call(scr.sound_play_at, x, y, sndGuardianFire, 1.5 + orandom(0.2), 2);
		}
	}
	else if(sprite_index != spr_disappear || anim_end){
		sprite_index = enemy_sprite;
	}
	
	 // FX:
	if(chance_ct(1, 30)){
		with(instance_create(x + hspeed_raw, y + vspeed_raw, PortalL)){
			depth = other.depth + choose(0, -1);
		}
	}
	
#define PortalGuardian_alrm1
	alarm1 = 20 + random(30);
	
	if(enemy_target(x, y)){
		enemy_look(target_direction);
		
		if(target_visible){
			 // Attack:
			if(chance(2, 3) && !array_length(instances_matching(projectile, "creator", self))){
				with(call(scr.projectile_create, self, x, y, "PortalBullet", gunangle, 10)){
					portal = other.portal;
				}
				
				 // Sound:
				sound_play_pitchvol(sndPortalOld, 2 + random(2), 1.5);
			}
			
			 // Move:
			else{
				enemy_walk(
					gunangle + (random_range(60, 100) * choose(-1, 1)),
					random_range(20, 40)
				);
				
				 // Away From Target:
				if(target_distance < 128){
					direction = gunangle + 180 + orandom(30);
				}
			}
		}
		
		 // Wander:
		else enemy_walk(
			gunangle + orandom(40),
			random_range(10, 20)
		);
	}
	
	 // Wander:
	else{
		enemy_walk(random(360), 30);
		enemy_look(direction);
	}
	
#define PortalGuardian_death
	 // Clear Walls:
	with(instance_create(x, y, PortalClear)){
		image_xscale = 2/3;
		image_yscale = image_xscale;
	}
	
	 // Implosion:
	if(implode){
		 // Effects:
		call(scr.sound_play_at, x, y, sndHorrorPortal, 1.5 + orandom(0.1), 3);
		view_shake_at(x, y, 30);
		sleep(30);
		
		 // Implosion Imminent:
		with(call(scr.obj_create, x, y, "PortalGuardianDeath")){
			spr_shadow   = other.spr_shadow;
			spr_shadow_x = other.spr_shadow_x;
			spr_shadow_y = other.spr_shadow_y;
			image_xscale = other.image_xscale * other.right;
			image_yscale = other.image_yscale;
			image_angle  = other.image_angle;
			image_blend  = other.image_blend;
			image_alpha  = other.image_alpha;
			depth        = other.depth;
			mask_index   = other.mask_index;
			raddrop      = other.raddrop;
			direction	 = other.direction;
			speed        = min(other.speed, other.maxspeed);
			move_contact_solid(direction, speed);
		}
		
		 // Hide:
		spr_dead = asset_get_index(`sprPortalL${irandom_range(1, 5)}`);
		snd_dead = -1;
		raddrop  = 0;
	}
	
	 // Pickups:
	else pickup_drop(40, 10, 0);
	
	
#define PortalGuardianDeath_create(_x, _y)
	/*
		The Portal Guardian's death implosion from teleporting into itself
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.PortalGuardianImplode;
		spr_shadow	 = shd24;
		spr_shadow_x = 0;
		spr_shadow_y = 0;
		hitid		 = [sprite_index, "IMPLOSION"];
		image_speed  = 0.4;
		depth		 = -2;
		
		 // Vars:
		mask_index = mskBandit;
		friction   = 0.2;
		wave	   = random(90);
		team	   = -1; // friendly fire is so cool
		raddrop    = 16;
		
		return self;
	}
	
#define PortalGuardianDeath_step
	 // Stumble:
	wave += current_time_scale;
	x += (orandom(1) + random(sin(wave / 10))) * current_time_scale;
	y += (orandom(1) + random(cos(wave / 10))) * current_time_scale;
	
	 // Effects:
	view_shake_max_at(x, y, 3);
	if(chance_ct(2, 3)){
		instance_create(x + orandom(12), y + orandom(12), Smoke);
	}
	if(chance_ct(2, 5)){
		with(instance_create(x + orandom(24), y + orandom(24), PortalL)){
			depth = other.depth - 1;
		}
	}
	
	 // Implode:
	if(anim_end){
		 // Clear Area:
		with(instance_create(x, y, PortalClear)){
			visible      = true;
			sprite_index = mskPlasmaImpact;
			image_speed  = 1/2;
			image_xscale = 1.5;
			image_yscale = image_xscale;
			image_angle  = 45;
			depth        = -1;
		}
		with(call(scr.projectile_create, self, x, y, "BatScreech")){
			image_alpha = 0;
			force       = 1.5;
		}
		
		 // Effects:
		audio_sound_pitch(sound_play_hit(    sndGammaGutsKill, 0), 1.3);
		audio_sound_pitch(sound_play_hit_big(sndPlasmaHugeUpg, 0), 1.2);
		view_shake_at(x, y, 100);
		sleep(100);
		
		 // Bullets:
		for(var _dir = direction; _dir < direction + 360; _dir += (360 / 3)){
			var _num = 16;
			for(var i = 1; i < _num; i++){
				with(call(scr.projectile_create,
					self,
					x,
					y,
					HorrorBullet,
					_dir + (lerp(-45, 45, i / _num) * sign(other.image_xscale)) + orandom(10),
					lerp(2, 5, i / _num) + random(1)
				)){
					sprite_index = sprHorrorBBullet;
					bskin        = true;
					move_contact_solid(direction, 24 * (i / _num));
					with(instance_create(x, y, Dust)){
						motion_set(direction + orandom(10), 4 + random(8));
					}
				}
			}
		}
		
		 // Pickups:
		pickup_drop(40, 0);
		call(scr.rad_drop, x, y, raddrop, direction, speed);
		
		 // Drops Golden Teleport Gun if a player is holding a normal one, or a separate golden weapon:
		with(Player){
			if(
				((array_find_index(["teleport gun", "super teleport gun"], call(scr.wep_raw, wep))  >= 0) ^^ (weapon_get_gold(wep)  != 0)) ||
				((array_find_index(["teleport gun", "super teleport gun"], call(scr.wep_raw, bwep)) >= 0) ^^ (weapon_get_gold(bwep) != 0))
			){
				with(instance_create(other.x, other.y, WepPickup)){
					ammo = true;
					wep  = { wep: "teleport gun", gold: true };
				}
				break;
			}
		}
		
		 // Goodbye:
		instance_destroy();
		exit;
	}
	
	 // Wall Collision:
	call(scr.motion_step, self, 1);
	if(place_meeting(x, y, Wall)){
		x = xprevious;
		y = yprevious;
		move_bounce_solid(true);
	}
	call(scr.motion_step, self, -1);
	
	
#define WallSlide_create(_x, _y)
	/*
		A controller that slides Walls around
		
		Vars:
			slide_inst  - An array containing the Wall instances to slide
			slide_path  - A 2D array containing values: [time, direction, speed, sound]
			              Leaving out direction or speed will maintain the current value
			              Sound can be in the form of an index, or an array of [snd, pit, vol]
			slide_index - The current index of 'slide_path' that the walls are following
			slide_loop  - Should the walls continue sliding on their path forever, true/false
			slide_time  - Number of frames until the next sliding motion
			smoke       - Chance to create Smoke, used for Labs freak dispensers
			
		Ex:
			with(call(scr.obj_create, x, y, "WallSlide")){
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
		
		return self;
	}
	
#define WallSlide_end_step
	slide_inst = instances_matching_ne(slide_inst, "id");
	
	if(array_length(slide_inst)){
		 // Next:
		if(slide_time > 0){
			slide_time -= current_time_scale;
		}
		if(slide_time <= 0){
			 // Tile Override:
			with(slide_inst){
				if(position_meeting(x, y, Wall) || position_meeting(x, y, TopSmall)){
					with(instances_matching_lt(instances_matching(instances_matching(Wall, "x", x), "y", y), "id", id)){
						var _inst = other;
						with(["image_blend", "topspr", "topindex", "l", "h", "w", "r"]){
							variable_instance_set(_inst, self, variable_instance_get(other, self));
						}
						instance_delete(self);
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
							call(scr.sound_play_at, x, y, _snd[0], _snd[1], _snd[2]);
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
					with(call(scr.instances_meeting_instance, self, hitme)){
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
			depth   = min(depth, -1);
			visible = place_meeting(x, y + 16, Floor);
			l       = 0;
			r       = 0;
			w       = 24;
			h       = 24;
			
			 // Effects:
			if(other.smoke > 0 && chance_ct(other.smoke, 1)){
				call(scr.fx, bbox_center_x, bbox_center_y, [other.direction + 180, 2], Smoke);
			}
		}
	}
	else instance_destroy();
	
#define WallSlide_destroy
	 // Visual Fix:
	with(instances_matching_ne(slide_inst, "id")){
		depth   = max(depth, 0);
		visible = place_meeting(x, y + 16, Floor);
		l = (place_free(x - 16, y) ?  0 :  4);
		w = (place_free(x + 16, y) ? 24 : 20) - l;
		r = (place_free(x, y - 16) ?  0 :  4);
		h = (place_free(x, y + 16) ? 24 : 20) - r;
	}
	
	
/// GENERAL
#define ntte_setup_Freak(_inst)
	 // Fish Freaks:
	var _underwater = call(scr.area_get_underwater, GameCont.area);
	with(_inst){
		if("fish_freak" not in self){
			fish_freak = (_underwater || (GameCont.area == area_labs && GameCont.loops > 0 && chance(1, 7)));
		}
		if(fish_freak){
			spr_idle = spr.FishFreakIdle;
			spr_walk = spr.FishFreakWalk;
			spr_hurt = spr.FishFreakHurt;
			spr_dead = spr.FishFreakDead;
			hitid    = [spr_idle, "FREAK"];
		}
	}
	
#define ntte_setup_PopoFreak(_inst)
	 // No Infinite Rads:
	if(GameCont.loops <= 0){
		with(instances_matching(_inst, "kills", 0)){
			raddrop = 0;
		}
	}
	
#define ntte_begin_step
	 // Custom Necromancy:
	if(instance_exists(ReviveArea) && (instance_exists(Corpse) || instance_exists(WepPickup))){
		var _inst = instances_matching_gt(instances_matching_le(ReviveArea, "alarm0", ceil(current_time_scale)), "alarm0", 0);
		if(array_length(_inst)) with(_inst){
			 // Skeals:
			if(place_meeting(x, y, Corpse)){
				with(call(scr.instances_meeting_instance, self, instances_matching_lt(Corpse, "size", 3))){
					var _sealType = array_find_index(spr.SealDead, sprite_index);
					if(_sealType >= 0){
						if(place_meeting(x, y, other)){
							with(call(scr.obj_create, x, y, "Seal")){
								type  = _sealType;
								skeal = true;
								kills = 0;
								
								 // Effects:
								instance_create(x, y, ReviveFX);
								sound_play_hit_big(sndNecromancerRevive, 0.2);
							}
							instance_delete(self);
						}
					}
				}
			}
			
			 // Merged Weapons:
			if(place_meeting(x, y, WepPickup)){
				with(call(scr.instances_meeting_instance, self, WepPickup)){
					if(point_distance(x, y, other.x, other.y - 2) < (other.sprite_width * 0.4)){
						if(weapon_get_area(wep) >= 0 && call(scr.wep_raw, wep) != "merge"){
							var _part = call(scr.weapon_merge_decide, 0, GameCont.hard + (2 * curse));
							if(array_length(_part) >= 2){
								wep = call(scr.weapon_merge, _part[0], _part[1]);
								mergewep_indicator = null;
								
								 // FX:
								sound_play_pitchvol(sndGunGun,  0.5 + orandom(0.1), 0.5);
								sound_play_pitchvol(sprEPickup, 0.5 + orandom(0.1), 0.5);
								call(scr.sound_play_at, x, y, sndNecromancerRevive, 1,                  1.8);
								call(scr.sound_play_at, x, y, sndNecromancerDead,   1.5 + orandom(0.1), 1.2);
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
	}
	
#define ntte_draw_dark(_type)
	switch(_type){
		
		case "normal":
		case "end":
			
			var _gray = (_type == "normal");
			
			 // Button Revive:
			if(array_length(obj.ButtonReviveArea)){
				var _r = 32 + (32 * _gray);
				with(instances_matching_ne(obj.ButtonReviveArea, "id")){
					draw_circle(x, y, _r + irandom(2), false);
				}
			}
			
			 // Portal Guardians:
			if(array_length(obj.PortalGuardian)){
				var _r = 24 + (68 * _gray),
					_o = 4  + (2  * _gray);
					
				with(instances_matching_ne(obj.PortalGuardian, "id")){
					draw_circle(x, y, _r + random(_o), false);
				}
			}
			
			break;
			
	}
	
	
/// SCRIPTS
#macro  call                                                                                    script_ref_call
#macro  scr                                                                                     global.scr
#macro  obj                                                                                     global.obj
#macro  spr                                                                                     global.spr
#macro  snd                                                                                     global.snd
#macro  msk                                                                                     spr.msk
#macro  mus                                                                                     snd.mus
#macro  lag                                                                                     global.debug_lag
#macro  ntte                                                                                    global.ntte_vars
#macro  epsilon                                                                                 global.epsilon
#macro  mod_current_type                                                                        global.mod_type
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
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
#macro  instance_max                                                                            instance_create(0, 0, DramaCamera)
#macro  current_frame_active                                                                    ((current_frame + epsilon) % 1) < current_time_scale
#macro  game_scale_nonsync                                                                      game_screen_get_width_nonsync() / game_width
#macro  anim_end                                                                                (image_index + image_speed_raw >= image_number) || (image_index + image_speed_raw < 0)
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed == 0) ? spr_idle : spr_walk) : sprite_index
#macro  enemy_boss                                                                              ('boss' in self) ? boss : ('intro' in self || array_find_index([Nothing, Nothing2, BigFish, OasisBoss], object_index) >= 0)
#macro  player_active                                                                           visible && !instance_exists(GenCont) && !instance_exists(LevCont) && !instance_exists(SitDown) && !instance_exists(PlayerSit)
#macro  target_visible                                                                          !collision_line(x, y, target.x, target.y, Wall, false, false)
#macro  target_direction                                                                        point_direction(x, y, target.x, target.y)
#macro  target_distance                                                                         point_distance(x, y, target.x, target.y)
#macro  bbox_width                                                                              (bbox_right + 1) - bbox_left
#macro  bbox_height                                                                             (bbox_bottom + 1) - bbox_top
#macro  bbox_center_x                                                                           (bbox_left + bbox_right + 1) / 2
#macro  bbox_center_y                                                                           (bbox_top + bbox_bottom + 1) / 2
#macro  FloorNormal                                                                             instances_matching(Floor, 'object_index', Floor)
#macro  alarm0_run                                                                              alarm0 && !--alarm0 && !--alarm0 && (script_ref_call(on_alrm0) || !instance_exists(self))
#macro  alarm1_run                                                                              alarm1 && !--alarm1 && !--alarm1 && (script_ref_call(on_alrm1) || !instance_exists(self))
#macro  alarm2_run                                                                              alarm2 && !--alarm2 && !--alarm2 && (script_ref_call(on_alrm2) || !instance_exists(self))
#macro  alarm3_run                                                                              alarm3 && !--alarm3 && !--alarm3 && (script_ref_call(on_alrm3) || !instance_exists(self))
#macro  alarm4_run                                                                              alarm4 && !--alarm4 && !--alarm4 && (script_ref_call(on_alrm4) || !instance_exists(self))
#macro  alarm5_run                                                                              alarm5 && !--alarm5 && !--alarm5 && (script_ref_call(on_alrm5) || !instance_exists(self))
#macro  alarm6_run                                                                              alarm6 && !--alarm6 && !--alarm6 && (script_ref_call(on_alrm6) || !instance_exists(self))
#macro  alarm7_run                                                                              alarm7 && !--alarm7 && !--alarm7 && (script_ref_call(on_alrm7) || !instance_exists(self))
#macro  alarm8_run                                                                              alarm8 && !--alarm8 && !--alarm8 && (script_ref_call(on_alrm8) || !instance_exists(self))
#macro  alarm9_run                                                                              alarm9 && !--alarm9 && !--alarm9 && (script_ref_call(on_alrm9) || !instance_exists(self))
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < _numer * current_time_scale;
#define pround(_num, _precision)                                                        return  (_precision == 0) ? _num : round(_num / _precision) * _precision;
#define pfloor(_num, _precision)                                                        return  (_precision == 0) ? _num : floor(_num / _precision) * _precision;
#define pceil(_num, _precision)                                                         return  (_precision == 0) ? _num :  ceil(_num / _precision) * _precision;
#define frame_active(_interval)                                                         return  ((current_frame + epsilon) % _interval) < current_time_scale;
#define lerp_ct(_val1, _val2, _amount)                                                  return  lerp(_val2, _val1, power(1 - _amount, current_time_scale));
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define angle_lerp_ct(_ang1, _ang2, _num)                                               return  _ang2 + (angle_difference(_ang1, _ang2) * power(1 - _num, current_time_scale));
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define enemy_walk(_dir, _num)                                                                  direction = _dir; walk = _num; if(speed < friction_raw) speed = friction_raw;
#define enemy_face(_dir)                                                                        _dir = ((_dir % 360) + 360) % 360; if(_dir < 90 || _dir > 270) right = 1; else if(_dir > 90 && _dir < 270) right = -1;
#define enemy_look(_dir)                                                                        _dir = ((_dir % 360) + 360) % 360; if(_dir < 90 || _dir > 270) right = 1; else if(_dir > 90 && _dir < 270) right = -1; if('gunangle' in self) gunangle = _dir;
#define enemy_target(_x, _y)                                                                    target = (instance_exists(Player) ? instance_nearest(_x, _y, Player) : ((instance_exists(target) && target >= 0) ? target : noone)); return (target != noone);
#define script_bind(_scriptObj, _scriptRef, _depth, _visible)                           return  call(scr.script_bind, script_ref_create(script_bind), _scriptObj, (is_real(_scriptRef) ? script_ref_create(_scriptRef) : _scriptRef), _depth, _visible);