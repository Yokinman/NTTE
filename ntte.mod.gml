#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	lag = false;
	
	 // Mod Lists:
	ntte_area = mod_variable_get("mod", "teassets", "area");
	ntte_race = mod_variable_get("mod", "teassets", "race");
	ntte_crwn = mod_variable_get("mod", "teassets", "crwn");
	ntte_weps = mod_variable_get("mod", "teassets", "weps");
	
	 // List of Mods to Call:
	ntte_call_mods = [];
	
	 // level_start():
	global.level_start = (instance_exists(GenCont) || instance_exists(Menu));
	
	 // Area:
	global.area_update = false;
	global.area_mapdata = [];
	
	 // Music / Ambience:
	global.mus_area = GameCont.area;
	global.mus_current = -1;
	global.amb_current = -1;
	
	 // Pets:
	global.pet_max = 1;
	global.pet_mapicon = array_create(maxp, []);
	global.pet_mapicon_pause = 0;
	global.pet_mapicon_pause_force = 0;
	
	 // For Merged Weapon PopupText Fix:
	global.mergewep_name = [];
	
	 // Kills:
	global.kills_last = GameCont.kills;
	
	 // Vault Flower Rerolled Skill:
	global.hud_reroll = null;
	
	 // Scythe Tippage:
	global.scythe_tip_index = 0;
	global.scythe_tip = ["press @we @sto change modes", "the @rscythe @scan do so much more", "press @we @sto rearrange a few @rbones", "just press @we @salready", "please press @we", "@w@qe"];
	
	 // Crystal Heart Guarantee:
	heart_spawn = {};
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#macro ntte_area global.area
#macro ntte_race global.race
#macro ntte_crwn global.crwn
#macro ntte_weps global.weps

#macro ntte_call_mods global.call_mods

#macro heart_spawn global.heart_spawn

#define game_start
	 // Reset:
	global.pet_max = 1;
	for(var i = 0; i < array_length(global.pet_mapicon); i++){
		global.pet_mapicon[i] = [];
	}
	global.area_mapdata = [];
	global.kills_last = GameCont.kills;
	global.hud_reroll = null;
	global.scythe_tip_index = 0;
	with(instances_matching(CustomObject, "name", "UnlockCont")) instance_destroy();
	
	 // Race Runs Stat:
	for(var i = 0; i < maxp; i++){
		var _race = player_get_race(i);
		if(array_exists(ntte_race, _race)){
			var _stat = "race:" + _race + ":runs";
			stat_set(_stat, stat_get(_stat) + 1);
		}
	}
	
	 // Set Storable NTTE Weapon:
	with(Player){
		var _wep = unlock_get(`loadout:wep:${race}:${save_get(`loadout:wep:${race}`, "")}`);
		if(_wep != wep_none){
			 // Take Ammo:
			var _type = weapon_get_type(wep);
			if(_type != 0){
				ammo[_type] = max(0, ammo[_type] - (typ_ammo[_type] * 3));
			}
			
			 // Set Wep:
			wep = _wep;
			
			 // Give Ammo:
			var _type = weapon_get_type(wep);
			if(_type != 0){
				ammo[_type] += round(typ_ammo[_type] * ((wep_get(wep) == "merge") ? 1.25 : 3));
			}
		}
	}
	
	 // Determine Crystal Heart Area:
	var _num = save_get("heart:spawn", 0);
	if(_num > 0){
		save_set("heart:spawn", _num - 1);
		
		/*
			- Excludes desert
			- Excludes boss levels
		*/
		
		heart_spawn.area    = irandom_range(2, 7);
		heart_spawn.subarea = irandom_range(1, max(1, area_get_subarea(heart_spawn.area) - 1));
		heart_spawn.loops   = 0;
	}
	else heart_spawn = {};
	
