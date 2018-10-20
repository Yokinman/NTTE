#define init
    global.newLevel = instance_exists(GenCont);
    global.area = ["coast","oasis","trench"];

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
            ]
    };
    for(var i = 0; i < lq_size(global.waterSound); i++){
        var s = lq_get_value(global.waterSound, i);
        for(var j = 0; j < array_length(s); j++){
            s[j] = [s[j], 1];
        }
    }

#define level_start // game_start but every level
	if(GameCont.area == 1){
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
	}

     // Spawn Mortars:
	with(LaserCrystal){
	    if(random(4) < 1){
	        obj_create(x, y, "Mortar");
	        instance_delete(self);
	    }
	}
	
	 // Spawn Cats:
	with(Rat){
	    if(random(8) < 1){
	        obj_create(x, y, "Cat");
	        instance_delete(self);
	    }
	}

     // Big Decals:
	with(TopSmall) if(random(200) < 1) {
		obj_create(x, y, "BigDecal");
		break;
	}

#define step
     // GENERATION CODE //
    if(instance_exists(GenCont) || instance_exists(Menu)) global.newLevel = 1;
    else if(global.newLevel){
        global.newLevel = 0;
        level_start();
    }

     // Call Area Step (Step not built into area mods):
    if(!instance_exists(GenCont)){
        var a = array_find_index(global.area, GameCont.area);
        if(a >= 0) mod_script_call("area", global.area[a], "area_step");
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

#define underwater_step
     // Run in underwater area step events
     // lightning
    with instances_matching(Lightning,"team",2){
        image_speed = 0.1;
        if floor(image_index) == sprite_get_number(sprite_index)-1{
            team = 0;
            sprite_index = sprEnemyLightning;
            image_speed = 0.3;
            image_index = 0;
            if random(8) < 1{
                sound_play_hit(sndLightningHit,0.2);
                with instance_create(x,y,GunWarrantEmpty)
                    image_angle = other.direction;
            }
            else if random(3) < 1
                instance_create(x+orandom(18),y+orandom(18),PortalL)
        }
    }
     // reskin opened chests
    with instances_matching(ChestOpen,"sprite_index",sprWeaponChestOpen)
        sprite_index = sprClamChestOpen;

    script_bind_step(underwater_poststep, 0);
    script_bind_draw(underwater_bubbledraw, -3);

#define underwater_poststep
    instance_destroy();

     // Replace Sounds w/ Oasis Sounds:
    for(var i = 0; i < lq_size(global.waterSound); i++){
        var _sndOasis = asset_get_index(lq_get_key(global.waterSound, i)),
            _sounds = lq_get_value(global.waterSound, i);

        for(var j = 0; j < array_length(_sounds); j++){
            var _snd = _sounds[j];
            if(audio_is_playing(_snd[0]) && _snd[1] < current_frame){
                sound_play_pitchvol(_sndOasis, 1, 2);
                _snd[1] = current_frame + 1;
            }
            sound_stop(_snd[0]);
        }
    }
    with(instances_matching_ne(enemy, "snd_hurt", sndOasisHurt, -1)) snd_hurt = sndOasisHurt;
    with(instances_matching_ne(enemy, "snd_dead", sndOasisDeath, -1)) snd_dead = sndOasisDeath;

     // Dust -> Bubbles:
    with(Dust){
        instance_create(x, y, Bubble);
        instance_destroy();
    }

#define underwater_bubbledraw
    instance_destroy();

     // Air Bubble:
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
    
#define orandom(_n)
    return irandom_range(-_n,_n);