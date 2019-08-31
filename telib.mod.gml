#define chat_command(_cmd, _arg, _ind) /// debug commands
    switch(_cmd){
    	case "ntte":
    		var _menu = mod_variable_get("mod", "ntte", "menu");
    		_menu.open = !_menu.open;
    		return true;
    	
        case "pet":
            Pet_spawn(mouse_x[_ind], mouse_y[_ind], _arg);
            return true;

		case "wepmerge":
			var a = string_split(_arg, "/"),
				w = wep_none;

			if(array_length(a) >= 2){
				w = wep_merge(a[0], a[1]);
			}
			else{
				w = wep_merge(a[0], a[0]);
			}

			with(instance_create(mouse_x[_ind], mouse_y[_ind], WepPickup)){
				wep = w;
				ammo = true;
			}
			return true;

		case "debuglag":
			var _mod = [];
			if(_arg != ""){
				var	p = 0;
				for(var i = 0; i <= string_length(_arg); i++){
					if(string_char_at(_arg, i) == "."){
						p = i;
					}
				}
	
				var	_name = ((p <= 0) ? _arg : string_copy(_arg, 1, p - 1)),
					_type = ((p <= 0) ? "mod" : string_delete(_arg, 1, p));
	
				array_push(_mod, [_type, _name]);
			}
			else{
				DebugLag = !DebugLag;
				with(["mod", "weapon", "race", "skill", "crown", "area", "skin"]){
					with(mod_get_names(self)){
						array_push(_mod, [other, self]);
					}
				}
			}

			with(_mod){
				var _type = self[0],
					_name = self[1],
					_varn = "debug_lag";

				if(mod_variable_exists(_type, _name, _varn)){
					var _state = ((_arg != "") ? !mod_variable_get(_type, _name, _varn) : DebugLag);
					if(_state ^^ mod_variable_get(_type, _name, _varn)){
						mod_variable_set(_type, _name, _varn, _state);
						trace_color((_state ? "ENABLED" : "DISABLED") + " " + _name + "." + _type, (_state ? c_lime : c_red));
					}
				}
				else if(_arg != ""){
					trace_color("Cannot debug lag for " + _arg, c_red);
				}
			}

			return true;

		case "unlockall":
		case "unlockreset":
			var _unlock = (_cmd == "unlockall");

			with(global.debug_unlock){
				unlock_set(self, _unlock);
			}

			scrUnlock("", "@wEVERYTHING " + (_unlock ? "@gUNLOCKED" : "@rLOCKED"), -1, -1);
			sound_play(_unlock ? sndGoldUnlock : sndCursedChest);
			return true;

		case "unlocktoggle":
			var _unlock = !unlock_get(_arg);

			unlock_set(_arg, _unlock);

			scrUnlock("", "@w" + _arg + " " + (_unlock ? "@gUNLOCKED" : "@rLOCKED"), -1, -1);
			sound_play(_unlock ? sndGoldUnlock : sndCursedChest);
			return true;

		case "charm":
			scrCharm(instance_create(mouse_x[_ind], mouse_y[_ind], asset_get_index(_arg)), true);
			return true;
    }


#define init
	global.debug_unlock = ["parrot", "parrotB", "coastWep", "oasisWep", "trenchWep", "lairWep", "lairCrown", "crownCrime", "boneScythe"];
	chat_comp_add("unlocktoggle", "(unlock name)", "toggle an unlock");
	with(global.debug_unlock) chat_comp_add_arg("unlocktoggle", 0, self);
	chat_comp_add("wepmerge", "(stock)", "/", "(front)", "spawn a merged weapon");
	for(var i = 1; i <= 127; i++){ var t = string_replace_all(string_lower(weapon_get_name(i)), " ", "_"); chat_comp_add_arg("wepmerge", 0, t); chat_comp_add_arg("wepmerge", 2, t); }
	chat_comp_add("charm", "(object)", "spawn a charmed object");
	for(var i = 1; i < object_max; i++) if(object_is_ancestor(i, hitme) || i == ReviveArea || i == NecroReviveArea || i == MaggotExplosion || i == RadMaggotExplosion){ chat_comp_add_arg("charm", 0, object_get_name(i)); }
	/** Delete above on release **/
	
	
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.sav = mod_variable_get("mod", "teassets", "sav");

    global.debug_lag = false;

	 // sleep_max():
	global.sleep_max = 0;

	 // Add an object to this list if you want it to appear in cheats mod spawn menu or if you want to specify create event arguments for it in global.objectScrt:
    global.objectList = {
		"tegeneral"	  : ["AllyFlakBullet", "BatDisc", "BigDecal", "BoneArrow", "BoneSlash", "BoneFX", "BubbleBomb", "BubbleExplosion", "BubbleExplosionSmall", "FlakBall", "FlySpin", "Harpoon", "HarpoonStick", "HyperBubble", "NetNade", "ParrotFeather", "ParrotChester", "Pet", "PickupIndicator", "PortalPrevent", "ReviveNTTE", "TeslaCoil", "VenomPellet"],
		"tepickups"   : ["Backpack", "BackpackPickup", "BatChest", "BoneBigPickup", "BonePickup", "CatChest", "ChestShop", "CursedAmmoChest", "CustomChest", "CustomPickup", "HarpoonPickup", "OverhealPickup", "OverstockPickup", "Pizza", "PizzaBoxCool", "SpiritPickup", "SunkenChest"],
		"tedesert"	  : ["BabyScorpion", "BabyScorpionGold", "BigCactus", "BigMaggotSpawn", "Bone", "BoneSpawner", "CoastBossBecome", "CoastBoss", "PetVenom", "ScorpionRock"],
		"tecoast"	  : ["BloomingAssassin", "BloomingAssassinHide", "BloomingBush", "BloomingCactus", "BuriedCar", "CoastBigDecal", "CoastDecal", "CoastDecalCorpse", "Creature", "Diver", "DiverHarpoon", "Gull", "Palanking", "PalankingDie", "PalankingSlash", "PalankingSlashGround", "PalankingToss", "Palm", "Pelican", "Seal", "SealAnchor", "SealHeavy", "SealMine", "TrafficCrab"],
		"teoasis"	  : ["ClamChest", "Crack", "Hammerhead", "OasisPetBecome", "Puffer"],
		"tetrench"	  : ["Angler", "Eel", "EelSkull", "ElectroPlasma", "ElectroPlasmaImpact", "Jelly", "JellyElite", "Kelp", "LightningDisc", "LightningDiscEnemy", "PitSpark", "PitSquid", "SquidArm", "SquidBomb", "QuasarBeam", "TrenchFloorChunk", "Vent", "WantEel", "WantPitSquid", "YetiCrab"],
	    "tesewers"	  : ["AlbinoBolt", "AlbinoGator", "BabyGator", "Bat", "BatBoss", "BatCloud", "BatScreech", "BoneGator", "BossHealFX", "Cabinet", "Cat", "CatBoss", "CatBossAttack", "CatDoor", "CatDoorDebris", "CatGrenade", "CatHole", "CatHoleBig", "CatLight", "ChairFront", "ChairSide", "Couch", "Manhole", "NewTable", "Paper", "PizzaDrain", "PizzaManholeCover", "PizzaRubble", "PizzaTV", "TopEnemy", "TurtleCool", "VenomFlak"],
	    "tescrapyard" : ["NestRaven", "SawTrap", "Tunneler"],
	    "tecaves"	  : ["InvMortar", "Mortar", "MortarPlasma", "NewCocoon", "Spiderling", "SpiderWall"]
    };

	 // Auto Create Event Script References:
    global.objectScrt = {}
	for(var i = 0; i < lq_size(objList); i++){
		var _modName = lq_get_key(objList, i),
			_modObjs = lq_get_value(objList, i);

		with(_modObjs){
			var _name = self;
			lq_set(objScrt, _name, script_ref_create_ext("mod", _modName, _name + "_create"));
		}
	}
	
	 // Water Sound Replacements:
    global.waterSound = {
        "sndOasisShoot" : [
            sndBloodLauncher,
            sndBouncerShotgun,
            sndBouncerSmg,
            sndClusterLauncher,
            sndCrossbow,
            sndDiscgun,
            sndDoubleMinigun,
            sndDragonStart,
            sndEnemyFire,
            sndFireShotgun,
            sndFlakCannon,
            sndFlare,
            sndFlareExplode,
            sndFrogPistol,
            sndGoldCrossbow,
            sndGoldDiscgun,
            sndGoldFrogPistol,
            sndGoldGrenade,
            sndGoldLaser,
            sndGoldLaserUpg,
            sndGoldMachinegun,
            sndGoldPistol,
            sndGoldPlasma,
            sndGoldPlasmaUpg,
            sndGoldRocket,
            sndGoldShotgun,
            sndGoldSlugger,
            sndGoldSplinterGun,
            sndGrenade,
            sndGrenadeRifle,
            sndGrenadeShotgun,
            sndGunGun,
            sndHeavyCrossbow,
            sndHeavyMachinegun,
            sndHeavyNader,
            sndHeavyRevoler,
            sndHyperLauncher,
            sndHyperRifle,
            sndIncinerator,
            sndMachinegun,
            sndMinigun,
            sndLaser,
            sndLaserUpg,
            sndLaserCannon,
            sndLaserCannonUpg,
            sndLightningHammer,
            sndLightningPistol,
            sndLightningPistolUpg,
            sndLightningRifle,
            sndLightningRifleUpg,
            sndPistol,
            sndPlasma,
            sndPlasmaUpg,
            sndPlasmaMinigun,
            sndPlasmaMinigunUpg,
            sndPlasmaRifle,
            sndPlasmaRifleUpg,
            sndPopgun,
            sndQuadMachinegun,
            sndRogueRifle,
            sndRustyRevolver,
            sndSeekerPistol,
            sndSeekerShotgun,
            sndShotgun,
            sndSlugger,
            sndSmartgun,
            sndSplinterGun,
            sndSplinterPistol,
            sndSuperCrossbow,
            sndSuperDiscGun,
            sndSuperSplinterGun,
            sndToxicLauncher,
            sndTripleMachinegun,
            sndUltraPistol,
            sndWaveGun
            ],
        "sndOasisMelee" : [
            sndBlackSword,
            sndBloodHammer,
            sndChickenSword,
            sndClusterOpen,
            sndEnergyHammer,
            sndEnergyHammerUpg,
            sndEnergyScrewdriver,
            sndEnergyScrewdriverUpg,
            sndEnergySword,
            sndEnergySwordUpg,
            sndFlamerStart,
            sndGoldScrewdriver,
            sndGoldWrench,
            sndGuitar,
            sndHammer,
            sndJackHammer,
            sndScrewdriver,
            sndShovel,
            sndToxicBoltGas,
            sndUltraShovel,
            sndWrench
            ],
        "sndOasisExplosion" : [
            sndBloodCannonEnd,
            sndBloodLauncherExplo,
            sndCorpseExplo,
            sndDevastator,
            sndDevastatorExplo,
            sndDevastatorUpg,
            sndExplosion,
            sndExplosionCar,
            sndExplosionL,
            sndExplosionXL,
            sndFlameCannonEnd,
            sndGoldNukeFire,
            sndLightningCannonEnd,
            sndLightningCannonUpg,
            sndNukeFire,
            sndNukeExplosion,
            sndPlasmaBigExplode,
            sndPlasmaBigUpg,
            sndPlasmaHuge,
            sndPlasmaHugeUpg,
            sndSuperFlakCannon,
            sndSuperFlakExplode
            ],
        "sndOasisExplosionSmall" : [
            sndBloodCannon,
            sndDoubleFireShotgun,
            sndDoubleShotgun,
            sndFlakExplode,
            sndFlameCannon,
            sndRocket,
            sndEraser,
            sndExplosionS,
            sndHeavySlugger,
            sndHyperSlugger,
            sndLightningCannon,
            sndLightningShotgun,
            sndLightningShotgunUpg,
            sndPlasmaBig,
            sndPlasmaHit,
            sndSawedOffShotgun,
            sndSuperBazooka,
            sndUltraCrossbow,
            sndUltraGrenade,
            sndUltraShotgun,
            sndUltraLaser,
            sndUltraLaserUpg
            ],
        "sndOasisPopo" : [
            sndEliteIDPDPortalSpawn,
            sndIDPDPortalSpawn
            ],
        "sndOasisPortal" : [
            sndLaserCannonCharge,
            sndPortalOpen
            ],
        "sndOasisChest" : [
            sndAmmoChest,
            sndBigCursedChest,
            sndBigWeaponChest,
            sndChest,
            sndCursedChest,
            sndGoldChest,
            sndHealthChest,
            sndHealthChestBig,
            sndWeaponChest
            ],
        "sndOasisHurt" : [
            sndMutant1Hurt,
            sndMutant2Hurt,
            sndMutant3Hurt,
            sndMutant4Hurt,
            sndMutant5Hurt,
            sndMutant6Hurt,
            sndMutant7Hurt,
            sndMutant8Hurt,
            sndMutant9Hurt,
            sndMutant10Hurt,
            sndMutant11Hurt,
            sndMutant12Hurt,
            sndMutant13Hurt,
            sndMutant14Hurt,
            sndMutant15Hurt,
            sndMutant16Hurt
            ],
        "sndOasisDeath" : [
            sndMutant1Dead,
            sndMutant2Dead,
            sndMutant3Dead,
            sndMutant4Dead,
            sndMutant5Dead,
            sndMutant6Dead,
            sndMutant7Dead,
            sndMutant8Dead,
            sndMutant9Dead,
            sndMutant10Dead,
            sndMutant11Dead,
            sndMutant12Dead,
            sndMutant13Dead,
            sndMutant14Dead,
            sndMutant15Dead,
            sndMutant16Dead,
            sndSuperSlugger
            ],
        "sndOasisHorn" : [
            sndVenuz
            ]
    };

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)

