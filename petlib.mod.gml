#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	mus = mod_variable_get("mod", "teassets", "mus");
	sav = mod_variable_get("mod", "teassets", "sav");
	
	DebugLag = false;
	
	surfWeb = surflist_set("Web", 0, 0, game_width, game_height);
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

#macro surfWeb global.surfWeb

#macro pet_target_inst instances_matching_ne(instances_matching_ne([enemy, Player, Sapling, Ally, SentryGun, CustomHitme], "team", team, 0), "mask_index", mskNone)

#define CoolGuy_create
	 // Visual:
	spr_shadow = shd16;
	spr_shadow_y = 4;

	 // Vars:
	maxspeed = 3.5;
	poop = 1;
	poop_delay = 0;
	combo = 0;
	combo_text = noone;
	combo_texty = 0;
	combo_delay = 0;
	kills_last = GameCont.kills;
	
	 // Stat:
	if("combo" not in stat) stat.combo = 0;

#define CoolGuy_ttip
	return ["JUST A COOL GUY", "BRO", "HIGH SCORE!", "BACKWARD CAPS ARE COOL"];

#define CoolGuy_stat(_name, _value)
	if(_name == "") return spr.PetCoolGuyIdle;

#define CoolGuy_step
	 // Kill Combos:
	if(instance_exists(leader) && GameCont.kills > kills_last){
		combo += (GameCont.kills - kills_last);
		combo_delay = 40;
	}
	kills_last = GameCont.kills;
	
	 // Combo Counter:
	if(combo >= 2){
		 // Combo Color:
		var	c = [c_white, make_color_rgb(255, 230, 70), make_color_rgb(50, 210, 255), make_color_rgb(255, 110, 25), make_color_rgb(255, 110, 150)],
			_lvl = max(0, floor(combo / 10)),
			_col;
			
		if(_lvl < array_length(c)){
			_col = c[_lvl];
		}
		else{
			_col = c[(wave * (combo / 150)) % array_length(c)];
		}
		
		 // Text:
		var	_off = round(min(3, floor(combo / 5))),
			_x = x + hspeed_raw + orandom(_off),
			_y = y + vspeed_raw + orandom(_off) - 8 + combo_texty,
			_text = `x${combo}`;
			
		if(_lvl >= array_length(c)){
			_text = "COMBO#" + _text;
		}
		if(combo > stat.combo){
			_text += "!";
		}
		
		if(!instance_exists(combo_text)){
			combo_text = instance_create(0, 0, PopupText);
		}
		with(combo_text){
			text = _text;
			alarm1 = 15;
			alarm2 = -1;
			event_perform(ev_alarm, 2);
			if(_col != c_white || _lvl >= array_length(c)){
				text = `@(color:${_col})#` + text;
			}
			
			x = _x;
			y = _y - (string_height(text) - 8);
			speed = 0;
		}
		
		combo_texty += (-8 - combo_texty) * 0.5 * current_time_scale;
	}
	else{
		combo_text = noone;
		combo_texty = 0;
	}
	
	 // Combo End:
	if(combo_delay > 0) combo_delay -= current_time_scale;
	else{
		if(combo > 0){
			 // Launch Combo Text:
			with(combo_text){
				vspeed = -4.5;
				friction = 1/3;
				time += (other.combo / 5);
			}
			if(combo >= 10){
				sound_play_pitchvol(sndCrownNo, 1.4, 0.5 + (combo / 50));
				sound_play_pitchvol((combo >= 50) ? sndLevelUltra : sndLevelUp, 0.8, (combo / 25));
			}
			
			 // Highscore!
			if(combo > stat.combo){
				stat.combo = combo;
				if(combo >= 10){
					with(combo_text) text += "@w#NEW RECORD";
				}
			}
			
			 // Poop Time:
			var _add = floor(combo / 5);
			if(_add > 0){
				if(poop <= 0){
					poop_delay = 30;
					alarm0 = poop_delay + 10;
				}
				poop += _add;
			}
		}
		combo = 0;
	}
	
	 // Poopin'
	if(!instance_exists(leader)) poop_delay = 30;
	if(poop_delay > 0){
		poop_delay -= current_time_scale;
	}
	else if(poop > 0){
		 // Delicious Pizza Juices:
		repeat(4){
			with(scrFX(x + orandom(2), y + 1, 1, "WaterStreak")){
				hspeed = 2 * -other.right;
				image_angle = direction;
				image_blend = make_color_rgb(255, 120, 25);
				image_xscale /= 2;
				image_yscale /= 2;
				depth = -1;
			}
		}
		if(poop >= 2){
			repeat(poop / 2){
				with(scrFX(x, y, 1, Dust)){
					sprite_index = sprBreath;
					image_index = irandom(4);
					image_blend = make_color_rgb(255, 105, 10);
					hspeed -= random(2) * other.right;
					vspeed += orandom(other.poop / 12);
					image_angle = direction + 180;
					image_xscale *= 2;
					image_yscale *= 2;
					growspeed /= 2;
					rot /= 2;
				}
			}
		}
		sound_play_pitchvol(sndHPPickup,        0.8 + random(0.2), 0.8);
		sound_play_pitchvol(sndFrogExplode,     1.2 + random(0.8), 0.8);
		
		 // Determine Pizza Output:
		var o;
		if(chance(1, 2) && !chance(4, poop)){
			o = "PizzaChest";
			poop -= 2;
		}
		else if(poop >= 2 && chance(1, 3)){
			o = "PizzaStack";
			poop -= 2;
		}
		else{
			o = "Pizza";
			poop--;
		}
		
		 // Excrete:
		with(obj_create(x + orandom(4), y + orandom(4), o)){
			hspeed = 3 * -other.right;
			vspeed = orandom(1);
			if(instance_is(self, prop)){
				x += hspeed;
				y += vspeed;
			}
			if(!instance_is(self, HPPickup)){
				sound_play_pitchvol(sndEnergyHammerUpg, 1.4 + random(0.2), 0.4);
			}
		}
		hspeed += min(poop + 1, 4) * right;
		
		poop_delay = 8 / max(1, poop);
	}
	
	 // He just keep movin
	if(poop <= 0 || poop_delay > 10) speed = maxspeed;
	if(array_length(path) <= 0){
		with(path_wall) with(other){
			if(place_meeting(x + hspeed_raw, y + vspeed_raw, other)){
				if(place_meeting(x + hspeed_raw, y, other)) hspeed_raw *= -1;
				if(place_meeting(x, y + vspeed_raw, other)) vspeed_raw *= -1;
			}
		}
	}
	scrRight(direction);
	
#define CoolGuy_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	 // Poopy Shake:
	if(poop > 0 && poop_delay < 20){
		_x += sin(wave * 5) * 1.5;
	}
	
	 // Self:
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
	
#define CoolGuy_alrm0(_leaderDir, _leaderDis)
	 // Follow Leader Around:
	if(instance_exists(leader)){
		if(_leaderDis > 24){
			 // Pathfinding:
			if(path_dir != null){
				if(chance(1, 3)) direction = path_dir + orandom(20);
				else direction += angle_difference(path_dir, direction) / 2;
			}
			
			 // Turn Toward Leader:
			else direction += angle_difference(_leaderDir, direction) / 2;
		}
		else direction += orandom(16);
		scrRight(direction);
		
		return 8;
	}
	
	 // Idle Movement:
	else{
		direction += orandom(16);
		scrRight(direction);
		
		return 10 + random(10);
	}
	
	
#define Orchid_create
	 // Vars:
	raddrop = 0;
	skill_rads = 60;
	skill_time = 450;
	skill_inst = noone;
	
	 // Stat:
	if("mutations" not in stat) stat.mutations = 0;
	
#define Orchid_ttip
	return ["ELEGANT", "FLORID"];
	
#define Orchid_stat(_name, _value)
	if(_name == "") return spr.PetOrchidIdle;
	
#define Orchid_step
	 // Mutate:
	if(raddrop >= skill_rads && instance_exists(enemy)){
		raddrop -= skill_rads;
		
		 // Stat:
		stat.mutations++;
		
		 // Compile Ungotten Skills:
		var _skillList = [];
		for(var i = mut_rhino_skin; i <= mut_heavy_heart; i++){
			if(skill_get_active(i) && skill_get(i) == 0){
				if(i != mut_patience && (i != mut_heavy_heart || GameCont.wepmuts >= 3)){
					array_push(_skillList, i);
				}
			}
		}
		with(mod_get_names("skill")){
			if(skill_get_active(self) && skill_get(self) == 0){
				if(!mod_script_exists("skill", self, "skill_avail") || mod_script_call_nc("skill", self, "skill_avail")){
					array_push(_skillList, self);
				}
			}
		}
		
		 // Already Have Everything, +1 to Random Skill:
		if(array_length(_skillList) <= 0){
			for(var i = 0; !is_undefined(skill_get_at(i)); i++){
				var _at = skill_get_at(i);
				if(_at != mut_patience && _at != mut_last_wish){
					if(!is_string(_at) || !mod_script_exists("skill", _at, "skill_avail") || mod_script_call_nc("skill", _at, "skill_avail")){
						array_push(_skillList, _at);
					}
				}
			}
		}
		
		 // Give Random Mutation:
		skill_inst = Orchid_skill(_skillList[irandom(array_length(_skillList) - 1)], skill_time);
	}
	
	 // Effects:
	if(chance_ct(1, (instance_exists(skill_inst) ? 10 : 15))){
		with(scrFX([x, 8], [y, 8], [90, 0.1], "VaultFlowerSparkle")){
			depth = other.depth + choose(-1, -1, 1);
		}
	}
	
#define Orchid_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
	
	 // Bloom:
	var	_scale = lerp(1.5, 1.8, 0.5 + (0.5 * sin(wave / 10))),
		_alpha = lerp(0.05, 0.25, raddrop / skill_rads);
		
	draw_set_blend_mode(bm_add);
	draw_sprite_ext(_spr, _img, _x, _y, _xsc * _scale, _ysc * _scale, _ang, _col, _alp * _alpha);
	draw_set_blend_mode(bm_normal);
	
#define Orchid_skill(_skill, _time)
	skill_set(_skill, skill_get(_skill) + 1);
	
	 // Skill-Specific Fixes:
	var	_spirit = noone,
		_chest = noone;
		
	switch(_skill){
		case mut_scarier_face:
			with(enemy){
				maxhealth = round(maxhealth * 0.8);
				my_health = round(my_health * 0.8);
				
				 // Hurt FX:
				image_index = 0;
				sprite_index = spr_hurt;
				if(point_seen(x, y, -1)) sound_play_hit(snd_hurt, 0.3);
			}
			break;
			
		case mut_hammerhead:
			with(Player){
				hammerhead += 20;
			}
			break;
			
		case mut_strong_spirit:
			with(Player){
				if(canspirit == false || ceil(skill_get(mut_strong_spirit)) == 1){
					canspirit = true;
					
					 // Effects:
					with(instance_create(x, y, StrongSpirit)){
						sprite_index = sprStrongSpiritRefill;
						creator = other;
					}
					sound_play(sndStrongSpiritGain);
				}
				else if("bonus_spirit" in self){
					_spirit = {};
					array_push(bonus_spirit, _spirit);
					sound_play(sndStrongSpiritGain);
				}
			}
			break;
			
		case mut_open_mind:
			with(instance_nearest_array(x, y, [chestprop, RadChest])){
				_chest = instance_copy(false);
			}
			break;
	}
	
	 // Alert:
	var	_icon = skill_get_icon(_skill),
		_alert = scrAlert(self, _icon[0]);
		
	with(_alert){
		image_index = _icon[1];
		image_speed = 0;
		snd_flash = sndLevelUp;
		spr_alert = -1;
		alarm0 = _time - (2 * blink);
	}
	with(_chest){
		with(scrAlert(self, _icon[0])){
			image_index = _icon[1];
			image_speed = 0;
			spr_alert = -1;
			alarm0 = _time / 3;
			blink = 12;
			flash = 4;
			snd_flash = sndChest;
		}
	}
	
	 // Controller:
	var _obj = instance_create(0, 0, CustomObject);
	with(_obj){
		time = _time;
		skill = _skill;
		alert = _alert;
		spirit = _spirit;
		chest = _chest;
		creator = other;
		on_step = script_ref_create(Orchid_skill_step);
		on_cleanup = script_ref_create(Orchid_skill_cleanup);
	}
	
	 // Effects:
	repeat(5) with(scrFX([x + hspeed, 12], [y + vspeed, 12], [90, random(1)], CaveSparkle)){
		depth = -8;
		image_speed = lerp(0.2, 0.4, speed);
		hspeed += other.hspeed / 1.5;
		vspeed += other.vspeed / 1.5;
	}
	sound_play_pitchvol(sndStatueXP, 0.8, 0.5);
	sound_play_hit_big(sndMut, 0.2);
	
	return _obj;
	
#define Orchid_skill_step
	if(time > 0 && instance_exists(creator) && creator.visible){
		if(instance_exists(alert) && alert.alarm0 <= 2){
			with(chest) visible = other.alert.visible;
		}
		time -= current_time_scale;
	}
	else instance_destroy();
	
#define Orchid_skill_cleanup
	skill_set(skill, max(0, skill_get(skill) - 1));
	
	 // Skill-Specific:
	switch(skill){
		case mut_scarier_face:
			with(instances_matching_lt(enemy, "id", self)){
				maxhealth = round(maxhealth / 0.8);
				my_health = round(my_health / 0.8);
				
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
			with(instances_matching_gt(instances_matching_lt(Player, "id", self), "hammerhead", 0)){
				hammerhead = max(0, hammerhead - 20);
			}
			break;
			
		case mut_strong_spirit:
			if(is_object(spirit)){
				with(spirit) if(lq_defget(self, "active", true)){
					active = false;
					sprite_index = sprStrongSpirit;
					image_index = 0;
					sound_play(sndStrongSpiritLost);
				}
			}
			else with(instances_matching_lt(Player, "id", self)){
				if(skill_get(mut_strong_spirit) <= 0 && canspirit == true){
					with(instance_create(x, y, StrongSpirit)) creator = other;
					sound_play(sndStrongSpiritLost);
				}
			}
			break;
			
		case mut_open_mind:
			with(chest) instance_delete(id);
			break;
	}
	
	 // Blip Out:
	with(alert){
		flash = 1;
		snd_flash = sndCursedReminder;
		alarm0 = flash;
		blink = 0;
	}
	
	
#define Mimic_create
	 // Visual:
	spr_open = spr.PetMimicOpen;
	spr_hide = spr.PetMimicHide;
	spr_bubble_y = -1;
	depth = -1;
	
	 // Vars:
	mask_index = mskFreak;
	maxspeed = 2;
	push = 0;
	wep = wep_none;
	wep_inst = noone;
	ammo = true;
	curse = false;
	open = false;
	hush = 0;
	hushtime = 0;
	pickup_mimic = scrPickupIndicator("DROP");
	
	 // Stat:
	if("weapons" not in stat) stat.weapons = [];
	
#define Mimic_ttip
	return ["EXTERNAL STORAGE", "GUN DEALER", "WHAT YOU NEED", "BUY SOMETHING"];
	
#define Mimic_stat(_name, _value)
	switch(_name){
		case "":
			return spr.PetMimicIdle;
			
		case "weapons": // Stored/Total
			var	_num = 0,
				_max = 0;
				
			if(is_array(_value)){
				var _mod = mod_get_names("weapon");
				for(var i = 0; i < 128 + array_length(_mod); i++){
					var w = ((i < 128) ? i : _mod[i - 128]);
					if(
						weapon_get_area(w) >= 0
						|| w == wep_revolver
						|| w == wep_golden_revolver
						|| w == wep_chicken_sword
						|| w == wep_rusty_revolver
						|| w == wep_rogue_rifle
						|| w == wep_guitar
						|| w == wep_frog_pistol
						|| w == wep_black_sword
						|| w == wep_golden_frog_pistol
						|| w == "crabbone"
						|| w == "merge"
					){
						_max++;
						if(array_exists(_value, w)) _num++;
					}
				}
			}
			
			return [_name, string(_num) + "/" + string(_max)];
	}

#define Mimic_anim
	if(sprite_index != spr_hurt || anim_end){
		if(speed > 0) sprite_index = spr_walk;
		else if(sprite_index != spr_walk || in_range(image_index, 3, 3 + image_speed)){
			sprite_index = (instance_exists(leader) ? spr_idle : spr_hide);
		}
	}

#define Mimic_step
	 // Weapon Storage:
	with(pickup_mimic) visible = false;
	if(instance_exists(leader)){
		 // Open Chest:
		if(place_meeting(x, y, Player)){
			walk = 0;
			sprite_index = spr_open;
			if(!open){
				open = true;
				
				 // Drop Weapon:
				if(wep != wep_none){
					wep_inst = instance_create(x, y, WepPickup);
					with(wep_inst){
						wep = other.wep;
						ammo = other.ammo;
						curse = other.curse;
					}
					wep = wep_none;
				}
				
				 // Effects:
				sound_play_hit_ext(sndGoldChest,  0.9 + random(0.2), 0.8 - hush);
				sound_play_hit_ext(sndMimicSlurp, 0.9 + random(0.2), 0.8 - hush);
				with(instance_create(x, y, FXChestOpen)) depth = other.depth - 1;
				hush = min(hush + 0.2, 0.3);
				hushtime = 60;
			}

			 // Not Holding Weapon:
			if(wep == wep_none && !place_meeting(x, y, WepPickup) && instance_exists(pickup_mimic)){
				with(pickup_mimic) visible = true;

				 // Place Weapon:
				with(player_find(pickup_mimic.pick)){
					if(canpick && wep != wep_none){
						if(!curse){
							with(other){
								wep_inst = instance_create(x, y, WepPickup);
								wep_inst.wep = other.wep;
							}
							wep = wep_none;
							player_swap();
							
							 // Effects:
							sound_play_hit(sndSwapGold, 0.1);
							sound_play_hit(sndWeaponPickup, 0.1);
							with(other) with(instance_create(x + orandom(4), y + orandom(4), CaveSparkle)){
								depth = other.depth - 1;
							}
							
							break;
						}
						else sound_play_hit(sndCursedReminder, 0.05);
					}
				}
			}
			
			 // Weapon Collection Stat:
			with(instance_nearest(x, y, WepPickup)){
				if(!array_exists(other.stat.weapons, wep_get(wep))){
					array_push(other.stat.weapons, wep_get(wep));
				}
			}
		}
		
		 // Regrab Weapon:
		else if(open){
			open = false;
			wep_inst = noone;
			if(wep == wep_none){
				if(place_meeting(x, y, WepPickup)){
					with(instance_nearest_array(x, y, instances_matching(WepPickup, "visible", true))){
						if(place_meeting(x, y, other)){
							other.wep = wep;
							other.ammo = ammo;
							other.curse = curse;
							instance_destroy();
						}
					}
				}
			}
		}

		 // Weapon Collection Stat:
		if(!array_exists(stat.weapons, wep_get(wep))){
			array_push(stat.weapons, wep_get(wep));
		}
	}
	if(hushtime <= 0) hush = max(hush - 0.1, 0);
	else hushtime -= current_time_scale;
	
	 // Hold Wep:
	if(instance_exists(wep_inst)){
		with(wep_inst){
			x = other.x;
			y = other.y;
			speed = 0;
		}
	}
	
	 // Sparkle:
	if(frame_active(10 + orandom(2))){
		instance_create(x + orandom(12), y + orandom(12), CaveSparkle);
	}

#define Mimic_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);

	 // Wep Depth Fix:
	if(place_meeting(x, y, WepPickup)){
		with(WepPickup) if(place_meeting(x, y, other)){
			event_perform(ev_draw, 0);
		}
	}

#define Mimic_alrm0(_leaderDir, _leaderDis)
	if(instance_exists(leader)){
		if(_leaderDis > 16){
			 // Pathfinding:
			if(path_dir != null){
				scrWalk(path_dir, 12);
				return irandom_range(3, walk);
			}
			
			 // Wander Toward Leader:
			else if(_leaderDis > 48){
				scrWalk(_leaderDir + orandom(10), 20 + random(max(0, _leaderDis - 64)));
			}
		}
	}
	
	return 30 + irandom(30);

#define Mimic_hurt(_hitdmg, _hitvel, _hitdir)
	if(sprite_index != spr_open){
		sprite_index = spr_hurt;
		image_index = 0;
	}


#define Parrot_create
	 // Visual:
	spr_shadow = shd16;
	spr_shadow_y = 4;
	spr_bubble_y = -2;
	bskin = false;
	depth = -3;

	 // Vars:
	maxspeed = 3.5;
	perched = noone;
	perched_x = 0;
	perched_y = 0;
	pickup = noone;
	pickup_x = 0;
	pickup_y = 0;
	pickup_held = false;
	path_wall = [Wall];
	
	 // Stat:
	if("pickups" not in stat) stat.pickups = 0;
	
#define Parrot_ttip
	return ["PARROTS RETRIEVE @wPICKUPS", "HANDY", "THEY LIKE YOU", "HAND OVER HAND"];

#define Parrot_stat(_name, _value)
	if(_name == "") return spr.PetParrotIdle;

#define Parrot_anim
	sprite_index = enemy_sprite;
	
	 // Nowhere to Land:
	if(sprite_index != spr_hurt && instance_exists(SpiralCont) && !place_meeting(x, y, Floor)){
		sprite_index = spr_walk;
	}
	
#define Parrot_step
	if("wading" in self && (speed > 0 || (instance_exists(perched) && ("wading" not in perched || perched.wading <= 0)))){
		nowade = true;
		wading = 0;
	}
	else nowade = false;

	 // Grabbing Pickup:
	if(instance_exists(pickup)){
		if(pickup_held){
			if(pickup.x == pickup_x && pickup.y == pickup_y){
				with(pickup){
					x = other.x;
					y = other.y + 4;
					xprevious = x;
					yprevious = y;

					 // Keep pickup alive:
					if(blink < 30){
						blink = 30;
						visible = true;
					}
				}
				pickup_x = pickup.x;
				pickup_y = pickup.y;
			}
			else other.pickup = noone;
		}

		 // Grab Pickup:
		else if(place_meeting(x, y, pickup)){
			pickup_held = true;
			pickup_x = pickup.x;
			pickup_y = pickup.y;

			 // Stat:
			if("ntte_statparrot" not in pickup){
				pickup.ntte_statparrot = true;
				stat.pickups++;
			}
		}

		 // Speed Bonus:
		if(speed >= maxspeed - friction){
			speed += abs(1 * sin(wave / 4));
		}
	}
	else pickup_held = false;

	 // Perching:
	if(
		instance_exists(perched)
		&& perched.speed <= 0
		&& !instance_exists(pickup)
		&& ("race" not in perched || perched.race != "horror")
	){
		x = perched.x;
		y = perched.y;
		perched_x = 0;
		perched_y = sprite_get_bbox_top(perched.sprite_index) - sprite_get_yoffset(perched.sprite_index) - 4;
		spr_bubble_y = -2 + perched_y;
	}

	else{
		 // Unperch:
		if(perched != noone){
			perched = noone;
			x += perched_x;
			y += perched_y;
			spr_bubble_y -= perched_y;
			perched_x = 0;
			perched_y = 0;
			scrWalk(random(360), 16);
			if(!instance_exists(leader)) can_take = true;
		}

		 // Perch on Leader:
		if(instance_exists(leader) && leader.visible){
			if("race" not in leader || leader.race != "horror"){ // Horror is too painful to stand on
				if(point_distance(x, y, leader.x, leader.bbox_top - 8) < 8 && leader.speed <= 0 && !instance_exists(pickup)){
					perched = leader;
					sound_play_pitch(sndBouncerBounce, 1.5 + orandom(0.1));
				}
			}
		}
	}

#define Parrot_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	 // Perched:
	if(instance_exists(perched)){
		var _perch = perched;
		
		with(PlayerSit){
			var _player = instances_matching(Player, "", null);
			if(_perch == _player[array_length(_player) - 1]) _perch = self;
		}
		
		var	_uvsStart = sprite_get_uvs(_perch.sprite_index, 0),
			_uvsCurrent = sprite_get_uvs(_perch.sprite_index, _perch.image_index);

		_x += perched_x;
		_y += perched_y;

		 // Manual Bobbing:
		if(_uvsStart[0] == 0 && _uvsStart[2] == 1 && "parrot_bob" in _perch){
			with(_perch){
				var _bob = parrot_bob[floor(image_index % array_length(parrot_bob))];
				if(is_array(_bob)){
					if(array_length(_bob) > 0) _x += _bob[0];
					if(array_length(_bob) > 1) _y += _bob[1];
				}
				else _y += _bob;
			}
		}

		 // Auto Bobbing:
		else{
			if(_perch.sprite_index != sprMutant10Idle && _perch.sprite_index != sprMutant4Idle){
				_x += (_uvsCurrent[4] - _uvsStart[4]) * (("right" in _perch) ? _perch.right : 1);
			}
			_y += (_uvsCurrent[5] - _uvsStart[5]);
		}
	}

	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);

#define Parrot_alrm0(_leaderDir, _leaderDis)
	if(instance_exists(leader)){
		 // Fly Toward Pickup:
		if(instance_exists(pickup)){
			if(!pickup_held){
				scrWalk(point_direction(x, y, pickup.x, pickup.y) + orandom(5), [6, 10]);
				return walk;
			}
		}
		else{
			pickup_held = false;
			
			 // Find Pickup:
			var	_pickup = noone,
				_disMax = 400;
				
			with(instances_matching(Pickup, "mask_index", mskPickup)){
				if(array_length(instances_matching(CustomHitme, "pickup", id)) <= 0){
					var _dis = point_distance(x, y, other.x, other.y);
					if(_dis < _disMax){
						if(in_sight(other)){
							_pickup = id;
							_disMax = _dis;
						}
					}
				}
			}
			
			if(instance_exists(_pickup)){
				pickup = _pickup;
				return 1;
			}
		}

		 // Fly Toward Leader:
		if(perched != leader){
			 // Pathfinding:
			if(path_dir != null){
				scrWalk(path_dir + orandom(4), [4, 8]);
				return walk;
			}

			 // Wander Toward Leader:
			else{
				scrWalk(_leaderDir + orandom(30), [10, 20]);
				if(_leaderDis > 32) return walk;
			}
		}

		 // Real Parrot:
		else if(chance(1, 4)){
			with(leader){
				sound_play_hit_ext(sndSaplingSpawn,                      1.8 + random(0.2), 0.33);
				sound_play_hit_ext(choose(snd_wrld, snd_chst, snd_crwn), 1.6,               0.4);
			}
			
			 // Real:
			hspeed = 4 * right;
			with(instance_create(x + (8 * right) + perched_x, y - 4 + perched_y, Wind)){
				sprite_index = spr.PetParrotNote;
				image_xscale = choose(-1, 1);
				depth = other.depth - 1;
				
				hspeed = random_range(1, 1.4) * other.right;
				gravity = -abs(speed / 10);
				friction = 0.1;
			}
			
			return 40 + random(20);
		}
	}

	 // Look Around:
	if(!instance_exists(leader) || instance_exists(perched)){
		scrRight(random(360));
		return 30 + random(30);
	}

	return 20 + random(20);

#define Parrot_hurt(_hitdmg, _hitvel, _hitdir)
	if(!instance_exists(perched)){
		sprite_index = spr_hurt;
		image_index = 0;
		
		 // Movin'
		if(speed <= 0){
			scrWalk(_hitdir, maxspeed);
			var o = 6;
			x += lengthdir_x(o, direction);
			y += lengthdir_y(o, direction);
		}
	}


#define Salamander_create
	 // Visual:
	spr_shadow_y = -2;
	
	 // Vars:
	
#define Salamander_ttip
	return [""];
	
	
#define Scorpion_create
	 // Visual:
	spr_fire   = spr.PetScorpionFire;
	spr_shield = spr.PetScorpionShield;
	hitid = [spr_idle, "SILVER SCORPION"];
	
	 // Sounds:
	snd_hurt = sndScorpionMelee;
	snd_dead = sndScorpionDie;
	
	 // Vars:
	mask_index = mskFrogEgg;
	maxhealth = 12;
	maxspeed = 3.4;
	target = noone;
	my_venom = noone;
	scorpion_city = true;
	
	 // Stat:
	if("blocked" not in stat) stat.blocked = 0;
	
#define Scorpion_ttip
	return ["SPIT VENOM", "ROCKSLIDE", "HIGH ON THE FOOD CHAIN"];
	
#define Scorpion_stat(_name, _value)
	if(_name == "") return spr.PetScorpionIdle;
	
#define Scorpion_anim
	if((sprite_index != spr_hurt && sprite_index != spr_shield) || anim_end){
		if(instance_exists(my_venom)) sprite_index = spr_fire;
		else sprite_index = enemy_sprite;
	}
	
#define Scorpion_step
	 // Collision:
	if(place_meeting(x, y, hitme)){
		with(instances_meeting(x, y, hitme)){
			if(place_meeting(x, y, other)){
				if(size < other.size){
					motion_add_ct(point_direction(other.x, other.y, x, y), 1);
				}
				with(other){
					motion_add_ct(point_direction(other.x, other.y, x, y), 1);
				}
			}
		}
	}
	
	 // Chargin:
	if(instance_exists(my_venom) && my_venom.charge){
		 // Aimin:
		if(instance_exists(target)){
			with(my_venom){
				direction += angle_difference(point_direction(x, y, other.target.x, other.target.y), direction) * 0.1 * current_time_scale;
				image_angle = direction;
				depth = other.depth - (direction >= 180);
			}
		}
		scrRight(my_venom.direction);
		
		 // Bouncy:
		with(path_wall) with(other){
			if(place_meeting(x + hspeed_raw, y + vspeed_raw, other)){
				if(place_meeting(x + hspeed_raw, y, other)) hspeed_raw *= -1;
				if(place_meeting(x, y + vspeed_raw, other)) vspeed_raw *= -1;
				scrRight(direction);
			}
		}
	}
	
#define Scorpion_alrm0(_leaderDir, _leaderDis)
	alarm0 = 20 + irandom(10);
	
	target = instance_nearest_array(x, y, pet_target_inst);
	
	if(sprite_index != spr_shield){
		if(instance_exists(leader)){
			var _leaderSeeTarget = false;
			with(leader) _leaderSeeTarget = in_sight(other.target);
			
			 // Pathfinding:
			if(path_dir != null && (!in_sight(target) || _leaderDis > 48)){
				scrWalk(path_dir + orandom(15), 15);
				return 1 + irandom(walk);
			}
			
			else{
				 // Follow Leader:
				if(_leaderDis > 28){
					scrWalk(_leaderDir + orandom(20), [10, 30]);
				}
				
				 // Attacking:
				if(instance_exists(target) && !instance_exists(my_venom)){
					if(in_sight(target) && _leaderSeeTarget && _leaderDis <= 96){
						if(chance(2, 3)){
							sound_play_hit_ext(sndScorpionFireStart, 1.2, 3);

							 // Venom Ball:
							var _targetDir = point_direction(x, y, target.x, target.y);
							my_venom = enemy_shoot("PetVenom", _targetDir, 0);
							scrRight(_targetDir);
						}
					}
				}
			}
		}
		
		 // Wander:
		else{
			scrWalk(random(360), [10, 20]);
			return 20 + irandom(20);
		}
	}

#define Scorpion_hurt(_hitdmg, _hitvel, _hitdir)
	 // Hurt:
	if(my_health > 0 && sprite_index == spr_fire && instance_exists(leader)){
		enemy_hurt(_hitdmg, _hitvel, _hitdir);
	}

	 // Dodge/Shield:
	else{
		nexthurt = current_frame + 6;
		sprite_index = spr_shield;
		image_index = 0;

		motion_add(_hitdir, 2);
		walk = 0;

		stat.blocked++;

		 // Effects:
		sound_play_hit_ext(sndGoldScorpionHurt,		 1.4 + random(0.4), 1.8);
		sound_play_hit_ext(sndCursedPickupDisappear, 0.8 + random(0.4), 1.8);
		with(instance_create(x, y, ThrowHit)) depth = other.depth - 1;
	}

#define Scorpion_death
	 // Sound:
	sound_play_hit_ext(snd_dead, 0.8 + random(0.1), 1.5);
	sound_play_hit_ext(sndGoldScorpionDead, 1.2 + random(0.2), 2.5);
	
	 // Venom Explo:
	var a = random(360);
	for(var d = a; d < a + 360; d += (360 / 5)){
		repeat(irandom_range(8, 12)){
			enemy_shoot("VenomPellet", d + orandom(12), 8 + random(8));
		}
		
		 // Effects:
		with(instance_create(x, y, AcidStreak)){
			motion_set(d, 4);
			image_angle = direction;
		}
	}
	
	
#define Slaughter_create
	 // Visual:
	spr_spwn = spr.PetSlaughterSpwn;
	spr_fire = spr.PetSlaughterBite;
	hitid = [spr_idle, "SLAUGHTERFISH"];
	sprite_index = spr_spwn;
	spr_shadow_y = -2;
	spr_bubble = -1;
	spr_bubble_pop = -1;
	depth = -3;
	
	 // Sound:
	snd_hurt = sndOasisBossHurt;
	snd_dead = sndFreakDead;
	
	 // Vars:
	mask_index = mskFrogEgg;
	maxhealth = 30;
	maxspeed = 3.4;
	nextexplo = 0;
	target = noone;
	my_bite = noone;
	my_bone = noone;
	
	 // Stat:
	if("bites" not in stat) stat.bites = 0;
	
#define Slaughter_ttip
	return ["BUBBLE BLOWIN'", "BABY", "JAWS", "VICIOUS"];
	
#define Slaughter_stat(_name, _value)
	if(_name == "") return spr.PetSlaughterIdle;
	
#define Slaughter_anim
	if((sprite_index != spr_hurt && sprite_index != spr_spwn && sprite_index != spr_fire) || anim_end){
		 // Spawn Animation End:
		if(sprite_index == spr_spwn){
			sprite_index = spr_hurt;
			image_index = 0;
			depth = -2;
			
			 // Effects:
			sound_play_hit_ext(sndOasisBossDead, 1.2 + random(0.1), 1.2);
			var l = -8;
			for(var d = direction; d < direction + 360; d += (360 / 3)){
				repeat(2) scrFX(x, y, [d + orandom(40), 4], Dust);
				with(obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "WaterStreak")){
					motion_set(d + orandom(20), 1.5);
					image_angle = direction;
					friction = 0.1;
				}
			}
		}
		
		 // Normal:
		else sprite_index = enemy_sprite;
	}
	
