#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.sav = mod_variable_get("mod", "teassets", "sav");

    global.debug_lag = false;

	 // floor_set():
	global.floor_style = null;
	global.floor_area = null;

	 // sleep_max():
	global.sleep_max = 0;
	
	 // Add an object to this list if you want it to appear in cheats mod spawn menu or if you want to specify create event arguments for it in global.objectScrt:
    global.objectList = {
		"tegeneral"	  : ["AlertIndicator", "AllyFlakBullet", "BigDecal", "BoneArrow", "BoneSlash", "BoneFX", "BuriedVault", "FlakBall", "Harpoon", "HarpoonStick", "Igloo", "NetNade", "ParrotFeather", "ParrotChester", "Pet", "PetWeaponBecome", "PetWeaponBoss", "PickupIndicator", "PortalBullet", "PortalGuardian", "PortalPrevent", "ReviveNTTE", "TeslaCoil", "TopObject", "VenomPellet"],
		"tepickups"   : ["Backpack", "Backpacker", "BackpackPickup", "BatChest", "BoneBigPickup", "BonePickup", "BuriedVaultChest", "BuriedVaultChestDebris", "BuriedVaultPedestal", "CatChest", "ChestShop", "CursedAmmoChest", "CursedMimic", "CustomChest", "CustomPickup", "HammerHeadPickup", "HarpoonPickup", "OverhealPickup", "OverstockPickup", "Pizza", "PizzaBoxCool", "SpiritPickup", "SunkenChest", "SunkenCoin", "VaultFlower", "VaultFlowerSparkle"],
		"tedesert"	  : ["BabyScorpion", "BabyScorpionGold", "BanditHiker", "BanditTent", "BigCactus", "BigMaggotSpawn", "Bone", "BoneSpawner", "CoastBossBecome", "CoastBoss", "FlySpin", "PetVenom", "ScorpionRock"],
		"tecoast"	  : ["BloomingAssassin", "BloomingAssassinHide", "BloomingBush", "BloomingCactus", "BuriedCar", "ClamShield", "ClamShieldSlash", "CoastBigDecal", "CoastDecal", "CoastDecalCorpse", "Creature", "Diver", "DiverHarpoon", "Gull", "Palanking", "PalankingDie", "PalankingSlash", "PalankingSlashGround", "PalankingToss", "Palm", "Pelican", "Seal", "SealAnchor", "SealHeavy", "SealMine", "TrafficCrab", "Trident"],
		"tewater"	  : ["Angler", "BubbleBomb", "BubbleExplosion", "BubbleExplosionSmall", "ClamChest", "Crack", "Eel", "EelSkull", "ElectroPlasma", "ElectroPlasmaImpact", "Hammerhead", "HyperBubble", "Jelly", "JellyElite", "Kelp", "LightningDisc", "LightningDiscEnemy", "OasisPetBecome", "PitSpark", "PitSquid", "PitSquidArm", "PitSquidBomb", "PitSquidDeath", "Puffer", "QuasarBeam", "QuasarRing", "TrenchFloorChunk", "Vent", "WantEel", "WantPitSquid", "WaterStreak", "YetiCrab"],
		"tesewers"	  : ["AlbinoBolt", "AlbinoGator", "AlbinoGrenade", "BabyGator", "Bat", "BatBoss", "BatCloud", "BatDisc", "BatScreech", "BoneGator", "BossHealFX", "Cabinet", "Cat", "CatBoss", "CatBossAttack", "CatDoor", "CatDoorDebris", "CatGrenade", "CatHole", "CatHoleBig", "CatLight", "ChairFront", "ChairSide", "Couch", "Manhole", "NewTable", "Paper", "PizzaDrain", "PizzaManholeCover", "PizzaRubble", "PizzaTV", "TurtleCool", "VenomFlak"],
		"tescrapyard" : ["BoneRaven", "NestRaven", "SawTrap", "SludgePool", "Tunneler"],
	    "tecaves"	  : ["CrystalHeart", "CrystalHeartProj", "InvMortar", "Mortar", "MortarPlasma", "NewCocoon", "RedCrystalProp", "RedSpider", "Spiderling", "SpiderWall"]
    };
    
	 // Auto Create Event Script References:
    global.objectScrt = {}
	for(var i = 0; i < lq_size(objList); i++){
		var _modName = lq_get_key(objList, i),
			_modObjs = lq_get_value(objList, i);

		with(_modObjs){
			var _name = self;
			lq_set(objScrt, _name, script_ref_create_ext("mod", _modName, _name + "_create"));
		}
	}

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav

#macro DebugLag global.debug_lag

#macro current_frame_active ((current_frame % 1) < current_time_scale)
#macro anim_end (image_index + image_speed_raw >= image_number)

#macro objList global.objectList
#macro objScrt global.objectScrt


#define obj_create(_x, _y, _name)
	if(is_real(_name) && object_exists(_name)){
		return instance_create(_x, _y, _name);
	}

	 // Search for Create Event if Unstored:
	if(!lq_exists(objScrt, _name) && is_string(_name)){
		for(var i = 0; i < lq_size(objList); i++){
			var _modName = lq_get_key(objList, i);
			if(mod_script_exists("mod", _modName, _name + "_create")){
				lq_set(objScrt, _name, script_ref_create_ext("mod", _modName, _name + "_create"));
			}
		}
	}

	 // Creating Object:
	if(lq_exists(objScrt, _name)){
		 // Call Create Event:
		var _scrt = array_combine(lq_get(objScrt, _name), [_x, _y]),
			_inst = script_ref_call(_scrt);

		if(is_undefined(_inst) || _inst == 0) _inst = noone;

	     /// Auto Assign Things:
	    if(is_real(_inst) && instance_exists(_inst)){
	        with(_inst){
	            name = _name;

				var _isCustom = (string_pos("Custom", object_get_name(_inst.object_index)) == 1),
					_events = [];

				if(_isCustom){
	            	var _isEnemy = instance_is(self, CustomEnemy);

		            switch(object_index){
		            	case CustomObject:
		            		_events = ["step", "begin_step", "end_step", "draw", "destroy", "cleanup"];
		            		break;

						case CustomHitme:
							_events = ["step", "begin_step", "end_step", "draw", "destroy", "hurt", "cleanup"];
							break;

						case CustomProp:
							_events = ["step", "death"];
							break;

		            	case CustomProjectile:
		            		_events = ["step", "begin_step", "end_step", "draw", "destroy", "cleanup", "hit", "wall", "anim"];
		            		break;

						case CustomSlash:
							_events = ["step", "begin_step", "end_step", "draw", "destroy", "cleanup", "hit", "wall", "anim", "grenade", "projectile"];
							break;

						case CustomEnemy:
							_events = ["step", "begin_step", "end_step", "draw", "destroy", "hurt", "death", "cleanup"];
							break;

		            	default:
		            		_events = ["step", "begin_step", "end_step", "draw", "destroy", "hurt", "death", "cleanup", "hit", "wall", "anim", "grenade", "projectile"];
		            }

		            _events = array_combine(_events, ["alrm0", "alrm1", "alrm2", "alrm3", "alrm4", "alrm5", "alrm6", "alrm7", "alrm8", "alrm9", "alrm10"]);
		            if(!_isEnemy) array_push(_events, "alrm11");
				}
				else _events = ["step", "begin_step", "end_step", "draw"];

	             // Scripts:
				var	_modType = _scrt[0],
					_modName = _scrt[1];

	            with(_events){
	                var v = (_isCustom ? "on_" + self : "ntte_bind_" + self);
	                if(v not in other || is_undefined(variable_instance_get(other, v))){
	                    var _modScrt = _name + "_" + self;

                        if(mod_script_exists(_modType, _modName, _modScrt)){
                        	 // Normal Event Set:
                            if(_isCustom){
                            	variable_instance_set(other, v, [_modType, _modName, _modScrt]);
                            }

                             // Auto Script Binding:
                            else{
                            	var s = variable_instance_get(other, "on_" + self, null);
                            	if(array_length(s) < 3 || !mod_script_exists(s[0], s[1], s[2])){
	                            	var _bind = instances_matching(CustomScript, "name", "NTTEBind_" + self);
	                            	if(array_length(_bind) <= 0 || self == "draw"){
	                            		switch(self){
		                            		case "step":		_bind = script_bind_step(ntte_bind, 0);			break;
		                            		case "begin_step":	_bind = script_bind_begin_step(ntte_bind, 0);	break;
		                            		case "end_step":	_bind = script_bind_end_step(ntte_bind, 0);		break;
		                            		case "draw":		_bind = script_bind_draw(ntte_bind, 0);			break;
		                            	}
		                            	if(instance_exists(_bind)){
		                            		with(_bind){
		                            			name = "NTTEBind_" + other;
			                            		inst_list = [];
		                            			persistent = true;
		                            		}
		                            		variable_instance_set(other, v, _bind);
		                            	}
	                            	}
	                            	with(_bind){
	                            		array_push(inst_list, { "inst" : _inst, "script" : [_modType, _modName, _modScrt] });
	                            	}
                            	}
                            }
                        }

	                     // Defaults:
	                    else if(_isCustom) with(other){
	                        switch(v){
								/*
								case "on_step":
									if(_isEnemy){
										on_step = enemy_step_ntte;
									}
									break;
								*/

	                            case "on_hurt":
	                                on_hurt = enemy_hurt;
	                                break;

	                            case "on_death":
	                                if(_isEnemy){
	                                    on_death = enemy_death;
	                                }
	                                break;

	                            case "on_draw":
	                                if(_isEnemy){
	                                    on_draw = draw_self_enemy;
	                                }
	                                break;
	                        }
	                    }
	                }
	            }

				if(_isCustom){
					on_create = script_ref_create_ext("mod", mod_current, "obj_create", _x, _y, _name);

	                 // Override Events:
	                var _override = ["step", "draw"];
	                with(_override){
	                    var v = "on_" + self;
	                    if(v in other){
	                        var e = variable_instance_get(other, v),
	                            _objScrt = script_ref_create(script_get_index("obj_" + self));

	                        if(!is_array(e) || !array_equals(e, _objScrt)){
	                            with(other){
	                                variable_instance_set(id, "on_ntte_" + other, e);

	                                 // Override Specifics:
	                                switch(v){
	                                    case "on_step":
	                                         // Setup Custom NTTE Event Vars:
	                                        if("ntte_anim" not in self){
	                                        	ntte_anim = _isEnemy;
	                                        }
	                                        if("ntte_walk" not in self){
	                                        	ntte_walk = ("walk" in self);
	                                        }
	                                        if(ntte_anim){
	                                        	if("spr_chrg" not in self) spr_chrg = -1;
	                                        }
                                        	if(ntte_walk){
                                        		if("walkspeed" not in self) walkspeed = 0.8;
                                        		if("maxspeed" not in self) maxspeed = 3;
                                        	}
	                                        ntte_alarm_max = 0;
	                                        for(var i = 0; i <= 10; i++){
	                                            var a = `on_alrm${i}`;
	                                            if(a in self && variable_instance_get(id, a) != null){
	                                                ntte_alarm_max = i + 1;
	                                                if("ntte_alarm_min" not in self){
	                                                	ntte_alarm_min = i;
	                                                }
	                                            }
	                                        }
                                            if("ntte_alarm_min" not in self){
                                            	ntte_alarm_min = 0;
                                            }
	                                        /*var _set = ["anim"];
	                                        with(_set){
	                                            var n = "on_ntte_" + self;
	                                            if(n not in other){
	                                                variable_instance_set(other, n, null);
	                                            }
	                                        }*/

	                                         // Set on_step to obj_step only if needed:
	                                        if(ntte_anim || ntte_walk || ntte_alarm_max > 0 || (DebugLag && array_length(on_step) >= 3)){
	                                        	on_step = _objScrt;
	                                        }
	                                        break;

	                                    case "on_draw":
	                                    	if(DebugLag && array_length(on_draw) >= 3){
	                                        	on_draw = _objScrt;
	                                        }
	                                    	break;

	                                    default:
	                                        variable_instance_set(id, v, []);
	                                }
	                            }
	                        }
	                    }
	                }

	                 // Auto-fill HP:
	                if(instance_is(self, CustomHitme) || instance_is(self, CustomProp)){
	                    if(my_health == 1) my_health = maxhealth;
	                }

	                 // Auto-spr_idle:
	                if(sprite_index == -1 && "spr_idle" in self && instance_is(self, hitme)){
	                    sprite_index = spr_idle;
	                }
				}
	        }
	    }

		return _inst;
	}

	 // Return List of Objects:
	else if(is_undefined(_name)){
		var _list = [];
		for(var i = 0; i < lq_size(objList); i++){
			_list = array_combine(_list, lq_get_value(objList, i));
		}
		return _list;
	}

	return noone;

#define obj_step
	if(DebugLag){
    	//trace_lag_bgn("Objects");
    	trace_lag_bgn(name);
    }

	 // Animate:
	if(ntte_anim){
		if(sprite_index != spr_chrg){
		    if(sprite_index != spr_hurt || anim_end){
		        sprite_index = ((speed <= 0) ? spr_idle : spr_walk);
		    }
		}
	}

	 // Movement:
	if(ntte_walk){
		if(walk > 0){
	        motion_add(direction, walkspeed);
	        walk -= current_time_scale;
	    }
	    if(speed > maxspeed) speed = maxspeed; // Max Speed
	}

     // Step:
    script_ref_call(on_ntte_step);
    if("ntte_alarm_max" not in self) exit;

     // Alarms:
	var r = (ntte_alarm_max - ntte_alarm_min);
    if(r > 0){
	    var i = ntte_alarm_min;
	    repeat(r){ // repeat() is very slightly faster than a for loop here i think- big optimizations
	        var a = alarm_get(i);
	        if(a > 0){
	             // Decrement Alarm:
	            a -= ceil(current_time_scale);
	            alarm_set(i, a);

	             // Call Alarm Event:
	    		if(a <= 0){
	    		    alarm_set(i, -1);
	    		    script_ref_call(variable_instance_get(self, "on_alrm" + string(i)));
	    			if("ntte_alarm_max" not in self) exit;
	    		}
	        }
	        i++;
	    }
	}

    if(DebugLag){
	    //trace_lag_end("Objects");
	    trace_lag_end(name);
    }

#define obj_draw // Only used for debugging lag
	if(DebugLag) trace_lag_bgn(name + "_draw");

    script_ref_call(on_ntte_draw);

	if(DebugLag) trace_lag_end(name + "_draw");

#define ntte_bind
	if(array_length(inst_list) > 0){
		if(DebugLag) trace_time();

		with(inst_list){
			if(instance_exists(inst)){
				if(other.object_index == CustomDraw && other.depth != inst.depth - 1){
					other.depth = inst.depth - 1;
				}

				 // Call Bound Script:
				var s = script;
				with(inst) mod_script_call(s[0], s[1], s[2]);
			}
			else other.inst_list = array_delete_value(other.inst_list, self);
		}

		if(DebugLag) trace_time(name);
	}
	else instance_destroy();

#define step
	if(DebugLag) script_bind_end_step(end_step_trace_lag, 0);

     // sleep_max():
    if(global.sleep_max > 0){
	    sleep(global.sleep_max);
	    global.sleep_max = 0;
    }

#define end_step_trace_lag
    trace("");
	trace("Frame", current_frame, "Lag:")
    trace_lag();
	instance_destroy();

#define draw_dark // Drawing Grays
    draw_set_color(c_gray);

	 // Portal Disappearing Visual:
	with(instances_matching(BulletHit, "name", "PortalPoof")){
		draw_circle(x, y, 120 + random(6), false);
	}

#define draw_dark_end // Drawing Clear
    draw_set_color(c_black);

	 // Portal Disappearing Visual:
	with(instances_matching(BulletHit, "name", "PortalPoof")){
		draw_circle(x, y, 20 + random(8), false);
	}


/// Scripts
#define draw_self_enemy()
	image_xscale *= right;
	draw_self(); // This is faster than draw_sprite_ext yea
	image_xscale /= right;

#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)
	draw_sprite_ext(_sprite, 0, _x - lengthdir_x(_wkick, _ang), _y - lengthdir_y(_wkick, _ang), 1, _flip, _ang + (_meleeAng * (1 - (_wkick / 20))), _blend, _alpha);

#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)
    var _sx = _x,
        _sy = _y,
        _lx = _sx,
        _ly = _ly,
        _md = _maxDistance,
        d = _md,
        m = 0; // Minor hitscan increment distance

    while(d > 0){
         // Major Hitscan Mode (Start at max, go back until no collision line):
        if(m <= 0){
            _lx = _sx + lengthdir_x(d, _dir);
            _ly = _sy + lengthdir_y(d, _dir);
            d -= sqrt(_md);

             // Enter minor hitscan mode:
            if(!collision_line(_sx, _sy, _lx, _ly, Wall, false, false)){
                m = 2;
                d = sqrt(_md);
            }
        }

         // Minor Hitscan Mode (Move until collision):
        else{
            if(position_meeting(_lx, _ly, Wall)) break;
            _lx += lengthdir_x(m, _dir);
            _ly += lengthdir_y(m, _dir);
            d -= m;
        }
    }

    draw_line_width(_sx, _sy, _lx, _ly, _width);

    return [_lx, _ly];

#define draw_text_bn(_x, _y, _string, _angle)
	var _col = draw_get_color();
	_string = string_upper(_string);

	draw_set_color(c_black);
	draw_text_transformed(_x + 1, _y,     _string, 1, 1, _angle);
	draw_text_transformed(_x,     _y + 2, _string, 1, 1, _angle);
	draw_text_transformed(_x + 1, _y + 2, _string, 1, 1, _angle);
	draw_set_color(_col);
	draw_text_transformed(_x,     _y,     _string, 1, 1, _angle);

#define scrWalk(_dir, _walk)
    walk = (is_array(_walk) ? random_range(_walk[0], _walk[1]) : _walk);
    speed = max(speed, friction);
    direction = _dir;
    if("gunangle" not in self) scrRight(direction);
    
#define scrRight(_dir)
    _dir = ((_dir % 360) + 360) % 360;
    if(_dir < 90 || _dir > 270) right = 1;
    if(_dir > 90 && _dir < 270) right = -1;
    
#define scrAim(_dir)
    if("gunangle" in self){
    	gunangle = (_dir % 360);
    	if(gunangle < 0) gunangle += 360;
    }
    scrRight(_dir);
    
#define enemy_shoot(_object, _dir, _spd)
    return enemy_shoot_ext(x, y, _object, _dir, _spd);

#define enemy_shoot_ext(_x, _y, _object, _dir, _spd)
    var _inst = noone;
    
    if(is_string(_object)) _inst = obj_create(_x, _y, _object);
    else _inst = instance_create(_x, _y, _object);
    with(_inst){
        if(_spd <= 0) direction = _dir;
        else motion_add(_dir, _spd);
        image_angle = _dir;
        if("hitid" in other) hitid = other.hitid;
        team = other.team;
        
		 // Auto-Creator:
		creator = other;
		while("creator" in creator && !instance_is(creator, hitme)){
			creator = creator.creator;
		}
		
         // Euphoria:
        var e = skill_get(mut_euphoria);
        if(e != 0 && object_index == CustomProjectile){
            speed *= (0.8 / e);
        }
    }
    
    return _inst;

#define enemy_walk(_spdAdd, _spdMax)
	if(walk > 0){
		motion_add(direction, _spdAdd);
		walk -= current_time_scale;
	}
	if(speed > _spdMax) speed = _spdMax;

#define enemy_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    motion_add(_hitdir, _hitvel);	// Knockback
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);	// Sound

     // Hurt Sprite:
    sprite_index = spr_hurt;
    image_index = 0;

#define enemy_death
    pickup_drop(16, 0); // Bandit drop-ness

#define enemy_target(_x, _y)
	// Base game targeting
	if(!instance_exists(target)){
		target = -1;
	}
	if(instance_exists(Player)){
	    target = instance_nearest(_x, _y, Player);
	}
	return (target > 0 && instance_exists(target));
	// Just doing this for consistency with base game, with consistency you can have clever solutions

#define chance(_numer, _denom)
	return random(_denom) < _numer;

#define chance_ct(_numer, _denom)
	return random(_denom) < (_numer * current_time_scale);

#define in_distance(_inst, _dis)
	if(!instance_exists(_inst)) return false;

	 // If '_inst' is an object, find nearest object:
	if(object_exists(_inst)){
		_inst = instance_nearest(x, y, _inst);
	}

	 // If '_dis' is an array it means [min, max], otherwise 'min = 0' and 'max = _dis':
	if(!is_array(_dis)) _dis = [0, _dis];
	else while(array_length(_dis) < 2){
		array_push(_dis, 0);
	}

	 // Return if '_inst' is within min and max distances:
	var d = point_distance(x, y, _inst.x, _inst.y);
	return (d >= _dis[0] && d <= _dis[1]);

#define in_sight(_inst)
	if(!instance_exists(_inst)) return false;

	 // If '_inst' is an object, find nearest object:
	if(object_exists(_inst)){
		_inst = instance_nearest(x, y, _inst);
	}

	 // Return if '_inst' is in line of sight:
	return !collision_line(x, y, _inst.x, _inst.y, Wall, false, false);

#define shadlist_setup(_shader, _texture, _args)
	if(is_string(_shader)){
		_shader = mod_script_call_nc('mod', 'teassets', 'shadlist_get', _shader);
	}
	if(lq_defget(_shader, "shad", -1) != -1){
		shader_set_vertex_constant_f(0, matrix_multiply(matrix_multiply(matrix_get(matrix_world), matrix_get(matrix_view)), matrix_get(matrix_projection)));
		
		switch(lq_get(_shader, "name")){
			case "Charm":
				var	_w = _args[0],
					_h = _args[1];
					
				shader_set_fragment_constant_f(0, [1 / _w, 1 / _h]);
				break;
				
			case "SludgePool":
				var	_w = _args[0],
					_h = _args[1],
					_color = _args[2];
					
				shader_set_fragment_constant_f(0, [1 / _w, 1 / _h]);
				shader_set_fragment_constant_f(1, [color_get_red(_color) / 255, color_get_green(_color) / 255, color_get_blue(_color) / 255]);
				break;
		}
		
		shader_set(_shader.shad);
		texture_set_stage(0, _texture);
		
		return true;
	}
	return false;
	
#define option_get(_name, _default)
	var q = lq_defget(sav, "option", {});
	return lq_defget(q, _name, _default);

#define option_set(_name, _value)
	if(!lq_exists(sav, "option")) sav.option = {};
	lq_set(sav.option, _name, _value);

#define unlock_get(_name)
    var q = lq_defget(sav, "unlock", {});
    return lq_defget(q, _name, false);

#define unlock_set(_name, _value)
    if(!lq_exists(sav, "unlock")) sav.unlock = {};
    lq_set(sav.unlock, _name, _value);

#define unlock_get_name(_name)
	 // Crown Unlock:
	if(string_pos("crown", _name) == 1){
		return string_upper(crown_get_name(string_lower(string_delete(_name, 1, 5)))) + "@s";
	}
	
	 // General Unlock:
	switch(_name){
		case "coastWep":	return "BEACH GUNS";
		case "oasisWep":	return "BUBBLE GUNS";
		case "trenchWep":	return "TECH GUNS";
		case "lairWep":		return "SAWBLADE GUNS";
		case "lairCrown":	return crown_get_name("crime");
		case "boneScythe":	return weapon_get_name("scythe");
	}
	
	 // Default (Split Name by Capitalization):
	var _split = [];
	for(var i = 1; i <= string_length(_name); i++){
		var c = string_char_at(_name, i);
		if(i == 1 || string_lower(c) != c) array_push(_split, "");
		_split[array_length(_split) - 1] += string_upper(c);
	}
	return array_join(_split, " ");
	
#define unlock_get_text(_name)
	 // Crown Unlock:
	if(string_pos("crown", _name) == 1){
		return "FOR @wEVERYONE";
	}
	
	 // General Unlock:
	switch(_name){
		case "parrot":		return "FOR REACHING COAST";
		case "parrotB":		return "FOR BEATING THE AQUATIC ROUTE";
		case "bee":			return "???";
		case "beeB":		return "???";
		case "coastWep":	return "GRAB YOUR FRIENDS";
		case "oasisWep":	return "SOAP AND WATER";
		case "trenchWep":	return "TERRORS FROM THE DEEP";
		case "lairWep":		return "DEVICES OF TORTURE";
		case "lairCrown":	return "STOLEN FROM THIEVES";
		case "boneScythe":	return "A PACKAGE DEAL";
	}
	
	return "";

#define unlock_call(_name)
	if(!unlock_get(_name)){
		unlock_set(_name, true);
		
		 // General Unlocks:
		var _type = {
			"race" : ["parrot", "bee"],
			"skin" : ["parrotB", "beeB"],
			"pack" : ["coastWep", "oasisWep", "trenchWep", "lairWep", "lairCrown"],
			"misc" : ["crownCrime", "boneScythe"]
		};
		for(var i = 0; i < array_length(_type); i++){
			var	_packName = lq_get_key(_type, i),
				_pack = lq_get_value(_type, i);
				
			if(array_exists(_pack, _name)){
				var	_unlockName = unlock_get_name(_name),
					_unlockText = unlock_get_text(_name);
					
				switch(_packName){
					case "race":
						unlock_splat(
							_unlockName,
							_unlockText,
							mod_script_call("race", _name, "race_portrait", 0, 0),
							mod_script_call("race", _name, "race_menu_confirm")
						);
						sound_play_pitchvol(sndGoldUnlock, 0.9, 0.9);
						break;
						
					case "skin":
						var	_race = string_copy(_name, 1, string_length(_name) - 1),
							_skin = ord(string_char_at(_name, string_length(_name))) - 65;
							
						with(unlock_splat(
							_unlockName,
							_unlockText,
							mod_script_call("race", _race, "race_portrait", 0, _skin),
							mod_script_call("race", _race, "race_menu_confirm")
						)){
							nam[0] += "-SKIN";
						}
						sound_play(sndMenuBSkin);
						break;
						
					case "pack":
						unlock_splat(_unlockName, _unlockText, -1, -1);
						sound_play(sndGoldUnlock);
						break;
						
					default:
						unlock_splat(_unlockName, _unlockText, -1, -1);
				}
			}
		}
		
		return unlock_get(_name);
	}
	return false;

#define stat_get(_name)
	if(!is_array(_name)) _name = string_split(_name, "/");

	var q = lq_defget(sav, "stat", {});
	with(_name) q = lq_defget(q, self, 0);

	return q;

#define stat_set(_name, _value)
	if(!is_array(_name)) _name = string_split(_name, "/");

	if("stat" not in sav) sav.stat = {};

	var q = sav.stat,
		m = array_length(_name) - 1;

	with(array_slice(_name, 0, m)){
		if(self not in q) lq_set(q, self, {});
		q = lq_get(q, self);
	}
	lq_set(q, _name[m], _value);

#define scrPickupIndicator(_text)
	with(obj_create(x, y, "PickupIndicator")){
		text = _text;
		creator = other;
		depth = other.depth;
		return id;
	}
	return noone;
	
#define scrAlert(_sprite, _inst)
	 // Group:
	if((is_real(_inst) && object_exists(_inst)) || is_array(_inst)){
		var a = [];
		with(_inst) array_push(a, scrAlert(_sprite, self));
		return a;
	}
	
	 // Normal:
	else{
		var	_x = 0,
			_y = 0;
			
		if(instance_exists(_inst)){
			_x = _inst.x;
			_y = _inst.y;
		}
		else{
			if("x" in self) _x = x;
			if("y" in self) _y = y;
		}
		
		with(obj_create(_x, _y, "AlertIndicator")){
			sprite_index = _sprite;
			target = _inst;
			
			 // Auto-Offset:
			if(instance_exists(target)){
				var	_h1 = abs((sprite_get_yoffset(target.sprite_index) - sprite_get_bbox_top(target.sprite_index)) * image_yscale),
					_h2 = abs(((sprite_get_bbox_bottom(sprite_index) + 1) - sprite_get_yoffset(sprite_index)) * image_yscale);
					
				target_y = -(1 + _h1 + _h2);
				alert_x = (sprite_get_bbox_left(sprite_index) - sprite_get_xoffset(sprite_index));
			}
			
			return id;
		}
	}
	
	return noone;

