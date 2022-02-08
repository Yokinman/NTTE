#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Setup Objects:
	call(scr.obj_add, script_ref_create(HyperSlashTrail_create));
	
	 // Store Script References:
	with([temerge_create_weapon, temerge_set_weapon_event, temerge_projectile_add_event, temerge_projectile_add_effect, temerge_projectile_add_scale, temerge_projectile_add_bloom, temerge_projectile_scale_damage, temerge_projectile_add_force]){
		lq_set(scr, script_get_name(self), script_ref_create(self));
	}
	
	 // Object Event Variable Names:
	global.obj_event_varname_list_map = mod_variable_get("mod", "teassets", "obj_event_varname_list_map");
	
	 // Volume-Muffled Sounds:
	global.sound_muffle_map = ds_map_create();
	
	 // 'draw_text_nt' Color Tags:
	global.nt_tag_color_map = ds_map_create();
	global.nt_tag_color_map[? "w"] = c_white;
	global.nt_tag_color_map[? "s"] = make_color_rgb(125, 131, 141);
	global.nt_tag_color_map[? "d"] = make_color_rgb( 59,  62,  67);
	global.nt_tag_color_map[? "r"] = make_color_rgb(252,  56,   0);
	global.nt_tag_color_map[? "y"] = make_color_rgb(250, 171,   0);
	global.nt_tag_color_map[? "g"] = make_color_rgb( 68, 198,  22);
	global.nt_tag_color_map[? "b"] = make_color_rgb( 22,  97, 223);
	global.nt_tag_color_map[? "p"] = make_color_rgb( 86,  34, 110);
	with(ds_map_keys(global.nt_tag_color_map)){
		global.nt_tag_color_map[? string_upper(self)] = global.nt_tag_color_map[? self];
	}
	
	 // Merged Weapon Event Scripts:
	global.weapon_event_script_map = ds_map_create();
	with([
		"weapon_name",
		"weapon_text",
		"weapon_swap",
		"weapon_sprt",
		"weapon_sprt_hud",
		"weapon_loadout",
		"weapon_area",
		"weapon_gold",
		"weapon_type",
		"weapon_cost",
		"weapon_rads",
		"weapon_load",
		"weapon_auto",
		"weapon_melee",
		"weapon_laser_sight",
		"weapon_red",
		"weapon_reloaded",
		"weapon_step",
		"player_fire",
		"weapon_fire",
		"projectile_setup"
	]){
		temerge_set_weapon_event(self, script_ref_create(script_get_index("temerge_" + self)));
	}
	
	 // Projectiles w/ Projectile Collision Events:
	global.projectile_collision_projectile_list = [
		Slash,
		EnemySlash,
		GuitarSlash,
		BloodSlash,
		EnergySlash,
		EnergyHammerSlash,
		LightningSlash,
		CustomSlash,
		Shank,
		EnergyShank,
		HorrorBullet,
		GuardianDeflect
	];
	
	 // Merged Effect Events:
	global.temerge_effect_event_script_list_table = ds_map_create();
	temerge_effect_add_event("hit_event",  "post_step", script_ref_create(temerge_collision_event_post_step, "hit"));
	temerge_effect_add_event("wall_event", "post_step", script_ref_create(temerge_collision_event_post_step, "wall"));
	with([
		"destroy_event",
		"fixed_scale",
		"fixed_lightning_scale",
		"fixed_plasma_speed_factor",
		"fixed_seeker_speed_factor",
		"fixed_rocket_speed_factor",
		"trail",
		"flame",
		"slug",
		"hyper",
		"toxic",
		"seek",
		"grenade",
		"sticky",
		"flare",
		"pull"
	]){
		with(["setup", "step", "post_step", "begin_step", "end_step", "draw"]){
			var _scriptIndex = script_get_index(`temerge_${other}_${self}`);
			if(_scriptIndex >= 0){
				temerge_effect_add_event(other, self, script_ref_create(_scriptIndex));
			}
		}
	}
	
	 // Merged Projectile Default Events:
	global.temerge_projectile_object_event_table = ds_map_create();
	for(var _objectIndex = 0; object_exists(_objectIndex); _objectIndex++){
		if(object_is_ancestor(_objectIndex, projectile)){
			var	_objectEventMap = {},
				_objectHasEvent = false;
				
			with(["fire", "setup", "hit", "wall", "destroy"]){
				var _eventName = self;
				lq_set(_objectEventMap, _eventName, undefined);
				for(var _eventObjectIndex = _objectIndex; object_is_ancestor(_eventObjectIndex, projectile); _eventObjectIndex = object_get_parent(_eventObjectIndex)){
					var _eventScriptIndex = script_get_index(`temerge_${object_get_name(_eventObjectIndex)}_${_eventName}`);
					if(_eventScriptIndex >= 0){
						lq_set(_objectEventMap, _eventName, script_ref_create(_eventScriptIndex));
						_objectHasEvent = true;
						break;
					}
				}
			}
			
			if(_objectHasEvent){
				global.temerge_projectile_object_event_table[? _objectIndex] = _objectEventMap;
			}
		}
	}
	
	 // Hyper Slash Trail Sprites:
	global.hyper_slash_trail_sprite_map = ds_map_create();
	global.hyper_slash_trail_mask_map   = ds_map_create();
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
	 // Unmuffle Sounds:
	with(ds_map_keys(global.sound_muffle_map)){
		audio_sound_gain(self, global.sound_muffle_map[? self].sound_gain, 0);
	}
	ds_map_destroy(global.sound_muffle_map);
	
#macro _wepXhas_merge             (is_object(_wep) && "temerge" in _wep && _wepXmerge_is_active)
#macro _wepXmerge                 _wep.temerge
#macro _wepXmerge_is_active       _wepXmerge.is_active
#macro _wepXmerge_is_part         _wepXmerge.is_part
#macro _wepXmerge_wep_raw         _wepXmerge.wep
#macro _wepXmerge_wep             _wepXmerge_wep_raw[@ 0]
#macro _wepXmerge_wep_fire_frame  _wepXmerge.wep_fire_frame
#macro _wepXmerge_fire_frame      _wepXmerge.fire_frame
#macro _wepXmerge_fire_at         _wepXmerge.fire_at_vars
#macro _wepXmerge_last_type       _wepXmerge.last_type
#macro _wepXmerge_last_cost       _wepXmerge.last_cost
#macro _wepXmerge_last_rads       _wepXmerge.last_rads
#macro _wepXmerge_last_stock_cost _wepXmerge.last_stock_cost

#define temerge_set_weapon_event(_eventName, _eventScriptRef)
	/*
		Sets the given merged weapon event to the given script reference
	*/
	
	global.weapon_event_script_map[? ((_eventName == "weapon_step") ? "step" : _eventName)] = _eventScriptRef;
	
#define temerge_create_weapon(_wep, _frontWep)
	/*
		Returns a merged weapon of the given weapon and front weapon combined
	*/
	
	 // Weapon Is/Has an Empty Slot:
	var _lastWep = _wep;
	_wep = _frontWep;
	var _wepIsPart = (call(scr.wep_raw, _wep) == wep_none || (_wepXhas_merge && _wepXmerge_is_part));
	_wep = _lastWep;
	
	 // Add to Front of Existing Merged Weapon:
	if(_wepXhas_merge){
		if(_wepIsPart){
			_wepXmerge_is_part = true;
		}
		_frontWep = temerge_create_weapon(_wepXmerge_wep, _frontWep);
	}
	
	 // Merged Weapon Setup:
	else{
		 // Wrapper Script Setup:
		with(ds_map_keys(global.weapon_event_script_map)){
			_wep = call(scr.wep_wrap, _wep, self, global.weapon_event_script_map[? self]);
		}
		
		 // LWO Setup (Just in Case):
		if(!is_object(_wep)){
			_wep = { "wep" : _wep };
		}
		
		 // Variable Setup:
		_wepXmerge                 = {};
		_wepXmerge_is_active       = true;
		_wepXmerge_is_part         = (_wepIsPart || call(scr.wep_raw, _wep) == wep_none);
		_wepXmerge_wep_raw         = [wep_none];
		_wepXmerge_wep_fire_frame  = 0;
		_wepXmerge_fire_frame      = 0;
		_wepXmerge_fire_at         = undefined;
		_wepXmerge_last_type       = 0;
		_wepXmerge_last_cost       = 0;
		_wepXmerge_last_rads       = 0;
		_wepXmerge_last_stock_cost = 0;
	}
	
	 // Set Front Weapon:
	_wepXmerge_wep = _frontWep;
	
	return _wep;
	
#define temerge_weapon_name(_wep, _stockName)
	/*
		Merged weapons insert their front weapon's name before the last word(s) of their stock weapon's name
		Words in the stock weapon's name are grouped with words in the front weapon's name for less repetition
		Redundant name suffixes are removed or replaced, like "GUN", "PISTOL", and "LAUNCHER"
		Weapon parts are suffixed with "STOCK" or "FRONT" depending on their type
	*/
	
	var _canMergeNameNonSync = true;
	
	 // HUD Optimization:
	if(
		instance_is(self, Player)
		&& (instance_is(other, TopCont) || instance_is(other, UberCont))
		&& (wep == _wep || bwep == _wep)
	){	
		var	_x = view_xview_nonsync + 24 + (44 * (wep != _wep)),
			_y = view_yview_nonsync + 16;
			
		 // Co-op Offset:
		for(var _playerIndex = 0, _playerCount = 0; _playerIndex < maxp; _playerIndex++){
			if(player_is_active(_playerIndex) && ++_playerCount > 1){
				_x -= 19;
				switch(call(scr.player_get_hud_index, index)){
					case 1 : _x += 227;            break;
					case 2 :            _y += 193; break;
					case 3 : _x += 227; _y += 193; break;
				}
				break;
			}
		}
		
		 // Check if Hovering:
		_canMergeNameNonSync = (
			   mouse_y_nonsync <= _y + 13
			&& mouse_x_nonsync <= _x + 31 + (44 * (wep == _wep && bwep == _wep))
			&& mouse_y_nonsync >= _y
			&& mouse_x_nonsync >= _x
		//	&& call(scr.player_get_show_hud_local_nonsync, index)
		);
	}
	
	 // Generate Merged Name:
	if(_canMergeNameNonSync && _wepXhas_merge){
		var _frontName = weapon_get_name(_wepXmerge_wep);
		if(_stockName != "" || _frontName != ""){
			var	_stockNameWordList     = [],
				_stockNameWordTextList = [],
				_frontNameWordList     = [],
				_frontNameWordTextList = [],
				_mergeNameWordList     = ((_frontName == "") ? _stockNameWordList     : _frontNameWordList),
				_mergeNameWordTextList = ((_frontName == "") ? _stockNameWordTextList : _frontNameWordTextList);
				
			 // Deconstruct Names Into Words:
			with([
				[_stockName, _stockNameWordList, _stockNameWordTextList],
				[_frontName, _frontNameWordList, _frontNameWordTextList]
			]){
				var _name = self[0];
				if(_name != ""){
					var	_nameWordList      = self[1],
						_nameWordTextList  = self[2],
						_textColor         = c_white,
						_textShake         = 0,
						_tagSplitNameIndex = 0;
						
					array_push(_nameWordList, {
						"space" : " ",
						"color" : _textColor,
						"shake" : _textShake,
						"text"  : ""
					});
					
					with(call(scr.string_split_nt, _name)){
						var	_tagString = self[0],
							_lineList  = string_split(self[1], "#"),
							_lineCount = array_length(_lineList);
							
						 // Parse Tag:
						if(_tagSplitNameIndex++ > 0){
							if(ds_map_exists(global.nt_tag_color_map, _tagString)){
								_textColor = global.nt_tag_color_map[? _tagString];
							}
							else if(_tagString == "q" || _tagString == "Q"){
								_textShake++;
							}
							else{
								var _tagExtStringStartPos = string_pos("(", _tagString);
								
								 // Custom Colors:
								if(_tagExtStringStartPos > 0 && string_split(string_delete(_tagString, 1, _tagExtStringStartPos), ":")[0] == "color"){
									_tagExtStringStartPos += 7;
									_textColor = real(string_copy(_tagString, _tagExtStringStartPos, string_pos(")", _tagString) - _tagExtStringStartPos));
								}
								
								 // Insert Non-Style Tags Back Into Words:
								else{
									_nameWordList[array_length(_nameWordList) - 1].text += "@" + _tagString;
									_tagString = "";
								}
							}
						}
						
						 // Parse Lines:
						for(var _lineIndex = 0; _lineIndex < _lineCount; _lineIndex++){
							var	_lineWordList  = string_split(_lineList[_lineIndex], " "),
								_lineWordCount = array_length(_lineWordList);
								
							 // Continue Last Word:
							if(_lineIndex == 0){
								var	_lineFirstWord = _lineWordList[0],
									_nameLastWord  = _nameWordList[array_length(_nameWordList) - 1];
									
								 // Update Style for Empty Words:
								if(_nameLastWord.text == ""){
									_nameLastWord.color = _textColor;
									_nameLastWord.shake = _textShake;
								}
								
								 // Active Words:
								else if(_lineFirstWord != ""){
									 // Store Latest Style:
									_nameLastWord.final_color = _textColor;
									_nameLastWord.final_shake = _textShake;
									
									 // Insert Raw Tags:
									if(_tagString != ""){
										_nameLastWord.text += "@" + _tagString;
									}
								}
								
								 // Add Text:
								_nameLastWord.text += _lineFirstWord;
							}
							
							 // Add New Words:
							for(var _lineWordIndex = ((_lineIndex == 0) ? 1 : 0); _lineWordIndex < _lineWordCount; _lineWordIndex++){
								array_push(_nameWordList, {
									"space" : ((_lineWordIndex > 0) ? " " : "#"),
									"color" : _textColor,
									"shake" : _textShake,
									"text"  : _lineWordList[_lineWordIndex]
								});
							}
						}
					}
					
					 // Compile Text Comparison List:
					with(_nameWordList){
						var	_text       = text,
							_textLength = string_length(_text);
							
						while(string_char_at(_text, _textLength) == "!"){
							_textLength--;
						}
						
						array_push(_nameWordTextList, string_upper(string_copy(_text, 1, _textLength)));
					}
				}
			}
			
			 // Combine Names (SUPER PLASMA CANNON + AUTO SHOTGUN = SUPER PLASMA AUTO SHOTGUN CANNON):
			if(_frontName != "" && _stockName != ""){
				var	_stockNamePrefixCount    = array_length(_stockNameWordList) - 1,
					_stockNamePrefixList     = array_slice(_stockNameWordList,     0, _stockNamePrefixCount),
					_stockNamePrefixTextList = array_slice(_stockNameWordTextList, 0, _stockNamePrefixCount),
					_stockNameSuffix         = _stockNameWordList[_stockNamePrefixCount],
					_stockNameSuffixText     = _stockNameWordTextList[_stockNamePrefixCount];
					
				 // Group Prefixes (*PLASMA* CANNON RIFLE > PLASMA PLASMA CANNON RIFLE):
				for(var _stockNamePrefixIndex = _stockNamePrefixCount - 1; _stockNamePrefixIndex >= 0; _stockNamePrefixIndex--){
					var _mergeNameWordIndex = array_find_index(_mergeNameWordTextList, _stockNamePrefixTextList[_stockNamePrefixIndex]);
					if(_mergeNameWordIndex >= 0){
						temerge_weapon_name_word_add_word(_mergeNameWordList[_mergeNameWordIndex], _stockNamePrefixList[_stockNamePrefixIndex]);
						_stockNamePrefixList     = call(scr.array_delete, _stockNamePrefixList,     _stockNamePrefixIndex);
						_stockNamePrefixTextList = call(scr.array_delete, _stockNamePrefixTextList, _stockNamePrefixIndex);
						_stockNamePrefixCount--;
					}
				}
				
				 // Prepend Prefixes:
				if(_stockNamePrefixCount > 0){
					_mergeNameWordList     = call(scr.array_combine, _stockNamePrefixList,     _mergeNameWordList);
					_mergeNameWordTextList = call(scr.array_combine, _stockNamePrefixTextList, _mergeNameWordTextList);
				}
				
				 // Remove Redundant Suffixes:
				switch(_stockNameSuffixText){
					
					case "GUN":
					case "PISTOL":
					case "LAUNCHER":
					
						 // SMART MACHINEGUN > SMART MACHINEGUN GUN:
						_stockNameSuffixText = "";
						
						break;
						
					case "REVOLVER":
					
						 // ULTRA POP GUN > ULTRA POP GUN REVOLVER:
						if(array_length(_stockNamePrefixList)){
							_stockNameSuffixText = "";
						}
						
						break;
						
					case "RIFLE":
					
						 // ASSAULT SHOTGUN > ASSAULT SHOTGUN RIFLE:
						if(array_find_index(_mergeNameWordTextList, "ASSAULT") >= 0){
							_stockNameSuffixText = "";
						}
						
						break;
						
					case "CANNON":
					
						 // FLAK MACHINEGUN > FLAK MACHINEGUN CANNON
						if(array_find_index(_mergeNameWordTextList, "FLAK") >= 0){
							_stockNameSuffixText = "";
						}
						
						break;
						
				}
				
				 // Append / Replace Suffix:
				if(_stockNameSuffixText != ""){
					var	_mergeNameSuffixIndex = array_length(_mergeNameWordTextList) - 1,
						_mergeNameSuffixText  = _mergeNameWordTextList[_mergeNameSuffixIndex];
						
					if(array_find_index(["STOCK", "FRONT", "PARTS"], _mergeNameSuffixText) >= 0){
						_mergeNameSuffixText = _mergeNameWordTextList[--_mergeNameSuffixIndex];
					}
					
					switch(_mergeNameSuffixText){
						
						case "GUN":
						case "PISTOL":
						case "LAUNCHER":
						
							 // Replace Redundant Suffixes (PLASMA DISC RIFLE > PLASMA DISC GUN RIFLE):
							_mergeNameWordList[_mergeNameSuffixIndex]     = _stockNameSuffix;
							_mergeNameWordTextList[_mergeNameSuffixIndex] = _stockNameSuffixText;
							
							break;
							
						default:
						
							 // Group Suffixes (HEAVY *MACHINEGUN* > HEAVY MACHINEGUN MACHINEGUN):
							var _mergeNameWordIndex = array_find_last_index(_mergeNameWordTextList, _stockNameSuffixText);
							if(_mergeNameWordIndex >= 0){
								temerge_weapon_name_word_add_word(_mergeNameWordList[_mergeNameWordIndex], _stockNameSuffix);
							}
							
							 // Append Suffix:
							else{
								_mergeNameSuffixIndex++;
								array_insert(_mergeNameWordList,     _mergeNameSuffixIndex, _stockNameSuffix);
								array_insert(_mergeNameWordTextList, _mergeNameSuffixIndex, _stockNameSuffixText);
							}
							
					}
				}
			}
			
			 // Append Part Type:
			if(_wepXmerge_is_part){
				var	_stockIsEmpty = (call(scr.wep_raw, _wep)           == wep_none),
					_frontIsEmpty = (call(scr.wep_raw, _wepXmerge_wep) == wep_none);
					
				if(_stockIsEmpty ^^ _frontIsEmpty){
					var	_mergeNameSuffixIndex = array_length(_mergeNameWordTextList) - 1,
						_mergeNameSuffixText  = _mergeNameWordTextList[_mergeNameSuffixIndex];
						
					if(_mergeNameSuffixText != "PARTS"){
						var _partWord = {
							"space" : " ",
							"color" : c_white,
							"shake" : 0,
							"text"  : ""
						};
						if(_mergeNameSuffixText == (_stockIsEmpty ? "STOCK" : "FRONT")){
							_partWord.text = "PARTS";
						}
						else{
							_mergeNameSuffixIndex++;
							_partWord.text = (_stockIsEmpty ? "FRONT" : "STOCK");
						}
						_mergeNameWordList[_mergeNameSuffixIndex]     = _partWord;
						_mergeNameWordTextList[_mergeNameSuffixIndex] = _partWord.text;
					}
				}
			}
			
			 // Reconstruct Name:
			var	_mergeName              = "",
				_lastMergeNameWordColor = c_white,
				_lastMergeNameWordShake = 0;
				
			_mergeNameWordList[0].space = "";
			
			with(_mergeNameWordList){
				 // Leading Spacer:
				_mergeName += space;
				
				 // Color:
				if(color != _lastMergeNameWordColor){
					var	_tagColorList  = ds_map_values(global.nt_tag_color_map),
						_tagColorIndex = array_find_index(_tagColorList, color);
						
					if(_tagColorIndex >= 0){
						_mergeName += `@${ds_map_keys(global.nt_tag_color_map)[_tagColorIndex]}`;
					}
					else{
						_mergeName += `@(color:${color})`;
					}
				}
				_lastMergeNameWordColor = (("final_color" in self) ? final_color : color);
				
				 // Shake:
				if(shake != _lastMergeNameWordShake){
					_mergeName += string_repeat("@q", shake - _lastMergeNameWordShake);
				}
				_lastMergeNameWordShake = (("final_shake" in self) ? final_shake : shake);
				
				 // Add Text:
				_mergeName += text;
			}
			
			return _mergeName;
		}
	}
	
	return _stockName;
	
#define temerge_weapon_name_word_add_word(_nameWord, _nameAddWord)
	/*
		Adds to the style of the given merged weapon name's word using the given additive word
	*/
	
	var	_nameWordColor           = _nameWord.color,
		_mergeNameWordColorList  = [global.nt_tag_color_map[? "r"], global.nt_tag_color_map[? "y"], global.nt_tag_color_map[? "g"], global.nt_tag_color_map[? "b"]],
		_mergeNameWordColorIndex = array_find_index(_mergeNameWordColorList, _nameWordColor);
		
	 // Shift Color Hue:
	if(
		(
			_mergeNameWordColorIndex >= 0
			|| color_get_saturation(_nameWordColor) < 255
			|| color_get_value(_nameWordColor) < 242
		)
		&& _mergeNameWordColorIndex + 1 < array_length(_mergeNameWordColorList)
	){
		_nameWord.color = _mergeNameWordColorList[_mergeNameWordColorIndex + 1];
		
		 // !!!:
		if(_mergeNameWordColorIndex >= 0){
			_nameWord.text += "!";
		}
	}
	else{
		var _hue = color_get_hue(_nameWordColor) + 39;
		if(_hue >= 255){
			_hue %= 255;
			_nameWord.shake++;
		}
		_nameWord.color = make_color_hsv(_hue, 255, 242);
	}
	
	 // Combine Shake:
	_nameWord.shake += _nameAddWord.shake;
	
#define temerge_weapon_text(_wep, _stockText)
	/*
		Merged weapons combine the first half of their front weapon's loading tip with the second half of their stock weapon's loading tip
		Weapon names and certain projectile names are swapped with more fitting references
	*/
	
	if(_wepXhas_merge){
		var _frontText = weapon_get_text(_wepXmerge_wep);
		
		if(
			(is_string(_stockText) && _stockText != "") &&
			(is_string(_frontText) && _frontText != "")
		){
			var _mergeText = string_lower(_stockText);
			_frontText = string_lower(_frontText);
			
			 // Fetch Stock Weapon Values:
			_wepXmerge_is_active = false;
			
			var	_stockName = weapon_get_name(_wep),
				_stockType = weapon_get_type(_wep);
				
			_wepXmerge_is_active = true;
			
			 // Swap Weapon Names:
			var _mergeName = string_lower(weapon_get_name(_wep));
			_frontText = string_replace(_frontText, string_lower(weapon_get_name(_wepXmerge_wep)), _mergeName);
			_mergeText = string_replace(_mergeText, string_lower(_stockName),                      _mergeName);
			
			 // Swap Projectile Names:
			if(_stockType >= 0 && _stockType < 6){
				var _frontType = weapon_get_type(_wepXmerge_wep);
				if(_stockType != _frontType && _frontType >= 0 && _frontType < 6){
					var	_typeTextLists = [
							["swing"],
							["bullet"],
							["shell"],
							["bolt"],
							["explosive", "grenade", "nade"],
							["plasma"]
						],
						_frontTypeText = _typeTextLists[_frontType][0];
						
					with(_typeTextLists[_stockType]){
						_mergeText = string_replace_all(_mergeText, self, _frontTypeText);
					}
				}
			}
			
			 // Combine Loading Tips:
			var	_frontTextWordList  = string_split(_frontText, " "),
				_mergeTextWordList  = string_split(_mergeText, " "),
				_mergeTextWordCount = array_length(_mergeTextWordList);
				
			_mergeText  = array_join(array_slice(_frontTextWordList, 0, max(1, floor(array_length(_frontTextWordList) / 2))), " ") + " ";
			_mergeText += array_join(array_slice(_mergeTextWordList, floor(_mergeTextWordCount / 2), ceil(_mergeTextWordCount / 2)), " ");
			
			return _mergeText;
		}
		
		return _frontText;
	}
	
	return _stockText;
	
#define temerge_weapon_sprt(_wep, _stockSprite)
	/*
		Merged weapons combine vertical slices from the sprites of their weapon parts
	*/
	
	if(_wepXhas_merge){
		if(sprite_get_name(_stockSprite) == "sprMerge" && _stockSprite == weapon_get_sprt_hud(_wep)){
			_wepXmerge_is_active = false;
			_stockSprite = weapon_get_sprt_hud(_wep);
			_wepXmerge_is_active = true;
		}
		return call(scr.merge_weapon_sprite, [_stockSprite, weapon_get_sprt(_wepXmerge_wep)]);
	}
	
	return _stockSprite;
	
#define temerge_weapon_sprt_hud(_wep, _stockHUDSprite)
	/*
		Merged weapons combine vertical slices from the HUD sprites of their weapon parts
	*/
	
	if(_wepXhas_merge){
		if(sprite_get_name(_stockHUDSprite) == "sprMerge" && _stockHUDSprite == weapon_get_sprt(_wep)){
			_wepXmerge_is_active = false;
			_stockHUDSprite = weapon_get_sprt(_wep);
			_wepXmerge_is_active = true;
		}
		return call(scr.merge_weapon_sprite, [_stockHUDSprite, weapon_get_sprt_hud(_wepXmerge_wep)]);
	}
	
	return _stockHUDSprite;
	
#define temerge_weapon_loadout(_wep, _stockLoadoutSprite)
	/*
		Merged weapons combine curved slices from the loadout sprites of their weapon parts
	*/
	
	if(_stockLoadoutSprite != 0 && _wepXhas_merge){
		var _frontLoadoutSprite = call(scr.weapon_get, "loadout", _wep);
		return (
			(_frontLoadoutSprite == 0)
			? 0
			: call(scr.merge_weapon_loadout_sprite, [_stockLoadoutSprite, _frontLoadoutSprite])
		);
	}
	
	return _stockLoadoutSprite;
	
#define temerge_weapon_swap(_wep, _stockSwapSound)
	/*
		Merged weapons use their front weapon's swap sound and play the swap sounds of their stock weapon(s) manually
	*/
	
	if(_wepXhas_merge){
		sound_play_pitchvol(_stockSwapSound, 1, 0.5);
		return weapon_get_swap(_wepXmerge_wep);
	}
	
	return _stockSwapSound;
	
#define temerge_weapon_area(_wep, _stockArea)
	/*
		Merged weapons use the spawn difficulty of ...
		***Do later when merged weapon spawning is rebalanced
	*/
	
	return _stockArea;
	
#define temerge_weapon_gold(_wep, _stockGold)
	/*
		Merged weapons are gold if all of their weapon parts are gold
	*/
	
	if(_stockGold != 0 && _wepXhas_merge){
		var _frontGold = weapon_get_gold(_wepXmerge_wep);
		if(_frontGold == 0 || _frontGold < _stockGold){
			return _frontGold;
		}
	}
	
	return _stockGold;
	
#define temerge_weapon_type(_wep, _stockType)
	/*
		Merged weapons use their front weapon's ammo type
	*/
	
	if(_wepXhas_merge){
		if(_wepXmerge_is_part){
			return type_melee;
		}
		
		var _mergeType = weapon_get_type(_wepXmerge_wep);
		
		_wepXmerge_last_type = _mergeType;
		
		return _mergeType;
	}
	
	return _stockType;
	
#define temerge_weapon_cost(_wep, _stockCost)
	/*
		Merged weapons use their front weapon's ammo cost:
		1. Multiplied by the reduced ammo cost of their stock weapon(s)
		2. Clamped at max capacity for fun (Back Muscle)
	*/
	
	_wepXmerge_last_stock_cost = _stockCost;
	
	if(_wepXhas_merge){
		if(_wepXmerge_is_part){
			return 0;
		}
		
		var	_frontCost = weapon_get_cost(_wepXmerge_wep),
			_mergeCost = _frontCost;
			
		if(_stockCost != 0 && _frontCost != 0){
			 // Integrate Stock Ammo Cost:
			_mergeCost += round(_mergeCost * (power(abs(_stockCost), 0.795) - 1));
			
			 // Clamp at Max Ammo:
			if(_mergeCost > 99){
				switch(weapon_get_type(_wep)){
					case type_bullet:
						if(_mergeCost > 555 && _stockCost <= 555 && _frontCost <= 555){
							_mergeCost = 555;
						}
						break;
						
					default:
						if(_stockCost <= 99 && _frontCost <= 99){
							_mergeCost = 99;
						}
				}
			}
		}
		
		_wepXmerge_last_cost = _mergeCost;
		
		return _mergeCost;
	}
	
	return _stockCost;
	
#define temerge_weapon_rads(_wep, _stockRads)
	/*
		Merged weapons use their front weapon's rad cost:
		1. Multiplied by the reduced ammo cost of their stock weapon(s)
		2. Added to half of the rad cost of their stock weapon(s) multiplied by how much ammo their front weapon(s) cost
		3. Clamped at max capacity for fun (Meltdown)
	*/
	
	if(_wepXhas_merge){
		if(_wepXmerge_is_part){
			return 0;
		}
		
		var	_frontRads = weapon_get_rads(_wepXmerge_wep),
			_mergeRads = _frontRads;
			
		if(_stockRads != 0 || _frontRads != 0){
			 // Integrate Stock Ammo Cost:
			if(_mergeRads != 0){
				_wepXmerge_is_active = false;
				
				var _stockCost = abs(weapon_get_cost(_wep));
				if(_stockCost != 0 && _stockCost != 1){
					_mergeRads += round(_mergeRads * (power(_stockCost, 0.795) - 1));
				}
				
				_wepXmerge_is_active = true;
			}
			
			 // Integrate Stock Rad Cost:
			if(_stockRads != 0){
				var	_addRads   = _stockRads / 2,
					_frontCost = weapon_get_cost(_wepXmerge_wep),
					_frontType = weapon_get_type(_wepXmerge_wep);
					
				if(_frontCost != 0){
					_addRads *= abs(_frontCost);
				}
				
				_wepXmerge_is_active = false;
				
				var _stockType = weapon_get_type(_wep);
				if(_stockType != _frontType){
					if(_stockType == type_bullet){
						_addRads *= 3;
					}
					else if(_frontType == type_bullet){
						_addRads /= 3;
					}
				}
				
				_wepXmerge_is_active = true;
				
				_mergeRads += round(_addRads);
			}
			
			 // Clamp at Max Rads:
			if(_mergeRads > 1200 && _stockRads <= 1200 && _frontRads <= 1200){
				_mergeRads = 1200;
			}
		}
		
		_wepXmerge_last_rads = _mergeRads;
		
		return _mergeRads;
	}
	
	return _stockRads;
	
#define temerge_weapon_load(_wep, _stockLoad)
	/*
		Merged weapons use their front weapon's reload:
		1. Multiplied by a reduced factor of the reload of their stock weapon(s)
		2. (If they cost no ammo) Increased by any surplus (>1) ammo cost from their stock weapon(s)
	*/
	
	if(_wepXhas_merge){
		if(_wepXmerge_is_part){
			return 1;
		}
		
		var	_frontLoad = weapon_get_load(_wepXmerge_wep),
			_mergeLoad = _frontLoad * lerp(1, _stockLoad / 8, 0.8);
			
		 // Less Reload Increase:
		if(_mergeLoad > _frontLoad){
			_mergeLoad = lerp(_mergeLoad, _frontLoad, 2/3);
		}
		
		 // Integrate Stock Ammo Cost (Ammoless Weapons):
		if(weapon_get_cost(_wep) == 0){
			_wepXmerge_is_active = false;
			_mergeLoad += 2 * max(0, abs(weapon_get_cost(_wep)) - 1);
			_wepXmerge_is_active = true;
		}
		
		return _mergeLoad;
	}
	
	return _stockLoad;
	
#define temerge_weapon_auto(_wep, _stockIsAuto)
	/*
		Merged weapons are automatic if their stock weapon is automatic, or if one of their other parts is automatic and reloads quickly
	*/
	
	if(_stockIsAuto >= 0 && _wepXhas_merge){
		if(_wepXmerge_is_part){
			return -1;
		}
		
		_wep = _wepXmerge_wep;
		
		var _frontIsAuto = weapon_get_auto(_wep);
		if(_frontIsAuto ? (weapon_get_load(_wep) <= 8) : (_frontIsAuto < 0)){
			return _frontIsAuto;
		}
	}
	
	return _stockIsAuto;
	
#define temerge_weapon_melee(_wep, _stockIsMelee)
	/*
		Merged weapons are melee if any of their weapon parts are melee
	*/
	
	if(!_stockIsMelee && _wepXhas_merge){
		return weapon_is_melee(_wepXmerge_wep);
	}
	
	return _stockIsMelee;
	
#define temerge_weapon_laser_sight(_wep, _stockLaserSight)
	/*
		Merged weapons use the laser sight of their stock weapon(s) (the first one that has a laser sight)
	*/
	
	if(_wepXhas_merge){
		if(_wepXmerge_is_part){
			return false;
		}
		
		if(_stockLaserSight == 0){
			_wep = _wepXmerge_wep;
			if(_wepXhas_merge){
				return weapon_get_laser_sight(_wep);
			}
		}
	}
	
	return _stockLaserSight;
	
#define temerge_weapon_red(_wep, _stockRed)
	/*
		Merged weapons alternate between using the red ammo costs of their front, first red-using, and latest-fired weapon parts
	*/
	
	if(
		_wepXhas_merge
		&& (
			(_wepXmerge_fire_frame < current_frame)
			? (_stockRed == 0 || (((current_frame - _wepXmerge_fire_frame) % 60) < 30 && !_wepXmerge_is_part))
			: (_wepXmerge_wep_fire_frame >= _wepXmerge_fire_frame)
		)
	){
		return call(scr.weapon_get, "red", _wepXmerge_wep);
	}
	
	return _stockRed;
	
#define temerge_weapon_reloaded(_wepIsPrimary)
	/*
		Merged weapons call all of their weapon part's reloaded events
	*/
	
	var _wep = (_wepIsPrimary ? wep : bwep);
	
	if(_wepXhas_merge && !_wepXmerge_is_part && _wepXmerge_wep_fire_frame >= _wepXmerge_fire_frame){
		var	_frontWep     = _wepXmerge_wep,
			_baseFrontWep = _frontWep;
			
		 // Find Base Front Weapon:
		while(is_object(_baseFrontWep) && "wep" in _baseFrontWep){
			_baseFrontWep = _baseFrontWep.wep;
		}
		
		 // Call Front Weapon's Reloaded Event:
		if(is_string(_baseFrontWep) && mod_script_exists("weapon", _baseFrontWep, "weapon_reloaded")){
			temerge_weapon_call_event(_wep, self, script_ref_create_ext("weapon", _baseFrontWep, "weapon_reloaded", _wepIsPrimary), true, "", undefined);
		}
		else{
			if(_wepIsPrimary){
				wep = _frontWep;
				
				call(scr.player_weapon_reloaded, _wepIsPrimary);
				
				if(wep != _frontWep){
					_wepXmerge_wep = wep;
				}
				wep = _wep;
			}
			else{
				bwep = _frontWep;
				
				call(scr.player_weapon_reloaded, _wepIsPrimary);
				
				if(bwep != _frontWep){
					_wepXmerge_wep = bwep;
				}
				bwep = _wep;
			}
		}
	}
	
#define temerge_weapon_step(_wepIsPrimary)
	/*
		Merged weapons call all of their weapon part's step events
	*/
	
	var _wep = (_wepIsPrimary ? wep : bwep);
	
	if(_wepXhas_merge && !_wepXmerge_is_part){
		var	_frontWep     = _wepXmerge_wep,
			_baseFrontWep = _frontWep;
			
		 // Find Base Front Weapon:
		while(is_object(_baseFrontWep) && "wep" in _baseFrontWep){
			_baseFrontWep = _baseFrontWep.wep;
		}
		
		 // Call Front Weapon's Step Event:
		if(is_string(_baseFrontWep) && mod_script_exists("weapon", _baseFrontWep, "step")){
			temerge_weapon_call_event(_wep, self, script_ref_create_ext("weapon", _baseFrontWep, "step", _wepIsPrimary), true, "", undefined);
		}
		else{
			if(_wepIsPrimary){
				wep = _frontWep;
				
				call(scr.player_weapon_step, _wepIsPrimary);
				
				if(wep != _frontWep){
					_wepXmerge_wep = wep;
				}
				wep = _wep;
			}
			else{
				bwep = _frontWep;
				
				call(scr.player_weapon_step, _wepIsPrimary);
				
				if(bwep != _frontWep){
					_wepXmerge_wep = bwep;
				}
				bwep = _wep;
			}
		}
	}
	
