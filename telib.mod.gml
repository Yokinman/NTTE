#macro current_frame_active ((current_frame mod 1) < current_time_scale)

#define init
    //#region SPRITES
    	 // Big Decals:
    	global.sprBigTopDecal = {
    	    "1"     : sprite_add("sprites/areas/Desert/sprDesertBigTopDecal.png", 1, 32, 40),
    	    "2"     : sprite_add("sprites/areas/Sewers/sprSewersBigTopDecal.png", 1, 32, 40),
    	    "102"   : sprite_add("sprites/areas/Pizza/sprPizzaBigTopDecal.png",   1, 32, 40)
    	}
    	global.mskBigTopDecal = sprite_add("sprites/areas/Desert/mskBigTopDecal.png", 1, 32, 24);

    	 // Big Fish:
    	global.sprBigFishBecomeIdle = sprite_add("sprites/enemies/CoastBoss/sprBigFishBuild.png",      4, 40, 38);
    	global.sprBigFishBecomeHurt = sprite_add("sprites/enemies/CoastBoss/sprBigFishBuildHurt.png",  4, 40, 38);
    	global.sprBigFishSpwn =       sprite_add("sprites/enemies/CoastBoss/sprBigFishSpawn.png",     11, 32, 32);
    	global.sprBigFishLeap =       sprite_add("sprites/enemies/CoastBoss/sprBigFishLeap.png",      11, 32, 32);
    	global.sprBigFishSwim =       sprite_add("sprites/enemies/CoastBoss/sprBigFishSwim.png",       8, 24, 24);
    	global.sprBigFishRise =       sprite_add("sprites/enemies/CoastBoss/sprBigFishRise.png",       5, 32, 32);
    	global.sprBigFishSwimFrnt =   sprite_add("sprites/enemies/CoastBoss/sprBigFishSwimFront.png",  6,  4,  1);
    	global.sprBigFishSwimBack =   sprite_add("sprites/enemies/CoastBoss/sprBigFishSwimBack.png",  11,  5,  1);
    	global.sprBubbleBomb =        sprite_add("sprites/enemies/projectiles/sprBubbleBomb.png",     30,  8,  8);
    	global.sprBubbleExplode =     sprite_add("sprites/enemies/projectiles/sprBubbleExplode.png",   9, 24, 24);

         // Harpoon:
        global.sprHarpoon = sprite_add_weapon("sprites/weps/projectiles/sprHarpoon.png", 4, 3);
        global.sprNetNade = sprite_add("sprites/weps/projectiles/sprNetNade.png", 1, 3, 3);

        //#region COAST
             // Blooming Cactus:
        	global.sprBloomingCactusIdle[0] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus.png",     1, 12, 12);
        	global.sprBloomingCactusHurt[0] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactusHurt.png", 3, 12, 12);
        	global.sprBloomingCactusDead[0] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactusDead.png", 4, 12, 12);

        	global.sprBloomingCactusIdle[1] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus2.png",     1, 12, 12);
        	global.sprBloomingCactusHurt[1] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus2Hurt.png", 3, 12, 12);
        	global.sprBloomingCactusDead[1] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus2Dead.png", 4, 12, 12);

        	global.sprBloomingCactusIdle[2] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus3.png",     1, 12, 12);
        	global.sprBloomingCactusHurt[2] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus3Hurt.png", 3, 12, 12);
        	global.sprBloomingCactusDead[2] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus3Dead.png", 4, 12, 12);

             // Decal Big Shell Prop:
    	    global.sprShellIdle = sprite_add("sprites/areas/Coast/Decals/sprShellIdle.png", 1, 32, 32);
    	    global.sprShellHurt = sprite_add("sprites/areas/Coast/Decals/sprShellHurt.png", 3, 32, 32);
    	    global.sprShellDead = sprite_add("sprites/areas/Coast/Decals/sprShellDead.png", 6, 32, 32);
    	    global.sprShellBott = sprite_add("sprites/areas/Coast/Decals/sprShellBott.png", 1, 32, 32);
    	    global.sprShellFoam = sprite_add("sprites/areas/Coast/Decals/sprShellFoam.png", 1, 32, 32);

             // Decal Water Rock Props:
            global.sprRockIdle[0] = sprite_add("sprites/areas/Coast/Decals/sprRock1Idle.png", 1, 16, 16);
            global.sprRockHurt[0] = sprite_add("sprites/areas/Coast/Decals/sprRock1Hurt.png", 3, 16, 16);
            global.sprRockDead[0] = sprite_add("sprites/areas/Coast/Decals/sprRock1Dead.png", 1, 16, 16);
            global.sprRockBott[0] = sprite_add("sprites/areas/Coast/Decals/sprRock1Bott.png", 1, 16, 16);
            global.sprRockFoam[0] = sprite_add("sprites/areas/Coast/Decals/sprRock1Foam.png", 1, 16, 16);
            global.sprRockIdle[1] = sprite_add("sprites/areas/Coast/Decals/sprRock2Idle.png", 1, 16, 16);
            global.sprRockHurt[1] = sprite_add("sprites/areas/Coast/Decals/sprRock2Hurt.png", 3, 16, 16);
            global.sprRockDead[1] = sprite_add("sprites/areas/Coast/Decals/sprRock2Dead.png", 1, 16, 16);
            global.sprRockBott[1] = sprite_add("sprites/areas/Coast/Decals/sprRock2Bott.png", 1, 16, 16);
            global.sprRockFoam[1] = sprite_add("sprites/areas/Coast/Decals/sprRock2Foam.png", 1, 16, 16);

             // Diver:
        	global.sprDiverIdle = sprite_add("sprites/enemies/Diver/sprDiverIdle.png", 4, 12, 12);
        	global.sprDiverWalk = sprite_add("sprites/enemies/Diver/sprDiverWalk.png", 6, 12, 12);
        	global.sprDiverHurt = sprite_add("sprites/enemies/Diver/sprDiverHurt.png", 3, 12, 12);
        	global.sprDiverDead = sprite_add("sprites/enemies/Diver/sprDiverDead.png", 9, 16, 16);
        	global.sprHarpoonGun = sprite_add("sprites/enemies/Diver/sprDiverHarpoonGun.png", 1, 8, 8);
        	global.sprHarpoonGunEmpty = sprite_add("sprites/enemies/Diver/sprDiverHarpoonGunDischarged.png", 1, 8, 8);

        	 // Gull:
        	global.sprGullIdle = sprite_add("sprites/enemies/Gull/sprGullIdle.png", 4, 12, 12);
        	global.sprGullWalk = sprite_add("sprites/enemies/Gull/sprGullWalk.png", 6, 12, 12);
        	global.sprGullHurt = sprite_add("sprites/enemies/Gull/sprGullHurt.png", 3, 12, 12);
        	global.sprGullDead = sprite_add("sprites/enemies/Gull/sprGullDead.png", 6, 16, 16);
        	global.sprGullSword = sprite_add("sprites/enemies/Gull/sprGullSword.png", 1, 6, 8);

             // Palanking:
            global.sprPalankingBott = sprite_add("sprites/enemies/Palanking/sprPalankingBottom.png",    1, 40, 28);
            global.sprPalankingLagh = sprite_add("sprites/enemies/Palanking/sprPalankingLaugh.png",     8, 40, 28);
            global.sprPalankingCall = sprite_add("sprites/enemies/Palanking/sprPalankingCall.png",     12, 40, 28);
            global.sprPalankingIdle = sprite_add("sprites/enemies/Palanking/sprPalankingIdle.png",      1, 40, 28);
            global.sprPalankingWalk = sprite_add("sprites/enemies/Palanking/sprPalankingWalk.png",      1, 40, 28);
            global.sprPalankingHurt = sprite_add("sprites/enemies/Palanking/sprPalankingHurt.png",      3, 40, 28);
            global.sprPalankingDead = sprite_add("sprites/enemies/Palanking/sprPalankingDead.png",      1, 40, 28);
            global.sprPalankingFoam = sprite_add("sprites/enemies/Palanking/sprPalankingFoam.png",      1, 40, 28);
            global.mskPalanking     = sprite_add("sprites/enemies/Palanking/mskPalanking.png",          1, 40, 28);
            if(fork()){
                wait 30;
                sprite_collision_mask(global.mskPalanking, false, 0, 0, 0, 0, 0, 0, 0);
                exit;
            }

             // Palm:
        	global.sprPalmIdle = sprite_add("sprites/areas/Coast/Props/sprPalm.png",     1, 24, 40);
        	global.sprPalmHurt = sprite_add("sprites/areas/Coast/Props/sprPalmHurt.png", 3, 24, 40);
        	global.sprPalmDead = sprite_add("sprites/areas/Coast/Props/sprPalmDead.png", 4, 24, 40);

             // Pelican:
            global.sprPelicanIdle   = sprite_add("sprites/enemies/Pelican/sprPelicanIdle.png",   6, 24, 24);
            global.sprPelicanWalk   = sprite_add("sprites/enemies/Pelican/sprPelicanWalk.png",   6, 24, 24);
            global.sprPelicanHurt   = sprite_add("sprites/enemies/Pelican/sprPelicanHurt.png",   3, 24, 24);
            global.sprPelicanDead   = sprite_add("sprites/enemies/Pelican/sprPelicanDead.png",   6, 24, 24);
            global.sprPelicanHammer = sprite_add("sprites/enemies/Pelican/sprPelicanHammer.png", 1,  6,  8);

             // Seal:
            global.sprTrident = sprite_add("sprites/enemies/Seal/sprTrident.png", 1, 18, 0);

             // Traffic Crab:
            global.sprCrabIdle = sprite_add("sprites/enemies/Crab/sprTrafficCrabIdle.png", 5, 24, 24);
            global.sprCrabWalk = sprite_add("sprites/enemies/Crab/sprTrafficCrabWalk.png", 6, 24, 24);
            global.sprCrabHurt = sprite_add("sprites/enemies/Crab/sprTrafficCrabHurt.png", 3, 24, 24);
            global.sprCrabDead = sprite_add("sprites/enemies/Crab/sprTrafficCrabDead.png", 9, 24, 24);
            global.sprCrabFire = sprite_add("sprites/enemies/Crab/sprTrafficCrabFire.png", 2, 24, 24);
    	//#endregion

        //#region OASIS
             // Hammerhead:
            global.sprHammerheadIdle = sprite_add("sprites/enemies/Hammer/sprHammerheadIdle.png", 6, 24, 24);
            global.sprHammerheadHurt = sprite_add("sprites/enemies/Hammer/sprHammerheadHurt.png", 3, 24, 24);
            global.sprHammerheadChrg = sprite_add("sprites/enemies/Hammer/sprHammerheadDash.png", 2, 24, 24);
        //#endregion

        //#region SEWERS
             // Cat:
            global.sprCatIdle = sprite_add("sprites/enemies/Cat/sprCatIdle.png", 4, 12, 12);
            global.sprCatWalk = sprite_add("sprites/enemies/Cat/sprCatWalk.png", 6, 12, 12);
            global.sprCatHurt = sprite_add("sprites/enemies/Cat/sprCatHurt.png", 3, 12, 12);
            global.sprCatDead = sprite_add("sprites/enemies/Cat/sprCatDead.png", 6, 12, 12);
            global.sprAcidPuff = sprite_add("sprites/enemies/Cat/sprAcidPuff.png", 4, 16, 16);
        //#endregion

        //#region CRYSTAL CAVES
        	 // Mortar:
        	global.sprMortarIdle = sprite_add("sprites/enemies/Mortar/sprMortarIdle.png", 4, 22, 24);
        	global.sprMortarWalk = sprite_add("sprites/enemies/Mortar/sprMortarWalk.png", 8, 22, 24);
        	global.sprMortarFire = sprite_add("sprites/enemies/Mortar/sprMortarFire.png", 16, 22, 24);
        	global.sprMortarHurt = sprite_add("sprites/enemies/Mortar/sprMortarHurt.png", 3, 22, 24);
        	global.sprMortarDead = sprite_add("sprites/enemies/Mortar/sprMortarDead.png", 14, 22, 24);
        	global.sprMortarPlasma = sprite_add("sprites/enemies/Mortar/sprMortarPlasma.png", 1, 4, 4);
        	global.sprMortarImpact = sprite_add("sprites/enemies/Mortar/sprMortarImpact.png", 7, 16, 16);
        	global.sprMortarTrail = sprite_add("sprites/enemies/Mortar/sprMortarTrail.png", 3, 4, 4);
        //#endregion
    //#endregion

     // Refresh Big Decals on Mod Load:
    with(instances_named(CustomObject, "BigDecal")){
        sprite_index = lq_defget(global.sprBigTopDecal, string(GameCont.area), mskNone);
    }

     // Harpoon Ropes:
    global.poonRope = [];


