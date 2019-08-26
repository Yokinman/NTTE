#define init
	 // Sprites:
	var b = [
		"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"
	];
    global.sprWep			= sprite_add_weapon_base64(b[0],  5, 7);
	global.sprWepHUD		= sprite_add_weapon_base64(b[1], 10, 7);
	
	global.sprShotbow		= sprite_add_weapon_base64(b[2],  6, 3);
	
	global.sprSlugbolt		= sprite_add_weapon_base64(b[3],  6, 5);
	global.sprSlugboltHUD	= sprite_add_weapon_base64(b[3], 11, 5);
	
    global.sprWepLocked	= mskNone;

	 // Mode Info:
	global.wepModes = [
		{
			name : "bone scythe",
			sprt : global.sprWep,
			cost : 0,
			load : 12, // 0.4 Seconds
			
			is_melee : true,
			sprt_hud : global.sprWepHUD
		},
		{
			name : "bone shotbow",
			sprt : global.sprShotbow,
			cost : 5,
			load : 18 // 0.6 Seconds
		},
		{
			name : "bone slugbolt",
			sprt : global.sprSlugbolt,
			cost : 5,
			load : 15, // 0.5 Seconds
			
			sprt_hud : global.sprSlugboltHUD
		}
	];
	global.numModes = array_length(wepModes);

#macro wepModes global.wepModes
#macro numModes global.numModes

#macro wepLWO {
        wep  : mod_current,
        ammo : 0,
        amax : 55,
        anam : "BONES",
        cost : 0,
        buff : false,
        mode : 0,
        combo : 0
    }
    
#define scrWepModeInfo(_wep, _name)
	var _index = lq_defget(_wep, "mode", 0);
	return lq_defget(wepModes[_index], _name, false);

#define weapon_avail return unlock_get("boneScythe");

#define weapon_name 	return (weapon_avail() ? scrWepModeInfo(argument0, "name") : "LOCKED");
#define weapon_text 	return choose("@rreassembled", "@gradiation@s deteriorates @wbones", "@wmarrow @sfrom a hundred @gmutants");
#define weapon_load 	return scrWepModeInfo(argument0, "load");
#define weapon_type 	return 0; // Melee
#define weapon_melee	return scrWepModeInfo(argument0, "is_melee");
#define weapon_area 	return (weapon_avail() ? 18 : -1); // 1-2 L1
#define weapon_swap 	return sndBloodGamble;

#define weapon_auto(w)
	if(instance_is(self, Player) && (infammo != 0 || (lq_defget(w, "ammo", -1) >= lq_defget(w, "cost", -1)))) return true;
	return -1;

#define weapon_sprt(w)
	wepammo_draw(w);
	
	if(!weapon_avail()) return global.sprWepLocked;
	
	 // Hud Sprite:
	var _sprtHud = scrWepModeInfo(w, "sprt_hud");
	if(_sprtHud != false && (instance_is(other, TopCont) || instance_is(other, UberCont))){
		return scrWepModeInfo(w, "sprt_hud");
	}
	
	 // Normal Sprite:
	return scrWepModeInfo(w, "sprt");

#define weapon_fire(w)
	 // LWO Insurance:
	if(!is_object(wep)){
		step(true);
		w = wep;
	}

	 // Mode Specific:
	switch(w.mode){
		//#region SCYTHE:
		case 0:
			var _skill = skill_get(mut_long_arms),
				_heavy = (++w.combo % 3 == 0),
				_flip = sign(wepangle),
				l = 10 + (10 * _skill),
				d = gunangle + (accuracy * orandom(4));
				
			with(obj_create(x + hspeed + lengthdir_x(l, d), y + vspeed + lengthdir_y(l, d), "BoneSlash")){
				image_yscale = _flip;
				
				creator = other;
				team	= other.team;
				heavy	= _heavy;
				rotspd	= (-3 * _flip);
				
				direction	= d;
				speed		= 2.5 + (2 * _skill);
				image_angle = direction;
			}
			
			 // Sounds:
			sound_play_pitch(sndBlackSword, 0.8 + random(0.3));
			if(_heavy){
				sound_play_pitchvol(sndHammer, 1 - random(0.2), 0.6);
				sound_play_pitchvol(sndSwapHammer, 1.3 + random(0.2), 0.6);
			}
			
			 // Effects:
			motion_add(d - (30 * sign(wepangle)), 3.5);
			wepangle *= -1;
			wkick = 5;
			if(_heavy) sleep(12);
		
			break;
		//#endregion
		 
		//#region SHOTBOW:
		case 1:
			if(wepammo_fire(w)){
				 // Projectile:
				var d = gunangle + (accuracy * orandom(12)),
					o = 20 * accuracy;

				for(var i = -1; i <= 1; i++){
					with(obj_create(x, y, "BoneArrow")){
						creator = other;
						team	= other.team;
						
						direction	= d + (i * o);
						speed		= 16;
						image_angle = direction;
					}
				}
				
				 // Sounds:
				sound_play_pitch(sndSuperCrossbow, 0.9 + random(0.3));
				sound_play_pitch(sndBloodLauncherExplo, 1.2 + random(0.3));
				
				 // Effects:
				weapon_post(6, 3, 7);
				sleep(4);
			}
		
			break;
		//#endregion
		
		//#region SLUGBOLT
		case 2:
			if(wepammo_fire(w)){
				 // Projectile:
				var d = gunangle + (accuracy * orandom(4));
				with(obj_create(x, y, "BoneArrow")){
					creator = other;
					team	= other.team;
					big		= true;
					
					direction	= d;
					speed		= 20;
					image_angle = direction;
				}
			
				 // Sounds:
				sound_play_pitch(sndHeavyCrossbow, 0.9 + random(0.3));
				sound_play_pitch(sndBloodHammer, 1.1 + random(0.2));
				
				 // Effects:
				motion_add((gunangle + 180), 3);
				weapon_post(12, 17, 15);
				sleep(40);
			}
			
			break;
		//#endregion
	}

#define step(_primary)
    var b = (_primary ? "" : "b"),
        w = variable_instance_get(self, b + "wep");

     // LWO Setup:
    if(!is_object(w)){
        w = wepLWO;
        variable_instance_set(self, b + "wep", w);
    }

     // Back Muscle:
    with(w){
        var _muscle = skill_get(mut_back_muscle);
        if(buff != _muscle){
            var _amaxRaw = (amax / (1 + (0.8 * buff)));
            buff = _muscle;
            amax = (_amaxRaw * (1 + (0.8 * buff)));
            ammo += (amax - _amaxRaw);
        }
    }
    
     // Switch Modes:
    var i = index;
    if(canpick && button_pressed(index, "pick")){
    	if(_primary && !instance_exists(nearwep)){
    		with(w){
	    		mode = ++mode % numModes;
	    		cost = scrWepModeInfo(w, "cost");
    		}
    		
    		 // Effects:
    		wkick = -2;
    		swapmove = true;
    		
    		sound_play_pitch(sndMutant14Turn, 0.9 + random(0.2));
    		sound_play_pitchvol(sndFishWarrantEnd, 0.9 + random(0.4), 1.2);
    		
    		with(instance_create(x, y, PopupText)){
    			target = i;
    			mytext = scrWepModeInfo(w, "name") + "!";
    		}
    		
    		 // Bone Piece Effects:
    		var n = 8 - array_length(instances_matching(instances_matching(Shell, "name", "BoneFX"), "creator", id));
    		if(n > 0) repeat(n) with(obj_create(x, y, "BoneFX")){
    			speed = 4 + random(3);
    			direction = random(360);
    			creator = other;
    		}
    		repeat(4) with(scrFX(x, y, [random(360), 1 + random(3)], Dust)) depth = -3;
    		
    		 // Silence:
    		mod_variable_set("mod", "ntte", "sPromptIndex", -1);
    		
    	}
    }

/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define wepammo_draw(_wep)                                                              return  mod_script_call("mod", "telib", "wepammo_draw", _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call("mod", "telib", "wepammo_fire", _wep);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc("mod", "telib", "scrFX", _x, _y, _motion, _obj);