#define temerge_weapon_call_event(_wep, _creator, _scriptCallRef, _canWrapEvents, _wrapEventVarName, _wrapEventRef)
	/*
		Used to override a Player instance's weapons during the events of custom instances created during certain weapon events
	*/
	
	 // Just in Case:
	if(!argument_count) exit;
	
	 // Set Event Reference:
	if(_wrapEventVarName in self){
		variable_instance_set(self, _wrapEventVarName, _scriptCallRef);
	}
	
	 // Set Weapon, Call Script, & Capture Instances:
	if(instance_exists(_creator)){
		var	_minID          = (_canWrapEvents ? instance_max : undefined),
			_frontWep       = _wepXmerge_wep,
			_creatorHasWep  = (_creator.wep  == _wep),
			_creatorHasBWep = (_creator.bwep == _wep);
			
		 // Set Player Weapon:
		if(_creatorHasWep ){ _creator.wep  = _frontWep; }
		if(_creatorHasBWep){ _creator.bwep = _frontWep; }
		
		 // Call Script Reference:
		if(fork()){
			script_ref_call(_scriptCallRef);
			exit;
		}
		
		 // Revert Player Weapon:
		if(instance_exists(_creator)){
			if(_creatorHasBWep){ if(_creator.bwep != _frontWep){ _wepXmerge_wep = _creator.bwep; } _creator.bwep = _wep; }
			if(_creatorHasWep ){ if(_creator.wep  != _frontWep){ _wepXmerge_wep = _creator.wep;  } _creator.wep  = _wep; }
		}
		
		 // Wrap Events of New Instances:
		if(_canWrapEvents){
			for(var _id = instance_max - 1; _id >= _minID; _id--){
				if("object_index" in _id){
					var _instObject = _id.object_index;
					if(ds_map_exists(global.obj_event_varname_list_map, _instObject)){
						with(global.obj_event_varname_list_map[? _instObject]){
							var _instEventRef = variable_instance_get(_id, self);
							if(array_length(_instEventRef) >= 3){
								var _instEventWrapRef = script_ref_create(
									temerge_weapon_call_event,
									_wep,
									_creator,
									_instEventRef,
									(instance_is(_instObject, CustomObject) || instance_is(_instObject, CustomScript)), // Causes slight inconsistencies, but significantly reduces lag
									self
								);
								array_push(_instEventWrapRef, _instEventWrapRef);
								variable_instance_set(_id, self, _instEventWrapRef);
							}
						}
					}
				}
			}
		}
	}
	
	 // Call Script Reference:
	else if(fork()){
		script_ref_call(_scriptCallRef);
		exit;
	}
	
	 // Revert Event Reference:
	if(_wrapEventVarName in self){
		var _scriptRef = variable_instance_get(self, _wrapEventVarName);
		if(_scriptRef != _scriptCallRef){
			if(array_length(_scriptRef) >= 3){
				_wrapEventRef[@ array_find_index(_wrapEventRef, _scriptCallRef)] = _scriptRef;
			}
			else _wrapEventRef = _scriptRef;
		}
		variable_instance_set(self, _wrapEventVarName, _wrapEventRef);
	}
	
#define temerge_player_fire(_wep, _at)
	/*
		Merged weapon pre-firing event
	*/
	
	if(_wepXhas_merge){
		 // Don't Fire:
		if(_wepXmerge_is_part){
			_at.wep = wep_none;
			exit;
		}
		
		 // Store Firing Frame:
		_wepXmerge_fire_frame = current_frame;
		
		 // Apply Firing Variables:
		var _fireAt = _wepXmerge_fire_at;
		if(_fireAt != undefined){
			_at.x                  = _fireAt.x;
			_at.y                  = _fireAt.y;
			_at.position_distance  = _fireAt.position_distance;
			_at.position_direction = _fireAt.position_direction;
			_at.position_rotation  = _fireAt.position_rotation;
			_at.direction          = _fireAt.direction;
			_at.direction_rotation = _fireAt.direction_rotation;
			_at.accuracy           = _fireAt.accuracy;
			_at.wep                = _fireAt.wep;
			_at.team               = _fireAt.team;
			_at.creator            = _fireAt.creator;
		}
	}
	
	 // Setup Variable Container:
	var	_atTeam    = ((_at.team == undefined) ? team : _at.team),
		_atCreator = _at.creator,
		_merge     = call(scr.projectile_tag_get_value, _atTeam, _atCreator, "temerge_vars");
		
	if(_merge == undefined){
		_merge = {};
		call(scr.projectile_tag_set_value, _atTeam, _atCreator, "temerge_vars", _merge);
	}
	
	 // Store Initial Firing Values:
	var _fire = {
		"frame"        : current_frame,
		"x"            : x,
		"y"            : y,
		"hspeed"       : hspeed,
		"vspeed"       : vspeed,
		"wepangle"     : wepangle,
		"wkick"        : wkick,
		"reload"       : reload,
		"ammo"         : (instance_is(_atCreator, Player) ? array_clone(_atCreator.ammo) : undefined),
		"rads"         : GameCont.rad,
		"shake"        : [],
		"opt_shake"    : UberCont.opt_shake,
		"opt_freeze"   : UberCont.opt_freeze,
		"has_shot"     : false,
		"max_id"       : instance_max,
		"max_sound_id" : sound_play_pitchvol(0, 0, 0)
	};
	sound_stop(_fire.max_sound_id);
	for(var i = 0; i < maxp; i++){
		array_push(_fire.shake, view_shake[i]);
	}
	_merge.fire_vars = _fire;
	if("main_fire_vars" not in _merge){
		if(_wepXhas_merge){
			_merge.main_fire_vars = _fire;
			
			 // Return Ammo Cost:
			if(infammo == 0){
				if(instance_is(self, Player)){
					ammo[_wepXmerge_last_type] += _wepXmerge_last_cost;
				}
				GameCont.rad += _wepXmerge_last_rads;
				
				 // Update Stored Values:
				_fire.ammo = array_clone(ammo);
				_fire.rads = GameCont.rad;
			}
			
			 // Update Stored Type/Cost/Rads:
			else{
				weapon_get_type(_wep);
				weapon_get_cost(_wep);
				weapon_get_rads(_wep);
			}
			
			 // Store Initial Shot Values:
			_fire.ammo_type     = _wepXmerge_last_type;
			_fire.ammo_cost     = _wepXmerge_last_cost;
			_fire.rads_cost     = _wepXmerge_last_rads;
			_fire.cost_index    = 0;
			_fire.cost_interval = 1;
			_fire.can_replace   = true;
			
			 // Determine Interval for Dynamic Ammo/Rad Cost:
			var _lastWep = _wep;
			do{
				var _wepCost = _wepXmerge_last_stock_cost;
				if(_wepCost != 0){
					_fire.cost_interval *= abs(_wepCost);
				}
				_wep = _wepXmerge_wep;
			}
			until(!_wepXhas_merge);
			_wep = _lastWep;
		}
	}
	else{
		var _mainFire = _merge.main_fire_vars;
		
		 // Update Initial Values:
		if(_fire.frame > _mainFire.frame){
			for(var i = lq_size(_fire) - 1; i >= 0; i--){
				lq_set(_mainFire, lq_get_key(_fire, i), lq_get_value(_fire, i));
			}
		}
		
		 // Restore Initial Values:
		else{
			x        = _mainFire.x;
			y        = _mainFire.y;
			hspeed   = _mainFire.hspeed;
			vspeed   = _mainFire.vspeed;
			wepangle = abs(wepangle) * sign(_mainFire.wepangle);
			for(var i = 0; i < maxp; i++){
				view_shake[i] = _mainFire.shake[i];
			}
		}
	}
	
	 // Temporary Weapon Kick:
	wkick = 0;
	
	 // Reduce Screen Shifting & Disable Freeze Frames:
	//UberCont.opt_shake *= 0.5;
	if(_wepXhas_merge){
		//var _mainWep = _wep;
		//_wep = _wepXmerge_wep;
		//while(_wepXhas_merge){
		//	_wep = _wepXmerge_wep;
		//	UberCont.opt_shake /= 2;
		//}
		//_wep = _mainWep;
		UberCont.opt_shake  = 0;
		UberCont.opt_freeze = 0;
	}
	
#define temerge_weapon_fire(_wep)
	/*
		Merged weapon post-firing event
	*/
	
	var	_team    = team,
		_creator = (("creator" in self && instance_is(self, FireCont)) ? creator : self),
		_merge   = call(scr.projectile_tag_get_value, _team, _creator, "temerge_vars");
		
	if(_merge != undefined && "fire_vars" in _merge){
		var _fire = _merge.fire_vars;
		
		 // Check if a Teamed Object Was Shot:
		if(instance_exists(projectile) && projectile.id > _fire.max_id){
			_fire.has_shot = true;
		}
		else{
			var _maxID = instance_max;
			for(var _id = _fire.max_id; _id < _maxID; _id++){
				if("team" in _id){
					_fire.has_shot = true;
					break;
				}
			}
		}
		
		 // Has Shot Teamed Objects:
		if(_fire.has_shot){
			if("main_fire_vars" in _merge){
				var _mainFire = _merge.main_fire_vars;
				
				 // Only Flip Melee Angle After Gaps in Firing:
				if(sign(wepangle) != sign(_mainFire.wepangle)){
					if("wepangle_side_frame" not in _mainFire || (current_frame - _mainFire.wepangle_side_frame) > 1){
						_mainFire.wepangle_side = sign(wepangle);
					}
					_mainFire.wepangle_side_frame = current_frame;
				}
				if("wepangle_side" in _mainFire){
					wepangle = abs(wepangle) * sign(_mainFire.wepangle_side);
				}
				
				 // Combine Weapon Kick:
				if(wkick == 0){
					wkick = _fire.wkick;
				}
				else if(_fire != _mainFire){
					wkick = max(abs(wkick), abs(_fire.wkick)) * ((wkick < 0 || _fire.wkick < 0) ? -1 : 1);
				}
				
				 // Combine Motion:
				x      += _fire.x      - _mainFire.x;
				y      += _fire.y      - _mainFire.y;
				hspeed += _fire.hspeed - _mainFire.hspeed;
				vspeed += _fire.vspeed - _mainFire.vspeed;
				
				 // Combine Screenshake:
				var	_fireShake     = _fire.shake,
					_mainFireShake = _mainFire.shake;
					
				for(var i = 0; i < maxp; i++){
					view_shake[i] += _fireShake[i] - _mainFireShake[i];
				}
			}
		}
		
		 // Hasn't Shot Teamed Objects:
		else if("main_fire_vars" in _merge){
			var _mainFire = _merge.main_fire_vars;
			
			 // Muffle Firing Sounds from Stock Weapon:
			var _maxSoundID = _fire.max_sound_id;
			for(var _soundID = _mainFire.max_sound_id; _soundID < _maxSoundID; _soundID++){
				if(audio_is_playing(_soundID)){
					var _soundIndex = asset_get_index(audio_get_name(_soundID));
					if(audio_exists(_soundIndex)){
						if(ds_map_exists(global.sound_muffle_map, _soundIndex)){
							var _muffle = global.sound_muffle_map[? _soundIndex];
							_muffle.sound_id = _soundID;
							if(_muffle.frame < current_frame){
								_muffle.frame = current_frame;
								audio_sound_gain(
									_soundIndex,
									lerp(audio_sound_get_gain(_soundIndex), _muffle.sound_gain * 0.1, 0.2),
									0
								);
							}
						}
						else global.sound_muffle_map[? _soundIndex] = {
							"sound_id"   : _soundID,
							"sound_gain" : audio_sound_get_gain(_soundIndex),
							"frame"      : current_frame
						};
					}
				}
			}
			
			 // Delete Effects from Stock Weapon:
			if(instance_exists(Effect)){
				var _maxID = _fire.max_id;
				for(var _id = _mainFire.max_id; _id < _maxID; _id++){
					if(instance_is(_id, Effect)){
						instance_delete(_id);
					}
				}
			}
			
			 // Revert Melee Angle:
			wepangle = abs(wepangle) * sign(_mainFire.wepangle);
			
			 // Revert Weapon Kick:
			if(wkick == 0){
				wkick = _mainFire.wkick;
			}
		}
		
		 // Revert Ammo Cost:
		if(_wepXhas_merge){
			if(instance_is(_creator, Player)){
				var _fireAmmo = _fire.ammo;
				if(_fireAmmo != undefined){
					array_copy(_creator.ammo, 0, _fireAmmo, 0, array_length(_fireAmmo));
				}
			}
			GameCont.rad = _fire.rads;
		}
		
		 // Fix Reload:
		if(reload <= 0 && _fire.reload > 0){
			reload = max(reload, (("reloadspeed" in self) ? reloadspeed : 1) * current_time_scale);
		}
		
		 // Revert Options:
		UberCont.opt_shake  = _fire.opt_shake;
		UberCont.opt_freeze = _fire.opt_freeze;
	}
	
	
/// MERGED PROJECTILES
#define temerge_projectile_setup(_instanceList, _wep, _isMain, _mainX, _mainY, _mainDirection, _mainAccuracy, _mainTeam, _mainCreator)
	/*
		Merged weapons replace the projectiles fired by their stock weapon(s) with shots from their front weapon(s) and apply effects to the final projectiles
	*/
	
	if(array_length(_instanceList)){
		var _mainMerge = call(scr.projectile_tag_get_value, _mainTeam, _mainCreator, "temerge_vars");
		
		 // Replace Projectiles:
		if(_isMain && _wepXhas_merge){
			var	_mainWep         = _wep,
				_originX         = _mainX,
				_originY         = _mainY,
				_originDirection = _mainDirection,
				_playerSpeedMap  = ds_map_create();
				
			 // Setup Variable Container:
			if(_mainMerge == undefined){
				_mainMerge = {};
				call(scr.projectile_tag_set_value, _mainTeam, _mainCreator, "temerge_vars", _mainMerge);
			}
			
			 // Find Shot's Original Position & Direction:
			if(instance_exists(_mainCreator)){
				_originX = _mainCreator.x;
				_originY = _mainCreator.y;
				if("gunangle" in _mainCreator){
					_originDirection = _mainCreator.gunangle;
				}
			}
			
			 // Sort Projectiles by Relative Distance:
			var	_sortInstanceList = [],
				_sortNum          = 0,
				_lastInstanceDis  = 0;
				
			with(_instanceList){
				var _dis = point_distance(_originX, _originY, xstart, ystart);
				if(abs(_dis - _lastInstanceDis) > 8){
					_lastInstanceDis = _dis;
					_sortNum++;
				}
				array_push(_sortInstanceList, [self, _sortNum + random(1)]);
			}
			array_sort_sub(_sortInstanceList, 1, true);
			for(var i = array_length(_sortInstanceList) - 1; i >= 0; i--){
				_sortInstanceList[i] = _sortInstanceList[i][0];
			}
			
			 // Replace Projectiles w/ Firing:
			if("main_fire_vars" in _mainMerge){
				var	_mainMergeFire      = _mainMerge.main_fire_vars,
					_rawWep             = undefined,
					_wepSprite          = undefined,
					_stockSprite        = undefined,
					_instWasIndependent = false;
					
				with(_sortInstanceList){
					if(instance_exists(self)){
						 // Don't Replace Weapon Projectiles:
						if("wep" in self){
							if(_rawWep == undefined){
								_rawWep = call(scr.wep_raw, _wep);
							}
							if(wep == _wep || wep == _rawWep || call(scr.wep_raw, wep) == _rawWep){
								if(_wepSprite == undefined){
									_wepSprite = weapon_get_sprt(wep);
								}
								if(sprite_index == _wepSprite){
									continue;
								}
								else{
									if(_stockSprite == undefined){
										_wepXmerge_is_active = false;
										_stockSprite = weapon_get_sprt(_wep);
										_wepXmerge_is_active = true;
									}
									if(sprite_index == _stockSprite){
										sprite_index = _wepSprite;
										if(is_array(hitid) && array_length(hitid) > 1 && hitid[1] == _wepSprite){
											hitid[1] = sprite_index;
										}
										continue;
									}
								}
							}
						}
						
						 // Replace Projectile:
						if(_mainMergeFire.can_replace){
							var	_merge = {
									"on_fire"      : (("temerge_on_fire"      in self) ? temerge_on_fire      : undefined),
									"on_setup"     : (("temerge_on_setup"     in self) ? temerge_on_setup     : undefined),
									"on_hit"       : (("temerge_on_hit"       in self) ? temerge_on_hit       : undefined),
									"on_wall"      : (("temerge_on_wall"      in self) ? temerge_on_wall      : undefined),
									"on_destroy"   : (("temerge_on_destroy"   in self) ? temerge_on_destroy   : undefined),
									"speed_factor" : (("temerge_speed_factor" in self) ? temerge_speed_factor : undefined),
									"setup_vars"   : {}
								},
								_mergeObject = (
									("temerge_object" in self && temerge_object != undefined)
									? temerge_object
									: object_index
								),
								_fireAt = {
									"x"                  : undefined,
									"y"                  : undefined,
									"position_distance"  : point_distance(_originX, _originY, xstart, ystart),
									"position_direction" : undefined,
									"position_rotation"  : angle_difference(point_direction(_originX, _originY, xstart, ystart), _originDirection),
									"direction"          : undefined,
									"direction_rotation" : angle_difference(((direction == 0 && speed == 0) ? ((image_angle == 0) ? _originDirection : image_angle) : direction), _originDirection),
									"speed_factor"       : ((_merge.speed_factor == undefined) ? (0.5 + max(0, abs(speed / 32) * (1 - (friction / 2)))) : _merge.speed_factor),
									"accuracy"           : _mainAccuracy,
									"wep"                : _wepXmerge_wep_raw,
									"team"               : team,
									"creator"            : creator
								}
								
							 // Is Independent From the Creator:
							if(_instWasIndependent || round(_fireAt.position_distance) > 16){
								_instWasIndependent = true;
								_fireAt.x           = _originX;
								_fireAt.y           = _originY;
								_fireAt.direction   = _originDirection;
							}
							
							 // Setup Default Events:
							if(ds_map_exists(global.temerge_projectile_object_event_table, _mergeObject)){
								var _mergeObjectEventMap = global.temerge_projectile_object_event_table[? _mergeObject];
								switch(_merge.on_fire   ){ case undefined : _merge.on_fire    = _mergeObjectEventMap.fire;    }
								switch(_merge.on_setup  ){ case undefined : _merge.on_setup   = _mergeObjectEventMap.setup;   }
								switch(_merge.on_hit    ){ case undefined : _merge.on_hit     = _mergeObjectEventMap.hit;     }
								switch(_merge.on_wall   ){ case undefined : _merge.on_wall    = _mergeObjectEventMap.wall;    }
								switch(_merge.on_destroy){ case undefined : _merge.on_destroy = _mergeObjectEventMap.destroy; }
							}
							
							 // Call Merged Projectile Fire Event:
							if(_merge.on_fire != undefined){
								call(scr.pass, self, _merge.on_fire, _fireAt, _merge.setup_vars);
							}
							
							 // Weapon Firing:
							_wep = (
								is_array(_fireAt.wep)
								? _fireAt.wep[0]
								: _fireAt.wep
							);
							with(_fireAt.creator){
								with(
									instance_is(self, Player)
									? self
									: player_fire_ext(
										(("gunangle" in self) ? gunangle : _originDirection),
										wep_none,
										(("x"        in self) ? x        : _originX),
										(("y"        in self) ? y        : _originY),
										(("team"     in self) ? team     : _mainTeam),
										self,
										(("accuracy" in self) ? accuracy : _mainAccuracy)
									)
								){
									 // Take Ammo & Rads:
									if(!_wepXhas_merge){
										var	_costIndex    = _mainMergeFire.cost_index,
											_costInterval = _mainMergeFire.cost_interval;
											
										if(_costIndex >= _costInterval){
											_costIndex = (_costIndex + 1) % _costInterval;
										}
										
										if(_costIndex < 1 && instance_is(self, Player) && infammo == 0){
											if(
												ammo[_mainMergeFire.ammo_type] >= _mainMergeFire.ammo_cost &&
												GameCont.rad                   >= _mainMergeFire.rads_cost
											){
												ammo[_mainMergeFire.ammo_type] -= _mainMergeFire.ammo_cost;
												GameCont.rad                   -= _mainMergeFire.rads_cost;
											}
											else{
												_mainMergeFire.can_replace = false;
												break;
											}
										}
										
										_mainMergeFire.cost_index++;
									}
									
									 // Store Firing Frame:
									var _lastWep = _wep;
									_wep = _mainWep;
									_wepXmerge_wep_fire_frame = current_frame;
									_wep = _lastWep;
									
									 // Store Player Speed:
									if(instance_is(self, Player) && !ds_map_exists(_playerSpeedMap, self)){
										_playerSpeedMap[? self] = speed;
									}
									
									 // Store Variable Container:
									_merge.speed_factor   = _fireAt.speed_factor;
									_merge.main_fire_vars = _mainMerge.main_fire_vars;
									call(scr.projectile_tag_set_value,
										((_fireAt.team == undefined) ? team : _fireAt.team),
										_fireAt.creator,
										"temerge_vars",
										_merge
									);
									
									 // Fire:
									if(_wepXhas_merge){
										var _lastMergeFireAt = _wepXmerge_fire_at;
										_wepXmerge_fire_at = _fireAt;
										call(scr.pass, self, scr.weapon_get, "fire", _wep);
										_wepXmerge_fire_at = _lastMergeFireAt;
									}
									else{
										temerge_player_fire(_wep, _fireAt);
										call(scr.pass, self, scr.player_fire_at,
											{
												"x"         : _fireAt.x,
												"y"         : _fireAt.y,
												"distance"  : _fireAt.position_distance,
												"direction" : _fireAt.position_direction,
												"rotation"  : _fireAt.position_rotation
											},
											{
												"direction" : _fireAt.direction,
												"rotation"  : _fireAt.direction_rotation
											},
											_fireAt.accuracy,
											_fireAt.wep,
											_fireAt.team,
											_fireAt.creator,
											true
										);
										if(instance_exists(self)){
											var _lastTeam = team;
											team = _fireAt.team;
											temerge_weapon_fire(_wep);
											team = _lastTeam;
										}
									}
									
									 // Transfer Variables:
									if(instance_is(self, FireCont)){
										call(scr.FireCont_end, self);
									}
									
									 // Stop Firing if Nothing Was Shot:
									if("fire_vars" in _merge && !_merge.fire_vars.has_shot){
										_mainMergeFire.can_replace = false;
									}
								}
							}
							_wep = _mainWep;
						}
						
						 // Delete Projectile:
						if(instance_exists(self)){
							switch(object_index){
								case LightningBall:
								case FlameBall:
								case BloodBall:
									var _snd = variable_instance_get(self, "snd");
									if(instance_number(object_index) <= 1 || _snd != asset_get_index(audio_get_name(_snd))){
										sound_stop(_snd);
									}
									break;
							}
							instance_delete(self);
						}
					}
				}
			}
			
			 // Clamp Player Speed + Manual Push (For Stacking):
			with(instances_matching_ne(ds_map_keys(_playerSpeedMap), "id")){
				var _maxSpeed = max(_playerSpeedMap[? self], maxspeed);
				if(speed > _maxSpeed){
					var	_dirX =  dcos(direction),
						_dirY = -dsin(direction);
						
					for(var _dis = (speed - _maxSpeed) / 8; _dis > 0; _dis--){
						var	_len  = min(1, _dis),
							_lenX = _len * _dirX,
							_lenY = _len * _dirY;
							
						if(place_free(x + _lenX, y + _lenY)){
							x += _lenX;
							y += _lenY;
						}
						else break;
					}
					
					speed = _maxSpeed;
				}
			}
			ds_map_destroy(_playerSpeedMap);
		}
		
		 // Apply Merged Projectile Effects:
		else if(_mainMerge != undefined && "on_setup" in _mainMerge){
			_instanceList = instances_matching(_instanceList, "can_temerge", null, true);
			
			 // Ignore Instances That Already Have the Effects:
			with(_instanceList){
				if("temerge_vars_list" not in self){
					temerge_vars_list = [];
				}
				if(array_find_index(temerge_vars_list, _mainMerge) < 0){
					array_push(temerge_vars_list, _mainMerge);
				}
				else _instanceList = instances_matching_ne(_instanceList, "id", id);
			}
			
			 // Setup Speed Multiplier:
			var _speedFactor = _mainMerge.speed_factor;
			if(_speedFactor != 1){
				with(_instanceList){
					 // Manual Fixes:
					if(speed != 0){
						switch(object_index){
							
							case PlasmaBall:
							case PlasmaBig:
							case PlasmaHuge:
							
								temerge_projectile_add_effect(self, "fixed_plasma_speed_factor");
								
								break;
								
							case Seeker:
							
								temerge_projectile_add_effect(self, "fixed_seeker_speed_factor");
								
								break;
								
							case Rocket:
							case Nuke:
							
								if(_speedFactor > 1){
									if(active || alarm1 > 0){
										active = false;
										alarm1 = max(alarm1, 0) + 1;
										speed  = max(speed, ((object_index == Nuke) ? 5 : 12));
									}
								}
								else{
									temerge_projectile_add_effect(self, "fixed_rocket_speed_factor");
								}
								
								break;
								
						}
					}
					if("temerge_fixed_speed_factor" not in self){
						temerge_fixed_speed_factor = 1;
					}
					temerge_fixed_speed_factor *= _speedFactor;
					
					 // Clamp Speed:
					image_angle -= direction;
					var _maxSpeed = 16 + bbox_width;
					image_angle += direction;
					if(speed < _maxSpeed){
						speed = min(speed * _speedFactor, _maxSpeed);
					}
				}
			}
			
			 // Setup Events:
			with(["hit", "wall", "destroy"]){
				var	_eventName = self,
					_eventRef  = lq_get(_mainMerge, `on_${_eventName}`);
					
				if(_eventRef != undefined){
					temerge_projectile_add_event(_instanceList, _eventName, _eventRef);
				}
			}
			
			 // Call Setup Event:
			if(_mainMerge.on_setup != undefined){
				script_ref_call(_mainMerge.on_setup, _instanceList, _mainMerge.setup_vars);
			}
		}
	}
	