#macro objList global.objectList
#macro objScrt global.objectScrt


#define obj_create(_x, _y, _name)
	if(is_real(_name) && object_exists(_name)){
		return instance_create(_x, _y, _name);
	}

	 // Search for Create Event if Unstored:
	if(!lq_exists(objScrt, _name) && is_string(_name)){
		for(var i = 0; i < lq_size(objList); i++){
			var _modName = lq_get_key(objList, i);
			if(mod_script_exists("mod", _modName, _name + "_create")){
				lq_set(objScrt, _name, script_ref_create_ext("mod", _modName, _name + "_create"));
			}
		}
	}

	 // Creating Object:
	if(lq_exists(objScrt, _name)){
		 // Call Create Event:
		var _scrt = array_combine(lq_get(objScrt, _name), [_x, _y]),
			_inst = script_ref_call(_scrt);

		if(is_undefined(_inst) || _inst == 0) _inst = noone;

	     /// Auto Assign Things:
	    if(is_real(_inst) && instance_exists(_inst)){
	        with(_inst){
	            name = _name;

				var _isCustom = (string_pos("Custom", object_get_name(_inst.object_index)) == 1),
					_events = [];

				if(_isCustom){
	            	var _isEnemy = instance_is(self, CustomEnemy);

		            switch(object_index){
		            	case CustomObject:
		            		_events = ["step", "begin_step", "end_step", "draw", "destroy", "cleanup"];
		            		break;

						case CustomHitme:
							_events = ["step", "begin_step", "end_step", "draw", "destroy", "hurt", "cleanup"];
							break;

						case CustomProp:
							_events = ["step", "death"];
							break;

		            	case CustomProjectile:
		            		_events = ["step", "begin_step", "end_step", "draw", "destroy", "cleanup", "hit", "wall", "anim"];
		            		break;

						case CustomSlash:
							_events = ["step", "begin_step", "end_step", "draw", "destroy", "cleanup", "hit", "wall", "anim", "grenade", "projectile"];
							break;

						case CustomEnemy:
							_events = ["step", "begin_step", "end_step", "draw", "destroy", "hurt", "death", "cleanup"];
							break;

		            	default:
		            		_events = ["step", "begin_step", "end_step", "draw", "destroy", "hurt", "death", "cleanup", "hit", "wall", "anim", "grenade", "projectile"];
		            }

		            _events = array_combine(_events, ["alrm0", "alrm1", "alrm2", "alrm3", "alrm4", "alrm5", "alrm6", "alrm7", "alrm8", "alrm9", "alrm10"]);
		            if(!_isEnemy) array_push(_events, "alrm11");
				}
				else _events = ["step", "begin_step", "end_step", "draw"];
	
	             // Scripts:
				var	_modType = _scrt[0],
					_modName = _scrt[1];

	            with(_events){
	                var v = (_isCustom ? "on_" + self : "ntte_bind_" + self);
	                if(v not in other || is_undefined(variable_instance_get(other, v))){
	                    var _modScrt = _name + "_" + self;

                        if(mod_script_exists(_modType, _modName, _modScrt)){
                        	 // Normal Event Set:
                            if(_isCustom){
                            	variable_instance_set(other, v, [_modType, _modName, _modScrt]);
                            }

                             // Auto Script Binding:
                            else{
                            	var _bind = instances_matching(CustomScript, "name", "NTTEBind_" + self);
                            	if(array_length(_bind) <= 0 || self == "draw"){
                            		switch(self){
	                            		case "step":		_bind = script_bind_step(ntte_bind, 0);			break;
	                            		case "begin_step":	_bind = script_bind_begin_step(ntte_bind, 0);	break;
	                            		case "end_step":	_bind = script_bind_end_step(ntte_bind, 0);		break;
	                            		case "draw":		_bind = script_bind_draw(ntte_bind, 0);			break;
	                            	}
	                            	if(instance_exists(_bind)){
	                            		with(_bind){
	                            			name = "NTTEBind_" + other;
		                            		inst_list = [];
	                            			persistent = true;
	                            		}
	                            		variable_instance_set(other, v, _bind);
	                            	}
                            	}
                            	with(_bind){
                            		array_push(inst_list, { "inst" : _inst, "script" : [_modType, _modName, _modScrt] });
                            	}
                            }
                        }

	                     // Defaults:
	                    else if(_isCustom) with(other){
	                        switch(v){
								/*
								case "on_step":
									if(_isEnemy){
										on_step = enemy_step_ntte;
									}
									break;
								*/
	
	                            case "on_hurt":
	                                on_hurt = enemyHurt;
	                                break;
	
	                            case "on_death":
	                                if(_isEnemy){
	                                    on_death = scrDefaultDrop;
	                                }
	                                break;
	    
	                            case "on_draw":
	                                if(_isEnemy){
	                                    on_draw = draw_self_enemy;
	                                }
	                                break;
	                        }
	                    }
	                }
	            }

				if(_isCustom){
					on_create = script_ref_create_ext("mod", mod_current, "obj_create", _x, _y, _name);

	                 // Override Events:
	                var _override = ["step"];
	                with(_override){
	                    var v = "on_" + self;
	                    if(v in other){
	                        var e = variable_instance_get(other, v),
	                            _objStep = script_ref_create(obj_step);
	        
	                        if(!is_array(e) || !array_equals(e, _objStep)){
	                            with(other){
	                                variable_instance_set(id, "on_ntte_" + other, e);
	
	                                 // Override Specifics:
	                                switch(v){
	                                    case "on_step":
	                                         // Setup Custom NTTE Event Vars:
	                                        if("ntte_anim" not in self){
	                                        	ntte_anim = _isEnemy;
	                                        }
	                                        if("ntte_walk" not in self){
	                                        	ntte_walk = ("walk" in self);
	                                        }
	                                        if(ntte_anim){
	                                        	if("spr_chrg" not in self) spr_chrg = -1;
	                                        }
                                        	if(ntte_walk){
                                        		if("walkspd" not in self) walkspd = 0.8;
                                        		if("maxspeed" not in self) maxspeed = 3;
                                        	}
	                                        ntte_alarm_max = 0;
	                                        for(var i = 0; i <= 10; i++){
	                                            var a = `on_alrm${i}`;
	                                            if(a in self && variable_instance_get(id, a) != null){
	                                                ntte_alarm_max = i + 1;
	                                                if("ntte_alarm_min" not in self){
	                                                	ntte_alarm_min = i;
	                                                }
	                                            }
	                                        }
                                            if("ntte_alarm_min" not in self){
                                            	ntte_alarm_min = 0;
                                            }
	                                        /*var _set = ["anim"];
	                                        with(_set){
	                                            var n = "on_ntte_" + self;
	                                            if(n not in other){
	                                                variable_instance_set(other, n, null);
	                                            }
	                                        }*/
	                                        
	                                         // Set on_step to obj_step if Needed:
	                                        if(ntte_anim || ntte_walk || ntte_alarm_max > 0 || (DebugLag && array_length(on_step) >= 3)){
	                                        	on_step = _objStep;
	                                        }
	                                        break;
	
	                                    default:
	                                        variable_instance_set(id, v, []);
	                                }
	                            }
	                        }
	                    }
	                }

	                 // Auto-fill HP:
	                if(instance_is(self, CustomHitme) || instance_is(self, CustomProp)){
	                    if(my_health == 1) my_health = maxhealth;
	                }

	                 // Auto-spr_idle:
	                if(sprite_index == -1 && "spr_idle" in self && instance_is(self, hitme)){
	                    sprite_index = spr_idle;
	                }
				}
	        }
	    }

		return _inst;
	}

	 // Return List of Objects if Object Doesn't Exist:
	else{
		var _list = [];
		for(var i = 0; i < lq_size(objList); i++){
			_list = array_combine(_list, lq_get_value(objList, i));
		}
		return _list;
	}

