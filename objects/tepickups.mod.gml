#define init
    spr = mod_variable_get("mod", "teassets", "spr");
    snd = mod_variable_get("mod", "teassets", "snd");
    mus = mod_variable_get("mod", "teassets", "mus");
    sav = mod_variable_get("mod", "teassets", "sav");
    
    DebugLag = false;
    
    global.pickup_custom = [];
    
	game_start();

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

#define Backpack_create(_x, _y)
	with(obj_create(_x, _y, "CustomChest")){
		 // Visual:
		spr_dead = spr.BackpackOpen;
		sprite_index = spr.Backpack;
		spr_shadow_y = 2;
		spr_shadow = shd16;
		
		 // Sounds:
		snd_open = choose(sndMenuASkin, sndMenuBSkin);
		
		 // Vars:
		raddrop = 8;
		switch(crown_current){
			case crwn_none:		curse = false;			break;
			case crwn_curses:	curse = chance(2, 3);	break;
			default:			curse = chance(1, 7);
		}
		for(var i = 0; i < maxp; i++){
			raddrop += (player_get_race(i) == "melting");
		}
		
		 // Cursed:
		if(curse){
			spr_dead = spr.BackpackCursedOpen;
			sprite_index = spr.BackpackCursed;
		}
		
		 // Events:
		on_step = script_ref_create(Backpack_step);
		on_open = script_ref_create(Backpack_open);
		
		return id;
	}
	
#define Backpack_step
	 // Curse FX:
	if(chance_ct(curse, 20)){
		with(instance_create(x + orandom(8), y + orandom(8), Curse)){
			depth = other.depth - 1;
		}
	}

#define Backpack_open
	var _curse = curse;
	
	if(_curse) sound_play(sndCursedChest);
	sound_play_pitchvol(sndPickupDisappear, 1 + orandom(0.4), 2);

	 // DefPack Integration:	
	if(mod_exists("mod", "defpack tools") && chance(1, 5)){
		with(instance_create(x, y, WepPickup)){
		    var _jsGrub = [
		    	"lightning blue lifting drink(tm)",
		    	"extra double triple coffee",
		    	"expresso",
		    	"saltshake",
		    	"munitions mist",
		    	"vinegar",
		    	"guardian juice",
		    	"stopwatch"]; // a beautiful mistake
		    	
			if(skill_get(mut_boiling_veins) > 0)								array_push(_jsGrub, "sunset mayo");
			if(array_length(instances_matching(Player, "notoxic", false)) > 0)	array_push(_jsGrub, "frog milk");
			
            wep = _jsGrub[irandom(array_length(_jsGrub)-1)];
            roll = true;
		}
	}
	
	 // Merged Weapon:
	else{
		var _part = wep_merge_decide(0, GameCont.hard + (2 * _curse));
		if(array_length(_part) >= 2){
			repeat(1 + ultra_get("steroids", 1)){
				with(instance_create(x, y, WepPickup)){
					wep = wep_merge(_part[0], _part[1]);
					curse = _curse;
					ammo = true;
					roll = true;
				}
			}
		}
	}
	
	 // Pickups:
	var _ang = random(360),
		_num = 2 + ceil(skill_get(mut_rabbit_paw));
		
	for(var d = _ang; d < _ang + 360; d += (360 / _num)){
		var _objMin = instance_create(x, y, Dust);
		with(_objMin) depth = 0;
		
		 // Rogues:
		var _rogue = 0;
		for(var i = 0; i < maxp; i++) if(player_get_race(i) == "rogue"){
			_rogue++;
		}
		
		 // Determine Pickup:
		if(chance(1, 40)){ // wtf this isnt a pickup
			instance_create(x, y, choose(Ally, Bandit));
		}
		else{
			pickup_drop(10000, 0);
		}
		with(instances_matching_gt(GameObject, "id", _objMin)){
			switch(object_index){
				case AmmoPickup:
				
					 // Portal Strikes:
					if(chance(_rogue, 5)){
						instance_create(x, y, RoguePickup);
						instance_delete(id);
						break;
					}
					
					 // Cursed:
					if(_curse > cursed){
						sprite_index = sprCursedAmmo;
						cursed = _curse;
						num = 1 + (0.5 * cursed);
						alarm0 = (200 + random(30)) / (1 + (2 * cursed));
					}
					
					break;
					
				case AmmoChest:
				
					 // Portal Strikes:
					if(chance(_rogue, 5)){
						instance_create(x, y, RogueChest);
						instance_delete(id);
						break;
					}
					
					 // Cursed:
					if(_curse){
						obj_create(x, y, "CursedAmmoChest");
						instance_delete(id);
					}
					
					break;
			}
		}
		
		 // Coolify:
		with(instances_matching_gt(GameObject, "id", _objMin)){
			with(obj_create(x, y, "BackpackPickup")){
				direction = d;
				target = other;
				event_perform(ev_step, ev_step_end);
			}
		}
	}
	
	 // Rads:
	repeat(raddrop){
		with(instance_create(x, y, Rad)){
			motion_add(random(360), random_range(3, 5));
		}
	}

	 // Restore Strong Spirit:
	if(instance_is(other, Player)) scrRestoreSpirit(other);


#define Backpacker_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle = spr.Backpacker;
		spr_hurt = mskNone;
		spr_dead = mskNone;
		spr_shadow_y = -2;
		sprite_index = spr_idle;
		image_index = irandom(image_number - 1);
		image_speed = 0;
		depth = -1;
		
		 // Sounds:
		snd_dead = sndHitRock;
		snd_dead = sndHitRock;
		
		 // Vars:
		mask_index = mskBandit;
		my_health = 1;
		raddrop = 2;
		size = 1;
		team = 1;
		weps = ["crabbone"];
		
		return id;
	}
	
#define Backpacker_death
	repeat(8) scrFX(x, y, [random(360), random(4)], Dust);
	repeat(6) with(scrFX(x, y, [random(360), 2 + random(3)], Shell)){
		sprite_index = spr.BonePickup[irandom(array_length(spr.BonePickup) - 1)];
		image_index = 0;
		image_speed = 0;
	}
	
	 // with(weps) was erroring :(
	for(var i = 0; i < array_length(weps); i++){
		var w = weps[i];
		with(instance_create(x, y, WepPickup)) wep = w;
	}

#define BackpackPickup_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		sprite_index = mskPickup;
		mask_index = mskPickup;
		visible = false;
		target = noone;
		target_x = x;
		target_y = y;
        z = 0;
        zfriction = 0.7;
        zspeed = random_range(2, 4);
		speed = random_range(1, 3);
		direction = random(360);
		
		return id;
	}
	
#define BackpackPickup_end_step
    if(instance_exists(target)){
	    z += zspeed * current_time_scale;
	    zspeed -= zfriction * current_time_scale;
	    if(z > 0 || zspeed > 0){
	        with(target){
	            x = other.x;
	            y = other.y - other.z;
	            xprevious = x;
	            yprevious = y;
				other.target_x = x;
				other.target_y = y;
				
				 // Important:
				if(instance_is(self, enemy)){
					sprite_index = spr_hurt;
				}
				
				 // Disable Collision:
				if(mask_index != mskNone){
					other.mask_index = other.mask_index;
					mask_index = mskNone;
				}
	        }
	        
			 // Collision:
			if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
				if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
				if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
			}
	    }
    	else instance_destroy();
    }
	
	else{
		 // Grab Pickup (In case it was replaced or something):
		with(instances_matching(instances_matching_gt(instances_matching_gt(instances_matching(instances_matching(GameObject, "xstart", target_x), "ystart", target_y), "id", id), "id", target), "backpackpickup_grab", null)){
			backpackpickup_grab = true;
			with(other){
				target = other;
				BackpackPickup_end_step();
			}
			exit;
		}
		
		 // Time to die:
		instance_destroy();
	}
	
#define BackpackPickup_destroy
     // Reset Vars:
    with(target){
    	x = other.x;
    	y = other.y;
    	xprevious = x;
    	yprevious = y;
        mask_index = other.mask_index;
		direction = other.direction;
		speed = other.speed;
		
	     // Effects:
	    repeat(3){
	        with(instance_create(x, y, Dust)){
	            motion_add(random(360), 3);
	            motion_add(other.direction, 1);
	            depth = 0;
	        }
	    }
    }


#define BatChest_create(_x, _y)
	with(obj_create(_x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.BatChest;
		spr_dead = spr.BatChestOpen;
		
		 // Sound:
		snd_open = sndWeaponChest;
		
		 // Big:
		big = false;
		setup = true;
		nochest = 1;
		
		 // Cursed:
		switch(crown_current){
			case crwn_none:		curse = false;			break;
			case crwn_curses:	curse = chance(2, 3);	break;
			default:			curse = chance(1, 7);
		}
		
		 // Events:
		on_step = script_ref_create(BatChest_step);
		on_open = script_ref_create(BatChest_open);
		
		return id;
	}

#define BatChest_setup
	setup = false;
	
	nochest = 1 + big;
	
	 // Big:
	if(big){
		if(curse){
			sprite_index = spr.BatChestBigCursed;
			spr_dead = spr.BatChestBigCursedOpen;
			snd_open = sndBigCursedChest;
		}
		else{
			sprite_index = spr.BatChestBig;
			spr_dead = spr.BatChestBigOpen;
			snd_open = sndBigWeaponChest;
		}
		spr_shadow = shd32;
	}
	
	 // Cursed:
	else if(curse){
		sprite_index = spr.BatChestCursed;
		spr_dead = spr.BatChestCursedOpen;
		snd_open = sndCursedChest;
	}

#define BatChest_step
	if(setup) BatChest_setup();
	
	 // Curse FX:
	if(chance_ct(curse, 16)){
		with(instance_create(x + orandom(8), y + orandom(8), Curse)){
			depth = other.depth - 1;
		}
	}
	
#define BatChest_open
	instance_create(x, y, PortalClear);
	
	if(big){
		 // Important:
		if(instance_is(other, Player)){
			sound_play(other.snd_chst);
		}
		
		 // Clear Big Chest Chance:
		GameCont.nochest = 0;
	}
	
	 // Manually Create ChestOpen to Link Shops:
	var _open = instance_create(x, y, ChestOpen);
	with(_open){
		sprite_index = other.spr_dead;
		if(other.curse){
			image_blend = merge_color(image_blend, c_purple, 0.6);
		}
	}
	spr_dead = -1;

	 // Create Weapon Shops:
	var o = 50 / (1 + (0.5 * big)),
		_shop = [];

	for(var a = -o * (1 + big); a <= o * (1 + big); a += o){
		var l = 28,
			d = a + 90;

		with(obj_create(x + lengthdir_x(l * ((3 + big) / 3), d), y + lengthdir_y(l, d), "ChestShop")){
			type = ChestShop_wep;
			drop = wep_screwdriver;
			open += other.big;
			curse = other.curse;
			creator = _open;
			array_push(_shop, id);
		}
	}

	 // Determine Weapons:
	var	_hardMin = 0,
		_hardMax = GameCont.hard + (2 * curse),
		_part = wep_merge_decide(_hardMin, _hardMax);
		
	for(var i = 0; i < array_length(_shop); i += 2){
		if(array_length(_part) >= 2){
			_shop[i].drop = ((_part[1].weap == -1) ? _part[1] : _part[1].weap);
			if(i + 1 < array_length(_shop)){
				_shop[i + 1].drop = wep_merge(_part[0], _part[1]);
			}
			
			 // Next Merged Weapon Uses the Current Stock as its Front:
			_part = mod_script_call("weapon", "merge", "weapon_merge_decide_raw", _hardMin, _hardMax, -1, _part[0], false);
		}
	}

	 // Effects:
	sound_play_pitchvol(sndEnergySword, 0.5 + orandom(0.1), 0.8);
	sound_play_pitchvol(sndEnergyScrewdriver, 1.5 + orandom(0.1), 0.5);
	repeat(6) scrFX(x, y, 3, Dust);


#define BoneBigPickup_create(_x, _y)
	with(obj_create(_x, _y, "BonePickup")){
		 // Visual:
		sprite_index = spr.BonePickupBig[irandom(array_length(spr.BonePickupBig) - 1)];
		
		 // Vars:
		mask_index = mskBigRad;
		num = 10;

		return id;
	}


#define BonePickup_create(_x, _y)
	with(obj_create(_x, _y, "CustomPickup")){ 
		 // Visual:
		sprite_index = spr.BonePickup[irandom(array_length(spr.BonePickup) - 1)];
		image_index = random(image_number - 1);
		image_angle = random(360);
        spr_open = -1;
        spr_fade = -1;

		 // Sound:
		snd_open = sndRadPickup;
		snd_fade = -1;

		 // Vars:
		mask_index = mskRad;
		time = 150 + random(30);
		time_loop = 1/4;
        pull_dis = 80 + (60 * skill_get(mut_plutonium_hunger));
        pull_spd = 12;

		 // Events:
		on_pull = script_ref_create(BonePickup_pull);
		on_open = script_ref_create(BonePickup_open);
		on_fade = script_ref_create(BonePickup_fade);

		return id;
	}

#define BonePickup_pull
	if(speed <= 0 && (wep_get(other.wep) == "scythe" || wep_get(other.bwep) == "scythe")){
		return true;
	}
	return false;

#define BonePickup_open
	 // Determine Handouts:
	var _inst = other;
	if(instance_is(other, Player)){
		if(wep_get(other.wep) != "scythe" && wep_get(other.bwep) != "scythe"){
			return true; // Can't be picked up
		}
	}
	else _inst = Player;

	 // Give Ammo:
	var _num = num;
	with(_inst){
		with(["wep", "bwep"]){
			var w = variable_instance_get(other, self);
			if(wep_get(w) == "scythe" && "ammo" in w){
				if(w.ammo < w.amax){
					w.ammo = min(w.ammo + _num, w.amax);
					break;
				}
			}
		}
	}

	instance_create(x, y, Dust);

#define BonePickup_fade
	instance_create(x, y, Dust);


#define CatChest_create(_x, _y)
	with(obj_create(_x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.CatChest;
		spr_dead = spr.CatChestOpen;
		
		 // Sound:
		snd_open = sndAmmoChest;
		
		on_open = script_ref_create(CatChest_open);
		
		return id;
	}
	
#define CatChest_open
	instance_create(x, y, PortalClear);

	 // Manually Create ChestOpen to Link Shops:
	var _open = instance_create(x, y, ChestOpen);
	_open.sprite_index = spr_dead;
	spr_dead = -1;

	 // Create Shops:
	var o = 50,
		_shop = [];

	for(var a = -o; a <= o; a += o){
		var l = 28,
			d = a + 90;

		with(obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "ChestShop")){
			type = ChestShop_basic;
			creator = _open;
			array_push(_shop, id);
		}
	}

	/// Randomize Items:
		var _pool = ["ammo", "health", "rads"];
		
		with(Player){
			 // Races:
			switch(race){
				case "rogue":	array_push(_pool, "rogue");		break;
				case "parrot":	array_push(_pool, "parrot");	break;
			}
			
			 // Bone:
			if(GameCont.hard >= 4 && (wep_get(wep) == "crabbone" || wep_get(bwep) == "crabbone") && chance(1, 2)){
				array_push(_pool, "bone");
			}
			if(wep_get(wep) == "scythe" || wep_get(bwep) == "scythe"){
				array_push(_pool, "bones");
			}
		}
		
		 // Bonus:
		if(GameCont.hard >= 6){
			array_push(_pool, "ammo_bonus");
			array_push(_pool, "health_bonus");
		}
		if(GameCont.hard >= 12 && chance(1, 5)){
			array_push(_pool, "spirit");
		}
		
		 // Crowns:
		switch(crown_current){
			case crwn_life:
				while(true){
					var i = array_find_index(_pool, "health");
					if(i >= 0) _pool[i] = "ammo";
					else break;
				}
				break;
				
			case crwn_guns:
				while(true){
					var i = array_find_index(_pool, "ammo");
					if(i >= 0) _pool[i] = "health";
					else break;
				}
				break;
		}
		
		 // Loop:
		if(GameCont.loops > 0){
			while(true){
				var i = array_find_index(_pool, "rads");
				if(i >= 0) _pool[i] = "rads_chest";
				else break;
			}
			while(true){
				var i = array_find_index(_pool, "ammo");
				if(i >= 0) _pool[i] = "ammo_chest";
				else break;
			}
			while(true){
				var i = array_find_index(_pool, "health");
				if(i >= 0) _pool[i] = "health_chest";
				else break;
			}
			
			 // Beep Boop:
			if(chance(2, 3)){
				array_push(_pool, "turret");
			}
		}
		
		 // Important:
		if(GameCont.hard >= 10 && mod_exists("mod", "defpack tools") && chance(1, 2)){
			array_push(_pool, "soda");
		}
		
		 // Decide:
		with(_shop){
			var i = irandom(array_length(_pool) - 1);
			drop = _pool[i];
			_pool = array_delete(_pool, i);
		}

	 // Effects:
	sound_play_pitchvol(sndEnergySword, 0.5 + orandom(0.1), 0.8);
	//sound_play_pitchvol(sndEnergyScrewdriver, 1.5 + orandom(0.1), 0.5);
	sound_play_pitchvol(sndLuckyShotProc, 0.7 + random(0.2), 0.7);
	repeat(6) scrFX(x, y, 3, Dust);


#macro ChestShop_basic	0
#macro ChestShop_wep	1

#define ChestShop_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = mskNone;
		image_speed = 0.4;
		image_blend = c_white;
		image_alpha = 0.7;
		depth = -8;

		 // Vars:
		mask_index = mskWepPickup;
		friction = 0.4;
		creator = noone;
		pickup_indicator = scrPickupIndicator("");
		shine = true;
		shine_speed = 0.025;
		open_state = 0;
		open = 1;
		wave = random(100);
		type = ChestShop_basic;
		drop = 0;
		num = 0;
		text = "";
		desc = "";
		soda = "";
		curse = false;
		setup = true;

		return id;
	}

#define ChestShop_setup
	setup = false;
	
	 // Default:
	num = 1;
	text = "";
	desc = "";
	sprite_index = sprAmmo;
	image_blend = c_white;
	
	 // Shop Setup:
	switch(type){
		case ChestShop_basic:
			switch(drop){
				case "ammo":
					num = 2;
					text = "AMMO";
					desc = `${num} PICKUPS`;
					
					 // Visual:
					sprite_index = sprAmmo;
					image_blend = make_color_rgb(255, 255, 0);
					break;
					
				case "health":
					num = 2;
					text = "HEALTH";
					desc = `${num} PICKUPS`;
					
					 // Visual:
					sprite_index = sprHP;
					image_blend = make_color_rgb(255, 255, 255);
					break;
					
				case "rads":
					num = 25;
					text = "RADS";
					desc = `${num} ${text}`;
					
					 // Visual:
					sprite_index = sprBigRad;
					image_blend = make_color_rgb(120, 230, 60);
					break;
					
				case "ammo_chest":
					text = "AMMO";
					desc = ((num > 1) ? `${num} ` : "") + "CHEST";
					
					 // Visual:
					sprite_index = (ultra_get("steroids", 2) ? sprAmmoChestSteroids : sprAmmoChest);
					image_blend = make_color_rgb(255, 255, 0);
					break;
					
				case "health_chest":
					text = "HEALTH";
					desc = ((num > 1) ? `${num} ` : "") + "CHEST";
					
					 // Visual:
					sprite_index = sprHealthChest;
					image_blend = make_color_rgb(255, 255, 255);
					break;
					
				case "rads_chest":
					text = "RADS";
					desc = `${45 * num} ${text}`;
					
					 // Visual:
					sprite_index = sprRadChestBig;
					image_blend = make_color_rgb(120, 230, 60);
					break;
					
				case "ammo_bonus":
					text = "OVERSTOCK";
					desc = `@5(${spr.BonusText}:0) AMMO`;
					
					 // Visual:
					sprite_index = spr.OverstockPickup;
					image_blend = make_color_rgb(100, 255, 255);
					break;
					
				case "health_bonus":
					text = "OVERHEAL";
					desc = `@5(${spr.BonusText}:0) HEALTH`;
					
					 // Visual:
					sprite_index = spr.OverhealPickup;
					image_blend = make_color_rgb(200, 160, 255);
					break;
					
				case "rogue":
					text = "PORTAL STRIKE";
					desc = `${num} PICKUP`;
					
					 // Visual:
					sprite_index = sprRogueAmmo;
					image_blend = make_color_rgb(140, 180, 255);
					break;
					
				case "parrot":
					num = 6;
					text = "FEATHERS";
					desc = `${num} ${text}`;
					
					 // Visual:
					sprite_index = spr.Race.parrot[0].Feather;
					image_blend = make_color_rgb(255, 120, 120);
					image_xscale = -1.2;
					image_yscale = 1.2;
					
					 // B-Skin:
					with(instance_nearest_array(x, y, instances_matching(Player, "race", "parrot"))){
						other.sprite_index = spr_feather;
						if(bskin) other.image_blend = make_color_rgb(0, 220, 255);
					}
					break;
					
				case "infammo":
					num = 90;
					text = "INFINITE AMMO";
					desc = "FOR A MOMENT";
					
					 // Visual:
					sprite_index = sprFishA;
					shine = false;
					break;
					
				case "spirit":
					text = "BONUS SPIRIT";
					desc = "LIVE FOREVER";
					
					 // Visual:
					sprite_index = spr.SpiritPickup;
					image_blend = make_color_rgb(255, 200, 140);
					break;
					
				case "bone":
					text = "BONE";
					desc = "BONE";
					
					 // Visual:
					sprite_index = sprBone;
					image_blend = make_color_rgb(220, 220, 60);
					break;
					
				case "bones":
					num = 30;
					text = "BONES";
					desc = `${num} ${text}`;
					
					 // Visual:
					sprite_index = spr.BonePickupBig[0];
					image_blend = make_color_rgb(220, 220, 60);
					break;
					
				case "soda":
					 // Decide Brand:
					var a = ["lightning blue lifting drink(tm)", "extra double triple coffee", "expresso", "saltshake", "munitions mist", "vinegar", "guardian juice"];
	        		if(skill_get(mut_boiling_veins) > 0){
	        			array_push(a, "sunset mayo");
	        		}
	        		if(array_length(instances_matching_lt(Player, "notoxic", 1)) > 0){
	        			array_push(a, "frog milk");
					}
					soda = a[irandom(array_length(a) - 1)];
	        		
	        		 // Vars:
					text = "SODA";
					desc = weapon_get_name(soda);
					
					 // Visual:
					sprite_index = weapon_get_sprt(soda);
					image_blend = make_color_rgb(220, 220, 220);
					break;
					
				case "turret":
					text = "TURRET";
					desc = "EXTRA OFFENSE";
					
					 // Visual:
					sprite_index = spr.LairTurretIdle;
					image_blend = make_color_rgb(200, 160, 180);
					image_xscale = 0.9;
					image_yscale = image_xscale;
					break;
			}
			break;

		case ChestShop_wep:
			var _merged = (wep_get(drop) == "merge");
			
			text = (curse ? "CURSED " : "") + (_merged ? "MERGED " : "") + "WEAPON";
			desc = weapon_get_name(drop);
			
			 // Visual:
			sprite_index = weapon_get_sprt(drop);
			
			var _hue = [0, 40, 120, 0, 160, 80];
				
			if(
				wep_get(drop) == "merge"		&&
				"stock" in lq_get(drop, "base")	&&
				"front" in lq_get(drop, "base")
			){
				var a = _hue[clamp(weapon_get_type(drop.base.stock), 0, array_length(_hue) - 1)],
					b = _hue[clamp(weapon_get_type(drop.base.front), 0, array_length(_hue) - 1)],
					_max = 256,
					_diff = abs(a - b) % _max;
					
				if(_diff > _max / 2) _diff -= _max;
					
				image_blend = merge_color(
					make_color_hsv(
						(min(a, b) + (_diff / 2) + _max) % _max,
						255,
						255
					),
					c_white,
					0.5
				);
			}
			else{
				image_blend = merge_color(
					make_color_hsv(
						_hue[clamp(weapon_get_type(drop), 0, array_length(_hue) - 1)],
						255,
						255
					),
					c_white,
					0.2
				);
			}
			
			 // Cursed:
			if(curse){
				image_blend = merge_color(image_blend, make_color_rgb(255, 0, 255), 0.5);
			}
			break;
	}
	
	with(pickup_indicator) text = `${other.text}#@s${other.desc}`;
	
#define ChestShop_step
	wave += current_time_scale;
	
	 // Setup:
	if(setup) ChestShop_setup();

	 // Shine Delay:
	if(shine && image_index < 1){
		image_index += image_speed_raw * (random(shine_speed) - 1);
	}

	 // Particles:
	if(instance_exists(creator) && chance_ct(1, 8 * ((open > 0) ? 1 : open_state))){
		var _x = creator.x,
			_y = creator.y,
			l = point_distance(_x, _y, x, y),
			d = point_direction(_x, _y, x, y) + orandom(8);

		if(open > 0) l = random(l);
		else l = random_range(l * (1 - open_state), l);

		with(instance_create(_x + lengthdir_x(l, d) + orandom(4), _y + lengthdir_y(l, d) + orandom(4), BulletHit)){
			motion_add(d + choose(0, 180), random(0.5));
			sprite_index = sprLightning;
			image_blend = other.image_blend;
			image_alpha = 1.5 * (l / point_distance(_x, _y, other.x, other.y)) * random(abs(other.image_alpha));
			image_angle = random(360);
			depth = other.depth - 1;
		}
		
		 // Curse:
		if(curse && chance(1, 5)){
			instance_create(_x + lengthdir_x(l, d) + orandom(4), _y + lengthdir_x(l, d) + orandom(4), Curse);
		}
	}

	 // Open for Business:
	var _pickup = pickup_indicator;
	if(instance_exists(_pickup)) _pickup.visible = (open > 0);
	if(open > 0){
		open_state += (1 - open_state) * 0.15 * current_time_scale;
		
		 // No Customers:
		if(!instance_exists(Player) && open_state >= 1){
			open = 0;
		}

		 // Take Item:
		if(instance_exists(_pickup)){
			var p = player_find(_pickup.pick);
			if(instance_exists(p)){
				var _x = x,
					_y = y,
					_num = num,
					_numDec = 1;
					
				 // Spawn From ChestOpen:
				if(instance_exists(creator)){
					_x = creator.x;
					_y = creator.y - 4;
				}
				
				 // Ambidextrous:
				if(type == ChestShop_wep){
					_num += ultra_get("steroids", 1);
				}
				
				while(_num > 0){
					_numDec = 1;
					switch(type){
						case ChestShop_basic:
							switch(drop){
								case "ammo":
									instance_create(_x + orandom(2), _y + orandom(2), AmmoPickup);
									break;
									
								case "health":
									instance_create(_x + orandom(2), _y + orandom(2), HPPickup);
									break;
									
								case "rads":
									_numDec = _num;
									with(rad_drop(_x, _y, _num, random(360), 4)){
										depth--;
									}
									break;
									
								case "ammo_chest":
									instance_create(_x, _y - 2, AmmoChest);
									repeat(3) scrFX(_x, _y, [90 + orandom(60), 4], Dust);
									instance_create(_x, _y, FXChestOpen);
									sound_play_pitchvol(sndChest, 0.6 + random(0.2), 3);
									break;
									
								case "health_chest":
									instance_create(_x, _y - 2, HealthChest);
									repeat(3) scrFX(_x, _y, [90 + orandom(60), 4], Dust);
									instance_create(_x, _y, FXChestOpen);
									sound_play_pitchvol(sndHealthChest, 0.8 + random(0.2), 1.5);
									break;
									
								case "rads_chest":
									with(instance_create(_x, _y - 6, RadChest)){
										spr_idle = sprRadChestBig;
										spr_hurt = sprRadChestBigHurt;
										spr_dead = sprRadChestBigDead;
										instance_create(x, y, ExploderExplo);
									}
									sound_play_pitch(sndRadMaggotDie, 0.6 + random(0.2));
									break;
									
								case "ammo_bonus":
									with(obj_create(_x, _y, "OverstockPickup")) pull_delay = 0;
									instance_create(_x, _y, GunWarrantEmpty);
									break;
									
								case "health_bonus":
									with(obj_create(_x, _y, "OverhealPickup")) pull_delay = 0;
								    instance_create(_x, _y, GunWarrantEmpty);
								    break;
								    
								case "rogue":
									with(instance_create(_x + orandom(2), _y + orandom(2), RoguePickup)){
										motion_add(point_direction(x, y, p.x, p.y), 3);
									}
									break;
									
								case "parrot":
									_numDec = _num;
									with(obj_create(_x, _y, "ParrotChester")){
										num = _num;
									}
									break;
									
								case "infammo":
									_numDec = _num;
									with(p){
										infammo = _num;
										reload = max(reload, 1);
									}
									break;
									
								case "spirit":
									obj_create(_x, _y, "SpiritPickup");
									instance_create(_x, _y, ImpactWrists);
									break;
									
								case "bone":
									with(instance_create(_x, _y, WepPickup)){
										motion_set(point_direction(x, y, p.x, p.y) + orandom(8), 4);
										wep = "crabbone";
										ammo = true;
									}
									instance_create(_x, _y, Dust);
									sound_play_pitchvol(sndBloodGamble, 0.8, 1);
									break;
									
								case "bones":
									_numDec = ((_num > 10) ? 10 : 1);
									with(obj_create(_x, _y, ((_num > 10) ? "BoneBigPickup" : "BonePickup"))){
										motion_set(random(360), 3 + random(1));
									}
									break;
									
								case "soda":
									with(instance_create(_x, _y, WepPickup)){
										motion_set(point_direction(x, y, p.x, p.y) + orandom(8), 5);
										wep = other.soda;
										ammo = true;
									}
									repeat(16) with(instance_create(_x, _y, Shell)){
										sprite_index = sprSodaCan;
										image_index = irandom(image_number - 1);
										image_speed = 0;
										depth = -1;
										motion_add(random(360), 2 + random(3));
									}
									sound_play_pitch(sndSodaMachineBreak, 1 + orandom(0.3));
									break;
									
								case "turret":
									with(instance_create(_x, _y - 4, Turret)){
										x = xstart;
										y = ystart;
										maxhealth *= 2;
										my_health = maxhealth;
										depth = -3;
										
										with(charm_instance(id, true)){
											time = 900;
											kill = true;
										}
									}
									break;
							}
							
							 // Effects:
							instance_create(_x, _y, WepSwap);
							sound_play_pitchvol(sndGunGun,    1.2 + random(0.4), 0.5);
							sound_play_pitchvol(sndAmmoChest, 0.5 + random(0.2), 0.8);
							break;
	
						case ChestShop_wep:
							with(instance_create(_x, _y, WepPickup)){
								motion_set(point_direction(x, y, p.x, p.y) + orandom(8), 5);
								wep = other.drop;
								curse = other.curse;
								ammo = true;
								roll = true;
							}
							
							 // Effects:
							sound_play(weapon_get_swap(drop));
							sound_play_pitchvol(sndGunGun,           0.8 + random(0.4), 0.6);
							sound_play_pitchvol(sndPlasmaBigExplode, 0.6 + random(0.2), 0.8);
							if(curse){
								sound_play_pitchvol(sndCursedPickup, 1 + orandom(0.2), 1.4);
							}
							instance_create(_x, _y, GunGun);
							break;
					}
					_num -= _numDec;
				}

				instance_create(p.x, p.y, PopupText).text = text;
				instance_create(p.x, p.y, PopupText).text = desc;

				 // Sounds:
			    sound_play_pitchvol(sndGammaGutsProc, 1.4 + random(0.1), 0.6);

				 // Remove other options:
				with(instances_matching(instances_matching(object_index, "name", name), "creator", creator)){
					if(--open <= 0) open_state += random(1/3);
				}
				open_state = 3/4;
				open = 0;
				
				 // Crown Time:
				if(crown_current == "crime"){
					with(instances_matching(Crown, "ntte_crown", "crime")){
						enemy_time = 30;
						enemies += (1 + GameCont.loops) + irandom(min(3, GameCont.hard - 1));
					}
				}
			}
		}
	}
	
	 // Close Up Shop:
	else{
		open_state -= 0.04 * current_time_scale;
		if(open_state <= 0){
			instance_destroy();
		}
	}
	
#define ChestShop_draw
	image_alpha = abs(image_alpha);
	
	var _openState = clamp(open_state, 0, 1),
		_spr = sprite_index,
		_img = image_index,
		_xsc = image_xscale * max((open > 0) * 0.8, _openState),
		_ysc = image_yscale * max((open > 0) * 0.8, _openState),
		_ang = image_angle + (8 * sin(wave / 12)),
		_col = merge_color(c_black, image_blend, _openState),
		_alp = image_alpha,
		_x = x,
		_y = y;
		
	if(type == ChestShop_basic && instance_exists(creator) && x < creator.x){
		_xsc *= -1;
	}
	
	 // Projector Beam:
	if(instance_exists(creator)){
		var	_sx = creator.x,
			_sy = creator.y,
			d = point_direction(_sx, _sy, _x, _y);
			
		//d = angle_lerp(d, 90, 1 - clamp(open_state, 0, 1));
		
		var	w = point_distance(_sx, _sy, _x, _y) * ((open > 0) ? _openState : min(_openState * 3, 1)),
			h = ((sqrt(sqr(sprite_get_width(_spr) * image_xscale * dsin(d)) + sqr(sprite_get_height(_spr) * image_yscale * dcos(d))) * 2/3) + random(2)) * max(0, (_openState - 0.5) * 2),
			_x1 = _sx + lengthdir_x(0.5, d),
			_y1 = _sy + lengthdir_y(1, d),
			_x2 = _sx + lengthdir_x(w, d) + lengthdir_x(h / 2, d - 90),
			_y2 = _sy + lengthdir_y(w, d) + lengthdir_y(h / 2, d - 90),
			_x3 = _sx + lengthdir_x(w, d) - lengthdir_x(h / 2, d - 90),
			_y3 = _sy + lengthdir_y(w, d) - lengthdir_y(h / 2, d - 90);
			
		if(type == ChestShop_wep){
			_y2 = max(_y + 2, _y2);
			_y3 = max(_y + 2, _y3);
		}
		
		_x = _sx + lengthdir_x(w, d);
		_y = _sy + lengthdir_y(w, d);
		
		draw_set_blend_mode(bm_add);
		draw_set_color(merge_color(_col, c_blue, 0.4));
		
		 // Main:
		draw_primitive_begin(pr_trianglestrip);
		
		draw_set_alpha(_alp);
		draw_vertex(_x1, _y1);
		draw_set_alpha(_alp / 8);
		draw_vertex(_x2, _y2);
		draw_vertex(_x3, _y3);
		
		draw_primitive_end();
		
		 // Side Lines:
		draw_primitive_begin(pr_linestrip);
		
		draw_set_alpha(_alp / 3);
		draw_vertex(_x2, _y2);
		draw_set_alpha(0);
		draw_vertex(_x1, _y1);
		draw_set_alpha(_alp / 3);
		draw_vertex(_x3, _y3);
		
		draw_primitive_end();
		
		draw_set_alpha(1);
		draw_set_blend_mode(bm_normal);
	}
	
	 // Projected Object:
	_x -= ((sprite_get_width(_spr) / 2) - sprite_get_xoffset(_spr)) * _xsc;
	_y += sin(wave / 20);
	
	draw_set_color_write_enable(true, true, false, true);
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
	draw_set_color_write_enable(true, true, true, true);
	
	draw_set_blend_mode_ext(bm_src_alpha, bm_one);
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, merge_color(_col, c_black, 0.5 + (0.1 * sin(wave / 8))), image_alpha * 1.5);
	draw_set_blend_mode(bm_normal);
	
	
	image_alpha = -abs(image_alpha);


#define CursedAmmoChest_create(_x, _y)
	with(obj_create(_x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.CursedAmmoChest;
		spr_dead = spr.CursedAmmoChestOpen;
		spr_shadow_y = -1;
		
		 // Sound:
		snd_open = sndAmmoChest;
		
		 // Vars:
		num = 10;
		
		 // Get Loaded:
		if(ultra_get("steroids", 2)){
			sprite_index = spr.CursedAmmoChestSteroids;
			spr_dead = spr.CursedAmmoChestSteroidsOpen;
			num *= 2;
		}
		
		 // Events:
		on_step = script_ref_create(CursedAmmoChest_step);
		on_open = script_ref_create(CursedAmmoChest_open);
		
		return id;
	}

#define CursedAmmoChest_step
	if(chance_ct(1, 12)){
		with(instance_create(x + orandom(4), y - 2 + orandom(4), Curse)){
			depth = other.depth - 1;
		}
	}

#define CursedAmmoChest_open
	sound_play(sndCursedChest);
	instance_create(x, y, PortalClear);
	instance_create(x, y, ReviveFX);
	repeat(num){
		with(obj_create(x + orandom(4), y + orandom(4), "BackpackPickup")){
			target = instance_create(x, y, AmmoPickup);
			with(target){
				sprite_index = sprCursedAmmo;
				cursed = true;
				num = 1.5;
				
				 // Shorten Timer:
				alarm0 = 120 + random(30);
				alarm0 /= 1 + (0.2 * GameCont.loops);
				if(crown_current == crwn_haste) alarm0 /= 3;
			}
			
			 // Spread Out:
			var s = random_range(1.5, 2);
			speed *= s;
			zspeed *= s - 0.5;

			 // Effects:
			with(instance_create(x, y, Curse)){
				depth = other.depth - 1;
				motion_add(other.direction, random(s));
			}
			
			event_perform(ev_step, ev_step_end);
		}
	}


#define CursedMimic_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle = spr.CursedMimicIdle;
		spr_walk = spr.CursedMimicFire;
		spr_hurt = spr.CursedMimicHurt;
		spr_dead = spr.CursedMimicDead;
		spr_chrg = spr.CursedMimicTell;
		spr_shadow = shd24;
		hitid = [spr.CursedMimicFire, "CURSED MIMIC"];
		
		 // Sound:
		snd_hurt = sndMimicHurt;
		snd_dead = sndMimicDead;
		snd_mele = sndMimicMelee;
		snd_tell = sndMimicSlurp;
		
		 // Vars:
		mask_index = -1;
		maxhealth = 12;
		raddrop = 16;
		size = 1;
		maxspeed = 2;
		meleedamage = 4;
		num = 4;
		
		 // Alarms:
		alarm1 = irandom_range(90, 240);
		
		return id;
	}
	
#define CursedMimic_step
	if(speed > maxspeed) speed = maxspeed;
	
	 // Animate:
	if(sprite_index == spr_chrg && anim_end){
		sprite_index = spr_idle;
	}
	else if(sprite_index == spr_hurt && in_distance(Player, 48)){
		sprite_index = spr_walk;
	}
	
	 // FX:
	if(chance_ct(1, 12)){
		with(instance_create(x + orandom(4), y - 2 + orandom(4), Curse)){
			depth = other.depth - 1;
		}
	}
	
	 // Melee Curse:
	with(instances_matching(Player, "lasthit", hitid)){
		if(curse < 1){
			curse++;
			sound_play(sndBigCursedChest);
		}
		lasthit = array_clone(lasthit);
	}
	
#define CursedMimic_alrm1
	alarm1 = irandom_range(90, 240);
	
	sprite_index = spr_chrg;
	image_index = 0;
	
	sound_play_hit(snd_tell, 0.1);
	
#define CursedMimic_death
	sound_play_hit(sndCursedChest, 0.1);
	
	 // Pickups:
	var _objMin = GameObject.id;
	repeat(num) pickup_drop(200, 0);
	
	 // Make Dropped Ammo Cursed:
	with(instances_matching_lt(instances_matching_gt(AmmoPickup, "id", _objMin), "cursed", 1)){
		sprite_index = sprCursedAmmo;
		cursed = true;
		num = 1 + (0.5 * cursed);
		alarm0 = (200 + random(30)) / (1 + (2 * cursed));
		
		 // Spread Out:
		with(obj_create(x, y, "BackpackPickup")){
			target = other;
			var s = random_range(1, 1.5);
			speed *= s;
			zspeed *= s - 0.5;
		}
	}


