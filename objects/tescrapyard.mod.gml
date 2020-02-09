#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	mus = mod_variable_get("mod", "teassets", "mus");
	sav = mod_variable_get("mod", "teassets", "sav");
	
	DebugLag = false;
	
	 // Sludge Pool:
	surfSludgePool = surflist_set("SludgePool", 0, 0, game_width, game_height);
	shadSludgePool = shadlist_set("SludgePool", 
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
		uniform float3 sludgeRGB;
		
		float4 main(PixelShaderInput INPUT) : SV_TARGET
		{
			 // Return if Above Sludge Pool Pixel:
			float4 RGBA = tex2D(s0, INPUT.vTexcoord);
			if(RGBA.r == sludgeRGB.r && RGBA.g == sludgeRGB.g && RGBA.b == sludgeRGB.b){
				float4 southRGBA = tex2D(s0, INPUT.vTexcoord + float2(0.0, pixelSize.y));
				if(southRGBA.r == (133.0 / 255.0) && southRGBA.g == (249.0 / 255.0) && southRGBA.b == (26.0 / 255.0)){
					return RGBA;
				}
			}
			
			 // Return Blank Pixel:
			return float4(0.0, 0.0, 0.0, 0.0);
		}
		"
	);

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

#macro bbox_center_x (bbox_left + bbox_right + 1) / 2
#macro bbox_center_y (bbox_top + bbox_bottom + 1) / 2
#macro bbox_width    (bbox_right + 1) - bbox_left
#macro bbox_height   (bbox_bottom + 1) - bbox_top

#macro surfSludgePool global.surfSludgePool

#macro shadSludgePool global.shadSludgePool

#define BoneRaven_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle = spr.BoneRavenIdle;
		spr_walk = spr.BoneRavenWalk;
		spr_hurt = spr.BoneRavenHurt;
		spr_dead = spr.BoneRavenDead;
		spr_lift = spr.BoneRavenLift;
		spr_land = spr.BoneRavenLand;
		spr_wing = spr.BoneRavenFly;
		sprite_index = spr_idle;
		image_index = irandom(image_number - 1);
		spr_shadow = shd24;
		hitid = [spr_idle, "RAVEN"];
		depth = -2;
		
		 // Sounds:
		snd_hurt = sndTurtleHurt;
		snd_dead = sndMutant14Hurt;
		
		 // Vars:
		mask_index = mskRat;
		maxhealth = 10;
		raddrop = 5;
		size = 1;
		kills = 0;
		max_kills = 0;
		walk = 0;
		walkspeed = 0.6;
		maxspeed = 2.5;
		creator = noone;
		top_object = noone;
		active = false;
		failed = false;
		
		 // Alarms:
		alarm1 = -1;
		alarm2 = -1;
		
		 // NTTE:
		ntte_anim = false;
		
		return id;
	}
	
#define BoneRaven_step
	 // Animate:
	if(!instance_exists(top_object) || (top_object.speed == 0 && top_object.zspeed == 0)){
		if(!active) speed = 0;
		if(sprite_index != spr_chrg || anim_end){
			sprite_index = enemy_sprite;
		}
	}
	
	 // Flight:
	else{
		alarm1 = max(alarm1, 30 + current_time_scale);
		
		 // Landing:
		if(top_object.zspeed < 0){
			if(top_object.z > 8)
			if(sprite_index != spr_land){
				image_index = max(2, image_index);
				if(anim_end) spr_chrg = spr_land;
			}
		}
		
		 // Flying:
		else if(sprite_index != spr_wing){
			if(sprite_index != spr_lift) spr_chrg = spr_lift;
			else if(anim_end) spr_chrg = spr_wing;
		}
		
		 // Manual Spriting:
		if(sprite_index != spr_chrg){
			sprite_index = spr_chrg;
			image_index = 0;
		}
		
		 // Later Sucker:
		if(failed){
			with(top_object){
				jump_x += hspeed_raw;
				jump_y += vspeed_raw;
			}
			if(!point_seen_ext(x, y + (top_object.z / 2), sprite_width, sprite_height + (top_object.z / 2), -1)){
				instance_delete(id);
			}
		}
	}
	