#define Slaughter_step
	if(nextexplo > current_frame) image_index = 0;
	if(sprite_index == spr_spwn) speed = 0;
	
	 // Extra Push:
	else if(place_meeting(x, y, hitme) && sprite_index != spr_fire){
		with(instances_meeting(x, y, hitme)){
			if(place_meeting(x, y, other)){
				if(size < other.size){
					motion_add_ct(point_direction(other.x, other.y, x, y), 1);
				}
				with(other){
					motion_add_ct(point_direction(other.x, other.y, x, y), 1);
				}
			}
		}
	}
	
	 // Biting:
	if(sprite_index == spr_fire){
		if(image_index < 3){
			 // Chompin:
			if(!instance_exists(my_bite)){
				my_bite = instance_create(x, y, RobotEat);
			}
			
			 // Drop Bone:
			with(my_bone){
				hspeed = 3.5 * other.right;
				vspeed = orandom(2);
				rotspeed = random_range(8, 16) * choose(-1, 1);
				
				 // Unstick From Wall:
				if(place_meeting(x, y, Wall) && instance_budge(Wall, -1)){
					instance_create(x, y, Dust);
				}
				instance_create(x, y, Dust);
			}
			my_bone = noone;
		}
		
		 // Bite:
		else if(image_index < 3 + image_speed_raw){
			stat.bites++;
			
			 // Attack:
			if(instance_is(target, hitme)){
				sound_play_hit_ext(sndExplosionS, 1.5, 1.2);
				with(enemy_shoot_ext(target.x, target.y, "BubbleExplosionSmall", point_direction(x, y, target.x, target.y), 5)){
					repeat(2) scrFX(x, y, [direction + orandom(30), 3], Smoke);
					image_angle = 0;
					friction = 1;
					x -= hspeed;
					y -= vspeed;
				}
			}
			
			 // Fetch Bone:
			else if(instance_is(target, WepPickup)){
				my_bone = target;
				sound_play_pitchvol(sndBloodGamble, 2 + orandom(0.2), 0.6);
			}
			
			 // Effects:
			sound_play_pitchvol(sndSharpTeeth, 1.5 + orandom(0.2), 0.5)
		}
		
		with(my_bite){
			x = other.x;
			y = other.y;
			sprite_index = spr.SlaughterBite;
			image_index = other.image_index;
			image_xscale = other.right;
			depth = other.depth - 0.1;
		}
	}
	else if(!instance_exists(target)){
		target = noone;
	}
	
	 // Fetching:
	if(instance_exists(my_bone)){
		var	_x = x + hspeed_raw + (10 * right),
			_y = y + vspeed_raw + 2;
			
		with(my_bone){
			if(point_distance(x, y, _x, _y) > 2){
				x += (_x - x) * 0.8 * current_time_scale;
				y += (_y - y) * 0.8 * current_time_scale;
			}
			else{
				x = _x;
				y = _y;
			}
			xprevious = x;
			yprevious = y;
			speed = 0;
			rotation += angle_difference((10 + (10 * sin((x + y) / 10))) * other.right, rotation) * 0.5 * current_time_scale;
			
			 // Portal Takes Bone:
			var n = instance_nearest(x, y, Portal);
			if(!visible || in_distance(n, 96)){
				other.my_bone = noone;
			}
		}
	}
	
#define Slaughter_alrm0(_leaderDir, _leaderDis)
	alarm0 = 20 + random(10);
	
	if(sprite_index != spr_fire && sprite_index != spr_spwn){
		if(instance_exists(leader)){
			 // Pathfinding:
			if(path_dir != null && (!in_sight(target) || _leaderDis > 96)){
				scrWalk(path_dir + orandom(20), 12);
				return 1 + irandom(walk);
			}
			
			else{
				if(in_sight(target) && point_distance(leader.x, leader.y, target.x, target.y) < 160 && target != my_bone){
					 // Bite:
					if(
						(target.visible || !instance_is(target, WepPickup))
						&&
						distance_to_object(target) < (instance_is(target, WepPickup) ? 2 : 32)
					){
						sprite_index = spr_fire;
						image_index = 0;
						speed = 0;
						walk = 0;
						scrRight(point_direction(x, y, target.x, target.y));
					}
					
					 // Towards Enemy:
					else{
						scrWalk(point_direction(x, y, target.x, target.y) + orandom(20), [8, 16]);
						alarm0 = 10;
					}
				}
				
				 // Towards Leader:
				else{
					if(_leaderDis > 48){
						scrWalk(_leaderDir + orandom(20), [15, 25]);
						if(instance_exists(my_bone)) walk = alarm0;
					}
					else if(!instance_exists(my_bone)){
						scrWalk(_leaderDir + orandom(90), [8, 16]);
					}
				}
				
				 // Targeting:
				if(sprite_index != spr_fire){
					var _disMax = 1000000;
					with(pet_target_inst){
						var _dis = point_distance(x, y, other.x, other.y);
						if(_dis < _disMax){
							if(!instance_is(self, prop) && in_sight(other)){
								_disMax = _dis;
								other.target = id;
							}
						}
					}
					
					 // Movin:
					if(instance_exists(target) && !collision_line(leader.x, leader.y, target.x, target.y, Wall, false, false)){
						motion_add(point_direction(x, y, target.x, target.y) + orandom(10), 2);
						scrRight(direction);
					}
					
					 // Fetch:
					if(!instance_exists(my_bone) && !in_sight(target)){
						var _disMax = 160;
						with(WepPickup) if(visible){
							var _dis = point_distance(x, y, other.x, other.y);
							if(_dis < _disMax){
								if(wep_get(wep) == "crabbone" && in_sight(other)){
									_disMax = _dis;
									other.target = id;
								}
							}
						}
					}
					
					else return 5 + random(10);
				}
			}
		}
		
		 // Wander:
		else{
			scrWalk(random(360), [8, 16]);
			return 30 + random(10);
		}
	}
	
#define Slaughter_hurt(_hitdmg, _hitvel, _hitdir)
	if(sprite_index != spr_spwn){
		if(my_health > 0 && (instance_exists(leader) || (sprite_index != spr_fire && "typ" in other && other.typ == 1))){
			if(instance_exists(leader)){
				 // Damage:
				enemy_hurt(_hitdmg, _hitvel, _hitdir);
				
				 // Sound:
				if(snd_hurt == sndOasisBossHurt){
					sound_play_hit_ext(snd_hurt, 1.2 + random(0.1), 1.4);
				}
				
				 // Bubble Armor:
				if(nextexplo <= current_frame){
					nextexplo = current_frame + 6;
					
					var	_ang = random(360),
						_num = 3 + (crown_current == crwn_death),
						l = 8;
						
					for(var d = _ang; d < _ang + 360; d += (360 / _num)){
						with(obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "BubbleExplosionSmall")){
							creator = other;
							team = other.team;
							hitid = other.hitid;
						}
					}
					
					 // Sound:
					sound_play_hit_ext(sndExplosion, 1.5 + random(0.5), 1.2);
				}
			}
			
			 // Eat:
			else if(!instance_exists(other) || ("typ" in other && other.typ != 0)){
				nexthurt = current_frame + 6;
				sprite_index = spr_fire;
				image_index = 2;
				scrRight(direction);
				walk = 0;
			}
		}
		
		 // Dodge:
		else if(sprite_index != spr_fire){
			sprite_index = spr_fire;
			image_index = 3;
		}
	}
	
#define Slaughter_death
	sound_play_hit_ext(snd_dead, 1.5 + random(0.3), 1.4);
	
	
#define Spider_create
	 // Visual:
	spr_shadow_y = 0;
	spr_bubble_y = 1;

	 // Vars:
	maxspeed = 3.4;
	web_list = [];
	web_list_x1 = 1000000;
	web_list_y1 = 1000000;
	web_list_x2 = 0;
	web_list_y2 = 0;
	web_add_l = 8;
	web_add_side = choose(-90, 90);
	web_add_d = direction + web_add_side;
	web_timer_max = 9;
	web_timer = web_timer_max;
	web_frame = 0;
	web_bits= 0;
	
	 // Stat:
	if("webbed" not in stat) stat.webbed = 0;

#define Spider_ttip
	return ["A BIT STUCK", "STICKY SITUATION", "GROSS", "COCOONED"];

#define Spider_stat(_name, _value)
	if(_name == "") return spr.PetSpiderIdle;

#define Spider_step
	 // Lay Webs:
	web_addx = x;
	web_addy = y;
	if(instance_exists(leader)){
		if(web_timer > 0){
			if(speed > 0) web_timer -= current_time_scale;
			if(web_timer <= 0){
				web_timer = web_timer_max;

				Spider_web_add(
					x + lengthdir_x(web_add_l, web_add_d),
					bbox_bottom + lengthdir_y(web_add_l, web_add_d)
				);

				web_add_l = 8 + orandom(2);
				web_add_d = direction + web_add_side + orandom(20);
				web_add_side *= -1;
			}
		}
	}
	else web_timer = web_timer_max;

#define Spider_alrm0(_leaderDir, _leaderDis)
	alarm0 = 20 + irandom(20);

	if(instance_exists(leader)){
		 // Pathfinding:
		if(path_dir != null){
			scrWalk(path_dir + orandom(15), [5, 10]);
			return walk;
		}

		 // Move Towards Leader:
		else{
			scrWalk(_leaderDir + orandom(30), 20);
			if(_leaderDis > 160) return walk;

			/*
			var _target = noone;
			
			 // Find Larget:	
			with(leader){
				var _enemies = [];
				with(enemy) if(in_sight(other) && in_distance(other, 256)){
					array_push(_enemies, id);
				}
				
				_target = instance_nearest_array(x, y, _enemies);
			}
				
			var t = array_length(instances_matching(instances_matching(CustomProjectile, "name", "SpiderTangle"), "creator", leader));
			if(instance_exists(_target) && (t < 3 || chance(1, 3 + (4 * t)))){
			
				 // Snare Larget:
				if(in_sight(_target)){
					var _targetDir = point_direction(x, y, _target.x, _target.y);
					
					with(obj_create(x, y, "SpiderTangle")){
						creator =	other.leader;
						team =		other.team;
						motion_set(_targetDir + orandom(2), 8);
						image_angle = direction;
					}
					
					 // Effects:
					motion_add(_targetDir + 180, 2);
					scrRight(_targetDir);
				}
			}
			
			else{
				 // Follow Leader:
				if(_leaderDis > 64){
					scrWalk(_leaderDir, [20, 30]);
				}
				
				 // Wander:
				else{
					scrWalk(direction + orandom(45), [10, 20]);
				}
			}
			*/
		}
	}

	 // Wander:
	else{
		scrWalk(random(360), [5, 10]);
	}

#define Spider_web_add(_x, _y)
	array_push(web_list, {
		x : _x,
		y : _y,
		frame : other.web_frame + 120,
		wading : (GameCont.area == "coast" && !position_meeting(_x, _y, Floor))
	});

	web_list_x1 = min(_x, web_list_x1);
	web_list_y1 = min(_y, web_list_y1);
	web_list_x2 = max(_x, web_list_x2);
	web_list_y2 = max(_y, web_list_y2);

