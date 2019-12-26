#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.sav = mod_variable_get("mod", "teassets", "sav");

	global.debug_lag = false;

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

#macro surfShadowTop global.surfShadowTop

#define BoneRaven_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle = spr.BoneRavenIdle;
		spr_walk = spr.BoneRavenWalk;
		spr_hurt = spr.BoneRavenHurt;
		spr_dead = spr.BoneRavenDead;
		spr_lift = spr.BoneRavenLift;
		spr_land = spr.BoneRavenLand;
		spr_fly  = spr.BoneRavenFly;
		sprite_index = spr_idle;
		spr_shadow = shd24;
		hitid = [spr_idle, "RAVEN"];
		depth = -3;
		
		 // Sounds:
		snd_hurt = sndRavenHit;
		snd_dead = sndRavenDie;
		
		 // Vars:
		mask_index = mskBandit;
		maxhealth = 10;
		raddrop = 5;
		size = 1;
		kills = 0;
		max_kills = 0;
		walk = 0;
		walkspeed = 0.8;
		maxspeed = 3.5;
		target = noone;
		active = false;
		creator = noone;
		fly_obj = noone;
		
		 // Alarms:
		alarm1 = -1;
		alarm2 = -1;
		
		 // NTTE:
		ntte_anim = false;
		
		return id;
	}
	
#define BoneRaven_step
	 // Animate:
	if(sprite_index != spr_lift && sprite_index != spr_fly && sprite_index != spr_land){
		sprite_index = enemy_sprite;
	}

	if(instance_exists(fly_obj)){
		 // Shadow Moment:
		spr_shadow_x = fly_obj.x;
		spr_shadow_y = fly_obj.y;
		x = 0;
		y = 0;
		
		 // Flying:
		with(fly_obj){
			var _zSpd = 3 * current_time_scale,
				_fSpd = 6 * current_time_scale;
			
			if(x == x_target && y == y_target){
				z -= _zSpd;
				with(other){
					if(sprite_index != spr_land){
						sprite_index = spr_land;
					}
				}
				
				 // Land:
				if(z <= 0){
					with(other){
						canfly = false;
						alarm1 = 30;
						x = other.x;
						y = other.y;
						xprevious = x;
						yprevious = y;
						spr_shadow_x = 0;
						spr_shadow_y = 0;
						sprite_index = spr_idle;
					}
					
					 // Effects:
					repeat(6) scrFX(x + orandom(8), y + random(16), 3 + random(1), Dust);
					if(point_seen(x, y, -1)) sound_play_hit(sndRavenLift, 0.2);
					 
					 // Farewell:
					instance_delete(id);
				}
			}
			else{
				
				 // Lift:
				if(z < z_max){
					z += _zSpd;
					with(other){
						if(sprite_index != spr_lift){
							sprite_index = spr_lift;
						}
					}
				}
				else{
					z = z_max;
					with(other){
						if(sprite_index != spr_fly){
							sprite_index = spr_fly;
						}
					}
					
					 // Later Sucker:
					if(failed){
						x += lengthdir_x(_fSpd, direction);
						y += lengthdir_y(_fSpd, direction);
						with(other) scrRight(direction);
						
						if(!place_meeting(x, y, Floor)){
							var _canEnd = true;
							for(var i = 0; i < maxp; i++) if(player_is_active(i) && point_seen(x, y, i) && point_seen(x, (y - z), i)){
								_canEnd = false;
							}
							
							 // Goodbye:
							if(_canEnd){
								instance_delete(other);
								instance_delete(self);
								exit;
							}
						}
					}
					
					 // Fly:
					else{
						var l = min(_fSpd, point_distance(x, y, x_target, y_target)),
							d = point_direction(x, y, x_target, y_target);
						
						x += lengthdir_x(l, d);
						y += lengthdir_y(l, d);
						with(other) scrRight(d);
					}
				}
			}
		}
	}
	
