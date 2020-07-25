#define init
	with(Loadout){
		instance_destroy();
		with(loadbutton) instance_destroy();
	}
	
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	lag = false;
	
	 // Charm:
	charm_object = [hitme, becomenemy, MaggotExplosion, RadMaggotExplosion, ReviveArea, NecroReviveArea, RevivePopoFreak];
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

#macro charm_object global.charm_object

/// General
#define race_name              return "PARROT";
#define race_text              return "MANY FRIENDS#@rCHARM ENEMIES";
#define race_lock              return "REACH " + area_get_name("coast", 1, 0);
#define race_unlock            return "FOR REACHING COAST";
#define race_tb_text           return "@wPICKUPS @sGIVE @rFEATHERS@s";
#define race_portrait(_p, _b)  return race_sprite_raw("Portrait", _b);
#define race_mapicon(_p, _b)   return race_sprite_raw("Map",      _b);
#define race_avail             return unlock_get("race:" + mod_current);

#define race_ttip
	 // Ultra:
	if(GameCont.level >= 10 && chance(1, 5)){
		return choose(
			"MIGRATION FORMATION",
			"CHARMED, I'M SURE",
			"ADVENTURING PARTY",
			"FREE AS A BIRD"
		);
	}
	
	 // Normal:
	return choose(
		"HITCHHIKER",
		"BIRDBRAIN",
		"PARROT IS AN EXPERT TRAVELER",
		"WIND UNDER MY WINGS",
		"PARROT LIKES CAMPING",
		"MACAW WORKS TOO",
		"CHESTS GIVE @rFEATHERS@s"
	);
	
#define race_sprite(_spr)
	var _b = (("bskin" in self && is_real(bskin)) ? bskin : 0);
	
	switch(_spr){
		case sprMutant1Idle      : return race_sprite_raw("Idle",         _b);
		case sprMutant1Walk      : return race_sprite_raw("Walk",         _b);
		case sprMutant1Hurt      : return race_sprite_raw("Hurt",         _b);
		case sprMutant1Dead      : return race_sprite_raw("Dead",         _b);
		case sprMutant1GoSit     : return race_sprite_raw("GoSit",        _b);
		case sprMutant1Sit       : return race_sprite_raw("Sit",          _b);
		case sprFishMenu         : return race_sprite_raw("Idle",         _b);
		case sprFishMenuSelected : return race_sprite_raw("MenuSelected", _b);
		case sprFishMenuSelect   : return race_sprite_raw("Idle",         _b);
		case sprFishMenuDeselect : return race_sprite_raw("Idle",         _b);
		case sprChickenFeather   : return race_sprite_raw("Feather",      _b);
		case sprRogueAmmoHUD     : return race_sprite_raw("FeatherHUD",   _b);
	}
	
	return -1;
	