#define obj_step
    if(DebugLag){
    	//trace_lag_bgn("Objects");
    	trace_lag_bgn(name);
    }

	 // Animate:
	if(ntte_anim){
		if(sprite_index != spr_chrg){
		     // Not Hurt:
		    if(sprite_index != spr_hurt){
		        if(speed <= 0) sprite_index = spr_idle;
		    	else if(sprite_index == spr_idle) sprite_index = spr_walk;
		    }
	
		     // Hurt:
		    else if(image_index > image_number - 1){
		        sprite_index = spr_idle;
		    }
		}
	}

	 // Movement:
	if(ntte_walk){
		if(walk > 0){
	        motion_add(direction, walkspd);
	        walk -= current_time_scale;
	    }
	    if(speed > maxspeed) speed = maxspeed; // Max Speed
	}

     // Step:
    script_ref_call(on_ntte_step);
    if("ntte_alarm_max" not in self) exit;

     // Alarms:
	var r = (ntte_alarm_max - ntte_alarm_min);
    if(r > 0){
	    var i = ntte_alarm_min;
	    repeat(r){ // repeat() is slightly faster than a for loop here i think- big optimizations
	        var a = alarm_get(i);
	        if(a > 0){
	             // Decrement Alarm:
	            a -= ceil(current_time_scale);
	            alarm_set(i, a);
	
	             // Call Alarm Event:
	    		if(a <= 0){
	    		    alarm_set(i, -1);
	    		    script_ref_call(variable_instance_get(self, "on_alrm" + string(i)));
	    			if("ntte_alarm_max" not in self) exit;
	    		}
	        }
	        i++;
	    }
	}

    if(DebugLag){
	    //trace_lag_end("Objects");
	    trace_lag_end(name);
    }

#define ntte_bind
	if(array_length(inst_list) > 0){
		if(DebugLag) trace_time();

		with(inst_list){
			if(instance_exists(inst)){
				if(other.object_index == CustomDraw && other.depth != inst.depth - 1){
					other.depth = inst.depth - 1;
				}

				 // Call Bound Script:
				var s = script;
				with(inst) mod_script_call(s[0], s[1], s[2]);
			}
			else other.inst_list = array_delete_value(other.inst_list, self);
		}

		if(DebugLag) trace_time(name);
	}
	else instance_destroy();

#define step
	if(DebugLag){
	    trace("");
		trace("Frame", current_frame, "Lag:")
	    trace_lag();
	}
    
     // sleep_max():
    if(global.sleep_max > 0){
	    sleep(global.sleep_max);
	    global.sleep_max = 0;
    }

#define draw_dark // Drawing Grays
    draw_set_color(c_gray);

	 // Portal Disappearing Visual:
	with(instances_matching(BulletHit, "name", "PortalPoof")){
		draw_circle(x, y, 120 + random(6), false);
	}

#define draw_dark_end // Drawing Clear
    draw_set_color(c_black);

	 // Portal Disappearing Visual:
	with(instances_matching(BulletHit, "name", "PortalPoof")){
		draw_circle(x, y, 20 + random(8), false);
	}


/// Scripts
#define draw_self_enemy()
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);

#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)
	draw_sprite_ext(_sprite, 0, _x - lengthdir_x(_wkick, _ang), _y - lengthdir_y(_wkick, _ang), 1, _flip, _ang + (_meleeAng * (1 - (_wkick / 20))), _blend, _alpha);

#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)
    var _sx = _x,
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

#define draw_trapezoid(_x1a, _x2a, _y1, _x1b, _x2b, _y2)
    draw_primitive_begin(pr_trianglestrip);
    draw_vertex(_x1a, _y1);
    draw_vertex(_x1b, _y2);
    draw_vertex(_x2a, _y1);
    draw_vertex(_x2b, _y2);
    draw_primitive_end();

#define draw_set_flat(_color)
	var _bool = (_color >= 0);
	draw_set_fog(_bool, (_bool ? _color : c_black), 0, 0);

#define draw_text_bn(_x, _y, _string, _angle)
	var _col = draw_get_color();
	_string = string_upper(_string);
	
	draw_set_color(c_black);
	draw_text_transformed(_x + 1, _y,     _string, 1, 1, _angle);
	draw_text_transformed(_x,     _y + 2, _string, 1, 1, _angle);
	draw_text_transformed(_x + 1, _y + 2, _string, 1, 1, _angle);
	draw_set_color(_col);
	draw_text_transformed(_x,     _y,     _string, 1, 1, _angle);

#define scrWalk(_walk, _dir)
    walk = _walk;
    speed = max(speed, friction);
    direction = _dir;
    if("gunangle" in self) gunangle = direction;
    scrRight(direction);

#define scrRight(_dir)
    _dir = (_dir + 360) mod 360;
    if(_dir < 90 || _dir > 270) right = 1;
    if(_dir > 90 && _dir < 270) right = -1;

#define scrEnemyShoot(_object, _dir, _spd)
    return scrEnemyShootExt(x, y, _object, _dir, _spd);

#define scrEnemyShootExt(_x, _y, _object, _dir, _spd)
    var _inst = noone;

    if(is_string(_object)) _inst = obj_create(_x, _y, _object);
    else _inst = instance_create(_x, _y, _object);
    with(_inst){
        if(_spd <= 0) direction = _dir;
        else motion_add(_dir, _spd);
        image_angle = _dir;
        if("hitid" in other) hitid = other.hitid;
        team = other.team;

		 // Auto-Creator:
		creator = other;
		while("creator" in creator && !instance_is(creator, hitme)){
			creator = creator.creator;
		}

         // Euphoria:
        var e = skill_get(mut_euphoria);
        if(e != 0 && object_index == CustomProjectile){
            speed *= (0.8 / e);
        }
    }

    return _inst;

#define enemyWalk(_spd, _max)
    if(walk > 0){
        motion_add(direction, _spd);
        walk -= current_time_scale;
    }
    if(speed > _max) speed = _max; // Max Speed

#define enemySprites()
     // Not Hurt:
    if(sprite_index != spr_hurt){
        if(speed <= 0) sprite_index = spr_idle;
    	else if(sprite_index == spr_idle) sprite_index = spr_walk;
    }

     // Hurt:
    else if(image_index > image_number - 1){
        sprite_index = spr_idle;
    }

#define enemyHurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    motion_add(_hitdir, _hitvel);	// Knockback
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);	// Sound

     // Hurt Sprite:
    sprite_index = spr_hurt;
    image_index = 0;

#define scrDefaultDrop
    pickup_drop(16, 0); // Bandit drop-ness

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

#define z_engine()
    z += zspeed * current_time_scale;
    zspeed -= zfric * current_time_scale;

