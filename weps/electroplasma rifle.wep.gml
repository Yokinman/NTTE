#define init
    global.sprWep = sprite_add_weapon("../sprites/weps/sprElectroPlasmaRifle.png", 1, 5);
    global.sprWepLocked = mskNone;

#define weapon_name     return (weapon_avail() ? "ELECTROPLASMA RIFLE" : "LOCKED");
#define weapon_text     return "DEEP SEA WEAPONRY";
#define weapon_type     return 5;  // Energy
#define weapon_cost     return 5;  // 5 Ammo
#define weapon_load     return 18; // 0.6 Seconds:
#define weapon_auto     return true;
#define weapon_area     return (weapon_avail() ? 11 : -1); // 5-2
#define weapon_swap     return sndSwapEnergy;
#define weapon_sprt     return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_avail    return unlock_get("trenchWep");

#define weapon_reloaded
    sound_play(sndLightningReload);

#define weapon_fire
    var _creator = wep_creator(),
        _brain = (skill_get(mut_laser_brain) > 0);
        
     // Sounds:
    if(_brain) sound_play_gun(sndLightningPistolUpg, 0.4, 0.6);
    else       sound_play_gun(sndLightningPistol,    0.3, 0.3);
    
     // Burst Fire:
    var _num = 3;
    repeat(_num) if(instance_exists(self)){
         // Projectile:
        var _last = variable_instance_get(_creator, "electroplasma_last", noone),
            _side = variable_instance_get(_creator, "electroplasma_side", 1),
            _dir = gunangle + (((17 * _side) + orandom(7)) * accuracy);
            
        with(obj_create(x, y, "ElectroPlasma")){
            motion_set(_dir, 4 + random(0.4));
            image_angle = direction;
            creator = _creator;
            team = other.team;

             // Tether Together:
            tether_inst = _last;
            _last = id;
        }
        with(_creator){
            electroplasma_last = _last;
            electroplasma_side = -_side;
        }
        
         // Effects:
        weapon_post(6, 3, 0);
        motion_add(gunangle, -3);
        
         // Sounds:
        sound_play_pitch(sndEliteShielderFire, 0.9 + random(0.3));
        sound_play_pitch(sndGammaGutsProc, 1.0 + random(0.2));
        
        wait(3);
    }


/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define wep_creator()                                                                   return  mod_script_call(   "mod", "telib", "wep_creator");
#define unlock_get(_unlock)                                                             return  mod_script_call(   "mod", "telib", "unlock_get", _unlock);