#define temerge_projectile_add_event(_instanceList, _eventName, _eventRef)
	/*
		Adds the given event to the given merged projectile instance
	*/
	
	var	_eventRefVarName     = `on_${_eventName}`,
		_eventRefListVarName = `temerge_${_eventName}_event_ref_list`;
		
	with(_instanceList){
		var _eventRefList = variable_instance_get(self, _eventRefListVarName);
		
		 // Setup Event Script Reference List:
		if(_eventRefList == undefined || !array_length(_eventRefList)){
			_eventRefList = [];
			variable_instance_set(self, _eventRefListVarName, _eventRefList);
			
			 // Custom Object (Wrap Existing Event):
			if(
				ds_map_exists(global.obj_event_varname_list_map, object_index)
				&& array_find_index(global.obj_event_varname_list_map[? object_index], _eventRefVarName) >= 0
			){
				var _lastEventRef = variable_instance_get(self, _eventRefVarName);
				if(_lastEventRef == undefined){
					var _defaultScriptIndex = script_get_index(`CustomProjectile_${_eventName}`);
					_lastEventRef = ((_defaultScriptIndex < 0) ? [] : script_ref_create(_defaultScriptIndex));
				}
				variable_instance_set(self, _eventRefVarName, script_ref_create(temerge_projectile_event_wrapper, _eventName, _lastEventRef));
			}
			
			 // Non-Custom Object:
			else temerge_projectile_add_effect(self, _eventName + "_event");
		}
		
		 // Update Destroy Event Variables:
		else if(_eventName == "destroy" && "temerge_destroy_event_vars" in self){
			var _destroyEventVars = call(scr.variable_instance_get_list, self);
			for(var _destroyEventVarIndex = lq_size(_destroyEventVars) - 1; _destroyEventVarIndex >= 0; _destroyEventVarIndex--){
				lq_set(temerge_destroy_event_vars, lq_get_key(_destroyEventVars, _destroyEventVarIndex), lq_get_value(_destroyEventVars, _destroyEventVarIndex));
			}
		}
		
		 // Store Event Script Reference:
		array_push(_eventRefList, _eventRef);
	}
	
#define temerge_projectile_event_wrapper(_eventName, _eventRef)
	/*
		Used as a wrapper script for merged projectile events
	*/
	
	var	_isSolid             = false,
		_isMeeting           = false,
		_context             = [self, other],
		_eventRefVarName     = `on_${_eventName}`,
		_eventRefListVarName = `temerge_${_eventName}_event_ref_list`,
		_eventRefList        = variable_instance_get(self, _eventRefListVarName),
		_lastEventRef        = variable_instance_get(self, _eventRefVarName);
		
	 // Set Event Reference:
	variable_instance_set(self, _eventRefVarName, _eventRef);
	
	 // Event-Specific:
	switch(_eventName){
		
		case "hit":
		case "wall":
		
			 // Check if Colliding:
			_isSolid   = (solid || other.solid);
			_isMeeting = (
				_isSolid
				? place_meeting(x + hspeed_raw, y + vspeed_raw, other)
				: place_meeting(x,              y,              other)
			);
			
			break;
			
		case "destroy":
		
			 // Remember Latest Instance:
			var _minID = instance_max;
			
			break;
			
	}
	
	 // Call Custom Scripts:
	with(_eventRefList){
		if(call(scr.pass, _context, self)){
			 // Remove Script From Event:
			_eventRefList = call(scr.array_delete_value, _eventRefList, self);
			if(instance_exists(other)){
				variable_instance_set(other, _eventRefListVarName, _eventRefList);
			}
			else exit;
		}
		else if(!instance_exists(other)){
			exit;
		}
		
		 // Stopped Colliding:
		if(_isMeeting){
			if(instance_exists(_context[1])){
				with(other){
					_isMeeting = (
						_isSolid
						? place_meeting(x + hspeed_raw, y + vspeed_raw, _context[1])
						: place_meeting(x,              y,              _context[1])
					);
				}
				if(!_isMeeting){
					_isMeeting = -1;
					break;
				}
			}
			else{
				_isMeeting = -1;
				break;
			}
		}
	}
	
	 // Event-Specific:
	switch(_eventName){
		
		case "destroy":
		
			 // Prevent Merged Effect Recursion by Default:
			for(var _id = instance_max - 1; _id >= _minID; _id--){
				if("team" in _id && "can_temerge" not in _id){
					_id.can_temerge = false;
				}
			}
			
			break;
			
	}
	
	 // Call Normal Script:
	if(_isMeeting != -1 && array_length(_eventRef) >= 3){
		call(scr.pass, _context, _eventRef);
	}
	
	 // Revert Event Reference:
	if(instance_exists(self) && array_length(_eventRefList)){
		var _scriptRef = variable_instance_get(self, _eventRefVarName);
		if(_scriptRef != _eventRef){
			if(array_length(_scriptRef) >= 3){
				_lastEventRef[@ array_find_index(_lastEventRef, _eventRef)] = _scriptRef;
			}
			else _lastEventRef = _scriptRef;
		}
		variable_instance_set(self, _eventRefVarName, _lastEventRef);
	}
	
#define temerge_projectile_wall_bounce()
	/*
		Called from a merged projectile in its wall collision event to make it bounce
	*/
	
	switch(object_index){
		
		case Laser:
		case EnemyLaser:
		
			 // Laser Bounce:
			with(instance_copy(false)){
				 // Restore Starting Values:
				xstart       = x;
				ystart       = y;
				image_xscale = 1;
				
				 // Bounce Direction:
				var	_addX = lengthdir_x(2, image_angle),
					_addY = lengthdir_y(2, image_angle);
					
				if(place_meeting(x + _addX, y, Wall)){
					_addX *= -1;
				}
				else if(place_meeting(x, y + _addY, Wall)){
					_addY *= -1;
				}
				else{
					_addX *= -1;
					_addY *= -1;
				}
				image_angle = point_direction(0, 0, _addX, _addY);
				direction   = image_angle;
				
				 // Rerun Hitscan:
				event_perform(ev_alarm, 0);
			}
			
			break;
			
		default:
		
			 // Normal Bounce:
			if(speed != 0){
				var _lastDirection = direction;
				move_bounce_solid(true);
				if(image_angle == _lastDirection){
					image_angle = direction;
				}
				
				 // Fun:
				if(instance_is(self, HyperGrenade)){
					alarm0 = 1;
					alarm1 = -1;
				}
			}
			
	}
	
#define temerge_projectile_add_scale // instanceList, addXScale, addYScale=addXScale
	/*
		Adds to the given merged projectile's scale, with manual visual fixes for certain projectiles
		
		Args:
			addXScale - The number to add to the instance's image_xscale
			addYScale - The number to add to the instance's image_yscale, defaults to addXScale
	*/
	
	var	_instanceList = argument[0],
		_addXScale    = argument[1],
		_addYScale    = ((argument_count > 2) ? argument[2] : _addXScale);
		
	with(_instanceList){
		image_xscale += _addXScale * ((image_xscale < 0) ? -1 : 1);
		image_yscale += _addYScale * ((image_yscale < 0) ? -1 : 1);
		
		 // Manual Visual Fixes:
		switch(object_index){
			
			case Rocket:
			case Nuke:
			
				temerge_projectile_add_effect(self, "fixed_scale");
				
				break;
				
			case Lightning:
			case EnemyLightning:
			
				temerge_fixed_yscale = image_yscale;
				temerge_projectile_add_effect(self, "fixed_lightning_scale");
				
				break;
				
		}
	}
	
#define temerge_projectile_add_bloom(_instanceList, _bloomAmount)
	/*
		Adds to the given merged projectile's bloom
	*/
	
	with(_instanceList){
		image_alpha += _bloomAmount * sign(image_alpha);
	}
	
#define temerge_projectile_scale_damage(_instanceList, _damageFactor)
	/*
		Scales the given merged projectile's damage
	*/
	
	with(_instanceList){
		damage += round(damage * (_damageFactor - 1));
	}
	
#define temerge_projectile_add_force(_instanceList, _forceAmount)
	/*
		Adds to the given merged projectile's push force
	*/
	
	with(_instanceList){
		force += _forceAmount * sign(force);
	}
	
#define temerge_projectile_add_effect // instance, effectName, ?effectSetupArgList
	/*
		Adds the given merged effect to the given merged projectile
		Future duplicates of the instance created by 'instance_copy' also get the effect
	*/
	
	var	_instance           = argument[0],
		_effectName         = argument[1],
		_effectSetupArgList = ((argument_count > 2) ? argument[2] : undefined);
		
	if("temerge_effect_vars_map" not in GameCont){
		GameCont.temerge_effect_vars_map = {};
	}
	
	var _effectVars = lq_get(GameCont.temerge_effect_vars_map, _effectName);
	
	 // Setup Effect Variables:
	if(_effectVars == undefined){
		_effectVars = {
			"instance_list"      : [],
			"event_instance_map" : {}
		};
		lq_set(GameCont.temerge_effect_vars_map, _effectName, _effectVars);
	}
	
	 // Activate Effect Events:
	if(ds_map_exists(global.temerge_effect_event_script_list_table, _effectName)){
		var _effectEventInstanceMap = _effectVars.event_instance_map;
		with(ds_map_keys(global.temerge_effect_event_script_list_table[? _effectName])){
			var _effectEventName = self;
			switch(_effectEventName){
				
				case "setup":
				
					 // Call Setup Event:
					var _effectLastInstanceList = _effectVars.instance_list;
					_effectVars.instance_list = (is_array(_instance) ? _instance : [_instance]);
					temerge_effect_call_event(_effectName, _effectEventName, _effectSetupArgList);
					_instance = _effectVars.instance_list;
					_effectVars.instance_list = _effectLastInstanceList;
					
					break;
					
				default:
				
					 // Create Event Instance:
					var _effectEventInstance = lq_defget(_effectEventInstanceMap, _effectEventName, noone);
					if(!instance_exists(_effectEventInstance)){
						var _effectEventObject = CustomScript;
						switch(_effectEventName){
							case "step"       : _effectEventObject = CustomObject;    break;
							case "post_step"  : _effectEventObject = CustomStep;      break;
							case "begin_step" : _effectEventObject = CustomBeginStep; break;
							case "end_step"   : _effectEventObject = CustomEndStep;   break;
							case "draw"       : _effectEventObject = CustomDraw;      break;
						}
						with(instance_create(0, 0, _effectEventObject)){
							lq_set(_effectEventInstanceMap, _effectEventName, self);
							
							 // Set Event's Script:
							var _scriptRef = script_ref_create(temerge_effect_call_event, _effectName, _effectEventName, undefined);
							switch(_effectEventObject){
								case CustomObject : on_step = _scriptRef; break;
								default           : script  = _scriptRef;
							}
							
							 // Event-Specific:
							switch(_effectEventObject){
								
								case CustomStep:
								case CustomObject:
								
									 // Run Step Events on Frame of Creation:
									if("temerge_effect_call_step_instance_list" not in GameCont){
										GameCont.temerge_effect_call_step_instance_list = [];
									}
									array_push(GameCont.temerge_effect_call_step_instance_list, self);
									GameCont.temerge_effect_call_step_frame = current_frame;
									
									break;
									
								case CustomDraw:
								
									 // Set Draw Event's Initial Depth:
									var _effectEventInstanceDepth = infinity;
									with(_instance){
										if(depth - 1 < _effectEventInstanceDepth){
											_effectEventInstanceDepth = depth - 1;
										}
									}
									depth = _effectEventInstanceDepth;
									
									break;
									
							}
						}
					}
					
			}
		}
	}
	
	 // Prune Instance List:
	_effectVars.instance_list = instances_matching_ne(_effectVars.instance_list, "id");
	
	 // Add Instance to Effect:
	with(_instance){
		 // Bind 'instance_copy' Instance Capturing Script:
		var _effectObjectSetupBindVarName = `bind_setup_temerge_${_effectName}_${object_get_name(object_index)}`;
		if(lq_get(ntte, _effectObjectSetupBindVarName) == undefined){
			lq_set(ntte, _effectObjectSetupBindVarName, call(scr.ntte_bind_setup, script_ref_create(temerge_effect_object_setup, _effectName, object_index), object_index));
		}
		
		 // Add to Instance List:
		if(array_find_index(_effectVars.instance_list, self) < 0){
			array_push(_effectVars.instance_list, self);
			
			 // Instance Capturing Identifier:
			var _effectInstanceVarName = `temerge_${_effectName}_instance`;
			if(_effectInstanceVarName not in self){
				variable_instance_set(self, _effectInstanceVarName, self);
			}
			
			 // Destroy Event:
			if(_effectName == "destroy_event" && "temerge_destroy_event_vars" not in self){
				 // Setup Variables List:
				if("destroy_event_vars_list" not in _effectVars){
					_effectVars.destroy_event_vars_list     = [];
					_effectVars.destroy_event_instance_list = [];
				}
				
				 // Store Variables:
				temerge_destroy_event_vars = call(scr.variable_instance_get_list, self);
				array_push(_effectVars.destroy_event_vars_list,     temerge_destroy_event_vars);
				array_push(_effectVars.destroy_event_instance_list, self);
			}
		}
	}
	
	
