#define init

#define weapon_name return "BONE";
#define weapon_type return 0;                   // Melee
#define weapon_load return 1;                   // 0.03 Seconds
#define weapon_area return -1;                  // Doesn't spawn normally
#define weapon_sprt return sprBone;
#define weapon_text return "BONE THE FISH";

#define weapon_fire(_wep)
    if(!is_object(_wep)){
        step(true);
        _wep = wep;
    }
    _wep.thrown = true;

     // Throw Bone:
    with(obj_create(x, y, "Bone")){
        motion_add(other.gunangle, 16);
        rotation = direction;
        team = other.team;
        creator = other;
    }

     // Effects:
    sound_play(sndChickenThrow);
    sound_play_pitch(sndBloodGamble, 0.7 + random(0.2));
    with(instance_create(x, y, MeleeHitWall)){
        motion_add(other.gunangle, 1);
        image_angle = direction + 180;
    }

#define step(_primary)
    var _throwWep = false,
        w = { wep : mod_current, thrown : false };

    if(_primary){
        wkick = min(-5, wkick);
        if(!is_object(wep)) wep = w;
        if(wep.thrown){
            wep.thrown = false;
            wep = 0;

             // Swap to bwep:
            breload = max(3, breload);
            scrSwap();
        }
    }
    else{
        bwkick = min(-5, bwkick);
        if(!is_object(bwep)) bwep = w;
        if(bwep.thrown){
            bwep.thrown = false;
            bwep = 0;
        }
    }

#define scrSwap()
	var _swap = ["wep", "curse", "reload", "wkick", "wepflip", "wepangle", "can_shoot"];
	for(var i = 0; i < array_length(_swap); i++){
		var	s = _swap[i],
			_temp = [variable_instance_get(id, "b" + s), variable_instance_get(id, s)];

		for(var j = 0; j < array_length(_temp); j++) variable_instance_set(id, chr(98 * j) + s, _temp[j]);
	}

	wepangle = (weapon_is_melee(wep) ? choose(120, -120) : 0);
	can_shoot = (reload <= 0);
	clicked = 0;

#define obj_create(_x, _y, _obj)
    return mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj);