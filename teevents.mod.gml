/*
	1) Add the event using 'teevent_add(_event)'
	2) Define scripts:
		Event_text    : Returns the event's loading tip, leave undefined or return a blank string for no loading tip
		Event_area    : Returns the event's spawn area, leave undefined if it can spawn on any area
		Event_chance  : Returns the event's spawn chance from 0 to 1, leave undefined if it always spawns
		Event_create  : The event's creation code, called from ntte.mod's level_start script (can also define variables here to be used in the step or cleanup events)
		Event_step    : The event's step code
		Event_cleanup : The event's cleanup code, called when the "NTTEEvent" controller object is destroyed (usually when the level ends)
*/

#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	mus = mod_variable_get("mod", "teassets", "mus");
	sav = mod_variable_get("mod", "teassets", "sav");
	
	global.event_list = [];
	
	 // Event Execution Order:
	teevent_add("MaggotPark");
	teevent_add("ScorpionCity");
	teevent_add("BanditCamp");
	teevent_add("RavenArena");
	teevent_add("GatorDen");
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro area_campfire     0
#macro area_desert       1
#macro area_sewers       2
#macro area_scrapyards   3
#macro area_caves        4
#macro area_city         5
#macro area_labs         6
#macro area_palace       7
#macro area_vault        100
#macro area_oasis        101
#macro area_pizza        102
#macro area_mansion      103
#macro area_cursed_caves 104
#macro area_jungle       105
#macro area_hq           106
#macro area_crib         107

#macro ScorpionCityPet instances_matching_gt(instances_matching(instances_matching(CustomHitme, "name", "Pet"), "pet", "Scorpion"), "scorpion_city", 0)

#define BanditCamp_text    return "BANDITS";
#define BanditCamp_area    return area_desert;
#define BanditCamp_chance  return ((GameCont.subarea == 3) ? 1/10 : ((GameCont.loops > 0) ? 1/20 : 0));

#define BanditCamp_create
	var	_w = 5,
		_h = 4,
		_type = floor_fill,
		_dirOff = 30,
		_spawnX = x,
		_spawnY = y,
		_spawnDis = 128,
		_spawnFloor = FloorNormal;
		
	floor_set_align(32, 32, null, null);
	
	with(floor_room(_w - 2, _h - 2, _type, _dirOff, _spawnX, _spawnY, _spawnDis, _spawnFloor)){
		script_execute(_type, x, y, _w, _h);
		
		 // Dying Campfire:
		with(instance_create(x, y, Effect)){
			sprite_index = spr.BanditCampfire;
			image_xscale = choose(-1, 1);
			depth = 8;
			with(instance_create(x, y - 2, GroundFlame)) alarm0 *= 4;
		}
		
		 // Main Tents:
		var	_ang = random(360),
			_chests = instances_matching_ne([chestprop, RadChest], "name", "PetWeaponBecome");
			
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 3)){
			var	l = 40,
				d = _dir + orandom(10);
				
			with(obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "BanditTent")){
				 // Grab Chests:
				with(instance_nearest_array(x, y, _chests)){
					_chests = array_delete_value(_chests, self);
					with(other){
						target = other;
						event_perform(ev_step, ev_step_begin);
					}
				}
			}
		}
		
		 // Bro:
		obj_create(x, y, "BanditHiker");
		
		 // Reduce Nearby Non-Bandits:
		with(instances_matching([MaggotSpawn, BigMaggot], "", null)){
			if(chance(1, point_distance(x, y, other.x, other.y) / (teevent_get_active("MaggotPark") ? 64 : 160))){
				instance_delete(id);
			}
		}
		with(instances_matching([Scorpion, GoldScorpion], "", null)){
			if(chance(1, point_distance(x, y, other.x, other.y) / (teevent_get_active("ScorpionCity") ? 32 : 160))){
				instance_delete(id);
			}
		}
		
		 // Random Tent Spawns:
		with(array_shuffle(instances_matching(FloorNormal, "styleb", false))){
			if(chance(1, point_distance(x, y, other.x, other.y) / 24)){
				if(!place_meeting(x, y, Wall) && !place_meeting(x, y, hitme)){
					var	_fw = bbox_width,
						_fh = bbox_height,
						_fx = x + (_fw / 2),
						_fy = y + (_fh / 2);
						
					if(point_distance(_fx, _fy, _spawnX, _spawnY) > 64){
						var	_sideStart = choose(-1, 1),
							_spawn = true;
							
						 // Wall Tent:
						for(var _side = _sideStart; abs(_side) <= 1; _side += 2 * -_sideStart){
							if(_spawn && !place_meeting(x + (_fw * _side), y, Floor)){
								_spawn = false;
								with(obj_create(_fx + (((_fw / 2) - irandom_range(3, 5)) * _side), _fy - random(2), "BanditTent")){
									spr_idle = spr.BanditTentWallIdle;
									spr_hurt = spr.BanditTentWallHurt;
									spr_dead = spr.BanditTentWallDead;
									image_xscale = -_side;
								}
							}
						}
						
						 // Can't Spawn Wall Tent, Spawn Normal:
						if(_spawn){
							if(!collision_rectangle(_fx - 32, _fy - 32, _fx + 32, _fy + 32, Wall, false, false)){
								if(!collision_rectangle(bbox_left - 4, bbox_top - 4, bbox_right + 4, bbox_bottom + 4, hitme, false, false)){
									_spawn = false;
									obj_create(_fx + orandom(8), _fy + orandom(8), (chance(1, 3) ? Barrel : "BanditTent"));
								}
							}
						}
					}
				}
			}
		}
		
		 // Riders:
		if(teevent_get_active("ScorpionCity")){
			var	_rideList = array_shuffle(instances_matching([Scorpion, GoldScorpion], "", null)),
				_rideNum = 0;
				
			with(instances_matching(Bandit, "name", "BanditCamper")){
				if(_rideNum >= array_length(_rideList)) break;
				if(chance(1, 2)){
					rider_target = _rideList[_rideNum++];
				}
			}
		}
	}
	
	floor_reset_align();
	
	
#define MaggotPark_text    return "SMELLS BAD";
#define MaggotPark_area    return area_desert;
#define MaggotPark_chance  return 1/60;

#define MaggotPark_create
	var	_x = x,
		_y = y,
		_num = 3,
		_ang = random(360),
		_nestNum = _num,
		_nestDir = _ang,
		_nestDis = 12 + (4 * _nestNum),
		_w = ceil(((2 * (_nestDis + 32)) + 32) / 32),
		_h = _w,
		_type = floor_fill_round,
		_dirOff = 0,
		_floorDis = 0,
		_spawnX = _x,
		_spawnY = _y,
		_spawnDis = 160,
		_spawnFloor = FloorNormal;
		
	 // Find Spawn Location:
	with(floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)){
		_x = x;
		_y = y;
	}
	with(instance_furthest(_spawnX, _spawnY, RadChest)){
		with(instance_nearest_bbox(_x, _y, _spawnFloor)){
			var	_fx = bbox_center_x,
				_fy = bbox_center_y;
				
			if(point_distance(_fx, _fy, _spawnX, _spawnY) >= _spawnDis){
				_x = _fx;
				_y = _fy;
			}
		}
		instance_delete(id);
	}
	
	 // Generate Area:
	floor_set_align(32, 32, null, null);
	floor_set_style(1, GameCont.area);
	
	with(floor_room_create(_x, _y, _w - 2, _h - 2, _type, point_direction(_spawnX, _spawnY, _x, _y), _dirOff, _floorDis)){
		var _minID = GameObject.id;
		script_execute(_type, x, y, _w, _h);
		
		 // Tendril Floors:
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
			var	_fx = x + lengthdir_x((_w * 16) - 32, _dir),
				_fy = y + lengthdir_y((_h * 16) - 32, _dir),
				_off = 0;
				
			for(var _size = 3; _size > 0; _size--){
				var	_dis = _size * 16,
					_dirOff = round((_dir + _off) / 90) * 90;
					
				_fx += lengthdir_x(_dis, _dirOff);
				_fy += lengthdir_y(_dis, _dirOff);
				floor_fill(_fx, _fy, _size, _size);
				_fx += lengthdir_x(_dis, _dirOff);
				_fy += lengthdir_y(_dis, _dirOff);
				_off += orandom(60);
			}
		}
		
		 // Nests:
		for(var d = _nestDir; d < _nestDir + 360; d += (360 / _nestNum)){
			var l = _nestDis + random(4 * _nestNum);
			obj_create(round(x + lengthdir_x(l, d)), round(y + lengthdir_y(l, d)), "BigMaggotSpawn");
		}
		
		 // Tendril Floors Setup:
		var	_nestTinyNum = random_range(5, 6),
			_burrowNum = random_range(3, 4);
			
		with(array_shuffle(instances_matching_gt(Floor, "id", _minID))){
			var	_fx = bbox_center_x,
				_fy = bbox_center_y,
				_cx = other.x,
				_cy = other.y;
				
			 // Enemies:
			if(!place_meeting(x, y, enemy)){
				if(_nestTinyNum > 0){
					_nestTinyNum--;
					with(instance_create(_fx, _fy, MaggotSpawn)){
						x = xstart;
						y = ystart;
						move_contact_solid(point_direction(_cx, _cy, x, y) + orandom(120), random(16));
						instance_create(x, y, Maggot);
					}
				}
				else if(_burrowNum > 0){
					_burrowNum--;
					obj_create(_fx, _fy, "WantBigMaggot");
				}
			}
			
			 // Remove Details:
			with(instance_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, Detail)){
				instance_destroy();
			}
		}
		
		 // Sound:
		sound_volume(sound_loop(sndMaggotSpawnIdle), 0.4);
	}
	
	floor_reset_align();
	floor_reset_style();
	
	
#define ScorpionCity_text    return "WHERE ARE WE GOING";
#define ScorpionCity_area    return area_desert;
#define ScorpionCity_chance  return array_length(ScorpionCityPet);

#define ScorpionCity_create
	 // Alert:
	with(ScorpionCityPet){
		scorpion_city--;
		with(scrAlert(self, spr_icon)){
			snd_flash = sndScorpionMelee;
		}
	}
	
	 // No Scorpion Pets:
	with(instances_matching(CustomProp, "name", "ScorpionRock")){
		friendly = -1;
	}
	
	 // Delete Lone Walls:
	with(Wall) if(place_meeting(x, y, Floor)){
		var _delete = true;
		for(var d = 0; d < 360; d += 90){
			if(place_meeting(x + lengthdir_x(16, d), y + lengthdir_y(16, d), Wall)){
				_delete = false;
				break;
			}
		}
		if(_delete) instance_delete(id);
	}
	
	 // More Scorpions:
	with(instances_matching_lt(enemy, "size", 4)){
		if(!floor_get(x, y).styleb){
			if(!instance_is(self, Bandit) || chance(1, 2)){
				var	_scorp = [[Scorpion, "BabyScorpion"], [GoldScorpion, "BabyScorpionGold"]],
					_gold = chance(size, 5),
					_baby = (size <= 1);
					
				obj_create(x, y, _scorp[_gold, _baby]);
				instance_delete(id);
			}
		}
	}
	with(instances_matching(CustomEnemy, "name", "BigMaggotSpawn")){
		scorp_drop++;
	}
	
	 // Scorpion Nests:
	var	_minID = GameObject.id,
		_spawnX = x,
		_spawnY = y,
		_spawnFloor = FloorNormal;
		
	repeat(3){
		var	_w = irandom_range(3, 5),
			_h = _w,
			_type = (min(_w, _h) > 3) ? floor_fill_round : floor_fill,
			_dirOff = 90,
			_spawnDis = 64 + (_w * 16);
			
		floor_set_align(32, 32, null, null);
		
		with(floor_room(_w, _h, _type, _dirOff, _spawnX, _spawnY, _spawnDis, _spawnFloor)){
			 // Family:
			repeat(max(1, ((_w + _h) / 2) - 2)){
				instance_create(x, y, ((chance(1, 5) || !instance_exists(GoldScorpion)) ? GoldScorpion : Scorpion));
			}
			
			 // Props:
			var	_boneNum = round(((_w * _h) / 16) + orandom(1)),
				_ang = random(360);
				
			for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _boneNum)){
				var	d = _dir + orandom(30),
					_obj = choose("Backpacker", LightBeam, WepPickup);
					
				with(obj_create(round(x + lengthdir_x((_w * 16) - 24, d)), round(y + lengthdir_y((_h * 16) - 24, d)), _obj)){
					if(_obj == WepPickup) wep = "crabbone";
				}
			}
			
			 // Details:
			for(var d = 0; d < 360; d += random_range(4, 10)){
				var l = (chance(1, 3) ? random_range(1/3, 1/2) : random(1/4)) * 32;
				with(instance_create(round(x + lengthdir_x(_w * l, d)), round(y + lengthdir_y(_h * l, d)), Detail)){
					if(floor(image_index) != 4 && chance(1, 5)){
						image_index = 4;
					}
				}
			}
		}
		
		floor_reset_align();
	}
	
	 // Nest Corner Walls:
	with(instances_matching_gt(Floor, "id", _minID)){
		var	_x1 = bbox_left,
			_y1 = bbox_top,
			_x2 = bbox_right + 1,
			_y2 = bbox_bottom + 1,
			_cx = bbox_center_x,
			_cy = bbox_center_y,
			_w = _x2 - _x1,
			_h = _y2 - _y1,
			_break = false;
			
		for(var	_x = _x1; _x < _x2; _x += _w - 16){
			for(var	_y = _y1; _y < _y2; _y += _h - 16){
				var	_sideX = sign((_x + 8) - _cx),
					_sideY = sign((_y + 8) - _cy);
					
				if(!place_meeting(_x1 + (_w * _sideX), _y1, Floor) && !place_meeting(_x1, _y1 + (_h * _sideY), Floor)){
					instance_create(_x, _y, Wall);
					
					 // Corner Decals:
					with(obj_create(_x + 8 - (8 * _sideX), _y, "WallDecal")){
						image_xscale = -_sideX;
					}
					
					_break = true;
					break;
				}
			}
			if(_break) break;
		}
	}
	
	
	
