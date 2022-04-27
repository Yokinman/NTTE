#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Store Script References:
	with([ntte_setup, mapdata_get, footprint_give]){
		lq_set(scr, script_get_name(self), script_ref_create(self));
	}
	
	 // Bind Events:
	script_bind(CustomStep,    ntte_step,        0,                            true);
	script_bind(CustomEndStep, ntte_end_step,    0,                            true);
	script_bind(CustomDraw,    draw_top_shadows, object_get_depth(SubTopCont), true);
	global.map_bind = ds_map_create();
	global.map_bind[? "pause"] = noone;
	global.map_bind[? "load" ] = script_bind(CustomDraw, script_ref_create(ntte_map,  -70, 7, null), object_get_depth(GenCont) - 1, false);
	global.map_bind[? "dead" ] = script_bind(CustomDraw, script_ref_create(ntte_map, -120, 4, 0),    object_get_depth(TopCont) - 1, false);
	global.hud_bind            = script_bind(CustomDraw, script_ref_create(ntte_hud, false, 0),      object_get_depth(TopCont) - 1, true);
	if("bind_setup_depth_list" not in ntte){
		ntte.bind_setup_depth_list = [];
		with([
			[-3, -5, VenuzTV],                    // Appear Above Explosions
			[-2, -3, Breath],                     // Appear Above Players
			[ 1,  7, [MeltSplat, Scorchmark]],    // Appear Below Shadows
			[ 7,  8, [VenuzCarpet, FloorMiddle]], // Appear Below Scorch Bottoms
			[ 8,  9, TrapScorchMark]              // Appear Below FloorExplo
		]){
			var	_ref = script_ref_create(ntte_setup_depth, self[0], self[1]),
				_obj = self[2];
				
			array_push(ntte.bind_setup_depth_list, call(scr.ntte_bind_setup, _ref, _obj));
			script_ref_call(_ref, _obj);
		}
	}
	if("bind_setup_shadow_list" not in ntte){
		ntte.bind_setup_shadow_list = [];
		with([
			[shd24, 0,  0, shd24,           1,  0, TV],
			[-1,    0,  0, shd24,           0,  0, SuperFrog],
			[shd24, 0,  0, shd16,           0,  2, Cocoon],
			[shd24, 0,  0, shd24,           0, -3, Pillar],
			[-1,    0,  0, spr.shd.Nothing, 0,  0, Nothing],
			[shd24, 0,  0, sprDeskEmpty,    0,  4, [LastIntro, LastCutscene]],
			[shd24, 0,  0, spr.shd.VenuzTV, 0,  0, VenuzTV],
			[shd24, 0,  0, sprVenuzCouch,   0,  4, VenuzCouch],
			[shd24, 0, -1, shd32,           0,  8, [GiantWeaponChest, GiantAmmoChest]]
		]){
			var	_ref = script_ref_create(ntte_setup_shadow, self[0], self[1], self[2], self[3], self[4], self[5]),
				_obj = self[6];
				
			array_push(ntte.bind_setup_shadow_list, call(scr.ntte_bind_setup, _ref, _obj));
			script_ref_call(_ref, _obj);
		}
	}
	
	 // Scythe Tippage:
	global.scythe_tip = [
		"press @1(sprKeySmall:pick) to change modes",
		"the @rscythe @scan do so much more",
		"press @1(sprKeySmall:pick) to rearrange a few @rbones",
		"just press @1(sprKeySmall:pick) already",
		"please press @1(sprKeySmall:pick)",
		"@q@1(sprKeySmall:pick)"
	];
	
	 // Max Pets (Legacy variable, now stored in GameCont):
	global.pet_max      = variable_instance_get(GameCont, "ntte_pet_max", 1);
	global.pet_max_last = global.pet_max;
	
	 // Wait Until Mod Fully Loaded:
	ntte_active = false;
	if(fork()){
		while(mod_exists("mod", "teloader")){
			wait 0;
		}
		ntte_active = true;
		exit;
	}
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro ntte_active global.active

#define game_start
	 // 'ntte_setup' ID Setup:
	if("ntte_setup_id" not in GameCont){
		GameCont.ntte_setup_id = GameCont.id;
	}
	
	 // Max Pets:
	if("ntte_pet_max" not in GameCont){
		GameCont.ntte_pet_max = 1;
	}
	global.pet_max      = GameCont.ntte_pet_max;
	global.pet_max_last = global.pet_max;
	
	 // Race Runs Stat:
	for(var i = 0; i < maxp; i++){
		var _race = player_get_race(i);
		if(array_find_index(ntte.mods.race, _race) >= 0){
			var _stat = "race:" + _race + ":runs";
			call(scr.stat_set, _stat, call(scr.stat_get, _stat) + 1);
		}
	}
	
	 // NT:TE Weapon Stuff:
	call(scr.loadout_wep_reset);
	with(Player){
		var	_wepName = call(scr.save_get,   `loadout:wep:${race}`, ""),
			_wep     = call(scr.unlock_get, `loadout:wep:${race}:${_wepName}`);
			
		 // Set Manually Stored Weapon:
		if(_wep != wep_none){
			 // Store LWO Variables:
			call(scr.loadout_wep_save, race, _wepName);
			
			 // Take Ammo:
			var _type = weapon_get_type(wep);
			if(_type != type_melee){
				ammo[_type] = max(0, ammo[_type] - (typ_ammo[_type] * 3));
			}
			
			 // Set Wep:
			wep = _wep;
			
			 // Give Ammo:
			var _type = weapon_get_type(wep);
			if(_type != type_melee){
				if(call(scr.wep_raw, wep) == "merge"){
					ammo[_type] += round(clamp(
						weapon_get_cost(wep) * 2,
						typ_ammo[_type] * 1.25,
						typ_ammo[_type] * 3
					));
				}
				else{
					ammo[_type] += round(typ_ammo[_type] * 3);
				}
			}
		}
		
		 // Weapon Skins:
		wep  = call(scr.wep_skin, wep,  race, bskin);
		bwep = call(scr.wep_skin, bwep, race, bskin);
	}
	with(instance_create(0, 0, ProtoChest)){
		if(is_object(wep) && call(scr.wep_raw, wep) == wep_frog_pistol && "tewrapper" in wep){
			//wep.tewrapper.wep = wep_golden_frog_pistol;
			wep = wep_golden_frog_pistol;
			with(ProtoChest){
				wep = other.wep;
			}
			sprite_index = sprProtoChest;
			event_perform(ev_other, ev_room_end);
		}
		instance_delete(self);
	}
	
	 // Determine Crystal Heart Area:
	if("ntte_heart_spawn" not in GameCont){
		var _num = call(scr.save_get, "heart:spawn", 0);
		if(_num > 0){
			call(scr.save_set, "heart:spawn", _num - 1);
			
			/*
				- Excludes desert
				- Excludes boss levels
			*/
			
			var _area = irandom_range(2, 7);
			
			GameCont.ntte_heart_spawn = {
				"area"    : _area,
				"subarea" : irandom_range(1, max(1, call(scr.area_get_subarea, _area) - 1)),
				"loops"   : 0
			};
		}
	}
	
	 // Secret Area Entry Weapons:
	var	_mods      = mod_get_names("weapon"),
		_poolExplo = [],
		_poolScrew = [];
		
	for(var i = 0; i < 128 + array_length(_mods); i++){
		var	_wep  = ((i < 128) ? i : _mods[i - 128]),
			_name = string_upper(weapon_get_name(_wep));
			
		if(weapon_get_type(_wep) == type_explosive){
			if(
				_wep == wep_hyper_launcher       ||
				_wep == wep_toxic_launcher       ||
				_wep == wep_sticky_launcher      ||
				_wep == wep_cluster_launcher     ||
				_wep == "claymore"               ||
				_wep == "blaster"                ||
				_wep == "puncher"                ||
				_wep == "buster"                 ||
				_wep == "pulser"                 ||
				_wep == "airstrike"              ||
				_wep == "herald"                 ||
				string_pos("GRENADE", _name) > 0 ||
				string_pos("BAZOOKA", _name) > 0 ||
				string_pos("NUKE",    _name) > 0 ||
				string_pos("BUBBLE",  _name) > 0 ||
				string_pos("ABRIS",   _name) > 0 ||
				string_pos("ROCKLET", _name) > 0
			){
				array_push(_poolExplo, _wep);
			}
		}
		if(string_pos("SCREWDRIVER", _name) > 0){
			array_push(_poolScrew, _wep);
		}
	}
	
	if("ntte_weapon_spawn" not in GameCont){
		GameCont.ntte_weapon_spawn = [];
	}
	
	array_push(GameCont.ntte_weapon_spawn, { "wep": _poolExplo, "area": area_sewers,     "subarea": 1, "open": 0 });
	array_push(GameCont.ntte_weapon_spawn, { "wep": _poolScrew, "area": area_scrapyards, "subarea": 1, "open": 1 });
	
	 // Track Biggest Weapon Chest Spawn:
	global.biggest_weapon_chest = false;
	
