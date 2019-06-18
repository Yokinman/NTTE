#define init
    global.sprBatTether = sprite_add_weapon("../sprites/weps/sprBatTether.png", 4, 3);

#macro wepLWO {wep : mod_current, ammo : maxAmmo}
#macro maxAmmo 6
#macro wepCost 1

#define weapon_name return "VAMPIRE";
#define weapon_text return "HEMOELECTRICITY";
#define weapon_auto return true;
#define weapon_type return 0; // None
#define weapon_load return 5; // 0.16 Seconds
#define weapon_area return (unlock_get("lairWep") ? 10 : -1); // 5-2
#define weapon_melee return false;
#define weapon_swap return sndSwapEnergy;
#define weapon_sprt return internalAmmoSprite(argument0, lq_defget(argument0, "ammo", maxAmmo), maxAmmo, global.sprBatTether);

#define weapon_fire
    if(!is_object(wep)) wep = wepLWO;
    
     // Fire:
    internalAmmoFire(wep, wepCost * (infammo == 0), false);
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
        wep.ammo = maxAmmo * (1 + skill_get(mut_back_muscle));
        
        projectile_hit_raw(id, 1, false);
        lasthit = [global.sprBatTether, "PLAYING GOD"];
        
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
        
         // Death:
        else{
            
             // Sounds:
            sound_play(sndGammaGutsKill);
            sound_play_pitchvol(sndHyperCrystalSearch, 0.8, 0.8);
            
             // Effects:
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
    
     // Effects:
    if(skill_get(mut_laser_brain)){
         // Upgrade effects:
        instance_create(x, y, LaserBrain).creator = id;
    }
    
/// Scripts:
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);
#define internalAmmoSprite(_weapon, _ammo, _maxAmmo, _sprite)                           return  mod_script_call("mod", "telib", "internalAmmoSprite", _weapon, _ammo, _maxAmmo, _sprite);
#define internalAmmoFire(_weapon, _cost, _emptyFX)                                      return  mod_script_call("mod", "telib", "internalAmmoFire", _weapon, _cost, _emptyFX);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call("mod", "telib", "lightning_connect", _x1, _y1, _x2, _y2, _arc, _enemy);