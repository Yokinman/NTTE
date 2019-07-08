#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.sav = mod_variable_get("mod", "teassets", "sav");

    global.chest_list = [];
    global.chest_vars = [];

    while(true){
        with(TopCont) script_bind_draw(draw_gui, depth - 0.01);

         // Chests Give Feathers:
        if(!instance_exists(GenCont)){
            with(instances_matching(chestprop, "my_feather_storage", null)){
                my_feather_storage = obj_create(x, y, "ParrotChester");
    
                 // Vars:
                with(my_feather_storage){
                    creator = other;
                    switch(other.object_index){
                        case IDPDChest:
                        case BigWeaponChest:
                        case BigCursedChest:
                            num = 18; break;
                        case GiantWeaponChest:
                        case GiantAmmoChest:
                            num = 54; break;
                    }
                }
            }

             // Throne Butt : Pickups Give Feathers
            if(skill_get(mut_throne_butt) > 0){
                with(instances_matching([AmmoPickup, HPPickup, RoguePickup], "my_feather_storage", null)){
                    my_feather_storage = obj_create(x, y, "ParrotChester");

                     // Vars:
                    with(my_feather_storage){
                        creator = other;
                        small = true;
                        num = ceil(2 * skill_get(mut_throne_butt));
                    }
                }
            }
        }

        wait 1;
    }

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav
#macro opt sav.option

#define race_name       return "PARROT";
#define race_text       return "MANY FRIENDS#BIRDS OF A @rFEATHER@w";
#define race_tb_text    return "@wPICKUPS @sGIVE @rFEATHERS@s";

/// Sprites
#define race_menu_button
    sprite_index = spr.Parrot[0].Select;
    image_index = !race_avail();

#define race_portrait(p, _skin)
	return spr.Parrot[_skin].Portrait;

#define race_mapicon(p, _skin)
    return spr.Parrot[_skin].Map;

#define race_skin_button(_skin)
    sprite_index = spr.Parrot[_skin].Loadout;
    image_index = !race_skin_avail(_skin);

#define race_ultra_button(_ultra)
	sprite_index = spr.Parrot[0].UltraIcon;
	image_index = _ultra - 1;

#define race_ultra_icon(_ultra)
	return lq_get(spr.Parrot[0], "UltraHUD" + chr(64 + _ultra));

#define race_sprite(_spr)  
    var b = (("bskin" in self && is_real(bskin)) ? bskin : 0);
    switch(_spr){
        case sprMutant1Idle:        return spr.Parrot[b].Idle;
        case sprMutant1Walk:        return spr.Parrot[b].Walk;
        case sprMutant1Hurt:        return spr.Parrot[b].Hurt;
        case sprMutant1Dead:        return spr.Parrot[b].Dead;
        case sprMutant1GoSit:       return spr.Parrot[b].GoSit;
        case sprMutant1Sit:         return spr.Parrot[b].Sit;
        case sprFishMenu:           return spr.Parrot[b].Idle;
        case sprFishMenuSelected:   return spr.Parrot[b].MenuSelected;
        case sprFishMenuSelect:     return spr.Parrot[b].Idle;
        case sprFishMenuDeselect:   return spr.Parrot[b].Idle;
        case sprChickenFeather:     return spr.Parrot[b].Feather;
    }
    return mskNone;

/// Lock Status
#define race_avail
    return unlock_get("parrot");

#define race_lock
    return "REACH @1(sprInterfaceIcons)1-1";

/// Skins
#define race_skins
	var _playersActive = 0;
	for(var i = 0; i < maxp; i++) _playersActive += player_is_active(i);
	if(_playersActive <= 1){
    	return 2;
	}
	else{ // Fix co-op bugginess
		var n = 1;
		while(unlock_get("parrot" + chr(65 + n))) n++;
		return n;
	}

#define race_skin_avail(_skin)
	var _playersActive = 0;
	for(var i = 0; i < maxp; i++) _playersActive += player_is_active(i);
	if(_playersActive <= 1){
		if(_skin == 0) return true;
    	return unlock_get("parrot" + chr(65 + real(_skin)));
	}
	else{ // Fix co-op bugginess
		return true;
	}

#define race_skin_name(_skin)
    if(race_skin_avail(_skin)){
        return chr(65 + _skin) + " SKIN";
    }
    else switch(_skin){
        case 0: return "EDIT THE SAVE FILE LMAO";
        case 1: return "COMPLETE THE#AQUATIC ROUTE";
    }

/// Text Stuff
#define race_ttip
    if(GameCont.level >= 10 && chance(1, 5)){
        return choose("migration formation", "charmed, i'm sure", "adventuring party", "free as a bird");
    }
    else{
        return choose("hitchhiker", "birdbrain", "parrot is an expert traveler", "wind under my wings", "parrot likes camping", "macaw works too", "chests give you @rfeathers@s");
    }

