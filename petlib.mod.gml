#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.save = mod_variable_get("mod", "teassets", "save");

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.save

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)

#define chat_command(_cmd, _arg, _ind)
    switch(_cmd){
        case "pet":
            Pet_spawn(mouse_x[_ind], mouse_y[_ind], _arg);
            return true;
    }


#define CoolGuy_create
     // Vars:
    maxspeed = 3.5;
    poop = 1;
    poop_delay = 0;

#define CoolGuy_step
    if(leader == noone && !instance_exists(leader)) poop_delay = 30;

    else if(instance_exists(HPPickup) && instance_exists(leader)){
        var h = nearest_instance(x, y, instances_matching_ne(HPPickup, "sprite_index", sprSlice));
        if(in_sight(h)){
            alarm0 = 40;
            direction = point_direction(x, y, h.x, h.y);

             // Nom:
            if(place_meeting(x, y, h)){
                with(h){
                    sound_play_pitchvol(sndFrogEggHurt, 0.6 + random(0.2), 0.3);
                    sound_play_pitchvol(sndHitRock, 2 + orandom(0.2), 0.5);
                    repeat(2) with(instance_create(x, y, AllyDamage)){
                        motion_add(random(360), 1);
                        image_blend = c_yellow;
                    }
                    instance_destroy();
                }
                poop++;
                poop_delay = alarm0 - 10;
            }
        }
    }

     // 
    if(poop_delay > 0) poop_delay -= current_time_scale;
    else if(poop > 0){
         // Delicious Pizza Juices:
        repeat(4){
            with(scrWaterStreak(x + orandom(2), y + 1, random(360), 1)){
                hspeed = 2 * -other.right;
                image_angle = direction;
                image_blend = c_orange;
                image_xscale = 0.5;
                image_yscale = image_xscale;
            }
        }
        if(poop >= 2){
            repeat(poop / 2){
                with(scrFX([x, 4], [y, 4], 1, Dust)){
                    image_blend = c_orange;
                    hspeed -= random_range(2, 3) * other.right;
                }
            }
        }
        sound_play_pitchvol(sndHPPickup,        0.8 + random(0.2), 0.8);
        sound_play_pitchvol(sndFrogExplode,     1.2 + random(0.8), 0.8);

         // Determine Pizza Output:
        var o = "Pizza";
        if(chance(1, 2) && !chance(4, poop)){
            poop -= 2;
            o = HealthChest;
            sound_play_pitchvol(sndEnergyHammerUpg, 1.4 + random(0.2), 0.4);
        }
        else if(poop >= 2 && chance(1, 3)){
            poop -= 2;
            o = "PizzaBoxCool";
            sound_play_pitchvol(sndEnergyHammerUpg, 1.4 + random(0.2), 0.4);
        }
        else poop--;

         // Excrete:
        with(obj_create(x + orandom(4), y + orandom(4), o)){
            hspeed = 3 * -other.right;
            vspeed = orandom(1);
            switch(o){
                case "PizzaBoxCool":
                    x += hspeed;
                    y += vspeed;
                    break;

                case HealthChest:
                    sprite_index = choose(sprPizzaChest1, sprPizzaChest2);
                    spr_dead = sprPizzaChestOpen;
                    break;
            }
        }
        hspeed += min(poop + 1, 4) * right;

        poop_delay = 8;
    }

     // He just keep movin
    if(poop <= 0 || poop_delay > 10) speed = maxspeed;
    if(place_meeting(x + hspeed, y + vspeed, Wall)){
        if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
        if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;
    }
    scrRight(direction);

#define CoolGuy_draw
    var _x = x,
        _y = y;

    if(poop > 0 && poop_delay < 20) _x += sin(current_frame * 5) * 1.5;
    draw_sprite_ext(sprite_index, image_index, _x, _y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);

#define CoolGuy_alrm0(_leaderDir, _leaderDis)
     // Follow Leader Around:
    if(instance_exists(leader)){
        if(_leaderDis > 24){
             // Pathfinding:
            if(array_length(path) > 0){
                direction = path_dir + orandom(20);
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


#define Mimic_create
     // Visual:
    spr_open = spr.PetMimicOpen;
    spr_hide = spr.PetMimicHide;
    depth = -1;
    
     // Vars:
    mask_index = mskFreak;
    maxspeed = 2;
    wep = wep_none;
    ammo = true;
    curse = false;
    open = false;
    hush = 0;
    hushtime = 0;
    player_push = false;
    mimic_pickup = scrPickupIndicator("");
    with(mimic_pickup) mask_index = mskWepPickup;

#define Mimic_anim
    if(sprite_index != spr_hurt || anim_end){
        if(speed > 0) sprite_index = spr_walk;
        else if(sprite_index != spr_walk || in_range(image_index, 3, 3 + image_speed)){
            if(instance_exists(leader)) sprite_index = spr_idle;
            else sprite_index = spr_hide;
        }
    }

#define Mimic_step
    if hushtime <= 0 hush = max(hush - 0.1, 0);
    hushtime -= current_time_scale;

    with(mimic_pickup) visible = false;

    if(instance_exists(leader)){
         // Open Chest:
        if(place_meeting(x, y, Player)){
            walk = 0;
            sprite_index = spr_open;
            if(!open){
                open = true;

                 // Drop Weapon:
                if(wep != wep_none){
                    with(instance_create(x, y, WepPickup)){
                        wep = other.wep;
                        ammo = other.ammo;
                        curse = other.curse;
                    }
                    wep = wep_none;
                }

                 // Effects:
                sound_play_pitchvol(sndGoldChest, 0.9 + random(0.2), 0.8 - hush);
                sound_play_pitchvol(sndMimicSlurp, 0.9 + random(0.2), 0.8 - hush);
                with(instance_create(x, y, FXChestOpen)) depth = other.depth - 1;
                hush = min(hush + 0.2, 0.4);
                hushtime = 60;
            }

             // Not Holding Weapon:
            if(wep == wep_none && !place_meeting(x, y, WepPickup)){
                with(mimic_pickup) visible = true;

                 // Place Weapon:
                with(Player) if(place_meeting(x, y, other) && button_pressed(index, "pick")){
                    if(canpick && wep != wep_none){
                        if(!curse){
                            with(instance_create(other.x, other.y, WepPickup)) wep = other.wep;
                            wep = wep_none;
                            scrSwap();

                             // Effects:
                            sound_play(sndSwapGold);
                            sound_play(sndWeaponPickup);
                            with(other) with(instance_create(x + orandom(4), y + orandom(4), CaveSparkle)){
                                depth = other.depth - 1;
                            }

                            break;
                        }
                        else sound_play(sndCursedReminder);
                    }
                }
            }
        }

         // Regrab Weapon:
        else if(open){
            open = false;
            if(wep == wep_none){
                if(place_meeting(x, y, WepPickup)){
                    with(nearest_instance(x, y, instances_matching(WepPickup, "visible", true))){
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
    }
    
     // Sparkle:
    if(frame_active(10 + orandom(2))){
        instance_create(x + orandom(12), y + orandom(12), CaveSparkle);
    }

#define Mimic_draw
    draw_self_enemy();

     // Wep Depth Fix:
    if(place_meeting(x, y, WepPickup)){
        with(WepPickup) if(place_meeting(x, y, other)){
            event_perform(ev_draw, 0);
        }
    }

#define Mimic_alrm0(_leaderDir, _leaderDis)
    if(instance_exists(leader)){
        if(_leaderDis > 48){
             // Pathfinding:
            if(array_length(path) > 0){
                scrWalk(15, path_dir);
                return 5 + random(10);
            }
            
             // Wander Toward Leader:
            else{
                scrWalk(20 + irandom(30), _leaderDir + orandom(10));
            }
        }
    }
    
    return 30 + irandom(30);

#define Mimic_hurt
    if(sprite_index != spr_open && (other.speed > 1 || !instance_is(other, projectile))){
        sprite_index = spr_hurt;
        image_index = 0;
    }


#define Parrot_create
     // Visual:
    depth = -3;

     // Vars:
    maxspeed = 3.5;
    perched = noone;
    pickup = noone;
    pickup_x = 0;
    pickup_y = 0;
    pickup_held = false;

#define Parrot_step
    if("wading" in self && (speed > 0 || instance_exists(perched))){
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
        }
    }
    else pickup_held = false;

     // Perching:
    if(instance_exists(perched)){
        can_take = false;
        x = perched.x;
        y = perched.y;
        if(
        	perched.speed > 0									||
        	instance_exists(pickup)								||
        	("race" in perched && perched.race == "horror") 	||
        	("my_health" in perched && perched.my_health <= 0)
        ){
            x = perched.x;
            y = perched.bbox_top - 8;
            perched = noone;
            scrWalk(16, random(360));
        }
    }
    else if(!instance_exists(leader)){
        can_take = true;
    }
    
     // Perch on Leader:
    else if(instance_exists(leader)){
    	if("race" not in leader || leader.race != "horror"){ // Horror is too painful to stand on
	        if(point_distance(x, y, leader.x, leader.bbox_top - 8) < 8 && leader.speed <= 0 && !instance_exists(pickup)){
	            perched = leader;
	            sound_play_pitch(sndBouncerBounce, 1.5 + orandom(0.1));
	        }
    	}
    }

#define Parrot_draw
     // Perched:
    if(instance_exists(perched)){
        var _uvsStart = sprite_get_uvs(perched.sprite_index, 0),
            _uvsCurrent = sprite_get_uvs(perched.sprite_index, perched.image_index),
            _x = x,
            _y = y - sprite_get_yoffset(perched.sprite_index) + sprite_get_bbox_top(perched.sprite_index) - 4;

         // Manual Bobbing:
        if(_uvsStart[0] == 0 && _uvsStart[2] == 1 && "parrot_bob" in perched){
            with(perched){
                var _bob = parrot_bob[floor(image_index mod array_length(parrot_bob))];
                if(is_array(_bob)){
                	if(array_length(_bob) > 0) _x += _bob[0];
                	if(array_length(_bob) > 1) _y += _bob[1];
                }
                else _y += _bob;
            }
        }

         // Auto Bobbing:
        else{
        	if(perched.sprite_index != sprMutant10Idle && perched.sprite_index != sprMutant4Idle){
        		_x += (_uvsCurrent[4] - _uvsStart[4]) * (("right" in perched) ? perched.right : 1);
        	}
        	_y += (_uvsCurrent[5] - _uvsStart[5]);
        }

        draw_sprite_ext(sprite_index, image_index, _x, _y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
    }

     // Normal:
    else draw_self_enemy();

#define Parrot_alrm0(_leaderDir, _leaderDis)
    if(instance_exists(leader)){
         // Fly Toward Pickup:
        if(instance_exists(pickup)){
            if(!pickup_held){
                scrWalk(8, point_direction(x, y, pickup.x, pickup.y));
                return walk;
            }
        }
        else{
            pickup_held = false;
            var _pickup = nearest_instance(x, y, instances_matching(Pickup, "object_index", AmmoPickup, HPPickup, RoguePickup))
            if(instance_exists(_pickup)){
                if(in_sight(_pickup)){
                    pickup = _pickup;
                    return 1;
                }
            }
        }

         // Fly Toward Leader:
        if(perched != leader){
             // Pathfinding:
            if(array_length(path) > 0){
                scrWalk(5 + random(5), path_dir + orandom(30));
                return walk;
            }

             // Wander Toward Leader:
            else{
                scrWalk(10 + random(10), _leaderDir + orandom(30));
                if(_leaderDis > 32) return walk;
            }
        }

         // Repeat sound:
        else if(chance(1, 4)) with(leader){
            sound_play_pitchvol(sndSaplingSpawn, 1.8 + random(0.2), 0.4);
            sound_play_pitchvol(choose(snd_wrld, snd_chst, snd_crwn), 2, 0.4);
            return 40 + random(20);
        }
    }

     // Look Around:
    if(!instance_exists(leader) || instance_exists(perched)){
        scrRight(random(360));
    }

    return (30 + random(30));

#define Parrot_hurt
    if(instance_exists(leader) && !instance_exists(perched) && (other.speed > 1 || !instance_is(other, projectile))){
        sprite_index = spr_hurt;
        image_index = 0;
    
         // Movin'
        if(speed <= 0){
            scrWalk(maxspeed, point_direction(other.x, other.y, x, y));
            var o = 6;
            x += lengthdir_x(o, direction);
            y += lengthdir_y(o, direction);
        }
    }


#define Scorpion_create
     // Visual:
    spr_dead   = spr.PetScorpionDead;
    spr_fire   = spr.PetScorpionFire;
    spr_shield = spr.PetScorpionShield;
    hitid = [spr_idle, "SILVER SCORPION"];
    
     // Sounds:
    snd_hurt =      sndScorpionHit;
    snd_dead =      sndScorpionDie;
    
     // Vars:
    mask_index = mskFrogEgg;
    maxhealth = 14;
    maxspeed = 3.6;
    my_health = maxhealth;
    my_corpse = noone;
    target = noone;
    nexthurt = 0;
    
#define Scorpion_anim
    if(my_health <= 0) sprite_index = spr_hurt;
    else{
        if((sprite_index != spr_hurt && sprite_index != spr_fire && sprite_index != spr_shield) || anim_end){
            if(speed <= 0) sprite_index = spr_idle;
            else sprite_index = spr_walk;
        }
    }
    
#define Scorpion_step
    if(my_health > 0){
         // Destroy Corpse:
        if(my_corpse != noone){
            with(my_corpse){
                repeat(4) scrFX([x, 8], [y, 8], 0, Smoke);
                instance_destroy();
            }
            my_corpse = noone;
        }

         // Collision:
        if(place_meeting(x, y, hitme) && sprite_index != spr_fire){
            with(instances_meeting(x, y, hitme)){
                if(place_meeting(x, y, other)){
                    if(size < other.size){
                        motion_add(point_direction(other.x, other.y, x, y), 1);
                    }
                    with(other){
                        motion_add(point_direction(other.x, other.y, x, y), 1);
                    }
                }
            }
        }
    }

     // Ded:
    else{
        x += (sin(current_frame / 10) / 3) * current_time_scale;
        y += (cos(current_frame / 10) / 3) * current_time_scale;

         // Corpse:
        if(my_corpse == noone){
            my_corpse = scrCorpse(direction, speed);
            motion_add(direction + orandom(20), speed * 2);

			 // Explode:
            var a = random(360);
            for(var d = a; d < a + 360; d += 360 / 5){
                 // Effects:
                with(instance_create(x, y, AcidStreak)){
                    motion_set(d, 4);
                    image_angle = direction;
                }
                
                 // Venom:
                repeat(8 + irandom(4)) scrEnemyShoot("VenomPellet", d + orandom(12), 8 + random(8));
            }

             // Death Sound:
            sound_play_pitchvol(snd_dead, 1.5 + random(0.3), 0.8);
        }

         // Revive:
        if(place_meeting(x, y, Player)){
            with(instance_nearest(x, y, Player)){
                projectile_hit_raw(id, 1, true);
                lasthit = [sprHealBigFX, "LOVE"];
            }
            my_health = maxhealth;
            sprite_index = spr_hurt;
            image_index = 0;

             // Effects:
            with(instance_create(x, y, HealFX)) depth = other.depth - 1;
            sound_play(sndHealthChestBig);
        }
    }
    
#define Scorpion_draw
    if(my_health > 0) draw_self_enemy();

     // Revive Mode:
    else draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha * 0.4);
    
#define Scorpion_alrm0(_leaderDir, _leaderDis)
    alarm0 = 20 + irandom(10);

    target = nearest_instance(x, y, instances_matching_ne(hitme, "team", team, 0));
    
    if(my_health > 0 && sprite_index != spr_shield){
        if(instance_exists(leader)){
            var _leaderSeeTarget;
            with(leader) _leaderSeeTarget = in_sight(other.target);
             // Pathfinding:
            if(array_length(path) > 0 && (!in_sight(target) || _leaderDis > 48)){
                scrWalk(4 + random(4), path_dir + orandom(10));
                return walk;
            }
            
            else{
                 // Follow leader:
                if(in_sight(leader) && _leaderDis > 28){
                    scrWalk(10 + irandom(20), _leaderDir + orandom(20));
                }
                
                if(instance_exists(target)){
                     // Attack target:
                    if(sprite_index != spr_fire && sprite_index != spr_shield){
                        if(in_sight(target) && _leaderSeeTarget && _leaderDis <= 96){
                            if(random(3) < 2){
                                sprite_index = spr_fire;
                                
                                sound_play_pitchvol(sndScorpionFireStart, 1.2, 0.8);
                                
                                var _targetDir = point_direction(x, y, target.x, target.y);
                                with(obj_create(x, y, "PetVenom")){
                                    creator = other;
                                    team = other.team;
                                    target = other.target;
                                }
                                scrRight(_targetDir);
                            }
                        }
                    }
                }
            }
        }
        
        else{
            scrWalk(10 + irandom(10), irandom(359));
            return 20 + irandom(20);
        }
    }
    
#define Scoprion_alrm1
    trace(argument0, argument1);
    
#define Scorpion_hurt
    if(my_health > 0){
         // Create CustomHitme to Receive the Damage:
        var s = ["x", "y", "speed", "direction", "sprite_index", "image_index", "my_health", "maxhealth", "nexthurt", "team", "walk", "spr_idle", "spr_walk", "spr_hurt", "spr_dead", "spr_fire", "spr_shield", "snd_hurt", "snd_dead"],
            h = instance_create(x, y, CustomHitme);

        h.on_hurt = ((sprite_index == spr_fire && instance_exists(leader)) ? enemyHurt : scrPetShield);

         // Transfer Pet's Vars:
        with(s){
            var _name = self;
            variable_instance_set(h, _name, variable_instance_get(other, _name, 0));
        }
    
         // Take Damage:
        with(other) with(h) with(other){
            event_perform(ev_collision, hitme);
        }

         // Set Pet's Vars & Destroy CustomHitme:
        with(s){
            var _name = self;
            variable_instance_set(other, _name, variable_instance_get(h, _name, 0));
        }
        instance_delete(h);
    }

#define scrPetShield(_hitdmg, _hitvel, _hitdir)
    sprite_index = spr_shield;
    image_index = 0;
    nexthurt = current_frame + 6;
    walk = 0;
    motion_add(_hitdir, 2);
    
    sound_play_hit(sndGoldScorpionHurt, 0);
    audio_sound_pitch(sndGoldScorpionHurt, 1.4 + random(0.4));
    
    sound_play_hit(sndCursedPickupDisappear, 0);
    audio_sound_pitch(sndCursedPickupDisappear, 0.8 + random(0.4));
    
    instance_create(x, y, ThrowHit).depth = -3;


#define Slaughter_create
     // Visual:
    spr_dead = spr.PetSlaughterDead;
    spr_fire = spr.PetSlaughterBite;
    hitid = [spr_idle, "SLAUGHTERFISH"];

     // Sound:
    snd_hurt = sndAllyHurt;
    snd_dead = sndFreakDead;

     // Vars:
    mask_index = mskFrogEgg;
    maxhealth = 30;
    maxspeed = 3.2;
    my_health = maxhealth;
    my_corpse = noone;
    my_bone = noone;
    target = noone;
    nexthurt = 0;

#define Slaughter_anim
    if(my_health <= 0) sprite_index = spr_hurt;
    else{
        if((sprite_index != spr_hurt && sprite_index != spr_fire) || anim_end){
            if(speed <= 0) sprite_index = spr_idle;
            else sprite_index = spr_walk;
        }
    }

#define Slaughter_step
    if(my_health > 0){
         // Destroy Corpse:
        if(my_corpse != noone){
            with(my_corpse){
                repeat(4) scrFX([x, 8], [y, 8], 0, Smoke);
                instance_destroy();
            }
            my_corpse = noone;
        }

         // Collision:
        if(place_meeting(x, y, hitme) && sprite_index != spr_fire){
            with(instances_meeting(x, y, hitme)){
                if(place_meeting(x, y, other)){
                    if(size < other.size){
                        motion_add(point_direction(other.x, other.y, x, y), 1);
                    }
                    with(other){
                        motion_add(point_direction(other.x, other.y, x, y), 1);
                    }
                }
            }
        }

         // Biting:
        if(sprite_index == spr_fire){
            if(image_index < 3){
                 // Drop Bone:
                with(my_bone){
                    hspeed = 3.5 * other.right;
                    vspeed = orandom(2);
                    rotspeed = random_range(8, 16) * choose(-1, 1);

                     // Unstick From Wall:
                    if(place_meeting(x, y, Wall)){
                        instance_create(x, y, Dust);
    
                        var _tries = 10;
                        while(place_meeting(x, y, Wall) && _tries-- > 0){
                
                            var w = instance_nearest(x, y, Wall),
                                _dir = point_direction(w.x + 8, w.y + 8, other.x, other.y);
                
                            while(place_meeting(x, y, w)){
                                x += lengthdir_x(4, _dir);
                                y += lengthdir_y(4, _dir);
                            }
                            xprevious = x;
                            yprevious = y;
                        }
                    }
                    instance_create(x, y, Dust);
                }
                my_bone = noone;
            }

             // Bite:
            else if(image_index < 3 + (image_speed * current_time_scale)){
                 // Attack Bite:
                if(instance_is(target, hitme)){
                	var r = 32;
                	with(instances_matching_ne(hitme, "team", team, 0)){
                		var _dmg = 0;
                		if(other.target == id){
                			_dmg = 8 + (3 * GameCont.level);
                		}
                		else if(collision_circle(other.x, other.y, r, id, false, false)){
                			_dmg = 8;
                		}

                		if(_dmg != 0) with(other){
                			projectile_hit(other, _dmg, 4, point_direction(x, y, other.x, other.y));
            			}
                	}
                    //scrEnemyShootExt(target.x, target.y, "PetBite", point_direction(x, y, target.x, target.y), 0);
                }
    
                 // Fetch Bone:
                else if(instance_is(target, WepPickup)){
                    with(target){
                        if(wep_get(wep) == "crabbone"){
                            other.my_bone = id;
                        }
                    }
                    sound_play_pitchvol(sndBloodGamble, 2 + orandom(0.2), 0.6);
                }
    
                 // Effects:
                sound_play_pitchvol(sndSharpTeeth, 1.5 + orandom(0.2), 0.5)
            }
        }

         // Fetching:
        if(instance_exists(my_bone)){
            var _x = x + hspeed + (10 * right),
                _y = y + vspeed + 2;

            with(my_bone){
                if(point_distance(x, y, _x, _y) > 2){
                    x += (_x - x) * 0.8;
                    y += (_y - y) * 0.8;
                }
                else{
                    x = _x;
                    y = _y;
                }
                xprevious = x;
                yprevious = y;
                speed = 0;
                rotation += (angle_difference((10 + (10 * sin((x + y) / 10))) * other.right, rotation) / 2) * current_time_scale;

                 // Portal Takes Bone:
                var n = instance_nearest(x, y, Portal);
                if(!visible || in_distance(n, 96)){
                    other.my_bone = noone;
                }
            }
        }
    }

     // Ded:
    else{
        x += (sin(current_frame / 10) / 3) * current_time_scale;
        y += (cos(current_frame / 10) / 3) * current_time_scale;

         // Corpse:
        if(my_corpse == noone){
            my_corpse = scrCorpse(direction, speed);
            motion_add(direction + orandom(20), speed * 2);

             // Death Sound:
            sound_play_pitchvol(snd_dead, 1.5 + random(0.3), 0.8);
        }

         // Revive:
        if(place_meeting(x, y, Player)){
            with(instance_nearest(x, y, Player)){
                projectile_hit_raw(id, 1, true);
                lasthit = [sprHealBigFX, "LOVE"];
            }
            my_health = maxhealth;
            sprite_index = spr_hurt;
            image_index = 0;

             // Effects:
            with(instance_create(x, y, HealFX)) depth = other.depth - 1;
            sound_play(sndHealthChestBig);
        }
    }

#define Slaughter_draw
    if(my_health > 0) draw_self_enemy();

     // Revive Mode:
    else draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha * 0.4);

#define Slaughter_alrm0(_leaderDir, _leaderDis)
    alarm0 = 20 + random(10);

    if(my_health > 0 && sprite_index != spr_fire){
        if(instance_exists(leader)){
             // Pathfinding:
            if(array_length(path) > 0 && (!in_sight(target) || _leaderDis > 96)){
                scrWalk(4 + random(4), path_dir + orandom(20));
                return walk;
            }

            else{
                if(in_sight(target) && point_distance(leader.x, leader.y, target.x, target.y) < 160 && target != my_bone){
                     // Bite:
                    if(distance_to_object(target) < (instance_is(target, WepPickup) ? 2 : 32) && (!instance_is(target, WepPickup) || target.visible)){
                        walk = 0;
                        speed = 0;
                        scrRight(point_direction(x, y, target.x, target.y));

                         // Visual:
                        sprite_index = spr_fire;
                        image_index = 0;
                        with(instance_create(x, y, RobotEat)){
                            sprite_index = spr.SlaughterBite;
                            image_xscale = other.right;
                            depth = other.depth - 0.1;
                        }
                    }

                     // Towards Enemy:
                    else{
                        scrWalk(8 + random(8), point_direction(x, y, target.x, target.y) + orandom(20));
                        alarm0 = 10;
                    }
                }

                 // Towards Leader:
                else{
                    if(_leaderDis > 48){
                        scrWalk(15 + random(10), _leaderDir + orandom(20));
                        if(instance_exists(my_bone)) walk = alarm0;
                    }
                    else if(!instance_exists(my_bone)){
                        scrWalk(8 + random(8), _leaderDir + orandom(90));
                    }
                }

                 // Targeting:
                if(sprite_index != spr_fire){
                    var _canTarget = [];
                    with(instances_matching_ne(hitme, "team", team)){
                        if(!instance_is(self, prop) && in_sight(other)){
                            array_push(_canTarget, id);
                        }
                    }
                    target = nearest_instance(x, y, _canTarget);
    
                     // Fetch:
                    if(!instance_exists(my_bone) && !in_sight(target)){
                        var _bones = [];
                        with(WepPickup) if(visible && wep_get(wep) == "crabbone"){
                            if(in_sight(other)){
                                array_push(_bones, id);
                            }
                        }
                        if(array_length(_bones) > 0){
                            target = nearest_instance(x, y, _bones);
                        }
                    }

                    else return 5 + random(10);
                }
            }
        }

         // Wander:
        else{
            scrWalk(8 + random(8), random(360));
            return 30 + random(10);
        }
    }

#define Slaughter_hurt
    if(my_health > 0){
         // Create CustomHitme to Receive the Damage:
        if(instance_exists(leader) || (sprite_index != spr_fire && "typ" in other && other.typ == 1)){
            var s = ["x", "y", "speed", "direction", "sprite_index", "image_index", "my_health", "maxhealth", "nexthurt", "leader", "team", "spr_idle", "spr_walk", "spr_hurt", "spr_dead", "spr_fire", "snd_hurt", "snd_dead", "depth", "right"],
                h = instance_create(x, y, CustomHitme);
    
            h.on_hurt = (instance_exists(leader) ? scrSlaughterHurt : scrSlaughterEat);
    
             // Transfer Pet's Vars:
            with(s){
                var _name = self;
                variable_instance_set(h, _name, variable_instance_get(other, _name, 0));
            }
        
             // Take Damage:
            with(other) with(h) with(other){
                event_perform(ev_collision, hitme);
            }
    
             // Set Pet's Vars & Destroy CustomHitme:
            with(s){
                var _name = self;
                variable_instance_set(other, _name, variable_instance_get(h, _name, 0));
            }
            instance_delete(h);
        }

		 // Dodge:
		else if(sprite_index != spr_fire){
			sprite_index = spr_fire;
			image_index = 3;
		}
    }

#define scrSlaughterHurt(_hitdmg, _hitvel, _hitdir)
     // Revenge:
    /*if(sprite_index != spr_hurt){
	    with(other) if("creator" in self && instance_exists(creator)){
	    	if(!instance_exists(other.leader) || self != other.leader){
	    		with(creator){
	    			repeat(4) instance_create(x + orandom(8), y + orandom(8), Bubble);
			        with(instance_create(x, y, SharpTeeth)){
			        	sprite_index = sprRobotEat;
			        	image_xscale = choose(-1, 1);
			            damage = _hitdmg + 2;
			            creator = other;
			            alarm0 = 8;
			        }
	    		}
	    	}
	    }
    }*/

     // Normal hurt:
    enemyHurt(_hitdmg, _hitvel, _hitdir);
    
     // Scared:
    alarm0 = max(alarm0, 20);
    scrRight(direction);
    repeat(ceil(_hitdmg / 4)) with(obj_create(x, y, "BubbleBomb")){
    	motion_add(90 + (90 * other.right) + orandom(8), 6);
    	team = other.team;

		 // Toot juice
		with(scrWaterStreak(x + (4 * other.right), y, direction + orandom(_hitdmg * 8), 4 + random(1))){
			vspeed += 2;
			image_xscale = 0.5;
			image_yscale = 0.5;
			image_speed *= 0.6;
		}
    }
    sound_play_pitchvol(sndFrogExplode, 1.4 + random(0.6), 0.8);

#define scrSlaughterEat(_hitdmg, _hitvel, _hitdir)
    if(!instance_exists(other) || ("typ" in other && other.typ != 0)){
        scrRight(direction);
        sprite_index = spr_fire;
        image_index = 2;
        walk = 0;
        with(instance_create(x, y, RobotEat)){
            sprite_index = spr.SlaughterBite;
            image_index = other.image_index;
            image_xscale = other.right;
            depth = other.depth - 0.1;
        }
    }


#define Spider_create
	
#define Spider_alrm0(_leaderDir, _leaderDis)
	alarm0 = 20 + irandom(20);
	
	if(instance_exists(leader)){
         // Pathfinding:
        if(array_length(path) > 0){
            scrWalk(5 + random(5), path_dir + orandom(30));
            return walk;
        }
        
        else{
			var _target = noone;
			
			 // Find Larget:	
			with(leader){
				var _enemies = [];
				with(enemy) if(in_sight(other) && in_distance(other, 256)){
					array_push(_enemies, id);
				}
				
				_target = nearest_instance(x, y, _enemies);
			}
				
			var t = array_length(instances_matching(instances_named(CustomProjectile, "SpiderTangle"), "creator", leader));
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
					scrWalk(20 + irandom(10), _leaderDir);
				}
				
				 // Wander:
				else{
					scrWalk(10 + irandom(10), direction + orandom(45));
				}
			}
        }
	}

#define Octo_create
     // Visual:
    spr_hide = spr.PetOctoHide;
    
     // Vars:
    friction = 0.1;
    arcing = 0;
    wave = 0;
    hiding = false;
    
#define Octo_anim
    if((sprite_index != spr_hurt) || anim_end){
        if(hiding) sprite_index = spr_hide;
        else{
            if(speed <= 0) sprite_index = spr_idle;
            else sprite_index = spr_walk;
        }
    }

#define Octo_step
    wave += current_time_scale;
    if(instance_exists(leader)){
         // Unhide:
        if(hiding){
            hiding = false;
        }
        
        var _lx = leader.x,
            _ly = leader.y,
            _leaderDir = point_direction(x, y, _lx, _ly),
            _leaderDis = point_distance(x, y, _lx, _ly);

        if(in_sight(leader) && _leaderDis < 90 + (45 * skill_get(mut_laser_brain))){
             // Lightning Arcing Effects:
            if(arcing < 1){
                arcing += 0.15 * current_time_scale;

                if(current_frame_active){
                    var _dis = random(_leaderDis),
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
            else lightning_connect(_lx, _ly, x, y, 8 * sin(wave / 60), false);
        }

         // Stop Arcing:
        else{
            if(arcing > 0){
                arcing = 0;
                sound_play_pitchvol(sndLightningReload, 0.7 + random(0.2), 0.5);

                repeat(2){
                    var _dis = random(point_distance(x, y, _lx, _ly)),
                        _dir = point_direction(x, y, _lx, _ly);

                    with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), PortalL)){
                        motion_add(random(360), 1);
                    }
                }
            }
        }
    }
    else arcing = 0;

    var h = hspeed + (sign(hspeed) * 8) * hiding,
        v = vspeed + (sign(vspeed) * 8) * hiding;

     // He is bouncy
    if(array_length(path) <= 0){
        if(place_meeting(x + h, y + v, Wall)){
            if(place_meeting(x + h, y, Wall)) hspeed *= -0.5;
            if(place_meeting(x, y + v, Wall)) vspeed *= -0.5;
            scrRight(direction);
        }
    }
    
    if(hiding){
         // Animation speed:
        if(image_index >= 29){
        	image_index -= 0.975 * image_speed * current_time_scale;
        }
        
         // Pit Collision:
        var f = floor_at(x + h, y + v);
        if(instance_exists(f.id) && f.sprite_index != spr.FloorTrenchB){
             // bounce off big floors:
            if(floor_at(x, y).sprite_index == spr.FloorTrenchB){
                if(place_meeting(x + h, y, f.id)) hspeed *= -1;
                if(place_meeting(x, y + v, f.id)) vspeed *= -1;
            }
        }
        
         // Slower:
        speed = clamp(speed, 0, 2.6);
    }

#define Octo_draw
    if(!hiding){
        draw_self_enemy();
        
         // Air Bubble:
        if(array_length(instances_matching(CustomDraw, "name", "underwater_draw")) <= 0){
            draw_sprite(sprPlayerBubble, -1, x, y);
        }
    }

#define Octo_alrm0(_leaderDir, _leaderDis)
    if(instance_exists(leader)){
         // Follow Leader Around:
        if(_leaderDis > 64 || !in_sight(leader)){
             // Pathfinding:
            if(array_length(path) > 0){
                scrWalk(5 + random(5), path_dir + orandom(10));
            }

             // Toward Leader:
            else{
                scrWalk(5 + random(10), _leaderDir + orandom(20));
            }

            return walk + random(10);
        }

         // Idle Around Leader:
        else{
            motion_add(_leaderDir + orandom(60), 1.5 + random(1.5));
            scrRight(direction);
            return 30 + random(10);
        }
    }
        
    else{
         // Find trench pit:
        if(GameCont.area == "trench"){
            var _n = nearest_instance(x, y, instances_matching(Floor, "sprite_index", spr.FloorTrenchB)),
            	f = floor_at(x, y);

            if(instance_exists(_n) || (f.sprite_index != spr.FloorTrenchB && hiding)){
                 // Hide:
                if(f.sprite_index == spr.FloorTrenchB && !hiding){
                    hiding = true;
                    
                    sprite_index = spr_hide;
                    image_index = 0;
                    
                     // Effects:
                    repeat(4 + irandom(4)) instance_create(x, y, Bubble);
                }
                
                 // Move toward pit:
                else if(in_sight(_n)){
                    scrWalk(10 + random(5), point_direction(x, y, _n.x, _n.y));
                    scrRight(direction);
                    return walk + random(5);
                }
            }
        }

         // Idle Movement:
        instance_create(x, y, Bubble);
        
        scrWalk(5 + random(10), direction + orandom(60));
        if(random(5) < 2) return walk + 45;
        return walk + 10;
    }

#define Octo_hurt
    if(!hiding){
        if(other.speed > 1 || !instance_is(other, projectile)){
            sprite_index = spr_hurt;
            image_index = 0;
        
             // Movin'
            scrWalk(10, point_direction(other.x, other.y, x, y));
            scrRight(direction + 180);
        }
    }


#define Prism_create
     // Visual:
    depth = -3;

     // Vars:
    mask_index = mskFrogEgg;
    maxspeed = 2.5;
    spawn_loc = [x, y];
    alarm0 = -1;
    
#define Prism_step
    if(instance_exists(leader)){
        spawn_loc = [x, y];

        scrWalk(1, direction); // Aimlessly floats
        
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
            can_prism_duplicate = false;
            if("prism_duplicate" not in self){
                prism_duplicate = false;
            }

            if(distance_to_object(other) < 8){
                if(!prism_duplicate && object_index != ThrownWep){
                    prism_duplicate = true;
                    other.speed *= 0.5;
        
                     // Slice FX:
                    var _dir = random(360),
                        o = 6;
    
                    for(var _dis = o; _dis >= -o; _dis -= 2){
                        with(instance_create(other.x + lengthdir_x(_dis, _dir) + orandom(0), other.y + lengthdir_y(_dis, _dir), BoltTrail)){
                            motion_add(_dir, 1);
                            image_angle = _dir;
                            image_xscale = 2;
                            image_yscale = 1 + (1 * (1 - ((_dis + o) / (o * 2))));
                            depth = -4;
                        }
                    }
                    instance_create(x + orandom(16), y + orandom(16), CaveSparkle);
                    sound_play_pitch(sndCrystalShield, 1.4 + orandom(0.1));
        
                     // Duplicate:
                    var _copy = instance_copy(false);
                    switch(_copy.object_index){
                        case Laser:
                            var l = point_distance(xstart, ystart, other.x, other.y),
                                d = image_angle;
    
                            with(_copy){
                                x = other.xstart + lengthdir_x(l, d);
                                y = other.ystart + lengthdir_y(l, d);
                                xstart = x;
                                ystart = y;
                                image_angle += orandom(20);
                                event_perform(ev_alarm, 0);
                            }
                            break;
        
                        case Lightning:
                            with(_copy){
                                image_index = 0;
                                image_angle += orandom(20);
                                event_perform(ev_alarm, 0);
                                with(Lightning) prism_duplicate = true;
                            }
                            break;
        
                        default:
                            var _off = random_range(4, 16);
                            with([id, _copy]){
                                direction += _off;
                                image_angle += _off;
                                _off *= -1;
                            }
                    }
                }
                else if(speed > 1){
                    sound_play_pitch(sndCursedReminder, 1.5);
                }
            }
        }
        var _prism = instances_named(object_index, name);
        with(instances_matching(projectile, "can_prism_duplicate", false)){
            if(array_length(instance_rectangle_bbox(bbox_left - 16, bbox_top - 16, bbox_right + 16, bbox_bottom + 16, _prism)) <= 0){
                can_prism_duplicate = true;
            }
        }

         // TP Around Player:
        var _dis = 96,
            _x = x,
            _y = y;

        if(!in_distance(leader, _dis)){
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
                with(instance_create(x, y, ThrowHit)) depth = other.depth - 1;
                sound_play_pitchvol(sndCrystalTB, 1.2 + orandom(0.1), 0.8);
            }
        }
    }
    else{
        x += sin(current_frame / 10) * 0.4 * current_time_scale;
        y += cos(current_frame / 10) * 0.4 * current_time_scale;

         // Jitters Around:
        if(chance(1, 30) && instance_exists(Floor)){
             // Decide Which Floor:
            var f = instance_nearest(spawn_loc[0] + orandom(64), spawn_loc[1] + orandom(64), Floor),
                _fx = (f.bbox_left + f.bbox_right) / 2,
                _fy = (f.bbox_top + f.bbox_bottom) / 2;
            
             // Teleport:
            x = _fx;
            y = _fy;
            
             // Effects:
            with(instance_create(x, y, ThrowHit)) depth = other.depth - 1;
            if(point_seen(x, y, player_find_local_nonsync())){
                sound_play_pitch(sndCrystalTB, 1.2 + orandom(0.1));
            }
        }
    }

     // Bouncin:
    if(place_meeting(x + hspeed, y + vspeed, Wall)){
        if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
        if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;
        direction += orandom(20);
    }

     // Effects:
    if(chance_ct(1, 3)) repeat(irandom(4)){
        instance_create(x + orandom(8), y + orandom(8), Curse);
    }