#define BoneRaven_alrm1
	alarm1 = 30 + random(30);
	
	 // You Lose:
	if(GameCont.kills > max_kills || failed){
		failed = true;
		BoneRaven_fly(-1, -1);
	}
	
	else{
		 // Back Away:
		if(enemy_target(x, y) && in_sight(target) && in_distance(target, 48)){
			scrWalk(point_direction(target.x, target.y, x, y), random_range(10, 30));
			scrRight(direction + 180);
			alarm1 = walk;
		}
		
		 // Wander:
		else if(chance(2, 3)){
			scrWalk(random(360), random_range(20, 60));
			
			 // Fly:
			if(chance(1, 3)){
				BoneRaven_fly(96, 160);
			}
		}
	}
	
#define BoneRaven_alrm2
	 // Activate:
	active = true;
	if(enemy_target(x, y)) scrRight(point_direction(x, y, target.x, target.y));
	BoneRaven_fly(96, 256);
	
#define BoneRaven_hurt(_hitdmg, _hitvel, _hitdir)
	if(!active) alarm2 = 1;
	with(creator) active = true;
	enemy_hurt(_hitdmg, _hitvel, _hitdir);
	
#define BoneRaven_death
	with(top_object) instance_destroy();
	
	 // Return That Which You Stole:
	if(instance_exists(creator)){
		creator.num--;
		rad_path(rad_drop(x, y, raddrop, direction, speed), creator);
		raddrop = 0;
	}
	
#define BoneRaven_fly(_disMin, _disMax)
	var	_x = x,
		_y = y;
		
	if(_disMax < 0) _disMax = 1000000000;
	
	with(array_shuffle(instances_matching(Floor, "", null))){
		if(in_range(point_distance(_x, _y, clamp(_x, bbox_left, bbox_right + 1), clamp(_y, bbox_top, bbox_bottom + 1)), _disMin, _disMax)){
			if(!place_meeting(x, y, Wall)){
				var	_tx = bbox_center_x + orandom(bbox_width / 8),
					_ty = bbox_center_y + orandom(bbox_height / 8);
					
				 // We Have Liftoff:
				with(other){
					with(top_create(x, y, self, 0, 0)){
						jump_time = 0;
						jump_x = _tx;
						jump_y = _ty;
						zspeed = jump;
						zfriction = grav;
					}
					scrRight(point_direction(x, y, _tx, _ty));
					
					 // Effects:
					if(point_seen(x, y, -1)){
						sound_play(sndRavenLand);
						repeat(4){
							with(scrFX([x, 8], y + random(16), random_range(3, 4), Dust)){
								depth = other.depth;
							}
						}
					}
					
					return true;
				}
			}
		}
	}
	
	return false;
	
	
#define RavenArenaCont_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Front Row Seating:
		with(Wall) if(place_meeting(x, y, Floor) && !collision_line(bbox_center_x, bbox_center_y, other.x, other.y, Wall, false, true)){
			if(chance(1, 4)){
				top_create(bbox_center_x + orandom(2), y - 8 + orandom(2), "TopRaven", 0, 0);
			}
		}
		
		 // Back Row Seating:
		var	_ang = random(360),
			_num = 3 + ceil(GameCont.loops / 4);
			
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
			with(top_create(x, y, ((GameCont.loops > 0 && chance(1, 2)) ? MeleeFake : Tires), _dir + orandom(40), 16)){
				with(target){
					 // Perched Raven:
					with(top_create(x, y + 1, "TopRaven", 0, 0)){
						z += max(0, ((sprite_get_bbox_bottom(other.spr_idle) + 1) - sprite_get_bbox_top(other.spr_idle)) - 5);
					}
					
					 // Ravens:
					var	_num = 3 + ceil(GameCont.loops / 2),
						l = 24;
						
					for(var d = _dir; d < _dir + 360; d += (360 / _num)){
						top_create(x + lengthdir_x(l, d), y + lengthdir_x(l, d), "TopRaven", d + orandom(40), -1);
					}
				}
			}
		}
		
		 // Grab Top Dudes:
		inst = [];
		with(instances_matching_gt(instances_matching(CustomEnemy, "name", "TopRaven"), "id", id)){
			array_push(other.inst, top_object);
			with(top_object) jump_time = -1;
		}
		
		 // Generic Enemies:
		var	_obj = [choose(Raven, Salamander, Exploder), choose(Sniper, MeleeFake)],
			_ang = random(360),
			_num = 4 * (1 + GameCont.loops);
			
		if(GameCont.loops > 0){
			array_push(_obj, choose(SnowBot, BuffGator));
		}
		
		inst_idle = [];
		
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
			var _objNum = array_length(inst_idle);
			if(_objNum >= array_length(_obj)){
				_objNum = irandom(array_length(_obj) - 1);
			}
			with(obj_create(x, y, _obj[_objNum])){
				move_contact_solid(_dir + orandom(20), random_range(16, 64));
				array_push(other.inst_idle, id);
				
				 // Loop Groups:
				if(chance(GameCont.loops, 60)){
					repeat(3 + GameCont.loops){
						array_push(other.inst_idle, instance_copy(false));
					}
				}
			}
		}
		
		 // Weapon:
		with(obj_create(x + orandom(8), y + orandom(8), "WepPickupGrounded")){
			with(target){
				var _noWep = [];
				with(Player){
					array_push(_noWep, wep);
					array_push(_noWep, bwep);
				}
				wep = weapon_decide(2, GameCont.hard, false, _noWep);
			}
		}
		
		return id;
	}
	