#define option_get(_name, _default)
	var q = lq_defget(sav, "option", {});
	return lq_defget(q, _name, _default);

#define option_set(_name, _value)
	if(!lq_exists(sav, "option")) sav.option = {};
	lq_set(sav.option, _name, _value);

#define unlock_get(_name)
    var q = lq_defget(sav, "unlock", {});
    return lq_defget(q, _name, false);

#define unlock_set(_name, _value)
    if(!lq_exists(sav, "unlock")) sav.unlock = {};
    lq_set(sav.unlock, _name, _value);

#define stat_get(_name)
	if(!is_array(_name)) _name = string_split(_name, "/");
	
	var q = lq_defget(sav, "stat", {});
	with(_name) q = lq_defget(q, self, 0);
	
	return q;

#define stat_set(_name, _value)
	if(!is_array(_name)) _name = string_split(_name, "/");
	
	if("stat" not in sav) sav.stat = {};
	
	var q = sav.stat,
		m = array_length(_name) - 1;
		
	with(array_slice(_name, 0, m)){
		if(self not in q) lq_set(q, self, {});
		q = lq_get(q, self);
	}
	lq_set(q, _name[m], _value);

#define scrPickupIndicator(_text)
	with(obj_create(x, y, "PickupIndicator")){
		creator = other;
		text = _text;
		return id;
	}
	return noone;

#define scrCharm(_instance, _charm)
    var c = {
            "instance"	: _instance,
            "charmed"	: false,
            "target"	: noone,
            "alarm"		: [],
            "index"		: -1,		// Player who charmed
            "team"		: -1,		// Original team before charming
            "time"		: 0,		// Charm duration in frames
            "time_speed": 1,		// Charm duration decrement speed
            "walk"		: 0,		// For overwriting movement on certain dudes (Assassin, big dog)
            "boss"		: false,	// Instance is a boss
            "kill"		: false 	// Kill when uncharmed (For dudes who were spawned by charmed dudes)
        },
        _charmListRaw = mod_variable_get("mod", "ntte", "charm");

    with(_instance){
        if("ntte_charm" not in self) ntte_charm = c;
        c = ntte_charm;

        if(!_charm != !c.charmed){
             // Charm:
            if(_charm){
            	 // Frienderize Team:
                if("team" in self){
                    c.team = team;
                    team = 2;

                     // Teamerize Nearby Projectiles:
        			with(instances_matching(instances_matching(projectile, "creator", id), "team", c.team)){
        				if(place_meeting(x, y, other)){
        					team = other.team;
                			charm_allyize(true);
        				}
        			}
                }

                 // Setup Custom Alarms:
                for(var i = 0; i <= 10; i++){
                	var a = alarm_get(i);
                	if(a == 0) a = 1;

                    c.alarm[i] = a;
                    alarm_set(i, -1);
                }

				 // Boss Check:
				c.boss = (("boss" in self && boss) || array_find_index([BanditBoss, ScrapBoss, LilHunter, Nothing, Nothing2, FrogQueen, HyperCrystal, TechnoMancer, Last, BigFish, OasisBoss], object_index) >= 0);

				 // Charm Duration Speed:
				c.time_speed = (c.boss ? 2 : 1);

                 // Necromancer Charm:
                switch(sprite_index){
                	case sprReviveArea:
                		sprite_index = spr.AllyReviveArea;
                		break;

					case sprNecroReviveArea:
						sprite_index = spr.AllyNecroReviveArea;
						break;
                }

                ds_list_add(_charmListRaw, c);
            }

             // Uncharm:
            else{
            	target = noone;
                c.time = 0;
                c.index = -1;

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
                if(c.team != -1){
                	if(fork()){
                		while(instance_exists(self) && instance_is(self, becomenemy)) wait 0;
                		if(instance_exists(self)){
                    		 // Teamerize Nearby Projectiles:
                			with(instances_matching(instances_matching(projectile, "creator", id), "team", team)){
                				if(place_meeting(x, y, other)){
                					team = c.team;
                					charm_allyize(false);
                				}
                			}

		                	team = c.team;
		                	c.team = -1;
                		}
                		exit;
                	}
                }

                 // Reset Alarms:
                for(var i = 0; i <= 10; i++){
                	var a = floor(c.alarm[i]);
                	if(a == 0) a = 1;

                	alarm_set(i, a);
                	c.alarm[i] = -1;
                }
                
                 // Kill:
                if(c.kill){
                	my_health = 0;
                	sound_play_pitchvol(sndEnemyDie, 2 + orandom(0.3), 3);
                }

                 // Effects:
                else instance_create(x, bbox_top, AssassinNotice);
                sound_play_pitchvol(sndAssassinGetUp, random_range(1.2, 1.5), 0.5);
                var _num = (max((("size" in self) ? size : 0), 0.5) * 10);
                for(var a = direction; a < direction + 360; a += (360 / _num)){
                    with(instance_create(x, y, Dust)) motion_add(a, 3);
                }
            }
        }
        c.charmed = _charm;
    }
    if(!_charm && ds_list_valid(_charmListRaw)){
        var _charmList = ds_list_to_array(_charmListRaw);
        with(_charmList){
            if(instance == _instance){
                ds_list_remove(_charmListRaw, self);
                break;
            }
        }
    }
    return c;

#define charm_allyize(_bool)
	if(_bool){
		switch(sprite_index){
			case sprEnemyBullet1:
				if(instance_is(self, EnemyBullet1)){
	    			instance_change(AllyBullet, false);
				}
	    		sprite_index = sprAllyBullet;
				break;
	
			case sprEBullet3:
				if(instance_is(self, EnemyBullet3)){
	    			instance_change(Bullet2, false);
	    			bonus = false;
				}
	    		sprite_index = sprBullet2;
				break;
	
			case sprEnemyBullet4:
				if(instance_is(self, EnemyBullet4)){
	    			instance_change(AllyBullet, false);
				}
	    		sprite_index = spr.AllyBullet4;
				break;
	
			case sprLHBouncer:
				if(instance_is(self, LHBouncer)){
	    			instance_change(BouncerBullet, false);
				}
	    		sprite_index = sprBouncerBullet;
				break;
	
			case sprEFlak:
				if(instance_is(self, EFlakBullet)){
					var _inst = obj_create(x, y, "AllyFlakBullet");
					with(variable_instance_get_names(id)){
						if(!array_exists(["id", "object_index", "bbox_bottom", "bbox_top", "bbox_right", "bbox_left", "image_number", "sprite_yoffset", "sprite_xoffset", "sprite_height", "sprite_width", "sprite_index"], self)){
							variable_instance_set(_inst, self, variable_instance_get(other, self));
						}
					}
					instance_delete(id);
				}
				break;
	
			case sprEnemyLaser:
				if(!instance_is(self, EnemyLaser)){
					sprite_index = sprLaser;
				}
				break;
	
			case sprEnemyLightning:
				sprite_index = sprLightning;
				break;
		}
	}
	else{
		switch(sprite_index){
			case sprAllyBullet:
				if(instance_is(self, AllyBullet)){
	    			instance_change(EnemyBullet1, false);
				}
	    		sprite_index = sprEnemyBullet1;
				break;
	
			case sprBullet2:
				if(instance_is(self, Bullet2)){
	    			instance_change(EnemyBullet3, false);
	    			bonus = false;
				}
	    		sprite_index = sprEBullet3;
				break;
	
			case sprBouncerBullet:
				if(instance_is(self, BouncerBullet)){
	    			instance_change(LHBouncer, false);
				}
	    		sprite_index = sprLHBouncer;
				break;
	
			case sprLaser:
				if(!instance_is(self, EnemyLaser)){
					sprite_index = sprEnemyLaser;
				}
				break;
	
			case sprLightning:
				sprite_index = sprEnemyLightning;
				break;

			default:
				if(sprite_index == spr.AllyBullet4){
					if(instance_is(self, AllyBullet)){
		    			instance_change(EnemyBullet4, false);
					}
		    		sprite_index = sprEnemyBullet4;
				}

				else if(sprite_index == spr.AllyFlakBullet){
					if(instance_is(self, CustomProjectile) && "name" in self && name == "AllyFlakBullet"){
						sprite_index = sprEFlak;
					}
				}
		}
	}

#define scrBossHP(_hp)
    var n = 0;
    for(var i = 0; i < maxp; i++) n += player_is_active(i);
    return round(_hp * (1 + ((1/3) * GameCont.loops)) * (1 + (0.5 * (n - 1))));

#define scrBossIntro(_name, _sound, _music)
    mod_script_call("mod", "ntte", "scrBossIntro", _name, _sound, _music);

#define scrUnlock(_name, _text, _sprite, _sound)
    return mod_script_call("mod", "ntte", "scrUnlock", _name, _text, _sprite, _sound);

#define scrTopDecal(_x, _y, _area)
    _area = string(_area);
    var _topDecal = {
        "0"   : TopDecalNightDesert,
        "1"   : TopDecalDesert,
        "2"   : TopDecalSewers,
        "3"   : TopDecalScrapyard,
        "4"   : TopDecalCave,
        "5"   : TopDecalCity,
        "7"   : TopDecalPalace,
        "102" : TopDecalPizzaSewers,
        "104" : TopDecalInvCave,
        "105" : TopDecalJungle,
        "106" : TopPot,
        "pizza" : TopDecalPizzaSewers
        };

    if(lq_exists(_topDecal, _area)){
        return instance_create(_x, _y, lq_get(_topDecal, _area));
    }
    else if(lq_exists(spr.TopDecal, _area)){
        with(instance_create(_x, _y, TopPot)){
            sprite_index = lq_get(spr.TopDecal, _area);
            image_index = irandom(image_number - 1);
            image_speed = 0;

             // Area-Specifics:
            switch(_area){
                case "trench":
                    right = choose(-1, 1);
                    image_index = 0;

                     // Water Mine:
                    if(chance(1, 6) && distance_to_object(Player) > 128){
                        image_index = 1;
                        with(script_bind_step(TopDecalWaterMine_step, 0)){
                            creator = other;
                        }
                    }
                    break;
            }

            return id;
        }
    }
    return noone;

