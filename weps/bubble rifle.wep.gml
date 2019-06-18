#define init
    global.sprBubbleRifle = sprite_add_weapon("../sprites/weps/sprBubbleRifle.png", 2, 5);

#define weapon_name return "BUBBLE RIFLE";
#define weapon_text return "REFRESHING";
#define weapon_type return 4; // Explosive
#define weapon_cost return 1; // 1 Ammo
#define weapon_load return 6; // 0.2 Seconds
#define weapon_area return (unlock_get("oasisWep") ? 6 : -1); // 3-1
#define weapon_swap return sndSwapExplosive;
#define weapon_sprt return global.sprBubbleRifle;

#define weapon_reloaded
    var _dis = 14, _dir = gunangle;
    with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Bubble)){
        image_angle = random(360);
        image_xscale = 0.75;
        image_yscale = image_xscale;
    }

    sound_play_pitchvol(sndOasisExplosionSmall, 1.3, 0.4);

#define weapon_fire(_wep)
    repeat(2) if(instance_exists(self)){
        with(obj_create(x,y,"BubbleBomb")){
            move_contact_solid(other.gunangle, 6);
            motion_add(other.gunangle + (orandom(12) * other.accuracy), 9);
            team = other.team;
            creator = other;
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
        sound_play_pitch(sndOasisCrabAttack,        1.6 * _pitch);
        sound_play_pitch(sndOasisExplosionSmall,    0.7 * _pitch);
        sound_play_pitch(sndToxicBoltGas,           0.8 * _pitch);
        sound_play_pitch(sndBouncerBounce,          1.2 * _pitch);
        weapon_post(5, -5, 10);

        wait 2;
    }


/// Scripts:
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);