/// MERGED EFFECTS
#define temerge_effect_add_event(_effectName, _effectEventName, _scriptRef)
	/*
		Adds the given script to the given merged effect's event
	*/
	
	var _effectEventScriptListTable = global.temerge_effect_event_script_list_table;
	
	 // Setup Event Script List Map:
	var _effectEventScriptListMap = ds_map_find_value(_effectEventScriptListTable, _effectName);
	if(_effectEventScriptListMap == undefined){
		_effectEventScriptListMap = ds_map_create();
		_effectEventScriptListTable[? _effectName] = _effectEventScriptListMap;
	}
	
	 // Setup Event Script List:
	var _effectEventScriptList = ds_map_find_value(_effectEventScriptListMap, _effectEventName);
	if(_effectEventScriptList == undefined){
		_effectEventScriptList = [];
		_effectEventScriptListMap[? _effectEventName] = _effectEventScriptList;
	}
	
	 // Add to Event Script List:
	array_push(_effectEventScriptList, _scriptRef);
	
#define temerge_effect_call_event(_effectName, _effectEventName, _effectEventArgList)
	/*
		Runs the given event of the given merged effect for its instances
	*/
	
	if("temerge_effect_vars_map" in GameCont){
		var _effectVars = lq_get(GameCont.temerge_effect_vars_map, _effectName);
		if(_effectVars != undefined){
			var _effectInstanceList = _effectVars.instance_list;
			if(array_length(_effectInstanceList)){
				 // Call Event Scripts:
				with(global.temerge_effect_event_script_list_table[? _effectName][? _effectEventName]){
					 // Prune Instance List:
					_effectInstanceList = instances_matching_ne(_effectInstanceList, "id");
					_effectVars.instance_list = [];
					
					 // Call Script:
					var _newEffectInstanceList = (
						(_effectEventArgList == undefined)
						? script_ref_call(self, _effectInstanceList)
						: script_ref_call(call(scr.array_combine, self, [_effectInstanceList], _effectEventArgList))
					);
					if(_newEffectInstanceList != 0){
						_effectInstanceList = _newEffectInstanceList;
					}
					
					 // Store Instances:
					if(array_length(_effectVars.instance_list)){
						_effectInstanceList = call(scr.array_combine, _effectInstanceList, _effectVars.instance_list);
					}
					_effectVars.instance_list = _effectInstanceList;
				}
				
				 // Update Draw Event Depth:
				if(_effectEventName == "draw" && lq_get(_effectVars.event_instance_map, _effectEventName) == self){
					var _effectDepthInstanceList = instances_matching_lt(_effectInstanceList, "depth", depth + 1);
					if(array_length(_effectDepthInstanceList)){
						with(_effectDepthInstanceList){
							other.depth = min(other.depth, depth - 1);
						}
					}
				}
				
				 // Destroy Event:
				if("destroy_event_vars_list" in _effectVars){
					if(!array_equals(_effectVars.destroy_event_instance_list, _effectInstanceList)){
						_effectVars.destroy_event_instance_list = _effectInstanceList;
						with(_effectVars.destroy_event_vars_list){
							if(!instance_exists(id)){
								 // Remove From List:
								_effectVars.destroy_event_vars_list = call(scr.array_delete_value, _effectVars.destroy_event_vars_list, self);
								
								 // Dummy Object:
								with(instance_create(x, y, object_index)){
									 // Set Stored Variables:
									call(scr.variable_instance_set_list, self, other);
									xprevious = x;
									yprevious = y;
									direction = other.direction;
									speed     = other.speed;
									
									 // Move Ahead:
									if(!place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
										x += hspeed_raw;
										y += vspeed_raw;
									}
									
									 // Offset Lasers:
									switch(object_index){
										case Laser:
										case EnemyLaser:
											x -= lengthdir_x(12, direction);
											y -= lengthdir_y(12, direction);
									}
									
									 // Call Event Scripts:
									with(temerge_destroy_event_ref_list){
										call(scr.pass, other, self);
										if(!instance_exists(other)){
											break;
										}
									}
									
									 // Prevent Merged Effect Recursion by Default:
									for(var _id = instance_max - 1; _id >= self; _id--){
										if("team" in _id && "can_temerge" not in _id){
											_id.can_temerge = false;
										}
									}
									
									 // Delete:
									instance_delete(self);
								}
							}
						}
					}
				}
			}
			
			 // Unbind Script:
			else if(lq_get(_effectVars.event_instance_map, _effectEventName) == self){
				lq_set(_effectVars.event_instance_map, _effectEventName, noone);
				instance_destroy();
			}
		}
	}
	
#define temerge_effect_object_setup(_effectName, _setupObject, _setupInstanceList)
	/*
		Collects merged projectiles that were created by 'instance_copy()'
	*/
	
	if("temerge_effect_vars_map" in GameCont){
		var _effectVars = lq_get(GameCont.temerge_effect_vars_map, _effectName);
		if(_effectVars != undefined){
			var _effectInstanceList = _effectVars.instance_list;
			if(array_length(_effectInstanceList)){
				var _effectInstanceVarName = `temerge_${_effectName}_instance`;
				
				 // Collect Instances:
				with(instances_matching_ne(_setupInstanceList, _effectInstanceVarName, null)){
					if(array_find_index(_effectInstanceList, self) < 0){
						if(array_find_index(_effectInstanceList, variable_instance_get(self, _effectInstanceVarName)) >= 0){
							array_push(_effectInstanceList, self);
							
							 // Update Instance Capturing Identifier:
							variable_instance_set(self, _effectInstanceVarName, self);
							
							 // Store Destroy Event Variables:
							if("destroy_event_vars_list" in _effectVars){
								temerge_destroy_event_vars = call(scr.variable_instance_get_list, self);
								array_push(_effectVars.destroy_event_vars_list,     temerge_destroy_event_vars);
								array_push(_effectVars.destroy_event_instance_list, self);
							}
						}
					}
				}
				
				 // Don't Unbind Script:
				exit;
			}
		}
	}
	
	 // Unbind Script:
	var	_effectObjectSetupBindVarName = `bind_setup_temerge_${_effectName}_${object_get_name(_setupObject)}`,
		_effectObjectSetupBind        = lq_get(ntte, _effectObjectSetupBindVarName);
		
	if(_effectObjectSetupBind != undefined){
		call(scr.ntte_unbind, _effectObjectSetupBind);
		lq_set(ntte, _effectObjectSetupBindVarName, undefined);
	}
	
	
#define temerge_collision_event_post_step(_collisionType, _instanceList)
	/*
		Predicts collisions and runs custom collision events for merged projectiles
	*/
	
	var	_collisionDis    = 16,
		_collisionObject = -1;
		
	 // Collision Object:
	switch(_collisionType){
		case "hit"  : _collisionObject = hitme; break;
		case "wall" : _collisionObject = Wall;  break;
	}
	
	 // Instance Collision:
	var _collisionInstanceList = instances_matching_ne(_instanceList, "mask_index", mskNone);
	if(array_length(_collisionInstanceList)){
		with(_collisionInstanceList){
			if(instance_exists(self) && distance_to_object(_collisionObject) <= _collisionDis + max(0, abs(speed_raw) - friction_raw) + abs(gravity_raw)){
				var _isFixingSolid = false;
				
				 // Fix Projectiles Without Wall Collision Events:
				if(_collisionObject == Wall && array_find_index([Laser, EnemyLaser, Lightning, EnemyLightning, HyperGrenade], object_index) >= 0){
					_isFixingSolid = true;
					
					var	_lastXPrevious = xprevious,
						_lastYPrevious = yprevious;
						
					xprevious = x;
					yprevious = y;
					
					 // Object-Specific:
					switch(object_index){
						
						case Laser:
						case EnemyLaser:
						
							xprevious -= lengthdir_x(2, image_angle);
							yprevious -= lengthdir_y(2, image_angle);
							
							break;
						
						case HyperGrenade:
						
							if(alarm0 == 0){
								xprevious -= lengthdir_x(4, direction);
								yprevious -= lengthdir_y(4, direction);
							}
							
							break;
							
					}
				}
				
				 // Apply Motion:
				call(scr.motion_step, self, 1);
				
				 // Search for Nearby Walls:
				if(distance_to_object(_collisionObject) <= _collisionDis){
					var _meetInstanceList = call(scr.instances_meeting_rectangle,
						bbox_left   - _collisionDis,
						bbox_top    - _collisionDis,
						bbox_right  + _collisionDis,
						bbox_bottom + _collisionDis,
						(
							(_collisionObject == hitme)
							? instances_matching_ne(_collisionObject, "team", team)
							: _collisionObject
						)
					);
					if(array_length(_meetInstanceList)){
						with(_meetInstanceList){
							 // Apply Motion:
							call(scr.motion_step, self, 1);
							
							 // Collision:
							if(place_meeting(x, y, other)){
								with(other){
									var	_isSolid             = (other.solid || solid),
										_context             = [self, other],
										_eventRefListVarName = `temerge_${_collisionType}_event_ref_list`,
										_eventRefList        = variable_instance_get(self, _eventRefListVarName),
										_minID               = instance_max;
										
									 // Solid Collision:
									if(_isSolid){
										x       = xprevious;
										y       = yprevious;
										other.x = other.xprevious;
										other.y = other.yprevious;
									}
									
									 // Call Event Scripts:
									with(_eventRefList){
										if(call(scr.pass, _context, self)){
											 // Remove Script From Event:
											_eventRefList = call(scr.array_delete_value, _eventRefList, self);
											if(instance_exists(other)){
												variable_instance_set(other, _eventRefListVarName, _eventRefList);
											}
											else break;
										}
										else if(!instance_exists(other)){
											break;
										}
										
										 // Stopped Colliding:
										if(instance_exists(_context[1])){
											var _isMeeting = true;
											with(other){
												_isMeeting = (
													_isSolid
													? place_meeting(x + hspeed_raw, y + vspeed_raw, _context[1])
													: place_meeting(x,              y,              _context[1])
												);
											}
											if(!_isMeeting){
												break;
											}
										}
										else break;
									}
									
									 // Solid Collision:
									if(_isSolid){
										if(instance_exists(self)){
											x += hspeed_raw;
											y += vspeed_raw;
										}
										if(instance_exists(other)){
											other.x += other.hspeed_raw;
											other.y += other.vspeed_raw;
										}
									}
									
									 // Colliding Instance(s) Created During Event:
									var _maxID = instance_max;
									for(var _id = _minID; _id < _maxID && instance_exists(self); _id++){
										if(instance_is(_id, _collisionObject) && place_meeting(x, y, _id)){
											_isSolid    = (solid || _id.solid);
											_context[1] = _id;
											
											 // Solid Collision:
											if(_isSolid){
												x     = xprevious;
												y     = yprevious;
												_id.x = _id.xprevious;
												_id.y = _id.yprevious;
											}
											
											 // Call Event Scripts:
											with(_eventRefList){
												if(call(scr.pass, _context, self)){
													 // Remove Script From Event:
													_eventRefList = call(scr.array_delete_value, _eventRefList, self);
													if(instance_exists(other)){
														variable_instance_set(other, _eventRefListVarName, _eventRefList);
													}
													else break;
												}
												else if(!instance_exists(other)){
													break;
												}
												
												 // Stopped Colliding:
												if(instance_exists(_context[1])){
													var _isMeeting = true;
													with(other){
														_isMeeting = (
															_isSolid
															? place_meeting(x + hspeed_raw, y + vspeed_raw, _context[1])
															: place_meeting(x,              y,              _context[1])
														);
													}
													if(!_isMeeting){
														break;
													}
												}
												else break;
											}
											
											 // Solid Collision:
											if(_isSolid){
												if(instance_exists(self)){
													x += hspeed_raw;
													y += vspeed_raw;
												}
												if(instance_exists(_id)){
													_id.x += _id.hspeed_raw;
													_id.y += _id.vspeed_raw;
												}
											}
											
											 // Keep Searching:
											_maxID = instance_max;
										}
									}
									
									 // Remove From Event Instance List:
									if(!instance_exists(self) || !array_length(_eventRefList)){
										_instanceList = instances_matching_ne(_instanceList, "id", self);
									}
								}
								if(!instance_exists(self)){
									continue;
								}
							}
							
							 // Revert Motion:
							call(scr.motion_step, self, -1);
						}
						if(!instance_exists(self)){
							continue;
						}
					}
				}
				
				 // Revert Motion:
				call(scr.motion_step, self, -1);
				
				 // Revert Wall Collision Fix:
				if(_isFixingSolid){
					xprevious = _lastXPrevious;
					yprevious = _lastYPrevious;
				}
			}
		}
	}
	
	return _instanceList;
	
	
#define temerge_destroy_event_post_step(_instanceList)
	/*
		Updates the stored destroy event variables for merged projectiles
	*/
	
	with(_instanceList){
		var _destroyVars = temerge_destroy_event_vars;
		_destroyVars.mask_index   = mask_index;
		_destroyVars.sprite_index = sprite_index;
		_destroyVars.image_index  = image_index;
		_destroyVars.image_xscale = image_xscale;
		_destroyVars.image_yscale = image_yscale;
		_destroyVars.image_angle  = image_angle;
		_destroyVars.image_blend  = image_blend;
		_destroyVars.image_alpha  = image_alpha;
		_destroyVars.x            = x;
		_destroyVars.y            = y;
		_destroyVars.speed        = speed;
		_destroyVars.direction    = direction;
		_destroyVars.friction     = friction;
		_destroyVars.damage       = damage;
		_destroyVars.force        = force;
		_destroyVars.team         = team;
		_destroyVars.creator      = creator;
	}
	
	
#define temerge_fixed_plasma_speed_factor_step(_instanceList)
	/*
		Fixes the speed multiplier for plasma merged projectiles
	*/
	
	with(instances_matching(_instanceList, "image_speed", 0)){
		_instanceList = instances_matching_ne(_instanceList, "id", id);
		speed *= temerge_fixed_speed_factor;
	}
	
	return _instanceList;
	
#define temerge_fixed_seeker_speed_factor_step(_instanceList)
	/*
		Fixes the speed multiplier for seeker merged projectiles
	*/
	
	with(_instanceList){
		speed *= temerge_fixed_speed_factor;
	}
	
#define temerge_fixed_rocket_speed_factor_step(_instanceList)
	/*
		Fixes the speed multiplier for rocket merged projectiles
	*/
	
	with(_instanceList){
		var _maxSpeed = ((object_index == Nuke) ? 5 : 12) * temerge_fixed_speed_factor;
		if(speed > _maxSpeed){
			speed = _maxSpeed;
		}
	}
	
#define temerge_fixed_scale_draw(_instanceList)
	/*
		Draws visual scale fixes for merged projectiles
	*/
	
	with(instances_matching(_instanceList, "visible", true)){
		draw_self();
	}
	
#define temerge_fixed_lightning_scale_draw(_instanceList)
	/*
		Draws visual scale fixes for lightning merged projectiles
	*/
	
	with(instances_matching(_instanceList, "visible", true)){
		var _yScale = temerge_fixed_yscale / 2;
		image_yscale *= _yScale;
		draw_self();
		image_yscale /= _yScale;
	}
	
	
#define temerge_trail_setup(_instanceList)
	/*
		Merged projectile trail visual effect
	*/
	
	with(instances_matching(_instanceList, "temerge_trail_color", null)){
		temerge_trail_color     = c_white;
		temerge_trail_is_sprite = !(
			   instance_is(self, Grenade)
			|| instance_is(self, Rocket)
			|| instance_is(self, Nuke)
			|| instance_is(self, Bolt)
			|| instance_is(self, HeavyBolt)
			|| instance_is(self, UltraBolt)
			|| instance_is(self, Seeker)
			|| instance_is(self, Disc)
		);
		
		 // Default Trail Color:
		switch(object_index){
			
			case BloodGrenade:
			
				temerge_trail_color = make_color_rgb(174, 58, 45);
				
				break;
				
			case ToxicGrenade:
			case UltraGrenade:
			
				temerge_trail_color = make_color_rgb(190, 253, 8);
				
				break;
				
			case ConfettiBall:
			
				temerge_trail_color = mycol;
				
				break;
				
		}
	}
	
#define temerge_trail_end_step(_instanceList)
	/*
		Merged trail projectiles leave behind a particle streak
	*/
	
	var _areaIsUnderwater = call(scr.area_get_underwater, GameCont.area);
	
	with(instances_matching_gt(_instanceList, "speed", 0)){
		if(image_index != 0 || image_speed == 0 || image_number == 1){
			with(instance_create(xprevious, yprevious, BoltTrail)){
				image_xscale = point_distance(x, y, other.x, other.y);
				image_angle  = point_direction(x, y, other.x, other.y);
				creator      = other.creator;
				if(other.temerge_trail_is_sprite){
					sprite_index  = other.sprite_index;
					image_index   = other.image_index;
					image_speed   = 0;
					image_xscale /= 1 + (other.sprite_width / 2);
					image_yscale  = other.image_yscale / 2;
					image_blend   = other.image_blend;
				}
				else{
					image_blend = other.temerge_trail_color;
				}
			}
			
			 // Bubbles:
			if(_areaIsUnderwater && chance_ct(1, 4)){
				instance_create(x, y, Bubble);
			}
		}
	}
	
	
#define temerge_flame_setup(_instanceList)
	/*
		Merged projectile flame-releasing effect
	*/
	
	with(_instanceList){
		if("temerge_flame_amount" not in self){
			temerge_flame_amount = [0];
			temerge_projectile_add_event(self, "destroy", script_ref_create(temerge_flame_projectile_destroy));
		}
		temerge_flame_amount[0]++;
	}
	
#define temerge_flame_step(_instanceList)
	/*
		Flame projectiles release their flame early if they slow down enough
	*/
	
	var _releaseInstanceList = instances_matching_gt(instances_matching_lt(_instanceList, "speed", 5), "friction", 0);
	
	if(array_length(_releaseInstanceList)){
		with(_releaseInstanceList){
			_instanceList = instances_matching_ne(_instanceList, "id", id);
			
			 // Release Flames:
			temerge_flame_projectile_destroy();
			temerge_flame_amount[@ 0] = 0;
		}
	}
	
	return _instanceList;
	
#define temerge_flame_projectile_destroy
	/*
		Flame projectiles release their flame on destruction
	*/
	
	if(temerge_flame_amount[0] > 0){
		repeat(temerge_flame_amount[0]){
			with(call(scr.projectile_create,
				x,
				y,
				Flame,
				((speed == 0) ? random(360) : direction),
				max(1.5, speed / 2)
			)){
				 // No Recursion:
				can_temerge = false;
			}
		}
	}
	
	
#define temerge_toxic_setup(_instanceList)
	/*
		Merged projectile toxic gas-releasing effect
	*/
	
	temerge_projectile_add_event(_instanceList, "destroy", script_ref_create(temerge_toxic_projectile_destroy));
	
