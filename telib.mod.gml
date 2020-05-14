#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	lag = false;
	
	 // Add an object to this list if you want it to appear in cheats mod spawn menu or if you want to specify create event arguments for it in global.objectScrt:
	ntte_obj_list = {
		"tegeneral"   : ["AlertIndicator", "BigDecal", "BoneArrow", "BoneSlash", "BoneFX", "BuriedVault", "CustomBullet", "CustomFlak", "CustomShell", "CustomPlasma", "GroundFlameGreen", "Igloo", "MergeFlak", "ParrotFeather", "ParrotChester", "Pet", "PetRevive", "PetWeaponBecome", "PetWeaponBoss", "PortalBullet", "PortalGuardian", "PortalPrevent", "ReviveNTTE", "TopDecal", "TopObject", "VenomPellet", "WallDecal", "WallEnemy"],
		"tepickups"   : ["Backpack", "Backpacker", "BackpackPickup", "BatChest", "BigIDPDSpawn", "BoneBigPickup", "BonePickup", "BuriedVaultChest", "BuriedVaultChestDebris", "BuriedVaultPedestal", "CatChest", "ChestShop", "CursedAmmoChest", "CursedMimic", "CustomChest", "CustomPickup", "HammerHeadPickup", "HarpoonPickup", "OrchidChest", "OrchidSkill", "OrchidSkillBecome", "OverhealChest", "OverhealMimic", "OverhealPickup", "OverstockChest", "OverstockMimic", "OverstockPickup", "PalaceAltar", "PalankingStatue", "PickupIndicator", "Pizza", "PizzaChest", "PizzaStack", "SpiritPickup", "SunkenChest", "SunkenCoin", "VaultFlower", "VaultFlowerSparkle", "WepPickupGrounded", "WepPickupStick"],
		"tedesert"    : ["BabyScorpion", "BabyScorpionGold", "BanditCamper", "BanditHiker", "BanditTent", "BigCactus", "BigMaggotSpawn", "Bone", "CoastBossBecome", "CoastBoss", "CowSkull", "FlySpin", "PetVenom", "ScorpionRock", "WantBigMaggot"],
		"tecoast"     : ["BloomingAssassin", "BloomingAssassinHide", "BloomingBush", "BloomingCactus", "BuriedCar", "ClamShield", "ClamShieldSlash", "CoastBigDecal", "CoastDecal", "CoastDecalCorpse", "Creature", "Diver", "DiverHarpoon", "Gull", "Harpoon", "HarpoonStick", "NetNade", "Palanking", "PalankingDie", "PalankingSlash", "PalankingSlashGround", "PalankingToss", "Palm", "Pelican", "Seal", "SealAnchor", "SealDisc", "SealHeavy", "SealMine", "TrafficCrab", "Trident"],
		"teoasis"     : ["BubbleBomb", "BubbleExplosion", "BubbleExplosionSmall", "CrabTank", "Crack", "Hammerhead", "HyperBubble", "OasisPetBecome", "Puffer", "SunkenRoom", "SunkenSealSpawn", "WaterStreak"],
		"tetrench"    : ["Angler", "Eel", "EelSkull", "ElectroPlasma", "ElectroPlasmaImpact", "Jelly", "JellyElite", "Kelp", "LightningDisc", "LightningDiscEnemy", "PitSpark", "PitSquid", "PitSquidArm", "PitSquidBomb", "PitSquidDeath", "QuasarBeam", "QuasarRing", "TeslaCoil", "TopDecalWaterMine", "TrenchFloorChunk", "Vent", "WantEel"],
		"tesewers"    : ["AlbinoBolt", "AlbinoGator", "AlbinoGrenade", "BabyGator", "Bat", "BatBoss", "BatCloud", "BatDisc", "BatScreech", "BoneGator", /*"BossHealFX",*/ "Cabinet", "Cat", "CatBoss", "CatBossAttack", "CatDoor", "CatDoorDebris", "CatGrenade", "CatHole", "CatHoleBig", "CatLight", "ChairFront", "ChairSide", "Couch", "GatorStatue", "GatorStatueFlak", "Manhole", "NewTable", "Paper", "PizzaDrain", "PizzaManholeCover", "PizzaRubble", "PizzaTV", "SewerDrain", "SewerRug", "TurtleCool", "VenomFlak"],
		"tescrapyard" : ["BoneRaven", "SawTrap", "SludgePool", "TopRaven", "Tunneler"],
		"tecaves"     : ["ChaosHeart", "Clone", "CrystalBrain", "CrystalHeart", "CrystalHeartProj", "CrystalPropRed", "CrystalPropWhite", "InvMortar", "Mortar", "MortarPlasma", "NewCocoon", "PlasmaImpactSmall", "RedSpider", "Spiderling", "TwinOrbital", "VlasmaBullet", "WallFake", "Warp", "WarpPortal"],
		"telabs"      : ["FreakChamber", "MutantVat", "WallSlide"]
	};
	
	 // Auto Create Event Script References:
	ntte_obj_scrt = {};
	for(var i = 0; i < lq_size(ntte_obj_list); i++){
		var	_modName = lq_get_key(ntte_obj_list, i),
			_modObjs = lq_get_value(ntte_obj_list, i);
			
		with(_modObjs){
			var _name = self;
			lq_set(ntte_obj_scrt, _name, script_ref_create_ext("mod", _modName, _name + "_create"));
		}
	}
	
	 // Object Event Reference:
	ntte_obj_event = ds_map_create();
	ntte_obj_event[? CustomObject    ] = ["step", "begin_step", "end_step", "draw", "destroy", "cleanup"];
	ntte_obj_event[? CustomHitme     ] = ["step", "begin_step", "end_step", "draw", "destroy", "hurt", "cleanup"];
	ntte_obj_event[? CustomProp      ] = ["step", "death"];
	ntte_obj_event[? CustomProjectile] = ["step", "begin_step", "end_step", "draw", "destroy", "cleanup", "hit", "wall", "anim"];
	ntte_obj_event[? CustomSlash     ] = ["step", "begin_step", "end_step", "draw", "destroy", "cleanup", "hit", "wall", "anim", "grenade", "projectile"];
	ntte_obj_event[? CustomEnemy     ] = ["step", "begin_step", "end_step", "draw", "destroy", "hurt", "death", "cleanup"];
	with(ds_map_keys(ntte_obj_event)){
		for(var i = ntte_alarm_min; i < ntte_alarm_max; i++){
			array_push(ntte_obj_event[? self], `alrm${i}`);
		}
	}
	
	 // Script Binding Object Lists:
	ntte_obj_bind = {
		"begin_step" : [],
		"step"       : [],
		"end_step"   : [],
		"draw"       : [],
	};
	
	 // Projectile Team Variants:
	var _teamGrid = [
		[[spr.EnemyBullet,				EnemyBullet4	],	[sprBullet1,			Bullet1				],	[sprIDPDBullet,			IDPDBullet		]], // Bullet
		[[sprEnemyBulletHit								],	[sprBulletHit								],	[sprIDPDBulletHit						]], // Bullet Hit
		[[spr.EnemyHeavyBullet,			"CustomBullet"	],	[sprHeavyBullet,		HeavyBullet			],	[										]], // Heavy Bullet
		[[spr.EnemyHeavyBulletHit						],	[sprHeavyBulletHit							],	[										]], // Heavy Bullet Hit
		[[sprLHBouncer,					LHBouncer		],	[sprBouncerBullet,		BouncerBullet		],	[										]], // Bouncer Bullet
		[[sprLHBouncer,					LHBouncer		],	[sprBouncerShell,		BouncerBullet		],	[										]], // Bouncer Bullet 2
		[[sprEnemyBullet1,				EnemyBullet1	],	[sprAllyBullet,			AllyBullet			],	[										]], // Bandit Bullet
		[[sprEnemyBulletHit								],	[sprAllyBulletHit							],	[sprIDPDBulletHit						]], // Bandit Bullet Hit
		[[sprEnemyBullet4,				EnemyBullet4	],	[spr.AllySniperBullet,	AllyBullet			],	[										]], // Sniper Bullet
		[[sprEBullet3,					EnemyBullet3	],	[sprBullet2,			Bullet2				],	[										]], // Shell
		[[sprEBullet3Disappear,			EnemyBullet3	],	[sprBullet2Disappear,	Bullet2				],	[										]], // Shell Disappear
		[[spr.EnemySlug,				"CustomShell"	],	[sprSlugBullet,			Slug				],	[sprPopoSlug,			PopoSlug		]], // Slug
		[[spr.EnemySlugDisappear,		"CustomShell"	],	[sprSlugDisappear,		Slug				],	[sprPopoSlugDisappear,	PopoSlug		]], // Slug Disappear
		[[spr.EnemySlugHit								],	[sprSlugHit									],	[sprIDPDBulletHit						]], // Slug Hit
		[[spr.EnemySlug,				"CustomShell"	],	[sprHyperSlug,			Slug				],	[sprPopoSlug,			PopoSlug		]], // Hyper Slug
		[[spr.EnemySlugDisappear,		"CustomShell"	],	[sprHyperSlugDisappear,	Slug				],	[sprPopoSlugDisappear,	PopoSlug		]], // Hyper Slug Disappear
		[[spr.EnemyHeavySlug,			"CustomShell"	],	[sprHeavySlug,			HeavySlug			],	[										]], // Heavy Slug
		[[spr.EnemyHeavySlugDisappear,	"CustomShell"	],	[sprHeavySlugDisappear,	HeavySlug			],	[										]], // Heavy Slug Disappear
		[[spr.EnemyHeavySlugHit							],	[sprHeavySlugHit,							],	[										]], // Heavy Slug Hit
		[[sprEFlak,						"CustomFlak"	],	[sprFlakBullet,			FlakBullet			],	[										]], // Flak
		[[sprEFlakHit									],	[sprFlakHit									],	[										]], // Flak Hit
		[[spr.EnemySuperFlak,			"CustomFlak"	],	[sprSuperFlakBullet,	SuperFlakBullet		],	[										]], // Super Flak
		[[spr.EnemySuperFlakHit							],	[sprSuperFlakHit							],	[										]], // Super Flak Hit
		[[sprEFlak,						EFlakBullet		],	[sprFlakBullet,			"CustomFlak"		],	[										]], // Gator Flak
		[[sprTrapFire									],	[sprWeaponFire								],	[sprFireLilHunter						]], // Fire
		[[sprSalamanderBullet							],	[sprDragonFire								],	[sprFireLilHunter						]], // Fire 2
		[[sprTrapFire									],	[sprCannonFire								],	[sprFireLilHunter						]], // Fire 3
		//[[sprFireBall									],	[sprFireBall								],	[										]], // Fire Ball
		//[[sprFireShell								],	[sprFireShell								],	[										]], // Fire Shell
		[[sprEnemyLaser,				EnemyLaser		],	[sprLaser,				Laser				],	[										]], // Laser
		[[sprEnemyLaserStart							],	[sprLaserStart								],	[										]], // Laser Start
		[[sprEnemyLaserEnd								],	[sprLaserEnd								],	[										]], // Laser End
		[[sprLaserCharge								],	[spr.AllyLaserCharge						],	[										]], // Laser Particle
		[[sprEnemyLightning								],	[sprLightning								],	[										]], // Lightning
		//[[sprLightningHit								],	[sprLightningHit							],	[										]], // Lightning Hit
		//[[sprLightningSpawn							],	[sprLightningSpawn							],	[										]], // Lightning Particle
		[[spr.EnemyPlasmaBall,			"CustomPlasma"	],	[sprPlasmaBall,			PlasmaBall			],	[sprPopoPlasma,			PopoPlasmaBall	]], // Plasma
		[[spr.EnemyPlasmaBig,			"CustomPlasma"	],	[sprPlasmaBallBig,		PlasmaBig			],	[										]], // Plasma Big
		[[spr.EnemyPlasmaHuge,			"CustomPlasma"	],	[sprPlasmaBallHuge,		PlasmaHuge			],	[										]], // Plasma Huge
		[[spr.EnemyPlasmaImpact							],	[sprPlasmaImpact							],	[sprPopoPlasmaImpact					]], // Plasma Impact
		[[spr.EnemyPlasmaImpactSmall					],	[spr.PlasmaImpactSmall						],	[										]], // Plasma Impact Small
		[[spr.EnemyPlasmaTrail							],	[sprPlasmaTrail								],	[sprPopoPlasmaTrail						]], // Plasma Particle
		[[spr.EnemyVlasmaBullet							],	[spr.VlasmaBullet							],	[										]], // Vector Plasma
		[[sprEnemySlash									],	[sprSlash									],	[sprEnemySlash							]]  // Slash
		// Devastator
		// Lightning Cannon
		// Hyper Slug (kinda)
	];
	
	spriteTeamMap = ds_map_create();
	teamSpriteMap = ds_map_create();
	teamSpriteObjectMap = ds_map_create();
	
	with(_teamGrid){
		var	_teamList = self,
			_teamSize = array_length(_teamList),
			_sprtList = array_create(_teamSize, -1),
			_objsList = array_create(_teamSize, -1);
			
		for(var i = 0; i < _teamSize; i++){
			var _team = _teamList[i];
			if(array_length(_team) > 0) _sprtList[i] = _team[0];
			if(array_length(_team) > 1) _objsList[i] = _team[1];
		}
		
		 // Compiling Sprite Maps:
		with(_sprtList){
			var _sprt = self;
			if(sprite_exists(_sprt)){
				if(!ds_map_exists(teamSpriteMap, _sprt)){
					teamSpriteMap[? _sprt] = _sprtList;
				}
				if(!ds_map_exists(spriteTeamMap, _sprt)){
					spriteTeamMap[? _sprt] = spriteTeamStart + array_find_index(_sprtList, _sprt);
				}
			}
		}
		
		 // Compiling Object~Object Map:
		with(_objsList){
			var _obj = self;
			if(!is_real(_obj) || object_exists(_obj)){
				if(!ds_map_exists(teamSpriteObjectMap, _obj)){
					var _map = ds_map_create();
					
					with(_teamGrid){
						var	_tList = self,
							_tSize = array_length(_tList),
							_sList = array_create(_tSize, -1),
							_oList = array_create(_tSize, -1);
							
						for(var i = 0; i < _tSize; i++){
							var _team = _tList[i];
							if(array_length(_team) > 0) _sList[i] = _team[0];
							if(array_length(_team) > 1) _oList[i] = _team[1];
						}
						
						for(var i = 0; i < _tSize; i++){
							if(_oList[i] == _obj){
								var _sprt = _sList[i];
								if(!ds_map_exists(_map, _sprt)) _map[? _sprt] = _oList;
							}
						}
					}
					
					teamSpriteObjectMap[? _obj] = _map;
				}
			}
		}
	}
	
	 // floor_set():
	floor_reset_style();
	floor_reset_align();
	
	 // sleep_max():
	global.sleep_max = 0;
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#macro mod_type_current script_ref_create(0)[0]

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
#macro area_pizza_sewers 102
#macro area_mansion      103
#macro area_cursed_caves 104
#macro area_jungle       105
#macro area_hq           106
#macro area_crib         107

#macro current_frame_active ((current_frame % 1) < current_time_scale)
#macro anim_end (image_index + image_speed_raw >= image_number)

#macro bbox_center_x (bbox_left + bbox_right + 1) / 2
#macro bbox_center_y (bbox_top + bbox_bottom + 1) / 2
#macro bbox_width    (bbox_right + 1) - bbox_left
#macro bbox_height   (bbox_bottom + 1) - bbox_top

#macro FloorNormal instances_matching(Floor, "object_index", Floor)

#macro ntte_alarm_min 0
#macro ntte_alarm_max 11

#macro ntte_obj_base  [CustomObject, CustomHitme, CustomEnemy, CustomProp, CustomProjectile];
#macro ntte_obj_event global.object_event
#macro ntte_obj_list  global.object_list
#macro ntte_obj_scrt  global.object_scrt
#macro ntte_obj_bind  global.object_bind

#macro spriteTeamStart     1
#macro spriteTeamMap       global.sprite_team_map
#macro teamSpriteMap       global.team_sprite_map
#macro teamSpriteObjectMap global.team_sprite_object_map

#macro infinity 1/0

#define obj_create(_x, _y, _name)
	if(is_real(_name) && object_exists(_name)){
		return instance_create(_x, _y, _name);
	}
	
	 // Search for Create Event if Unstored:
	if(!lq_exists(ntte_obj_scrt, _name) && is_string(_name)){
		for(var i = 0; i < lq_size(ntte_obj_list); i++){
			var _modName = lq_get_key(ntte_obj_list, i);
			if(mod_script_exists("mod", _modName, _name + "_create")){
				lq_set(ntte_obj_scrt, _name, script_ref_create_ext("mod", _modName, _name + "_create"));
			}
		}
	}
	
	 // Creating Object:
	if(lq_exists(ntte_obj_scrt, _name)){
		 // Call Create Event:
		var	_scrt = array_combine(lq_get(ntte_obj_scrt, _name), [_x, _y]),
			_inst = script_ref_call(_scrt);
			
		if(is_undefined(_inst) || _inst == 0){
			_inst = noone;
		}
		
		 /// Auto Assign Things:
		if(is_real(_inst) && instance_exists(_inst)){
			with(_inst){
				name = _name;
				
				var	_isCustom = ds_map_exists(ntte_obj_event, object_index),
					_modType = _scrt[0],
					_modName = _scrt[1];
					
				 // Bind Events:
				with(
					_isCustom
					? ntte_obj_event[? object_index]
					: ["step", "begin_step", "end_step", "draw"]
				){
					var _event = self;
					if(("on_" + _event) not in _inst || is_undefined(variable_instance_get(_inst, "on_" + _event))){
						var _varName = (_isCustom ? "on_" : "ntte_bind_") + _event;
						if(_isCustom || _varName not in _inst || is_undefined(variable_instance_get(_inst, _varName))){
							var _modScrt = _name + "_" + _event;
							
							if(mod_script_exists(_modType, _modName, _modScrt)){
								variable_instance_set(_inst, _varName, script_ref_create_ext(_modType, _modName, _modScrt));
								
								 // Auto Script Binding:
								if(!_isCustom){
									if(!lq_exists(ntte_obj_bind, _event)){
										lq_set(ntte_obj_bind, _event, []);
									}
									
									 // Bind Script:
									var _bind = instances_matching(instances_matching(CustomScript, "name", "obj_bind"), "type", _event);
									if(_event == "draw"){
										_bind = instances_matching(_bind, "depth", _inst.depth);
									}
									if(array_length(_bind) <= 0){
										switch(_event){
											case "step"       : _bind = script_bind_step(obj_bind, 0);           break;
											case "begin_step" : _bind = script_bind_begin_step(obj_bind, 0);     break;
											case "end_step"   : _bind = script_bind_end_step(obj_bind, 0);       break;
											case "draw"       : _bind = script_bind_draw(obj_bind, _inst.depth); break;
										}
										with(_bind){
											name = script[2];
											type = _event;
											inst = [];
											inst_obj = lq_get(ntte_obj_bind, type);
											persistent = true;
										}
									}
									with(_bind){
										array_push(inst, _inst);
										
										 // Add to Object List:
										var _obj = _inst.object_index;
										for(var i = _obj; object_exists(i); i = object_get_parent(i)){
											if(array_exists(inst_obj, i)){
												_obj = -1;
												break;
											}
										}
										if(object_exists(_obj)){
											with(inst_obj){
												if(object_is_ancestor(self, _obj)){
													other.inst_obj = array_delete_value(other.inst_obj, self);
												}
											}
											array_push(inst_obj, _obj);
										}
										with(instances_matching(instances_matching(CustomScript, "name", name), "type", type)){
											inst_obj = other.inst_obj;
										}
										lq_set(ntte_obj_bind, type, inst_obj);
									}
								}
							}
							
							 // Defaults:
							else if(_isCustom){
								with(_inst){
									switch(_event){
										case "hurt":
											on_hurt = enemy_hurt;
											break;
											
										case "death":
											if(instance_is(self, CustomEnemy)){
												on_death = enemy_death;
											}
											break;
											
										case "draw":
											if(instance_is(self, CustomEnemy)){
												on_draw = draw_self_enemy;
											}
											break;
									}
								}
							}
						}
					}
				}
				
				 // Automatic Stuff:
				if(_isCustom){
					on_create = script_ref_create(obj_create, _x, _y, _name);
					
					 // Animation:
					if("ntte_anim" not in self){
						if(instance_is(self, CustomEnemy)){
							ntte_anim = true;
						}
					}
					if("ntte_anim" in self && ntte_anim){
						if("spr_chrg" not in self){
							spr_chrg = -1;
						}
					}
					
					 // Walking:
					if("ntte_walk" not in self){
						if("walk" in self){
							ntte_walk = true;
						}
					}
					if("ntte_walk" in self && ntte_walk){
						if("walkspeed" not in self) walkspeed = 0.8;
						if("maxspeed"  not in self) maxspeed = 3;
					}
					
					 // hitmes:
					if(instance_is(self, hitme)){
						 // Fill HP:
						if(my_health == 1){
							if(instance_is(self, CustomHitme) || instance_is(self, CustomProp)){
								my_health = maxhealth;
							}
						}
						
						 // Set Sprite:
						if(sprite_index == -1 && "spr_idle" in self){
							sprite_index = spr_idle;
						}
					}
				}
			}
		}
		
		return _inst;
	}
	
	 // Return List of Objects:
	else if(is_undefined(_name)){
		var _list = [];
		
		for(var i = 0; i < lq_size(ntte_obj_list); i++){
			_list = array_combine(_list, lq_get_value(ntte_obj_list, i));
		}
		
		return _list;
	}
	
	return noone;
	
#define obj_begin_step
	/*
		Performs alarms, movement, and animation code for NTTE's "Custom" objects
		Called from ntte.mod's 'ntte_begin_step' event
	*/
	
	var _obj = ntte_obj_base;
	
	 // Debugging Lag:
	if(lag){
		trace("");
		
		 // Override Events:
		with(instances_matching_ne(_obj, "on_begin_step", null)){
			if(array_length(on_begin_step) >= 3){
				ntte_begin_step = on_begin_step;
				on_begin_step = [];
			}
		}
		with(instances_matching_ne(_obj, "on_step", null)){
			if(array_length(on_step) >= 3){
				ntte_step = on_step;
				on_step = [];
			}
		}
		with(instances_matching_ne(_obj, "on_end_step", null)){
			if(array_length(on_end_step) >= 3){
				ntte_end_step = on_end_step;
				on_end_step = [];
			}
		}
		
		 // Bind Events:
		if(array_length(instances_matching(CustomScript, "name", "obj_step")) <= 0){
			with(script_bind_step(obj_step, 0)){
				name = script[2];
				persistent = true;
			}
		}
		if(array_length(instances_matching(CustomScript, "name", "obj_end_step")) <= 0){
			with(script_bind_end_step(obj_end_step, 0)){
				name = script[2];
				persistent = true;
			}
		}
		
		 // Manual Begin Step:
		var _inst = instances_matching_ne(_obj, "ntte_begin_step", null);
		trace_time();
		with(_inst){
			mod_script_call(ntte_begin_step[0], ntte_begin_step[1], ntte_begin_step[2]);
		}
		trace_time("obj_begin_step");
	}
	
	 // Alarms:
	for(var i = ntte_alarm_min; i < ntte_alarm_max; i++){
		var	_alrm = `on_alrm${i}`,
			_inst = instances_matching_ne(instances_matching_ge(_obj, `alarm${i}`, 0), _alrm, null);
			
		array_sort(_inst, true);
		
		with(_inst){
			var _num = alarm_get(i) - 1;
			alarm_set(i, _num);
			
			 // Call Event:
			if(_num == 0){
				var _scrt = variable_instance_get(self, _alrm);
				if(array_length(_scrt) >= 3){
					with(self) mod_script_call(_scrt[0], _scrt[1], _scrt[2]); // !!! Use 'script_ref_call()' once GMS2 version become stable
				}
			}
		}
	}
	
	 // Movement:
	with(instances_matching(_obj, "ntte_walk", true)){
		if(walk > 0){
			motion_add(direction, walkspeed);
			walk -= current_time_scale;
		}
		if(speed > maxspeed) speed = maxspeed; // Max Speed
	}
	
	 // Animate:
	with(instances_matching(_obj, "ntte_anim", true)){
		if(sprite_index != spr_chrg){
			if(sprite_index != spr_hurt || anim_end){
				sprite_index = ((speed <= 0) ? spr_idle : spr_walk);
			}
		}
	}
	
	if(lag) trace_time("obj_begin_step Misc");
	
#define obj_step
	/*
		Manually performs all "Custom" object step events for debugging lag
	*/
	
	var	_obj = ntte_obj_base,
		_inst = instances_matching_ne(_obj, "ntte_step", null);
		
	if(lag) trace_time();
	
	with(_inst){
		mod_script_call(ntte_step[0], ntte_step[1], ntte_step[2]);
	}
	
	if(lag) trace_time("obj_step");
	
	 // Goodbye:
	else instance_destroy();
	
#define obj_end_step
	/*
		Manually performs all "Custom" object end step events for debugging lag
	*/
	
	var	_obj = ntte_obj_base,
		_inst = instances_matching_ne(_obj, "ntte_end_step", null);
		
	if(lag) trace_time();
	
	with(_inst){
		mod_script_call(ntte_end_step[0], ntte_end_step[1], ntte_end_step[2]);
	}
	
	if(lag) trace_time("obj_end_step");
	
	 // Goodbye:
	else{
		instance_destroy();
		
		 // Reset Events:
		with(instances_matching_ne(_obj, "ntte_begin_step", null)){
			on_begin_step = ntte_begin_step;
			ntte_begin_step = null;
		}
		with(instances_matching_ne(_obj, "ntte_step", null)){
			on_step = ntte_step;
			ntte_step = null;
		}
		with(instances_matching_ne(_obj, "ntte_end_step", null)){
			on_end_step = ntte_end_step;
			ntte_end_step = null;
		}
	}
	
#define obj_bind
	/*
		A script bind controller that calls scripts for NTTE's non-"Custom" objects
	*/
	
	if(lag) trace_time();
	
	var	_varName = "ntte_bind_" + type,
		_isDraw  = (type == "draw"),
		_bind    = instances_matching(instances_matching(CustomScript, "name", name), "type", type);
		
	 // No Copies:
	with(instances_matching(instances_matching_ne(_bind, "id", id), "depth", depth)){
		other.inst = array_combine(other.inst, inst);
		instance_destroy();
	}
	
	 // Changed Depth:
	if(_isDraw){
		with(instances_matching_ne(inst, "depth", depth)){
			if(array_length(instances_matching(_bind, "depth", depth)) <= 0){
				with(script_bind_draw(obj_bind, depth)){
					name = script[2];
					type = "draw";
					inst = [other];
					inst_obj = lq_get(ntte_obj_bind, type);
					persistent = true;
				}
			}
		}
	}
	
	 // Collect Instances:
	inst = instances_matching_ne(inst_obj, _varName, null);
	if(_isDraw){
		inst = instances_matching(inst, "depth", depth);
	}
	
	 // Call Scripts:
	with(_isDraw ? instances_matching(inst, "visible", true) : inst){
		var _scrt = variable_instance_get(self, _varName);
		if(array_length(_scrt) > 2){
			mod_script_call(_scrt[0], _scrt[1], _scrt[2]);
		}
	}
	
	if(lag) trace_time(name + "_" + type);
	
	 // Goodbye:
	if(array_length(inst) <= 0){
		if(array_length(instances_matching(_bind, "inst_obj", inst_obj)) <= 1){
			lq_set(ntte_obj_bind, type, []);
		}
		instance_destroy();
	}
	
#define step
	 // sleep_max():
	if(global.sleep_max > 0){
		sleep(global.sleep_max);
		global.sleep_max = 0;
	}
	
	
/// SCRIPTS
#define draw_self_enemy()
	image_xscale *= right;
	draw_self(); // This is faster than draw_sprite_ext yea
	image_xscale /= right;
	
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)
	draw_sprite_ext(_sprite, 0, _x - lengthdir_x(_wkick, _ang), _y - lengthdir_y(_wkick, _ang), 1, _flip, _ang + (_meleeAng * (1 - (_wkick / 20))), _blend, _alpha);
	
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)
	var	_sx = _x,
		_sy = _y,
		_lx = _sx,
		_ly = _ly,
		_md = _maxDistance,
		d = _md,
		m = 0; // Minor hitscan increment distance
		
	while(d > 0){
		 // Major Hitscan Mode (Start at max, go back until no collision line):
		if(m <= 0){
			_lx = _sx + lengthdir_x(d, _dir);
			_ly = _sy + lengthdir_y(d, _dir);
			d -= sqrt(_md);
			
			 // Enter minor hitscan mode:
			if(!collision_line(_sx, _sy, _lx, _ly, Wall, false, false)){
				m = 2;
				d = sqrt(_md);
			}
		}
		
		 // Minor Hitscan Mode (Move until collision):
		else{
			if(position_meeting(_lx, _ly, Wall)) break;
			_lx += lengthdir_x(m, _dir);
			_ly += lengthdir_y(m, _dir);
			d -= m;
		}
	}
	
	draw_line_width(_sx, _sy, _lx, _ly, _width);
	
	return [_lx, _ly];
	
#define draw_surface_scale(_surf, _x, _y, _scale)
	/*
		Draws a given surface at a given position with a given scale
		Useful when working with surfaces that support pixel scaling
	*/
	
	draw_surface_ext(_surf, _x, _y, _scale, _scale, 0, c_white, draw_get_alpha());
	
#define draw_text_bn(_x, _y, _string, _angle)
	var _col = draw_get_color();
	_string = string_upper(_string);
	
	draw_set_color(c_black);
	draw_text_transformed(_x + 1, _y,     _string, 1, 1, _angle);
	draw_text_transformed(_x,     _y + 2, _string, 1, 1, _angle);
	draw_text_transformed(_x + 1, _y + 2, _string, 1, 1, _angle);
	draw_set_color(_col);
	draw_text_transformed(_x,     _y,     _string, 1, 1, _angle);
	
#define string_delete_nt(_string)
	/*
		Returns a given string with "draw_text_nt()" formatting removed
		
		Ex:
			string_delete_nt("@2(sprBanditIdle:0)@rBandit") == "  Bandit"
			string_width(string_delete_nt("@rHey")) == 3
	*/
	
	var	_split = "@",
		_stringSplit = string_split(_string, _split),
		_stringSplitMax = array_length(_stringSplit);
		
	for(var i = 1; i < _stringSplitMax; i++){
		if(_stringSplit[i - 1] != _split){
			var	_current = _stringSplit[i],
				_char = string_upper(string_char_at(_current, 1));
				
			switch(_char){
				case "": // CANCEL : "@@rHey" -> "@rHey"
					
					if(i < _stringSplitMax - 1){
						_current = _split;
					}
					
					break;
					
				case "W":
				case "S":
				case "D":
				case "R":
				case "G":
				case "B":
				case "P":
				case "Y":
				case "Q": // BASIC : "@qHey" -> "Hey"
					
					_current = string_delete(_current, 1, 1);
					
					break;
					
				case "0":
				case "1":
				case "2":
				case "3":
				case "4":
				case "5":
				case "6":
				case "7":
				case "8":
				case "9": // SPRITE OFFSET : "@2(sprBanditIdle:1)Hey" -> "  Hey"
					
					if(string_char_at(_current, 2) == "("){
						_current = string_delete(_current, 1, 1);
						
						 // Offset if Drawing Sprite:
						var _spr = string_split(string_copy(_current, 2, string_pos(")", _current) - 2), ":")[0];
						if(
							real(_spr) > 0                       ||
							sprite_exists(asset_get_index(_spr)) ||
							_spr == "sprKeySmall"                ||
							_spr == "sprButSmall"                ||
							_spr == "sprButBig"
						){
							// draw_text_nt uses width of "A" instead of " ", so this is slightly off on certain fonts
							if(string_width(" ") > 0){
								_current = string_repeat(" ", real(_char) * (string_width("A") / string_width(" "))) + _current;
							}
						}
					}
					
					 // NONE : "@2Hey" -> "@2Hey"
					else{
						_current = _split + _current;
						break;
					}
					
				case "(": // ADVANCED : "@(sprBanditIdle:1)Hey" -> "Hey"
					
					var	_bgn = string_pos("(", _current),
						_end = string_pos(")", _current);
						
					if(_bgn < _end){
						_current = string_delete(_current, _bgn, 1 + _end - _bgn);
						break;
					}
					
				default: // NONE : "@Hey" -> "@Hey"
					
					_current = _split + _current;
			}
			
			_stringSplit[i] = _current;
		}
	}
	
	return array_join(_stringSplit, "");
	
#define scrWalk(_dir, _walk)
	walk = (is_array(_walk) ? random_range(_walk[0], _walk[1]) : _walk);
	speed = max(speed, friction);
	direction = _dir;
	if("gunangle" not in self) scrRight(direction);
	
#define scrRight(_dir)
	_dir = ((_dir % 360) + 360) % 360;
	if(_dir < 90 || _dir > 270) right = 1;
	if(_dir > 90 && _dir < 270) right = -1;
	
#define scrAim(_dir)
	if("gunangle" in self){
		gunangle = ((_dir % 360) + 360) % 360;
	}
	scrRight(_dir);
	
#define enemy_shoot(_object, _dir, _spd)
	return enemy_shoot_ext(x, y, _object, _dir, _spd);

#define enemy_shoot_ext(_x, _y, _object, _dir, _spd)
	var _inst = obj_create(_x, _y, _object);
	
	with(_inst){
		speed += _spd;
		direction = _dir;
		image_angle = direction;
		if("hitid" in other) hitid = other.hitid;
		if("team" in other) team = other.team;
		
		 // Auto-Creator:
		creator = other;
		while("creator" in creator && !instance_is(creator, hitme)){
			creator = creator.creator;
		}
		
		 // Euphoria:
		if(instance_is(self, CustomProjectile)){
			speed *= power(0.8, skill_get(mut_euphoria));
		}
	}
	
	return _inst;

#define enemy_walk(_spdAdd, _spdMax)
	if(walk > 0){
		motion_add(direction, _spdAdd);
		walk -= current_time_scale;
	}
	if(speed > _spdMax) speed = _spdMax;

#define enemy_hurt(_hitdmg, _hitvel, _hitdir)
	my_health -= _hitdmg;			// Damage
	motion_add(_hitdir, _hitvel);	// Knockback
	nexthurt = current_frame + 6;	// I-Frames
	sound_play_hit(snd_hurt, 0.3);	// Sound

	 // Hurt Sprite:
	sprite_index = spr_hurt;
	image_index = 0;

#define enemy_death
	pickup_drop(16, 0); // Bandit drop-ness

#define enemy_target(_x, _y)
	/*
		Base game targeting for consistency, cause with consistency u can have clever solutions
	*/
	
	if(instance_exists(Player)){
		target = instance_nearest(_x, _y, Player);
	}
	else if(target < 0){
		target = noone;
	}
	
	return instance_exists(target);
	
#define chest_create(_x, _y, _obj)
	/*
		Creates a given chest with some special spawn conditions applied, such as Crown of Love, Crown of Life, and Rogue
		!!! Don't use this for replacing chests with custom chests, put that in level_start or something
		
		Ex:
			chest_create(x, y, WeaponChest)
			chest_create(x, y, "BatChest")
	*/
	
	if(
		is_string(_obj)
		|| _obj == chestprop
		|| _obj == RadChest
		|| object_is_ancestor(_obj, chestprop)
		|| object_is_ancestor(_obj, RadChest)
	){
		 // Rad Canisters:
		if(is_real(_obj) && (_obj == RadChest || object_is_ancestor(_obj, RadChest))){
			 // More Health Chests:
			if(chance(2, 3) && crown_current == crwn_life){
				_obj = HealthChest;
			}
			
			 // Rogue:
			else for(var i = 0; i < maxp; i++){
				if(player_get_race(i) == "rogue"){
					_obj = RogueChest;
					break;
				}
			}
		}
		
		 // Only Ammo Chests:
		if(crown_current == crwn_love){
			if(!is_real(_obj) || !object_is_ancestor(_obj, AmmoChest)){
				if(!array_exists([ProtoChest, RogueChest, "Backpack", "BuriedVaultChest", "CatChest", "CursedAmmoChest", "SunkenChest"], _obj)){
					_obj = AmmoChest;
				}
			}
		}
	}
	
	var _inst = obj_create(_x, _y, _obj);
	
	 // Replaced:
	if(!instance_exists(_inst)){
		with(instances_matching_gt(chestprop, "id", _inst)){
			_inst = min(_inst, id);
		}
	}
	
	return _inst;
	
#define chance(_numer, _denom)
	return random(_denom) < _numer;

#define chance_ct(_numer, _denom)
	return random(_denom) < (_numer * current_time_scale);

#define in_distance(_inst, _dis)
	if(!instance_exists(_inst)) return false;

	 // If '_inst' is an object, find nearest object:
	if(object_exists(_inst)){
		_inst = instance_nearest(x, y, _inst);
	}

	 // If '_dis' is an array it means [min, max], otherwise 'min = 0' and 'max = _dis':
	if(!is_array(_dis)) _dis = [0, _dis];
	else while(array_length(_dis) < 2){
		array_push(_dis, 0);
	}

	 // Return if '_inst' is within min and max distances:
	var d = point_distance(x, y, _inst.x, _inst.y);
	return (d >= _dis[0] && d <= _dis[1]);

#define in_sight(_inst)
	if(!instance_exists(_inst)) return false;
	
	 // If '_inst' is an object, find nearest object:
	if(object_exists(_inst)){
		_inst = instance_nearest(x, y, _inst);
	}
	
	 // Return if '_inst' is in line of sight:
	return !collision_line(x, y, _inst.x, _inst.y, Wall, false, false);
	
#define save_get(_name, _default)
	return mod_script_call("mod", "teassets", "save_get", _name, _default);
	
#define save_set(_name, _value)
	mod_script_call("mod", "teassets", "save_set", _name, _value);
	
#define option_get(_name)
	return mod_script_call("mod", "teassets", "option_get", _name);
	
#define option_set(_name, _value)
	mod_script_call("mod", "teassets", "option_set", _name, _value);
	
#define stat_get(_name)
	return mod_script_call("mod", "teassets", "stat_get", _name);
	
#define stat_set(_name, _value)
	mod_script_call("mod", "teassets", "stat_set", _name, _value);
	
#define unlock_get(_name)
	return mod_script_call("mod", "teassets", "unlock_get", _name);
	
#define unlock_set(_name, _value)
	return mod_script_call("mod", "teassets", "unlock_set", _name, _value);
	
#define unlock_get_name(_name)
	/*
		Returns the title associated with a given unlock's corner splat
	*/
	
	 // Specific:
	switch(_name){
		case "skin:red crystal": return "RED CRYSTAL";
	}
	
	 // General:
	var _split = string_split(_name, ":");
	
	if(array_length(_split) >= 2){
		switch(_split[0]){
			
			case "pack": // PACK
				
				var _pack = _split[1];
				
				switch(_pack){
					case "coast"  : return "BEACH GUNS";
					case "oasis"  : return "BUBBLE GUNS";
					case "trench" : return "TECH GUNS";
					case "lair"   : return "SAWBLADE GUNS";
				}
					
				return _pack;
				
			case "race": // CHARACTER
				
				return race_get_title(_split[1]);
				
			case "skin": // SKIN
				
				var	_race = "",
					_skin = _split[1];
					
				 // Race Mod:
				if(array_length(_split) > 2){
					_race = _skin;
					_skin = real(_split[2]);
				}
				
				 // Skin Mod:
				else if(mod_exists("skin", _skin)){
					_race = mod_script_call("skin", _skin, "skin_race");
				}
				
				 // Get Unlock Name:
				var _skinName = race_get_title(_race) + " " + string_upper(skin_get_name(_race, _skin));
				if(string_delete(_skinName, 1, string_length(_skinName) - 4) != "SKIN"){
					_skinName += " SKIN";
				}
				
				return _skinName;
				
			case "wep": // WEAPON
				
				return weapon_get_name(_split[1]);
				
			case "crown": // CROWN
				
				return crown_get_name(_split[1]);
				
			case "loadout": // LOADOUT
				
				switch(_split[1]){
					
					case "wep":
						
						return weapon_get_name(unlock_get(_name));
						
					case "crown":
						
						if(array_length(_split) > 2){
							return crown_get_name(_split[2]) + "@s";
						}
						
						break;
						
				}
				
				break;
				
		}
	}
	
	return "";
	
#define unlock_get_text(_name)
	/*
		Returns the description associated with a given unlock's corner splat
	*/
	
	var _split = string_split(_name, ":");
	
	if(array_length(_split) >= 2){
		switch(_split[0]){
			
			case "pack": // PACK
				
				switch(_split[1]){
					case "coast"  : return "GRAB YOUR FRIENDS";
					case "oasis"  : return "SOAP AND WATER";
					case "trench" : return "TERRORS FROM THE DEEP";
					case "lair"   : return "DEVICES OF TORTURE";
				}
				
				break;
				
			case "race": // CHARACTER
				
				var	_race = _split[1],
					_text = mod_script_call("race", _race, "race_unlock");
					
				 // Loading Tip:
				if(!is_string(_text)){
					_text = mod_script_call("skin", _race, "race_ttip");
				}
				
				if(is_string(_text)){
					return _text;
				}
				
				break;
				
			case "skin": // SKIN
				
				var	_skin = _split[1],
					_text = "";
					
				 // Race Mod:
				if(array_length(_split) > 2){
					var _race = _skin;
					_skin = real(_split[2]);
					_text = mod_script_call("race", _race, "race_skin_unlock", _skin);
				}
				
				 // Skin Mod:
				else if(mod_exists("skin", _skin)){
					_text = mod_script_call("skin", _skin, "skin_unlock");
					
					 // Loading Tip:
					if(!is_string(_text)){
						_text = mod_script_call("skin", _skin, "skin_ttip");
					}
				}
				
				if(is_string(_text)){
					return _text;
				}
				
				break;
				
			case "wep": // WEAPON
				
				var	_wep = _split[1],
					_text = mod_script_call("weapon", _wep, "weapon_unlock", _wep);
					
				 // Loading Tip:
				if(!is_string(_text)){
					_text = mod_script_call("weapon", _wep, "weapon_text", _wep);
				}
				
				if(is_string(_text)){
					return _text;
				}
				
				break;
				
			case "crown": // CROWN
				
				var	_crown = _split[1],
					_text = mod_script_call("crown", _crown, "crown_unlock");
				
				 // Loading Tip:
				if(!is_string(_text)){
					_text = mod_script_call("weapon", _crown, "crown_tip");
				}
				
				if(is_string(_text)){
					return _text;
				}
				
				break;
				
			case "loadout": // LOADOUT
				
				switch(_split[1]){
					case "wep"   : return "STORED!";
					case "crown" : return "FOR @w" + ((array_length(_split) > 3) ? race_get_title(_split[3]) : "EVERYONE");
				}
				
				break;
		}
	}
	
	return "";
	
#define unlock_splat(_name, _text, _sprite, _sound)
	 // Make Sure UnlockCont Exists:
	if(array_length(instances_matching(CustomObject, "name", "UnlockCont")) <= 0){
		obj_create(0, 0, "UnlockCont");
	}
	
	 // Add New Unlock:
	var _unlock = {
		"nam" : [_name, _name], // [splash popup, gameover popup]
		"txt" : _text,
		"spr" : _sprite,
		"img" : 0,
		"snd" : _sound
	};
	
	with(instances_matching(CustomObject, "name", "UnlockCont")){
		if(splash_index >= array_length(unlock) - 1 && splash_timer <= 0){
			splash_delay = 40;
		}
		array_push(unlock, _unlock);
	}
	
	return _unlock;
	
#define scrPickupIndicator(_text)
	with(obj_create(x, y, "PickupIndicator")){
		text = _text;
		creator = other;
		depth = other.depth;
		return id;
	}
	return noone;
	
#define scrAlert(_inst, _sprite)
	 // Group:
	if((is_real(_inst) && object_exists(_inst)) || is_array(_inst)){
		var a = [];
		with(_inst) array_push(a, scrAlert(self, _sprite));
		return a;
	}
	
	 // Normal:
	else{
		var	_x = 0,
			_y = 0;
			
		if(instance_exists(_inst)){
			_x = _inst.x;
			_y = _inst.y;
		}
		else{
			if("x" in self) _x = x;
			if("y" in self) _y = y;
		}
		
		with(obj_create(_x, _y, "AlertIndicator")){
			target = _inst;
			sprite_index = _sprite;
			image_index = irandom(image_number - 1);
			
			 // Auto-Offset:
			if(instance_exists(target)){
				var	_h1 = abs((sprite_get_yoffset(target.sprite_index) - sprite_get_bbox_top(target.sprite_index)) * image_yscale),
					_h2 = abs(((sprite_get_bbox_bottom(sprite_index) + 1) - sprite_get_yoffset(sprite_index)) * image_yscale);
					
				target_y = -(1 + _h1 + _h2);
			}
			alert.x = (sprite_get_bbox_left(sprite_index) - sprite_get_xoffset(sprite_index));
			
			return id;
		}
	}
	
	return noone;

#define charm_instance(_inst, _charm)
	var _bind = instances_matching(CustomScript, "name", "charm_step");
	
	 // Bind Script:
	if(array_length(_bind) <= 0){
		_bind = script_bind_end_step(0, 0);
		with(_bind){
			script = script_ref_create_ext("race", "parrot", "charm_step")
			name = script[2];
			inst = [];
			vars = [];
		}
	}
	
	 // Charm/Uncharm:
	var _instVars = [];
	with(_inst) if(instance_exists(self)){
		if("ntte_charm" not in self){
			ntte_charm = {
				"charmed"    : false,
				"target"     : noone,
				"on_step"    : [],     // Custom object step event
				"index"      : -1,     // Player who charmed
				"team"       : -1,     // Original team before charming
				"time"       : 0,      // Charm duration in frames
				"time_speed" : 1,      // Charm duration decrement speed
				"walk"       : 0,      // For overwriting movement on certain dudes (Assassin, big dog)
				"boss"       : false,  // Instance is a boss
				"kill"       : false   // Kill when uncharmed (For dudes who were spawned by charmed dudes)
			};
		}
		
		var _vars = ntte_charm;
		
		if(_charm ^^ _vars.charmed){
			_vars.charmed = _charm;
			_vars.target = noone;
			_vars.index = -1;
			_vars.time = 0;
			
			 // Charm:
			if(_charm){
				 // Frienderize Team:
				_vars.team = variable_instance_get(self, "team", -1);
				if("team" in self){
					team = 2;
					
					 // Teamerize Nearby Projectiles:
					with(instances_matching(instances_matching(projectile, "creator", id), "team", _vars.team)){
						if(place_meeting(x, y, other)){
							team = other.team;
							team_instance_sprite(team, self);
						}
					}
				}
				
				 // Custom (Override Step Event):
				if(string_pos("Custom", object_get_name(object_index)) == 1){
					_vars.on_step = on_step;
					on_step = [];
				}
				
				 // Normal (Delay Alarms):
				else for(var a = 0; a <= 10; a++){
					if(alarm_get(a) > 0){
						alarm_set(a, alarm_get(a) + ceil(current_time_scale));
					}
				}
				
				 // Boss Check:
				_vars.boss = (("boss" in self && boss) || array_exists([BanditBoss, ScrapBoss, LilHunter, Nothing, Nothing2, FrogQueen, HyperCrystal, TechnoMancer, Last, BigFish, OasisBoss], object_index));
				
				 // Charm Duration Speed:
				_vars.time_speed = (_vars.boss ? 2 : 1);
				
				 // Necromancer Charm:
				switch(sprite_index){
					case sprReviveArea:
						sprite_index = spr.AllyReviveArea;
						break;
						
					case sprNecroReviveArea:
						sprite_index = spr.AllyNecroReviveArea;
						break;
				}
				
				 // Add to List:
				with(_bind){
					array_push(inst, other);
					array_push(vars, _vars);
				}
			}
			
			 // Uncharm:
			else{
				target = noone;
				
				 // I-Frames:
				if("nexthurt" in self){
					nexthurt = current_frame + 12;
				}
				
				 // Delay Contact Damage:
				if("canmelee" in self && canmelee){
					alarm11 = 30;
					canmelee = false;
				}
				
				 // Reset Team:
				if(_vars.team != -1){
					if(fork()){
						while("team" not in self && instance_is(self, becomenemy)){
							wait 0;
						}
						if("team" in self){
							 // Teamerize Nearby Projectiles:
							with(instances_matching(instances_matching(projectile, "creator", self), "team", team)){
								if(place_meeting(x, y, other)){
									team = _vars.team;
									team_instance_sprite(team, self);
								}
							}
							
							team = _vars.team;
							_vars.team = -1;
						}
						exit;
					}
				}
				
				 // Reset Step:
				if(array_length(_vars.on_step) > 0){
					on_step = _vars.on_step;
					_vars.on_step = [];
				}
				
				 // Kill:
				if(_vars.kill){
					my_health = 0;
					sound_play_pitchvol(sndEnemyDie, 2 + orandom(0.3), 3);
				}
				
				 // Effects:
				else instance_create(x, bbox_top, AssassinNotice);
				sound_play_pitchvol(sndAssassinGetUp, random_range(1.2, 1.5), 0.5);
				var _num = 10 * max(variable_instance_get(self, "size", 0), 0.5);
				for(var a = direction; a < direction + 360; a += (360 / _num)){
					scrFX(x, y, [a, 3], Dust);
				}
			}
		}
		
		array_push(_instVars, _vars);
	}
	
	return ((array_length(_instVars) == 1) ? _instVars[0] : _instVars);
	
#define boss_hp(_hp)
	var n = 0;
	for(var i = 0; i < maxp; i++) n += player_is_active(i);
	return round(_hp * (1 + ((1/3) * GameCont.loops)) * (1 + (0.5 * (n - 1))));

#define boss_intro(_name)
	/*
		Plays a given boss's intro and their music
	*/
	
	 // Music:
	with(MusCont){
		alarm_set(2, 1);
		alarm_set(3, -1);
	}
	
	 // Bind begin_step to fix TopCont.darkness flash
	if(_name != ""){
		with(script_bind_begin_step(boss_intro_step, 0)){
			boss = _name;
			loops = 0;
			replaced = false;
			
			 // Co-op Delay:
			delay = 0;
			for(var i = 0; i < maxp; i++){
				delay += player_is_active(i) * current_time_scale;
			}
			
			return id;
		}
	}
	
	return noone;

#define boss_intro_step
	if(delay > 0){
		delay -= current_time_scale;
		
		if(option_get("intros") && GameCont.loops <= loops){
			 // Replace Big Bandit's Intro:
			if(!replaced){
				replaced = true;
				var _path = "sprites/intros/";
				sprite_replace_image(sprBossIntro,          `${_path}spr${boss}Main.png`, 0);
				sprite_replace_image(sprBossIntroBackLayer, `${_path}spr${boss}Back.png`, 0);
				sprite_replace_image(sprBossName,           `${_path}spr${boss}Name.png`, 0);
			}
			
			 // Call Big Bandit's Intro:
			if(delay <= 0){
				var	_lastSub = GameCont.subarea,
					_lastLoop = GameCont.loops,
					_lastIntro = UberCont.opt_bossintros;
					
				GameCont.loops = 0;
				UberCont.opt_bossintros = true;
				
				with(instance_create(0, 0, BanditBoss)){
					event_perform(ev_alarm, 6);
					sound_stop(sndBigBanditIntro);
					instance_delete(id);
				}
				
				GameCont.subarea = _lastSub;
				GameCont.loops = _lastLoop;
				UberCont.opt_bossintros = _lastIntro;
			}
		}
	}
	
	 // End:
	else{
		if(replaced){
			sprite_restore(sprBossIntro);
			sprite_restore(sprBossIntroBackLayer);
			sprite_restore(sprBossName);
		}
		instance_destroy();
	}
	
#define scrFX(_x, _y, _motion, _obj)
	if(!is_array(_x)) _x = [_x, 1];
	while(array_length(_x) < 2) array_push(_x, 0);

	if(!is_array(_y)) _y = [_y, 1];
	while(array_length(_y) < 2) array_push(_y, 0);

	if(!is_array(_motion)) _motion = [random(360), _motion];
	while(array_length(_motion) < 2) array_push(_motion, 0);

	with(obj_create(_x[0] + orandom(_x[1]), _y[0] + orandom(_y[1]), _obj)){
		var _face = (image_angle == direction);
		motion_add(_motion[0], _motion[1]);
		if(_face) image_angle = direction;
		
		return id;
	}
	
	return noone;

#define corpse_drop(_dir, _spd)
	/*
		Creates a corpse with a given direction and speed
		Automatically transfers standard variables to the corpse and applies impact wrists
	*/
	
	with(instance_create(x, y, Corpse)){
		size = other.size;
		sprite_index = other.spr_dead;
		image_xscale = variable_instance_get(other, "right", other.image_xscale);
		direction = _dir;
		speed = _spd;
		
		 // Non-Props:
		if(!instance_is(other, prop) && instance_is(other, hitme)){
			mask_index = other.mask_index;
			speed += max(0, -other.my_health / 5);
			speed += 8 * skill_get(mut_impact_wrists) * instance_is(other, enemy);
		}
		
		 // Clamp Speed:
		speed = min(speed, 16);
		if(size > 0) speed /= size;
		
        return id;
	}

#define player_swap()
	/*
		Swaps weapons and weapon-related vars
		Called from a Player object
	*/
	
	with(["wep", "curse", "reload", "wkick", "wepflip", "wepangle", "can_shoot", "interfacepop"]){
		var _temp = variable_instance_get(other, self);
		variable_instance_set(other, self, variable_instance_get(other, "b" + self));
		variable_instance_set(other, "b" + self, _temp);
	}
	
	can_shoot = (reload <= 0);
	drawempty = 30;
	swapmove = true;
	clicked = false;
	
#define portal_poof()
	/*
		Get rid of portals, but make it look cool
	*/
	
	var _rescue = false;
	
	with(instances_matching_ge(instances_matching_ge(instances_matching(instances_matching(Portal, "object_index", Portal), "type", 1, 3), "endgame", 0), "image_alpha", 1)){
		sound_stop(sndPortalClose);
		sound_stop(sndPortalLoop);
		
		 // Guardian:
		if(
			visible
			&& type == 1
			&& endgame >= 100
			&& !place_meeting(x, y, PortalShock)
			&& point_seen_ext(x, y, -8, -8, -1)
			&& chance(1, 2)
		){
			with(obj_create(x, y, "PortalGuardian")){
				x = xstart;
				y = ystart;
				sprite_index = spr_appear;
				right = other.image_xscale;
				portal = true;
			}
			sound_play_hit_ext(
				asset_get_index(`sndPortalFlyby${irandom_range(1, 4)}`),
				2 + orandom(0.1),
				3
			);
		}
		
		 // Normal:
		else with(instance_create(x, y, BulletHit)){
			name = "PortalPoof";
			sprite_index = sprPortalDisappear;
			image_xscale = other.image_xscale;
			image_yscale = other.image_yscale;
			image_angle = other.image_angle;
			image_blend = other.image_blend;
			image_alpha = other.image_alpha;
			depth = other.depth;
		}
		
		 // Rescue Players:
		with(Player){
			if(in_sight(other)){
				array_push(_rescue, self);
			}
		}
		
		instance_destroy();
	}
	
	 // Rescue Players:
	if(array_length(instances_matching_lt(Portal, "endgame", 100)) <= 0){
		with(_rescue){
			if(mask_index == mskNone){
				mask_index = ((race == char_bigdog) ? mskScrapBoss : mskPlayer);
			}
			if(angle != 0){
				if(skill_get(mut_throne_butt) > 0) angle = 0;
				else roll = true;
			}
		}
	}
	
	 // Prevent Corpse Portal:
	with(instances_matching_gt(Corpse, "alarm0", 0)){
		alarm0 = -1;
	}

#define portal_pickups()
	var _bind = instances_matching(CustomScript, "name", "portal_pickups_step");
	
	 // Bind Script:
	if(array_length(_bind) <= 0){
		_bind = script_bind_end_step(portal_pickups_step, 0);
		with(_bind){
			name = script[2];
		}
	}
	
	return _bind;

#define portal_pickups_step
	instance_destroy();
	
	 // Attract Pickups:
	if(instance_exists(Player) && !instance_exists(Portal)){
		var _pluto = skill_get(mut_plutonium_hunger);
		
		 // Normal Pickups:
		var _attractDis = 30 + (40 * _pluto);
		with(instances_matching([AmmoPickup, HPPickup, RoguePickup], "", null)){
			var p = instance_nearest(x, y, Player);
			if(point_distance(x, y, p.x, p.y) >= _attractDis){
				var	_dis = 6 * current_time_scale,
					_dir = point_direction(x, y, p.x, p.y),
					_x = x + lengthdir_x(_dis, _dir),
					_y = y + lengthdir_y(_dis, _dir);
					
				if(place_free(_x, y)) x = _x;
				if(place_free(x, _y)) y = _y;
			}
		}
		
		 // Rads:
		var	_attractDis = 80 + (60 * _pluto),
			_attractDisProto = 170;
			
		with(instances_matching([Rad, BigRad], "speed", 0)){
			var s = instance_nearest(x, y, ProtoStatue);
			if(distance_to_object(s) >= _attractDisProto || !in_sight(s)){
				if(distance_to_object(Player) >= _attractDis){
					var	p = instance_nearest(x, y, Player),
						_dis = 12 * current_time_scale,
						_dir = point_direction(x, y, p.x, p.y),
						_x = x + lengthdir_x(_dis, _dir),
						_y = y + lengthdir_y(_dis, _dir);
						
					if(place_free(_x, y)) x = _x;
					if(place_free(x, _y)) y = _y;
				}
			}
		}
	}

#define orandom(n)
	/*
		For offsets
	*/
	
	return random_range(-n, n);
	
#define pfloor(_num, _precision)
	return floor(_num / _precision) * _precision;
	
#define pround(_num, _precision)
	return round(_num / _precision) * _precision;
	
#define pceil(_num, _precision)
	return ceil(_num / _precision) * _precision;
	
#define array_exists(_array, _value)
	return (array_find_index(_array, _value) >= 0);

#define array_count(_array, _value)
	var _count = 0;
	with(_array) if(self == _value) _count++;
	return _count;

#define array_flip(_array)
	var	a = array_clone(_array),
		m = array_length(_array);

	for(var i = 0; i < m; i++){
		_array[@i] = a[(m - 1) - i];
	}

	return _array;

#define array_combine(_array1, _array2)
	var a = array_clone(_array1);
	array_copy(a, array_length(a), _array2, 0, array_length(_array2));
	return a;

#define array_shuffle(_array)
	var	_size = array_length(_array),
		j, t;
		
	for(var i = 0; i < _size; i++){
		j = irandom_range(i, _size - 1);
		if(i != j){
			t = _array[i];
			_array[@i] = _array[j];
			_array[@j] = t;
		}
	}
	
	return _array;
	
#define pool(_pool)
	/*
		Accepts a LWO or array of value:weight pairs, and returns one of them based on random chance
		
		Ex:
			pool({
				"A" : 4, // 50%
				"B" : 3, // 37.5%
				"C" : 1  // 12.5%
			})
			pool([
				[Bandit,    5], // 50%
				[Scorpion,  3], // 30%
				[BigMaggot, 1], // 10%
				[Maggot,    1]  // 10%
			])
	*/
	
	 // Turn LWO Into Array:
	if(is_object(_pool)){
		var _poolNew = [];
		for(var i = 0; i < lq_size(_pool); i++){
			array_push(_poolNew, [lq_get_key(_pool, i), lq_get_value(_pool, i)]);
		}
		_pool = _poolNew;
	}
	
	 // Roll Max Number:
	var _roll = 0;
	with(_pool) _roll += self[1];
	_roll -= random(_roll);
	
	 // Find Rolled Value:
	if(_roll > 0){
		with(_pool){
			_roll -= self[1];
			if(_roll <= 0) return self[0];
		}
	}
	
	return null;
	
#define array_delete(_array, _index)
	var _new = array_slice(_array, 0, _index);
	array_copy(_new, array_length(_new), _array, _index + 1, array_length(_array) - (_index + 1));
	return _new;
	
#define array_delete_value(_array, _value)
	var a = _array;
	while(array_find_index(a, _value) >= 0){
		a = array_delete(a, array_find_index(a, _value));
	}
	return a;
	
#define array_clone_deep(_array)
	var _new = array_clone(_array);

	for(var i = 0; i < array_length(_new); i++){
		var v = _new[i];
		if(is_array(v)){
			_new[i] = array_clone_deep(v);
		}
		else if(is_object(v)){
			_new[i] = lq_clone_deep(v);
		}
	}

	return _new;

#define lq_clone_deep(_obj)
	var _new = lq_clone(_obj);
	
	for(var i = 0; i < lq_size(_new); i++){
		var	k = lq_get_key(_new, i),
			v = lq_get_value(_new, i);
			
		if(is_array(v)){
			lq_set(_new, k, array_clone_deep(v));
		}
		else if(is_object(v)){
			lq_set(_new, k, lq_clone_deep(v));
		}
	}
	
	return _new;
	
#define instance_nearest_array(_x, _y, _inst)
	/*
		Returns the instance closest to a given point from an array of instances
		
		Ex:
			instance_nearest_array(x, y, instances_matching_ne(hitme, "team", 2));
	*/
	
	var	_nearest = noone,
		_disMax = infinity;
		
	with(instances_matching(_inst, "", null)){
		var _dis = point_distance(_x, _y, x, y);
		if(_dis < _disMax){
			_disMax = _dis;
			_nearest = id;
		}
	}
	
	return _nearest;
	
#define instance_nearest_bbox(_x, _y, _inst)
	/*
		Returns the instance closest to a given point based on their bounding box, similar to how 'distance_to_point()' works
		Accepts an array argument like 'instance_nearest_array()' does
		
		Ex:
			instance_nearest_bbox(x, y, Floor);
	*/
	
	var	_nearest = noone,
		_disMax = infinity;
		
	with(instances_matching(_inst, "", null)){
		var _dis = point_distance(_x, _y, clamp(_x, bbox_left, bbox_right + 1), clamp(_y, bbox_top, bbox_bottom + 1));
		if(_dis < _disMax){
			_disMax = _dis;
			_nearest = id;
		}
	}
	
	return _nearest;
	
#define instance_nearest_rectangle(_x1, _y1, _x2, _y2, _inst)
	/*
		Returns the instance closest to a given rectangle based on their position
		If multiple instances are equally distant from the rectangle, a bias exists for the one closer to its center
		Accepts an array argument like 'instance_nearest_array()' does
		
		Ex:
			instance_nearest_rectangle(x, y, x + 160, y + 64, chestprop)
	*/
	
	var	_cx = (_x1 + _x2) / 2,
		_cy = (_y1 + _y2) / 2,
		_nearest = noone,
		_disAMax = infinity,
		_disBMax = infinity;
		
	with(instances_matching(_inst, "", null)){
		var	_disA = point_distance(clamp(x, _x1, _x2), clamp(y, _y1, _y2), x, y),
			_disB = point_distance(_cx, _cy, x, y);
			
		if(_disA < _disAMax || (_disA == _disAMax && _disB < _disBMax)){
			_disAMax = _disA;
			_disBMax = _disB;
			_nearest = id;
		}
	}
	
	return _nearest;
	
#define instance_nearest_rectangle_bbox(_x1, _y1, _x2, _y2, _inst)
	/*
		Returns the instance closest to a given rectangle based on their bounding box, similar to how 'distance_to_object()' works
		If multiple instances are equally distant from the rectangle, a bias exists for the one closer to its center
		Accepts an array argument like 'instance_nearest_array()' does
		
		Ex:
			instance_nearest_rectangle_bbox(x - 16, y - 16, x + 16, y + 16, Floor)
	*/
	
	var	_cx = (_x1 + _x2) / 2,
		_cy = (_y1 + _y2) / 2,
		_nearest = noone,
		_disAMax = infinity,
		_disBMax = infinity;
		
	with(instances_matching(_inst, "", null)){
		var	_x = clamp(_cx, bbox_left, bbox_right + 1),
			_y = clamp(_cy, bbox_top, bbox_bottom + 1),
			_disA = point_distance(clamp(_x, _x1, _x2), clamp(_y, _y1, _y2), _x, _y),
			_disB = point_distance(_cx, _cy, _x, _y);
			
		if(_disA < _disAMax || (_disA == _disAMax && _disB < _disBMax)){
			_disAMax = _disA;
			_disBMax = _disB;
			_nearest = id;
		}
	}
	
	return _nearest;
	
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)
	return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "x", _x1), "x", _x2), "y", _y1), "y", _y2);

#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)
	return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _x1), "bbox_left", _x2), "bbox_bottom", _y1), "bbox_top", _y2);

#define instances_seen_nonsync(_obj, _bx, _by)
	var	_vx = view_xview_nonsync,
		_vy = view_yview_nonsync;

	return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _vx - _bx), "bbox_left", _vx + game_width + _bx), "bbox_bottom", _vy - _by), "bbox_top", _vy + game_height + _by);

#define instances_meeting(_x, _y, _obj)
	var	_tx = x,
		_ty = y;

	x = _x;
	y = _y;
	var r = instances_matching_ne(instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", bbox_left), "bbox_left", bbox_right), "bbox_bottom", bbox_top), "bbox_top", bbox_bottom), "id", id);
	x = _tx;
	y = _ty;

	return r;

#define instances_at(_x, _y, _obj)
	return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _x), "bbox_left", _x), "bbox_bottom", _y), "bbox_top", _y);

#define instance_random(_obj)
	/*
		Returns a random instance of the given object
		Also accepts an array of instances
	*/
	
	var	_inst = instances_matching(_obj, "", null),
		_max = array_length(_inst);
		
	return ((_max > 0) ? _inst[irandom(_max - 1)] : noone);
	
#define instance_clone()
	/*
		Duplicates an instance like 'instance_copy(false)' and clones all of their data structures
	*/
	
	with(instance_copy(false)){
		with(variable_instance_get_names(self)){
			var	_value = variable_instance_get(other, self),
				_clone = data_clone(_value);
				
			if(_value != _clone){
				variable_instance_set(other, self, _clone);
			}
		}
		
		return id;
	}
	
#define data_clone(_value)
	/*
		Returns an exact copy of the given value
	*/
	
	if(is_array(_value)){
		return array_clone(_value);
	}
	if(is_object(_value)){
		return lq_clone(_value);
	}
	if(ds_list_valid(_value)){
		return ds_list_clone(_value);
	}
	if(ds_map_valid(_value)){
		return ds_map_clone(_value);
	}
	if(ds_grid_valid(_value)){
		return ds_grid_clone(_value);
	}
	if(surface_exists(_value)){
		return surface_clone(_value);
	}
	
	return _value;
	
#define ds_list_clone(_list)
	/*
		Returns an exact copy of the given ds_list
	*/
	
	var _new = ds_list_create();
	
	ds_list_add_array(_new, ds_list_to_array(_list));
	
	return _new;
	
#define ds_map_clone(_map)
	/*
		Returns an exact copy of the given ds_map
	*/
	
	var _new = ds_map_create();
	
	with(ds_map_keys(_map)){
		_new[? self] = _map[? self];
	}
	
	return _new;
	
#define ds_grid_clone(_grid)
	/*
		Returns an exact copy of the given ds_grid
	*/
	
	var	_w = ds_grid_width(_grid),
		_h = ds_grid_height(_grid),
		_new = ds_grid_create(_w, _h);
		
	for(var _x = 0; _x < _w; _x++){
		for(var _y = 0; _y < _h; _y++){
			_new[# _x, _y] = _grid[# _x, _y];
		}
	}
	
	return _new;
	
#define variable_instance_get_list(_inst)
	/*
		Returns all of a given instance's variable names and values as a LWO
	*/
	
	var _list = {};
	
	with(variable_instance_get_names(_inst)){
		lq_set(_list, self, variable_instance_get(_inst, self));
	}
	
	return _list;
	
#define variable_instance_set_list(_inst, _list)
	/*
		Sets all of a given LWO's variable names and values on a given instance
	*/
	
	if(instance_exists(_inst)){
		var	_listMax = lq_size(_list),
			_isCustom = (string_pos("Custom", object_get_name(_inst.object_index)) == 1);
			
		for(var i = 0; i < _listMax; i++){
			var _name = lq_get_key(_list, i);
			if(!variable_is_readonly(_inst, _name)){
				if(_isCustom && string_pos("on_", _name) == 1){
					try variable_instance_set(_inst, _name, lq_get_value(_list, i));
					catch(_error){}
				}
				else variable_instance_set(_inst, _name, lq_get_value(_list, i));
			}
		}
	}
	
#define surface_clone(_surf)
	/*
		Returns an exact copy of the given surface
	*/
	
	var _new = surface_create(surface_get_width(_surf), surface_get_height(_surf));
	
	surface_set_target(_new);
	draw_clear_alpha(0, 0);
	draw_surface(_surf, 0, 0);
	surface_reset_target();
	
	return _new;
	
#define variable_is_readonly(_inst, _varName)
	if(array_exists(["id", "object_index", "bbox_bottom", "bbox_top", "bbox_right", "bbox_left", "image_number", "sprite_yoffset", "sprite_xoffset", "sprite_height", "sprite_width"], _varName)){
		return true;
	}
	if(instance_is(_inst, Player)){
		if(array_exists(["p", "index", "alias"], _varName)){
			return true;
		}
	}
	return false;
	
#define wepfire_init(_wep)
	var _fire = {
		wep     : _wep,
		creator : noone,
		wepheld : false,
		roids   : false,
		spec    : false
	};

	 // Creator:
	_fire.creator = self;
	if(variable_instance_get(self, "object_index") == FireCont){
		_fire.creator = creator;
	}

	 // Weapon Held by Creator:
	_fire.wepheld = (variable_instance_get(_fire.creator, "wep") == _wep);

	 // Secondary Firing:
	_fire.spec = variable_instance_get(self, "specfiring", false);
	if(_fire.spec && race == "steroids") _fire.roids = true;
	
	 // LWO Setup:
	if(is_string(_fire.wep)){
		var _lwo = mod_variable_get("weapon", _fire.wep, "lwoWep");
		if(is_object(_lwo)){
			_fire.wep = lq_clone(_lwo);

			if(_fire.wepheld){
				_fire.creator.wep = _fire.wep;
			}
		}
	}

	return _fire;

#define wepammo_fire(_wep)
	 // Infinite Ammo:
	if(infammo != 0) return true;
	
	 // Ammo Cost:
	var _cost = lq_defget(_wep, "cost", 1);
	with(_wep) if(ammo >= _cost){
		ammo -= _cost;
		
		 // Can Fire:
		return true;
	}
	
	 // Not Enough Ammo:
	reload = 0;
	if("anam" in _wep){
		wkick = -3;
		sound_play(sndEmpty);
		with(instance_create(x, y, PopupText)){
			target = other.index;
			if(_wep.ammo > 0){
				text = "NOT ENOUGH " + _wep.anam;
			}
			else{
				text = "EMPTY";
			}
		}
	}
	
	return false;

#define wepammo_draw(_wep)
	if(instance_is(self, Player) && (instance_is(other, TopCont) || instance_is(other, UberCont)) && is_object(_wep)){
		var _ammo = lq_defget(_wep, "ammo", 0);
		draw_ammo(index, (wep == _wep), _ammo, lq_defget(_wep, "amax", _ammo), (race == "steroids"));
	}

#define draw_ammo(_index, _primary, _ammo, _ammoMax, _steroids)
	if(player_get_show_hud(_index, player_find_local_nonsync())){
		if(!instance_exists(menubutton) || _index == player_find_local_nonsync()){
			var	_x = view_xview_nonsync + (_primary ? 42 : 86),
				_y = view_yview_nonsync + 21;
				
			var _active = 0;
			for(var i = 0; i < maxp; i++) _active += player_is_active(i);
			if(_active > 1) _x -= 19;
			
			 // Determine Color:
			var _col = "w";
			if(is_real(_ammo)){
				if(_ammo > 0){
					if(_primary || _steroids){
						if(_ammo <= ceil(_ammoMax * 0.2)){
							_col = "r";
						}
					}
					else _col = "s";
				}
				else _col = "d";
			}
			
			 // !!!
			draw_set_halign(fa_left);
			draw_set_valign(fa_top);
			draw_set_projection(2, _index);
			draw_text_nt(_x, _y, "@" + _col + string(_ammo));
			draw_reset_projection();
		}
	}
	
#define frame_active(_interval)
	return ((current_frame % _interval) < current_time_scale);
	
#define skill_get_icon(_skill)
	/*
		Returns an array containing the [sprite_index, image_index] of a mutation's HUD icon
	*/
	
	if(is_real(_skill)){
		return [sprSkillIconHUD, _skill];
	}
	
	if(is_string(_skill) && mod_script_exists("skill", _skill, "skill_icon")){
		return [mod_script_call("skill", _skill, "skill_icon"), 0];
	}
	
	return [sprEGIconHUD, 2];
	
#define game_activate()
	/*
		Reactivates all instances and unpauses the game
	*/
	
	with(UberCont) with(self){
		event_perform(ev_alarm, 2);
	}
	
#define game_deactivate()
	/*
		Deactivates all objects, except GmlMods & most controllers
	*/
	
	with(UberCont) with(self){
		var	_lastIntro = opt_bossintros,
			_lastLoop = GameCont.loops,
			_player = noone;
			
		 // Ensure Boss Intro Plays:
		opt_bossintros = true;
		GameCont.loops = 0;
		if(!instance_exists(Player)){
			_player = instance_create(0, 0, GameObject);
			with(_player) instance_change(Player, false);
		}
		
		 // Call Boss Intro:
		with(instance_create(0, 0, GameObject)){
			instance_change(BanditBoss, false);
			event_perform(ev_alarm, 6);
			sound_stop(sndBigBanditIntro);
			instance_delete(id);
		}
		
		 // Reset:
		alarm2 = -1;
		opt_bossintros = _lastIntro;
		GameCont.loops = _lastLoop;
		with(_player) instance_delete(id);
		
		 // Unpause Game, Then Deactivate Objects:
		event_perform(ev_alarm, 2);
		event_perform(ev_draw, ev_draw_post);
	}
	
#define area_generate(_area, _subarea, _x, _y, _setArea, _overlapFloor, _scrSetup)
	/*
		Deactivates the game, generates a given area, and reactivates the game
		Returns the ID of the GenCont used to create the area, or null if the area couldn't be generated
		
		Args:
			area/subarea - Area to generate
			x/y          - Spawn position
			setArea      - Set the current area to the generated area
			                 True  : Sets the area, background_color, BackCont vars, TopCont vars, and calls .mod level_start scripts
			                 False : Maintains the current area and deletes new IDPD spawns
			overlapFloor - Number 0 to 1, determines the percent of current level floors that can be overlapped
			scrSetup     - Script reference, called right before floor generation
			
		Ex:
			var _genID = area_generate(area_scrapyards, 3, x, y, false, 0, null);
			with(instances_matching_gt(chestprop, "id", _genID)){
				instance_delete(id);
			}
	*/
	
	if(is_real(_area) || is_string(_area)){
		var	_lastArea = GameCont.area,
			_lastSubarea = GameCont.subarea,
			_lastBackgroundColor = background_color,
			_lastLetterbox = game_letterbox,
			_lastViewObj = [],
			_lastViewPan = [],
			_lastViewShk = [],
			_lastObjVars = [],
			_lastSolid = [];
			
		 // Remember Stuff:
		for(var i = 0; i < maxp; i++){
			_lastViewObj[i] = view_object[i];
			_lastViewPan[i] = view_pan_factor[i];
			_lastViewShk[i] = view_shake[i];
		}
		with([BackCont, TopCont]){
			var	_obj = self,
				_vars = {};
				
			if(instance_exists(_obj)){
				with(variable_instance_get_names(_obj)){
					if(array_find_index(["id", "object_index", "bbox_bottom", "bbox_top", "bbox_right", "bbox_left", "image_number", "sprite_yoffset", "sprite_xoffset", "sprite_height", "sprite_width"], self) < 0){
						lq_set(_vars, self, variable_instance_get(_obj, self));
					}
				}
				array_push(_lastObjVars, [_obj, _vars]);
			}
		}
		
		 // Fix Ghost Collision:
		with(instances_matching(all, "solid", true)){
			solid = false;
			array_push(_lastSolid, self);
		}
		
		 // Clamp to Grid:
		with(instance_nearest_bbox(_x, _y, Floor)){
			_x = x + pfloor(_x - x, 16);
			_y = y + pfloor(_y - y, 16);
		}
		
		 // Floor Overlap Fixing:
		var	_overlapFloorBBox = [],
			_overlapFloorFill = [];
			
		if(_overlapFloor < 1){
			var	_floor = FloorNormal,
				_num = array_length(_floor) * (1 - _overlapFloor);
				
			with(array_shuffle(_floor)){
				if(_num-- > 0){
					array_push(_overlapFloorBBox, [bbox_left, bbox_top, bbox_right, bbox_bottom]);
				}
				else break;
			}
		}
		
		 // No Duplicates:
		with(BackCont) instance_destroy();
		with(TopCont) instance_destroy();
		with(SubTopCont) instance_destroy();
		
		 // Deactivate Objects:
		game_deactivate();
		
		 // No Boss Death Music:
		if(_setArea){
			with(MusCont){
				alarm_set(3, -1);
			}
		}
		
		 // Generate Level:
		GameCont.area = _area;
		GameCont.subarea = _subarea;
		var _genID = instance_create(0, 0, GenCont);
		with(_genID) with(self){
			var	_ox = (_x - 10016),
				_oy = (_y - 10016);
				
			 // Music:
			if(_setArea){
				with(MusCont){
					alarm_set(11, 1);
				}
			}
			
			 // Delete Loading Spirals:
			with(SpiralCont) instance_destroy();
			with(Spiral) instance_destroy();
			with(SpiralStar) instance_destroy();
			with(SpiralDebris) instance_destroy(); // *might play a 0.1 pitched sound
			
			 // Custom Code:
			if(is_array(_scrSetup)){
				script_ref_call(_scrSetup);
			}
			
			 // Floors:
			var	_tries = 100,
				_floorNum = 0;
				
			while(instance_exists(FloorMaker) && _tries-- > 0){
				with(FloorMaker){
					xprevious = x;
					yprevious = y;
					event_perform(ev_step, ev_step_normal);
				}
				if(instance_number(Floor) > _floorNum){
					_floorNum = instance_number(Floor);
					_tries = 300;
				}
			}
			with(FloorMaker) instance_destroy();
			
			 // Safe Spawns & Misc:
			event_perform(ev_alarm, 2);
			
			 // Remove Overlapping Floors:
			with(_overlapFloorBBox){
				var	_x1 = self[0] - _ox,
					_y1 = self[1] - _oy,
					_x2 = self[2] - _ox,
					_y2 = self[3] - _oy;
					
				with(instance_rectangle_bbox(_x1, _y1, _x2, _y2, Floor)){
					array_push(_overlapFloorFill, [bbox_left + _ox, bbox_top + _oy, bbox_right + _ox, bbox_bottom + _oy]);
					instance_destroy();
				}
				with(instance_rectangle_bbox(_x1, _y1, _x2, _y2, [SnowFloor, chestprop, RadChest])){
					instance_delete(id);
				}
			}
			
			 // Populate Level:
			with(KeyCont) event_perform(ev_create, 0); // reset player counter
			event_perform(ev_alarm, 0);
			if(!_setArea){
				with(WantPopo) instance_delete(id);
				with(WantVan) instance_delete(id);
			}
			event_perform(ev_alarm, 1);
			
			 // Player Reset:
			if(game_letterbox == false) game_letterbox = _lastLetterbox;
			for(var i = 0; i < maxp; i++){
				if(view_object[i] == noone) view_object[i] = _lastViewObj[i];
				if(view_pan_factor[i] == null) view_pan_factor[i] = _lastViewPan[i];
				if(view_shake[i] == 0) view_shake[i] = _lastViewShk[i];
				
				with(instances_matching(Player, "index", i)){
					 // Fix View:
					var	_vx1 = x - (game_width / 2),
						_vy1 = y - (game_height / 2),
						_vx2 = view_xview[i],
						_vy2 = view_yview[i],
						_shake = UberCont.opt_shake;
						
					UberCont.opt_shake = 1;
					gunangle = point_direction(_vx1, _vy1, _vx2, _vy2);
					weapon_post(0, point_distance(_vx1, _vy1, _vx2, _vy2), 0);
					UberCont.opt_shake = _shake;
					
					 // Delete:
					repeat(4) with(instance_nearest(x, y, PortalL)) instance_destroy();
					with(instance_nearest(x, y, PortalClear)) instance_destroy();
					instance_delete(id);
					
					break;
				}
			}
			
			 // Move Objects:
			with(instances_matching_ne(instances_matching_ne(instances_matching_gt(all, "id", _genID), "x", null), "y", null)){
				if(x != 0 || y != 0){
					x += _ox;
					y += _oy;
					xprevious += _ox;
					yprevious += _oy;
					xstart += _ox;
					ystart += _oy;
				}
			}
		}
		
		 // Call Funny Mod Scripts:
		if(_setArea){
			with(mod_get_names("mod")){
				mod_script_call_nc("mod", self, "level_start");
			}
		}
		
		 // Reactivate Objects:
		game_activate();
		with(_lastSolid) solid = true;
		
		 // Overlap Fixes:
		var	_overlapObject = [Floor, Wall, InvisiWall, TopSmall, TopPot, Bones],
			_overlapObj = array_clone(_overlapObject);
			
		while(array_length(_overlapObj) > 0){
			var _obj = _overlapObj[0];
			
			 // New Overwriting Old:
			var _objNew = instances_matching_gt(_obj, "id", _genID);
			with(instances_matching_lt(_overlapObj, "id", _genID)){
				if(place_meeting(x, y, _obj) && array_length(instances_meeting(x, y, _objNew)) > 0){
					if(object_index == Floor) array_push(_overlapFloorFill, [bbox_left, bbox_top, bbox_right, bbox_bottom]);
					instance_delete(id);
				}
			}
			
			 // Advance:
			_overlapObj = array_slice(_overlapObj, 1, array_length(_overlapObj) - 1);
			
			 // Old Overwriting New:
			var _objOld = instances_matching_lt(_obj, "id", _genID);
			with(instances_matching_gt(_overlapObj, "id", _genID)){
				if(place_meeting(x, y, _obj) && array_length(instances_meeting(x, y, _objOld)) > 0){
					instance_delete(id);
				}
			}
		}
		var _wallOld = instances_matching_lt(Wall, "id", _genID);
		with(instances_matching_lt(hitme, "id", _genID)){
			if(place_meeting(x, y, Wall) && array_length(instances_meeting(x, y, _wallOld)) <= 0){
				instance_budge(Wall, -1);
			}
		}
		
		 // Fill Gaps:
		with(_overlapFloorFill){
			var	_x1 = self[0],
				_y1 = self[1],
				_x2 = self[2] + 1,
				_y2 = self[3] + 1;
				
			with(other){
				for(var _fx = _x1; _fx < _x2; _fx += 16){
					for(var _fy = _y1; _fy < _y2; _fy += 16){
						if(!position_meeting(_fx, _fy, Floor)){
							with(instance_create(_fx, _fy, FloorExplo)){
								with(instances_meeting(x, y, _overlapObject)){
									instance_delete(id);
								}
							}
						}
					}
				}
			}
		}
		
		 // Reset Area:
		if(!_setArea){
			GameCont.area = _lastArea;
			GameCont.subarea = _lastSubarea;
			background_color = _lastBackgroundColor;
			with(_lastObjVars){
				var	_obj = self[0],
					_vars = self[1];
					
				with(_obj){
					for(var i = 0; i < lq_size(_vars); i++){
						variable_instance_set(self, lq_get_key(_vars, i), lq_get_value(_vars, i));
					}
				}
			}
		}
		with(_lastObjVars){
			var	_obj = self[0],
				_vars = self[1];
				
			if(_obj == TopCont && "fogscroll" in _vars){
				with(_obj) fogscroll = _vars.fogscroll;
			}
		}
		
		return _genID;
	}
	
	return null;
	
#define area_get_name(_area, _subarea, _loop)
	/*
		Returns the current area's name as it would appear on the map
	*/
	
	var a = [_area, "-", _subarea];
	
	 // Custom Area:
	if(is_string(_area)){
		a = ["MOD"];
		if(mod_script_exists("area", _area, "area_name")){
			var _custom = mod_script_call("area", _area, "area_name", _subarea, _loop);
			if(is_string(_custom)) a = [_custom];
		}
	}
	
	 // Secret Area:
	else if(real(_area) >= 100){
		switch(_area){
			case area_vault:
				a = ["???"];
				break;
				
			case area_hq:
				a = ["HQ", _subarea];
				break;
				
			case area_mansion:
				a = ["$$$"];
				break;
				
			default:
				a = [_area - 100, "-?"];
		}
	}
	
	 // Victory:
	if(GameCont.win == true){
		if(_area == area_palace || _area == area_labs){
			a = ["END", (_area >= 100) ? 2 : 1];
		}
	}
	
	 // Loop:
	if(real(_loop) > 0){
		array_push(a, " " + ((UberCont.hardmode == true) ? "H" : "L"));
		array_push(a, _loop);
	}
	
	 // Compile Name:
	var _name = "";
	for(var i = 0; i < array_length(a); i++){
		var n = a[i];
		if(is_real(n) && frac(n) != 0){
			a[i] = string_format(n, 0, 2);
		}
		_name += string(n);
	}
	
	return _name;
	
#define area_get_subarea(_area)
	if(is_real(_area)){
		 // Secret Areas:
		if(_area == area_hq) return 3;
		if(_area >= 100) return 1;
		
		 // Transition Area:
		if((_area % 2) == 0) return 1;
		
		return 3;
	}
	
	 // Custom Area:
	var _scrt = "area_subarea";
	if(mod_script_exists("area", _area, _scrt)){
		return mod_script_call("area", _area, _scrt);
	}
	
	return 0;

#define area_get_secret(_area)
	if(is_real(_area)){
		return (_area >= 100);
	}

	 // Custom Area:
	var _scrt = "area_secret";
	if(mod_script_exists("area", _area, _scrt)){
		return mod_script_call("area", _area, _scrt);
	}

	return false;

#define area_get_underwater(_area)
	if(is_real(_area)){
		return (_area == area_oasis);
	}

	 // Custom Area:
	var _scrt = "area_underwater";
	if(mod_script_exists("area", _area, _scrt)){
		return mod_script_call("area", _area, _scrt);
	}

	return false;

#define floor_walls()
	var	_x1 = bbox_left - 16,
		_y1 = bbox_top - 16,
		_x2 = bbox_right + 16 + 1,
		_y2 = bbox_bottom + 16 + 1,
		_minID = GameObject.id;
		
	for(var _x = _x1; _x < _x2; _x += 16){
		for(var _y = _y1; _y < _y2; _y += 16){
			if(_x == _x1 || _y == _y1 || _x == _x2 - 16 || _y == _y2 - 16){
				if(!position_meeting(_x, _y, Floor)){
					instance_create(_x, _y, Wall);
				}
			}
		}
	}
	
	return _minID;

#define floor_bones(_num, _chance, _linked)
	/*
		Checks if the current Floor is a vertical hallway and then creates Bones decals on the Walls left and right of the current Floor
		
		Args:
			num    - How many decals can be made vertically
			chance - Chance to create each decal
			linked - Decal should always spawn with one on the other side, true/false
			
		Ex:
			floor_bones(2, 1,    false) == DESERT / CAMPFIRE
			floor_bones(1, 1/10, true ) == SEWERS / PIZZA SEWERS / JUNGLE
			floor_bones(2, 1/7,  false) == SCRAPYARDS / FROZEN CITY
			floor_bones(2, 1/9,  false) == CRYSTAL CAVES / CURSED CRYSTAL CAVES / OASIS
	*/
	
	var _inst = [];
	
	if(!collision_rectangle(bbox_left - 16, bbox_top, bbox_right + 16, bbox_bottom, Floor, false, true)){
		for(var _y = bbox_top; _y < bbox_bottom + 1; _y += (32 / _num)){
			var _create = true;
			for(var _side = 0; _side <= 1; _side++){
				if(_side == 0 || !_linked){
					_create = (random(1) < _chance);
				}
				if(_create){
					var _x = lerp(bbox_left, bbox_right + 1, _side);
					with(obj_create(_x, _y, "WallDecal")){
						image_xscale = ((_side > 0.5) ? -1 : 1);
						array_push(_inst, id);
					}
				}
			}
		}
	}
	
	return _inst;

#define floor_reveal(_x1, _y1, _x2, _y2, _time)
	var	_bind = instances_matching(CustomScript, "name", "floor_reveal_draw"),
		_reveal = {
			creator     : noone,
			x1          : _x1,
			y1          : _y1,
			x2          : _x2,
			y2          : _y2,
			ox          : 0,
			oy          : -8,
			time        : _time,
			time_max    : _time,
			color       : background_color,
			flash       : true,
			flash_color : c_white
		};
		
	 // Bind Script:
	if(array_length(_bind) <= 0){
		_bind = script_bind_draw(floor_reveal_draw, -8);
		with(_bind){
			name = script[2];
			list = [];
		}
	}
	
	 // Add to List:
	with(_bind){
		_reveal.creator = id;
		array_push(list, _reveal);
	}
	
	return _reveal;

#define floor_reveal_draw
	var _destroyInst = [FloorExplo, Explosion, PortalClear, EnergyHammerSlash];
	
	with(list){
		 // Revealing:
		if(time > 0 && (time <= time_max || array_length(instance_rectangle_bbox(x1, y1, x2, y2, _destroyInst)) <= 0)){
			var	_num = clamp(time / time_max, 0, 1),
				_col = ((time > time_max) ? color : merge_color(flash_color, color, (flash ? (1 - _num) : _num)));
				
			draw_set_alpha(_num);
			draw_set_color(_col);
			draw_rectangle(x1 + ox, y1 + oy, x2 + ox, y2 + oy, false);
			
			time -= current_time_scale;
		}
		
		 // Done:
		else other.list = array_delete_value(other.list, self);
	}
	draw_set_alpha(1);
	
	 // Goodbye:
	if(array_length(list) <= 0){
		instance_destroy();
	}

#define area_border(_y, _area, _color)
	with(script_bind_draw(area_border_step, infinity, _y, _area, _color)){
		cavein = false;
		cavein_dis = 800;
		cavein_inst = [];
		cavein_pan = 0;
		
		type = [
			[Wall,		 0, [area_get_sprite(_area, sprWall1Bot), area_get_sprite(_area, sprWall1Top), area_get_sprite(_area, sprWall1Out)]],
			[TopSmall,	 0, area_get_sprite(_area, sprWall1Trans)],
			[FloorExplo, 0, area_get_sprite(_area, sprFloor1Explo)],
			[Debris,	 0, area_get_sprite(_area, sprDebris1)]
		];
		
		return id;
	}
	
#define area_border_step(_y, _area, _color)
	if(lag) trace_time();
	
	var	_fix = false,
		_caveInst = cavein_inst;
		
	 // Cave-In:
	if(cavein){
		_fix = true;
		if(cavein_dis > 0){
			var d = 12;
			if(array_length(instances_matching_gt(Player, "y", _y - 64)) <= 0) d *= 1.5;
			cavein_dis = max(0, cavein_dis - (max(4, random(d)) * current_time_scale));
			
			 // Debris:
			var _floor = instances_matching_gt(Floor, "bbox_bottom", _y);
			with(_floor) if(point_seen_ext(bbox_center_x, bbox_center_y, 16, 16, -1)){
				var n = 2 * array_length(instances_matching_gt(Floor, "y", y));
				if(chance_ct(1, n) && (object_index != FloorExplo || chance(1, 10))){
					with(instance_create(choose(bbox_left + 4, bbox_right - 4), choose(bbox_top + 4, bbox_bottom - 4), Debris)){
						motion_set(90 + orandom(90), 4 + random(4));
					}
				}
			}
			
			 // Caving Level In:
			if(cavein_dis < 400){
				script_bind_step(area_border_cavein, 0, _y, cavein_dis, _caveInst);
				
				 // Effects:
				if(current_frame_active){
					with(instances_matching_gt(_floor, "bbox_bottom", _y + cavein_dis)){
						repeat(choose(1, choose(1, 2))) with(instance_create(random_range(bbox_left - 12, bbox_right + 12), bbox_bottom, Dust)){
							image_xscale *= 2;
							image_yscale *= 2;
							depth = -8;
							vspeed -= 5;
							sound_play_hit(choose(sndWallBreak, sndWallBreakBrick), 0.3);
						}
					}
				}
			}
			
			 // Saved Caved Instances:
			var f = noone;
			with(instances_matching_lt(instances_matching_gt(Floor, "bbox_bottom", _y), "bbox_top", _y)){
				f = id;
				break;
			}
			with(_caveInst){
				if(instance_exists(self)){
					visible = false;
					y = _y + 16 + other.cavein_dis;
					with(f) other.x += (bbox_center_x - other.x) * 0.1 * current_time_scale;

					 // Why do health chests break walls again
					if(instance_is(self, HealthChest)) mask_index = mskNone;
				}
				else other.cavein_inst = array_delete_value(other.cavein_inst, self);
			}
			
			 // Screenshake:
			if(cavein_pan < 1) cavein_pan += 1/20 * current_time_scale;
			for(var i = 0; i < maxp; i++){
				view_shake[i] = max(view_shake[i], 5);
				with(instance_exists(view_object[i]) ? view_object[i] : player_find(i)){
					view_shake_max_at(x, _y + other.cavein_dis, 20);
					
					 // Pan Down:
					view_shift(i, 270, clamp(y - (_y - 64), 0, min(20, other.cavein_dis / 10)) * other.cavein_pan);
				}
			}
		}
		
		 // Finished Caving In:
		else{
			cavein = -1;
			
			 // Fix Camera:
			with(Revive){
				if(view_object[p] == id) view_object[p] = noone;
			}
			
			 // Wallerize:
			with(instances_matching_gt(Floor, "bbox_bottom", _y)){
				floor_walls();
			}
			with(instances_matching_gt(Wall, "bbox_bottom", _y)){
				wall_tops();
			}
			
			 // Rubble:
			with(_caveInst) if(instance_exists(self)){
				visible = true;
			}
			with(instances_matching_gt(FloorNormal, "bbox_bottom", _y)){
				with(obj_create(x + 16, _y, "PizzaRubble")){
					inst = _caveInst;
					event_perform(ev_step, ev_step_normal);
				}
				
				 // Fix Potential Softlockyness:
				var _x2 = bbox_center_x;
				with(instances_matching_lt(instances_matching_gt(FloorExplo, "bbox_bottom", _y - 4), "bbox_top", _y - 4)){
					var	_x1 = bbox_center_x,
						_y1 = bbox_center_y;
						
					if(collision_line(_x1, _y1, _x2, _y1, Wall, false, false)){
						floor_tunnel(_x1, _y - 8, _x2, _y - 8);
					}
				}
			}
		}
	}
	else if(cavein == false){
		 // Start Cave In:
		if(array_length(instances_matching_lt(Player, "y", _y)) > 0){
			cavein = true;
			sound_play_pitchvol(sndStatueXP, 0.2 + random(0.2), 3);
		}
	}
	if(cavein != -1){
		with(Revive){
			if(!instance_exists(view_object[p]) && !instance_exists(player_find(p))){
				view_object[p] = id;
			}
		}
	}
	
	 // Sprite Fixes:
	with(type){
		var	_obj = self[0],
			_num = self[1];
			
		if(_num < 0 || _num != instance_number(_obj)){
			_fix = true;
			self[@1] = instance_number(_obj);
		}
	}
	if(_fix) with(type){
		var	_obj = self[0],
			_spr = self[2];
			
		with(instances_matching(_obj, "cat_border_fix", null)){
			cat_border_fix = true;
			if(y >= _y){
				switch(_obj){
					case Wall:
						sprite_index = _spr[0];
						topspr = _spr[1];
						outspr = _spr[2];
						break;
						
					default:
						sprite_index = _spr;
				}
			}
		}
	}
	
	 // Background:
	var	_vx = view_xview_nonsync,
		_vy = view_yview_nonsync;
		
	draw_set_color(_color);
	draw_rectangle(_vx, _y, _vx + game_width, max(_y, _vy + game_height), 0);
	
	if(lag) trace_time("area_border_step");
	
#define area_border_cavein(_y, _caveDis, _caveInst)
	 // Delete:
	with(instances_matching_ne(instances_matching_gt(GameObject, "y", _y + _caveDis), "object_index", Dust)){
		 // Kill:
		if(y > _y + 64 && instance_is(self, hitme) && my_health > 0){
			my_health = 0;
			if("lasthit" in self) lasthit = [sprDebris102, "CAVE IN"];
			event_perform(ev_step, ev_step_normal);
		}
		
		 // Save:
		else if(persistent || (instance_is(self, Pickup) && !instance_is(self, Rad)) || instance_is(self, chestprop) || (instance_is(self, Corpse) && y < _y + 240) || (instance_is(self, CustomHitme) && "name" in self && name == "Pet")){
			if(!array_exists(_caveInst, id)) array_push(_caveInst, id);
		}
		
		 // Delete:
		else instance_delete(id);
	}
	
	 // Hide Wall Shadows:
	with(instances_matching_gt(Wall, "bbox_bottom", _y + _caveDis - 32)) outspr = -1;
	
	instance_destroy();
	
#define area_get_sprite(_area, _spr)
	/*
		Returns a given area's variant of the given sprite
		
		Ex:
			area_get_sprite(area_sewers, sprFloor1) == sprFloor2
			area_get_sprite(area_city, sprDebris1)  == sprDebris5
			area_get_sprite(area_caves, sprBones)   == sprCaveDecal
	*/
	
	 // Store Sprites:
	if(!mod_variable_exists(mod_type_current, mod_current, "area_sprite_map")){
		var _map = ds_map_create();
		_map[? 0  ] = [sprFloor0,   sprFloor0,    sprFloor0Explo,   sprWall0Trans,   sprWall0Bot,   sprWall0Out,   sprWall0Top,   sprDebris0,   sprDetail0,   sprNightBones,      sprNightDesertTopDecal];
		_map[? 1  ] = [sprFloor1,   sprFloor1B,   sprFloor1Explo,   sprWall1Trans,   sprWall1Bot,   sprWall1Out,   sprWall1Top,   sprDebris1,   sprDetail1,   sprBones,           sprDesertTopDecal     ];
		_map[? 2  ] = [sprFloor2,   sprFloor2B,   sprFloor2Explo,   sprWall2Trans,   sprWall2Bot,   sprWall2Out,   sprWall2Top,   sprDebris2,   sprDetail2,   sprSewerDecal,      sprTopDecalSewers     ];
		_map[? 3  ] = [sprFloor3,   sprFloor3B,   sprFloor3Explo,   sprWall3Trans,   sprWall3Bot,   sprWall3Out,   sprWall3Top,   sprDebris3,   sprDetail3,   sprScrapDecal,      sprTopDecalScrapyard  ];
		_map[? 4  ] = [sprFloor4,   sprFloor4B,   sprFloor4Explo,   sprWall4Trans,   sprWall4Bot,   sprWall4Out,   sprWall4Top,   sprDebris4,   sprDetail4,   sprCaveDecal,       sprTopDecalCave       ];
		_map[? 5  ] = [sprFloor5,   sprFloor5B,   sprFloor5Explo,   sprWall5Trans,   sprWall5Bot,   sprWall5Out,   sprWall5Top,   sprDebris5,   sprDetail5,   sprIceDecal,        sprTopDecalCity       ];
		_map[? 6  ] = [sprFloor6,   sprFloor6B,   sprFloor6Explo,   sprWall6Trans,   sprWall6Bot,   sprWall6Out,   sprWall6Top,   sprDebris6,   sprDetail6,   -1,                 -1                    ];
		_map[? 7  ] = [sprFloor7,   sprFloor7B,   sprFloor7Explo,   sprWall7Trans,   sprWall7Bot,   sprWall7Out,   sprWall7Top,   sprDebris7,   -1,           -1,                 sprPalaceTopDecal     ];
		_map[? 100] = [sprFloor100, sprFloor100B, sprFloor100Explo, sprWall100Trans, sprWall100Bot, sprWall100Out, sprWall100Top, sprDebris100, -1,           -1,                 -1                    ];
		_map[? 101] = [sprFloor101, sprFloor101B, sprFloor101Explo, sprWall101Trans, sprWall101Bot, sprWall101Out, sprWall101Top, sprDebris101, sprDetail101, sprCoral,           -1                    ];
		_map[? 102] = [sprFloor102, sprFloor102B, sprFloor102Explo, sprWall102Trans, sprWall102Bot, sprWall102Out, sprWall102Top, sprDebris102, sprDetail102, sprPizzaSewerDecal, sprTopDecalPizzaSewers];
		_map[? 103] = [sprFloor103, sprFloor103B, sprFloor103Explo, sprWall103Trans, sprWall103Bot, sprWall103Out, sprWall103Top, sprDebris103, -1,           -1,                 -1                    ];
		_map[? 104] = [sprFloor104, sprFloor104B, sprFloor104Explo, sprWall104Trans, sprWall104Bot, sprWall104Out, sprWall104Top, sprDebris104, sprDetail104, sprInvCaveDecal,    sprTopDecalInvCave    ];
		_map[? 105] = [sprFloor105, sprFloor105B, sprFloor105Explo, sprWall105Trans, sprWall105Bot, sprWall105Out, sprWall105Top, sprDebris105, -1,           sprJungleDecal,     sprTopDecalJungle     ];
		_map[? 106] = [sprFloor106, sprFloor106B, sprFloor106Explo, sprWall106Trans, sprWall106Bot, sprWall106Out, sprWall106Top, sprDebris106, -1,           -1,                 sprTopPot             ];
		_map[? 107] = [sprFloor107, sprFloor107B, sprFloor107Explo, sprWall107Trans, sprWall107Bot, sprWall107Out, sprWall107Top, sprDebris107, -1,           -1,                 -1                    ];
		global.area_sprite_map = _map;
	}
	
	 // Convert to Desert Sprite:
	if(sprite_exists(_spr)){
		with(ds_map_values(global.area_sprite_map)){
			var i = array_find_index(self, _spr);
			if(i >= 0){
				_spr = global.area_sprite_map[? 1][i];
				if(_spr == sprDesertTopDecal) _spr = sprTopPot;
				break;
			}
		}
	}
	
	 // Custom:
	if(is_string(_area)){
		var s = mod_script_call("area", _area, "area_sprite", _spr);
		if(s != 0 && is_real(s)){
			return s;
		}
	}
	
	 // Normal:
	if(ds_map_exists(global.area_sprite_map, _area)){
		var	_list = global.area_sprite_map[? _area],
			i = array_find_index(global.area_sprite_map[? 1], _spr);
			
		if(i >= 0 && i < array_length(_list)){
			return _list[i];
		}
	}
	
	return -1;
	
#define floor_get(_x, _y)
	 // Find Floor:
	with(instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(Floor, "bbox_right", _x), "bbox_left", _x), "bbox_bottom", _y), "bbox_top", _y)){
		return id;
	}

	 // Default to LWO Floor:
	return {
		x					: _x,
		y					: _y,
		xprevious			: _x,
		yprevious			: _y,
		xstart				: _x,
		ystart				: _y,
		hspeed				: 0,
		vspeed				: 0,
		direction			: 0,
		speed				: 0,
		friction			: 0,
		gravity				: 0,
		gravity_direction	: 270,
		visible				: true,
		sprite_index		: -1,
		sprite_width		: 0,
		sprite_height		: 0,
		sprite_xoffset		: 0,
		sprite_yoffset		: 0,
		image_number		: 1,
		image_index			: 0,
		image_speed			: 0,
		depth				: 10,
		image_xscale		: 1,
		image_yscale		: 1,
		image_angle			: 0,
		image_alpha			: 1,
		image_blend			: c_white,
		bbox_left			: _x,
		bbox_right			: _x,
		bbox_top			: _y,
		bbox_bottom			: _y,
		object_index		: Floor,
		id					: noone,
		solid				: false,
		persistent			: false,
		mask_index			: mskFloor,
		image_speed_raw		: 0,
		hspeed_raw			: 0,
		vspeed_raw			: 0,
		speed_raw			: 0,
		friction_raw		: 0,
		gravity_raw			: 0,
		alarm0				: -1,
		alarm1				: -1,
		alarm2				: -1,
		alarm3				: -1,
		alarm4				: -1,
		alarm5				: -1,
		alarm6				: -1,
		alarm7				: -1,
		alarm8				: -1,
		alarm9				: -1,
		alarm10				: -1,
		alarm11				: -1,
		styleb				: false,
		traction			: 0.45,
		area				: GameCont.area,
		material			: 0
	};
	
