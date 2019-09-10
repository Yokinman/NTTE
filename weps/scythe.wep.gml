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
    
     // LWO:
	global.lwoWep = {
        wep   : mod_current,
        ammo  : 0,
        amax  : 55,
        anam  : "BONES",
        cost  : 0,
        buff  : false,
        mode  : 0,
        combo : 0
    };
    
	 // Mode Info:
	global.wepModes = [
		{
			name : "BONE SCYTHE",
			sprt : global.sprWep,
			swap : sndSwapSword,
			cost : 0,
			load : 12, // 0.4 Seconds
			auto : true,
			mele : true,
			
			sprt_hud : global.sprWepHUD
		},
		{
			name : "BONE SHOTBOW",
			sprt : global.sprShotbow,
			swap : sndSwapMachinegun,
			cost : 5,
			load : 18, // 0.6 Seconds
			auto : true
		},
		{
			name : "BONE SLUGBOW",
			sprt : global.sprSlugbolt,
			swap : sndSwapMotorized,
			cost : 5,
			load : 15, // 0.5 Seconds
			auto : false,
			
			sprt_hud : global.sprSlugboltHUD
		}
	];

	 // Global Step
	while(true){
		with(Player) if(wep_get(wep) == mod_current){
	    	script_bind_end_step(scythe_swap, 0, id);
		}
		wait 0;
	}

#macro wepModes global.wepModes
#macro numModes array_length(wepModes)

#macro lwoWep global.lwoWep
    
#define scrWepModeInfo(_wep, _name)
	var _index = lq_defget(_wep, "mode", 0);
	return lq_defget(wepModes[_index], _name, false);

#define weapon_avail return unlock_get("boneScythe");

#define weapon_name 	return (weapon_avail() ? scrWepModeInfo(argument0, "name") : "LOCKED");
#define weapon_text 	return choose("@rreassembled", "@gradiation@s deteriorates @wbones", "@wmarrow @sfrom a hundred @gmutants");
#define weapon_load 	return scrWepModeInfo(argument0, "load");
#define weapon_type 	return 0; // Melee
#define weapon_melee	return scrWepModeInfo(argument0, "mele");
#define weapon_area 	return (weapon_avail() ? 18 : -1); // 1-2 L1
#define weapon_swap 	return sndBloodGamble;

#define weapon_auto(w)
	if(instance_is(self, Player) && (infammo != 0 || (lq_defget(w, "ammo", -1) >= lq_defget(w, "cost", -1)))){
		return scrWepModeInfo(w, "auto");
	}
	return -1;

#define weapon_sprt(w)
	 // Draw Ammo:
	if(is_object(w) && instance_is(self, Player)){
		var _ammo = w.ammo,
			_primary = (wep == w),
			_steroids = (race == "steroids"),
			_col = "w";
			
		if(_ammo > 0){
		    if(_primary || _steroids){
		    	if(_ammo < 5){
			    	_col = "r";
			    }
		    }
		    else _col = "s";
		}
		else _col = "d";
		
		w.ammo = `@${_col}${_ammo}`;
		
		wepammo_draw(w);
		
		w.ammo = _ammo;
	}
	
	 // Locked:
	if(!weapon_avail()) return global.sprWepLocked;
	
	 // Hud Sprite:
	var _sprtHud = scrWepModeInfo(w, "sprt_hud");
	if(_sprtHud != false && (instance_is(other, TopCont) || instance_is(other, UberCont))){
		return scrWepModeInfo(w, "sprt_hud");
	}
	
	 // Normal Sprite:
	return scrWepModeInfo(w, "sprt");

