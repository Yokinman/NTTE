#define init
    global.sprTeslaCoil = sprite_add_weapon("../sprites/weps/sprTeslaCoil.png", 5, 2);

#define weapon_name return "TESLA COIL";
#define weapon_text return "SMART LIGHTNING";
#define weapon_auto return true;
#define weapon_type return 5;
#define weapon_cost return 2; // could b too much
#define weapon_load return 8;
#define weapon_area return (unlock_get(mod_current) ? 9 : -1);
#define weapon_swap return sndSwapEnergy;
#define weapon_sprt return global.sprTeslaCoil;

#define weapon_reloaded
    sound_play_pitchvol(sndLightningReload, 0.5 + random(0.5), 0.8);

#define weapon_fire
    var _roids = (specfiring && (race == "steroids")),
        _xdis, _ydis;

    with(obj_create(x, y, "TeslaCoil")){
        creator = other;
        roids = _roids;
        if(roids) creator_offy -= 4;
        
        _xdis = creator_offx;
        _ydis = creator_offy;
    }

     // Effects:
    if(array_length(instances_matching(instances_matching(instances_matching(CustomObject, "name", "TeslaCoil"), "creator", id), "roids", _roids)) <= 1){
        weapon_post(8, -10, 10);

         // Ball Appear FX:
        _ydis *= right;
        with(instance_create(
            x + lengthdir_x(_xdis, gunangle) + lengthdir_x(_ydis, gunangle - 90),
            y + lengthdir_y(_xdis, gunangle) + lengthdir_y(_ydis, gunangle - 90) - (_roids ? 4 : 0),
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


/// Scripts:
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call("mod", "telib", "obj_create", _x, _y, _obj);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);