#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Bind Events:
	script_bind(CustomDraw, temerge_scale_draw, 0, true);
	
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
		"step",
		"player_fire",
		"weapon_fire",
		"projectile_setup"
	]){
		temerge_set_weapon_event_script(self, script_ref_create(script_get_index("temerge_" + self)));
	}
	
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

#define temerge_set_weapon_event_script(_eventName, _eventScriptRef)
	/*
		Sets the given weapon event's script to the given script reference
	*/
	
	global.weapon_event_script_map[? _eventName] = _eventScriptRef;
	
#define temerge_merge_weapon(_wep, _frontWep)
	/*
		Returns a weapon of the given weapons merged together
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
		_frontWep = temerge_merge_weapon(_wepXmerge_wep, _frontWep);
	}
	
	 // Merged Weapon Setup:
	else{
		 // Wrapper Script Setup:
		with(ds_map_keys(global.weapon_event_script_map)){
			_wep = call(scr.wep_wrap, _wep, self, global.weapon_event_script_map[? self]);
		}
		
		 // LWO Setup:
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
						
					case "RIFLE":
					
						 // ASSAULT SHOTGUN > ASSAULT SHOTGUN RIFLE:
						if(array_find_index(_mergeNameWordTextList, "ASSAULT") >= 0){
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
		Merged weapons play the swap sounds from all of their weapon parts, but play their stock weapon's sounds quieter
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
			return 0;
		}
		
		return weapon_get_type(_wepXmerge_wep);
	}
	
	return _stockType;
	
#define temerge_weapon_cost(_wep, _stockCost)
	/*
		Merged weapons use their front weapon's ammo cost
	*/
	
	if(_wepXhas_merge){
		if(_wepXmerge_is_part){
			return 0;
		}
		
		return weapon_get_cost(_wepXmerge_wep);
	}
	
	return _stockCost;
	
#define temerge_weapon_rads(_wep, _stockRads)
	/*
		Merged weapons use their front weapon's rad cost
	*/
	
	if(_wepXhas_merge){
		if(_wepXmerge_is_part){
			return 0;
		}
		
		return weapon_get_rads(_wepXmerge_wep);
	}
	
	return _stockRads;
	
#define temerge_weapon_load(_wep, _stockLoad)
	/*
		Merged weapons use the highest reload from their weapon parts factored by a multiplier based on the lowest reload divided by 8 frames
	*/
	
	if(_wepXhas_merge){
		if(_wepXmerge_is_part){
			return 1;
		}
		
		var	_frontLoad = weapon_get_load(_wepXmerge_wep),
			_minLoad   = min(_stockLoad, _frontLoad),
			_maxLoad   = max(_stockLoad, _frontLoad),
			_mergeLoad = _maxLoad * lerp(1, _minLoad / 8, 0.85);
			
		 // Decay High Reload:
		if(_mergeLoad > _maxLoad){
			_mergeLoad = lerp(_mergeLoad, _maxLoad, 2/3);
		}
		
		return _mergeLoad;
	}
	
	return _stockLoad;
	
