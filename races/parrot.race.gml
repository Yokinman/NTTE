#define init
	with(Loadout){
		instance_destroy();
		with(loadbutton) instance_destroy();
	}
	
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	mus = mod_variable_get("mod", "teassets", "mus");
	sav = mod_variable_get("mod", "teassets", "sav");
	
	DebugLag = false;
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

/// General
#define race_name            return "PARROT";
#define race_text            return "MANY FRIENDS#@rCHARM ENEMIES";
#define race_lock            return "REACH @1(sprInterfaceIcons)1-1";
#define race_tb_text         return "@wPICKUPS @sGIVE @rFEATHERS@s";
#define race_portrait(p, b)  return race_sprite_raw("Portrait", b);
#define race_mapicon(p, b)   return race_sprite_raw("Map",      b);
#define race_avail           return unlock_get(mod_current);

#define race_ttip
	if(GameCont.level >= 10 && chance(1, 5)){
		return choose("MIGRATION FORMATION", "CHARMED, I'M SURE", "ADVENTURING PARTY", "FREE AS A BIRD");
	}
	else{
		return choose("HITCHHIKER", "BIRDBRAIN", "PARROT IS AN EXPERT TRAVELER", "WIND UNDER MY WINGS", "PARROT LIKES CAMPING", "MACAW WORKS TOO", "CHESTS GIVE YOU @rFEATHERS@s");
	}
	
#define race_sprite(_spr)
	var b = (("bskin" in self && is_real(bskin)) ? bskin : 0);
	switch(_spr){
		case sprMutant1Idle:        return race_sprite_raw("Idle",         b);
		case sprMutant1Walk:        return race_sprite_raw("Walk",         b);
		case sprMutant1Hurt:        return race_sprite_raw("Hurt",         b);
		case sprMutant1Dead:        return race_sprite_raw("Dead",         b);
		case sprMutant1GoSit:       return race_sprite_raw("GoSit",        b);
		case sprMutant1Sit:         return race_sprite_raw("Sit",          b);
		case sprFishMenu:           return race_sprite_raw("Idle",         b);
		case sprFishMenuSelected:   return race_sprite_raw("MenuSelected", b);
		case sprFishMenuSelect:     return race_sprite_raw("Idle",         b);
		case sprFishMenuDeselect:   return race_sprite_raw("Idle",         b);
		case sprChickenFeather:     return race_sprite_raw("Feather",      b);
	}
	return mskNone;
	
#define race_sound(_snd)
	switch(_snd){
		case sndMutant1Wrld: return -1;
		case sndMutant1Hurt: return sndRavenHit;
		case sndMutant1Dead: return sndAllyDead;
		case sndMutant1LowA: return -1;
		case sndMutant1LowH: return -1;
		case sndMutant1Chst: return -1;
		case sndMutant1Valt: return -1;
		case sndMutant1Crwn: return -1;
		case sndMutant1Spch: return -1;
		case sndMutant1IDPD: return -1;
		case sndMutant1Cptn: return -1;
		case sndMutant1Thrn: return -1;
	}
	return -1;
	
#define race_sprite_raw(_spr, _skin)
	var s = lq_defget(spr.Race, mod_current, []);
	if(_skin >= 0 && _skin < array_length(s)){
		return lq_defget(s[_skin], _spr, -1);
	}
	return -1;
	

/// Menu
#define race_menu_select
	if(instance_is(self, CharSelect) || instance_is(other, CharSelect)){
		 // Yo:
		sound_play_pitchvol(sndMutant6Slct, 2, 0.6);
		
		 // Kun:
		if(fork()){
			wait 5 * current_time_scale;
			
			audio_sound_set_track_position(
				sound_play_pitchvol(sndMutant15Hurt, 2, 0.6),
				0.2
			);
			
			 // Extra singy noise:
			audio_sound_set_track_position(
				sound_play_pitchvol(sndMutant15Slct, 2.5, 0.2),
				0.2
			);
			
			exit;
		}
		
		return -1;
	}
	
	return sndRavenLift;

#define race_menu_confirm
	if(instance_is(self, Menu) || instance_is(other, Menu) || instance_is(other, UberCont)){
		 // Wah:
		sound_play_pitchvol(sndMutant6Slct, 2.4, 0.6);
		
		 // Tohohoho:
		if(fork()){
			wait 5 * current_time_scale;
			
			audio_sound_set_track_position(
				sound_play_pitchvol(sndMutant15Cnfm, 2.5, 0.5),
				0.4
			);
			
			exit;
		}
		
		return -1;
	}
	
	return sndRavenLand;

#define race_menu_button
	sprite_index = race_sprite_raw("Select", 0);
	image_index = !race_avail();
	
	
/// Skins
#define race_skins
	var _playersActive = 0;
	for(var i = 0; i < maxp; i++) _playersActive += player_is_active(i);
	if(_playersActive <= 1){
		return 2;
	}
	else{ // Fix co-op bugginess
		var n = 1;
		while(unlock_get(mod_current + chr(65 + n))) n++;
		return n;
	}

#define race_skin_avail(_skin)
	var _playersActive = 0;
	for(var i = 0; i < maxp; i++) _playersActive += player_is_active(i);
	if(_playersActive <= 1){
		if(_skin == 0) return true;
		return unlock_get(mod_current + chr(65 + real(_skin)));
	}
	else{ // Fix co-op bugginess
		return true;
	}

#define race_skin_name(_skin)
	if(race_skin_avail(_skin)){
		return chr(65 + _skin) + " SKIN";
	}
	else switch(_skin){
		case 0: return "EDIT THE SAVE FILE LMAO";
		case 1: return "COMPLETE THE#AQUATIC ROUTE";
	}
	
#define race_skin_button(_skin)
	sprite_index = race_sprite_raw("Loadout", _skin);
	image_index = !race_skin_avail(_skin);
	

/// Ultras
#macro ultFeath 1
#macro ultShare 2

#define race_ultra_name(_ultra)
	switch(_ultra){
		case ultFeath: return "BIRDS OF A FEATHER";
		case ultShare: return "FLOCK TOGETHER";
	}
	return "";
	
#define race_ultra_text(_ultra)
	switch(_ultra){
		case ultFeath: return "INCREASED @rFEATHER @sOUTPUT";
		case ultShare: return "@wFEATHERED @sENEMIES#SHARE @rHEALTH @sWITH YOU";
	}
	return "";
	
#define race_ultra_button(_ultra)
	sprite_index = race_sprite_raw("UltraIcon", 0);
	image_index = _ultra - 1; // why are ultras 1-based bro
	
#define race_ultra_icon(_ultra)
	return race_sprite_raw("UltraHUD" + chr(64 + _ultra), 0);
	
#define race_ultra_take(_ultra, _state)
	with(instances_matching(Player, "race", mod_current)){
		switch(_ultra){
			case ultFeath:
				feather_num_mult = 1 + (2 * _state);
				feather_targ_radius = 24 * (1 + _state);
				
				 // Bonus - Full Ammo:
				if(instance_exists(EGSkillIcon)){
					feather_ammo = feather_ammo_max;
				}
				break;
				
			case ultShare:
				// Look elsewhere bro
				break;
		}
	}
	
	 // Ultra Sound:
	if(_state && instance_exists(EGSkillIcon)){
		sound_play(sndBasicUltra);
		
		switch(_ultra){
			case ultFeath:
				 // Feathers:
				if(fork()){
					for(var i = 0; i < 8; i++){
						sound_play_pitchvol(sndSharpTeeth, 4 + sin(i / 3), 0.4);
						wait (1 + (2 * sin(i * 1.5))) * current_time_scale;
					}
					
					exit;
				}
				
				 // Charm:
				if(fork()){
					wait 7 * current_time_scale;
					
					var _snd = [sndBigBanditIntro, sndBigDogIntro, sndLilHunterAppear];
					for(var i = 0; i < array_length(_snd); i++){
						sound_play_pitchvol(_snd[i], 1.2, 0.8 - (i * 0.1));
						sound_play_pitch(sndBanditDie, 1.2 + (i * 0.4));
						wait 4 * current_time_scale;
					}
					
					exit;
				}
				break;
				
			case ultShare:
				if(fork()){
					sound_play_pitch(sndCoopUltraA, 2);
					sound_play_pitch(sndHPPickupBig, 0.8);
					sound_play_pitch(sndHealthChestBig, 1.5);
					
					wait 10 * current_time_scale;
					
					 // They Dyin:
					var _snd = [sndBigMaggotDie, sndScorpionDie, sndBigBanditDie];
					for(var i = 0; i < array_length(_snd); i++){
						sound_play_pitchvol(_snd[i], 1.3, 1.4);
						wait 5 * current_time_scale;
					}
					
					exit;
				}
				break;
		}
	}
	
	
#define create
	 // Random lets you play locked characters: (Can remove once 9941+ gets stable build)
	if(!unlock_get(mod_current)){
		race = "fish";
		player_set_race(index, race);
		exit;
	}
	
	 // Sprite:
	spr_feather = race_sprite(sprChickenFeather);
	
	 // Sound:
	snd_wrld = race_sound(sndMutant1Wrld);
	snd_hurt = race_sound(sndMutant1Hurt);
	snd_dead = race_sound(sndMutant1Dead);
	snd_lowa = race_sound(sndMutant1LowA);
	snd_lowh = race_sound(sndMutant1LowH);
	snd_chst = race_sound(sndMutant1Chst);
	snd_valt = race_sound(sndMutant1Valt);
	snd_crwn = race_sound(sndMutant1Crwn);
	snd_spch = race_sound(sndMutant1Spch);
	snd_idpd = race_sound(sndMutant1IDPD);
	snd_cptn = race_sound(sndMutant1Cptn);
	snd_thrn = race_sound(sndMutant1Thrn);
	footkind = 2; // Pla
	
	 // Perching Parrot:
	parrot_bob = [0, 1, 1, 0];
	if(bskin) for(var i = 0; i < array_length(parrot_bob); i++){
		parrot_bob[i] += 3;
	}
	
	 // Feather Related:
	feather_num = 12;
	feather_num_mult = 1;
	feather_ammo = 0;
	feather_ammo_max = 5 * feather_num;
	feather_ammo_hud = [];
	//feather_ammo_hud_flash = 0;
	feather_targ_radius = 24;
	feather_targ_delay = 0;
	
	 // Ultra B:
	charm_hplink_lock = my_health;
	charm_hplink_hud = 0;
	charm_hplink_hud_hp = array_create(2, 0);
	charm_hplink_hud_hp_lst = 0;

	 // Extra Pet Slot:
	ntte_pet_max = mod_variable_get("mod", "ntte", "pet_max") + 1;
	
	 // Re-Get Ultras When Revived:
	for(var i = 0; i < ultra_count(mod_current); i++){
		if(ultra_get(mod_current, i)){
			race_ultra_take(i, true);
		}
	}
	
#define game_start
	with(instances_matching(Player, "race", mod_current)){
		if(fork()){
			while(instance_exists(self) && "ntte_pet" not in self) wait 0;
			
			 // Parrot Pet:
			if(instance_exists(self) && array_length(ntte_pet) > 0){
				with(pet_spawn(x, y, "Parrot")){
					leader = other;
					visible = false;
					other.ntte_pet[array_length(other.ntte_pet) - 1] = id;
					stat_found = false;
					
					 // Special:
					bskin = other.bskin;
					if(bskin){
						spr_idle = spr.PetParrotBIdle;
						spr_walk = spr.PetParrotBWalk;
						spr_hurt = spr.PetParrotBHurt;
						spr_icon = spr.PetParrotBIcon;
					}
				}
			}
			
			 // Wait Until Level is Generated:
			while(instance_exists(self) && !visible) wait 0;
			
			 // Starting Feather Ammo:
			if(instance_exists(self)){
				repeat(feather_num){
					with(obj_create(x + orandom(16), y + orandom(16), "ParrotFeather")){
						sprite_index = other.spr_feather;
						bskin = other.bskin;
						index = other.index;
						creator = other;
						target = other;
						speed *= 3;
					}
				}
			}
			
			exit;
		}
	}
	