#define charm_instance(_instance, _charm)
    var c = {
            "instance"	: _instance,
            "charmed"	: false,
            "target"	: noone,
            "on_step"	: [],		// Custom object step event
            "index"		: -1,		// Player who charmed
            "team"		: -1,		// Original team before charming
            "time"		: 0,		// Charm duration in frames
            "time_speed": 1,		// Charm duration decrement speed
            "walk"		: 0,		// For overwriting movement on certain dudes (Assassin, big dog)
            "boss"		: false,	// Instance is a boss
            "kill"		: false 	// Kill when uncharmed (For dudes who were spawned by charmed dudes)
        },
        _charmListRaw = mod_variable_get("race", "parrot", "charm");

    with(_instance){
        if("ntte_charm" not in self) ntte_charm = c;
        c = ntte_charm;

        if(!_charm != !c.charmed){
             // Charm:
            if(_charm){
            	 // Frienderize Team:
                if("team" in self){
                    c.team = team;
                    team = 2;

                     // Teamerize Nearby Projectiles:
        			with(instances_matching(instances_matching(projectile, "creator", id), "team", c.team)){
        				if(place_meeting(x, y, other)){
        					team = other.team;
                			charm_allyize(true);
        				}
        			}
                }
                
                 // Custom (Override Step Event):
                if(string_pos("Custom", object_get_name(object_index)) == 1){
                	c.on_step = on_step;
                	on_step = [];
                }
                
                 // Normal (Delay Alarms):
                else for(var i = 0; i <= 10; i++){
                	if(alarm_get(i) > 0){
                		alarm_set(i, alarm_get(i) + ceil(current_time_scale));
                	}
                }

				 // Boss Check:
				c.boss = (("boss" in self && boss) || array_exists([BanditBoss, ScrapBoss, LilHunter, Nothing, Nothing2, FrogQueen, HyperCrystal, TechnoMancer, Last, BigFish, OasisBoss], object_index));

				 // Charm Duration Speed:
				c.time_speed = (c.boss ? 2 : 1);

                 // Necromancer Charm:
                switch(sprite_index){
                	case sprReviveArea:
                		sprite_index = spr.AllyReviveArea;
                		break;

					case sprNecroReviveArea:
						sprite_index = spr.AllyNecroReviveArea;
						break;
                }

                ds_list_add(_charmListRaw, c);
            }

             // Uncharm:
            else{
            	target = noone;
                c.time = 0;
                c.index = -1;

                 // I-Frames:
                if("nexthurt" in self){
                	nexthurt = current_frame + 12;
                }

                 // Delay Contact Damage:
                if("canmelee" in self && canmelee){
                    alarm11 = 30;
                    canmelee = false;
                }

				 // Reset Team:
                if(c.team != -1){
                	if(fork()){
                		while("team" not in self && instance_is(self, becomenemy)){
                			wait 0;
                		}
                		if("team" in self){
                    		 // Teamerize Nearby Projectiles:
                			with(instances_matching(instances_matching(projectile, "creator", id), "team", team)){
                				if(place_meeting(x, y, other)){
                					team = c.team;
                					charm_allyize(false);
                				}
                			}

		                	team = c.team;
		                	c.team = -1;
                		}
                		exit;
                	}
                }
                
                 // Reset Step:
                if(array_length(c.on_step) > 0){
                	on_step = c.on_step;
                	c.on_step = [];
                }

                 // Kill:
                if(c.kill){
                	my_health = 0;
                	sound_play_pitchvol(sndEnemyDie, 2 + orandom(0.3), 3);
                }

                 // Effects:
                else instance_create(x, bbox_top, AssassinNotice);
                sound_play_pitchvol(sndAssassinGetUp, random_range(1.2, 1.5), 0.5);
                var _num = (max((("size" in self) ? size : 0), 0.5) * 10);
                for(var a = direction; a < direction + 360; a += (360 / _num)){
                    with(instance_create(x, y, Dust)) motion_add(a, 3);
                }
            }
        }
        c.charmed = _charm;
    }
    if(!_charm && ds_list_valid(_charmListRaw)){
        var _charmList = ds_list_to_array(_charmListRaw);
        with(_charmList){
            if(instance == _instance){
                ds_list_remove(_charmListRaw, self);
                break;
            }
        }
    }
    return c;

#define charm_allyize(_bool)
	var _inst = noone;
	
	/*
		[[EnemyBullet4, spr.EnemyBullet0], Bullet1],
		[EnemyBullet1,                     AllyBullet],
		[EnemyBullet3,                     Bullet2],
		[EnemyBullet4,                     [AllyBullet, spr.AllyBullet4]],
		[EFlakBullet,                      ["AllyFlakBullet", sprFlakBullet]],
		[LHBouncer,                        BouncerBullet],
		[EnemyLaser,                       Laser],
		[EnemyLightning,                   Lightning]
	*/
	
	
	 // Become Allied:
	if(_bool){
		switch(sprite_index){
			case sprEnemyBullet1:
				if(instance_is(self, EnemyBullet1)){
	    			_inst = instance_create(x, y, AllyBullet);
				}
	    		sprite_index = sprAllyBullet;
				break;

			case sprEBullet3:
				if(instance_is(self, EnemyBullet3)){
	    			_inst = instance_create(x, y, Bullet2);
	    			with(_inst) bonus = false;
				}
	    		sprite_index = sprBullet2;
				break;

			case sprEnemyBullet4:
				if(instance_is(self, EnemyBullet4)){
	    			_inst = instance_create(x, y, AllyBullet);
				}
	    		sprite_index = spr.AllyBullet4;
				break;

			case sprLHBouncer:
				if(instance_is(self, LHBouncer)){
	    			_inst = instance_create(x, y, BouncerBullet);
				}
	    		sprite_index = sprBouncerBullet;
				break;

			case sprEFlak:
				if(instance_is(self, EFlakBullet)){
					_inst = obj_create(x, y, "AllyFlakBullet");
				}
				sprite_index = sprFlakBullet;
				break;

			case sprEnemyLaser:
				if(!instance_is(self, EnemyLaser)){
					sprite_index = sprLaser;
				}
				break;

			case sprEnemyLightning:
				sprite_index = sprLightning;
				break;
		}
	}

	 // Become Enemied:
	else{
		switch(sprite_index){
			case sprAllyBullet:
				if(instance_is(self, AllyBullet)){
	    			_inst = instance_create(x, y, EnemyBullet1);
				}
	    		sprite_index = sprEnemyBullet1;
				break;

			case sprBullet2:
				if(instance_is(self, Bullet2)){
	    			_inst = instance_create(x, y, EnemyBullet3);
	    			with(_inst) bonus = false;
				}
	    		sprite_index = sprEBullet3;
				break;

			case sprBouncerBullet:
				if(instance_is(self, BouncerBullet)){
	    			_inst = instance_create(x, y, LHBouncer);
				}
	    		sprite_index = sprLHBouncer;
				break;

			case sprLaser:
				if(!instance_is(self, EnemyLaser)){
					sprite_index = sprEnemyLaser;
				}
				break;

			case sprLightning:
				sprite_index = sprEnemyLightning;
				break;

			default:
				if(sprite_index == spr.AllyBullet4){
					if(instance_is(self, AllyBullet)){
	    				_inst = instance_create(x, y, EnemyBullet4);
					}
		    		sprite_index = sprEnemyBullet4;
				}

				else if(sprite_index == sprFlakBullet){
					if(instance_is(self, CustomProjectile) && "name" in self && name == "AllyFlakBullet"){
						sprite_index = sprEFlak;
					}
				}
		}
	}
	
	 // Better than instance_change:
	if(instance_exists(_inst) && instance_exists(self)){
		with(variable_instance_get_names(id)){
			if(!variable_is_read_only(other, self)){
				variable_instance_set(_inst, self, variable_instance_get(other, self));
			}
		}
		instance_delete(id);
	}
	
	return _inst;

#define boss_hp(_hp)
    var n = 0;
    for(var i = 0; i < maxp; i++) n += player_is_active(i);
    return round(_hp * (1 + ((1/3) * GameCont.loops)) * (1 + (0.5 * (n - 1))));

#define boss_intro(_name, _sound, _music)
	var	s = sound_play(_sound),
    	m = sound_play_ntte("mus", _music);
    	
    with(MusCont) alarm_set(3, -1);
    
	 // Bind begin_step to fix TopCont.darkness flash
    if(_name != ""){
    	var _bind = instance_create(0, 0, CustomBeginStep);
		with(_bind){
			boss = _name;
			replaced = false;
			sound = s;
			music = m;
			delay = 0;
			loops = 0;
			for(var i = 0; i < maxp; i++){
				delay += player_is_active(i);
			}
		}
		
		 // wait hold on:
		if(fork()){
			wait 0;
			with(_bind) script = script_ref_create(boss_intro_step);
			exit;
		}
		
		return _bind;
	}
    
    return noone;

#define boss_intro_step
	 // Delay in Co-op:
	if(delay > 0){
		delay -= current_time_scale;
		
		var _option = option_get("intros", 2),
			_introLast = UberCont.opt_bossintros;

		if(_option < 2) UberCont.opt_bossintros = !!_option;

		if(UberCont.opt_bossintros == true && GameCont.loops <= loops){
			 // Replace Big Bandit's Intro:
			if(!replaced){
				replaced = true;
				var _path = "sprites/intros/";
		        sprite_replace_image(sprBossIntro,          _path + "spr" + boss + "Main.png", 0);
		        sprite_replace_image(sprBossIntroBackLayer, _path + "spr" + boss + "Back.png", 0);
		        sprite_replace_image(sprBossName,           _path + "spr" + boss + "Name.png", 0);
			}

			 // Call Big Bandit's Intro:
			if(delay <= 0){
		    	var	_lastSub = GameCont.subarea,
		    		_lastLoop = GameCont.loops;
		    		
		    	GameCont.loops = 0;
		    	
	        	with(instance_create(0, 0, BanditBoss)){
		            event_perform(ev_alarm, 6);
		            sound_stop(sndBigBanditIntro);
	            	instance_delete(id);
	            }
	            
	            GameCont.subarea = _lastSub;
	            GameCont.loops = _lastLoop;
			}
		}
		
		UberCont.opt_bossintros = _introLast;
	}

	 // End:
	else{
		if(replaced){
            sprite_restore(sprBossIntro);
            sprite_restore(sprBossIntroBackLayer);
            sprite_restore(sprBossName);
		}
		instance_destroy();
	}

#define unlock_splat(_name, _text, _sprite, _sound)
     // Make Sure UnlockCont Exists:
    if(array_length(instances_matching(CustomObject, "name", "UnlockCont")) <= 0){
    	obj_create(0, 0, "UnlockCont");
    }

     // Add New Unlock:
    var _unlock = {
        "nam" : [_name, _name], // [splash popup, gameover popup]
        "txt" : _text,
        "spr" : _sprite,
        "img" : 0,
        "snd" : _sound
	};

    with(instances_matching(CustomObject, "name", "UnlockCont")){
        if(splash_index >= array_length(unlock) - 1 && splash_timer <= 0){
        	splash_delay = 40;
        }
        array_push(unlock, _unlock);
    }

    return _unlock;
    
#define TopDecal_create(_x, _y, _area)
    _area = string(_area);
    
    var _topDecal = {
        "0"     : TopDecalNightDesert,
        "1"     : TopDecalDesert,
        "2"     : TopDecalSewers,
        "3"     : TopDecalScrapyard,
        "4"     : TopDecalCave,
        "5"     : TopDecalCity,
        "7"     : TopDecalPalace,
        "102"   : TopDecalPizzaSewers,
        "104"   : TopDecalInvCave,
        "105"   : TopDecalJungle,
        "106"   : TopPot,
        "pizza" : TopDecalPizzaSewers
    };
    
    if(lq_exists(_topDecal, _area)){
        return instance_create(_x, _y, lq_get(_topDecal, _area));
    }
    
    else if(lq_exists(spr.TopDecal, _area)){
        with(instance_create(_x, _y, TopPot)){
            sprite_index = lq_get(spr.TopDecal, _area);
            image_index = irandom(image_number - 1);
            image_speed = 0;
            
             // Area-Specifics:
            switch(_area){
                case "trench":
                    right = choose(-1, 1);
                    image_index = 0;
                    
                     // Water Mine:
                    if(chance(1, 6) && distance_to_object(Player) > 128){
                        image_index = 1;
                        with(script_bind_step(TopDecalWaterMine_step, 0)){
                            creator = other;
                        }
                    }
                    break;
            }
            
            return id;
        }
    }
    
    return noone;

#define TopDecalWaterMine_step
    if(instance_exists(creator)){
        x = creator.x;
        y = creator.y;
    }
    else{
        with(instance_create(x, y, WaterMine)){
            my_health = 0;
            spr_dead = spr.TopDecalMine;
            with(instances_meeting(x, y, Wall)){
                instance_create(x, y, FloorExplo);
                instance_destroy();
            }
        }
        instance_destroy();
    }

#define scrFX(_x, _y, _motion, _obj)
	if(!is_array(_x)) _x = [_x, 1];
	while(array_length(_x) < 2) array_push(_x, 0);

	if(!is_array(_y)) _y = [_y, 1];
	while(array_length(_y) < 2) array_push(_y, 0);

	if(!is_array(_motion)) _motion = [random(360), _motion];
	while(array_length(_motion) < 2) array_push(_motion, 0);

	with(obj_create(_x[0] + orandom(_x[1]), _y[0] + orandom(_y[1]), _obj)){
		var _face = (image_angle == direction);
		motion_add(_motion[0], _motion[1]);
		if(_face) image_angle = direction;
		
		return id;
	}
	
	return noone;

#define corpse_drop(_dir, _spd)
	with(instance_create(x, y, Corpse)){
		size = other.size;
		sprite_index = other.spr_dead;
		mask_index = other.mask_index;
		image_xscale = other.right * other.image_xscale;

		 // Speedify:
		direction = _dir;
		speed = min(_spd + max(0, -other.my_health / 5), 16);
		if(size > 0) speed /= size;

        return id;
	}

#define player_swap()
	var _swap = ["wep", "curse", "reload", "wkick", "wepflip", "wepangle", "can_shoot"];
	for(var i = 0; i < array_length(_swap); i++){
		var	s = _swap[i],
			_temp = [variable_instance_get(id, "b" + s), variable_instance_get(id, s)];

		for(var j = 0; j < array_length(_temp); j++) variable_instance_set(id, chr(98 * j) + s, _temp[j]);
	}

	wepangle = (weapon_is_melee(wep) ? choose(120, -120) : 0);
	can_shoot = (reload <= 0);
	clicked = 0;

#define portal_poof()  // Get Rid of Portals (but make it look cool)
    if(
    	instance_exists(Portal) &&
    	array_length(instances_matching_gt(instances_matching_gt(instances_matching_ne(Portal, "type", 2), "endgame", 0), "image_alpha", 0)) >= instance_number(Portal)
    ){
        with(Portal) if(endgame >= 0){
        	sound_stop(sndPortalClose);
        	with(instance_create(x, y, BulletHit)){
        		name = "PortalPoof";
        		sprite_index = sprPortalDisappear;
        		image_xscale = other.image_xscale;
        		image_yscale = other.image_yscale;
        		image_angle = other.image_angle;
        		image_blend = other.image_blend;
        		image_alpha = other.image_alpha;
        		depth = other.depth;
        	}
        	instance_destroy();
        }
    	if(fork()){
    		while(instance_exists(Portal)) wait 0;
    		with(Player){
	    		if(mask_index == mskNone) mask_index = mskPlayer;
	    		if(angle != 0){
		    		if(skill_get(mut_throne_butt)) angle = 0;
		    		else roll = true;
	    		}
    		}
    		exit;
    	}
    }
    
     // Prevent Corpse Portal:
    with(instances_matching_gt(Corpse, "alarm0", 0)){
    	alarm0 = -1;
    }

#define portal_pickups()
    with(CustomEndStep) if(array_equals(script, ["mod", mod_current, "portal_pickups_step"])){
    	return id;
    }
    return script_bind_end_step(portal_pickups_step, 0);

#define portal_pickups_step
	instance_destroy();
	
     // Attract Pickups:
    if(instance_exists(Player) && !instance_exists(Portal)){
        var _pluto = skill_get(mut_plutonium_hunger);
        
         // Normal Pickups:
        var _attractDis = 30 + (40 * _pluto);
        with(instances_matching([AmmoPickup, HPPickup, RoguePickup], "", null)){
            var p = instance_nearest(x, y, Player);
            if(point_distance(x, y, p.x, p.y) >= _attractDis){
                var _dis = 6 * current_time_scale,
                    _dir = point_direction(x, y, p.x, p.y),
                    _x = x + lengthdir_x(_dis, _dir),
                    _y = y + lengthdir_y(_dis, _dir);
                    
                if(place_free(_x, y)) x = _x;
                if(place_free(x, _y)) y = _y;
            }
        }
        
         // Rads:
        var _attractDis = 80 + (60 * _pluto),
            _attractDisProto = 170;
            
        with(instances_matching([Rad, BigRad], "speed", 0)){
            var s = instance_nearest(x, y, ProtoStatue);
            if(distance_to_object(s) >= _attractDisProto || !in_sight(s)){
                if(distance_to_object(Player) >= _attractDis){
                    var p = instance_nearest(x, y, Player),
                        _dis = 12 * current_time_scale,
                        _dir = point_direction(x, y, p.x, p.y),
                        _x = x + lengthdir_x(_dis, _dir),
                        _y = y + lengthdir_y(_dis, _dir);
                        
                    if(place_free(_x, y)) x = _x;
                    if(place_free(x, _y)) y = _y;
                }
            }
        }
    }

