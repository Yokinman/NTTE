#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.save = mod_variable_get("mod", "teassets", "save");

    global.objectMods = ["tegeneral", "tedesert", "tecoast", "teoasis", "tetrench", "tesewers", "tecaves"];

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.save

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)

#define obj_create(_x, _y, obj_name)
    var o = noone,
        _name = string_upper(string(obj_name));

    switch(obj_name){
        //#region GENERAL
        	case "BigDecal":
        	    var a = string(GameCont.area);
        	    if(lq_exists(spr.BigTopDecal, a)){
            	    o = instance_create(_x, _y, CustomObject);
            		with(o){
            		     // Visual:
            		    sprite_index = lq_get(spr.BigTopDecal, a);
            			image_xscale = choose(-1, 1);
            			image_speed = 0.4;
            			depth = -8;

                         // Vars:
                		mask_index = msk.BigTopDecal;

                         // Avoid Bad Stuff:
                        var _tries = 1000;
            		    while(_tries-- > 0){
            		        if(place_meeting(x, y, TopPot) || place_meeting(x, y, Bones) || place_meeting(x, y, Floor)){
            		            var _dis = 16,
            		                _dir = irandom(3) * 90;

            		            x += lengthdir_x(_dis, _dir);
            		            y += lengthdir_y(_dis, _dir);
            		        }
            		        else break;
            		    }

                         // TopSmalls:
                		var _off = 16,
                		    s = _off * 3;

                		for(var _ox = -s; _ox <= s; _ox += _off){
                		    for(var _oy = -s; _oy <= s; _oy += _off){
                		        if(!position_meeting(x + _ox, y + _oy, Floor)){
                		            if(random(2) < 1) instance_create(x + _ox, y + _oy, TopSmall);
                		        }
                		    }
                		}

                		 // TopDecals:
                		var _num = irandom(4),
                		    _ang = random(360);

                		for(var i = _ang; i < _ang + 360; i += (360 / _num)){
                		    var _dis = 24 + random(12),
                		        _dir = i + orandom(30);

                            with(scrTopDecal(0, 0, GameCont.area)){
                                x = other.x + lengthdir_x(_dis * 1.5, _dir);
                                y = other.y + lengthdir_y(_dis, _dir) + 40;
                                if(place_meeting(x, y, Floor)) instance_destroy();
                            }
                		}
            		}
        	    }
        	    break;

        	case "BubbleBomb":
        	    o = instance_create(_x, _y, CustomProjectile);
        	    with(o){
        	         // Visual:
        	        sprite_index = spr.BubbleBomb;
        	        image_speed = 0.5;
        	        depth = -2;

        	         // Vars:
        	        mask_index = mskSuperFlakBullet;
        	        z = 0;
        	        zspeed = -0.5;
        	        zfric = -0.02;
        	        friction = 0.4;
        	        damage = 0;
        	        force = 2;
        	        typ = 1;
        	        my_projectile = noone;
        	    }
        	    break;

              case "SuperBubbleBomb":
            	    o = instance_create(_x, _y, CustomProjectile);
            	    with(o){
            	         // Visual:
            	        sprite_index = spr.BubbleBomb;
                      image_xscale = 2
                      image_yscale = 2
                      image_speed = .5;
            	        depth = -2;

            	         // Vars:
            	        mask_index = mskSuperFlakBullet;
            	        z = 0;
            	        zspeed = -0.5;
            	        zfric = -0.02;
            	        friction = 0.4;
            	        damage = 0;
            	        force = 2;
            	        typ = 1;
            	        my_projectile = noone;
            	    }
            	    break;

            case "BubbleExplosion":
                o = instance_create(_x, _y, PopoExplosion);
                with(o){
                    sprite_index = spr.BubbleExplode;
                    mask_index = mskExplosion;
                    hitid = [sprite_index, "BUBBLE EXPLO"];
                    damage = 3;
                    force = 1;
                    alarm0 = -1; // No scorchmark
                }

                 // Effects:
                repeat(10) instance_create(_x, _y, Bubble);
                sound_play_pitch(sndExplosionS, 2);
                sound_play_pitch(sndOasisExplosion, 1 + random(1));
                 // Crown of Explosions:
                if GameCont.crown == 2
                    if fork(){
                        wait(0);
                        repeat(choose(2,3))
                            with obj_create(_x,_y,"SmallBubbleExplosion") if instance_exists(o)
                                team = o.team;
                        exit;
                    }
                break;

            case "CustomChest":
                o = instance_create(_x, _y, chestprop);
                with(o){
                     // Visual:
                    sprite_index = sprAmmoChest;
                    spr_open = sprAmmoChestOpen;

                     // Sound:
                    snd_open = sndAmmoChest;

                    on_step = ["", "", ""];
                    on_open = ["", "", ""];

                    with(script_bind_step(0, 0)){
                        script = script_ref_create_ext("mod", "tegeneral", "CustomChest_step");
                        creator = other;
                    }
                }
                break;

            case "Harpoon":
                o = instance_create(_x, _y, CustomProjectile);
                with(o){
                    sprite_index = spr.Harpoon;
                    image_speed = 0;
                    mask_index = mskBolt;

                     // Vars:
    				creator = noone;
    				target = noone;
    				rope = noone;
    				pull_speed = 0;
    				canmove = 1;
    				damage = 3;
    				force = 8;
    				typ = 1;
    				blink = 30;
                }
                break;

            case "LightningDisc":
                o = instance_create(_x, _y, CustomProjectile);
                with(o){
                     // Visual:
                    sprite_index = sprLightning;
                    image_speed = 0.4;
                    depth = -3;

                     // Vars:
                    mask_index = mskWepPickup;
                    rotspeed = random_range(10, 20) * choose(-1, 1);
                    rotation = 0;
                    radius = 12;
                    charge = 1;
                    charge_spd = 1;
                    ammo = 10;
                    typ = 0;
                    shrink = 1/160;
                    maxspeed = 2.5;
                    is_enemy = false;
                    image_xscale = 0;
                    image_yscale = 0;
                    stretch = 1;
                    super = -1; //describes the minimum size of the ring to split into more rings, -1 = no splitting
                    creator_follow = true;
                }
                break;

            case "LightningDiscEnemy":
                o = obj_create(_x, _y, "LightningDisc");
                with(o){
                     // Visual:
                    sprite_index = sprEnemyLightning;

                     // Vars:
                    is_enemy = true;
                    maxspeed = 2;
                    radius = 16;
                }
                break;

            case "NetNade":
                o = instance_create(_x, _y, CustomProjectile);
                with(o){
                    sprite_index = spr.NetNade;
                    image_speed = 0.4;
                    mask_index = sprGrenade;

                     // Vars:
                    friction = 0.4;
                    creator = noone;
                    lasthit = noone;
                    damage = 10;
                    force = 4;
                    typ = 1;

                    alarm0 = 60;
                }
                break;

            case "ParrotFeather":
                o = instance_create(_x, _y, CustomObject);
                with(o){
                     // Visual:
                    //sprite_index = spr.Parrot[0].Feather;
                    sprite_index = mskNone;
                    depth = -8;

                     // Vars:
                    mask_index = mskLaser;
                    creator = noone;
                    target = noone;
                    bskin = 0;
                    stick = false;
                    stickx = 0;
                    sticky = 0;
                    stick_time = 30;
                    fall = 30 + random(40);
                    rot = orandom(3);
                    canhold = true;

                     // Push:
                    motion_add(random(360), 4 + random(2));
                    image_angle = direction + 135;
                    
                     // Spriterize:
                    if(fork()){
                        wait 1;
                        if(instance_exists(self)){
                            sprite_index = spr.Parrot[bskin].Feather;
                        }
                        exit;
                    }
                }
                break;

            case "ParrotChester":
                o = instance_create(_x, _y, CustomObject)
                with(o){
                     // Vars:
                    creator = noone;
                    num = 1;
                }
                break;

            case "SmallBubbleExplosion":
                o = instance_create(_x, _y, SmallExplosion);
                with(o){
                    sprite_index = spr.BubbleExplode;
                    mask_index = mskExplosion;
                    image_xscale = 0.5; // Bad!
                    image_yscale = 0.5; // Lazy!
                    hitid = [sprite_index,"BUBBLE EXPLO"];
                    damage = 3;
                    force = 1;
                    alarm0 = -1; // No scorchmark
                }
                 // Effects:
                repeat(10) instance_create(_x, _y, Bubble);
                sound_play_pitch(sndOasisExplosionSmall, 1 + random(2));
                break;

            case "Pet":
                o = instance_create(_x, _y, CustomObject);
                with(o){
                     // Visual:
                    spr_idle = spr.PetParrotIdle;
                    spr_walk = spr.PetParrotWalk;
                    spr_hurt = spr.PetParrotHurt;
                    spr_shadow = shd16;
                    spr_shadow_x = 0;
                    spr_shadow_y = 4;
                    mask_index = mskPlayer;
                    image_speed = 0.4;
                    right = choose(1, -1);
                    depth = -2;

                     // Sound:
                    snd_hurt = sndFrogEggHurt;

                     // Vars:
                    pet = "Parrot";
                    leader = noone;
                    can_take = true;
                    can_path = true;
                    path = [];
                    path_dir = 0;
                    team = 2;
                    walk = 0;
                    walkspd = 2;
                    maxspd = 3;
                    friction = 0.4;
                    direction = random(360);
                    pickup_indicator = noone;
                    surf_draw = -1;
                    surf_draw_w = 64;
                    surf_draw_h = 64;

                    //can_tp = true;
                    //tp_distance = 240;

                    alarm0 = 20 + random(10);
                }
                break;

            case "PizzaBoxCool":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = sprPizzaBox;
                    spr_hurt = sprPizzaBoxHurt;
                    spr_dead = sprPizzaBoxDead;

                     // Sound:
                    snd_hurt = sndHitPlant;
                    snd_dead = sndPizzaBoxBreak;

                     // Vars:
                    maxhealth = 4;
                    size = 1;
                }
                break;

            case "scrTopDecal":
                return scrTopDecal(_x, _y, GameCont.area);
        //#endregion

        //#region DESERT
            case "BabyScorpion":
        	    o = instance_create(_x, _y, CustomEnemy);
        		with(o){
                     // Visual:
        			spr_idle = spr.BabyScorpionIdle;
        			spr_walk = spr.BabyScorpionWalk;
        			spr_hurt = spr.BabyScorpionHurt;
        			spr_dead = spr.BabyScorpionDead;
        			spr_fire = spr.BabyScorpionFire;
        			spr_shadow = shd24;
        			spr_shadow_y = -1;
        			hitid = [spr_idle, _name];
        			mask_index = mskBandit;
        			depth = -2;

        			 // Sound:
        			snd_hurt = sndScorpionHit;
        			snd_dead = sndScorpionDie;
        			snd_fire = sndScorpionFireStart;

        			 // Vars:
        			gold = false;
        			maxhealth = 7;
        			raddrop = 4;
        			size = 1;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 2.4;
        			gunangle = random(360);
        			direction = gunangle;

                     // Alarms:
        			alarm1 = 40 + irandom(30);
        		}
            	break;

            case "BabyScorpionGold":
                o = obj_create(_x, _y, "BabyScorpion");
                with(o){
                     // Visual:
        			spr_idle = spr.BabyScorpionGoldIdle;
        			spr_walk = spr.BabyScorpionGoldWalk;
        			spr_hurt = spr.BabyScorpionGoldHurt;
        			spr_dead = spr.BabyScorpionGoldDead;
        			spr_fire = spr.BabyScorpionGoldFire;
        			spr_shadow = shd24;
        			hitid = [spr_idle, _name];
        			sprite_index = spr_idle;
        			mask_index = mskBandit;
        			depth = -2;

        			 // Sound:
        			snd_hurt = sndGoldScorpionHurt;
        			snd_dead = sndGoldScorpionDead;
        			snd_fire = sndGoldScorpionFire;

        			 // Vars:
        			gold = true;
        			maxhealth = 16;
        			my_health = maxhealth;
        			raddrop = 14;
                }
                break;

            case "Bone":
                o = instance_create(_x, _y, CustomProjectile);
                with(o){
                     // Visual:
                    sprite_index = spr.Bone;
                    hitid = [sprite_index, _name];

                     // Vars:
                    mask_index = mskFlakBullet;
                    friction = 1;
                    damage = 50;
                    force = 1;
                    typ = 1;
                    creator = noone;
                    rotation = 0;
                    rotspeed = (1 / 3) * choose(-1, 1);
                    broken = false;

                     // Annoying Fix:
                    if(place_meeting(x, y, PortalShock)){
                        mod_script_call("mod", "tedesert", "Bone_destroy");
                    }
                }
                break;

            case "BoneSpawner":
                o = instance_create(_x, _y, CustomObject);
                with(o) creator = noone;
                break;

            case "CoastBossBecome":
                o = instance_create(_x, _y, CustomHitme);
                with(o){
                     // Visual:
                    spr_idle = spr.BigFishBecomeIdle;
                    spr_hurt = spr.BigFishBecomeHurt;
                    spr_dead = sprBigSkullDead;
                    spr_shadow = shd32;
                    image_speed = 0;
                    depth = -1;

                     // Sound:
                    snd_hurt = sndHitRock;
                    snd_dead = -1;

                     // Vars:
                    mask_index = mskScorpion;
                    maxhealth = 50 + (100 * GameCont.loops);
                    size = 2;
                    part = 0;
                }
                break;

        	case "CoastBoss":
        	    o = instance_create(_x, _y, CustomEnemy);
        	    with(o){
        	         // For Sani's bosshudredux:
        	        boss = 1;
        	        bossname = "BIG FISH";
        	        col = c_red;

        	        /// Visual:
        	            spr_spwn = spr.BigFishSpwn;
            	        spr_idle = sprBigFishIdle;
            			spr_walk = sprBigFishWalk;
            			spr_hurt = sprBigFishHurt;
            			spr_dead = sprBigFishDead;
        			    spr_weap = mskNone;
        			    spr_shad = shd48;
            			spr_shadow = spr_shad;
            			hitid = [spr_idle, "BIG FISH"];
            			sprite_index = spr_spwn;
        			    depth = -2;

            			 // Fire:
            			spr_chrg = sprBigFishFireStart;
            			spr_fire = sprBigFishFire;
            			spr_efir = sprBigFishFireEnd;

            			 // Swim:
            			spr_dive = spr.BigFishLeap;
            			spr_rise = spr.BigFishRise;

                     // Sound:
            		snd_hurt = sndOasisBossHurt;
            		snd_dead = sndOasisBossDead;

        			 // Vars:
            		mask_index = mskBigMaggot;
        			maxhealth = scrBossHP(150);
        			raddrop = 50;
        			size = 3;
        			meleedamage = 3;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 3;
        			ammo = 4;
        			swim = 0;
        			swim_target = noone;
        			gunangle = random(360);
        			direction = gunangle;
        			intro = false;
        			swim_ang_frnt = direction;
        			swim_ang_back = direction;
        			shot_wave = 0;
        			fish_train = [];
        			fish_swim = [];
        			fish_swim_delay = 0;
        			fish_swim_regen = 0;
        			for(var i = 0; i < (GameCont.loops * 3); i++) fish_train[i] = noone;

        			 // Alarms:
        			alarm1 = 90;
        			alarm2 = -1;
        			alarm3 = -1;
        	    }
        	    break;
        //#endregion

        //#region COAST
            case "BloomingCactus":
                o = instance_create(_x, _y, Cactus);
                with(o){
                    var s = irandom(array_length(spr.BloomingCactusIdle) - 1);
                    spr_idle = spr.BloomingCactusIdle[s];
                    spr_hurt = spr.BloomingCactusHurt[s];
                    spr_dead = spr.BloomingCactusDead[s];
                }
                break;

            case "BuriedCar":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = spr.BuriedCarIdle;
                    spr_hurt = spr.BuriedCarHurt;
                    spr_dead = mskNone;
                    spr_shadow = mskNone;

                     // Sound:
                    snd_hurt = sndHitMetal;

                     // Vars:
                    size = 2;
                    maxhealth = 20;
                    my_floor = instance_nearest(x - 16, y - 16, Floor);
                }
                break;

            case "CoastDecal":
            case "CoastBigDecal":
                return mod_script_call("mod", "tecoast", "CoastDecal_create", _x, _y, (obj_name == "CoastBigDecal"));

            case "Creature":
        	    o = instance_create(_x, _y, CustomHitme);
        	    with(o){
        	         // visual
        	        spr_idle = spr.CreatureIdle;
        	        spr_walk = spr_idle;
        	        spr_hurt = spr.CreatureHurt;
        	        spr_bott = spr.CreatureBott;
        	        spr_foam = spr.CreatureFoam;
        	        image_speed = 0.4;
        	        depth = -3;

        	         // sounds
        	        snd_hurt = sndOasisBossHurt;

        	         // variables
        	        mask_index = spr_foam;
        	        friction = 0.4;
        	        maxhealth = 999999999;
        	        size = 8;
        	        team = 1;
        	        nowade = true;
        	        right = choose(-1, 1);
        	        walk = 0;
        			walkspd = 1.2;
        			maxspd = 2.6;
        			scared = false;

        			 // alarms
        			alarm1 = 30;
        	    }
        	    break;

        	case "Diver":
        	    o = instance_create(_x, _y, CustomEnemy);
        		with(o){
                     // Visual:
        			spr_idle = spr.DiverIdle;
        			spr_walk = spr.DiverWalk;
        			spr_hurt = spr.DiverHurt;
        			spr_dead = spr.DiverDead;
        			spr_weap = spr.HarpoonGun;
        			spr_shadow = shd24;
        			hitid = [spr_idle, _name];
        			depth = -2;

        			 // Sound:
        			snd_hurt = sndHitMetal;
        			snd_dead = sndAssassinDie;

        			 // Vars:
        			mask_index = mskBandit;
        			maxhealth = 12;
        			raddrop = 4;
        			size = 1;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 3;
        			gunangle = random(360);
        			direction = gunangle;
        			canshoot = false;
        			reload = 0;

                     // Alarms:
        			alarm1 = 90 + irandom(60);
        		}
            	break;

            case "DiverHarpoon":
    			o = instance_create(_x, _y, CustomProjectile);
    			with(o){
                     // Visual:
    			    sprite_index = sprBolt;

                     // Vars:
    			    mask_index = mskBolt;
    				creator = noone;
    				damage = 4;
    				force = 8;
    				typ = 2;
    			}
        		break;

        	case "Gull":
        	    o = instance_create(_x, _y, CustomEnemy);
        		with(o){
                     // Visual:
        			spr_idle = spr.GullIdle;
        			spr_walk = spr.GullWalk;
        			spr_hurt = spr.GullHurt;
        			spr_dead = spr.GullDead;
        			spr_weap = spr.GullSword;
        			spr_shadow = shd24;
        			hitid = [spr_idle, _name];
        			depth = -2;

                     // Sound:
                    snd_hurt = sndRavenHit;
                    snd_dead = sndAllyDead;

                     // Vars:
        			mask_index = mskBandit;
        			maxhealth = 8;
        			raddrop = 3;
        			size = 1;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 3.5;
        			gunangle = random(360);
        			direction = gunangle;
        			wepangle = choose(-140, 140);

                     // Alarms:
        			alarm1 = 60 + irandom(60);
        			alarm2 = -1;
        		}
            	break;

            case "Palanking":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // For Sani's bosshudredux:
        	        boss = 1;
        	        bossname = "PALANKING";
        	        col = c_red;

        	         // Visual:
    	            spr_bott = spr.PalankingBott;
    	            spr_taun = spr.PalankingTaunt;
    	            spr_call = spr.PalankingCall;
        	        spr_idle = spr.PalankingIdle;
        			spr_walk = spr.PalankingWalk;
        			spr_hurt = spr.PalankingHurt;
        			spr_dead = spr.PalankingDead;
        			spr_burp = spr.PalankingBurp;
        			spr_fire = spr.PalankingFire;
        			spr_foam = spr.PalankingFoam;
    			    spr_shadow_hold = shd64B; // Actually a good use for this shadow hell yeah
    			    spr_shadow = mskNone;
                    spr_shadow_y = 24;
        			hitid = [spr_idle, "SEAL KING"];
    			    depth = -3;

                     // Sound:
            		snd_hurt = snd.PalankingHurt;
            		snd_dead = snd.PalankingDead;

        			 // Vars:
            		mask_index = mskNone;
            		mask_hold = msk.Palanking;
        			maxhealth = scrBossHP(350);
        			raddrop = 80;
        			size = 4;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 2;
        			ammo = 0;
        			canmelee = 0;
        			meleedamage = 4;
        			ground_smash = 0;
        			gunangle = random(360);
        			direction = gunangle;
        			nowade = true;
        			active = false;
        			intro = false;
        			intro_pan = 0;
        			intro_pan_x = x;
        			intro_pan_y = y;
                    seal = [];
                    seal_x = [];
                    seal_y = [];
                    seal_max = 4 + (2 * GameCont.loops);
                    seal_group = 0;
                    seal_spawn = 0;
                    seal_spawn_x = x;
                    seal_spawn_y = y;
                    tauntdelay = 40;
                    phase = -1;
        	        z = 0;
        	        zspeed = 0;
        	        zfric = 1;
        	        zgoal = 0;
        	        corpse = false;
                }
                break;

            case "PalankingDie":
                o = instance_create(_x, _y, CustomObject);
                with(o){
                     // Visual:
                    sprite_index = spr.PalankingHurt;
                    spr_dead = spr.PalankingDead;
                    image_speed = 0.4;
                    image_alpha = 0; // Cause customobjects draw themselves even if you have a custom draw event >:(
    			    depth = -3;

    			     // Vars:
    			    friction = 0.4
                    size = 3;
        	        z = 0;
        	        zspeed = 9;
        	        zfric = 1;
        	        raddrop = 80;
        	        snd_dead = snd.PalankingDead;
                }
                break;

            case "Palm":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = spr.PalmIdle;
                    spr_hurt = spr.PalmHurt;
                    spr_dead = spr.PalmDead;
                    spr_shadow = -1;
                    depth = -2 - (y / 20000);

                     // Sound:
                    snd_hurt = sndHitRock;
                    snd_dead = sndHitPlant;

                     // Vars:
                    mask_index = mskStreetLight;
                    maxhealth = 30;
                    size = 2;
                    my_enemy = noone;
                    my_enemy_mask = mskNone;

                     // Fortify:
                    if(random(8) < 1){
                        my_enemy = obj_create(x, y, "Diver");
                        with(my_enemy) depth = -3;

                        spr_idle = spr.PalmFortIdle;
                        spr_hurt = spr.PalmFortHurt;
                        snd_dead = sndGeneratorBreak;
                        maxhealth = 40;
                    }
                }
                break;

        	case "Pelican":
        	    o = instance_create(_x, _y, CustomEnemy);
        		with(o) {
                     // Visual:
        			spr_idle = spr.PelicanIdle;
        			spr_walk = spr.PelicanWalk;
        			spr_hurt = spr.PelicanHurt;
        			spr_dead = spr.PelicanDead;
        			spr_weap = spr.PelicanHammer;
        			spr_shadow = shd32;
        			spr_shadow_y = 6;
        			hitid = [spr_idle, _name];
        			mask_index = mskRhinoFreak;
        			depth = -2;

                     // Sound:
        			snd_hurt = sndGatorHit;
        			snd_dead = sndGatorDie;

        			 // Vars:
        			maxhealth = 50;
        			raddrop = 20;
        			size = 2;
        			walk = 0;
        			walkspd = 0.6;
        			maxspd = 3;
        			dash = 0;
        			dash_factor = 1.25;
        			chrg_time = 24; // 0.8 Seconds
        			gunangle = random(360);
        			direction = gunangle;
        			wepangle = choose(-140, 140);

        			 // Alarms:
        			alarm1 = 30 + irandom(60);
        		}
            	break;

            case "Seal":
                 // Elite Spawn:
                if(random(16) < 1){
                    return obj_create(_x, _y, "SealHeavy");
                }

                 // Normal Spawn:
                else{
                    o = instance_create(_x, _y, CustomEnemy);
                    with(o){
                         // Visual:
                        spr_spwn = spr.SealSpwn[0];
                        spr_idle = spr.SealIdle[0];
                        spr_walk = spr.SealWalk[0];
                        spr_hurt = spr.SealHurt[0];
                        spr_dead = spr.SealDead[0];
                        spr_weap = spr.SealWeap[0];
                        spr_shadow = shd24;
                        hitid = [spr_idle, _name];
                        sprite_index = spr_spwn;
                        depth = -2;

                         // Sound:
                        var _male = irandom(1);
                        snd_hurt = (_male ? sndFireballerHurt : sndFreakHurt);
                        snd_dead = (_male ? sndFireballerDead : sndFreakDead);

                         // Vars:
                        mask_index = mskBandit;
                        maxhealth = 12;
                        raddrop = 1;
                        size = 1;
                        walk = 0;
                        walkspd = 0.8;
                        maxspd = 3.5;
                        type = 0;
                        hold = false;
                        hold_x = 0;
                        hold_y = 0;
                        creator = noone;
                        wepangle = 0;
                        gunangle = random(360);
                        direction = gunangle;
                        slide = 0;
                        scared = false;
                        shield = choose(true, false);
                        shield_ang = gunangle;
                        shield_draw = true;
                        surfClamShield = -1;

                         // Alarms:
                        alarm1 = 20 + random(20);
                        alarm2 = -1;
                    }
                }
                break;

            case "SealAnchor":
                o = instance_create(_x, _y, CustomSlash);
                with(o){
                     // Visual:
                    sprite_index = spr.SealAnchor;
                    image_speed = 0;
                    depth = -2;

                     // Vars:
                    mask_index = -1;
                    damage = 4;
                    force = 6;
                    team = 1;
                    last_x = [x, x];
                    last_y = [y, y];
                }
                break;

            case "SealHeavy":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
                    spr_spwn = spr.SealHeavySpwn;
                    spr_idle = spr.SealHeavyIdle;
                    spr_walk = spr.SealHeavyWalk;
                    spr_hurt = spr.SealHeavyHurt;
                    spr_dead = spr.SealHeavyDead;
                    spr_chrg = spr.SealHeavyTell;
                    spr_weap = spr.SealAnchor;
                    spr_shadow = shd24;
                    hitid = [spr_idle, "HEAVY SEAL"];
                    sprite_index = spr_spwn;
                    depth = -2;

                     // Sound:
                    snd_hurt = sndJockHurt;
                    snd_dead = sndJockDead;

                     // Vars:
                    mask_index = mskBandit;
                    maxhealth = 40;
                    raddrop = 12;
                    size = 2;
                    walk = 0;
                    walkspd = 0.8;
                    maxspd = 3;
                    wepangle = 0;
                    gunangle = random(360);
                    direction = gunangle;
                    my_mine = noone;
                    my_mine_ang = gunangle;
                    my_mine_spin = 0;
                    target_x = x;
                    target_y = y;
                    anchor = noone;
                    anchor_swap = false;
                    anchor_spin = 0;
                    anchor_throw = 0;
                    anchor_retract = 0;

                    alarm1 = 40 + random(30);
                }
                break;

            case "SealMine":
                o = instance_create(_x, _y, CustomHitme);
                with(o){
                     // Visual:
                    spr_idle = spr.SealMine;
                    spr_hurt = spr.SealMineHurt;
                    spr_dead = sprScorchmark;
                    spr_shadow = shd24;
                    hitid = [spr_idle, "WATER MINE"];
                    depth = -5;
                    image_speed = 0.4;

                     // Sound:
                    snd_hurt = sndHitMetal;

                     // Vars:
                    mask_index = mskNone;
                    friction = 0;
                    maxhealth = 10;
                    creator = noone;
                    canfly = true;
                    size = 2;
                    team = 0;
        	        z = 0;
        	        zspeed = 0;
        	        zfric = 1;
        	        right = choose(-1, 1);

        	        motion_add(random(360), 3);
                }
                break;

            case "TrafficCrab":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
                    spr_idle = spr.CrabIdle;
                    spr_walk = spr.CrabWalk;
                    spr_hurt = spr.CrabHurt;
                    spr_dead = spr.CrabDead;
                    spr_fire = spr.CrabFire;
                    spr_shadow = shd48;
                    hitid = [spr_idle, "Traffic Crab"];
                    mask_index = mskScorpion;
                    depth = -2;

                     // Sound:
                    snd_hurt = sndSpiderHurt;
                    snd_dead = sndPlantTBKill;
                    snd_mele = sndGoldScorpionMelee;

                     // Vars:
                    maxhealth = 20;
                    raddrop = 10;
                    size = 2;
                    meleedamage = 4;
                    walk = 0;
                    walkspd = 1;
                    maxspd = 2.5;
        			gunangle = random(360);
        			direction = gunangle;
        			sweep_spd = 10;
                    sweep_dir = right;
                    ammo = 0;

                     // Alarms:
                    alarm1 = 30 + random(90);
                }
                break;

            case "TrafficCrabVenom":
                o = instance_create(_x, _y, CustomProjectile);
                with(o){
                     // Visual:
                    sprite_index = sprScorpionBullet;
                    mask_index = mskEnemyBullet1;
                    depth = -3;

                     // Vars:
                    friction = 0.75;
                    damage = 2;
                    force = 4;
                    typ = 2;
                }
                break;
    	//#endregion

        //#region OASIS
            case "ClamChest":
                with(obj_create(_x, _y, "CustomChest")){
                     // Visual:
                    sprite_index = sprClamChest;
                    spr_open = sprClamChestOpen;

                     // Sound:
                    snd_open = sndOasisChest;

                    on_open = script_ref_create_ext("mod", "teoasis", "ClamChest_open");
                }
                break;

            case "Hammerhead":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
        			spr_idle = spr.HammerheadIdle;
        			spr_walk = spr.HammerheadIdle;
        			spr_hurt = spr.HammerheadHurt;
        			spr_dead = spr.HammerheadDead;
        			spr_chrg = spr.HammerheadChrg;
        			spr_shadow = shd48;
        			spr_shadow_y = 2;
        			hitid = [spr_idle, _name];
        			depth = -2;

                     // Sound:
        			snd_hurt = sndSalamanderHurt;
        			snd_dead = sndOasisDeath;
        			snd_mele = sndBigBanditMeleeHit;

        			 // Vars:
        			mask_index = mskScorpion;
        			maxhealth = 40;
        			raddrop = 12;
        			size = 2;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 4;
        			meleedamage = 4;
        			direction = random(360);
        			rotate = 0;
        			charge = 0;
        			charge_dir = 0;
        			charge_wait = 0;

        			 // Alarms:
        			alarm1 = 40 + random(20);
        		}
                break;

            case "Puffer":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
        			spr_idle = spr.PufferIdle;
        			spr_walk = spr.PufferIdle;
        			spr_hurt = spr.PufferHurt;
        			spr_dead = spr.PufferDead;
        			spr_chrg = spr.PufferChrg;
        			spr_fire = spr.PufferFire[0, 0];
        			spr_shadow = shd16;
        			spr_shadow_y = 7;
        			hitid = [spr_idle, _name];
        			depth = -2;

                     // Sound:
                    snd_hurt = sndOasisHurt;
                    snd_dead = sndOasisDeath;

                     // Vars:
        			mask_index = mskFreak;
                    maxhealth = 10;
        			raddrop = 4;
        			size = 1;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 3;
        			meleedamage = 2;
        			direction = random(360);
        			blow = 0;

                     // Alarms:
                    alarm1 = 40 + random(80);
                }
                break;

            case "Crack":
                o = instance_create(_x, _y, CustomObject);
                with(o){
                     // Visual:
                    sprite_index = spr.Crack;
                    image_speed = 0;
                    mask_index = mskWepPickup;
                }
                break;
        //#endregion

        //#region TRENCH
            case "Angler":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Offset:
                    x = _x - (right * 6);
                    y = _y - 8;
                    xstart = x;
                    ystart = y;
                    xprevious = x;
                    yprevious = y;

                     // Visual:
        	        spr_idle =      spr.AnglerIdle;
        			spr_walk =      spr.AnglerWalk;
        			spr_hurt =      spr.AnglerHurt;
        			spr_dead =      spr.AnglerDead;
        			spr_appear =    spr.AnglerAppear;
        			 // spr_shadow = shd64;
        			 // spr_shadow_y = 6;
        			hitid = [spr_idle, _name];
        			sprite_index = spr_appear;
        			image_speed = 0.4;
        			depth = -2

                     // Sound:
        			snd_hurt = sndFireballerHurt;
        			snd_dead = choose(sndFrogEggDead, sndFrogEggOpen2);

        			 // Vars:
        			//mask_index = mskFrogQueen;
        			maxhealth = 50;
        			raddrop = 25;
        			meleedamage = 4;
        			size = 3;
        			walk = 0;
        			walkspd = 0.6;
        			maxspd = 3;
        			hiding = true;
        			ammo = 0;

                     // Hide:
                    mod_script_call("mod", "tetrench", "scrAnglerHide");

                     // Alarms:
        			alarm1 = 30 + irandom(30);
                }
                break;

            case "Eel":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
                    c = irandom(2);
                    if(c == 0 && GameCont.crown == crwn_guns) c = 1;
                    if(c == 1 && GameCont.crown == crwn_life) c = 0;
                    spr_idle = spr.EelIdle[c];
                    spr_walk = spr_idle;
                    spr_hurt = spr.EelHurt[c];
                    spr_dead = spr.EelDead[c];
                    spr_tell = spr.EelTell[c];
                    spr_shadow = shd24;
                    image_index = random(image_number - 1);
                    depth = -2;

                     // Sound:
                    snd_hurt = sndHitFlesh;
                    snd_dead = sndFastRatDie;
                    snd_melee = sndMaggotBite;

                     // Vars:
                    mask_index = mskRat;
                    maxhealth = 12;
                    raddrop = 2;
                    meleedamage = 2;
                    size = 1;
                    walk = 0;
                    walkspd = 1.2;
                    maxspd = 3;
                    pitDepth = 0;
                    direction = random(360);
                    arc_inst = noone;
                    arcing = 0;
                    wave = random(100);
                    gunangle = 0;
                    elite = 0;
                    ammo = 0;

                     // Alarms:
                    alarm1 = 30;
                }
                break;

            case "EelSkull":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = spr.EelSkullIdle;
                    spr_hurt = spr.EelSkullHurt;
                    spr_dead = spr.EelSkullDead;

                     // Sound:
                    snd_hurt = sndOasisHurt;
                    snd_dead = sndOasisDeath;

                     // Vars:
                    maxhealth = 50;
                    size = 2;
                }
                break;

            case "InkStain":
                o = instance_create(_x, _y, CustomObject);
                with(o){
                     // Visual:
                    //sprite_index =
                }
                break;

            case "Jelly":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
                    c = irandom(2);
                    if(c == 0 && GameCont.crown == crwn_guns) c = 1;
                    if(c == 1 && GameCont.crown == crwn_life) c = 0;
                    spr_charged = spr.JellyIdle[c];
                    spr_idle = spr_charged;
                    spr_walk = spr_charged;
                    spr_hurt = spr.JellyHurt[c];
                    spr_dead = spr.JellyDead[c];
                    spr_fire = (c == 3 ? spr.JellyEliteFire : spr.JellyFire);
                    spr_shadow = shd24;
                    spr_shadow_y = 6;
                    hitid = [spr_idle, _name];
                    depth = -2;

                     // Sound:
                    snd_hurt = sndHitFlesh;
                    snd_dead = sndBigMaggotDie;

                     // Vars:
                    mask_index = mskLaserCrystal;
                    maxhealth = 52 // (c == 3 ? 72 : 52);
                    raddrop = 16 // (c == 3 ? 38 : 16);
                    size = 2;
                    walkspd = 1;
                    maxspd = 2.6;
                    meleedamage = 4;
                    direction = random(360);

                     // Alarms:
                    alarm1 = 40 + irandom(20);

                     // Always on the move:
                    walk = alarm0;
                }
                break;

            case "JellyElite":
                o = obj_create(_x, _y, "Jelly");
                with(o){
                    c = 3;

                     // Visual:
                    spr_charged = spr.JellyIdle[c]
                    spr_idle = spr_charged;
                    spr_walk = spr_charged;
                    spr_hurt = spr.JellyHurt[c];
                    spr_dead = spr.JellyDead[c];
                    spr_fire = spr.JellyEliteFire;

                     // Sound:
                    snd_hurt = sndLightningCrystalHit;
                    snd_dead = sndLightningCrystalDeath;

                     // Vars:
                    raddrop *= 2;
                }
                break;

            case "Kelp":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = spr.KelpIdle;
                    spr_hurt = spr.KelpHurt;
                    spr_dead = spr.KelpDead;
                    image_speed = random_range(0.2, 0.3);
                    depth = -2;

                     // Sounds:
                    snd_hurt = sndOasisHurt;
                    snd_dead = sndOasisDeath;

                     // Vars:
                    maxhealth = 2;
                    size = 1;
                }
                break;

            case "PitSquid":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:


                     // Sounds:
                    snd_hurt = sndBallMamaHurt;
                    snd_mele = sndMaggotBite;

                     // Vars:
                    friction = 0.01;
                    mask_index = mskNone;
                    meleedamage = 8;
                    maxhealth = scrBossHP(450);
                    raddrop = 1;
                    size = 5;
                    canfly = true;
                    target = noone;
                    bite = false;
                    sink = false;
                    sink_targetx = x;
                    sink_targety = y;
                    pit_height = 1;

                     // Eyes:
                    eye = [];
                    eye_angle = random(360);
                    eye_dis_offset = 0;
                    repeat(3){
                        array_push(eye, {
                            x : 0,
                            y : 0,
                            dis : 5,
                            dir : random(360),
                            blink : false,
                            blink_img : 0
                        });
                    }

                     // Alarms:
                    alarm1 = 90;
                    alarm2 = 90;
                }
                break;

            case "Tentacle":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
                    spr_spwn = spr.TentacleSpwn;
                    spr_idle = spr.TentacleIdle;
                    spr_walk = spr.TentacleIdle;
                    spr_hurt = spr.TentacleHurt;
                    spr_dead = spr.TentacleDead;
                    depth = -2 - (y / 20000);
                    hitid = [spr_idle, "PIT SQUID"];
                    sprite_index = mskNone;

                     // Sound:
                    snd_hurt = sndHitFlesh;
                    snd_dead = sndMaggotSpawnDie;
                    snd_mele = sndPlantSnare;

                     // Vars:
                    mask_index = mskNone;
                    meleedamage = 3;
                    maxhealth = 20;
                    raddrop = 0;
                    size = 3;
                    xoff = 0;
                    yoff = 0;
                    dir = 0;
                    spd = 0;
                    move_delay = 0;
                    creator = noone;
                    canfly = true;
                    kills = 0;

                    alarm0 = 1;
                    alarm1 = 90;
                }
                break;

            case "TentacleRip":
                o = instance_create(_x, _y, CustomObject);
                with(o){
                     // Visual:
                    sprite_index = spr.TentacleWarn;
                    image_speed = 0.4;
                    depth = 6;

                     // Vars:
                    creator = noone;
                }
                break;

            case "TrenchFloorChunk":
                o = instance_create(_x, _y, CustomObject);
                with(o){
                     // Visual:
                    sprite_index = spr.FloorTrenchBreak;
                    image_index = irandom(image_number - 1)
                    image_speed = 0;
                    image_alpha = 0;
                    depth = -8;

                     // Vars:
        	        z = 0;
        	        zspeed = 6 + random(4);
        	        zfric = 0.3;
        	        friction = 0.05;
        	        rotspeed = random_range(1, 2) * choose(-1, 1);

        	        motion_add(random(360), 2 + random(3));
                }
                break;

            case "Vent":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = spr.VentIdle;
                    spr_hurt = spr.VentHurt;
                    spr_dead = spr.VentDead;
                    spr_shadow = mskNone;
                    depth = -2;

                     // Sounds
                    snd_hurt = sndOasisHurt;
                    snd_dead = sndOasisExplosionSmall;

                     // Vars:
                    maxhealth = 12;
                    size = 1;
                }
                break;

            case "YetiCrab":
                o = instance_create(_x, _y, CustomEnemy);
                with(o) {
                     // Visual:
                    spr_idle = spr.YetiCrabIdle;
                    spr_walk = spr.YetiCrabIdle;
                    spr_hurt = spr.YetiCrabIdle;
                    spr_dead = spr.YetiCrabIdle;
                    spr_weap = mskNone;
                    spr_shadow = shd24;
                    spr_shadow_y = 6;
                    hitid = [spr_idle, _name];
                    mask_index = mskFreak;
                    depth = -2;

                     // Sound:
                    snd_hurt = sndScorpionHit;
                    snd_dead = sndScorpionDie;

                     // Vars:
                    maxhealth = 12;
                    raddrop = 3;
                    size = 1;
                    walk = 0;
                    walkspd = 1;
                    maxspd = 4;
                    meleedamage = 2;
                    is_king = 0; // Decides leader
                    direction = random(360);

                     // Alarms:
                    alarm1 = 20 + irandom(10);
                }
                break;
        //#endregion

        //#region SEWERS
            case "Bat":
                var o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
                    spr_idle = spr.BatIdle;
                    spr_walk = spr.BatWalk;
                    spr_hurt = spr.BatHurt;
                    spr_dead = spr.BatDead;
                    spr_fire = spr.BatYell;
        			spr_weap = spr.BatWeap;
        			spr_shadow = shd48;
        			hitid = [spr_idle, _name];
        			mask_index = mskScorpion;
        			depth = -2;

                     // Sound:
                    snd_hurt = sndSuperFireballerHurt;
                    snd_dead = sndFrogEggDead;

                     // Vars:
        			maxhealth = 30;
        			raddrop = 12;
        			size = 2;
        			walk = 0;
        			scream = 0;
        			stress = 20;
        			walkspd = 0.8;
        			maxspd = 2.5;
        			gunangle = random(360);
        			direction = gunangle;

        			 // Alarms:
        			alarm1 = 60;
        			alarm2 = 120;
                }
                break;

            case "BatBoss":
                var o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
                    spr_idle = spr.BatBossIdle;
                    spr_walk = spr.BatBossWalk;
                    spr_hurt = spr.BatBossHurt;
                    spr_dead = spr.BatBossDead;
                    spr_fire = spr.BatBossYell;
        			spr_weap = spr.BatBossWeap;
        			spr_shadow = shd64;
        			spr_shadow_y = 12;
        			hitid = [spr_idle, "BIG BAT"];
        			mask_index = mskBanditBoss;
        			depth = -2;

                     // Sound:
                    snd_hurt = sndSalamanderHurt;
                    snd_dead = sndRatkingCharge;

                     // Vars:
        			maxhealth = scrBossHP(100);
        			raddrop = 24;
        			size = 3;
        			walk = 0;
        			scream = 0;
        			stress = 20;
        			walkspd = 0.8;
        			maxspd = 3;
        			gunangle = irandom(359);
        			direction = gunangle;
        			attack = 0;

        			 // Alarms:
        			alarm1 = 60;
        			alarm2 = 90;
        			alarm3 = 120;
                }
                break;

            case "BatScreech" :
                var o = instance_create(_x, _y, CustomSlash);
                with(o){
                     // Visual:
                    sprite_index = spr.BatScreech;
                    mask_index = msk.BatScreech;
                    image_speed = 0.4;

                     // Vars:
                    creator = noone;
                    candeflect = false;
                }

                 // Effects:
                instance_create(o.x, o.y, PortalClear);
                repeat(12 + irandom(6))
                    with instance_create(o.x, o.y, Dust)
                        motion_set(irandom(359), 4 + random(4));

                break;

            case "Cabinet":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = spr.CabinetIdle;
                    spr_hurt = spr.CabinetHurt;
                    spr_dead = spr.CabinetDead;

                     // Sounds:
                    snd_hurt = sndHitMetal;
                    snd_dead = sndSodaMachineBreak;

                     // Vars:
                    maxhealth = 20;
                    size = 1;
                }
                break;

        	case "Cat":
        	    o = instance_create(_x, _y, CustomEnemy);
        		with(o){
                     // Visual:
        			spr_idle = spr.CatIdle;
        			spr_walk = spr.CatWalk;
        			spr_hurt = spr.CatHurt;
        			spr_dead = spr.CatDead;
        			spr_sit1 = spr.CatSit1[0];
        			spr_sit2 = spr.CatSit2[0];
        			spr_sit1_side = spr.CatSit1[1];
        			spr_sit2_side = spr.CatSit2[1];
        			spr_weap = spr.CatWeap;
        			spr_shadow = shd24;
        			hitid = [spr_idle, _name];
        			mask_index = mskFreak;
        			depth = -2;

                     // Sound:
        			snd_hurt = sndGatorHit;
        			snd_dead = sndSalamanderDead;

        			 // Vars:
        			maxhealth = 18;
        			raddrop = 6;
        			size = 1;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 3;
        			hole = noone;
        			ammo = 0;
        			active = true;
        			cantravel = false;
        			gunangle = random(360);
        			direction = gunangle;
        			toxer_loop = -1;
        			sit = noone;
        			sit_side = 0;

        			 // Alarms:
        			alarm1 = 40 + irandom(20);
        			alarm2 = 40 + irandom(20);
        		}
        	    break;

        	case "CatBoss":
        	    o = instance_create(_x, _y, CustomEnemy);
        		with(o){
        		     // For Sani's bosshudredux:
        	        boss = 1;
        	        bossname = "BIG CAT";
        	        col = c_green;

                     // Visual:
        			spr_idle = spr.CatBossIdle;
        			spr_walk = spr.CatBossWalk;
        			spr_hurt = spr.CatBossHurt;
        			spr_dead = spr.CatBossDead;
        			spr_weap = spr.CatBossWeap;
        			spr_shadow = shd48;
        			spr_shadow_y = 3;
        			hitid = [spr_idle, bossname];
        			mask_index = mskBanditBoss;
        			depth = -2;

                     // Sound:
        			snd_hurt = sndScorpionHit;
        			snd_dead = sndSalamanderDead;

        			 // Vars:
        			maxhealth = scrBossHP(100);
        			raddrop = 24;
        			size = 3;
        			walk = 0;
                    dash = 0;
        			gunangle = random(360);
        			direction = gunangle;

        			 // Alarms:
        			alarm1 = 40 + irandom(20);
        		}
        	    break;

        	case "CatBossAttack" :
        	    o = instance_create(_x, _y, CustomObject);
        	    with(o){
        	         // Visual:
        	        image_blend = c_lime;
        	        image_yscale = 1.5;
        			hitid = [spr.CatIdle, "BIG CAT"];

        	         // Vars:
        	        team = 1;
        	        creator = noone;
        	        fire_line = [];
        	        var _off = 30 + (10 * GameCont.loops);
        	        repeat(3 + GameCont.loops) array_push(fire_line, {
        	            dir : 0,
        	            dis : 0,
        	            dir_goal : orandom(_off),
        	            dis_goal : 1000
                        });

        	         // Alarms:
        	        alarm0 = 30;
        	    }
        	    break;

        	case "CatDoor":
        	    o = instance_create(_x, _y, CustomHitme);
        	    with(o){
        	         // Visual:
        	        sprite_index = spr.CatDoor;
        	        spr_shadow = mskNone;
        	        image_speed = 0;
        	        depth = -3 - (y / 20000);

                     // Sound:
                    snd_hurt = sndHitMetal;
                    snd_dead = sndStreetLightBreak;

        	         // Vars:
        	        mask_index = msk.CatDoor;
        	        maxhealth = 15;
        	        size = 2;
        	        team = 0;
        	        openang = 0;
        	        openang_last = openang;
        	        my_wall = noone;
        	        partner = noone;
        	        my_surf = -1;
        	        my_surf_w = 32;
        	        my_surf_h = 50;
        	    }
        	    break;

        	case "CatGrenade":
        	    o = instance_create(_x, _y, CustomProjectile);
        	    with(o){
                     // Visual:
        	        sprite_index = sprToxicGrenade;
        	        mask_index = mskNone;

        	         // Vars:
        	        z = 1;
        	        zspeed = 0;
        	        zfric = 0.8;
        	        damage = 0;
        	        force = 0;
        	        right = choose(-1, 1);
        	    }
        	    break;

            case "CatHole":
                o = instance_create(_x, _y, CustomObject);
                with(o){
                     // Visual:
                    sprite_index = spr.ManholeBottom;
                    image_speed = 0.4;
                    depth = 7;
            
                     // Vars:
                    mask_index = mskSuperFlakBullet;
                    fullofrats = true;
                    target = noone;

                     // don't mess with the big boy
                    if(place_meeting(x, y, CustomObject)){
                        with(instances_named(CustomObject, "CatHoleBig")){
                            if(place_meeting(x, y, other)) with(other){
                                instance_destroy();
                                exit;
                            }
                        }
                    }
            
                    mod_script_call("mod", "tesewers", "CatHoleCover");
                }
                break;

            case "CatHoleBig":
                o = instance_create(_x, _y, CustomObject);
                with(o){
                     // Visual:
                    sprite_index = spr.BigManhole;
                    image_speed = 0;

                     // Vars:
                    depth = 8;
                    canboss = true;
                }
                break;

            case "CatLight":
                var o = {
                    x : _x,
                    y : _y,
                    w1 : 12,
                    w2 : 32,
                    h1 : 32,
                    h2 : 8,
                    offset : 0,
                    active : true
                    };

                array_push(mod_variable_get("mod", "tesewers", "catLight"), o);
                return o;

            case "ChairFront":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = spr.ChairFrontIdle;
                    spr_hurt = spr.ChairFrontHurt;
                    spr_dead = spr.ChairDead;

                     // Sounds:
                    snd_hurt = sndHitMetal;
                    snd_dead = sndStreetLightBreak;

                     // Vars:
                    maxhealth = 4;
                    size = 1;
                }
                break;

            case "ChairSide":
                o = obj_create(_x, _y, "ChairFront");
                with(o){
                     // Visual:
                    spr_idle = spr.ChairSideIdle;
                    spr_hurt = spr.ChairSideHurt;
                }
                break;

            case "Couch":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = spr.CouchIdle;
                    spr_hurt = spr.CouchHurt;
                    spr_dead = spr.CouchDead;

                     // Sounds:
                    snd_hurt = sndHitPlant;
                    snd_dead = sndWheelPileBreak;

                     // Vars:
                    maxhealth = 20;
                    size = 3;
                }
                break;

            case "Manhole":
                o = instance_create(_x, _y, CustomObject);
                with(o){
                     // Visual:
                    sprite_index = sprPizzaEntrance;
                    image_speed = 0;
                    mask_index = mskFloor;

                     // Vars:
                    depth = 8;
                    toarea = "pizza"; // go to pizza sewers
                }
                break;

            case "NewTable":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = spr.TableIdle;
                    spr_hurt = spr.TableHurt;
                    spr_dead = spr.TableDead;
                    spr_shadow = shd32;
                    depth--;

                     // Sounds:
                    snd_hurt = sndHitMetal;
                    snd_dead = sndHydrantBreak;

                     // Vars:
                    maxhealth = 8;
                    size = 2;
                }
                break;

            case "Paper":
                o = instance_create(_x, _y, Feather);
                with(o){
                    sprite_index = spr.Paper;
                    image_index = random(image_number);
                    image_speed = 0;
                    friction = 0.2;
                }
                break;

            case "PizzaDrain":
                o = instance_create(_x, _y, CustomHitme);
                with(o){
                     // Visual:
                    spr_idle = spr.PizzaDrainIdle;
                    spr_walk = spr_idle;
                    spr_hurt = spr.PizzaDrainHurt;
                    spr_dead = spr.PizzaDrainDead;
                    spr_shadow = mskNone;
                    image_xscale = choose(-1, 1);
                    image_speed = 0.4;
                    depth = -7;

                     // Sound:
                    snd_hurt = sndHitMetal;
                    snd_dead = sndStatueDead;

                     // Vars:
                    mask_index = mskIcon;
                    maxhealth = 40;
                    team = 0;
                    size = 3;
                    target = instance_nearest(x, y, Wall);
                }
                break;

            case "PizzaTV":
                o = instance_create(_x, _y, TV);
                with(o){
                     // Visual:
                    spr_hurt = spr.TVHurt;
                    spr_dead = spr.TVHurt;

                     // Vars:
                    maxhealth = 15;
                    my_health = 15;

                    with(script_bind_end_step(0, 0)){
                        script = script_ref_create_ext("mod", "tesewers", "PizzaTV_end_step");
                        creator = other;
                    }
                }
                return o;
                break;

            case "VenomFlak":
                o = instance_create(_x, _y, CustomProjectile);
                with(o){
                     // Visual:
                    sprite_index = spr.VenomFlak;
                    image_speed = 0.4;

                     // Vars:
                    friction = 0.4;
                    damage = 6;
                    time = 40;
                }
                break;
        //#endregion

        //#region CRYSTAL CAVES
        	case "InvMortar":
        	    o = obj_create(_x, _y, "Mortar");
        	    with(o){
        	        inv = true;

        	        // Visual:
        	       spr_idle = spr.InvMortarIdle;
        	       spr_walk = spr.InvMortarWalk;
        	       spr_fire = spr.InvMortarFire;
        	       spr_hurt = spr.InvMortarHurt;
        	       spr_dead = spr.InvMortarDead;
        	    }
        	    break;

        	case "Mortar":
        	    o = instance_create(_x, _y, CustomEnemy);
        	    with(o){
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
        			hitid = [spr_idle, _name];
        			depth = -4;

                     // Sound:
        			snd_hurt = sndLaserCrystalHit;
        			snd_dead = sndLaserCrystalDeath;

        			 // Vars:
        			maxhealth = 75;
        			raddrop = 30;
        			size = 3;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 2;
        			ammo = 4;
        			gunangle = random(360);
        			direction = gunangle;

                     // Alarms:
        			alarm1 = 100 + irandom(40);
        			alarm2 = -1;
        	    }
        	    break;

        	case "MortarPlasma":
        	    o = instance_create(_x, _y, CustomProjectile);
        	    with(o){
                     // Visual:
        	        sprite_index = spr.MortarPlasma;
        	        mask_index = mskNone;

        	         // Vars:
        	        z = 1;
        	        zspeed = 0;
        	        zfric = 0.4; // 0.8
        	        damage = 0;
        	        force = 0;
        	    }
        	    break;

        	case "NewCocoon":
        	    o = instance_create(_x, _y, CustomProp);
        		with(o){
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
        		}
        	    break;

        	case "Spiderling":
        	    o = instance_create(_x, _y, CustomEnemy);
        	    with(o){
                     // Visual:
        	        spr_idle = spr.SpiderlingIdle;
        			spr_walk = spr.SpiderlingWalk;
        			spr_hurt = spr.SpiderlingHurt;
        			spr_dead = spr.SpiderlingDead;
        			spr_shadow = shd16;
        			spr_shadow_y = 2;
        			mask_index = mskMaggot;
        			hitid = [spr_idle, _name];
        			depth = -2;

                     // Sound:
        			snd_hurt = sndSpiderHurt;
        			snd_dead = sndSpiderDead;

        			 // Vars:
        			maxhealth = 4;
        			raddrop = 2;
        			size = 1;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 3;
        			direction = irandom(359);

                     // Alarms:
        			alarm0 = 300 + random(90);
        			alarm1 = 20 + random(20);
        	    }
        	    break;
    	//#endregion

    	default:
    		return [/* GENERAL */ "BigDecal", "BubbleBomb", "SuperBubbleBomb", "BubbleExplosion", "CustomChest", "Harpoon", "LightningDisc", "LightningDiscEnemy", "NetNade", "ParrotFeather", "ParrotChester", "Pet", "PizzaBoxCool", "scrTopDecal",
    		        /* DESERT  */ "BabyScorpion", "BabyScorpionGold", "Bone", "BoneSpawner", "CoastBossBecome", "CoastBoss",
    		        /* COAST   */ "BloomingCactus", "BuriedCar", "CoastBigDecal", "CoastDecal", "Creature", "Diver", "DiverHarpoon", "Gull", "Palanking", "PalankingDie", "Palm", "Pelican", "Seal", "SealAnchor", "SealHeavy", "SealMine", "TrafficCrab", "TrafficCrabVenom",
    		        /* OASIS   */ "ClamChest", "Hammerhead", "Puffer", "Crack",
    		        /* TRENCH  */ "Angler", "Eel", "EelSkull", "Jelly", "JellyElite", "Kelp", "PitSquid", "Tentacle", "TentacleRip", "TrenchFloorChunk", "Vent", "YetiCrab",
    		        /* SEWERS  */ "Bat", "BatBoss", "BatScreech", "Cabinet", "Cat", "CatBoss", "CatBossAttack", "CatDoor", "CatGrenade", "CatHole", "CatHoleBig", "CatLight", "ChairFront", "ChairSide", "Couch", "Manhole", "NewTable", "Paper", "PizzaDrain", "PizzaTV", "VenomFlak",
    		        /* CAVES   */ "InvMortar", "Mortar", "MortarPlasma", "NewCocoon", "Spiderling"
    		        ];
    }

     /// Auto Assign Things:
    if(instance_exists(o)){
        if(string_pos("Custom", object_get_name(o.object_index)) == 1){
            var _scrt = ["step", "begin_step", "end_step", "draw", "destroy", "hurt", "death", "cleanup", "hit", "wall", "anim", "grenade", "projectile", "alrm0", "alrm1", "alrm2", "alrm3", "alrm4", "alrm5", "alrm6", "alrm7", "alrm8", "alrm9", "alrm10"];
            with(o){
                var _isEnemy = instance_is(self, CustomEnemy);

                if("name" not in self) name = string(obj_name);
        
                 // Scripts:
                with(_scrt){
                    var v = "on_" + self;
                    if(v not in other || is_undefined(variable_instance_get(other, v))){
                        var s = other.name + "_" + self,
                            _mod = global.objectMods,
                            m = false;
        
                        for(var i = 0; i < array_length(_mod); i++){
                            if(mod_script_exists("mod", _mod[i], s)){
                                variable_instance_set(other, v, ["mod", _mod[i], s]);
                                m = true;
                                break;
                            }
                        }

                         // Defaults:
                        if(!m) with(other){
                            switch(v){
                                case "on_step":
                                    if(_isEnemy){
                                        on_step = enemy_step_ntte;
                                    }
                                    break;

                                case "on_hurt":
                                    on_hurt = enemyHurt;
                                    break;

                                case "on_death":
                                    if(_isEnemy){
                                        on_death = scrDefaultDrop;
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
        
                 // Override Events:
                var _override = ["step"];
                with(_override){
                    var v = "on_" + self;
                    if(v in other){
                        var e = variable_instance_get(other, v),
                            _objStep = script_ref_create(obj_step);
        
                        if(!is_array(e) || !array_equals(e, _objStep)){
                            with(other){
                                variable_instance_set(id, "on_ntte_" + other, e);

                                 // Override Specifics:
                                switch(v){
                                    case "on_step":
                                        on_step = _objStep;

                                         // Setup Custom NTTE Event Vars:
                                        ntte_alarm_max = 0;
                                        for(var i = 0; i <= 10; i++){
                                            var a = `on_alrm${i}`;
                                            if(a in self && variable_instance_get(id, a) != null){
                                                ntte_alarm_max = i + 1;
                                            }
                                        }
                                        /*var _set = ["anim"];
                                        with(_set){
                                            var n = "on_ntte_" + self;
                                            if(n not in other){
                                                variable_instance_set(other, n, null);
                                            }
                                        }*/
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

    return o;

#define obj_step
    //trace_lag_bgn(name);

     // Step:
    script_ref_call(on_ntte_step);
    if(!instance_exists(self)) exit;

     // Alarms:
    for(var i = 0; i < ntte_alarm_max; i++){
        var a = alarm_get(i);
        if(a > 0){
             // Decrement Alarm:
            a -= ceil(current_time_scale);
            alarm_set(i, a);

             // Call Alarm Event:
    		if(a <= 0){
    		    alarm_set(i, -1);
    		    script_ref_call(variable_instance_get(self, "on_alrm" + string(i)));
    		    if(!instance_exists(self)) exit;
    		}
        }
    }

    //trace_lag_end(name);

#define step
    //trace("");
    //trace("Frame", current_frame, "Lag:")
    //trace_lag();

#define enemy_step_ntte
    if("walk" in self){
        enemyWalk(walkspd, maxspd);
    }
    enemySprites();


/// Scripts
#define draw_self_enemy()
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);

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
            if(!collision_line(_sx, _sy, _lx, _ly, Wall, 0, 0)){
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

#define draw_trapezoid(_x1a, _x2a, _y1, _x1b, _x2b, _y2)
    draw_primitive_begin(pr_trianglestrip);
    draw_vertex(_x1a, _y1);
    draw_vertex(_x1b, _y2);
    draw_vertex(_x2a, _y1);
    draw_vertex(_x2b, _y2);
    draw_primitive_end();

#define scrWalk(_walk, _dir)
    walk = _walk;
    speed = max(speed, friction);
    direction = _dir;
    if("gunangle" in self) gunangle = direction;
    scrRight(direction);

#define scrRight(_dir)
    _dir = (_dir + 360) mod 360;
    if(_dir < 90 || _dir > 270) right = 1;
    if(_dir > 90 && _dir < 270) right = -1;

#define scrEnemyShoot(_object, _dir, _spd)
    return scrEnemyShootExt(x, y, _object, _dir, _spd);

#define scrEnemyShootExt(_x, _y, _object, _dir, _spd)
    var _inst = noone;

    if(is_string(_object)) _inst = obj_create(_x, _y, _object);
    else _inst = instance_create(_x, _y, _object);
    with(_inst){
        if(_spd <= 0) direction = _dir;
        else motion_add(_dir, _spd);
        image_angle = _dir;
        hitid = other.hitid;
        team = other.team;
        creator = other;

         // Euphoria:
        var e = skill_get(mut_euphoria);
        if(e != 0 && object_index == CustomProjectile){
            speed *= (0.8 / e);
        }
    }

    return _inst;

#define enemyWalk(_spd, _max)
    if(walk > 0){
        motion_add(direction, _spd);
        walk -= current_time_scale;
    }
    if(speed > _max) speed = _max; // Max Speed

#define enemySprites()
     // Not Hurt:
    if(sprite_index != spr_hurt){
        if(speed <= 0) sprite_index = spr_idle;
    	else if(sprite_index == spr_idle) sprite_index = spr_walk;
    }

     // Hurt:
    else if(image_index > image_number - 1){
        sprite_index = spr_idle;
    }

#define enemyHurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    motion_add(_hitdir, _hitvel);	// Knockback
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);	// Sound

     // Hurt Sprite:
    sprite_index = spr_hurt;
    image_index = 0;

#define scrDefaultDrop
    pickup_drop(16, 0); // Bandit drop-ness

#define target_in_distance(_disMin, _disMax)
    if(instance_exists(target)){
        var _dis = point_distance(x, y, target.x, target.y);
        return (_dis > _disMin && _dis < _disMax);
    }
    return 0;

#define target_is_visible()
    if(instance_exists(target)){
        if(!collision_line(x, y, target.x, target.y, Wall, false, false)) return true;
    }
    return false;

#define z_engine()
    z += zspeed * current_time_scale;
    zspeed -= zfric * current_time_scale;

#define unlock_get(_unlock)
    var u = lq_defget(sav, "unlock", {});
    return lq_defget(u, _unlock, false);

#define unlock_set(_unlock, _value)
    if(!lq_exists(sav, "unlock")) sav.unlock = {};
    lq_set(sav.unlock, _unlock, _value);

#define scrPickupIndicator(_text)
    return mod_script_call("mod", "ntte", "scrPickupIndicator", _text);

#define scrCharm(_instance, _charm)
    var c = {
            "instance"  : _instance,
            "charmed"   : false,
            "target"    : noone,
            "alarm"     : [],
            "team"      : -1,
            "time"      : 0,
            "walk"      : 0
        },
        _charmListRaw = mod_variable_get("mod", "ntte", "charm");

    with(_instance){
        if("charm" not in self) charm = c;

        if(_charm != charm.charmed){
             // Charm:
            if(_charm){
                if("team" in self){
                    charm.team = team;
                    team = 2;
                }
                for(var i = 0; i <= 10; i++){
                    charm.alarm[i] = alarm_get(i);
                    alarm_set(i, -1);
                }
                ds_list_add(_charmListRaw, charm);
            }

             // Uncharm:
            else{
                if("canmelee" in self && canmelee){
                    alarm11 = 30;
                    canmelee = false;
                }
                if(charm.team != -1){
                    team = charm.team;
                    charm.team = -1;
                }
                for(var i = 0; i <= 10; i++) alarm_set(i, charm.alarm[i]);

                 // Effects:
                sound_play_pitch(sndAssassinGetUp, 0.7);
                instance_create(x, bbox_top, AssassinNotice);
                for(var a = direction; a < direction + 360; a += (360 / 10)){
                    with(instance_create(x, y, Dust)) motion_add(a, 3);
                }
            }
        }
        charm.charmed = _charm;
        c = charm;
    }
    if(!_charm){
        var _charmList = ds_list_to_array(_charmListRaw);
        with(_charmList){
            if(instance == _instance){
                ds_list_remove(_charmListRaw, self);
                break;
            }
        }
    }
    return c;

#define scrBossHP(_hp)
    var n = 0;
    for(var i = 0; i < maxp; i++) n += player_is_active(i);
    return round(_hp * (1 + ((1/3) * GameCont.loops)) * (1 + (0.5 * (n - 1))));

#define scrBossIntro(_name, _sound, _music)
    mod_script_call("mod", "ntte", "scrBossIntro", _name, _sound, _music);

#define scrUnlock(_name, _text, _sprite, _sound)
    return mod_script_call("mod", "ntte", "scrUnlock", _name, _text, _sprite, _sound);

#define scrTopDecal(_x, _y, _area)
    _area = string(_area);
    var _topDecal = {
        "0"   : TopDecalNightDesert,
        "1"   : TopDecalDesert,
        "2"   : TopDecalSewers,
        "3"   : TopDecalScrapyard,
        "4"   : TopDecalCave,
        "5"   : TopDecalCity,
        "7"   : TopDecalPalace,
        "102" : TopDecalPizzaSewers,
        "104" : TopDecalInvCave,
        "105" : TopDecalJungle,
        "106" : TopPot,
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
                    if(random(6) < 1 && distance_to_object(Player) > 128){
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

#define scrWaterStreak(_x, _y, _dir, _spd)
    with(instance_create(_x, _y, AcidStreak)){
        sprite_index = spr.WaterStreak;
        motion_add(_dir, _spd);
        vspeed -= 2;
        image_angle = direction;
        image_speed = 0.4 + random(0.2);
        depth = 0;

        return id;
    }

#define scrRadDrop(_x, _y, _raddrop, _dir, _spd)
	while(_raddrop > 0){
		var r = (_raddrop > 15);
		repeat(r ? 1 : _raddrop){
			if(r) _raddrop -= 10;
			with(instance_create(_x, _y, (r ? BigRad : Rad))){
				speed = _spd;
				direction = _dir;
				motion_add(random(360), random(_raddrop / 2) + 2);
				speed *= power(0.9, speed);
			}
		}
		if(!r) break;
	}

#define scrCorpse(_dir, _spd)
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

#define scrSwap()
	var _swap = ["wep", "curse", "reload", "wkick", "wepflip", "wepangle", "can_shoot"];
	for(var i = 0; i < array_length(_swap); i++){
		var	s = _swap[i],
			_temp = [variable_instance_get(id, "b" + s), variable_instance_get(id, s)];

		for(var j = 0; j < array_length(_temp); j++) variable_instance_set(id, chr(98 * j) + s, _temp[j]);
	}

	wepangle = (weapon_is_melee(wep) ? choose(120, -120) : 0);
	can_shoot = (reload <= 0);
	clicked = 0;

#define scrPortalPoof()
     // Get Rid of Portals (but make it look cool):
    if(instance_exists(Portal)){
        var _spr = sprite_duplicate(sprPortalDisappear);
        with(Portal) if(endgame >= 100){
            mask_index = mskNone;
            sprite_index = _spr;
            image_index = 0;
            if(fork()){
                while(instance_exists(self)){
                    if(anim_end) instance_destroy();
                    wait 1;
                }
                exit;
            }
        }
    }

#define scrPickupPortalize()
    var _scrt = "scrPickupPortalize";
    if(!instance_is(self, CustomEndStep) || script[2] != _scrt){
        with(CustomEndStep) if(script[2] == _scrt) exit;
        script_bind_end_step(scrPickupPortalize, 0);
    }

     // Attract Pickups:
    else{
        instance_destroy();
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
                if(distance_to_object(s) >= _attractDisProto || collision_line(x, y, s.x, s.y, Wall, false, false)){
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
    }

#define orandom(n) // For offsets
    return random_range(-n, n);

#define floor_ext(_num, _round)
    return floor(_num / _round) * _round;

#define array_count(_array, _value)
    var c = 0;
    for(var i = 0; i < array_length(_array); i++){
        if(_array[i] == _value) c++;
    }
    return c;

#define array_flip(_array)
    var a = array_clone(_array),
        m = array_length(_array);

    for(var i = 0; i < m; i++){
        _array[@i] = a[(m - 1) - i];
    }

#define instances_named(_object, _name)
    return instances_matching(_object, "name", _name);

#define nearest_instance(_x, _y, _instances)
	var	_nearest = noone,
		d = 1000000;

	with(_instances) if(instance_exists(self)){
		var _dis = point_distance(_x, _y, x, y);
		if(_dis < d){
			_nearest = id;
			d = _dis;
		}
	}

	return _nearest;

#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)
    return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "x", _x1), "x", _x2), "y", _y1), "y", _y2);

#define instances_seen(_obj, _ext)
    var _vx = view_xview_nonsync,
        _vy = view_yview_nonsync,
        o = _ext;

    return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _vx - o), "bbox_left", _vx + game_width + o), "bbox_bottom", _vy - o), "bbox_top", _vy + game_height + o);

#define instances_meeting(_x, _y, _obj)
    var _tx = x,
        _ty = y;

    x = _x;
    y = _y;
    var r = instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", bbox_left), "bbox_left", bbox_right), "bbox_bottom", bbox_top), "bbox_top", bbox_bottom);
    x = _tx;
    y = _ty;

    return r;

#define instance_random(_obj)
	if(is_array(_obj) || instance_exists(_obj)){
		var i = instances_matching(_obj, "", undefined);
		return i[irandom(array_length(i) - 1)];
	}
	return noone;

#define frame_active(_interval)
    return ((current_frame mod _interval) < current_time_scale);

#define area_generate(_sx, _sy, _area)
    GameCont.area = _area;

     // Store Player Positions:
    var _px = [], _py = [], _vx = [], _vy = [];
    with(Player){
        _px[index] = x;
        _py[index] = y;
        _vx[index] = view_xview[index];
        _vy[index] = view_yview[index];
    }

     // No Duplicates:
    with(TopCont) instance_destroy();
    with(SubTopCont) instance_destroy();
    with(BackCont) instance_destroy();

     // Exclude These:
    var _oldFloor = instances_matching(Floor, "", null),
        _oldChest = [],
        _chest = [WeaponChest, AmmoChest, RadChest, RogueChest, HealthChest];

    for(var i = 0; i < array_length(_chest); i++){
        _oldChest[i] = instances_matching(_chest[i], "", null);
    }

     // Generate Level:
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
        var f = instances_matching(Floor, "", null),
            _newFloor = array_slice(f, 0, array_length(f) - array_length(_oldFloor)),
            _newChest = [];

        for(var i = 0; i < array_length(_chest); i++){
            var c = instances_matching(_chest[i], "", null);
            _newChest[i] = array_slice(c, 0, array_length(c) - array_length(_oldChest[i]));
        }

         // Make Walls:
        with(_newFloor) scrFloorWalls();

         // Spawn Enemies:
        with(_newFloor){
            if(random(_hard + 10) < _hard){
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
                if(random(_hard + 8) < _hard){
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
                    instance_delete(nearest_instance(_sx + random_range(-250, 250), _sy + random_range(-250, 250), _newChest[i]));
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
                if((_lowHP && random(2) < 1) || (GameCont.crown == crwn_life && random(3) < 2)){
                    array_push(_newChest[4], instance_create(x, y, HealthChest));
                    instance_destroy();
                    break;
                }
            }
        }

         // Mimics:
        with(_newChest[1]) if(instance_exists(self) && random(11) < 1){
            instance_create(x, y, Mimic);
            instance_delete(id);
        }
        with(_newChest[4]) if(instance_exists(self) && random(51) < 1){
            instance_create(x, y, SuperMimic);
            instance_delete(id);
        }

         // Extras:
        mod_script_call("area", _area, "area_pop_extras");

         // Done + Fix Random Wall Spawn:
        var _wall = instances_matching(Wall, "", null);

        event_perform(ev_alarm, 1);

        if(instance_number(Wall) > array_length(_wall)){
            with(Wall.id) instance_delete(id);
        }
    }

     // Remove Portal FX:
    with(instances_matching([Spiral, SpiralCont], "", null)) instance_destroy();
    repeat(4) with(instance_nearest(10016, 10016, PortalL)) instance_destroy();
    with(instance_nearest(10016, 10016, PortalClear)) instance_destroy();
    sound_stop(sndPortalOpen);

     // Reset Player & Camera Pos:
    var s = UberCont.opt_shake;
    UberCont.opt_shake = 1;
    with(Player){
        sound_stop(snd_wrld);

        x = _px[index];
        y = _py[index];

        var g = gunangle,
            _x = _vx[index],
            _y = _vy[index];

        gunangle = point_direction(0, 0, _x, _y);
        weapon_post(wkick, point_distance(0, 0, _x, _y), 0);
        gunangle = g;
    }
    UberCont.opt_shake = s;

#define area_get_subarea(_area)
    if(is_real(_area)){
         // Secret Areas:
        if(_area == 106) return 3;
        if(_area >= 100) return 1;

         // Transition Area:
        if((_area % 2) == 1) return 3;

        return 1;
    }

     // Custom Area:
    var _scrt = "area_subarea";
    if(mod_script_exists("area", _area, _scrt)){
        return mod_script_call("area", _area, _scrt);
    }

    return 0;

#define scrFloorWalls() /// this is gross but dont blame me it runs faster than a for loop which is important
    if(!position_meeting(x - 16, y - 16, Floor)) instance_create(x - 16, y - 16, Wall);
    if(!position_meeting(x,      y - 16, Floor)) instance_create(x,      y - 16, Wall);
    if(!position_meeting(x + 16, y - 16, Floor)) instance_create(x + 16, y - 16, Wall);
    if(!position_meeting(x + 32, y - 16, Floor)) instance_create(x + 32, y - 16, Wall);
    if(!position_meeting(x + 32, y,      Floor)) instance_create(x + 32, y,      Wall);
    if(!position_meeting(x + 32, y + 16, Floor)) instance_create(x + 32, y + 16, Wall);
    if(!position_meeting(x - 16, y,      Floor)) instance_create(x - 16, y,      Wall);
    if(!position_meeting(x - 16, y + 16, Floor)) instance_create(x - 16, y + 16, Wall);
    if(!position_meeting(x - 16, y + 32, Floor)) instance_create(x - 16, y + 32, Wall);
    if(!position_meeting(x,      y + 32, Floor)) instance_create(x,      y + 32, Wall);
    if(!position_meeting(x + 16, y + 32, Floor)) instance_create(x + 16, y + 32, Wall);
    if(!position_meeting(x + 32, y + 32, Floor)) instance_create(x + 32, y + 32, Wall);

#define floor_reveal(_floors, _maxTime)
    if(instance_is(self, CustomDraw) && script[2] == "floor_reveal"){
        if(array_length(_floors) > num){
            var _yOffset = 8;
            draw_set_color(area_get_background_color(102));

             // Hiding Floors:
            with(array_slice(_floors, num + 1, array_length(_floors) - (num + 1))){
                draw_rectangle(x - 15, y - _yOffset, x + 32 + 15, y + 31 - _yOffset, 0);
            }

             // Revealing Floor:
            if(time-- > 0){
                var a = (time / _maxTime);
                _yOffset += 4 * a;

                draw_set_alpha(a);
                draw_set_color(merge_color(draw_get_color(), c_white, a));
                with(_floors[num]){
                    draw_rectangle(x - 15, y - _yOffset, x + 32 + 15, y + 31 - _yOffset, 0);
                }
                draw_set_alpha(1);
            }

             // Next Floor:
            else{
                num++;
                time = _maxTime;
            }
        }
        else instance_destroy();
    }
    else with(script_bind_draw(floor_reveal, -7, _floors, _maxTime)){
        time = _maxTime;
        num = 0;
    }

#define area_border(_y, _area, _color)
    if(instance_is(self, CustomDraw) && script[2] == "area_border"){
         // Sprite Fixes:
        var o = instances_matching(Wall, "cat_border_fix", null);
        if(array_length(o) > 0){
            var _spr = [area_get_sprite(_area, sprWall1Bot), area_get_sprite(_area, sprWall1Top), area_get_sprite(_area, sprWall1Out)];
            with(o){
                cat_border_fix = true;
                if(y >= _y){
                    sprite_index = _spr[0];
                    topspr = _spr[1];
                    outspr = _spr[2];
                }
            }
        }
        var o = instances_matching(TopSmall, "cat_border_fix", null);
        if(array_length(o) > 0){
            var _spr = area_get_sprite(_area, sprWall1Trans);
            with(o){
                cat_border_fix = true;
                if(y >= _y) sprite_index = _spr;
            }
        }
        var o = instances_matching(FloorExplo, "cat_border_fix", null);
        if(array_length(o) > 0){
            var _spr = area_get_sprite(_area, sprFloor1Explo);
            with(o){
                cat_border_fix = true;
                if(y >= _y) sprite_index = _spr;
            }
        }
        var o = instances_matching(Debris, "cat_border_fix", null);
        if(array_length(o) > 0){
            var _spr = area_get_sprite(_area, sprDebris1);
            with(o){
                cat_border_fix = true;
                if(y >= _y) sprite_index = _spr;
            }
        }

         // Background:
        var _vx = view_xview_nonsync,
            _vy = view_yview_nonsync;

        draw_set_color(_color);
        draw_rectangle(_vx, _y, _vx + game_width, max(_y, _vy + game_height), 0);
    }
    else script_bind_draw(area_border, 10000, _y, _area, _color);

#define area_get_sprite(_area, _spr)
    return mod_script_call("area", _area, "area_sprite", _spr);

#define floor_at(_x, _y)
    with(instances_matching(instances_matching(Floor, "x", floor(_x / 16) * 16), "y", floor(_y / 16) * 16)){
        if(position_meeting(_x, _y, self)){
            return self;
        }
    }
    with(instances_matching(instances_matching(Floor, "x", (floor((_x + 16) / 32) * 32) - 16), "y", (floor((_y + 16) / 32) * 32) - 16)){
        if(position_meeting(_x, _y, self)){
            return self;
        }
    }
    return noone;

#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)
    var _maxDis = point_distance(_x1, _y1, _x2, _y2),
        _lastx = _x1,
        _lasty = _y1,
        _x = _lastx,
        _y = _lasty,
        o = max(_maxDis / 8, 10),
        a = 0,
        r = [];

    while(point_distance(_x, _y, _x2, _y2) > 2 * o){
        var _dir = point_direction(_x, _y, _x2, _y2);
        _x += lengthdir_x(o, _dir);
        _y += lengthdir_y(o, _dir);

        var d = point_distance(_x, _y, _x2, _y2),
            _off = 4 * sin((d / 8) + (current_frame / 6)),
            m = d / _maxDis,
            _ox = _x + lengthdir_x(_off, _dir - 90) + (_arc * sin(m * pi)),
            _oy = _y + lengthdir_y(_off, _dir - 90) + (_arc * sin(m * pi/2));

        array_push(r, scrLightning(_lastx, _lasty, _ox, _oy, _enemy));
        _lastx = _ox;
        _lasty = _oy;
    }
    array_push(r, scrLightning(_lastx, _lasty, _x2, _y2, _enemy));

    var _ammo = array_length(r) - 1;
    with(r) ammo = _ammo--;

    return r;

#define scrLightning(_x1, _y1, _x2, _y2, _enemy)
    with(instance_create(_x2, _y2, (_enemy ? EnemyLightning : Lightning))){
        image_xscale = -point_distance(_x1, _y1, _x2, _y2) / 2;
        image_angle = point_direction(_x1, _y1, _x2, _y2);
        direction = image_angle;
        return id;
    }

#define in_range(_num, _lower, _upper)
    return (_num >= _lower && _num <= _upper);

#define wep_get(_wep)
    if(is_object(_wep)){
        return wep_get(lq_defget(_wep, "wep", 0));
    }
    return _wep;

#define decide_wep_gold(_minhard, _maxhard, _nowep)
    var _list = ds_list_create(),
        s = weapon_get_list(_list, _minhard, _maxhard);

    ds_list_shuffle(_list);

    for(i = 0; i < s; i++) {
        var w = ds_list_find_value(_list, i),
            c = 0;

         // Weapon Exceptions:
        if(is_array(_nowep) && array_find_index(_nowep, w) >= 0) c = true;
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

#define path_create(_xstart, _ystart, _xtarget, _ytarget)
     // Auto-Determine Grid Size:
    var _tileSize = 16,
        _areaWidth = (ceil(abs(_xtarget - _xstart) / _tileSize) * _tileSize) + 320,
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
        _gridx = round((((_xstart + _xtarget) / 2) - (_areaWidth / 2)) / _tileSize) * _tileSize,
        _gridy = round((((_ystart + _ytarget) / 2) - (_areaHeight / 2)) / _tileSize) * _tileSize,
        _grid = ds_grid_create(_gridw, _gridh),
        _gridCost = ds_grid_create(_gridw, _gridh);

    ds_grid_clear(_grid, -1);

     // Mark Walls:
    with(instance_rectangle(_gridx, _gridy, _gridx + _areaWidth, _gridy + _areaHeight, Wall)){
        _grid[# ((x - _gridx) / _tileSize), ((y - _gridy) / _tileSize)] = -2;
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

#define Pet_create(_x, _y, _name)
    var p = obj_create(_x, _y, "Pet");
    with(p){
        pet = _name;

         // Custom Create Event:
        var _scrt = pet + "_create";
        if(mod_script_exists("mod", "petlib", _scrt)){
            mod_script_call("mod", "petlib", _scrt);
        }

         // Default:
        else{
             // Sprites:
            spr_idle = lq_defget(spr, "Pet" + pet + "Idle", spr_idle);
            spr_walk = lq_defget(spr, "Pet" + pet + "Walk", spr_idle);
            spr_hurt = lq_defget(spr, "Pet" + pet + "Hurt", spr_idle);
        }

        with(scrPickupIndicator(pet)) mask_index = mskWepPickup;
    }

    return p;

#define scrFloorMake(_x, _y, _obj)
    instance_create(_x, _y, Floor);
    return instance_create(_x + 16, _y + 16, _obj);

#define scrFloorFill(_x, _y, _w, _h)
    _w--;
    _h--;
    var o = 32;

     // Center Around x,y:
    _x -= floor(_w / 2) * o;
    _y -= floor(_h / 2) * o;

     // Floors:
    var r = [];
    for(var _ox = 0; _ox <= _w; _ox++){
        for(var _oy = 0; _oy <= _h; _oy++){
            r[array_length(r)] = instance_create(_x + (_ox * o), _y + (_oy * o), Floor);
        }
    }
    return r;

#define scrFloorFillRound(_x, _y, _w, _h)
    _w--;
    _h--;
    var o = 32;

     // Center Around x,y:
    _x -= floor(_w / 2) * o;
    _y -= floor(_h / 2) * o;

     // Floors:
    var r = [];
    for(var _ox = 0; _ox <= _w; _ox++){
        for(var _oy = 0; _oy <= _h; _oy++){
            if((_ox != 0 && _ox != _w) || (_oy != 0 && _oy != _h)){ // Don't Make Corner Floors
                r[array_length(r)] = instance_create(_x + (_ox * o), _y + (_oy * o), Floor);
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