#define step
	if(DebugLag) trace_time();
	
	 /// ACTIVE : Charm
	if(button_check(index, "spec") || usespec > 0){
		var	_feathers = instances_matching(instances_matching(CustomObject, "name", "ParrotFeather"), "index", index),
			_feathersTargeting = instances_matching(instances_matching(_feathers, "canhold", true), "creator", id),
			_featherNum = ceil(feather_num * feather_num_mult);
			
		if(array_length(_feathersTargeting) < _featherNum){
			 // Retrieve Feathers:
			with(instances_matching(_feathers, "canhold", false)){
				 // Remove Charm Time:
				if(target != creator){
					if("ntte_charm" in target && (lq_defget(target.ntte_charm, "time", 0) > 0 || creator != other)){
						with(target){
							ntte_charm.time -= other.stick_time;
							if(ntte_charm.time <= 0){
								charm_instance(id, false);
							}
						}
					}
					target = creator;
				}
				
				 // Unstick:
				if(stick){
					stick = false;
					motion_add(random(360), 4);
				}
				
				 // Mine now:
				if(creator == other && array_length(_feathersTargeting) < _featherNum){
					other.feather_targ_delay = 3;
					array_push(_feathersTargeting, id);
				}
			}
			
			 // Excrete New Feathers:
			while(array_length(_feathersTargeting) < _featherNum && (feather_ammo > 0 || infammo != 0)){
				if(infammo == 0) feather_ammo--;
				
				 // Feathers:
				with(obj_create(x + orandom(4), y + orandom(4), "ParrotFeather")){
					sprite_index = other.spr_feather;
					bskin = other.bskin;
					index = other.index;
					creator = other;
					target = other;
					array_push(_feathersTargeting, id);
				}
				
				 // Effects:
				sound_play_pitchvol(sndSharpTeeth, 3 + random(3), 0.4);
			}
		}
		
		 // Targeting:
		if(array_length(_feathersTargeting) > 0){
			with(_feathersTargeting) canhold = true;
			
			if(feather_targ_delay <= 0){
				var	_targ = [],
					_targX = mouse_x[index],
					_targY = mouse_y[index],
					_targRadius = feather_targ_radius,
					_featherMax = array_length(_feathersTargeting);
					
				 // Gather All Potential Targets:
				with(instances_matching_lt(instance_rectangle_bbox(_targX - _targRadius, _targY - _targRadius, _targX + _targRadius, _targY + _targRadius, [enemy, RadMaggotChest, FrogEgg]), "size", 6)){
					if(collision_circle(_targX, _targY, _targRadius, id, true, false)){
						 // Intro played OR is not a boss:
						if(
							variable_instance_get(self, "intro", true)
							||
							!(array_exists([BanditBoss, ScrapBoss, LilHunter, Nothing, Nothing2, FrogQueen, HyperCrystal, TechnoMancer, Last, BigFish, OasisBoss], object_index) || variable_instance_get(self, "boss", false))
						){
							array_push(_targ, id);
							if(array_length(_targ) >= _featherMax) break;
						}
					}
				}
				
				 // Spread Feathers Out Evenly:
				if(array_length(_targ) > 0){
					var	_featherNum = 0,
						_spreadMax = max(1, ceil(_featherMax / array_length(_targ)));
						
					with(_targ){
						var _spreadNum = 0;
						while(_featherNum < _featherMax && _spreadNum < _spreadMax){
							with(_feathersTargeting[_featherNum]){
								target = other;
							}
							_featherNum++;
							_spreadNum++;
						}
					}
				}
				
				 // Nothing to Target, Return to Parrot:
				else{
					with(_feathersTargeting) target = other;
				}
			}
			
			 // Minor targeting delay so you can just click to return feathers:
			else{
				feather_targ_delay -= current_time_scale;
				with(_feathers) target = creator;
			}
		}
		
		 // No Feathers:
		else if(button_pressed(index, "spec")){
			sound_play_pitchvol(sndMutant0Cnfm, 3 + orandom(0.2), 0.5);
		}
	}
	
	 // Feather FX:
	if(lsthealth > my_health && (chance_ct(1, 10) || my_health <= 0)){
		repeat((my_health <= 0) ? 5 : 1) with(instance_create(x, y, Feather)){
			sprite_index = other.spr_feather;
			image_blend = c_gray;
		}
	}
	
	 // Pitched snd_hurt:
	if(sprite_index == spr_hurt && image_index == image_speed_raw){
		var _sndMax = sound_play_pitchvol(0, 0, 0);
		sound_stop(_sndMax);
		
		for(var i = _sndMax - 1; i >= _sndMax - 10; i--){
			if(audio_get_name(i) == audio_get_name(snd_hurt)){
				sound_pitch(i, 1.1 + random(0.4));
				sound_volume(i, 1.2);
				break;
			}
		}
	}
	
	 // Bind Ultra Script:
	if(array_length(instances_matching(CustomScript, "name", "step_charm_hplink")) <= 0){
		with(script_bind_end_step(step_charm_hplink, 0)){
			name = script[2];
			persistent = true;
		}
	}
	
	if(DebugLag) trace_time("parrot_step");
	
