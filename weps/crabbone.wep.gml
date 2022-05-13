#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep = spr.Bone;
	
	 // Quest:
	global.quest_part_info_list = [
		{ "name": "ANCIENT ARTIFACT", "text": "SECRETS LIE WITHIN",        "sprt": sprite_add_weapon("../sprites/weps/sprArtifact0.png", 3, 5) },
		{ "name": "GUARDED ARTIFACT", "text": "UNCONVENTIONAL WEAPONRY",   "sprt": sprite_add_weapon("../sprites/weps/sprArtifact1.png", 3, 5) },
		{ "name": "STOLEN ARTIFACT",  "text": "BRING IT BACK",             "sprt": sprite_add_weapon("../sprites/weps/sprArtifact2.png", 3, 5) },
		{ "name": "MISSING ARTIFACT", "text": "HARDLY FOUND, EASILY LOST", "sprt": sprite_add_weapon("../sprites/weps/sprArtifact3.png", 3, 5) }
	];
	
	 // LWO:
	global.lwoWep = {
		"wep"   : mod_current,
		"ammo"  : 1,
		"combo" : 0
	};
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr

#macro _wepXis_quest_part   ("quest_part_index_list" in _wep && array_length(_wep.quest_part_index_list))
#macro _wepXquest_last_part global.quest_part_info_list[_wep.quest_part_index_list[array_length(_wep.quest_part_index_list) - 1]]

// for(var i = 0; i < 4; i++) w cm(WepPickup) wep = { wep:"crabbone", quest_part_index_list:[i] }

#define weapon_name(_wep)    return (_wepXis_quest_part ? _wepXquest_last_part.name        : ((lq_defget(_wep, "ammo", 1) > 0) ? loc("NTTE:Bone", "BONE") : "DROP"));
#define weapon_text(_wep)    return (_wepXis_quest_part ? _wepXquest_last_part.text        : "BONE THE FISH"); // yokin no
#define weapon_sprt(_wep)    return (_wepXis_quest_part ? _wepXquest_last_part.sprt        : ((lq_defget(_wep, "ammo", 1) > 0) ? global.sprWep : mskNone));
#define weapon_swap(_wep)    return (_wepXis_quest_part ? sndSwapHammer                    : sndBloodGamble);
#define weapon_shrine(_wep)  return (_wepXis_quest_part ? [mut_long_arms, mut_laser_brain] : mut_long_arms);
#define weapon_load          return ((wep_get(true, "curse", 0) > 0) ? 30 : 6); // 0.2 Seconds (Cursed ~ 1 Second)

#define weapon_area
	 // Drops naturally if a player is already carrying bones:
	with(Player){
		if(
			call(scr.wep_raw, wep)  == mod_current ||
			call(scr.wep_raw, bwep) == mod_current
		){
			var _wep = wep;
			if(!_wepXis_quest_part){
				return 4; // 1-3
			}
		}
	}
	
	 // If not, it don't:
	return -1;
	
#define weapon_type(_wep)
	 // Return Other Weapon's Ammo Type:
	if(instance_is(self, AmmoPickup) && instance_is(other, Player) && other.wep == _wep){
		with(other){
			return weapon_get_type(bwep);
		}
	}
	
	 // Normal:
	return type_melee;
	
#define weapon_sprt_hud(_wep)
	 // Custom Ammo Drawing:
	if(lq_defget(_wep, "ammo", 0) > 1){
		return call(scr.weapon_ammo_hud, _wep);
	}
	
	 // Normal:
	return weapon_get_sprt(_wep);
	
#define weapon_ntte_eat(_wep)
	 // Fix Stacked Eating:
	if(is_object(_wep)){
		var _num = (lq_defget(_wep, "ammo", 0) - 1);
		if(_num > 0) repeat(_num){
			 // Regurgitate:
			if(ultra_get("robot", 2) > 0 && chance(3, 7)){
				sound_play_hit_big(sndRegurgitate, 0.2);
				repeat(ultra_get("robot", 2)){
					instance_create(x, y, choose(AmmoChest, choose(WeaponChest, WeaponChest, HealthChest)));
				}
			}
			
			 // Normal:
			else if(random(maxhealth) > my_health && crown_current != crwn_life){
				instance_create(x, y, HPPickup)
			}
			else{
				instance_create(x, y, AmmoPickup)
			}
			
			 // Throne Butt:
			if(skill_get(mut_throne_butt) > 0){
				repeat(skill_get(mut_throne_butt)){
					instance_create(x, y, AmmoPickup);
				}
			}
		}
	}
	
