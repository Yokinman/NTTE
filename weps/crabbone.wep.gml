#define init
	global.sprWep = sprite_add_weapon("../sprites/weps/sprBone.png", 6, 6);
	
	lwoWep = {
		wep  : mod_current,
		ammo : 1
	};
	
#macro lwoWep global.lwoWep

#define weapon_name  return "BONE";
#define weapon_text  return "BONE THE FISH"; // yokin no
#define weapon_load  return (variable_instance_get(self, "curse", false) ? 30 : 6); // 0.2 Seconds
#define weapon_swap  return sndBloodGamble;

#define weapon_type(w)
	 // Return Other Weapon's Ammo Type:
	if(instance_is(self, AmmoPickup) && instance_is(other, Player)){
		with(other) return weapon_get_type((w == wep) ? bwep : wep);
	}
	
	 // Melee:
	return 0;
	
#define weapon_area
	 // Drops naturally if a player is already carrying bones:
	with(Player) if(wep_get(wep) == mod_current || wep_get(bwep) == mod_current){
		return 4;
	}
	
	 // If not, it don't:
	return -1;
	
#define weapon_sprt(w)
	 // Custom Ammo Drawing:
	if(lq_defget(w, "ammo", 0) > 1){
		wepammo_draw(w);
	}
	
	return global.sprWep;
	
#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
	
	 // Cursed:
	var _curse = variable_instance_get(self, "curse", false);
	if(_curse){
	    var	_flip = sign(wepangle),
	    	l = 10 + (10 * skill_get(mut_long_arms)),
	    	d = gunangle;
	    	
	    with(obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "BoneSlash")){
	        motion_add(other.gunangle + orandom(5 * other.accuracy), 2 + (3 * skill_get(mut_long_arms)));
	        image_angle = direction;
	        rotspeed = -2 * _flip;
	        creator = f.creator;
	        team = other.team;
	        image_xscale *= 3/4;
	        image_yscale = image_xscale * _flip;
	    }
	    
	     // Effects:
	    wepangle *= -1;
	    weapon_post(-8, 12, 1);
	    motion_add(other.aimDirection, 4);
	    sound_play_gun(sndScrewdriver, 0.2, 0.6);
		sound_play_pitch(sndBloodGamble, 0.7 + random(0.2));
		sound_play(sndCursedReminder);
	    instance_create(x, y, Dust);
	}
	
	 // Fire:
	else if(wepammo_fire(w)){
		 // Throw Bone:
		with(obj_create(x, y, "Bone")){
			motion_add(other.gunangle, 16);
			rotation = direction;
			creator = f.creator;
			team = other.team;
			curse = _curse;
			
			 // Death to Free Bones:
			if(other.infammo != 0) broken = true;
		}
		
		 // Effects:
		wepangle *= -1;
		weapon_post(-10, -4, 4);
		sound_play(sndChickenThrow);
		sound_play_pitch(sndBloodGamble, 0.7 + random(0.2));
		with(instance_create(x, y, MeleeHitWall)){
			motion_add(other.gunangle, 1);
			image_angle = direction + 180;
		}
	}
	
	 // Gone:
	if(w.ammo <= 0 && f.wepheld && !f.roids){
		with(f.creator) step(true);
	}
	