#define CustomChest_create(_x, _y)
    with(instance_create(_x, _y, chestprop)){
         // Visual:
        sprite_index = sprAmmoChest;
        spr_dead = sprAmmoChestOpen;

         // Sound:
        snd_open = sndAmmoChest;
        
         // Vars:
        nochest = 0; // Adds to GameCont.nochest if not grabbed

		 // Events:
        on_step = ["", "", ""];
        on_open = ["", "", ""];

        return id;
    }

#define CustomChest_step
     // Call Chest Step Event:
    var e = on_step;
    if(mod_script_exists(e[0], e[1], e[2])){
        mod_script_call(e[0], e[1], e[2]);
    }

     // Open Chest:
    var c = [Player, PortalShock];
    for(var i = 0; i < array_length(c); i++) if(place_meeting(x, y, c[i])){
        with(instance_nearest(x, y, c[i])) with(other){
             // Hatred:
            if(crown_current == crwn_hatred){
            	repeat(16) with(instance_create(x, y, Rad)){
            		motion_add(random(360), random_range(2, 6));
            	}
	            if(instance_is(other, Player)){
	            	projectile_hit_raw(other, 1, true);
	            }
            }

             // Call Chest Open Event:
            var e = on_open;
            if(mod_script_exists(e[0], e[1], e[2])){
                mod_script_call(e[0], e[1], e[2]);
            }

             // Effects:
            if(sprite_exists(spr_dead)){
            	with(instance_create(x, y, ChestOpen)) sprite_index = other.spr_dead;
            }
            instance_create(x, y, FXChestOpen);
            sound_play(snd_open);

            instance_destroy();
            exit;
        }
    }
    
     // Increase Big Weapon Chest Chance if Skipped:
    if(nochest != 0 && fork()){
    	var _add = nochest;
    	wait 0;
    	if(!instance_exists(self)){
    		if(instance_exists(GenCont) || instance_exists(LevCont)){
    			GameCont.nochest += _add;
    		}
    	}
    	exit;
    }


#define CustomPickup_create(_x, _y)
    with(instance_create(_x, _y, Pickup)){
         // Visual:
        sprite_index = sprAmmo;
        spr_open = sprSmallChestPickup;
        spr_fade = sprSmallChestFade;
        image_speed = 0.4;
        shine = 0.04;

         // Sound:
        snd_open = sndAmmoPickup;
        snd_fade = sndPickupDisappear;

         // Vars:
        mask_index = mskPickup;
        friction = 0.2;
        blink = 30;
		time = 200 + random(30);
		time_tick = ((crown_current == crwn_haste) ? 3 : 1);
		time_loop = 1/5;
        pull_dis = 40 + (30 * skill_get(mut_plutonium_hunger));
        pull_spd = 6;
        num = 1;

		 // Events:
        on_step = ["", "", ""];
        on_pull = ["", "", ""];
        on_open = ["", "", ""];
        on_fade = ["", "", ""];

        return id;
    }

#define CustomPickup_pull
	return true;

#define CustomPickup_step
	array_push(global.pickup_custom, id); // For step event management

     // Call Chest Step Event:
    var e = on_step;
    if(mod_script_exists(e[0], e[1], e[2])){
        mod_script_call(e[0], e[1], e[2]);
    }

     // Animate:
    if(image_index < 1 && shine > 0){
		image_index += random(shine) - image_speed_raw;
    }

     // Find Nearest Attractable Player:
    var _nearest = noone,
    	_disMax = (instance_exists(Portal) ? 1000000 : pull_dis),
    	e = on_pull;

	if(!mod_script_exists(e[0], e[1], e[2])){
		e = script_ref_create(CustomPickup_pull);
	}

    with(Player){
    	var _dis = point_distance(x, y, other.x, other.y);
    	if(_dis < _disMax){
	    	with(other) if(mod_script_call(e[0], e[1], e[2])){
	    		_disMax = _dis;
	    		_nearest = other;
	    	}
    	}
    }

     // Attraction:
    if(_nearest != noone){
        var l = pull_spd * current_time_scale,
            d = point_direction(x, y, _nearest.x, _nearest.y),
            _x = x + lengthdir_x(l, d),
            _y = y + lengthdir_y(l, d);

        if(place_free(_x, y)) x = _x;
        if(place_free(x, _y)) y = _y;
    }

	 // Pickup Collision:
	if(mask_index == mskPickup && place_meeting(x, y, Pickup)){
		with(instances_meeting(x, y, instances_matching(Pickup, "mask_index", mskPickup))){
			if(place_meeting(x, y, other)){
				if(object_index == AmmoPickup || object_index == HPPickup || object_index == RoguePickup){
					motion_add_ct(point_direction(other.x, other.y, x, y) + orandom(10), 0.8);
				}
				with(other){
					motion_add_ct(point_direction(other.x, other.y, x, y) + orandom(10), 0.8);
				}
			}
		}
	}

     // Wall Collision:
    if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
    	if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
    	if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
    }

     // Fading:
	if(time > 0){
		time -= time_tick * (1 + (time_loop * GameCont.loops)) * current_time_scale;
		if(time <= 0){
			time_tick = 1;
			
			 // Blink:
			if(blink >= 0){
				time = 2;
				blink--;
				visible = !visible;
			}
			
			 // Fade:
			else{
				 // Call Fade Event:
				var e = on_fade;
				if(mod_script_exists(e[0], e[1], e[2])){
					mod_script_call(e[0], e[1], e[2]);
				}
				
				 // Effects:
				if(sprite_exists(spr_fade)){
					with(instance_create(x, y, SmallChestFade)){
						sprite_index = other.spr_fade;
						image_xscale = other.image_xscale;
						image_yscale = other.image_yscale;
						image_angle = other.image_angle;
					}
				}
				sound_play_hit(snd_fade, 0.1);
				
				instance_destroy();
			}
		}
    }


#define HammerHeadPickup_create(_x, _y)
	with(obj_create(_x, _y, "CustomPickup")){
		 // Visual:
		sprite_index = spr.HammerHeadPickup;
		spr_open = -1;
		spr_fade = -1;
		
		 // Sounds:
		snd_open = sndHammerHeadProc;
		snd_fade = sndHammerHeadEnd;
		
		 // Vars:
		mask_index = mskPickup;
		pull_dis = 30 + (30 * skill_get(mut_plutonium_hunger));
		pull_spd = 4;
		pull_delay = 9;
		num = 10 + (crown_current == crwn_haste);
		
		 // Events:
		on_open = script_ref_create(HammerHeadPickup_open);
		on_fade = script_ref_create(HammerHeadPickup_fade);
		
		return id;
	}
	
#define HammerHeadPickup_draw
	draw_sprite(spr.HammerHeadPickupEffect, (current_frame * current_time_scale * 0.4), x, y);
	
#define HammerHeadPickup_open
	 // Determine Handouts:
	var _inst = other;
	if(!instance_is(other, Player)) _inst = Player;

	 // Hammer Time:
	var _num = num;
	with(_inst){
		hammerhead += _num;
		
		 // Text:
		with(instance_create(x, y, PopupText)){
			var _color = c_yellow;
			text = `+${_num} @(color:${_color})HAMMERHEAD`;
		}
	}
	
	sound_play(sndLuckyShotProc);
	sleep(20); // i am karmelyth now
	
	instance_create(x, y, Hammerhead);
	
#define HammerHeadPickup_fade
	instance_create(x, y, Hammerhead);
	repeat(1 + irandom(2)) scrFX(x, y, [random(360), random(2)], Smoke);
	
	sound_play_hit(sndBurn, 0.4);


#define HarpoonPickup_create(_x, _y)
	with(obj_create(_x, _y, "CustomPickup")){
		 // Visual:
        sprite_index = spr.Harpoon;
        image_index = 1;
        spr_open = spr.HarpoonOpen;
        spr_fade = spr.HarpoonFade;
        
		 // Vars:
		mask_index = mskBigRad;
		friction = 0.4;
		time = 90 + random(30);
		pull_spd = 8;
		target = noone;
		
		 // Events:
		on_step = script_ref_create(HarpoonPickup_step);
		on_pull = script_ref_create(HarpoonPickup_pull);
		on_open = script_ref_create(HarpoonPickup_open);
		
		return id;
	}

#define HarpoonPickup_step
	 // Stuck in Target:
    if(instance_exists(target)){
        var _odis = 16,
            _odir = image_angle;

        x = target.x + target.hspeed_raw - lengthdir_x(_odis, _odir);
        y = target.y + target.vspeed_raw - lengthdir_y(_odis, _odir);
        if("z" in target){
        	if(target.object_index == RavenFly || target.object_index == LilHunterFly){
        		y += target.z;
        	}
        	else y -= target.z;
        }
        xprevious = x;
        yprevious = y;

        if(!target.visible) target = noone;
    }

#define HarpoonPickup_pull
	if(instance_exists(target)){ // Stop Sticking
		if(place_meeting(x, y, Wall)){
			x = target.x;
			y = target.y;
			xprevious = x;
			yprevious = y;
		}
		target = noone;
	}
	return (speed <= 0);

#define HarpoonPickup_open
	 // +1 Bolt Ammo:
	var _inst = noone,
		_type = 3,
		_num = num;

	if(instance_is(other, Player)) _inst = other;
	else _inst = Player;

	with(_inst){
        ammo[_type] = min(ammo[_type] + _num, typ_amax[_type]);
        with(instance_create(x, y, PopupText)){
        	text = `+${_num} ${other.typ_name[_type]}`;
        	target = other.index;
        }
	}


#define OverhealPickup_create(_x, _y)
    var _skill = skill_get(mut_second_stomach);
	with(obj_create(_x, _y, "CustomPickup")){
		 // Visuals:
		sprite_index = spr.OverhealPickup;
		spr_open = -1;
		spr_fade = -1;

		 // Sounds:
		snd_open = (_skill ? sndHPPickupBig : sndHPPickup);
		snd_fade = sndPickupDisappear;

		 // Vars:
		mask_index = mskPickup;
		pull_dis = 30 + (30 * skill_get(mut_plutonium_hunger));
		pull_spd = 4;
		pull_delay = 9;
		num = (2 * (1 + _skill)) + (crown_current == crwn_haste);
		wave = random(90);
		
		 // Events:
		on_step = script_ref_create(BonusPickup_step);
		on_pull = script_ref_create(BonusPickup_pull);
		on_open = script_ref_create(OverhealPickup_open);
		on_fade = script_ref_create(BonusPickup_fade);
		
		return id;	
	}
	
#define OverhealPickup_open
	 // Determine Handouts:
	var _inst = other;
	if(!instance_is(other, Player)) _inst = Player;

	 // Bonus HP:
    var _num = num,
    	_max = 8;

	with(_inst){
		my_health_bonus = min(_max, variable_instance_get(id, "my_health_bonus", 0) + _num);
		my_health_bonus_hold = my_health;

		 // Effects:
		with(instance_create(x, y, PopupText)){
			if(other.my_health_bonus < _max){
				text = `+${_num}`;
			}
			else{
				text = "MAX";
			}
			text += ` @5(${spr.BonusText}:-0.3) HP`;
		}
		with(instance_create(x, y, HealFX)){
			sprite_index = (skill_get(mut_second_stomach) ? spr.OverhealBigFX : spr.OverhealFX);
			depth = other.depth - 1;
		}
	}

	 // Effects:
	sound_play_pitchvol(sndRogueCanister, 1.3, 0.7);
	BonusPickup_open();


#define OverstockPickup_create(_x, _y)
	with(obj_create(_x, _y, "CustomPickup")){
		 // Visuals:
		sprite_index = spr.OverstockPickup;
		spr_open = -1;
		spr_fade = -1;

		 // Sounds:
		snd_open = sndAmmoPickup;
		snd_fade = sndPickupDisappear;

		 // Vars:
		mask_index = mskPickup;
		pull_dis = 30 + (30 * skill_get(mut_plutonium_hunger));
		pull_spd = 4;
		pull_delay = 9;
		num = 24 + (crown_current == crwn_haste);
		wave = random(90);

		 // Events:
		on_step = script_ref_create(BonusPickup_step);
		on_pull = script_ref_create(BonusPickup_pull);
		on_open = script_ref_create(OverstockPickup_open);
		on_fade = script_ref_create(BonusPickup_fade);
		
		return id;	
	}

#define OverstockPickup_open
	 // Determine Handouts:
	var _inst = other;
	if(!instance_is(other, Player)) _inst = Player;

	 // Bonus Ammo:
	var _num = num;
	with(_inst){
		ammo_bonus = variable_instance_get(id, "ammo_bonus", 0) + _num;

		 // Text:
		with(instance_create(x, y, PopupText)){
			text = `+${_num} @5(${spr.BonusText}:-0.3) AMMO`;
		}
	}
	
	 // Effects:
	sound_play_pitchvol(sndRogueCanister, 0.7, 0.7);
	BonusPickup_open();


#define BonusPickup_step
	if(pull_delay > 0){
		pull_delay -= current_time_scale;
	}

	 // FX:
	wave += current_time_scale;
	if(((wave % 30) < current_time_scale || pull_delay > 0) && chance(1, max(2, pull_delay))){
		with(scrFX([x, 4], [y, 4], 0, FireFly)){
			sprite_index = spr.OverstockFX;
			depth = other.depth - 1;
		}
	}

