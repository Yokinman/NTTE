#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	lag = false;
	
	 // Custom Pickup Instances (Used in step):
	global.pickup_custom = [];
	
	 // Bonus Pickups:
	global.bonus_ammo_step = [];
	
	 // Vault Flower:
	global.VaultFlower_spawn = true; // used in ntte.mod
	global.VaultFlower_alive = true;

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#define Backpack_create(_x, _y)
	with(obj_create(_x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.Backpack;
		spr_dead     = spr.BackpackOpen;
		spr_shadow   = shd16;
		spr_shadow_y = 2;
		
		 // Sounds:
		snd_open = choose(sndMenuASkin, sndMenuBSkin);
		
		 // Vars:
		num = 2;
		raddrop = 8;
		
		 // Cursed:
		switch(crown_current){
			case crwn_none   : curse = false;        break;
			case crwn_curses : curse = chance(2, 3); break;
			default          : curse = chance(1, 7);
		}
		if(curse > 0){
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
	 // Sound:
	if(curse > 0) sound_play(sndCursedChest);
	sound_play_pitchvol(sndPickupDisappear, 1 + orandom(0.4), 2);
	
	 // Weapon:
	var _wepNum = 1 + ultra_get("steroids", 1);
	if(_wepNum > 0){
		var _wep = wep_none;
		
		 // DefPack Integration:
		if(mod_exists("mod", "defpack tools") && chance(1, 5)){
			var _jsGrub = [
				"lightning blue lifting drink(tm)",
				"extra double triple coffee",
				"expresso",
				"saltshake",
				"munitions mist",
				"vinegar",
				"guardian juice",
				"stopwatch" // a beautiful mistake
			];
			
			if(skill_get(mut_boiling_veins) > 0){
				array_push(_jsGrub, "sunset mayo");
			}
			if(array_length(instances_matching(Player, "notoxic", false)) > 0){
				array_push(_jsGrub, "frog milk");
			}
			
			_wep = _jsGrub[irandom(array_length(_jsGrub) - 1)];
		}
		
		 // Merged Weapon:
		else{
			var _part = wep_merge_decide(0, GameCont.hard + (2 * curse));
			if(array_length(_part) >= 2){
				_wep = wep_merge(_part[0], _part[1]);
			}
		}
		
		 // Create:
		if(_wep != wep_none){
			repeat(_wepNum){
				with(instance_create(x, y, WepPickup)){
					wep = _wep;
					curse = other.curse;
					ammo = true;
					roll = true;
				}
			}
		}
	}
	
	 // Pickups:
	var	_ang = random(360),
		_num = ceil(num * power(1.4, skill_get(mut_rabbit_paw)));
		
	if(_num > 0){
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
			var _minID = GameObject.id;
			
			 // Puf:
			with(instance_create(x, y, Dust)){
				depth = other.depth;
			}
			
			 // Determine Drop:
			if(chance(1, 40)){ // wtf this isnt a pickup
				with(instance_create(x, y, choose(Bandit, Ally))){
					with(alert_create(self, (instance_is(self, Ally) ? spr.AllyAlert : spr.BanditAlert))){
						flash = 6 + random(3);
					}
				}
			}
			else{
				pickup_drop(10000, 0);
				
				 // Rogues:
				var _rogue = 0;
				for(var i = 0; i < maxp; i++){
					if(player_get_race(i) == "rogue"){
						_rogue++;
					}
				}
				
				 // Modify Pickup:
				with(instances_matching_gt([Pickup, chestprop], "id", _minID)){
					switch(object_index){
						
						case AmmoPickup:
							
							 // Portal Strikes:
							if(chance(_rogue, 4)){
								instance_create(x, y, RoguePickup);
								instance_delete(id);
							}
							
							 // Cursed:
							else if(other.curse > cursed){
								sprite_index = sprCursedAmmo;
								cursed       = other.curse;
								num          = 1 + (0.5 * cursed);
								alarm0       = pickup_alarm(200 + random(30), 1/5) / (1 + (2 * cursed));
							}
							
							break;
							
						case AmmoChest:
							
							 // Portal Strikes:
							if(chance(_rogue, 4)){
								chest_create(x, y, RogueChest, false);
								instance_delete(id);
							}
							
							 // Cursed:
							else if(other.curse > 0){
								chest_create(x, y, "CursedAmmoChest", false);
								instance_delete(id);
							}
							
							break;
							
					}
				}
			}
			
			 // Coolify:
			with(instances_matching_gt([Pickup, chestprop, hitme], "id", _minID)){
				with(obj_create(x, y, "BackpackPickup")){
					direction = _dir;
					target = other;
					event_perform(ev_step, ev_step_end);
				}
			}
		}
	}
	
	 // Rads:
	var _rad = raddrop;
	for(var i = 0; i < maxp; i++){
		_rad += (player_get_race(i) == "melting");
	}
	if(_rad > 0) repeat(_rad){
		with(instance_create(x, y, Rad)){
			motion_add(random(360), random_range(3, 5));
		}
	}
	
	 // Restore Strong Spirit:
	if(skill_get(mut_strong_spirit) > 0){
		with(instance_is(other, Player) ? other : Player){
			if(canspirit == false){
				canspirit = true;
				GameCont.canspirit[index] = false;
				
				 // Effects:
				with(instance_create(x, y, StrongSpirit)){
					sprite_index = sprStrongSpiritRefill;
					creator = other;
				}
				sound_play(sndStrongSpiritGain);
			}
		}
	}
	
	
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
	repeat(8) scrFX([x, 4], [y, 4], [random(360), random(4)], Dust);
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
					if(!canfly){
						other.canfly = canfly;
						canfly = true;
					}
				}
				
				 // Disable Collision:
				if(mask_index != mskNone){
					other.mask_index = mask_index;
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
		if("canfly" in other) canfly = other.canfly;
		
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
			case crwn_none:   curse = false;        break;
			case crwn_curses: curse = chance(2, 3); break;
			default:          curse = chance(1, 7);
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
	var	_angOff = 50 / (1 + (0.5 * big)),
		_shop = [];
		
	for(var _ang = -_angOff * (1 + big); _ang <= _angOff * (1 + big); _ang += _angOff){
		var	_l = 28,
			_d = _ang + 90;
			
		with(obj_create(x + lengthdir_x(_l * ((3 + big) / 3), _d), y + lengthdir_y(_l, _d), "ChestShop")){
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
	
	
#define BigIDPDSpawn_create(_x, _y)
	with(instance_create(_x, _y, IDPDSpawn)){
		 // Visual:
		depth = -3;
		
		 // Vars:
		elite = true;
		num   = 2 * (1 + GameCont.loops);
		
		 // Vars:
		alarm0 += 30;
		sound_stop(sndIDPDPortalSpawn);
		sound_play(sndEliteIDPDPortalSpawn);
		
		return id;
	}
	
#define BigIDPDSpawn_end_step
	 // Effects:
	if(sprite_index == sprVanPortalCharge){
		if(chance_ct(2, 3)){
			var	l = 64,
				d = random(360);
			
			with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), IDPDPortalCharge)){
				alarm0 = 20 + random(20);
				speed = l / alarm0;
				direction = d + 180;
			}
		}
		if(chance_ct(1, 4)){
			with(scrFX(x, y, [random(360), 1 + random(1)], PlasmaTrail)){
				sprite_index = sprPopoPlasmaTrail;
			}
		}
	}
	
	 // Force Spawns:
	if(alarm1 > 0 && alarm1 <= ceil(current_time_scale)){
		depth = 0;
		repeat(num){
			event_perform(ev_alarm, 1);
			with(instance_create(x, y, PortalClear)){
				image_xscale = 2;
				image_yscale = image_xscale;
			}
		}
		alarm1 = -1;
	}
	
	 // Animate:
	if(anim_end){
		switch(sprite_index){
			case sprVanPortalStart:
				sprite_index = sprVanPortalCharge;
				break;
				
			case sprVanPortalClose:
				instance_destroy();
				break;
		}
	}
	else{
		switch(sprite_index){
			case sprIDPDPortalClose:  sprite_index = sprVanPortalClose;  break;
			case sprIDPDPortalCharge: sprite_index = sprVanPortalCharge; break;
			case sprIDPDPortalStart:  sprite_index = sprVanPortalStart;  break;
		}
	}
	
	
#define BloodLustPickup_create(_x, _y)
	with(obj_create(_x, _y, "CustomPickup")){
		 // Visual:
		sprite_index = sprHP;
		image_blend = c_red;
		
		 // Sounds:
		snd_open = sndHPPickup;
		snd_fade = sndBloodlustProc;
		
		 // Vars:
		num      = -1 + (crown_current == crwn_haste);
		pull_dis = 30 + (30 * skill_get(mut_plutonium_hunger));
		pull_spd = 4;
		
		 // Events:
		on_open = script_ref_create(BloodLustPickup_open);
		on_fade = script_ref_create(BloodLustPickup_fade);
		
		return id;
	}
	
#define BloodLustPickup_open
	var _num = num;
	
	 // Regen:
	if(fork()){
		with(instance_is(other, Player) ? other : Player){
			while(instance_exists(self)){
				my_health += clamp(maxhealth - my_health, 0, _num);
				
				sound_play(sndBloodlustProc);
				with(instance_create(x, y, BloodLust)){
					creator = other;
				}
				
				var _text = ((my_health < maxhealth) ? "%" : "MAX") + " HP";
				pickup_text(_text, _num);
				
				if(my_health >= maxhealth) break;
				
				wait 45;
			}
		}
		exit;
	}
	
#define BloodLustPickup_fade
	 // Effects:
	instance_create(x, y, BloodLust);
	
	
#define BoneBigPickup_create(_x, _y)
	with(obj_create(_x, _y, "BonePickup")){
		 // Visual:
		sprite_index = spr.BonePickupBig[irandom(array_length(spr.BonePickupBig) - 1)];
		
		 // Vars:
		mask_index = mskBigRad;
		num        = 10;
		
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
		alarm0     = pickup_alarm(150 + random(30), 1/4);
		pull_dis   = 80 + (60 * skill_get(mut_plutonium_hunger));
		pull_spd   = 12;
		
		 // Events:
		on_pull = script_ref_create(BonePickup_pull);
		on_open = script_ref_create(BonePickup_open);
		on_fade = script_ref_create(BonePickup_fade);
		
		return id;
	}
	
#define BonePickup_pull
	if(speed <= 0){
		if(wep_get(other.wep) == "scythe" || wep_get(other.bwep) == "scythe"){
			return true;
		}
	}
	return false;

#define BonePickup_open
	var _num = num;
	
	 // Only Players Holding Scythes:
	if(instance_is(other, Player)){
		if(wep_get(other.wep) != "scythe" && wep_get(other.bwep) != "scythe"){
			return true;
		}
	}
	
	 // Give Ammo:
	with(instance_is(other, Player) ? other : Player){
		with([wep, bwep]){
			if(is_object(self) && wep_get(self) == "scythe"){
				if(ammo < amax){
					ammo = min(ammo + _num, amax);
					break;
				}
			}
		}
	}
	
	 // Effects:
	instance_create(x, y, Dust);

#define BonePickup_fade
	 // Effects:
	instance_create(x, y, Dust);
	
	
#define BonusAmmoChest_create(_x, _y)
	with(obj_create(_x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.BonusAmmoChest;
		spr_dead = spr.BonusAmmoChestOpen;
		spr_open = spr.BonusFXChestOpen;
		
		 // Vars:
		num  = 16;
		wave = random(90);
		
		 // Get Loaded:
		if(ultra_get("steroids", 2) != 0){
			sprite_index = spr.BonusAmmoChestSteroids;
			spr_dead = spr.BonusAmmoChestSteroidsOpen;
			num *= power(2, ultra_get("steroids", 2));
		}
		
		 // Events:
		on_step = script_ref_create(BonusAmmoChest_step);
		on_open = script_ref_create(BonusAmmoChest_open);
		
		return id;
	}
	
#define BonusAmmoChest_step
	 // FX:
	wave += current_time_scale;
	if((wave % 30) < current_time_scale){
		with(scrFX([x, 4], [y, 4], 0, FireFly)){
			sprite_index = spr.BonusFX;
			depth = other.depth - 1;
		}
	}
	
#define BonusAmmoChest_open
	var	_num  = num,
		_text = `% @5(${spr.BonusText}:-0.3) AMMO`;
		
	 // Bonus Ammo:
	if(instance_is(other, Player)){
		with(other){
			var _add = _num;
			
			 // Fish:
			var	_ammoBase = [264, 32, 8, 7, 6, 10],
				_ammoMult = 0;
				
			for(var i = 1; i < array_length(typ_ammo); i++){
				_ammoMult += typ_ammo[i] / ((i < array_length(_ammoBase)) ? _ammoBase[i] : typ_ammo[i]);
			}
			_ammoMult = pfloor(_ammoMult / (array_length(typ_ammo) - 1), 0.05);
			_add += round(16 * (_ammoMult - 1));
			
			 // Give Ammo:
			bonus_ammo = variable_instance_get(id, "bonus_ammo", 0) + _add;
			
			 // Text:
			pickup_text(_text, _add);
		}
	}
	else repeat(2){
		with(obj_create(x, y, "BonusAmmoPickup")){
			num = _num / 2;
		}
	}
	
	 // Effects:
	sound_play_pitchvol(sndRogueCanister, 0.7, 0.7);
	sound_play_pitch(sndRogueRifle, 0.5);
	
	
#define BonusAmmoMimic_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle = spr.BonusAmmoMimicIdle;
		spr_walk = spr.BonusAmmoMimicFire;
		spr_hurt = spr.BonusAmmoMimicHurt;
		spr_dead = spr.BonusAmmoMimicDead;
		spr_chrg = spr.BonusAmmoMimicTell;
		spr_shadow = shd24;
		hitid = [spr.BonusAmmoMimicFire, "OVERSTOCK MIMIC"];
		
		 // Sound:
		snd_hurt = sndMimicHurt;
		snd_dead = sndMimicDead;
		snd_mele = sndMimicMelee;
		snd_tell = sndMimicSlurp;
		
		 // Vars:
		mask_index  = -1;
		maxhealth   = 12;
		raddrop     = 6;
		size        = 1;
		maxspeed    = 2;
		meleedamage = 3;
		num         = 2;
		
		 // Alarms:
		alarm1 = irandom_range(90, 240);
		
		return id;
	}
	
#define BonusAmmoMimic_step
	if(speed > maxspeed) speed = maxspeed;
	
	 // Animate:
	if(sprite_index == spr_chrg && anim_end){
		sprite_index = spr_idle;
	}
	else if(sprite_index == spr_hurt && instance_near(x, y, Player, 48)){
		sprite_index = spr_walk;
	}
	
#define BonusAmmoMimic_end_step
	 // Contact:
	if(place_meeting(x, y, Player)){
		with(instances_matching(instances_meeting(x, y, Player), "lasthit", hitid)){
			if(place_meeting(x, y, other)){
				if(sprite_index == spr_hurt && image_index == 0){
					 // Give Bonus Ammo:
					with(obj_create(x, y, "BonusAmmoPickup")){
						BonusAmmoPickup_open();
						instance_destroy();
					}
				}
			}
		}
	}
	
#define BonusAmmoMimic_alrm1
	alarm1 = irandom_range(90, 240);
	
	sprite_index = spr_chrg;
	image_index = 0;
	
	sound_play_hit(snd_tell, 0.1);
	
#define BonusAmmoMimic_death
	 // Pickups:
	repeat(num){
		obj_create(x, y, "BonusAmmoPickup");
	}
	
	
#define BonusAmmoPickup_create(_x, _y)
	with(obj_create(_x, _y, "CustomPickup")){
		 // Visuals:
		sprite_index = spr.BonusAmmoPickup;
		spr_open = spr.BonusFXPickupOpen;
		spr_fade = spr.BonusFXPickupFade;
		
		 // Sounds:
		snd_open = sndAmmoPickup;
		snd_fade = sndPickupDisappear;
		
		 // Vars:
		num        = 8 + (crown_current == crwn_haste);
		pull_dis   = 30 + (30 * skill_get(mut_plutonium_hunger));
		pull_spd   = 4;
		pull_delay = 9;
		wave       = random(90);
		
		 // Events:
		on_step = script_ref_create(BonusAmmoPickup_step);
		on_pull = script_ref_create(BonusAmmoPickup_pull);
		on_open = script_ref_create(BonusAmmoPickup_open);
		
		return id;	
	}
	
#define BonusAmmoPickup_step
	if(pull_delay > 0){
		pull_delay -= current_time_scale;
	}
	
	 // FX:
	wave += current_time_scale;
	if(((wave % 30) < current_time_scale || pull_delay > 0) && chance(1, max(2, pull_delay))){
		with(scrFX([x, 4], [y, 4], 0, FireFly)){
			sprite_index = spr.BonusFX;
			depth = other.depth - 1;
		}
	}
	
#define BonusAmmoPickup_pull
	if(pull_delay <= 0){
		 // Pull FX:
		if(chance_ct(1, 2)){
			if(instance_near(x, y, other, pull_dis) || instance_exists(Portal)){
				with(scrFX([x, 4], [y, 4], 0, FireFly)){
					sprite_index = spr.BonusFX;
					depth = other.depth - 1;
					image_index = 1;
				}
			}
		}
		
		return true;
	}
	return false;
	
#define BonusAmmoPickup_open
	var	_num  = num,
		_text = `% @5(${spr.BonusText}:-0.3) AMMO`;
		
	 // Bonus Ammo:
	with(instance_is(other, Player) ? other : Player){
		var _add = _num;
		
		 // Fish:
		var	_ammoBase = [264, 32, 8, 7, 6, 10],
			_ammoMult = 0;
			
		for(var i = 1; i < array_length(typ_ammo); i++){
			_ammoMult += typ_ammo[i] / ((i < array_length(_ammoBase)) ? _ammoBase[i] : typ_ammo[i]);
		}
		_ammoMult = pfloor(_ammoMult / (array_length(typ_ammo) - 1), 0.05);
		_add += round(8 * (_ammoMult - 1));
		
		 // Give Ammo:
		bonus_ammo = variable_instance_get(id, "bonus_ammo", 0) + _add;
		
		 // Text:
		pickup_text(_text, _add);
	}
	
	 // Effects:
	sound_play_pitchvol(sndRogueCanister, 0.7, 0.7);
	sound_play_pitch(sndRogueRifle, 1.5);
	
	
#define BonusHealthChest_create(_x, _y)
	with(obj_create(_x, _y, "CustomChest")){
		var _skill = skill_get(mut_second_stomach);
		
		 // Visual:
		sprite_index = spr.BonusHealthChest;
		spr_dead = spr.BonusHealthChestOpen;
		spr_open = spr.BonusFXChestOpen;
		
		 // Sound:
		snd_open = ((_skill > 0) ? sndHPPickupBig : sndHPPickup);
		
		 // Vars:
		num  = 4 * (1 + _skill);
		wave = random(90);
		
		 // Events:
		on_step = script_ref_create(BonusAmmoChest_step);
		on_open = script_ref_create(BonusHealthChest_open);
		
		return id;
	}
	
#define BonusHealthChest_open
	var	_num  = num,
		_text = `% @5(${spr.BonusText}:-0.3) HP`;
		
	 // Bonus HP:
	if(instance_is(other, Player)){
		with(other){
			bonus_health = variable_instance_get(id, "bonus_health", 0) + _num;
			
			 // Text:
			pickup_text(_text, _num);
			
			 // Effects:
			with(instance_create(x, y, HealFX)){
				sprite_index = ((skill_get(mut_second_stomach) > 0) ? spr.BonusHealBigFX : spr.BonusHealFX);
				depth = other.depth - 1;
			}
		}
	}
	else repeat(2){
		with(obj_create(x, y, "BonusHealthPickup")){
			num = _num / 2;
		}
	}
	
	 // Effects:
	sound_play_pitchvol(sndRogueCanister, 1.3, 0.7);
	sound_play_pitch(sndRogueRifle, 0.5);
	
	
#define BonusHealthMimic_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle = spr.BonusHealthMimicIdle;
		spr_walk = spr.BonusHealthMimicFire;
		spr_hurt = spr.BonusHealthMimicHurt;
		spr_dead = spr.BonusHealthMimicDead;
		spr_chrg = spr.BonusHealthMimicTell;
		spr_shadow = shd24;
		hitid = [spr.BonusHealthMimicFire, "OVERHEAL MIMIC"];
		
		 // Sound:
		snd_hurt = sndMimicHurt;
		snd_dead = sndMimicDead;
		snd_mele = sndMimicMelee;
		snd_tell = sndHPMimicTaunt;
		
		 // Vars:
		mask_index  = -1;
		maxhealth   = 12;
		raddrop     = 15;
		size        = 1;
		maxspeed    = 2;
		meleedamage = 4;
		num         = 2;
		
		 // Alarms:
		alarm1 = irandom_range(180, 480);
		
		return id;
	}

