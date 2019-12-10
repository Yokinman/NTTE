#define init
    global.sprWep = sprite_add_weapon("../sprites/weps/sprBatDiscCannon.png", 13, 6);
    global.sprWepLocked = mskNone;
    
    global.lwoWep = {
        wep : mod_current,
        ammo : 14,
        amax : 14,
        anam : "SAWBLADES",
        cost : 7,
        buff : false,
        canload : true
    };

#macro lwoWep global.lwoWep

#define weapon_name     return (weapon_avail() ? "SAWBLADE CANNON" : "LOCKED");
#define weapon_text     return "THEY STAND NO CHANCE";
#define weapon_type     return 0;  // None
#define weapon_load     return 20; // 0.66 Seconds
#define weapon_area     return (weapon_avail() ? 11 : -1); // 5-2
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
    var f = wepfire_init(w);
    w = f.wep;
    
     // Fire:
    if(wepammo_fire(w)){
         // Projectile:
        with(obj_create(x, y, "BatDisc")){
            direction = other.gunangle + orandom(4 * other.accuracy); // sorry smash but 32° is too much for a cannon
            creator = f.creator;
            team = other.team;
            ammo = w.cost;
            my_lwo = w;
            big = true;
            
             // Death to Free Discs:
            if(other.infammo != 0) ammo = 0;
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
        w = lq_clone(lwoWep);
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
    
     // Encourage Less Hold-Down-LMouse Play:
    if(w.canload){
        if(w.ammo <= 0) w.canload = false;
    }
    else{
         // Stop Reloading:
        if(w.ammo > 0){
            variable_instance_set(self, b + "reload", weapon_load());
            variable_instance_set(self, b + "can_shoot", false);
        }
        
         // Smokin'
        if(current_frame_active) repeat(choose(1, 2)){
            var _dir = gunangle,
                _disx = 12 - wkick,
                _disy = 2 + orandom(2),
                _x = x,
                _y = y;
                
            if(!_primary){
                if(race == "steroids"){
                    _y -= 4;
                    _disy -= 4;
                }
                else{
                    _dir = 90 + (20 * right);
                }
            }
            
            with(instance_create(_x + lengthdir_x(_disx, _dir) + lengthdir_x(_disy, _dir - (90 * right)), _y + lengthdir_y(_disx, _dir) + lengthdir_y(_disy, _dir - (90 * right)), Smoke)){
                hspeed += other.hspeed / 2;
                vspeed += other.vspeed / 2;
                motion_add(_dir, 2);
                image_xscale /= 1.5;
                image_yscale /= 1.5;
                growspeed = -0.015;
                gravity = -0.1;
            }
        }
        
         // Ammo Returned:
        if(w.ammo >= w.amax) w.canload = true;
    }


/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'telib', 'unlock_get', _unlock);
#define wepfire_init(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepfire_init', _wep);
#define wepammo_draw(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_draw', _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_fire', _wep);