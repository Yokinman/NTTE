#define init
    global.sprWep = sprite_add_weapon("../sprites/weps/sprBatTether.png", 4, 3);
    global.sprWepLocked = mskNone;

#macro wepLWO {
        wep : mod_current,
        ammo : 6,
        amax : 6,
        cost : 1,
        buff : false
    }

#define weapon_name     return (weapon_avail() ? "VAMPIRE" : "LOCKED");
#define weapon_text     return "HEMOELECTRICITY";
#define weapon_type     return 0; // None
#define weapon_load     return 5; // 0.16 Seconds
#define weapon_area     return (weapon_avail() ? 10 : -1); // 5-2
#define weapon_melee    return false;
#define weapon_swap     return sndSwapEnergy;
#define weapon_avail    return unlock_get("lairWep");

#define weapon_auto(w)
    if(is_object(w) && w.ammo < w.cost) return -1;
    return true;

#define weapon_sprt(w)
    wepammo_draw(w); // Custom Ammo Drawing
    return (weapon_avail() ? global.sprWep : global.sprWepLocked);

#define weapon_fire(w)
    if(!is_object(w)){
        step(true);
        w = wep;
    }

     // Fire:
    if(wepammo_fire(w)){
        var _roids = (specfiring && (race == "steroids"));
    
        with(obj_create(x, y, "TeslaCoil")){
            creator = other;
            roids = _roids;
            dist_max = 64;
            bat = true;
            time = 7 * (1 + skill_get(mut_laser_brain));
            if(roids) creator_offy -= 4;
        }
        
         // Refill:
        if(wep.ammo <= 0){
            wep.ammo = wep.amax * (1 + skill_get(mut_back_muscle));
            
            projectile_hit_raw(id, 1, false);
            lasthit = [global.sprWep, "PLAYING GOD"];
            
             // Hurt:
            if(my_health > 0){
                var _addVol = (my_health <= maxhealth / 2) * 0.3
                
                 // Sounds:
                sound_play_pitchvol(sndGammaGutsProc, 0.9 + random(0.3), 1.1 + _addVol);
                sound_play_pitchvol(sndHitFlesh, 0.8 + random(0.4), 0.9 + _addVol);
                
                 // Effects:
                view_shake_max_at(x, y, 12);
                sleep(24);
                
                instance_create(x, y, AllyDamage);
            }
            
             // Death FX:
            else{
                sound_play(sndGammaGutsKill);
                sound_play_pitchvol(sndHyperCrystalSearch, 0.8, 0.8);
                view_shake_max_at(x, y, 24);
                sleep(48);
            }
        }
        
         // Effects:
        if(array_length(instances_matching(instances_matching(instances_matching(instances_matching(CustomObject, "name", "TeslaCoil"), "bat", true), "creator", id), "roids", _roids)) <= 1){
            weapon_post(8, -10, 10);
    
             // Upgrade Sounds:
            if(skill_get(mut_laser_brain)){
                sound_play_pitchvol(sndBloodLauncherExplo, 0.7 + random(0.3), 0.8);
                sound_play_pitchvol(sndLightningShotgunUpg, 0.7 + random(0.4), 0.8)
            }
    
             // Default Sounds:
            else{
                sound_play_pitchvol(sndBloodLauncherExplo, 0.9 + random(0.4), 0.8);
                sound_play_pitchvol(sndLightningShotgun, 0.8 + random(0.4), 0.8)
            }
        }
        if(skill_get(mut_laser_brain)){
            instance_create(x, y, LaserBrain).creator = id; // Upgrade FX
        }
    }

#define step(_primary)
    var b = (_primary ? "" : "b"),
        w = variable_instance_get(self, b + "wep");

     // LWO Setup:
    if(!is_object(w)){
        w = wepLWO;
        variable_instance_set(self, b + "wep", w);
    }

     // Back Muscle:
    with(w){
        var _muscle = skill_get(mut_back_muscle);
        if(buff != _muscle){
            var _amaxRaw = (amax / (1 + buff));
            buff = _muscle;
            amax = (_amaxRaw * (1 + buff));
            ammo += (amax - _amaxRaw);
        }
    }


/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);
#define wepammo_draw(_wep)                                                              return  mod_script_call("mod", "telib", "wepammo_draw", _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call("mod", "telib", "wepammo_fire", _wep);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call("mod", "telib", "lightning_connect", _x1, _y1, _x2, _y2, _arc, _enemy);