#define Spider_web_delete(_index)
	web_list = array_delete(web_list, _index);

	web_list_x1 = 1000000;
	web_list_y1 = 1000000;
	web_list_x2 = 0;
	web_list_y2 = 0;
	with(web_list){
		other.web_list_x1 = min(x, other.web_list_x1);
		other.web_list_y1 = min(y, other.web_list_y1);
		other.web_list_x2 = max(x, other.web_list_x2);
		other.web_list_y2 = max(y, other.web_list_y2);
	}


#define Octo_create
	 // Visual:
	spr_hide = spr.PetOctoHide;
	spr_shadow = shd16;
	spr_shadow_y = 5;
	spr_bubble = -1;
	spr_bubble_pop = -1;
	
	 // Vars:
	friction = 0.1;
	maxspeed = 3.4;
	hiding = false;
	arcing = 0;
	arcing_attack = 0;
	path_wall = [Wall];
	
	 // Stat:
	if("arcing" not in stat) stat.arcing = 0;

#define Octo_ttip
	return ["BRAIN WAVES", "TEAMWORK", "JUMP ROPE"];

#define Octo_stat(_name, _value)
	switch(_name){
		case "":
			return spr.PetOctoIdle;
		
		case "arcing":
			var _time = "";
			_time += string_lpad(string(floor((_value / power(60, 2))     )), "0", 1); // Hours
			_time += ":";
			_time += string_lpad(string(floor((_value / power(60, 1)) % 60)), "0", 2); // Minutes
			_time += ":";
			_time += string_lpad(string(floor((_value / power(60, 0)) % 60)), "0", 2); // Seconds
			
			return [_name, _time];
	}

#define Octo_anim
	sprite_index = (hiding ? spr_hide : enemy_sprite);
	
#define Octo_step
	if(instance_exists(leader)){
		 // Unhide:
		if(hiding){
			hiding = false;
			light = true;
			spr_shadow = shd16;
		}
		
		var	_lx = leader.x,
			_ly = leader.y,
			_leaderDir = point_direction(x, y, _lx, _ly),
			_leaderDis = point_distance(x, y, _lx, _ly);
			
		if(leader.visible && in_sight(leader) && _leaderDis < 96 /*+ (45 * skill_get(mut_laser_brain))*/){
			 // Lightning Arcing Effects:
			if(arcing < 1){
				arcing += 0.15 * current_time_scale;
				
				if(current_frame_active){
					var	_dis = random(_leaderDis),
						_dir = _leaderDir;
						
					with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), choose(PortalL, LaserCharge))){
						if(object_index == LaserCharge){
							sprite_index = sprLightning;
							image_xscale = random_range(0.5, 2);
							image_yscale = random_range(0.5, 2);
							image_angle = random(360);
							alarm0 = 4 + random(4);
						}
						motion_add(random(360), 1);
					}
				}
				
				 // Arced:
				if(arcing >= 1){
					sound_play_pitch(sndLightningHit, 2);
					
					 // Laser Brain FX:
					if(skill_get(mut_laser_brain)){
						with(instance_create(x, y, LaserBrain)){
							image_angle = _leaderDir + orandom(10);
							creator = other;
						}
						with(instance_create(_lx, _ly, LaserBrain)){
							image_angle = _leaderDir + orandom(10) + 180;
							creator = other.leader;
						}
					}
				}
			}
			
			 // Lightning Arc:
			else{
				lightning_connect(_lx, _ly, x, y, 8 * sin(wave / 60), false);
				stat.arcing += (current_time_scale / 30);
			}
		}
		
		 // Stop Arcing:
		else{
			if(arcing > 0){
				arcing = 0;
				sound_play_pitchvol(sndLightningReload, 0.7 + random(0.2), 0.5);
				
				repeat(2){
					var	_dis = random(point_distance(x, y, _lx, _ly)),
						_dir = point_direction(x, y, _lx, _ly);
						
					with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), PortalL)){
						motion_add(random(360), 1);
					}
				}
			}
		}
		
		 // Arc to Nearby Things:
		if(arcing_attack > 0) arcing_attack -= current_time_scale;
		else{
			if(arcing >= 1){
				var	_nearest = noone,
					_disMax = 96;
					
				with(instances_matching_ne(instances_matching_ne(hitme, "team", team), "mask_index", mskNone)){
					var _dis = point_distance(x, y, other.x, other.y);
					if(_dis < _disMax){
						if(
							(!instance_is(self, prop) && team != 0)
							||
							(instance_is(self, prop) && sprite_get_width(sprite_index) <= 24 && sprite_get_height(sprite_index) <= 24)
						){
							if(in_sight(other)){
								_disMax = _dis;
								_nearest = id;
							}
						}
					}
				}
				
				if(instance_exists(_nearest)){
					arcing_attack = 30 + random(30);
					with(enemy_shoot("TeslaCoil", point_direction(x, y, _nearest.x, _nearest.y), 0)){
						dist_max = _disMax;
						creator_offx = 9;
						
						 // Manually Targeting:
						alarm0 = -1;
						target = _nearest;
						target_x = target.x;
						target_y = target.y;
						
						 // Effects:
						var _brain = skill_get(mut_laser_brain);
						sound_play_hit_ext((_brain ? sndLightningPistolUpg : sndLightningPistol), 1.5 + orandom(0.2), 1.2);
						if(_brain) instance_create(x, y, LaserBrain).creator = other;
					}
				}
			}
			else arcing_attack = 10 + random(20);
		}
	}
	else arcing = 0;
	
	 // He is bouncy:
	if(array_length(path) <= 0){
		with(path_wall) with(other){
			if(place_meeting(x + hspeed_raw, y + vspeed_raw, other)){
				if(place_meeting(x + hspeed_raw, y, other)) hspeed_raw *= -0.5;
				if(place_meeting(x, y + vspeed_raw, other)) vspeed_raw *= -0.5;
				scrRight(direction);
			}
		}
	}
	
	 // Hiding:
	if(hiding){
		light = false;
		spr_shadow = -1;
		
		 // Icon:
		if(spr_icon == spr.PetOctoIcon){
			spr_icon = spr.PetOctoHideIcon;
			with(pickup_indicator){
				text = string_replace(text, string(spr.PetOctoIcon), string(other.spr_icon));
			}
		}
		
		 // Hop to New Pit:
		if(image_index < 1) image_index -= image_speed_raw * 0.95;
		else if(anim_end){
			var f = instance_random(instances_matching(Floor, "sprite_index", spr.FloorTrenchB));
			if(instance_exists(f)){
				x = (f.bbox_left + f.bbox_right + 1) / 2;
				y = (f.bbox_bottom + f.bbox_top + 1) / 2;
			}
		}
		
		 // Move Slower:
		speed = clamp(speed, 0, maxspeed - 0.4);
		
		 // Can't be Grabbed Under Floors:
		can_take = (floor_get(x, y - 4).sprite_index == spr.FloorTrenchB);
	}
	else{
		 // Icon:
		if(spr_icon == spr.PetOctoHideIcon){
			spr_icon = spr.PetOctoIcon;
			with(pickup_indicator){
				text = string_replace(text, string(spr.PetOctoHideIcon), string(other.spr_icon));
			}
		}
	}

#define Octo_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	if(!hiding) draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);

#define Octo_alrm0(_leaderDir, _leaderDis)
	if(instance_exists(leader)){
		 // Follow Leader Around:
		if(_leaderDis > 64 || !in_sight(leader)){
			 // Pathfinding:
			if(path_dir != null){
				scrWalk(path_dir + orandom(10), 6);
				return 1 + irandom(walk) + irandom(6);
			}

			 // Toward Leader:
			else{
				scrWalk(_leaderDir + orandom(20), [5, 15]);
			}

			return walk + random(5);
		}

		 // Idle Around Leader:
		else{
			motion_add(_leaderDir + orandom(60), 1.5 + random(1.5));
			scrRight(direction);

			 // More Aggressive:
			if(arcing >= 1 && in_distance(enemy, 160) && "index" in leader){
				motion_add(point_direction(x, y, mouse_x[leader.index], mouse_y[leader.index]) + orandom(10), 2);
			}

			return 20 + random(10);
		}
	}

	 // No Leader:
	else{
		 // Find trench pit:
		if(GameCont.area == "trench" && !hiding){
			var f = floor_get(x, y - 4);

			 // Hide:
			if(f.sprite_index == spr.FloorTrenchB){
				hiding = true;
				
				sprite_index = spr_hide;
				image_index = 0;
				
				 // Effects:
				repeat(4 + irandom(4)){
					with(scrFX(x, y, 2, Dust)) waterbubble = chance(1, 2);
				}
			}

			 // Move Toward Nearest Seen Pit:
			else{
				var	_dir = -1,
					_disMax = 1000000;

				with(instances_matching(Floor, "sprite_index", spr.FloorTrenchB)){
					var	_x = (bbox_left + bbox_right + 1) / 2,
						_y = (bbox_top + bbox_bottom + 1) / 2,
						_dis = point_distance(other.x, other.y, _x, _y);

					if(_dis < _disMax && !collision_line(other.x, other.y, _x, _y, Wall, false, false)){
						_dir = point_direction(other.x, other.y, _x, _y);
						_disMax = _dis;
					}
				}

				if(_dir >= 0){
					scrWalk(_dir, [10, 15]);
					return walk + random(5);
				}
			}
		}

		 // Idle Movement:
		instance_create(x, y, Bubble);
		scrWalk(direction + orandom(60), [5, 15]);
		return walk + random_range(30, 60);
	}

#define Octo_hurt(_hitdmg, _hitvel, _hitdir)
	if(!hiding){
		sprite_index = spr_hurt;
		image_index = 0;
   
		 // Movin'
		scrWalk(_hitdir, 10);
		scrRight(direction + 180);
	}


#define Prism_create
	 // Visual:
	spr_bubble = -1;
	spr_bubble_pop = -1;
	depth = -3;

	 // Vars:
	mask_index = mskFrogEgg;
	maxspeed = 2.5;
	tp_delay = irandom(30);
	push = 0.5;
	alarm0 = -1;
	spawn_loc = [x, y];
	path_wall = [Wall];
	flash_frame = 0;
	
	 // Stat:
	if("splits" not in stat) stat.splits = 0;

#define Prism_ttip
	return ["STRANGE GEOMETRY", "CURSED REFRACTION", "YEAH OH ", "LIGHT BEAMS"];

#define Prism_stat(_name, _value)
	if(_name == "") return spr.PetPrismIdle;

#define Prism_step
	if(instance_exists(leader)){
		spawn_loc = [x, y];
		
		scrWalk(direction, 1); // Aimlessly floats
		
		 // Duplicate Friendly Bullets:
		with(
			instances_matching(
				instance_rectangle_bbox(bbox_left - 8, bbox_top - 8, bbox_right + 8, bbox_bottom + 8, array_combine(
					instances_matching(projectile, "team", leader.team),
					instances_matching(instances_matching_ne(projectile, "team", leader.team), "creator", leader)
				)),
				"can_prism_duplicate", true, null
			)
		){
			if(distance_to_object(other) < 8){
				if("prism_duplicate" not in self){
					prism_duplicate = false;
				}
				can_prism_duplicate = false;
				
				if(!prism_duplicate && object_index != ThrownWep){
					with(other){
						speed *= 0.5;
						stat.splits++;
					}
		
					 // Slice FX:
					var	_dir = random(360),
						_disMax = 6;
	
					for(var _dis = _disMax; _dis >= -_disMax; _dis -= 2){
						with(instance_create(other.x + lengthdir_x(_dis, _dir), other.y + lengthdir_y(_dis, _dir), BoltTrail)){
							motion_add(_dir, 1);
							image_angle = _dir;
							image_xscale = 2;
							image_yscale = 1 + (1 * (1 - ((_dis + _disMax) / (2 * _disMax))));
							if(skill_get(mut_bolt_marrow) > 0) image_yscale *= 0.7;
							depth = -4;
						}
					}
					instance_create(x + orandom(16), y + orandom(16), CaveSparkle);
					sound_play_hit_ext(sndCrystalShield, 1.4 + orandom(0.1), 2.4);
					other.flash_frame = max(other.flash_frame, current_frame + max(1, sprite_height / 16));
					
					 // Duplicate:
					var	_copy = instance_copy(false),
						_accuracy = variable_instance_get(other.leader, "accuracy", 1);
						
					switch(_copy.object_index){
						case Laser:
							var	l = point_distance(xstart, ystart, other.x, other.y) + 12,
								d = image_angle;
	
							with(_copy){
								x = other.xstart + lengthdir_x(l, d);
								y = other.ystart + lengthdir_y(l, d);
								xstart = x;
								ystart = y;
								image_angle += orandom(20 * _accuracy);
								event_perform(ev_alarm, 0);
							}
							break;
		
						case Lightning:
							for(var i = id + ceil(ammo); (i > id || instance_is(i, Lightning) || !instance_exists(i)); i--){
								if(instance_is(i, Lightning)) with(i){
									prism_duplicate = true;
								}
							}
							with(_copy){
								image_angle = other.image_angle + (random_range(20, 40) * choose(-1, 1) * _accuracy);
								ammo = min(30, ammo);
								
								 // Split Lightning:
								var	_varCopy = variable_instance_get_names(id),
									_varNo = [
										"id", "object_index", "bbox_bottom", "bbox_top", "bbox_right", "bbox_left", "image_number", "sprite_yoffset", "sprite_xoffset", "sprite_height", "sprite_width",
										"ammo", "x", "y", "xstart", "ystart", "xprevious", "yprevious", "image_xscale", "image_yscale", "image_angle", "direction"
									];
									
								event_perform(ev_alarm, 0);
								with(instances_matching_gt(Lightning, "id", id)){
									prism_duplicate = true;
									with(_varCopy){
										if(!array_exists(_varNo, self)){
											variable_instance_set(other, self, variable_instance_get(_copy, self));
										}
									}
								}
							}
							break;
		
						default:
							var _off = random_range(4, 16) * _accuracy;
							with([id, _copy]){
								direction += _off;
								image_angle += _off;
								_off *= -1;
							}
							
							 // Custom Projectile Fixes:
							with(_copy) if(instance_is(self, CustomProjectile)){
								switch(variable_instance_get(self, "name")){
									case "Bone":
										broken = true;
										break;
										
									case "QuasarRing":
										ring_lasers = array_clone(ring_lasers);
										break;
										
									case "Trident":
										with(other) if(!curse){
											curse = true;
											direction -= _off;
											image_angle -= _off;
											other.wep = wep_none;
											instance_delete(other);
											
											 // FX:
											for(var i = 0; i < 3; i++){
												with(scrFX(x, y, [direction + orandom(5), 2 + (3 * i)], AcidStreak)){
													image_angle = direction;
													sprite_index = spr.WaterStreak;
													image_speed = random_range(0.2, 0.4);
													image_blend = make_color_rgb(103, 27, 131);
													depth = -4;
												}
											}
											sound_play_pitch(sndCursedChest, 0.8);
										}
										break;
								}
							}
					}
					
					prism_duplicate = true;
				}
				else if(speed > 1){
					sound_play_pitch(sndCursedReminder, 1.5);
				}
			}
		}
		var _prism = instances_matching(instances_matching(object_index, "name", name), "pet", pet);
		with(instances_matching(instances_matching_gt(projectile, "speed", 0), "can_prism_duplicate", false)){
			if(array_length(instance_rectangle_bbox(bbox_left - 16, bbox_top - 16, bbox_right + 16, bbox_bottom + 16, _prism)) <= 0){
				can_prism_duplicate = true;
			}
		}

		 // TP Around Player:
		if(tp_delay > 0) tp_delay -= current_time_scale;
		else{
			var	_dis = 96,
				_x = x,
				_y = y;
	
			if(!collision_circle(leader.x, leader.y, _dis, id, true, false)){
				tp_delay = 15;
				
				var _dir = point_direction(leader.x, leader.y, _x, _y) + 180;
	
				do{
					x = leader.x + lengthdir_x(_dis, _dir) + orandom(4);
					y = leader.y + lengthdir_y(_dis, _dir) + orandom(4);
					_dis -= 4;
				}
				until(
					_dis < -12 ||
					(
						!place_meeting(x, y, Wall) &&
						(
							place_meeting(x, y, Floor) ||
							!place_meeting(leader.x, leader.y, Floor)
						)
					)
				)
	
				 // Effects:
				if(!place_meeting(x, y, Wall)){
					flash_frame = max(flash_frame, current_frame + 1);
					repeat(4) with(instance_create(_x + orandom(6), _y + orandom(6), (chance(1, 6) ? CaveSparkle : Curse))){
						direction = random(360);
						depth = other.depth - 1;
					}
					sound_play_hit_ext(sndCursedReminder, 0.6 + orandom(0.1), 2);
				}
			}
		}
	}
	else{
		x += sin(current_frame / 10) * 0.4 * current_time_scale;
		y += cos(current_frame / 10) * 0.4 * current_time_scale;

		 // Jitters Around:
		if(tp_delay > 0) tp_delay -= current_time_scale;
		else if(instance_exists(Floor)){
			tp_delay = irandom(30);
			
			if(!position_meeting(spawn_loc[0], spawn_loc[1], Floor)){
				with(instance_random(Floor)){
					other.spawn_loc = [
						(bbox_left + bbox_right + 1) / 2,
						(bbox_top + bbox_bottom + 1) / 2
					];
				}
			}
			
			 // Decide Which Floor:
			var	f = instance_nearest_bbox(spawn_loc[0] + orandom(64), spawn_loc[1] + orandom(64), Floor),
				_fx = (f.bbox_left + f.bbox_right + 1) / 2,
				_fy = (f.bbox_top + f.bbox_bottom + 1) / 2;
				
			 // Teleport:
			if(!place_meeting(_fx, _fy, Wall)){
				x = _fx;
				y = _fy;
				flash_frame = max(flash_frame, current_frame + 1);
				repeat(4) with(instance_create(x + orandom(6), y + orandom(6), (chance(1, 6) ? CaveSparkle : Curse))){
					direction = random(360);
					depth = other.depth - 1;
				}
				sound_play_hit_ext(sndCursedReminder, 0.6 + orandom(0.1), 2 + random(2));
			}
		}
	}

	 // Bouncin:
	with(path_wall) with(other){
		if(place_meeting(x + hspeed_raw, y + vspeed_raw, other)){
			if(place_meeting(x + hspeed_raw, y, other)) hspeed_raw *= -1;
			if(place_meeting(x, y + vspeed_raw, other)) vspeed_raw *= -1;
			direction += orandom(20);
		}
	}

	 // Effects:
	if(chance_ct(1, 3)) repeat(irandom(4)){
		instance_create(x + orandom(8), y + orandom(8), Curse);
	}

#define Prism_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	if(flash_frame > current_frame) draw_set_fog(true, image_blend, 0, 0);
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
	if(flash_frame > current_frame) draw_set_fog(false, 0, 0, 0);


#define Weapon_create
	 // Visual:
	hitid = [spr.PetWeaponIdle, "WEAPON MIMIC"];
	spr_spwn = spr.PetWeaponSpwn;
	spr_hide = spr.PetWeaponHide;
	spr_bubble_y = -1;
	sprite_index = spr_hide;
	image_index = image_number - 1;
	
	 // Sounds:
	snd_hurt = sndMimicHurt;
	snd_dead = sndMimicDead;
	
	 // Vars:
	mask_index = mskFrogEgg;
	maxhealth = 20;
	type = irandom(5);
	gunangle = random(360);
	gunangle_goal = gunangle;
	gunangle_turn = 0.25;
	shootdis_min = 0;
	shootdis_max = 192;
	target = noone;
	curse = false;
	setup = true;
	
	 // Weapons:
	with(["", "b"]){
		var b = self;
		with(other){
			variable_instance_set(self, b + "wep",       wep_none);
			variable_instance_set(self, b + "wkick",     0);
			variable_instance_set(self, b + "wepangle",  0);
			variable_instance_set(self, b + "wepflip",   choose(-1, 1));
			variable_instance_set(self, b + "reload",    30);
			variable_instance_set(self, b + "can_shoot", false);
			variable_instance_set(self, b + "wep_laser", 0);
		}
	}
	
	 // Stat:
	if("battle" not in stat) stat.battle = [0, 0];
	
#define Weapon_ttip
	return ["MUTUAL RESPECT", "WALKING WEAPON"];
	
#define Weapon_stat(_name, _value)
	switch(_name){
		case "":
			return spr.PetWeaponIdle;
			
		case "battle":
			return [`@5(${spr.PetWeaponStat})`, array_join(_value, "-")]
	}
	
#define Weapon_setup
	setup = false;
	
	if(type >= 0){
		 // Auto-Wep:
		if(wep == wep_none){
			 // Cursed:
			if(curse){
				wep = wep_super_disc_gun;
				type = 2;
			}
			
			 // Normal:
			else{
				var _typeSub = (
					(chance(1, 15) && (stat.found > 0 || stat.owned > 0))
					? 2
					: (GameCont.loops > 0)
				);
				
				switch(type){     // NORMAL //           // LOOP //           // RARE //
					case 0:	wep = [wep_wrench,           wep_energy_sword,    wep_jackhammer         ][_typeSub]; break;
					case 1:	wep = [wep_revolver,         wep_heavy_revolver,  wep_minigun            ][_typeSub]; break;
					case 2:	wep = [wep_shotgun,          wep_eraser,          wep_heavy_slugger      ][_typeSub]; break;
					case 3:	wep = [wep_crossbow,         wep_auto_crossbow,   wep_splinter_pistol    ][_typeSub]; break;
					case 4:	wep = [wep_grenade_launcher, wep_blood_launcher,  wep_sticky_launcher    ][_typeSub]; break;
					case 5:	wep = [wep_laser_cannon,     wep_plasma_cannon,   wep_super_plasma_cannon][_typeSub]; break;
				}
			}
			
			 // Akimbo:
			if(bwep == wep_none){
				var _name = string_upper(weapon_get_name(wep));
				if(string_pos("REVOLVER", _name) > 0 || string_pos("PISTOL", _name) > 0){
					bwep = wep;
				}
			}
		}
		else{
			type = (weapon_is_melee(wep) ? 0 : weapon_get_type(wep));
		}
		
		 // Weapon Setup:
		gunangle_turn = 0.25;
		shootdis_min = 32;
		shootdis_max = 192;
		switch(type){
			case 0:
				shootdis_min = 0;
				break;
				
			case 2:
				shootdis_min = 0;
				shootdis_max = 96 + (64 * (wep == wep_eraser));
				break;
				
			case 3:
				gunangle_turn = 0.5;
				shootdis_min = 64;
				shootdis_max = 320;
				break;
				
			case 4:
				gunangle_turn = 0.1;
				break;
		}
		if(wep == wep_jackhammer) gunangle_turn = 0.1;
	}
	
	 // Melee:
	var w = choose(-120, 120);
	wepangle = w * weapon_is_melee(wep);
	bwepangle = -w * weapon_is_melee(bwep);
	
	 // Cursed Sprites:
	if(curse){
		with(["idle", "walk", "hurt", "dead", "spwn", "hide", "icon"]){
			var	_type = self,
				_spr = variable_instance_get(other, "spr_" + _type, -1),
				_sprName = "PetWeapon" + string_upper(string_char_at(_type, 1)) + string_delete(_type, 1, 1);
				
			if(_spr == lq_get(spr, _sprName)){
				with(other){
					var _new = lq_get(spr, _sprName + "Cursed");
					variable_instance_set(self, "spr_" + _type, _new);
					if(sprite_index == _spr) sprite_index = _new;
					
					 // Icon:
					if(_type == "icon" && name == "Pet"){
						with(pickup_indicator){
							text = string_replace_all(text, string(_spr), string(_new));
						}
					}
				}
			}
		}
		hitid = [spr_idle, "@q@pCURSED#WEAPON MIMIC"];
	}
	
