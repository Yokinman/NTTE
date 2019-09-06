#define init
    global.sprWep = sprite_add_weapon("../sprites/weps/sprQuasarRifle.png", 8, 5);
    global.sprWepLocked = mskNone;

#macro wepLWO {
		wep  : mod_current,
		beam : noone
	}

#define weapon_name		return (weapon_avail() ? "QUASAR RIFLE" : "LOCKED");
#define weapon_text		return "BLINDING LIGHT";
#define weapon_auto		return true;
#define weapon_type		return 5;  // Energy
#define weapon_cost		return 10; // 10 Ammo
#define weapon_load		return 60; // 2 Seconds
#define weapon_area		return (weapon_avail() ? 16 : -1); // 7-3
#define weapon_swap		return sndSwapEnergy;
#define weapon_sprt		return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_avail	return unlock_get("trenchWep");

#define weapon_fire(w)
    var	_creator = wep_creator(),
    	_wepHeld = (variable_instance_get(_creator, "wep") == w),
        _roids = (race == "steroids" && variable_instance_get(self, "specfiring", false)),
        _venuz = (race != "steroids" && variable_instance_get(self, "specfiring", false));
        
     // LWO Setup:
    if(!is_object(w)){
    	w = wepLWO;
        if(_wepHeld) _creator.wep = w;
    }
    
     // New Beam:
    if(!instance_exists(w.beam) || _venuz){
    	 // Projectile:
        with(obj_create(x, y, "QuasarBeam")){
            image_angle = other.gunangle + orandom(6 * other.accuracy);
            image_yscale = 0.6;
            creator = _creator;
            team = other.team;

            turn_factor = 1/100;
            offset_dis = 16;

            w.beam = id;
        }

         // Effects:
        weapon_post(14, -16, 8);
        var _brain = skill_get(mut_laser_brain);
		sound_play_pitch(_brain ? sndLaserUpg  : sndLaser,  0.4 + random(0.1));
		sound_play_pitch(_brain ? sndPlasmaUpg : sndPlasma, 1.2 + random(0.2));
		sound_play_pitchvol(sndExplosion, 1.5, 0.5);
		motion_add(gunangle + 180, 3);
    }
    
     // Charge Beam:
    else with(w.beam){
        if(image_yscale < 1) scale_goal = 1;
        else{
            var a = 0.25,
                m = 1 + (a * (1 + (0.4 * skill_get(mut_laser_brain))));

            if(scale_goal < m){
                scale_goal = min((floor(image_yscale / a) * a) + a, m);
            }
        }

         // Knockback:
        if(image_yscale < scale_goal){
    	    with(other) motion_add(gunangle + 180, 2);
        }
    }

     // Keep Setting:
    with(w.beam){
        shrink_delay = weapon_load() + 1;
        roids = _roids;
    }

#define step(_primary)
     // LWO Setup:
    if(_primary){
        if(!is_object(wep)) wep = wepLWO;
    }
    else{
        if(!is_object(bwep)) bwep = wepLWO;
    }


/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define wep_creator()                                                                   return  mod_script_call(   "mod", "telib", "wep_creator");
#define unlock_get(_unlock)                                                             return  mod_script_call(   "mod", "telib", "unlock_get", _unlock);