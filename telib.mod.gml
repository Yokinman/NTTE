#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.save = mod_variable_get("mod", "teassets", "save");

     // Refresh Big Decals on Mod Load:
    /*with(instances_named(CustomObject, "BigDecal")){
        sprite_index = lq_defget(spr.BigTopDecal, string(GameCont.area), mskNone);
    }*/
     // Trench big decal bubble spawn points:
    global.decalVents = [
        [  2, -14],
        [ 15,   8],
        [  1,   0],
        [-19,  17],
        [-12,  25],
        [ 11,  28],
        [ 24,  18]];

     // Lightweight Object Lists:
    global.poonRope = [];
    global.catLight = [];

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
            			image_speed = 0;
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
                    if(place_meeting(x, y, PortalShock)) Bone_destroy();
                }
                break;

            case "BoneSpawner":
                o = instance_create(_x, _y, CustomObject);
                with(o) creator = noone;
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
        			alarm0 = 90;
        			alarm1 = -1;
        			alarm2 = -1;
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

                    on_step = script_bind_step(CustomChest_step, 0, id);
                    on_open = ["", "", ""];
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
                    sprite_index = spr.ParrotFeather;
                    depth = -8;

                     // Vars:
                    mask_index = mskLaser;
                    creator = noone;
                    target = noone;
                    stick = false;
                    stickx = 0;
                    sticky = 0;
                    stick_time = 30;
                    fall = 30 + random(40);
                    rot = orandom(3);

                     // Push:
                    motion_add(random(360), 4 + random(2));
                    image_angle = direction + 135;
                }
                break;

            case "ParrotChester":
                o = instance_create(_x, _y, CustomObject)
                with(o){
                     // Vars:
                    creator = noone;
                    num = 12;
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
                }
                break;
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
        			sprite_index = spr_idle;
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
        			alarm0 = 40 + irandom(30);
        		}
            	break;

            case "GoldBabyScorpion":
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
                return mod_script_call("mod", "telib2", "CoastDecal_create", _x, _y, (obj_name == "CoastBigDecal"));

            case "Creature":
        	    o = instance_create(_x, _y, CustomHitme);
        	    with(o){
        	         // visual
        	        spr_idle = spr.CreatureIdle;
        	        spr_walk = spr_idle;
        	        spr_hurt = spr.CreatureHurt;
        	        spr_bott = spr.CreatureBott;
        	        spr_foam = spr.CreatureFoam;
        	        sprite_index = spr_idle;
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
        			alarm0 = 30;
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
        			sprite_index = spr_idle;
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
        			reload = 0;

                     // Alarms:
        			alarm0 = 90 + irandom(60);
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
        			sprite_index = spr_idle;
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
        			alarm0 = 60 + irandom(60);
        			alarm1 = -1;
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
        			sprite_index = spr_idle;
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
                    size = 1;
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
        			sprite_index = spr_idle;
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
        			alarm0 = 30 + irandom(60);
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

                        alarm0 = 20 + random(20);
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

                    alarm0 = 40 + random(30);
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
                    sprite_index = spr_idle;
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
                    alarm0 = 30 + random(90);
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

                    on_open = script_ref_create_ext("mod", "telib2", "ClamChest_open");
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
        			sprite_index = spr_idle;
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
        			alarm0 = 40 + random(20);
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
                    alarm0 = 40 + random(80);
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
        			size = 2;
        			walk = 0;
        			walkspd = 0.6;
        			maxspd = 3;
        			hiding = true;
        			ammo = 0;

                    scrAnglerHide();

                     // Alarms:
        			alarm0 = 30 + irandom(30);
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
                    sprite_index = spr_idle;
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
                    alarm0 = 30;
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
                    sprite_index = spr_idle;
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
                    alarm0 = 40 + irandom(20);

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
                    sprite_index = spr_idle;
                    image_speed = 0.2;

                     // Sounds:
                    snd_hurt = sndOasisHurt;
                    snd_dead = sndOasisDeath;

                     // Vars:
                    depth = -2;
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
                    alarm0 = 90;
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
                    sprite_index = spr_idle;

                     // Sounds
                    snd_hurt = sndOasisHurt;
                    snd_dead = sndOasisExplosionSmall;

                     // Vars:
                    depth = -2;
                    maxhealth = 12;
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
                    sprite_index = spr_idle;
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
                    alarm0 = 20 + irandom(10);
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
        			alarm0 = 60;
        			alarm1 = 120;
                }
                break;

            case "BatBoss":
                var o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
                    spr_idle = spr.BatIdle;
                    spr_walk = spr.BatWalk;
                    spr_hurt = spr.BatHurt;
                    spr_dead = spr.BatDead;
                    spr_fire = spr.BatYell;
        			spr_weap = spr.BatBossWeap;
        			spr_shadow = shd48;
        			hitid = [spr_idle, "BIG BAT"];
        			mask_index = mskScorpion;
        			image_xscale = 1.2;
        			image_yscale = 1.2;
        			image_blend = merge_color(c_red, c_white, 0.5);
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
        			alarm0 = 60;
        			alarm1 = 90;
        			alarm2 = 120;
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
                    sprite_index = spr_idle;

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
        			spr_weap = spr.CatWeap;
        			spr_shadow = shd24;
        			hitid = [spr_idle, _name];
        			sprite_index = spr_idle;
        			mask_index = mskBandit;
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
        			gunangle = random(360);
        			hole = noone;
        			direction = gunangle;
        			ammo = 0;
        			cantravel = false;

        			 // Alarms:
        			alarm0 = 40 + irandom(20);
        			alarm1 = 40 + irandom(20);
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
        			spr_idle = spr.CatIdle;
        			spr_walk = spr.CatWalk;
        			spr_hurt = spr.CatHurt;
        			spr_dead = spr.CatDead;
        			spr_weap = spr.CatBossWeap;
        			spr_shadow = shd24;
        			hitid = [spr_idle, bossname];
        			sprite_index = spr_idle;
        			mask_index = mskBandit;
        			depth = -2;
        			image_xscale *= 1.5;
        			image_yscale *= 1.5

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
        			alarm0 = 40 + irandom(20);
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
                    snd_dead = sndGeneratorBreak;

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
                    sprite_index = spr.Manhole;
                    mask_index = mskWepPickup;
                    image_speed = 0;

                     // Vars:
                    depth = 7;
                    fullofrats = true;
                    cat = noone;

                    if(place_meeting(x, y, CustomObject)){
                        with(instances_named(CustomObject, "CatholeBig")){
                            if(place_meeting(x, y, other)) with(other){
                                instance_destroy();
                                exit;
                            }
                        }
                    }
                    with(instance_nearest(x, y, Floor)) if(place_meeting(x, y, other)){
                        sprite_index = spr.ManholeBottom;
                    }
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

                array_push(global.catLight, o);
                return o;

            case "ChairFront":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = spr.ChairFrontIdle;
                    spr_hurt = spr.ChairFrontHurt;
                    spr_dead = spr.ChairDead;
                    sprite_index = spr_idle;

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
                    sprite_index = spr_idle;
                }
                break;

            case "Couch":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = spr.CouchIdle;
                    spr_hurt = spr.CouchHurt;
                    spr_dead = spr.CouchDead;
                    sprite_index = spr_idle;

                     // Sounds:
                    snd_hurt = sndHitPlant;
                    snd_dead = sndWheelPileBreak;

                     // Vars:
                    maxhealth = 20;
                    size = 3;
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
                    sprite_index = spr_idle;
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

                    script_bind_end_step(PizzaTV_end_step, 0, id);
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

                    on_step = VenomFlak_step;
                    on_draw = VenomFlak_draw;
                    on_destroy = VenomFlak_destroy;
                    on_wall = VenomFlak_wall;
                }
                return o;
                break;

        //#endregion

        //#region CRYSTAL CAVES
        	case "InvMortar":
        	    o = obj_create(_x, _y, "Mortar");
        	    with(o){
        	        // Visual:
        	       spr_idle = spr.InvMortarIdle;
        	       spr_walk = spr.InvMortarWalk;
        	       spr_fire = spr.InvMortarFire;
        	       spr_hurt = spr.InvMortarHurt;
        	       spr_dead = spr.InvMortarDead;
        	        // Shh don't tell yokin:
        	       on_hurt = script_ref_create(InvMortar_hurt);
        	       on_step = script_ref_create(InvMortar_step);
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
        			sprite_index = spr_idle;
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
        			alarm0 = 100 + irandom(40);
        			alarm1 = -1;
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
        			sprite_index = spr_idle;
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
        			alarm0 = 20 + irandom(20);
        			alarm1 = 300 + random(90);
        	    }
        	    break;

    	//#endregion

    	default:
    		return ["BigDecal", "Bone", "BoneSpawner", "BubbleBomb", "SuperBubbleBomb", "BubbleExplosion", "CoastBossBecome", "CoastBoss", "CustomChest", "Harpoon", "LightningDisc", "LightningDiscEnemy", "Manhole", "NetNade", "ParrotFeather", "ParrotChester", "Pet", "PizzaBoxCool",
    		        "BabyScorpion", "GoldBabyScorpion",
    		        "BloomingCactus", "BuriedCar", "CoastBigDecal", "CoastDecal", "Creature", "Diver", "DiverHarpoon", "Gull", "Palanking", "PalankingDie", "Palm", "Pelican", "Seal", "SealAnchor", "SealHeavy", "SealMine", "TrafficCrab", "TrafficCrabVenom",
    		        "ClamChest", "Hammerhead", "Puffer", "Crack",
    		        "Angler", "Eel", "Jelly", "JellyElite", "Kelp", "PitSquid", "Tentacle", "TentacleRip", "TrenchFloorChunk", "Vent", "YetiCrab",
    		        "Bat", "BatBoss", "BatScreech", "Cabinet", "Cat", "CatBoss", "CatBossAttack", "CatDoor", "CatGrenade", "CatHole", "CatHoleBig", "CatLight", "ChairFront", "ChairSide", "Couch", "NewTable", "Paper", "PizzaDrain", "PizzaTV", "VenomFlak",
    		        "InvMortar", "Mortar", "MortarPlasma", "NewCocoon", "Spiderling"
    		        ];
    }

     /// Auto Assign Things:
    var _scrt = ["step", "begin_step", "end_step", "draw", "destroy", "hurt", "death", "cleanup", "hit", "wall", "anim", "grenade", "projectile", "alrm0", "alrm1", "alrm2", "alrm3", "alrm4", "alrm5", "alrm6", "alrm7", "alrm8", "alrm9", "alrm10", "alrm11"];
    with(o){
        if("name" not in self) name = string(obj_name);

         // Scripts:
        for(var i = 0; i < array_length(_scrt); i++){
            var v = "on_" + _scrt[i];
            if(v not in self || is_undefined(variable_instance_get(id, v))){
                var s = name + "_" + _scrt[i],
                    _mod = [mod_current, "telib2"],
                    m = false;

                for(var j = 0; j < array_length(_mod); j++){
                    if(mod_script_exists("mod", _mod[j], s)){
                        variable_instance_set(id, v, ["mod", _mod[j], s]);
                        m = true;
                        break;
                    }
                }

                 // Exceptions:
                if(!m) switch(v){
                    case "on_hurt":
                        on_hurt = enemyHurt; break;

                    case "on_death":
                        if(instance_is(self, CustomEnemy)){
                            on_death = scrDefaultDrop;
                        }
                        break;

                    case "on_draw":
                        if(instance_is(self, CustomEnemy)){
                            on_draw = draw_self_enemy;
                        }
                        break;
                }
            }
        }

         // Auto-fill HP:
        if(instance_is(self, CustomHitme) || instance_is(self, CustomProp)){
            if(my_health == 1) my_health = maxhealth;
        }
    }
    return o;


#define BigDecal_step
    if(!instance_exists(GenCont)){
         // Area-Specifics:
        switch(GameCont.area){
            case "trench":
                // Trench vent bubbles:
                for(var i = 0; i < array_length(global.decalVents); i++){
                    if(random(8) < current_time_scale){
                        var p = global.decalVents[i];
                        with(instance_create(x + p[0], y + p[1], Bubble)){
                            depth = -9;
                            friction = 0.2;
                            motion_set(90 + orandom(5), random_range(4, 7));
                        }
                    }
                }
                break;
        }

         // he ded lol:
        if(place_meeting(x, y, Floor)){
            instance_destroy();
        }
    }

#define BigDecal_draw
     // Bubble Fix:
    if(distance_to_object(Bubble) < 40){
        with(instance_rectangle(bbox_left, bbox_top - 32, bbox_right, bbox_bottom, Bubble)){
            draw_self();
        }
    }

#define BigDecal_destroy
     // General FX:
    sleep(100);
    view_shake_at(x, y, 50);
    with(instance_create(x, y, PortalClear)){
        mask_index = other.mask_index;
    }
    repeat(irandom_range(9, 18)){
        with(instance_create(x, y, Debris)){
            speed = random_range(6, 12);
        }
    }

     // Area-Specifics:
    var _x = x,
        _y = y + 16;

    switch(GameCont.area){
        case 1 : // Spawn a handful of crab bones:
            repeat(irandom_range(2, 3)) with instance_create(_x, _y, WepPickup){
                motion_set(irandom(359), random_range(3, 6));
                wep = "crabbone";
            }
            break;

        case 2 : // Spawn a bunch of frog eggs:
            repeat(irandom_range(3, 5)){
                with(instance_create(_x + orandom(24), _y + irandom(16), FrogEgg)){
                    alarm0 = irandom_range(20, 40);
                }
            }
            break;
    }

#define Bone_step
     // Spin:
    rotation += speed * rotspeed;

     // Into Portal:
    if(place_meeting(x, y, Portal)){
        if(speed > 0){
            sound_play_pitchvol(sndMutant14Turn, 0.6 + random(0.2), 0.8);
            repeat(3) instance_create(x, y, Smoke);
        }
        instance_destroy();
    }

     // Turn Back Into Weapon:
    else if(speed <= 0 || place_meeting(x + hspeed, y + vspeed, PortalShock)){
         // Don't Get Stuck on Wall:
        mask_index = mskWepPickup;
        if(place_meeting(x, y, Wall)){
            instance_create(x, y, Dust);

            var w = instance_nearest(x, y, Wall),
                _dir = point_direction(w.x, w.y, x, y);

            while(place_meeting(x, y, w)){
                x += lengthdir_x(4, _dir);
                y += lengthdir_y(4, _dir);
            }
        }

        instance_destroy();
    }

#define Bone_draw
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, rotation, image_blend, image_alpha);

#define Bone_hit
     // Secret:
    if("name" in other && other.name == "CoastBossBecome"){
        with(other){
            part++;

             // Hit:
            sound_play_hit(snd_hurt, 0.3);
            sprite_index = spr_hurt;
            image_index = 0;
        }

         // Effects:
        sound_play_hit(sndMutant14Turn, 0.2);
        repeat(3){
            instance_create(x + orandom(4), y + orandom(4), Bubble);
            with(instance_create(x, y, Smoke)){
                motion_add(random(360), 1);
                depth = -2;
            }
        }

        instance_delete(id);
        exit;
    }

    if(other.object_index = ScrapBoss) {
        with(other) {
            var c = scrCharm(self, true);
            c.time = 300;
        }
        sound_play(sndBigDogTaunt);
        instance_delete(id);
        exit;
    }

    projectile_hit_push(other, damage, speed * force);

     // Bounce Off Enemy:
    direction = point_direction(other.x, other.y, x, y);
    speed /= 2;
    rotspeed *= -1;

     // Sound:
    sound_play_pitchvol(sndBloodGamble, 1.2 + random(0.2), 0.8);

     // Break:
    var i = nearest_instance(x, y, instances_matching(CustomProp,"name","CoastBossBecome"));
    if !(instance_exists(i) && point_distance(x, y, i.x, i.y) <= 32){
        broken = true;
        instance_destroy();
    }

#define Bone_wall
     // Bounce Off Wall:
    if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
    if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;
    speed /= 2;
    rotspeed *= -1;

     // Effects:
    sound_play_hit(sndHitWall, 0.2);
    instance_create(x, y, Dust);

#define Bone_destroy
    instance_create(x, y, Dust);

     // Darn:
    if(broken){
        sound_play_pitch(sndHitRock, 1.4 + random(0.2));
        repeat(2) with(instance_create(x, y, Shell)){
            sprite_index = spr.BoneShard;
            motion_add(random(360), 2);
        }
    }

     // Pickupable:
    else with(instance_create(x, y, WepPickup)){
        wep = "crabbone";
        rotation = other.rotation;
    }


