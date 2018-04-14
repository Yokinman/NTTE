#define init
//sprites
{ 
     // Diver:
	global.sprDiverIdle = sprite_add("sprites/enemies/Diver/sprDiverIdle.png", 4, 12, 12);
	global.sprDiverWalk = sprite_add("sprites/enemies/Diver/sprDiverWalk.png", 6, 12, 12);
	global.sprDiverHurt = sprite_add("sprites/enemies/Diver/sprDiverHurt.png", 3, 12, 12);
	global.sprDiverDead = sprite_add("sprites/enemies/Diver/sprDiverDead.png", 9, 16, 16);
	global.sprHarpoonGun = sprite_add("sprites/enemies/Diver/sprDiverHarpoonGun.png", 1, 8, 8);
	global.sprHarpoonGunEmpty = sprite_add("sprites/enemies/Diver/sprDiverHarpoonGunDischarged.png", 1, 8, 8);
	
	 // Mortar:
	global.sprMortarIdle = sprite_add("sprites/enemies/Mortar/sprMortarIdle.png", 4, 22, 24);
	global.sprMortarWalk = sprite_add("sprites/enemies/Mortar/sprMortarWalk.png", 8, 22, 24);
	global.sprMortarFire = sprite_add("sprites/enemies/Mortar/sprMortarFire.png", 16, 22, 24);
	global.sprMortarHurt = sprite_add("sprites/enemies/Mortar/sprMortarHurt.png", 3, 22, 24);
	global.sprMortarDead = sprite_add("sprites/enemies/Mortar/sprMortarDead.png", 14, 22, 24);
	global.sprMortarPlasma = sprite_add("sprites/enemies/Mortar/sprMortarPlasma.png", 1, 4, 4);
	global.sprMortarImpact = sprite_add("sprites/enemies/Mortar/sprMortarImpact.png", 7, 16, 16);
	global.sprMortarTrail = sprite_add("sprites/enemies/Mortar/sprMortarTrail.png", 3, 4, 4);
	
	 // Big Fish:
	global.sprBigFishLeap = sprite_add("sprites/enemies/CoastBoss/sprBigFishLeap.png", 11, 32, 32);
	global.sprBigFishSwim = sprite_add("sprites/enemies/CoastBoss/sprBigFishSwim.png", 8, 24, 24);  
	global.sprBigFishEmerge = sprite_add("sprites/enemies/CoastBoss/sprBigFishEmerge.png", 5, 32, 32);
	global.sprBubbleBomb = sprite_add("sprites/enemies/projectiles/sprBubbleBomb.png", 30, 8, 8);
	global.sprBubbleExplode = sprite_add("sprites/enemies/projectiles/sprBubbleExplode.png", 9, 24, 24);

	 // Seagull:
	global.sprGullIdle = sprite_add("sprites/enemies/Gull/sprGullIdle.png", 4, 12, 12);
	global.sprGullWalk = sprite_add("sprites/enemies/Gull/sprGullWalk.png", 6, 12, 12);
	global.sprGullHurt = sprite_add("sprites/enemies/Gull/sprGullHurt.png", 3, 12, 12);
	global.sprGullDead = sprite_add("sprites/enemies/Gull/sprGullDead.png", 6, 16, 16);
	global.sprGullSword = sprite_add("sprites/enemies/Gull/sprGullSword.png", 1, 6, 8);

     // Pelican:
    global.sprPelicanIdle = sprite_add("sprites/enemies/Pelican/sprPelicanIdle.png", 6, 24, 24);
    global.sprPelicanWalk = sprite_add("sprites/enemies/Pelican/sprPelicanWalk.png", 6, 24, 24);
    global.sprPelicanHurt = sprite_add("sprites/enemies/Pelican/sprPelicanHurt.png", 3, 24, 24);
    global.sprPelicanDead = sprite_add("sprites/enemies/Pelican/sprPelicanDead.png", 6, 24, 24);
    global.sprPelicanHammer = sprite_add("sprites/enemies/Pelican/sprPelicanHammer.png", 1, 6, 8);
    
     // Cat:
    global.sprAcidPuff = sprite_add("sprites/enemies/Cat/sprAcidPuff.png", 4, 16, 16);

	 // Big Decals:
	global.sprDesertBigTopDecal = sprite_add("sprites/areas/Desert/sprDesertBigTopDecal.png", 1, 32, 24);
	global.mskBigTopDecal = sprite_add("sprites/areas/Desert/mskBigTopDecal.png", 1, 32, 24);
}

