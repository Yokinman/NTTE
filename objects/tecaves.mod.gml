#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	mus = mod_variable_get("mod", "teassets", "mus");
	sav = mod_variable_get("mod", "teassets", "sav");
	
	DebugLag = false;
	
	 // Surfaces:
	surfWallShineMask = surflist_set("WallShineMask", 0, 0, game_width * 2, game_height * 2);
	surfWallShine = surflist_set("WallShine", 0, 0, game_width, game_height);
	
	global.floor_num = 0;
	global.wall_num = 0;
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav
#macro opt sav.option

#macro DebugLag global.debug_lag

#macro surfWallShineMask global.surfWallShineMask
#macro surfWallShine global.surfWallShine

#define CrystalHeart_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle = spr.CrystalHeartIdle;
		spr_walk = spr.CrystalHeartIdle;
		spr_hurt = spr.CrystalHeartHurt;
		spr_dead = spr.CrystalHeartDead;
		spr_shadow = shd24;
		spr_shadow_y = 4;
		hitid = [spr_idle, "CRYSTAL HEART"];
		sprite_index = spr_idle;
		depth = -4;
		
		 // Sounds:
		snd_hurt = sndHyperCrystalHurt;
		snd_dead = sndHyperCrystalDead;
		snd_mele = sndHyperCrystalSearch;
		
		 // Vars:
		mask_index = mskLaserCrystal;
		friction = 0.1;
		maxhealth = 50;
		size = 3;
		walk = 0;
		walkspeed = 0.3;
		maxspeed = 2;
		
		 // Alarms:
		alarm1 = 30;
		
		 // Light Radius:
		dark_vertices = 30;
		dark_vertices_offsets = [];
		repeat(dark_vertices) array_push(dark_vertices_offsets, random(1));
		
		return id;
	}
	
#define CrystalHeart_step
	 // Effects:
	if(chance_ct(1, 10)){
		with(scrFX([x, 6], [y, 12], random(1), LaserCharge)){
			alarm0 = 10 + random(10);
		}
	}
	
	 // Manual Contact Damage:
	if(canmelee == true && place_meeting(x, y, hitme)){
		with(instances_meeting(x, y, instances_matching_ne(hitme, "team", team))){
			if(place_meeting(x, y, other)){
				with(other) if(projectile_canhit_melee(other)){
					 // Fixes:
					var	_lastFreeze = UberCont.opt_freeze,
						_lastGamma = skill_get(mut_gamma_guts);
						
					if(!instance_is(other, Player)){
						UberCont.opt_freeze = 0;
						skill_set(mut_gamma_guts, 0);
						sound_play_hit(snd_mele, 0.1);
					}
					
					 // Damage:
					meleedamage = ((other.my_health > 1) ? other.my_health - 1 : 20);
					event_perform(ev_collision, (instance_is(other, Player) ? Player : prop));
					meleedamage = 0;
					
					 // Reset Fixes:
					if(!instance_is(other, Player)){
						UberCont.opt_freeze = _lastFreeze;
						skill_set(mut_gamma_guts, _lastGamma);
					}
					else{
						my_health = 0;
						GameCont.area = "red";
						GameCont.subarea = 0;
						instance_create(x, y, Portal);
						with(other) motion_set(point_direction(x, y, other.x, other.y), 4);
					}
				}
			}
		}
	}
	
#define CrystalHeart_alrm1
	alarm1 = random_range(30, 60);
	
	 // Wander:
	scrWalk(random(360), [10, 40]);
	
#define CrystalHeart_death
	 // Unfold:
	instance_create(x, y, PortalClear);
	var _chestTypes = [AmmoChest, WeaponChest, RadChest];
	for(var i = 0; i < 3; i++){
		with(enemy_shoot("CrystalHeartProj", (direction + (i * 120)) + orandom(4), 4)){
			chest_type = _chestTypes[i];
		}
	}
	
	 // Effects:
	sleep(100);
	
	
#define CrystalHeartProj_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.CrystalHeartProj;
		image_speed = 0.4;
		
		 // Vars:
		mask_index = mskFlakBullet;
		floor_goal = 10 + irandom(10);
		damage = 3;
		force = 12;
		typ = 0;
		maxspeed = 12;
		friction = 0.4;
		wall_break = 3;
		chest_type = AmmoChest;
		area = "red";
		subarea = 1;
		areaseed = random_get_seed();
		
		 // Alarms:
		alarm0 = 12;
		
		return id;
	}
	
#define CrystalHeartProj_step
	 // Effects:
	if(chance_ct(2, 3)) with(scrFX([x, 6], [y, 6], random(1), LaserCharge)) alarm0 = 5 + random(15);
	if(current_frame_active) with(instance_create(x, y, DiscTrail)){
		image_blend = make_color_rgb(253, 0, 67);
	}
	
	 // Coast:
	if(!place_meeting(x, y, Floor)){
		instance_destroy();
	}
	
#define CrystalHeartProj_alrm0
	alarm0 = 1;
	motion_add(direction, 0.8);
	speed = min(speed, maxspeed);
	
	 // Deflectable:
	if(typ == 0) typ = 1;
	
