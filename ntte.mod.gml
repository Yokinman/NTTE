#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.save = mod_variable_get("mod", "teassets", "save");

    global.newLevel = instance_exists(GenCont);
    global.area = ["coast", "oasis", "trench", "pizza", "lair"];
    global.effect_timer = 0;
    global.current = {
        mus : { snd: -1, vol: 1, pos: 0, hold: mus.Placeholder },
        amb : { snd: -1, vol: 1, pos: 0, hold: mus.amb.Placeholder }
    };

    global.bones = [];

     // Make Custom CampChars for:
    global.campchar = ["parrot"];
    global.campchar_fix = false;

     // Options Menu:
    global.option_NTTE_splat = 0;
    global.option_NTTE_splat_menu = 1;
    global.option_open = false;
    global.option_slct = -1;
    global.option_pop = 0;
    global.option_menu = [
        {	name : "Use Shaders",
            type : opt_toggle,
            text : "Used for certain visuals#@sShaders may cause the game# to @rcrash @son older computers!",
            sync : false,
            varname : "allowShaders"
            },
        {	name : "Reminders",
        	type : opt_toggle,
        	text : "@sRemind you to enable#@wboss intros @s& @wmusic",
        	varname : "remindPlayer"
        	},
        {	name : "NTTE Intros",
        	type : opt_toggle,
        	pick : ["OFF", "ON", "AUTO"],
        	text : "@sSet @wAUTO @sto obey the#@wboss intros @soption",
        	varname : "intros"
        	},
        {	name : "NTTE Outlines :",
            type : opt_title,
        	text : "@sSet @wAUTO @sto#obey @w/outlines"
            },
        {	name : "Pets",
        	type : opt_toggle,
        	pick : ["OFF", "ON", "AUTO"],
            sync : false,
        	varname : "outlinePets"
        	},
        {	name : "Charm",
        	type : opt_toggle,
        	pick : ["OFF", "ON", "AUTO"],
            sync : false,
        	varname : "outlineCharm"
        	},
        {	name : "Water Quality :",
            type : opt_title,
            text : `@sAdjust @sfor @wperformance#@sat the @(color:${make_color_rgb(55, 253, 225)})Coast`
            },
        {   name : "Wading",
            type : opt_slider,
            text : "Objects in the water",
            sync : false,
            varname : "waterQualityTop"
            },
        {   name : "Main",
            type : opt_slider,
            text : "Water foam,#underwater visuals,#etc.",
            sync : false,
            varname : "waterQualityMain"
            }
        ];

    with(OptionMenu){
        if("name" not in self) name = "";
        if("type" not in self) type = opt_title;
        if("pick" not in self) pick = ["OFF", "ON"];
        if("sync" not in self) sync = true;
        if("varname" not in self) varname = name;
        if("clicked" not in self) clicked = false;
        if(type >= 0 && varname not in opt){
            lq_set(opt, varname, 0);
        }
    }

     // Charm:
    global.surfCharm = -1;
    global.eye_shader = -1;
    global.charm = ds_list_create();
    global.charm_step = noone;

     // Water Level Sounds:
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
    for(var i = 0; i < lq_size(global.waterSound); i++){
        var s = lq_get_value(global.waterSound, i);
        for(var j = 0; j < array_length(s); j++){
            s[j] = [s[j], 1];
        }
    }

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.save
#macro opt sav.option

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)

#macro cMusic global.current.mus
#macro cAmbience global.current.amb

#macro UnlockCont instances_matching(CustomObject, "name", "UnlockCont")

#macro OptionOpen global.option_open
#macro OptionMenu global.option_menu
#macro OptionSlct global.option_slct
#macro OptionPop  global.option_pop
#macro OptionX (game_width / 2)
#macro OptionY (game_height / 2) - 62
#macro opt_title -1
#macro opt_toggle 0
#macro opt_slider 1

#macro EyeShader global.eye_shader
#macro surfCharm global.surfCharm

#define game_start
    with(UnlockCont) instance_destroy();
    mod_variable_set("area", "trench", "trench_visited", []);

#define level_start // game_start but every level
    switch(GameCont.area){
        case 1: /// DESERT
             // Disable Oasis Skip:
    		with(instance_create(0, 0, AmmoChest)){
    			visible = 0;
    			mask_index = mskNone;
    		}

    	     // Spawn Sharky Skull on 1-3:
    		with(BigSkull) instance_delete(id);
    		if(instance_exists(Floor)){
        		if(GameCont.subarea == 3){
        		    var _spawned = false,
        		    	_tries = 100;

        		    do{
            		    with(instance_random(Floor)){
                            if(point_distance(x, y, 10016, 10016) > 48){
                                if(array_length(instances_meeting(x, y, [prop, chestprop, Wall, MaggotSpawn])) <= 0){
            		                obj_create(x + 16, y + 16, "CoastBossBecome");
            		                _spawned = true;
                                }
                            }
            		    }
        		    }
        		    until (_spawned || _tries-- <= 0);
        		}

                 // Consistently Spawning Crab Skeletons:
                if(!instance_exists(BonePile)){
        		    var _spawned = false,
        		    	_tries = 100;

                    do{
                        with(instance_random(Floor)){
                            if(point_distance(x, y, 10016, 10016) > 48){
                                if(array_length(instances_meeting(x, y, [prop, chestprop, Wall, MaggotSpawn])) <= 0){
                                    instance_create(x + 16, y + 16, BonePile);
            		                _spawned = true;
                                }
                            }
                        }
                    }
        		    until (_spawned || _tries-- <= 0);
                }
                
                 // Spawn scorpion rocks occasionally:
                if(chance(3, 5)){
                     // This part is irrelevant don't worry:
                    var _friendChance = 0;
                    with(instances_matching_le(Player, "my_health", 3)){
                        if(_friendChance <= 0 || my_health <= _friendChance) _friendChance = my_health;
                    }
                    
                    var _spawned = false,
                        _tries = 100;

                    do{
                        with(instance_random(Floor)){
                            if(point_distance(x, y, 10016, 10016) > 48){
                                if(array_length(instances_meeting(x, y, [prop, chestprop, Wall, MaggotSpawn])) <= 0){
                                    with(obj_create(x + 16, y + 14, "ScorpionRock")){
                                    	if(_friendChance > 0) friendly = chance(1, _friendChance);
                                    }
                                    _spawned = true;
                                }
                            }
                        }
                    }
                    until(_spawned || _tries-- <= 0);
                }
    		}

             // Spawn Baby Scorpions:
            with(Scorpion) if(chance(1, 4)){
                repeat(irandom_range(1, 3)) obj_create(x, y, "BabyScorpion");
            }
            with(GoldScorpion) if(chance(1, 4)){
            	repeat(irandom_range(1, 3)) obj_create(x, y, "BabyScorpionGold");
            }
            with(MaggotSpawn){
            	babyscorp_drop = chance(1, 8);
            }
            
             // Rare scorpion desert (EASTER EGG):
            if(GameCont.subarea > 1 || GameCont.loops > 0){
            	if(chance(1, 120) || (chance(1, 60) && array_length(instances_matching(instances_named(CustomObject, "Pet"), "pet", "Scorpion")) > 0)){
	                with(instances_matching_ge(enemy, "size", 1)) if(chance(1, 2)){
	                    var _gold = chance(1, 5);
	                    
	                     // Normal scorpion:
	                    if(chance(2, 5)){
	                    	instance_create(x, y, (!_gold ? Scorpion : GoldScorpion));
	                    }
	                    
	                     // Baby scorpions:
	                    else repeat(1 + irandom(2)){
	                    	obj_create(x, y, (!_gold ? "BabyScorpion" : "BabyScorpionGold"));
	                    }
	                     
	                    instance_delete(id);
	                }
	                with(MaggotSpawn) babyscorp_drop++;
	                with(Cactus) if(chance(1, 2)){
	                	obj_create(x, y, "BigCactus");
	                	instance_delete(id);
	                }
	                
	                 // Scary sound:
	                sound_play_pitchvol(sndGoldTankShoot, 1, 0.6);
	                sound_play_pitchvol(sndGoldScorpionFire, 0.8, 1.4);
	            }
            }
            break;

        case 2: /// SEWERS
             // Spawn Cats:
    	    with(ToxicBarrel){
    	        repeat(irandom_range(2, 3)){
    	        	obj_create(x, y, "Cat");
    	        }
    	    }
            break;

        case 4: /// CAVES
             // Spawn Mortars:
        	with(instances_matching(LaserCrystal, "mortar_check", null, false)){
        	    mortar_check = true;
        	    if(chance(1, 4)){
        	        obj_create(x, y, "Mortar");
        	        instance_delete(self);
        	    }
        	}
        	
        	 // Spawn Spider Walls:
        	if(instance_exists(Wall)){
        	     // Strays:
        	    repeat(8 + irandom(4)) with(instance_random(Wall)) if(point_distance(x, y, 10016, 10016) > 48){
        	    	if(array_length(instances_matching(instances_named(CustomObject, "SpiderWall"), "creator", id)) <= 0){
	        	        with(obj_create(x, y, "SpiderWall")){
	        	            creator = other;
	        	        }
        	    	}
        	    }
        	    
        	     // Central mass:
        	    var _spawned = false,
        	        _tries = 100;
        	    do{
        	        with(instance_random(Wall)) if(point_distance(x, y, 10016, 10016) > 128){
        	             // Spawn Main Wall:
        	            with(obj_create(x, y, "SpiderWall")){
        	                creator = other;
        	                special = true;
        	            }
        	            
        	             // Spawn fake walls:
        	            with(Wall) if(point_distance(x, y, other.x, other.y) <= 48 && chance(2, 3) && self != other){
        	                with(obj_create(x, y, "SpiderWall")){
        	                    creator = other;
        	                }
        	            }
        	            
        	             // Change TopSmalls:
        	            with(TopSmall) if(point_distance(x, y, other.x, other.y) <= 48 && chance(1, 3)){
        	                sprite_index = spr.SpiderWallTrans;
        	            }
        	            
        	            _spawned = true;
        	        }
        	    }
        	    until(_spawned || _tries-- <= 0);
        	} 
        	 
            break;

        case 103: /// MANSIOM  its MANSION idiot, who wrote this
             // Spawn Gold Mimic:
            with(instance_nearest(10016, 10016, GoldChest)){
                with(Pet_spawn(x, y, "Mimic")){
                    wep = decide_wep_gold(18, 18 + GameCont.loops, 0);
                }
                instance_delete(self);
            }
            break;

        case 104: /// CURSED CAVES
             // Spawn Cursed Mortars:
        	with(instances_matching(InvLaserCrystal, "mortar_check", null, false)){
        	    mortar_check = true;
        	    if(chance(1, 4)){
        	        obj_create(x, y, "InvMortar");
        	        instance_delete(self);
        	    }
        	}

             // Spawn Prism:
            with(BigCursedChest) {
                Pet_spawn(x, y, "Prism");
            }
            break;

        case "coast":
             // Cool parrot:
            if(GameCont.subarea == 1){
                with(instances_matching(instances_matching(CustomHitme, "name", "CoastDecal"), "shell", true)){
                    with(Pet_spawn(x, y, "Parrot")){
                        perched = other;
                    }
                }
            }

             // who's that bird? \\
            if(!unlock_get("parrot")){
                unlock_set("parrot", true); // It's a secret yo
                scrUnlock("PARROT", "FOR REACHING COAST", spr.Parrot[0].Portrait, sndRavenScreech);
            }
            break;

		case "oasis":
			 // Fierce boy:
            if(GameCont.subarea == 1 && instance_exists(Floor) && instance_exists(Player)){
                var f = noone,
                    p = instance_nearest(10016, 10016, Player),
                    _tries = 1000;

                do f = instance_random(Floor);
                until (point_distance(f.x + 16, f.y + 16, p.x, p.y) > 128 || _tries-- <= 0);

                Pet_spawn(f.x + 16, f.y + 16, "Slaughter");
            }
			break;

        case "trench":
            if(GameCont.subarea == 1 && instance_exists(Floor) && instance_exists(Player)){
                var f = noone,
                    p = instance_nearest(10016, 10016, Player),
                    _tries = 1000;

                do f = instance_random(instances_matching(Floor, "sprite_index", spr.FloorTrenchB));
                until (point_distance(f.x + 16, f.y + 16, p.x, p.y) > 128 || _tries-- <= 0);

                Pet_spawn(f.x + 16, f.y + 16, "Octo");
            }
            break;
    }

     // Flavor big cactus:
    if(chance(1, ((GameCont.area == 0) ? 3 : 10))){
    	with(instance_random([Cactus, NightCactus])){
	        obj_create(x, y, "BigCactus");
	        instance_delete(id);
    	}
    }

     // Crab Skeletons Drop Bones:
    with(BonePile) with(obj_create(x, y, "BoneSpawner")) creator = other;

	 // Sewer manhole:
	with(PizzaEntrance){
	    with obj_create(x,y,"Manhole") toarea = "pizza";
	    instance_delete(id);
	}
	
	 // OG gators:
	with(Gator){
	    with instance_create(x,y,GatorSmoke) image_speed = 0.4;
	    instance_delete(id);
	}

     // Big Decals:
    var _chance = 1/8;
	if(area_get_subarea(GameCont.area) <= 1){
		 // Secret Levels:
		if(is_real(GameCont.area) && GameCont.area >= 100){
			_chance = 1/2;
		}

		 // Transition Levels:
		else _chance = 1/4;
	}
    if(chance(_chance, 1) && instance_exists(Player)){
        var _tries = 1000;
        while(_tries-- > 0){
            with(instance_random(TopSmall)){
                var p = instance_nearest(x, y, Player);
                if(point_distance(x + 8, y + 8, p.x, p.y) > 100){
                    obj_create(x, y, "BigDecal");
                    _tries = 0;
                }
            }
        }
    }
    
     // Spawn CoolGuy:
    if(GameCont.area = "pizza") with(TV) {
        var f = instance_nearest(x, y + 48, Floor);
        Pet_spawn(x, f.y + 16, "CoolGuy");
    }

     // Spider Cocoons:
    with(Cocoon) if(chance(4, 5)){ 
    	obj_create(x, y, "NewCocoon");
    	instance_delete(id);
    }

     // Visibilize Pets:
    with(instances_matching(CustomObject, "name", "Pet")) visible = true;

