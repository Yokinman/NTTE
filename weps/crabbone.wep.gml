#define init
    global.sprWep = sprite_add_weapon("../sprites/weps/sprBone.png", 6, 6);

#macro wepLWO {
        wep  : mod_current,
        ammo : 1
    }

#define weapon_name return "BONE";
#define weapon_text return "BONE THE FISH"; // yokin no
#define weapon_type(w)
     // Return Other Weapon's Ammo Type:
    if(instance_is(self, AmmoPickup) && instance_is(other, Player)){
        with(other) return weapon_get_type((w == wep) ? bwep : wep);
    }
    return 0; // Melee
    
#define weapon_load return 6;  // 0.2 Seconds
#define weapon_swap return sndBloodGamble;

#define weapon_area
     // Drops naturally if a player is already carrying bones:
    with(Player) with(["wep", "bwep"]){
        var w = variable_instance_get(other, self);
        
        if(lq_defget(w, "wep", w) == mod_current){
            return 4;
        }
    }
    
     // If not, it don't:
    return -1;

#define weapon_sprt(w)
     // Custom Ammo Drawing:
    if(lq_defget(w, "ammo", 0) > 1){
        wepammo_draw(w);
    }

    return global.sprWep;

#define weapon_fire(w)
    if(!is_object(w)){
        step(true);
        w = wep;
    }

     // Fire:
    if(wepammo_fire(w)){
         // Throw Bone:
        with(obj_create(x, y, "Bone")){
            motion_add(other.gunangle, 16);
            rotation = direction;
            team = other.team;
            creator = other;
            broken = (other.infammo != 0);
        }

         // Effects:
        wepangle *= -1;
        weapon_post(-10, -4, 4);
        sound_play(sndChickenThrow);
        sound_play_pitch(sndBloodGamble, 0.7 + random(0.2));
        with(instance_create(x, y, MeleeHitWall)){
            motion_add(other.gunangle, 1);
            image_angle = direction + 180;
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

     // Holdin Bone:
    if(w.ammo > 0){
         // Extend Bone:
        variable_instance_set(self, b + "wkick", min(-5, variable_instance_get(self, b + "wkick")));

         // Pickup Bones:
        if(place_meeting(x, y, WepPickup)){
            with(instances_meeting(x, y, WepPickup)){
                if(place_meeting(x, y, other)){
                    if(wep_get(wep) == mod_current){
                        w.ammo++;

                         // Epic Time:
                        if(w.ammo > stat_get("miscBone")){
                            stat_set("miscBone", w.ammo);
                        }

                         // Effects:
                        with(instance_create(x, y, DiscDisappear)) image_angle = other.rotation;
                        sound_play_pitchvol(sndHPPickup, 4, 1);
                        sound_play_pitch(sndPickupDisappear, 1.2);
                        sound_play_pitchvol(sndBloodGamble, 0.4 + random(0.2), 0.9);

                        instance_destroy();
                    }
                }
            }
        }

         // Bro don't look here:
        if(w.ammo >= 10 && !unlock_get("boneScythe")){
            variable_instance_set(id, b + "wep", "scythe");
            
             // Unlock me bro:
            unlock_set("boneScythe", true);
            scrUnlock("BONE SCYTHE", "@yPRESS E@s TO CHANGE MODES", -1, -1);
            
             // Sounds:
            sound_play_pitchvol(sndCursedChest, 1.5 + random(0.5), 0.5);
            sound_play_pitchvol(sndMutant14Turn, 1.2 + random(0.2), 0.5);
            
             // Effects:
            repeat(4){
                with(instance_create(x, y, Dust)){
                    motion_add(other.gunangle + other.wepangle, 3);
                    depth = other.depth - 1;
                }
            }
            with(instance_create(x, y, PopupText)){
                mytext = "bone scythe!";
                target = other.index;
            }
        }
    }

     // No Bones Left:
    else{
        variable_instance_set(self, b + "wep", wep_none);
        variable_instance_set(self, b + "wkick", 0);

         // Auto Swap to Secondary:
        if(_primary){
            scrSwap();

             // Prevent Shooting Until Trigger Released:
            if(wep != wep_none && fork()){
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


/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define unlock_get(_name)                                                               return  mod_script_call("mod", "telib", "unlock_get", _name);
#define unlock_set(_name, _value)                                                               mod_script_call_nc("mod", "telib", "unlock_set", _name, _value);
#define stat_get(_name)                                                                 return  mod_script_call("mod", "telib", "stat_get", _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc("mod", "telib", "stat_set", _name, _value);
#define scrUnlock(_name, _text, _sprite, _sound)                                        return  mod_script_call("mod", "ntte", "scrUnlock", _name, _text, _sprite, _sound);
#define wepammo_draw(_wep)                                                              return  mod_script_call("mod", "telib", "wepammo_draw", _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call("mod", "telib", "wepammo_fire", _wep);
#define scrSwap()                                                                       return  mod_script_call("mod", "telib", "scrSwap");
#define wep_get(_wep)                                                                   return  mod_script_call("mod", "telib", "wep_get", _wep);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call("mod", "telib", "instances_meeting", _x, _y, _obj);