#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
	
	 // Mode Specific:
	switch(w.mode){
		//#region SCYTHE:
		case 0:
			var _skill = skill_get(mut_long_arms),
				_heavy = (++w.combo % 3 == 0),
				_flip = sign(wepangle),
				l = 10 + (10 * _skill),
				d = gunangle + orandom(4 * accuracy);
				
			with(obj_create(x + hspeed + lengthdir_x(l, d), y + vspeed + lengthdir_y(l, d), "BoneSlash")){
				image_yscale = _flip;
				
				creator = f.creator;
				team	= other.team;
				heavy	= _heavy;
				rotspd	= (-3 * _flip);
				
				direction	= d;
				speed		= 2.5 + (2 * _skill);
				image_angle = direction;
			}
			
			 // Sounds:
			sound_play_pitchvol(sndBlackSword, 0.8 + random(0.3), 1);
			if(_heavy){
				sound_play_pitchvol(sndHammer,     1 - random(0.2),   0.6);
				sound_play_pitchvol(sndSwapHammer, 1.3 + random(0.2), 0.6);
			}
			
			 // Effects:
			wepangle *= -1;
			motion_add(d + (30 * sign(wepangle)), 3 + _heavy);
			weapon_post((_heavy ? -5 : 5), 6 + (10 * _heavy), 2);
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
						creator = f.creator;
						team	= other.team;
						
						direction	= d + (i * o);
						speed		= 16;
						image_angle = direction;
					}
				}
				
				 // Sounds:
				sound_play_pitchvol(sndSuperCrossbow,      0.9 + random(0.3), 0.5);
				sound_play_pitchvol(sndBloodLauncherExplo, 1.2 + random(0.3), 0.5);
				
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
					creator = f.creator;
					team	= other.team;
					big		= true;
					
					direction	= d;
					speed		= 20;
					image_angle = direction;
				}
			
				 // Sounds:
				sound_play_pitchvol(sndHeavyCrossbow, 0.9 + random(0.3), 2/3);
				sound_play_pitchvol(sndBloodHammer,   1.1 + random(0.2), 2/3);
				
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
        w = lq_clone(lwoWep);
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
    
     // Big Ammo:
    if(place_meeting(x, y, WepPickup)){
        with(instances_meeting(x, y, instances_matching(WepPickup, "visible", true))){
            if(place_meeting(x, y, other)){
                if(wep_get(wep) == "crabbone"){
                    w.ammo = min(w.ammo + 20, w.amax);
                    
                     // Effects:
                    with(instance_create(x, y, DiscDisappear)) image_angle = other.rotation;
                    sound_play_pitchvol(sndHPPickup, 4, 0.6);
                    sound_play_pitchvol(sndPickupDisappear, 1.2, 0.6);
                    sound_play_pitchvol(sndBloodGamble, 0.4 + random(0.2), 0.4);
                    
                    instance_destroy();
                }
            }
        }
    }

#define scythe_swap
	with(Player){
		if(button_pressed(index, "pick") && !instance_exists(nearwep) && wep_get(wep) == mod_current){
			var w = wep;
			
			 // Swap:
			with(w){
				mode = ++mode % numModes;
				cost = scrWepModeInfo(w, "cost");
			}
			
			 // Sound:
			sound_play(scrWepModeInfo(w, "swap"));
			sound_play_hit(sndMutant14Turn, 0.1);
			sound_play_hit_ext(sndFishWarrantEnd, 1 + random(0.2), 2);
			
			 // Silence:
			mod_variable_set("mod", "ntte", "sPromptIndex", -1);
			
			 // Effects:
			swapmove = 1;
			if(visible && !instance_exists(GenCont) && !instance_exists(LevCont)){
				wkick = -3;
				gunshine = 1;
				clicked = false;
				
				 // !
				with(instance_create(x, y, PopupText)){
					target = other.index;
					mytext = scrWepModeInfo(w, "name") + "!";
				}
				
				 // Bone Piece Effects:
				var	n = 8 - array_length(instances_matching(instances_matching(Shell, "name", "BoneFX"), "creator", id)),
		    		l = 12,
					d = gunangle + wepangle;
					
				if(n > 0) repeat(n){
					with(obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "BoneFX")){
						motion_add(d, 1);
						creator = other;
					}
				}
				
				l = 8;
				repeat(6){
					with(scrFX(x + lengthdir_x(l, d), y + lengthdir_y(l, d), [d + orandom(60), 1 + random(5)], Dust)) depth = -3;
				}
			}
    	}
	}
	instance_destroy();


/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define wepfire_init(_wep)                                                              return  mod_script_call(   "mod", "telib", "wepfire_init", _wep);
#define wepammo_draw(_wep)                                                              return  mod_script_call(   "mod", "telib", "wepammo_draw", _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call(   "mod", "telib", "wepammo_fire", _wep);
#define unlock_get(_unlock)                                                             return  mod_script_call(   "mod", "telib", "unlock_get", _unlock);
#define wep_get(_wep)                                                                   return  mod_script_call(   "mod", "telib", "wep_get", _wep);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   "mod", "telib", "instances_meeting", _x, _y, _obj);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc("mod", "telib", "scrFX", _x, _y, _motion, _obj);
#define sound_play_hit_ext(_snd, _pit, _vol)											return  mod_script_call(   "mod", "telib", "sound_play_hit_ext", _snd, _pit, _vol);