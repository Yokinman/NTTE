#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Setup Objects:
	call(scr.obj_add, script_ref_create(HyperSlashTrail_create));
	
	 // Store Script References:
	with([temerge_create_weapon, temerge_set_weapon_event]){
		lq_set(scr, script_get_name(self), script_ref_create(self));
	}
	
	 // Bind Events:
	script_bind(CustomDraw, temerge_projectile_scale_draw, 0, true);
	
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
	
#macro _wepXhas_merge            (is_object(_wep) && "temerge" in _wep && _wepXmerge != undefined)
#macro _wepXmerge                _wep.temerge
#macro _wepXmerge_wep_raw        _wepXmerge.wep
#macro _wepXmerge_wep            _wepXmerge_wep_raw[@ 0]
#macro _wepXmerge_fire_at        _wepXmerge.fire_at_vars
#macro _wepXmerge_fire_frame     _wepXmerge.fire_frame
#macro _wepXmerge_wep_fire_frame _wepXmerge.wep_fire_frame
#macro _wepXmerge_is_part        _wepXmerge.is_part

#define temerge_instance_list_add_instance(_instanceListObject, _instanceListName, _instance)
	/*
		Adds the given instance to the given list of merged instances and returns whether it was already in the list
		Future duplicates of the instance created by 'instance_copy' are automatically added to the list
	*/
	
	var	_instanceListObjectName = object_get_name(_instanceListObject),
		_instanceVarName        = `temerge_${_instanceListObjectName}_${_instanceListName}_instance`,
		_instanceListVarName    = `${_instanceVarName}_list`,
		_instanceList           = variable_instance_get(GameCont, _instanceListVarName);;
		
	 // Setup Instance List:
	if(_instanceListVarName not in GameCont){
		_instanceList = [];
		variable_instance_set(GameCont, _instanceListVarName, _instanceList);
	}
	
	 // Bind 'instance_copy' Instance Capturing Script:
	var _instanceListObjectSetupBindVarName = `bind_setup_temerge_${_instanceListObjectName}`;
	if(is_undefined(lq_get(ntte, _instanceListObjectSetupBindVarName))){
		lq_set(
			ntte,
			_instanceListObjectSetupBindVarName,
			call(scr.ntte_bind_setup, script_ref_create(ntte_setup_temerge_instance_list_object, _instanceListObject, _instanceListName), _instanceListObject)
		);
	}
	
	 // Add to Instance List:
	if(array_find_index(_instanceList, _instance) < 0){
		array_push(_instanceList, _instance);
		variable_instance_set(_instance, _instanceVarName, _instance);
		return true;
	}
	
	return false;
	
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
		_wepXmerge                = {};
		_wepXmerge_wep_raw        = [wep_none];
		_wepXmerge_fire_at        = undefined;
		_wepXmerge_fire_frame     = 0;
		_wepXmerge_wep_fire_frame = 0;
		_wepXmerge_is_part        = (_wepIsPart || call(scr.wep_raw, _wep) == wep_none);
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
			var _lastWepMerge = _wepXmerge;
			_wepXmerge = undefined;
			
			var	_stockName = weapon_get_name(_wep),
				_stockType = weapon_get_type(_wep);
				
			_wepXmerge = _lastWepMerge;
			
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
			var _lastWepMerge = _wepXmerge;
			_wepXmerge = undefined;
			_stockSprite = weapon_get_sprt_hud(_wep);
			_wepXmerge = _lastWepMerge;
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
			var _lastWepMerge = _wepXmerge;
			_wepXmerge = undefined;
			_stockHUDSprite = weapon_get_sprt(_wep);
			_wepXmerge = _lastWepMerge;
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
		
		return weapon_get_type(_wepXmerge_wep);
	}
	
	return _stockType;
	