#define Weapon_anim
	if(
		sprite_index != spr_hide
		|| (instance_is(self, enemy) && enemy_target(x, y))
		|| (name == "Pet" && instance_exists(leader))
	){
		 // Appear:
		if(sprite_index == spr_spwn || sprite_index == spr_hide){
			if(sprite_index == spr_hide){
				sprite_index = spr_spwn;
				image_index = 0;
			}
			
			 // Laugh:
			if(image_index <= 0){
				audio_sound_set_track_position(sound_play_hit_ext(sndBallMamaTaunt, 2, 3), 0.2); // don't like the part at tha end but audio_set_gain was being fucky
				audio_sound_gain(sound_play_hit(sndTechnomancerActivate, 0), 0.4, 300);
				sound_play_hit(sndBigWeaponChest, 0);
			}
			
			 // Swap to Weapons:
			if(anim_end){
				wkick = -2;
				bwkick = -2;
				sound_play(weapon_get_swap(wep));
				instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), WepSwap);
				sprite_index = enemy_sprite;
			}
		}
		
		 // Normal:
		else sprite_index = enemy_sprite;
	}
	
	 // Hiding:
	else{
		image_index = min(image_index, image_number - 1);
		
		 // Clunk:
		if(floor(image_index) == image_number - 2 && image_index < floor(image_index) + image_speed_raw){
			sound_play_pitch(sndChest, 0.8 + random(0.2));
			repeat(4) scrFX(x, y, 2, Dust);
		}
	}
	
#define Weapon_step
	if(setup) Weapon_setup();
	
	 // Pet Shootin Rootin Tootin:
	if(
		sprite_index != spr_spwn
		&& name == "Pet"
		&& (in_sight(leader) || in_sight(target))
		&& instance_is(leader, Player)
	){
		gunangle_goal = point_direction(x, y, mouse_x[leader.index], mouse_y[leader.index]);
		
		 // Fire:
		if(button_check(leader.index, "fire")){
			if(
				leader.reload > 0
				||
				(
					weapon_get_load(leader.wep) <= leader.reloadspeed * current_time_scale
					&&
					array_length(instances_matching(projectile, "creator", leader)) > 0
				)
			){
				var _shot = false;
				with(["", "b"]){
					var b = self;
					with(other){
						var	_wep      = variable_instance_get(self, b + "wep"),
							_reload   = variable_instance_get(self, b + "reload"),
							_canShoot = variable_instance_get(self, b + "can_shoot");
							
						if(_canShoot <= 0 && _wep != wep_none && _reload <= 0){
							if(
								button_pressed(leader.index, "fire")
								||
								(
									(weapon_get_load(leader.wep) <= weapon_get_load(_wep) || weapon_get_auto(leader.wep) >= (leader.race != "steroids"))
									&&
									weapon_get_cost(leader.wep) > 0
								)
							){
								_shot = true;
								_canShoot = 1;
								
								 // Fire Multiple Times:
								var _wepLoad = weapon_get_load(_wep);
								if(weapon_get_auto(_wep) || _wepLoad <= 10){
									_canShoot += floor(random(15) / _wepLoad);
								}
								
								variable_instance_set(self, b + "reload",    _reload);
								variable_instance_set(self, b + "can_shoot", _canShoot);
							}
						}
					}
					if(_shot) break;
				}
			}
		}
	}
	
	 // Aim:
	if(instance_exists(target) && in_sight(target)){
		gunangle_goal = point_direction(x, y, target.x + target.hspeed, target.y + target.vspeed);
	}
	else target = noone;
	scrAim(angle_lerp(gunangle, gunangle_goal, gunangle_turn * current_time_scale));
	
	 // Weapons:
	with(["", "b"]){
		var b = self;
		with(other){
			var	_wep    = variable_instance_get(self, b + "wep"),
				_wkick  = variable_instance_get(self, b + "wkick"),
				_reload = variable_instance_get(self, b + "reload");
				
			 // Weapon Kick:
			if(!instance_is(self, enemy) || b != ""){
				_wkick -= clamp(_wkick, -current_time_scale, current_time_scale);
			}
			
			 // Reloading:
			if(_reload > 0){
				_reload -= current_time_scale;
				
				 // Reload FX:
				if(
					_reload <= 0
					&& _wep != wep_none
					&& sprite_index != spr_spwn
					&& sprite_index != spr_hide
					&& variable_instance_get(self, b + "can_shoot") <= 0
				){
					var _snd = -1;
					
					 // Melee:
					variable_instance_set(self, b + "wepflip", -variable_instance_get(self, b + "wepflip"));
					if(weapon_is_melee(_wep)){
						var	l = 12,
							d = gunangle + variable_instance_get(self, b + "wepangle");
							
						instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), WepSwap);
						variable_instance_set(self, b + "wkick", -3);
						_snd = sndMeleeFlip;
					}
					
					 // Normal:
					else switch(weapon_get_type(_wep)){
						case 2: // SHELL
							_snd = sndShotReload;
							
							 // Epic:
							variable_instance_set(self, b + "wkick", -4);
							repeat(weapon_get_cost(_wep)){
								with(instance_create(x, y, Shell)){
									sprite_index = sprShotShell;
									motion_add(other.gunangle + (100 * other.right) + orandom(20), 2 + random(2));
								}
							}
							break;
							
						case 3: // BOLT
							_snd = sndCrossReload;
							break;
							
						case 4: // EXPLOSIVE
							if(array_exists([wep_grenade_launcher, wep_golden_grenade_launcher, wep_grenade_shotgun, wep_grenade_rifle, wep_auto_grenade_shotgun, wep_ultra_grenade_launcher, wep_sticky_launcher, wep_hyper_launcher, wep_toxic_launcher, wep_cluster_launcher, wep_heavy_grenade_launcher], _wep)){
								_snd = sndNadeReload;
							}
							break;
							
						case 5: // ENERGY
							if(string_pos("PLASMA", weapon_get_name(_wep)) == 1){
								_snd = sndPlasmaReload;
							}
							else if(string_pos("LIGHTNING", weapon_get_name(_wep)) == 1){
								_snd = sndLightningReload;
							}
							break;
					}
					
					if(sound_exists(_snd)){
						sound_play_hit_ext(_snd, 1.15 + orandom(0.25), 1.5);
					}
				}
			}
			
			 // Ready:
			else{
				var _wepLaser = variable_instance_get(self, b + "wep_laser");
				
				 // Laser Sight:
				if(weapon_get_laser_sight(wep)){
					if(
						in_sight(target)
						|| (name == "Pet" && in_sight(leader))
						|| (name == "PetWeaponBoss" && point_distance(x, y, cover_x, cover_y) < 24)
					){
						_wepLaser += current_time_scale / (in_distance(target, shootdis_min) ? 60 : 5);
					}
					else if(_wepLaser > 0){
						_wepLaser -= current_time_scale / 3;
					}
				}
				
				 // Shoot:
				var _canShoot = variable_instance_get(self, b + "can_shoot");
				if(_canShoot > 0){
					var	_minID = GameObject.id,
						_wepangle = variable_instance_get(self, b + "wepangle");
						
					_canShoot--;
					_wepLaser = 0;
					
					 // Mutation Fixes:
					var _muts = [];
					if(instance_is(self, enemy)){
						var _muts = [[mut_long_arms, 0], [mut_recycle_gland, 0], [mut_shotgun_shoulders, 0], [mut_bolt_marrow, 0], [mut_boiling_veins, 0], [mut_laser_brain, 0]];
						with(_muts){
							var v = self[1];
							self[@1] = skill_get(self[0]);
							skill_set(self[0], v);
						}
					}
					
					 // Fire:
					with(player_fire_ext(gunangle, _wep, x, y, team, id)){
						_reload = reload;
						_wkick = wkick * 1.5;
					}
					_wepangle *= -1;
					
					 // Reset Mutation Fixes:
					with(_muts) skill_set(self[0], self[1]);
					
					 // Projectiles:
					with(instances_matching_gt([projectile, LaserCannon], "id", _minID)){
						hitid = other.hitid;
						
						if(instance_is(other, enemy)){
							 // Euphoria:
							speed *= power(0.8, skill_get(mut_euphoria));
							
							 // Specifics:
							switch(object_index){
								case Bullet2: // Nerf Shotguns
									if(string_pos("SHOTGUN", string_upper(weapon_get_name(_wep))) > 0){
										speed *= 0.8;
									}
									break;
									
								case Bolt: // Bolt Marrow Fix
									instance_create_copy(x, y, "DiverHarpoon");
									break;
									
								default:
									 // Time Nades:
									if(instance_is(self, Grenade) && alarm0 > 0){
										var a = (alarm2 - alarm0);
										alarm0 += (_canShoot * weapon_get_load(_wep));
										if(alarm2 > 0){
											if(TopCont.darkness) a -= 40;
											alarm2 = max(1, alarm0 + a);
										}
									}
							}
							
							 // Enemy Spriterize:
							team_instance_sprite(1, self);
						}
					}
					
					variable_instance_set(self, b + "can_shoot", _canShoot);
					variable_instance_set(self, b + "wepangle",  _wepangle);
				}
				
				variable_instance_set(self, b + "wep_laser", _wepLaser);
			}
			
			variable_instance_set(self, b + "wkick",  _wkick);
			variable_instance_set(self, b + "reload", _reload);
		}
	}
	
	 // Burst Weapon Fix:
	with(instances_matching([LaserCannon, Burst, GoldBurst, HeavyBurst, HyperBurst, RogueBurst, SawBurst, SplinterBurst, NadeBurst, DragonBurst, ToxicBurst, FlameBurst, WaveBurst, SlugBurst, PopBurst], "creator", id)){
		direction = other.gunangle;
	}
	