#define CrystalHeartProj_hit
	if(projectile_canhit_melee(other)){
		projectile_hit(other, damage);
	}
	
#define CrystalHeartProj_wall
	 // Melt Through a Few Walls:
	if(wall_break > 0 && instance_is(other, Wall)){
		wall_break--;
		with(other){
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}
		
		 // Sounds:
		var _snd = sound_play_hit_ext(sndGammaGutsProc, 0.8 + random(0.4), 1.5);
		sound_stop(_snd - 1); // stops the wall break sound bro i didnt like how it sounded
	}
	
	 // Tunnel Time:
	else instance_destroy();
	
#define CrystalHeartProj_destroy
	 // Effects:
	sound_play_hit_ext(sndGammaGutsKill,      0.8 + random(0.3), 3);
	sound_play_hit_ext(sndNothing2Beam,       0.7 + random(0.2), 3);
	sound_play_hit_ext(sndHyperCrystalSearch, 0.6 + random(0.3), 1.5);
	view_shake_max_at(x, y, 20);
	with(instance_create(x, y, BulletHit)) sprite_index = sprEFlakHit;
	
	 // Tunnel Time:
	var	_scrt = script_ref_create(CrystalHeartProj_area_generate_setup, floor_goal, direction, areaseed),
		_genID = area_generate(area, subarea, x, y, false, false, _scrt);
		
	if(is_real(_genID)){
		var _chest = chest_type;
		
		 // Delete Chests:
		with(instances_matching_gt([RadChest, chestprop], "id", _genID)){
			instance_delete(id);
		}
		
		 // Rogue:
		if(_chest == RadChest || object_is_ancestor(_chest, RadChest)){
			for(var i = 0; i < maxp; i++){
				if(player_get_race(i) == "rogue"){
					_chest = RogueChest;
					break;
				}
			}
		}
		
		 // Spawn Chest on Furthest Floor:
		var	_disMin = -1,
			_chestX = x,
			_chestY = y;
			
		with(instances_matching_gt(FloorNormal, "id", _genID)){
			var	_x = bbox_center_x,
				_y = bbox_center_y,
				_dis = point_distance(other.x, other.y, _x, _y);
				
			if(_dis > _disMin){
				if(!place_meeting(x, y, Wall)){
					_disMin = _dis;
					_chestX = _x;
					_chestY = _y;
				}
			}
		}
		with(instance_create(_chestX, _chestY, chest_type)){
			with(instances_meeting(x, y, CrystalProp)){
				instance_delete(id);
			}
		}
		
		 // Prettify:
		with(instances_matching_gt(Floor, "id", _genID)){
			depth = 8;
		}
		with(instances_matching_gt(TopSmall, "id", _genID)){
			if(chance(2, 5)) event_perform(ev_create, 0);
		}
		
		 // Reveal:
		with(floor_reveal(instances_matching_gt([Floor, Wall, TopSmall], "id", _genID), 6)){
			flash = true;
			move_dis = 0;
		}
		
		 // Goodbye:
		if(instance_exists(enemy)) portal_poof();
		instance_create(x, y, PortalClear);
		instance_destroy();
	}
	
#define CrystalHeartProj_area_generate_setup(_goal, _direction, _seed)
	with(GenCont){
		goal = _goal;
	}
	with(FloorMaker){
		goal = _goal;
		direction = round(_direction / 90) * 90;
		directionstart = direction;
	}
	random_set_seed(_seed);
	
	
#define InvMortar_create(_x, _y)
	with(obj_create(_x, _y, "Mortar")){
		 // Visual:
		spr_idle = spr.InvMortarIdle;
		spr_walk = spr.InvMortarWalk;
		spr_fire = spr.InvMortarFire;
		spr_hurt = spr.InvMortarHurt;
		spr_dead = spr.InvMortarDead;
		sprite_index = spr_idle;
		hitid = [spr_idle, "@p@qC@qU@qR@qS@qE@qD @qM@qO@qR@qT@qA@qR"];
		
		 // Sounds:
		snd_hurt = choose(sndBanditHit, sndBigMaggotHit, sndScorpionHit, sndRatHit, sndGatorHit, sndRavenHit, sndSalamanderHurt, sndSniperHit);
		snd_dead = choose(sndBanditDie, sndBigMaggotDie, sndScorpionDie, sndRatDie, sndGatorDie, sndRavenDie, sndSalamanderDead);
		  
		 // Vars:
		inv = true;  
		
		return id;
	}
	
	
#define Mortar_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle = spr.MortarIdle;
		spr_walk = spr.MortarWalk;
		spr_fire = spr.MortarFire;
		spr_hurt = spr.MortarHurt;
		spr_dead = spr.MortarDead;
		spr_weap = mskNone;
		spr_shadow = shd48;
		spr_shadow_y = 4;
		mask_index = mskSpider;
		hitid = [spr_idle, "MORTAR"];
		depth = -4;
		
		 // Sound:
		snd_hurt = sndLaserCrystalHit;
		snd_dead = sndLaserCrystalDeath;
		
		 // Vars:
		maxhealth = 75;
		raddrop = 30;
		size = 3;
		walk = 0;
		walkspeed = 0.8;
		maxspeed = 2;
		ammo = 4;
		target_x = x;
		target_y = y;
		gunangle = random(360);
		direction = gunangle;
		inv = false;
		
		 // Alarms:
		alarm1 = 100 + irandom(40);
		alarm2 = -1;
		
		 // NTTE:
		ntte_anim = false;
		
		return id;
	}
	
