#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.save = mod_variable_get("mod", "teassets", "save");

    global.newLevel = instance_exists(GenCont);
    global.area = ["secret", "coast", "oasis", "trench", "pizza"];
    global.effect_timer = 0;
    global.currentMusic = -1;
    global.bones = [];

     // Options Menu:
    global.option_NTTE_splat = 0;
    global.option_open = false;
    global.option_slct = -1;
    global.option_pop = 0;
    global.option_menu = [
        {   name : "Water Quality",
            type : opt_title,
            text : "Reduce to help#performance in coast"
            },
        {   name : "Main",
            type : opt_slider,
            text : "Water foam,#underwater visuals,#etc.",
            varname : "WaterQualityMain"
            },
        {   name : "Wading",
            type : opt_slider,
            text : "Top halves of#swimming objects",
            varname : "WaterQualityTop"
            }
        ];

    with(OptionMenu){
        if("name" not in self) name = "";
        if("type" not in self) type = opt_title;
        if("varname" not in self) varname = name;
        if("clicked" not in self) clicked = false;
        if(type >= 0 && varname not in opt){
            lq_set(opt, varname, 0);
        }
    }

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
            sndIDPDPortalSpawn
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
#macro sav global.save
#macro opt sav.option

#macro current_frame_active ((current_frame mod 1) < current_time_scale)

#macro UnlockCont instances_matching(CustomObject, "name", "UnlockCont")

#macro OptionOpen global.option_open
#macro OptionMenu global.option_menu
#macro OptionSlct global.option_slct
#macro OptionPop  global.option_pop
#macro opt_title -1
#macro opt_toggle 0
#macro opt_slider 1
#macro opt_sorter 2
//#macro opt_other 3

#define game_start
    with(UnlockCont) instance_destroy();
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
            
             // Spawn Baby Scorpions:
            with(Scorpion){
                if(random(4) < 1){
                    repeat(irandom_range(1,3)) obj_create(x, y, "BabyScorpion");
                }
            }
            
             // Spawn Golden Lads:
            with(GoldScorpion){
                if(random(4) < 1){
                    repeat(irandom_range(1,3)) obj_create(x, y, "GoldBabyScorpion");
                }
            }
            
             // Rare scorpion desert (EASTER EGG):
            if random(200) < 1{
                with(Bandit) if random(5) > 1{
                    var gold = (random(20) < 1);
                    
                     // Normal scorpion:
                    if random(5) < 2 instance_create(x, y, !gold ? Scorpion : GoldScorpion);
                    
                     // Baby scorpions:
                    else repeat(1 + irandom(2)) obj_create(x, y, !gold ? "BabyScorpion" : "GoldBabyScorpion");
                     
                    instance_delete(id);
                }
                
                 // Scary sound:
                sound_play_pitchvol(sndGoldTankShoot, 1, 0.6);
                sound_play_pitchvol(sndGoldScorpionFire, 0.8, 1.4);
            }

        case 2: /// SEWERS
             // Spawn Cats:
    	    with(Rat) if(random(8) < 1){
    	        obj_create(x, y, "Cat");
    	        instance_delete(self);
    	    }
            break;

        case 103: /// MANSIOM
             // Spawn Gold Mimic:
            with(instance_nearest(10016, 10016, GoldChest)){
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

        case "coast":
             // Cool parrot:
            if(GameCont.subarea == 1){
                with(instances_matching(instances_matching(CustomHitme, "name", "CoastDecal"), "shell", true)){
                    with(Pet_create(x, y, "Parrot")){
                        perched = other;
                    }
                }
            }

             // who's that bird? \\
            if(!unlock_get("parrot")){
                unlock_set("parrot", true); // It's a secret yo
                scrUnlock("PARROT", "FOR REACHING COAST", spr.Parrot[0].Portrait, sndRavenScreech);
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
    var _chance = 1/2;
    if(is_real(GameCont.area)){
        if(GameCont.area < 100) _chance /= 2;
        if(GameCont.area & 1) _chance /= 2;
    }
    if(random(1) < _chance){
        var _tries = 1000;
        while(_tries-- > 0){
            with(instance_random(TopSmall)){
                var p = instance_nearest(x, y, Player);
                if(point_distance(x + 8, y + 8, p.x, p.y) > 100){
                    obj_create(x, y, "BigDecal");
                    _tries = 0;
                }
            }
        }
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

     // Fixes weird delay thing:
    script_bind_step(bone_step, 0);

#define bone_step
    instance_destroy();

     // Reset Bone Ammo Indicator:
    global.bones = [];
    with(Player){
        var _wep = [wep, bwep];
        for(var i = 0; i < array_length(_wep); i++){
            if(is_object(_wep[i]) && wep_get(_wep[i]) == "crabbone"){
                if(_wep[i].ammo > 1){
                    array_push(global.bones, {
                        ammo : _wep[i].ammo,
                        index : index,
                        primary : !i,
                        steroids : (race == "steroids")
                        });
                }
            }
        }
    }

     // Draw Bone Ammo Indicators:
    var d = 0;
    if(instance_exists(TopCont)) d = TopCont.depth;
    if(instance_exists(GenCont)) d = GenCont.depth;
    if(instance_exists(LevCont)) d = LevCont.depth;
    if(d != 0) with(global.bones){
        script_bind_draw(ammo_draw_scrt, d - 1, index, primary, ammo, steroids);
    }

#define draw_gui_end
     // Custom Music Volume Fix:
    if(global.currentMusic != -1){
        sound_volume(global.currentMusic, audio_sound_get_gain(mus.Placeholder));
    }

#define draw_pause
    if(GameCont.area == "coast"){
        mod_variable_set("area", GameCont.area, "surfReset", true);
    }

     // Draw Bone Ammo Indicators:
    if(instance_exists(PauseButton)) with(global.bones){
        ammo_draw(index, primary, ammo, steroids);
    }
    
    draw_set_projection(0);

     // NTTE Menu Button:
    if(instance_exists(OptionMenuButton)){
        var _draw = true;
        with(OptionMenuButton) if(alarm_get(0) >= 0 || alarm_get(1) >= 0) _draw = false;
        if(_draw){
            var _x = (game_width / 2),
                _y = (game_height / 2) + 59,
                _hover = false;

             // Button Clicking:
            for(var i = 0; i < maxp; i++){
                if(point_in_rectangle(mouse_x[i] - view_xview[i], mouse_y[i] - view_yview[i], _x - 57, _y - 12, _x + 57, _y + 12)){
                    _hover = true;
                    if(button_pressed(i, "fire")){
                        global.option_open = true;
                        with(OptionMenuButton) instance_destroy();
                        sound_play(sndClick);
                        break;
                    }
                }
            }

             // Splat:
            global.option_NTTE_splat += (_hover ? 1 : -1) * current_time_scale;
            global.option_NTTE_splat = clamp(global.option_NTTE_splat, 0, sprite_get_number(sprMainMenuSplat) - 1);
            draw_sprite(sprMainMenuSplat, global.option_NTTE_splat, (game_width / 2), _y);

             // Gray Out Other Options:
            if(global.option_NTTE_splat > 0){
                var _spr = sprOptionsButtons;
                for(var j = 0; j < sprite_get_number(_spr); j++){
                    var _dx = (game_width / 2),
                        _dy = (game_height / 2) - 36 + (j * 24);

                    draw_sprite_ext(_spr, j, _dx, _dy, 1, 1, 0, make_color_rgb(155, 155, 155), 1);
                }
            }

             // Button:
            draw_sprite_ext(spr.OptionNTTE, 0, _x, _y, 1, 1, 0, (_hover ? c_white : make_color_rgb(155, 155, 155)), 1);
        }
    }

     // NTTE Options Menu:
    var _x = (game_width / 2),
        _y = (game_height / 2) - 40,
        _tooltip = "";

    draw_set_font(fntM);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    if(OptionOpen){
        OptionPop++;

         // Option Selecting & Splat:
        for(var i = 0; i < array_length(OptionMenu); i++){
            var _option = OptionMenu[i],
                _selected = (OptionSlct == i);

             // Select:
            for(var p = 0; p < maxp; p++) if(player_is_active(p)){
                var _vx = view_xview[p],
                    _vy = view_yview[p],
                    _mx = mouse_x[p] - _vx,
                    _my = mouse_y[p] - _vy;

                if(point_in_rectangle(_mx, _my, _x - 80, _y - 8, _x + 159, _y + 6)){
                    if(_option.type >= 0){
                        OptionSlct = i;
                    }

                    with(_option){
                         // Click:
                        if(!clicked){
                            if(button_pressed(p, "fire")){
                                clicked = true;
                                switch(type){
                                    case opt_slider:
                                        sound_play(sndSlider);
                                        break;

                                    default:
                                        sound_play(sndClick);
                                        break;
                                }
                            }
                        }
                        else if(!button_check(p, "fire")){
                            clicked = false;
                            switch(type){
                                case opt_slider:
                                    sound_play(sndSliderLetGo);
                                    break;
                            }
                        }

                         // Option Specifics:
                        switch(type){
                            case opt_toggle:
                                if(button_pressed(p, "fire")){
                                    lq_set(opt, varname, !lq_get(opt, varname));
                                }
                                break;

                            case opt_slider:
                                if(button_check(p, "fire") && clicked){
                                    var _slider = clamp(round(_mx - (_x + 40)) / 100, 0, 1);
                                    lq_set(opt, varname, _slider);
                                }
                                else{
                                    var _adjust = 0.1 * (button_pressed(p, "east") - button_pressed(p, "west"));
                                    if(_adjust != 0){
                                        lq_set(opt, varname, clamp(lq_get(opt, varname) + _adjust, 0, 2));
                                    }
                                }
                                break;
                        }

                         // Description on Hover:
                        if("text" in self){
                            if(!button_check(p, "fire")){
                                if(_mx < (game_width / 2) + 32){
                                    if(player_is_local_nonsync(p)){
                                        _tooltip = text;
                                    }
                                }
                            }
                        }
                    }
                }
                else _option.clicked = false;
            }

            with(_option){
                if("splat" not in self) splat = 0;
                appear = (i + 3);
                x = _x;
                y = _y;

                if(OptionPop >= appear){
                     // Appear Pop:
                    if(OptionPop == appear) sound_play_pitch(sndAppear, random_range(0.5, 1.5));
    
                     // Selection Splat:
                    splat += (_selected ? 1 : -1) * current_time_scale;
                    splat = clamp(splat, 0, sprite_get_number(sprMainMenuSplat) - 1);
                    if(splat > 0) with(other) draw_sprite(sprMainMenuSplat, other.splat, _x, _y);
                }
            }
            _y += 16;
        }

         // Option Text:
        for(var i = 0; i < array_length(OptionMenu); i++){
            var _option = OptionMenu[i],
                _selected = (OptionSlct == i);

            with(_option) if(OptionPop >= appear){
                 // Option Name:
                var _x = x - 80,
                    _y = y;

                if(_selected){
                    _y--;
                    draw_set_color(c_white);
                }
                else draw_set_color(make_color_rgb(125, 131, 141));
                if(OptionPop < (appear + 1)) _y++;

                draw_text_shadow(_x, _y, name);

                 // Option Specifics:
                _x += 124;
                var _value = lq_get(opt, varname);
                with(other) switch(other.type){
                    case opt_toggle:
                        draw_text_shadow(_x, _y, (_value ? "ON" : "OFF"));
                        break;

                    case opt_slider:
                        var _dx = _x - 5,
                            _dy = _y - 2,
                            w = 6 + (100 * _value),
                            h = sprite_get_height(sprOptionSlider);

                         // Slider:
                        draw_sprite(sprOptionSlider,      0,             _dx,           _dy);
                        draw_sprite_part(sprOptionSlider, 1, 0, 0, w, h, _dx - 5,       _dy - 6);
                        draw_sprite(sprSliderEnd,         1,             _dx + w - 2,   _y);

                         // Text:
                        draw_set_color(c_white);
                        draw_text_shadow(_x, _y + 1, string_format(_value * 100, 0, 0) + "%");
                        break;
                }
            }
        }

         // Tooltip:
        draw_reset_projection();
        if(_tooltip != ""){
            draw_tooltip(mouse_x_nonsync, mouse_y_nonsync, _tooltip);
        }

        if(instance_exists(menubutton)) OptionOpen = false;
    }
    else{
        OptionPop = false;
        OptionSlct = -1;
    }

    draw_reset_projection();

#define ammo_draw_scrt(_index, _primary, _ammo, _steroids)
    instance_destroy();
    ammo_draw(_index, _primary, _ammo, _steroids)

#define ammo_draw(_index, _primary, _ammo, _steroids)
    var _active = 0;
    for(var i = 0; i < maxp; i++) _active += player_is_active(i);

    draw_set_visible_all(0);
    draw_set_visible(_index, 1);
    draw_set_projection(0);

    var _x = (_primary ? 42 : 86),
        _y = 21;

    if(_active > 1) _x -= 19;

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    if(!_primary && !_steroids) draw_set_color(c_silver);

    draw_text_shadow(_x, _y, string(_ammo));

    draw_reset_projection();
    draw_set_visible_all(1);

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
    with instances_matching([Flame, TrapFire], "", null){
        if(sprite_index != sprFishBoost){
            if(image_index > 2){
                sprite_index = sprFishBoost;
                image_index = 0;

                 // FX:
                if(random(3) < 1){
                    var xx = x,
                        yy = y,
                        vol = 0.4;
                    if fork(){
                        repeat(1 + irandom(3)){
                            instance_create(xx, yy, Bubble);
                            
                            view_shake_max_at(xx, yy, 3);
                            sleep(6);
                            
                            sound_play_pitchvol(sndOasisPortal, 1.4 + random(0.4), vol);
                            audio_sound_set_track_position(sndOasisPortal, 0.52 + random(0.04));
                            vol -= 0.1;
                            
                            wait(10 + irandom(20));
                        }
                        exit;
                    }
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
    with(instances_matching(enemy, "underwater_sound_check", null)){
        underwater_sound_check = true;
        if(object_index != CustomEnemy){
            if(snd_hurt != -1) snd_hurt = sndOasisHurt;
            if(snd_dead != -1) snd_hurt = sndOasisDeath;
        }
    }

#define underwater_end_step
    instance_destroy();

     // Just in case - backup sound stopping:
    for(var i = 0; i < lq_size(global.waterSound); i++){
        var _sndOasis = asset_get_index(lq_get_key(global.waterSound, i));
        with(lq_get_value(global.waterSound, i)) sound_stop(self[0]);
    }

     // Bubbles:
    with(instances_matching(Dust, "waterbubble", null)){
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
    with(instances_matching([Ally, Sapling, Bandit, Grunt, Inspector, Shielder, EliteGrunt, EliteInspector, EliteShielder, PopoFreak, Salamander, Necromancer, Freak, Rat], "visible", true)){
        draw_sprite(sprPlayerBubble, -1, x, y);
        if(my_health <= 0) instance_create(x, y, BubblePop);
    }
    with(instances_matching_ne(Player, "race", "fish")) if(visible){
        draw_sprite(sprPlayerBubble, -1, x, y);
        if(my_health <= 0 && candie && spiriteffect <= 0){
            instance_create(x, y, BubblePop);
        }
    }
    with instances_matching_ne(instances_matching(CustomObject, "name", "Pet"), "pet", "Prism"){
        draw_sprite(sprPlayerBubble, -1, x, y);
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
                wait 0;
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

#define scrUnlock(_name, _text, _sprite, _sound)
     // Make Sure UnlockCont Exists:
    if(array_length(UnlockCont) <= 0){
        with(instance_create(0, 0, CustomObject)){
            name = "UnlockCont";

             // Visual:
            depth = UberCont.depth - 1;

             // Vars:
            persistent = true;
            unlock = [];
            unlock_sprit = sprMutationSplat;
            unlock_image = 0;
            unlock_delay = 50;
            unlock_index = 0;
            unlock_porty = 0;
            unlock_delay_continue = 0;
            splash_sprit = sprUnlockPopupSplat;
            splash_image = 0;
            splash_index = -1;
            splash_texty = 0;
            splash_timer = 0;
            splash_timer_max = 150;

             // Events:
            on_step = unlock_step;
            on_draw = unlock_draw;
        }
    }

     // Add New Unlock:
    var u = {
        nam : [_name, _name], // [splash popup, gameover popup]
        txt : _text,
        spr : _sprite,
        img : 0,
        snd : _sound
        };

    with(UnlockCont){
        array_push(unlock, u);
    }
    return u;

#define unlock_step
    if(instance_exists(Menu)){
        instance_destroy();
        exit;
    }

     // Animate Corner Popup:
    var _img = 0;
    if(instance_exists(Player)){
        if(splash_timer > 0){
            splash_timer -= current_time_scale;
    
            _img = sprite_get_number(splash_sprit) - 1;
    
             // Text Offset:
            if(splash_image >= _img && splash_texty > 0){
                splash_texty -= current_time_scale;
            }
        }
        else{
            splash_texty = 2;
    
             // Splash Next Unlock:
            if(splash_index < array_length(unlock) - 1){
                splash_index++;
                splash_timer = splash_timer_max;
            }
        }
    }
    splash_image += clamp(_img - splash_image, -1, 1) * current_time_scale;


     // Game Over Splash:
    if(instance_exists(UnlockScreen)) unlock_delay = 1;
    else if(!instance_exists(Player)){
        while(
            unlock_index >= 0                   &&
            unlock_index < array_length(unlock) &&
            unlock[unlock_index].spr == -1
        ){
            unlock_index++; // No Game Over Splash
        }

        if(unlock_index < array_length(unlock)){
             // Disable Game Over Screen:
            with(GameOverButton){
                if(game_letterbox) alarm_set(0, 30);
                else instance_destroy();
            }
            with(TopCont){
                gameoversplat = 0;
                go_addy1 = 9999;
                dead = false;
            }
    
             // Delay Unlocks:
            if(unlock_delay > 0){
                unlock_delay -= current_time_scale;
                var _delayOver = (unlock_delay <= 0);
    
                unlock_delay_continue = 20;
                unlock_porty = 0;
    
                 // Screen Dim + Letterbox:
                with(TopCont){
                    visible = _delayOver;
                    if(darkness){
                       visible = true;
                       darkness = 2;
                    }
                }
                game_letterbox = _delayOver;
    
                 // Sound:
                if(_delayOver){
                    sound_play(sndCharUnlock);
                    sound_play(unlock[unlock_index].snd);
                }
            }
            else{
                 // Animate Unlock Splash:
                var _img = sprite_get_number(unlock_sprit) - 1;
                unlock_image += clamp(_img - unlock_image, -1, 1) * current_time_scale;
    
                 // Portrait Offset:
                if(unlock_porty < 3){
                    unlock_porty += current_time_scale;
                }
    
                 // Next Unlock:
                if(unlock_delay_continue > 0) unlock_delay_continue -= current_time_scale;
                else for(var i = 0; i < maxp; i++){
                    if(button_pressed(i, "fire") || button_pressed(i, "okay")){
                        if(unlock_index < array_length(unlock)){
                            unlock_index++;
                            unlock_delay = 1;
                        }
                        break;
                    }
                }
            }
        }

         // Done:
        else{
            with(TopCont){
                go_addy1 = 55;
                dead = true;
            }
            instance_destroy();
        }
    }

#define unlock_draw
    draw_set_projection(0);

     // Game Over Splash:
    if(unlock_delay <= 0){
        if(unlock_image > 0){
            var _unlock = unlock[unlock_index],
                _nam = _unlock.nam[1],
                _spr = _unlock.spr,
                _img = _unlock.img,
                _x = game_width / 2,
                _y = game_height - 20;

             // Unlock Portrait:
            var _px = _x - 60,
                _py = _y + 9 + unlock_porty;

            draw_sprite(_spr, _img, _px, _py);

             // Splash:
            draw_sprite(unlock_sprit, unlock_image, _x, _y);

             // Unlock Name:
            var _tx = _x,
                _ty = _y - 92 + (unlock_porty < 2);

            draw_set_font(fntBigName);
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);

            var t = string_upper(_nam);
            draw_text_nt(_tx, _ty, t);

             // Unlocked!
            _ty += string_height(t) + 3;
            if(unlock_porty >= 3){
                d3d_set_fog(1, 0, 0, 0);
                draw_sprite(sprTextUnlocked, 4, _tx + 1, _ty);
                draw_sprite(sprTextUnlocked, 4, _tx,     _ty + 1);
                draw_sprite(sprTextUnlocked, 4, _tx + 1, _ty + 1);
                d3d_set_fog(0, 0, 0, 0);
                draw_sprite(sprTextUnlocked, 4, _tx,     _ty);
            }

             // Continue Button:
            if(unlock_delay_continue <= 0){
                var _cx = _x,
                    _cy = _y - 4,
                    _blend = make_color_rgb(102, 102, 102);

                for(var i = 0; i < maxp; i++){
                    if(point_in_rectangle(mouse_x[i] - view_xview[i], mouse_y[i] - view_yview[i], _cx - 64, _cy - 12, _cx + 64, _cy + 16)){
                        _blend = c_white;
                        break;
                    }
                }

                draw_sprite_ext(sprUnlockContinue, 0, _cx, _cy, 1, 1, 0, _blend, 1);
            }
        }
    }

     // Corner Popup:
    if(splash_image > 0){
         // Splash:
        var _x = game_width,
            _y = game_height;
    
        draw_sprite(splash_sprit, splash_image, _x, _y);

         // Unlock Text:
        if(splash_texty < 2){
            var _unlock = unlock[splash_index],
                _nam = _unlock.nam[0],
                _txt = _unlock.txt,
                _tx = _x - 4,
                _ty = _y - 16 + splash_texty;

            draw_set_font(fntM);
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);

             // Title:
            var t = _nam + " UNLOCKED";
            draw_text_nt(_tx, _ty, t);

             // Description:
            if(splash_texty <= 0){
                _ty += string_height(t);
                draw_text_nt(_tx, _ty, "@s" + _txt);
            }
        }
    }

    draw_reset_projection();

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

#define wep_get(_wep)
    return mod_script_call("mod", "teassets", "wep_get", _wep);

#define orandom(_n)
    return irandom_range(-_n,_n);

#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "teassets", "unlock_get", _unlock);
#define unlock_set(_unlock, _value)                                                             mod_script_call("mod", "teassets", "unlock_set", _unlock, _value);