#define RavenArenaCont_step
	 // Hold Enemies:
	with(inst_idle){
		if(instance_exists(self) && sprite_index != spr_hurt){
			if("walk" in self){
				if(walk > 0) walk -= 4 * current_time_scale;
			}
			else{
				direction = angle_lerp(direction, point_direction(x, y, other.x, other.y), 0.04 * current_time_scale);
			}
		}
		else other.inst_idle = array_delete_value(other.inst_idle, self);
	}
	
	 // Activate Ravens:
	if(in_distance(Player, 96)){
		var _time = 60;
		with(instances_matching_lt(inst, "jump_time", 0)){
			jump_time = _time * (128 / point_distance(x, y, other.x, other.y));
			_time += random_range(15 + (2400 / _time), 60);
		}
		instance_destroy();
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
		
		 // Move Towards Nearest Wall:
		with(instance_nearest_bbox(x, y, Wall)){
			dir = point_direction(other.x, other.y, bbox_center_x, bbox_center_y);
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
		 // Visual:
		sprite_index = msk.SludgePool;
		spr_floor = spr.SludgePool;
		depth = 4;
		
		 // Vars:
		mask_index = -1;
		fx_color = make_color_rgb(130 - 40, 189, 5);
		my_alert = noone;
		right = choose(-1, 1);
		active = false;
		setup = true;
		num = -1;
		
		 // Alarms:
		alarm0 = -1;
		
		return id;
	}
	
#define SludgePool_setup
	setup = false;
	
	 // Floorerize:
	var	_w = ceil(abs(sprite_width) / 32),
		_h = ceil(abs(sprite_height) / 32),
		_cx = 0,
		_cy = 0,
		_num = 0;
		
	with(floor_fill(x, y, _w, _h)){
		sprite_index = other.spr_floor;
		image_index = ((sprite_index = sprFloor3) ? 3 : _num);
		material = 5; // slimy stone
		_cx += bbox_center_x;
		_cy += bbox_center_y;
		_num++;
	}
	
	 // Center Position:
	x = (_cx / _num);
	y = (_cy / _num);
	
	 // Ravens:
	if(num > 0){
		var	_ang = random(360),
			_dis = 12;
			
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / num)){
			with(obj_create(round(x + lengthdir_x(_dis, _dir)), round(y + lengthdir_y(_dis, _dir)), "BoneRaven")){
				x = xstart;
				y = ystart;
				y -= round(bbox_bottom - y);
				creator = other;
				scrRight(_dir);
				instance_budge(enemy, 4);
			}
		}
	}
	
