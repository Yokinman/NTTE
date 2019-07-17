#define init
    global.sprElectroPlasmaRifle = sprite_add_weapon("../sprites/weps/sprElectroPlasmaRifle.png", 1, 5);

#define weapon_name return "ELECTROPLASMA RIFLE";
#define weapon_text return "DEEP SEA WEAPONRY";
#define weapon_type return 5;  // Energy
#define weapon_cost return 5;  // 5 Ammo
#define weapon_load return 18; // 0.6 Seconds:
#define weapon_auto return true;
#define weapon_area return (unlock_get("trenchWep") ? 11 : -1); // 5-2
#define weapon_swap return sndSwapEnergy;
#define weapon_sprt return global.sprElectroPlasmaRifle;

#define weapon_reloaded
    sound_play(sndLightningReload);

#define weapon_fire
    if("last_electroplasma" not in self) last_electroplasma = noone;
    if("electroplasma_side" not in self) electroplasma_side = 1;
    
     // Sounds:
    var _brain = (skill_get(mut_laser_brain) > 0);
    if(_brain)  sound_play_gun(sndLightningPistolUpg,   0.4, 0.6);
    else        sound_play_gun(sndLightningPistol,      0.3, 0.3);
    
     // Burst Fire:
    var _num = 3;
    repeat(_num) if(instance_exists(self)){
        var _last = last_electroplasma;
        
         // Projectile:
        var d = gunangle + (((17 * electroplasma_side) + orandom(7)) * accuracy);
        with(obj_create(x, y, "ElectroPlasma")){
            team =          other.team;
            creator =       other;
            tethered_to =   _last;
            motion_set(d, 4 + random(0.4));
            image_angle =   direction;
            
            _last =         id;
        }
        
        last_electroplasma = _last;
        electroplasma_side *= -1;
        
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
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);