#define Mortar_step
	 // Animate:
	if(sprite_index != spr_hurt && sprite_index != spr_fire){
		if(speed <= 0) sprite_index = spr_idle;
		else if(sprite_index == spr_idle) sprite_index = spr_walk;
	}
	else{
		 // End Hurt Sprite:
		if(sprite_index = spr_hurt && image_index > 2) sprite_index = spr_idle;
		
		 // End Fire Sprite:
		if(sprite_index = spr_fire && (image_index > sprite_get_number(spr_fire) - 1)){
			sprite_index = spr_idle;
		}
	}
	
	 // Charging effect:
	if(sprite_index == spr_fire && chance_ct(1, 5)){
		var	_x = x + 6 * right,
			_y = y - 16,
			_l = irandom_range(16, 24),
			_d = random(360);
			
		with instance_create(_x + lengthdir_x(_l, _d), _y + lengthdir_y(_l, _d), LaserCharge){
			depth = other.depth - 1;
			motion_set(_d + 180, random_range(1,2));
			alarm0 = point_distance(x, y, _x, _y) / speed;
		}
	}
	
	 // Curse Particles:
	if(inv){
		if(chance_ct(1, 3)) instance_create(x + orandom(8), y + orandom(8), Curse);
	}
	
#define Mortar_draw
	 // Flash White w/ Hurt While Firing:
	if(
		sprite_index == spr_fire &&
		nexthurt > current_frame &&
		(nexthurt + current_frame) mod (room_speed/10) = 0
	){
		d3d_set_fog(true, image_blend, 0, 0);
		draw_self_enemy();
		d3d_set_fog(false, c_black, 0, 0);
	}
	
	 // Normal Self:
	else draw_self_enemy();
	
#define Mortar_alrm1
	alarm1 = 80 + random(20);
	
	 // Near Target:
	if(enemy_target(x, y) && in_distance(target, 240)){
		scrAim(point_direction(x, y, target.x, target.y));
		
		 // Attack:
		if(chance(1, 3)){
			alarm2 = 26;
			target_x = target.x;
			target_y = target.y;
			sprite_index = spr_fire;
			sound_play(sndCrystalJuggernaut);
		}
		
		 // Move Towards Target:
		else{
			alarm1 = 40 + irandom(40);
			scrWalk(gunangle + orandom(15), 15 + random(30));
		}
	}
	
	 // Passive Movement:
	else{
		alarm1 = 50 + irandom(30);
		scrWalk(random(360), 10);
		scrAim(direction);
	}

#define Mortar_alrm2
	enemy_target(x, y);

	 // Start:
	if(ammo <= 0){
		if(instance_exists(target)){
			target_x = target.x;
			target_y = target.y;
		}
		ammo = 4;
	}

	if(ammo > 0){
		var	_tx = target_x + orandom(16),
			_ty = target_y + orandom(16);
			
		scrAim(point_direction(x, y, _tx, _ty));
		
		 // Sound:
		sound_play(sndCrystalTB);
		sound_play(sndPlasma);
		
		 // Shoot Mortar:
		with(enemy_shoot_ext(x + (5 * right), y, "MortarPlasma", gunangle, 3)){
			z += 18;
			var d = point_distance(x, y, _tx, _ty) / speed;
			zspeed = (d * zfriction * 0.5) - (z / d);
			
			 // Cool particle line
			var	_x = x,
				_y = y,
				_z = z,
				_zspd = zspeed,
				_zfrc = zfriction,
				i = 0;
				
			while(_z > 0){
				with(instance_create(_x, _y - _z, BoltTrail)){
					image_angle = point_direction(x, y, _x + other.hspeed, _y + other.vspeed - (_z + _zspd));
					image_xscale = point_distance(x, y, _x + other.hspeed, _y + other.vspeed - (_z + _zspd));
					image_yscale = random(1.5);
					image_blend = make_color_rgb(235, 0, 67);
					depth = -8;
					if(chance(1, 6)){
						with(instance_create(x + orandom(8), y + orandom(8), LaserCharge)){
							motion_add(point_direction(x, y, _x, _y - _z), 1);
							alarm0 = (point_distance(x, y, _x, _y - _z) / speed) + 1;
							depth = -8;
						}
					}
				}
				
				_x += hspeed;
				_y += vspeed;
				_z += _zspd;
				_zspd -= _zfrc;
				i++;
			}
			var _ang = random(360);
			for(var a = _ang; a < _ang + 360; a += 120 + orandom(30)){
				var	l = 16,
					_tx = _x,
					_ty = _y;
					
				with(instance_create(_x + lengthdir_x(l, a), _y + lengthdir_y(l, a), LaserCharge)){
					motion_add(point_direction(x, y, _tx, _ty), (point_distance(x, y, _tx, _ty) / i));
					alarm0 = i;
				}
				i *= 3/4;
			}
			with(instance_create(_x, _y, CaveSparkle)) image_speed *= random_range(0.5, 1);
		}
		
		 // Aim After Target:
		if(in_sight(target)){
			var	l = 32,
				d = point_direction(target_x, target_y, target.x, target.y);
				
			target_x += lengthdir_x(l, d);
			target_y += lengthdir_y(l, d);
		}
		
		if(--ammo > 0) alarm2 = 4;
	}