#define level_start // game_start but every level
	var	_spawnX     = 10016,
		_spawnY     = 10016,
		_normalArea = (GameCont.hard > 1 && instance_exists(enemy)),
		_topChance  = 1/100,
		_topSpawn   = [];
		
	with(instance_nearest(_spawnX, _spawnY, Player)){
		_spawnX = x;
		_spawnY = y;
	}
	
	 // Top Decal Fix:
	with(TopPot){
		while(place_meeting(x, y, Wall)){
			var _break = true;
			with(instances_meeting(x, y, Wall)){
				if(place_meeting(x, y, PortalClear) && place_meeting(x, y, other)){
					with(other){
						_break = false;
						while(place_meeting(x, y, other)){
							x += lengthdir_x(16, dir);
							y += lengthdir_y(16, dir);
						}
					}
				}
			}
			if(_break) break;
		}
	}
	
	 // Visibilize Pets:
	with(instances_matching(CustomHitme, "name", "Pet")){
		visible = true;
	}
	
	 // Flavor Big Cactus:
	if(chance(1, 3 * area_get_subarea(GameCont.area))){
		with(instance_random([Cactus, NightCactus])){
			obj_create(x, y, "BigCactus");
			instance_delete(id);
		}
	}
	
	 // Baby Spiders:
	if(instance_exists(Spider) || instance_exists(InvSpider)){
		with(instances_matching([CrystalProp, InvCrystal], "", null)){
			if(place_meeting(x, y, Floor) && !place_meeting(x, y, Wall)){
				repeat(irandom_range(1, 3)){
					obj_create(x, y, "Spiderling");
				}
			}
		}
	}
	
	/*
	 // Cool Vault Statues:
	with(ProtoStatue) with(floor_get(x, y)){
		var o = 32;
		for(var h = -1; h <= 1; h++) for(var v = -1; v <= 1; v++){
			with(floor_get(x + (h * o), y + (v * o))){
				sprite_index = spr.VaultFlowerFloor;
				image_index	 = ((h + 1) * 3) + (v + 1);
			}
		}
	}
	*/
	
	 // Backpack Setpieces:
	var	_canBackpack = chance(1 + (2 * skill_get(mut_last_wish)), 12),
		_forceSpawn = (GameCont.area == area_campfire);
		
	if(GameCont.hard > 4 && ((_canBackpack && _normalArea && GameCont.area != area_hq) || _forceSpawn)){
		with(array_shuffle(FloorNormal)){
			if(distance_to_object(Player) > 80){
				if(!place_meeting(x, y, hitme) && !place_meeting(x, y, chestprop)){
					 // Backpack:
					chest_create(bbox_center_x + orandom(4), bbox_center_y - 6, "Backpack", true);
					instance_create(bbox_center_x, bbox_center_y, PortalClear);
					
					 // Flavor Corpse:
					if(GameCont.area != area_campfire){
						obj_create(bbox_center_x + orandom(8), bbox_center_y + irandom(8), "Backpacker");
					}
					
					break;
				}
			}
		}
	}
	
	 // Crystal Hearts:
	if(_normalArea){
		var	_heartNum = (chance(GameCont.hard, 400 + (5 * GameCont.hard)) && GameCont.hard != 106),
			_chaosNum = ((GameCont.subarea == 1) + chance(1, 5)) * (crown_current == "red");
			
		 // Guarantee Unnecessary:
		if(_heartNum > 0){
			heart_spawn = {};
		}
		
		 // Guaranteed Spawn:
		if(lq_size(heart_spawn) > 0){
			if(
				lq_defget(heart_spawn, "area",    GameCont.area)    == GameCont.area    &&
				lq_defget(heart_spawn, "subarea", GameCont.subarea) == GameCont.subarea &&
				lq_defget(heart_spawn, "loops",   GameCont.loops)   == GameCont.loops
			){
				_heartNum++;
				
				 // No Repeat Visits:
				heart_spawn = {};
			}
		}
		
		 // Spawn:
		if(_heartNum > 0 || _chaosNum > 0){
			 // Find Spawnable Tiles:
			var _spawnFloor = [];
			with(instances_matching_ne(FloorNormal, "name", "WallFake")){
				if(instance_exists(Player) && distance_to_object(Player) > 128){
					if(!instance_exists(Wall) || distance_to_object(Wall) < 34){
						array_push(_spawnFloor, id);
					}
				}
			}
			
			 // Spawn Hearts:
			if(array_length(_spawnFloor) > 0){
				 // Visited Warp Zone, Only Chaos Hearts:
				if(_heartNum > 0 && variable_instance_get(GameCont, "ntte_visits_red", 0) > GameCont.loops){
					_chaosNum += _heartNum;
					_heartNum = 0;
				}
				
				 // Create:
				while((_heartNum + _chaosNum) > 0){
					with(instance_random(_spawnFloor)){
						var _type = ((_chaosNum > 0) ? "ChaosHeart" : "CrystalHeart");
						with(obj_create(bbox_center_x, bbox_center_y + 2, _type)){
							with(instance_create(x, y, PortalClear)){
								mask_index = other.mask_index;
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
	if(_normalArea && (chance(GameCont.nochest - 4, 4) || chance(1, 100))){
		with(instance_furthest(_spawnX, _spawnY, WeaponChest)){
			with(obj_create(x, y, "PetWeaponBecome")){
				curse = max(curse, other.curse);
				
				 // Spawn Room:
				with(floor_room_create(x, y, 1, 1, "", random(360), 0, 0)){
					other.x = x;
					other.y = y;
					switch(other.type){
						case 0: // MELEE
							floor_fill(x, y, 3, 3, "");
							break;
							
						case 1: // BULLET
							floor_fill(x, y, 5, 5, "round");
							break;
							
						case 2: // SHELL
							floor_fill(x, y, 3, 3, "round");
							break;
							
						case 3: // BOLT
							floor_fill(x, y, 3, 3, "round");
							floor_fill(x, y, 5, 5, "ring");
							break;
							
						case 4: // EXPLOSIVE
							floor_fill(x, y, 5, 1, "");
							floor_fill(x, y, 1, 5, "");
							break;
							
						case 5: // ENERGY
							floor_fill(x, y, 5, 5, "ring");
							break;
					}
				}
				
				 // Clear:
				instance_create(x, y, PortalClear);
				with(instances_matching(instances_matching(PortalClear, "xstart", xstart), "ystart", ystart)){
					instance_destroy();
				}
			}
			instance_delete(id);
		}
	}
	
	 // Area-Specific:
	switch(GameCont.area){
		case area_campfire: /// CAMPFIRE
			
			 // Unlock Custom Crowns:
			if(array_exists(ntte_crwn, crown_current)){
				unlock_set(`loadout:crown:${crown_current}`, true);
			}
			
			 // Less Bones:
			with(BonePileNight) if(chance(1, 3)){
				instance_delete(id);
			}
			
			 // Guarantee Crystal Heart Spawn Next Run:
			if(GameCont.loops > 0){
				var _num = save_get("heart:spawn", 0);
				if(_num <= 0){
					save_set("heart:spawn", _num + 1);
				}
			}
			
			 // Guitar Grounded:
			with(instances_matching(WepPickup, "wep", wep_guitar)){
				with(obj_create(x, y, "WepPickupGrounded")){
					with(target){
						wep = wep_guitar;
					}
				}
				instance_delete(id);
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
						array_push(_propFloor, id);
						_propIndex++;
					}
				}
			}
			array_shuffle(_propFloor);
			
			 // Sharky Skull:
			with(BigSkull) instance_delete(id);
			if(GameCont.subarea == 3){
				var	_sx = _spawnX,
					_sy = _spawnY;
					
				if(_propIndex >= 0) with(_propFloor[_propIndex--]){
					_sx = bbox_center_x;
					_sy = bbox_center_y;
				}
				
				obj_create(_sx, _sy, "CoastBossBecome");
			}
			
			 // Consistent Crab Skeletons:
			if(!instance_exists(BonePile) && !teevent_get_active("ScorpionCity")){
				if(_propIndex >= 0) with(_propFloor[_propIndex--]){
					obj_create(bbox_center_x, bbox_center_y, BonePile);
				}
			}
			
			 // Scorpion Rocks:
			if(chance(2, 5) && GameCont.subarea < area_get_subarea(GameCont.area)){
				if(_propIndex >= 0) with(_propFloor[_propIndex--]){
					obj_create(bbox_center_x, bbox_center_y - 2, "ScorpionRock");
				}
			}
			
			 // Big Maggot Nests:
			if(!teevent_get_active("MaggotPark")){
				with(MaggotSpawn) if(chance(1 + GameCont.loops, 12)){
					obj_create(x, y, "BigMaggotSpawn");
					instance_delete(id);
				}
			}
			
			break;
			
		case area_sewers: /// SEWERS
			
			 // Cats:
			with(ToxicBarrel){
				repeat(irandom_range(2, 3)){
					obj_create(x, y, "Cat");
				}
			}
			
			 // Frog Nest:
			with(FrogQueen){
				var	_total = 0,
					_queen = self;
					
				with(array_shuffle(floor_fill(x, y, 5, 5, "round"))){
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
			}
			
			 // Loop Spawns:
			if(GameCont.loops > 0){
				 // Traffic Crabs:
				with(Ratking) if(chance(1, 3) || floor_get(x, y).styleb){
					obj_create(x, y, "TrafficCrab");
					instance_delete(id);
				}
			}
			
			break;
			
		case area_scrapyards: /// SCRAPYARDS
			
			 // Sawblade Traps:
			if(GameCont.subarea != 3){
				with(enemy) if(chance(1, 40) && place_meeting(x, y, Floor)){
					with(instance_nearest_bbox(x, y, FloorNormal)){
						obj_create(bbox_center_x, bbox_center_y, "SawTrap");
					}
				}
			}
			
			 // Venuz Landing Pad:
			with(CarVenus){
				 // Fix Overlapping Chests:
				if(place_meeting(x, y, chestprop) || place_meeting(x, y, prop)){
					floor_set_align(null, null, 32, 32);
					with(floor_room_create(x, y, 1, 1, "", random(360), 0, 0)){
						other.x = x;
						other.y = y;
					}
					floor_reset_align();
				}
				
				 // Fill:
				with(instance_nearest_bbox(x, y, instances_matching_lt(FloorNormal, "id", id))){
					floor_set_style(styleb, area);
				}
				floor_fill(x, y, 3, 3, "");
				floor_reset_style();
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
					
				floor_set_align(null, null, 32, 32);
				
				with(floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
					 // Fill Some Corners:
					repeat(3){
						var	_x = choose(x1, x2 - 32),
							_y = choose(y1, y2 - 32);
							
						if(array_length(instances_at(_x + 16, _y + 16, FloorNormal)) <= 0){
							floor_set(_x, _y, true);
						}
					}
					
					 // Sludge:
					with(obj_create(x, y, "SludgePool")){
						num = 3;
					}
				}
				
				floor_reset_align();
			}
			
			 // Raven Spectators:
			with(Wall) if(chance(1, 5)){
				if(!place_meeting(x, y, PortalClear) && place_meeting(x, y, Floor)){
					top_create(bbox_center_x + orandom(2), y - 8 + orandom(2), "TopRaven", 0, 0);
				}
			}
			
			 // Loop Spawns:
			if(GameCont.loops > 0){
				 // Pelicans:
				with(Raven) if(chance(4 - GameCont.subarea, 12)){
					obj_create(x, y, "Pelican");
					instance_delete(id);
				}
			}
			
			break;
			
		case area_caves: /// CRYSTAL CAVES
			
			 // Spawn Mortars:
			with(instances_matching(LaserCrystal, "mortar_check", null)){
				mortar_check = true;
				if(chance(1, 4)){
					obj_create(x, y, "Mortar");
					instance_delete(self);
				}
			}
			
			 // Baby:
			with(instances_matching(Spider, "spiderling_check", null)){
				spiderling_check = true;
				if(chance(1, 4)){
					obj_create(x, y, "Spiderling");
					instance_delete(id);
				}
			}
			
			 // Preloop Lightning Crystals:
			if(GameCont.loops <= 0){
				with(LaserCrystal) if(chance(1, 40 * ((crown_current == crwn_blood) ? 0.7 : 1))){
					instance_create(x, y, LightningCrystal);
					instance_delete(id);
				}
			}
			
			break;
			
		case area_city: /// FROZEN CITY
			
			 // Igloos:
			if(chance(1, GameCont.subarea)){
				var	_minID      = GameObject.id,
					_w          = 3,
					_h          = 3,
					_type       = "",
					_dirOff     = [30, 90],
					_spawnDis   = 64,
					_spawnFloor = FloorNormal;
					
				floor_set_align(null, null, 32, 32);
				
				repeat(irandom_range(1, 3)){
					var _floorDis = choose(0, -32);
					with(floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
						obj_create(x, y, "Igloo");
					}
				}
				
				floor_reset_align();
				
				 // Corner Walls:
				with(instances_matching_gt(Floor, "id", _minID)){
					if(!place_meeting(x - 32, y, Floor) && !place_meeting(x, y - 32, Floor)) instance_create(x,      y,      Wall);
					if(!place_meeting(x + 32, y, Floor) && !place_meeting(x, y - 32, Floor)) instance_create(x + 16, y,      Wall);
					if(!place_meeting(x - 32, y, Floor) && !place_meeting(x, y + 32, Floor)) instance_create(x,      y + 16, Wall);
					if(!place_meeting(x + 32, y, Floor) && !place_meeting(x, y + 32, Floor)) instance_create(x + 16, y + 16, Wall);
				}
			}
			
			 // Loop Spawns:
			if(GameCont.loops > 0){
				with(SnowTank) if(chance(1, 4)){
					obj_create(x, y, "SawTrap");
				}
				with(Necromancer) if(chance(1, 2)){
					obj_create(x, y, "Cat");
					instance_delete(id);
				}
			}
			with(Wolf) if(chance(1, ((GameCont.loops > 0) ? 5 : 200))){
				with(obj_create(x, y, "Cat")){
					sit = other; // It fits
					depth = other.depth - 0.1;
				}
			}
			
			break;
			
		case area_labs: /// LABS
			
			 // Loop Spawns:
			if(GameCont.loops > 0){
				with(Freak) if(chance(1, 5)){
					instance_create(x, y, BoneFish);
					instance_delete(id);
				}
				with(RhinoFreak) if(chance(1, 3)){
					obj_create(x, y, "Bat");
					instance_delete(id);
				}
				with(Ratking) if(chance(1, 5)){
					obj_create(x, y, "Bat");
					instance_delete(id);
				}
				with(LaserCrystal) if(chance(1, 4)){
					obj_create(x, y, "PortalGuardian");
					instance_delete(id);
				}
			}
			
			 // Freak Chambers:
			with(FloorNormal){
				if(chance(1 + GameCont.loops, 60 + GameCont.loops)){
					if(place_free(x, y) && point_distance(bbox_center_x, bbox_center_y, _spawnX, _spawnY) > 128){
						obj_create(bbox_center_x, bbox_center_y, "FreakChamber");
					}
				}
			}
			
			break;
			
		case area_palace: /// PALACE
			
			 // Cool Dudes:
			with(Guardian) if(chance(1, 20)){
				obj_create(x, y, "PortalGuardian");
				instance_delete(id);
			}
			
			 // Loop Spawns:
			if(GameCont.loops > 0){
				with(JungleBandit){
					repeat(chance(1, 5) ? 5 : 1){
						obj_create(x, y, "Gull");
					}
					
					 // Move to Wall:
					top_create(x, y, id, -1, -1);
				}
				
				 // More Cool Dudes:
				with(ExploGuardian) if(chance(1, 10)){
					obj_create(x, y, "PortalGuardian");
					instance_delete(id);
				}
			}
			
			break;
			
		case area_vault: /// CROWN VAULT
			
			 // Vault Flower Room:
			if(mod_variable_get("mod", "tepickups", "VaultFlower_spawn")){
				with(CrownPed){
					var	_w = 3,
						_h = 3,
						_type = "",
						_dirStart = random(360),
						_dirOff = 90,
						_floorDis = 0;
						
					floor_set_align(null, null, 32, 32);
					
					with(floor_room_create(x, y, _w, _h, _type, _dirStart, _dirOff, _floorDis)){
						 // Floor Time:
						var _img = 0;
						with(floors){
							// love u yokin yeah im epic
							sprite_index = spr.VaultFlowerFloor;
							image_index = _img++;
							depth = 7;
						}
						
						 // The Star of the Show:
						with(obj_create(x, y - 8, "VaultFlower")){
							with(instance_create(x, y, LightBeam)) sprite_index = sprLightBeamVault;
						}
					}
					
					floor_reset_align();
				}
			}
			
			break;
			
		case area_mansion: /// MANSIOM  its MANSION idiot, who wrote this
			
			 // Spawn Gold Mimic:
			with(instance_nearest(_spawnX, _spawnY, GoldChest)){
				with(pet_spawn(x, y, "Mimic")){
					wep = weapon_decide(0, GameCont.hard, true, null);
				}
				instance_delete(self);
			}
			
			break;
			
		case area_cursed_caves: /// CURSED CRYSTAL CAVES
			
			 // Spawn Cursed Mortars:
			with(instances_matching(InvLaserCrystal, "mortar_check", null)){
				mortar_check = chance(1, 4);
				if(mortar_check){
					obj_create(x, y, "InvMortar");
					instance_delete(id);
				}
			}
			
			 // Spawn Prism:
			with(BigCursedChest) pet_spawn(x, y, "Prism");
			
			break;
			
		case area_jungle: /// JUNGLE where is the hive ?
			
			 // Top Spawns:
			_topSpawn = [
				[Bush,					1],
				[JungleAssassinHide,	1/3],
				[BigFlower,				1/3]
			];
			with(instances_matching([JungleBandit, JungleFly], "", null)){
				if(chance(1, 3)){
					top_create(x, y, id, -1, -1);
				}
			}
			
			break;
			
		case area_hq: /// IDPD HQ
			
			 // Elevators:
			with(WantPopo){
				with(array_shuffle(FloorNormal)){
					if(place_free(x, y) && point_distance(bbox_center_x, bbox_center_y, _spawnX, _spawnY) > 128){
						obj_create(x, y, "FreakChamber");
					}
				}
				instance_delete(id);
			}
			with(instances_matching([EliteGrunt, EliteShielder, EliteInspector], "", null)){
				if(chance(1, 2)){
					obj_create(_x, _y, "FreakChamber");
					instance_delete(id);
					with(VanSpawn) enemies--;
					with(instances_matching(CustomObject, "name", "FreakChamber")) enemies--;
				}
			}
			
			 // Security Guards:
			with(instance_random(instances_matching([Grunt, Shielder, Inspector], "", null))){
				obj_create(x, y, "PopoSecurity");
				instance_delete(id);
			}
			
			break;
			
		case area_crib: /// CRIB
			
			 // Hmmmm:
			
			break;
	}
	
	 // Activate Events:
	with(array_flip(instances_matching(CustomObject, "name", "NTTEEvent"))){
		on_step = script_ref_create_ext(mod_type, mod_name, event + "_step");
		on_cleanup = script_ref_create_ext(mod_type, mod_name, event + "_cleanup");
		
		 // Event Generation:o
		var _minID = GameObject.id;
		mod_script_call(mod_type, mod_name, event + "_create");
		floors = array_combine(floors, instances_matching_gt(Floor, "id", _minID));
	}
	
	 // Wall Enemies / Props:
	var	_spiderMain = true,
		_spiderMainX = 0,
		_spiderMainY = 0,
		_spiderMainDis = 48 + (16 * GameCont.loops),
		_spiderStrayNum = 8 + irandom(4) + (2 * GameCont.loops);
		
	with(array_shuffle(instances_matching_ne(Wall, "topspr", -1))){
		if(!place_meeting(x, y, PortalClear) && !place_meeting(x, y, TopPot)){
			switch(topspr){
				
				case sprWall1Top: // BANDITS
					
					if(chance(1, 400)){
						if(!place_meeting(x, y + 16, Bones)){
							obj_create(bbox_center_x, bbox_center_y, "WallEnemy");
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
							with(obj_create(_x, _y, "WallEnemy")){
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
									obj_create(bbox_center_x, bbox_center_y, "WallEnemy");
								}
							}
						}
						
						 // Central Mass:
						else if(chance(2, 3) && point_distance(_x, _y, _spiderMainX, _spiderMainY) <= _spiderMainDis){
							obj_create(_x, _y, "WallEnemy");
						}
						
						 // Strays:
						else if(_spiderStrayNum > 0){
							_spiderStrayNum--;
							obj_create(_x, _y, "WallEnemy");
						}
					}
					
					 // Props:
					if(chance(1, 12)){
						if(distance_to_object(TopPot) > 64 && distance_to_object(Bones) > 96){
							top_create(
								random_range(bbox_left, bbox_right + 1),
								random_range(bbox_top, bbox_bottom + 1),
								choose(CrystalProp, CrystalProp, "NewCocoon"),
								-1,
								-1
							);
						}
					}
					
					break;
					
				case sprWall100Top: // TORCHES
					
					if(chance(1, 40)){
						top_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Torch, -1, -1);
					}
					
					break;
					
				case sprWall104Top: // CRYSTALS
					
					if(chance(1, 12)){
						if(distance_to_object(TopPot) > 64 && distance_to_object(Bones) > 96){
							top_create(
								random_range(bbox_left, bbox_right + 1),
								random_range(bbox_top, bbox_bottom + 1),
								choose(InvCrystal, InvCrystal, "NewCocoon"),
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
	with(array_shuffle(instances_matching_ne(TopPot, "object_index", TopPot))){
		switch(object_index){
			
			case TopDecalNightDesert: /// CAMPFIRE
				
				 // Night Cacti:
				if(chance(1, 2)){
					top_create(x, y - 8, NightCactus, random(360), -1);
				}
				
				break;
				
			case TopDecalDesert: /// DESERT
				
				 // Special:
				if(_topSpecial){
					_topSpecial = false;
					
					var	_x = x,
						_y = y,
						_dis = 64,
						_dir = random(360),
						_type = choose("Bandit", "Cactus", "Chest", "Wep");
						
					 // Avoid Floors:
					if(instance_exists(Floor)){
						var	l = 8,
							d = _dir;
							
						with(instance_nearest_bbox(_x, _y, Floor)){
							d = point_direction(bbox_center_x, bbox_center_y, _x, _y);
						}
						
						while(collision_circle(_x, _y, _dis, Floor, false, false)){
							_x += lengthdir_x(l, d);
							_y += lengthdir_y(l, d);
						}
						
						_dir = d;
					}
					
					 // Create:
					var	_num = 3,
						_ang = random(360),
						_decalNum = _num,
						_cactusNum = irandom_range(1, _num),
						_banditNum = 0,
						_flyNum = 0;
						
					if(GameCont.loops > 0){
						_flyNum = irandom_range(1, _num);
					}
					
					switch(_type){
						case "Bandit":
							_banditNum = irandom_range(1, _num);
							_cactusNum = max(_cactusNum, _banditNum - 1);
							obj_create(_x, _y - 4, "WallEnemy");
							break;
							
						case "Cactus":
							_cactusNum = _num;
							top_create(_x, _y - 28, BonePile, 0, 0);
							
							 // Hmmm:
							var	l = 160,
								d = _dir;
								
							with(chest_create(_x + lengthdir_x(l, d), _y + lengthdir_y(l, d), BigWeaponChest, true)){
								with(top_create(x, y, self, d, l)){
									with(chest_create(x + lengthdir_x(16, d), y + lengthdir_y(16, d), AmmoChest, true)){
										top_create(x, y, self, -1, -1);
									}
									top_create(x, y, Cactus, d + 180 + orandom(90), -1);
								}
								
								 // Skipping Doesn't Count:
								if(instance_is(self, BigWeaponChest)) GameCont.nochest -= 2;
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
							with(chest_create(_x, _y - 16, _obj, true)){
								with(top_create(x, y, self, 0, 0)) spr_shadow_y--;
							}
							break;
							
						case "Wep":
							_cactusNum = irandom_range(2, _num);
							with(top_create(_x, _y - 16, "WepPickupGrounded", 0, 0)){
								with(target) with(target){
									wep = weapon_decide(3, GameCont.hard + 2, false, null);
								}
							}
							break;
					}
					
					for(var a = _ang; a < _ang + 360; a += (360 / _num)){
						var l = _dis * random_range(0.3, 0.7),
							d = a + orandom(15);
							
						 // Rocks:
						if(_decalNum > 0){
							_decalNum--;
							with(obj_create(_x + lengthdir_x(l, d), _y + lengthdir_y(l, d), "TopDecal")){
								x = xstart;
								y = ystart;
								instance_create(pfloor(x - 16, 16), pfloor(y - 16, 16), Top);
							}
						}
						d += (360 / _num) / 2;
						
						 // Enemy:
						if(_banditNum > 0){
							_banditNum--;
							obj_create(_x + lengthdir_x(l, d), _y + lengthdir_y(l, d), "WallEnemy");
						}
						
						 // Cacti:
						if(_cactusNum > 0){
							_cactusNum--;
							var l = _dis * random_range(0.15, 0.5);
							top_create(_x + lengthdir_x(l, d), _y - 20 + lengthdir_y(l, d), Cactus, 0, 0);
						}
						
						 // Flies:
						if(_flyNum > 0){
							_flyNum--;
							var l = _dis * random_range(0.5, 1);
							top_create(_x + lengthdir_x(l, d), _y - 16 + lengthdir_y(l, d), JungleFly, d + orandom(30), l);
						}
					}
					
					instance_delete(id);
				}
				
				 // Cacti:
				else top_create(x, y - 8, Cactus, random(360), -1);
				
				break;
				
			case TopDecalScrapyard: /// SCRAPYARD
				
				 // Ravens:
				if(chance(1, 2)){
					if(image_index >= 1){
						top_create(x, y - 16, "TopRaven", 0, 0);
					}
					else{
						top_create(x, y - 8, "TopRaven", random(360), -1);
					}
				}
				
				break;
				
			case TopDecalPalace: /// PALACE
				
				 // Pillars:
				if(chance(1, 2)){
					with(instance_nearest_bbox(x, y, Floor)){
						top_create(other.x, other.y - 8, Pillar, point_direction(other.x, other.y, bbox_center_x, bbox_center_y), random_range(16, 64));
					}
				}
				
				break;
				
		}
	}
	
	 // Big Decals:
	if(chance(1, (area_get_subarea(GameCont.area) > 1) ? 8 : 4)){
		with(instance_random(TopSmall)){
			obj_create(x, y, "BigDecal");
		}
	}
	
	 // Top Spawns:
	var _rollMax = 0;
	with(_topSpawn) _rollMax += self[1];
	if(array_length(_topSpawn) > 0){
		with(instances_matching([TopSmall, Wall], "", null)) if(chance(_topChance, 1)){
			var _roll = random(_rollMax);
			if(_roll > 0){
				 // Decide:
				var _obj = -1;
				with(_topSpawn){
					_roll -= self[1];
					if(_roll <= 0){
						_obj = self[0];
						break;
					}
				}
				
				 // Spawn:
				var	_x = x + random(8),
					_y = y + random(8);
					
				with(top_create(_x, _y, _obj, -1, -1)){
					switch(_obj){
						case Barrel: // Bandit Boys
							for(var d = spawn_dir; d < spawn_dir + 360; d += (360 / 3)){
								var l = random_range(12, 24);
								with(top_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), Bandit, d, 0)){
									idle_walk_chance = 1/20;
								}
							}
							break;
							
						case BoneFish: // Fish Schools
						case "Puffer":
						case "HammerShark":
							var	_num = irandom_range(1, 4) + (3 * GameCont.loops),
								_ang = random(360);
								
							if(_obj == "HammerShark"){
								_num = floor(_num / 4);
							}
							
							if(_num > 0) for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
								var	l = 12 + random(12 + (4 * GameCont.loops)),
									d = _dir + orandom(40);
									
								with(top_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), _obj, d, 0)){
									jump_time = other.jump_time;
									z = max(8, other.z + orandom(8));
								}
							}
							break;
							
						case Car: // Perching Ravens
						case Tires:
						case MeleeFake:
							with(top_create(target.x, target.y + 1, "TopRaven", 0, 0)){
								z += max(0, ((sprite_get_bbox_bottom(target.spr_idle) + 1) - sprite_get_bbox_top(target.spr_idle)) - 5);
								
								switch(_obj){
									case Car:
										x += 2 * other.target.image_xscale * variable_instance_get(other.target, "right", 1);
										z += choose(-1, 0, 1);
										break;
										
									case MeleeFake:
										z -= choose(3, 4);
										break;
								}
							}
							break;
							
						case CrystalProp: // Spider Time
						//case InvCrystal:
							if(chance(1, 8)) repeat(irandom_range(1, 3)){
								top_create(x, y, "Spiderling", random(360), -1);
							}
							break;
							
						case Freak: // Freak Groups
							var _num = irandom_range(1, 4);
							if(_num > 0) repeat(_num){
								with(top_create(x + orandom(24), y + orandom(24), _obj, 0, 0)){
									jump_time = other.jump_time;
								}
							}
							break;
							
						/*case Hydrant: // Seal Squads
							var	_type = choose(5, 6),
								_time = 30 * random_range(5, 1 + instance_number(enemy)),
								_num = 3 + irandom(2 + (crown_current == crwn_blood)) + ceil(GameCont.loops / 2);
								
							for(var d = spawn_dir; d < spawn_dir + 360; d += (360 / _num)){
								with(top_create(x, y, (chance(1, 80) ? Bandit : "Seal"), d, -1)){
									jump_time = _time + random(30);
									with(target) if(variable_instance_get(self, "name") == "Seal"){
										type = (chance(1, 2) ? _type : 4);
										spr_idle = spr.SealIdle[type];
										spr_walk = spr.SealWalk[type];
										spr_weap = spr.SealWeap[type];
									}
								}
							}
							break;*/
							
						/*case ToxicBarrel: // Cat Dudes
							repeat(choose(1, 1, 2)){
								top_create(x, y, "Cat", random(360), -1);
							}
							break;*/
					}
				}
			}
		}
	}
	
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
				var t = weapon_get_type(self);
				if(t != 0){
					_chance += other.ammo[t];
					_chanceMax += other.typ_amax[t] * 0.8;
				}
				else{
					_chance += 200;
					_chanceMax += 200;
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
		with(instance_random([Wall, TopSmall])){
			with(top_create(x + random(16), y + random(16), _obj, -1, -1)){
				with(instances_matching_gt(RadMaggotChest, "id", target)) instance_delete(id);
			}
		}
	}
	
	 // Baby Scorpions:
	if(instance_exists(Scorpion) || instance_exists(GoldScorpion)){
		var _eventScorp = teevent_get_active("ScorpionCity");
		with(Scorpion) if(chance(1 + _eventScorp, 4)){
			repeat(irandom_range(1, 3)){
				obj_create(x, y, "BabyScorpion");
			}
		}
		with(GoldScorpion) if(chance(_eventScorp, 4)){
			repeat(irandom_range(1, 3)){
				obj_create(x, y, "BabyScorpionGold");
			}
		}
		with(MaggotSpawn){
			babyscorp_drop = chance(1, 8) + _eventScorp;
		}
	}
	
	 // Big Dog Spectators:
	with(BecomeScrapBoss){
		repeat(irandom_range(2, 6) * (1 + GameCont.loops)){
			top_create(x, y, "TopRaven", random(360), -1);
		}
	}
	
	 // Sewer Manhole:
	with(PizzaEntrance){
		obj_create(bbox_center_x, bbox_center_y, "Manhole");
		instance_delete(id);
	}
	
	 // Lair Chests:
	var	_crime = (crown_current == "crime"),
		_lair = (variable_instance_get(GameCont, "ntte_visits_lair", 0) > 0);
		
	if(_lair || _crime){
		var _crimePick = (_crime ? choose(AmmoChest, WeaponChest) : -1);
		
		 // Cat Chests:
		with(instances_matching_ne(AmmoChest, "object_index", IDPDChest, GiantAmmoChest)){
			if(instance_is(self, _crimePick) || chance(_lair, 5)){
				chest_create(x, y, "CatChest", true);
				instance_delete(id);
			}
		}
		
		 // Bat Chests:
		with(instances_matching_ne(WeaponChest, "object_index", GiantWeaponChest)){
			if(instance_is(self, _crimePick) || chance(_lair, 5)){
				with(chest_create(x, y, "BatChest", true)){
					if("name" in self && name == "BatChest"){
						big = (instance_is(other, BigWeaponChest) || instance_is(other, BigCursedChest));
						curse = other.curse;
					}
				}
				instance_delete(id);
			}
		}
	}
	
	 // Orchid Chests:
	if(save_get("orchid:seen", false)){
		with(RadChest){
			if(chance(GameCont.rad * (GameCont.level / 10), 600 * 3)){
				obj_create(x, y, "OrchidChest");
				instance_delete(id);
			}
		}
	}
	
	 // Red Ammo:
	var _redWep = false;
	with(["wep", "bwep"]){
		var o = self;
		with(Player){
			var _name = wep_get(variable_instance_get(self, o)),
				_scrt = "weapon_red",
				_type = "weapon";
			
			if(is_string(_name)){
				if(mod_script_exists(_type, _name, _scrt)){
					_redWep += real(mod_script_call(_type, _name, _scrt));
				}
			}
		}
	}
	
	if(_redWep > 0){
		with(RadChest) if(chance(_redWep, 5)){
			obj_create(x, y, "RedAmmoChest");
			instance_delete(id);
		} 
	}
	
	 // Flies:
	with(MaggotSpawn){
		var n = irandom_range(0, 2);
		if(n > 0) repeat(n) obj_create(x + orandom(12), y + orandom(8), "FlySpin");
	}
	with(BonePile) if(chance(1, 2)){
		with(obj_create(x, y, "FlySpin")){
			target = other;
			target_x = orandom(8);
			target_y = -random(8);
		}
	}
	
	 // Baby Sludge Pools:
	with(instances_matching(instances_matching(Floor, "sprite_index", sprFloor3), "image_index", 3)){
		if(array_length(instances_meeting(CustomObject, "name", "SludgePool")) <= 0){
			with(obj_create(bbox_center_x, bbox_center_y, "SludgePool")){
				sprite_index = msk.SludgePoolSmall;
				spr_floor = other.sprite_index;
			}
		}
	}
	
	 // Wall Depth Fix:
	with(instances_matching(Wall, "depth", 0)){
		depth++;
		depth--;
	}
	
#define step
	ntte_begin_step();
	
	 // Bind Events:
	if(array_length(instances_matching(CustomScript, "name", "ntte_step")) <= 0){
		with(script_bind_step(ntte_step, 0)){
			name = script[2];
			persistent = true;
		}
	}
	if(array_length(instances_matching(CustomScript, "name", "ntte_end_step")) <= 0){
		with(script_bind_end_step(ntte_end_step, 0)){
			name = script[2];
			persistent = true;
		}
	}
	if(!instance_exists(NothingSpiral) && instance_exists(BackCont)){
		script_bind_draw(draw_shadows_top, -6.001);
	}
	
#define ntte_call(_call)
	/*
		Calls the given type of script in all NTTE area and object mods
		Other mod types can be added if desired in future
		
		Ex:
			ntte_call("bloom") == Calls all 'ntte_bloom' scripts
	*/
	
	var _scrt = "ntte_" + _call;
	
	 // Compile Mod Calling List:
	if(array_length(ntte_call_mods) <= 0){
		 // General Mods:
		with([
			["mod", "temenu"],
			["mod", "teevents"],
			["mod", "petlib"]
		]){
			var	_type = self[0],
				_name = self[1];
				
			array_push(
				ntte_call_mods,
				[_type, _name, mod_variable_get(_type, _name, "debug_lag")]
			);
		}
		
		 // Area Mods:
		with(ntte_area){
			var	_type = "area",
				_name = self;
				
			array_push(
				ntte_call_mods,
				[_type, _name, mod_variable_get(_type, _name, "debug_lag")]
			);
		}
		
		 // Object Mods:
		var _objList = mod_variable_get("mod", "telib", "object_list");
		for(var i = 0; i < lq_size(_objList); i++){
			var	_type = "mod",
				_name = lq_get_key(_objList, i);
				
			array_push(
				ntte_call_mods,
				[_type, _name, mod_variable_get(_type, _name, "debug_lag")]
			);
		}
		
		 // Debugging Lag:
		if(lag || instance_exists(PauseButton) || instance_exists(BackMainMenu)){
			with(ntte_call_mods){
				self[@2] = false;
			}
		}
	}
	
	 // Call Scripts:
	with(ntte_call_mods){
		var	_type = self[0],
			_name = self[1];
			
		if(mod_script_exists(_type, _name, _scrt)){
			var _lag = self[2];
			if(_lag) trace_time();
			
			with(other) mod_script_call(_type, _name, _scrt);
			
			if(_lag) trace_time(_name + "_" + _call);
		}
	}
	
#define ntte_begin_step
	if(lag) trace("");
	
	 // NTTE Object Code:
	mod_script_call("mod", "telib", "obj_begin_step");
	
	if(lag) trace_time();
	
	 // Manually Recreating Pause/Loading/GameOver Map:
	if(global.area_update){
		global.area_update = false;
		
		with(GameCont){
			var i = waypoints - 1;
			if(i >= 0){
				global.area_mapdata[i] = [area, subarea, loops];
			}
		}
	}
	
	 // Character Selection Menu:
	if(instance_exists(Menu)){
		if(!mod_exists("mod", "teloader")){
			 // Custom Character Stuff:
			with(ntte_race){
				var _name = self;
				
				 // Create Custom CampChars:
				if(mod_exists("race", _name) && unlock_get("race:" + _name)){
					if(array_length(instances_matching(CampChar, "race", _name)) <= 0){
						with(CampChar_create(64, 48, _name)){
							 // Poof in:
							repeat(8) with(instance_create(x, y + 4, Dust)){
								motion_add(random(360), 3);
								depth = other.depth - 1;
							}
						}
					}
				}
				
				 // CharSelect:
				with(instances_matching(CharSelect, "race", _name)){
					 // race_avail Fix:
					if(mod_script_exists("race", _name, "race_avail") && !mod_script_call_nc("race", _name, "race_avail")){
						noinput = 10;
					}
					
					 // New:
					else if(stat_get("race:" + _name + ":runs") <= 0){
						script_bind_draw(CharSelect_draw_new, depth - 0.001, id);
					}
				}
			}
			
			 // CampChar Management:
			for(var i = 0; i < maxp; i++) if(player_is_active(i)){
				var _race = player_get_race(i);
				if(array_exists(ntte_race, _race)){
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
									
								view_shift(
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
	}
	
	 // Pets:
	with(Player){
		if("ntte_pet" not in self){
			ntte_pet = [];
		}
		if("ntte_pet_max" not in self){
			ntte_pet_max = global.pet_max;
		}
		
		 // Slots:
		if(array_length(ntte_pet) != ntte_pet_max){
			while(array_length(ntte_pet) < ntte_pet_max){
				array_push(ntte_pet, noone);
			}
			while(array_length(ntte_pet) > ntte_pet_max){
				var _break = true;
				for(var i = 0; i < array_length(ntte_pet); i++){
					if(!instance_exists(ntte_pet[i])){
						ntte_pet = array_delete(ntte_pet, i);
						_break = false;
						break;
					}
				}
				if(_break) break;
			}
		}
		
		 // Map Icons:
		var _list = [];
		with(ntte_pet) if(instance_exists(self)){
			array_push(_list, pet_get_icon(mod_type, mod_name, pet));
		}
		global.pet_mapicon[index] = _list;
	}
	
	 // NTTE Areas:
	if(!instance_exists(GenCont) && !instance_exists(LevCont)){
		var _area = (
			(GameCont.area == area_vault)
			? GameCont.lastarea
			: GameCont.area
		);
		if(array_exists(ntte_area, _area)){
			 // Underwater Area:
			if(area_get_underwater(_area)){
				mod_script_call("mod", "teoasis", "underwater_step");
			}
			
			 // Floor FX:
			with(instances_matching_le(instances_matching_gt(BackCont, "alarm0", 0), "alarm0", ceil(current_time_scale))){
				var _scrt = "area_effect";
				if(mod_script_exists("area", _area, _scrt)){
					 // Pick Random Player's Screen:
					do var i = irandom(maxp - 1);
					until player_is_active(i);
					var _vx = view_xview[i], _vy = view_yview[i];
					
					 // FX:
					var t = mod_script_call("area", _area, _scrt, _vx, _vy);
					if(!is_undefined(t) && t != 0) alarm0 = t + current_time_scale;
				}
			}
		}
	}
	ntte_music();
	
	 // Game Win Crown Unlock:
	with(instances_matching_le(instances_matching_gt(PlayerSit, "alarm0", 0), "alarm0", ceil(current_time_scale))){
		if(array_exists(ntte_crwn, crown_current)){
			unlock_set(`loadout:crown:${crown_current}`, true);
		}
	}
	
	 // Pet Map Icon Stuff:
	global.pet_mapicon_pause = 0;
	if(instance_exists(GenCont)){
		for(var i = 0; i < maxp; i++){
			if(button_pressed(i, "paus")){
				global.pet_mapicon_pause_force = true;
			}
		}
	}
	
	 // Goodbye, stupid mechanic:
	with(GameCont) if(junglevisits > 0){
		skill_set(mut_last_wish, 1);
		junglevisits--;
		skillpoints--;
	}
	
	 // Call Scripts:
	ntte_call("begin_step");
	
	 // NTTE Blood Weapons:
	for(var i = 0; i < maxp; i++){
		var	_fire = button_pressed(i, "fire"),
			_spec = button_pressed(i, "spec");
			
		if(_fire || _spec){
			with(ntte_weps){
				var	_name = self,
					_scrt = "weapon_blood";
					
				if(mod_script_exists("weapon", _name, "weapon_blood")){
					var _wepList = [];
					with(instances_matching(Player, "infammo", 0)){
						if(player_active){
							if(_fire && canfire >= 1){
								array_push(_wepList, [id, wep]);
							}
							if(_spec && canspec && race == "steroids"){
								array_push(_wepList, [id, bwep]);
							}
						}
					}
					with(_wepList){
						var _wep = self[1];
						if(wep_get(_wep) == _name){
							with(self[0]){
								var	_type = weapon_get_type(_wep),
									_cost = weapon_get_cost(_wep);
									
								if(ammo[_type] < _cost && _type != 0){
									var _blood = mod_script_call("weapon", _name, "weapon_blood", _wep);
									if(_blood != 0){
										ammo[_type] += _cost;
										lasthit = [weapon_get_sprt(_wep), weapon_get_name(_wep)];
										projectile_hit_raw(self, _blood, true);
										sound_play_hit(sndBloodHurt, 0.1);
										sleep(40);
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
	 // Player Death:
	with(instances_matching_le(Player, "my_health", 0)){
		if(fork()){
			var	_x = x,
				_y = y,
				_save = ["ntte_pet", "feather_ammo", "bonus_ammo"],
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
					with(instance_nearest_array(_x, _y, instances_matching(Revive, "ntte_storage", null))){
						ntte_storage = obj_create(x, y, "ReviveNTTE");
						with(ntte_storage){
							creator = other;
							vars = _vars;
							p = other.p;
						}
					}
				}
				
				 // Race Deaths Stat:
				if(array_exists(ntte_race, _race)){
					var _stat = "race:" + _race + ":lost";
					stat_set(_stat, stat_get(_stat) + 1);
				}
			}
			
			exit;
		}
	}
	
	 // Temporary Turret Fix:
	with(instances_matching(Turret, "mask_index_fix_brooooo", null)){
		mask_index_fix_brooooo = true;
		if(mask_index == mskNone && !canfly){
			mask_index = mskScorpion;
		}
	}
	
	if(lag) trace_time("ntte_begin_step");
	
#define ntte_step
	if(lag) trace_time();
	
	 // Level Start:
	if(instance_exists(GenCont) || instance_exists(Menu)){
		global.level_start = true;
	}
	else if(global.level_start){
		global.level_start = false;
		level_start();
	}
	
	 // IDPD Chest Alerts:
	with(instances_matching(ChestOpen, "ntte_chestalert_check", null)){
		ntte_chestalert_check = false;
		
		if(sprite_index == sprIDPDChestOpen && instance_exists(IDPDSpawn)){
			ntte_chestalert_check = true;
			
			 // Alert:
			var _spr = spr.PopoAlert;
			if(array_length(instances_matching(IDPDSpawn, "elite", true)) > 0) _spr = spr.PopoEliteAlert;
			if(array_length(instances_matching(IDPDSpawn, "freak", true)) > 0) _spr = spr.PopoFreakAlert;
			with(scrAlert(self, _spr)){
				vspeed = -0.8;
				image_speed = 0.1;
				alert = { spr:spr.AlertIndicatorPopo, x:-5, y:5 };
				blink = 20;
				flash = 6;
				snd_flash = sndIDPDNadeAlmost;
			}
			
			 // No Cheese:
			portal_poof();
		}
	}
	
	 // Van Alerts:
	with(instances_matching(VanSpawn, "ntte_vanalert_check", null)){
		ntte_vanalert_check = true;
		
		 // Side:
		var _side = choose(-1, 1);
		with(instance_nearest(x, y, Player)){
			if(x != other.x) _side = sign(x - other.x);
		}
		
		 // Alert:
		with(scrAlert(noone, spr.VanAlert)){
			image_xscale *= _side;
			alert.x *= -1;
			canview = false;
			alarm0 = 12 + other.alarm0;
			blink = 10;
		}
	}
	
	 // Proto Statue Destroys Portal:
	if(instance_exists(enemy) || instance_exists(IDPDSpawn)){
		with(instances_matching(ProtoStatue, "ntte_portalpoof_check", null)){
			if(my_health < maxhealth * 0.7){
				ntte_portalpoof_check = true;
				portal_poof();
			}
		}
	}
	
	 // Portal Weapons:
	if(instance_exists(SpiralCont) && (instance_exists(GenCont) || instance_exists(LevCont))){
		with(WepPickup){
			if(!instance_exists(variable_instance_get(self, "portal_inst", noone))){
				portal_inst = instance_create(SpiralCont.x, SpiralCont.y, SpiralDebris);
				with(portal_inst){
					sprite_index = other.sprite_index;
					image_index = 0;
					turnspeed = orandom(1);
					rotspeed = orandom(15);
					dist = random_range(80, 120);
				}
			}
			with(portal_inst){
				image_xscale = 0.7 + (0.1 * sin((-image_angle / 2) / 200));
				image_yscale = image_xscale;
				grow = 0;
			}
		}
	}
	
	 // Unlock Golden Merged Weapons:
	with(instances_matching(GenCont, "ntte_wep_unlock", null)){
		ntte_wep_unlock = true;
		with(Player){
			with(["wep", "bwep"]){
				var _wep = variable_instance_get(other, self);
					
				if(weapon_get_gold(_wep) != 0){
					if(array_exists(["merge", "trident"], wep_get(_wep))){
						var	_path = `loadout:wep:${other.race}`,
							_name = "main";
							
						if(unlock_set(_path + ":" + _name, _wep)){
							save_set(_path, _name);
							break;
						}
					}
				}
			}
		}
	}
	
	 // Area Completion Unlocks:
	if(!instance_exists(GenCont) && !instance_exists(LevCont) && instance_exists(Player)){
		if(instance_exists(Portal) || (!instance_exists(enemy) && !instance_exists(becomenemy) && !instance_exists(CorpseActive))){
			//if(!array_length(instances_matching_ne(instances_matching(CustomObject, "name", "CatHoleBig"), "sprite_index", mskNone))){ yokin wtf how could you comment out my epic code!?!?
				var _packList = [
					"coast",
					"oasis",
					"trench",
					"lair"
				];
				
				if(array_exists(_packList, GameCont.area)){
					if(GameCont.subarea >= area_get_subarea(GameCont.area)){
						unlock_set("pack:" + GameCont.area, true);
						
						 // Extra Unlocks:
						switch(GameCont.area){
							case "lair":
								unlock_set("crown:crime", true);
								break;
						}
					}
				}
			//}
		}
	}
	
	 // Call Scripts:
	ntte_call("step");
	
	 // Better Inactive Throne Hitbox:
	with(instances_matching(NothingIntroMask, "mask_index", mskNothingInactive, msk.NothingInactiveCool)){
		with(instances_matching(instances_matching([NothingInactive, BecomeNothing], "xstart", xstart), "ystart", ystart)){
			 // Shadow Fix:
			depth = max(depth, 5);
			if("spr_shadow" in self){
				spr_shadow = -1;
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
						if(object_get_depth(NothingPipes) < depth){
							with(instance_nearest(x, y, NothingPipes)){
								with(other){
									with(instance_create(x, y, GameObject)){
										sprite_index = object_get_sprite(NothingPipes);
										depth = other.depth;
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
		
		 // Better Collision:
		var _lastSolid = solid;
		solid = true;
		with(Player){
			move_step(1);
			
			if(place_meeting(x, y, other)){
				x = xprevious;
				y = yprevious;
				
				if(place_meeting(x, y + max(0, vspeed_raw), other)){
					direction = 270 + (30 * clamp(hspeed / 4, -1, 1));
				}
				else{
					event_perform(ev_collision, InvisiWall);
				}
			}
			
			move_step(-1);
		}
		solid = _lastSolid;
	}
	
	if(lag) trace_time("ntte_step");
	
#define ntte_end_step
	if(lag) trace_time();
	
	 // Bind HUD Event:
	var	_HUDDepth = 0,
		_HUDVisible = false;
		
	with(instances_matching(TopCont, "visible", true)){
		_HUDDepth = depth - 0.1;
		_HUDVisible = true;
	}
	if(instance_exists(GenCont) || instance_exists(LevCont)){
		with(instances_matching(UberCont, "visible", true)){
			_HUDDepth = min(depth - 0.1, _HUDDepth);
			_HUDVisible = true;
		}
	}
	script_bind_draw(ntte_hud, _HUDDepth, _HUDVisible);
	
	 // Teamify Deflections:
	with(instances_matching([Slash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, LightningSlash, CustomSlash, CrystalShield, PopoShield], "", null)){
		if(place_meeting(x, y, projectile)){
			with(instances_meeting(x, y, instances_matching(projectile, "team", team))){
				if(place_meeting(x, y, other)){
					if(sprite_get_team(sprite_index) != 3){
						if(hitid == -1) hitid = variable_instance_get(other, "hitid", -1);
						team_instance_sprite(((team == 3) ? 1 : team), self);
					}
				}
			}
		}
	}
	
	 // Last Wish:
	with(instances_matching_ne(Player, "ntte_lastwish", skill_get(mut_last_wish))){
		var _wishDiff = (skill_get(mut_last_wish) - variable_instance_get(id, "ntte_lastwish", 0));
		ntte_lastwish = skill_get(mut_last_wish);
		
		if(ntte_lastwish != 0){
			 // LWO Weapons:
			with([wep, bwep]){
				var w = self;
				if(
					is_object(w)
					&& "ammo" in w
					&& "amax" in w
					&& array_exists(ntte_weps, wep_get(w))
				){
					var	_cost = lq_defget(w, "cost", 0),
						_amax = w.amax,
						_amaxRaw = (_amax / (1 + lq_defget(w, "buff", 0))),
						_wish = lq_defget(w, "wish", (
							(_amaxRaw < 200)
							? ceil(_amax * 0.35)
							: round(_amax * 0.785)
						));
						
					w.ammo = clamp(w.ammo + (_wish * _wishDiff), _cost, _amax);
				}
			}
			
			 // Parrot:
			if(race == "parrot"){
				var _wish = (2 * feather_num);
				feather_ammo = clamp(feather_ammo + (_wish * _wishDiff), feather_num, feather_ammo_max);
			}
		}
	}
	
	 // Weapon Unlock Stuff:
	with(Player){
		var w = 0;
		with([wep_get(wep), wep_get(bwep)]){
			var _wep = self;
			with(other){
				if(is_string(_wep) && mod_script_exists("weapon", _wep, "weapon_avail") && array_exists(ntte_weps, _wep)){
					 // No Cheaters (bro just play the mod):
					if(!mod_script_call("weapon", _wep, "weapon_avail")){
						variable_instance_set(id, ["wep", "bwep"][w], "crabbone");
						var a = choose(-120, 120);
						variable_instance_set(id, ["wepangle", "bwepangle"][w], a);
						
						 // Effects:
						sound_play(sndCrownRandom);
						view_shake_at(x, y, 20);
						instance_create(x, y, GunWarrantEmpty);
						repeat(2) with(scrFX(x, y, [gunangle + a, 2.5], Smoke)){
							depth = other.depth - 1;
						}
					}
					
					 // Weapon Found:
					else stat_set("found:" + _wep + ".wep", true);
				}
			}
			w++;
		}
	}
	
	 // Crown Found:
	if(is_string(crown_current) && array_exists(ntte_crwn, crown_current)){
		stat_set("found:" + crown_current + ".crown", true);
	}
	
	 // Race Stats:
	var _statInst = instances_matching([GenCont, PlayerSit], "ntte_statadd", null);
	with(_statInst) ntte_statadd = true;
	if(instance_exists(Player)){
		var _statList = {
			"kill" : (GameCont.kills - global.kills_last),
			"loop" : ((GameCont.area == area_vault) ? array_length(instances_matching(_statInst, "object_index", GenCont)) : 0),
			"wins" : array_length(instances_matching(_statInst, "object_index", PlayerSit))
			//"time" : (current_time_scale / 30)
		};
		
		 // Find Active Races:
		var _statRace = [];
		for(var i = 0; i < maxp; i++){
			var _race = player_get_race(i);
			if(array_exists(ntte_race, _race) && !array_exists(_statRace, _race)){
				array_push(_statRace, _race);
			}
		}
		
		 // Apply Stats:
		with(_statRace){
			var _statPath = "race:" + self + ":";
			
			 // General Stats:
			for(var i = 0; i < lq_size(_statList); i++){
				var	_stat = _statPath + lq_get_key(_statList, i),
					_add = lq_get_value(_statList, i);
					
				if(_add > 0){
					stat_set(_stat, stat_get(_stat) + _add);
				}
			}
			
			 // Time:
			if((array_length(instances_matching(instances_matching(Player, "race", self), "visible", false)) <= 0 && !instance_exists(GenCont)) || instance_exists(LevCont)){
				if(!instance_exists(PlayerSit)){
					var _stat = _statPath + "time";
					stat_set(_stat, stat_get(_stat) + (current_time_scale / 30));
				}
			}
			
			 // Best Run:
		 	if(GameCont.kills >= stat_get(_statPath + "best:kill")){
		 		stat_set(_statPath + "best:area", area_get_name(GameCont.area, GameCont.subarea, GameCont.loops));
		 		stat_set(_statPath + "best:kill", GameCont.kills);
		 	}
		}
	}
	global.kills_last = GameCont.kills;
	
	 // Custom Loading Screens:
	with(instances_matching(SpiralCont, "ntte_spiral", null)){
		ntte_spiral = true;
		
		var _lastTimeScale = current_time_scale;
		current_time_scale = 1;
		
		switch(GameCont.area){
			
			case area_desert: // Another Universe Fallen
				
				if(GameCont.lastarea == area_campfire && instance_exists(GenCont)){
					var s = spr.SpiralDebrisNothing;
					for(var i = 0; i < sprite_get_number(s); i++){
						var	l = 24,
							d = random(360);
							
						with(instance_create((game_width / 2) + lengthdir_x(l, d), (game_height / 2) + lengthdir_y(l, d), SpiralDebris)){
							sprite_index = s;
							image_index = i;
							turnspeed *= 2/3;
							angle = d;
							
							 // Fast Forward:
							repeat(irandom_range(25, 40)){
								with(self) event_perform(ev_step, ev_step_normal);
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
				
			case "pizza": // Falling Through Manhole
				
				type = 4;
				
				 // Reset:
				with(Spiral) instance_destroy();
				repeat(30){
					with(self) event_perform(ev_step, ev_step_normal);
					with(Spiral) event_perform(ev_step, ev_step_normal);
					with(SpiralStar) event_perform(ev_step, ev_step_normal);
				}
				
				 // Pizza:
				with(SpiralStar){
					if(chance(1, 30)){
						sprite_index = sprSlice;
						image_index = 0;
						image_xscale *= 2/3;
						image_yscale *= 2/3;
						image_angle = random(360);
						
						 // Fast Forward:
						repeat(irandom(10)){
							with(self) event_perform(ev_step, ev_step_normal);
						}
					}
				}
				
				 // Manhole Cover:
				with(instance_create(x, y, SpiralDebris)){
					sprite_index = spr.Manhole;
					image_index = 5;
					turnspeed *= 2/3;
					
					 // Fast Forward:
					repeat(irandom_range(8, 12)){
						with(self) event_perform(ev_step, ev_step_normal);
					}
				}
				
				break;
				
			case "trench": // Surprise Cameo
				
				if(chance(1, 6)){
					with(instance_create(x, y, SpiralDebris)){
						sprite_index = spr.KingCrabIdle;
						grow  = 0.1;
						dist *= 0.8;
					}
				}
				
				break;
				
			case "red": // Between Betweens
				
				time = 0;
				
				 // Did You Just See That?:
				with(Player) if(chance(1, 3)){
					with(instance_create(other.x, other.y, SpiralDebris)){
						sprite_index = other.spr_hurt;
						image_index  = 1;
						turnspeed *= 2/3;
						
						 // Fast Forward:
						repeat(irandom_range(8, 12)){
							with(self) event_perform(ev_step, ev_step_normal);
						}
					}
				}
				
				 // Starfield:
				var _spr = spr.Starfield;
				for(var i = sprite_get_number(_spr) - 1; i >= 0; i--){
					with(instance_create(x, y, SpiralDebris)){
						ntte_starfield = true;
						sprite_index = _spr;
						image_index = i;
						turnspeed = 0;
					}
				}
				
				break;
		}
		
		 // Bubbles:
		if(area_get_underwater(GameCont.area)){
			repeat(12) with(instance_create(x, y, SpiralStar)){
				sprite_index = sprBubble;
				image_speed  = random(0.2);
				
				 // Fast Forward:
				repeat(irandom_range(12, 48)){
					with(self) event_perform(ev_step, ev_step_normal);
				}
			}
		}
		
		current_time_scale = _lastTimeScale;
	}
	if(GameCont.area == "red"){
		 // Starfield:
		with(SpiralCont){
			var w = arctan(time / 100);
			with(instances_matching(SpiralDebris, "ntte_starfield", true)){
				image_xscale = (0.8 + (0.4 * image_index)) + w;
				image_yscale = image_xscale;
				rotspeed = image_xscale;
				dist = 0;
				grow = 0;
			}
		}
		
		 // Starfield Spirals:
		with(instances_matching(Spiral, "sprite_index", sprSpiral)){
			sprite_index = spr.SpiralStarfield;
			colors = [make_color_rgb(30, 14, 29), make_color_rgb(16, 10, 25)];
			lanim = -100;
			//grow += 0.05;
		}
	}
	
	 // NTTE Tips:
	with(instances_matching(GenCont, "tip_ntte", null)){
		tip_ntte = "";
		
		 // Scythe:
		if(GameCont.hard > 1){
			if(global.scythe_tip_index != -1){
				var _scythe = false;
				with(Player) if(wep_get(wep) == "scythe" || wep_get(bwep) == "scythe"){
					_scythe = true;
				}
				if(_scythe){
					tip_ntte = global.scythe_tip[global.scythe_tip_index];
					global.scythe_tip_index = min(global.scythe_tip_index + 1, array_length(global.scythe_tip) - 1);
				}
			}
		}
		
		 // Pets:
		if(tip_ntte == "" && chance(1, 14)){
			var	_player = array_shuffle(instances_matching_ne(Player, "ntte_pet", null)),
				_tip = null;
				
			with(_player){
				var _pet = array_shuffle(array_clone(ntte_pet));
				with(_pet) if(instance_exists(self)){
					var _scrt = pet + "_ttip";
					if(mod_script_exists(mod_type, mod_name, _scrt)){
						_tip = mod_script_call(mod_type, mod_name, _scrt);
						if(array_length(_tip) > 0){
							_tip = _tip[irandom(array_length(_tip) - 1)];
						}
					}
					
					if(is_string(_tip)) break;
				}
				if(is_string(_tip)) break;
			}
			
			if(is_string(_tip)){
				tip_ntte = _tip;
			}
		}
		
		 // Set Tip:
		if(tip_ntte != ""){
			tip = tip_ntte;
		}
	}
	
	 // Setup Events:
	with(instances_matching(GenCont, "ntte_event_check", null)){
		ntte_event_check = true;
		
		var _list = mod_variable_get("mod", "teevents", "event_list");
		for(var i = 0; i < array_length(_list); i++){
			var	_scrt = _list[i],
				_modType = _scrt[0],
				_modName = _scrt[1],
				_name = _scrt[2],
				_area = mod_script_call(_modType, _modName, _name + "_area");
				
			if(_area == null || GameCont.area == _area){
				var _hard = mod_script_call(_modType, _modName, _name + "_hard");
				if(GameCont.hard >= ((_hard == null) ? 2 : _hard)){
					var _chance = 1;
					if(mod_script_exists(_modType, _modName, _name + "_chance")){
						_chance = mod_script_call(_modType, _modName, _name + "_chance");
					}
					if(chance(_chance, 1)){
						teevent_set_active(_name, true);
					}
				}
			}
		}
	}
	
	 // This is it:
	with(instances_matching(Breath, "depth", -2)){
		depth = -3;
	}
	with(instances_matching([MeltSplat, Scorchmark], "depth", 1)){
		depth = 7;
	}
	with(instances_matching([VenuzCarpet, FloorMiddle], "depth", 7)){
		depth = 8;
	}
	with(instances_matching(instances_matching(Pillar, "spr_shadow_y", 0), "spr_shadow", shd24)){
		spr_shadow_y = -3;
	}
	with(instances_matching([Generator, GeneratorInactive], "spr_shadow", shd24, spr.shd.BigGenerator, spr.shd.BigGeneratorR)){
		spr_shadow = ((image_xscale < 0) ? spr.shd.BigGeneratorR : spr.shd.BigGenerator);
	}
	
	 // Call Scripts:
	ntte_call("end_step");
	
	 // Merged Weapon Pickup Indicator:
	with(instances_matching(WepPickup, "mergewep_indicator", null)){
		mergewep_indicator = true;
		
		if(wep_get(wep) == "merge" && is_object(wep)){
			if("stock" in wep.base && "front" in wep.base){
				var n = name;
				name += `#@(${mod_script_call("mod", "teassets", "weapon_merge_subtext", wep.base.stock, wep.base.front)})`;
				array_push(global.mergewep_name, { inst:id, name:name, orig:n });
			}
		}
	}
	var _pop = instances_matching(PopupText, "mergewep_indicator", null);
	if(array_length(_pop) > 0){
		with(global.mergewep_name){
			with(instances_matching(_pop, "text", name + "!")){
				text = other.orig + "!";
			}
			if(!instance_exists(inst)){
				global.mergewep_name = array_delete_value(global.mergewep_name, self);
			}
		}
		with(_pop) mergewep_indicator = true;
	}
	
	if(lag) trace_time("ntte_end_step");
	
#define draw_dark // Drawing Grays
	draw_set_color(c_gray);
	
	if(lag) trace_time();
	
	 // Portal Disappearing Visual:
	with(instances_matching(BulletHit, "name", "PortalPoof")){
		draw_circle(x, y, 120 + random(6), false);
	}
	
	 // Call Scripts:
	ntte_call("dark");
	
	if(lag) trace_time("ntte_dark");
	
#define draw_dark_end // Drawing Clear
	draw_set_color(c_black);
	
	if(lag) trace_time();
	
	 // Portal Disappearing Visual:
	with(instances_matching(BulletHit, "name", "PortalPoof")){
		draw_circle(x, y, 20 + random(8), false);
	}

	 // Call Scripts:
	ntte_call("dark_end");
	
	if(lag) trace_time("ntte_dark_end");
	
#define draw_bloom
	if(lag) trace_time();
	
	 // Call Scripts:
	ntte_call("bloom");
	
	if(lag) trace_time("ntte_bloom");
	
#define draw_shadows
	var _lag = (lag && !instance_exists(PauseButton) && !instance_exists(BackMainMenu));
	if(_lag) trace_time();
	
	 // Call Scripts:
	ntte_call("shadows");
	
	if(_lag) trace_time("ntte_shadows");
	
#define draw_shadows_top
	if(lag) trace_time();
	
	var	_inst = instances_matching_ne(
		instances_matching_ge(
			instances_matching(
				array_combine(
					instances_matching(CustomObject, "name", "TopObject"),
					instances_matching(CustomProjectile, "name", "MortarPlasma")
				),
				"visible", true
			),
			"z", 8
		),
		"spr_shadow", -1
	);
	
	if(array_length(_inst) > 0){
		var	_vx                = view_xview_nonsync,
			_vy                = view_yview_nonsync,
			_gw                = game_width,
			_gh                = game_height,
			_surfScale         = option_get("quality:minor"),
			_surfTopShadowMask = surface_setup("TopShadowMask", _gw * 2, _gh * 2, _surfScale),
			_surfTopShadow     = surface_setup("TopShadow",     _gw,     _gh,     _surfScale);
			
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
				x = _surfX;
				y = _surfY;
				floor_num = instance_number(Floor);
				wall_num  = instance_number(Wall);
				floor_min = GameObject.id;
				wall_min  = GameObject.id;
				
				 // Floor Mask:
				surface_set_target(surf);
				draw_clear_alpha(0, 0);
					
					 // Draw Floors:
					with(instance_rectangle_bbox(x, y, x + w, y + h, Floor)){
						draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - 8 - _surfY) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, image_blend, image_alpha);
					}
					
					 // Cut Out Walls:
					draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
					with(instance_rectangle_bbox(x, y, x + w, y + h, Wall)){
						draw_sprite_ext(outspr, outindex, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
					}
					draw_set_blend_mode(bm_normal);
					
				surface_reset_target();
			}
		}
		
		with(_surfTopShadow){
			x = _vx;
			y = _vy;
			
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
				
				 // Draw Shadows:
				with(instances_seen_nonsync(_inst, 8, 8)){
					switch(name){
						case "MortarPlasma":
							var	_percent = clamp(96 / (z - 8), 0.1, 1),
								_w = ceil(18 * _percent) * _surfScale,
								_h = ceil(6 * _percent) * _surfScale,
								_x = (x - other.x) * _surfScale,
								_y = (y - other.y - 8) * _surfScale;
								
							draw_ellipse(_x - (_w / 2), _y - (_h / 2), _x + (_w / 2), _y + (_h / 2), false);
							
							break;
							
						default:
							var	_x = x + spr_shadow_x - other.x,
								_y = y + spr_shadow_y - other.y - 8;
								
							if(_surfScale == 1){
								draw_sprite(spr_shadow, 0, _x, _y);
							}
							else{
								draw_sprite_ext(spr_shadow, 0, _x * _surfScale, _y * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
							}
					}
				}
				
				 // Cut Out Floors:
				with(_surfTopShadowMask){
					draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
					draw_surface_scale(
						surf,
						(x - other.x) * other.scale,
						(y - other.y) * other.scale,
						other.scale / scale
					);
					draw_set_blend_mode(bm_normal);
				}
				
			surface_reset_target();
			
			 // Draw Surface:
			draw_set_fog(true, BackCont.shadcol, 0, 0);
			draw_set_alpha(BackCont.shadalpha * 0.9);
			draw_surface_scale(surf, x, y, 1 / scale);
			draw_set_fog(false, 0, 0, 0);
			draw_set_alpha(1);
		}
	}
	
	if(lag) trace_time(script[2]);
	
	instance_destroy();
	
#define draw_pause
	global.paused = true;
	
	 // (Frame Flash) Pet Map Icons:
	if(global.pet_mapicon_pause < 2){
		if(global.pet_mapicon_pause > 0){
			draw_pet_mapicons(UberCont);
		}
		global.pet_mapicon_pause++;
	}
	global.pet_mapicon_pause_force = false;
	
	 // Pause HUD:
	if(instance_exists(PauseButton) || instance_exists(BackMainMenu)){
		if(UberCont.alarm2 < 0){
			 // Dim:
			var _col = c_white;
			if(instance_exists(BackMainMenu)){
				_col = merge_color(_col, c_black, 0.9);
			}
			
			 // Skill HUD:
			if(player_get_show_skills(player_find_local_nonsync())){
				with(surface_setup("HUDSkill", null, null, null)){
					x = view_xview_nonsync + (game_width - w);
					y = view_yview_nonsync;
					draw_surface_ext(surf, x, y, 1 / scale, 1 / scale, 0, _col, 1);
				}
			}
			
			 // Main HUD:
			if(player_get_show_hud(player_find_local_nonsync(), player_find_local_nonsync())){
				with(surface_setup("HUDMain", null, null, null)){
					x = view_xview_nonsync;
					y = view_yview_nonsync;
					draw_surface_ext(surf, x, y, 1 / scale, 1 / scale, 0, _col, 1);
				}
			}
		}
	}
	
#define draw_gui
	 // Game Over Skill HUD:
	if(!instance_exists(Player) && !instance_exists(GenCont) || instance_exists(PopoScene) || instance_exists(LastFire)){
		if(!instance_exists(UnlockScreen)){
			with(UberCont) if(visible){
				if(player_get_show_skills(player_find_local_nonsync())){
					with(surface_setup("HUDSkill", null, null, null)){
						x = view_xview_nonsync + (game_width - w);
						y = view_yview_nonsync;
						draw_surface_scale(surf, x - view_xview_nonsync, y - view_yview_nonsync, 1 / scale);
					}
				}
			}
		}
	}
	
#define draw_gui_end
	 // NTTE Music / Ambience:
	ntte_music();
	
	 // Pet Map Icon Drawing:
	var _mapObj = [TopCont, GenCont, UberCont];
	for(var i = 0; i < array_length(_mapObj); i++){
		var _obj = _mapObj[i];
		with(script_bind_draw(draw_pet_mapicons, (instance_exists(_obj) ? _obj.depth : object_get_depth(_obj)) - 0.1, _obj)){
			persistent = true;
		}
	}
	
	 // NTTE Time Stat:
	stat_set("time", stat_get("time") + (current_time_scale / 30));
	
	 // Reset Mod Calling List:
	ntte_call_mods = [];
	
#define draw_pet_mapicons(_mapObj)
	if(instance_is(self, CustomScript) && script[2] == "draw_pet_mapicons"){
		instance_destroy();
	}
	
	 // Map Index:
	var _mapIndex = GameCont.waypoints;
	if(instance_exists(_mapObj) && _mapObj == TopCont){
		var _last = _mapObj.mapanim;
		if("mapanim_petmapicon_last" in _mapObj) _last = _mapObj.mapanim_petmapicon_last;
		_mapObj.mapanim_petmapicon_last = _mapObj.mapanim;
		
		_mapIndex = clamp(min(_last, _mapObj.mapanim), 0, _mapIndex);
	}
	
	 // Exit Conditions:
	if(instance_exists(_mapObj) || object_exists(_mapObj)){
		 // Check if Can Draw:
		if(array_length(instances_matching(_mapObj, "visible", true)) <= 0){
			exit;
		}
		
		 // Extra Checks:
		switch(_mapObj){
			case UberCont:
				if(!global.pet_mapicon_pause_force || instance_exists(GenCont)){
					if(
						global.pet_mapicon_pause <= 0  ||
						array_length(instances_matching([PauseButton, BackMainMenu, OptionMenuButton, AudioMenuButton, VisualsMenuButton, GameMenuButton, ControlMenuButton], "", null)) <= 0
					){
						exit;
					}
				}
				break;
				
			case TopCont:
				var _last = _mapObj.go_addy1;
				if("go_addy1_petmapicon_last" in _mapObj) _last = _mapObj.go_addy1_petmapicon_last;
				_mapObj.go_addy1_petmapicon_last = _mapObj.go_addy1;
				
				if(instance_exists(Player) || _mapObj.go_addy1 != 0 || _last != 0){
					exit;
				}
				break;
		}
	}
	
	 // Map Position:
	var	_mapEnd = mapdata_get(_mapIndex),
		_mapX = game_width  / 2,
		_mapY = game_height / 2;
		
	if(_mapObj == TopCont){
		_mapX -= 120;
		_mapY += 4;
		if(instance_exists(_mapObj)){
			_mapY -= min(2, _mapObj.go_stage);
		}
	}
	else{
		_mapX -= 70;
		_mapY += 7;
	}
	
	 // Draw Icons:
	if(_mapIndex == 0 || (is_real(_mapEnd.area) && _mapEnd.area >= 0) || (is_string(_mapEnd.area) && mod_exists("area", _mapEnd.area))){
		draw_set_projection(0);
		
		var _playerMax = 0;
		for(var i = 0; i < maxp; i++) if(player_is_active(i)){
			_playerMax = i + 1;
		}
		
		for(var i = 0; i < _playerMax; i++){
			var	_px = _mapX + _mapEnd.x,
				_py = _mapY + _mapEnd.y,
				_iconAng = 30,
				_iconDir = 0,
				_iconDis = 10;
				
			 // Co-op Offset:
			if(_playerMax > 1){
				var	l = 2 * _playerMax,
					d = 90 - ((360 / _playerMax) * i);
					
				if(_playerMax == 2) d += 45;
				
				_px += lengthdir_x(l, d);
				_py += lengthdir_y(l, d);
				
				_iconAng = d;
			}
			
			 // Pet Icons:
			for(var _petNum = 0; _petNum < array_length(global.pet_mapicon[i]); _petNum++){
				var _icon = global.pet_mapicon[i, _petNum];
				
				 // Dim:
				if(instance_exists(BackMainMenu)){
					_icon.col = merge_color(_icon.col, c_black, 0.9);
				}
				
				 // Draw:
				if(sprite_exists(_icon.spr)){
					draw_sprite_ext(
						_icon.spr,
						_icon.img,
						_px + floor(lengthdir_x(_iconDis, _iconAng + _iconDir)) + _icon.x,
						_py + floor(lengthdir_y(_iconDis, _iconAng + _iconDir)) + _icon.y,
						_icon.xsc,
						_icon.ysc,
						_icon.ang,
						_icon.col,
						_icon.alp
					);
				}
				
				_iconDir += 60 / (1 + floor(_iconDir / 360));
				if((_iconDir % 360) == 0) _iconDis += 8;
			}
		}
		
		draw_reset_projection();
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
		
		if(i >= 0 && i < array_length(global.area_mapdata)){
			var	_dataLast = _map[i],
				_waypoint = global.area_mapdata[i];
				
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
					var	_dataNext = mod_script_call("area", _data.area, "area_mapdata", _dataLast.x, _dataLast.y, _dataLast.area, _dataLast.subarea, _data.subarea, _data.loops),
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
	
#define ntte_hud(_visible)
	if(lag) trace_time();
	
	var	_vx = view_xview_nonsync,
		_vy = view_yview_nonsync,
		_gw = game_width,
		_gh = game_height,
		_ox = _vx,
		_oy = _vy;
		
	 // Pause Imminent:
	var _pause = false;
	if(instance_exists(Player)){
		for(var i = 0; i < maxp; i++){
			if(button_pressed(i, "paus")){
				_pause = true;
				break;
			}
		}
	}
	
	/// Co-op:
		var _players = 0;
		for(var i = 0; i < maxp; i++){
			_players += player_is_active(i);
		}
		
		 // Rad Canister Offset:
		if(_players > 1) _ox -= 17;
		
		 // Determine which side of the screen each player's HUD is on:
		var	_hudSide = array_create(maxp, 0),
			_num = 0;
			
		for(var i = 0; i < maxp; i++) if( player_is_local_nonsync(i)) _hudSide[i] = (_num++ & 1);
		for(var i = 0; i < maxp; i++) if(!player_is_local_nonsync(i)) _hudSide[i] = (_num++ & 1);
		
	/// Surface Setup:
		var	_surfScreen = surface_setup("HUDScreen", _gw, _gh, game_scale_nonsync),
			_surfMain   = surface_setup("HUDMain",   _gw, _gh, game_scale_nonsync),
			_surfSkill  = surface_setup("HUDSkill",  _gw, _gh, game_scale_nonsync);
			
		with([_surfMain, _surfSkill, _surfScreen]){
			x = _vx;
			y = _vy;
			
			 // Clear:
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			surface_reset_target();
		}
		
		 // Copy & Clear Screen:
		with(_surfScreen){
			draw_set_blend_mode_ext(bm_one, bm_zero);
			surface_screenshot(surf);
			draw_set_alpha(0);
			draw_surface_scale(surf, x, y, 1 / scale);
			draw_set_alpha(1);
			draw_set_blend_mode(bm_normal);
		}
		
	 // Mutation HUD:
	var	_skillType = [],
		_skillList = [];
		
	with(instances_matching(CustomObject, "name", "OrchidSkill")){
		if(skill_get(skill) != 0){
			array_push(_skillType, "orchid");
			array_push(_skillList, skill);
		}
	}
	if(skill_get(global.hud_reroll) != 0){
		array_push(_skillType, "reroll");
		array_push(_skillList, ((global.hud_reroll == mut_patience && skill_get(GameCont.hud_patience) != 0) ? GameCont.hud_patience : global.hud_reroll));
	}
	
	if(array_length(_skillList) > 0){
		var	_sx = _gw - 11,
			_sy = 12,
			_x = _sx,
			_y = _sy,
			_addx = -16,
			_addy = 16,
			_minx = 110;
			
		 // Co-op Offset:
		if(!_pause && instance_exists(Player)){
			if(_players >= 2){
				_minx = 10;
				_addy *= -1;
				_sy = _gh - 12;
				if(_players >= 3) _minx = 100;
				if(_players >= 4) _sx = _gw - 100;
			}
		}
		
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
		for(var i = 0; !is_undefined(skill_get_at(i)); i++){
			var	_skill = skill_get_at(i),
				_skillIndex = array_find_index(_skillList, _skill);
				
			if(_skillIndex >= 0){
				var	_dx = _x + _ox,
					_dy = _y + _oy;
					
				while(_skillIndex >= 0){
					switch(_skillType[_skillIndex]){
						
						case "reroll": // VAULT FLOWER
							
							draw_sprite(
								spr.SkillRerollHUDSmall,
								0,
								_dx + ((_skill == mut_patience && skill_get(GameCont.hud_patience) != 0) ? -4 : 5),
								_dy + 5
							);
							
							break;
							
						case "orchid": // ORCHID MANTIS
							
							var	_icon = skill_get_icon(_skill),
								_spr = _icon[0],
								_img = _icon[1];
								
							if(sprite_exists(_spr)){
								var	_time    = infinity,
									_timeMax = infinity,
									_colSub  = c_dkgray,
									_colTop  = c_white,
									_flash   = false;
									
								 // Get Orchid Skill With Least Time:
								with(instances_matching(instances_matching(CustomObject, "name", "OrchidSkill"), "skill", _skill)){
									if(time < _time){
										_time    = time;
										_timeMax = time_max;
										_colSub  = color2;
										_colTop  = color1;
									}
									if(flash) _flash = true;
								}
								
								 // Orchid Skill Drawing:
								if(_time > current_time_scale){
									var	_uvs = sprite_get_uvs(_spr, _img),
										_x1 = max(sprite_get_bbox_left  (_spr),     _uvs[4]                                      ),
										_y1 = max(sprite_get_bbox_top   (_spr),     _uvs[5]                                      ),
										_x2 = min(sprite_get_bbox_right (_spr) + 1, _uvs[4] + (_uvs[6] * sprite_get_width (_spr))),
										_y2 = min(sprite_get_bbox_bottom(_spr) + 1, _uvs[5] + (_uvs[7] * sprite_get_height(_spr)));
										
									 // Outline:
									draw_set_fog(true, _colSub, 0, 0);
									for(var d = 0; d < 360; d += 90){
										draw_sprite(_spr, _img, _dx + dcos(d), _dy - dsin(d));
									}
									
									 // Timer Outline:
									draw_set_fog(true, _colTop, 0, 0);
									var _num =  1 - (_time / _timeMax);
									for(var d = 0; d < 360; d += 90){
										var	_l = _x1,
											_t = max(_y1, lerp(_y1 - 1, _y2 + 1, _num) + dsin(d)),
											_w = _x2 - _l,
											_h = _y2 + 1 - _t;
											
										draw_sprite_part(_spr, _img, _l, _t, _w, _h, _dx + _l - sprite_get_xoffset(_spr) + dcos(d), _dy + _t - sprite_get_yoffset(_spr) - dsin(d));
									}
									
									 // Star Flash:
									var	_wave = current_frame + (i * 1000),
										_frames = 60,
										_scale = max(0, (1.1 + (0.1 * sin(_wave / 15))) * ((_time - (_timeMax - _frames)) / _frames)),
										_angle = _wave / 10;
										
									if(_scale > 0){
										if(_flash) draw_set_fog(true, c_white, 0, 0);
										draw_sprite_ext(spr.PetOrchidBall, _wave, _dx, _dy, _scale, _scale, _angle, c_white, 1);
									}
								}
								
								 // Skill Icon:
								draw_set_fog(_flash, c_white, 0, 0);
								draw_sprite(_spr, _img, _dx, _dy);
								draw_set_fog(false, 0, 0, 0);
								draw_set_blend_mode(bm_add);
								draw_sprite_ext(_spr, _img, _dx, _dy, 1, 1, 0, c_white, 0.1 + (0.1 * cos((_timeMax - _time) / 20)));
								draw_set_blend_mode(bm_normal);
							}
							
							break;
							
					}
					
					_skillList = array_delete(_skillList, _skillIndex);
					_skillType = array_delete(_skillType, _skillIndex);
					
					_skillIndex = array_find_index(_skillList, _skill);
				}
				
				if(array_length(_skillList) <= 0) break;
			}
			
			 // Keep it movin:
			if(_skill != mut_patience || GameCont.hud_patience == 0 || GameCont.hud_patience == null){
				_x += _addx;
				if(_x < _minx){
					_x = _sx;
					_y += _addy;
				}
			}
		}
	}
	
	 // Copy Skill Drawing & Clear Screen:
	surface_screenshot(_surfSkill.surf);
	with(_surfScreen){
		if(_visible && instance_exists(Player) && player_get_show_skills(player_find_local_nonsync())){
			surface_screenshot(surf);
		}
		draw_set_blend_mode_ext(bm_one, bm_zero);
		draw_set_alpha(0);
		draw_surface_scale(surf, x, y, 1 / scale);
		draw_set_alpha(1);
		draw_set_blend_mode(bm_normal);
	}
	
	 // Player HUD:
	for(var _index = 0; _index < maxp; _index++) if(player_is_active(_index)){
		var	_player = player_find(_index),
			_side = _hudSide[_index],
			_flip = (_side ? -1 : 1),
			_HUDVisible = (_visible && player_get_show_hud(_index, player_find_local_nonsync())),
			_HUDMain = (player_find_local_nonsync() == _index);
			
		draw_set_projection(2, _index);
		
		if(instance_exists(_player)){
			 // Non-nonsync Stuff:
			with(_player){
				 // Bonus Ammo:
				if("bonus_ammo" in self){
					if("bonus_ammo_last" not in self) bonus_ammo_last = 0;
				}
				
				 // Bonus HP:
				if("bonus_health" in self){
					if("bonus_health_max"  not in self) bonus_health_max = 0;
					if("bonus_health_last" not in self) bonus_health_last = 0;
					if("bonus_health_hud"  not in self) bonus_health_hud = 0;
					
					 // Max Bonus HP:
					if(bonus_health > 0){
						if(bonus_health == bonus_health_last){
							var _diff = (bonus_health - bonus_health_max);
							if(abs(_diff) > 1/3){
								_diff *= 0.25 * current_time_scale;
							}
							bonus_health_max += _diff;
						}
						bonus_health_max = max(bonus_health, bonus_health_max);
					}
					else bonus_health_max = 0;
					
					 // Last Bonus HP:
					bonus_health_last = min(bonus_health_last, bonus_health_max);
					
					 // Expand HUD:
					bonus_health_hud += ((bonus_health > 0) - bonus_health_hud) * 0.5 * current_time_scale;
				}
				
				 // Feathers:
				if(race == "parrot"){
					var m = ceil(feather_ammo_max / feather_num);
					if(array_length(feather_ammo_hud) != m){
						feather_ammo_hud = array_create(m);
						for(var i = 0; i < m; i++) feather_ammo_hud[i] = [0, 0];
					}
					
					/*
					 // Flash:
					if(feather_ammo < feather_ammo_max) feather_ammo_hud_flash = 0;
					else feather_ammo_hud_flash += current_time_scale;
					*/
				}
			}
			
			if(_HUDVisible || _HUDMain){
				 // Bonus Ammo HUD:
				with(instances_matching_gt(_player, "bonus_ammo", 0)){
					var _textCol = (
						(bonus_ammo != bonus_ammo_last)
						? c_white
						: (
							(drawempty > 26 && ammo[weapon_get_type(wep)] + bonus_ammo < weapon_get_cost(wep))
							? c_red
							: merge_color(c_aqua, c_blue, 0.1 + (0.05 * sin((current_frame / 20))))
						)
					);
					
					draw_set_font(fntSmall);
					draw_set_halign(fa_right);
					draw_set_valign(fa_top);
					
					draw_text_nt(
						_ox + 66,
						_oy + 30 - (_players > 1),
						`@(color:${_textCol})+${bonus_ammo}`
					);
				}
				
				 // Bonus HP HUD:
				with(instances_matching_ne(_player, "bonus_health", null)){
					var	_x1 = _ox + 106 - (85 * _side),
						_y1 = _oy + 5,
						_x2 = _x1 + (3 * bonus_health_hud * _flip),
						_y2 = _y1 + 10;
						
					if(_side ? (_x1 > _x2 + 1) : (_x2 > _x1 + 1)){
						draw_set_color(c_black);
						draw_rectangle(_x1, _y1 - 1, _x2 + _flip, _y2 + 2, false); // Shadow
						draw_set_color(c_white);
						draw_rectangle(_x1, _y1, _x2, _y2, false); // Outline
						draw_set_color(c_black);
						draw_rectangle(_x1, _y1 + 1, _x2 - _flip, _y2 - 1, false); // Inset
						
						 // Filling:
						var	_fx = ((_x1 + _x2) / 2) - _flip,
							_fy = _y2 - 1,
							_fw = _x2 - _x1,
							_fh = _fy - (_y1 + 1),
							_col = merge_color(c_aqua, c_blue, 0.15 + (0.05 * cos(current_frame / 20)));
							
						if(bonus_health_last > bonus_health){
							draw_set_color(merge_color(_col, c_black, 0.5));
							draw_line_width(_fx, _fy - max(_fh * (bonus_health_last / bonus_health_max), 1 / game_scale_nonsync), _fx, _fy, _fw);
						}
						if(bonus_health > 0){
							var	_fy1 = _fy - max(_fh * (bonus_health / bonus_health_max), 1 / game_scale_nonsync),
								_fy2 = _fy;
								
							draw_set_color(_col);
							draw_line_width(_fx, _fy1, _fx, _fy2, _fw);
							
							 // Flash / Cell Highlight:
							var	_flashHealth = (current_frame / 6) % (2 + bonus_health_max),
								_flashHurt   = ((sprite_index == spr_hurt && image_index < 1 && player_active) || (lsthealth < my_health && lsthealth <= 1));
								
							if(
								_flashHurt
								|| bonus_health_last < bonus_health
								|| (my_health <= 1 && _flashHealth < bonus_health && bonus_health == bonus_health_max)
							){
								var	_flashNum = (_flashHurt ? 0 : clamp(1 - (0.5 * abs(bonus_health - bonus_health_last)), 0, 1)),
									_flashCol = merge_color(c_white, merge_color(_col, c_white, min(0.8, 1 - frac(_flashHealth))), _flashNum),
									_flashY   = _fy,
									_flashH   = max(_fh / bonus_health_max, 1 / game_scale_nonsync);
									
								if(_flashHealth < bonus_health){
									_flashY = _fy - (_fh * ((floor(_flashHealth) + 0.5) / bonus_health_max));
								}
								
								draw_set_color(_flashCol);
								
								draw_line_width(
									_fx,
									clamp(lerp(_fy1, _flashY - (_flashH / 2), _flashNum), _fy1, _fy2),
									_fx,
									clamp(lerp(_fy2, _flashY + (_flashH / 2), _flashNum), _fy1, _fy2),
									_fw
								);
							}
							
							 // Text:
							var _textCol = (
								(_flashHurt || (bonus_health - bonus_health_last) >= 2/3)
								? c_white
								: merge_color(c_aqua, c_blue, 0.1 + (0.05 * cos((current_frame / 20))))
							);
							draw_set_font(fntSmall);
							draw_set_halign(fa_left);
							draw_set_valign(fa_top);
							draw_text_nt(
								_x1 - 3,
								_y2 + 2,
								`@(color:${_textCol})+${bonus_health}`
							);
						}
					}
				}
				
				 // Parrot:
				with(instances_matching(_player, "race", "parrot")){
					var _skinCol = (bskin ? make_color_rgb(24, 31, 50) : make_color_rgb(114, 2, 10));
					
					 // Ultra B:
					if(charm_hplink_hud > 0){
						var	_HPCur = max(0, my_health),
							_HPMax = max(0, maxhealth),
							_HPLst = max(0, lsthealth),
							_HPCurCharm = max(0, charm_hplink_hud_hp[0]),
							_HPMaxCharm = max(0, charm_hplink_hud_hp[1]),
							_HPLstCharm = max(0, charm_hplink_hud_hp_lst),
							_w = 83,
							_h = 7,
							_x = _ox + 22,
							_y = _oy + 7,
							_HPw = floor(_w * (1 - (0.7 * charm_hplink_hud)));
							
						draw_set_halign(fa_center);
						draw_set_valign(fa_middle);
						
						 // Main BG:
						draw_set_color(c_black);
						draw_rectangle(_x, _y, _x + _w, _y + _h, false);
							
						/// Charmed HP:
							var	_x1 = _x + _HPw + 2,
								_x2 = _x + _w;
								
							if(_x1 < _x2){
								 // lsthealth Filling:
								if(_HPLstCharm > _HPCurCharm){
									draw_set_color(merge_color(
										merge_color(_skinCol, player_get_color(index), 0.5),
										make_color_rgb(21, 27, 42),
										2/3
									));
									draw_rectangle(_x1, _y, lerp(_x1, _x2, clamp(_HPLstCharm / _HPMaxCharm, 0, 1)), _y + _h, false);
								}
								
								 // my_health Filling:
								if(_HPCurCharm > 0 && _HPMaxCharm > 0){
									draw_set_color(
										(sprite_index == spr_hurt && image_index < 1)
										? c_white
										: merge_color(_skinCol, player_get_color(index), 0.5)
									);
									draw_rectangle(_x1, _y, lerp(_x1, _x2, clamp(_HPCurCharm / _HPMaxCharm, 0, 1)), _y + _h, false);
								}
								
								 // Text:
								var _HPText = `${_HPCurCharm}/${_HPMaxCharm}`;
								draw_set_font(
									(string_length(_HPText) > 7 || ((string_length(_HPText) - 1) * 8) >= _x2 - _x1)
									? fntSmall
									: fntM
								);
								draw_text_nt(min(floor(lerp(_x1, _x + _w, 0.54)), _x + _w - (string_width(_HPText) / 2)), _y + 1 + floor(_h / 2), _HPText);
							}
							
						/// Normal HP:
							 // BG:
							draw_set_color(c_black);
							draw_rectangle(_x, _y, _x + _HPw, _y + _h, false);
							
							 // lsthealth Filling: (Color is like 95% accurate, I did a lot of trial and error)
							if(_HPLst > _HPCur){
								draw_set_color(merge_color(
									player_get_color(index),
									make_color_rgb(21, 27, 42),
									2/3
								));
								draw_rectangle(_x, _y, _x + floor(_HPw * clamp(_HPLst / _HPMax, 0, 1)), _y + _h, false);
							}
							
							 // my_health Filling:
							if(_HPCur > 0 && _HPMax > 0){
								draw_set_color(
									(_HPLst < _HPCur)
									? c_white
									: player_get_color(index)
								);
								draw_rectangle(_x, _y, _x + floor(_HPw * clamp(_HPCur / _HPMax, 0, 1)), _y + _h, false);
							}
							
							 // Text:
							if(_HPLst >= _HPCur || sin(wave) > 0){
								var _HPText = `${_HPCur}/${_HPMax}`;
								draw_set_font(
									(string_length(_HPText) > 6 * (1 - charm_hplink_hud))
									? fntSmall
									: fntM
								);
								draw_text_nt(_x + floor(_HPw * 0.55), _y + 1 + floor(_h / 2), _HPText);
							}
							
						 // Separator:
						if(_HPw < _w){
							draw_set_color(c_white);
							draw_line_width(_x + _HPw + 1, _y - 2, _x + _HPw + 1, _y + _h, 1);
							if(_HPw + 1 < _w){
								draw_set_color(c_black);
								draw_line_width(_x + _HPw + 2, _y - 2, _x + _HPw + 2, _y + _h, 1);
							}
						}
					}
					
					 // Parrot Feathers:
					var	_x = _ox + 116 - (104 * _side) + (3 * variable_instance_get(id, "bonus_health_hud", 0) * _flip),
						_y = _oy + 11,
						_spr = race_get_sprite(race, sprChickenFeather),
						_sprHUD = race_get_sprite(race, sprRogueAmmoHUD),
						_output = feather_num_mult,
						_feathers = instances_matching(instances_matching(CustomObject, "name", "ParrotFeather"), "creator", id),
						_hudGoal = [feather_ammo, 0];
						
					with(instances_matching_ne(_feathers, "canhud", true)){
						if(canhold) canhud = true;
					}
					for(var i = 0; i < array_length(_hudGoal); i++){
						_hudGoal[i] += array_length(instances_matching(_feathers, "canhud", true));
					}
					
					for(var i = 0; i < array_length(feather_ammo_hud); i++){
						var	_hud = feather_ammo_hud[i],
							_xsc = _flip,
							_ysc = 1,
							_col = merge_color(c_white, c_black, clamp((_hud[1] / _hud[0]) - 1/3, 0, 1)),
							_alp = 1,
							_dx = _x + (5 * i * _flip),
							_dy = _y;
							
						 // Gradual Fill Change:
						for(var j = 0; j < array_length(_hudGoal); j++){
							var _diff = clamp((_hudGoal[j] - (feather_num * i)) / feather_num, 0, 1) - _hud[j];
							if(_diff != 0){
								if((j == 1 && _diff > 0) || abs(_diff) < 0.01){
									_hud[j] += _diff;
								}
								else{
									_hud[j] += _diff * 2/3 * current_time_scale;
								}
							}
						}
						
						 // Extend Shootable Feathers:
						if(i < _output && _hud[0] > 0){
							_dx -= _flip;
							if(_hud[0] > _hud[1]) _dy++;
						}
						
						 // Draw:
						draw_sprite_ext(_sprHUD, 0, _dx, _dy, _xsc, _ysc, 0, c_white, 1);
						_dx -= sprite_get_xoffset(_spr) * _xsc;
						_dy -= sprite_get_yoffset(_spr) * _ysc;
						for(var j = 0; j < array_length(_hud); j++){
							if(_hud[j] > 0){
								var	_l = 0,
									_t = 0,
									_w = max(1, sprite_get_width(_spr) * _hud[j]),
									_h = sprite_get_height(_spr);
									
								draw_set_fog(j, merge_color(_skinCol, player_get_color(index), 0.5), 0, 0);
								draw_sprite_part_ext(_spr, 0, _l, _t, _w, _h, _dx + _l, _dy + _t, _xsc, _ysc, _col, _alp);
								
								 // Separation Line:
								if(_hud[j] < 1 && _hud[0] > _hud[1]){
									_l += _w - 1;
									_w = 1;
									draw_set_fog(true, merge_color(_skinCol, player_get_color(index), 0.2 * j), 0, 0);
									draw_sprite_part_ext(_spr, 0, _l, _t, _w, _h, _dx + (_l * _xsc), _dy + _t, _xsc, _ysc, _col, _alp);
								}
								
								/*
								 // Flash:
								if(j == 0 && feather_ammo_hud_flash > 0){
									var	_flash = ((feather_ammo_hud_flash - 1 - array_length(feather_ammo_hud) - (i * _flip)) % 150),
										_flashAlpha = _alp * ((3 - _flash) / 5);
										
									if(_flash >= 0 && _flashAlpha > 0){
										if(!_pause){
											draw_set_fog(true, merge_color(_skinCol, c_white, 1), 0, 0);
											draw_sprite_part_ext(_spr, 0, _l, _t, _w, _h, _dx + _l, _dy + _t, _xsc, _ysc, _col, _flashAlpha);
										}
									}
								}
								*/
							}
						}
						draw_set_fog(false, 0, 0, 0);
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
									draw_text_nt(_ox + 110, _oy + 7, `@(color:${c_red})LOW HP`);
								}
							}
						}
					}
				}
			}
			
			 // Non-nonsync Stuff Pt.2:
			with(_player){
				 // Bonus Ammo:
				if("bonus_ammo" in self){
					var _diff = (bonus_ammo - bonus_ammo_last);
					if(abs(_diff) > 1/2){
						_diff *= current_time_scale / 2.5;
					}
					bonus_ammo_last += _diff;
				}
				
				 // Bonus HP:
				if("bonus_health" in self && sprite_index != spr_hurt){
					var _diff = (bonus_health - bonus_health_last);
					if(abs(_diff) > 1/5){
						_diff *= current_time_scale / 3;
					}
					bonus_health_last += _diff;
				}
			}
		}
		
		draw_reset_projection();
		
		 // Copy HUD Drawing & Clear Screen:
		if(_HUDMain){
			surface_screenshot(_surfMain.surf);
		}
		with(_surfScreen){
			if(_HUDVisible){
				surface_screenshot(surf);
			}
			draw_set_blend_mode_ext(bm_one, bm_zero);
			draw_set_alpha(0);
			draw_surface_scale(surf, x, y, 1 / scale);
			draw_set_alpha(1);
			draw_set_blend_mode(bm_normal);
		}
	}
	
	 // Redraw Screen:
	with(_surfScreen){
		draw_set_blend_mode_ext(bm_one, bm_zero);
		draw_surface_scale(surf, x, y, 1 / scale);
		draw_set_blend_mode(bm_normal);
	}
	
	 // Indicator HUD:
	if(_visible){
		 // Coast Indicator:
		if(instance_exists(Player)){
			with(instances_matching(instances_matching_ge(Portal, "endgame", 100), "coast_portal", true)){
				var p = player_find_local_nonsync();
				if(point_seen(x, y, p)){
					var	_size = 4,
						_x = x,
						_y = y;
						
					 // Drawn to Player:
					with(player_find(p)){
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
			draw_set_alpha(1);
			
			 // Pet Indicator:
			with(instances_matching(CustomHitme, "name", "Pet")){
				var _draw = false;
				
				 // Death Conditions:
				if(instance_exists(revive)){
					if(instance_exists(leader)){
						_draw = true;
						with(revive) with(pickup_indicator){
							if(instance_exists(nearwep) && array_length(instances_matching(Player, "nearwep", nearwep)) > 0){
								_draw = false;
							}
						}
					}
				}
				
				 // Normal Conditions:
				else if(visible && "index" in leader && player_is_local_nonsync(leader.index) && !point_seen(x, y, leader.index)){
					_draw = true;
				}
				
				if(_draw){
					var _icon = pet_get_icon(mod_type, mod_name, pet);
					
					if(sprite_exists(_icon.spr)){
						var	_x = x + _icon.x,
							_y = y + _icon.y;
							
						 // Death Pointer:
						if(instance_exists(revive)){
							_y -= 20 + sin(wave / 10);
							draw_sprite_ext(spr.PetArrow, _icon.img, _x, _y + (sprite_get_height(_icon.spr) - sprite_get_yoffset(_icon.spr)), _icon.xsc, _icon.ysc, 0, _icon.col, _icon.alp);
						}
						
						 // Icon:
						var	_x1 = sprite_get_xoffset(_icon.spr),
							_y1 = sprite_get_yoffset(_icon.spr),
							_x2 = _x1 - sprite_get_width(_icon.spr) + _gw,
							_y2 = _y1 - sprite_get_height(_icon.spr) + _gh;
							
						_x = _vx + clamp(_x - _vx, _x1 + 1, _x2 - 1);
						_y = _vy + clamp(_y - _vy, _y1 + 1, _y2 - 1);
						
						draw_sprite_ext(_icon.spr, _icon.img, _x, _y, _icon.xsc, _icon.ysc, _icon.ang, _icon.col, _icon.alp);
						
						 // Death Indicating:
						if(instance_exists(revive)){
							var	_flashLength = 15,
								_flashDelay = 10,
								_flash = (current_frame % (_flashLength + _flashDelay));
								
							if(_flash < _flashLength){
								draw_set_blend_mode(bm_add);
								draw_sprite_ext(_icon.spr, _icon.img, clamp(_x, _x1, _x2), clamp(_y, _y1, _y2), _icon.xsc, _icon.ysc, _icon.ang, _icon.col, _icon.alp * (1 - (_flash / _flashLength)));
								draw_set_blend_mode(bm_normal);
							}
						}
					}
				}
			}
			
			 // Alert Indicators:
			with(instances_matching(instances_matching(CustomObject, "name", "AlertIndicator"), "visible", true)){
				if(canview || !point_seen(x, y, player_find_local_nonsync())){
					var	_flash    = max(1, flash),
						_spr      = sprite_index,
						_img      = image_index,
						_xsc      = image_xscale,
						_ysc      = image_yscale / _flash,
						_ang      = image_angle,
						_col      = image_blend,
						_alp      = abs(image_alpha),
						_x        = round(_vx + clamp(x - _vx, (x - bbox_left) + 1, _gw - ((bbox_right  + 1) - x) - 2)),
						_y        = round(_vy + clamp(y - _vy, (y - bbox_top ) + 1, _gh - ((bbox_bottom + 1) - y) - 1) + ((3 / _flash) * (_flash - 1))),
						_alertSpr = lq_defget(alert, "spr", -1),
						_alertCan = sprite_exists(_alertSpr);
						
					if(flash > 0) draw_set_fog(true, image_blend, 0, 0);
					
					 // Alert (!) Shadow:
					if(_alertCan){
						var	_alertImg = lq_defget(alert, "img", current_frame * image_speed),
							_alertX   = _x + (lq_defget(alert, "x", 0) * _xsc),
							_alertY   = _y + (lq_defget(alert, "y", 0) * _ysc),
							_alertXSc = lq_defget(alert, "xsc", _xsc),
							_alertYSc = lq_defget(alert, "ysc", _ysc),
							_alertAng = lq_defget(alert, "ang", 0),
							_alertCol = lq_defget(alert, "col", c_white),
							_alertAlp = lq_defget(alert, "alp", _alp);
							
						for(var	_ox = -1; _ox <= 1; _ox++){
							for(var	_oy = -1; _oy <= 2; _oy++){
								draw_sprite_ext(
									_alertSpr,
									_alertImg,
									_alertX + lengthdir_x(_ox * _alertXSc, _ang) + lengthdir_x(_oy * _alertYSc, _ang - 90),
									_alertY + lengthdir_y(_ox * _alertXSc, _ang) + lengthdir_y(_oy * _alertYSc, _ang - 90),
									_alertXSc,
									_alertYSc,
									_alertAng,
									c_black,
									_alertAlp
								);
							}
						}
					}
					
					 // Main Icon:
					draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
					
					 // Alert (!)
					if(_alertCan){
						draw_sprite_ext(_alertSpr, _alertImg, _alertX, _alertY, _alertXSc, _alertYSc, _alertAng, _alertCol, _alertAlp);
					}
					
					if(flash > 0) draw_set_fog(false, 0, 0, 0);
				}
			}
		}
	}
	
	draw_set_font(fntM);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	
	if(lag) trace_time("ntte_hud");
	
	instance_destroy();
	
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
			if(array_exists(ntte_area, _area)){
				if(mod_script_exists("area", _area, "area_music_boss")){
					alarm_set(2, -1);
					_mus = mod_script_call("area", _area, "area_music_boss");
				}
			}
		}
		
		 // Music / Ambience:
		if(alarm_get(11) > 0 && alarm_get(11) <= ceil(current_time_scale)){
			if(array_exists(ntte_area, _area)){
				if(mod_script_exists("area", _area, "area_music") || mod_script_exists("area", _area, "area_ambient")){
					alarm_set(11, -1);
					
					 // Update MusCont:
					if(_area != global.mus_area){
						event_perform(ev_alarm, 11);
					}
					
					_mus = mod_script_call("area", _area, "area_music");
					_amb = mod_script_call("area", _area, "area_ambient");
				}
			}
			global.mus_area = _area;
		}
		
		 // Play:
		if(is_real(_mus)){
			if(sound_play_music(_mus)){
				var _snd = sound_play_pitchvol(0, 0, 0);
				sound_stop(_snd);
				global.mus_current = _snd - 1;
			}
		}
		if(is_real(_amb)){
			if(sound_play_ambient(_amb)){
				var _snd = sound_play_pitchvol(0, 0, 0);
				sound_stop(_snd);
				global.amb_current = _snd - 1;
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
		num = 0.1;
		
		 // Visual:
		spr_slct = race_get_sprite(_race, sprFishMenu);
		spr_menu = race_get_sprite(_race, sprFishMenuSelected);
		spr_to   = race_get_sprite(_race, sprFishMenuSelect);
		spr_from = race_get_sprite(_race, sprFishMenuDeselect);
		sprite_index = spr_slct;
		
		 // Auto Offset:
		var _tries = 1000;
		while(_tries-- > 0){
			 // Move Somewhere:
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
		
		return id;
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
#macro  anim_end                                                                                (image_index + image_speed_raw >= image_number || image_index + image_speed_raw < 0)
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
#define pround(_num, _precision)                                                        return  (_num == 0) ? _num : round(_num / _precision) * _precision;
#define pfloor(_num, _precision)                                                        return  (_num == 0) ? _num : floor(_num / _precision) * _precision;
#define pceil(_num, _precision)                                                         return  (_num == 0) ? _num :  ceil(_num / _precision) * _precision;
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
#define area_get_name(_area, _subarea, _loops)                                          return  mod_script_call_nc('mod', 'telib', 'area_get_name', _area, _subarea, _loops);
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call(   'mod', 'telib', 'area_get_sprite', _area, _spr);
#define area_get_subarea(_area)                                                         return  mod_script_call_nc('mod', 'telib', 'area_get_subarea', _area);
#define area_get_secret(_area)                                                          return  mod_script_call_nc('mod', 'telib', 'area_get_secret', _area);
#define area_get_underwater(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_underwater', _area);
#define area_get_back_color(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_back_color', _area);
#define area_get_shad_color(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_shad_color', _area);
#define area_border(_y, _area, _color)                                                  return  mod_script_call_nc('mod', 'telib', 'area_border', _y, _area, _color);
#define area_generate(_area, _sub, _loops, _x, _y, _setArea, _overlapFloor, _scrSetup)  return  mod_script_call_nc('mod', 'telib', 'area_generate', _area, _sub, _loops, _x, _y, _setArea, _overlapFloor, _scrSetup);
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
#define move_step(_mult)                                                                return  mod_script_call(   'mod', 'telib', 'move_step', _mult);
#define scrPickupIndicator(_text)                                                       return  mod_script_call(   'mod', 'telib', 'scrPickupIndicator', _text);
#define scrAlert(_inst, _sprite)                                                        return  mod_script_call(   'mod', 'telib', 'scrAlert', _inst, _sprite);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   'mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_instance, _charm)                                               return  mod_script_call_nc('mod', 'telib', 'charm_instance', _instance, _charm);
#define door_create(_x, _y, _dir)                                                       return  mod_script_call_nc('mod', 'telib', 'door_create', _x, _y, _dir);
#define pool(_pool)                                                                     return  mod_script_call_nc('mod', 'telib', 'pool', _pool);
#define teevent_set_active(_name, _active)                                              return  mod_script_call_nc('mod', 'teevents', 'teevent_set_active', _name, _active);
#define teevent_get_active(_name)                                                       return  mod_script_call_nc('mod', 'teevents', 'teevent_get_active', _name);