#define obj_create(_x, _y, obj_name)
{
    var o = "";
    switch(obj_name) {
    	case "Diver":
    	    o = instance_create(_x, _y, CustomEnemy);
    		with(o) {
    		    name = string(string_upper(obj_name));

                 // Visual:
    			spr_idle = global.sprDiverIdle;
    			spr_walk = global.sprDiverWalk;
    			spr_hurt = global.sprDiverHurt;
    			spr_dead = global.sprDiverDead;
    			spr_weap = global.sprHarpoonGun;
    			spr_shadow = shd24;
    			hitid = [spr_idle, name];
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

    			on_alarm0 = script_ref_create(diver_alarm0);
    			on_step = script_ref_create(diver_step);
    			on_hurt = script_ref_create(enemyHurt);
    			on_draw = script_ref_create(diver_draw);
    		}
    	break;

        case "Harpoon":
			o = instance_create(_x, _y, CustomProjectile);
			with(o){
			    name = string(string_upper(obj_name));

                 // Visual:
			    sprite_index = sprBolt;
			    mask_index = mskBolt;

                 // Vars:
				creator = noone;
				damage = 1;
				force = 8;
				typ = 2;

                on_end_step = script_ref_create(harpoon_end_step);
                on_alarm0 = script_ref_create(harpoon_alarm0);
                on_hit  = script_ref_create(harpoon_hit);
                on_anim = script_ref_create(harpoon_anim);
                on_wall = script_ref_create(harpoon_wall);
			}
		break;

    	case "NewCocoon":
    	    o = instance_create(_x, _y, CustomProp);
    		with(o) {
    		    name = string(string_upper(obj_name));

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

    			on_death = script_ref_create(cocoon_dead);
    		}
    	break;
    	
    	case "Mortar":
    	    o = instance_create(_x, _y, CustomEnemy);
    	    with(o) {
    	        name = string(string_upper(obj_name));

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
    			hitid = [spr_idle, name];
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
    			
    			on_step = script_ref_create(mortar_step);
    			on_alarm0 = script_ref_create(mortar_alarm0);
    			on_alarm1 = script_ref_create(mortar_alarm1);
    			on_hurt = script_ref_create(mortar_hurt);
    			on_draw = script_ref_create(mortar_draw);
    	    }
    	break;
    	
    	case "MortarPlasma":
    	    o = instance_create(_x, _y, CustomProjectile);
    	    with(o) {
    	        name = string(string_upper(obj_name));

                 // Visual:
    	        sprite_index = global.sprMortarPlasma;
    	        mask_index = mskNone;

    	         // Vars:
    	        z = 1;
    	        zspeed = 0;
    	        zfric = 0.8;
    	        damage = 0;
    	        force = 0;
    	        
    	        on_step = script_ref_create(mortar_plasma_step);
    	        on_hit = script_ref_create(mortar_plasma_hit);
    	        on_wall = script_ref_create(mortar_plasma_wall);
    	        on_draw = script_ref_create(mortar_plasma_draw);
    	        on_destroy = script_ref_create(mortar_plasma_destroy);
    	    }
    	break;
    	
    	case "CoastBoss":
    	    o = instance_create(_x, _y, CustomEnemy);
    	    with(o) {
    	        name = string(string_upper(obj_name));
    	        
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
        			hitid = [spr_idle, name];
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

    			on_alarm0 = script_ref_create(fish_alarm0);
    			on_alarm1 = script_ref_create(fish_alarm1);
    			on_alarm2 = script_ref_create(fish_alarm2);
    			on_step = script_ref_create(fish_step);
    			on_hurt = script_ref_create(fish_hurt);
    			on_death = script_ref_create(fish_death);
    			on_draw = script_ref_create(fish_draw);
    	    }
    	break;
    	
    	case "BubbleBomb":
    	    o = instance_create(_x, _y, CustomProjectile);
    	    with(o){
    	        name = string(string_upper(obj_name));

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
    	        
    	        on_alarm0 = script_ref_create(bubble_alarm0);
    	        on_step = script_ref_create(bubble_step);
    	        on_draw = script_ref_create(bubble_draw);
    	        on_hit = script_ref_create(bubble_hit);
    	        on_wall = script_ref_create(bubble_wall);
    	        on_destroy = script_ref_create(bubble_destroy);
    	    }
    	break;

    	case "Decal":
    	    o = instance_create(_x, _y, CustomObject);
    		with(o){
    			name = string(string_upper(obj_name));

        		mask_index = global.mskBigTopDecal;
    			image_xscale = choose(-1, 1);
    			image_speed = 0;
    			depth = -8;
    			
    			on_step = script_ref_create(decal_step);

    		    if(place_meeting(x, y, TopPot)) instance_destroy();

            	 // TopSmalls:
            	else{
            		var _off = 16,
            		    s = _off * 3;
        
            		for(var _ox = -s; _ox <= s; _ox += _off){
            		    for(var _oy = -s; _oy <= s; _oy += _off){
            		        if(random(2) < 1) instance_create(x + _ox, y + _oy, TopSmall);
            		    }
            		}
    		    }
    		}
    	break;
    	
    	case "Gull": 
    	    o = instance_create(_x, _y, CustomEnemy);
    		with(o) {
    		    name = string(string_upper(obj_name));

                 // Visual:
    			spr_idle = global.sprGullIdle;
    			spr_walk = global.sprGullWalk;
    			spr_hurt = global.sprGullHurt;
    			spr_dead = global.sprGullDead;
    			spr_weap = global.sprGullSword;
    			spr_shadow = shd24;
    			hitid = [spr_idle, name];
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
    			
    			on_alarm0 = script_ref_create(gull_alarm0);
    			on_alarm1 = script_ref_create(gull_alarm1);
    			on_step = script_ref_create(gull_step);
    			on_hurt = script_ref_create(enemyHurt);
    			on_draw = script_ref_create(gull_draw);
    		}
    	break;
    	
    	case "Pelican":
    	    o = instance_create(_x, _y, CustomEnemy);
    		with(o) {
    		    name = string(string_upper(obj_name));

                 // Visual:
    			spr_idle = global.sprPelicanIdle;
    			spr_walk = global.sprPelicanWalk;
    			spr_hurt = global.sprPelicanHurt;
    			spr_dead = global.sprPelicanDead;
    			spr_weap = global.sprPelicanHammer;
    			spr_shadow = shd32;
    			spr_shadow_y = 6;
    			hitid = [spr_idle, name];
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

    			on_alarm0 = script_ref_create(pelican_alarm0);
    			on_alarm1 = script_ref_create(pelican_alarm1);
    			on_step = script_ref_create(pelican_step);
    			on_hurt = script_ref_create(enemyHurt);
    			on_draw = script_ref_create(pelican_draw);
    		}
    	break;
    	
    	case "Cat":
    	    o = instance_create(_x, _y, CustomEnemy);
    		with(o) {
    		    name = string(string_upper(obj_name));

                 // Visual:
    			spr_idle = sprBanditIdle;
    			spr_walk = sprBanditWalk;
    			spr_hurt = sprBanditHurt;
    			spr_dead = sprBanditDead;
    			spr_weap = sprToxicThrower;
    			spr_shadow = shd24;
    			hitid = [spr_idle, name];
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

    			on_alarm0 = script_ref_create(cat_alarm0);
    			on_step = script_ref_create(cat_step);
    			on_hurt = script_ref_create(enemyHurt);
    			on_draw = script_ref_create(cat_draw);
    		}
    	break;
    	
    	default:
    		return ["Diver", "NewCocoon", "Mortar", "MortarPlasma", "CoastBoss", "BubbleBomb", "Decal", "Gull", "Pelican", "Cat"];
    	break;
    }
    
    return o;
}


