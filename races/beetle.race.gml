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
	beetle_last_usespec               = 0;
	beetle_menu_is_open               = false;
	beetle_menu_scale                 = 0;
	beetle_menu_has_changed           = false;
	beetle_menu_wkick                 = undefined;
	beetle_menu_bwkick                = undefined;
	beetle_menu_wep                   = wep_none;
	beetle_menu_bwep                  = wep_none;
	beetle_menu_wep_select_wep_list   = [];
	beetle_menu_bwep_select_wep_list  = [];
	beetle_menu_select_wep_index      = 0;
	beetle_menu_select_wep_index_list = [];
	beetle_menu_select_wep_angle      = 0;
	beetle_menu_select_wep_state      = true;
	
	 // Re-Get Ultras When Revived:
	/*for(var i = 0; i < ultra_count(mod_current); i++){
		if(ultra_get(mod_current, i)){
			race_ultra_take(i, true);
		}
	}*/
	
#macro beetle_menu_cycle_button  "swap"
#macro beetle_menu_select_button "pick"

#define step
	if(lag) trace_time();
	
	 // ACTIVE : Merge Weapons
	// if(wep != wep_none && bwep != wep_none){
	// 	if(canspec && player_active){
	// 		if(button_pressed(index, "horn")/* || usespec > 0*/){
				
				
	// 			var _mergeWepDepth = 1 + call(scr.weapon_has_temerge, wep) + call(scr.weapon_has_temerge, bwep);
	// 			if(maxhealth > _mergeWepDepth){
	// 				 // Merge Weapons:
	// 				wep  = call(scr.weapon_add_temerge, wep, bwep);
	// 				bwep = wep_none;
					
	// 				 // Take Health:
	// 				chickendeaths += _mergeWepDepth;
	// 				maxhealth     -= _mergeWepDepth;
	// 				lsthealth      = min(lsthealth, maxhealth);
	// 				projectile_hit_raw(self, max(0, my_health - 1), 2);
					
	// 				 // Effects:
	// 				call(scr.pickup_text, weapon_get_name(wep), "got");
	// 				call(scr.pickup_text, "MAX HP", "add", -_mergeWepDepth);
	// 			}
				
	// 			 // Not Enough Health:
	// 			else{
					
	// 			}
	// 		}
	// 	}
	// }
	
	 // :
	var	_specIsPressed     = button_pressed(index, "spec"),
		_specIsReleased    = button_released(index, "spec"),
		_beetleMenuWasOpen = beetle_menu_is_open;
		
	if((usespec > 0) != (beetle_last_usespec > 0)){
		if(usespec > 0){
			_specIsPressed = true;
		}
		else{
			_specIsReleased = true;
		}
	}
	beetle_last_usespec = usespec;
	
	if(_specIsPressed && !beetle_menu_is_open && canspec && player_active){
		beetle_menu_is_open = !beetle_menu_is_open;
	}
	
	if(beetle_menu_is_open){
		var _beetleMenuSelectWepListSize = 0;
		
		 // Compile Merged Weapon Parts:
		for(var _wepIndex = 0; _wepIndex <= 1; _wepIndex++){
			var	_wepVarName                 = ((_wepIndex == 0) ? "wep" : "bwep"),
				_wep                        = variable_instance_get(self, _wepVarName),
				_beetleMenuWep              = variable_instance_get(self, `beetle_menu_${_wepVarName}`),
				_beetleMenuWepSelectWepList = variable_instance_get(self, `beetle_menu_${_wepVarName}_select_wep_list`);
				
			if(_beetleMenuWep != _wep){
				_beetleMenuWep              = _wep;
				_beetleMenuWepSelectWepList = [];
				variable_instance_set(self, `beetle_menu_${_wepVarName}`,                 _beetleMenuWep);
				variable_instance_set(self, `beetle_menu_${_wepVarName}_select_wep_list`, _beetleMenuWepSelectWepList);
				
				 // Deselect Previous Weapon Parts:
				if(beetle_menu_select_wep_index > _beetleMenuSelectWepListSize){
					beetle_menu_select_wep_index = _beetleMenuSelectWepListSize;
				}
				with(beetle_menu_select_wep_index_list){
					if(self >= _beetleMenuSelectWepListSize){
						other.beetle_menu_select_wep_index_list = call(scr.array_delete_value, other.beetle_menu_select_wep_index_list, self);
					}
				}
				
				 // Add Weapon Parts to List:
				while(true){
					if(call(scr.wep_raw, _beetleMenuWep) != wep_none){
						array_push(_beetleMenuWepSelectWepList, _beetleMenuWep);
					}
					if(call(scr.weapon_has_temerge, _beetleMenuWep)){
						_beetleMenuWep = call(scr.weapon_get_temerge_weapon, _beetleMenuWep);
					}
					else break;
				}
			}
			
			_beetleMenuSelectWepListSize += array_length(_beetleMenuWepSelectWepList);
		}
		
		 // :
		if(_beetleMenuSelectWepListSize > 0){
			 // :
			if(beetle_menu_scale == 0){
				 // Default Selection:
				//beetle_menu_select_wep_index = array_length(beetle_menu_wep_select_wep_list) % _beetleMenuSelectWepListSize;
				//beetle_menu_select_wep_angle = 90 + (360 * (beetle_menu_select_wep_index / _beetleMenuSelectWepListSize));
				// for(var _beetleMenuWepSelectWepIndex = 0; _beetleMenuWepSelectWepIndex < array_length(beetle_menu_wep_select_wep_list); _beetleMenuWepSelectWepIndex++){
				// 	array_push(beetle_menu_select_wep_index_list, _beetleMenuWepSelectWepIndex);
				// }
				beetle_menu_select_wep_angle = gunangle;
				
				 // Effects:
				if(call(scr.weapon_has_temerge, wep)){
					gunshine = 1;
				}
				sound_play_hit(sndClickBack, 0.1);
			}
			
			 // Cycle to Next Weapon:
			// if(button_pressed(index, beetle_menu_cycle_button)){
			// 	beetle_menu_select_wep_index = (beetle_menu_select_wep_index + 1) % _beetleMenuSelectWepListSize;
			// }
			// beetle_menu_select_wep_angle = angle_lerp_ct(
			// 	beetle_menu_select_wep_angle,
			// 	90 + (360 * (beetle_menu_select_wep_index / _beetleMenuSelectWepListSize)),
			// 	0.25
			// );
			
			 // :
			beetle_menu_select_wep_index = round(_beetleMenuSelectWepListSize * (1 + ((gunangle - beetle_menu_select_wep_angle) / 360))) % _beetleMenuSelectWepListSize;
			
			 // Select Current Weapon:
			if(button_check(index, "fire")){
				var _beetleMenuSelectWepIsSelected = (array_find_index(beetle_menu_select_wep_index_list, beetle_menu_select_wep_index) >= 0);
				if(button_pressed(index, "fire")){
					beetle_menu_select_wep_state = !_beetleMenuSelectWepIsSelected;
				}
				if(beetle_menu_select_wep_state != _beetleMenuSelectWepIsSelected){
					if(beetle_menu_select_wep_state){
						array_push(beetle_menu_select_wep_index_list, beetle_menu_select_wep_index);
					}
					else{
						beetle_menu_select_wep_index_list = call(scr.array_delete_value, beetle_menu_select_wep_index_list, beetle_menu_select_wep_index);
					}
				}
				beetle_menu_has_changed = true;
			}
		}
		
		 // :
		if(
			(_specIsPressed && _beetleMenuWasOpen)
			|| (_specIsReleased && (beetle_menu_scale > 0.75 || beetle_menu_has_changed))
		){	
			 // :
			var _hpCost = 2 * (array_length(beetle_menu_select_wep_index_list) - 1);
			if(
				array_length(beetle_menu_select_wep_index_list) > 0
				&& maxhealth > _hpCost
			){
				var	_beetleMenuSelectWepList     = call(scr.array_combine, beetle_menu_wep_select_wep_list, beetle_menu_bwep_select_wep_list),
					_beetleMenuSelectWepListSize = array_length(_beetleMenuSelectWepList);
					
				for(var _beetleMenuWepSelectWepIndex = 0; _beetleMenuWepSelectWepIndex < _beetleMenuSelectWepListSize; _beetleMenuWepSelectWepIndex++){
					var	_beetleMenuSelectWep          = _beetleMenuSelectWepList[_beetleMenuWepSelectWepIndex],
						_beetleMenuSelectWepIsPrimary = (_beetleMenuWepSelectWepIndex < array_length(beetle_menu_wep_select_wep_list));
						
					 // Delete Existing Weapon Merges:
					if(call(scr.weapon_has_temerge, _beetleMenuSelectWep) != false){
						call(scr.weapon_delete_temerge, _beetleMenuSelectWep);
					}
					
					 // Drop Unselected Weapons:
					if(array_find_index(beetle_menu_select_wep_index_list, _beetleMenuWepSelectWepIndex) < 0){
						with(instance_create(x, y, WepPickup)){
							wep   = _beetleMenuSelectWep;
							curse = (_beetleMenuSelectWepIsPrimary ? other.curse : other.bcurse);
							
							 // Shine:
							image_index = 1;
						}
						_beetleMenuSelectWepList[_beetleMenuWepSelectWepIndex] = wep_none;
					}
					
					 // Merging Cursed Secondary Weapon:
					else if(!_beetleMenuSelectWepIsPrimary){
						curse = max(curse, bcurse);
					}
				}
				
				 // Clear Secondary Weapon:
				bwep   = wep_none;
				bcurse = 0;
				
				 // Merge Selected Weapons:
				wep = wep_none;
				with(beetle_menu_select_wep_index_list){
					var _beetleMenuSelectWep = _beetleMenuSelectWepList[self];
					other.wep = (
						(other.wep == wep_none)
						? _beetleMenuSelectWep
						: call(scr.weapon_add_temerge, other.wep, _beetleMenuSelectWep)
					);
				}
				
				 // Menu Visuals:
				beetle_menu_wep                  = wep;
				beetle_menu_bwep                 = bwep;
				beetle_menu_wep_select_wep_list  = _beetleMenuSelectWepList;
				beetle_menu_bwep_select_wep_list = [];
				
				if(_hpCost != 0){
					 // Take Health:
					chickendeaths += _hpCost;
					maxhealth     -= _hpCost;
					lsthealth      = min(lsthealth, maxhealth);
					projectile_hit_raw(self, max(0, my_health - maxhealth), 2);
					
					 // Effects:
					// call(scr.pickup_text, weapon_get_name(wep), "got");
					// call(scr.pickup_text, "MAX HP", "add", -_hpCost);
					with(call(scr.fx, x, y, 3, BloodStreak)){
						sprite_index = spr.SquidBloodStreak;
					}
				}
			}
			
			 // :
			beetle_menu_is_open     = false;
			beetle_menu_has_changed = false;
		}
		
		 // :
		// else if(button_pressed(index, "fire")){
		// 	beetle_menu_is_open = false;
		// }
		
		 // :
		if(abs(1 - beetle_menu_scale) > 0.01){
			beetle_menu_scale = lerp_ct(beetle_menu_scale, 1, 0.15);
		}
		else{
			beetle_menu_scale = 1;
		}
		
		 // :
		canfire  = false;
		canscope = false;
	}
	else if(beetle_menu_scale != 0){
		canfire = true;
		
		if(beetle_menu_scale > 0.05){
			beetle_menu_scale *= power(0.8, current_time_scale);
		}
		else{
			beetle_menu_scale                 = 0;
			beetle_menu_has_changed           = false;
			beetle_menu_wep                   = wep_none;
			beetle_menu_bwep                  = wep_none;
			beetle_menu_wep_select_wep_list   = [];
			beetle_menu_bwep_select_wep_list  = [];
			beetle_menu_select_wep_index_list = [];
			beetle_menu_select_wep_index      = 0;
			//beetle_menu_select_wep_angle      = 90;
			
			 // :
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
	
	
// #define ntte_step
// 	/*
		
// 	*/
	
// 	if(instance_exists(Player)){
// 		var _inst = instances_matching_ne(instances_matching_ne(instances_matching(Player, "race", mod_current), "beetle_menu_scale", 0), "nearwep", noone);
// 		if(array_length(_inst)){
// 			with(_inst){
// 				nearwep = noone;
// 			}
// 		}
// 	}
	
#define ntte_draw
	/*
		
	*/
	
	if(instance_exists(Player)){
		var _inst = instances_matching(instances_matching_ne(instances_matching(Player, "race", mod_current), "beetle_menu_scale", 0), "visible", true);
		if(array_length(_inst)){
			with(_inst){
				nearwep = noone;
				
				var	_x                               = pround(x, 1 / game_scale_nonsync),
					_y                               = pround(y, 1 / game_scale_nonsync),
					_beetleMenuWepSelectWepList      = beetle_menu_wep_select_wep_list,
					_beetleMenuWepSelectWepListSize  = array_length(_beetleMenuWepSelectWepList),
					_beetleMenuBWepSelectWepList     = beetle_menu_bwep_select_wep_list,
					_beetleMenuBWepSelectWepListSize = array_length(_beetleMenuBWepSelectWepList),
					_beetleMenuSelectWepList         = call(scr.array_combine, _beetleMenuWepSelectWepList, _beetleMenuBWepSelectWepList),
					_beetleMenuSelectWepListSize     = _beetleMenuWepSelectWepListSize + _beetleMenuBWepSelectWepListSize;
					
				if(beetle_menu_is_open || 1){
					var	_arrowLen2    = 4 * beetle_menu_scale,
						_arrowDir     = gunangle,
						_arrowX1      = _x + lengthdir_x(lerp(5, 10, beetle_menu_scale), _arrowDir),
						_arrowY1      = _y + lengthdir_y(lerp(2, 10, power(beetle_menu_scale, 2)), _arrowDir) + (3 * (1 - beetle_menu_scale)),
						_arrowX2      = _arrowX1 + lengthdir_x(_arrowLen2, _arrowDir),
						_arrowY2      = _arrowY1 + lengthdir_y(_arrowLen2, _arrowDir) + dsin((wave / 30) * 180),
						_circleRadius = lerp(1, 2, beetle_menu_scale);
						
					//draw_sprite_ext(sprTooltip, 0, _x + lengthdir_x(_l,     _d),     _y + lengthdir_y(_l,     _d),     1, 1, _d + 90, c_white, 1);
					draw_set_color(c_black);
					draw_circle(_arrowX1 - 1, _arrowY1 - 1, _circleRadius, false);
					draw_triangle(
						(_arrowX1 - 1) + lengthdir_x(_circleRadius, _arrowDir - 90),
						(_arrowY1 - 1) + lengthdir_y(_circleRadius, _arrowDir - 90),
						(_arrowX1 - 1) - lengthdir_x(_circleRadius, _arrowDir - 90),
						(_arrowY1 - 1) - lengthdir_y(_circleRadius, _arrowDir - 90),
						(_arrowX2 - 1),
						(_arrowY2 - 1),
						false
					);
				}
				
				for(var _beetleMenuSelectWepIndex = 0; _beetleMenuSelectWepIndex < _beetleMenuSelectWepListSize; _beetleMenuSelectWepIndex++){
					var	_wep = _beetleMenuSelectWepList[_beetleMenuSelectWepIndex],
						_spr = -1;
						
					if(call(scr.weapon_has_temerge, _wep)){
						call(scr.weapon_deactivate_temerge, _wep);
						_spr = weapon_get_sprt(_wep);
						call(scr.weapon_activate_temerge, _wep);
					}
					else{
						_spr = weapon_get_sprt(_wep);
					}
					
					var	_isPrimary = (_beetleMenuSelectWepIndex < _beetleMenuWepSelectWepListSize),
						_isMelee   = weapon_is_melee(_isPrimary ? wep : bwep),
						_canAdd    = (array_find_index(beetle_menu_select_wep_index_list, _beetleMenuSelectWepIndex) < 0),
						_img       = gunshine,
						_flip      = (_isMelee ? (_isPrimary ? wepflip : bwepflip) : right),
						_kick      = 0,
						_ang       = ((_flip < 0) ? 180 : 0),
						_meleeAng  = 0,
						_col       = (_canAdd ? c_white : c_black),
						_alp       = 1,
						_offsetX   = sprite_get_xoffset(_spr) - floor(lerp(sprite_get_bbox_left(_spr), sprite_get_bbox_right(_spr)  + 1, 0.5)),
						_offsetY   = sprite_get_yoffset(_spr) - floor(lerp(sprite_get_bbox_top(_spr),  sprite_get_bbox_bottom(_spr) + 1, 0.5)),
						_offsetLen = 28,
						_offsetDir = beetle_menu_select_wep_angle + (360 * (_beetleMenuSelectWepIndex / _beetleMenuSelectWepListSize));
						
					 // :
					if(_flip < 0){
						_offsetX += sprite_get_width(_spr) - (2 * sprite_get_xoffset(_spr));
					}
					
					 // Separator Line:
					if(_beetleMenuSelectWepListSize > 1){
						var	_lineLen1 = lerp(56, 20, power(beetle_menu_scale, 1.5)) + (2 * dcos((wave / 30) * 180)),
							_lineLen2 = _lineLen1 + (16 * power(beetle_menu_scale, 2));
							
						if(round(_lineLen2 - _lineLen1) > 0){
							var	_lineDir = _offsetDir + ((360 * (0.5 / _beetleMenuSelectWepListSize)) * beetle_menu_scale),
								_lineX1  = _x + lengthdir_x(_lineLen1, _lineDir),
								_lineY1  = _y + lengthdir_y(_lineLen1, _lineDir),
								_lineX2  = _x + lengthdir_x(_lineLen2, _lineDir),
								_lineY2  = _y + lengthdir_y(_lineLen2, _lineDir),
								_lineW   = 2 * lerp(3, beetle_menu_scale, abs(power(beetle_menu_scale, 1.5) - 0.5) / 0.5);
								
							draw_set_color(c_black);
							draw_line_width(_lineX1,     _lineY1 - 1, _lineX2,     _lineY2 - 1, _lineW);
							draw_line_width(_lineX1 - 1, _lineY1,     _lineX2 - 1, _lineY2,     _lineW);
							draw_line_width(_lineX1,     _lineY1,     _lineX2,     _lineY2,     _lineW);
							draw_set_color(c_white);
							draw_line_width(_lineX1 - 1, _lineY1 - 1, _lineX2 - 1, _lineY2 - 1, _lineW);
						}
					}
					
					 // :
					if(beetle_menu_scale < 1){
						var	_menuInvScale   = 1 - beetle_menu_scale,
							_startKick      = (_isPrimary ? beetle_menu_wkick : 0),
							_startAng       = (_isPrimary ? gunangle          : (90 + (15 * right))),
							_startMeleeAng  = (_isPrimary ? wepangle          : 0),
							_startCol       = (_isPrimary ? image_blend       : c_black),
							_startAlp       = (_isPrimary ? image_alpha       : -0.5),
							_startOffsetX   = (_isPrimary ? 0                 : -(2 * right)),
							_startOffsetY   = (_isPrimary ? swapmove          : -swapmove),
							_startOffsetDir = (_isPrimary ? _ang              : (90 + (90 * right))),
							_startOffsetLen = 0;
							
						_kick      = lerp       (_kick,      _startKick,      _menuInvScale);
						_ang       = angle_lerp (_ang,       _startAng,       _menuInvScale);
						_meleeAng  = angle_lerp (_meleeAng,  _startMeleeAng,  _menuInvScale);
						_col       = merge_color(_col,       _startCol,       _menuInvScale);
						_alp       = lerp       (_alp,       _startAlp,       _menuInvScale);
						_offsetX   = lerp       (_offsetX,   _startOffsetX,   _menuInvScale);
						_offsetY   = lerp       (_offsetY,   _startOffsetY,   _menuInvScale);
						_offsetDir = angle_lerp (_offsetDir, _startOffsetDir, _menuInvScale);
						_offsetLen = lerp       (_offsetLen, _startOffsetLen, _menuInvScale);
					}
					
					 // :
					if(_beetleMenuSelectWepIndex == beetle_menu_select_wep_index){
						draw_set_fog(true, c_white, 0, 0);
						for(var _dir = 0; _dir < 360; _dir += 90){
							call(scr.draw_weapon, 
								_spr,
								_img,
								_x + _offsetX + lengthdir_x(_offsetLen, _offsetDir) + dcos(_dir),
								_y + _offsetY + lengthdir_y(_offsetLen, _offsetDir) - dsin(_dir),
								_ang,
								_meleeAng,
								_kick,
								_flip,
								_col,
								_alp * max(0, lerp(-1, 1, beetle_menu_scale))
							);
						}
						draw_set_fog(false, 0, 0, 0);
					}
					call(scr.draw_weapon, 
						_spr,
						_img,
						_x + _offsetX + lengthdir_x(_offsetLen, _offsetDir),
						_y + _offsetY + lengthdir_y(_offsetLen, _offsetDir),
						_ang,
						_meleeAng,
						_kick,
						_flip,
						_col,
						_alp
					);
					
					 // :
					if(beetle_menu_scale > 0.75 && _beetleMenuSelectWepIndex == beetle_menu_select_wep_index){
						draw_set_font(fntSmall);
						draw_set_halign(fa_center);
						draw_set_valign(fa_middle);
						draw_text_nt(
							_x + lengthdir_x(_offsetLen - 10, _offsetDir),
							_y + lengthdir_y(_offsetLen - 10, _offsetDir),
							"@(sprKeySmall:fire)"
						);
						if(!button_check(index, "fire")){
							draw_text_nt(
								_x + lengthdir_x(_offsetLen - 10, _offsetDir),
								_y + lengthdir_y(_offsetLen - 10, _offsetDir) - 1,
								"@(sprKeySmall:fire)"
							);
						}
					}
				}
				
				var _num = 2 * (array_length(beetle_menu_select_wep_index_list) - 1);
				
				var	_x1 = _x - lerp(24, 32, beetle_menu_scale),
					_x2 = _x + (_x - _x1),
					_y1 = _y - (52 + (4 * beetle_menu_scale)),
					_y2 = _y1 + (16 * beetle_menu_scale);
					
				 // :
				if(_num >= 0){
					draw_set_color(c_black);
					draw_set_alpha(2/3);
					draw_roundrect(_x1 - 1, _y1 - 1, _x2 - 1, _y2 - 1, false);
					draw_set_alpha(1);
				}
				
				 // :
				// draw_set_font(fntSmall);
				// draw_set_valign(fa_bottom);
				// draw_set_halign(fa_right);
				// draw_text_nt(_x1 + 10, _y2 + 10, `< @2(sprKeySmall:${beetle_menu_cycle_button})`);
				// if(!button_check(index, beetle_menu_cycle_button) && beetle_menu_scale > 0.5){
				// 	draw_text_nt(_x1 + 10, _y2 + 9, `@2(sprKeySmall:${beetle_menu_cycle_button})`);
				// }
				// draw_set_halign(fa_left);
				// draw_text_nt(_x2 - 9, _y2 + 10, `@2(sprKeySmall:${beetle_menu_select_button}) ${
				// 	(array_find_index(beetle_menu_select_wep_index_list, beetle_menu_select_wep_index) < 0)
				// 	? "ADD"
				// 	: "REMOVE"
				// }`);
				// if(!button_check(index, beetle_menu_select_button) && beetle_menu_scale > 0.5){
				// 	draw_text_nt(_x2 - 9, _y2 + 9, `@2(sprKeySmall:${beetle_menu_select_button})`);
				// }
				
				 // :
				draw_set_font(fntM);
				draw_set_halign(fa_center);
				draw_set_valign(fa_bottom);
				if(_num > 0){
					if(maxhealth > _num){
						draw_text_nt(lerp(_x1, _x2, 0.5), _y1 - 2, `${_num} @rMAX HP`);
					}
					else{
						draw_text_nt(lerp(_x1, _x2, 0.5), _y1 - 2, `@d${_num} MAX HP`);
					}
				}
				// draw_text_nt(_x2 + 3, _y2 - (11 * beetle_menu_scale), `@2(sprKeySmall:spec) ${(_num > 0) ? "MERGE" : "CLOSE"}`);
				// if(!button_check(index, "spec") && beetle_menu_scale > 0.5){
				// 	draw_text_nt(_x2 + 3, (_y2 - (11 * beetle_menu_scale)) - 1, "@2(sprKeySmall:spec)");
				// }
				
				 // :
				var	_list = [],
					_name = "";
					
				with(beetle_menu_select_wep_index_list){
					var _beetleMenuSelectWep = _beetleMenuSelectWepList[self];
					if(call(scr.weapon_has_temerge, _beetleMenuSelectWep)){
						call(scr.weapon_deactivate_temerge, _beetleMenuSelectWep);
						array_push(_list, weapon_get_sprt(_beetleMenuSelectWep));
						call(scr.weapon_activate_temerge, _beetleMenuSelectWep);
					}
					else{
						array_push(_list, weapon_get_sprt(_beetleMenuSelectWep));
					}
				}
				
				if(array_length(_list)){
					// if(array_length(_list) < 2){
					// 	array_push(_list, mskNone);
					// }
					var _spr = call(scr.merge_weapon_sprite, _list);
					draw_sprite(
						_spr,
						0,
						lerp(_x1, _x2, 0.5) + sprite_get_xoffset(_spr) - floor(lerp(sprite_get_bbox_left(_spr), sprite_get_bbox_right(_spr)  + 1, 0.5)),
						lerp(_y1, _y2, 0.5) + sprite_get_yoffset(_spr) - floor(lerp(sprite_get_bbox_top(_spr),  sprite_get_bbox_bottom(_spr) + 1, 0.5))
					);
					
					var _wep = undefined;
					with(beetle_menu_select_wep_index_list){
						var _rawWep = call(scr.wep_raw, _beetleMenuSelectWepList[self]);
						_wep = (
							(_wep == undefined)
							? _rawWep
							: call(scr.weapon_add_temerge, _wep, _rawWep)
						);
					}
					// if(array_length(beetle_menu_select_wep_index_list) < 2){
					// 	_wep = call(scr.weapon_add_temerge, _wep, wep_none);
					// }
					
					_name = weapon_get_name(_wep);
				}
				
				draw_set_font(fntSmall);
				draw_set_halign(fa_center);
				draw_set_valign(fa_bottom);
				draw_text_nt(lerp(_x1, _x2, 0.5), _y1 - (2 + (10 * (_num > 0))), _name);
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