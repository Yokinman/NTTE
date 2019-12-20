#define chat_command(_cmd, _arg, _ind)
    if(string_upper(_cmd) == "NTTE"){
		NTTEMenu.open = !NTTEMenu.open;
		return true;
    }

#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.sav = mod_variable_get("mod", "teassets", "sav");

	global.area = mod_variable_get("mod", "teassets", "area");
	global.race = mod_variable_get("mod", "teassets", "race");
	global.crwn = mod_variable_get("mod", "teassets", "crwn");
	global.weps = mod_variable_get("mod", "teassets", "weps");

    global.debug_lag = false;

	 // level_start():
    global.newLevel = instance_exists(GenCont);

	 // Area Stuff:
	global.setup_floor_num = 0;
    global.effect_timer = 0;

	 // Map:
	global.mapAreaCheck = false;
	global.mapArea = [];

	 // Fix for custom music/ambience:
	global.musTrans = false;
    global.sound_current = {
        mus : { snd: -1, vol: 1, pos: 0, hold: mus.Placeholder },
        amb : { snd: -1, vol: 1, pos: 0, hold: mus.amb.Placeholder }
    };

	 // HUD Surface, for Pause Screen:
	global.surfMainHUD = surflist_set("MainHUD", 0, 0, game_width, game_height);

	 // Loadout Crown System:
    global.loadout_crown = {
        size : [],
        race : {},
        camp : crwn_none
    }
    global.clock_fix = false;
    if(instance_exists(LoadoutCrown)){
	    with(loadbutton) instance_destroy();
	    with(Loadout) selected = false;
    }
    global.surfCrownHide	   = surflist_set("CrownHide",		 0, 0, 32, 32);
    global.surfCrownHideScreen = surflist_set("CrownHideScreen", 0, 0, game_width, game_height);

	/// NTTE Menus:
		global.menu = {
			"open"			: false,
			"slct"			: array_create(maxp, menu_base),
			"pop"			: array_create(maxp, 0),
			"splat"			: 0,
			"splat_blink"	: 0,
			"splat_options"	: 0,
			
			"list" : {
				"options" : {
					"x" : 0,
					"y" : -64,
					"slct" : array_create(maxp, -1),
					"list" : [
						{	name : "Use Shaders",
							type : opt_toggle,
							text : "Used for certain visuals#@sShaders may cause the game# to @rcrash @son certain systems!",
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
						{	name : "Wading",
							type : opt_slider,
							text : "Objects in the water",
							sync : false,
							varname : "waterQualityTop"
							},
						{	name : "Main",
							type : opt_slider,
							text : "Water foam,#underwater visuals,#etc.",
							sync : false,
							varname : "waterQualityMain"
							}
					]
				},
				
				"stats" : {
					"slct" : array_create(maxp, 0),
					"list" : {
						"mutants" : {
							"x" : 56,
							"y" : -48,
							"slct" : array_create(maxp, 0),
							"list" : {/*Filled in Later*/}
						},
						
						"pets" : {
							"x" : 56,
							"y" : -16,
							"slct" : array_create(maxp, ""),
							"list" : [ // Pets that show up by default
								"Scorpion"		+ ".petlib.mod",
								"Parrot"		+ ".petlib.mod",
								"CoolGuy"		+ ".petlib.mod",
								"Salamander"	+ ".petlib.mod",
								"Mimic"			+ ".petlib.mod",
								"Slaughter"		+ ".petlib.mod",
								"Octo"			+ ".petlib.mod",
								"Spider"		+ ".petlib.mod",
								"Prism"			+ ".petlib.mod",
								"Weapon"		+ ".petlib.mod",
								"Orchid"		+ ".petlib.mod"
							]
						},
						
						"other" : {
							"slct" : array_create(maxp, 0),
							"list" : [
								{	name : "AREA UNLOCKS",
									list : [
										["coastWep",	["harpoon launcher.wep", "net launcher.wep", "clam shield.wep", "trident.wep"]],
										["oasisWep",	["bubble rifle.wep", "bubble shotgun.wep", "bubble minigun.wep", "bubble cannon.wep", "hyper bubbler.wep"]],
										["trenchWep",	["lightring launcher.wep", "super lightring launcher.wep", "tesla coil.wep", "electroplasma rifle.wep", "electroplasma shotgun.wep", "quasar blaster.wep", "quasar rifle.wep", "quasar cannon.wep"]],
										["lairWep",		["bat disc launcher.wep", "bat disc cannon.wep"]],
										["lairCrown",	["crime.crown"]]
										]
									},
								{	name : "MISC",
									list : [
										["Time",  "time", stat_time],
										["Bones", "bone", stat_base]
										]
									}
							]
						}
					}
				},
				
				"credits" : {
					"x" : 0,
					"y" : -79,
					"slct" : array_create(maxp, false),
					"list" : [
						{	name : "Yokin",
							role : [[cred_coder, "Lead Programmer"]],
							link : [[cred_twitter, "Yokinman"], [cred_discord, "Yokin\#1322"]]
							},
						{	name : "THX",
							role : [[cred_artist, "Sprite Artist"]],
							link : [[cred_twitter, "thxsprites"], [cred_discord, "THX\#0011"]]
							}
						{	name : "smash brothers",
							role : [[cred_artist, "Sprite Artist"], [cred_coder, "Programmer"]],
							link : [[cred_twitter, "attfooy"], [cred_discord, "smash brothers\#5026"]]
							},
						{	name : "peas",
							role : [[cred_artist, "Sprite Artist"]],
							link : [[cred_twitter, "realestpeas"], [cred_discord, "peas\#8304"]]
							},
						{	name : "jsburg",
							role : [[cred_coder, "Programmer?"]],
							link : [[cred_itchio, "jsburg"], [cred_discord, "Jsburg\#1045"]]
							},
						{	name : "karmelyth",
							role : [[cred_artist, "Weapon Sprites"], [cred_coder, "Weapon Programming"]],
							link : [[cred_twitter, "karmelyth"], [cred_discord, "Karmelyth\#7168"]]
							},
						{	name : "Mista Jub",
							role : [[cred_music, "Music"]],
							link : [[cred_twitter, "JDubbsishere"], [cred_soundcloud, "jdubmmusic"], [cred_discord, "Mista Jub\#8521"]]
							},
						{	name : "BioOnPC",
							role : [[cred_music, "Sound Design"], [cred_coder, "Programmer"], "Trailer"],
							link : [[cred_twitter, "HitregOnPC"], [cred_discord, "BioOnPC\#6521"]]
							},
						{	name : "Special Thanks",
							role : [[cred_yellow, "blaac"], "Bub", "Emffles", "minichibis"],
							link : [[cred_twitter + cred_yellow, "blaac_"], [cred_twitter, "Bubonto"], [cred_twitter, "EmfflesTWO"], [cred_twitter, "minichibisart"]]
							}
					]
				}
			}
		}
		
		 // Menu Defaulterize:
		for(var i = 0; i < lq_size(MenuList); i++){
			var o = lq_get_value(MenuList, i);
			if("slct" in o && array_length(o.slct) > 0){
				if("slct_default" not in o){
					o.slct_default = o.slct[0];
				}
			}
		}
		with(MenuList.options.list){
			if("name" not in self) name = "";
			if("type" not in self) type = opt_title;
			if("pick" not in self){
	        	switch(type){
	        		case opt_toggle:	pick = ["OFF", "ON"];	break;
	        		case opt_slider:	pick = [0, 1];			break;
	        		default:			pick = [];				break;
	        	}
	        }
			if("sync" not in self) sync = true;
			if("splat" not in self) splat = 0;
			if("varname" not in self) varname = name;
			if("clicked" not in self) clicked = array_create(maxp, false);
			if(type >= 0 && varname not in sav.option){
	            option_set(varname, 0);
	        }
		}
		with(MenuList.credits.list){
			if("name" not in self) name = "";
			if("role" not in self) role = [];
			if("link" not in self) link = [];
			
			if(!is_array(role)) role = [role];
			for(var i = 0; i < array_length(role); i++){
				if(!is_array(role[i])) role[i] = [role[i]];
			}
			
			if(!is_array(link)) link = [link];
			for(var i = 0; i < array_length(link); i++){
				if(!is_array(link[i])) link[i] = [link[i]];
			}
			if(array_length(link) >= 4){
				with(link){
					for(var i = 0; i < array_length(self); i++){
						self[@i] = string_replace(self[i], "Twitter: ", "@@");
					}
				}
			}
		}
		
		 // Race Stats:
		with(raceList){
			var _race = self,
				_path = "race/" + _race + "/",
				_stat = [
					{	name : "",
						list : [
							["Kills",	_path + "kill", stat_base],
							["Loops",	_path + "loop", stat_base],
							["Runs",	_path + "runs", stat_base],
							["Deaths",	_path + "lost", stat_base],
							["Wins",	_path + "wins", stat_base],
							["Time",	_path + "time", stat_time]
							]
						},
					{	name : "Best Run",
						list : [
							["Area",	_path + "bestArea",	stat_base],
							["Kills",	_path + "bestKill", stat_base]
							]
						}
				];
				
			switch(_race){
				case "parrot":
					array_push(_stat[0].list, ["Charmed", _path + "spec", stat_base]);
					break;
			}
			
			lq_set(MenuList.stats.list.mutants.list, _race, _stat);
		}
		
		global.mouse_x_previous = array_create(maxp);
		global.mouse_y_previous = array_create(maxp);
	
	 // Pets:
	global.pet_max = 1;
	global.petMapicon = array_create(maxp, []);
	global.petMapiconPause = 0;
	global.petMapiconPauseForce = 0;

	 // For Merged Weapon PopupText Fix:
	global.wepMergeName = [];

	 // Kills:
	global.killsLast = GameCont.kills;
    
     // Scythe Tippage:
    global.sPromptIndex = 0;
    global.scythePrompt = ["press @we @sto change modes", "the @rscythe @scan do so much more", "press @we @sto rearrange a few @rbones", "just press @we @salready", "please press @we", "@w@qe"];

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro areaList global.area
#macro raceList global.race
#macro crwnList global.crwn
#macro wepsList global.weps

#macro DebugLag global.debug_lag

#macro surfCrownHide		global.surfCrownHide
#macro surfCrownHideScreen	global.surfCrownHideScreen
#macro surfMainHUD			global.surfMainHUD

#macro cMusic	 global.sound_current.mus
#macro cAmbience global.sound_current.amb

#macro NTTEMenu			global.menu
#macro MenuOpen			NTTEMenu.open
#macro MenuSlct			NTTEMenu.slct
#macro MenuPop			NTTEMenu.pop
#macro MenuList			NTTEMenu.list
#macro MenuSplat		NTTEMenu.splat
#macro MenuSplatBlink	NTTEMenu.splat_blink
#macro MenuSplatOptions	NTTEMenu.splat_options

#macro menu_options	0
#macro menu_stats	1
#macro menu_credits	2
#macro menu_base	menu_options

#macro opt_title -1
#macro opt_toggle 0
#macro opt_slider 1

#macro stat_base	0
#macro stat_time	1
#macro stat_display	2

#macro cred_artist		`@(color:${make_color_rgb(30, 160, 240)})`
#macro cred_coder		`@(color:${make_color_rgb(250, 170, 0)})`
#macro cred_music		`@(color:${make_color_rgb(255, 60, 0)})`
#macro cred_twitter		cred_artist	+ "Twitter: @w"
#macro cred_itchio		cred_coder	+ "Itch.io: @w"
#macro cred_soundcloud	cred_music	+ "Soundcloud: @w"
#macro cred_discord		`@(color:${make_color_rgb(160, 70, 200)})Discord: @w`
#macro cred_yellow		"@y"

#macro crownPlayer	player_find_local_nonsync()
#macro crownSize	global.loadout_crown.size
#macro crownRace	global.loadout_crown.race
#macro crownCamp	global.loadout_crown.camp
#macro crownIconW	28
#macro crownIconH	28
#macro crownPath	"crownCompare/"
#macro crownPathD	""
#macro crownPathA	"A"
#macro crownPathB	"B"


#define game_start
	 // Reset:
	global.pet_max = 1;
    for(var i = 0; i < array_length(global.petMapicon); i++){
    	global.petMapicon[i] = [];
    }
    global.mapArea = [];
	global.killsLast = GameCont.kills;
    with(instances_matching(CustomObject, "name", "UnlockCont")) instance_destroy();
	
	 // Reset Haste Hands:
    if(global.clock_fix){
    	global.clock_fix = false;
    	sprite_restore(sprClockParts);
    }
    
     // Special Loadout Crown Selected:
    var p = crownPlayer,
        _crown = lq_get(crownRace, player_get_race_fix(p)),
        _crownPoints = GameCont.crownpoints;
        
    if(!is_undefined(_crown)){
    	if(_crown.custom.slct != -1 && crown_current == _crown.slct && _crown.custom.slct != _crown.slct){
	    	switch(_crown.custom.slct){
	        	case crwn_random:
	        		 // Get Unlocked Crowns:
	        		var _list = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
	        		with(_crown.icon) if(locked){
	        			_list = array_delete_value(_list, crwn);
	        		}

					 // Add Modded Crowns:
					var _scrt = "crown_menu_avail";
	        		with(mod_get_names("crown")){
	        			if(!mod_script_exists("crown", self, _scrt) || mod_script_call("crown", self, _scrt)){
	        				array_push(_list, self);
	        			}
	        		}

					 // Pick Random Crown:
		            var m = ((array_length(_list) > 0) ? _list[irandom(array_length(_list) - 1)] : crwn_none);
		            if(m != crown_current){
		                crown_current = m;

		                 // Destiny Fix:
		                if(crown_current == crwn_destiny){
		                    GameCont.skillpoints--;
		                }
		            }
		            break;

	        	default:
	        		crown_current = _crown.custom.slct;
	        }

	         // Death Fix:
	        if(_crown.slct == crwn_death){
	            with(Player) my_health = maxhealth;
	        }
    	}
    }
    GameCont.crownpoints = _crownPoints;
    
     // Race Runs Stat:
    for(var i = 0; i < maxp; i++){
    	var _race = player_get_race(i);
    	if(array_exists(raceList, _race)){
			var _stat = "race/" + _race + "/runs";
			stat_set(_stat, stat_get(_stat) + 1);
    	}
    }
    
     // Yeah:
    global.sPromptIndex = 0;

#define level_start // game_start but every level
	var	_spawnx = 10016,
		_spawny = 10016,
		_validArea = (GameCont.hard > 1 && instance_number(enemy) > array_length(instances_matching(CustomEnemy, "name", "PortalPrevent"))),
		_topChance = 1/100,
		_topSpawn = [];
		
	with(Player){
		_spawnx = x;
		_spawny = y;
	}
    
     // Wepmimic Arena:
    if(_validArea && (chance(GameCont.nochest - 4, 4) || chance(1, 100))){
    	with(instance_furthest(_spawnx, _spawny, WeaponChest)){
	    	with(obj_create(x, y, "PetWeaponBecome")){
	    		switch(type){
	    			case 2:
	    				floor_fill(x, y, 5, 1);
	    				floor_fill(x, y, 1, 5);
	    				break;
	    				
	    			case 3:
	    				floor_fill(x, y, 5, 5);
	    				
	    				 // Cover Zones:
	    				if(fork()){
	    					wait 0;
		    				for(var	_x = x - 32; _x <= x + 32; _x += 64){
		    					for(var	_y = y - 32; _y <= y + 32; _y += 64){
		    						var _cover = true;
		    						with(instances_at(_x, _y, instances_matching_ne(Floor, "mask_index", mskFloor))){
			    						if(place_meeting(x, y, hitme) || place_meeting(x, y, chestprop)){
			    							_cover = false;
			    						}
		    						}
		    						if(_cover){
		    							floor_set(_x, _y, false);
		    						}
		    					}
		    				}
		    				exit;
	    				}
	    				break;
	    				
	    			default:
	    				floor_fill_round(x, y, 5, 5);
	    		}
	    	}
	    	instance_delete(id);
    	}
    }
    
     // Area-Specific:
    switch(GameCont.area){
    	case 0: /// CAMPFIRE
		
			 // Unlock Custom Crowns:
			if(array_exists(crwnList, crown_current)){
				unlock_call("crown" + string_upper(string_char_at(crown_current, 1)) + string_delete(crown_current, 1, 1));
			}
			
			 // Less Bones:
			with(BonePileNight) if(chance(1, 3)) instance_delete(id);
			
			 // Top Spawns:
			_topSpawn = [
				[NightCactus,	1],
				[BonePileNight,	1/2]
			];
			
			break;
			
        case 1: /// DESERT
        
             // Disable Oasis Skip:
			with(instance_create(0, 0, chestprop)){
				visible = false;
					mask_index = mskNone;
			}
			
			 // Big Nests:
			with(MaggotSpawn) if(chance(1 + GameCont.loops, 12)){
				obj_create(x, y, "BigMaggotSpawn");
				instance_delete(id);
			}
			
			 // Find Prop-Spawnable Floors:
    	    var _spawnFloor = [],
    	    	_spawnIndex = -1;

			with(Floor){
				var _x = (bbox_left + bbox_right + 1) / 2,
					_y = (bbox_top + bbox_bottom + 1) / 2;
					
				if(point_distance(_x, _y, _spawnx, _spawny) > 48){
					if(array_length(instances_meeting(x, y, [prop, chestprop, Wall, MaggotSpawn])) <= 0){
						array_push(_spawnFloor, {
							inst : id,
							cenx : _x,
							ceny : _y
						});
						_spawnIndex++;
					}
				}
			}
			array_shuffle(_spawnFloor);

    	     // Sharky Skull:
    		with(BigSkull) instance_delete(id);
    		if(GameCont.subarea == 3){
				var _sx = _spawnx,
    				_sy = _spawny;
    				
			    if(_spawnIndex >= 0) with(_spawnFloor[_spawnIndex--]){
	                _sx = cenx;
	                _sy = ceny;
			    }

    			obj_create(_sx, _sy, "CoastBossBecome");
    		}

             // Consistently Spawn Crab Skeletons:
            if(!instance_exists(BonePile)){
			    if(_spawnIndex >= 0) with(_spawnFloor[_spawnIndex--]){
	                obj_create(cenx, ceny, BonePile);
			    }
            }

             // Spawn scorpion rocks occasionally:
            if(chance(3, 5)){
			    if(_spawnIndex >= 0) with(_spawnFloor[_spawnIndex--]){
                    with(obj_create(cenx, ceny - 2, "ScorpionRock")){
                		 // This part is irrelevant don't worry:
		                var _friendChance = 0;
		                with(instances_matching_le(Player, "my_health", 3)){
		                	if(my_health < maxhealth || my_health <= 1){
		                    	if(_friendChance <= 0 || my_health <= _friendChance) _friendChance = my_health;
		                	}
		                }
                    	if(_friendChance > 0) friendly = chance(1, _friendChance);
                    }
			    }
		    }
		    
			 // Maggot Park:
        	if(GameCont.subarea > 1 || GameCont.loops > 0){
				with(instances_matching([RadChest, RadMaggotChest], "", null)) if(instance_exists(self)){
					if(distance_to_object(Player) > 196){
						if(chance(1, 60 + (20 * (object_index != RadMaggotChest)))){
							var _sx = x + (irandom_range(-2, 2) * 32),
								_sy = y + (irandom_range(-2, 2) * 32),
								_ang = random(360),
								_copy = {};
								
							 // Copy Origin Floor's Vars:
							with(instance_nearest_array(_sx - 16, _sy - 16, instances_matching_ne(Floor, "object_index", FloorExplo))){
								_copy.sprite_index = sprite_index;
								_copy.depth        = depth;
								_copy.material     = material;
								_copy.traction     = traction;
								_copy.styleb       = styleb;
								_copy.area         = area;
							}
							
							 // Delete RadChest:
							instance_delete(id);
							
							 // Generate Area:
							var _minID = GameObject.id;
							for(var d = _ang; d < _ang + 360; d += (360 / 8)){
								var l = 0;
								repeat(4 + GameCont.loops){
									floor_fill(_sx + lengthdir_x(l, d), _sy + lengthdir_y(l, d), 3, 3);
									l += random_range(8, 24);
								}
							}
							var _floors = instances_matching_gt(Floor, "id", _minID);
							
							 // Setup:
							with(_floors){
								for(var i = 0; i < lq_size(_copy); i++){
									variable_instance_set(id, lq_get_key(_copy, i), lq_get_value(_copy, i));
								}
								
								 // Cut Corners:
								if(chance(1, 3)){
									with(instance_create(x + 16, y + 16, PortalClear)){
										mask_index = mskPlasmaImpact;
									}
								}
							}
							
							 // Nests:
							var _ang = random(360),
								_num = 2 + GameCont.loops;
								
							for(var d = _ang; d < _ang + 360; d += (360 / _num)){
								var l = 12 + (random_range(4, 12) * _num);
								obj_create(round(_sx + lengthdir_x(l, d)), round(_sy + lengthdir_y(l, d)), "BigMaggotSpawn");
							}
							with(_floors){
								if(!place_meeting(x, y, enemy)){
									if(chance(2, 3)){
										with(instance_create(x + 16, y + 16, MaggotSpawn)){
											x = xstart;
											y = ystart;
											move_contact_solid(random(360), random(16));
											instance_create(x, y, Maggot);
										}
									}
								}
								else with(instances_meeting(x, y, instances_matching_ne(enemy, "object_index", MaggotSpawn, CustomEnemy, Maggot))){
									if(chance(2, 3)){
										if(!place_meeting(x, y, BigMaggot) && !place_meeting(x, y, JungleFly)){
											if(GameCont.loops > 0 && chance(1, 2)){
												instance_create(x, y, JungleFly);
											}
											else instance_create(x, y, BigMaggot);
										}
									}
								}
							}
							
							 // Sound:
							sound_play_pitchvol(sndBigMaggotBite, 0.4 + random(0.1), 1.5);
							sound_play_pitchvol(sndBigMaggotBurrow, 0.6, 2);
							sound_play_pitchvol(sndBigMaggotUnburrow, 0.6, 3);
							sound_volume(sound_loop(sndMaggotSpawnIdle), 0.4);
						}
					}
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

             // Scorpion Desert:
            var _eventScorp = false;
            if(GameCont.subarea > 1 || GameCont.loops > 0){
            	if(chance(1, 80) || (chance(1, 40) && array_length(instances_matching(instances_matching(CustomHitme, "name", "Pet"), "pet", "Scorpion")) > 0)){
            		_eventScorp = true;
            		
	                with(instances_matching_lt(instances_matching_ge(enemy, "size", 1), "size", 4)) if(chance(1, 2)){
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
	                with(instances_matching(CustomEnemy, "name", "BigMaggotSpawn")){
	                	if(chance(1, 2)) scorp_drop++;
	                }
	                with(Cactus) if(chance(1, 2)){
	                	obj_create(x, y, "BigCactus");
	                	instance_delete(id);
	                }
	                
	                 // Scary sound:
	                sound_play_pitchvol(sndGoldTankShoot, 1, 0.6);
	                sound_play_pitchvol(sndGoldScorpionFire, 0.8, 1.4);
	            }
            }
            
			 // Bandit Camp:
			if((GameCont.subarea = 3 || GameCont.loops > 0) && chance(1, 10)){
				var	_instSpawn = [],
					_w = 5 * 32,
					_h = 4 * 32;
					
				with(Wall){
					if(
						abs(((bbox_left + bbox_right + 1) / 2) - _spawnx) > 48 + (_w / 2) &&
						abs(((bbox_top + bbox_bottom + 1) / 2) - _spawny) > 48 + (_h / 2)
					){
						array_push(_instSpawn, id);
					}
				}
				
				with(instance_random(_instSpawn)){
					var	_dir = point_direction(_spawnx, _spawny, x, y),
						_dis = 1/3,
						_campX = x + lengthdir_x(_w * _dis, _dir),
						_campY = y + lengthdir_y(_h * _dis, _dir),
						_floor = floor_fill(_campX, _campY, _w / 32, _h / 32);
						
					 // Main Campsite:
					if(array_length(_floor) > 0) with(_floor[0]){
						var	_x = x + (_w / 2),
							_y = y + (_h / 2);
							
						 // Dying Campfire:
						with(instance_create(_x, _y, Detail)){
							sprite_index = spr.BanditCampfire;
							with(instance_create(_x, _y - 2, GroundFlame)){
								alarm0 *= 4;
							}
						}
						
						 // Main Tents:
						var _ang = random(360);
						for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 3)){
							var	l = 40,
								d = _dir + orandom(10);
								
							with(obj_create(_x + lengthdir_x(l, d), _y + lengthdir_y(l, d), "BanditTent")){
								 // Grab Chests:
								with(instance_nearest_array(x, y, instances_matching_ne([chestprop, RadChest], "mask_index", mskNone))){
									with(other){
										target = other;
										event_perform(ev_step, ev_step_begin);
									}
								}
							}
						}
						
						 // Bro:
						obj_create(_x, _y, "BanditHiker");
					}
					
					 // Reduce Nearby Non-Bandits:
	        		with(instances_matching([MaggotSpawn, BigMaggot, Scorpion, GoldScorpion], "", null)){
	        			if(chance(1, point_distance(x, y, _campX, _campY) / 160)){
	        				instance_delete(id);
	        			}
	        		}
					
					 // Random Tent Spawns:
					with(array_shuffle(instances_matching(instances_matching(Floor, "mask_index", mskFloor), "styleb", false))){
						if(chance(1, point_distance(x, y, _campX, _campY) / 24)){
							if(!place_meeting(x, y, Wall) && !place_meeting(x, y, hitme)){
								var	_fw = ((bbox_right + 1) - bbox_left),
									_fh = ((bbox_bottom + 1) - bbox_top),
									_fx = x + (_fw / 2),
									_fy = y + (_fh / 2);
									
								if(point_distance(_fx, _fy, _spawnx, _spawny) > 64){
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
												obj_create(_fx + orandom(8), _fy + orandom(8), (chance(1, 3) ? Barrel : "BanditTent"));
											}
										}
									}
								}
							}
						}
					}
				}
			}
            
             // Top Spawns:
            _topChance *= (0.5 + (0.5 * GameCont.loops)) * (1 + _eventScorp);
            _topSpawn = [
            	[Cactus,			1],
            	["BabyScorpion",	(_eventScorp ? (1 + GameCont.loops) : 1/20)]
            ];
            if(GameCont.subarea == 3){
            	_topChance *= 2;
            	
             	if(!_eventScorp){
             		array_push(_topSpawn, [Bandit, 1 + GameCont.loops]);
             	}
            	array_push(_topSpawn, [Barrel, 1/5]);
            	
            	 // Bandit Camp:
            	/*
            	if(chance(1, 50)){
            		with(_topSpawn){
            			switch(self[0]){
            				case Cactus:
            					self[@0] = Bandit;
            					break;
            					
            				case Barrel:
            					self[@1] = 1 + GameCont.loops;
            					if(_eventScorp) self[@1] /= 2;
            					break;
            			}
            		}
            		
            		 // More Bandit:
            		with(instances_matching([MaggotSpawn, BigMaggot, Scorpion, GoldScorpion], "", null)){
            			corpse_drop(direction, 0);
            			
        				mask_index = sprBarrel;
        				if(!place_meeting(x, y, prop) && !place_meeting(x, y, chestprop)){
	            			with(instance_create(x, y, Barrel)){
	            				x += irandom_range(-2, 2);
	            				y -= irandom(2);
	            				repeat(2) instance_create(x, y, Bandit);
	            			}
        				}
        				
            			instance_delete(id);
            		}
            		with(WantBoss) number++;
            		
            		 // Sound:
            		sound_play_pitchvol(sndVlambeer, 0.7, 2);
            		sound_play_pitchvol(sndHitPlant, 0.5, 2);
            		sound_play_pitchvol(sndSelectUp, 0.7, 2);
            		sound_play_pitchvol(sndBigBanditTaunt, 1 + orandom(0.2), 0.5);
            	}
            	*/
            }
            else{
            	array_push(_topSpawn, [JungleFly, GameCont.loops]);
            }
            if(chance(1, 3)){
            	with(instance_random(TopSmall)){
            		with(top_create(x, y, BonePile, random(360), random_range(128, 160))){
						var d = random(360);
						repeat(choose(1, 1, 2)){
							top_create(x, y, Cactus, d, -1);
							d += 180 + orandom(90);
						}
						
						 // Hmmm:
						var	l = 128,
							d = spawn_dir;
							
						with(top_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), ((crown_current == crwn_love) ? AmmoChest : BigWeaponChest), -1, -1)){
							top_create(x + orandom(24), y + orandom(24), AmmoChest, -1, -1);
							top_create(x, y, Cactus, random(360), -1);
							
							 // Skipping Doesn't Count:
							if(instance_is(target, BigWeaponChest)) GameCont.nochest -= 2;
						}
            		}
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
    	    
             // Top Spawns:
            _topChance /= 2;
            _topSpawn = [
            	[Pipe,			1],
            	[ToxicBarrel,	1/20]
            ];
            with(FrogQueen){
		    	repeat(irandom_range(1, 3) + (3 * GameCont.loops)){
		    		with(top_create(x, y, FrogEgg, random(360), -1)){
						if(distance_to_object(Floor) > 24 && chance(2, 3)){
							var	a = random(360),
								l = 8,
								_cx = x + lengthdir_x(l, a),
								_cy = y + lengthdir_y(l, a);
								
							for(var d = a - 60; d <= a + 60; d += 120){
								top_create(
									_cx + lengthdir_x(l, d) + orandom(2),
									_cy + lengthdir_y(l, d) + orandom(2),
									FrogEgg,
									d,
									0
								);
								x += orandom(2);
								y += orandom(2);
							}
						}
		    		}
		    	}
            }
    	    
    	     // Loop Spawns:
    	    if(GameCont.loops > 0){
    	    	with(Ratking) if(chance(1, 3) || floor_get(x, y).styleb){
    	    		obj_create(x, y, "TrafficCrab");
    	    		instance_delete(id);
    	    	}
    	    }
    	    
            break;

		case 3: /// SCRAPYARDS
		
			 // Raven Spectators:
			var	_event = chance(1, 60),
				_ravenChance = (_event ? 1 : 0.1) * (1 + (0.5 * GameCont.loops));
				
			if(!_event && instance_exists(BecomeScrapBoss)){
				_ravenChance *= 2;
			}
			
			with(Wall) if(!place_meeting(x, y, PortalClear)){
				if(chance(_ravenChance, 20) || (_event && position_meeting(x + 8, y + 8, Floor))){
					obj_create(x + 8 + orandom(4), y - 8 + orandom(4), "NestRaven");
				}
			}
			with(TopSmall){
				if(chance(_ravenChance, 10)){
					obj_create(x + 8 + orandom(16), y + orandom(8), "NestRaven");
				}
			}
			
			 // Raven Arena:
			if(_event){
				with(Bandit){
					instance_create(x, y, Raven);
					instance_delete(id);
				}

				 // Sound:
				sound_play_pitchvol(sndRavenDie, 0.5 + orandom(0.1), 0.7);
				sound_play_pitchvol(sndHalloweenWolf, 1.4 + random(0.1), 0.5);
				if(fork()){
					repeat(10){
						var s = audio_play_sound(choose(sndRavenLift, sndRavenScreech, sndRavenLand), 0, 0);
						audio_sound_gain(s, random(0.8), 0);
						audio_sound_pitch(s, 1 + orandom(0.2));
						var w = irandom(4);
						if(w > 0) wait w;
					}
					exit;
				}
			}
			
			 // Sawblade Traps:
			with(enemy) if(chance(1, 20)){
				obj_create(x, y, "SawTrap");
			}
			
			 // Sludge Pool:
			if(GameCont.subarea = 2){
				var _floors = instances_matching(Floor, "mask_index", mskFloor);
				with(instance_random(_floors)){
					with(instance_create(x, y, CustomObject)){
						 // Vars:
						var _size = 2;
						mask_index = mskFloor;
						image_xscale = _size;
						image_yscale = _size;
						direction = choose(0, 90, 270, 180);
						
						 // Find Space:
						var o = 32;
						while(array_length(instances_meeting(x, y, _floors)) > 0){
							direction += choose(0, 0, 90, 270, 180);
							x += lengthdir_x(o, direction);
							y += lengthdir_y(o, direction);
						}
						
						 // Create Room:
						var a = floor_fill(x, y, _size, _size);
						for(var i = 0; i < array_length(a); i++){
							with(a[i]){
								sprite_index = spr.SludgePool;
								image_index = i;
								material = 5; // slimy stone
							}
						}
						obj_create(x, y, "SludgePool");
						
						 // Goodbye:
						instance_delete(id);
					}
				}
			}
			
			 // Top Spawns:
            _topChance *= (0.5 * (1 + instance_exists(BecomeScrapBoss) + _event));
            _topSpawn = [
            	[Tires,			1],
            	[Car,			1/3],
            	[MeleeFake,		1/8]
            ];
        	var _num = irandom_range(-2, 1) + (3 * GameCont.loops);
        	if(_num > 0) repeat(_num) with(instance_random(TopSmall)){
    			top_create(
    				random_range(bbox_left, bbox_right),
    				random_range(bbox_top, bbox_bottom),
    				MeleeBandit,
    				-1,
    				random_range(32, 80)
    			);
        	}
			
    	     // Loop Spawns:
    	    if(GameCont.loops > 0){
    	    	with(Raven) if(chance(4 - GameCont.subarea, 12)){
    	    		obj_create(x, y, "Pelican");
    	    		instance_delete(id);
    	    	}
    	    }
    	    
			break;

        case 4: /// CAVES
            
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
        	
        	 // Spawn Lightning Crystals:
        	if(GameCont.loops <= 0){
	        	with(LaserCrystal) if(chance(1, 40)){
	        		instance_create(x, y, LightningCrystal);
	        		instance_delete(id);
	        	}
        	}
        	
        	 // Spawn Spider Walls:
        	if(instance_exists(Wall)){
    	    	var _spawnWall = [];
    	    	with(Wall) if(distance_to_object(PortalClear) > 16){
    	    		array_push(_spawnWall, id);
    	    	}
    	    	
    	    	 // Central Mass:
    	        with(instance_random(_spawnWall)){
    	        	var _dis = 48 + (32 * GameCont.loops);
    	        	
    	             // Spawn Main Wall:
    	            with(obj_create(x, y, "SpiderWall")){
    	                creator = other;
    	                special = true;
    	            }
    	            
    	             // Spawn fake walls:
    	            with(_spawnWall) if(point_distance(x, y, other.x, other.y) <= _dis && chance(2, 3)){
    	                with(obj_create(x, y, "SpiderWall")){
    	                    creator = other;
    	                }
    	            }
    	            
    	             // Change TopSmalls:
    	            with(TopSmall) if(point_distance(x, y, other.x, other.y) <= _dis && chance(1, 3)){
    	                sprite_index = spr.SpiderWallTrans;
    	            }
    	        }
    	    	
        	     // Strays:
        	    repeat((8 + irandom(4)) * (1 + GameCont.loops)) with(instance_random(_spawnWall)){
        	        with(obj_create(x, y, "SpiderWall")){
        	            creator = other;
        	        }
        	    }
        	}
        
			 // Top Spawns:
            _topSpawn = [
            	[CrystalProp,	1],
            	["NewCocoon",	1/2]
            ];
        	
            break;
            
        case 5: /// FROZEN CITY
        
        	 // Igloos:
        	repeat(1 + irandom(2)){
				var _floors = instances_matching(Floor, "mask_index", mskFloor);
				with(instance_random(_floors)){
					with(instance_create(x, y, CustomObject)){
						 // Vars:
						var _size = 3;
						mask_index = mskFloor;
						image_xscale = _size;
						image_yscale = _size;
						direction = choose(0, 90, 270, 180);
						
						 // Find Space:
						var o = 32;
						while(array_length(instances_meeting(x, y, _floors)) > 0){
							direction += choose(0, 0, 90, 270, 180);
							x += lengthdir_x(o, direction);
							y += lengthdir_y(o, direction);
						}
						
						 // Create Room:
						var _cx = x + o,
							_cy = y + o;
						floor_fill(_cx, _cy, _size, _size);
						obj_create(_cx + 16, _cy + 16, "Igloo");
						
						 // Goodbye:
						instance_delete(id);
					}
				}
			}
    
        	 // Top Spawns:
        	_topChance /= 1.5;
        	_topSpawn = [
        		[Hydrant, 1],
        		[SnowMan, 1/20]
        	];
        	
    	     // Loop Spawns:
    	    if(GameCont.loops > 0){
    	    	with(SnowTank) if(chance(1, 4)){
    	    		obj_create(x, y, "SawTrap");
    	    	}
    	    	with(Necromancer) if(chance(1, 2)){
    	    		obj_create(x, y, "Cat");
    	    		instance_delete(id);
    	    	}
    	    	
    	    	 // Charging Wall-Top Bots:
	        	var _num = (3 * GameCont.loops) + random_range(1, 3);
	        	if(_num > 0) repeat(_num) with(instance_random(TopSmall)){
	    			with(top_create(x, y, SnowBot, random(360), random_range(80, 192))){
						jump = 0.5;
						idle_walk_chance = 0;
						target_save.alarm1 = irandom_range(3, 10);
						with(target) spr_walk = sprSnowBotFire;
	    			}
	        	}
    	    }
	    	with(Wolf) if(chance(1, ((GameCont.loops > 0) ? 5 : 200))){
	    		with(obj_create(x, y, "Cat")){
	    			sit = other; // It fits
	    			depth = other.depth - 0.1;
	    		}
	    	}
	    	
        	break;
            
        case 6: /// LABS
        
        	 // Top Spawns:
        	_topChance *= (1 + (0.5 * GameCont.loops));
        	_topSpawn = [
        		[Freak,			1],
        		[ExploFreak,	1/5]
        	];
        	with(TechnoMancer){
        		var	_spawnAng = random(360),
        			_spawnNum = irandom_range(3, 5);
        			
        		for(var _spawnDir = _spawnAng; _spawnDir < _spawnAng + 360; _spawnDir += (360 / _spawnNum)){
        			with(top_create(x, y, choose(Server, Terminal), _spawnDir, 32)){
	        			if(instance_is(target, Terminal) && distance_to_object(Floor) > 16){
	        				var	l = 16,
	        					d = 270 + orandom(70);
	        					
	        				with(top_create(target.x + lengthdir_x(l, d), target.y + lengthdir_y(l, d), Necromancer, d, 0)){
	        					with(target){
	        						gunangle = d + 180;
	        						scrRight(gunangle);
	        					}
	        				}
	        			}
        			}
        		}
        	}
        	
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
    	    	with(LaserCrystal) if(chance(1, 2)){
    	    		obj_create(x, y, "PortalGuardian");
    	    		instance_delete(id);
    	    	}
    	    }
    	    
        	break;
            
        case 7: /// PALACE
        
    		 // Cool Dudes:
    		with(Guardian) if(chance(1, 20)){
    			obj_create(x, y, "PortalGuardian");
    			instance_delete(id);
    		}
    		
        	 // Top Spawns
        	if(GameCont.subarea != 3){
            	_topChance /= 1.2;
        		_topSpawn = [
	        		[Pillar,	1],
	        		[Generator,	1/50]
	        	];
        	}	
        	/*else with(ThroneStatue){
    			var f = instance_nearest(x, y, Carpet);
    			top_create(x + (72 * sign(x - f.x)), y - 8, ThroneStatue, -1, 0);
    		}*/
        	
    	     // Loop Spawns:
    	    if(GameCont.loops > 0){
    	    	with(JungleBandit){
    	    		repeat(chance(1, 5) ? 5 : 1) obj_create(x, y, "Gull");
    	    		
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
        	
        case 100: /// CROWN VAULT
        	
        	 // Vault Flower Room:
        	if(instance_exists(Floor)){
				var	_farFloor = instance_furthest(_spawnx, _spawny, Floor),
					_floorDir = point_direction(_spawnx, _spawny, _farFloor.x, _farFloor.y),
					_floorDis = point_distance(_spawnx, _spawny, _farFloor.x, _farFloor.y) / 2,
					_midFloor = instance_nearest_array(_spawnx + lengthdir_x(_floorDis, _floorDir), _spawny + lengthdir_y(_floorDis, _floorDir), instances_matching(Floor, "mask_index", mskFloor));
					
				with(instance_random(instances_matching(Floor, "mask_index", mskFloor))){
					with(instance_create(x, y, CustomObject)){
						 // Create Room:
						var _size = 3;
						mask_index = mskFloor;
						image_xscale = _size;
						image_yscale = _size;
						direction = choose(0, 90, 180, 270);
						
						 // Move Away:
						var o = 32;
						while(place_meeting(x, y, Floor)){
							direction += choose(0, 0, 90, 180, 270);
							x += lengthdir_x(o, direction);
							y += lengthdir_y(o, direction);
						}
						
						 // Floor Time:
						var _img = 0;
						with(floor_fill(x + o, y + o, _size, _size)){
							// love u yokin yeah im epic
							sprite_index = spr.VaultFlowerFloor;
							image_index = _img++;
							depth = 7;
						}
						
						 // The Star of the Show:
	 					var cx = x + (floor(_size / 2) * o) + 16,
							cy = y + (floor(_size / 2) * o) + 16,
							yoff = -8;
							
						obj_create(cx, cy + yoff, "VaultFlower");
						
						with(instance_create(cx, cy + yoff, LightBeam)){
							sprite_index = sprLightBeamVault;
						}
						
						with(instance_create(x, y, PortalClear)){
							mask_index = mskFloor;
							image_xscale = _size;
							image_yscale = _size;
						}
						
						 // Goodbye:
						instance_destroy();
					}
				}
    		}
        	
        	 // Top Spawns:
        	_topChance = 1/40;
        	_topSpawn = [
        		[Torch, 1]
        	];
        	
        	break;
        	
        case 101:
        case "oasis":
        
        	 // Top Spawns:
        	_topSpawn = [
        		[BoneFish,		1],
        		["Puffer",		1],
        		["Hammerhead",	(GameCont.loops > 0)],
        		[Freak,			(GameCont.loops > 0) / 2],
        		[OasisBarrel,	1],
        		[Anchor,		1/4]
        	];
        	
        	break;

        case 103: /// MANSIOM  its MANSION idiot, who wrote this
        
             // Spawn Gold Mimic:
            with(instance_nearest(_spawnx, _spawny, GoldChest)){
                with(pet_spawn(x, y, "Mimic")){
                    wep = weapon_decide_gold(18, 18 + GameCont.loops, 0);
                }
                instance_delete(self);
            }
            
             // Top Spawns:
            _topChance *= (1.5 + GameCont.loops);
            _topSpawn = [
            	[MoneyPile,			1],
            	[GoldBarrel,		1/3],
            	[FireBaller,		2/3 * (1 + GameCont.loops)],
            	[SuperFireBaller,	1/3 * (1 + GameCont.loops)]
            ];
            
            break;

        case 104: /// CURSED CAVES
        
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
        	
			 // Top Spawns:
            _topSpawn = [
            	[InvCrystal,	1],
            	["NewCocoon",	1/2]
            ];
            
            break;
            
        case 105: /// JUNGLE where is the hive ?
        
        	 // Top Spawns:
        	_topSpawn = [
        		[Bush,					1],
        		[JungleAssassinHide,	1/3],
        		[BigFlower,				1/3]
        	];
        	with(instances_matching([JungleBandit, JungleFly], "", null)){
        		if(chance(1, 3)) top_create(x, y, id, -1, -1);
        	}
        	
        	break;
            
        case 107: /// CRIB
        
        	 // Top Spawns
        	_topSpawn = [
        		[MoneyPile, 1]
        	];
        	
        	break;
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
	if(GameCont.area == 3 && array_length(instances_matching(CustomObject, "name", "NestRaven")) > 24){
		_chance = 1;
	}
    if(chance(_chance, 1) && instance_exists(Player)){
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
						case "Hammerhead":
							var _num = irandom_range(1, 4) + (3 * GameCont.loops),
								_ang = random(360);
								
							if(_obj == "Hammerhead"){
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
							with(obj_create(x, y + 1, "NestRaven")){
								x = other.x;
								y = other.y + 5 - (other.z - z) - (sprite_get_bbox_bottom(spr_idle) - sprite_get_bbox_top(spr_idle));
								spr_shadow = shd16;
								spr_shadow_y = 5;
								
								switch(_obj){
									case Car:
										x += 2 * other.target.image_xscale * variable_instance_get(other.target, "right", 1);
										y += choose(-1, 0, 1);
										break;
										
									case MeleeFake:
										y += choose(3, 4);
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
							
						case Hydrant: // Seal Squads
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
							break;
							
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
    if(_validArea){
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
			top_create(x + random(16), y + random(16), _obj, -1, -1);
		}
    }
    
     // Buried Vault:
    if(_validArea || instance_exists(IDPDSpawn) || instance_exists(CrownPed)){
	    if(chance(
	    	1 + (2 * GameCont.vaults * (GameCont.area == 100)),
	    	8 + variable_instance_get(GameCont, "buried_vaults", 0)
	    )){
	    	with(instance_random(Wall)){
		    	obj_create(x, y, "BuriedVault");
		    	
		    	 // Hint:
		    	sound_play_pitchvol(sndWallBreakBrick, 0.5 + random(0.1), 0.6);
				sound_play_pitchvol(sndStatueXP, 0.3 + random(0.1), 5);
	    	}
	    }
    }
    
	 // Bab:
	if(instance_exists(CrystalProp) || instance_exists(InvCrystal)){
		with(instances_matching([CrystalProp, InvCrystal, chestprop], "", null)){
			if(place_meeting(x, y, Floor) && !place_meeting(x, y, Wall)){
				repeat(irandom_range(1, 3)){
					obj_create(x, y, "Spiderling");
				}
			}
		}
	}

     // Visibilize Pets:
    with(instances_matching(CustomHitme, "name", "Pet")) visible = true;

     // Flavor big cactus:
    if(chance(1, ((GameCont.area == 0) ? 3 : 10))){
    	with(instance_random([Cactus, NightCactus])){
	        obj_create(x, y, "BigCactus");
	        instance_delete(id);
    	}
    }

	 // Sewer manhole:
	with(PizzaEntrance){
	    with(obj_create(x, y, "Manhole")) toarea = "pizza";
	    instance_delete(id);
	}
    
     // Backpack Setpieces:
    var	_canBackpack = chance(1 + (2 * skill_get(mut_last_wish)), 12),
    	_forceSpawn = (GameCont.area == 0);
    	
    if(GameCont.hard > 4 && ((_canBackpack && _validArea && GameCont.area != 106) || _forceSpawn)){
		 // Compile Potential Floors:
		var _potentialFloors = [];
		with(instances_matching_ne(Floor, "object_index", FloorExplo)){
			if(distance_to_object(Player) > 80){
				if(!place_meeting(x, y, hitme) && !place_meeting(x, y, chestprop)){
					array_push(_potentialFloors, id);
				}
			}
		}

		 // Backpack:
		with(instance_random(_potentialFloors)){
			obj_create(x + 16 + orandom(4), y + 10, "Backpack");

			 // Flavor Corpse:
			if(GameCont.area != 0){
				obj_create((x + 16) + orandom(8), (y + 16) + irandom(8), "Backpacker");
				
				/*
				with(instance_create(x + 16 + orandom(8), y + 16 + irandom(8), CorpseActive)){
					image_xscale = choose(-1, 1);
					sprite_index = sprMutant14Dead;
					image_index = image_number - 1;
	
					 // Bone:
					with(instance_create(x - 8 * image_xscale, y + 8, WepPickup)){
						wep = "crabbone";
					}
				}
				*/
			}
			
			instance_create(x + 16, y + 16, PortalClear);
		}
    }
    
     // Lair Chests:
    var	_crime = (crown_current == "crime"),
    	_lair = variable_instance_get(GameCont, "visited_lair", false);
    	
    if(_lair || _crime){
    	var _crimePick = (_crime ? choose(AmmoChest, WeaponChest) : -1);
    	
		 // Cat Chests:
		with(instances_matching_ne(AmmoChest, "object_index", IDPDChest, GiantAmmoChest)){
			if(instance_is(self, _crimePick) || chance(_lair, 5)){
				obj_create(x, y, "CatChest");
				instance_delete(id);
			}
		}
		
		 // Bat Chests:
		with(instances_matching_ne(WeaponChest, "object_index", GiantWeaponChest)){
			if(instance_is(self, _crimePick) || chance(_lair, 5)){
				with(obj_create(x, y, "BatChest")){
					big = (instance_is(other, BigWeaponChest) || instance_is(other, BigCursedChest));
					curse = other.curse;
				}
				instance_delete(id);
			}
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
	
	 // Crystal Hearts:
	if(_validArea && instance_exists(Wall)){
		if(GameCont.area == 104 || chance(GameCont.hard, (GameCont.hard + 80))){
			with(instance_random(enemy)) obj_create(x, y, "CrystalHeart");
		}
	}
	
#define step
    if(DebugLag) trace_time();
    
	 // Bind Events:
    script_bind_end_step(end_step, 0);
    script_bind_draw(draw_menu, (instance_exists(Menu) ? Menu.depth : object_get_depth(Menu)) - 0.1);
    
     // Bind HUD Event:
    var _HUDDepth = 0,
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
    
     // Character Selection Menu:
    if(instance_exists(Menu)){
    	if(!mod_exists("mod", "teloader")){
	    	 // Custom Character Stuff:
	        with(raceList){
	            var _name = self;
	
	        	 // Create Custom CampChars:
	            if(mod_exists("race", _name) && unlock_get(_name)){
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
	    			else if(stat_get("race/" + _name + "/runs") <= 0){
			            script_bind_draw(CharSelect_draw_new, depth - 0.001, id);
	    			}
		        }
	        }
	
	         // CampChar Management:
	        var _playersTotal = 0,
	        	_playersLocal = 0;
	        	
	        for(var i = 0; i < maxp; i++){
	        	_playersTotal += player_is_active(i);
	        	_playersLocal += player_is_local_nonsync(i);
	        }
	        for(var i = 0; i < maxp; i++) if(player_is_active(i)){
	            var _race = player_get_race(i);
	            if(array_exists(raceList, _race)){
	                with(instances_matching(CampChar, "race", _race)){
	                     // Pan Camera:
	                    if(_playersLocal <= 1 || _playersTotal > _playersLocal){
		                    with(instances_matching(CampChar, "num", 17)){
								var _x1 = x,
									_y1 = y,
									_x2 = other.x,
									_y2 = other.y,
					        		_pan = 4;
					        		
								view_shift(
									i,
									point_direction(_x1, _y1, _x2, _y2),
									point_distance(_x1, _y1, _x2, _y2) * (1 + ((2/3) / _pan)) * 0.1
								);
								
								break;
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
	
			 // Loadout Crowns:
	    	with([surfCrownHide, surfCrownHideScreen]) active = true;
			with(Menu){
	            with(Loadout) if(selected == false && openanim > 0){
	            	openanim = 0; // Bro they actually forgot to reset this when the loadout is closed
	            }
	
		    	 // Bind Drawing:
			    script_bind_draw(draw_crown, object_get_depth(LoadoutCrown) - 0.0001);
			    if(instance_exists(Loadout)){
			    	script_bind_draw(loadout_behind, Loadout.depth + 0.0001);
			    }
	
				 // Crown Thing:
				if("NTTE_crown_check" not in self){
					NTTE_crown_check = true;
		    		if(crownCamp != crwn_none){
						var _inst = instance_create(0, 0, Crown);
						with(_inst){
							alarm0 = -1;
							event_perform(ev_alarm, 0);
		
							 // Place by Last Played Character:
							with(array_combine(instances_matching(CampChar, "num", player_get_race_id(0)), instances_matching(CampChar, "race", player_get_race(0)))){
								other.x = x + (random_range(12, 24) * choose(-1, 1));
								other.y = y + orandom(8);
							}
		
							 // Visual Setup:
							var c = crownCamp;
							if(is_string(c)){
								mod_script_call("crown", c, "crown_object");
							}
							else if(is_real(c)){
								spr_idle = asset_get_index(`sprCrown${c}Idle`);
								spr_walk = asset_get_index(`sprCrown${c}Walk`);
							}
							depth = -2 - (y / 10000);
						}
		
						 // Delete:
						if(fork()){
							wait 5;
							with(instances_matching_ne(Crown, "id", _inst)){
								instance_destroy();
							}
							exit;
		    			}
					}
				}
	
		    	 // Initialize Crown Selection:
		    	var _mods = mod_get_names("race");
			    for(var i = 0; i <= 16 + array_length(_mods); i++){
			        var _race = ((i <= 16) ? race_get_name(i) : _mods[i - 17]);
			        if(_race not in crownRace){
			        	lq_set(crownRace, _race, {
			        		icon : [],
			        		slct : crwn_none,
			        		custom : {
			        			icon : [],
			        			slct : -1
			        		}
			        	});
			        }
			    }
		    }
    	}
    }
    else{
    	with([surfCrownHide, surfCrownHideScreen]) active = false;

		 // For CharSelection Crown Boy:
	    crownCamp = crown_current;
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
		while(array_length(ntte_pet) < ntte_pet_max){
			array_push(ntte_pet, noone);
		}
		
		 // Map Icons:
		var _list = [];
		with(ntte_pet) if(instance_exists(self)){
			array_push(_list, pet_get_mapicon(mod_type, mod_name, pet));
		}
		global.petMapicon[index] = _list;
	}

	 // Player Death:
	with(instances_matching_le(Player, "my_health", 0)){
		if(fork()){
			var _x = x,
				_y = y,
				_save = ["ntte_pet", "feather_ammo", "ammo_bonus"],
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
		    	if(array_exists(raceList, _race)){
			    	var _stat = "race/" + _race + "/lost";
					stat_set(_stat, stat_get(_stat) + 1);
		    	}
			}
			exit;
		}
	}

     // Wait for Level Start:
    if(instance_exists(GenCont) || instance_exists(Menu)){
    	global.newLevel = true;

    	 // Reset Things:
    	global.setup_floor_num = 0;
    }
    else if(global.newLevel){
        global.newLevel = false;
        level_start();
    }
    
     // Call Area Events (Not built into area mods):
    var a = array_find_index(areaList, GameCont.area);
    if(a < 0 && GameCont.area = 100) a = array_find_index(areaList, GameCont.lastarea);
    if(a >= 0){
        var _area = areaList[a];

         // Floor Setup:
        if(GameCont.area != 100){
	        var	_scrt = "area_setup_floor";
	        if(mod_script_exists("area", _area, _scrt)){
		        var _num = instance_number(Floor);
		        if(global.setup_floor_num != _num){
		        	global.setup_floor_num = _num;
		            with(instances_matching(Floor, "ntte_setup", null)){
		                ntte_setup = true;
		                mod_script_call("area", _area, _scrt, (object_index == FloorExplo));
		            }
		        }
	        }
        }

        if(!instance_exists(GenCont) && !instance_exists(LevCont)){
		     // Underwater Area:
		    if(area_get_underwater(_area)){
		    	mod_script_call("mod", "tewater", "underwater_step");
		    }

             // Step(s):
            mod_script_call("area", _area, "area_step");
            if(mod_script_exists("area", _area, "area_begin_step")){
                script_bind_begin_step(area_step, 0);
            }
            if(mod_script_exists("area", _area, "area_end_step")){
                script_bind_end_step(area_step, 0);
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
        if(GameCont.area != 100){
	        if(global.musTrans || instance_exists(GenCont) || instance_exists(mutbutton)){
	        	global.musTrans = false;
	            var _scrt = ["area_music", "area_ambience"];
	            for(var i = 0; i < lq_size(global.sound_current); i++){
	                var _type = lq_get_key(global.sound_current, i);
	                if(mod_script_exists("area", _area, _scrt[i])){
	                    var s = mod_script_call("area", _area, _scrt[i]);
	                    if(!is_array(s)) s = [s];
	
	                    while(array_length(s) < 3) array_push(s, -1);
	                    if(s[1] == -1) s[1] = 1;
	                    if(s[2] == -1) s[2] = 0;
	
	                    with(sound_play_ntte(_type, s[0])){
	                    	vol = s[1];
	                    	pos = s[2];
	                    }
	                }
	            }
	        }
        }
    }
    
     // Fix for Custom Music/Ambience:
    for(var i = 0; i < lq_size(global.sound_current); i++){
        var _type = lq_get_key(global.sound_current, i),
            c = lq_get_value(global.sound_current, i);

        if(audio_is_playing(c.hold)){
            if(!audio_is_playing(c.snd)){
                audio_sound_set_track_position(audio_play_sound(c.snd, 0, true), c.pos);
            }
        }
        else audio_stop_sound(c.snd);
    }
    
	 // Area Completion Unlocks:
	if(!instance_exists(GenCont) && !instance_exists(LevCont) && instance_exists(Player)){
		if(instance_exists(Portal) || (!instance_exists(enemy) && !instance_exists(CorpseActive))){
			//if(!array_length(instances_matching_ne(instances_matching(CustomObject, "name", "CatHoleBig"), "sprite_index", mskNone))){ yokin wtf how could you comment out my epic code!?!?
				var _packList = {
					"coast"  : ["Wep"],
					"oasis"  : ["Wep"],
					"trench" : ["Wep"],
					"lair"	 : ["Wep", "Crown"]
				};
				
				with(GameCont){
					if(is_string(area) && area in _packList){
						if(subarea >= area_get_subarea(area)){
							with(lq_get_value(_packList, i)){
								unlock_call(other.area + self);
							}
						}
					}
				}
			//}
		}
	}
	
	 // Game Win Crown Unlock:
	with(SitDown) if(place_meeting(x, y, Player)){
		if(array_exists(crwnList, crown_current)){
			unlock_call("crown" + string_upper(string_char_at(crown_current, 1)) + string_delete(crown_current, 1, 1));
		}
	}
	
	 // Pet Map Icon Stuff:
	global.petMapiconPause = 0;
	if(instance_exists(GenCont)){
		for(var i = 0; i < maxp; i++){
			if(button_pressed(i, "paus")){
				global.petMapiconPauseForce = true;
			}
		}
	}
	
	 // Delete IDPD Chest Cheese:
	with(instances_matching(ChestOpen, "portalpoof_check", null)){
		portalpoof_check = false;
		if(sprite_index == sprIDPDChestOpen && instance_exists(IDPDSpawn)){
			portalpoof_check = true;
			portal_poof();
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
	
	 // Goodbye, stupid mechanic:
	with(instances_matching(instances_matching(Corpse, "sprite_index", sprIceFlowerDead), "no_reroll", null)) if(GameCont.area == 105 && position_meeting(x, y, Portal)){
		GameCont.skillpoints--;
		no_reroll = true;
		
		 // Give it back:
		skill_set(mut_last_wish, 1);
	}
	
    if(DebugLag) trace_time("ntte_step");

#define end_step
	if(DebugLag) trace_time();

	 // Manually Recreating Pause/Loading/GameOver Map:
	if(global.mapAreaCheck){
		global.mapAreaCheck = false;
		with(GameCont){
			var i = waypoints - 1;
			if(i >= 0) global.mapArea[i] = [area, subarea, loops];
		}
	}

	try{
	     // Labs Merged Weapons:
	    with(instances_matching_le(ReviveArea, "alarm0", ceil(current_time_scale))){
	    	if(place_meeting(x, y, WepPickup)){
	    		with(instances_meeting(x, y, WepPickup)){
	    			if(point_distance(x, y, other.x, other.y - 2) < (other.sprite_width * 0.4) && weapon_get_area(wep) >= 0 && wep_get(wep) != "merge"){
						var _part = wep_merge_decide(0, GameCont.hard + (2 * curse));
						if(array_length(_part) >= 2){
							wep = wep_merge(_part[0], _part[1]);
							mergewep_indicator = null;
							
							 // FX:
							sound_play_hit_ext(sndNecromancerRevive, 1, 1.5);
							sound_play_pitchvol(sndGunGun, 0.5 + orandom(0.1), 0.5);
							sound_play_pitchvol(sprEPickup, 0.5 + orandom(0.1), 0.5);
							sound_play_hit_ext(sndNecromancerDead, 1.5 + orandom(0.1), 1);
							with(instance_create(x, y + 2, ReviveFX)){
								sprite_index = sprPopoRevive;
								image_xscale = 0.8;
								image_yscale = image_xscale;
								image_blend = make_color_rgb(100, 255, 50);
								depth = -2;
							}
						}
	    			}
	    		}
	    	}
	    }
		
	     // Merged Wep Pickup Indicator:
	    with(instances_matching(WepPickup, "mergewep_indicator", null)){
	    	mergewep_indicator = true;
	
	    	if(wep_get(wep) == "merge" && is_object(wep)){
	    		if("stock" in wep.base && "front" in wep.base){
	    			var n = name;
			    	name += `#@(${mod_script_call("mod", "teassets", "weapon_merge_subtext", wep.base.stock, wep.base.front)})`;
			    	array_push(global.wepMergeName, { inst:id, name:name, orig:n });
	    		}
	    	}
	    }
	    var _pop = instances_matching(PopupText, "mergewep_indicator", null);
	    if(array_length(_pop) > 0){
		    with(global.wepMergeName){
				with(instances_matching(_pop, "text", name + "!")){
					text = other.orig + "!";
				}
		    	if(!instance_exists(inst)){
		    		global.wepMergeName = array_delete_value(global.wepMergeName, self);
		    	}
		    }
	    	with(_pop) mergewep_indicator = true;
	    }
	
	     // Weapon Unlock Stuff:
		with(Player){
			var w = 0;
			with([wep_get(wep), wep_get(bwep)]){
				var _wep = self;
				with(other){
					if(is_string(_wep) && mod_script_exists("weapon", _wep, "weapon_avail") && array_exists(wepsList, _wep)){
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
						else unlock_call("found(" + _wep + ".wep)");
					}
				}
				w++;
			}
		}
		
		 // Crown Found:
		if(is_string(crown_current) && array_exists(crwnList, crown_current)){
			unlock_call("found(" + crown_current + ".crown)");
		}

		 // Race Stats:
		var _statInst = instances_matching([GenCont, SitDown], "ntte_statadd", null);
		with(_statInst) ntte_statadd = true;
		if(instance_exists(Player)){
			var _statList = {
				"kill"	: (GameCont.kills - global.killsLast),
				"loop"	: ((GameCont.area == 0) ? array_length(instances_matching(_statInst, "object_index", GenCont)) : 0),
				"wins"	: array_length(instances_matching(_statInst, "object_index", SitDown)),
				"time"	: (current_time_scale / 30)
			};

			 // Find Active Races:
			var _statRace = [];
			for(var i = 0; i < maxp; i++){
				var _race = player_get_race(i);
				if(array_exists(raceList, _race) && !array_exists(_statRace, _race)){
					array_push(_statRace, _race);
				}
			}

			 // Apply Stats:
			with(_statRace){
				var _statPath = "race/" + self + "/";

				 // General Stats:
				for(var i = 0; i < lq_size(_statList); i++){
					var _stat = _statPath + lq_get_key(_statList, i),
						_add = lq_get_value(_statList, i);
	
					if(_add > 0){
						stat_set(_stat, stat_get(_stat) + _add);
					}
				}

				  // Best Run:
			 	if(GameCont.kills > stat_get(_statPath + "bestKill")){
			 		stat_set(_statPath + "bestArea", area_get_name(GameCont.area, GameCont.subarea, GameCont.loops));
			 		stat_set(_statPath + "bestKill", GameCont.kills);
			 	}
			}
		}
		global.killsLast = GameCont.kills;
		
		 // Scythe Prompts:
		with(instances_matching(GenCont, "tip_scythe", null)){
			tip_scythe = false;
			
			if(GameCont.hard > 1){
				if(global.sPromptIndex != -1){
					with(Player) if(wep_get(wep) == "scythe" || wep_get(bwep) == "scythe"){
						other.tip_scythe = true;
					}
					if(tip_scythe){
						tip = global.scythePrompt[global.sPromptIndex];
						global.sPromptIndex = min(global.sPromptIndex + 1, array_length(global.scythePrompt) - 1);
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
					if(is_object(w) && "ammo" in w && "amax" in w && array_exists(wepsList, wep_get(w))){
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
		
		 // Loop Labs:
		if(GameCont.loops > 0 && GameCont.area == 6){
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
    }
    catch(_error){
    	trace_error(_error);
    }

	if(DebugLag) trace_time("ntte_end_step");

    instance_destroy();

#define draw_menu
	 // Campfire Menu:
    MenuSplat += current_time_scale * (mod_exists("mod", "teloader") ? -1 : 1);
	MenuSplat = clamp(MenuSplat, 0, sprite_get_number(sprBossNameSplat) - 1);
	if(instance_exists(Menu)){
    	draw_set_projection(0);

		if(MenuOpen){
	         // Hide Things:
	        with(Menu){
	        	mode = 0;
	            charsplat = 1;
	            for(var i = 0; i < array_length(charx); i++) charx[i] = 0;
	        	sound_volume(sndMenuCharSelect, 0);
	        }
	        with(Loadout) instance_destroy();
	        with(loadbutton) instance_destroy();
	        with(menubutton) instance_destroy();
	        with(BackFromCharSelect) noinput = 10;

	         // Dim Screen:
	        draw_set_color(c_black);
	        draw_set_alpha(0.75);
	        draw_rectangle(0, 0, game_width, game_height, 0);
	        draw_set_alpha(1);

	         // Leave:
	        for(var i = 0; i < maxp; i++){
	        	with(BackFromCharSelect){
	        		if(position_meeting((mouse_x[i] - (view_xview[i] + xstart)) + x, (mouse_y[i] - (view_yview[i] + ystart)) + y, id)){
		        		if(button_pressed(i, "fire")){
		        			MenuOpen = false;
		        			break;
		        		}
	        		}
	        	}
	        	if(button_pressed(i, "spec") || button_pressed(i, "paus")){
		        	MenuOpen = false;
	        		break;
	        	}
	        }
	        if(!MenuOpen || mod_exists("mod", "teloader")){
	        	MenuOpen = false;
            	MenuSplat = 1;
	        	sound_play(sndClickBack);

	        	 // Reset Menu:
	        	with(Menu){
	        		mode = 0;
	        		event_perform(ev_step, ev_step_end);
	        		sound_volume(sndMenuCharSelect, 1);
	        		sound_stop(sndMenuCharSelect);
	        		with(CharSelect) alarm0 = 2;
	        	}
	        	with(Loadout) selected = 0;

	        	 // Tiny Fix:
        		with(instance_create(0, 0, CustomDraw)){
        			loadout_behind();
        		}
	        }
		}

		 // Open:
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
				_x1 = (game_width / 2) - 20;
				_y1 += 2;
			}

			var _x2 = _x1 + 40,
				_y2 = _y1 + 24;

			 // Player Clicky:
			if(!instance_exists(Loadout) || !Loadout.selected){
				for(var i = 0; i < maxp; i++){
					if(point_in_rectangle(mouse_x[i] - view_xview[i], mouse_y[i] - view_yview[i], _x1, _y1 - 8, _x2, _y2)){
						_hover = true;
						if(button_pressed(i, "fire")){
							sound_play_pitch(sndMenuCredits, 1 + orandom(0.1));
							MenuOpen = true;
            				MenuSplat = 1;
							break;
						}
					}
				}
			}

			 // Button Visual:
			draw_sprite_ext(sprBossNameSplat, MenuSplat, _x1 + 17, _y1 + 12 + MenuSplat, 1, 1, 90, c_white, 1);
			if(!MenuOpen && MenuSplat > 0){
				var w = (MenuSplatBlink % 300) - 120;
				draw_sprite_ext(spr.MenuNTTE, 0, (_x1 + _x2) / 2, _y1 + 8 + _hover, 1, 1, 0, ((_hover || in_range(w, 0, 5) || in_range(w, 8, 10)) ? c_white : c_silver), 1);
			}
			if(MenuSplatBlink >= 0){
				MenuSplatBlink += current_time_scale;
				if(_hover || !option_get("remindPlayer", true)) MenuSplatBlink = -1;
			}
		}

		draw_reset_projection();
	}

	 // Main Code:
	ntte_menu();

	instance_destroy();

#define draw_pause_pre
	if(instance_exists(PauseButton) || instance_exists(BackMainMenu)){
		 // HUD:
		if(player_get_show_hud(player_find_local_nonsync(), player_find_local_nonsync())){
			with(surfMainHUD) if(surface_exists(surf)){
				x = view_xview_nonsync;
				y = view_yview_nonsync;
				
				 // Dim:
				var _col = c_white;
				if(instance_exists(BackMainMenu)){
					_col = merge_color(_col, c_black, 0.9);
				}
				
				draw_surface_ext(surf, x, y, 1, 1, 0, _col, 1);
			}
		}
	}
	
	instance_destroy();

#define draw_pause
	 // (Frame Flash) Pet Map Icons:
	if(global.petMapiconPause < 2){
		if(global.petMapiconPause > 0){
			draw_pet_mapicons(UberCont);
		}
		global.petMapiconPause++;
	}
	global.petMapiconPauseForce = false;

     // NTTE Menu:
    draw_set_projection(0);

    if(!MenuOpen){
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
		                	MenuOpen = true;
		                    with(OptionMenuButton) instance_destroy();
		                    sound_play(sndClick);
		                    break;
		                }
		            }
		        }
	
	             // Splat:
	            MenuSplatOptions += (_hover ? 1 : -1) * current_time_scale;
	            MenuSplatOptions = clamp(MenuSplatOptions, 0, sprite_get_number(sprMainMenuSplat) - 1);
	            draw_sprite(sprMainMenuSplat, MenuSplatOptions, (game_width / 2), _y);
	
	             // Gray Out Other Options:
	            if(MenuSplatOptions > 0){
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
    		else MenuSplatOptions = 0;
    	}
    }
	else if(instance_exists(menubutton)){
		MenuOpen = false;
	}

	draw_reset_projection();

	ntte_menu();

#define draw_gui_end
     // Custom Sound Volume:
    for(var i = 0; i < array_length(global.sound_current); i++){
        var c = lq_get_value(global.sound_current, i);
        if(c.snd != -1){
            audio_sound_gain(c.snd, audio_sound_get_gain(c.hold) * c.vol, 0);
        }
    }

	 // For Options Menu:
	for(var i = 0; i < maxp; i++){
		global.mouse_x_previous[i] = mouse_x[i];
		global.mouse_y_previous[i] = mouse_y[i];
	}

	 // Draw on Pause Screen but Below draw_pause Depth:
	if(instance_exists(PauseButton) || instance_exists(BackMainMenu)) with(UberCont){
		script_bind_draw(draw_pause_pre, depth - 0.1);
	}

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

#define area_step
	if(!instance_exists(GenCont) && !instance_exists(LevCont)){
	    var a = array_find_index(areaList, GameCont.area);
	    if(a < 0 && GameCont.area = 100) a = array_find_index(areaList, GameCont.lastarea);
	    if(a >= 0){
	        var _area = areaList[a],
		    	_scrt = "step";

		    switch(object_index){
		        case CustomBeginStep:
		            _scrt = "begin_step";
		            break;
		
		        case CustomEndStep:
		            _scrt = "end_step";
		            break;
		    }
		
		    try{
		        mod_script_call("area", _area, "area_" + _scrt);
		    }
		    catch(_error){
		    	trace_error(_error);
		    }
	    }
    }

    instance_destroy();

#define pet_get_mapicon(_modType, _modName, _name)
	var	_icon = {
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
	var _modScrt = _name + "_icon"
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
		_icon.spr = lq_defget(spr, "Pet" + _name + "Icon", -1);
	}

	return _icon;

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
				if(!global.petMapiconPauseForce || instance_exists(GenCont)){
					if(
						global.petMapiconPause <= 0  ||
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
	var _mapEnd = mapdata_get(_mapIndex),
		_mapX = (game_width  / 2) - 70,
		_mapY = (game_height / 2) + 7;

	if(_mapObj == TopCont){
		_mapX -= 50;
		_mapY -= 3;
		if(instance_exists(_mapObj)){
			_mapY -= min(2, _mapObj.go_stage);
		}
	}

	 // Draw Icons:
	if(_mapIndex == 0 || (is_real(_mapEnd.area) && _mapEnd.area >= 0) || (is_string(_mapEnd.area) && mod_exists("area", _mapEnd.area))){
		draw_set_projection(0);

		var _playerMax = 0;
		for(var i = 0; i < maxp; i++) if(player_is_active(i)){
			_playerMax = i + 1;
		}

		for(var i = 0; i < _playerMax; i++){
			var _px = _mapX + _mapEnd.x,
				_py = _mapY + _mapEnd.y,
				_iconAng = 30,
				_iconDir = 0,
				_iconDis = 10;

			 // Co-op Offset:
			if(_playerMax > 1){
				var l = 2 * _playerMax,
					d = 90 - ((360 / _playerMax) * i);
	
				if(_playerMax == 2) d += 45;
	
				_px += lengthdir_x(l, d);
				_py += lengthdir_y(l, d);

				_iconAng = d;
			}

			 // Pet Icons:
			for(var _petNum = 0; _petNum < array_length(global.petMapicon[i]); _petNum++){
				var _icon = global.petMapicon[i, _petNum];

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
	for(var i = -1; i < GameCont.waypoints; i++){
		var _data = {
			x		 : 0,
			y		 : 0,
			area	 : -1,
			subarea	 : 0,
			loop	 : 0,
			showdot  : false,
			showline : true
		};
		
		if(i >= 0 && i < array_length(global.mapArea)){
			var _last = _map[i],
				a = global.mapArea[i];

			if(is_array(a)){
				_data.area = a[0];
				_data.subarea = a[1];
				_data.loop = a[2];
			}

			 // Base Game:
			if(is_real(_data.area)){
				if(_data.area < 100){
					var n = 0;
					n += 3 *  ceil((floor(_data.area) - 1) / 2);	// Main Areas
					n += 1 * floor((floor(_data.area) - 1) / 2);	// Transition Areas
					n += _data.subarea - 1;							// Subarea
					n += (_data.area - floor(_data.area));			// Fractional Areas

					_data.x = 9 * n;
					_data.y = 0;
				}

				 // Secret Areas:
				else{
					_data.x = _last.x;
					_data.y = 9;
				}

				_data.showdot = (_data.subarea == 1);
			}

			 // Modded:
			else if(is_string(_data.area)){
				with(UberCont){
					var d = mod_script_call("area", _data.area, "area_mapdata", _last.x, _last.y, _last.area, _last.subarea, _data.subarea, _data.loop),
						n = array_length(d);

					if(n >= 2){
						_data.x = d[0];
						_data.y = d[1];
						if(n >= 3) _data.showdot = d[2];
						if(n >= 4) _data.showline = d[3];
					}
				}
			}
		}

		array_push(_map, _data);
	}

	 // Return Specific Waypoint:
	if(_index >= 0){
		return ((_index < array_length(_map)) ? _map[_index] : _map[0]);
	}

	return _map;

#define ntte_hud(_visible)
    var _players = 0,
		_vx = view_xview_nonsync,
		_vy = view_yview_nonsync,
		_ox = _vx,
		_oy = _vy,
		_surfHUD = surfMainHUD;
		
	draw_set_font(fntSmall);
	draw_set_halign(fa_right);
	draw_set_valign(fa_top);
	
	with(_surfHUD){
		x = _vx;
		y = _vy;
		w = game_width;
		h = game_height;
		
		active = false;
		
		if(surface_exists(surf)){
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			surface_reset_target();
		}
	}
	
	 // Co-op Rad Canister Offset:
    for(var i = 0; i < maxp; i++) _players += player_is_active(i);
    if(_players > 1) _ox -= 17;

	 // Determine which sides of the screen player HUD is On:
	var _hudSide = array_create(maxp, 0),
		n = 0;
		
	for(var i = 0; i < maxp; i++) if(player_is_local_nonsync(i)) _hudSide[i] = (n++ & 1);
	for(var i = 0; i < maxp; i++) if(!player_is_local_nonsync(i)) _hudSide[i] = (n++ & 1);

	 // Player HUD:
	for(var _index = 0; _index < maxp; _index++) if(player_is_active(_index)){
		var _player = player_find(_index),
			_side = _hudSide[_index],
			_flip = (_side ? -1 : 1),
			_HUDVisible = (_visible && player_get_show_hud(_index, player_find_local_nonsync())),
			_HUDMain = (player_find_local_nonsync() == _index);
			
		draw_set_projection(2, _index);
		
		 // Draw Main Local Player to Surface for Pause Screen:
		if(_HUDMain){
			with(_surfHUD) if(surface_exists(surf)){
				_ox -= x;
				_oy -= y;
				surface_set_target(surf);
			}
		}
		
		if(instance_exists(_player)){
			 // Non-nonsync Stuff:
			with(_player){
				 // Bonus HP:
				if("my_health_bonus" in self){
					if("my_health_bonus_hud" not in self){
						my_health_bonus_hud = 0;
					}
					my_health_bonus_hud += ((my_health_bonus > 0) - my_health_bonus_hud) * 0.5 * current_time_scale;
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
				with(instances_matching_gt(_player, "ammo_bonus", 0)){
					_surfHUD.active = true;
					
					 // Subtle Color Wave:
					var _text = `+${ammo_bonus}`;
					for(var i = 1; i <= string_length(_text); i++){
						var a = `@(color:${merge_color(c_aqua, c_blue, 0.1 + (0.05 * sin(((current_frame + (i * 8)) / 20) + ammo_bonus)))})`;
						_text = string_insert(a, _text, i);
						i += string_length(a);
					}
					
					draw_text_nt(_ox + 66, _oy + 30 - (_players > 1), _text);
				}
				
				 // Bonus HP HUD:
				with(instances_matching_ne(_player, "my_health_bonus", null)){
					var _x1 = _ox + 106 - (85 * _side),
						_y1 = _oy + 5,
						_x2 = _x1 + (3 * my_health_bonus_hud * _flip),
						_y2 = _y1 + 10;
						
					if((!_side && _x2 > _x1 + 1) || (_side && _x1 > _x2 + 1)){
						_surfHUD.active = true;
						
						draw_set_color(c_black);
						draw_rectangle(_x1, _y1 - 1, _x2 + _flip, _y2 + 2, false); // Shadow
						draw_set_color(c_white);
						draw_rectangle(_x1, _y1, _x2, _y2, false); // Outline
						draw_set_color(c_black);
						draw_rectangle(_x1, _y1 + 1, _x2 - _flip, _y2 - 1, false); // Inset
						
						 // Filling:
						if(my_health_bonus > 0){
							if(sprite_index == spr_hurt && image_index < 1){
								draw_set_color(c_white);
							}
							else{
								draw_set_color(merge_color(c_aqua, c_blue, 0.15 + (0.05 * sin(current_frame / 40))));
							}
							
							draw_rectangle(_x1, _y2 - max(1, my_health_bonus), _x2 - _flip, _y2 - 1, false);
						}
					}
				}
				
				with(instances_matching(_player, "race", "parrot")){
					_surfHUD.active = true;
					
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
							var _x1 = _x + _HPw + 2,
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
					var _x = _ox + 116 - (104 * _side) + (3 * variable_instance_get(id, "my_health_bonus_hud", 0) * _flip),
						_y = _oy + 11,
						_spr = spr_feather,
						_output = feather_num_mult,
						_feathers = instances_matching(instances_matching(CustomObject, "name", "ParrotFeather"), "creator", id),
						_hudGoal = [feather_ammo, 0];
						
					with(instances_matching_ne(_feathers, "canhud", true)) if(canhold) canhud = true;
					for(var i = 0; i < array_length(_hudGoal); i++){
						_hudGoal[i] += array_length(instances_matching(_feathers, "canhud", true));
					}
					
					for(var i = 0; i < array_length(feather_ammo_hud); i++){
						var _hud = feather_ammo_hud[i],
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
						draw_sprite_ext(spr.Race.parrot[bskin].FeatherHUD, 0, _dx, _dy, _xsc, _ysc, 0, c_white, 1);
						_dx -= sprite_get_xoffset(_spr) * _xsc;
						_dy -= sprite_get_yoffset(_spr) * _ysc;
						for(var j = 0; j < array_length(_hud); j++){
							if(_hud[j] > 0){
								var _l = 0,
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
										if(fork()){
											 // Paused:
											for(var n = 0; n < maxp; n++) if(button_pressed(n, "paus")){
												exit;
											}
											
											draw_set_fog(true, merge_color(_skinCol, c_white, 1), 0, 0);
											draw_sprite_part_ext(_spr, 0, _l, _t, _w, _h, _dx + _l, _dy + _t, _xsc, _ysc, _col, _flashAlpha);
											
											exit;
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
								if(fork()){
									for(var i = 0; i < maxp; i++) if(button_pressed(i, "paus")){
										drawlowhp = 0;
										exit;
									}
									
									draw_set_font(fntM);
									draw_set_halign(fa_left);
									draw_set_valign(fa_top);
									draw_text_nt(110, 7, `@(color:${c_red})LOW HP`);
									
									exit;
								}
							}
						}
					}
				}
			}
		}
		
		 // Main Player Surface Finish:
		if(_HUDMain){
			surface_reset_target();
			with(_surfHUD) if(surface_exists(surf)){
				if(_HUDVisible) draw_surface(surf, x, y);
				_ox += x;
				_oy += y;
			}
		}
	}
	
	draw_reset_projection();
	
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

					var l = min(point_distance(_x, _y, x, y), 16 * min(1, 28 / point_distance(_x, _y, x, y))),
						d = point_direction(_x, _y, x, y);

					_x += lengthdir_x(l, d);
					_y += lengthdir_y(l, d);
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
	}

	 // Pet Indicator:
	with(instances_matching(CustomHitme, "name", "Pet")){
		var _dead = (maxhealth > 0 && my_health <= 0);
		if("index" in leader && player_is_local_nonsync(leader.index) && ((visible && !point_seen(x, y, leader.index)) || _dead)){
			var _icon = pet_get_mapicon(mod_type, mod_name, pet);
			
			if(sprite_exists(_icon.spr)){
				var _x = x + _icon.x,
					_y = y + _icon.y;
						
				 // Death Pointer:
				if(_dead){
					_y -= 20 + sin(wave / 10);
					draw_sprite_ext(spr.PetArrow, _icon.img, _x, _y + (sprite_get_height(_icon.spr) - sprite_get_yoffset(_icon.spr)), _icon.xsc, _icon.ysc, 0, _icon.col, _icon.alp);
				}
				
				 // Icon:
				var	_x1 = sprite_get_xoffset(_icon.spr),
					_y1 = sprite_get_yoffset(_icon.spr),
					_x2 = _x1 - sprite_get_width(_icon.spr) + game_width,
					_y2 = _y1 - sprite_get_height(_icon.spr) + game_height;
					
				_x = _vx + clamp(_x - _vx, _x1 + 1, _x2 - 1);
				_y = _vy + clamp(_y - _vy, _y1 + 1, _y2 - 1);
				
				draw_sprite_ext(_icon.spr, _icon.img, _x, _y, _icon.xsc, _icon.ysc, _icon.ang, _icon.col, _icon.alp);
				
				 // Death Indicating:
				if(_dead){
					var _flashLength = 15,
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
	with(instances_matching(CustomObject, "name", "AlertIndicator")) if(visible == true){
		var _sprite = sprite_index,
			_x1 = sprite_get_xoffset(_sprite),
			_y1 = sprite_get_yoffset(_sprite),
			_x2 = _x1 - sprite_get_width(_sprite) + game_width,
			_y2 = _y1 - sprite_get_height(_sprite) + game_height,
			_x = _vx + clamp(x - _vx, _x1 + 1, _x2 - 1),
			_y = _vy + clamp(y - _vy, _y1 + 1, _y2 - 1);
			
		if(flash_active) d3d_set_fog(true, image_blend, 0, 0);
		draw_sprite_ext(sprite_index, image_index, _x, _y, image_xscale, image_yscale, image_angle, image_blend, abs(image_alpha) - fade);
		if(flash_active) d3d_set_fog(false, c_white, 0, 0);
	}
	
	draw_set_font(fntM);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	
	instance_destroy();
	
#define ntte_menu()
	if(MenuOpen){
		for(var _index = 0; _index < maxp; _index++) if(player_is_active(_index)){
			if(player_is_local_nonsync(_index) && _index != player_find_local_nonsync()){
				continue; // Only Allow the Main Local Player / Non-Local Players Through
			}
			
			draw_set_visible_all(false);
			draw_set_visible(_index, true);

			draw_set_projection(0);
			
			var	_menuCurrent = MenuSlct[_index],
				_vx = view_xview[_index],
				_vy = view_yview[_index],
				_mx = mouse_x[_index],
				_my = mouse_y[_index],
				_local = player_is_local_nonsync(_index),
				_tooltip = "";
				
			/// Menu Swap:
				var _tx = game_width - 3,
					_ty = 35 + min(3, 2 * MenuSplat);
					
				draw_set_halign(fa_right);
				draw_set_valign(fa_top);
				draw_set_font(fntSmall);
				
				 // Splat:
				draw_sprite_ext(sprBossNameSplat, MenuSplat, _tx - 15 - MenuSplat, _ty + 17, 1, 1, 90, c_white, 1);
				
				 // Cycle Through Menus:
				if(button_pressed(_index, "swap")){
					_menuCurrent = ((_menuCurrent + 1) % lq_size(MenuList));
				}
				
				 // Menu List:
				for(var m = 0; m < lq_size(MenuList); m++){
					var _text = lq_get_key(MenuList, m),
						_hover = false,
						_current = (MenuSlct[_index] == m);
						
					 // Selecting:
					if(!_current){
						if(point_in_rectangle(
							_mx - _vx,
							_my - _vy,
							_tx - 40,
							_ty,
							_tx + 2,
							_ty + 1 + string_height(_text)
						)){
							_hover = true;
							if(MenuPop[_index] >= 3 && button_pressed(_index, "fire")){
								_menuCurrent = m;
							}
						}
					}
					
					 // Text:
					draw_text_nt(_tx - _current, _ty, (_current ? "" : (_hover ? "@s" : "@d")) + _text);
					_ty += string_height(_text) + 2;
				}
				
				 // Menu Swapped:
				if(_menuCurrent != MenuSlct[_index]){
					MenuPop[_index] = 0;
					
					 // Sound:
					switch(_menuCurrent){
						case menu_options:	sound_play(sndMenuOptions);	break;
						case menu_stats:	sound_play(sndMenuStats);	break;
						case menu_credits:	sound_play(sndMenuCredits);	break;
						default:			sound_play(sndClick);
					}
				}
				
			 // Menu Code:
			var _menu = lq_get_value(MenuList, _menuCurrent),
				_menuList = lq_defget(_menu, "list", []),
				_menuSlct = lq_defget(_menu, "slct", []),
				_menuX = (game_width  / 2) + lq_defget(_menu, "x", 0),
				_menuY = (game_height / 2) + lq_defget(_menu, "y", 0);
				
			draw_set_font(fntM);
			
			MenuPop[_index] += current_time_scale;
			var _pop = floor(MenuPop[_index]);
			
			switch(_menuCurrent){
				case menu_options:
					draw_set_halign(fa_left);
					draw_set_valign(fa_middle);
					
					 // Arrow Key Selection Change:
					var _moveOption = sign(button_pressed(_index, "sout") - button_pressed(_index, "nort"));
					if(_moveOption != 0){
						var m = _menuSlct[_index];
						do{
							m += _moveOption;
							m = ((m + array_length(_menuList)) % array_length(_menuList));
						}
						until (_menuList[m].type >= 0);
						_menuSlct[_index] = m;
					}
					
					 // Option Selecting & Splat:
					for(var i = 0; i < array_length(_menuList); i++){
						var _option = _menuList[i];
						with(_option) appear = (i + 3);
						
						 // Select:
						var	_hover = (point_in_rectangle(_mx - _vx, _my - _vy, _menuX - 80, _menuY - 8, _menuX + 159, _menuY + 6) && (_mx < _vx + game_width - 48 || _my > _vy + 64)),
							_selected = (_menuSlct[_index] == i);
							
						if(_hover || _selected){
							if(_option.type >= 0){
								if(
									!_hover
									|| _mx != global.mouse_x_previous[_index]
									|| _my != global.mouse_y_previous[_index]
								){
									_menuSlct[_index] = i;
								}
							}
							
							with(_option) if(_pop >= appear){
								var	_click = button_pressed(_index, "fire"),
									_confirm = ((_click && _hover) || button_pressed(_index, "okay"));
									
								 // Click:
								if(type >= 0){
									if(!clicked[_index]){
										if(_confirm){
											if(_click) clicked[_index] = true;
											if(_selected) switch(type){
												case opt_slider:
													if(_click) sound_play(sndSlider);
													break;
													
												default:
													sound_play(sndClick);
													break;
											}
										}
									}
									else if(!button_check(_index, "fire")){
										clicked[_index] = false;
										if(_selected) switch(type){
											case opt_slider:
												sound_play(sndSliderLetGo);
												break;
										}
									}
								}
								
								 // Option Specifics:
								if(_selected && (sync || _local)) switch(type){
									case opt_toggle:
										if(_confirm){
											option_set(varname, (option_get(varname, 0) + 1) % array_length(pick));
										}
										break;
										
									case opt_slider:
										if(_hover && button_check(_index, "fire") && clicked[_index]){
											var _slider = clamp(round((_mx - _vx) - (_menuX + 40)) / 100, 0, 1);
											option_set(varname, _slider);
										}
										else{
											var _adjust = 0.1 * sign(button_pressed(_index, "east") - button_pressed(_index, "west"));
											if(_adjust != 0){
												option_set(varname, clamp(option_get(varname, 0) + _adjust, pick[0], pick[1]));
											}
										}
										break;
								}
								
								 // Description on Hover:
								if(_hover && "text" in self){
									//if(!button_check(_index, "fire") || type == opt_title){
										if(_mx < _vx + (game_width / 2) + 32){
											_tooltip = text;
										}
									//}
								}
							}
						}
						else _option.clicked[_index] = false;
						
						with(_option){
							if(type == opt_title) _menuY += 2;
							x = _menuX;
							y = _menuY;
							
							if(_pop >= appear){
								 // Appear Pop:
								if(_pop == appear && MenuPop[_index] - _pop <= current_time_scale){
									sound_play_pitch(sndAppear, random_range(0.5, 1.5));
								}
								
								 // Selection Splat:
								if(_local){
									if(_moveOption == 0){
										splat += ((_menuSlct[_index] == i) ? 1 : -1) * current_time_scale;
										splat = clamp(splat, 0, sprite_get_number(sprMainMenuSplat) - 1);
									}
									if(splat > 0) with(other) draw_sprite(sprMainMenuSplat, other.splat, _menuX, _menuY);
								}
							}
						}
						_menuY += 16;
					}
					
					 // Option Text:
					if(_local){
						var _titleFound = false;
						for(var i = 0; i < array_length(_menuList); i++){
							var _option = _menuList[i],
								_selected = (_local && _menuSlct[_index] == i);
								
							with(_option) if(_pop >= appear){
								 // Option Name:
								var	_x = x - 80,
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
								if(_pop < (appear + 1)) _y++;
								
								draw_text_shadow(_x, _y, _name);
								
								 // Option Specifics:
								_x += 124;
								var _value = option_get(varname, 0);
								with(other){
									switch(other.type){
										case opt_toggle:
											draw_text_shadow(_x, _y, other.pick[clamp(_value, 0, array_length(other.pick) - 1)]);
											break;
											
										case opt_slider:
											var	_dx = _x - 5,
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
											var	_active = in_range(_menuSlct[_index], i, i + 2),
												_spr = spr.GullIdle,
												_img = (current_frame * 0.4),
												_scale = [
													1/3 + (2/3 * option_get("waterQualityMain", 1)),
													1/2 + (1/2 * option_get("waterQualityTop", 1))
												],
												_sx = _x - 32,
												_sy = _y + 12;
												
											for(var s = 0; s < array_length(_scale); s++){
												var	_sw = sprite_get_width(_spr) * _scale[s],
													_sh = sprite_get_height(_spr) * _scale[s],
													_surf = surface_create(_sw, _sh);
													
												 // Quality Visual:
												surface_set_target(_surf);
												draw_clear_alpha(0, 0);
												
												var	_dx = (_sw / 2),
													_dy = (_sh / 2) - ((2 + sin(current_frame / 10)) * _scale[s]);
													
												draw_sprite_ext(_spr, _img, _dx, _dy, _scale[s], _scale[s], 0, (_active ? c_white : c_gray), 1);
												
												surface_reset_target();
												draw_set_projection(0);
												
												 // Draw Clipped/Colored Surface:
												if(s == 0){
													var b = merge_color(make_color_rgb(44, 37, 122), make_color_rgb(27, 118, 184), 0.25 + (0.25 * sin(current_frame / 30)));
													draw_set_fog(true, (_active ? b : merge_color(b, c_black, 0.5)), 0, 0);
													draw_surface_part_ext(_surf, 0, (_sh / 2), _sw, (_sh / 2), _sx, _sy + ((_sh / 2) / _scale[s]), 1 / _scale[s], 1 / _scale[s], c_white, 1);
													draw_set_fog(false, 0, 0, 0);
												}
												else{
													draw_surface_part_ext(_surf, 0, 0, _sw, (_sh / 2) + 1, _sx,	_sy, 1/_scale[s], 1/_scale[s], c_white, 1);
													draw_set_fog(true, (_active ? c_white : c_gray), 0, 0);
													draw_surface_part_ext(_surf, 0,	(_sh / 2), _sw, 1, _sx, _sy + ((_sh / 2) / _scale[s]), 1/_scale[s], 1/_scale[s], c_white, 0.8);
													draw_set_fog(false, 0, 0, 0);
												}
												
												surface_destroy(_surf);
											}
											break;
									}
								}
							}
						}
					}
					
					break;
					
				case menu_stats:
					
					var _statSlct = _menuSlct[_index];
					
					/// Stat Menu Swap:
						var _tx = game_width,
							_ty = game_height - 36;
							
						 // Splat:
						var _spr = sprLoadoutSplat;
						draw_sprite(_spr, min(_pop, sprite_get_number(_spr) - 1), _tx, _ty);
						
						 // Cycle Through:
						if(button_pressed(_index, "pick")){
							_statSlct = ((_statSlct + 1) % lq_size(_menuList));
						}
						
						 // Tabs:
						_tx -= 4;
						_ty -= 4;
						draw_set_halign(fa_right);
						draw_set_valign(fa_bottom);
						for(var i = lq_size(_menuList) - 1; i >= 0; i--){
							var _text = lq_get_key(_menuList, i),
								_hover = false,
								_selected = (_menuSlct[_index] == i);
							
							 // Selecting:
							if(!_selected && point_in_rectangle(
								_mx - _vx,
								_my - _vy,
								_tx - 68,
								_ty - string_height(_text) - 1,
								_tx + 4,
								_ty
							)){
								_hover = true;
								
								 // Select:
								if(button_pressed(_index, "fire")){
									_statSlct = i;
								}
							}
							
							draw_text_nt(_tx - _selected, _ty + (_pop <= 1), (_selected ? "" : (_hover ? "@s" : "@d")) + _text);
							
							_ty -= string_height(_text) + 2;
						}
						
						 // Swapped:
						if(_statSlct != _menuSlct[_index]){
							_menuSlct[_index] = _statSlct;
							
							_pop = 2;
							MenuPop[_index] = _pop;

							switch(lq_get_key(_menuList, _statSlct)){
								case "pets":	sound_play_pitch(sndMenuStats, 1.2);	break;
								case "other":	sound_play_pitch(sndMenuScores, 1.1);	break;
								default:		sound_play(sndMenuStats);
							}
						}
					
					 // Stat Menus:
					var _statMenu = lq_get_value(_menuList, _statSlct),
						_statX = _menuX + lq_defget(_statMenu, "x", 0),
						_statY = _menuY + lq_defget(_statMenu, "y", 0),
						_statDraw = [];

					switch(lq_get_key(_menuList, _statSlct)){
						case "mutants":
						
							var	_raceList = _statMenu.list,
								_raceSlct = _statMenu.slct,
								_raceCurrent = lq_get_key(_raceList, _raceSlct[_index]);
								
							if(is_undefined(_raceCurrent)) _raceCurrent = "";
							
							 // Locked:
							if(mod_script_exists("race", _raceCurrent, "race_avail")){
								var a = mod_script_call("race", _raceCurrent, "race_avail");
								if(is_real(a) && !a){
									_raceCurrent = "";
								}
							}
							
							/// Character Swap:
								 // Splat:
								var _x = 0,
									_y = 36,
									_spr = sprUnlockPopupSplat;
									
								if(!instance_exists(BackMainMenu)){
									draw_sprite_ext(_spr, clamp(_pop - 2, 0, sprite_get_number(_spr) - 1), _x, _y, 1, 1, 180, c_white, 1);
								}
								else _x -= 16;
								
								 // Icons:
								if(_pop >= 4){
									_x += 40;
									_y += 10;
									for(var i = 0; i < lq_size(_raceList); i++){
										var	_race = lq_get_key(_raceList, i),
											_avail = true;
											
										 // Locked:
										if(mod_script_exists("race", _race, "race_avail")){
											_avail = mod_script_call("race", _race, "race_avail");
											if(!is_real(_avail)) _avail = true;
										}
										
										var	_selected = (_raceSlct[_index] == i && _avail),
											_sprt = mod_script_call("race", _race, "race_mapicon", _index, 0);
											
										if(!is_real(_sprt) || !sprite_exists(_sprt)) _sprt = sprMapIconChickenHeadless;
										
										 // Selection:
										var _hover = false;
										if(!_selected && point_in_rectangle(
											_mx - _vx,
											_my - _vy,
											_x - 8,
											_y - 8,
											_x + 8,
											_y + 8
										)){
											_hover = true;
											if(!_avail) _tooltip = "LOCKED";
											
											 // Select:
											if(button_pressed(_index, "fire")){
												if(_avail){
													_raceSlct[_index] = i;
													_pop = 4;
													MenuPop[_index] = _pop;
													sound_play((i & 1) ? sndMenuBSkin : sndMenuASkin);
												}
												
												 // Locked:
												else{
													sound_play(sndNoSelect);
													_selected = true;
												}
											}
										}
										
										if(!_avail) draw_set_fog(true, make_color_hsv(0, 0, 22 * (1 + _hover)), 0, 0);
										draw_sprite_ext(_sprt, 0.4 * current_frame, _x, _y - _selected, 1, 1, 0, (_selected ? c_white : (_hover ? c_silver : c_gray)), 1);
										if(!_avail) draw_set_fog(false, 0, 0, 0);
										
										_x += 32;
									}
									
									 // Temporary:
									if(instance_exists(Menu) && unlock_get("parrot")){
										_y -= 2;
										
										var _hover = point_in_rectangle(_mx - _vx, _my - _vy, _x - 12, _y - 8, _x + 12, _y + 8);
										
										if(_hover && button_pressed(_index, "fire")){
											sound_play(sndNoSelect);
											_y += choose(-1, 1);
										}
										
										draw_set_fog(true, make_color_hsv(0, 0, (_hover ? 50 : 30)), 0, 0);
										draw_sprite(sprMapIcon, 4, _x, _y - _hover)
										draw_set_fog(false, 0, 0, 0);
										
										//draw_set_halign(fa_center);
										//draw_set_valign(fa_middle);
										//draw_text_nt(_x, _y + (_hover * sin(current_frame / 10)), (_hover ? "@s" : "@d") + "COMING#SOON")
										
										if(_hover) _tooltip = "@sCOMING#SOON@w?";
									}
								}
								
								 // Get Stats to Display:
								with(lq_defget(_raceList, _raceCurrent, [])){
									with(list) if(stat_get(self[1]) != 0){
										array_push(_statDraw, other);
										break;
									}
								}
								
							/// Portrait:
								var	_sprt = sprBigPortraitChickenHeadless,
									_x = 0,
									_y = game_height,
									_portX = (90 * min(0, _pop - 5)) - min(2, (_pop - 5) * 2);
									
								if(mod_script_exists("race", _raceCurrent, "race_portrait")){
									_sprt = mod_script_call("race", _raceCurrent, "race_portrait", _index, 0)
									if(sprite_exists(_sprt)){
										draw_sprite(_sprt, 0.4 * current_frame, _x + _portX, _y);
									}
								}
								
								 // Splat:
								var _spr = sprCharSplat;
								draw_sprite(_spr, clamp(_pop - 1, 0, sprite_get_number(_spr) - 1), _x, _y - 36);
								
								 // Name:
								draw_set_color(c_white);
								draw_set_font(fntBigName);
								draw_set_halign(fa_left);
								draw_set_valign(fa_top);
								if(mod_script_exists("race", _raceCurrent, "race_name")){
									var _text = mod_script_call("race", _raceCurrent, "race_name");
									if(is_string(_text)){
										draw_text_bn(_x + 6 + (_portX * 1.5), _y - 80, _text, 1.5);
									}
								}
								else{
									draw_text_bn(_x + 16 + (_portX * 0.6), _y - 80, "NONE", 1.5);
								}
								
							break;
							
						case "pets":
							
							var _petSlct = _statMenu.slct;
							
							 // Add Any Pets Found in Stats:
							var _petStatList = lq_defget(lq_defget(sav, "stat", {}), "pet", {}),
								_list = array_clone(_statMenu.list);
								
							for(var i = 0; i < lq_size(_petStatList); i++){
								var k = lq_get_key(_petStatList, i);
								if(!array_exists(_list, k)) array_push(_list, k);
							}
							
							 // Compile Pet List:
							var _petList = {};
							with(_list){
								var _pet = self,
									_split = string_split(_pet, ".");
									
								if(array_length(_split) >= 3){
									var _petName = _split[0],
										_modName = array_join(array_slice(_split, 1, array_length(_split) - 2), "."),
										_modType = _split[array_length(_split) - 1],
										_petStat = lq_defget(_petStatList, _pet, {});
										
									if(mod_exists(_modType, _modName)){
										var _avail = (lq_defget(_petStat, "found", 0) > 0 || lq_defget(_petStat, "owned", 0) > 0);
										
										 // Auto-Select First Unlocked Pet:
										if(_avail && _petSlct[_index] == ""){
											_petSlct[_index] = _pet;
										}
										
										lq_set(_petList, _pet, {
											"name"		: _split[0],
											"mod_name"	: array_join(array_slice(_split, 1, array_length(_split) - 2), "."),
											"mod_type"	: _split[array_length(_split) - 1],
											"stat"		: _petStat,
											"avail"		: _avail
										});
									}
								}
							}
							
							 // Splat:
							var _x = (instance_exists(BackMainMenu) ? -48 : -96),
								_y = game_height - 36,
								_spr = sprLoadoutOpen;
								
							draw_sprite_ext(_spr, clamp(_pop - 1, 0, (instance_exists(BackMainMenu) ? 1 : sprite_get_number(_spr) - 1)), _x, _y, -1, (game_height - 72) / (240 - 72), 0, c_white, 1);
							
							 // Icons:
							if(_pop >= 3){
								var	_col = min(4, floor(sqrt(lq_size(_petList)))),
									_w = 13,
									_h = 13,
									_x = 40 - round(_w * ((_col - 1) / 2)) - (2 * (_pop <= 3)) + (_pop == 4),
									_y = 96;
									
								 // Arrow Key Selection:
								var _swaph = (button_pressed(_index, "east") - button_pressed(_index, "west")),
									_swapv = (button_pressed(_index, "sout") - button_pressed(_index, "nort")) * _col;
									
								if(_swaph != 0 || _swapv != 0){
									 // Get Current Pet Index:
									var _slct = -1;
									for(var i = 0; i < lq_size(_petList); i++){
										if(lq_get_key(_petList, i) == _petSlct[_index]){
											_slct = i;
											break;
										}
									}
									
									 // Swap:
									if(_slct >= 0) while(true){
										var _max = ceil(lq_size(_petList) / _col) * _col;
										_slct = (_slct + _swaph + _swapv + _max) % _max;
										
										 // Back at Start:
										if(lq_get_key(_petList, _slct) == _petSlct[_index]){
											break;
										}
										
										 // New Selection:
										if(lq_defget(lq_get_value(_petList, _slct), "avail", false)){
											_petSlct[_index] = lq_get_key(_petList, _slct);
											
											_pop = 4;
											MenuPop[_index] = _pop;
											sound_play((_slct & 1) ? sndMenuBSkin : sndMenuASkin);
											
											break;
										}
									}
								}
								
								for(var i = 0; i < lq_size(_petList); i++){
									var _pet = lq_get_key(_petList, i),
										_info = lq_get_value(_petList, i),
										_icon = pet_get_mapicon(_info.mod_type, _info.mod_name, _info.name),
										_avail = _info.avail,
										_hover = false,
										_selected = (_petSlct[_index] == _pet && _avail);
										
									 // Selecting:
									if(!_selected && point_in_rectangle(
										_mx - _vx,
										_my - _vy,
										_x - 6,
										_y - 6,
										_x + 6,
										_y + 6
									)){
										_hover = true;
										_tooltip = (_avail ? _info.name : "UNKNOWN");
										
										 // Select:
										if(button_pressed(_index, "fire")){
											if(_avail){
												_petSlct[_index] = _pet;
												
												_pop = 4;
												MenuPop[_index] = _pop;
												sound_play((i & 1) ? sndMenuBSkin : sndMenuASkin);
											}
											
											 // No:
											else{
												sound_play(sndNoSelect);
												_selected = true;
											}
										}
									}
									
									if(!_avail) draw_set_fog(true, make_color_hsv(0, 0, 22 * (1 + _hover)), 0, 0);
									
									draw_sprite_ext(_icon.spr, _icon.img, _x + _icon.x, _y + _icon.y - _selected, _icon.xsc, _icon.ysc, _icon.ang, merge_color(_icon.col, c_black, (_selected || _hover) ? 0 : 0.5), _icon.alp);
									
									if(!_avail) draw_set_fog(false, 0, 0, 0);
									
									_x += _w;
									if((i % _col) == _col - 1){
										_x -= (_w * _col);
										_y += _h;
									}
								}
							}
							
							var	_pet = lq_get(_petList, _petSlct[_index]);
							
							 // Name:
							var _appear = 5;
							if(_pop >= _appear){
								draw_set_color(c_white);
								draw_set_font(fntBigName);
								draw_set_halign(fa_left);
								draw_set_valign(fa_top);
								draw_text_bn(28 + (2 * max(0, (_appear + 1) - _pop)), 46, (_pet != null ? (_pet.avail ? _pet.name : "UNKNOWN") : "NONE"), 1.5);
							}
							
							 // Get Stats to Display:
							if(_pet != null && _pet.avail){
								var	_stat = { name : "", list : [] },
									_scrt = _pet.name + "_stat",
									_statPath = `pet/${_pet.name}.${_pet.mod_name}.${_pet.mod_type}/`;
									
								for(var i = -1; i < lq_size(_pet.stat); i++){
									var	_name = ((i < 0) ? "" : lq_get_key(_pet.stat, i)),
										_value = lq_get_value(_pet.stat, i),
										_type = ((_name == "owned") ? stat_time : stat_base);
										
									 // Call Stats Script:
									if(mod_script_exists(_pet.mod_type, _pet.mod_name, _scrt)){
										var s = mod_script_call(_pet.mod_type, _pet.mod_name, _scrt, _name, _value);
										if(s != 0){
											if(is_array(s)){
												if(array_length(s) > 0) _name = s[0];
												if(array_length(s) > 1){
													_value = s[1];
													_type = stat_display;
												}
											}
											else _name = s;
										}
									}
									
									if(_name != ""){
										 // Title:
										if(i < 0){
											if(is_real(_name) && sprite_exists(_name)){
												_name = `@(${s}:-0.4)# `;
											}
											_stat.name = string(_name);
										}
										
										 // Stat:
										else array_push(_stat.list, [
											string(_name),
											((_type == stat_display) ? _value : (_statPath + lq_get_key(_pet.stat, i))),
											_type
										]);
									}
								}
								
								array_push(_statDraw, _stat);
							}
								
							break;
							
						case "other":
						
							var _otherList = _statMenu.list;
							
							 // Splat:
							var _x = -64,
								_y = game_height - 36,
								_spr = sprLoadoutOpen;
								
							draw_sprite_ext(_spr, clamp(_pop - 1, 0, sprite_get_number(_spr) - 1), _x, _y, -1, (game_height - 72) / (240 - 72), 0, c_white, 1);
							
							 // Draw Categories:
							var	_appear = 5,
								_sx = 6 + (2 * max(0, (_appear + 1) - _pop)),
								_sy = 44;
								
							draw_set_halign(fa_left);
							draw_set_valign(fa_top);
							
							with(_otherList){
								 // Name:
								draw_set_font(fntBigName);
								if(_pop >= _appear){
									var _scale = 0.95;
									draw_set_color(c_black);
									draw_text_transformed(_sx + 1, _sy,     name, _scale, _scale, 0);
									draw_text_transformed(_sx,     _sy + 2, name, _scale, _scale, 0);
									draw_text_transformed(_sx + 1, _sy + 2, name, _scale, _scale, 0);
									draw_set_color(c_white);
									draw_text_transformed(_sx,     _sy,     name, _scale, _scale, 0);
								}
								_sy += string_height(name) + 4;
								
								 // Main Drawing:
								switch(name){
									case "AREA UNLOCKS":
										
										if(_pop >= _appear){
											draw_set_font(fntM);
											
											var _slct = _statMenu.slct
											
											 // Auto Select First Unlocked:
											if(!unlock_get(list[_slct[_index], 0])){
												for(var i = 0; i < array_length(list); i++){
													if(unlock_get(list[i, 0])){
														_slct[_index] = i;
														break;
													}
												}
											}
											
											 // Up/Down Select:
											var	_slctSwap = _slct[_index],
												s = ((button_pressed(_index, "sout") || button_pressed(_index, "east")) - (button_pressed(_index, "nort") || button_pressed(_index, "west")));
												
											while(s != 0){
												_slctSwap = (_slctSwap + s + array_length(list)) % array_length(list);
												if(unlock_get(list[_slctSwap, 0]) || _slctSwap == _slct[_index]){
													break;
												}
											}
											
											with(list){
												var	_unlock = unlock_get(self[0]),
													_unlockList = self[1],
													_name = (_unlock ? mod_script_call_nc("mod", "telib", "unlock_get_name", self[0]) : "LOCKED"),
													_selected = (_unlock && _slct[_index] == array_find_index(other.list, self)),
													_hover = false;
													
												if(_selected){
													with(UberCont){
														var _dx = _sx + 116,
															_dy = _sy;
															
														 // Splat:
														var	_spr = sprKilledBySplat,
															_img = min(_pop - (_appear + 1), sprite_get_number(_spr) - 1);
															
														if(_img >= 0){
															draw_sprite(_spr, _img, _dx + 32, _dy - (string_height(_name) / 2));
														}
														
														 // Unlocks:
														_dy += 2;
														for(var i = 0; i < array_length(_unlockList); i++){
															var _unlockAppear = _appear + 2 + i;
															if(_pop >= _unlockAppear){
																var	_split = string_split(_unlockList[i], "."),
																	_modType = _split[array_length(_split) - 1],
																	_modName = array_join(array_slice(_split, 0, array_length(_split) - 1), "."),
																	_found = unlock_get("found(" + _unlockList[i] + ")");
																	
																if(_modType == "wep") _modType = "weapon";
																
																 // Get Sprite:
																var	_spr = -1,
																	_img = (_found ? ((_pop * 0.4) - (3 * i)) : 0);
																	
																if(mod_exists(_modType, _modName)){
																	switch(_modType){
																		case "weapon":
																			_spr = mod_variable_get(_modType, _modName, "sprWep");
																			if((_img % sprite_get_number(_spr)) < 2) _img = 0;
																			break;
																			
																		case "crown":
																			_spr = mod_variable_get(_modType, _modName, "sprCrownIdle");
																			break;
																	}
																}
																if((_img + sprite_get_number(_spr)) % ((1 + array_length(_unlockList)) * sprite_get_number(_spr)) >= sprite_get_number(_spr)){
																	_img = 0;
																}
																
																 // Loop Over:
																if(_dx + sprite_get_width(_spr) > game_width){
																	_dx = _sx + 124;
																	_dy += 16;
																}
																
																if(is_real(_spr) && sprite_exists(_spr)){
																	if(!_found){
																		 // Shadow:
																		draw_set_fog(true, c_black, 0, 0);
																		draw_sprite(
																			_spr,
																			_img,
																			_dx + sprite_get_xoffset(_spr) - (_pop == _unlockAppear),
																			_dy + 1
																		);
																		
																		 // Draw in Flat Gray:
																		draw_set_fog(true, make_color_hsv(0, 0, 28 + (10 * instance_exists(BackMainMenu))), 0, 0);
																	}
																	
																	draw_sprite(
																		_spr,
																		_img,
																		_dx + sprite_get_xoffset(_spr) - (_pop == _unlockAppear),
																		_dy
																	);
																	
																	_dx += 1 + sprite_get_width(_spr);
																	
																	if(!_found) draw_set_fog(false, 0, 0, 0);
																}
																
																 // Sound:
																if(_pop == _unlockAppear){
																	sound_play_pitch(sndAppear, 1 + (i * 0.05));
																}
															}
														}
													}
												}
												
												 // Selection:
												if(point_in_rectangle(_mx - _vx, _my - _vy, _sx, _sy, _sx + 120, _sy + string_height(_name))){
													_hover = true;
													if(button_pressed(_index, "fire")){
														_selected = true;
														
														if(_unlock){
															_slctSwap = array_find_index(other.list, self);
														}
														
														 // No:
														else sound_play(sndNoSelect);
													}
												}
												
												 // Name:
												draw_text_nt(
													_sx + (2 * _selected) - !_unlock,
													_sy,
													(_unlock ? (_selected ? "" : (_hover ? "@s" : "@d")) : `@(color:${make_color_hsv(0, 0, 25 + (15 * (_hover && !_selected)))})`) + _name
												);
												
												_sy += 1 + string_height(_name);
											}
											
											 // Selection Swapped:
											if(_slctSwap != _slct[_index]){
												_slct[_index] = _slctSwap;
												
												_pop = _appear + 1;
												MenuPop[_index] = _pop;
												sound_play_pitchvol(sndClick, 1 + (0.2 * _slct[_index]), 2/3);
											}
										}
										
										break;
										
									case "MISC":
									
										_statX = _sx + 44;
										_statY = _sy;
										_statDraw = { name : "", list : ((_pop >= _appear) ? list : []) };
										
										break;
								}
								
								_sy += 16;
							}
							
							break;
					}
					
					 // Draw Stats:	
					draw_set_font(fntM);
					draw_set_valign(fa_top);
					
					var	_x = _statX,
						_y = _statY,
						_appear = 5;
						
					if(is_object(_statDraw)) _statDraw = [_statDraw];
					
					if(array_length(_statDraw) > 0){
						with(_statDraw){
							if(_pop >= _appear){
								if(_pop == _appear) _x--;
								
								 // Category Name:
								draw_set_halign(fa_center);
								draw_text_nt(_x, _y, name);
								_y += string_height(name);
								
								 // Stats:
								with(list){
									var _name = self[0],
										_stat = self[1],
										_type = self[2];
										
									if(_type != stat_display){
										_stat = stat_get(_stat);
									}
									switch(_type){
										case stat_time:
											var t = "";
											t += string_lpad(string(floor((_stat / power(60, 2))     )), "0", 1); // Hours
											t += ":";
											t += string_lpad(string(floor((_stat / power(60, 1)) % 60)), "0", 2); // Minutes
											t += ":";
											t += string_lpad(string(floor((_stat / power(60, 0)) % 60)), "0", 2); // Seconds
											_stat = t;
											break;
									}
									_stat = string(_stat);
									
									draw_set_halign(fa_right);
									draw_text_nt(_x - 1, _y, "@s" + _name);
									
									draw_set_halign(fa_left);
									draw_text_nt(_x + 1, _y, _stat);
									
									_y += max(string_height(_name), string_height(_stat));
								}
								
								_y += string_height("A");
							}
							_appear += 2;
						}
					}
					
					 // No Stats to Display:
					else if(_pop >= _appear){
						draw_set_halign(fa_center);
						draw_set_valign(fa_middle);
						draw_text_nt(_x - 4 - (_pop == _appear), (game_height / 2), "@sNOTHING TO# DISPLAY YET!")
					}
					
					break;
					
				case menu_credits:
				
					var _links = _menuSlct[_index];
					
					for(var i = 0; i <= array_length(_menuList); i++){
						var _appear = 1 + floor(i / 2);
						if(_pop >= _appear){
							var	_side = ((i & 1) ? 1 : -1),
								_tx = _menuX + (_side * 8),
								_ty = _menuY + (32 * floor(i / 2)) - (_pop == _appear);
								
							draw_set_halign(_side ? fa_left : fa_right);
							draw_set_valign(fa_top);
							
							 // Link Mode Left Align:
							if(_links && !_side){
								_tx -= 128;
								draw_set_halign(fa_left);
							}
							
							 // Draw Credits:
							if(i < array_length(_menuList)){
								 // Name:
								draw_set_font(fntM);
								if(!_links || i < array_length(_menuList) - 1){ // No "Special Thanks" Name for Links
									draw_text_nt(_tx, _ty, _menuList[i].name);
								}
								_ty += string_height(_menuList[i].name);
								
								 // Links:
								if(_links){
									var	_link = _menuList[i].link,
										_font = fntChat;
										
									if(array_length(_link) >= 4) _font = fntSmall;
									
									if(_font == fntChat) _ty -= 3;
									
									draw_set_font(_font);
									
									with(_link){
										var _text = array_join(self, "");
										draw_text_nt(_tx, _ty, _text);
										_ty += string_height(_text) - (4 * (_font == fntChat));
									}
								}
								
								 // Roles:
								else{
									var _text = "";
									with(_menuList[i].role){
										_text += array_join(self, "") + "#@w";
									}
									
									draw_set_font(fntSmall);
									draw_text_nt(_tx, _ty, _text);
								}
							}
							
							 // Links/Roles Button:
							else{
								_tx += 32;
								_ty += 16;
								
								 // Hovering:
								var _hover = false;
								if(point_in_rectangle(
									mouse_x[_index] - view_xview[_index],
									mouse_y[_index] - view_yview[_index],
									_tx - 32,
									_ty - 20,
									_tx + 32,
									_ty + 20
								)){
									_hover = true;
								}
								
								 // Splat:
								var _spr = sprKilledBySplat;
								draw_sprite(_spr, min(_pop - _appear, sprite_get_number(_spr) - 1), _tx + 4, _ty - 6);
								
								 // Text:
								draw_set_font(fntM);
								draw_set_halign(fa_center);
								draw_set_valign(fa_middle);
								draw_text_nt(_tx - _hover + (!instance_exists(BackMainMenu) && _pop > _appear + 1), _ty, (_hover ? "" : "@s") + (_links ? "Roles" : "Links"));
							}
						}
					}
					
					 // Switch Between Roles/Links:
					if(_pop >= 3){
						if(button_pressed(_index, "fire")){
							_menuSlct[_index] = !_menuSlct[_index];
							sound_play_pitch(sndMenuCredits, (_menuSlct[_index] ? 1.3 : 1));
							MenuPop[_index] = 0;
						}
					}
					
					break;
			}

			draw_reset_projection();
			
			 // Tooltips:
			if(_local && _tooltip != ""){
				draw_tooltip(mouse_x_nonsync, mouse_y_nonsync, _tooltip);
			}
			
			MenuSlct[_index] = _menuCurrent;
		}
		
		draw_set_visible_all(true);
		draw_reset_projection();
    }
    
	 // Closed:
	else{
		MenuSplatOptions = 0;
		
		 // Reset Menus:
		for(var i = 0; i < maxp; i++){
			MenuSlct[i] = menu_base;
			MenuPop[i] = 0;
		}
		for(var i = 0; i < lq_size(MenuList); i++){
			var o = lq_get_value(MenuList, i);
			
			 // Selection:
			for(var j = 0; j < array_length(o.slct); j++){
				o.slct[j] = o.slct_default;
			}
			
			 // Options Splat:
			if(o == MenuList.options){
				for(var j = 0; j < array_length(o.list); j++){
					o.list[j].splat = 0;
				}
			}
		}
	}

#define CharSelect_draw_new(_inst)
	with(_inst) if(visible){
		draw_sprite(sprNew, image_index, view_xview_nonsync + xstart + (alarm1 > 0), view_yview_nonsync + ystart - mouseover);
	}
	instance_destroy();

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
            if(!collision_circle(x, y, 12, CampChar, true, true) && !place_meeting(x, y, TV)){
                break;
            }
        }

        return id;
    }

#define loadout_behind
    instance_destroy();

    var p = crownPlayer,
        _crown = lq_get(crownRace, player_get_race_fix(p));

	if(is_undefined(_crown)) exit;

	with(surfCrownHide) if(surface_exists(surf)){
		var	_surf = surf,
			_surfx = -60 - (w / 2),
			_surfy = -39 - (h / 2);

	    with(Loadout){
	        _surfy += (introsettle - (introsettle > 0));
			if(position_meeting(mouse_x[p], mouse_y[p], self)){
				_surfx--;
				_surfy--;
			}

			if(_crown.slct != crwn_none){
				with(surfCrownHideScreen) if(surface_exists(surf)){
					x = other.x - game_width;
					y = other.y - (game_height - 36);
					w = game_width;
					h = game_height;
	
					 // Capture Screen:
			        surface_set_target(surf);
			        draw_clear(c_black);
			        draw_set_blend_mode_ext(bm_one, bm_inv_src_alpha);
			        surface_screenshot(surf);
			        draw_set_blend_mode(bm_normal);
	
					with(other){
			        	surface_set_target(_surf);
			        	draw_clear_alpha(0, 0);
	
						 // Draw Mask of What to Hide (The Currently Selected Crown):
						draw_set_fog(true, c_black, 0, 0);
				        draw_sprite(sprLoadoutCrown, _crown.slct, 16, 16 + (introsettle > 0));
						draw_set_fog(false, 0, 0, 0);
	
						 // Lay Screen + Loadout Sprite Over Mask:
			        	draw_set_color_write_enable(true, true, true, false);
			        	draw_surface(other.surf, other.x - (x + _surfx), other.y - (y + _surfy));
			        	draw_sprite(sprLoadoutSplat, image_index, -_surfx, -_surfy);
			        	if(selected == true) draw_sprite(sprLoadoutOpen, openanim, -_surfx, -_surfy);
			        	draw_set_color_write_enable(true, true, true, true);
					}
		        }

	        	surface_reset_target();
			}
	    }

	    x = _surfx;
	    y = _surfy;
	}

	 // Fix Haste Hands:
	if(global.clock_fix){
		with(Loadout) if(selected == false){
			global.clock_fix = false;
			sprite_restore(sprClockParts);
		}
	}
	
	 // Cool Unused Splat:
	with(instances_matching(Loadout, "visible", true)){
		if(selected == true){
			closeanim = 0;
		}
		else{
			var _spr = sprLoadoutClose;
			if("closeanim" in self && closeanim < sprite_get_number(_spr)){
				draw_sprite(_spr, closeanim, view_xview_nonsync + game_width, view_yview_nonsync + game_height - 36);
				closeanim += current_time_scale;
				
				image_index = 0;
				image_speed_raw = image_number - 1;
			}
		}
	}

#define draw_crown
    var p = crownPlayer,
		_crown = lq_get(crownRace, player_get_race_fix(p)),
        _vx = view_xview_nonsync,
        _vy = view_yview_nonsync,
        _mx = mouse_x[p],
        _my = mouse_y[p],
        _surfScreen = -1,
        _surfCrown = -1,
        _w = 20,
        _h = 20,
        _cx = game_width - 102,
        _cy = 75;

	if(_crown == null){
		instance_destroy();
		exit;
	}

    for(var i = 0; i < array_length(_crown.icon); i++){
        var _icon = _crown.icon[i];
        if(instance_exists(_icon.inst)) with(_icon){
            x = _vx + _cx + (dix * crownIconW);
            y = _vy + _cy + (diy * crownIconH);

            if(!visible){
                addy = 2;

                 // Initial Crown Reading:
                with(inst) if(alarm_get(0) == 0) with(other){
                    visible = true;

                     // Capture Screen:
                    if(!surface_exists(_surfScreen)){
                        _surfScreen = surface_create(game_width, game_height);

                        surface_set_target(_surfScreen);
                        draw_clear(c_black);
                        surface_reset_target();
        
                        draw_set_blend_mode_ext(bm_one, bm_one);
                        surface_screenshot(_surfScreen);
                        draw_set_blend_mode(bm_normal);
                    }
                    
                     // Capture Crown Icon from Screen Capture:
                    if(!surface_exists(_surfCrown)){
                        _surfCrown = surface_create(_w, _h);
                    }
                    surface_set_target(_surfCrown);
                    draw_clear_alpha(0, 0);
                    draw_surface(_surfScreen, -(x - (_h / 2) - _vx), -(y + 2 - (_w / 2) - _vy));
                    surface_reset_target();
    
                     // Compare Size w/ Selected/Locked Variants to Determine Crown's Current State (Bro if LoadoutCrown gets exposed pls tell me):
                    var f = crownPath + string(crwn) + crownPathD;
                    surface_save(_surfCrown, f);
                    surface_destroy(_surfCrown);
                    file_load(f);
                    if(fork()){
                        wait 0;
                        var _size = file_size(f);
                        locked = (_size == crownSize[crwn].lock);
                        if(_size == crownSize[crwn].slct){
                            _crown.slct = crwn;
                        }
                        exit;
                    }
                }
            }
            else addy = 0;
        }
        else with(Loadout) if(selected == true){
        	_crown.icon = [];
        	_crown.custom.icon = [];
        }
    }

     // Manually Keep Track of Crown's Status:
    with(_crown.icon) if(visible){ 
        blnd = c_gray;

        with(other) if(instance_exists(other.inst)) with(other){
        	if(position_meeting(_mx, _my, inst)){
	             // Select:
	            if(!locked && button_pressed(p, "fire")){
	                if(_crown.custom.slct != -1 && crwn == _crown.slct){
	                    sound_play(sndMenuCrown);
	                }
	                _crown.slct = crwn;
	                _crown.custom.slct = -1;
	            }
	
	             // Hovering Over Button:
	            if(crwn != _crown.slct || _crown.custom.slct != -1){
	                addy--;
	                blnd = merge_color(c_gray, c_white, 0.6);
	            }
	        }
	
	         // Selected:
	        if(crwn == _crown.slct && _crown.custom.slct == -1){
	            addy -= 2;
	            blnd = c_white;
	        }
        }
    }

     // Crown Loadout Setup:
    if(instance_exists(LoadoutCrown)){
        if(array_length(_crown.icon) <= 0){
            var _crownList = array_flip(instances_matching(LoadoutCrown, "", null)),
                _col = 2,  // crwn_none column
                _row = -1; // crwn_none row

            for(var i = 0; i < array_length(_crownList); i++){
                array_push(_crown.icon, {
                    inst : _crownList[i],
                    crwn : (i + 1),
                    locked : false,
                    x    : 0,
                    y    : 0,
                    dix  : _col,
                    diy  : _row,
                    addy : 2,
                    blnd : c_gray,
                    visible : false
                });

                 // Determine Position on Screen:
                _col++;
                if((i % 4) == 0){
                    _col = 0;
                    _row++;
                }

                 // Delay Crowns (Necessary for scanning the image without any overlapping):
                with(_crownList[i]){
                	alarm_set(0, 4 - floor((i - 1) / 4));
                }
            }

             // Another Hacky Fix:
            if(fork()){
            	wait 2;
            	sprite_replace_base64(sprClockParts, "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQImWNgYGBgAAAABQABh6FO1AAAAABJRU5ErkJggg==", 1);
            	global.clock_fix = true;
            	exit;
            }
        }

         // Generate Comparison Sizes:
        if(array_length(crownSize) <= 0){
            var _x = _w / 2,
                _y = _h / 2,
                _surf = surface_create(_w, _h);

            surface_set_target(_surf);

            for(var i = 0; i <= 13; i++){
                var a = crownPath + string(i) + crownPathA,
                    b = crownPath + string(i) + crownPathB;

                 // Selected:
                draw_clear(c_black);
                draw_sprite(sprLoadoutCrown, i, _x, _y - 2);
                surface_save(_surf, a);

                 // Locked:
                draw_clear(c_black);
                draw_sprite_ext(sprLockedLoadoutCrown, i, _x, _y, 1, 1, 0, c_gray, 1);
                surface_save(_surf, b);

                 // Store Sizes:
                var _size = { slct:0, lock:0 };
                array_push(crownSize, _size);
                file_load(a);
                file_load(b);
                if(fork()){
                    wait 0;
                    _size.slct = file_size(a);
                    _size.lock = file_size(b);
                    exit;
                }
            }

            surface_reset_target();
            surface_destroy(_surf);
        }

         // Adding Custom Crowns:
        if(array_length(_crown.custom.icon) <= 0){
            with(array_combine(crwnList, [crwn_random])){
                with({
                    crwn : self,
                    locked : false,
                    x    : 0,
                    y    : 0,
                    dix  : 0,
                    diy  : 0,
                    addy : 2,
                    blnd : c_gray,
                    hover : false,
                    alarm0 : 6,
                    visible : false,
                    sprite_index : sprLoadoutCrown,
                    image_index  : 0
                }){
                	 // Modded:
                    if(is_string(crwn)){
                    	var _scrt = "crown_menu_avail";
                        locked = (mod_script_exists("crown", crwn, _scrt) && !mod_script_call_nc("crown", crwn, _scrt));

						var _scrt = "crown_menu_button";
                        if(mod_script_exists("crown", crwn, _scrt)){
                            with(instance_create(0, 0, GameObject)){
                                for(var i = 0; i < lq_size(other); i++){
                                    variable_instance_set(id, lq_get_key(other, i), lq_get_value(other, i));
                                }
                                mod_script_call("crown", crwn, _scrt);
                                for(var i = 0; i < lq_size(other); i++){
                                    lq_set(other, lq_get_key(other, i), variable_instance_get(id, lq_get_key(other, i)));
                                }
                                instance_delete(id);
                            }
                            array_push(_crown.custom.icon, self);
                        }
                    }

                     // Other:
                    else{
                        switch(crwn){
                            case crwn_random:
                                dix = 1;
                                diy = -1;
                                sprite_index = spr.CrownRandomLoadout;
                                break;
                        }
                        array_push(_crown.custom.icon, self);
                    }
                }
            }
        }

         // Dull Normal Crown Selection:
        if(_crown.custom.slct != -1){
            with(_crown.icon) if(visible && crwn == _crown.slct){
                draw_sprite_ext((locked ? sprLockedLoadoutCrown : sprLoadoutCrown), real(crwn), x, y + addy, 1, 1, 0, blnd, 1);
            }
        }

         // Haste Fix:
        with(_crown.icon) if(visible && crwn == crwn_haste && !locked){
            if("time" not in self) time = current_frame / 12;

            if(crwn == _crown.slct && _crown.custom.slct == -1){
                time += current_time_scale / 12;
            }

            draw_sprite_ext(spr.ClockParts, 0, x - 2, y - 1 + addy, 1, 1, time, blnd, 1);
            draw_sprite_ext(spr.ClockParts, 0, x - 2, y - 1 + addy, 1, 1, time * 12, blnd, 1);
            draw_sprite_ext(spr.ClockParts, 1, x - 2, y - 1 + addy, 1, 1, 0, blnd, 1);
        }

         // Custom Crown Icons:
        with(_crown.custom.icon){
            x = _vx + _cx + (dix * crownIconW);
            y = _vy + _cy + (diy * crownIconH);
            blnd = c_gray;
            addy = 0;

             // Locked:
            if(_crown.custom.slct == crwn && locked){
                _crown.custom.slct = -1;
            }

             // Appear:
            if(alarm0 > 0){
                addy = 2;
                alarm0 -= current_time_scale;
                if(alarm0 <= 0) visible = true;
            }

            if(visible){
                 // Hovering:
                if(point_in_rectangle(_mx, _my, x - 10, y - 10, x + 10, y + 10)){
                     // Sound:
                    if(!hover) sound_play(sndHover);
                    hover = min(hover + 1, 2);

                     // Select:
                    if(!locked && button_pressed(p, "fire") && _crown.custom.slct != crwn){
                        _crown.custom.slct = crwn;
                        sound_play(sndMenuCrown);
                    }

                     // Highlight:
                    if(crwn != _crown.custom.slct){
                        addy--;
                        blnd = merge_color(c_gray, c_white, 0.6);
                    }
                }
                else hover = false;

                 // Selected:
                if(crwn == _crown.custom.slct){
                    addy -= 2;
                    blnd = c_white;
                }

                 // Draw:
                with(other) draw_sprite_ext(other.sprite_index, other.image_index, other.x, other.y + other.addy, 1, 1, 0, other.blnd, 1);
            }
        }

         // Custom Crown Tooltip:
        with(_crown.custom.icon) if(visible && hover){
            draw_set_font(fntM);

            var _text = (locked ? "LOCKED" : crown_get_name(crwn) + "#@s" + crown_get_text(crwn)),
                _x = x,
                _y = max(y - 5, _vy + 24 + string_height(_text)/*can only draw over YAL's header in draw_gui_end and draw_tooltip breaks there so*/) - hover;

            draw_tooltip(_x, _y, _text);
        }
    }
	else crownSize = [];

     // Drawing Custom Crown on Collapsed Loadout:
    if(_crown.custom.slct != -1){
    	with(surfCrownHide) if(surface_exists(surf)){
            with(Loadout) if(visible && (selected == false || openanim < 3)){
            	var _x = x + other.x,
            		_y = y + other.y;

                 // Hide Normal Crown:
                if(_crown.slct != crwn_none){
					draw_surface(other.surf, _x, _y);
                }

                 // Draw Custom:
                with(_crown.custom.icon) if(crwn == _crown.custom.slct){
                	with(other) draw_sprite(other.sprite_index, other.image_index, _x + 16, _y + 16);
                }
            }
    	}
    }

    instance_destroy();

#define player_get_race_fix(p) /// Used for custom crown loadout
	var _race = player_get_race(p);

	 // Fix 1 Frame Delay Thing:
	var _raceChange = (button_pressed(p, "east") - button_pressed(p, "west"));
	if(_raceChange != 0){
		var _new = _race;

		with(instances_matching(CharSelect, "race", _race)){
			var _slct = instances_matching_ne(instances_matching_ne(CharSelect, "id", id), "race", 16/*==Locked in game logic??*/),
				_inst = _slct;

			if(_raceChange > 0){
				_inst = instances_matching_gt(_slct, "xstart", xstart);
			}
			else{
				_inst = instances_matching_lt(_slct, "xstart", xstart);
			}

			 // Find Next CharSelect:
			if(array_length(_inst) > 0){
				var _min = 0;
				with(_inst){
					var _x = (xstart - other.xstart);
					if(_min <= 0 || abs(_x) < _min){
						_min = abs(_x);
						_new = race;
					}
				}
			}

			 // Loop Around to Farthest CharSelect:
			else{
				var _max = 0;
				with(_slct){
					var _x = (xstart - other.xstart);
					if(_max <= 0 || abs(_x) > _max){
						_max = abs(_x);
						_new = race;
					}
				}
			}
		}

		_race = _new;
	}

	return _race;

#define cleanup
    if(global.clock_fix) sprite_restore(sprClockParts);

	 // Fix Options:
	if(MenuOpen){
		with(Menu) mode = 0;
		sound_volume(sndMenuCharSelect, 1);
	}

     // Stop Area Music/Ambience:
    for(var i = 0; i < lq_size(global.sound_current); i++){
        audio_stop_sound(lq_get_value(global.sound_current, i).snd);
    }


/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  anim_end                                                                                image_index + image_speed_raw >= image_number
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define in_range(_num, _lower, _upper)                                                  return  (_num >= _lower && _num <= _upper);
#define frame_active(_interval)                                                         return  (current_frame % _interval) < current_time_scale;
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define surflist_set(_name, _x, _y, _width, _height)                                    return  mod_script_call_nc('mod', 'teassets', 'surflist_set', _name, _x, _y, _width, _height);
#define surflist_get(_name)                                                             return  mod_script_call_nc('mod', 'teassets', 'surflist_get', _name);
#define shadlist_set(_name, _vertex, _fragment)                                         return  mod_script_call_nc('mod', 'teassets', 'shadlist_set', _name, _vertex, _fragment);
#define shadlist_get(_name)                                                             return  mod_script_call_nc('mod', 'teassets', 'shadlist_get', _name);
#define shadlist_setup(_shader, _texture, _draw)                                        return  mod_script_call_nc('mod', 'telib', 'shadlist_setup', _shader, _texture, _draw);
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
#define dfloor(_num, _div)                                                              return  mod_script_call_nc('mod', 'telib', 'dfloor', _num, _div);
#define in_distance(_inst, _dis)                                                        return  mod_script_call(   'mod', 'telib', 'in_distance', _inst, _dis);
#define in_sight(_inst)                                                                 return  mod_script_call(   'mod', 'telib', 'in_sight', _inst);
#define instance_budge(_objAvoid, _disMax)                                              return  mod_script_call(   'mod', 'telib', 'instance_budge', _objAvoid, _disMax);
#define instance_random(_obj)                                                           return  mod_script_call_nc('mod', 'telib', 'instance_random', _obj);
#define instance_create_copy(_x, _y, _obj)                                              return  mod_script_call(   'mod', 'telib', 'instance_create_copy', _x, _y, _obj);
#define instance_nearest_array(_x, _y, _inst)                                           return  mod_script_call_nc('mod', 'telib', 'instance_nearest_array', _x, _y, _inst);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc('mod', 'telib', 'instance_rectangle', _x1, _y1, _x2, _y2, _obj);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call_nc('mod', 'telib', 'instance_rectangle_bbox', _x1, _y1, _x2, _y2, _obj);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call_nc('mod', 'telib', 'instances_at', _x, _y, _obj);
#define instances_seen_nonsync(_obj, _bx, _by)                                          return  mod_script_call_nc('mod', 'telib', 'instances_seen_nonsync', _obj, _bx, _by);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   'mod', 'telib', 'instances_meeting', _x, _y, _obj);
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call_nc('mod', 'telib', 'draw_weapon', _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call_nc('mod', 'telib', 'draw_lasersight', _x, _y, _dir, _maxDistance, _width);
#define draw_text_bn(_x, _y, _string, _angle)                                                   mod_script_call_nc('mod', 'telib', 'draw_text_bn', _x, _y, _string, _angle);
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
#define area_generate(_x, _y, _area)                                                    return  mod_script_call_nc('mod', 'telib', 'area_generate', _x, _y, _area);
#define area_border(_y, _area, _color)                                                  return  mod_script_call_nc('mod', 'telib', 'area_border', _y, _area, _color);
#define floor_get(_x, _y)                                                               return  mod_script_call_nc('mod', 'telib', 'floor_get', _x, _y);
#define floor_set(_x, _y, _state)                                                       return  mod_script_call_nc('mod', 'telib', 'floor_set', _x, _y, _state);
#define floor_fill(_x, _y, _w, _h)                                                      return  mod_script_call_nc('mod', 'telib', 'floor_fill', _x, _y, _w, _h);
#define floor_fill_round(_x, _y, _w, _h)                                                return  mod_script_call_nc('mod', 'telib', 'floor_fill_round', _x, _y, _w, _h);
#define floor_make(_x, _y, _obj)                                                        return  mod_script_call_nc('mod', 'telib', 'floor_make', _x, _y, _obj);
#define floor_reveal(_floors, _maxTime)                                                 return  mod_script_call_nc('mod', 'telib', 'floor_reveal', _floors, _maxTime);
#define floor_walls()                                                                   return  mod_script_call(   'mod', 'telib', 'floor_walls');
#define wall_tops()                                                                     return  mod_script_call(   'mod', 'telib', 'wall_tops');
#define wall_clear(_x1, _y1, _x2, _y2)                                                          mod_script_call_nc('mod', 'telib', 'wall_clear', _x1, _y1, _x2, _y2);
#define sound_play_ntte(_type, _snd)                                                    return  mod_script_call_nc('mod', 'telib', 'sound_play_ntte', _type, _snd);
#define sound_play_hit_ext(_snd, _pit, _vol)                                            return  mod_script_call(   'mod', 'telib', 'sound_play_hit_ext', _snd, _pit, _vol);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call(   'mod', 'telib', 'race_get_sprite', _race, _sprite);
#define player_create(_x, _y, _index)                                                   return  mod_script_call_nc('mod', 'telib', 'player_create', _x, _y, _index);
#define player_swap()                                                                   return  mod_script_call(   'mod', 'telib', 'player_swap');
#define wep_get(_wep)                                                                   return  mod_script_call_nc('mod', 'telib', 'wep_get', _wep);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc('mod', 'telib', 'wep_merge', _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call_nc('mod', 'telib', 'wep_merge_decide', _hardMin, _hardMax);
#define weapon_decide_gold(_minhard, _maxhard, _nowep)                                  return  mod_script_call_nc('mod', 'telib', 'weapon_decide_gold', _minhard, _maxhard, _nowep);
#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)                        return  mod_script_call_nc('mod', 'telib', 'path_create', _xstart, _ystart, _xtarget, _ytarget, _wall);
#define path_shrink(_path, _wall, _skipMax)                                             return  mod_script_call_nc('mod', 'telib', 'path_shrink', _path, _wall, _skipMax);
#define path_reaches(_path, _xtarget, _ytarget, _wall)                                  return  mod_script_call_nc('mod', 'telib', 'path_reaches', _path, _xtarget, _ytarget, _wall);
#define path_direction(_path, _x, _y, _wall)                                            return  mod_script_call_nc('mod', 'telib', 'path_direction', _path, _x, _y, _wall);
#define path_draw(_path)                                                                return  mod_script_call(   'mod', 'telib', 'path_draw', _path);
#define portal_poof()                                                                   return  mod_script_call_nc('mod', 'telib', 'portal_poof');
#define portal_pickups()                                                                return  mod_script_call_nc('mod', 'telib', 'portal_pickups');
#define pet_spawn(_x, _y, _name)                                                        return  mod_script_call_nc('mod', 'telib', 'pet_spawn', _x, _y, _name);
#define scrPickupIndicator(_text)                                                       return  mod_script_call(   'mod', 'telib', 'scrPickupIndicator', _text);
#define TopDecal_create(_x, _y, _area)                                                  return  mod_script_call_nc('mod', 'telib', 'TopDecal_create', _x, _y, _area);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   'mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_instance, _charm)                                               return  mod_script_call_nc('mod', 'telib', 'charm_instance', _instance, _charm);