#define temerge_toxic_projectile_destroy
	/*
		Toxic projectiles release toxic gas on destruction
	*/
	
	var _num = damage * 2/3;
	
	_num = min(floor(_num) + chance(frac(_num), 1), 640);
	
	if(_num > 0){
		var	_x = x,
			_y = y;
			
		 // Move Ahead:
		// if(speed > 0){
		// 	var	_lastX = x,
		// 		_lastY = y;
				
		// 	move_contact_solid(direction, speed_raw);
		// 	_x = x;
		// 	_y = y;
			
		// 	x  = _lastX;
		// 	y  = _lastY;
		// }
		
		 // Release Gas:
		repeat(_num){
			instance_create(_x, _y, ToxicGas);
		}
		
		 // Sound:
		call(scr.sound_play_at,
			_x,
			_y,
			sndToxicBoltGas,
			max(0.6, 1.2 - (0.0125 * _num)) + orandom(0.1),
			0.2 + (0.05 * _num),
			320
		);
		
		 // Effects:
		repeat(ceil(_num / 3)){
			call(scr.fx, _x, _y, random(sqrt(_num) / 2), Smoke);
		}
	}
	
	
#define temerge_slug_setup(_instanceList, _size)
	/*
		Merged projectile slug impact effect
	*/
	
	with(_instanceList){
		if("temerge_slug_size" not in self){
			temerge_slug_size = 0;
			temerge_projectile_add_event(self, "hit", script_ref_create(temerge_slug_projectile_hit));
		}
		temerge_slug_size += _size;
	}
	
	 // Add Bloom:
	temerge_projectile_add_bloom(_instanceList, _size / 3);
	
#define temerge_slug_hit(_instance, _hitInstance, _hitX, _hitY, _hitDamage)
	/*
		Applies merged slug projectile impact damage & effects to the given hittable instance
		
		Args:
			instance    - The projectile instance
			hitInstance - The hitme instance
			hitX, hitY  - The position that the hitme instance is being hit from
			hitDamage   - The damage that is applied to the hitme instance
			hitMult     - The multiplier for the damage and effects
	*/
	
	with(_hitInstance){
		var	_x   = bbox_center_x,
			_y   = bbox_center_y,
			_dir = (
				(_x == _hitX && _y == _hitY)
				? random(360)
				: point_direction(_x, _y, _hitX, _hitY)
			);
			
		 // Hit Effect:
		with(instance_create(
			_x + lengthdir_x(min(abs(_hitX - _x), (bbox_width  / 2) + 1), _dir),
			_y + lengthdir_y(min(abs(_hitY - _y), (bbox_height / 2) + 1), _dir),
			BulletHit
		)){
			var _scale = 0.75 + (max(0, _hitDamage) / 80);
			sprite_index = ((_scale < 1.5) ? sprSlugHit : sprHeavySlugHit);
			image_xscale = ((_scale < 1.5) ? _scale     : (_scale / 1.5));
			image_yscale = image_xscale;
			depth        = -6;
			friction     = 0.6;
			motion_add(_dir + 180 + orandom(30), 4);
		}
		
		 // Hit Damage:
		if(instance_exists(_instance)){
			with(_instance){
				projectile_hit(other, _hitDamage);
			}
		}
		else projectile_hit_raw(self, _hitDamage, 1);
	}
	
#define temerge_slug_projectile_hit
	/*
		Merged slug projectiles deal extra impact damage to the first thing they hit
	*/
	
	if(temerge_slug_size != 0){
		if(
			projectile_canhit(other)
			&& other.my_health > 0
			&& ("canhurt" not in self || canhurt) // Bolts
		){
			var _damage = ceil(((damage == 0) ? 1 : damage) * (power(1.5, temerge_slug_size) - 1));
			
			if("temerge_slug_nexthurt" not in other || other.temerge_slug_nexthurt <= current_frame){
				var _lastNextHurt = other.nexthurt;
				
				 // Deal Impact Damage:
				temerge_slug_hit(self, other, x, y, _damage);
				
				with(other){
					 // Manual I-Frames:
					temerge_slug_nexthurt = nexthurt;
					nexthurt = _lastNextHurt;
					
					 // Piercing Fix:
					if(my_health <= 0){
						script_bind_end_step(temerge_slug_projectile_hit_health_end_step, 0, self, my_health);
						my_health = 1;
					}
				}
				
				 // Disable Slug Effect:
				if(instance_exists(self)){
					temerge_projectile_add_bloom(self, -temerge_slug_size / 3);
					temerge_slug_size = 0;
				}
				
				 // Disable Event:
				return true;
			}
			
			 // Check Post-Collision:
			else script_bind_end_step(temerge_slug_projectile_hit_end_step, 0, self, other, x, y, _damage);
		}
	}
	
	 // Disable Event:
	else return true;
	
#define temerge_slug_projectile_hit_end_step(_instance, _hitInstance, _hitX, _hitY, _hitDamage)
	if(!instance_exists(_instance)){
		temerge_slug_hit(_instance, instances_matching_ne(_hitInstance, "id"), _hitX, _hitY, _hitDamage);
	}
	instance_destroy();
	
#define temerge_slug_projectile_hit_health_end_step(_slugInstance, _lastHealth)
	with(instances_matching_le(_slugInstance, "my_health", 1)){
		my_health = _lastHealth + (my_health - 1);
	}
	instance_destroy();
	
	
#define temerge_hyper_setup(_instanceList, _hyperSpeed)
	/*
		Merged projectile hyper effect
	*/
	
	with(_instanceList){
		 // Hyper Melee:
		if(speed < 8 && array_find_index([Slash, EnemySlash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, LightningSlash, CustomSlash, Shank, EnergyShank], object_index) >= 0){
			if(array_find_index(obj.HyperSlashTrail, self) < 0){
				var	_maskIndex   = ((mask_index < 0) ? sprite_index : mask_index),
					_bboxCenterX = bbox_center_x,
					_bboxCenterY = bbox_center_y;
					
				with(creator){
					if(mask_index != mskNone && !place_meeting(_bboxCenterX, _bboxCenterY, Wall) && !collision_line(x, y, _bboxCenterX, _bboxCenterY, Wall, false, false)){
						var	_lastX    = x,
							_lastY    = y,
							_moveDis  = max(64, 2 * ((sprite_get_bbox_right(_maskIndex) + 1) - sprite_get_bbox_left(_maskIndex))) * _hyperSpeed,
							_moveLen  = 8,
							_moveDir  = ((other.direction == 0 && other.speed == 0) ? ((other.image_angle == 0 && "gunangle" in self) ? gunangle : other.image_angle) : other.direction),
							_moveX    = lengthdir_x(_moveLen, _moveDir),
							_moveY    = lengthdir_y(_moveLen, _moveDir);
							
						x = _bboxCenterX;
						y = _bboxCenterY;
						
						 // Creator Wall Hitscan:
						while(_moveDis > 0 && place_free(x + (3 * _moveX), y + (3 * _moveY))){
							_moveDis -= _moveLen;
							x        += _moveX;
							y        += _moveY;
						}
						
						 // Slash:
						with(other){
							var	_trailX = x,
								_trailY = y;
								
							 // Move Slash:
							x        += other.x - _bboxCenterX;
							y        += other.y - _bboxCenterY;
							xprevious = x;
							yprevious = y;
							
							 // Create Trail:
							with(call(scr.obj_create, _trailX, _trailY, "HyperSlashTrail")){
								target = other;
								
								 // One-Sided Trail:
								if("wepangle" in other.creator){
									sprite_side = -sign(other.creator.wepangle * other.image_yscale);
								}
								
								 // Fix for Position Changing in End Step:
								if(instance_is(other, CustomSlash) && other.on_end_step != undefined){
									on_end_step = on_step;
								}
								
								 // Instant Setup:
								event_perform(ev_step, ev_step_normal);
							}
						}
						
						 // Keep Creator Here:
						var _hyperDistance = point_distance(x, y, _bboxCenterX, _bboxCenterY);
						if(
							"temerge_hyper_frame" not in self
							|| temerge_hyper_frame < current_frame
							|| ("temerge_hyper_distance" in self && _hyperDistance > temerge_hyper_distance)
						){
							temerge_hyper_frame    = current_frame;
							temerge_hyper_distance = _hyperDistance;
							xprevious              = x;
							yprevious              = y;
							
							 // Shift Screen:
							call(scr.view_shift, index, _moveDir, _hyperDistance / 2);
						}
						
						 // Move Creator Back:
						else{
							x = _lastX;
							y = _lastY;
						}
					}
				}
			}
			
			 // Remove From List:
			_instanceList = instances_matching_ne(_instanceList, "id", id);
		}
		
		 // Hyper Projectiles:
		else{
			if("temerge_hyper_speed" not in self){
				temerge_hyper_speed    = 0;
				temerge_hyper_minspeed = max(1, min(friction * 10, speed - (4 * friction)));
			}
			temerge_hyper_speed += _hyperSpeed;
		}
	}
	
	return _instanceList;
	
#define temerge_hyper_begin_step(_instanceList)
	/*
		Merged hyper projectiles travel instantly until they hit a wall or enemy
	*/
	
	with(instances_matching_ge(_instanceList, "speed", 1)){
		if(speed >= temerge_hyper_minspeed){
			var	_stepNum = 0,
				_stepMax = 15 * temerge_hyper_speed,
				_isMelee = (array_find_index(global.projectile_collision_projectile_list, object_index) >= 0);
				
			with(self){
				while(_stepNum < _stepMax && speed >= temerge_hyper_minspeed){
					 // Alarms:
					if(((current_frame + _stepNum + epsilon) % 1) < current_time_scale){
						var _notExisting = false;
						for(var _alarmIndex = 0; _alarmIndex < 12; _alarmIndex++){
							var _alarmNum = alarm_get(_alarmIndex);
							if(_alarmNum >= 0){
								//if(event_exists(object_index, ev_alarm, _alarmIndex)){
									alarm_set(_alarmIndex, --_alarmNum);
									if(_alarmNum == 0){
										event_perform(ev_alarm, _alarmIndex);
										if(!instance_exists(self)){
											_notExisting = true;
											break;
										}
									}
								//}
							}
						}
						if(_notExisting){
							break;
						}
					}
					
					 // Step:
					event_perform(ev_step, ev_step_normal);
					if(!instance_exists(self)){
						break;
					}
					
					 // Movement:
					if(friction_raw != 0 && speed_raw != 0){
						speed_raw -= min(abs(speed_raw), friction_raw) * sign(speed_raw);
					}
					if(gravity_raw != 0){
						hspeed_raw += lengthdir_x(gravity_raw, gravity_direction);
						vspeed_raw += lengthdir_y(gravity_raw, gravity_direction);
					}
					if(speed_raw != 0){
						x += hspeed_raw;
						y += vspeed_raw;
					}
					
					 // Smoke Trail:
					if(chance_ct(1, 10)){
	        			instance_create(x, y, Smoke);
					}
					
					 // Potential Collision:
					if(place_meeting(x, y, Wall) || place_meeting(x, y, PortalShock)){
						x = xprevious;
						y = yprevious;
						break;
					}
					
					 // Potential Hit:
					if(place_meeting(x, y, hitme)){
						if(array_length(instances_matching_gt(call(scr.instances_meeting_instance, self, instances_matching_ne(hitme, "team", team)), "my_health", 0))){
							x = xprevious;
							y = yprevious;
							break;
						}
					}
					
					 // Potential Deflection:
					if(typ != 0){
						var _collisionObjectList = [];
						if(place_meeting(x, y, projectile   )) _collisionObjectList = call(scr.array_combine, _collisionObjectList, global.projectile_collision_projectile_list);
						if(place_meeting(x, y, CrystalShield)) array_push(_collisionObjectList, CrystalShield);
						if(place_meeting(x, y, PopoShield   )) array_push(_collisionObjectList, PopoShield);
						if(place_meeting(x, y, MeatExplosion)) array_push(_collisionObjectList, MeatExplosion);
						if(place_meeting(x, y, PopoExplosion)) array_push(_collisionObjectList, PopoExplosion);
						if(array_length(_collisionObjectList)){
							if(array_length(call(scr.instances_meeting_instance, self, instances_matching_ne(_collisionObjectList, "team", team)))){
								x = xprevious;
								y = yprevious;
								break;
							}
						}
					}
					if(_isMelee && place_meeting(x, y, projectile)){
						if(array_length(call(scr.instances_meeting_instance, self, instances_matching_ne(instances_matching_ne(projectile, "team", team), "typ", 0)))){
							x = xprevious;
							y = yprevious;
							break;
						}
					}
					
					 // End Step:
					event_perform(ev_step, ev_step_end);
					if(!instance_exists(self)){
						break;
					}
					
					 // Store Last Position:
					xprevious = x;
					yprevious = y;
					
					 // Animate:
					image_index += image_speed_raw;
					if(image_index < 0 || image_index >= image_number){
						image_index -= image_number * sign(image_index);
						event_perform(ev_other, ev_animation_end);
						if(!instance_exists(self)){
							break;
						}
					}
					
					 // Begin Step:
					event_perform(ev_step, ev_step_begin);
					if(!instance_exists(self)){
						break;
					}
					
					_stepNum += current_time_scale;
				}
			}
			
			 // Remove From List:
			if(instance_exists(self) && speed - friction_raw < temerge_hyper_minspeed){
				_instanceList = instances_matching_ne(_instanceList, "id", id);
			}
		}
	}
	
	return _instanceList;
	
	
#define temerge_seek_setup(_instanceList)
	/*
		Merged projectile enemy seeking effect
	*/
	
	with(_instanceList){
		if("temerge_seek_strength" not in self){
			temerge_seek_strength = 0;
		}
		temerge_seek_strength++;
	}
	
#define temerge_seek_step(_instanceList)
	/*
		Merged seeker projectiles turn towards the nearest enemy
	*/
	
	var _seekInstanceList = instances_matching_ne(instances_matching_ne([enemy, Player, Ally, Sapling, SentryGun, CustomHitme], "team", 0), "mask_index", mskNone);
	
	if(array_length(_seekInstanceList)){
		with(instances_matching_ne(_instanceList, "speed", 0)){
			var	_turn   = orandom(speed_raw / 4),
				_target = call(scr.instance_nearest_array,
					x + (6 * hspeed),
					y + (6 * vspeed),
					instances_matching_ne(_seekInstanceList, "team", team)
				);
				
			 // Turn Towards Target:
			if(instance_exists(_target) && !collision_line(x, y, _target.x, _target.y, Wall, false, false)){
				var	_addTurn = angle_difference(point_direction(x, y, _target.x, _target.y), direction),
					_maxTurn = 3 * (abs(_addTurn) / (abs(_addTurn) + 30)) * temerge_seek_strength * current_time_scale;
					
				 // Nearby Seeking:
				if(distance_to_object(_target) < 6 * speed){
					_maxTurn *= 2;
					
					 // Disable Nuke Homing:
					if(instance_is(self, Nuke)){
						index = -1;
					}
				}
				
				_turn += clamp(_addTurn, -_maxTurn, _maxTurn);
			}
			
			 // Turning:
			direction   += _turn;
			image_angle += _turn;
		}
		
		 // Lasers:
		var _laserInstanceList = instances_matching(instances_matching(_instanceList, "object_index", Laser, EnemyLaser), "speed", 0);
		if(array_length(_laserInstanceList)){
			with(_laserInstanceList){
				var _target = call(scr.instance_nearest_array, x, y, instances_matching_ne(_seekInstanceList, "team", team));
				if(instance_exists(_target) && !collision_line(xstart, ystart, _target.x, _target.y, Wall, false, false)){
					var	_len = min(4 * temerge_seek_strength * current_time_scale, point_distance(x, y, _target.x, _target.y)),
						_dir = point_direction(x, y, _target.x, _target.y);
						
					x           += lengthdir_x(_len, _dir);
					y           += lengthdir_y(_len, _dir);
					image_angle  = point_direction(xstart, ystart, x, y);
					image_xscale = point_distance(xstart, ystart, x, y) / 2;
				}
			}
		}
	}
	
	
#define temerge_grenade_setup // instanceList, maxRange, ?explosionInfo
	/*
		Merged projectile timed explosion effect
	*/
	
	var	_instanceList  = argument[0],
		_maxRange      = argument[1],
		_explosionInfo = ((argument_count > 2) ? argument[2] : undefined);
		
	if("temerge_grenade_frame" not in GameCont){
		GameCont.temerge_grenade_frame = 0;
	}
	
	with(_instanceList){
		if("temerge_grenade_frame" not in self){
			temerge_grenade_frame          = GameCont.temerge_grenade_frame;
			temerge_grenade_explosion_list = [];
			
			 // Projectile Events:
			temerge_projectile_add_event(self, "destroy", script_ref_create(temerge_grenade_projectile_destroy));
			if(instance_is(self, HyperGrenade)){
				temerge_projectile_add_event(self, "hit",  script_ref_create(temerge_grenade_HyperGrenade_hit));
				temerge_projectile_add_event(self, "wall", script_ref_create(temerge_grenade_HyperGrenade_wall));
			}
		}
		
		 // Explosion Delay:
		temerge_grenade_frame = max(temerge_grenade_frame, GameCont.temerge_grenade_frame + (_maxRange / max(6, speed))) - 1;
		if(instance_is(self, Grenade) && alarm0 > 0){
			temerge_grenade_frame += alarm0 / 4;
			alarm0 = -1;
		}
		
		 // Add Explosion:
		if(_explosionInfo != undefined){
			array_push(temerge_grenade_explosion_list, _explosionInfo);
		}
	}
	
	 // Toxic Explosions:
	if(_explosionInfo != undefined && _explosionInfo.is_toxic){
		temerge_projectile_add_effect(_instanceList, "toxic");
	}
	
#define temerge_grenade_step(_instanceList)
	/*
		Merged grenade projectiles destroy themselves after a certain amount of time
	*/
	
	GameCont.temerge_grenade_frame += current_time_scale;
	
	with(instances_matching_le(_instanceList, "temerge_grenade_frame", GameCont.temerge_grenade_frame)){
		instance_destroy();
	}
	
#define temerge_grenade_end_step(_instanceList)
	/*
		Merged grenade projectiles explode when they touch an explosion
	*/
	
	if(instance_exists(Explosion)){
		var _blinkInstanceList = instances_matching_le(_instanceList, "temerge_grenade_frame", GameCont.temerge_grenade_frame + 10);
		if(array_length(_blinkInstanceList)){
			with(_blinkInstanceList){
				if(place_meeting(x, y, Explosion)){
					instance_destroy();
				}
			}
		}
	}
	
#define temerge_grenade_draw(_instanceList)
	/*
		Merged grenade projectiles visually flash when about to explode
	*/
	
	var _blinkInstanceList = instances_matching(instances_matching_le(_instanceList, "temerge_grenade_frame", GameCont.temerge_grenade_frame + 10), "visible", true);
	
	if(array_length(_blinkInstanceList)){
		draw_set_fog(true, ((((GameCont.temerge_grenade_frame * 0.4) % 2) < 1) ? c_white : c_black), 0, 0);
		
		with(_blinkInstanceList){
			draw_self();
		}
		
		draw_set_fog(false, 0, 0, 0);
	}
	
#define temerge_grenade_projectile_destroy
	/*
		Merged grenade projectiles create explosions on destruction
	*/
	
	if((object_index != Lightning && object_index != EnemyLightning) || (ammo % 4) < 1){
		var	_explosionList  = temerge_grenade_explosion_list,
			_explosionCount = array_length(_explosionList),
			_explosionAngle = random(360);
			
		for(var _explosionIndex = 0; _explosionIndex < _explosionCount; _explosionIndex++){
			var	_explosion          = _explosionList[_explosionIndex],
				_explosionIsSmall   = (_explosion.is_small || damage < 10),
				_explosionIsHeavy   = _explosion.is_heavy,
				_explosionIsBlood   = _explosion.is_blood,
				_explosionIsCluster = _explosion.is_cluster,
				_explosionOffsetLen = min(16, 8 * (_explosionCount - 1)),
				_explosionOffsetDir = _explosionAngle + (360 * (_explosionIndex / _explosionCount)),
				_explosionX         = x + lengthdir_x(_explosionOffsetLen, _explosionOffsetDir),
				_explosionY         = y + lengthdir_y(_explosionOffsetLen, _explosionOffsetDir),
				_explosionSubCount  = ((_explosionIsBlood && !_explosionIsSmall) ? 3 : 1),
				_explosionSubAngle  = random(360);
				
			 // Sound:
			if(_explosionIsCluster){
				sound_play_hit(sndClusterOpen, 0.2);
			}
			else if(_explosionIsBlood){
				sound_play_hit_big(sndMeatExplo,          0.2);
				sound_play_hit_big(sndBloodLauncherExplo, 0.2);
			}
			else sound_play_hit_big(
				(
					(_explosionCount > 1)
					? (_explosionIsSmall ? sndExplosion  : sndExplosionL)
					: (_explosionIsSmall ? sndExplosionS : sndExplosion)
				),
				0.2
			);
			
			 // Create Explosion:
			for(var _explosionSubOffsetDir = _explosionSubAngle; _explosionSubOffsetDir < _explosionSubAngle + 360; _explosionSubOffsetDir += (360 / _explosionSubCount)){
				if(_explosionIsCluster){
					var _clusterNum = min(ceil(damage / 3), 640) + (crown_current == crwn_death);
					if(_clusterNum > 0){
						var _clusterMotionLerpAmount = min(abs(speed) / 16, 1) / sqrt(_clusterNum);
						repeat(_clusterNum){
							call(scr.projectile_create,
								x + orandom(2),
								y + orandom(2),
								MiniNade,
								angle_lerp(random(360), direction, _clusterMotionLerpAmount),
								lerp(random_range(3, 8), speed / 2, _clusterMotionLerpAmount)
							);
							
							 // Smoke:
							call(scr.fx, x, y, random_range(2, 5), Smoke);
						}
					}
				}
				else{
					var _explosionSubOffsetLen = ((_explosionSubCount > 1) ? 24 : random(1));
					with(call(scr.projectile_create,
						_explosionX + lengthdir_x(_explosionSubOffsetLen, _explosionSubOffsetDir),
						_explosionY + lengthdir_y(_explosionSubOffsetLen, _explosionSubOffsetDir),
						(
							_explosionIsBlood
							? MeatExplosion
							: (
								_explosionIsSmall
								? (_explosionIsHeavy ? "SmallGreenExplosion" : SmallExplosion)
								: (_explosionIsHeavy ? GreenExplosion        : Explosion)
							)
						),
						direction,
						speed / 4
					)){
						friction    = 0.5;
						image_angle = 0;
						
						 // Damage:
						damage  = other.damage;
						damage *= (_explosionIsHeavy ? (4/5) : (1/3));
						if(_explosionIsBlood){
							damage *= 0.8;
						}
						damage = round(damage);
						
						 // Streak Blood:
						if(_explosionIsBlood){
							with(instance_create(_explosionX, _explosionY, BloodStreak)){
								image_angle = _explosionSubOffsetDir;
							}
						}
						
						 // Hostile to Player:
						else{
							team = -1;
							if(hitid == -1){
								switch(object_index){
									case Explosion      : hitid = 55; break;
									case SmallExplosion : hitid = 56; break;
									case GreenExplosion : hitid = 99; break;
								}
							}
							
							 // Crown of Death:
							if(crown_current == crwn_death && _explosionIsSmall && !_explosion.is_small){
								with(instance_copy(false)){
									x += orandom(2);
									y += orandom(2);
								}
							}
						}
					}
				}
			}
		}
	}
	
#define temerge_grenade_HyperGrenade_hit
	 // Delay Explosion:
	alarm1 = max(alarm1, temerge_grenade_frame - GameCont.temerge_grenade_frame);
	
#define temerge_grenade_HyperGrenade_wall
	var _canBounce = false;
	with(temerge_grenade_explosion_list){
		if(!is_small && !is_blood){
			_canBounce = true;
			break;
		}
	}
	if(_canBounce){
		 // Delay Explosion:
		alarm1 = max(alarm1, temerge_grenade_frame - GameCont.temerge_grenade_frame);
		
		 // Bounce:
		if(speed != 0 && "temerge_sticky_target" not in self){
			friction = 0.4;
			move_bounce_solid(true);
			sound_play_hit(sndGrenadeHitWall, 0.2);
			instance_create(x, y, Dust);
		}
	}
	
	
#define temerge_sticky_setup(_instanceList)
	/*
		Merged projectile sticky effect
	*/
	
	with(instances_matching(_instanceList, "temerge_sticky_target", null)){
		temerge_sticky_target     = noone;
		temerge_sticky_xoffset    = 0;
		temerge_sticky_yoffset    = 0;
		temerge_sticky_mask_index = mskNone;
		
		 // Projectile Events:
		temerge_projectile_add_event(self, "hit",  script_ref_create(temerge_sticky_projectile_stick));
		temerge_projectile_add_event(self, "wall", script_ref_create(temerge_sticky_projectile_stick));
	}
	
#define temerge_sticky_post_step(_instanceList)
	/*
		Merged sticky projectiles follow what they're stuck to around
	*/
	
	var _stickyInstanceList = instances_matching_ne(_instanceList, "temerge_sticky_target", noone);
	
	if(array_length(_stickyInstanceList)){
		with(_stickyInstanceList){
			if(instance_exists(temerge_sticky_target)){
				 // Follow Target:
				x = lerp_ct(x, temerge_sticky_target.x + temerge_sticky_xoffset, 0.5);
				y = lerp_ct(y, temerge_sticky_target.y + temerge_sticky_yoffset, 0.5);
				call(scr.motion_step, self, -1);
				
				 // Thrust:
				if(speed != 0){
					switch(object_index){
						
						case Rocket:
						case Nuke:
						
							if(active && instance_is(temerge_sticky_target, hitme)){
								with(temerge_sticky_target){
									motion_add_ct(other.direction, other.speed / (3 * (max(0, size) + 1)));
								}
							}
							
							break;
							
					}
				}
				
				 // Disable Hitbox:
				if(mask_index != mskNone && object_index != UltraBolt){
					temerge_sticky_mask_index = mask_index;
					mask_index                = mskNone;
				}
			}
			else{
				temerge_sticky_target = noone;
				
				 // Restore Hitbox:
				if(temerge_sticky_mask_index != mskNone){
					mask_index                = temerge_sticky_mask_index;
					temerge_sticky_mask_index = mskNone;
				}
			}
		}
	}
	
#define temerge_sticky_projectile_stick
	/*
		Merged sticky projectiles stick to hittables and walls instead of their normal interaction
	*/
	
	if(!instance_exists(temerge_sticky_target) && visible){
		temerge_sticky_target  = other;
		temerge_sticky_xoffset = x - other.x;
		temerge_sticky_yoffset = y - other.y;
		
		 // Offset Stick Position:
		if(speed != 0){
			repeat(3){
				temerge_sticky_xoffset += hspeed_raw / 3;
				temerge_sticky_yoffset += vspeed_raw / 3;
				if(place_meeting(
					other.x + temerge_sticky_xoffset,
					other.y + temerge_sticky_yoffset,
					other
				)){
					break;
				}
			}
			x = other.x + temerge_sticky_xoffset + hspeed_raw;
			y = other.y + temerge_sticky_yoffset + vspeed_raw;
		}
		if(instance_is(other, hitme)){
			var _offsetScale = 1 - (1 / (1 + max(0, other.size)));
			temerge_sticky_xoffset *= _offsetScale;
			temerge_sticky_yoffset *= _offsetScale;
		}
		
		 // Reduce Speed:
		if(speed > friction * 10){
			speed = max(friction * 10, speed * 0.6);
		}
		
		 // Appear Above or Below:
		depth = other.depth + choose(-1, 1);
		
		 // Sound:
		sound_play_hit(sndGrenadeStickWall, 0.1);
		
		 // Object-Specific:
		switch(object_index){
			
			case Rocket:
			case Nuke:
			
				 // Stop Thrusting:
				if(instance_is(other, Wall) || instance_is(other, prop)){
					active = false;
					alarm1 = -1;
				}
				
				break;
				
			case UltraBolt:
			
				 // Stop Damaging:
				canhurt = false;
				
				break;
				
			case Laser:
			case EnemyLaser:
			
				 // Stop Growing:
				alarm0 = -1;
				
				break;
				
		}
		
		 // Follow Target:
		temerge_sticky_post_step(self);
	}
	
	
#define temerge_flare_step(_instanceList)
	/*
		Merged flare projectiles leave behind a trail of flames
	*/
	
	var	_lastSprite = -1,
		_flameScale = 1;
		
	with(_instanceList){
		if((current_frame % damage) >= 1){
			if(sprite_index != _lastSprite){
				_lastSprite = sprite_index;
				_flameScale = ((sprite_get_bbox_bottom(sprite_index) + 1) - sprite_get_bbox_top(sprite_index)) / 16;
				if(_flameScale >= 0.375 && _flameScale < 1){
					_flameScale = 1;
				}
			}
			for(var _length = 0; _length <= speed_raw; _length += 8 * _flameScale){
				with(instance_create(
					x + lengthdir_x(_length, direction),
					y + lengthdir_y(_length, direction),
					Flame
				)){
					 // Motion:
					motion_add(random(360), 1);
					
					 // Dissipate Faster:
					image_index = max(0, (image_number - 1) - (1 + other.damage));
					
					 // Resize:
					image_xscale *= _flameScale;
					image_yscale *= _flameScale;
					
					 // Setup:
					projectile_init(other.team, other);
					
					 // No Recursion:
					can_temerge = false;
				}
			}
		}
	}
	
	
#define temerge_pull_setup(_instanceList)
	/*
		Merged projectile enemy pulling effect
	*/
	
	with(instances_matching(_instanceList, "temerge_pull_can_play_sound", null)){
		temerge_pull_can_play_sound = true;
	}
	
#define temerge_pull_step(_instanceList)
	/*
		Merged pull projectiles attract nearby enemies towards them
	*/
	
	var _pullInstanceList = instances_matching_ne([enemy, Player, Ally, Sapling, SentryGun, CustomHitme], "team", 0);
	
	if(array_length(_pullInstanceList)){
		var _pullRadius = 96;
		with(_instanceList){
			var	_pullStrength           = power(2, 1 - (speed / 16)) * lerp(damage / 20, 1, 1/15),
				_pullRadiusInstanceList = call(scr.instances_in_rectangle, x - _pullRadius, y - _pullRadius, x + _pullRadius, y + _pullRadius, _pullInstanceList);
				
			if(array_length(_pullRadiusInstanceList)){
				with(_pullRadiusInstanceList){
					if(point_distance(x, y, other.x, other.y) < _pullRadius){
						var	_pullDis = _pullStrength * (instance_is(self, Player) ? 0.5 : 1),
							_pullDir = point_direction(x, y, other.x, other.y),
							_pullX   = x + lengthdir_x(_pullDis, _pullDir),
							_pullY   = y + lengthdir_y(_pullDis, _pullDir);
							
						if(place_free(_pullX, y)) x = _pullX;
						if(place_free(x, _pullY)) y = _pullY;
					}
				}
			}
			
			 // Sound:
			if(temerge_pull_can_play_sound && speed < 4){
				temerge_pull_can_play_sound = false;
				sound_play_hit(sndUltraGrenadeSuck, 0.2);
			}
			
			 // Effects:
			if(chance_ct(_pullStrength, 4)){
				var	_len = random(_pullRadius / 2),
					_dir = random(360);
					
				with(instance_create(x + lengthdir_x(_len, _dir), y + lengthdir_y(_len, _dir), EatRad)){
					motion_add(_dir + 180, random(4));
					hspeed      += other.hspeed / 2;
					vspeed      += other.vspeed / 2;
					image_speed *= random_range(0.5, 1);
					depth        = -8;
					if(chance(1, 4)){
						sprite_index = sprEatBigRad;
					}
				}
			}
		}
	}
	
	
/// MERGED PROJECTILE EFFECTS
#define temerge_HeavyBullet_setup(_instanceList)
	 // Heavy:
	temerge_projectile_add_scale(_instanceList, 0.1);
	
	 // Hits Like a Fist:
	temerge_projectile_scale_damage(_instanceList, 5/3);
	temerge_projectile_add_force(_instanceList, 2);
	
	
#define temerge_UltraBullet_setup(_instanceList)
	 // Big & Bright:
	temerge_projectile_add_scale(_instanceList, 0.2);
	temerge_projectile_add_bloom(_instanceList, 0.2);
	
	 // Hits Like a Brick:
	temerge_projectile_scale_damage(_instanceList, 2.5);
	temerge_projectile_add_force(_instanceList, 4);
	
	
#define temerge_BouncerBullet_wall
	 // Bounce:
	temerge_projectile_wall_bounce();
	
	 // Effects:
	instance_create(x, y, Dust);
	sound_play_hit(sndBouncerBounce, 0.2);
	
	 // Disable Event:
	return true;
	
	
#define temerge_FlameShell_setup(_instanceList)
	 // Releases a Flame:
	temerge_projectile_add_effect(_instanceList, "flame");
	
	
#define temerge_UltraShell_setup(_instanceList)
	 // Long & Bright:
	with(_instanceList){
		if((sprite_get_bbox_bottom(sprite_index) + 1) - sprite_get_bbox_top(sprite_index) <= (sprite_get_bbox_right(sprite_index) + 1) - sprite_get_bbox_left(sprite_index)){
			temerge_projectile_add_scale(self, 0.1, 0);
		}
		else{
			temerge_projectile_add_scale(self, 0, 0.1);
		}
	}
	temerge_projectile_add_bloom(_instanceList, 0.2);
	
	 // Floaty:
	with(instances_matching_gt(_instanceList, "friction", 0)){
		friction *= 2/3;
	}
	
	 // Hits Like a Dart:
	temerge_projectile_scale_damage(_instanceList, 2);
	temerge_projectile_add_force(_instanceList, 2);
	
	
#define temerge_Slug_setup(_instanceList)
	 // Fat:
	temerge_projectile_add_scale(_instanceList, 0.25);
	
	 // Hits Like a Big Fist:
	temerge_projectile_add_effect(_instanceList, "slug", [1]);
	temerge_projectile_add_force(_instanceList, 4);
	
	
#define temerge_HeavySlug_setup(_instanceList)
	 // Obese:
	temerge_projectile_add_scale(_instanceList, 0.4);
	
	 // Hits Like a Truck:
	temerge_projectile_add_effect(_instanceList, "slug", [2]);
	temerge_projectile_add_force(_instanceList, 8);
	
	
#define temerge_HyperSlug_setup(_instanceList)
	 // Hyper:
	temerge_projectile_add_effect(_instanceList, "hyper", [1]);
	
	 // Slug:
	temerge_Slug_setup(_instanceList);
	
	
#define temerge_FlakBullet_destroy
	var _num = abs(damage / 2) + (force >= 3);
	
	 // Nerf Lightning:
	switch(object_index){
		case Lightning:
		case EnemyLightning:
			_num -= ammo;
	}
	
	 // Explode Into Shrapnel:
	_num = min(floor(_num) + chance(frac(_num), 1), 640);
	if(_num > 0){
		repeat(_num){
			call(scr.projectile_create, x, y, Bullet2, random(360), random_range(8, 16));
		}
		
		 // Sound:
		call(scr.sound_play_at,
			x,
			y,
			sndFlakExplode,
			max(0.6, 1.2 - (0.0125 * _num)) + orandom(0.1),
			0.2 + (0.05 * _num),
			320
		);
		
		 // Effects:
		repeat(ceil(_num / 3)){
			call(scr.fx, x, y, random(3), Smoke);
		}
		with(instance_create(x, y, BulletHit)){
			sprite_index = sprFlakHit;
		}
		view_shake_at(x, y, _num / 2);
		sleep(_num / 1.5);
	}
	
	
#define temerge_SuperFlakBullet_setup(_instanceList)
	 // Big:
	temerge_projectile_add_scale(_instanceList, 0.2);
	
#define temerge_SuperFlakBullet_destroy
	var _num = power(max(0, abs(damage) - 1.95), 0.45) + (0.25 * (force >= 3));
	
	 // Nerf Lightning:
	switch(object_index){
		case Lightning:
		case EnemyLightning:
			_num -= ammo * 1.5;
	}
	
	 // Explode Into Flak Shrapnel:
	_num = min(floor(_num) + chance(frac(_num), 1), 40);
	if(_num > 0){
		var _ang = random(360);
		if(position_meeting(x + lengthdir_x(16, _ang), y + lengthdir_y(16, _ang), Wall)){
			_ang += 180;
		}
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
			call(scr.projectile_create, x, y, FlakBullet, _dir, 12);
		}
		
		 // Sound:
		call(scr.sound_play_at,
			x,
			y,
			sndSuperFlakExplode,
			max(0.6, 1.2 - (0.04 * _num)) + orandom(0.1),
			0.2 + (0.16 * _num),
			320
		);
		
		 // Effects:
		repeat(floor(_num * 2.5)){
			call(scr.fx, x, y, random(3), Smoke);
		}
		with(instance_create(x, y, BulletHit)){
			sprite_index = sprSuperFlakHit;
		}
		view_shake_at(x, y, _num * 2.5);
		sleep(_num * 4);
	}
	
	 // Normal Shrapnel:
	else{
		var _addDamage = 2 * (force >= 3);
		damage += _addDamage;
		temerge_FlakBullet_destroy();
		damage -= _addDamage;
	}
	
	
#define temerge_Bolt_fire(_at)
	 // Accurate:
	_at.accuracy *= 0.5;
	
#define temerge_Bolt_setup(_instanceList)
	 // Has a Cool Trail:
	temerge_projectile_add_effect(_instanceList, "trail");
	
#define temerge_Bolt_hit
	if(
		projectile_canhit(other)
		&& other.my_health > 0
		&& ("canhurt" not in self || canhurt) // Bolts
	){
		var _pierceHealth = damage - floor(damage * 0.5);
		
		 // Pierce Weaker Enemies:
		if(other.my_health <= _pierceHealth){
			 // Manual Damage:
			projectile_hit(other, max(damage, _pierceHealth), force);
			
			 // Temporarily Disable Enemy Hitbox:
			with(other){
				if(mask_index != mskNone){
					script_bind_end_step(temerge_Bolt_hit_mask_end_step, 0, self, mask_index);
					mask_index = mskNone;
				}
			}
		}
	}
	
#define temerge_Bolt_hit_mask_end_step(_instance, _mask)
	with(instances_matching(_instance, "mask_index", mskNone)){
		mask_index = _mask;
	}
	instance_destroy();
	
	
