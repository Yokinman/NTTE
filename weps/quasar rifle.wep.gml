#define init
    global.sprQuasarRifle = sprite_add_weapon("../sprites/weps/sprQuasarRifle.png", 8, 5);

#define weapon_name return "QUASAR RIFLE";
#define weapon_text return "BLINDING LIGHT";
#define weapon_auto return true;
#define weapon_type return 5;  // Energy
#define weapon_cost return 10; // 10 Ammo
#define weapon_load return 60; // 2 Seconds
#define weapon_area return (unlock_get("trenchWep") ? 16 : -1); // 7-3
#define weapon_swap return sndSwapEnergy;
#define weapon_sprt return global.sprQuasarRifle;

#define weapon_reloaded
    

#define weapon_fire(_wep)
    if(!is_object(_wep)){
        step(true);
        _wep = wep;
    }

    var _roids = (specfiring && (race == "steroids")),
        _venuz = (specfiring && !_roids);

    if(!instance_exists(_wep.beam) || _venuz){
        with(obj_create(x, y, "QuasarBeam")){
            image_angle = other.gunangle + orandom(6 * other.accuracy);
            team = other.team;
            creator = other;

            player_aim = 1/16;

            offset_dis = 16;
            x += lengthdir_x(offset_dis, image_angle);
            y += lengthdir_y(offset_dis, image_angle);

            _wep.beam = id;
        }

         // Effects:
        weapon_post(14, -16, 8);
        var _brain = skill_get(mut_laser_brain);
		sound_play_pitch(_brain ? sndLaserUpg  : sndLaser,  0.4 + random(0.1));
		sound_play_pitch(_brain ? sndPlasmaUpg : sndPlasma, 1.2 + random(0.2));
		sound_play_pitchvol(sndExplosion, 1.5, 0.5);
		motion_add(gunangle + 180, 3);
    }
    else with(_wep.beam){
        if(image_yscale < 1) scale_goal = 1;
        else{
            var a = 0.25,
                m = 1 + (a * (1 + skill_get(mut_laser_brain)));

            if(scale_goal < m){
                scale_goal = min((floor(image_yscale / a) * a) + a, m);
            }
        }

         // LB Effect:
        if(skill_get(mut_laser_brain) != 0 && scale_goal > 1 + a){
            repeat(6){
                with(instance_create(x + orandom(32), y + orandom(32), LaserBrain)){
                    motion_add(point_direction(other.x, other.y, x, y), 1);
                    image_angle = random(360);
                }
            }
        }

         // Knockback:
        if(image_yscale < scale_goal){
    	    with(other) motion_add(gunangle + 180, 2);
        }
    }

     // Keep Setting:
    with(_wep.beam){
        shrink_delay = weapon_load() + 1;
        roids = _roids;
    }

#define step(_primary)
     // LWO Setup:
    var w = { wep : mod_current, beam : noone };
    if(_primary){
        if(!is_object(wep)) wep = w;
    }
    else{
        if(!is_object(bwep)) bwep = w;
    }

#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "teassets", "unlock_get", _unlock);
#define unlock_set(_unlock, _value)                                                             mod_script_call("mod", "teassets", "unlock_set", _unlock, _value);
