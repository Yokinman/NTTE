#define init
	with(Loadout){
		instance_destroy();
		with(loadbutton) instance_destroy();
	}

    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.sav = mod_variable_get("mod", "teassets", "sav");

    while(true){
         // Chests Give Feathers:
        if(!instance_exists(GenCont)){
            with(instances_matching(chestprop, "my_feather_storage", null)){
                my_feather_storage = obj_create(x, y, "ParrotChester");
    
                 // Vars:
                with(my_feather_storage){
                    creator = other;
                    switch(other.object_index){
                        case IDPDChest:
                        case BigWeaponChest:
                        case BigCursedChest:
                            num = 18; break;
                        case GiantWeaponChest:
                        case GiantAmmoChest:
                            num = 60; break;
                    }
                }
            }

             // Throne Butt : Pickups Give Feathers
            if(skill_get(mut_throne_butt) > 0){
                with(instances_matching(Pickup, "my_feather_storage", null)){
                    my_feather_storage = noone;
                    if(mask_index == mskPickup){
	                    my_feather_storage = obj_create(x, y, "ParrotChester");
	
	                     // Vars:
	                    with(my_feather_storage){
	                        creator = other;
	                        small = true;
	                        num = ceil(2 * skill_get(mut_throne_butt));
	                    }
                    }
                }
            }
        }

        wait 1;
    }

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav


/// General
#define race_name
	return "PARROT";

#define race_text
	return "MANY FRIENDS#@rFEATHERS";

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
        case sprMutant1Idle:        return spr.Parrot[b].Idle;
        case sprMutant1Walk:        return spr.Parrot[b].Walk;
        case sprMutant1Hurt:        return spr.Parrot[b].Hurt;
        case sprMutant1Dead:        return spr.Parrot[b].Dead;
        case sprMutant1GoSit:       return spr.Parrot[b].GoSit;
        case sprMutant1Sit:         return spr.Parrot[b].Sit;
        case sprFishMenu:           return spr.Parrot[b].Idle;
        case sprFishMenuSelected:   return spr.Parrot[b].MenuSelected;
        case sprFishMenuSelect:     return spr.Parrot[b].Idle;
        case sprFishMenuDeselect:   return spr.Parrot[b].Idle;
        case sprChickenFeather:     return spr.Parrot[b].Feather;
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


/// Lock Status
#define race_avail
    return unlock_get("parrot");

#define race_lock
    return "REACH @1(sprInterfaceIcons)1-1";


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
    sprite_index = spr.Parrot[0].Select;
    image_index = !race_avail();

#define race_portrait(p, _skin)
	return spr.Parrot[_skin].Portrait;

#define race_mapicon(p, _skin)
    return spr.Parrot[_skin].Map;


/// Skins
#define race_skins
	var _playersActive = 0;
	for(var i = 0; i < maxp; i++) _playersActive += player_is_active(i);
	if(_playersActive <= 1){
    	return 2;
	}
	else{ // Fix co-op bugginess
		var n = 1;
		while(unlock_get("parrot" + chr(65 + n))) n++;
		return n;
	}