#define step_charm_hplink
	 /// ULTRA B : Flock Together / HP Link
	with(instances_matching(Player, "race", mod_current)){
		if(ultra_get(mod_current, ultShare)){
			 // Gather Charmed Bros:
			var _HPList = ds_list_create();
			with(instances_matching_gt(instances_matching_ne([hitme, becomenemy], "ntte_charm", null), "my_health", 0)){
				if(lq_defget(ntte_charm, "index", -1) == other.index){
					ds_list_add(_HPList, id);
				}
			}
			
			if(ds_list_size(_HPList) > 0){
				var _HPListSave = ds_list_to_array(_HPList);
				
				 // Steal Charmed Bro HP:
				if(nexthurt > current_frame && my_health < charm_hplink_lock){
					ds_list_shuffle(_HPList);
					
					while(my_health < charm_hplink_lock){
						if(ds_list_size(_HPList) > 0){
							with(ds_list_to_array(_HPList)){
								with(other){
									var a = min(1, charm_hplink_lock - my_health);
									if(a > 0){
										my_health += a;
										projectile_hit_raw(other, a, true);
										if(!instance_exists(other) || other.my_health <= 0){
											ds_list_remove(_HPList, other);
										}
									}
									else{
										my_health = charm_hplink_lock;
										break;
									}
								}
							}
						}
						else break;
					}
					my_health = charm_hplink_lock;
				}
				
				 // HUD Drawn Health:
				var _canChangeMax = (charm_hplink_hud_hp_lst <= charm_hplink_hud_hp[0]);
				for(var i = 0; i < array_length(charm_hplink_hud_hp); i++){
					if(i != 1 || _canChangeMax) charm_hplink_hud_hp[i] = 0;
				}
				with(_HPListSave){
					other.charm_hplink_hud_hp[0] += my_health;
					if(_canChangeMax) other.charm_hplink_hud_hp[1] += maxhealth;
				}
			}
			else{
				charm_hplink_hud_hp[0] -= ceil(charm_hplink_hud_hp[0] / 5) * current_time_scale;
				charm_hplink_hud_hp_lst -= ceil(charm_hplink_hud_hp_lst / 10) * current_time_scale;
			}
		}
		else charm_hplink_hud_hp_lst = 0;
		
		charm_hplink_lock = my_health;
		
		 // HUD Related:
		var a = 0.5 * current_time_scale;
		charm_hplink_hud_hp_lst += clamp(charm_hplink_hud_hp[0] - charm_hplink_hud_hp_lst, -a, a);
		
		var _hudGoal = (charm_hplink_hud_hp_lst >= 1);
		charm_hplink_hud += (_hudGoal - charm_hplink_hud) * 0.2 * current_time_scale;
		if(abs(_hudGoal - charm_hplink_hud) < 0.01) charm_hplink_hud = _hudGoal;
	}
	instance_destroy();
	
#define cleanup
	with(Loadout){
		instance_destroy();
		with(loadbutton) instance_destroy();
	}
	
	
