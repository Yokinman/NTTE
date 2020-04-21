#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	
	DebugLag = false;
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#macro DebugLag global.debug_lag

#define FreakChamber_create(_x, _y)
	/*
		Creates an epic room on the side of the level that opens to release freaks
		
		Vars:
			image_xscale - Room's length
			image_yscale - Room's height
			hallway_size - Hallway's length
			slide_path   - The sliding door's path, see 'WallSlide_create()'
			               The direction value is altered based on the room's angle
			alarm0       - Delay before opening, is set when a Player passes nearby
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		mask_index = mskFloor;
		image_xscale = 2;
		image_yscale = 1;
		hallway_size = 1;
		alarm0 = -1;
		slide_path = [
			[45,  0, 0], // Delay
			[16,  0, 1],
			[10,  0, 0], // Delay
			[16, 90, 1]
		];
		
		return id;
	}
	
#define FreakChamber_step
	if(alarm0 < 0){
		 // No Portal:
		if(!instance_exists(enemy) && !instance_exists(becomenemy)){
			alarm0 = 1;
		}
		
		 // Wait for Nearby Player:
		else if(instance_exists(Player)){
			var _target = instance_nearest(x, y, Player);
			if(in_sight(_target) && in_distance(_target, 64)){
				alarm0 = 60;
			}
		}
	}
	
#define FreakChamber_alrm0
	alarm0 = 30;
	
	var	_ang       = round(random(360) / 90) * 90,
		_hallDis   = 32 * hallway_size,
		_slidePath = slide_path,
		_target    = instance_nearest(x, y, Player),
		_open      = false;
		
	with(array_shuffle(FloorNormal)){
		var	_fx = bbox_center_x,
			_fy = bbox_center_y,
			_fw = bbox_width,
			_fh = bbox_height;
			
		if(!collision_line(_fx, _fy, _target.x, _target.y, Wall, false, false) && point_distance(_fx, _fy, _target.x, _target.y) < 128){
			with(other){
				for(var _dir = _ang; _dir < _ang + 360; _dir += 90){
					var	_hallW = max(1, abs(lengthdir_x(_hallDis / 32, _dir))),
						_hallH = max(1, abs(lengthdir_y(_hallDis / 32, _dir))),
						_hallX = _fx + lengthdir_x((_fw / 2) + (_hallDis / 2), _dir),
						_hallY = _fy + lengthdir_y((_fh / 2) + (_hallDis / 2), _dir),
						_hallXOff = lengthdir_x(32, _dir),
						_hallYOff = lengthdir_y(32, _dir);
						
					if(
						array_length(instance_rectangle_bbox(
							_hallX - (_hallW * 16) + max(0, _hallXOff),
							_hallY - (_hallH * 16) + max(0, _hallYOff),
							_hallX + (_hallW * 16) + min(0, _hallXOff) - 1,
							_hallY + (_hallH * 16) + min(0, _hallYOff) - 1,
							[Floor, Wall, TopSmall]
						)) <= 0
					){
						var _yoff = -(sprite_get_height(mask_index) * image_yscale) / 2;
						x = _fx + lengthdir_x((_fw / 2) + _hallDis, _dir) + lengthdir_x(_yoff, _dir - 90);
						y = _fy + lengthdir_y((_fh / 2) + _hallDis, _dir) + lengthdir_y(_yoff, _dir - 90);
						
						image_angle = _dir;
						
						if(!place_meeting(x, y, Floor) && !place_meeting(x, y, Wall) && !place_meeting(x, y, TopSmall)){
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
							var _minID = GameObject.id;
							floor_set_style(1, null);
							var _hallFloor = floor_fill(_hallX, _hallY, _hallW, _hallH, "");
							floor_fill(_x, _y, _w, _h, "");
							floor_reset_style();
							with(instances_matching_gt(Wall, "id", _minID)){
								topspr = area_get_sprite(GameCont.area, sprWall1Trans);
								if(sprite_index == sprWall6Bot) sprite_index = spr.Wall6BotTrans;
							}
							
							 // Reveal Tiles:
							var _reveal = [];
							with(instances_matching_gt([Floor, Wall, TopSmall], "id", _minID)){
								var _can = true;
								
								 // Don't Cover Doors:
								if(array_exists(_hallFloor, id)){
									with(_wall){
										if(rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, other.bbox_left, other.bbox_top, other.bbox_right, other.bbox_bottom)){
											_can = false;
											break;
										}
									}
								}
								
								 // Don't Cover Pre-Existing TopSmalls:
								if(instance_is(self, Wall) || instance_is(self, TopSmall)){
									with(_tops){
										if(x == other.x && y == other.y){
											_can = false;
											break;
										}
									}
								}
								
								if(_can) array_push(_reveal, id);
							}
							with(floor_reveal(_reveal, 15)){
								move_dis = 0;
								flash_color = color;
								
								 // Delay:
								for(var i = 0; i < min(2, array_length(_slidePath)); i++){
									time += _slidePath[i, 0];
								}
							}
							
							 // Freaks:
							repeat(4 + irandom(4)){
								with(instance_create(_x + orandom(8), _y + orandom(8), Freak)){
									walk = true;
									direction = random(360);
								}
							}
							//obj_create(_x, _y, "LabsVat");
							
							 // Sliding Doors:
							with(_wall){
								with(instance_create(x, y, object_index)){
									variable_instance_set_list(self, other);
									
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
								
								 // Recreate TopSmall:
								else variable_instance_set_list(instance_create(x, y, object_index), self);
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
		if(instance_exists(enemy)) portal_poof();
		instance_destroy();
	}
	
	
#define LabsVat_create(_x, _y)
	/*
		A giant version of the MutantTube, which can contain special enemies or loot
	*/
	
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle = spr.LabsVatIdle;
		spr_hurt = spr.LabsVatHurt;
		spr_dead = spr.LabsVatDead;
		spr_back = spr.LabsVatBack;
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
	