#define diver_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);

#define diver_alarm0
    alarm0 = 60 + irandom(30);
    target = instance_nearest(x, y, Player);
    if(target_is_visible()) {
        var _targetDir = point_direction(x, y, target.x, target.y);

    	if(target_in_distance(60, 320)){
    	     // Shoot Harpoon:
    		if(spr_weap = global.sprHarpoonGun && random(4) < 1){
    		     // Harpoon/Bolt:
    			gunangle = _targetDir + random_range(10, -10);
    			with(obj_create(x, y, "Harpoon")){
    			    motion_add(other.gunangle, 12);
    				image_angle = direction;
    				team = other.team;
    				creator = other;
    				hitid = other.hitid;
    			}

                wkick = 8;
                sound_play(sndCrossbow);
    			spr_weap = global.sprHarpoonGunEmpty;
    		}

             // Reload Harpoon:
    		else if(spr_weap = global.sprHarpoonGunEmpty){
    			sound_play(sndCrossReload);
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

#define diver_draw
    if(gunangle <= 180) draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
    draw_self_enemy();
    if(gunangle > 180) draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);

#define harpoon_end_step
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

#define harpoon_alarm0
    instance_destroy();

#define harpoon_hit
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

#define harpoon_wall
     // Stick in Wall:
    if(speed > 0){
        speed = 0;
        sound_play(sndBoltHitWall);
        move_contact_solid(direction, 16);
        instance_create(x, y, Dust);
        alarm0 = 30;
    }

#define harpoon_anim
    image_speed = 0;
    image_index = image_number - 1;

#define cocoon_dead
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

#define mortar_step
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

#define mortar_alarm0
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

#define mortar_alarm1
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
        with(obj_create(x - (2 * right), y, "MortarPlasma")) {
            z += 18;
            depth = 12;
            zspeed = point_distance(x, y - z, other.target.x, other.target.y)/8 + random_range(1, -1);
            motion_add(_targetDir, 3);
            team = other.team;
            creator = other.id;
            hitid = other.hitid;
            right = other.right;
        }

        alarm1 = 4;
        ammo--;
    }

#define mortar_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    motion_add(_hitdir, _hitvel);	// Knockback
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);	// Sound

     // Hurt Sprite:
    if(sprite_index != spr_fire){
        sprite_index = spr_hurt;
        image_index = 0;
    }