#define floor_set_style(_style, _area)
	global.floor_style = _style;
	global.floor_area = _area;
	
#define floor_reset_style()
	floor_set_style(null, null);
	
#define floor_set_align(_alignW, _alignH, _alignX, _alignY)
	global.floor_align_x = _alignX;
	global.floor_align_y = _alignY;
	global.floor_align_w = _alignW;
	global.floor_align_h = _alignH;
	
#define floor_reset_align()
	floor_set_align(null, null, null, null);
	
#define floor_align(_x, _y, _w, _h, _type)
	/*
		Aligns a given rectangle to the floor grid
		Has a bias towards nearby floors to help prevent the rectangle from being disconnected from the level
	*/
	
	var	_gridXAuto = is_undefined(global.floor_align_x),
		_gridYAuto = is_undefined(global.floor_align_y),
		_gridWAuto = is_undefined(global.floor_align_w),
		_gridHAuto = is_undefined(global.floor_align_h),
		_gridX     = (_gridXAuto ? 10000 : global.floor_align_x),
		_gridY     = (_gridYAuto ? 10000 : global.floor_align_y),
		_gridW     = (_gridWAuto ? 16    : global.floor_align_w),
		_gridH     = (_gridHAuto ? 16    : global.floor_align_h),
		_gridXBias = 0,
		_gridYBias = 0;
		
	if(_gridXAuto || _gridYAuto || _gridWAuto || _gridHAuto){
		if(!instance_exists(FloorMaker)){
			var	_fx = _gridX + floor_align_round(_x - _gridX, _gridW, _gridXBias),
				_fy = _gridY + floor_align_round(_y - _gridY, _gridH, _gridYBias);
				
			 // Align to Nearest Floor:
			if(_gridXAuto || _gridYAuto){
				with(instance_nearest_rectangle_bbox(_fx, _fy, _fx + _w, _fy + _h, Floor)){
					if(_gridXAuto){
						_gridX = x;
						_gridXBias = bbox_center_x - (_x + (_w / 2));
						_fx = _gridX + floor_align_round(_x - _gridX, _gridW, _gridXBias);
					}
					if(_gridYAuto){
						_gridY = y;
						_gridYBias = bbox_center_y - (_y + (_h / 2));
						_fy = _gridY + floor_align_round(_y - _gridY, _gridH, _gridYBias);
					}
				}
			}
			
			 // Align to Largest Colliding Floor:
			var	_fwMax = _gridW,
				_fhMax = _gridH;
				
			with(instance_rectangle_bbox(_fx, _fy, _fx + _w - 1, _fy + _h - 1, Floor)){
				var	_fw = bbox_width,
					_fh = bbox_height;
					
				if(_fw >= _fwMax){
					_fwMax = _fw;
					if(_gridWAuto){
						_gridW = _fwMax;
					}
					if(_gridXAuto){
						_gridX = x;
						_gridXBias = bbox_center_x - (_x + (_w / 2));
					}
				}
				if(_fh >= _fhMax){
					_fhMax = _fh;
					if(_gridHAuto){
						_gridH = _fhMax;
					}
					if(_gridYAuto){
						_gridY = y;
						_gridYBias = bbox_center_y - (_y + (_h / 2));
					}
				}
			}
			
			 // No Unnecessary Bias:
			if(_gridXBias != 0 || _gridYBias != 0){
				_fx = _gridX + floor_align_round(_x - _gridX, _gridW, 0);
				_fy = _gridY + floor_align_round(_y - _gridY, _gridH, 0);
				if(
					(_type == "round")
					? (
						collision_rectangle(_fx + 32, _fy,     _fx + _w - 32 - 1, _fy + _h - 1,      Floor, false, false) ||
						collision_rectangle(_fx,      _fy + 32, _fx + _w - 1,     _fy + _h - 32 - 1, Floor, false, false)
					)
					: collision_rectangle(_fx, _fy, _fx + _w - 1, _fy + _h - 1, Floor, false, false)
				){
					_gridXBias = 0;
					_gridYBias = 0;
				}
			}
		}
		
		 // FloorMaker:
		else with(instance_nearest(_x + max(0, (_w / 2) - 16), _y + max(0, (_h / 2) - 16), FloorMaker)){
			if(_gridXAuto) _gridX = x;
			if(_gridYAuto) _gridY = y;
			if(_gridWAuto) _gridW = min(_w, 32);
			if(_gridHAuto) _gridH = min(_h, 32);
		}
	}
	
	 // Align:
	return [
		_gridX + floor_align_round(_x - _gridX, _gridW, _gridXBias),
		_gridY + floor_align_round(_y - _gridY, _gridH, _gridYBias)
	];
	
#define floor_align_round(_num, _precision, _bias)
	var _value = _num;
	if(_precision != 0){
		_value /= _precision;
		
		if(_bias < 0){
			_value = floor(_value);
		}
		else if(_bias > 0 || frac(_value) == 0.5){ // No sig-fig rounding
			_value = ceil(_value);
		}
		else{
			_value = round(_value);
		}
		
		_value *= _precision;
	}
	return _value;
	
#define floor_set(_x, _y, _state) // imagine if floors and walls just used a ds_grid bro....
	var _inst = noone;
	
	 // Create Floor:
	if(_state){
		var	_obj = ((_state >= 2) ? FloorExplo : Floor),
			_msk = object_get_mask(_obj),
			_w = ((sprite_get_bbox_right (_msk) + 1) - sprite_get_bbox_left(_msk)),
			_h = ((sprite_get_bbox_bottom(_msk) + 1) - sprite_get_bbox_top (_msk));
			
		 // Align to Adjacent Floors:
		var _gridPos = floor_align(_x, _y, _w, _h, "");
		_x = _gridPos[0];
		_y = _gridPos[1];
		
		 // Clear Floors:
		if(!instance_exists(FloorMaker)){
			if(_obj == FloorExplo){
				with(instances_matching(instances_matching(_obj, "x", _x), "y", _y)) instance_delete(id);
			}
			else{
				floor_clear(_x, _y, _x + _w - 1, _y + _h - 1);
			}
		}
		
		 // Auto-Style:
		var	_floormaker = noone,
			_lastArea = GameCont.area;
			
		if(!is_undefined(global.floor_style)){
			GameCont.area = 0;
			with(instance_create(_x, _y, FloorMaker)){
				with(instances_matching_gt(Floor, "id", id)) instance_delete(id);
				styleb = global.floor_style;
				_floormaker = self;
			}
			GameCont.area = _lastArea;
		}
		if(!is_undefined(global.floor_area)){
			GameCont.area = global.floor_area;
		}
		
		 // Floorify:
		_inst = instance_create(_x, _y, _obj);
		with(_floormaker) instance_destroy();
		GameCont.area = _lastArea;
		with(_inst){
			if(!instance_exists(FloorMaker)){
				 // Clear Area:
				wall_clear(bbox_left, bbox_top, bbox_right, bbox_bottom);
				
				 // Details:
				if(chance(1, 6)){
					instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Detail);
				}
			}
			
			 // Wallerize:
			if(instance_exists(Wall)){
				floor_walls();
				wall_update(bbox_left - 16, bbox_top - 16, bbox_right + 16, bbox_bottom + 16);
			}
		}
	}
	
	 // Destroy Floor:
	else with(instances_at(_x, _y, [Floor, SnowFloor])){
		var	_x1 = bbox_left - 16,
			_y1 = bbox_top - 16,
			_x2 = bbox_right + 16,
			_y2 = bbox_bottom + 16;
			
		instance_destroy();
		
		if(instance_exists(Wall)){
			with(other){
				 // Un-Wall:
				wall_clear(_x1, _y1, _x2, _y2);
				
				 // Re-Wall:
				for(var _fx = _x1; _fx < _x2 + 1; _fx += 16){
					for(var _fy = _y1; _fy < _y2 + 1; _fy += 16){
						if(!position_meeting(_fx, _fy, Floor)){
							if(collision_rectangle(_fx - 16, _fy - 16, _fx + 31, _fy + 31, Floor, false, false)){
								instance_create(_fx, _fy, Wall);
							}
						}
					}
				}
				wall_update(_x1 - 16, _y1 - 16, _x2 + 16, _y2 + 16);
			}
		}
	}
	
	return _inst;
	
#define floor_clear(_x1, _y1, _x2, _y2)
	with(instance_rectangle_bbox(_x1, _y1, _x2, _y2, Floor)){
		for(var	_x = bbox_left; _x < bbox_right + 1; _x += 16){
			for(var	_y = bbox_top; _y < bbox_bottom + 1; _y += 16){
				if(
					!rectangle_in_rectangle(_x, _y, _x + 15, _y + 15, _x1, _y1, _x2, _y2)
					&& !collision_rectangle(_x, _y, _x + 15, _y + 15, Floor, false, true)
				){
					var	_shake = UberCont.opt_shake,
						_sleep = UberCont.opt_freeze,
						_sound = sound_play_pitchvol(0, 0, 0);
						
					UberCont.opt_shake = 0;
					UberCont.opt_freeze = 0;
					
					with(instances_matching_gt(GameObject, "id", instance_create(_x, _y, FloorExplo))){
						instance_delete(id);
					}
					
					UberCont.opt_shake = _shake;
					UberCont.opt_freeze = _sleep;
					
					for(var i = _sound; audio_is_playing(i); i++){
						sound_stop(i);
					}
				}
			}
		}
		with(instance_rectangle(bbox_left, bbox_top, bbox_right + 1, bbox_bottom + 1, Detail)){
			instance_destroy();
		}
		with(instances_meeting(x, y, SnowFloor)){
			instance_destroy();
		}
		instance_destroy();
	}
	
#define floor_tunnel(_x1, _y1, _x2, _y2)
	/*
		Creates a PortalClear that destroys all Walls between two given points, making a FloorExplo tunnel
		Tunnel's height defaults to 32, set its 'image_yscale' to change
	*/
	
	with(instance_create(_x1, _y1, PortalClear)){
		var	_dis = point_distance(x, y, _x2, _y2),
			_dir = point_direction(x, y, _x2, _y2);
			
		sprite_index = sprBoltTrail;
		image_xscale = _dis / bbox_width;
		image_yscale = 32 / bbox_height;
		image_angle = _dir;
		image_speed = 16 / _dis;
		
		 // Ensure Tunnel:
		if(instance_exists(Wall) && !place_meeting(x, y, Wall) && !place_meeting(x, y, Floor)){
			with(instance_nearest_bbox(x, y, Wall)){
				instance_create(x + pfloor(other.x - x, 16), y + pfloor(other.y - y, 16), Wall);
			}
		}
		
		return id;
	}
	
	return noone;
	
#define floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)
	/*
		Returns a safe starting x/y and direction to use with 'floor_room_create()'
		Searches through the given Floor tiles for one that is far enough away from the spawn and can be reached from the spawn (no Walls in between)
		
		Args:
			spawnX/spawnY - The spawn point
			spawnDis      - Minimum distance that the starting x/y must be from the spawn point
			spawnFloor    - Potential starting floors to search
			
		Ex:
			with(floor_room_start(10016, 10016, 128, FloorNormal)){
				floor_room_create(x, y, 2, 2, "", direction, [60, 90], 96);
			}
	*/
	
	with(array_shuffle(instances_matching(_spawnFloor, "", null))){
		var	_x = bbox_center_x,
			_y = bbox_center_y;
			
		if(point_distance(_spawnX, _spawnY, _x, _y) >= _spawnDis){
			var _spawnReached = false;
			
			 // Make Sure it Reaches the Spawn Point:
			var _pathWall = [Wall, InvisiWall];
			for(var _fx = bbox_left; _fx < bbox_right + 1; _fx += 16){
				for(var _fy = bbox_top; _fy < bbox_bottom + 1; _fy += 16){
					if(path_reaches(path_create(_fx + 8, _fy + 8, _spawnX, _spawnY, _pathWall), _spawnX, _spawnY, _pathWall)){
						_spawnReached = true;
						break;
					}
				}
				if(_spawnReached) break;
			}
			
			 // Success bro!
			if(_spawnReached){
				return {
					"x" : _x,
					"y" : _y,
					"direction" : point_direction(_spawnX, _spawnY, _x, _y),
					"id" : id
				};
			}
		}
	}
	
	return noone;
	
