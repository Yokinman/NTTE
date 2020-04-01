#define init
	global.sprLoad = sprite_add("sprites/menu/sprNTTELoading.png", 2, 32, 8);
	
	 // Loading Vars:
	global.load = 0;
	global.load_max = 0;
	global.load_hudy = 0;
	global.load_hudb = 0;
	global.load_text = "";
	
	 // Coop Delay Increase:
	var _coop = -1;
	for(var i = 0; i < maxp; i++) _coop += player_is_active(i);
	_coop *= 2;
	
	 // Mods:
	global.list = [ // [mod, delay]
		["teassets.mod.gml",                        5 + _coop, "Assets"],
		["telib.mod.gml",                           1 + _coop, "Main Files"],
		["temenu.mod.gml",                          1 + _coop],
		["teevents.mod.gml",                        1 + _coop],
		["ntte.mod.gml",                            1 + _coop],
		["petlib.mod.gml",                          1 + _coop],
		["objects/tegeneral.mod.gml",               0 + _coop, "Objects"],
		["objects/tepickups.mod.gml",               1 + _coop],
		["objects/tedesert.mod.gml",                0 + _coop],
		["objects/tecoast.mod.gml",                 1 + _coop],
		["objects/teoasis.mod.gml",                 0 + _coop],
		["objects/tetrench.mod.gml",                1 + _coop],
		["objects/tesewers.mod.gml",                0 + _coop],
		["objects/tescrapyard.mod.gml",             0 + _coop],
		["objects/tecaves.mod.gml",                 1 + _coop],
		["objects/telabs.mod.gml",					1 + _coop],
		["areas/coast.area.gml",                    1 + _coop, "Areas"],
		["areas/oasis.area.gml",                    1 + _coop],
		["areas/trench.area.gml",                   1 + _coop],
		["areas/pizza.area.gml",                    1 + _coop],
		["areas/lair.area.gml",                     1 + _coop],
		["areas/red.area.gml",                      1 + _coop],
		["races/parrot.race.gml",                   1 + _coop, "Characters"],
		["skins/red crystal.skin.gml",              1 + _coop, "Skins"],
		["skills/compassion.skill.gml",             1 + _coop, "Mutations"],
		["skills/reroll.skill.gml",                 1 + _coop],
		["crowns/bonus.crown.gml",                  0 + _coop],
		["crowns/red.crown.gml",                    0 + _coop],
		["crowns/crime.crown.gml",                  1 + _coop, "Crowns"],
		["weps/merge.wep.gml",                      1 + _coop, "Weapons"],
		["weps/crabbone.wep.gml",                   1],
		["weps/scythe.wep.gml",                     1],
		["weps/bat disc launcher.wep.gml",          1],
		["weps/bat disc cannon.wep.gml",            1],
		["weps/harpoon launcher.wep.gml",           1],
		["weps/net launcher.wep.gml",               1],
		["weps/clam shield.wep.gml",                1],
		["weps/trident.wep.gml",                    1],
		["weps/bubble rifle.wep.gml",               1],
		["weps/bubble shotgun.wep.gml",             1],
		["weps/bubble minigun.wep.gml",             1],
		["weps/bubble cannon.wep.gml",              1],
		["weps/hyper bubbler.wep.gml",              1],
		["weps/lightring launcher.wep.gml",         1],
		["weps/super lightring launcher.wep.gml",   1],
		["weps/tesla coil.wep.gml",                 1],
		["weps/electroplasma rifle.wep.gml",        1],
		["weps/electroplasma shotgun.wep.gml",      1],
		["weps/quasar blaster.wep.gml",             1],
		["weps/quasar rifle.wep.gml",               1],
		["weps/quasar cannon.wep.gml",              1]
	];
	global.load_max += array_length(global.list);
	
	 // Waiting for...
	while(
		!mod_sideload() // Mod loading permissions
		||
		(!instance_exists(Menu) || Menu.mode == 0) // Menu to exist
		||
		global.load_hudy < 0.99 // Loading bar to appear
	){
		wait 0;
	}
	
	 // Load Mods:
	with(global.list){
		var	_load = self[0],
			_wait = self[1];
			
		mod_load(_load);
		
		 // Advance Loading Bar:
		global.load += 1 + random(0.2);
		if(array_length(self) > 2) global.load_text = self[2];
		
		 // Delay:
		if(_wait > 0) wait _wait;
		
		 // Wait for Sprites:
		if(array_length(mod_variable_get("mod", "teassets", "spr_load")) > 0){
			var _perc = 0.2;
			
			global.load /= (1 - _perc)
			global.load_max /= (1 - _perc);
			
			var	l = global.load,
				m = global.load_max * _perc;
				
			while(true){
				var _sprLoad = mod_variable_get("mod", "teassets", "spr_load");
				if(array_length(_sprLoad) > 0){
					global.load = (l + (m * (_sprLoad[0, 1] / array_length(_sprLoad[0, 0]))));
				}
				else break;
				wait 0;
			}
		}
	}
	
	 // Finished:
	global.load_text = `@q@(color:${make_color_rgb(150, 40, 240)})Complete!`;
	sound_play_pitchvol(sndEXPChest, 1.5 + random(0.1), 0.6);
	sound_play_pitchvol(sndNoSelect, 0.6 + random(0.1), 0.5);
	while(global.load_hudy > 0) wait 0;
	mod_loadtext("main3.txt");
	
