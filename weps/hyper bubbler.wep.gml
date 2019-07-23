#define init
    global.sprWep = sprite_add_weapon("../sprites/weps/sprHyperBubbler.png", 8, 4);
    global.sprWepLocked = mskNone;

#define weapon_name     return (weapon_avail() ? "HYPER BUBBLER" : "LOCKED");
#define weapon_text     return "POWER WASHER";
#define weapon_type     return 4; // Explosive
#define weapon_cost     return 4; // 4 Ammo
#define weapon_load     return 7; // 0.43 Seconds
#define weapon_area     return (weapon_avail() ? 15 : -1); // 7-2
#define weapon_swap     return sndSwapExplosive;
#define weapon_sprt     return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_avail    return unlock_get("oasisWep");

#define weapon_fire(_wep)
     // Muzzle Explosion:
    var l = 20,
        d = gunangle + (accuracy * orandom(3));
    with(obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "HyperBubble")){
        team    = other.team;
        creator = other;
        
        direction = d;
    }
    
     // Effects:
    weapon_post(10, 20, 5);
    motion_add(d + 180, 4);
    sleep(35);
    
     // Sounds:
    sound_play_pitchvol(sndPlasmaRifle,     0.9 + random(0.3), 1.0);
    sound_play_pitchvol(sndHyperSlugger,    0.9 + random(0.3), 0.6);

/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);