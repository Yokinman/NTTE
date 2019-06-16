#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");

#macro spr global.spr

#macro wepLWO {
	wep 	 : mod_current,
	chrg	 : false,
	chrg_num : 0,
	chrg_max : 7,
	chrg_key : "fire"
	}

#define weapon_name			return "TRIDENT";
#define weapon_text			return "SCEPTER OF THE @bSEA";
#define weapon_type			return 0;  // Melee
#define weapon_load			return 14; // 0.47 Seconds (Stab Length)
#define weapon_area			return (unlock_get("coastWep") ? 7 : -1); // 3-2
#define weapon_auto			return true;
#define weapon_melee		return false;
#define weapon_chrg			return true;
#define weapon_swap			return sndSwapSword;
#define weapon_sprt			return spr.Trident;

#define weapon_fire(w)
	if(!is_object(w)){
		step(true);
		w = wep;
	}

	 // Charge Trident:
	w.chrg = true;
	w.chrg_key = (specfiring ? "spec" : "fire");                            //// Pop pop is broken, fix later ////
	reload = current_time_scale;

#define step(_primary)
    var b = (_primary ? "" : "b"),
        w = variable_instance_get(self, b + "wep");

     // LWO Setup:
    if(!is_object(w)){
        w = wepLWO;
        variable_instance_set(self, b + "wep", w);
    }

     // Harpoon Charge:
    if(w.chrg){
    	w.chrg = false;
    	if(w.chrg_num < w.chrg_max){
	    	w.chrg_num += current_time_scale;

			 // Charging FX:
			sound_play_pitch(sndOasisMelee, 1 / (1 - ((w.chrg_num / w.chrg_max) * 0.25)));

	    	 // Full Charge:
			if(w.chrg_num >= w.chrg_max){
				w.chrg_num = w.chrg_max;

				 // FX:
				var	l = 16,
					d = gunangle;
		
				instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), ThrowHit)
				instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), ImpactWrists)
				sound_play_pitch(sndCrystalRicochet, 3);
				sound_play_pitch(sndSewerDrip, 3);
				sleep(5);
			}
    	}

    	 // Blink:
    	else if(frame_active(12)){
			gunshine = 1;
		}

    	 // Pullback:
    	var k = wkick,
	    	f = (w.chrg_num / w.chrg_max);

	    weapon_post(9 * f, 8 * f, 0);
    	if(!_primary){
    		bwkick = wkick;
    		wkick = k;
    	}
    }
    else{
	    if(!button_check(index, w.chrg_key)){
	    	if(!w.chrg && w.chrg_num > 0){
				 // Throw Trident:
			    if(w.chrg_num >= w.chrg_max){
					variable_instance_set(self, b + "wep", wep_none);
					if(_primary){
						wkick = 0;
						scrSwap();
					}
	
					 // Trident:
					with(obj_create(x, y, "Trident")){
						projectile_init(other.team, other);
						motion_add(other.gunangle, 18);
						image_angle = direction;
						curse = other.bcurse;
					}
					weapon_post(-4, 50, 5);
				}

				 // Stab Trident:
				else{
					var l = weapon_get_load(wep),
						d = gunangle;
					
					reload = l;
					can_shoot = false;
					weapon_post(0, -20, 8);

					 // Stabby:
					l *= power(1.5, skill_get(mut_long_arms));
					variable_instance_set(self, b + "wkick", -l);
					with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), Shank)){
						projectile_init(other.team, other);

						mask_index = weapon_get_sprt(w);
						direction = d;
						image_angle = direction;
						visible = false;

						damage = 16;
					}
				}

				 // Effects:
				sleep(15);
				var n = random_range(0.8, 1.2);
				sound_play_pitchvol(sndAssassinAttack,		1.3	* n, 1.6);
				sound_play_pitchvol(sndOasisExplosionSmall,	0.7	* n, 0.7);
				sound_play_pitchvol(sndOasisDeath,			1.2	* n, 0.8);
				sound_play_pitchvol(sndOasisMelee,			1	* n, 1);
		
				 // bubbol:
				var l = 24,
					d = gunangle;

				with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), Bubble)){
					motion_set(d + orandom(30), choose(1, 2, 2, 3, 3))
				}
	    	}
	    }
    	w.chrg_num = 0;
    }


/// Scripts:
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call("mod", "telib", "obj_create", _x, _y, _obj);
#define scrSwap()                                                                       return  mod_script_call("mod", "telib", "scrSwap");
#define frame_active(_interval)                                                         return  mod_script_call(   "mod", "telib", "frame_active", _interval);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);