#define race_sound(_snd)
	switch(_snd){
		case sndMutant1Wrld : return -1;
		case sndMutant1Hurt : return sndRavenHit;
		case sndMutant1Dead : return sndAllyDead;
		case sndMutant1LowA : return -1;
		case sndMutant1LowH : return -1;
		case sndMutant1Chst : return -1;
		case sndMutant1Valt : return -1;
		case sndMutant1Crwn : return -1;
		case sndMutant1Spch : return -1;
		case sndMutant1IDPD : return -1;
		case sndMutant1Cptn : return -1;
		case sndMutant1Thrn : return -1;
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
	for(var i = 0; i < maxp; i++){
		_playersActive += player_is_active(i);
	}
	
	 // Normal:
	if(_playersActive <= 1){
		return 2;
	}
	
	 // Co-op Bugginess:
	var _num = 0;
	while(_num == 0 || unlock_get(`skin:${mod_current}:${_num}`)){
		_num++;
	}
	return _num;
	
#define race_skin_avail(_skin)
	var _playersActive = 0;
	for(var i = 0; i < maxp; i++){
		_playersActive += player_is_active(i);
	}
	
	 // Normal:
	if(_playersActive <= 1){
		return (_skin == 0 || unlock_get(`skin:${mod_current}:${_skin}`));
	}
	
	 // Co-op Bugginess:
	return true;
	
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
						if("ntte_charm" in target && (lq_defget(target.ntte_charm, "time", 0) >= 0 || creator != other)){
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
							if(("intro" in self && intro) || !enemy_boss){
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
	
#define charm_target(_vars)
	/*
		Targets a nearby enemy and moves the player to their position
		Returns an array containing the moved players and their previous position, [id, x, y]
	*/
	
	var	_playerPos   = [],
		_targetCrash = (!instance_exists(Player) && instance_is(self, Grunt)); // References player-specific vars in its alarm event, causing a crash
		
	 // Targeting:
	var	_search = hitme,
		_disMax = infinity;
		
	if("team" in self){
		_search = instances_matching_ne(_search, "team", team);
	}
	
	with(instances_matching_ne(instances_matching_ne(_search, "team", 0), "mask_index", mskNone)){
		var _dis = point_distance(x, y, other.x, other.y);
		if(_dis < _disMax){
			if(!instance_is(self, prop)){
				if(instance_seen(x, y, other)){
					_disMax = _dis;
					_vars.target = id;
				}
			}
		}
	}
	
	 // Move Players to Target (the key to this system):
	if("target" in self){
		if(!_targetCrash){
			target = _vars.target;
		}
		
		with(Player){
			array_push(_playerPos, [id, x, y]);
			
			if(instance_exists(_vars.target)){
				x = _vars.target.x;
				y = _vars.target.y;
			}
			
			else{
				var	_l = 10000,
					_d = random(360);
					
				x += lengthdir_x(_l, _d);
				y += lengthdir_y(_l, _d);
			}
		}
	}
	
	return _playerPos;
	
#define charm_grab(_vars, _minID)
	/*
		Finds any charmable instances above the given minimum ID to set 'creator' on unowned ones, and resprite any projectiles to the charmed enemy's team
	*/
	
	if(GameObject.id > _minID){
		 // Set Creator:
		with(instances_matching(instances_matching_gt(charm_object, "id", _minID), "creator", null, noone)){
			creator = other;
		}
		
		 // Ally-ify Projectiles:
		with(instances_matching(instances_matching_gt([projectile, LaserCannon], "id", _minID), "creator", self, noone)){
			if(sprite_get_team(sprite_index) != 3){
				team_instance_sprite(team, self);
			}
		}
	}
	
#define charm_step
	if(lag) trace_time();

	 // Charm Draw Setup:
	var _charmDraw = array_create(maxp + 1);
	for(var i = 0; i < array_length(_charmDraw); i++){
		_charmDraw[i] = {
			inst  : [],
			depth : infinity
		};
	}
	
	 // Collect Charmed Instances:
	with(instances_matching_ne(charm_object, "ntte_charm", null)){
		if(ntte_charm.charmed && array_find_index(other.inst, id) < 0){
			array_push(other.inst, id);
			array_push(other.vars, ntte_charm);
		}
	}
	
	 // Charm Step:
	var	_instNum  = 0,
		_instList = array_clone(inst),
		_varsList = array_clone(vars);
		
	with(_instList){
		var _vars = _varsList[_instNum++];
		
		if(_vars.charmed){
			if(!instance_exists(self)) _vars.charmed = false;
			else{
				if("ntte_charm_override" not in self || !ntte_charm_override){
					var	_lastDir     = direction,
						_isCustom    = (string_pos("Custom", object_get_name(object_index)) == 1),
						_aggroFactor = 10;
						
					 // Emergency Target:
					if(!instance_exists(_vars.target)){
						with(charm_target(_vars)){
							with(self[0]){
								x = other[1];
								y = other[2];
							}
						}
					}
					
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
					
					 // Custom (Replace Step Event):
					if(_isCustom){
						if(array_length(_vars.on_step) <= 0 && is_array(on_step)){
							_vars.on_step = on_step;
							on_step = script_ref_create(charm_step_obj);
						}
					}
					
					 // Normal (Run Alarms):
					else{
						var _minID = GameObject.id;
						
						for(var _alarmNum = 0; _alarmNum <= 10; _alarmNum++){
							var _alarm = alarm_get(_alarmNum);
							if(_alarm > 0 && _alarm <= ceil(current_time_scale)){
								var _playerPos = charm_target(_vars);
								
								 // Call Alarm Event:
								try{
									alarm_set(_alarmNum, 0);
									event_perform(ev_alarm, _alarmNum);
								}
								catch(_error){
									trace_error(_error);
								}
								
								 // Return Moved Players:
								with(_playerPos){
									with(self[0]){
										x = other[1];
										y = other[2];
									}
								}
								
								 // 1 Frame Extra:
								if(instance_exists(self)){
									_alarm = alarm_get(_alarmNum);
									if(_alarm > 0){
										alarm_set(_alarmNum, _alarm + ceil(current_time_scale));
									}
								}
								else break;
							}
						}
						
						 // Grab Spawned Things:
						charm_grab(_vars, _minID);
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
							if(
								meleedamage <= 0
								|| "gunangle" in self
								|| ("walk" in self && walk > 0 && !instance_is(self, ExploFreak))
							){
								if("ammo" not in self || ammo <= 0){
									if(distance_to_object(Player) > 256 || !instance_exists(_vars.target) || !instance_seen(x, y, _vars.target) || !instance_near(x, y, _vars.target, 80)){
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
					}
					
					 // Object-Specifics:
					if(instance_exists(self) && !_isCustom){
						switch(object_index){
							
							case BigMaggot:
								if(alarm1 < 0) alarm1 = irandom_range(10, 20); // JW u did this to me
							case MaggotSpawn:
							case RadMaggotChest:
							case JungleFly:
							case FiredMaggot:
							case RatkingRage:
							case InvSpider:
								
								 // Charm Spawned Bros:
								if(
									my_health <= 0
									|| (object_index == FiredMaggot && place_meeting(x + hspeed_raw, y + vspeed_raw, Wall))
									|| (object_index == RatkingRage && walk > 0 && walk <= current_time_scale)
								){
									var _minID = GameObject.id;
									instance_destroy();
									with(instances_matching_gt(charm_object, "id", _minID)){
										creator = other;
									}
								}
								
								break;
								
							case MeleeBandit:
							case JungleAssassin:
								
								 // Move Towards Target:
								if(walk > 0){
									var _spd = ((object_index == JungleAssassin) ? 1 : 2) * current_time_scale;
									
									if(instance_exists(Player)){
										var	_ox = lengthdir_x(_spd, _lastDir),
											_oy = lengthdir_y(_spd, _lastDir);
											
										if(place_free(x - _ox, y)) x -= _ox;
										if(place_free(x, y - _oy)) y -= _oy;
									}
									if(instance_exists(_vars.target)){
										mp_potential_step(_vars.target.x, _vars.target.y, _spd, false);
									}
								}
								
								break;
								
							case Sniper:
								
								 // Aim at Target:
								if(alarm2 > 5 && instance_exists(_vars.target)){
									gunangle = point_direction(x, y, _vars.target.x, _vars.target.y);
								}
								
								break;
								
							case ScrapBoss:
								
								 // Move Towards Target:
								if(walk > 0 && instance_exists(_vars.target)){
									motion_add(point_direction(x, y, _vars.target.x, _vars.target.y), 0.5);
								}
								
								break;
								
							case ScrapBossMissile:
								
								 // Move Towards Target:
								if(sprite_index != spr_hurt && instance_exists(_vars.target)){
									motion_add_ct(point_direction(x, y, _vars.target.x, _vars.target.y), 0.2);
								}
								
								break;
								
							case LilHunterFly:
								
								 // Land on Enemies:
								if(sprite_index == sprLilHunterLand && z < -160){
									if(instance_exists(_vars.target)){
										x = _vars.target.x;
										y = _vars.target.y;
									}
								}
								
								break;
								
							case ExploFreak:
							case RhinoFreak:
								
								 // Move Towards Target:
								var _spd = current_time_scale;
								if(instance_exists(Player)){
									var	_ox = lengthdir_x(_spd, _lastDir),
										_oy = lengthdir_y(_spd, _lastDir);
										
									if(place_free(x - _ox, y)) x -= _ox;
									if(place_free(x, y - _oy)) y -= _oy;
								}
								if(instance_exists(_vars.target)){
									mp_potential_step(_vars.target.x, _vars.target.y, _spd, false);
								}
								
								break;
								
							case Shielder:
							case EliteShielder:
								
								 // Fix Shield Team:
								with(instances_matching(PopoShield, "creator", self)){
									team = other.team;
								}
								
								break;
								
							case Inspector:
							case EliteInspector:
								
								 // Fix Telekinesis Pull:
								if(control == true){
									var _dis = (1 + (object_index == EliteInspector)) * current_time_scale;
									with(instances_matching([Player, Ally], "team", team)){
										if(point_distance(x, y, other.x, other.y) < 160){
											var	_dir = point_direction(x, y, other.x, other.y),
												_ox  = lengthdir_x(_dis, _dir),
												_oy  = lengthdir_y(_dis, _dir);
												
											if(place_free(x + _ox, y)) x -= _ox;
											if(place_free(x, y + _oy)) y -= _oy;
										}
									}
								}
								
								break;
								
							case EnemyHorror:
								
								 // Don't Shoot Beam at Player:
								if(ammo > 0 && instance_exists(_vars.target)){
									var _player = instance_nearest(x, y, Player);
									if(instance_exists(_player)){
										gunangle = point_direction(x, y, _player.x, _player.y);
										
										if(abs(angle_difference(point_direction(x, y, _vars.target.x, _vars.target.y), gunangle + gunoffset)) > 10){
											gunoffset = angle_difference(point_direction(x, y, _vars.target.x, _vars.target.y), gunangle) + orandom(10);
										}
									}
								}
								
								break;
								
						}
					}
				}
				
				 // Reset Step Event:
				else if(array_length(_vars.on_step) > 0){
					on_step = _vars.on_step;
					_vars.on_step = [];
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
					else if(_vars.time >= 0){
						_vars.time -= _vars.time_speed * current_time_scale;
						if(_vars.time <= 0){
							charm_instance(self, false);
						}
					}
				}
			}
			
			 // Charm Spawned Enemies:
			if(_vars.charmed){
				with(instances_matching(instances_matching(charm_object, "creator", self), "ntte_charm", null)){
					var _hitme = (instance_is(self, hitme) || instance_is(self, becomenemy));
					if(!_hitme || !instance_exists(other) || place_meeting(x, y, other)){
						var _charm = charm_instance(id, true);
						
						_charm.time    = _vars.time;
						_charm.index   = _vars.index;
						_charm.feather = _vars.feather;
						
						if(_hitme){
							 // Kill When Uncharmed if Infinitely Spawned:
							if(!_vars.boss && "kills" in self && kills <= 0){
								_charm.kill = true;
								if("raddrop" in self) raddrop = 0;
							}
							
							 // Featherize:
							if(_charm.feather && _vars.time >= 0){
								repeat(max(_charm.time / 90, 1)){
									with(obj_create(x + orandom(24), y + orandom(24), "ParrotFeather")){
										target = other;
										index  = _charm.index;
										with(player_find(index)){
											other.bskin = bskin;
										}
										sprite_index = race_get_sprite("parrot", sprite_index);
									}
								}
								_charm.time = -1;
							}
						}
						else _charm.time_speed = 0;
					}
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
	
	if(lag) trace_time(script[2] + " " + string(_instNum));
	
	 // Goodbye:
	if(array_length(inst) <= 0){
		instance_destroy();
	}
	
#define charm_step_obj
	var	_vars      = ntte_charm,
		_minID     = GameObject.id,
		_playerPos = charm_target(_vars);
		
	 // Call Step Event:
	try{
		on_step = _vars.on_step;
		script_ref_call(on_step);
	}
	catch(_error){
		trace_error(_error);
	}
	
	 // Return Moved Players:
	with(_playerPos){
		with(self[0]){
			x = other[1];
			y = other[2];
		}
	}
	
	 // Reset Step:
	if(instance_exists(self)){
		_vars.on_step = on_step;
		on_step = script_ref_create(charm_step_obj);
	}
	
	 // Grab Spawned Things:
	charm_grab(_vars, _minID);
	
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
				draw_set_fog(true, (player_is_active(_index) ? player_get_color(_index) : c_white), 0, 0);
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
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
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
#macro  anim_end                                                                                (image_index + image_speed_raw >= image_number || image_index + image_speed_raw < 0)
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
#macro  enemy_boss                                                                              ('boss' in self && boss) || array_exists([BanditBoss, ScrapBoss, LilHunter, Nothing, Nothing2, FrogQueen, HyperCrystal, TechnoMancer, Last, BigFish, OasisBoss], object_index)
#macro  player_active                                                                           visible && !instance_exists(GenCont) && !instance_exists(LevCont) && !instance_exists(SitDown) && !instance_exists(PlayerSit)
#macro  game_scale_nonsync                                                                      game_screen_get_width_nonsync() / game_width
#macro  bbox_width                                                                              (bbox_right + 1) - bbox_left
#macro  bbox_height                                                                             (bbox_bottom + 1) - bbox_top
#macro  bbox_center_x                                                                           (bbox_left + bbox_right + 1) / 2
#macro  bbox_center_y                                                                           (bbox_top + bbox_bottom + 1) / 2
#macro  FloorNormal                                                                             instances_matching(Floor, 'object_index', Floor)
#macro  alarm0_run                                                                              alarm0 >= 0 && --alarm0 == 0 && (script_ref_call(on_alrm0) || !instance_exists(self))
#macro  alarm1_run                                                                              alarm1 >= 0 && --alarm1 == 0 && (script_ref_call(on_alrm1) || !instance_exists(self))
#macro  alarm2_run                                                                              alarm2 >= 0 && --alarm2 == 0 && (script_ref_call(on_alrm2) || !instance_exists(self))
#macro  alarm3_run                                                                              alarm3 >= 0 && --alarm3 == 0 && (script_ref_call(on_alrm3) || !instance_exists(self))
#macro  alarm4_run                                                                              alarm4 >= 0 && --alarm4 == 0 && (script_ref_call(on_alrm4) || !instance_exists(self))
#macro  alarm5_run                                                                              alarm5 >= 0 && --alarm5 == 0 && (script_ref_call(on_alrm5) || !instance_exists(self))
#macro  alarm6_run                                                                              alarm6 >= 0 && --alarm6 == 0 && (script_ref_call(on_alrm6) || !instance_exists(self))
#macro  alarm7_run                                                                              alarm7 >= 0 && --alarm7 == 0 && (script_ref_call(on_alrm7) || !instance_exists(self))
#macro  alarm8_run                                                                              alarm8 >= 0 && --alarm8 == 0 && (script_ref_call(on_alrm8) || !instance_exists(self))
#macro  alarm9_run                                                                              alarm9 >= 0 && --alarm9 == 0 && (script_ref_call(on_alrm9) || !instance_exists(self))
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define pround(_num, _precision)                                                        return  (_num == 0) ? _num : round(_num / _precision) * _precision;
#define pfloor(_num, _precision)                                                        return  (_num == 0) ? _num : floor(_num / _precision) * _precision;
#define pceil(_num, _precision)                                                         return  (_num == 0) ? _num :  ceil(_num / _precision) * _precision;
#define in_range(_num, _lower, _upper)                                                  return  (_num >= _lower && _num <= _upper);
#define frame_active(_interval)                                                         return  (current_frame % _interval) < current_time_scale;
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define enemy_walk(_add, _max)                                                                  if(walk > 0){ walk -= current_time_scale; motion_add_ct(direction, _add); } if(speed > _max) speed = _max;
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
#define projectile_create(_x, _y, _obj, _dir, _spd)                                     return  mod_script_call(   'mod', 'telib', 'projectile_create', _x, _y, _obj, _dir, _spd);
#define chest_create(_x, _y, _obj, _levelStart)                                         return  mod_script_call_nc('mod', 'telib', 'chest_create', _x, _y, _obj, _levelStart);
#define prompt_create(_text)                                                            return  mod_script_call(   'mod', 'telib', 'prompt_create', _text);
#define alert_create(_inst, _sprite)                                                    return  mod_script_call(   'mod', 'telib', 'alert_create', _inst, _sprite);
#define door_create(_x, _y, _dir)                                                       return  mod_script_call_nc('mod', 'telib', 'door_create', _x, _y, _dir);
#define trace_error(_error)                                                                     mod_script_call_nc('mod', 'telib', 'trace_error', _error);
#define view_shift(_index, _dir, _pan)                                                          mod_script_call_nc('mod', 'telib', 'view_shift', _index, _dir, _pan);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc('mod', 'telib', 'sleep_max', _milliseconds);
#define instance_seen(_x, _y, _obj)                                                     return  mod_script_call_nc('mod', 'telib', 'instance_seen', _x, _y, _obj);
#define instance_near(_x, _y, _obj, _dis)                                               return  mod_script_call_nc('mod', 'telib', 'instance_near', _x, _y, _obj, _dis);
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
#define enemy_hurt(_hitdmg, _hitvel, _hitdir)                                                   mod_script_call(   'mod', 'telib', 'enemy_hurt', _hitdmg, _hitvel, _hitdir);
#define enemy_target(_x, _y)                                                            return  mod_script_call(   'mod', 'telib', 'enemy_target', _x, _y);
#define boss_hp(_hp)                                                                    return  mod_script_call_nc('mod', 'telib', 'boss_hp', _hp);
#define boss_intro(_name)                                                               return  mod_script_call_nc('mod', 'telib', 'boss_intro', _name);
#define corpse_drop(_dir, _spd)                                                         return  mod_script_call(   'mod', 'telib', 'corpse_drop', _dir, _spd);
#define rad_drop(_x, _y, _raddrop, _dir, _spd)                                          return  mod_script_call_nc('mod', 'telib', 'rad_drop', _x, _y, _raddrop, _dir, _spd);
#define rad_path(_inst, _target)                                                        return  mod_script_call_nc('mod', 'telib', 'rad_path', _inst, _target);
#define area_set(_area, _subarea, _loops)                                               return  mod_script_call_nc('mod', 'telib', 'area_set', _area, _subarea, _loops);
#define area_get_name(_area, _subarea, _loops)                                          return  mod_script_call_nc('mod', 'telib', 'area_get_name', _area, _subarea, _loops);
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call(   'mod', 'telib', 'area_get_sprite', _area, _spr);
#define area_get_subarea(_area)                                                         return  mod_script_call_nc('mod', 'telib', 'area_get_subarea', _area);
#define area_get_secret(_area)                                                          return  mod_script_call_nc('mod', 'telib', 'area_get_secret', _area);
#define area_get_underwater(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_underwater', _area);
#define area_get_back_color(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_back_color', _area);
#define area_get_shad_color(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_shad_color', _area);
#define area_border(_y, _area, _color)                                                  return  mod_script_call_nc('mod', 'telib', 'area_border', _y, _area, _color);
#define area_generate(_area, _sub, _loops, _x, _y, _setArea, _overlapFloor, _scrSetup)  return  mod_script_call_nc('mod', 'telib', 'area_generate', _area, _sub, _loops, _x, _y, _setArea, _overlapFloor, _scrSetup);
#define floor_get(_x, _y)                                                               return  mod_script_call_nc('mod', 'telib', 'floor_get', _x, _y);
#define floor_set(_x, _y, _state)                                                       return  mod_script_call_nc('mod', 'telib', 'floor_set', _x, _y, _state);
#define floor_set_style(_style, _area)                                                  return  mod_script_call_nc('mod', 'telib', 'floor_set_style', _style, _area);
#define floor_set_align(_alignX, _alignY, _alignW, _alignH)                             return  mod_script_call_nc('mod', 'telib', 'floor_set_align', _alignX, _alignY, _alignW, _alignH);
#define floor_reset_style()                                                             return  mod_script_call_nc('mod', 'telib', 'floor_reset_style');
#define floor_reset_align()                                                             return  mod_script_call_nc('mod', 'telib', 'floor_reset_align');
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
#define sound_play_hit_ext(_snd, _pit, _vol)                                            return  mod_script_call(   'mod', 'telib', 'sound_play_hit_ext', _snd, _pit, _vol);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call(   'mod', 'telib', 'race_get_sprite', _race, _sprite);
#define race_get_title(_race)                                                           return  mod_script_call(   'mod', 'telib', 'race_get_title', _race);
#define player_create(_x, _y, _index)                                                   return  mod_script_call_nc('mod', 'telib', 'player_create', _x, _y, _index);
#define player_swap()                                                                   return  mod_script_call(   'mod', 'telib', 'player_swap');
#define wep_raw(_wep)                                                                   return  mod_script_call_nc('mod', 'telib', 'wep_raw', _wep);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc('mod', 'telib', 'wep_merge', _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call_nc('mod', 'telib', 'wep_merge_decide', _hardMin, _hardMax);
#define weapon_decide(_hardMin, _hardMax, _gold, _noWep)                                return  mod_script_call(   'mod', 'telib', 'weapon_decide', _hardMin, _hardMax, _gold, _noWep);
#define weapon_get_red(_wep)                                                            return  mod_script_call(   'mod', 'telib', 'weapon_get_red', _wep);
#define skill_get_icon(_skill)                                                          return  mod_script_call(   'mod', 'telib', 'skill_get_icon', _skill);
#define skill_get_avail(_skill)                                                         return  mod_script_call(   'mod', 'telib', 'skill_get_avail', _skill);
#define string_delete_nt(_string)                                                       return  mod_script_call_nc('mod', 'telib', 'string_delete_nt', _string);
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
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   'mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_inst, _charm)                                                   return  mod_script_call_nc('mod', 'telib', 'charm_instance', _inst, _charm);
#define move_step(_mult)                                                                return  mod_script_call(   'mod', 'telib', 'move_step', _mult);
#define pool(_pool)                                                                     return  mod_script_call_nc('mod', 'telib', 'pool', _pool);