#define BoneSpawner_step
    if(instance_exists(creator)){
         // Follow Creator:
        x = creator.x;
        y = creator.y;
    }
    else{
         // Enter the bone zone:
        with(instance_create(x, y, WepPickup)){
            wep = "crabbone";
            motion_add(random(360), 3);
        }

         // Effects:
        repeat(2) with(instance_create(x, y, Dust)){
            motion_add(random(360), 3);
        }

        //with(instances_named(object_index, name)) instance_destroy();
        instance_destroy();
    }


    #define BubbleBomb_step
         // Float Up:
        z_engine();
        image_angle += (sin(current_frame / 8) * 10) * current_time_scale;
        depth = min(depth, -z);

         // Collision:
        if(place_meeting(x, y, Player)) with(Player){
            if(place_meeting(x, y, other)) with(other){
                motion_add(point_direction(other.x, other.y, x, y), 1.5);
            }
        }
        if(place_meeting(x, y, object_index)){
            with(nearest_instance(x, y, instances_matching_ne(instances_named(object_index, name), "id", id))){
                if(place_meeting(x, y, other)){
                    with(other) motion_add(point_direction(other.x, other.y, x, y), 0.5);
                }
            }
        }

         // Baseball:
        if(place_meeting(x, y, projectile)){
            var _slash = [Slash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, CustomSlash],
                _meeting = false;

            for(var i = 0; i < array_length(_slash); i++){
                if(place_meeting(x, y, _slash[i])){
                    var s = instance_nearest(x, y, _slash[i]);
                    direction = s.direction;
                    speed = 8;
                    break;
                }
            }
        }

         // Charged:
        if(current_frame_active){
            image_blend = c_white;
            if(random(image_number - image_index + 8) < 1){
                image_blend = c_black;
                var o = image_index / 3;
                instance_create(x + orandom(o), y + orandom(o), PortalL);
            }
        }

         // Bubble charge effect:
        if speed <= 0 && random(12) < current_time_scale
            with instance_create(x, y - z, BulletHit) sprite_index = spr.BubbleCharge;

    #define BubbleBomb_end_step
         // Hold Projectile:
        if(instance_exists(my_projectile)) with(my_projectile){
            //speed += friction * current_time_scale;
            other.x += (hspeed / 4);
            other.y += (vspeed / 4);

            var s = (current_frame / 1.5) + direction;
            x = other.x;
            y = other.y - other.z;
        }

         // Grab Projectile:
        else if(place_meeting(x, y, projectile)){
            with(instances_matching_ne(instances_matching_ne(instances_matching_ne(instances_matching(projectile, "bubble_bombed", null, false), "team", team), "typ", 0), "name", name)){
                if(place_meeting(x, y, other)){
                    if(object_index == Flame || object_index == Bolt || object_index == Splinter || object_index == HeavyBolt || object_index == UltraBolt){
                        with(other) instance_destroy();
                    }
                    else{
                        bubble_bombed = true;
                        other.my_projectile = id;
                        with(other){
                            x = other.x;
                            y = other.y + z;
                            motion_add(other.direction, min(other.speed / 2, other.force));

                             // Effects:
                            instance_create(x, y, Dust);
                            repeat(4) instance_create(x, y, Bubble);
                            sound_play(sndOasisHurt);
                        }
                    }

                    break;
                }
            }
        }

    #define BubbleBomb_draw
        draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
        //draw_sprite_ext(asset_get_index(`sprPortalL${(x mod 5) + 1}`), image_index, x, y - z, image_xscale, image_yscale, image_angle / 3, image_blend, image_alpha);

    #define BubbleBomb_hit
        if(other.team != 0){
             // Knockback:
            if(random(2) < 1){
                speed *= 0.9;
                with(other) motion_add(other.direction, other.force);
            }

             // Speed Up:
            if(team == 2) image_index += image_speed * 2;
        }

    #define BubbleBomb_wall
        if(speed > 0){
            sound_play(sndBouncerBounce);
            move_bounce_solid(false);
            speed *= 0.5;
        }

    #define BubbleBomb_anim
        with(my_projectile) instance_destroy();

         // Explode:
        with(obj_create(x, y, "BubbleExplosion")){
            team = other.team;
            var c = other.creator;
            if(instance_exists(c)){
                if(c.object_index == Player) team = 2;
                else if(team == 2) team = -1; // Popo nade logic
            }
            hitid = other.hitid;
        }
        instance_destroy();

    #define BubbleBomb_destroy
         // Pop:
        sound_play_pitchvol(sndLilHunterBouncer, 2 + random(0.5), 0.5);
        with(instance_create(x, y - z, BulletHit)){
            sprite_index = sprPlayerBubblePop;
            image_angle = other.image_angle;
            image_xscale = 0.5 + (0.01 * other.image_index);
            image_yscale = image_xscale;
        }

#define SuperBubbleBomb_step
// Float Up:
z_engine();
image_angle += (sin(current_frame / 8) * 10) * current_time_scale;
depth = min(depth, -z);

 // Collision:
if(place_meeting(x, y, Player)) with(Player){
  if(place_meeting(x, y, other)) with(other){
    motion_add(point_direction(other.x, other.y, x, y), 1.5);
  }
}
if(place_meeting(x, y, object_index)){
  with(nearest_instance(x, y, instances_matching_ne(instances_named(object_index, name), "id", id))){
    if(place_meeting(x, y, other)){
      with(other) motion_add(point_direction(other.x, other.y, x, y), 0.5);
    }
  }
}

// Baseball:
if(place_meeting(x, y, projectile)){
var _slash = [Slash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, CustomSlash],
_meeting = false;

for(var i = 0; i < array_length(_slash); i++){
  if(place_meeting(x, y, _slash[i])){
      var s = instance_nearest(x, y, _slash[i]);
      direction = s.direction;
      speed = 8;
      break;
    }
  }
}

// Charged:
if(current_frame_active){
image_blend = c_white;
if(random(image_number - image_index + 8) < 1){
    image_blend = c_black;
    var o = image_index / 3;
    instance_create(x + orandom(o), y + orandom(o), PortalL);
  }
}

// Bubble charge effect:
if speed <= 0 && random(12) < current_time_scale
with instance_create(x, y - z, BulletHit) sprite_index = spr.BubbleCharge;

#define SuperBubbleBomb_end_step
// Hold Projectile:
if(instance_exists(my_projectile)) with(my_projectile){
  //speed += friction * current_time_scale;
  other.x += (hspeed / 4);
  other.y += (vspeed / 4);

  var s = (current_frame / 1.5) + direction;
  x = other.x;
  y = other.y - other.z;
}

// Grab Projectile:
else if(place_meeting(x, y, projectile)){
  with(instances_matching_ne(instances_matching_ne(instances_matching_ne(instances_matching(projectile, "bubble_bombed", null, false), "team", team), "typ", 0), "name", name)){
    if(place_meeting(x, y, other)){
      if(object_index == Flame || object_index == Bolt || object_index == Splinter || object_index == HeavyBolt || object_index == UltraBolt){
        with(other) instance_destroy();
      }
      else{
        bubble_bombed = true;
        other.my_projectile = id;
        with(other){
          x = other.x;
          y = other.y + z;
          motion_add(other.direction, min(other.speed / 2, other.force));

          // Effects:
          instance_create(x, y, Dust);
          repeat(4) instance_create(x, y, Bubble);
          sound_play(sndOasisHurt);
        }
      }

      break;
    }
  }
}

#define SuperBubbleBomb_draw
draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
//draw_sprite_ext(asset_get_index(`sprPortalL${(x mod 5) + 1}`), image_index, x, y - z, image_xscale, image_yscale, image_angle / 3, image_blend, image_alpha);

#define SuperBubbleBomb_hit
if(other.team != 0){
  // Knockback:
  if(random(2) < 1){
    speed *= 0.9;
    with(other) motion_add(other.direction, other.force);
  }

  // Speed Up:
  if(team == 2) image_index += image_speed * 2;
}

#define SuperBubbleBomb_wall
if(speed > 0){
  sound_play(sndBouncerBounce);
  move_bounce_solid(false);
  speed *= 0.5;
}

#define SuperBubbleBomb_anim
with(my_projectile) instance_destroy();

// Explode:
sleep(15)
view_shake_at(x,y,60)
var _ang  = random(360);
repeat(3)
{
  with(obj_create(x+lengthdir_x(16,_ang), y+lengthdir_y(16,_ang), "BubbleExplosion")){
    team = other.team;
    var c = other.creator;
    if(instance_exists(c)){
      if(c.object_index == Player) team = 2;
      else if(team == 2) team = -1; // Popo nade logic
    }
    hitid = other.hitid;
  }
  with(obj_create(x+lengthdir_x(16,_ang+60), y+lengthdir_y(16,_ang+60), "SmallBubbleExplosion")){
    team = other.team;
    var c = other.creator;
    if(instance_exists(c)){
      if(c.object_index == Player) team = 2;
      else if(team == 2) team = -1; // Popo nade logic
    }
    hitid = other.hitid;
  }
  _ang +=  120;
  scrWaterStreak(x,y,_ang,10)
}
repeat(5){
  _ang += 72;
  with(obj_create(x,y,"BubbleBomb")){
      move_contact_solid(_ang, 2);
      motion_add(_ang + orandom(6), 7);
      team = other.team;
      creator = other;
      friction *= 1.2;
      image_speed += (irandom_range(-2,2)/50);
  }
}
repeat(3)with(obj_create(x+random_range(-3,3),y+random_range(-3,3),"BubbleBomb")){
  team = other.team;
  creator = other;
}
instance_destroy();

#define SuperBubbleBomb_destroy
// Pop:
sound_play_pitch(sndOasisExplosion,.8);
sound_play_pitchvol(sndLilHunterBouncer, 2 + random(0.5), 0.5);
with(instance_create(x, y - z, BulletHit)){
  sprite_index = sprPlayerBubblePop;
  image_angle = other.image_angle;
  image_xscale = 0.5 + (0.01 * other.image_index);
  image_yscale = image_xscale;
}




#define CoastBossBecome_step
    speed = 0;

     // Animate:
    image_index = part;
    if(nexthurt > current_frame + 3) sprite_index = spr_hurt;
    else sprite_index = spr_idle;

     // Skeleton Rebuilt:
    if(part >= sprite_get_number(spr_idle) - 1){
        with(obj_create(x - (image_xscale * 8), y - 6, "CoastBoss")){
            x = xstart;
            y = ystart;
            right = other.image_xscale;
        }
        with(WantBoss) instance_destroy();
        with(BanditBoss) my_health = 0;
        scrPortalPoof();

        instance_delete(id);
    }

     // Death:
    else if(my_health <= 0) instance_destroy();

#define CoastBossBecome_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);  // Sound

#define CoastBossBecome_destroy
    with(instance_create(x, y, Corpse)){
        sprite_index = other.spr_dead;
        image_xscale = other.image_xscale;
        size = other.size;
    }

     // Death Effects:
    if(part > 0){
        sound_play(sndOasisDeath);
        repeat(part * 2) instance_create(x, y, Bubble);
    }
    else for(var a = direction; a < direction + 360; a += (360 / 10)){
        with(instance_create(x, y, Dust)) motion_add(a, 3);
    }


#define CoastBoss_step
    enemyAlarms(3);

     // Animate:
    if(
        sprite_index != spr_hurt &&
        sprite_index != spr_spwn &&
        sprite_index != spr_dive &&
        sprite_index != spr_rise &&
        sprite_index != spr_efir &&
        sprite_index != spr_fire &&
        sprite_index != spr_chrg
    ){
        if(speed <= 0) sprite_index = spr_idle;
    	else if(sprite_index == spr_idle) sprite_index = spr_walk;
    }
    else if(anim_end){
        var _lstspr = sprite_index;
        if(fork()){
            if(sprite_index == spr_spwn) {
                sprite_index = spr_idle;

                 // Spawn FX:
                hspeed += 2 * right;
                vspeed += orandom(2);
                view_shake_at(x, y, 15);
                sound_play(sndOasisBossIntro);
                instance_create(x, y, PortalClear);
                repeat(10) with(instance_create(x, y, Dust)){
                    motion_add(random(360), 5);
                }

                 // Intro:
                if(!intro){
                    intro = true;
                    scrBossIntro("", sndOasisBossIntro, musBoss1);
                    with(MusCont) alarm_set(3, -1);
                }
                exit; }

            if(sprite_index = spr_dive) {
                sprite_index = spr_idle;

                 // Start Swimming:
                swim = 180;
                direction = 90 - (right * 90);
                swim_ang_frnt = direction;
                swim_ang_back = direction;
                exit; }

            if(sprite_index = spr_hurt || sprite_index == spr_efir){
                sprite_index = spr_idle;
                exit; }

            if(sprite_index = spr_rise){
                sprite_index = spr_idle;
                spr_shadow = spr_shad;
                exit; }

            if(sprite_index = spr_chrg){
                sprite_index = spr_fire;
                exit; }

            if(sprite_index = spr_fire && ammo <= 0){
                sprite_index = spr_efir;
                exit; }
        }
        if(sprite_index != _lstspr) image_index = 0;
    }

     // Movement:
    enemyWalk(walkspd, maxspd);

     // Swimming:
    if(swim > 0){
        swim -= current_time_scale;

         // Jus keep movin:
        if(instance_exists(swim_target)){
            speed += (friction + (swim / 120)) * current_time_scale;

             // Turning:
            var _x = swim_target.x,
                _y = swim_target.y;

            if(point_distance(x, y, _x, _y) < 100){
                var _dis = 80,
                    _dir = direction + (10 * right);

                _x += lengthdir_x(_dis, _dir);
                _y += lengthdir_y(_dis, _dir);
            }

            direction += (angle_difference(point_direction(x, y, _x, _y), direction) / 16) * current_time_scale;
        }
        else swim = 0;

         // Turn Fins:
        swim_ang_frnt += (angle_difference(direction, swim_ang_frnt) / 3) * current_time_scale;
        swim_ang_back += (angle_difference(swim_ang_frnt, swim_ang_back) / 10) * current_time_scale;

         // Break Walls:
        if(place_meeting(x + hspeed, y + vspeed, Wall)){
            speed *= 2/3;

             // Effects:
            var w = instance_nearest(x, y, Wall);
            with(instance_create(w.x, w.y, MeleeHitWall)){
                motion_add(point_direction(x, y, other.x, other.y), 1);
                image_angle = direction + 180;
            }
            sound_play_pitchvol(sndHammerHeadProc, 1.4 + random(0.2), 0.5);

             // Break Walls:
            with(instance_create(x, y, PortalClear)){
                image_xscale /= 2;
                image_yscale = image_xscale;
            }
        }

         // Visual:
        spr_shadow = mskNone;
        if(current_frame_active){
            var _cx = x,
                _cy = bbox_bottom;

             // Debris:
            if((place_meeting(x, y, FloorExplo) && random(30) < 1) || random(40) < 1){
                repeat(irandom(2)){
                    with(instance_create(_cx, _cy, Debris)){
                        speed /= 2;
                    }
                }
            }

             // Ripping Through Ground:
            var _oDis = [16, -4],
                _oDir = [swim_ang_frnt, swim_ang_back],
                _ang = [20, 30];

            for(var o = 0; o < array_length(_oDis); o++){
                for(var i = -1; i <= 1; i += 2){
                    var _x = _cx + lengthdir_x(_oDis[o], _oDir[o]),
                        _y = _cy + lengthdir_y(_oDis[o], _oDir[o]),
                        a = (i * _ang[o]);

                     // Cool Trail FX:
                    if(speed > 1) with(instance_create(_x, _y, BoltTrail)){
                        motion_add(_oDir[o] + 180 + a, (other.speed + random(other.speed)) / 2);
                        image_xscale = speed * 2;
                        image_yscale = (skill_get(mut_bolt_marrow) ? 0.6 : 1);
                        image_angle = direction;
                        hspeed += other.hspeed;
                        vspeed += other.vspeed;
                        friction = random(0.5);
                        //image_blend = make_color_rgb(110, 184, 247);
                    }

                     // Kick up Dust:
                    if(random(20) < 1){
                        with(instance_create(_x, _y, Dust)){
                            hspeed += other.hspeed / 2;
                            vspeed += other.vspeed / 2;
                            motion_add(_oDir[o] + 180 + (2 * a), other.speed);
                            image_xscale *= .75;
                            image_yscale = image_xscale;
                        }
                    }
                }
            }

             // Quakes:
            if(random(4) < 1) view_shake_at(_cx, _cy, 4);
        }

         // Un-Dive:
        if(swim <= 0){
            swim = 0;
            alarm2 = -1;
            image_index = 0;
            sprite_index = spr_rise;
            scrRight(direction);
            speed = 0;

             // Babbies:
            /*if(GameCont.loops > 0) repeat(GameCont.loops * 3){
                with(instance_create(x, y, BoneFish)) kills = 0;
            }*/

             // Effects:
            instance_create(x, y, PortalClear);
            sound_play_pitchvol(sndFootOrgSand1, 0.5, 5);
            sound_play_pitchvol(sndToxicBoltGas, 0.5 + random(0.2), 0.5);
            repeat(10){
                var _dis = 12,
                    _dir = random(360);

                with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Dust)){
                    motion_add(_dir, 3);
                }
            }
        }
    }

     // Fish Train:
    if(array_length(fish_train) > 0){
        var _leader = id,
            _broken = false;

        for(var i = 0; i < array_length(fish_train); i++){
            if(_broken){
                with(fish_train[i]) visible = 1;
                fish_train[i] = noone;
            }
            else{
                var _fish = fish_train[i],
                    b = false;

                 // Fish Regen:
                if(array_length(fish_swim) > i && fish_swim[i]){
                    if(!instance_exists(_fish) && fish_swim_regen <= 0){
                        fish_swim_regen = 3;

                        if(random(100) < 1) _fish = obj_create(_leader.x, _leader.y, "Puffer");
                        else _fish = instance_create(_leader.x, _leader.y, BoneFish);
                        with(_fish){
                            kills = 0;
                            creator = other;

                             // Keep Distance:
                            var l = 2,
                                d = _leader.direction + 180;

                            while(point_distance(x, y, _leader.x, _leader.y) < 24){
                                x += lengthdir_x(l, d);
                                y += lengthdir_y(l, d);
                                direction = d;
                            }

                             // Spawn Poof:
                            //sound_play(snd)
                            repeat(8) with(instance_create(x, y, Dust)){
                                motion_add(random(360), 1);
                                depth = other.depth - 1;
                            }
                        }

                        fish_train[i] = _fish;
                    }
                }

                if(instance_exists(_fish)){
                    with(_fish){
                        alarm1 = 15 + (i * 4);

                         // Swimming w/ Big Fish:
                        visible = !other.fish_swim[i];
                        if(other.fish_swim[i]){
                            scrRight(point_direction(x, y, _leader.x, _leader.y));

                            if(random(3) < 1 && speed > 0){
                                with(instance_create(x + orandom(6), y + random(8), Sweat)){
                                    direction = other.direction + choose(-120, 120) + orandom(10);
                                    speed = 0.5;
                                }
                            }
                        }

                         // Follow the Leader:
                        var _dis = distance_to_object(_leader),
                            _max = 6;

                        if(_dis > _max){
                            var l = 2,
                                d = point_direction(x, y, _leader.x, _leader.y);

                            while(_dis > _max){
                                x += lengthdir_x(l, d);
                                y += lengthdir_y(l, d);
                                _dis -= l;
                            }
                            motion_add(d, 1);
                        }
                        _leader = id;
                    }
                }
                else{
                    _broken = true;
                    fish_train[i] = noone;
                }
            }
        }
    }

     // Gradual Swim Train:
    if(fish_swim_delay <= 0){
        fish_swim_delay = 3;
        for(var i = 0; i <= 1; i++){
            var p = array_find_last_index(fish_swim, i);
            if(p >= 0 && p < array_length(fish_train) - 1){
                fish_swim[p + 1] = i;

                 // EZ burrow:
                with(fish_train[p + 1]){
                    repeat(8) with(instance_create(x + orandom(8) + hspeed, y + orandom(8) + vspeed, Dust)){
                        depth = other.depth - 1;
                    }
                }
            }
        }
        fish_swim[0] = (swim > 0);
    }
    fish_swim_delay -= current_time_scale;
    fish_swim_regen -= current_time_scale;

