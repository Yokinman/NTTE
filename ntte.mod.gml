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
    global.current = {
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
							"list" : [
								"Scorpion"	+ ".petlib.mod",
								"Parrot"	+ ".petlib.mod",
								"CoolGuy"	+ ".petlib.mod",
								"Mimic"		+ ".petlib.mod",
								"Slaughter"	+ ".petlib.mod",
								"Octo"		+ ".petlib.mod",
								"Spider"	+ ".petlib.mod",
								"Prism"		+ ".petlib.mod"
								]
						},
						
						"other" : {}
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
		
	 // Pet Map Icons:
	global.petMapicon = array_create(maxp, []);
	global.petMapiconPause = 0;
	global.petMapiconPauseForce = 0;

	 // For Merged Weapon PopupText Fix:
	global.wepMergeName = [];
	
	 // Max Special Pickups Per Level:
	global.specialPickupsMax = 2;
	global.specialPickups = global.specialPickupsMax;

	 // Kills:
	global.killsLast = GameCont.kills;

     // Charm:
    global.surfCharm = surflist_set("Charm", 0, 0, game_width, game_height);
    global.shadCharm = shadlist_set("Charm", 
		/* Vertex Shader */"
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

		/* Fragment/Pixel Shader */"
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
		"
	);
    global.charm = ds_list_create();

     // Underwater Level:
    global.waterBubblePop = [];
    global.waterSoundActive = false;
    
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

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)

#macro surfCrownHide		global.surfCrownHide
#macro surfCrownHideScreen	global.surfCrownHideScreen
#macro surfCharm			global.surfCharm
#macro surfMainHUD			global.surfMainHUD

#macro shadCharm global.shadCharm

#macro cMusic	 global.current.mus
#macro cAmbience global.current.amb

