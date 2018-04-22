#define init
    global.sprHarpoonLauncher = sprite_add_weapon("../sprites/weps/sprHarpoonLauncher.png", 6, 4);

#define weapon_name
    return "HARPOON LAUNCHER";

#define weapon_type
    return 3;

#define weapon_sprt
    return global.sprHarpoonLauncher;

#define weapon_fire(_wep)
     // Pack into Lightweight Object:
    if(!is_object(wep)){
        wep = { wep : _wep, last_harpoon : noone };
        _wep = wep;
    }

     // Effects:
    weapon_post(6, 8, -20);
    sound_play(sndCrossbow);
    sound_play_pitch(sndNadeReload, 0.8);

     // Shoot Harpoon:
    var _poon = obj_create(x, y, "PlayerHarpoon");
    with(_poon){
        motion_add(other.gunangle, 22);
        image_angle = direction;
        image_yscale = other.right;
        team = other.team;
        creator = other;
    }

     // Link Harpoons:
    with(_wep){
        if(instance_exists(last_harpoon)){
            _poon.link = last_harpoon;
            last_harpoon.link = _poon;
            last_harpoon = noone;
        }
        else{
            _poon.link = other;
            last_harpoon = _poon;
        }
    }

#define obj_create(_x, _y, _object)
    return mod_script_call("mod", "telib", "obj_create", _x, _y, _object);