#define TopDecalWaterMine_step
    if(instance_exists(creator)){
        x = creator.x;
        y = creator.y;
    }
    else{
        with(instance_create(x, y, WaterMine)){
            my_health = 0;
            spr_dead = spr.TopDecalMine;
            with(instances_meeting(x, y, Wall)){
                instance_create(x, y, FloorExplo);
                instance_destroy();
            }
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

	var o = noone;
	with(obj_create(_x[0] + orandom(_x[1]), _y[0] + orandom(_y[1]), _obj)){
		motion_add(_motion[0], _motion[1]);
		o = id;
	}
	return o;

#define scrWaterStreak(_x, _y, _dir, _spd)
    with(instance_create(_x, _y, AcidStreak)){
        sprite_index = spr.WaterStreak;
        motion_add(_dir, _spd);
        vspeed -= 2;
        image_angle = direction;
        image_speed = 0.4 + random(0.2);
        depth = 0;

        return id;
    }

#define scrCorpse(_dir, _spd)
	with(instance_create(x, y, Corpse)){
		size = other.size;
		sprite_index = other.spr_dead;
		mask_index = other.mask_index;
		image_xscale = other.right * other.image_xscale;

		 // Speedify:
		direction = _dir;
		speed = min(_spd + max(0, -other.my_health / 5), 16);
		if(size > 0) speed /= size;

        return id;
	}

#define scrSwap()
	var _swap = ["wep", "curse", "reload", "wkick", "wepflip", "wepangle", "can_shoot"];
	for(var i = 0; i < array_length(_swap); i++){
		var	s = _swap[i],
			_temp = [variable_instance_get(id, "b" + s), variable_instance_get(id, s)];

		for(var j = 0; j < array_length(_temp); j++) variable_instance_set(id, chr(98 * j) + s, _temp[j]);
	}

	wepangle = (weapon_is_melee(wep) ? choose(120, -120) : 0);
	can_shoot = (reload <= 0);
	clicked = 0;

#define scrPortalPoof()  // Get Rid of Portals (but make it look cool)
    if(instance_exists(Portal) && array_length(instances_matching(Portal, "type", 2)) <= 0 && array_length(instances_matching_le(Portal, "endgame", 0)) <= 0){
        //var _spr = sprite_duplicate(sprPortalDisappear);
        with(Portal) if(endgame >= 0){
        	sound_stop(sndPortalClose);
        	with(instance_create(x, y, BulletHit)){
        		name = "PortalPoof";
        		sprite_index = sprPortalDisappear;
        		image_xscale = other.image_xscale;
        		image_yscale = other.image_yscale;
        		image_angle = other.image_angle;
        		image_blend = other.image_blend;
        		image_alpha = other.image_alpha;
        		depth = other.depth;
        	}
        	instance_destroy();
            /*mask_index = mskNone;
            sprite_index = _spr;
            image_index = 0;
            if(fork()){
                while(instance_exists(self)){
                    if(anim_end) instance_destroy();
                    wait 1;
                }
                exit;
            }*/
        }
    	if(fork()){
    		while(instance_exists(Portal)) wait 0;
    		with(instances_matching(Player, "mask_index", mskNone)){
	    		mask_index = mskPlayer;
	    		if(skill_get(mut_throne_butt)) angle = 0;
	    		else roll = true;
    		}
    		exit;
    	}
    }
    with(instances_matching_gt(Corpse, "alarm0", 0)){
    	alarm0 = -1;
    }

#define scrPickupPortalize()
    var _scrt = "scrPickupPortalize";
    if(!instance_is(self, CustomEndStep) || script[2] != _scrt){
        with(CustomEndStep) if(script[2] == _scrt) exit;
        script_bind_end_step(scrPickupPortalize, 0);
    }

     // Attract Pickups:
    else{
        instance_destroy();
        if(instance_exists(Player) && !instance_exists(Portal)){
            var _pluto = skill_get(mut_plutonium_hunger);

             // Normal Pickups:
            var _attractDis = 30 + (40 * _pluto);
            with(instances_matching([AmmoPickup, HPPickup, RoguePickup], "", null)){
                var p = instance_nearest(x, y, Player);
                if(point_distance(x, y, p.x, p.y) >= _attractDis){
                    var _dis = 6 * current_time_scale,
                        _dir = point_direction(x, y, p.x, p.y),
                        _x = x + lengthdir_x(_dis, _dir),
                        _y = y + lengthdir_y(_dis, _dir);

                    if(place_free(_x, y)) x = _x;
                    if(place_free(x, _y)) y = _y;
                }
            }

             // Rads:
            var _attractDis = 80 + (60 * _pluto),
                _attractDisProto = 170;

            with(instances_matching([Rad, BigRad], "speed", 0)){
                var s = instance_nearest(x, y, ProtoStatue);
                if(distance_to_object(s) >= _attractDisProto || !in_sight(s)){
                    if(distance_to_object(Player) >= _attractDis){
                        var p = instance_nearest(x, y, Player),
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
    }

#define orandom(n) // For offsets
    return random_range(-n, n);

#define floor_ext(_num, _round)
    return floor(_num / _round) * _round;

#define array_exists(_array, _value)
    return (array_find_index(_array, _value) >= 0);

#define array_count(_array, _value)
    var c = 0;
    for(var i = 0; i < array_length(_array); i++){
        if(_array[i] == _value) c++;
    }
    return c;

#define array_flip(_array)
    var a = array_clone(_array),
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
	var _size = array_length(_array),
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

#define array_delete(_array, _index)
    var i = _index,
        _new = array_slice(_array, 0, i);

    array_copy(_new, array_length(_new), _array, i + 1, array_length(_array) - (i + 1))

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
        var k = lq_get_key(_new, i),
            v = lq_get_value(_new, i);

        if(is_array(v)){
            lq_set(_new, k, array_clone_deep(v));
        }
        else if(is_object(v)){
            lq_set(_new, k, lq_clone_deep(v));
        }
    }

    return _new;

#define instances_named(_object, _name)
	if(is_array(_name)){
		var r = [];
		with(_name){
			var n = instances_matching(_object, "name", self);
			array_copy(r, array_length(r), n, 0, array_length(n));
		}
		return r;
	}
    return instances_matching(_object, "name", _name);

#define nearest_instance(_x, _y, _instances)
	var	_nearest = noone,
		d = 1000000;

	with(_instances) if(instance_exists(self)){
		var _dis = point_distance(_x, _y, x, y);
		if(_dis < d){
			_nearest = id;
			d = _dis;
		}
	}

	return _nearest;

#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)
    return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "x", _x1), "x", _x2), "y", _y1), "y", _y2);

#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)
    return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _x1), "bbox_left", _x2), "bbox_bottom", _y1), "bbox_top", _y2);

#define instances_seen(_obj, _ext)
    var _vx = view_xview_nonsync,
        _vy = view_yview_nonsync,
        o = _ext;

    return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _vx - o), "bbox_left", _vx + game_width + o), "bbox_bottom", _vy - o), "bbox_top", _vy + game_height + o);

#define instances_meeting(_x, _y, _obj)
    var _tx = x,
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
	if(is_array(_obj) || instance_exists(_obj)){
		var i = instances_matching(_obj, "", undefined);
		if(array_length(i) > 0){
			return i[irandom(array_length(i) - 1)];
		}
	}
	return noone;

#define wepammo_fire(_wep)
     // Infinite Ammo:
    if(infammo != 0) return true;
    
     // Subtract Cost:
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
    if(instance_is(self, Player) && instance_is(other, TopCont) && is_object(_wep)){
		var _ammo = lq_defget(_wep, "ammo", 0);
		draw_ammo(index, (wep == _wep), _ammo, lq_defget(_wep, "amax", _ammo), (race == "steroids"));
    }

#define draw_ammo(_index, _primary, _ammo, _ammoMax, _steroids)
    if(player_get_show_hud(_index, player_find_local_nonsync())){
    	if(!instance_exists(menubutton) || _index == player_find_local_nonsync()){
		    var _x = view_xview_nonsync + (_primary ? 42 : 86),
		        _y = view_yview_nonsync + 21;
	
		    var _active = 0;
		    for(var i = 0; i < maxp; i++) _active += player_is_active(i);
		    if(_active > 1) _x -= 19;
	
			 // Determine Color:
		    var _col = "w";
			if(_ammo > 0){
			    if(_primary || _steroids){
			    	if(_ammo <= ceil(_ammoMax * 0.2)){
				    	_col = "r";
				    }
			    }
			    else _col = "s";
			}
			else _col = "d";
	
			 // !!!
		    draw_set_halign(fa_left);
		    draw_set_valign(fa_top);
		    draw_set_projection(2, _index);
		    draw_text_nt(_x, _y, "@" + _col + string(_ammo));
		    draw_reset_projection();
    	}
    }
    
#define frame_active(_interval)
    return ((current_frame mod _interval) < current_time_scale);

#define area_generate(_sx, _sy, _area)
	if(is_real(_area) || mod_exists("area", _area)){
	    GameCont.area = _area;
	
	     // Store Player Positions:
	    var _playerPos = [];
	    with(Player){
	    	array_push(_playerPos, {
	    		inst : id,
	    		x : x,
	    		y : y
	    	});
	    }

	     // Remember View:
	    var _viewPos = [];
	    for(var i = 0; i < maxp; i++){
	    	_viewPos[i] = [view_xview[i], view_yview[i]];
	    }
	
	     // No Duplicates:
	    with(TopCont) instance_destroy();
	    with(SubTopCont) instance_destroy();
	    with(BackCont) instance_destroy();

	     // Generate Level:
	    var _minID = instance_create(0, 0, GameObject),
	    	_chest = [WeaponChest, AmmoChest, RadChest, HealthChest];

		instance_delete(_minID);

	    with(instance_create(0, 0, GenCont)){
	        var _hard = GameCont.hard;
	        spawn_x = _sx + 16;
	        spawn_y = _sy + 16;
	
	         // FloorMaker Fixes:
	        goal += instance_number(Floor);
	        var _floored = instance_nearest(10000, 10000, Floor);
	        with(FloorMaker){
	            goal = other.goal;
	            if(!position_meeting(x, y, _floored)){
	                with(instance_nearest(x, y, Floor)) instance_destroy();
	            }
	            x = _sx;
	            y = _sy;
	            instance_create(x, y, Floor);
	        }
	
	         // Floor & Chest Gen:
	        while(instance_exists(FloorMaker)){
	            with(FloorMaker) if(instance_exists(self)){
	                event_perform(ev_step, ev_step_normal);
	            }
	        }
	
	         // Find Newly Generated Things:
	        var _newFloor = instances_matching_gt(Floor, "id", _minID),
	            _newChest = [];
	
	        for(var i = 0; i < array_length(_chest); i++){
	            _newChest[i] = instances_matching_gt(_chest[i], "id", _minID);
	        }
	
	         // Make Walls:
	        with(_newFloor) scrFloorWalls();
	
	         // Spawn Enemies:
	        with(_newFloor){
	            if(chance(_hard, _hard + 10)){
	                if(!place_meeting(x, y, chestprop) && !place_meeting(x, y, RadChest)){
	                    // (distance to spawn coordinates > 120) check
	                    mod_script_call("area", _area, "area_pop_enemies");
	                }
	            }
	        }
	        with(_newFloor){
	             // Minimum Enemy Count:
	            if(instance_number(enemy) < (3 + (_hard / 1.5))){
	                if(!place_meeting(x, y, chestprop) && !place_meeting(x, y, RadChest)){
	                    // (distance to spawn coordinates > 120) check
	                    mod_script_call("area", _area, "area_pop_enemies");
	                }
	            }
	
	              // Crown of Blood:
	            if(GameCont.crown = crwn_blood){
	                if(chance(_hard, _hard + 8)){
	                    if(!place_meeting(x, y, chestprop) && !place_meeting(x, y, RadChest)){
	                        // (distance to spawn coordinates > 120) check
	                        mod_script_call("area", _area, "area_pop_enemies");
	                    }
	                }
	            }
	
	             // Props:
	            mod_script_call("area", _area, "area_pop_props");
	        }
	
	         // Find # of Chests to Keep:
	        gol = 1;
	        wgol = 0;
	        agol = 0;
	        rgol = 0;
	        if(skill_get(mut_open_mind)){
	            var m = choose(0, 1, 2);
	            switch(m){
	                case 0: wgol++; break;
	                case 1: agol++; break;
	                case 2: rgol++; break;
	            }
	        }
	        mod_script_call("area", _area, "area_pop_chests");
	
	         // Clear Extra Chests:
	        var _extra = [wgol, agol, rgol, rgol, 0];
	        for(var i = 0; i < array_length(_newChest); i++){
	            var n = array_length(_newChest[i]);
	            if(n > 0 && gol + _extra[i] > 0){
	                while(n-- > gol + _extra[i]){
	                    instance_delete(nearest_instance(_sx + random_range(-250, 250), _sy + random_range(-250, 250), _newChest[i]));
	                }
	            }
	        }
	
	         // Crown of Love:
	        if(GameCont.crown = crwn_love){
	            for(var i = 0; i < array_length(_newChest); i++) with(_newChest[i]){
	                if(instance_exists(self)){
	                    instance_create(x, y, AmmoChest);
	                    instance_delete(id);
	                }
	            }
	        }
	
	         // Rad Can -> Health Chest:
	        else{
	            var _lowHP = false;
	            with(Player) if(my_health < maxhealth / 2) _lowHP = true;
	            with(_newChest[2]) if(instance_exists(self)){
	                if((_lowHP && chance(1, 2)) || (GameCont.crown == crwn_life && chance(2, 3))){
	                    array_push(_newChest[3], instance_create(x, y, HealthChest));
	                    instance_destroy();
	                    break;
	                }
	            }
	        }

	         // Rogue:
	        for(var i = 0; i < maxp; i++) if(player_get_race(i) == "rogue"){
		        with(RadChest){
		        	instance_create(x, y, RogueChest);
		        	instance_delete(id);
		        }
		        break;
	        }

	         // Mimics:
	        with(_newChest[1]) if(instance_exists(self) && chance(1, 11)){
	            instance_create(x, y, Mimic);
	            instance_delete(id);
	        }
	        with(_newChest[3]) if(instance_exists(self) && chance(1, 51)){
	            instance_create(x, y, SuperMimic);
	            instance_delete(id);
	        }

	         // Extras:
	        mod_script_call("area", _area, "area_pop_extras");

	         // Done + Fix Random Wall Spawn:
	        var n = instance_number(Wall);
	        event_perform(ev_alarm, 1);
	        if(instance_number(Wall) > n) instance_delete(Wall.id);
	    }

	     // Remove Portal FX:
	    with(instances_matching([Spiral, SpiralCont], "", null)) instance_destroy();
	    repeat(4) with(instance_nearest(10016, 10016, PortalL)) instance_destroy();
	    with(instance_nearest(10016, 10016, PortalClear)) instance_destroy();
	    sound_stop(sndPortalOpen);

	     // Reset Player & Camera Pos:
	    with(Player) sound_stop(snd_wrld);
	    with(_playerPos) with(inst){
    		x = other.x;
    		y = other.y;
	    }
	    for(var i = 0; i < array_length(_viewPos); i++){
	    	var _vx = _viewPos[i, 0],
	    		_vy = _viewPos[i, 1];

	    	view_shift(i, point_direction(0, 0, _vx, _vy), point_distance(0, 0, _vx, _vy));
	    }

	     // Force Music Transition:
	    mod_variable_set("mod", "ntte", "musTrans", true);
	}

#define area_get_name(_area, _subarea, _loop)
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
			case 100:
				a = ["???"];
				break;

			case 106:
				a = ["HQ", _subarea];
				break;

			case 107:
				a = ["$$$"];
				break;

			default:
				a = [_area - 100, "-?"];
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
        if(_area == 106) return 3;
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
    	return (_area == 101);
    }

     // Custom Area:
    var _scrt = "area_underwater";
    if(mod_script_exists("area", _area, _scrt)){
        return mod_script_call("area", _area, _scrt);
    }

    return false;

#define scrFloorWalls()
	var	_x1 = bbox_left - 16,
		_y1 = bbox_top - 16,
		_x2 = bbox_right + 1,
		_y2 = bbox_bottom + 1;

	for(var _x = _x1; _x <= _x2; _x += 16){
		for(var _y = _y1; _y <= _y2; _y += 16){
			if(_x == _x1 || _y == _y1 || _x == _x2 || _y == _y2){
				if(!position_meeting(_x, _y, Floor)){
					instance_create(_x, _y, Wall);
				}
			}
		}
	}

#define floor_reveal(_floors, _maxTime)
    if(instance_is(self, CustomDraw) && script[2] == "floor_reveal"){
        if(array_length(_floors) > num){
            var _yOffset = 8;
            draw_set_color(area_get_background_color(102));

             // Hiding Floors:
            with(array_slice(_floors, num + 1, array_length(_floors) - (num + 1))){
                draw_rectangle(x - 15, y - _yOffset, x + 32 + 15, y + 31 - _yOffset, 0);
            }

             // Revealing Floor:
            if(time > 0){
            	time -= current_time_scale;

                var a = clamp(time / _maxTime, 0, 1);
                _yOffset += 4 * a;

                draw_set_alpha(a);
                draw_set_color(merge_color(draw_get_color(), c_white, a));
                with(_floors[num]){
                    draw_rectangle(bbox_left - 16, bbox_top - _yOffset, bbox_right + 16, bbox_bottom - _yOffset + (24 * (other.time >= _maxTime)), 0);
                }
                draw_set_alpha(1);
            }

             // Next Floor:
            else{
                num++;
                time = _maxTime;
            }
        }
        else instance_destroy();
    }
    else with(script_bind_draw(floor_reveal, -7, _floors, _maxTime)){
        time = _maxTime + 1;
        num = 0;
    }

#define area_border(_y, _area, _color)
	if(DebugLag) trace_time();

    if(instance_is(self, CustomScript) && script[2] == "area_border"){
        var _fix = false,
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
				with(_floor) if(point_seen_ext((bbox_left + bbox_right) / 2, (bbox_top + bbox_bottom) / 2, 16, 16, -1)){
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
								depth = -10;
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
		    			if(instance_exists(f)) x += (((f.bbox_left + f.bbox_right) / 2) - x) * 0.1 * current_time_scale;
		    			
		    			 // Why do health chests break walls again
		    			if(instance_is(self, HealthChest)) mask_index = mskNone;
	    			}
	    			else other.cavein_inst = array_delete_value(other.cavein_inst, self);
	    		}

				 // Screenshake:
				for(var i = 0; i < maxp; i++){
					view_shake[i] = max(view_shake[i], 5);
					with(instance_exists(view_object[i]) ? view_object[i] : player_find(i)){
						view_shake_max_at(x, _y + other.cavein_dis, 20);

						 // Pan Down:
						view_shift(i, 270, clamp(y - (_y - 64), 0, min(20, other.cavein_dis / 10)));
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
					scrFloorWalls();
				}
				with(instances_matching_gt(Wall, "bbox_bottom", _y)){
					instance_create(x - 16,	y - 16,	Top);
					instance_create(x - 16,	y,		Top);
					instance_create(x,		y - 16,	Top);
					instance_create(x,		y,		Top);
				}
				
				 // Rubble:
				with(_caveInst) if(instance_exists(self)){
					visible = true;
				}
				with(instances_matching(instances_matching_gt(Floor, "bbox_bottom", _y), "object_index", Floor)){
					with(obj_create(x + 16, _y, "PizzaRubble")){
						inst = _caveInst;
						event_perform(ev_step, ev_step_normal);
					}

					 // Fix Potential Softlockyness:
					with(instances_matching_lt(instances_matching_gt(FloorExplo, "bbox_bottom", _y - 4), "bbox_top", _y - 4)){
						var _x1 = (bbox_left + bbox_right) / 2,
							_y1 = (bbox_top + bbox_bottom) / 2,
							_x2 = (other.bbox_left + other.bbox_right) / 2;

						if(collision_line(_x1, _y1, _x2, _y1, Wall, false, false)){
							with(instance_create(_x1, _y - 24, PortalClear)){
								sprite_index = mskFloor;
								image_xscale = (_x2 - _x1) / sprite_width;
								image_speed = 1 / abs(image_xscale);
							}
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
        	var _obj = self[0],
        		_num = self[1];

        	if(_num < 0 || _num != instance_number(_obj)){
        		_fix = true;
        		self[@1] = instance_number(_obj);
        	}
        }
		if(_fix) with(type){
        	var _obj = self[0],
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
        var _vx = view_xview_nonsync,
            _vy = view_yview_nonsync;

        draw_set_color(_color);
        draw_rectangle(_vx, _y, _vx + game_width, max(_y, _vy + game_height), 0);
    }
    else with(script_bind_draw(area_border, 10000, _y, _area, _color)){
    	cavein = false;
    	cavein_dis = 800;
    	cavein_inst = [];

    	type = [
    		[Wall,		 0, [area_get_sprite(_area, sprWall1Bot), area_get_sprite(_area, sprWall1Top), area_get_sprite(_area, sprWall1Out)]],
    		[TopSmall,	 0, area_get_sprite(_area, sprWall1Trans)],
    		[FloorExplo, 0, area_get_sprite(_area, sprFloor1Explo)],
    		[Debris,	 0, area_get_sprite(_area, sprDebris1)]
    	];

    	return id;
    }

    if(DebugLag) trace_time("area_border");

#define area_border_cavein(_y, _caveDis, _caveInst)
	 // Delete:
	with(instances_matching_ne(instances_matching_gt(GameObject, "y", _y + _caveDis), "object_index", Dust)){
		 // Kill:
		if(y > _y + 64 && instance_is(self, hitme)){
			my_health = 0;
			if("lasthit" in self) lasthit = [sprDebris102, "CAVE IN"]
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

	 // Lights:
	var _light = mod_variable_get("mod", "tesewers", "catLight");
	with(_light){
		if(y > _y + _caveDis){
			_light = array_delete_value(_light, self);
			mod_variable_set("mod", "tesewers", "catLight", _light);
		}
	}

	instance_destroy();

#define area_get_sprite(_area, _spr)
    return mod_script_call("area", _area, "area_sprite", _spr);

#define floor_at(_x, _y)
	 // Find Floor:
    with(instances_at(_x, _y, Floor)){
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

#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)
    var _disMax	= point_distance(_x1, _y1, _x2, _y2),
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
		_team	= team,
		_hitid	= (("hitid" in self) ? hitid : -1),
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

#define scrLightning(_x1, _y1, _x2, _y2, _enemy)
    with(instance_create(_x2, _y2, (_enemy ? EnemyLightning : Lightning))){
        image_xscale = -point_distance(_x1, _y1, _x2, _y2) / 2;
        image_angle = point_direction(_x1, _y1, _x2, _y2);
        direction = image_angle;
        return id;
    }

#define in_range(_num, _lower, _upper)
    return (_num >= _lower && _num <= _upper);

#define wep_get(_wep)
    if(is_object(_wep)){
        return wep_get(lq_defget(_wep, "wep", 0));
    }
    return _wep;

#define decide_wep_gold(_minhard, _maxhard, _nowep)
    var _list = ds_list_create(),
        s = weapon_get_list(_list, _minhard, _maxhard);

    ds_list_shuffle(_list);

    for(i = 0; i < s; i++) {
        var w = ds_list_find_value(_list, i),
            c = 0;

         // Weapon Exceptions:
        if(is_array(_nowep) && array_find_index(_nowep, w) >= 0) c = true;
        if(w == _nowep) c = true;

         // Specific Weapon Spawn Conditions:
        if(
            !weapon_get_gold(w)             ||
            w == wep_golden_nuke_launcher   ||
            w == wep_golden_disc_gun        ||
            w == wep_golden_frog_pistol
        ){
            c = true;
        }

        if(c) continue;
        break;
    }

    ds_list_destroy(_list);

     // Set Weapon:
    if(!c) return w;

     // Default:
    return choose(wep_golden_wrench, wep_golden_machinegun, wep_golden_shotgun, wep_golden_crossbow, wep_golden_grenade_launcher, wep_golden_laser_pistol);

#define wep_merge(_stock, _front)
	return mod_script_call_nc("weapon", "merge", "wep_merge", _stock, _front);

#define wep_merge_decide(_hardMin, _hardMax)
	return mod_script_call_nc("weapon", "merge", "wep_merge_decide", _hardMin, _hardMax);

#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)
     // Auto-Determine Grid Size:
    var _tileSize = 16,
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
    var _gridw = ceil(_areaWidth / _tileSize),
        _gridh = ceil(_areaHeight / _tileSize),
        _gridx = round((((_xstart + _xtarget) / 2) - (_areaWidth  / 2)) / _tileSize) * _tileSize,
        _gridy = round((((_ystart + _ytarget) / 2) - (_areaHeight / 2)) / _tileSize) * _tileSize,
        _grid = ds_grid_create(_gridw, _gridh),
        _gridCost = ds_grid_create(_gridw, _gridh);

    ds_grid_clear(_grid, -1);

     // Mark Walls:
    with(instance_rectangle(_gridx, _gridy, _gridx + _areaWidth, _gridy + _areaHeight, _wall)){
    	if(position_meeting(x, y, id)){
    		_grid[# ((x - _gridx) / _tileSize), ((y - _gridy) / _tileSize)] = -2;
    	}
    }

     // Pathing:
    var _x1 = (_xtarget - _gridx) / _tileSize,
        _y1 = (_ytarget - _gridy) / _tileSize,
        _x2 = (_xstart - _gridx) / _tileSize,
        _y2 = (_ystart - _gridy) / _tileSize,
        _searchList = [[_x1, _y1, 0]],
        _tries = _triesMax;

    while(_tries-- > 0){
        var _search = _searchList[0],
            _sx = _search[0],
            _sy = _search[1],
            _sp = _search[2];

        if(_sp >= 1000000) break; // No more searchable tiles
        _search[2] = 1000000;

         // Sort Through Neighboring Tiles:
        var _costSoFar = _gridCost[# _sx, _sy];
        for(var i = 0; i < 2*pi; i += pi/2){
            var _nx = _sx + cos(i),
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
    var _x = _xstart,
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
    var _pathNew = [],
		_link = 0;

	if(!is_array(_wall)) _wall = [_wall];

    for(var i = 0; i < array_length(_path); i++){
    	 // Save Important Points on Path:
    	var _save = (
            i <= 0							||
            i >= array_length(_path) - 1	||
            i - _link >= _skipMax
        );

		 // Save Points Going Around Walls:
        if(!_save){
        	var _x1 = _path[i + 1, 0],
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

#define path_direction(_x, _y, _path, _wall)
	if(!is_array(_wall)) _wall = [_wall];
	
     // Find Nearest Unobstructed Point on Path:
    var	_nearest = -1,
		_disMax = 1000000;
		
	for(var i = 0; i < array_length(_path); i++){
		var _px = _path[i, 0],
			_py = _path[i, 1],
        	_dis = point_distance(_x, _y, _px, _py);
        	
		if(_dis < _disMax){
			var _walled = false
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
	    var _follow = min(_nearest + 1, array_length(_path) - 1),
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

#define race_get_sprite(_race, _sprite)
    var i = race_get_id(_race),
        n = race_get_name(_race);

    if(i < 17){
        var a = string_upper(string_char_at(n, 1)) + string_lower(string_delete(n, 1, 1));
        switch(_sprite){
            case sprMutant1Idle:        return asset_get_index(`sprMutant${i}Idle`);
            case sprMutant1Walk:        return asset_get_index(`sprMutant${i}Walk`);
            case sprMutant1Hurt:        return asset_get_index(`sprMutant${i}Hurt`);
            case sprMutant1Dead:        return asset_get_index(`sprMutant${i}Dead`);
            case sprMutant1GoSit:       return asset_get_index(`sprMutant${i}GoSit`);
            case sprMutant1Sit:         return asset_get_index(`sprMutant${i}Sit`);
            case sprFishMenu:           return asset_get_index("spr" + a + "Menu");
            case sprFishMenuSelected:   return asset_get_index("spr" + a + "MenuSelected");
            case sprFishMenuSelect:     return asset_get_index("spr" + a + "MenuSelect");
            case sprFishMenuDeselect:   return asset_get_index("spr" + a + "MenuDeselect");
        }
    }
    if(mod_script_exists("race", n, "race_sprite")){
        var s = mod_script_call("race", n, "race_sprite", _sprite);
        if(!is_undefined(s)) return s;
    }
    return -1;

#define pet_create(_x, _y, _name, _modType, _modName)
    with(obj_create(_x, _y, "Pet")){
        pet = _name;
        mod_name = _modName;
        mod_type = _modType;

		 // Stats:
		var s = `pet/${pet}.${mod_name}.${mod_type}`;
		if(!is_object(stat_get(s))){
			stat_set(s, { found:0, owned:0 });
		}
		stat = stat_get(s);

         // Sprites:
        if(mod_type == "mod" && mod_name == "petlib"){
	        spr_idle = lq_defget(spr, "Pet" + pet + "Idle", spr_idle);
	        spr_walk = lq_defget(spr, "Pet" + pet + "Walk", spr_idle);
	        spr_hurt = lq_defget(spr, "Pet" + pet + "Hurt", spr_idle);
	        spr_dead = lq_defget(spr, "Pet" + pet + "Dead", mskNone);
        }

         // Custom Create Event:
    	var _scrt = pet + "_create";
        if(mod_script_exists(mod_type, mod_name, _scrt)){
            mod_script_call(mod_type, mod_name, _scrt);
        }

		 // Auto-set Stuff:
		if(instance_exists(self)){
	        with(pickup_indicator) if(text == "") text = other.pet;
	        if(sprite_index == spr.PetParrotIdle) sprite_index = spr_idle;
			if(maxhealth > 0 && my_health == 0) my_health = maxhealth;
			if(hitid == -1) hitid = [spr_idle, pet];
		}

		return self;
    }
    return noone;

#define Pet_spawn(_x, _y, _name)
	return pet_create(_x, _y, _name, "mod", "petlib");

#define scrFloorMake(_x, _y, _obj)
    instance_create(_x, _y, Floor);
    return instance_create(_x + 16, _y + 16, _obj);

#define scrFloorFill(_x, _y, _w, _h)
    _w--;
    _h--;
    var o = 32;

     // Center Around x,y:
    _x -= floor(_w / 2) * o;
    _y -= floor(_h / 2) * o;

     // Floors:
    var r = [];
    for(var _ox = 0; _ox <= _w; _ox++){
        for(var _oy = 0; _oy <= _h; _oy++){
            array_push(r, instance_create(_x + (_ox * o), _y + (_oy * o), Floor));
        }
    }
    return r;

#define scrFloorFillRound(_x, _y, _w, _h)
    _w--;
    _h--;
    var o = 32;

     // Center Around x,y:
    _x -= floor(_w / 2) * o;
    _y -= floor(_h / 2) * o;

     // Floors:
    var r = [];
    for(var _ox = 0; _ox <= _w; _ox++){
        for(var _oy = 0; _oy <= _h; _oy++){
            if((_ox != 0 && _ox != _w) || (_oy != 0 && _oy != _h)){ // Don't Make Corner Floors
                array_push(r, instance_create(_x + (_ox * o), _y + (_oy * o), Floor));
            }
        }
    }
    return r;

#define trace_lag()
    if(mod_variable_exists("mod", mod_current, "lag")){
        for(var i = 0; i < array_length(global.lag); i++){
            var _name = lq_get_key(global.lag, i),
                _total = string(lq_get_value(global.lag, i).total),
                _str = "";

            while(string_length(_total) > 0){
                var p = string_length(_total) - 3;
                _str = string_delete(_total, 1, p) + " " + _str;
                _total = string_copy(_total, 1, p);
            }

            trace(_name + ":", _str + "us");
        }
    }
    global.lag = {};

#define trace_lag_bgn(_name)
    _name = string(_name);
    if(!lq_exists(global.lag, _name)){
        lq_set(global.lag, _name, {
            timer : 0,
            total : 0
        });
    }
    with(lq_get(global.lag, _name)){
        timer = get_timer_nonsync();
    }

#define trace_lag_end(_name)
    var _timer = get_timer_nonsync();
    with(lq_get(global.lag, string(_name))){
        total += (_timer - timer);
        timer = _timer;
    }

#define player_create(_x, _y, _index)
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
	trace_color("Hey, screenshot that ^^^ error and send it to Yokin#1322 on Discord (or another NTTE dev)", c_yellow);

#define sleep_max(_milliseconds)
	global.sleep_max = max(global.sleep_max, _milliseconds);

#define view_shift(_index, _dir, _pan)
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
			catch(_error) trace_error(_error);
	
			instance_delete(id);
		}
	
	    UberCont.opt_shake = _shake;
	}

#define sound_play_hit_ext(_sound, _pitch, _volume)
	var s = sound_play_hit(_sound, 0);
	sound_pitch(s, _pitch);
	sound_volume(s, _volume);
	return s;

#define rad_drop(_x, _y, _raddrop, _dir, _spd)
	var _radInst = [];
	while(_raddrop > 0){
		var r = (_raddrop > 15);
		repeat(r ? 1 : _raddrop){
			if(r) _raddrop -= 10;
			with(instance_create(_x, _y, (r ? BigRad : Rad))){
				speed = _spd;
				direction = _dir;
				motion_add(random(360), random(_raddrop / 2) + 3);
				speed *= power(0.9, speed);
				array_push(_radInst, id);
			}
		}
		if(!r) break;
	}
	return _radInst;

#define rad_path(_inst, _target)
	var q = [];

	 // Bind Script:
	if(array_length(instances_matching(CustomScript, "name", "rad_path_step")) <= 0){
		with(script_bind_end_step(rad_path_step, 0)){
			name = script[2];
			list = [];
		}
	}

	 // Add to List:
	with(_inst){
		array_push(q, {
			inst : id,
			targ : _target,
			path : [],
			path_delay : 0,
			heal : 0
		});
	}
	with(instances_matching(CustomScript, "name", "rad_path_step")){
		list = array_combine(list, q);
	}

	return q;

#define rad_path_step
	var _list = list;
	if(array_length(_list) > 0){
		with(_list){
			var _targ = targ;
			if(instance_exists(inst) && instance_exists(_targ)){
			    var _tx = _targ.x,
			        _ty = _targ.y,
			        _path = path;
		
				with(inst){
					if(array_length(_path) > 0){
						 // Direction to Follow:
					    var _dir = null;
						if(collision_line(x, y, _tx, _ty, Wall, false, false)){
							_dir = path_direction(x, y, _path, Wall);
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
							}
						}
						else path = [];

						 // Done:
						if(place_meeting(x, y, _targ) || (_targ.mask_index == mskNone && point_in_rectangle(x, y, _targ.bbox_left, _targ.bbox_top, _targ.bbox_right, _targ.bbox_bottom))){
							if(instance_is(_targ, Player)) speed = 0;
							else{
								if("raddrop" in _targ) _targ.raddrop += rad;
		
								 // Heal:
								var _heal = other.heal;
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
	
				        var _pathEndX = x,
				            _pathEndY = y;
			
				        if(array_length(_path) > 0){
				            var e = _path[array_length(_path) - 1];
				            _pathEndX = e[0];
				            _pathEndY = e[1];
				        }

					    if(array_length(_path) <= 0 || collision_line(_pathEndX, _pathEndY, _tx, _ty, Wall, false, false)){
				        	if(other.path_delay > 0) other.path_delay -= current_time_scale;
				        	else{
				                _path = path_create(x, y, _tx, _ty, Wall);
				                _path = path_shrink(_path, Wall, 2);
				                other.path = _path;
				            	other.path_delay = 30;
			
								 // Send Path to Bros:
								var _inst = id;
								with(_list) if(inst != _inst && targ == _targ && array_length(path) <= 0){
									with(inst){
										if(!collision_line(x, y, _inst.x, _inst.y, Wall, false, false)){
											other.path = _path;
										}
									}
								}
				        	}
				        }
				        else other.path_delay = 0;
					}
				}
			}
			else{
				_list = array_delete_value(_list, self);

				 // Heal FX:
				if(heal){
					var n = 0;
					with(_list) if(targ == _targ) n++;
					if(n <= 0) with(_targ){
						with(instance_create(x, y, FrogHeal)){
							sprite_index = spr.BossHealFX;
							depth = other.depth - 1;
							image_xscale *= 1.5;
							image_yscale *= 1.5;
							vspeed -= 1;
						}
						with(instance_create(x, y, LevelUp)) creator = other;
						sound_play_hit_ext(sndLevelUltra, 2 + orandom(0.1), 0.6);
					}
				}
			}
		}
		list = _list;
	}
	else instance_destroy();