#define step
    script_bind_end_step(end_step, 0);

     // Custom CampChars:
    if(instance_exists(Menu)){
         // Make Custom CampChars:
        for(var i = 0; i < array_length(global.campchar); i++){
            var n = global.campchar[i];
            if(mod_exists("race", n) && unlock_get(n)){
                if(array_length(instances_matching(CampChar, "race", n)) <= 0){
                    with(CampChar_create(64, 48, n)){
                         // Poof in:
                        repeat(8) with(instance_create(x, y + 4, Dust)){
                            motion_add(random(360), 3);
                            depth = other.depth - 1;
                        }
                    }
                }
            }
        }

         // CampChar Stuff:
        for(var i = 0; i < maxp; i++) if(player_is_active(i)){
            var r = player_get_race(i);
            if(array_find_index(global.campchar, r) >= 0){
                with(instances_matching(CampChar, "race", player_get_race(i))){
                     // Pan Camera:
                    with(instances_matching(CampChar, "num", 17)){
                    	global.campchar_fix = true;

					    var _shake = UberCont.opt_shake;
					    UberCont.opt_shake = 1;

						var _x1 = x,
							_y1 = y,
							_x2 = other.x,
							_y2 = other.y,
			        		_pan = 4;

						with(player_create(_x1, _y1, i)){
							gunangle = point_direction(_x1, _y1, _x2, _y2);
							weapon_post(0, point_distance(_x1, _y1, _x2, _y2) * (1 + ((2/3) / _pan)) * 0.1, 0);

							instance_delete(id);
						}

					    UberCont.opt_shake = _shake;
						break;
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
    else if(global.campchar_fix){
		global.campchar_fix = false;

		 // Save Sounds:
		var _sndList = [],
			_sndMax = audio_play_sound(0, 0, 0);

		audio_stop_sound(_sndMax);

		for(var i = max(_sndMax - 1000, 400000); i < _sndMax; i++){
			if(audio_is_playing(i)){
				if(audio_sound_length_nonsync(i) < 10){
					array_push(_sndList, [asset_get_index(audio_get_name(i)), audio_sound_get_gain(i), audio_sound_get_pitch(i), audio_sound_get_track_position_nonsync(i)]);
				}
			}
		}

		 // Restart Game:
		game_restart();
		sound_stop(sndRestart);

		 // Resume Sounds:
		with(_sndList){
			var s = self,
				_snd = audio_play_sound(s[0], 0, false);

			audio_sound_gain(_snd, s[1], 0);
			audio_sound_pitch(_snd, s[2]);
			audio_sound_set_track_position(_snd, s[3]);
		}
    }

     // Pet Slots:
    with(instances_matching(Player, "pet", null)) pet = [noone];

	 // Save Stuff in Revive:
	with(instances_matching_le(Player, "my_health", 0)){
		if(fork()){
			var _x = x,
				_y = y,
				_save = ["pet", "feather_ammo"],
				_vars = {};

			with(_save){
				if(self in other){
					lq_set(_vars, self, variable_instance_get(other, self));
				}
			}

			 // Storing Vars w/ Revive
			wait 0;
			if(!instance_exists(self)) with(other){
				with(nearest_instance(_x, _y, instances_matching(Revive, "ntte_storage", null))){
					ntte_storage = obj_create(x, y, "ReviveNTTE");
					with(ntte_storage){
						creator = other;
						vars = _vars;
						p = other.p;
					}
				}
			}
			exit;
		}
	}

     // GENERATION CODE //
    if(instance_exists(GenCont) || instance_exists(Menu)) global.newLevel = 1;
    else if(global.newLevel){
        global.newLevel = 0;
        level_start();
    }

     // Call Area Events (Not built into area mods):
    var a = array_find_index(global.area, GameCont.area);
    if(a < 0 && GameCont.area = 100) a = array_find_index(global.area, GameCont.lastarea);
    if(a >= 0){
        var _area = global.area[a];

         // Floor Setup:
        var _scrt = "area_setup_floor";
        if(mod_script_exists("area", _area, _scrt)){
            with(instances_matching(Floor, "ntte_setup", null)){
                ntte_setup = true;
                mod_script_call("area", _area, _scrt, (object_index == FloorExplo));
            }
        }

        if(!instance_exists(GenCont)){
             // Step(s):
            mod_script_call("area", _area, "area_step");
            if(mod_script_exists("area", _area, "area_begin_step")){
                script_bind_begin_step(area_step, 0, _area);
            }
            if(mod_script_exists("area", _area, "area_end_step")){
                script_bind_end_step(area_step, 0, _area);
            }

             // Floor FX:
            if(global.effect_timer <= 0){
                global.effect_timer = random(60);

                var _scrt = "area_effect";
                if(mod_script_exists("area", _area, _scrt)){
                     // Pick Random Player's Screen:
                    do var i = irandom(maxp - 1);
                    until player_is_active(i);
                    var _vx = view_xview[i], _vy = view_yview[i];

                     // FX:
                    var t = mod_script_call("area", _area, _scrt, _vx, _vy);
                    if(!is_undefined(t) && t > 0) global.effect_timer = t;
                }
            }
            else global.effect_timer -= current_time_scale;
        }
        else global.effect_timer = 0;

         // Music / Ambience:
        if(instance_exists(GenCont) || instance_exists(mutbutton)){
            var _scrt = ["area_music", "area_ambience"];
            for(var i = 0; i < lq_size(global.current); i++){
                var _type = lq_get_key(global.current, i);
                if(mod_script_exists("area", _area, _scrt[i])){
                    var s = mod_script_call("area", _area, _scrt[i]);
                    if(!is_array(s)) s = [s];

                    while(array_length(s) < 3) array_push(s, -1);
                    if(s[1] == -1) s[1] = 1;
                    if(s[2] == -1) s[2] = 0;

                    sound_play_ntte(_type, s[0], s[1], s[2]);
                }
            }
        }
    }

     // Fix for Custom Music/Ambience:
    for(var i = 0; i < lq_size(global.current); i++){
        var _type = lq_get_key(global.current, i),
            c = lq_get_value(global.current, i);

        if(audio_is_playing(c.hold)){
            if(!audio_is_playing(c.snd)){
                audio_sound_set_track_position(audio_play_sound(c.snd, 0, true), c.pos);
            }
        }
        else audio_stop_sound(c.snd);
    }

     // Baby Scorpion Spawn:
    with(instances_matching_gt(instances_matching_le(MaggotSpawn, "my_health", 0), "babyscorp_drop", 0)){
    	repeat(babyscorp_drop){
    		obj_create(x, y, "BabyScorpion");
    	}
    }

	 // Weapon Pack Unlocks:
	if(!instance_exists(GenCont) && !instance_exists(LevCont) && instance_exists(Player)){
		var _packList = {
			"coast" : ["BEACH GUNS" , "GRAB YOUR FRIENDS"],
			"oasis" : ["BUBBLE GUNS", "SOAP AND WATER"],
			"trench": ["TECH GUNS"  , "TERRORS FROM THE DEEP"]
		};

		for(var i = 0; i < array_length(_packList); i++){
			var _area = lq_get_key(_packList, i),
				_pack = lq_get_value(_packList, i),
				_unlock = _area + "Wep";
	
			if(!unlock_get(_unlock)){
				if(GameCont.area == _area){
					if(GameCont.subarea >= area_get_subarea(_area)){
						if(!instance_exists(enemy) && !instance_exists(CorpseActive)){
	                		unlock_set(_unlock, true);
	                		sound_play(sndGoldUnlock);
	                		scrUnlock(_pack[0], _pack[1], -1, -1);
						}
					}
				}
			}
		}
	}

     // Fixes weird delay thing:
    script_bind_step(bone_step, 0);

     // Charm Step:
    if(!instance_exists(global.charm_step)){
        global.charm_step = script_bind_end_step(charm_step, 0);
        with(global.charm_step) persistent = true;
    }

#define sound_play_ntte /// sound_play_ntte(_type, _snd, ?_vol = undefined, ?_pos = undefined)
    var _type = argument[0], _snd = argument[1];
var _vol = argument_count > 2 ? argument[2] : undefined;
var _pos = argument_count > 3 ? argument[3] : undefined;
    if(is_undefined(_vol)) _vol = 1;
    if(is_undefined(_pos)) _pos = 0;

    var c = lq_get(global.current, _type);

     // Stop Previous Track:
    if(_snd != c.snd){
        audio_stop_sound(c.snd);
    }

     // Set Stuff:
    c.snd = _snd;
    c.vol = _vol;
    c.pos = _pos;

     // Play Track:
    if(!audio_is_playing(c.hold)){
        switch(_type){
            case "mus":
                sound_play_music(-1);
                sound_play_music(c.hold);
                break;
        
            case "amb":
                sound_play_ambient(-1);
                sound_play_ambient(c.hold);
                break;
        }
    }

#define draw_gui_end
     // Custom Sound Volume:
    for(var i = 0; i < array_length(global.current); i++){
        var c = lq_get_value(global.current, i);
        if(c.snd != -1){
            audio_sound_gain(c.snd, audio_sound_get_gain(c.hold) * c.vol, 0);
        }
    }

#define area_step(_area)
    var _scrt = "step";
    switch(object_index){
        case CustomBeginStep:
            _scrt = "begin_step";
            break;

        case CustomEndStep:
            _scrt = "end_step";
            break;
    }

    if(fork()){ // Fork for error handling
        mod_script_call("area", _area, "area_" + _scrt);
        exit;
    }

    instance_destroy();

#define end_step
    instance_destroy();

     // Convert WepPickups to Pickup Indicators:
    with(instances_matching(WepPickup, "convert_pickup_indicator", true)){
        var v = ["creator", "mask_index", "xoff", "yoff"],
            _save = {};

        with(v) lq_set(_save, self, variable_instance_get(other, self));
        instance_change(CustomObject, true);
        with(v) variable_instance_set(other, self, lq_get(_save, self));

        name = "PickupIndicator";
        on_end_step = pickup_indicator_end_step;
    }

     // Make Game Display Pickup Indicators:
    with(instances_matching(Player, "nearwep", noone)){
        if(place_meeting(x, y, CustomObject)){
            with(nearest_instance(x, y, instances_matching(instances_matching(CustomObject, "name", "PickupIndicator"), "visible", true))){
                if(place_meeting(x, y, other)){
                    x += xoff;
                    y += yoff;
                    with(other){
                        nearwep = other;
                        if(canpick && button_pressed(index, "pick")){
                            other.pick = index;
                        }
                    }
                }
            }
        }
    }

#define bone_step
    instance_destroy();

     // Reset Bone Ammo Indicator:
    global.bones = [];
    with(Player){
        var _wep = [wep, bwep];
        for(var i = 0; i < array_length(_wep); i++){
            if(is_object(_wep[i]) && wep_get(_wep[i]) == "crabbone"){
                if(_wep[i].ammo > 1){
                    array_push(global.bones, {
                        ammo : _wep[i].ammo,
                        index : index,
                        primary : !i,
                        steroids : (race == "steroids")
                        });
                }
            }
        }
    }

     // Draw Bone Ammo Indicators:
    var d = 0;
    if(instance_exists(TopCont)) d = TopCont.depth;
    if(instance_exists(GenCont)) d = GenCont.depth;
    if(instance_exists(LevCont)) d = LevCont.depth;
    if(d != 0) with(global.bones){
        script_bind_draw(ammo_draw_scrt, d - 1, index, primary, ammo, steroids);
    }

#define draw
	 // NTTE Options at Campfire:
	if(instance_exists(Menu)){
    	draw_set_projection(0);

		if(OptionOpen){
            global.option_NTTE_splat_menu = 2;

	         // Hide Things:
	        with(Menu){
	            charsplat = 1;
	            for(var i = 0; i < array_length(charx); i++) charx[i] = 0;
	        }
	        with(CharSelect){
	            visible = false;
	            alarm0 = 2;
	            noinput = 2;
	        }
	        with(Loadout){
	            visible = false;
	            selected = -1;
	            introsettle = 1;
	        }
	        with(loadbutton) instance_destroy();
	        with(BackFromCharSelect) noinput = 8;
	
	         // Dim Screen:
	        draw_set_color(c_black);
	        draw_set_alpha(0.75);
	        draw_rectangle(0, 0, game_width, game_height, 0);
	        draw_set_alpha(1);

	         // Leave Options:
	        for(var i = 0; i < maxp; i++){
	        	with(BackFromCharSelect){
	        		if(position_meeting((mouse_x[i] - (view_xview[i] + xstart)) + x, (mouse_y[i] - (view_yview[i] + ystart)) + y, id)){
		        		if(button_pressed(i, "fire")){
		        			OptionOpen = false;
		        			break;
		        		}
	        		}
	        	}
	        	if(button_pressed(i, "spec") || button_pressed(i, "paus")){
	        		OptionOpen = false;
	        		break;
	        	}
	        }
	        if(!OptionOpen){
	        	sound_play(sndClickBack);
	        	with(Loadout){
	        		visible = true;
	        		selected = 0;
	        	}
	        }
		}

		 // Open Options:
		else{
			var _hover = false,
				_x1 = game_width - 40,
				_y1 = 40,
				_max = 0;

			 // Offset for Co-op:
			for(var i = 0; i < array_length(Menu.charx); i++){
				if(Menu.charx[i] != 0) _max = i;
			}
			if(_max >= 2){
				_x1 -= 138;
			}

			var _x2 = _x1 + 40,
				_y2 = _y1 + 24;

			 // Player Clicky:
			if(!instance_exists(Loadout) || !Loadout.selected){
				for(var i = 0; i < maxp; i++){
					if(point_in_rectangle(mouse_x[i] - view_xview[i], mouse_y[i] - view_yview[i], _x1, _y1, _x2, _y2)){
						_hover = true;
						if(button_pressed(i, "fire")){
							sound_play_pitch(sndMenuCredits, 1 + orandom(0.1));
							OptionOpen = true;
							break;
						}
					}
				}
			}

			 // Button Visual:
            global.option_NTTE_splat_menu = clamp(global.option_NTTE_splat_menu, 0, sprite_get_number(sprBossNameSplat) - 1);
			draw_sprite_ext(sprBossNameSplat, global.option_NTTE_splat_menu, _x1 + 17, _y1 + 12 + global.option_NTTE_splat_menu, 1, 1, 90, c_white, 1);
            global.option_NTTE_splat_menu += current_time_scale;
			//draw_set_font(fntM);
			//draw_set_halign(fa_center);
			//draw_set_valign(fa_middle);
			//draw_text_nt(((_x1 + _x2) / 2), _y1 + 8 + _hover, (_hover ? "@w" : "@s") + "NTTE");
			draw_sprite_ext(spr.MenuNTTE, 0, (_x1 + _x2) / 2, _y1 + 8 + _hover, 1, 1, 0, (_hover ? c_white : c_silver), 1);
		}

		 // Main Option Drawing:
		ntte_options(OptionX, OptionY);

		draw_reset_projection();
	}

#define draw_pause
     // Reset Stuff:
    if(GameCont.area == "coast"){
        mod_variable_set("area", GameCont.area, "surfReset", true);
    }
    with(instances_matching(CustomDraw, "name", "draw_pit")){
        mod_variable_set("area", "trench", "surf_reset", true);
    }

     // Draw Bone Ammo Indicators:
    if(instance_exists(PauseButton)) with(global.bones){
        ammo_draw(index, primary, ammo, steroids);
    }

     // NTTE Options:
	draw_set_projection(0);

    if(!OptionOpen){
    	if(instance_exists(OptionMenuButton)){
	        var _draw = true;
	        with(OptionMenuButton) if(alarm_get(0) >= 1 || alarm_get(1) >= 1) _draw = false;
	        if(_draw){
	            var _x = (game_width / 2),
	                _y = (game_height / 2) + 59,
	                _hover = false;
	
	             // Button Clicking:
		        for(var i = 0; i < maxp; i++){
		            if(point_in_rectangle(mouse_x[i] - view_xview[i], mouse_y[i] - view_yview[i], _x - 57, _y - 12, _x + 57, _y + 12)){
		                _hover = true;
		                if(button_pressed(i, "fire")){
		                    OptionOpen = true;
		                    with(OptionMenuButton) instance_destroy();
		                    sound_play(sndClick);
		                    break;
		                }
		            }
		        }
	
	             // Splat:
	            global.option_NTTE_splat += (_hover ? 1 : -1) * current_time_scale;
	            global.option_NTTE_splat = clamp(global.option_NTTE_splat, 0, sprite_get_number(sprMainMenuSplat) - 1);
	            draw_sprite(sprMainMenuSplat, global.option_NTTE_splat, (game_width / 2), _y);
	
	             // Gray Out Other Options:
	            if(global.option_NTTE_splat > 0){
	                var _spr = sprOptionsButtons;
	                for(var j = 0; j < sprite_get_number(_spr); j++){
	                    var _dx = (game_width / 2),
	                        _dy = (game_height / 2) - 36 + (j * 24);
	
	                    draw_sprite_ext(_spr, j, _dx, _dy, 1, 1, 0, make_color_rgb(155, 155, 155), 1);
	                }
	            }
	
	             // Button:
	            draw_sprite_ext(spr.OptionNTTE, 0, _x, _y, 1, 1, 0, (_hover ? c_white : make_color_rgb(155, 155, 155)), 1);
	        }
    		else global.option_NTTE_splat = 0;
    	}
    }
	else if(instance_exists(menubutton)){
		OptionOpen = false;
	}

	ntte_options(OptionX, OptionY);

	draw_reset_projection();

#define ntte_options(_optionsX, _optionsY)
    if(OptionOpen){
        OptionPop++;

	    var _tooltip = "",
    		_x = _optionsX,
    		_y = _optionsY;
	
	    draw_set_font(fntM);
	    draw_set_halign(fa_left);
	    draw_set_valign(fa_middle);

         // Option Selecting & Splat:
        for(var i = 0; i < array_length(OptionMenu); i++){
            var _option = OptionMenu[i],
                _selected = (OptionSlct == i);

			with(_option) appear = (i + 3);

             // Select:
            for(var p = 0; p < maxp; p++) if(player_is_active(p)){
                var _vx = view_xview[p],
                    _vy = view_yview[p],
                    _mx = mouse_x[p] - _vx,
                    _my = mouse_y[p] - _vy;

                if(point_in_rectangle(_mx, _my, _x - 80, _y - 8, _x + 159, _y + 6)){
                    if(_option.type >= 0 && player_is_local_nonsync(p)){
                        OptionSlct = i;
                    }

                    with(_option) if(OptionPop >= appear){
                         // Click:
                        if(type >= 0){
                            if(!clicked){
                                if(button_pressed(p, "fire")){
                                    if(player_is_local_nonsync(p)) clicked = true;
                                    switch(type){
                                        case opt_slider:
                                            sound_play(sndSlider);
                                            break;
    
                                        default:
                                            sound_play(sndClick);
                                            break;
                                    }
                                }
                            }
                            else if(!button_check(p, "fire")){
                                if(player_is_local_nonsync(p)) clicked = false;
                                switch(type){
                                    case opt_slider:
                                        sound_play(sndSliderLetGo);
                                        break;
                                }
                            }
                        }

                         // Option Specifics:
                        if(sync || player_is_local_nonsync(p)) switch(type){
                            case opt_toggle:
                                if(button_pressed(p, "fire")){
                                    lq_set(opt, varname, (lq_defget(opt, varname, 0) + 1) % array_length(pick));
                                }
                                break;

                            case opt_slider:
                                if(button_check(p, "fire") && clicked){
                                    var _slider = clamp(round(_mx - (_x + 40)) / 100, 0, 1);
                                    lq_set(opt, varname, _slider);
                                }
                                else{
                                    var _adjust = 0.1 * (button_pressed(p, "east") - button_pressed(p, "west"));
                                    if(_adjust != 0){
                                        lq_set(opt, varname, clamp(lq_get(opt, varname) + _adjust, 0, 2));
                                    }
                                }
                                break;
                        }

                         // Description on Hover:
                        if("text" in self){
                            //if(!button_check(p, "fire") || type == opt_title){
                                if(_mx < (game_width / 2) + 32){
                                    if(player_is_local_nonsync(p)){
                                        _tooltip = text;
                                    }
                                }
                            //}
                        }
                    }
                }
                else if(player_is_local_nonsync(p)){
                	_option.clicked = false;
                }
            }

            with(_option){
                if("splat" not in self) splat = 0;
            	if(type == opt_title) _y += 2;
                x = _x;
                y = _y;

                if(OptionPop >= appear){
                     // Appear Pop:
                    if(OptionPop == appear) sound_play_pitch(sndAppear, random_range(0.5, 1.5));
    
                     // Selection Splat:
                    splat += (_selected ? 1 : -1) * current_time_scale;
                    splat = clamp(splat, 0, sprite_get_number(sprMainMenuSplat) - 1);
                    if(splat > 0) with(other) draw_sprite(sprMainMenuSplat, other.splat, _x, _y);
                }
            }
            _y += 16;
        }

         // Option Text:
        var _titleFound = false;
        for(var i = 0; i < array_length(OptionMenu); i++){
            var _option = OptionMenu[i],
                _selected = (OptionSlct == i);

            with(_option) if(OptionPop >= appear){
                 // Option Name:
                var _x = x - 80,
                    _y = y,
                    _name = name;

                if(type == opt_title){
                    _titleFound = true;
                    draw_set_color(c_white);
                }
                else if(_titleFound){
                    _name = " " + _name;
                }

                if(_selected){
                    _y--;
                    draw_set_color(c_white);
                }
                else draw_set_color(make_color_rgb(125, 131, 141));
                if(OptionPop < (appear + 1)) _y++;

                draw_text_shadow(_x, _y, _name);

                 // Option Specifics:
                _x += 124;
                var _value = lq_defget(opt, varname, 0);
                with(other){
                	switch(other.type){
	                    case opt_toggle:
	                        draw_text_shadow(_x, _y, other.pick[clamp(_value, 0, array_length(other.pick) - 1)]);
	                        break;
	
	                    case opt_slider:
	                        var _dx = _x - 5,
	                            _dy = _y - 2,
	                            w = 6 + (100 * _value),
	                            h = sprite_get_height(sprOptionSlider);

	                         // Slider:
	                        draw_sprite(sprOptionSlider,      0,             _dx,           _dy);
	                        draw_sprite_part(sprOptionSlider, 1, 0, 0, w, h, _dx - 5,       _dy - 6);
	                        draw_sprite(sprSliderEnd,         1,             _dx + w - 2,   _y);
	
	                         // Text:
	                        draw_set_color(c_white);
	                        draw_text_shadow(_x, _y + 1, string_format(_value * 100, 0, 0) + "%");
	                        break;
                	}
                	switch(_name){
                		case "Water Quality :": // Water Quality Visual
                			var	_slct = in_range(OptionSlct, i, i + 2),
                				_spr = spr.GullIdle,
                				_img = (current_frame * 0.4),
                				_scale = [
                					1/3 + (2/3 * lq_defget(opt, "waterQualityMain", 1)),
                					1/2 + (1/2 * lq_defget(opt, "waterQualityTop", 1))
                				],
                				_sx = _x - 32,
                				_sy = _y + 12;

							for(var s = 0; s < array_length(_scale); s++){
								var _sw = sprite_get_width(_spr) * _scale[s],
									_sh = sprite_get_height(_spr) * _scale[s],
                					_surf = surface_create(_sw, _sh);

								 // Quality Visual:
								surface_set_target(_surf);
								draw_clear_alpha(0, 0);

                				var _dx = (_sw / 2),
                					_dy = (_sh / 2) - ((2 + sin(current_frame / 10)) * _scale[s]);

								draw_sprite_ext(_spr, _img, _dx, _dy, _scale[s], _scale[s], 0, (_slct ? c_white : c_gray), 1);

								surface_reset_target();
	    						draw_set_projection(0);

								 // Draw Clipped/Colored Surface:
								if(s == 0){
									var b = merge_color(make_color_rgb(44, 37, 122), make_color_rgb(27, 118, 184), 0.25 + (0.25 * sin(current_frame / 30)));
									draw_set_flat(_slct ? b : merge_color(b, c_black, 0.5));
									draw_surface_part_ext(_surf, 0, (_sh / 2), _sw, (_sh / 2), _sx, _sy + ((_sh / 2) / _scale[s]), 1 / _scale[s], 1 / _scale[s], c_white, 1);
									draw_set_flat(-1);
								}
								else{
									draw_surface_part_ext(_surf, 0, 0, _sw, (_sh / 2) + 1, _sx,	_sy, 1/_scale[s], 1/_scale[s], c_white, 1);
									draw_set_flat(_slct ? c_white : c_gray);
									draw_surface_part_ext(_surf, 0,	(_sh / 2), _sw, 1, _sx, _sy + ((_sh / 2) / _scale[s]), 1/_scale[s], 1/_scale[s], c_white, 0.8);
									draw_set_flat(-1);
								}

	    						surface_destroy(_surf);
							}
                			break;
                	}
                }
            }
        }

         // Tooltip:
        draw_reset_projection();
        if(instance_exists(Menu)){
        	script_bind_draw(tooltip_menu, -1002, _tooltip);
        }
        else if(_tooltip != ""){
            draw_tooltip(mouse_x_nonsync, mouse_y_nonsync, _tooltip);
        }
    }
    else{
        OptionPop = false;
        OptionSlct = -1;
        with(OptionMenu) splat = 0;
    }

#define tooltip_menu(_tooltip)
	instance_destroy();
	if(_tooltip != ""){
		draw_tooltip(mouse_x_nonsync, mouse_y_nonsync, _tooltip);
	}

#define ammo_draw_scrt(_index, _primary, _ammo, _steroids)
    instance_destroy();
    ammo_draw(_index, _primary, _ammo, _steroids);

#define ammo_draw(_index, _primary, _ammo, _steroids)
    if(player_get_show_hud(_index, _index)){
	    var _active = 0;
	    for(var i = 0; i < maxp; i++) _active += player_is_active(i);
	
	    draw_set_visible_all(0);
	    draw_set_visible(_index, 1);
	    draw_set_projection(0);
	
	    var _x = (_primary ? 42 : 86),
	        _y = 21;
	
	    if(_active > 1) _x -= 19;
	
	    draw_set_halign(fa_left);
	    draw_set_valign(fa_top);
	    draw_set_color(c_white);
	    if(!_primary && !_steroids) draw_set_color(c_silver);
	
	    draw_text_shadow(_x, _y, string(_ammo));
	
	    draw_reset_projection();
	    draw_set_visible_all(1);
    }

#define underwater_step /// Call from underwater area step events
     // Lightning:
    with(Lightning){
        image_index -= image_speed * 0.75;

         // Zap:
        if(image_index > image_number - 1){
            with(instance_create(x, y, EnemyLightning)){
                image_speed = 0.3;
                image_angle = other.image_angle;
                image_xscale = other.image_xscale;
                if(chance(1, 8)){
                    sound_play_hit(sndLightningHit,0.2);
                    with(instance_create(x, y, GunWarrantEmpty)){
                        image_angle = other.direction;
                    }
                }
                else if(chance(1, 3)){
                    instance_create(x + orandom(18), y + orandom(18), PortalL);
                }
            }
            instance_destroy();
        }
    }

     // Flames Boil Water:
    with instances_matching([Flame, TrapFire], "", null){
        if(sprite_index != sprFishBoost){
            if(image_index > 2){
                sprite_index = sprFishBoost;
                image_index = 0;

                 // FX:
                if(chance(1, 3)){
                    var xx = x,
                        yy = y,
                        vol = 0.4;
                    if fork(){
                        repeat(1 + irandom(3)){
                            instance_create(xx, yy, Bubble);
                            
                            view_shake_max_at(xx, yy, 3);
                            sleep(6);
                            
                            sound_play_pitchvol(sndOasisPortal, 1.4 + random(0.4), vol);
                            audio_sound_set_track_position(sndOasisPortal, 0.52 + random(0.04));
                            vol -= 0.1;
                            
                            wait(10 + irandom(20));
                        }
                        exit;
                    }
                }
            }
        }

         // Hot hot hot:
        else if(chance_ct(1, 100)){
            instance_create(x, y, Bubble);
        }

         // Go away ugly smoke:
        if(place_meeting(x, y, Smoke)){
            with(instance_nearest(x, y, Smoke)) instance_destroy();
            if(chance(1, 2)) with(instance_create(x, y, Bubble)){
                motion_add(other.direction, other.speed / 2);
            }
        }
    }

     // Chest Stuff:
    with(instances_matching(ChestOpen, "waterchest", null)){
        waterchest = true;
        repeat(3) instance_create(x, y, Bubble);
        if(sprite_index == sprWeaponChestOpen) sprite_index = sprClamChestOpen;
    }

    with(script_bind_step(underwater_sound, 0)) name = script[2];
    with(script_bind_draw(underwater_draw, -3)) name = script[2];
    with(script_bind_end_step(underwater_end_step, 0)) name = script[2];

#define underwater_sound
    instance_destroy();

     // Replace Sounds w/ Oasis Sounds:
    for(var i = 0; i < lq_size(global.waterSound); i++){
        var _sndOasis = asset_get_index(lq_get_key(global.waterSound, i));
        with(lq_get_value(global.waterSound, i)){
            var _snd = self;
            if(audio_is_playing(_snd[0])){
                if(_snd[1] < current_frame){
                    sound_play_pitchvol(_sndOasis, 1, 2);
                    _snd[1] = current_frame + 1;
                }
                sound_stop(_snd[0]);
            }
        }
    }
    with(instances_matching(enemy, "underwater_sound_check", null)){
        underwater_sound_check = true;
        if(object_index != CustomEnemy){
            if(snd_hurt != -1) snd_hurt = sndOasisHurt;
            if(snd_dead != -1) snd_dead = sndOasisDeath;
        }
    }

#define underwater_end_step
    instance_destroy();

     // Just in case - backup sound stopping:
    for(var i = 0; i < lq_size(global.waterSound); i++){
        var _sndOasis = asset_get_index(lq_get_key(global.waterSound, i));
        with(lq_get_value(global.waterSound, i)) sound_stop(self[0]);
    }

     // Bubbles:
    with(instances_matching(Dust, "waterbubble", null)){
        instance_create(x, y, Bubble);
        instance_destroy();
    }
    with(instances_matching(Smoke, "waterbubble", null)){
        waterbubble = true;
        instance_create(x, y, Bubble);
    }
    with(instances_matching(BoltTrail, "waterbubble", null)){
        if(image_xscale != 0 && chance(1, 4)){
            waterbubble = true;
            instance_create(x, y, Bubble);
        }
        else waterbubble = false;
    }

     // Fish Freaks:
    with(instances_matching(Freak, "fish_freak", null)){
    	fish_freak = true;
    	spr_idle = spr.FishFreakIdle;
    	spr_walk = spr.FishFreakWalk;
    	spr_hurt = spr.FishFreakHurt;
    	spr_dead = spr.FishFreakDead;
    	snd_hurt = sndOasisHurt;
    	snd_dead = sndOasisDeath;
    }

#define underwater_draw
    instance_destroy();

     // Air Bubbles:
    with(instances_matching(hitme, "spr_bubble", null)){
        spr_bubble = -1;
        spr_bubble_pop = -1;
        spr_bubble_x = 0;
        spr_bubble_y = 0;
        switch(object_index){
            case Ally:
            case Sapling:
            case Bandit:
            case Grunt:
            case Inspector:
            case Shielder:
            case EliteGrunt:
            case EliteInspector:
            case EliteShielder:
            case PopoFreak:
            case Necromancer:
            case FastRat:
            case Rat:
                spr_bubble = sprPlayerBubble;
                spr_bubble_pop = sprPlayerBubblePop;
                break;

            case Player:
                if(race != "fish"){
                    spr_bubble = sprPlayerBubble;
                    spr_bubble_pop = sprPlayerBubblePop;
                }
                break;

            case Salamander:
                spr_bubble = spr.BigBubble;
                spr_bubble_pop = spr.BigBubblePop;
                break;

            case Ratking:
            case RatkingRage:
                spr_bubble = spr.BigBubble;
                spr_bubble_pop = spr.BigBubblePop;
                spr_bubble_y = 2;
                break;

            case FireBaller:
            case SuperFireBaller:
                spr_bubble = spr.BigBubble;
                spr_bubble_pop = spr.BigBubblePop;
                spr_bubble_y = -6;
                break;
        }
    }
    with(instances_matching(instances_matching_ne(instances_seen(hitme, 16), "spr_bubble", -1), "visible", true)){
        draw_sprite(spr_bubble, -1, x + spr_bubble_x, y + spr_bubble_y);

         // Death Pop:
        if(my_health <= 0){
            if(!instance_is(self, Player) || (candie && spiriteffect <= 0)){
                instance_create(x + spr_bubble_x, y + spr_bubble_y, BubblePop);
            }
        }
    }

     // Pet Bubbles:
    with(instances_matching(instances_matching_ne(instances_matching(CustomObject, "name", "Pet"), "pet", "Prism", "Octo", "Slaughter"), "visible", true)){
        draw_sprite(sprPlayerBubble, -1, x, y);
    }

     // Boiling Water:
    d3d_set_fog(1, make_color_rgb(255, 70, 45), 0, 0);
    draw_set_blend_mode(bm_add);
    with(Flame) if(sprite_index != sprFishBoost){
        var s = 1.5,
            a = 0.1;

        draw_sprite_ext(sprDragonFire, image_index + 2, x, y, image_xscale * s, image_yscale * s, image_angle, image_blend, image_alpha * a);
    }
    draw_set_blend_mode(bm_normal);
    d3d_set_fog(0, 0, 0, 0);


#define CampChar_create(_x, _y, _race)
    _race = race_get_name(_race);
    with(instance_create(_x, _y, CampChar)){
        num = _race;
        race = _race;

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
            var o = 12;
            if(!collision_ellipse(x - o, y - o, x + o, y + o, CampChar, true, true) && !place_meeting(x, y, TV)){
                break;
            }
        }

        return id;
    }

#define scrBossIntro(_name, _sound, _music)
	if(!instance_is(self, CustomBeginStep)){
	    audio_play_sound(_sound, 0, false);
	    sound_play_ntte("mus", _music);

		 // BeginStep to fix TopCont.darkness flash
	    if(fork()){
	    	wait 0;
			script_bind_begin_step(scrBossIntro, 0, _name, _sound, _music);
			exit;
	    }
	}
	else{
		var _option = lq_defget(opt, "intros", 2),
			_introLast = UberCont.opt_bossintros;

		if(_option < 2) UberCont.opt_bossintros = _option;
		if(UberCont.opt_bossintros){
		    var _path = "sprites/intros/",
		        _lastSub = GameCont.subarea; // !!!
	
		    if(_name != ""){
		        with(instance_create(0, 0, BanditBoss)){
		            sprite_replace_image(sprBossIntro,          _path + "spr" + _name + "Main.png", 0);
		            sprite_replace_image(sprBossIntroBackLayer, _path + "spr" + _name + "Back.png", 0);
		            sprite_replace_image(sprBossName,           _path + "spr" + _name + "Name.png", 0);
		            event_perform(ev_alarm, 6);
		            sound_stop(sndBigBanditIntro);
		            instance_delete(id);
		            if(fork()){
		                wait 0;
		                sprite_restore(sprBossIntro);
		                sprite_restore(sprBossIntroBackLayer);
		                sprite_restore(sprBossName);
		                exit;
		            }
		        }
		    }
		    GameCont.subarea = _lastSub; // !!!
		}
		UberCont.opt_bossintros = _introLast;

		instance_destroy();
	}

#define scrUnlock(_name, _text, _sprite, _sound)
     // Make Sure UnlockCont Exists:
    if(array_length(UnlockCont) <= 0){
        with(instance_create(0, 0, CustomObject)){
            name = "UnlockCont";

             // Visual:
            depth = UberCont.depth - 1;

             // Vars:
            persistent = true;
            unlock = [];
            unlock_sprit = sprMutationSplat;
            unlock_image = 0;
            unlock_delay = 50;
            unlock_index = 0;
            unlock_porty = 0;
            unlock_delay_continue = 0;
            splash_sprit = sprUnlockPopupSplat;
            splash_image = 0;
            splash_index = -1;
            splash_texty = 0;
            splash_timer = 0;
            splash_timer_max = 150;

             // Events:
            on_step = unlock_step;
            on_draw = unlock_draw;
        }
    }

     // Add New Unlock:
    var u = {
        nam : [_name, _name], // [splash popup, gameover popup]
        txt : _text,
        spr : _sprite,
        img : 0,
        snd : _sound
        };

    with(UnlockCont){
        array_push(unlock, u);
    }
    return u;

#define unlock_step
    if(instance_exists(Menu)){
        instance_destroy();
        exit;
    }

     // Animate Corner Popup:
    var _img = 0;
    if(instance_exists(Player)){
        if(splash_timer > 0){
            splash_timer -= current_time_scale;
    
            _img = sprite_get_number(splash_sprit) - 1;
    
             // Text Offset:
            if(splash_image >= _img && splash_texty > 0){
                splash_texty -= current_time_scale;
            }
        }
        else{
            splash_texty = 2;
    
             // Splash Next Unlock:
            if(splash_index < array_length(unlock) - 1){
                splash_index++;
                splash_timer = splash_timer_max;
            }
        }
    }
    splash_image += clamp(_img - splash_image, -1, 1) * current_time_scale;


     // Game Over Splash:
    if(instance_exists(UnlockScreen)) unlock_delay = 1;
    else if(!instance_exists(Player)){
        while(
            unlock_index >= 0                   &&
            unlock_index < array_length(unlock) &&
            unlock[unlock_index].spr == -1
        ){
            unlock_index++; // No Game Over Splash
        }

        if(unlock_index < array_length(unlock)){
             // Disable Game Over Screen:
            with(GameOverButton){
                if(game_letterbox) alarm_set(0, 30);
                else instance_destroy();
            }
            with(TopCont){
                gameoversplat = 0;
                go_addy1 = 9999;
                dead = false;
            }
    
             // Delay Unlocks:
            if(unlock_delay > 0){
                unlock_delay -= current_time_scale;
                var _delayOver = (unlock_delay <= 0);
    
                unlock_delay_continue = 20;
                unlock_porty = 0;
    
                 // Screen Dim + Letterbox:
                with(TopCont){
                    visible = _delayOver;
                    if(darkness){
                       visible = true;
                       darkness = 2;
                    }
                }
                game_letterbox = _delayOver;
    
                 // Sound:
                if(_delayOver){
                    sound_play(sndCharUnlock);
                    sound_play(unlock[unlock_index].snd);
                }
            }
            else{
                 // Animate Unlock Splash:
                var _img = sprite_get_number(unlock_sprit) - 1;
                unlock_image += clamp(_img - unlock_image, -1, 1) * current_time_scale;
    
                 // Portrait Offset:
                if(unlock_porty < 3){
                    unlock_porty += current_time_scale;
                }
    
                 // Next Unlock:
                if(unlock_delay_continue > 0) unlock_delay_continue -= current_time_scale;
                else for(var i = 0; i < maxp; i++){
                    if(button_pressed(i, "fire") || button_pressed(i, "okay")){
                        if(unlock_index < array_length(unlock)){
                            unlock_index++;
                            unlock_delay = 1;
                        }
                        break;
                    }
                }
            }
        }

         // Done:
        else{
            with(TopCont){
                go_addy1 = 55;
                dead = true;
            }
            instance_destroy();
        }
    }

#define unlock_draw
    draw_set_projection(0);

     // Game Over Splash:
    if(unlock_delay <= 0){
        if(unlock_image > 0){
            var _unlock = unlock[unlock_index],
                _nam = _unlock.nam[1],
                _spr = _unlock.spr,
                _img = _unlock.img,
                _x = game_width / 2,
                _y = game_height - 20;

             // Unlock Portrait:
            var _px = _x - 60,
                _py = _y + 9 + unlock_porty;

            draw_sprite(_spr, _img, _px, _py);

             // Splash:
            draw_sprite(unlock_sprit, unlock_image, _x, _y);

             // Unlock Name:
            var _tx = _x,
                _ty = _y - 92 + (unlock_porty < 2);

            draw_set_font(fntBigName);
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);

            var t = string_upper(_nam);
            draw_text_nt(_tx, _ty, t);

             // Unlocked!
            _ty += string_height(t) + 3;
            if(unlock_porty >= 3){
                d3d_set_fog(1, 0, 0, 0);
                draw_sprite(sprTextUnlocked, 4, _tx + 1, _ty);
                draw_sprite(sprTextUnlocked, 4, _tx,     _ty + 1);
                draw_sprite(sprTextUnlocked, 4, _tx + 1, _ty + 1);
                d3d_set_fog(0, 0, 0, 0);
                draw_sprite(sprTextUnlocked, 4, _tx,     _ty);
            }

             // Continue Button:
            if(unlock_delay_continue <= 0){
                var _cx = _x,
                    _cy = _y - 4,
                    _blend = make_color_rgb(102, 102, 102);

                for(var i = 0; i < maxp; i++){
                    if(point_in_rectangle(mouse_x[i] - view_xview[i], mouse_y[i] - view_yview[i], _cx - 64, _cy - 12, _cx + 64, _cy + 16)){
                        _blend = c_white;
                        break;
                    }
                }

                draw_sprite_ext(sprUnlockContinue, 0, _cx, _cy, 1, 1, 0, _blend, 1);
            }
        }
    }

     // Corner Popup:
    if(splash_image > 0){
         // Splash:
        var _x = game_width,
            _y = game_height;
    
        draw_sprite(splash_sprit, splash_image, _x, _y);

         // Unlock Text:
        if(splash_texty < 2){
            var _unlock = unlock[splash_index],
                _nam = _unlock.nam[0],
                _txt = _unlock.txt,
                _tx = _x - 4,
                _ty = _y - 16 + splash_texty;

            draw_set_font(fntM);
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);

             // Title:
            var t = _nam + " UNLOCKED";
            draw_text_nt(_tx, _ty, t);

             // Description:
            if(splash_texty <= 0){
                _ty += string_height(t);
                draw_text_nt(_tx, _ty, "@s" + _txt);
            }
        }
    }

    draw_reset_projection();

#define scrPickupIndicator(_text)
    with(instance_create(0, 0, WepPickup)){
        name = _text;
        type = 0;
        creator = other;
        xoff = 0;
        yoff = 0;
        pick = -1;
        convert_pickup_indicator = true;
        mask_index = mskNone;
        visible = 0;

        return id;
    }

#define pickup_indicator_end_step
    pick = -1;

     // Follow Creator:
    var c = creator;
    if(c != noone){
        if(instance_exists(c)){
            x = c.x;
            y = c.y;
            persistent = c.persistent;
            image_index = c.image_index;
            image_angle = c.image_angle;
            image_xscale = c.image_xscale;
            image_yscale = c.image_yscale;
            if(mask_index == mskNone){
                mask_index = c.mask_index;
                if(mask_index == -1) mask_index = c.sprite_index;
            }
            if("pickup_indicator" not in c || !instance_exists(c.pickup_indicator)){
                c.pickup_indicator = id;
            }
        }
        else instance_destroy();
    }

#define alarm_creator(_object, _alarm)
  /// Calls alarm event and sets creator on objects that were spawned during it
    with(instances_matching(_object, "creator", null)) creator = noone;
    event_perform(ev_alarm, _alarm);
    var i = instances_matching(_object, "creator", null);
    with(i) creator = other;
    return i;

#define scrCharmTarget()
    with(instance){
        var _x = x,
            _y = y,
			e = instances_matching_ne(enemy, "mask_index", mskNone, sprVoid);

        if("team" in self) e = instances_matching_ne(e, "team", team);
		other.target = nearest_instance(_x, _y, e);
    }

#define charm_step
    var _charmList = ds_list_to_array(global.charm),
        _charmDraw = {};

    with(_charmList){
        var _self = instance,
            _time = time,
            _index = index;

        if(!instance_exists(_self)) scrCharm(_self, false);
        else{
			//with(instances_matching(projectile, "creator", _self)){
				/* Double Damage
				if("damage_save" not in self) damage_save = damage;
				damage = damage_save * 2;
				*/

				/* Triple Shot
				if("charm_dupe" not in self){
					charm_dupe = true;
					for(var _off = -1; _off <= 1; _off += 2){
						with(instance_copy(false)){
							var o = 30 * _off * power(0.3, skill_get(mut_eagle_eyes));
							direction += o;
							if(speed > 0) image_angle += o;
						}
					}
				}
				*/

				/* Homing
				var n = nearest_instance(x, y, instances_matching_ne(hitme, "team", 0, team));
				if(instance_exists(n)){
					var a = (image_angle == direction);
					direction += angle_difference(point_direction(x, y, n.x, n.y), direction) / (7 + random(3));
					if(a) image_angle = direction;
				}
				*/
				
				/*
				if("charm_newspeed" not in self){
					charm_newspeed = true;
					speed *= 1.25;
				}*/
			//}
			
			//with(_self){
				//if(in_sight(other.target)){
					//gunangle += angle_difference(point_direction(x, y, other.target.x + other.target.hspeed, other.target.y + other.target.vspeed), gunangle) / 3;
				//}
				//if("my_health" in self){
					/* SharpTeeth
					if("last_my_health" in self){
						if(my_health < last_my_health){
							with(instance_create(x, y, SharpTeeth)){
								damage = 2.5 * (other.last_my_health - other.my_health);
								alarm0 = 1;
								creator = nearest_instance(x, y, instances_matching_ne(enemy, "team", other.team));
							}
						}
					}
					last_my_health = my_health;
					*/
	
					// Immortal
					/*if("last_my_health" in self){
						if(my_health < last_my_health && sprite_index == spr_hurt){
							my_health = last_my_health;
							sound_stop(snd_hurt);
							sprite_index = spr_idle;
	
				             // Effects:
				            sound_play_pitch(sndCrystalPropBreak, 0.7);
				            sound_play_pitchvol(sndShielderDeflect, 1.5, 0.5);
				            repeat(5) with(instance_create(x, y, Dust)){
				                motion_add(random(360), 3);
				            }
						}
					}
					last_my_health = my_health;
					nexthurt = max(nexthurt, current_frame + 2);*/
				//}
			//}

             // Target Nearest Enemy:
            if(!instance_exists(target)) scrCharmTarget();

             // Alarms:
            with(_self){
                 // Reset Alarms:
                for(var a = 0; a <= 10; a++){
                    var _alrm = alarm_get(a);
                    if(_alrm > 0) other.alarm[a] = _alrm + current_time_scale;
                    alarm_set(a, -1);
                }
            }
            for(var i = 0; i <= 10; i++){
                 // Custom Alarms:
                if(alarm[i] > 0){
                    alarm[i] -= current_time_scale;
                    
                     // Increased Aggro:
            		if(i == 1 && alarm[i] > 15){
            			 // Not Shooting:
	            		if("ammo" not in _self || _self.ammo <= 0){
	            			 // Not Boss:
	            			var _bossList = [BanditBoss, ScrapBoss, LilHunter, Nothing, Nothing2, FrogQueen, HyperCrystal, TechnoMancer, Last, BigFish, OasisBoss];
	            			if(("boss" not in _self && array_find_index(_bossList, _self.object_index) < 0) || ("boss" in _self && !_self.boss)){
	            				 // Not Shielding:
	            				if(array_length(instances_matching(PopoShield, "creator", _self)) <= 0){
	            					alarm[i] -= current_time_scale;
	            				}
	            			}
            			}
            		}

                    if(alarm[i] <= 0){
                        alarm[i] = -1;

                         // Target Nearest Enemy:
                        scrCharmTarget();
                        with(_self){
                            target = other.target;
                            var t = target;

                             // Move Player for Enemy Targeting:
                            var _lastPos = [];
                            with(Player){
                                array_push(_lastPos, [x, y]);
                                if(instance_exists(t)){
                                    x = t.x;
                                    y = t.y;
                                }
                                else{
                                    x = choose(0, 20000);
                                    y = choose(0, 20000);
                                }
                            }

                             // Reset Alarms:
                            for(var a = 0; a <= 10; a++){
                                alarm_set(a, other.alarm[a]);
                            }

                             // Call Alarm Event:
                            if(object_index != CustomEnemy){
                                switch(object_index){
                                    case MaggotExplosion:   /// Charm Spawned Maggots
                                        alarm_creator(Maggot, i);
                                        break;

                                    case RadMaggotExplosion:   /// Charm Spawned Maggots
                                        alarm_creator(RadMaggot, i);
                                        break;

                                    case Necromancer:       /// Match ReviveArea to Necromancer
                                        with(alarm_creator(ReviveArea, i)) alarm0++;
                                        break;

                                    case Ratking:           /// Charm Spawned Rats
                                        if(i == 2) alarm_creator(FastRat, i);
                                        else event_perform(ev_alarm, i);
                                        break;

                                    case ScrapBoss:         /// Charm Spawned Missiles
                                        if(i == 0) alarm_creator(ScrapBossMissile, i);
                                        else event_perform(ev_alarm, i);
                                        break;

                                    case FrogQueen:         /// Charm Spawned Eggs
                                        if(i == 2) alarm_creator(FrogEgg, i);
                                        else event_perform(ev_alarm, i);
                                        break;

                                    case FrogEgg:           /// Charm Spawned Ballguys
                                        if(i == 0) alarm_creator(Exploder, i);
                                        else event_perform(ev_alarm, i);
                                        break;

                                    case HyperCrystal:      /// Charm Spawned Crystals
                                        if(i == 1) alarm_creator(LaserCrystal, i);
                                        else event_perform(ev_alarm, i);
                                        break;

                                    case TechnoMancer:      /// Charm Spawned Necromancers + Turrets
                                        if(i == 2) with(alarm_creator(NecroReviveArea, i)) alarm0++;
                                        else{
                                            if(i == 6) alarm_creator(Turret, i);
                                            else event_perform(ev_alarm, i);
                                        }
                                        break;

                                    case MeleeBandit:
                                    case JungleAssassin:
                                        event_perform(ev_alarm, i);
                                        charm.walk = walk;
                                        walk = 0;
                                        break;

                                    case JungleFly:
                                        if(i == 2) alarm_creator(FiredMaggot, i);
                                        else event_perform(ev_alarm, i);
                                        break;

                                    default:
                                        event_perform(ev_alarm, i);
                                }
                            }
                            else{ // Custom Alarm Support
                                var a = "on_alrm" + string(i);
                                if(a in self){
                                    var _scrt = variable_instance_get(id, a);
                                    //script_ref_call(_scrt); DO THIS INSTEAD WHEN YAL FIXES IT !!!
                                    if(array_length(_scrt) >= 3){
                                        with(self) mod_script_call_self(_scrt[0], _scrt[1], _scrt[2]);
                                    }
                                }
                            }

                             // Reset Alarms:
                            for(var a = 0; a <= 10; a++){
                                var _alrm = alarm_get(a);
                                if(_alrm > 0) other.alarm[a] = _alrm + current_time_scale;
                                alarm_set(a, -1);
                            }

                             // Return Players:
                            var i = 0;
                            with(Player){
                                var p = _lastPos[i++];
                                x = p[0];
                                y = p[1];
                            }
                        }
                    }
                }
                if(!instance_exists(_self)) break;
            }

            if(!instance_exists(_self)) scrCharm(_self, false);

            else{
                with(_self){
                    target = other.target;
                    if(instance_is(self, enemy)){
                         // Contact Damage:
                        if(place_meeting(x, y, enemy)){
                            with(instances_matching_ne(instances_matching_ne(enemy, "team", team), "creator", _self)){
                                if(place_meeting(x, y, other)) with(other){
                                	//meleedamage *= 2;
                                	//var m = meleedamage;

                                    if(alarm11 > 0 && alarm11 < 26){
                                    	event_perform(ev_alarm, 11);
                                    }
                                    event_perform(ev_collision, Player);
                                    with(other) nexthurt = current_frame;

                                    //if(meleedamage == m) meleedamage *= 2;
                                }
                            }
                        }

                         // Player Shooting:
                        /* actually pretty annoying dont use this
                        if(place_meeting(x, y, projectile)){
                            with(instances_matching(projectile, "team", team)){
                                if(place_meeting(x, y, other)){
                                    if(instance_exists(creator) && creator.object_index == Player){
                                        with(other) scrCharm(id, false);
                                        event_perform(ev_collision, enemy);
                                    }
                                }
                            }
                        }
                        */

                         // Follow Leader:
                        if(instance_exists(Player)){
                        	if(meleedamage <= 0 || "gunangle" in self || ("walk" in self && walk > 0)){
	            				if("ammo" not in self || ammo <= 0){
		                            if(distance_to_object(Player) > 256 || !instance_exists(target) || !in_sight(target) || !in_distance(target, 80)){
		                            	 // Player to Follow:
		                                var n = instance_nearest(x, y, Player);
		                                if(instance_exists(player_find(_index))){
		                                	n = nearest_instance(x, y, instances_matching(Player, "index", _index));
		                                }
		
		                                 // Stay in Range:
		                                if(distance_to_object(n) > 32){
		                                    motion_add(point_direction(x, y, n.x, n.y), 1);
		                                }
		                            }
	            				}
                        	}
                        }

                         // Add to Charm Drawing:
                        if(visible){
                        	if(!lq_exists(_charmDraw, string(_index))){
								lq_set(_charmDraw, string(_index), {
									inst: [],
									depth: 9999
								});
                        	}

                        	var p = lq_get(_charmDraw, string(_index));

                        	array_push(p.inst, id);
                        	if(depth < p.depth) p.depth = depth;
                        }
                    }

                     // Manual Exception Stuff:
                    switch(object_index){
                        case BigMaggot:
                        case MaggotSpawn:       /// Charm Spawned Maggots
                            if(my_health <= 0){
                                var _x = x, _y = y;
                                instance_destroy();
                                with(scrCharm(instance_nearest(_x, _y, MaggotExplosion), true)){
                                	time = _time;
                                	index = _index;
                                }
                            }
                            break;

                        case RadMaggotChest:
                            if(my_health <= 0){
                                var _x = x, _y = y;
                                instance_destroy();
                                with(scrCharm(instance_nearest(_x, _y, RadMaggotExplosion), true)){
                                	time = _time;
                                	index = _index;
                                }
                            }
                            break;

                        case RatkingRage:       /// Charm Spawned Rats
                            if(walk > 0 && walk <= current_time_scale){
                                with(instances_matching(FastRat, "creator", null)) creator = noone;
                                instance_destroy();
                                with(instances_matching(FastRat, "creator", null)) creator = _self;
                            }
                            break;

                        case MeleeBandit:
                        case JungleAssassin:    /// Overwrite Movement
                            if(walk > 0){
                                other.walk = walk;
                                walk = 0;
                            }
                            if(other.walk > 0){
                                other.walk -= current_time_scale;

                                motion_add(direction, 2);
                                if(instance_exists(other.target)){
                                    var s = ((object_index == JungleAssassin) ? 1 : 2);
                                    mp_potential_step(other.target.x, other.target.y, s, false);
                                }
                            }

                             // Max Speed:
                            var m = ((object_index == JungleAssassin) ? 4 : 3);
                            if(speed > m) speed = m;
                            break;

                        case Sniper:            /// Aim at Target
                            if(other.alarm[2] > 5 && in_sight(other.target)){
                                gunangle = point_direction(x, y, other.target.x, other.target.y);
                            }
                            break;

                        case ScrapBoss:         /// Override Movement
                            if(walk > 0){
                                other.walk = walk;
                                walk = 0;
                            }
                            if(other.walk > 0){
                                other.walk -= current_time_scale;

                                motion_add(direction, 0.5);
                                if(instance_exists(other.target)){
                                    motion_add(point_direction(x, y, other.target.x, other.target.y), 0.5);
                                }

                                if(round(other.walk / 10) == other.walk / 10) sound_play(sndBigDogWalk);

                                 // Animate:
                                if(other.walk <= 0) sprite_index = spr_idle;
                                else sprite_index = spr_walk;
                            }
                            break;

                        case ScrapBossMissile:  /// Don't Move Towards Player
                            if(sprite_index != spr_hurt){
                                if(instance_exists(Player)){
                                    var n = instance_nearest(x, y, Player);
                                    motion_add(point_direction(n.x, n.y, x, y), 0.1);
                                }
                                if(instance_exists(other.target)){
                                    motion_add(point_direction(x, y, other.target.x, other.target.y), 0.1);
                                }
                                speed = 2;
                                x = xprevious + hspeed;
                                y = yprevious + vspeed;
                            }
                            break;

                        case LaserCrystal:
                        case InvLaserCrystal:   /// Charge Particles
                            if(other.alarm[2] > 8 && current_frame_active){
                                with(instance_create(x + orandom(48), y + orandom(48), LaserCharge)){
                                    motion_add(point_direction(x, y, other.x, other.y), 2 + random(1));
                                    alarm0 = (point_distance(x, y, other.x, other.y) / speed) + 1;
                                }
                            }
                        case LightningCrystal:  /// Don't Move While Charging
                            if(other.alarm[2] > 0) speed = 0;
                            break;

                        case LilHunterFly:      /// Land on Enemies
                            if(sprite_index == sprLilHunterLand && z < -160){
                                if(instance_exists(other.target)){
                                    x = other.target.x;
                                    y = other.target.y;
                                }
                            }
                            break;

                        case ExploFreak:
                        case RhinoFreak:        /// Don't Move Towards Player
                            if(instance_exists(Player)){
                                x -= lengthdir_x(1, direction);
                                y -= lengthdir_y(1, direction);
                            }
                            if(instance_exists(other.target)){
                                mp_potential_step(other.target.x, other.target.y, 1, false);
                            }
                            break;

                        case Necromancer:       /// Charm Revived Freaks
                            with(instances_matching_le(instances_matching(ReviveArea, "creator", _self), "alarm0", 1)){
                                if(place_meeting(x, y, Corpse)) with(Corpse){
                                    if(place_meeting(x, y, other) && size < 3){
                                        with(instance_create(x, y, Freak)) creator = _self;

                                         // Effects:
                                        instance_create(x, y, ReviveFX);
                                        sound_play(sndNecromancerRevive);

                                        instance_destroy();
                                    }
                                }
                                instance_destroy();
                            }
                            break;

                        case TechnoMancer:      /// Charm Revived Necromancers
                            with(instances_matching_le(instances_matching(NecroReviveArea, "creator", _self), "alarm0", 1)){
                                if(place_meeting(x, y, Corpse)) with(instance_nearest(x, y, Corpse)){
                                    if(place_meeting(x, y, other) && size < 3){
                                        with(instance_create(x, y, Necromancer)) creator = _self;

                                         // Effects:
                                        with(instance_create(x, y, ReviveFX)) sprite_index = sprNecroRevive;
                                        sound_play(sndNecromancerRevive);

                                        instance_destroy();
                                    }
                                }
                                instance_destroy();
                            }
                            break;

                        case Shielder:
                        case EliteShielder:     /// Fix Shield Team
                            with(instances_matching(PopoShield, "creator", id)) team = other.team;
                            break;

						case Inspector:
						case EliteInspector:	/// Fix Telekinesis Pull
							if("charm_control_last" in self && charm_control_last){
								var _pull = (1 + (object_index == EliteInspector));
								with(instances_matching(Player, "team", team)){
									if(point_distance(x, y, xprevious, yprevious) <= speed + _pull + 1){
										if(point_distance(other.xprevious, other.yprevious, xprevious, yprevious) < 160){
											if(!place_meeting(xprevious + hspeed, yprevious + vspeed, Wall)){
												x = xprevious + hspeed;
												y = yprevious + vspeed;
											}
										}
									}
								}
							}
							charm_control_last = control;
							break;

                        case EnemyHorror:       /// Don't Shoot Beam at Player
                            if(instance_exists(other.target)){
                                gunangle = point_direction(x, y, other.target.x, other.target.y);
                            }
                            with(instances_matching(instances_matching(projectile, "creator", _self), "charmed_horror", null)){
                                charmed_horror = true;
                                x -= hspeed;
                                y -= vspeed;
                                direction = other.gunangle;
                                image_angle = direction;
                                x += hspeed;
                                y += vspeed;
                            }
                            break;

                        case InvSpider:         /// Charm Split Spiders
                            if(my_health <= 0){
                                with(instances_matching(InvSpider, "creator", null)) creator = noone;
                                instance_destroy();
                                with(instances_matching(InvSpider, "creator", null)) creator = _self;
                            }
                            break;

                        case FiredMaggot:       /// Charm Dropped Maggot
                            if(my_health <= 0 || place_meeting(x + hspeed, y + vspeed, Wall)){
                                with(instances_matching(Maggot, "creator", null)) creator = noone;
                                instance_destroy();
                                with(instances_matching(Maggot, "creator", null)) creator = _self;
                            }
                            break;
                    }
                }

                 // Charm Timer:
                if(instance_exists(_self) && time > 0){
                    time -= current_time_scale;
                    if(time <= 0) scrCharm(_self, false);
                }
            }
        }

         // Charm Spawned Enemies:
        with(instances_matching(instances_matching(hitme, "creator", _self), "charm", null)){
            scrCharm(id, true).index = _index;
            repeat(max(_time / 90, 1)) with(obj_create(x + orandom(24), y + orandom(24), "ParrotFeather")){
                target = other;
            	index = _index;
            }
        }
    }

    for(var i = 0; i < lq_size(_charmDraw); i++){
    	var p = lq_get_value(_charmDraw, i);
        script_bind_draw(charm_draw, p.depth - 0.1, p.inst, real(lq_get_key(_charmDraw, i)));
    }

#define charm_draw(_inst, _index)
	if(_index < 0 || _index >= maxp){
		_index = player_find_local_nonsync();
	}

     // Surface Setup:
    var _surf = surfCharm,
        _surfw = game_width,
        _surfh = game_height,
        _surfx = view_xview_nonsync,
        _surfy = view_yview_nonsync,
        _cts = current_time_scale;

    if(!surface_exists(_surf)){
        _surf = surface_create(_surfw, _surfh)
        surfCharm = _surf;
    }

     // Draw Charmed Enemies to Surface:
    current_time_scale = 0.00001;
    surface_set_target(_surf);
    draw_clear_alpha(0, 0);
    try{
	    with(instances_seen(instances_matching_ne(_inst, "sprite_index", sprSuperFireBallerFire, sprFireBallerFire), 24)){
	        /*var _x = x - _surfx,
	            _y = y - _surfy,
	            _spr = sprite_index,
	            _img = image_index;
	
	        if(object_index == TechnoMancer){ // JW help me
	            _spr = drawspr;
	            _img = drawimg;
	            if(_spr == sprTechnoMancerAppear || _spr == sprTechnoMancerFire1 || _spr == sprTechnoMancerFire2 || _spr == sprTechnoMancerDisappear){
	                texture_set_stage(0, sprite_get_texture(sprTechnoMancerActivate, 8));
	                draw_sprite_ext(sprTechnoMancerActivate, 8, _x, _y, image_xscale * (("right" in self) ? right : 1), image_yscale, image_angle, image_blend, image_alpha);
	            }
	        }
	
	        draw_sprite_ext(_spr, _img, _x, _y, image_xscale * (("right" in self) ? right : 1), image_yscale, image_angle, image_blend, image_alpha);*/

			var _x = x,
				_y = y;
	
	    	x -= _surfx;
	    	y -= _surfy;

			switch(object_index){ // literally laser sight exceptions
				case SnowTank:
				case GoldSnowTank:
					var a = ammo;
					ammo = 0;
			        event_perform(ev_draw, 0);
					ammo = a;
					break;

				case Sniper:
					var g = gonnafire;
					gonnafire = false;
			        event_perform(ev_draw, 0);
					gonnafire = g;
					break;

				case CustomEnemy:
					if("name" in self){
						switch(name){
							case "Diver":
								var c = canshoot;
								canshoot = false;
								event_perform(ev_draw, 0);
								canshoot = c;
								break;
	
							default:
						        event_perform(ev_draw, 0);
						}
						break;
					}

				default:
			        event_perform(ev_draw, 0);
			}

	        x = _x;
	        y = _y;
	    }
    }
    catch(_error){
    	trace_error(_error);
    }
    surface_reset_target();
    current_time_scale = _cts;

     // Outlines:
    var _option = lq_defget(opt, "outlineCharm", 2);
    if(_option > 0){
    	if(_option < 2 || player_get_outlines(_index)){
	        draw_set_flat(player_get_color(_index));
	        for(var a = 0; a <= 360; a += 90){
	            var _x = _surfx,
	                _y = _surfy;

	            if(a >= 360) draw_set_flat(-1);
	            else{
	                _x += dcos(a);
	                _y -= dsin(a);
	            }

	            draw_surface(_surf, _x, _y);
	        }
    	}
    }

     // Eye Shader:
    if(opt.allowShaders){
        if(global.eye_shader == -1){
            global.eye_shader = shader_create(
                "/// Vertex Shader ///

                struct VertexShaderInput
                {
                    float4 vPosition : POSITION;
                    float2 vTexcoord : TEXCOORD0;
                };

                struct VertexShaderOutput
                {
                    float4 vPosition : SV_POSITION;
                    float2 vTexcoord : TEXCOORD0;
                };

                uniform float4x4 matrix_world_view_projection;

                VertexShaderOutput main(VertexShaderInput INPUT)
                {
                    VertexShaderOutput OUT;

                    OUT.vPosition = mul(matrix_world_view_projection, INPUT.vPosition); // (x,y,z,w)
                    OUT.vTexcoord = INPUT.vTexcoord; // (x,y)

                    return OUT;
                }
                ",


                "/// Fragment/Pixel Shader ///

                struct PixelShaderInput
                {
                    float2 vTexcoord : TEXCOORD0;
                };

                sampler2D s0;

                float4 main(PixelShaderInput INPUT) : SV_TARGET
                {
                     // Break Down Pixel's Color:
                    float4 Color = tex2D(s0, INPUT.vTexcoord); // (r,g,b,a)
                    float R = round(Color.r * 255.0);
                    float G = round(Color.g * 255.0);
                    float B = round(Color.b * 255.0);

                    if(R > G && R > B){
                        if(
                            (R == 252.0 && G ==  56.0 && B ==  0.0) || // Standard enemy eye color
                            (R == 199.0 && G ==   0.0 && B ==  0.0) || // Freak eye color
                            (R ==  95.0 && G ==   0.0 && B ==  0.0) || // Freak eye color
                            (R == 163.0 && G ==   5.0 && B ==  5.0) || // Buff gator ammo
                            (R == 105.0 && G ==   3.0 && B ==  3.0) || // Buff gator ammo
                            (R == 255.0 && G == 164.0 && B == 15.0) || // Saladmander fire color
                            (R == 255.0 && G ==   0.0 && B ==  0.0) || // Wolf eye color
                            (R == 165.0 && G ==   9.0 && B == 43.0) || // Snowbot eye color
                            (R == 255.0 && G == 168.0 && B == 61.0) || // Snowbot eye color
                            (R == 194.0 && G ==  42.0 && B ==  0.0) || // Explo freak color
                            (R == 122.0 && G ==  27.0 && B ==  0.0) || // Explo freak color
                            (R == 156.0 && G ==  20.0 && B == 31.0) || // Turret eye color
                            (R == 255.0 && G == 134.0 && B == 47.0) || // Turret eye color
                            (R ==  99.0 && G ==   9.0 && B == 17.0) || // Turret color
                            (R == 112.0 && G ==   0.0 && B == 17.0) || // Necromancer eye color
                            (R == 210.0 && G ==  32.0 && B == 71.0) || // Jungle fly eye color
                            (R == 179.0 && G ==  27.0 && B == 60.0) || // Jungle fly eye color
                            (R == 255.0 && G == 160.0 && B == 35.0) || // Jungle fly eye/wing color
                            (R == 255.0 && G == 228.0 && B == 71.0)    // Jungle fly wing color
                        ){
                            return float4(G / 255.0, R / 255.0, B / 255.0, Color.a);
                        }
                    }

                     // Return Blank Pixel:
                    return float4(0.0, 0.0, 0.0, 0.0);
                }
            ");
        }

        shader_set_vertex_constant_f(0, matrix_multiply(matrix_multiply(matrix_get(matrix_world), matrix_get(matrix_view)), matrix_get(matrix_projection)));
        shader_set(EyeShader);
        texture_set_stage(0, surface_get_texture(_surf));

        draw_surface(_surf, _surfx, _surfy);

        shader_reset();
    }

    instance_destroy();

#define cleanup
    with(global.charm_step) instance_destroy();
    for(var i = 0; i < lq_size(global.current); i++){
        audio_stop_sound(lq_get_value(global.current, i).snd);
    }

	 // Uncharm yo:
	with(ds_list_to_array(global.charm)) scrCharm(instance, false);


/// Scripts
#define orandom(n)																		return  random_range(-n, n);
#define chance(_numer, _denom)															return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)														return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj);
#define draw_self_enemy()                                                                       mod_script_call(   "mod", "telib", "draw_self_enemy");
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call(   "mod", "telib", "draw_weapon", _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call(   "mod", "telib", "draw_lasersight", _x, _y, _dir, _maxDistance, _width);
#define draw_trapezoid(_x1a, _x2a, _y1, _x1b, _x2b, _y2)                                        mod_script_call_nc("mod", "telib", "draw_trapezoid", _x1a, _x2a, _y1, _x1b, _x2b, _y2);
#define scrWalk(_walk, _dir)                                                                    mod_script_call(   "mod", "telib", "scrWalk", _walk, _dir);
#define scrRight(_dir)                                                                          mod_script_call(   "mod", "telib", "scrRight", _dir);
#define scrEnemyShoot(_object, _dir, _spd)                                              return  mod_script_call(   "mod", "telib", "scrEnemyShoot", _object, _dir, _spd);
#define scrEnemyShootExt(_x, _y, _object, _dir, _spd)                                   return  mod_script_call(   "mod", "telib", "scrEnemyShootExt", _x, _y, _object, _dir, _spd);
#define enemyWalk(_spd, _max)                                                                   mod_script_call(   "mod", "telib", "enemyWalk", _spd, _max);
#define enemySprites()                                                                          mod_script_call(   "mod", "telib", "enemySprites");
#define enemyHurt(_hitdmg, _hitvel, _hitdir)                                                    mod_script_call(   "mod", "telib", "enemyHurt", _hitdmg, _hitvel, _hitdir);
#define scrDefaultDrop()                                                                        mod_script_call(   "mod", "telib", "scrDefaultDrop");
#define in_distance(_inst, _dis)			                                            return  mod_script_call(   "mod", "telib", "in_distance", _inst, _dis);
#define in_sight(_inst)																	return  mod_script_call(   "mod", "telib", "in_sight", _inst);
#define z_engine()                                                                              mod_script_call(   "mod", "telib", "z_engine");
#define scrCharm(_instance, _charm)                                                     return  mod_script_call_nc("mod", "telib", "scrCharm", _instance, _charm);
#define scrBossHP(_hp)                                                                  return  mod_script_call(   "mod", "telib", "scrBossHP", _hp);
#define scrTopDecal(_x, _y, _area)                                                      return  mod_script_call(   "mod", "telib", "scrTopDecal", _x, _y, _area);
#define scrWaterStreak(_x, _y, _dir, _spd)                                              return  mod_script_call(   "mod", "telib", "scrWaterStreak", _x, _y, _dir, _spd);
#define scrRadDrop(_x, _y, _raddrop, _dir, _spd)                                        return  mod_script_call(   "mod", "telib", "scrRadDrop", _x, _y, _raddrop, _dir, _spd);
#define scrCorpse(_dir, _spd)                                                           return  mod_script_call(   "mod", "telib", "scrCorpse", _dir, _spd);
#define scrSwap()                                                                       return  mod_script_call(   "mod", "telib", "scrSwap");
#define scrSetPet(_pet)                                                                 return  mod_script_call(   "mod", "telib", "scrSetPet", _pet);
#define scrPortalPoof()                                                                 return  mod_script_call(   "mod", "telib", "scrPortalPoof");
#define scrPickupPortalize()                                                            return  mod_script_call(   "mod", "telib", "scrPickupPortalize");
#define floor_ext(_num, _round)                                                         return  mod_script_call(   "mod", "telib", "floor_ext", _num, _round);
#define array_count(_array, _value)                                                     return  mod_script_call(   "mod", "telib", "array_count", _array, _value);
#define array_flip(_array)                                                              return  mod_script_call(   "mod", "telib", "array_flip", _array);
#define instances_named(_object, _name)                                                 return  mod_script_call(   "mod", "telib", "instances_named", _object, _name);
#define nearest_instance(_x, _y, _instances)                                            return  mod_script_call(   "mod", "telib", "nearest_instance", _x, _y, _instances);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc("mod", "telib", "instance_rectangle", _x1, _y1, _x2, _y2, _obj);
#define instances_seen(_obj, _ext)                                                      return  mod_script_call(   "mod", "telib", "instances_seen", _obj, _ext);
#define instance_random(_obj)                                                           return  mod_script_call(   "mod", "telib", "instance_random", _obj);
#define frame_active(_interval)                                                         return  mod_script_call(   "mod", "telib", "frame_active", _interval);
#define area_generate(_x, _y, _area)                                                    return  mod_script_call(   "mod", "telib", "area_generate", _x, _y, _area);
#define scrFloorWalls()                                                                 return  mod_script_call(   "mod", "telib", "scrFloorWalls");
#define floor_reveal(_floors, _maxTime)                                                 return  mod_script_call(   "mod", "telib", "floor_reveal", _floors, _maxTime);
#define area_border(_y, _area, _color)                                                  return  mod_script_call(   "mod", "telib", "area_border", _y, _area, _color);
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call(   "mod", "telib", "area_get_sprite", _area, _spr);
#define floor_at(_x, _y)                                                                return  mod_script_call(   "mod", "telib", "floor_at", _x, _y);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   "mod", "telib", "lightning_connect", _x1, _y1, _x2, _y2, _arc, _enemy);
#define scrLightning(_x1, _y1, _x2, _y2, _enemy)                                        return  mod_script_call(   "mod", "telib", "scrLightning", _x1, _y1, _x2, _y2, _enemy);
#define in_range(_num, _lower, _upper)                                                  return  mod_script_call(   "mod", "telib", "in_range", _num, _lower, _upper);
#define wep_get(_wep)                                                                   return  mod_script_call(   "mod", "telib", "wep_get", _wep);
#define decide_wep_gold(_minhard, _maxhard, _nowep)                                     return  mod_script_call(   "mod", "telib", "decide_wep_gold", _minhard, _maxhard, _nowep);
#define path_create(_xstart, _ystart, _xtarget, _ytarget)                               return  mod_script_call(   "mod", "telib", "path_create", _xstart, _ystart, _xtarget, _ytarget);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call(   "mod", "telib", "race_get_sprite", _race, _sprite);
#define scrFloorMake(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "scrFloorMake", _x, _y, _obj);
#define scrFloorFill(_x, _y, _w, _h)                                                    return  mod_script_call(   "mod", "telib", "scrFloorFill", _x, _y, _w, _h);
#define scrFloorFillRound(_x, _y, _w, _h)                                               return  mod_script_call(   "mod", "telib", "scrFloorFillRound", _x, _y, _w, _h);
#define unlock_get(_unlock)                                                             return  mod_script_call(   "mod", "telib", "unlock_get", _unlock);
#define unlock_set(_unlock, _value)                                                             mod_script_call(   "mod", "telib", "unlock_set", _unlock, _value);
#define area_get_subarea(_area)                                                         return  mod_script_call(   "mod", "telib", "area_get_subarea", _area);
#define trace_lag()                                                                             mod_script_call(   "mod", "telib", "trace_lag");
#define trace_lag_bgn(_name)                                                                    mod_script_call(   "mod", "telib", "trace_lag_bgn", _name);
#define trace_lag_end(_name)                                                                    mod_script_call(   "mod", "telib", "trace_lag_end", _name);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call(   "mod", "telib", "instance_rectangle_bbox", _x1, _y1, _x2, _y2, _obj);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   "mod", "telib", "instances_meeting", _x, _y, _obj);
#define array_delete(_array, _index)                                                    return  mod_script_call(   "mod", "telib", "array_delete", _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call(   "mod", "telib", "array_delete_value", _array, _value);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "instances_at", _x, _y, _obj);
#define Pet_spawn(_x, _y, _name)                                                        return  mod_script_call(   "mod", "telib", "Pet_spawn", _x, _y, _name);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc("mod", "telib", "scrFX", _x, _y, _motion, _obj);
#define array_combine(_array1, _array2)                                                 return  mod_script_call(   "mod", "telib", "array_combine", _array1, _array2);
#define player_create(_x, _y, _index)                                                   return  mod_script_call(   "mod", "telib", "player_create", _x, _y, _index);
#define draw_set_flat(_color)                                                                   mod_script_call(   "mod", "telib", "draw_set_flat", _color);
#define trace_error(_error)                                                                     mod_script_call_nc("mod", "telib", "trace_error", _error);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc("mod", "telib", "sleep_max", _milliseconds);