#define BoneRaven_alrm1
	alarm1 = 30 + random(30);
	enemy_target(x, y);
	
	 // You Lose:
	if(GameCont.kills > max_kills && instance_exists(creator)){
		BoneRaven_fly(0, point_direction(creator.x, creator.y, x, y));
		with(fly_obj) failed = true;
	}
	else{
		
		 // Back Away:
		if(in_sight(target) && in_distance(target, 48)){
			scrWalk(point_direction(target.x, target.y, x, y), 10 + random(20));
			scrRight(direction + 180);
			
			alarm1 = walk;
		}
		else{
			
			 // Fly:
			if(instance_exists(Floor) && chance(1, 3)){
				BoneRaven_fly(64, random(360));
			}
			
			 // Wander:
			else{
				scrWalk(random(360), 20 + random(40));
			}
		}
	}
	
	
#define BoneRaven_alrm2
	alarm2 = -1;
	active = true;
	
	if(enemy_target(x, y)) scrRight(point_direction(x, y, target.x, target.y));
	BoneRaven_fly(128, random(360));
	
#define BoneRaven_fly(_len, _dir)
	 // Effects:
	repeat(6) scrFX(x + orandom(8), y + random(16), 3 + random(1), Dust);
	if(point_seen(x, y, -1)) sound_play_hit(sndRavenLand, 0.2);

	 // Find Floor:
	var _tries = 100,
		_x = x,
		_y = y;
		
	do{
		var l = _len,
			d = lerp(random(360), _dir, (_tries / 100)),
			f = instance_nearest(x + lengthdir_x(l, d), y + lengthdir_y(l, d), Floor);
		
		_x = f.x + (instance_is(f, FloorExplo) ? 8 : 16);
		_y = f.y + (instance_is(f, FloorExplo) ? 8 : 16);
		
		_tries--;
	}
	until(place_free(_x, _y) || _tries <= 0);
	
	 // We Have Liftoff:
	BoneRaven_fly_init(_x, _y);
	with(fly_obj) direction = _dir;

#define BoneRaven_fly_init(_targetX, _targetY)
	fly_obj = script_bind_draw(BoneRaven_fly_draw, -7, id);
	with(fly_obj){
		mask_index = other.mask_index;
		x = other.x;
		y = other.y;
		z = 0;
		z_max = 32;
		failed = false;
		x_target = _targetX;
		y_target = _targetY;
	}
	
	 // Hide:
	canfly = true;
	alarm1 = -1;
	x = 0;
	y = 0;

#define BoneRaven_fly_draw(_inst)
	var _x = x,
		_y = y - z;
	with(_inst) draw_sprite_ext(sprite_index, image_index, _x, _y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
	
#define BoneRaven_hurt(_hitdmg, _hitvel, _hitdir)
	if(!active && instance_exists(creator)){
		with(creator) active = true;
	}
	else enemy_hurt(_hitdmg, _hitvel, _hitdir);
	
#define BoneRaven_death
	 // Return That Which You Stole:
	if(instance_exists(creator)){
		var _num = min(raddrop, 2);
		rad_path(rad_drop(x, y, _num, direction, speed), creator);
		raddrop -= _num;
		
		with(creator){
			num_ravens--;
			if(num_ravens <= 0) alarm0 = 90;
		}
	}
	
#define BoneRaven_cleanup
	instance_delete(fly_obj);

#define NestRaven_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		spr_idle = sprRavenIdle;
		spr_walk = sprRavenWalk;
		spr_hurt = sprRavenHurt;
		spr_dead = sprRavenDead;
		spr_lift = sprRavenLift;
		spr_land = sprRavenLand;
		spr_wing = sprRavenFly;
		spr_shadow = shd24;
		spr_shadow_x = 0;
		spr_shadow_y = -1;
		sprite_index = spr_idle;
		image_index = irandom(image_number - 1);
		image_speed = 0.4;
		depth = -6 - ((y - 8) / 10000);
		
		 // Vars:
		mask_index = object_get_mask(Raven);
		right = choose(-1, 1);
		targetx = x;
		targety = y;
		z = 8;
		force_spawn = false;
		teeth = 0;
		
		 // HP:
		maxhealth = 10;
		with(instance_create(x, y, CustomEnemy)){
			maxhealth = other.maxhealth;
			other.maxhealth = maxhealth;
			instance_delete(id);
		}
		my_health = maxhealth;
		
		 // Alarms:
		alarm0 = 1;
		alarm1 = irandom_range(90, 1500);
		
		return id;
	}