/// Scripts
#define orandom(n)																		return  random_range(-n, n);
#define chance(_numer, _denom)															return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)														return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj);
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
#define instances_named(_object, _name)                                                 return  mod_script_call(   "mod", "telib", "instances_named", _object, _name);
#define nearest_instance(_x, _y, _instances)                                            return  mod_script_call(   "mod", "telib", "nearest_instance", _x, _y, _instances);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc("mod", "telib", "instance_rectangle", _x1, _y1, _x2, _y2, _obj);
#define instances_seen(_obj, _ext)                                                      return  mod_script_call(   "mod", "telib", "instances_seen", _obj, _ext);
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
#define unlock_get(_unlock)                                                             return  mod_script_call(   "mod", "telib", "unlock_get", _unlock);
#define unlock_set(_unlock, _value)                                                             mod_script_call(   "mod", "telib", "unlock_set", _unlock, _value);
#define scrUnlock(_name, _text, _sprite, _sound)                                        return  mod_script_call(   "mod", "telib", "scrUnlock", _name, _text, _sprite, _sound);
#define area_get_subarea(_area)                                                         return  mod_script_call(   "mod", "telib", "area_get_subarea", _area);
#define trace_lag()                                                                             mod_script_call(   "mod", "telib", "trace_lag");
#define trace_lag_bgn(_name)                                                                    mod_script_call(   "mod", "telib", "trace_lag_bgn", _name);
#define trace_lag_end(_name)                                                                    mod_script_call(   "mod", "telib", "trace_lag_end", _name);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call(   "mod", "telib", "instance_rectangle_bbox", _x1, _y1, _x2, _y2, _obj);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   "mod", "telib", "instances_meeting", _x, _y, _obj);
#define array_delete(_array, _index)                                                    return  mod_script_call_nc("mod", "telib", "array_delete", _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call_nc("mod", "telib", "array_delete_value", _array, _value);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "instances_at", _x, _y, _obj);
#define Pet_spawn(_x, _y, _name)                                                        return  mod_script_call(   "mod", "telib", "Pet_spawn", _x, _y, _name);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc("mod", "telib", "scrFX", _x, _y, _motion, _obj);
#define array_combine(_array1, _array2)                                                 return  mod_script_call(   "mod", "telib", "array_combine", _array1, _array2);
#define player_create(_x, _y, _index)                                                   return  mod_script_call(   "mod", "telib", "player_create", _x, _y, _index);
#define draw_set_flat(_color)                                                                   mod_script_call(   "mod", "telib", "draw_set_flat", _color);
#define trace_error(_error)                                                                     mod_script_call_nc("mod", "telib", "trace_error", _error);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc("mod", "telib", "sleep_max", _milliseconds);
#define array_clone_deep(_array)                                                        return  mod_script_call_nc("mod", "telib", "array_clone_deep", _array);
#define lq_clone_deep(_obj)                                                             return  mod_script_call_nc("mod", "telib", "lq_clone_deep", _obj);
#define array_exists(_array, _value)                                                    return  mod_script_call_nc("mod", "telib", "array_exists", _array, _value);