#define obj_create(_x, _y, obj_name)
    var o = noone,
        _name = string_upper(string(obj_name));

    switch(obj_name){
    	case "BigDecal":
    	    var a = string(GameCont.area);
    	    if(lq_exists(global.sprBigTopDecal, a)){
        	    o = instance_create(_x, _y, CustomObject);
        		with(o){
        		     // Visual:
        		    sprite_index = lq_get(global.sprBigTopDecal, a);
        			image_xscale = choose(-1, 1);
        			image_speed = 0;
        			depth = -8;

            		mask_index = global.mskBigTopDecal;

        		    if(place_meeting(x, y, TopPot)) instance_destroy();
                	else{
                         // TopSmalls:
                		var _off = 16,
                		    s = _off * 3;

                		for(var _ox = -s; _ox <= s; _ox += _off){
                		    for(var _oy = -s; _oy <= s; _oy += _off){
                		        if(random(2) < 1) instance_create(x + _ox, y + _oy, TopSmall);
                		    }
                		}
        		    }
        		}
    	    }
    	break;

        case "Bone":
            o = instance_create(_x, _y, CustomProjectile);
            with(o){
                 // Visual:
                sprite_index = sprBone;
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
    	        sprite_index = global.sprBubbleBomb;
    	        image_speed = 0.5;

    	         // Vars:
    	        mask_index = -1;
    	        z = 0;
    	        zspeed = -0.5;
    	        zfric = -0.02;
    	        friction = 0.4;
    	        damage = 0;
    	        force = 0;
    	        typ = 1;
    	        my_projectile = noone;

    	         // Alarms:
    	        alarm0 = (image_number / image_speed); // 2 seconds
    	    }
    	break;

        case "BubbleExplosion":
            o = instance_create(_x, _y, Explosion);
            with(o){
                sprite_index = global.sprBubbleExplode;
                mask_index = mskExplosion;
                hitid = [sprite_index, "BUBBLE EXPLO"];
                damage = 2;
                alarm0 = -1; // No scorchmark
            }

             // Effects:
            repeat(10) instance_create(_x, _y, Bubble);
            sound_play_pitch(sndExplosionS, 2);
            sound_play_pitch(sndOasisExplosion, 1 + random(1));
        break;

        case "CoastBossBecome":
            o = instance_create(_x, _y, CustomProp);
            with(o){
                 // Visual:
                spr_idle = global.sprBigFishBecomeIdle;
                spr_hurt = global.sprBigFishBecomeHurt;
                spr_dead = sprBigSkullDead;
                spr_shadow = shd32;
                image_speed = 0;
                depth = -1;

                 // Sound:
                snd_hurt = sndHitRock;
                snd_dead = -1;

                 // Vars:
                mask_index = mskBigSkull;
                maxhealth = 50 + (100 * GameCont.loops);
                my_health = maxhealth;
                size = 2;
                part = 0;
            }
            break;

    	case "CoastBoss":
    	    o = instance_create(_x, _y, CustomEnemy);
    	    with(o){
    	         // for sani's bosshudredux
    	        boss = 1;
    	        bossname = "BIG FISH";
    	        col = c_red;

    	        /// Visual:
    	            spr_spwn = global.sprBigFishSpwn;
        	        spr_idle = sprBigFishIdle;
        			spr_walk = sprBigFishWalk;
        			spr_hurt = sprBigFishHurt;
        			spr_dead = sprBigFishDead;
    			    spr_weap = mskNone;
    			    spr_shad = shd48;
        			spr_shadow = spr_shad;
        			hitid = [spr_idle, _name];
        			sprite_index = spr_spwn;
    			    depth = -2;
        			
        			 // Fire:
        			spr_chrg = sprBigFishFireStart;
        			spr_fire = sprBigFishFire;
        			spr_efir = sprBigFishFireEnd;

        			 // Swim:
        			spr_dive = global.sprBigFishLeap;
        			spr_rise = global.sprBigFishRise;

                 // Sound:
        		snd_hurt = sndOasisBossHurt;
        		snd_dead = sndOasisBossDead;

    			 // Vars:
        		mask_index = mskBigMaggot;
    			maxhealth = 120 * (1 + ((1/3) * GameCont.loops));
    			raddrop = 50;
    			size = 3;
    			meleedamage = 3;
    			walk = 0;
    			walkspd = 0.8;
    			maxspd = 3;
    			ammo = 4;
    			swim = 0;
    			gunangle = random(360);
    			direction = gunangle;
    			swim_ang_frnt = direction;
    			swim_ang_back = direction;
    			shot_wave = 0;
    			swimx = x;
    			swimy = y;

    			 // Alarms:
    			alarm0 = 60 + irandom(40);
    			alarm1 = -1;
    			alarm2 = -1;
    	    }
    	break;

        case "Harpoon":
            o = instance_create(_x, _y, CustomProjectile);
            with(o){
                sprite_index = global.sprHarpoon;
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

        case "NetNade":
            o = instance_create(_x, _y, CustomProjectile);
            with(o){
                sprite_index = global.sprNetNade;
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

        //#region COAST
            case "BloomingCactus":
                o = instance_create(_x, _y, Cactus);
                with(o){
                    var s = irandom(array_length(global.sprBloomingCactusIdle) - 1);
                    spr_idle = global.sprBloomingCactusIdle[s];
                    spr_hurt = global.sprBloomingCactusHurt[s];
                    spr_dead = global.sprBloomingCactusDead[s];
                }
            break;

            case "CoastBigDecal":
                return CoastDecal_create(_x, _y, 1);

            case "CoastDecal":
                return CoastDecal_create(_x, _y, 0);

        	case "Diver":
        	    o = instance_create(_x, _y, CustomEnemy);
        		with(o){
                     // Visual:
        			spr_idle = global.sprDiverIdle;
        			spr_walk = global.sprDiverWalk;
        			spr_hurt = global.sprDiverHurt;
        			spr_dead = global.sprDiverDead;
        			spr_weap = global.sprHarpoonGun;
        			spr_shadow = shd24;
        			hitid = [spr_idle, _name];
        			sprite_index = spr_idle;
        			depth = -3;

        			 // Sound:
        			snd_hurt = sndHitMetal;
        			snd_dead = sndAssassinDie;
    
        			 // Vars:
        			mask_index = mskBandit;
        			maxhealth = 12;
        			raddrop = 8;
        			size = 1;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 3;
        			gunangle = random(360);
        			direction = gunangle;
    
                     // Alarms:
        			alarm0 = 60 + irandom(30);
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
    				damage = 1;
    				force = 8;
    				typ = 2;
    			}
    		break;

        	case "Gull": 
        	    o = instance_create(_x, _y, CustomEnemy);
        		with(o){
                     // Visual:
        			spr_idle = global.sprGullIdle;
        			spr_walk = global.sprGullWalk;
        			spr_hurt = global.sprGullHurt;
        			spr_dead = global.sprGullDead;
        			spr_weap = global.sprGullSword;
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
        			raddrop = 6;
        			size = 1;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 3.5;
        			gunangle = random(360);
        			direction = gunangle;
        			wepangle = choose(-140, 140);
    
                     // Alarms:
        			alarm0 = 60 + irandom(30);
        			alarm1 = -1;
        		}
        	break;

            case "Palanking":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // for sani's bosshudredux
        	        boss = 1;
        	        bossname = "PALANKING";
        	        col = c_red;

        	        /// Visual:
        	            spr_bott = global.sprPalankingBott;
        	            spr_lagh = global.sprPalankingLagh;
        	            spr_call = global.sprPalankingCall;
            	        spr_idle = global.sprPalankingIdle;
            			spr_walk = global.sprPalankingWalk;
            			spr_hurt = global.sprPalankingHurt;
            			spr_dead = global.sprPalankingDead;
            			spr_foam = global.sprPalankingFoam;
        			    spr_shadow_hold = shd64B; // Actually a good use for this shadow hell yeah
        			    spr_shadow = mskNone;
                        spr_shadow_y = 24;
            			hitid = [spr_idle, _name];
            			sprite_index = spr_idle;
        			    depth = -3;

            			 // Fire:
            			spr_sfir = global.sprPalankingIdle;
            			spr_fire = global.sprPalankingIdle;
            			spr_efir = global.sprPalankingIdle;

                     // Sound:
            		snd_hurt = sndOasisBossHurt;
            		snd_dead = sndOasisBossDead;

        			 // Vars:
            		mask_index = mskNone;
            		mask_hold = global.mskPalanking;
        			maxhealth = 350;
        			raddrop = 100;
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
        			intro = false;
        			intro_pan = 0;
                    seal = ds_list_create();
                    seal_pos = [[-28, 28], [32, 28], [-34, 16], [22, 16]];
        	        z = 0;
        	        zspeed = 0;
        	        zfric = 1;
        	        zgoal = 0;

        			 // Alarms:
        			alarm0 = 20;
        			//alarm1 = 60 + irandom(40);
        			//alarm2 = 30 + irandom(10);
                }
                break;
    
            case "Palm":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = global.sprPalmIdle;
                    spr_hurt = global.sprPalmHurt;
                    spr_dead = global.sprPalmDead;
                    spr_shadow = -1;
                    depth = -2 - (y / 20000);
    
                     // Sound:
                    snd_hurt = sndHitRock;
                    snd_dead = sndHitPlant;
    
                     // Vars:
                    mask_index = mskStreetLight;
                    my_health = 40;
                    size = 1;
                    my_enemy = noone;
                    my_enemy_mask = mskNone;

                    if(random(10) < 1) my_enemy = obj_create(x, y, "Diver");
                }
                break;
    
        	case "Pelican":
        	    o = instance_create(_x, _y, CustomEnemy);
        		with(o) {
                     // Visual:
        			spr_idle = global.sprPelicanIdle;
        			spr_walk = global.sprPelicanWalk;
        			spr_hurt = global.sprPelicanHurt;
        			spr_dead = global.sprPelicanDead;
        			spr_weap = global.sprPelicanHammer;
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
        			my_health = maxhealth;
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
        			alarm0 = 30 + irandom(30);
        		}
            	break;

            case "Seal":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
                    spr_spwn = sprRavenLand;
                    spr_idle = sprRavenIdle;
                    spr_walk = sprRavenWalk;
                    spr_hurt = sprRavenHurt;
                    spr_dead = sprRavenDead;
                    spr_weap = mskNone;
                    spr_shadow = shd24;
                    hitid = [spr_idle, _name];
                    sprite_index = spr_spwn;
                    depth = -2;

                     // Sound:
                    snd_hurt = sndRavenHit;
                    snd_dead = sndRavenDie;

                     // Vars:
                    mask_index = mskBandit;
                    maxhealth = 12;
                    raddrop = 2;
                    size = 1;
                    walk = 0;
                    walkspd = 0.8;
                    maxspd = 3.5;
                    type = 0;
                    hold = false;
                    creator = noone;
                    wepangle = 0;
                    gunangle = random(360);
                    direction = gunangle;
                    speed = maxspd;

                    alarm0 = 1;
                }
                break;

            case "TrafficCrab":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
                    spr_idle = global.sprCrabIdle;
                    spr_walk = global.sprCrabWalk;
                    spr_hurt = global.sprCrabHurt;
                    spr_dead = global.sprCrabDead;
                    spr_fire = global.sprCrabFire;
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
                    alarm0 = 30 + random(10);
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
            case "Hammerhead":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
        			spr_idle = global.sprHammerheadIdle;
        			spr_walk = global.sprHammerheadIdle;
        			spr_hurt = global.sprHammerheadHurt;
        			spr_dead = sprBoneFish1Dead; //global.sprHammerheadDead
        			spr_chrg = global.sprHammerheadChrg;
        			spr_shadow = shd48;
        			spr_shadow_y = 2;
        			hitid = [spr_idle, _name];
        			sprite_index = spr_idle;
        			mask_index = mskScorpion;
        			depth = -2;
    
                     // Sound:
        			snd_hurt = sndOasisHurt;
        			snd_dead = sndOasisDeath;
    
        			 // Vars:
        			maxhealth = 30;
        			my_health = maxhealth;
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
        			alarm0 = 40 + irandom(20);
        		}
                break;
        //#endregion

        //#region SEWERS
        	case "Cat":
        	    o = instance_create(_x, _y, CustomEnemy);
        		with(o){
                     // Visual:
        			spr_idle = global.sprCatIdle;
        			spr_walk = global.sprCatWalk;
        			spr_hurt = global.sprCatHurt;
        			spr_dead = global.sprCatDead;
        			spr_weap = sprToxicThrower;
        			spr_shadow = shd24;
        			hitid = [spr_idle, _name];
        			sprite_index = spr_idle;
        			mask_index = mskBandit;
        			depth = -2;
    
                     // Sound:
        			snd_hurt = sndScorpionHit;
        			snd_dead = sndSalamanderDead;
    
        			 // Vars:
        			maxhealth = 18;
        			my_health = maxhealth;
        			raddrop = 6;
        			size = 1;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 3;
        			gunangle = random(360);
        			direction = gunangle;
        			ammo = 0;
    
        			 // Alarms:
        			alarm0 = 40 + irandom(20);
        		}
        	break;
        //#endregion

        //#region CRYSTAL CAVES
        	case "Mortar":
        	    o = instance_create(_x, _y, CustomEnemy);
        	    with(o) {
                     // Visual:
        	        spr_idle = global.sprMortarIdle;
        			spr_walk = global.sprMortarWalk;
        			spr_fire = global.sprMortarFire;
        			spr_hurt = global.sprMortarHurt;
        			spr_dead = global.sprMortarDead;
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
        			size = 2;
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
        	        sprite_index = global.sprMortarPlasma;
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
    	//#endregion

    	default:
    		return ["BigDecal", "Bone", "BoneSpawner", "BubbleBomb", "BubbleExplosion", "CoastBossBecome", "CoastBoss", "Harpoon", "NetNade",
    		        "BloomingCactus", "CoastBigDecal", "CoastDecal", "Diver", "DiverHarpoon", "Gull", "Palanking", "Palm", "Pelican", "Seal", "TrafficCrab", "TrafficCrabVenom",
    		        "Hammerhead",
    		        "Cat",
    		        "Mortar", "MortarPlasma", "NewCocoon"
    		        ];
    }

     /// Auto Assign Name + Scripts:
    var _scrt = ["step", "begin_step", "end_step", "draw", "destroy", "hurt", "death", "hit", "wall", "anim", "grenade", "projectile", "alrm0", "alrm1", "alrm2", "alrm3", "alrm4", "alrm5", "alrm6", "alrm7", "alrm8", "alrm9", "alrm10", "alrm11"];
    with(o){
        if("name" not in self) name = string(obj_name);

         // Scripts:
        for(var i = 0; i < array_length(_scrt); i++){
            var v = "on_" + _scrt[i];
            if(v not in self || is_undefined(variable_instance_get(id, v))){
                var s = name + "_" + _scrt[i];
                if(mod_script_exists("mod", mod_current, s)){
                    variable_instance_set(id, v, ["mod", mod_current, s]);
                }
    
                 // Exceptions:
                else switch(v){
                    case "on_hurt":
                        on_hurt = enemyHurt; break;
                    case "on_death":
                        on_death = scrDefaultDrop; break;
                }
            }
        }
    }

    return o;

#define BigDecal_step
    if(place_meeting(x, y, FloorExplo)){
    	instance_destroy();
    	exit;
    }
    if(place_meeting(x, y, Floor) || place_meeting(x, y, Bones)){
        instance_delete(id);
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
    else if(speed <= 0){
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
    if(projectile_canhit(other)){
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

        projectile_hit_push(other, damage, speed * force);

         // Bounce Off Enemy:
        direction = point_direction(other.x, other.y, x, y);
        speed /= 2;
        rotspeed *= -1;

         // Sound:
        sound_play_pitchvol(sndBloodGamble, 1.2 + random(0.2), 0.8);
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
    with(instance_create(x, y, WepPickup)){
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

        with(instances_named(object_index, name)) instance_destroy();
        instance_destroy();
    }


#define BubbleBomb_step
     // Float Up:
    z_engine();
    image_angle += (sin(current_frame/8) * 10) * current_time_scale;
    depth = min(-2, -z);

     // Collision:
    if(place_meeting(x, y, Player)) with(Player){
        if(place_meeting(x, y, other)) with(other){
            motion_add(point_direction(other.x, other.y, x, y), 1.5);
        }
    }
    if(place_meeting(x, y, object_index)) with(instances_named(object_index, name)){
        if(place_meeting(x, y, other)) with(other){
            motion_add(point_direction(other.x, other.y, x, y), 0.5);
        }
    }

     // Baseball:
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

    enemyAlarms(1);

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

#define BubbleBomb_hit
    // nada

#define BubbleBomb_wall
    if(speed > 0){
        sound_play(sndBouncerBounce);
        move_bounce_solid(false);
        speed *= 0.5;
    }

#define BubbleBomb_alrm0
    with(my_projectile) instance_destroy();

     // Explode:
    with(obj_create(x, y, "BubbleExplosion")){
        team = ((other.team == 2) ? -1 : other.team); // Popo nade logic
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


#define CoastBossBecome_step
     // Animate:
    image_index = part;
    if(nexthurt > current_frame + 3) sprite_index = spr_hurt;
    else if(sprite_index == spr_hurt) sprite_index = spr_idle;

     // Skeleton Rebuilt:
    if(part >= sprite_get_number(spr_idle) - 1){
        with(obj_create(x - (image_xscale * 8), y - 6, "CoastBoss")){
            x = xstart;
            y = ystart;
            right = other.image_xscale;
        }
        with(Portal) instance_destroy();
        with(WantBoss) instance_destroy();
        with(BanditBoss) my_health = 0;
        instance_delete(id);
    }

#define CoastBossBecome_death
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
    else if(image_index > image_number - 1){
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
                exit; }

            if(sprite_index = spr_dive) {
                sprite_index = spr_idle;

                 // Start Swimming:
                swim = true;
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
    if(swim){
        speed += 0.8 * current_time_scale;

         // Follow Player:
        direction += (angle_difference(point_direction(x, y, swimx, swimy), direction) / 10) * current_time_scale;

         // Turn Fins:
        swim_ang_frnt += (angle_difference(direction, swim_ang_frnt) / 3) * current_time_scale;
        swim_ang_back += (angle_difference(swim_ang_frnt, swim_ang_back) / 10) * current_time_scale;

         // Break Walls:
        if(place_meeting(x + hspeed, y + vspeed, Wall)){
            speed /= 2;

             // Effects:
            var w = instance_nearest(x, y, Wall);
            with(instance_create(w.x, w.y, MeleeHitWall)){
                motion_add(point_direction(x, y, other.x, other.y), 1);
                image_angle = direction + 180;
            }
            sound_play_pitchvol(sndHammerHeadProc, 1.4 + random(0.2), 0.5);

             // Break Wall:
            with(w){
                instance_create(x, y, FloorExplo);
                instance_destroy();
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
            if(random(3) < 1) view_shake_at(_cx, _cy, 4);
        }
    }

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

    if(swim){
        if(h) d3d_set_fog(1, c_white, 0, 0);

        var _cx = x,
            _cy = bbox_bottom;
    
        for(var a = 0; a < 4; a++){
            var _x = _cx,
                _y = _cy,
                _xscale = image_xscale,
                _yscale = image_yscale,
                _blend = image_blend,
                _alpha = image_alpha,
                _swimSpd = (current_frame / 3),
                _spr = [global.sprBigFishSwimFrnt,      global.sprBigFishSwimBack           ],
                _ang = [swim_ang_frnt,                  swim_ang_back                       ],
                _dis = [10 * _xscale,                   10 * _xscale                        ], // Offset Distance
                _dir = [_ang[0] + (5 * sin(_swimSpd)),  _ang[1] + 180 + (5 * sin(_swimSpd))], // Offset Direction
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
    alarm0 = 60 + irandom(20);
    target = instance_nearest(x, y, Player);
    if(target_in_distance(0, 160)) {
        var _targetDir = point_direction(x, y, target.x, target.y);
    
         // Bubble Attack:
        if(random(3) < 2) {
            image_index = 0;
            sprite_index = spr_chrg;
            sound_play_pitch(sndOasisBossFire, 1 + orandom(0.2));

            gunangle = _targetDir;
            ammo = 4 * (GameCont.loops + 2);

            alarm1 = 3;
            alarm0 = -1;
        }
    
         // Dive:
        else if(random(4) < 1) alarm2 = 6;
    
         // Move Towards Target:
        else{
            scrWalk(30 + random(10), _targetDir + orandom(15));
            alarm0 = walk + random(10);
        }

        scrRight(_targetDir);
    }

     // Dive:
    else if(instance_exists(target)) alarm2 = 6;

     // Passive Movement:
    else{
        alarm0 = 40 + irandom(20);
        scrWalk(20, random(360));
    }

#define CoastBoss_alrm1
     // Fire Bubble Bombs:
    repeat(irandom_range(1, 2)){
        if(ammo > 0){
            alarm1 = 2;

             // Blammo:
            sound_play(sndOasisShoot);
            scrEnemyShoot("BubbleBomb", gunangle + (sin(shot_wave / 4) * 24), 8 + random(4));
            shot_wave += alarm1;
            walk++;

             // End:
            if(--ammo <= 0){
                alarm0 = 40;
            }
        }
    }

#define CoastBoss_alrm2
    target = instance_nearest(x, y, Player);

     // Dive:
    var _notSwimming = (sprite_index != spr_dive && !swim);
    if(_notSwimming || (instance_exists(target) && (point_distance(x, y, target.x, target.y) > 80 || random(2) < 1))){
        if(_notSwimming){
            sprite_index = spr_dive;
            image_index = 0;
            spr_shadow = mskNone;
            sound_play(sndOasisBossMelee);
        }

        swimx = target.x + orandom(48);
        swimy = target.y + orandom(48);

        alarm2 = 15;
        alarm0 = alarm2 + 10;
    }

     // Un-Dive:
    else{
        swim = false;
        image_index = 0;
        sprite_index = spr_rise;
        scrRight(direction);
        speed = 0;

         // Babbies:
        if(GameCont.loops > 0) repeat(GameCont.loops * 3){
            with(instance_create(x, y, BoneFish)) kills = 0;
        }

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

#define CoastBoss_death
     // Coast Entrance:
    instance_create(x, y, Portal);
    GameCont.area = "coast";
    GameCont.subarea = 0;
    with(enemy) my_health = 0;


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


#define NetNade_step
    if(alarm0 > 0 && alarm0 < 15) sprite_index = sprGrenadeBlink;
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


#define CoastDecal_create(_x, _y, _shell)
    with(instance_create(_x, _y, CustomHitme)){
        name = "CoastDecal";

        shell = _shell;

         // Visual:
        if(shell){
            type = 0;
            spr_idle = global.sprShellIdle;
            spr_hurt = global.sprShellHurt;
            spr_dead = global.sprShellDead;
            spr_bott = global.sprShellBott;
            spr_foam = global.sprShellFoam;
        }
        else{
            type = irandom(array_length(global.sprRockIdle) - 1);
            spr_idle = global.sprRockIdle[type];
            spr_hurt = global.sprRockHurt[type];
            spr_dead = global.sprRockDead[type];
            spr_bott = global.sprRockBott[type];
            spr_foam = global.sprRockFoam[type];
        }
        spr_walk = spr_idle;
        image_xscale = choose(-1, 1);
        image_speed = 0.4;
        spr_shadow = -1;
        depth = (shell ? -2 : 0) + (-y / 20000);
        friction = 3;

         // Sound:
        snd_hurt = sndHitRock;
        snd_dead = (shell ? sndHyperCrystalHurt : sndWallBreakRock);

         // Vars:
        mask_index = (shell ? mskScrapBoss : mskBandit);
        mask_floor = (shell ? mskSalamander : mskAlly);
        my_health = (shell ? 100 : 50);
        size = (shell ? 4 : 3);
        team = 0;

         // Offset:
        x += orandom(10);
        y += orandom(10);

         // Doesn't Use Coast Wading System:
        nowade = true;

        on_step = CoastDecal_step;
        on_hurt = CoastDecal_hurt;

        return id;
    }

#define CoastDecal_step
     // Animate:
    if(image_index + image_speed > image_number - 1){
        if(sprite_index != spr_dead) sprite_index = spr_idle;
        else{
            image_speed = 0;
            image_index = image_number - 1;
        }
    }

     // Pushing:
    if(place_meeting(x, y, hitme)){
        with(instances_matching_lt(hitme, "size", size)){
            if(place_meeting(x, y, other)){
                motion_add(point_direction(other.x, other.y, x, y), 1);
            }
        }
        if(!shell) with(instances_matching_ge(hitme, "size", size)){
            if(place_meeting(x, y, other) && object_index != Player){
                with(other) motion_add(point_direction(other.x, other.y, x, y), 4);
            }
        }
        with(Player){
            if(place_meeting(x, y, other)){
                motion_add(point_direction(other.x, other.y, x, y), 1);
            }
        }
    }

#define CoastDecal_hurt(_hitdmg, _hitvel, _hitdir)
    nexthurt = current_frame + 6;   // I-Frames
    sound_play_hit(snd_hurt, 0.3);  // Sound

     // Hurt Sprite:
    sprite_index = spr_hurt;
    image_index = 0;

     // Splashy FX:
    repeat(1 + (_hitdmg / 5)){
        var _dis = (shell ? 24 : 8),
            _dir = _hitdir + 180 + orandom(30);

        with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Sweat)){
            speed = random(speed);
            direction = _dir;
        }
    }

     // Damage:
    if(my_health > 0){
        my_health -= _hitdmg;

         // Break:
        if(my_health <= 0){
            mask_index = mskNone;
            sprite_index = spr_dead;
            team = 2;

             // Can Stand On Corpse:
            with(instance_create(0, 0, Floor)){
                x = other.x;
                y = other.y;
                visible = 0;
                mask_index = other.mask_floor;
            }

             // Weapon Drop:
            //pickup_drop(0, 100);

             // Visual Stuff:
            depth = (shell ? 0 : 1);
            with(instances_matching(BoltStick, "target", id)) instance_destroy();

             // Water Rock Debris:
            if(!shell){
                var _ang = random(360);
                for(var a = _ang; a < _ang + 360; a += 360 / 3){
                    with(instance_create(x, y, MeleeHitWall)) image_angle = a + orandom(10);
                }
                repeat(choose(2, 3)){
                    with(instance_create(x + orandom(2), y + orandom(2), Debris)){
                        motion_set(_hitdir + orandom(10), (speed + _hitvel) / 2);
                    }
                }
            }

             // Break Sound:
            sound_play_pitch(snd_dead, 1 + random(0.2));
        }
    }


#define Diver_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);

#define Diver_alrm0
    alarm0 = 60 + irandom(30);
    target = instance_nearest(x, y, Player);
    if(target_is_visible()) {
        var _targetDir = point_direction(x, y, target.x, target.y);

    	if(target_in_distance(60, 320)){
    	     // Shoot Harpoon:
    		if(spr_weap = global.sprHarpoonGun && random(4) < 1){
    		     // Harpoon/Bolt:
    			gunangle = _targetDir + orandom(10);
    			scrEnemyShoot("DiverHarpoon", gunangle, 12);

                wkick = 8;
                sound_play(sndCrossbow);
    			spr_weap = global.sprHarpoonGunEmpty;
    		}

             // Reload Harpoon:
    		else if(spr_weap = global.sprHarpoonGunEmpty){
    			sound_play_hit(sndCrossReload,0);
    			spr_weap = global.sprHarpoonGun;
    			wkick = 2;
    		}

    		alarm0 = 30 + irandom(30);
    	}

         // Move Away From Target:
    	else{
    		alarm0 = 45 + irandom(30);
    		direction = _targetDir + 180 + orandom(30);
    		gunangle = direction + orandom(15);
    		walk = 15 + irandom(15);
    	}

    	 // Facing:
    	scrRight(_targetDir);
    }

     // Passive Movement:
    else{
    	direction = random(360);
    	gunangle = direction + orandom(15);
    	walk = 30;
    	scrRight(direction);
    }

#define Diver_draw
    if(gunangle <= 180) draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
    draw_self_enemy();
    if(gunangle > 180) draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);


#define DiverHarpoon_end_step
     // Trail:
    var _x1 = x,
        _y1 = y,
        _x2 = xprevious,
        _y2 = yprevious;

    with(instance_create(x, y, BoltTrail)){
        image_xscale = point_distance(_x1, _y1, _x2, _y2);
        image_angle = point_direction(_x1, _y1, _x2, _y2);
    }

     // Destroy Timer:
    enemyAlarms(1);

#define DiverHarpoon_alrm0
    instance_destroy();

#define DiverHarpoon_hit
    var _inst = other;
    if(speed > 0 && projectile_canhit(_inst) && ("my_enemy" not in other || other.my_enemy != creator)){
        var _hp = _inst.my_health;

         // Damage:
        projectile_hit_push(_inst, damage, force);

         // No Piercing:
        if(_hp >= 10){
             // Stick in Player:
            with(instance_create(x, y, BoltStick)){
                image_angle = other.image_angle;
                target = _inst;
            }
            instance_destroy();
        }
    }

#define DiverHarpoon_wall
     // Stick in Wall:
    if(speed > 0){
        speed = 0;
        sound_play_hit(sndBoltHitWall,.1);
        move_contact_solid(direction, 16);
        instance_create(x, y, Dust);
        alarm0 = 30;
    }

#define DiverHarpoon_anim
    image_speed = 0;
    image_index = image_number - 1;


#define Gull_step
    enemyAlarms(2);
    enemySprites();
    enemyWalk(walkspd, maxspd);

#define Gull_alrm0
    alarm0 = 40 + irandom(30);
    target = instance_nearest(x, y, Player);
    if(target_is_visible()){
        var _targetDir = point_direction(x, y, target.x, target.y);

         // Target Nearby:
    	if(target_in_distance(10, 480)){
    	     // Attack:
    		if(target_in_distance(10, 60)){
    			alarm1 = 8;
    			instance_create(x, y, AssassinNotice);
                sound_play_pitch(sndRavenScreech, 1.15 + random(0.1));
    		}

             // Move Toward Target:
    		else{
    		    alarm0 = 40 + irandom(10);
        		walk = 20 + irandom(15);
        		direction = _targetDir + orandom(20);
        		gunangle = direction + orandom(15);
    		}
    	}

         // Move Toward Target:
    	else{
    		alarm0 = 30 + irandom(10);
    		walk = 10 + irandom(20);
    		direction = _targetDir + orandom(20);
    		gunangle = direction + orandom(15);
    	}

    	 // Facing:
    	scrRight(direction);
    }

     // Passive Movement:
    else{
    	walk = 30;
    	direction = random(360);
    	gunangle = direction + orandom(15);
    	scrRight(direction);
    }

#define Gull_alrm1
     // Slash:
    gunangle = point_direction(x, y, target.x, target.y) + orandom(10);
    with(scrEnemyShoot(EnemySlash, gunangle, 4)) damage = 2;

     // Visual/Sound Related:
    wkick = -3;
    wepangle = -wepangle;
    motion_add(gunangle, 4);
    sound_play(sndChickenSword);
    scrRight(gunangle);

#define Gull_draw
    if(gunangle <= 180) draw_weapon(spr_weap, x, y, gunangle, wepangle, wkick, 1, image_blend, image_alpha);
    draw_self_enemy();
    if(gunangle > 180) draw_weapon(spr_weap, x, y, gunangle, wepangle, wkick, 1, image_blend, image_alpha);


#define Palanking_step
    enemyAlarms(3);
    if(z <= 0) walk = 0;
    enemyWalk(walkspd, maxspd);

     // Seals:
    var _sealNum = ds_list_size(seal),
        _holding = 0,
        _holdx = [-34,  32],
        _holdy = [ 16,  28],
        _holdw = [  6, -10],
        _holdh = [ 12, -12],
        _side = 0;

    if(right < 0){
        _holdx = [-_holdx[1] - _holdw[1], -_holdx[0] - _holdw[0]];
        _holdw = [ _holdw[1], _holdw[0]];
    }

    for(var i = 0; i < _sealNum; i++){
        var _seal = seal[| i];
        if(instance_exists(_seal)){
            var n = max((_sealNum / 2) - 1, 1);
            if(_side) n = floor(i / 2) / floor(n);
            else n = ceil(i / 2) / ceil(n);

            var _x = _holdx[_side] + (n * _holdw[_side]),
                _y = _holdy[_side] + (n * _holdh[_side]);

            with(_seal){
                if(hold){
                    _holding++;

                    if("hold_x" not in self) hold_x = _x;
                    if("hold_y" not in self) hold_y = _y;

                    x = other.x + hold_x;
                    y = other.y + hold_y;
                    hspeed = other.hspeed;
                    vspeed = other.vspeed;
                    depth = other.depth + (0.1 * dsin(point_direction(0, 24, hold_x, hold_y)));

                    if(_sealNum > 1){
                        if(hold_x != _x){
                            hspeed = random(clamp(_x - hold_x, -maxspd, maxspd));
                            hold_x += hspeed;
                        }
                        if(hold_y != _y){
                            vspeed = random(clamp(_y - hold_y, -maxspd, maxspd));
                            hold_y += vspeed;
                        }
                    }
                }
                else{
                    hold_x = x - other.x;
                    hold_y = y - other.y;
                    motion_add(point_direction(x, y, other.x + _x, other.y + _y), walkspd);
                    if(distance_to_point(other.x + _x, other.y + _y) < 32) hold = true;
                }
            }

            _side = !_side;
        }
        else{
            ds_list_remove(seal, _seal);
            _sealNum--;
        }
    }

     // Seals Holding Up:
    if(intro){
        if(_holding <= 1){
            if(zgoal != 0){
                zgoal = 0;
                zspeed = 6;
            }
        }
        else if(zgoal == 0) zgoal = 12;
    }

     // Intro Stuff:
    if(!intro){
        x = xstart;
        y = ystart;

         // Begin Intro:
        if(instance_number(enemy) - instance_number(Van) > 1 + _sealNum){
            alarm0 = 30;
            intro_pan = 0;
        }
    }

     // Push to Shore:
    else if(instance_exists(Floor)){
        if(distance_to_object(Floor) >= 80 && zspeed == 0){
            var f = instance_nearest(x - 16, y - 16, Floor);
            motion_add(point_direction(x, y, f.x, f.y), 1);
        }
    }

     // Pan Intro Camera:
    for(var i = 0; i < maxp; i++){
        if(intro_pan) view_object[i] = id;
            /*for(var i = 0; i < maxp; i++) with(player_find(i)){
                var g = gunangle;
                gunangle = point_direction(x, y, other.x, other.y);
                weapon_post(wkick, (point_distance(x, y, other.x, other.y) / 2) - 15, 0);
                gunangle = g;
            }*/
            //intro_pan = clamp(intro_pan + ((intro_pan / 2) * current_time_scale), 0, 1);
        else if(view_object[i] == id){
            view_object[i] = noone;
        }
    }

     // Z-Axis:
    z += zspeed * current_time_scale;
    if(z <= zgoal){
        if(z < zgoal && zspeed == 0){
            if(zgoal <= 0) z = zgoal;
            else zspeed = (zgoal - z) / 2;
        }
        if(zspeed <= 0){
             // Held in Air:
            if(zgoal > 0){
                z = zgoal + zspeed;
                zspeed *= 0.8;
            }

             // Ground Landing:
            else if(zspeed < 0){
                 // Ground Smash:
                if(zspeed < -5){
                    //&& place_meeting(x, y, hitme)) with(hitme){
                    /*if(place_meeting(x, y, other)) with(other){
                        projectile_hit(other, meleedamage, abs(zspeed), point_direction(other.x, other.y, x, y));
                        sound_play_hit_big(sndBigBanditMeleeHit, 0.3);
                    }*/
                    
                    alarm2 = 1;
                    projectile_hit_raw(id, 10, 1);
                    sound_play_hit_big(sndBigBanditMeleeHit, 0.3);
                    /*with(Floor) if(place_meeting(x, y, other)){
                         // Effects:
                        repeat(irandom_range(3, 6)) instance_create(x + random(sprite_width), y + random(sprite_height), Debris);

                         // Floor Explo:
                        /*for(var _fx = 0; _fx < sprite_get_width(mask_index); _fx += 16){
                            for(var _fy = 0; _fy < sprite_get_height(mask_index); _fy += 16){
                                var _make = false;
                                for(var a = 0; a < 360; a += 90){
                                    var _x = x + lengthdir_x(32, a),
                                        _y = y + lengthdir_y(32, a);

                                    if(position_meeting(_x, _y, Floor)){
                                        if(position_meeting(_x, _y, id)){
                                            _make = true;
                                            break;
                                        }
                                    }
                                }
                                if(_make && random(2) < 1){
                                    with(instance_create(0, 0, Floor)){
                                        x = other.x + _fx;
                                        y = other.y + _fy;
                                        sprite_index = sprFloor1Explo;
                                        mask_index = mskNone;
                                        image_index = irandom(image_number - 1);
                                    }
                                }
                            }
                        }
                        instance_destroy();
                    }*/
                    //mod_variable_set("area", "coast", "surfFloorReset", true);
                    /*with(instance_nearest(x - 16, y - 16, Floor)){
                        for(var a = 0; a < 360; a += 90){
                            var _x = x + lengthdir_x(32, a),
                                _y = y + lengthdir_y(32, a);

                            if(position_meeting(_x, _y, Floor)){
                                with(instance_nearest(_x, _y, Floor)){
                                    instance_destroy();
                                }
                            }
                        }
                        instance_destroy();
                    }*/

                    /*for(var i = direction; i < direction + 360; i += (360 / 5)){
                        with(scrEnemyShootExt(x, y + 20, EnemySlash, i, 4)){
                        }
                    }*/
                }

                 // Effects:
                for(var a = 0; a < 360; a += (360 / 30)){
                    if(random(5) < 1){
                        with(instance_create(x + orandom(8), y + orandom(8) + 32, Debris)){
                            motion_set(a, random_range(0.5, 0.8) * abs(other.zspeed));
                        }
                    }
                    else with(instance_create(x, y + 32, Dust)){
                        motion_add(a, random(abs(other.zspeed / 2)) + (2 * abs(dcos(a))));
                    }
                }

                zspeed *= -0.2;
            }

            if(abs(zspeed) < zfric){
                zspeed = 0;
                z = zgoal;
            }
        }
    }
    else zspeed -= zfric * current_time_scale;

     // Animate:
    if(sprite_index != spr_hurt && sprite_index != spr_call && sprite_index != spr_lagh){
        if(speed <= 0) sprite_index = spr_idle;
        else sprite_index = spr_walk;
    }
    else if(image_index > image_number - 1){
        sprite_index = spr_idle;
    }

     // Hitbox/Shadow:
    if(z <= 4){
        mask_index = mask_hold;
        if(spr_shadow != mskNone){
            spr_shadow_hold = spr_shadow;
            spr_shadow = mskNone;
        }
    }
    else{
        spr_shadow = spr_shadow_hold;
        if(mask_index != mskNone){
            mask_hold = mask_index;
            mask_index = mskNone
        }
    }

#define Palanking_alrm0
    if(intro_pan == 0){
        alarm0 = 60;

         // Pan Camera:
        intro_pan = true;

         // Call for Seals:
        sprite_index = spr_call;
        image_index = 0;
    }
    else{
        if(!intro){
            var _sealNum = ds_list_size(seal);
            if(_sealNum < 4){
                 // Seal Plop:
                //repeat(4) instance_create(other.x + x, other.y + y, Sweat);
                sound_play_pitch(choose(sndOasisHurt, sndOasisMelee, sndOasisShoot, sndOasisChest, sndOasisCrabAttack), 0.8 + random(0.4));
        
                 // Spawn Seals:
                var _sealPos = seal_pos,
                    _seal = obj_create(x, y, "Seal");

                ds_list_add(seal, _seal);
                with(_seal){
                    hold = true;
                    creator = other;
                }

                if(++_sealNum >= 4) alarm0 = 16;
                else alarm0 = 8;
            }

             // Lift Palanking:
            else{
                intro = true;
                zgoal = 12;
                alarm0 = 30;
            }
        }
        else{
             // Walk Towards Player:
            if(walk == 0 && instance_exists(Player)){
                target = instance_nearest(x, y, Player);
                scrWalk(90, point_direction(x, y, target.x, target.y));
                alarm0 = 10;
            }
    
             // End:
            else{
                intro_pan = false;
                alarm1 = 60 + irandom(40);
                //alarm2 = 30 + irandom(10);
            }
        }
    }

#define Palanking_alrm1
    alarm1 = 40 + random(20);

    target = instance_nearest(x, y, Player);

     // Bubble Bomb Burp:
    if(ammo > 0){
        alarm1 = 4;

        scrEnemyShoot("BubbleBomb", gunangle + orandom(10), 8 + random(4));
        sound_play_pitchvol(sndExplosionS, 3, 0.4);
        motion_add(gunangle + 180, 4);

        if(--ammo <= 0) alarm1 = 60 + random(20);
    }
    
     // Normal AI:
    else if(target_is_visible()){
        var _targetDir = point_direction(x, y, target.x, target.y);

        scrWalk(60, _targetDir + orandom(30));

        var _sealNum = ds_list_size(seal);
        if(_sealNum < 4){
            var _x = x,
                _y = y,
                _dis = 42 + random(24),
                _dir = random(360);

            if(instance_exists(Floor)){
                with(instance_create(_x, _y, GameObject)){
                    while(distance_to_object(Floor) < _dis + 8){
                        x += lengthdir_x(12, _dir);
                        y += lengthdir_y(12, _dir);
                    }
                    _x = x;
                    _y = y;
                    instance_destroy();
                }
            }
            repeat(4 - _sealNum){
                var d = random(_dis);
                var _seal = obj_create(_x + lengthdir_x(d, _dir), _y + lengthdir_y(d, _dir), "Seal");
                ds_list_add(seal, _seal);
                with(_seal){
                    type = irandom(1);
                    creator = other;
                    kills = 0;
                }
            }
        }

         // Begin Bubble Bomb Attack:
        if(target_in_distance(0, 160) and random(4) < 1) {
            alarm1 = 5;
            ammo = 10;
            gunangle = _targetDir;
            sound_play_pitchvol(sndVenuz, 0.4, 0.8);
        }

         // Wave Slash:
        else if(target_in_distance(80, 900) and random(2) < 1) {
            alarm1 = 60 + random(20);

            gunangle = _targetDir;
            scrWalk(20, gunangle);
            with(scrEnemyShoot(EnemySlash, gunangle + 20, 4)){
                sprite_index = sprHeavySlash;
                image_speed = 0.2;
            }
            with(scrEnemyShoot(EnemySlash, gunangle - 20, 4)){
                sprite_index = sprHeavySlash;
                image_speed = 0.2;
            }
        }
    }

#define Palanking_alrm2
    var m = 5;
    if(ground_smash++ < m){
        alarm2 = 2;

        sound_play_pitch(sndWallBreakBrick, 0.6 + random(0.2));

        var _dis = (ground_smash * 16);
        for(var a = 0; a < 360; a += (360 / 16)){
            with(instance_create(x + lengthdir_x(_dis, a) + orandom(8), y + 20 + lengthdir_y(_dis, a) + orandom(8), Dust)){
                motion_add(a + orandom(90), 2);
            }
        }
    }
    else ground_smash = 0;

#define Palanking_hurt(_hitdmg, _hitvel, _hitdir)
    nexthurt = current_frame + 6;	// I-Frames
    if(intro){
        my_health -= _hitdmg;			// Damage
        motion_add(_hitdir, _hitvel);	// Knockback
        sound_play_hit(snd_hurt, 0.3);	// Sound

         // Hurt Sprite:
        sprite_index = spr_hurt;
        image_index = 0;
    }

     // Laugh:
    else if(sprite_index == spr_idle){
        sprite_index = spr_lagh;
        image_index = 0;

         // Effects:
        sound_play_hit(sndHitWall, 0.3);
        if(instance_exists(other)){
            with(instance_create(other.x, other.y, Dust)){
                coast_water = 1;
                if(y > other.y + 12) depth = other.depth - 1;
            }
            if(random(2) < 1) with(other){
                sound_play_hit(sndHitRock, 0.3);
                with(instance_create(x, y, Debris)){
                    motion_set(_hitdir + 180 + orandom(other.force * 4), 2 + random(other.force / 2));
                }
            }
        }
    }

#define Palanking_draw
     // Palanquin Bottom:
    if(z > 4 || place_meeting(x, y, Floor)){
        var h = (nexthurt > current_frame + 3 && intro);
        if(h) d3d_set_fog(1, c_white, 0, 0);
        draw_sprite_ext(spr_bott, image_index, x, y - z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
        if(h) d3d_set_fog(0, 0, 0, 0);
    }

     // Self:
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
    //draw_self_enemy();


#define Palm_step
    with(my_enemy){
        x = other.x;
        y = other.y - 36;
        walk = 0;
        speed = 0;
        sprite_index = spr_idle;
        if(mask_index != mskNone){
            other.my_enemy_mask = mask_index;
            mask_index = mskNone;
        }
    }

#define Palm_death
    with(my_enemy){
        y += 8;
        vspeed += 10;
        mask_index = other.my_enemy_mask;
    }

     // Leaves:
    repeat(15) with(instance_create(x + orandom(15), y - 30 + orandom(10), Feather)){
        sprite_index = sprLeaf;
        image_yscale = random_range(1, 3);
        motion_add(point_direction(other.x, other.y, x, y), 1 + random(1));
        vspeed += 2;
    }


#define Pelican_step
    enemyAlarms(2);
    enemySprites();
    enemyWalk(walkspd, maxspd);

     // Dash:
    if(dash > 0){
        motion_add(direction, dash * dash_factor);
        dash -= current_time_scale;

         // Dusty:
        instance_create(x + orandom(3), y + random(6), Dust);
        with(instance_create(x + orandom(3), y + random(6), Dust)){
            motion_add(other.direction + orandom(45), (4 + random(1)) * other.dash_factor);
        }
    }

#define Pelican_alrm0
    alarm0 = 40 + random(20); // 1-2 Seconds

     // Flash (About to attack):
    if(alarm1 >= 0){
        var _dis = 18,
            _ang = gunangle + wepangle;

        with(instance_create(x + lengthdir_x(_dis, _ang), y + lengthdir_y(_dis, _ang), ThrowHit)){
            image_speed = 0.5;
            depth = -3;
        }
    }

     // Aggroed:
    target = instance_nearest(x, y, Player);
    if(target_is_visible() && target_in_distance(0, 320)){
        var _targetDir = point_direction(x, y, target.x, target.y);

         // Attack:
        if(((target_in_distance(0, 128) && random(3) < 2) || random(my_health) < 1) && alarm1 < 0){
            alarm1 = chrg_time;
            alarm0 = alarm1 - 10;

             // Move away a tiny bit:
            scrWalk(5, _targetDir + 180 + orandom(10));

             // Warn:
            instance_create(x, y, AssassinNotice).depth = -3;
            sound_play_pitch(sndRavenHit, 0.5 + random(0.1));
        }

         // Move Toward Target:
        else scrWalk(20 + random(10), _targetDir + orandom(10));

         // Aim Towards Target:
        gunangle = _targetDir;
        scrRight(gunangle);
    }

     // Passive Movement:
    else{
        alarm0 = 90 + random(30); // 3-4 Seconds
        scrWalk(10 + random(5), random(360));
    }

#define Pelican_alrm1
    alarm0 = 40 + random(20);

     // Dash:
    dash = 12;
    motion_set(gunangle, maxspd);

     // Heavy Slash:
    with(scrEnemyShoot(EnemySlash, gunangle, ((dash - 2) * dash_factor))){
        sprite_index = sprHeavySlash;
        friction = 0.4;
        damage = 10;
    }

     // Misc. Visual/Sound:
    wkick = -10;
    wepangle = -wepangle;
    view_shake_at(x, y, 20); // Mmm that's heavy
    sound_play(sndEnergyHammer);
    sound_play_pitch(sndHammer, 0.75);
    sound_play_pitch(sndRavenScreech, 0.5 + random(0.1));

#define Pelican_draw
    var _charge = ((alarm1 > 0) ? alarm1 : 0),
        _angOff = sign(wepangle) * (60 * (_charge / chrg_time));

    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, wepangle - _angOff, wkick, 1, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();

#define Pelican_death
    pickup_drop(80, 0);
    pickup_drop(60, 5);

     // Hmm:
    if(place_meeting(x, y, WepPickup)){
        with(instance_nearest(x, y, WepPickup)){
            if(wep == wep_sledgehammer){
                sprite_index = other.spr_weap;

                var _dis = 16,
                    _dir = rotation;

                instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), ThrowHit).image_speed = 0.35;
            }
        }
    }


#define Seal_step
    enemyWalk((hold ? 0 : walkspd), maxspd);
    enemyAlarms(2);

     // Trident:
    switch(type){
        case seal_trident:
            spr_weap = global.sprTrident;
            
             // About to Stab:
            if(alarm1 > 0) wkick += 2 * current_time_scale;
            break;

        default:
            spr_weap = mskNone;
    }

     // Animate:
    if(sprite_index != spr_spwn){
        enemySprites();
    }
    else if(image_index > image_number - 1) sprite_index = spr_idle;

#macro seal_none 0
#macro seal_trident 1

#define Seal_alrm0
    alarm0 = 30 + random(30);

    trident_dist = 0;

    target = instance_nearest(x, y, Player);
    if(target_is_visible()){
        var _targetDir = point_direction(x, y, target.x, target.y);

         // 
        switch(type){
            case seal_trident:
                alarm0 = 10 + random(15);
        
                 // Too Close:
                if(target_in_distance(0, 30)){
                    scrWalk(10, _targetDir + 180 + orandom(60));
                }

                else{
                    if(random(5) < 4){
                         // Attack:
                        if(target_in_distance(0, 60)){
                            alarm0 = 30;
                            alarm1 = 10;
                            trident_dist = point_distance(x, y, target.x, target.y) - 24;
                        }

                         // Too Far:
                        else scrWalk(10, _targetDir + orandom(20));
                    }

                     // Side Step:
                    else scrWalk(15, _targetDir + choose(-80, 80));
                }
                break;
        }

         // Face Target:
        gunangle = _targetDir;
        scrRight(gunangle);
    }

     // Passive Movement:
    else{
        scrWalk(5 + random(20), random(360));
        gunangle = 90 + (20 * right);
        alarm0 += walk;
    }

#define Seal_alrm1
     // Trident Stabby:
    for(var i = -4; i <= 4; i += 4){
        var _dis = 22 + trident_dist + ((i == 0) * 2),
            _dir = gunangle,
            o = (6 * right) + i,
            _x = x + lengthdir_x(_dis, _dir) + lengthdir_x(o, _dir - 90),
            _y = y + lengthdir_y(_dis, _dir) + lengthdir_y(o, _dir - 90);

        with(scrEnemyShootExt(_x, _y, Shank, _dir, 1)){
            damage = 3;
            image_angle -= i;
            image_xscale = 0.25;
            image_yscale = 0.5;
            depth = -3;
        }
    }

     // Effects:
    sound_play(sndMeleeFlip);
    sound_play(sndJackHammer);
    sound_play(sndScrewdriver);
    repeat(5) with(instance_create(x, y, Dust)){
        motion_add(other.gunangle + orandom(30), random(5));
    }

     // Forward Push:
    x += lengthdir_x(4, gunangle);
    y += lengthdir_y(4, gunangle);
    wkick = -trident_dist;

     // Walk Backwards:
    var g = gunangle;
    scrWalk(6 + random(4), gunangle + 180 + orandom(20));
    gunangle = g;
    scrRight(g);

#define Seal_draw
    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, wepangle, wkick, right, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();


#define TrafficCrab_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);

     // Attack Sprite:
    if(ammo > 0){
        sprite_index = spr_fire;
        image_index = 0;
    }

#define TrafficCrab_alrm0
     // Spray Venom:
    if(ammo > 0){
        alarm0 = 2;
        walk = 1;

        sound_play(sndOasisCrabAttack);
        sound_play_pitchvol(sndFlyFire, 2 + random(1), 0.5);

         // Venom:
        var _x = x + (right * (4 + (sweep_dir * 10))),
            _y = y + 4;

        repeat(choose(2, 3)){
            scrEnemyShootExt(_x, _y, "TrafficCrabVenom", gunangle + orandom(10), 10 + random(2));
        }
        gunangle += (sweep_dir * sweep_spd);

         // End:
        if(--ammo <= 0){
            alarm0 = 30 + random(20);
            sprite_index = spr_idle;

             // Move Towards Player:
            var _dir = (instance_exists(target) ? point_direction(x, y, target.x, target.y) : random(360));
            scrWalk(15, _dir);

             // Switch Claws:
            sweep_dir *= -1;
        }
    }

     // Normal AI:
    else{
        alarm0 = 35 + random(15);
        target = instance_nearest(x, y, Player);

        if(target_is_visible()){
            var _targetDir = point_direction(x, y, target.x, target.y);

             // Attack:
            var _max = 128;
            if(target_in_distance(0, _max)){
                scrWalk(1, _targetDir + (sweep_dir * random(90)));

                alarm0 = 1;
                ammo = 10;
                gunangle = _targetDir - (sweep_dir * (sweep_spd * (ammo / 2)));

                sound_play_pitch(sndScorpionFireStart, 0.8);
                sound_play_pitch(sndGoldScorpionFire, 1.5);
            }

             // Move Towards Player:
            else scrWalk(30, _targetDir + (random_range(20, 40) * choose(-1, 1)));

             // Facing:
            scrRight(_targetDir);
        }

         // Passive Movement:
        else scrWalk(10, random(360));
    }

#define TrafficCrab_draw
    draw_self_enemy();

#define TrafficCrab_death
    pickup_drop(10, 10);

     // Splat:
    var _ang = random(360);
    for(var a = _ang; a < _ang + 360; a += (360 / 3)){
        with(instance_create(x, y, MeleeHitWall)){
            motion_add(a, 1);
            image_angle = direction + 180;
            image_blend = make_color_rgb(174, 58, 45);//make_color_rgb(133, 249, 26);
        }
    }


#define TrafficCrabVenom_step
    if(speed <= 0) instance_destroy();

#define TrafficCrabVenom_hit
    if(projectile_canhit_melee(other)){
        projectile_hit_push(other, damage, force);
    }

#define TrafficCrabVenom_anim
    image_speed = 0;
    image_index = image_number - 1;

#define TrafficCrabVenom_destroy
    with(instance_create(x, y, BulletHit)) sprite_index = sprScorpionBulletHit;


#define Hammerhead_step
    enemyAlarms(1);
    if(sprite_index != spr_chrg) enemySprites();
    enemyWalk(walkspd, maxspd);

     // Swim in a circle:
    if(rotate != 0){
        rotate -= clamp(rotate, -1, 1) * current_time_scale;
        direction += rotate;
        if(speed > 0) scrRight(direction);
    }

     // Charge:
    if(charge > 0 || charge_wait > 0){
        direction += angle_difference(charge_dir + (sin(charge / 5) * 20), direction) / 3;
        scrRight(direction);
    }
    if(charge_wait > 0){
        charge_wait -= current_time_scale;

        x += orandom(1);
        y += orandom(1);
        x -= lengthdir_x(charge_wait / 5, charge_dir);
        y -= lengthdir_y(charge_wait / 5, charge_dir);
        sprite_index = choose(spr_hurt, spr_chrg);

         // Start Charge:
        if(charge_wait <= 0){
            sound_play_pitch(sndRatkingCharge, 0.4 + random(0.2));
            view_shake_at(x, y, 15);
        }
    }
    else if(charge > 0){
        charge -= current_time_scale;

        if(sprite_index != spr_hurt) sprite_index = spr_chrg;

         // Fast Movement:
        motion_add(direction, 3);
        scrRight(direction);

         // Break Walls:
        if(place_meeting(x + hspeed, y + vspeed, Wall)){
            with(Wall) if(place_meeting(x - other.hspeed, y - other.vspeed, other)){
                 // Effects:
                if(random(2) < 1) with(instance_create(x + 8, y + 8, Hammerhead)){
                    motion_add(random(360), 1);
                }
                instance_create(x, y, Smoke);
                sound_play_pitchvol(sndHammerHeadProc, 0.75, 0.5);

                instance_create(x, y, FloorExplo);
                instance_destroy();
            }
        }

         // Effects:
        if(current_frame_active){
            with(instance_create(x + orandom(8), y + 8, Dust)){
                motion_add(random(360), 1)
            }
        }
        if !(charge mod 5) view_shake_at(x, y, 10);

         // Charge End:
        if(charge <= 0){
            sprite_index = spr_idle;
            sound_play_pitch(sndRatkingChargeEnd, 0.6);
        }
    }

#define Hammerhead_alrm0
    alarm0 = 30 + random(20);

    target = instance_nearest(x, y, Player);
    if(target_in_distance(0, 256)){
        var _targetDir = point_direction(x, y, target.x, target.y);
        if(target_is_visible()){
             // Close Range Charge:
            if(target_in_distance(0, 96) && random(3) < 2){
                charge = 15 + random(10);
                charge_wait = 15;
                charge_dir = _targetDir;
                sound_play_pitchvol(sndHammerHeadEnd, 0.6, 0.25);
            }

             // Move Towards Target:
            else{
                scrWalk(30, _targetDir + orandom(20));
                rotate = orandom(20);
            }
        }

        else{
             // Charge Through Walls:
            if(my_health < maxhealth && random(3) < 1){
                charge = 30;
                charge_wait = 15;
                charge_dir = _targetDir;
                alarm0 = charge + charge_wait + random(10);
                sound_play_pitchvol(sndHammerHeadEnd, 0.6, 0.25);
            }

             // Movement:
            else{
                rotate = orandom(30);
                scrWalk(20 + random(10), _targetDir + orandom(90));
            }
        }
    }

     // Passive Movement:
    else{
        scrWalk(30, direction);
        scrRight(direction);
        rotate = orandom(30);
        alarm0 += random(walk);
    }

    scrRight(direction);

#define Hammerhead_draw
    draw_self_enemy();


#define Cat_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);

#define Cat_alrm0
    alarm0 = 20 + random(20);
    
    if(ammo > 0) {
        repeat(2)
        with(scrEnemyShoot(ToxicGas, gunangle + orandom(6), 4)) {
            friction = 0.1;
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
                    sprite_index = global.sprAcidPuff;
                    image_angle = other.gunangle;
                }
                sound_play(sndToxicBoltGas);
                sound_play(sndEmpty);
                sound_loop(sndFlamerLoop);
                wkick += 4;
                alarm0 = 4;
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
    
#define Cat_draw
    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();


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

        var _targetDir = point_direction(x, y, target.x, target.y);

         // Sound:
        sound_play(sndCrystalTB);
        sound_play(sndPlasma);

         // Facing:
        scrRight(_targetDir);
        
         // Shoot Mortar:
        with(scrEnemyShootExt(x - (2 * right), y, "MortarPlasma", _targetDir, 3)){
            z += 18;
            depth = 12;
            zspeed = (point_distance(x, y - z, other.target.x, other.target.y) / 8) + orandom(1);
            right = other.right;
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

     // Trail:
    if(random(2) < 1){
        with(instance_create(x + orandom(4), y - z + orandom(4), PlasmaTrail)) {
            sprite_index = global.sprMortarTrail;
            depth = other.depth;
        }
    }

     // Hit:
    if(z <= 0) instance_destroy();

#define MortarPlasma_destroy
    with(instance_create(x, y, PlasmaImpact)){
        sprite_index = global.sprMortarImpact;
        team = other.team;
        creator = other.creator;
        hitid = other.hitid;
        damage = 1;
    }

     // Sound:
    sound_play(sndPlasmaHit);

#define MortarPlasma_draw
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale * right, image_angle - (speed * 2) + (max(zspeed, -8) * 8), image_blend, image_alpha);

#define MortarPlasma_hit
    // nada

#define MortarPlasma_wall
    // nada


#define NewCocoon_death
     // Hatch 1-3 Spiders:
    repeat(irandom_range(1, 3)) {
    	with(instance_create(x, y, Spider)) {
    		maxhealth = round(maxhealth / 4.5);
    		my_health = maxhealth;
    		spr_shadow = shd16;
    		corpse = 0;
    		
    		image_xscale = 0.6;
    		image_yscale = image_xscale;
    	}
    }


#define draw_self_enemy()
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);

#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)
	draw_sprite_ext(_sprite, 0, _x - lengthdir_x(_wkick, _ang), _y - lengthdir_y(_wkick, _ang), 1, _flip, _ang + (_meleeAng * (1 - (_wkick / 20))), _blend, _alpha);

#define scrWalk(_walk, _dir)
    walk = _walk;
    speed = max(speed, friction);
    direction = _dir;
    if("gunangle" in self) gunangle = direction;
    scrRight(direction);

#define scrRight(_dir)
    if(_dir < 90 || _dir > 270) right = 1;
    if(_dir > 90 && _dir < 270) right = -1;

#define scrEnemyShoot(_object, _dir, _spd)
    return scrEnemyShootExt(x, y, _object, _dir, _spd);

#define scrEnemyShootExt(_x, _y, _object, _dir, _spd)
    var _inst = noone;

    if(is_string(_object)) _inst = obj_create(_x, _y, _object);
    else _inst = instance_create(_x, _y, _object);
    with(_inst){
        motion_add(_dir, _spd);
        image_angle = _dir;
        hitid = other.hitid;
        team = other.team;
        creator = other;
        if(skill_get(mut_euphoria) && object_index == CustomProjectile){
            speed *= 0.8;
        }
    }

    return _inst;

#define enemyAlarms(_maxAlarm)
    for(var i = 0; i < _maxAlarm; i++){
    	var a = alarm_get(i);
    	if(a > 0){
             // Decrement Alarm:
            a -= ceil(current_time_scale);
    		alarm_set(i, a);

             // Call Alarm:
    		if(a <= 0){
    		    alarm_set(i, -1);
    		    script_ref_call(variable_instance_get(self, "on_alrm" + string(i)));
    		    if(!instance_exists(self)) exit;
    		}
    	}
    }

#define enemyWalk(_spd, _max)
    if(walk > 0){
        motion_add(direction, _spd);
        walk -= current_time_scale;
    }
    if(speed > _max) speed = _max; // Max Speed

#define enemySprites
     // Not Hurt:
    if(sprite_index != spr_hurt){
        if(speed <= 0) sprite_index = spr_idle;
    	else if(sprite_index == spr_idle) sprite_index = spr_walk;
    }

     // Hurt:
    else if(image_index > sprite_get_number(sprite_index) - 1) {
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

#define scrDefaultDrop
    pickup_drop(16, 0); // Bandit drop-ness

#define z_engine
    z += zspeed * current_time_scale;
    zspeed -= zfric * current_time_scale;

#define chance_frame(_percent)
    return random(100) <= _percent * current_time_scale;

#define instances_named(_object, _name)
    return instances_matching(_object, "name", _name);


#define draw_bloom
    draw_set_blend_mode(bm_add);
    with(instances_named(CustomProjectile, "MortarPlasma")){
        draw_sprite_ext(sprite_index, image_index, x, y - z, 2 * image_xscale, 2 * image_yscale * right, image_angle - (speed * 2) + (max(zspeed, -8) * 8), image_blend, 0.1 * image_alpha);
    }
    with(instances_named(CustomProjectile, "TrafficCrabVenom")){
        draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.2 * image_alpha);
    }
    with(instances_named(CustomProjectile, "BubbleBomb")){
        //draw_sprite_ext(sprite_index, image_index, x, y - z, 1.5 * image_xscale, 1.5 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
    }
    draw_set_blend_mode(bm_normal);

#define draw_shadows
    with(instances_named(CustomProjectile, "MortarPlasma")) if(visible){
        draw_sprite(shd24, 0, x, y);
    }


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

#define array_flip(_array)
    var a = array_clone(_array),
        m = array_length(_array);

    for(var i = 0; i < m; i++){
        _array[@i] = a[(m - 1) - i];
    }

#define orandom(n) // For offsets
    return random_range(-n, n);