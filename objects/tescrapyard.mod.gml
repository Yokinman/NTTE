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
#macro opt sav.option

#macro DebugLag global.debug_lag

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)


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
		meleedamage = 4;
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
				_y = y + lengthdir_y(l, d) - random(2),
				_inv = side * -1;
			if(chance_ct(2, 3)){
				with(instance_create(_x, _y, BulletHit)){
					sprite_index = choose(sprGroundFlameDisappear, sprGroundFlameBigDisappear);
					image_angle = d + random_range(15, 60) * _inv;
					image_yscale = random_range(1, 1.5) * _inv;
					
					if(!place_meeting(x, y, Wall)) instance_destroy();
				}
			}
			if(chance_ct(1, 4)) scrFX([_x, 3], [_y, 3], [d + (random_range(45, 90) * _inv), random(2)], Sweat).image_blend = make_color_rgb(255, 222, 056);
		}
	}

	 // Sound:
	var _pit = (1 + (0.05 * sin(current_frame / 8))) * (spd / maxspeed),
		_vol = min(2, 80 / (distance_to_object(Player) + 1)) * (spd / maxspeed);

	if(active && !audio_is_playing(loop_snd)){
		loop_snd = audio_play_sound(snd.SawTrap, 0, false);
		audio_sound_set_track_position(loop_snd, random(audio_sound_length_nonsync(loop_snd)));
	}
	audio_sound_gain(loop_snd, _vol, 0);
	audio_sound_pitch(loop_snd, _pit);

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
						sound_play_pitchvol(snd_mele, 0.7 + random(0.2), 1);
					}
				}

				 // Epic FX:
				if(instance_is(self, other.object_index) && "name" in self && name == other.name){
					if(active && side != other.side){
						_sawtrapHit = true;
						if(!sawtrap_hit || chance_ct(1, 30)){
							sound_play_pitchvol(sndDiscBounce, 0.6 + random(0.2), _vol / 2);
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
		sound_play(sndExplosion);
		sound_play_pitch(snd_dead, 1 + orandom(0.2));

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
		walkspd = 0.8;
		maxspeed = 2.4;
		gunangle = random(360);
		direction = gunangle;
		tunneling = 0;
		tunnel_wall = noone;

         // Alarms:
		alarm1 = 20 + irandom(30);

		 // NTTE:
		ntte_anim = false;

		return id;
	}
	
#define Tunneler_step
    enemySprites();
     
    if(!tunneling) {
        enemyWalk(walkspd, maxspeed);
    }

#define Tunneler_end_step
    if(tunneling) {
        x = tunnel_wall.x + 8;
        y = tunnel_wall.y;
    }
    
#define Tunneler_alrm1
    alarm1 = 20 + irandom(10);
    target = instance_nearest(x, y, Player);
    
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
            var _targetDir = point_direction(x, y, target.x, target.y);
            
            if(in_sight(target) && chance(2, 3)) {
                scrEnemyShoot(EnemyBullet1, _targetDir, 6);
            }
            
            else {
                var _targetWall = instance_nearest(x, y, Wall);
                var _targetDist = point_distance(x, y, _targetWall.x + 8, _targetWall.y + 8);
                
                if(_targetDist < 8) {
                    alarm1 = 5 + random(5);
                    scrWalk(_targetDist/walkspd, point_direction(x, y, _targetWall.x, _targetWall.y) + orandom(5));
                }
                
                else {
                    Tunneler_tunnel(1, _targetWall);
                }
            }
        } 
        
        else {
            scrWalk(10 + random(10), random(360));
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
#define draw_shadows
	 // Saw Traps:
	with(instances_matching(CustomHitme, "name", "SawTrap")){
		draw_sprite_ext(sprite_index, image_index, x, y + 6, image_xscale * 0.9, image_yscale * 0.9, image_angle, image_blend, image_alpha);
	}


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
#define scrRadDrop(_x, _y, _raddrop, _dir, _spd)                                        return  mod_script_call(   "mod", "telib", "scrRadDrop", _x, _y, _raddrop, _dir, _spd);
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
#define path_create(_xstart, _ystart, _xtarget, _ytarget)                               return  mod_script_call(   "mod", "telib", "path_create", _xstart, _ystart, _xtarget, _ytarget);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call(   "mod", "telib", "race_get_sprite", _race, _sprite);
#define scrFloorMake(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "scrFloorMake", _x, _y, _obj);
#define scrFloorFill(_x, _y, _w, _h)                                                    return  mod_script_call(   "mod", "telib", "scrFloorFill", _x, _y, _w, _h);
#define scrFloorFillRound(_x, _y, _w, _h)                                               return  mod_script_call(   "mod", "telib", "scrFloorFillRound", _x, _y, _w, _h);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc("mod", "telib", "unlock_get", _unlock);
#define unlock_set(_unlock, _value)                                                             mod_script_call_nc("mod", "telib", "unlock_set", _unlock, _value);
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