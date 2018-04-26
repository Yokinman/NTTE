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
    	global.sprBigFishLeap = sprite_add("sprites/enemies/CoastBoss/sprBigFishLeap.png", 11, 32, 32);
    	global.sprBigFishSwim = sprite_add("sprites/enemies/CoastBoss/sprBigFishSwim.png", 8, 24, 24);  
    	global.sprBigFishEmerge = sprite_add("sprites/enemies/CoastBoss/sprBigFishEmerge.png", 5, 32, 32);
    	global.sprBubbleBomb = sprite_add("sprites/enemies/projectiles/sprBubbleBomb.png", 30, 8, 8);
    	global.sprBubbleExplode = sprite_add("sprites/enemies/projectiles/sprBubbleExplode.png", 9, 24, 24);

         // Harpoon:
        global.sprHarpoon = sprite_add("sprites/weps/sprHarpoon.png", 1, 4, 3);

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

             // Coast Water Rock Decal:
            global.sprTopDecalCoast = sprite_add("sprites/areas/Coast/sprTopDecalCoast.png", 2, 16, 16);
            global.sprMidDecalCoast = sprite_add("sprites/areas/Coast/sprMidDecalCoast.png", 2, 16, 16);
            global.sprBotDecalCoast = sprite_add("sprites/areas/Coast/sprBotDecalCoast.png", 2, 16, 16);

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
            global.sprPalankingTemp = sprite_add("sprites/enemies/Palanking/sprTemp.png", 1, 40, 40);

             // Palm:
        	global.sprPalmIdle = sprite_add("sprites/areas/Coast/Props/sprPalm.png",     1, 24, 40);
        	global.sprPalmHurt = sprite_add("sprites/areas/Coast/Props/sprPalmHurt.png", 3, 24, 40);
        	global.sprPalmDead = sprite_add("sprites/areas/Coast/Props/sprPalmDead.png", 4, 24, 40);

             // Pelican:
            global.sprPelicanIdle = sprite_add("sprites/enemies/Pelican/sprPelicanIdle.png", 6, 24, 24);
            global.sprPelicanWalk = sprite_add("sprites/enemies/Pelican/sprPelicanWalk.png", 6, 24, 24);
            global.sprPelicanHurt = sprite_add("sprites/enemies/Pelican/sprPelicanHurt.png", 3, 24, 24);
            global.sprPelicanDead = sprite_add("sprites/enemies/Pelican/sprPelicanDead.png", 6, 24, 24);
            global.sprPelicanHammer = sprite_add("sprites/enemies/Pelican/sprPelicanHammer.png", 1, 6, 8);

             // Traffic Crab:
            global.sprCrabIdle = sprite_add("sprites/enemies/Crab/sprTrafficCrabIdle.png", 5, 24, 24);
            global.sprCrabWalk = sprite_add("sprites/enemies/Crab/sprTrafficCrabWalk.png", 6, 24, 24);
            global.sprCrabHurt = sprite_add("sprites/enemies/Crab/sprTrafficCrabHurt.png", 3, 24, 24);
            global.sprCrabDead = sprite_add("sprites/enemies/Crab/sprTrafficCrabDead.png", 9, 24, 24);
            global.sprCrabFire = sprite_add("sprites/enemies/Crab/sprTrafficCrabFire.png", 2, 24, 24);
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

    	case "BubbleBomb":
    	    o = instance_create(_x, _y, CustomProjectile);
    	    with(o){
    	         // Visual:
    	        sprite_index = global.sprBubbleBomb;
    	        mask_index = sprGrenade;
    	        image_speed = 0.4;

    	         // Vars:
    	        z = 0;
    	        zspeed = -0.5;
    	        zfric = -0.02;
    	        friction = 0.4;
    	        damage = 0;
    	        force = 0;
    	        typ = 2;

    	         // Alarms:
    	        alarm0 = 60;
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
        	        spr_idle = sprBigFishIdle;
        			spr_walk = sprBigFishWalk;
        			spr_hurt = sprBigFishHurt;
        			spr_dead = sprBigFishDead;
    			    spr_weap = mskNone;
        			spr_shadow = shd48;
        			mask_index = mskBigMaggot;
        			hitid = [spr_idle, _name];
        			sprite_index = spr_idle;
    			    depth = -1;
        			
        			 // Fire:
        			spr_sfir = sprBigFishFireStart;
        			spr_fire = sprBigFishFire;
        			spr_efir = sprBigFishFireEnd;

        			 // Swim:
        			spr_dive = global.sprBigFishLeap;
        			spr_swim = global.sprBigFishSwim;
        			spr_rise = global.sprBigFishEmerge;

                 // Sound:
        		snd_hurt = sndOasisBossHurt;
        		snd_dead = sndOasisBossDead;

    			 // Vars:
    			my_health = 120;
    			maxhealth = my_health;
    			raddrop = 50;
    			size = 3;
    			meleedamage = 3;
    			walk = 0;
    			walkspd = 0.8;
    			maxspd = 3;
    			ammo = 4;
    			gunangle = random(360);
    			direction = gunangle;

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
                mask_index = mskBolt;

                 // Vars:
				creator = noone;
				target = noone;
				link = noone;
				rope_length = 0;
				break_force = 0;
				can_break = 0;
				damage = 3;
				force = 8;
				typ = 0;
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

            case "CoastDecal":
                o = instance_create(_x, _y, CustomHitme);
                with(o){
                     // Visual:
                    sprite_index = global.sprMidDecalCoast;
                    spr_top = global.sprTopDecalCoast;
                    spr_bot = global.sprBotDecalCoast;
                    image_index = irandom(image_number - 1);
                    image_xscale = choose(-1, 1);
                    image_speed = 0;
                    mask_index = mskPlayer;
                    spr_shadow = -1;
                    depth = (-y / 20000);
                    friction = 3;
        
                     // Sound:
                    snd_hurt = sndHitRock;
        
                     // Vars:
                    my_health = 50;
                    size = 5;
    
                     // Offset:
                    x += random_range(-10, 10);
                    y += random_range(-10, 10);
        
                     // Doesn't Use Coast Wading System:
                    nowade = 1;
                }
            break;

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
        			mask_index = mskBandit;
        			depth = -3;
    
        			 // Vars:
        			my_health = 12;
        			maxhealth = my_health;
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
    			    mask_index = mskBolt;
    
                     // Vars:
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
        			mask_index = mskBandit;
        			depth = -2;
    
                     // Sound:
                    snd_hurt = sndRavenHit;
                    snd_dead = sndAllyDead;
    
                     // Vars:
        			my_health = 8;
        			maxhealth = my_health;
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
            	        spr_idle = global.sprPalankingTemp;
            			spr_walk = global.sprPalankingTemp;
            			spr_hurt = global.sprPalankingTemp;
            			spr_dead = global.sprPalankingTemp;
        			    spr_weap = mskNone;
            			spr_shadow = shd48;
            			mask_index = mskBigMaggot;
            			hitid = [spr_idle, _name];
            			sprite_index = spr_idle;
        			    depth = -1;
            			
            			 // Fire:
            			spr_sfir = global.sprPalankingTemp;
            			spr_fire = global.sprPalankingTemp;
            			spr_efir = global.sprPalankingTemp;
    
                     // Sound:
            		snd_hurt = sndOasisBossHurt;
            		snd_dead = sndOasisBossDead;
    
        			 // Vars:
        			my_health = 350;
        			maxhealth = my_health;
        			raddrop = 100;
        			size = 3;
        			meleedamage = 3;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 3;
        			ammo = 0;
        			gunangle = random(360);
        			direction = gunangle;
    
        			 // Alarms:
        			alarm0 = 60 + irandom(40);
        			alarm1 = 30 + irandom(10);
        			alarm2 = -1;
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
                    depth = -(y / 20000);
                    mask_index = mskStreetLight;
    
                     // Sound:
                    snd_hurt = sndHitPlant;
                    snd_dead = sndHitPlant;
    
                     // Vars:
                    my_health = 40;
                    size = 1;
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
                    hitid = [spr_idle, _name];
                    sprite_index = spr_idle;
                    mask_index = mskScorpion;
                    depth = -2;
    
                     // Sound:
                    snd_hurt = sndHitRock;
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
        			my_health = 75;
        			maxhealth = my_health;
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
        			my_health = 6;
        			maxhealth = my_health;
        			nexthurt = current_frame;
        			size = 1;
        		}
        	break;
    	//#endregion

    	default:
    		return ["BigDecal", "BubbleBomb", "CoastBoss", "Harpoon",
    		        "BloomingCactus", "CoastDecal", "Diver", "DiverHarpoon", "Gull", "Palanking", "Palm", "Pelican", "TrafficCrab", "TrafficCrabVenom",
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
                else{
                    if(v == "on_hurt") on_hurt = enemyHurt;
                    else if(v == "on_death") on_death = scrDefaultDrop;
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


#define BubbleBomb_step
     // Float Up:
    z_engine();
    image_angle += (sin(current_frame/8) * 10) * current_time_scale;
    depth = min(-2, -z);

    enemyAlarms(1);

#define BubbleBomb_draw
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

#define BubbleBomb_hit
    // nada

#define BubbleBomb_wall
    move_bounce_solid(false);

#define BubbleBomb_alrm0
     // Explode:
    with(instance_create(x, y, Explosion)){
        sprite_index = global.sprBubbleExplode;
        team = other.team;
        creator = other.creator;
        hitid = other.hitid;
    }

     // Effects:
    sound_play_pitch(sndExplosionS, 2);
    sound_play_pitch(sndOasisExplosion, 1 + random(1));
    repeat(10) instance_create(x, y, Bubble);

    instance_destroy();

#define BubbleBomb_destroy
     // Pop:
    sound_play_pitchvol(sndLilHunterBouncer, 2 + random(0.5), 0.5);
    with(instance_create(x, y - z, BubblePop)){
        image_angle = other.image_angle;
        image_xscale = 0.5 + (other.image_index * 0.02);
        image_yscale = image_xscale;
    }


#define CoastBoss_step
    enemyAlarms(3);

     // Animate:
    if(sprite_index != spr_hurt and sprite_index != spr_fire and sprite_index != spr_sfir and sprite_index != spr_efir and sprite_index != spr_dive and sprite_index != spr_swim and sprite_index != spr_rise)
    {
        if(speed <= 0) sprite_index = spr_idle;
    	else if(sprite_index == spr_idle) sprite_index = spr_walk;
    }
    else if(image_index > sprite_get_number(sprite_index) - 1){
        var _lstspr = sprite_index;
        if(fork()){
            if(sprite_index = spr_hurt) {
                sprite_index = spr_idle;
                exit;
            }

            if(sprite_index = spr_sfir) {
                sprite_index = spr_fire
                exit;
            }

            if(sprite_index = spr_fire and ammo = 0) {
                sprite_index = spr_efir;
                exit;
            }

            if(sprite_index = spr_efir) {
                sprite_index = spr_idle;
                exit;
            }

            if(sprite_index = spr_dive) {
                sprite_index = spr_swim;
                exit;
            }

            if(sprite_index = spr_rise) {
                sprite_index = spr_idle;
                spr_shadow = shd48;
                exit;
            }
        }
        if(sprite_index != _lstspr) image_index = 0;
    }

    enemyWalk(walkspd, maxspd);

     // Swim Towards Target:
    if(sprite_index == spr_swim){
        target = instance_nearest(x, y, Player);
        if(instance_exists(target)){
            motion_add(point_direction(x, y, target.x, target.y), 1);
        }
        scrRight(direction);
        if chance_frame(100) 
            repeat(random(3))
                with instance_create(x+(random(16) * other.right),bbox_bottom+random_range(12,16),Dust){
                    gravity = .3;
                    motion_add(other.direction+(other.right * random_range(80,130)), random_range(2,4));
                    if (place_meeting(x,y,FloorExplo) && irandom(2)) || !irandom(3){
                        sprite_index = sprDebris1;
                    }
                    else{
                        image_blend = make_color_rgb(236,188,82);
                    }
                    image_xscale *= .75;
                    image_yscale *= .75;
                    depth = other.depth + choose(-1,1);
                }
    }

#define CoastBoss_hurt(_hitdmg, _hitvel, _hitdir)
    if(sprite_index != spr_swim){ // Can't be hurt while swimming
        my_health -= _hitdmg;           // Damage
        motion_add(_hitdir, _hitvel);	// Knockback
        nexthurt = current_frame + 6;	// I-Frames
        sound_play_hit(snd_hurt, 0.3);	// Sound

         // Hurt Sprite:
        if(sprite_index != spr_fire and sprite_index != spr_sfir and sprite_index != spr_efir and sprite_index != spr_dive and sprite_index != spr_rise) {
            sprite_index = spr_hurt;
            image_index = 0;
        }
    }

#define CoastBoss_draw
     // Flash White w/ Hurt While Diving:
    if(
        sprite_index != spr_hurt &&
        nexthurt > current_frame &&
        ((nexthurt + current_frame) mod (room_speed / 10)) = 0
    ){
        d3d_set_fog(1, c_white, 0, 0);
        draw_self_enemy();
        d3d_set_fog(0, 0, 0, 0);
    }

     // Normal Self:
    else draw_self_enemy();

#define CoastBoss_alrm0
    alarm0 = 80 + irandom(20);
    target = instance_nearest(x, y, Player);
    if(target_in_distance(0, 160)) {
        var _targetDir = point_direction(x, y, target.x, target.y);
    
         // Bubble Attack:
        if(random(2) < 1) {
            alarm1 = 6;
            sprite_index = spr_sfir;
            image_index = 0;
            gunangle = _targetDir;
            sound_play(sndOasisBossFire);
            ammo = 3 * (GameCont.loops + 2);
            alarm0 = 60 + (2 * ammo);
        }
    
         // Dive:
        else if(random(2) < 1) alarm2 = 6;
    
         // Move Towards Target:
        else{
            walk = 30 + random(10);
            direction = _targetDir + random_range(-15, 15);
            alarm0 = 30 + irandom(20);
        }
    
        scrRight(_targetDir);
    }

     // Dive:
    else if(instance_exists(target)) alarm2 = 6;

     // Passive Movement:
    else{
        walk = 20;
        alarm0 = 40 + irandom(20);
        direction = random(360);
        scrRight(direction);
    }

#define CoastBoss_alrm1
     // Fire Bubble Bombs:
    if(ammo > 0){
        alarm1 = 2;
        sound_play(sndOasisShoot);
        with(obj_create(x, y, "BubbleBomb")) {
            motion_add(other.gunangle + sin(current_frame/4) * 24, 8 + random_range(0, 2))
            team = other.team;
            creator = other.id;
            hitid = [other.spr_idle, "BIG FISH"];
        }
        ammo--;
    }

#define CoastBoss_alrm2
    target = instance_nearest(x, y, Player);

     // Dive:
    if((sprite_index != spr_dive and sprite_index != spr_swim) or point_distance(x, y, target.x, target.y) > 120){
        if(sprite_index != spr_swim) {
            sprite_index = spr_dive;
            image_index = 0;
            spr_shadow = mskNone;
            sound_play(sndOasisBossMelee);
        }
        
        alarm0 = 80;
        alarm2 = 60;
    }

     // Un-Dive:
    else{
        sprite_index = spr_rise;
        image_index = 0;
    }

#define CoastBoss_death
     // Coast Entrance:
    instance_create(x, y, Portal);
    GameCont.area = "coast";
    GameCont.subarea = 0;
    with(enemy) my_health = 0;


#define Harpoon_step
     // Hit Pickups/Chests:
    if(speed > 0){
        if(place_meeting(x, y, chestprop)){
            with(instance_nearest(x, y, chestprop)) with(other){
                event_perform(ev_collision, Wall);
            }
        }
    }

     // Stuck in Target:
    var _targ = target,
        _link = link;

    if(instance_exists(_targ)){
        var _inWall = (_targ.object_index == Wall);

         // Stay on Target:
        if(!_inWall){
            var _odis = 16,
                _odir = image_angle;

            x = _targ.x - lengthdir_x(_odis, _odir);
            y = _targ.y - lengthdir_y(_odis, _odir);
            xprevious = x;
            yprevious = y;
            visible = _targ.visible;
        }

         // Rope Linked:
        if(instance_exists(_link)){
            var _linkDis = point_distance(_targ.x, _targ.y, _link.x, _link.y) - rope_length,
                _linkDir = point_direction(x, y, _link.x, _link.y);

            if(_link != creator){
                with(_link) if(rope_length <= 0) rope_length = other.rope_length;
            }

             // Pull Target:
            if(!_inWall && _linkDis > 0){
                if(!instance_is(_targ, prop)) with(instances_matching_ne(_targ, "name", "CoastDecal")){
                    var _pull = (("size" in self) ? (2 / size) : 2),
                        _drag = min(_linkDis / 3, 10 / (("size" in self) ? (size * 2) : 2));

                    hspeed += lengthdir_x(_pull, _linkDir);
                    vspeed += lengthdir_y(_pull, _linkDir);
                    x += lengthdir_x(_drag, _linkDir);
                    y += lengthdir_y(_drag, _linkDir);
                }
            }

             // Rope Stretching:
            if(can_break){
                break_force = max(_linkDis, 0);

                 // Break:
                if(break_force > 100){
                    sound_play_pitch(sndHammerHeadEnd, 2);
                    with(_link) link = noone;
                    link = noone;
                }
            }
            else if(_linkDis <= 0) can_break = 1;
            if(_link != creator) with(_link){
                if(!instance_exists(target)) other.can_break = 0;
                can_break = other.can_break;
            }
        }
    }
    else if(speed <= 0) instance_destroy();

#define Harpoon_hit
    if(speed > 0 && projectile_canhit(other)){
        speed = 0;
        target = other;
        if(instance_exists(link) && rope_length <= 0){
            rope_length = point_distance(x, y, link.x, link.y);
        }
        projectile_hit_push(other, damage, force);
    }

#define Harpoon_wall
     // Stick in Wall:
    if(speed > 0){
        speed = 0;
        target = other;
        move_contact_solid(direction, 16);
        if(instance_exists(link) && rope_length <= 0){
            rope_length = point_distance(x, y, link.x, link.y);
        }
        instance_create(x, y, Dust);
        sound_play(sndBoltHitWall);
    }

#define Harpoon_draw
    var _targ = target,
        _link = link;

    if(instance_exists(_link)){
        var _wid = 1,
            _col = c_white;

         // Rope Stretching:
        if(can_break){
            _wid = min(rope_length / point_distance(x, y, _link.x, _link.y), 2);
            _col = merge_color(_col, c_red, clamp(break_force / 100, 0, 1)) 
        }

        draw_set_color(_col);
        draw_line_width(x, y, _link.x, _link.y, _wid);
    }

    draw_self();


#define CoastDecal_step
    if(place_meeting(x, y, hitme)){
        with(instances_matching_le(hitme, "size", size)){
            if(place_meeting(x, y, other)) motion_add(point_direction(other.x, other.y, x, y), size);
        }
    }

#define CoastDecal_hurt(_hitdmg, _hitvel, _hitdir)
    nexthurt = current_frame + 6;   // I-Frames
    sound_play(snd_hurt);           // Sound

     // Damage:
    if(my_health > 0){
        my_health -= _hitdmg;

         // Break:
        if(my_health <= 0){
            mask_index = mskNone;

             // Can Stand On Corpse:
            with(instance_create(0, 0, Floor)){
                x = other.x;
                y = other.y;
                visible = 0;
                mask_index = mskAlly;
            }

             // Visual:
            depth = 1;
            var _ang = random(360);
            for(var a = _ang; a < _ang + 360; a += 360 / 3){
                with(instance_create(x, y, MeleeHitWall)) image_angle = a + random_range(-10, 10);
            }
            repeat(choose(2, 3)){
                with(instance_create(x + random_range(-2, 2), y + random_range(-2, 2), Debris)){
                    motion_set(_hitdir + random_range(-10, 10), (speed + _hitvel) / 2);
                }
            }
            with(instances_matching(BoltStick, "target", id)) instance_destroy();

             // Break Sound:
            sound_play_pitchvol(sndWallBreakRock, 0.7 + random(0.2), 0.7);
        }
    }

#define CoastDecal_draw
    var _hurt = (nexthurt > current_frame + 4);
    if(_hurt) d3d_set_fog(1, c_white, 0, 0);

    if(my_health > 0) draw_sprite_ext(spr_top, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    else draw_self();

    if(_hurt) d3d_set_fog(0, 0, 0, 0);


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
    			gunangle = _targetDir + random_range(10, -10);
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
    		direction = _targetDir + 180 + random_range(30, -30);
    		gunangle = direction + random_range(15, -15);
    		walk = 15 + irandom(15);
    	}

    	 // Facing:
    	scrRight(_targetDir);
    }

     // Passive Movement:
    else{
    	direction = random(360);
    	gunangle = direction + random_range(15, -15);
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
    if(speed > 0 && projectile_canhit(_inst)){
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
        		direction = _targetDir + random_range(20, -20);
        		gunangle = direction + random_range(15, -15);
    		}
    	}

         // Move Toward Target:
    	else{
    		alarm0 = 30 + irandom(10);
    		walk = 10 + irandom(20);
    		direction = _targetDir + random_range(20, -20);
    		gunangle = direction + random_range(15, -15);
    	}

    	 // Facing:
    	scrRight(direction);
    }

     // Passive Movement:
    else{
    	walk = 30;
    	direction = random(360);
    	gunangle = direction + random_range(15, -15);
    	scrRight(direction);
    }

#define Gull_alrm1
     // Slash:
    gunangle = point_direction(x, y, target.x, target.y) + random_range(10, -10);
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
    enemySprites();
    enemyWalk(walkspd, maxspd);
    
#define Palanking_alrm0
    alarm0 = 40 + random(20);
    target = instance_nearest(x, y, Player);
     // Bubble Attack:
    if(ammo > 0) {
        alarm0 = 4;
        scrEnemyShoot("BubbleBomb", gunangle + random_range(10, -10), 8 + random(4));
        motion_add(gunangle + 180, 4);
        sound_play_pitchvol(sndExplosionS, 3, 0.4);
        ammo--;
        if(ammo = 0)
        alarm0 = 60 + random(20);
    }
    
     // Normal AI:
    else {
         // Bubble Bomb Burp:
        if(target_in_distance(0, 160) and random(4) < 1) {
            var _targetDir = point_direction(x, y, target.x, target.y);
            gunangle = _targetDir;
            ammo = 10;
            alarm0 = 5;
            sound_play_pitchvol(sndVenuz, 0.4, 0.8);
        } else if(target_in_distance(80, 900) and random(2) < 1) {
            var _targetDir = point_direction(x, y, target.x, target.y);
            gunangle = _targetDir;
            scrWalk(20, gunangle);
            with(scrEnemyShoot(EnemySlash, gunangle + 20, 4)) { sprite_index = sprHeavySlash; image_speed = 0.2; }
            with(scrEnemyShoot(EnemySlash, gunangle - 20, 4)) { sprite_index = sprHeavySlash; image_speed = 0.2; }
            alarm0 = 60 + random(20);
        }
    }
    