#define CoastBoss_hurt(_hitdmg, _hitvel, _hitdir)
     // Can't be hurt while swimming:
    if(swim){
        with(other) if("typ" in self && typ != 0){
             // Effects:
            sound_play_pitch(sndCrystalPropBreak, 0.7);
            sound_play_pitchvol(sndShielderDeflect, 1.5, 0.5);
            repeat(5) with(instance_create(x, y, Dust)){
                motion_add(random(360), 3);
            }

             // Destroy (1 frame delay to prevent errors):
            if(fork()){
                wait 1;
                if(instance_exists(self)) instance_destroy();
                exit;
            }
        }
    }
    else{
        my_health -= _hitdmg;           // Damage
        nexthurt = current_frame + 6;	// I-Frames

         // Sound:
        sound_play_hit(swim ? sndBigMaggotHit : snd_hurt, 0.3);

         // Knockback:
        if(!swim){
            motion_add(_hitdir, _hitvel);
        }

         // Hurt Sprite:
        if(
            sprite_index != spr_fire &&
            sprite_index != spr_chrg &&
            sprite_index != spr_efir &&
            sprite_index != spr_dive &&
            sprite_index != spr_rise
        ){
            sprite_index = spr_hurt;
            image_index = 0;
        }
    }

#define CoastBoss_draw
    var h = (nexthurt > current_frame + 3);

    var _leader = id;
    with(fish_train) if(instance_exists(self) && other.fish_swim[array_find_index(other.fish_train, self)]){
        var _spr = sprite_index,
            _img = image_index,
            _xscale = image_xscale * right,
            _yscale = image_yscale,
            _x = x - (sprite_get_xoffset(_spr) * _xscale),
            _y = bbox_bottom - (sprite_get_yoffset(_spr) * _yscale) - 1 + spr_shadow_y;

        draw_sprite_part_ext(_spr, _img, 0, 0, sprite_get_width(_spr), sprite_get_yoffset(_spr), _x, _y, _xscale, _yscale, image_blend, image_alpha);
    }

    if(swim > 0){
        var _cx = x,
            _cy = bbox_bottom;

        if(h) d3d_set_fog(1, c_white, 0, 0);
        for(var a = 0; a < 4; a++){
            var _x = _cx,
                _y = _cy,
                _xscale = image_xscale,
                _yscale = image_yscale,
                _blend = image_blend,
                _alpha = image_alpha,
                _swimSpd = (current_frame / 3),
                _spr = [spr.BigFishSwimFrnt,            spr.BigFishSwimBack                 ],
                _ang = [swim_ang_frnt,                  swim_ang_back                       ],
                _dis = [10 * _xscale,                   10 * _xscale                        ], // Offset Distance
                _dir = [_ang[0] + (5 * sin(_swimSpd)),  _ang[1] + 180 + (5 * sin(_swimSpd)) ], // Offset Direction
                _trn = [15 * cos(_swimSpd),             -25 * cos(_swimSpd)                 ];

             // Outline:
            if(a < 3){
                _blend = c_black;
                _x += lengthdir_x(1, a * 90);
                _y += lengthdir_y(1, a * 90);
            }

             // Draw Front & Back Fins:
            for(var j = 0; j < array_length(_spr); j++){
                var s = _spr[j],
                    _drawx = _x + lengthdir_x(_dis[j], _dir[j]),
                    _drawy = _y + lengthdir_y(_dis[j], _dir[j]);

                for(var i = 0; i < sprite_get_number(s); i++){
                    draw_sprite_ext(s, i, _drawx, _drawy - (i * _yscale), _xscale, _yscale, _ang[j] + _trn[j], _blend, _alpha);
                }
            }
        }
    }

     // Normal Self:
    else{
        if(h && sprite_index != spr_hurt) d3d_set_fog(1, c_white, 0, 0);
        draw_self_enemy();
    }

    if(h) d3d_set_fog(0, 0, 0, 0);

#define CoastBoss_alrm0
    alarm0 = 30 + random(20);

    target = instance_nearest(x, y, Player);

    if(instance_exists(target)){
        if(target_in_distance(0, 160) && (target.reload <= 0 || random(3) < 2)){
            var _targetDir = point_direction(x, y, target.x, target.y);

             // Move Towards Target:
            if((target_in_distance(0, 64) && random(2) < 1) || random(4) < 1){
                scrWalk(30 + random(10), _targetDir + orandom(10));
                alarm0 = walk + random(10);
            }

             // Bubble Blow:
            else{
                gunangle = _targetDir;
                ammo = 4 * (GameCont.loops + 2);

                scrWalk(8, gunangle + orandom(30));

                image_index = 0;
                sprite_index = spr_chrg;
                sound_play_pitch(sndOasisBossFire, 1 + orandom(0.2));

                alarm1 = 3;
                alarm0 = -1;
            }

            scrRight(_targetDir);
        }

         // Dive:
        else alarm2 = 6;
    }

     // Passive Movement:
    else{
        alarm0 = 40 + random(20);
        scrWalk(20, random(360));
    }

#define CoastBoss_alrm1
     // Fire Bubble Bombs:
    repeat(irandom_range(1, 2)){
        if(ammo > 0){
            alarm1 = 2;

             // Blammo:
            sound_play(sndOasisShoot);
            scrEnemyShoot("BubbleBomb", gunangle + (sin(shot_wave / 4) * 16), 8 + random(4));
            shot_wave += alarm1;
            walk++;

             // End:
            if(--ammo <= 0){
                alarm0 = 60;
            }
        }
    }

#define CoastBoss_alrm2
    target = instance_nearest(x, y, Player);
    swim_target = target;

    alarm2 = 8;
    alarm0 = alarm2 + 10;

    if(sprite_index != spr_dive){
         // Dive:
        if(swim <= 0){
            sprite_index = spr_dive;
            image_index = 0;
            spr_shadow = mskNone;
            sound_play(sndOasisBossMelee);
        }

         // Bubble Trail:
        else if(swim > 80){
            scrEnemyShoot("BubbleBomb", direction + orandom(10), 4);
            sound_play_hit(sndBouncerBounce, 0.3);
        }
    }

#define CoastBoss_death
     // Coast Entrance:
    instance_create(x, y, Portal);
    GameCont.area = "coast";
    GameCont.subarea = 0;
    with(enemy) my_health = 0;

     // Boss Win Music:
    with(MusCont) alarm_set(1, 1);


#define CustomChest_step(_inst)
    if(instance_exists(_inst)) with(_inst){
         // Open Chest:
        var c = [Player, PortalShock];
        for(var i = 0; i < array_length(c); i++) if(place_meeting(x, y, c[i])){
            with(instance_nearest(x, y, c[i])) with(other){
                 // Call Chest Open Event:
                var e = on_open;
                if(mod_script_exists(e[0], e[1], e[2])){
                    mod_script_call(e[0], e[1], e[2], (i == 0));
                }

                 // Effects:
                with(instance_create(x, y, ChestOpen)) sprite_index = other.spr_open;
                instance_create(x, y, FXChestOpen);
                sound_play(snd_open);

                instance_destroy();
            }
            break;
        }
    }
    else instance_destroy();


#define Harpoon_end_step
     // Trail:
    var _x1 = x,
        _y1 = y,
        _x2 = xprevious,
        _y2 = yprevious;

    with(instance_create(x, y, BoltTrail)){
        image_yscale = 0.6;
        image_xscale = point_distance(_x1, _y1, _x2, _y2);
        image_angle = point_direction(_x1, _y1, _x2, _y2);
        creator = other.creator;
    }

#define Harpoon_step
     // Stuck in Target:
    var _targ = target;
    if(instance_exists(_targ)){
        if(canmove){
            var _odis = 16,
                _odir = image_angle;

            x = _targ.x - lengthdir_x(_odis, _odir);
            y = _targ.y - lengthdir_y(_odis, _odir);
            xprevious = x;
            yprevious = y;
            visible = _targ.visible;
        }

         // Pickup-able:
        if(alarm0 < 0){
            image_index = 0;

            var _pickup = 1;
            with(rope) if(!broken) _pickup = 0;
            if(_pickup){
                alarm0 = 200 + random(20);
                if(GameCont.crown == crwn_haste) alarm0 /= 3;
            }
        }
        else if(instance_exists(Player)){
             // Shine:
            image_speed = (image_index < 1 ? random(0.04) : 0.4);

             // Attraction:
            var p = instance_nearest(x, y, Player);
            if(point_distance(x, y, p.x, p.y) < (skill_get(mut_plutonium_hunger) ? 100 : 50)){
                canmove = 0;

                var _dis = 10,
                    _dir = point_direction(x, y, p.x, p.y);

                x += lengthdir_x(_dis, _dir);
                y += lengthdir_y(_dis, _dir);
                xprevious = x;
                yprevious = y;

                 // Pick Up Bolt Ammo:
                if(place_meeting(x, y, p) || place_meeting(x, y, Portal)){
                    with(p){
                        ammo[3] = min(ammo[3] + 1, typ_amax[3]);
                        instance_create(x, y, PopupText).text = "+1 BOLTS";
                        sound_play(sndAmmoPickup);
                    }
                    instance_destroy();
                }
            }
        }
    }

    else{
         // Rope Length:
        with(rope) if(!harpoon_stuck){
            if(instance_exists(link1) && instance_exists(link2)){
                length = point_distance(link1.x, link1.y, link2.x, link2.y);
            }
        }

        if(speed > 0){
             // Bolt Marrow:
            if(skill_get(mut_bolt_marrow)){
                var n = instance_nearest(x, y, enemy);
                if(distance_to_object(n) < 16 && !place_meeting(x, y, n)){
                    direction = point_direction(x, y, n.x, n.y);
                    image_angle = direction;
                }
            }

             // Stick in Chests:
            var c = instance_nearest(x, y, chestprop);
            if(place_meeting(x, y, c)) scrHarpoonStick(c);
        }

        else instance_destroy();
    }

    if(instance_exists(self)) enemyAlarms(1);

#define Harpoon_hit
    if(speed > 0){
        if(projectile_canhit(other)){
            projectile_hit_push(other, damage, force);

             // Stick in enemies that don't die:
            if(other.my_health > 0){
                if(
                    (instance_is(other, prop) && other.object_index != RadChest)
                    ||
                    ("name" in other && name == "CoastDecal")
                ){
                    canmove = 0;
                }
                scrHarpoonStick(other);
            }
        }
    }

#define Harpoon_wall
    if(speed > 0){
        move_contact_solid(direction, 16);
        instance_create(x, y, Dust);
        sound_play(sndBoltHitWall);

         // Stick in Wall:
        canmove = 0;
        scrHarpoonStick(other);
    }

#define Harpoon_alrm0
     // Blinking:
    if(blink-- > 0){
        alarm0 = 2;
        visible = !visible;
    }
    else instance_destroy();

#define Harpoon_destroy
    scrHarpoonUnrope(rope);

#define draw_rope(_rope)
    with(_rope) if(instance_exists(link1) && instance_exists(link2)){
        var _x1 = link1.x,
            _y1 = link1.y,
            _x2 = link2.x,
            _y2 = link2.y,
            _wid = clamp(length / point_distance(_x1, _y1, _x2, _y2), 0.1, 2),
            _col = merge_color(c_white, c_red, (0.25 + clamp(0.5 - (break_timer / 45), 0, 0.5)) * clamp(break_force / 100, 0, 1));

        draw_set_color(_col);
        draw_line_width(_x1, _y1, _x2, _y2, _wid);
    }
    instance_destroy();

#define scrHarpoonStick(_instance) /// Called from Harpoon
    speed = 0;
    target = _instance;

     // Set Rope Vars:
    pull_speed = (("size" in target) ? (2 / target.size) : 2);
    with(rope){
        harpoon_stuck = 1;

         // Deteriorate rope if only stuck in unmovable objects:
        var m = 1;
        with([link1, link2]) if("canmove" not in self || canmove) m = 0;
        if(m){
            deteriorate_timer = 60;
            length = point_distance(link1.x, link1.y, link2.x, link2.y);
        }
    }

#define scrHarpoonRope(_link1, _link2)
    var r = {
        link1 : _link1,
        link2 : _link2,
        length : 0,
        harpoon_stuck : 0,
        break_force : 0,
        break_timer : 90,
        creator : noone,
        deteriorate_timer : -1,
        broken : 0
    }
    global.poonRope[array_length(global.poonRope)] = r;
    with([_link1, _link2]) rope[array_length(rope)] = r;

    return r;

#define scrHarpoonUnrope(_rope)
    with(_rope){
        broken = 1;

        var i = 0,
            a = [],
            _ropeIndex = array_find_index(global.poonRope, self);

        for(var j = 0; j < array_length(global.poonRope); j++){
            if(j != _ropeIndex) a[i++] = global.poonRope[j];
        }

        global.poonRope = a;
    }


#define LightningDisc_step
    rotation += rotspeed;

     // Charge Up:
    if(image_xscale < charge){
        image_xscale += (charge / 20) * charge_spd * current_time_scale;
        image_yscale = image_xscale;

        if(creator_follow){
            if(instance_exists(creator)){
                x = creator.x;
                y = creator.y;
            }
    
             // Lightning Disc Weaponry:
            if(instance_is(creator, Player)){
                direction = creator.gunangle;

                var _big = (charge >= 2.5);
                if(_big){
                    x += hspeed;
                    y += vspeed;
                }
    
                 // Attempt to Unstick from Wall:
                if(place_meeting(x, y, Wall)){
                    if(!_big){
                        var w = instance_nearest(x, y, Wall),
                            _dis = 2,
                            _dir = round(point_direction(w.x + 8, w.y + 8, x, y) / 90) * 90;
    
                        while(place_meeting(x, y, w)){
                            x += lengthdir_x(_dis, _dir);
                            y += lengthdir_y(_dis, _dir);
                        }
                    }
    
                     // Big boy:
                    else with(Wall) if(place_meeting(x, y, other)){
                        instance_create(x, y, FloorExplo);
                        instance_destroy();
                    }
                }
    
                if(!_big){
                    move_contact_solid(direction, speed);
                }
    
                 // Sorry roid man:
                with(creator) wkick = 5 * (other.image_xscale / other.charge);
            }
        }

         // Stay Still:
        xprevious = x;
        yprevious = y;
        x -= hspeed * current_time_scale;
        y -= vspeed * current_time_scale;

         // Effects:
        sound_play_pitch(sndLightningHit, (image_xscale / charge));
        if(!is_enemy) sound_play_pitch(sndPlasmaReload, (image_xscale / charge) * 3);
    }
    else{
        if(charge > 0){
             // Just in case:
            if(place_meeting(x, y, Wall)){
                with(Wall) if(place_meeting(x, y, other)){
                    instance_create(x, y, FloorExplo);
                    instance_destroy();
                }
            }

             // Player Shooting:
            if(instance_is(creator, Player)) with(creator){
                weapon_post(-4, 16, 8);
                with(other) direction += orandom(6) * other.accuracy;
            }

             // Effects:
            sound_play_pitch(sndLightningCannonEnd, (3 + random(1)) / charge);
            with(instance_create(x, y, GunWarrantEmpty)) image_angle = other.direction;
            if(!is_enemy && skill_get(mut_laser_brain)){
                sound_play_pitch(sndLightningPistolUpg, 0.8);
            }

            charge = 0;
        }

         // Random Zapp:
        if(!is_enemy){
            if(current_frame_active && random(30) < 1){
                with(nearest_instance(x, y, instances_matching_ne(hitme, "team", team, 0))){
                    if(!place_meeting(x, y, other) && distance_to_object(other) < 32){
                        with(other) LightningDisc_hit();
                    }
                }
            }
        }
    }

     // Slow:
    var _maxSpd = maxspeed;
    if(charge <= 0 && speed > _maxSpd) speed -= current_time_scale;

     // Particles:
    if(current_frame_active){
        if(random(30) < image_xscale || (charge <= 0 && speed > _maxSpd && random(3) < image_xscale)){
            var d = random(360),
                r = random(radius),
                _x = x + lengthdir_x(r * image_xscale, d),
                _y = y + lengthdir_y(r * image_yscale, d);

            with(instance_create(_x, _y, PortalL)){
                motion_add(random(360), 1);
                if(other.charge <= 0){
                    hspeed += other.hspeed;
                    vspeed += other.vspeed;
                }
            }
        }

         // Super Ring Split FX:
        if (super != -1 && charge <= 0 && image_xscale < super + .9){
            if (random((image_xscale - super) * 12) < 1){
                 // Particles:
                var _ang = random(360);
                repeat(irandom(2)){
                    with(instance_create(x + lengthdir_x((image_xscale * 17) + hspeed, _ang), y + lengthdir_y((image_yscale * 17) + vspeed, _ang), LightningSpawn)){
                        image_angle = _ang;
                        image_index = 1;
                        with(instance_create(x, y, PortalL)) image_angle  = _ang;
                    }
                }
                view_shake_at(x, y, 3);
    
                 // Sound:
                var _pitchMod = 1 / (4 * ((image_xscale - super) + .12));
                    _vol = 0.1 / ((image_xscale - super) + 0.2);
    
                if(random(2) < 1){
                    sound_play_pitchvol(sndGammaGutsKill, random_range(1.8, 2.5) * _pitchMod, max(_vol, 0.2));
                }
                else sound_play_pitchvol(sndLightningHit, random_range(0.8, 1.2) * _pitchMod, _vol * 2);
            }
        }
    }

     // Shrink:
    if(charge <= 0){
        var s = shrink * current_time_scale;
        image_xscale -= s;
        image_yscale -= s;

         // Super lightring split:
        if(super != -1 && image_xscale <= super){
            instance_destroy();
            exit;
        }

         // Normal poof:
        if(image_xscale <= 0 || image_yscale <= 0){
            sound_play_hit(sndLightningHit, 0.5);
            instance_create(x, y, LightningHit);
            instance_destroy();
        }
    }

#define LightningDisc_hit
    if(projectile_canhit_melee(other)){
         // Slow:
        x -= hspeed;
        y -= vspeed;
        direction = point_direction(x, y, other.x, other.y) + orandom(10);

         // Electricity Field:
        var _tx = other.x,
            _ty = other.y,
            d = random(360),
            r = radius,
            _x = x + lengthdir_x(r * image_xscale, d),
            _y = y + lengthdir_y(r * image_yscale, d);

        with(instance_create(_x, _y, (is_enemy ? EnemyLightning : Lightning))){
            ammo = other.image_xscale + random(other.image_xscale * 2);
            direction = point_direction(x, y, _tx, _ty) + orandom(12);
            image_angle = direction;
            team = other.team;
            hitid = other.hitid;
            creator = other.creator;
            event_perform(ev_alarm, 0);
        }

         // Effects:
        with(other) instance_create(x, y, Smoke);
        sound_play(sndLightningHit);
    }

#define LightningDisc_wall
    var _hprev = hspeed,
        _vprev = vspeed;

    if(image_xscale >= charge && (image_xscale < 2.5 || image_yscale < 2.5)){
         // Bounce:
        if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
        if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;

        with(other){
             // Bounce Effect:
            var _x = x + 8,
                _y = y + 8,
                _dis = 8,
                _dir = point_direction(_x, _y, other.x, other.y);

            instance_create(_x + lengthdir_x(_dis, _dir), _y + lengthdir_y(_dis, _dir), PortalL);
            sound_play_hit(sndLightningHit, 0.2);
        }
    }

     // Too powerful to b contained:
    if(image_xscale > 1.2 || image_yscale > 1.2){
        with(other){
            instance_create(x, y, FloorExplo);
            instance_destroy();
        }
        with(Wall) if(place_meeting(x - _hprev, y - _vprev, other)){
            instance_create(x, y, FloorExplo);
            instance_destroy();
        }
    }

#define LightningDisc_destroy
    if(super != -1)
    {
         // Effects:
        sleep(80);
        sound_play_pitchvol(sndLightningPistolUpg, 0.7,               0.4);
        sound_play_pitchvol(sndLightningPistol,    0.7,               0.6);
        sound_play_pitchvol(sndGammaGutsKill,      0.5 + random(0.2), 0.7);

         // Disc Split:
        var _ang = random(360);
        for(var a = _ang; a < _ang + 360; a += (360 / 5))
        {
            with(obj_create(x, y, "LightningDisc"))
            {
                motion_add(a, 10);
                charge = other.image_xscale;
                if(skill_get(mut_laser_brain)){
                    charge *= 1.2;
                    stretch *= 1.2;
                    image_speed *= 0.75;
                }

                 // Insta-Charge:
                image_xscale = charge * 0.9;
                image_yscale = charge * 0.9;

                team = other.team;
                creator = other.creator;
                creator_follow = false;
            }
            
             // Clear Walls:
            var o = 24;
            instance_create(x + lengthdir_x(o, a), y + lengthdir_y(o, a), PortalClear);
        }
    }

#define LightningDisc_draw
    scrDrawLightningDisc(sprite_index, image_index, x, y, ammo, radius, stretch, image_xscale, image_yscale, image_angle + rotation, image_blend, image_alpha);

#define scrDrawLightningDisc(_spr, _img, _x, _y, _num, _radius, _stretch, _xscale, _yscale, _angle, _blend, _alpha)
    var _off = (360 / _num),
        _ysc = _stretch * (0.5 + random(1));

    for(var d = _angle; d < _angle + 360; d += _off){
        var _ro = random(2),
            _rx = (_radius * _xscale) + _ro,
            _ry = (_radius * _yscale) + _ro,
            _x1 = _x + lengthdir_x(_rx, d),
            _y1 = _y + lengthdir_y(_ry, d),
            _x2 = _x + lengthdir_x(_rx, d + _off),
            _y2 = _y + lengthdir_y(_ry, d + _off),
            _xsc = point_distance(_x1, _y1, _x2, _y2) / 2,
            _ang = point_direction(_x1, _y1, _x2, _y2);

        draw_sprite_ext(_spr, _img, _x1, _y1, _xsc, _ysc, _ang, _blend, _alpha);
    }


#define Manhole_step
    var _canhole = (!instance_exists(FrogQueen) && !array_length_1d(instances_matching(CustomEnemy,"name","CatBoss")));
    if place_meeting(x,y,Explosion) && !image_index && _canhole{
        image_index = 1;
        with(GameCont) area = other.toarea;
        with(enemy) my_health = 0;
         // portal
        with instance_create(x+16,y+16,Portal) image_alpha = 0;
        sound_stop(sndPortalOpen);
    }


#define NetNade_step
    if(alarm0 > 0 && alarm0 < 15) sprite_index = spr.NetNadeBlink;
    enemyAlarms(1);

#define NetNade_hit
    if(speed > 0 && projectile_canhit(other)){
        lasthit = other;
        projectile_hit_push(other, damage, force);
        if(alarm0 > 1) alarm0 = 1;
    }

#define NetNade_wall
    if(alarm0 > 1) alarm0 = 1;

#define NetNade_alrm0
    instance_destroy();

#define NetNade_destroy
     // Effects:
    repeat(8) instance_create(x, y, Dust);
    sound_play(sndUltraCrossbow);
    sound_play(sndFlakExplode);
    view_shake_at(x, y, 20);

     // Break Walls:
    while(distance_to_object(Wall) < 32){
        with(instance_nearest(x, y, Wall)){
            instance_create(x, y, FloorExplo);
            instance_destroy();
        }
    }

     // Harpoon-Splosion:
    var _num = 10,
        _ang = random(360),
        o = 8, // Spawn Offset
        f = noone, // First Harpoon Created
        h = noone; // Latest Harpoon Created

    for(var a = _ang; a < _ang + 360; a += (360 / _num)){
        with(obj_create(x + lengthdir_x(o, a), y + lengthdir_y(o, a), "Harpoon")){
            motion_add(a + orandom(5), 22);
            image_angle = direction;
            team = other.team;
            creator = other.creator;
            if(direction > 90 && direction < 270) image_yscale = -1;

             // Explosion Effect:
            with(instance_create(x, y, MeleeHitWall)){
                motion_add(other.direction, 1 + random(2));
                image_angle = direction + 180;
                image_speed = 0.6;
            }

             // Link harpoons to each other:
            if(!instance_exists(f)) f = id;
            if(instance_exists(h)) scrHarpoonRope(id, h);
            h = id;
        }
    }
    scrHarpoonRope(f, h);


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

#define Pet_step
    if(instance_exists(Menu)){ instance_destroy(); exit; }

    var _pickup = pickup_indicator;

    enemyAlarms(1);
    enemyWalk(walkspd, maxspd);

     // Animate:
    var _scrt = pet + "_anim";
    if(mod_script_exists("mod", "petlib", _scrt)){
         // Custom Animation Event:
        mod_script_call("mod", "petlib", _scrt);
    }
    else enemySprites();

     // Custom Step Event:
    if(visible){
        var _scrt = pet + "_step";
        if(mod_script_exists("mod", "petlib", _scrt)){
            mod_script_call("mod", "petlib", _scrt);
        }
    }

     // Player Owns Pet:
    if(instance_exists(leader)){
        can_take = false;
        persistent = true;

         // Teleport To Leader:
        /*if(can_tp && point_distance(x, y, leader.x, leader.y) > tp_distance) {
             // Decide Which Floor:
            var f = instance_nearest(leader.x + orandom(16), leader.y + orandom(16), Floor);
            var fx = f.x + (f.sprite_width/2);
            var fy = f.y + (f.sprite_height/2);

             // Teleport:
            x = fx;
            y = fy;

             // Effects:
            sound_play_pitch(sndCrystalTB, 1.40 + orandom(0.10));
            repeat(2) instance_create(x + orandom(8), y + orandom(8), CaveSparkle);
        }*/

         // Pathfind to Leader:
        var _xtarget = leader.x,
            _ytarget = leader.y;

        if(can_path && collision_line(x, y, _xtarget, _ytarget, Wall, false, false)){
            var _pathEndX = x,
                _pathEndY = y;

             // Find Path's Endpoint:
            if(array_length(path) > 0){
                var p = path[array_length(path) - 1];
                _pathEndX = p[0];
                _pathEndY = p[1];
            }

             // Create path if current one doesn't reach leader:
            if(collision_line(_pathEndX, _pathEndY, _xtarget, _ytarget, Wall, false, false)){
                path = path_create(x, y, _xtarget, _ytarget);
            }
        }
        else path = [];

         // Enter Portal:
        if(visible){
            if(place_meeting(x, y, Portal) || instance_exists(GenCont)){
                visible = false;
                repeat(3) instance_create(x, y, Dust);
            }
        }
        else{
            x = leader.x + orandom(16);
            y = leader.y + orandom(16);
        }
    }

     // No Owner:
    else{
        persistent = false;

         // Looking for a home:
        if(instance_exists(Player) && can_take && instance_exists(_pickup)){
            with(player_find(_pickup.pick)){
                var _max = array_length(pet);
                if(_max > 0){
                     // Remove Oldest Pet:
                    with(pet[_max - 1]){
                        leader = noone;
                        can_take = true;
                    }
                    pet = array_slice(pet, 0, _max - 1);

                     // Add New Pet:
                    other.leader = self;
                    array_insert(pet, 0, other);
                    with(other) direction = point_direction(x, y, other.x, other.y);

                     // Effects:
                    with(instance_create(x, y, WepSwap)){
                        sprite_index = sprHealFX;
                        creator = other;
                    }
                    sound_play(sndHealthChestBig);
                    sound_play(sndHitFlesh);
                }
            }
        }
    }
    with(_pickup) visible = other.can_take;

     // Dodge:
    if(instance_exists(leader)) team = leader.team;
    else team = 1;

    if(place_meeting(x, y, projectile) && sprite_index != spr_hurt){
        with(instances_matching_ne(projectile, "team", team)){
            if(place_meeting(x, y, other)) with(other){
                 // Custom Dodge Event:
                var _scrt = pet + "_hurt";
                if(mod_script_exists("mod", "petlib", _scrt)){
                    mod_script_call("mod", "petlib", _scrt);
                }

                 // Default:
                else{
                    sprite_index = spr_hurt;
                    image_index = 0;
                }
            }
        }
    }

     // Pet Collision:
    if(place_meeting(x, y, object_index)){
        with(instances_named(object_index, name)){
            if(place_meeting(x, y, other)){
                var _dir = point_direction(other.x, other.y, x, y);
                motion_add(_dir, 1);
                with(other) motion_add(_dir + 180, 1);
            }
        }
    }

#define Pet_end_step
     // Wall Collision:
    if(place_meeting(x, y, Wall)){
        x = xprevious;
        y = yprevious;
        if(place_meeting(x + hspeed, y, Wall)) hspeed = 0;
        if(place_meeting(x, y + vspeed, Wall)) vspeed = 0;
        x += hspeed;
        y += vspeed;
    }

