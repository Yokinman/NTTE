#define init
    global.sprLightningRingLauncher = sprite_add_weapon("../sprites/weps/sprLightningRingLauncher.png", 6, 3);

#define weapon_name return "LIGHTRING LAUNCHER";
#define weapon_text return "JELLY TECHNOLOGY";
#define weapon_type return 5;   // Energy
#define weapon_cost return 3;   // 3 Ammo
#define weapon_load return 37;  // 1.23 Seconds
#define weapon_area             // Spawns naturlly only after unlock
    if !unlock_get(mod_current) return -1;
    return 9;
    
#define weapon_swap return sndSwapEnergy;
#define weapon_sprt return global.sprLightningRingLauncher;

#define weapon_reloaded
    sound_play(sndLightningReload);

#define weapon_fire
    with(obj_create(x, y, "LightningDisc")){
        motion_add(other.gunangle, 10);
        if(skill_get(mut_laser_brain)){
            charge *= 1.2;
            image_speed *= 0.75;
        }
        team = other.team;
        creator = other;
    }

     // Effects:
    sound_play_pitchvol(sndLightningCannonUpg, 0.5, 0.4);

#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "teassets", "unlock_get", _unlock);
#define unlock_set(_unlock, _value)                                                             mod_script_call("mod", "teassets", "unlock_set", _unlock, _value);