#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	var _wepIsPart = _wepXis_quest_part;
	
	 // Cursed:
	var _curse = 0;
	with(_fire.creator){
		_curse = max(_curse, wep_get(true, "curse", 0));
	}
	if(_curse > 0){
		 // Shrink Wepangle:
		if(abs(wepangle) == 120){
			wepangle = 100 * sign(wepangle);
		}
		
		 // Slash:
		var	_skill = skill_get(mut_long_arms),
			_heavy = ((++_wep.combo % 2) == 0 && !_wepIsPart),
			_flip  = sign(wepangle),
			_dis   = lerp(10, 20, _skill) + (_wepIsPart ? -20 : 0),
			_dir   = gunangle;
			
		with(call(scr.projectile_create,
			x + hspeed + lengthdir_x(_dis, _dir),
			y + vspeed + lengthdir_y(_dis, _dir),
			(_wepIsPart ? "EnergyBatSlash" : "BoneSlash"),
			_dir + orandom(5 * accuracy),
			lerp(2, 4, _skill)
		)){
			image_xscale *= 3/4;
			image_yscale *= 3/4 * _flip;
			rotspeed      = 2 * _flip;
			if(_heavy){
				heavy = _heavy;
			}
		}
		
		 // Sounds:
		if(_wepIsPart){
			if(skill_get(mut_laser_brain) > 0){
				sound_play_pitchvol(sndEnergyHammerUpg, random_range(1.2, 1.5), 0.8);
				sound_play_pitchvol(sndBlackSword,      random_range(0.5, 0.7), 0.3);
			}
			else{
				sound_play_pitchvol(sndEnergyHammer, random_range(1.2, 1.5), 0.9);
				sound_play_pitchvol(sndBlackSword,   random_range(0.5, 0.7), 0.2);
			}
		}
		else{
			sound_play_gun(sndWrench, 0.3, 0.5);
			sound_play_hit(sndCursedReminder, 0.1);
			sound_play_pitchvol(sndBloodGamble, (_heavy ? 0.5 : 0.7) + random(0.2), (_heavy ? 0.7 : 0.5));
			if(_heavy){
				sound_play_pitch(sndHammer, 1 + random(0.2));
			}
		}
		
		 // Effects:
		instance_create(x, y, Dust);
		weapon_post(-9 - (3 * _heavy), 12 + (8 * _heavy), 1);
		motion_add(_dir + (20 * _flip), 3 + _heavy);
		if(_heavy) sleep(10);
	}
	
	 // Fire:
	else{
		var _lastInfAmmo = infammo;
		if(_wepIsPart){
			infammo = 0;
		}
		if(call(scr.weapon_ammo_fire, _wep)){
			 // Throw Bone:
			with(call(scr.projectile_create, x, y, "Bone", gunangle, lerp(16, 20, skill_get(mut_long_arms)))){
				wep      = lq_clone(_wep);
				wep.ammo = 1;
				curse    = _curse;
				if(_wepIsPart && other.infammo == 0){
					_wep.quest_part_index_list = array_slice(wep.quest_part_index_list, 0, array_length(wep.quest_part_index_list) - 1);
					wep.quest_part_index_list  = array_slice(wep.quest_part_index_list, array_length(wep.quest_part_index_list) - 1, 1);
				}
				sprite_index = weapon_get_sprt(wep);
				
				 // Death to Free Bones:
				if(other.infammo != 0){
					broken = true;
				}
			}
			
			 // Sound:
			sound_play(sndChickenThrow);
			if(_wepIsPart){
				sound_play_pitch(sndPlasmaReload, 2 + orandom(0.1));
			}
			else{
				sound_play_pitch(sndBloodGamble, 0.7 + random(0.2));
			}
			
			 // Effects:
			weapon_post(-10, -4, 4);
			with(instance_create(x, y, MeleeHitWall)){
				motion_add(other.gunangle, 1);
				image_angle = direction + 180;
			}
		}
		if(_wepIsPart){
			infammo = _lastInfAmmo;
		}
	}
	
	 // Gone:
	if(_wep.ammo <= 0 && _fire.wepheld){
		with(_fire.creator){
			if(!_fire.primary){
				call(scr.player_swap, self);
			}
			step(_fire.primary);
			if(!_fire.primary){
				call(scr.player_swap, self);
			}
		}
	}
	
#define step(_primary)
	var _wep = call(scr.weapon_step_init, _primary);
	
	 // Holdin Bone:
	if(_wep.ammo > 0){
		 // Extend Bone:
		var	_goal = -5,
			_kick = wep_get(_primary, "wkick", 0);
			
		if(_kick <= 0 && _kick > _goal){
			_kick = max(_goal, _kick - (2 * current_time_scale));
			wep_set(_primary, "wkick", _kick);
		}
		
		 // Pickup Bones:
		if(instance_exists(WepPickup) && place_meeting(x, y, WepPickup)){
			var _inst = call(scr.instances_meeting_instance, self, instances_matching_le(instances_matching(WepPickup, "visible", true), "curse", wep_get(_primary, "curse", 0)));
			if(array_length(_inst)) with(_inst){
				if(place_meeting(x, y, other)){
					if(call(scr.wep_raw, wep) == mod_current){
						var	_partIndexListA = lq_defget(_wep, "quest_part_index_list", []),
							_partIndexListB = lq_defget(wep,  "quest_part_index_list", []);
							
						if(
							(array_length(_partIndexListA) > 0) == (array_length(_partIndexListB) > 0)
							&& (!array_length(_partIndexListA) || !array_length(call(scr.instances_meeting_instance, self, obj.QuestFloorCont)))
						){
							var _num = lq_defget(wep, "ammo", 1);
							_wep.ammo += _num;
							
							 // Part:
							if(array_length(_partIndexListA) || array_length(_partIndexListB)){
								_wep.quest_part_index_list = call(scr.array_combine, _partIndexListA, _partIndexListB);
								
								 // Pickuped:
								with(other){
									if(_primary || race == "steroids"){
										wep_set(_primary, "wkick", 0);
										gunshine = max(gunshine, 2);
									}
									call(scr.pickup_text, weapon_get_name(other.wep), "got", _num);
								}
							}
							
							 // Bone:
							else{
								 // Pickuped:
								with(other){
									if(_primary || race == "steroids"){
										wep_set(_primary, "wkick", 0);
									}
									else{
										call(scr.pickup_text, weapon_get_name(other.wep), "add", _num);
									}
								}
								
								 // Epic Time:
								if(_wep.ammo > call(scr.stat_get, "bone")){
									call(scr.stat_set, "bone", _wep.ammo);
								}
							}
							
							 // Effects:
							with(instance_create(x, y, DiscDisappear)){
								image_angle = other.rotation;
							}
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
		}
		
		 // Sparkly:
		if(_wepXis_quest_part){
			if(_primary && chance_ct(1, 20)){
				var	_len = random_range(4, 12) - _kick,
					_dir = gunangle + ((_primary ? wepangle : bwepangle) * (1 - (_kick / 20)));
					
				with(call(scr.obj_create,
					x + lengthdir_x(_len, _dir) + orandom(4),
					y + lengthdir_y(_len, _dir) + orandom(4),
					"VaultFlowerSparkle"
				)){
					sprite_index = spr.QuestSparkle;
					depth		 = other.depth + (_primary ? -1 : 1);
					switch(_wep.quest_part_index_list[array_length(_wep.quest_part_index_list) - 1]){
						case 0 : sprite_index = spr.AllyLaserCharge;    break;
						case 1 : sprite_index = spr.ElectroPlasmaTrail; break;
						case 2 : sprite_index = sprIDPDPortalCharge;    break;
						case 3 : sprite_index = sprLaserCharge;         break;
					}
				}
			}
		}
		
		 // Bro don't look here:
		else if(_wep.ammo >= 10){
			 // E Indicator:
			if(!instance_exists(variable_instance_get(self, "prompt_scythe", noone))){
				prompt_scythe = call(scr.prompt_create, self, loc("NTTE:Bone:Prompt", "SCYTHE"));
				with(prompt_scythe){
					depth   = 1000000;
					index   = other.index;
					on_meet = script_ref_create(scythe_prompt_meet);
				}
			}
			prompt_scythe.yoff = sin(other.wave / 10);
			
			 // Bro 10 bones dont fit in a 3x3 square
			if(player_is_active(prompt_scythe.pick)){
				with(prompt_scythe){
					instance_destroy();
				}
				
				 // Give Scythe:
				call(scr.scythe_swap, _primary);
				
				 // Unlock:
				call(scr.unlock_set, "wep:scythe", true);
				
				 // Drop Spare Bones:
				_wep.ammo -= 10;
				if(_wep.ammo > 0) repeat(_wep.ammo){
					with(instance_create(x, y, WepPickup)){
						wep = mod_current;
					}
				}
			}
		}
		else if("prompt_scythe" in self && instance_exists(prompt_scythe)){
			with(prompt_scythe){
				instance_destroy();
			}
		}
	}
	
	 // No Bones Left:
	else{
		wep_set(_primary, "wep",   wep_none);
		wep_set(_primary, "wkick", 0);
		
		 // Auto Swap to Secondary:
		if(_primary && instance_is(self, Player)){
			call(scr.player_swap, self);
			clicked   = false;
			swapmove  = true;
			drawempty = 30;
			
			 // Prevent Shooting Until Trigger Released:
			if(wep != wep_none && fork()){
				while(instance_exists(self) && canfire && button_check(index, "fire")){
					reload    = max(2 * reloadspeed * current_time_scale, reload);
					can_shoot = false;
					clicked   = false;
					wait 0;
				}
				exit;
			}
		}
	}
	
#define scythe_prompt_meet
	return (other.index == index && call(scr.wep_raw, other.wep) == mod_current);
	
	
/// SCRIPTS
#macro  call                                                                                    script_ref_call
#macro  obj                                                                                     global.obj
#macro  scr                                                                                     global.scr
#macro  spr                                                                                     global.spr
#macro  snd                                                                                     global.snd
#macro  msk                                                                                     spr.msk
#macro  mus                                                                                     snd.mus
#macro  lag                                                                                     global.debug_lag
#macro  ntte                                                                                    global.ntte_vars
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  current_frame_active                                                                    ((current_frame + global.epsilon) % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        if(((_primary ? '' : 'b') + _name) in self) variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);