#define Pet_draw
    image_alpha = abs(image_alpha);

     // Outline Setup:
    var _outline = (instance_exists(leader) && player_get_outlines(leader.index) && player_is_local_nonsync(leader.index));
    if(_outline){
        var _surf = surf_draw,
            _surfw = surf_draw_w,
            _surfh = surf_draw_h,
            _surfx = x - (_surfw / 2),
            _surfy = y - (_surfh / 2);

        if(!surface_exists(_surf)){
            _surf = surface_create(_surfw, _surfh)
            surf_draw = _surf;
        }

        surface_set_target(_surf);
        draw_clear_alpha(0, 0);

        x -= _surfx;
        y -= _surfy;
    }

     // Custom Draw Event:
    var _scrt = pet + "_draw";
    if(mod_script_exists("mod", "petlib", _scrt)){
        mod_script_call("mod", "petlib", _scrt);
    }

     // Default:
    else draw_self_enemy();

     // Draw Outline:
    if(_outline){
        x += _surfx;
        y += _surfy;

        surface_reset_target();

         // Fix coast stuff:
        if("wading" in self && wading != 0 && GameCont.area == "coast"){
            surface_set_target(mod_variable_get("area", "coast", "surfSwim"));
        }

        d3d_set_fog(1, player_get_color(leader.index), 0, 0);
        for(var a = 0; a <= 360; a += 90){
            var _x = _surfx,
                _y = _surfy;

            if(a >= 360) d3d_set_fog(0, 0, 0, 0);
            else{
                _x += dcos(a);
                _y -= dsin(a);
            }

            draw_surface(_surf, _x, _y);
        }
    }

     // CustomObject draw events are annoying:
    image_alpha = -abs(image_alpha);

#define Pet_alrm0
    alarm0 = 30;
    if(visible){
         // Where leader be:
        var _leaderDir = 0,
            _leaderDis = 0;

        if(instance_exists(leader)){
            _leaderDir = point_direction(x, y, leader.x, leader.y);
            _leaderDis = point_distance(x, y, leader.x, leader.y);
        }

         // Find Current Path Direction:
        if(array_length(path) > 0){
             // Find Nearest Point on Path:
            var	_nearest = 0,
        		d = 1000000;

            for(var i = 0; i < array_length(path); i++){
                var _x = path[i, 0],
                    _y = path[i, 1],
        		    _dis = point_distance(_x, _y, x, y);

        		if(_dis < d){
        			_nearest = i;
        			d = _dis;
        		}
        	}

             // Find Direction to Next Point on Path:
            var _follow = _nearest + 1;
            if(_follow < array_length(path)){
                var _x = path[_follow, 0],
                    _y = path[_follow, 1];

                path_dir = point_direction(x, y, _x, _y);
            }
        }

         // Custom Alarm Event:
        var _scrt = pet + "_alrm0";
        if(mod_script_exists("mod", "petlib", _scrt)){
            var a = mod_script_call("mod", "petlib", _scrt, _leaderDir, _leaderDis);
            if(is_real(a) && a > 0) alarm0 = a;
        }

         // Default:
        else{
             // Follow Leader Around:
            if(instance_exists(leader)){
                if(_leaderDis > 24){
                     // Pathfinding:
                    if(array_length(path) > 0){
                        scrWalk(8, path_dir + orandom(20));
                        alarm0 = walk;
                    }

                     // Move Toward Leader:
                    else{
                        scrWalk(10, _leaderDir + orandom(10));
                        alarm0 = 10 + random(5);
                    }
                }
            }

             // Idle Movement:
            else scrWalk(15, random(360));
        }
    }


#define PizzaBoxCool_death
    var _num = choose(1, 2);

     // Big luck:
    if(random(10) < 1){
        _num = 4;
        repeat(5) instance_create(x + orandom(4), y + orandom(4), Dust);
        sound_play_pitch(snd_dead, 0.6);
        snd_dead = -1;
    }

     // +Yum
    repeat(_num){
        with(instance_create(x + orandom(2 * _num), y + orandom(2 * _num), HPPickup)){
            sprite_index = sprSlice;
            num++;
        }
    }


#define BabyScorpion_step
    enemyAlarms(2);
    enemySprites();
    enemyWalk(walkspd, maxspd);

#define BabyScorpion_alrm0
    alarm0 = 50 + irandom(30);
    target = instance_nearest(x, y, Player);

    if(target_is_visible()) {
        var _targetDir = point_direction(x, y, target.x + target.hspeed, target.y + target.vspeed);

    	if(target_in_distance(32, 96) > 0 and random(3) < 2){
		    gunangle = _targetDir;

		     // Golden poison shot:
		    if(gold) {
		        repeat(6) scrEnemyShoot("TrafficCrabVenom", gunangle + orandom(30), 5 + random(2));
		        repeat(4) scrEnemyShoot("TrafficCrabVenom", gunangle + orandom(10), 10 + random(4));
		    }

		     // Normal poison shot:
		    else {
		        repeat(2) scrEnemyShoot("TrafficCrabVenom", gunangle + orandom(10), 6 + random(4));
		    }
		    motion_add(_targetDir + 180, 3);
            sound_play_pitch(snd_fire, 1.6);

    		alarm0 = 20 + random(30);
    	}

         // Move Away From Target:
        else if(target_in_distance(0, 32) > 0) {
            alarm0 = 20 + irandom(30);
            scrWalk(10 + random(10), _targetDir + 180 + orandom(40));
        }

         // Move Towards Target:
    	else{
    		alarm0 = 30 + irandom(20);
    		scrWalk(20 + random(15), _targetDir + orandom(40));
    		gunangle = _targetDir + orandom(15);
    	}

    	 // Facing:
    	scrRight(gunangle);
    }

     // Wander:
    else scrWalk(30, random(360));

#define BabyScorpion_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    motion_add(_hitdir, _hitvel);	// Knockback
    nexthurt = current_frame + 6;	// I-Frames

     // Pitched Sound:
    var v = clamp(50 / (distance_to_object(Player) + 1), 0, 2);
    sound_play_pitchvol(snd_hurt, 1.2 + random(0.3), v);

     // Hurt Sprite:
    sprite_index = spr_hurt;
    image_index = 0;

#define BabyScorpion_death
    scrDefaultDrop();

     // Effects:
    var l = 6,
        d = irandom(359);

    for(var i = 0; i < 360; i += 360 / 3){
        with instance_create(x + lengthdir_x(l, d + i), y + lengthdir_y(l, d + i), AcidStreak){
            motion_set(d + i, 4);
            image_angle = direction;
        }
    }
    sound_play_pitchvol(snd_dead, 1.5 + random(0.3), 1.3);
    snd_dead = -1;

#define Bat_step
    enemyAlarms(1);
    enemyWalk(walkspd, maxspd);

     // Walk:
    if((sprite_index != spr_fire && sprite_index != spr_hurt) || anim_end){
        if(speed <= 0) sprite_index = spr_idle;
        else sprite_index = spr_walk;
    }

     // Bounce:
    if(place_meeting(x + hspeed, y + vspeed, Wall)){
        if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
        if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;
    }

#define Bat_alrm0
    alarm0 = 15 + irandom(20);
    target = instance_nearest(x, y, Player);

    if target_is_visible(){
        gunangle = point_direction(x, y, target.x, target.y);
        scrRight(gunangle);

        if !target_in_distance(0, 75){
             // Walk to target:
            if random(5) < 4
                scrWalk(15 + irandom(20), gunangle + orandom(8));
        }
        else if target_in_distance(0, 50){
             // Walk away from target:
            scrWalk(10+irandom(5), gunangle + 180 + orandom(12));
            alarm0 = walk;
        }

         // Attack target:
        if random(5) < 2 && target_in_distance(50, 200){
             // Sounds:
            sound_play_pitchvol(sndRustyRevolver, 0.8, 0.7);
            sound_play_pitchvol(sndSnowTankShoot, 1.2, 0.6);
            sound_play_pitchvol(sndFrogEggHurt, 1 + random(0.4), 3.5);

             // Bullets:
            var d = 4,
                s = 2;
            for (var i = 0; i <= 5; i++){
                with scrEnemyShoot("TrafficCrabVenom", gunangle + orandom(2 + i), s * i){
                    move_contact_solid(direction, d + d * i);

                     // Effects:
                    with instance_create(x, y, AcidStreak){
                        motion_set(other.direction + orandom(4), other.speed * 0.8);
                        image_angle = direction;
                    }

                    if i <= 2
                        with instance_create(x, y, Smoke){
                            motion_set(other.direction + orandom(8 * i), 4 - i);
                        }
                }
            }

             // Effects:
            wkick += 7;
            with instance_create(x, y, Shell){
                sprite_index = sprShotShell;
                motion_set(other.gunangle + 130 * choose(-1, 1) + orandom(20), 5);
            }
        }

         // Screech:
        else{
            if irandom(stress) >= 15{
                stress -= 8;
                scrBatScreech();

                 // Fewer mass screeches:
                with instances_matching(CustomEnemy, "name", "Bat"){
                    stress = max(stress - 4, 10);
                }
            }

             // Build up stress:
            else stress += 4;
        }
    }
    else{
        var c = nearest_instance(x, y, instances_matching(CustomEnemy, "name", "Cat", "CatBoss", "BatBoss"));

         // Follow nearest ally:
        if instance_exists(c) && !collision_line(x, y, c.x, c.y, Wall, 0, 0) && point_distance(x, y, c.x, c.y) > 64
            scrWalk(15 + irandom(20), point_direction(x, y, c.x, c.y) + orandom(8));

         // Wander:
        else if random(3) < 1
            scrWalk(10 + irandom(20), direction + orandom(24));

        gunangle = direction;
        scrRight(gunangle);
    }

#define Bat_alrm1
    alarm1 = 20 + irandom(20);

    if random(5) < 1 && target_is_visible() && target_in_distance(0, 240){
        alarm1 = 40 + irandom(20);

        //sound_play_gun(sndMolesargeHurt, 0, -1);
        scrBatScreech();
    }

#define scrBatScreech
     // Effects:
    sound_play_pitchvol(sndNothing2Hurt, 1.4 + random(0.2), 0.7);
    sound_play_pitchvol(sndSnowTankShoot, 0.8 + random(0.4), 0.5);

    view_shake_at(x, y, 16);
    sleep(40);

     // Alert nearest cat:
    with nearest_instance(x, y, instances_matching(CustomEnemy, "name", "Cat"))
        cantravel = true;

     // Screech:
    scrEnemyShoot("BatScreech", 0, 0);
    sprite_index = spr_fire;
    image_index = 0;

#define OLDBat_alrm0
    alarm0 = 30 + random(30);

    target = instance_nearest(x, y, Player);
    if(instance_exists(target)){
        alarm0 = 90;

        var _targetDir = point_direction(x, y, target.x, target.y),
            _targetDis = point_distance(x, y, target.x, target.y);

        if(target_is_visible() && random(2) < 1){
            alarm0 = 8;

            scrWalk(8, _targetDir + choose(-90, 90));

             // Venom Shooter:
            gunangle = _targetDir;
            scrRight(gunangle);
            for(var i = -1; i <= 1; i += 0.4){
                var _dir = gunangle + (i * 10),
                    _spd = 12 - (4 * abs(i));

                scrEnemyShoot("TrafficCrabVenom", _dir, _spd);
                scrEnemyShoot(EnemyBullet2, _dir, _spd / 2);
            }

             // Effects:
            repeat(3) with(instance_create(x, y, AcidStreak)) {
                motion_add(other.gunangle + orandom(20), 4 + random(4));
                image_angle = direction;
                depth = other.depth - 1;
            }
            sound_play_pitch(sndToxicBoltGas, 3);
            sound_play_pitch(sndLilHunterSniper, 2);
            wkick = 8;
        }
        else{
            alarm0 = 30;

            scrWalk(20, gunangle + orandom(20));
            gunangle = _targetDir + orandom(10);
            scrRight(gunangle);
        }
    }
    else scrWalk(10, random(360));

#define Bat_draw
    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();

#define Bat_hurt(_hitdmg, _hitvel, _hitdir)
     // Get hurt:
    if !instance_is(other, ToxicGas){
        stress += _hitdmg;
        enemyHurt(_hitdmg, _hitvel, _hitdir);
    }

     // Screech:
    else{
        stress -= 4;
        nexthurt = current_frame + 5;

        scrBatScreech();
    }

#define Bat_death
    sound_play_pitch(sndScorpionFireStart, 1.2);
    //pickup_drop(0, 100);
    pickup_drop(60, 5);

#define BatBoss_step
    enemyAlarms(3);
    enemySprites();
    enemyWalk(walkspd, maxspd);

#define BatBoss_alrm0
    alarm0 = 20 + irandom(20);
    target = instance_nearest(x, y, Player);

    if target_is_visible(){
        gunangle = point_direction(x, y, target.x, target.y);
        scrRight(gunangle);

         // Walk towards target:
        if random(5) < 3{
            scrWalk(20 + irandom(15), gunangle + irandom_range(25, 45) * right);
        }

         // Fire at player:
        else if random(5) < 3{
             // Tell:
            with instance_create(x + right * 18, y + 16, AssassinNotice)
                depth = other.depth - 1;

            if fork(){
                wait(10);
                if !instance_exists(self) exit;

                 // Fire:
                motion_add(gunangle + 180, maxspd);
                scrEnemyShoot("VenomFlak", gunangle + orandom(10), 12);

                 // Effects:
                wkick += 9;
                sound_play_pitchvol(sndCrystalRicochet, 1.4 + random(0.4), 0.8);
                sound_play_pitchvol(sndLightningRifleUpg, 0.8, 0.4);

                repeat(3 + irandom(2)) instance_create(x + orandom(6), y + orandom(6), Smoke){
                    motion_set(other.gunangle + orandom(2), 4 + random(4));
                }

                exit;
            }
        }

         // Screech:
        else{
            if irandom(stress) >= 15{
                stress -= 8;
                scrBatBossScreech();
            }

             // Build up stress:
            else stress += 4;
        }
    }
    else{
        var c = nearest_instance(x, y, instances_matching(CustomEnemy, "name", "CatBoss"));

         // Follow cat boss:
        if instance_exists(c) && !collision_line(x, y, c.x, c.y, Wall, 0, 0) && point_distance(x, y, c.x, c.y) > 64
            scrWalk(15 + irandom(20), point_direction(x, y, c.x, c.y) + orandom(8));

         // Wander:
        else if random(3) < 1
            scrWalk(10 + irandom(20), direction + orandom(24));

        gunangle = direction;
        scrRight(gunangle);
    }

#define BatBoss_alrm1
    // alarm1 = 50 + irandom(50);

    //  // charge up attack
    // if target_is_visible() || charge > 0{
    //     if charge < max_charge{
    //         alarm1 = 1;

    //         charge += current_time_scale;

    //          // effects:
    //         if charge mod 2 == 0{
    //             sound_play_pitchvol(sndLuckyShotProc, (charge / max_charge) + 1.3, 0.2);
    //             sound_play_pitchvol(sndPickupDisappear, 0.4, 0.6);

    //             if target_is_visible(){
    //                 gunangle = point_direction(x, y, target.x, target.y);
    //             }
    //         }
    //     }
    //     else{
    //          // fire if charged
    //         if charged{
    //             alarm0 = 30 + irandom(20);
    //             alarm1 = 90 + irandom(60);

    //             charged = false;
    //             charge = 0;

    //              // fire:
    //             for (var i = -1; i <= 1; i++){
    //                 var d = 4,
    //                     s = 3;
    //                 for (var ii = 0; ii <= 16; ii++){
    //                     with scrEnemyShoot("TrafficCrabVenom", gunangle + i * 16 + orandom(2 + ii), s + ii){
    //                         move_contact_solid(direction, d + d * ii);

    //                          // Effects:
    //                         with instance_create(x, y, AcidStreak){
    //                             motion_set(other.direction + orandom(4), other.speed * 0.8);
    //                             image_angle = direction;
    //                         }

    //                         if i <= 2
    //                             with instance_create(x, y, Smoke){
    //                                 motion_set(other.direction + orandom(8 * ii), 4 - ii);
    //                             }
    //                     }
    //                 }
    //             }

    //              // effects:
    //             sound_play_pitchvol(sndHeavyMachinegun, 1, 0.8);
    //             sound_play_pitchvol(sndSnowTankShoot, 1.4, 0.7);
    //             sound_play_pitchvol(sndFrogEggHurt, 0.4 + random(0.2), 3.5);

    //             motion_add(gunangle + 180, maxspd);
    //             view_shake_at(x, y, 20);
    //             sleep(50);
    //         }
    //          // finish charging
    //         else{
    //             alarm0 = 0;
    //             alarm1 = 35;

    //             charged = true;

    //             if target_is_visible(){
    //                 gunangle = point_direction(x, y, target.x, target.y);
    //                 scrRight(gunangle);
    //             }

    //              // effects:
    //             sound_play_pitchvol(sndCrystalRicochet, 1.4 + random(0.4), 0.8);
    //             sound_play_pitchvol(sndLightningRifleUpg, 0.8, 0.4);

    //             with instance_create(x, y, ImpactWrists){
    //                 move_contact_solid(other.gunangle, 8);
    //                 depth = other.depth - 1;
    //             }
    //         }
    //     }
    // }

