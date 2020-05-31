#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	lag = false;
	
	 // Surfaces:
	surfWallShineMask = surface_setup("RedWallShineMask", null, null, null);
	
	 // Fake Wall Player Visibility Coefficient:
	wallFakePlayerVisible = array_create(maxp, 0);
	wallFakeTransitionCol = make_color_rgb(145, 0, 43);
	
	 // Clone Base Color:
	baseCloneCol = make_color_rgb(145, 0, 43);
	
	 // Client-Side Darkness:
	clientDarknessCoeff = array_create(maxp, 0);
	clientDarknessFloor = [];
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#macro surfWallShineMask global.surfWallShineMask

#macro WallFake              instances_matching(FloorNormal, "name", "WallFake")
#macro wallFakePlayerVisible global.wallFakePlayerVisible
#macro wallFakeTransitionCol global.wallFakeTransitionCol

#macro clientDarknessCoeff global.clientDarknessCoeff
#macro clientDarknessFloor global.clientDarknessFloor

#macro baseCloneCol global.cloneCol

#define ChaosHeart_create(_x, _y)
	/*
		A special variant of crystal hearts unique to the red crown
		Generates random areas on death and cannot be used to access the warp zone
	*/
	
	with(obj_create(_x, _y, "CrystalHeart")){
		 // Visual:
		spr_idle = spr.ChaosHeartIdle;
		spr_walk = spr.ChaosHeartIdle;
		spr_hurt = spr.ChaosHeartHurt;
		spr_dead = spr.ChaosHeartDead;
		hitid = [spr_idle, "CHAOTIC CRYSTAL HEART"];
		sprite_index = spr_idle;
		
		 // Vars:
		white = true;
		meleedamage = 4;
		
		return id;
	}

#define Clone_create(_x, _y)
	/*
		Clone handler object for enemies duplicated by crystal brains
		
		Vars:
			spr_overlay - An array containing the overlay sprites. Meant to be accessed with 'flash' as the index
			clone_color - Base blend color for clones
			wave        - Incrementing variable
			clone_of    - Tracks the ID of the enemy cloned
			creator     - The brain that created the enemy
			target      - The enemy being handled
			time        - Time in frames until the enemy is destroyed; does not decrement while the brain is alive
			team        - Determines the team from which enemies will be cloned
			flash       - Boolean. Used as an index for referencing 'spr_overlay'
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		spr_overlay = [spr.CloneOverlay, spr.CloneOverlayCorpse];
		clone_color = make_color_rgb(145, 0, 43);
		image_speed = 0.4;
		
		 // Vars:
		wave = 0;
		clone_of = noone;
		creator = noone;
		clone = noone;
		time = 60 + random(60);
		team = 1;
		flash = false;
		setup = true;
		
		return id;
	}
	
#define Clone_setup
	setup = false;
	
	 // Inherit Variables:
	team = variable_instance_get(creator, "team", team);
	
	 // Find Target:
	if(!instance_exists(clone)){
		if(!instance_exists(clone_of)){
			var	_enemies = [],
				_target = noone,
				_clones = instances_matching(CustomObject, "name", "Clone");
				
			with(instances_matching([enemy, Ally], "team", team)){
				if(instance_near(x, y, other, 256)){
				
					 // Quality Assurance:
					if(!instance_is(id, becomenemy)){
						
						 // Blacklist:
						var _objName = variable_instance_get(id, "name", object_index);
						if(!array_exists([
							"CrystalBrain", 
							"CrystalHeart",
							"ChaosHeart",
							"Palanking", 
							"PitSquid", 
							"PitSquidArm", 
							"BoneRaven", 
							"Creature", 
							TechnoMancer,
							Nothing,
							Nothing2
							], _objName)){
						
							 // No Duplicate Clones:
							if(array_length(instances_matching(_clones, "clone", id)) <= 0){
								if(array_length(instances_matching(_clones, "clone_of", id)) <= 0){
									array_push(_enemies, id);
								}
							}
						}
					}
				}
			}
			
			 // Man of the Hour:
			clone_of = instance_nearest_array(x, y, _enemies);
		}
		
		if(!instance_is(clone_of, Player)){
			with(clone_of){
				_target = instance_copy(false);
				/*
				_target = instance_clone();
				*/
			}
		}
		else{
			
			 // Easter Egg:
			with(clone_of){
				_target = instance_create(x, y, Ally);
				with(_target){
					 // Visual:
					spr_idle = other.spr_idle;
					spr_walk = other.spr_walk;
					spr_hurt = other.spr_hurt;
					spr_dead = other.spr_dead;
					sprite_index = spr_idle;
					spr_weap = sprRevolver;
					
					 // Sounds:
					snd_hurt = other.snd_hurt;
					snd_dead = other.snd_dead;
					
					sound_stop(sndAllySpawn);
					sound_play(other.snd_wrld);
				}
			}
		}
		
		clone = _target;
	}
	
	if(instance_exists(clone)){
		
		 // Clone Variables:
		Clone_end_step();
		with(clone){
			raddrop = 0;
			kills = 0;
			direction += orandom(90);

			 // Disable Duplicated Boss Intros:
			if("intro" in self){
				intro = true;
			}
		}
		
		/*
		 // Encharm:
		if(lq_defget(lq_defget(clone, "ntte_charm", {}), "charmed", false)){
			var _cloneInst = clone,
				_charmData = ntte_charm;
				
			with(instances_matching(CustomScript, "name", "charm_step")){
				array_push(inst, _cloneInst);
				array_push(vars, _charmData);
			}
		}
		*/
		
		 // (Placeholder) Effects:
		with(instance_create(x, y, PlasmaTrail)){
			sprite_index = sprMutant6Dead;
			image_index  = 9;
			image_blend  = other.clone_color;
		}
		sound_play_hit_ext(sndHyperCrystalSearch, 0.8 + random(0.3), 0.5);
		scrCloneFX(x, y, xstart, ystart);
	}
	
#define Clone_step
	if(setup) Clone_setup();
	
	wave += current_time_scale;
	
	if(instance_exists(clone)){
		
		 // Effects:
		if(chance_ct(1, 5)){
			scrCrystalBrainEffect(random_range(bbox_left, bbox_right) + orandom(10), random_range(bbox_top, bbox_bottom) + orandom(10));
		}
		
		if(!instance_exists(creator)){
			if(!instance_is(clone, becomenemy)){
				time -= current_time_scale;
				flash = (floor(time / 2) % 2);
				
				if(time <= 0){
					time = 0;
					with(clone){
						my_health = 0;
					}
				}
			}
		}
	}
	
	 // Goodbye:
	else{
		instance_destroy();
	}
	
#define Clone_end_step
	if(setup) Clone_setup();
	
	if(instance_exists(clone)){
		x = clone.x;
		y = clone.y;
		with(clone){
			image_alpha = -abs(image_alpha);
			
			 // Death Effects:
			if("my_health" in self && my_health <= 0){
				sound_play_hit_ext(sndHyperCrystalRelease, 0.8 + random(0.3), 0.8);
				repeat(size + irandom(2)){
					instance_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), Smoke);
					with(instance_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), LaserCharge)){
						alarm0 = 10 + random(10);
						motion_set(90, random(0.5));
					}
				}
			}
		}
	}
	
#define scrCloneFX(_x1, _y1, _x2, _y2)
	var	_array = [],
		_dist = point_distance(_x1, _y1, _x2, _y2),
		_dir = point_direction(_x1, _y1, _x2, _y2);
		
	repeat(_dist / 12){
		var _len = random(_dist);
		array_push(_array, scrCrystalBrainEffect(_x1 + lengthdir_x(_len, _dir) + orandom(8), _y1 + lengthdir_y(_len, _dir) + orandom(8)));
	}
	
	return _array;
	
	
