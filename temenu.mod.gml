#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	mus = mod_variable_get("mod", "teassets", "mus");
	sav = mod_variable_get("mod", "teassets", "sav");
	
	areaList = mod_variable_get("mod", "teassets", "area");
	raceList = mod_variable_get("mod", "teassets", "race");
	crwnList = mod_variable_get("mod", "teassets", "crwn");
	wepsList = mod_variable_get("mod", "teassets", "weps");
	
	NTTEMenu = {
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
							"Slaughter"		+ ".petlib.mod",
							"CoolGuy"		+ ".petlib.mod",
							"Salamander"	+ ".petlib.mod",
							"Mimic"			+ ".petlib.mod",
							"Octo"			+ ".petlib.mod",
							"Spider"		+ ".petlib.mod",
							"Prism"			+ ".petlib.mod",
							"Orchid"		+ ".petlib.mod",
							"Weapon"		+ ".petlib.mod"
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
						},
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
		var	_race = self,
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
	
	 // Loadout Crown System:
	global.loadout_crown = {
		size : [],
		race : {},
		camp : crwn_none
	};
	global.clock_fix = false;
	if(instance_exists(LoadoutCrown)){
		with(loadbutton) instance_destroy();
		with(Loadout) selected = false;
	}
	surfCrownHide       = surflist_set("CrownHide",       0, 0, 32, 32);
	surfCrownHideScreen = surflist_set("CrownHideScreen", 0, 0, game_width, game_height);
	
	 // Mouse:
	global.mouse_x_previous = array_create(maxp, 0);
	global.mouse_y_previous = array_create(maxp, 0);
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro areaList global.area
#macro raceList global.race
#macro crwnList global.crwn
#macro wepsList global.weps

#macro surfCrownHide       global.surfCrownHide
#macro surfCrownHideScreen global.surfCrownHideScreen

#macro NTTEMenu         global.menu
#macro MenuOpen         NTTEMenu.open
#macro MenuSlct         NTTEMenu.slct
#macro MenuPop          NTTEMenu.pop
#macro MenuList         NTTEMenu.list
#macro MenuSplat        NTTEMenu.splat
#macro MenuSplatBlink   NTTEMenu.splat_blink
#macro MenuSplatOptions NTTEMenu.splat_options

#macro menu_options 0
#macro menu_stats   1
#macro menu_credits 2
#macro menu_base    menu_options

#macro opt_title  -1
#macro opt_toggle  0
#macro opt_slider  1

#macro stat_base    0
#macro stat_time    1
#macro stat_display 2

#macro cred_artist     `@(color:${make_color_rgb(30, 160, 240)})`
#macro cred_coder      `@(color:${make_color_rgb(250, 170, 0)})`
#macro cred_music      `@(color:${make_color_rgb(255, 60, 0)})`
#macro cred_twitter    cred_artist	+ "Twitter: @w"
#macro cred_itchio     cred_coder	+ "Itch.io: @w"
#macro cred_soundcloud cred_music	+ "Soundcloud: @w"
#macro cred_discord    `@(color:${make_color_rgb(160, 70, 200)})Discord: @w`
#macro cred_yellow     "@y"

#macro crownPlayer player_find_local_nonsync()
#macro crownSize   global.loadout_crown.size
#macro crownRace   global.loadout_crown.race
#macro crownCamp   global.loadout_crown.camp
#macro crownIconW  28
#macro crownIconH  28
#macro crownPath   "crownCompare/"
#macro crownPathD  ""
#macro crownPathA  "A"
#macro crownPathB  "B"

#define chat_command(_cmd, _arg, _ind)
	if(string_upper(_cmd) == "NTTE"){
		NTTEMenu.open = !NTTEMenu.open;
		return true;
	}
	