#define NestRaven_step
	 // Flight:
	if(sprite_index = spr_wing){
		var l = 6 * current_time_scale,
			d = point_direction(x, y, targetx, targety);
			
		if(point_distance(x, y, targetx, targety) > l){
			x += lengthdir_x(l, d);
			y += lengthdir_y(l, d);
		}
		
		 // Land:
		else{
			image_index = max(2, image_index);
			if(anim_end){
				sprite_index = spr_land;
				image_index = 0;
			}
		}
	}
	
	 // Lifting:
	else if(sprite_index = spr_lift){
		z += 2 * current_time_scale;
		
		 // Fly Away:
		if(anim_end) sprite_index = spr_wing;
	}
	
	 // Landing:
	else if(sprite_index = spr_land){
		z -= 3 * current_time_scale;
		
		 // Attempt Landing:
		if(anim_end || z <= 0){
			z = 0;
			
			 // Try Again:
			if(!place_meeting(x, y, Floor)){
				alarm1 = 1;
			}
			
			 // Landed:
			else{
				with(instance_create(x, y, Raven)){
					x = xstart;
					y = ystart;
					alarm1 = 20 + random(10);
					right = other.right;
					
					 // Target:
					var n = instance_nearest(x, y, Player);
					if(in_sight(n) && sign(right) == sign(n.x - x)){
						scrAim(point_direction(x, y, n.x, n.y));
					}
					
					 // Swappin:
					var l = 4,
						d = gunangle;
						
					instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), WepSwap);
					wkick = 4;
					
					 // Effects:
					if(point_seen(x, y, -1)) sound_play(sndRavenLand);
					repeat(6){
						with(instance_create(x + orandom(8), y + random(16), Dust)){
							motion_add(random(360), 3 + random(1));
						}
					}
				}
				instance_destroy();
			}
		}
	}
	
#define NestRaven_draw
	image_alpha = abs(image_alpha);
	y -= z;
	image_xscale *= right;
	draw_self();
	y += z;
	image_xscale /= right;
	image_alpha = -image_alpha;

#define NestRaven_alrm0
	alarm0 = irandom_range(1, 80);
	
	 // Lookin:
	if(sprite_index == spr_idle){
		right = choose(-1, 1);
		if(instance_exists(Player)){
			var t = instance_nearest(x, y, Player);
			scrRight(point_direction(x, y, t.x, t.y));
		}
	}
	
	 // Sharp Teeth:
	if(teeth != 0){
		my_health = min(my_health - teeth, maxhealth);
		if(my_health <= 0){
			with(top_create(x, y, Raven, 0, 0)){
				target.my_health = other.my_health;
			}
			instance_destroy();
		}
	}

#define NestRaven_alrm1
	alarm1 = irandom_range(1, 100);
	
	var t = instance_nearest(x, y, Player);
	if(force_spawn || in_distance(t, 128)){
		var _x = x,
			_y = y;
			
		 // Search Floors by Player:
		if(instance_exists(t) && !chance(force_spawn, 2)){
			scrRight(point_direction(x, y, t.x, t.y));
			
			_x = t.x;
			_y = t.y;
			
			with(array_shuffle(instance_rectangle_bbox(t.x - 64, t.y - 64, t.x + 64, t.y + 64, Floor))){
				var	_fx = ((bbox_left + bbox_right + 1) / 2) + orandom(4),
					_fy = ((bbox_top + bbox_bottom + 1) / 2) + orandom(4),
					b = false;
					
				with(other){
					if(!place_meeting(_fx, _fy, Wall)){
						_x = _fx;
						_y = _fy;
						b = true;
					}
				}
				if(b) break;
			}
		}
		
		 // Random Nearby Floor:
		else{
			alarm1 = 1;
			
			var r = 64;
			with(instance_random(instance_rectangle_bbox(x - r, y - r, x + r, y + r, Floor))){
				_x = (bbox_left + bbox_right + 1) / 2;
				_y = (bbox_top + bbox_bottom + 1) / 2;
			}
		}
		
		 // Take Off:
		if(!place_meeting(_x, _y, Wall)){
			if(!instance_exists(t) || !collision_line(_x, _y, t.x, t.y, Wall, false, false)){
				sprite_index = spr_lift;
				image_index = 0;
				depth = -8;
				alarm1 = -1;
				targetx = _x;
				targety = _y;
				
				 // Effects:
				if(force_spawn) sound_play(sndRavenScreech);
				sound_play(sndRavenLift);
				repeat(6){
					with(instance_create(x + orandom(8), y + random(16), Dust)){
						motion_add(random(360), 3 + random(1));
						depth = other.depth;
					}
				}
			}
		}
	}