#define level_start // game_start but every level
	var	_spawnX     = 10016,
		_spawnY     = 10016,
		_normalArea = (GameCont.hard > 1 && instance_number(enemy) > instance_number(EnemyHorror));
		
	 // Death Bubble Pop Setup:
	if("ntte_bubble_pop" in GameCont){
		GameCont.ntte_bubble_pop = [];
		with(instances_matching_ne(hitme, "spr_bubble", null, -1)){
			array_push(
				GameCont.ntte_bubble_pop,
				[self, x + spr_bubble_x, y + spr_bubble_y, spr_bubble_pop, true]
			);
		}
	}
	
	 // Activate Pets:
	with(instances_matching_ne(obj.Pet, "id")){
		if(!instance_exists(PopoScene)){
			visible = true;
		}
		if(instance_exists(leader)){
			x = leader.x;
			y = leader.y;
			xprevious = x;
			yprevious = y;
			move_contact_solid(wave, 16);
		}
	}
	
	 // Activate Mutation Orbs:
	with(instances_matching(instances_matching(obj.OrchidBall, "visible", false), "persistent", true)){
		persistent   = false;
		visible      = true;
		speed        = 8;
		direction    = random(360);
		image_xscale = 1.5;
		image_yscale = image_xscale;
		flash        = 3;
		if(instance_exists(target)){
			x = target.x;
			y = target.y;
		}
		else{
			x = _spawnX;
			y = _spawnY;
		}
	}
	
	 // Grounded Guitar/Sword:
	with(instances_matching(instances_matching(WepPickup, "wep", wep_guitar, wep_black_sword), "roll", false)){
		with(call(scr.obj_create, xstart, ystart, "WepPickupGrounded")){
			target = other;
			
			 // Space Out:
			move_contact_solid(random(360), random_range(24, 32));
			call(scr.instance_budge, self, obj.WepPickupGrounded, 32);
			
			 // Quiet Down:
			with(instances_matching(Player, "nearwep", target)){
				nearwep = noone;
			}
		}
	}
	
	 // Crown of Crime:
	if(crown_current == "crime"){
		 // Spawn Bounty Hunters:
		if("ntte_crime_active" in GameCont && GameCont.ntte_crime_active){
			/*with(Crown){
				enemies = 2 * variable_instance_get(GameCont, "ntte_crime_bounty", 0);
			}*/
			
			
			
			with(call(scr.crime_alert, _spawnX, _spawnY, 120, 30)){
				snd_flash = sndSkillPick;
			}
			GameCont.ntte_crime_active = false;
		}
		
		 // Reduce Crime Bounty:
		else if("ntte_crime_bounty" in GameCont && GameCont.ntte_crime_bounty > 0){
			GameCont.ntte_crime_bounty = max(0, GameCont.ntte_crime_bounty - 1);
			
			var _alert = call(scr.crime_alert, _spawnX, _spawnY, 120, 30);
			if(is_array(_alert)){
				with(_alert[1]){
					with(call(scr.instance_clone, self)){
						image_index = min(image_index + 1, image_number - 1);
						depth       = other.depth + 1;
					}
					flash    += 30;
					snd_flash = sndIcicleBreak;
				}
			}
		}
		
		 // No Bounty:
		else call(scr.crime_alert, _spawnX, _spawnY, 90, 10);
	}
	
	 // Subtract Big Bandit Ambush Spawns:
	if(GameCont.area == area_desert){
		with(instances_matching(WantBoss, "ntte_bigbandit_spawn", null)){
			ntte_bigbandit_spawn = variable_instance_get(GameCont, "ntte_bigbandit_spawn", 0);
			if(ntte_bigbandit_spawn != 0){
				number -= ntte_bigbandit_spawn;
				if(number == 0){
					instance_destroy();
				}
			}
		}
	}
	else if(!call(scr.area_get_secret, GameCont.area)){
		GameCont.ntte_bigbandit_spawn = 0;
	}
	
	 // Flavor Big Cactus:
	if(chance(1, 3 * call(scr.area_get_subarea, GameCont.area))){
		with(call(scr.instance_random, [Cactus, NightCactus])){
			call(scr.obj_create, x, y, "BigCactus");
			instance_delete(self);
		}
	}
	
	 // Sewer Manhole:
	with(PizzaEntrance){
		call(scr.obj_create, bbox_center_x, bbox_center_y, "Manhole");
		instance_delete(self);
	}
	
	 // Baby Spiders:
	if(instance_exists(Spider) || instance_exists(InvSpider)){
		with(instances_matching_ne([CrystalProp, InvCrystal], "id")){
			if(place_meeting(x, y, Floor) && !place_meeting(x, y, Wall)){
				repeat(irandom_range(1, 3)){
					call(scr.obj_create, x, y, "Spiderling");
				}
			}
		}
	}
	
	/*
	 // Cool Vault Statues:
	with(ProtoStatue){
		call(scr.floor_set_style, 0, area_vault);
		
		var _img = 0;
		with(call(scr.floor_fill, x, y, 3){
			sprite_index = spr.VaultFlowerFloor;
			image_index	 = _img++;
		}
		
		call(scr.floor_reset_style);
	}
	*/
	
	 // Backpack Setpieces:
	if(GameCont.hard > 4 && GameCont.area != area_hq){
		if(GameCont.area == area_campfire || (chance(1 + (2 * skill_get(mut_last_wish)), 12) && _normalArea)){
			with(call(scr.array_shuffle, FloorNormal)){
				if(
					distance_to_object(Player) > 80
					&& !place_meeting(x, y, hitme)
					&& !place_meeting(x, y, chestprop)
				){
					var	_rebel = 0,
						_rogue = 0;
						
					 // Find Characters:
					with(instances_matching_ne([Player, Revive], "id")){
						 // Rebel:
						if(race_get_name(race) == "rebel"){
							_rebel++;
						}
						
						 // Rogue / Rogue Rifle:
						if(GameCont.area == area_campfire){
							if(
								(race_get_name(race) == "rogue" && GameCont.loops <= 1)
								|| call(scr.wep_raw, wep)  == wep_rogue_rifle
								|| call(scr.wep_raw, bwep) == wep_rogue_rifle
							){
								_rogue++;
							}
						}
					}
					
					 // Backpack:
					var _num = max(1, _rogue) + skill_get(mut_open_mind);
					if(_num > 0){
						repeat(_num){
							call(scr.chest_create, 
								bbox_center_x + orandom(4),
								bbox_center_y - 6 + orandom(min(4, _num - 1)),
								(
									(_rogue > 0)
									? "RogueBackpack"
									: (
										chance(_rebel + variable_instance_get(GameCont, "ntte_backpack_opened", false), 4)
										? "AllyBackpack"
										: "Backpack"
									)
								),
								true
							);
						}
						
						 // Flavor Corpse:
						if(GameCont.area != area_campfire){
							call(scr.obj_create, 
								bbox_center_x + orandom(8),
								bbox_center_y + irandom(8),
								"Backpacker"
							);
						}
						
						 // Clear Walls:
						instance_create(bbox_center_x, bbox_center_y, PortalClear);
					}
					
					break;
				}
			}
		}
	}
	
	 // Beetle Chest:
	for(var _playerIndex = 0; _playerIndex < maxp; _playerIndex++){
		if(player_get_race(_playerIndex) == "beetle"){
			var	_beetleChestX = _spawnX,
				_beetleChestY = _spawnY;
				
			if(_normalArea || GameCont.hard == 1){
				var _w			= 2,
					_h			= 2,
					_type		= "",
					_dirStart	= random(360),
					_dirOff 	= 0,
					_floorDis	= -32,
					_spawnDis	= 64,
					_spawnFloor = [];
					
				 // Compile List of Central Floors:
				with(FloorNormal){
					var _isCentral = true;
					for(var _x = bbox_left - 8; _x <= bbox_right + 1 + 8; _x += 16){
						for(var _y = bbox_top - 8; _y <= bbox_bottom + 1 + 8; _y += 16){
							if(_x < bbox_left || _x > bbox_right + 1 || _y < bbox_top || _y > bbox_bottom + 1){
								if(!position_meeting(_x, _y, Floor)){
									_isCentral = false;
									break;
								}
							}
						}
					}
					if(_isCentral){
						array_push(_spawnFloor, self);
					}
				}
				if(!array_length(_spawnFloor)){
					_spawnFloor = FloorNormal;
				}
				
				 // Prefer Floors by Weapon Chest:
				if(instance_exists(WeaponChest)){
					var _weaponChestSpawnFloor = [];
					with(_spawnFloor){
						var	_cx = bbox_center_x,
							_cy = bbox_center_y;
							
						with(WeaponChest){
							if(!collision_line(x, y, _cx, _cy, Wall, false, false)){
								array_push(_weaponChestSpawnFloor, other);
								break;
							}
						}
					}
					if(array_length(_weaponChestSpawnFloor)){
						_spawnFloor = _weaponChestSpawnFloor;
					}
				}
				
				 // Generate Beetle Chest Room:
				call(scr.floor_set_style, true);
				with(call(scr.floor_room_start, _spawnX, _spawnY, _spawnDis, _spawnFloor)){
					with(call(scr.floor_room_create, x, y, _w, _h, _type, _dirStart, _dirOff, _floorDis)){
						_beetleChestX = x;
						_beetleChestY = y;
						
						//  // Resprite Floors:
						// var _img = 0;
						// with(floors){
						// 	sprite_index = spr.VaultFlowerFloorSmall;
						// 	image_index  = _img++;
						// 	depth        = 8;
						// 	material     = 2;
						// 	traction     = 0.45;
						// 	with(instance_create(x, y + 1, SnowFloor)){
						// 		sprite_index = other.sprite_index;
						// 		image_index  = other.image_index;
						// 		image_speed  = other.image_speed;
						// 	}
						// }
						
						 // Health Chest:
						var _beetleList = instances_matching_gt(instances_matching(Player, "race", "beetle"), "chickendeaths", 0);
						if(array_length(_beetleList)){
							var _floorIndex = irandom(array_length(floors) - 1);
							with(call(scr.array_shuffle, _beetleList)){
								if(instance_number(HealthChest) < array_length(_beetleList)){
									if(chance(1, 2) && !chance(maxhealth, 8)){
										with(other.floors[_floorIndex % array_length(other.floors)]){
											call(scr.chest_create, bbox_center_x, bbox_center_y, HealthChest, true);
										}
										_floorIndex++;
									}
								}
								else break;
							}
						}
					}
				}
				call(scr.floor_reset_style);
			}
			
			 // Refresh Beetle Chest's Ammo Supply:
			if("player_beetle_chest_info" in GameCont){
				with(GameCont.player_beetle_chest_info){
					has_ammo  = true;
					has_blast = true;
				}
			}
			
			 // Beetle Chest:
			call(scr.chest_create, _beetleChestX, _beetleChestY, "BeetleChest", true);
			
			break;
		}
	}
	
	 // Crystal Hearts:
	if(_normalArea){
		var	_heartNum = (chance(GameCont.hard, 400 + (5 * GameCont.hard)) && GameCont.area != area_hq),
			_chaosNum = ((GameCont.subarea == 1) + chance(1, 5)) * (crown_current == "red");
			
		 // Guaranteed Spawn:
		if("ntte_heart_spawn" in GameCont && GameCont.ntte_heart_spawn != undefined){
			if(
				lq_defget(GameCont.ntte_heart_spawn, "area",    GameCont.area)    == GameCont.area    &&
				lq_defget(GameCont.ntte_heart_spawn, "subarea", GameCont.subarea) == GameCont.subarea &&
				lq_defget(GameCont.ntte_heart_spawn, "loops",   GameCont.loops)   == GameCont.loops
			){
				_heartNum = max(_heartNum, 1);
			}
			
			 // Only Need 1:
			if(_heartNum > 0){
				GameCont.ntte_heart_spawn = undefined;
			}
		}
		
		 // Spawn:
		if(_heartNum > 0 || _chaosNum > 0){
			var _spawnFloor = [];
			
			 // Find Spawnable Tiles:
			with(FloorNormal){
				if(distance_to_object(Player) > 128 && !place_meeting(x, y, Wall)){
					if(!instance_exists(Wall) || distance_to_object(Wall) < 34){
						array_push(_spawnFloor, self);
					}
				}
			}
			
			 // Spawn Hearts:
			if(array_length(_spawnFloor)){
				var _chaosForce = (
					GameCont.area == "red" ||
					variable_instance_get(GameCont, "ntte_visits_loop_red", -1) >= GameCont.loops
				);
				while(_heartNum > 0 || _chaosNum > 0){
					with(call(scr.instance_random, _spawnFloor)){
						with(call(scr.obj_create, 
							bbox_center_x,
							bbox_center_y + 2,
							((_chaosNum > 0 || _chaosForce) ? "ChaosHeart" : "CrystalHeart")
						)){
							 // Tesseract:
							if(chance(1, 10) || _chaosNum <= 0){
								if(variable_instance_get(GameCont, "ntte_tesseract_loop", 0) < GameCont.loops){
									variable_instance_set(GameCont, "ntte_tesseract_loop", GameCont.loops);
									tesseract = true;
								}
							}
						}
					}
					if(_chaosNum > 0) _chaosNum--;
					else _heartNum--;
				}
			}
		}
	}
	
	 // Wepmimic Arena:
	if(_normalArea && chance(GameCont.nochest - 4, 4)){
		with(instance_furthest(_spawnX, _spawnY, WeaponChest)){
			with(call(scr.obj_create, x, y, "PetWeaponBecome")){
				curse = max(curse, other.curse);
				
				 // Spawn Room:
				with(call(scr.floor_room_create, x, y, 1, 1, "", random(360), 0, 0)){
					other.x = x;
					other.y = y;
					switch(other.type){
						case type_melee:
							call(scr.floor_fill, x, y, 3);
							break;
							
						case type_bullet:
							call(scr.floor_fill, x, y, 5, 5, "round");
							break;
							
						case type_shell:
							call(scr.floor_fill, x, y, 3, 3, "round");
							break;
							
						case type_bolt:
							call(scr.floor_fill, x, y, 3, 3, "round");
							call(scr.floor_fill, x, y, 5, 5, "ring");
							break;
							
						case type_explosive:
							call(scr.floor_fill, x, y, 5, 1);
							call(scr.floor_fill, x, y, 1, 5);
							break;
							
						case type_energy:
							call(scr.floor_fill, x, y, 5, 5, "ring");
							break;
					}
				}
				
				 // Clear:
				instance_create(x, y, PortalClear);
				with(instances_matching(instances_matching(PortalClear, "xstart", xstart), "ystart", ystart)){
					instance_destroy();
				}
			}
			instance_delete(self);
		}
	}
	
	 // Area-Specific:
	switch(GameCont.area){
		
		case area_campfire: /// CAMPFIRE
			
			 // Unlock Custom Crowns:
			if(array_find_index(ntte.mods.crown, crown_current) >= 0){
				call(scr.unlock_set, `loadout:crown:${crown_current}`, true);
			}
			
			 // Spawn NT:TE Corpses:
			with(ntte.mods.race){
				var _race = self;
				if(!mod_script_exists("race", _race, "race_avail") || mod_script_call("race", _race, "race_avail")){
					var _active = false;
					for(var i = 0; i < maxp; i++){
						if(player_get_race(i) == _race){
							_active = true;
							break;
						}
					}
					if(!_active){
						with(instance_create(_spawnX, _spawnY - 16, Corpse)){
							sprite_index = call(scr.race_get_sprite, _race, 0, sprMutant1Dead);
							image_index  = image_number - 1;
							
							 // Space Out:
							var _tries = 1000;
							while(_tries-- > 0){
								x = xstart;
								y = ystart;
								move_contact_solid(random(360), random_range(32, 64) + random(random(64)));
								x = round(x);
								y = round(y);
								
								 // Safe:
								if(!collision_circle(x, y, 12, Corpse, true, true)){
									break;
								}
							}
						}
					}
				}
			}
			
			 // Less Bones:
			with(BonePileNight) if(chance(1, 3)){
				instance_delete(self);
			}
			
			 // Guarantee Crystal Heart Spawn Next Run:
			if(GameCont.loops > 0){
				var _num = call(scr.save_get, "heart:spawn", 0);
				if(_num <= 0){
					call(scr.save_set, "heart:spawn", _num + 1);
				}
				
				 // Character Loops Stat:
				with(ntte.mods.race){
					for(var i = 0; i < maxp; i++){
						if(player_get_race(i) == self){
							var _stat = "race:" + self + ":loop";
							call(scr.stat_set, _stat, call(scr.stat_get, _stat) + 1);
							break;
						}
					}
				}
			}
			
			break;
			
		case area_desert: /// DESERT
			
			 // Disable Oasis Skip:
			with(instance_create(0, 0, chestprop)){
				visible = false;
				mask_index = mskNone;
			}
			
			 // Find Prop-Spawnable Floors:
			var	_propFloor = [],
				_propIndex = -1;
				
			with(FloorNormal){
				if(point_distance(bbox_center_x, bbox_center_y, _spawnX, _spawnY) > 48){
					if(!place_meeting(x, y, Wall) && !place_meeting(x, y, prop) && !place_meeting(x, y, chestprop) && !place_meeting(x, y, MaggotSpawn)){
						array_push(_propFloor, self);
						_propIndex++;
					}
				}
			}
			_propFloor = call(scr.array_shuffle, _propFloor);
			
			 // Sharky Skull:
			with(BigSkull){
				instance_delete(self);
			}
			if(GameCont.subarea == 3){
				var	_sx = _spawnX,
					_sy = _spawnY;
					
				if(_propIndex >= 0){
					with(_propFloor[_propIndex--]){
						_sx = bbox_center_x;
						_sy = bbox_center_y;
					}
				}
				
				call(scr.obj_create, _sx, _sy, "CoastBossBecome");
			}
			
			 // Consistent Crab Skeletons:
			if(!instance_exists(BonePile) && !instance_exists(call(scr.teevent_get_active, "ScorpionCity"))){
				if(_propIndex >= 0){
					with(_propFloor[_propIndex--]){
						call(scr.obj_create, bbox_center_x, bbox_center_y, BonePile);
					}
				}
			}
			
			 // Scorpion Rocks:
			if(
				chance(2, 5)
				&& GameCont.subarea < call(scr.area_get_subarea, GameCont.area)
				&& !instance_exists(call(scr.teevent_get_active, "ScorpionCity"))
			){
				if(_propIndex >= 0){
					with(_propFloor[_propIndex--]){
						call(scr.obj_create, bbox_center_x, bbox_center_y - 2, "ScorpionRock");
					}
				}
			}
			
			 // Big Maggot Nests:
			if(!instance_exists(call(scr.teevent_get_active, "MaggotPark"))){
				with(MaggotSpawn){
					if(chance(1 + GameCont.loops, 12)){
						call(scr.obj_create, x, y, "BigMaggotSpawn");
						instance_delete(self);
					}
				}
			}
			
			break;
			
		case area_sewers: /// SEWERS
			
			 // Cats:
			with(ToxicBarrel){
				repeat(irandom_range(2, 3)){
					call(scr.obj_create, x, y, "Cat");
				}
			}
			
			 // Frog Nest:
			with(FrogQueen){
				var _minID = instance_max;
				
				 // Bathing:
				with(call(scr.obj_create, x, y, "SludgePool")){
					sprite_index = msk.SewerPoolBig;
					spr_floor    = spr.SewerPoolBig;
					with(self){
						event_perform(ev_step, ev_step_normal);
					}
				}
				
				var _floors = instances_matching_gt(Floor, "id", _minID);
				
				 // Corner Walls:
				with(_floors){
					var	_nw = (!place_meeting(x - 32, y, Floor) && !place_meeting(x, y - 32, Floor)),
						_ne = (!place_meeting(x + 32, y, Floor) && !place_meeting(x, y - 32, Floor)),
						_sw = (!place_meeting(x - 32, y, Floor) && !place_meeting(x, y + 32, Floor)),
						_se = (!place_meeting(x + 32, y, Floor) && !place_meeting(x, y + 32, Floor));
						
					if(_nw || _ne || _sw || _se){
						if(chance(1, 5)){
							with(instance_create(bbox_center_x, bbox_center_y, choose(Pipe, ToxicBarrel))){
								 // pls mom dont step on the props:
								if(fork()){
									var _lastSize = size;
									size = 4;
									while(instance_exists(self) && !point_seen(x, y, -1)){
										wait 0;
									}
									if(instance_exists(self) && size == 4){
										size = _lastSize;
									}
									exit;
								}
							}
						}
						else{
							if(_nw) instance_create(x,      y,      Wall);
							if(_ne) instance_create(x + 16, y,      Wall);
							if(_sw) instance_create(x,      y + 16, Wall);
							if(_se) instance_create(x + 16, y + 16, Wall);
						}
					}
				}
				
				/*
				 // Eggs:
				with(call(scr.array_shuffle, _floors)){
					var _chance = 0;
					
					for(var _checkDir = 0; _checkDir < 360; _checkDir += 90){
						if(!place_meeting(x + lengthdir_x(32, _checkDir), y + lengthdir_y(32, _checkDir), Floor)){
							_chance++;
						}
					}
					
					if(chance(_chance, 1 + _total)){
						_total++;
						
						var	_dis = 8,
							_ang = random(360),
							_num = choose(1, 3);
							
						for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
							var	_x = bbox_center_x + lengthdir_x(_dis, _dir) + orandom(2),
								_y = bbox_center_y + lengthdir_y(_dis, _dir) - random(4);
								
							with(instance_create(_x, _y, FrogEgg)){
								alarm0 *= random_range(1, 2);
								depth = -1;
								
								 // Wait for Boss Intro:
								if(fork()){
									var a = alarm0;
									while(instance_exists(self) && instance_exists(_queen) && _queen.intro == false){
										alarm0 = a;
										wait 0;
									}
									exit;
								}
							}
						}
					}
				}
				*/
				
				break;
			}
			
			 // Loop Spawns:
			if(GameCont.loops > 0){
				 // Traffic Crabs:
				with(Ratking){
					if(chance(1, 3) || array_length(instances_matching(call(scr.instances_meeting_point, x, y, Floor), "styleb", true))){
						call(scr.obj_create, x, y, "TrafficCrab");
						instance_delete(self);
					}
				}
			}
			
			break;
			
		case area_scrapyards: /// SCRAPYARDS
			
			 // Sawblade Traps:
			if(GameCont.subarea != 3){
				with(enemy) if(chance(1, 40) && place_meeting(x, y, Floor)){
					with(call(scr.instance_nearest_bbox, x, y, FloorNormal)){
						call(scr.obj_create, bbox_center_x, bbox_center_y, "SawTrap");
					}
				}
			}
			
			 // Venuz Landing Pad:
			with(CarVenus){
				 // Fix Overlapping Chests:
				if(place_meeting(x, y, chestprop) || place_meeting(x, y, prop)){
					call(scr.floor_set_align, 32, 32);
					with(call(scr.floor_room_create, x, y, 1, 1, "", random(360), 0, 0)){
						other.x = x;
						other.y = y;
					}
					call(scr.floor_reset_align);
				}
				
				 // Fill:
				with(call(scr.instance_nearest_bbox, x, y, instances_matching_lt(FloorNormal, "id", id))){
					call(scr.floor_set_style, styleb, area);
				}
				call(scr.floor_fill, x, y, 3);
				call(scr.floor_reset_style);
			}
			
			 // Sludge Pool:
			if(GameCont.subarea == 2){
				var	_w          = 4,
					_h          = 4,
					_type       = "round",
					_dirOff     = 90,
					_floorDis   = -32,
					_spawnDis   = 96,
					_spawnFloor = FloorNormal;
					
				call(scr.floor_set_align, 32, 32);
				
				with(call(scr.floor_room, _spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
					 // Fill Some Corners:
					repeat(3){
						var	_x = choose(x1, x2 - 32),
							_y = choose(y1, y2 - 32);
							
						if(!array_length(call(scr.instances_meeting_point, _x + 16, _y + 16, FloorNormal))){
							call(scr.floor_set, _x, _y, true);
						}
					}
					
					 // Sludge:
					with(call(scr.obj_create, x, y, "SludgePool")){
						num = 3;
					}
				}
				
				call(scr.floor_reset_align);
			}
			
			 // Raven Spectators:
			with(Wall) if(chance(1, 5)){
				if(!place_meeting(x, y, PortalClear) && place_meeting(x, y, Floor)){
					call(scr.top_create, bbox_center_x + orandom(2), y - 8 + orandom(2), "TopRaven", 0, 0);
				}
			}
			
			 // Loop Spawns:
			if(GameCont.loops > 0){
				 // Pelicans:
				with(Raven) if(chance(4 - GameCont.subarea, 12)){
					call(scr.obj_create, x, y, "Pelican");
					instance_delete(self);
				}
			}
			
			break;
			
		case area_caves:
		case area_cursed_caves: /// CRYSTAL CAVES
			
			 // Miner Bandit:
			with(instance_furthest(_spawnX, _spawnY, Bandit)){
				call(scr.obj_create, x, y, "MinerBandit");
				instance_delete(self);
			}
			
			 // Baby:
			with(Spider){
				if(chance(1, 4)){
					call(scr.obj_create, x, y, "Spiderling");
					instance_delete(self);
				}
			}
			
			 // Spawn Mortars:
			with(crystaltype){
				if(chance(1, 5) && !array_length(instances_matching(call(scr.instances_meeting_point, x, y, Floor), "styleb", true))){
					switch(object_index){
						case LaserCrystal:
							call(scr.obj_create, x, y, "Mortar");
							instance_delete(self);
							break;
							
						case InvLaserCrystal:
							call(scr.obj_create, x, y, "InvMortar");
							instance_delete(self);
							break;
					}
				}
			}
			
			 // Spawn Crystal Bats:
			if(GameCont.loops > 0){
				with(instances_matching_ne([Spider, InvSpider], "id")){
					if(chance(1, 6) && !array_length(instances_matching(call(scr.instances_meeting_point, x, y, Floor), "styleb", true))){
						var	_ang = pround(random(360), 90),
							_dis = 32;
							
						for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 2)){
							with(call(scr.obj_create, x, y, (instance_is(self, InvSpider) ? "InvCrystalBat" : "CrystalBat"))){
								repeat(2){
									if(place_free(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir))){
										x += lengthdir_x(_dis, _dir);
										y += lengthdir_y(_dis, _dir);
									}
									else break;
								}
							}
						}
						
						instance_delete(self);
					}
				}
			}
			
			 // Preloop Lightning Crystals:
			if(GameCont.loops <= 0 && GameCont.subarea <= 1){
				with(LaserCrystal){
					if(chance(1, 40 * ((crown_current == crwn_blood) ? 0.7 : 1))){
						instance_create(x, y, LightningCrystal);
						instance_delete(self);
					}
				}
			}
			
			 // Spawn Prism:
			if(GameCont.area == area_cursed_caves){
				with(instance_furthest(_spawnX, _spawnY, BigCursedChest)){
					call(scr.pet_create, x, y, "Prism");
				}
			}
			
			 // Big Crystal Prop:
			if(chance(1, 2)){
				with(call(scr.array_shuffle, instances_matching_ne([CrystalProp, InvCrystal], "id"))){
					if(place_meeting(x, y, Floor) && point_distance(x, y, _spawnX, _spawnY) >= 96){
						call(scr.obj_create, x, y, "BigCrystalProp");
						instance_delete(self);
						break;
					}
				}
			}
			
			 // Hyper Crystal Pit:
			with(HyperCrystal){
				var	_w          = 5,
					_h          = _w,
					_type       = "",
					_dirOff     = 0,
					_floorDis   = -32,
					_spawnDis   = 256,
					_spawnFloor = FloorNormal;
					
				 // Arena:
				with(call(scr.floor_room, _spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
					with(other){
						x = other.x;
						y = other.y;
						xprevious = x;
						yprevious = y;
						
						 // Delete PortalClears:
						for(var _inst = id + 1; _inst <= id + 15; _inst++){
							if(instance_is(_inst, PortalClear)){
								instance_delete(_inst);
							}
						}
					}
					
					 // Side Column Hallways:
					call(scr.floor_fill, x, y, _w + 4, _h - 2, "ring");
					call(scr.floor_fill, x, y, _w - 2, _h + 4, "ring");
					
					 // Mysterious Pit:
					with(call(scr.obj_create, x, y, "ManholeOpen")){
						sprite_index = ((GameCont.area == area_cursed_caves) ? spr.CaveHoleCursed : spr.CaveHole);
						mask_index   = msk.CaveHole;
						big          = true;
					}
				}
				
				break;
			}
			
			break;
			
		case area_city: /// FROZEN CITY
			
			 // Igloos:
			if(chance(1, GameCont.subarea)){
				var	_minID      = instance_max,
					_w          = 3,
					_h          = 3,
					_type       = "",
					_dirOff     = [30, 90],
					_spawnDis   = 64,
					_spawnFloor = FloorNormal;
					
				call(scr.floor_set_align, 32, 32);
				
				repeat(irandom_range(1, 3)){
					var _floorDis = choose(0, -32);
					with(call(scr.floor_room, _spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
						call(scr.obj_create, x, y, "Igloo");
					}
				}
				
				call(scr.floor_reset_align);
				
				 // Corner Walls:
				with(instances_matching_gt(Floor, "id", _minID)){
					if(!place_meeting(x - 32, y, Floor) && !place_meeting(x, y - 32, Floor) && !place_meeting(x, y, hitme) && !place_meeting(x, y, chestprop)) instance_create(x,      y,      Wall);
					if(!place_meeting(x + 32, y, Floor) && !place_meeting(x, y - 32, Floor) && !place_meeting(x, y, hitme) && !place_meeting(x, y, chestprop)) instance_create(x + 16, y,      Wall);
					if(!place_meeting(x - 32, y, Floor) && !place_meeting(x, y + 32, Floor) && !place_meeting(x, y, hitme) && !place_meeting(x, y, chestprop)) instance_create(x,      y + 16, Wall);
					if(!place_meeting(x + 32, y, Floor) && !place_meeting(x, y + 32, Floor) && !place_meeting(x, y, hitme) && !place_meeting(x, y, chestprop)) instance_create(x + 16, y + 16, Wall);
				}
			}
			
			 // Loop Spawns:
			if(GameCont.loops > 0){
				with(SnowTank) if(chance(1, 4)){
					call(scr.obj_create, x, y, "SawTrap");
				}
				with(Necromancer) if(chance(1, 2)){
					call(scr.obj_create, x, y, "Cat");
					instance_delete(self);
				}
			}
			with(Wolf) if(chance(1, ((GameCont.loops > 0) ? 5 : 200))){
				with(call(scr.obj_create, x, y, "Cat")){
					sit   = other; // It fits
					depth = other.depth - 1;
				}
			}
			
			break;
			
		case area_labs: /// LABS
			
			 // Loop Spawns:
			if(GameCont.loops > 0){
				with(Freak) if(chance(1, 5)){
					instance_create(x, y, BoneFish);
					instance_delete(self);
				}
				with(RhinoFreak) if(chance(1, 3)){
					call(scr.obj_create, x, y, "Bat");
					instance_delete(self);
				}
				with(Ratking) if(chance(1, 5)){
					call(scr.obj_create, x, y, "Bat");
					instance_delete(self);
				}
				with(LaserCrystal) if(chance(1, 4)){
					call(scr.obj_create, x, y, "PortalGuardian");
					instance_delete(self);
				}
			}
			
			 // Freak Chambers:
			with(FloorNormal){
				if(chance(1 + GameCont.loops, 60 + GameCont.loops)){
					if(place_free(x, y) && point_distance(bbox_center_x, bbox_center_y, _spawnX, _spawnY) > 128){
						call(scr.obj_create, bbox_center_x, bbox_center_y, "FreakChamber");
					}
				}
			}
			
			break;
			
		case area_palace: /// PALACE
			
			if(GameCont.subarea == 3){
				
				 // Stairs:
				with(instances_matching(Carpet, "sprite_index", sprCarpet)){
					var	_x1     = x - 128,
						_y1     = bbox_top + 128,
						_x2     = x + 128,
						_y2     = 10016,
						_spr    = spr.FloorPalaceStairs,
						_sprNum = sprite_get_number(_spr),
						_floors = FloorNormal;
						
					for(var _y = _y1; _y < _y2; _y += 368){
						with(call(scr.instance_nearest_array, _x1, _y, _floors)){
							with(instance_create(x, y + 32 - 5, CustomObject)){
								mask_index    = mskFloor;
								image_xscale  = (_x2 - _x1) / 32;
								on_begin_step = PalaceStairs_begin_step;
							}
							
							 // Spriterize:
							for(var i = 0; i < _sprNum; i++){
								with(call(scr.instances_meeting_rectangle, _x1, y + (32 * i), _x2, y + (32 * (i + 1)) - 1, _floors)){
									sprite_index = _spr;
									image_index  = i;
									depth        = 8;
									
									 // Carpet Time:
									if(place_meeting(x, y, Carpet)){
										sprite_index = spr.FloorPalaceStairsCarpet;
										image_index *= 2;
										if(bbox_center_x > (_x1 + _x2) / 2){
											image_index++;
										}
									}
								}
							}
						}
					}
					depth = 9;
				}
				
				/*
				 // Quest Room:
				var _w		  = 4,
					_h		  = 4,
					_type	  = "",
					_dirStart = 90,
					_dirOff   = 0,
					_floorDis = 256,
					_minID	  = instance_max;
					
				call(scr.floor_set_align, 32, 32);
					
				with(call(scr.floor_room_create, _spawnX, _spawnY, _w, _h, _type, _dirStart, _dirOff, _floorDis)){
					
					 // Hallway:
					with(call(scr.instance_random, floors)){
						var	_x       = bbox_center_x,
							_y       = bbox_center_y,
							_moveDis = 32;
							
						while(
							point_distance(_x, _y, other.xstart, other.ystart) > _moveDis / 2
							&& (
								!position_meeting(_x, _y, Floor)
								|| !array_length(call(scr.instances_meeting_point, _x, _y, _spawnFloor))
							)
						){
							 // Floor & Fake Walls:
							if(!position_meeting(_x, _y, Floor) || !array_length(call(scr.instances_meeting_point, _x, _y, FloorNormal))){
								call(scr.floor_set, _x - 16, _y - 16, true);
							}
							
							 // Move:
							var _moveDir = pround(point_direction(_x, _y, other.xstart, other.ystart) + orandom(60), 90);
							_x += lengthdir_x(_moveDis, _moveDir);
							_y += lengthdir_y(_moveDis, _moveDir);
							
							_x = clamp(_x, _spawnX - 96, _spawnX + 64);
						}
					}
					
					 // Floor Sprites:
					with(instances_matching_gt(FloorNormal, "id", _minID)){
						sprite_index = spr.FloorPalaceShrine;
					}
					
					 // Center Floor:
					var _img = 0;
					with(call(scr.floor_fill, x - 16, y - 16, 2, 2)){
						sprite_index = spr.FloorPalaceShrineRoomSmall;
						image_index  = _img++;
					}
					
					 // Chest:
					call(scr.obj_create, x, y, "QuestChest");
				}
				*/
				
				call(scr.floor_reset_align);
			}
			
			 // Cool Dudes:
			with(Guardian) if(chance(1, 20)){
				call(scr.obj_create, x, y, "PortalGuardian");
				instance_delete(self);
			}
			
			 // Loop Spawns:
			if(GameCont.loops > 0){
				with(JungleBandit){
					repeat(chance(1, 5) ? 5 : 1){
						call(scr.obj_create, x, y, "Gull");
					}
					
					 // Move to Wall:
					call(scr.top_create, x, y, self, -1, -1);
				}
				
				 // More Cool Dudes:
				with(ExploGuardian) if(chance(1, 10)){
					call(scr.obj_create, x, y, "PortalGuardian");
					instance_delete(self);
				}
			}
			
			break;
			
		case area_vault: /// CROWN VAULT
			
			 // Vault Flower Room:
			if("ntte_vault_flower" not in GameCont || GameCont.ntte_vault_flower){
				with(CrownPed){
					var	_w        = 3,
						_h        = 3,
						_type     = "",
						_dirStart = random(360),
						_dirOff   = 90,
						_floorDis = 0;
						
					call(scr.floor_set_align, 32, 32);
					
					with(call(scr.floor_room_create, x, y, _w, _h, _type, _dirStart, _dirOff, _floorDis)){
						 // Floor Time:
						var _img = 0;
						with(floors){
							// love u yokin yeah im epic
							sprite_index = spr.VaultFlowerFloor;
							image_index  = _img++;
							depth        = 7;
						}
						
						 // The Star of the Show:
						with(call(scr.obj_create, x, y - 8, "VaultFlower")){
							with(instance_create(x, y, LightBeam)){
								sprite_index = sprLightBeamVault;
							}
						}
					}
					
					call(scr.floor_reset_align);
				}
			}
			
			 // Quest Room:
			with(CrownPed){
				call(scr.floor_set_align, 32, 32);
				
				if(GameCont.proto){
					var _w		  = 2,
						_h		  = 2,
						_type	  = "",
						_dirStart = random(360),
						_dirOff   = 90,
						_floorDis = 0;
						
					with(call(scr.floor_room_create, x, y, _w, _h, _type, _dirStart, _dirOff, _floorDis)){
						call(scr.obj_create, x, y, "QuestChest");
						
						var _img = 0;
						with(floors){
							sprite_index = spr.VaultFlowerFloorSmall;
							image_index  = _img++;
							depth		 = 7;
						}
					}
				}
				else{
					var _w			= 5,
						_h			= 5,
						_type		= "",
						_dirStart	= 90,
						_dirOff 	= 0,
						_floorDis	= 64,
						_spawnDis	= 256,
						_spawnFloor = FloorNormal,
						_minID		= instance_max;
						
					with(call(scr.floor_room_start, _spawnX, _spawnY, _spawnDis, _spawnFloor)){
						with(call(scr.floor_room_create, x, y, _w, _h, _type, _dirStart, _dirOff, _floorDis)){
							
							 // Hallway:
							with(call(scr.instance_random, floors)){
								var	_x       = bbox_center_x,
									_y       = bbox_center_y,
									_moveDis = 32;
									
								while(
									point_distance(_x, _y, other.xstart, other.ystart) > _moveDis / 2
									&& (
										!position_meeting(_x, _y, Floor)
										|| !array_length(call(scr.instances_meeting_point, _x, _y, _spawnFloor))
									)
								){
									 // Floor & Fake Walls:
									if(!position_meeting(_x, _y, Floor) || !array_length(call(scr.instances_meeting_point, _x, _y, FloorNormal))){
										call(scr.floor_set, _x - 16, _y - 16, true);
									}
									
									 // Move:
									var _moveDir = pround(point_direction(_x, _y, other.xstart, other.ystart) + orandom(60), 90);
									_x += lengthdir_x(_moveDis, _moveDir);
									_y += lengthdir_y(_moveDis, _moveDir);
								}
							}
							
							 // Room Shape:
							call(scr.floor_fill, x - 16, y - 16, 9, 3);
							
							 // Floor Pattern:
							var _img = 0;
							with(call(scr.floor_fill, x - 16, y - 112, 3, 3)){
								sprite_index = spr.VaultFlowerFloor;
								image_index  = _img++;
								depth		 = 7;
							}
							
							 // Hint Lore Tiles:
							var _img = 0;
							for(var i = -3; i <= 3; i += 2){
								with(call(scr.floor_set, x - 16 + (32 * i), y - 16, true)){
									sprite_index = spr.QuestFloor;
									image_index  = _img++;
								}
							}
							
							call(scr.obj_create, x, y - 96, "QuestChestBig");
						}
					}
					
				}
				call(scr.floor_reset_align);
			}
			
			break;
			
		case area_mansion: /// MANSIOM  its MANSION idiot, who wrote this
			
			 // Spawn Gold Mimic:
			with(instance_nearest(_spawnX, _spawnY, GoldChest)){
				with(call(scr.pet_create, x, y, "Mimic")){
					wep = call(scr.weapon_decide, 0, 1 + (2 * curse) + GameCont.hard, true);
				}
				instance_delete(self);
			}
			
			break;
			
		case area_jungle: /// JUNGLE where is the hive ?
			
			 // Top Spawns:
			var _topify = [Bush, JungleBandit, JungleFly];
			if(GameCont.loops > 0){
				array_push(_topify, JungleAssassinHide);
			}
			with(instances_matching_ne(_topify, "id")){
				if(chance(1, 4)){
					call(scr.top_create, x, y, self, -1, -1);
				}
			}
			
			break;
			
		case area_hq: /// IDPD HQ
			
			 // Elevators:
			with(WantPopo){
				instance_delete(self);
				with(call(scr.array_shuffle, FloorNormal)){
					if(place_free(x, y) && point_distance(bbox_center_x, bbox_center_y, _spawnX, _spawnY) > 128){
						call(scr.obj_create, x, y, "FreakChamber");
						break;
					}
				}
			}
			with(instances_matching_ne([EliteGrunt, EliteShielder, EliteInspector], "id")){
				if(chance(1, 2)){
					call(scr.obj_create, _x, _y, "FreakChamber");
					instance_delete(self);
					with(VanSpawn){
						enemies--;
					}
					with(instances_matching_ne(obj.FreakChamber, "id")){
						enemies--;
					}
				}
			}
			
			 // Security Guards:
			with(call(scr.instance_random, [Grunt, Shielder, Inspector])){
				call(scr.obj_create, x, y, "PopoSecurity");
				instance_delete(self);
			}
			
			break;
			
	}
	
	 // Activate Events:
	with(call(scr.teevent_get_active, all)){
		x = 0;
		y = 0;
		
		 // Set Events:
		on_step    = script_ref_create_ext(mod_type, mod_name, event + "_step");
		on_cleanup = script_ref_create_ext(mod_type, mod_name, event + "_cleanup");
		
		 // Generate Event:
		var _minID = instance_max;
		mod_script_call(mod_type, mod_name, event + "_create");
		floors = instances_matching_gt(Floor, "id", _minID);
		
		 // Position Controller:
		if(x == 0 && y == 0){
			if(array_length(floors)){
				var	_x1 = +infinity,
					_y1 = +infinity,
					_x2 = -infinity,
					_y2 = -infinity;
					
				with(floors){
					if(_x1 > bbox_left      ) _x1 = bbox_left;
					if(_y1 > bbox_top       ) _y1 = bbox_top;
					if(_x2 < bbox_right  + 1) _x2 = bbox_right  + 1;
					if(_y2 < bbox_bottom + 1) _y2 = bbox_bottom + 1;
				}
				
				x = (_x1 + _x2) / 2;
				y = (_y1 + _y2) / 2;
			}
		}
	}
	
	 // Silver Tongue Crates:
	if(skill_get("silver tongue") > 0 && _normalArea && GameCont.subarea == 1){
		var _roomList = [];
		
		 // Rooms:
		var _spawnFloor = FloorNormal;
		repeat(skill_get("silver tongue")){
			var _w = irandom_range(1, 2),
				_h = _w;
				
			with(call(scr.array_shuffle, _spawnFloor)){
				var	_x = bbox_center_x,
					_y = bbox_center_y;
					
				if(point_distance(_spawnX, _spawnY, _x, _y) > 32){
					var _dirStart = pround(point_direction(_spawnX, _spawnY, _x, _y) + choose(-90, 90), 90);
					array_push(_roomList, call(scr.floor_room_create, _x, _y, _w, _h, "", _dirStart, 0, 0));
					break;
				}
			}
		}
		
		 // Spawn Crate:
		var _minID = instance_max;
		with(_roomList){
			with(call(scr.obj_create, x, y, "WallCrate")){
				crate_loot = call(scr.chest_create, x, y - 4, choose("CatChest", "BatChest", "RatChest"), true);
			}
		}
	}
	
	 // Wall Enemies / Props:
	var	_spiderMain     = true,
		_spiderMainX    = 0,
		_spiderMainY    = 0,
		_spiderMainDis  = 48 + (16 * GameCont.loops),
		_spiderStrayNum = 8 + irandom(4) + (2 * GameCont.loops);
		
	with(call(scr.array_shuffle, instances_matching_ne(Wall, "topspr", -1))){
		if(!place_meeting(x, y, PortalClear) && !place_meeting(x, y, TopPot)){
			switch(topspr){
				
				case sprWall1Top: // BANDITS
					
					if(chance(1, 400)){
						if(!place_meeting(x, y + 16, Bones)){
							call(scr.obj_create, bbox_center_x, bbox_center_y, "WallEnemy");
						}
					}
					
					break;
					
				case sprWall4Top: // SPIDERLINGS
					
					var	_x = bbox_center_x,
						_y = bbox_center_y;
						
					if(point_distance(_x, _y, _spawnX, _spawnY) > 64){
						 // Central Wall:
						if(_spiderMain){
							_spiderMain = false;
							_spiderMainX = _x;
							_spiderMainY = _y;
							
							 // Wall Spider:
							with(call(scr.obj_create, _x, _y, "WallEnemy")){
								special = true;
								with(target){
									sprite_index = spr.WallSpider;
									image_index = irandom(image_number - 1);
								}
							}
							sprite_index = spr.WallSpiderBot;
							image_index = irandom(image_number - 1);
							
							 // TopSmalls:
							with(TopSmall){
								if(chance(1, 3) && point_distance(bbox_center_x, bbox_center_y, _spiderMainX, _spiderMainY) <= _spiderMainDis){
									call(scr.obj_create, bbox_center_x, bbox_center_y, "WallEnemy");
								}
							}
						}
						
						 // Central Mass:
						else if(chance(2, 3) && point_distance(_x, _y, _spiderMainX, _spiderMainY) <= _spiderMainDis){
							call(scr.obj_create, _x, _y, "WallEnemy");
						}
						
						 // Strays:
						else if(_spiderStrayNum > 0){
							_spiderStrayNum--;
							call(scr.obj_create, _x, _y, "WallEnemy");
						}
					}
					
					 // Props:
					if(chance(1, 12)){
						if(distance_to_object(TopPot) > 64 && distance_to_object(Bones) > 96){
							call(scr.top_create, 
								random_range(bbox_left, bbox_right + 1),
								random_range(bbox_top, bbox_bottom + 1),
								choose(CrystalProp, CrystalProp, Cocoon),
								-1,
								-1
							);
						}
					}
					
					break;
					
				case sprWall100Top: // TORCHES
					
					if(chance(1, 40)){
						call(scr.top_create, random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Torch, -1, -1);
					}
					
					break;
					
				case sprWall104Top: // CRYSTALS
					
					if(chance(1, 12)){
						if(distance_to_object(TopPot) > 64 && distance_to_object(Bones) > 96){
							call(scr.top_create, 
								random_range(bbox_left, bbox_right + 1),
								random_range(bbox_top, bbox_bottom + 1),
								choose(InvCrystal, InvCrystal, Cocoon),
								-1,
								-1
							);
						}
					}
					
					break;
					
			}
		}
	}
	
	 // Top Spawns:
	var _topSpecial = chance(1, 5);
	with(call(scr.array_shuffle, instances_matching_ne(TopPot, "object_index", TopPot))){
		switch(object_index){
			
			case TopDecalNightDesert: /// CAMPFIRE
				
				 // Night Cacti:
				if(chance(1, 2)){
					call(scr.top_create, x, y - 8, NightCactus, random(360), -1);
				}
				
				break;
				
			case TopDecalDesert: /// DESERT
				
				 // Special:
				if(_topSpecial){
					_topSpecial = false;
					
					var	_x    = x,
						_y    = y,
						_dis  = 64,
						_dir  = random(360),
						_type = choose("Bandit", "Cactus", "Chest", "Wep");
						
					 // Avoid Floors:
					if(instance_exists(Floor)){
						var	_l = 8,
							_d = _dir;
							
						with(call(scr.instance_nearest_bbox, _x, _y, Floor)){
							_d = point_direction(bbox_center_x, bbox_center_y, _x, _y);
						}
						
						while(collision_circle(_x, _y, _dis, Floor, false, false)){
							_x += lengthdir_x(_l, _d);
							_y += lengthdir_y(_l, _d);
						}
						
						_dir = _d;
					}
					
					 // Create:
					var	_num       = 3,
						_ang       = random(360),
						_decalNum  = _num,
						_cactusNum = irandom_range(1, _num),
						_banditNum = 0,
						_flyNum    = 0;
						
					if(GameCont.loops > 0){
						_flyNum = irandom_range(1, _num);
					}
					
					switch(_type){
						
						case "Bandit":
							
							_banditNum = irandom_range(1, _num);
							_cactusNum = max(_cactusNum, _banditNum - 1);
							call(scr.obj_create, _x, _y - 4, "WallEnemy");
							
							break;
							
						case "Cactus":
							
							_cactusNum = _num;
							call(scr.top_create, _x, _y - 28, BonePile, 0, 0);
							
							 // Hmmm:
							var	_l = 160,
								_d = _dir;
								
							with(call(scr.chest_create, _x + lengthdir_x(_l, _d), _y + lengthdir_y(_l, _d), BigWeaponChest)){
								with(call(scr.top_create, x, y, self, _d, _l)){
									with(call(scr.chest_create, x + lengthdir_x(16, _d), y + lengthdir_y(16, _d), AmmoChest)){
										call(scr.top_create, x, y, self, -1, -1);
									}
									call(scr.top_create, x, y, Cactus, _d + 180 + orandom(90), -1);
								}
								
								 // Skipping Doesn't Count:
								if(instance_is(self, BigWeaponChest)){
									GameCont.nochest -= 2;
								}
							}
							
							break;
							
						case "Chest":
							
							var _obj = AmmoChest;
							if(crown_current == crwn_life && chance(2, 3)){
								_obj = HealthChest;
							}
							else with(Player) if(my_health < maxhealth / 2 && chance(1, 2)){
								_obj = HealthChest;
							}
							with(call(scr.chest_create, _x, _y - 16, _obj)){
								with(call(scr.top_create, x, y, self, 0, 0)){
									spr_shadow_y--;
								}
							}
							
							break;
							
						case "Wep":
							
							_cactusNum = irandom_range(2, _num);
							with(call(scr.obj_create, _x, _y - 16, "WepPickupGrounded")){
								target = instance_create(x, y, WepPickup);
								with(target){
									ammo = true;
									roll = true;
									wep  = call(scr.weapon_decide, min(6, 2 + GameCont.hard), 3 + GameCont.hard);
								}
								call(scr.top_create, x, y, self, 0, 0);
							}
							
							break;
							
					}
					
					for(var _a = _ang; _a < _ang + 360; _a += (360 / _num)){
						var _l = _dis * random_range(0.3, 0.7),
							_d = _a + orandom(15);
							
						 // Rocks:
						if(_decalNum > 0){
							_decalNum--;
							with(call(scr.obj_create, _x + lengthdir_x(_l, _d), _y + lengthdir_y(_l, _d), "TopDecal")){
								x = xstart;
								y = ystart;
								instance_create(pfloor(x - 16, 16), pfloor(y - 16, 16), Top);
							}
						}
						_d += (360 / _num) / 2;
						
						 // Enemy:
						if(_banditNum > 0){
							_banditNum--;
							call(scr.obj_create, _x + lengthdir_x(_l, _d), _y + lengthdir_y(_l, _d), "WallEnemy");
							_l *= random_range(0.5, 0.7);
						}
						else{
							_l = _dis * random_range(0.15, 0.5);
						}
						
						 // Cacti:
						if(_cactusNum > 0){
							_cactusNum--;
							call(scr.top_create, _x + lengthdir_x(_l, _d), _y - 20 + lengthdir_y(_l, _d), Cactus, 0, 0);
						}
						
						 // Flies:
						if(_flyNum > 0){
							_flyNum--;
							var _l = _dis * random_range(0.5, 1);
							call(scr.top_create, _x + lengthdir_x(_l, _d), _y - 16 + lengthdir_y(_l, _d), JungleFly, _d + orandom(30), _l);
						}
					}
					
					instance_delete(self);
				}
				
				 // Cacti:
				else call(scr.top_create, x, y - 8, Cactus, random(360), -1);
				
				break;
				
			case TopDecalScrapyard: /// SCRAPYARD
				
				 // Ravens:
				if(chance(1, 2)){
					if(image_index >= 1){
						call(scr.top_create, x, y - 16, "TopRaven", 0, 0);
					}
					else{
						call(scr.top_create, x, y - 8, "TopRaven", random(360), -1);
					}
				}
				
				break;
				
			case TopDecalPalace: /// PALACE
				
				 // Pillars:
				if(chance(1, 2)){
					with(call(scr.instance_nearest_bbox, x, y, Floor)){
						call(scr.top_create, other.x, other.y - 8, Pillar, point_direction(other.x, other.y, bbox_center_x, bbox_center_y), random_range(16, 64));
					}
				}
				
				break;
				
		}
	}
	
	 // Big Decals:
	if(chance(1, (call(scr.area_get_subarea, GameCont.area) > 1) ? 8 : 4)){
		with(call(scr.instance_random, TopSmall)){
			call(scr.obj_create, random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), "BigDecal");
		}
	}
	
	/*
	 // Top Chests:
	if(_normalArea && (GameCont.area != area_desert || GameCont.loops > 0)){
		var _obj = -1;
		
		 // Health:
		if(chance(1, 2) || crown_current == crwn_life){
			with(Player) if(!chance(my_health, maxhealth)){
				_obj = ((crown_current == crwn_love) ? AmmoChest : HealthChest);
			} 
		}
		
		 // Ammo:
		if(_obj == -1 && chance(1, 2)){
			var	_chance = 0,
				_chanceMax = 0;
				
			with(Player) with([wep, bwep]){
				var _type = weapon_get_type(self);
				if(_type == type_melee){
					_chance    += 200;
					_chanceMax += 200;
				}
				else{
					_chance    += other.ammo[_type];
					_chanceMax += other.typ_amax[_type] * 0.8;
				}
			}
			
			if(!chance(_chance, _chanceMax)){
				_obj = AmmoChest;
			}
		}
		
		 // Rads:
		if(_obj == -1 && chance(1, 15)){
			_obj = ((crown_current == crwn_life && chance(2, 3)) ? HealthChest : RadChest);
		}
		
		 // Create:
		with(call(scr.instance_random, [Wall, TopSmall])){
			with(call(scr.top_create, x + random(16), y + random(16), _obj, -1, -1)){
				with(instances_matching_gt(RadMaggotChest, "id", target)){
					instance_delete(self);
				}
			}
		}
	}
	*/
	
	 // Baby Scorpions:
	if(instance_exists(Scorpion) || instance_exists(GoldScorpion)){
		var _city = instance_exists(call(scr.teevent_get_active, "ScorpionCity"));
		with(Scorpion) if(chance(1 + _city, 4)){
			repeat(irandom_range(1, 3)){
				call(scr.obj_create, x, y, "BabyScorpion");
			}
		}
		with(GoldScorpion) if(chance(_city, 4)){
			repeat(irandom_range(1, 3)){
				call(scr.obj_create, x, y, "BabyScorpionGold");
			}
		}
		with(MaggotSpawn){
			babyscorp_drop = chance(1, 8) + _city;
		}
	}
	
	 // Big Dog Spectators:
	with(BecomeScrapBoss){
		repeat(irandom_range(2, 6) * (1 + GameCont.loops)){
			call(scr.top_create, x, y, "TopRaven", random(360), -1);
		}
	}
	
	 // Crown of Crime:
	if(crown_current == "crime"){
		switch(choose(AmmoChest, WeaponChest, RadChest)){
			
			case AmmoChest:
				
				 // Cat Chests:
				with(instances_matching_ne([AmmoChest, Mimic], "object_index", IDPDChest, GiantAmmoChest)){
					call(scr.chest_create, x, y, "CatChest", true);
					instance_delete(self);
				}
				
				break;
				
			case WeaponChest:
				
				 // Bat Chests:
				with(instances_matching_ne(WeaponChest, "object_index", GiantWeaponChest)){
					with(call(scr.chest_create, x, y, "BatChest", true)){
						if(array_find_index(obj.BatChest, self) >= 0){
							big   = (instance_is(other, BigWeaponChest) || instance_is(other, BigCursedChest));
							curse = other.curse;
						}
					}
					instance_delete(self);
				}
				
				break;
				
			case RadChest:
				
				 // Rat Chests:
				with(instances_matching_ne([RadChest, RogueChest, HealthChest, SuperMimic], "id")){
					call(scr.chest_create, x, y, "RatChest", true);
					instance_delete(self);
				}
				
				break;
				
		}
	}
	
	 // Red Ammo Canisters:
	with(Player){
		if(
			call(scr.weapon_get, "red", wep)  > 0 ||
			call(scr.weapon_get, "red", bwep) > 0
		){
			 // Replace Rad Canisters:
			with(RadChest){
				call(scr.obj_create, x, y, "RedAmmoChest");
				instance_delete(self);
			}
			
			 // Spawn With Rogue Canisters:
			var _spawn = true;
			with(RogueChest){
				if(_spawn){
					_spawn = false;
					call(scr.floor_set_align, 32, 32);
					with(call(scr.floor_room, x, y, 0, FloorNormal, 1, 1, "", 0, 0)){
						call(scr.obj_create, x, y, "RedAmmoChest");
					}
					call(scr.floor_reset_align);
				}
				
				 // Replace:
				else if(chance(1, 2)){
					call(scr.obj_create, x, y, "RedAmmoChest");
					instance_delete(self);
				}
			}
			break;
		}
	}
	
	 // Orchid Chests:
	if(call(scr.save_get, "orchid:seen", false)){
		with(RadChest){
			if(chance(GameCont.rad * (GameCont.level / 10), 600 * 3)){
				call(scr.obj_create, x, y, "OrchidChest");
				instance_delete(self);
			}
		}
	}
	
	 // Bonus Chests:
	with(instances_matching([AmmoPickup, HPPickup, AmmoChest, HealthChest, Mimic, SuperMimic], "bonus_pickup_check", null)){
		bonus_pickup_check = (
			chance(1, 6)
			&& _normalArea
			&& GameCont.hard > 8
		);
		if(bonus_pickup_check){
			var _chest = "";
			if((instance_is(self, AmmoChest) && !instance_is(self, IDPDChest)) || instance_is(self, Mimic)){
				_chest = "Ammo";
			}
			else if(instance_is(self, HealthChest) || instance_is(self, SuperMimic)){
				_chest = "Health";
			}
			if(_chest != ""){
				call(scr.chest_create, x, y, "Bonus" + _chest + (instance_is(self, enemy) ? "Mimic" : "Chest"), true);
				instance_delete(self);
			}
		}
	}
	
	 // Biggest Weapon Chest:
	if(chance(1, 10) && call(scr.weapon_get, "avail", "ultra quasar rifle")){
		if("ntte_huge_weapon_chest" not in GameCont || GameCont.ntte_huge_weapon_chest){
			with(Player){
				if(weapon_get_rads(wep) > 0 || weapon_get_rads(bwep) > 0){
					with(call(scr.instance_random, instances_matching(WeaponChest, "object_index", WeaponChest, BigWeaponChest))){
						call(scr.chest_create, x, y, "BiggestWeaponChest", true);
						GameCont.ntte_huge_weapon_chest = false;
						instance_delete(self);
					}
					break;
				}
			}
		}
	}
	
	 // Flies:
	with(MaggotSpawn){
		var _num = irandom_range(0, 2);
		if(_num > 0) repeat(_num){
			call(scr.obj_create, x + orandom(12), y + orandom(8), "FlySpin");
		}
	}
	with(BonePile) if(chance(1, 2)){
		with(call(scr.obj_create, x, y, "FlySpin")){
			target   = other;
			target_x = orandom(8);
			target_y = -random(8);
		}
	}
	
	 // Baby Sludge Pools:
	with(instances_matching(instances_matching(Floor, "sprite_index", sprFloor3), "image_index", 3)){
		if(!array_length(call(scr.instances_meeting_instance, self, obj.SludgePool))){
			with(call(scr.obj_create, bbox_center_x, bbox_center_y, "SludgePool")){
				sprite_index = msk.SludgePoolSmall;
				spr_floor    = other.sprite_index;
				floors       = [other];
			}
		}
	}
	
	 // Trap Collision Fix:
	with(Trap){
		solid = false;
	}
	
	 // Top Decal Fix:
	with(TopPot){
		while(place_meeting(x, y, Wall)){
			var _break = true;
			with(call(scr.instances_meeting_instance, self, Wall)){
				if(place_meeting(x, y, PortalClear) && place_meeting(x, y, other)){
					with(other){
						_break = false;
						while(place_meeting(x, y, Floor) || place_meeting(x, y, other)){
							x += lengthdir_x(16, dir);
							y += lengthdir_y(16, dir);
						}
					}
				}
			}
			if(_break) break;
		}
	}
	
	 // Wall Depth Fix:
	with(instances_matching(Wall, "depth", 0)){
		var _depth = depth;
		depth++;
		if(fork()){
			wait 0;
			if(instance_exists(self) && depth == _depth + 1){
				depth = _depth;
			}
			exit;
		}
	}
	