#define floor_room_create(_x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis)
	/*
		Moves toward a given direction until an open space is found, then creates a room based on the width, height, and script
		Rooms will always connect to the level as long as floorDis <= 0 (and the starting x/y is over a floor)
		Rooms will not overlap existing Floors as long as floorDis >= 0 (they can still overlap FloorExplo)
		
		Args:
			x/y      - The point to begin the search for an open space to create the room
			w/h      - Width/height of the room to create
			type     - The type of room to create (see 'floor_fill' script)
			dirStart - The direction to search towards for an open space
			dirOff   - Random directional offset to use while searching towards dirStart
			floorDis - How far from the level to create the room
			           Use 0 to spawn adjacent to the level, >0 to create an isolated room, <0 to overlap the level
			
		Ex:
			floor_room_create(10016, 10016, 5, 3, "round", random(360), 0, 0)
	*/
	
	 // Find Space:
	var	_move = true,
		_floorAvoid = FloorNormal,
		_dis = 16,
		_dir = 0,
		_ow = (_w * 32) / 2,
		_oh = (_h * 32) / 2,
		_sx = _x,
		_sy = _y;
		
	if(!is_array(_dirOff)) _dirOff = [_dirOff];
	while(array_length(_dirOff) < 2) array_push(_dirOff, 0);
	
	while(_move){
		var	_x1 = _x - _ow,
			_y1 = _y - _oh,
			_x2 = _x + _ow,
			_y2 = _y + _oh,
			_inst = instance_rectangle_bbox(_x1 - _floorDis, _y1 - _floorDis, _x2 + _floorDis - 1, _y2 + _floorDis - 1, _floorAvoid);
			
		 // No Corner Floors:
		if(_type == "round" && _floorDis <= 0){
			with(_inst){
				if((bbox_right < _x1 + 32 || bbox_left >= _x2 - 32) && (bbox_bottom < _y1 + 32 || bbox_top >= _y2 - 32)){
					_inst = array_delete_value(_inst, self);
				}
			}
		}
		
		 // Floors in Range:
		_move = false;
		if(array_length(_inst) > 0){
			if(_floorDis <= 0){
				_move = true;
			}
			
			 // Floor Distance Check:
			else with(_inst){
				var	_fx = clamp(_x, bbox_left, bbox_right + 1),
					_fy = clamp(_y, bbox_top, bbox_bottom + 1),
					_fDis = (
						(_type == "round")
						? min(
							point_distance(_fx, _fy, clamp(_fx, _x1 + 32, _x2 - 32), clamp(_fy, _y1,      _y2     )),
							point_distance(_fx, _fy, clamp(_fx, _x1,      _x2     ), clamp(_fy, _y1 + 32, _y2 - 32))
						)
						: point_distance(_fx, _fy, clamp(_fx, _x1, _x2), clamp(_fy, _y1, _y2))
					);
					
				if(_fDis < _floorDis){
					_move = true;
					break;
				}
			}
			
			 // Keep Searching:
			if(_move){
				_dir = pround(_dirStart + (random_range(_dirOff[0], _dirOff[1]) * choose(-1, 1)), 90);
				_x += lengthdir_x(_dis, _dir);
				_y += lengthdir_y(_dis, _dir);
			}
		}
	}
	
	 // Create Room:
	var	_floorNumLast = array_length(FloorNormal),
		_floors = mod_script_call_nc(mod_type_current, mod_current, "floor_fill", _x, _y, _w, _h, _type),
		_floorNum = array_length(FloorNormal),
		_x1 = _x,
		_y1 = _y,
		_x2 = _x,
		_y2 = _y;
		
	if(array_length(_floors) > 0){
		with(_floors[0]){
			_x1 = bbox_left;
			_y1 = bbox_top;
			_x2 = bbox_right + 1;
			_y2 = bbox_bottom + 1;
		}
		with(_floors){
			var	_fx1 = bbox_left,
				_fy1 = bbox_top,
				_fx2 = bbox_right,
				_fy2 = bbox_bottom;
				
			 // Determine Room's Dimensions:
			_x1 = min(_x1, _fx1);
			_y1 = min(_y1, _fy1);
			_x2 = max(_x2, _fx2 + 1);
			_y2 = max(_y2, _fy2 + 1);
			
			 // Fix Potential Wall Softlock:
			if(_floorDis <= 0 && _floorNum == _floorNumLast + array_length(_floors)){
				with(instance_rectangle_bbox(_fx1 - 1, _fy1,     _fx2 + 1, _fy2,     Wall)) if(place_meeting(x, y, Floor)) instance_destroy();
				with(instance_rectangle_bbox(_fx1,     _fy1 - 1, _fx2,     _fy2 + 1, Wall)) if(place_meeting(x, y, Floor)) instance_destroy();
			}
		}
	}
	
	 // Done:
	return {
		floors : _floors,
		x      : (_x1 + _x2) / 2,
		y      : (_y1 + _y2) / 2,
		x1     : _x1,
		y1     : _y1,
		x2     : _x2,
		y2     : _y2,
		xstart : _sx,
		ystart : _sy
	};
	
#define floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)
	/*
		Automatically creates a room a safe distance from the spawn point
		Rooms will always connect to the level as long as floorDis <= 0
		Rooms will not overlap existing Floors as long as floorDis >= 0 (they can still overlap FloorExplo)
		
		Args:
			spawnX/spawnY - The spawn point
			spawnDis      - Minimum distance from the spawn point to begin searching for an open space
			spawnFloor    - Potential starting floors to begin searching for an open space from
			w/h           - Width/height of the room to create
			type          - The type of room to create (see 'floor_fill' script)
			dirOff        - Random directional offset to use while moving away from the spawn point to find an open space
			floorDis      - How far from the level to create the room
			                Use 0 to spawn adjacent to the level, >0 to create an isolated room, <0 to overlap the level
			
		Ex:
			floor_room(10016, 10016, 96, FloorNormal, 4, 4, "round", 60, -32)
	*/
	
	with(floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)){
		with(floor_room_create(x, y, _w, _h, _type, direction, _dirOff, _floorDis)){
			return self;
		}
	}
	
	return noone;
	
	
#define wall_clear(_x1, _y1, _x2, _y2)
	with(instance_rectangle_bbox(_x1, _y1, _x2, _y2, [Wall, TopSmall, TopPot, Bones, InvisiWall])){
		instance_delete(id);
	}
	
#define wall_tops()
	var _minID = GameObject.id;
	instance_create(x - 16, y - 16, Top);
	instance_create(x - 16, y,      Top);
	instance_create(x,      y - 16, Top);
	instance_create(x,      y,      Top);
	return instances_matching_gt(TopSmall, "id", _minID);
	
#define wall_update(_x1, _y1, _x2, _y2)
	with(instance_rectangle(_x1, _y1, _x2, _y2, Wall)){
		 // Fix:
		visible = place_meeting(x, y + 16, Floor);
		l = (place_free(x - 16, y) ?  0 :  4);
		w = (place_free(x + 16, y) ? 24 : 20) - l;
		r = (place_free(x, y - 16) ?  0 :  4);
		h = (place_free(x, y + 16) ? 24 : 20) - r;
		
		 // TopSmalls:
		wall_tops();
	}
	
#define instance_budge(_objAvoid, _disMax)
	var	_isArray = is_array(_objAvoid),
		_canWall = (!place_meeting(x, y, Floor) || (_isArray ? array_exists(_objAvoid, Wall) : (_objAvoid == Wall)));
		
	 // Auto Max Distance:
	if(_disMax < 0){
		var	_w = 0,
			_h = 0;
			
		with(_isArray ? _objAvoid : [_objAvoid]){
			if(object_exists(self)){
				var _mask = object_get_mask(self);
				if(_mask == -1) _mask = object_get_sprite(self);
				_w = max(_w, (sprite_get_bbox_right(_mask) + 1) - sprite_get_bbox_left(_mask));
				_h = max(_h, (sprite_get_bbox_bottom(_mask) + 1) - sprite_get_bbox_top(_mask));
			}
			else{
				_w = max(_w, bbox_width);
				_h = max(_h, bbox_height);
			}
		}
		
		_disMax = (sqrt(sqr(bbox_width + _w) + sqr(bbox_height + _h)) / 2) + _disAdd;
	}
	
	 // Starting Direction:
	var _dirStart = 0;
	if(x != xprevious || y != yprevious){
		_dirStart = point_direction(x, y, xprevious, yprevious);
	}
	else{
		_dirStart = point_direction(hspeed, vspeed, 0, 0);
	}
	
	 // Search for Open Space:
	var	_dis = 0,
		_disAdd = 4;
		
	while(_dis <= _disMax){
		 // Look Around:
		var _dirAdd = 360 / max(1, 4 * _dis);
		for(var _dir = _dirStart; _dir < _dirStart + 360; _dir += _dirAdd){
			var	_x = x + lengthdir_x(_dis, _dir),
				_y = y + lengthdir_y(_dis, _dir);
				
			if(_isArray ? (array_length(instances_meeting(_x, _y, _objAvoid)) <= 0) : !place_meeting(_x, _y, _objAvoid)){
				if(_canWall || (place_free(_x, _y) && (position_meeting(_x, _y, Floor) || place_meeting(_x, _y, Floor)))){
					x = _x;
					y = _y;
					xprevious = x;
					yprevious = y;
					
					return true;
				}
			}
		}
		
		 // Go Outward:
		if(_dis >= _disMax) break;
		_dis = min(_dis + clamp(_dis, 1, _disAdd), _disMax);
	}
	
	return false;

#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)
	var	_disMax	= point_distance(_x1, _y1, _x2, _y2),
		_disAdd	= min(_disMax / 8, 10) + (_enemy ? (array_length(instances_matching_ge(instances_matching(CustomEnemy, "name", "Eel"), "arcing", 1)) - 1) : 0),
		_dis	= _disMax,
		_dir	= point_direction(_x1, _y1, _x2, _y2),
		_x		= _x1,
		_y		= _y1,
		_lx		= _x,
		_ly		= _y,
		_ox		= lengthdir_x(_disAdd, _dir),
		_oy		= lengthdir_y(_disAdd, _dir),
		_obj	= (_enemy ? EnemyLightning : Lightning),
		_inst	= [],
		_team	= variable_instance_get(self, "team", -1),
		_hitid	= variable_instance_get(self, "hitid", -1),
		_imgInd	= -1,
		_imgSpd	= 0.4,
		a, _off, _wx, _wy;

	while(_dis > _disAdd){
		_dis -= _disAdd;
		_x += _ox;
		_y += _oy;

		 // Wavy Offset:
		if(_dis > _disAdd){
			a = (_dis / _disMax) * pi;
			_off = 4 * sin((_dis / 8) + (current_frame / 6));
			_wx = _x + lengthdir_x(_off, _dir - 90) + (_arc * sin(a));
			_wy = _y + lengthdir_y(_off, _dir - 90) + (_arc * sin(a / 2));
		}

		 // End:
		else{
			_wx = _x2;
			_wy = _y2;
		}

		 // Lightning:
		with(instance_create(_wx, _wy, _obj)){
			ammo = ceil(_dis / _disAdd);
			image_xscale = -point_distance(_lx, _ly, x, y) / 2;
			image_angle = point_direction(_lx, _ly, x, y);
			direction = image_angle;
			hitid = _hitid;
			creator = other;
			team = _team;

			 // Exists 1 Frame - Manually Animate:
			if(_imgInd < 0){
				_imgInd = ((current_frame + _arc) * image_speed) % image_number;
				_imgSpd = (image_number - _imgInd);
			}
			image_index = _imgInd;
			image_speed_raw = _imgSpd;

			array_push(_inst, id);
		}

		_lx = _wx;
		_ly = _wy;
	}

	 // FX:
	if(chance_ct(array_length(_inst), 200)){
		with(_inst[irandom(array_length(_inst) - 1)]){
			with(instance_create(x + orandom(8), y + orandom(8), PortalL)){
				motion_add(random(360), 1);
			}
			if(_enemy) sound_play_hit(sndLightningReload, 0.5);
			else sound_play_pitchvol(sndLightningReload, 1.25 + random(0.5), 0.5);
		}
	}

	return _inst;

#define wep_get(_wep)
	if(is_object(_wep)){
		return wep_get(lq_defget(_wep, "wep", wep_none));
	}
	return _wep;

#define wep_merge(_stock, _front)
	return mod_script_call_nc("weapon", "merge", "weapon_merge", _stock, _front);

#define wep_merge_decide(_hardMin, _hardMax)
	return mod_script_call_nc("weapon", "merge", "weapon_merge_decide", _hardMin, _hardMax);

#define weapon_decide(_hardMin, _hardMax, _gold, _noWep)
	 // Robot:
	for(var i = 0; i < maxp; i++) if(player_get_race(i) == "robot") _hardMax++;
	_hardMin += (5 * ultra_get("robot", 1));
	
	 // Just in Case:
	_hardMax = max(0, _hardMax);
	_hardMin = min(_hardMin, _hardMax);
	
	 // Default:
	var _wepDecide = wep_screwdriver;
	if(_gold != 0){
		_wepDecide = choose(wep_golden_wrench, wep_golden_machinegun, wep_golden_shotgun, wep_golden_crossbow, wep_golden_grenade_launcher, wep_golden_laser_pistol);
		if(GameCont.loops > 0 && random(2) < 1){
			_wepDecide = choose(wep_golden_screwdriver, wep_golden_assault_rifle, wep_golden_slugger, wep_golden_splinter_gun, wep_golden_bazooka, wep_golden_plasma_gun);
		}
	}
	
	 // Decide:
	var	_list = ds_list_create(),
		_listMax = weapon_get_list(_list, _hardMin, _hardMax);
		
	ds_list_shuffle(_list);
	
	for(var i = 0; i < _listMax; i++){
		var	_wep = ds_list_find_value(_list, i),
			_canWep = true;
			
		 // Weapon Exceptions:
		if(_wep == _noWep || (is_array(_noWep) && array_exists(_noWep, _wep))){
			_canWep = false;
		}
		
		 // Gold Check:
		else if((_gold > 0 && !weapon_get_gold(_wep)) || (_gold < 0 && weapon_get_gold(_wep) == 0)){
			_canWep = false;
		}
		
		 // Specific Spawn Conditions:
		else switch(_wep){
			case wep_super_disc_gun:       if("curse" not in self || curse <= 0) _canWep = false; break;
			case wep_golden_nuke_launcher: if(!UberCont.hardmode)                _canWep = false; break;
			case wep_golden_disc_gun:      if(!UberCont.hardmode)                _canWep = false; break;
			case wep_gun_gun:              if(crown_current != crwn_guns)        _canWep = false; break;
		}
		
		 // Success:
		if(_canWep){
			_wepDecide = _wep;
			break;
		}
	}
	
	ds_list_destroy(_list);
	
	return _wepDecide;
	
#define weapon_get_loadout(_wep)
	/*
		Returns the loadout sprite associated with a given weapon
	*/
	
	var _wepRaw = wep_get(_wep);
	
	 // Custom:
	if(is_string(_wepRaw)){
		return mod_script_call("weapon", _wepRaw, "weapon_loadout", _wep);
	}
	
	 // Normal:
	else switch(_wepRaw){
		case wep_revolver               : return sprRevolverLoadout;
		case wep_golden_revolver        : return sprGoldRevolverLoadout;
		case wep_chicken_sword          : return sprChickenSwordLoadout;
		case wep_rogue_rifle            : return sprRogueRifleLoadout;
		case wep_rusty_revolver         : return sprRustyRevolverLoadout;
		case wep_golden_wrench          : return sprGoldWrenchLoadout;
		case wep_golden_machinegun      : return sprGoldMachinegunLoadout;
		case wep_golden_shotgun         : return sprGoldShotgunLoadout;
		case wep_golden_crossbow        : return sprGoldCrossbowLoadout;
		case wep_golden_grenade_launcher: return sprGoldGrenadeLauncherLoadout;
		case wep_golden_laser_pistol    : return sprGoldLaserPistolLoadout;
		case wep_golden_screwdriver     : return sprGoldScrewdriverLoadout;
		case wep_golden_assault_rifle   : return sprGoldAssaultRifleLoadout;
		case wep_golden_slugger         : return sprGoldSluggerLoadout;
		case wep_golden_splinter_gun    : return sprGoldSplintergunLoadout;
		case wep_golden_bazooka         : return sprGoldBazookaLoadout;
		case wep_golden_plasma_gun      : return sprGoldPlasmaGunLoadout;
		case wep_golden_nuke_launcher   : return sprGoldNukeLauncherLoadout;
		case wep_golden_disc_gun        : return sprGoldDiscgunLoadout;
		case wep_golden_frog_pistol     : return sprGoldToxicGunLoadout;
	}
	
	return 0;
	
