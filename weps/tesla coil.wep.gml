#define init
    global.sprTeslaCoil = sprite_add_weapon("../sprites/weps/sprTeslaCoil.png", 5, 2);

#define weapon_name return "TESLA COIL";
#define weapon_text return "SMART LIGHTNING";
#define weapon_auto return true;
#define weapon_type return 5;
#define weapon_cost return 1;
#define weapon_load return 7;
#define weapon_area return (unlock_get(mod_current) ? 9 : -1);
#define weapon_swap return sndSwapEnergy;
#define weapon_sprt return global.sprTeslaCoil;

#define weapon_fire
    var _key = (specfiring ? "spec" : "fire");
    
    if(!array_length(instances_matching(instances_matching(instances_matching(CustomObject, "name", "TeslaCoil"), "creator", id), "key", _key))){
        with(obj_create(x, y, "TeslaCoil")){
            creator = other;
            key = _key; 
        }
        
        motion_add(gunangle, -3);
        
         // Upgrade Sounds:
        if(skill_get(mut_laser_brain)){
            sound_play_pitchvol(sndGuitarHit7,          2.4 + random(0.4),  0.6);
            sound_play_pitchvol(sndLightningRifle,      0.8 + random(0.4),  0.8);
            sound_play_pitchvol(sndDevastatorExplo,     1.4 + random(0.4),  0.6);
        }
        
         // Default Sounds:
        else{
            sound_play_pitchvol(sndGuitarHit6,          2.4 + random(0.4),  0.6);
            sound_play_pitchvol(sndLightningRifle,      1.2 + random(0.4),  1.0);
        }
    }


/// Scripts:
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call("mod", "telib", "obj_create", _x, _y, _obj);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);