#define GatorDen_text    return "DISTANT CHATTER";
#define GatorDen_area    return area_sewers;
#define GatorDen_chance  return ((crown_current == "crime") ? 1 : (unlock_get("lairCrown") ? 1/5 : 0));

#define GatorDen_create
	var _inst = [];
	
	with(array_shuffle(FloorNormal)){
		if(!place_meeting(x, y, Wall)){
			var	_fx = bbox_center_x,
				_fy = bbox_center_y,
				_w = 5 * 32,
				_h = 4 * 32,
				_ang = 90 * irandom(3),
				_border = 32,
				_end = false;
				
			for(var _dir = _ang; _dir < _ang + 360; _dir += 90){
				if(!place_meeting(x + lengthdir_x(32, _dir), y + lengthdir_y(32, _dir), Floor)){
					for(var _dis = _border + choose(32, 64, 96); _dis >= _border; _dis -= 32){
						var	_hallXOff = lengthdir_x(_dis - _border, _dir + 180),
							_hallYOff = lengthdir_y(_dis - _border, _dir + 180),
							_cx = _fx + lengthdir_x(16 + _dis + (_w / 2), _dir),
							_cy = _fy + lengthdir_y(16 + _dis + (_h / 2), _dir);
							
						if(!collision_rectangle(
							_cx - (_w / 2) - _border + min(0, _hallXOff),
							_cy - (_h / 2) - _border + min(0, _hallYOff),
							_cx + (_w / 2) + _border + max(0, _hallXOff) - 1,
							_cy + (_h / 2) + _border + max(0, _hallYOff) - 1,
							Floor,
							false,
							false
						)){
							 // Floors:
							floor_fill(_cx, _cy, _w / 32, _h / 32);
							
							 // Entrance:
							floor_set_style(1, "lair");
							for(var l = _border; l <= _dis; l += 32){
								with(floor_set(_fx - 16 + lengthdir_x(l, _dir), _fy - 16 + lengthdir_y(l, _dir), true)){
									 // Doors:
									if(l > _dis - 32){
										door_create(x + 16, y + 16, _dir);
									}
									if(l <= _border){
										door_create(x + 16, y + 16, _dir + 180);
									}
									
									 // Pipes:
									else floor_bones(1, 1/10, true);
								}
							}
							floor_reset_style();
							
							 // Table:
							other.x = _cx + lengthdir_x(12, _dir + 180);
							other.y = _cy + lengthdir_y(12, _dir + 180);
							with(instance_create(other.x, other.y, Table)){
								spr_idle = sprTable1;
								spr_hurt = sprTable1Hurt;
								spr_dead = sprTable1Dead;
								spr_shadow = shd32;
								maxhealth = 5;
								my_health = maxhealth;
								
								 // Furnishment:
								obj_create(x, y, "SewerRug");
								
								 // Light:
								with(obj_create(x, y - 30, "CatLight")){
									w1 = 16;
								}
								
								 // Table Variance:
								if(chance(1, 3)){
									spr_idle = sprTable2;
									spr_hurt = sprTable2Hurt;
									spr_dead = sprTable2Dead;
								}
								else if(chance(1, 2)){
									with(instance_create(x, y - 10, Corpse)){
										sprite_index = sprBanditDead;
										image_xscale = choose(-1, 1);
										mask_index = mskBandit;
										size = 1;
										other.depth = depth;
									}
								}
								else with(instance_create(x, y - 9, MoneyPile)){
									x = xstart;
									y = ystart;
									depth = other.depth - 1;
								}
								
								 // The Boys:
								array_push(_inst, id);
								for(var _side = -1; _side <= 1; _side += 2){
									var	_off = 20,
										_num = 2,
										l = 28,
										d = (180 * (_side < 0)) - _off;
										
									repeat(_num){
										var _obj = choose(
											Gator, Gator, GatorSmoke, GatorSmoke,
											"BabyGator", "BabyGator", "BabyGator",
											BuffGator, BuffGator,
											"BoneGator",
											"AlbinoGator"
										);
										
										with(obj_create(x + orandom(2) + lengthdir_x(l, d), y - random(4) + lengthdir_y(l, d), _obj)){
											x = xstart;
											y = ystart;
											image_index = irandom(image_number - 1);
											
											 // Aim:
											scrAim(d + 180);
											if(chance(2, 3)){
												gunangle = 90 + (random_range(30, 50) * right);
											}
											
											 // Specifics:
											switch(_obj){
												case GatorSmoke:
													image_speed = 0;
													break;
													
												case "BabyGator":
													if(chance(1, 2)){
														with(instance_copy(false)){
															var o = orandom(30);
															x += lengthdir_x(16, d + o);
															y += lengthdir_y(16, d + o);
															right *= choose(-1, 1);
															gunangle = 90 + (angle_difference(90, gunangle) * right) + orandom(20);
															array_push(_inst, id);
														}
													}
													break;
											}
											
											array_push(_inst, id);
										}
										
										d += (_off * 2) / (_num - 1);
									}
								}
							}
							
							 // Corner Prop:
							var	_x = choose(_cx - (_w / 2) + 16, _cx + (_w / 2) - 16),
								_y = choose(_cy - (_h / 2) + 16, _cy + (_h / 2) - 16),
								_obj = MoneyPile;
								
							if(abs(angle_difference(_dir + 180, point_direction(_cx, _cy, _x, _y))) < 90){
								_obj = Table;
							}
							
							with(instance_create(_x, _y, _obj)){
								switch(_obj){
									case Table:
										spr_idle = sprFallenChair;
										spr_hurt = sprFallenChairHurt;
										spr_dead = sprFallenChairDead;
										break;
								}
							}
							
							 // Loot:
							for(var _side = -1; _side <= 1; _side++){
								var	_ox = ((_side == 0) ? -24 : -32),
									_oy = -32,
									_x = _cx + lengthdir_x((_w / 2) + _ox, _dir) + (lengthdir_x((_w / 2) + _oy, _dir - 90) * _side) + orandom(2),
									_y = _cy + lengthdir_y((_h / 2) + _ox, _dir) + (lengthdir_y((_h / 2) + _oy, _dir - 90) * _side) + orandom(2),
									_obj = choose(choose(WeaponChest, AmmoChest), AmmoChestMystery, MoneyPile);
									
								if(_side == 0){
									_obj = choose("BatChest", "CatChest");
								}
								
								with(obj_create(_x, _y, _obj)){
									x = xstart;
									y = ystart;
								}
								
								 // Light:
								with(obj_create(_x, _y - 24, "CatLight")){
									w1 = 12;
									w2 = random_range(18, 22);
									h1 = 28
									h2 = 6;
								}
							}
							
							_end = true;
							break;
						}
					}
					
					if(_end) break;
				}
			}
			
			if(_end) break;
		}
	}
	
	inst = _inst;
	
