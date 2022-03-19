#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define race_name              return "BEETLE";
#define race_text              return "PASSIVE#CAN MERGE WEAPONS";
#define race_lock              return "???";
#define race_unlock            return "???";
#define race_tb_text           return "???";
#define race_portrait(_p, _b)  return race_sprite_raw("Portrait", _b);
#define race_mapicon(_p, _b)   return race_sprite_raw("Map",      _b);
#define race_avail             return true;//call(scr.unlock_get, "race:" + mod_current);

#define race_ttip
	 // Ultra:
	if(GameCont.level >= 10 && chance(1, 5)){
		return choose(
			"ULTRA TIP A",
			"ULTRA TIP B",
			"ULTRA TIP C"
		);
	}
	
	 // Normal:
	return choose(
		"TIP A",
		"TIP B",
		"TIP C"
	);
	
#define race_sprite(_sprite)
	var _b = (("bskin" in self && is_real(bskin)) ? bskin : 0);
	
	switch(_sprite){
		case sprMutant1Idle      : return race_sprite_raw("Idle",         _b);
		case sprMutant1Walk      : return race_sprite_raw("Walk",         _b);
		case sprMutant1Hurt      : return race_sprite_raw("Hurt",         _b);
		case sprMutant1Dead      : return race_sprite_raw("Dead",         _b);
		case sprMutant1GoSit     : return race_sprite_raw("GoSit",        _b);
		case sprMutant1Sit       : return race_sprite_raw("Sit",          _b);
		case sprFishMenu         : return race_sprite_raw("Menu",         _b);
		case sprFishMenuSelected : return race_sprite_raw("MenuSelected", _b);
		case sprFishMenuSelect   : return race_sprite_raw("MenuSelect",   _b);
		case sprFishMenuDeselect : return race_sprite_raw("MenuDeselect", _b);
	}
	
	return -1;
	
#define race_sound(_snd)
	var _sndNone = sndFootPlaSand5; // playing a sound that doesn't exist using sound_play_pitch/sound_play_pitchvol modifies sndSwapPistol's pitch/volume
	
	switch(_snd){
		case sndMutant1Wrld : return sndMutant1Wrld;
		case sndMutant1Hurt : return sndMutant1Hurt;
		case sndMutant1Dead : return sndMutant1Dead;
		case sndMutant1LowA : return sndMutant1LowA;
		case sndMutant1LowH : return sndMutant1LowH;
		case sndMutant1Chst : return sndMutant1Chst;
		case sndMutant1Valt : return sndMutant1Valt;
		case sndMutant1Crwn : return sndMutant1Crwn;
		case sndMutant1Spch : return sndMutant1Spch;
		case sndMutant1IDPD : return sndMutant1IDPD;
		case sndMutant1Cptn : return sndMutant1Cptn;
		case sndMutant1Thrn : return sndMutant1Thrn;
	}
	
	return -1;
	
#define race_sprite_raw(_sprite, _skin)
	var _skinSpriteMapList = lq_defget(spr.Race, mod_current, []);
	
	if(_skin >= 0 && _skin < array_length(_skinSpriteMapList)){
		return lq_defget(_skinSpriteMapList[_skin], _sprite, -1);
	}
	
	return -1;
	
	
/// Menu
#define race_menu_select
	return sndMutant1Slct;
	
#define race_menu_confirm
	return sndMutant1Cnfm;
	
#define race_menu_button
	sprite_index = race_sprite_raw("Select", 0);
	image_index = !race_avail();
	
	
/// Skins
#define race_skins
	var _playersActive = 0;
	for(var i = 0; i < maxp; i++){
		_playersActive += player_is_active(i);
	}
	
	 // Normal:
	if(_playersActive <= 1){
		return 2;
	}
	
	 // Co-op Bugginess:
	var _num = 0;
	while(_num == 0 || call(scr.unlock_get, `skin:${mod_current}:${_num}`)){
		_num++;
	}
	return _num;
	
#define race_skin_avail(_skin)
	var _playersActive = 0;
	for(var i = 0; i < maxp; i++){
		_playersActive += player_is_active(i);
	}
	
	 // Normal:
	if(_playersActive <= 1){
		return (_skin == 0 || call(scr.unlock_get, `skin:${mod_current}:${_skin}`));
	}
	
	 // Co-op Bugginess:
	return true;
	
#define race_skin_name(_skin)
	if(race_skin_avail(_skin)){
		return chr(65 + _skin) + " SKIN";
	}
	else{
		return race_skin_lock(_skin);
	}
	