#define BatBoss_alrm2

#define BatBoss_draw
    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();

     // draw_text_nt(x, y - 30, string(charge) + "/" + string(max_charge) + "(" + string(charged) + ")");

#define BatBoss_hurt(_hitdmg, _hitvel, _hitdir)
     // Get hurt:
    if !instance_is(other, ToxicGas){
        stress += _hitdmg;
        enemyHurt(_hitdmg, _hitvel, _hitdir);
    }

     // Screech:
    else{
        stress -= 4;
        nexthurt = current_frame + 5;

        scrBatBossScreech();
    }

#define scrBatBossScreech
     // Effects:
    sound_play_pitchvol(sndNothing2Hurt, 1.4 + random(0.2), 0.7);
    sound_play_pitchvol(sndSnowTankShoot, 0.8 + random(0.4), 0.5);

    view_shake_at(x, y, 16);
    sleep(40);

     // Alert nearest cat:
    with nearest_instance(x, y, instances_matching(CustomEnemy, "name", "Cat"))
        cantravel = true;

     // Screech:
    scrEnemyShoot("BatScreech", 0, 0);
    var l = 64;
    for (var d = 0; d <= 360; d += 360 / 6)
        scrEnemyShootExt(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "BatScreech", 0, 0);

    sprite_index = spr_fire;
    image_index = 0;

#define BatScreech_step
    while place_meeting(x, y, ToxicGas)
        with instance_nearest(x, y, ToxicGas)
            instance_delete(id);

#define BatScreech_hit
    with instances_matching_ne(hitme, "team", team)
        if place_meeting(x, y, other)
            motion_add(point_direction(other.x, other.y, x, y), 1);

#define BatScreech_draw
    draw_set_blend_mode(bm_add);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha * 0.4);
    draw_set_blend_mode(bm_normal);

#define Cabinet_death
    repeat(irandom_range(8,16))
        with obj_create(x,y,"Paper")
            motion_set(irandom(359),random_range(2,8));

#define Cat_step
    enemyAlarms(2);
    enemySprites();
    enemyWalk(walkspd, maxspd);

    if instance_exists(hole) && place_meeting(x,y,hole) || (!array_length_1d(instances_matching(instances_matching(CustomObject,"name","CatHole"),"cat",self)) && !place_meeting(x,y,Floor)){
        canfly = true;
        alarm0 = -1;
        alarm1 = -1;
        x = 0;
        y = 0;
        var _a = instances_matching(CustomObject,"name","CatHole"),
            _t = target,
            _dest = nearest_instance(_t.x,_t.y,_a),
            _dist = 10000;

         // Find nearest canhole to player:
        with(_a){
            var _mydist = point_distance(x,y,_t.x,_t.y);
            if _mydist < _dist && !collision_line(x,y,_t.x,_t.y,Wall,0,0){
                _dist = _mydist;
                _dest = self;
            }
        }
        with(hole){
            image_index = 1;
            image_speed = 0.4;
        }
        hole = noone;
        with(_dest){
            alarm0 = 30;
            cat = other;
        }
    }

     // Sound fix
    if fork(){
        wait(0) if !instance_exists(self) sound_stop(sndFlamerLoop);
        exit;
    }

#define Cat_alrm0
    alarm0 = 20 + irandom(20);

    if (my_health < maxhealth || target_is_visible()) && !cantravel{
        cantravel = true;
        instance_create(x + 10 * right, y - 5, AssassinNotice);
    }

    if(ammo > 0) {
        repeat(2) with(scrEnemyShoot(ToxicGas, gunangle + orandom(6), 4)){
            friction = 0.12;
            team = 0;
        }
        gunangle += 12;
        ammo--;
        if(ammo = 0) {
            alarm0 = 40;
            repeat(3) {
                var _dir = orandom(16);
                with(instance_create(x, y, AcidStreak)) {
                    motion_add(other.gunangle + _dir, 3);
                    image_angle = direction;
                }
            }
            wkick += 6;
            sound_play_pitch(sndEmpty, random_range(0.75, 0.9));
            sound_stop(sndFlamerLoop);
        } else {
            alarm0 = 2;
            wkick += 1;
        }
    } else {
        target = instance_nearest(x, y, Player);
        if(target_is_visible()) {
            var _targetDir = point_direction(x, y, target.x, target.y);

            if(target_in_distance(0, 140) and random(3) < 1) {
                scrRight(_targetDir);
                gunangle = _targetDir - 45;
                ammo = 10;
                with(instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), BloodGamble)) {
                    sprite_index = spr.AcidPuff;
                    image_angle = other.gunangle;
                }
                sound_play(sndToxicBoltGas);
                sound_play(sndEmpty);
                sound_loop(sndFlamerLoop);
                wkick += 4;
                alarm0 = 4;
            } else {
                alarm0 = 20 + irandom(20);
                scrWalk(20 + irandom(5), _targetDir + orandom(20));
                scrRight(gunangle);
            }
        } else {
            if instance_exists(hole){
                 // Move towards nearest cathole
                alarm0 = 60 + irandom(30);
                scrWalk(alarm0,point_direction(x,y,hole.x+16,hole.y+16));
            } else {
                 // Wander
                alarm0 = 30 + irandom(20); // 3-4 Seconds
                scrWalk(20 + irandom(10), irandom(360));
                scrRight(gunangle);
            }
        }
    }

#define Cat_alrm1
    if GameCont.area != sewers{
        alarm1 = -1;
        exit;
    }
    alarm1 = 90 + irandom(60); // 3-5 seconds
    if cantravel{
         // Locate nearest cathole:
        if (!target_is_visible() || !target_in_distance(0,128)) {
            hole = noone;
            var _array = instances_matching(CustomObject,"name","CatHole"),
                _dist = 10000;

             // Bootleg nearest_instance() to find the nearest visible cathole
            with(_array) if !collision_line(other.x,other.y,x,y,Wall,0,0) && !instance_exists(cat){
                var _mydist = point_distance(x,y,other.x,other.y);
                if _mydist < _dist{
                    _dist = _mydist;
                    other.hole = self;
                }
            }
        }
    }

#define Cat_hurt(_hitdmg, _hitvel, _hitdir)
    if(!instance_is(other, ToxicGas)){
        my_health -= _hitdmg;           // Damage
        nexthurt = current_frame + 6;   // I-Frames
        sound_play_hit(snd_hurt, 0.3);  // Hurt Sound
        motion_add(_hitdir, _hitvel);   // Knockback

         // Hurt Sprite:
        sprite_index = spr_hurt;
        image_index = 0;
    }

     // Toxic immune
    else with(other){
		instance_copy(false);
		instance_delete(id);
		for(var i = 0; i < maxp; i++) view_shake[i] -= 1;
	}

#define Cat_draw
    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();


#define CatBoss_step
    enemyAlarms(3);
    enemySprites();

    if dash enemyWalk(0.0,  6.5);
    else    enemyWalk(0.8,  3.0);

#define CatBoss_alrm0
    alarm0 = 20 + irandom(20);
    target = instance_nearest(x, y, Player);

    if target_is_visible(){
        gunangle = point_direction(x, y, target.x, target.y);
        scrRight(gunangle);

         // Attack:
        if random(5) < 3{
             // Gas dash:
            if random(4) < 3 && target_in_distance(85, 240){
                dash = 18;
                alarm1 = 1;

                sound_play(sndToxicBoltGas);

                sound_play(sndFlamerStart);
                sound_loop(sndFlamerLoop);

                sleep(26);
                view_shake_at(x, y, 18);

                direction = gunangle + irandom_range(30, 60) * right;
            }

             // Attack:
            else if target_in_distance(0, 240){
                alarm0 = 40;
                scrEnemyShoot("CatBossAttack", gunangle, 0);
                sound_play(sndShotReload);
                sound_play_pitchvol(sndLilHunterSniper, 2 + random(0.5), 0.5);
                sound_play_pitch(sndSnowTankAim, 2.5 + random(0.5));
            }
        }

         // Circle target:
        else{
            scrWalk(15 + irandom(25), gunangle + irandom_range(30, 60) * right);
        }
    }

     // Wander:
    else{
        gunangle = direction;
        scrWalk(15 + irandom(25), direction + orandom(30));
        scrRight(direction);
    }

#define CatBoss_alrm1
    if dash > 0{
        dash--;
        alarm1 = 1;

        meleedamage = 3;

         // Forward motion:
        motion_add(direction, 1.4);
         // Steer towards target:
        if instance_exists(target)
            motion_add(point_direction(x, y, target.x, target.y), 0.7);

         // Wall break:
        if place_meeting(x + hspeed, y + vspeed, Wall)
            with instance_create(x + hspeed, y + vspeed, PortalClear){
                team = other.team;
                image_xscale = 0.5;
                image_yscale = 0.5;
            }

         // Gas:
        repeat(3 + irandom(3)){
            with(scrEnemyShoot(ToxicGas, direction + 180 + orandom(4), 1 + random(2))){
                friction = 0.16;
                team = 0;
            }
        }

         // Effects:
        wkick = 6;
        gunangle = direction;
        repeat(1 + irandom(2))
            with instance_create(x, y, AcidStreak)
                image_angle = other.direction + 180 + orandom(64);
    }
    else{
        meleedamage = 0;

        sound_play(sndFlamerStop);
        sound_stop(sndFlamerLoop);

        view_shake_at(x, y, 12);
    }

#define CatBoss_hurt(_hitdmg, _hitvel, _hitdir)
    if(!instance_is(other, ToxicGas)){
        my_health -= _hitdmg;
        nexthurt = current_frame + 6;
        sound_play_hit(snd_hurt, 0.3);
        if !dash motion_add(_hitdir, _hitvel);

         // Hurt Sprite:
        sprite_index = spr_hurt;
        image_index = 0;
    }

     // Toxic immune
    else with(other){
        instance_copy(false);
		instance_delete(id);
		for(var i = 0; i < maxp; i++) view_shake[i] -= 1;
	}

#define OLDCatBoss_alrm0
    alarm0 = 20 + random(20);

    if(ammo > 0) {
        with(scrEnemyShoot(ToxicGas, gunangle + orandom(8), 4)) {
            friction = 0.2;
        }
        gunangle += 24;
        ammo--;
        if(ammo = 0) {
            alarm0 = 40;

            repeat(3) {
                var _dir = orandom(16);
                with(instance_create(x, y, AcidStreak)) {
                    motion_add(other.gunangle + _dir, 3);
                    image_angle = direction;
                }
            }

            target = instance_nearest(x, y, Player);
            var _targetDir = point_direction(x, y, target.x, target.y);

            with(scrEnemyShootExt(x - (2 * right), y, "CatGrenade", _targetDir, 3)){
                z += 12;
                depth = 12;
                zspeed = (point_distance(x, y - z, other.target.x, other.target.y) / 8) + orandom(1);
                right = other.right;
            }

            gunangle = _targetDir;
            wkick += 6;
            sound_play_pitch(sndEmpty, random_range(0.75, 0.9));
            sound_play_pitch(sndToxicLauncher, random_range(0.75, 0.9));
            sound_stop(sndFlamerLoop);
        } else {
            alarm0 = 1;
            wkick += 1;
        }
    } else {
        target = instance_nearest(x, y, Player);
        if(target_is_visible()) {
            var _targetDir = point_direction(x, y, target.x, target.y);

            if(target_in_distance(0, 140) and random(3) < 1) {
                if(random(3) < 3) {
                    scrRight(_targetDir);
                    gunangle = _targetDir - 45;
                    ammo = 20;
                    with(instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), BloodGamble)) {
                        sprite_index = spr.AcidPuff;
                        image_angle = other.gunangle;
                    }
                    sound_play(sndToxicBoltGas);
                    sound_play(sndEmpty);
                    var s = sndFlamerLoop;
                    sound_loop(sndFlamerLoop);
                    sound_pitch(sndFlamerLoop, random_range(1.8, 1.4));
                    wkick += 4;
                    alarm0 = 4;
                }
            } else {
                alarm0 = 20 + random(20);
                scrWalk(20 + random(5), _targetDir + orandom(20));
                scrRight(gunangle);
            }
        } else {
            alarm0 = 30 + random(20); // 3-4 Seconds
            scrWalk(20 + random(10), random(360));
            scrRight(gunangle);
        }
    }

#define CatBoss_draw
    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();

#define CatBoss_death
    sound_stop(sndFlamerLoop); // Stops infinite flamer loop until you leave
    pickup_drop(100, 20);
    pickup_drop(60, 0);

     // Hmmmm
    instance_create(x, y, ToxicDelay);


#define CatBossAttack_step
     // Follow Creator:
    if(instance_exists(creator)){
        var o = 16;
        x = creator.x + lengthdir_x(o, creator.gunangle);
        y = creator.y + lengthdir_y(o, creator.gunangle);
    }

     // Hitscan Lines:
    with(fire_line){
        dir += angle_difference(dir_goal, dir) / 7;

         // Line Hitscan:
        var o = 4,
            _dir = dir + other.direction,
            _x = 0,
            _y = 0,
            _ox = lengthdir_x(o, _dir),
            _oy = lengthdir_y(o, _dir);

        dis = 0;
        with(other) while(other.dis < other.dis_goal){
            other.dis += o;
            _x += _ox;
            _y += _oy;
            if(position_meeting(x + _x, y + _y, Wall)) break;

             // Sparkly Laser:
            if(current_frame_active && random(250) < 1){
                with(instance_create(x + _x + orandom(4), y + _y + orandom(4), EatRad)){
                    sprite_index = choose(sprEatRadPlut, sprEatBigRad);
                    motion_set(_dir + 180 + orandom(60), 2);
                }
            }
        }
    }

    enemyAlarms(1);

#define CatBossAttack_draw
     // Laser Sights:
    var _x = x,
        _y = y;

    draw_set_color(image_blend);
    with(fire_line){
        var _dir = dir + other.direction;
        draw_line_width(_x, _y, _x + lengthdir_x(dis, _dir), _y + lengthdir_y(dis, _dir), other.image_yscale);

         // Bloom:
        draw_set_blend_mode(bm_add);
        draw_set_alpha(0.1);
        draw_line_width(_x, _y, _x + lengthdir_x(dis, _dir), _y + lengthdir_y(dis, _dir), other.image_yscale * 3);
        draw_set_alpha(1);
        draw_set_blend_mode(bm_normal);
    }

#define CatBossAttack_alrm0
     // Hitscan Toxic:
    var _x = x,
        _y = y;

    for(var i = 0; i < array_length(fire_line); i++){
        var _line = fire_line[i],
            _dis = _line.dis,
            _dir = _line.dir + direction;

        while(_dis > 0){
            with(instance_create(_x + lengthdir_x(_dis, _dir), _y + lengthdir_y(_dis, _dir), ToxicGas)){
                friction += random_range(0.1, 0.2);
                growspeed *= _dis / _line.dis;
                creator = other.creator;
                hitid = other.hitid;

                if(random(2) < 1){
                    with(instance_create(x + orandom(8), y + orandom(8), AcidStreak)){
                        motion_add(_dir + orandom(8), 4);
                        image_angle = direction;
                    }
                }
            }
            _dis -= 6;
        }
    }

     // Effects:
    view_shake_at(x, y, 32);
    sound_play(sndHyperSlugger);
    sound_play(sndToxicBarrelGas);

     // Cat knockback:
    with(creator){
        motion_add(other.direction + 180, 2);
        wkick = 12;
    }

    instance_destroy();


