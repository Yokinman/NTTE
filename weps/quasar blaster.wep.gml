#define init
    global.sprWep = sprite_add_weapon("../sprites/weps/sprQuasarBlaster.png", 4, 5);
    global.sprWepLocked = mskNone;

#define weapon_name		return (weapon_avail() ? "QUASAR BLASTER" : "LOCKED");
#define weapon_text		return "SO FLEXIBLE";
#define weapon_type		return 5;  // Energy
#define weapon_cost		return 3;  // 3 Ammo
#define weapon_load		return 15; // 0.5 Seconds
#define weapon_area		return (weapon_avail() ? 9 : -1); // 4-1
#define weapon_swap		return sndSwapEnergy;
#define weapon_sprt		return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_avail	return unlock_get("trenchWep");

#define weapon_fire(w)
    var	_creator = wep_creator(),
        _roids = (race == "steroids" && variable_instance_get(self, "specfiring", false));
        
     // Projectile:
    with(obj_create(x, y, "QuasarBeam")){
        image_angle = other.gunangle + orandom(4 * other.accuracy);
        creator = _creator;
        team = other.team;
        roids = _roids;
        
        turn_factor = 1/10;
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


/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define wep_creator()                                                                   return  mod_script_call(   "mod", "telib", "wep_creator");
#define unlock_get(_unlock)                                                             return  mod_script_call(   "mod", "telib", "unlock_get", _unlock);