#define Weapon_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	 // Gun Drawing Setup:
	var	_wepOffX = 1,
		_wepOffY = ((wep != wep_none && bwep != wep_none) ? 5 : 2),
		_wepDraw = [];
		
	if(_spr != spr_spwn && _spr != spr_hide && !instance_exists(variable_instance_get(self, "revive", noone))){
		with(["", "b"]){
			var b = self;
			with(other){
				var	_wep     = variable_instance_get(self, b + "wep"),
					_wepLoad = variable_instance_get(self, b + "reload"),
					_wepAng  = variable_instance_get(self, b + "wepangle"),
					_wepDir  = gunangle + _wepAng;
					
				array_push(_wepDraw, {
					"sprt" : weapon_get_sprt(_wep),
					"x"    : _x + lengthdir_x(_wepOffX, _wepDir) + lengthdir_x(_wepOffY,       _wepDir - 90),
					"y"    : _y + lengthdir_y(_wepOffX, _wepDir) + lengthdir_y(_wepOffY * 2/3, _wepDir - 90),
					"gang" : gunangle,
					"wang" : _wepAng,
					"kick" : variable_instance_get(self, b + "wkick"),
					"flip" : ((_wepAng != 0) ? variable_instance_get(self, b + "wepflip") : 1) * ((_wepOffY == 0) ? right : sign(_wepOffY)),
					"blnd" : merge_color(_col, c_black, 0.15 * (_wepLoad > 0) * weapon_is_melee(_wep)),
					"alph" : _alp,
					"load" : _wepLoad,
					"lasr" : min(1, weapon_get_laser_sight(_wep) * variable_instance_get(self, b + "wep_laser"))
				});
				
				_wepOffY *= -1;
			}
		}
	}
	
	 // Guns in Back:
	with(_wepDraw){
		 // Laser Sight:
		if(lasr > 0){
			draw_set_color(make_color_rgb(250, 54, 0));
			draw_lasersight(x, y, gang, 1000, lasr);
		}
		
		 // Gun:
		if(y < _y){
			draw_weapon(sprt, x, y, gang, wang, kick, flip, blnd, alph);
		}
	}
	
	 // Self:
	var _hurt = (_spr != spr_hurt && nexthurt > current_frame + 3);
	if(_hurt) draw_set_fog(true, image_blend, 0, 0);
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
	if(_hurt) draw_set_fog(false, 0, 0, 0);
	
	 // Guns in Front:
	with(_wepDraw) if(y >= _y){
		draw_weapon(sprt, x, y, gang, wang, kick, flip, blnd, alph);
	}
	
#define Weapon_alrm0(_leaderDir, _leaderDis)
	alarm0 = irandom_range(20, 40);
	
	if(sprite_index != spr_hide && sprite_index != spr_spwn){
		if(instance_exists(leader)){
			 // Pathfind:
			if(path_dir != null){
				scrWalk(path_dir + orandom(20), [5, 10]);
				alarm0 = walk;
				gunangle_goal = angle_lerp(gunangle_goal, direction, 0.1);
			}
				
			 // Walkin':
			else{
				if(_leaderDis > 128){
					scrWalk(_leaderDir + orandom(30), [30, 60]);
				}
				
				 // Near Leader:
				else if("index" in leader){
					var	_mx = mouse_x[leader.index],
						_my = mouse_y[leader.index],
						_tx = lerp(leader.x, _mx, 0.5),
						_ty = lerp(leader.y, _my, 0.5);
						
					scrWalk(
						point_direction(x, y, _tx + orandom(24), _ty + orandom(24)),
						(point_distance(x, y, _tx, _ty) / 4) + irandom(20)
					);
					
					 // Lock-on Nearby Dudes:
					if(!instance_exists(target)){
						var _disMax = 64;
						with(pet_target_inst){
							var _dis = point_distance(x, y, other.x, other.y);
							if(_dis < _disMax && in_sight(other)){
								_disMax = _dis;
								other.target = id;
							}
						}
						
						 // Nearby Mouse:
						if(!instance_exists(target)){
							var _disMax = 64;
							with(pet_target_inst){
								var _dis = point_distance(x, y, _mx, _my);
								if(_dis < _disMax && in_sight(other)){
									_disMax = _dis;
									other.target = id;
								}
							}
						}
					}
				}
			}
		}
		
		 // Hide:
		else{
			sprite_index = spr_hide;
			image_index = 0;
		}
	}
	
#define Weapon_hurt(_hitdmg, _hitvel, _hitdir)
	enemy_hurt(_hitdmg, _hitvel, _hitdir);
	
	 // Seek Revenge:
	if(instance_exists(variable_instance_get(other, "creator", noone))){
		if("team" in other.creator && other.creator.team != team){
			target = other.creator;
		}
	}
	
	
/// Mod Events
#define step
	if(DebugLag) trace_time();
	
	 // Spider Webs:
	var _inst = instances_matching(instances_matching(CustomHitme, "name", "Pet"), "pet", "Spider");
	if(array_length(_inst) > 0){
		with(surfWeb){
			active = true;
			x = view_xview_nonsync;
			y = view_yview_nonsync;
			w = game_width;
			h = game_height;
			
			 // Bind Events:
			if(!instance_exists(GenCont) && surface_exists(surf)){
				script_bind_end_step(web_end_step, 0, _inst);
				script_bind_draw(web_draw,		5);
				script_bind_draw(web_draw_post,	0);
			}
			
			 // Reset Webs:
			else with(_inst){
				web_list = [];
				web_timer = web_timer_max;
				web_list_x1 = 1000000;
				web_list_y1 = 1000000;
				web_list_x2 = 0;
				web_list_y2 = 0;
			}
		}
	}
	else with(surfWeb) active = false;
	
	 // Octo Air Bubble:
	if(!area_get_underwater(GameCont.area) && (GameCont.area != 100 || !area_get_underwater(GameCont.lastarea))){
		script_bind_draw(octobubble_draw, -3);
	}
	
	 // Mantis Rad Attraction:
	var _targetInst = instances_matching(instances_matching(instances_matching(CustomHitme, "pet", "Orchid"), "name", "Pet"), "visible", true);
	if(array_length(_targetInst) > 0){
		with(instances_matching([Rad, BigRad], "orchidmantisradattract_check", null)){
			orchidmantisradattract_check = true;
			
			var	_target = noone,
				_disMax = 1000000;
				
			with(_targetInst){
				if(instance_exists(leader) && !instance_exists(skill_inst)){
					var _dis = point_distance(x, y, other.x, other.y);
					if(_dis < _disMax){
						_disMax = _dis;
						_target = id;
					}
				}
			}
			
			 // Grab:
			if(instance_exists(_target)){
				with(scrFX(x + (hspeed / 2), y + (vspeed / 2), [direction, 0.4], "VaultFlowerSparkle")){
					alarm0 = random_range(20, 30);
					image_alpha *= 2;
				}
				rad_path(self, _target);
			}
		}
	}
	
	if(DebugLag) trace_time("petlib_step");
	
#define octobubble_draw
	instance_destroy();
	with(instances_matching(instances_matching(instances_matching(instances_matching(CustomHitme, "name", "Pet"), "pet", "Octo"), "visible", true), "hiding", false)){
		draw_sprite(sprPlayerBubble, -1, x + spr_bubble_x, y + spr_bubble_y);
	}
	
#define web_draw_post
	instance_destroy();

	 // Web Bloom:
	with(surfWeb){
		if(surface_exists(surf)){
			draw_set_alpha(1/3);
			draw_set_blend_mode(bm_add);
			draw_surface(surf, x, y);
			draw_set_blend_mode(bm_normal);
			draw_set_alpha(1);
		}
	}

#define web_end_step(_inst)
	if(DebugLag) trace_time();
	
	with(surfWeb){
		if(surface_exists(surf)){
			var	_surfx = x,
				_surfy = y,
				_slowInst = [];
				
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			draw_set_color(c_black);
			
			with(_inst) if(instance_exists(self)){
				web_frame += current_time_scale;
				
				var	_webInst = instance_rectangle_bbox(web_list_x1, web_list_y1, web_list_x2, web_list_y2, instances_matching_ne(hitme, "team", team)),
					_x1, _x2, _x3,
					_y1, _y2, _y3,
					_vertexNum = 0;
					
				draw_primitive_begin(pr_trianglestrip);
				
				with(web_list){
					_x3 = _x2;
					_y3 = _y2;
					_x2 = _x1;
					_y2 = _y1;
					_x1 = x;
					_y1 = y;
					
					 // Drawing Web Mask:
					draw_vertex(x - _surfx, y - _surfy);
					
					 // Slow Enemies:
					if(_vertexNum++ >= 2){
						with(instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(
							_webInst,
							"bbox_right",	min(_x1, _x2, _x3)),
							"bbox_left",	max(_x1, _x2, _x3)),
							"bbox_bottom",	min(_y1, _y2, _y3)),
							"bbox_top",		max(_y1, _y2, _y3))
						){
							//if(point_in_triangle(x, bbox_bottom, _x1, _y1, _x2, _y2, _x3, _y3)){
								if(!collision_line(x, y, xprevious, yprevious, Wall, false, false)){
									array_push(_slowInst, id);
								}
								_webInst = array_delete_value(_webInst, id);
							//}
						}
					}
					
					 // Dissipate:
					if(frame < other.web_frame){
						 // Shrink Towards Next Point:
						var	_x = x,
							_y = y;
							
						if(_vertexNum + 1 < array_length(other.web_list)){
							with(other.web_list[_vertexNum + 1]){
								_x = x;
								_y = y;
							}
						}
						
						x = lerp(x, _x, 0.2 * current_time_scale);
						y = lerp(y, _y, 0.2 * current_time_scale);
						
						 // Delete:
						if(point_distance(_x, _y, x, y) < 1){
							with(other) Spider_web_delete(--_vertexNum);
						}
					}
					
					 // In Coast Water:
					else if(wading){
						var o = sin((current_frame + frame) / 10) * current_time_scale;
						x += o * 0.1;
						y += o * 0.15;
					}
				}
				
				 // Finish Web Mask:
				if(instance_exists(leader)){
					var	l = web_add_l * (1 - (web_timer / web_timer_max)),
						d = web_add_d;
						
					draw_vertex(x + lengthdir_x(l, d) - _surfx, bbox_bottom + lengthdir_y(l, d) - _surfy);
				}
				draw_primitive_end();
				
				 // Particles:
				if(web_bits > 0) web_bits -= current_time_scale;
				else{
					web_bits = 10 + random(20);
					if(array_length(web_list) > 0) with(web_list[0]){
						if(frame < other.web_frame){
							with(instance_create(x, y, Dust)){
								image_xscale /= 2;
								image_yscale /= 2;
							}
							with(instance_create(x, y, Feather)){
								sprite_index = spr.PetSpiderWebBits;
								image_index = irandom(image_number - 1);
								image_angle = orandom(30);
								image_speed = 0;
								speed *= 0.5;
								rot *= 0.5;
								alarm0 = 60 + random(30);
							}
						}
					}
				}
				
				 // Special Stat:
				with(instances_matching(_slowInst, "ntte_statspider", null)){
					ntte_statspider = true;
					other.stat.webbed++;
				}
			}
			
			 // Draw Web Sprite Over Web Mask:
			draw_set_blend_mode_ext(bm_inv_dest_alpha, bm_inv_dest_alpha);
			draw_rectangle(0, 0, w, h, false);
			with(other) draw_sprite_tiled(spr.PetSpiderWeb, 0, 0 - _surfx, 0 - _surfy);
			draw_set_blend_mode(bm_normal);
			
			surface_reset_target();
			
			 // Slow Enemies on Web:
			with(_slowInst){
				x = lerp(xprevious, x, current_time_scale / 3);
				y = lerp(yprevious, y, current_time_scale / 3);
			}
		}
	}
	
	if(DebugLag) trace_time("petlib_web_end_step");
	
	instance_destroy();
	
#define web_draw
	instance_destroy();
	
	 // Drawing Web Surface:
	with(surfWeb) if(surface_exists(surf)){
		draw_set_fog(true, make_color_rgb(50, 41, 71), 0, 0);
		draw_surface(surf, x, y + 1);
		draw_set_fog(false, 0, 0, 0);
		draw_surface(surf, x, y);
	}
	
	
/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  anim_end                                                                                image_index + image_speed_raw >= image_number
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
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
#define TopDecal_create(_x, _y, _area)                                                  return  mod_script_call_nc('mod', 'telib', 'TopDecal_create', _x, _y, _area);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   'mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_instance, _charm)                                               return  mod_script_call_nc('mod', 'telib', 'charm_instance', _instance, _charm);
#define door_create(_x, _y, _dir)                                                       return  mod_script_call_nc('mod', 'telib', 'door_create', _x, _y, _dir);