#define SludgePool_step
	if(setup) SludgePool_setup();
	
	if(sprite_index == msk.SludgePool){
		 // Raven Time:
		if(!active){
			if(in_sight(Player) && in_distance(Player, 96)){
				active = true;
			}
		}
		if(active){
			var _ravens = instances_matching(instances_matching(CustomEnemy, "name", "BoneRaven"), "creator", id);
			with(instances_matching(_ravens, "active", false)){
				max_kills = GameCont.kills;
				alarm2 = 1 + random(5);
				active = true;
			}
		}
		
		 // Alert:
		if(num == 0){
			num = -1;
			
			 // Alert:
			with(my_alert) instance_destroy();
			my_alert = scrAlert(self, spr.SludgePoolAlert);
			with(my_alert){
				spr_alert = spr.AlertIndicatorMystery;
				alert_col = c_yellow;
				target_y -= 4;
				alarm0 = -1;
			}
		}
	}
	
	 // Bubblin'
	if(instance_exists(my_alert) && my_alert.sprite_index == spr.SludgePoolAlert){
		my_alert.alert_ang = sin(current_frame * 0.1) * 20;
		
		 // Bubbles:
		if(chance_ct(1, 30) || frame_active(15)){
			var	l = random_range(1/10, 1/3) * choose(-1, 1),
				d = current_frame * 10,
				_x = x + lengthdir_x(l * sprite_width,        d),
				_y = y + lengthdir_y(l * sprite_height * 2/3, d);
				
			with(instance_create(_x, _y, RainSplash)){
				image_blend = merge_color(other.fx_color, c_black, random(0.1));
				with(instance_create(x, y, Bubble)){
					gravity *= random_range(0.5, 0.8);
					image_blend = other.image_blend;
					image_index = irandom(2);
					hspeed /= 3;
					vspeed = 0;
				}
			}
		}
		
		 // Sounds:
		var	_sndInterval = (point_seen(x, y, -1) ? 8 : 12),
			_snd = [sndOasisMelee, sndOasisCrabAttack, sndOasisChest];
			
		if(frame_active(_sndInterval) || chance(1, 12)){
			sound_play_hit(_snd[((current_frame / _sndInterval) / 1.5) % array_length(_snd)], 0.4);
		}
		
		 // Activate Saladman:
		if(alarm0 < 0 && in_sight(Player)){
			if(point_seen_ext(x, y, -32, -32, -1) || in_distance(Player, 64)){
				alarm0 = 150;
				with(instance_nearest(x, y, Player)){
					with(other) scrRight(point_direction(x, y, other.x, other.y));
				}
			}
		}
	}
	
#define SludgePool_end_step
	 // Sticky Sludge:
	with(instance_rectangle_bbox(bbox_left, bbox_top, bbox_right, bbox_bottom, instances_matching_lt(instances_matching_gt(hitme, "speed", 0), "size", 6))){
		if(position_meeting(x, bbox_bottom, other)){
			x = lerp(xprevious, x, 2/3);
			y = lerp(yprevious, y, 2/3);
			
			 // FX:
			if(chance_ct(speed, 12)){
				var o = other;
				with(instance_create(x + orandom(2), bbox_bottom + random(4), Dust)){
					sprite_index = sprBoltTrail;
					image_blend = o.fx_color;
					image_xscale *= random_range(1, 3);
					depth = o.depth - 1;
				}
			}
		}
	}
	
	 // Effects:
	with(instances_matching(instances_meeting(x, y, RainSplash), "image_blend", c_white)){
		var	l = 4,
			d = point_direction(other.x, other.y, x, y);
			
		if(position_meeting(x + lengthdir_x(l, d), y + lengthdir_y(l * 2/3, d), other)){
			image_blend = other.fx_color;
		}
	}
	with(instances_matching(instances_meeting(x, y, Dust), "sprite_index", sprDust)){
		if(position_meeting(x, y, other)){
			sprite_index = sprSweat;
			image_blend = other.fx_color;
			speed /= 3;
		}
	}
	
