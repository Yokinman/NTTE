#define init
    global.sprBone = sprite_add_weapon("../sprites/weps/sprBone.png", 6, 6);

     // Global Step:
    while(true){
        with(WepPickup) if(is_object(wep)){
            if(wep_get(wep) == mod_current && lq_defget(wep, "ammo", 1) > 1){
                wep.ammo--;
                with(instance_create(x, y, WepPickup)) wep = mod_current;
            }
        }
        wait 1;
    }

#define weapon_name return "BONE";
#define weapon_text return "BONE THE FISH";
#define weapon_type return 0;   // Melee
#define weapon_load return 6;   // 0.20 Seconds
#define weapon_area return -1;  // Doesn't spawn normally
#define weapon_swap return sndBloodGamble;
#define weapon_sprt return global.sprBone;

#define weapon_fire(_wep)
    if(!is_object(_wep)){
        step(true);
        _wep = wep;
    }
    _wep.ammo--;

     // Throw Bone:
    with(obj_create(x, y, "Bone")){
        motion_add(other.gunangle, 16);
        rotation = direction;
        team = other.team;
        creator = other;
    }

    weapon_post(-10, -4, 4);
    wepangle *= -1;

     // Effects:
    sound_play(sndChickenThrow);
    sound_play_pitch(sndBloodGamble, 0.7 + random(0.2));
    with(instance_create(x, y, MeleeHitWall)){
        motion_add(other.gunangle, 1);
        image_angle = direction + 180;
    }

#define step(_primary)
    var _throwWep = false,
        w = { wep : mod_current, ammo : 1 };

    if(_primary){
        wkick = min(-5, wkick);
        if(!is_object(wep)) wep = w;
        w = wep;
        if(wep.ammo <= 0){
            wep = 0;

             // Swap:
            scrSwap();

             // Prevent Shooting Until Trigger Released:
            if(wep != 0 && fork()){
                while(instance_exists(self) && canfire && button_check(index, "fire")){
            		reload = max(2, reload);
            		can_shoot = 0;
            		clicked = 0;
                    wait 0;
                }
                exit;
            }
        }
    }
    else{
        bwkick = min(-5, bwkick);
        if(!is_object(bwep)) bwep = w;
        w = bwep;
        if(bwep.ammo <= 0) bwep = 0;
    }

     // Pickup Bones:
    if(place_meeting(x, y, WepPickup)){
        with(WepPickup) if(place_meeting(x, y, other)){
            if(wep_get(wep) == mod_current){
                w.ammo++;
                with(instance_create(x, y, DiscDisappear)) image_angle = other.rotation;
                sound_play_pitchvol(sndHPPickup, 4, 1);
                sound_play_pitch(sndPickupDisappear, 1.2);
                sound_play_pitchvol(sndBloodGamble, 0.4 + random(0.2), 0.9);
                instance_destroy();
            }
        }
    }


/// Scripts:
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call("mod", "telib", "obj_create", _x, _y, _obj);
#define scrSwap()                                                                       return  mod_script_call("mod", "telib", "scrSwap");
#define wep_get(_wep)                                                                   return mod_script_call("mod", "telib", "wep_get", _wep);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);