#define orandom(n) // For offsets
    return random_range(-n, n);

#define dfloor(_num, _round)
    return floor(_num / _round) * _round;

#define array_exists(_array, _value)
    return (array_find_index(_array, _value) >= 0);

#define array_count(_array, _value)
    var _count = 0;
    with(_array) if(self == _value) _count++;
    return _count;

#define array_flip(_array)
    var a = array_clone(_array),
        m = array_length(_array);

    for(var i = 0; i < m; i++){
        _array[@i] = a[(m - 1) - i];
    }

    return _array;

#define array_combine(_array1, _array2)
	var a = array_clone(_array1);
	array_copy(a, array_length(a), _array2, 0, array_length(_array2));
	return a;

#define array_shuffle(_array)
	var _size = array_length(_array),
		j, t;

	for(var i = 0; i < _size; i++){
	    j = irandom_range(i, _size - 1);
	    if(i != j){
	        t = _array[i];
	        _array[@i] = _array[j];
	        _array[@j] = t;
	    }
	}

	return _array;

#define array_delete(_array, _index)
    var i = _index,
        _new = array_slice(_array, 0, i);

    array_copy(_new, array_length(_new), _array, i + 1, array_length(_array) - (i + 1))

    return _new;

#define array_delete_value(_array, _value)
    var a = _array;
    while(array_find_index(a, _value) >= 0){
        a = array_delete(a, array_find_index(a, _value));
    }
    return a;

#define array_clone_deep(_array)
    var _new = array_clone(_array);

    for(var i = 0; i < array_length(_new); i++){
        var v = _new[i];
        if(is_array(v)){
            _new[i] = array_clone_deep(v);
        }
        else if(is_object(v)){
            _new[i] = lq_clone_deep(v);
        }
    }

    return _new;

#define lq_clone_deep(_obj)
    var _new = lq_clone(_obj);

    for(var i = 0; i < lq_size(_new); i++){
        var k = lq_get_key(_new, i),
            v = lq_get_value(_new, i);

        if(is_array(v)){
            lq_set(_new, k, array_clone_deep(v));
        }
        else if(is_object(v)){
            lq_set(_new, k, lq_clone_deep(v));
        }
    }

    return _new;

#define instance_nearest_array(_x, _y, _inst)
	var	_nearest = noone,
		d = 1000000;

	with(_inst) if(instance_exists(self)){
		var _dis = point_distance(_x, _y, x, y);
		if(_dis < d){
			_nearest = id;
			d = _dis;
		}
	}

	return _nearest;

#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)
    return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "x", _x1), "x", _x2), "y", _y1), "y", _y2);

#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)
    return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _x1), "bbox_left", _x2), "bbox_bottom", _y1), "bbox_top", _y2);

#define instances_seen_nonsync(_obj, _bx, _by)
    var _vx = view_xview_nonsync,
        _vy = view_yview_nonsync;

    return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _vx - _bx), "bbox_left", _vx + game_width + _bx), "bbox_bottom", _vy - _by), "bbox_top", _vy + game_height + _by);

#define instances_meeting(_x, _y, _obj)
    var _tx = x,
        _ty = y;

    x = _x;
    y = _y;
    var r = instances_matching_ne(instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", bbox_left), "bbox_left", bbox_right), "bbox_bottom", bbox_top), "bbox_top", bbox_bottom), "id", id);
    x = _tx;
    y = _ty;

    return r;

#define instances_at(_x, _y, _obj)
    return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _x), "bbox_left", _x), "bbox_bottom", _y), "bbox_top", _y);

#define instance_random(_obj)
	if(is_array(_obj) || instance_exists(_obj)){
		var i = instances_matching(_obj, "", undefined);
		if(array_length(i) > 0){
			return i[irandom(array_length(i) - 1)];
		}
	}
	return noone;

#define instance_create_copy(_x, _y, _obj)
	var	_inst = self,
		_instNew = obj_create(_x, _y, _obj);
		
	if(instance_exists(_instNew)){
		with(variable_instance_get_names(_inst)){
			if(!variable_is_read_only(_instNew, self)){
				if(!array_exists(["x", "y", "xstart", "ystart", "xprevious", "yprevious"], self)){
					variable_instance_set(_instNew, self, variable_instance_get(_inst, self));
				}
			}
		}
	}
	
	return _instNew;

#define variable_is_read_only(_inst, _varName)
	if(array_exists(["id", "object_index", "bbox_bottom", "bbox_top", "bbox_right", "bbox_left", "image_number", "sprite_yoffset", "sprite_xoffset", "sprite_height", "sprite_width"], _varName)){
		return true;
	}
	if(instance_is(_inst, Player)){
		if(array_exists(["p", "index", "alias"], _varName)){
			return true;
		}
	}
	return false;

#define wepfire_init(_wep)
	var _fire = {
		wep     : _wep,
		creator : noone,
		wepheld : false,
		roids   : false,
		spec    : false
	};

	 // Creator:
	_fire.creator = self;
    if(variable_instance_get(self, "object_index") == FireCont){
        _fire.creator = creator;
    }

     // Weapon Held by Creator:
	_fire.wepheld = (variable_instance_get(_fire.creator, "wep") == _wep);

	 // Secondary Firing:
	_fire.spec = variable_instance_get(self, "specfiring", false);
	if(_fire.spec && race == "steroids") _fire.roids = true;
	
	 // LWO Setup:
	if(is_string(_fire.wep)){
		var _lwo = mod_variable_get("weapon", _fire.wep, "lwoWep");
		if(is_object(_lwo)){
			_fire.wep = lq_clone(_lwo);

			if(_fire.wepheld){
				_fire.creator.wep = _fire.wep;
			}
		}
	}

	return _fire;

#define wepammo_fire(_wep)
     // Infinite Ammo:
    if(infammo != 0) return true;
    
     // Ammo Cost:
	var _cost = lq_defget(_wep, "cost", 1);
    with(_wep) if(ammo >= _cost){
        ammo -= _cost;
        
         // Can Fire:
        return true;
    }
    
     // Not Enough Ammo:
    reload = 0;
    if("anam" in _wep){
        wkick = -3;
        sound_play(sndEmpty);
        with(instance_create(x, y, PopupText)){
            target = other.index;
            if(_wep.ammo > 0){
            	text = "NOT ENOUGH " + _wep.anam;
            }
            else{
            	text = "EMPTY";
            }
        }
    }
    
	return false;

#define wepammo_draw(_wep)
    if(instance_is(self, Player) && (instance_is(other, TopCont) || instance_is(other, UberCont)) && is_object(_wep)){
		var _ammo = lq_defget(_wep, "ammo", 0);
		draw_ammo(index, (wep == _wep), _ammo, lq_defget(_wep, "amax", _ammo), (race == "steroids"));
    }

#define draw_ammo(_index, _primary, _ammo, _ammoMax, _steroids)
    if(player_get_show_hud(_index, player_find_local_nonsync())){
    	if(!instance_exists(menubutton) || _index == player_find_local_nonsync()){
		    var _x = view_xview_nonsync + (_primary ? 42 : 86),
		        _y = view_yview_nonsync + 21;

		    var _active = 0;
		    for(var i = 0; i < maxp; i++) _active += player_is_active(i);
		    if(_active > 1) _x -= 19;

			 // Determine Color:
		    var _col = "w";
			if(is_real(_ammo)){
				if(_ammo > 0){
				    if(_primary || _steroids){
				    	if(_ammo <= ceil(_ammoMax * 0.2)){
					    	_col = "r";
					    }
				    }
				    else _col = "s";
				}
				else _col = "d";
			}

			 // !!!
		    draw_set_halign(fa_left);
		    draw_set_valign(fa_top);
		    draw_set_projection(2, _index);
		    draw_text_nt(_x, _y, "@" + _col + string(_ammo));
		    draw_reset_projection();
    	}
    }

#define frame_active(_interval)
    return ((current_frame % _interval) < current_time_scale);

#define skill_get_icon(_skill)
    if(is_real(_skill)){
        return [sprSkillIconHUD, _skill];
    }
    if(is_string(_skill) && mod_script_exists("skill", _skill, "skill_icon")){
        return [mod_script_call("skill", _skill, "skill_icon"), 0];
    }
    return [sprEGIconHUD, 2];

#define area_generate(_sx, _sy, _area)
	if(is_real(_area) || mod_exists("area", _area)){
	    GameCont.area = _area;

	     // Store Player Positions:
	    var _playerPos = [];
	    with(Player){
	    	array_push(_playerPos, {
	    		inst : id,
	    		x : x,
	    		y : y
	    	});
	    }

	     // Remember View:
	    var _viewPos = [];
	    for(var i = 0; i < maxp; i++){
	    	_viewPos[i] = [view_xview[i], view_yview[i]];
	    }

	     // No Duplicates:
	    var _fogscroll = 0;
	    with(TopCont){
	    	_fogscroll = fogscroll;
	    	instance_destroy();
	    }
	    with(SubTopCont) instance_destroy();
	    with(BackCont) instance_destroy();

	     // Generate Level:
	    var _minID = GameObject.id,
	    	_chest = [WeaponChest, AmmoChest, RadChest, HealthChest];
	    	
	    with(instance_create(0, 0, GenCont)){
	        var _hard = GameCont.hard;
	        spawn_x = _sx + 16;
	        spawn_y = _sy + 16;

	         // FloorMaker Fixes:
	        goal += instance_number(Floor);
	        var _floored = instance_nearest(10000, 10000, Floor);
	        with(FloorMaker){
	            goal = other.goal;
	            if(!position_meeting(x, y, _floored)){
	                with(instance_nearest(x, y, Floor)) instance_destroy();
	            }
	            x = _sx;
	            y = _sy;
	            instance_create(x, y, Floor);
	        }

	         // Floor & Chest Gen:
	        while(instance_exists(FloorMaker)){
	            with(FloorMaker) if(instance_exists(self)){
	                event_perform(ev_step, ev_step_normal);
	            }
	        }

	         // Find Newly Generated Things:
	        var _newFloor = instances_matching_gt(Floor, "id", _minID),
	            _newChest = [];

	        for(var i = 0; i < array_length(_chest); i++){
	            _newChest[i] = instances_matching_gt(_chest[i], "id", _minID);
	        }

	         // Make Walls:
	        with(_newFloor) floor_walls();

	         // Spawn Enemies:
	        with(_newFloor){
	            if(chance(_hard, _hard + 10)){
	                if(!place_meeting(x, y, chestprop) && !place_meeting(x, y, RadChest)){
	                    // (distance to spawn coordinates > 120) check
	                    mod_script_call("area", _area, "area_pop_enemies");
	                }
	            }
	        }
	        with(_newFloor){
	             // Minimum Enemy Count:
	            if(instance_number(enemy) < (3 + (_hard / 1.5))){
	                if(!place_meeting(x, y, chestprop) && !place_meeting(x, y, RadChest)){
	                    // (distance to spawn coordinates > 120) check
	                    mod_script_call("area", _area, "area_pop_enemies");
	                }
	            }
	            
	              // Crown of Blood:
	            if(GameCont.crown = crwn_blood){
	                if(chance(_hard, _hard + 8)){
	                    if(!place_meeting(x, y, chestprop) && !place_meeting(x, y, RadChest)){
	                        // (distance to spawn coordinates > 120) check
	                        mod_script_call("area", _area, "area_pop_enemies");
	                    }
	                }
	            }
	            
	             // Props:
	            mod_script_call("area", _area, "area_pop_props");
	        }
	        
	         // Find # of Chests to Keep:
	        gol = 1;
	        wgol = 0;
	        agol = 0;
	        rgol = 0;
	        if(skill_get(mut_open_mind)){
	            var m = choose(0, 1, 2);
	            switch(m){
	                case 0: wgol++; break;
	                case 1: agol++; break;
	                case 2: rgol++; break;
	            }
	        }
	        mod_script_call("area", _area, "area_pop_chests");
	        
	         // Clear Extra Chests:
	        var _extra = [wgol, agol, rgol, rgol, 0];
	        for(var i = 0; i < array_length(_newChest); i++){
	            var n = array_length(_newChest[i]);
	            if(n > 0 && gol + _extra[i] > 0){
	                while(n-- > gol + _extra[i]){
	                    instance_delete(instance_nearest_array(_sx + random_range(-250, 250), _sy + random_range(-250, 250), _newChest[i]));
	                }
	            }
	        }
	        
	         // Crown of Love:
	        if(GameCont.crown = crwn_love){
	            for(var i = 0; i < array_length(_newChest); i++) with(_newChest[i]){
	                if(instance_exists(self)){
	                    instance_create(x, y, AmmoChest);
	                    instance_delete(id);
	                }
	            }
	        }
	        
	         // Rad Can -> Health Chest:
	        else{
	            var _lowHP = false;
	            with(Player) if(my_health < maxhealth / 2) _lowHP = true;
	            with(_newChest[2]) if(instance_exists(self)){
	                if((_lowHP && chance(1, 2)) || (GameCont.crown == crwn_life && chance(2, 3))){
	                    array_push(_newChest[3], instance_create(x, y, HealthChest));
	                    instance_destroy();
	                    break;
	                }
	            }
	        }
	        
	         // Rogue:
	        for(var i = 0; i < maxp; i++) if(player_get_race(i) == "rogue"){
		        with(RadChest){
		        	instance_create(x, y, RogueChest);
		        	instance_delete(id);
		        }
		        break;
	        }
	        
	         // Mimics:
	        with(_newChest[1]) if(instance_exists(self) && chance(1, 11)){
	            instance_create(x, y, Mimic);
	            instance_delete(id);
	        }
	        with(_newChest[3]) if(instance_exists(self) && chance(1, 51)){
	            instance_create(x, y, SuperMimic);
	            instance_delete(id);
	        }
	        
	         // Extras:
	        mod_script_call("area", _area, "area_pop_extras");
	        
	         // Done + Fix Random Wall Spawn:
	        var n = Wall.id;
	        event_perform(ev_alarm, 1);
	        with(instances_matching_gt(Wall, "id", n)) instance_delete(id);
	    }
	    with(TopCont) fogscroll = _fogscroll;
	    
	     // Remove Portal FX:
	    with(instances_matching([Spiral, SpiralCont], "", null)) instance_destroy();
	    repeat(4) with(instance_nearest(10016, 10016, PortalL)) instance_destroy();
	    with(instance_nearest(10016, 10016, PortalClear)) instance_destroy();
	    sound_stop(sndPortalOpen);
	    
	     // Reset Player & Camera Pos:
	    with(Player) sound_stop(snd_wrld);
	    with(_playerPos) with(inst){
    		x = other.x;
    		y = other.y;
	    }
	    for(var i = 0; i < array_length(_viewPos); i++){
	    	var _vx = _viewPos[i, 0],
	    		_vy = _viewPos[i, 1];
	    		
	    	view_shift(i, point_direction(0, 0, _vx, _vy), point_distance(0, 0, _vx, _vy) / current_time_scale);
	    }
	    
	     // Force Music Transition:
	    mod_variable_set("mod", "ntte", "musTrans", true);
	}

