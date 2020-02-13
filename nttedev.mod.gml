#define chat_command(_cmd, _arg, _ind)
    switch(_cmd){
		case "charm":
			mod_script_call_nc("mod", "telib", "charm_instance", instance_create(mouse_x[_ind], mouse_y[_ind], asset_get_index(_arg)), true);
			return true;
			
		case "debuglag":
			var _mod = [];
			if(_arg != ""){
				var	p = 0;
				for(var i = 0; i <= string_length(_arg); i++){
					if(string_char_at(_arg, i) == "."){
						p = i;
					}
				}
				
				var	_name = ((p <= 0) ? _arg : string_copy(_arg, 1, p - 1)),
					_type = ((p <= 0) ? "mod" : string_delete(_arg, 1, p));
					
				array_push(_mod, [_type, _name]);
				
			}
			else{
				global.debug_lag = !global.debug_lag;
				with(["mod", "weapon", "race", "skill", "crown", "area", "skin"]){
					with(mod_get_names(self)){
						array_push(_mod, [other, self]);
					}
				}
				trace_color("DEBUGGING LAG" + (global.debug_lag ? "" : " DISABLED"), (global.debug_lag ? c_lime : c_red));
			}
			
			with(_mod){
				var _type = self[0],
					_name = self[1],
					_varn = "debug_lag";
					
				if(mod_variable_exists(_type, _name, _varn)){
					var _state = ((_arg != "") ? !mod_variable_get(_type, _name, _varn) : global.debug_lag);
					if(_state ^^ mod_variable_get(_type, _name, _varn)){
						mod_variable_set(_type, _name, _varn, _state);
						if(_arg != "") trace_color((_state ? "ENABLED" : "DISABLED") + " " + _name + "." + _type, (_state ? c_lime : c_red));
					}
				}
				else if(_arg != ""){
					trace_color("Cannot debug lag for " + _arg, c_red);
				}
			}
			
			return true;
			
        case "loadblock":
            scriptblock_file_load("scripts/" + _arg + ".txt");
            return true;
            
        case "pet":
            mod_script_call_nc("mod", "telib", "pet_spawn", mouse_x[_ind], mouse_y[_ind], _arg);
            return true;
			
		case "top":
			mod_script_call_nc("mod", "telib", "top_create", mouse_x[_ind], mouse_y[_ind], (object_exists(asset_get_index(_arg)) ? asset_get_index(_arg) : _arg), 0, 0);
			return true;
			
		case "unlockall":
		case "unlockreset":
			var _unlock = (_cmd == "unlockall");
			
			with(global.unlock){
				mod_script_call_nc("mod", "telib", "unlock_set", self, _unlock);
	            chat_comp_add_arg("unlocktoggle", 0, self, (_unlock ? "UNLOCKED" : "LOCKED"));
			}
			
			mod_script_call_nc("mod", "telib", "unlock_splat", "", "@wEVERYTHING " + (_unlock ? "@gUNLOCKED" : "@rLOCKED"), -1, -1);
			sound_play(_unlock ? sndGoldUnlock : sndCursedChest);
			return true;
			
		case "unlocktoggle":
			if(!mod_script_call_nc("mod", "telib", "unlock_call", _arg)){
				mod_script_call_nc("mod", "telib", "unlock_set", _arg, false);
				mod_script_call_nc("mod", "telib", "unlock_splat", "", "@w" + _arg + " @rLOCKED", -1, -1);
				sound_play(sndCursedChest);
			}
	        chat_comp_add_arg("unlocktoggle", 0, _arg, (mod_script_call_nc("mod", "telib", "unlock_get", _arg) ? "UNLOCKED" : "LOCKED"));
			return true;
            
		case "wepmerge":
			var a = string_split(_arg, "/"),
				w = wep_none;
				
			if(array_length(a) >= 2){
				w = mod_script_call_nc("mod", "telib", "wep_merge", a[0], a[1]);
			}
			else{
				w = mod_script_call_nc("mod", "telib", "wep_merge", a[0], a[0]);
			}
			
			with(instance_create(mouse_x[_ind], mouse_y[_ind], WepPickup)){
				wep = w;
				ammo = true;
			}
			return true;
    }
    