#define step
	with(instances_matching(Menu, "teloaderbar_reset", null)){
		teloaderbar_reset = true;
		global.load_hudy = 0;
	}
	
#define draw_gui
	 // Hiding/Showing Loading Bar:
	if(global.load < global.load_max){
		if(global.load_hudy <= 0){
			sound_play_pitchvol(sndMeleeFlip, 1.4 + random(0.1), 0.25);
			sound_play_pitchvol(sndHitMetal,  1.4 + random(0.1), 0.25);
		}
		global.load_hudy += (1 - global.load_hudy) * 0.3;
	}
	else{
		if(global.load_hudb < 2){
			global.load_hudb += 0.15;
		}
		else global.load_hudy -= 0.4;
	}
	
	 // Loading Bar:
	var	_x = round(game_width / 2),
		_y = round(22 * global.load_hudy),
		_spr = global.sprLoad,
		_load = (global.load / global.load_max);
		
	draw_set_fog(true, c_black, 0, 0);
	draw_sprite(_spr, 0, _x + 1, _y);
	draw_sprite(_spr, 0, _x - 1, _y);
	draw_sprite(_spr, 0, _x + 1, _y + 1);
	draw_sprite(_spr, 0, _x - 1, _y + 1);
	draw_set_fog(false, 0, 0, 0);
	draw_sprite(_spr, 0, _x, _y);
	
	for(var i = 0; i <= 1; i++){
		var	_bloom = clamp(global.load_hudb, 0.4, i),
			_xsc = 1 + (0.15 * _bloom),
			_ysc = 1 + (0.5 * _bloom),
			_alp = ((i <= 0) ? 1 : (0.25 - (0.025 * global.load_hudb)));
			
		if(_alp > 0){
			if(i > 0) draw_set_blend_mode(bm_add);
			
			draw_sprite_part_ext(
				_spr,
				1,
				0,
				0,
				(sprite_get_width(_spr) * _load) + i,
				sprite_get_height(_spr),
				_x - (_xsc * sprite_get_xoffset(_spr)),
				_y - (_ysc * sprite_get_yoffset(_spr)),
				_xsc,
				_ysc,
				c_white,
				_alp
			);
		}
	}
	draw_set_blend_mode(bm_normal);
	
	 // % Text:
	draw_set_font(fntM);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text_nt(_x + (string_width("%") / 4), _y, `${round(_load * 100)}%`);
	
	 // Loading Text:
	if(global.load_text != ""){
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_text_nt(_x + 33, _y - 7, "Loading");
		draw_set_font(fntSmall);
		var t = global.load_text;
		if(global.load < global.load_max){
			t += string_repeat(".", round(1.5 + (1.5 * sin(global.load))))
		}
		draw_text_nt(_x + 34, _y + 2, t);
	}
	else{
		var _text = "";
		if(!instance_exists(Menu)){
			_text = "RETURN TO THE @yCAMPFIRE";
		}
		else if(!mod_sideload()){
			_text = `/@yallowmod @w${mod_current}.mod`;
		}
		
		if(_text != ""){
			draw_set_font(fntSmall);
			draw_set_halign(fa_center);
			draw_set_valign(fa_top);
			draw_text_nt(_x, _y + 12, _text);
		}
	}
	