#define area_get_name(_area, _subarea, _loop)
	var a = [_area, "-", _subarea];

	 // Custom Area:
	if(is_string(_area)){
		a = ["MOD"];
		if(mod_script_exists("area", _area, "area_name")){
			var _custom = mod_script_call("area", _area, "area_name", _subarea, _loop);
			if(is_string(_custom)) a = [_custom];
		}
	}

	 // Secret Area:
	else if(real(_area) >= 100){
		switch(_area){
			case 100:
				a = ["???"];
				break;

			case 106:
				a = ["HQ", _subarea];
				break;

			case 107:
				a = ["$$$"];
				break;

			default:
				a = [_area - 100, "-?"];
		}
	}

	 // Loop:
	if(real(_loop) > 0){
		array_push(a, " " + ((UberCont.hardmode == true) ? "H" : "L"));
		array_push(a, _loop);
	}

	 // Compile Name:
	var _name = "";
	for(var i = 0; i < array_length(a); i++){
		var n = a[i];
		if(is_real(n) && frac(n) != 0){
			a[i] = string_format(n, 0, 2);
		}
		_name += string(n);
	}

	return _name;

#define area_get_subarea(_area)
    if(is_real(_area)){
         // Secret Areas:
        if(_area == 106) return 3;
        if(_area >= 100) return 1;
        
         // Transition Area:
        if((_area % 2) == 0) return 1;
        
        return 3;
    }
    
     // Custom Area:
    var _scrt = "area_subarea";
    if(mod_script_exists("area", _area, _scrt)){
        return mod_script_call("area", _area, _scrt);
    }
    
    return 0;

#define area_get_secret(_area)
    if(is_real(_area)){
    	return (_area >= 100);
    }

     // Custom Area:
    var _scrt = "area_secret";
    if(mod_script_exists("area", _area, _scrt)){
        return mod_script_call("area", _area, _scrt);
    }

    return false;

#define area_get_underwater(_area)
    if(is_real(_area)){
    	return (_area == 101);
    }

     // Custom Area:
    var _scrt = "area_underwater";
    if(mod_script_exists("area", _area, _scrt)){
        return mod_script_call("area", _area, _scrt);
    }

    return false;

#define floor_walls()
	var	_x1 = bbox_left - 16,
		_y1 = bbox_top - 16,
		_x2 = bbox_right + 16 + 1,
		_y2 = bbox_bottom + 16 + 1/*,
		_minID = GameObject.id*/;
		
	for(var _x = _x1; _x < _x2; _x += 16){
		for(var _y = _y1; _y < _y2; _y += 16){
			if(_x == _x1 || _y == _y1 || _x == _x2 - 16 || _y == _y2 - 16){
				if(!position_meeting(_x, _y, Floor)){
					instance_create(_x, _y, Wall);
				}
			}
		}
	}
	
	//return instances_matching_gt(Wall, "id", _minID);

#define floor_reveal(_floors, _maxTime)
    with(script_bind_draw(floor_reveal_draw, -6.00001)){
		list = [];
		
		with(_floors) if(instance_exists(self)){
			array_push(other.list, {
				inst		: id,
				time		: _maxTime,
				time_max	: _maxTime,
				color		: background_color,
				flash		: false,
				move_dis	: 4,
				move_dir	: 90,
				ox			: 0,
				oy			: -8,
				bx			: 0,
				by			: 0
			})
		}
		
        return list;
    }

#define floor_reveal_draw
	if(array_length(list) > 0){
        with(list){
        	 // Revealing:
            if(time > 0){
            	time -= current_time_scale;
            	
                var	t = clamp(time / time_max, 0, 1),
                	_ox = ox + lengthdir_x(move_dis * (1 - t), move_dir),
                	_oy = oy + lengthdir_y(move_dis * (1 - t), move_dir),
                	_bx = bx,
                	_by = by;
                	
                draw_set_alpha(t);
                draw_set_color(merge_color(c_white, color, (flash ? ((time > time_max) ? 1 : (1 - t)) : t)));
                
                with(inst){
                    draw_rectangle(bbox_left + _ox - _bx, bbox_top + _oy - _by, bbox_right + _ox + _bx, bbox_bottom + _oy + _by, false);
                }
            }
            
             // Done:
            else other.list = array_delete_value(other.list, self);
        }
		draw_set_alpha(1);
    }
    else instance_destroy();

#define area_border(_y, _area, _color)
	with(script_bind_draw(area_border_step, 10000, _y, _area, _color)){
    	cavein = false;
    	cavein_dis = 800;
    	cavein_inst = [];
		cavein_pan = 0;

    	type = [
    		[Wall,		 0, [area_get_sprite(_area, sprWall1Bot), area_get_sprite(_area, sprWall1Top), area_get_sprite(_area, sprWall1Out)]],
    		[TopSmall,	 0, area_get_sprite(_area, sprWall1Trans)],
    		[FloorExplo, 0, area_get_sprite(_area, sprFloor1Explo)],
    		[Debris,	 0, area_get_sprite(_area, sprDebris1)]
    	];

    	return id;
    }
    
#define area_border_step(_y, _area, _color)
	if(DebugLag) trace_time();
	
    var _fix = false,
    	_caveInst = cavein_inst;
    	
	 // Cave-In:
	if(cavein){
	    _fix = true;
		if(cavein_dis > 0){
			var d = 12;
			if(array_length(instances_matching_gt(Player, "y", _y - 64)) <= 0) d *= 1.5;
    		cavein_dis = max(0, cavein_dis - (max(4, random(d)) * current_time_scale));
    		
    		 // Debris:
			var _floor = instances_matching_gt(Floor, "bbox_bottom", _y);
			with(_floor) if(point_seen_ext((bbox_left + bbox_right + 1) / 2, (bbox_top + bbox_bottom + 1) / 2, 16, 16, -1)){
				var n = 2 * array_length(instances_matching_gt(Floor, "y", y));
				if(chance_ct(1, n) && (object_index != FloorExplo || chance(1, 10))){
					with(instance_create(choose(bbox_left + 4, bbox_right - 4), choose(bbox_top + 4, bbox_bottom - 4), Debris)){
						motion_set(90 + orandom(90), 4 + random(4));
					}
				}
			}
			
			 // Caving Level In:
			if(cavein_dis < 400){
				script_bind_step(area_border_cavein, 0, _y, cavein_dis, _caveInst);
				
				 // Effects:
				if(current_frame_active){
					with(instances_matching_gt(_floor, "bbox_bottom", _y + cavein_dis)){
						repeat(choose(1, choose(1, 2))) with(instance_create(random_range(bbox_left - 12, bbox_right + 12), bbox_bottom, Dust)){
							image_xscale *= 2;
							image_yscale *= 2;
							depth = -8;
							vspeed -= 5;
							sound_play_hit(choose(sndWallBreak, sndWallBreakBrick), 0.3);
						}
					}
				}
    		}
    		
    		 // Saved Caved Instances:
    		var f = noone;
    		with(instances_matching_lt(instances_matching_gt(Floor, "bbox_bottom", _y), "bbox_top", _y)){
    			f = id;
    			break;
    		}
    		with(_caveInst){
    			if(instance_exists(self)){
					visible = false;
	    			y = _y + 16 + other.cavein_dis;
	    			if(instance_exists(f)) x += (((f.bbox_left + f.bbox_right + 1) / 2) - x) * 0.1 * current_time_scale;

	    			 // Why do health chests break walls again
	    			if(instance_is(self, HealthChest)) mask_index = mskNone;
    			}
    			else other.cavein_inst = array_delete_value(other.cavein_inst, self);
    		}
    		
			 // Screenshake:
			if(cavein_pan < 1) cavein_pan += 1/20 * current_time_scale;
			for(var i = 0; i < maxp; i++){
				view_shake[i] = max(view_shake[i], 5);
				with(instance_exists(view_object[i]) ? view_object[i] : player_find(i)){
					view_shake_max_at(x, _y + other.cavein_dis, 20);
					
					 // Pan Down:
					view_shift(i, 270, clamp(y - (_y - 64), 0, min(20, other.cavein_dis / 10)) * other.cavein_pan);
				}
			}
		}
		
		 // Finished Caving In:
		else{
			cavein = -1;
			
			 // Fix Camera:
			with(Revive){
				if(view_object[p] == id) view_object[p] = noone;
			}
			
			 // Wallerize:
			with(instances_matching_gt(Floor, "bbox_bottom", _y)){
				floor_walls();
			}
			with(instances_matching_gt(Wall, "bbox_bottom", _y)){
				wall_tops();
			}
			
			 // Rubble:
			with(_caveInst) if(instance_exists(self)){
				visible = true;
			}
			with(instances_matching(instances_matching_gt(Floor, "bbox_bottom", _y), "object_index", Floor)){
				with(obj_create(x + 16, _y, "PizzaRubble")){
					inst = _caveInst;
					event_perform(ev_step, ev_step_normal);
				}
				
				 // Fix Potential Softlockyness:
				with(instances_matching_lt(instances_matching_gt(FloorExplo, "bbox_bottom", _y - 4), "bbox_top", _y - 4)){
					var _x1 = (bbox_left + bbox_right + 1) / 2,
						_y1 = (bbox_top + bbox_bottom + 1) / 2,
						_x2 = (other.bbox_left + other.bbox_right + 1) / 2;
						
					if(collision_line(_x1, _y1, _x2, _y1, Wall, false, false)){
						with(instance_create(_x1, _y - 24, PortalClear)){
							sprite_index = mskFloor;
							image_xscale = (_x2 - _x1) / sprite_width;
							image_speed = 1 / abs(image_xscale);
						}
					}
				}
			}
		}
	}
	else if(cavein == false){
		 // Start Cave In:
		if(array_length(instances_matching_lt(Player, "y", _y)) > 0){
			cavein = true;
			sound_play_pitchvol(sndStatueXP, 0.2 + random(0.2), 3);
		}
	}
	if(cavein != -1){
		with(Revive){
			if(!instance_exists(view_object[p]) && !instance_exists(player_find(p))){
				view_object[p] = id;
			}
		}
	}
	
     // Sprite Fixes:
    with(type){
    	var _obj = self[0],
    		_num = self[1];
    		
    	if(_num < 0 || _num != instance_number(_obj)){
    		_fix = true;
    		self[@1] = instance_number(_obj);
    	}
    }
	if(_fix) with(type){
    	var _obj = self[0],
    		_spr = self[2];
    		
		with(instances_matching(_obj, "cat_border_fix", null)){
			cat_border_fix = true;
			if(y >= _y){
				switch(_obj){
					case Wall:
						sprite_index = _spr[0];
    					topspr = _spr[1];
    					outspr = _spr[2];
    					break;
    					
    				default:
						sprite_index = _spr;
				}
			}
		}
    }
    
     // Background:
    var _vx = view_xview_nonsync,
        _vy = view_yview_nonsync;
        
    draw_set_color(_color);
    draw_rectangle(_vx, _y, _vx + game_width, max(_y, _vy + game_height), 0);

    if(DebugLag) trace_time("area_border_step");

#define area_border_cavein(_y, _caveDis, _caveInst)
	 // Delete:
	with(instances_matching_ne(instances_matching_gt(GameObject, "y", _y + _caveDis), "object_index", Dust)){
		 // Kill:
		if(y > _y + 64 && instance_is(self, hitme) && my_health > 0){
			my_health = 0;
			if("lasthit" in self) lasthit = [sprDebris102, "CAVE IN"];
			event_perform(ev_step, ev_step_normal);
		}

		 // Save:
		else if(persistent || (instance_is(self, Pickup) && !instance_is(self, Rad)) || instance_is(self, chestprop) || (instance_is(self, Corpse) && y < _y + 240) || (instance_is(self, CustomHitme) && "name" in self && name == "Pet")){
			if(!array_exists(_caveInst, id)) array_push(_caveInst, id);
		}

		 // Delete:
		else instance_delete(id);
	}

	 // Hide Wall Shadows:
	with(instances_matching_gt(Wall, "bbox_bottom", _y + _caveDis - 32)) outspr = -1;

	 // Lights:
	var _light = mod_variable_get("mod", "tesewers", "catLight");
	with(_light){
		if(y > _y + _caveDis){
			_light = array_delete_value(_light, self);
			mod_variable_set("mod", "tesewers", "catLight", _light);
		}
	}

	instance_destroy();

#define area_get_sprite(_area, _spr)
	if(is_string(_area)){
		var s = mod_script_call("area", _area, "area_sprite", _spr);
		if(s != 0 && s != null){
			return s;
		}
	}
	
	if(is_real(_spr) || is_string(_spr)){
		var	_name = (is_real(_spr) ? sprite_get_name(_spr) : _spr),
			_list = {
		        "sprFloor1"		 : `sprFloor${_area}`,
		        "sprFloor1B"	 : `sprFloor${_area}B`,
		        "sprFloor1Explo" : `sprFloor${_area}Explo`,
		        "sprWall1Trans"	 : `sprWall${_area}Trans`,
		        "sprWall1Bot"	 : `sprWall${_area}Bot`,
		        "sprWall1Out"	 : `sprWall${_area}Out`,
		        "sprWall1Top"	 : `sprWall${_area}Top`,
		        "sprDebris1"	 : `sprDebris${_area}`,
		        "sprDetail1"	 : `sprDetail${_area}`
			},
			s = asset_get_index(lq_defget(_list, _name, ""));
			
		if(!sprite_exists(s)) s = asset_get_index(_name);
		
		return s;
	}
	
	return -1;

#define floor_get(_x, _y)
	 // Find Floor:
    with(instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(Floor, "bbox_right", _x), "bbox_left", _x), "bbox_bottom", _y), "bbox_top", _y)){
    	return id;
    }

	 // Default to LWO Floor:
    return {
		x					: _x,
		y					: _y,
		xprevious			: _x,
		yprevious			: _y,
		xstart				: _x,
		ystart				: _y,
		hspeed				: 0,
		vspeed				: 0,
		direction			: 0,
		speed				: 0,
		friction			: 0,
		gravity				: 0,
		gravity_direction	: 270,
		visible				: true,
		sprite_index		: -1,
		sprite_width		: 0,
		sprite_height		: 0,
		sprite_xoffset		: 0,
		sprite_yoffset		: 0,
		image_number		: 1,
		image_index			: 0,
		image_speed			: 0,
		depth				: 10,
		image_xscale		: 1,
		image_yscale		: 1,
		image_angle			: 0,
		image_alpha			: 1,
		image_blend			: c_white,
		bbox_left			: _x,
		bbox_right			: _x,
		bbox_top			: _y,
		bbox_bottom			: _y,
		object_index		: Floor,
		id					: noone,
		solid				: false,
		persistent			: false,
		mask_index			: mskFloor,
		image_speed_raw		: 0,
		hspeed_raw			: 0,
		vspeed_raw			: 0,
		speed_raw			: 0,
		friction_raw		: 0,
		gravity_raw			: 0,
		alarm0				: -1,
		alarm1				: -1,
		alarm2				: -1,
		alarm3				: -1,
		alarm4				: -1,
		alarm5				: -1,
		alarm6				: -1,
		alarm7				: -1,
		alarm8				: -1,
		alarm9				: -1,
		alarm10				: -1,
		alarm11				: -1,
		styleb				: false,
		traction			: 0.45,
		area				: GameCont.area,
		material			: 0
	};
	