#define BonusPickup_pull
	if(pull_delay <= 0){
		 // Pull FX:
		if(point_distance(x, y, other.x, other.y) < pull_dis || instance_exists(Portal)){
			if(chance_ct(1, 2)){
				with(scrFX([x, 4], [y, 4], 0, FireFly)){
					sprite_index = spr.OverstockFX;
					depth = other.depth - 1;
					image_index = 1;
				}
			}
		}
	
		return true;
	}
	return false;

#define BonusPickup_open
	sound_play_pitchvol(sndRogueRifle, 1.5, 1);
	with(instance_create(x, y, SmallChestPickup)){
		image_blend = c_aqua;//make_color_rgb(26, 23, 38);
	}

#define BonusPickup_fade
	with(instance_create(x, y, SmallChestFade)){
		image_blend = make_color_rgb(26, 23, 38);
	}
	

#define BuriedVaultChest_create(_x, _y)
	with(obj_create(_x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.BuriedVaultChest;
		spr_dead = spr.BuriedVaultChestOpen;
		spr_shadow = -1;
		
		 // Sound:
		snd_open = sndBigWeaponChest;
		
		 // Vars:
		num = 3 + skill_get(mut_open_mind);
		
		 // Events:
		on_open = script_ref_create(BuriedVaultChest_open);
		
		return id;
	}
	
#define BuriedVaultChest_open
	 // Important:
	if(instance_is(other, Player)){
		sound_play(other.snd_chst);
	}
	
	 // Loot:
	var _ang = random(360);
	for(var d = _ang; d < _ang + 360; d += (360 / num)){
		with(obj_create(x, y, "BackpackPickup")){
			zfriction = 0.6;
	        zspeed = random_range(3, 4);
			speed = 1.5 + orandom(0.2);
			direction = d;
			
			var _pool = [AmmoChest, WeaponChest, HealthChest, RadChest];
			if(chance(1, 2)) array_push(_pool, "Backpack");
			
			switch(crown_current){
				case crwn_love:
					for(var i = 0; i < array_length(_pool); i++){
						_pool[i] = AmmoChest;
					}
					break;
					
				case crwn_life:
					for(var i = 0; i < array_length(_pool); i++){
						if(_pool[i] == RadChest && chance(2, 3)){
							_pool[i] = HealthChest;
						}
					}
					break;
			}
			
			target = obj_create(x, y, _pool[irandom(array_length(_pool) - 1)]);
			
			event_perform(ev_step, ev_step_end);
		}
	}
	
	 // Blast Off:
	sound_play_pitch(sndStatueXP, 0.5 + orandom(0.1));
	sound_play_pitchvol(sndExplosion, 1.4 + random(0.3), 0.8);
	with(instance_create(x, y - 2, FXChestOpen)){
		sprite_index = sprMutant6Dead;
		image_index = 9;
		image_xscale *= 0.75;
		image_yscale = image_xscale;
		image_blend = make_color_rgb(random_range(120, 190), 255, 8);
	}
	with(obj_create(x, y - 2, "BuriedVaultChestDebris")){
		direction = _ang + ((360 / other.num) * random_range(1/3, 2/3));
	}
	
	
#define BuriedVaultChestDebris_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.BuriedVaultChestDebris;
		image_speed = 0.4 * choose(-1, 1);
		depth = -8;
		
		 // Vars:
		friction = 0.15;
		direction = random(360);
		speed = random_range(1, 2);
		z = 0;
		zspeed = 10;
		zfriction = 1;
		rotspeed = orandom(30);
		land = false;
		
		return id;
	}
	
#define BuriedVaultChestDebris_step
    z += zspeed * current_time_scale;
    zspeed -= zfriction * current_time_scale;
	
	 // Spinny:
	if(zspeed > 0){
		image_angle += rotspeed * current_time_scale;
		image_angle = (image_angle + 360) % 360;
	}
	else{
		image_angle -= image_angle * 0.2 * current_time_scale;
	}
	
	 // Land:
	if(z <= 0 || z <= 8){
		var _land = false;
		
		if(position_meeting(x, y + 8, Wall) || place_meeting(x, y + 8, TopSmall)){
			z = 8;
			depth = -6 - (y / 10000);
			_land = true;
		}
		else if(z <= 0){
			z = 0;
			depth = 0;
			_land = true;
			
			 // Collision:
			if(position_meeting(x, y - 8, Wall)){
				y += current_time_scale;
				depth = -1;
			}
			if(position_meeting(x + hspeed_raw, y + 8 + vspeed_raw, Wall)){
				if(position_meeting(x + hspeed_raw, y + 8, Wall)) hspeed_raw = 0;
				if(position_meeting(x, y + 8 + vspeed_raw, Wall)) vspeed_raw = 0;
			}
		}
		
		if(_land){
			if(abs(zspeed) > zfriction){
				repeat(3) with(scrFX(x, y - z, 2, Dust)){
					depth = other.depth;
				}
			}
			image_index = 0;
			image_angle = 0;
			zspeed = 0;
		}
	}
	else{
		depth = -8;
		speed += friction_raw;
	}
	
#define BuriedVaultChestDebris_draw
	image_alpha = abs(image_alpha);
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	image_alpha *= -1;
	
	
#define BuriedVaultPedestal_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.BuriedVaultChestBase;
		image_speed = 0.4;
		depth = 2;
		
		 // Vars:
		mask_index = mskSalamander;
		spawn = irandom_range(1, 2) + GameCont.vaults;
		spawn_time = 0;
		spawn_inst = [];
		
		 // Main Loot:
		var _pool = [];
			repeat(4) array_push(_pool, "BuriedVaultChest");
			repeat(1) array_push(_pool, ((crown_current == crwn_love) ? AmmoChest : BigWeaponChest));
			repeat(1) array_push(_pool, ((crown_current == crwn_love) ? AmmoChest : RadChest));
		
		if(!instance_exists(ProtoChest))
			repeat(1) array_push(_pool, ProtoChest);
		
		if(GameCont.subarea == 2) // (proto statues do not support non-subarea of 2)
			repeat(2) array_push(_pool, ProtoStatue);
		
		if(chance(1, 5))
			repeat(1) array_push(_pool, EnemyHorror);
			
		target = obj_create(x, y + 2, _pool[irandom(array_length(_pool) - 1)]);
		if(!instance_exists(target)){
			with(instances_matching_gt(chestprop, "id", target)){
				other.target = id;
			}
		}
		with(target){
			x = xstart;
			y = ystart;
			switch(object_index){
				case EnemyHorror:
					instance_create(x, y, PortalShock);
					other.spawn = 0;
					break;
					
				case ProtoChest:
					 // Cool Wep:
					if(wep == wep_rusty_revolver){
						sprite_index = spr.ProtoChestMerge;
						var _part = wep_merge_decide(0, GameCont.hard + 4);
						wep = wep_merge(_part[0], _part[1]);
					}
					break;
					
				case ProtoStatue:
					y -= 12;
					spr_shadow = -1;
					with(instances_matching_gt(Bandit, "id", id)){
						instance_delete(id);
					}
					break;
					
				case RadChest:
					y -= 4;
					spr_idle = sprRadChestBig;
					spr_hurt = sprRadChestBigHurt;
					spr_dead = sprRadChestBigDead;
					break;
			}
		}
		
		 // Extra Loot:
		var	_rad = (instance_is(target, RadChest) ? 30 : 15),
			_num = irandom_range(1, 2) + floor(_rad / 15) + skill_get(mut_open_mind),
			_ang = random(360);
			
		if(_num > 0) for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
			var	l = random_range(16, 40),
				d = _dir + orandom((360 / _num) * 0.4),
				o = RadChest;
				
			switch(crown_current){
				case crwn_love:
					o = AmmoChest;
					break;
					
				case crwn_life:
					if(chance(2, 3)) o = HealthChest;
					break;
			}
			
			with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), o)){
				if(instance_is(self, RadChest)){
					if(chance(1, 6)){
						spr_idle = sprRadChestBig;
						spr_hurt = sprRadChestBigHurt;
						spr_dead = sprRadChestBigDead;
					}
					else{
						spr_idle = sprRadChest;
						spr_hurt = sprRadChestHurt;
						spr_dead = sprRadChestCorpse;
					}
				}
			}
		}
		rad_drop(x, y, _rad, random(360), 0);
		
		return id;
	}
	
#define BuriedVaultPedestal_step
	if(image_speed != 0){
		 // Holding Loot:
		if(
			place_meeting(x, y, target)
			&&
			(!instance_is(target, ProtoChest) || target.sprite_index != sprProtoChestOpen)
			&&
			(!instance_is(target, ProtoStatue) || target.my_health >= target.maxhealth * 0.7)
		){
			image_index = 0;
			
			 // Hold Chest:
			if(variable_instance_get(target, "name") == "BuriedVaultChest"){
				target.x = x;
				target.y = y;
				target.speed = 0;
			}
		}
		
		 // Loot Taken:
		else if(anim_end){
			image_speed = 0;
			image_index = image_number - 1;
		}
	}
	
	 // Guardians:
	else if(spawn > 0){
		if(spawn_time > 0){
			spawn_time -= current_time_scale;
			if(spawn_time <= 0){
				spawn_time = 10;
				spawn--;
				
				sound_play_pitch(sndCrownGuardianAppear, 1 + random(0.4));
				
				var _inst = noone;
				with(instance_random(instance_rectangle_bbox(x - 96, y - 96, x + 96, y + 96, instances_matching_ne(Floor, "id", floor_get(x, y))))){
					_inst = instance_create((bbox_left + bbox_right + 1) / 2, (bbox_top + bbox_bottom + 1) / 2, CrownGuardian);
				}
				with(_inst){
					spr_idle = sprCrownGuardianAppear;
					sprite_index = spr_idle;
					
					 // Just in Case:
					with(instance_create(x, y, PortalClear)){
						sprite_index = other.sprite_index;
						mask_index = other.mask_index;
					}
				}
				
				array_push(spawn_inst, _inst);
			}
		}
		
		 // Begin Spawnage
		else{
			other.spawn_time = 30;
			GameCont.buried_vaults = variable_instance_get(GameCont, "buried_vaults", 0) + 1;
	        portal_poof();
			
			 // Sound/Music:
			sound_play_pitch(sndCrownGuardianDisappear, 0.7 + random(0.2));
			//sound_play_music(mus100b);
	        //with(MusCont) alarm_set(3, -1);
		}
	}
	
	 // Proto Statue Charged:
	if(instance_is(target, ProtoStatue) && target.canim > 0){
		image_index = max(0, (image_number - 1) - (0.5 * target.canim));
		image_speed = 0.4;
	}
	
#define BuriedVaultPedestal_end_step
	 // Music Fix:
	with(instances_matching_le(spawn_inst, "my_health", 0)){
		var m = -1;
		with(MusCont) m = alarm_get(1);
		instance_destroy();
		with(MusCont) alarm_set(1, m);
	}
	
	
#define Pizza_create(_x, _y)
    with(instance_create(_x, _y, HPPickup)){
        sprite_index = sprSlice;
        num = ceil(num / 2);
        return id;
    }


#define PizzaChest_create(_x, _y)
	with(instance_create(_x, _y, HealthChest)){
        sprite_index = choose(sprPizzaChest1, sprPizzaChest2);
        spr_dead = sprPizzaChestOpen;
        num = ceil(num / 2);
        return id;
	}


#define PizzaStack_create(_x, _y)
    with(instance_create(_x, _y, CustomProp)){
         // Visual:
        spr_idle = sprPizzaBox;
        spr_hurt = sprPizzaBoxHurt;
        spr_dead = sprPizzaBoxDead;

         // Sound:
        snd_hurt = sndHitPlant;
        snd_dead = sndPizzaBoxBreak;

         // Vars:
        maxhealth = 4;
        size = 1;
        num = choose(1, 2);

	     // Big luck:
	    if(chance(1, 10)) num = 4;

        return id;
    }

#define PizzaStack_death
     // Big:
    if(num >= 4){
        sound_play_pitch(snd_dead, 0.6);
        snd_dead = -1;
    }

     // +Yum
    repeat(num){
    	obj_create(x + orandom(2 * num), y + orandom(2 * num), "Pizza");
    	instance_create(x + orandom(4), y + orandom(4), Dust);
    }


#define SpiritPickup_create(_x, _y)
    with(obj_create(_x, _y, "CustomPickup")){
         // Visual:
        sprite_index = spr.SpiritPickup;
        spr_open = -1;
        spr_fade = -1;
        halo_sprite = sprStrongSpiritRefill;
        halo_index = 0;
        
         // Sounds:
        snd_open = sndAmmoPickup;
        snd_fade = sndStrongSpiritLost;
        
         // Vars:
        mask_index = mskPickup;
		pull_dis = 30 + (30 * skill_get(mut_plutonium_hunger));
		pull_spd = 4;
		pull_delay = 30;
        wave = random(90);
        time = 90 + random(30);
        num = 1 + (crown_current == crwn_haste); // haste confirmed epic
        
         // Events:
        on_step = script_ref_create(SpiritPickup_step);
        on_pull = script_ref_create(SpiritPickup_pull);
        on_open = script_ref_create(SpiritPickup_open);
        on_fade = script_ref_create(SpiritPickup_fade);
        
         // FX:
        sound_play_pitchvol(sndStrongSpiritGain, 1.4 + random(0.3), 0.7);
        repeat(5) with(scrFX(x, y, 3, Dust)) depth = other.depth;
        
        return id;
    }
   
#define SpiritPickup_step
	if(pull_delay > 0) pull_delay -= current_time_scale;
    wave += current_time_scale;
    
     // Animate Halo:
    if(halo_sprite != sprHalo){
    	halo_index += 0.4 * current_time_scale;
    	if(halo_index > sprite_get_number(halo_sprite) - 1) halo_sprite = sprHalo;
    }

