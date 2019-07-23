#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.sprWep = spr.Trident;
    global.sprWepLocked = mskNone;

#macro spr global.spr

#macro wepLWO {
	wep 	 : mod_current,
	chrg	 : false,
	chrg_num : 0,
	chrg_max : 7,
	wepangle : 0,
	primary  : true,
	visible  : true
	}

#define weapon_name		return (weapon_avail() ? "TRIDENT" : "LOCKED");
#define weapon_text		return "SCEPTER OF THE @bSEA";
#define weapon_type		return 0;  // Melee
#define weapon_load		return 14; // 0.47 Seconds (Stab Length)
#define weapon_area		return (weapon_avail() ? 7 : -1); // 3-2
#define weapon_auto		return true;
#define weapon_melee	return false;
#define weapon_chrg		return true;
#define weapon_swap(w)	return (lq_defget(w, "visible", true) ? sndSwapSword : sndSwapCursed);
#define weapon_sprt(w)	return (lq_defget(w, "visible", true) ? (weapon_avail() ? global.sprWep : global.sprWepLocked) : mskNone);
#define weapon_avail	return unlock_get("coastWep");

#define weapon_fire(w)
	if(!is_object(w)){
		step(true);
		w = wep;
	}

	 // Charge Trident:
	if(w.visible){
		w.chrg = true;
		w.primary = (race != "steroids" || !specfiring);
    	if(w.chrg_num < w.chrg_max){
    		var n = reloadspeed;
    		n *= 1 + (skill_get(mut_stress) * (1 - (my_health / maxhealth)));
    		if(race == "venuz"){
    			n *= 1.2 + (0.4 * ultra_get(race, 2));
    		}
    		w.chrg_num += n * current_time_scale;

			 // Charging FX:
			sound_play_pitch(sndOasisMelee, 1 / (1 - ((w.chrg_num / w.chrg_max) * 0.25)));

	    	 // Full Charge:
			if(w.chrg_num >= w.chrg_max){
				w.chrg_num = w.chrg_max;

				 // FX:
				var	l = 16,
					d = gunangle;
		
				instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), ThrowHit);
				instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), ImpactWrists);
				sound_play_pitch(sndCrystalRicochet, 3);
				sound_play_pitch(sndSewerDrip,		 3);
				sleep(5);
			}
    	}

    	 // Fully Charged - Blink:
    	else if(frame_active(12)){
			gunshine = 2;
		}

    	 // Pullback:
    	var f = (w.chrg_num / w.chrg_max);
	    weapon_post(9 * f, 8 * f, 0);
		
		 // Pop Pop:
		if(race == "venuz" && specfiring){
			w.chrg_num = w.chrg_max;
		}
	}
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
    if(!w.chrg){
    	if(w.chrg_num > 0 && w.primary == _primary){
			 // Throw Trident:
		    if(w.chrg_num >= w.chrg_max){
		    	var c = variable_instance_get(self, b + "curse");
		    	if(!c){
					variable_instance_set(self, b + "wep", wep_none);
					if(_primary){
						wkick = 0;
						scrSwap();
					}
		    	}
		    	else w.visible = false;

				 // Trident:
				with(obj_create(x, y, "Trident")){
					projectile_init(other.team, other);
					motion_add(other.gunangle, 18);
					image_angle = direction;
					curse = c;
					wep = w;
				}
				weapon_post(-4, 50, 5);
			}

			 // Stab Trident:
			else{
				var l = weapon_get_load(w),
					d = gunangle;
				
				variable_instance_set(self, b + "reload",	 l);
				variable_instance_set(self, b + "can_shoot", false);
				weapon_post(wkick, -20, 8);

				 // Stabby:
				l += 8 * skill_get(mut_long_arms);
				variable_instance_set(self, b + "wkick", -l);
				for(var i = l + 8; i > 0; i -= 16){
					with(instance_create(x + lengthdir_x(i, d), y + lengthdir_y(i, d) - (_primary ? 0 : 4), Shank)){
						projectile_init(other.team, other);

						motion_add(d, 1 * (1 + (2 * skill_get(mut_long_arms))));
						image_angle = direction;
						image_xscale = 0.5;
						depth = other.depth - 1;
						canfix = false;
						damage = 20;

						 // Secret Shanks:
						if(i < l) visible = false;
						
						 // Hit Wall:
						else if(place_meeting(x + hspeed, y + vspeed, Wall)){
							sound_play(sndMeleeWall);
							instance_create(x + orandom(4), y + orandom(4), Debris);
							with(instance_nearest(x + hspeed - 8, y + vspeed - 8, Wall)){
								with(instance_create(x + 8 + orandom(4), y + 8 + orandom(4), MeleeHitWall)){
									image_angle = d;
								}
							}
						}

						mask_index = mskSlash;
					}
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
    	w.chrg_num = 0;
    }
    w.chrg = false;

     // Curse Harpoon Grab Reorient:
    if(w.wepangle != 0){
    	script_bind_end_step(end_step, 0, _primary, self);
    }

#define end_step(_primary, _inst)
	instance_destroy();

	 // Wepangle Transition:
	var b = (_primary ? "" : "b"),
		w = variable_instance_get(_inst, b + "wep");

	variable_instance_set(_inst, b + "wepangle", w.wepangle);
	w.wepangle -= clamp(w.wepangle * 0.4, -40, 40) * current_time_scale;
	if(abs(w.wepangle) < 1) w.wepangle = 0;


/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);
#define scrSwap()                                                                       return  mod_script_call("mod", "telib", "scrSwap");
#define frame_active(_interval)                                                         return  mod_script_call("mod", "telib", "frame_active", _interval);