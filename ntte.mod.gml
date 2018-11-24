#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");

    global.newLevel = instance_exists(GenCont);
    global.area = ["secret", "coast", "oasis", "trench", "pizza"];
    global.effect_timer = 0;
    global.currentMusic = -1;

     // Water Level Sounds:
    global.waterSound = {
        "sndOasisShoot" : [
            sndBloodLauncher,
            sndBouncerShotgun,
            sndBouncerSmg,
            sndClusterLauncher,
            sndCrossbow,
            sndDiscgun,
            sndDoubleMinigun,
            sndDragonStart,
            sndEnemyFire,
            sndFireShotgun,
            sndFlakCannon,
            sndFlare,
            sndFlareExplode,
            sndFrogPistol,
            sndGoldCrossbow,
            sndGoldDiscgun,
            sndGoldFrogPistol,
            sndGoldGrenade,
            sndGoldLaser,
            sndGoldLaserUpg,
            sndGoldMachinegun,
            sndGoldPistol,
            sndGoldPlasma,
            sndGoldPlasmaUpg,
            sndGoldRocket,
            sndGoldShotgun,
            sndGoldSlugger,
            sndGoldSplinterGun,
            sndGrenade,
            sndGrenadeRifle,
            sndGrenadeShotgun,
            sndGunGun,
            sndHeavyCrossbow,
            sndHeavyMachinegun,
            sndHeavyNader,
            sndHeavyRevoler,
            sndHyperLauncher,
            sndHyperRifle,
            sndIncinerator,
            sndMachinegun,
            sndMinigun,
            sndLaser,
            sndLaserUpg,
            sndLaserCannon,
            sndLaserCannonUpg,
            sndLightningHammer,
            sndLightningPistol,
            sndLightningPistolUpg,
            sndLightningRifle,
            sndLightningRifleUpg,
            sndPistol,
            sndPlasma,
            sndPlasmaUpg,
            sndPlasmaMinigun,
            sndPlasmaMinigunUpg,
            sndPlasmaRifle,
            sndPlasmaRifleUpg,
            sndPopgun,
            sndQuadMachinegun,
            sndRogueRifle,
            sndRustyRevolver,
            sndSeekerPistol,
            sndSeekerShotgun,
            sndShotgun,
            sndSlugger,
            sndSmartgun,
            sndSplinterGun,
            sndSplinterPistol,
            sndSuperCrossbow,
            sndSuperDiscGun,
            sndSuperSplinterGun,
            sndToxicLauncher,
            sndTripleMachinegun,
            sndUltraPistol,
            sndWaveGun
            ],
        "sndOasisMelee" : [
            sndBlackSword,
            sndBloodHammer,
            sndChickenSword,
            sndClusterOpen,
            sndEnergyHammer,
            sndEnergyHammerUpg,
            sndEnergyScrewdriver,
            sndEnergyScrewdriverUpg,
            sndEnergySword,
            sndEnergySwordUpg,
            sndFlamerStart,
            sndGoldScrewdriver,
            sndGoldWrench,
            sndGuitar,
            sndHammer,
            sndJackHammer,
            sndScrewdriver,
            sndShovel,
            sndToxicBoltGas,
            sndUltraShovel,
            sndWrench
            ],
        "sndOasisExplosion" : [
            sndBloodCannonEnd,
            sndBloodLauncherExplo,
            sndCorpseExplo,
            sndDevastator,
            sndDevastatorExplo,
            sndDevastatorUpg,
            sndExplosion,
            sndExplosionCar,
            sndExplosionL,
            sndExplosionXL,
            sndFlameCannonEnd,
            sndGoldNukeFire,
            sndLightningCannonEnd,
            sndLightningCannonUpg,
            sndNukeFire,
            sndNukeExplosion,
            sndPlasmaBigExplode,
            sndPlasmaBigUpg,
            sndPlasmaHuge,
            sndPlasmaHugeUpg,
            sndSuperFlakCannon,
            sndSuperFlakExplode
            ],
        "sndOasisExplosionSmall" : [
            sndBloodCannon,
            sndDoubleFireShotgun,
            sndDoubleShotgun,
            sndFlakExplode,
            sndFlameCannon,
            sndRocket,
            sndEraser,
            sndExplosionS,
            sndHeavySlugger,
            sndHyperSlugger,
            sndLightningCannon,
            sndLightningShotgun,
            sndLightningShotgunUpg,
            sndPlasmaBig,
            sndPlasmaHit,
            sndSawedOffShotgun,
            sndSuperBazooka,
            sndUltraCrossbow,
            sndUltraGrenade,
            sndUltraShotgun,
            sndUltraLaser,
            sndUltraLaserUpg
            ],
        "sndOasisPopo" : [
            sndEliteIDPDPortalSpawn,
            sndIDPDPortalSpawn,
            sndVanWarning
            ],
        "sndOasisPortal" : [
            sndLaserCannonCharge,
            sndPortalOpen
            ],
        "sndOasisChest" : [
            sndAmmoChest,
            sndBigCursedChest,
            sndBigWeaponChest,
            sndChest,
            sndCursedChest,
            sndEXPChest,
            sndGoldChest,
            sndHealthChest,
            sndHealthChestBig,
            sndWeaponChest
            ],
        "sndOasisHurt" : [
            sndMutant1Hurt,
            sndMutant2Hurt,
            sndMutant3Hurt,
            sndMutant4Hurt,
            sndMutant5Hurt,
            sndMutant6Hurt,
            sndMutant7Hurt,
            sndMutant8Hurt,
            sndMutant9Hurt,
            sndMutant10Hurt,
            sndMutant11Hurt,
            sndMutant12Hurt,
            sndMutant13Hurt,
            sndMutant14Hurt,
            sndMutant15Hurt,
            sndMutant16Hurt
            ],
        "sndOasisDeath" : [
            sndMutant1Dead,
            sndMutant2Dead,
            sndMutant3Dead,
            sndMutant4Dead,
            sndMutant5Dead,
            sndMutant6Dead,
            sndMutant7Dead,
            sndMutant8Dead,
            sndMutant9Dead,
            sndMutant10Dead,
            sndMutant11Dead,
            sndMutant12Dead,
            sndMutant13Dead,
            sndMutant14Dead,
            sndMutant15Dead,
            sndMutant16Dead,
            sndSuperSlugger
            ],
        "sndOasisHorn" : [
            sndVenuz
            ]
    };
    for(var i = 0; i < lq_size(global.waterSound); i++){
        var s = lq_get_value(global.waterSound, i);
        for(var j = 0; j < array_length(s); j++){
            s[j] = [s[j], 1];
        }
    }

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus

#macro current_frame_active ((current_frame mod 1) < current_time_scale)

#define game_start
    mod_variable_set("area", "trench", "trench_visited", []);

#define level_start // game_start but every level
    switch(GameCont.area){
        case 1: /// DESERT
             // Disable Oasis Skip:
    		with(instance_create(0, 0, AmmoChest)){
    			visible = 0;
    			mask_index = mskNone;
    		}
    
    	     // Spawn Sharky Skull on 1-3:
    		with(BigSkull) instance_delete(id);
    		if(instance_exists(Floor)){
        		if(GameCont.subarea == 3){
        		    var _spawned = false;
        		    do{
            		    with(instance_random(Floor)){
                            if(point_distance(x, y, 10016, 10016) > 48){
                                if(!place_meeting(x, y, prop) && !place_meeting(x, y, chestprop) && !place_meeting(x, y, Wall)){
            		                obj_create(x + 16, y + 16, "CoastBossBecome");
            		                _spawned = true;
                                }
                            }
            		    }
        		    }
        		    until _spawned;
        		}
    
                 // Consistently Spawning Crab Skeletons:
                if(!instance_exists(BonePile)){
        		    var _spawned = false;
                    do{
                        with(instance_random(Floor)){
                            if(point_distance(x, y, 10016, 10016) > 48){
                                if(!place_meeting(x, y, prop) && !place_meeting(x, y, chestprop) && !place_meeting(x, y, Wall)){
                                    instance_create(x + 16, y + 16, BonePile);
            		                _spawned = true;
                                }
                            }
                        }
                    }
                    until _spawned;
                }
    		}
    
             // Crab Skeletons Drop Bones:
            with(BonePile) with(obj_create(x, y, "BoneSpawner")) creator = other;
            break;

        case 2: /// SEWERS
             // Spawn Cats:
    	    with(Rat) if(random(8) < 1){
    	        obj_create(x, y, "Cat");
    	        instance_delete(self);
    	    }
            break;

        case 103: /// MANSIOM
             // Spawn Gold Mimic:
            with(instance_nearest(x, y, GoldChest)){
                with(Pet_create(x, y, "Mimic")){
                    wep = decide_wep_gold(18, 18 + GameCont.loops, 0);
                }
                instance_delete(self);
            }
            break;

        case 104: /// CURSED CAVES
             // Spawn Prism:
            with(BigCursedChest) {
                Pet_create(x, y, "Prism");
            }
            break;

        case "trench":
            break;
    }

     // Spawn Mortars:
	with(LaserCrystal){
	    if(random(4) < 1){
	        obj_create(x, y, "Mortar");
	        instance_delete(self);
	    }
	}
	
     // Spawn Cursed Mortars:
	with(InvLaserCrystal){
	    if(random(4) < 1){
	        obj_create(x, y, "InvMortar");
	        instance_delete(self);
	    }
	}
	
	 // Sewer manhole:
	with(PizzaEntrance){
	    with obj_create(x,y,"Manhole") toarea = "pizza";
	    instance_delete(id);
	}
	
	 // OG gators:
	with(Gator){
	    with instance_create(x,y,GatorSmoke) image_speed = 0.4;
	    instance_delete(id);
	}

     // Big Decals:
	with(TopSmall) if(random(200) < 1) {
		obj_create(x, y, "BigDecal");
		break;
	}
    
     // Spawn CoolGuy:
    if(GameCont.area = "pizza") with(TV) {
        var f = instance_nearest(x, y + 48, Floor);
        Pet_create(x, f.y + 16, "CoolGuy");
    }

     // Visibilize Pets:
    with(instances_matching(CustomObject, "name", "Pet")) visible = true;

