#define init
    global.sprNetLauncher = sprite_add_weapon("../sprites/weps/sprNetGun.png", 3, 2);

#define weapon_name return "NET LAUNCHER";
#define weapon_type return 3;   // Bolt
#define weapon_load return 20;  // 0.67 Seconds
#define weapon_cost return 10;   // 4 Bolts
#define weapon_sprt return global.sprNetLauncher;

#define weapon_laser_sight
    return 0;

#define weapon_fire(_wep)
     // Effects:
    weapon_post(6, 8, -20);
    sound_play(sndGrenade);
    sound_play_pitch(sndFlakCannon, 1.75 + random(0.25));
    sound_play_pitch(sndNadeReload, 0.8);

     // Shoot Harpoon:
    with(obj_create(x, y, "NetNade")){
        motion_add(other.gunangle + (random_range(-5, 5) * other.accuracy), 12);
        image_angle = direction;
        team = other.team;
        creator = other;
    }

#define obj_create(_x, _y, _object)
    return mod_script_call("mod", "telib", "obj_create", _x, _y, _object);