#define SpiritPickup_draw
    for(var i = 0; i < num; i++){
    	draw_sprite(halo_sprite, halo_index, x, (y + 3) + sin(wave * 0.1) - (i * 7));
    }

#define SpiritPickup_open
	var _inst = noone,
		_num = num;

	if(instance_is(other, Player)) _inst = other;
	else _inst = Player;
	
	with(_inst){
		 // Acquire Bonus Spirit:
		if(_num > 0 && "bonus_spirit" in self){
			repeat(_num) array_push(bonus_spirit, bonusSpiritGain);
			sound_play(sndStrongSpiritGain);
			
			with(instance_create(x, y, PopupText)){
				mytext = `+${_num} @yBONUS @wSPIRIT${(_num > 1) ? "S" : ""}`;
				target = other.index;
			}
		}
		
		 // for all the headless chickens in the crowd:
		my_health = max(my_health, 1);
	}
    
     // Effects:
    instance_create(x, y, SmallChestPickup);

#define SpiritPickup_fade
    instance_create(x, y, SmallChestFade);
    for(var i = 0; i < num; i++){
    	instance_create(x, (y + 3) - (i * 7), StrongSpirit);
    }
    
#define SpiritPickup_pull
	return (pull_delay <= 0);

#define scrRestoreSpirit(_inst)
    with(_inst) if(skill_get(mut_strong_spirit) && !canspirit){
		var i = index;
			
		canspirit = true;
		GameCont.canspirit[i] = false;
		with(instance_create(x, y, StrongSpirit)){
			sprite_index = sprStrongSpiritRefill;
			creator = i;
		}
		
		sound_play(sndStrongSpiritGain);
	}


#define SunkenChest_create(_x, _y)
	with(obj_create(_x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.SunkenChest;
		spr_dead = spr.SunkenChestOpen;
		spr_shadow_y = 0;
		
		 // Sounds:
		snd_open = sndGoldChest;
		
		 // Vars:
		num = 2;
		wep = wep_golden_revolver;
		
		 // Decide Weapon:
		if(GameCont.area == "coast"){
			wep = "trident";
		}
		else{
			wep = "merge";
		}
		
		 // Events:
		on_step = script_ref_create(SunkenChest_step);
		on_open = script_ref_create(SunkenChest_open);
		
		return id;
	}
	
#define SunkenChest_step
	 // Shiny:
	if(chance_ct(1, 90)){
		with(instance_create(x + orandom(16), y + orandom(8), CaveSparkle)){
			depth = other.depth - 1;
		}
	}
	
#define SunkenChest_open
	instance_create(x, y, PortalClear);
	
	with(GameCont){
		if("sunkenchests" not in self){
			sunkenchests = 0;
		}
		sunkenchests++;
	}
	
	 // Important:
	if(instance_is(other, Player)){
		sound_play(other.snd_chst);
	}
	
	 // Trident Unlock:
	if(wep == "trident") unlock_call("trident");
	
	 // Weapon:
	var _num = 1 + ultra_get("steroids", 1);
	if(_num > 0) repeat(_num){
		var _wep = wep;
		
		if(_wep == "merge"){
			var _part = mod_script_call("weapon", _wep, "weapon_merge_decide_raw", 0, GameCont.hard, -1, -1, true);
			if(array_length(_part) >= 2){
				_wep = wep_merge(_part[0], _part[1]);
			}
		}
		
		with(instance_create(x, y, WepPickup)){
			wep = _wep;
			ammo = true;
		}
	}
	
	 // Real Loot:
	if(num > 0){
		repeat(num * 10){
			with(obj_create(x, y, "SunkenCoin")){
				motion_add(random(360), 2 + random(2.5));
			}
		}
		
		 // Ammo:
		var _ang = random(360);
		for(var d = _ang; d < _ang + 360; d += (360 / num)){
			with(obj_create(x, y, "BackpackPickup")){
				target = instance_create(x, y, AmmoPickup);
				direction = d;
				speed = random_range(2, 3);
				event_perform(ev_step, ev_step_end);
			}
		}
	}
	
	 // Skealetons:
	if(num + 1 > 0){
		var _ang = random(360);
		for(var d = _ang; d < _ang + 360; d += (360 / (num + 1))){
			with(obj_create(x, y, "SunkenSealSpawn")){
				var	_dis = random_range(40, 80),
					_dir = d + orandom(30);
					
				while(_dis > 0 && !position_meeting(x, y, Wall)){
					var l = min(_dis, 4);
					x += lengthdir_x(l, _dir);
					y += lengthdir_y(l, _dir);
					_dis -= l;
				}
			}
			
			 // Top Bros:
			if(area_get_underwater(GameCont.area)){
				var _spawnX = x,
					_spawnY = y,
					_spawnObj = ((GameCont.area == "trench" || (GameCont.area == 100 && GameCont.lastarea == "trench")) ? Freak : BoneFish),
					_spawnDir = d,
					_spawnDis = random_range(320, 400);
					
				with(instance_nearest(x-8 + lengthdir_x(32, _spawnDir), y-8 + lengthdir_y(32, _spawnDir), TopSmall)){
					_spawnDir = point_direction(other.x, other.y, x + 8, y + 8);
				}
				
				repeat(3){
					with(top_create(_spawnX, _spawnY, _spawnObj, _spawnDir, _spawnDis)){
						jump_time = irandom_range(30, 150);
						
						_spawnX = x;
						_spawnY = y;
						_spawnDir = random(360);
						_spawnDis = -1;
						
						z = 8;
						
						 // Poof:
						with(target) repeat(3){
							with(instance_create(x + orandom(8), y + orandom(8), Dust)){
								depth = other.depth - 1;
							}
						}
					}
				}
				
				sound_play_pitchvol(sndMutant14Turn, 0.2 + random(0.1), 1);
			}
		}
	}
	
	
#define SunkenCoin_create(_x, _y)
	with(obj_create(_x, _y, "CustomPickup")){
		 // Visual:
		sprite_index = (chance(1, 3) ? spr.SunkenCoinBig : spr.SunkenCoin);
		image_angle = random(360);
        spr_open = sprCaveSparkle;
        spr_fade = sprCaveSparkle;
        shine = 0.03;
        
		 // Sound:
		snd_open = sndRadPickup;
		snd_fade = -1;
		
		 // Vars:
		mask_index = mskRad;
		time_loop = 1/4;
        pull_dis = 18 + (12 * skill_get(mut_plutonium_hunger));
        
		 // Events:
		on_pull = script_ref_create(SunkenCoin_pull);
		on_open = script_ref_create(SunkenCoin_open);
		
		return id;
	}
	
#define SunkenCoin_pull
	return (speed <= 0);
	
#define SunkenCoin_open
	if(speed > 0) return true;
	
	
#define SunkenSealSpawn_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		mask_index = mskBandit;
		
		 // Alarms:
		alarm0 = 30 + (10 * array_length(instances_matching(CustomObject, "name", "SunkenSealSpawn")));
		
		return id;
	}
	
#define SunkenSealSpawn_step
	portal_poof();
	
	 // Make Room:
	if(place_meeting(x, y, Wall)){
		with(instances_meeting(x, y, Wall)){
			if(place_meeting(x, y, other)){
				instance_create(x, y, FloorExplo);
				instance_destroy();
			}
		}
	}
	
	 // Unburrowing FX:
	if(chance_ct(1, 2)){
		with(scrFX(x, y + random(4), 1.5, Dust)){
			depth = -4;
			waterbubble = false;
		}
	}
	
#define SunkenSealSpawn_alrm0
	with(obj_create(x, y, "Seal")){
		skeal = !(GameCont.area == "coast" || (GameCont.area == 100 && GameCont.lastarea == "coast"));
		type = choose(1, 2, 3);
	}
	
	 // Sound:
	sound_play_hit_ext(sndBloodGamble, 1.6 + random(0.2), 0.5);
	var s = audio_play_sound(sndSharpTeeth, 0, false);
	audio_sound_pitch(s, 0.6 + random(0.4));
	audio_sound_gain(s, 0.4, 0);
	
	instance_destroy();


#define VaultFlower_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle = spr.VaultFlowerIdle;
		spr_hurt = spr.VaultFlowerHurt;
		spr_dead = spr.VaultFlowerDead;
		
		 // Sounds:
		snd_hurt = sndHitPlant;
		snd_dead = sndMoneyPileBreak;
		
		 // Vars:
		mask_index = mskBigSkull;
		maxhealth = 30;
		size = 2;
		skill = mut_last_wish;
		wilted = global.vFlowerWilted;
		pickup_indicator = noone;
		
		 // Determine Skill:
		if(!wilted){
			if(skill_get(skill) == 0){
				var _skillList = [];
				for(var i = 0; !is_undefined(skill_get_at(i)); i++){
					var s = skill_get_at(i);
					if(s != mut_patience) array_push(_skillList, s);
				}
				
				if(array_length(_skillList) > 0){
					skill = _skillList[irandom(array_length(_skillList) - 1)];
				}
			}
			
			wilted = (skill_get(skill) == 0);
		}
		
		 // Pickup Indicator:
		if(!wilted){
			pickup_indicator = scrPickupIndicator("  REROLL");
			with(pickup_indicator){
				mask_index = mskLast;
				xoff = -8;
				yoff = -10;
				on_meet = script_ref_create(VaultFlower_PickupIndicator_meet);
			}
		}
		
		return id;
	}
	
#define VaultFlower_step
	x = xstart;
	y = ystart;
	
	var _pickup = pickup_indicator;
	
	if(!wilted){
		 // Sprites:
		if(spr_idle == spr.VaultFlowerWiltedIdle) spr_idle = spr.VaultFlowerIdle;
		if(spr_hurt == spr.VaultFlowerWiltedHurt) spr_hurt = spr.VaultFlowerHurt;
		if(spr_dead == spr.VaultFlowerWiltedDead) spr_dead = spr.VaultFlowerDead;
		
		 // Wilt:
		if(global.vFlowerWilted || skill_get(skill) == 0){
			wilted = true;
		}
		
		 // Interact:
		else if(instance_exists(_pickup) && player_is_active(_pickup.pick)){
			global.vFlowerWilted = true;
			
			 // Reroll:
			mod_variable_set("skill", "reroll", "skill", skill);
			skill_set("reroll", true);
			
			 // FX:
			image_index = 0;
			sprite_index = spr.VaultFlowerHurt;
			with(scrAlert(self, skill_get_icon("reroll")[0])){
				snd_flash = sndLevelUp;
				spr_alert = -1;
			}
			for(var a = 0; a < 360; a += (360 / 10)){
				var	l = 8 + (8 * dcos(a * 4)),
					d = a + orandom(60);
					
				with(scrFX(
					x + lengthdir_x(l, d),
					y + lengthdir_y(l, d),
					[90, random_range(0.25, 1.5)],
					"VaultFlowerSparkle"
				)){
					depth = -8;
				}
			}
			/*repeat(8) with(scrFX([x, 16], [y - 4, 16], [90, random(2)], CaveSparkle)){
				depth = -8;
			}*/
			sound_play_pitchvol(sndStatueXP, 0.3, 2);
			with(player_find(_pickup.pick)) sound_play(snd_crwn);
			
			/*if(fork()){
				wilted = true;
				while(button_check(0, "pick")) wait 0;
				if(instance_exists(self)){
					wilted = false;
					with(instances_matching(CustomObject, "name", "AlertIndicator")) if(target == other) instance_destroy();
				}
				exit;
			}*/
		}
		
		 // Effects:
		if(chance_ct(1, 12)){
			with(instance_create(x + orandom(12), (y - 6) + orandom(8), CaveSparkle)){
				depth = other.depth - 1;
			}
		}
		/*if(chance_ct(1, 10)){
			with(scrFX([x, 12], [(y - 4), 8], [90, 0.1], "VaultFlowerSparkle")) depth = other.depth + choose(-1, -1, 1);
		}*/
	}
	
	 // Wilted:
	else{
		maxhealth = min(9, maxhealth);
		my_health = min(my_health, maxhealth);
		
		 // Sprites:
		if(spr_idle == spr.VaultFlowerIdle) spr_idle = spr.VaultFlowerWiltedIdle;
		if(spr_hurt == spr.VaultFlowerHurt) spr_hurt = spr.VaultFlowerWiltedHurt;
		if(spr_dead == spr.VaultFlowerDead) spr_dead = spr.VaultFlowerWiltedDead;
		
		 // Effects:
		if(chance_ct(1, 150)){
			with(scrVaultFlowerDebris(x + orandom(12), (y - 4) + orandom(8), 0, 0)){
				with(scrFX(x, y, [270 + orandom(60), 0.5], Dust)){
					image_blend = make_color_rgb(84, 58, 24);
					image_xscale /= 2;
					image_yscale /= 2;
				}
			}
		}
	}
	
	 // Hurt Effects:
	if(sprite_index == spr_hurt){
		if(image_index >= 1 && image_index < 1 + image_speed_raw){
			scrVaultFlowerDebris(x, y, direction + orandom(random(180)), 2 + random(3.5));
		}
	}
	
	with(_pickup) visible = !other.wilted;

