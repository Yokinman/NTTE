#define init
    global.sprBatDiscLauncher = sprite_add_weapon("../sprites/weps/sprBatDiscLauncher.png", 6, 5);

#macro wepLWO {
        wep  : mod_current,
        ammo : 3,
        amax : 3,
        anam : "SAWBLADES",
        cost : 1,
        buff : false
    }

#define weapon_name     return "SAWBLADE GUN";
#define weapon_text     return "LIKE DISCS BUT @ySMARTER";
#define weapon_type     return 0; // None
#define weapon_load     return 8; // 0.26 Seconds
#define weapon_area     return (unlock_get("lairWep") ? 10 : -1); // 5-2
#define weapon_melee    return false;
#define weapon_swap     return sndSwapShotgun;

#define weapon_auto(w)
    if(is_object(w) && w.ammo < w.cost) return -1;
    return true;

#define weapon_sprt(w)
    wepammo_draw(w); // Custom Ammo Drawing
    return global.sprBatDiscLauncher;

#define weapon_fire(w)
    if(!is_object(w)){
        step(true);
        w = wep;
    }

     // Fire:
    if(wepammo_fire(w)){
         // Projectile:
        with(obj_create(x, y, "BatDisc")){
            projectile_init(other.team, other);
            ammo = w.cost * (other.infammo == 0);
            my_lwo = w;

            motion_set(other.gunangle + orandom(12 * other.accuracy), maxspeed);
        }
        
         // Effects:
        weapon_post(8, 8, 8);
        motion_set(gunangle + 180, 2);
        repeat(irandom_range(3, 6)){
            with(instance_create(x, y, Smoke)){
                motion_set(other.gunangle + orandom(24), random(6));
            }
        }

         // Sounds:
        sound_play_pitchvol(sndSuperDiscGun,    0.8 + random(0.4), 0.6);
        sound_play_pitchvol(sndRocket,          1.0 + random(0.6), 0.8);
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


/// Scripts:
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call("mod", "telib", "obj_create", _x, _y, _obj);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);
#define wepammo_draw(_wep)                                                              return  mod_script_call("mod", "telib", "wepammo_draw", _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call("mod", "telib", "wepammo_fire", _wep);