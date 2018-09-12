#define init
    global.sprBubbleMinigun = sprite_add_weapon("../sprites/weps/sprBubbleMinigun.png", 3, 3);

#define weapon_name return "BUBBLE MINIGUN";
#define weapon_type return 4;   // Explosive
#define weapon_cost return 1;   // 1 Ammo
#define weapon_load return 1;   // 0.03 Seconds
#define weapon_area return -1;  // Doesn't spawn normally
#define weapon_auto return true;
#define weapon_sprt return global.sprBubbleMinigun;
#define weapon_text return "SUMMERTIME FUN";

#define weapon_reloaded
    var _dis = sprite_get_width(weapon_sprt()),
        _dir = gunangle;

    instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Bubble);
    sound_play_pitchvol(sndOasisExplosionSmall, 1.3, 0.4);

#define weapon_fire(_wep)
    with(obj_create(x, y, "BubbleBomb")){
        move_contact_solid(other.gunangle, 6);
        motion_add(other.gunangle + (orandom(8) * other.accuracy), 10);
        friction *= random_range(0.8, 1.2);
        team = other.team;
        creator = other;
    }

     // Effects:
    var _pitch = random_range(0.8, 1.2);
    sound_play_pitch(sndOasisCrabAttack,        0.7 * _pitch);
    sound_play_pitch(sndOasisExplosionSmall,    0.7 * _pitch);
    sound_play_pitch(sndSuperSplinterGun,       1.4 * _pitch);
    weapon_post(5, -5, 10);

#define orandom(n)
    return random_range(-n, n);

#define obj_create(_x, _y, _obj)
    return mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj);