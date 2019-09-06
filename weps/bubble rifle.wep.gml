#define init
    global.sprWep = sprite_add_weapon("../sprites/weps/sprBubbleRifle.png", 2, 5);
    global.sprWepLocked = mskNone;

#define weapon_name     return (weapon_avail() ? "BUBBLE RIFLE" : "LOCKED");
#define weapon_text     return "REFRESHING";
#define weapon_type     return 4; // Explosive
#define weapon_cost     return 1; // 1 Ammo
#define weapon_load     return 6; // 0.2 Seconds
#define weapon_area     return (weapon_avail() ? 6 : -1); // 3-1
#define weapon_swap     return sndSwapExplosive;
#define weapon_sprt     return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_avail    return unlock_get("oasisWep");

#define weapon_reloaded
    var _dis = 14, _dir = gunangle;
    with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Bubble)){
        image_angle = random(360);
        image_xscale = 0.75;
        image_yscale = image_xscale;
    }

    sound_play_pitchvol(sndOasisExplosionSmall, 1.3, 0.4);

#define weapon_fire(_wep)
    var _creator = wep_creator();
    
     // Burst Fire:
    repeat(2) if(instance_exists(self)){
         // Projectile:
        with(obj_create(x, y, "BubbleBomb")){
            move_contact_solid(other.gunangle, 6);
            motion_add(other.gunangle + (orandom(12) * other.accuracy), 9);
            creator = _creator;
            team = other.team;
        }

         // Effects:
        weapon_post(5, -5, 10);
        
        var l = 14,
            d = gunangle;
            
        with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), BubblePop)){
            image_index = 1;
            image_angle = random(360);
            image_xscale = 0.8;
            image_yscale = image_xscale;
            depth = -1;
        }
        
         // Sound:
        var _pitch = random_range(0.8, 1.2);
        sound_play_pitch(sndOasisCrabAttack,        1.6 * _pitch);
        sound_play_pitch(sndOasisExplosionSmall,    0.7 * _pitch);
        sound_play_pitch(sndToxicBoltGas,           0.8 * _pitch);
        sound_play_pitch(sndBouncerBounce,          1.2 * _pitch);

        wait 2;
    }


/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define wep_creator()                                                                   return  mod_script_call(   "mod", "telib", "wep_creator");
#define unlock_get(_unlock)                                                             return  mod_script_call(   "mod", "telib", "unlock_get", _unlock);