#define CatDoor_step
     // Opening & Closing:
    var s = 0,
        _open = false;

    if(distance_to_object(Player) <= 0 || distance_to_object(enemy) <= 0 || distance_to_object(Ally) <= 0 || distance_to_object(CustomObject) <= 0){
        with(instances_named(CustomObject, "Pet")){
            if(distance_to_object(other) <= 0){
                var _sx = lengthdir_x(hspeed, other.image_angle),
                    _sy = lengthdir_y(vspeed, other.image_angle);

                s = 3 * (_sx + _sy);
                _open = true;
            }
        }
        with(instances_matching_ne(hitme, "team", team)){
            if(distance_to_object(other) <= 0){
                var _sx = lengthdir_x(hspeed, other.image_angle),
                    _sy = lengthdir_y(vspeed, other.image_angle);

                s = 3 * (_sx + _sy);
                _open = true;
            }
        }
    }
    if(_open){
        if(s != 0){
            if(abs(openang) < abs(s) && abs(openang) < 4){
                var _vol = clamp(40 / (distance_to_object(Player) + 1), 0, 1);
                if(_vol > 0.2){
                    sound_play_pitchvol(sndMeleeFlip, 1 + random(0.4), 0.8 * _vol);
                    sound_play_pitchvol(((openang > 0) ? sndAmmoChest : sndWeaponChest), 0.4 + random(0.2), 0.5 * _vol);
                }
            }
            openang += s;
        }
        openang = clamp(openang, -90, 90);
    }
    else openang *= 0.8;

     // Collision:
    if(abs(openang) > 20) mask_index = mskNone;
    else mask_index = msk.CatDoor;

     // Block Line of Sight:
    if(!instance_exists(my_wall)) my_wall = instance_create(0, 0, Wall);
    with(my_wall){
        x = other.x;
        y = other.y;
        if(other.mask_index == mskNone) mask_index = -1;
        else mask_index = msk.CatDoorLOS;
        image_xscale = other.image_xscale;
        image_yscale = other.image_yscale;
        image_angle = other.image_angle;
        sprite_index = -1;
        visible = 0;
        topspr = -1;
        outspr = -1;
    }

     // Draw Self:
    if(!surface_exists(my_surf) || openang != openang_last){
        if(!surface_exists(my_surf)) my_surf = surface_create(my_surf_w, my_surf_h);
        surface_set_target(my_surf);
        draw_clear_alpha(0, 0);

         // Draw 3D Door:
        for(var i = 0; i < image_number; i++){
            draw_sprite_ext(sprite_index, i, (my_surf_w / 2), (my_surf_h / 2) - i, image_xscale, image_yscale, image_angle + (openang * image_yscale), image_blend, 1);
        }

        surface_reset_target();
    }
    openang_last = openang;

     // Death:
    if(my_health <= 0){
        sound_play(snd_dead);

        repeat(4) with(instance_create(x, y, Shell)){
            sprite_index = sprDebris102; // Temporary duh
            image_index = random(image_number);
            image_speed = 0;
            motion_add(other.direction + orandom(20), other.speed);
        }
        repeat(4) with(instance_create(x, y, Dust)){
            motion_add(other.direction + orandom(20), other.speed / 2);
        }

        instance_destroy();
    }

     // Stay Still:
    else speed = 0;

#define CatDoor_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    motion_add(_hitdir, _hitvel);	// Knockback
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);	// Sound

     // Push Open Force:
    if(instance_exists(other)){
        var _sx = lengthdir_x(other.hspeed, image_angle),
            _sy = lengthdir_y(other.vspeed, image_angle);

        openang += (_sx + _sy);
    }

     // Shared Hurt:
    if(_hitdmg > 0){
        with(partner) if(my_health > other.my_health){
            CatDoor_hurt(_hitdmg, _hitvel, _hitdir);
        }
    }

#define CatDoor_draw
    if(surface_exists(my_surf)){
        var h = (nexthurt > current_frame + 3);
        if(h) d3d_set_fog(1, image_blend, 0, 0);
        draw_surface_ext(my_surf, x - (my_surf_w / 2), y - (my_surf_h / 2), 1, 1, 0, c_white, image_alpha);
        if(h) d3d_set_fog(0, 0, 0, 0);
    }

#define CatDoor_destroy
    instance_delete(my_wall);


#define CatGrenade_step
     // Rise & Fall:
    z_engine();
    depth = max(-z, -12);

     // Trail:
    if(random(2) < 1){
        with(instance_create(x + orandom(4), y - z + orandom(4), PlasmaTrail)) {
            sprite_index = sprToxicGas;
            image_xscale = 0.25;
            image_yscale = image_xscale;
            image_angle = random(360);
            image_speed = 0.4;
            depth = other.depth;
        }
    }

     // Hit:
    if(z <= 0) instance_destroy();

#define CatGrenade_destroy
    with(instance_create(x, y, Explosion)){
        team = other.team;
        creator = other.creator;
        hitid = other.hitid;
    }

    repeat(18) {
        with(scrEnemyShoot(ToxicGas, random(360), 4)) {
            friction = 0.2;
        }
    }

     // Sound:
    sound_play(sndGrenade);
    sound_play(sndToxicBarrelGas);

#define CatGrenade_draw
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale * right, image_angle - (speed * 2) + (max(zspeed, -8) * 8), image_blend, image_alpha);

#define CatGrenade_hit
    // nada

#define CatGrenade_wall
    // nada


#define CatHole_step
    enemyAlarms(1);
    if !image_index image_speed = 0;
    if floor(image_index) == 6 && !place_meeting(x,y,ImpactWrists){
        instance_create(x,y,ImpactWrists);//repeat(irandom_range(2,4)) with instance_create(x,y,MeleeHitWall) image_angle = irandom(359);
        CatHole_effects();
    }

#define CatHole_alrm0
    if instance_exists(cat){
        //CatHole_effects();
         // Players standing on top keep cats in
        if place_meeting(x,y,Player){
            with instance_nearest(x,y,Player) motion_add(point_direction(other.x,other.y,x,y),2);
            alarm0 = 30 + irandom(20);
            image_index = 6;
            image_speed = 0.4;

        }
         // Release cats
        else{
            image_index = 1;
            image_speed = 0.4;
            var _team = cat.team;
            with instance_create(x,y,PortalClear) team = _team;
            with(cat){
                canfly = false;
                alarm0 = 10;
                alarm1 = 90 + irandom(60);
                x = other.x;
                y = other.y;
                hole = noone;
            }
            cat = noone;
        }
    }
    else cat = noone;

#define CatHole_effects
    view_shake_at(x,y,10);
    sound_play_pitchvol(sndHitMetal,0.5,1);


#define CatLight_draw(_x, _y, _w1, _w2, _h1, _h2, _offset)
     // Trapezoid Bit:
    var _x1a = _x - (_w1 / 2),
        _x2a = _x1a + _w1,
        _y1 = _y,
        _x1b = _x - (_w2 / 2) + _offset,
        _x2b = _x1b + _w2,
        _y2 = _y + _h1;

    draw_trapezoid(_x1a, _x2a, _y1, _x1b, _x2b, _y2);

     // Half Oval Bit:
    var _segments = 8,
        _cw = _w2 / 2,
        _cx = _x1b + _cw,
        _cy = _y2;

    draw_primitive_begin(pr_trianglefan);
    draw_vertex(_cx, _cy);
    for(var i = 0; i <= _segments; i++){
        var a = (i / _segments) * -180;
        draw_vertex(_cx + lengthdir_x(_cw, a), _cy + lengthdir_y(_h2, a));
    }
    draw_primitive_end();

#define draw_trapezoid(_x1a, _x2a, _y1, _x1b, _x2b, _y2)
    draw_primitive_begin(pr_trianglestrip);
    draw_vertex(_x1a, _y1);
    draw_vertex(_x1b, _y2);
    draw_vertex(_x2a, _y1);
    draw_vertex(_x2b, _y2);
    draw_primitive_end();

#define VenomFlak_wall
    move_bounce_solid(false);
    speed = min(speed, 8);

     // effects:
    with instance_create(x, y, AcidStreak){
        motion_set(other.direction, 3);
        image_angle = direction;
         // fat splat:
        image_yscale *= 2;
    }

    sound_play_pitchvol(sndShotgunHitWall, 1.2, 1);
    sound_play_pitchvol(sndFrogEggHurt, 0.7, 0.2);

#define VenomFlak_destroy
    instance_create(x, y, PortalClear);

     // effects:
    for (var i = 0; i <= 360; i += 360 / 20){
        with instance_create(x, y, Smoke)
            motion_set(i, 4 + random(4));
    }

    view_shake_at(x, y, 20);

    sound_play_pitchvol(sndHeavyMachinegun, 1, 0.8);
    sound_play_pitchvol(sndSnowTankShoot, 1.4, 0.7);
    sound_play_pitchvol(sndFrogEggHurt, 0.4 + random(0.2), 3.5);

     // bullets:
    for (var d = 0; d <= 360; d += 360 / 12){

         // lines of venom:
        if (d mod 90) == 0{
            for (var i = 0; i <= 5; i++){
                with scrEnemyShoot("TrafficCrabVenom", direction + d + orandom(2 + i), 2 * i){
                    move_contact_solid(direction, 4 + 4 * i);

                     // effects:
                    with instance_create(x, y, AcidStreak){
                        motion_set(other.direction + orandom(4), other.speed * 0.8);
                        image_angle = direction;
                    }
                }
            }
        }

         // single venom bullets:
        else{
            with scrEnemyShoot("TrafficCrabVenom", direction + d + orandom(2), 5.8 + random(0.4)){
                move_contact_solid(direction, 6);
            }
        }
    }

#define VenomFlak_step
     // effects:
    if random(3) < current_time_scale
        with instance_create(x, y, Smoke)
            depth = other.depth + 1;

     // timeout:
    time -= current_time_scale;
    if time <= 0
        instance_destroy();

#define VenomFlak_draw
    draw_self();
    draw_set_blend_mode(bm_add);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * 0.1);
    draw_set_blend_mode(bm_normal);

#define ParrotFeather_step
    speed *= 0.9;
    if(instance_exists(target)){
        if(stick){
             // Fall Off:
            if(stick_time <= 0 || !target.charm.charmed){
                target = noone;
            }
            else stick_time -= current_time_scale;
        }
        else{
             // Fly Towards Enemy:
            motion_add(point_direction(x, y, target.x, target.y) + orandom(60), 1);
            image_angle = direction + 135;

            if(place_meeting(x, y, target) || (target == creator && place_meeting(x, y, Portal))){
                 // Effects:
                with(instance_create(x, y, Dust)) depth = other.depth - 1;
                sound_play_pitchvol(sndFlyFire, 2 + random(0.2), 0.25);
                sound_play_pitchvol(sndChickenThrow, 1 + orandom(0.3), 0.25);
                sound_play_pitchvol(sndMoneyPileBreak, 1 + random(3), 0.5);

                 // Stick to & Charm Enemy:
                if(target != creator){
                    stick = true;
                    stickx = random(x - target.x) * (("right" in target) ? target.right : 1);
                    sticky = random(y - target.y);
                    image_angle = random(360);
                    speed = 0;

                     // Charm Enemy:
                    var c = scrCharm(target, true);
                    c.time += 30 + (skill_get(mut_throne_butt) * 15);
                    stick_time = c.time;
                }

                 // Player Pickup:
                else{
                    with(creator) feather_ammo++;
                    instance_destroy();
                }
            }
        }
    }

     // Fall to Ground:
    else{
        with(instance_create(x, y, Feather)){
            sprite_index = other.sprite_index;
            image_angle = other.image_angle;
            image_blend = merge_color(other.image_blend, c_black, 0.5);
        }
        instance_destroy();
    }

#define ParrotFeather_end_step
    if(stick && instance_exists(target)){
        x = target.x + (stickx * image_xscale * (("right" in target) ? target.right : 1));
        y = target.y + (sticky * image_yscale);
        visible = target.visible;
        if("wading" in target && target.wading != 0) visible = true;
        depth = target.depth - 1;
    }


#define ParrotChester_step
    if(instance_exists(creator)){
        x = creator.x;
        y = creator.y;
    }
    else{
         // Feather Pickups:
        var t = instances_matching(Player, "race", "parrot");
        if(array_length(t) > 0 && num > 0){
            with(t) repeat(other.num){
                with(obj_create(other.x + orandom(8), other.y + orandom(8), "ParrotFeather")){
                    target = other;
                    creator = other;
                }
            }
        }

        instance_destroy();
    }


#define PizzaDrain_step
     // Stay Still:
    if(instance_exists(target)){
        x = target.x;
        y = target.y + 16;
    }
    else{
        x = xstart;
        y = ystart;
    }
    speed = 0;

     // Animate:
    if(sprite_index != spr_idle){
        if(anim_end) sprite_index = spr_idle;
    }

     // Break:
    with(instances_matching_le(instances_matching_ge(instances_matching_lt(FloorExplo, "y", y), "x", x - 16), "x", x)){
        instance_create(x, y, PortalClear);
        other.my_health = 0;
    }

     // Death:
    if(my_health <= 0) instance_destroy();

#define PizzaDrain_destroy
    sound_play(snd_dead);
    scrPortalPoof();

     // Corpse:
    with(instance_create(x, y, Corpse)){
        sprite_index = other.spr_dead;
        mask_index = other.mask_index;
        image_xscale = other.image_xscale;
        size = other.size;
    }

    /// Entrance:
        var _sx = (floor(x / 32) * 32) - 16,
            _sy = (floor(y / 32) * 32) - 16;

         // Borderize Area:
        var _borderY = _sy - 248;
        area_border(_borderY, string(GameCont.area), background_color);

         // Path Gen:
        var _dir = 90,
            _path = [];

        instance_create(_sx + 16, _sy + 16, PortalClear);
        while(_sy >= _borderY - 224){
            with(instance_create(_sx, _sy, Floor)){
                array_push(_path, id);

                 // Stuff in path fix:
                with(instance_rectangle(x, y, x + 32, y + 32, [TopSmall, Wall])) instance_destroy();
            }

            if(!in_range(_sy, _borderY - 160, _borderY + 32)) _dir = 90;
            else{
                _dir += choose(0, 0, 0, 0, -90, 90);
                if(((_dir + 360) mod 360) == 270) _dir = 90;
            }

            _sx += lengthdir_x(32, _dir);
            _sy += lengthdir_y(32, _dir);
        }

         // Generate the Realm:
        area_generate(_sx, _sy - 32, sewers);

         // Finish Path:
        with(_path){
            sprite_index = area_get_sprite(sewers, sprFloor1B);
            scrFloorWalls();
        }
        floor_reveal(_path, 2);


#define PizzaTV_end_step(_inst)
    if(instance_exists(_inst)) with(_inst){
        depth = 0;

         // Death without needing a corpse sprite haha:
        if(my_health <= 0){
            with(instance_create(x, y, Corpse)){
                sprite_index = other.spr_dead;
                mask_index = other.mask_index;
                size = other.size;
            }

             // Zap:
            sound_play_pitch(sndPlantPotBreak, 1.6);
            sound_play_pitchvol(sndLightningHit, 1, 2);
            repeat(2) instance_create(x, y, PortalL);

            instance_delete(id);
        }
    }
    else instance_destroy();


#define InvMortar_step
    if random(3) < current_time_scale
        instance_create(x + orandom(8), y + orandom(8), Curse);

    Mortar_step();

#define InvMortar_hurt(_hitdmg, _hitvel, _hitdir)
    Mortar_hurt(_hitdmg, _hitvel, _hitdir);

    if my_health > 0 && random(1) < _hitdmg / 25{
        var _a = instances_matching([InvLaserCrystal, InvSpider], "", null),
            _n = array_length(_a),
            _x = x,
            _y = y;

         // Swap places with another dude:
        if _n{
            with(_a[irandom(_n-1)]){
                other.x = x;
                other.y = y;
                x = _x;
                y = _y;
                nexthurt = current_frame + 6;

                 // Unstick from walls by annihilating them:
                with instance_create(x, y, PortalClear)
                    mask_index = other.mask_index;

                 // Effects:
                sprite_index = spr_hurt;
                image_index = 0;
                sleep(15);
                view_shake_at(x, y, 12);
            }

             // Unstick from walls by annihilating them:
            with instance_create(x, y, PortalClear)
                mask_index = other.mask_index;
        }
    }

#define Mortar_step
    enemyAlarms(2);

     // Animate:
    if(sprite_index != spr_hurt and sprite_index != spr_fire){
    	if(speed <= 0) sprite_index = spr_idle;
    	else if(sprite_index == spr_idle) sprite_index = spr_walk;
    }
    else{
         // End Hurt Sprite:
        if(sprite_index = spr_hurt and image_index > 2) sprite_index = spr_idle;

         // End Fire Sprite:
        if(sprite_index = spr_fire && (image_index > sprite_get_number(spr_fire) - 1)){
            sprite_index = spr_idle;
        }
    }

     // Charging effect:
    if sprite_index == spr_fire && random(5) < current_time_scale{
        var _x = x + 6 * right,
            _y = y - 16,
            _l = irandom_range(16, 24),
            _d = irandom(359);
        with instance_create(_x + lengthdir_x(_l, _d), _y + lengthdir_y(_l, _d), LaserCharge){
            depth = other.depth - 1;
            motion_set(_d + 180, random_range(1,2));
            alarm0 = point_distance(x, y, _x, _y) / speed;
        }
    }

    enemyWalk(walkspd, maxspd);

#define Mortar_alrm0
    alarm0 = 80 + irandom(20);
    target = instance_nearest(x, y, Player);

     // Near Target:
    if(target_in_distance(0, 240)){
        var _targetDir = point_direction(x, y, target.x, target.y);

         // Attack:
        if(random(3) < 1){
            ammo = 4;
            alarm1 = 26;
            sprite_index = spr_fire;
            sound_play(sndCrystalJuggernaut);
        }

         // Move Towards Target:
        else{
            walk = 15 + random(30);
            direction = _targetDir + orandom(15);
            alarm0 = 40 + irandom(40);
        }

         // Facing:
        scrRight(_targetDir);
    }

     // Passive Movement:
    else{
        walk = 10;
        alarm0 = 50 + irandom(30);
        direction = random(360);
        scrRight(direction);
    }

#define Mortar_alrm1
    if(ammo > 0){
        target = instance_nearest(x, y, Player);

        if(target < 0)
        exit;

        var _targetDir = point_direction(x, y, target.x, target.y) + orandom(6);

         // Sound:
        sound_play(sndCrystalTB);
        sound_play(sndPlasma);

         // Facing:
        scrRight(_targetDir);

         // Shoot Mortar:
        with(scrEnemyShootExt(x + (5 * right), y, "MortarPlasma", _targetDir, 3)){
            z += 18;
            depth = 12;
            zspeed = ((point_distance(x, y, other.target.x + orandom(16), other.target.y + orandom(16)) - z) * zfric) / (speed * 2);

             // Cool particle line
            var _x = x,
                _y = y,
                _z = z,
                _zspd = zspeed,
                _zfrc = zfric,
                i = 0;

            while(_z > 0){
                with(instance_create(_x, _y - _z, BoltTrail)){
                    image_angle = point_direction(x, y, _x + other.hspeed, _y + other.vspeed - (_z + _zspd));
                    image_xscale = point_distance(x, y, _x + other.hspeed, _y + other.vspeed - (_z + _zspd));
                    image_yscale = random(1.5);
                    image_blend = make_color_rgb(235, 0, 67);
                    depth = -8;
                    if(random(6) < 1){
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
                var l = 16,
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

        alarm1 = 4;
        ammo--;
    }

#define Mortar_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    motion_add(_hitdir, _hitvel);	// Knockback
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);	// Sound

     // Hurt Sprite:
    if(sprite_index != spr_fire){
        sprite_index = spr_hurt;
        image_index = 0;
    }

#define Mortar_draw
     // Flash White w/ Hurt While Firing:
    if(
        sprite_index == spr_fire &&
        nexthurt > current_frame &&
        (nexthurt + current_frame) mod (room_speed/10) = 0
    ){
        d3d_set_fog(true, c_white, 0, 0);
        draw_self_enemy();
        d3d_set_fog(false, c_black, 0, 0);
    }

     // Normal Self:
    else draw_self_enemy();


#define MortarPlasma_step
     // Rise & Fall:
    z_engine();
    depth = max(-z, -12);

     // Facing:
    if(in_range(direction, 30, 150) || in_range(direction, 210, 330)){
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
    if(current_frame_active && random(2) < 1){
        with(instance_create(x + orandom(4), y - z + orandom(4), PlasmaTrail)) {
            sprite_index = spr.MortarTrail;
            depth = other.depth;
        }
    }

     // Hit:
    if(z <= 0) instance_destroy();

#define MortarPlasma_destroy
    with(instance_create(x, y, PlasmaImpact)){
        sprite_index = spr.MortarImpact;
        team = other.team;
        creator = other.creator;
        hitid = other.hitid;
        damage = 1;
    }

     // Effects:
    view_shake_at(x, y, 8);
    sound_play(sndPlasmaHit);

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


#define NewCocoon_death
     // Hatch 1-3 Spiders:
    repeat(irandom_range(1, 3)) {
    	obj_create(x,y,"Spiderling");
    }

#define Spiderling_step
    enemyWalk(walkspd, maxspd);
    enemySprites();
    enemyAlarms(2);

#define Spiderling_alrm0
    alarm0 = 10 + irandom(10);
    target = instance_nearest(x,y,Player);

     // Move towards player:
    if(target_is_visible() && target_in_distance(0, 96)){
        scrWalk(14, point_direction(x, y, target.x, target.y) + orandom(20));
    }

     // Wander:
    else scrWalk(12, direction + orandom(20));

#define Spiderling_alrm1
     // Shhh dont tell anybody
    with(instance_create(x, y, Spider)){
        x = other.x;
        y = other.y;
        right = other.right;
        alarm1 = 10 + random(10);
    }

     // Effects
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
        with(instance_create(x, y, Shell)){
            motion_add(a + orandom(30), 3 + random(4));
            friction *= 2;
            sprite_index = sprHyperCrystalShard;
            image_index = random(image_number - 1);
            image_speed = 0;
            depth = 0;
        }
    }
    sound_play_hit(sndHitRock, 0.3);
    sound_play_hit(sndBouncerBounce, 0.5);
    sound_play_pitchvol(sndCocoonBreak, 2 + random(1), 0.8);

    instance_delete(id);




#define game_start
    with(instances_named(CustomObject, "Pet")) instance_destroy();

#define step
     // Harpoon Connections:
    for(var i = 0; i < array_length(global.poonRope); i++){
        var _rope = global.poonRope[i],
            _link1 = _rope.link1,
            _link2 = _rope.link2;

        if(instance_exists(_link1) && instance_exists(_link2)){
            var _length = _rope.length,
                _linkDis = point_distance(_link1.x, _link1.y, _link2.x, _link2.y) - _length,
                _linkDir = point_direction(_link1.x, _link1.y, _link2.x, _link2.y);

             // Pull Link:
            if(_linkDis > 0) with([_link1, _link2]){
                if("name" in self && name == "Harpoon"){
                    if(canmove) with(target){
                        var _pull = other.pull_speed,
                            _drag = min(_linkDis / 3, 10 / (("size" in self) ? (size * 2) : 2));

                        hspeed += lengthdir_x(_pull, _linkDir);
                        vspeed += lengthdir_y(_pull, _linkDir);
                        x += lengthdir_x(_drag, _linkDir);
                        y += lengthdir_y(_drag, _linkDir);
                    }
                }
                _linkDir += 180;
            }

             // Deteriorate Rope:
            var _deteriorate = (_rope.deteriorate_timer == 0);
            if(_deteriorate) _rope.length *= 0.9;
            else if(_rope.deteriorate_timer > 0){
                _rope.deteriorate_timer -= min(1, _rope.deteriorate_timer);
            }

             // Rope Stretching:
            with(_rope){
                break_force = max(_linkDis, 0);

                 // Break:
                if(break_timer > 0) break_timer -= current_time_scale;
                else if(break_force > 100 || (_deteriorate && _length <= 1)){
                    if(_deteriorate) with([_link1, _link2]) image_index = 1;
                    else sound_play_pitch(sndHammerHeadEnd, 2);
                    scrHarpoonUnrope(_rope);
                }
            }

             // Draw Rope:
            script_bind_draw(draw_rope, 0, _rope);
        }
        else scrHarpoonUnrope(_rope);
    }

     // Reset Lights:
    with(instances_matching(GenCont, "catlight_reset", null)){
        catlight_reset = true;
        global.catLight = [];
    }

#define draw_bloom
    /*with(instances_named(CustomProjectile, "BubbleBomb")){
        draw_sprite_ext(sprite_index, image_index, x, y - z, 1.5 * image_xscale, 1.5 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
    }*/

    with(instances_named(CustomProjectile, "LightningDisc")){
        scrDrawLightningDisc(sprite_index, image_index, x, y, ammo, radius, 2, image_xscale, image_yscale, image_angle + rotation, image_blend, 0.1 * image_alpha);
    }

#define draw_shadows
    // with(instances_named(CustomProjectile, ["MortarPlasma", "CatGrenade"])) if(visible){
    //     draw_sprite(shd24, 0, x, y - z);
    // }

    with(instances_named(CustomObject, "Pet")) if(visible){
        draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
    }

    with(instances_matching(CustomProjectile, "name", "MortarPlasma", "CatGrenade")) if(visible){
        var _percent = clamp(96 / z, 0.1, 1),
            _w = ceil(18 * _percent),
            _h = ceil(6 * _percent);

        draw_ellipse(x - _w / 2, y - _h / 2, x + _w / 2, y + _h / 2, false);
    }

    with(instances_named(CustomEnemy, "CoastBoss")){
        for(var i = 0; i < array_length(fish_train); i++){
            if(array_length(fish_swim) > i && fish_swim[i]){
                with(fish_train[i]){
                    draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
                }
            }
        }
    }

#define draw_dark // Drawing Grays
    draw_set_color(c_gray);

     // Cat Light:
    with(global.catLight){
        offset = random_range(-1, 1);

         // Flicker:
        if(current_frame_active){
            if(random(60) < 1) active = false;
            else active = true;
        }

        if(active){
            var b = 2; // Border Size
            CatLight_draw(x, y, w1 + b, w2 + (3 * (2 * b)), h1 + (2 * b), h2 + b, offset);
        }
    }

     // TV:
    with(TV) draw_circle(x, y, 64 + random(2), 0);

     // Mortar:
    with(instances_matching(CustomEnemy, "name", "Mortar", "InvMortar")){
        if(sprite_index == spr_fire){
            draw_circle(x + (6 * right), y - 16, 48 - alarm1 + orandom(4), false)
        }
    }

     // Mortar plasma:
    with(instances_matching(CustomProjectile, "name", "MortarPlasma")){
        draw_circle(x, y - z, 64 + orandom(1), false);
    }

#define draw_dark_end // Drawing Clear
    draw_set_color(c_black);

     // Cat Light:
    with(global.catLight) if(active){
        CatLight_draw(x, y, w1, w2, h1, h2, offset);
    }

     // TV:
    with(TV){
        var o = orandom(1);
        CatLight_draw(x + 1, y - 6, 12 + abs(o), 48 + o, 48, 8 + o, 0);
    }

     // Mortar:
    with(instances_matching(CustomEnemy, "name", "Mortar", "InvMortar")){
        if(sprite_index == spr_fire){
            draw_circle(x + (6 * right), y - 16, 24 - alarm1 + orandom(4), false)
        }
    }

     // Mortar plasma:
    with(instances_matching(CustomProjectile, "name", "MortarPlasma")){
        draw_circle(x, y - z, 32 + orandom(1), false);
    }



#define scrAnglerAppear()                                                                       mod_script_call("mod", "telib2", "scrAnglerAppear");
#define scrAnglerHide()                                                                         mod_script_call("mod", "telib2", "scrAnglerHide");

#define draw_self_enemy()                                                                       mod_script_call("mod", "teassets", "draw_self_enemy");
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call("mod", "teassets", "draw_weapon", _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define scrWalk(_walk, _dir)                                                                    mod_script_call("mod", "teassets", "scrWalk", _walk, _dir);
#define scrRight(_dir)                                                                          mod_script_call("mod", "teassets", "scrRight", _dir);
#define scrEnemyShoot(_object, _dir, _spd)                                              return  mod_script_call("mod", "teassets", "scrEnemyShoot", _object, _dir, _spd);
#define scrEnemyShootExt(_x, _y, _object, _dir, _spd)                                   return  mod_script_call("mod", "teassets", "scrEnemyShootExt", _x, _y, _object, _dir, _spd);
#define enemyAlarms(_maxAlarm)                                                                  mod_script_call("mod", "teassets", "enemyAlarms", _maxAlarm);
#define enemyWalk(_spd, _max)                                                                   mod_script_call("mod", "teassets", "enemyWalk", _spd, _max);
#define enemySprites()                                                                          mod_script_call("mod", "teassets", "enemySprites");
#define enemyHurt(_hitdmg, _hitvel, _hitdir)                                                    mod_script_call("mod", "teassets", "enemyHurt", _hitdmg, _hitvel, _hitdir);
#define scrDefaultDrop()                                                                        mod_script_call("mod", "teassets", "scrDefaultDrop");
#define target_in_distance(_disMin, _disMax)                                            return  mod_script_call("mod", "teassets", "target_in_distance", _disMin, _disMax);
#define target_is_visible()                                                             return  mod_script_call("mod", "teassets", "target_is_visible");
#define z_engine()                                                                              mod_script_call("mod", "teassets", "z_engine");
#define scrPickupIndicator(_text)                                                       return  mod_script_call("mod", "teassets", "scrPickupIndicator", _text);
#define scrCharm(_instance, _charm)                                                     return  mod_script_call("mod", "teassets", "scrCharm", _instance, _charm);
#define scrCharmTarget()                                                                return  mod_script_call("mod", "teassets", "scrCharmTarget");
#define scrBossHP(_hp)                                                                  return  mod_script_call("mod", "teassets", "scrBossHP", _hp);
#define scrBossIntro(_name, _sound, _music)                                                     mod_script_call("mod", "teassets", "scrBossIntro", _name, _sound, _music);
#define scrTopDecal(_x, _y, _area)                                                      return  mod_script_call("mod", "teassets", "scrTopDecal", _x, _y, _area);
#define scrWaterStreak(_x, _y, _dir, _spd)                                              return  mod_script_call("mod", "teassets", "scrWaterStreak", _x, _y, _dir, _spd);
#define scrRadDrop(_x, _y, _raddrop, _dir, _spd)                                        return  mod_script_call("mod", "teassets", "scrRadDrop", _x, _y, _raddrop, _dir, _spd);
#define scrCorpse(_dir, _spd)                                                           return  mod_script_call("mod", "teassets", "scrCorpse", _dir, _spd);
#define scrSwap()                                                                       return  mod_script_call("mod", "teassets", "scrSwap");
#define scrPortalPoof()                                                                 return  mod_script_call("mod", "teassets", "scrPortalPoof");
#define orandom(n)                                                                      return  mod_script_call("mod", "teassets", "orandom", n);
#define floor_ext(_num, _round)                                                         return  mod_script_call("mod", "teassets", "floor_ext", _num, _round);
#define array_count(_array, _value)                                                     return  mod_script_call("mod", "teassets", "array_count", _array, _value);
#define array_flip(_array)                                                              return  mod_script_call("mod", "teassets", "array_flip", _array);
#define instances_named(_object, _name)                                                 return  mod_script_call("mod", "teassets", "instances_named", _object, _name);
#define nearest_instance(_x, _y, _instances)                                            return  mod_script_call("mod", "teassets", "nearest_instance", _x, _y, _instances);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call("mod", "teassets", "instance_rectangle", _x1, _y1, _x2, _y2, _obj);
#define instances_seen(_obj, _ext)                                                      return  mod_script_call("mod", "teassets", "instances_seen", _obj, _ext);
#define frame_active(_interval)                                                         return  mod_script_call("mod", "teassets", "frame_active", _interval);
#define area_generate(_x, _y, _area)                                                    return  mod_script_call("mod", "teassets", "area_generate", _x, _y, _area);
#define scrFloorWalls()                                                                 return  mod_script_call("mod", "teassets", "scrFloorWalls");
#define floor_reveal(_floors, _maxTime)                                                 return  mod_script_call("mod", "teassets", "floor_reveal", _floors, _maxTime);
#define area_border(_y, _area, _color)                                                  return  mod_script_call("mod", "teassets", "area_border", _y, _area, _color);
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call("mod", "teassets", "area_get_sprite", _area, _spr);
#macro sewers "secret"
#define floor_at(_x, _y)                                                                return  mod_script_call("mod", "teassets", "floor_at", _x, _y);
#define in_range(_num, _lower, _upper)                                                  return  mod_script_call("mod", "teassets", "in_range", _num, _lower, _upper);
#define path_create(_xstart, _ystart, _xtarget, _ytarget)                               return  mod_script_call("mod", "teassets", "path_create", _xstart, _ystart, _xtarget, _ytarget);