#define VaultFlower_death
	 // Effects:
	for(var d = direction; d < direction + 360; d += (360 / 6)){
		scrFX(x, y, [d + orandom(45), 3], Dust);
		scrVaultFlowerDebris(x, y - 6, d + orandom(45), 4 + random(2));
		repeat(2){
			with(scrVaultFlowerDebris(x, y - 6, d + orandom(45), random(4))){
				vspeed--;
			}
		}
	}
	sound_play_hit_ext(sndPlantSnare, 0.8, 1.5);
	
	 // Secret:
	if(!wilted){
		pet_spawn(x, y, "Orchid");
		
		 // FX:
		repeat(20) with(scrFX(x, (y - 6), [90 + orandom(100), random(4)], "VaultFlowerSparkle")){
			depth = -7;
			friction = 0.1;
			alarm0 = (speed / friction) + random(20);
		}
		sound_play_pitch(sndCrystalPropBreak, 1.2 + random(0.1));
		audio_sound_set_track_position(sound_play_pitchvol(sndUncurse, 0.5, 5), 0.66);
		/*with(instance_create(x, y, BulletHit)){
			sprite_index = sprSlugHit;
			image_speed = 0.25;
			depth = -3;
		}
		audio_sound_set_track_position(sound_play_pitchvol(sndVaultBossWin, 1.75, 0.5), 0.5);*/
	}
	
#define VaultFlower_PickupIndicator_meet
	if(instance_exists(TopCont)){
		script_bind_draw(VaultFlower_PickupIndicator_icon, TopCont.depth, self, other);
	}
	return true;
	
#define VaultFlower_PickupIndicator_icon(_inst, _instMeet)
	with(_instMeet){
		if(player_get_show_prompts(index, player_find_local_nonsync())){
			with(_inst){
				if(nearwep == other.nearwep && "skill" in creator){
					var _icon = skill_get_icon(creator.skill);
					draw_sprite(_icon[0], _icon[1], x - xoff, (y - 13) + yoff);
				}
			}
		}
	}
	instance_destroy();
	
#define scrVaultFlowerDebris(_x, _y, _dir, _spd)
	with(instance_create(_x, _y, Feather)){
		sprite_index = (other.wilted ? spr.VaultFlowerWiltedDebris : spr.VaultFlowerDebris);
		image_index = irandom(image_number - 1);
		image_angle = orandom(30);
		image_speed = 0;
		depth = other.depth - 1;
		direction = _dir;
		speed = _spd;
		rot *= 0.5;
		//alarm0 = 60 + random(30);
		
		return id;
	}
	

#define VaultFlowerSparkle_create(_x, _y)
	with(instance_create(_x, _y, LaserCharge)){
		 // Visual:
		sprite_index = spr.VaultFlowerSparkle;
		image_angle  = random(360);
		image_xscale = 0;
		image_yscale = 0;
		depth = -3;
		
		 // Alarms:
		alarm0 = random_range(10, 45);
		
		 // Grow & Shrink & Spin:
		if(fork()){
			wait 0;
			
			if(instance_exists(self)){
				var	_rot = orandom(4),
					_alarmMax = alarm0,
					_scaleAlarm = 5 + (alarm0 / 3),
					_scaleMax = random_range(1, 1.25);
					
				while(instance_exists(self)){
					image_angle += _rot * current_time_scale;
					
					image_xscale = _scaleMax;
					if(alarm0 > _scaleAlarm){
						image_xscale *= 1 - (abs(alarm0 - _scaleAlarm) / max(1, abs(_alarmMax - _scaleAlarm)));
					}
					else{
						image_xscale *= alarm0 / _scaleAlarm;
					}
					image_yscale = image_xscale;
					
					wait 0;
				}
			}
			
			exit;
		}
		
		return id;
	}
	

/// Mod Events
#define game_start
	 // Special Pickups:
	global.sPickupsMax = 4;
	global.sPickupsInc = 1;
	global.sPickupsNum = 1;
	
	 // Vault Flower:
	global.vFlowerWilted = false;

#define step
    script_bind_step(post_step, 0);
    script_bind_end_step(end_step, 0);
    script_bind_draw(draw_bonus_spirit, -12);
    
    if(DebugLag) trace_time();

	 // Overstock / Bonus Ammo:
	with(instances_matching(instances_matching(instances_matching(instances_matching_gt(Player, "ammo_bonus", 0), "infammo", 0), "visible", true), "can_shoot", 1)){
		var _wep = wep,
			_cost = weapon_get_cost(_wep),
			_type = weapon_get_type(_wep),
			_auto = weapon_get_auto(_wep),
			_internal = (is_object(_wep) && "wep" in _wep && "ammo" in _wep && "cost" in _wep && is_string(_wep.wep)),
			_internalCost = (_internal ? _wep.cost : 0),
			_fireNum = 0;
			
		if(_type != 0){
			if(canfire >= 1){
				if(button_pressed(index, "fire") || (_auto && button_check(index, "fire")) || (!_auto && clicked >= 1)){
					_fireNum = 1;
				}
			}
			
			 // Race-Specific:
			switch(race){
				case "steroids": // Automatic Weapons
					if(_auto >= 0) _auto = true;
					break;
					
				case "venuz": // Pop Pop
					if(canspec && button_pressed(index, "spec")){
						_fireNum = floor(2 * (1 + skill_get(mut_throne_butt)));
					}
					break;
			}
			
			 // Firing:
			if(_fireNum > 0) repeat(_fireNum){
				 // Bonus Ammo:
				var _fire = (ammo[_type] + ammo_bonus >= _cost);
				if(_fire){
					_cost = min(ammo_bonus, _cost);
					ammo[_type] += _cost;
					ammo_bonus -= _cost;
				}
				
				 // Internal Bonus Ammo:
				var _fireInternal = (_fire && _internal && _wep.ammo + ammo_bonus >= _internalCost)
				if(_fireInternal){
					_internalCost = min(ammo_bonus, _internalCost);
					_wep.ammo += _internalCost;
					ammo_bonus -= _internalCost;
				}
				
				 // FX:
				var	_end = (ammo_bonus <= 0);
				if((_fire && _cost > 0) || (_fireInternal && _internalCost > 0) || _end){
					var l = 12,
						d = gunangle,
						_x = x + hspeed + lengthdir_x(l, d),
						_y = y + vspeed + lengthdir_y(l, d),
						_load = weapon_get_load(_wep);
						
					sound_play_pitchvol(
						choose(sndGruntFire, sndRogueRifle),
						(0.6 + random(1)) / clamp(_load / 10, 1, 3),
						0.8 + (0.2 * (_load / 20))
					);
					
					with(instance_create(_x, _y, BulletHit)){
						sprite_index = sprImpactWrists;
						image_xscale = 0.4 + (0.1 * ceil(_load / 15));
						image_blend = merge_color(c_aqua, choose(c_white, c_blue), random(0.4));
						depth = -4;
						
						 // Normal:
						if(!_end){
							image_index = max(2 - image_speed, 3 - (_load / 30));
							image_angle = 0;
							
							 // Fast Reload Spacing Out:
							friction = 0.4;
							motion_add(random(360), min(2, random(6 / _load)));
						}
						
						 // End:
						else{
							image_xscale *= 1.5;
							image_speed = 0.35;
							sound_play_pitchvol(sndLaserCannon, 1.4 + random(0.2), 0.8);
							sound_play_pitchvol(sndEmpty,       0.8 + random(0.1), 1);
						}
						
						image_xscale = min(1.2, image_xscale);
						image_yscale = image_xscale;
					}
				}
			}
		}
	}
    
     // Bonus Spirits:
    with(Player){
    	if("bonus_spirit" not in self){
    		bonus_spirit = [];
    		bonus_spirit_bend = 0;
    		bonus_spirit_bend_spd = 0;
    	}
    	
    	 // Sort Spirits:
    	var _spirits = [[], []];
    	with(bonus_spirit){
    		var o = self;
    		array_push(_spirits[active], o);
    	}

		 // Grant Grace:
    	if(array_length(bonus_spirit) > 0){
	    	if(my_health <= 0){
	    		if(spiriteffect <= 0){
		    		var _doSpirit = false;
		    		
		    		 // Natural Spirit Depletion:
			    	if(skill_get(mut_strong_spirit) && canspirit){
			    		with(instances_matching(StrongSpirit, "creator", index)) instance_destroy();
			    		canspirit = false;
			    		GameCont.canspirit[index] = false;
			    		
			    		array_push(_spirits[0], bonusSpiritLose);
			    		
			    		_doSpirit = true;
			    	}
			    	
			    	 // Bonus Spirit Depletion:
			    	else if(array_length(_spirits[1]) > 0){
			    		with(_spirits[1]){
			    			sprite = mskNone;
			    			break;
			    		}
			    		array_push(_spirits[0], bonusSpiritLose);
			    		
			    		_doSpirit = true;
			    	}
			    	
			    	 // Perform Spirit Effect:
			    	if(_doSpirit){
			    		my_health = 1;
			    		spiriteffect = 4;
			    		sound_play(sndStrongSpiritLost);
			    	}
			    }
			    
			     // Fuck Explosions:
			    else my_health = 1;
	    	}
	    }
	    
	     // Animate and Cull Spirits:
	    var a = [],
	    	_animSpeed = 0.4 * current_time_scale;
	    	
	    for(var i = 1; i >= 0; i--){
	    	with(_spirits[i]){
	    		
	    		 // you may pass:
	    		var o = self;
	    		if(sprite != mskNone){
		    		index += _animSpeed;
		    		if(index >= sprite_get_number(sprite)){
		    			if(active) sprite = sprHalo;
		    			else sprite = mskNone;
		    		}
	    			
	    			array_push(a, o);
	    		}
	    	}
	    }
	    
	     // the next generation:
	    bonus_spirit = a;
	    
	     // Wobble:
	    var _num = array_length(bonus_spirit) + (skill_get(mut_strong_spirit) && canspirit);
    	bonus_spirit_bend_spd += hspeed_raw / (3 * max(1, _num));
		bonus_spirit_bend_spd += 0.1 * (0 - bonus_spirit_bend) * current_time_scale;
	    bonus_spirit_bend += bonus_spirit_bend_spd * current_time_scale;
	    bonus_spirit_bend_spd -= bonus_spirit_bend_spd * 0.15 * current_time_scale;
    }

	 // Eyes Custom Pickup Attraction:
    with(instances_matching(Player, "race", "eyes")){
    	if(canspec && button_check(index, "spec")){
    		var _vx = view_xview[index],
    			_vy = view_yview[index];

    		with(instance_rectangle(_vx, _vy, _vx + game_width, _vy + game_height, global.pickup_custom)){
			    var e = on_pull;
				if(!mod_script_exists(e[0], e[1], e[2]) || mod_script_call(e[0], e[1], e[2])){
	    			var	l = (1 + skill_get(mut_throne_butt)) * current_time_scale,
	    				d = point_direction(x, y, other.x, other.y),
	    				_x = x + lengthdir_x(l, d),
	    				_y = y + lengthdir_y(l, d);
	
			        if(place_free(_x, y)) x = _x;
			        if(place_free(x, _y)) y = _y;
				}
    		}
    	}
    }

	 // Grabbing Custom Pickups:
    with(instances_matching([Player, Portal], "", null)){
        if(place_meeting(x, y, Pickup)){
        	with(instances_meeting(x, y, global.pickup_custom)){
        		if(instance_exists(self) && place_meeting(x, y, other)){
		            var e = on_open;
		            if(!mod_script_exists(e[0], e[1], e[2]) || !mod_script_call(e[0], e[1], e[2])){
			             // Effects:
			            if(sprite_exists(spr_open)){
			            	with(instance_create(x, y, SmallChestPickup)){
			            		sprite_index = other.spr_open;
			            		image_xscale = other.image_xscale;
			            		image_yscale = other.image_yscale;
			            		image_angle = other.image_angle;
			            	}
			            }
			            sound_play(snd_open);
			
			            instance_destroy();
		            }
        		}
        	}
        }
    }

    global.pickup_custom = [];
    
    if(DebugLag) trace_time("tepickups_step")