#define race_skin_lock(_skin)
	switch(_skin){
		case 0 : return "EDIT THE SAVE FILE LMAO";
		case 1 : return "???";
	}
	
#define race_skin_unlock(_skin)
	switch(_skin){
		case 0 : return "???";
		case 1 : return "???";
	}
	
#define race_skin_button(_skin)
	sprite_index = race_sprite_raw("Loadout", _skin);
	image_index  = !race_skin_avail(_skin);
	
	
/// Ultras
#macro ultA 1
#macro ultB 2

#define race_ultra_name(_ultra)
	switch(_ultra){
		case ultA : return "ULTRA A";
		case ultB : return "ULTRA B";
	}
	return "";
	
#define race_ultra_text(_ultra)
	switch(_ultra){
		case ultA : return "???";
		case ultB : return "???";
	}
	return "";
	
#define race_ultra_button(_ultra)
	sprite_index = race_sprite_raw("UltraIcon", 0);
	image_index  = _ultra - 1; // why are ultras 1-based bro
	
#define race_ultra_icon(_ultra)
	return race_sprite_raw("UltraHUD" + chr(64 + _ultra), 0);
	
#define race_ultra_take(_ultra, _state)
	 // Ultra Sound:
	if(_state != 0 && instance_exists(EGSkillIcon)){
		sound_play(sndBasicUltra);
		
		switch(_ultra){
			case ultA:
				break;
				
			case ultB:
				break;
		}
	}
	
	
#define race_swep
	return "beetle pistol";
	
	
#define create
	 // Random lets you play locked characters: (Can remove once 9941+ gets stable build)
	if(!race_avail()){
		race = "fish";
		player_set_race(index, race);
		exit;
	}
	
	 // Sound:
	snd_wrld = race_sound(sndMutant1Wrld);
	snd_hurt = race_sound(sndMutant1Hurt);
	snd_dead = race_sound(sndMutant1Dead);
	snd_lowa = race_sound(sndMutant1LowA);
	snd_lowh = race_sound(sndMutant1LowH);
	snd_chst = race_sound(sndMutant1Chst);
	snd_valt = race_sound(sndMutant1Valt);
	snd_crwn = race_sound(sndMutant1Crwn);
	snd_spch = race_sound(sndMutant1Spch);
	snd_idpd = race_sound(sndMutant1IDPD);
	snd_cptn = race_sound(sndMutant1Cptn);
	snd_thrn = race_sound(sndMutant1Thrn);
	footkind = 4; // Metal
	
	 // Character-Specific Vars:
	beetle_last_usespec                 = 0;
	beetle_menu_is_open                 = false;
	beetle_menu_scale                   = 0;
	beetle_menu_wkick                   = undefined;
	beetle_menu_bwkick                  = undefined;
	beetle_menu_wep                     = wep_none;
	beetle_menu_bwep                    = wep_none;
	beetle_menu_wep_selection_wep_list  = [];
	beetle_menu_bwep_selection_wep_list = [];
	beetle_menu_selection_wep_index     = 0;
	beetle_menu_selection_angle         = 0;
	beetle_menu_selection_state         = undefined;
	beetle_menu_selection_trail_last_x  = x;
	beetle_menu_selection_trail_last_y  = y;
	beetle_menu_merging_scale           = 0;
	beetle_menu_merging_wep_index_list  = [];
	beetle_menu_merging_wep_name        = "";
	beetle_menu_merging_wep_sprite      = mskNone;
	
	 // Re-Get Ultras When Revived:
	/*for(var i = 0; i < ultra_count(mod_current); i++){
		if(ultra_get(mod_current, i)){
			race_ultra_take(i, true);
		}
	}*/
	