#define init
     // Charm / Top Object Spawning:
	chat_comp_add("charm", "(object)", "spawn a charmed object");
	chat_comp_add("top", "(object)", "spawn a top object");
	for(var i = 1; i < object_max; i++){
	    if(object_is_ancestor(i, hitme) || i == ReviveArea || i == NecroReviveArea || i == MaggotExplosion || i == RadMaggotExplosion){
	        chat_comp_add_arg("charm", 0, object_get_name(i));
	    }
	    chat_comp_add_arg("top", 0, object_get_name(i));
	}
    
     // Debug Lag:
    global.debug_lag = false;
    chat_comp_add("debuglag", "(mod)", "leave blank for global debugging");
    
     // Script Block Files:
    chat_comp_add("loadblock", "(file)", "file in scripts folder");
    with(["general", "weps", "misc"]){
        chat_comp_add_arg("loadblock", 0, self);
    }
    
     // Pets:
    chat_comp_add("pet", "(name)", "name of pet");
    with(["Scorpion", "Parrot", "CoolGuy", "Salamander", "Mimic", "Slaughter", "Octo", "Spider", "Prism", "Weapon", "Orchid"]){
        chat_comp_add_arg("pet", 0, self);
    }
    
     // Unlocks:
    global.unlock = ["parrot", "parrotB", "bee", "beeB", "coastWep", "oasisWep", "trenchWep", "lairWep", "lairCrown", "boneScythe", "crownCrime"];
    chat_comp_add("unlocktoggle", "(unlock name)", "toggle an unlock");
    with(global.unlock){
	    chat_comp_add_arg("unlocktoggle", 0, self, (mod_script_call_nc("mod", "telib", "unlock_get", self) ? "UNLOCKED" : "LOCKED"));
    }
    chat_comp_add("unlockall");
    chat_comp_add("unlockreset");
    
     // Weapon Merging:
    chat_comp_add("wepmerge", "(stock)", "/", "(front)", "spawn a merged weapon");
    for(var i = 1; i <= 127; i++){
        var t = string_replace_all(string_lower(weapon_get_name(i)), " ", "_");
        chat_comp_add_arg("wepmerge", 0, t);
        chat_comp_add_arg("wepmerge", 2, t);
    }
    
#macro lnbreak chr(13) + chr(10)

