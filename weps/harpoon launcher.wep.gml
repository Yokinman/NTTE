#define init
    global.sprWep = sprite_add_weapon("../sprites/weps/sprHarpoonLauncher.png", 3, 4);
    global.sprWepLocked = global.sprWep;
    wait(30) global.sprWepLocked = wep_locked_sprite(mod_current, global.sprWep);

#define weapon_unlocked return unlock_get("coastWep");

#define weapon_name return (weapon_unlocked() ? "HARPOON LAUNCHER" : "LOCKED");
#define weapon_text return "REEL IT IN";
#define weapon_type return 3; // Bolt
#define weapon_cost return 1; // 1 Ammo
#define weapon_load return 5; // 0.17 Seconds
#define weapon_area return (weapon_unlocked() ? 4 : -1); // 1-3
#define weapon_swap return sndSwapBow;
#define weapon_sprt return (weapon_unlocked() ? global.sprWep : global.sprWepLocked);

#define weapon_fire(_wep)
     // Pack into Lightweight Object:
    if(!is_object(wep)){
        wep = { wep : _wep, rope : noone };
        _wep = wep;
    }

     // Effects:
    weapon_post(6, 8, -20);
    sound_play(sndCrossbow);
    sound_play_pitch(sndNadeReload, 0.8);

     // Shoot Harpoon:
    with(obj_create(x, y, "Harpoon")){
        motion_add(other.gunangle + orandom(3 * other.accuracy), 22);
        image_angle = direction;
        image_yscale = other.right;
        team = other.team;
        creator = other;

         // Link Harpoon:
        if(!instance_exists(lq_defget(_wep.rope, "link1", noone)) || lq_defget(_wep.rope, "broken", true)){
            _wep.rope = scrHarpoonRope(id, other);
        }
        else{
            array_push(rope, _wep.rope);
            _wep.rope.break_timer = 60;
            _wep.rope.link2 = id;
            _wep.rope = noone;
        }
    }


/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);
#define scrHarpoonRope(_link1, _link2)                                                  return  mod_script_call("mod", "tegeneral", "scrHarpoonRope", _link1, _link2);
#define wep_locked_sprite(_wepName, _wepSprite)                                         return  mod_script_call("mod", "teassets", "wep_locked_sprite", _wepName, _wepSprite);