#define step
	ntte_begin_step();
	
#define ntte_call(_call)
	/*
		Calls the given type of script in all NTTE mods
		
		Args:
			call - A string or array, referencing the script to call
			
		Ex:
			ntte_call("step")               == Calls all 'ntte_step' scripts
			ntte_call(["draw_dark", "end"]) == Calls all 'ntte_draw_dark' scripts with an argument0 of "end"
	*/
	
	_call = (
		is_array(_call)
		? array_clone(_call)
		: [_call]
	);
	
	var	_list   = lq_get(ntte.mods_call, _call[0]),
		_max    = array_length(_list),
		_ref    = call(scr.array_combine, ["", ""], _call),
		_canLag = !(lag || instance_exists(PauseButton) || instance_exists(BackMainMenu));
		
	_ref[2] = "ntte_" + _ref[2];
	
	for(var i = 0; i < _max; i++){
		_ref[0] = _list[i, 0];
		_ref[1] = _list[i, 1];
		var _lag = (_canLag && mod_variable_get(_ref[0], _ref[1], "debug_lag"));
		if(_lag) trace_time();
		script_ref_call(_ref);
		if(_lag) trace_time(array_join(_ref, "_"));
	}
	
#define ntte_setup
	/*
		Calls object setup scripts with arrays of their newly created instances
		The arrays can be empty, as other setup scripts may destroy the instances
	*/
	
	var _objectRefList = mod_variable_get("mod", "teassets", "bind_setup_object_list");
	
	while(true){
		var	_maxID    = instance_max,
			_minID    = (("ntte_setup_id" in GameCont) ? (GameCont.ntte_setup_id + 1) : _maxID),
			_instList = [],
			_refList  = [];
			
		 // Compile New Instances:
		while(_minID < _maxID){
			if("object_index" in _minID){
				with(_objectRefList[_minID.object_index]){
					var _pos = array_find_index(_refList, self);
					if(_pos < 0){
						_pos = array_length(_refList);
						array_push(_instList, [_minID]);
						array_push(_refList,  self);
					}
					else{
						array_push(_instList[_pos], _minID);
					}
				}
			}
			_minID++;
		}
		GameCont.ntte_setup_id = _maxID;
		
		 // Call Setup Scripts:
		if(array_length(_instList)){
			var _pos = 0;
			with(_refList){
				//trace(self);
				script_ref_call(self, instances_matching_ne(_instList[_pos++], "id"));
			}
		}
		else break;
	}
	
