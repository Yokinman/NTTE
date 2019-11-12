#define init
	with(Loadout){
		instance_destroy();
		with(loadbutton) instance_destroy();
	}

    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.sav = mod_variable_get("mod", "teassets", "sav");

	global.debug_lag = false;

     // Charm:
    global.surfCharm = surflist_set("Charm", 0, 0, game_width, game_height);
    global.shadCharm = shadlist_set("Charm", 
		/* Vertex Shader */"
		struct VertexShaderInput
		{
			float4 vPosition : POSITION;
			float2 vTexcoord : TEXCOORD0;
		};

		struct VertexShaderOutput
		{
			float4 vPosition : SV_POSITION;
			float2 vTexcoord : TEXCOORD0;
		};

		uniform float4x4 matrix_world_view_projection;

		VertexShaderOutput main(VertexShaderInput INPUT)
		{
			VertexShaderOutput OUT;

			OUT.vPosition = mul(matrix_world_view_projection, INPUT.vPosition); // (x,y,z,w)
			OUT.vTexcoord = INPUT.vTexcoord; // (x,y)

			return OUT;
		}
		",

		/* Fragment/Pixel Shader */"
		struct PixelShaderInput
		{
			float2 vTexcoord : TEXCOORD0;
		};

		sampler2D s0;

		float4 main(PixelShaderInput INPUT) : SV_TARGET
		{
			 // Break Down Pixel's Color:
			float4 Color = tex2D(s0, INPUT.vTexcoord); // (r,g,b,a)
			float R = round(Color.r * 255.0);
			float G = round(Color.g * 255.0);
			float B = round(Color.b * 255.0);

			if(R > G && R > B){
				if(
					(R == 252.0 && G ==  56.0 && B ==  0.0) || // Standard enemy eye color
					(R == 199.0 && G ==   0.0 && B ==  0.0) || // Freak eye color
					(R ==  95.0 && G ==   0.0 && B ==  0.0) || // Freak eye color
					(R == 163.0 && G ==   5.0 && B ==  5.0) || // Buff gator ammo
					(R == 105.0 && G ==   3.0 && B ==  3.0) || // Buff gator ammo
					(R == 255.0 && G == 164.0 && B == 15.0) || // Saladmander fire color
					(R == 255.0 && G ==   0.0 && B ==  0.0) || // Wolf eye color
					(R == 165.0 && G ==   9.0 && B == 43.0) || // Snowbot eye color
					(R == 255.0 && G == 168.0 && B == 61.0) || // Snowbot eye color
					(R == 194.0 && G ==  42.0 && B ==  0.0) || // Explo freak color
					(R == 122.0 && G ==  27.0 && B ==  0.0) || // Explo freak color
					(R == 156.0 && G ==  20.0 && B == 31.0) || // Turret eye color
					(R == 255.0 && G == 134.0 && B == 47.0) || // Turret eye color
					(R ==  99.0 && G ==   9.0 && B == 17.0) || // Turret color
					(R == 112.0 && G ==   0.0 && B == 17.0) || // Necromancer eye color
					(R == 210.0 && G ==  32.0 && B == 71.0) || // Jungle fly eye color
					(R == 179.0 && G ==  27.0 && B == 60.0) || // Jungle fly eye color
					(R == 255.0 && G == 160.0 && B == 35.0) || // Jungle fly eye/wing color
					(R == 255.0 && G == 228.0 && B == 71.0)    // Jungle fly wing color
				){
					return float4(G / 255.0, R / 255.0, B / 255.0, Color.a);
				}
			}

			 // Return Blank Pixel:
			return float4(0.0, 0.0, 0.0, 0.0);
		}
		"
	);
    global.charm = ds_list_create();

	 // Global Step:
    while(true){
    	script_bind_end_step(charm_step, 0);
    	
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

        wait 0;
    }

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

#macro surfCharm global.surfCharm
#macro shadCharm global.shadCharm

#macro current_frame_active ((current_frame mod 1) < current_time_scale)

/// General
#define race_name
	return "PARROT";

#define race_text
	return "MANY FRIENDS#@rCHARM ENEMIES";

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
	 // Random lets you play locked characters: (Remove once 9941+ gets stable build)
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

     // Extra Pet Slot:
    ntte_pet_max = mod_variable_get("mod", "ntte", "pet_max") + 1;
    
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
		    while(instance_exists(self) && "ntte_pet" not in self) wait 0;
		    
		     // Parrot Pet:
		    if(instance_exists(self) && array_length(ntte_pet) > 0){
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
	if(DebugLag) trace_time();
	
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

#define charm_step
	if(DebugLag) trace_time();
	
    var _charmList = ds_list_to_array(global.charm),
        _charmDraw = array_create(maxp + 1),
        _charmObject = [hitme, MaggotExplosion, RadMaggotExplosion, ReviveArea, NecroReviveArea, RevivePopoFreak];
        
	for(var i = 0; i < array_length(_charmDraw); i++){
		_charmDraw[i] = {
			inst  : [],
			depth : 9999
		};
	}
	
    with(_charmList){
        var _self = instance,
            _time = time,
            _index = index,
            _target = target,
            _targetCrash = (!instance_exists(Player) && instance_is(_self, Grunt)); // References player-specific vars in its alarm event, causing a crash
            
        if(!instance_exists(_self)) scrCharm(_self, false);
        else{
            with(_self){
				var _minID = GameObject.id;
				
				 // Increased Aggro:
				var _aggroFactor = 10;
				if((current_frame % (_aggroFactor / alarm1)) < current_time_scale){
					var _aggroSpeed = ceil(alarm1 / _aggroFactor);
					if(alarm1 - _aggroSpeed > 0 && instance_is(self, enemy)){
						 // Not Boss:
						if(!other.boss){
							 // Not Attacking:
							if(
								alarm2 < 0							&&
								("ammo" not in self || ammo <= 0)	&&
								(sprite_index == spr_idle || sprite_index == spr_walk || sprite_index == spr_hurt)
							){
								 // Not Shielding:
								if(array_length(instances_matching(PopoShield, "creator", self)) <= 0){
									alarm1 -= _aggroSpeed;
								}
							}
						}
					}
				}
				
				 // Targeting:
				if(
					!instance_exists(_target)										||
					("team" in self && "team" in _target && team == _target.team)	||
					collision_line(x, y, _target.x, _target.y, Wall, false, false)
				){
					var	_disMax = 1000000,
						_search = instances_matching_ne(enemy, "mask_index", mskNone, sprVoid);
						
					if("team" in self){
						_search = instances_matching_ne(_search, "team", team);
					}
					
					with(_search){
						var _dis = point_distance(x, y, other.x, other.y);
						if(_dis < _disMax){
							_disMax = _dis;
							_target = id;
						}
					}
					
        			other.target = _target;
				}
				
				 // Move Players to Target (the key to this system):
				var _lastPos = [];
				if("target" in self){
					if(!_targetCrash){
						target = _target;
					}
					
					with(Player){
						array_push(_lastPos, [id, x, y]);
						if(instance_exists(other.target)){
							x = other.target.x;
							y = other.target.y;
						}
						else{
							var l = 10000,
								d = random(360);
								
							x += lengthdir_x(l, d);
							y += lengthdir_y(l, d);
						}
					}
				}
				
				 // Call Main Code:
				try{
					 // Custom Objects (Override Step Event):
					var _step = other.on_step;
					if(array_length(_step) > 0){
						if(array_length(on_step) > 0){
							_step = on_step;
							other.on_step = _step;
							on_step = [];
						}
						if(array_length(_step) >= 2){
							mod_script_call(_step[0], _step[1], _step[2]);
						}
					}
					
					 // Normal (Override Alarms):
					else for(var _alarmNum = 0; _alarmNum <= 10; _alarmNum++){
						var a = alarm_get(_alarmNum);
						if(a > 0 && a <= ceil(current_time_scale)){
							alarm_set(_alarmNum, -1);
							
							 // Call Alarm Event:
							event_perform(ev_alarm, _alarmNum);
							if(!instance_exists(self)) break;
							
							 // 1 Frame Extra:
							var a = alarm_get(_alarmNum);
							if(a > 0) alarm_set(_alarmNum, a + ceil(current_time_scale));
						}
					}
				}
				catch(_error){
					trace_error(_error);
				}
				
				 // Return Moved Players:
				with(_lastPos){
					with(self[0]){
						x = other[1];
						y = other[2];
					}
				}
				
				 // Newly Spawned Things:
				if(GameObject.id > _minID){
					 // Set Creator:
					with(instances_matching(instances_matching_gt(_charmObject, "id", _minID), "creator", null, noone)){
						creator = other;
					}
					
					 // Ally-ify Projectiles:
					with(instances_matching(instances_matching_gt(projectile, "id", _minID), "creator", self, noone)){
						mod_script_call("mod", "telib", "charm_allyize", true);
					}
				}
				
				 // Enemy Stuff:
                if(instance_is(self, enemy)){
                     // Contact Damage:
                    if(place_meeting(x, y, enemy)){
                        with(instances_meeting(x, y, instances_matching_ne(instances_matching_ne(enemy, "team", team), "creator", _self))){
                            if(place_meeting(x, y, other)) with(other){
                            	 // Disable Freeze Frames:
                            	var f = UberCont.opt_freeze;
                            	UberCont.opt_freeze = 0;
                            	
								 // Gamma Guts Fix (It breaks contact damage idk):
								var _gamma = skill_get(mut_gamma_guts);
								skill_set(mut_gamma_guts, false);
								
                            	 // Speed Up 'canmelee' Reset:
                                if(alarm11 > 0 && alarm11 < 26){
                                	event_perform(ev_alarm, 11);
                                }
                                
								 // Collision:
                                event_perform(ev_collision, Player);
                                
                                 // No I-Frames:
                                with(other) nexthurt = current_frame;
                                
                                 // Set Stuff Back:
                            	UberCont.opt_freeze = f;
                            	skill_set(mut_gamma_guts, _gamma);
                            }
                        }
                    }
                    
                     // Player Shooting:
                    /* actually pretty annoying dont use this
                    if(place_meeting(x, y, projectile)){
                        with(instances_matching(projectile, "team", team)){
                            if(place_meeting(x, y, other)){
                                if(instance_exists(creator) && creator.object_index == Player){
                                    with(other) scrCharm(id, false);
                                    event_perform(ev_collision, enemy);
                                }
                            }
                        }
                    }
                    */
                    
                     // Follow Leader:
                    if(instance_exists(Player)){
						if(meleedamage <= 0 || "gunangle" in self || ("walk" in self && walk > 0)){
							if("ammo" not in self || ammo <= 0){
								if(distance_to_object(Player) > 256 || !instance_exists(_target) || !in_sight(_target) || !in_distance(_target, 80)){
									 // Player to Follow:
									var n = instance_nearest(x, y, Player);
									if(instance_exists(player_find(_index))){
										n = nearest_instance(x, y, instances_matching(Player, "index", _index));
									}
									
									 // Stay in Range:
									if(distance_to_object(n) > 32){
										motion_add_ct(point_direction(x, y, n.x, n.y), 1);
									}
								}
							}
						}
                    }
                    
                     // Add to Charm Drawing:
                    if(visible){
						var _draw = _charmDraw[player_is_active(_index) ? (_index + 1) : 0];
						with(_draw){
							array_push(inst, other);
							if(other.depth < depth) depth = other.depth;
						}
					}
                }
                
				if(!instance_exists(self)) break;
				
                 // Manual Exception Stuff:
                switch(object_index){
                    case BigMaggot:
                    	if(alarm1 < 0) alarm1 = irandom_range(10, 20); // JW u did this to me
                    case MaggotSpawn:
                    case RadMaggotChest:
                    case FiredMaggot:
                    case RatkingRage:
                    case InvSpider:			/// Charm Spawned Bros
						if(
							my_health <= 0
							||
							(object_index == FiredMaggot && place_meeting(x + hspeed_raw, y + vspeed_raw, Wall))
							||
							(object_index == RatkingRage && walk > 0 && walk <= current_time_scale)
						){
							var _minID = instance_create(0, 0, GameObject);
							instance_delete(_minID);
							instance_destroy();
							with(instances_matching_gt(_charmObject, "id", _minID)){
								creator = other;
							}
						}
						break;
                        
                    case MeleeBandit:
                    case JungleAssassin:    /// Overwrite Movement
                        if(walk > 0){
                            other.walk = walk;
                            walk = 0;
                        }
                        if(other.walk > 0){
                            other.walk -= current_time_scale;
                            
                            motion_add_ct(direction, 2);
                            if(instance_exists(_target)){
                                var s = ((object_index == JungleAssassin) ? 1 : 2) * current_time_scale;
                                mp_potential_step(_target.x, _target.y, s, false);
                            }
                        }
                        
                         // Max Speed:
                        var m = ((object_index == JungleAssassin) ? 4 : 3);
                        if(speed > m) speed = m;
                        break;
                        
                    case Sniper:            /// Aim at Target
                        if(alarm2 > 5){
                            gunangle = point_direction(x, y, _target.x, _target.y);
                        }
                        break;
                        
                    case ScrapBoss:         /// Override Movement
                        if(walk > 0){
                            other.walk = walk;
                            walk = 0;
                        }
                        if(other.walk > 0){
                            other.walk -= current_time_scale;
                            
                            motion_add(direction, 0.5);
                            if(instance_exists(_target)){
                                motion_add(point_direction(x, y, _target.x, _target.y), 0.5);
                            }
                            
                            if(round(other.walk / 10) == other.walk / 10) sound_play(sndBigDogWalk);
                            
                             // Animate:
                            if(other.walk <= 0) sprite_index = spr_idle;
                            else sprite_index = spr_walk;
                        }
                        break;

                    case ScrapBossMissile:  /// Don't Move Towards Player
                        if(sprite_index != spr_hurt){
                            if(instance_exists(Player)){
                                var n = instance_nearest(x, y, Player);
                                motion_add(point_direction(n.x, n.y, x, y), 0.1);
                            }
                            if(instance_exists(_target)){
                                motion_add(point_direction(x, y, _target.x, _target.y), 0.1);
                            }
                            speed = 2;
                            x = xprevious + hspeed;
                            y = yprevious + vspeed;
                        }
                        break;
                        
                    case LightningCrystal:  /// Ally-ify Lightning
						with(instances_matching(EnemyLightning, "charmally_check", null)){
							charmally_check = true;
							if(sprite_index == sprEnemyLightning){
								if(team == other.team){
									if(!instance_exists(creator) || creator == other){
										if(distance_to_object(other) < 56){
											sprite_index = sprLightning;
										}
									}
								}
							}
                        }
                        break;
                        
                    case LilHunterFly:      /// Land on Enemies
                        if(sprite_index == sprLilHunterLand && z < -160){
                            if(instance_exists(_target)){
                                x = _target.x;
                                y = _target.y;
                            }
                        }
                        break;
                        
                    case ExploFreak:
                    case RhinoFreak:        /// Don't Move Towards Player
                        if(instance_exists(Player)){
                            x -= lengthdir_x(current_time_scale, direction);
                            y -= lengthdir_y(current_time_scale, direction);
                        }
                        if(instance_exists(_target)){
                            mp_potential_step(_target.x, _target.y, current_time_scale, false);
                        }
                        break;
                        
                    case Shielder:
                    case EliteShielder:     /// Fix Shield Team
                        with(instances_matching(PopoShield, "creator", id)) team = other.team;
                        break;
                        
					case Inspector:
					case EliteInspector:	/// Fix Telekinesis Pull
						if("charm_control_last" in self && charm_control_last){
							var _pull = (1 + (object_index == EliteInspector)) * current_time_scale;
							with(instances_matching(Player, "team", team)){
								if(point_distance(x, y, xprevious, yprevious) <= speed_raw + _pull + 1){
									if(point_distance(other.xprevious, other.yprevious, xprevious, yprevious) < 160){
										if(!place_meeting(xprevious + hspeed_raw, yprevious + vspeed_raw, Wall)){
											x = xprevious + hspeed_raw;
											y = yprevious + vspeed_raw;
										}
									}
								}
							}
						}
						charm_control_last = control;
						break;
						
                    case EnemyHorror:       /// Don't Shoot Beam at Player
                        if(instance_exists(_target)){
                            gunangle = point_direction(x, y, _target.x, _target.y);
                        }
                        with(instances_matching(instances_matching(projectile, "creator", _self), "charmed_horror", null)){
                            charmed_horror = place_meeting(x, y, other);
                            if(charmed_horror){
	                            x -= hspeed_raw;
	                            y -= vspeed_raw;
	                            direction = other.gunangle;
	                            image_angle = direction;
	                            x += hspeed_raw;
	                            y += vspeed_raw;
                            }
                        }
                        break;
                }
                
				if(!instance_exists(self)) break;
				
				// <3
				if(random(200) < current_time_scale){
					with(instance_create(x + orandom(8), y - random(8), AllyDamage)){
						sprite_index = sprHealFX;
						motion_add(other.direction, 1);
						speed /= 2;
						image_xscale *= random_range(2/3, 1);
						image_yscale = image_xscale;
					}
				}
                
				 // Level Over:
				if(other.kill && array_length(instances_matching_ne(instances_matching_ne(enemy, "team", team), "object_index", Van)) <= 0){
					scrCharm(_self, false);
				}
				
				if(_targetCrash) target = noone;
			}
            
             // Charm Timer:
            if((instance_is(_self, hitme) || instance_is(_self, becomenemy)) && time > 0){
                time -= time_speed * current_time_scale;
                if(time <= 0) scrCharm(_self, false);
            }
        }
        
         // Charm Spawned Enemies:
        with(instances_matching(instances_matching(_charmObject, "creator", _self), "ntte_charm", null)){
        	if(place_meeting(x, y, _self) || !instance_exists(_self)){
	            var c = scrCharm(id, true);
	            c.index = _index;
	            
				if(instance_is(self, hitme)){
					 // Kill When Uncharmed if Infinitely Spawned:
					if("kills" in self && kills <= 0 && !other.boss){
						c.kill = true;
						if("raddrop" in self) raddrop = 0;
					}
					
					 // Featherize:
					repeat(max(_time / 90, 1)) with(obj_create(x + orandom(24), y + orandom(24), "ParrotFeather")){
						target = other;
						index = _index;
						with(player_find(index)) if("spr_feather" in self){
							other.sprite_index = spr_feather;
						}
					}
	            }
	            else c.time = _time;
        	}
        }
    }

	with(surfCharm) active = false;
	for(var i = 0; i < array_length(_charmDraw); i++){
		var _draw = _charmDraw[i];
		if(array_length(_draw.inst) > 0){
			with(surfCharm) active = true;
	        script_bind_draw(charm_draw, _draw.depth - 0.1, _draw.inst, i - 1);
		}
	}

	if(DebugLag) trace_time("charm_step " + string(array_length(_charmList)));

	instance_destroy();

#define charm_draw(_inst, _index)
	if(_index < 0 || _index >= maxp){
		_index = player_find_local_nonsync();
	}

	with(surfCharm){
		x = view_xview_nonsync;
		y = view_yview_nonsync;
		w = game_width;
		h = game_height;

		if(surface_exists(surf)){
			var _cts = current_time_scale;
			current_time_scale = 0.00001;

			var	_surfx = x,
				_surfy = y;

			surface_set_target(surf);
			draw_clear_alpha(0, 0);

			try{
				with(other) with(instances_seen_nonsync(instances_matching_ne(_inst, "sprite_index", sprSuperFireBallerFire, sprFireBallerFire), 24, 24)){
					/*var _x = x - _surfx,
						_y = y - _surfy,
						_spr = sprite_index,
						_img = image_index;

					if(object_index == TechnoMancer){ // JW help me
						_spr = drawspr;
						_img = drawimg;
						if(_spr == sprTechnoMancerAppear || _spr == sprTechnoMancerFire1 || _spr == sprTechnoMancerFire2 || _spr == sprTechnoMancerDisappear){
							texture_set_stage(0, sprite_get_texture(sprTechnoMancerActivate, 8));
							draw_sprite_ext(sprTechnoMancerActivate, 8, _x, _y, image_xscale * (("right" in self) ? right : 1), image_yscale, image_angle, image_blend, image_alpha);
						}
					}

					draw_sprite_ext(_spr, _img, _x, _y, image_xscale * (("right" in self) ? right : 1), image_yscale, image_angle, image_blend, image_alpha);*/

					var _x = x,
						_y = y;

					x -= _surfx;
					y -= _surfy;

					switch(object_index){
						case SnowTank:
						case GoldSnowTank: // disable laser sights
							var a = ammo;
							ammo = 0;
					        event_perform(ev_draw, 0);
							ammo = a;
							break;

						default:
							var g = false;
							if("gonnafire" in self){ // Disable laser sights
								g = gonnafire;
								gonnafire = false;
							}

							event_perform(ev_draw, 0);

							if(g != false) gonnafire = g;
					}

					x = _x;
					y = _y;
				}
		    }
			catch(_error){
				trace_error(_error);
			}

			surface_reset_target();
			current_time_scale = _cts;

			 // Outlines:
			var _option = option_get("outlineCharm", 2);
			if(_option > 0){
				if(_option < 2 || player_get_outlines(player_find_local_nonsync())){
					draw_set_fog(true, player_get_color(_index), 0, 0);
					for(var a = 0; a <= 360; a += 90){
						var _x = _surfx,
						    _y = _surfy;

						if(a >= 360) draw_set_fog(false, 0, 0, 0);
						else{
						    _x += dcos(a);
						    _y -= dsin(a);
						}

						draw_surface(surf, _x, _y);
					}
				}
			}

			 // Eye Shader:
			with(shadCharm) if(shad != -1){
				shader_set_vertex_constant_f(0, matrix_multiply(matrix_multiply(matrix_get(matrix_world), matrix_get(matrix_view)), matrix_get(matrix_projection)));
				shader_set(shad);
				texture_set_stage(0, surface_get_texture(other.surf));

				draw_surface(other.surf, _surfx, _surfy);

				shader_reset();
			}
		}
	}

	instance_destroy();

#define cleanup
	with(Loadout){
		instance_destroy();
		with(loadbutton) instance_destroy();
	}

	 // Uncharm yo:
	with(ds_list_to_array(global.charm)) scrCharm(instance, false);


/// Scripts
#define orandom(n)																		return  random_range(-n, n);
#define chance(_numer, _denom)															return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)														return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define surflist_set(_name, _x, _y, _width, _height)									return	mod_script_call_nc("mod", "teassets", "surflist_set", _name, _x, _y, _width, _height);
#define surflist_get(_name)																return	mod_script_call_nc("mod", "teassets", "surflist_get", _name);
#define shadlist_set(_name, _vertex, _fragment)											return	mod_script_call_nc("mod", "teassets", "shadlist_set", _name, _vertex, _fragment);
#define shadlist_get(_name)																return	mod_script_call_nc("mod", "teassets", "shadlist_get", _name);
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
#define scrBossIntro(_name, _sound, _music)                                             return  mod_script_call(   "mod", "telib", "scrBossIntro", _name, _sound, _music);
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
#define instances_seen_nonsync(_obj, _bx, _by)                                          return  mod_script_call_nc("mod", "telib", "instances_seen_nonsync", _obj, _bx, _by);
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
#define top_create(_x, _y, _obj, _spawnDir, _spawnDis)                                  return  mod_script_call_nc("mod", "telib", "top_create", _x, _y, _obj, _spawnDir, _spawnDis);