#macro UnlockCont instances_matching(CustomObject, "name", "UnlockCont")

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
    global.mapArea = [];
    for(var i = 0; i < array_length(global.petMapicon); i++){
    	global.petMapicon[i] = [];
    }
    with(UnlockCont) instance_destroy();
    mod_variable_set("area", "trench", "trench_visited", []);
	global.killsLast = GameCont.kills;
	
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
    switch(GameCont.area){
    	case 0: /// CAMPFIRE
    		 // Unlock Custom Crowns:
    		if(array_exists(crwnList, crown_current)){
    			var _unlock = "crown" + string_upper(string_char_at(crown_current, 1)) + string_delete(crown_current, 1, 1);
    			if(!unlock_get(_unlock)){
    				unlock_set(_unlock, true);
    				scrUnlock(crown_get_name(crown_current) + "@s", "FOR @wEVERYONE", -1, -1);
    			}
    		}
    		break;

        case 1: /// DESERT
             // Disable Oasis Skip:
    		with(instance_create(0, 0, chestprop)){
    			visible = false;
    			mask_index = mskNone;
    		}

			 // Big Nests:
			with(MaggotSpawn) if(chance(1, 14)){
				obj_create(x, y, "BigMaggotSpawn");
				instance_delete(id);
			}

			 // Find Prop-Spawnable Floors:
    	    var _spawnFloor = [],
    	    	_spawnIndex = -1;

			with(Floor){
				var _x = (bbox_left + bbox_right) / 2,
					_y = (bbox_top + bbox_bottom) / 2;

				if(point_distance(_x, _y, 10016, 10016) > 48){
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
				var _sx = 10016,
    				_sy = 10016;

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
					if(distance_to_object(Player) > 196 && chance(1, 40 + (20 * (object_index != RadMaggotChest)))){
						var _sx = x + (irandom_range(-2, 2) * 32),
							_sy = y + (irandom_range(-2, 2) * 32),
							_floors = [],
							_ang = random(360);
	
						instance_delete(id);

						 // Generate Area:
						for(var d = _ang; d < _ang + 360; d += (360 / 8)){
							var l = 0;
							repeat(5 + GameCont.loops){
								var _x = (floor((_sx + lengthdir_x(l, d)) / 32) * 32) - 16,
									_y = (floor((_sy + lengthdir_y(l, d)) / 32) * 32) - 16;

								for(var _ox = -32; _ox < 32; _ox += 32){
									for(var _oy = -32; _oy < 32; _oy += 32){
										with(instance_rectangle(_x + _ox, _y + _oy, _x + _ox + 16, _y + _oy + 16, Floor)){
											if(!array_exists(_floors, id)) instance_destroy();
										}
										with(instance_create(_x + _ox, _y + _oy, Floor)){
											if(instance_exists(self)) array_push(_floors, id);
										}
									}
								}
	
								l += random(32);
							}
						}
	
						 // Clear Walls:
						with(_floors){
							with(instance_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, [Wall, TopSmall, Bones, TopPot])){
								instance_destroy();
							}
						}
	
						 // New Walls:
						with(_floors){
							scrFloorWalls();
							if(chance(1, 3)){
								with(instance_create(x + 16, y + 16, PortalClear)){
									mask_index = mskPlasmaImpact;
								}
							}
						}
						with(Wall){
							for(var _x = x - 16; _x <= x + 16; _x += 16){
								for(var _y = y - 16; _y <= y + 16; _y += 16){
									if(!position_meeting(_x, _y, Wall) && !position_meeting(_x, _y, Floor) && !position_meeting(_x, _y, TopSmall)){
										instance_create(_x, _y, TopSmall);
									}
								}
							}
						}
	
						 // Nests:
						var _ang = random(360),
							r = choose(-1, 1);
	
						for(var d = _ang; d < _ang + 360; d += (360 / 3)){
							var l = random_range(28, 40);
							with(obj_create(round(_sx + lengthdir_x(l, d)), round(_sy + lengthdir_y(l, d)), "BigMaggotSpawn")){
								right = r;
								r *= -1;
							}
						}
						with(_floors){
							if(!place_meeting(x, y, enemy)){
								if(chance(2, 3)){
									with(instance_create(x + 16, y + 16, MaggotSpawn)){
										raddrop = 2;
										x = xstart;
										y = ystart;
										move_contact_solid(random(360), random(16));
										instance_create(x, y, Maggot);
									}
								}
							}
							else with(instances_meeting(x, y, instances_matching_ne(enemy, "object_index", MaggotSpawn, CustomEnemy, Maggot))){
								if(!place_meeting(x, y, BigMaggot) && !place_meeting(x, y, JungleFly)){
									if(GameCont.loops > 0 && chance(1, 2)){
										instance_create(x, y, JungleFly);
									}
									else instance_create(x, y, BigMaggot);
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
            if(GameCont.subarea > 1 || GameCont.loops > 0){
            	if(chance(1, 100) || (chance(1, 50) && array_length(instances_matching(instances_matching(CustomHitme, "name", "Pet"), "pet", "Scorpion")) > 0)){
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
            break;

        case 2: /// SEWERS
             // Spawn Cats:
    	    with(ToxicBarrel){
    	        repeat(irandom_range(2, 3)){
    	        	obj_create(x, y, "Cat");
    	        }
    	    }
            break;

		case 3: /// SCRAPYARDS
			 // Sawblade Traps:
			with(Raven) if(distance_to_object(Player) > 128 && chance(1, 10)){
				obj_create(x, y, "SawTrap");
				instance_delete(id);
			}

			var _event = chance(1, 60),
				_ravenChance = (_event ? 1 : 0.1) * (1 + GameCont.loops);

			if(!_event && instance_exists(BecomeScrapBoss)){
				_ravenChance *= 2.5;
			}

			 // Raven Spectators:
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
        	
        	 // Spawn Lightning Crystals:
        	with(LaserCrystal) if(GameCont.loops <= 0 && chance(1, 20)){
        		instance_create(x, y, LightningCrystal);
        		instance_delete(id);
        	}
        	
        	 // Spawn Spider Walls:
        	if(instance_exists(Wall)){
        	     // Strays:
        	    repeat(8 + irandom(4)) with(instance_random(Wall)) if(point_distance(x, y, 10016, 10016) > 48){
        	    	if(array_length(instances_matching(instances_matching(CustomObject, "name", "SpiderWall"), "creator", id)) <= 0){
	        	        with(obj_create(x, y, "SpiderWall")){
	        	            creator = other;
	        	        }
        	    	}
        	    }
        	    
        	     // Central mass:
        	    if(fork()){
	        	    var _tries = 100;
	        	    while(_tries-- > 0){
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
	
	        	        	exit;
	        	        }
	        	    }
	        	    exit;
        	    }
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
            with(BigCursedChest){
                Pet_spawn(x, y, "Prism");
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

     // Spider Cocoons:
    with(Cocoon) if(chance(4, 5)){ 
    	obj_create(x, y, "NewCocoon");
    	instance_delete(id);
    }

     // Visibilize Pets:
    with(instances_matching(CustomHitme, "name", "Pet")) visible = true;
    
     // Backpack Setpieces:
    var _canBackpack = (instance_number(enemy) > array_length(instances_matching(CustomEnemy, "name", "PortalPrevent")) && chance(1 + (2 * skill_get(mut_last_wish)), 12)),
    	_validArea = !(GameCont.area == 106),
    	_forceSpawn = (GameCont.area == 0);

    if(GameCont.hard > 4 && ((_canBackpack && _validArea) || _forceSpawn)){
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
			with(instance_create(x + 16 + orandom(8), y + 16 + irandom(8), CorpseActive)){
				image_xscale = choose(-1, 1);
				sprite_index = sprMutant14Dead;
				image_index = image_number - 1;

				 // Bone:
				with(instance_create(x - 8 * image_xscale, y + 8, WepPickup)){
					wep = "crabbone";
				}
			}

			instance_create(x + 16, y + 16, PortalClear);
		}
    }
    
     // Lair Chests:
    var _crownCrime = (crown_current == "crime");
    if(variable_instance_get(GameCont, "visited_lair", false) || _crownCrime){
		
		 // Cat Chests:
		with(instances_matching_ne(AmmoChest, "object_index", IDPDChest, GiantAmmoChest)){
			if(_crownCrime ? chance(2, 3) : chance(1, 5)){
				obj_create(x, y, "CatChest");
				instance_delete(id);
			}
		}
		
		 // Bat Chests:
		with(instances_matching_ne(WeaponChest, "object_index", BigWeaponChest, BigCursedChest, GiantWeaponChest)){
			if(_crownCrime ? chance(2, 3) : chance(1, 5)){
				obj_create(x, y, "BatChest");
				instance_delete(id);
			}
		}
    }
    
     // Treasure Chests:
    /*if(chance(0, 1)){
    	var _x, _y,
    		o = 32;

    	with(instance_furthest(10000, 10000, Floor)){
    		var l = ((GameCont.area == "coast") ? 200 : 160),
    			d = point_direction(10000, 10000, x, y);

    		_x = round((x + lengthdir_x(l, d)) / o) * o + 16;
    		_y = round((y + lengthdir_y(l, d)) / o) * o + 16;
    	}
    	
    	switch(GameCont.area){
    		 // Coast Island Chest:
    		 // spawns alone at sea, requires you to think smart in order to reach it
    		case "coast":
    			obj_create(_x + 16, _y + 16, "SunkenChest");
    			
    			break;
    			
    		 // Oasis Cove Chest:
    		 // spawns in a sealed-off cove, you don't have to think that smart for this one
    		case "oasis":
    			var _floors = [instance_create(_x, _y, Floor)];
    			for(var d = 0; d < 360; d += 90) array_push(_floors, instance_create(_x + lengthdir_x(o, d), _y + lengthdir_y(o, d), Floor));
    			obj_create(_x + 16, _y + 16, "SunkenChest");
    			
    			with(_floors){
    				 // Visual:
    				styleb = true;
    				sprite_index = sprFloor101B;
    				
    				scrFloorWalls();
    			}
				with(Wall){
					for(var _x = x - 16; _x <= x + 16; _x += 16){
						for(var _y = y - 16; _y <= y + 16; _y += 16){
							if(!position_meeting(_x, _y, Wall) && !position_meeting(_x, _y, Floor) && !position_meeting(_x, _y, TopSmall)){
								instance_create(_x, _y, TopSmall);
							}
						}
					}
				}
    		
    			break;
    	}
    }*/
    
     // More:
    global.specialPickups = global.specialPickupsMax;

#define step
    if(DebugLag) trace_time();
    
	 // Bind Events:
    script_bind_end_step(end_step, 0);
    script_bind_end_step(charm_step, 0);
    script_bind_draw(draw_menu, (instance_exists(Menu) ? Menu.depth : object_get_depth(Menu)) - 0.1);
    with(instances_matching(TopCont, "visible", true)){
    	var d = depth;
    	with(instances_matching(GenCont, "visible", true)) d = min(depth, d);
    	script_bind_draw(draw_top, d - 0.1);
    }

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
	
	             // race_avail Fix:
	            if(mod_script_exists("race", _name, "race_avail") && !mod_script_call_nc("race", _name, "race_avail")){
		            with(instances_matching(CharSelect, "race", _name)){
		            	noinput = 10;
		            }
	            }
	        }
	
	         // CampChar Management:
	        var _playersLocal = 0;
	        for(var i = 0; i < maxp; i++) _playersLocal += player_is_local_nonsync(i);
	        for(var i = 0; i < maxp; i++) if(player_is_active(i)){
	            var _race = player_get_race(i);
	            if(array_exists(raceList, _race)){
	                with(instances_matching(CampChar, "race", _race)){
	                     // Pan Camera:
	                    if(_playersLocal <= 1){
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

	 // Underwater Sounds:
    if(global.waterSoundActive){
    	if(!area_get_underwater(GameCont.area) && GameCont.area != 100){
			underwater_sound(false);
    	}
    }
    else if(area_get_underwater(GameCont.area)){
		underwater_sound(true);
	}

     // Pet Slots:
    with(instances_matching(Player, "ntte_pet", null)) ntte_pet = [noone];
		
	 // Pet Map Icons:
	with(Player){
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
				_save = ["ntte_pet", "feather_ammo"],
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
					with(nearest_instance(_x, _y, instances_matching(Revive, "ntte_storage", null))){
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
    	with(global.waterBubblePop) with(self[0]) spr_bubble_pop_check = null
    	global.waterBubblePop = [];
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

        if(!instance_exists(GenCont) && !instance_exists(LevCont)){
		     // Underwater Area:
		    if(area_get_underwater(_area)) underwater_step();

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
        if(global.musTrans || instance_exists(GenCont) || instance_exists(mutbutton)){
        	global.musTrans = false;
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

	 // Area Completion Unlocks:
	if(!instance_exists(GenCont) && !instance_exists(LevCont) && instance_exists(Player)){
		if(instance_exists(Portal) || (!instance_exists(enemy) && !instance_exists(CorpseActive))){
			//if(!array_length(instances_matching_ne(instances_matching(CustomObject, "name", "CatHoleBig"), "sprite_index", mskNone))){ yokin wtf how could you comment out my epic code!?!?
				var _packList = {
					"coast"  : [["BEACH GUNS" 		, "GRAB YOUR FRIENDS"		, "Wep"		]],
					"oasis"  : [["BUBBLE GUNS"		, "SOAP AND WATER"			, "Wep"		]],
					"trench" : [["TECH GUNS"  		, "TERRORS FROM THE DEEP"	, "Wep"		]],
					"lair"	 : [["SAWBLADE GUNS"	, "DEVICES OF TORTURE"		, "Wep"		],
								["CROWN OF CRIME"	, "STOLEN FROM THIEVES"		, "Crown"	]]
				};

				for(var i = 0; i < array_length(_packList); i++){
					var _area = lq_get_key(_packList, i);
					if(GameCont.area == _area){
						if(GameCont.subarea >= area_get_subarea(_area)){
							with(lq_get_value(_packList, i)){
								var	_pack = self,
									_unlock = _area + _pack[2];

								if(!unlock_get(_unlock)){
									unlock_set(_unlock, true);
									sound_play(sndGoldUnlock);
									scrUnlock(_pack[0], _pack[1], -1, -1);
								}
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
			var _unlock = "crown" + string_upper(string_char_at(crown_current, 1)) + string_delete(crown_current, 1, 1);
			if(!unlock_get(_unlock)){
				unlock_set(_unlock, true);
				scrUnlock(crown_get_name(crown_current) + "@s", "FOR @wEVERYONE", -1, -1);
			}
		}
	}

	 // Overstock / Bonus Ammo:
	with(instances_matching(instances_matching(instances_matching_gt(Player, "ammo_bonus", 0), "infammo", 0), "visible", true)){
		var c = weapon_get_cost(wep),
			t = weapon_get_type(wep),
			_auto = weapon_get_auto(wep);

		if(race == "steroids" && _auto >= 0) _auto = true;

		if(canfire && can_shoot){
			if(button_pressed(index, "fire") || (_auto && button_check(index, "fire")) || (!_auto && clicked)){
				if(ammo[t] + ammo_bonus >= c){
					ammo_bono(c, t);
				}
			}
		}
	}
	
	 // Crown of Crime:
	if(!(GameCont.area == 7 && GameCont.area == 3)){
		with(instances_matching(Crown, "ntte_crown", "crime")){
			 // Watch where you're going bro:
			if(hspeed != 0) image_xscale = abs(image_xscale) * sign(hspeed);
			
			 // Spawn Enemies:
			if(enemies > 0){
				enemy_time -= current_time_scale;
				scrPortalPoof();
				
				if(enemy_time <= 0){
					var f = instance_furthest(x, y, Floor),
						l = irandom_range(360, 420),
						d = point_direction(f.x, f.y, x, y);
						
					 // Weighted Pool:
					var _enemyPool = [];
						repeat(5) array_push(_enemyPool, "Gator");
						repeat(3) array_push(_enemyPool, "Buff Gator");
						repeat(2) array_push(_enemyPool, "Baby Gator");
						
					if(GameCont.hard > 2)
						repeat(2) array_push(_enemyPool, "Bone Gator");
					
					if(GameCont.hard > 5)
						repeat(1) array_push(_enemyPool, "Albino Gator");
					
					while(enemies > 0){
						enemies -= 1;
						with(obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "TopEnemy")){
							 // Determine Enemy Type:
							switch(_enemyPool[irandom(array_length(_enemyPool) - 1)]){
								case "Gator":
									obj_name = Gator;
									with(obj_info){
										spr_idle = sprGatorIdle;
										spr_walk = sprGatorWalk;
										spr_weap = sprGatorShotgun;
									}
									break;
									
								case "Buff Gator":
									obj_name = BuffGator;
									with(obj_info){
										spr_idle = sprBuffGatorIdle;
										spr_walk = sprBuffGatorWalk;
										spr_weap = sprBuffGatorFlakCannon;
									}
									break;
								
								case "Bone Gator":
									obj_name = "BoneGator";
									with(obj_info){
										spr_idle = spr.BoneGatorIdle;
										spr_walk = spr.BoneGatorWalk;
										spr_weap = spr.BoneGatorWeap;
									}
									break;
									
								case "Baby Gator":
									obj_name = "BabyGator";
									with(obj_info){
										spr_idle = spr.BabyGatorIdle;
										spr_walk = spr.BabyGatorWalk;
										spr_weap = spr.BabyGatorWeap;
										spr_shadow = shd16;
										spr_shadow_y = 0;
									}
									
									 // Babies Stick Together:
									var n = 2 + irandom(1 + GameCont.loops);
									repeat(n) instance_copy(false);
									break;
									
								case "Albino Gator":
									obj_name = "AlbinoGator";
									with(obj_info){
										spr_idle = spr.AlbinoGatorIdle;
										spr_walk = spr.AlbinoGatorWalk;
										spr_weap = spr.AlbinoGatorWeap;
									}
									break;
									
								 //#region I Dunno:
									
								/* commenting this out cause bro i cant load the mod we literally at the threshold bro and i cant find anything to get rid of
								case "Rat Horde": // maybe?
									obj_name = FastRat;
									with(obj_info){
										spr_idle = sprFastRatIdle;
										spr_walk = sprFastRatWalk;
									}
									
									 // The Horde:
									var n = 3 + irandom(3 + GameCont.loops);
									repeat(n) instance_copy(false);
									
									 // Large and in Charge:
									with(obj_create(x, y, "TopEnemy")){
										obj_name = Ratking;
										with(obj_info){
											spr_idle = sprRatkingRageWait;
											spr_walk = sprRatkingRageAttack;
											spr_shadow = shd48;
										}
									}
									break;
									*/
									
								 //#endregion
							}
						}
					}
					
					 // Effects:
					with(instance_create(x + lengthdir_x(12, d), y + lengthdir_y(12, d), AssassinNotice)) motion_set(d, 1);
					sound_play_pitch(sndIDPDNadeAlmost, 0.8);
				}
			}
		}
	}
	
	 // Dissipate Cat Gas Faster:
	with(instances_matching_lt(instances_matching(ToxicGas, "cat_toxic", true), "speed", 0.1)){
		growspeed -= random(0.002 * current_time_scale);
	}

	 // Separate Bones:
    with(instances_matching(WepPickup, "crabbone_splitcheck", null)){
    	if(is_object(wep) && wep_get(wep) == "crabbone" && lq_defget(wep, "ammo", 1) > 1){
            wep.ammo--;
            with(instance_create(x, y, WepPickup)) wep = "crabbone";
        }
        else crabbone_splitcheck = true;
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
		 // Pet Tips:
		with(instances_matching(GenCont, "tip_ntte_pet", null)){
			tip_ntte_pet = chance(1, 14);
			if(tip_ntte_pet){
				var _player = array_shuffle(instances_matching_ne(Player, "ntte_pet", null)),
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
				if(is_string(_tip)) tip = _tip;
			}
		}

	     // Scramble Cursed Caves Weapons:
	    if(GameCont.area == 104){
	    	with(instances_matching(WepPickup, "scrambled", null)){
		    	scrambled = false;
				if(roll && wep_get(wep) != "merge"){
					//if(!position_meeting(xstart, ystart, ChestOpen) || chance(1, 3)){
						scrambled = true;
						curse = max(1, curse);

						var _part = wep_merge_decide(0, GameCont.hard + 2);
						if(array_length(_part) >= 2){
							wep = wep_merge(_part[0], _part[1]);
						}
					//}
				}
	    	}
	    }

		 // Overstock / Bonus Ammo Cleanup:
		with(instances_matching(instances_matching_gt(Player, "ammo_bonus", 0), "infammo", 0)){
			drawempty = 0;
	
			var t = weapon_get_type(wep),
				c = weapon_get_cost(wep);
	
			if(c > 0){
				 // Cool Blue Shells:
				with(instances_matching(instances_matching_gt(Shell, "speed", 0), "ammo_bonus_shell", null)){
					if(place_meeting(xprevious, yprevious, other)){
						ammo_bonus_shell = true;
						sprite_index = ((sprite_get_width(sprite_index) > 3) ? spr.BonusShellHeavy : spr.BonusShell);
						image_blend = merge_color(image_blend, c_blue, random(0.25));
					}
				}
		
				 // Prevent Low Ammo PopupTexts:
				if(ammo[t] + ammo_bonus >= c && infammo == 0){
					var o = 10;
					with(instance_rectangle_bbox(x - o, y - o, x + o, y + o, instances_matching(instances_matching(instances_matching(PopupText, "target", index), "text", "EMPTY", "NOT ENOUGH " + typ_name[t]), "alarm1", 30))){
						if(point_distance(xstart, ystart, other.x, other.y) < o){
							other.wkick = 0;
							sound_stop(sndEmpty);
							instance_destroy();
						}
					}
				}
			}
		}

		 // Overheal / Bonus HP:
		with(instances_matching_gt(Player, "my_health_bonus", 0)){
			drawlowhp = 0;
	
			if(nexthurt > current_frame && "my_health_bonus_hold" in self){
				var a = my_health,
					b = my_health_bonus_hold;
		
				if(a < b){
					var c = min(my_health_bonus, b - a);
					my_health += c;
					my_health_bonus -= c;

					 // Sound:
					sound_play_pitchvol(sndRogueAim, 2 + random(0.5), 0.7);
					sound_play_pitchvol(sndHPPickup, 0.6 + random(0.1), 0.7);

					 // Visual:
					var _x1, _y1,
						_x2, _y2,
						_ang = direction + 180,
						l = 12;

					for(var d = _ang; d <= _ang + 360; d += (360 / 20)){
						_x1 = x + lengthdir_x(l, d);
						_y1 = y + lengthdir_y(l, d);
						if(d > _ang){
							with(instance_create(_x1, _y1, BoltTrail)){
								image_blend = merge_color(c_aqua, c_blue, 0.2 + (0.2 * dsin(_ang + d)));
								image_angle = point_direction(_x1, _y1, _x2, _y2);
								image_xscale = point_distance(_x1, _y1, _x2, _y2) * 1.1;
								image_yscale = 1.5 + dsin(_ang + d);
								if(other.my_health_bonus > 0){
									image_yscale = max(1.7, image_yscale);
								}
								motion_add(other.direction, 0.5);
								depth = -2;
							}
						}
						_x2 = _x1;
						_y2 = _y1;
					}
					with(instance_create(x, y, BulletHit)){
						sprite_index = sprPortalClear;
						image_xscale = 0.4;
						image_yscale = image_xscale;
						image_speed = 1;
						motion_add(other.direction, 0.5);
					}

					 // End:
					if(my_health_bonus <= 0){
						 // Can't die coming out of overheal:
						spiriteffect = max(1, spiriteffect);

						 // Effects:
						sound_play_pitchvol(sndLaserCannon, 1.4 + random(0.2), 0.8);
						sound_play_pitchvol(sndEmpty, 0.8 + random(0.1), 1);
						with(instance_create(x, y, BulletHit)){
							sprite_index = sprThrowHit;
							motion_add(other.direction, 1);
							image_xscale = random_range(2/3, 1);
							image_yscale = image_xscale;
							image_angle = random(360);
							image_blend = merge_color(c_aqua, c_blue, 0.2 + (0.2 * dsin(d)));
							image_speed = 0.5;
							image_alpha = 2;
							depth = -3;
						}
					}
				}
			}
			my_health_bonus_hold = my_health;
		}
	
		 // Overheal, Overstock, and Spirit Pickups:
		with(instances_matching([AmmoPickup, HPPickup], "bonuspickup_spawn", undefined)) if(GameCont.hard > 6){
			bonuspickup_spawn = false;
	
			if(!position_meeting(xstart, ystart, ChestOpen) && global.specialPickups > 0){
				if((instance_is(self, HPPickup) && sprite_index == sprHP) || (instance_is(self, AmmoPickup) && sprite_index == sprAmmo)){
					 // Spirit Pickups:
					if(chance(1 + skill_get(mut_last_wish), 200)){
						obj_create(x, y, "SpiritPickup");
						instance_delete(id);
		
						global.specialPickups--;
					}
					
					 // Overheal/Overstock Pickups:
					else if(chance(1, 50)){
						obj_create(x, y, (instance_is(id, HPPickup) ? "OverhealPickup" : "OverstockPickup"));
						instance_delete(id);
		
						global.specialPickups--;
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
			    	name += `#@(${mod_script_call("mod", "teassets", "wep_merge_subtext", wep.base.stock, wep.base.front)})`;
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
	
	     // No Cheaters (bro just play the mod):
		with(Player){
			var w = 0;
			with([wep_get(wep), wep_get(bwep)]){
				var _wep = self;
				with(other){
					if(is_string(_wep) && mod_script_exists("weapon", _wep, "weapon_avail") && !mod_script_call("weapon", _wep, "weapon_avail")){
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
				}
				w++;
			}
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

		 // NTTE Time Stat:
		stat_set("time", stat_get("time") + (current_time_scale / 30));
		
		 // Scythe Prompts:
		var _scytheExists = false;
		with(Player) if(wep_get(wep) == "scythe" || wep_get(bwep) == "scythe"){
			_scytheExists = true;
		}
		with(instances_matching(GenCont, "scythe_prompt", undefined)) if(_scytheExists && global.sPromptIndex != -1){
			scythe_prompt = true;
			tip = global.scythePrompt[global.sPromptIndex];
			global.sPromptIndex = min(global.sPromptIndex + 1, array_length(global.scythePrompt) - 1);
		}
		
		 // Cursed Ammo Chests:
		with(instances_matching(AmmoChest, "cursedammochest_check", undefined)) if(crown_current == crwn_curses){
			cursedammochest_check = true;
			if(chance(1, 5)){
				obj_create(x, y, "CursedAmmoChest");
				instance_delete(id);
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

#define draw_top
    var _players = 0,
		_vx = view_xview_nonsync,
		_vy = view_yview_nonsync,
		_ox = _vx,
		_oy = _vy,
		_surfHUD = surfMainHUD,
		_surfHUDDraw = true;
		
	draw_set_font(fntSmall);
	draw_set_halign(fa_right);
	draw_set_valign(fa_top);
	
	with(_surfHUD){
		x = _vx;
		y = _vy;
		w = game_width;
		h = game_height;
		
		if(surface_exists(surf)){
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			surface_reset_target();
		}
		else _surfHUDDraw = false;
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
			_flip = (_side ? -1 : 1);
			
		draw_set_projection(2, _index);
		
		 // Draw Main Local Player to Surface for Pause Screen:
		if(_surfHUDDraw && player_is_local_nonsync(_index)){
			with(_surfHUD){
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
				}
			}
			
			if(player_get_show_hud(_index, player_find_local_nonsync())){
				 // Bonus Ammo HUD:
				with(instances_matching_gt(_player, "ammo_bonus", 0)){
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
				
				 // Parrot Feathers:
				with(instances_matching(_player, "race", "parrot")){
					var _x = _ox + 116 - (104 * _side) + (3 * variable_instance_get(id, "my_health_bonus_hud", 0) * _flip),
						_y = _oy + 11,
						_spr = spr_feather,
						_skinCol = (bskin ? make_color_rgb(30, 30, 60) : make_color_rgb(80, 0, 0)),
						_output = 1 + (2 * ultra_get(race, 1)),
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
							
							if((j == 1 && _diff > 0) || abs(_diff) < 0.01){
								_hud[j] += _diff;
							}
							else{
								_hud[j] += _diff * 2/3 * current_time_scale;
							}
						}
						
						 // Extend Shootable Feathers:
						if(i < _output && _hud[0] > 0){
							_dx -= _flip;
							if(_hud[0] > _hud[1]) _dy++;
						}
						
						 // Draw:
						draw_sprite_ext(spr.Parrot[bskin].FeatherHUD, 0, _dx, _dy, _xsc, _ysc, 0, c_white, 1);
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
							}
						}
						draw_set_fog(false, 0, 0, 0);
					}
					
					 // LOW HP:
					if(_players <= 1){
						if(drawlowhp > 0 && sin(wave) > 0){
							if(my_health <= 4 && my_health != maxhealth){
								draw_set_font(fntM);
								draw_set_halign(fa_left);
								draw_set_valign(fa_top);
								draw_text_nt(110, 7, `@(color:${c_red})LOW HP`);
							}
						}
					}
				}
			}
		}
		
		 // Main Player Surface Finish:
		if(_surfHUDDraw && player_is_local_nonsync(_index)){
			_surfHUDDraw = false;
			surface_reset_target();
			with(_surfHUD){
				draw_surface(surf, x, y);
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
		if("index" in leader && player_is_local_nonsync(leader.index) && ((visible && !point_seen(x, y, leader.index)) || instance_exists(my_corpse))){
			var _icon = pet_get_mapicon(mod_type, mod_name, pet);
			
			if(sprite_exists(_icon.spr)){
				var _x = x + _icon.x,
					_y = y + _icon.y;
						
				 // Death Pointer:
				if(instance_exists(my_corpse)){
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
				if(instance_exists(my_corpse)){
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
	
	draw_set_font(fntM);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	
	instance_destroy();

#define draw_pause_pre
	if(instance_exists(PauseButton) || instance_exists(BackMainMenu)){
		 // HUD:
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
    for(var i = 0; i < array_length(global.current); i++){
        var c = lq_get_value(global.current, i);
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


#define ammo_bono(_cost, _type)
	_cost = min(ammo_bonus, _cost);
	ammo_bonus -= _cost;
	ammo[_type] += _cost;

	 // FX:
	if(_cost > 0){
		repeat(_cost) with(instance_create(x, y, WepSwap)){
			sprite_index = asset_get_index(`sprPortalL${irandom_range(1, 5)}`);
			image_blend = merge_color(c_aqua, choose(c_white, c_blue), random(0.4));
			image_speed *= random_range(0.8, 1.2);
			if(chance(1, _cost) || chance(1, 3)){
				creator = other;
			}
		}
		sound_play_pitchvol(sndLaser, 1.5 + random(1), 0.6 + random(0.3));
	}

	 // End:
	if(ammo_bonus <= 0){
		sound_play_pitchvol(sndLaserCannon, 1.4 + random(0.2), 0.8);
		sound_play_pitchvol(sndEmpty, 0.8 + random(0.1), 1);
		with(instance_create(x, y, WepSwap)){
			sprite_index = sprThrowHit;
			image_xscale = random_range(2/3, 1);
			image_yscale = image_xscale;
			image_angle = random(360);
			image_blend = c_aqua;
			creator = other;
		}
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
													draw_set_flat(_active ? b : merge_color(b, c_black, 0.5));
													draw_surface_part_ext(_surf, 0, (_sh / 2), _sw, (_sh / 2), _sx, _sy + ((_sh / 2) / _scale[s]), 1 / _scale[s], 1 / _scale[s], c_white, 1);
													draw_set_flat(-1);
												}
												else{
													draw_surface_part_ext(_surf, 0, 0, _sw, (_sh / 2) + 1, _sx,	_sy, 1/_scale[s], 1/_scale[s], c_white, 1);
													draw_set_flat(_active ? c_white : c_gray);
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
										
										if(!_avail) draw_set_flat(make_color_hsv(0, 0, 22 * (1 + _hover)));
										draw_sprite_ext(_sprt, 0.4 * current_frame, _x, _y - _selected, 1, 1, 0, (_selected ? c_white : (_hover ? c_silver : c_gray)), 1);
										if(!_avail) draw_set_flat(-1);
										
										_x += 32;
									}
									
									 // Temporary:
									if(unlock_get("parrot")){
										_x += 10;
										var _hover = point_in_rectangle(_mx - _vx, _my - _vy, _x - 24, _y - 8, _x + 24, _y + 8);
										if(_hover && button_pressed(_index, "fire")){
											sound_play(sndNoSelect);
											_x += cos(current_frame);
											_y += sin(current_frame);
										}
										draw_set_halign(fa_center);
										draw_set_valign(fa_middle);
										draw_text_nt(_x, _y - _hover, (_hover ? "@s" : "@d") + "COMING#SOON")
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
								
							draw_sprite_ext(_spr, clamp(_pop - 1, 0, (instance_exists(BackMainMenu) ? 1 : sprite_get_number(_spr) - 1)), _x, _y, -1, (game_height / 240), 0, c_white, 1);
							
							 // Icons:
							if(_pop >= 3){
								var	_col = min(4, floor(sqrt(array_length(_petList)))),
									_w = 13,
									_h = 13,
									_x = 40 - round(_w * ((_col - 1) / 2)) - (2 * (_pop <= 3)) + (_pop == 4),
									_y = 96;
									
								for(var i = 0; i < array_length(_petList); i++){
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
							if(_pop >= 5){
								draw_set_color(c_white);
								draw_set_font(fntBigName);
								draw_set_halign(fa_left);
								draw_set_valign(fa_top);
								draw_text_bn(28 + (2 * max(0, 6 - _pop)), 46, (_pet != null ? (_pet.avail ? _pet.name : "UNKNOWN") : "NONE"), 1.5);
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

#define underwater_step
     // Lightning:
    with(Lightning){
        image_index -= image_speed_raw * 0.75;

         // Zap:
        if(image_index > image_number - 1){
            with(instance_create(x, y, EnemyLightning)){
                image_speed = 0.3;
                image_angle = other.image_angle;
                image_xscale = other.image_xscale;
                hitid = 88;
                
                 // FX:
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
    with(instances_matching([Flame, TrapFire], "", null)){
        if(sprite_index != sprFishBoost){
            if(image_index > 2){
                sprite_index = sprFishBoost;
                image_index = 0;

                 // FX:
                if(chance(1, 3)){
                    var xx = x,
                        yy = y,
                        vol = 0.4;

                    if(fork()){
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

     // Watery Enemy Hurt/Death Sounds:
    with(instances_matching(enemy, "underwater_sound_check", null)){
        underwater_sound_check = true;
        if(object_index != CustomEnemy){
            if(snd_hurt != -1) snd_hurt = sndOasisHurt;
            if(snd_dead != -1) snd_dead = sndOasisDeath;
        }
    }

    with(script_bind_draw(underwater_draw, -3)) name = script[2];
    with(script_bind_end_step(underwater_end_step, 0)) name = script[2];

#define underwater_end_step
    instance_destroy();

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

     // Air Bubble Pop:
    with(global.waterBubblePop){
    	var _inst = self[0];

    	 // Follow Papa:
    	if(instance_exists(_inst) && _inst.visible){
			self[@1] = _inst.x + _inst.spr_bubble_x;
			self[@2] = _inst.y + _inst.spr_bubble_y;
			self[@3] = _inst.spr_bubble_pop;
    	}

    	 // Pop:
    	else{
    		with(_inst) spr_bubble_pop_check = null;
    		with(instance_create(self[1], self[2], BubblePop)) sprite_index = other[3];
    		global.waterBubblePop = array_delete_value(global.waterBubblePop, self);
    	}
    }

     // Clam Chests:
    with(instances_matching(ChestOpen, "waterchest", null)){
        waterchest = true;
        repeat(3) instance_create(x, y, Bubble);
        if(sprite_index == sprWeaponChestOpen) sprite_index = sprClamChestOpen;
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
    var _inst = instances_matching(hitme, "visible", true);
    with(instances_seen(instances_matching_ne(_inst, "spr_bubble", -1), 16)){
        draw_sprite(spr_bubble, -1, x + spr_bubble_x, y + spr_bubble_y);
    }
    with(instances_matching(instances_matching_ne(_inst, "spr_bubble_pop", -1), "spr_bubble_pop_check", null)){
    	spr_bubble_pop_check = true;
    	array_push(global.waterBubblePop, [id, x, y, sprPlayerBubblePop]);
    }
    
     // Boiling Water:
    draw_set_fog(1, make_color_rgb(255, 70, 45), 0, 0);
    draw_set_blend_mode(bm_add);
    with(Flame) if(sprite_index != sprFishBoost){
        var s = 1.5,
            a = 0.1;

        draw_sprite_ext(sprDragonFire, image_index + 2, x, y, image_xscale * s, image_yscale * s, image_angle, image_blend, image_alpha * a);
    }
    draw_set_blend_mode(bm_normal);
    draw_set_fog(0, 0, 0, 0);

#define underwater_sound(_state)
    global.waterSoundActive = _state;
    var _waterSound = mod_variable_get("mod", "telib", "waterSound");
    for(var i = 0; i < lq_size(_waterSound); i++){
        var _sndOasis = asset_get_index(lq_get_key(_waterSound, i));
        with(lq_get_value(_waterSound, i)){
        	var _snd = self;
        	if(_state) sound_assign(_snd, _sndOasis);
        	else sound_restore(_snd);
        }
    }

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

#define scrBossIntro(_name, _sound, _music)
	if(!instance_is(self, CustomScript) || script[2] != "scrBossIntro"){
	    sound_play(_sound);
	    sound_play_ntte("mus", _music);

		 // Bind begin_step to fix TopCont.darkness flash
	    if(_name != "" && fork()){
	    	wait 0;
			with(script_bind_begin_step(scrBossIntro, 0, _name, _sound, _music)){
				replaced = false;
				delay = 0;
				for(var i = 0; i < maxp; i++){
					delay += player_is_active(i);
				}
			}
			exit;
	    }
	}
	else{
		 // Delay in Co-op:
		if(delay > 0){
			delay -= current_time_scale;

			 // Replace Big Bandit's Intro:
			if(!replaced){
				replaced = true;
				var _path = "sprites/intros/";
		        sprite_replace_image(sprBossIntro,          _path + "spr" + _name + "Main.png", 0);
		        sprite_replace_image(sprBossIntroBackLayer, _path + "spr" + _name + "Back.png", 0);
		        sprite_replace_image(sprBossName,           _path + "spr" + _name + "Name.png", 0);
			}

			 // Call Big Bandit's Intro:
			if(delay <= 0){
				var _option = option_get("intros", 2),
					_introLast = UberCont.opt_bossintros;
	
				if(_option < 2) UberCont.opt_bossintros = _option;
				if(UberCont.opt_bossintros){
			    	var _lastSub = GameCont.subarea;
		        	with(instance_create(0, 0, BanditBoss)){
			            event_perform(ev_alarm, 6);
			            sound_stop(sndBigBanditIntro);
		            	instance_delete(id);
		            }
		            GameCont.subarea = _lastSub;
				}
				UberCont.opt_bossintros = _introLast;
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
            splash_delay = 0;
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
        if(splash_index >= array_length(unlock) - 1 && splash_timer <= 0){
        	splash_delay = 40;
        }
        array_push(unlock, u);
    }

    return u;

#define unlock_step
    if(instance_exists(Menu)){
        instance_destroy();
        exit;
    }

     // Animate Corner Popup:
    if(splash_delay > 0) splash_delay -= current_time_scale;
    else{
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
	}

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
            var t = "";
            if(_nam != ""){
	            t = _nam + " UNLOCKED";
	            draw_text_nt(_tx, _ty, t);
            }

             // Description:
            if(splash_texty <= 0){
                _ty += max(string_height("A"), string_height(t));
                draw_text_nt(_tx, _ty, "@s" + _txt);
            }
        }
    }

    draw_reset_projection();

#define scrCharmTarget()
    with(instance){
        var _x = x,
            _y = y,
			e = instances_matching_ne(enemy, "mask_index", mskNone, sprVoid);

        if("team" in self) e = instances_matching_ne(e, "team", team);
		other.target = nearest_instance(_x, _y, e);
    }

#define charm_step
	if(DebugLag) trace_time();

    var _charmList = ds_list_to_array(global.charm),
        _charmDraw = array_create(maxp + 1),
        _charmObject = [hitme, MaggotExplosion, RadMaggotExplosion, ReviveArea, NecroReviveArea, RevivePopoFreak];

	for(var i = 0; i < array_length(_charmDraw); i++){
		_charmDraw[i] = {
			inst  : [],
			depth : 9999
		};
	}

    with(_charmList){
        var _self = instance,
            _time = time,
            _index = index,
            _targetCrash = (!instance_exists(Player) && instance_is(_self, Grunt)); // References player-specific vars in its alarm event, causing a crash

        if(!instance_exists(_self)) scrCharm(_self, false);
        else{
             // Target Nearest Enemy:
            if(!instance_exists(target)) scrCharmTarget();

             // Alarms:
            var	_alarm = alarm,
            	_alarmMax = 0;

            with(_self){ // Reset Alarms
				for(var a = 0; a <= 10; a++){
                    var _alrm = alarm_get(a);
                    if(_alrm > 0){
                    	alarm_set(a, -1);
                    	_alarm[a] = _alrm;
                    	_alarmMax = a;
                    }
                    else if(_alarm[a] > 0){
                    	_alarmMax = a;
                    }
				}
			}
			for(var _alarmNum = 0; _alarmNum <= _alarmMax; _alarmNum++){
				if(_alarm[_alarmNum] > 0){
					var _alarmSpeed = 1;
	
					 // Increased Aggro:
					if(_alarmNum == 1){
						 // Not Boss:
						if(!boss){
							 // Not Shooting:
							if(("ammo" not in _self || _self.ammo <= 0) && _alarm[2] < 0){
								 // Not Shielding:
								if(array_length(instances_matching(PopoShield, "creator", _self)) <= 0){
									_alarmSpeed *= 1 + (_alarm[_alarmNum] / 10);
								}
							}
						}
					}
	
					_alarm[_alarmNum] -= _alarmSpeed * current_time_scale;
	                if(_alarm[_alarmNum] <= 0){
	                    _alarm[_alarmNum] = -1;
	
						scrCharmTarget();
	
	                    with(_self){
							var	_lastWalk = (("walk" in self) ? walk : null),
								_lastRight = (("right" in self) ? right : null),
								_lastGunangle = (("gunangle" in self) ? gunangle : null),
								_lastSpeed = speed,
								_lastDirection = direction,
								_minID = instance_create(0, 0, GameObject);
	
							instance_delete(_minID);
	
							 // Targeting:
							var _lastPos = [];
							if("target" in self){
								if(!_targetCrash){
									target = other.target;
								}

								 // Move Players to Target:
								with(Player){
									array_push(_lastPos, [id, x, y]);
									if(instance_exists(other.target)){
										x = other.target.x;
										y = other.target.y;
									}
									else{
										x = choose(0, 20000);
										y = choose(0, 20000);
									}
								}
							}

	                         // Reset Alarms:
	                        for(var a = 0; a <= 10; a++){
	                            alarm_set(a, _alarm[a]);
	                        }

	                         // Call Alarm Event:
	                        if(object_index != CustomEnemy){
								event_perform(ev_alarm, _alarmNum);
	                        }
	                        else{ // Custom Alarm Support
	                            var a = "on_alrm" + string(_alarmNum);
	                            if(a in self){
	                                var _scrt = variable_instance_get(id, a);
	                                //script_ref_call(_scrt); DO THIS INSTEAD WHEN YAL FIXES IT !?! he might not but oh well
	                                if(array_length(_scrt) >= 3){
	                                    with(self) mod_script_call_self(_scrt[0], _scrt[1], _scrt[2]);
	                                }
	                            }
	                        }
	
							 // Set Creator:
	                        with(instances_matching(instances_matching_gt(_charmObject, "id", _minID), "creator", null, noone)){
	                        	creator = other;
	                        }
	
		                     // Ally-ify Projectiles:
	                        with(instances_matching(instances_matching_gt(projectile, "id", _minID), "creator", self, noone)){
		                    	mod_script_call("mod", "telib", "charm_allyize", true);
		                    }

							 // Return Moved Players:
							with(_lastPos){
								with(self[0]){
									x = other[1];
									y = other[2];
								}
							}
	
	                        if(!instance_exists(self)) break;
	
	                    	 // Reset Alarms:
	                        for(var a = 0; a <= 10; a++){
	                            var _alrm = alarm_get(a);
	                            if(_alrm > 0){
	                            	alarm_set(a, -1);
	                            	_alarm[a] = _alrm;
	                            	_alarmMax = a;
	                            }
	                            else if(_alarm[a] > 0){
	                            	_alarmMax = a;
	                            }
	                        }
	
							 // Reset Certain Movement Vars With Increased Alarm Speed:
							if(_alarmNum == 1 && chance(_alarmSpeed - 1, _alarmSpeed)){
								if(("ammo" not in self || ammo <= 0) && _alarm[2] < 0){
									if(array_length(instances_matching(projectile, "creator", id)) <= 0){
										if(_lastWalk != null) walk = _lastWalk;
										if(_lastRight != null) right = _lastRight;
										if(_lastGunangle != null) gunangle = _lastGunangle;
										speed = _lastSpeed;
										direction = _lastDirection;
									}
								}
							}
						}
					}
				}
			}

			if(!instance_exists(_self)) scrCharm(_self, false);

            else{
                with(_self){
					target = other.target;

                    if(instance_is(self, enemy)){
                         // Contact Damage:
                        if(place_meeting(x, y, enemy)){
                            with(instances_meeting(x, y, instances_matching_ne(instances_matching_ne(enemy, "team", team), "creator", _self))){
                                if(place_meeting(x, y, other)) with(other){
                                	 // Disable Freeze Frames:
                                	var f = UberCont.opt_freeze;
                                	UberCont.opt_freeze = 0;

									 // Gamma Guts Fix (It breaks contact damage idk):
									var _gamma = skill_get(mut_gamma_guts);
									skill_set(mut_gamma_guts, false);

                                	 // Speed Up 'canmelee' Reset:
                                    if(alarm11 > 0 && alarm11 < 26){
                                    	event_perform(ev_alarm, 11);
                                    }

									 // Collision:
                                    event_perform(ev_collision, Player);

                                     // No I-Frames:
                                    with(other) nexthurt = current_frame;

                                	UberCont.opt_freeze = f;
                                	skill_set(mut_gamma_guts, _gamma);
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
                        	var _draw = _charmDraw[player_is_active(_index) ? (_index + 1) : 0];
                        	with(_draw){
	                        	array_push(inst, other);
	                        	if(other.depth < depth) depth = other.depth;
                        	}
                        }
                    }

                     // Manual Exception Stuff:
                    switch(object_index){
                        case BigMaggot:
                        case MaggotSpawn:
                        case RadMaggotChest:
                        case FiredMaggot:
                        case RatkingRage:
                        case InvSpider:			/// Charm Spawned Bros
                            if(
                            	my_health <= 0
                            	||
                            	(object_index == FiredMaggot && place_meeting(x + hspeed_raw, y + vspeed_raw, Wall))
                            	||
                            	(object_index == RatkingRage && walk > 0 && walk <= current_time_scale)
                            ){
                                var _minID = instance_create(0, 0, GameObject);
                                instance_delete(_minID);
                                instance_destroy();
								with(instances_matching_gt(_charmObject, "id", _minID)){
									creator = other;
								}
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

                                motion_add_ct(direction, 2);
                                if(instance_exists(other.target)){
                                    var s = ((object_index == JungleAssassin) ? 1 : 2) * current_time_scale;
                                    mp_potential_step(other.target.x, other.target.y, s, false);
                                }
                            }

                             // Max Speed:
                            var m = ((object_index == JungleAssassin) ? 4 : 3);
                            if(speed > m) speed = m;
                            break;

                        case Sniper:            /// Aim at Target
                            if(_alarm[2] > 5 && in_sight(other.target)){
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
                            if(_alarm[2] > 0){
                            	speed = 0;
                            	if(_alarm[2] > 8 && current_frame_active){
	                                with(instance_create(x + orandom(48), y + orandom(48), LaserCharge)){
	                                    motion_add(point_direction(x, y, other.x, other.y), 2 + random(1));
	                                    alarm0 = (point_distance(x, y, other.x, other.y) / speed) + 1;
	                                }
                            	}
                            }
                            break;

                        case LightningCrystal:  /// Ally-ify Lightning
                            if(_alarm[2] > 0) speed = 0;
                            with(instances_matching(EnemyLightning, "charmally_check", null)){
                            	charmally_check = true;
                            	if(sprite_index == sprEnemyLightning){
                            		if(team == other.team){
                            			if(!instance_exists(creator) || creator == other){
			                            	if(distance_to_object(other) < 56){
			                            		sprite_index = sprLightning;
			                            	}
                            			}
                            		}
                            	}
                            }
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
                                x -= lengthdir_x(current_time_scale, direction);
                                y -= lengthdir_y(current_time_scale, direction);
                            }
                            if(instance_exists(other.target)){
                                mp_potential_step(other.target.x, other.target.y, current_time_scale, false);
                            }
                            break;

                        case Shielder:
                        case EliteShielder:     /// Fix Shield Team
                            with(instances_matching(PopoShield, "creator", id)) team = other.team;
                            break;

						case Inspector:
						case EliteInspector:	/// Fix Telekinesis Pull
							if("charm_control_last" in self && charm_control_last){
								var _pull = (1 + (object_index == EliteInspector)) * current_time_scale;
								with(instances_matching(Player, "team", team)){
									if(point_distance(x, y, xprevious, yprevious) <= speed_raw + _pull + 1){
										if(point_distance(other.xprevious, other.yprevious, xprevious, yprevious) < 160){
											if(!place_meeting(xprevious + hspeed_raw, yprevious + vspeed_raw, Wall)){
												x = xprevious + hspeed_raw;
												y = yprevious + vspeed_raw;
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
                                x -= hspeed_raw;
                                y -= vspeed_raw;
                                direction = other.gunangle;
                                image_angle = direction;
                                x += hspeed_raw;
                                y += vspeed_raw;
                            }
                            break;
                    }

					if(instance_exists(self)){
	                	 // <3
	                	if(random(200) < current_time_scale){
	                		with(instance_create(x + orandom(8), y - random(8), AllyDamage)){
	                			sprite_index = sprHealFX;
	                			motion_add(other.direction, 1);
	                			speed /= 2;
	                			image_xscale *= random_range(2/3, 1);
	                			image_yscale = image_xscale;
	                		}
	                	}

	                     // Prevent Crashes:
	                    if(_targetCrash) target = noone;
	            	}
                }

                 // Charm Timer:
                if(instance_is(_self, hitme) && time > 0){
                    time -= time_speed * current_time_scale;
                    if(time <= 0) scrCharm(_self, false);
                }
            }
        }

         // Charm Spawned Enemies:
        with(instances_matching(instances_matching(_charmObject, "creator", _self), "ntte_charm", null)){
            var c = scrCharm(id, true);
            c.index = _index;

            if(instance_is(self, hitme)){
            	 // Kill When Uncharmed if Infinitely Spawned:
            	if("kills" in self && kills <= 0 && object_index != ScrapBossMissile){
            		c.kill = true;
	            	if("raddrop" in self) raddrop = 0;
            	}

            	 // Featherize:
	            repeat(max(_time / 90, 1)) with(obj_create(x + orandom(24), y + orandom(24), "ParrotFeather")){
	                target = other;
	            	index = _index;
	            }
            }
            else c.time = _time;
        }
    }

	with(surfCharm) active = false;
	for(var i = 0; i < array_length(_charmDraw); i++){
		var _draw = _charmDraw[i];
		if(array_length(_draw.inst) > 0){
			with(surfCharm) active = true;
	        script_bind_draw(charm_draw, _draw.depth - 0.1, _draw.inst, i - 1);
		}
	} 

	if(DebugLag) trace_time("ntte_charm_step " + string(array_length(_charmList)));

	instance_destroy();

#define charm_draw(_inst, _index)
	if(_index < 0 || _index >= maxp){
		_index = player_find_local_nonsync();
	}

	with(surfCharm){
		x = view_xview_nonsync;
		y = view_yview_nonsync;
		w = game_width;
		h = game_height;

		if(surface_exists(surf)){
			var _cts = current_time_scale;
			current_time_scale = 0.00001;

			var	_surfx = x,
				_surfy = y;

			surface_set_target(surf);
			draw_clear_alpha(0, 0);

			try{
				with(other) with(instances_seen(instances_matching_ne(_inst, "sprite_index", sprSuperFireBallerFire, sprFireBallerFire), 24)){
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

					switch(object_index){
						case SnowTank:
						case GoldSnowTank: // disable laser sights
							var a = ammo;
							ammo = 0;
					        event_perform(ev_draw, 0);
							ammo = a;
							break;

						default:
							var g = false;
							if("gonnafire" in self){ // Disable laser sights
								g = gonnafire;
								gonnafire = false;
							}

							event_perform(ev_draw, 0);

							if(g != false) gonnafire = g;
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
			var _option = option_get("outlineCharm", 2);
			if(_option > 0){
				if(_option < 2 || player_get_outlines(player_find_local_nonsync())){
					draw_set_flat(player_get_color(_index));
					for(var a = 0; a <= 360; a += 90){
						var _x = _surfx,
						    _y = _surfy;

						if(a >= 360) draw_set_flat(-1);
						else{
						    _x += dcos(a);
						    _y -= dsin(a);
						}

						draw_surface(surf, _x, _y);
					}
				}
			}

			 // Eye Shader:
			with(shadCharm) if(shad != -1){
				shader_set_vertex_constant_f(0, matrix_multiply(matrix_multiply(matrix_get(matrix_world), matrix_get(matrix_view)), matrix_get(matrix_projection)));
				shader_set(shad);
				texture_set_stage(0, surface_get_texture(other.surf));

				draw_surface(other.surf, _surfx, _surfy);

				shader_reset();
			}
		}
	}

	instance_destroy();

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

	if(is_undefined(_crown)){
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
			var _slct = instances_matching_ne(instances_matching_ne(CharSelect, "id", id), "race", 16/*=Locked in game logic??*/),
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

			 // Looping to Farthest CharSelect:
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
    for(var i = 0; i < lq_size(global.current); i++){
        audio_stop_sound(lq_get_value(global.current, i).snd);
    }

	 // Uncharm yo:
	with(ds_list_to_array(global.charm)) scrCharm(instance, false);

	 // Disable Water Sounds:
	if(global.waterSoundActive){
		underwater_sound(false);
	}

	 // Reset Bubble Pop:
    with(global.waterBubblePop){
    	with(self[0]) spr_bubble_pop_check = null;
    }


/// Scripts
#define orandom(n)																		return  random_range(-n, n);
#define chance(_numer, _denom)															return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)														return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define surflist_set(_name, _x, _y, _width, _height)									return	mod_script_call_nc("mod", "teassets", "surflist_set", _name, _x, _y, _width, _height);
#define surflist_get(_name)																return	mod_script_call_nc("mod", "teassets", "surflist_get", _name);
#define shadlist_set(_name, _vertex, _fragment)											return	mod_script_call_nc("mod", "teassets", "shadlist_set", _name, _vertex, _fragment);
#define shadlist_get(_name)																return	mod_script_call_nc("mod", "teassets", "shadlist_get", _name);
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
#define scrPickupIndicator(_text)                                                       return  mod_script_call(   "mod", "telib", "scrPickupIndicator", _text);
#define scrCharm(_instance, _charm)                                                     return  mod_script_call_nc("mod", "telib", "scrCharm", _instance, _charm);
#define scrBossHP(_hp)                                                                  return  mod_script_call(   "mod", "telib", "scrBossHP", _hp);
#define scrTopDecal(_x, _y, _area)                                                      return  mod_script_call(   "mod", "telib", "scrTopDecal", _x, _y, _area);
#define scrWaterStreak(_x, _y, _dir, _spd)                                              return  mod_script_call(   "mod", "telib", "scrWaterStreak", _x, _y, _dir, _spd);
#define scrCorpse(_dir, _spd)                                                           return  mod_script_call(   "mod", "telib", "scrCorpse", _dir, _spd);
#define scrSwap()                                                                       return  mod_script_call(   "mod", "telib", "scrSwap");
#define scrSetPet(_pet)                                                                 return  mod_script_call(   "mod", "telib", "scrSetPet", _pet);
#define scrPortalPoof()                                                                 return  mod_script_call(   "mod", "telib", "scrPortalPoof");
#define scrPickupPortalize()                                                            return  mod_script_call(   "mod", "telib", "scrPickupPortalize");
#define floor_ext(_num, _round)                                                         return  mod_script_call(   "mod", "telib", "floor_ext", _num, _round);
#define array_count(_array, _value)                                                     return  mod_script_call(   "mod", "telib", "array_count", _array, _value);
#define array_flip(_array)                                                              return  mod_script_call(   "mod", "telib", "array_flip", _array);
#define nearest_instance(_x, _y, _instances)                                            return  mod_script_call(   "mod", "telib", "nearest_instance", _x, _y, _instances);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc("mod", "telib", "instance_rectangle", _x1, _y1, _x2, _y2, _obj);
#define instances_seen(_obj, _ext)                                                      return  mod_script_call_nc("mod", "telib", "instances_seen", _obj, _ext);
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
#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)                        return  mod_script_call_nc("mod", "telib", "path_create", _xstart, _ystart, _xtarget, _ytarget, _wall);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call(   "mod", "telib", "race_get_sprite", _race, _sprite);
#define scrFloorMake(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "scrFloorMake", _x, _y, _obj);
#define scrFloorFill(_x, _y, _w, _h)                                                    return  mod_script_call(   "mod", "telib", "scrFloorFill", _x, _y, _w, _h);
#define scrFloorFillRound(_x, _y, _w, _h)                                               return  mod_script_call(   "mod", "telib", "scrFloorFillRound", _x, _y, _w, _h);
#define unlock_get(_name)                                                               return  mod_script_call_nc("mod", "telib", "unlock_get", _name);
#define unlock_set(_name, _value)                                                               mod_script_call_nc("mod", "telib", "unlock_set", _name, _value);
#define area_get_subarea(_area)                                                         return  mod_script_call(   "mod", "telib", "area_get_subarea", _area);
#define trace_lag()                                                                             mod_script_call(   "mod", "telib", "trace_lag");
#define trace_lag_bgn(_name)                                                                    mod_script_call(   "mod", "telib", "trace_lag_bgn", _name);
#define trace_lag_end(_name)                                                                    mod_script_call(   "mod", "telib", "trace_lag_end", _name);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call_nc("mod", "telib", "instance_rectangle_bbox", _x1, _y1, _x2, _y2, _obj);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   "mod", "telib", "instances_meeting", _x, _y, _obj);
#define array_delete(_array, _index)                                                    return  mod_script_call_nc("mod", "telib", "array_delete", _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call_nc("mod", "telib", "array_delete_value", _array, _value);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "instances_at", _x, _y, _obj);
#define Pet_spawn(_x, _y, _name)                                                        return  mod_script_call(   "mod", "telib", "Pet_spawn", _x, _y, _name);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc("mod", "telib", "scrFX", _x, _y, _motion, _obj);
#define array_combine(_array1, _array2)                                                 return  mod_script_call_nc("mod", "telib", "array_combine", _array1, _array2);
#define player_create(_x, _y, _index)                                                   return  mod_script_call(   "mod", "telib", "player_create", _x, _y, _index);
#define draw_set_flat(_color)                                                                   mod_script_call_nc("mod", "telib", "draw_set_flat", _color);
#define trace_error(_error)                                                                     mod_script_call_nc("mod", "telib", "trace_error", _error);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc("mod", "telib", "sleep_max", _milliseconds);
#define array_clone_deep(_array)                                                        return  mod_script_call_nc("mod", "telib", "array_clone_deep", _array);
#define lq_clone_deep(_obj)                                                             return  mod_script_call_nc("mod", "telib", "lq_clone_deep", _obj);
#define array_exists(_array, _value)                                                    return  mod_script_call_nc("mod", "telib", "array_exists", _array, _value);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc("mod", "telib", "wep_merge", _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call(   "mod", "telib", "wep_merge_decide", _hardMin, _hardMax);
#define array_shuffle(_array)                                                           return  mod_script_call_nc("mod", "telib", "array_shuffle", _array);
#define view_shift(_index, _dir, _pan)                                                          mod_script_call_nc("mod", "telib", "view_shift", _index, _dir, _pan);
#define stat_get(_name)                                                                 return  mod_script_call_nc("mod", "telib", "stat_get", _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc("mod", "telib", "stat_set", _name, _value);
#define option_get(_name, _default)                                                     return  mod_script_call_nc("mod", "telib", "option_get", _name, _default);
#define option_set(_name, _value)                                                               mod_script_call_nc("mod", "telib", "option_set", _name, _value);
#define sound_play_hit_ext(_sound, _pitch, _volume)                                     return  mod_script_call_nc("mod", "telib", "sound_play_hit_ext", _sound, _pitch, _volume);
#define area_get_secret(_area)                                                          return  mod_script_call_nc("mod", "telib", "area_get_secret", _area);
#define area_get_underwater(_area)                                                      return  mod_script_call_nc("mod", "telib", "area_get_underwater", _area);
#define path_shrink(_path, _wall, _skipMax)                                             return  mod_script_call_nc("mod", "telib", "path_shrink", _path, _wall, _skipMax);
#define path_direction(_x, _y, _path, _wall)                                            return  mod_script_call_nc("mod", "telib", "path_direction", _x, _y, _path, _wall);
#define rad_drop(_x, _y, _raddrop, _dir, _spd)                                          return  mod_script_call_nc("mod", "telib", "rad_drop", _x, _y, _raddrop, _dir, _spd);
#define rad_path(_inst, _target)                                                        return  mod_script_call_nc("mod", "telib", "rad_path", _inst, _target);
#define area_get_name(_area, _subarea, _loop)                                           return  mod_script_call_nc("mod", "telib", "area_get_name", _area, _subarea, _loop);
#define draw_text_bn(_x, _y, _string, _angle)                                                   mod_script_call_nc("mod", "telib", "draw_text_bn", _x, _y, _string, _angle);