#define game_start
	 // Reset Haste Hands:
	if(global.clock_fix){
		global.clock_fix = false;
		sprite_restore(sprClockParts);
	}
	
	 // Special Loadout Crown Selected:
	var	p = crownPlayer,
		_crown = lq_get(crownRace, player_get_race_fix(p)),
		_crownPoints = GameCont.crownpoints;
		
	if(!is_undefined(_crown)){
		if(_crown.custom.slct != -1 && crown_current == _crown.slct && _crown.custom.slct != _crown.slct){
			switch(_crown.custom.slct){
				case crwn_random:
					 // Get Unlocked Crowns:
					var	_listLocked = [],
						_list = [];
						
					with(_crown.icon) if(locked){
						array_push(_listLocked, crwn);
					}
					for(var i = crwn_death; i <= crwn_protection; i++){
						if(array_find_index(_listLocked, i) < 0) array_push(_list, i);
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
	
#define step
	script_bind_draw(draw_menu, (instance_exists(Menu) ? Menu.depth : object_get_depth(Menu)) - 0.1);
	
	 // Loadout Crowns:
	if(instance_exists(Menu)){
		with([surfCrownHide, surfCrownHideScreen]) active = true;
		with(Menu){
			with(Loadout) if(selected == false && openanim > 0){
				openanim = 0; // Bro they actually forgot to reset this when the loadout is closed (<= v9940)
			}
			
			 // Bind Drawing:
			script_bind_draw(draw_crown, object_get_depth(LoadoutCrown) - 1);
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
							other.y = y + random_range(-8, 8);
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
	else{
		with([surfCrownHide, surfCrownHideScreen]) active = false;
		
		 // For CharSelection Crown Boy:
		crownCamp = crown_current;
	}
	
#define draw_gui_end
	 // Save Previous Mouse Position:
	for(var i = 0; i < maxp; i++){
		global.mouse_x_previous[i] = mouse_x[i];
		global.mouse_y_previous[i] = mouse_y[i];
	}
	
#define draw_pause
	draw_set_projection(0);
	
	 // NTTE Options Button:
	if(!MenuOpen){
		if(instance_exists(OptionMenuButton)){
			var _draw = true;
			with(OptionMenuButton) if(alarm_get(0) >= 1 || alarm_get(1) >= 1) _draw = false;
			if(_draw){
				var	_x = (game_width / 2),
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
						var	_dx = (game_width / 2),
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
	
	 // Main Code:
	ntte_menu();
	
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
					mod_script_call("mod", "teassets", "loadout_behind");
				}
			}
		}
		
		 // Open:
		else{
			var	_hover = false,
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
			
			var	_x2 = _x1 + 40,
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
	
#define draw_crown
	var	p = crownPlayer,
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
			var	_crownList = instances_matching(LoadoutCrown, "", null),
				_col = 2,  // crwn_none column
				_row = -1; // crwn_none row
				
			for(var i = array_length(_crownList) - 1; i >= 0; i--){
				var n = ((array_length(_crownList) - 1) - i);
				
				array_push(_crown.icon, {
					inst : _crownList[i],
					crwn : n + 1,
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
				if((n % 4) == 0){
					_col = 0;
					_row++;
				}
				
				 // Delay Crowns (Necessary for scanning the image without any overlapping):
				with(_crownList[i]){
					alarm_set(0, 4 - floor((n - 1) / 4));
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
					alarm0 : -1,
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
					
					if(alarm0 < 0) alarm0 = max(1, 5 - diy);
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
			
			var	_text = (locked ? "LOCKED" : crown_get_name(crwn) + "#@s" + crown_get_text(crwn)),
				_x = x,
				_y = y - 5 - hover; // NTT header fix: max(, _vy + 24 + string_height(_text))
				
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
	
	 // LoadoutSkin Offset:
	with(instances_matching(LoadoutSkin, "ntte_crown_xoffset", null)){
		ntte_crown_xoffset = -22;
		xstart += ntte_crown_xoffset;
	}
	
	instance_destroy();
	
#define loadout_behind
	instance_destroy();
	
	var	p = crownPlayer,
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
	
#define player_get_race_fix(p) /// Used for custom crown loadout
	var _race = player_get_race(p);
	
	 // Fix 1 Frame Delay Thing:
	var _raceChange = (button_pressed(p, "east") - button_pressed(p, "west"));
	if(_raceChange != 0){
		var _new = _race;
		
		with(instances_matching(CharSelect, "race", _race)){
			var	_slct = instances_matching_ne(instances_matching_ne(CharSelect, "id", id), "race", 16/*==Locked in game logic??*/),
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
				var	_tx = game_width - 3,
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
					var	_text = lq_get_key(MenuList, m),
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
			var	_menu = lq_get_value(MenuList, _menuCurrent),
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
							var	_option = _menuList[i],
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
						var	_tx = game_width,
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
							var	_text = lq_get_key(_menuList, i),
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
					var	_statMenu = lq_get_value(_menuList, _statSlct),
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
								var	_x = 0,
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
							var	_petStatList = lq_defget(lq_defget(sav, "stat", {}), "pet", {}),
								_list = array_clone(_statMenu.list);
								
							for(var i = 0; i < lq_size(_petStatList); i++){
								var k = lq_get_key(_petStatList, i);
								if(!array_exists(_list, k)) array_push(_list, k);
							}
							
							 // Compile Pet List:
							var _petList = {};
							with(_list){
								var	_pet = self,
									_split = string_split(_pet, ".");
									
								if(array_length(_split) >= 3){
									var	_petName = _split[0],
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
							var	_x = (instance_exists(BackMainMenu) ? -48 : -96),
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
								var	_swaph = (button_pressed(_index, "east") - button_pressed(_index, "west")),
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
										if(_swapv != 0) _slct = min(_slct, lq_size(_petList) - 1);
										
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
									var	_pet = lq_get_key(_petList, i),
										_info = lq_get_value(_petList, i),
										_icon = pet_get_icon(_info.mod_type, _info.mod_name, _info.name),
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
										_x -= ceil(_w * (_col - max(0, (_col - ((lq_size(_petList) - 1) - i)) / 2)));
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
							var	_x = -64,
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
													_name = (_unlock ? unlock_get_name(self[0]) : "LOCKED"),
													_selected = (_unlock && _slct[_index] == array_find_index(other.list, self)),
													_hover = false;
													
												if(_selected){
													with(UberCont){
														var	_dx = _sx + 116,
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
									var	_name = self[0],
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
	
#define cleanup
	 // Fix Options:
	if(MenuOpen){
		with(Menu) mode = 0;
		sound_volume(sndMenuCharSelect, 1);
	}
	
	 // Reset Clock Parts:
	if(global.clock_fix) sprite_restore(sprClockParts);
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define in_range(_num, _lower, _upper)                                                  return  (_num >= _lower && _num <= _upper);
#define frame_active(_interval)                                                         return  (current_frame % _interval) < current_time_scale;
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define surflist_set(_name, _x, _y, _width, _height)                                    return  mod_script_call_nc('mod', 'teassets', 'surflist_set', _name, _x, _y, _width, _height);
#define surflist_get(_name)                                                             return  mod_script_call_nc('mod', 'teassets', 'surflist_get', _name);
#define shadlist_set(_name, _vertex, _fragment)                                         return  mod_script_call_nc('mod', 'teassets', 'shadlist_set', _name, _vertex, _fragment);
#define shadlist_get(_name)                                                             return  mod_script_call_nc('mod', 'teassets', 'shadlist_get', _name);
#define shadlist_setup(_shader, _texture, _args)                                        return  mod_script_call_nc('mod', 'telib', 'shadlist_setup', _shader, _texture, _args);
#define option_get(_name, _default)                                                     return  mod_script_call_nc('mod', 'telib', 'option_get', _name, _default);
#define option_set(_name, _value)                                                               mod_script_call_nc('mod', 'telib', 'option_set', _name, _value);
#define stat_get(_name)                                                                 return  mod_script_call_nc('mod', 'telib', 'stat_get', _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc('mod', 'telib', 'stat_set', _name, _value);
#define unlock_get(_name)                                                               return  mod_script_call_nc('mod', 'telib', 'unlock_get', _name);
#define unlock_set(_name, _value)                                                               mod_script_call_nc('mod', 'telib', 'unlock_set', _name, _value);
#define unlock_get_name(_name)                                                          return  mod_script_call_nc('mod', 'telib', 'unlock_get_name', _name);
#define array_exists(_array, _value)                                                    return  mod_script_call_nc('mod', 'telib', 'array_exists', _array, _value);
#define array_combine(_array1, _array2)                                                 return  mod_script_call_nc('mod', 'telib', 'array_combine', _array1, _array2);
#define draw_text_bn(_x, _y, _string, _angle)                                                   mod_script_call_nc('mod', 'telib', 'draw_text_bn', _x, _y, _string, _angle);
#define pet_get_icon(_modType, _modName, _name)                                         return  mod_script_call(   'mod', 'telib', 'pet_get_icon', _modType, _modName, _name);