#define ntte_setup_GenCont(_inst)
	/*
		Loading screen general setup
	*/
	
	 // Unlock NT:TE Golden Weapons:
	with(Player){
		for(var i = 0; i < 2; i++){
			var _wep = ((i == 0) ? wep : bwep);
			if(weapon_get_gold(_wep) != 0){
				if(array_find_index(ntte.mods.weapon, call(scr.wep_raw, _wep)) >= 0){
					var	_path = `loadout:wep:${race}`,
						_name = "main";
						
					if(call(scr.unlock_set, _path + ":" + _name, _wep)){
						call(scr.save_set, _path, _name);
						break;
					}
				}
			}
		}
	}
	
	 // NT:TE Tips:
	var _lastSeed = random_get_seed();
	with(_inst){
		tip_ntte = "";
		
		 // Scythe:
		if(GameCont.hard > 1){
			if("ntte_scythe_tip_index" not in GameCont){
				GameCont.ntte_scythe_tip_index = 0;
			}
			if(GameCont.ntte_scythe_tip_index >= 0){
				var _scythe = false;
				with(Player){
					if(call(scr.wep_raw, wep) == "scythe" || call(scr.wep_raw, bwep) == "scythe"){
						_scythe = true;
						break;
					}
				}
				if(_scythe){
					tip_ntte = global.scythe_tip[GameCont.ntte_scythe_tip_index];
					GameCont.ntte_scythe_tip_index = min(
						GameCont.ntte_scythe_tip_index + 1,
						array_length(global.scythe_tip) - 1
					);
				}
			}
		}
		
		 // Pets:
		if(tip_ntte == "" && chance(1, 14)){
			var	_player = call(scr.array_shuffle, instances_matching_ne(Player, "ntte_pet", null)),
				_tip    = "";
				
			with(_player){
				with(instances_matching_ne(call(scr.array_shuffle, ntte_pet), "id")){
					_tip = call(scr.pet_get_ttip, pet, mod_type, mod_name, bskin);
					if(_tip != ""){
						break;
					}
				}
				if(_tip != ""){
					break;
				}
			}
			
			tip_ntte = _tip;
		}
		
		 // Set Tip:
		if(tip_ntte != ""){
			tip = tip_ntte;
		}
	}
	random_set_seed(_lastSeed);
	
	 // Setup Events:
	var _list = mod_variable_get("mod", "teevents", "event_list");
	for(var i = 0; i < array_length(_list); i++){
		var	_scrt    = _list[i],
			_modType = _scrt[0],
			_modName = _scrt[1],
			_name    = _scrt[2],
			_area    = mod_script_call(_modType, _modName, _name + "_area");
			
		if(_area == undefined || GameCont.area == _area){
			var _hard = mod_script_call(_modType, _modName, _name + "_hard");
			if(GameCont.hard >= ((_hard == undefined) ? 2 : _hard)){
				var _chance = 1;
				if(mod_script_exists(_modType, _modName, _name + "_chance")){
					_chance = mod_script_call(_modType, _modName, _name + "_chance");
				}
				if(chance(_chance, 1)){
					call(scr.teevent_set_active, _name, true);
				}
			}
		}
	}
	
#define ntte_setup_SpiralCont(_inst)
	/*
		Loading screen background setup
	*/
	
	with(_inst){
		var	_lastTimeScale = current_time_scale,
			_lastSeed      = random_get_seed();
			
		current_time_scale = 1;
		
		 // Bubbles:
		if(call(scr.area_get_underwater, ((GameCont.area == area_vault) ? GameCont.lastarea : GameCont.area))){
			repeat(12){
				with(instance_create(x, y, SpiralStar)){
					sprite_index = sprBubble;
					image_speed  = random(0.2);
					
					 // Fast Forward:
					repeat(irandom_range(12, 48)){
						with(self){
							event_perform(ev_step, ev_step_normal);
						}
					}
				}
			}
		}
		
		 // Area-Specific:
		switch(GameCont.area){
			
			case area_desert:
				
				 // Another Universe Fallen:
				if(GameCont.lastarea == area_campfire && instance_exists(GenCont)){
					var _spr = spr.SpiralDebrisNothing;
					for(var _img = 0; _img < sprite_get_number(_spr); _img++){
						var	_l = 24,
							_d = random(360);
							
						with(instance_create((game_width / 2) + lengthdir_x(_l, _d), (game_height / 2) + lengthdir_y(_l, _d), SpiralDebris)){
							sprite_index = _spr;
							image_index  = _img;
							turnspeed   *= 2/3;
							angle        = _d;
							
							 // Fast Forward:
							repeat(irandom_range(25, 40)){
								with(self){
									event_perform(ev_step, ev_step_normal);
								}
							}
						}
					}
					with(instances_matching(SpiralDebris, "sprite_index", sprDebris1)){
						if(chance(1, 2)){
							sprite_index = sprDebris7;
						}
					}
				}
				
				break;
				
			default:
				
				 // NT:TE Areas:
				if(array_find_index(ntte.mods.area, GameCont.area) >= 0){
					mod_script_call_self("area", GameCont.area, "area_setup_spiral");
				}
				
		}
		
		current_time_scale = _lastTimeScale;
		random_set_seed(_lastSeed);
	}
	
#define ntte_setup_WepPickup(_inst)
	with(_inst){
		 // Guaranteed Secret Area Entry Weapons:
		if("ntte_weapon_spawn" in GameCont && array_length(GameCont.ntte_weapon_spawn)){
			with(GameCont.ntte_weapon_spawn){
				var _spawn = false;
				
				 // Natural Spawn:
				if(array_find_index(wep, call(scr.wep_raw, other.wep)) >= 0){
					_spawn = true;
				}
				
				 // Manual Spawn:
				else if(GameCont.area == area && GameCont.subarea == subarea){
					with(other) if(roll){
						var _chest = call(scr.instances_meeting_point, xstart, ystart, ChestOpen);
						
						 // Chest Counter:
						if(other.open != 0 && array_length(_chest)){
							other.open--;
						}
						
						 // Spawn Weapon from Pool:
						else{
							_spawn = true;
							
							 // Exclusion Pool:
							var	_mods  = mod_get_names("weapon"),
								_noWep = [];
								
							for(var i = 0; i < 128 + array_length(_mods); i++){
								var _wep = ((i < 128) ? i : _mods[i - 128]);
								if(array_find_index(other.wep, _wep) < 0){
									array_push(_noWep, _wep);
								}
							}
							
							 // Weapon:
							wep = call(scr.weapon_decide, 
								0,
								(array_length(_chest) > 0) + (2 * curse) + GameCont.hard,
								(weapon_get_gold(wep) > 0),
								_noWep
							);
						}
					}
				}
				
				 // Weapon Spawned:
				if(_spawn){
					GameCont.ntte_weapon_spawn = call(scr.array_delete_value, GameCont.ntte_weapon_spawn, self);
					break;
				}
			}
		}
		
		 // Weapon Skins:
		if(!roll && (ammo || instance_exists(GenCont) || instance_exists(LevCont))){
			if("ntte_weapon_skin_player" not in GameCont){
				GameCont.ntte_weapon_skin_player = [[], []];
			}
			
			var	_wep        = call(scr.wep_raw, wep),
				_wepSprt    = weapon_get_sprt(wep),
				_wepFirst   = true,
				_wepPlayer  = 0,
				_skinWep    = GameCont.ntte_weapon_skin_player[0],
				_skinPlayer = GameCont.ntte_weapon_skin_player[1],
				_skinPos    = array_find_index(_skinWep, _wep);
				
			 // Retrieve Player:
			if(_skinPos < 0){
				_skinPos = array_length(_skinWep);
				array_push(_skinWep,    _wep);
				array_push(_skinPlayer, _wepPlayer);
			}
			else{
				_wepPlayer = _skinPlayer[_skinPos];
				_wepFirst  = false;
			}
			
			 // Skin:
			repeat(maxp){
				if(player_is_active(_wepPlayer)){
					wep = call(scr.wep_skin, wep, player_get_race(_wepPlayer), player_get_skin(_wepPlayer));
				}
				if(!_wepFirst || _wepSprt != weapon_get_sprt(wep)){
					break;
				}
				_wepPlayer = (_wepPlayer + 1) % maxp;
			}
			
			 // Find Next Active Player:
			repeat(maxp){
				_wepPlayer = (_wepPlayer + 1) % maxp;
				if(player_is_active(_wepPlayer)){
					break;
				}
			}
			_skinWep[_skinPos]    = _wep;
			_skinPlayer[_skinPos] = _wepPlayer;
		}
	}
	
#define ntte_setup_Deflect(_inst)
	 // Teamify Deflections:
	with(_inst){
		if(distance_to_object(projectile) <= 0){
			with(call(scr.instances_meeting_instance, self, projectile)){
				if(call(scr.sprite_get_team, sprite_index) != 3){
					call(scr.team_instance_sprite, ((team == 3) ? 1 : team), self);
					
					 // Weapon Mimic Fix:
					if(
						hitid == -1
						//&& instance_is(creator, Player)
						&& place_meeting(x, y, projectile)
					){
						with(call(scr.instances_meeting_instance, self, instances_matching_ne(instances_matching([Slash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, LightningSlash, CustomSlash], "team", team), "hitid", -1))){
							if(place_meeting(x, y, other)){
								other.hitid = hitid;
								break;
							}
						}
					}
				}
			}
		}
	}
	
#define ntte_setup_ChestOpen(_inst)
	 // IDPD Chest Alerts:
	if(instance_exists(IDPDSpawn)){
		with(instances_matching(_inst, "sprite_index", sprIDPDChestOpen)){
			 // Alert:
			var _spr = spr.PopoAlert;
			if(array_length(instances_matching(IDPDSpawn, "elite", true))) _spr = spr.PopoEliteAlert;
			if(array_length(instances_matching(IDPDSpawn, "freak", true))) _spr = spr.PopoFreakAlert;
			with(call(scr.alert_create, self, _spr)){
				vspeed      = -0.8;
				image_speed = 0.1;
				alert       = { spr:spr.AlertIndicatorPopo, x:-5, y:5 };
				blink       = 20;
				flash       = 6;
				snd_flash   = sndIDPDNadeAlmost;
			}
			
			 // No Cheese:
			call(scr.portal_poof);
		}
	}
	
#define ntte_setup_VanSpawn(_inst)
	 // Van Alerts:
	with(_inst){
		var _side = choose(-1, 1);
		
		 // Determine Side:
		with(instance_nearest(x, y, Player)){
			if(x != other.x){
				_side = sign(x - other.x);
			}
		}
		
		 // Alert:
		with(call(scr.alert_create, noone, spr.VanAlert)){
			x             = other.x;
			y             = other.y;
			image_xscale *= _side;
			alert.x      *= -1;
			canview       = false;
			alarm0        = 12 + other.alarm0;
			blink         = 10;
		}
	}
	
#define ntte_setup_PlayerSit(_inst)
	 // Character Wins Stat:
	with(ntte.mods.race){
		for(var i = 0; i < maxp; i++){
			if(player_get_race(i) == self){
				var _stat = "race:" + self + ":wins";
				call(scr.stat_set, _stat, call(scr.stat_get, _stat) + 1);
				break;
			}
		}
	}
	
#define ntte_setup_Bubble(_inst)
	 // Make Bubbles Draw Themselves:
	with(_inst){
		depth   = -9;
		visible = true;
	}
	
#define ntte_setup_RainSplash(_inst)
	 // Make Rain Splashes Appear Above Walls:
	with(_inst){
		if(!place_meeting(x, y + 8, Floor)){
			depth = -7;
		}
	}
	
#define ntte_setup_BigTV(_inst)
	 // Override Shadow:
	with(instances_matching(_inst, "spr_shadow", shd24)){
		spr_shadow   = spr_idle;
		spr_shadow_x = -(image_xscale < 0);
		spr_shadow_y = 8;
	}
	
#define ntte_setup_Generator(_inst)
	 // Override Shadow:
	with(instances_matching(_inst, "spr_shadow", shd24)){
		spr_shadow = (
			(image_xscale < 0)
			? spr.shd.BigGeneratorR
			: spr.shd.BigGenerator
		);
		spr_shadow_x = 0;
		spr_shadow_y = 0;
	}
	
#define ntte_setup_GeneratorInactive(_inst)
	ntte_setup_Generator(_inst);
	
#define ntte_setup_Nothing2(_inst)
	 // Fix Throne 2 Not Deleting All Lone Walls:
	with(InvisiWall){
		if(place_meeting(x, y, Floor)){
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}
	}
	
#define ntte_setup_MaggotSpawn(_inst)
	 // MaggotSpawn doesn't start with a hitid:
	with(_inst){
		if(!is_real(hitid) && !is_array(hitid)){
			hitid = [sprMSpawnIdle, "MAGGOT NEST"];
		}
	}
	