#define BonusHealthMimic_step
	if(speed > maxspeed) speed = maxspeed;
	
	 // Animate:
	if(sprite_index == spr_chrg && anim_end){
		sprite_index = spr_idle;
	}
	else if(sprite_index == spr_hurt && instance_near(x, y, Player, 48)){
		sprite_index = spr_walk;
	}
	
#define BonusHealthMimic_end_step
	 // Contact:
	if(place_meeting(x, y, Player)){
		with(instances_matching(instances_meeting(x, y, Player), "lasthit", hitid)){
			if(place_meeting(x, y, other)){
				if(sprite_index == spr_hurt && image_index == 0){
					 // Give Bonus Ammo:
					with(obj_create(x, y, "BonusHealthPickup")){
						BonusHealthPickup_open();
						instance_destroy();
					}
				}
			}
		}
	}
	
#define BonusHealthMimic_alrm1
	alarm1 = irandom_range(180, 480);
	
	sprite_index = spr_chrg;
	image_index = 0;
	
	sound_play_hit(snd_tell, 0.1);
	
#define BonusHealthMimic_death
	 // Pickups:
	repeat(num){
		obj_create(x, y, "BonusHealthPickup");
	}
	
	
#define BonusHealthPickup_create(_x, _y)
	with(obj_create(_x, _y, "CustomPickup")){
		var _skill = skill_get(mut_second_stomach);
		
		 // Visuals:
		sprite_index = spr.BonusHealthPickup;
		spr_open     = spr.BonusFXPickupOpen;
		spr_fade     = spr.BonusFXPickupFade;
		
		 // Sounds:
		snd_open = ((_skill > 0) ? sndHPPickupBig : sndHPPickup);
		snd_fade = sndPickupDisappear;
		
		 // Vars:
		num        = (2 * (1 + _skill)) + (crown_current == crwn_haste);
		pull_dis   = 30 + (30 * skill_get(mut_plutonium_hunger));
		pull_spd   = 4;
		pull_delay = 9;
		wave       = random(90);
		
		 // Events:
		on_step = script_ref_create(BonusAmmoPickup_step);
		on_pull = script_ref_create(BonusAmmoPickup_pull);
		on_open = script_ref_create(BonusHealthPickup_open);
		
		return id;
	}
	
#define BonusHealthPickup_open
	var	_num  = num,
		_text = `% @5(${spr.BonusText}:-0.3) HP`;
		
	 // Bonus Health:
	with(instance_is(other, Player) ? other : Player){
		bonus_health = variable_instance_get(id, "bonus_health", 0) + _num;
		
		 // Text:
		pickup_text(_text, _num);
		
		 // Effects:
		with(instance_create(x, y, HealFX)){
			sprite_index = ((skill_get(mut_second_stomach) > 0) ? spr.BonusHealBigFX : spr.BonusHealFX);
			depth = other.depth - 1;
		}
	}
	
	 // Effects:
	sound_play_pitchvol(sndRogueCanister, 1.3, 0.7);
	sound_play_pitch(sndRogueRifle, 1.5);
	
	
#define BuriedVaultChest_create(_x, _y)
	with(obj_create(_x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.BuriedVaultChest;
		spr_dead     = spr.BuriedVaultChestOpen;
		spr_shadow   = -1;
		
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
	if(num > 0){
		for(var d = _ang; d < _ang + 360; d += (360 / num)){
			with(obj_create(x, y, "BackpackPickup")){
				zfriction = 0.6;
				zspeed = random_range(3, 4);
				speed = 1.5 + orandom(0.2);
				direction = d;
				
				 // Decide Chest:
				target = chest_create(
					x,
					y,
					pool([
						[AmmoChest,     1],
						[WeaponChest,   1],
						[HealthChest,   1],
						["Backpack",    1],
						["OrchidChest", 1]
					]),
					false
				);
				
				event_perform(ev_step, ev_step_end);
			}
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
		
		 // Sounds:
		snd_land = -1;
		
		 // Vars:
		friction = 0.15;
		direction = random(360);
		speed = random_range(1, 2);
		z = 0;
		zspeed = 10;
		zfriction = 1;
		rotspeed = orandom(30);
		bounce = 0;
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
				sound_play_hit_ext(snd_land, 0.9 + random(0.2), 0.5);
				repeat(3) with(scrFX(x, y - z, 2, Dust)){
					depth = other.depth;
				}
			}
			if(bounce-- > 0){
				zspeed *= -2/3;
			}
			else{
				image_index = 0;
				image_angle = 0;
				zspeed = 0;
			}
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
	with(instance_create(_x, _y, (instance_exists(CrownPed) ? CustomObject : CrownPed))){
		 // Visual:
		sprite_index = spr.BuriedVaultChestBase;
		image_speed = 0.4;
		depth = 2;
		
		 // Vars:
		mask_index = mskSalamander;
		spawn = irandom_range(1, 2) + GameCont.vaults;
		spawn_time = 0;
		spawn_inst = [];
		
		 // Loot:
		var _chest = pool([
			["BuriedVaultChest", 4],
			[BigWeaponChest,     1],
			//[RadChest,         1],
			[ProtoChest,         1 * (!instance_exists(ProtoChest))],
			[ProtoStatue,        2 * (GameCont.subarea == 2)], // (proto statues do not support non-subarea of 2)
			[EnemyHorror,        1/5]
		]);
		target = chest_create(x, y + 2, _chest, false);
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
			
			 // Fix:
			with(instances_matching_gt(PortalClear, "id", id)){
				instance_destroy();
			}
		}
		
		 // Rads:
		var	_rad = (instance_is(target, RadChest) ? 30 : 15),
			_num = irandom_range(1, 2) + floor(_rad / 15) + skill_get(mut_open_mind),
			_ang = random(360);
			
		if(_num > 0){
			for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
				var	_l = random_range(16, 40),
					_d = _dir + orandom((360 / _num) * 0.4);
					
				with(chest_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), RadChest, false)){
					if(instance_is(self, RadChest) && chance(1, 6)){
						spr_idle = sprRadChestBig;
						spr_hurt = sprRadChestBigHurt;
						spr_dead = sprRadChestBigDead;
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
			&& (!instance_is(target, ProtoChest) || target.sprite_index != sprProtoChestOpen)
			&& (!instance_is(target, ProtoStatue) || target.my_health >= target.maxhealth * 0.7)
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
					_inst = instance_create(bbox_center_x, bbox_center_y, CrownGuardian);
					portal_poof();
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
		
		 // Begin Spawnage:
		else{
			spawn_time = 30;
			GameCont.buried_vaults = variable_instance_get(GameCont, "buried_vaults", 0) + 1;
			portal_poof();
			
			 // Sound/Music:
			sound_play_pitch(sndCrownGuardianDisappear, 0.7 + random(0.2));
			with(MusCont){
				var _area = GameCont.area;
				GameCont.area = -1;
				event_perform(ev_alarm, 11);
				GameCont.area = _area;
				alarm_set(3, -1);
				alarm_set(4, 1);
			}
		}
	}
	
	 // Proto Statue Charged:
	if(instance_is(target, ProtoStatue) && target.canim > 0){
		image_index = max(0, (image_number - 1) - (0.5 * target.canim));
		image_speed = 0.4;
	}
	
	
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
	
	 // Shop Pool:
	var	_hard = GameCont.hard,
		_pool = {
			"ammo"         : 1,
			"health"       : 1,
			"rads"         : 1,
			"bonus_ammo"   : 1   * (_hard >= 6),
			"bonus_health" : 1   * (_hard >= 6),
			"soda"         : 0.5 * (_hard >= 10 && mod_exists("mod", "defpack tools")),
			"spirit"       : 0.3 * (_hard >= 12),
			"turret"       : 0.7 * (GameCont.loops > 0),
			"rogue"        : 0,
			"parrot"       : 0,
			"bone"         : 0,
			"bones"        : 0
		};
		
	with(Player){
		 // Character-Specific:
		switch(race){
			case "rogue"  : _pool.rogue++;  break;
			case "parrot" : _pool.parrot++; break;
		}
		
		 // Bones:
		if(_hard >= 4){
			if((wep_get(wep) == "crabbone" || wep_get(bwep) == "crabbone")){
				_pool.bone = 0.5;
			}
		}
		if(wep_get(wep) == "scythe" || wep_get(bwep) == "scythe"){
			_pool.bones++;
		}
	}
	
	 // Create Shops:
	var _angOff = 50;
	for(var _ang = -_angOff; _ang <= _angOff; _ang += _angOff){
		var	_dis = 28,
			_dir = _ang + 90;
			
		with(obj_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), "ChestShop")){
			type = ChestShop_basic;
			creator = _open;
			
			 // Decide Item:
			var _drop = pool(_pool);
			if(!is_undefined(_drop)){
				drop = _drop;
				lq_set(_pool, drop, lq_get(_pool, drop) - 1);
			}
		}
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
		sprite_index     = mskNone;
		image_speed      = 0.4;
		image_blend      = c_white;
		image_alpha      = 0.7;
		depth            = -8;
		
		 // Vars:
		mask_index = mskWepPickup;
		friction   = 0.4;
		creator    = noone;
		prompt     = prompt_create("");
		shine      = 0.025;
		open_state = 0;
		open       = 1;
		wave       = random(100);
		type       = ChestShop_basic;
		drop       = 0;
		num        = 0;
		text       = "";
		desc       = "";
		soda       = "";
		curse      = false;
		setup      = true;
		
		return id;
	}
	
#define ChestShop_setup
	setup = false;
	
	 // Default:
	num  = 1;
	text = "";
	desc = "";
	sprite_index = sprAmmo;
	image_blend = c_white;
	
	 // Loop:
	if(GameCont.loops > 0){
		switch(drop){
			case "ammo"   : drop = "ammo_chest";   break;
			case "health" : drop = "health_chest"; break;
			case "rads"   : drop = "rads_chest";   break;
		}
	}
	
	 // Crowns:
	switch(crown_current){
		case crwn_love:
			switch(drop){
				case "health"             :
				case "rads"               :
				case "spirit"             : drop = "ammo";             break;
				case "health_chest"       :
				case "rads_chest"         :
				case "turret"             : drop = "ammo_chest";       break;
				case "bonus_health"       : drop = "bonus_ammo";       break;
				case "bonus_health_chest" : drop = "bonus_ammo_chest"; break;
			}
			break;
			
		case crwn_life:
			if(drop == "health"){
				drop = "ammo";
			}
			break;
			
		case crwn_guns:
			if(drop == "ammo"){
				drop = "health";
			}
			break;
			
		case "bonus":
			switch(drop){
				case "ammo"         : drop = "bonus_ammo";         break;
				case "ammo_chest"   : drop = "bonus_ammo_chest";   break;
				case "health"       : drop = "bonus_health";       break;
				case "health_chest" : drop = "bonus_health_chest"; break;
			}
			break;
	}
	
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
					
				case "bonus_ammo":
					text = "OVERSTOCK";
					desc = `@5(${spr.BonusText}:0) AMMO`;
					
					 // Visual:
					sprite_index = spr.BonusAmmoPickup;
					image_blend = make_color_rgb(100, 255, 255);
					break;
					
				case "bonus_ammo_chest":
					text = "OVERSTOCK";
					desc = ((num > 1) ? `${num} ` : "") + "CHEST";
					
					 // Visual:
					sprite_index = (ultra_get("steroids", 2) ? spr.BonusAmmoChestSteroids : spr.BonusAmmoChest);
					image_blend = make_color_rgb(100, 255, 255);
					break;
					
				case "bonus_health":
					text = "OVERHEAL";
					desc = `@5(${spr.BonusText}:0) HEALTH`;
					
					 // Visual:
					sprite_index = spr.BonusHealthPickup;
					image_blend = make_color_rgb(200, 160, 255);
					break;
					
				case "bonus_health_chest":
					text = "OVERHEAL";
					desc = ((num > 1) ? `${num} ` : "") + "CHEST";
					
					 // Visual:
					sprite_index = spr.BonusHealthChest;
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
						if(bskin == 1){
							other.image_blend = make_color_rgb(0, 220, 255);
						}
						other.sprite_index = race_get_sprite(race, sprChickenFeather);
					}
					break;
					
				case "infammo":
					num = 90;
					text = "INFINITE AMMO";
					desc = "FOR A MOMENT";
					
					 // Visual:
					sprite_index = sprFishA;
					shine = 0;
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
				wep_get(drop) == "merge"
				&& "stock" in lq_get(drop, "base")
				&& "front" in lq_get(drop, "base")
			){
				var	a = _hue[clamp(weapon_get_type(drop.base.stock), 0, array_length(_hue) - 1)],
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
	
	with(prompt){
		text = `${other.text}#@s${other.desc}`;
	}
	
#define ChestShop_step
	wave += current_time_scale;
	
	 // Setup:
	if(setup) ChestShop_setup();
	
	 // Shine Delay:
	if(image_index < 1 && shine > 0){
		image_index += random(shine * current_time_scale) - image_speed_raw;
	}
	
	 // Particles:
	if(instance_exists(creator) && chance_ct(1, 8 * ((open > 0) ? 1 : open_state))){
		var	_x = creator.x,
			_y = creator.y,
			_l = point_distance(_x, _y, x, y),
			_d = point_direction(_x, _y, x, y) + orandom(8);
			
		if(open > 0){
			_l = random(_l);
		}
		else{
			_l = random_range(_l * (1 - open_state), _l);
		}
		
		with(instance_create(_x + lengthdir_x(_l, _d) + orandom(4), _y + lengthdir_y(_l, _d) + orandom(4), BulletHit)){
			motion_add(_d + choose(0, 180), random(0.5));
			sprite_index = sprLightning;
			image_blend = other.image_blend;
			image_alpha = 1.5 * (_l / point_distance(_x, _y, other.x, other.y)) * random(abs(other.image_alpha));
			image_angle = random(360);
			depth = other.depth - 1;
		}
		
		 // Curse:
		if(curse && chance(1, 5)){
			instance_create(_x + lengthdir_x(_l, _d) + orandom(4), _y + lengthdir_x(_l, _d) + orandom(4), Curse);
		}
	}
	
	 // Open for Business:
	if(instance_exists(prompt)){
		prompt.visible = (open > 0);
	}
	if(open > 0){
		open_state += (1 - open_state) * 0.15 * current_time_scale;
		
		 // No Customers:
		if(!instance_exists(Player) && open_state >= 1){
			open = 0;
		}
		
		 // Take Item:
		if(instance_exists(prompt)){
			var p = player_find(prompt.pick);
			if(instance_exists(p)){
				var	_x = x,
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
									
								case "bonus_ammo":
									with(obj_create(_x, _y, "BonusAmmoPickup")) pull_delay = 0;
									instance_create(_x, _y, GunWarrantEmpty);
									break;
									
								case "bonus_ammo_chest":
									obj_create(_x, _y - 2, "BonusAmmoChest");
									repeat(3) scrFX(_x, _y, [90 + orandom(60), 4], Dust);
									instance_create(_x, _y, GunWarrantEmpty);
									sound_play_pitchvol(sndChest, 0.6 + random(0.2), 3);
									break;
									
								case "bonus_health":
									with(obj_create(_x, _y, "BonusHealthPickup")) pull_delay = 0;
									instance_create(_x, _y, GunWarrantEmpty);
									break;
									
								case "bonus_health_chest":
									obj_create(_x, _y - 2, "BonusHealthChest");
									repeat(3) scrFX(_x, _y, [90 + orandom(60), 4], Dust);
									instance_create(_x, _y, GunWarrantEmpty);
									sound_play_pitchvol(sndHealthChest, 0.8 + random(0.2), 1.5);
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
					with(instances_matching(Crown, "ntte_crown", crown_current)){
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
	
	var	_openState = clamp(open_state, 0, 1),
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
			_d = point_direction(_sx, _sy, _x, _y);
			
		//_d = angle_lerp(_d, 90, 1 - clamp(open_state, 0, 1));
		
		var	_w = point_distance(_sx, _sy, _x, _y) * ((open > 0) ? _openState : min(_openState * 3, 1)),
			_h = ((sqrt(sqr(sprite_get_width(_spr) * image_xscale * dsin(_d)) + sqr(sprite_get_height(_spr) * image_yscale * dcos(_d))) * 2/3) + random(2)) * max(0, (_openState - 0.5) * 2),
			_x1 = _sx + lengthdir_x(0.5, _d),
			_y1 = _sy + lengthdir_y(1,   _d),
			_x2 = _sx + lengthdir_x(_w, _d) + lengthdir_x(_h / 2, _d - 90),
			_y2 = _sy + lengthdir_y(_w, _d) + lengthdir_y(_h / 2, _d - 90),
			_x3 = _sx + lengthdir_x(_w, _d) - lengthdir_x(_h / 2, _d - 90),
			_y3 = _sy + lengthdir_y(_w, _d) - lengthdir_y(_h / 2, _d - 90);
			
		if(type == ChestShop_wep){
			_y2 = max(_y + 2, _y2);
			_y3 = max(_y + 2, _y3);
		}
		
		_x = _sx + lengthdir_x(_w, _d);
		_y = _sy + lengthdir_y(_w, _d);
		
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
		spr_dead     = spr.CursedAmmoChestOpen;
		
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
				alarm0 = pickup_alarm(120 + random(30), 1/5);
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
		mask_index  = -1;
		maxhealth   = 12;
		raddrop     = 16;
		size        = 1;
		maxspeed    = 2;
		meleedamage = 4;
		num         = 4;
		
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
	else if(sprite_index == spr_hurt && instance_near(x, y, Player, 48)){
		sprite_index = spr_walk;
	}
	
	 // FX:
	if(chance_ct(1, 12)){
		with(instance_create(x + orandom(4), y - 2 + orandom(4), Curse)){
			depth = other.depth - 1;
		}
	}
	
#define CursedMimic_end_step
	 // Contact:
	if(place_meeting(x, y, Player)){
		with(instances_matching(instances_meeting(x, y, Player), "lasthit", hitid)){
			if(place_meeting(x, y, other)){
				if(sprite_index == spr_hurt && image_index == 0){
					 // Curse:
					if(curse < 1){
						curse++;
						sound_play(sndBigCursedChest);
					}
				}
			}
		}
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
		cursed       = true;
		num          = 1 + (0.5 * cursed);
		alarm0       = pickup_alarm(200 + random(30), 1/5) / (1 + (2 * cursed));
		
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
		spr_dead     = sprAmmoChestOpen;
		spr_open     = sprFXChestOpen;
		
		 // Sound:
		snd_open = sndAmmoChest;
		
		 // Vars:
		nochest = 0; // Adds to GameCont.nochest if not grabbed
		
		 // Events:
		on_step = null;
		on_open = null;
		
		return id;
	}
	
#define CustomChest_step
	 // Call Chest Step Event:
	var e = on_step;
	if(is_array(e)){
		mod_script_call(e[0], e[1], e[2]);
	}
	
	 // Open Chest:
	var _meet = [Player, PortalShock];
	for(var i = 0; i < array_length(_meet); i++){
		if(place_meeting(x, y, _meet[i])){
			with(instance_nearest(x, y, _meet[i])) with(other){
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
				if(is_array(e)){
					mod_script_call(e[0], e[1], e[2]);
				}
				
				 // Effects:
				if(sprite_exists(spr_dead)){
					with(instance_create(x, y, ChestOpen)){
						sprite_index = other.spr_dead;
					}
				}
				if(sprite_exists(spr_open)){
					with(instance_create(x, y, FXChestOpen)){
						sprite_index = other.spr_open;
					}
				}
				sound_play(snd_open);
				
				instance_destroy();
				exit;
			}
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
		friction   = 0.2;
		num        = 1;
		blink      = 30;
		alarm0     = pickup_alarm(200 + random(30), 1/5);
		pull_dis   = 40 + (30 * skill_get(mut_plutonium_hunger));
		pull_spd   = 6;
		
		 // Events:
		on_step = null;
		on_pull = script_ref_create(CustomPickup_pull);
		on_open = null;
		on_fade = null;
		
		return id;
	}
	
#define CustomPickup_pull
	return true;
	
#define CustomPickup_step
	array_push(global.pickup_custom, id); // For step event management
	
	 // Fading:
	if(alarm0 >= 0 && --alarm0 == 0){
		 // Blink:
		if(blink >= 0){
			blink--;
			alarm0 = 2;
			visible = !visible;
		}
		
		 // Fade:
		else{
			 // Call Fade Event:
			var e = on_fade;
			if(is_array(e)){
				mod_script_call(e[0], e[1], e[2]);
			}
			
			 // Effects:
			if(sprite_exists(spr_fade)){
				with(instance_create(x, y, SmallChestFade)){
					sprite_index = other.spr_fade;
					image_xscale = other.image_xscale;
					image_yscale = other.image_yscale;
					image_angle  = other.image_angle;
				}
			}
			sound_play_hit(snd_fade, 0.1);
			
			instance_destroy();
			exit;
		}
	}
	
	 // Call Chest Step Event:
	var e = on_step;
	if(is_array(e)){
		mod_script_call(e[0], e[1], e[2]);
	}
	
	 // Attraction:
	var e = on_pull;
	if(is_array(e)){
		var	_nearest = noone,
			_disMax = (instance_exists(Portal) ? infinity : pull_dis);
			
		 // Find Nearest Attractable Player:
		with(Player){
			var _dis = point_distance(x, y, other.x, other.y);
			if(_dis < _disMax){
				with(other) if(mod_script_call(e[0], e[1], e[2])){
					_disMax = _dis;
					_nearest = other;
				}
			}
		}
		
		 // Move:
		if(_nearest != noone){
			var	_l = pull_spd * current_time_scale,
				_d = point_direction(x, y, _nearest.x, _nearest.y),
				_x = x + lengthdir_x(_l, _d),
				_y = y + lengthdir_y(_l, _d);
				
			if(place_free(_x, y)) x = _x;
			if(place_free(x, _y)) y = _y;
		}
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
	
	 // Animate:
	if(image_index < 1 && shine > 0){
		image_index += random(shine * current_time_scale) - image_speed_raw;
	}
	
	
#define HammerHeadPickup_create(_x, _y)
	with(obj_create(_x, _y, "CustomPickup")){
		 // Visual:
		sprite_index = spr.HammerHeadPickup;
		spr_open = sprHammerHead;
		spr_fade = sprHammerHead;
		spr_halo = spr.HammerHeadPickupEffectSpawn;
		img_halo = 0;
		
		 // Sounds:
		snd_open = sndHammerHeadProc;
		snd_fade = sndHammerHeadEnd;
		
		 // Vars:
		num      = 10 + (crown_current == crwn_haste);
		pull_dis = 30 + (30 * skill_get(mut_plutonium_hunger));
		pull_spd = 4;
		
		 // Events:
		on_step = script_ref_create(HammerHeadPickup_step);
		on_open = script_ref_create(HammerHeadPickup_open);
		on_fade = script_ref_create(HammerHeadPickup_fade);
		
		 // Sound:
		sound_play_hit_ext(sndWeaponPickup,  0.3 + random(0.1), 1);
		sound_play_hit_ext(sndHammerHeadEnd, 0.2 + random(0.1), 1.5);
		
		return id;
	}
	
#define HammerHeadPickup_step
	 // Animate Indicator:
	img_halo += image_speed_raw;
	if(img_halo >= sprite_get_number(spr_halo)){
		img_halo %= sprite_get_number(spr_halo);
		spr_halo = spr.HammerHeadPickupEffect;
	}
	
#define HammerHeadPickup_draw
	draw_sprite(spr_halo, img_halo, x, y);
	
#define HammerHeadPickup_open
	var	_num  = num,
		_text = `% @(color:${c_yellow})HAMMERHEAD`;
		
	 // Hammer Time:
	with(instance_is(other, Player) ? other : Player){
		hammerhead += _num;
		
		 // Text:
		pickup_text(_text, _num);
	}
	
	 // Effects:
	sound_play(sndLuckyShotProc);
	sleep(20); // i am karmelyth now
	
#define HammerHeadPickup_fade
	 // Effects:
	repeat(1 + irandom(2)){
		scrFX(x, y, random(2), Smoke);
	}
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
		friction   = 0.4;
		alarm0     = pickup_alarm(90 + random(30), 1/5);
		pull_spd   = 8;
		target     = noone;
		
		 // Events:
		on_step = script_ref_create(HarpoonPickup_step);
		on_pull = script_ref_create(HarpoonPickup_pull);
		on_open = script_ref_create(HarpoonPickup_open);
		
		return id;
	}
	
#define HarpoonPickup_step
	 // Stuck in Target:
	if(instance_exists(target)){
		var	_odis = 16,
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
	var	_type = 3,
		_num  = num;
		
	 // +1 Bolt Ammo:
	with(instance_is(other, Player) ? other : Player){
		ammo[_type] = min(ammo[_type] + _num, typ_amax[_type]);
		
		 // Text:
		var _text = ((ammo[_type] < typ_amax[_type]) ? "%" : "MAX") + " " + typ_name[_type];
		pickup_text(_text, _num);
	}
	
	
#define OrchidBall_create(_x, _y)
	/*
		The Orchid pet's mutation projectile
		
		Args:
			skill       - The mutation to give, automatically decided by default
			time        - The lifespan of the given mutation
			target      - The instance to fly towards
			target_seek - True/false can fly toward the target, gets set to 'true' when not moving
			creator     - Who created this ball, bro
			trail_col   - The trail effect's 'image_blend'
			flash       - How many frames to draw in flat white
	*/
	
	 // First, Enable Orchid Chest Spawning:
	save_set("orchid:seen", true);
	
	 // Back to Business:
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.PetOrchidBall;
		depth        = -9;
		
		 // Vars:
		mask_index   = mskSuperFlakBullet;
		image_xscale = 1.5;
		image_yscale = image_xscale;
		friction     = 0.6;
		direction    = random(360);
		speed        = 8;
		skill        = OrchidSkill_decide();
		time         = -1;
		target       = instance_nearest(x, y, Player);
		target_seek  = false;
		creator      = noone;
		trail_col    = make_color_rgb(128, 104, 34); // make_color_rgb(84, 58, 24);
		flash        = 3;
		
		return id;
	}
	
#define OrchidBall_step
	if(flash > 0) flash -= current_time_scale;
	
	 // Grow / Shrink:
	var	_scale = 1 + (0.1 * sin(current_frame / 10)),
		_scaleAdd = (current_time_scale / 15);
		
	image_xscale += clamp(_scale - image_xscale, -_scaleAdd, _scaleAdd);
	image_yscale += clamp(_scale - image_yscale, -_scaleAdd, _scaleAdd);
	
	 // Spin:
	image_angle += hspeed_raw / 3;
	
	 // Effects:
	if(visible && chance_ct(1, 4)){
		scrFX([x, 6], [y, 6], 0, "VaultFlowerSparkle");
	}
	
	 // Doin':
	if(target_seek){
		if(target != noone){
			if(instance_exists(target)){
				 // Epic Success:
				if(place_meeting(x, y, target) || place_meeting(x, y, Portal)){
					instance_destroy();
				}
				
				 // Movin':
				else{
					motion_add_ct(point_direction(x, y, target.x, target.y), 1.5);
					speed = min(speed, 10);
					
					 // Trail:
					if(current_frame_active){
						repeat(1 + chance(1, 3)){
							with(instance_create(x + orandom(8), y + orandom(8), DiscTrail)){
								sprite_index = choose(sprWepSwap, sprWepSwap, sprThrowHit);
								image_blend  = other.trail_col;
								image_xscale = 0.8;
								image_yscale = image_xscale;
								image_angle  = random(360);
								depth        = other.depth + 0.1;
								// image_speed  = 0.4;
							}
						}
					}
				}
			}
			
			 // Fresh Meat:
			else if(instance_exists(Player)){
				target = instance_nearest(x, y, Player);
			}
				
			 // Disappear:
			else instance_destroy();
		}
	}
	else if(speed <= 3){
		target_seek = true;
		flash = 3;
	}
	
#define OrchidBall_draw
	if(flash > 0) draw_set_fog(true, image_blend, 0, 0);
	draw_self();
	if(flash > 0) draw_set_fog(false, 0, 0, 0);
	
	 // Bloom:
	var	_scale = 2,
		_alpha = 0.1;
		
	draw_set_blend_mode(bm_add);
	image_xscale *= _scale;
	image_yscale *= _scale;
	image_alpha  *= _alpha;
	draw_self();
	image_xscale /= _scale;
	image_yscale /= _scale;
	image_alpha  /= _alpha;
	draw_set_blend_mode(bm_normal);
	
#define OrchidBall_destroy
	 // Mutate:
	with(obj_create(x, y, "OrchidSkill")){
		creator = other.creator;
		if(other.skill != mut_none){
			skill = other.skill;
		}
		if(other.time >= 0){
			time = other.time;
		}
	}
	
	 // Alert:
	with(target){
		var _icon = skill_get_icon(other.skill);
		with(alert_create(self, _icon[0])){
			image_index = _icon[1];
			image_speed = 0;
			alert       = { spr:spr.AlertIndicatorOrchid, x:6, y:6 };
			blink       = 15;
			alarm0      = 60;
			snd_flash   = sndLevelUp;
			
			 // Fix Overlap:
			while(array_length(instances_meeting(target.x + target_x, target.y + target_y, instances_matching(instances_matching(CustomObject, "name", "AlertIndicator"), "target", target))) > 0){
				target_y -= 8;
			}
		}
	}
	
	 // Effects:
	repeat(10 + irandom(10)){
		with(scrFX([x, 16], [y, 16], [direction, 3 + random(3)], "VaultFlowerSparkle")){
			depth = -9;
			friction = 0.2;
		}
	}
	var _len = 16;
	with(instance_create(x + lengthdir_x(_len, direction), y + lengthdir_y(_len, direction), BulletHit)){
		speed = 1;
		direction = other.direction;
		sprite_index = sprMutant6Dead;
		image_index = 11;
		image_speed = 0.5;
		image_xscale = 0.75;
		image_yscale = image_xscale;
		image_angle = direction - 90;
		depth = -4;
	}
	sleep(20);
	
	
#define OrchidChest_create(_x, _y)
	with(obj_create(_x, _y, "CustomChest")){
		 // Visual:
		spr_dead = spr.OrchidChestOpen;
		sprite_index = spr.OrchidChest;
		//spr_shadow_y = 2;
		
		 // Sounds:
		snd_open = sndChest;
		
		 // Scripts:
		on_step = script_ref_create(OrchidChest_step);
		on_open = script_ref_create(OrchidChest_open);
		
		return id;
	}
	
#define OrchidChest_step
	 // Sparkle:
	if(chance_ct(1, 5)){
		scrFX([x, 7], [y, 6], 0, "VaultFlowerSparkle");
	}
	
#define OrchidChest_open
	 // Skill:
	with(obj_create(x, y, "OrchidBall")){
		if(instance_is(other, Player)) target = other;
		direction = 90 + orandom(45);
	}
	
	 // Effects:
	repeat(10){
		scrFX(x + random(5), [y, 5], [90, random(1)], "VaultFlowerSparkle");
	}
	repeat(5){
		scrVaultFlowerDebris(x, y, random(360), random(3));
	}
	with(instance_create(x, y - 10, FXChestOpen)){
		sprite_index = sprMutant6Dead;
		image_index  = 12;
		image_xscale = 0.75;
		image_yscale = image_xscale;
	}
	
	 // Sound:
	sound_play_pitchvol(sndUncurse,            0.9 + random(0.2), 1.0);
	sound_play_pitchvol(sndJungleAssassinWake, 0.9 + random(0.2), 0.8);
	sound_play_pitchvol(sndWallBreakBrick,     1,                 0.6);
	
	
#define OrchidSkill_decide
	/*
		Returns a random mutation that could currently appear on the mutation selection screen and isn't patience
		If the player already has every available mutation then a random one is returned
		Returns 'mut_none' if there were no available mutations
	*/
	
	var _skillList = [],
		_skillMods = mod_get_names("skill"),
		_skillMax = 30,
		_skillAll = true; // Already have every available skill
		
	for(var i = 1; i < _skillMax + array_length(_skillMods); i++){
		var _skill = ((i < _skillMax) ? i : _skillMods[i - _skillMax]);
		
		if(skill_get_active(_skill)){
			if(
				_skill != mut_patience
				&& (_skill != mut_last_wish || skill_get(_skill) <= 0)
				&& (_skill != mut_heavy_heart || GameCont.wepmuts >= 3)
			){
				if(
					!is_string(_skill)
					|| !mod_script_exists("skill", _skill, "skill_avail")
					|| mod_script_call("skill", _skill, "skill_avail")
				){
					array_push(_skillList, _skill);
					if(skill_get(_skill) == 0) _skillAll = false;
				}
			}
		}
	}
	
	var _skillInst = instances_matching(CustomObject, "name", "OrchidSkill", "OrchidBall");
	with(array_shuffle(_skillList)){
		var _skill = self;
		if(_skillAll || (skill_get(_skill) == 0 && array_length(instances_matching(_skillInst, "skill", _skill)) <= 0)){
			return _skill;
		}
	}
	
	return mut_none;
	
#define OrchidSkill_create(_x, _y)
	/*
		Manages the pet Orchid's timed mutation
		
		Vars:
			color1 - The main HUD color
			color2 - The secondary HUD color
			skill  - The mutation to give, automatically decided by default
			time   - How many frames the mutation lasts
			num    - The value of the mutation
			flash  - Visual HUD flash, true/false
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		color1 = make_color_rgb(255, 255, 80);
		color2 = make_color_rgb(84, 58, 24);
		
		 // Vars:
		persistent = true;
		skill      = OrchidSkill_decide();
		num        = 1;
		time       = 600;
		time_max   = 0;
		setup      = true;
		flash      = true;
		chest      = [];
		spirit     = [];
		creator    = noone;
		
		return id;
	}
	
#define OrchidSkill_setup
	setup = false;
	
	 // Effects:
	flash = true;
	sound_play_pitch(sndMut, 1 + orandom(0.2));
	sound_play_pitchvol(sndStatueXP, 0.8, 0.8);
	
	 // Skill:
	skill_set(skill, max(0, skill_get(skill)) + num);
	if(num != 0) switch(skill){
		case mut_scarier_face:
			
			 // Manually Reduce Enemy HP:
			with(enemy){
				maxhealth = round(maxhealth * power(0.8, other.num));
				my_health = round(my_health * power(0.8, other.num));
				
				 // Hurt FX:
				image_index = 0;
				sprite_index = spr_hurt;
				if(point_seen(x, y, -1)) sound_play_hit(snd_hurt, 0.3);
			}
			
			break;
			
		case mut_hammerhead:
			
			 // Give Hammerhead Points:
			with(Player) hammerhead += 20 * other.num;
			
			break;
			
		case mut_strong_spirit:
			
			with(Player){
				var _num = other.num;
				
				 // Restore Strong Spirit:
				if(canspirit == false || skill_get(mut_strong_spirit) <= other.num){
					canspirit = true;
					_num--;
					
					 // Effects:
					with(instance_create(x, y, StrongSpirit)){
						sprite_index = sprStrongSpiritRefill;
						creator = other;
					}
					sound_play(sndStrongSpiritGain);
				}
				
				 // Bonus Spirit (Strong Spirit's built-in mutation stacking don't exist):
				if("bonus_spirit" not in self){
					bonus_spirit = [];
				}
				if(_num > 0) repeat(_num){
					var _spirit = {};
					array_push(other.spirit, _spirit);
					array_push(bonus_spirit, _spirit);
					sound_play(sndStrongSpiritGain);
				}
			}
			
			break;
			
		case mut_open_mind:
			
			if(num > 0){
				 // Duplicate Chest:
				with(instance_random(instances_matching_ne([chestprop, RadChest], "mask_index", mskNone))){
					repeat(other.num){
						array_push(other.chest, instance_clone());
					}
					
					 // Manual Offset:
					if(instance_is(self, RadChest)){
						with(other.chest) instance_budge(other, -1);
					}
				}
				
				 // Alert:
				with(chest) with(other){
					var _icon = skill_get_icon(skill);
					with(alert_create(other, _icon[0])){
						image_index = _icon[1];
						image_speed = 0;
						alert = {};
						alarm0 = other.time - (2 * blink);
						flash = 4;
						snd_flash = sndChest;
					}
				}
			}
			
			break;
	}
	
#define OrchidSkill_step
	if(setup) OrchidSkill_setup();
	
	 // Unflash:
	else flash = false;
	
	if(skill_get(skill) != 0){
		 // Chest Blink:
		with(chest) if(instance_exists(self)){
			with(instances_matching(instances_matching(CustomObject, "name", "AlertIndicator"), "target", self)){
				other.visible = visible;
				break;
			}
		}
		
		 // Timer:
		time_max = max(time, time_max);
		if(time >= 0 && !instance_exists(GenCont) && !instance_exists(LevCont)){
			time -= current_time_scale;
			
			 // Goodbye:
			if(time <= current_time_scale){
				flash = true;
				if(time <= 0) instance_destroy();
			}
		}
	}
	else instance_delete(id);
	
#define OrchidSkill_destroy
	skill_set(skill, max(0, skill_get(skill) - num));
	
	 // Blip:
	sound_play_pitchvol(sndMutHover,       0.5 + random(0.2), 3);
	sound_play_pitchvol(sndCursedReminder, 1 + orandom(0.1),  3);
	sound_play_pitchvol(sndStatueHurt,     0.7 + random(0.1), 0.4);
	
	 // Delete Alerts:
	with(instances_matching(instances_matching(CustomObject, "name", "AlertIndicator"), "creator", id)){
		flash   = 1;
		blink   = 1;
		alarm0  = 1 + flash;
		visible = true;
	}
	
	 // Skill-Specific:
	switch(skill){
		case mut_scarier_face:
			
			 // Restore Enemy HP:
			with(instances_matching_lt(enemy, "id", self)){
				maxhealth = round(maxhealth / power(0.8, other.num));
				my_health = round(my_health / power(0.8, other.num));
				
				 // Heal FX:
				image_index = 0;
				sprite_index = spr_hurt;
				with(instance_create(x, y, BloodLust)){
					sprite_index = sprHealFX;
					creator = other;
				}
				sound_play_pitchvol(sndHPPickup, 1.5, 0.3);
			}
			
			break;
			
		case mut_hammerhead:
			
			 // Remove Hammerhead Points:
			with(instances_matching_gt(instances_matching_lt(Player, "id", self), "hammerhead", 0)){
				hammerhead = max(0, hammerhead - (20 * other.num));
			}
			
			break;
			
		case mut_strong_spirit:
			
			 // Remove Bonus Spirit:
			with(spirit) if(lq_defget(self, "active", true)){
				active = false;
				sprite_index = sprStrongSpirit;
				image_index = 0;
				sound_play(sndStrongSpiritLost);
			}
			
			 // Remove Strong Spirit:
			if(num - array_length(spirit) > 0){
				with(instances_matching(instances_matching_lt(Player, "id", self), "canspirit", true)){
					if(skill_get(mut_strong_spirit) > 0) canspirit = false;
					with(instance_create(x, y, StrongSpirit)) creator = other;
					sound_play(sndStrongSpiritLost);
				}
			}
			
			break;
			
		case mut_open_mind:
			
			 // Delete Duplicate Chest:
			with(chest) if(instance_exists(self)){
				instance_delete(id);
			}
			
			break;
	}
	
	
#define PalaceAltar_create(_x, _y)
	/*
		7-2 event prop. Grants a temporary weapon mutation based on the player's loadout.
	*/
	
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle = spr.PalaceAltarIdle;
		spr_hurt = spr.PalaceAltarHurt;
		spr_dead = spr.PalaceAltarDead;
		sprite_index = spr_idle;
		
		 // Sounds:
		snd_hurt = sndHitRock;
		snd_dead = sndGeneratorBreak;
		
		 // Vars:
		maxhealth = 80;
		raddrop = 6;
		team = 1;
		size = 3;
		skill = mut_none;
		effect_color = make_color_rgb(72, 253, 8); // make_color_rgb(190, 253, 8);
		
		 // Prompt:
		prompt = prompt_create("  CHOOSE");
		with(prompt){
			xoff = -8;
			yoff = -16;
			mask_index = mskReviveArea;
			on_meet = script_ref_create(VaultFlower_prompt_meet);
		}
		
		 // Alarms:
		alarm0 = -1;
		
		return id;
	}
	
#define PalaceAltar_step
	x = xstart;
	y = ystart;

	 // Radiate:
	if(chance_ct(2, 3)){
		with(scrFX([x, 2], y - random(16), [90, random(2)], EatRad)){
			sprite_index = choose(sprEatRadPlut, sprEatBigRadPlut);
			image_speed  = 0.4;
			depth = -7;
		} 
	}
	
	 // Damage Sparks:
	if(sprite_index == spr_hurt && chance_ct(2, 5)){
		instance_create(x + orandom(16), (y + 8) + orandom(16), PortalL);
	}
	
	 // Pickup:
	if(instance_exists(prompt)){
		if(player_is_active(prompt.pick)){
			 // Grant Blessing:
			with(obj_create(0, 0, "OrchidSkill")){
				color1 = make_color_rgb(72, 253,  8);
				color2 = make_color_rgb( 3,  33, 18)
				skill  = other.skill;
				time   = 180 * 30; // 3 minutes
			}
			
			 // Effect:
			with(instance_create(x, y, ImpactWrists)){
				image_blend = other.effect_color;
				depth = -7;
			}
			
			 // Disable All Altars:
			with(instances_matching(object_index, "name", name)){
				with(prompt) visible = false;
				alarm0 = 10 + random(10);
			}
		}
	}
	
#define PalaceAltar_alrm0
	my_health = 0;
	
#define PalaceAltar_death
	 // Debris:
	repeat(10){
		with(instance_create(x, y, Shell)){
			sprite_index = spr.PalaceAltarDebris;
			image_index  = irandom(image_number - 1);
			image_speed  = 0;
			image_angle  = random(360);
			motion_set(random(360), random_range(4, 8));
		}
	}
	
	 // Effects:
	instance_create(x, y, PortalClear);
	repeat(4){
		obj_create(x + orandom(24), (y + 8) + orandom(24), "GroundFlameGreen");
	}
	/*
	repeat(2 + irandom(1)){
		with(obj_create(x + orandom(16), (y + 8) + orandom(16), "GroundFlameGreen")){
			spr_dead = sprThroneFlameEnd;
			sprite_index = sprThroneFlameIdle;
			image_yscale = 0.6;
			image_xscale = 0.8;
		}
	}
	*/
	with(instance_create(x, y - 8, EatRad)){
		sprite_index = sprMutant6Dead;
		image_speed  = 0.4;
		image_index  = 9;
		image_blend  = other.effect_color;
		depth = -6
	}
	repeat(15){
		with(scrFX([x, 16], [y, 16], [90, random(1)], EatRad)){
			sprite_index = choose(sprEatRadPlut, sprEatBigRadPlut);
			image_index  = random(2);
			image_speed  = 0.4;
			depth = -7;
		}
	}
	view_shake_max_at(x, y, 50);
	sleep_max(50);
	
	 // Sounds:
	sound_play_hit_ext(sndGunGun,          0.6 + random(0.2), 1.0);
	sound_play_hit_ext(sndSnowTankDead,    0.6 + random(0.2), 1.0);
	sound_play_hit_ext(sndEnergyHammerUpg, 0.5,               0.8);
	
	
#define PalankingStatue_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		var _phase = 0;
		
		 // Visual:
		spr_idle = spr.PalankingStatueIdle[_phase];
		spr_hurt = spr.PalankingStatueHurt[_phase];
		spr_dead = spr.PalankingStatueDead;
		sprite_index = spr_idle;
		
		 // Sounds:
		snd_hurt = sndHitRock;
		snd_dead = sndPillarBreak;
		
		 // Vars:
		maxhealth = 300;
		team = 1;
		size = 3;
		phase = _phase;
		
		return id;
	}
	
#define PalankingStatue_step
	
	 // Change Phase:
	if(sprite_index == spr_hurt){
		var	_mPhase = 4,
			_cPhase = floor(_mPhase - ((my_health / maxhealth) * _mPhase));
			
		while(phase < _cPhase){
			phase++;
			
			/*
			 // Loot:
			var _minID = GameObject.id;
			pickup_drop(10000, 0);
			with(instances_matching_gt([Pickup, chestprop], "id", _minID)){
				with(obj_create(x, y, "BackpackPickup")){
					target = other;
					event_perform(ev_step, ev_step_end);
				}
			}
			
			 // Blank:
			scrPalankingStatueBlank(1 + phase);
			*/
			
			 // Resprite:
			spr_idle = spr.PalankingStatueIdle[phase];
			spr_hurt = spr.PalankingStatueHurt[phase];
			sprite_index = spr_hurt;
			
			 // Effects:
			repeat(3) scrPalankingStatueChunk(x, y, random(360), random_range(3, 8), random_range(3, 8));
			sound_play_hit_ext(snd.PalankingHurt, 0.7 + random(0.2), 0.5);
		}
	}

#define PalankingStatue_death
	var _minID = GameObject.id;
	with(obj_create(x, y, "BackpackPickup")){
		target = obj_create(x, y, "Backpack");
	}
	
	/*
	pickup_drop(10000, 0);
	chest_create(x, y, "Backpack", false);

	 // Become Big:
	with(instances_matching_gt([Pickup, chestprop], "id", _minID)){
		if(instance_is(self, AmmoPickup) || instance_is(self, AmmoChest)){
			chest_create(x, y, AmmoChest, false);
		}
		else if(instance_is(self, HPPickup) || instance_is(self, HealthChest)){
			chest_create(x, y, HealthChest, false);
		}
		instance_delete(id);
	}
	
	 // Z-ify:
	with(instances_matching_gt([Pickup, chestprop], "id", _minID)){
		with(obj_create(x, y, "BackpackPickup")){
			target = other;
			zfriction = 0.6;
			zspeed = random_range(3, 4);
			speed = 1 + orandom(0.5);
			event_perform(ev_step, ev_step_end);
		}
	}
	
	 // Blank:
	scrPalankingStatueBlank(2 + phase);
	*/
	
	 // Effects:
	scrPalankingStatueChunk(x, y, random(360), random_range(3, 8), random_range(3, 8));
	sound_play_hit_ext(snd.PalankingDead, 0.7 + random(0.2), 0.5);
	
#define scrPalankingStatueChunk(_x, _y, _dir, _spd, _zspd)
	with(scrFX(_x, _y, [_dir, _spd], ScrapBossCorpse)){
		sprite_index = spr.PalankingStatueChunk;
		image_index  = irandom(image_number - 1);
		friction	 = 0.2;
		
		 // Z-ify:
		with(obj_create(_x, _y, "BackpackPickup")){
			target = other;
			zfriction = 0.6;
			zspeed = _zspd;
			speed  = _spd;
			event_perform(ev_step, ev_step_end);
		}
		
		return id;
	}
	
	
#define scrPalankingStatueBlank(_num)
	var n = _num;
	for(var i = 0; i < n; i++){
		var	s = 0.5 + (0.5 * (1 - (i / n))),
			l = (24 * i) * (s * 2);
			
		repeat(1 + i){
			var d = random(360);
			with(obj_create(x + lengthdir_x(l, d) + orandom(5), y + lengthdir_y(l, d) + orandom(5), "BatScreech")){
				image_xscale = s;
				image_yscale = s;
				image_speed *= s;
				depth = -7;
				team  = 2;
			}
		}
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
		size      = 1;
		num       = choose(1, 2);
		
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
	
	
#define Prompt_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		mask_index = mskWepPickup;
		persistent = true;
		creator = noone;
		nearwep = noone;
		depth = 0; // Priority (0==WepPickup)
		pick = -1;
		xoff = 0;
		yoff = 0;
		
		 // Events:
		on_meet = null;
		
		return id;
	}
	
#define Prompt_begin_step
	with(nearwep) instance_delete(id);
	
#define Prompt_end_step
	 // Follow Creator:
	var c = creator;
	if(c != noone){
		if(instance_exists(c)){
			if(instance_exists(nearwep)) with(nearwep){
				x += c.x - other.x;
				y += c.y - other.y;
				visible = true;
			}
			x = c.x;
			y = c.y;
			//image_angle = c.image_angle;
			//image_xscale = c.image_xscale;
			//image_yscale = c.image_yscale;
		}
		else instance_destroy();
	}
	
#define Prompt_cleanup
	with(nearwep) instance_delete(id);
	
	
#define RedAmmoChest_create(_x, _y)
	with(obj_create(_x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.RedAmmoChest;
		spr_dead     = spr.RedAmmoChestOpen;
		spr_shadow_y = -3;
		
		 // Sounds:
		snd_open = sndRogueCanister;
		
		 // Vars:
		num = 1;
		
		 // Scripts:
		on_open = script_ref_create(RedAmmoChest_open);
		
		return id;
	}
	
#define RedAmmoChest_open
	var _num = num;
	
	 // Red Ammo:
	if(instance_is(other, Player)){
		with(other) if("red_ammo" in self){
			red_ammo = min(red_ammo + _num, red_amax);
			
			 // Text:
			var _text = `${((red_ammo < red_amax) ? "%" : "MAX")} @3(${spr.RedText}:-0.8) AMMO`;
			pickup_text(_text, _num);
		}
	}
	else repeat(_num){
		obj_create(x, y, "RedAmmoPickup");
	}
	
	
#define RedAmmoPickup_create(_x, _y)
	with(obj_create(_x, _y, "CustomPickup")){
		 // Visual:
		sprite_index = spr.RedAmmoPickup;
		
		 // Sounds:
		snd_open = sndRogueCanister;
		snd_dead = sndPickupDisappear;
		
		 // Vars:
		num = 1;
		
		 // Events:
		on_pull = script_ref_create(RedAmmoPickup_pull);
		on_open = script_ref_create(RedAmmoPickup_open);
		 
		return id;
	}
	
#define RedAmmoPickup_pull
	if(weapon_get_red(other.wep) > 0 || weapon_get_red(other.bwep) > 0){
		return true;
	}
	return false;
	
#define RedAmmoPickup_open
	var	_num  = num;
	
	 // Red Ammo:
	with(instance_is(other, Player) ? other : Player){
		if("red_ammo" in self){
			red_ammo = min(red_ammo + _num, red_amax);
			
			 // Text:
			var _text = `${((red_ammo < red_amax) ? "%" : "MAX")} @3(${spr.RedText}:-0.8) AMMO`;
			pickup_text(_text, _num);
		}
	}
	
	
#define SpiritPickup_create(_x, _y)
	with(obj_create(_x, _y, "CustomPickup")){
		 // Visual:
		sprite_index = spr.SpiritPickup;
		spr_halo = sprStrongSpiritRefill;
		img_halo = 0;
		
		 // Sounds:
		snd_open = sndAmmoPickup;
		snd_fade = sndStrongSpiritLost;
		
		 // Vars:
		num        = 1 + (crown_current == crwn_haste); // haste confirmed epic
		alarm0     = pickup_alarm(90 + random(30), 1/5);
		pull_dis   = 30 + (30 * skill_get(mut_plutonium_hunger));
		pull_spd   = 4;
		pull_delay = 30;
		wave       = random(90);
		
		 // Events:
		on_step = script_ref_create(SpiritPickup_step);
		on_pull = script_ref_create(SpiritPickup_pull);
		on_open = script_ref_create(SpiritPickup_open);
		on_fade = script_ref_create(SpiritPickup_fade);
		
		 // Sound:
		sound_play_pitchvol(sndStrongSpiritGain, 1.4 + random(0.3), 0.7);
		
		return id;
	}
	
#define SpiritPickup_step
	if(pull_delay > 0) pull_delay -= current_time_scale;
	wave += current_time_scale;
	
	 // Animate Halo:
	img_halo += image_speed_raw;
	if(img_halo >= sprite_get_number(spr_halo)){
		img_halo %= sprite_get_number(spr_halo);
		spr_halo = sprHalo;
	}

#define SpiritPickup_draw
	 // Halos:
	for(var i = 0; i < num; i++){
		draw_sprite(spr_halo, img_halo, x, y + 3 + sin(wave * 0.1) - (i * 7));
	}

#define SpiritPickup_open
	var	_inst = noone,
		_num  = num,
		_text ="% @yBONUS @wSPIRIT" + ((_num > 1) ? "S" : "");
		
	 // Acquire Bonus Spirit:
	with(instance_is(other, Player) ? other : Player){
		if("bonus_spirit" not in self){
			bonus_spirit = [];
		}
		if(_num > 0) repeat(_num){
			array_push(bonus_spirit, {});
		}
		
		 // Text:
		pickup_text(_text, _num);
		
		 // for all the headless chickens in the crowd:
		my_health = max(my_health, 1);
	}
	
	 // Sound:
	sound_play(sndStrongSpiritGain);
	
#define SpiritPickup_fade
	 // Kill Spirits:
	for(var i = 0; i < num; i++){
		instance_create(x, (y + 3) - (i * 7), StrongSpirit);
	}
	
	 // Pity HP:
	instance_create(x, y, HPPickup);
	
#define SpiritPickup_pull
	return (pull_delay <= 0);
	
	
#define SunkenChest_create(_x, _y)
	with(obj_create(_x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.SunkenChest;
		spr_dead = spr.SunkenChestOpen;
		spr_shadow_y = 0;
		
		 // Sounds:
		snd_open = sndGoldChest;
		
		 // Vars:
		num   = 2;
		wep   = "merge";
		skeal = false;
		if(GameCont.area == "coast"){
			wep = "trident";
			if(mod_exists("weapon", wep)){
				wep = lq_clone(mod_variable_get("weapon", wep, "lwoWep"));
				wep.gold = true;
			}
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
	
	 // Ancient Treasure Guards:
	var _num = 3 * skeal;
	if(_num > 0){
		if(instance_near(x, y, instance_seen(x, y, Player), 192)){
			skeal = 0;
			
			 // Skeals:
			var _ang = random(360);
			for(var d = _ang; d < _ang + 360; d += 360 / _num){
				var	_dis = 32,
					_dir = d + orandom(30);
					
				obj_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), "SunkenSealSpawn");
			}
			
			 // Clear Area:
			with(instance_create(x, y, PortalClear)){
				image_xscale = 1.2;
				image_yscale = image_xscale;
			}
			
			 // Alert:
			with(alert_create(self, spr.SkealAlert)){
				flash = 10;
			}
			
			 // Sound:
			sound_play_pitchvol(sndMutant14Turn, 0.2 + random(0.1), 1);
		}
	}
	
#define SunkenChest_open
	instance_create(x, y, PortalClear);
	
	 // Sunken Chest Count:
	with(GameCont){
		if("sunkenchests" not in self){
			sunkenchests = 0;
		}
		sunkenchests = max(sunkenchests, GameCont.loops + 1);
	}
	
	 // Important:
	if(instance_is(other, Player)){
		sound_play(other.snd_chst);
	}
	
	 // Trident Unlock:
	var _wepRaw = wep_get(wep);
	if(_wepRaw == "trident"){
		if(mod_script_exists("weapon", _wepRaw, "weapon_avail") && !mod_script_call("weapon", _wepRaw, "weapon_avail", wep)){
			unlock_set(`wep:${_wepRaw}`, true);
		}
	}
	
	 // Weapon:
	var _num = 1 + ultra_get("steroids", 1);
	if(_num > 0){
		var _wep = wep;
		
		 // Golden Merged Weapon:
		if(_wep == "merge"){
			var _part = mod_script_call("weapon", _wep, "weapon_merge_decide_raw", 0, GameCont.hard, -1, -1, true);
			if(array_length(_part) >= 2){
				_wep = wep_merge(_part[0], _part[1]);
			}
		}
		
		 // Create:
		repeat(_num){
			with(instance_create(x, y, WepPickup)){
				wep = _wep;
				ammo = true;
			}
			if(is_object(_wep)) _wep = lq_clone(_wep);
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
	
	/*
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
				var	_spawnX = x,
					_spawnY = y,
					_spawnObj = ((GameCont.area == "trench" || (GameCont.area == area_vault && GameCont.lastarea == "trench")) ? Freak : BoneFish),
					_spawnDir = d,
					_spawnDis = random_range(320, 400);
					
				with(instance_nearest(x - 8 + lengthdir_x(32, _spawnDir), y - 8 + lengthdir_y(32, _spawnDir), TopSmall)){
					_spawnDir = point_direction(other.x, other.y, bbox_center_x, bbox_center_y);
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
	*/
	
	
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
		alarm0     = pickup_alarm(200 + random(30), 1/4);
		pull_dis   = 18 + (12 * skill_get(mut_plutonium_hunger));
		
		 // Events:
		on_pull = script_ref_create(SunkenCoin_pull);
		on_open = script_ref_create(SunkenCoin_open);
		
		return id;
	}
	
#define SunkenCoin_pull
	return (speed <= 0);
	
#define SunkenCoin_open
	if(speed > 0) return true;
	
	
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
		maxhealth  = 30;
		size       = 3;
		skill      = mut_last_wish;
		alive      = global.VaultFlower_alive;
		prompt     = noone;
		
		 // Determine Skill:
		if(alive){
			if(skill_get(skill) == 0){
				var _skillList = [];
				for(var i = 0; !is_undefined(skill_get_at(i)); i++){
					var s = skill_get_at(i);
					if(s != mut_patience){
						var a = true,
							n = "skill_avail";
							
						 // Identify Available Skills:
						if(is_string(s) && mod_script_exists("skill", s, n)){
							a = mod_script_call("skill", s, n);
						}
						
						if(a){
							array_push(_skillList, s);
						}
					}
				}
				
				if(array_length(_skillList) > 0){
					skill = _skillList[irandom(array_length(_skillList) - 1)];
				}
			}
			
			 // Wilt:
			if(skill_get(skill) == 0){
				alive = false;
			}
		}
		
		 // Prompt:
		if(alive){
			prompt = prompt_create("  REROLL");
			with(prompt){
				mask_index = mskLast;
				xoff = -8;
				yoff = -10;
				on_meet = script_ref_create(VaultFlower_prompt_meet);
			}
		}
		
		return id;
	}
	
#define VaultFlower_step
	x = xstart;
	y = ystart;
	
	if(alive){
		 // Sprites:
		if(spr_idle == spr.VaultFlowerWiltedIdle) spr_idle = spr.VaultFlowerIdle;
		if(spr_hurt == spr.VaultFlowerWiltedHurt) spr_hurt = spr.VaultFlowerHurt;
		if(spr_dead == spr.VaultFlowerWiltedDead) spr_dead = spr.VaultFlowerDead;
		
		 // Wilt:
		if(!global.VaultFlower_alive || skill_get(skill) == 0){
			alive = false;
		}
		
		 // Interact:
		else if(instance_exists(prompt) && player_is_active(prompt.pick)){
			global.VaultFlower_alive = false;
			
			 // Reroll:
			mod_variable_set("skill", "reroll", "skill", skill);
			skill_set("reroll", true);
			
			 // FX:
			image_index = 0;
			sprite_index = spr.VaultFlowerHurt;
			with(alert_create(self, skill_get_icon("reroll")[0])){
				image_speed = 0;
				alert = {};
				snd_flash = sndLevelUp;
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
			with(player_find(prompt.pick)){
				sound_play(snd_crwn);
			}
			
			/*if(fork()){
				alive = false;
				while(button_check(0, "pick")) wait 0;
				if(instance_exists(self)){
					alive = true;
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
	
	with(prompt) visible = other.alive;

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
	sound_play_hit_ext(sndPlantSnare, 0.8, 2.5);
	
	 // Secret:
	if(alive){
		pet_spawn(x, y, "Orchid");
		
		 // Permadeath:
		global.VaultFlower_spawn = false;
		
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
	
#define VaultFlower_prompt_meet
	if(instance_exists(TopCont)){
		script_bind_draw(VaultFlower_prompt_icon, TopCont.depth, self, other);
	}
	return true;
	
#define VaultFlower_prompt_icon(_inst, _instMeet)
	with(_instMeet){
		var _local = player_find_local_nonsync();
		if(player_is_active(_local) && player_get_show_prompts(index, _local)){
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
		sprite_index = (variable_instance_get(other, "alive", true) ? spr.VaultFlowerDebris : spr.VaultFlowerWiltedDebris);
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
	
	
#define WepPickupGrounded_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		spr_shadow = shd24;
		spr_shadow_x = 0;
		spr_shadow_y = -9;
		image_xscale = -1;
		image_yscale = choose(-1, 1);
		depth = -1;
		
		 // Vars:
		mask_index = mskWepPickup;
		target     = instance_create(x, y, WepPickup);
		target_x   = 0;
		target_y   = 0;
		top_object = noone;
		
		 // Weapon:
		with(target){
			//wep = weapon_decide(0, GameCont.hard, false, null);
			rotation = 90 + (random_range(10, 20) * choose(-1, 1));
			ammo = true;
		}
		
		return id;
	}
	
#define WepPickupGrounded_end_step
	if(instance_exists(target) && (!instance_exists(Portal) || !instance_near(x, y, instance_seen(x, y, Portal), 96))){
		with(target){
			image_alpha = 0;
			
			 // Spin:
			if(instance_exists(other.top_object) && other.top_object.zfriction != 0){
				rotation += 4 * rotspeed * current_time_scale;
			}
			
			 // Wobble:
			else if(x != xprevious || y != yprevious){
				rotation += sin(current_frame * 0.7) * rotspeed * sign(other.image_yscale) * current_time_scale;
			}
			
			 // Offset:
			var	_uvs = sprite_get_uvs(sprite_index, 0),
				_off = sprite_get_xoffset(sprite_index),
				_ang = other.image_angle + rotation,
				_xsc = other.image_xscale;
				
			if(_xsc < 0) _off = (sprite_get_bbox_right(sprite_index) + 1) - _off;
			else _off -= sprite_get_bbox_left(sprite_index);
			_off *= abs(_xsc);
			
			other.target_x = lengthdir_x(_off, _ang);
			other.target_y = lengthdir_y(_off, _ang) + ((_ang > 180) ? -2 : 2);
			
			 // Hold:
			x = other.x;
			y = other.y - 8;
			xprevious = x;
			yprevious = y;
			speed = 0;
			
			 // Less Shine:
			var _shineSlow = random(0.02 * current_time_scale);
			if(image_index > _shineSlow && image_index < 1){
				image_index -= _shineSlow;
			}
		}
	}
	else instance_destroy();
	
#define WepPickupGrounded_draw
	if(instance_exists(target)){
		var	_spr = target.sprite_index,
			_img = target.image_index,
			_xsc = image_xscale,
			_ysc = image_yscale,
			_ang = image_angle + target.rotation,
			_col = image_blend,
			_alp = image_alpha,
			_x = x + target_x,
			_y = y + target_y;
			
		 // Draw Normal:
		if(instance_exists(top_object) && top_object.zfriction != 0){
			draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
		}
		
		 // Draw w/ End Clipped Off:
		else with(surface_setup(name, 64, 64, option_get("quality:main"))){
			x = other.x - (w / 2);
			y = other.y - h;
			
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			
			with(other){
				draw_sprite_ext(_spr, _img, (_x - other.x) * other.scale, (_y - other.y) * other.scale, _xsc * other.scale, _ysc * other.scale, _ang, _col, _alp);
			}
			
			surface_reset_target();
			draw_surface_scale(surf, x, y, 1 / scale);
		}
	}
	
#define WepPickupGrounded_destroy
	with(target){
		image_alpha = 1;
		x = other.x + other.target_x;
		y = other.y + other.target_y;
		rotation += other.image_angle + (180 * (other.image_xscale < 0));
		
		 // Fix:
		if("top_object" in self){
			with(top_object) instance_destroy();
		}
		
		 // Effects:
		repeat(3) scrFX([x, 4], [y, 4], random(1), Dust);
		sound_play_hit_ext(sndWeaponPickup, 0.7, 0.8);
	}
	with(instance_create(x, y, WepSwap)){
		depth = other.depth - 1;
	}
	
	/*with(instance_create(x, y, WepPickup)){
		ammo = true;
		wep = other.wep;
		curse = other.curse;
		rotation = other.rotation + other.image_angle + (90 + (90 * sign(other.image_xscale)));
	}*/


#define WepPickupStick_create(_x, _y)
	with(instance_create(_x, _y, WepPickup)){
		 // Vars:
		mask_index   = mskShield;
		stick_target = noone;
		stick_x      = 0;
		stick_y      = 0;
		stick_damage = 0;
		
		return id;
	}
	
#define WepPickupStick_step
	if(instance_exists(stick_target)){
		canwade = false;
		rotspeed = 0;
		
		 // Stick in Target:
		var _t = stick_target;
		x = _t.x + _t.hspeed_raw + stick_x;
		y = _t.y + _t.vspeed_raw + stick_y;
		if("z" in _t){
			if(_t.object_index == RavenFly || _t.object_index == LilHunterFly){
				y += _t.z;
			}
			else y -= _t.z;
		}
		xprevious = x;
		yprevious = y;
		speed = 0;
		visible = (_t.visible || instance_is(_t, NothingIntroMask));
		
		 // Deal Damage w/ Taken Out:
		if(stick_damage != 0 && fork()){
			var	_damage  = stick_damage,
				_creator = creator,
				_ang     = rotation,
				_wep     = wep,
				_x       = x,
				_y       = y;
				
			wait 0;
			
			if(!instance_exists(self)){
				with(_t){
					 // Effects:
					var	_prop = (instance_is(self, prop) || instance_is(self, Nothing) || instance_is(self, Nothing2)),
						_dis  = 24;
						
					repeat(3){
						with(scrFX(
							_x + lengthdir_x(_dis, _ang),
							_y + lengthdir_y(_dis, _ang),
							(_prop ? 2.5  : 0),
							(_prop ? Dust : AllyDamage)
						)){
							depth = min(depth, other.depth - 1);
						}
					}
					
					 // Damage:
					projectile_hit_raw(self, _damage, true);
					
					 // Kick:
					with(instance_nearest_array(_x, _y, array_combine(instances_matching(Player, "wep", _wep), instances_matching(Player, "bwep", _wep)))){
						if(wep == _wep){
							wkick = 10;
						}
						else if(bwep == _wep){
							bwkick = 10;
						}
					}
				}
			}
			
			exit;
		}
	}
	else if(stick_target != noone){
		stick_target = noone;
		mask_index = mskWepPickup;
		visible = true;
		canwade = true;
		rotspeed = random_range(1, 2) * choose(-1, 1);
	}
	
	
/// GENERAL
#define game_start
	 // Reset Vault Flower:
	global.VaultFlower_spawn = true;
	global.VaultFlower_alive = true;
	
	 // Delete Orchid Skills:
	with(instances_matching(CustomObject, "name", "OrchidSkill")){
		instance_delete(id);
	}
	
#define ntte_begin_step
	 // Bonus Ammo / Overstock:
	global.bonus_ammo_step = [];
	with(instances_matching(instances_matching_gt(Player, "bonus_ammo", 0), "infammo", 0)){
		if(player_active){
			var	_wepNum  = 1,
				_wepList = [{
					"wep"       : wep,
					"reload"    : reload,
					"clicked"   : (clicked >= 1),
					"canfire"   : (canfire >= 1),
					"can_shoot" : (can_shoot == true),
					"button"    : "fire"
				}];
				
			 // Dual Wielding:
			if(race == "steroids"){
				_wepNum++;
				array_push(_wepList, {
					"wep"       : bwep,
					"reload"    : breload,
					"clicked"   : false,
					"canfire"   : canspec,
					"can_shoot" : (bcan_shoot == true),
					"button"    : "spec"
				});
			}
			
			while(_wepNum-- > 0){
				var	_info         = _wepList[_wepNum],
					_wep          = _info.wep,
					_cost         = weapon_get_cost(_wep),
					_load         = weapon_get_load(_wep),
					_type         = weapon_get_type(_wep),
					_auto         = weapon_get_auto(_wep),
					_internal     = (is_object(_wep) && "wep" in _wep && "ammo" in _wep && "cost" in _wep && is_string(_wep.wep)),
					_internalCost = (_internal ? _wep.cost : 0);
					
				 // Automatic Weapons:
				if(race == "steroids" && _auto >= 0){
					_auto = true;
				}
				
				 // Firing:
				var _fire = 0;
				if(_wepNum == 0 && race == "venuz" && canspec && button_pressed(index, "spec")){
					_fire = floor(2 * (1 + skill_get(mut_throne_butt)));
				}
				else if(_info.canfire){
					 // Automatic:
					if(_auto >= 1){
						if(_info.can_shoot){
							if(button_check(index, _info.button)){
								_fire = 100;
								if(_load > 0){
									_fire = min(_fire, 1 - (min(0, _info.reload) / _load));
								}
								if(_cost > 0){
									_fire = min(_fire, (ammo[_type] + bonus_ammo) / _cost);
								}
								if(_internalCost > 0){
									_fire = min(_fire, (_wep.ammo + bonus_ammo) / _internalCost);
								}
								_fire = floor(_fire);
							}
						}
						
						 // Reloading:
						else if(button_pressed(index, _info.button)){
							_fire = 1;
						}
					}
					
					 // Manual:
					else if(button_pressed(index, _info.button) || _info.clicked){
						_fire = 1;
					}
				}
				
				 // Step:
				if(ammo[_type] - (_cost * _fire) <= _cost){
					array_push(global.bonus_ammo_step, {
						num    : _wepNum,
						inst   : id,
						last   : GameObject.id,
						type   : weapon_get_type(wep),
						btype  : weapon_get_type(bwep),
						wkick  : wkick  + (sign(wkick)  * current_time_scale),
						bwkick : bwkick + (sign(bwkick) * current_time_scale),
						bonus  : (ammo[_type] - (_cost * _fire) + bonus_ammo >= _cost)
					});
				}
				
				 // Give Bonus Ammo:
				if(_fire > 0){
					var	_bonus         = 0,
						_internalBonus = 0;
						
					 // Cost:
					_cost         *= _fire;
					_internalCost *= _fire;
					if(!_info.can_shoot){
						_cost         = min(_cost,         typ_amax[_type]);
						_internalCost = min(_internalCost, (_internal ? lq_defget(_wep, "amax", 0) : 0));
					}
					
					 // Ammo:
					if(ammo[_type] + bonus_ammo >= _cost){
						 // Normal:
						_bonus = clamp(_cost - ammo[_type], 0, bonus_ammo);
						ammo[_type] += _bonus;
						bonus_ammo  -= _bonus;
						
						 // Internal:
						if(_internal){
							if(_wep.ammo + bonus_ammo >= _internalCost){
								_internalBonus = clamp(_internalCost - _wep.ammo, 0, bonus_ammo);
								_wep.ammo  += _internalBonus;
								bonus_ammo -= _internalBonus;
							}
						}
					}
					
					 // FX:
					var _size = _bonus + _internalBonus;
					if(_size > 0){
						sound_play_pitchvol(
							choose(sndGruntFire, sndRogueRifle),
							(0.6 + random(1)) / clamp(_size, 1, 3),
							0.8 + (0.1 * _size)
						);
						
						with(instance_create(x, y, WepSwap)){
							name         = "BonusAmmoFire";
							creator      = other;
							sprite_index = sprImpactWrists;
							image_xscale = 0.425 + (0.075 * _size);
							image_blend  = merge_color(c_aqua, choose(c_white, c_blue), random(0.4));
							image_speed  = 0.35;
							
							 // Normal:
							if(other.bonus_ammo > 0){
								image_index = max(2 - image_speed, 3 - (_size / 3));
							}
							
							 // End:
							else{
								image_xscale *= 1.5;
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
	}
	
	 // Bonus Spirits:
	with(instances_matching_ne(Player, "bonus_spirit", null)){
		if(array_length(bonus_spirit) > 0){
			 // Grant Grace:
			if(my_health <= 0 && lsthealth > 0 && player_active){
				if(skill_get(mut_strong_spirit) <= 0 || canspirit != true){
					for(var i = array_length(bonus_spirit) - 1; i >= 0; i--){
						var _spirit = bonus_spirit[i];
						if(lq_defget(_spirit, "active", true)){
							my_health = 1;
							spiriteffect = 5;
							
							 // Lost:
							with(_spirit){
								active = false;
								sprite_index = sprStrongSpirit;
								image_index = 0;
							}
							sound_play(sndStrongSpiritLost);
							
							break;
						}
					}
				}
			}
			
			 // Override Halos:
			with(instances_matching(instances_matching(StrongSpirit, "creator", id), "visible", true)){
				visible = false;
				array_push(other.bonus_spirit, {
					active       : false,
					sprite_index : sprite_index,
					image_index  : image_index
				});
			}
			
			 // Animate and Cull Spirits:
			with(bonus_spirit){
				if("active"       not in self) active = true;
				if("sprite_index" not in self) sprite_index = (active ? sprStrongSpiritRefill : sprStrongSpirit);
				if("image_index"  not in self) image_index = 0;
				
				 // Animate:
				if(active || sprite_index != mskNone){
					image_index += 0.4 * current_time_scale;
					if(image_index >= sprite_get_number(sprite_index)){
						if(active) sprite_index = sprHalo;
						else sprite_index = mskNone;
						image_index = 0;
					}
				}
				
				 // Gone:
				else other.bonus_spirit = array_delete_value(other.bonus_spirit, self);
			}
			
			 // Wobble:
			if("bonus_spirit_bend" not in self){
				bonus_spirit_bend = 0;
				bonus_spirit_bend_spd = 0;
			}
			var _num = array_length(bonus_spirit) + (skill_get(mut_strong_spirit) > 0 && canspirit == true && array_length(instances_matching(StrongSpirit, "creator", id)) <= 0);
			bonus_spirit_bend_spd += hspeed_raw / (3 * max(1, _num));
			bonus_spirit_bend_spd += 0.1 * (0 - bonus_spirit_bend) * current_time_scale;
			bonus_spirit_bend += bonus_spirit_bend_spd * current_time_scale;
			bonus_spirit_bend_spd -= bonus_spirit_bend_spd * 0.15 * current_time_scale;
		}
		else{
			bonus_spirit_bend = 0;
			bonus_spirit_bend_spd = 0;
		}
	}
	if(array_length(instances_matching(CustomScript, "name", "draw_bonus_spirit")) <= 0){
		with(script_bind_draw(draw_bonus_spirit, -8)){
			name = script[2];
			persistent = true;
		}
	}
	
	 // Mutation Pickups:
	with(instances_matching(instances_matching_le(enemy, "my_health", 0), "mutationpickup_check", null)){
		if(!instance_is(self, CustomEnemy) || candie >= 1){
			mutationpickup_check = false;
			
			if(GameCont.hard > 3){
				if(enemy_boss){
					if(
						(!instance_exists(Generator) || !instance_is(self, Nothing)) &&
						(!instance_exists(LastChair) || !instance_is(self, Last))
					){
						mutationpickup_check = true;
						
						 // Is Last Boss on Level:
						with(enemy){
							if(my_health > 0 || id > other.id){
								if(enemy_boss){
									other.mutationpickup_check = false;
									break;
								}
							}
						}
						
						 // Pickup Time:
						if(mutationpickup_check){
							var	_x = x,
								_y = y;
								
							if(instance_is(self, CustomEnemy) && "name" in self && name == "PitSquid"){
								_x = posx;
								_y = posy;
							}
							
							if(position_meeting(_x, _y, Floor)){
								var	_obj       = "",
									_health    = 0,
									_healthMax = 0;
									
								with(Player){
									_health    += my_health;
									_healthMax += maxhealth;
								}
								
								 // Spirit:
								if(_health <= ceil(_healthMax / 2) && chance(1, 1 + (_health / instance_number(Player)))){
									_obj = "SpiritPickup";
								}
								
								 // HammerHead:
								else if(chance(1 + GameCont.loops, 4)){
									_obj = "HammerHeadPickup"
								}
								
								 // Create:
								if(_obj != ""){
									obj_create(_x + orandom(4), _y + orandom(4), _obj);
								}
							}
						}
					}
				}
			}
		}
	}
	
#define ntte_step
	 // Replace Pickups / Chests:
	if(!instance_exists(GenCont)){
		 // Bonus Pickups:
		bonus_pickup_replace(false);
		
		 // Cursed Ammo Chests:
		with(instances_matching([AmmoChest, Mimic], "cursedammochest_check", null)){
			cursedammochest_check = false;
			
			if(!instance_is(self, IDPDChest)){
				var _mimic = instance_is(self, Mimic);
				
				 // Crown of Curses:
				if(chance(1, (_mimic ? 3 : 5))){
					if(crown_current == crwn_curses || GameCont.area == area_cursed_caves){
						cursedammochest_check = true;
					}
				}
				
				 // Cursed Player:
				if(chance(1, 2)){
					if(array_length(instances_matching_gt(instances_matching_gt(Player, "curse", 0), "bcurse", 0)) > 0){
						cursedammochest_check = true;
					}
				}
				
				 // Spawn:
				if(cursedammochest_check){
					chest_create(x, y, (_mimic ? "CursedMimic" : "CursedAmmoChest"), false);
					instance_delete(id);
				}
			}
		}
	}
	
	 // Bonus Ammo / Overstock Cleanup:
	with(global.bonus_ammo_step){
		if(instance_exists(inst)){
			 // Prevent Low Ammo Text:
			if(bonus){
				var	_txtNonA = loc(`HUD:NoAmmo:${type  }`, loc("HUD:NoAmmo", "EMPTY")),
					_txtNonB = loc(`HUD:NoAmmo:${btype }`, loc("HUD:NoAmmo", "EMPTY")),
					_txtInsA = loc(`HUD:InsAmmo:${type }`, string_replace(loc("HUD:InsAmmo", "NOT ENOUGH %"), "%", inst.typ_name[type])),
					_txtInsB = loc(`HUD:InsAmmo:${btype}`, string_replace(loc("HUD:InsAmmo", "NOT ENOUGH %"), "%", inst.typ_name[btype]));
					
				with(instances_matching(instances_matching(instances_matching_gt(PopupText, "id", last), "target", inst.index), "text", _txtNonA, _txtNonB, _txtInsA, _txtInsB)){
					if(text == _txtNonA || text == _txtInsA){
						other.inst.wkick = other.wkick;
					}
					if(text == _txtNonB || text == _txtInsB){
						other.inst.bwkick = other.bwkick;
					}
					sound_stop(sndEmpty);
					instance_destroy();
				}
			}
			
			 // Cool Blue Shells:
			with(instances_matching_ne(instances_matching_gt(Shell, "id", last), "sprite_index", sprSodaCan)){
				if(position_meeting(x, y, other.inst)){
					sprite_index = ((sprite_get_width(sprite_index) > 3) ? spr.BonusShellHeavy : spr.BonusShell);
					if(chance(1, 5)){
						image_blend = merge_color(image_blend, c_blue, 0.25);
					}
				}
			}
		}
	}
	with(instances_matching_gt(Player, "bonus_ammo", 0)){
		if(drawempty > 0){
			var	_type = weapon_get_type(wep),
				_ammo = ammo[_type];
				
			if(_type != 0 && _ammo <= 0 && _ammo + bonus_ammo > weapon_get_cost(wep)){
				drawempty = 0;
			}
		}
		if(drawemptyb > 0){
			var	_type = weapon_get_type(bwep),
				_ammo = ammo[_type];
				
			if(_type != 0 && _ammo <= 0 && _ammo + bonus_ammo > weapon_get_cost(bwep)){
				drawemptyb = 0;
			}
		}
	}
	
	 // Eyes Custom Pickup Attraction:
	with(instances_matching(Player, "race", "eyes")){
		if(player_active && canspec && button_check(index, "spec")){
			var	_vx = view_xview[index],
				_vy = view_yview[index];
				
			with(instance_rectangle(_vx, _vy, _vx + game_width, _vy + game_height, global.pickup_custom)){
				var e = on_pull;
				if(!is_array(e) || mod_script_call(e[0], e[1], e[2])){
					var	_l = (1 + skill_get(mut_throne_butt)) * current_time_scale,
						_d = point_direction(x, y, other.x, other.y),
						_x = x + lengthdir_x(_l, _d),
						_y = y + lengthdir_y(_l, _d);
						
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
					if(!is_array(e) || !mod_script_call(e[0], e[1], e[2])){
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
	
	 // Prompt Collision:
	var _inst = instances_matching(CustomObject, "name", "Prompt");
	with(_inst) pick = -1;
	_inst = instances_matching(_inst, "visible", true);
	if(array_length(_inst) > 0){
		with(Player) if(visible || variable_instance_get(id, "wading", 0) > 0){
			if(place_meeting(x, y, CustomObject) && !place_meeting(x, y, IceFlower) && !place_meeting(x, y, CarVenusFixed)){
				var _noVan = true;
				
				 // Van Check:
				if(place_meeting(x, y, Van)){
					with(instances_meeting(x, y, instances_matching(Van, "drawspr", sprVanOpenIdle))){
						if(place_meeting(x, y, other)){
							_noVan = false;
							break;
						}
					}
				}
				
				if(_noVan){
					// Find Nearest Touching Indicator:
					var	_nearest = noone,
						_maxDis = null,
						_maxDepth = null;
						
					if(instance_exists(nearwep)){
						_maxDis = point_distance(x, y, nearwep.x, nearwep.y);
						_maxDepth = nearwep.depth;
					}
					
					with(instances_meeting(x, y, _inst)){
						if(place_meeting(x, y, other) && (!instance_exists(creator) || creator.visible || variable_instance_get(creator, "wading", 0) > 0)){
							var e = on_meet;
							if(!is_array(e) || mod_script_call(e[0], e[1], e[2])){
								if(_maxDepth == null || depth < _maxDepth){
									_maxDepth = depth;
									_maxDis = null;
								}
								if(depth == _maxDepth){
									var _dis = point_distance(x, y, other.x, other.y);
									if(_maxDis == null || _dis < _maxDis){
										_maxDis = _dis;
										_nearest = id;
									}
								}
							}
						}
					}
					
					 // Secret IceFlower:
					with(_nearest){
						nearwep = instance_create(x + xoff, y + yoff, IceFlower);
						with(nearwep){
							name = other.text;
							x = xstart;
							y = ystart;
							xprevious = x;
							yprevious = y;
							visible = false;
							mask_index = mskNone;
							sprite_index = mskNone;
							spr_idle = mskNone;
							spr_walk = mskNone;
							spr_hurt = mskNone;
							spr_dead = mskNone;
							spr_shadow = -1;
							snd_hurt = -1;
							snd_dead = -1;
							size = 0;
							team = 0;
							my_health = 99999;
							nexthurt = current_frame + 99999;
						}
						with(other){
							nearwep = other.nearwep;
							if(canpick && button_pressed(index, "pick")){
								other.pick = index;
							}
						}
					}
				}
			}
		}
	}
	
#define ntte_end_step
	 // Red Weapon Pickup Ammo:
	with(instances_matching_gt(WepPickup, "ammo", 0)){
		if(place_meeting(x, y, Player)){
			if(weapon_get_red(wep) > 0){
				with(instance_nearest_array(x, y, instances_matching_ne(Player, "red_ammo", null))){
					other.ammo = false;
					
					 // Crown of Protection:
					if(crown_current == crwn_protection){
						var _num = 1;
						my_health = min(my_health + _num, maxhealth);
						
						 // Text:
						var _text = `${((my_health < maxhealth) ? "%" : "MAX")} HP`;
						pickup_text(_text, _num);
					}
					
					 // Normal:
					else{
						var _num = 1;
						red_ammo = min(red_ammo + _num, red_amax);
						
						 // Text:
						var _text = `${((red_ammo < red_amax) ? "%" : "MAX")} @3(${spr.RedText}:-0.8) AMMO`;
						pickup_text(_text, _num);
					}
				}
			}
		}
	}
	
	 // Bonus HP / Overheal:
	with(instances_matching_gt(Player, "bonus_health", 0)){
		drawlowhp = 0;
		
		if(my_health < 1 && player_active){
			var _bonus = clamp(1 - my_health, 0, bonus_health);
			my_health    += _bonus;
			bonus_health -= _bonus;
			
			 // Sound:
			sound_play_pitchvol(sndRogueAim, 2   + random(0.5), 0.7);
			sound_play_pitchvol(sndHPPickup, 0.6 + random(0.1), 0.7);
			
			 // Visual:
			var	_x1 = null,
				_y1 = null,
				_x2 = null,
				_y2 = null,
				_ang = direction + 180,
				_dis = 12;
				
			for(var _dir = _ang; _dir <= _ang + 360; _dir += (360 / 20)){
				_x1 = x + lengthdir_x(_dis, _dir);
				_y1 = y + lengthdir_y(_dis, _dir);
				if(_dir > _ang){
					with(instance_create(_x1, _y1, BoltTrail)){
						image_blend = merge_color(c_aqua, c_blue, 0.2 + (0.2 * dsin(_ang + _dir)));
						image_angle = point_direction(_x1, _y1, _x2, _y2);
						image_xscale = point_distance(_x1, _y1, _x2, _y2) * 1.1;
						image_yscale = 1.5 + dsin(_ang + _dir);
						if(other.bonus_health > 0){
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
			if(bonus_health <= 0){
				 // Effects:
				sound_play_pitchvol(sndLaserCannon, 1.4 + random(0.2), 0.8);
				sound_play_pitchvol(sndEmpty,       0.8 + random(0.1), 1);
				with(instance_create(x, y, BulletHit)){
					direction    = other.direction;
					speed        = 1;
					sprite_index = sprThrowHit;
					image_xscale = random_range(2/3, 1);
					image_yscale = image_xscale;
					image_angle  = random(360);
					image_blend  = merge_color(c_aqua, c_blue, 0.2 + (0.2 * dsin(_dir)));
					image_speed  = 0.5;
					image_alpha  = 2;
					depth        = -3;
				}
			}
		}
	}
	
	 // Fix Steroids Mystery Chests:
	if(ultra_get("steroids", 2)){
		with(instances_matching(AmmoChestMystery, "sprite_index", sprAmmoChestMystery)){
			sprite_index = sprAmmoChestSteroids;
		}
	}
	
	 // HammerHead Persistence:
	if(instance_exists(GenCont)){
		var _hammerMin = 20 * skill_get(mut_hammerhead);
		with(instances_matching_gt(Player, "hammerhead", _hammerMin)){
			var _save = (hammerhead - _hammerMin);
			hammerhead_save = _save + variable_instance_get(self, "hammerhead_save", 0);
			hammerhead -= _save;
		}
	}
	else with(instances_matching_ne(Player, "hammerhead_save", 0, null)){
		hammerhead += hammerhead_save;
		hammerhead_save = 0;
	}
	
#define ntte_shadows
	 // Weapons Stuck in Ground:
	with(instances_matching(CustomObject, "name", "WepPickupGrounded")){
		draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
	}
	
#define ntte_bloom
	 // Bonus Ammo FX:
	with(instances_matching(WepSwap, "name", "BonusAmmoFire")){
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * ((image_xscale + image_yscale) / 12));
	}
	
#define ntte_dark // Drawing Grays
	 // Shops:
	with(instances_matching(instances_matching(CustomObject, "name", "ChestShop"), "visible", true)){
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
	with(instances_matching(instances_matching(Pickup, "name", "BonusAmmoPickup", "BonusHealthPickup"), "visible", true)){
		draw_circle(x, y, 48 + random(2), false);
	}
	
	 // Bonus Chests:
	with(instances_matching(instances_matching(chestprop, "name", "BonusAmmoChest", "BonusAmmoMimic", "BonusHealthChest", "BonusHealthMimic"), "visible", true)){
		draw_circle(x, y, 64 + random(2), false);
	}
	
	 // Vault Flower:
	with(instances_matching(instances_matching(instances_matching(CustomProp, "name", "VaultFlower"), "alive", true), "visible", true)){
		draw_circle(x, y, 64 + (2 * sin(current_frame / 10)), false);
	}
	
#define ntte_dark_end // Drawing Clears
	 // Shops:
	with(instances_matching(instances_matching(CustomObject, "name", "ChestShop"), "visible", true)){
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
	with(instances_matching(instances_matching(Pickup, "name", "BonusAmmoPickup", "BonusHealthPickup"), "visible", true)){
		draw_circle(x, y, 16 + random(2), false);
	}
	
	 // Bonus Chests:
	with(instances_matching(instances_matching(chestprop, "name", "BonusAmmoChest", "BonusAmmoMimic", "BonusHealthChest", "BonusHealthMimic"), "visible", true)){
		draw_circle(x, y, 16 + random(2), false);
	}
	
	 // Vault Flower:
	with(instances_matching(instances_matching(instances_matching(CustomProp, "name", "VaultFlower"), "alive", true), "visible", true)){
		draw_circle(x, y, 24 + (2 * sin(current_frame / 10)), false);
	}
	
#define draw_bonus_spirit
	if(lag) trace_time();
	
	var _lag = false;
	
	with(instances_matching(instances_matching_ne(Player, "bonus_spirit", null), "visible", true)){
		var _num = array_length(bonus_spirit);
		if(_num > 0){
			var	_bend = (("bonus_spirit_bend" in self) ? bonus_spirit_bend : 0),
				_dir = 90,
				_dis = 7,
				_x = x,
				_y = y + sin(wave * 0.1);
				
			if(skill_get(mut_strong_spirit) > 0 && canspirit == true && array_length(instances_matching(StrongSpirit, "creator", id)) <= 0){
				_x += lengthdir_x(_dis, _dir);
				_y += lengthdir_y(_dis, _dir);
				_dir += _bend;
			}
			
			for(var i = 0; i < _num; i++){
				draw_sprite_ext(lq_defget(bonus_spirit[i], "sprite_index", mskNone), lq_defget(bonus_spirit[i], "image_index", 0), _x, _y, 1, 1, _dir - 90, c_white, 1);
				_x += lengthdir_x(_dis, _dir);
				_y += lengthdir_y(_dis, _dir);
				_dir += _bend;
			}
			
			_lag = true;
		}
	}
	
	if(_lag && lag) trace_time(script[2]);
	
#define pickup_alarm(_time, _loopDecay)
	/*
		Returns the alarm0 to set on a pickup, affected by loop and crown of haste
		
		Args:
			time      - The pickup's base alarm value
			loopDecay - The percentage decay per loop
	*/
	
	 // Loop:
	_time /= 1 + (GameCont.loops * _loopDecay);
	
	 // Haste:
	if(crown_current == crwn_haste){
		_time /= (instance_is(self, BigRad) ? 2 : 3);
	}
	
	return _time;
	
#define pickup_text(_text, _num)
	/*
		Creates a PopupText with the given text, with all mentions of '%' in the text replaced by the given number
		If called from a Player it will only appear on their screen
	*/
	
	with(instance_create(x, y, PopupText)){
		text = string_replace_all(_text, "%", ((_num < 0) ? "" : "+") + string(_num));
		
		 // Target Player's Screen:
		if(instance_is(other, Player)){
			target = other.index;
		}
		
		return id;
	}
	
	return noone;
	
#define bonus_pickup_replace(_levelStart)
	/*
		Replaces pickups and chests with their bonus versions
	*/
	
	with(instances_matching([Pickup, chestprop, Mimic, SuperMimic], "bonus_pickup_check", null)){
		bonus_pickup_check = false;
		
		if(!position_meeting(xstart, ystart, ChestOpen)){
			var _bonusCrown = (crown_current == "bonus");
			
			if(GameCont.hard > 4 || _bonusCrown){
				var	_isAmmo = false,
					_isHP   = false;
					
				 // Replace Ammo:
				if(
					(instance_is(self, AmmoPickup) && sprite_index == sprAmmo)                                                               ||
					(instance_is(self, AmmoChest)  && array_exists([sprAmmoChest, sprAmmoChestSteroids, sprAmmoChestMystery], sprite_index)) ||
					(instance_is(self, Mimic)      && spr_idle == sprMimicIdle)
				){
					bonus_pickup_check = true;
					_isAmmo = true;
				}
				
				 // Replace HP:
				else if(_bonusCrown){
					if(
						(instance_is(self, HPPickup)    && sprite_index == sprHP)          ||
						(instance_is(self, HealthChest) && sprite_index == sprHealthChest) ||
						(instance_is(self, SuperMimic)  && spr_idle == sprSuperMimicIdle)
					){
						bonus_pickup_check = true;
						_isHP = true;
					}
				}
				
				 // Bonus Time:
				if(bonus_pickup_check){
					var	_chest = "",
						_force = (_bonusCrown && _levelStart);
						
					 // Bonus Ammo:
					if(_isAmmo || (_chest == "" && !_force)){
						var	_ammoPick  = [0, 32, 8, 7, 6, 10],
							_ammoNum   = 0,
							_ammoMax   = 0,
							_ammoMin   = 0,
							_wepTotal  = 0,
							_wepChance = 0;
							
						 // Determine Spawn Chance:
						with(Player){
							with([wep, bwep]){
								var _wep = self;
								with(other){
									var _type = weapon_get_type(_wep);
									
									 // Encourage Weapons Closer to Full Ammo:
									_ammoMax++;
									if(_type > 0){
										_ammoMin += min(1, (((_type < array_length(_ammoPick)) ? _ammoPick[_type] : typ_ammo[_type]) * 3) / typ_amax[_type]);
										_ammoNum += min(1, ammo[_type] / typ_amax[_type]);
									}
									else{
										_ammoMin += 1/3;
										_ammoNum += 1/4;
									}
									
									 // Encourage Ammo Intensive Weapons:
									if(_wep != wep_none){
										var _cost = weapon_get_cost(_wep) / ((_type == 1) ? 3 : 1);
										if(is_object(_wep) && "wep" in _wep && "ammo" in _wep && "cost" in _wep && is_string(_wep.wep)){
											_cost += _wep.cost;
										}
										
										_wepTotal++;
										_wepChance += min(1, (_cost / min(90, weapon_get_load(_wep))) * 1.5);
									}
								}
							}
						}
						
						 // Replace:
						if(chance(_ammoNum - _ammoMin, _ammoMax - _ammoMin) || _bonusCrown || _force){
							if(chance(_wepChance * (1 + _bonusCrown), _wepTotal) || _force){
								_chest = "BonusAmmo";
							}
						}
					}
					
					 // Bonus HP:
					if(_isHP || (_chest == "" && !_force)){
						var	_HP      = 0,
							_HPMax   = 0,
							_HPBonus = 0;
							
						 // Determine Max HP:
						with(Player){
							_HP    += max(0, my_health);
							_HPMax += max(0, max(my_health, maxhealth));
							
							if("bonus_health" in self){
								_HPBonus += max(0, bonus_health);
							}
						}
						
						 // Replace:
						if(_HP >= _HPMax || _bonusCrown || _force){
							if(chance(1 * (1 + _bonusCrown), 4 * (4 + ((_HPMax + _HPBonus) / instance_number(Player)))) || _force){
								_chest = "BonusHealth";
							}
						}
					}
					
					 // Replace:
					if(_chest != ""){
						if(instance_is(self, Pickup)){
							obj_create(x, y, _chest + "Pickup");
						}
						else if(instance_is(self, chestprop) || instance_is(self, RadChest)){
							chest_create(x, y, _chest + "Chest", _levelStart);
						}
						else if(instance_is(self, enemy)){
							chest_create(x, y, _chest + "Mimic", _levelStart);
						}
						instance_delete(id);
					}
					else if(_bonusCrown){
						instance_delete(id);
					}
				}
			}
		}
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
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define pround(_num, _precision)                                                        return  (_num == 0) ? _num : round(_num / _precision) * _precision;
#define pfloor(_num, _precision)                                                        return  (_num == 0) ? _num : floor(_num / _precision) * _precision;
#define pceil(_num, _precision)                                                         return  (_num == 0) ? _num :  ceil(_num / _precision) * _precision;
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
#define chest_create(_x, _y, _obj, _levelStart)                                         return  mod_script_call_nc('mod', 'telib', 'chest_create', _x, _y, _obj, _levelStart);
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
#define enemy_walk(_spdAdd, _spdMax)                                                            mod_script_call(   'mod', 'telib', 'enemy_walk', _spdAdd, _spdMax);
#define enemy_hurt(_hitdmg, _hitvel, _hitdir)                                                   mod_script_call(   'mod', 'telib', 'enemy_hurt', _hitdmg, _hitvel, _hitdir);
#define enemy_shoot(_x, _y, _object, _dir, _spd)                                        return  mod_script_call(   'mod', 'telib', 'enemy_shoot', _x, _y, _object, _dir, _spd);
#define enemy_target(_x, _y)                                                            return  mod_script_call(   'mod', 'telib', 'enemy_target', _x, _y);
#define boss_hp(_hp)                                                                    return  mod_script_call_nc('mod', 'telib', 'boss_hp', _hp);
#define boss_intro(_name)                                                               return  mod_script_call_nc('mod', 'telib', 'boss_intro', _name);
#define corpse_drop(_dir, _spd)                                                         return  mod_script_call(   'mod', 'telib', 'corpse_drop', _dir, _spd);
#define rad_drop(_x, _y, _raddrop, _dir, _spd)                                          return  mod_script_call_nc('mod', 'telib', 'rad_drop', _x, _y, _raddrop, _dir, _spd);
#define rad_path(_inst, _target)                                                        return  mod_script_call_nc('mod', 'telib', 'rad_path', _inst, _target);
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
#define wep_get(_wep)                                                                   return  mod_script_call_nc('mod', 'telib', 'wep_get', _wep);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc('mod', 'telib', 'wep_merge', _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call_nc('mod', 'telib', 'wep_merge_decide', _hardMin, _hardMax);
#define weapon_decide(_hardMin, _hardMax, _gold, _noWep)                                return  mod_script_call(   'mod', 'telib', 'weapon_decide', _hardMin, _hardMax, _gold, _noWep);
#define weapon_get_red(_wep)                                                            return  mod_script_call(   'mod', 'telib', 'weapon_get_red', _wep);
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
#define prompt_create(_text)                                                            return  mod_script_call(   'mod', 'telib', 'prompt_create', _text);
#define alert_create(_inst, _sprite)                                                    return  mod_script_call(   'mod', 'telib', 'alert_create', _inst, _sprite);
#define door_create(_x, _y, _dir)                                                       return  mod_script_call_nc('mod', 'telib', 'door_create', _x, _y, _dir);
#define charm_instance(_inst, _charm)                                                   return  mod_script_call_nc('mod', 'telib', 'charm_instance', _inst, _charm);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   'mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define move_step(_mult)                                                                return  mod_script_call(   'mod', 'telib', 'move_step', _mult);
#define pool(_pool)                                                                     return  mod_script_call_nc('mod', 'telib', 'pool', _pool);