#define SawTrap_create(_x, _y)
	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		spr_idle = spr.SawTrap;
		spr_walk = spr.SawTrap;
		spr_hurt = spr.SawTrapHurt;
		hitid = [spr_idle, "SAWBLADE TRAP"];
		image_speed = 0.4;
		depth = 0;

		 // Sound:
		snd_hurt = sndHitMetal;
		snd_dead = sndHydrantBreak;
		snd_mele = sndDiscHit;

		 // Vars:
		mask_index = mskShield;
		friction = 0.2;
		maxhealth = 30;
		meleedamage = 6;
		canmelee = true;
		raddrop = 0;
		size = 3;
		team = 1;
		walled = false;
		side = choose(-1, 1);
		maxspeed = 3;
		spd = 0;
		dir = random(360);
		active = false;
		loop_snd = -1;
		sawtrap_hit = false;

		if(instance_exists(Wall)){
			var n = instance_nearest(x - 8, y - 8, Wall);
			dir = point_direction(x, y, n.x + 8, n.y + 8);
		}

		 // Alarms:
		alarm0 = random_range(30, 60);

		return id;
	}

#define SawTrap_step
	speed = 0;

	 // Start/Stop:
	if(instance_exists(Portal)) active = false;
	var _goal = (active * maxspeed);
	spd += (_goal - spd) * friction * current_time_scale;

	 // Stick to Wall:
	var _x = x,
		_y = y,
		_sideDis = 8,
		_sideDir = dir + (90 * side),
		_walled = collision_circle(_x + lengthdir_x(_sideDis, _sideDir), _y + lengthdir_y(_sideDis, _sideDir), 1, Wall, false, false);

	if(!_walled && walled){
		dir += 90 * side;
	}
	walled = _walled;

	 // Movement/Wall Collision:
	var l = spd * current_time_scale,
		d = dir;

	if(!collision_circle(_x + lengthdir_x(l, d), _y + lengthdir_y(l, d), 1, Wall, false, false)){
		x += lengthdir_x(l, d);
		y += lengthdir_y(l, d);
		x = round(x);
		y = round(y);
	}
	else dir -= 90 * side;

	dir = round(dir / 90) * 90;
	dir = (dir + 360) % 360;

	 // Animate:
	if(sprite_index == spr_hurt && anim_end){
		sprite_index = spr_idle;
	}

	 // Spin:
	image_angle += 4 * spd * side * current_time_scale;

	 // Effects:
	if(spd > 1 && point_seen(x, y, -1)){
		if(chance_ct(1, 2)){
			var l = random(12),
				d = dir,
				_debris = (walled && chance(1, 30)),
				_x = x + lengthdir_x(l, d),
				_y = y + lengthdir_y(l, d) - 2;
	
			instance_create(_x, _y, (_debris ? Debris : Dust));
			if(_debris){
				sound_play_pitchvol(sndWallBreak, 2, 0.2);
				view_shake_max_at(x, y, random_range(2, 6));
			}
		}
		if(walled){
			var	l = random_range(12, 16),
				d = dir,
				_x = x + lengthdir_x(l, d) + orandom(2),
				_y = y + lengthdir_y(l, d) - random(2);
				
			if(chance_ct(2, 3)){
				with(instance_create(_x, _y, BulletHit)){
					sprite_index = choose(sprGroundFlameDisappear, sprGroundFlameBigDisappear);
					image_angle = d - (random_range(15, 60) * other.side);
					image_yscale = -(random_range(1, 1.5) * other.side);
					
					if(!place_meeting(x, y, Wall)) instance_destroy();
				}
			}
			if(chance_ct(1, 4)){
				with(scrFX([_x, 3], [_y, 3], [d - (random_range(45, 90) * side), random(2)], Sweat)){
					image_blend = make_color_rgb(255, 222, 56);
				}
			}
		}
	}

	 // Sound:
	var _volGoal = (spd / maxspeed);
	if(_volGoal > 0 && point_in_rectangle(x, y, view_xview_nonsync, view_yview_nonsync, view_xview_nonsync + game_width, view_yview_nonsync + game_height)){
		if(!audio_is_playing(loop_snd)){
			loop_snd = audio_play_sound(snd.SawTrap, 0, true);
			audio_sound_gain(loop_snd, 0, 0);
		}
	}
	else _volGoal = 0;
	
	var _vol = audio_sound_get_gain(loop_snd);
	if(_vol > 0 || _volGoal > 0){
		 // Pitch:
		audio_sound_pitch(loop_snd, (1 + (0.05 * sin(current_frame / 8))) * (spd / maxspeed));
		
		 // Volume:
		_vol += 0.1 * (_volGoal - _vol) * current_time_scale;
		audio_sound_gain(loop_snd, _vol, 0);
	}
	else audio_stop_sound(loop_snd);
	

	 // Hitme Collision:
	var _scale = 0.55,
		_sawtrapHit = false;

	image_xscale *= _scale;
	image_yscale *= _scale;
	if(place_meeting(x, y, hitme)){
		with(instances_meeting(x, y, hitme)){
			if(place_meeting(x, y, other) && in_sight(other)){
				if(!instance_is(self, prop) || size <= 1){
					 // Push:
					if(!instance_is(self, prop) && (size < other.size || instance_is(self, Player))){
						motion_add_ct(point_direction(other.x, other.y, x, y), 0.6);
					}
	
					 // Contact Damage:
					with(other) if(active && canmelee && projectile_canhit_melee(other)){
						projectile_hit_raw(other, meleedamage, true);
	
						 // Effects:
						sound_play_hit_ext(snd_mele, 0.7 + random(0.2), 0.6);
					}
				}

				 // Epic FX:
				if(instance_is(self, other.object_index) && "name" in self && name == other.name){
					if(active && side != other.side){
						_sawtrapHit = true;
						if(!sawtrap_hit || chance_ct(1, 30)){
							sound_play_hit_ext(sndDiscBounce, 0.6 + random(0.2), 0.5);
							with(instance_create(x, y, MeleeHitWall)){
								motion_add(other.dir - random(120 * other.side), random(1));
								image_angle = direction + 180;
							}
							spd = 0;
						}
					}
				}
			}
		}
	}
	image_xscale /= _scale;
	image_yscale /= _scale;
	sawtrap_hit = _sawtrapHit;

	 // Die:
	if(my_health <= 0 || place_meeting(x, y, PortalShock)){
		 // Explo:
		instance_create(x, y, Explosion);
		repeat(3) instance_create(x, y, SmallExplosion);

		 // Effects:
		repeat(3) instance_create(x + orandom(16), y + orandom(16), GroundFlame);
		repeat(3 + irandom(3)) instance_create(x, y, Debris).sprite_index = spr.SawTrapDebris;

		 // Sounds:
		sound_play_hit_ext(sndExplosion, 1 + orandom(0.1), 3);
		sound_play_hit_ext(snd_dead, 1 + orandom(0.2), 3);

		 // Pickups:
		pickup_drop(50, 0);

		instance_destroy();
	}

#define SawTrap_alrm0
	active = true;

#define SawTrap_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);	// Sound

     // Hurt Sprite:
    sprite_index = spr_hurt;
    image_index = 0;

     // Push:
    if(active) spd /= 2;
    else{
    	spd = _hitvel / 4;
    	dir = _hitdir;
    }

#define SawTrap_cleanup
	sound_stop(loop_snd);


#define SludgePool_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		mask_index = msk.SludgePool;
		active = false;
		ravens = [];
		num_ravens = 3;
		repeat(num_ravens) array_push(ravens, obj_create(_x, _y, "BoneRaven"));
		with(ravens) creator = other;
		my_alert = noone;
		fx_color = make_color_rgb(130, 189, 005);
		
		 // Alarms:
		alarm0 = -1;
		
		return id;
	}
	
#define SludgePool_step
	 // Raven Time:
	var t = instance_nearest(x, y, Player);
	if(in_sight(t) && in_distance(t, 128)){
		if(!active){
			active = true;
		}
	}
	if(active){
		with(instances_matching(ravens, "active", false)){
			max_kills = GameCont.kills;
			alarm2 = 1 + random(5);
			active = true;
		}
	}
	
	 // Alert:
	if(num_ravens <= 0){
		if(my_alert == noone){
			my_alert = obj_create(x, y, "AlertIndicator");
			with(my_alert){
				sprite_index = spr.SludgePoolAlert;
				target = other;
				target_y = -32;
			}
		}
		with(my_alert) if(sprite_index == spr.SludgePoolAlert){
			alarm0 = 60;
		}
	}
	
	 // Bubblin':
	if(chance_ct(1, 5)) with(scrFX([x, 20], [y, 10], 0, RainSplash)) image_blend = other.fx_color;

#define SludgePool_end_step
	 // Sticky Sludge:
	with(instance_rectangle_bbox(bbox_left, bbox_top, bbox_right, bbox_bottom, [Player, hitme])){
		x = lerp(xprevious, x, 0.8);
		y = lerp(yprevious, y, 0.8);
	}
	
#define SludgePool_alrm0
	alarm0 = 30 + random(30);
	var t = instance_nearest(x, y, Player);
	
	if(in_sight(t) && in_distance(t, 128)){
		alarm0 = -1;
		
		pet_spawn(x, y, "Salamander");
		with(my_alert) sprite_index = spr.PetSalamanderIcon;
	}
	
#define Tunneler_create(_x, _y)
    with(instance_create(_x, _y, CustomEnemy)){
         // Visual:
		spr_idle = sprBanditIdle;
		spr_walk = sprBanditWalk;
		spr_hurt = sprBanditHurt;
		spr_dead = sprBanditDead;
		spr_shadow = shd24;
		spr_shadow_y = -1;
		hitid = [spr_idle, "TUNNELER"];
		mask_index = mskBandit;
		depth = -11;

		 // Sound:
		snd_hurt = sndGatorHit;
		snd_dead = sndGatorDie;

		 // Vars:
		maxhealth = 15;
		meleedamage = 2;
		canmelee = true;
		raddrop = 8;
		size = 1;
		walk = 0;
		walkspeed = 0.8;
		maxspeed = 2.4;
		gunangle = random(360);
		direction = gunangle;
		tunneling = 0;
		tunnel_wall = noone;

         // Alarms:
		alarm1 = 20 + irandom(30);

		 // NTTE:
		ntte_anim = false;
		ntte_walk = false;

		return id;
	}
	
#define Tunneler_step
    sprite_index = enemy_sprite;
    if(!tunneling) enemy_walk(walkspeed, maxspeed);

#define Tunneler_end_step
    if(tunneling) {
        x = tunnel_wall.x + 8;
        y = tunnel_wall.y;
    }
    
#define Tunneler_alrm1
    alarm1 = 20 + irandom(10);
    enemy_target(x, y);
    
     // Tunneling AI:
    if(tunneling) {
         // Speedwalk:
        if(walk > 0) {
            alarm1 = 2 + irandom(4);
            
             // Target is near/alive:
            if(in_distance(target, 256)) {
                var _targetDir = ceil(point_direction(x, y, target.x, target.y)/90) * 90;
            }
            
             // Target is far/dead:
            else {
                var _targetDir = irandom_range(1, 4) * 90;
            }
            
            var _targetWall = instance_place(x + lengthdir_x(16, _targetDir), y + lengthdir_y(16, _targetDir), Wall);
            
            if(_targetWall != noone) {
                tunnel_wall = _targetWall;
            }
            
            else {
                x += lengthdir_x(24, _targetDir);
                y += lengthdir_y(24, _targetDir);
                Tunneler_tunnel(0, noone);
            }
            
            walk -= 1;
        }
        
        else {
            alarm1 = 10 + irandom(5);
            walk = 10;
        }
    } 
    
     // Normal AI:
    else {
        if(in_distance(target, 256)) {
            scrAim(point_direction(x, y, target.x, target.y));
            
            if(in_sight(target) && chance(2, 3)) {
                enemy_shoot(EnemyBullet1, gunangle, 6);
            }
            
            else {
                var _targetWall = instance_nearest(x, y, Wall);
                var _targetDist = point_distance(x, y, _targetWall.x + 8, _targetWall.y + 8);
                
                if(_targetDist < 8) {
                    alarm1 = 5 + random(5);
                    scrWalk(point_direction(x, y, _targetWall.x, _targetWall.y) + orandom(5), _targetDist/walkspeed);
                }
                
                else {
                    Tunneler_tunnel(1, _targetWall);
                }
            }
        } 
        
        else {
            scrWalk(random(360), [10, 20]);
            scrAim(direction);
        }
    }
    

#define Tunneler_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;           // Damage
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);	// Sound
    sprite_index = spr_hurt;
    
    if(tunneling) {
        with(instance_create(x, y, PortalClear)) {
            mask_index = other.mask_index;
        }
        Tunneler_tunnel(0, noone);
    }

#define Tunneler_tunnel(_tf, _wall)
    tunneling = _tf;
    tunnel_wall = _wall;
    canfly = _tf;
    if(_tf = 1) mask_index = mskBanditBoss; 
    else mask_index = mskBandit;


/// Mod Events
#define step
	if(DebugLag) trace_time();
	
	 // Bind Events:
	script_bind_draw(draw_ravenflys, -8);
	
	 // Nest Raven Disable Portal:
	if(!instance_exists(enemy)){
		if(array_length(instances_matching(CustomObject, "name", "NestRaven")) > 0){
			with(instances_matching_gt(Corpse, "alarm0", -1)) alarm0 = -1;
		}
	}
	
	 // Nest Raven Manual Sharp Teeth:
	if(skill_get(mut_sharp_teeth) != 0){
		with(Player) if(lsthealth > my_health){
			var _damage = (lsthealth - my_health) * 2.5 * skill_get(mut_sharp_teeth);
			with(instance_rectangle(view_xview[index], view_yview[index], view_xview[index] + game_width, view_yview[index] + game_height, instances_matching(CustomObject, "name", "NestRaven"))){
				teeth += _damage;
				alarm0 = round(1 + (point_distance(x, y, 0.x, 0.y) / 8));
				
				 // Just Visual:
				with(instance_create(x, y - z, SharpTeeth)){
					depth = -8;
					damage = other.teeth;
					alarm0 = other.alarm0;
				}
			}
		}
	}
	
	 // Variant Car Decal:
	with(instances_matching(TopDecalScrapyard, "verticalcar_check", null)){
		verticalcar_check = (image_index == 0 && chance(1, 2));
		if(verticalcar_check) sprite_index = spr.TopDecalScrapyardAlt;
	}

	if(DebugLag) trace_time("tescrapyard_step");
	
#define draw_shadows
	 // Saw Traps:
	with(instances_matching(CustomHitme, "name", "SawTrap")) if(visible){
		draw_sprite_ext(sprite_index, image_index, x, y + 6, image_xscale * 0.9, image_yscale * 0.9, image_angle, image_blend, image_alpha);
	}

#define draw_ravenflys
	 // RavenFlys draw at like -6 depth, not cool bro:
	with(RavenFly){
		y += z;
		image_xscale *= right;
    	draw_self();
		y -= z;
		image_xscale /= right;
	}
	instance_destroy();


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
#define scrPickupIndicator(_text)                                                       return  mod_script_call(   'mod', 'telib', 'scrPickupIndicator', _text);
#define scrAlert(_sprite, _inst)                                                        return  mod_script_call(   'mod', 'telib', 'scrAlert', _sprite, _inst);
#define TopDecal_create(_x, _y, _area)                                                  return  mod_script_call_nc('mod', 'telib', 'TopDecal_create', _x, _y, _area);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call(   'mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_instance, _charm)                                               return  mod_script_call_nc('mod', 'telib', 'charm_instance', _instance, _charm);