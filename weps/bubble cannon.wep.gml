#define init
    global.sprBubbleCannon = sprite_add_weapon("../sprites/weps/sprBubbleCannon.png", 5, 7);

#define weapon_name return "BUBBLE CANNON";
#define weapon_text return "KING OF THE BUBBLES";
#define weapon_type return 4;   // Explosive
#define weapon_cost return 3;   // 3 Ammo
#define weapon_load return 30;  // 1.0 Seconds
#define weapon_area return (unlock_get(mod_current) ? 7 : -1);
#define weapon_swap return sndSwapExplosive;
#define weapon_sprt return global.sprBubbleCannon;

#define weapon_reloaded
    var _dis = 22, _dir = gunangle;
    repeat(5)with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Bubble)){
        image_angle = random(360);
        image_xscale = 0.75;
        image_yscale = image_xscale;
    }

    sound_play_pitchvol(sndOasisExplosionSmall, 1.3, 0.4);

#define weapon_fire(_wep)
    if(instance_exists(self)){
    with(obj_create(x,y,"SuperBubbleBomb")){
        move_contact_solid(other.gunangle, 7);
        motion_add(other.gunangle + (orandom(6) * other.accuracy), 9);
        team = other.team;
        creator = other;
      }
    
      // Effects:
      var _dis = 12, _dir = gunangle;
      with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), BubblePop)){
          image_index = 1;
          image_speed = .25;
          image_angle = random(360);
          image_xscale = 1.2;
          image_yscale = image_xscale;
          depth = -1;
      }
      var _pitch = random_range(0.8, 1.2);
      sound_play_pitch(sndOasisCrabAttack,        1.4 * _pitch);
      sound_play_pitch(sndOasisExplosionSmall,    0.5 * _pitch);
      sound_play_pitch(sndToxicBoltGas,           0.7 * _pitch);
      sound_play_pitch(sndToxicBarrelGas,         0.8 * _pitch);
      sound_play_pitch(sndOasisPortal,             .6 * _pitch);
      sound_play_pitch(sndPlasmaMinigunUpg,        .4 * _pitch);
      motion_add(gunangle-180,4)
      weapon_post(10, -12, 32);
    }


/// Scripts:
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call("mod", "telib", "obj_create", _x, _y, _obj);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);