#define step
     // Pet Slots:
    with(instances_matching(Player, "pet", null)) pet = [noone];

     // GENERATION CODE //
    if(instance_exists(GenCont) || instance_exists(Menu)) global.newLevel = 1;
    else if(global.newLevel){
        global.newLevel = 0;
        level_start();
    }

     // Call Area Events (Not built into area mods):
    var a = array_find_index(global.area, GameCont.area);
    if(a >= 0){
        var _area = global.area[a];

        if(!instance_exists(GenCont)){
             // Step:
            mod_script_call("area", _area, "area_step");

             // Floor FX:
            if(global.effect_timer <= 0){
                global.effect_timer = random(60);
                if(mod_script_exists("area", _area, "area_effect")){
                     // Pick Random Player's Screen:
                    do var i = irandom(maxp - 1);
                    until player_is_active(i);
                    var _vx = view_xview[i], _vy = view_yview[i];

                     // FX:
                    var t = mod_script_call("area", _area, "area_effect", _vx, _vy);
                    if(!is_undefined(t) && t > 0) global.effect_timer = t;
                }
            }
            else global.effect_timer -= current_time_scale;
        }
        else global.effect_timer = 0;

         // Music / Ambience:
        if(instance_exists(GenCont) || instance_exists(mutbutton)){
             // Music:
            var _mus = -1;
            if(mod_script_exists("area", _area, "area_music")){
                _mus = mod_script_call("area", _area, "area_music");

                 // Custom Music:
                if(_mus >= 300000){
                    if(!audio_is_playing(mus.Placeholder)){
                        sound_play_music(-1);
                        sound_play_music(mus.Placeholder);
                    }
                }

                 // Normal Music:
                else{
                    sound_play_music(_mus);
                    _mus = -1;
                }
            }

             // Set Custom Music:
            if(global.currentMusic != _mus){
                sound_stop(global.currentMusic);
                global.currentMusic = _mus;
            }

             // Ambience:
            if(mod_script_exists("area", _area, "area_ambience")){
                sound_play_ambient(mod_script_call("area", _area, "area_ambience"));
            }
        }
    }
    else sound_stop(mus.Placeholder);

     // Fix for Custom Music:
    if(audio_is_playing(mus.Placeholder)){
        if(!audio_is_playing(global.currentMusic)){
            sound_loop(global.currentMusic);
        }
    }
    else if(global.currentMusic != -1){
        sound_stop(global.currentMusic);
        global.currentMusic = -1;
    }

    /// Tiny Spiders (New Cocoons):
         // Spider Cocoons:
        with(Cocoon){ 
        	obj_create(x, y, "NewCocoon");
        	instance_delete(id);
        }

         // Appropriate Corpses:
        with(instances_matching(instances_matching_le(Spider, "my_health", 0), "corpse", 0)){
        	with(scrCorpse(direction, speed)){
        		image_xscale = other.image_xscale;
        		image_yscale = other.image_yscale;
        	}
        }