#define temerge_weapon_cost(_wep, _stockCost)
	/*
		Merged weapons use their front weapon's ammo cost:
		1. Multiplied by the reduced ammo cost of their stock weapon(s)
		2. Clamped at max capacity for fun (Back Muscle)
	*/
	
	if(_wepXhas_merge){
		if(_wepXmerge_is_part){
			return 0;
		}
		
		var _frontCost = weapon_get_cost(_wepXmerge_wep);
		
		if(_stockCost != 0 && _frontCost != 0){
			var _mergeCost = _frontCost;
			
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
			
			return _mergeCost;
		}
		
		return _frontCost;
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
		
		var _frontRads = weapon_get_rads(_wepXmerge_wep);
		
		if(_stockRads != 0 || _frontRads != 0){
			var _mergeRads = _frontRads;
			
			 // Integrate Stock Ammo Cost:
			if(_mergeRads != 0){
				var _lastWepMerge = _wepXmerge;
				_wepXmerge = undefined;
				var _stockCost = abs(weapon_get_cost(_wep));
				if(_stockCost != 0 && _stockCost != 1){
					_mergeRads += round(_mergeRads * (power(_stockCost, 0.795) - 1));
				}
				_wepXmerge = _lastWepMerge;
			}
			
			 // Integrate Stock Rad Cost:
			if(_stockRads != 0){
				var _frontCost = weapon_get_cost(_wepXmerge_wep);
				_mergeRads += _stockRads + round((_stockRads / 2) * (((_frontCost == 0) ? 1 : abs(_frontCost)) - 2));
			}
			
			 // Clamp at Max Rads:
			if(_mergeRads > 1200 && _stockRads <= 1200 && _frontRads <= 1200){
				_mergeRads = 1200;
			}
			
			return _mergeRads;
		}
		
		return _frontRads;
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
			var _lastWepMerge = _wepXmerge;
			_wepXmerge = undefined;
			_mergeLoad += 2 * max(0, abs(weapon_get_cost(_wep)) - 1);
			_wepXmerge = _lastWepMerge;
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
			for(var _inst = instance_max - 1; _inst >= _minID; _inst--){
				if("object_index" in _inst){
					var _instObject = _inst.object_index;
					if(ds_map_exists(global.obj_event_varname_list_map, _instObject)){
						with(global.obj_event_varname_list_map[? _instObject]){
							var _instEventRef = variable_instance_get(_inst, self);
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
								variable_instance_set(_inst, self, _instEventWrapRef);
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
			with(_at){
				x                  = _fireAt.x;
				y                  = _fireAt.y;
				position_distance  = _fireAt.position_distance;
				position_direction = _fireAt.position_direction;
				position_rotation  = _fireAt.position_rotation;
				direction          = _fireAt.direction;
				direction_rotation = _fireAt.direction_rotation;
				accuracy           = _fireAt.accuracy;
				wep                = _fireAt.wep;
				team               = _fireAt.team;
				creator            = _fireAt.creator;
			}
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
	
	 // Store Initial Shot Values:
	if("shot_vars" not in _merge){
		var _costInterval = 1;
		
		 // Determine Interval for Dynamic Ammo/Rad Cost:
		if(_wepXhas_merge){
			var _lastWep = _wep;
			while(_wepXhas_merge){
				var _lastWepMerge = _wepXmerge;
				_wepXmerge = undefined;
				
				var _wepCost = weapon_get_cost(_wep);
				if(_wepCost != 0){
					_costInterval *= abs(_wepCost);
				}
				
				_wepXmerge = _lastWepMerge;
				
				_wep = _wepXmerge_wep;
			}
			_wep = _lastWep;
		}
		
		 // Store Values:
		_merge.shot_vars = {
			"ammo_type"     : weapon_get_type(_wep),
			"ammo_cost"     : weapon_get_cost(_wep),
			"rads_cost"     : weapon_get_rads(_wep),
			"cost_index"    : 0,
			"cost_interval" : _costInterval,
			"can_replace"   : true
		};
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
		"set_reload"   : weapon_get_load(_wep),
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
		_merge.main_fire_vars = _fire;
		
		 // Return Ammo Cost:
		if(infammo == 0){
			var _mergeShot = _merge.shot_vars;
			if(instance_is(self, Player)){
				ammo[_mergeShot.ammo_type] += _mergeShot.ammo_cost;
			}
			GameCont.rad += _mergeShot.rads_cost;
			
			 // Update Stored Values:
			_fire.ammo = array_clone(ammo);
			_fire.rads = GameCont.rad;
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
	
	 // Temporary Values:
	wkick  = 0;
	reload = _fire.set_reload;
	
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
		
		 // Revert Reload:
		if(reload == _fire.set_reload){
			reload = _fire.reload;
		}
		
		 // Revert Options:
		UberCont.opt_shake  = _fire.opt_shake;
		UberCont.opt_freeze = _fire.opt_freeze;
	}
	
#define temerge_projectile_setup(_inst, _wep, _isMain, _mainX, _mainY, _mainDirection, _mainAccuracy, _mainTeam, _mainCreator)
	/*
		Merged weapons replace the projectiles fired by their stock weapon(s) with shots from their front weapon(s) and apply effects to the final projectiles
	*/
	
	if(array_length(_inst)){
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
			var	_sortInst    = [],
				_sortNum     = 0,
				_lastInstDis = 0;
				
			with(_inst){
				var _dis = point_distance(_originX, _originY, xstart, ystart);
				if(abs(_dis - _lastInstDis) > 8){
					_lastInstDis = _dis;
					_sortNum++;
				}
				array_push(_sortInst, [self, _sortNum + random(1)]);
			}
			array_sort_sub(_sortInst, 1, true);
			for(var i = array_length(_sortInst) - 1; i >= 0; i--){
				_sortInst[i] = _sortInst[i][0];
			}
			
			 // Replace Projectiles w/ Firing:
			var	_mainMergeShot      = (("shot_vars" in _mainMerge) ? _mainMerge.shot_vars : undefined),
				_rawWep             = undefined,
				_wepSprite          = undefined,
				_stockSprite        = undefined,
				_instWasIndependent = false;
				
			with(_sortInst){
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
									var _lastWepMerge = _wepXmerge;
									_wepXmerge = undefined;
									_stockSprite = weapon_get_sprt(_wep);
									_wepXmerge = _lastWepMerge;
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
					if(_mainMergeShot != undefined && _mainMergeShot.can_replace){
						var	_merge = {
								"on_setup"     : (("temerge_on_setup"     in self) ? temerge_on_setup     : undefined),
								"on_hit"       : (("temerge_on_hit"       in self) ? temerge_on_hit       : undefined),
								"on_wall"      : (("temerge_on_wall"      in self) ? temerge_on_wall      : undefined),
								"on_destroy"   : (("temerge_on_destroy"   in self) ? temerge_on_destroy   : undefined),
								"speed_factor" : (("temerge_speed_factor" in self) ? temerge_speed_factor : undefined)
							},
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
							},
							_scrPrefix = "temerge_" + object_get_name(
								("temerge_object" in self && temerge_object != undefined)
								? temerge_object
								: object_index
							);
							
						 // Is Independent From the Creator:
						if(_instWasIndependent || round(_fireAt.position_distance) > 16){
							_instWasIndependent = true;
							_fireAt.x           = _originX;
							_fireAt.y           = _originY;
							_fireAt.direction   = _originDirection;
						}
						
						 // Call Merged Projectile Fire Event:
						switch(("temerge_on_fire" in self) ? temerge_on_fire : undefined){
							case undefined:
								var _scrIndex = script_get_index(`${_scrPrefix}_fire`);
								if(_scrIndex >= 0){
									call(scr.pass, [_fireAt.creator, self], script_ref_create(_scrIndex), _fireAt);
								}
								break;
								
							default:
								call(scr.pass, [_fireAt.creator, self], temerge_on_fire, _fireAt);
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
									var	_costIndex    = _mainMergeShot.cost_index,
										_costInterval = _mainMergeShot.cost_interval;
										
									if(_costIndex >= _costInterval){
										_costIndex = (_costIndex + 1) % _costInterval;
									}
									
									if(_costIndex < 1 && instance_is(self, Player) && infammo == 0){
										if(
											ammo[_mainMergeShot.ammo_type] >= _mainMergeShot.ammo_cost &&
											GameCont.rad                   >= _mainMergeShot.rads_cost
										){
											ammo[_mainMergeShot.ammo_type] -= _mainMergeShot.ammo_cost;
											GameCont.rad                   -= _mainMergeShot.rads_cost;
										}
										else{
											_mainMergeShot.can_replace = false;
											break;
										}
									}
									
									_mainMergeShot.cost_index++;
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
								
								 // Setup Merged Projectile Scripts:
								switch(_merge.on_setup  ){ case undefined: var _scrIndex = script_get_index(`${_scrPrefix}_setup`);    if(_scrIndex >= 0) _merge.on_setup   = script_ref_create(_scrIndex); }
								switch(_merge.on_hit    ){ case undefined: var _scrIndex = script_get_index(`${_scrPrefix}_hit`);      if(_scrIndex >= 0) _merge.on_hit     = script_ref_create(_scrIndex); }
								switch(_merge.on_wall   ){ case undefined: var _scrIndex = script_get_index(`${_scrPrefix}_wall`);     if(_scrIndex >= 0) _merge.on_wall    = script_ref_create(_scrIndex); }
								switch(_merge.on_destroy){ case undefined: var _scrIndex = script_get_index(`${_scrPrefix}_destroy`);  if(_scrIndex >= 0) _merge.on_destroy = script_ref_create(_scrIndex); }
								
								 // Store Variable Container:
								_merge.speed_factor = _fireAt.speed_factor;
								if("main_fire_vars" in _mainMerge) _merge.main_fire_vars = _mainMerge.main_fire_vars;
								if("shot_vars"      in _mainMerge) _merge.shot_vars      = _mainMerge.shot_vars;
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
									_mainMergeShot.can_replace = false;
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
			with(_inst){
				if("temerge_vars_list" not in self){
					temerge_vars_list = [];
				}
				if(array_find_index(temerge_vars_list, _mainMerge) < 0){
					array_push(temerge_vars_list, _mainMerge);
					
					 // Speed Multiplier:
					var _speedFactor = _mainMerge.speed_factor;
					if(_speedFactor != 1){
						 // Manual Fixes:
						if(speed != 0){
							if(instance_is(self, PlasmaBall) || instance_is(self, PlasmaBig) || instance_is(self, PlasmaHuge)){
								temerge_instance_list_add_instance(object_index, "fix_speed_factor", self);
							}
							else if(instance_is(self, Rocket)){
								if(_speedFactor > 1){
									if(active || alarm1 > 0){
										active = false;
										alarm1 = max(alarm1, 0) + 1;
										speed  = max(speed, 12);
									}
								}
								else{
									temerge_instance_list_add_instance(Rocket, "fix_speed_factor", self);
								}
							}
							else if(instance_is(self, Nuke)){
								if(_speedFactor > 1){
									if(active || alarm1 > 0){
										active = false;
										alarm1 = max(alarm1, 0) + 1;
										speed  = max(speed, 5);
									}
								}
								else{
									temerge_instance_list_add_instance(Nuke, "fix_speed_factor", self);
								}
							}
							else if(instance_is(self, Seeker)){
								temerge_instance_list_add_instance(Seeker, "fix_speed_factor", self);
							}
						}
						if("temerge_fix_speed_factor" not in self){
							temerge_fix_speed_factor = 1;
						}
						temerge_fix_speed_factor *= _speedFactor;
						
						 // Clamp Speed:
						image_angle -= direction;
						var _maxSpeed = 16 + bbox_width;
						image_angle += direction;
						if(speed < _maxSpeed){
							speed = min(speed * _speedFactor, _maxSpeed);
						}
					}
					
					 // Setup Events:
					if(_mainMerge.on_hit     != undefined) temerge_projectile_add_event("hit",     _mainMerge.on_hit);
					if(_mainMerge.on_wall    != undefined) temerge_projectile_add_event("wall",    _mainMerge.on_wall);
					if(_mainMerge.on_destroy != undefined) temerge_projectile_add_event("destroy", _mainMerge.on_destroy);
				}
				
				 // Remove From List:
				else _inst = instances_matching_ne(_inst, "id", id);
			}
			
			 // Call Setup Event:
			if(_mainMerge.on_setup != undefined){
				script_ref_call(_mainMerge.on_setup, _inst);
			}
		}
	}
	
#define temerge_projectile_add_event(_eventName, _eventRef)
	/*
		Adds the given event to the calling merged projectile instance
	*/
	
	var	_eventRefListVarName = `temerge_${_eventName}_ref_list`,
		_eventRefList        = variable_instance_get(self, _eventRefListVarName);
		
	 // Setup Event Script Reference List:
	if(_eventRefList == undefined || !array_length(_eventRefList)){
		_eventRefList = [];
		variable_instance_set(self, _eventRefListVarName, _eventRefList);
		
		 // Custom Object (Wrap Existing Event):
		var _eventRefVarName = `on_${_eventName}`;
		if(
			ds_map_exists(global.obj_event_varname_list_map, object_index)
			&& array_find_index(global.obj_event_varname_list_map[? object_index], _eventRefVarName) >= 0
		){
			var _lastEventRef = variable_instance_get(self, _eventRefVarName);
			if(_lastEventRef == undefined){
				var _defaultScriptIndex = script_get_index(`CustomProjectile_${_eventName}`);
				_lastEventRef = ((_defaultScriptIndex < 0) ? [] : script_ref_create(_defaultScriptIndex));
			}
			variable_instance_set(self, _eventRefVarName, script_ref_create(temerge_projectile_call_event, _eventName, _lastEventRef));
		}
		
		 // Non-Custom Object:
		else if(temerge_instance_list_add_instance(projectile, _eventName, self)){
			switch(_eventName){
				
				case "destroy":
				
					var	_destroyInstanceList  = GameCont.temerge_projectile_destroy_instance_list,
						_destroyInstanceCount = array_length(_destroyInstanceList);
						
					 // Setup Instance Variables List:
					if("temerge_projectile_destroy_instance_vars_list" not in GameCont){
						GameCont.temerge_projectile_destroy_instance_vars_list = [];
					}
					
					 // Store Instance Variables:
					for(var _destroyInstanceIndex = array_length(GameCont.temerge_projectile_destroy_instance_vars_list); _destroyInstanceIndex < _destroyInstanceCount; _destroyInstanceIndex++){
						with(_destroyInstanceList[_destroyInstanceIndex]){
							temerge_destroy_vars = call(scr.variable_instance_get_list, self);
							GameCont.temerge_projectile_destroy_instance_vars_list[_destroyInstanceIndex] = temerge_destroy_vars;
						}
					}
					
					break;
					
			}
		}
	}
	
	 // Store Event Script Reference:
	array_push(_eventRefList, _eventRef);
	
#define temerge_projectile_call_event(_eventName, _eventRef)
	/*
		Used as a wrapper script for merged projectile events
	*/
	
	var	_isSolid             = false,
		_isMeeting           = false,
		_context             = [self, other],
		_eventRefVarName     = `on_${_eventName}`,
		_eventRefListVarName = `temerge_${_eventName}_ref_list`,
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
		
			 // Untag Team:
			var _lastTeam = team;
			team = round(team);
			
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
		
			 // Revert Team:
			if(team == round(_lastTeam)){
				team = _lastTeam;
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
	
#define temerge_projectile_wall_bounce()
	/*
		Called from a merged projectile in its wall collision event to make it bounce
	*/
	
	 // Laser Bounce:
	if(instance_is(self, Laser) || instance_is(self, EnemyLaser)){
		with(instance_copy(false)){
			var	_addX = lengthdir_x(2, image_angle),
				_addY = lengthdir_y(2, image_angle);
				
			 // Update Starting Position:
			x           -= _addX;
			y           -= _addY;
			xstart       = x;
			ystart       = y;
			xprevious    = x;
			yprevious    = y;
			image_xscale = 1;
			
			 // Bounce Direction:
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
	}
	
	 // Bounce:
	else if(speed != 0){
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
	
#define temerge_projectile_set_scale // setXScale, setYScale=setXScale
	/*
		Sets the calling merged projectile's scale, with manual visual fixes for certain projectiles
		
		Args:
			setXScale - The number to set to the instance's image_xscale
			setYScale - The number to set to the instance's image_yscale, defaults to setXScale
	*/
	
	var	_setXScale = argument[0],
		_setYScale = ((argument_count > 1) ? argument[1] : _setXScale);
		
	image_xscale = _setXScale;
	image_yscale = _setYScale;
	
	 // Manual Visual Fixes:
	if(instance_is(self, Lightning) || instance_is(self, EnemyLightning)){
		temerge_instance_list_add_instance(object_index, "fix_draw_scale", self);
		temerge_fix_draw_yscale = image_yscale;
	}
	else if(instance_is(self, Rocket) || instance_is(self, Nuke)){
		temerge_instance_list_add_instance(object_index, "fix_draw_scale", self);
	} 
	
#define temerge_projectile_add_scale // addXScale, addYScale=addXScale
	/*
		Adds to the calling merged projectile's scale, with manual visual fixes for certain projectiles
		
		Args:
			addXScale - The number to add to the instance's image_xscale
			addYScale - The number to add to the instance's image_yscale, defaults to addXScale
	*/
	
	var	_addXScale = argument[0],
		_addYScale = ((argument_count > 1) ? argument[1] : _addXScale);
		
	temerge_projectile_set_scale(
		image_xscale + (_addXScale * ((image_xscale < 0) ? -1 : 1)),
		image_yscale + (_addYScale * ((image_yscale < 0) ? -1 : 1))
	);
	
#define temerge_projectile_scale_draw
	/*
		Draws merged projectile visual scale fixes
	*/
	
	with(["Lightning", "EnemyLightning", "Rocket", "Nuke"]){
		var	_drawScaleObjectName          = self,
			_drawScaleInstanceListVarName = `temerge_${_drawScaleObjectName}_fix_draw_scale_instance_list`;
			
		if(_drawScaleInstanceListVarName in GameCont){
			var _drawScaleInstanceList = variable_instance_get(GameCont, _drawScaleInstanceListVarName);
			if(array_length(_drawScaleInstanceList)){
				 // Prune Instance List:
				_drawScaleInstanceList = instances_matching_ne(_drawScaleInstanceList, "id");
				
				 // Visual Scale Fix:
				var _activeDrawScaleInstanceList = instances_matching_ge(instances_matching(_drawScaleInstanceList, "visible", true), "depth", other.depth);
				if(array_length(_activeDrawScaleInstanceList)){
					switch(_drawScaleObjectName){
						
						case "Lightning":
						case "EnemyLightning":
						
							with(_activeDrawScaleInstanceList){
								var _yScale = temerge_fix_draw_yscale / 2;
								image_yscale *= _yScale;
								draw_self();
								image_yscale /= _yScale;
							}
							
							break;
							
						default:
						
							with(_activeDrawScaleInstanceList){
								draw_self();
							}
							
					}
				}
				
				 // Store Instance List:
				variable_instance_set(GameCont, _drawScaleInstanceListVarName, _drawScaleInstanceList);
			}
		}
	}
	
#define temerge_projectile_scale_damage(_damageFactor)
	/*
		Scales the calling merged projectile's damage
	*/
	
	damage += round(damage * (_damageFactor - 1));
	
#define temerge_projectile_add_bloom(_bloomAmount)
	/*
		Adds to the calling merged projectile's bloom
	*/
	
	image_alpha += _bloomAmount * sign(image_alpha);
	
#define temerge_projectile_add_trail // ?trailColor, ?trailIsSprite
	/*
		Adds a trail visual effect to the calling merged projectile
	*/
	
	var	_trailColor    = ((argument_count > 0) ? argument[0] : undefined),
		_trailIsSprite = ((argument_count > 1) ? argument[1] : undefined);
		
	if("temerge_trail_color" not in self){
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
	
	if(_trailColor    != undefined) temerge_trail_color     = _trailColor;
	if(_trailIsSprite != undefined) temerge_trail_is_sprite = _trailIsSprite;
	
	 // Add to Instance List:
	temerge_instance_list_add_instance(projectile, "trail", self);
	
#define temerge_projectile_add_force(_forceAmount)
	/*
		Adds to the calling merged projectile's push force
	*/
	
	force += _forceAmount * sign(force);
	
#define temerge_projectile_add_flame(_flameAmount)
	/*
		Adds a flame-releasing effect to the calling merged projectile
	*/
	
	if("temerge_flame_amount" not in self){
		temerge_flame_amount = [0];
		temerge_projectile_add_event("destroy", script_ref_create(temerge_projectile_flame, temerge_flame_amount));
	}
	temerge_flame_amount[0]++;
	
	 // Add to Instance List:
	temerge_instance_list_add_instance(projectile, "flame", self);
	
#define temerge_projectile_flame(_flameAmount)
	if(_flameAmount[0] > 0){
		var	_x = x,
			_y = y;
			
		 // Unstick From Wall:
		if(position_meeting(_x, _y, Wall)){
			_x -= lengthdir_x(12, direction);
			_y -= lengthdir_y(12, direction);
		}
		
		 // Create Flames:
		repeat(_flameAmount[0]){
			call(scr.projectile_create,
				self,
				_x,
				_y,
				Flame,
				((speed == 0) ? random(360) : direction),
				max(1.5, speed / 2)
			);
		}
		_flameAmount[@ 0] = 0;
	}
	
#define temerge_projectile_add_slug(_slugSize)
	/*
		Adds a slug impact effect to the calling merged projectile
	*/
	
	if("temerge_slug_size" not in self){
		temerge_slug_size = 0;
		temerge_projectile_add_event("hit", script_ref_create(temerge_projectile_slug_hit));
	}
	temerge_slug_size += _slugSize;
	
	 // Add Bloom:
	temerge_projectile_add_bloom(_slugSize / 3);
	
#define temerge_projectile_slug(_inst, _hitInst, _hitX, _hitY, _hitDamage)
	/*
		Applies merged projectile slug impact damage & effects to the given instance
		
		Args:
			inst       - The projectile instance
			hitInst    - The hitme instance
			hitX, hitY - The position that the hitme instance is being hit from
			hitDamage  - The damage that is applied to the hitme instance
			hitMult    - The multiplier for the damage and effects
	*/
	
	with(_hitInst){
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
		if(instance_exists(_inst)){
			with(_inst){
				projectile_hit(other, _hitDamage);
			}
		}
		else projectile_hit_raw(self, _hitDamage, 1);
	}
	
#define temerge_projectile_slug_hit
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
				temerge_projectile_slug(self, other, x, y, _damage);
				
				with(other){
					 // Manual I-Frames:
					temerge_slug_nexthurt = nexthurt;
					nexthurt = _lastNextHurt;
					
					 // Piercing Fix:
					if(my_health <= 0){
						script_bind_end_step(temerge_projectile_slug_hit_health_end_step, 0, self, my_health);
						my_health = 1;
					}
				}
				
				 // Disable Slug Effect:
				if(instance_exists(self)){
					temerge_projectile_add_slug(-temerge_slug_size);
				}
				
				 // Disable Event:
				return true;
			}
			
			 // Check Post-Collision:
			else script_bind_end_step(temerge_projectile_slug_hit_end_step, 0, self, other, x, y, _damage);
		}
	}
	
	 // Disable Event:
	else return true;
	
#define temerge_projectile_slug_hit_end_step(_inst, _hitInst, _hitX, _hitY, _hitDamage)
	if(!instance_exists(_inst)){
		temerge_projectile_slug(_inst, instances_matching_ne(_hitInst, "id"), _hitX, _hitY, _hitDamage);
	}
	instance_destroy();
	
#define temerge_projectile_slug_hit_health_end_step(_slugInst, _lastHealth)
	with(instances_matching_le(_slugInst, "my_health", 1)){
		my_health = _lastHealth + (my_health - 1);
	}
	instance_destroy();
	
#define temerge_projectile_add_hyper(_hyperSpeed)
	/*
		Adds a hyper effect to the calling merged projectile
	*/
	
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
	}
	
	 // Hyper Projectiles:
	else{
		if("temerge_hyper_speed" not in self){
			temerge_hyper_speed    = 0;
			temerge_hyper_minspeed = max(1, min(friction * 10, speed - (4 * friction)));
		}
		temerge_hyper_speed += _hyperSpeed;
		
		 // Add to Instance List:
		temerge_instance_list_add_instance(projectile, "hyper", self);
	}
	
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
	
#define temerge_projectile_add_pierce(_pierceStrength)
	/*
		Adds a piercing effect to the calling merged projectile
	*/
	
	if("temerge_pierce_strength" not in self){
		temerge_pierce_strength = 0;
		temerge_projectile_add_event("hit", script_ref_create(temerge_projectile_pierce_hit));
	}
	temerge_pierce_strength = max(temerge_pierce_strength, _pierceStrength);
	
#define temerge_projectile_pierce_hit
	if(
		projectile_canhit(other)
		&& other.my_health > 0
		&& ("canhurt" not in self || canhurt) // Bolts
	){
		var _pierceHealth = damage - floor(damage * (1 - temerge_pierce_strength));
		if(other.my_health <= _pierceHealth){
			 // Manual Damage:
			projectile_hit(other, max(damage, _pierceHealth), force);
			
			 // Temporarily Disable Enemy Hitbox:
			with(other){
				if(mask_index != mskNone){
					script_bind_end_step(temerge_projectile_pierce_hit_mask_end_step, 0, self, mask_index);
					mask_index = mskNone;
				}
			}
		}
	}
	
#define temerge_projectile_pierce_hit_mask_end_step(_inst, _mask)
	with(instances_matching(_inst, "mask_index", mskNone)){
		mask_index = _mask;
	}
	instance_destroy();
	
#define temerge_projectile_add_seeker(_seekerStrength)
	/*
		Adds an enemy-seeking effect to the calling merged projectile
	*/
	
	if("temerge_seeker_strength" not in self){
		temerge_seeker_strength = 0;
	}
	temerge_seeker_strength += _seekerStrength;
	
	 // Add to Instance List:
	temerge_instance_list_add_instance(projectile, "seeker", self);
	
	
#define temerge_HeavyBullet_setup(_inst)
	with(_inst){
		 // Big:
		temerge_projectile_add_scale(0.1);
		
		 // Hits Like a Fist:
		temerge_projectile_scale_damage(5/3);
		temerge_projectile_add_force(2);
	}
	
	
#define temerge_UltraBullet_setup(_inst)
	with(_inst){
		 // Big & Bright:
		temerge_projectile_add_scale(0.2);
		temerge_projectile_add_bloom(0.2);
		
		 // Hits Like a Brick:
		temerge_projectile_scale_damage(2.5);
		temerge_projectile_add_force(4);
	}
	
	
#define temerge_BouncerBullet_wall
	 // Bounce:
	temerge_projectile_wall_bounce();
	
	 // Effects:
	instance_create(x, y, Dust);
	sound_play_hit(sndBouncerBounce, 0.2);
	
	 // Disable Event:
	return true;
	
	
#define temerge_FlameShell_setup(_inst)
	with(_inst){
		 // Releases a Flame:
		temerge_projectile_add_flame(1);
	}
	
	
#define temerge_UltraShell_setup(_inst)
	with(_inst){
		 // Long & Bright:
		if((sprite_get_bbox_bottom(sprite_index) + 1) - sprite_get_bbox_top(sprite_index) <= (sprite_get_bbox_right(sprite_index) + 1) - sprite_get_bbox_left(sprite_index)){
			temerge_projectile_add_scale(0.1, 0);
		}
		else{
			temerge_projectile_add_scale(0, 0.1);
		}
		temerge_projectile_add_bloom(0.2);
		
		 // Hits Like a Dart:
		temerge_projectile_scale_damage(2);
		temerge_projectile_add_force(2);
		
		 // Floaty:
		if(friction > 0){
			friction *= 2/3;
		}
	}
	
	
#define temerge_Slug_setup(_inst)
	with(_inst){
		 // Fat:
		temerge_projectile_add_scale(0.25);
		
		 // Hits Like a Big Fist:
		temerge_projectile_add_slug(1);
		temerge_projectile_add_force(4);
	}
	
	
#define temerge_HeavySlug_setup(_inst)
	with(_inst){
		 // Obese:
		temerge_projectile_add_scale(0.4);
		
		 // Hits Like a Truck:
		temerge_projectile_add_slug(2);
		temerge_projectile_add_force(8);
	}
	
	
#define temerge_HyperSlug_setup(_inst)
	 // Hyper:
	with(_inst){
		temerge_projectile_add_hyper(1);
	}
	
	 // Slug:
	temerge_Slug_setup(_inst);
	
	
#define temerge_FlakBullet_destroy
	var _num = abs(damage / 2) + (force >= 3);
	
	 // Nerf Lightning:
	if(instance_is(self, Lightning) || instance_is(self, EnemyLightning)){
		_num -= ammo;
	}
	
	 // Explode Into Shrapnel:
	_num = min(floor(_num) + chance(frac(_num), 1), 640);
	if(_num > 0){
		var	_x = x,
			_y = y;
			
		 // Unstick From Wall:
		if(position_meeting(_x, _y, Wall)){
			_x -= lengthdir_x(16, direction);
			_y -= lengthdir_y(16, direction);
		}
		
		 // Create Shrapnel:
		repeat(_num){
			call(scr.projectile_create, self, _x, _y, Bullet2, random(360), random_range(8, 16));
		}
		
		 // Sound:
		call(scr.sound_play_at,
			_x,
			_y,
			sndFlakExplode,
			max(0.6, 1.2 - (0.0125 * _num)) + orandom(0.1),
			0.2 + (0.05 * _num),
			320
		);
		
		 // Effects:
		repeat(ceil(_num / 3)){
			call(scr.fx, _x, _y, random(3), Smoke);
		}
		with(instance_create(_x, _y, BulletHit)){
			sprite_index = sprFlakHit;
		}
		view_shake_at(_x, _y, _num / 2);
		sleep(_num / 1.5);
	}
	
	
#define temerge_SuperFlakBullet_setup(_inst)
	with(_inst){
		 // Big:
		temerge_projectile_add_scale(0.2);
	}
	
#define temerge_SuperFlakBullet_destroy
	var _num = power(max(0, abs(damage) - 1.95), 0.45) + (0.25 * (force >= 3));
	
	 // Nerf Lightning:
	if(instance_is(self, Lightning) || instance_is(self, EnemyLightning)){
		_num -= ammo * 1.5;
	}
	
	 // Explode Into Flak Shrapnel:
	_num = min(floor(_num) + chance(frac(_num), 1), 40);
	if(_num > 0){
		var	_x = x,
			_y = y;
			
		 // Unstick From Wall:
		if(position_meeting(_x, _y, Wall)){
			_x -= lengthdir_x(12, direction);
			_y -= lengthdir_y(12, direction);
		}
		
		 // Create Shrapnel:
		var _ang = random(360);
		if(position_meeting(_x + lengthdir_x(16, _ang), _y + lengthdir_y(16, _ang), Wall)){
			_ang += 180;
		}
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
			call(scr.projectile_create, self, _x, _y, FlakBullet, _dir, 12);
		}
		
		 // Sound:
		call(scr.sound_play_at,
			_x,
			_y,
			sndSuperFlakExplode,
			max(0.6, 1.2 - (0.04 * _num)) + orandom(0.1),
			0.2 + (0.16 * _num),
			320
		);
		
		 // Effects:
		repeat(floor(_num * 2.5)){
			call(scr.fx, _x, _y, random(3), Smoke);
		}
		with(instance_create(_x, _y, BulletHit)){
			sprite_index = sprSuperFlakHit;
		}
		view_shake_at(_x, _y, _num * 2.5);
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
	
#define temerge_Bolt_setup(_inst)
	with(_inst){
		 // Has a Cool Trail:
		temerge_projectile_add_trail();
		
		 // Pierces Weaker Enemies:
		temerge_projectile_add_pierce(0.5);
	}
	
	
#define temerge_HeavyBolt_fire(_at)
	 // Bolt:
	temerge_Bolt_fire(_at);
	
#define temerge_HeavyBolt_setup(_inst)
	 // Heavy:
	with(_inst){
		 // Fat:
		temerge_projectile_add_scale(0.25);
		
		 // Hits Like a Log:
		temerge_projectile_scale_damage(2);
		temerge_projectile_add_force(2);
	}
	
	 // Bolt:
	temerge_Bolt_setup(_inst);
	
	
#define temerge_ToxicBolt_fire(_at)
	 // Bolt:
	temerge_Bolt_fire(_at);
	
#define temerge_ToxicBolt_setup(_inst)
	 // Bolt:
	temerge_Bolt_setup(_inst);
	
#define temerge_ToxicBolt_destroy
	var _num = damage * 2/3;
	_num = min(floor(_num) + chance(frac(_num), 1), 640);
	if(_num > 0){
		var	_x = x,
			_y = y;
			
		 // Unstick From Wall:
		if(position_meeting(_x, _y, Wall)){
			_x -= lengthdir_x(12, direction);
			_y -= lengthdir_y(12, direction);
		}
		
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
	
	
#define temerge_UltraBolt_fire(_at)
	 // Bolt:
	temerge_Bolt_fire(_at);
	
#define temerge_UltraBolt_setup(_inst)
	 // Ultra:
	with(_inst){
		 // Brighter:
		temerge_projectile_add_bloom(0.2);
		
		 // Pierces Walls:
		if("temerge_UltraBolt_wall_count" not in self){
			temerge_UltraBolt_wall_count = 0;
		}
		temerge_UltraBolt_wall_count += ceil(damage / 6);
	}
	
	 // Bolt:
	temerge_Bolt_setup(_inst);
	
#define temerge_UltraBolt_wall
	if(temerge_UltraBolt_wall_count > 0){
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
		if(--temerge_UltraBolt_wall_count <= 0){
			return true;
		}
	}
	
	 // Disable Event:
	else return true;
	
	
#define temerge_Splinter_setup(_inst)
	with(_inst){
		 // Small:
		temerge_projectile_add_scale(-0.05);
	}
	
	
#define temerge_Seeker_setup(_inst)
	with(_inst){
		 // Small:
		temerge_projectile_add_scale(-0.05);
		
		 // Has a Cool Trail:
		temerge_projectile_add_trail();
		
		 // Seeks Enemies:
		temerge_projectile_add_seeker(1);
	}
	
	
#define temerge_Disc_setup(_inst)
	with(_inst){
		 // Setup Variables:
		if("temerge_Disc_wall_bounce_frame" not in self){
			temerge_Disc_wall_bounce_frame = current_frame;
			temerge_Disc_friction          = 0;
			temerge_Disc_is_ally           = true;
		}
		
		 // Bounces:
		temerge_Disc_wall_bounce_frame = max(current_frame, temerge_Disc_wall_bounce_frame) + 30;
		
		 // No Friction:
		if(friction != 0){
			temerge_Disc_friction = friction;
			if(speed > friction * 10){
				speed = max(friction * 10, speed - (3 * friction));
			}
			friction = 0;
		}
	}
	
#define temerge_Disc_wall
	 // Become Hostile:
	if(
		temerge_Disc_is_ally
		&& (
			!instance_exists(creator)
			|| distance_to_object(creator) > 16
			|| point_distance(xstart, ystart, creator.x, creator.y) > 16
		)
	){
		temerge_Disc_is_ally = false;
		team = -1;
		
		 // Resprite:
		var _hitName = call(scr.instance_get_name, self);
		call(scr.team_instance_sprite, 1, self);
		if(hitid == -1){
			hitid = [((sprite_index == sprEnemyLaser) ? sprEnemyLaserStart : sprite_index), _hitName];
		}
	}
	
	 // Bounce:
	if(temerge_Disc_wall_bounce_frame > current_frame){
		var _isLaser = (instance_is(self, Laser) || instance_is(self, EnemyLaser));
		
		 // Hitscan Projectiles Bounce Once:
		if(_isLaser || instance_is(self, HyperGrenade)){
			temerge_Disc_wall_bounce_frame -= 30;
		}
		
		 // Bounce:
		temerge_projectile_wall_bounce();
		
		 // Lasers Bounce Once:
		if(_isLaser){
			temerge_Disc_wall_bounce_frame = current_frame;
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
		if(temerge_Disc_friction != 0){
			if(friction == 0){
				friction = temerge_Disc_friction;
			}
			temerge_Disc_friction = 0;
		}
		
		 // Effects:
		sound_play_hit(sndDiscDie, 0.2);
		instance_create(x, y, DiscDisappear);
		
		 // Disable Event:
		return false;
	}
	
	
/// GENERAL
#define ntte_setup_temerge_instance_list_object(_instanceListObject, _instanceListName, _inst)
	/*
		Collects merged instances that were created by 'instance_copy()'
	*/
	
	var	_instanceListObjectName = object_get_name(_instanceListObject),
		_instanceVarName        = `temerge_${_instanceListObjectName}_${_instanceListName}_instance`,
		_instanceListVarName    = `${_instanceVarName}_list`,
		_instanceList           = variable_instance_get(GameCont, _instanceListVarName, []);
		
	if(array_length(_instanceList)){
		with(instances_matching_ne(_inst, _instanceVarName, null)){
			if(
				array_find_index(_instanceList, self) < 0
				&& array_find_index(_instanceList, variable_instance_get(self, _instanceVarName)) >= 0
			){
				array_push(_instanceList, self);
				variable_instance_set(self, _instanceVarName, self);
			}
		}
	}
	
	 // Unbind Script:
	else{
		var	_instanceListObjectSetupBindVarName = `bind_setup_temerge_${_instanceListObjectName}`,
			_instanceListObjectSetupBind        = lq_get(ntte, _instanceListObjectSetupBindVarName);
			
		if(!is_undefined(_instanceListObjectSetupBind)){
			call(scr.ntte_unbind, _instanceListObjectSetupBind);
			lq_set(ntte, _instanceListObjectSetupBindVarName, undefined);
		}
	}
	
#define ntte_begin_step
	 // Merged Projectile Hyper Effect:
	if("temerge_projectile_hyper_instance_list" in GameCont && array_length(GameCont.temerge_projectile_hyper_instance_list)){
		 // Prune Instance List:
		GameCont.temerge_projectile_hyper_instance_list = instances_matching_ne(GameCont.temerge_projectile_hyper_instance_list, "id");
		
		 // Hyper Hitscan:
		with(instances_matching_ge(GameCont.temerge_projectile_hyper_instance_list, "speed", 1)){
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
					GameCont.temerge_projectile_hyper_instance_list = instances_matching_ne(GameCont.temerge_projectile_hyper_instance_list, "id", id);
				}
			}
		}
	}
	
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
	
	 // Merged Projectile Speed Multiplier Fixes:
	with(["PlasmaBall", "PlasmaBig", "PlasmaHuge", "Rocket", "Nuke", "Seeker"]){
		var	_speedFactorObjectName          = self,
			_speedFactorInstanceListVarName = `temerge_${_speedFactorObjectName}_fix_speed_factor_instance_list`;
			
		if(_speedFactorInstanceListVarName in GameCont){
			var _speedFactorInstanceList = variable_instance_get(GameCont, _speedFactorInstanceListVarName);
			if(array_length(_speedFactorInstanceList)){
				 // Prune Instance List:
				_speedFactorInstanceList = instances_matching_ne(_speedFactorInstanceList, "id");
				
				 // Speed Multiplier Fix:
				switch(_speedFactorObjectName){
					
					case "PlasmaBall":
					case "PlasmaBig":
					case "PlasmaHuge":
					
						with(instances_matching(_speedFactorInstanceList, "image_speed", 0)){
							_speedFactorInstanceList = instances_matching_ne(_speedFactorInstanceList, "id", id);
							speed *= temerge_fix_speed_factor;
						}
						
						break;
						
					case "Rocket":
					
						with(_speedFactorInstanceList){
							if(speed > 12 * temerge_fix_speed_factor){
								speed = 12 * temerge_fix_speed_factor;
							}
						}
						
						break;
						
					case "Nuke":
					
						with(_speedFactorInstanceList){
							if(speed > 5 * temerge_fix_speed_factor){
								speed = 5 * temerge_fix_speed_factor;
							}
						}
						
						break;
						
					default:
					
						with(_speedFactorInstanceList){
							speed *= temerge_fix_speed_factor;
						}
						
				}
				
				 // Store Instance List:
				variable_instance_set(GameCont, _speedFactorInstanceListVarName, _speedFactorInstanceList);
			}
		}
	}
	
	 // Merged Projectile Flame Effect (Early Release):
	if("temerge_projectile_flame_instance_list" in GameCont && array_length(GameCont.temerge_projectile_flame_instance_list)){
		 // Prune Instance List:
		GameCont.temerge_projectile_flame_instance_list = instances_matching_ne(GameCont.temerge_projectile_flame_instance_list, "id");
		
		 // Release Flames Early:
		with(instances_matching_gt(instances_matching_lt(GameCont.temerge_projectile_flame_instance_list, "speed", 5), "friction", 0)){
			GameCont.temerge_projectile_flame_instance_list = call(scr.array_delete_value, GameCont.temerge_projectile_flame_instance_list, self);
			temerge_projectile_flame(temerge_flame_amount);
		}
	}
	
	 // Merged Projectile Enemy Seeking Effect:
	if("temerge_projectile_seeker_instance_list" in GameCont && array_length(GameCont.temerge_projectile_seeker_instance_list)){
		 // Prune Instance List:
		GameCont.temerge_projectile_seeker_instance_list = instances_matching_ne(GameCont.temerge_projectile_seeker_instance_list, "id");
		
		 // Enemy Seeking:
		with(instances_matching_ne(GameCont.temerge_projectile_seeker_instance_list, "speed", 0)){
			var	_turn   = orandom(speed_raw / 4),
				_target = call(scr.instance_nearest_array,
					x + (6 * hspeed),
					y + (6 * vspeed),
					instances_matching_ne(instances_matching_ne([enemy, Player, Sapling, Ally, SentryGun, CustomHitme], "team", team, 0), "mask_index", mskNone)
				);
				
			 // Turn Towards Target:
			if(instance_exists(_target) && !collision_line(x, y, _target.x, _target.y, Wall, false, false)){
				var	_addTurn = angle_difference(point_direction(x, y, _target.x, _target.y), direction),
					_maxTurn = 3 * (abs(_addTurn) / (abs(_addTurn) + 30)) * temerge_seeker_strength * current_time_scale;
					
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
		
		 // Laser Enemy Seeking:
		var _seekerLaserInst = instances_matching(instances_matching(GameCont.temerge_projectile_seeker_instance_list, "object_index", Laser, EnemyLaser), "speed", 0);
		if(array_length(_seekerLaserInst)){
			with(_seekerLaserInst){
				var _target = call(scr.instance_nearest_array, x, y, instances_matching_ne(instances_matching_ne([enemy, Player, Sapling, Ally, SentryGun, CustomHitme], "team", team, 0), "mask_index", mskNone));
				if(instance_exists(_target) && !collision_line(xstart, ystart, _target.x, _target.y, Wall, false, false)){
					var	_len = min(4 * temerge_seeker_strength * current_time_scale, point_distance(x, y, _target.x, _target.y)),
						_dir = point_direction(x, y, _target.x, _target.y);
						
					x           += lengthdir_x(_len, _dir);
					y           += lengthdir_y(_len, _dir);
					image_angle  = point_direction(xstart, ystart, x, y);
					image_xscale = point_distance(xstart, ystart, x, y) / 2;
				}
			}
		}
	}
	
	 // Merged Projectile Trail Visual Effect:
	if("temerge_projectile_trail_instance_list" in GameCont && array_length(GameCont.temerge_projectile_trail_instance_list)){
		 // Prune Instance List:
		GameCont.temerge_projectile_trail_instance_list = instances_matching_ne(GameCont.temerge_projectile_trail_instance_list, "id");
		
		 // Trails:
		var _areaIsUnderwater = call(scr.area_get_underwater, GameCont.area);
		with(instances_matching_gt(GameCont.temerge_projectile_trail_instance_list, "speed", 0)){
			with(instance_create(x, y, BoltTrail)){
				image_xscale = other.speed_raw;
				image_angle  = other.direction;
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
	
	 // Merged Projectile Destroy Events:
	if("temerge_projectile_destroy_instance_list" in GameCont && array_length(GameCont.temerge_projectile_destroy_instance_list)){
		with(GameCont.temerge_projectile_destroy_instance_list){
			 // Update Stored Instance Variables:
			if(instance_exists(self)){
				var _destroyVars = temerge_destroy_vars;
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
			
			 // Instance Destroyed:
			else{
				var	_destroyInstanceIndex = array_find_index(GameCont.temerge_projectile_destroy_instance_list, self),
					_destroyInstanceVars  = GameCont.temerge_projectile_destroy_instance_vars_list[_destroyInstanceIndex];
					
				 // Remove From List:
				GameCont.temerge_projectile_destroy_instance_list      = call(scr.array_delete, GameCont.temerge_projectile_destroy_instance_list,      _destroyInstanceIndex);
				GameCont.temerge_projectile_destroy_instance_vars_list = call(scr.array_delete, GameCont.temerge_projectile_destroy_instance_vars_list, _destroyInstanceIndex);
				
				 // Create Dummy Projectile:
				with(instance_create(_destroyInstanceVars.x, _destroyInstanceVars.y, GameObject)){
					 // Set Stored Variables:
					instance_change(_destroyInstanceVars.object_index, false);
					call(scr.variable_instance_set_list, self, _destroyInstanceVars);
					xprevious = x;
					yprevious = y;
					
					 // Untag Team:
					team = round(team);
					
					 // Call Event Scripts:
					with(temerge_destroy_ref_list){
						call(scr.pass, other, self);
						if(!instance_exists(other)){
							break;
						}
					}
					
					 // Delete:
					instance_delete(self);
				}
			}
		}
	}
	
	 // Merged Projectile Collision Events:
	with(["hit", "wall"]){
		var	_eventName                = self,
			_eventInstanceListVarName = `temerge_projectile_${_eventName}_instance_list`;
			
		if(_eventInstanceListVarName in GameCont){
			var _eventInstanceList = variable_instance_get(GameCont, _eventInstanceListVarName);
			if(array_length(_eventInstanceList)){
				var	_searchDis    = 16,
					_searchObject = -1;
					
				 // Event Collision Object:
				switch(_eventName){
					case "hit"  : _searchObject = hitme; break;
					case "wall" : _searchObject = Wall;  break;
				}
				
				 // Prune Instance List:
				_eventInstanceList = instances_matching_ne(_eventInstanceList, "id");
				variable_instance_set(GameCont, _eventInstanceListVarName, _eventInstanceList);
				
				 // Instance Collision:
				with(_eventInstanceList){
					if(instance_exists(self) && distance_to_object(_searchObject) <= _searchDis + max(0, abs(speed_raw) - friction_raw) + abs(gravity_raw)){
						var _isFixingSolid = false;
						
						 // Fix Projectiles Without Wall Collision Events:
						if(_eventName == "wall" && array_find_index([Laser, EnemyLaser, Lightning, EnemyLightning, HyperGrenade], object_index) >= 0){
							_isFixingSolid = true;
							
							var	_lastXPrevious = xprevious,
								_lastYPrevious = yprevious;
								
							xprevious = x;
							yprevious = y;
						}
						
						 // Apply Motion:
						call(scr.motion_step, self, 1);
						
						 // Search for Nearby Walls:
						if(distance_to_object(_searchObject) <= _searchDis){
							var _meetInst = call(scr.instances_meeting_rectangle,
								bbox_left   - _searchDis,
								bbox_top    - _searchDis,
								bbox_right  + _searchDis,
								bbox_bottom + _searchDis,
								(
									(_searchObject == hitme)
									? instances_matching_ne(_searchObject, "team", team)
									: _searchObject
								)
							);
							if(array_length(_meetInst)){
								with(_meetInst){
									 // Apply Motion:
									call(scr.motion_step, self, 1);
									
									 // Collision:
									if(place_meeting(x, y, other)){
										with(other){
											var	_isSolid             = (other.solid || solid),
												_context             = [self, other],
												_eventRefListVarName = `temerge_${_eventName}_ref_list`,
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
											for(var _inst = _minID; _inst < _maxID && instance_exists(self); _inst++){
												if(instance_is(_inst, _searchObject) && place_meeting(x, y, _inst)){
													_isSolid    = (solid || _inst.solid);
													_context[1] = _inst;
													
													 // Solid Collision:
													if(_isSolid){
														x       = xprevious;
														y       = yprevious;
														_inst.x = _inst.xprevious;
														_inst.y = _inst.yprevious;
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
														if(instance_exists(_inst)){
															_inst.x += _inst.hspeed_raw;
															_inst.y += _inst.vspeed_raw;
														}
													}
													
													 // Keep Searching:
													_maxID = instance_max;
												}
											}
											
											 // Remove From Event Instance List:
											if(!instance_exists(self) || !array_length(_eventRefList)){
												_eventInstanceList = instances_matching_ne(_eventInstanceList, "id", self);
												variable_instance_set(GameCont, _eventInstanceListVarName, _eventInstanceList);
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