#define init
    global.sprWep = sprite_add_weapon("../sprites/weps/sprHarpoonLauncher.png", 3, 4);
    global.sprWepLocked = mskNone;

#macro wepLWO {
        wep  : mod_current,
        rope : noone
    }
    
#define weapon_name     return (weapon_avail() ? "HARPOON LAUNCHER" : "LOCKED");
#define weapon_text     return "REEL IT IN";
#define weapon_type     return 3; // Bolt
#define weapon_cost     return 1; // 1 Ammo
#define weapon_load     return 5; // 0.17 Seconds
#define weapon_area     return (weapon_avail() ? 4 : -1); // 1-3
#define weapon_swap     return sndSwapBow;
#define weapon_sprt     return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_avail    return unlock_get("coastWep");

#define weapon_fire(w)
    var _creator = wep_creator(),
        _wepHeld = (variable_instance_get(_creator, "wep") == w);
    
     // LWO Setup:
    if(!is_object(w)){
        w = wepLWO;
        if(_wepHeld) _creator.wep = w;
    }
    
     // Effects:
    weapon_post(6, 8, -20);
    sound_play(sndCrossbow);
    sound_play_pitch(sndNadeReload, 0.8);

     // Projectile:
    with(obj_create(x, y, "Harpoon")){
        motion_add(other.gunangle + orandom(3 * other.accuracy), 22);
        image_angle = direction;
        creator = _creator;
        team = other.team;
        
         // Link Harpoon:
        if(_wepHeld){
            if(!instance_exists(lq_defget(w.rope, "link1", noone)) || lq_defget(w.rope, "broken", true)){
                w.rope = scrHarpoonRope(id, _creator);
            }
            else{
                array_push(rope, w.rope);
                w.rope.break_timer = 60;
                w.rope.link2 = id;
                w.rope = noone;
            }
        }
    }


/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define wep_creator()                                                                   return  mod_script_call(   "mod", "telib", "wep_creator");
#define unlock_get(_unlock)                                                             return  mod_script_call(   "mod", "telib", "unlock_get", _unlock);
#define scrHarpoonRope(_link1, _link2)                                                  return  mod_script_call("mod", "tegeneral", "scrHarpoonRope", _link1, _link2);