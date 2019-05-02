#define init
    global.sprLightningRingLauncher = sprite_add_weapon("../sprites/weps/sprLightningRingLauncher.png", 6, 3);

#define weapon_name return "LIGHTRING LAUNCHER";
#define weapon_text return "JELLY TECHNOLOGY";
#define weapon_type return 5;  // Energy
#define weapon_cost return 3;  // 3 Ammo
#define weapon_load return 37; // 1.23 Seconds
#define weapon_area return (unlock_get("trenchWep") ? 7 : -1); // 3-2
#define weapon_swap return sndSwapEnergy;
#define weapon_sprt return global.sprLightningRingLauncher;

#define weapon_reloaded
    sound_play(sndLightningReload);

#define weapon_fire
    var _roids = (specfiring && (race == "steroids"));

    with(obj_create(x, y, "LightningDisc")){
        motion_add(other.gunangle, 10);
        if(skill_get(mut_laser_brain)){
            charge *= 1.2;
            stretch *= 1.2;
            image_speed *= 0.75;
        }
        team = other.team;
        creator = other;
        roids = _roids;
    }

     // Effects:
    sound_play_pitchvol(sndLightningCannonUpg, 0.5, 0.4);


/// Scripts:
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call("mod", "telib", "obj_create", _x, _y, _obj);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);