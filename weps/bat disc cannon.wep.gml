#define init
    global.sprWep = sprite_add_weapon("../sprites/weps/sprBatDiscCannon.png", 13, 6);
    global.sprWepLocked = mskNone;

#macro wepLWO {
        wep : mod_current,
        ammo : 14,
        amax : 14,
        anam : "SAWBLADES",
        cost : 7,
        buff : false
    }

#define weapon_name     return (weapon_avail() ? "SAWBLADE CANNON" : "LOCKED");
#define weapon_text     return "THEY STAND NO CHANCE";
#define weapon_type     return 0;  // None
#define weapon_load     return 20; // 0.66 Seconds
#define weapon_area     return (weapon_avail() ? 13 : -1); // 6-1
#define weapon_melee    return false;
#define weapon_swap     return sndSwapShotgun;
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
         // Projectile:
        with(obj_create(x, y, "BatDisc")){
            projectile_init(other.team, other);
            ammo = w.cost * (other.infammo == 0);
            my_lwo = w;
            big = true;

            motion_set(other.gunangle + orandom(4 * other.accuracy), maxspeed); // sorry smash but 32° is too much for a cannon
        }

         // Effects:
        weapon_post(12, 16, 12);
        motion_set(gunangle + 180, 4);
        repeat(irandom_range(4, 8)){
            with(instance_create(x, y, Smoke)){
                motion_set(other.gunangle + orandom(32), random(8));
            }
        }

         // Sounds:
        sound_play_pitchvol(sndSuperDiscGun,    0.6 + random(0.4), 0.6);
        sound_play_pitchvol(sndNukeFire,        1.0 + random(0.6), 0.8);
        sound_play_pitchvol(sndEnergyHammerUpg, 0.8 + random(0.4), 0.6);
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