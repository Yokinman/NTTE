#define init
    global.sprWep = sprite_add_weapon("../sprites/weps/sprTeslaCoil.png", 5, 2);
    global.sprWepLocked = mskNone;

#define weapon_name     return (weapon_avail() ? "TESLA COIL" : "LOCKED");
#define weapon_text     return "LIMITED POWER";
#define weapon_auto     return true;
#define weapon_type     return 5; // Energy
#define weapon_cost     return 2; // 2 Ammo
#define weapon_load     return 8; // 0.27 Seconds
#define weapon_area     return (weapon_avail() ? 11 : -1); // 5-2
#define weapon_swap     return sndSwapEnergy;
#define weapon_sprt     return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_avail    return unlock_get("trenchWep");

#define weapon_reloaded
    sound_play_pitchvol(sndLightningReload, 0.5 + random(0.5), 0.8);

#define weapon_fire(w)
    var f = wepfire_init(w);
    w = f.wep;
    
     // Projectile:
    var _xdis, _ydis;
    with(obj_create(x, y, "TeslaCoil")){
        direction = other.gunangle;
        creator = f.creator;
        team = other.team;
        roids = f.roids;
        if(roids) creator_offy -= 4;
        
        _xdis = creator_offx;
        _ydis = creator_offy;
    }
    
     // Effects:
    if(array_length(instances_matching(instances_matching(instances_matching(instances_matching(CustomObject, "name", "TeslaCoil"), "bat", false), "creator", f.creator), "roids", f.roids)) <= 1){
        weapon_post(8, -10, 10);
        
         // Ball Appear FX:
        _ydis *= variable_instance_get(f.creator, "right", 1);
        with(instance_create(
            x + lengthdir_x(_xdis, gunangle) + lengthdir_x(_ydis, gunangle - 90),
            y + lengthdir_y(_xdis, gunangle) + lengthdir_y(_ydis, gunangle - 90) - (4 * f.roids),
            LightningHit
        )){
            motion_add(other.gunangle, 0.5);
        }
        
         // Upgrade Sounds:
        if(skill_get(mut_laser_brain)){
            sound_play_pitchvol(sndGuitarHit7,          2.4 + random(0.4),  0.6);
            sound_play_pitchvol(sndLaserUpg,            0.8 + random(0.2),  0.6);
            sound_play_pitchvol(sndDevastatorExplo,     1.4 + random(0.4),  0.6);
        }
        
         // Default Sounds:
        else{
            sound_play_pitchvol(sndGuitarHit6,          1.6 + random(0.4),  0.4);
            sound_play_pitchvol(sndLaser,               1.4 + random(0.4),  1.0);
        }
    }


/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define wepfire_init(_wep)                                                              return  mod_script_call(   "mod", "telib", "wepfire_init", _wep);
#define unlock_get(_unlock)                                                             return  mod_script_call(   "mod", "telib", "unlock_get", _unlock);