#define Mortar_hurt(_hitdmg, _hitvel, _hitdir)
	my_health -= _hitdmg;          // Damage
	motion_add(_hitdir, _hitvel);  // Knockback
	nexthurt = current_frame + 6;  // I-Frames
	sound_play_hit(snd_hurt, 0.3); // Sound
	
	 // Hurt Sprite:
	if(sprite_index != spr_fire){
		sprite_index = spr_hurt;
		image_index = 0;
		
		 // Cursed Mortar Behavior:
		if(inv && my_health > 0 && chance(_hitdmg / 25, 1)){
			var	_enemies = instances_matching_ne(enemy, "name", name),
				_x = x,
				_y = y;
				
			 // Swap places with another dude:
			if(array_length(_enemies) > 0){
				with(instance_random(_enemies)){
					other.x = x;
					other.y = y;
					x = _x;
					y = _y;
					
					 // Unstick from walls by annihilating them:
					instance_create(x, y, PortalClear).mask_index = mask_index;
					
					 // Effects:
					nexthurt = current_frame + 6;
					sprite_index = spr_hurt;
					image_index = 0;
				}
				
				 // Unstick from walls by annihilating them:
				if(place_meeting(x, y, Floor)){
					instance_create(x, y, PortalClear).mask_index = mask_index;
				}
				else{
					top_create(x, y, id, 0, 0);
				}
			}
		}
	}
	
#define Mortar_death
	pickup_drop(30, 35);
	pickup_drop(30, 0);
	
	
#define MortarPlasma_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.MortarPlasma;
		mask_index = mskNone;
		depth = -8;
		
		 // Vars:
		z = 1;
		zspeed = 0;
		zfriction = 0.4; // 0.8
		damage = 0;
		force = 0;
		
		return id;
	}
	
#define MortarPlasma_step
	z += zspeed * current_time_scale;
	zspeed -= zfriction * current_time_scale;
	
	 // Facing:
	if((direction >= 30 && direction <= 150) || (direction >= 210 && direction <= 330)){
		image_index = round((point_direction(0, 0, speed, zspeed) + 90) / (360 / image_number));
		image_angle = direction;
	}
	else{
		if(zspeed > 5) image_index = 0;
		else if(zspeed > 2) image_index = 1;
		else image_index = 2;
		image_angle = point_direction(0, 0, hspeed, -zspeed);
	}
	
	 // Trail:
	if(chance_ct(1, 2)){
		with(instance_create(x + orandom(4), y - z + orandom(4), PlasmaTrail)) {
			sprite_index = spr.EnemyPlasmaTrail;
			depth = other.depth;
		}
	}
	
	 // Hit:
	if(z <= 0 || (z <= 8 && position_meeting(x, y + 8, Wall))){
		instance_destroy();
	}
	
#define MortarPlasma_draw
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	
	 // Bloom:
	draw_set_blend_mode(bm_add);
	draw_sprite_ext(sprite_index, image_index, x, y - z, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
	draw_set_blend_mode(bm_normal);
	
#define MortarPlasma_hit
	// nada
	
#define MortarPlasma_wall
	// nada
	
#define MortarPlasma_destroy
	with(instance_create(x, y, PlasmaImpact)){
		sprite_index = spr.EnemyPlasmaImpact;
		team = other.team;
		creator = other.creator;
		hitid = other.hitid;
		damage = 2;
		
		 // Over Wall:
		if(position_meeting(x, y + 8, Wall) || !position_meeting(x, y + 8, Floor)){
			depth = -8;
		}
	}
	
	 // Effects:
	view_shake_at(x, y, 2);
	sound_play(sndPlasmaHit);
	
	
#define NewCocoon_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle = sprCocoon;
		spr_hurt = sprCocoonHurt;
		spr_dead = sprCocoonDead;
		spr_shadow = shd24;
		
		 // Sound:
		snd_dead = sndCocoonBreak;
		
		 // Vars:
		maxhealth = 6;
		nexthurt = current_frame;
		size = 1;
		
		return id;
	}
	
#define NewCocoon_death
	 // Bits:
	var _ang = random(360);
	for(var d = _ang; d < _ang + 360; d += (360 / 5)){
		with(scrFX(x, y, [d, 1.5], Feather)){
			sprite_index = spr.PetSpiderWebBits;
			image_blend = make_color_rgb(165, 165, 165);
			image_angle = orandom(30);
			image_index = irandom(image_number - 1);
			image_speed = 0;
			rot /= 2;
		}
	}
	
	 // O no:
	if(chance(1, 30)){
		with(obj_create(x, y, "Seal")){
			nexthurt = current_frame + 15;
		}
	}
	
	 // Hatch 1-3 Spiders:
	else if(chance(4, 5)){
		repeat(irandom_range(1, 3)) {
			obj_create(x, y, "Spiderling");
		}
	}
	
	 // Normal:
	else{
		instance_change(Cocoon, false);
		instance_destroy();
	}


