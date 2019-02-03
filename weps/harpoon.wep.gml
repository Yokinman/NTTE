#define init
    global.sprHarpoonLauncher = sprite_add_weapon("../sprites/weps/sprHarpoonLauncher.png", 3, 4);

#define weapon_name return "HARPOON LAUNCHER";
#define weapon_type return 3;   // Bolt
#define weapon_load return 2;   // 0.07 Seconds
#define weapon_area             // Spawns naturlly only after unlock
    if !unlock_get(mod_current) return -1;
    return 2;
    
#define weapon_swap return sndSwapBow;
#define weapon_sprt return global.sprHarpoonLauncher;

#define weapon_fire(_wep)
     // Pack into Lightweight Object:
    if(!is_object(wep)){
        wep = { wep : _wep, link : noone, rope : noone };
        _wep = wep;
    }

     // Effects:
    weapon_post(6, 8, -20);
    sound_play(sndCrossbow);
    sound_play_pitch(sndNadeReload, 0.8);

     // Shoot Harpoon:
    with(obj_create(x, y, "Harpoon")){
        motion_add(other.gunangle + (random_range(-3, 3) * other.accuracy), 22);
        image_angle = direction;
        image_yscale = other.right;
        team = other.team;
        creator = other;

         // Link Harpoon:
        if(!instance_exists(_wep.link)){
            rope = scrHarpoonRope(id, other);
            _wep.rope = rope;
            _wep.link = id;
        }
        else{
            rope[array_length(rope)] = _wep.rope;
            _wep.rope.link2 = id;
            _wep.link = noone;
            _wep.rope = noone;
        }
        with(rope){
            break_timer = 90;
            creator = other.creator;
        }
    }

#define scrHarpoonRope(_link1, _link2)                                                  return  mod_script_call("mod", "telib", "scrHarpoonRope", _link1, _link2);
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "teassets", "unlock_get", _unlock);
#define unlock_set(_unlock, _value)                                                             mod_script_call("mod", "teassets", "unlock_set", _unlock, _value);