#define race_skin_avail(_skin)
	var _playersActive = 0;
	for(var i = 0; i < maxp; i++) _playersActive += player_is_active(i);
	if(_playersActive <= 1){
		if(_skin == 0) return true;
    	return unlock_get("parrot" + chr(65 + real(_skin)));
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
    sprite_index = spr.Parrot[_skin].Loadout;
    image_index = !race_skin_avail(_skin);


/// Throne Butt
#define race_tb_text
	return "@wPICKUPS @sGIVE @rFEATHERS@s";


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
	sprite_index = spr.Parrot[0].UltraIcon;
	image_index = _ultra - 1; // why are ultras 1-based bro

#define race_ultra_icon(_ultra)
	return lq_get(spr.Parrot[0], "UltraHUD" + chr(64 + _ultra));

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
	 // Random lets you play locked characters:
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

     // Pets:
    if("ntte_pet" not in self) ntte_pet = [noone];
    while(array_length(ntte_pet) < 2) array_push(ntte_pet, noone);
    
     // Perching Parrot:
    parrot_bob = [0, 1, 1, 0];
    if(bskin) for(var i = 0; i < array_length(parrot_bob); i++){
    	parrot_bob[i] += 3;
    }
    
     // Re-Get Ultras When Revived:
    for(var i = 0; i < ultra_count(mod_current); i++){
    	if(ultra_get(mod_current, i)){
    		race_ultra_take(i, true);
    	}
    }

#define game_start
    with(instances_matching(Player, "race", mod_current)){
    	if(fork()){
		    wait 0;
	
		     // Starter Pet + Extra Pet Slot:
		    if(instance_exists(self)){
		        with(Pet_spawn(x, y, "Parrot")){
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
     /// ACTIVE : Charm
    if(button_check(index, "spec") || usespec > 0){
        var _feathers = instances_matching(instances_matching(CustomObject, "name", "ParrotFeather"), "index", index),
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
	                            scrCharm(id, false);
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
                var _targ = [],
                    _targX = mouse_x[index],
                    _targY = mouse_y[index],
                	_targRadius = feather_targ_radius,
                    _featherMax = array_length(_feathersTargeting);

				 // Gather All Potential Targets:
                with(instances_matching_lt(instance_rectangle_bbox(_targX - _targRadius, _targY - _targRadius, _targX + _targRadius, _targY + _targRadius, [enemy, RadMaggotChest, FrogEgg]), "size", 6)){
                    if(collision_circle(_targX, _targY, _targRadius, id, true, false)){
                        array_push(_targ, id);
                        if(array_length(_targ) >= _featherMax) break;
                    }
                }

				 // Spread Feathers Out Evenly:
                if(array_length(_targ) > 0){
                    var _featherNum = 0,
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
#define orandom(n)																		return  random_range(-n, n);
#define chance(_numer, _denom)															return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)														return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define surflist_set(_name, _x, _y, _width, _height)									return	mod_script_call_nc("mod", "teassets", "surflist_set", _name, _x, _y, _width, _height);
#define surflist_get(_name)																return	mod_script_call_nc("mod", "teassets", "surflist_get", _name);
#define draw_self_enemy()                                                                       mod_script_call(   "mod", "telib", "draw_self_enemy");
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call(   "mod", "telib", "draw_weapon", _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call(   "mod", "telib", "draw_lasersight", _x, _y, _dir, _maxDistance, _width);
#define scrWalk(_walk, _dir)                                                                    mod_script_call(   "mod", "telib", "scrWalk", _walk, _dir);
#define scrRight(_dir)                                                                          mod_script_call(   "mod", "telib", "scrRight", _dir);
#define scrEnemyShoot(_object, _dir, _spd)                                              return  mod_script_call(   "mod", "telib", "scrEnemyShoot", _object, _dir, _spd);
#define scrEnemyShootExt(_x, _y, _object, _dir, _spd)                                   return  mod_script_call(   "mod", "telib", "scrEnemyShootExt", _x, _y, _object, _dir, _spd);
#define enemyWalk(_spd, _max)                                                                   mod_script_call(   "mod", "telib", "enemyWalk", _spd, _max);
#define enemySprites()                                                                          mod_script_call(   "mod", "telib", "enemySprites");
#define enemyHurt(_hitdmg, _hitvel, _hitdir)                                                    mod_script_call(   "mod", "telib", "enemyHurt", _hitdmg, _hitvel, _hitdir);
#define scrDefaultDrop()                                                                        mod_script_call(   "mod", "telib", "scrDefaultDrop");
#define in_distance(_inst, _dis)			                                            return  mod_script_call(   "mod", "telib", "in_distance", _inst, _dis);
#define in_sight(_inst)																	return  mod_script_call(   "mod", "telib", "in_sight", _inst);
#define z_engine()                                                                              mod_script_call(   "mod", "telib", "z_engine");
#define scrPickupIndicator(_text)                                                       return  mod_script_call(   "mod", "telib", "scrPickupIndicator", _text);
#define scrCharm(_instance, _charm)                                                     return  mod_script_call_nc("mod", "telib", "scrCharm", _instance, _charm);
#define scrBossHP(_hp)                                                                  return  mod_script_call(   "mod", "telib", "scrBossHP", _hp);
#define scrBossIntro(_name, _sound, _music)                                                     mod_script_call(   "mod", "telib", "scrBossIntro", _name, _sound, _music);
#define scrTopDecal(_x, _y, _area)                                                      return  mod_script_call(   "mod", "telib", "scrTopDecal", _x, _y, _area);
#define scrWaterStreak(_x, _y, _dir, _spd)                                              return  mod_script_call(   "mod", "telib", "scrWaterStreak", _x, _y, _dir, _spd);
#define scrCorpse(_dir, _spd)                                                           return  mod_script_call(   "mod", "telib", "scrCorpse", _dir, _spd);
#define scrSwap()                                                                       return  mod_script_call(   "mod", "telib", "scrSwap");
#define scrSetPet(_pet)                                                                 return  mod_script_call(   "mod", "telib", "scrSetPet", _pet);
#define scrPortalPoof()                                                                 return  mod_script_call(   "mod", "telib", "scrPortalPoof");
#define scrPickupPortalize()                                                            return  mod_script_call(   "mod", "telib", "scrPickupPortalize");
#define floor_ext(_num, _round)                                                         return  mod_script_call(   "mod", "telib", "floor_ext", _num, _round);
#define array_count(_array, _value)                                                     return  mod_script_call(   "mod", "telib", "array_count", _array, _value);
#define array_flip(_array)                                                              return  mod_script_call(   "mod", "telib", "array_flip", _array);
#define nearest_instance(_x, _y, _instances)                                            return  mod_script_call(   "mod", "telib", "nearest_instance", _x, _y, _instances);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc("mod", "telib", "instance_rectangle", _x1, _y1, _x2, _y2, _obj);
#define instances_seen(_obj, _ext)                                                      return  mod_script_call_nc("mod", "telib", "instances_seen", _obj, _ext);
#define instance_random(_obj)                                                           return  mod_script_call(   "mod", "telib", "instance_random", _obj);
#define frame_active(_interval)                                                         return  mod_script_call(   "mod", "telib", "frame_active", _interval);
#define area_generate(_x, _y, _area)                                                    return  mod_script_call(   "mod", "telib", "area_generate", _x, _y, _area);
#define scrFloorWalls()                                                                 return  mod_script_call(   "mod", "telib", "scrFloorWalls");
#define floor_reveal(_floors, _maxTime)                                                 return  mod_script_call(   "mod", "telib", "floor_reveal", _floors, _maxTime);
#define area_border(_y, _area, _color)                                                  return  mod_script_call(   "mod", "telib", "area_border", _y, _area, _color);
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call(   "mod", "telib", "area_get_sprite", _area, _spr);
#define floor_at(_x, _y)                                                                return  mod_script_call(   "mod", "telib", "floor_at", _x, _y);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   "mod", "telib", "lightning_connect", _x1, _y1, _x2, _y2, _arc, _enemy);
#define scrLightning(_x1, _y1, _x2, _y2, _enemy)                                        return  mod_script_call(   "mod", "telib", "scrLightning", _x1, _y1, _x2, _y2, _enemy);
#define in_range(_num, _lower, _upper)                                                  return  mod_script_call(   "mod", "telib", "in_range", _num, _lower, _upper);
#define wep_get(_wep)                                                                   return  mod_script_call(   "mod", "telib", "wep_get", _wep);
#define decide_wep_gold(_minhard, _maxhard, _nowep)                                     return  mod_script_call(   "mod", "telib", "decide_wep_gold", _minhard, _maxhard, _nowep);
#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)                        return  mod_script_call_nc("mod", "telib", "path_create", _xstart, _ystart, _xtarget, _ytarget, _wall);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call(   "mod", "telib", "race_get_sprite", _race, _sprite);
#define scrFloorMake(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "scrFloorMake", _x, _y, _obj);
#define scrFloorFill(_x, _y, _w, _h)                                                    return  mod_script_call(   "mod", "telib", "scrFloorFill", _x, _y, _w, _h);
#define scrFloorFillRound(_x, _y, _w, _h)                                               return  mod_script_call(   "mod", "telib", "scrFloorFillRound", _x, _y, _w, _h);
#define unlock_get(_name)                                                               return  mod_script_call_nc("mod", "telib", "unlock_get", _name);
#define unlock_set(_name, _value)                                                               mod_script_call_nc("mod", "telib", "unlock_set", _name, _value);
#define scrUnlock(_name, _text, _sprite, _sound)                                        return  mod_script_call(   "mod", "telib", "scrUnlock", _name, _text, _sprite, _sound);
#define area_get_subarea(_area)                                                         return  mod_script_call(   "mod", "telib", "area_get_subarea", _area);
#define trace_lag()                                                                             mod_script_call(   "mod", "telib", "trace_lag");
#define trace_lag_bgn(_name)                                                                    mod_script_call(   "mod", "telib", "trace_lag_bgn", _name);
#define trace_lag_end(_name)                                                                    mod_script_call(   "mod", "telib", "trace_lag_end", _name);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call_nc("mod", "telib", "instance_rectangle_bbox", _x1, _y1, _x2, _y2, _obj);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   "mod", "telib", "instances_meeting", _x, _y, _obj);
#define array_delete(_array, _index)                                                    return  mod_script_call_nc("mod", "telib", "array_delete", _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call_nc("mod", "telib", "array_delete_value", _array, _value);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "instances_at", _x, _y, _obj);
#define Pet_spawn(_x, _y, _name)                                                        return  mod_script_call(   "mod", "telib", "Pet_spawn", _x, _y, _name);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc("mod", "telib", "scrFX", _x, _y, _motion, _obj);
#define array_combine(_array1, _array2)                                                 return  mod_script_call_nc("mod", "telib", "array_combine", _array1, _array2);
#define player_create(_x, _y, _index)                                                   return  mod_script_call(   "mod", "telib", "player_create", _x, _y, _index);
#define trace_error(_error)                                                                     mod_script_call_nc("mod", "telib", "trace_error", _error);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc("mod", "telib", "sleep_max", _milliseconds);
#define array_clone_deep(_array)                                                        return  mod_script_call_nc("mod", "telib", "array_clone_deep", _array);
#define lq_clone_deep(_obj)                                                             return  mod_script_call_nc("mod", "telib", "lq_clone_deep", _obj);
#define array_exists(_array, _value)                                                    return  mod_script_call_nc("mod", "telib", "array_exists", _array, _value);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc("mod", "telib", "wep_merge", _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call(   "mod", "telib", "wep_merge_decide", _hardMin, _hardMax);
#define array_shuffle(_array)                                                           return  mod_script_call_nc("mod", "telib", "array_shuffle", _array);
#define view_shift(_index, _dir, _pan)                                                          mod_script_call_nc("mod", "telib", "view_shift", _index, _dir, _pan);
#define stat_get(_name)                                                                 return  mod_script_call_nc("mod", "telib", "stat_get", _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc("mod", "telib", "stat_set", _name, _value);
#define option_get(_name, _default)                                                     return  mod_script_call_nc("mod", "telib", "option_get", _name, _default);
#define option_set(_name, _value)                                                               mod_script_call_nc("mod", "telib", "option_set", _name, _value);
#define sound_play_hit_ext(_snd, _pit, _vol)                                            return  mod_script_call(   "mod", "telib", "sound_play_hit_ext", _snd, _pit, _vol);
#define area_get_secret(_area)                                                          return  mod_script_call_nc("mod", "telib", "area_get_secret", _area);
#define area_get_underwater(_area)                                                      return  mod_script_call_nc("mod", "telib", "area_get_underwater", _area);
#define path_shrink(_path, _wall, _skipMax)                                             return  mod_script_call_nc("mod", "telib", "path_shrink", _path, _wall, _skipMax);
#define path_direction(_x, _y, _path, _wall)                                            return  mod_script_call_nc("mod", "telib", "path_direction", _x, _y, _path, _wall);
#define rad_drop(_x, _y, _raddrop, _dir, _spd)                                          return  mod_script_call_nc("mod", "telib", "rad_drop", _x, _y, _raddrop, _dir, _spd);
#define rad_path(_inst, _target)                                                        return  mod_script_call_nc("mod", "telib", "rad_path", _inst, _target);
#define area_get_name(_area, _subarea, _loop)                                           return  mod_script_call_nc("mod", "telib", "area_get_name", _area, _subarea, _loop);
#define draw_text_bn(_x, _y, _string, _angle)                                                   mod_script_call_nc("mod", "telib", "draw_text_bn", _x, _y, _string, _angle);