#define ntte_setup_YungCuz(_inst)
	 // Yung Cuz Sprite Fix:
	with(instances_matching(instances_matching(_inst, "spr_to", sprCuzInteractTo), "spr_from", sprCuzInteractFrom)){
		var	_lastSpr = sprite_index,
			_lastImg = image_index,
			_looking = (distance_to_object(Player) <= 64);
			
		sprite_index = (_looking ? spr_idle : spr_heya);
		
		with(self){
			event_perform(ev_other, ev_animation_end);
		}
		
		if(sprite_index == (_looking ? spr_from : spr_to)){
			spr_from = sprCuzInteractTo;
			spr_to   = sprCuzInteractFrom;
		}
		
		sprite_index = _lastSpr;
		image_index  = _lastImg;
	}
	
#define ntte_setup_depth(_depthNormal, _depth, _inst)
	 // Override Depths:
	_inst = instances_matching(_inst, "depth", _depthNormal);
	if(array_length(_inst)){
		with(_inst){
			depth = _depth;
		}
	}
	
#define ntte_setup_shadow(_shadowNormal, _shadowXNormal, _shadowYNormal, _shadow, _shadowX, _shadowY, _inst)
	 // Override Shadows:
	_inst = instances_matching(instances_matching(instances_matching(_inst, "spr_shadow", _shadowNormal), "spr_shadow_x", _shadowXNormal), "spr_shadow_y", _shadowYNormal);
	if(array_length(_inst)){
		with(_inst){
			spr_shadow   = _shadow;
			spr_shadow_x = _shadowX;
			spr_shadow_y = _shadowY;
		}
	}
	
#define ntte_begin_step
	if(ntte_active){
		if(lag) trace_time();
		
		 // New Area:
		if("ntte_area_update" in GameCont && GameCont.ntte_area_update){
			GameCont.ntte_area_update = false;
			
			with(GameCont){
				 // NT:TE Area B-Themes:
				if(subarea == 1){
					if(array_find_index(ntte.mods.area, area) >= 0){
						if(chance(1, 20) || array_length(instances_matching_le(Player, "my_health", 1))){
							if(vaults < 3){
								proto = true;
							}
						}
					}
				}
				
				 // Manually Recreating Pause/Loading/GameOver Map:
				var _pos = waypoints - 1;
				if(_pos >= 0){
					if("ntte_mapdata" not in GameCont){
						GameCont.ntte_mapdata = [];
					}
					GameCont.ntte_mapdata[_pos] = [area, subarea, loops];
				}
			}
		}
		
		 // Character Selection Menu:
		if(instance_exists(Menu)){
			 // Custom Character Stuff:
			with(ntte.mods.race){
				var _name = self;
				
				 // Create Custom CampChars:
				if(mod_exists("race", _name) && call(scr.unlock_get, "race:" + _name)){
					if(!array_length(instances_matching(CampChar, "race", _name))){
						with(CampChar_create(64, 48, _name)){
							 // Poof in:
							repeat(8) with(instance_create(x, y + 4, Dust)){
								motion_add(random(360), 3);
								depth = other.depth - 1;
							}
						}
					}
				}
				
				 // CharSelect Management:
				with(instances_matching(CharSelect, "race", _name)){
					 // race_avail Fix:
					if(mod_script_exists("race", _name, "race_avail") && !mod_script_call_nc("race", _name, "race_avail")){
						noinput = 10;
					}
					
					 // New:
					else if(call(scr.stat_get, "race:" + _name + ":runs") <= 0){
						script_bind_draw(CharSelect_draw_new, depth - 1, self);
					}
				}
			}
			
			 // CampChar Management:
			for(var i = 0; i < maxp; i++) if(player_is_active(i)){
				var _race = player_get_race(i);
				if(array_find_index(ntte.mods.race, _race) >= 0){
					with(instances_matching(CampChar, "race", _race)){
						 // Pan Camera:
						var _local = false;
						for(var j = 0; j < maxp; j++){
							if(j != i && player_get_uid(j) == player_get_uid(i)){
								_local = true;
								break;
							}
						}
						if(!_local){
							var _char = instances_matching(CampChar, "num", 17);
							with(_char[array_length(_char) - 1]){
								var	_x1 = x,
									_y1 = y,
									_x2 = other.x,
									_y2 = other.y,
									_pan = 4;
									
								call(scr.view_shift, 
									i,
									point_direction(_x1, _y1, _x2, _y2),
									point_distance(_x1, _y1, _x2, _y2) * (1 + ((2/3) / _pan)) * 0.1
								);
							}
						}
						
						 // Manually Animate:
						if(anim_end){
							if(sprite_index != spr_menu){
								if(sprite_index == spr_to){
									sprite_index = spr_menu;
								}
								else{
									sprite_index = spr_to;
								}
							}
							image_index = 0;
						}
					}
				}
			}
		}
		
		 // NT:TE Player Systems:
		if(instance_exists(Player)){
			if("ntte_pet_max"  not in GameCont) GameCont.ntte_pet_max = 1;
			if("ntte_pet_icon" not in GameCont) GameCont.ntte_pet_icon = array_create(maxp, undefined);
			
			 // "global.pet_max" Legacy Support:
			if(global.pet_max != global.pet_max_last){
				GameCont.ntte_pet_max += (global.pet_max - global.pet_max_last);
			}
			global.pet_max      = GameCont.ntte_pet_max;
			global.pet_max_last = global.pet_max;
			
			 // Player Code:
			with(Player){
				
				/// Pets:
					
					if("ntte_pet"     not in self) ntte_pet     = [];
					if("ntte_pet_max" not in self) ntte_pet_max = GameCont.ntte_pet_max;
					
					 // Slots:
					if(array_length(ntte_pet) != max(0, ntte_pet_max)){
						while(array_length(ntte_pet) < max(0, ntte_pet_max)){
							array_push(ntte_pet, noone);
						}
						while(array_length(ntte_pet) > max(0, ntte_pet_max)){
							var _full = true;
							
							 // Clear Empty Slots:
							for(var i = 0; i < array_length(ntte_pet); i++){
								if(!instance_exists(ntte_pet[i])){
									ntte_pet = call(scr.array_delete, ntte_pet, i);
									_full = false;
									break;
								}
							}
							
							 // Clear Other Slots:
							if(_full){
								var _pos = array_length(ntte_pet) - 1;
								with(ntte_pet[_pos]){
									leader   = noone;
									can_take = true;
									
									 // Effects:
									with(instance_create(x + hspeed, y + vspeed, HealFX)){
										sprite_index = spr.PetLost;
										image_xscale = choose(-1, 1);
										image_speed  = 0.5;
										friction     = 1/8;
										depth        = -9;
									}
								}
								ntte_pet = call(scr.array_delete, ntte_pet, _pos);
							}
						}
					}
					
					 // Map Icons:
					var	_list = undefined,
						_inst = instances_matching_ne(ntte_pet, "id");
						
					if(array_length(_inst)){
						_list = [];
						with(_inst){
							array_push(_list, [pet, mod_type, mod_name, bskin]);
						}
					}
					
					GameCont.ntte_pet_icon[index] = _list;
					
				/// Red Ammo:
					
					if("red_ammo"        not in self) red_ammo        = 0;
					if("red_amax"        not in self) red_amax        = 4;
					if("red_amax_muscle" not in self) red_amax_muscle = 0;
					
					 // Back Muscle:
					var _muscle = skill_get(mut_back_muscle);
					if(red_amax_muscle != _muscle){
						red_amax -= 4 * red_amax_muscle;
						red_amax_muscle = _muscle;
						red_amax += 4 * red_amax_muscle;
					}
					
				/// Footprints:
					
					if(player_active){
						var _lastMask = mask_index;
						mask_index = sprite_index;
						
						 // Scuff Marks:
						if(position_meeting(x, bbox_bottom, ScorchTop)){
							footprint_give(40, make_color_rgb(23, 13, 13), 1.5);
						}
						
						 // Normal:
						else if(!position_meeting(x, bbox_bottom, FloorMiddle)){
							var _floor = instance_position(x, bbox_bottom, Floor);
							if(instance_exists(_floor)){
								switch(_floor.sprite_index){
									case sprFloor2B: // TOXIC
										footprint_give(20, make_color_rgb(149, 214, 6), 1.1);
										break;
										
									case sprFloor102B: // CHEESE
										footprint_give(20, make_color_rgb(239, 157, 8), 1.1);
										break;
										
									case sprFloor4B:
									case sprFloor104B: // WEBS
										footprint_give(20, make_color_rgb(234, 217, 237), 1.1);
										break;
										
									default: // SOFT
										if(_floor.material == 1 || _floor.material == 4){
											if(instance_exists(BackCont)){
												footprint_give(current_time_scale, BackCont.shadcol, BackCont.shadalpha + 0.05);
											}
										}
								}
							}
						}
						
						 // Make Footprints:
						if("ntte_foot_time" in self && ntte_foot_time > 0){
							if(
								sprite_index == spr_walk
								&& speed_raw > max(0, friction_raw)
								&& call(scr.option_get, "footprints")
							){
								if(footextra == true){
									footextra = 2;
								}
								if(round(image_index) == footstep + 2){
									if(
										roll == 0
										&& footkind != 0
										&& array_length(call(scr.instances_meeting_point, x, bbox_bottom, instances_matching_ne(Floor, "material", 0)))
									){
										var _side = (((footstep % 2) < 1) ? -1 : 1) * right;
										with(instance_create(
											x + (random_range(3, 4) * _side),
											bbox_bottom + ((race == "plant") ? -(_side / right) : 1),
											PhantomBolt
										)){
											sprite_index = sprBoltTrail;
											image_blend  = variable_instance_get(other, "ntte_foot_color", c_white);
											image_alpha  = variable_instance_get(other, "ntte_foot_alpha", 1);
											depth        = 5;
											friction     = 0.5;
											image_xscale = clamp(other.ntte_foot_time / 15, 1, 4);
											
											 // Face Direction:
											image_angle = other.direction;
											image_angle += 90 * _side * ((abs(other.hspeed) > abs(other.vspeed)) ? sign(other.hspeed * other.right) : sign(other.vspeed));
											
											 // Point Outward:
											image_angle += 20 * _side * ((other.vspeed == 0) ? 1 : sign(other.vspeed * ((other.hspeed == 0) ? 1 : sign(other.hspeed * other.right))));
											
											 // Shrink:
											if(fork()){
												while(instance_exists(self)){
													if(image_alpha < 0.3){
														image_xscale *= power(0.95, current_time_scale);
														image_yscale *= power(0.95, current_time_scale);
													}
													wait 0;
												}
												exit;
											}
										}
										ntte_foot_time -= 4;
									}
								}
							}
							ntte_foot_time -= current_time_scale;
						}
						
						mask_index = _lastMask;
					}
					else if("ntte_foot_time" in self){
						ntte_foot_time = 0;
					}
					
				// UNUSED FROG SOUNDS, THEY'RE AWESOME:
					
					if(frogcharge > 3){
						if(alarm3 > 0 && alarm3 <= ceil(current_time_scale)){
							var _butt = (skill_get(mut_throne_butt) > 0);
							sound_play_hit(_butt ? sndFrogGasReleaseButt : sndFrogGasRelease, 0.1);
							if(frogcharge > 30){
								sound_play_hit(_butt ? sndFrogEndButt : sndFrogEnd, 0.1);
							}
						}
					}
					
			}
		}
		
		 // Call Scripts:
		ntte_call("begin_step");
		
		 // Instance Setup:
		ntte_setup();
		
		 // NTTE Music / Ambience:
		ntte_music();
		
		 // Goodbye, stupid mechanic:
		if(GameCont.junglevisits > 0){
			skill_set(mut_last_wish, 1);
			GameCont.junglevisits--;
			GameCont.skillpoints--;
		}
		
		 // Last Wish:
		var _inst = instances_matching_ne(GameCont, "ntte_lastwish", skill_get(mut_last_wish));
		if(array_length(_inst)){
			with(_inst){
				var _wishDiff = (skill_get(mut_last_wish) - variable_instance_get(self, "ntte_lastwish", 0));
				ntte_lastwish = skill_get(mut_last_wish);
				
				if(ntte_lastwish != 0 && _wishDiff != 0){
					with(Player){
						 // LWO Weapons:
						with([wep, bwep]){
							var _wep = self;
							if(
								is_object(_wep)
								&& "ammo" in _wep
								&& "amax" in _wep
								&& array_find_index(ntte.mods.weapon, call(scr.wep_raw, _wep)) >= 0
							){
								var	_cost    = lq_defget(_wep, "cost", 0),
									_amax    = _wep.amax,
									_amaxRaw = (_amax / (1 + lq_defget(_wep, "buff", 0))),
									_wish    = lq_defget(_wep, "wish", (_amaxRaw < 200) ? ceil(_amax * 0.35) : round(_amax * 0.785));
									
								_wep.ammo = clamp(_wep.ammo + (_wish * _wishDiff), _cost, _amax);
							}
						}
						
						 // Parrot:
						if(race == "parrot"){
							if(feather_ammo < feather_ammo_max){
								var _wish = (2 * feather_num);
								feather_ammo = clamp(feather_ammo + (_wish * _wishDiff), feather_num, feather_ammo_max);
							}
						}
						
						 // Red Ammo:
						if("red_ammo" in self){
							if(
								call(scr.weapon_get, "red", wep)  > 0 ||
								call(scr.weapon_get, "red", bwep) > 0
							){
								var _wish = red_amax;
								red_ammo = min(red_ammo + (_wish * _wishDiff), red_amax);
							}
						}
					}
				}
			}
		}
		
		if(instance_exists(Player)){
			 // Player Death:
			var _inst = instances_matching_le(Player, "my_health", 0);
			if(array_length(_inst)){
				with(_inst){
					if(fork()){
						var	_x    = x,
							_y    = y,
							_save = ["ntte_pet", "bonus_ammo", "bonus_ammo_max", "bonus_health", "bonus_health_max", "red_ammo", "red_amax", "red_amax_muscle", "feather_ammo"],
							_vars = {},
							_race = race;
							
						with(_save){
							if(self in other){
								lq_set(_vars, self, variable_instance_get(other, self));
							}
						}
						
						wait 0;
						
						if(!instance_exists(self)){
							 // Storing Vars w/ Revive:
							with(other){
								with(call(scr.instance_nearest_array, _x, _y, instances_matching(Revive, "ntte_storage", null))){
									ntte_storage = call(scr.obj_create, x, y, "CustomRevive");
									with(ntte_storage){
										creator = other;
										vars    = _vars;
										p       = other.p;
									}
								}
							}
							
							 // Race Deaths Stat:
							if(array_find_index(ntte.mods.race, _race) >= 0){
								var _stat = "race:" + _race + ":lost";
								call(scr.stat_set, _stat, call(scr.stat_get, _stat) + 1);
							}
						}
						
						exit;
					}
				}
			}
			
			 // Robot:
			var _inst = instances_matching(Player, "race", "robot");
			if(array_length(_inst)){
				var _eatList = [];
				
				 // Normal Eating:
				with(_inst){
					if(
						canspec
						&& (button_pressed(index, "spec") || usespec == 1)
						&& bwep != wep_none
					){
						if(player_active){
							array_push(_eatList, [self, self]);
						}
					}
				}
				
				 // Auto Eating:
				if(instance_exists(Portal) && GameCont.endskill != 0){
					var _instPortal = instances_matching(Portal, "endgame", 30);
					if(array_length(_instPortal)){
						with(_instPortal){
							with(instances_matching_le(instances_matching(WepPickup, "persistent", false), "curse", 0)){
								if(position_meeting(x, y, RobotEat)){
									array_push(_eatList, [self, other]);
								}
							}
						}
					}
				}
				
				 // Eat:
				if(array_length(_eatList)){
					with(_eatList){
						var	_wepInst = self[0],
							_eatInst = self[1];
							
						with(_wepInst){
							var _wep = wep;
							with(_eatInst){
								 // Custom:
								mod_script_call(scr.weapon_get[0], scr.weapon_get[1], scr.weapon_get[2], "ntte_eat", _wep);
								
								 // Red:
								if(call(scr.weapon_get, "red", _wep) > 0){
									call(scr.obj_create, x, y, "RedAmmoPickup");
								}
							}
						}
					}
				}
			}
		}
		
		 // Intercept Alarms:
		if(((current_frame - current_time_scale + epsilon) % 1) < current_time_scale){
			 // Custom Area Effects:
			if(!instance_exists(GenCont) && !instance_exists(LevCont) && instance_exists(BackCont)){
				if(array_find_index(ntte.mods.area, GameCont.area) >= 0){
					var _inst = instances_matching(BackCont, "alarm0", 1);
					if(array_length(_inst)){
						with(_inst){
							alarm_set(0, 0);
							mod_script_call("area", GameCont.area, "area_effect");
							
							 // Extra Frame Delay:
							var _alarm = alarm_get(0);
							if(_alarm > 0){
								alarm_set(0, _alarm + ceil(current_time_scale));
							}
						}
					}
				}
			}
			
			 // Game Win Crown Unlock:
			if(instance_exists(PlayerSit) && array_length(instances_matching(PlayerSit, "alarm0", 1))){
				if(array_find_index(ntte.mods.crown, crown_current) >= 0){
					call(scr.unlock_set, `loadout:crown:${crown_current}`, true);
				}
			}
			
			 // Portal Out of Bounds Fix:
			if(instance_exists(Portal)){
				var _inst = instances_matching(Portal, "alarm0", 1);
				if(array_length(_inst)){
					with(_inst){
						alarm0 = 0;
						event_perform(ev_alarm, 0);
						xprevious = x;
						yprevious = y;
					}
				}
			}
		}
		
		if(lag) trace_time("ntte_begin_step");
	}
	
