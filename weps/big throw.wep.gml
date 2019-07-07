#define init
    global.sprCopyCat = sprite_add_weapon("../sprites/weps/sprCopyCat.png", 6, 3);

#define weapon_name  return "BIG THROW";
#define weapon_text  return "BLAST 'EM AWAY";
#define weapon_type  return 0;  // Melee
#define weapon_cost  return 0;  // No Ammo
#define weapon_load  return 20; // 1 Second
#define weapon_area  return 0;
#define weapon_swap  return sndSwapEnergy;
#define weapon_sprt  return global.sprCopyCat;
#define weapon_melee return 0;

#define weapon_reloaded
    sound_play(sndMeleeFlip);

#define weapon_fire
      weapon_post(9, 70, 0);
      motion_add(gunangle-180, 3);
      var _angle  = 20,
          _offset = -_angle;
      repeat(3){
        with(obj_create(x, y, "PalankingSlashGround")){
        motion_add(other.gunangle + _offset * other.accuracy, 10 + skill_get(mut_long_arms) * 3);
        if _offset = 0{speed += 1};
        team = other.team;
        creator = other;
        image_angle = direction;
        smack_all = "ok";
        }
        _offset += _angle;
      }

     // Effects:
     var _p = random_range(.8,1.2);
    sound_play_pitchvol(sndHyperSlugger, .6 * _p, 1);
    sound_play_pitchvol(sndHyperRifle, .7 * _p, 1);
    sound_play_pitchvol(sndHyperLauncher, 1.5 * _p, 1);


/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);