#define temerge_HeavyBolt_fire(_at)
	 // Bolt:
	temerge_Bolt_fire(_at);
	
#define temerge_HeavyBolt_setup(_instanceList)
	 // Fat:
	temerge_projectile_add_scale(_instanceList, 0.25);
	
	 // Hits Like a Log:
	temerge_projectile_scale_damage(_instanceList, 2);
	temerge_projectile_add_force(_instanceList, 2);
	
	 // Bolt:
	temerge_Bolt_setup(_instanceList);
	
	
#define temerge_ToxicBolt_fire(_at)
	 // Bolt:
	temerge_Bolt_fire(_at);
	
#define temerge_ToxicBolt_setup(_instanceList)
	 // Toxic:
	temerge_projectile_add_effect(_instanceList, "toxic");
	with(_instanceList){
		image_blend = merge_color(image_blend, make_color_rgb(131, 253, 8), 0.5);
	}
	
	 // Bolt:
	temerge_Bolt_setup(_instanceList);
	
	
#define temerge_UltraBolt_fire(_at)
	 // Bolt:
	temerge_Bolt_fire(_at);
	
#define temerge_UltraBolt_setup(_instanceList)
	 // Brighter:
	temerge_projectile_add_bloom(_instanceList, 0.2);
	
	 // Pierces Walls:
	with(_instanceList){
		if("temerge_pierce_wall_count" not in self){
			temerge_pierce_wall_count = 0;
		}
		temerge_pierce_wall_count += ceil(damage / 6);
	}
	
	 // Bolt:
	temerge_Bolt_setup(_instanceList);
	
#define temerge_UltraBolt_wall
	if(temerge_pierce_wall_count > 0){
		 // Break Wall:
		with(other){
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}
		
		 // Slow Down (Less Weird):
		if(speed > 16){
			speed = 16;
		}
		
		 // Disable Event:
		if(--temerge_pierce_wall_count <= 0){
			return true;
		}
	}
	
	 // Disable Event:
	else return true;
	
	
#define temerge_Splinter_setup(_instanceList)
	 // Small:
	temerge_projectile_add_scale(_instanceList, -0.05);
	
	
#define temerge_Seeker_setup(_instanceList)
	 // Small:
	temerge_projectile_add_scale(_instanceList, -0.05);
	
	 // Has a Cool Trail:
	temerge_projectile_add_effect(_instanceList, "trail");
	
	 // Seeks Enemies:
	temerge_projectile_add_effect(_instanceList, "seek");
	
	
#define temerge_Disc_setup(_instanceList)
	with(_instanceList){
		 // Setup Variables:
		if("temerge_disc_wall_bounce_frame" not in self){
			temerge_disc_wall_bounce_frame = current_frame;
			temerge_disc_friction          = 0;
			temerge_disc_is_ally           = true;
		}
		
		 // Bounces:
		temerge_disc_wall_bounce_frame = max(current_frame, temerge_disc_wall_bounce_frame) + 30;
		
		 // No Friction:
		if(friction != 0){
			temerge_disc_friction = friction;
			if(speed > friction * 10){
				speed = max(friction * 10, speed - (3 * friction));
			}
			friction = 0;
		}
	}
	
#define temerge_Disc_wall
	 // Become Hostile:
	if(
		temerge_disc_is_ally
		&& (
			!instance_exists(creator)
			|| distance_to_object(creator) > 16
			|| point_distance(xstart, ystart, creator.x, creator.y) > 16
		)
	){
		temerge_disc_is_ally = false;
		team = -1;
		
		 // Resprite:
		var _hitName = call(scr.instance_get_name, self);
		call(scr.team_instance_sprite, 1, self);
		if(hitid == -1){
			hitid = [((sprite_index == sprEnemyLaser) ? sprEnemyLaserStart : sprite_index), _hitName];
		}
	}
	
	 // Bounce:
	if(temerge_disc_wall_bounce_frame > current_frame){
		var _isLaser = (object_index == Laser || object_index == EnemyLaser);
		
		 // Hitscan Projectiles Bounce Once:
		if(_isLaser || instance_is(self, HyperGrenade)){
			temerge_disc_wall_bounce_frame -= 30;
		}
		
		 // Bounce:
		temerge_projectile_wall_bounce();
		
		 // Lasers Bounce Once:
		if(_isLaser){
			temerge_disc_wall_bounce_frame = current_frame;
		}
		
		 // Effects:
		sound_play_hit(sndDiscBounce, 0.2);
		with(instance_create(x, y, DiscBounce)){
			image_angle = other.image_angle;
		}
	}
	
	 // Done:
	else{
		 // Restore Friction:
		if(temerge_disc_friction != 0){
			if(friction == 0){
				friction = temerge_disc_friction;
			}
			temerge_disc_friction = 0;
		}
		
		 // Effects:
		sound_play_hit(sndDiscDie, 0.2);
		instance_create(x, y, DiscDisappear);
		
		 // Disable Event:
		return false;
	}
	
	
#define temerge_Grenade_fire(_at, _setupInfo)
	var	_moveSpeed    = speed,
		_moveFriction = friction,
		_moveSteps    = floor(_moveSpeed / _moveFriction),
		_moveDistance = 0,
		_explodeSteps = alarm0,
		_airSteps     = alarm1;
		
	 // Determine Travel Distance:
	if(_explodeSteps > 0 && _explodeSteps < _moveSteps){
		_moveSteps = _explodeSteps;
	}
	if(_airSteps > 0 && _airSteps < _moveSteps){
		_moveDistance += _airSteps * (_moveSpeed - (_moveFriction * ((_airSteps + 1) / 2)));
		_moveSpeed    -= _moveFriction * _airSteps;
		_moveFriction  = (instance_is(self, BloodGrenade) ? 0.5 : 0.4);
		_moveSteps     = floor(_moveSpeed / _moveFriction);
		if(_explodeSteps > 0 && _explodeSteps < _moveSteps){
			_moveSteps = _explodeSteps;
		}
	}
	_moveDistance += _moveSteps * (_moveSpeed - (_moveFriction * ((floor(_moveSpeed / _moveFriction) + 1) / 2)));
	
	 // Store Explosion Info:
	_setupInfo.max_range = _moveDistance;
	_setupInfo.is_sticky = sticky;
	_setupInfo.is_ultra  = instance_is(self, UltraGrenade);
	_setupInfo.explosion = {
		"is_small"   : instance_is(self, MiniNade),
		"is_heavy"   : (_setupInfo.is_ultra || instance_is(self, HeavyNade)),
		"is_blood"   : instance_is(self, BloodGrenade),
		"is_toxic"   : instance_is(self, ToxicGrenade),
		"is_cluster" : instance_is(self, ClusterNade)
	};
	
#define temerge_Grenade_setup(_instanceList, _info)
	var _explosion = _info.explosion;
	
	 // Explosion on a Timer:
	temerge_projectile_add_effect(_instanceList, "grenade", [_info.max_range, _explosion]);
	
	 // Small:
	if(_explosion.is_small){
		temerge_projectile_add_scale(_instanceList, -0.05);
	}
	
	 // Big:
	if(_explosion.is_heavy){
		temerge_projectile_add_scale(_instanceList, 0.1);
	}
	
	 // Bloody:
	if(_explosion.is_blood){
		with(_instanceList){
			if(!place_meeting(x, y, BloodStreak) || chance(1, 3)){
				with(instance_create(xstart + hspeed, ystart + vspeed, BloodStreak)){
					image_angle = other.direction;
				}
			}
		}
	}
	
	 // Sticky:
	if(_info.is_sticky){
		temerge_projectile_add_effect(_instanceList, "sticky");
		
		 // Longer Delay, Bigger Explosion:
		with(_instanceList){
			repeat(2){
				temerge_projectile_add_effect(self, "grenade", [
					_info.max_range + (30 * speed),
					(_explosion.is_toxic ? undefined : _explosion)
				]);
			}
			
			 // Green:
			image_blend = merge_color(image_blend, make_color_rgb(131, 253, 8), 0.5);
		}
	}
	
	 // Ultra:
	if(_info.is_ultra){
		temerge_projectile_add_effect(_instanceList, "pull");
		
		 // Brighter:
		temerge_projectile_add_bloom(_instanceList, 0.2);
		
		 // Longer Delay:
		with(_instanceList){
			temerge_projectile_add_effect(self, "grenade", [_info.max_range + (10 * speed)]);
		}
	}
	
	
#define temerge_HyperGrenade_fire(_at)
	 // No Speed Multiplier:
	if(alarm0 > 0){
		_at.speed_factor = 1;
	}
	
#define temerge_HyperGrenade_setup(_instanceList)
	 // Hyper:
	temerge_projectile_add_effect(_instanceList, "hyper", [1]);
	
	 // Grenade:
	temerge_projectile_add_effect(_instanceList, "grenade", [160]);
	
	
#define temerge_Flare_setup(_instanceList)
	 // Emits Flames:
	temerge_projectile_add_effect(_instanceList, "flare");
	
	
/// OBJECTS
#define HyperSlashTrail_create(_x, _y)
	/*
		A stretched slash trail that follows a slash or shank around and passes collision to its events
	*/
	
	with(instance_create(_x, _y, CustomSlash)){
		 // Vars:
		target      = other;
		sprite_side = 0;
		
		 // Events:
		on_hit        = script_ref_create(HyperSlashTrail_collision, hitme);
		on_wall       = script_ref_create(HyperSlashTrail_collision, Wall);
		on_projectile = script_ref_create(HyperSlashTrail_collision, projectile);
		on_grenade    = script_ref_create(HyperSlashTrail_collision, Grenade);
		
		return self;
	}
	
#define HyperSlashTrail_begin_step
	 // Shrink Towards Target:
	if(image_index > image_speed || image_speed <= 0){
		if(instance_exists(target)){
			var	_targetX     = target.x,
				_targetY     = target.y,
				_targetAngle = target.image_angle;
				
			 // Try to Shrink Along Target's Axis:
			if(_targetAngle != 0){
				var	_dir = _targetAngle + 180,
					_len = 0.5 * (lengthdir_x(xstart - _targetX, _dir) + lengthdir_y(ystart - _targetY, _dir));
					
				_targetX += lengthdir_x(_len, _dir);
				_targetY += lengthdir_y(_len, _dir);
			}
			
			 // Effects:
			if(chance_ct(1, 2)){
				call(scr.fx, [_targetX, 4], [_targetY, 4], [_targetAngle + orandom(15), 4], Dust);
			}
			
			 // Shrink:
			xstart = lerp_ct(xstart, _targetX, 2/3);
			ystart = lerp_ct(ystart, _targetY, 2/3);
			
			 // Shrunk:
			if(point_distance(xstart, ystart, target.x, target.y) < 1){
				instance_destroy();
			}
		}
	}
	
#define HyperSlashTrail_step
	if(instance_exists(target)){
		var	_target         = target,
			_spriteIndex    = _target.sprite_index,
			_spriteCutWidth = 0,
			_maskIndex      = _target.mask_index;
			
		 // Uses Sprite as Mask:
		if(_maskIndex < 0){
			_maskIndex = _spriteIndex;
		}
		
		 // Follow Target:
		x                 = _target.x;
		y                 = _target.y;
		hspeed            = _target.hspeed;
		vspeed            = _target.vspeed;
		friction          = _target.friction;
		gravity           = _target.gravity;
		gravity_direction = _target.gravity_direction;
		image_index       = _target.image_index;
		image_speed       = _target.image_speed;
		image_xscale      = _target.image_xscale;
		image_yscale      = _target.image_yscale;
		image_angle       = point_direction(xstart, ystart, x, y);
		image_blend       = _target.image_blend;
		image_alpha       = _target.image_alpha;
		visible           = _target.visible;
		depth             = _target.depth - 1;
		deflected         = _target.deflected;
		damage            = _target.damage;
		force             = _target.force;
		hitid             = _target.hitid;
		typ               = _target.typ;
		team              = _target.team;
		creator           = _target.creator;
		
		 // Sprite Setup:
		if(sprite_exists(_spriteIndex)){
			var _spriteKey = `${_spriteIndex}:${sprite_side}`;
			if(ds_map_exists(global.hyper_slash_trail_sprite_map, _spriteKey)){
				sprite_index = global.hyper_slash_trail_sprite_map[? _spriteKey];
			}
			else{
				_spriteCutWidth = ceil(lerp(sprite_get_bbox_left(_spriteIndex), sprite_get_bbox_right(_spriteIndex) + 1, 0.5));
				
				var	_spriteImageNumber = sprite_get_number(_spriteIndex),
					_spriteBBoxTop     = sprite_get_bbox_top(_spriteIndex),
					_spriteBBoxHeight  = (sprite_get_bbox_bottom(_spriteIndex) + 1) - _spriteBBoxTop,
					_spriteBBoxCenterY = _spriteBBoxTop + (_spriteBBoxHeight / 2),
					_spriteCutY        = ((sprite_side < 0) ? floor(_spriteBBoxCenterY) : 0),
					_spriteCutHeight   = ((sprite_side > 0) ?  ceil(_spriteBBoxCenterY) : sprite_get_height(_spriteIndex)) - _spriteCutY,
					_spriteSurface     = surface_create(max(1, _spriteCutWidth * _spriteImageNumber), _spriteCutHeight);
					
				 // Draw Sprite:
				surface_set_target(_spriteSurface);
				draw_clear_alpha(c_black, 0);
				for(var _spriteImage = 0; _spriteImage < _spriteImageNumber; _spriteImage++){
					draw_sprite_part(
						_spriteIndex,
						_spriteImage,
						0,
						_spriteCutY,
						_spriteCutWidth,
						_spriteCutHeight,
						_spriteCutWidth * _spriteImage,
						0
					);
				}
				surface_reset_target();
				
				 // Add Sprite:
				surface_save(_spriteSurface, "sprHyperSlashTrail.png");
				surface_destroy(_spriteSurface);
				sprite_index = sprite_add(
					"sprHyperSlashTrail.png",
					_spriteImageNumber,
					_spriteCutWidth,
					sprite_get_yoffset(_spriteIndex) - _spriteCutY
				);
				global.hyper_slash_trail_sprite_map[? _spriteKey] = sprite_index;
			}
		}
		
		 // Mask Setup:
		if(sprite_exists(_maskIndex)){
			if(ds_map_exists(global.hyper_slash_trail_mask_map, _maskIndex)){
				mask_index = global.hyper_slash_trail_mask_map[? _maskIndex];
			}
			else{
				var	_maskHeight        = sprite_get_height(_maskIndex),
					_maskImageNumber   = sprite_get_number(_maskIndex),
					_maskSpriteXOffset = sprite_get_xoffset(_maskIndex) - sprite_get_xoffset(_spriteIndex),
					_maskCutX          = sprite_get_bbox_left(_spriteIndex) + _maskSpriteXOffset,
					_maskCutWidth      = (_spriteCutWidth + _maskSpriteXOffset) - _maskCutX,
					_maskSurface       = surface_create(max(1, _maskCutWidth * _maskImageNumber), _maskHeight);
					
				 // Draw Mask:
				surface_set_target(_maskSurface);
				draw_clear_alpha(c_black, 0);
				for(var _maskImage = 0; _maskImage < _maskImageNumber; _maskImage++){
					draw_sprite_part(
						_maskIndex,
						_maskImage,
						max(0, _maskCutX),
						0,
						max(0, _maskCutWidth + min(0, _maskCutX)),
						_maskHeight,
						_maskCutWidth * _maskImage,
						0
					);
				}
				surface_reset_target();
				
				 // Add Mask:
				surface_save(_maskSurface, "mskHyperSlashTrail.png");
				surface_destroy(_maskSurface);
				mask_index = sprite_add(
					"mskHyperSlashTrail.png",
					_maskImageNumber,
					_maskCutWidth,
					sprite_get_yoffset(_maskIndex)
				);
				global.hyper_slash_trail_mask_map[? _maskIndex] = mask_index;
			}
		}
		
		 // Stretch Backwards:
		var	_offsetLen   = (sprite_get_xoffset(sprite_index) - sprite_get_xoffset(_spriteIndex)) * image_xscale,
			_offsetDir   = _target.image_angle,
			_spriteWidth = sprite_get_width(sprite_index);
			
		image_xscale += (point_distance(x, y, xstart, ystart) * (1 + (sprite_get_bbox_left(sprite_index) / _spriteWidth))) / _spriteWidth;
		x            += lengthdir_x(_offsetLen, _offsetDir);
		y            += lengthdir_y(_offsetLen, _offsetDir);
		xprevious     = x;
		yprevious     = y;
	}
	else instance_destroy();
	
#define HyperSlashTrail_collision(_collisionObject)
	if(instance_exists(self) && instance_exists(target)){
		var	_dir = image_angle,
			_len = clamp(lengthdir_x(other.x - xstart, _dir) + lengthdir_y(other.y - ystart, _dir), 0, point_distance(xstart, ystart, target.x, target.y)),
			_x   = xstart + lengthdir_x(_len, _dir),
			_y   = ystart + lengthdir_y(_len, _dir);
			
		with(other){
			with(other.target){
				var	_lastX         = x,
					_lastY         = y,
					_lastXPrevious = x,
					_lastYPrevious = y;
					
				xprevious += _x - x;
				yprevious += _y - y;
				x          = _x;
				y          = _y;
				
				event_perform(ev_collision, _collisionObject);
				
				if(instance_exists(self)){
					x         = _lastX;
					y         = _lastY;
					xprevious = _lastXPrevious;
					yprevious = _lastYPrevious;
				}
			}
		}
		
		 // Update:
		if(instance_exists(self)){
			HyperSlashTrail_step();
		}
	}
	
	
/// GENERAL
#define ntte_step
	 // Unmuffle Muffled Sounds:
	with(ds_map_keys(global.sound_muffle_map)){
		var	_sound  = self,
			_muffle = global.sound_muffle_map[? _sound];
			
		if(audio_is_playing(_sound)){
			if(!audio_is_playing(_muffle.sound_id)){
				var	_muffleSoundGain = _muffle.sound_gain,
					_soundGain       = lerp(audio_sound_get_gain(_sound), _muffleSoundGain, 0.1);
					
				if(abs(1 - (_soundGain / _muffleSoundGain)) > 0.1){
					audio_sound_gain(_sound, _soundGain, 0);
				}
				else{
					audio_sound_gain(_sound, _muffleSoundGain, 0);
					ds_map_delete(global.sound_muffle_map, _sound);
				}
			}
		}
		else{
			audio_sound_gain(_sound, _muffle.sound_gain, 0);
			ds_map_delete(global.sound_muffle_map, _sound);
		}
	}
	
	 // Run Newly Created Effect Step Events:
	if("temerge_effect_call_step_frame" in GameCont && GameCont.temerge_effect_call_step_frame == current_frame){
		with(instances_matching_ne(GameCont.temerge_effect_call_step_instance_list, "id")){
			event_perform(ev_step, ev_step_normal);
		}
		GameCont.temerge_effect_call_step_instance_list = [];
	}
	
#define CustomProjectile_hit
	/*
		Default CustomProjectile hitme collision
	*/
	
	if(projectile_canhit(other)){
		projectile_hit(other, damage, force);
		instance_destroy();
	}
	
#define CustomProjectile_wall
	/*
		Default CustomProjectile wall collision
	*/
	
	instance_destroy();
	
	
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