#define mortar_draw
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


#define mortar_plasma_step
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

#define mortar_plasma_destroy
    with(instance_create(x, y, PlasmaImpact)){
        sprite_index = global.sprMortarImpact;
        team = other.team;
        creator = other.creator;
        hitid = other.hitid;
        damage = 1;
    }

     // Sound:
    sound_play(sndPlasmaHit);

#define mortar_plasma_draw
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale * right, image_angle - (speed * 2) + (max(zspeed, -8) * 8), image_blend, image_alpha);

#define mortar_plasma_hit
    // nada

#define mortar_plasma_wall
    // nada


#define fish_step
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
    }

#define fish_hurt(_hitdmg, _hitvel, _hitdir)
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

#define fish_draw
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

#define fish_alarm0
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

#define fish_alarm1
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

#define fish_alarm2
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

#define fish_death
     // Entrance to Coast:
    instance_create(x, y, Portal);
    GameCont.area = "coast";
    GameCont.subarea = 0;
    with(enemy) my_health = 0;


#define bubble_step
     // Float Up:
    z_engine();
    image_angle += (sin(current_frame/8) * 10) * current_time_scale;
    depth = min(-2, -z);

     // Exploding:
    if(alarm0 > 1 && place_meeting(x, y, Explosion)) alarm0 = 1;
    enemyAlarms(1);

#define bubble_draw
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

#define bubble_hit
    // nada

#define bubble_wall
    move_bounce_solid(false);

#define bubble_alarm0
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

#define bubble_destroy
    sound_play_pitchvol(sndLilHunterBouncer, 2 + random(0.5), 0.5);
    with(instance_create(x, y - z, BubblePop)){
        image_angle = other.image_angle;
        image_xscale = 0.5 + (other.image_index * 0.02);
        image_yscale = image_xscale;
    }