#define GatorDen_step
	if(array_length(inst) > 0){
		with(inst){
			 // Deactivate:
			if(instance_exists(self) && !in_sight(Player) && sprite_index != spr_hurt){
				alarm1 = -1;
				if(instance_is(self, GatorSmoke)) timer = 0;
			}
			
			 // Reactivate:
			else{
				with(other){
					var _alert = false;
					
					with(inst){
						 // Stop Smoking:
						if(instance_is(self, GatorSmoke)){
							var	_x = x,
								_y = y;
								
							with(instance_create(x, y, Shell)) sprite_index = sprCigarette;
							instance_change(Gator, true);
							x = _x;
							y = _y;
						}
						
						 // Reactivate:
						if(instance_is(self, enemy)){
							if(alarm1 < 0) alarm1 = 25 + random(10);
							
							 // Alerted:
							if(enemy_target(x, y) && in_sight(target) && my_health > 0){
								_alert = true;
								
								var _ready = (sign(right) == sign(dcos(gunangle)));
								scrAim(point_direction(x, y, target.x, target.y) + orandom(20));
								
								 // Move:
								if(_ready){
									alarm1 /= 2;
									scrWalk(gunangle + 180 + orandom(30), random(15));
								}
								
								 // Reload:
								else{
									wkick = -4;
									instance_create(x + lengthdir_x(4, gunangle), y + lengthdir_y(4, gunangle), WepSwap);
									if(variable_instance_get(self, "spr_weap") != spr.AlbinoGatorWeap){
										with(scrFX(x, y, [gunangle + (90 * right), 2 + random(2)], Shell)){
											sprite_index = sprShotShell;
										}
									}
								}
							}
						}
					}
					
					 // Alert:
					if(_alert){
						with(scrAlert(noone, spr.GatorAlert)){
							y -= 16;
							vspeed = -2;
							snd_flash = sndBuffGatorHit;
						}
					}
					
					 // ?
					else with(inst) if(instance_is(self, enemy) && my_health > 0){
						with(scrAlert(self, -1)){
							spr_alert = spr.AlertIndicatorMystery;
							alert_col = c_yellow;
							target_y -= 2;
							alarm1 = 30;
							blink = 15;
						}
					}
					
					inst = [];
				}
				break;
			}
		}
	}
	
	
