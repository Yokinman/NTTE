#define init
    global.sprCopyCat = sprite_add_weapon("../sprites/weps/sprCopyCat.png", 6, 3);

#define weapon_name  return "BAT CANNON";
#define weapon_text  return "ACID SPIT";
#define weapon_type  return 0;  // Melee
#define weapon_cost  return 0;  // No Ammo
#define weapon_load  return 20; // 1 Second
#define weapon_area  return 0;
#define weapon_swap  return sndSwapEnergy;
#define weapon_sprt  return global.sprCopyCat;
#define weapon_melee return 0;

#define weapon_reloaded

#define weapon_fire
    weapon_post(3, 40, 0);
    with obj_create(x, y, "VenomFlak"){
      creator = other;
      team = other.team;
    motion_add(other.gunangle + random_range(-4, 4) * other.accuracy, 16);

    }

    // Effects:
    var _p = random_range(.8,1.2);
    sound_play_pitchvol(sndHyperSlugger, .6 * _p, 1);
    sound_play_pitchvol(sndHyperLauncher, 1.5 * _p, 1);


/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);
