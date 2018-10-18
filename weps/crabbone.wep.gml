#define init
    global.sprBone = sprite_add_weapon("../sprites/weps/sprBone.png", 6, 6);

#define weapon_name return "BONE";
#define weapon_text return "BONE THE FISH";
#define weapon_type return 0;   // Melee
#define weapon_load return 6;   // 0.20 Seconds
#define weapon_area return -1;  // Doesn't spawn normally
#define weapon_sprt return global.sprBone;

#define weapon_fire(_wep)
    if(!is_object(_wep)){
        step(true);
        _wep = wep;
    }
    _wep.ammo--;

     // Throw Bone:
    with(obj_create(x, y, "Bone")){
        motion_add(other.gunangle, 16);
        rotation = direction;
        team = other.team;
        creator = other;
    }

    weapon_post(-10, -4, 4);
    wepangle *= -1;

     // Effects:
    sound_play(sndChickenThrow);
    sound_play_pitch(sndBloodGamble, 0.7 + random(0.2));
    with(instance_create(x, y, MeleeHitWall)){
        motion_add(other.gunangle, 1);
        image_angle = direction + 180;
    }

#define step(_primary)
    var _throwWep = false,
        w = { wep : mod_current, ammo : 1 };

    if(_primary){
        wkick = min(-5, wkick);
        if(!is_object(wep)) wep = w;
        w = wep;
        if(wep.ammo <= 0){
            wep = 0;

             // Swap:
            breload = max(3, breload);
            scrSwap();
        }
    }
    else{
        bwkick = min(-5, bwkick);
        if(!is_object(bwep)) bwep = w;
        w = bwep;
        if(bwep.ammo <= 0) bwep = 0;
    }

     // Pickup Bones:
    if(place_meeting(x, y, WepPickup)){
        with(WepPickup) if(place_meeting(x, y, other)){
            if(wep_get(wep) == mod_current){
                w.ammo++;
                with(instance_create(x, y, DiscDisappear)){
                    image_angle = other.rotation;
                }
                sound_play_pitchvol(sndHPPickup, 4, 0.6);
                sound_play_pitch(sndPickupDisappear, 0.8);
                sound_play_pitchvol(sndBloodGamble, 0.4 + random(0.2), 0.5);
                instance_destroy();
            }
        }
    }

     // Ammo Indicator:
    if(w.ammo > 1){
        script_bind_draw(ammo_draw, -100, index, _primary, w.ammo, (race == "steroids"));
    }

#define ammo_draw(_index, _primary, _ammo, _steroids)
    instance_destroy();

    var _active = 0;
    for(var i = 0; i < maxp; i++) _active += player_is_active(i);

    draw_set_visible_all(0);
    draw_set_visible(_index, 1);
    draw_set_projection(0);

    var _x = (_primary ? 42 : 86),
        _y = 21;

    if(_active > 1) _x -= 19;

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    if(!_primary && !_steroids) draw_set_color(c_silver);

    draw_text_shadow(_x, _y, string(_ammo));

    draw_reset_projection();
    draw_set_visible_all(1);

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

#define wep_get(_wep)
    if(is_object(_wep)){
        return wep_get(lq_defget(_wep, "wep", 0));
    }
    return _wep;

#define obj_create(_x, _y, _obj)
    return mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj);