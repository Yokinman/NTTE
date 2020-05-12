#define init
	with(Loadout){
		instance_destroy();
		with(loadbutton) instance_destroy();
	}
	
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	lag = false;
	
	 // Charm:
	shader_add("Charm",
		
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
		uniform float2 pixelSize;
		
		bool isEyeColor(in float3 RGB)
		{
			if(RGB.r > RGB.g + RGB.b){
				float R = round(RGB.r * 255.0);
				float G = round(RGB.g * 255.0);
				float B = round(RGB.b * 255.0);
				if(
					R == 252.0 && G ==  56.0 && B ==  0.0 || //  Standard enemy eye color
					R == 199.0 && G ==   0.0 && B ==  0.0 || //  Freak eye color
					R ==  95.0 && G ==   0.0 && B ==  0.0 || //  Freak eye color
					R == 163.0 && G ==   5.0 && B ==  5.0 || //  Buff gator ammo
					R == 105.0 && G ==   3.0 && B ==  3.0 || //  Buff gator ammo
					R == 255.0 && G ==   0.0 && B ==  0.0 || //  Wolf eye color
					R == 165.0 && G ==   9.0 && B == 43.0 || //  Snowbot eye color
					R == 194.0 && G ==  42.0 && B ==  0.0 || //  Explo freak color
					R == 122.0 && G ==  27.0 && B ==  0.0 || //  Explo freak color
					R == 156.0 && G ==  20.0 && B == 31.0 || //  Turret eye color
					R == 255.0 && G == 134.0 && B == 47.0 || //  Turret eye color
					R ==  99.0 && G ==   9.0 && B == 17.0 || //  Turret color
					R == 112.0 && G ==   0.0 && B == 17.0 || //  Necromancer eye color
					R == 210.0 && G ==  32.0 && B == 71.0 || //  Jungle fly eye color
					R == 179.0 && G ==  27.0 && B == 60.0    //  Jungle fly eye color
				){
					return true;
				}
			}
			return false;
		}
		
		float4 main(PixelShaderInput INPUT) : SV_TARGET
		{
			float4 RGBA = tex2D(s0, INPUT.vTexcoord);
			
			 // Red Eyes to Green:
			if(RGBA.r > RGBA.g + RGBA.b){
				if(
					isEyeColor(RGBA.rgb)
					|| isEyeColor(tex2D(s0, INPUT.vTexcoord - float2(pixelSize.x, 0.0)).rgb)
					|| isEyeColor(tex2D(s0, INPUT.vTexcoord + float2(pixelSize.x, 0.0)).rgb)
					|| isEyeColor(tex2D(s0, INPUT.vTexcoord - float2(0.0, pixelSize.y)).rgb)
					|| isEyeColor(tex2D(s0, INPUT.vTexcoord + float2(0.0, pixelSize.y)).rgb)
				){
					return RGBA.grba;
				}
			}
			
			 // Return Blank Pixel:
			return float4(0.0, 0.0, 0.0, 0.0);
		}
		"
		/*
			  R    G    B |   H    S    V |
			252,  56,   0 |  13, 100,  99 | Standard enemy eye color
			199,   0,   0 |   0, 100,  78 | Freak eye color
			 95,   0,   0 |   0, 100,  37 | Freak eye color
			163,   5,   5 |   0,  97,  64 | Buff gator ammo
			105,   3,   3 |   0,  97,  41 | Buff gator ammo
			255,   0,   0 |   0, 100, 100 | Wolf eye color
			165,   9,  43 | 347,  95,  65 | Snowbot eye color
			194,  42,   0 |  13, 100,  76 | Explo freak color
			122,  27,   0 |  13, 100,  48 | Explo freak color
			156,  20,  31 | 355,  87,  61 | Turret eye color
			 99,   9,  17 | 355,  91,  39 | Turret color
			112,   0,  17 | 351, 100,  44 | Necromancer eye color
			210,  32,  71 | 347,  85,  82 | Jungle fly eye color
			179,  27,  60 | 347,  85,  70 | Jungle fly eye color
			
			255, 164,  15 |  37,  94, 100 | Saladmander fire color
			255, 168,  61 |  33,  76  100 | Snowbot eye color
			255, 134,  47 |  25,  82, 100 | Turret eye color
			255, 160,  35 |  34,  86, 100 | Jungle fly eye/wing color
			///255, 228,  71 |  51,  72, 100 | Jungle fly wing color
		*/
	);
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

/// General
#define race_name            return "PARROT";
#define race_text            return "MANY FRIENDS#@rCHARM ENEMIES";
#define race_lock            return "REACH " + area_get_name("coast", 1, 0);
#define race_unlock          return "FOR REACHING COAST";
#define race_tb_text         return "@wPICKUPS @sGIVE @rFEATHERS@s";
#define race_portrait(p, b)  return race_sprite_raw("Portrait", b);
#define race_mapicon(p, b)   return race_sprite_raw("Map",      b);
#define race_avail           return unlock_get("race:" + mod_current);

#define race_ttip
	 // Ultra:
	if(GameCont.level >= 10 && chance(1, 5)){
		return choose("MIGRATION FORMATION", "CHARMED, I'M SURE", "ADVENTURING PARTY", "FREE AS A BIRD");
	}
	
	 // Normal:
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
		case sprRogueAmmoHUD:       return race_sprite_raw("FeatherHUD",   b);
	}
	
	return -1;
	
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
		while(unlock_get(`skin:${mod_current}:${n}`)){
			n++;
		}
		return n;
	}

#define race_skin_avail(_skin)
	var _playersActive = 0;
	for(var i = 0; i < maxp; i++) _playersActive += player_is_active(i);
	if(_playersActive <= 1){
		if(_skin == 0) return true;
		return unlock_get(`skin:${mod_current}:${_skin}`);
	}
	else{ // Fix co-op bugginess
		return true;
	}

#define race_skin_name(_skin)
	if(race_skin_avail(_skin)){
		return chr(65 + _skin) + " SKIN";
	}
	else{
		return race_skin_lock(_skin);
	}
	
#define race_skin_lock(_skin)
	switch(_skin){
		case 0: return "EDIT THE SAVE FILE LMAO";
		case 1: return "COMPLETE THE#AQUATIC ROUTE";
	}
	
#define race_skin_unlock(_skin)
	switch(_skin){
		case 1: return "FOR BEATING THE AQUATIC ROUTE";
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
	if(!race_avail()){
		race = "fish";
		player_set_race(index, race);
		exit;
	}
	
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
	if(bskin == 1){
		for(var i = 0; i < array_length(parrot_bob); i++){
			parrot_bob[i] += 3;
		}
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
					if(bskin == 1){
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
						bskin = other.bskin;
						index = other.index;
						creator = other;
						target = other;
						speed *= 3;
						sprite_index = race_get_sprite(other.race, sprite_index);
					}
				}
			}
			
			exit;
		}
	}
	
#define step
	if(lag) trace_time();
	
	 /// ACTIVE : Charm
	if(player_active && canspec){
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
						bskin = other.bskin;
						index = other.index;
						creator = other;
						target = other;
						sprite_index = race_get_sprite(other.race, sprite_index);
						array_push(_feathersTargeting, self);
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
	}
	
	 // Feather FX:
	if(lsthealth > my_health && (chance_ct(1, 10) || my_health <= 0)){
		repeat((my_health <= 0) ? 5 : 1) with(instance_create(x, y, Feather)){
			image_blend = c_gray;
			bskin = other.bskin;
			sprite_index = race_get_sprite(other.race, sprite_index);
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
	
	if(lag) trace_time(mod_current + "_step");
	
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
	if(lag) trace_time();
	
	var	_instList = array_clone(inst),
		_varsList = array_clone(vars),
		_charmDraw = array_create(maxp + 1),
		_charmObject = [hitme, MaggotExplosion, RadMaggotExplosion, ReviveArea, NecroReviveArea, RevivePopoFreak];
		
	for(var i = 0; i < array_length(_charmDraw); i++){
		_charmDraw[i] = {
			inst  : [],
			depth : 9999
		};
	}
	
	var _instNum = 0;
	with(_instList){
		var _vars = _varsList[_instNum++];
		
		if(_vars.charmed){
			if(!instance_exists(self)) _vars.charmed = false;
			else{
				if("ntte_charm_override" not in self || !ntte_charm_override){
					var	_minID = GameObject.id,
						_target = _vars.target,
						_targetCrash = (!instance_exists(Player) && instance_is(self, Grunt)), // References player-specific vars in its alarm event, causing a crash
						_aggroFactor = 10;
						
					 // Increased Aggro:
					if((current_frame % (_aggroFactor / alarm1)) < current_time_scale){
						var _aggroSpeed = ceil(alarm1 / _aggroFactor);
						if(alarm1 - _aggroSpeed > 0 && instance_is(self, enemy)){
							 // Not Boss:
							if(!_vars.boss){
								 // Not Attacking:
								if(
									alarm2 < 0
									&& ("ammo" not in self || ammo <= 0)
									&& (sprite_index == spr_idle || sprite_index == spr_walk || sprite_index == spr_hurt)
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
						!instance_exists(_target)
						|| ("team" in self && "team" in _target && team == _target.team)
						|| collision_line(x, y, _target.x, _target.y, Wall, false, false)
					){
						var _search = instances_matching_ne(enemy, "mask_index", mskNone);
						
						if("team" in self){
							_search = instances_matching_ne(_search, "team", team);
						}
						
						_target = instance_nearest_array(x, y, _search);
						_vars.target = _target;
					}
					
					 // Move Players to Target (the key to this system):
					var _lastPos = [];
					if("target" in self){
						if(!_targetCrash){
							target = _target;
						}
						
						with(Player){
							array_push(_lastPos, [id, x, y]);
							if(instance_exists(_target)){
								x = _target.x;
								y = _target.y;
							}
							else{
								var	l = 10000,
									d = random(360);
									
								x += lengthdir_x(l, d);
								y += lengthdir_y(l, d);
							}
						}
					}
					
					 // Call Main Code:
					try{
						 // Custom Objects (Override Step Event):
						var _step = _vars.on_step;
						if(array_length(_step) > 0){
							if(array_length(on_step) > 0){
								_step = on_step;
								_vars.on_step = _step;
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
					
					 // Prevent Crash:
					if(_targetCrash && instance_exists(self)){
						target = noone;
					}
					
					 // Newly Spawned Things:
					if(GameObject.id > _minID){
						 // Set Creator:
						with(instances_matching(instances_matching_gt(_charmObject, "id", _minID), "creator", null, noone)){
							creator = other;
						}
						
						 // Ally-ify Projectiles:
						team_instance_sprite(
							variable_instance_get(self, "team", _vars.team),
							instances_matching(instances_matching_gt([projectile, LaserCannon], "id", _minID), "creator", self, noone)
						);
					}
					
					 // Enemy Stuff:
					if(instance_is(self, enemy)){
						 // Add to Charm Drawing:
						if(visible){
							var _draw = _charmDraw[player_is_active(_vars.index) ? (_vars.index + 1) : 0];
							with(_draw){
								array_push(inst, other);
								if(other.depth < depth) depth = other.depth;
							}
						}
						
						 // Follow Leader:
						if(instance_exists(Player)){
							if(meleedamage <= 0 || "gunangle" in self || ("walk" in self && walk > 0)){
								if("ammo" not in self || ammo <= 0){
									if(distance_to_object(Player) > 256 || !instance_exists(_target) || !in_sight(_target) || !in_distance(_target, 80)){
										 // Player to Follow:
										var n = instance_nearest(x, y, Player);
										if(instance_exists(player_find(_vars.index))){
											n = instance_nearest_array(x, y, instances_matching(Player, "index", _vars.index));
										}
										
										 // Stay in Range:
										if(distance_to_object(n) > 32){
											motion_add_ct(point_direction(x, y, n.x, n.y), 1);
										}
									}
								}
							}
						}
						
						 // Contact Damage:
						if(place_meeting(x, y, enemy)){
							with(instances_meeting(x, y, instances_matching_ne(instances_matching_ne(enemy, "team", team), "creator", self))){
								if(place_meeting(x, y, other)) with(other){
									 // Disable Freeze Frames:
									var _freeze = UberCont.opt_freeze;
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
									
									 // Reset Stuff:
									UberCont.opt_freeze = _freeze;
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
										charm_instance(other, false);
										event_perform(ev_collision, enemy);
									}
								}
							}
						}
						*/
					}
					
					 // Object-Specifics:
					if(instance_exists(self)){
						switch(object_index){
							case BigMaggot:
								if(alarm1 < 0) alarm1 = irandom_range(10, 20); // JW u did this to me
							case MaggotSpawn:
							case RadMaggotChest:
							case FiredMaggot:
							case RatkingRage:
							case InvSpider: /// Charm Spawned Bros
								if(
									my_health <= 0
									||
									(object_index == FiredMaggot && place_meeting(x + hspeed_raw, y + vspeed_raw, Wall))
									||
									(object_index == RatkingRage && walk > 0 && walk <= ceil(current_time_scale))
								){
									var _minID = GameObject.id;
									instance_destroy();
									with(instances_matching_gt(_charmObject, "id", _minID)){
										creator = other;
									}
								}
								break;
								
							case MeleeBandit:
							case JungleAssassin: /// Overwrite Movement
								if(walk > 0){
									_vars.walk = walk;
									walk = 0;
								}
								if(_vars.walk > 0){
									_vars.walk -= current_time_scale;
									
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
								
							case Sniper: /// Aim at Target
								if(alarm2 > 5){
									gunangle = point_direction(x, y, _target.x, _target.y);
								}
								break;
								
							case ScrapBoss: /// Override Movement
								if(walk > 0){
									_vars.walk = walk;
									walk = 0;
								}
								if(_vars.walk > 0){
									_vars.walk -= current_time_scale;
									
									motion_add_ct(direction, 0.5);
									if(instance_exists(_target)){
										motion_add(point_direction(x, y, _target.x, _target.y), 0.5);
									}
									
									 // Sound:
									if(round(_vars.walk / 10) == _vars.walk / 10){
										sound_play(sndBigDogWalk);
									}
									
									 // Animate:
									sprite_index = ((_vars.walk <= 0) ? spr_idle : spr_walk);
								}
								break;
								
							case ScrapBossMissile: /// Don't Move Towards Player
								if(sprite_index != spr_hurt){
									if(instance_exists(Player)){
										var n = instance_nearest(x, y, Player);
										motion_add_ct(point_direction(n.x, n.y, x, y), 0.1);
									}
									if(instance_exists(_target)){
										motion_add_ct(point_direction(x, y, _target.x, _target.y), 0.1);
									}
									speed = 2;
									x = xprevious + hspeed_raw;
									y = yprevious + vspeed_raw;
								}
								break;
								
							case LaserCrystal:
							case InvLaserCrystal: /// Ally-ify Laser Charge
								var n = `charmally_${self}_check`;
								with(instances_matching(LaserCharge, n, null)){
									variable_instance_set(self, n, true);
									
									var	_x1 = xstart,
										_y1 = ystart,
										_x2 = other.xprevious,
										_y2 = other.yprevious,
										_dis = point_distance(_x1, _y1, _x2, _y2),
										_dir = point_direction(_x1, _y1, _x2, _y2);
										
									if(_dis < 5 || (alarm0 == round(1 + (_dis / speed)) && abs(angle_difference(direction, _dir)) < 0.1)){
										team_instance_sprite(other.team, self);
									}
								}
								break;
								
							case LightningCrystal: /// Ally-ify Lightning
								var n = `charmally_${self}_check`;
								with(instances_matching(EnemyLightning, n, null)){
									variable_instance_set(self, n, true);
									
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
								
							case LilHunterFly: /// Land on Enemies
								if(sprite_index == sprLilHunterLand && z < -160){
									if(instance_exists(_target)){
										x = _target.x;
										y = _target.y;
									}
								}
								break;
								
							case ExploFreak:
							case RhinoFreak: /// Don't Move Towards Player
								if(instance_exists(Player)){
									x -= lengthdir_x(current_time_scale, direction);
									y -= lengthdir_y(current_time_scale, direction);
								}
								if(instance_exists(_target)){
									mp_potential_step(_target.x, _target.y, current_time_scale, false);
								}
								break;
								
							case Shielder:
							case EliteShielder: /// Fix Shield Team
								with(instances_matching(PopoShield, "creator", self)) team = other.team;
								break;
								
							case Inspector:
							case EliteInspector: /// Fix Telekinesis Pull
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
								
							case EnemyHorror: /// Don't Shoot Beam at Player
								if(instance_exists(_target)){
									gunangle = point_direction(x, y, _target.x, _target.y);
								}
								with(instances_matching(instances_matching(projectile, "creator", self), "charmed_horror", null)){
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
					}
				}
				
				if(instance_exists(self)){
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
					if(_vars.kill && array_length(instances_matching_ne(instances_matching_ne(enemy, "team", team), "object_index", Van)) <= 0){
						charm_instance(self, false);
					}
					
					 // Charm Timer:
					else if((instance_is(self, hitme) || instance_is(self, becomenemy)) && _vars.time > 0){
						_vars.time -= _vars.time_speed * current_time_scale;
						if(_vars.time <= 0) charm_instance(self, false);
					}
				}
			}
			
			 // Charm Spawned Enemies:
			with(instances_matching(instances_matching(_charmObject, "creator", self), "ntte_charm", null)){
				if(!instance_exists(other) || place_meeting(x, y, other)){
					var c = charm_instance(id, true);
					c.index = _vars.index;
					
					if(instance_is(self, hitme)){
						 // Kill When Uncharmed if Infinitely Spawned:
						if(!_vars.boss && "kills" in self && kills <= 0){
							c.kill = true;
							if("raddrop" in self) raddrop = 0;
						}
						
						 // Featherize:
						repeat(max(_vars.time / 90, 1)){
							with(obj_create(x + orandom(24), y + orandom(24), "ParrotFeather")){
								target = other;
								index = _vars.index;
								with(player_find(index)) other.bskin = bskin;
								sprite_index = race_get_sprite("parrot", sprite_index);
							}
						}
					}
					else c.time = _vars.time;
				}
			}
		}
		
		 // Done:
		else{
			var _pos = array_find_index(other.inst, self);
			other.inst = array_delete(other.inst, _pos);
			other.vars = array_delete(other.vars, _pos);
		}
	}
	
	 // Drawing:
	for(var i = 0; i < array_length(_charmDraw); i++){
		var _draw = _charmDraw[i];
		if(array_length(_draw.inst) > 0){
			script_bind_draw(charm_draw, _draw.depth - 0.1, _draw.inst, i - 1);
		}
	}
	
	 // Goodbye:
	if(array_length(inst) <= 0){
		instance_destroy();
	}
	
	if(lag) trace_time(script[2] + " " + string(_instNum));
	
#define charm_draw(_inst, _index)
	/*
		Draws green eyes and outlines for charmed enemies
	*/
	
	if(lag) trace_time();
	
	if(_index < 0) _index = player_find_local_nonsync();
	
	var	_vx = view_xview_nonsync,
		_vy = view_yview_nonsync,
		_gw = game_width,
		_gh = game_height;
		
	with(surface_setup("CharmScreen", _gw, _gh, game_scale_nonsync)){
		x = _vx;
		y = _vy;
		
		 // Copy & Clear Screen:
		draw_set_blend_mode_ext(bm_one, bm_zero);
		surface_screenshot(surf);
		draw_set_alpha(0);
		draw_surface_scale(surf, x, y, 1 / scale);
		draw_set_alpha(1);
		draw_set_blend_mode(bm_normal);
		
		 // Find Co-op Screen Bounding Area:
		var	_x1 = null,
			_y1 = null,
			_x2 = null,
			_y2 = null;
			
		for(var i = 0; i < maxp; i++){
			if(player_is_active(i)){
				var	_x = view_xview[i],
					_y = view_yview[i];
					
				if(is_undefined(_x1) || _x       > _x1) _x1 = _x;
				if(is_undefined(_y1) || _y       > _y1) _y1 = _y;
				if(is_undefined(_x2) || _x + _gw < _x2) _x2 = _x + _gw;
				if(is_undefined(_y2) || _y + _gh < _y2) _y2 = _y + _gh;
			}
		}
		
		 // Call Enemy Draw Events:
		var _lastTimeScale = current_time_scale;
		current_time_scale = 0.0000000001;
		try{
			with(other){
				with(instance_rectangle_bbox(_x1 - 24, _y1 - 24, _x2 + 24, _y2 + 24, _inst)){
					event_perform(ev_draw, 0);
				}
			}
		}
		catch(_error){
			trace_error(_error);
		}
		current_time_scale = _lastTimeScale;
		
		 // Copy Enemy Drawing:
		var _outline = option_get("outline:charm");
		with(surface_setup("Charm", w, h, (_outline ? option_get("quality:main") : scale))){
			x = other.x;
			y = other.y;
			
			 // Copy Enemy Drawing & Redraw Old Screen:
			draw_set_blend_mode_ext(bm_one, bm_zero);
			surface_screenshot(surf);
			with(other) draw_surface_scale(surf, x, y, 1 / scale);
			draw_set_blend_mode(bm_normal);
			
			 // Outlines:
			if(_outline){
				draw_set_fog(true, player_get_color(_index), 0, 0);
				for(var a = 0; a < 360; a += 90){
					draw_surface_scale(surf, x + dcos(a), y - dsin(a), 1 / scale);
				}
				draw_set_fog(false, 0, 0, 0);
				draw_surface_scale(surf, x, y, 1 / scale);
			}
			
			 // Eye Shader:
			if(shader_setup("Charm", surface_get_texture(surf), [w, h])){
				draw_surface_scale(surf, x, y, 1 / scale);
				shader_reset();
			}
		}
	}
	
	if(lag) trace_time(script[2] + " " + string(_index));
	
	instance_destroy();
	
#define cleanup
	with(Loadout){
		instance_destroy();
		with(loadbutton) instance_destroy();
	}
	
	
/// SCRIPTS
#macro  area_campfire                                                                           0
#macro  area_desert                                                                             1
#macro  area_sewers                                                                             2
#macro  area_scrapyards                                                                         3
#macro  area_caves                                                                              4
#macro  area_city                                                                               5
#macro  area_labs                                                                               6
#macro  area_palace                                                                             7
#macro  area_vault                                                                              100
#macro  area_oasis                                                                              101
#macro  area_pizza_sewers                                                                       102
#macro  area_mansion                                                                            103
#macro  area_cursed_caves                                                                       104
#macro  area_jungle                                                                             105
#macro  area_hq                                                                                 106
#macro  area_crib                                                                               107
#macro  infinity                                                                                1/0
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  anim_end                                                                                image_index + image_speed_raw >= image_number
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
#macro  player_active                                                                           visible && !instance_exists(GenCont) && !instance_exists(LevCont) && !instance_exists(SitDown) && !instance_exists(PlayerSit)
#macro  game_scale_nonsync                                                                      game_screen_get_width_nonsync() / game_width
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
#define save_get(_name, _default)                                                       return  mod_script_call_nc('mod', 'teassets', 'save_get', _name, _default);
#define save_set(_name, _value)                                                                 mod_script_call_nc('mod', 'teassets', 'save_set', _name, _value);
#define option_get(_name)                                                               return  mod_script_call_nc('mod', 'teassets', 'option_get', _name);
#define option_set(_name, _value)                                                               mod_script_call_nc('mod', 'teassets', 'option_set', _name, _value);
#define stat_get(_name)                                                                 return  mod_script_call_nc('mod', 'teassets', 'stat_get', _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc('mod', 'teassets', 'stat_set', _name, _value);
#define unlock_get(_name)                                                               return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _name);
#define unlock_set(_name, _value)                                                       return  mod_script_call_nc('mod', 'teassets', 'unlock_set', _name, _value);
#define surface_setup(_name, _w, _h, _scale)                                            return  mod_script_call_nc('mod', 'teassets', 'surface_setup', _name, _w, _h, _scale);
#define shader_setup(_name, _texture, _args)                                            return  mod_script_call_nc('mod', 'teassets', 'shader_setup', _name, _texture, _args);
#define shader_add(_name, _vertex, _fragment)                                           return  mod_script_call_nc('mod', 'teassets', 'shader_add', _name, _vertex, _fragment);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define top_create(_x, _y, _obj, _spawnDir, _spawnDis)                                  return  mod_script_call_nc('mod', 'telib', 'top_create', _x, _y, _obj, _spawnDir, _spawnDis);
#define chest_create(_x, _y, _obj)                                                      return  mod_script_call_nc('mod', 'telib', 'chest_create', _x, _y, _obj);
#define trace_error(_error)                                                                     mod_script_call_nc('mod', 'telib', 'trace_error', _error);
#define view_shift(_index, _dir, _pan)                                                          mod_script_call_nc('mod', 'telib', 'view_shift', _index, _dir, _pan);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc('mod', 'telib', 'sleep_max', _milliseconds);
#define in_distance(_inst, _dis)                                                        return  mod_script_call(   'mod', 'telib', 'in_distance', _inst, _dis);
#define in_sight(_inst)                                                                 return  mod_script_call(   'mod', 'telib', 'in_sight', _inst);
#define instance_budge(_objAvoid, _disMax)                                              return  mod_script_call(   'mod', 'telib', 'instance_budge', _objAvoid, _disMax);
#define instance_random(_obj)                                                           return  mod_script_call_nc('mod', 'telib', 'instance_random', _obj);
#define instance_clone()                                                                return  mod_script_call(   'mod', 'telib', 'instance_clone');
#define instance_nearest_array(_x, _y, _inst)                                           return  mod_script_call_nc('mod', 'telib', 'instance_nearest_array', _x, _y, _inst);
#define instance_nearest_bbox(_x, _y, _inst)                                            return  mod_script_call_nc('mod', 'telib', 'instance_nearest_bbox', _x, _y, _inst);
#define instance_nearest_rectangle(_x1, _y1, _x2, _y2, _inst)                           return  mod_script_call_nc('mod', 'telib', 'instance_nearest_rectangle', _x1, _y1, _x2, _y2, _inst);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc('mod', 'telib', 'instance_rectangle', _x1, _y1, _x2, _y2, _obj);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call_nc('mod', 'telib', 'instance_rectangle_bbox', _x1, _y1, _x2, _y2, _obj);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call_nc('mod', 'telib', 'instances_at', _x, _y, _obj);
#define instances_seen_nonsync(_obj, _bx, _by)                                          return  mod_script_call_nc('mod', 'telib', 'instances_seen_nonsync', _obj, _bx, _by);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   'mod', 'telib', 'instances_meeting', _x, _y, _obj);
#define variable_instance_get_list(_inst)                                               return  mod_script_call_nc('mod', 'telib', 'variable_instance_get_list', _inst);
#define variable_instance_set_list(_inst, _list)                                                mod_script_call_nc('mod', 'telib', 'variable_instance_set_list', _inst, _list);
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call_nc('mod', 'telib', 'draw_weapon', _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call_nc('mod', 'telib', 'draw_lasersight', _x, _y, _dir, _maxDistance, _width);
#define draw_surface_scale(_surf, _x, _y, _scale)                                               mod_script_call_nc('mod', 'telib', 'draw_surface_scale', _surf, _x, _y, _scale);
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
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call(   'mod', 'telib', 'area_get_sprite', _area, _spr);
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
#define floor_make(_x, _y, _obj)                                                        return  mod_script_call_nc('mod', 'telib', 'floor_make', _x, _y, _obj);
#define floor_fill(_x, _y, _w, _h, _type)                                               return  mod_script_call_nc('mod', 'telib', 'floor_fill', _x, _y, _w, _h, _type);
#define floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)                      return  mod_script_call_nc('mod', 'telib', 'floor_room_start', _spawnX, _spawnY, _spawnDis, _spawnFloor);
#define floor_room_create(_x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis)         return  mod_script_call_nc('mod', 'telib', 'floor_room_create', _x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis);
#define floor_room(_spaX, _spaY, _spaDis, _spaFloor, _w, _h, _type, _dirOff, _floorDis) return  mod_script_call_nc('mod', 'telib', 'floor_room', _spaX, _spaY, _spaDis, _spaFloor, _w, _h, _type, _dirOff, _floorDis);
#define floor_reveal(_x1, _y1, _x2, _y2, _time)                                         return  mod_script_call_nc('mod', 'telib', 'floor_reveal', _x1, _y1, _x2, _y2, _time);
#define floor_tunnel(_x1, _y1, _x2, _y2)                                                return  mod_script_call_nc('mod', 'telib', 'floor_tunnel', _x1, _y1, _x2, _y2);
#define floor_bones(_num, _chance, _linked)                                             return  mod_script_call(   'mod', 'telib', 'floor_bones', _num, _chance, _linked);
#define floor_walls()                                                                   return  mod_script_call(   'mod', 'telib', 'floor_walls');
#define wall_tops()                                                                     return  mod_script_call(   'mod', 'telib', 'wall_tops');
#define wall_clear(_x1, _y1, _x2, _y2)                                                          mod_script_call_nc('mod', 'telib', 'wall_clear', _x1, _y1, _x2, _y2);
#define sound_play_ntte(_type, _snd)                                                    return  mod_script_call_nc('mod', 'telib', 'sound_play_ntte', _type, _snd);
#define sound_play_hit_ext(_snd, _pit, _vol)                                            return  mod_script_call(   'mod', 'telib', 'sound_play_hit_ext', _snd, _pit, _vol);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call(   'mod', 'telib', 'race_get_sprite', _race, _sprite);
#define race_get_title(_race)                                                           return  mod_script_call(   'mod', 'telib', 'race_get_title', _race);
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
#define pool(_pool)                                                                     return  mod_script_call_nc('mod', 'telib', 'pool', _pool);