#define ntte_step
	if(ntte_active){
		if(lag) trace_time();
		
		 // Level Start:
		if(instance_exists(GenCont) || instance_exists(Menu)){
			GameCont.ntte_level_start = true;
		}
		else if("ntte_level_start" in GameCont && GameCont.ntte_level_start){
			GameCont.ntte_level_start = false;
			level_start();
		}
		
		 // Area Completion Unlocks:
		if(!instance_exists(GenCont) && !instance_exists(LevCont) && instance_exists(Player)){
			if(instance_exists(Portal) || (!instance_exists(enemy) && !instance_exists(becomenemy) && !instance_exists(CorpseActive))){
				//if(!array_length(instances_matching_ne(obj.CatHoleBig, "sprite_index", mskNone))){ yokin wtf how could you comment out my epic code!?!?
					if(array_find_index(["coast", "oasis", "trench", "lair", "red"], GameCont.area) >= 0){
						if(GameCont.subarea >= call(scr.area_get_subarea, GameCont.area)){
							call(scr.unlock_set, "pack:" + GameCont.area, true);
						}
					}
				//}
			}
		}
		
		 // Call Scripts:
		ntte_call("step");
		
		 // Instance Setup:
		ntte_setup();
		
		 // Proto Statue Destroys Portal:
		if(instance_exists(ProtoStatue) && (instance_exists(enemy) || instance_exists(IDPDSpawn))){
			var _inst = instances_matching(ProtoStatue, "ntte_portalpoof_check", null);
			if(array_length(_inst)){
				with(_inst){
					if(my_health < maxhealth * 0.7){
						ntte_portalpoof_check = true;
						call(scr.portal_poof);
					}
				}
			}
		}
		
		 // Better Inactive Throne Hitbox:
		if(instance_exists(NothingIntroMask)){
			var _inst = instances_matching(NothingIntroMask, "mask_index", mskNothingInactive, msk.NothingInactiveCool);
			if(array_length(_inst)){
				with(_inst){
					var _instThrone = instances_matching(instances_matching([NothingInactive, BecomeNothing], "xstart", xstart), "ystart", ystart);
					if(array_length(_instThrone)){
						with(_instThrone){
							 // Activation:
							if(
								instance_is(self, BecomeNothing)
								&& sprite_index == sprNothingActivate
								&& image_index >= 1
							){
								 // Reset Depth:
								if(depth >= object_get_depth(BackCont)){
									depth = object_get_depth(Nothing);
								}
								
								 // Leg Break Wall:
								if(image_index >= 2){
									var _lastMask = mask_index;
									mask_index = object_get_mask(Nothing);
									if(place_meeting(x, y, Wall)){
										with(call(scr.instances_meeting_rectangle,
											bbox_left,
											lerp(bbox_bottom, bbox_top, clamp(floor(image_index) / 6, 0, 1)),
											bbox_right,
											bbox_bottom,
											Wall
										)){
											if(place_meeting(x, y, other)){
												instance_create(x, y, FloorExplo);
												instance_destroy();
											}
										}
									}
									mask_index = _lastMask;
								}
							}
							
							 // Shadow Fix:
							else{
								depth = max(depth, object_get_depth(BackCont));
								if("spr_shadow" in self){
									spr_shadow = -1;
								}
							}
							
							 // Better Hitbox:
							with(other){
								if(instance_is(other, NothingInactive)){
									if(mask_index == mskNothingInactive){
										mask_index = msk.NothingInactiveCool;
									}
								}
								
								 // Reset:
								else if(mask_index == msk.NothingInactiveCool){
									mask_index = mskNothingInactive;
									
									with(other){
										 // Pipe Depth Fix:
										if(object_get_depth(NothingPipes) <= depth){
											with(instance_nearest(x, y, NothingPipes)){
												with(other){
													with(instance_create(x, y, GameObject)){
														sprite_index = object_get_sprite(NothingPipes);
														depth        = other.depth;
													}
												}
												instance_destroy();
											}
										}
										
										 // Flame Fix:
										with(instance_create(x - 81, y - 38, Wind)) sprite_index = sprThroneFlameEnd;
										with(instance_create(x + 81, y - 38, Wind)) sprite_index = sprThroneFlameEnd;
										with(instance_create(x - 81, y + 18, Wind)) sprite_index = sprThroneFlameEnd;
										with(instance_create(x + 81, y + 18, Wind)) sprite_index = sprThroneFlameEnd;
									}
								}
							}
						}
					}
					
					 // Better Collision:
					var _lastSolid = solid;
					solid = true;
					with(Player){
						call(scr.motion_step, self, 1);
						
						 // Smooth Wall Collision:
						if(place_meeting(x, y, other)){
							x = xprevious;
							y = yprevious;
							
							if(place_meeting(x, y + max(0, vspeed_raw), other)){
								direction = 270 + (30 * clamp(hspeed / 4, -1, 1));
							}
							else{
								event_perform(ev_collision, InvisiWall);
							}
							
							x += hspeed_raw;
							y += vspeed_raw;
						}
						
						call(scr.motion_step, self, -1);
						
						 // Slow Stair Climbing:
						if(collision_rectangle(other.x - 20, other.y + 40, other.x + 20, other.y + 80, self, false, false)){
							ntte_stairslow = 8;
						}
					}
					solid = _lastSolid;
				}
			}
		}
		
		 // Player Collision:
		if(instance_exists(Player)){
			 // Smoother Captain Desk Collision:
			if(instance_exists(LastIntro)){
				with(LastIntro){
					var _lastSolid = solid;
					solid = true;
					with(Player){
						call(scr.motion_step, self, 1);
						if(place_meeting(x, y, other)){
							x = xprevious;
							y = yprevious;
							event_perform(ev_collision, InvisiWall);
							x += hspeed_raw;
							y += vspeed_raw;
						}
						call(scr.motion_step, self, -1);
					}
					solid = _lastSolid;
				}
			}
			
			 // Stair Climbing:
			var _inst = instances_matching_gt(Player, "ntte_stairslow", 0);
			if(array_length(_inst)){
				with(_inst){
					 // Slow:
					if(roll == false){
						if(abs(vspeed) > 0.2 && skill_get(mut_extra_feet) <= 0){
							//if(!instance_exists(Nothing)){
								var _goal = 0.45 + (maxspeed / 4);
								if(friction < _goal){
									friction = lerp(friction, _goal, ntte_stairslow / 5);
								}
							//}
						}
					}
					
					 // Don't roll on stairs bro:
					else if(skill_get(mut_throne_butt) <= 0){
						vspeed += 0.4 * current_time_scale;
					}
					
					ntte_stairslow -= current_time_scale;
				}
			}
		}
		
		 // Crowns Face Direction:
		if(instance_exists(Crown)){
			var _inst = instances_matching_ne(Crown, "hspeed", 0);
			if(array_length(_inst)){
				with(_inst){
					if(sign(image_xscale) != sign(hspeed)){
						image_xscale = abs(image_xscale) * sign(hspeed);
					}
				}
			}
		}
		
		 // Portal Weapons:
		if(instance_exists(SpiralCont) && (instance_exists(GenCont) || instance_exists(LevCont))){
			if(instance_exists(WepPickup)){
				with(WepPickup){
					if("portal_inst" not in self || !instance_exists(portal_inst)){
						var _lastSeed = random_get_seed();
						portal_inst = instance_create(SpiralCont.x, SpiralCont.y, SpiralDebris);
						with(portal_inst){
							sprite_index = other.sprite_index;
							image_index  = 0;
							turnspeed    = orandom(1);
							rotspeed     = orandom(15);
							dist         = random_range(80, 120);
						}
						random_set_seed(_lastSeed);
					}
					with(portal_inst){
						sprite_index = other.sprite_index;
						image_xscale = 0.7 + (0.1 * sin((-image_angle / 2) / 200));
						image_yscale = image_xscale;
						grow         = 0;
					}
				}
			}
		}
		
		 // Disable Pet Collision to Avoid Projectiles:
		if(array_length(obj.Pet)){
			var _inst = instances_matching_ne(instances_matching_le(obj.Pet, "maxhealth", 0), "mask_index", mskNone);
			if(array_length(_inst)){
				with(_inst){
					mask_store = mask_index;
					mask_index = mskNone;
				}
			}
		}
		
		if(lag) trace_time("ntte_step");
	}
	
#define ntte_end_step
	if(ntte_active){
		if(lag) trace_time();
		
		 // Crown Found:
		if(is_string(crown_current) && array_find_index(ntte.mods.crown, crown_current) >= 0){
			call(scr.stat_set, "found:" + crown_current + ".crown", true);
			call(scr.save_set, "unlock:pack:crown",                 true);
		}
		
		 // Player-Related:
		if(instance_exists(Player)){
			 // Locked Weapons:
			with(Player){
				for(var i = 0; i < 2; i++){
					var	_wep = ((i == 0) ? wep : bwep),
						_raw = call(scr.wep_raw, _wep);
						
					if(
						is_string(_raw)
						&& mod_script_exists("weapon", _raw, "weapon_avail")
						&& array_find_index(ntte.mods.weapon, _raw) >= 0
					){
						 // No Cheaters (bro just play the mod):
						if(!call(scr.weapon_get, "avail", _wep)){
							var _b = ((i == 0) ? "" : "b");
							
							 // Boneify:
							variable_instance_set(self, _b + "wep",      "crabbone");
							variable_instance_set(self, _b + "wepangle", choose(-120, 120));
							
							 // Effects:
							sound_play(sndCrownRandom);
							view_shake_at(x, y, 20);
							instance_create(x, y, GunWarrantEmpty);
							repeat(2){
								with(call(scr.fx, x, y, [gunangle + variable_instance_get(self, _b + "wepangle"), 2.5], Smoke)){
									depth = other.depth - 1;
								}
							}
						}
						
						 // Weapon Found:
						else call(scr.stat_set, "found:" + _raw + ".wep", true);
					}
				}
			}
			
			 // Character Stats:
			with(ntte.mods.race){
				for(var i = 0; i < maxp; i++){
					if(player_get_race(i) == self){
						 // Time:
						if((!array_length(instances_matching(instances_matching(Player, "race", self), "visible", false)) && !instance_exists(GenCont)) || instance_exists(LevCont)){
							if(!instance_exists(PlayerSit)){
								var _stat = "race:" + self + ":time";
								call(scr.stat_set, _stat, call(scr.stat_get, _stat) + (current_time_scale / 30));
							}
						}
						
						 // Kills:
						if("ntte_kills_last" in GameCont && GameCont.kills != GameCont.ntte_kills_last){
							var _stat = "race:" + self + ":kill";
							call(scr.stat_set, _stat, call(scr.stat_get, _stat) + (GameCont.kills - GameCont.ntte_kills_last));
							
							 // Best Run:
							if(GameCont.kills >= call(scr.stat_get, "race:" + self + ":best:kill")){
								call(scr.stat_set, "race:" + self + ":best:area", [GameCont.area, GameCont.subarea, GameCont.loops]);
								call(scr.stat_set, "race:" + self + ":best:kill", GameCont.kills);
							}
						}
						
						break;
					}
				}
			}
		}
		GameCont.ntte_kills_last = GameCont.kills;
		
		 // Make Flying Ravens/Lil Hunter Draw Themselves:
		if(instance_exists(RavenFly) || instance_exists(LilHunterFly)){
			var _inst = instances_matching_gt([RavenFly, LilHunterFly], "depth", object_get_depth(SubTopCont));
			if(array_length(_inst)){
				with(_inst){
					depth   = -9;
					visible = true;
				}
			}
			
			 // Reset:
			if(instance_exists(RavenFly)){
				_inst = instances_matching(instances_matching(RavenFly, "sprite_index", sprRavenLand), "depth", -9);
				if(array_length(_inst)){
					with(_inst){
						if(anim_end){
							depth = object_get_depth(Raven);
						}
					}
				}
			}
			if(instance_exists(LilHunterFly)){
				_inst = instances_matching(instances_matching_ge(instances_matching(LilHunterFly, "sprite_index", sprLilHunterLand), "z", -10 * current_time_scale), "depth", -9);
				if(array_length(_inst)){
					with(_inst){
						depth = object_get_depth(LilHunter);
					}
				}
			}
		}
		
		 // Smaller Cause of Death:
		if(GameCont.deathcause == 37){
			GameCont.deathcause = [spr.NothingDeathCause, "THE THRONE"];
		}
		
		 // Call Scripts:
		ntte_call("end_step");
		
		 // Instance Setup:
		ntte_setup();
		
		 // Bind HUD Drawing:
		with(global.hud_bind.id){
			script[3] = false;
			
			 // Normal:
			if(instance_exists(TopCont)){
				with(instances_matching(TopCont, "visible", true)){
					if(!other.script[3] || depth - 1 <= other.depth){
						other.script[3] = true;
						other.script[4] = ((fadeout == true) ? fade : 0);
						other.depth     = depth - 1;
					}
				}
			}
			
			 // Loading / Level Up Screen:
			if(instance_exists(GenCont) || instance_exists(LevCont)){
				with(instances_matching(UberCont, "visible", true)){
					if(!other.script[3] || depth - 1 <= other.depth){
						other.script[3] = true;
						other.script[4] = 0;
						other.depth     = depth - 1;
					}
				}
			}
		}
		
		 // Loading Screen Map Drawing Setup:
		with(global.map_bind[? "load"].id){
			visible = false;
			if(instance_exists(GenCont) && !instance_exists(PopoScene) && !GameCont.win){
				with(instances_matching(GenCont, "visible", true)){
					if(!other.visible || depth - 1 <= other.depth){
						other.visible = true;
						other.depth   = depth - 1;
					}
				}
			}
		}
		
		 // Game Over Screen Map Drawing Setup:
		with(global.map_bind[? "dead"].id){
			var	_anim  = 0,
				_stage = 0;
				
			visible = false;
			
			if(!instance_exists(Player) && instance_exists(TopCont) && !instance_exists(UnlockScreen)){
				if(!instance_exists(GenCont) || instance_exists(PopoScene) || instance_exists(LastFire)){
					with(instances_matching(instances_matching(TopCont, "visible", true), "go_addy1", 0)){
						if(!other.visible || depth - 1 <= other.depth){
							other.visible = true;
							other.depth   = depth - 1;
							_stage        = go_stage;
							_anim         = mapanim;
						}
					}
				}
			}
			
			script[4] = 4 - min(2, _stage + current_time_scale);
			script[5] = _anim;
		}
		
		if(lag) trace_time("ntte_end_step");
	}
	
#define draw
	if(ntte_active){
		if(lag) trace_time();
		
		 // Call Scripts:
		ntte_call("draw");
		
		if(lag) trace_time("ntte_draw");
	}
	
#define draw_dark // Drawing Grays
	if(ntte_active){
		draw_set_color(c_gray);
		
		if(lag) trace_time();
		
		 // Call Scripts:
		ntte_call(["draw_dark", "normal"]);
		
		if(lag) trace_time("ntte_draw_dark");
	}
	
#define draw_dark_end // Drawing Clear
	if(ntte_active){
		draw_set_color(c_black);
		
		if(lag) trace_time();
		
		 // Call Scripts:
		ntte_call(["draw_dark", "end"]);
		
		if(lag) trace_time("ntte_draw_dark_end");
	}
	
#define draw_bloom
	if(ntte_active){
		if(lag) trace_time();
		
		 // Call Scripts:
		ntte_call("draw_bloom");
		
		 // GunCont (Merged Laser Cannon):
		if(array_length(obj.GunCont)){
			var _inst = instances_matching_gt(obj.GunCont, "bloom", 0);
			if(array_length(_inst)){
				with(_inst){
					var _scr = on_draw;
					if(array_length(_scr) >= 3){
						var	_xsc = 2,
							_ysc = 2,
							_alp = 0.1 * bloom;
							
						image_xscale *= _xsc;
						image_yscale *= _ysc;
						image_alpha  *= _alp;
						
						call(scr.pass, self, _scr);
						
						image_xscale /= _xsc;
						image_yscale /= _ysc;
						image_alpha  /= _alp;
					}
				}
			}
		}
		
		if(lag) trace_time("ntte_draw_bloom");
	}
	
#define draw_shadows
	if(ntte_active){
		var _lag = (lag && !instance_exists(PauseButton) && !instance_exists(BackMainMenu));
		if(_lag) trace_time();
		
		 // Throne Intro Shadow:
		if(instance_exists(BecomeNothing)){
			var _inst = instances_matching_ge(instances_matching(instances_matching(BecomeNothing, "visible", true), "sprite_index", sprNothingActivate), "image_index", 1);
			if(array_length(_inst)){
				with(_inst){
					draw_sprite(spr.shd.Nothing, 0, x, y);
				}
			}
		}
		
		 // Campfire Maggot Shadow:
		if(instance_exists(CampChar)){
			var _inst = instances_matching(CampChar, "sprite_index", sprEyesMenu, sprEyesMenuSelected, sprEyesMenuDeselect, sprEyesMenuSelect);
			if(array_length(_inst)){
				with(_inst){
					switch(sprite_index){
						case sprEyesMenu         : draw_sprite(spr.shd.EyesMenu, image_index, x + spr_shadow_x,     y + spr_shadow_y); break;
						case sprEyesMenuDeselect : draw_sprite(spr.shd.EyesMenu, 0,           x + spr_shadow_x - 1, y + spr_shadow_y); break;
						default                  : draw_sprite(spr.shd.EyesMenu, 0,           x + spr_shadow_x - 2, y + spr_shadow_y);
					}
				}
			}
		}
		
		 // Popo Shields:
		if(instance_exists(PopoShield)){
			var _inst = instances_matching(instances_matching_gt(PopoShield, "alarm0", 0), "spr_shadow", null);
			if(array_length(_inst)){
				with(_inst){
					draw_sprite(shd48, 0, x, y);
				}
			}
		}
		
		 // Call Scripts:
		ntte_call("draw_shadows");
		
		if(_lag) trace_time("ntte_draw_shadows");
	}
	
#define draw_top_shadows
	if(ntte_active){
		if(array_length(obj.TopObject) || array_length(obj.MortarPlasma) || array_length(obj.BigPipe)){
			if(!instance_exists(NothingSpiral) && instance_exists(BackCont)){
				if(lag) trace_time();
				
				var	_inst = [obj.TopObject, obj.MortarPlasma, obj.BigPipe],
					_draw = false;
					
				for(var i = array_length(_inst) - 1; i >= 0; i--){
					if(array_length(_inst[i])){
						_inst[i] = instances_matching_ne(instances_matching(_inst[i], "visible", true), "spr_shadow", -1);
						if(i != 2){
							_inst[i] = instances_matching_ge(_inst[i], "z", 8);
						}
						if(!_draw && array_length(_inst[i])){
							_draw = true;
						}
					}
				}
				
				if(_draw){
					var	_vx                = view_xview_nonsync,
						_vy                = view_yview_nonsync,
						_gw                = game_width,
						_gh                = game_height,
						_surfScale         = call(scr.option_get, "quality:minor"),
						_surfTopShadowMask = call(scr.surface_setup, "TopShadowMask", _gw * 2, _gh * 2, _surfScale),
						_surfTopShadow     = call(scr.surface_setup, "TopShadow",     _gw,     _gh,     _surfScale);
						
					with(_surfTopShadowMask){
						var	_surfX = pfloor(_vx, _gw),
							_surfY = pfloor(_vy, _gh);
							
						if(
							reset
							|| x != _surfX
							|| y != _surfY
							|| (instance_number(Floor) != lq_defget(self, "floor_num", 0))
							|| (instance_number(Wall)  != lq_defget(self, "wall_num",  0))
							|| (instance_exists(Floor) && lq_defget(self, "floor_min", 0) < Floor.id)
							|| (instance_exists(Wall)  && lq_defget(self, "wall_min",  0) < Wall.id)
						){
							reset = false;
							
							 // Update Vars:
							x         = _surfX;
							y         = _surfY;
							floor_num = instance_number(Floor);
							wall_num  = instance_number(Wall);
							floor_min = instance_max;
							wall_min  = instance_max;
							
							 // Floor Mask:
							surface_set_target(surf);
							draw_clear_alpha(c_black, 0);
								
								 // Draw Floors:
								d3d_set_projection_ortho(x, y + 8, w, h, 0);
								with(call(scr.instances_meeting_rectangle, x, y, x + w, y + h, Floor)){
									draw_self();
								}
								
								 // Cut Out Walls:
								d3d_set_projection_ortho(x, y, w, h, 0);
								draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
								with(call(scr.instances_meeting_rectangle, x, y, x + w, y + h, Wall)){
									draw_sprite(outspr, outindex, x, y);
								}
								draw_set_blend_mode(bm_normal);
								
							d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
							surface_reset_target();
						}
					}
					
					with(_surfTopShadow){
						x = _vx;
						y = _vy;
						
						surface_set_target(surf);
						draw_clear_alpha(c_black, 0);
						d3d_set_projection_ortho(x, y, w, h, 0);
							
							 // Normal Shadows:
							if(array_length(_inst[0])){
								with(call(scr.instances_seen_nonsync, _inst[0], 8, 8)){
									draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y - 8);
								}
							}
							
							 // Mortar Plasma Shadows:
							if(array_length(_inst[1])){
								with(call(scr.instances_seen_nonsync, _inst[1], 8, 8)){
									var	_percent = clamp(96 / (z - 8), 0.1, 1),
										_w       = ceil(18 * _percent),
										_h       = ceil(6 * _percent),
										_x       = x,
										_y       = y - 8;
										
									draw_ellipse(_x - (_w / 2), _y - (_h / 2), _x + (_w / 2), _y + (_h / 2), false);
								}
							}
							
							 // Big Pipe Shadows:
							if(array_length(_inst[2])){
								with(call(scr.instances_seen_nonsync, _inst[2], 8, 8)){
									draw_sprite_ext(
										spr_top_idle,
										image_index,
										x + spr_shadow_x,
										y + spr_shadow_y,
										image_xscale,
										image_yscale,
										image_angle,
										image_blend,
										image_alpha
									);
								}
							}
							
							 // Cut Out Floors:
							with(_surfTopShadowMask){
								draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
								call(scr.draw_surface_scale, surf, x, y, 1 / scale);
								draw_set_blend_mode(bm_normal);
							}
							
						d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
						surface_reset_target();
						
						 // Draw Surface:
						draw_set_fog(true, BackCont.shadcol, 0, 0);
						draw_set_alpha(BackCont.shadalpha * 0.9);
						call(scr.draw_surface_scale, surf, x, y, 1 / scale);
						draw_set_fog(false, 0, 0, 0);
						draw_set_alpha(1);
					}
				}
				
				if(lag) trace_time(script[2]);
			}
		}
	}
	
#define draw_pause
	if(ntte_active){
		 // Pause Map Drawing:
		var _start = false;
		for(var i = 0; i < maxp; i++){
			if(button_pressed(i, "paus")){
				_start = true;
				break;
			}
		}
		if(!instance_exists(global.map_bind[? "pause"]) && !_start){
			with(script_bind_draw(ntte_map_pause, UberCont.depth - 1)){
				global.map_bind[? "pause"] = self;
				with(self){
					event_perform(ev_draw, 0);
				}
			}
		}
		
		 // Pause HUD:
		var _local = player_find_local_nonsync();
		if(player_is_active(_local)){
			var _col = c_white;
			
			 // Dim:
			if(instance_exists(BackMainMenu)){
				_col = merge_color(_col, c_black, 0.9);
			}
			
			 // Skill HUD:
			if(UberCont.alarm2 < 0){
				for(var i = 0; player_is_active(player_find_local_nonsync(i)); i++){
					if(player_get_show_skills(player_find_local_nonsync(i))){
						with(call(scr.surface_setup, "HUDSkill", null, null, null)){
							x = view_xview_nonsync + (game_width - w);
							y = view_yview_nonsync;
							draw_surface_ext(surf, x, y, 1 / scale, 1 / scale, 0, _col, 1);
						}
						break;
					}
				}
			}
			
			 // Main HUD:
			for(var i = 0; player_is_active(player_find_local_nonsync(i)); i++){
				if(player_get_show_hud(_local, player_find_local_nonsync(i))){
					with(call(scr.surface_setup, "HUDMain", null, null, null)){
						x = view_xview_nonsync;
						y = view_yview_nonsync;
						draw_surface_ext(surf, x, y, 1 / scale, 1 / scale, 0, _col, 1);
					}
					break;
				}
			}
		}
		
		 // Instance Setup:
		ntte_setup();
	}
	
#define draw_gui
	if(ntte_active){
		 // Game Over Skill HUD:
		if(!instance_exists(Player) && !instance_exists(GenCont) || instance_exists(PopoScene) || instance_exists(LastFire)){
			if(!instance_exists(UnlockScreen)){
				with(instances_matching(UberCont, "visible", true)){
					for(var i = 0; player_is_active(player_find_local_nonsync(i)); i++){
						if(player_get_show_skills(player_find_local_nonsync(i))){
							with(call(scr.surface_setup, "HUDSkill", null, null, null)){
								x = view_xview_nonsync + (game_width - w);
								y = view_yview_nonsync;
								call(scr.draw_surface_scale, surf, x - view_xview_nonsync, y - view_yview_nonsync, 1 / scale);
							}
							break;
						}
					}
				}
			}
		}
	}
	
