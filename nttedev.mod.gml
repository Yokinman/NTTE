#macro autoReplace (player_get_alias(0) == "Yokin") // u kno im the only one that stores mods in the localappdata

#define init
    with([
        "ntte.mod.gml", "petlib.mod.gml",
        "areas/template.gml", "areas/coast.area.gml", "areas/oasis.area.gml", "areas/pizza.area.gml", "areas/secret.area.gml", "areas/trench.area.gml",
        "objects/template.gml", "objects/tecaves.mod.gml", "objects/tecoast.mod.gml", "objects/tedesert.mod.gml", "objects/tegeneral.mod.gml", "objects/teoasis.mod.gml", "objects/tesewers.mod.gml", "objects/tetrench.mod.gml",
        "races/parrot.race.gml"
    ]){
        /* script_set modifies a script if it exists, appends script to end of file if not */
        /* script_remove removes a script if it exists */

        script_set(self, "mod", "telib", "area_get_subarea", ["_area"], "return", "");
        //script_remove(self, "obj_create");
    }

#define script_set(_path, _type, _name, _scrt, _args, _return, _callType)
    if(!is_array(_args)) _args = [_args];

    wait file_load(_path);

    var _str = string_load(_path),
        _old = "",
        _new = "";

    var p = string_pos("#define " + _scrt, _str);
    if(p > 0){
        _old = string_copy(_str, p, string_pos(";", string_delete(_str, 1, p - 1)));
    }

    _new += "#define " + _scrt + "(";
    for(var i = 0; i < array_length(_args); i++){
        if(i > 0) _new += ", ";
        _new += _args[i];
    }
    _new += ")";
    _new = string_rpad(_new, " ", 88);
    _new += string_rpad(_return, " ", 8);
    _new += string_rpad("mod_script_call" + _callType + "(", " ", 19);
    _new += '"' + _type + '", "' + _name + '", "' + _scrt + '", ';
    for(var i = 0; i < array_length(_args); i++){
        if(i > 0) _new += ", ";
        _new += _args[i];
    }
    _new += ");"

    if(_old != ""){
        _str = string_replace(_str, _old, _new);
    }
    else{
        _str += chr(13) + chr(10) + _new;
    }

    string_save(_str, (autoReplace ? "../../mods/NTTE/" : "") + _path);

#define script_remove(_path, _scrt)
    wait file_load(_path);

    var _str = string_load(_path);

    var p = string_pos("#define " + _scrt, _str);
    if(p <= 0) p = string_length(_str);
    _str = string_delete(_str, p - 2, string_pos(";", string_delete(_str, 1, p - 1)) + 2);

    string_save(_str, (autoReplace ? "../../mods/NTTE/" : "") + _path);