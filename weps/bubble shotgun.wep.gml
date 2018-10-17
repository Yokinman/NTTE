#define init
    global.sprBubbleShotgun = sprite_add_weapon("../sprites/weps/sprBubbleShotgun.png", 3, 4);

#define weapon_name return "BUBBLE SHOTGUN";
#define weapon_text return "SUMMERTIME FUN";
#define weapon_type return 4;   // Explosive
#define weapon_cost return 3;   // 3 Ammo
#define weapon_load return 17;  // 0.6 Seconds
#define weapon_area return -1;  // Doesn't spawn normally
#define weapon_sprt return global.sprBubbleShotgun;

#define weapon_reloaded
    var _dis = 16, _dir = gunangle;
    repeat(3) with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Bubble)){
        image_angle = random(360);
        image_xscale = 0.75;
        image_yscale = image_xscale;
    }

    sound_play_pitchvol(sndOasisExplosionSmall, 1.3, 0.4);

#define weapon_fire(_wep)
    repeat(6){
        with(obj_create(x,y,"BubbleBomb")){
            move_contact_solid(other.gunangle, 6);
            motion_add(other.gunangle + (orandom(12) * other.accuracy), 9 + random(1));
            team = other.team;
            creator = other;
        }
    }

     // Effects:
    var _dis = 14, _dir = gunangle;
    with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), BubblePop)){
        image_index = 1;
        image_angle = random(360);
        image_xscale = 0.8;
        image_yscale = image_xscale;
        depth = -1;
    }
    var _pitch = random_range(0.8, 1.2);
    sound_play_pitch(sndOasisCrabAttack,        0.7 * _pitch);
    sound_play_pitch(sndOasisExplosionSmall,    0.8 * _pitch);
    sound_play_pitch(sndToxicBoltGas,           0.8 * _pitch);
    sound_play_pitch(sndHyperRifle,             1.5 * _pitch);
    weapon_post(10, -5, 10);

#define orandom(n)
    return random_range(-n, n);

#define obj_create(_x, _y, _obj)
    return mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj);