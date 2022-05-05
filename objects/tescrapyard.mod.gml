#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Gather Objects:
	for(var i = 1; true; i++){
		var _scrName = script_get_name(i);
		if(_scrName != undefined){
			call(scr.obj_add, script_ref_create(i));
		}
		else break;
	}
	
	 // Bind Events:
	script_bind(CustomDraw, draw_sludge,       -4,                               true);
	script_bind(CustomDraw, draw_trapspin_top, object_get_depth(SubTopCont),     true);
	script_bind(CustomDraw, draw_bigpipe_top,  object_get_depth(SubTopCont) - 1, true);
	
	 // Sludge Pool:
	shadSludgePool = call(scr.shader_add, "SludgePool",
		
		/* Vertex Shader */"
		struct VertexShaderInput
		{
			float2 vTexcoord : TEXCOORD0;
			float4 vPosition : POSITION;
		};
		
		struct VertexShaderOutput
		{
			float2 vTexcoord : TEXCOORD0;
			float4 vPosition : SV_POSITION;
		};
		
		uniform float4x4 matrix_world_view_projection;
		
		VertexShaderOutput main(VertexShaderInput INPUT)
		{
			VertexShaderOutput OUT;
			
			OUT.vTexcoord = INPUT.vTexcoord; // (x,y)
			OUT.vPosition = mul(matrix_world_view_projection, INPUT.vPosition); // (x,y,z,w)
			
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
			 // Return Color if Above Sludge Pool Pixel:
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
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro shadSludgePool global.shadSludgePool

#define BigPipe_create(_x, _y)
	/*
		A big pipe that spawns bounty hunters
	*/
	
	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		spr_idle     = spr.BigPipeBottom;
		spr_hurt     = spr.BigPipeBottomHurt;
		spr_dead     = sprSmallGeneratorDead;
		spr_top_idle = spr.BigPipeTop;
		spr_top_hurt = spr.BigPipeTopHurt;
		spr_shadow   = msk.BigPipe;
		spr_shadow_y = 5;
		image_speed  = 0.4;
		image_xscale = choose(-1, 1);
		depth        = 1;
		
		 // Sound:
		snd_hurt = sndHitMetal;
		snd_dead = sndGeneratorBreak;
		
		 // Vars:
		mask_index = msk.BigPipe;
		friction   = 1000;
		maxhealth  = 60;
		size       = 4;
		team       = 0;
		
		 // Hole:
		hole_inst = call(scr.obj_create, x, y + 8, "ManholeOpen");
		with(hole_inst){
			sprite_index = spr.BigPipeHole;
			visible      = false;
			big          = true;
		}
		
		 // TopSmalls:
	//	for(var _ox = -32; _ox < 32; _ox += 32){
	//		for(var _oy = -16; _oy < 48; _oy += 32){
	//			instance_create(pround(x + _ox, 16), pround(y + _oy, 16), Top);
	//		}
	//	}
		
		return self;
	}
	
#define BigPipe_step
	 // Collision:
	if(place_meeting(x, y, hitme)){
		var	_x = bbox_center_x,
			_y = bbox_center_y;
			
		with(call(scr.instances_meeting_instance, self, instances_matching_ne(hitme, "team", 0))){
			if(!instance_is(self, prop)){
				motion_add_ct(point_direction(_x, _y, x, y), 0.5);
				
				 // Damage:
				if(instance_is(self, enemy) && meleedamage > 0 && size > other.size && projectile_canhit_melee(other)){
					projectile_hit(other, meleedamage);
				}
			}
		}
	}
	
	 // Animate:
	if(sprite_index == spr_hurt && anim_end){
		sprite_index = spr_idle;
		image_index  = 0;
	}
	
	 // Spawn Gators:
	if(button_pressed(0, "horn")){
		with(call(scr.obj_create, x, y - 8, choose(Gator, BuffGator, "BabyGator", "BoneGator", "AlbinoGator"))){
			with(call(scr.obj_create, x, y, "PalankingToss")){
				direction    = point_direction(x, y, mouse_x, mouse_y) + random_range(-60, 60);
				speed        = random_range(2, 4);
				zspeed       = 6;
				creator      = other;
				depth        = other.depth;
				mask_index   = other.mask_index;
				spr_shadow_y = other.spr_shadow_y;
			}
		}
	}
	
	 // Death:
	if(my_health <= 0){
		instance_destroy();
	}
	
#define BigPipe_end_step
	 // Stay Still:
	x = xstart;
	y = ystart;
	
#define BigPipe_destroy
	 // Reveal Hole:
	with(hole_inst){
		visible = true;
		big     = false;
		x       = other.x;
		y       = other.y;
	}
	
	 // Corpse:
	call(scr.corpse_drop, self, 0, 0);
	
	 // Sound:
	if(snd_dead == sndGeneratorBreak){
		sound_play_hit(sndSewerPipeBreak, 0.3);
	}
	
	 // Clear Walls:
	instance_create(x, y, PortalClear);
	
	
#define BoneRaven_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle     = spr.BoneRavenIdle;
		spr_walk     = spr.BoneRavenWalk;
		spr_hurt     = spr.BoneRavenHurt;
		spr_dead     = spr.BoneRavenDead;
		spr_lift     = spr.BoneRavenLift;
		spr_land     = spr.BoneRavenLand;
		spr_wing     = spr.BoneRavenFly;
		sprite_index = spr_idle;
		image_index  = random(image_number);
		spr_shadow   = shd24;
		hitid        = [spr_idle, "RAVEN"];
		depth        = -2;
		
		 // Sounds:
		snd_hurt = sndTurtleHurt;
		snd_dead = sndMutant14Hurt;
		
		 // Vars:
		mask_index = mskRat;
		maxhealth  = 10;
		raddrop    = 5;
		size       = 1;
		walk       = 0;
		walkspeed  = 0.6;
		maxspeed   = 2.5;
		creator    = noone;
		top_object = noone;
		active     = false;
		failed     = false;
		
		 // Alarms:
		alarm1 = -1;
		
		return self;
	}
	
#define BoneRaven_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Grounded:
	if(!instance_exists(top_object) || (top_object.speed == 0 && top_object.zspeed == 0)){
		 // Stay Still:
		if(!active){
			speed = 0;
		}
		
		 // Animate:
		if(sprite_index != spr_chrg || anim_end){
			sprite_index = enemy_sprite;
		}
	}
	
	 // Flight:
	else{
		alarm1 = max(alarm1, 30 + current_time_scale);
		
		 // Landing:
		if(top_object.zspeed < 0){
			if(sprite_exists(spr_chrg)){
				if(sprite_index != spr_land){
					if(top_object.z > 8){
						image_index = max(2, image_index);
						if(anim_end) spr_chrg = spr_land;
					}
				}
				else if(anim_end){
					spr_chrg = -1;
					sprite_index = enemy_sprite;
				}
			}
		}
		
		 // Flying:
		else if(sprite_index != spr_wing){
			if(sprite_index != spr_lift){
				spr_chrg = spr_lift;
			}
			else if(anim_end){
				spr_chrg = spr_wing;
				call(scr.sound_play_at, x, y, sndMutant14Turn, 1.4 + random(0.1), 2);
			}
		}
		else if(image_index < 1 && current_frame_active){
			if(chance(1, 3)){
				call(scr.sound_play_at, x, y, sndMutant14LowA, 1.8 + orandom(0.2), 2);
			}
			with(call(scr.fx, x, y, [270, 2], Dust)){
				depth = -7;
			}
		}
		
		 // Manual Spriting:
		if(sprite_exists(spr_chrg) && sprite_index != spr_chrg){
			sprite_index = spr_chrg;
			image_index  = 0;
		}
		
		 // Later Sucker:
		if(failed){
			with(top_object){
				jump_x += hspeed_raw;
				jump_y += vspeed_raw;
			}
			if(!point_seen_ext(x, y + (top_object.z / 2), sprite_width, sprite_height + (top_object.z / 2), -1)){
				with(call(scr.instance_nearest_bbox, x, y, Floor)){
					with(instance_create(bbox_center_x, bbox_center_y, Corpse)){
						sprite_index = mskNone;
					}
				}
				instance_delete(self);
			}
		}
	}
	
#define BoneRaven_alrm1
	alarm1 = 30 + random(30);
	
	 // You Lose:
	if(failed){
		BoneRaven_fly(-1, -1);
	}
	
	 // Back Away:
	else if(
		enemy_target(x, y)
		&& target_distance < 48
		&& target_visible
	){
		enemy_walk(target_direction + 180, random_range(10, 30));
		enemy_look(direction + 180);
		alarm1 = walk;
	}
	
	 // Wander:
	else if(chance(2, 3)){
		enemy_walk(random(360), random_range(20, 60));
		enemy_look(direction);
		
		 // Fly:
		if(chance(1, 3)){
			BoneRaven_fly(96, 160);
		}
	}
	
#define BoneRaven_hurt(_damage, _force, _direction)
	 // Fly Away:
	if(!active){
		active = true;
		
		 // Fly Away:
		var _disMin = 96;
		if(enemy_target(x, y)){
			_disMin += target_distance;
			enemy_look(target_direction);
		}
		BoneRaven_fly(_disMin, _disMin + 160);
	}
	
	 // Damage:
	call(scr.enemy_hurt, _damage, _force, _direction);
	
#define BoneRaven_death
	with(top_object){
		instance_destroy();
	}
	
	 // Return That Which You Stole:
	if(instance_exists(creator)){
		creator.num--;
		
		 // Rads:
		call(scr.rad_path, 
			call(scr.rad_drop, x, y, raddrop, direction, speed),
			creator
		);
		raddrop = 0;
		
		 // More Time:
		if(creator.alarm0 > 0){
			creator.alarm0 += 60;
		}
	}
	
#define BoneRaven_fly(_disMin, _disMax)
	var	_x = x,
		_y = y;
		
	if(_disMax < 0){
		_disMax = infinity;
	}
	
	with(call(scr.array_shuffle, instances_matching_ne(Floor, "id"))){
		var _dis = point_distance(_x, _y, clamp(_x, bbox_left, bbox_right + 1), clamp(_y, bbox_top, bbox_bottom + 1));
		if(_dis >= _disMin && _dis <= _disMax){
			if(!place_meeting(x, y, Wall)){
				var	_tx = bbox_center_x + orandom(bbox_width / 8),
					_ty = bbox_center_y + orandom(bbox_height / 8);
					
				 // We Have Liftoff:
				with(other){
					with(call(scr.top_create, x, y, self, 0, 0)){
						jump_time = 0;
						jump_x    = _tx;
						jump_y    = _ty;
						zspeed    = jump;
						zfriction = grav;
					}
					enemy_look(point_direction(x, y, _tx, _ty));
					
					 // Effects:
					if(point_seen(x, y, -1)){
						sound_play(sndRavenLand);
						repeat(4){
							with(call(scr.fx, [x, 8], y + random(16), random_range(3, 4), Dust)){
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
	
	
#define Ghost_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		spr_idle	 = spr.GhostIdle;
		spr_spwn	 = spr.GhostAppear;
		spr_dead	 = spr.GhostDisappear;
		spr_shadow   = shd24;
		spr_shadow_x = 0;
		spr_shadow_y = 8;
		halo_sprite  = spr.GhostHaloAppear;
		halo_index   = 0;
		sprite_index = spr_spwn;
		image_speed  = 0.4;
		depth		 = -2;
		
		 // Vars:
		dark_vertices  = 12;
		dark_scale     = 1/3;
		wave	       = random(90);
		prompt		   = call(scr.prompt_create, self, loc("NTTE:GatorStatue:Prompt", "BLESSING"), mskShield, 0, -10);
		prompt.visible = false;
		
		 // Sounds:
		sound_play_pitchvol(sndGuardianAppear, 0.8, 0.6);
		audio_sound_set_track_position(sound_play_pitchvol(sndStatueCharge, 0.8, 0.8), 0.5);
		
		 // Effects:
		repeat(10){
			with(call(scr.obj_create, x, y, "VaultFlowerSparkle")){
				motion_set(random(360), 1 + random(3));
				depth	 = other.depth - 1;
				gravity  = -0.1;
				friction = 0.1;
			}
		}
		
		return self;
	}
	
#define Ghost_step
	wave += current_time_scale;
	
	x = xstart + sin(wave / 10) * 2;
	y = ystart + cos(wave / 10) * 2 + sin(wave / 30) * 3;
	
	 // Particles:
	if(chance_ct(1, 5)){
		with(call(scr.obj_create, random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), "VaultFlowerSparkle")){
			motion_add(90, random(1));
			depth = other.depth - 1;
		}
	}
	
	 // Face Player:
	if(chance_ct(1, 30) && instance_exists(Player)){
		var _near = instance_nearest(x, y, Player);
		image_xscale = (_near.x < x ? -1 : 1);
	}
	
	 // Prompt Interaction:
	if(instance_exists(prompt)){
		
		if(player_is_active(prompt.pick)){
			sprite_index  = spr_dead;
			image_index   = 0;
			
			dark_scale	  = 5/3;
			
			 // The Blessing (underwhelming, like hivemind):
			with(call(scr.obj_create, x, y, "OrchidBall")){
				skill = mut_last_wish;
			}
			
			 // Restore Strong Spirit Potential (just kidding about the hivemind comment):
			if(skill_get(mut_strong_spirit) > 0){
				with(player_find(prompt.pick)){
					if(canspirit == false){
						GameCont.canspirit[index] = true;
					}
				}
			}
			
			 // Effects (please don't be mad bro):
			sleep(20);
			
			repeat(10){
				var l = random_range(16, 24),
					d = random(360);
					
				with(call(scr.obj_create, x + lengthdir_x(l, d), y + lengthdir_y(l, d), "VaultFlowerSparkle")){
					motion_set(d, 1 + random(4));
					
					 // gravity_direction is so lit bro
					 // why didn't i realize this was a thing sooner
					 
					gravity_direction = direction;
					gravity 		  = -0.1;
					friction		  = 0.1;
				}
			}
			
			 // Sounds:
			sound_play_pitchvol(sndCrownRandom, 	  1,   0.2);
			sound_play_pitchvol(sndGuardianDisappear, 0.8, 0.6);
			
			 // Goodbye:
			instance_delete(prompt);
		}
	}
	
	 // Spawn Animation:
	if(sprite_index == spr_spwn){
		
		dark_vertices = max(dark_vertices - current_time_scale, 6);
		dark_scale	  = lerp_ct(dark_scale, 1, 1/5);
		
		if(anim_end){
			sprite_index = spr_idle;
			image_index  = 0;
		}
	}
	else{
		
		 // Animate Halo:
		if(halo_index < sprite_get_number(halo_sprite) - 1){
			halo_index += image_speed_raw;
			
			if(halo_index >= sprite_get_number(halo_sprite) - 1){
				halo_index = sprite_get_number(halo_sprite) - 1;
				
				with(prompt) visible = true;
			}
		}
	}
	
	 // Death Animation
	if(sprite_index == spr_dead){
		
		dark_vertices = min(dark_vertices + current_time_scale, 12);
		dark_scale	  = lerp_ct(dark_scale, 0, 1/10);
		
		if(anim_end){
			with(instance_create(x, y, RecycleGland)){
				sprite_index = spr.GhostHaloDisappear;
			}
			
			 // Goodbye:
			instance_destroy();
		}
	}
	
#define Ghost_draw
	draw_sprite_ext(halo_sprite, halo_index, x, y + sin(wave / 10), image_xscale, image_yscale, image_angle, image_blend, image_alpha);


#define GhostStatue_create(_x, _y)
	/*
	 // Chests:
	var _num = 3,
		_ang = random(360);
		
	for(var i = 0; i < 360; i += (360 / _num)){
		var l = random_range(24, 32);
			d = _ang + i;
			
		with(call(scr.obj_create, _x + lengthdir_x(l, d), _y + lengthdir_y(l, d), "OrchidChest")){
			sprite_index = spr.OrchidChestWilted;
			alive = false;
		}
	}
	
	 // Details:
	var _area = GameCont.area;
	GameCont.area = area_desert;
	
	repeat(15){
		with(instance_create(_x + orandom(48), _y + orandom(48), Detail)){
			sprite_index = spr.VaultFlowerWiltedDebris;
		}
	}
	
	GameCont.area = _area;
	*/
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle	 = spr.GhostStatueIdle;
		spr_hurt	 = spr.GhostStatueHurt;
		spr_dead	 = spr.GhostStatueDead;
		sprite_index = spr_idle;
		depth		 = -1;
		
		 // Sounds:
		snd_hurt = sndHitRock;
		snd_dead = sndPillarBreak;
		
		 // Vars:
		maxhealth = 30;
		size	  = 3;
		
		return self;
	}
	
#define GhostStatue_death
	with(instance_create(x, y, Debris)){
		sprite_index = spr.GhostStatueDebris;
		motion_set(random(360), 4);
	}
	with(call(scr.obj_create, x, y - 16, "Ghost")){
		right = other.image_xscale;
	}
	
	
#define QuestChest_create(_x, _y)
	/*
		Used for the ultimate quest
	*/
	
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.QuestChest;
		spr_dead	 = spr.QuestChestOpen;
		spr_shadow   = shd32;
		
		 // Sounds:
		snd_open = sndWeaponChest;
		
		 // Vars:
		wep = { wep: "crabbone", ammo: 1 };
		
		 // Events:
		on_step = script_ref_create(QuestChest_step);
		on_open = script_ref_create(QuestChest_open);
		
		return self;
	}
	
#define QuestChest_step
	/*
		Quest chests sparkle
	*/
	
	if(chance_ct(1, 60)){
		with(call(scr.obj_create,
			random_range(bbox_left, bbox_right  + 1),
			random_range(bbox_top,  bbox_bottom + 1),
			"VaultFlowerSparkle"
		)){
			sprite_index = spr.QuestSparkle;
			depth		 = other.depth - 1;
		}
	}
	
#define QuestChest_open
	/*
		Quest chests drop their stored weapon when opened
	*/
	
	with(instance_create(x, y, WepPickup)){
		ammo = true;
		wep  = other.wep;
	}
	
	
#define QuestFloorCont_create(_x, _y)
	/*
		The controller object for quest floor tiles
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		depth = 5;
		
		 // Vars:
		part_index = -1;
		target     = noone;
		prompt     = call(scr.prompt_create, self, loc("NTTE:PetMimic:Prompt", "DROP"), mskWepPickup, 0, 0);
		with(prompt){
			on_meet = script_ref_create(QuestFloorCont_prompt_meet);
		}
		
		return self;
	}
	
#define QuestFloorCont_step
	/*
		Quest floor tiles have a sparkly hint when players stand on them and accept player artifacts
	*/
	
	if(instance_exists(target)){
		var _partIndex = part_index;
		
		 // Sparkle:
		if((current_frame % 10) < current_time_scale){
			with(target){
				var _canSparkle = place_meeting(x, y, Player);
				with(Player){
					if(
						(call(scr.wep_raw, wep)  == "crabbone" && array_find_index(lq_defget(wep,  "quest_part_index_list", []), _partIndex) >= 0) ||
						(call(scr.wep_raw, bwep) == "crabbone" && array_find_index(lq_defget(bwep, "quest_part_index_list", []), _partIndex) >= 0)
					){
						_canSparkle = true;
						break;
					}
				}
				if(_canSparkle){
					with(call(scr.obj_create,
						random_range(bbox_left, bbox_right  + 1),
						random_range(bbox_top,  bbox_bottom + 1),
						"VaultFlowerSparkle"
					)){
						sprite_index = spr.QuestSparkle;
						depth		 = 1;
						switch(_partIndex){
							case 0 : sprite_index = spr.AllyLaserCharge;    break;
							case 1 : sprite_index = spr.ElectroPlasmaTrail; break;
							case 2 : sprite_index = spr.PopoLaserCharge;    break;
							case 3 : sprite_index = sprLaserCharge;         break;
						}
					}
				}
			}
		}
		
		 // Drop Artifact:
		if(instance_exists(prompt) && player_is_active(prompt.pick)){
			with(player_find(prompt.pick)){
				with(other.prompt){
					if(QuestFloorCont_prompt_meet()){
						with(other){
							 // Cursed:
							if(curse > 0){
								sound_play_hit(sndCursedReminder, 0.05);
							}
							
							 // Drop:
							else{
								with(instance_create(other.creator.x, other.creator.y, WepPickup)){
									var _wep = lq_clone(other.wep);
									_wep.ammo                  = 1;
									_wep.quest_part_index_list = [_partIndex];
									wep                        = _wep;
									with(other.wep){
										ammo--;
										quest_part_index_list = call(scr.array_delete,
											quest_part_index_list,
											array_find_index(quest_part_index_list, _partIndex)
										);
									}
									
									 // Sound:
									sound_play_hit(sndWeaponPickup, 0.1);
								}
								call(scr.unlock_set, `quest:part:${_partIndex}`, true);
							}
						}
					}
				}
			}
		}
	}
	else instance_destroy();
	
#define QuestFloorCont_draw
	/*
		...
	*/
	
	// draw_set_blend_mode(bm_add);
	
	// with(target){
	// 	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha * place_meeting(x, y, WepPickup));
	// }
	
	// draw_set_blend_mode(bm_normal);
	
#define QuestFloorCont_cleanup
	/*
		Quest floor tiles permanently store artifacts for future vault visits
	*/
	
	var _partState = false;
	
	with(instances_matching(WepPickup, "visible", true)){
		if(
			call(scr.wep_raw, wep) == "crabbone"
			&& array_find_index(lq_defget(wep, "quest_part_index_list", []), other.part_index) >= 0
		){
			_partState = true;
			break;
		}
	}
	
	call(scr.unlock_set, `quest:part:${part_index}`, _partState);
	
#define QuestFloorCont_prompt_meet
	/*
		Quest floor tiles allow players holding an artifact to drop it on them
	*/
	
	return (
		call(scr.wep_raw, other.wep) == "crabbone"
		&& array_find_index(lq_defget(other.wep, "quest_part_index_list", []), creator.part_index) >= 0
	);
	
	
#define LockedBigQuestChest_create(_x, _y)
	/*
		Used for the ultimate quest
	*/
	
	with(call(scr.obj_create, _x, _y, chestprop)){
		 // Visual:
		sprite_index = spr.BigQuestChest;
		spr_shadow   = shd32;
		spr_shadow_y = 8;
		
		return self;
	}
	
#define LockedBigQuestChest_step
	/*
		Big quest chests sparkle & push players away
	*/
	
	 // Sparkles:
	if(chance_ct(1, 30)){
		with(call(scr.obj_create,
			random_range(bbox_left, bbox_right  + 1),
			random_range(bbox_top,  bbox_bottom + 1),
			"VaultFlowerSparkle"
		)){
			sprite_index = spr.QuestSparkle;
			depth		 = other.depth - 1;
		}
	}
	
	 // Push:
	if(place_meeting(x, y, Player)){
		with(call(scr.instances_meeting_instance, self, Player)){
			if(place_meeting(x, y, other)){
				motion_add(point_direction(other.x, other.y, x, y), 1);
			}
		}
	}
	
	
#define BigQuestChest_create(_x, _y)
	/*
		Used for the ultimate quest
	*/
	
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.BigQuestChest;
		spr_dead	 = spr.BigQuestChestOpen;
		spr_shadow   = shd32;
		spr_shadow_y = 8;
		
		 // Sounds:
		snd_open = sndBigWeaponChest;
		
		 // Events:
		on_step = script_ref_create(LockedBigQuestChest_step);
		
		return self;
	}
	
	
#define QuestProp_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		var _num	 = irandom_range(1, 3);
		spr_idle	 = lq_get(spr, `QuestProp${_num}Idle`);
		spr_hurt	 = lq_get(spr, `QuestProp${_num}Hurt`);
		spr_dead	 = lq_get(spr, `QuestProp${_num}Dead`);
		spr_shadow   = mskNone;
		sprite_index = spr_idle;
		
		 // Sounds:
		snd_hurt = sndNothingHurtHigh;
		snd_dead = sndNothingHurtLow;
		
		 // Vars:
		maxhealth = 90;
		
		return self;
	}
	

#define SawTrap_create(_x, _y)
	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		spr_idle     = spr.SawTrap;
		spr_walk     = spr.SawTrap;
		spr_hurt     = spr.SawTrapHurt;
		spr_shadow   = mskNone;
		spr_shadow_y = 6;
		hitid        = [spr_idle, "SAWBLADE TRAP"];
		image_speed  = 0.4;
		depth        = 1;
		
		 // Sound:
		snd_hurt = sndHitMetal;
		snd_dead = sndHydrantBreak;
		snd_mele = sndDiscHit;
		loop_snd = -1;
		
		 // Vars:
		mask_index  = mskShield;
		friction    = 0.2;
		maxhealth   = 30;
		meleedamage = 6;
		canmelee    = true;
		raddrop     = 0;
		size        = 3;
		team        = 1;
		walled      = false;
		side        = choose(-1, 1);
		maxspeed    = 3;
		spd         = 0;
		dir         = random(360);
		active      = false;
		sawtrap_hit = false;
		
		 // Move Towards Nearest Wall:
		with(call(scr.instance_nearest_bbox, x, y, Wall)){
			dir = point_direction(other.x, other.y, bbox_center_x, bbox_center_y);
		}
		
		 // Alarms:
		alarm0 = random_range(30, 60);
		
		return self;
	}

#define SawTrap_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Manual Movement:
	speed = 0;
	
	 // Start/Stop:
	if(instance_exists(Portal)){
		active = false;
	}
	var _goal = (active * maxspeed);
	spd += (_goal - spd) * friction * current_time_scale;
	
	 // Stick to Wall:
	var _x       = x,
		_y       = y,
		_sideDis = 8,
		_sideDir = dir + (90 * side),
		_walled  = collision_circle(_x + lengthdir_x(_sideDis, _sideDir), _y + lengthdir_y(_sideDis, _sideDir), 1, Wall, false, false);
		
	if(!_walled && walled){
		dir += 90 * side;
	}
	walled = _walled;
	
	 // Movement/Wall Collision:
	var _l = spd * current_time_scale,
		_d = dir;
		
	if(!collision_circle(_x + lengthdir_x(_l, _d), _y + lengthdir_y(_l, _d), 1, Wall, false, false)){
		x += lengthdir_x(_l, _d);
		y += lengthdir_y(_l, _d);
		x = round(x);
		y = round(y);
	}
	else dir -= 90 * side;
	
	dir = pround(dir, 90);
	dir = (dir + 360) % 360;
	
	 // Animate:
	if(sprite_index == spr_hurt && anim_end){
		sprite_index = spr_idle;
	}
	
	 // Spin:
	image_angle += 4 * spd * side * current_time_scale;
	
	 // BoltStick Depth Fix:
	if(instance_exists(BoltStick)){
		var _inst = instances_matching_lt(instances_matching(BoltStick, "target", self), "depth", depth);
		if(array_length(_inst)){
			with(_inst){
				depth = other.depth;
			}
		}
	}
	
	 // Effects:
	if(spd > 1 && point_seen(x, y, -1)){
		if(chance_ct(1, 2)){
			var _l      = random(12),
				_d      = dir,
				_debris = (walled && chance(1, 30)),
				_x      = x + lengthdir_x(_l, _d),
				_y      = y + lengthdir_y(_l, _d) - 2;
				
			instance_create(_x, _y, (_debris ? Debris : Dust));
			
			if(_debris){
				sound_play_pitchvol(sndWallBreak, 2, 0.2);
				view_shake_max_at(x, y, random_range(2, 6));
			}
		}
		if(walled){
			var	_l = random_range(12, 16),
				_d = dir,
				_x = x + lengthdir_x(_l, _d) + orandom(2),
				_y = y + lengthdir_y(_l, _d) - random(2);
				
			if(chance_ct(2, 3)){
				with(instance_create(_x, _y, BulletHit)){
					sprite_index = choose(sprGroundFlameDisappear, sprGroundFlameBigDisappear);
					image_angle  = _d - (random_range(15, 60) * other.side);
					image_yscale = -random_range(1, 1.5) * other.side;
					
					if(!place_meeting(x, y, Wall)){
						instance_destroy();
					}
				}
			}
			if(chance_ct(1, 4)){
				with(call(scr.fx, [_x, 3], [_y, 3], [_d - (random_range(45, 90) * side), random(2)], Sweat)){
					image_blend = make_color_rgb(255, 222, 56);
				}
			}
		}
	}
	
	 // Sound:
	var _volGoal = (spd / maxspeed);
	if(_volGoal > 0 && point_seen(x, y, player_find_local_nonsync())){
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
	var _scale      = 0.55,
		_sawtrapHit = false;
		
	image_xscale *= _scale;
	image_yscale *= _scale;
	if(place_meeting(x, y, hitme)){
		with(call(scr.instances_meeting_instance, self, hitme)){
			if(place_meeting(x, y, other) && !collision_line(x, y, other.x, other.y, Wall, false, false)){
				if(!instance_is(self, prop) || size <= 1){
					 // Push:
					if(!instance_is(self, prop) && (size < other.size || instance_is(self, Player))){
						motion_add_ct(point_direction(other.x, other.y, x, y), 0.6);
					}
					
					 // Contact Damage:
					with(other) if(active && canmelee && projectile_canhit_melee(other)){
						projectile_hit_np(other, meleedamage, 4, 40);
						
						 // Effects:
						call(scr.sound_play_at, x, y, snd_mele, 0.7 + random(0.2), 1);
					}
				}
				
				 // Epic FX:
				if(other.walled && array_find_index(obj.SawTrap, self) >= 0){
					if(active && side != other.side && walled){
						_sawtrapHit = true;
						if(!sawtrap_hit || chance_ct(1, 30)){
							call(scr.sound_play_at, x, y, sndDiscBounce, 0.6 + random(0.2), 0.8);
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
		instance_destroy();
	}
	
#define SawTrap_alrm0
	active = true;

#define SawTrap_hurt(_damage, _force, _direction)
	my_health -= _damage;
	nexthurt = current_frame + 6;
	sound_play_hit(snd_hurt, 0.3);

	 // Hurt Sprite:
	sprite_index = spr_hurt;
	image_index  = 0;

	 // Push:
	if(active){
		spd /= 2;
	}
	else{
		spd = _force / 4;
		dir = _direction;
	}
	
#define SawTrap_destroy
	 // Explo:
	with(call(scr.projectile_create, x, y, Explosion)){
		team = -1;
	}
	repeat(3){
		with(call(scr.projectile_create, x + orandom(6), y + orandom(6), SmallExplosion)){
			team = -1;
		}
	}
	
	 // Effects:
	repeat(3){
		instance_create(x + orandom(16), y + orandom(16), GroundFlame);
	}
	repeat(3 + irandom(3)){
		with(instance_create(x, y, Debris)){
			sprite_index = spr.SawTrapDebris;
		}
	}
	
	 // Sounds:
	call(scr.sound_play_at, x, y, sndExplosion, 1 + orandom(0.1), 3);
	call(scr.sound_play_at, x, y, snd_dead,     1 + orandom(0.2), 3);
	
	 // Pickups:
	pickup_drop(50, 0);
	
#define SawTrap_cleanup
	sound_stop(loop_snd);
	
	
#define SludgePool_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = msk.SludgePool;
		spr_floor    = spr.SludgePool;
		depth        = 4;
		
		 // Vars:
		mask_index = -1;
		floors     = [];
		fx_color   = make_color_rgb(130 - 40, 189, 5);
		my_alert   = noone;
		right      = choose(-1, 1);
		setup      = true;
		num        = -1;
		
		 // Alarms:
		alarm0 = -1;
		alarm1 = -1;
		
		return self;
	}
	
#define SludgePool_setup
	setup = false;
	
	 // Floorerize:
	if(array_length(floors) <= 0){
		floors = call(scr.floor_fill, 
			x,
			y,
			ceil(abs(sprite_width)  / 32),
			ceil(abs(sprite_height) / 32)
		);
		
		 // Center Position:
		var _num = array_length(floors);
		if(_num > 0){
			x = 0;
			y = 0;
			with(floors){
				other.x += bbox_center_x;
				other.y += bbox_center_y;
			}
			x /= _num;
			y /= _num;
		}
	}
	
	 // Floor Setup:
	var _img = 0;
	with(floors){
		if(instance_exists(self)){
			sprite_index = other.spr_floor;
			image_index  = ((sprite_index = sprFloor3) ? 3 : _img);
			
			 // Slimy Material:
			if(material > 0 && material < 4){
				material += 3;
			}
		}
		_img++;
	}
	
	 // Ravens:
	if(num > 0){
		var	_ang = random(360),
			_dis = 12;
			
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / num)){
			with(call(scr.obj_create, round(x + lengthdir_x(_dis, _dir)), round(y + lengthdir_y(_dis, _dir)), "BoneRaven")){
				x = xstart;
				y = ystart;
				y -= round(bbox_bottom - y);
				creator = other;
				enemy_look(_dir);
				call(scr.instance_budge, self, enemy, 4);
			}
		}
	}
	
	 // Move Manhole:
	if(array_length(obj.Manhole)){
		var _instHole = call(scr.instances_meeting_instance, self, obj.Manhole);
		if(array_length(_instHole)){
			var _inst = self;
			with(_instHole){
				if(place_meeting(x, y, other)){
					with(call(scr.array_shuffle, FloorNormal)){
						var _move = true;
						if(place_meeting(x, y, _inst)){
							_move = false;
						}
						else if(place_meeting(x, y, _inst.object_index)){
							var _instMeet = call(scr.instances_meeting_instance, self, obj.SludgePool);
							if(array_length(_instMeet)) with(_instMeet){
								if(place_meeting(x, y, other)){
									_move = false;
									break;
								}
							}
						}
						if(_move){
							other.x = bbox_center_x;
							other.y = bbox_center_y;
							break;
						}
					}
				}
			}
		}
	}
	
#define SludgePool_step
	if(setup) SludgePool_setup();
	
	 // Alarms:
	if(alarm0_run) exit;
	if(alarm1_run) exit;
	
	 // Big:
	if(num >= 0){
		 // Raven Time:
		if(num > 0){
			if(instance_exists(CustomEnemy)){
				var _ravens = instances_matching(obj.BoneRaven, "creator", self);
				if(array_length(_ravens)){
					 // Wait for Player:
					if(alarm0 < 0){
						var _start = (array_length(instances_matching(_ravens, "active", true)) > 0);
						if(!_start){
							with(Player){
								if(point_distance(x, y, other.x, other.y) < 96){
									if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
										_start = true;
										break;
									}
								}
							}
						}
						if(_start){
							alarm0 = 120;
						}
					}
					
					 // Take Flight:
					if(alarm0 > 0){
						var _inst = instances_matching(_ravens, "active", false);
						if(array_length(_inst)){
							var _dis = 96;
							with(_inst){
								active = true;
								BoneRaven_fly(_dis, _dis + 64);
								_dis += 64;
							}
						}
					}
				}
			}
		}
		
		 // Activate Saladman:
		else{
			num    = -1;
			alarm1 = 150;
			
			 // Face Player:
			with(instance_nearest(x, y, Player)){
				with(other){
					enemy_face(point_direction(x, y, other.x, other.y));
				}
			}
			
			 // Alert:
			with(my_alert){
				instance_destroy();
			}
			my_alert = call(scr.alert_create, self, spr.SludgePoolAlert);
			with(my_alert){
				alert.spr = spr.AlertIndicatorMystery;
				alert.col = c_yellow;
				target_y -= 4;
				alarm0    = -1;
			}
		}
	}
	
	 // Bubblin'
	if(alarm1 > 0){
		if(chance_ct(1, 30) || frame_active(15)){
			var	_l = random_range(1/10, 1/3) * choose(-1, 1),
				_d = current_frame * 10,
				_x = x + lengthdir_x(_l * sprite_width,        _d),
				_y = y + lengthdir_y(_l * sprite_height * 2/3, _d);
				
			with(instance_create(_x, _y, RainSplash)){
				image_blend = merge_color(other.fx_color, c_black, random(0.1));
				with(instance_create(x, y, Bubble)){
					gravity    *= random_range(0.5, 0.8);
					image_blend = other.image_blend;
					image_index = irandom(2);
					hspeed     /= 3;
					vspeed      = 0;
				}
			}
		}
		
		 // Sounds:
		var	_snd         = [sndOasisMelee, sndOasisCrabAttack, sndOasisChest],
			_sndInterval = (point_seen(x, y, -1) ? 8 : 12);
			
		if(frame_active(_sndInterval) || chance(1, 12)){
			sound_play_hit(_snd[((current_frame / _sndInterval) / 1.5) % array_length(_snd)], 0.4);
		}
		
		 // Alert Wobble:
		if(instance_exists(my_alert)){
			my_alert.alert.ang = sin(current_frame * 0.1) * 20;
		}
	}
	
	 // Goodbye:
	if(!array_length(instances_matching_ne(floors, "id"))){
		instance_destroy();
	}
	
#define SludgePool_end_step
	 // Sticky Sludge:
	if(instance_exists(hitme) && place_meeting(x, y, hitme)){
		with(call(scr.instances_meeting_instance, self, instances_matching_lt(instances_matching_gt(hitme, "speed", 0), "size", 6))){
			if(position_meeting(x, bbox_bottom, other)){
				var _slow = true;
				
				 // Footsteps:
				if(instance_is(self, Player)){
					mod_script_call("mod", "ntte", "footprint_give", 40, other.fx_color, 1.1);
					if(skill_get(mut_extra_feet) > 0){
						_slow = false;
					}
				}
				
				 // Slow:
				if(_slow){
					x = lerp(xprevious, x, 2/3);
					y = lerp(yprevious, y, 2/3);
				}
				
				 // Somethins comin up bro:
				if(other.alarm1 > 0){
					motion_add_ct(point_direction(other.x, other.y, x, y), 0.6);
				}
				
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
	}
	
	 // Effects:
	if(instance_exists(RainSplash) && place_meeting(x, y, RainSplash)){
		with(instances_matching(call(scr.instances_meeting_instance, self, RainSplash), "image_blend", c_white)){
			var	_l = 4,
				_d = point_direction(other.x, other.y, x, y);
				
			if(position_meeting(x + lengthdir_x(_l, _d), y + lengthdir_y(_l * 2/3, _d), other)){
				image_blend = other.fx_color;
			}
		}
	}
	if(instance_exists(Dust) && place_meeting(x, y, Dust)){
		with(instances_matching(call(scr.instances_meeting_instance, self, Dust), "sprite_index", sprDust)){
			if(position_meeting(x, y, other)){
				sprite_index = sprSweat;
				image_blend = other.fx_color;
				speed /= 3;
			}
		}
	}
	
#define SludgePool_draw
	 // Silhouette:
	if(alarm1 > 0){
		var	_spr = spr.PetSalamanderIdle,
			_img = 0.4 * current_frame,
			_x   = x,
			_y   = y + (max(0, alarm1 - 60) / 8) + (min(1, alarm1 / 10) * sin(current_frame / 10)),
			_xsc = image_xscale * right,
			_ysc = image_yscale,
			_ang = image_angle,
			_col = image_blend,
			_alp = image_alpha / max(1, 0.1 * (alarm1 - 50));
			
		draw_set_fog(true, fx_color, 0, 0);
		draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
		draw_set_fog(false, 0, 0, 0);
	}
	
#define SludgePool_alrm0
	 // Mishin Failed:
	with(instances_matching(obj.BoneRaven, "creator", self)){
		failed = true;
	}
	
#define SludgePool_alrm1
	 // DUDE:
	with(call(scr.pet_create, x, y, "Salamander")){
		right = other.right;
	}
	
	 // Splash:
	for(var _dir = 0; _dir < 360; _dir += (360 / 3)){
		with(call(scr.fx, [x, 8], [y, 4], [_dir + 90, 2], AcidStreak)){
			image_angle += orandom(30);
			image_blend = merge_color(image_blend, c_lime, random(0.1));
		}
	}
	repeat(8){
		with(call(scr.fx, x, y, [90 + orandom(60), random(1)], Sweat)){
			image_blend = merge_color(other.fx_color, c_lime, random(0.3));
		}
	}
	sound_play_pitch(sndCorpseExplo, 1 + orandom(0.1));
	sound_play(sndOasisMelee);
	
	 // Update Alert:
	with(my_alert){
		sprite_index = spr.PetSalamanderIcon;
		alert.spr    = spr.AlertIndicator;
		alert.ang    = 0;
		alarm0       = 90;
		flash        = 3;	
		snd_flash    = sndSalamanderEndFire;
	}
	
	
#define TopRaven_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle     = sprRavenIdle;
		spr_walk     = sprRavenWalk;
		spr_hurt     = sprRavenHurt;
		spr_dead     = sprRavenDead;
		spr_lift     = sprRavenLift;
		spr_land     = sprRavenLand;
		spr_wing     = sprRavenFly;
		spr_shadow   = shd24;
		hitid        = 15;
		sprite_index = spr_idle;
		image_index  = random(image_number);
		depth        = object_get_depth(Raven);
		
		 // Sound:
		snd_hurt = sndRavenHit;
		snd_dead = sndRavenDie;
		
		 // Vars:
		mask_index = object_get_mask(Raven);
		maxhealth  = 10;
		raddrop    = 4;
		size       = 1;
		top_object = noone;
		setup      = true;
		
		return self;
	}
	
#define TopRaven_setup
	setup = false;
	
	 // Top Object Setup:
	if(!instance_exists(top_object)){
		top_object = call(scr.top_create, x, y, self, -1, -1);
	}
	with(top_object) if(z > 8){
		canmove = false;
	}
	
#define TopRaven_step
	if(setup) TopRaven_setup();
	
	 // Animate:
	if(instance_exists(top_object)){
		if(top_object.speed != 0 || (top_object.zspeed != 0 && spr_chrg != spr_land)){
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
							with(call(scr.fx, [x, 8], y + random(16), random_range(3, 4), Dust)){
								depth = other.depth;
							}
						}
					}
				}
				else if(anim_end){
					spr_chrg = spr_wing;
				}
			}
			
			 // Manual Spriting:
			if(sprite_index != spr_chrg){
				sprite_index = spr_chrg;
				image_index  = 0;
			}
		}
		else if(sprite_index != spr_chrg || anim_end){
			sprite_index = enemy_sprite;
		}
	}
	
	 // Goodbye:
	else{
		if(sprite_index == spr_chrg){
			sprite_index = enemy_sprite;
		}
		spr_chrg = -1;
		instance_destroy();
	}
	
#define TopRaven_death
	pickup_drop(20, 0);
	
	 // Feathers:
	repeat(4){
		with(instance_create(x, y, Feather)){
			sprite_index = sprRavenFeather;
		}
	}
	
#define TopRaven_destroy
	 // Become Raven:
	if(my_health > 0){
		with(instance_create(x, y, Raven)){
			other.name = null;
			call(scr.variable_instance_set_list, self, call(scr.variable_instance_get_list, other));
			alarm1 = 20 + random(10);
			
			 // Target:
			if(
				enemy_target(x, y)
				&& sign(right) == sign(target.x - x)
				&& target_visible
			){
				enemy_look(target_direction);
			}
			
			 // Swappin:
			var _l = 4,
				_d = gunangle;
				
			instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), WepSwap);
			wkick = 4;
			
			 // Effects:
			if(point_seen(x, y, -1)){
				sound_play(sndRavenLand);
			}
		}
		instance_delete(self);
	}
	
	
#define TrapSpin_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.TrapSpin;
		hitid        = 57;
		
		 // Sound:
		loop_snd = -1;
		
		 // Vars:
		mask_index = mskExploder;
		friction   = 0.4;
		my_health  = 1000000000000000;
		rotspeed   = 1.5 * choose(-1, 1);
		size       = 3;
		team       = 1;
		fire       = false;
		canrot     = false;
		
		 // Alarms:
		alarm0 = 300;
		
		 // Wall:
		with(instance_create(x - 8, y - 8, Wall)){
			image_alpha = 0;
			visible     = false;
			topspr      = -1;
			outspr      = -1;
			
			 // Scorch:
			instance_create(x, y, TrapScorchMark);
		}
		
		return self;
	}
	
#define TrapSpin_step
	 // Alarms:
	if(alarm0_run) exit;
	if(alarm1_run) exit;
	
	 // Level Over:
	if(instance_exists(Portal)){
		fire   = false;
		alarm0 = 30;
	}
	
	 // Spin:
	if(canrot){
		var _lastImageAngle = image_angle;
		image_angle += rotspeed * current_time_scale;
		if(
			(rotspeed > 0)
			? (pfloor(image_angle, 90) != pfloor(_lastImageAngle, 90))
			: (pceil (image_angle, 90) != pceil (_lastImageAngle, 90))
		){
			image_angle = ((rotspeed > 0) ? pfloor(image_angle, 90) : pceil(image_angle, 90));
			canrot      = false;
			alarm1      = 30;
		}
	}
	
	 // Flames:
	if(fire != false){
		if((current_frame % (1 / fire)) < current_time_scale){
			repeat(ceil(fire * current_time_scale)){
				var	_dis = 12,
					_spd = 6;
					
				for(var _dir = image_angle; _dir < image_angle + 360; _dir += 90){
					call(scr.projectile_create, x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), TrapFire, _dir, _spd);
				}
			}
		}
		
		 // Sound:
		if(!audio_is_playing(loop_snd)){
			var _lastSeed = random_get_seed();
			loop_snd = call(scr.sound_play_at, x, y, sndFlamerLoop, 1 + orandom(0.1), 3);
			random_set_seed(_lastSeed);
		}
	}
	else sound_stop(loop_snd);
	
	 // Die:
	if(!position_meeting(x, y, Wall)){
		instance_destroy();
	}
	
#define TrapSpin_draw
	 // CustomObject:
	image_alpha = -abs(image_alpha);
	
	 // 3D Trap:
	for(var i = 0; i < image_number; i++){
		draw_sprite_ext(sprite_index, i, x, y - i, image_xscale, image_yscale, image_angle, image_blend, abs(image_alpha));
	}
	
#define TrapSpin_alrm0
	 // Activate Flames:
	if(fire <= 0){
		fire   = true;
		alarm1 = 90;
		sound_play_hit_big(sndFiretrap, 0.2);
	}
	
#define TrapSpin_alrm1
	 // Start Spinning:
	if(!instance_exists(Portal)){
		canrot = true;
	}
	
#define TrapSpin_destroy
	 // Shh:
	sound_stop(loop_snd);
	
	 // FloorExplo Fix:
	with(instances_matching(instances_matching(FloorExplo, "x", x - 8), "y", y - 8)){
		var	_ox  = -8,
			_oy  = -8,
			_ang = other.image_angle;
			
		x = other.x + lengthdir_x(_ox, _ang) + lengthdir_x(_oy, _ang - 90);
		y = other.y + lengthdir_y(_ox, _ang) + lengthdir_y(_oy, _ang - 90);
		image_angle = _ang;
		
		break;
	}
	
	 // More Debris:
	repeat(3){
		instance_create(x, y, Debris);
		call(scr.fx, x, y, 2, Dust);
	}
	
	
#define Tunneler_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle     = sprBanditIdle;
		spr_walk     = sprBanditWalk;
		spr_hurt     = sprBanditHurt;
		spr_dead     = sprBanditDead;
		spr_shadow   = shd24;
		spr_shadow_y = -1;
		hitid        = [spr_idle, "TUNNELER"];
		depth        = -11;
		
		 // Sound:
		snd_hurt = sndGatorHit;
		snd_dead = sndGatorDie;
		
		 // Vars:
		mask_index  = mskBandit;
		maxhealth   = 15;
		meleedamage = 2;
		canmelee    = true;
		raddrop     = 8;
		size        = 1;
		walk        = 0;
		walkspeed   = 0.8;
		maxspeed    = 2.4;
		gunangle    = random(360);
		direction   = gunangle;
		tunneling   = 0;
		tunnel_wall = noone;
		
		 // Alarms:
		alarm1 = 20 + irandom(30);
		
		return self;
	}
	
#define Tunneler_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Movement:
	if(tunneling){
		walk = 0;
	}
	else if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Animate:
	sprite_index = enemy_sprite;

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
			walk--;
			alarm1 = 2 + irandom(4);
			
			 // Target is near/alive:
			if(target_distance < 256) {
				var _targetDir = pceil(target_direction, 90);
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
		}
		
		else {
			alarm1 = 10 + irandom(5);
			walk = 10;
		}
	} 
	
	 // Normal AI:
	else {
		if(target_distance < 256) {
			enemy_look(target_direction);
			
			if(target_visible && chance(2, 3)) {
				call(scr.projectile_create, x, y, EnemyBullet1, gunangle, 6);
			}
			
			else {
				var _targetWall = call(scr.instance_nearest_bbox, x, y, Wall);
				var _targetDist = point_distance(x, y, _targetWall.x + 8, _targetWall.y + 8);
				
				if(_targetDist < 8) {
					alarm1 = 5 + random(5);
					enemy_walk(
						point_direction(x, y, _targetWall.x, _targetWall.y) + orandom(5),
						_targetDist / walkspeed
					);
				}
				
				else {
					Tunneler_tunnel(1, _targetWall);
				}
			}
		} 
		
		else {
			enemy_walk(random(360), random_range(10, 20));
			enemy_look(direction);
		}
	}
	
#define Tunneler_hurt(_damage, _force, _direction)
	my_health -= _damage;
	nexthurt = current_frame + 6;
	sound_play_hit(snd_hurt, 0.3);
	sprite_index = spr_hurt;
	image_index = 0;
	
	if(tunneling) {
		call(scr.wall_clear, self);
		Tunneler_tunnel(0, noone);
	}

#define Tunneler_tunnel(_tf, _wall)
	tunneling = _tf;
	tunnel_wall = _wall;
	canfly = _tf;
	if(_tf = 1) mask_index = mskBanditBoss; 
	else mask_index = mskBandit;
	
	
#define WallCrate_create(_x, _y)
	/*
		A crate made out of wall tiles, destroy the walls to reach the goodies inside
	*/
	
	with(instance_create(_x, _y, FloorMiddle)){
		 // Pallet:
		mask_index   = mskIcon;
		sprite_index = spr.FloorCrate;
		depth        = 5;
		crate_wall   = [];
		crate_loot   = noone;
		
		 // Clear Space:
		//call(scr.floor_fill, x, y, bbox_width / 32, bbox_height / 32);
		
		 // Crate Walls:
		var _lastArea = GameCont.area;
		GameCont.area = area_campfire;
		for(var _wy = bbox_top; _wy < bbox_bottom + 1; _wy += 16){
			for(var _wx = bbox_left; _wx < bbox_right + 1; _wx += 16){
				array_push(crate_wall, instance_create(_wx, _wy, Wall));
			}
		}
		GameCont.area = _lastArea;
		for(var i = array_length(crate_wall) - 1; i >= 0; i--){
			with(crate_wall[i]){
				sprite_index = spr.WallCrateBot;
				topspr       = spr.WallCrateTop;
				outspr       = spr.WallCrateOut;
				image_index  = i;
				topindex     = i;
				outindex     = i;
			}
		}
		
		 // Fix Drawing Order:
		if(fork()){
			wait 0;
			if(instance_exists(self)){
				var _inst = call(scr.instances_in_rectangle,
					bbox_left   - 16,
					bbox_top    - 16,
					bbox_right  + 1,
					bbox_bottom + 1,
					instances_matching_lt(Wall, "id", id)
				);
				array_sort(_inst, true);
				
				 // GMS2:
				try{
					if(!null){
						with(_inst){
							with(instance_copy(false)){
								if(fork()){
									var _lastMask = mask_index;
									mask_index = mskNone;
									wait 0;
									if(instance_exists(self) && mask_index == mskNone){
										mask_index = _lastMask;
									}
									exit;
								}
							}
							instance_delete(self);
						}
					}
				}
				
				 // GMS1:
				catch(_error){
					with(_inst){
						instance_copy(false);
						instance_delete(self);
					}
				}
			}
			exit;
		}
		
		return self;
	}
	