#define RedCrystalProp_create(_x, _y)
	with(instance_create(_x, _y, CrystalProp)){
		 // Visual:
		spr_idle = spr.RedCrystalPropIdle;
		spr_hurt = spr.RedCrystalPropHurt;
		spr_dead = spr.RedCrystalPropDead;
		
		 // Sounds:
		snd_hurt = sndHitRock;
		snd_dead = sndCrystalPropBreak;
		
		 // Vars:
		maxhealth = 2;
		
		return id;
	}
	

#define RedSpider_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle = spr.RedSpiderIdle;
		spr_walk = spr.RedSpiderWalk;
		spr_hurt = spr.RedSpiderHurt;
		spr_dead = spr.RedSpiderDead;
		sprite_index = spr_idle;
		spr_shadow = shd24;
		hitid = [spr_idle, "CRYSTAL SPIDER?"];
		depth = -2;
		
		 // Sounds:
		snd_hurt = sndSpiderHurt;
		snd_dead = sndSpiderDead;
		snd_mele = sndSpiderMelee;
		
		 // Vars:
		mask_index = mskSpider;
		maxhealth = 14;
		raddrop = 4;
		size = 1;
		walk = 0;
		walkspeed = 0.6;
		maxspeed = 4;
		canmelee = true;
		meleedamage = 2;
		cantunnel = false;
		
		 // Alarms:
		alarm1 = irandom_range(30, 60);
		
		return id;
	}
	
#define RedSpider_alrm1
	alarm1 = irandom_range(10, 30);
	
	if(enemy_target(x, y)){
		var	_targetDir = point_direction(x, y, target.x, target.y),
			_targetSeen = in_sight(target);
			
		if(_targetSeen) cantunnel = true;
		
		 // Attack:
		if(
			(chance(2, 3) && in_distance(target, 64))
			||
			(!_targetSeen && cantunnel && collision_circle(x + lengthdir_x(8, _targetDir), y + lengthdir_y(8, _targetDir), 8, Wall, false, false))
		){
			alarm1 = 45;
			walk = 0;
			speed /= 2;
			scrRight(_targetDir);
			
			 // Plasma Bite:
			for(var _spd = 0; _spd < (_targetSeen ? 4 : 2); _spd += random_range(1, 1.5)){
				var	_dis = 12,
					_dir = _targetDir + orandom(lerp(20, 10, _spd / 4)),
					_x = x + lengthdir_x(_dis, _dir),
					_y = y + lengthdir_y(_dis, _dir);
					
				with(team_instance_sprite(1, enemy_shoot_ext(_x, _y, PlasmaImpact, _dir, _spd))){
					damage = 4;
					mask_index = -1;
					image_xscale = lerp(0.7, 0.2, _spd / 4);
					image_yscale = image_xscale;
					image_speed += orandom(0.1);
					friction = 0.1;
					
					 // Tunnel Time:
					if(!_targetSeen){
						with(instance_create_copy(x, y, PortalClear)) visible = false;
					}
				}
			}
			
			 // Effects:
			sound_play_hit_ext(sndSharpTeeth, 1 + orandom(0.2), 0.8);
			sound_play_hit_ext(sndPlasmaHit, 1 + orandom(0.5), 1.5);
			sprite_index = spr_hurt;
			image_index = 0;
			
			 // Debris Protection:
			if(!_targetSeen){
				nexthurt = current_frame + 6;
			}
		}
		
		 // Towards Target:
		else if(_targetSeen || cantunnel){
			scrWalk(_targetDir + orandom(10), 15);
		}
		
		 // Wander:
		else scrWalk(random(360), 10);
	}
	
	 // Wander:
	else{
		scrWalk(random(360), random_range(5, 10));
		alarm1 += walk;
	}
	
#define RedSpider_hurt(_hitdmg, _hitvel, _hitdir)
	enemy_hurt(_hitdmg, _hitvel, _hitdir);
	cantunnel = true;
	
#define RedSpider_death
	pickup_drop(20, 0);
	
	 // Plasma:
	with(team_instance_sprite(1, enemy_shoot(PlasmaImpact, 0, 0))){
		mask_index = mskPopoPlasmaImpact;
		with(instance_create_copy(x, y, PortalClear)) visible = false;
	}
	sound_play_hit_big(sndPlasmaHit, 0.2);
	
	