#define temerge_weapon_auto(_wep, _stockIsAuto)
	/*
		Merged weapons are automatic if their stock weapon is automatic, or if one of their other parts is automatic and reloads within 8 frames
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
		Merged weapons use a laser sight if any of their non-front weapon parts use a laser sight
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
		Merged weapons use the red ammo cost of their weapon part that most recently fired in the past 15 frames
		If none exist, merged weapons use the red ammo cost of the first non-front weapon part that uses red ammo
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
			temerge_event_call(_wep, self, script_ref_create_ext("weapon", _baseFrontWep, "weapon_reloaded", _wepIsPrimary), true, "", undefined);
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
	
#define temerge_step(_wepIsPrimary)
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
			temerge_event_call(_wep, self, script_ref_create_ext("weapon", _baseFrontWep, "step", _wepIsPrimary), true, "", undefined);
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
	
#define temerge_event_call(_wep, _creator, _scriptCallRef, _canWrapEvents, _wrapEventVarName, _wrapEventRef)
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
									temerge_event_call,
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
	
	 // Setup Variable Storage:
	var	_atTeam    = ((_at.team == undefined) ? team : _at.team),
		_atCreator = _at.creator,
		_merge     = call(scr.projectile_tag_get_value, _atTeam, _atCreator, "temerge_vars");
		
	if(is_undefined(_merge)){
		_merge = {};
		call(scr.projectile_tag_set_value, _atTeam, _atCreator, "temerge_vars", _merge);
	}
	
	 // Store Initial Values:
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
			if(instance_is(self, Player)){
				ammo[weapon_get_type(_wep)] += weapon_get_cost(_wep);
			}
			GameCont.rad += weapon_get_rads(_wep);
			
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
		
	if(!is_undefined(_merge) && "fire_vars" in _merge){
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
			wepangle = _mainFire.wepangle;
			
			 // Revert Weapon Kick:
			if(wkick == 0){
				wkick = _mainFire.wkick;
			}
		}
		
		 // Revert Ammo Cost:
		if(_wepXhas_merge){
			if(instance_is(_creator, Player)){
				var _fireAmmo = _fire.ammo;
				if(!is_undefined(_fireAmmo)){
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
	
#define temerge_projectile_setup(_inst, _wep, _mainShot, _mainX, _mainY, _mainDirection, _mainAccuracy, _mainTeam, _mainCreator)
	/*
		Merged weapons replace the projectiles fired by their stock weapon(s) with shots from their front weapon(s) and apply effects to the final projectiles
	*/
	
	if(array_length(_inst)){
		var _mainMerge = call(scr.projectile_tag_get_value, _mainTeam, _mainCreator, "temerge_vars");
		
		 // Replace Projectiles:
		if(_mainShot && _wepXhas_merge){
			var	_mainWep         = _wep,
				_originX         = _mainX,
				_originY         = _mainY,
				_originDirection = _mainDirection,
				_playerSpeedMap  = ds_map_create();
				
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
			var	_rawWep             = undefined,
				_wepSprite          = undefined,
				_stockSprite        = undefined,
				_instCanShoot       = true,
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
					if(_instCanShoot){
						var	_merge = {
								temp : object_index,
								"on_fire"  : (("temerge_on_fire"  in self) ? temerge_on_fire  : undefined),
								"on_merge" : (("temerge_on_merge" in self) ? temerge_on_merge : undefined),
								"on_hit"   : (("temerge_on_hit"   in self) ? temerge_on_hit   : undefined)
							},
							_fireAt = {
								"x"                  : undefined,
								"y"                  : undefined,
								"position_distance"  : point_distance(_originX, _originY, xstart, ystart),
								"position_direction" : undefined,
								"position_rotation"  : angle_difference(point_direction(_originX, _originY, xstart, ystart), _originDirection),
								"direction"          : undefined,
								"direction_rotation" : angle_difference(((direction == 0 && speed == 0) ? ((image_angle == 0) ? _originDirection : image_angle) : direction), _originDirection),
								"accuracy"           : _mainAccuracy,
								"wep"                : _wepXmerge_wep_raw,
								"team"               : team,
								"creator"            : creator,
							};
							
						 // Is Independent From the Creator:
						if(_instWasIndependent || round(_fireAt.position_distance) > 16){
							_instWasIndependent = true;
							_fireAt.x           = _originX;
							_fireAt.y           = _originY;
							_fireAt.direction   = _originDirection;
						}
						
						 // Setup Default Scripts:
						var _scrName = "temerge_" + object_get_name(
							("temerge_object" in self && !is_undefined(temerge_object))
							? temerge_object
							: object_index
						);
						switch(_merge.on_fire ){ case undefined: var _scrIndex = script_get_index(`${_scrName}_fire`);  if(_scrIndex >= 0) _merge.on_fire  = script_ref_create(_scrIndex); }
						switch(_merge.on_merge){ case undefined: var _scrIndex = script_get_index(`${_scrName}_merge`); if(_scrIndex >= 0) _merge.on_merge = script_ref_create(_scrIndex); }
						switch(_merge.on_hit  ){ case undefined: var _scrIndex = script_get_index(`${_scrName}_hit`);   if(_scrIndex >= 0) _merge.on_hit   = script_ref_create(_scrIndex); }
						
						 // Call Firing Setup Code:
						if(!is_undefined(_merge.on_fire)){
							call(scr.pass, self, _merge.on_fire, _fireAt);
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
								var _canShoot = true;
								
								 // Take Ammo:
								if(!_wepXhas_merge){
									if(instance_is(self, Player) && infammo == 0){
										var	_type = weapon_get_type(_wep),
											_cost = weapon_get_cost(_wep);
											
										if(ammo[_type] >= _cost){
											var _rads = weapon_get_rads(_wep);
											if(GameCont.rad >= _rads){
												ammo[_type]  -= _cost;
												GameCont.rad -= _rads;
											}
											else _canShoot = false;
										}
										else _canShoot = false;
									}
								}
								
								 // Firing:
								if(_canShoot){
									 // Store Firing Frame:
									var _lastWep = _wep;
									_wep = _mainWep;
									_wepXmerge_wep_fire_frame = current_frame;
									_wep = _lastWep;
									
									 // Store Player Speed:
									if(instance_is(self, Player) && !ds_map_exists(_playerSpeedMap, self)){
										_playerSpeedMap[? self] = speed;
									}
									
									 // Store Values:
									if(!is_undefined(_mainMerge) && "main_fire_vars" in _mainMerge){
										_merge.main_fire_vars = _mainMerge.main_fire_vars;
									}
									call(scr.projectile_tag_set_value,
										(is_undefined(_fireAt.team) ? team : _fireAt.team),
										other,
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
											other,
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
										_instCanShoot = false;
									}
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
								if(snd != asset_get_index(audio_get_name(snd)) || instance_number(object_index) <= 1){
									sound_stop(snd);
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
		else if(!is_undefined(_mainMerge)){
			var _speedFactor = 1;
			
			// Speed | Friction | Factor  | Weapon
			// 24    | 0        | 1.25    | Crossbow
			// 16    | 0        | 1?      | Machinegun
			// 16    | 0.8      | 0.8     | Slugger
			// 18    | 0.6      | ?       | Shotgun Max
			// 12    | 0.6      | ?       | Shotgun Min
			
			 // Call Projectile Effect Merging Code:
			if("on_merge" in _mainMerge && !is_undefined(_mainMerge.on_merge)){
				script_ref_call(_mainMerge.on_merge, _inst);
			}
			_inst = instances_matching_ne(_inst, "id");
			
			 // TESTING:
			if("temp" in _mainMerge) switch(_mainMerge.temp){
			
				case Bolt:
				
					 // Faster:
					_speedFactor = 1.25;
					
					break;
					
				case Slug:
				
					 // Slower:
					_speedFactor = 0.8;
					
					break;
					
			}
			
			 // Less Speed:
			if(_speedFactor != 1){
				with(_inst){
					 // Exceptions:
					if(speed != 0){
						if(instance_is(self, PlasmaBall) || instance_is(self, PlasmaBig) || instance_is(self, PlasmaHuge)){
							if("temerge_speed_Plasma" not in GameCont){
								GameCont.temerge_speed_Plasma = [];
							}
							if(array_find_index(GameCont.temerge_speed_Plasma, self) < 0){
								array_push(GameCont.temerge_speed_Plasma, self);
							}
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
								if("temerge_speed_Rocket" not in GameCont){
									GameCont.temerge_speed_Rocket = [];
								}
								if(array_find_index(GameCont.temerge_speed_Rocket, self) < 0){
									array_push(GameCont.temerge_speed_Rocket, self);
								}
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
								if("temerge_speed_Nuke" not in GameCont){
									GameCont.temerge_speed_Nuke = [];
								}
								if(array_find_index(GameCont.temerge_speed_Nuke, self) < 0){
									array_push(GameCont.temerge_speed_Nuke, self);
								}
							}
						}
						else if(instance_is(self, Seeker)){
							if("temerge_speed_Seeker" not in GameCont){
								GameCont.temerge_speed_Seeker = [];
							}
							if(array_find_index(GameCont.temerge_speed_Seeker, self) < 0){
								array_push(GameCont.temerge_speed_Seeker, self);
							}
						}
					}
					if("temerge_speed_factor" not in self){
						temerge_speed_factor = 1;
					}
					temerge_speed_factor *= _speedFactor;
					
					 // Clamp Speed:
					image_angle -= direction;
					var _maxSpeed = 16 + bbox_width;
					image_angle += direction;
					if(speed < _maxSpeed){
						speed = min(speed * _speedFactor, _maxSpeed);
					}
				}
			}
			
			 // Custom Hit Event:
			if("on_hit" in _mainMerge){
				var _onHit = _mainMerge.on_hit;
				if(!is_undefined(_onHit)){
					if("temerge_hit_instance_list" not in GameCont){
						GameCont.temerge_hit_instance_list = [];
					}
					with(_inst){
						if("temerge_on_hit_list" not in self || !array_length(temerge_on_hit_list)){
							temerge_on_hit_list = [];
							if(instance_is(self, CustomProjectile)){
								on_hit = script_ref_create(temerge_hit, (is_undefined(on_hit) ? script_ref_create(CustomProjectile_hit) : on_hit));
							}
							else if(array_find_index(GameCont.temerge_hit_instance_list, self) < 0){
								array_push(GameCont.temerge_hit_instance_list, self);
							}
						}
						if(array_find_index(temerge_on_hit_list, _onHit) < 0){
							array_push(temerge_on_hit_list, _onHit);
						}
					}
				}
			}
		}
	}
	
#define temerge_set_scale // setXScale, setYScale=setXScale
	/*
		Sets the calling instance's scale, with manual visual fixes for certain projectiles
		
		Args:
			setXScale - The number to set to the instance's image_xscale
			setYScale - The number to set to the instance's image_yscale, defaults to setXScale
	*/
	
	var	_setXScale = argument[0],
		_setYScale = ((argument_count > 1) ? argument[1] : _setXScale);
		
	image_xscale = _setXScale;
	image_yscale = _setYScale;
	
	 // Manual Visual Fixes:
	if(instance_is(self, Rocket) || instance_is(self, Nuke)){
		if("temerge_scale_draw_projectile" not in GameCont){
			GameCont.temerge_scale_draw_projectile = [];
		}
		if(array_find_index(GameCont.temerge_scale_draw_projectile, self) < 0){
			array_push(GameCont.temerge_scale_draw_projectile, self);
		}
	}
	else if(instance_is(self, Lightning)){
		if("temerge_scale_draw_Lightning" not in GameCont){
			GameCont.temerge_scale_draw_Lightning = [];
		}
		if(array_find_index(GameCont.temerge_scale_draw_Lightning, self) < 0){
			array_push(GameCont.temerge_scale_draw_Lightning, self);
		}
		temerge_Lightning_scale = image_yscale;
	}
	
#define temerge_add_scale // addXScale, addYScale=addXScale
	/*
		Adds to the calling instance's scale, with manual visual fixes for certain projectiles
		
		Args:
			addXScale - The number to add to the instance's image_xscale
			addYScale - The number to add to the instance's image_yscale, defaults to addXScale
	*/
	
	var	_addXScale = argument[0],
		_addYScale = ((argument_count > 1) ? argument[1] : _addXScale);
		
	temerge_set_scale(
		image_xscale + (_addXScale * ((image_xscale < 0) ? -1 : 1)),
		image_yscale + (_addYScale * ((image_yscale < 0) ? -1 : 1))
	);
	
#define temerge_scale_draw
	 // Visually Fix Projectile Scale:
	if("temerge_scale_draw_projectile" in GameCont && array_length(GameCont.temerge_scale_draw_projectile)){
		GameCont.temerge_scale_draw_projectile = instances_matching_ne(GameCont.temerge_scale_draw_projectile, "id");
		with(instances_matching_ge(instances_matching(GameCont.temerge_scale_draw_projectile, "visible", true), "depth", depth)){
			draw_self();
		}
	}
	
	 // Visually Fix Lightning Scale:
	if("temerge_scale_draw_Lightning" in GameCont && array_length(GameCont.temerge_scale_draw_Lightning)){
		GameCont.temerge_scale_draw_Lightning = instances_matching_ne(GameCont.temerge_scale_draw_Lightning, "id");
		with(instances_matching_ge(instances_matching(GameCont.temerge_scale_draw_Lightning, "visible", true), "depth", depth)){
			var _scale = temerge_Lightning_scale / 2;
			image_yscale *= _scale;
			draw_self();
			image_yscale /= _scale;
		}
	}
	
#define ntte_step
	with(Player){
		if(button_pressed(index, "horn")){
			wep  = temerge_merge_weapon(wep, bwep);
			bwep = wep_none;
		}
	}
	
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
	
	 // Plasma Speed Fix:
	if("temerge_speed_Plasma" in GameCont && array_length(GameCont.temerge_speed_Plasma)){
		GameCont.temerge_speed_Plasma = instances_matching_ne(GameCont.temerge_speed_Plasma, "id");
		with(instances_matching(GameCont.temerge_speed_Plasma, "image_speed", 0)){
			GameCont.temerge_speed_Plasma = instances_matching_ne(GameCont.temerge_speed_Plasma, "id", id);
			speed *= temerge_speed_factor;
		}
	}
	
	 // Rocket Speed Fix:
	if("temerge_speed_Rocket" in GameCont && array_length(GameCont.temerge_speed_Rocket)){
		GameCont.temerge_speed_Rocket = instances_matching_ne(GameCont.temerge_speed_Rocket, "id");
		with(GameCont.temerge_speed_Rocket){
			if(speed > 12 * temerge_speed_factor){
				speed = 12 * temerge_speed_factor;
			}
		}
	}
	
	 // Nuke Speed Fix:
	if("temerge_speed_Nuke" in GameCont && array_length(GameCont.temerge_speed_Nuke)){
		GameCont.temerge_speed_Nuke = instances_matching_ne(GameCont.temerge_speed_Nuke, "id");
		with(GameCont.temerge_speed_Nuke){
			if(speed > 5 * temerge_speed_factor){
				speed = 5 * temerge_speed_factor;
			}
		}
	}
	
	 // Seeker Speed Fix:
	if("temerge_speed_Seeker" in GameCont && array_length(GameCont.temerge_speed_Seeker)){
		GameCont.temerge_speed_Seeker = instances_matching_ne(GameCont.temerge_speed_Seeker, "id");
		with(GameCont.temerge_speed_Seeker){
			speed *= temerge_speed_factor;
		}
	}
	
	 // Merged Projectile HitMe Collision:
	if("temerge_hit_instance_list" in GameCont && array_length(GameCont.temerge_hit_instance_list)){
		GameCont.temerge_hit_instance_list = instances_matching_ne(GameCont.temerge_hit_instance_list, "id");
		
		var _searchDis = 16;
		
		with(GameCont.temerge_hit_instance_list){
			if(instance_exists(self) && distance_to_object(hitme) <= _searchDis + max(0, abs(speed_raw) - friction_raw) + abs(gravity_raw)){
				call(scr.motion_step, self, 1);
				
				if(distance_to_object(hitme) <= _searchDis){
					var _instMeet = call(scr.instances_meeting_rectangle,
						bbox_left   - _searchDis,
						bbox_top    - _searchDis,
						bbox_right  + _searchDis,
						bbox_bottom + _searchDis,
						instances_matching_ne(hitme, "team", team)
					);
					if(array_length(_instMeet)){
						with(_instMeet){
							call(scr.motion_step, self, 1);
							
							if(place_meeting(x, y, other)){
								with(other){
									var _context = [self, other];
									with(temerge_on_hit_list){
										if(call(scr.pass, _context, self) && instance_exists(other)){
											other.temerge_on_hit_list = call(scr.array_delete_value, other.temerge_on_hit_list, self);
										}
										if(!instance_exists(other)){
											break;
										}
									}
									if(!instance_exists(self) || !array_length(temerge_on_hit_list)){
										GameCont.temerge_hit_instance_list = instances_matching_ne(GameCont.temerge_hit_instance_list, "id", other);
									}
								}
								if(!instance_exists(self)){
									continue;
								}
							}
							
							call(scr.motion_step, self, -1);
						}
						if(!instance_exists(self)){
							continue;
						}
					}
				}
				
				call(scr.motion_step, self, -1);
			}
		}
	}
	
#define temerge_hit(_refLast)
	var	_call      = 0,
		_context   = [self, other],
		_lastOnHit = on_hit;
		
	 // Reset 'on_hit' Script:
	on_hit = _refLast;
	
	 // Call Custom Scripts:
	with(temerge_on_hit_list){
		if(call(scr.pass, _context, self) && instance_exists(other)){
			other.temerge_on_hit_list = call(scr.array_delete_value, other.temerge_on_hit_list, self);
		}
		if(!instance_exists(other)){
			exit;
		}
	}
	
	 // Call Normal Script:
	if(instance_exists(other)){
		_call = call(scr.pass, _context, on_hit);
	}
	
	 // Retake 'on_hit' Script:
	if(instance_exists(self) && array_length(temerge_on_hit_list)){
		_lastOnHit[4] = on_hit;
		on_hit        = _lastOnHit;
	}
	
	return _call;
	
#define CustomProjectile_hit
	if(projectile_canhit(other)){
		projectile_hit(other, damage, force);
		instance_destroy();
	}
	
	
#define temerge_Bolt_fire(_at)
	 // More Accuracy:
	_at.accuracy *= 0.5;
	
#define temerge_Bolt_merge(_inst)
	with(_inst){
		 // Add Piercing:
		if("temerge_Bolt" not in self){
			temerge_Bolt = 0;
		}
		temerge_Bolt++;
		
		 // More Damage:
		damage += 2;
	}
	
#define temerge_Bolt_hit
	if(projectile_canhit(other) && other.my_health > 0 && ("canhurt" not in self || canhurt)){
		if(other.my_health <= damage){
			 // Manual Damage:
			projectile_hit(other, damage, force);
			
			 // Disable Enemy Hitbox:
			with(other){
				if(mask_index != mskNone){
					script_bind_end_step(temerge_Bolt_hit_end_step, 0, self, mask_index);
					mask_index = mskNone;
				}
			}
			
			 // End:
			damage -= floor(damage / 2);
			/*if(--temerge_Bolt <= 0){
				return true;
			}*/
		}
	}
	
#define temerge_Bolt_hit_end_step(_inst, _mask)
	with(instances_matching(_inst, "mask_index", mskNone)){
		mask_index = _mask;
	}
	instance_destroy();
	
	
#define temerge_Slug_merge(_inst)
	with(_inst){
		 // Add Impact Damage:
		if("temerge_Slug" not in self){
			temerge_Slug = 0;
		}
		temerge_Slug++;
		
		 // More Push:
		force += 4;
		
		 // More Bloom:
		image_alpha += sign(image_alpha) / 3;
		
		 // More Big:
		temerge_add_scale(0.25);
	}
	
#define temerge_Slug_hit
	if(projectile_canhit(other) && other.my_health > 0 && ("canhurt" not in self || canhurt)){ // Bolts
		if("temerge_Slug_nexthurt" not in other || other.temerge_Slug_nexthurt <= current_frame){
			var _lastNextHurt = other.nexthurt;
			
			 // Deal Impact Damage:
			temerge_Slug_impact(self, other, x, y, damage, temerge_Slug);
			
			with(other){
				 // Manual I-Frames:
				temerge_Slug_nexthurt = nexthurt;
				nexthurt              = _lastNextHurt;
				
				 // Piercing Fix:
				if(my_health <= 0){
					script_bind_end_step(temerge_Slug_health_end_step, 0, self, my_health);
					my_health = 1;
				}
			}
			
			 // Disable Slug Effect:
			if(instance_exists(self)){
				image_alpha -= (sign(image_alpha) / 3) * temerge_Slug;
				temerge_Slug = 0;
			}
			
			return true;
		}
		
		 // Check Post-Collision:
		else script_bind_end_step(temerge_Slug_hit_end_step, 0, self, other, x, y, damage, temerge_Slug);
	}
	
#define temerge_Slug_hit_end_step(_slugInst, _hitInst, _hitX, _hitY, _hitDamage, _hitMult)
	if(!instance_exists(_slugInst)){
		temerge_Slug_impact(_slugInst, instances_matching_ne(_hitInst, "id"), _hitX, _hitY, _hitDamage, _hitMult);
	}
	instance_destroy();
	
#define temerge_Slug_health_end_step(_slugInst, _lastHealth)
	with(instances_matching_le(_slugInst, "my_health", 1)){
		my_health = _lastHealth + (my_health - 1);
	}
	instance_destroy();
	
#define temerge_Slug_impact(_inst, _hitInst, _hitX, _hitY, _hitDamage, _hitMult)
	/*
		WIP
	*/
	
	var _damage = _hitDamage;
	
	 // :
	if(_hitMult > 0){
		repeat(_hitMult){
			_damage = _hitDamage + (ceil(_damage * 1.5) + (4 * ((_damage < 0) ? -1 : 1)));
		}
	}
	_damage -= _hitDamage;
	
	 // :
	with(_hitInst){
		 // :
		var	_bx  = bbox_center_x,
			_by  = bbox_center_y,
			_dir = ((_bx == _hitX && _by == _hitY) ? random(360) : point_direction(_bx, _by, _hitX, _hitY));
			
		with(instance_create(
			_bx + lengthdir_x(min(abs(_hitX - _bx), (bbox_width  / 2) + 1), _dir),
			_by + lengthdir_y(min(abs(_hitY - _by), (bbox_height / 2) + 1), _dir),
			BulletHit
		)){
			var _scale = 0.8 + ((_hitDamage / 100) * _hitMult);
			sprite_index = ((_scale < 1.5) ? sprSlugHit : sprHeavySlugHit);
			image_xscale = ((_scale < 1.5) ? _scale     : (_scale / 1.5));
			image_yscale = image_xscale;
			depth        = -6;
			friction     = 0.6;
			motion_add(_dir + 180 + orandom(30), 4);
		}
		
		 // :
		if(instance_exists(_inst)){
			with(_inst){
				projectile_hit(other, _damage);
			}
		}
		else projectile_hit_raw(self, _damage, 1);
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