#define WallCrate_step
	if(array_length(crate_wall)){
		var _wallExisting = instances_matching_ne(crate_wall, "id");
		
		 // Loot Taken:
		if(crate_loot != noone && !instance_exists(crate_loot)){
			if(array_equals(crate_wall, _wallExisting)){
				crate_loot = call(scr.instance_nearest_array, x, y, call(scr.instances_meeting_instance, self, instances_matching_gt([chestprop, RadChest, Mimic, SuperMimic], "id", crate_loot)));
			}
			if(!instance_exists(crate_loot)){
				call(scr.wall_clear, self);
				_wallExisting = [];
				
				 // Effects:
				repeat(15){
					call(scr.fx, x, y, 3, Dust);
				}
			}
		}
		
		 // Crate Smashed:
		if(!array_equals(crate_wall, _wallExisting)){
			crate_wall = _wallExisting;
			
			 // Sound:
			sound_play_hit(sndHammer, 0.3);
			if(!array_length(crate_wall)){
				sound_play_pitchvol(sndWallBreakJungle, 1.2 + orandom(0.2), 0.5);
			}
		}
	}
	
	
#define WepPickupGrounded_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		spr_shadow   = shd24;
		spr_shadow_x = 0;
		spr_shadow_y = -9;
		image_xscale = -1;
		image_yscale = choose(-1, 1);
		image_angle  = 90 + (random_range(10, 20) * choose(-1, 1));
		depth        = -1;
		
		 // Vars:
		mask_index = mskFlakBullet;
		target     = noone;
		target_x   = 0;
		target_y   = 0;
		top_object = noone;
		
		return self;
	}
	