#define step
	if(lag) trace_time();
	
	 // Open Weapon Merging Menu:
	var	_menuWasOpen    = beetle_menu_is_open,
		_specIsPressed  = button_pressed(index, "spec"),
		_specIsReleased = button_released(index, "spec");
		
	if((usespec > 0) != (beetle_last_usespec > 0)){
		if(usespec > 0){
			_specIsPressed = true;
		}
		else{
			_specIsReleased = true;
		}
	}
	
	if(_specIsPressed && !beetle_menu_is_open && canspec && player_active){
		beetle_menu_is_open         = !beetle_menu_is_open;
		beetle_menu_selection_angle = gunangle;
	}
	
	beetle_last_usespec = usespec;
	
	 // Weapon Merging Menu:
	if(beetle_menu_is_open){
		var _menuSelectionWepListSize = 0;
		
		 // Setup Merged Weapon Parts:
		for(var _wepIndex = 0; _wepIndex <= 1; _wepIndex++){
			var	_wepVarName              = ((_wepIndex == 0) ? "wep" : "bwep"),
				_wep                     = variable_instance_get(self, _wepVarName),
				_menuWep                 = variable_instance_get(self, `beetle_menu_${_wepVarName}`),
				_menuWepSelectionWepList = variable_instance_get(self, `beetle_menu_${_wepVarName}_selection_wep_list`);
				
			if(_menuWep != _wep){
				_menuWep                 = _wep;
				_menuWepSelectionWepList = [];
				variable_instance_set(self, `beetle_menu_${_wepVarName}`,                    _menuWep);
				variable_instance_set(self, `beetle_menu_${_wepVarName}_selection_wep_list`, _menuWepSelectionWepList);
				
				 // Deselect Previous Weapon Parts:
				if(beetle_menu_selection_wep_index > _menuSelectionWepListSize){
					beetle_menu_selection_wep_index = _menuSelectionWepListSize;
				}
				with(beetle_menu_merging_wep_index_list){
					if(self >= _menuSelectionWepListSize){
						other.beetle_menu_merging_wep_index_list = call(scr.array_delete_value, other.beetle_menu_merging_wep_index_list, self);
					}
				}
				
				 // Add Weapon Parts to List:
				while(true){
					if(call(scr.wep_raw, _menuWep) != wep_none){
						array_push(_menuWepSelectionWepList, _menuWep);
					}
					if(call(scr.weapon_has_temerge, _menuWep)){
						_menuWep = call(scr.weapon_get_temerge_weapon, _menuWep);
					}
					else break;
				}
			}
			
			_menuSelectionWepListSize += array_length(_menuWepSelectionWepList);
		}
		
		 // Weapon Selection:
		if(_menuSelectionWepListSize > 0){
			beetle_menu_selection_wep_index = round(_menuSelectionWepListSize * (1 + ((gunangle - beetle_menu_selection_angle) / 360))) % _menuSelectionWepListSize;
			
			 // Toggle Current Weapon's Selection:
			if(button_check(index, "fire") && beetle_menu_scale > 0.75){
				call(scr.motion_step, self, 1);
				
				var	_menuSelectionTrailX        = x + lengthdir_x(10, gunangle),
					_menuSelectionTrailY        = y + lengthdir_y(10, gunangle),
					_menuSelectionWepList       = call(scr.array_combine, beetle_menu_wep_selection_wep_list, beetle_menu_bwep_selection_wep_list),
					_menuSelectionWepIsSelected = (array_find_index(beetle_menu_merging_wep_index_list, beetle_menu_selection_wep_index) >= 0),
					_menuSelectionWep           = _menuSelectionWepList[beetle_menu_selection_wep_index];
					
				call(scr.motion_step, self, -1);
				
				 // Store Selection State:
				if(beetle_menu_selection_state == undefined){
					beetle_menu_selection_state = !_menuSelectionWepIsSelected;
				}
				
				 // Selection Hand Trail:
				else with(instance_create(_menuSelectionTrailX, _menuSelectionTrailY, BoltTrail)){
					image_angle  = point_direction(x, y, other.beetle_menu_selection_trail_last_x, other.beetle_menu_selection_trail_last_y);
					image_xscale = point_distance(x, y, other.beetle_menu_selection_trail_last_x, other.beetle_menu_selection_trail_last_y);
					image_yscale = 1.5;
					image_blend  = c_black;
					depth        = other.depth + 1;
				}
				beetle_menu_selection_trail_last_x = _menuSelectionTrailX;
				beetle_menu_selection_trail_last_y = _menuSelectionTrailY;
				
				 // Toggle Selection:
				if(beetle_menu_selection_state != _menuSelectionWepIsSelected && _menuSelectionWep != wep_none){
					if(beetle_menu_selection_state){
						array_push(beetle_menu_merging_wep_index_list, beetle_menu_selection_wep_index);
					}
					else{
						beetle_menu_merging_wep_index_list = call(scr.array_delete_value, beetle_menu_merging_wep_index_list, beetle_menu_selection_wep_index);
					}
					
					 // Effects:
					var	_menuSelectionWepSwap     = sndSwapPistol,
						_menuSelectionEffectScale = array_length(beetle_menu_merging_wep_index_list) / _menuSelectionWepListSize;
						
					with(call(scr.fx, _menuSelectionTrailX, _menuSelectionTrailY, [gunangle, 1], BulletHit)){
						image_xscale = lerp(1/3, 2/3, _menuSelectionEffectScale);
						image_yscale = image_xscale;
						image_blend  = c_black;
						friction     = 0.1;
					}
					if(beetle_menu_selection_state){
						if(call(scr.weapon_has_temerge, _menuSelectionWep)){
							call(scr.weapon_deactivate_temerge, _menuSelectionWep);
							_menuSelectionWepSwap = weapon_get_swap(_menuSelectionWep);
							call(scr.weapon_activate_temerge, _menuSelectionWep);
						}
						else{
							_menuSelectionWepSwap = weapon_get_swap(_menuSelectionWep);
						}
						sound_play_pitchvol(_menuSelectionWepSwap, 1, 2/3);
					}
					sound_play_pitchvol((beetle_menu_selection_state ? sndPlantPower : sndPlantFire), lerp(1.25, 2, _menuSelectionEffectScale), 2);
					
					 // Store Merged Weapon's Name & Sprite:
					if(array_length(beetle_menu_merging_wep_index_list)){
						var	_menuMergingWep             = undefined,
							_menuSelectionWepSpriteList = [];
							
						with(beetle_menu_merging_wep_index_list){
							var	_menuSelectionWep    = _menuSelectionWepList[self],
								_menuSelectionRawWep = call(scr.wep_raw, _menuSelectionWep);
								
							_menuMergingWep = (
								(_menuMergingWep == undefined)
								? _menuSelectionRawWep
								: call(scr.weapon_add_temerge, _menuMergingWep, _menuSelectionRawWep)
							);
							
							if(call(scr.weapon_has_temerge, _menuSelectionWep)){
								call(scr.weapon_deactivate_temerge, _menuSelectionWep);
								array_push(_menuSelectionWepSpriteList, weapon_get_sprt(_menuSelectionWep));
								call(scr.weapon_activate_temerge, _menuSelectionWep);
							}
							else{
								array_push(_menuSelectionWepSpriteList, weapon_get_sprt(_menuSelectionWep));
							}
						}
						
						beetle_menu_merging_wep_name   = weapon_get_name(_menuMergingWep);
						beetle_menu_merging_wep_sprite = call(scr.merge_weapon_sprite, _menuSelectionWepSpriteList);
					}
				}
			}
			else beetle_menu_selection_state = undefined;
		}
		
		 // Merged Weapon Crafting Zone Opening & Closing Animation:
		if(array_length(beetle_menu_merging_wep_index_list)){
			if(abs(1 - beetle_menu_merging_scale) > 0.01){
				beetle_menu_merging_scale = lerp_ct(beetle_menu_merging_scale, 1, 0.2);
			}
			else{
				beetle_menu_merging_scale = 1;
			}
		}
		else if(beetle_menu_merging_scale != 0){
			if(beetle_menu_merging_scale > 0.01){
				beetle_menu_merging_scale *= power(2/3, current_time_scale);
			}
			else{
				beetle_menu_merging_scale = 0;
			}
		}
		
		 // Close Menu & Confirm Selection:
		if((_specIsPressed && _menuWasOpen) || (_specIsReleased && beetle_menu_scale > 0.75)){
			beetle_menu_is_open = false;
			
			 // Merge Selected Weapons:
			if(array_length(beetle_menu_merging_wep_index_list)){
				var _menuMergingHPCost = 2 * (array_length(beetle_menu_merging_wep_index_list) - 1);
				if(maxhealth > _menuMergingHPCost){
					var	_menuSelectionWepList     = call(scr.array_combine, beetle_menu_wep_selection_wep_list, beetle_menu_bwep_selection_wep_list),
						_menuSelectionWepListSize = array_length(_menuSelectionWepList);
						
					for(var _menuWepSelectionWepIndex = 0; _menuWepSelectionWepIndex < _menuSelectionWepListSize; _menuWepSelectionWepIndex++){
						var	_menuSelectionWep          = _menuSelectionWepList[_menuWepSelectionWepIndex],
							_menuSelectionWepIsPrimary = (_menuWepSelectionWepIndex < array_length(beetle_menu_wep_selection_wep_list));
							
						 // Delete Existing Weapon Merges:
						if(call(scr.weapon_has_temerge, _menuSelectionWep) != false){
							call(scr.weapon_delete_temerge, _menuSelectionWep);
						}
						
						 // Drop Unselected Weapons:
						if(_menuSelectionWep != wep_none && array_find_index(beetle_menu_merging_wep_index_list, _menuWepSelectionWepIndex) < 0){
							with(instance_create(x, y, WepPickup)){
								wep   = _menuSelectionWep;
								curse = (_menuSelectionWepIsPrimary ? other.curse : other.bcurse);
								
								 // Effects:
								image_index = 1;
								call(scr.fx, x, y, 3, Dust);
							}
							_menuSelectionWepList[_menuWepSelectionWepIndex] = wep_none;
						}
						
						 // Merging Cursed Secondary Weapon:
						else if(!_menuSelectionWepIsPrimary){
							curse = max(curse, bcurse);
						}
					}
					
					 // Clear Secondary Weapon:
					bwep   = wep_none;
					bcurse = 0;
					
					 // Merge Selected Weapons:
					wep = wep_none;
					with(beetle_menu_merging_wep_index_list){
						var _menuSelectionWep = _menuSelectionWepList[self];
						other.wep = (
							(other.wep == wep_none)
							? _menuSelectionWep
							: call(scr.weapon_add_temerge, other.wep, _menuSelectionWep)
						);
					}
					
					 // Reset Menu:
					beetle_menu_wep                     = wep;
					beetle_menu_bwep                    = bwep;
					beetle_menu_wep_selection_wep_list  = _menuSelectionWepList;
					beetle_menu_bwep_selection_wep_list = [];
					beetle_menu_merging_wep_index_list  = [];
					
					 // Take Health:
					if(_menuMergingHPCost != 0){
						chickendeaths += _menuMergingHPCost;
						maxhealth     -= _menuMergingHPCost;
						lsthealth      = min(lsthealth, maxhealth);
						projectile_hit_raw(self, max(0, my_health - maxhealth), 2);
						
						 // Effects:
						with(call(scr.pickup_text, "MAX HP", "add", -_menuMergingHPCost)){
							y    -= 58;
							speed = 0;
						}
						with(call(scr.fx, x, y, 3, BloodStreak)){
							sprite_index = spr.SquidBloodStreak;
						}
					}
					
					 // Sound:
					sound_play_pitchvol(
						sndPlantTBKill,
						lerp(0.75, 0.25, _menuMergingHPCost / (maxhealth + chickendeaths)),
						2
					);
					
					 // Weapon Name:
					call(scr.pickup_text, weapon_get_name(wep), "got");
				}
			}
		}
		
		 // Opening Animation:
		if(beetle_menu_scale == 0){
			if(call(scr.weapon_has_temerge, wep)){
				gunshine = 1;
				sound_play_pitchvol(sndWeaponPickup, 1 + orandom(0.1), 2/3);
			}
			sound_play_pitchvol(sndPlantSnareTB, 2 + orandom(0.1), 4/3);
		}
		if(abs(1 - beetle_menu_scale) > 0.01){
			beetle_menu_scale = lerp_ct(beetle_menu_scale, 1, 0.15);
		}
		else{
			beetle_menu_scale = 1;
		}
		
		 // Disable Firing & Laser Sight:
		canfire  = false;
		canscope = false;
	}
	else if(beetle_menu_scale != 0){
		 // Enable Firing:
		canfire = true;
		
		 // Closing Animation:
		if(beetle_menu_scale > 0.05){
			beetle_menu_scale *= power(0.8, current_time_scale);
		}
		
		 // Menu Closed:
		else{
			 // Clear Menu:
			beetle_menu_scale                   = 0;
			beetle_menu_wep                     = wep_none;
			beetle_menu_bwep                    = wep_none;
			beetle_menu_wep_selection_wep_list  = [];
			beetle_menu_bwep_selection_wep_list = [];
			beetle_menu_selection_wep_index     = 0;
			beetle_menu_selection_state         = undefined;
			beetle_menu_merging_scale           = 0;
			beetle_menu_merging_wep_index_list  = [];
			
			 // Enable Laser Sight:
			canscope = true;
			
			 // Effects:
			if(wep != wep_none){
				if(call(scr.weapon_has_temerge, wep)){
					gunshine = 2;
				}
				with(instance_create(x, y, WepSwap)){
					creator = other;
				}
				sound_play_hit(weapon_get_swap(wep), 0.1);
			}
		}
	}
	
	 // Hide Weapons While Menu is Open:
	if(beetle_menu_scale != 0){
		if(beetle_menu_wkick == undefined || wkick < infinity){
			beetle_menu_wkick = wkick;
			wkick = infinity;
		}
		else{
			beetle_menu_wkick -= clamp(beetle_menu_wkick, -current_time_scale, current_time_scale);
		}
		if(beetle_menu_bwkick == undefined || bwkick < infinity){
			beetle_menu_bwkick = bwkick;
			bwkick = infinity;
		}
	}
	else{
		if(beetle_menu_wkick != undefined){
			wkick = beetle_menu_wkick;
			beetle_menu_wkick = undefined;
		}
		if(beetle_menu_bwkick != undefined){
			bwkick = beetle_menu_bwkick;
			beetle_menu_bwkick = undefined;
		}
	}
	
	if(lag) trace_time(mod_current + "_step");
	
