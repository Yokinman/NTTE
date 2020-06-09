#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	
	global.sprWep            = spr.Trident;
	global.sprWepGold        = spr.GoldTrident;
	global.sprWepLoadout     = spr.TridentLoadout;
	global.sprWepGoldLoadout = spr.GoldTridentLoadout;
	global.sprWepLocked      = mskNone;
	
	lwoWep = {
		wep      : mod_current,
		gold     : false,
		chrg     : false,
		chrg_num : 0,
		chrg_max : 7,
		chrg_obj : noone,
		stab_dis : 14,
		wepangle : 0,
		primary  : true,
		visible  : true
	};
	
#macro spr global.spr

#macro lwoWep global.lwoWep

#define weapon_name(w)   return (weapon_avail(w) ? ((weapon_gold(w) != 0) ? "GOLDEN " : "") + "TRIDENT" : "LOCKED");
#define weapon_text(w)   return ((weapon_get_gold(w) != 0) ? "SHINE THROUGH THE SKY" : "SCEPTER OF THE @bSEA");
#define weapon_swap(w)   return (lq_defget(w, "visible", true) ? sndSwapSword : sndSwapCursed);
#define weapon_sprt(w)   return (lq_defget(w, "visible", true) ? (weapon_avail() ? ((weapon_get_gold(w) != 0) ? global.sprWepGold : global.sprWep) : global.sprWepLocked) : mskNone);
#define weapon_loadout   return ((argument_count > 0 && weapon_get_gold(argument0) != 0) ? global.sprWepGoldLoadout : global.sprWepLoadout);
#define weapon_area(w)   return ((argument_count > 0 && weapon_avail(w) && weapon_get_gold(w) == 0) ? 7 : -1); // 3-2
#define weapon_gold(w)   return (lq_defget(w, "gold", false) ? -1 : 0);
#define weapon_type(w)   return type_melee;
#define weapon_auto(w)   return true;
#define weapon_melee(w)  return false;
#define weapon_avail     return (unlock_get("pack:coast") || unlock_get("wep:" + mod_current));
#define weapon_chrg      return true; // Defpack 4

#define weapon_load(w)
	 // Stab Reload:
	if(is_object(w) && instance_is(self, Player)){
		if((wep == w && reload > 0 && !can_shoot) || (bwep == w && breload > 0 && !bcan_shoot)){
			return w.stab_dis;
		}
	}
	
	 // Normal:
	return current_time_scale;
	
#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
	
	 // Charge Trident:
	if(w.visible){
		w.chrg = true;
		w.primary = !f.spec;
		
		 // Charging:
		if(w.chrg_num < w.chrg_max){
			 // Determine Charge Speed:
			var s = 1;
			with(f.creator) if(instance_is(self, Player)){
				s *= reloadspeed;
				s *= 1 + (skill_get(mut_stress) * (1 - (my_health / maxhealth)));
			}
			if(race == "venuz"){
				s *= 1.2 + (0.4 * ultra_get(race, 2));
			}
			
			 // Charge:
			w.chrg_num += s * current_time_scale;
			
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
			with(f.creator) if(instance_is(self, Player)){
				gunshine = 2;
			}
		}
		
		 // Pullback:
		var n = (w.chrg_num / w.chrg_max);
		weapon_post(9 * n, 8 * n * current_time_scale, 0);
		
		 // Pop Pop, Blood Gamble:
		if(f.spec && !f.roids){
			w.chrg_num = w.chrg_max;
		}
		
		 // Charge Controller:
		if(!instance_exists(w.chrg_obj)){
			w.chrg_obj = script_bind_step(trident_chrg, 0, w);
		}
		with(w.chrg_obj) creator = other;
	}
	