#define post_step
	if(DebugLag) trace_time();
	
	 // Fix Steroids Mystery Chests:
	if(ultra_get("steroids", 2)){
		with(instances_matching(AmmoChestMystery, "sprite_index", sprAmmoChestMystery)){
			sprite_index = sprAmmoChestSteroids;
		}
	}
	
     // More:
    var _minHard = 8;
    if(instance_exists(GenCont)){
    	with(instances_matching(GenCont, "ntte_special_pickup", null)){
    		ntte_special_pickup = true;
    		global.sPickupsNum = min(global.sPickupsNum + global.sPickupsInc, global.sPickupsMax, (GameCont.hard < _minHard));
    	}
    }

	else{
		 // Spawning Overheal, Overstock, and Spirit Pickups:
		with(instances_matching([AmmoPickup, HPPickup], "ntte_special_pickup", null)){
			ntte_special_pickup = false;
			
			if(GameCont.hard >= _minHard && global.sPickupsNum > 0){
				if(!position_meeting(xstart, ystart, ChestOpen)){
					if((instance_is(self, HPPickup) && sprite_index == sprHP) || (instance_is(self, AmmoPickup) && sprite_index == sprAmmo)){
						var _sPickupsDec = 0;
						
						 // Spirit Pickups:
						if(chance(1 + skill_get(mut_last_wish), 200)){
							_sPickupsDec = 2;
							obj_create(x, y, "SpiritPickup");
						}
						
						else if(chance(1, 50)){
							 // Hammerhead Pickups:
							if(chance(2, 5)){
								_sPickupsDec = 0.5;
								obj_create(x, y, "HammerHeadPickup");
							}
							
							 // Overheal / Overstock Pickups:
							else{
								_sPickupsDec = 1;
								obj_create(x, y, (instance_is(id, HPPickup) ? "OverhealPickup" : "OverstockPickup"));
							}
						}
						
						if(_sPickupsDec > 0){
							global.sPickupsNum -= _sPickupsDec;
							instance_delete(id);
						}
					}
				}
			}
		}
		
		 // Cursed Ammo Chests:
		with(instances_matching(AmmoChest, "cursedammochest_check", null)){
			cursedammochest_check = false;
			
			if(!instance_is(self, IDPDChest)){
				 // Crown of Curses:
				if((crown_current == crwn_curses || GameCont.area == 104) && chance(1, 5)){
					cursedammochest_check = true;
				}
				
				 // Cursed Player:
				with(instances_matching_gt(instances_matching_gt(Player, "curse", 0), "bcurse", 0)){
					if(chance(1, 2)) other.cursedammochest_check = true;
				}
				
				 // Spawn:
				if(cursedammochest_check){
					obj_create(x, y, "CursedAmmoChest");
					instance_delete(id);
				}
			}
		}
		with(instances_matching(Mimic, "cursedmimic_check", null)){
			cursedmimic_check = false;
			
			 // Crown of Curses:
			if((crown_current == crwn_curses || GameCont.area == 104) && chance(1, 3)){
				cursedmimic_check = true;
			}
			
			 // Cursed Player:
			with(instances_matching_gt(instances_matching_gt(Player, "curse", 0), "bcurse", 0)){
				if(chance(1, 2)) other.cursedmimic_check = true;
			}
			
			 // Spawn:
			if(cursedmimic_check){
				obj_create(x, y, "CursedMimic");
				instance_delete(id);
			}
		}
	}
	
	 // Overstock / Bonus Ammo Cleanup:
	with(instances_matching(instances_matching_gt(Player, "ammo_bonus", 0), "infammo", 0)){
		drawempty = 0;
		
		var t = weapon_get_type(wep),
			c = weapon_get_cost(wep);
			
		if(c > 0){
			 // Cool Blue Shells:
			with(instances_matching_ne(instances_matching(instances_matching_gt(Shell, "speed", 0), "ammo_bonus_shell", null), "sprite_index", sprSodaCan)){
				if(place_meeting(xprevious, yprevious, other)){
					ammo_bonus_shell = true;
					sprite_index = ((sprite_get_width(sprite_index) > 3) ? spr.BonusShellHeavy : spr.BonusShell);
					image_blend = merge_color(image_blend, c_blue, random(0.25));
				}
			}
	
			 // Prevent Low Ammo PopupTexts:
			if(ammo[t] + ammo_bonus >= c && infammo == 0){
				var o = 10;
				with(instance_rectangle_bbox(x - o, y - o, x + o, y + o, instances_matching(instances_matching(instances_matching(PopupText, "target", index), "text", "EMPTY", "NOT ENOUGH " + typ_name[t]), "alarm1", 30))){
					if(point_distance(xstart, ystart, other.x, other.y) < o){
						other.wkick = 0;
						sound_stop(sndEmpty);
						instance_destroy();
					}
				}
			}
		}
	}
	
	if(DebugLag) trace_time("tepickups_post_step");
	
	instance_destroy();

#define end_step
	if(DebugLag) trace_time();

	 // Overheal / Bonus HP:
	with(instances_matching_gt(Player, "my_health_bonus", 0)){
		drawlowhp = 0;

		if(nexthurt > current_frame && "my_health_bonus_hold" in self){
			var a = my_health,
				b = my_health_bonus_hold;
	
			if(a < b){
				var c = min(my_health_bonus, b - a);
				my_health += c;
				my_health_bonus -= c;

				 // Sound:
				sound_play_pitchvol(sndRogueAim, 2 + random(0.5), 0.7);
				sound_play_pitchvol(sndHPPickup, 0.6 + random(0.1), 0.7);

				 // Visual:
				var _x1, _y1,
					_x2, _y2,
					_ang = direction + 180,
					l = 12;

				for(var d = _ang; d <= _ang + 360; d += (360 / 20)){
					_x1 = x + lengthdir_x(l, d);
					_y1 = y + lengthdir_y(l, d);
					if(d > _ang){
						with(instance_create(_x1, _y1, BoltTrail)){
							image_blend = merge_color(c_aqua, c_blue, 0.2 + (0.2 * dsin(_ang + d)));
							image_angle = point_direction(_x1, _y1, _x2, _y2);
							image_xscale = point_distance(_x1, _y1, _x2, _y2) * 1.1;
							image_yscale = 1.5 + dsin(_ang + d);
							if(other.my_health_bonus > 0){
								image_yscale = max(1.7, image_yscale);
							}
							motion_add(other.direction, 0.5);
							depth = -2;
						}
					}
					_x2 = _x1;
					_y2 = _y1;
				}
				with(instance_create(x, y, BulletHit)){
					sprite_index = sprPortalClear;
					image_xscale = 0.4;
					image_yscale = image_xscale;
					image_speed = 1;
					motion_add(other.direction, 0.5);
				}

				 // End:
				if(my_health_bonus <= 0){
					 // Can't die coming out of overheal:
					spiriteffect = max(1, spiriteffect);

					 // Effects:
					sound_play_pitchvol(sndLaserCannon, 1.4 + random(0.2), 0.8);
					sound_play_pitchvol(sndEmpty,       0.8 + random(0.1), 1);
					with(instance_create(x, y, BulletHit)){
						sprite_index = sprThrowHit;
						motion_add(other.direction, 1);
						image_xscale = random_range(2/3, 1);
						image_yscale = image_xscale;
						image_angle = random(360);
						image_blend = merge_color(c_aqua, c_blue, 0.2 + (0.2 * dsin(d)));
						image_speed = 0.5;
						image_alpha = 2;
						depth = -3;
					}
				}
			}
		}
		my_health_bonus_hold = my_health;
	}
	
	if(DebugLag) trace_time("tepickups_end_step");
	
	instance_destroy();

#define draw_dark // Drawing Grays
    draw_set_color(c_gray);
    
    if(DebugLag) trace_time();
    
     // Shops:
    with(instances_matching(CustomObject, "name", "ChestShop")) if(visible){
    	var	_x = x,
    		_y = y,
    		_radius = (80 * clamp(open_state, 0, 1)) + random(1);
    		
    	if(instance_exists(creator)){
    		_x = lerp(_x, creator.x, 0.2);
    		_y = lerp(_y, creator.y, 0.2);
    	}
    	
        draw_circle(_x, _y, _radius, false);
    }
    
     // Bonus Pickups:
    with(instances_matching(Pickup, "name", "OverhealPickup", "OverstockPickup")) if(visible){
        draw_circle(x, y, 48 + random(2), false);
    }
    
     // Vault Flower:
    with(instances_matching(instances_matching(CustomProp, "name", "VaultFlower"), "wilted", false)){
    	draw_circle(x, y, 64 + (sin(current_frame * 0.1) * 2), false);
    }
    
    if(DebugLag) trace_time("tepickups_draw_dark");

#define draw_dark_end // Drawing Clears
    draw_set_color(c_black);
    
    if(DebugLag) trace_time();
    
     // Shops:
    with(instances_matching(CustomObject, "name", "ChestShop")) if(visible){
    	var	_x = x,
    		_y = y,
    		_radius = (32 * clamp(open_state, 0, 1)) + random(1);
    		
    	if(instance_exists(creator)){
    		_x = lerp(_x, creator.x, 0.2);
    		_y = lerp(_y, creator.y, 0.2);
    	}
    	
        draw_circle(_x, _y, _radius, false);
    }
    
     // Bonus Pickups:
    with(instances_matching(Pickup, "name", "OverhealPickup", "OverstockPickup")) if(visible){
        draw_circle(x, y, 16 + random(2), false);
    }
    
     // Vault Flower:
    with(instances_matching(instances_matching(CustomProp, "name", "VaultFlower"), "wilted", false)){
    	draw_circle(x, y, 24 + (sin(current_frame * 0.1) * 2), false);
    }
    
    if(DebugLag) trace_time("tepickups_draw_dark_end");
    
#define draw_bonus_spirit
	if(DebugLag) trace_time();
	
	with(instances_matching_ne(Player, "bonus_spirit", null)){
		if(visible || variable_instance_get(self, "wading", 0) > 0){
			var n = array_length(bonus_spirit);
			if(n > 0){
				var _bend = bonus_spirit_bend,
					_dir = 90,
					_dis = 7,
					_x = x,
					_y = y + sin(wave * 0.1);
					
				if(skill_get(mut_strong_spirit) && canspirit){
					_x += lengthdir_x(_dis, _dir);
					_y += lengthdir_y(_dis, _dir);
					_dir += _bend;
				}
				
				for(var i = 0; i < n; i++){
					draw_sprite_ext(bonus_spirit[i].sprite, bonus_spirit[i].index, _x, _y, 1, 1, _dir - 90, c_white, 1);
					_x += lengthdir_x(_dis, _dir);
					_y += lengthdir_y(_dis, _dir);
					_dir += _bend;
				}
			}
		}
	}
	
	if(DebugLag) trace_time("tepickups_draw_bonus_spirit");
	
	 // Goodbye Bro:
	instance_destroy();

#macro bonusSpiritGain { sprite : sprStrongSpiritRefill, index : 0, active : true  }
#macro bonusSpiritLose { sprite : sprStrongSpirit,       index : 0, active : false }


/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  anim_end                                                                                image_index + image_speed_raw >= image_number
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
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
#define dfloor(_num, _div)                                                              return  mod_script_call_nc('mod', 'telib', 'dfloor', _num, _div);
#define in_distance(_inst, _dis)                                                        return  mod_script_call(   'mod', 'telib', 'in_distance', _inst, _dis);
#define in_sight(_inst)                                                                 return  mod_script_call(   'mod', 'telib', 'in_sight', _inst);
#define instance_budge(_objAvoid, _disMax)                                              return  mod_script_call(   'mod', 'telib', 'instance_budge', _objAvoid, _disMax);
#define instance_random(_obj)                                                           return  mod_script_call_nc('mod', 'telib', 'instance_random', _obj);
#define instance_create_copy(_x, _y, _obj)                                              return  mod_script_call(   'mod', 'telib', 'instance_create_copy', _x, _y, _obj);
#define instance_create_lq(_x, _y, _lq)                                                 return  mod_script_call_nc('mod', 'telib', 'instance_create_lq', _x, _y, _lq);
#define instance_nearest_array(_x, _y, _inst)                                           return  mod_script_call_nc('mod', 'telib', 'instance_nearest_array', _x, _y, _inst);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc('mod', 'telib', 'instance_rectangle', _x1, _y1, _x2, _y2, _obj);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call_nc('mod', 'telib', 'instance_rectangle_bbox', _x1, _y1, _x2, _y2, _obj);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call_nc('mod', 'telib', 'instances_at', _x, _y, _obj);
#define instances_seen_nonsync(_obj, _bx, _by)                                          return  mod_script_call_nc('mod', 'telib', 'instances_seen_nonsync', _obj, _bx, _by);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   'mod', 'telib', 'instances_meeting', _x, _y, _obj);
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call_nc('mod', 'telib', 'draw_weapon', _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call_nc('mod', 'telib', 'draw_lasersight', _x, _y, _dir, _maxDistance, _width);
#define draw_text_bn(_x, _y, _string, _angle)                                                   mod_script_call_nc('mod', 'telib', 'draw_text_bn', _x, _y, _string, _angle);
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
#define area_generate(_x, _y, _area)                                                    return  mod_script_call_nc('mod', 'telib', 'area_generate', _x, _y, _area);
#define area_border(_y, _area, _color)                                                  return  mod_script_call_nc('mod', 'telib', 'area_border', _y, _area, _color);
#define floor_get(_x, _y)                                                               return  mod_script_call_nc('mod', 'telib', 'floor_get', _x, _y);
#define floor_set(_x, _y, _state)                                                       return  mod_script_call_nc('mod', 'telib', 'floor_set', _x, _y, _state);
#define floor_fill(_x, _y, _w, _h)                                                      return  mod_script_call_nc('mod', 'telib', 'floor_fill', _x, _y, _w, _h);
#define floor_fill_round(_x, _y, _w, _h)                                                return  mod_script_call_nc('mod', 'telib', 'floor_fill_round', _x, _y, _w, _h);
#define floor_fill_ring(_x, _y, _w, _h)                                                 return  mod_script_call_nc('mod', 'telib', 'floor_fill_ring', _x, _y, _w, _h);
#define floor_make(_x, _y, _obj)                                                        return  mod_script_call_nc('mod', 'telib', 'floor_make', _x, _y, _obj);
#define floor_set_style(_style, _area)                                                  return  mod_script_call_nc('mod', 'telib', 'floor_set_style', _style, _area);
#define floor_reset_style()                                                             return  mod_script_call_nc('mod', 'telib', 'floor_reset_style');
#define floor_reveal(_floors, _maxTime)                                                 return  mod_script_call_nc('mod', 'telib', 'floor_reveal', _floors, _maxTime);
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
#define weapon_decide_gold(_minhard, _maxhard, _nowep)                                  return  mod_script_call_nc('mod', 'telib', 'weapon_decide_gold', _minhard, _maxhard, _nowep);
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
#define TopDecal_create(_x, _y, _area)                                                  return  mod_script_call_nc('mod', 'telib', 'TopDecal_create', _x, _y, _area);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   'mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_instance, _charm)                                               return  mod_script_call_nc('mod', 'telib', 'charm_instance', _instance, _charm);