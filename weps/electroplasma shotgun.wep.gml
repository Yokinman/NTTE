#define init
    global.sprElectroPlasmaShotgun = sprite_add_weapon("../sprites/weps/sprElectroPlasmaShotgun.png", 9, 8);

#define weapon_name return "ELECTROPLASMA SHOTGUN";
#define weapon_text return "WHERE'S THE PEANUT BUTTER";
#define weapon_type return 5;  // Energy
#define weapon_cost return 8;  // 8 Ammo
#define weapon_load return 18; // 0.6 Seconds
#define weapon_area return (unlock_get("trenchWep") ? 12 : -1); // 5-2
#define weapon_swap return sndSwapEnergy;
#define weapon_sprt return global.sprElectroPlasmaShotgun;

#define weapon_reloaded
    sound_play(sndLightningReload);

#define weapon_fire
     // Sounds:
    var _brain = (skill_get(mut_laser_brain) > 0);
    if(_brain)  sound_play_gun(sndLightningShotgunUpg,  0.4, 0.6);
    else        sound_play_gun(sndLightningShotgun,     0.3, 0.3);
    sound_play_pitch(sndPlasmaBig, 1.1 + random(0.3));
    
     // Effects:
    weapon_post(8, 6, 0);
    motion_add(gunangle, -4);
    
     // Spread Fire:
    var _last = noone,
        _num = 5;
    for(var i = floor(_num / 2) * -1; i <= floor(_num / 2); i++){
        
         // Projectile:
        with(obj_create(x, y, "ElectroPlasma")){
            team =          other.team;
            creator =       other;
            tethered_to =   _last;
            motion_set(other.gunangle + (20 * i) + (orandom(6) * other.accuracy), 4 + random(0.8));
            image_angle =   direction;
            
            _last =         id;
        }
    }
    
/// Scripts:
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);