#define SludgePool_draw
	 // Silhouette:
	if(alarm0 > 0){
		var	_spr = spr.PetSalamanderIdle,
			_img = 0.4 * current_frame,
			_x = x,
			_y = y + (max(0, alarm0 - 40) / 6) + (min(1, alarm0 / 10) * sin(current_frame / 10)),
			_xsc = image_xscale * right,
			_ysc = image_yscale,
			_ang = image_angle,
			_col = image_blend,
			_alp = image_alpha / max(1, 0.5 * (alarm0 - 55));
			
		draw_set_fog(true, fx_color, 0, 0);
		draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
		draw_set_fog(false, 0, 0, 0);
	}
	
#define SludgePool_alrm0
	with(pet_spawn(x, y, "Salamander")){
		right = other.right;
	}
	
	 // Splash:
	for(var _dir = 0; _dir < 360; _dir += (360 / 3)){
		with(scrFX([x, 8], [y, 4], [_dir + 90, 2], AcidStreak)){
			image_angle = direction + orandom(30);
			image_blend = merge_color(image_blend, c_lime, random(0.1));
		}
	}
	repeat(8){
		with(scrFX(x, y, [90 + orandom(60), random(1)], Sweat)){
			image_blend = merge_color(other.fx_color, c_lime, random(0.3));
		}
	}
	sound_play_pitch(sndCorpseExplo, 1 + orandom(0.1));
	sound_play(sndOasisMelee);
	
	 // Alert:
	with(my_alert){
		sprite_index = spr.PetSalamanderIcon;
		spr_alert = spr.AlertIndicator;
		snd_flash = sndSalamanderEndFire;
		alert_ang = 0;
		alarm0 = 90;
		flash = 3;	
	}
	
	
#define TopRaven_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle = sprRavenIdle;
		spr_walk = sprRavenWalk;
		spr_hurt = sprRavenHurt;
		spr_dead = sprRavenDead;
		spr_lift = sprRavenLift;
		spr_land = sprRavenLand;
		spr_wing = sprRavenFly;
		spr_shadow = shd24;
		hitid = 15;
		sprite_index = spr_idle;
		image_index = irandom(image_number - 1);
		depth = object_get_depth(Raven);
		
		 // Sound:
		snd_hurt = sndRavenHit;
		snd_dead = sndRavenDie;
		
		 // Vars:
		mask_index = object_get_mask(Raven);
		maxhealth = 10;
		raddrop = 4;
		size = 1;
		top_object = noone;
		setup = true;
		
		return id;
	}
	
#define TopRaven_setup
	setup = false;
	
	 // Top Object Setup:
	if(!instance_exists(top_object)){
		top_object = top_create(x, y, self, -1, -1);
	}
	with(top_object) if(z > 8){
		canmove = false;
	}
	
#define TopRaven_step
	if(setup) TopRaven_setup();
	
	 // Animate:
	if(instance_exists(top_object)){
		if(top_object.speed == 0 && (top_object.zspeed == 0 || spr_chrg = spr_land)){
			if(sprite_index == spr_chrg && anim_end){
				sprite_index = spr_idle;
			}
		}
		else{
			 // Landing:
			if(top_object.zspeed < 0){
				if(sprite_index != spr_land){
					image_index = max(2, image_index);
					if(anim_end) spr_chrg = spr_land;
				}
			}
			
			 // Flying:
			else if(sprite_index != spr_wing){
				if(sprite_index != spr_lift){
					spr_chrg = spr_lift;
					
					 // Effects:
					if(point_seen(x, y, -1)){
						sound_play(sndRavenLift);
						repeat(6){
							with(scrFX([x, 8], y + random(16), random_range(3, 4), Dust)){
								depth = other.depth;
							}
						}
					}
				}
				else if(anim_end) spr_chrg = spr_wing;
			}
			
			 // Manual Spriting:
			if(sprite_index != spr_chrg){
				sprite_index = spr_chrg;
				image_index = 0;
			}
		}
	}
	
	 // Goodbye:
	else{
		if(sprite_index == spr_chrg) sprite_index = spr_idle;
		spr_chrg = -1;
		instance_destroy();
	}
	