#define scriptblock_file_load(_path)
    /*
        Loads a scriptblock file
        
        File Elements:
            path
            - The files to edit
            - "array_flatten()" is called on this
            script
            - New script block
            - Scripts not mentioned in this block that existed in the file's block are pushed to the end, not removed
            remove
            - Scripts to remove from the file's script block
            - Traces line numbers where script is mentioned for easier manual deletion
            rename
            - Renames all whole word mentions of a script in a file
            - Traces line numbers of edge cases
            
        File Example:
            "path" : ["file1.mod", "file2.race"]
            
            "script" : "
            #macro  macroA                  5
            #define scriptA(a, b, c)        return mod_script_call("mod", "telib", "scriptA", a, b, c);
            ",
            
            "remove" : [
                "insert_script",
                "scrNamesHere"
            ],
            
            "rename" : {
                "script_original" : "scr_rename"
            }
    */
    
    if(fork()){
        file_load(_path);
        while(!file_loaded(_path)) wait 0;
        
        if(file_exists(_path)){
	        var _info = json_decode("{" + string_load(_path) + "}");
	        if(_info != json_error){
	            var _scrt = scriptblock_decode(lq_defget(_info, "script", "")),
	                _removeList = lq_defget(_info, "remove", []),
	                _renameList = lq_defget(_info, "rename", {}),
	                _log = [
	                    _path,
	                    ""
	                    "* Script renamed on these lines",
	                    "- Script detected on these lines (requires manual deletion)",
	                    "? Script detected on these lines, but is likely part of something else (like how 'draw_sprite' is in 'draw_sprite_ext')",
	                    "",
	                    ""
	                ];
	                
	            with(_removeList) if(!lq_exists(_renameList, self)){
	                lq_set(_renameList, self, self);
	            }
	            
	            with(list_flatten(lq_defget(_info, "path", ""))){
	                var _filePath = self + ".gml";
	                
	                file_load(_filePath);
	                while(!file_loaded(_filePath)) wait 0;
	                
	                if(file_exists(_filePath)){
	                    var _fileString = string_load(_filePath),
	                        _fileScrtString = scriptblock_trim(_fileString),
	                        _fileScrt = scriptblock_decode(_fileScrtString),
	                        _fileScrtNew = {},
	                        _logTrace = [];
	                        
	                     // Backup:
	                    string_save(_fileString, "NTTE_backup/" + _filePath);
	                    
	                     // Generate New Script Block:
	                    with([_scrt, _fileScrt]){
	                        for(var i = 0; i < lq_size(self); i++){
	                            var k = lq_get_key(self, i),
	                                v = lq_get_value(self, i);
	                                
	                            if(k not in _fileScrtNew){
	                            	if(k not in _renameList){
	                                	lq_set(_fileScrtNew, k, v);
	                            	}
	                            	else{
	                            		var n = lq_get(_renameList, k);
	                            		if(n not in _scrt && !array_exists(_removeList, n)){
	                            			lq_set(_fileScrtNew, n, lq_defget(_fileScrt, n, v));
	                            		}
	                            	}
	                            }
	                        }
	                    }
	                    
	                     // Remove File's Script Block + Append New Script Block:
	                    _fileString = string_copy(_fileString, 1, string_length(string_rtrim(_fileString)) - string_length(_fileScrtString));
	                    if(string_pos(lnbreak, string_delete(_fileString, 1, string_length(_fileString) - 2)) <= 0){
	                        _fileString = string_rtrim(_fileString) + string_repeat(lnbreak, 3) + "/// Scripts" + lnbreak;
	                    }
	                    _fileString += scriptblock_encode(_fileScrtNew);
	                    
	                     // Search File for Scripts to Rename/Remove:
	                    var _parse = _fileString,
	                        _parseTrace = {};
	                        
	                    while(string_length(_parse) > 0){
	                        var _parsePos = string_length(_parse) + 1,
	                            _parseScrt = "",
	                            _parseScrtNew = "";
	                            
	                         // Find Next Appearance:
	                        for(var i = 0; i < array_length(_renameList); i++){
	                            var _name = lq_get_key(_renameList, i),
	                                _pos = string_pos(_name, _parse);
	                                
	                            if(_pos > 0 && _pos <= _parsePos){
	                                if(_pos < _parsePos || string_length(_name) >= string_length(_parseScrt)){
	                                    _parsePos = _pos;
	                                    _parseScrt = _name;
	                                    _parseScrtNew = lq_get_value(_renameList, i);
	                                }
	                            }
	                        }
	                        
	                        if(_parseScrt != ""){
	                             // Make Sure it Isn't Part of Another Name (draw_sprite in draw_sprite_ext):
	                            var _charRight = string_char_at(_parse, _parsePos + string_length(_parseScrt)),
	                                _whole = true;
	                                
	                            if(_charRight == "_" || (_charRight == string_lettersdigits(_charRight) && _charRight != "")){
	                                _whole = false;
	                            }
	                            
	                            else{
	                                for(var i = _parsePos - 1; i > 0; i--){
	                                    var _charLeft = string_char_at(_parse, i);
	                                    if(_charLeft == "_" || _charLeft == string_letters(_charLeft)){
	                                        _whole = false;
	                                        break;
	                                    }
	                                    else if(_charLeft != string_digits(_charLeft)){
	                                        break;
	                                    }
	                                }
	                            }
	                            
	                             // Next:
	                            _parse = string_delete(_parse, 1, _parsePos + string_length(_parseScrt) - 1);
	                            
	                             // Rename:
	                            if(_whole && _parseScrt != _parseScrtNew){
	                                _fileString = string_copy(_fileString, 1, (string_length(_fileString) - string_length(_parse)) - string_length(_parseScrt)) + _parseScrtNew + _parse;
	                            }
	                            
	                             // Add to Trace Log:
	                            var _traceName = (_whole ? ((_parseScrt != _parseScrtNew) ? "*" : "-") : "?") + ` ${_parseScrt}: `,
	                                _line = 1 + (string_count(lnbreak, _fileString) - string_count(lnbreak, _parse));
	                                
	                            if(!lq_exists(_parseTrace, _traceName)){
	                                lq_set(_parseTrace, _traceName, []);
	                            }
	                            
	                            var _lineList = lq_get(_parseTrace, _traceName);
	                            if(!array_exists(_lineList, _line)){
	                                array_push(_lineList, _line);
	                            }
	                        }
	                        
	                        else break;
	                    }
	                    
	                     // Save File:
	                    var _pathSave = "NTTE/" + _filePath,
	                        _pathMods = "../../mods/" + _pathSave;
	                        
	                    file_load(_pathMods);
	                    while(!file_loaded(_pathMods)) wait 0;
	                    
	                    if(file_exists(_pathMods)){
	                        // Auto-replace files if stored in the AppData mods folder
	                        array_push(_logTrace, _pathSave);
	                        _pathSave = _pathMods;
	                    }
	                    else{
	                        array_push(_logTrace, `nuclearthrone/data/${mod_current}.mod/${_pathSave}`);
	                    }
	                    
	                    string_save(_fileString, _pathSave);
	                    file_unload(_pathMods);
	                    
	                     // Trace:
	                    for(var i = 0; i < lq_size(_parseTrace); i++){
	                        var _trace = lq_get_key(_parseTrace, i),
	                            _lines = lq_get_value(_parseTrace, i);
	                            
	                        if(array_length(_lines) > 0){
	                            for(var j = 0; j < array_length(_lines); j++){
	                                if(j > 0) _trace += ", ";
	                                _trace += string(_lines[j]);
	                            }
	                            array_push(_logTrace, _trace);
	                        }
	                    }
	                    with(_logTrace){
	                        var _trace = self;
	                        switch(string_char_at(_trace, 1)){
	                            case "*":   trace_color(_trace, c_yellow);  break;
	                            case "-":   trace_color(_trace, c_red);     break;
	                            case "?":   /*trace_color(_trace, c_blue);*/break;
	                            default :   trace(_trace);
	                        }
	                        array_push(_log, _trace);
	                    }
	                }
	                
	                 // wtf moment:
	                else trace_error(`couldn't find "${_filePath}"`);
	                
	                 // Unload:
	                file_unload(_filePath);
	            }
	            
	             // Log Info:
	            string_save(array_join(_log, lnbreak), "log.txt");
	            trace(mod_current + ` | saved to "log.txt", old files moved to "NTTE_backup"`);
	        }
	        
	         // wtf moment:
	        else{
	            trace_error(`${_path}, "${json_error_text}"`);
	        }
        }
        
         // wtf moment:
        else{
        	trace_error(`couldn't find "${_path}"`)
        }
        
        file_unload(_path);
        
        exit;
    }
    