#define draw_gui_end
	if(ntte_active){
		var _lag = (lag && !instance_exists(PauseButton) && !instance_exists(BackMainMenu));
		if(_lag) trace_time();
		
		 // NT:TE Music / Ambience:
		ntte_music();
		
		 // NT:TE Time Stat:
		call(scr.stat_set, "time", call(scr.stat_get, "time") + (current_time_scale / 30));
		
		 // Reset Warp Zone Map Data:
		mod_variable_set("area", "red", "mapdata_warp_draw", undefined);
		
		 // Debug Log Spacing:
		if(_lag){
			trace_time("draw_gui_end");
			trace("");
		}
	}
	
#define mapdata_get(_index)
	var _map = [];
	
	 // Disable Drawing:
	var	_lastVis = array_create(maxp, true),
		_lastCol = draw_get_color(),
		_lastAlp = draw_get_alpha();
		
	for(var i = 0; i < maxp; i++){
		_lastVis[i] = draw_get_visible(i);
	}
	draw_set_visible_all(false);
	draw_set_color(c_white);
	draw_set_alpha(0);
	
	for(var i = -1; i < GameCont.waypoints; i++){
		var _data = {
			x        : 0,
			y        : 0,
			area     : -1,
			subarea  : 0,
			loops    : 0,
			showdot  : false,
			showline : true
		};
		
		if(
			"ntte_mapdata" in GameCont
			&& i >= 0
			&& i < array_length(GameCont.ntte_mapdata)
		){
			var	_dataLast = _map[i],
				_waypoint = GameCont.ntte_mapdata[i];
				
			if(is_array(_waypoint)){
				_data.area    = _waypoint[0];
				_data.subarea = _waypoint[1];
				_data.loops   = _waypoint[2];
			}
			
			 // Base Game:
			if(is_real(_data.area)){
				if(_data.area < 100){
					var _num = 0;
					_num += 3 *  ceil((floor(_data.area) - 1) / 2); // Main Areas
					_num += 1 * floor((floor(_data.area) - 1) / 2); // Transition Areas
					_num += _data.subarea - 1;                      // Subarea
					_num += (_data.area - floor(_data.area));       // Fractional Areas
					
					_data.x = 9 * _num;
					_data.y = 0;
				}
				
				 // Secret Areas:
				else{
					_data.x = _dataLast.x;
					_data.y = 9;
				}
				
				_data.showdot = (_data.subarea == 1);
			}
			
			 // Modded:
			else if(is_string(_data.area)){
				with(UberCont){
					var	_dataNext = mod_script_call_self("area", _data.area, "area_mapdata", _dataLast.x, _dataLast.y, _dataLast.area, _dataLast.subarea, _data.subarea, _data.loops),
						_dataSize = array_length(_dataNext);
						
					if(_dataSize >= 2){
						_data.x = _dataNext[0];
						_data.y = _dataNext[1];
						if(_dataSize >= 3) _data.showdot  = _dataNext[2];
						if(_dataSize >= 4) _data.showline = _dataNext[3];
					}
				}
			}
		}
		
		array_push(_map, _data);
	}
	
	 // Reset Drawing:
	for(var i = 0; i < maxp; i++){
		draw_set_visible(i, _lastVis[i]);
	}
	draw_set_color(_lastCol);
	draw_set_alpha(_lastAlp);
	
	 // Return Specific Waypoint:
	if(_index >= 0){
		return ((_index < array_length(_map)) ? _map[_index] : _map[0]);
	}
	
	return _map;
	
#define ntte_hud(_visible, _fade)
	if(ntte_active){
		if(lag) trace_time();
		
		var	_hudList = call(scr.player_get_hud_index),
			_players = 0,
			_pause   = false,
			_vx      = view_xview_nonsync,
			_vy      = view_yview_nonsync,
			_gw      = game_width,
			_gh      = game_height;
			
		 // Players:
		for(var i = 0; i < maxp; i++){
			if(player_is_active(i)){
				_players++;
				
				 // Pause Imminent:
				if(instance_exists(Player)){
					if(button_pressed(i, "paus")){
						_pause = true;
					}
				}
			}
		}
		
		 // Mutation HUD:
		with(call(scr.surface_setup, "HUDSkill", _gw, _gh, game_scale_nonsync)){
			x = _vx;
			y = _vy;
			
			var _draw = false;
			
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			d3d_set_projection_ortho(0, 0, w, h, 0);
			
			if(_players <= 1 || instance_exists(Player)){
				with(UberCont){
					var	_skillList = [],
						_skillType = [];
						
					 // Compile Orchid Mutations to Draw:
					if(array_length(obj.OrchidSkill)){
						with(instances_matching_ne(obj.OrchidSkill, "id")){
							if(skill_get(skill) != 0){
								array_push(_skillType, "orchid");
								array_push(_skillList, skill);
							}
						}
					}
					
					 // Compile Orchid Rerolls to Draw:
					if("ntte_reroll_hud" in GameCont && GameCont.ntte_reroll_hud != undefined){
						if(skill_get(GameCont.ntte_reroll_hud) != 0){
							array_push(_skillType, "reroll");
							array_push(_skillList, GameCont.ntte_reroll_hud);
						}
					}
					
					 // Mutation Drawing:
					if(array_length(_skillList)){
						var	_sx   = _gw - 11,
							_sy   = 12,
							_addx = -16,
							_addy = 16,
							_minx = 110 - (17 * (_players > 1));
							
						 // Patience Fix:
						var _m = array_length(_skillList);
						for(var i = 0; i < _m; i++){
							if(_skillList[i] == mut_patience && skill_get(GameCont.hud_patience) != 0){
								array_push(_skillType, _skillType[i]);
								array_push(_skillList, GameCont.hud_patience);
							}
						}
						
						 // Co-op Offset:
						if(!_pause && instance_exists(Player)){
							if(_players >= 2){
								_minx = 10;
								_addy *= -1;
								_sy = _gh - 12;
								if(instance_exists(LevCont)){
									_sy -= 34;
								}
								else{
									if(_players >= 3) _minx = 100;
									if(_players >= 4) _sx = _gw - 100;
								}
							}
						}
						
						var	_x = _sx,
							_y = _sy;
							
						 // Ultras Offset:
						var _raceMods = mod_get_names("race");
						for(var i = 0; i < 17 + array_length(_raceMods); i++){
							var _race = ((i < 17) ? i : _raceMods[i - 17]);
							for(var j = 1; j <= ultra_count(_race); j++){
								if(ultra_get(_race, j) != 0){
									_x += _addx;
									if(_x < _minx){
										_x = _sx;
										_y += _addy;
									}
								}
							}
						}
						
						 // Draw:
						for(var i = 0; true; i++){
							var _skill = skill_get_at(i);
							if(_skill == undefined){
								break;
							}
							if(_skill != mut_patience || real(string(GameCont.hud_patience)) == mut_none){ // yes the game does real(string())
								var _skillIndex = array_find_index(_skillList, _skill);
								if(_skillIndex >= 0){
									while(_skillIndex >= 0){
										switch(_skillType[_skillIndex]){
											
											case "reroll": // VAULT FLOWER
												
												_draw = true;
												
												draw_sprite(
													spr.SkillRerollHUDSmall,
													0,
													_x + ((_skill == GameCont.hud_patience) ? -4 : 5),
													_y + 5
												);
												
												break;
												
											case "orchid": // ORCHID MANTIS
												
												var	_icon = call(scr.skill_get_icon, _skill),
													_spr  = _icon[0],
													_img  = _icon[1];
													
												if(sprite_exists(_spr)){
													_draw = true;
													
													var	_wave    = current_frame + (i * 1000),
														_type    = undefined,
														_time    = 0,
														_timeMax = 0,
														_colTop  = c_white,
														_colSub  = c_dkgray,
														_flash   = false,
														_star    = 0,
														_inst    = instances_matching(obj.OrchidSkill, "skill", _skill);
														
													 // Patience:
													if(GameCont.hud_patience == _skill){
														_inst = call(scr.array_combine, _inst, instances_matching(obj.OrchidSkill, "skill", mut_patience));
													}
													
													 // Get Orchid Mutation With Least Time:
													array_sort(_inst, false);
													with(_inst){
														if(_type == undefined || (type == _type && time > _time)){
															_type    = type;
															_time    = time;
															_timeMax = time_max;
															_colTop  = color1;
															_colSub  = color2;
														}
														if(flash > 0){
															_flash = true;
														}
														if(star_scale > _star){
															_star = star_scale;
														}
													}
													
													 // Flash White:
													if(_flash){
														draw_set_fog(true, c_white, 0, 0);
													}
													
													 // Orchid Mutation Drawing:
													if(_time != 0){
														var	_uvs = sprite_get_uvs(_spr, _img),
															_x1  = max(sprite_get_bbox_left  (_spr),     _uvs[4]                                      ),
															_y1  = max(sprite_get_bbox_top   (_spr),     _uvs[5]                                      ),
															_x2  = min(sprite_get_bbox_right (_spr) + 1, _uvs[4] + (_uvs[6] * sprite_get_width (_spr))),
															_y2  = min(sprite_get_bbox_bottom(_spr) + 1, _uvs[5] + (_uvs[7] * sprite_get_height(_spr))),
															_num = 1 - (_time / _timeMax);
															
														 // Outline:
														if(!_flash){
															draw_set_fog(true, _colSub, 0, 0);
														}
														for(var _dir = 0; _dir < 360; _dir += 90){
															draw_sprite(_spr, _img, _x + dcos(_dir), _y - dsin(_dir));
														}
														
														 // Timer Outline:
														if(!_flash){
															draw_set_fog(true, _colTop, 0, 0);
														}
														for(var _dir = 0; _dir < 360; _dir += 90){
															var	_l = _x1,
																_t = max(_y1, lerp(_y1 - 1, _y2 + 1, _num) + dsin(_dir)),
																_w = _x2 - _l,
																_h = _y2 + 1 - _t;
																
															draw_sprite_part(_spr, _img, _l, _t, _w, _h, _x + _l - sprite_get_xoffset(_spr) + dcos(_dir), _y + _t - sprite_get_yoffset(_spr) - dsin(_dir));
														}
														
														 // Star Flash:
														if(_star > 0){
															var	_scale = max(0, (1.1 + (0.1 * sin(_wave / 15))) * _star),
																_angle = _wave / 10;
																
															draw_sprite_ext(spr.PetOrchidBall, _wave, _x, _y, _scale, _scale, _angle, c_white, 1);
														}
														
														if(!_flash){
															draw_set_fog(false, 0, 0, 0);
														}
													}
													
													 // Skill Icon:
													draw_sprite(_spr, _img, _x, _y);
													
													 // Patience Fix:
													if(GameCont.hud_patience == _skill){
														draw_sprite(sprPatienceIconHUD, 0, _x, _y);
													}
													
													 // Unflash:
													if(_flash){
														draw_set_fog(false, 0, 0, 0);
													}
													
													 // Lighten Up, Bro:
													draw_set_blend_mode(bm_add);
													var _alpha = lerp(0.2, 0, ((1 + cos(_wave / 20)) / 2) * clamp(1 - _star, 0, 1));
													draw_sprite_ext(_spr, _img, _x, _y, 1, 1, 0, c_white, _alpha);
													draw_set_blend_mode(bm_normal);
												}
												
												break;
												
										}
										
										_skillList = call(scr.array_delete, _skillList, _skillIndex);
										_skillType = call(scr.array_delete, _skillType, _skillIndex);
										
										_skillIndex = array_find_index(_skillList, _skill);
									}
									if(!array_length(_skillList)){
										break;
									}
								}
								
								 // Keep it movin:
								_x += _addx;
								if(_x < _minx){
									_x = _sx;
									_y += _addy;
								}
							}
						}
					}
				}
			}
			
			d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
			surface_reset_target();
			
			 // Draw to Screen:
			if(_draw && _visible && instance_exists(Player)){
				for(var i = 0; player_is_active(player_find_local_nonsync(i)); i++){
					if(player_get_show_skills(player_find_local_nonsync(i))){
						if(_fade > 0){
							draw_surface_ext(surf, x, y, 1 / scale, 1 / scale, 0, merge_color(c_white, c_black, min(1, _fade)), 1);
						}
						else call(scr.draw_surface_scale, surf, x, y, 1 / scale);
						break;
					}
				}
			}
		}
		
		 // Player HUD:
		with(call(scr.surface_setup, "HUDMain", _gw, _gh, game_scale_nonsync)){
			x = _vx;
			y = _vy;
			
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			surface_reset_target();
			
			if(instance_exists(Player)){
				for(var _hudIndex = array_length(_hudList) - 1; _hudIndex >= 0; _hudIndex--){
					var	_index  = _hudList[_hudIndex],
						_player = player_find(_index);
						
					if(instance_exists(_player)){
						var	_hudX       = 17 * (_players <= 1),
							_hudY       = 0,
							_hudSide    = (_hudIndex % 2),
							_hudMain    = (_hudIndex == 0),
							_hudVisible = false,
							_hudDraw    = _hudMain;
							
						 // HUD Visibility:
						if(_visible && !instance_exists(PopoScene) && (_hudIndex < 2 || !instance_exists(LevCont))){
							for(var i = 0; player_is_active(player_find_local_nonsync(i)); i++){
								if(player_get_show_hud(_index, player_find_local_nonsync(i))){
									_hudVisible = true;
									_hudDraw    = true;
									break;
								}
							}
						}
						
						 // draw_set_projection(2) doesn't work on surfaces?
						switch(_hudIndex){
							case 1 : _hudX += 227;               break;
							case 2 :               _hudY += 193; break;
							case 3 : _hudX += 227; _hudY += 193; break;
						}
						
						surface_set_target(surf);
						draw_clear_alpha(c_black, 0);
						d3d_set_projection_ortho(-_hudX, -_hudY, w, h, 0);
						
						with(other) with(_player){
							 // Red Ammo:
							if("red_ammo" in self){
								if(_hudDraw){
									for(var i = 0; i < 2; i++){
										var	_wep  = ((i == 0) ? wep : bwep),
											_cost = (
												(is_string(_wep) || is_object(_wep))
												? call(scr.weapon_get, "red", _wep)
												: 0
											);
											
										if(_cost > 0){
											var	_gold = (weapon_get_gold(_wep) != 0),
												_x    = 26 + (44 * i),
												_y    = 20,
												_max  = 4,
												_low  = (
													red_ammo < _cost
													&& (wave % 10) < 5
													&& ((i == 0) ? drawempty : drawemptyb) > 0
												);
												
											 // Main:
											draw_sprite((_gold ? spr.RedAmmoHUDGold : spr.RedAmmoHUD), (red_amax > _max), _x, _y);
											
											 // Ammo Meter:
											if(red_ammo > 0){
												draw_sprite_ext(spr.RedAmmoHUDFill, 0, _x + 2, _y, red_ammo, 1, 0, c_white, 1);
											}
											
											 // Charge Meter:
											if(
												is_object(_wep)
												&& "chrg"     in _wep
												&& "chrg_num" in _wep
												&& "chrg_max" in _wep
												&& (_wep.chrg_num > 3 || _wep.chrg_num >= _wep.chrg_max)
											){
												draw_sprite_ext(
													spr.RedAmmoHUDFill,
													((_wep.chrg_num < _wep.chrg_max) ? 1 : (current_frame / 12)),
													_x + 2,
													_y,
													(_wep.chrg_num / _wep.chrg_max) * max(red_ammo, red_amax),
													1,
													0,
													c_white,
													1
												);
											}
											
											 // Ammo Charges:
											for(var j = 0; j < red_ammo; j++){
												draw_sprite(spr.RedAmmoHUDAmmo, j / _max, _x + 4 + (4 * (j % _max)), _y + 4);
											}
											
											 // Cost Indicator:
											draw_sprite((_gold ? spr.RedAmmoHUDCostGold : spr.RedAmmoHUDCost), _low, _x + 4 + (4 * (_cost % _max)), _y + 4);
										}
									}
								}
							}
							
							 // Parrot:
							if(race == "parrot"){
								/*
								 // Expand HUD:
								var _max = ceil(feather_ammo_max / feather_num);
								if(array_length(feather_ammo_hud) != _max){
									feather_ammo_hud = array_create(_max);
									for(var i = 0; i < _max; i++){
										feather_ammo_hud[i] = [0, 0];
									}
								}
								*/
								
								/*
								 // Flash:
								if(feather_ammo < feather_ammo_max) feather_ammo_hud_flash = 0;
								else feather_ammo_hud_flash += current_time_scale;
								*/
								
								 // Draw:
								if(_hudDraw){
									 // Ultra B:
									if(ntte_charm_flock_hud > 0){
										var	_HPCur      = max(0, my_health),
											_HPMax      = max(0, maxhealth),
											_HPLst      = max(0, lsthealth),
											_HPCurCharm = max(0, ntte_charm_flock_hud_hp),
											_HPMaxCharm = max(0, ntte_charm_flock_hud_hp_max),
											_HPLstCharm = max(0, ntte_charm_flock_hud_hp_lst),
											_HPCol      = player_get_color(index),
											_HPColCharm = make_color_hsv(color_get_hue(_HPCol), min(255, color_get_saturation(_HPCol) * 1.5), color_get_value(_HPCol) * 2/3),
											_w          = 83,
											_h          = 7,
											_x          = 5,
											_y          = 7,
											_HPw        = floor(_w * 0.35 * ntte_charm_flock_hud);
											
										draw_set_halign(fa_center);
										draw_set_valign(fa_middle);
										
										 // Main BG:
										draw_set_color(c_black);
										draw_rectangle(_x, _y, _x + _w, _y + _h, false);
											
										/// Charmed HP:
											var	_x1 = _x,
												_x2 = _x + _HPw - 1;
												
											if(_x1 < _x2){
												 // lsthealth Filling:
												if(_HPLstCharm > _HPCurCharm){
													draw_set_color(merge_color(
														_HPColCharm,
														make_color_rgb(21, 27, 42),
														2/3
													));
													draw_rectangle(_x1, _y, lerp(_x1, _x2, clamp(_HPLstCharm / _HPMaxCharm, 0, 1)), _y + _h, false);
												}
												
												 // my_health Filling:
												if(_HPCurCharm > 0 && _HPMaxCharm > 0){
													draw_set_color(
														(_HPLstCharm != _HPCurCharm)
														? c_white
														: _HPColCharm
													);
													draw_rectangle(_x1, _y, lerp(_x1, _x2, clamp(_HPCurCharm / _HPMaxCharm, 0, 1)), _y + _h, false);
												}
												
												 // Text:
												var _HPText = `+${_HPCurCharm}`;
												draw_set_font(fntM);
												if(string_width(_HPText) >= _x2 - _x1){
													draw_set_font(fntSmall);
												}
												draw_text_nt(
													clamp(ceil(lerp(_x1, _x2, 0.5)), _x + floor(string_width(_HPText) / 2) + 1, _x + _w - ceil(string_width(_HPText) / 2) + 1),
													_y + 1 + floor(_h / 2),
													_HPText
												);
											}
											
										/// Normal HP:
											var	_x1 = _x + _HPw + (1 * ntte_charm_flock_hud),
												_x2 = _x + _w;
												
											if(_x1 < _x2){
												 // BG:
												draw_set_color(c_black);
												draw_rectangle(_x1, _y, _x2, _y + _h, false);
												
												 // lsthealth Filling: (Color is like 95% accurate, I did a lot of trial and error)
												if(_HPLst > _HPCur){
													draw_set_color(merge_color(
														_HPCol,
														make_color_rgb(21, 27, 42),
														2/3
													));
													draw_rectangle(_x1, _y, lerp(_x1, _x2, clamp(_HPLst / _HPMax, 0, 1)), _y + _h, false);
												}
												
												 // my_health Filling:
												if(_HPCur > 0 && _HPMax > 0){
													draw_set_color(
														(((sprite_index == spr_hurt && image_index < 1 && !instance_exists(Portal)) || _HPLst < _HPCur) && !instance_exists(GenCont) && !instance_exists(LevCont) && !instance_exists(PlayerSit))
														? c_white
														: _HPCol
													);
													draw_rectangle(_x1, _y, lerp(_x1, _x2, clamp(_HPCur / _HPMax, 0, 1)), _y + _h, false);
												}
												
												 // Text:
												if(_HPLst >= _HPCur || sin(wave) > 0){
													var _HPText = `${_HPCur}/${_HPMax}`;
													draw_set_font(fntM);
													if(string_width(_HPText) >= _x2 - _x1){
														draw_set_font(fntSmall);
													}
													draw_text_nt(
														ceil(lerp(_x1, _x2, 0.5)) + round(4 * (1 - ntte_charm_flock_hud)),
														_y + 1 + floor(_h / 2),
														_HPText
													);
												}
											}
											
										 // Separator:
										draw_set_color(c_white);
										draw_line_width(_x + _HPw, _y - 2, _x + _HPw, _y + _h, 1);
									}
									
									 // Parrot Feathers:
									var	_x           = (_hudSide ? -5 : 99),
										_y           = 11,
										_spr         = call(scr.race_get_sprite, race, bskin, sprRogueAmmoHUD),
										_featherInst = (array_length(obj.ParrotFeather) ? instances_matching(instances_matching(obj.ParrotFeather, "index", index), "creator", self, noone) : []),
										_hudActive   = ((button_check(index, "spec") || usespec > 0) && canspec && player_active),
										_hudFill     = array_create(ceil(feather_ammo_max / feather_num), 0),
										_hudTarget   = [];
										
									with(_featherInst){
										var _pos = array_find_index(_hudTarget, target);
										if(_pos < 0){
											_pos = array_length(_hudTarget);
											
											 // Idle Feather:
											if(target == other){
												while(_pos < array_length(_hudFill) && _hudFill[_pos] >= other.feather_num){
													_pos++;
												}
											}
											
											 // Active Feather:
											else if(_pos < array_length(_hudFill)){
												array_push(_hudTarget, target);
												
												 // Shift Right:
												for(var i = array_length(_hudFill) - 1; i > _pos; i--){
													_hudFill[i] = _hudFill[i - 1];
												}
												_hudFill[_pos] = 0;
											}
										}
										if(_pos < array_length(_hudFill)){
											_hudFill[_pos]++;
										}
									}
									
									for(var i = 0; i < array_length(_hudFill); i++){
										var	_ammo = clamp(((feather_ammo + array_length(_featherInst)) / feather_num) - i, 0, 1),
											_fill = clamp(_hudFill[i] / feather_num, 0, 1),
											_xsc  = (_hudSide ? -1 : 1),
											_ysc  = 1,
											_dx   = _x + (5 * i * _xsc),
											_dy   = _y;
											
										 // Extend Shootable Feathers:
										if((_ammo > 0 && (i < 1 || ultra_get(race, 1) > 0)) || _fill > 0){
											_dx -= _xsc;
											if((!_hudActive || _fill <= 0) && _ammo > _fill){
												_fill = _ammo;
												_dy++;
											}
										}
										
										 // Main HUD:
										draw_sprite_ext(_spr, 0, _dx, _dy, _xsc, _ysc, 0, c_white, 1);
										
										 // Total Feathers Filling:
										if(_ammo > _fill){
											var	_img = lerp(1, sprite_get_number(_spr) - 1, clamp(_ammo, 0, 1)),
												_col = make_color_hsv(178, 1/3 * 255, 0.6 * 255);
												
											draw_sprite_ext(_spr, _img, _dx, _dy, _xsc, _ysc, 0, _col, 1);
										}
										
										 // Active Feathers Filling:
										if(_fill > 0){
											var _img = lerp(1, sprite_get_number(_spr) - 1, clamp(_fill, 0, 1));
											draw_sprite_ext(_spr, _img, _dx, _dy, _xsc, _ysc, 0, c_white, 1);
										}
									}
								}
								
								 // LOW HP:
								if(_players <= 1){
									if(drawlowhp > 0 && sin(wave) > 0){
										if(my_health <= 4 && my_health != maxhealth){
											if(_pause){
												drawlowhp = 0;
											}
											else{
												draw_set_font(fntM);
												draw_set_halign(fa_left);
												draw_set_valign(fa_top);
												draw_text_nt(93, 7, `@(color:${c_red})LOW HP`);
											}
										}
									}
								}
							}
							
							 // Bonus Ammo:
							if(
								"bonus_ammo"     in self &&
								"bonus_ammo_max" in self &&
								bonus_ammo > 0
							){
								var	_tick  = (("bonus_ammo_tick"  in self) ? bonus_ammo_tick  : 0),
									_flash = (("bonus_ammo_flash" in self) ? bonus_ammo_flash : 0),
									_spr   = ((_tick == 0) ? spr.BonusAmmoHUDFill : spr.BonusAmmoHUDFillDrain);
									
								 // Draw:
								if(_hudDraw){
									var	_num = ceil(bonus_ammo / 60) - 1,
										_img = _flash,
										_x   = 5 - (17 * (_players <= 1)),
										_y   = 35,
										_w   = sprite_get_width(_spr) * clamp(bonus_ammo / bonus_ammo_max, 0, 1),
										_h   = sprite_get_height(_spr);
										
									if(bonus_ammo > 2 * _tick){
										 // Back:
										draw_sprite(spr.BonusAmmoHUD, 0, _x, _y);
										draw_sprite_ext(_spr, 0, _x, _y, 1, 1, 0, make_color_hsv(wave % 256, 80, 80), 1);
										
										 // Filling:
										draw_sprite_part(_spr, _img, 0, 0, _w, _h, _x, _y);
										
										 // Text:
										draw_set_font(fntSmall);
										draw_set_halign(fa_center);
										draw_set_valign(fa_middle);
										draw_text_nt(
											_x + (sprite_get_width(_spr)  / 2),
											_y + (sprite_get_height(_spr) / 2),
											`@4(${spr.BonusHUDText})` + ((_num > 0) ? `+${_num}` : "")
										);
									}
									
									 // Flash Out:
									else{
										draw_set_fog(true, c_white, 0, 0);
										draw_sprite(spr.BonusAmmoHUD, 0, _x, _y);
										draw_set_fog(false, 0, 0, 0);
									}
								}
								
								 // Animate:
								if(_flash > 0){
									bonus_ammo_flash += 0.4 * current_time_scale;
									if(bonus_ammo_flash >= sprite_get_number(_spr)){
										bonus_ammo_flash = 0;
									}
								}
							}
							
							 // Bonus HP:
							if(
								"bonus_health"     in self &&
								"bonus_health_max" in self &&
								bonus_health > 0
							){
								var	_tick  = (("bonus_health_tick"  in self) ? bonus_health_tick  : 0),
									_flash = (("bonus_health_flash" in self) ? bonus_health_flash : 0)
									_spr   = ((_tick == 0) ? spr.BonusHealthHUDFill : spr.BonusHealthHUDFillDrain);
								
								 // Draw:
								if(_hudDraw){
									var	_num = ceil(bonus_health / 30) - 1,
										_img = ((maxhealth > 0 && lsthealth < my_health && !instance_exists(GenCont) && !instance_exists(LevCont)) ? 1 : _flash),
										_x   = 5,
										_y   = 7,
										_w   = sprite_get_width(_spr) * clamp(bonus_health / bonus_health_max, 0, 1),
										_h   = sprite_get_height(_spr);
										
									 // Back:
									draw_sprite(sprHealthBar, 0, _x - 2, _y - 3);
									draw_sprite_ext(_spr, 0, _x, _y, 1, 1, 0, make_color_hsv(wave % 256, 80, 80), 1);
									
									 // Filling:
									draw_sprite_part(_spr, _img, 0, 0, _w, _h, _x, _y);
									
									 // Text:
									draw_set_font(fntSmall);
									draw_set_halign(fa_center);
									draw_set_valign(fa_middle);
									draw_text_nt(
										_x + (sprite_get_width(_spr)  / 2) + 1,
										_y + (sprite_get_height(_spr) / 2),
										`@4(${spr.BonusHUDText})` + ((_num > 0) ? `+${_num}` : "")
									);
								}
								
								 // Animate:
								if(_flash > 0){
									bonus_health_flash += 0.4 * current_time_scale;
									if(bonus_health_flash >= sprite_get_number(_spr)){
										bonus_health_flash = 0;
									}
								}
							}
						}
						
						d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
						surface_reset_target();
						
						 // Draw to Screen:
						if(_hudVisible){
							if(_fade > 0){
								draw_surface_ext(surf, x, y, 1 / scale, 1 / scale, 0, merge_color(c_white, c_black, min(1, _fade)), 1);
							}
							else call(scr.draw_surface_scale, surf, x, y, 1 / scale);
						}
					}
				}
			}
		}
		
		 // Indicator HUD:
		if(_visible && instance_exists(Player)){
			 // Coast Indicator:
			if(instance_exists(Portal)){
				var _inst = instances_matching(instances_matching_ge(Portal, "endgame", 100), "coast_portal", true);
				if(array_length(_inst)){
					with(_inst){
						if(point_seen(x, y, player_find_local_nonsync())){
							var	_size = 4,
								_x = x,
								_y = y;
								
							 // Drawn to Player:
							with(instance_nearest(_x, _y, Player)){
								draw_set_alpha((point_distance(x, y, _x, _y) - 12) / 80);
								
								var	_l = min(point_distance(_x, _y, x, y), 16 * min(1, 28 / point_distance(_x, _y, x, y))),
									_d = point_direction(_x, _y, x, y);
									
								_x += lengthdir_x(_l, _d);
								_y += lengthdir_y(_l, _d);
							}
							
							 // Draw:
							_y += sin(current_frame / 8);
							
							var	_x1 = _x - (_size / 2),
								_y1 = _y - (_size / 2),
								_x2 = _x1 + _size,
								_y2 = _y1 + _size;
								
							draw_set_color(c_black);
							draw_rectangle(_x1, _y1 + 1, _x2, _y2 - 1, false);
							draw_rectangle(_x1 + 1, _y1, _x2 - 1, _y2, false);
							draw_set_color(make_color_rgb(150, 100, 200));
							draw_rectangle(_x1 + 1, _y1 + 1, _x1 + 1 + max(0, _size - 3), _y1 + 1 + max(0, _size - 3), false);
						}
					}
				}
				draw_set_alpha(1);
			}
			
			 // Charm Indicator:
			if(instance_exists(enemy)){
				var _inst = instances_matching(instances_matching_ne(enemy, "ntte_charm", null), "visible", true);
				if(array_length(_inst)){
					with(_inst){
						if(ntte_charm.charmed && ntte_charm.feather){
							var _index = ntte_charm.index;
							if(!point_seen(x, y, _index) && player_is_local_nonsync(_index)){
								with(player_find(_index)){
									var	_spr = call(scr.race_get_sprite, race, bskin, sprRogueAmmoHUD),
										_x1  = sprite_get_xoffset(_spr) - sprite_get_bbox_left(_spr),
										_y1  = sprite_get_yoffset(_spr) - sprite_get_bbox_top(_spr),
										_x2  = _x1 - sprite_get_bbox_right(_spr)  + _gw,
										_y2  = _y1 - sprite_get_bbox_bottom(_spr) + _gh,
										_x   = _vx + clamp(other.x - _vx, _x1 + 1, _x2 - 1);
										_y   = _vy + clamp(other.y - _vy, _y1 + 1, _y2 - 2);
										
									draw_sprite(_spr, 0, _x, _y);
									draw_sprite(call(scr.race_get_sprite, race, bskin, sprChickenFeather), 0, _x, _y);
								}
							}
						}
					}
				}
			}
			
			 // Pet Indicator:
			if(array_length(obj.Pet)){
				with(instances_matching_ne(obj.Pet, "id")){
					var _draw = false;
					
					 // Death Conditions:
					if(instance_exists(revive)){
						if(instance_exists(leader)){
							_draw = true;
							with(revive){
								with(prompt){
									if(instance_exists(nearwep) && array_length(instances_matching(Player, "nearwep", nearwep))){
										_draw = false;
									}
								}
							}
						}
					}
					
					 // Normal Conditions:
					else if(visible && "index" in leader && player_is_local_nonsync(leader.index) && !point_seen(x, y, leader.index)){
						_draw = true;
					}
					
					if(_draw){
						var _spr = spr_icon;
						if(sprite_exists(_spr)){
							var	_x   = x,
								_y   = y,
								_img = 0.4 * current_frame;
								
							 // Death Pointer:
							if(instance_exists(revive)){
								_y -= 20 + sin(wave / 10);
								draw_sprite(spr.PetArrow, _img, _x, _y + (sprite_get_height(_spr) - sprite_get_yoffset(_spr)));
							}
							
							 // Icon:
							var	_x1 = sprite_get_xoffset(_spr),
								_y1 = sprite_get_yoffset(_spr),
								_x2 = _x1 - sprite_get_width(_spr)  + _gw,
								_y2 = _y1 - sprite_get_height(_spr) + _gh;
								
							_x = _vx + clamp(_x - _vx, _x1 + 1, _x2 - 1);
							_y = _vy + clamp(_y - _vy, _y1 + 1, _y2 - 1);
							
							draw_sprite(_spr, _img, _x, _y);
							
							 // Death Indicating:
							if(instance_exists(revive)){
								var	_flashLength = 15,
									_flashDelay  = 10,
									_flash       = (current_frame % (_flashLength + _flashDelay));
									
								if(_flash < _flashLength){
									draw_set_blend_mode(bm_add);
									draw_sprite_ext(_spr, _img, clamp(_x, _x1, _x2), clamp(_y, _y1, _y2), 1, 1, 0, c_white, 1 - (_flash / _flashLength));
									draw_set_blend_mode(bm_normal);
								}
							}
						}
					}
				}
			}
		}
		
		draw_set_font(fntM);
		draw_set_halign(fa_center);
		draw_set_valign(fa_top);
		
		if(lag) trace_time(script[2]);
	}
	