#define Spiderling_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle = spr.SpiderlingIdle;
		spr_walk = spr.SpiderlingWalk;
		spr_hurt = spr.SpiderlingHurt;
		spr_dead = spr.SpiderlingDead;
		spr_hatch = spr.SpiderlingHatch;
		spr_shadow = shd16;
		spr_shadow_y = 2;
		mask_index = mskMaggot;
		hitid = [spr_idle, "SPIDERLING"];
		depth = -2;

		 // Sound:
		snd_hurt = sndSpiderHurt;
		snd_dead = sndSpiderDead;

		 // Vars:
		maxhealth = 4;
		raddrop = 2;
		size = 1;
		walk = 0;
		walkspeed = 0.8;
		maxspeed = 3;
		nexthurt = current_frame + 15;
		direction = random(360);

		 // Cursed:
		curse = (GameCont.area == 104);
		if(curse){
			spr_idle = spr.InvSpiderlingIdle;
			spr_walk = spr.InvSpiderlingWalk;
			spr_hurt = spr.InvSpiderlingHurt;
			spr_dead = spr.InvSpiderlingDead;
			spr_hatch = spr.InvSpiderlingHatch;
			snd_hurt = choose(sndHitFlesh, sndBanditHit, sndFastRatHit);
			snd_dead = choose(sndEnemyDie, sndBanditDie, sndFastRatDie);
		}
		
		 // Alarms:
		alarm0 = irandom_range(60, 150);
		alarm1 = irandom_range(20, 40);
		
		var n = instance_nearest(x, y, Player);
		if(instance_exists(n)) alarm0 += point_distance(x, y, n.x, n.y);

		return id;
	}

#define Spiderling_alrm0
	 // Shhh dont tell anybody
	var _obj = ((GameCont.area == 104) ? InvSpider : Spider);
	with(instance_create(x, y, _obj)){
		x = other.x;
		y = other.y;
		creator = other;
		right = other.right;
		alarm1 = 10 + random(10);
	}

	 // Effects:
	for(var a = 0; a < 360; a += (360 / 6)){
		var o = random(8);
		with(instance_create(x + lengthdir_x(o, a), y + lengthdir_y(o, a), Smoke)){
			motion_add(a + orandom(20), 1 + random(1.5));
			depth = -3;
			with(instance_create(x, y, Dust)){
				depth = other.depth;
				motion_add(other.direction + orandom(90), 2);
			}
		}
	}
	for(var a = direction; a < direction + 360; a += (360 / 3)){
		with(obj_create(x, y, "CatDoorDebris")){
			sprite_index = other.spr_hatch;
			image_index = irandom(image_number - 1);
			direction = a + orandom(30);
			speed += 1 + random(4);
		}
	}
	sound_play_hit(sndHitRock, 0.3);
	sound_play_hit(sndBouncerBounce, 0.5);
	sound_play_pitchvol(sndCocoonBreak, 2 + random(1), 0.8);

	instance_delete(id);

#define Spiderling_alrm1
	alarm1 = 10 + irandom(10);
	
	if(instance_exists(Player)){
		target = instance_nearest_array(x, y, [Player, CrystalProp, InvCrystal]);
	}
	
	 // Cursed:
	if(curse) instance_create(x, y, Curse);
	
	 // Move Towards Target:
	if(in_sight(target) && in_distance(target, 96)){
		scrWalk(point_direction(x, y, target.x, target.y) + orandom(20), 14);
		if(instance_is(target, prop)){
			direction += orandom(60);
			alarm1 *= random_range(1, 2);
		}
	}
	
	 // Wander:
	else scrWalk(direction + orandom(20), 12);

#define Spiderling_death
	pickup_drop(15, 0);
	
	 // Dupe Time:
	var _chance = 2/3 * curse;
	if(chance(_chance, 1)){
		speed = min(1, speed);
		repeat(3 * max(1, _chance)) with(obj_create(x, y, "Spiderling")){
			sprite_index = spr_hurt;
			alarm0 = ceil(other.alarm0 / 2);
			curse = other.curse / 2;
			kills = other.kills;
			raddrop = 0;
		}
	}


#define SpiderWall_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		topspr = spr.SpiderWallFakeTop;
		botspr = sprWall4Bot;
		topindex = 0;
		botindex = 0;
		
		 // Vars:
		mask_index = mskWall;
		creator = noone;
		special = false;
		setup = true;
		
		return id;
	}

#define SpiderWall_setup
	setup = false;
	
	 // Sprites:
	topspr = (special ? spr.SpiderWallMainTop : spr.SpiderWallFakeTop);
	botspr = (special ? spr.SpiderWallMainBot : sprWall4Bot);
	topindex = irandom(sprite_get_number(topspr) - 1);
	botindex = irandom(sprite_get_number(botspr) - 1);
	with(creator){
		topspr = other.topspr;
		topindex = other.topindex;
		sprite_index = other.botspr;
		image_index = other.botindex;
	}
	
	 // No Duplicates:
	with(instances_matching_gt(instances_matching(instances_matching(CustomObject, "name", name), "creator", creator), "id", id)){
		instance_destroy();
	}

