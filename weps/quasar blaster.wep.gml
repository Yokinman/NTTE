#define init
    global.sprQuasarBlaster = sprite_add_weapon("../sprites/weps/sprQuasarBlaster.png", 4, 5);

#define weapon_name return "QUASAR BLASTER";
#define weapon_text return "SO FLEXIBLE";
#define weapon_type return 5;  // Energy
#define weapon_cost return 3;  // 3 Ammo
#define weapon_load return 15; // 0.5 Seconds
#define weapon_area return (unlock_get("trenchWep") ? 9 : -1); // 4-1
#define weapon_swap return sndSwapEnergy;
#define weapon_sprt return global.sprQuasarBlaster;

#define weapon_fire(_wep)
    var _roids = (specfiring && (race == "steroids")),
        _beams = instances_matching(instances_matching_gt(instances_matching(instances_matching(CustomProjectile, "name", "QuasarBeam"), "creator", id), "shrink_delay", 0), "roids", _roids);

    with(obj_create(x, y, "QuasarBeam")){
        image_angle = other.gunangle + orandom(4 * other.accuracy);
        team = other.team;
        creator = other;
        roids = _roids;

        shrink_delay = 8;
        scale_goal = 0.5;
        bend_fric = 0.4;

        image_xscale *= scale_goal;
        image_yscale *= scale_goal;
    }

     // Effects:
    weapon_post(12, -12, 4);
    var _brain = skill_get(mut_laser_brain);
    sound_play_pitchvol((_brain ? sndLaserUpg : sndLaser),  0.6 + random(0.1), 1);
	sound_play_pitchvol(sndPlasmaHit,                       1.5,               0.6);

#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "teassets", "unlock_get", _unlock);
#define unlock_set(_unlock, _value)                                                             mod_script_call("mod", "teassets", "unlock_set", _unlock, _value);
