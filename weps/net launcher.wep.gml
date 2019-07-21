#define init
    global.sprWep = sprite_add_weapon("../sprites/weps/sprNetGun.png", 3, 2);
    global.sprWepLocked = global.sprWep;
    wait(30) global.sprWepLocked = wep_locked_sprite(mod_current, global.sprWep);

#define weapon_unlocked return unlock_get("coastWep");

#define weapon_name return (weapon_unlocked() ? "NET LAUNCHER" : "LOCKED");
#define weapon_text return "CATCH OF THE DAY";
#define weapon_type return 3;  // Bolt
#define weapon_cost return 10; // 10 Ammo
#define weapon_load return 36; // 1.2 Seconds
#define weapon_area return (weapon_unlocked() ? 6 : -1); // 3-1
#define weapon_swap return sndSwapExplosive;
#define weapon_sprt return (weapon_unlocked() ? global.sprWep : global.sprWepLocked);

#define weapon_laser_sight
    return false;

#define weapon_fire(_wep)
     // Shoot Harpoon:
    with(obj_create(x, y, "NetNade")){
        motion_add(other.gunangle + orandom(5 * other.accuracy), 16);
        image_angle = direction;
        team = other.team;
        creator = other;
    }

     // Effects:
    weapon_post(6, 8, -20);
    sound_play(sndGrenade);
    sound_play_pitch(sndFlakCannon, 1.75 + random(0.25));
    sound_play_pitch(sndNadeReload, 0.8);


/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);
#define wep_locked_sprite(_wepName, _wepSprite)                                         return  mod_script_call("mod", "teassets", "wep_locked_sprite", _wepName, _wepSprite);