#define SpiderWall_step
	if(setup) SpiderWall_setup();
	
	 // Sparklin:
	if(special && chance_ct(1, 90)){
		with(instance_create(x + random_range(-4, 20), y - 8 + random_range(-4, 20), CaveSparkle)){
			sprite_index = spr.PetSparkle;
			depth = -9;
		}
	}
	
	 // Spawn:
	if(!instance_exists(creator) && !place_meeting(x, y, Explosion)){
		 // Spawn:
		if(position_meeting(x + 8, y + 8, FloorExplo)){
			
			 // Special Spider:
			if(special){
				with(pet_spawn(x + 8, y + 8, "Spider")){
					sprite_index = spr_hurt;
					sound_play_hit_ext(sndSpiderMelee, 0.6 + random(0.2), 1.5);
				}
			}
			
			 // Spiderlings:
			else repeat(irandom_range(1, 3)){
				if(chance(3, 5)){
					with(obj_create(x + 8, y + 8, "Spiderling")){
						sprite_index = spr_hurt;
						sound_play_hit_ext(sndSpiderHurt, 0.5 + random(0.3), 1.5);
					}
				}
				
				 // Sparkle:
				with(instance_create(x + random(16), y + orandom(8), CaveSparkle)){
					sprite_index = spr.PetSparkle;
					depth = -3;
				}
			}
		}
		
		instance_destroy();
	}


/// Mod Events:
#define step
	script_bind_end_step(end_step, 0);
	
	if(DebugLag) trace_time();
	
	 // Wall Shine:
	if(global.floor_num != instance_number(Floor) || global.wall_num != instance_number(Wall)){
		global.floor_num = instance_number(Floor);
		global.wall_num = instance_number(Wall);
		
		 // New Floors, Reset Wall Mask:
		with(surfWallShineMask){
			reset = true;
			inst_tops = instances_matching(TopSmall, "sprite_index", spr.WallRedTrans);
			inst_wall = instances_matching(Wall, "topspr", spr.WallRedTop);
			active = (array_length(inst_tops) + array_length(inst_wall) > 0);
		}
	}
	with(surfWallShine){
		active = surfWallShineMask.active;
		if(active) script_bind_draw(draw_wall_shine, -6.0001);
	}
	
	 // Crystal Tunnel Particles:
	if(GameCont.area != "red"){
		with(surfWallShineMask) if(active){
			if(chance_ct(1, 40)){
				do var i = irandom(maxp - 1);
				until player_is_active(i);
				mod_script_call_nc("area", "red", "area_effect", view_xview[i], view_yview[i]);
			}
		}
	}
	
	if(DebugLag) trace_time("tecaves_step");

#define end_step
	if(DebugLag) trace_time();

	 // Spider Cocoons:
	with(Cocoon){
		obj_create(x, y, "NewCocoon");
		instance_delete(id);
	}
	
	 // Scramble Cursed Caves Weapons:
	with(instances_matching(WepPickup, "cursedcavescramble_check", null)){
		cursedcavescramble_check = false;
		if(GameCont.area == 104){
			if(roll && wep_get(wep) != "merge"){
				if(!position_meeting(xstart, ystart, ChestOpen) || chance(1, 3)){
					cursedcavescramble_check = true;
					mergewep_indicator = null;
					
					curse = max(1, curse);
	
					var _part = wep_merge_decide(0, GameCont.hard + (2 * curse));
					if(array_length(_part) >= 2){
						wep = wep_merge(_part[0], _part[1]);
					}
				}
			}
		}
	}
	
	if(DebugLag) trace_time("tecaves_end_step");
	
	instance_destroy();

#define draw_shadows
	if(DebugLag) trace_time();

	 // Mortar Plasma:
	with(instances_matching(CustomProjectile, "name", "MortarPlasma")) if(visible){
		if(position_meeting(x, y, Floor)){
			var	_percent = clamp(96 / z, 0.1, 1),
				_w = ceil(18 * _percent),
				_h = ceil(6 * _percent),
				_x = x,
				_y = y;
				
			draw_ellipse(_x - (_w / 2), _y - (_h / 2), _x + (_w / 2), _y + (_h / 2), false);
		}
	}

	if(DebugLag) trace_time("tecaves_draw_shadows");

#define draw_dark // Drawing Grays
	draw_set_color(c_gray);

	if(DebugLag) trace_time();

	 // Crystal Heart:
	with(instances_matching(CustomEnemy, "name", "CrystalHeart")){
		draw_crystal_heart_dark(45, 72 + random(2), 3);
	}
	
	 // Mortar:
	with(instances_matching(CustomEnemy, "name", "Mortar", "InvMortar")) if(visible){
		if(sprite_index == spr_fire){
			draw_circle(x + (6 * right), y - 16, 48 - alarm1 + orandom(4), false)
		}
	}

	 // Mortar Plasma:
	with(instances_matching(CustomProjectile, "name", "MortarPlasma")) if(visible){
		draw_circle(x, y - z, 64 + orandom(1), false);
	}

	if(DebugLag) trace_time("tecaves_draw_dark");

#define draw_dark_end // Drawing Clear
	draw_set_color(c_black);

	if(DebugLag) trace_time();
	
	 // Crystal Heart:
	with(instances_matching(CustomEnemy, "name", "CrystalHeart")){
		draw_crystal_heart_dark(15, 24 + random(2), 2);
	}

	 // Mortar:
	with(instances_matching(CustomEnemy, "name", "Mortar", "InvMortar")) if(visible){
		if(sprite_index == spr_fire){
			draw_circle(x + (6 * right), y - 16, 24 - alarm1 + orandom(4), false)
		}
	}

	 // Mortar Plasma:
	with(instances_matching(CustomProjectile, "name", "MortarPlasma")) if(visible){
		draw_circle(x, y - z, 32 + orandom(1), false);
	}

	if(DebugLag) trace_time("tecaves_draw_dark_end");