#define step(_primary)
	var	b = (_primary ? "" : "b"),
		w = variable_instance_get(self, b + "wep");
		
	 // LWO Setup:
	if(!is_object(w)){
		w = lq_clone(lwoWep);
		variable_instance_set(self, b + "wep", w);
	}
	
	 // Holdin Bone:
	if(w.ammo > 0){
		 // Extend Bone:
		variable_instance_set(self, b + "wkick", min(-5, variable_instance_get(self, b + "wkick")));
		
		 // Pickup Bones:
		if(place_meeting(x, y, WepPickup)){
			with(instances_meeting(x, y, instances_matching(WepPickup, "visible", true))){
				if(place_meeting(x, y, other)){
					if(wep_get(wep) == mod_current){
						w.ammo++;
						
						with(other){
							if(_primary || race == "steroids"){
								variable_instance_set(self, b + "wkick", min(-8, variable_instance_get(self, b + "wkick")));
							}
							else with(instance_create(x, y, PopupText)){
								text = "+1 BONE";
							}
						}
						
						 // Curse:
						if(curse > other.curse){
							other.curse = curse;
							sound_play_pitch(sndCursedChest, 1.2);
						}
						
						 // Epic Time:
						if(w.ammo > stat_get("bone")){
							stat_set("bone", w.ammo);
						}
						
						 // Effects:
						with(instance_create(x, y, DiscDisappear)) image_angle = other.rotation;
						with(other){
							sound_play_pitch(sndHPPickup, 4);
							sound_play_pitch(sndPickupDisappear, 1.2);
							sound_play_pitchvol(sndBloodGamble, 0.4 + random(0.2), 0.9);
						}
						
						instance_destroy();
					}
				}
			}
		}
		
		 // Bro don't look here:
		if(w.ammo >= 10){
			 // E Indicator:
			if(!instance_exists(variable_instance_get(id, "pickup_scythe", noone))){
				pickup_scythe = obj_create(x, y, "PickupIndicator");
				with(pickup_scythe){
					text = "SCYTHE";
					creator = other;
					index = other.index;
					depth = 1000000;
					on_meet = script_ref_create(scythe_PickupIndicator_meet);
				}
			}
			pickup_scythe.yoff = sin(other.wave / 10);
			
			 // Bro 10 bones dont fit in a 3x3 square
			if(player_is_active(pickup_scythe.pick)){
				var _wep = "scythe";
				variable_instance_set(id, b + "wep", _wep);
				
				 // Unlock:
				unlock_set("wep:" + _wep, true);
				
				 // Drop Spare Bones:
				w.ammo -= 10;
				if(w.ammo > 0) repeat(w.ammo){
					with(instance_create(x, y, WepPickup)){
						wep = mod_current;
					}
				}
				
				 // Sounds:
				sound_play_pitch(weapon_get_swap(wep), 0.5);
				sound_play_pitchvol(sndCursedChest, 0.9, 2);
				sound_play_pitchvol(sndFishWarrantEnd, 1.2, 2);
				
				wkick = -3;
				gunshine = 1;
				swapmove = 1;
				
				 // !
				with(instance_create(x, y, PopupText)){
					target = other.index;
					mytext = weapon_get_name(_wep) + "!";
				}
				
				 // Bone Piece Effects:
				var	l = 12,
					d = gunangle + wepangle;
					
				repeat(8){
					with(obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "BoneFX")){
						motion_add(d, 1);
						creator = other;
					}
				}
				
				l = 8;
				repeat(6){
					with(scrFX(x + lengthdir_x(l, d), y + lengthdir_y(l, d), [d + orandom(60), 1 + random(5)], Dust)) depth = -3;
				}
				
				with(pickup_scythe) instance_destroy();
			}
		}
		else with(variable_instance_get(id, "pickup_scythe", noone)){
			instance_destroy();
		}
	}
	
	 // No Bones Left:
	else{
		variable_instance_set(self, b + "wep", wep_none);
		if(instance_is(self, Player)){
			variable_instance_set(self, b + "wkick", 0);
			
			 // Auto Swap to Secondary:
			if(_primary){
				player_swap();
				
				 // Prevent Shooting Until Trigger Released:
				if(wep != wep_none && fork()){
					while(instance_exists(self) && canfire && button_check(index, "fire")){
						reload = max(2, reload);
						can_shoot = false;
						clicked = false;
						wait 0;
					}
					exit;
				}
			}
		}
	}
	
#define scythe_PickupIndicator_meet
	if(other.index == index && wep_get(other.wep) == mod_current){
		return true;
	}
	return false;
	
	
/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define unlock_set(_name, _value)                                                       return  mod_script_call_nc('mod', 'teassets', 'unlock_set', _name, _value);
#define stat_get(_name)                                                                 return  mod_script_call(   'mod', 'teassets', 'stat_get', _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc('mod', 'teassets', 'stat_set', _name, _value);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define wepfire_init(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepfire_init', _wep);
#define wepammo_draw(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_draw', _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_fire', _wep);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   'mod', 'telib', 'instances_meeting', _x, _y, _obj);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc('mod', 'telib', 'scrFX', _x, _y, _motion, _obj);
#define player_swap()                                                                   return  mod_script_call(   'mod', 'telib', 'player_swap');
#define wep_get(_wep)                                                                   return  mod_script_call(   'mod', 'telib', 'wep_get', _wep);