#define floor_align(_x, _y, _w, _h, _bw, _bh)
	var	_gridX = 10000,
		_gridY = 10000,
		_gridW = 16,
		_gridH = 16,
		_floorAdjacent = instance_rectangle_bbox(_x - _bw, _y - _bh, _x + _w + _bw - 1, _y + _h + _bh - 1, instances_matching_ne(Floor, "object_index", FloorExplo));
		
	if(array_length(_floorAdjacent) <= 0){
		instance_rectangle_bbox(_x - _bw, _y - _bh, _x + _w + _bw - 1, _y + _h + _bh - 1, FloorExplo);
	}
	
	if(array_length(_floorAdjacent) > 0){
		with(instance_nearest_array(_x, _y, _floorAdjacent)){
			_gridX = x;
			_gridY = y;
			_gridW = min(_bw, ((bbox_right + 1) - bbox_left));
			_gridH = min(_bh, ((bbox_bottom + 1) - bbox_top));
		}
	}
	else with(instance_nearest(_x, _y, Floor)){
		_gridX = x;
		_gridY = y;
	}
	
	return [
		_gridX + dfloor(_x - _gridX, _gridW),
		_gridY + dfloor(_y - _gridY, _gridH)
	];
	
#define floor_set(_x, _y, _state) // imagine if floors and walls just used a ds_grid bro....
	var _inst = noone;
	
	 // Create Floor:
	if(_state){
		var	_obj = ((_state >= 2) ? FloorExplo : Floor),
			_msk = object_get_mask(_obj),
			_w = ((sprite_get_bbox_right (_msk) + 1) - sprite_get_bbox_left(_msk)),
			_h = ((sprite_get_bbox_bottom(_msk) + 1) - sprite_get_bbox_top (_msk));
			
		 // Align to Adjacent Floors:
		var _gridPos = floor_align(_x, _y, _w, _h, _w, _h);
		_x = _gridPos[0];
		_y = _gridPos[1];
		
		 // Clear Floors:
		if(!instance_exists(GenCont)){
			with(instance_rectangle_bbox(_x, _y, _x + _w - 1, _y + _h - 1, [Floor, SnowFloor])){
				if(instance_is(self, _obj)){
					instance_destroy();
				}
			}
		}
		
		 // Auto-Style:
		var	_floormaker = noone,
			_lastArea = GameCont.area;
			
		if(!is_undefined(global.floor_style)){
			GameCont.area = 0;
			with(instance_create(_x, _y, FloorMaker)){
				with(instances_matching_gt(Floor, "id", id)) instance_delete(id);
				styleb = global.floor_style;
				_floormaker = self;
			}
			GameCont.area = _lastArea;
		}
		if(!is_undefined(global.floor_area)){
			GameCont.area = global.floor_area;
		}
		
		 // Floorify:
		_inst = instance_create(_x, _y, _obj);
		with(_inst){
			 // Clear Area:
			if(!instance_exists(GenCont)){
				wall_clear(bbox_left, bbox_top, bbox_right, bbox_bottom);
			}
			
			 // Wallerize:
			if(instance_exists(Wall)){
				floor_walls();
				wall_update(bbox_left - 16, bbox_top - 16, bbox_right + 16, bbox_bottom + 16);
			}
		}
		
		with(_floormaker) instance_destroy();
		GameCont.area = _lastArea;
	}
	
	 // Destroy Floor:
	else with(instances_at(_x, _y, [Floor, SnowFloor])){
		var	_x1 = bbox_left - 16,
			_y1 = bbox_top - 16,
			_x2 = bbox_right + 16,
			_y2 = bbox_bottom + 16;
			
		instance_destroy();
		
		if(instance_exists(Wall)){
			with(other){
				 // Un-Wall:
				wall_clear(_x1, _y1, _x2, _y2);
				
				 // Re-Wall:
				for(var _fx = _x1; _fx < _x2 + 1; _fx += 16){
					for(var _fy = _y1; _fy < _y2 + 1; _fy += 16){
						if(!position_meeting(_fx, _fy, Floor)){
							if(collision_rectangle(_fx - 16, _fy - 16, _fx + 31, _fy + 31, Floor, false, false)){
								instance_create(_fx, _fy, Wall);
							}
						}
					}
				}
				wall_update(_x1 - 16, _y1 - 16, _x2 + 16, _y2 + 16);
			}
		}
	}
	
	return _inst;
	
#define floor_set_style(_style, _area)
	global.floor_style = _style;
	global.floor_area = _area;
	
#define floor_reset_style()
	floor_set_style(null, null);
	
#define wall_clear(_x1, _y1, _x2, _y2)
	with(instance_rectangle_bbox(_x1, _y1, _x2, _y2, [Wall, TopSmall, TopPot, Bones, InvisiWall])){
		instance_destroy();
	}
	
#define wall_tops()
	var _minID = GameObject.id;
	instance_create(x - 16, y - 16, Top);
	instance_create(x - 16, y,      Top);
	instance_create(x,      y - 16, Top);
	instance_create(x,      y,      Top);
	return instances_matching_gt(TopSmall, "id", _minID);
	
#define wall_update(_x1, _y1, _x2, _y2)
	with(instance_rectangle(_x1, _y1, _x2, _y2, Wall)){
		 // Fix:
		visible = place_meeting(x, y + 16, Floor);
		l = (place_free(x - 16, y) ?  0 :  4);
		w = (place_free(x + 16, y) ? 24 : 20) - l;
		r = (place_free(x, y - 16) ?  0 :  4);
		h = (place_free(x, y + 16) ? 24 : 20) - r;
		
		 // TopSmalls:
		wall_tops();
	}

#define instance_budge(_objAvoid, _disMax)
	if(place_meeting(x, y, _objAvoid)){
		 // Find Nearby Open Space:
		var	_goalx = null,
			_goaly = null;
			
		with(instance_rectangle_bbox(x - _disMax, y - _disMax, x + _disMax, y + _disMax, Floor)){
			for(var _x = bbox_left; _x < bbox_right + 1; _x += 8){
				for(var _y = bbox_top; _y < bbox_bottom + 1; _y += 8){
	        		var _dis = point_distance(other.x, other.y, _x, _y);
	    			if(_dis < _disMax){
	    				with(other) if(!place_meeting(_x, _y, _objAvoid)){
	        				_disMax = _dis;
	        				_goalx = _x;
	        				_goaly = _y;
	    				}
	    			}
				}
			}
		}
		
		 // Move Toward Open Space:
		if(_goalx != null && _goaly != null){
			while(place_meeting(x, y, _objAvoid)){
				var	l = min(1, point_distance(x, y, _goalx, _goalx)),
					d = point_direction(x, y, _goalx, _goaly);
					
				x += lengthdir_x(l, d);
				y += lengthdir_y(l, d);
			}
			xprevious = x;
			yprevious = y;
		}
		
		return place_meeting(x, y, _objAvoid);
	}
	
	return false;

#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)
    var _disMax	= point_distance(_x1, _y1, _x2, _y2),
        _disAdd	= min(_disMax / 8, 10) + (_enemy ? (array_length(instances_matching_ge(instances_matching(CustomEnemy, "name", "Eel"), "arcing", 1)) - 1) : 0),
		_dis	= _disMax,
        _dir	= point_direction(_x1, _y1, _x2, _y2),
        _x		= _x1,
        _y		= _y1,
        _lx		= _x,
        _ly		= _y,
        _ox		= lengthdir_x(_disAdd, _dir),
        _oy		= lengthdir_y(_disAdd, _dir),
        _obj	= (_enemy ? EnemyLightning : Lightning),
		_inst	= [],
		_team	= variable_instance_get(self, "team", -1),
		_hitid	= variable_instance_get(self, "hitid", -1),
		_imgInd	= -1,
		_imgSpd	= 0.4,
		a, _off, _wx, _wy;

    while(_dis > _disAdd){
        _dis -= _disAdd;
        _x += _ox;
        _y += _oy;

		 // Wavy Offset:
		if(_dis > _disAdd){
	        a = (_dis / _disMax) * pi;
	        _off = 4 * sin((_dis / 8) + (current_frame / 6));
	        _wx = _x + lengthdir_x(_off, _dir - 90) + (_arc * sin(a));
	        _wy = _y + lengthdir_y(_off, _dir - 90) + (_arc * sin(a / 2));
		}

		 // End:
		else{
			_wx = _x2;
			_wy = _y2;
		}

		 // Lightning:
	    with(instance_create(_wx, _wy, _obj)){
	        ammo = ceil(_dis / _disAdd);
	        image_xscale = -point_distance(_lx, _ly, x, y) / 2;
	        image_angle = point_direction(_lx, _ly, x, y);
	        direction = image_angle;
		    hitid = _hitid;
		    creator = other;
		    team = _team;

			 // Exists 1 Frame - Manually Animate:
			if(_imgInd < 0){
				_imgInd = ((current_frame + _arc) * image_speed) % image_number;
				_imgSpd = (image_number - _imgInd);
			}
			image_index = _imgInd;
			image_speed_raw = _imgSpd;

			array_push(_inst, id);
	    }

        _lx = _wx;
        _ly = _wy;
    }

	 // FX:
	if(chance_ct(array_length(_inst), 200)){
		with(_inst[irandom(array_length(_inst) - 1)]){
	        with(instance_create(x + orandom(8), y + orandom(8), PortalL)){
	            motion_add(random(360), 1);
	        }
			if(_enemy) sound_play_hit(sndLightningReload, 0.5);
			else sound_play_pitchvol(sndLightningReload, 1.25 + random(0.5), 0.5);
		}
	}

    return _inst;

#define wep_get(_wep)
    if(is_object(_wep)){
        return wep_get(lq_defget(_wep, "wep", wep_none));
    }
    return _wep;

#define wep_merge(_stock, _front)
	return mod_script_call_nc("weapon", "merge", "weapon_merge", _stock, _front);

#define wep_merge_decide(_hardMin, _hardMax)
	return mod_script_call_nc("weapon", "merge", "weapon_merge_decide", _hardMin, _hardMax);

#define weapon_decide_gold(_minhard, _maxhard, _nowep)
    var _list = ds_list_create(),
        s = weapon_get_list(_list, _minhard, _maxhard);
        
	ds_list_shuffle(_list);
	
    for(i = 0; i < s; i++) {
        var w = ds_list_find_value(_list, i),
            c = 0;
            
         // Weapon Exceptions:
        if(is_array(_nowep) && array_exists(_nowep, w)) c = true;
        if(w == _nowep) c = true;
        
         // Specific Weapon Spawn Conditions:
        if(
            !weapon_get_gold(w)             ||
            w == wep_golden_nuke_launcher   ||
            w == wep_golden_disc_gun        ||
            w == wep_golden_frog_pistol
        ){
            c = true;
        }
        
        if(c) continue;
        break;
    }
    
    ds_list_destroy(_list);
    
     // Set Weapon:
    if(!c) return w;
    
     // Default:
    return choose(wep_golden_wrench, wep_golden_machinegun, wep_golden_shotgun, wep_golden_crossbow, wep_golden_grenade_launcher, wep_golden_laser_pistol);

