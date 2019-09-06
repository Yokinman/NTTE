#define init
    global.sprWep = sprite_add_weapon("../sprites/weps/sprLightningRingLauncher.png", 6, 3);
    global.sprWepLocked = mskNone;

#define weapon_name     return (weapon_avail() ? "LIGHTRING LAUNCHER" : "LOCKED");
#define weapon_text     return "JELLY TECHNOLOGY";
#define weapon_auto     return true;
#define weapon_type     return 5;  // Energy
#define weapon_cost     return 3;  // 3 Ammo
#define weapon_load     return 37; // 1.23 Seconds
#define weapon_area     return (weapon_avail() ? 7 : -1); // 3-2
#define weapon_swap     return sndSwapEnergy;
#define weapon_sprt     return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_avail    return unlock_get("trenchWep");

#define weapon_reloaded
    sound_play(sndLightningReload);

#define weapon_fire
    var _creator = wep_creator(),
        _roids = (race == "steroids" && variable_instance_get(self, "specfiring", false));
        
     // Projectile:
    with(obj_create(x, y, "LightningDisc")){
        motion_add(other.gunangle, 10);
        if(skill_get(mut_laser_brain)){
            charge *= 1.2;
            stretch *= 1.2;
            image_speed *= 0.75;
        }
        creator = _creator;
        team = other.team;
        roids = _roids;
    }
    
     // Effects:
    sound_play_pitchvol(sndLightningCannonUpg, 0.5, 0.4);


/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define wep_creator()                                                                   return  mod_script_call(   "mod", "telib", "wep_creator");
#define unlock_get(_unlock)                                                             return  mod_script_call(   "mod", "telib", "unlock_get", _unlock);