#define draw_bloom
	 // Crystal Heart Projectile:
	with(instances_matching(projectile, "name", "CrystalHeartOrb")){
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * 0.1);
	}
	
#define draw_crystal_heart_dark(_vertices, _radius, _coefficient)
	draw_primitive_begin(pr_trianglefan);
	draw_vertex(x, y);
	
	for(var i = 0; i <= _vertices + 1; i++){
		var	_x = x + lengthdir_x(_radius, (360 / _vertices) * i),
			_y = y + lengthdir_y(_radius, (360 / _vertices) * i);
			
		_x += sin(_x * 0.1) * _coefficient;
		_y += sin(_y * 0.1) * _coefficient;
		draw_vertex(_x, _y);
	}
	
	draw_primitive_end();
	
#define draw_wall_shine
	var	_vx = view_xview_nonsync,
		_vy = view_yview_nonsync,
		_gw = game_width,
		_gh = game_height;
		
	with(surfWallShineMask){
		var	_x = floor(_vx / _gw) * _gw,
			_y = floor(_vy / _gh) * _gh;
			
		if(_x != x || _y != y){
			reset = true;
			x = _x;
			y = _y;
		}
		w = _gw * 2;
		h = _gh * 2;
		
		if(surface_exists(surf) && reset){
			reset = false;
			
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			
			 // Background:
			if(background_color == mod_script_call_nc("area", "red", "area_background_color")){
				draw_clear(background_color);
				draw_set_blend_mode_ext(bm_inv_src_alpha, bm_inv_src_alpha);
				
				with(instance_rectangle_bbox(x, y, x + w, y + h, Floor)){
					x -= _x;
					y -= _y;
					draw_self();
					x += _x;
					y += _y;
				}
				with(instance_rectangle_bbox(x, y, x + w, y + h, Wall)){
					x -= _x;
					y -= _y;
					draw_self();
					draw_sprite(topspr, topindex, x, y - 8);
					x += _x;
					y += _y;
				}
				with(instance_rectangle_bbox(x, y, x + w, y + h, TopSmall)){
					draw_sprite(sprite_index, image_index, x - _x, y - 8 - _y);
				}
				
				draw_set_blend_mode(bm_normal);
			}
			
			 // Crystal Wall Tops:
			with(inst_tops) if(instance_exists(self)){
				draw_sprite(sprite_index, image_index, x - _x, y - 8 - _y);
			}
			with(inst_wall) if(instance_exists(self)){
				draw_sprite(topspr, topindex, x - _x, y - 8 - _y);
			}
			
			surface_reset_target();
		}
	}
	
	with(surfWallShine){
		x = _vx;
		y = _vy;
		w = _gw;
		h = _gh;
		
		wave += current_time_scale * random_range(1, 2);
		
		if(surface_exists(surf)){
			var	_x = x,
				_y = y,
				_shineAng = 45,
				_shineSpeed = 10,
				_shineWidth = 30 + orandom(2),
				_shineInterval = 240, // 4-8 Seconds
				_shineDisMax = sqrt(2 * sqr(max(_gw, _gh))),
				_shineDis = (_shineSpeed * wave) % (_shineDisMax + (_shineInterval * _shineSpeed)),
				_shineX = _vx - _x       + lengthdir_x(_shineDis, _shineAng),
				_shineY = _vy - _y + _gh + lengthdir_y(_shineDis, _shineAng),
				_shineXOff = lengthdir_x(_shineDisMax, _shineAng + 90),
				_shineYOff = lengthdir_y(_shineDisMax, _shineAng + 90);
				
			if(_shineDis < _shineDisMax){
				surface_set_target(surf);
				
					draw_clear_alpha(0, 0);
					
					 // Mask:
					draw_set_fog(true, c_black, 0, 0);
					with(surfWallShineMask) if(surface_exists(surf)){
						draw_surface(surf, x - _x, y - _y);
					}
					with(other) with(instances_matching(instances_matching(CustomEnemy, "name", "RedSpider"), "visible", true)){
						x -= _x;
						y -= _y;
						event_perform(ev_draw, 0);
						x += _x;
						y += _y;
					}
					with(instances_matching(instances_matching(CrystalProp, "name", "RedCrystalProp"), "visible", true)){
						x -= _x;
						y -= _y;
						draw_self();
						x += _x;
						y += _y;
					}
					draw_set_fog(false, 0, 0, 0);
					
					 // Shine:
					draw_set_color(c_white);
					draw_set_color_write_enable(true, true, true, false);
					draw_line_width(_shineX + _shineXOff, _shineY + _shineYOff, _shineX - _shineXOff, _shineY - _shineYOff, _shineWidth);
					draw_set_color_write_enable(true, true, true, true);
					
				surface_reset_target();
				
				 // Ship 'em Out:
				draw_set_alpha(0.1);
				draw_set_blend_mode_ext(bm_src_alpha, bm_one);
				draw_surface(surf, x, y);
				draw_set_blend_mode(bm_normal);
				draw_set_alpha(1);
			}
		}
	}
	
	instance_destroy();
	

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