#define init
    global.sprQuasarCannon = sprite_add_weapon("../sprites/weps/sprQuasarCannon.png", 20, 5);

#define weapon_name return "QUASAR CANNON";
#define weapon_text return "";
#define weapon_auto return true;
#define weapon_type return 5;	// Energy
#define weapon_cost return 12;	// 12 Ammo
#define weapon_load return 159; // 5.3 Seconds
#define weapon_area return (unlock_get("trenchWep") ? 18 : -1); // L1 1-1
#define weapon_swap return sndSwapEnergy;
#define weapon_sprt return global.sprQuasarCannon;

#define weapon_reloaded
    

#define weapon_fire(_wep)
    with(obj_create(x, y, "QuasarRing")){
        motion_add(other.gunangle + orandom(8 * other.accuracy), 4.5);
        image_angle = direction;
        image_yscale = 0;
        team = other.team;
        creator = other;
        ring_size = 0.5;
    }

     // Effects:
    weapon_post(20, -24, 8);
    var _brain = skill_get(mut_laser_brain);
	sound_play_pitch(_brain ? sndLightningCannonUpg	: sndLaser,		0.4 + random(0.1));
	sound_play_pitch(_brain ? sndPlasmaBigUpg		: sndPlasmaBig,	1.2 + random(0.2));
	sound_play_pitchvol(sndExplosion, 0.8, 0.8);
	motion_add(gunangle + 180, 5);


#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "teassets", "unlock_get", _unlock);
#define unlock_set(_unlock, _value)                                                             mod_script_call("mod", "teassets", "unlock_set", _unlock, _value);