#define decal_step
    if(place_meeting(x, y, FloorExplo)){
    	instance_destroy();
    	exit;
    }
    if(place_meeting(x, y, Floor) || place_meeting(x, y, Bones)){
        instance_delete(id);
    }


#define gull_step
    enemyAlarms(2);
    enemySprites();
    enemyWalk(walkspd, maxspd);

#define gull_alarm0
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

#define gull_alarm1
     // Slash:
    gunangle = point_direction(x, y, target.x, target.y) + random_range(10, -10);
    with(scrEnemyShoot(EnemySlash, gunangle, 4)) damage = 2;

     // Visual/Sound Related:
    wkick = -3;
    wepangle = -wepangle;
    motion_add(gunangle, 4);
    sound_play(sndChickenSword);

#define gull_draw
    if(gunangle <= 180) draw_weapon(spr_weap, x, y, gunangle, wepangle, wkick, 1, image_blend, image_alpha);
    draw_self_enemy();
    if(gunangle > 180) draw_weapon(spr_weap, x, y, gunangle, wepangle, wkick, 1, image_blend, image_alpha);

#define pelican_step
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

#define pelican_alarm0
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

#define pelican_alarm1
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

#define pelican_draw
    var _charge = ((alarm1 > 0) ? alarm1 : 0),
        _angOff = sign(wepangle) * (60 * (_charge / chrg_time));

    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, wepangle - _angOff, wkick, 1, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();

#define cat_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);

#define cat_alarm0
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
    
#define cat_draw
    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();

#define draw_self_enemy()
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);

#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)
	draw_sprite_ext(_sprite, 0, _x - lengthdir_x(_wkick, _ang), _y - lengthdir_y(_wkick, _ang), 1, _flip, _ang + (_meleeAng * (1 - (_wkick / 20))), _blend, _alpha);

#define scrRight(_dir)
    if(_dir < 90 || _dir > 270) right = 1;
    if(_dir > 90 && _dir < 270) right = -1;

#define scrWalk(_walk, _dir)
    walk = _walk;
    speed = max(speed, friction);
    direction = _dir;
    gunangle = direction;
    scrRight(direction);

#define scrEnemyShoot(_object, _dir, _spd)
    with(instance_create(x, y, _object)){
        motion_add(_dir, _spd);
        image_angle = direction;
        hitid = other.hitid;
        team = other.team;
        creator = other;

        return id;
    }

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
    		    script_ref_call(variable_instance_get(self, "on_alarm" + string(i)));
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
    	else if(sprite_index = spr_idle) sprite_index = spr_walk;
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

#define target_in_distance
    var _dis = point_distance(x, y, target.x, target.y);
    return (instance_exists(target) && _dis > argument0 && _dis < argument1);

#define target_is_visible
	return (instance_exists(target) and !collision_line(x, y, target.x, target.y, Wall, false, false));

#define scrDefaultDrop
    scrPickups(50);

#define scrPickups(_dropchance)
    with(instance_nearest(x,y,Player)){
        var _need = 0;
        var w = wep;
        repeat(2){
            if(w = bwep && bwep = 0) _need += 0.5;
            else{
                if(ammo[weapon_get_type(w)] < typ_amax[weapon_get_type(w)] * 0.2) _need += 0.75;
                else{
                    if(ammo[weapon_get_type(w)] > typ_amax[weapon_get_type(w)] * 0.6) _need += 0.1;
                    else _need += 0.5;
                }
            }
            w = bwep;
        }
    
        if(random(100) < _dropchance * (_need + (skill_get(4) * 0.6))){
            if(random(maxhealth) > my_health && random(3) < 2 && GameCont.crown != 2) instance_create(other.x + random_range(-2, 2), other.y + random_range(-2, 2), HPPickup);
            else if(GameCont.crown != 5) instance_create(other.x + random_range(-2, 2), other.y + random_range(-2, 2), AmmoPickup);
        }
    }

#define z_engine
    z += zspeed * current_time_scale;
    zspeed -= zfric * current_time_scale;