#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)
	 // Auto-Determine Grid Size:
	var	_tileSize = 16,
		_areaWidth  = (ceil(abs(_xtarget - _xstart) / _tileSize) * _tileSize) + 320,
		_areaHeight = (ceil(abs(_ytarget - _ystart) / _tileSize) * _tileSize) + 320;

	_areaWidth = max(_areaWidth, _areaHeight);
	_areaHeight = max(_areaWidth, _areaHeight);

	var _triesMax = 4 * ceil((_areaWidth + _areaHeight) / _tileSize);

	 // Clamp Path X/Y:
	_xstart = floor(_xstart / _tileSize) * _tileSize;
	_ystart = floor(_ystart / _tileSize) * _tileSize;
	_xtarget = floor(_xtarget / _tileSize) * _tileSize;
	_ytarget = floor(_ytarget / _tileSize) * _tileSize;

	 // Grid Setup:
	var	_gridw = ceil(_areaWidth / _tileSize),
		_gridh = ceil(_areaHeight / _tileSize),
		_gridx = round((((_xstart + _xtarget) / 2) - (_areaWidth  / 2)) / _tileSize) * _tileSize,
		_gridy = round((((_ystart + _ytarget) / 2) - (_areaHeight / 2)) / _tileSize) * _tileSize,
		_grid = ds_grid_create(_gridw, _gridh),
		_gridCost = ds_grid_create(_gridw, _gridh);

	ds_grid_clear(_grid, -1);

	 // Mark Walls:
	with(instance_rectangle(_gridx, _gridy, _gridx + _areaWidth, _gridy + _areaHeight, _wall)){
		if(position_meeting(x, y, id)){
			_grid[# (x - _gridx) / _tileSize, (y - _gridy) / _tileSize] = -2;
		}
	}

	 // Pathing:
	var	_x1 = (_xtarget - _gridx) / _tileSize,
		_y1 = (_ytarget - _gridy) / _tileSize,
		_x2 = (_xstart - _gridx) / _tileSize,
		_y2 = (_ystart - _gridy) / _tileSize,
		_searchList = [[_x1, _y1, 0]],
		_tries = _triesMax;

	while(_tries-- > 0){
		var	_search = _searchList[0],
			_sx = _search[0],
			_sy = _search[1],
			_sp = _search[2];

		if(_sp >= infinity) break; // No more searchable tiles
		_search[2] = infinity;

		 // Sort Through Neighboring Tiles:
		var _costSoFar = _gridCost[# _sx, _sy];
		for(var i = 0; i < 2*pi; i += pi/2){
			var	_nx = _sx + cos(i),
				_ny = _sy - sin(i),
				_nc = _costSoFar + 1;

			if(_grid[# _nx, _ny] == -1){
				if(_nx >= 0 && _ny >= 0){
					if(_nx < _gridw && _ny < _gridh){
						_gridCost[# _nx, _ny] = _nc;
						_grid[# _nx, _ny] = point_direction(_nx, _ny, _sx, _sy);

						 // Add to Search List:
						array_push(_searchList, [
							_nx,
							_ny,
							point_distance(_x2, _y2, _nx, _ny) + (abs(_x2 - _nx) + abs(_y2 - _ny)) + _nc
						]);
					}
				}
			}

			 // Path Complete:
			if(_nx == _x2 && _ny == _y2){
				_tries = 0;
				break;
			}
		}

		 // Next:
		array_sort_sub(_searchList, 2, true);
	}

	 // Pack Path into Array:
	var	_x = _xstart,
		_y = _ystart,
		_path = [[_x + (_tileSize / 2), _y + (_tileSize / 2)]],
		_tries = _triesMax;

	while(_tries-- > 0){
		var _dir = _grid[# ((_x - _gridx) / _tileSize), ((_y - _gridy) / _tileSize)];
		if(_dir >= 0){
			_x += lengthdir_x(_tileSize, _dir);
			_y += lengthdir_y(_tileSize, _dir);
			array_push(_path, [_x + (_tileSize / 2), _y + (_tileSize / 2)]);
		}
		else{
			_path = []; // Couldn't find path
			break;
		}

		 // Done:
		if(_x == _xtarget && _y == _ytarget){
			break;
		}
	}
	if(_tries <= 0) _path = []; // Couldn't find path

	ds_grid_destroy(_grid);
	ds_grid_destroy(_gridCost);

	return _path;

#define path_shrink(_path, _wall, _skipMax)
	var	_pathNew = [],
		_link = 0;

	if(!is_array(_wall)) _wall = [_wall];

	for(var i = 0; i < array_length(_path); i++){
		 // Save Important Points on Path:
		var _save = (
			i <= 0                       ||
			i >= array_length(_path) - 1 ||
			i - _link >= _skipMax
		);

		 // Save Points Going Around Walls:
		if(!_save){
			var	_x1 = _path[i + 1, 0],
				_y1 = _path[i + 1, 1],
				_x2 = _path[_link, 0],
				_y2 = _path[_link, 1];

			for(var j = 0; j < array_length(_wall); j++){
				if(collision_line(_x1, _y1, _x2, _y2, _wall[j], false, false)){
					_save = true;
					break;
				}
			}
		}

		 // Store:
		if(_save){
			array_push(_pathNew, _path[i]);
			_link = i;
		}
	}

	return _pathNew;
	
#define path_reaches(_path, _xtarget, _ytarget, _wall)
	if(!is_array(_wall)) _wall = [_wall];
	
	var m = array_length(_path);
	if(m > 0){
		var	_x = _path[m - 1, 0],
			_y = _path[m - 1, 1];
			
		for(var i = 0; i < array_length(_wall); i++){
			if(collision_line(_x, _y, _xtarget, _ytarget, _wall[i], false, false)){
				return false;
			}
		}
		
		return true;
	}
	
	return false;
	
#define path_direction(_path, _x, _y, _wall)
	if(!is_array(_wall)) _wall = [_wall];

	 // Find Nearest Unobstructed Point on Path:
	var	_nearest = -1,
		_disMax = infinity;

	for(var i = 0; i < array_length(_path); i++){
		var	_px = _path[i, 0],
			_py = _path[i, 1],
			_dis = point_distance(_x, _y, _px, _py);

		if(_dis < _disMax){
			var _walled = false;
			for(var j = 0; j < array_length(_wall); j++){
				if(collision_line(_x, _y, _px, _py, _wall[j], false, false)){
					_walled = true;
					break;
				}
			}
			if(!_walled){
				_disMax = _dis;
				_nearest = i;
			}
		}
	}

	 // Find Direction to Next Point on Path:
	if(_nearest >= 0){
		var	_follow = min(_nearest + 1, array_length(_path) - 1),
			_nx = _path[_follow, 0],
			_ny = _path[_follow, 1];

		 // Go to Nearest Point if Path to Next Point Obstructed:
		for(var j = 0; j < array_length(_wall); j++){
			if(collision_line(x, y, _nx, _ny, _wall[j], false, false)){
				_nx = _path[_nearest, 0];
				_ny = _path[_nearest, 1];
				break;
			}
		}

		return point_direction(x, y, _nx, _ny);
	}

	return null;
	
#define path_draw(_path)
	var	_x = x,
		_y = y;
		
	with(_path){
		draw_line(self[0], self[1], _x, _y);
		_x = self[0];
		_y = self[1];
	}
	
#define race_get_sprite(_race, _sprite)
	/*
		Returns the matching sprite for a given race
		
		Ex:
			race_get_sprite("crystal", sprMutant1Walk) == sprMutant2Walk
	*/
	
	 // Custom:
	var _scrt = "race_sprite";
	if(is_string(_race) && mod_script_exists("race", _race, _scrt)){
		if(!instance_is(self, Player) || race != _race){
			var _new = mod_script_call("race", _race, _scrt, _sprite);
			if(is_real(_new) && sprite_exists(_new)){
				_sprite = _new;
			}
		}
	}
	
	 // Normal:
	else{
		var	_id = race_get_id(_race),
			_name = race_get_name(_race);
			
		if(_id >= 17) _id = 1;
		
		switch(_sprite){
			case sprMutant1Idle:
			case sprMutant1Walk:
			case sprMutant1Hurt:
			case sprMutant1Dead:
			case sprMutant1GoSit:
			case sprMutant1Sit:
				
				var _new = asset_get_index(string_replace(
					sprite_get_name(_sprite),
					"1",
					_id
				));
				
				if(sprite_exists(_new)){
					_sprite = _new;
				}
				
				break;
				
			 // Menu:
			case sprFishMenu:
			case sprFishMenuSelected:
			case sprFishMenuSelect:
			case sprFishMenuDeselect:
				
				var _new = asset_get_index(string_replace(
					sprite_get_name(_sprite),
					"Fish",
					string_upper(string_char_at(_name, 1)) + string_lower(string_delete(_name, 1, 1))
				));
				
				if(sprite_exists(_new)){
					_sprite = _new;
				}
				
				break;
				
			 // Shadow:
			case shd24:
				
				if(_id == 13) _sprite = shd96;
				
				break;
		}
	}
	
	return skin_get_sprite(variable_instance_get(self, "bskin"), _sprite);
	
#define race_get_title(_race)
	/*
		The same as 'race_get_alias(_race)', but supports modded races
	*/
	
	var _id = race_get_id(_race);
		
	 // Custom:
	if(is_string(_race) && _id == 17){
		var	_scrt = "race_name",
			_title = mod_script_call("race", _race, _scrt);
			
		if(is_string(_title)){
			return _title;
		}
		
		return _scrt;
	}
	
	 // Normal:
	return race_get_alias(_id);
	
#define race_get_skin_list(_race)
	/*
		Returns a list of a given race's skins
	*/
	
	var _num = 1;
	
	switch(race_get_id(_race)){
		case char_fish:
		case char_crystal:
		case char_eyes:
		case char_melting:
		case char_plant:
		case char_steroids:
		case char_chicken:
		case char_rebel:
		case char_horror:
		case char_rogue:
		case char_skeleton:
			_num = 2;
			break;
			
		case char_venuz:
		case char_robot:
			_num = 3;
			break;
			
		default: // CUSTOM
			if(is_string(_race)){
				var _skins = mod_script_call("race", _race, "race_skins");
				if(is_real(_skins)){
					_num = _skins;
				}
			}
	}
	
	 // Add Normal Skins to List:
	var _list = array_create(_num, 0);
	for(var i = 0; i < array_length(_list); i++){
		_list[i] = i;
	}
	
	 // Add Skin Mods to List:
	with(mod_get_names("skin")){
		if(race_get_id(mod_script_call("skin", self, "skin_race")) == race_get_id(_race)){
			array_push(_list, self);
		}
	}
	
	return _list;
	
#define skin_get_sprite(_skin, _sprite)
	/*
		Returns a given skin's variant of a given sprite
		
		Ex:
			skin_get_sprite(1, sprShield) == sprShieldB
			skin_get_sprite("tree", sprShield) == (Shield sprite for 'tree.skin.gml')
	*/
	
	switch(_sprite){
		 // FISH:
		case sprMutant1Idle:            return sprite_skin(_skin, _sprite, sprMutant1BIdle);
		case sprMutant1Walk:            return sprite_skin(_skin, _sprite, sprMutant1BWalk);
		case sprMutant1Hurt:            return sprite_skin(_skin, _sprite, sprMutant1BHurt);
		case sprMutant1Dead:            return sprite_skin(_skin, _sprite, sprMutant1BDead);
		case sprMutant1GoSit:           return sprite_skin(_skin, _sprite, sprMutant1BGoSit);
		case sprMutant1Sit:             return sprite_skin(_skin, _sprite, sprMutant1BSit);
		
		 // CRYSTAL:
		case sprMutant2Idle:            return sprite_skin(_skin, _sprite, sprMutant2BIdle);
		case sprMutant2Walk:            return sprite_skin(_skin, _sprite, sprMutant2BWalk);
		case sprMutant2Hurt:            return sprite_skin(_skin, _sprite, sprMutant2BHurt);
		case sprMutant2Dead:            return sprite_skin(_skin, _sprite, sprMutant2BDead);
		case sprMutant2GoSit:           return sprite_skin(_skin, _sprite, sprMutant2BGoSit);
		case sprMutant2Sit:             return sprite_skin(_skin, _sprite, sprMutant2BSit);
		case sprShield:                 return sprite_skin(_skin, _sprite, sprShieldB);
		case sprCrystTrail:             return sprite_skin(_skin, _sprite, sprCrystTrailB);
		case sprCrystalShieldIdleFront: return sprite_skin(_skin, _sprite, sprCrystalShieldBIdleFront);
		case sprCrystalShieldWalkFront: return sprite_skin(_skin, _sprite, sprCrystalShieldBWalkFront);
		case sprCrystalShieldIdleBack:  return sprite_skin(_skin, _sprite, sprCrystalShieldBIdleBack);
		case sprCrystalShieldWalkBack:  return sprite_skin(_skin, _sprite, sprCrystalShieldBWalkBack);
		
		 // EYES:
		case sprMutant3Idle:            return sprite_skin(_skin, _sprite, sprMutant3BIdle);
		case sprMutant3Walk:            return sprite_skin(_skin, _sprite, sprMutant3BWalk);
		case sprMutant3Hurt:            return sprite_skin(_skin, _sprite, sprMutant3BHurt);
		case sprMutant3Dead:            return sprite_skin(_skin, _sprite, sprMutant3BDead);
		case sprMutant3GoSit:           return sprite_skin(_skin, _sprite, sprMutant3BGoSit);
		case sprMutant3Sit:             return sprite_skin(_skin, _sprite, sprMutant3BSit);
		
		 // MELTING:
		case sprMutant4Idle:            return sprite_skin(_skin, _sprite, sprMutant4BIdle);
		case sprMutant4Walk:            return sprite_skin(_skin, _sprite, sprMutant4BWalk);
		case sprMutant4Hurt:            return sprite_skin(_skin, _sprite, sprMutant4BHurt);
		case sprMutant4Dead:            return sprite_skin(_skin, _sprite, sprMutant4BDead);
		case sprMutant4GoSit:           return sprite_skin(_skin, _sprite, sprMutant4BGoSit);
		case sprMutant4Sit:             return sprite_skin(_skin, _sprite, sprMutant4BSit);
		
		 // PLANT:
		case sprMutant5Idle:            return sprite_skin(_skin, _sprite, sprMutant5BIdle);
		case sprMutant5Walk:            return sprite_skin(_skin, _sprite, sprMutant5BWalk);
		case sprMutant5Hurt:            return sprite_skin(_skin, _sprite, sprMutant5BHurt);
		case sprMutant5Dead:            return sprite_skin(_skin, _sprite, sprMutant5BDead);
		case sprMutant5GoSit:           return sprite_skin(_skin, _sprite, sprMutant5BGoSit);
		case sprMutant5Sit:             return sprite_skin(_skin, _sprite, sprMutant5BSit);
		case sprTangle:                 return sprite_skin(_skin, _sprite, sprTangleB);
		case sprTangleSeed:             return sprite_skin(_skin, _sprite, sprTangleSeedB);
		
		 // YV:
		case sprMutant6Idle:            return sprite_skin(_skin, _sprite, sprMutant6BIdle,  sprMutant16Idle);
		case sprMutant6Walk:            return sprite_skin(_skin, _sprite, sprMutant6BWalk,  sprMutant16Walk);
		case sprMutant6Hurt:            return sprite_skin(_skin, _sprite, sprMutant6BHurt,  sprMutant16Hurt);
		case sprMutant6Dead:            return sprite_skin(_skin, _sprite, sprMutant6BDead,  sprMutant16Dead);
		case sprMutant6GoSit:           return sprite_skin(_skin, _sprite, sprMutant6BGoSit, sprMutant16GoSit);
		case sprMutant6Sit:             return sprite_skin(_skin, _sprite, sprMutant6BSit,   sprMutant16Sit);
		
		 // STEROIDS:
		case sprMutant7Idle:            return sprite_skin(_skin, _sprite, sprMutant7BIdle);
		case sprMutant7Walk:            return sprite_skin(_skin, _sprite, sprMutant7BWalk);
		case sprMutant7Hurt:            return sprite_skin(_skin, _sprite, sprMutant7BHurt);
		case sprMutant7Dead:            return sprite_skin(_skin, _sprite, sprMutant7BDead);
		case sprMutant7GoSit:           return sprite_skin(_skin, _sprite, sprMutant7BGoSit);
		case sprMutant7Sit:             return sprite_skin(_skin, _sprite, sprMutant7BSit);
		
		 // ROBOT:
		case sprMutant8Idle:            return sprite_skin(_skin, _sprite, sprMutant8BIdle,  sprMutant8CIdle);
		case sprMutant8Walk:            return sprite_skin(_skin, _sprite, sprMutant8BWalk,  sprMutant8CWalk);
		case sprMutant8Hurt:            return sprite_skin(_skin, _sprite, sprMutant8BHurt,  sprMutant8CHurt);
		case sprMutant8Dead:            return sprite_skin(_skin, _sprite, sprMutant8BDead,  sprMutant8CDead);
		case sprMutant8GoSit:           return sprite_skin(_skin, _sprite, sprMutant8BGoSit, sprMutant8CGoSit);
		case sprMutant8Sit:             return sprite_skin(_skin, _sprite, sprMutant8BSit,   sprMutant8CSit);
		
		 // CHICKEN:
		case sprMutant9Idle:            return sprite_skin(_skin, _sprite, sprMutant9BIdle);
		case sprMutant9Walk:            return sprite_skin(_skin, _sprite, sprMutant9BWalk);
		case sprMutant9Hurt:            return sprite_skin(_skin, _sprite, sprMutant9BHurt);
		case sprMutant9GoSit:           return sprite_skin(_skin, _sprite, sprMutant9BGoSit);
		case sprMutant9Sit:             return sprite_skin(_skin, _sprite, sprMutant9BSit);
		case sprMutant9HeadIdle:        return sprite_skin(_skin, _sprite, sprMutant9BHeadIdle);
		case sprMutant9HeadHurt:        return sprite_skin(_skin, _sprite, sprMutant9BHeadHurt);
		
		 // REBEL:
		case sprMutant10Idle:           return sprite_skin(_skin, _sprite, sprMutant10BIdle, sprMutant10CIdle);
		case sprMutant10Walk:           return sprite_skin(_skin, _sprite, sprMutant10BWalk, sprMutant10CWalk);
		case sprMutant10Hurt:           return sprite_skin(_skin, _sprite, sprMutant10BHurt, sprMutant10CHurt);
		case sprMutant10Dead:           return sprite_skin(_skin, _sprite, sprMutant10BDead, sprMutant10CDead);
		case sprMutant10GoSit:          return sprite_skin(_skin, _sprite, sprMutant10BGoSit);
		case sprMutant10Sit:            return sprite_skin(_skin, _sprite, sprMutant10BSit);
		
		 // HORROR:
		case sprMutant11Idle:           return sprite_skin(_skin, _sprite, sprMutant11BIdle);
		case sprMutant11Walk:           return sprite_skin(_skin, _sprite, sprMutant11BWalk);
		case sprMutant11Hurt:           return sprite_skin(_skin, _sprite, sprMutant11BHurt);
		case sprMutant11Dead:           return sprite_skin(_skin, _sprite, sprMutant11BDead);
		case sprMutant11GoSit:          return sprite_skin(_skin, _sprite, sprMutant11BGoSit);
		case sprMutant11Sit:            return sprite_skin(_skin, _sprite, sprMutant11BSit);
		case sprHorrorBullet:           return sprite_skin(_skin, _sprite, sprHorrorBBullet);
		case sprHorrorBulletHit:        return sprite_skin(_skin, _sprite, sprHorrorBulletHitB);
		case sprHorrorHit:              return sprite_skin(_skin, _sprite, sprHorrorHitB);
		
		 // ROGUE:
		case sprMutant12Idle:           return sprite_skin(_skin, _sprite, sprMutant12BIdle);
		case sprMutant12Walk:           return sprite_skin(_skin, _sprite, sprMutant12BWalk);
		case sprMutant12Hurt:           return sprite_skin(_skin, _sprite, sprMutant12BHurt);
		case sprMutant12Dead:           return sprite_skin(_skin, _sprite, sprMutant12BDead);
		case sprMutant12GoSit:          return sprite_skin(_skin, _sprite, sprMutant12BGoSit);
		case sprMutant12Sit:            return sprite_skin(_skin, _sprite, sprMutant12BSit);
		
		 // SKELETON:
		case sprMutant14Idle:           return sprite_skin(_skin, _sprite, sprMutant14BIdle);
		case sprMutant14Walk:           return sprite_skin(_skin, _sprite, sprMutant14BWalk);
		case sprMutant14Hurt:           return sprite_skin(_skin, _sprite, sprMutant14BHurt);
		case sprMutant14Dead:           return sprite_skin(_skin, _sprite, sprMutant14BDead);
		case sprMutant14GoSit:          return sprite_skin(_skin, _sprite, sprMutant14BGoSit);
		case sprMutant14Sit:            return sprite_skin(_skin, _sprite, sprMutant14BSit);
	}
	
	return sprite_skin(_skin, _sprite);
	
#define skin_get_name(_race, _skin)
	/*
		Returns the name of a race's skin as it appears on the loadout menu
	*/
	
	 // Modded Skin:
	if(is_string(_skin)){
		var _name = mod_script_call("skin", _skin, "skin_name", true);
		if(is_string(_name)){
			return _name;
		}
	}
	
	 // Modded Race:
	else if(is_string(_race)){
		var _name = mod_script_call("race", _race, "race_skin_name", _skin);
		if(is_string(_name)){
			return _name;
		}
	}
	
	 // Default:
	var _skinList = race_get_skin_list(_race);
	return chr(ord("A") + max(0, array_find_index(_skinList, _skin))) + " SKIN";
	
#define pet_create(_x, _y, _name, _modType, _modName)
	with(obj_create(_x, _y, "Pet")){
		pet = _name;
		mod_name = _modName;
		mod_type = _modType;
		
		 // Stats:
		var _stat = `pet:${pet}.${mod_name}.${mod_type}`;
		if(!is_object(stat_get(_stat))){
			stat_set(_stat, { found:0, owned:0 });
		}
		stat = stat_get(_stat);
		
		 // Sprites:
		if(mod_type == "mod" && mod_name == "petlib"){
			spr_idle = lq_defget(spr, "Pet" + pet + "Idle", spr_idle);
			spr_walk = lq_defget(spr, "Pet" + pet + "Walk", spr_idle);
			spr_hurt = lq_defget(spr, "Pet" + pet + "Hurt", spr_idle);
			spr_dead = lq_defget(spr, "Pet" + pet + "Dead", mskNone);
		}
		spr_icon = lq_defget(pet_get_icon(mod_type, mod_name, pet), "spr", spr_icon);
		
		 // Custom Create Event:
		var _scrt = pet + "_create";
		if(mod_script_exists(mod_type, mod_name, _scrt)){
			mod_script_call(mod_type, mod_name, _scrt);
		}
		
		 // Auto-set Stuff:
		if(instance_exists(self)){
			with(pickup_indicator) if(text == ""){
				text = `@2(${other.spr_icon})` + other.pet;
			}
			if(sprite_index == spr.PetParrotIdle) sprite_index = spr_idle;
			if(maxhealth > 0 && my_health == 0) my_health = maxhealth;
			if(hitid == -1) hitid = [spr_idle, pet];
		}
		
		return self;
	}
	return noone;
	
#define pet_spawn(_x, _y, _name)
	return pet_create(_x, _y, _name, "mod", "petlib");
	
#define pet_get_icon(_modType, _modName, _name)
	var _icon = {
		spr	: spr.PetParrotIcon,
		img	: 0.4 * current_frame,
		x	: 0,
		y	: 0,
		xsc	: 1,
		ysc	: 1,
		ang	: 0,
		col	: c_white,
		alp	: 1
	};
	
	 // Custom:
	var _modScrt = _name + "_icon";
	if(mod_script_exists(_modType, _modName, _modScrt)){
		var _iconCustom = mod_script_call(_modType, _modName, _modScrt);
		
		if(is_real(_iconCustom)){
			_icon.spr = _iconCustom;
		}
		
		else{
			for(var i = 0; i < min(array_length(_iconCustom), lq_size(_icon)); i++){
				lq_set(_icon, lq_get_key(_icon, i), real(_iconCustom[i]));
			}
		}
	}
	
	 // Default:
	else if(_modType == "mod" && _modName == "petlib"){
		if(variable_instance_get(self, "name") == "Pet" && sprite_exists(variable_instance_get(self, "spr_icon", -1))){
			_icon.spr = spr_icon;
		}
		else{
			_icon.spr = lq_defget(spr, "Pet" + _name + "Icon", -1);
		}
	}
	
	return _icon;
	
#define top_create(_x, _y, _obj, _spawnDir, _spawnDis)
	/*
		Creates a wall-top object at the given position and automatically moves them away from floors
		Set spawnDir/spawnDis to -1 for spawnDir/spawnDis to be automatic
		Also accepts an instance as the object argument
		
		Ex:
			top_create(mouse_x, mouse_y, Bandit, -1, -1)
	*/
	
	var _inst = _obj;
	if(!is_real(_obj) || _obj < 100000){
		_inst = obj_create(_x, _y, _obj);
	}
	with(_inst){
		x = _x;
		y = _y;
		xprevious = x;
		yprevious = y;
		
		 // Don't Clear Walls:
		if(instance_is(self, hitme) || instance_is(self, chestprop)){
			with(instances_matching(instances_matching(instances_matching_gt([PortalClear, PortalShock], "id", id), "xstart", xstart), "ystart", ystart)){
				instance_destroy();
			}
		}
	}
	
	 // Top-ify:
	if(array_length(instances_matching(instances_matching(CustomObject, "name", "TopObject"), "target", _inst)) <= 0){
		with(obj_create(_x, _y, "TopObject")){
			target = _inst;
			
			if(instance_exists(target)){
				target.top_object = id;
				spawn_dis = random_range(16, 48);
				
				 // Object-General Setup:
				if(instance_is(target, hitme)){
					unstick = true;
					
					 // Enemy:
					if(instance_is(target, enemy)){
						type = enemy;
						idle_time = 90 + random(90);
						
						 // Fix Facing:
						if(target.direction == 0 && "walk" not in target && "right" in target){
							with(target){
								direction = random(360);
								scrRight(direction);
							}
						}
					}
					
					 // Prop:
					else if(instance_is(target, prop)){
						spawn_dis = random_range(8, 16);
						
						 // Death on Impact:
						if(target.team == 0 && target.size <= 1 && target.maxhealth < 50){
							target_save.my_health = 0;
						}
					}
				}
				else if(instance_is(target, Effect) || instance_is(target, Corpse)){
					override_depth = false;
					depth = -6.01;
					if(instance_is(target, Corpse)) depth -= 0.001;
				}
				else if(instance_is(target, chestprop) || instance_is(target, Pickup)){
					wobble = 8;
					spawn_dis = 8;
					if(instance_is(target, Pickup)){
						override_depth = false;
						depth = -6.0111;
						jump = 0;
					}
					if(instance_is(target, chestprop) || instance_is(target, WepPickup)){
						unstick = true;
					}
				}
				else if(instance_is(target, projectile)){
					jump = 0;
					type = projectile;
				}
				else if(instance_is(target, Explosion) || instance_is(target, MeatExplosion) || instance_is(target, PlasmaImpact)){
					jump = 0;
					grav = 0;
					type = projectile;
					override_mask = false;
					override_depth = false;
					depth = -8;
				}
				else if(instance_is(target, ReviveArea) || instance_is(target, NecroReviveArea) || instance_is(target, RevivePopoFreak)){
					jump = 0;
					grav = 0;
					override_mask = false;
					override_depth = false;
					depth = -6.01;
				}
				else if(instance_is(target, IDPDSpawn) || instance_is(target, VanSpawn)){
					jump = 0;
					grav = 0;
					override_depth = false;
					depth = -6.01;
				}
				
				 // Object-Specific Setup:
				switch((string_pos("Custom", object_get_name(target.object_index)) == 1 && "name" in target) ? target.name : target.object_index){
					 /// ENEMIES ///
					case BoneFish:
					case "Puffer":
					case "Hammerhead":
						idle_walk = [0, 5];
						idle_walk_chance = 1/2;
						break;
						
					case Exploder:
						jump_time = 1;
						break;
						
					case ExploFreak:
						jump *= 1.2;
						idle_walk = [0, 5];
						idle_walk_chance = 1;
						spawn_dis = random_range(120, 192);
						
						 // Important:
						target_save.my_health = 0;
						break;
						
					case Freak:
						idle_walk = [0, 5];
						idle_walk_chance = 1;
						spawn_dis = random_range(80, 240);
						break;
						
					case JungleFly:
						jump = 0;
						grav = random_range(0.1, 0.3);
						idle_walk = [8, 12];
						idle_walk_chance = 1/2;
						break;
						
					case MeleeBandit:
						idle_walk = [10, 30];
						idle_walk_chance = 1/2;
						break;
						
					case Necromancer:
						jump *= 2/3;
						idle_walk_chance = 1/16;
						break;
						
					case "Seal":
						idle_walk_chance = 1/12;
						break;
						
					case "Spiderling":
						jump *= 4/5;
						idle_walk_chance = 1/4;
						break;
						
					case "TopRaven":
					case "BoneRaven":
						type = RavenFly;
						jump = 2;
						grav = 0;
						canmove = true;
						spr_shadow_y--;
						break;
						
					 /// PROPS ///
					case Anchor:
					case OasisBarrel:
					case WaterMine:
						mask_index = target.spr_shadow;
						image_xscale = 0.5;
						image_yscale = 0.5;
						spr_shadow = mskNone;
						break;
						
					case Barrel:
					case GoldBarrel:
					case ToxicBarrel:
						jump *= 1.5;
						spawn_dis = ((target.object_index == Barrel) ? 32 : 8);
						spr_shadow = shd16;
						spr_shadow_y = 4;
						wobble = 8;
						break;
						
					case BigFlower:
					case IceFlower:
						override_depth = false;
						depth = -6.01;
						spr_shadow = target.spr_idle;
						spr_shadow_y = 1;
						break;
						
					case Bush:
					case JungleAssassinHide:
						spr_shadow_y = -1;
						break;
						
					case Cactus:
						with(target){
							var t = choose("", "3");
							if(true || chance(2, 3)) t = "B" + t; // Rotten epic
							spr_idle = asset_get_index("sprCactus" + t);
							spr_hurt = asset_get_index("sprCactus" + t + "Hurt");
							spr_dead = asset_get_index("sprCactus" + t + "Dead");
						}
						//case NightCactus:
						spr_shadow = sprMine;
						spr_shadow_y = 9;
						break;
						
					case Car:
						spawn_dis = 16;
						break;
						
					case Cocoon:
					case "NewCocoon":
						spr_shadow = shd16;
						spr_shadow_y = 3;
						break;
						
					case FireBaller:
					case SuperFireBaller:
						z += random(8);
						jump = random(1);
						grav = random_range(0.1, 0.2);
						break;
						
					case FrogEgg:
						grav = 1.5;
						break;
						
					case Generator:
						spawn_dis = 64;
						spr_shadow = ((target.image_xscale < 0) ? spr.shd.BigGeneratorR : spr.shd.BigGenerator);
						target_save.my_health = 0;
						break;
						
					case Hydrant:
						spawn_dis = random_range(32, 96);
						
						 // Icicle:
						if(chance(1, 2) || target.spr_idle == sprIcicle) with(target){
							spr_idle = sprIcicle;
							spr_hurt = sprIcicleHurt;
							spr_dead = sprIcicleDead;
							snd_hurt = sndHitRock;
							snd_dead = sndIcicleBreak;
							spr_shadow = shd16;
							spr_shadow_y = 3;
						}
						break;
						
					case MeleeFake:
						spr_shadow = sprMine;
						spr_shadow_y = 7;
						break;
						
					case MoneyPile:
						spawn_dis = 8;
						spr_shadow_y = -1;
						break;
						
					case Pillar:
						spr_shadow = shd32;
						spr_shadow_y = -3;
						break;
						
					case Pipe:
						spr_shadow = sprMine;
						spr_shadow_y = 7;
						break;
						
					case Server:
						spr_shadow = sprHydrant;
						spr_shadow_y = 5;
						break;
						
					case SmallGenerator:
						spawn_dis = 32;
						target.image_xscale = 1;
						spr_shadow = target.spr_idle;
						spr_shadow_y = 1;
						break;
						
					case SnowMan:
						spawn_dis = random_range(8, 40);
						spr_shadow = sprNewsStand;
						spr_shadow_y = 5;
						break;
						
					case Terminal:
						spr_shadow_y = 1;
						break;
						
					case Tires:
						spawn_dis = random_range(16, 32);
						spr_shadow_y = -1;
						break;
						
					case "WepPickupGrounded":
						jump = 3;
						wobble = 8;
						unstick = true;
						break;
				}
				
				 // Shadow:
				if("spr_shadow" in target){
					if(spr_shadow   == -1) spr_shadow   = target.spr_shadow;
					if(spr_shadow_x ==  0) spr_shadow_x = target.spr_shadow_x;
					if(spr_shadow_y ==  0) spr_shadow_y = target.spr_shadow_y;
				}
				
				 // Hitbox:
				if(mask_index == -1){
					image_xscale = 0.5;
					image_yscale = 0.5;
					
					 // Default:
					if(spr_shadow == -1){
						mask_index = target.sprite_index;
					}
					
					 // Shadow-Based:
					else{
						mask_index = spr_shadow;
						mask_y = spr_shadow_y + (((bbox_top - y) * (1 - image_yscale)));
					}
				}
				
				 // Push Away From Floors:
				if(_spawnDir >= 0){
					spawn_dir = ((_spawnDir % 360) + 360) % 360;
				}
				else with(instance_nearest_bbox(x, y, Floor)){
					other.spawn_dir = point_direction(bbox_center_x, bbox_center_y, other.x, other.y);
				}
				if(_spawnDis >= 0){
					spawn_dis = _spawnDis;
				}
				if(spawn_dis > 0){
					while(true){
						var _dis = max(
							spawn_dis      - distance_to_object(Floor),
							spawn_dis + 16 - distance_to_object(PortalClear),
							16             - distance_to_object(Bones),
							8              - distance_to_object(TopPot),
							8              - distance_to_object(CustomObject)
						);
						if(_dis > 0){
							_dis = max(1, _dis);
							x += lengthdir_x(_dis, spawn_dir);
							y += lengthdir_y(_dis, spawn_dir);
						}
						else break;
					}
				}
				x = round(x);
				y = round(y);
				
				/// Post-Setup:
					 // Enemy:
					if(instance_is(target, enemy)){
						 // Setup Time Until Jump Mode:
						if(jump_time == 0){
							with(instance_nearest(x - 16, y - 16, Floor)){ //instance_nearest_bbox(x, y, Floor)){
								other.jump_time = 90 + (distance_to_object(Player) * (2 + GameCont.loops));
							}
						}
						
						 // No Movin:
						if("walk" not in target && type != RavenFly){
							canmove = false;
						}
					}
					
					 // Object-Specific Post-Setup:
					switch(target.object_index){
						case BoneFish:
						case Freak:
						case "Puffer":
						case "Hammerhead": // Swimming bro
							if(area_get_underwater(GameCont.area)){
								z += random_range(8, distance_to_object(Floor) / 2) * ((target.object_index == "Puffer") ? 0.5 : 1);
							}
							break;
							
						case FrogEgg: // Hatch
							target.alarm0 = irandom(150) + (distance_to_object(Player) * (1 + GameCont.loops));
							target_save.alarm0 = random_range(10, 30);
							break;
							
						case JungleFly: // Bro hes actually flying real
							z += random_range(4, 16 + (distance_to_object(Floor) / 2));
							break;
					}
					
					 // Type-Specific:
					switch(type){
						case enemy:
							
							 // Disable AI:
							with(target){
								for(var i = 0; i <= 10; i++){
									lq_set(other.target_save, `alarm${i}`, alarm_get(i));
									alarm_set(i, -1);
								}
							}
							
							break;
					}
					
				 // Underwater Time:
				if(area_get_underwater(GameCont.area)){
					jump /= 6;
					grav /= 4;
				}
				
				 // Insta-Land:
				var n = instance_nearest(x - 16, y - 16, Floor); //instance_nearest_bbox(x, y, Floor);
				if(
					instance_exists(n)                                                                                                            &&
					!instance_exists(NothingSpiral)                                                                                               &&
					!collision_line(x, y + 8, (n.bbox_left + n.bbox_right + 1) / 2, (n.bbox_top + n.bbox_bottom + 1) / 2, Wall,     false, false) &&
					!collision_line(x, y + 8, (n.bbox_left + n.bbox_right + 1) / 2, (n.bbox_top + n.bbox_bottom + 1) / 2, TopSmall, false, false)
				){
					zspeed = jump;
					zfriction = grav;
				}
				
				 // TopSmalls:
				else if(instance_is(target, prop)) with(target){
					var _xsc = image_xscale;
					image_xscale = sign(image_xscale * variable_instance_get(self, "right", 1));
					
					var	_west = bbox_left - 8,
						_east = bbox_right + 1 + 8,
						_nort = y - 8,
						_sout = bbox_bottom + 1 + 8,
						_shad = ((other.spr_shadow != -1) ? other.spr_shadow : spr_shadow),
						_chance = 4/5;
						
					if(sprite_get_bbox_right(_shad) - sprite_get_bbox_left(_shad) > 64){
						_chance = 1;
					}
					
					for(var _ox = _west; _ox < _east; _ox += 16){
						for(var _oy = _nort; _oy < _sout; _oy += 16){
							if(chance(_chance, 1)){
								var	_sx = floor(_ox / 16) * 16,
									_sy = floor(_oy / 16) * 16;
									
								if(!position_meeting(_sx, _sy, Floor) && !position_meeting(_sx, _sy, Wall) && !position_meeting(_sx, _sy, TopSmall)){
									instance_create(_sx, _sy, TopSmall);
								}
							}
						}
					}
					
					image_xscale = _xsc;
				}
				
				 // Depth:
				if(override_depth) depth = -6 - ((y - 8) / 10000);
				
				 // Search Zone:
				with(target){
					var m = mask_index;
					mask_index = -1;
					other.search_x1 = min(x - 8, bbox_left);
					other.search_x2 = max(x + 8, bbox_right);
					other.search_y1 = min(y - 8, bbox_top);
					other.search_y2 = max(y + 8, bbox_bottom);
					mask_index = m;
				}
			}
			
			with(self) event_perform(ev_step, ev_step_end);
			
			return self;
		}
	}
	
	return noone;
	
#define floor_make(_x, _y, _obj)
	/*
		Creates a floor at the given position and creates an object on it
		
		Ex:
			floor_make(x, y, WeaponChest)
	*/
	
	with(floor_set(_x, _y, true)){
		_x = x;
		_y = y;
	}
	
	return instance_create(_x + 16, _y + 16, _obj);
	
#define floor_fill(_x, _y, _w, _h, _type)
	/*
		Creates a rectangular area of floors around the given position
		The type can be "" for default, "round" for no corners, or "ring" for no inner floors
		
		Ex:
			floor_fill(x, y, 3, 3, "")
				###
				###
				###
				
			floor_fill(x, y, 5, 4, "round")
				 ###
				#####
				#####
				 ###
				 
			floor_fill(x, y, 4, 4, "ring")
				####
				#  #
				#  #
				####
	*/
	
	var	_ow = 32,
		_oh = 32;
		
	_w *= _ow;
	_h *= _oh;
	
	 // Center & Align:
	_x -= (_w / 2);
	_y -= (_h / 2);
	var _gridPos = floor_align(_x, _y, _w, _h, _type);
	_x = _gridPos[0];
	_y = _gridPos[1];
	
	 // Floors:
	var	_ax = global.floor_align_x,
		_ay = global.floor_align_y,
		_aw = global.floor_align_w,
		_ah = global.floor_align_h,
		_inst = [];
		
	floor_set_align(_ow, _oh, _x, _y);
	
	for(var _ox = 0; _ox < _w; _ox += _ow){
		for(var _oy = 0; _oy < _h; _oy += _oh){
			var _make = true;
			
			 // Type-Specific:
			switch(_type){
				case "round": // No Corner Floors
					_make = ((_ox != 0 && _ox != _w - _ow) || (_oy != 0 && _oy != _h - _oh));
					break;
					
				case "ring": // No Inner Floors
					_make = (_ox == 0 || _oy == 0 || _ox == _w - _ow || _oy == _h - _oh);
					break;
			}
			
			if(_make){
				array_push(_inst, floor_set(_x + _ox, _y + _oy, true));
			}
		}
	}
	
	floor_set_align(_aw, _ah, _ax, _ay);
	
	return _inst;
	
#define door_create(_x, _y, _dir)
	/*
		Creates a double CatDoor for a normal Floor
		Returns an array containing both doors
		
		Ex:
			with(FloorNormal){
				door_create(bbox_center_x, bbox_center_y, 90);
			}
	*/
	
	var	_dx = _x + lengthdir_x(16 - 2, _dir),
		_dy = _y + lengthdir_y(16 - 2, _dir) + 1,
		_partner = noone,
		_inst = [];
		
	for(var _side = -1; _side <= 1; _side += 2){
		with(obj_create(_dx + lengthdir_x(16 * _side, _dir - 90), _dy + lengthdir_y(16 * _side, _dir - 90), "CatDoor")){
			image_angle = _dir;
			image_yscale = -_side;
			
			 // Link Doors:
			partner = _partner;
			with(partner) partner = other;
			_partner = id;
			
			 // Ensure LoS Wall Creation:
			with(self) event_perform(ev_step, ev_step_normal);
			
			array_push(_inst, id);
		}
	}
	
	return _inst;
	
#define player_create(_x, _y, _index)
	/*
		Creates a Player of the given index at the given coordinates
	*/
	
	with(instance_create(_x, _y, CustomHitme)){
		with(instance_create(x, y, Revive)){
			p = _index;
			canrevive = true;
			event_perform(ev_collision, Player);
			event_perform(ev_alarm, 0);
		}
		instance_destroy();
	}
	
	with(player_find(_index)){
		my_health = maxhealth;
		sound_stop(snd_hurt);
		return id;
	}
	
	return noone;

#define trace_error(_error)
	trace(_error);
	trace_color(" ^ Screenshot that error and post it on NTTE's itch.io page, thanks!", c_yellow);
	
#define sleep_max(_milliseconds)
	/*
		Like 'sleep()', but doesn't stack with multiple 'sleep_max()' calls on the same frame
	*/
	
	global.sleep_max = max(global.sleep_max, _milliseconds);
	
#define view_shift(_index, _dir, _pan)
	/*
		Moves a given player's screen a given distance toward a given direction
		Basically the second argument of "weapon_post()", but usable outside of a Player object
	*/
	
	if(_index < 0){
		for(var i = 0; i < maxp; i++){
			view_shift(i, _dir, _pan);
		}
	}
	else{
		var _shake = UberCont.opt_shake;
		UberCont.opt_shake = 1;
		
		with(instance_create(0, 0, Revive)){
			try{
				p = _index;
				instance_change(Player, false);
				gunangle = _dir;
				weapon_post(0, _pan * current_time_scale, 0);
			}
			catch(_error){
				trace_error(_error);
			}
			
			instance_delete(id);
		}
		
		UberCont.opt_shake = _shake;
	}
	
#define sound_play_hit_ext(_sound, _pitch, _volume)
	/*
		'sound_play_hit()' distance-based sound, but with pitch and volume arguments
	*/
	
	var s = sound_play_hit(_sound, 0);
	sound_pitch(s, _pitch);
	sound_volume(s, audio_sound_get_gain(s) * _volume);
	
	return s;

#define rad_drop(_x, _y, _raddrop, _dir, _spd)
	/*
		Creates rads at the given coordinates in enemy death fashion
	*/
	
	var _inst = [];
	
	while(_raddrop > 0){
		var r = (_raddrop > 15);
		repeat(r ? 1 : _raddrop){
			if(r) _raddrop -= 10;
			with(instance_create(_x, _y, (r ? BigRad : Rad))){
				speed = _spd;
				direction = _dir;
				motion_add(random(360), random(_raddrop / 2) + 3);
				speed *= power(0.9, speed);
				array_push(_inst, id);
			}
		}
		if(!r) break;
	}
	
	return _inst;

#define rad_path(_inst, _target)
	var _bind = instances_matching(CustomScript, "name", "rad_path_step");
	
	 // Bind Script:
	if(array_length(_bind) <= 0){
		_bind = script_bind_end_step(rad_path_step, 0);
		with(_bind){
			name = script[2];
			inst = [];
			vars = [];
		}
	}
	
	 // Add to List:
	with(_bind){
		var	_instList = inst,
			_varsList = vars,
			i = array_length(_varsList);
			
		with(_inst){
			if(array_find_index(_instList, self) < 0){
				array_push(_instList, self);
				array_push(_varsList, {
					targ     : _target,
					path     : [],
					can_path : true,
					heal     : 0
				});
			}
		}
		
		return array_slice(_varsList, i, array_length(_varsList) - i);
	}
	
	return [];
	
#define rad_path_step
	var	_instList = inst,
		_varsList = vars,
		i = 0;
		
	with(_instList){
		var	_vars = _varsList[i],
			_targ = _vars.targ;
			
		if(instance_exists(self) && instance_exists(_targ)){
			var	_tx = _targ.x,
				_ty = _targ.y,
				_path = _vars.path;
				
			if(array_length(_path) > 0){
				 // Direction to Follow:
				var _dir = null;
				if(collision_line(x, y, _tx, _ty, Wall, false, false)){
					_dir = path_direction(_path, x, y, Wall);
				}
				else{
					_dir = point_direction(x, y, _tx, _ty);
				}
				
				 // Movin:
				if(_dir != null){
					 // Accelerate:
					speed = min(speed + random(max(friction_raw, 2 * current_time_scale)), 12);
					
					 // Follow Path:
					direction += angle_difference(_dir, direction) * min(1, max(0.2, 16 / point_distance(x, y, _tx, _ty)) * current_time_scale);
					
					 // Spinny:
					image_angle += speed_raw;
					
					 // Bounce Less:
					if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
						var _min = min(speed, 2);
						if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw = 0;
						if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw = 0;
						speed = max(_min, speed);
						if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw = 0;
						if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw = 0;
					}
				}
				else _vars.path = [];
				
				 // Done:
				if(place_meeting(x, y, _targ) || (_targ.mask_index == mskNone && point_in_rectangle(x, y, _targ.bbox_left, _targ.bbox_top, _targ.bbox_right, _targ.bbox_bottom))){
					if(instance_is(_targ, Player)) speed = 0;
					else{
						if("raddrop" in _targ) _targ.raddrop += rad;
						
						 // Heal:
						var _heal = _vars.heal;
						if(_heal > 0) with(_targ){
							my_health += _heal;
							
							 // Effects:
							sound_play_hit(sndHPPickup, 0.3);
							with(instance_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), FrogHeal)){
								if(chance(1, 3)) sprite_index = spr.BossHealFX;
								depth = other.depth - 1;
							}
						}
						
						 // Effects:
						sound_play_hit(sndRadPickup, 0.5);
						with(instance_create(x, y, EatRad)){
							if(other.sprite_index == sprBigRad) sprite_index = sprEatBigRad;
						}
						
						instance_destroy();
					}
				}
			}
			else if(speed <= friction_raw * 2){
				speed = max(speed, friction_raw);
				
				 // Target in Sight:
				if(!_vars.can_path){
					if(!collision_line(x, y, _tx, _ty, Wall, false, false)){
						_vars.can_path = true;
					}
				}
				
				 // Create Path:
				if(_vars.can_path && !path_reaches(_path, _tx, _ty, Wall)){
					_path = path_create(x, y, _tx, _ty, Wall);
					_path = path_shrink(_path, Wall, 2);
					_vars.path = _path;
					_vars.can_path = false;
					
					 // Send Path to Bros:
					var j = 0;
					with(_instList){
						var v = _varsList[j++];
						if(v.targ == _targ && array_length(v.path) <= 0 && self != other){
							if(instance_exists(self) && !collision_line(x, y, other.x, other.y, Wall, false, false)){
								v.path = _path;
								v.can_path = false;
							}
						}
					}
				}
			}
			i++;
		}
		
		 // Done:
		else{
			_instList = array_delete(_instList, i);
			_varsList = array_delete(_varsList, i);
			
			 // Heal FX:
			if(_vars.heal){
				var n = 0;
				with(_varsList) if(targ == _targ) n++;
				if(n <= 0) with(_targ){
					with(instance_create(x, y, FrogHeal)){
						sprite_index = spr.BossHealFX;
						depth = other.depth - 1;
						image_xscale *= 1.5;
						image_yscale *= 1.5;
						vspeed -= 1;
					}
					with(instance_create(x, y, LevelUp)) creator = other;
					sound_play_hit_ext(sndLevelUltra, 2 + orandom(0.1), 1.7);
				}
			}
		}
	}
	inst = _instList;
	vars = _varsList;
	
	 // Goodbye:
	if(array_length(_instList) <= 0){
		instance_destroy();
	}
	
#define sprite_get_team(_sprite)
	/*
		Returns what team a sprite is based on
		
		Example:
			sprite_get_team(sprAllyBullet) == 2
	*/
	
	if(ds_map_exists(spriteTeamMap, _sprite)){
		return spriteTeamMap[? _sprite];
	}
	
	return -1;
	
#define team_get_sprite(_team, _sprite)
	/*
		Returns the given team's variant of a sprite, returns _sprite if none exists
		
		Example:
			team_get_sprite(1, sprFlakBullet) == sprEFlak
	*/
	
	var	_spriteList = teamSpriteMap[? _sprite],
		_spriteIndex = _team - spriteTeamStart;
		
	if(_spriteIndex >= 0 && _spriteIndex < array_length(_spriteList)){
		return _spriteList[_spriteIndex];
	}
	
	return _sprite;
	
#define team_instance_sprite(_team, _inst)
	/*
		Visually changes a projectile to a given team's variant, if it exists
	*/
	
	var _newInst = [_inst];
	
	with(_inst){
		var	_spr = sprite_index,
			_obj = (("name" in self && string_pos("Custom", object_get_name(object_index)) == 1) ? name : object_index);
			
		 // Sprite:
		sprite_index = team_get_sprite(_team, _spr);
		
		 // Object, for hardcoded stuff:
		if(ds_map_exists(teamSpriteObjectMap, _obj)){
			var	_objList = teamSpriteObjectMap[? _obj][? _spr],
				_objIndex = _team - spriteTeamStart;
				
			if(_objIndex >= 0 && _objIndex < array_length(_objList)){
				var _newObj = _objList[_objIndex];
				if(_obj != _newObj){
					with(obj_create(x, y, _newObj)){
						array_push(_newInst, id);
						variable_instance_set_list(self, variable_instance_get_list(other));
						instance_delete(other);
						
						if(array_exists(["CustomBullet", "CustomFlak", "CustomShell", "CustomPlasma"], _newObj)){
							var _sprAlly = team_get_sprite(2, sprite_index);
							
							 // Destruction Sprite:
							switch(_sprAlly){
								case sprHeavyBullet        : spr_dead = sprHeavyBulletHit;   break;
								case sprAllyBullet         : spr_dead = sprAllyBulletHit;    break;
								case sprBullet2            :
								case sprBullet2Disappear   : spr_dead = sprBullet2Disappear; break;
								case sprSlugBullet         :
								case sprSlugDisappear      :
								case sprHyperSlug          :
								case sprHyperSlugDisappear : spr_dead = sprSlugHit;          break;
								case sprHeavySlug          :
								case sprHeavySlugDisappear : spr_dead = sprHeavySlugHit;     break;
								case sprFlakBullet         : spr_dead = sprFlakHit;          break;
								case sprSuperFlakBullet    : spr_dead = sprSuperFlakHit;     break;
								case sprPlasmaBall         : spr_dead = sprPlasmaImpact;     break;
								default                    : spr_dead = sprBulletHit;
							}
							spr_dead = team_get_sprite(_team, spr_dead);
							
							 // Specifics:
							switch(_newObj){
								
								case "CustomFlak":
								
									 // Specifics:
									switch(_obj){
										case SuperFlakBullet:
											snd_dead = sndSuperFlakExplode;
											bonus_damage = 5;
											flak = array_create(5, FlakBullet);
											super = true;
											break;
											
										case EFlakBullet:
											bonus_damage = 0;
											flak = array_create(10);
											for(var i = 0; i < array_length(flak); i++){
												flak[i] = {
													object_index : EnemyBullet3,
													speed : random_range(9, 12)
												};
											}
											break;
									}
									
									break;
									
								case "CustomShell":
								
									 // Disappear Sprite:
									switch(_sprAlly){
										case sprSlugBullet:
										case sprSlugDisappear:
											spr_dead = sprSlugDisappear;
											break;
											
										case sprHeavySlug:
										case sprHeavySlugDisappear:
											spr_dead = sprHeavySlugDisappear;
											break;
											
										default:
											spr_dead = sprBullet2Disappear;
									}
									spr_fade = team_get_sprite(_team, spr_dead);
									
									 // Specifics:
									switch(_obj){
										case Slug      : bonus_damage = 2;  break;
										case HeavySlug : bonus_damage = 10; break;
										case PopoSlug  : bonus_damage = 0;  break;
									}
									
									break;
									
								case "CustomPlasma":
									
									 // Trail Sprite:
									spr_trail = team_get_sprite(_team, sprPlasmaTrail);
									
									 // Specifics:
									switch(_obj){
										case PlasmaBig:
										case PlasmaHuge:
											snd_dead = sndPlasmaBigExplode;
											minspeed = 6;
											flak = ((_obj == PlasmaHuge) ? array_create(4, PlasmaBig) : array_create(10, PlasmaBall));
											break;
									}
									
									break;
									
							}
						}
					}
				}
			}
		}
	}
	
	_newInst = instances_matching(_newInst, "", null);
	
	if(array_length(_newInst) <= 0) return noone;
	return ((array_length(_newInst) == 1) ? _newInst[0] : _newInst);
	