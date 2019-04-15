#define init
    global.sprQuasarRifle = sprite_add_weapon("../sprites/weps/sprQuasarRifle.png", 8, 5);

#define weapon_name return "QUASAR RIFLE";
#define weapon_text return "BLINDING LIGHT";
#define weapon_type return 5;  // Energy
#define weapon_cost return 4;  // 5 Ammo
#define weapon_load return 10;  // 0.6 Seconds
#define weapon_area return (unlock_get(mod_current) ? 14 : -1);
#define weapon_swap return sndSwapEnergy;
#define weapon_sprt return global.sprQuasarRifle;
#define weapon_auto return true;

#define weapon_reloaded
    

#define weapon_fire(_wep)
    var _roids = (specfiring && (race == "steroids")),
        _beams = instances_matching(instances_matching_gt(instances_matching(instances_matching(CustomProjectile, "name", "QuasarBeam"), "creator", id), "shrink_delay", 0), "roids", _roids);

    if(array_length(_beams) <= 0){
        with(obj_create(x, y, "QuasarBeam")){
            image_angle = other.gunangle;
            team = other.team;
            creator = other;
            roids = _roids;
    
            turn_max = 50;
            turn_factor = 1/8;
            shrink = 0.08;
    
            offset_dis = 20;
            x += lengthdir_x(offset_dis, image_angle);
            y += lengthdir_y(offset_dis, image_angle);

            array_push(_beams, id);
        }

         // Effects:
        weapon_post(14, -16, 8);
    }
    with(_beams){
        shrink_delay = weapon_load() + 1;
    }

#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "teassets", "unlock_get", _unlock);
#define unlock_set(_unlock, _value)                                                             mod_script_call("mod", "teassets", "unlock_set", _unlock, _value);