#define CrystalBrain_create(_x, _y)
	/*
		Mastermind. Clones enemies.
		
		Vars:
			target_x/y            - Coordinates the brain will try to navigate to
			motion_obj            - Separate object for avoiding wall collision. Trades motion and position data with the brain
			clone_num             - Number of currently active clones. Cannot excede 'clone_max'
			clone_max             - Max clone count
			teleport              - Boolean. Indicates if the brain is currently teleporting
			teleport_x/teleport_y - Position to draw at during teleportation. Doubles as a destination coordinate
			min_tele_dist         - Minimum distance from the player the brain can teleport to
			max_tele_dist         - Maximum distance from the player the brain can teleport to
			dying                 - Boolean. Tracks if the brain has entered its death phase
			death_throes          - The remaining number of throes in the death phase
			parts                 - Used in death anim
	*/

	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle      = spr.CrystalBrainIdle;
		spr_walk      = spr.CrystalBrainIdle;
		spr_hurt      = spr.CrystalBrainHurt;
		spr_dead      = spr.CrystalBrainDead;
		spr_part	  = spr.CrystalBrainPart;
		spr_appear    = spr.CrystalBrainAppear;
		spr_disappear = spr.CrystalBrainDisappear;
		spr_shadow = shd32;
		spr_shadow_y = 6;
		hitid = [spr_idle, "CRYSTAL BRAIN"];
		sprite_index = spr_hurt;
		depth = -2;
		
		 // Sounds:
		snd_hurt = sndLightningCrystalHit;
		snd_dead = sndLightningCrystalDeath;
		
		 // Vars:
		mask_index = mskBanditBoss;
		direction = random(360);
		friction = 0.1;
		maxhealth = 80;
		raddrop = 20;
		wave = 0;
		size = 3;
		walk = 0;
		walkspeed = 0.3;
		maxspeed = 1.2;
		minspeed = 0.4;
		meleedamage = 4;
		clone_num = 0;
		clone_max = 3;
		teleport = false;
		teleport_x = x;
		teleport_y = y;
		min_tele_dist = 80;
		max_tele_dist = 160;
		candie = false;
		dying = false;
		death_throes = irandom_range(3, 4);
		parts = [];
		
		 // Alarms:
		alarm1 = 90;
		
		 // NTTE:
		ntte_anim = false;
		
		return id;
	}
	
#define CrystalBrain_step
	wave += current_time_scale;
	clone_num = array_length(instances_matching(instances_matching(CustomObject, "name", "Clone"), "creator", id));
	
	 // Animate:
	if(teleport){
		if(anim_end){
			if(sprite_index == spr_appear){
				teleport = false;
				x = teleport_x;
				y = teleport_y;
				sprite_index = enemy_sprite;
				
				 // For Safety:
				with(instance_create(x, y, PortalClear)){
					mask_index = other.mask_index;
				}
			}
			if(sprite_index == spr_disappear){
				image_index -= image_speed_raw;
			}
		}
	}
	else{
		if(!dying){
			sprite_index = enemy_sprite;
		}
		else{
			if(anim_end){
				sprite_index = spr_hurt;
			}
		}
	}
	
	 // Effects:
	if(chance_ct(teleport, 4)){
		scrCrystalBrainEffect(x + orandom(32), y + orandom(32));
	}
	
	 // Dying:
	if(my_health <= 0){
		
		 // Begin Death:
		if(!dying){
			dying = true;
			
			 // Visual:
			sprite_index = spr_hurt;
			image_index = 0;
			
			 // Vars:
			friction = 0.5;
			speed = 0;
			minspeed = 0;
			maxspeed = 8;
			
			 // Parts:
			repeat(sprite_get_number(spr_part)){
				array_push(parts, {
					angle : 0,
					x_off : 0,
					y_off : 0
				});
			}
			
			sound_play_hit(sndLightningCrystalCharge, 0.3);
		}
		
		alarm1 = -1;
		walk = 0;
		
		 // Mid Death:
		var _still = (speed <= minspeed || (x == xprevious && y == yprevious));
		if(death_throes > 0){
			
			if(_still){
				death_throes--;
				
				 // Jerk Around:
				motion_set(point_direction(x, y, xstart, ystart) + orandom(30), random_range(3, 8));
				move_contact_solid(direction, 4);
				
				 // Desperation Clone:
				with(obj_create(x, y, "Clone")){
					creator = other;
				}
				
				 // Effects:
				sound_play_hit(snd_hurt, 0.3);
				view_shake_at(x, y, 15);
				repeat(2){
					with(scrFX(x, y, [random(360), random_range(2, 5)], Shell)){
						sprite_index = spr.CrystalBrainChunk;
						image_index = irandom(image_number - 1);
						image_speed = 0;
					}
				}
				
				 // Falling Apart:
				with(parts){
					x_off += orandom(8);
					y_off += orandom(8);
					angle += orandom(4);
				}
			}
			
			 // Effects:
			if(chance_ct(2, 5)){
				instance_create(x + orandom(12), y + orandom(12), Smoke);
			}
		}
		
		else{
			if(_still){
				candie = true;
			}
		}
	}
	
#define CrystalBrain_end_step
	speed = max(speed, minspeed);
	canfly = teleport;
	
#define CrystalBrain_draw
		
	if(dying){
		var _hurt = (sprite_index == spr_hurt && image_index < 1);
			
		if(_hurt) draw_set_fog(true, image_blend, 0, 0);
		for(var i = 0; i < array_length(parts); i++){
			var p = parts[i];
			
			 // Ghost:
			if(i == floor(sprite_get_number(spr_part) / 2)){
				draw_set_blend_mode(bm_add);
				draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha * 2/3);
				draw_set_blend_mode(bm_normal);
			}
			
			 // Fragments:
			draw_sprite_ext(spr_part, i, x + p.x_off + orandom(2), y + p.y_off + orandom(2), image_xscale * right, image_yscale, image_angle + p.angle, image_blend, image_alpha);
		}
		if(_hurt) draw_set_fog(false, c_white, 0, 0);
	}
	else{
		var	_x = (teleport ? teleport_x : x),
			_y = (teleport ? teleport_y : y);
			
		draw_sprite_ext(sprite_index, image_index, _x, _y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
	}
	
	/* DEPRICATED - FUNKY DRAW EFFECT
	var _yoff = sin(wave / 20);
	draw_sprite_ext(sprite_index, image_index, x, y + (wall_yoff * wall_yoff_coeff) + _yoff, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
	
	if(button_check(0, "horn")) draw_self_enemy();
	else
	
	with(surface_setup("CrystalBrain", 64, 64, 1)){
		x = other.x - (w / 2);
		y = other.y - (h / 2);
		
		for(var i = 0; i <= 1; i++){
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			
			with(other){
				var	_c = ((i == 0) ? -1 : 1),
					_w = 48,
					_h = 48,
					_segHeight = 3,
					_segStartY = (wave mod _segHeight),
					_segNumber = (_h div _segHeight);
					
				for(var j = 0; j <= _segNumber; j++){
					draw_sprite_part(
						sprite_index, 
						image_index,
						0,
						j * _segHeight - _segStartY,
						_w,
						_segHeight,
						sin((wave + (j * 2)) / 10) * (2 * _c),
						j * _segHeight - _segStartY
					);
				}
				
				draw_set_blend_mode_ext(bm_inv_src_alpha, bm_subtract);
				draw_sprite_tiled(spr.CrystalBrainSurfMask, 0, 0, view_xview_nonsync + i);
				draw_set_blend_mode(bm_normal);
			}
			
			surface_reset_target();
			
			draw_surface(surf, x, y);
		}
	}
	*/
	
#define CrystalBrain_alrm1
	alarm1 = random_range(20, 40);
	
	
	if(!teleport){
		if(enemy_target(x, y)){
			var _targetDir = point_direction(x, y, target.x, target.y),
				_canWarp = my_health < maxhealth;
			
			if(instance_seen(x, y, target)){
			
				 // Attempt Cloning:
				if(chance((1 - (clone_num / clone_max)), 1)){
					with(obj_create(x, y, "Clone")){
						_canWarp = false;
						creator = other;
					}
				}
				
				 // Get Back, Bro:
				if(instance_near(x, y, target, 64)){
					scrWalk((_targetDir + 180) + orandom(30), random_range(10, 20));
					alarm1 = walk + random(10);
				}
			}
			
			 // Warp Out:
			if(_canWarp && chance(1, 4)){
				alarm1 = 30;
				
				teleport = true;
				teleport_x = x;
				teleport_y = y;
				x = 0;
				y = 0;
				
				 // Visual:
				sprite_index = spr_disappear;
				image_index = 0;
				
				 // Effects:
				repeat(8){
					with(scrFX(teleport_x, teleport_y, [random(360), random(2)], CrystTrail)){
						sprite_index = spr.CrystalRedTrail;
					}
				}
			}
			
			 // Watch Your Back:
			if(instance_seen(x, y, target)){
				scrRight(_targetDir);
			}
		}
		
		 // Wander:
		else{
			scrWalk(random(360), random_range(20, 40));
			alarm1 = random_range(30, 60);
		}
	}
	
	 // Warp In:
	else{
		var _floors = [],
			_target = instance_nearest(x, y, Player),
			_minDis = min_tele_dist,
			_maxDis = max_tele_dist;
			
		 // Find Valid Floors:
		if(instance_exists(_target)){
			with(instances_matching_ne(FloorNormal, "name", "WallFake")){
				if(!place_meeting(x, y, Wall)){
					if(instance_near(x, y, _target, [_minDis, _maxDis])){
						array_push(_floors, id);
					}
				}
			}
			
			 // Teleport to Random Floor:
			var _targetFloor = instance_random(_floors);
			if(instance_exists(_targetFloor)){
				teleport_x = _targetFloor.x + 16;
				teleport_y = _targetFloor.y + 16;
				
				 // Visual:
				sprite_index = spr_appear;
				image_index = 0;
			}
		}
	}
	
#define CrystalBrain_death
	pickup_drop(100, 0);
	pickup_drop(50,  0);
	
	 // Effects:
	view_shake_at(x, y, 30);
	repeat(5){
		with(scrFX(x, y, [random(360), random_range(3, 7)], Shell)){
			sprite_index = spr.CrystalBrainChunk;
			image_index = irandom(image_number - 1);
			image_speed = 0;
		}
	}
	
#define scrCrystalBrainEffect(_x, _y)
	with(instance_create(_x, _y, BulletHit)){
		sprite_index = spr.CrystalBrainEffect
		image_yscale = choose(1, -1);
		image_angle = irandom(3) * 90;
		depth = other.depth + choose(-1, -1, 1);
		
		return id;
	}
	
	
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
		depth = -3;
		
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
		white = false;
		natural_death = false;
		
		 // Alarms:
		alarm1 = 30;
		
		 // Light Radius:
		dark_vertices = 30;
		dark_vertices_offsets = [];
		repeat(dark_vertices) array_push(dark_vertices_offsets, random(1));
		
		return id;
	}
	
#define CrystalHeart_step
	if(white){
		
		 // Effects:
		if(chance_ct(1, 20)){
			with(scrFX([x, 6], [y, 12], [90, random_range(0.2, 0.5)], LaserCharge)){
				sprite_index = sprSpiralStar;
				image_index = choose(0, irandom(image_number - 1));
				depth = other.depth - 1;
				alarm0 = random_range(15, 30);
			}
		}
		if(chance_ct(1, 25)){
			with(instance_create(x + orandom(6), y + orandom(12), BulletHit)){
				sprite_index = sprThrowHit;
				image_xscale = 0.2 + random(0.3);
				image_yscale = image_xscale;
				depth = other.depth - 1;
			}
		}
	}
	else{
		
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
						meleedamage = max(1, other.my_health - 1);
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
							GameCont.killenemies = true;
							sound_play_music(-1);
							with(obj_create(x, y, "WarpPortal")){
								event_perform(ev_step, ev_step_normal);
							}
						}
					}
				}
			}
		}
	}
	
#define CrystalHeart_alrm1
	alarm1 = random_range(30, 60);
	
	 // Wander:
	scrWalk(random(360), [10, 40]);
	
#define CrystalHeart_hurt(_hitdmg, _hitvel, _hitdir)
	enemy_hurt(_hitdmg, _hitvel, _hitdir);
	
	 // Anti "Wack Shit" Protocol:
	if(my_health <= 0){
		natural_death = true;
	}
	
#define CrystalHeart_death
	 // Sound:
	if(place_meeting(x, y, Portal) && GameCont.area == "red"){
		var _snd = sound_play_pitch(snd_dead, 1.3 + random(0.3));
		audio_sound_set_track_position(_snd, 0.4 + random(0.1));
		snd_dead = -1;
	}
	
	 // Unfold:
	if(natural_death){
		instance_create(x, y, PortalClear);
		var _chestTypes = [AmmoChest, WeaponChest, RadChest];
		for(var i = 0; i < 3; i++){
			with(enemy_shoot("CrystalHeartProj", (direction + (i * 120)) + orandom(4), 4)){
				chest_type = _chestTypes[i];
				
				 // Chaos Heart Area Decision:
				if(other.white){
					var _area = [GameCont.area, area],
						_loop = GameCont.loops,
						_cont = true;
						
					 // Decision Making Two:
					if(chance(1, 2)){
						var a = [GameCont.area];
						while(_cont){
							switch(a[irandom(array_length(a) - 1)]){
								case area_campfire     :                                     break;
								case area_desert       : a = [area_sewers, area_scrapyards]; break;
								case "coast"           : a = [area_scrapyards, area_jungle]; break;
								case area_oasis        :
								case "oasis"           : a = [area_sewers, area_labs];       break;
								case "trench"          : a = [area_sewers, area_caves];      break;
								case area_sewers       : a = [area_caves];                   break;
								case area_pizza_sewers :
								case "pizza"           :                                     break;
								case "lair"            :                                     break;
								case area_scrapyards   : a = [area_sewers, area_city];       break;
								case area_mansion      :                                     break;
								case area_crib         :                                     break;
								case area_caves        : a = [area_labs];                    break;
								case area_cursed_caves :                                     break;
								case area_city         : a = [area_labs, area_palace];       break;
								case area_jungle       :                                     break;
								case area_labs         : a = [area_sewers, area_caves];      break;
								case area_palace       : a = [area_scrapyards, area_labs];   break;
								case area_hq           :                                     break;
								case "red"             :                                     break;
							}
							
							 // Decrement Loop:
							_cont = (_loop >= 1 && chance(1, 2));
							if(_cont){
								_loop--;
							}
						}
						
						 // Woah:
						_area = a;
					}
					
					area = _area[irandom(array_length(_area) - 1)];
					loop = _loop;
				}
			}
		}
	}
	
	 // Effects:
	sleep(100);
	
	
#define CrystalHeartProj_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		spr_bot = spr.CrystalHeartProjMid;
		spr_top = spr.CrystalHeartProjOut;
		sprite_index = spr_top;
		image_speed = 0.4;
		
		 // Vars:
		mask_index = mskFlakBullet;
		friction = 0.4;
		damage = 3;
		force = 12;
		typ = 0;
		maxspeed = 12;
		wall_break = 3;
		area = "red";
		subarea = 1;
		areaseed = random_get_seed() + irandom(1000);
		loop = GameCont.loops;
		chest_type = AmmoChest;
		floor_goal = 10 + irandom(10);
		setup = true;
		
		 // Alarms:
		alarm0 = 12;
		
		return id;
	}
	
#define CrystalHeartProj_setup
	setup = false;
	
	 // Colorize:
	var c = image_blend;
	if(is_real(area)){
		c = area_get_background_color(area);
	}
	else{
		var _scrt = "area_background_color";
		if(mod_script_exists("area", area, _scrt)){
			c = mod_script_call("area", area, _scrt);
		}
	}
	if(c != image_blend){
		var h = color_get_hue(c),
			s = color_get_saturation(c),
			v = lerp(color_get_value(c), 255, 0.5);
			
		image_blend = make_color_hsv(h, s, v);
	}
	
#define CrystalHeartProj_step
	if(setup) CrystalHeartProj_setup();

	 // Effects:
	if(area == "red" && chance_ct(2, 3)){
		with(scrFX([x, 6], [y, 6], random(1), LaserCharge)){
			alarm0 = 5 + random(15);
		}
	}
	if(current_frame_active) with(instance_create(x, y, DiscTrail)){
		sprite_index = spr.CrystalHeartProjTrail;
		image_blend = other.image_blend;
		image_angle = random(360);
		depth = other.depth + 1;
	}
	
	 // Coast:
	if(!place_meeting(x, y, Floor)){
		instance_destroy();
	}
	
#define CrystalHeartProj_draw
	draw_sprite_ext(spr_bot,	  image_index, x, y, image_xscale, image_yscale, image_angle, c_white,	   image_alpha);
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	
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
	sleep(50);
	with(instance_create(x, y, BulletHit)) sprite_index = sprEFlakHit;
	
	 // Loopify:
	var _loop = GameCont.loops;
	GameCont.loops = loop;
	
	 // Tunnel Time:
	var	_scrt = script_ref_create(CrystalHeartProj_area_generate_setup, floor_goal, direction, areaseed),
		_genID = area_generate(area, subarea, x, y, false, false, _scrt);
		
	GameCont.loops = _loop;
		
	if(is_real(_genID)){
		var	_disMin = -1,
			_chest = chest_type,
			_chestX = x,
			_chestY = y;
			
		 // Delete Chests:
		with(instances_matching_gt([RadChest, chestprop], "id", _genID)){
			instance_delete(id);
		}
		
		 // Spawn Chest on Furthest Floor:
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
		with(chest_create(_chestX, _chestY, _chest, true)){
			with(instances_meeting(x, y, CrystalProp)){
				instance_delete(id);
			}
		}
		
		 // Prettify:
		var _noReveal = [];
		with(instances_matching_gt(Floor, "id", _genID)){
			depth = 8;
		}
		with(instances_matching_gt(TopSmall, "id", _genID)){
			if(chance(2, 5)){
				array_push(_noReveal, id);
				event_perform(ev_create, 0);
			}
		}
		
		 // Clientside Darkness:
		var _darkAreas = [area_sewers, area_caves, area_labs, "pizza", "lair", "trench"];
		if(array_exists(_darkAreas, area) && !array_exists(_darkAreas, GameCont.area)){
			with(instances_matching_gt(Floor, "id", _genID)){
				array_push(clientDarknessFloor, id);
			}
			with(TopCont){
				darkness = true;
			}
		}
		
		 // Reveal:
		with(instances_matching_gt([Floor, Wall, TopSmall], "id", _genID)){
			if(!array_exists(_noReveal, id)){
				with(floor_reveal(bbox_left, bbox_top, bbox_right, bbox_bottom, 6)){
					time_max *= 1.3;
				}
			}
		}
		
		 // Red Crown Quality Assurance:
		if(crown_current == "red"){
			with(instances_matching([PizzaEntrance, CarVenus, IceFlower], "", null)){
				instance_delete(id);
			}
		}
		
		 // Goodbye:
		if(instance_exists(enemy)) portal_poof();
		instance_create(x, y, PortalClear);
		instance_destroy();
	}
	
#define CrystalHeartProj_area_generate_setup(_goal, _direction, _seed)
	with(GenCont){
		goal = _goal;
		iswarpzone = false;
	}
	with(FloorMaker){
		goal = _goal;
		direction = round(_direction / 90) * 90;
	}
	random_set_seed(_seed);
	
	
#define CrystalPropRed_create(_x, _y)
	with(instance_create(_x, _y, CrystalProp)){
		 // Visual:
		spr_idle = spr.CrystalPropRedIdle;
		spr_hurt = spr.CrystalPropRedHurt;
		spr_dead = spr.CrystalPropRedDead;
		
		 // Sounds:
		snd_hurt = sndHitRock;
		snd_dead = sndCrystalPropBreak;
		
		 // Vars:
		maxhealth = 2;
		
		return id;
	}
	
	
#define CrystalPropWhite_create(_x, _y)
	with(instance_create(_x, _y, CrystalProp)){
		 // Visual:
		spr_idle = spr.CrystalPropWhiteIdle;
		spr_hurt = spr.CrystalPropWhiteHurt;
		spr_dead = spr.CrystalPropWhiteDead;
		
		 // Sounds:
		snd_hurt = sndHitRock;
		snd_dead = sndCrystalPropBreak;
		
		 // Vars:
		maxhealth = 2;
		
		return id;
	}
	
#define CrystalPropWhite_step
	 // Sparkly:
	if(chance_ct(1, 20)){
		with(scrFX([x, 7], [(y + 3), 7], [90, random_range(0.2, 0.5)], LaserCharge)){
			sprite_index = sprSpiralStar;
			image_index = choose(0, irandom(image_number - 1));
			depth = other.depth - 1;
			alarm0 = random_range(15, 30);
		}
	}
	if(chance_ct(1, 25)){
		with(instance_create(x + orandom(7), (y + 3) + orandom(7), BulletHit)){
			sprite_index = sprThrowHit;
			image_xscale = 0.2 + random(0.3);
			image_yscale = image_xscale;
			depth = other.depth - 1;
		}
	}
	
	
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
		depth = -3;
		
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
			
		with(instance_create(_x + lengthdir_x(_l, _d), _y + lengthdir_y(_l, _d), LaserCharge)){
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
	if(enemy_target(x, y) && instance_near(x, y, target, 240)){
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
					depth = -9;
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
		if(instance_seen(x, y, target)){
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
		depth = -12;
		
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
	if(chance(1, 25)){
		with(obj_create(x, y, "SunkenSealSpawn")){
			alarm0 = 15;
		}
	}
	
	 // Hatch 1-3 Spiders:
	else if(chance(4, 5)){
		repeat(irandom_range(1, 3)){
			obj_create(x, y, "Spiderling");
		}
	}
	
	 // Normal:
	else{
		instance_change(Cocoon, false);
		instance_destroy();
	}
	
	
#define PlasmaImpactSmall_create(_x, _y)
	var	_lastShake = UberCont.opt_shake,
		_lastFreeze = UberCont.opt_freeze;
		
	UberCont.opt_shake *= 0.5;
	UberCont.opt_freeze = 0;
	
	var _inst = instance_create(_x, _y, PlasmaImpact);
	with(_inst){
		 // Visual:
		sprite_index = spr.PlasmaImpactSmall;
		
		 // Vars:
		mask_index = msk.PlasmaImpactSmall;
		damage = 2;
		force = 6;
	}
	
	UberCont.opt_shake = _lastShake;
	UberCont.opt_freeze = _lastFreeze;
	
	return _inst;
	
	
#define RedSpider_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle = spr.RedSpiderIdle;
		spr_walk = spr.RedSpiderWalk;
		spr_hurt = spr.RedSpiderHurt;
		spr_dead = spr.RedSpiderDead;
		sprite_index = spr_idle;
		spr_shadow = shd24;
		hitid = [spr_idle, `@(color:${mod_script_call("area", "red", "area_background_color")})RED SPIDER`];
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
		target_seen = false;
		
		 // Alarms:
		alarm1 = irandom_range(30, 60);
		
		return id;
	}
	
#define RedSpider_alrm1
	alarm1 = irandom_range(10, 30);
	
	if(enemy_target(x, y)){
		var	_targetDir  = point_direction(x, y, target.x, target.y),
			_targetSeen = instance_seen(x, y, target);
			
		if(_targetSeen) target_seen = true;
		
		 // Attack:
		if(chance(2, 3) && instance_near(x, y, target, 96)){
			alarm1 = 45;
			walk = 0;
			speed /= 2;
			scrRight(_targetDir);
			
			var _last = noone;
			
			for(var i = -1; i <= 1; i++){
				var	l = 128,
					d = (i * 90) + (round(_targetDir / 45) * 45) + orandom(2);
					
				with(enemy_shoot_ext(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "VlasmaBullet", d + 180, 1)){
					sprite_index = spr.EnemyVlasmaBullet;
					target = other;
					target_x = other.x;
					target_y = other.y;
					_last = id;
				}
			}
			
			 // Effects:
			with(_last){
				my_sound = sound_play_hit_ext(sndHyperCrystalSpawn, 0.9 + random(0.3), 0.8);
			}
		}
		
		 // Towards Target:
		else if(_targetSeen || target_seen){
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
	target_seen = true;
	
#define RedSpider_death
	pickup_drop(20, 0);
	
	 // Plasma:
	with(team_instance_sprite(1, enemy_shoot(PlasmaImpact, 0, 0))){
		mask_index = mskPopoPlasmaImpact;
		with(instance_create(x, y, PortalClear)){
			mask_index   = other.mask_index;
			sprite_index = other.sprite_index;
			image_index  = other.image_index;
			image_xscale = other.image_xscale;
			image_yscale = other.image_yscale;
			image_angle  = other.image_angle;
			visible = false;
		}
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
		size = 0;
		walk = 0;
		walkspeed = 0.8;
		maxspeed = 3;
		nexthurt = current_frame + 15;
		direction = random(360);
		
		 // Cursed:
		curse = (GameCont.area == area_cursed_caves);
		if(curse > 0){
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
	var _obj = ((curse > 0) ? InvSpider : Spider);
	with(instance_create(x, y, _obj)){
		x = other.x;
		y = other.y;
		creator = other;
		right = other.right;
		alarm1 = 10 + random(10);
		
		 // Out of Wall:
		instance_budge(Wall, -1);
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
	if(curse > 0) repeat(curse){
		instance_create(x, y, Curse);
	}
	
	 // Move Towards Target:
	if(instance_seen(x, y, target) && instance_near(x, y, target, 96)){
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
		repeat(3 * max(1, _chance)){
			with(obj_create(x, y, "Spiderling")){
				sprite_index = spr_hurt;
				alarm0 = ceil(other.alarm0 / 2);
				curse = other.curse / 2;
				kills = other.kills;
				raddrop = 0;
			}
		}
	}
	
	
#define TwinOrbital_create(_x, _y)
	with(instance_create(_x, _y, CustomSlash)){
		 // Visual:
		sprite_index = spr.PetTwinsRed;
		image_speed = 0;
		depth = -3;
		
		 // Vars:
		mask_index = mskFreak;
		creator = noone;
		leader = noone;
		white = false;
		setup = true;
		damage = 2;
		force = 4;
		team = 2;
		kick = 0;
		kick_dir = 0;
		twin = noone;
		free = false;
		
		return id;
	}
	
#define TwinOrbital_setup
	setup = false;
	
	if(white){
		sprite_index = spr.PetTwinsWhite;
	}
	
#define TwinOrbital_step
	if(setup) TwinOrbital_setup();

	 // Visibilize:
	var _lastFree = free;
	free = (place_meeting(x, y, Floor) && !place_meeting(x, y, TopSmall));
	
	 // Effects:
	if(free != _lastFree){
		instance_create(x, y, ThrowHit)
	}
	if(free){
		if(white){
			if(chance_ct(1, 20)){
				with(scrFX([x, 8], [y, 8], [90, random_range(0.2, 0.5)], LaserCharge)){
					sprite_index = sprSpiralStar;
					image_index = choose(0, irandom(image_number - 1));
					depth = other.depth - 1;
					alarm0 = random_range(15, 30);
				}
			}
			if(chance_ct(1, 25)){
				with(instance_create(x + orandom(8), y + orandom(8), BulletHit)){
					sprite_index = sprThrowHit;
					image_xscale = 0.2 + random(0.3);
					image_yscale = image_xscale;
					depth = other.depth - 1;
				}
			}
		}
	}
	
	 // Kick:
	kick = max(abs(kick) - current_time_scale, 0) * sign(kick);
	
	
#define TwinOrbital_hit
	if(free && projectile_canhit_melee(other)){
		projectile_hit(other, damage, force, direction);
		
		 // Game Feel:
		sleep_max(20);
		kick = 4;
		kick_dir = lerp(point_direction(x, y, other.x, other.y), direction, 0.5);
	}
	
#define TwinOrbital_projectile
	var _projDir = other.direction;
	
	 // Divert:
	if(instance_exists(twin)){
		kick = 6;
		kick_dir = _projDir;
		
		scrTwinOrbitalFX(x, y, _projDir);
		repeat(irandom_range(1, 3)){
			with(scrFX(x, y, [_projDir + orandom(10), random(1)], LaserCharge)){
				alarm0 = random_range(10, 20);
			}
		}
		
		with(twin){
			kick = -3;
			kick_dir = _projDir;
		
			scrTwinOrbitalFX(x, y, _projDir);
			repeat(irandom_range(1, 3)){
				with(scrFX(x, y, [_projDir + orandom(10), random(1)], LaserCharge)){
					sprite_index = sprSpiralStar;
					alarm0 = random_range(10, 20);
				}
			}
		}
		
		if(twin.free){
			var _twin = twin;
			with(team_instance_sprite(team, other)){
				team = other.team;
				x = _twin.x;
				y = _twin.y;
			}
		}
		
		else{
			instance_delete(other);
		}
	}
	
	 // Oh Well:
	else{
		instance_create(x, y, Smoke);
		instance_delete(other);
	}

	
	 // Stat:
	with(creator){
		if("stat" in self && "diverted" in stat){
			stat.diverted++;
		}
	}
	
#define TwinOrbital_draw
	if(free){
		draw_sprite_ext(sprite_index, image_index, x + lengthdir_x(kick, kick_dir), y + lengthdir_y(kick, kick_dir), image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	}
	
#define scrTwinOrbitalFX(_x, _y, _dir)
	var _sprite = (white ? spr.PetTwinsEffectWhite : spr.PetTwinsEffectRed);
	with(instance_create(_x, _y, BulletHit)){
		sprite_index = _sprite;
		image_angle = _dir;
		depth = other.depth - 1;
		
		return id;
	}
	
	
#define VlasmaBullet_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.VlasmaBullet;
		image_speed = 0.4;
		depth = -8;
		
		 // Vars:
		mask_index = mskEnemyBullet1;
		damage = 2;
		force = 1;
		typ = 1;
		maxspeed = 8;
		addspeed = 0.4;
		target = noone;
		target_x = x;
		target_y = y;
		my_sound = -1;
		
		return id;
	}
	
#define VlasmaBullet_step
	 // Follow Target:
	if(instance_exists(target)){
		target_x = target.x;
		target_y = target.y;
	}
	
	 // Movement:
	if(image_speed == 0){
		 // Acceleration:
		var	_euphoria = (instance_is(creator, Player) ? 1 : power(0.8, skill_get(mut_euphoria))),
			_speedMax = maxspeed * _euphoria,
			_speedAdd = addspeed * _euphoria * current_time_scale;
			
		speed += clamp(_speedMax - speed, -_speedAdd, _speedAdd);
		
		 // Turn:
		var _turn = angle_difference(point_direction(x, y, target_x, target_y), direction);
		_turn *= clamp(speed / point_distance(x, y, target_x, target_y), 0.1, 1);
		_turn *= min(current_time_scale, 1);
		direction += _turn;
		image_angle += _turn;
	}
	
	 // Particles:
	if(chance_ct(1, 4)){
		with(team_instance_sprite(
			sprite_get_team(sprite_index),
			scrFX([x, 4], [y, 4], [direction, 2 * (speed / maxspeed)], PlasmaTrail)
		)){
			depth = other.depth;
		}
	}
	
	 // Passing Through Walls:
	xprevious += hspeed_raw;
	yprevious += vspeed_raw;
	
	 // Target Acquired, Sweet Prince:
	if(image_speed == 0){
		if(
			(instance_exists(target) && team != variable_instance_get(target, "team"))
			? place_meeting(x, y, target)
			: point_distance(x, y, target_x, target_y) <= 8 + speed_raw
		){
			instance_destroy();
		}
	}
	
#define VlasmaBullet_draw
	draw_self();
	
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
	
#define VlasmaBullet_anim
	if(instance_exists(self)){
		image_index = image_number - 1;
		image_speed = 0;
	}
	
#define VlasmaBullet_hit
	if(image_speed == 0 && projectile_canhit_melee(other)){
		projectile_hit_push(other, damage, force);
	}
	
#define VlasmaBullet_wall
	 // Passing Through Walls: *Movement Fix
	x -= hspeed_raw;
	y -= vspeed_raw;
	
#define VlasmaBullet_destroy
	 // Sound:
	sound_stop(my_sound);
	sound_play_hit_ext(sndLaser,        1.1 + random(0.3), 1);
	sound_play_hit_ext(sndLightningHit, 0.9 + random(0.2), 1);
	
	 // Explo:
	with(team_instance_sprite(
		sprite_get_team(sprite_index),
		enemy_shoot("PlasmaImpactSmall", direction, 0)
	)){
		image_angle = 0;
		depth = other.depth;
	}
	
	
#define WallFake_create(_x, _y)
	/*
		Illusory walls. Drawn through draw_fake_walls().
		
		Vars:
			out_free - enables drawing the out sprite.
			bot_free - enables drawing the bottom sprite.
	*/
	
	with(floor_set(_x, _y, true)){
		 // Visual:
		sprite_index = spr.FloorRedB;
		
		 // Vars:
		depth = 10;
		out_free = true;
		bot_free = true;
		styleb = true;
		
		return id;
	}
	
#define WallFake_step
	/*
	 // Determine Open Faces:
	out_free = false;
	bot_free = false;
	 
	var l = 32;
	for(var d = 0; d < 360; d += 90){
		var _x = x + lengthdir_x(l, d),
			_y = y + lengthdir_y(l, d);
			
		if(array_length(instance_rectangle_bbox(_x, _y, (_x + 31), (_y + 31), Floor)) > 0){
			if(d == 270){
				bot_free = true;
			}
			else{
				out_free = true;
			}
		}
	}
	*/
	
	 // Repel Enemies:
	if(out_free || bot_free){
		with(instances_meeting(x, y, enemy)){
			if(!place_meeting(x - hspeed, y - vspeed, other)){
				
				 // Horizontal Collision:
				if(!place_meeting(x - hspeed, y, other)){
					repeat(5){
						with(instance_create((sign(hspeed) ? bbox_right : bbox_left) + orandom(2), random_range(min(bbox_top, other.bbox_top), max(bbox_bottom, other.bbox_bottom)), PlasmaTrail)){
							sprite_index = spr.EnemyPlasmaTrail;
						}
					}
					x -= hspeed;
					hspeed *= -1;
				} 
				
				 // Vertical Collision:
				if(!place_meeting(x, y - vspeed, other)){
					repeat(5){
						with(instance_create(random_range(min(bbox_right, other.bbox_right), max(bbox_left, other.bbox_left)), (sign(vspeed) ? bbox_bottom : bbox_top) + orandom(2), PlasmaTrail)){
							sprite_index = spr.EnemyPlasmaTrail;
						}
					}
					y -= vspeed;
					vspeed *= -1;
				}
			}
		}
	}
	
	
#define Warp_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		spr_open = spr.WarpOpen;
		sprite_index = spr.Warp;
		image_speed = 0.4;
		depth = -7;
		
		 // Vars:
		mask_index = mskWepPickup;
		open = false;
		
		 // Alarms:
		alarm0 = 30;
		
		return id;
	}
	
#define Warp_step
	image_angle += current_time_scale;
	
	 // Sparkly:
	if(chance_ct(1, 15)){
		with(instance_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), LaserCharge)){
			sprite_index = sprSpiralStar;
			image_index = choose(0, irandom(image_number - 1));
			alarm0 = random_range(15, 30);
			motion_set(90, random_range(0.2, 0.5));
		}
	}
	if(chance_ct(1, 20)){
		with(instance_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), BulletHit)){
			sprite_index = sprThrowHit;
			image_xscale = 0.2 + random(0.3);
			image_yscale = image_xscale;
		}
	}
	
#define Warp_draw
	draw_set_blend_mode(bm_add);
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha / 10);
	draw_set_blend_mode(bm_normal);
	
#define Warp_alrm0
	if(instance_number(enemy) - instance_number(Van) <= 0){
		var p = instance_nearest(x, y, Player);
		if(instance_exists(p) && !place_meeting(x, y, p)){
			open = true;
			sprite_index = spr_open;
			
			exit;
		}
	}

	alarm0 = 30 + random(60);

#define WarpPortal_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = sprPortalClear;
		depth = -8;
		
		 // Vars:
		mask_index = sprPortalShock;
		image_xscale = 0.6;
		image_yscale = image_xscale;
		
		 // Portal:
		portal = instance_create(x, y, BigPortal);
		with(portal){
			x = other.x;
			y = other.y;
			sprite_index = sprBigPortal;
			image_alpha = 0;
		}
		instance_create(x, y, PortalShock);
		
		 // Effects:
		repeat(30){
			var	l = 32 + random(8),
				d = random(360);
				
			with(scrFX(x + lengthdir_x(l, d), y + lengthdir_y(l, d), [d, 4 + random(2)], Dust)){
				friction = 0.4;
				sprite_index = sprSmoke;
			}
		}
		view_shake_at(x, y, 50);
		sleep(100);
		
		return id;
	}
	
#define WarpPortal_step
	 // Shrink:
	if(!instance_exists(portal) || portal.endgame < 100){
		var _shrinkSpeed = 1/80 * current_time_scale;
		image_xscale -= _shrinkSpeed;
		image_yscale -= _shrinkSpeed;
	}
	
	 // Destroy Walls:
	if(place_meeting(x, y, Wall)){
		with(instances_meeting(x, y, Wall)){
			if(place_meeting(x, y, other)){
				instance_create(x, y, FloorExplo);
				instance_destroy();
			}
		}
	}
	
	 // Grab Player:
	with(instances_matching(Player, "visible", true)){
		if(place_meeting(x, y, other) || position_meeting(x, y, other)){
			visible = false;
			direction = point_direction(x, y, other.x, other.y);
			
			 // Wacky Effect:
			with(instance_create(x, y, Dust)){
				speed = max(3, other.speed);
				direction = other.direction;
				sprite_index = other.spr_hurt;
				image_index = 1;
				image_xscale = abs(other.image_xscale * other.right);
				image_yscale = abs(other.image_yscale);
				image_angle = other.sprite_angle + other.angle + orandom(30);
				image_blend = other.image_blend;
				image_alpha = other.image_alpha;
				depth = -9;
				growspeed *= 2/3;
				
				 // Pink Flash:
				with(instance_create(x , y, ThrowHit)){
					motion_add(other.direction, 1);
					image_speed = 0.5;
					image_blend = make_color_rgb(255, 0, 80);
					depth = other.depth - 1;
				}
			}
		}
	}
	
	 // Effects:
	if(current_frame_active){
		var	l = 64,
			d = random(360);
			
		with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), LaserCharge)){
			alarm0 = random_range(15, 20);
			motion_set(d + 180, random_range(1, 2));
			sprite_index = sprSpiralStar;
			direction = d + 180;
			speed = l / alarm0;
		}
	}
	if(chance_ct(1, 5)){
		var	l = random_range(32, 128),
			d = random(360);
			
		with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), BulletHit)){
			sprite_index = sprWepSwap;
		}
	}
	
	 // Later, Bro:
	if(image_xscale <= 0 || image_yscale <= 0){
		instance_destroy();
		exit;
	}
	
#define WarpPortal_draw
	image_alpha = abs(image_alpha); // CustomObject
	
	var	_ext = random(3),
		_xsc = image_xscale + (_ext / sprite_get_width(sprite_index)),
		_ysc = image_yscale + (_ext / sprite_get_height(sprite_index));
		
	draw_sprite_ext(sprite_index, image_index, x, y, _xsc, _ysc, image_angle, image_blend, image_alpha);
	
	image_alpha = -abs(image_alpha); // CustomObject
	
#define WarpPortal_destroy
	 // Blip Out:
	with(instance_create(x, y, BulletHit)){
		sprite_index = sprThrowHit;
	}
	
	
/// GENERAL
#define ntte_step
	 // Wall Shine:
	with(surfWallShineMask){
		if(
			(instance_number(Wall) != lq_defget(self, "wall_num", 0)) ||
			(instance_exists(Wall) && lq_defget(self, "wall_min", 0) < Wall.id)
		){
			reset = true;
			
			 // Update Vars:
			wall_num  = instance_number(Wall);
			wall_min  = GameObject.id;
			inst_tops = instances_matching(TopSmall, "sprite_index", spr.WallRedTrans, spr.WallRedTop);
			inst_wall = instances_matching(Wall,     "topspr",       spr.WallRedTrans, spr.WallRedTop);
		}
		
		 // Time to Shine:
		if(array_length(inst_tops) > 0 || array_length(inst_wall) > 0){
			script_bind_draw(draw_wall_shine, -6.0001);
			
			 // Crystal Tunnel Particles:
			if(GameCont.area != "red"){
				if(chance_ct(1, 40)){
					do var i = irandom(maxp - 1);
					until player_is_active(i);
					mod_script_call_nc("area", "red", "area_effect", view_xview[i], view_yview[i]);
				}
			}
		}
	}
	
	 // Fake Walls:
	var _inst = WallFake;
	if(array_length(_inst) > 0){
		var _frame = (current_frame / 10) % sprite_get_number(spr.WallFakeBot);
		script_bind_draw(draw_fake_walls,  0, instances_matching(_inst, "bot_free", true), spr.WallFakeBot, _frame);
		script_bind_draw(draw_fake_walls, -6, instances_matching(_inst, "out_free", true), spr.WallFakeOut, 0);
		script_bind_draw(draw_fake_walls, -7, _inst, spr.WallFakeTop, 0);
	}
	with(Player){ // Player Visibility
		 // Increment:
		var _array = wallFakePlayerVisible;
		if(array_length(instances_meeting(x, y, _inst)) > 0){
			_array[index] = min(_array[index] + current_time_scale / 10, 1);
		}
		
		 // Decrement:
		else{
			_array[index] = max(_array[index] - current_time_scale / 10, 0);
		}
	}
	
	 // Clone Draw:
	var	_clones = instances_matching(CustomObject, "name", "Clone"),
		_corpse = []; // instances_matching(Corpse, "ntte_clonecorpse", true);
		
	if(array_length(_clones) > 0){
		script_bind_draw(draw_clones, -2, _clones, spr.CloneOverlay, 0.4);
	}
	/*
	if(array_length(_corpse) > 0){
		script_bind_draw(draw_clones, 1, _corpse, spr.CloneOverlayCorpse, 0.2);
	}
	*/
		
	 // Client-Side Darkness:
	clientDarknessFloor = instances_matching(clientDarknessFloor, "", null);
	with(Player){
		if(array_length(clientDarknessFloor) > 0){
			var _num = clientDarknessCoeff[index],
				_spd = current_time_scale / 5,
				_inDark = false;
				
			with(instances_meeting(x, y, clientDarknessFloor)){
				_inDark = true;
				break;
			}
			
			if(_inDark){
				_num -= _spd;
			}
			else{
				_num += _spd;
			}
			
			clientDarknessCoeff[index] = clamp(_num, 0, 1);
		}	
		else{
			clientDarknessCoeff[index] = 1;
		}
	}
	
#define ntte_end_step
	 // Spider Cocoons:
	with(Cocoon){
		obj_create(x, y, "NewCocoon");
		instance_delete(id);
	}
	
	 // Scramble Cursed Caves Weapons:
	with(instances_matching(WepPickup, "cursedcavescramble_check", null)){
		cursedcavescramble_check = false;
		
		if(GameCont.area == area_cursed_caves){
			if(roll && wep_get(wep) != "merge"){
				if(!position_meeting(xstart, ystart, ChestOpen) || chance(1, 3)){
					cursedcavescramble_check = true;
					
					 // Reset Merged Weapon Text:
					mergewep_indicator = null;
					
					 // Curse:
					curse = max(1, curse);
					
					 // Scramble:
					var _part = wep_merge_decide(0, GameCont.hard + (2 * curse));
					if(array_length(_part) >= 2){
						wep = wep_merge(_part[0], _part[1]);
					}
				}
			}
		}
	}
	
#define ntte_shadows
	 // Mortar Plasma:
	with(instances_matching(instances_matching(CustomProjectile, "name", "MortarPlasma"), "visible", true)){
		if(position_meeting(x, y, Floor)){
			var	_percent = clamp(96 / z, 0.1, 1),
				_w = ceil(18 * _percent),
				_h = ceil(6 * _percent),
				_x = x,
				_y = y;
				
			draw_ellipse(_x - (_w / 2), _y - (_h / 2), _x + (_w / 2), _y + (_h / 2), false);
		}
	}
	
#define ntte_bloom
	 // Crystal Heart Projectile:
	with(instances_matching(projectile, "name", "CrystalHeartOrb")){
		var	_scale = 2,
			_alpha = 0.1;
			
		 // Copy pasting code is truly so epic:
		image_xscale *= _scale;
		image_yscale *= _scale;
		image_alpha  *= _alpha;
		event_perform(ev_draw, 0);
		image_xscale /= _scale;
		image_yscale /= _scale;
		image_alpha  /= _alpha;
	}
	
	 // Teleport FX:
	with(instances_matching(CustomObject, "name", "WarpPortal")){
		var	_scale = 2,
			_alpha = 0.1;
			
		image_xscale *= _scale;
		image_yscale *= _scale;
		image_alpha  *= _alpha;
		event_perform(ev_draw, 0);
		image_xscale /= _scale;
		image_yscale /= _scale;
		image_alpha  /= _alpha;
	}
	
#define ntte_dark // Drawing Grays
	 // Crystal Heart:
	with(instances_matching(instances_matching(CustomEnemy, "name", "CrystalHeart", "ChaosHeart"), "visible", true)){
		draw_crystal_heart_dark(45, 72 + random(2), 3);
	}
	
	 // Mortar:
	with(instances_matching(instances_matching(CustomEnemy, "name", "Mortar", "InvMortar"), "visible", true)){
		if(sprite_index == spr_fire){
			draw_circle(x + (6 * right), y - 16, 48 - alarm1 + orandom(4), false)
		}
	}

	 // Mortar Plasma:
	with(instances_matching(instances_matching(CustomProjectile, "name", "MortarPlasma"), "visible", true)){
		draw_circle(x, y - z, 64 + orandom(1), false);
	}
	
#define ntte_dark_end // Drawing Clear
	 // Client-Side Darkness:
	if(array_length(clientDarknessFloor) > 0){
		var _alph = draw_get_alpha(),
			_vx = view_xview_nonsync,
			_vy = view_yview_nonsync;
			
		draw_set_alpha(clientDarknessCoeff[player_find_local_nonsync()]);
		draw_rectangle(_vx, _vy, _vx + game_width, _vy + game_height, false);
		draw_set_alpha(_alph);
		
		 // Crystal Heart:
		with(instances_matching(instances_matching(CustomEnemy, "name", "CrystalHeart", "ChaosHeart"), "visible", true)){
			draw_crystal_heart_dark(15, 24 + random(2), 2);
		}
	}
	
	 // Mortar:
	with(instances_matching(instances_matching(CustomEnemy, "name", "Mortar", "InvMortar"), "visible", true)){
		if(sprite_index == spr_fire){
			draw_circle(x + (6 * right), y - 16, 24 - alarm1 + orandom(4), false)
		}
	}
	
	 // Mortar Plasma:
	with(instances_matching(instances_matching(CustomProjectile, "name", "MortarPlasma"), "visible", true)){
		draw_circle(x, y - z, 32 + orandom(1), false);
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
	if(lag) trace_time();
	
	var	_vx = view_xview_nonsync,
		_vy = view_yview_nonsync,
		_gw = game_width,
		_gh = game_height,
		_surfScale = option_get("quality:minor");
		
	 // Wall Shine Mask:
	with(surface_setup("RedWallShineMask", _gw * 2, _gh * 2, _surfScale)){
		var	_surfX = pfloor(_vx, _gw),
			_surfY = pfloor(_vy, _gh);
			
		if(reset || x != _surfX || y != _surfY){
			reset = false;
			x = _surfX;
			y = _surfY;
			
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
				
				 // Background:
				if(background_color == mod_script_call_nc("area", "red", "area_background_color")){
					draw_clear(background_color);
					
					 // Cut Out Floors & Walls:
					draw_set_blend_mode_ext(bm_inv_src_alpha, bm_inv_src_alpha);
					with(instance_rectangle_bbox(x, y, x + w, y + h, Floor)){
						draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, image_blend, image_alpha);
					}
					with(instance_rectangle_bbox(x, y, x + w, y + h, Wall)){
						draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, image_blend, image_alpha);
						draw_sprite_ext(topspr, topindex, (x - _surfX) * _surfScale, (y - 8 - _surfY) * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
					}
					with(instance_rectangle_bbox(x, y, x + w, y + h, TopSmall)){
						draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - 8 - _surfY) * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
					}
					draw_set_blend_mode(bm_normal);
				}
				
				 // Red Crystal Wall Tops:
				inst_tops = instances_matching(inst_tops, "", null);
				inst_wall = instances_matching(inst_wall, "", null);
				with(inst_tops) draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - 8 - _surfY) * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
				with(inst_wall) draw_sprite_ext(topspr,       topindex,    (x - _surfX) * _surfScale, (y - 8 - _surfY) * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
				
			surface_reset_target();
		}
	}
	
	 // Wall Shine:
	with(surface_setup("RedWallShine", _gw, _gh, _surfScale)){
		x = _vx;
		y = _vy;
		
		if("wave" not in self) wave = 0;
		wave += current_time_scale * random_range(1, 2);
		
		var	_surfX         = x,
			_surfY         = y,
			_shineAng      = 45,
			_shineSpeed    = 10,
			_shineWidth    = (30 + orandom(2)) * _surfScale,
			_shineInterval = 240, // 4-8 Seconds ('wave' adds 1~2)
			_shineDisMax   = sqrt(2 * sqr(max(_gw, _gh))),
			_shineDis      = (_shineSpeed * wave) % (_shineDisMax + (_shineInterval * _shineSpeed)),
			_shineX        = (_vx - _surfX       + lengthdir_x(_shineDis, _shineAng)) * _surfScale,
			_shineY        = (_vy - _surfY + _gh + lengthdir_y(_shineDis, _shineAng)) * _surfScale,
			_shineXOff     = lengthdir_x(_shineDisMax, _shineAng + 90) * _surfScale,
			_shineYOff     = lengthdir_y(_shineDisMax, _shineAng + 90) * _surfScale;
			
		if(_shineDis < _shineDisMax){
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
				
				 // Mask:
				draw_set_fog(true, c_black, 0, 0);
				with(surfWallShineMask){
					draw_surface_scale(
						surf,
						(x - _surfX) * _surfScale,
						(y - _surfY) * _surfScale,
						_surfScale / scale
					);
				}
				with(other){
					with(instances_matching(instances_matching(CustomEnemy, "name", "RedSpider"), "visible", true)){
						x -= _surfX;
						y -= _surfY;
						image_xscale *= _surfScale;
						image_yscale *= _surfScale;
						event_perform(ev_draw, 0);
						x += _surfX;
						y += _surfY;
						image_xscale /= _surfScale;
						image_yscale /= _surfScale;
					}
					with(instances_matching(instances_matching(CrystalProp, "name", "CrystalPropRed"), "visible", true)){
						draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, image_blend, image_alpha);
					}
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
			draw_surface_scale(surf, x, y, 1 / scale);
			draw_set_blend_mode(bm_normal);
			draw_set_alpha(1);
		}
	}
	
	if(lag) trace_time(script[2]);
	
	instance_destroy();
	
#define draw_fake_walls(_inst, _sprite, _frame)
	if(lag) trace_time();
	
	var _vx = view_xview_nonsync,
		_vy = view_yview_nonsync,
		_gw = game_width,
		_gh = game_height;
		
	with(surface_setup("WallFake", _gw, _gh, option_get("quality:minor"))){
		x = _vx;
		y = _vy;
		
		var _surfScale = scale;
		
		surface_set_target(surf);
		draw_clear_alpha(0, 0);
			
			 // Draw Fake Wall Sprite:
			with(instances_seen_nonsync(_inst, 48, 48)){
				draw_sprite_ext(_sprite, _frame, (x - _vx) * _surfScale, (y - _vy) * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
			}
			
			 // Drawing Cutout:
			var p = player_find_local_nonsync(),
				c = wallFakePlayerVisible[p],
				r = (32 + sin(current_frame / 10)) * lerp(0.2, c, c);
				
			if(c > 0){
				with(player_find(p)){
					draw_set_blend_mode(bm_subtract);
					draw_circle((x - _vx) * _surfScale, (y - _vy) * _surfScale, r * _surfScale, false);
					draw_set_blend_mode(bm_normal);
					
					draw_set_color_write_enable(true, true, true, false);
					draw_set_color(wallFakeTransitionCol);
					draw_circle((x - _vx) * _surfScale, (y - _vy) * _surfScale, (r + 0.5) * _surfScale, false);
					draw_set_color_write_enable(true, true, true, true);
					draw_set_color(c_white);
				}
			}
			
			/*
			 // Wall Silhouette:
			draw_set_color_write_enable(true, true, true, false);
			draw_set_fog(true, merge_color(background_color, c_black, 0.5), 0, 0);
			
			var i = player_find_local_nonsync();
			with(player_find(i)){
				x -= _vx;
				y -= _vy;
				
				with(self) event_perform(ev_draw, 0);
				
				x += _vx;
				y += _vy;
			}
			
			draw_set_color_write_enable(true, true, true, true);
			draw_set_fog(false, 0, 0, 0);
			*/
			
		surface_reset_target();
		
		 // Draw:
		draw_surface_scale(surf, x, y, 1 / scale);
	}
	
	if(lag) trace_time(script[2]);
	
	 // Goodbye:
	instance_destroy();
	
#define draw_clones(_inst, _sprite, _speed)
	if(lag) trace_time();
	
	var _vx = view_xview_nonsync,
		_vy = view_yview_nonsync,
		_gw = game_width,
		_gh = game_height;
		
	with(surface_setup("Clones", _gw, _gh, game_scale_nonsync)){
		x = _vx;
		y = _vy;
		
		 // Copy & Clear Screen:
		draw_set_blend_mode_ext(bm_one, bm_zero);
		surface_screenshot(surf);
		draw_set_alpha(0);
		draw_surface_scale(surf, x, y, 1 / scale);
		draw_set_alpha(1);
		draw_set_blend_mode(bm_normal)
		
		 // Draw Clones:
		draw_set_color(baseCloneCol);
		with(instances_matching(_inst, "", null)){
			if(flash) draw_set_fog(true, c_black, 0, 0);
			with(clone){
				image_alpha = abs(image_alpha);
				with(self) event_perform(ev_draw, 0);
				image_alpha *= -1;
			}
			if(flash) draw_set_fog(false, c_white, 0, 0);
		}
		draw_set_color(c_white);
		
		 // Epic Overlay:
		draw_set_color_write_enable(true, true, true, false);
		draw_set_blend_mode(bm_add);
		with(other) draw_sprite_tiled(_sprite, current_frame * _speed, 0, 0);
		draw_set_blend_mode(bm_normal);
		draw_set_color_write_enable(true, true, true, true);
		
		 // Redraw Screen:
		surface_screenshot(surf);
		draw_set_blend_mode_ext(bm_one, bm_zero);
		draw_surface_scale(surf, x, y, 1 / scale);
		draw_set_blend_mode(bm_normal);
	}
	
	if(lag) trace_time(script[2]);
	
	 // Goodbye:
	instance_destroy();
	
	
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
#define enemy_shoot(_object, _dir, _spd)                                                return  mod_script_call(   'mod', 'telib', 'enemy_shoot', _object, _dir, _spd);
#define enemy_shoot_ext(_x, _y, _object, _dir, _spd)                                    return  mod_script_call(   'mod', 'telib', 'enemy_shoot_ext', _x, _y, _object, _dir, _spd);
#define enemy_target(_x, _y)                                                            return  mod_script_call(   'mod', 'telib', 'enemy_target', _x, _y);
#define boss_hp(_hp)                                                                    return  mod_script_call_nc('mod', 'telib', 'boss_hp', _hp);
#define boss_intro(_name)                                                               return  mod_script_call_nc('mod', 'telib', 'boss_intro', _name);
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