#define race_ultra_name
    switch (argument0) {
        case 1: return "FLOCK TOGETHER";
        case 2: return "UNFINISHED";
        default: return "";
    }
    
#define race_ultra_text
    switch (argument0) {
        case 1: return "CORPSES SPAWN @rFEATHERS@s";
        case 2: return "N/A";
        default: return "";
    }

#define create
     // Sound:
    snd_hurt = sndRavenHit;
    snd_dead = sndRavenDie;
    if(instance_exists(Menu)) snd_hurt = -1; // Dum CampChar fix

     // Feather Related:
    feather_num = 12;
    feather_ammo = 0;
    feather_ammo_max = 5 * feather_num;
    feather_targ_delay = 0;

     // :
    charm_last_my_health = my_health;

     // Extra Pet Slot:
    pet = [noone, noone];

     // Pet Perching:
    parrot_bob = [0, 1, 1, 0];

#define game_start
    wait 0;

     // Starter Pet + Extra Pet Slot:
    if(instance_exists(self)){
        with(Pet_spawn(x, y, "Parrot")) {
            leader = other;
            other.pet[0] = id;
            visible = false;
        }
    }

     // Wait Until Level is Generated:
    if(fork()){
        while(instance_exists(self) && !visible) wait 0;

         // Starting Feather Ammo:
        if(instance_exists(self)){
            repeat(12) with(obj_create(x + orandom(16), y + orandom(16), "ParrotFeather")){
                target = other;
                creator = other;
                index = other.index;
                bskin = other.bskin;
                speed *= 3;
            }
        }

        exit;
    }

#define step
     /// ACTIVE : Charm
    if(button_check(index, "spec") || usespec > 0){
        var _feathers = instances_matching(instances_matching(CustomObject, "name", "ParrotFeather"), "index", index),
            _feathersTargeting = instances_matching(instances_matching(_feathers, "canhold", true), "creator", id),
            _featherNum = feather_num;

         // Shooty Charm Feathers:
        if(array_length(_feathersTargeting) < _featherNum){
             // Retrieve Feathers:
            with(instances_matching(_feathers, "canhold", false)){
                 // Remove Charm Time:
                if(target != creator){
                    if("charm" in target && (target.charm.time > 0 || creator != other)){
                    	with(target){
	                        charm.time -= other.stick_time;
	                        if(charm.time <= 0){
	                            scrCharm(id, false);
	                        }
                    	}
                    }
                    target = creator;
                }

                 // Penalty:
                if(stick_time < stick_time_max){
                    stick_time -= min(30, stick_time);
                }

                 // Unstick:
                if(stick){
                    stick = false;
                    motion_add(random(360), 4);
                }

                 // Mine now:
                if(creator == other && array_length(_feathersTargeting) < _featherNum){
                    canhold = true;
                    other.feather_targ_delay = 3;
                    array_push(_feathersTargeting, id);
                }
            }

             // Excrete New Feathers:
            while(array_length(_feathersTargeting) < _featherNum && (feather_ammo > 0 || infammo != 0)){
                if(infammo == 0) feather_ammo--;

                 // Feathers:
                with(obj_create(x + orandom(4), y + orandom(4), "ParrotFeather")){
                    creator = other;
                    target = other;
                    bskin = other.bskin;
                    index = other.index;
                    array_push(_feathersTargeting, id);
                }

                 // Effects:
                sound_play_pitchvol(sndSharpTeeth, 3 + random(3), 0.4);
            }
        }

         // Targeting:
        if(array_length(_feathersTargeting) > 0){
            if(feather_targ_delay > 0){
                feather_targ_delay -= current_time_scale;
                with(_feathers) target = creator;
            }
            else{
                var r = 32,// * (1 + ultra_get("parrot", 3)),
                    _x = mouse_x[index],
                    _y = mouse_y[index],
                    _targ = [],
                    _featherNum = array_length(_feathersTargeting);
        
                with(instances_matching_ne(instance_rectangle_bbox(_x - r, _y - r, _x + r, _y + r, [enemy, RadMaggotChest]), "object_index", Van)){
                    if(collision_circle(_x, _y, r, id, true, false)){
                        array_push(_targ, id);
                        if(array_length(_targ) >= _featherNum) break;
                    }
                }
    
                if(array_length(_targ) <= 0){
                    with(_feathersTargeting) target = other;
                }
                else{
                    var n = 0;
                    with(_targ){
                        var i = 0,
                            _take = max(ceil(_featherNum / array_length(_targ)), 1);
        
                        while(n < _featherNum && i < _take){
                            with(_feathersTargeting[n]){
                                target = other;
                            }
                            n++;
                            i++;
                        }
                    }
                }
            }
        }
        
         // No Feathers:
        else if(button_pressed(index, "spec")){
            sound_play_pitchvol(sndMutant0Cnfm, 3 + orandom(0.2), 0.5);
        }
    }

     //HP Link
    if(ultra_get(mod_current, 2)){
        if(my_health != charm_hplink_lock){
            var _HPList = ds_list_create();
            with(instances_matching_gt(instances_matching_ne([hitme, becomenemy], "charm", null), "my_health", 0)){
                if(lq_defget(charm, "index", -1) == other.index){
                    ds_list_add(_HPList, id);
                }
            }
    
            if(ds_list_size(_HPList) > 0){
                ds_list_shuffle(_HPList);

                while(my_health != charm_hplink_lock){
                    if(ds_list_size(_HPList) > 0){
                        with(ds_list_to_array(_HPList)){
                            with(other){
                                var a = clamp(charm_hplink_lock - my_health, -1, 1);
                        		my_health += a;

                        		 // Alter Enemy HP:
                        		if(a > 0){
                        		     // FX:
                        		    var o = other;
                        		    with(instances_meeting(x, y, HealFX)){
                        		        with(instance_copy(true)){
                        		            x = o.x;
                        		            y = o.y;
                        		        }
                        		    }

                        		     // Heal:
                        		    with(o) if(my_health <= maxhealth){
                        		        my_health = min(my_health + a, maxhealth);
                        		    }
                        		}
                        		else projectile_hit_raw(other, a, true);

                        		if(other.my_health <= 0) ds_list_remove(_HPList, id);

                                if(my_health == charm_hplink_lock){
                                    my_health = charm_hplink_lock;
                                    break;
                                }
                            }
                        }
                    }
                    else break;
                }
            }
        }
    }
    charm_hplink_lock = my_health;

     /// ULTRA A: Flock Together
     // probably incredibly busted
    if(ultra_get(mod_current, 1)) {
        with(instances_matching(Corpse, "flock_together", null)) {
            flock_together = 1;
            // Hacky but me lazy:
            with(other) {
                with(obj_create(other.x + orandom(8), other.y + orandom(8), "ParrotFeather")){
                    target = other;
                    creator = other;
                    index = other.index;
                    bskin = other.bskin;
                }
            }
        }
    }

#define draw
    /*
    if(button_check(index, "spec")){
        draw_text_nt(x, y - 32, string(feather_ammo));
        
        var t = nearest_instance(mouse_x[index], mouse_y[index], instances_matching([enemy, RadMaggotChest], "", null));
        draw_sprite_ext(t.sprite_index, t.image_index, t.x, t.y, (t.image_xscale + sin((current_frame div (3 * current_time_scale))/2)/4) * t.right, t.image_yscale + sin((current_frame div (3 * current_time_scale))/2)/4, t.image_angle, c_red, t.image_alpha * 0.7)
    }
	*/

#define draw_gui
    instance_destroy();
    draw_set_projection(0);
    
    var _index = player_find_local_nonsync(),
        _playersActive = 0;

    for(var i = 0; i < maxp; i++) _playersActive += player_is_active(i);

	with(player_find(_index)){
	    if("charm_hplink_hud" not in self){
	        charm_hplink_hud = true;
	        charm_hplink_hud_hp = [my_health, maxhealth];
	    }

         // Add Up Charmed Ally HP:
        var _myHealth = 0,
            _maxHealth = 0,
            _hpColor = player_get_color(index);

        if(ultra_get(mod_current, 2)){
            with(instances_matching_gt(instances_matching_ne([hitme, becomenemy], "charm", null), "my_health", 0)){
                if(lq_defget(charm, "index", -1) == other.index){
                    _myHealth += my_health;
                    _maxHealth += maxhealth;
                    
                     // Hurt:
                    if(sprite_index == spr_hurt && image_index < 1){
                        _hpColor = c_white;
                    }
                }
            }
        }

        var _goal = [_myHealth, _maxHealth],
            _goalFactor = 0.2;

    	if(_myHealth != 0) charm_hplink_hud = true;

    	 // No Allies Alive:
    	else{
    	    _goal = [my_health, maxhealth];
    	    _goalFactor = 0.5;
    	    if(array_equals(charm_hplink_hud_hp, _goal)){
                charm_hplink_hud = false;
    	    }
    	}

         // Draw HP:
    	if(charm_hplink_hud){
        	var	_x1 = 22 + ((_playersActive > 1) ? -17 : 0),
        		_y1 = 7,
        		_x2 = _x1 + 83,
        		_y2 = _y1 + 7;

             // Hurt:
            if(sprite_index == spr_hurt && image_index < 1){
                _hpColor = c_white;
            }

    		if(_x1 < _x2){
    		     // Hide Normal HP:
    		    draw_set_color(c_black);
    			draw_rectangle(_x1, _y1, _x2, _y2, 0);

    			 // True HP Filling:
                draw_set_color(merge_color(_hpColor, c_black, 0.6));
    			draw_rectangle(_x1, _y1, _x1 + (clamp(min(my_health, maxhealth) / maxhealth, 0, 1) * (_x2 - _x1)), _y2, 0);

                 // Filling:
                draw_set_color(merge_color(_hpColor, c_white, 0.4));
    			draw_rectangle(_x1, _y1, _x1 + (clamp(min(charm_hplink_hud_hp[0], charm_hplink_hud_hp[1]) / charm_hplink_hud_hp[1], 0, 1) * (_x2 - _x1)), _y2, 0);

                 // Text:
    			draw_set_font(fntM);
    			draw_set_halign(fa_center);
    			draw_set_valign(fa_top);
    			draw_text_nt(_x1 + 45, _y1, `${charm_hplink_hud_hp[0]}/${charm_hplink_hud_hp[1]}`);
    		}

    		 // HP Changes Gradually (Visual Only):
        	for(var i = 0; i < array_length(_goal); i++){
                var a = (_goal[i] - charm_hplink_hud_hp[i]) * _goalFactor;
                charm_hplink_hud_hp[i] += ceil(abs(a)) * sign(a);

                if(abs(_goal[i] - charm_hplink_hud_hp[i]) < 1){
                    charm_hplink_hud_hp[i] = _goal[i];
                }
        	}
    	}
    	else charm_hplink_hud_hp = [my_health, maxhealth];
    	
    	 // Test Visual:
    	/*
    	if("test_off" not in self) test_off = 0;
    	if("test_has" not in self) test_has = 20;
    	if(button_check(index, "spec")){
	    	test_off += (1 - test_off) * 0.6 * current_time_scale;
	    }
	    else test_off -= test_off * 0.3 * current_time_scale;

	    if(test_off != 0){
	    	var _off = test_off;
	    	if("test_surf" not in self) test_surf = -1;
	    	if(!surface_exists(test_surf)){
	    		test_surf = surface_create(game_width, game_height);
	    	}
	    	
	    	surface_set_target(test_surf);
	    	draw_clear_alpha(0, 0);

			draw_set_color(c_black);
			var _x = mouse_x_nonsync,
				_y = mouse_y_nonsync;
	    	
	    	var r = 32,
	    		_test = false;
	    	test_has = 32;

            with(instances_matching_ne(instance_rectangle_bbox(_x - r, _y - r, _x + r, _y + r, [enemy, RadMaggotChest]), "object_index", Van)){
                if("test_thing" not in self) test_thing = 0;
                if(collision_circle(_x, _y, r, id, true, false)){
                	test_thing += (1 - test_thing) * 0.1 * current_time_scale;
                }
            }
            with(instances_matching_gt(hitme, "test_thing", 0.1)){
                other.test_has -= (6 * test_thing);
	    		draw_circle(_x + ((x - _x) * test_thing) - view_xview_nonsync, _y + ((y - _y) * test_thing) - view_yview_nonsync, (4 + sprite_xoffset) * test_thing, false);
                if(!collision_circle(_x, _y, r, id, true, false)){
                	test_thing -= test_thing * 0.2 * current_time_scale;
                }
            }

	    	//draw_circle(_x - view_xview_nonsync, _y - view_yview_nonsync, test_has + (2 * sin(current_frame / 20)), false);
	    	
	    	surface_reset_target();
	    	
	    	draw_set_blend_mode_ext(bm_dest_alpha, bm_inv_src_alpha);
	    	surface_screenshot(test_surf);
	    	draw_set_blend_mode(bm_normal);
	    	
	    	draw_set_flat(_hpColor);
	    	draw_set_alpha(0.5);
	    	draw_surface(test_surf, view_xview_nonsync + _off, view_yview_nonsync - (_off * 4));
	    	draw_surface(test_surf, view_xview_nonsync, view_yview_nonsync - (_off * 4) + _off);
	    	draw_surface(test_surf, view_xview_nonsync, view_yview_nonsync - (_off * 4) - _off);
	    	draw_surface(test_surf, view_xview_nonsync - _off, view_yview_nonsync - (_off * 4));
	    	draw_set_alpha(1);
	    	draw_set_flat(-1);
	    	
	    	draw_surface(test_surf, view_xview_nonsync, view_yview_nonsync - (_off * 4));
	    }
	    */
	}

	draw_reset_projection();


/// Scripts
#define orandom(n)																		return  random_range(-n, n);
#define chance(_numer, _denom)															return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)														return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define surflist_set(_name, _x, _y, _width, _height)									return	mod_script_call_nc("mod", "teassets", "surflist_set", _name, _x, _y, _width, _height);
#define surflist_get(_name)																return	mod_script_call_nc("mod", "teassets", "surflist_get", _name);
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