#define ntte_map(_mapX, _mapY, _mapIndex)
	/*
		For drawing NTTE's custom map stuff, currently only pet map icons
	*/
	
	var _canDraw = false;
	
	if("ntte_pet_icon" in GameCont){
		with(GameCont.ntte_pet_icon){
			if(self != undefined){
				_canDraw = true;
			}
			break;
		}
	}
	
	if(_canDraw){
		var _lag = (lag && !instance_exists(PauseButton) && !instance_exists(BackMainMenu));
		
		if(_lag) trace_time();
		
		_mapIndex = (
			(_mapIndex == undefined)
			? GameCont.waypoints
			: clamp(_mapIndex, 0, GameCont.waypoints)
		);
		
		var _mapPos = mapdata_get(_mapIndex);
		
		if(
			_mapIndex == 0
			|| (is_real(_mapPos.area) && _mapPos.area >= 0)
			|| (is_string(_mapPos.area) && mod_exists("area", _mapPos.area))
		){
			 // Determine Max Players:
			var _playerMax = 0;
			for(var i = 0; i < maxp; i++){
				if(player_is_active(i)){
					_playerMax = i + 1;
				}
			}
			
			 // Draw:
			for(var i = 0; i < _playerMax; i++){
				var	_x       = view_xview_nonsync + (game_width  / 2) + _mapX + _mapPos.x,
					_y       = view_yview_nonsync + (game_height / 2) + _mapY + _mapPos.y,
					_iconAng = 30,
					_iconDir = 0,
					_iconDis = 10;
					
				 // Co-op Offset:
				if(_playerMax > 1){
					var	_l = 2 * _playerMax,
						_d = 90 - ((360 / _playerMax) * i);
						
					if(_playerMax == 2){
						_d += 45;
					}
					
					_x += lengthdir_x(_l, _d);
					_y += lengthdir_y(_l, _d);
					
					_iconAng = _d;
				}
				
				 // Pet Icons:
				var _iconList = GameCont.ntte_pet_icon[i];
				if(_iconList != undefined){
					for(var _iconNum = 0; _iconNum < array_length(_iconList); _iconNum++){
						var	_icon    = _iconList[_iconNum],
							_iconSpr = call(scr.pet_get_sprite, _icon[0], _icon[1], _icon[2], _icon[3], "icon");
							
						if(sprite_exists(_iconSpr)){
							draw_sprite_ext(
								_iconSpr,
								0.4 * current_frame,
								_x + floor(lengthdir_x(_iconDis, _iconAng + _iconDir)),
								_y + floor(lengthdir_y(_iconDis, _iconAng + _iconDir)),
								1,
								1,
								0,
								(instance_exists(BackMainMenu) ? merge_color(c_white, c_black, 0.9) : c_white),
								1
							);
						}
						
						 // Next:
						_iconDir += 60 / (1 + floor(_iconDir / 360));
						if((_iconDir % 360) == 0){
							_iconDis += 8;
						}
					}
				}
			}
		}
		
		if(_lag) trace_time(script[2]);
	}
	
#define ntte_map_pause
	if(array_length(instances_matching([PauseButton, BackMainMenu, OptionMenuButton, AudioMenuButton, VisualsMenuButton, GameMenuButton, ControlMenuButton], "", null))){
		ntte_map(-70, 7, null);
	}
	else instance_destroy();
	
#define ntte_music()
	/*
		Overrides MusCont's alarms for playing area-specific music and ambience
	*/
	
	var _area = GameCont.area;
	
	with(MusCont){
		var	_mus = null,
			_amb = null;
			
		 // Boss Music:
		if(alarm_get(2) > 0 && alarm_get(2) <= ceil(current_time_scale)){
			 // Make Music Restart Next Sub-Area:
			try{
				if(!null){
					var _lastArea = GameCont.area;
					GameCont.area = -1;
					with(self){
						event_perform(ev_alarm, 11);
					}
					GameCont.area = _lastArea;
				}
			}
			catch(_error){}
			
			 // Play Custom Music:
			if(array_length(instances_matching_ne(obj.Tesseract, "id"))){
				alarm_set(2, -1);
				_mus = mus.Tesseract;
			}
			else if(array_find_index(ntte.mods.area, _area) >= 0){
				if(mod_script_exists("area", _area, "area_music_boss")){
					alarm_set(2, -1);
					_mus = mod_script_call_self("area", _area, "area_music_boss");
				}
			}
		}
		
		 // Music / Ambience:
		if(alarm_get(11) > 0 && alarm_get(11) <= ceil(current_time_scale)){
			if(array_find_index(ntte.mods.area, _area) >= 0){
				if(mod_script_exists("area", _area, "area_music") || mod_script_exists("area", _area, "area_ambient")){
					alarm_set(11, -1);
					
					 // Update MusCont:
					if("ntte_music_area" not in GameCont || _area != GameCont.ntte_music_area){
						with(self){
							event_perform(ev_alarm, 11);
						}
					}
					
					_mus = mod_script_call_self("area", _area, "area_music");
					_amb = mod_script_call_self("area", _area, "area_ambient");
				}
			}
			GameCont.ntte_music_area = _area;
		}
		
		 // Play:
		if(is_real(_mus)){
			if(sound_play_music(_mus)){
				var _snd = sound_play_pitchvol(0, 0, 0);
				sound_stop(_snd);
				GameCont.ntte_music_index = _snd - 1;
			}
		}
		if(is_real(_amb)){
			if(sound_play_ambient(_amb)){
				var _snd = sound_play_pitchvol(0, 0, 0);
				sound_stop(_snd);
				GameCont.ntte_ambient_index = _snd - 1;
			}
		}
	}
	
#define footprint_give(_time, _color, _alpha)
	/*
		Called from a Player to give them footprints for a number of frames, if they don't already have footprints that last longer
		Returns 'true' if the footprints were set, 'false' otherwise
		
		Args:
			time  - How many frames the Player will have footprints
			color - The footprint color
			alpha - The footprint alpha
	*/
	
	if("ntte_foot_time" not in self || ntte_foot_time < _time){
		ntte_foot_time  = _time;
		ntte_foot_color = _color;
		ntte_foot_alpha = _alpha;
		
		return true;
	}
	
	return false;
	
#define PalaceStairs_begin_step
	 // Walking Up Stairs:
	if(place_meeting(x, y, Player)){
		var _inst = instances_matching_ne(call(scr.instances_meeting_instance, self, Player), "footkind", 0);
		if(array_length(_inst)){
			with(_inst){
				if(player_active){
					 // Footsteps:
					if(sprite_index == spr_walk && roll == 0){
						if(round(image_index) == footstep + 2 || footextra == true){
							var	_snd = asset_get_index(`sndFoot${place_meeting(x, y, Carpet) ? "Sho" : "Met"}Rock${irandom_range(1, 6)}`),
								_pit = ((vspeed > 0) ? 0.8 : 1) + orandom(0.1),
								_vol = 0.3;
								
							sound_play_pitchvol(_snd, _pit, _vol);
						}
						
						 // Dust Effect:
						if("ntte_stairslow" not in self || ntte_stairslow <= 0){
							with(instance_create(x, y, Dust)){
								sprite_index = sprSmoke;
							}
						}
					}
					
					 // Slow:
					ntte_stairslow = 5;
				}
			}
		}
	}
	
#define CharSelect_draw_new(_inst)
	with(instances_matching(_inst, "visible", true)){
		draw_sprite(sprNew, image_index, view_xview_nonsync + xstart + (alarm1 > 0), view_yview_nonsync + ystart - mouseover);
	}
	instance_destroy();
	
#define CampChar_create(_x, _y, _race)
	_race = race_get_name(_race);
	with(instance_create(_x, _y, CampChar)){
		race = _race;
		num  = 0.1;
		
		 // Visual:
		spr_slct     = call(scr.race_get_sprite, _race, 0, sprFishMenu);
		spr_menu     = call(scr.race_get_sprite, _race, 0, sprFishMenuSelected);
		spr_to       = call(scr.race_get_sprite, _race, 0, sprFishMenuSelect);
		spr_from     = call(scr.race_get_sprite, _race, 0, sprFishMenuDeselect);
		sprite_index = spr_slct;
		
		 // Space Out:
		var _tries = 1000;
		while(_tries-- > 0){
			x = xstart;
			y = ystart;
			move_contact_solid(random(360), random_range(32, 64) + random(random(64)));
			x = round(x);
			y = round(y);
			
			 // Safe:
			if(!collision_circle(x, y, 12, CampChar, true, true) && !place_meeting(x, y, TV)){
				break;
			}
		}
		
		return self;
	}
	
#define chat_message(_message, _index)
	 // The Peas Feature (Peature):
	if(string_upper(_message) == "LEGUME"){
		with(instances_matching(obj.PizzaRubble, "peas", false)){
			peas = true;
			sound_play_hit(sndUncurse, 0);
		}
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