#define RavenArena_text    return "ENTER THE RING";
#define RavenArena_area    return area_scrapyards;
#define RavenArena_chance  return ((GameCont.subarea != 3) ? 1/30 : 0);

#define RavenArena_create
	var	_w = 6 + ceil(GameCont.loops / 2.5),
		_h = _w,
		_type = floor_fill_round,
		_dirOff = 60,
		_spawnX = x,
		_spawnY = y,
		_spawnDis = 32,
		_spawnFloor = FloorNormal,
		_instTop = [],
		_instIdle = [];
		
	floor_set_align(32, 32, null, null);
	
	with(floor_room(_w, _h, _type, _dirOff, _spawnX, _spawnY, _spawnDis, _spawnFloor)){
		other.x = x;
		other.y = y;
		
		 // Decals:
		repeat(3){
			obj_create(x, y, "TopDecal");
		}
		
		 // Round Off Corners:
		for(var _x = x1; _x < x2; _x += 16){
			for(var _y = y1; _y < y2; _y += 16){
				var	_cx = _x + 8,
					_cy = _y + 8;
					
				if(!in_range(_cx, x1 + 64, x2 - 64) && !in_range(_cy, y1 + 64, y2 - 64)){
					var	_sideX = ((_x <= x1 || _x >= x2 - 16) ? sign(_cx - x) : 0),
						_sideY = ((_y <= y1 || _y >= y2 - 16) ? sign(_cy - y) : 0);
						
					if(_sideX != 0 || _sideY != 0){
						if(position_meeting(_cx + (16 * _sideX), _cy + (16 * _sideY), Wall)){
							var	_cornerX = ((_cx < x) ? x1 : x2 - 32),
								_cornerY = ((_cy < y) ? y1 : y2 - 32);
								
							if(!collision_rectangle(_cornerX, _cornerY, _cornerX + 31, _cornerY + 31, Floor, false, false)){
								instance_create(_x, _y, Wall);
							}
						}
					}
				}
			}
		}
		
		 // Front Row Seating:
		with(Wall) if(place_meeting(x, y, Floor) && !collision_line(bbox_center_x, bbox_center_y, other.x, other.y, Wall, false, true)){
			if(chance(1, 4)){
				with(top_create(bbox_center_x + orandom(2), y - 8 + orandom(2), "TopRaven", 0, 0)){
					array_push(_instTop, id);
				}
			}
		}
		
		 // Back Row Seating:
		var	_ang = random(360),
			_num = 3 + ceil(GameCont.loops / 4);
			
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
			with(top_create(x, y, ((GameCont.loops > 0 && chance(1, 2)) ? MeleeFake : Tires), _dir + orandom(40), 16)){
				with(target){
					 // Perched Raven:
					with(top_create(x, y + 1, "TopRaven", 0, 0)){
						z += max(0, ((sprite_get_bbox_bottom(other.spr_idle) + 1) - sprite_get_bbox_top(other.spr_idle)) - 5);
						array_push(_instTop, id);
					}
					
					 // Ravens:
					var	_num = 3 + ceil(GameCont.loops / 2),
						l = 24;
						
					for(var d = _dir; d < _dir + 360; d += (360 / _num)){
						with(top_create(x + lengthdir_x(l, d), y + lengthdir_x(l, d), "TopRaven", d + orandom(40), -1)){
							array_push(_instTop, id);
						}
					}
				}
			}
		}
		
		 // Generic Enemies:
		var	_obj = [choose(Raven, Salamander, Exploder), choose(Sniper, MeleeFake)],
			_ang = random(360),
			_num = 4 * (1 + GameCont.loops);
			
		if(GameCont.loops > 0){
			array_push(_obj, choose("Pelican", BuffGator));
		}
		
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
			var _objNum = array_length(_instIdle);
			if(_objNum >= array_length(_obj)){
				_objNum = irandom(array_length(_obj) - 1);
			}
			with(obj_create(x, y, _obj[_objNum])){
				move_contact_solid(_dir + orandom(20), random_range(16, 64));
				array_push(_instIdle, id);
				
				 // Loop Groups:
				if(chance(GameCont.loops, 60)){
					repeat(3 + GameCont.loops){
						array_push(_instIdle, instance_copy(false));
					}
				}
			}
		}
		
		 // Weapon:
		with(obj_create(x + orandom(8), y + orandom(8), "WepPickupGrounded")){
			with(target){
				var _noWep = [];
				with(Player){
					array_push(_noWep, wep);
					array_push(_noWep, bwep);
				}
				wep = weapon_decide(2, GameCont.hard, false, _noWep);
			}
		}
	}
	
	floor_reset_align();
	
	inst_top = _instTop;
	inst_idle = _instIdle;
	with(inst_top) jump_time = -1;
	