#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)
     // Auto-Determine Grid Size:
    var _tileSize = 16,
        _areaWidth  = (ceil(abs(_xtarget - _xstart) / _tileSize) * _tileSize) + 320,
        _areaHeight = (ceil(abs(_ytarget - _ystart) / _tileSize) * _tileSize) + 320;

    _areaWidth = max(_areaWidth, _areaHeight);
    _areaHeight = max(_areaWidth, _areaHeight);

    var _triesMax = 4 * ceil((_areaWidth + _areaHeight) / _tileSize);

     // Clamp Path X/Y:
    _xstart = floor(_xstart / _tileSize) * _tileSize;
    _ystart = floor(_ystart / _tileSize) * _tileSize;
    _xtarget = floor(_xtarget / _tileSize) * _tileSize;
    _ytarget = floor(_ytarget / _tileSize) * _tileSize;

     // Grid Setup:
    var _gridw = ceil(_areaWidth / _tileSize),
        _gridh = ceil(_areaHeight / _tileSize),
        _gridx = round((((_xstart + _xtarget) / 2) - (_areaWidth  / 2)) / _tileSize) * _tileSize,
        _gridy = round((((_ystart + _ytarget) / 2) - (_areaHeight / 2)) / _tileSize) * _tileSize,
        _grid = ds_grid_create(_gridw, _gridh),
        _gridCost = ds_grid_create(_gridw, _gridh);

    ds_grid_clear(_grid, -1);

     // Mark Walls:
    with(instance_rectangle(_gridx, _gridy, _gridx + _areaWidth, _gridy + _areaHeight, _wall)){
    	if(position_meeting(x, y, id)){
    		_grid[# ((x - _gridx) / _tileSize), ((y - _gridy) / _tileSize)] = -2;
    	}
    }

     // Pathing:
    var _x1 = (_xtarget - _gridx) / _tileSize,
        _y1 = (_ytarget - _gridy) / _tileSize,
        _x2 = (_xstart - _gridx) / _tileSize,
        _y2 = (_ystart - _gridy) / _tileSize,
        _searchList = [[_x1, _y1, 0]],
        _tries = _triesMax;

    while(_tries-- > 0){
        var _search = _searchList[0],
            _sx = _search[0],
            _sy = _search[1],
            _sp = _search[2];

        if(_sp >= 1000000) break; // No more searchable tiles
        _search[2] = 1000000;

         // Sort Through Neighboring Tiles:
        var _costSoFar = _gridCost[# _sx, _sy];
        for(var i = 0; i < 2*pi; i += pi/2){
            var _nx = _sx + cos(i),
                _ny = _sy - sin(i),
                _nc = _costSoFar + 1;

            if(_grid[# _nx, _ny] == -1){
                if(_nx >= 0 && _ny >= 0){
                    if(_nx < _gridw && _ny < _gridh){
                        _gridCost[# _nx, _ny] = _nc;
                        _grid[# _nx, _ny] = point_direction(_nx, _ny, _sx, _sy);

                         // Add to Search List:
                        array_push(_searchList, [
                            _nx,
                            _ny,
                            point_distance(_x2, _y2, _nx, _ny) + (abs(_x2 - _nx) + abs(_y2 - _ny)) + _nc
                        ]);
                    }
                }
            }

             // Path Complete:
            if(_nx == _x2 && _ny == _y2){
                _tries = 0;
                break;
            }
        }

         // Next:
        array_sort_sub(_searchList, 2, true);
    }

     // Pack Path into Array:
    var _x = _xstart,
        _y = _ystart,
        _path = [[_x + (_tileSize / 2), _y + (_tileSize / 2)]],
        _tries = _triesMax;

    while(_tries-- > 0){
        var _dir = _grid[# ((_x - _gridx) / _tileSize), ((_y - _gridy) / _tileSize)];
        if(_dir >= 0){
            _x += lengthdir_x(_tileSize, _dir);
            _y += lengthdir_y(_tileSize, _dir);
            array_push(_path, [_x + (_tileSize / 2), _y + (_tileSize / 2)]);
        }
        else{
            _path = []; // Couldn't find path
            break;
        }

         // Done:
        if(_x == _xtarget && _y == _ytarget){
            break;
        }
    }
    if(_tries <= 0) _path = []; // Couldn't find path

    ds_grid_destroy(_grid);
    ds_grid_destroy(_gridCost);

    return _path;

#define path_shrink(_path, _wall, _skipMax)
    var _pathNew = [],
		_link = 0;

	if(!is_array(_wall)) _wall = [_wall];

    for(var i = 0; i < array_length(_path); i++){
    	 // Save Important Points on Path:
    	var _save = (
            i <= 0							||
            i >= array_length(_path) - 1	||
            i - _link >= _skipMax
        );

		 // Save Points Going Around Walls:
        if(!_save){
        	var _x1 = _path[i + 1, 0],
        		_y1 = _path[i + 1, 1],
        		_x2 = _path[_link, 0],
        		_y2 = _path[_link, 1];

		    for(var j = 0; j < array_length(_wall); j++){
        		if(collision_line(_x1, _y1, _x2, _y2, _wall[j], false, false)){
        			_save = true;
        			break;
        		}
		    }
        }

		 // Store:
        if(_save){
            array_push(_pathNew, _path[i]);
            _link = i;
        }
    }

    return _pathNew;
    
#define path_reaches(_path, _xtarget, _ytarget, _wall)
	if(!is_array(_wall)) _wall = [_wall];
	
	var m = array_length(_path);
	if(m > 0){
		var	_x = _path[m - 1, 0],
			_y = _path[m - 1, 1];
			
	    for(var i = 0; i < array_length(_wall); i++){
			if(collision_line(_x, _y, _xtarget, _ytarget, _wall[i], false, false)){
				return false;
			}
	    }
	    
	    return true;
	}
	return false;
    
#define path_direction(_path, _x, _y, _wall)
	if(!is_array(_wall)) _wall = [_wall];

     // Find Nearest Unobstructed Point on Path:
    var	_nearest = -1,
		_disMax = 1000000;

	for(var i = 0; i < array_length(_path); i++){
		var _px = _path[i, 0],
			_py = _path[i, 1],
        	_dis = point_distance(_x, _y, _px, _py);

		if(_dis < _disMax){
			var _walled = false
		    for(var j = 0; j < array_length(_wall); j++){
        		if(collision_line(_x, _y, _px, _py, _wall[j], false, false)){
        			_walled = true;
        			break;
        		}
		    }
		    if(!_walled){
				_disMax = _dis;
				_nearest = i;
		    }
		}
	}

     // Find Direction to Next Point on Path:
    if(_nearest >= 0){
	    var _follow = min(_nearest + 1, array_length(_path) - 1),
        	_nx = _path[_follow, 0],
            _ny = _path[_follow, 1];

		 // Go to Nearest Point if Path to Next Point Obstructed:
	    for(var j = 0; j < array_length(_wall); j++){
    		if(collision_line(x, y, _nx, _ny, _wall[j], false, false)){
				_nx = _path[_nearest, 0];
				_ny = _path[_nearest, 1];
    			break;
    		}
	    }

        return point_direction(x, y, _nx, _ny);
    }

    return null;
    
#define path_draw(_path)
	var	_x = x,
		_y = y;
		
	with(_path){
		draw_line(self[0], self[1], _x, _y);
		_x = self[0];
		_y = self[1];
	}

#define race_get_sprite(_race, _sprite)
    var i = race_get_id(_race),
        n = race_get_name(_race);
        
    if(i < 17){
        var a = string_upper(string_char_at(n, 1)) + string_lower(string_delete(n, 1, 1));
        switch(_sprite){
            case sprMutant1Idle:        return asset_get_index(`sprMutant${i}Idle`);
            case sprMutant1Walk:        return asset_get_index(`sprMutant${i}Walk`);
            case sprMutant1Hurt:        return asset_get_index(`sprMutant${i}Hurt`);
            case sprMutant1Dead:        return asset_get_index(`sprMutant${i}Dead`);
            case sprMutant1GoSit:       return asset_get_index(`sprMutant${i}GoSit`);
            case sprMutant1Sit:         return asset_get_index(`sprMutant${i}Sit`);
            case sprFishMenu:           return asset_get_index("spr" + a + "Menu");
            case sprFishMenuSelected:   return asset_get_index("spr" + a + "MenuSelected");
            case sprFishMenuSelect:     return asset_get_index("spr" + a + "MenuSelect");
            case sprFishMenuDeselect:   return asset_get_index("spr" + a + "MenuDeselect");
        }
    }
    if(mod_script_exists("race", n, "race_sprite")){
        var s = mod_script_call("race", n, "race_sprite", _sprite);
        if(!is_undefined(s)) return s;
    }
    return -1;

#define pet_create(_x, _y, _name, _modType, _modName)
    with(obj_create(_x, _y, "Pet")){
        pet = _name;
        mod_name = _modName;
        mod_type = _modType;

		 // Stats:
		var s = `pet/${pet}.${mod_name}.${mod_type}`;
		if(!is_object(stat_get(s))){
			stat_set(s, { found:0, owned:0 });
		}
		stat = stat_get(s);

         // Sprites:
        if(mod_type == "mod" && mod_name == "petlib"){
	        spr_idle = lq_defget(spr, "Pet" + pet + "Idle", spr_idle);
	        spr_walk = lq_defget(spr, "Pet" + pet + "Walk", spr_idle);
	        spr_hurt = lq_defget(spr, "Pet" + pet + "Hurt", spr_idle);
	        spr_dead = lq_defget(spr, "Pet" + pet + "Dead", mskNone);
        }
        spr_icon = lq_defget(pet_get_icon(mod_type, mod_name, pet), "spr", spr_icon);

         // Custom Create Event:
    	var _scrt = pet + "_create";
        if(mod_script_exists(mod_type, mod_name, _scrt)){
            mod_script_call(mod_type, mod_name, _scrt);
        }

		 // Auto-set Stuff:
		if(instance_exists(self)){
	        with(pickup_indicator) if(text == ""){
	        	text = `@2(${other.spr_icon})` + other.pet;
	        }
	        if(sprite_index == spr.PetParrotIdle) sprite_index = spr_idle;
			if(maxhealth > 0 && my_health == 0) my_health = maxhealth;
			if(hitid == -1) hitid = [spr_idle, pet];
		}

		return self;
    }
    return noone;

#define pet_spawn(_x, _y, _name)
	return pet_create(_x, _y, _name, "mod", "petlib");
	
#define pet_get_icon(_modType, _modName, _name)
	var	_icon = {
		spr	: spr.PetParrotIcon,
		img	: 0.4 * current_frame,
		x	: 0,
		y	: 0,
		xsc	: 1,
		ysc	: 1,
		ang	: 0,
		col	: c_white,
		alp	: 1
	};
	
	 // Custom:
	var _modScrt = _name + "_icon"
	if(mod_script_exists(_modType, _modName, _modScrt)){
		var _iconCustom = mod_script_call(_modType, _modName, _modScrt);
		
		if(is_real(_iconCustom)){
			_icon.spr = _iconCustom;
		}
		
		else{
			for(var i = 0; i < min(array_length(_iconCustom), lq_size(_icon)); i++){
				lq_set(_icon, lq_get_key(_icon, i), real(_iconCustom[i]));
			}
		}
	}
	
	 // Default:
	else if(_modType == "mod" && _modName == "petlib"){
		_icon.spr = lq_defget(spr, "Pet" + _name + "Icon", -1);
	}
	
	return _icon;
	
#define top_create(_x, _y, _obj, _spawnDir, _spawnDis)
	var _inst = _obj;
	if(!is_real(_obj) || _obj < 100000){
		_inst = obj_create(_x, _y, _obj);
	}
	with(_inst){
		x = _x;
		y = _y;
		xprevious = x;
		yprevious = y;
		
		 // Don't Clear Walls:
		if(instance_is(self, hitme) || instance_is(self, chestprop)){
			with(instances_matching(instances_matching(instances_matching_gt([PortalClear, PortalShock], "id", id), "xstart", xstart), "ystart", ystart)){
				instance_destroy();
			}
		}
	}
	
	 // Top-ify:
	if(array_length(instances_matching(instances_matching(CustomObject, "name", "TopObject"), "target", _inst)) <= 0){
		with(obj_create(_x, _y, "TopObject")){
			target = _inst;
			
			if(instance_exists(target)){
				target.top_object = id;
				spawn_dis = random_range(16, 48);
				
				 // Object-General Setup:
				if(instance_is(target, projectile)){
					is_damage = true;
				}
				if(instance_is(target, hitme) || instance_is(target, chestprop) || instance_is(target, WepPickup)){
					unstick = true;
				}
				if(instance_is(target, Pickup) || instance_is(target, projectile)){
					jump = 0;
				}
				if(instance_is(target, IDPDSpawn) || instance_is(target, VanSpawn)){
					grav = 0;
					override_depth = false;
					depth = -6.01;
				}
				if(instance_is(target, chestprop) || instance_is(target, Pickup)){
					wobble = 8;
					spawn_dis = 8;
				}
				if(instance_is(target, Effect) || instance_is(target, Corpse) || instance_is(target, Pickup)){
					override_depth = false;
					depth = -6.01;
					if(instance_is(target, Corpse)) depth -= 0.001;
					if(instance_is(target, Pickup)) depth -= 0.002;
				}
				if(instance_is(target, Explosion) || instance_is(target, MeatExplosion) || instance_is(target, PlasmaImpact)){
					grav = 0;
					is_damage = true;
					override_mask = false;
					override_depth = false;
					depth = -8;
				}
				if(instance_is(target, ReviveArea) || instance_is(target, NecroReviveArea) || instance_is(target, RevivePopoFreak)){
					grav = 0;
					override_mask = false;
					override_depth = false;
					depth = -6.01;
				}
				if(instance_is(target, prop)){
					spawn_dis = random_range(4, 16);
					
					 // Death on Impact:
					if(target.team == 0 && target.size <= 1 && target.maxhealth < 50){
						target_save.my_health = 0;
					}
				}
				if(instance_is(target, enemy)){
					is_enemy = true;
					idle_time = 90 + random(90);
					if(direction == 0 && "walk" not in self && "right" in self){
						direction = random(360);
						scrRight(direction);
					}
					
					 // Disable AI:
					with(target) for(var i = 0; i <= 10; i++){
						lq_set(other.target_save, `alarm${i}`, alarm_get(i));
						alarm_set(i, -1);
					}
				}
				
				 // Object-Specific Setup:
				switch((string_pos("Custom", object_get_name(target.object_index)) == 1 && "name" in target) ? target.name : target.object_index){
					 /// ENEMIES ///
					case BoneFish:
					case "Puffer":
					case "Hammerhead":
						idle_walk = [0, 5];
						idle_walk_chance = 1/2;
						break;
						
					case Exploder:
						jump_time = 1;
						break;
						
					case ExploFreak:
						jump *= 1.2;
						idle_walk = [0, 5];
						idle_walk_chance = 1;
						spawn_dis = random_range(120, 192);
						
						 // Important:
						target_save.my_health = 0;
						break;
						
					case Freak:
						idle_walk = [0, 5];
						idle_walk_chance = 1;
						spawn_dis = random_range(80, 240);
						break;
						
					case JungleFly:
						jump = 0;
						grav = random_range(0.1, 0.3);
						idle_walk = [8, 12];
						idle_walk_chance = 1/2;
						break;
						
					case MeleeBandit:
						idle_walk = [10, 30];
						idle_walk_chance = 1/2;
						break;
						
					case Necromancer:
						jump *= 2/3;
						idle_walk_chance = 1/16;
						break;
						
					case "Seal":
					    idle_walk_chance = 1/12;
					    break;
					    
					case "Spiderling":
						jump *= 4/5;
						idle_walk_chance = 1/4;
						break;
						
					 /// PROPS ///
					case Anchor:
					case OasisBarrel:
					case WaterMine:
						mask_index = target.spr_shadow;
						image_xscale = 0.5;
						image_yscale = 0.5;
						spr_shadow = mskNone;
						break;
						
					case Barrel:
					case GoldBarrel:
					case ToxicBarrel:
						jump *= 1.5;
						spawn_dis = ((target.object_index == Barrel) ? 32 : 8);
						spr_shadow = shd16;
						spr_shadow_y = 4;
						wobble = 8;
						break;
						
					case BigFlower:
					case IceFlower:
						override_depth = false;
						depth = -6.01;
						spr_shadow = target.spr_idle;
						spr_shadow_y = 1;
						break;
						
					case Bush:
					case JungleAssassinHide:
						spr_shadow_y = -1;
						break;
						
					case Cactus:
						with(target){
							var t = choose("", "3");
							if(chance(2, 3)) t = "B" + t; // Rotten epic
							spr_idle = asset_get_index("sprCactus" + t);
							spr_hurt = asset_get_index("sprCactus" + t + "Hurt");
							spr_dead = asset_get_index("sprCactus" + t + "Dead");
						}
					//case NightCactus:
						spr_shadow = sprMine;
						spr_shadow_y = 9;
						break;
						
					case Car:
						spawn_dis = 16;
						break;
						
					case Cocoon:
					case "NewCocoon":
						spawn_dis = 8;
						spr_shadow = shd16;
						spr_shadow_y = 3;
						break;
						
					case FireBaller:
					case SuperFireBaller:
						z += random(8);
						jump = random(1);
						grav = random_range(0.1, 0.2);
						break;
						
					case FrogEgg:
						grav = 1.5;
						break;
						
					case Generator:
						spawn_dis = 64;
						spr_shadow = ((target.image_xscale < 0) ? spr.shd.BigGeneratorR : spr.shd.BigGenerator);
						target_save.my_health = 0;
						break;
						
					case Hydrant:
						spawn_dis = random_range(32, 96);
						
						 // Icicle:
						if(chance(1, 2) || target.spr_idle == sprIcicle) with(target){
							spr_idle = sprIcicle;
							spr_hurt = sprIcicleHurt;
							spr_dead = sprIcicleDead;
							snd_hurt = sndHitRock;
							snd_dead = sndIcicleBreak;
							spr_shadow = shd16;
							spr_shadow_y = 3;
						}
						break;
						
					case MeleeFake:
						spr_shadow = sprMine;
						spr_shadow_y = 7;
						break;
						
					case MoneyPile:
						spawn_dis = 8;
						spr_shadow_y = -1;
						break;
						
					case Pillar:
						spr_shadow = shd32;
						spr_shadow_y = -3;
						break;
						
					case Pipe:
						spr_shadow = sprMine;
						spr_shadow_y = 7;
						break;
						
					case Server:
						spr_shadow = sprHydrant;
						spr_shadow_y = 5;
						break;
						
					case SmallGenerator:
						spawn_dis = 32;
						target.image_xscale = 1;
						spr_shadow = target.spr_idle;
						spr_shadow_y = 1;
						break;
						
					case SnowMan:
						spawn_dis = random_range(8, 40);
						spr_shadow = sprNewsStand;
						spr_shadow_y = 5;
						break;
						
					case Terminal:
						spr_shadow_y = 1;
						break;
						
					case Tires:
						spawn_dis = random_range(24, 80);
						spr_shadow_y = -1;
						break;
				}
				
				 // Shadow:
				if("spr_shadow" in target){
					if(spr_shadow   == -1) spr_shadow   = target.spr_shadow;
					if(spr_shadow_x ==  0) spr_shadow_x = target.spr_shadow_x;
					if(spr_shadow_y ==  0) spr_shadow_y = target.spr_shadow_y;
				}
				
				 // Hitbox:
				if(mask_index == -1){
					image_xscale = 0.5;
					image_yscale = 0.5;
					
					 // Default:
					if(spr_shadow == -1){
						mask_index = target.sprite_index;
					}
					
					 // Shadow-Based:
					else{
						mask_index = spr_shadow;
						mask_y = spr_shadow_y + (((bbox_top - y) * (1 - image_yscale)));
					}
				}
				
				 // Push Away From Floors:
				if(_spawnDir >= 0){
					spawn_dir = _spawnDir;
				}
				else with(instance_nearest(x - 16, y - 16, Floor)){
					other.spawn_dir = point_direction((bbox_left + bbox_right + 1) / 2, (bbox_top + bbox_bottom + 1) / 2, other.x, other.y);
				}
				if(_spawnDis >= 0){
					spawn_dis = _spawnDis;
				}
				if(spawn_dis > 0){
					var l = 4;
					while(
						distance_to_object(Floor)			< spawn_dis			||
						distance_to_object(PortalClear)		< spawn_dis + 16	||
						distance_to_object(Bones)			< 16				||
						distance_to_object(TopPot)			< 8					||
						distance_to_object(CustomObject)	< 8
					){
						x += lengthdir_x(l, spawn_dir);
						y += lengthdir_y(l, spawn_dir);
					}
				}
				x = round(x);
				y = round(y);
				
				 // Object-Specific Post-Setup:
				if(instance_is(target, enemy) && jump_time == 0){
					with(instance_nearest(x - 16, y - 16, Floor)){
						other.jump_time = 90 + (distance_to_object(Player) * (2 + GameCont.loops));
					}
				}
				switch(target.object_index){
					case BoneFish:
					case Freak:
					case "Puffer":
					case "Hammerhead": // Swimming bro
						if(area_get_underwater(GameCont.area)){
							z += random_range(8, distance_to_object(Floor) / 2) * ((target.object_index == "Puffer") ? 0.5 : 1);
						}
						break;
						
					case FrogEgg: // Hatch
						target.alarm0 = irandom(150) + (distance_to_object(Player) * (1 + GameCont.loops));
						target_save.alarm0 = random_range(10, 30);
						break;
						
					case JungleFly: // Bro hes actually flying real
						z += random_range(4, 16 + (distance_to_object(Floor) / 2));
						break;
						
					case Pipe: // eat smash br
						with(target) with(instances_meeting(x, y, Wall)){
							topindex = 0;
						}
						break;
				}
				
				 // Underwater Time:
				if(area_get_underwater(GameCont.area)){
					jump /= 6;
					grav /= 4;
				}
				
				 // Insta-Land:
				var n = instance_nearest(x - 16, y - 16, Floor);
				if(
					instance_exists(n)																											&&
					!instance_exists(NothingSpiral)																								&&
					!collision_line(x, y, (n.bbox_left + n.bbox_right + 1) / 2, (n.bbox_top + n.bbox_bottom + 1) / 2, Wall,     false, false)	&&
					!collision_line(x, y, (n.bbox_left + n.bbox_right + 1) / 2, (n.bbox_top + n.bbox_bottom + 1) / 2, TopSmall, false, false)
				){
					zspeed = jump;
					zfriction = grav;
				}
				
				 // TopSmalls:
				else if(instance_is(target, prop)) with(target){
					var _xsc = image_xscale;
					image_xscale = sign(image_xscale * variable_instance_get(self, "right", 1));
					
					var _west = bbox_left - 8,
						_east = bbox_right + 1 + 8,
						_nort = y - 8,
						_sout = bbox_bottom + 1 + 8,
						_shad = ((other.spr_shadow != -1) ? other.spr_shadow : spr_shadow),
						_chance = 4/5;
						
					if(sprite_get_bbox_right(_shad) - sprite_get_bbox_left(_shad) > 64){
						_chance = 1;
					}
					
					for(var _ox = _west; _ox < _east; _ox += 16){
						for(var _oy = _nort; _oy < _sout; _oy += 16){
							if(chance(_chance, 1)){
								var	_sx = floor(_ox / 16) * 16,
									_sy = floor(_oy / 16) * 16;
									
								if(!position_meeting(_sx, _sy, Floor) && !position_meeting(_sx, _sy, Wall) && !position_meeting(_sx, _sy, TopSmall)){
									instance_create(_sx, _sy, TopSmall);
								}
							}
						}
					}
					
					image_xscale = _xsc;
				}
				
				 // Depth:
				if(override_depth) depth = -6 - ((y - 8) / 10000);
				
				with(target){
					var m = mask_index;
					mask_index = -1;
					other.search_x1 = min(x - 8, bbox_left);
					other.search_x2 = max(x + 8, bbox_right);
					other.search_y1 = min(y - 8, bbox_top);
					other.search_y2 = max(y + 8, bbox_bottom);
					mask_index = m;
				}
			}
			
			if(instance_exists(other)){
				event_perform(ev_step, ev_step_end);
			}
			else{ // bro wtf
				mod_script_call(on_end_step[0], on_end_step[1], on_end_step[2]);
			}
			
			return self;
		}
	}
	
	return noone;

#define floor_make(_x, _y, _obj)
    with(floor_set(_x, _y, true)){
    	_x = x;
    	_y = y;
    }
    return instance_create(_x + 16, _y + 16, _obj);

#define floor_fill(_x, _y, _w, _h)
    var	o = 32,
    	_gridPos = floor_align(_x, _y, _w * o, _h * o, o, o);
    	
	_x = _gridPos[0];
	_y = _gridPos[1];
	
     // Center Around x,y:
    _x -= floor((_w - 1) / 2) * o;
    _y -= floor((_h - 1) / 2) * o;
    
     // Floors:
    var r = [];
    for(var _ox = 0; _ox < _w; _ox++){
        for(var _oy = 0; _oy < _h; _oy++){
        	array_push(r, floor_set(_x + (_ox * o), _y + (_oy * o), true));
        }
    }
    return r;

#define floor_fill_round(_x, _y, _w, _h)
    var	o = 32,
    	_gridPos = floor_align(_x, _y, _w * o, _h * o, o, o);
    	
	_x = _gridPos[0];
	_y = _gridPos[1];
	
     // Center Around x,y:
    _x -= floor((_w - 1) / 2) * o;
    _y -= floor((_h - 1) / 2) * o;
    
     // Floors:
    var r = [];
    for(var _ox = 0; _ox < _w; _ox++){
        for(var _oy = 0; _oy < _h; _oy++){
            if((_ox != 0 && _ox != _w - 1) || (_oy != 0 && _oy != _h - 1)){ // Don't Make Corner Floors
                array_push(r, floor_set(_x + (_ox * o), _y + (_oy * o), true));
            }
        }
    }
    return r;

#define trace_lag()
    if(mod_variable_exists("mod", mod_current, "lag")){
        for(var i = 0; i < array_length(global.lag); i++){
            var _name = lq_get_key(global.lag, i),
                _total = string(lq_get_value(global.lag, i).total),
                _str = "";

            while(string_length(_total) > 0){
                var p = string_length(_total) - 3;
                _str = string_delete(_total, 1, p) + " " + _str;
                _total = string_copy(_total, 1, p);
            }

            trace(_name + ":", _str + "us");
        }
    }
    global.lag = {};

#define trace_lag_bgn(_name)
    _name = string(_name);
    if(!lq_exists(global.lag, _name)){
        lq_set(global.lag, _name, {
            timer : 0,
            total : 0
        });
    }
    with(lq_get(global.lag, _name)){
        timer = get_timer_nonsync();
    }

#define trace_lag_end(_name)
    var _timer = get_timer_nonsync();
    with(lq_get(global.lag, string(_name))){
        total += (_timer - timer);
        timer = _timer;
    }

#define player_create(_x, _y, _index)
    with(instance_create(_x, _y, CustomHitme)){
        with(instance_create(x, y, Revive)){
            p = _index;
            canrevive = true;
            event_perform(ev_collision, Player);
            event_perform(ev_alarm, 0);
        }
        instance_destroy();
    }
    with(player_find(_index)){
        my_health = maxhealth;
        sound_stop(snd_hurt);
        return id;
    }
    return noone;

#define trace_error(_error)
	trace(_error);
	trace_color(" ^ Screenshot that error and post it on NTTE's itch.io page, thanks!", c_yellow);

#define sleep_max(_milliseconds)
	global.sleep_max = max(global.sleep_max, _milliseconds);

#define view_shift(_index, _dir, _pan)
	if(_index < 0){
		for(var i = 0; i < maxp; i++){
			view_shift(i, _dir, _pan);
		}
	}
	else{
	    var _shake = UberCont.opt_shake;
	    UberCont.opt_shake = 1;

		with(instance_create(0, 0, Revive)){
			try{
				p = _index;
				instance_change(Player, false);
				gunangle = _dir;
				weapon_post(0, _pan * current_time_scale, 0);
			}
			catch(_error) trace_error(_error);

			instance_delete(id);
		}

	    UberCont.opt_shake = _shake;
	}

#define sound_play_ntte(_type, _snd)
    var c = lq_get(mod_variable_get("mod", "ntte", "sound_current"), _type);
    
     // Stop Previous Track:
    if(_snd != c.snd){
        audio_stop_sound(c.snd);
    }
    
     // Set Stuff:
    c.snd = _snd;
    c.vol = 1;
    c.pos = 0;
    
     // Play Track:
    if(!audio_is_playing(c.hold)){
        switch(_type){
            case "mus":
                sound_play_music(-1);
                sound_play_music(c.hold);
                break;
                
            case "amb":
                sound_play_ambient(-1);
                sound_play_ambient(c.hold);
                break;
        }
    }
    
    return c;

#define sound_play_hit_ext(_snd, _pit, _vol)
	var s = sound_play_hit(_snd, 0);
	sound_pitch(s, _pit);
	sound_volume(s, _vol);
	return s;

#define rad_drop(_x, _y, _raddrop, _dir, _spd)
	var _radInst = [];
	while(_raddrop > 0){
		var r = (_raddrop > 15);
		repeat(r ? 1 : _raddrop){
			if(r) _raddrop -= 10;
			with(instance_create(_x, _y, (r ? BigRad : Rad))){
				speed = _spd;
				direction = _dir;
				motion_add(random(360), random(_raddrop / 2) + 3);
				speed *= power(0.9, speed);
				array_push(_radInst, id);
			}
		}
		if(!r) break;
	}
	return _radInst;

#define rad_path(_inst, _target)
	var q = [];

	 // Bind Script:
	if(array_length(instances_matching(CustomScript, "name", "rad_path_step")) <= 0){
		with(script_bind_end_step(rad_path_step, 0)){
			name = script[2];
			list = [];
		}
	}

	 // Add to List:
	with(_inst){
		array_push(q, {
			inst : id,
			targ : _target,
			path : [],
			path_delay : 0,
			heal : 0
		});
	}
	with(instances_matching(CustomScript, "name", "rad_path_step")){
		list = array_combine(list, q);
	}

	return q;

#define rad_path_step
	var _list = list;
	if(array_length(_list) > 0){
		with(_list){
			var _targ = targ;
			if(instance_exists(inst) && instance_exists(_targ)){
			    var _tx = _targ.x,
			        _ty = _targ.y,
			        _path = path;
			        
				with(inst){
					if(array_length(_path) > 0){
						 // Direction to Follow:
						var _dir = null;
						if(collision_line(x, y, _tx, _ty, Wall, false, false)){
							_dir = path_direction(_path, x, y, Wall);
						}
						else{
							_dir = point_direction(x, y, _tx, _ty);
						}
						
						 // Movin:
						if(_dir != null){
							 // Accelerate:
							speed = min(speed + random(max(friction_raw, 2 * current_time_scale)), 12);
							
							 // Follow Path:
							direction += angle_difference(_dir, direction) * min(1, max(0.2, 16 / point_distance(x, y, _tx, _ty)) * current_time_scale);
							
							 // Spinny:
							image_angle += speed_raw;
							
							 // Bounce Less:
							if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
								var _min = min(speed, 2);
								if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw = 0;
								if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw = 0;
								speed = max(_min, speed);
							}
						}
						else path = [];
						
						 // Done:
						if(place_meeting(x, y, _targ) || (_targ.mask_index == mskNone && point_in_rectangle(x, y, _targ.bbox_left, _targ.bbox_top, _targ.bbox_right, _targ.bbox_bottom))){
							if(instance_is(_targ, Player)) speed = 0;
							else{
								if("raddrop" in _targ) _targ.raddrop += rad;

								 // Heal:
								var _heal = other.heal;
								if(_heal > 0) with(_targ){
									my_health += _heal;

									 // Effects:
									sound_play_hit(sndHPPickup, 0.3);
									with(instance_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), FrogHeal)){
										if(chance(1, 3)) sprite_index = spr.BossHealFX;
										depth = other.depth - 1;
									}
								}

								 // Effects:
								sound_play_hit(sndRadPickup, 0.5);
								with(instance_create(x, y, EatRad)){
									if(other.sprite_index == sprBigRad) sprite_index = sprEatBigRad;
								}

								instance_destroy();
							}
						}
					}
					else if(speed <= friction_raw * 2){
						speed = max(speed, friction_raw);
						
					    if(!path_reaches(_path, _tx, _ty, Wall)){
				        	if(other.path_delay > 0) other.path_delay -= current_time_scale;
				        	else{
				                _path = path_create(x, y, _tx, _ty, Wall);
				                _path = path_shrink(_path, Wall, 2);
				                other.path = _path;
				            	other.path_delay = 30;
				            	
								 // Send Path to Bros:
								var _inst = id;
								with(_list) if(inst != _inst && targ == _targ && array_length(path) <= 0){
									with(inst){
										if(!collision_line(x, y, _inst.x, _inst.y, Wall, false, false)){
											other.path = _path;
										}
									}
								}
				        	}
				        }
				        else other.path_delay = 0;
					}
				}
			}
			else{
				_list = array_delete_value(_list, self);
				
				 // Heal FX:
				if(heal){
					var n = 0;
					with(_list) if(targ == _targ) n++;
					if(n <= 0) with(_targ){
						with(instance_create(x, y, FrogHeal)){
							sprite_index = spr.BossHealFX;
							depth = other.depth - 1;
							image_xscale *= 1.5;
							image_yscale *= 1.5;
							vspeed -= 1;
						}
						with(instance_create(x, y, LevelUp)) creator = other;
						sound_play_hit_ext(sndLevelUltra, 2 + orandom(0.1), 0.6);
					}
				}
			}
		}
		list = _list;
	}
	else instance_destroy();
	