#define ntte_draw
	/*
		
	*/
	
	if(instance_exists(Player)){
		var _inst = instances_matching(instances_matching_ne(instances_matching(Player, "race", mod_current), "beetle_menu_scale", 0), "visible", true);
		if(array_length(_inst)){
			with(_inst){
				var	_menuX                        = pround(x, 1 / game_scale_nonsync),
					_menuY                        = pround(y, 1 / game_scale_nonsync),
					_menuScale                    = beetle_menu_scale,
					_menuWepSelectionWepList      = beetle_menu_wep_selection_wep_list,
					_menuWepSelectionWepListSize  = array_length(_menuWepSelectionWepList),
					_menuBWepSelectionWepList     = beetle_menu_bwep_selection_wep_list,
					_menuBWepSelectionWepListSize = array_length(_menuBWepSelectionWepList),
					_menuSelectionWepList         = call(scr.array_combine, _menuWepSelectionWepList, _menuBWepSelectionWepList),
					_menuSelectionWepListSize     = _menuWepSelectionWepListSize + _menuBWepSelectionWepListSize,
					_handLen2                     = 4 * beetle_menu_scale,
					_handDir                      = gunangle,
					_handX1                       = x + lengthdir_x(lerp(5, 10, beetle_menu_scale), _handDir),
					_handY1                       = y + lengthdir_y(lerp(2, 10, power(beetle_menu_scale, 2)), _handDir) + (3 * (1 - beetle_menu_scale)),
					_handX2                       = _handX1 + lengthdir_x(_handLen2, _handDir),
					_handY2                       = _handY1 + lengthdir_y(_handLen2, _handDir) + dsin((wave / 30) * 180),
					_handRadius                   = lerp(1, 2, beetle_menu_scale);
					
				 // Beetle's Hand:
				draw_set_color(c_black);
				draw_circle(_handX1 - 1, _handY1 - 1, _handRadius, false);
				if(beetle_menu_selection_state == undefined){
					draw_triangle(
						(_handX1 - 1) + lengthdir_x(_handRadius, _handDir - 90),
						(_handY1 - 1) + lengthdir_y(_handRadius, _handDir - 90),
						(_handX1 - 1) - lengthdir_x(_handRadius, _handDir - 90),
						(_handY1 - 1) - lengthdir_y(_handRadius, _handDir - 90),
						(_handX2 - 1),
						(_handY2 - 1),
						false
					);
				}
				
				 // Radial Weapon Selection:
				for(var _menuSelectionWepIndex = 0; _menuSelectionWepIndex < _menuSelectionWepListSize; _menuSelectionWepIndex++){
					var	_wep    = _menuSelectionWepList[_menuSelectionWepIndex],
						_wepSpr = -1;
						
					 // Fetch Weapon Sprite:
					if(call(scr.weapon_has_temerge, _wep)){
						call(scr.weapon_deactivate_temerge, _wep);
						_wepSpr = weapon_get_sprt(_wep);
						call(scr.weapon_activate_temerge, _wep);
					}
					else{
						_wepSpr = weapon_get_sprt(_wep);
					}
					
					 // Setup Drawing Values:
					var	_isPrimary    = (_menuSelectionWepIndex < _menuWepSelectionWepListSize),
						_isMelee      = weapon_is_melee(_isPrimary ? wep : bwep),
						_wepImg       = gunshine,
						_wepFlip      = (_isMelee ? (_isPrimary ? wepflip : bwepflip) : right),
						_wepKick      = 0,
						_wepAng       = ((_wepFlip < 0) ? 180 : 0),
						_wepMeleeAng  = 0,
						_wepCol       = ((array_find_index(beetle_menu_merging_wep_index_list, _menuSelectionWepIndex) < 0) ? c_white : c_black),
						_wepAlp       = 1,
						_wepOffsetX   = sprite_get_xoffset(_wepSpr) - floor(lerp(sprite_get_bbox_left(_wepSpr), sprite_get_bbox_right(_wepSpr)  + 1, 0.5)),
						_wepOffsetY   = sprite_get_yoffset(_wepSpr) - floor(lerp(sprite_get_bbox_top(_wepSpr),  sprite_get_bbox_bottom(_wepSpr) + 1, 0.5)),
						_wepOffsetLen = 28,
						_wepOffsetDir = beetle_menu_selection_angle + (360 * (_menuSelectionWepIndex / _menuSelectionWepListSize));
						
					if(_wepFlip < 0){
						_wepOffsetX += sprite_get_width(_wepSpr) - (2 * sprite_get_xoffset(_wepSpr));
					}
					
					 // Draw Separator Line:
					if(_menuSelectionWepListSize > 1){
						var	_lineLen1 = lerp(56, 20, power(_menuScale, 1.5)) + (2 * dcos((wave / 30) * 180)),
							_lineLen2 = _lineLen1 + (16 * power(_menuScale, 2));
							
						if(round(_lineLen2 - _lineLen1) > 0){
							var	_lineDir = _wepOffsetDir + ((360 * (0.5 / _menuSelectionWepListSize)) * _menuScale),
								_lineX1  = _menuX + lengthdir_x(_lineLen1, _lineDir),
								_lineY1  = _menuY + lengthdir_y(_lineLen1, _lineDir),
								_lineX2  = _menuX + lengthdir_x(_lineLen2, _lineDir),
								_lineY2  = _menuY + lengthdir_y(_lineLen2, _lineDir),
								_lineW   = 2 * lerp(3, _menuScale, abs(power(_menuScale, 1.5) - 0.5) / 0.5);
								
							draw_set_color(c_black);
							draw_line_width(_lineX1,     _lineY1 - 1, _lineX2,     _lineY2 - 1, _lineW);
							draw_line_width(_lineX1 - 1, _lineY1,     _lineX2 - 1, _lineY2,     _lineW);
							draw_line_width(_lineX1,     _lineY1,     _lineX2,     _lineY2,     _lineW);
							draw_set_color(c_white);
							draw_line_width(_lineX1 - 1, _lineY1 - 1, _lineX2 - 1, _lineY2 - 1, _lineW);
						}
					}
					
					 // Menu Opening Animation:
					if(_menuScale < 1){
						var	_startKick      = (_isPrimary ? beetle_menu_wkick : 0),
							_startAng       = (_isPrimary ? gunangle          : (90 + (15 * right))),
							_startMeleeAng  = (_isPrimary ? wepangle          : 0),
							_startCol       = (_isPrimary ? image_blend       : c_black),
							_startAlp       = (_isPrimary ? image_alpha       : -0.5),
							_startOffsetX   = (_isPrimary ? 0                 : -(2 * right)),
							_startOffsetY   = (_isPrimary ? swapmove          : -swapmove),
							_startOffsetDir = (_isPrimary ? _wepAng           : (90 + (90 * right))),
							_startOffsetLen = 0;
							
						_wepKick      = lerp       (_startKick,      _wepKick,      _menuScale);
						_wepAng       = angle_lerp (_startAng,       _wepAng,       _menuScale);
						_wepMeleeAng  = angle_lerp (_startMeleeAng,  _wepMeleeAng,  _menuScale);
						_wepCol       = merge_color(_startCol,       _wepCol,       _menuScale);
						_wepAlp       = lerp       (_startAlp,       _wepAlp,       _menuScale);
						_wepOffsetX   = lerp       (_startOffsetX,   _wepOffsetX,   _menuScale);
						_wepOffsetY   = lerp       (_startOffsetY,   _wepOffsetY,   _menuScale);
						_wepOffsetDir = angle_lerp (_startOffsetDir, _wepOffsetDir, _menuScale);
						_wepOffsetLen = lerp       (_startOffsetLen, _wepOffsetLen, _menuScale);
					}
					
					var	_wepX = _menuX + lengthdir_x(_wepOffsetLen, _wepOffsetDir),
						_wepY = _menuY + lengthdir_y(_wepOffsetLen, _wepOffsetDir);
						
					 // Draw Selected Weapon Outline:
					if(_menuSelectionWepIndex == beetle_menu_selection_wep_index){
						draw_set_fog(true, c_white, 0, 0);
						
						for(var _dir = 0; _dir < 360; _dir += 90){
							call(scr.draw_weapon,
								_wepSpr,
								_wepImg,
								_wepX + _wepOffsetX + dcos(_dir),
								_wepY + _wepOffsetY - dsin(_dir),
								_wepAng,
								_wepMeleeAng,
								_wepKick,
								_wepFlip,
								_wepCol,
								_wepAlp * max(0, lerp(-1, 1, _menuScale))
							);
						}
						
						draw_set_fog(false, 0, 0, 0);
					}
					
					 // Draw Weapon Sprite:
					call(scr.draw_weapon,
						_wepSpr,
						_wepImg,
						_wepX + _wepOffsetX,
						_wepY + _wepOffsetY,
						_wepAng,
						_wepMeleeAng,
						_wepKick,
						_wepFlip,
						_wepCol,
						_wepAlp
					);
					
					//  // Draw Selected Weapon Button Prompt:
					// if(_menuSelectionWepIndex == beetle_menu_selection_wep_index && _menuScale > 0.75){
					// 	draw_set_font(fntSmall);
					// 	draw_set_halign(fa_center);
					// 	draw_set_valign(fa_middle);
					// 	for(var _buttonOffsetY = 0; _buttonOffsetY <= (button_check(index, "fire") ? 0 : 1); _buttonOffsetY++){
					// 		draw_text_nt(
					// 			_wepX + lengthdir_x(-10, _wepOffsetDir),
					// 			_wepY + lengthdir_y(-10, _wepOffsetDir) - _buttonOffsetY,
					// 			"@(sprKeySmall:fire)"
					// 		);
					// 	}
					// }
				}
				
				 // Weapon Merging:
				var	_menuMergingX1      = _menuX - (lerp(24, 32, _menuScale) * beetle_menu_merging_scale),
					_menuMergingX2      = _menuX + (_menuX - _menuMergingX1),
					_menuMergingY1      = _menuY - (52 + (4 * _menuScale)),
					_menuMergingY2      = _menuMergingY1 + (16 * _menuScale),
					_menuMergingWepSize = array_length(beetle_menu_merging_wep_index_list);
					
				draw_set_color(c_black);
				draw_set_alpha(2/3);
				draw_roundrect(_menuMergingX1 - 1, _menuMergingY1 - 1, _menuMergingX2 - 1, _menuMergingY2 - 1, false);
				draw_set_alpha(1);
				
				if(_menuMergingWepSize > 0){
					var _menuMergingHPCost = 2 * (_menuMergingWepSize - 1);
					draw_set_halign(fa_center);
					draw_set_valign(fa_bottom);
					
					 // Draw Merging Weapon Sprite:
					draw_sprite(
						beetle_menu_merging_wep_sprite,
						0,
						lerp(_menuMergingX1, _menuMergingX2, 0.5) + sprite_get_xoffset(beetle_menu_merging_wep_sprite) - floor(lerp(sprite_get_bbox_left(beetle_menu_merging_wep_sprite), sprite_get_bbox_right(beetle_menu_merging_wep_sprite)  + 1, 0.5)),
						lerp(_menuMergingY1, _menuMergingY2, 0.5) + sprite_get_yoffset(beetle_menu_merging_wep_sprite) - floor(lerp(sprite_get_bbox_top(beetle_menu_merging_wep_sprite),  sprite_get_bbox_bottom(beetle_menu_merging_wep_sprite) + 1, 0.5))
					);
					
					 // HP Cost Text:
					if(_menuMergingHPCost > 0){
						var _menuMergingHPCostText = "-";
						
						 // Amount Text:
						if(maxhealth > _menuMergingHPCost){
						}
						else{
							_menuMergingHPCostText += "@d";
						}
						_menuMergingHPCostText += `${_menuMergingHPCost} `;
						
						 // Name Text:
						if(maxhealth > _menuMergingHPCost){
							_menuMergingHPCostText += "@q@r";
						}
						_menuMergingHPCostText += "MAX HP";
						
						 // Draw Text:
						draw_set_font(fntM);
						draw_text_nt(
							lerp(_menuMergingX1, _menuMergingX2, 0.5),
							_menuMergingY1 - 2,
							_menuMergingHPCostText
						);
					}
					
					 // Draw Merging Weapon Name:
					draw_set_font(fntSmall);
					draw_text_nt(
						lerp(_menuMergingX1, _menuMergingX2, 0.5),
						_menuMergingY1 - (2 + (10 * (_menuMergingHPCost > 0))),
						beetle_menu_merging_wep_name
					);
				}
			}
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