#define RavenArena_step
	 // Hold Enemies:
	with(inst_idle){
		if(instance_exists(self) && sprite_index != spr_hurt){
			if("walk" in self){
				if(walk > 0) walk -= 4 * current_time_scale;
			}
			else{
				direction = angle_lerp(direction, point_direction(x, y, other.x, other.y), 0.04 * current_time_scale);
			}
		}
		else other.inst_idle = array_delete_value(other.inst_idle, self);
	}
	
	 // Activate Ravens:
	if(in_distance(Player, 96)){
		var _time = 60;
		with(instances_matching_lt(inst_top, "jump_time", 0)){
			jump_time = _time * (128 / point_distance(x, y, other.x, other.y));
			_time += random_range(15 + (2400 / _time), 60);
		}
		instance_destroy();
	}
	
	
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
#define option_get(_name, _default)                                                     return  mod_script_call_nc('mod', 'telib', 'option_get', _name, _default);
#define option_set(_name, _value)                                                               mod_script_call_nc('mod', 'telib', 'option_set', _name, _value);
#define stat_get(_name)                                                                 return  mod_script_call_nc('mod', 'telib', 'stat_get', _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc('mod', 'telib', 'stat_set', _name, _value);
#define unlock_get(_name)                                                               return  mod_script_call_nc('mod', 'telib', 'unlock_get', _name);
#define unlock_set(_name, _value)                                                               mod_script_call_nc('mod', 'telib', 'unlock_set', _name, _value);
#define unlock_call(_name)                                                              return  mod_script_call_nc('mod', 'telib', 'unlock_call', _name);
#define unlock_splat(_name, _text, _sprite, _sound)                                     return  mod_script_call_nc('mod', 'telib', 'unlock_splat', _name, _text, _sprite, _sound);
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
#define floor_fill(_x, _y, _w, _h)                                                      return  mod_script_call_nc('mod', 'telib', 'floor_fill', _x, _y, _w, _h);
#define floor_fill_round(_x, _y, _w, _h)                                                return  mod_script_call_nc('mod', 'telib', 'floor_fill_round', _x, _y, _w, _h);
#define floor_fill_ring(_x, _y, _w, _h)                                                 return  mod_script_call_nc('mod', 'telib', 'floor_fill_ring', _x, _y, _w, _h);
#define floor_make(_x, _y, _obj)                                                        return  mod_script_call_nc('mod', 'telib', 'floor_make', _x, _y, _obj);
#define floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)                      return  mod_script_call_nc('mod', 'telib', 'floor_room_start', _spawnX, _spawnY, _spawnDis, _spawnFloor);
#define floor_room_create(_x, _y, _w, _h, _scrt, _dirStart, _dirOff, _floorDis)         return  mod_script_call_nc('mod', 'telib', 'floor_room_create', _x, _y, _w, _h, (is_real(_scrt) ? script_ref_create(_scrt) : _scrt), _dirStart, _dirOff, _floorDis);
#define floor_room(_w, _h, _scrt, _dirOff, _spawnX, _spawnY, _spawnDis, _spawnFloor)    return  mod_script_call_nc('mod', 'telib', 'floor_room', _w, _h, (is_real(_scrt) ? script_ref_create(_scrt) : _scrt), _dirOff, _spawnX, _spawnY, _spawnDis, _spawnFloor);
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
#define teevent_set_active(_name, _active)                                              return  mod_script_call_nc('mod', 'telib', 'teevent_set_active', _name, _active);
#define teevent_get_active(_name)                                                       return  mod_script_call_nc('mod', 'telib', 'teevent_get_active', _name);
#define scrPickupIndicator(_text)                                                       return  mod_script_call(   'mod', 'telib', 'scrPickupIndicator', _text);
#define scrAlert(_inst, _sprite)                                                        return  mod_script_call(   'mod', 'telib', 'scrAlert', _inst, _sprite);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   'mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_instance, _charm)                                               return  mod_script_call_nc('mod', 'telib', 'charm_instance', _instance, _charm);
#define door_create(_x, _y, _dir)                                                       return  mod_script_call_nc('mod', 'telib', 'door_create', _x, _y, _dir);
#define teevent_add(_event)                                                             return  mod_script_call_nc('mod', 'telib', 'teevent_add', _event);