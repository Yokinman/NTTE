#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.sav = mod_variable_get("mod", "teassets", "sav");
    
    global.debug_lag = false;
    
    global.pickup_custom = [];

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)

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
		on_open = script_ref_create(Backpack_open);
		on_step = script_ref_create(Backpack_step);

		return id;
	}
	
#define Backpack_step
	 // Curse FX:
	if(chance_ct(curse, 20)){
		instance_create(x + orandom(8), y + orandom(8), Curse);
	}

#define Backpack_open
	if(curse) sound_play(sndCursedChest);
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
		var _refinedTaste = (ultra_get("robot", 1) * 4),
			_part = wep_merge_decide(_refinedTaste, max(GameCont.hard, _refinedTaste) + (curse ? 2 : 0));
		if(array_length(_part) >= 2){
			repeat(1 + ultra_get("steroids", 1)){
				with(instance_create(x, y, WepPickup)){
					wep = wep_merge(_part[0], _part[1]);
					curse = other.curse;
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
		with(obj_create(x, y, "BackpackPickup")){
			direction = d;
			curse = other.curse;
			if(curse && object == AmmoPickup){
				sprite_index = sprCursedAmmo;
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


#define BackpackPickup_create(_x, _y)
	instance_create(_x, _y, Dust);
	with(instance_create(_x, _y, CustomObject)){
		 // Determine Pickup:
		var _objMin = instance_create(0, 0, GameObject),
			_obj = AmmoPickup,
			_spr = sprAmmo,
			_msk = mskPickup;

		instance_delete(_objMin);
		pickup_drop(10000, 0);
		with(instances_matching_gt([Pickup, chestprop], "id", _objMin)){
			_obj = object_index;
			_spr = sprite_index;
			_msk = mask_index;

			if(instance_is(self, AmmoPickup)){
				 // Portal Strikes:
				for(var i = 0; i < maxp; i++) if(player_get_race(i) == "rogue"){
					if(chance(1, 5)){
						_obj = RoguePickup;
						_spr = sprRogueAmmo;
					}
					break;
				}

				 // Fix Cursed Ammo:
				if(cursed) _spr = sprAmmo;
			}

			instance_delete(id);
		}

		 // wtf this isnt a pickup:
		if(chance(1, 40)){
			_obj = Bandit;
			_spr = sprBanditHurt;
			_msk = mskBandit;
		}

		 // Visual:
		sprite_index = _spr;
		image_speed = 0.4;
		depth = -3;

		 // Vars:
		object = _obj;
		mask_index = _msk;
        z = 0;
        zspeed = random_range(2, 4);
        zfric = 0.7;
        curse = false;
		direction = random(360);
		speed = random_range(1, 3);

		return id;
	}

#define BackpackPickup_step
	 // Collision:
	if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
		if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
		if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
	}

	z_engine();
	if(z <= 0) instance_destroy();

#define BackpackPickup_draw
	image_alpha = abs(image_alpha);
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	image_alpha = -image_alpha;

#define BackpackPickup_destroy
	with(instance_create(x, y - z, object)){
		xstart = other.xstart;
		ystart = other.ystart;
		sprite_index = other.sprite_index;
		direction = other.direction;
		speed = other.speed;
		if("curse" in self) curse = other.curse;
		if("cursed" in self) cursed = other.curse; // Bro why do ammo pickups be inconsistent
	    bonuspickup_spawn = false; // Bro I feel u
	}


#define BatChest_create(_x, _y)
	with(obj_create(_x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.BatChest;
		spr_dead = spr.BatChestOpen;
		
		 // Sound:
		snd_open = sndWeaponChest;

		 // Cursed:
		switch(crown_current){
			case crwn_none:		curse = false;			break;
			case crwn_curses:	curse = chance(2, 3);	break;
			default:			curse = chance(1, 7);
		}
		if(curse) snd_open = sndCursedChest;

		 // Events:
		on_open = script_ref_create(BatChest_open);
		//on_step = script_ref_create(BatChest_step);
		
		return id;
	}

#define BatChest_step
	 // Curse FX:
	if(chance_ct(curse, 16)){
		instance_create(x + orandom(8), y + orandom(8), Curse);
	}
	
#define BatChest_open
	instance_create(x, y, PortalClear);

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
	var o = 50,
		_shop = [];

	for(var a = -o; a <= o; a += o){
		var l = 28,
			d = a + 90;

		with(obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "ChestShop")){
			type = ChestShop_wep;
			drop = wep_screwdriver;
			curse = other.curse;
			creator = _open;
			array_push(_shop, id);
		}
	}

	 // Determine Weapons:
	var _part = wep_merge_decide(0, GameCont.hard + (curse ? 2 : 0));
	if(array_length(_part) >= 2){
         // Set Weps:
        _shop[2].drop = ((_part[0].weap == -1) ? _part[0] : _part[0].weap);
        _shop[0].drop = ((_part[1].weap == -1) ? _part[1] : _part[1].weap);
		_shop[1].drop = wep_merge(_part[0], _part[1]);

		 // Color:
		if(curse){
			with(_shop) image_blend = make_color_rgb(255, 0, 40);
			_shop[1].image_blend = make_color_rgb(255, 0, 255);
		}
		else{
			with(_shop) image_blend = c_lime;
			_shop[1].image_blend = c_yellow;
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

	 // Randomize Items:
	var _pool = ["ammo", "health", "bonus_ammo", "bonus_health"];
	with(Player){
		switch(race){
			case "horror":	array_push(_pool, "rads");		break;
			case "rogue":	array_push(_pool, "rogue");		break;
			case "parrot":	array_push(_pool, "parrot");	break;
		}
	}
	// if(chance(1, 5)) array_push(_pool, "spirit");
	with(["wep", "bwep"]){
		var w = self;
		with(Player) if(wep_get(variable_instance_get(id, w)) == "scythe"){
			array_push(_pool, "bones");
		}
	}
	switch(crown_current){
		case crwn_life:
			while(true){
				var i = array_find_index(_pool, "ammo");
				if(i >= 0) _pool[i] = "health";
				else break;
			}
			break;

		case crwn_guns:
			while(true){
				var i = array_find_index(_pool, "health");
				if(i >= 0) _pool[i] = "ammo";
				else break;
			}
			break;
	}
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
		image_blend = c_aqua;
		image_alpha = 0.7;
		depth = -8;

		 // Vars:
		mask_index = mskWepPickup;
		friction = 0.4;
		creator = noone;
		pickup_indicator = noone;
		shine = true;
		shine_speed = 0.025;
		open_state = 0;
		open = true;
		wave = random(100);
		type = ChestShop_basic;
		drop = 0;
		text = "";
		desc = "";
		curse = false;

		 // Alarms:
		alarm0 = 1;

		return id;
	}
	
#define ChestShop_step
	wave += current_time_scale;

	 // Shine Delay:
	if(shine && image_index < 1){
		image_index -= image_speed;
		image_index += image_speed * random(shine_speed) * current_time_scale;
	}

	 // Particles:
	if(instance_exists(creator) && chance_ct(1, 8 * (open ? 1 : open_state))){
		var _x = creator.x,
			_y = creator.y,
			l = point_distance(_x, _y, x, y),
			d = point_direction(_x, _y, x, y) + orandom(8);

		if(open) l = random(l);
		else l = random_range(l * (1 - open_state), l);

		with(instance_create(_x + lengthdir_x(l, d) + orandom(4), _y + lengthdir_y(l, d) + orandom(4), BulletHit)){
			motion_add(d + choose(0, 180), random(0.5));
			sprite_index = sprLightning;
			image_blend = other.image_blend;
			image_alpha = 1.5 * (l / point_distance(_x, _y, other.x, other.y)) * random(abs(other.image_alpha));
			image_angle = random(360);
			depth = other.depth - 1;
		}
	}

	 // Open for Business:
	var _pickup = pickup_indicator;
	if(instance_exists(_pickup)) _pickup.visible = open;
	if(open){
		open_state += (1 - open_state) * 0.15 * current_time_scale;

		 // No Customers:
		if(!instance_exists(Player) && open_state >= 1){
			open = false;
		}

		 // Take Item:
		if(instance_exists(_pickup)){
			var p = player_find(_pickup.pick);
			if(instance_exists(p)){
				var _x = x,
					_y = y;

				if(instance_exists(creator)){
					_x = creator.x;
					_y = creator.y - 4;
				}

				switch(type){
					case ChestShop_basic:
						switch(drop){
							case "ammo":
								repeat(2){
									instance_create(_x + orandom(2), _y + orandom(2), AmmoPickup);
								}
								break;

							case "health":
								repeat(2){
									instance_create(_x + orandom(2), _y + orandom(2), HPPickup);
								}
								break;

							case "rads":
								rad_drop(_x, _y, 25, random(360), 4);
								with(creator) depth++; depth--;
								break;

							case "bonus_ammo":
								obj_create(_x, _y, "OverstockPickup");
								instance_create(_x, _y, GunWarrantEmpty);
								break;
								
							case "bonus_health":
							    obj_create(_x, _y, "OverhealPickup");
							    instance_create(_x, _y, GunWarrantEmpty);
							    break;

							case "rogue":
								with(instance_create(_x + orandom(2), _y + orandom(2), RoguePickup)){
									motion_add(point_direction(x, y, p.x, p.y), 3);
								}
								break;

							case "parrot":
								obj_create(_x, _y, "ParrotChester");
								break;

							case "infammo":
								with(p){
									infammo = 90;
									reload = max(reload, 1);
								}
								break;
								
							case "bones":
								repeat(2) with(obj_create(_x, _y, "BoneBigPickup")){
									motion_set(random(360), 3 + random(1));
								}
								repeat(10) with(obj_create(_x, _y, "BonePickup")){
									motion_set(random(360), 3 + random(1));
								}
								break;
								
							case "spirit":
								obj_create(_x, _y, "SpiritPickup");
								instance_create(_x, _y, ImpactWrists);
								break;
						}
						
						 // Effects:
						sound_play_pitchvol(sndGunGun, 1.2 + random(0.4), 0.5);
						sound_play_pitchvol(sndAmmoChest, 0.5 + random(0.2), 0.8);
						instance_create(_x, _y, WepSwap);
						break;

					case ChestShop_wep:
						repeat(1 + ultra_get("steroids", 1)){
							with(instance_create(_x, _y, WepPickup)){
								motion_set(point_direction(x, y, p.x, p.y) + orandom(8), 5);
								wep = other.drop;
								curse = other.curse;
								ammo = true;
								roll = true;
							}

							 // Sounds:
							sound_play(weapon_get_swap(drop));
							sound_play_pitchvol(sndGunGun, 0.8 + random(0.4), 0.6);
							sound_play_pitchvol(sndPlasmaBigExplode, 0.6 + random(0.2), 0.8);
					
							 // Effects:
							instance_create(_x, _y, GunGun);
						}
						break;
				}

				instance_create(p.x, p.y, PopupText).text = text;
				instance_create(p.x, p.y, PopupText).text = desc;

				 // Sounds:
			    sound_play_pitchvol(sndGammaGutsProc, 1.4 + random(0.1), 0.6);

				 // Remove other options:
				with(instances_matching(instances_matching(object_index, "name", name), "creator", creator)){
					open = false;
					open_state += random(1/3);
				}
				open_state = 3/4;
				
				 // Crown Time:
				with(instances_matching(Crown, "ntte_crown", "crime")){
					enemy_time = 30;
					enemies += (1 + GameCont.loops) + irandom(3);
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
		_xsc = image_xscale * max(open * 0.8, _openState),
		_ysc = image_yscale * max(open * 0.8, _openState),
		_ang = image_angle + (8 * sin(wave / 12)),
		_col = merge_color(c_black, image_blend, _openState),
		_alp = image_alpha,
		_x = x,
		_y = y;

	 // Projector Beam:
	if(instance_exists(creator)){
		var	_sx = creator.x,
			_sy = creator.y,
			d = point_direction(_sx, _sy, _x, _y);

		//d += angle_difference(90, d) * (1 - clamp(open_state, 0, 1));

		var	w = point_distance(_sx, _sy, _x, _y) * (open ? _openState : min(_openState * 3, 1)),
			h = ((sqrt(sqr(sprite_get_width(_spr) * dsin(d)) + sqr(sprite_get_height(_spr) * dcos(d))) * 2/3) + random(2)) * max(0, (_openState - 0.5) * 2),
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

#define ChestShop_alrm0
	 // Shop Setup:
	switch(type){
		case ChestShop_basic:
			switch(drop){
				case "ammo":
					sprite_index = sprAmmo;
					image_blend = c_yellow;
					text = "AMMO";
					desc = "2 PICKUPS";
					break;

				case "health":
					sprite_index = sprHP;
					image_blend = c_white;
					text = "HEALTH";
					desc = "2 PICKUPS";
					break;

				case "rads":
					sprite_index = sprBigRad;
					image_blend = c_lime;
					text = "RADS";
					desc = "RADS";
					break;

				case "bonus_ammo":
					sprite_index = spr.OverstockPickup;
					text = "OVERSTOCK";
					desc = "BONUS AMMO";
					break;
					
				case "bonus_health":
					sprite_index = spr.OverhealPickup;
					text = "OVERHEAL";
					desc = "BONUS HEALTH";
					break;

				case "rogue":
					sprite_index = sprRogueAmmo;
					text = "PORTAL STRIKE";
					desc = "PORTAL STRIKE";
					break;

				case "parrot":
					sprite_index = spr.Parrot[0].Feather;
					image_blend = make_color_rgb(200, 0, 0);
					text = "FEATHERS";
					desc = "FEATHERS";
					break;

				case "infammo":
					sprite_index = sprFishA;
					text = "INFINITE AMMO";
					desc = "FOR A MOMENT";
					shine = false;
					break;
					
				case "bones":
					sprite_index = spr.BonePickupBig[0];
					image_blend = c_yellow;
					text = "BONES";
					desc = "BONES";
					break;
					
				case "spirit":
					sprite_index = spr.SpiritPickup;
					image_blend = merge_color(c_yellow, c_white, 0.75);
					text = "BONUS SPIRIT";
					desc = "LIVE FOREVER";
					break;

				default:
					sprite_index = sprAmmo;
					break;
			}
			break;

		case ChestShop_wep:
			sprite_index = weapon_get_sprt(drop);

			text = (curse ? "CURSED " : "") + ((wep_get(drop) == "merge") ? "MERGED " : "") + "WEAPON";
			desc = weapon_get_name(drop);
			break;
	}

	pickup_indicator = scrPickupIndicator(text + "#@s" + desc);


#define CursedAmmoChest_create(_x, _y)
	with(obj_create(_x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.CursedAmmoChest;
		spr_dead = spr.CursedAmmoChestOpen;
		spr_shadow_y = -2;

		 // Sound:
		snd_open = sndAmmoChest;

		on_open = script_ref_create(CursedAmmoChest_open);
		
		return id;
	}

#define CursedAmmoChest_open
	sound_play(sndCursedChest);
	instance_create(x, y, PortalClear);
	instance_create(x, y, ReviveFX);
	repeat(10){
		with(obj_create(x + orandom(4), y + orandom(4), "BackpackPickup")){
			sprite_index = sprCursedAmmo;
			mask_index = mskPickup;
			object = AmmoPickup;
			curse = true;

			var s = random_range(1.5, 2);
			speed *= s;
			zspeed *= s - 0.5;

			with(instance_create(x, y, Curse)){
				depth = other.depth - 1;
				motion_add(other.direction, random(s));
			}
		}
	}

#define CustomChest_create(_x, _y)
    with(instance_create(_x, _y, chestprop)){
         // Visual:
        sprite_index = sprAmmoChest;
        spr_dead = sprAmmoChestOpen;

         // Sound:
        snd_open = sndAmmoChest;

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
    	time -= ((time > 2 && crown_current == crwn_haste) ? 3 : 1) * current_time_scale;
		if(time <= 0){
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
		on_open = script_ref_create(OverhealPickup_open);
		on_step = script_ref_create(BonusPickup_step);
		on_pull = script_ref_create(BonusPickup_pull);
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
	sound_play_pitch(sndRogueCanister, 1.3);
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
		on_open = script_ref_create(OverstockPickup_open);
		on_step = script_ref_create(BonusPickup_step);
		on_pull = script_ref_create(BonusPickup_pull);
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
		ammo_bonus_hold = array_clone(ammo);

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
        
         // Sounds:
        snd_open = sndAmmoPickup;
        snd_fade = sndStrongSpiritLost;
        
         // Vars:
        mask_index = mskPickup;
		pull_dis = 30 + (30 * skill_get(mut_plutonium_hunger));
		pull_spd = 4;
        nextpull = current_frame + 9;
        wave = random(90);
        num = 1 + (crown_current == crwn_haste);
        
         // Events:
        on_open = script_ref_create(SpiritPickup_open);
        on_fade = script_ref_create(SpiritPickup_fade);
        on_pull = script_ref_create(SpiritPickup_pull);
        on_step = script_ref_create(SpiritPickup_step);
        on_draw = script_ref_create(SpiritPickup_draw);
        
        return id;
    }
   
#define SpiritPickup_step
    wave += current_time_scale;

#define SpiritPickup_draw
    draw_sprite(sprHalo, 0, x, ((y + 3) + sin(wave * 0.1)));

#define SpiritPickup_open
	 // Restore Missing Strong Spirit (BORING):
	var n = num;
	with(other){
		
		 // Acquire Bonus Spirit:
		if(n >= 1){
			if("bonus_spirit" not in self) bonus_spirit = [];
			
			repeat(n) array_push(bonus_spirit, bonusSpiritGain);
			sound_play(sndStrongSpiritGain);
			
			with(instance_create(x, y, PopupText)){
				mytext = `+${n} @yBONUS @wSPIRIT${n > 1 ? "S" : ""}`;
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
    instance_create(x, y, StrongSpirit);
    
#define SpiritPickup_pull
	return (nextpull <= current_frame);

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
		spr_dead = spr.SunkenChestOpen;
		sprite_index = spr.SunkenChest;
		
		 // Sounds:
		snd_open = sndMenuGoldwep;
		
		 // Events:
		on_open = script_ref_create(SunkenChest_open);
		
		return id;
	}
	
#define SunkenChest_open
	 // Unlocks:
	var _areas = ["coast", "oasis"];
	for(var i = 0; i < array_length(_areas); i++) if(GameCont.area == _areas[i])
		scrUnlock("part " + string(i + 1) + "/2", "it would be cool", -1, -1);


/// Mod Events

#define draw_bonus_spirit
	with(Player){
		var n = array_length(bonus_spirit);
		if(n > 0){
			for(var i = 0; i < n; i++){
				var _naturalSpirit = (skill_get(mut_strong_spirit) && canspirit),
					_x = x, // too lazy to make them wobble, sorry jsburg
					_y = y - (7 * (i + _naturalSpirit)) + sin(wave * 0.1);
					
				draw_sprite(bonus_spirit[i].sprite, bonus_spirit[i].index, _x, _y);
			}
		}
	}
	
	 // Goodbye Bro:
	instance_destroy();

#macro bonusSpiritGain {sprite : sprStrongSpiritRefill, index : 0, active : true}
#macro bonusSpiritLose {sprite : sprStrongSpirit,		index : 0, active : false}
#define step
    if(DebugLag) trace_time();
    
     // Bonus Spirits:
    with(Player){
    	if("bonus_spirit" not in self) bonus_spirit = [];
    	script_bind_draw(draw_bonus_spirit, -12);
    	
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
	    	s = 0.4;
	    for(var i = 1; i >= 0; i--){
	    	with(_spirits[i]){
	    		
	    		 // you may pass:
	    		var o = self;
	    		if(sprite != mskNone){
		    		index += s;
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

#define draw_dark // Drawing Grays
    draw_set_color(c_gray);
    
    if(DebugLag) trace_time();
    
     // Bonus Pickups:
    with(instances_matching(Pickup, "name", "OverhealPickup", "OverstockPickup")) if(visible){
        draw_circle(x, y, 48 + random(2), false);
    }
    
    if(DebugLag) trace_time("tepickups_draw_dark");

#define draw_dark_end // Drawing Clears
    draw_set_color(c_black);
    
    if(DebugLag) trace_time();
    
     // Bonus Pickups:
    with(instances_matching(Pickup, "name", "OverhealPickup", "OverstockPickup")) if(visible){
        draw_circle(x, y, 16 + random(2), false);
    }
    
    if(DebugLag) trace_time("tepickups_draw_dark_end");


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
#define draw_trapezoid(_x1a, _x2a, _y1, _x1b, _x2b, _y2)                                        mod_script_call_nc("mod", "telib", "draw_trapezoid", _x1a, _x2a, _y1, _x1b, _x2b, _y2);
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
#define draw_set_flat(_color)                                                                   mod_script_call_nc("mod", "telib", "draw_set_flat", _color);
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
#define sound_play_hit_ext(_sound, _pitch, _volume)                                     return  mod_script_call_nc("mod", "telib", "sound_play_hit_ext", _sound, _pitch, _volume);
#define area_get_secret(_area)                                                          return  mod_script_call_nc("mod", "telib", "area_get_secret", _area);
#define area_get_underwater(_area)                                                      return  mod_script_call_nc("mod", "telib", "area_get_underwater", _area);
#define path_shrink(_path, _wall, _skipMax)                                             return  mod_script_call_nc("mod", "telib", "path_shrink", _path, _wall, _skipMax);
#define path_direction(_x, _y, _path, _wall)                                            return  mod_script_call_nc("mod", "telib", "path_direction", _x, _y, _path, _wall);
#define rad_drop(_x, _y, _raddrop, _dir, _spd)                                          return  mod_script_call_nc("mod", "telib", "rad_drop", _x, _y, _raddrop, _dir, _spd);
#define rad_path(_inst, _target)                                                        return  mod_script_call_nc("mod", "telib", "rad_path", _inst, _target);
#define area_get_name(_area, _subarea, _loop)                                           return  mod_script_call_nc("mod", "telib", "area_get_name", _area, _subarea, _loop);
#define draw_text_bn(_x, _y, _string, _angle)                                                   mod_script_call_nc("mod", "telib", "draw_text_bn", _x, _y, _string, _angle);