#define WepPickupGrounded_end_step
	var _stuck = false;
	if(instance_exists(target)){
		_stuck = true;
		
		 // Portal Attraction:
		if(instance_exists(Portal)){
			with(Portal){
				if(point_distance(x, y, other.x, other.y) < 96){
					if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
						_stuck = false;
						break;
					}
				}
			}
		}
	}
	if(_stuck){
		 // Spin:
		if(instance_exists(top_object) && top_object.zfriction != 0){
			image_angle += 4 * target.rotspeed * current_time_scale;
		}
		
		 // Wobble:
		else if(target.x != target.xprevious || target.y != target.yprevious){
			image_angle += sin(current_frame * 0.7) * target.rotspeed * sign(image_yscale) * current_time_scale;
		}
		
		 // Determine Offset:
		var	_uvs = sprite_get_uvs(target.sprite_index, 0),
			_off = sprite_get_xoffset(target.sprite_index),
			_ang = image_angle,
			_xsc = image_xscale;
			
		if(_xsc < 0){
			_off = (sprite_get_bbox_right(target.sprite_index) + 1) - _off;
		}
		else{
			_off -= sprite_get_bbox_left(target.sprite_index);
		}
		_off *= abs(_xsc);
		
		target_x = lengthdir_x(_off, _ang);
		target_y = lengthdir_y(_off, _ang) + ((_ang > 180) ? -2 : 2);
		
		 // Hold:
		with(target){
			x           = other.x;
			y           = other.y - 8;
			xprevious   = x;
			yprevious   = y;
			speed       = 0;
			rotation    = _ang + (180 * (_xsc < 0));
			image_alpha = 0;
			
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
			_ang = image_angle,
			_col = image_blend,
			_alp = image_alpha,
			_x   = x + target_x,
			_y   = y + target_y;
			
		 // Draw Normal:
		if(instance_exists(top_object) && top_object.zfriction != 0){
			draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
		}
		
		 // Draw w/ End Clipped Off:
		else with(call(scr.surface_setup, "WepPickupGrounded", 64, 64, call(scr.option_get, "quality:main"))){
			x = other.x - (w / 2);
			y = other.y - h;
			
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			d3d_set_projection_ortho(x, y, w, h, 0);
			
			with(other){
				draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
			}
			
			d3d_set_projection_ortho(view_xview_nonsync, view_yview_nonsync, game_width, game_height, 0);
			surface_reset_target();
			
			call(scr.draw_surface_scale, surf, x, y, 1 / scale);
		}
	}
	
#define WepPickupGrounded_destroy
	with(target){
		x           = other.x + other.target_x;
		y           = other.y + other.target_y;
		rotation    = other.image_angle + (180 * (other.image_xscale < 0));
		image_alpha = 1;
		
		 // Fix:
		if("top_object" in self){
			with(top_object) instance_destroy();
		}
		
		 // Effects:
		repeat(3) call(scr.fx, [x, 4], [y, 4], random(1), Dust);
		call(scr.sound_play_at, x, y, sndWeaponPickup, 0.7, 0.8);
	}
	with(instance_create(x, y, WepSwap)){
		depth = other.depth - 1;
	}


#define WepPickupStick_create(_x, _y)
	with(instance_create(_x, _y, WepPickup)){
		 // Vars:
		mask_index   = mskShield;
		stick_target = noone;
		stick_x      = 0;
		stick_y      = 0;
		stick_damage = 0;
		
		return self;
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
			y -= abs(_t.z);
		}
		xprevious = x;
		yprevious = y;
		speed     = 0;
		visible   = (_t.visible || instance_is(_t, NothingIntroMask));
		
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
					 // Damage:
					if(instance_is(self, hitme)){
						var	_prop = (instance_is(self, prop) || instance_is(self, Nothing) || instance_is(self, Nothing2)),
							_dis  = 24;
							
						 // Effects:
						repeat(3){
							with(call(scr.fx, 
								_x + lengthdir_x(_dis, _ang),
								_y + lengthdir_y(_dis, _ang),
								(_prop ? 2.5  : 0),
								(_prop ? Dust : AllyDamage)
							)){
								depth = min(depth, other.depth - 1);
							}
						}
						
						 // Damage:
						projectile_hit_raw(self, _damage, 1);
					}
					
					 // Kick:
					with(call(scr.instance_nearest_array, _x, _y, call(scr.array_combine, instances_matching(Player, "wep", _wep), instances_matching(Player, "bwep", _wep)))){
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
#define ntte_setup_TopDecalScrapyard(_inst)
	 // Variant Car Decal:
	with(instances_matching(_inst, "image_index", 0)){
		if(chance(1, 2)){
			sprite_index = spr.TopDecalScrapyardAlt;
		}
	}
	
#define ntte_draw_shadows
	 // Saw Traps:
	if(array_length(obj.SawTrap)){
		with(instances_matching(instances_matching(obj.SawTrap, "visible", true), "spr_shadow", mskNone)){
			draw_sprite_ext(sprite_index, image_index, x + spr_shadow_x, y + spr_shadow_y, image_xscale * 0.9, image_yscale * 0.9, image_angle, image_blend, 1);
		}
	}
	
	 // Spinny Fire Trap:
	if(array_length(obj.TrapSpin)){
		with(instances_matching(obj.TrapSpin, "visible", true)){
			for(var i = 0; i < image_number; i++){
				draw_sprite_ext(sprite_index, i, x, y + i, image_xscale, image_yscale, image_angle, image_blend, 1);
			}
		}
	}
	
	 // Ghost:
	if(array_length(obj.Ghost)){
		with(instances_matching(obj.Ghost, "visible", true)){
			draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
		}
	}
	
#define ntte_draw_dark(_type)
	switch(_type){
		
		case "normal":
		case "end":
			
			var _gray = (_type == "normal");
			
			if(array_length(obj.Ghost)){
				with(instances_matching_ne(obj.Ghost, "id")){
					
					draw_primitive_begin(pr_trianglefan);
					draw_vertex(x, y);
					
					var n = dark_vertices,
						l = (48 + (64 * _gray)) * dark_scale + random(2);
					for(var i = 0; i <= 360; i += (360 / n)){
						var d = i + 90;
						draw_vertex(x + lengthdir_x(l, d), y + lengthdir_y(l, d));
					}
					
					draw_primitive_end();
				}
			}
			
			break;
			
	}
	
	
#define draw_sludge
	if(array_length(obj.SludgePool)){
		var _instSludge = instances_matching(obj.SludgePool, "visible", true);
		if(array_length(_instSludge)){
			if(lag) trace_time();
			
			var	_surfX     = view_xview_nonsync,
				_surfY     = view_yview_nonsync,
				_surfW     = game_width,
				_surfH     = game_height,
				_surfScale = call(scr.option_get, "quality:minor");
				
			if(_surfScale >= 2/3){
				with(call(scr.surface_setup, "SludgePool", _surfW, _surfH, _surfScale)){
					x = _surfX;
					y = _surfY;
					
					var	_surf      = surf,
						_inst      = call(scr.instances_seen_nonsync, [hitme, Corpse, chestprop, ChestOpen, Crown], 24, 24),
						_canShader = (shadSludgePool.shad != -1);
						
					if(_canShader){
						_inst = call(scr.array_combine, _inst, instances_matching(Pickup, "mask_index", mskPickup));
					}
					_inst = instances_matching(_inst, "visible", true);
					
					if(array_length(_inst)){
						with(_instSludge){
							var _instNear = call(scr.instances_meeting_rectangle, bbox_left - 8, bbox_top - 8, bbox_right + 8, bbox_bottom + 8, _inst);
							if(array_length(_instNear)){
								 // Grab Screen for Shader:
								if(_canShader){
									draw_set_blend_mode_ext(bm_one, bm_zero);
									surface_screenshot(_surf);
									draw_set_blend_mode(bm_normal);
								}
								
								 // Stuff in Sludge:
								surface_set_target(_surf);
								if(!_canShader){
									draw_clear_alpha(c_black, 0);
								}
								d3d_set_projection_ortho(_surfX, _surfY, _surfW, _surfH, 0);
									
									draw_set_fog(true, fx_color, 0, 0);
									with(_instNear){
										var	_spr = sprite_index,
											_img = image_index,
											_xsc = image_xscale * (("right" in self) ? right : 1),
											_ysc = image_yscale,
											_col = image_blend,
											_alp = image_alpha,
											_w   = sprite_get_width(_spr),
											_h   = max(1 / _surfScale,
												(_canShader && (instance_is(self, Corpse) || instance_is(self, Pickup) || instance_is(self, chestprop) || instance_is(self, prop)))
												? (sprite_get_bbox_bottom(_spr) + 1) - sprite_get_yoffset(_spr)
												: 1 + ((string_pos("Sit", sprite_get_name(_spr)) > 0) ? 3 : (_spr == sprRavenIdle || _spr == spr.BoneRavenIdle))
											),
											_l   = 0,
											_t   = sprite_get_bbox_bottom(_spr) + 1 - _h,
											_x   = x - (sprite_get_xoffset(_spr) * _xsc) + _l,
											_y   = y - (sprite_get_yoffset(_spr) * _ysc) + _t;
											
										draw_sprite_part_ext(_spr, _img, _l, _t, _w, _h, _x, _y, _xsc, _ysc, _col, _alp);
									}
									draw_set_fog(false, 0, 0, 0);
									
									 // Cut Out:
									draw_set_blend_mode_ext(bm_inv_src_alpha, bm_src_alpha);
									draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
									draw_set_blend_mode(bm_normal);
									
								d3d_set_projection_ortho(view_xview_nonsync, view_yview_nonsync, game_width, game_height, 0);
								surface_reset_target();
								
								 // Draw:
								call(scr.shader_setup, "SludgePool", surface_get_texture(_surf), [_surfW, _surfH, fx_color]);
								draw_surface_part_ext(_surf, (bbox_left - _surfX) * _surfScale, (bbox_top - _surfY) * _surfScale, bbox_width * _surfScale, bbox_height * _surfScale, bbox_left, bbox_top, 1 / _surfScale, 1 / _surfScale, c_white, 1);
								shader_reset();
							}
						}
					}
				}
			}
			
			if(lag) trace_time(script[2]);
		}
	}
	
#define draw_trapspin_top
	if(array_length(obj.TrapSpin)){
		if(lag) trace_time();
		
		with(instances_matching(obj.TrapSpin, "visible", true)){
			draw_sprite_ext(sprite_index, image_number - 1, x, y - (image_number - 1), image_xscale, image_yscale, image_angle, image_blend, abs(image_alpha));
		}
		
		if(lag) trace_time(script[2]);
	}
	
#define draw_bigpipe_top
	 // Big Pipe Tops:
	if(array_length(obj.BigPipe)){
		with(instances_matching(obj.BigPipe, "visible", true)){
			draw_sprite_ext(
				((sprite_index == spr_hurt) ? spr_top_hurt : spr_top_idle),
				image_index,
				x,
				y,
				image_xscale,
				image_yscale,
				image_angle,
				image_blend,
				image_alpha
			);
		}
	}
	
	
/// SCRIPTS
#macro  call                                                                                    script_ref_call
#macro  scr                                                                                     global.scr
#macro  obj                                                                                     global.obj
#macro  spr                                                                                     global.spr
#macro  snd                                                                                     global.snd
#macro  msk                                                                                     spr.msk
#macro  mus                                                                                     snd.mus
#macro  lag                                                                                     global.debug_lag
#macro  ntte                                                                                    global.ntte_vars
#macro  epsilon                                                                                 global.epsilon
#macro  mod_current_type                                                                        global.mod_type
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
#macro  instance_max                                                                            instance_create(0, 0, DramaCamera)
#macro  current_frame_active                                                                    ((current_frame + epsilon) % 1) < current_time_scale
#macro  game_scale_nonsync                                                                      game_screen_get_width_nonsync() / game_width
#macro  anim_end                                                                                (image_index + image_speed_raw >= image_number) || (image_index + image_speed_raw < 0)
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed == 0) ? spr_idle : spr_walk) : sprite_index
#macro  enemy_boss                                                                              ('boss' in self) ? boss : ('intro' in self || array_find_index([Nothing, Nothing2, BigFish, OasisBoss], object_index) >= 0)
#macro  player_active                                                                           visible && !instance_exists(GenCont) && !instance_exists(LevCont) && !instance_exists(SitDown) && !instance_exists(PlayerSit)
#macro  target_visible                                                                          !collision_line(x, y, target.x, target.y, Wall, false, false)
#macro  target_direction                                                                        point_direction(x, y, target.x, target.y)
#macro  target_distance                                                                         point_distance(x, y, target.x, target.y)
#macro  bbox_width                                                                              (bbox_right + 1) - bbox_left
#macro  bbox_height                                                                             (bbox_bottom + 1) - bbox_top
#macro  bbox_center_x                                                                           (bbox_left + bbox_right + 1) / 2
#macro  bbox_center_y                                                                           (bbox_top + bbox_bottom + 1) / 2
#macro  FloorNormal                                                                             instances_matching(Floor, 'object_index', Floor)
#macro  alarm0_run                                                                              alarm0 && !--alarm0 && !--alarm0 && (script_ref_call(on_alrm0) || !instance_exists(self))
#macro  alarm1_run                                                                              alarm1 && !--alarm1 && !--alarm1 && (script_ref_call(on_alrm1) || !instance_exists(self))
#macro  alarm2_run                                                                              alarm2 && !--alarm2 && !--alarm2 && (script_ref_call(on_alrm2) || !instance_exists(self))
#macro  alarm3_run                                                                              alarm3 && !--alarm3 && !--alarm3 && (script_ref_call(on_alrm3) || !instance_exists(self))
#macro  alarm4_run                                                                              alarm4 && !--alarm4 && !--alarm4 && (script_ref_call(on_alrm4) || !instance_exists(self))
#macro  alarm5_run                                                                              alarm5 && !--alarm5 && !--alarm5 && (script_ref_call(on_alrm5) || !instance_exists(self))
#macro  alarm6_run                                                                              alarm6 && !--alarm6 && !--alarm6 && (script_ref_call(on_alrm6) || !instance_exists(self))
#macro  alarm7_run                                                                              alarm7 && !--alarm7 && !--alarm7 && (script_ref_call(on_alrm7) || !instance_exists(self))
#macro  alarm8_run                                                                              alarm8 && !--alarm8 && !--alarm8 && (script_ref_call(on_alrm8) || !instance_exists(self))
#macro  alarm9_run                                                                              alarm9 && !--alarm9 && !--alarm9 && (script_ref_call(on_alrm9) || !instance_exists(self))
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < _numer * current_time_scale;
#define pround(_num, _precision)                                                        return  (_precision == 0) ? _num : round(_num / _precision) * _precision;
#define pfloor(_num, _precision)                                                        return  (_precision == 0) ? _num : floor(_num / _precision) * _precision;
#define pceil(_num, _precision)                                                         return  (_precision == 0) ? _num :  ceil(_num / _precision) * _precision;
#define frame_active(_interval)                                                         return  ((current_frame + epsilon) % _interval) < current_time_scale;
#define lerp_ct(_val1, _val2, _amount)                                                  return  lerp(_val2, _val1, power(1 - _amount, current_time_scale));
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define angle_lerp_ct(_ang1, _ang2, _num)                                               return  _ang2 + (angle_difference(_ang1, _ang2) * power(1 - _num, current_time_scale));
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define enemy_walk(_dir, _num)                                                                  direction = _dir; walk = _num; if(speed < friction_raw) speed = friction_raw;
#define enemy_face(_dir)                                                                        _dir = ((_dir % 360) + 360) % 360; if(_dir < 90 || _dir > 270) right = 1; else if(_dir > 90 && _dir < 270) right = -1;
#define enemy_look(_dir)                                                                        _dir = ((_dir % 360) + 360) % 360; if(_dir < 90 || _dir > 270) right = 1; else if(_dir > 90 && _dir < 270) right = -1; if('gunangle' in self) gunangle = _dir;
#define enemy_target(_x, _y)                                                                    target = (instance_exists(Player) ? instance_nearest(_x, _y, Player) : ((instance_exists(target) && target >= 0) ? target : noone)); return (target != noone);
#define script_bind(_scriptObj, _scriptRef, _depth, _visible)                           return  call(scr.script_bind, script_ref_create(script_bind), _scriptObj, (is_real(_scriptRef) ? script_ref_create(_scriptRef) : _scriptRef), _depth, _visible);