#define trident_chrg(w)
	if(!w.chrg){
		with(creator){
			var	f = wepfire_init(w),
				b = (w.primary ? "" : "b");
				
			if(w.chrg_num > 0){
				if((b + "wep") not in self || variable_instance_get(f.creator, b + "wep") == w){
					 // Throw Trident:
					if(w.chrg_num >= w.chrg_max){
						var c = variable_instance_get(f.creator, b + "curse", false);
						
						 // Trident:
						with(obj_create(x, y, "Trident")){
							sprite_index = weapon_get_sprt(w);
							motion_add(other.gunangle, 18 * (1 + (0.3 * w.gold)));
							image_angle = direction;
							creator = f.creator;
							team = other.team;
							curse = c;
							wep = w;
						}
						weapon_post(-4, 50, 5);
						
						 // Lose Trident:
						with(f.creator) if(variable_instance_get(self, b + "wep") == w){
							if(!c){
								variable_instance_set(self, b + "wep", wep_none);
								
								var k = (b + "wkick");
								if(k in self) variable_instance_set(self, k, 0);
								
								 // Swap to Secondary:
								if(instance_is(self, Player) && w.primary){
									player_swap();
								}
							}
							else w.visible = false;
						}
					}
					
					 // Stab Trident:
					else{
						var	l = w.stab_dis,
							d = gunangle;
							
						variable_instance_set(self, b + "reload",	 l);
						variable_instance_set(self, b + "can_shoot", false);
						
						 // Long Arms:
						l += 8 * skill_get(mut_long_arms);
						
						 // Stabby:
						weapon_post(wkick, -20, 8);
						if((b + "wkick") in self){
							variable_instance_set(self, b + "wkick", -l);
						}
						
						 // Stab:
						var _off = 220 / l;
						for(var o = -_off; o <= _off; o += _off){
							for(var i = l + (8 * ((o == 0) ? 1 : 2/3)); i > 0; i -= 16){
								with(instance_create(x + hspeed + lengthdir_x(i, d + o), y + vspeed + lengthdir_y(i, d + o) - (w.primary ? 0 : 4), Shank)){
									direction = d + (o / 3);
									image_angle = direction;
									
									speed = 1 + skill_get(mut_long_arms);
									if(o != 0) speed /= 2;
									
									depth = other.depth - (1 + (0.1 * (o != 0)));
									image_xscale = 0.5 + (0.1 * (o == 0));
									image_yscale = 0.9;
									creator = f.creator;
									team = other.team;
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
								}
							}
						}
					}
					
					 // Effects:
					sleep(15);
					var n = random_range(0.8, 1.2);
					sound_play_pitchvol(sndAssassinAttack,      1.3 * n, 1.6);
					sound_play_pitchvol(sndOasisExplosionSmall, 0.7 * n, 0.7);
					sound_play_pitchvol(sndOasisDeath,          1.2 * n, 0.8);
					sound_play_pitchvol(sndOasisMelee,          1   * n, 1);
					if(w.gold){
						sound_play_pitchvol(sndSwapGold,        0.8 * n, 0.7);
					}
					
					 // bubbol:
					var	l = 24,
						d = gunangle;
						
					with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), Bubble)){
						motion_set(d + orandom(30), choose(1, 2, 2, 3, 3));
					}
				}
			}
			w.chrg_num = 0;
		}
		instance_destroy();
	}
	w.chrg = false;
	
#define step(_primary)
	var	b = (_primary ? "" : "b"),
		w = variable_instance_get(self, b + "wep");
		
	 // LWO Setup:
	if(!is_object(w)){
		w = lq_clone(lwoWep);
		variable_instance_set(self, b + "wep", w);
	}
	
	 // Cursed Trident Grab Reorient:
	if(w.wepangle != 0){
		script_bind_end_step(end_step, 0, _primary, self);
	}
	
#define end_step(_primary, _inst)
	instance_destroy();
	
	 // Wepangle Transition:
	if(instance_exists(_inst)){
		var	b = (_primary ? "" : "b"),
			w = variable_instance_get(_inst, b + "wep");
			
		if(is_object(w) && "wepangle" in w){
			variable_instance_set(_inst, b + "wepangle", w.wepangle);
			w.wepangle -= clamp(w.wepangle * 0.4, -40, 40) * current_time_scale;
			if(abs(w.wepangle) < 1) w.wepangle = 0;
		}
	}
	
	
/// SCRIPTS
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define wepfire_init(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepfire_init', _wep);
#define wepammo_draw(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_draw', _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_fire', _wep);
#define frame_active(_interval)                                                         return  mod_script_call_nc('mod', 'telib', 'frame_active', _interval);
#define player_swap()                                                                   return  mod_script_call(   'mod', 'telib', 'player_swap');