#define draw_gui_end
     // Custom Music Volume Fix:
    if(global.currentMusic != -1){
        sound_volume(global.currentMusic, audio_sound_get_gain(mus.Placeholder));
    }

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

#define underwater_step /// Call from underwater area step events
     // Lightning:
    with(Lightning){
        image_index -= image_speed * 0.75;

         // Zap:
        if(image_index > image_number - 1){
            with(instance_create(x, y, EnemyLightning)){
                image_speed = 0.3;
                image_angle = other.image_angle;
                image_xscale = other.image_xscale;
                if(random(8) < 1){
                    sound_play_hit(sndLightningHit,0.2);
                    with(instance_create(x, y, GunWarrantEmpty)){
                        image_angle = other.direction;
                    }
                }
                else if(random(3) < 1){
                    instance_create(x + orandom(18), y + orandom(18), PortalL);
                }
            }
            instance_destroy();
        }
    }

     // Flames Boil Water:
    with(Flame){
        if(sprite_index != sprFishBoost){
            if(image_index > 2){
                sprite_index = sprFishBoost;
                image_index = 0;

                 // FX:
                if(random(3) < 1){
                    instance_create(x, y, Bubble);
                    sound_play_pitchvol(sndOasisPortal, 1.4 + random(0.4), 0.4);
                }
            }
        }

         // Hot hot hot:
        else if(current_frame_active && random(100) < 1){
            instance_create(x, y, Bubble);
        }

         // Go away ugly smoke:
        if(place_meeting(x, y, Smoke)){
            with(instance_nearest(x, y, Smoke)) instance_destroy();
            if(random(2) < 1) with(instance_create(x, y, Bubble)){
                motion_add(other.direction, other.speed / 2);
            }
        }
    }

     // Chest Stuff:
    with(instances_matching(ChestOpen, "waterchest", null)){
        waterchest = true;
        repeat(3) instance_create(x, y, Bubble);
        if(sprite_index == sprWeaponChestOpen) sprite_index = sprClamChestOpen;
    }

    script_bind_step(underwater_sound, 0);
    script_bind_draw(underwater_draw, -3);
    script_bind_end_step(underwater_end_step, 0);

#define underwater_sound
    instance_destroy();

     // Replace Sounds w/ Oasis Sounds:
    for(var i = 0; i < lq_size(global.waterSound); i++){
        var _sndOasis = asset_get_index(lq_get_key(global.waterSound, i));
        with(lq_get_value(global.waterSound, i)){
            var _snd = self;
            if(audio_is_playing(_snd[0])){
                if(_snd[1] < current_frame){
                    sound_play_pitchvol(_sndOasis, 1, 2);
                    _snd[1] = current_frame + 1;
                }
                sound_stop(_snd[0]);
            }
        }
    }
    with(instances_matching_ne(enemy, "snd_hurt", sndOasisHurt, -1)) snd_hurt = sndOasisHurt;
    with(instances_matching_ne(enemy, "snd_dead", sndOasisDeath, -1)) snd_dead = sndOasisDeath;

#define underwater_end_step
    instance_destroy();

     // Just in case - backup sound stopping:
    for(var i = 0; i < lq_size(global.waterSound); i++){
        var _sndOasis = asset_get_index(lq_get_key(global.waterSound, i));
        with(lq_get_value(global.waterSound, i)) sound_stop(self[0]);
    }

     // Bubbles:
    with(Dust){
        instance_create(x, y, Bubble);
        instance_destroy();
    }
    with(instances_matching(Smoke, "waterbubble", null)){
        waterbubble = true;
        instance_create(x, y, Bubble);
    }
    with(instances_matching(BoltTrail, "waterbubble", null)){
        if(image_xscale != 0 && random(4) < 1){
            waterbubble = true;
            instance_create(x, y, Bubble);
        }
        else waterbubble = false;
    }

#define underwater_draw
    instance_destroy();

     // Air Bubbles:
    with(instances_matching([Ally, Sapling, Bandit, Grunt, Inspector, Shielder, EliteGrunt, EliteInspector, EliteShielder, PopoFreak], "visible", true)){
        draw_sprite(sprPlayerBubble, -1, x, y);
        if(my_health <= 0) instance_create(x, y, BubblePop);
    }
    with(instances_matching_ne(Player, "race", "fish")) if(visible){
        draw_sprite(sprPlayerBubble, -1, x, y);
        if(my_health <= 0 && candie && spiriteffect <= 0){
            instance_create(x, y, BubblePop);
        }
    }

     // :
    d3d_set_fog(1, make_color_rgb(255, 70, 45), 0, 0);
    draw_set_blend_mode(bm_add);
    with(Flame) if(sprite_index != sprFishBoost){
        var s = 1.5,
            a = 0.1;

        draw_sprite_ext(sprDragonFire, image_index + 2, x, y, image_xscale * s, image_yscale * s, image_angle, image_blend, image_alpha * a);
    }
    draw_set_blend_mode(bm_normal);
    d3d_set_fog(0, 0, 0, 0);


#define scrBossIntro(_name, _sound, _music)
    var _path = "sprites/intros/",
        _lastSub = GameCont.subarea; // !!!

    if(_name != ""){
        with(instance_create(0, 0, BanditBoss)){
            sprite_replace_image(sprBossIntro,          _path + "spr" + _name + "Main.png", 0);
            sprite_replace_image(sprBossIntroBackLayer, _path + "spr" + _name + "Back.png", 0);
            sprite_replace_image(sprBossName,           _path + "spr" + _name + "Name.png", 0);
            event_perform(ev_alarm, 6);
            sound_stop(sndBigBanditIntro);
            instance_delete(id);
            if(fork()){
                wait 1;
                sprite_restore(sprBossIntro);
                sprite_restore(sprBossIntroBackLayer);
                sprite_restore(sprBossName);
                exit;
            }
        }
    }
    sound_play(_sound);
    sound_play_music(_music);
    sound_stop(global.currentMusic);
    GameCont.subarea = _lastSub; // !!!

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

#define instance_random(_obj)
	if(instance_exists(_obj)){
		var i = instances_matching(_obj, "", undefined);
		return i[irandom(array_length(i) - 1)];
	}
	return noone;

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

#define obj_create(_x, _y, _obj)
    return mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj);

#define Pet_create(_x, _y, _pet)
    return mod_script_call("mod", "telib", "Pet_create", _x, _y, _pet);

#define scrSetPet(_pet)
    return mod_script_call("mod", "teassets", "scrSetPet", _pet);
    
#define orandom(_n)
    return irandom_range(-_n,_n);