#define scriptblock_trim(_string)
    /*
        Trims whitespace below scriptblock and removes non-scriptblock text above scriptblock
        A scriptblock is defined as consecutive lines all starting with "#", not counting whitespace before a "#"
    */
    
    var _lineList = string_split(string_trim(_string), lnbreak),
        _lineStart = "#",
        _scrtString = "";
        
    for(var i = array_length(_lineList) - 1; i >= 0; i--){
        var _line = string_trim(_lineList[i]);
        if(string_pos(_lineStart, _line) == 1 || _line == ""){
            _scrtString = _lineList[i] + ((i < array_length(_lineList) - 1) ? lnbreak : "") + _scrtString;
        }
        else break;
    }
    
    return _scrtString;
    
#define scriptblock_decode(_string)
    /*
        Converts a scriptblock string to a scriptblock lwo
    */
    
    var _blockString = scriptblock_trim(_string),
        _scrt = {};
        
    while(string_length(_blockString) > 0){
        var _lineEnd = string_pos(lnbreak, _blockString);
        if(_lineEnd <= 0) _lineEnd = string_length(_blockString) + 1;
        var _line = string_copy(_blockString, 1, _lineEnd - 1);
        
        if(string_trim(_line) != ""){
             // Fetch Script Name:
            var _name = "";
            if(string_pos(" ", _line) > 0){
                _name = string_trim(string_delete(_line, 1, string_pos(" ", _line)));
                for(var i = 1; i < string_length(_name); i++){
                    var _nameChar = string_char_at(_name, i);
                    if(
                        (_nameChar != "_" && string_lettersdigits(_nameChar) != _nameChar)
                        ||
                        (i <= 1 && string_digits(_nameChar) == _nameChar)
                    ){
                        _name = string_copy(_name, 1, i - 1);
                        break;
                    }
                }
            }
            
             // Add to List:
            lq_set(_scrt, _name, _line);
        }
        
         // Delete Line:
        _blockString = string_delete(_blockString, 1, _lineEnd + 1);
    }
    
    return _scrt;
    
#define scriptblock_encode(_scrt)
    /*
        Converts a scriptblock lwo to a scriptblock string
    */

    var _string = "";
    for(var i = 0; i < lq_size(_scrt); i++){
        if(i > 0) _string += lnbreak;
        _string += lq_get_value(_scrt, i);
    }
    return _string;
    
#define list_flatten(_list)
    /*
        [{ a: "wtf", b:[{ yo: "hey" }, 2] }, [3, 4, 5], 8, [1]]   ->   ["awtf", "byohey", 2, 3, 4, 5, 8, 1]
    */

    var _listNew = [];
    
    if(is_array(_list)){
        with(_list){
            with(list_flatten(self)){
                array_push(_listNew, self);
            }
        }
    }
    else if(is_object(_list)){
        for(var i = 0; i < lq_size(_list); i++){
            with(list_flatten(lq_get_value(_list, i))){
                array_push(_listNew, (is_string(self) ? lq_get_key(_list, i) + self : self));
            }
        }
    }
    else{
        array_push(_listNew, _list);
    }
    
    return _listNew;
    
#define array_exists(_array, _value)
    return (array_find_index(_array, _value) >= 0);
	
#define trace_error(_string)
    trace_color(`${mod_current} | ${_string}`, c_red);
    