#define TopRaven_destroy
	 // Become Raven:
	if(my_health > 0){
		with(instance_create_copy(x, y, Raven)){
			alarm1 = 20 + random(10);
			
			 // Target:
			if(enemy_target(x, y) && in_sight(target) && sign(right) == sign(target.x - x)){
				scrAim(point_direction(x, y, target.x, target.y));
			}
			
			 // Swappin:
			var l = 4,
				d = gunangle;
				
			instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), WepSwap);
			wkick = 4;
			
			 // Effects:
			if(point_seen(x, y, -1)) sound_play(sndRavenLand);
		}
		instance_delete(id);
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
				var _targetWall = instance_nearest_bbox(x, y, Wall);
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
	with(surfSludgePool){
		active = (array_length(instances_matching(CustomObject, "name", "SludgePool")) > 0);
		if(active) script_bind_draw(draw_sludge, -4);
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
	
#define draw_sludge
	with(surfSludgePool) if(surface_exists(surf)){
		x = view_xview_nonsync;
		y = view_yview_nonsync;
		w = game_width;
		h = game_height;
		
		var	_surf = surf,
			_surfw = w,
			_surfh = h,
			_surfx = x,
			_surfy = y,
			_canShader = (lq_defget(shadSludgePool, "shad", -1) != -1),
			_inst = instances_seen_nonsync([hitme, Corpse, chestprop, ChestOpen, Crown], 24, 24);
			
		if(_canShader){
			_inst = array_combine(_inst, instances_matching(Pickup, "mask_index", mskPickup));
		}
		_inst = instances_matching(_inst, "visible", true);
		
		with(instances_matching(instances_matching(CustomObject, "name", "SludgePool"), "visible", true)){
			surface_set_target(_surf);
			draw_clear_alpha(0, 0);
				
				 // Grab Screen for Shader:
				if(shadSludgePool.shad != -1){
					surface_screenshot(_surf);
				}
				
				 // Stuff in Sludge:
				draw_set_fog(true, fx_color, 0, 0);
				with(instance_rectangle_bbox(bbox_left - 8, bbox_top - 8, bbox_right + 8, bbox_bottom + 8, _inst)){
					var	_spr = sprite_index,
						_img = image_index,
						_xsc = image_xscale * (("right" in self) ? right : 1),
						_ysc = image_yscale,
						_col = image_blend,
						_alp = image_alpha,
						_sludgeHeight = (
							(_canShader && (instance_is(self, Corpse) || instance_is(self, Pickup) || instance_is(self, chestprop) || instance_is(self, prop)))
							? (sprite_get_bbox_bottom(_spr) + 1) - sprite_get_yoffset(_spr)
							: 1 + (_spr == sprRavenIdle || _spr == spr.BoneRavenIdle)
						),
						_l = 0,
						_t = sprite_get_bbox_bottom(_spr) + 1 - _sludgeHeight,
						_w = sprite_get_width(_spr),
						_h = _sludgeHeight,
						_x = x - (sprite_get_xoffset(_spr) * _xsc) + _l,
						_y = y - (sprite_get_yoffset(_spr) * _ysc) + _t;
						
					draw_sprite_part_ext(_spr, _img, _l, _t, _w, _h, _x - _surfx, _y - _surfy, _xsc, _ysc, _col, _alp);
				}
				draw_set_fog(false, 0, 0, 0);
				
				 // Cut Out:
				draw_set_blend_mode_ext(bm_inv_src_alpha, bm_src_alpha);
				draw_sprite_ext(sprite_index, image_index, x - _surfx, y - _surfy, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
				draw_set_blend_mode(bm_normal);
				
			surface_reset_target();
			
			 // Draw:
			shadlist_setup(shadSludgePool, surface_get_texture(_surf), [_surfw, _surfh, fx_color]);
			draw_surface_part(_surf, bbox_left - _surfx, bbox_top - _surfy, bbox_width, bbox_height, bbox_left, bbox_top);
			shader_reset();
		}
	}
	instance_destroy();


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
#define area_generate(_area, _subarea, _x, _y)                                          return  mod_script_call_nc('mod', 'telib', 'area_generate', _area, _subarea, _x, _y);
#define area_generate_ext(_area, _subarea, _x, _y, _setArea, _overlapFloor, _scrSetup)  return  mod_script_call_nc('mod', 'telib', 'area_generate_ext', _area, _subarea, _x, _y, _setArea, _overlapFloor, _scrSetup);
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