#define LabsVat_setup
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
	
#define LabsVat_step
	if(setup) LabsVat_setup();
	wave += current_time_scale;
	x = xstart;
	y = ystart;

	 // Draw Back:
	script_bind_draw(LabsVat_draw_back, depth + 1/100, id);
	
#define LabsVat_draw_back(_inst)
	with(_inst){
		var _imageIndex = (wave * image_speed);
		draw_sprite_ext(spr_back, _imageIndex, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		
		 // Draw Thing:
		var _oc = chance(1, 30),
			_ol = 2,
			_od = random(360),
			_xo = _oc * lengthdir_x(_ol, _od),
			_yo = _oc * lengthdir_y(_ol, _od),
			_sprite = thing.sprite,
			_index = (thing.index == -1 ? _imageIndex : thing.index),
			_x = x + _xo + (sin(wave / 10) * 2),
			_y = y + _yo + (cos(wave / 10) * 3),
			_xScale = (image_xscale * thing.right),
			_yScale = image_yscale,
			_angle = image_angle + sin(wave / 30) * 30,
			_blend = c_white,
			_alpha = image_alpha;
			
		draw_set_fog(true, thing.color, 0, 0);
		draw_sprite_ext(_sprite, _index, _x, _y, _xScale, _yScale, _angle, _blend, _alpha);
		draw_set_fog(false, c_white, 0, 0);
	}
	
	 // Goodbye:
	instance_destroy();
	
#define LabsVat_alrm1
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
	
#define LabsVat_alrm2
	alarm2 = 30 + random(60);
	var _target = instance_nearest(x, y, Player);
	if(in_sight(_target)){
		thing.right = (x > _target.x ? -1 : 1);
	}
	
#define LabsVat_death
	 // Effects:
	repeat(24){
		with(instance_create(x, y, Shell)){
			sprite_index = spr.LabsVatGlass;
			image_index = irandom(image_number - 1);
			image_speed = 0;
			motion_set(random(360), random_range(2, 6));
			x += hspeed;
			y += vspeed;
		}
	}
	with(obj_create(x, y, "BuriedVaultChestDebris")){
		sprite_index = spr.LabsVatLid;
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
			case WeaponChest:
			case "OrchidChest":
			case "Backpack":
			case "CatChest":
			case "BatChest":
				obj_create(_x, _y, type);
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
	
	
#define WallSlide_create(_x, _y)
	/*
		A controller that slides Walls around
		
		Vars:
			slide_inst  - An array containing the Wall instances to slide
			slide_path  - A 2D array containing values to set: [time, direction, speed]
			              Leaving any values undefined will maintain the current value
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
					[16, 90],   // Move up 16
					[90, 0, 0], // Wait 3 seconds
					[32, 0, 1]  // Move right 32
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
		var _pathTries = array_length(slide_path);
		if(slide_time > 0){
			slide_time -= current_time_scale;
		}
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
				
				 // Tile Override:
				with(slide_inst){
					if(position_meeting(x, y, TopSmall)){
						with(instances_matching(instances_matching(instances_matching_ne(TopSmall, "id", id), "x", x), "y", y)){
							instance_destroy();
						}
					}
				}
			}
			
			 // Done:
			else{
				instance_destroy();
				exit;
			}
		}
		
		 // Slide Walls:
		var	_mx = hspeed_raw,
			_my = vspeed_raw;
			
		with(slide_inst){
			x += _mx;
			y += _my;
			
			 // Collision:
			if(_mx != 0 || _my != 0){
				if(place_meeting(x, y, hitme) || place_meeting(x, y, chestprop)){
					with(instances_meeting(x, y, [hitme, chestprop])){
						if(place_meeting(x, y, other)){
							if(!place_meeting(x + _mx, y, Wall)) x += _mx;
							if(!place_meeting(x, y + _my, Wall)) y += _my;
						}
					}
				}
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
	with(instances_matching(slide_inst, "", null)){
		 // Visual:
		depth = max(depth, 0);
		visible = place_meeting(x, y + 16, Floor);
		l = (place_free(x - 16, y) ?  0 :  4);
		w = (place_free(x + 16, y) ? 24 : 20) - l;
		r = (place_free(x, y - 16) ?  0 :  4);
		h = (place_free(x, y + 16) ? 24 : 20) - r;
		
		 // Wall Override:
		with(instances_matching(instances_matching(instances_matching_ne(Wall, "id", id), "x", x), "y", y)){
			var _inst = other;
			with(["image_blend", "topspr", "topindex", "l", "h", "w", "r"]){
				variable_instance_set(_inst, self, variable_instance_get(other, self));
			}
			instance_delete(id);
			break;
		}
	}
	
	
/// Scripts
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
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  anim_end                                                                                image_index + image_speed_raw >= image_number
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
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
#define trace_error(_error)                                                                     mod_script_call_nc('mod', 'telib', 'trace_error', _error);
#define view_shift(_index, _dir, _pan)                                                          mod_script_call_nc('mod', 'telib', 'view_shift', _index, _dir, _pan);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc('mod', 'telib', 'sleep_max', _milliseconds);
#define in_distance(_inst, _dis)                                                        return  mod_script_call(   'mod', 'telib', 'in_distance', _inst, _dis);
#define in_sight(_inst)                                                                 return  mod_script_call(   'mod', 'telib', 'in_sight', _inst);
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
#define boss_intro(_name, _sound, _music)                                               return  mod_script_call_nc('mod', 'telib', 'boss_intro', _name, _sound, _music);
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
#define pool(_pool)                                                                     return  mod_script_call_nc('mod', 'telib', 'pool', _pool);