#define Palanking_alrm1
    target = instance_nearest(x, y, Player);
    
    if(target_is_visible()) {
        if(random(2) < 1) {
            var _targetDir = point_direction(x, y, target.x, target.y);
            scrEnemyShootExt(x + choose(12, -12), y + choose(12, -12), EnemyBullet1, _targetDir + random_range(30, -30), 3);
        }
    }
    
    alarm1 += 30 + random(10);

#define Palanking_alrm2
    


#define Palm_death
     // Leaves:
    repeat(15) with(instance_create(x + random_range(-15, 15), y - 30 + random_range(-10, 10), Feather)){
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
        instance_create(x + random_range(-3, 3), y + random(6), Dust);
        with(instance_create(x + random_range(-3, 3), y + random(6), Dust)){
            motion_add(other.direction + random_range(-45, 45), (4 + random(1)) * other.dash_factor);
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
            scrWalk(5, _targetDir + 180 + random_range(-10, 10));

             // Warn:
            instance_create(x, y, AssassinNotice).depth = -3;
            sound_play_pitch(sndRavenHit, 0.5 + random(0.1));
        }

         // Move Toward Target:
        else scrWalk(20 + random(10), _targetDir + random_range(-10, 10));

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
            scrEnemyShootExt(_x, _y, "TrafficCrabVenom", gunangle + random_range(-10, 10), 10 + random(2));
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

#define TrafficCrabVenom_anim
    image_speed = 0;
    image_index = image_number - 1;

#define TrafficCrabVenom_destroy
    with(instance_create(x, y, BulletHit)) sprite_index = sprScorpionBulletHit;


#define Cat_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);

#define Cat_alrm0
    alarm0 = 20 + random(20);
    
    if(ammo > 0) {
        repeat(2)
        with(scrEnemyShoot(ToxicGas, gunangle + random_range(6, -6), 4)) {
            friction = 0.1;
        }
        gunangle += 12;
        ammo--;
        if(ammo = 0) {
            alarm0 = 40;
            repeat(3) {
                var _dir = random_range(16, -16);
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
                scrWalk(20 + random(5), _targetDir + random_range(20, -20));
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
            direction = _targetDir + random_range(-15, 15);
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
            zspeed = (point_distance(x, y - z, other.target.x, other.target.y) / 8) + random_range(1, -1);
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
        with(instance_create(x + random_range(4, -4), y - z + random_range(4, -4), PlasmaTrail)) {
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
    		my_health = 4;
    		maxhealth = my_health;
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
    gunangle = direction;
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
        image_angle = direction;
        hitid = other.hitid;
        team = other.team;
        creator = other;
    }

    return _inst;

#define enemyAlarms(_maxAlarm)
    for(i = 0; i < _maxAlarm; i++){
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
	return (instance_exists(target) && !collision_line(x, y, target.x, target.y, Wall, false, false));

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
    draw_set_blend_mode(bm_normal);

#define draw_shadows
    with(instances_named(CustomProjectile, "MortarPlasma")) draw_sprite(shd24, 0, x, y);
