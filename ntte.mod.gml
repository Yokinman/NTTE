#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");
    global.save = mod_variable_get("mod", "teassets", "save");

    global.newLevel = instance_exists(GenCont);
    global.area = ["coast", "oasis", "trench", "pizza", "secret"];
    global.effect_timer = 0;
    global.current = {
        mus : { snd: -1, vol: 1, pos: 0, hold: mus.Placeholder },
        amb : { snd: -1, vol: 1, pos: 0, hold: mus.amb.Placeholder }
    };
    global.bones = [];

     // Make Custom CampChars for:
    global.campchar = ["parrot"];

     // Options Menu:
    global.option_NTTE_splat = 0;
    global.option_open = false;
    global.option_slct = -1;
    global.option_pop = 0;
    global.option_menu = [
        {
            name : "Use Shaders",
            type : opt_toggle,
            text : "Used for certain visuals#@sShaders may cause the game# to crash on older computers!",
            varname : "allowShaders"
            },
        {   name : "Water Quality :",
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
            text : "Objects in the water",
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

     // Charm:
    global.surfCharm = -1;
    global.eye_shader = -1;
    global.charm = ds_list_create();
    global.charm_step = noone;

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
#macro anim_end (image_index > image_number - 1 + image_speed)

#macro cMusic global.current.mus
#macro cAmbience global.current.amb

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

#macro EyeShader global.eye_shader
#macro surfCharm global.surfCharm

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
                    repeat(irandom_range(1,3)) obj_create(x, y, "BabyScorpionGold");
                }
            }
            
             // Rare scorpion desert (EASTER EGG):
            if random(200) < 1{
                with(Bandit) if random(5) > 1{
                    var gold = (random(20) < 1);
                    
                     // Normal scorpion:
                    if random(5) < 2 instance_create(x, y, !gold ? Scorpion : GoldScorpion);
                    
                     // Baby scorpions:
                    else repeat(1 + irandom(2)) obj_create(x, y, !gold ? "BabyScorpion" : "BabyScorpionGold");
                     
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

        case 4: /// CAVES
             // Spawn Mortars:
        	with(instances_matching(LaserCrystal, "mortar_check", null, false)){
        	    mortar_check = true;
        	    if(random(4) < 1){
        	        obj_create(x, y, "Mortar");
        	        instance_delete(self);
        	    }
        	}
            break;

        case 103: /// MANSIOM  its MANSION idiot, who wrote this
             // Spawn Gold Mimic:
            with(instance_nearest(10016, 10016, GoldChest)){
                with(Pet_create(x, y, "Mimic")){
                    wep = decide_wep_gold(18, 18 + GameCont.loops, 0);
                }
                instance_delete(self);
            }
            break;

        case 104: /// CURSED CAVES
             // Spawn Cursed Mortars:
        	with(instances_matching(InvLaserCrystal, "mortar_check", null, false)){
        	    mortar_check = true;
        	    if(random(4) < 1){
        	        obj_create(x, y, "InvMortar");
        	        instance_delete(self);
        	    }
        	}

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
            if(GameCont.subarea == 1 && instance_exists(Floor) && instance_exists(Player)){
                var f = noone,
                    p = instance_nearest(10016, 10016, Player),
                    _tries = 1000;

                do f = instance_random(Floor);
                until (point_distance(f.x + 16, f.y + 16, p.x, p.y) > 128 || _tries-- <= 0);

                Pet_create(f.x + 16, f.y + 16, "Octo");
            }
            break;
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
        if(GameCont.area < 100){
            _chance /= 2;
            if(GameCont.area & 1) _chance /= 2;
        }
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
    script_bind_begin_step(begin_step, 0);
    script_bind_end_step(end_step, 0);

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
    if(a < 0 && GameCont.area = 100) a = array_find_index(global.area, GameCont.lastarea);
    if(a >= 0){
        var _area = global.area[a];

         // Floor Setup:
        var _scrt = "area_setup_floor";
        if(mod_script_exists("area", _area, _scrt)){
            with(instances_matching(Floor, "ntte_setup", null)){
                ntte_setup = true;
                mod_script_call("area", _area, _scrt, (object_index == FloorExplo));
            }
        }

        if(!instance_exists(GenCont)){
             // Step(s):
            mod_script_call("area", _area, "area_step");
            if(mod_script_exists("area", _area, "area_begin_step")){
                script_bind_begin_step(area_step, 0, _area);
            }
            if(mod_script_exists("area", _area, "area_end_step")){
                script_bind_end_step(area_step, 0, _area);
            }

             // Floor FX:
            if(global.effect_timer <= 0){
                global.effect_timer = random(60);

                var _scrt = "area_effect";
                if(mod_script_exists("area", _area, _scrt)){
                     // Pick Random Player's Screen:
                    do var i = irandom(maxp - 1);
                    until player_is_active(i);
                    var _vx = view_xview[i], _vy = view_yview[i];

                     // FX:
                    var t = mod_script_call("area", _area, _scrt, _vx, _vy);
                    if(!is_undefined(t) && t > 0) global.effect_timer = t;
                }
            }
            else global.effect_timer -= current_time_scale;
        }
        else global.effect_timer = 0;

         // Music / Ambience:
        if(instance_exists(GenCont) || instance_exists(mutbutton)){
            var _scrt = ["area_music", "area_ambience"];
            for(var i = 0; i < lq_size(global.current); i++){
                var _type = lq_get_key(global.current, i);
                if(mod_script_exists("area", _area, _scrt[i])){
                    var s = mod_script_call("area", _area, _scrt[i]);
                    if(!is_array(s)) s = [s];

                    while(array_length(s) < 3) array_push(s, -1);
                    if(s[1] == -1) s[1] = 1;
                    if(s[2] == -1) s[2] = 0;

                    sound_play_ntte(_type, s[0], s[1], s[2]);
                }
            }
        }
    }

     // Fix for Custom Music/Ambience:
    for(var i = 0; i < lq_size(global.current); i++){
        var _type = lq_get_key(global.current, i),
            c = lq_get_value(global.current, i);

        if(audio_is_playing(c.hold)){
            if(!audio_is_playing(c.snd)){
                audio_sound_set_track_position(audio_play_sound(c.snd, 0, true), c.pos);
            }
        }
        else audio_stop_sound(c.snd);
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

     // Charm Step:
    if(!instance_exists(global.charm_step)){
        global.charm_step = script_bind_end_step(charm_step, 0);
        with(global.charm_step) persistent = true;
    }

#define sound_play_ntte /// sound_play_ntte(_type, _snd, ?_vol = undefined, ?_pos = undefined)
    var _type = argument[0], _snd = argument[1];
var _vol = argument_count > 2 ? argument[2] : undefined;
var _pos = argument_count > 3 ? argument[3] : undefined;
    if(is_undefined(_vol)) _vol = 1;
    if(is_undefined(_pos)) _pos = 0;

    var c = lq_get(global.current, _type);

     // Stop Previous Track:
    if(_snd != c.snd){
        audio_stop_sound(c.snd);
    }

     // Set Stuff:
    c.snd = _snd;
    c.vol = _vol;
    c.pos = _pos;

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

#define draw_gui_end
     // Custom Sound Volume:
    for(var i = 0; i < array_length(global.current); i++){
        var c = lq_get_value(global.current, i);
        if(c.snd != -1){
            audio_sound_gain(c.snd, audio_sound_get_gain(c.hold) * c.vol, 0);
        }
    }

#define area_step(_area)
    var _scrt = "step";
    switch(object_index){
        case CustomBeginStep:
            _scrt = "begin_step";
            break;

        case CustomEndStep:
            _scrt = "end_step";
            break;
    }

    if(fork()){ // Fork for error handling
        mod_script_call("area", _area, "area_" + _scrt);
        exit;
    }

    instance_destroy();

#define begin_step
    instance_destroy();

     // Custom CampChars:
    if(instance_exists(Menu)){
         // Make Custom CampChars:
        for(var i = 0; i < array_length(global.campchar); i++){
            var n = global.campchar[i];
            if(mod_exists("race", n) && unlock_get(n)){
                if(array_length(instances_matching(CampChar, "race", n)) <= 0){
                    with(CampChar_create(64, 48, n)){
                         // Poof in:
                        repeat(8) with(instance_create(x, y + 4, Dust)){
                            motion_add(random(360), 3);
                            depth = other.depth - 1;
                        }
                    }
                }
            }
        }

         // Reset Camera:
        with(instances_matching(instances_matching(CampChar, "num", 17), "move_back", true)){
            move_back = false;
            x = xstart;
            y = ystart;
        }

         // CampChar Stuff:
        for(var i = 0; i < maxp; i++){
            if(player_is_local_nonsync(i)){
                var r = player_get_race(i)
                if(array_find_index(global.campchar, r) >= 0){
                    with(instances_matching(CampChar, "race", player_get_race(i))){
                         // Move Camera:
                        with(instances_matching(CampChar, "num", 17)){
                            x = other.x;
                            y = other.y;
                            move_back = true;
                        }

                         // Manually Animate:
                        if(anim_end){
                            if(sprite_index != spr_menu){
                                if(sprite_index == spr_to){
                                    sprite_index = spr_menu;
                                }
                                else{
                                    sprite_index = spr_to;
                                }
                            }
                            image_index = 0;
                        }
                    }
                }
            }
        }
    }

#define end_step
    instance_destroy();

     // Convert WepPickups to Pickup Indicators:
    with(instances_matching(WepPickup, "convert_pickup_indicator", true)){
        var v = ["creator", "mask_index", "xoff", "yoff"],
            _save = {};

        with(v) lq_set(_save, self, variable_instance_get(other, self));
        instance_change(CustomObject, true);
        with(v) variable_instance_set(other, self, lq_get(_save, self));

        name = "PickupIndicator";
        on_end_step = pickup_indicator_end_step;
    }

     // Make Game Display Pickup Indicators:
    with(instances_matching(Player, "nearwep", noone)){
        if(place_meeting(x, y, CustomObject)){
            with(nearest_instance(x, y, instances_matching(instances_matching(CustomObject, "name", "PickupIndicator"), "visible", true))){
                if(place_meeting(x, y, other)){
                    x += xoff;
                    y += yoff;
                    with(other){
                        nearwep = other;
                        if(canpick && button_pressed(index, "pick")){
                            other.pick = index;
                        }
                    }
                }
            }
        }
    }

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

#define draw_pause
     // Reset Stuff:
    if(GameCont.area == "coast"){
        mod_variable_set("area", GameCont.area, "surfReset", true);
    }
    with(instances_matching(CustomDraw, "name", "draw_pit")){
        mod_variable_set("area", "trench", "surf_reset", true);
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
                        if(type >= 0){
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
                            if(!button_check(p, "fire") || type == opt_title){
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
        var _titleFound = false;
        for(var i = 0; i < array_length(OptionMenu); i++){
            var _option = OptionMenu[i],
                _selected = (OptionSlct == i);

            with(_option) if(OptionPop >= appear){
                 // Option Name:
                var _x = x - 80,
                    _y = y,
                    _name = name;

                if(type == opt_title){
                    _titleFound = true;
                    draw_set_color(c_white);
                }
                else if(_titleFound){
                    _name = " " + _name;
                }

                if(_selected){
                    _y--;
                    draw_set_color(c_white);
                }
                else draw_set_color(make_color_rgb(125, 131, 141));
                if(OptionPop < (appear + 1)) _y++;

                draw_text_shadow(_x, _y, _name);

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

    with(script_bind_step(underwater_sound, 0)) name = script[2];
    with(script_bind_draw(underwater_draw, -3)) name = script[2];
    with(script_bind_end_step(underwater_end_step, 0)) name = script[2];

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
    with(instances_matching(hitme, "spr_bubble", null)){
        spr_bubble = -1;
        spr_bubble_pop = -1;
        spr_bubble_x = 0;
        spr_bubble_y = 0;
        switch(object_index){
            case Ally:
            case Sapling:
            case Bandit:
            case Grunt:
            case Inspector:
            case Shielder:
            case EliteGrunt:
            case EliteInspector:
            case EliteShielder:
            case PopoFreak:
            case Necromancer:
            case Freak:
            case FastRat:
            case Rat:
                spr_bubble = sprPlayerBubble;
                spr_bubble_pop = sprPlayerBubblePop;
                break;

            case Player:
                if(race != "fish"){
                    spr_bubble = sprPlayerBubble;
                    spr_bubble_pop = sprPlayerBubblePop;
                }
                break;

            case Salamander:
                spr_bubble = spr.BigBubble;
                spr_bubble_pop = spr.BigBubblePop;
                break;

            case Ratking:
            case RatkingRage:
                spr_bubble = spr.BigBubble;
                spr_bubble_pop = spr.BigBubblePop;
                spr_bubble_y = 2;
                break;

            case FireBaller:
            case SuperFireBaller:
                spr_bubble = spr.BigBubble;
                spr_bubble_pop = spr.BigBubblePop;
                spr_bubble_y = -6;
                break;
        }
    }
    with(instances_matching(instances_matching_ne(instances_seen(hitme, 16), "spr_bubble", -1), "visible", true)){
        draw_sprite(spr_bubble, -1, x + spr_bubble_x, y + spr_bubble_y);

         // Death Pop:
        if(my_health <= 0){
            if(!instance_is(self, Player) || (candie && spiriteffect <= 0)){
                instance_create(x + spr_bubble_x, y + spr_bubble_y, BubblePop);
            }
        }
    }

     // Pet Bubbles:
    with(instances_matching(instances_matching_ne(instances_matching(CustomObject, "name", "Pet"), "pet", "Prism", "Octo"), "visible", true)){
        draw_sprite(sprPlayerBubble, -1, x, y);
    }

     // Boiling Water:
    d3d_set_fog(1, make_color_rgb(255, 70, 45), 0, 0);
    draw_set_blend_mode(bm_add);
    with(Flame) if(sprite_index != sprFishBoost){
        var s = 1.5,
            a = 0.1;

        draw_sprite_ext(sprDragonFire, image_index + 2, x, y, image_xscale * s, image_yscale * s, image_angle, image_blend, image_alpha * a);
    }
    draw_set_blend_mode(bm_normal);
    d3d_set_fog(0, 0, 0, 0);


#define CampChar_create(_x, _y, _race)
    _race = race_get_name(_race);
    with(instance_create(_x, _y, CampChar)){
        num = _race;
        race = _race;

         // Visual:
        spr_slct = race_get_sprite(_race, sprFishMenu);
        spr_menu = race_get_sprite(_race, sprFishMenuSelected);
        spr_to   = race_get_sprite(_race, sprFishMenuSelect);
        spr_from = race_get_sprite(_race, sprFishMenuDeselect);
        sprite_index = spr_slct;

         // Auto Offset:
        var _tries = 1000;
        while(_tries-- > 0){
             // Move Somewhere:
            x = xstart;
            y = ystart;
            move_contact_solid(random(360), random_range(32, 64) + random(random(64)));
            x = round(x);
            y = round(y);

             // Safe:
            var o = 12;
            if(!collision_ellipse(x - o, y - o, x + o, y + o, CampChar, true, true) && !place_meeting(x, y, TV)){
                break;
            }
        }

        return id;
    }

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
    sound_play_ntte("mus", _music);
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

#define scrPickupIndicator(_text)
    with(instance_create(0, 0, WepPickup)){
        name = _text;
        type = 0;
        creator = other;
        xoff = 0;
        yoff = 0;
        pick = -1;
        convert_pickup_indicator = true;
        mask_index = mskNone;
        visible = 0;

        return id;
    }

#define pickup_indicator_end_step
    pick = -1;

     // Follow Creator:
    var c = creator;
    if(c != noone){
        if(instance_exists(c)){
            x = c.x;
            y = c.y;
            persistent = c.persistent;
            image_index = c.image_index;
            image_angle = c.image_angle;
            image_xscale = c.image_xscale;
            image_yscale = c.image_yscale;
            if(mask_index == mskNone){
                mask_index = c.mask_index;
                if(mask_index == -1) mask_index = c.sprite_index;
            }
            if("pickup_indicator" not in c || !instance_exists(c.pickup_indicator)){
                c.pickup_indicator = id;
            }
        }
        else instance_destroy();
    }

#define alarm_creator(_object, _alarm)
  /// Calls alarm event and sets creator on objects that were spawned during it
    with(instances_matching(_object, "creator", null)) creator = noone;
    event_perform(ev_alarm, _alarm);
    var i = instances_matching(_object, "creator", null);
    with(i) creator = other;
    return i;

#define charm_draw(_inst)
    instance_destroy();

     // Surface Setup:
    var _surf = surfCharm,
        _surfw = game_width,
        _surfh = game_height,
        _surfx = view_xview_nonsync,
        _surfy = view_yview_nonsync;

    if(!surface_exists(_surf)){
        _surf = surface_create(_surfw, _surfh)
        surfCharm = _surf;
    }

     // Draw Charmed Enemies to Surface:
    surface_set_target(_surf);
    draw_clear_alpha(0, 0);
    with(instances_seen(_inst, 24)){
        var _x = x - _surfx,
            _y = y - _surfy,
            _spr = sprite_index,
            _img = image_index;

        if(object_index == TechnoMancer){ // JW help me
            _spr = drawspr;
            _img = drawimg;
            if(_spr == sprTechnoMancerAppear || _spr == sprTechnoMancerFire1 || _spr == sprTechnoMancerFire2 || _spr == sprTechnoMancerDisappear){
                texture_set_stage(0, sprite_get_texture(sprTechnoMancerActivate, 8));
                draw_sprite_ext(sprTechnoMancerActivate, 8, _x, _y, image_xscale * (("right" in self) ? right : 1), image_yscale, image_angle, image_blend, image_alpha);
            }
        }

        draw_sprite_ext(_spr, _img, _x, _y, image_xscale * (("right" in self) ? right : 1), image_yscale, image_angle, image_blend, image_alpha);
    }
    surface_reset_target();

     // Outlines:
    var _local = -1;
    for(var i = 0; i < maxp; i++){
        if(player_is_local_nonsync(i)){
            _local = i;
            break;
        }
    }
    if(player_get_outlines(_local)){
        d3d_set_fog(1, player_get_color(_local), 0, 0);
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

     // Eye Shader:
    if(opt.allowShaders){
        if(global.eye_shader == -1){
            global.eye_shader = shader_create(
                "/// Vertex Shader ///

                struct VertexShaderInput
                {
                    float4 vPosition : POSITION;
                    float2 vTexcoord : TEXCOORD0;
                };

                struct VertexShaderOutput
                {
                    float4 vPosition : SV_POSITION;
                    float2 vTexcoord : TEXCOORD0;
                };

                uniform float4x4 matrix_world_view_projection;

                VertexShaderOutput main(VertexShaderInput INPUT)
                {
                    VertexShaderOutput OUT;

                    OUT.vPosition = mul(matrix_world_view_projection, INPUT.vPosition); // (x,y,z,w)
                    OUT.vTexcoord = INPUT.vTexcoord; // (x,y)

                    return OUT;
                }
                ",


                "/// Fragment/Pixel Shader ///

                struct PixelShaderInput
                {
                    float2 vTexcoord : TEXCOORD0;
                };

                sampler2D s0;

                float4 main(PixelShaderInput INPUT) : SV_TARGET
                {
                     // Break Down Pixel's Color:
                    float4 Color = tex2D(s0, INPUT.vTexcoord); // (r,g,b,a)
                    float R = round(Color.r * 255.0);
                    float G = round(Color.g * 255.0);
                    float B = round(Color.b * 255.0);

                    if(R > G && R > B){
                        if(
                            (R == 252.0 && G ==  56.0 && B ==  0.0) || // Standard enemy eye color
                            (R == 199.0 && G ==   0.0 && B ==  0.0) || // Freak eye color
                            (R ==  95.0 && G ==   0.0 && B ==  0.0) || // Freak eye color
                            (R == 163.0 && G ==   5.0 && B ==  5.0) || // Buff gator ammo
                            (R == 105.0 && G ==   3.0 && B ==  3.0) || // Buff gator ammo
                            (R == 255.0 && G == 164.0 && B == 15.0) || // Saladmander fire color
                            (R == 255.0 && G ==   0.0 && B ==  0.0) || // Wolf eye color
                            (R == 165.0 && G ==   9.0 && B == 43.0) || // Snowbot eye color
                            (R == 255.0 && G == 168.0 && B == 61.0) || // Snowbot eye color
                            (R == 194.0 && G ==  42.0 && B ==  0.0) || // Explo freak color
                            (R == 122.0 && G ==  27.0 && B ==  0.0) || // Explo freak color
                            (R == 156.0 && G ==  20.0 && B == 31.0) || // Turret eye color
                            (R == 255.0 && G == 134.0 && B == 47.0) || // Turret eye color
                            (R ==  99.0 && G ==   9.0 && B == 17.0) || // Turret color
                            (R == 112.0 && G ==   0.0 && B == 17.0) || // Necromancer eye color
                            (R == 210.0 && G ==  32.0 && B == 71.0) || // Jungle fly eye color
                            (R == 179.0 && G ==  27.0 && B == 60.0) || // Jungle fly eye color
                            (R == 255.0 && G == 160.0 && B == 35.0) || // Jungle fly eye/wing color
                            (R == 255.0 && G == 228.0 && B == 71.0)    // Jungle fly wing color
                        ){
                            return float4(G / 255.0, R / 255.0, B / 255.0, Color.a);
                        }
                    }

                     // Return Blank Pixel:
                    return float4(0.0, 0.0, 0.0, 0.0);
                }
            ");
        }

        shader_set_vertex_constant_f(0, matrix_multiply(matrix_multiply(matrix_get(matrix_world), matrix_get(matrix_view)), matrix_get(matrix_projection)));
        shader_set(EyeShader);
        texture_set_stage(0, surface_get_texture(_surf));

        draw_surface(_surf, _surfx, _surfy);

        shader_reset();
    }

#define charm_step
    var _charmList = ds_list_to_array(global.charm),
        _charmDraw = [];

    with(_charmList){
        if(!instance_exists(instance)) scrCharm(instance, false);
        else{
            var _self = instance,
                _time = time;

             // Target Nearest Enemy:
            if(!instance_exists(target)) scrCharmTarget();

             // Alarms:
            for(var i = 0; i <= 10; i++){
                 // Custom Alarms:
                if(alarm[i] > 0){
                    alarm[i] -= current_time_scale;
                    if(alarm[i] <= 0){
                        alarm[i] = -1;

                         // Target Nearest Enemy:
                        scrCharmTarget();
                        with(instance){
                            target = other.target;
                            var t = target;

                             // Move Player for Enemy Targeting:
                            var _lastPos = [];
                            with(Player){
                                array_push(_lastPos, [x, y]);
                                if(instance_exists(t)){
                                    x = t.x;
                                    y = t.y;
                                }
                                else{
                                    x = choose(0, 20000);
                                    y = choose(0, 20000);
                                }
                            }

                             // Reset Alarms:
                            for(var a = 0; a <= 10; a++){
                                alarm_set(a, other.alarm[a]);
                            }

                             // Call Alarm Event:
                            if(object_index != CustomEnemy){
                                switch(object_index){
                                    case MaggotExplosion:   /// Charm Spawned Maggots
                                        alarm_creator(Maggot, i);
                                        break;

                                    case RadMaggotExplosion:   /// Charm Spawned Maggots
                                        alarm_creator(RadMaggot, i);
                                        break;

                                    case Necromancer:       /// Match ReviveArea to Necromancer
                                        with(alarm_creator(ReviveArea, i)) alarm0++;
                                        break;

                                    case Ratking:           /// Charm Spawned Rats
                                        if(i == 2) alarm_creator(FastRat, i);
                                        else event_perform(ev_alarm, i);
                                        break;

                                    case ScrapBoss:         /// Charm Spawned Missiles
                                        if(i == 0) alarm_creator(ScrapBossMissile, i);
                                        else event_perform(ev_alarm, i);
                                        break;

                                    case FrogQueen:         /// Charm Spawned Eggs
                                        if(i == 2) alarm_creator(FrogEgg, i);
                                        else event_perform(ev_alarm, i);
                                        break;

                                    case FrogEgg:           /// Charm Spawned Ballguys
                                        if(i == 0) alarm_creator(Exploder, i);
                                        else event_perform(ev_alarm, i);
                                        break;

                                    case HyperCrystal:      /// Charm Spawned Crystals
                                        if(i == 1) alarm_creator(LaserCrystal, i);
                                        else event_perform(ev_alarm, i);
                                        break;

                                    case TechnoMancer:      /// Charm Spawned Necromancers + Turrets
                                        if(i == 2) with(alarm_creator(NecroReviveArea, i)) alarm0++;
                                        else{
                                            if(i == 6) alarm_creator(Turret, i);
                                            else event_perform(ev_alarm, i);
                                        }
                                        break;

                                    case MeleeBandit:
                                    case JungleAssassin:
                                        event_perform(ev_alarm, i);
                                        charm.walk = walk;
                                        walk = 0;
                                        break;

                                    case JungleFly:
                                        if(i == 2) alarm_creator(FiredMaggot, i);
                                        else event_perform(ev_alarm, i);
                                        break;

                                    default:
                                        event_perform(ev_alarm, i);
                                }
                            }
                            else{ // Custom Alarm Support
                                var a = "on_alrm" + string(i);
                                if(a in self){
                                    var _scrt = variable_instance_get(id, a);
                                    if(array_length(_scrt) >= 3){
                                        with(self) mod_script_call_self(_scrt[0], _scrt[1], _scrt[2]);
                                    }
                                }
                            }

                             // Reset Alarms:
                            for(var a = 0; a <= 10; a++){
                                var _alrm = alarm_get(a);
                                if(_alrm > 0) other.alarm[a] = _alrm + current_time_scale;
                                alarm_set(a, -1);
                            }

                             // Return Players:
                            var i = 0;
                            with(Player){
                                var p = _lastPos[i++];
                                x = p[0];
                                y = p[1];
                            }
                        }
                    }
                }
                if(!instance_exists(_self)) break;
            }
            if(!instance_exists(_self)) scrCharm(_self, false);

            else{
                with(_self){
                    target = other.target;
                    if(instance_is(self, enemy)){
                         // Contact Damage:
                        if(place_meeting(x, y, enemy)){
                            with(instances_matching_ne(instances_matching_ne(enemy, "team", team), "creator", _self)){
                                if(place_meeting(x, y, other)) with(other){
                                    if(alarm11 > 0) event_perform(ev_alarm, 11);
                                    event_perform(ev_collision, Player);
                                    with(other) nexthurt = current_frame;
                                }
                            }
                        }

                         // Player Shooting:
                        /* actually pretty annoying dont use this
                        if(place_meeting(x, y, projectile)){
                            with(instances_matching(projectile, "team", team)){
                                if(place_meeting(x, y, other)){
                                    if(instance_exists(creator) && creator.object_index == Player){
                                        with(other) scrCharm(id, false);
                                        event_perform(ev_collision, enemy);
                                    }
                                }
                            }
                        }
                        */

                         // Follow Leader:
                        if(instance_exists(Player)){
                            if(distance_to_object(Player) > 256 || !instance_exists(target) || collision_line(x, y, target.x, target.y, Wall, 0, 0) || point_distance(x, y, target.x, target.y) > 80){
                                var n = instance_nearest(x, y, Player);
                                if((meleedamage != 0 && canmelee) || "walk" not in self || walk > 0){
                                    motion_add(point_direction(x, y, mouse_x[n.index], mouse_y[n.index]), 1);
                                }
                                if(distance_to_object(n) > 20){
                                    motion_add(point_direction(x, y, n.x, n.y), 1);
                                }
                            }
                        }

                         // Make Eyes Green:
                        if(visible) array_push(_charmDraw, id);
                    }

                     // Manual Exception Stuff:
                    switch(object_index){
                        case BigMaggot:
                        case MaggotSpawn:       /// Charm Spawned Maggots
                            if(my_health <= 0){
                                var _x = x, _y = y;
                                instance_destroy();
                                scrCharm(instance_nearest(_x, _y, MaggotExplosion), true).time = _time;
                            }
                            break;

                        case RadMaggotChest:
                            if(my_health <= 0){
                                var _x = x, _y = y;
                                instance_destroy();
                                scrCharm(instance_nearest(_x, _y, RadMaggotExplosion), true).time = _time;
                            }
                            break;

                        case RatkingRage:       /// Charm Spawned Rats
                            if(walk > 0 && walk <= current_time_scale){
                                with(instances_matching(FastRat, "creator", null)) creator = noone;
                                instance_destroy();
                                with(instances_matching(FastRat, "creator", null)) creator = _self;
                            }
                            break;

                        case MeleeBandit:
                        case JungleAssassin:    /// Overwrite Movement
                            if(walk > 0){
                                other.walk = walk;
                                walk = 0;
                            }
                            if(other.walk > 0){
                                other.walk -= current_time_scale;

                                motion_add(direction, 2);
                                if(instance_exists(other.target)){
                                    var s = ((object_index == JungleAssassin) ? 1 : 2);
                                    mp_potential_step(other.target.x, other.target.y, s, false);
                                }
                            }

                             // Max Speed:
                            var m = ((object_index == JungleAssassin) ? 4 : 3);
                            if(speed > m) speed = m;
                            break;

                        case Sniper:            /// Aim at Target
                            if(other.alarm[2] > 5 && instance_exists(other.target)){
                                gunangle = point_direction(x, y, other.target.x, other.target.y);
                            }
                            break;

                        case ScrapBoss:         /// Override Movement
                            if(walk > 0){
                                other.walk = walk;
                                walk = 0;
                            }
                            if(other.walk > 0){
                                other.walk -= current_time_scale;

                                motion_add(direction, 0.5);
                                if(instance_exists(other.target)){
                                    motion_add(point_direction(x, y, other.target.x, other.target.y), 0.5);
                                }

                                if(round(other.walk / 10) == other.walk / 10) sound_play(sndBigDogWalk);

                                 // Animate:
                                if(other.walk <= 0) sprite_index = spr_idle;
                                else sprite_index = spr_walk;
                            }
                            break;

                        case ScrapBossMissile:  /// Don't Move Towards Player
                            if(sprite_index != spr_hurt){
                                if(instance_exists(Player)){
                                    var n = instance_nearest(x, y, Player);
                                    motion_add(point_direction(n.x, n.y, x, y), 0.1);
                                }
                                if(instance_exists(other.target)){
                                    motion_add(point_direction(x, y, other.target.x, other.target.y), 0.1);
                                }
                                speed = 2;
                                x = xprevious + hspeed;
                                y = yprevious + vspeed;
                            }
                            break;

                        case LaserCrystal:
                        case InvLaserCrystal:   /// Charge Particles
                            if(other.alarm[2] > 8 && current_frame_active){
                                with(instance_create(x + orandom(48), y + orandom(48), LaserCharge)){
                                    motion_add(point_direction(x, y, other.x, other.y), 2 + random(1));
                                    alarm0 = (point_distance(x, y, other.x, other.y) / speed) + 1;
                                }
                            }
                        case LightningCrystal:  /// Don't Move While Charging
                            if(other.alarm[2] > 0) speed = 0;
                            break;

                        case LilHunterFly:      /// Land on Enemies
                            if(sprite_index == sprLilHunterLand && z < -160){
                                if(instance_exists(other.target)){
                                    x = other.target.x;
                                    y = other.target.y;
                                }
                            }
                            break;

                        case ExploFreak:
                        case RhinoFreak:        /// Don't Move Towards Player
                            if(instance_exists(Player)){
                                x -= lengthdir_x(1, direction);
                                y -= lengthdir_y(1, direction);
                            }
                            if(instance_exists(other.target)){
                                mp_potential_step(other.target.x, other.target.y, 1, false);
                            }
                            break;

                        case Necromancer:       /// Charm Revived Freaks
                            with(instances_matching_le(instances_matching(ReviveArea, "creator", _self), "alarm0", 1)){
                                if(place_meeting(x, y, Corpse)) with(Corpse){
                                    if(place_meeting(x, y, other) && size < 3){
                                        with(instance_create(x, y, Freak)) creator = _self;

                                         // Effects:
                                        instance_create(x, y, ReviveFX);
                                        sound_play(sndNecromancerRevive);

                                        instance_destroy();
                                    }
                                }
                                instance_destroy();
                            }
                            break;

                        case TechnoMancer:      /// Charm Revived Necromancers
                            with(instances_matching_le(instances_matching(NecroReviveArea, "creator", _self), "alarm0", 1)){
                                if(place_meeting(x, y, Corpse)) with(instance_nearest(x, y, Corpse)){
                                    if(place_meeting(x, y, other) && size < 3){
                                        with(instance_create(x, y, Necromancer)) creator = _self;

                                         // Effects:
                                        with(instance_create(x, y, ReviveFX)) sprite_index = sprNecroRevive;
                                        sound_play(sndNecromancerRevive);

                                        instance_destroy();
                                    }
                                }
                                instance_destroy();
                            }
                            break;

                        case Shielder:
                        case EliteShielder:     /// Fix Shield Team
                            with(instances_matching(PopoShield, "creator", id)) team = other.team;
                            break;

                        case EnemyHorror:       /// Don't Shoot Beam at Player
                            if(instance_exists(other.target)){
                                gunangle = point_direction(x, y, other.target.x, other.target.y);
                            }
                            with(instances_matching(instances_matching(projectile, "creator", _self), "charmed_horror", null)){
                                charmed_horror = true;
                                x -= hspeed;
                                y -= vspeed;
                                direction = other.gunangle;
                                image_angle = direction;
                                x += hspeed;
                                y += vspeed;
                            }
                            break;

                        case InvSpider:         /// Charm Split Spiders
                            if(my_health <= 0){
                                with(instances_matching(InvSpider, "creator", null)) creator = noone;
                                instance_destroy();
                                with(instances_matching(InvSpider, "creator", null)) creator = _self;
                            }
                            break;

                        case FiredMaggot:       /// Charm Dropped Maggot
                            if(my_health <= 0 || place_meeting(x + hspeed, y + vspeed, Wall)){
                                with(instances_matching(Maggot, "creator", null)) creator = noone;
                                instance_destroy();
                                with(instances_matching(Maggot, "creator", null)) creator = _self;
                            }
                            break;
                    }
                }

                 // Charm Timer:
                if(instance_exists(_self) && time > 0){
                    time -= current_time_scale;
                    if(time <= 0) scrCharm(_self, false);
                }
            }
        }

         // Charm Spawned Enemies:
        with(instances_matching(instances_matching(hitme, "creator", instance), "charm", null)){
            scrCharm(id, true);
            repeat(_time / 60) with(obj_create(x + orandom(16), y + orandom(16), "ParrotFeather")){
                target = other;
            }
        }
    }
    if(array_length(_charmDraw) > 0){
        script_bind_draw(charm_draw, -3, _charmDraw);
    }

#define scrCharmTarget()
    with(instance){
        var _x = x,
            _y = y;

        if(instance_is(self, enemy)){
            other.target = nearest_instance(_x, _y, instances_matching_ne(enemy, "team", team));
        }
        else other.target = instance_nearest(_x, _y, enemy);
    }

#define cleanup
    with(global.charm_step) instance_destroy();
    for(var i = 0; i < lq_size(global.current); i++){
        audio_stop_sound(lq_get_value(global.current, i).snd);
    }


/// Scripts
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
#define target_in_distance(_disMin, _disMax)                                            return  mod_script_call(   "mod", "telib", "target_in_distance", _disMin, _disMax);
#define target_is_visible()                                                             return  mod_script_call(   "mod", "telib", "target_is_visible");
#define z_engine()                                                                              mod_script_call(   "mod", "telib", "z_engine");
#define scrCharm(_instance, _charm)                                                     return  mod_script_call_nc("mod", "telib", "scrCharm", _instance, _charm);
#define scrBossHP(_hp)                                                                  return  mod_script_call(   "mod", "telib", "scrBossHP", _hp);
#define scrTopDecal(_x, _y, _area)                                                      return  mod_script_call(   "mod", "telib", "scrTopDecal", _x, _y, _area);
#define scrWaterStreak(_x, _y, _dir, _spd)                                              return  mod_script_call(   "mod", "telib", "scrWaterStreak", _x, _y, _dir, _spd);
#define scrRadDrop(_x, _y, _raddrop, _dir, _spd)                                        return  mod_script_call(   "mod", "telib", "scrRadDrop", _x, _y, _raddrop, _dir, _spd);
#define scrCorpse(_dir, _spd)                                                           return  mod_script_call(   "mod", "telib", "scrCorpse", _dir, _spd);
#define scrSwap()                                                                       return  mod_script_call(   "mod", "telib", "scrSwap");
#define scrSetPet(_pet)                                                                 return  mod_script_call(   "mod", "telib", "scrSetPet", _pet);
#define scrPortalPoof()                                                                 return  mod_script_call(   "mod", "telib", "scrPortalPoof");
#define scrPickupPortalize()                                                            return  mod_script_call(   "mod", "telib", "scrPickupPortalize");
#define orandom(n)                                                                      return  mod_script_call(   "mod", "telib", "orandom", n);
#define floor_ext(_num, _round)                                                         return  mod_script_call(   "mod", "telib", "floor_ext", _num, _round);
#define array_count(_array, _value)                                                     return  mod_script_call(   "mod", "telib", "array_count", _array, _value);
#define array_flip(_array)                                                              return  mod_script_call(   "mod", "telib", "array_flip", _array);
#define instances_named(_object, _name)                                                 return  mod_script_call(   "mod", "telib", "instances_named", _object, _name);
#define nearest_instance(_x, _y, _instances)                                            return  mod_script_call(   "mod", "telib", "nearest_instance", _x, _y, _instances);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call(   "mod", "telib", "instance_rectangle", _x1, _y1, _x2, _y2, _obj);
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
#define Pet_create(_x, _y, _name)                                                       return  mod_script_call(   "mod", "telib", "Pet_create", _x, _y, _name);
#define scrFloorMake(_x, _y, _obj)                                                      return  mod_script_call(   "mod", "telib", "scrFloorMake", _x, _y, _obj);
#define scrFloorFill(_x, _y, _w, _h)                                                    return  mod_script_call(   "mod", "telib", "scrFloorFill", _x, _y, _w, _h);
#define scrFloorFillRound(_x, _y, _w, _h)                                               return  mod_script_call(   "mod", "telib", "scrFloorFillRound", _x, _y, _w, _h);
#define unlock_get(_unlock)                                                             return  mod_script_call(   "mod", "telib", "unlock_get", _unlock);
#define unlock_set(_unlock, _value)                                                             mod_script_call(   "mod", "telib", "unlock_set", _unlock, _value);