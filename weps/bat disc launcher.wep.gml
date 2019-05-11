#define init
    global.sprBatDiscLauncher = sprite_add_weapon("../sprites/weps/sprBatDiscLauncher.png", 6, 5);

#macro wepLWO {wep : mod_current, ammo : maxAmmo, buff : muscle}
#macro maxAmmo (3 + buffAmmo * muscle)
#macro wepCost 1
#macro buffAmmo 3

#macro muscle skill_get(mut_back_muscle)

#define weapon_name return "SAWBLADE GUN";
#define weapon_text return "LIKE DISCS BUT @ySMARTER";
#define weapon_auto return true;
#define weapon_type return 0; // None
#define weapon_load return 8; // 0.26 Seconds
#define weapon_area return (unlock_get("lairWep") ? 10 : -1); // 5-2
#define weapon_melee return false;
#define weapon_swap return sndSwapShotgun;
#define weapon_sprt return internalAmmoSprite(argument0, lq_defget(argument0, "ammo", maxAmmo), maxAmmo, global.sprBatDiscLauncher);

#define step(_pwep)
     // Back muscle:
    var _wep = variable_instance_get(id, ["bwep", "wep"][_pwep]);
    if(is_object(_wep)){
        if(_wep.buff != muscle){
            
            var _unbuff = round(buffAmmo * _wep.buff)
            
             // Account for preexisting projectiles:
            with(instances_matching(instances_matching(CustomProjectile, "name", "BatDisc"), "my_lwo", _wep)){
                _unbuff -= ammo;
                ammo = 0;
                
                if(_unbuff <= _wep.ammo) break;
            }
            
            _wep.ammo -= _unbuff;
            _wep.buff = muscle;
            _wep.ammo += round(buffAmmo * muscle);
        }
    }
    
     // Set clicked:
    if(button_pressed(index, ["spec", "fire"][_pwep])) bat_clicked = true;

#define weapon_fire
    if(!is_object(wep)) wep = wepLWO;
    
     // Fire:
    if(internalAmmoFire(wep, wepCost, variable_instance_get(id, "bat_clicked", false))){
         // Projectile:
        with(obj_create(x, y, "BatDisc")){
            projectile_init(other.team, other);
            my_lwo = other.wep;
            ammo = (other.infammo == 0) * wepCost;
            
            motion_set(other.gunangle + orandom(12) * other.accuracy, maxspeed);
        }
        
         // Effects:
        weapon_post(8, 8, 8);
        motion_set(gunangle, -2);
        
        repeat(3 + irandom(3)) with(instance_create(x, y, Smoke)) motion_set(other.gunangle + orandom(24), random(6));
        
         // Sounds:
        sound_play_pitchvol(sndSuperDiscGun,    0.8 + random(0.4), 0.6);
        sound_play_pitchvol(sndRocket,          1.0 + random(0.6), 0.8);
    }
    
     // Reset clicked:
    bat_clicked = false;

/// Scripts:
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call("mod", "telib", "obj_create", _x, _y, _obj);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);
#define internalAmmoSprite(_weapon, _ammo, _maxAmmo, _sprite)                           return  mod_script_call("mod", "telib", "internalAmmoSprite", _weapon, _ammo, _maxAmmo, _sprite);
#define internalAmmoFire(_weapon, _cost, _emptyFX)                                      return  mod_script_call("mod", "telib", "internalAmmoFire", _weapon, _cost, _emptyFX);