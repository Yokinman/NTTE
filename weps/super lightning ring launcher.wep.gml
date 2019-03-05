#define init
    global.sprSuperLightningRingLauncher = sprite_add_weapon("../sprites/weps/sprSuperLightningRingLauncher.png", 7, 4);

#define weapon_name return "SUPER LIGHTRING LAUNCHER";
#define weapon_text return "EYE OF THE STORM";
#define weapon_type return 5;  // Energy
#define weapon_cost return 8;  // 8 Ammo
#define weapon_load return 90; // 3 Seconds
#define weapon_area return (unlock_get(mod_current) ? 15 : -1);
#define weapon_swap return sndSwapEnergy;
#define weapon_sprt return global.sprSuperLightningRingLauncher;

#define weapon_reloaded
    sound_play(sndLightningReload);

#define weapon_fire
    with(obj_create(x, y, "LightningDisc")){
        motion_add(other.gunangle, 14);
        maxspeed = 2.5;
        charge *= 2.5;
        charge_spd /= 2;
        stretch = 1.2;
        radius = 16;
        if(skill_get(mut_laser_brain)){
            charge *= 1.2;
            stretch *= 1.2;
            image_speed *= 0.75;
        }
        team = other.team;
        creator = other;
        super = 1.2;
    }

     // Effects:
    sound_play_pitchvol(sndLightningCannon, 1.5, 0.6)
    sound_play_pitchvol(sndLightningCannonUpg, 0.5, 0.4);


/// Scripts:
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call("mod", "telib", "obj_create", _x, _y, _obj);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);