/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  anim_end                                                                                image_index + image_speed_raw >= image_number
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
#macro  bbox_width                                                                              (bbox_right + 1) - bbox_left
#macro  bbox_height                                                                             (bbox_bottom + 1) - bbox_top
#macro  bbox_center_x                                                                           (bbox_left + bbox_right + 1) / 2
#macro  bbox_center_y                                                                           (bbox_top + bbox_bottom + 1) / 2
#macro  FloorNormal                                                                             instances_matching(Floor, 'object_index', Floor)
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define pfloor(_num, _precision)                                                        return  floor(_num / _precision) * _precision;
#define in_range(_num, _lower, _upper)                                                  return  (_num >= _lower && _num <= _upper);
#define frame_active(_interval)                                                         return  (current_frame % _interval) < current_time_scale;
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define surflist_set(_name, _x, _y, _width, _height)                                    return  mod_script_call_nc('mod', 'teassets', 'surflist_set', _name, _x, _y, _width, _height);
#define surflist_get(_name)                                                             return  mod_script_call_nc('mod', 'teassets', 'surflist_get', _name);
#define shadlist_set(_name, _vertex, _fragment)                                         return  mod_script_call_nc('mod', 'teassets', 'shadlist_set', _name, _vertex, _fragment);
#define shadlist_get(_name)                                                             return  mod_script_call_nc('mod', 'teassets', 'shadlist_get', _name);
#define shadlist_setup(_shader, _texture, _args)                                        return  mod_script_call_nc('mod', 'telib', 'shadlist_setup', _shader, _texture, _args);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define top_create(_x, _y, _obj, _spawnDir, _spawnDis)                                  return  mod_script_call_nc('mod', 'telib', 'top_create', _x, _y, _obj, _spawnDir, _spawnDis);
#define option_get(_name, _default)                                                     return  mod_script_call_nc('mod', 'telib', 'option_get', _name, _default);
#define option_set(_name, _value)                                                               mod_script_call_nc('mod', 'telib', 'option_set', _name, _value);
#define stat_get(_name)                                                                 return  mod_script_call_nc('mod', 'telib', 'stat_get', _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc('mod', 'telib', 'stat_set', _name, _value);
#define unlock_get(_name)                                                               return  mod_script_call_nc('mod', 'telib', 'unlock_get', _name);
#define unlock_set(_name, _value)                                                               mod_script_call_nc('mod', 'telib', 'unlock_set', _name, _value);
#define unlock_call(_name)                                                              return  mod_script_call_nc('mod', 'telib', 'unlock_call', _name);
#define unlock_splat(_name, _text, _sprite, _sound)                                     return  mod_script_call_nc('mod', 'telib', 'unlock_splat', _name, _text, _sprite, _sound);
#define trace_error(_error)                                                                     mod_script_call_nc('mod', 'telib', 'trace_error', _error);
#define view_shift(_index, _dir, _pan)                                                          mod_script_call_nc('mod', 'telib', 'view_shift', _index, _dir, _pan);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc('mod', 'telib', 'sleep_max', _milliseconds);
#define in_distance(_inst, _dis)                                                        return  mod_script_call(   'mod', 'telib', 'in_distance', _inst, _dis);
#define in_sight(_inst)                                                                 return  mod_script_call(   'mod', 'telib', 'in_sight', _inst);
#define instance_budge(_objAvoid, _disMax)                                              return  mod_script_call(   'mod', 'telib', 'instance_budge', _objAvoid, _disMax);
#define instance_random(_obj)                                                           return  mod_script_call_nc('mod', 'telib', 'instance_random', _obj);
#define instance_create_copy(_x, _y, _obj)                                              return  mod_script_call(   'mod', 'telib', 'instance_create_copy', _x, _y, _obj);
#define instance_create_lq(_x, _y, _lq)                                                 return  mod_script_call_nc('mod', 'telib', 'instance_create_lq', _x, _y, _lq);
#define instance_nearest_array(_x, _y, _inst)                                           return  mod_script_call_nc('mod', 'telib', 'instance_nearest_array', _x, _y, _inst);
#define instance_nearest_bbox(_x, _y, _inst)                                            return  mod_script_call_nc('mod', 'telib', 'instance_nearest_bbox', _x, _y, _inst);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc('mod', 'telib', 'instance_rectangle', _x1, _y1, _x2, _y2, _obj);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call_nc('mod', 'telib', 'instance_rectangle_bbox', _x1, _y1, _x2, _y2, _obj);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call_nc('mod', 'telib', 'instances_at', _x, _y, _obj);
#define instances_seen_nonsync(_obj, _bx, _by)                                          return  mod_script_call_nc('mod', 'telib', 'instances_seen_nonsync', _obj, _bx, _by);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   'mod', 'telib', 'instances_meeting', _x, _y, _obj);
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call_nc('mod', 'telib', 'draw_weapon', _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call_nc('mod', 'telib', 'draw_lasersight', _x, _y, _dir, _maxDistance, _width);
#define array_exists(_array, _value)                                                    return  mod_script_call_nc('mod', 'telib', 'array_exists', _array, _value);
#define array_count(_array, _value)                                                     return  mod_script_call_nc('mod', 'telib', 'array_count', _array, _value);
#define array_combine(_array1, _array2)                                                 return  mod_script_call_nc('mod', 'telib', 'array_combine', _array1, _array2);
#define array_delete(_array, _index)                                                    return  mod_script_call_nc('mod', 'telib', 'array_delete', _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call_nc('mod', 'telib', 'array_delete_value', _array, _value);
#define array_flip(_array)                                                              return  mod_script_call_nc('mod', 'telib', 'array_flip', _array);
#define array_shuffle(_array)                                                           return  mod_script_call_nc('mod', 'telib', 'array_shuffle', _array);
#define array_clone_deep(_array)                                                        return  mod_script_call_nc('mod', 'telib', 'array_clone_deep', _array);
#define lq_clone_deep(_obj)                                                             return  mod_script_call_nc('mod', 'telib', 'lq_clone_deep', _obj);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc('mod', 'telib', 'scrFX', _x, _y, _motion, _obj);
#define scrRight(_dir)                                                                          mod_script_call(   'mod', 'telib', 'scrRight', _dir);
#define scrWalk(_dir, _walk)                                                                    mod_script_call(   'mod', 'telib', 'scrWalk', _dir, _walk);
#define scrAim(_dir)                                                                            mod_script_call(   'mod', 'telib', 'scrAim', _dir);
#define enemy_walk(_spdAdd, _spdMax)                                                            mod_script_call(   'mod', 'telib', 'enemy_walk', _spdAdd, _spdMax);
#define enemy_hurt(_hitdmg, _hitvel, _hitdir)                                                   mod_script_call(   'mod', 'telib', 'enemy_hurt', _hitdmg, _hitvel, _hitdir);
#define enemy_shoot(_object, _dir, _spd)                                                return  mod_script_call(   'mod', 'telib', 'enemy_shoot', _object, _dir, _spd);
#define enemy_shoot_ext(_x, _y, _object, _dir, _spd)                                    return  mod_script_call(   'mod', 'telib', 'enemy_shoot_ext', _x, _y, _object, _dir, _spd);
#define enemy_target(_x, _y)                                                            return  mod_script_call(   'mod', 'telib', 'enemy_target', _x, _y);
#define boss_hp(_hp)                                                                    return  mod_script_call_nc('mod', 'telib', 'boss_hp', _hp);
#define boss_intro(_name, _sound, _music)                                               return  mod_script_call_nc('mod', 'telib', 'boss_intro', _name, _sound, _music);
#define corpse_drop(_dir, _spd)                                                         return  mod_script_call(   'mod', 'telib', 'corpse_drop', _dir, _spd);
#define rad_drop(_x, _y, _raddrop, _dir, _spd)                                          return  mod_script_call_nc('mod', 'telib', 'rad_drop', _x, _y, _raddrop, _dir, _spd);
#define rad_path(_inst, _target)                                                        return  mod_script_call_nc('mod', 'telib', 'rad_path', _inst, _target);
#define area_get_name(_area, _subarea, _loop)                                           return  mod_script_call_nc('mod', 'telib', 'area_get_name', _area, _subarea, _loop);
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call_nc('mod', 'telib', 'area_get_sprite', _area, _spr);
#define area_get_subarea(_area)                                                         return  mod_script_call_nc('mod', 'telib', 'area_get_subarea', _area);
#define area_get_secret(_area)                                                          return  mod_script_call_nc('mod', 'telib', 'area_get_secret', _area);
#define area_get_underwater(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_underwater', _area);
#define area_border(_y, _area, _color)                                                  return  mod_script_call_nc('mod', 'telib', 'area_border', _y, _area, _color);
#define area_generate(_area, _subarea, _x, _y, _setArea, _overlapFloor, _scrSetup)      return  mod_script_call_nc('mod', 'telib', 'area_generate', _area, _subarea, _x, _y, _setArea, _overlapFloor, _scrSetup);
#define floor_get(_x, _y)                                                               return  mod_script_call_nc('mod', 'telib', 'floor_get', _x, _y);
#define floor_set(_x, _y, _state)                                                       return  mod_script_call_nc('mod', 'telib', 'floor_set', _x, _y, _state);
#define floor_set_style(_style, _area)                                                  return  mod_script_call_nc('mod', 'telib', 'floor_set_style', _style, _area);
#define floor_set_align(_alignW, _alignH, _alignX, _alignY)                             return  mod_script_call_nc('mod', 'telib', 'floor_set_align', _alignW, _alignH, _alignX, _alignY);
#define floor_reset_style()                                                             return  mod_script_call_nc('mod', 'telib', 'floor_reset_style');
#define floor_reset_align()                                                             return  mod_script_call_nc('mod', 'telib', 'floor_reset_align');
#define floor_fill(_x, _y, _w, _h)                                                      return  mod_script_call_nc('mod', 'telib', 'floor_fill', _x, _y, _w, _h);
#define floor_fill_round(_x, _y, _w, _h)                                                return  mod_script_call_nc('mod', 'telib', 'floor_fill_round', _x, _y, _w, _h);
#define floor_fill_ring(_x, _y, _w, _h)                                                 return  mod_script_call_nc('mod', 'telib', 'floor_fill_ring', _x, _y, _w, _h);
#define floor_make(_x, _y, _obj)                                                        return  mod_script_call_nc('mod', 'telib', 'floor_make', _x, _y, _obj);
#define floor_reveal(_floors, _maxTime)                                                 return  mod_script_call_nc('mod', 'telib', 'floor_reveal', _floors, _maxTime);
#define floor_bones(_sprite, _num, _chance, _linked)                                    return  mod_script_call(   'mod', 'telib', 'floor_bones', _sprite, _num, _chance, _linked);
#define floor_walls()                                                                   return  mod_script_call(   'mod', 'telib', 'floor_walls');
#define wall_tops()                                                                     return  mod_script_call(   'mod', 'telib', 'wall_tops');
#define wall_clear(_x1, _y1, _x2, _y2)                                                          mod_script_call_nc('mod', 'telib', 'wall_clear', _x1, _y1, _x2, _y2);
#define sound_play_ntte(_type, _snd)                                                    return  mod_script_call_nc('mod', 'telib', 'sound_play_ntte', _type, _snd);
#define sound_play_hit_ext(_snd, _pit, _vol)                                            return  mod_script_call(   'mod', 'telib', 'sound_play_hit_ext', _snd, _pit, _vol);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call(   'mod', 'telib', 'race_get_sprite', _race, _sprite);
#define player_create(_x, _y, _index)                                                   return  mod_script_call_nc('mod', 'telib', 'player_create', _x, _y, _index);
#define player_swap()                                                                   return  mod_script_call(   'mod', 'telib', 'player_swap');
#define wep_get(_wep)                                                                   return  mod_script_call_nc('mod', 'telib', 'wep_get', _wep);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc('mod', 'telib', 'wep_merge', _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call_nc('mod', 'telib', 'wep_merge_decide', _hardMin, _hardMax);
#define weapon_decide(_hardMin, _hardMax, _gold, _noWep)                                return  mod_script_call(   'mod', 'telib', 'weapon_decide', _hardMin, _hardMax, _gold, _noWep);
#define skill_get_icon(_skill)                                                          return  mod_script_call(   'mod', 'telib', 'skill_get_icon', _skill);
#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)                        return  mod_script_call_nc('mod', 'telib', 'path_create', _xstart, _ystart, _xtarget, _ytarget, _wall);
#define path_shrink(_path, _wall, _skipMax)                                             return  mod_script_call_nc('mod', 'telib', 'path_shrink', _path, _wall, _skipMax);
#define path_reaches(_path, _xtarget, _ytarget, _wall)                                  return  mod_script_call_nc('mod', 'telib', 'path_reaches', _path, _xtarget, _ytarget, _wall);
#define path_direction(_path, _x, _y, _wall)                                            return  mod_script_call_nc('mod', 'telib', 'path_direction', _path, _x, _y, _wall);
#define path_draw(_path)                                                                return  mod_script_call(   'mod', 'telib', 'path_draw', _path);
#define portal_poof()                                                                   return  mod_script_call_nc('mod', 'telib', 'portal_poof');
#define portal_pickups()                                                                return  mod_script_call_nc('mod', 'telib', 'portal_pickups');
#define pet_spawn(_x, _y, _name)                                                        return  mod_script_call_nc('mod', 'telib', 'pet_spawn', _x, _y, _name);
#define pet_get_icon(_modType, _modName, _name)                                         return  mod_script_call(   'mod', 'telib', 'pet_get_icon', _modType, _modName, _name);
#define team_get_sprite(_team, _sprite)                                                 return  mod_script_call_nc('mod', 'telib', 'team_get_sprite', _team, _sprite);
#define team_instance_sprite(_team, _inst)                                              return  mod_script_call_nc('mod', 'telib', 'team_instance_sprite', _team, _inst);
#define sprite_get_team(_sprite)                                                        return  mod_script_call_nc('mod', 'telib', 'sprite_get_team', _sprite);
#define scrPickupIndicator(_text)                                                       return  mod_script_call(   'mod', 'telib', 'scrPickupIndicator', _text);
#define scrAlert(_inst, _sprite)                                                        return  mod_script_call(   'mod', 'telib', 'scrAlert', _inst, _sprite);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   'mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_instance, _charm)                                               return  mod_script_call_nc('mod', 'telib', 'charm_instance', _instance, _charm);
#define door_create(_x, _y, _dir)                                                       return  mod_script_call_nc('mod', 'telib', 'door_create', _x, _y, _dir);