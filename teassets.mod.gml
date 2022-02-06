#define init
	ntte_version = 2.049;
	
	 // Debug Lag:
	lag = false;
	
	 // Custom Object Related:
	obj                                = {};
	global.obj_create_ref_map          = ds_map_create(); // Pairs an NT:TE object's name with a script reference to its create event
	global.obj_parent_map              = ds_map_create(); // Pairs an NT:TE object's name with the name of its parent NT:TE object
	global.obj_search_bind_map         = ds_map_create(); // Pairs a "name:objectName" key with a setup script binding for 'instance_copy' searching
	global.obj_event_varname_list_map  = ds_map_create();
	global.obj_event_obj_list_map      = ds_map_create();
	global.obj_draw_depth_instance_map = ds_map_create();
	
	 // Custom Object Event Variable Names:
	with([CustomObject, CustomHitme, CustomProp, CustomProjectile, CustomSlash, CustomEnemy, CustomScript, CustomBeginStep, CustomStep, CustomEndStep, CustomDraw]){
		var _eventVarNameList = [];
		with(instance_create(0, 0, self)){
			with(["on_step", "on_begin_step", "on_end_step", "on_draw", "on_destroy", "on_cleanup", "on_anim", "on_death", "on_hurt", "on_hit", "on_wall", "on_projectile", "on_grenade", "script"]){
				if(self in other){
					array_push(_eventVarNameList, self);
				}
			}
			instance_delete(self);
		}
		if(array_find_index(_eventVarNameList, "on_step") >= 0){
			for(var i = 0; i < 10; i++){
				array_push(_eventVarNameList, `on_alrm${i}`);
			}
		}
		global.obj_event_varname_list_map[? self] = _eventVarNameList;
	}
	
	 // Script References:
	scr = {};
	with([save_get, save_set, option_get, option_set, stat_get, stat_set, unlock_get, unlock_set, surface_setup, shader_setup, shader_add, script_bind, ntte_bind_setup, ntte_unbind, loadout_wep_save, loadout_wep_reset, trace_error, merge_weapon_sprite, merge_weapon_loadout_sprite, weapon_merge_subtext]){
		lq_set(scr, script_get_name(self), script_ref_create(self));
	}
	
	 // SPRITES //
	spr      = {};
	spr_load = [[spr, 0]];
	with(spr){
		var m, p;
		
		 // Storage:
		msk             = {};
		shd             = {};
		BigTopDecal     = ds_map_create();
		msk.BigTopDecal = ds_map_create();
		TopTiny         = ds_map_create();
		MergeWep        = ds_map_create();
		MergeWepLoadout = ds_map_create();
		MergeWepText    = ds_map_create();
		
		 // Shine Overlay:
		p = "sprites/shine/";
		Shine8    = sprite_add(p + "sprShine8.png",    7,  4,  4); // Rads
		Shine10   = sprite_add(p + "sprShine10.png",   7,  5,  5); // Pickups
		Shine12   = sprite_add(p + "sprShine12.png",   7,  6,  6); // Big Rads
		Shine16   = sprite_add(p + "sprShine16.png",   7,  8,  8); // Normal Chests
		Shine20   = sprite_add(p + "sprShine20.png",   7, 10, 10); // Heavy Chests (Steroids)
		Shine24   = sprite_add(p + "sprShine24.png",   7, 12, 12); // Big Chests
		Shine64   = sprite_add(p + "sprShine64.png",   7, 32, 32); // Giant Chests (YV)
		ShineHurt = sprite_add(p + "sprShineHurt.png", 3,  0,  0); // Hurt Flash
		ShineSnow = sprite_add(p + "sprShineSnow.png", 1,  0,  0); // Snow Floors
		
		//#region MENU / HUD
			
			 // Menu:
			m = "menu/";
			p = m;
				
				 // Open Options:
				OptionNTTE = sprite(p + "sprOptionNTTE", 1, 32, 12);
				MenuNTTE   = sprite(p + "sprMenuNTTE",   1, 20,  9);
				
				 // Eyes Maggot Shadow:
				shd.EyesMenu = sprite(p + "shdEyesMenu", 24, 16, 18);
				
				 // Alt Route Area Icons:
				RouteIcon = sprite(p + "sprRouteIcon", 2, 4, 4);
			
				 // Unlock Icons:
				p = m + "unlocks/";
				UnlockIcon = {
					"coast"  : sprite(p + "sprUnlockIconBeach",    2, 12, 12),
					"oasis"  : sprite(p + "sprUnlockIconBubble",   2, 12, 12),
					"trench" : sprite(p + "sprUnlockIconTech",     2, 12, 12),
					"lair"   : sprite(p + "sprUnlockIconSawblade", 2, 12, 12),
					"red"    : sprite(p + "sprUnlockIconRed",      2, 12, 12),
					"crown"  : sprite(p + "sprUnlockIconCrown",    2, 12, 12)
				};
				
			 // Loadout Crown System:
			p = "crowns/";
			CrownRandomLoadout = sprite(p + "Random/sprCrownRandomLoadout", 2, 16, 16);
			ClockParts         = sprite(p + "sprClockParts",                2,  1, 1);
			
			 // Mutation Reroll Icon:
			p = "skills/Reroll/";
			SkillRerollHUDSmall = sprite(p + "sprSkillRerollHUDSmall", 1, 4, 4);
			
		//#endregion
		
		//#region WEAPONS
		p = "weps/";
			
			 // Bone:
			Bone      = sprite(p + "sprBone",      1, 6, 6, shnWep);
			BoneShard = sprite(p + "sprBoneShard", 1, 3, 2, shnWep);
			
			 // Teleport Gun:
			TeleportGun            = sprite(p + "sprTeleportGun",            1,  4,  4, shnWep);
			GoldTeleportGun        = sprite(p + "sprGoldTeleportGun",        1,  4,  4, shnWep);
			TeleportGunLoadout     = sprite(p + "sprTeleportGunLoadout",     1, 24, 24, shnWep);
			GoldTeleportGunLoadout = sprite(p + "sprGoldTeleportGunLoadout", 1, 24, 24, shnWep);
			
			 // Trident:
			Trident            = sprite(p + "sprTrident",            1, 11,  6, shnWep);
			GoldTrident        = sprite(p + "sprGoldTrident",        1, 11,  6, shnWep);
			TridentLoadout     = sprite(p + "sprTridentLoadout",     1, 24, 24, shnWep);
			GoldTridentLoadout = sprite(p + "sprGoldTridentLoadout", 1, 24, 24, shnWep);
			msk.Trident        = sprite(p + "mskTrident",            1, 11,  6);
			
			 // Tunneller:
			Tunneller            = sprite(p + "sprTunneller",            1, 14,  6, shnWep);
			GoldTunneller        = sprite(p + "sprGoldTunneller",        1, 14,  6, shnWep);
			TunnellerLoadout     = sprite(p + "sprTunnellerLoadout",     1, 24, 24, shnWep);
			GoldTunnellerLoadout = sprite(p + "sprGoldTunnellerLoadout", 1, 24, 24, shnWep);
			TunnellerHUD         = sprite(p + "sprTunnellerHUD",         1,  0,  3, shnWep);
			TunnellerHUDRed      = sprite(p + "sprTunnellerHUD",         1,  0,  3);
			
			 // Ultra Quasar Blaster:
			UltraQuasarBlaster    = sprite(p + "sprUltraQuasarBlaster",    1,  20, 12, shnWep);
			UltraQuasarBlasterEat = sprite(p + "sprUltraQuasarBlasterEat", 12, 24, 24);
			
		//#endregion
		
		//#region PROJECTILES
		p = "projectiles/";
			
			 // Albino Gator:
			AlbinoBolt      = sprite(p + "sprAlbinoBolt",     1,  8, 4);
			AlbinoGrenade   = sprite(p + "sprAlbinoGrenade",  1,  4, 4);
			AlbinoSplinter  = sprite(p + "sprAlbinoSplinter", 1, -6, 3);
			
			 // Bat Discs:
			BatDisc      = sprite(p + "sprBatDisc",      2,  9,  9);
			BatDiscBig   = sprite(p + "sprBatDiscBig",   2, 14, 14);
			BigDiscTrail = sprite(p + "sprBigDiscTrail", 3, 12, 12);
			
			 // Bat Lightning:
			BatLightning    = sprite(p + "sprBatLightning",    4,  0,  1);
			BatLightningHit = sprite(p + "sprBatLightningHit", 4, 12, 12);
			
			 // Bone:
			BoneSlashLight     = sprite(p + "sprBoneSlashLight", 3, 16, 16);
			msk.BoneSlashLight = sprite(p + "mskBoneSlashLight", 3, 16, 16);
			BoneSlashHeavy     = sprite(p + "sprBoneSlashHeavy", 4, 24, 24);
			msk.BoneSlashHeavy = sprite(p + "mskBoneSlashHeavy", 4, 24, 24);
			BoneArrow          = sprite(p + "sprBoneArrow",      1, 10,  2);
			BoneArrowHeavy     = sprite(p + "sprBoneArrowHeavy", 1, 12,  3);
			with([msk.BoneSlashLight, msk.BoneSlashHeavy]){
				mask = [true, 0];
			}
			
			 // Bubble Bombs:
			BubbleBomb           = sprite(p + "sprBubbleBomb",           30, 12, 12);
			BubbleBombEnemy      = sprite(p + "sprBubbleBombEnemy",      30, 12, 12);
			BubbleExplosion      = sprite(p + "sprBubbleExplosion",       9, 24, 24);
			BubbleExplosionSmall = sprite(p + "sprBubbleExplosionSmall",  7, 12, 12);
			BubbleCharge         = sprite(p + "sprBubbleCharge",         12, 12, 12);
			BubbleBombBig        = sprite(p + "sprBubbleBombBig",        46, 16, 16);
			BubbleSlash          = sprite(p + "sprBubbleSlash",           3,  0, 24);
			
			 // Clam Shield:
			ClamShield          = sprite(p + "sprClamShield",      14,  0,  7);
			ClamShieldWep       = sprite(p + "sprClamShieldWep",    1,  8,  8, shn16);
			ClamShieldSlash     = sprite(p + "sprClamShieldSlash",  4, 12, 12);
			msk.ClamShieldSlash = sprite(p + "mskClamShieldSlash",  4, 12, 12);
			
			 // Crystal Heart:
			CrystalHeartBullet         = sprite(p + "sprCrystalHeartBullet",         2, 10, 10);
			CrystalHeartBulletHit      = sprite(p + "sprCrystalHeartBulletHit",      8, 16, 16);
			CrystalHeartBulletRing     = sprite(p + "sprCrystalHeartBulletRing",     2, 10, 10);
			CrystalHeartBulletTrail    = sprite(p + "sprCrystalHeartBulletTrail",    4, 10, 10);
			CrystalHeartBulletBig      = sprite(p + "sprCrystalHeartBulletBig",      2, 24, 24);
			CrystalHeartBulletBigRed   = sprite(p + "sprCrystalHeartBulletBigRed",   2, 24, 24);
			CrystalHeartBulletBigRing  = sprite(p + "sprCrystalHeartBulletBigRing",  2, 24, 24);
			CrystalHeartBulletBigTrail = sprite(p + "sprCrystalHeartBulletBigTrail", 4, 24, 24);
			
			 // Electroplasma:
			ElectroPlasma       = sprite(p + "sprElectroPlasma",       7, 12, 12);
			ElectroPlasmaBig    = sprite(p + "sprElectroPlasmaBig",    7, 12, 12);
			ElectroPlasmaTrail  = sprite(p + "sprElectroPlasmaTrail",  3,  4,  4);
			ElectroPlasmaImpact = sprite(p + "sprElectroPlasmaImpact", 7, 12, 12);
			ElectroPlasmaTether = sprite(p + "sprElectroPlasmaTether", 4,  0,  1);
			
			 // Harpoon:
			Harpoon      = sprite(p + "sprHarpoon",      1, 4, 3, shnWep);
			HarpoonOpen  = sprite(p + "sprHarpoonOpen",  5, 4, 3);
			HarpoonFade  = sprite(p + "sprHarpoonFade",  5, 7, 3);
			NetNade      = sprite(p + "sprNetNade",      1, 3, 3);
			NetNadeBlink = sprite(p + "sprNetNadeBlink", 2, 3, 3);
			
			 // Mortar Plasma:
			MortarPlasma = sprite(p + "sprMortarPlasma", 8, 8, 8);
			
			 // Small Plasma Impact:
			EnemyPlasmaImpactSmall = sprite(p + "sprEnemyPlasmaImpactSmall", 7,  8,  8);
			PlasmaImpactSmall      = sprite(p + "sprPlasmaImpactSmall",      7,  8,  8);
			PopoPlasmaImpactSmall  = sprite(p + "sprPopoPlasmaImpactSmall",	 7,  8,  8);
			msk.PlasmaImpactSmall  = sprite(p + "mskPlasmaImpactSmall",      7, 16, 16);
			with(msk.PlasmaImpactSmall){
				mask = [true, 0];
			}
			
			 // Portal Bullet:
			PortalBullet          = sprite(p + "sprPortalBullet",          4, 12, 12);
			PortalBulletHit       = sprite(p + "sprPortalBulletHit",       4, 16, 16);
			PortalBulletSpawn     = sprite(p + "sprPortalBulletSpawn",     7, 26, 26);
			PortalBulletLightning = sprite(p + "sprPortalBulletLightning", 4, 0,  1);
			
			 // Quasar Beam:
			QuasarBeam           = sprite(p + "sprQuasarBeam",           2,  0, 16);
			QuasarBeamStart      = sprite(p + "sprQuasarBeamStart",      2, 32, 16);
			QuasarBeamEnd        = sprite(p + "sprQuasarBeamEnd",        2,  0, 16);
			QuasarBeamHit        = sprite(p + "sprQuasarBeamHit",        6, 24, 24);
			QuasarBeamTrail      = sprite(p + "sprQuasarBeamTrail",      3,  4,  4);
			UltraQuasarBeam      = sprite(p + "sprUltraQuasarBeam",      2,  0, 32);
			UltraQuasarBeamStart = sprite(p + "sprUltraQuasarBeamStart", 2, 64, 32);
			UltraQuasarBeamEnd   = sprite(p + "sprUltraQuasarBeamEnd",   2,  0, 32);
			UltraQuasarBeamHit   = sprite(p + "sprUltraQuasarBeamHit",   6, 24, 24);
			UltraQuasarBeamTrail = sprite(p + "sprUltraQuasarBeamTrail", 3,  8,  8);
			UltraQuasarBeamFlame = sprite(p + "sprUltraQuasarBeamFlame", 3, 64, 32);
			msk.QuasarBeam       = sprite(p + "mskQuasarBeam",           1, 32, 16);
			msk.UltraQuasarBeam  = sprite(p + "mskUltraQuasarBeam",      1, 64, 32);
			
			 // Red:
			RedBullet          = sprite(p + "sprRedBullet",          2,  9,  9);
			RedBulletDisappear = sprite(p + "sprRedBulletDisappear", 5,  9,  9);
			RedExplosion       = sprite(p + "sprRedExplosion",       7, 16, 16);
			RedSlash           = sprite(p + "sprRedSlash",           3,  0, 24);
			RedHeavySlash      = sprite(p + "sprRedHeavySlash",      3,  0, 24);
			RedMegaSlash       = sprite(p + "sprRedMegaSlash",       3,  0, 36);
			RedShank           = sprite(p + "sprRedShank",           2, -5,  8);
			RedShankGold       = sprite(p + "sprRedShankGold",       2, -5,  8);
			//EntanglerSlash     = sprite(p + "sprEntanglerSlash", 3, 0, 24);
			
			 // Small Green Explo:
			SmallGreenExplosion = sprite(p + "sprSmallGreenExplosion", 7, 12, 12);
			
			 // Energy Bat Slash:
			EnergyBatSlash     = sprite(p + "sprEnergyBatSlash", 3,  0,  24);
			//msk.EnergyBatSlash = sprite(p + "mskEnergyBatSlash", 4, 16, 24);
			
			 // Vector Plasma:
			EnemyVlasmaBullet = sprite(p + "sprEnemyVlasmaBullet", 5,  8,  8);
			VlasmaBullet      = sprite(p + "sprVlasmaBullet",      5,  8,  8);
			PopoVlasmaBullet  = sprite(p + "sprPopoVlasmaBullet",  5,  8,  8);
			EnemyVlasmaCannon = sprite(p + "sprEnemyVlasmaCannon", 5, 10, 10);
			VlasmaCannon      = sprite(p + "sprVlasmaCannon",      5, 10, 10);
			PopoVlasmaCannon  = sprite(p + "sprPopoVlasmaCannon",  5, 10, 10);
			
			 // Venom Pellets:
			VenomPelletAppear        = sprite(p + "sprVenomPelletAppear",        1, 8, 8);
			VenomPellet              = sprite(p + "sprVenomPellet",              2, 8, 8);
			VenomPelletDisappear     = sprite(p + "sprVenomPelletDisappear",     5, 8, 8);
			VenomPelletBack          = sprite(p + "sprVenomPelletBack",          2, 8, 8);
			VenomPelletBackDisappear = sprite(p + "sprVenomPelletBackDisappear", 5, 8, 8);
			
			 // Variants:
			EnemyBullet             = sprite(p + "sprEnemyBullet",             2,  7,  9);
			EnemyHeavyBullet        = sprite(p + "sprEnemyHeavyBullet",        2, 12, 12);
			EnemyHeavyBulletHit     = sprite(p + "sprEnemyHeavyBulletHit",     4, 12, 12);
			EnemySlug               = sprite(p + "sprEnemySlug",               2, 12, 12);
			EnemySlugHit            = sprite(p + "sprEnemySlugHit",            4, 16, 16);
			EnemySlugDisappear      = sprite(p + "sprEnemySlugDisappear",      6, 12, 12);
			EnemyHeavySlug          = sprite(p + "sprEnemyHeavySlug",          2, 16, 16);
			EnemyHeavySlugHit       = sprite(p + "sprEnemyHeavySlugHit",       4, 24, 24);
			EnemyHeavySlugDisappear = sprite(p + "sprEnemyHeavySlugDisappear", 6, 16, 16);
			EnemySuperFlak          = sprite(p + "sprEnemySuperFlak",          2, 12, 12);
			EnemySuperFlakHit       = sprite(p + "sprEnemySuperFlakHit",       9, 24, 24);
			EnemyPlasmaBall         = sprite(p + "sprEnemyPlasmaBall",         2, 12, 12);
			EnemyPlasmaBig          = sprite(p + "sprEnemyPlasmaBig",          2, 16, 16);
			EnemyPlasmaHuge         = sprite(p + "sprEnemyPlasmaHuge",         2, 24, 24);
			EnemyPlasmaImpact       = sprite(p + "sprEnemyPlasmaImpact",       7, 16, 16);
			EnemyPlasmaTrail        = sprite(p + "sprEnemyPlasmaTrail",        3,  4,  4);
			AllySniperBullet        = sprite(p + "sprAllySniperBullet",        2,  6,  8);
			AllyLaserCharge         = sprite(p + "sprAllyLaserCharge",         4,  3,  3);
			IDPDHeavyBullet         = sprite(p + "sprIDPDHeavyBullet",         2, 12, 12);
			IDPDHeavyBulletHit      = sprite(p + "sprIDPDHeavyBulletHit",      4, 12, 12);
			
		//#endregion
		
		//#region ALERTS
		p = "alerts/";
			
			 // Alert Indicators:
			AlertIndicator        = sprite(p + "sprAlertIndicator",        1, 1, 6);
			AlertIndicatorMystery = sprite(p + "sprAlertIndicatorMystery", 1, 2, 6);
			AlertIndicatorPopo    = sprite(p + "sprAlertIndicatorPopo",    1, 4, 4);
			AlertIndicatorOrchid  = sprite(p + "sprAlertIndicatorOrchid",  1, 4, 4);
			
			 // Alert Icons:
			AllyAlert            = sprite(p + "sprAllyAlert",            1, 7,  7);
			BanditAlert          = sprite(p + "sprBanditAlert",          1, 7,  7);
			CrimeBountyAlert     = sprite(p + "sprCrimeBountyAlert",     2, 8, 10);
			CrimeBountyFillAlert = sprite(p + "sprCrimeBountyFillAlert", 4, 5,  0);
			FlyAlert             = sprite(p + "sprFlyAlert",             1, 7,  7);
			GatorAlert           = sprite(p + "sprGatorAlert",           1, 7,  7);
			GatorAlbinoAlert     = sprite(p + "sprGatorAlbinoAlert",     1, 7,  7);
			GatorPatchAlert      = sprite(p + "sprGatorPatchAlert",      1, 7,  7);
			PopoAlert            = sprite(p + "sprPopoAlert",            3, 8,  8);
			PopoEliteAlert       = sprite(p + "sprPopoEliteAlert",       3, 8,  8);
			PopoFreakAlert       = sprite(p + "sprPopoFreakAlert",       1, 8,  8);
			SealAlert            = sprite(p + "sprSealAlert",            1, 7,  7);
			SealArcticAlert      = sprite(p + "sprSealArcticAlert",      1, 7,  7);
			SkealAlert           = sprite(p + "sprSkealAlert",           1, 7,  7);
			SludgePoolAlert      = sprite(p + "sprSludgePoolAlert",      1, 7,  7);
			VanAlert             = sprite(p + "sprVanAlert",             1, 7,  7);
			
		//#endregion
		
		//#region ENEMIES
		m = "enemies/";
			
			 // Albino Gator:
			p = m + "AlbinoGator/";
			AlbinoGatorIdle = sprite(p + "sprAlbinoGatorIdle", 8, 16, 16);
			AlbinoGatorWalk = sprite(p + "sprAlbinoGatorWalk", 6, 16, 16);
			AlbinoGatorHurt = sprite(p + "sprAlbinoGatorHurt", 3, 16, 16);
			AlbinoGatorDead = sprite(p + "sprAlbinoGatorDead", 6, 16, 16);
			AlbinoGatorWeap = sprite(p + "sprAlbinoGatorWeap", 1,  7,  5, shnWep);
			
			 // Angler:
			p = m + "Angler/";
			AnglerIdle       = sprite(p + "sprAnglerIdle",    8, 32, 32);
			AnglerWalk       = sprite(p + "sprAnglerWalk",    8, 32, 32);
			AnglerHurt       = sprite(p + "sprAnglerHurt",    3, 32, 32);
			AnglerDead       = sprite(p + "sprAnglerDead",    7, 32, 32);
			AnglerAppear     = sprite(p + "sprAnglerAppear",  4, 32, 32);
			AnglerTrail      = sprite(p + "sprAnglerTrail",   8, 32, 32);
			AnglerLight      = sprite(p + "sprAnglerLight",   4, 80, 80);
			msk.AnglerHidden =[sprite(p + "mskAnglerHidden1", 1, 32, 32),
			                   sprite(p + "mskAnglerHidden2", 1, 32, 32)];
			
			 // Angler (Gold):
			p = m + "GoldAngler/";
			AnglerGoldIdle    = sprite(p + "sprGoldAnglerIdle",    8, 32, 32);
			AnglerGoldWalk    = sprite(p + "sprGoldAnglerWalk",    8, 32, 32);
			AnglerGoldHurt    = sprite(p + "sprGoldAnglerHurt",    3, 32, 32);
			AnglerGoldDead    = sprite(p + "sprGoldAnglerDead",    7, 32, 32);
			AnglerGoldAppear  = sprite(p + "sprGoldAnglerAppear",  4, 32, 32);
			AnglerGoldScreech = sprite(p + "sprGoldAnglerScreech", 8, 48, 48);
			
			 // Baby Gator:
			p = m + "BabyGator/";
			BabyGatorIdle = sprite(p + "sprBabyGatorIdle", 6, 12, 12);
			BabyGatorWalk = sprite(p + "sprBabyGatorWalk", 6, 12, 12);
			BabyGatorHurt = sprite(p + "sprBabyGatorHurt", 3, 12, 12);
			BabyGatorDead = sprite(p + "sprBabyGatorDead", 7, 12, 12);
			BabyGatorWeap = sprite(p + "sprBabyGatorWeap", 1,  0,  3, shnWep);
			
			 // Baby Scorpion:
			p = m + "BabyScorpion/";
			BabyScorpionIdle = sprite("enemies/BabyScorpion/sprBabyScorpionIdle", 4, 16, 16);
			BabyScorpionWalk = sprite("enemies/BabyScorpion/sprBabyScorpionWalk", 6, 16, 16);
			BabyScorpionHurt = sprite("enemies/BabyScorpion/sprBabyScorpionHurt", 3, 16, 16);
			BabyScorpionDead = sprite("enemies/BabyScorpion/sprBabyScorpionDead", 6, 16, 16);
			BabyScorpionFire = sprite("enemies/BabyScorpion/sprBabyScorpionFire", 6, 16, 16);
			
			 // Baby Scorpion (Gold):
			p = m + "BabyScorpionGold/";
			BabyScorpionGoldIdle = sprite("enemies/BabyScorpionGold/sprBabyScorpionGoldIdle", 4, 16, 16);
			BabyScorpionGoldWalk = sprite("enemies/BabyScorpionGold/sprBabyScorpionGoldWalk", 6, 16, 16);
			BabyScorpionGoldHurt = sprite("enemies/BabyScorpionGold/sprBabyScorpionGoldHurt", 3, 16, 16);
			BabyScorpionGoldDead = sprite("enemies/BabyScorpionGold/sprBabyScorpionGoldDead", 6, 16, 16);
			BabyScorpionGoldFire = sprite("enemies/BabyScorpionGold/sprBabyScorpionGoldFire", 6, 16, 16);
			
			 // Bandit Campers:
			p = m + "Camp/";
			BanditCamperIdle = sprite(p + "sprBanditCamperIdle", 4, 12, 12);
			BanditCamperWalk = sprite(p + "sprBanditCamperWalk", 6, 12, 12);
			BanditCamperHurt = sprite(p + "sprBanditCamperHurt", 3, 12, 12);
			BanditCamperDead = sprite(p + "sprBanditCamperDead", 6, 12, 12);
			BanditHikerIdle  = sprite(p + "sprBanditHikerIdle",  4, 12, 12);
			BanditHikerWalk  = sprite(p + "sprBanditHikerWalk",  6, 12, 12);
			BanditHikerHurt  = sprite(p + "sprBanditHikerHurt",  3, 12, 12);
			BanditHikerDead  = sprite(p + "sprBanditHikerDead",  6, 12, 12);
			
			 // Bat:
			p = m + "Bat/";
			BatWeap        = sprite(p + "sprBatWeap",     1,  2,  6, shnWep);
			BatIdle        = sprite(p + "sprBatIdle",    24, 16, 16);
			BatWalk        = sprite(p + "sprBatWalk",    12, 16, 16);
			BatHurt        = sprite(p + "sprBatHurt",     3, 16, 16);
			BatDead        = sprite(p + "sprBatDead",     6, 16, 16);
			BatYell        = sprite(p + "sprBatYell",     6, 16, 16);
			BatScreech     = sprite(p + "sprBatScreech",  8, 48, 48);
			msk.BatScreech = sprite(p + "mskBatScreech",  8, 48, 48);
			
			 // Bat Boss:
			p = m + "BatBoss/"
			BatBossIdle = sprite(p + "sprBigBatIdle",  12, 24, 24);
			BatBossWalk = sprite(p + "sprBigBatWalk",   8, 24, 24);
			BatBossHurt = sprite(p + "sprBigBatHurt",   3, 24, 24);
			BatBossDead = sprite(p + "sprBigBatDead",   6, 24, 24);
			BatBossYell = sprite(p + "sprBigBatYell",   6, 24, 24);
			BatBossWeap = sprite(p + "sprBatBossWeap",  1,  4,  8, shnWep);
			VenomFlak   = sprite(p + "sprVenomFlak",    2, 12, 12);
			
			 // Big Fish:
			p = m + "CoastBoss/";
			BigFishBecomeIdle = sprite(p + "sprBigFishBuild",      4, 40, 38);
			BigFishBecomeHurt = sprite(p + "sprBigFishBuildHurt",  4, 40, 38);
			BigFishSpwn       = sprite(p + "sprBigFishSpawn",     11, 32, 32);
			BigFishLeap       = sprite(p + "sprBigFishLeap",      11, 32, 32);
			BigFishSwim       = sprite(p + "sprBigFishSwim",       8, 24, 24);
			BigFishRise       = sprite(p + "sprBigFishRise",       5, 32, 32);
			BigFishSwimFrnt   = sprite(p + "sprBigFishSwimFront",  6,  0,  4);
			BigFishSwimBack   = sprite(p + "sprBigFishSwimBack",  11,  0,  5);
			
			 // Bone Gator:
			p = m + "BoneGator/";
			BoneGatorIdle = sprite(p + "sprBoneGatorIdle", 8, 12, 12);
			BoneGatorWalk = sprite(p + "sprBoneGatorWalk", 6, 12, 12);
			BoneGatorHurt = sprite(p + "sprBoneGatorHurt", 3, 12, 12);
			BoneGatorDead = sprite(p + "sprBoneGatorDead", 6, 12, 12);
			BoneGatorHeal = sprite(p + "sprBoneGatorHeal", 7,  8,  8);
			BoneGatorWeap = sprite(p + "sprBoneGatorWeap", 1,  2,  3);
			FlameSpark    = sprite(p + "sprFlameSpark",    7,  1,  1);
			
			 // Big Maggot Nest:
			p = m + "BigMaggotNest/";
			BigMaggotSpawnIdle = sprite(p + "sprBigMaggotNestIdle", 4, 32, 32);
			BigMaggotSpawnHurt = sprite(p + "sprBigMaggotNestHurt", 3, 32, 32);
			BigMaggotSpawnDead = sprite(p + "sprBigMaggotNestDead", 3, 32, 32);
			BigMaggotSpawnChrg = sprite(p + "sprBigMaggotNestChrg", 4, 32, 32);
			
			 // Blooming Bush Assassin:
			p = m + "BloomingAss/";
			BloomingAssassinHide = sprite(p + "sprBloomingAssassinHide", 41, 16, 16);
			BloomingAssassinIdle = sprite(p + "sprBloomingAssassinIdle",  6, 16, 16);
			BloomingAssassinWalk = sprite(p + "sprBloomingAssassinWalk",  6, 16, 16);
			BloomingAssassinHurt = sprite(p + "sprBloomingAssassinHurt",  3, 16, 16);
			BloomingAssassinDead = sprite(p + "sprBloomingAssassinDead",  6, 16, 16);
			
			 // Bone Raven:
			p = m + "BoneRaven/";
			BoneRavenIdle = sprite(p + "sprBoneRavenIdle", 33, 12, 12);
			BoneRavenWalk = sprite(p + "sprBoneRavenWalk",  7, 12, 12);
			BoneRavenHurt = sprite(p + "sprBoneRavenHurt",  3, 12, 12);
			BoneRavenDead = sprite(p + "sprBoneRavenDead", 11, 12, 12);
			BoneRavenLift = sprite(p + "sprBoneRavenLift",  5, 32, 32);
			BoneRavenLand = sprite(p + "sprBoneRavenLand",  4, 32, 32);
			BoneRavenFly  = sprite(p + "sprBoneRavenFly",   5, 32, 32);
			
			 // Cat:
			p = m + "Cat/";
			CatIdle      = sprite(p + "sprCatIdle",          4, 12, 12);
			CatWalk      = sprite(p + "sprCatWalk",          6, 12, 12);
			CatHurt      = sprite(p + "sprCatHurt",          3, 12, 12);
			CatDead      = sprite(p + "sprCatDead",          6, 12, 12);
			CatSit1      =[sprite(p + "sprCatGoSit",         3, 12, 12),
			               sprite(p + "sprCatGoSitSide",     3, 12, 12)];
			CatSit2      =[sprite(p + "sprCatSit",           6, 12, 12),
			               sprite(p + "sprCatSitSide",       6, 12, 12)];
			CatSnowIdle  = sprite(p + "sprCatSnowIdle",      4, 12, 12);
			CatSnowWalk  = sprite(p + "sprCatSnowWalk",      6, 12, 12);
			CatSnowHurt  = sprite(p + "sprCatSnowHurt",      3, 12, 12);
			CatSnowDead  = sprite(p + "sprCatSnowDead",      6, 12, 12);
			CatSnowSit1  =[sprite(p + "sprCatSnowGoSit",     3, 12, 12),
			               sprite(p + "sprCatSnowGoSitSide", 3, 12, 12)];
			CatSnowSit2  =[sprite(p + "sprCatSnowSit",       6, 12, 12),
			               sprite(p + "sprCatSnowSitSide",   6, 12, 12)];
			CatWeap  = sprite(p + "sprCatToxer",     1,  3,  4);
			AcidPuff = sprite(p + "sprAcidPuff",     4, 16, 16);
			
			 // Cat Boss:
			p = m + "CatBoss/";
			CatBossIdle     = sprite(p + "sprBigCatIdle",       12, 24, 24);
			CatBossWalk     = sprite(p + "sprBigCatWalk",        6, 24, 24);
			CatBossHurt     = sprite(p + "sprBigCatHurt",        3, 24, 24);
			CatBossDead     = sprite(p + "sprBigCatDead",        6, 24, 24);
			CatBossChrg     = sprite(p + "sprBigCatChrg",        2, 24, 24);
			CatBossFire     = sprite(p + "sprBigCatFire",        2, 24, 24);
			CatBossWeap     = sprite(p + "sprCatBossToxer",      2,  4,  7);
			CatBossWeapChrg = sprite(p + "sprCatBossToxerChrg", 12,  1,  7);
			BossHealFX      = sprite(p + "sprBossHealFX",       10,  9,  9);
			
			 // Crab Tank:
			CrabTankIdle = sprCrabIdle;
			CrabTankWalk = sprCrabWalk;
			CrabTankHurt = sprCrabHurt;
			CrabTankDead = sprCrabDead;
			
			 // Crystal Bat:
			p = m + "CrystalBat/";
			CrystalBatIdle = sprite(p + "sprCrystalBatIdle", 6, 16, 16);
			CrystalBatHurt = sprite(p + "sprCrystalBatHurt", 3, 16, 16);
			CrystalBatDead = sprite(p + "sprCrystalBatDead", 8, 16, 16);
			CrystalBatTell = sprite(p + "sprCrystalBatTell", 2, 16, 16);
			CrystalBatDash = sprite(p + "sprCrystalBatDash", 4, 16, 16);
			
			 // Crystal Bat (Cursed):
			p = m + "InvCrystalBat/";
			InvCrystalBatIdle = sprite(p + "sprInvCrystalBatIdle", 6, 16, 16);
			InvCrystalBatHurt = sprite(p + "sprInvCrystalBatHurt", 3, 16, 16);
			InvCrystalBatDead = sprite(p + "sprInvCrystalBatDead", 8, 16, 16);
			InvCrystalBatTell = sprite(p + "sprInvCrystalBatTell", 2, 16, 16);
			InvCrystalBatDash = sprite(p + "sprInvCrystalBatDash", 4, 16, 16);
			
			 // Crystal Brain:
			p = m + "CrystalBrain/";
			CrystalBrainIdle          = sprite(p + "sprCrystalBrainIdle",           6, 24, 24);
			CrystalBrainHurt          = sprite(p + "sprCrystalBrainHurt",           3, 24, 24);
			CrystalBrainDead          = sprite(p + "sprCrystalBrainDead",           7, 24, 24);
			CrystalBrainAppear        = sprite(p + "sprCrystalBrainAppear",         4, 24, 24);
			CrystalBrainDisappear     = sprite(p + "sprCrystalBrainDisappear",      7, 24, 24);
			CrystalBrainChunk         = sprite(p + "sprCrystalBrainChunk",          4,  8,  8);
			CrystalBrainPart          = sprite(p + "sprCrystalBrainPart",           7, 24, 24);
			CrystalBrainEffect        = sprite(p + "sprCrystalBrainEffect",        10,  8,  8);
			CrystalBrainEffectAlly    = sprite(p + "sprCrystalBrainEffectAlly",    10,  8,  8);
			CrystalBrainEffectPopo    = sprite(p + "sprCrystalBrainEffectPopo",    10,  8,  8);
			CrystalBrainSurfMask      = sprite(p + "sprCrystalBrainSurfMask",       1,  0,  0);
			CrystalCloneOverlay       = sprite(p + "sprCrystalCloneOverlay",        8,  0,  0);
			CrystalCloneOverlayAlly   = sprite(p + "sprCrystalCloneOverlayAlly",    8,  0,  0);
			CrystalCloneOverlayPopo   = sprite(p + "sprCrystalCloneOverlayPopo",    8,  0,  0);
			CrystalCloneOverlayCorpse = sprite(p + "sprCrystalCloneOverlayCorpse",  8,  0,  0);
		//	CrystalCloneGun           = sprite_duplicate_ext(sprRevolver,   0, 1);
		//	CrystalCloneGunTB         = sprite_duplicate_ext(sprMachinegun, 0, 1);
			
			 // Crystal Heart:
			p = m + "CrystalHeart/";
			CrystalHeartIdle = sprite(p + "sprCrystalHeartIdle", 10, 24, 24);
			CrystalHeartHurt = sprite(p + "sprCrystalHeartHurt",  3, 24, 24);
			CrystalHeartDead = sprite(p + "sprCrystalHeartDead", 22, 24, 24);
			ChaosHeartIdle   = sprite(p + "sprChaosHeartIdle",   10, 24, 24);
			ChaosHeartHurt   = sprite(p + "sprChaosHeartHurt",    3, 24, 24);
			ChaosHeartDead   = sprite(p + "sprChaosHeartDead",   22, 24, 24);
			
			 // Diver:
			p = m + "Diver/";
			DiverIdle  = sprite(p + "sprDiverIdle",       4, 12, 12);
			DiverWalk  = sprite(p + "sprDiverWalk",       6, 12, 12);
			DiverHurt  = sprite(p + "sprDiverHurt",       3, 12, 12);
			DiverDead  = sprite(p + "sprDiverDead",       9, 24, 24);
			HarpoonGun = sprite(p + "sprDiverHarpoonGun", 1,  8,  8);
			
			 // Eel:
			p = m + "Eel/";
			EelIdle    =[sprite(p + "sprEelIdleBlue",    8, 16, 16),
			             sprite(p + "sprEelIdlePurple",  8, 16, 16),
			             sprite(p + "sprEelIdleGreen",   8, 16, 16)];
			EelHurt    =[sprite(p + "sprEelHurtBlue",    3, 16, 16),
			             sprite(p + "sprEelHurtPurple",  3, 16, 16),
			             sprite(p + "sprEelHurtGreen",   3, 16, 16)];
			EelDead    =[sprite(p + "sprEelDeadBlue",    9, 16, 16),
			             sprite(p + "sprEelDeadPurple",  9, 16, 16),
			             sprite(p + "sprEelDeadGreen",   9, 16, 16)];
			EelTell    =[sprite(p + "sprEelTellBlue",    8, 16, 16),
			             sprite(p + "sprEelTellPurple",  8, 16, 16),
			             sprite(p + "sprEelTellGreen",   8, 16, 16)];
			EeliteIdle = sprite(p + "sprEelIdleElite",   8, 16, 16);
			EeliteHurt = sprite(p + "sprEelHurtElite",   3, 16, 16);
			EeliteDead = sprite(p + "sprEelDeadElite",   9, 16, 16);
			WantEel    = sprite(p + "sprWantEel",       16, 16, 16);
			
			 // Fish Freaks:
			p = m + "FishFreak/";
			FishFreakIdle = sprite(p + "sprFishFreakIdle",  6, 12, 12);
			FishFreakWalk = sprite(p + "sprFishFreakWalk",  6, 12, 12);
			FishFreakHurt = sprite(p + "sprFishFreakHurt",  3, 12, 12);
			FishFreakDead = sprite(p + "sprFishFreakDead", 11, 12, 12);
			
			 // Gull:
			p = m + "Gull/";
			GullIdle  = sprite(p + "sprGullIdle",  4, 12, 12);
			GullWalk  = sprite(p + "sprGullWalk",  6, 12, 12);
			GullHurt  = sprite(p + "sprGullHurt",  3, 12, 12);
			GullDead  = sprite(p + "sprGullDead",  6, 16, 16);
			GullSword = sprite(p + "sprGullSword", 1,  6,  8);
			
			 // Hammerhead Fish:
			p = m + "Hammer/";
			HammerSharkIdle = sprite(p + "sprHammerSharkIdle",  6, 24, 24);
			HammerSharkHurt = sprite(p + "sprHammerSharkHurt",  3, 24, 24);
			HammerSharkDead = sprite(p + "sprHammerSharkDead", 10, 24, 24);
			HammerSharkChrg = sprite(p + "sprHammerSharkDash",  2, 24, 24);
			
			 // Jellyfish (0 = blue, 1 = purple, 2 = green, 3 = elite):
			p = m + "Jellyfish/";
			JellyFire      = sprite(p + "sprJellyfishFire",        6, 24, 24);
			JellyEliteFire = sprite(p + "sprJellyfishEliteFire",   6, 24, 24);
			JellyIdle      =[sprite(p + "sprJellyfishBlueIdle",    8, 24, 24),
			                 sprite(p + "sprJellyfishPurpleIdle",  8, 24, 24),
			                 sprite(p + "sprJellyfishGreenIdle",   8, 24, 24),
			                 sprite(p + "sprJellyfishEliteIdle",   8, 24, 24)];
			JellyHurt      =[sprite(p + "sprJellyfishBlueHurt",    3, 24, 24),
			                 sprite(p + "sprJellyfishPurpleHurt",  3, 24, 24),
			                 sprite(p + "sprJellyfishGreenHurt",   3, 24, 24),
			                 sprite(p + "sprJellyfishEliteHurt",   3, 24, 24)];
			JellyDead      =[sprite(p + "sprJellyfishBlueDead",   10, 24, 24),
			                 sprite(p + "sprJellyfishPurpleDead", 10, 24, 24),
			                 sprite(p + "sprJellyfishGreenDead",  10, 24, 24),
			                 sprite(p + "sprJellyfishEliteDead",  10, 24, 24)];
			
			 // Lair Turret Reskin:
			p = m + "LairTurret/";
			LairTurretIdle   = sprite(p + "sprLairTurretIdle",    1, 12, 12);
			LairTurretHurt   = sprite(p + "sprLairTurretHurt",    3, 12, 12);
			LairTurretDead   = sprite(p + "sprLairTurretDead",    6, 12, 12);
			LairTurretFire   = sprite(p + "sprLairTurretFire",    3, 12, 12);
			LairTurretAppear = sprite(p + "sprLairTurretAppear", 11, 12, 12);
			
			 // Miner Bandit:
			p = m + "MinerBandit/";
			MinerBanditIdle = sprite(p + "sprMinerBanditIdle", 4, 12, 12);
			MinerBanditWalk = sprite(p + "sprMinerBanditWalk", 6, 12, 12);
			MinerBanditHurt = sprite(p + "sprMinerBanditHurt", 3, 12, 12);
			MinerBanditDead = sprite(p + "sprMinerBanditDead", 6, 12, 12);
			
			 // Mortar:
			p = m + "Mortar/";
			MortarIdle = sprite(p + "sprMortarIdle",  4, 22, 24);
			MortarWalk = sprite(p + "sprMortarWalk",  8, 22, 24);
			MortarFire = sprite(p + "sprMortarFire", 16, 22, 24);
			MortarHurt = sprite(p + "sprMortarHurt",  3, 22, 24);
			MortarDead = sprite(p + "sprMortarDead", 14, 22, 24);
			
			 // Mortar (Cursed):
			p = m + "InvMortar/";
			InvMortarIdle = sprite(p + "sprInvMortarIdle",  4, 22, 24);
			InvMortarWalk = sprite(p + "sprInvMortarWalk",  8, 22, 24);
			InvMortarFire = sprite(p + "sprInvMortarFire", 16, 22, 24);
			InvMortarHurt = sprite(p + "sprInvMortarHurt",  3, 22, 24);
			InvMortarDead = sprite(p + "sprInvMortarDead", 14, 22, 24);
			
			 // Palanking:
			p = m + "Palanking/";
			PalankingBott  = sprite(p + "sprPalankingBase",   1, 40, 24);
			PalankingTaunt = sprite(p + "sprPalankingTaunt", 31, 40, 24);
			PalankingCall  = sprite(p + "sprPalankingCall",   9, 40, 24);
			PalankingIdle  = sprite(p + "sprPalankingIdle",  16, 40, 24);
			PalankingWalk  = sprite(p + "sprPalankingWalk",  16, 40, 24);
			PalankingHurt  = sprite(p + "sprPalankingHurt",   3, 40, 24);
			PalankingDead  = sprite(p + "sprPalankingDead",  11, 40, 24);
			PalankingBurp  = sprite(p + "sprPalankingBurp",   5, 40, 24);
			PalankingFire  = sprite(p + "sprPalankingFire",  11, 40, 24);
			PalankingFoam  = sprite(p + "sprPalankingFoam",   1, 40, 24);
			PalankingChunk = sprite(p + "sprPalankingChunk",  5, 16, 16);
			GroundSlash    = sprite(p + "sprGroundSlash",     3,  0, 21);
			PalankingSlash = sprite(p + "sprPalankingSlash",  3,  0, 29);
			msk.Palanking  = sprite(p + "mskPalanking",       1, 40, 24);
			with(msk.Palanking){
				mask = [false, 0];
			}
			
			 // Patch Gator (Eyepatch Reskin):
			p = m + "PatchGator/";
			PatchGatorIdle = sprite(p + "sprPatchGatorIdle", 8, 12, 12);
			PatchGatorWalk = sprite(p + "sprPatchGatorWalk", 6, 12, 12);
			PatchGatorHurt = sprite(p + "sprPatchGatorHurt", 3, 12, 12);
			PatchGatorDead = sprite(p + "sprPatchGatorDead", 6, 12, 12);
			
			 // Pelican:
			p = m + "Pelican/";
			PelicanIdle   = sprite(p + "sprPelicanIdle",   6, 24, 24);
			PelicanWalk   = sprite(p + "sprPelicanWalk",   6, 24, 24);
			PelicanHurt   = sprite(p + "sprPelicanHurt",   3, 24, 24);
			PelicanDead   = sprite(p + "sprPelicanDead",   6, 24, 24);
			PelicanHammer = sprite(p + "sprPelicanHammer", 1,  6,  8, shnWep);
			
			 // Pit Squid:
			p = m + "Pitsquid/";
				
				 // Eyes:
				PitSquidCornea  = sprite(p + "sprPitsquidCornea", 1, 19, 19);
				PitSquidPupil   = sprite(p + "sprPitsquidPupil",  1, 19, 19);
				PitSquidEyelid  = sprite(p + "sprPitsquidEyelid", 3, 19, 19);
				
				 // Tentacles:
				TentacleIdle = sprite(p + "sprTentacleIdle", 8, 20, 28);
				TentacleHurt = sprite(p + "sprTentacleHurt", 3, 20, 28);
				TentacleDead = sprite(p + "sprTentacleDead", 4, 20, 28);
				TentacleSpwn = sprite(p + "sprTentacleSpwn", 6, 20, 28);
				TentacleTele = sprite(p + "sprTentacleTele", 6, 20, 28);
				
				 // Maw:
				PitSquidMawBite = sprite(p + "sprPitsquidMawBite", 14, 19, 19);
				PitSquidMawSpit = sprite(p + "sprPitsquidMawSpit", 10, 19, 19);
				
				 // Particles:
				p += "Particles/";
				PitSpark = [
					sprite(p + "sprPitSpark1", 5, 16, 16),
					sprite(p + "sprPitSpark2", 5, 16, 16),
					sprite(p + "sprPitSpark3", 5, 16, 16),
					sprite(p + "sprPitSpark4", 5, 16, 16),
					sprite(p + "sprPitSpark5", 5, 16, 16),
				];
				TentacleWheel    = sprite(p + "sprTentacleWheel",    2, 40, 40);
				SquidCharge      = sprite(p + "sprSquidCharge",      5, 24, 24);
				SquidBloodStreak = sprite(p + "sprSquidBloodStreak", 7,  0,  8);
				
			 // Popo Security:
			p = m + "PopoSecurity/";
			PopoSecurityIdle    = sprite(p + "sprPopoSecurityIdle",    11, 16, 16);
			PopoSecurityWalk    = sprite(p + "sprPopoSecurityWalk",    6,  16, 16);
			PopoSecurityHurt    = sprite(p + "sprPopoSecurityHurt",    3,  16, 16);
			PopoSecurityDead    = sprite(p + "sprPopoSecurityDead",    7,  16, 16);
			PopoSecurityCannon  = sprite(p + "sprPopoSecurityCannon",  1,  7,  8);
			PopoSecurityMinigun = sprite(p + "sprPopoSecurityMinigun", 1,  7,  8);
			
			 // Portal Guardian:
			p = m + "PortalGuardian/";
			PortalGuardianIdle      = sprite(p + "sprPortalGuardianIdle",       4, 16, 16);
			PortalGuardianHurt      = sprite(p + "sprPortalGuardianHurt",       3, 16, 16);
			PortalGuardianDead      = sprite(p + "sprPortalGuardianDead",       9, 32, 32);
			PortalGuardianAppear    = sprite(p + "sprPortalGuardianAppear",     5, 32, 32);
			PortalGuardianDisappear = sprite(p + "sprPortalGuardianDisappear",  4, 32, 32);
			PortalGuardianImplode   = sprite(p + "sprPortalGuardianImplode",   17, 32, 32);
			
			 // Puffer:
			p = m + "Puffer/";
			PufferIdle       = sprite(p + "sprPufferIdle",    6, 15, 16);
			PufferHurt       = sprite(p + "sprPufferHurt",    3, 15, 16);
			PufferDead       = sprite(p + "sprPufferDead",   11, 15, 16);
			PufferChrg       = sprite(p + "sprPufferChrg",    9, 15, 16);
			PufferFire[0, 0] = sprite(p + "sprPufferBlow0",   2, 15, 16);
			PufferFire[0, 1] = sprite(p + "sprPufferBlowB0",  2, 15, 16);
			PufferFire[1, 0] = sprite(p + "sprPufferBlow1",   2, 15, 16);
			PufferFire[1, 1] = sprite(p + "sprPufferBlowB1",  2, 15, 16);
			PufferFire[2, 0] = sprite(p + "sprPufferBlow2",   2, 15, 16);
			PufferFire[2, 1] = sprite(p + "sprPufferBlowB2",  2, 15, 16);
			PufferFire[3, 0] = sprite(p + "sprPufferBlow3",   2, 15, 16);
			PufferFire[3, 1] = sprite(p + "sprPufferBlowB3",  2, 15, 16);
			
			 // Red Crystal Spider:
			p = m + "RedSpider/";
			RedSpiderIdle = sprite(p + "sprRedSpiderIdle", 8, 12, 12);
			RedSpiderWalk = sprite(p + "sprRedSpiderWalk", 6, 12, 12);
			RedSpiderHurt = sprite(p + "sprRedSpiderHurt", 3, 12, 12);
			RedSpiderDead = sprite(p + "sprRedSpiderDead", 7, 12, 12);
			
			 // Saw Trap:
			p = m + "SawTrap/";
			SawTrap       = sprite(p + "sprSawTrap",       1, 20, 20);
			SawTrapHurt   = sprite(p + "sprSawTrapHurt",   3, 20, 20);
			SawTrapDebris = sprite(p + "sprSawTrapDebris", 4,  8,  8);
			
			 // Seal:
			p = m + "Seal/";
			SealIdle = [];
			SealWalk = [];
			SealHurt = [];
			SealDead = [];
			SealSpwn = [];
			SealWeap = [];
			for(var i = 0; i <= 6; i++){
				var n = ((i <= 0) ? "" : string(i));
				SealIdle[i] = sprite(p + "sprSealIdle" + n, 6, 12, 12);
				SealWalk[i] = sprite(p + "sprSealWalk" + n, 6, 12, 12);
				SealHurt[i] = sprite(p + "sprSealHurt" + n, 3, 12, 12);
				SealDead[i] = sprite(p + "sprSealDead" + n, 6, 12, 12);
				SealSpwn[i] = sprite(p + "sprSealSpwn" + n, 6, 12, 12);
				SealWeap[i] = mskNone;
			}
			SealWeap[1] = sprite(p + "sprHookPole",    1, 18,  2);
			SealWeap[2] = sprite(p + "sprSabre",       1, -2,  1);
			SealWeap[3] = sprite(p + "sprBlunderbuss", 1,  7,  1);
			SealWeap[4] = sprite(p + "sprRepeater",    1,  6,  2);
			SealWeap[6] = sprBanditGun;
			SealDisc    = sprite(p + "sprSealDisc",    2,  7,  7);
			SkealIdle   = sprite(p + "sprSkealIdle",   6, 12, 12);
			SkealWalk   = sprite(p + "sprSkealWalk",   7, 12, 12);
			SkealHurt   = sprite(p + "sprSkealHurt",   3, 12, 12);
			SkealDead   = sprite(p + "sprSkealDead",  10, 16, 16);
			SkealSpwn   = sprite(p + "sprSkealSpwn",   8, 16, 16);
			
			 // Seal (Heavy):
			p = m + "SealHeavy/";
			SealHeavySpwn = sprite(p + "sprHeavySealSpwn",    6, 16, 17);
			SealHeavyIdle = sprite(p + "sprHeavySealIdle",   10, 16, 17);
			SealHeavyWalk = sprite(p + "sprHeavySealWalk",    8, 16, 17);
			SealHeavyHurt = sprite(p + "sprHeavySealHurt",    3, 16, 17);
			SealHeavyDead = sprite(p + "sprHeavySealDead",    7, 16, 17);
			SealHeavyTell = sprite(p + "sprHeavySealTell",    2, 16, 17);
			SealAnchor    = sprite(p + "sprHeavySealAnchor",  1,  0, 12);
			SealChain     = sprite(p + "sprChainSegment",     1,  0,  0);
			
			 // Silver Scorpion:
			p = m + "SilverScorpion/";
			SilverScorpionIdle = sprite(p + "sprSilverScorpionIdle", 14, 24, 24);
			SilverScorpionWalk = sprite(p + "sprSilverScorpionWalk", 6,  24, 24);
			SilverScorpionHurt = sprite(p + "sprSilverScorpionHurt", 3,  24, 24);
			SilverScorpionDead = sprite(p + "sprSilverScorpionDead", 6,  24, 24);
			SilverScorpionFire = sprite(p + "sprSilverScorpionFire", 2,  24, 24);
			SilverScorpionFlak = sprite(p + "sprSilverScorpionFlak", 4,  10, 10);
			
			 // Spiderling:
			p = m + "Spiderling/";
			SpiderlingIdle     = sprite(p + "sprSpiderlingIdle",     4, 8, 8);
			SpiderlingWalk     = sprite(p + "sprSpiderlingWalk",     4, 8, 8);
			SpiderlingHurt     = sprite(p + "sprSpiderlingHurt",     3, 8, 8);
			SpiderlingDead     = sprite(p + "sprSpiderlingDead",     7, 8, 8);
			SpiderlingHatch    = sprite(p + "sprSpiderlingHatch",    5, 8, 8);
			InvSpiderlingIdle  = sprite(p + "sprInvSpiderlingIdle",  4, 8, 8);
			InvSpiderlingWalk  = sprite(p + "sprInvSpiderlingWalk",  4, 8, 8);
			InvSpiderlingHurt  = sprite(p + "sprInvSpiderlingHurt",  3, 8, 8);
			InvSpiderlingDead  = sprite(p + "sprInvSpiderlingDead",  7, 8, 8);
			InvSpiderlingHatch = sprite(p + "sprInvSpiderlingHatch", 5, 8, 8);
			
			 // Tesseract:
			p = m + "Tesseract/";
			TesseractIdle           = sprite(p + "sprTesseractEyeIdle",           8,  8,  8);
			TesseractHurt           = sprite(p + "sprTesseractEyeHurt",           3,  8,  8);
			TesseractFire           = sprite(p + "sprTesseractEyeFire",           4,  8,  8);
			TesseractTell           = sprite(p + "sprTesseractEyeTell",           6,  8,  8);
			TesseractLayer          =[sprite(p + "sprTesseractLayerBottom",       2, 48, 48),
			                          sprite(p + "sprTesseractLayerMiddle",       2, 48, 48),
			                          sprite(p + "sprTesseractLayerTop",          2, 48, 48)];
			TesseractDeathLayer     =[sprite(p + "sprTesseractDeathLayerBottom",  3, 48, 48),
			                          sprite(p + "sprTesseractDeathLayerMiddle",  6, 48, 48),
			                          sprite(p + "sprTesseractDeathLayerTop",    11, 48, 48)];
			TesseractDeathCause     = sprite(p + "sprTesseractDeathCause",        8, 48, 48);
			TesseractDeathCauseText = sprite(p + "sprTesseractDeathCauseText",   12, 36,  4);
			TesseractWeapon         = sprite(p + "sprTesseractWeapon",            1, 24, 24);
			TesseractStrike         = sprite(p + "sprTesseractStrike",            4, 26, 12);
			with(TesseractDeathLayer){
				mask = [true, 0];
			}
			
			 // Traffic Crab:
			p = m + "Crab/";
			CrabIdle = sprite(p + "sprTrafficCrabIdle", 5, 24, 24);
			CrabWalk = sprite(p + "sprTrafficCrabWalk", 6, 24, 24);
			CrabHurt = sprite(p + "sprTrafficCrabHurt", 3, 24, 24);
			CrabDead = sprite(p + "sprTrafficCrabDead", 9, 24, 24);
			CrabFire = sprite(p + "sprTrafficCrabFire", 2, 24, 24);
			CrabHide = sprite(p + "sprTrafficCrabHide", 5, 24, 24);
			
			 // Yeti Crab:
			p = m + "YetiCrab/";
			YetiCrabIdle = sprite(p + "sprYetiCrab", 1, 12, 12);
			KingCrabIdle = sprite(p + "sprKingCrab", 1, 12, 12);
			
		//#endregion
		
		//#region CAMPFIRE
		m = "areas/Campfire/";
		p = m;
			
			 // Loading Screen:
			SpiralDebrisNothing = sprite(p + "sprSpiralDebrisNothing", 5, 24, 24);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Big Cactus:
				BigNightCactusIdle = sprite(p + "sprBigNightCactus",     1, 16, 16);
				BigNightCactusHurt = sprite(p + "sprBigNightCactus",     1, 16, 16, shnHurt);
				BigNightCactusDead = sprite(p + "sprBigNightCactusDead", 4, 16, 16);
				
			//#endregion
			
		//#endregion
		
		//#region DESERT
		m = "areas/Desert/";
		p = m;
			
			 // Big Decal:
			BigTopDecal[?     area_desert] = sprite(p + "sprBigTopDecalDesert",         1, 32, 56);
			msk.BigTopDecal[? area_desert] = sprite(p + "../mskBigTopDecal",            1, 32, 12);
			BigTopDecalScorpion            = sprite(p + "sprBigTopDecalScorpion",       1, 32, 52);
			BigTopDecalScorpionDebris      = sprite(p + "sprBigTopDecalScorpionDebris", 8, 10, 10);
			
			 // Fly:
			FlySpin = sprite(p + "sprFlySpin", 16, 4, 4);
			
			 // Wall Rubble:
			Wall1BotRubble = sprite(p + "sprWall1BotRubble", 4, 0,  0);
			Wall1TopRubble = sprite(p + "sprWall1TopRubble", 4, 0,  0);
			Wall1OutRubble = sprite(p + "sprWall1OutRubble", 4, 4, 12);
			
			 // Wall Bro:
			WallBandit = sprite(p + "sprWallBandit", 9, 8, 8);
			
			 // Scorpion Floor:
			FloorScorpion     = sprite(p + "sprFloorScorpion",     2, 8, 8);
			SnowFloorScorpion = sprite(p + "sprSnowFloorScorpion", 1, 8, 8);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Camp:
				BanditCampfire     = sprite(p + "sprBanditCampfire",     1, 26, 26);
				BanditTentIdle     = sprite(p + "sprBanditTent",         1, 24, 24);
				BanditTentHurt     = sprite(p + "sprBanditTentHurt",     3, 24, 24);
				BanditTentDead     = sprite(p + "sprBanditTentDead",     3, 24, 24);
				BanditTentWallIdle = sprite(p + "sprBanditTentWall",     1, 24, 24);
				BanditTentWallHurt = sprite(p + "sprBanditTentWallHurt", 3, 24, 24);
				BanditTentWallDead = sprite(p + "sprBanditTentWallDead", 3, 24, 24);
				shd.BanditTent     = sprite(p + "shdBanditTent",         1, 24, 24);
				
				 // Big Cactus:
				BigCactusIdle = sprite(p + "sprBigCactus",     1, 16, 16);
				BigCactusHurt = sprite(p + "sprBigCactus",     1, 16, 16, shnHurt);
				BigCactusDead = sprite(p + "sprBigCactusDead", 4, 16, 16);
				
				 // Return of a Legend:
				CowSkullIdle = sprite(p + "sprCowSkull",     1, 24, 24);
				CowSkullHurt = sprite(p + "sprCowSkull",     1, 24, 24, shnHurt);
				CowSkullDead = sprite(p + "sprCowSkullDead", 3, 24, 24);
				
				 // Scorpion Rock:
				ScorpionRock         = sprite(p + "sprScorpionRock",     6, 16, 16);
				ScorpionRockAlly     = sprite(p + "sprScorpionRockAlly", 6, 16, 16);
				ScorpionRockHurt     = sprite(p + "sprScorpionRock",     6, 16, 16, shnHurt);
				ScorpionRockAllyHurt = sprite(p + "sprScorpionRockAlly", 6, 16, 16, shnHurt);
				ScorpionRockDead     = sprite(p + "sprScorpionRockDead", 3, 16, 16);
				
			//#endregion
			
		//#endregion
		
		//#region SCRAPYARD
		m = "areas/Scrapyard/";
		p = m;
			
			 // Decals:
			BigTopDecal[? area_scrapyards] = sprite(p + "sprBigTopDecalScrapyard",  1, 32, 48);
			TopDecalScrapyardAlt           = sprite(p + "sprTopDecalScrapyardAlt",  1, 16, 16);
			NestDebris                     = sprite(p + "sprNestDebris",           16,  4,  4);
			
			 // Sludge Pool:
			SludgePool          = sprite(p + "sprSludgePool",      4,  0,  0);
			msk.SludgePool      = sprite(p + "mskSludgePool",      1, 32, 32);
			msk.SludgePoolSmall = sprite(p + "mskSludgePoolSmall", 1, 16, 16);
			
			 // Fire Pit Event:
			FirePitScorch = sprite(p + "sprFirePitScorch", 3, 16, 16);
			TrapSpin      = sprite(p + "sprTrapSpin",      8, 12, 12);
			
		//#endregion
		
		//#region CRYSTAL CAVES
		m = "areas/Caves/";
		p = m;
			
			 // Decals:
			BigTopDecal[?     area_caves       ] = sprite(p + "sprBigTopDecalCaves",       1, 32, 56);
			BigTopDecal[?     area_cursed_caves] = sprite(p + "sprBigTopDecalCursedCaves", 1, 32, 56);
			msk.BigTopDecal[? area_caves       ] = sprite(p + "../mskBigTopDecal",         1, 32, 16);
			msk.BigTopDecal[? area_cursed_caves] = msk.BigTopDecal[? area_caves];
			
			 // Wall Spiders:
			WallSpider          = sprite(p + "sprWallSpider",          2, 8, 8);
			WallSpiderBot       = sprite(p + "sprWallSpiderBot",       2, 0, 0);
			WallSpiderling      = sprite(p + "sprWallSpiderling",      4, 8, 8);
			WallSpiderlingTrans = sprite(p + "sprWallSpiderlingTrans", 4, 8, 8);
			
			 // Cave Hole:
			CaveHole	   = sprite(p + "sprCaveHole",		 1, 64, 64);
			CaveHoleCursed = sprite(p + "sprCaveHoleCursed", 1, 64, 64);
			msk.CaveHole   = sprite(p + "mskCaveHole",		 1, 64, 64);
			with(msk.CaveHole){
				mask = [false, 0];
			}
			
			//#region PROPS
			p = m + "Props/";
				
				 // Big Crystal Prop:
				BigCrystalPropIdle = sprite(p + "sprBigCrystalPropIdle", 1, 16, 16);
				BigCrystalPropHurt = sprite(p + "sprBigCrystalPropIdle", 1, 16, 16, shnHurt);
				BigCrystalPropDead = sprite(p + "sprBigCrystalPropDead", 4, 16, 16);
				
				 // Cursed Big Crystal Prop:
				InvBigCrystalPropIdle = sprite(p + "sprInvBigCrystalPropIdle", 1, 16, 16);
				InvBigCrystalPropHurt = sprite(p + "sprInvBigCrystalPropIdle", 1, 16, 16, shnHurt);
				InvBigCrystalPropDead = sprite(p + "sprInvBigCrystalPropDead", 4, 16, 16);
			
			//#endregion
			
		//#endregion
		
		//#region FROZEN CITY
		m = "areas/City/";
		p = m;
			
			 // FIX CRAP:
			sprite_replace(sprWall5Bot, "sprites/" + p + "sprWall5BotFix.png", 3);
			
			 // Seal Plaza:
			FloorSeal            = sprite(p + "sprFloorSeal",         4, 16, 16);
			SnowFloorSeal        = sprite(p + "sprFloorSeal",         4, 16, 16, shnSnow);
			FloorSealRoom        = sprite(p + "sprFloorSealRoom",     9, 16, 16);
			SnowFloorSealRoom    = sprite(p + "sprFloorSealRoom",     9, 16, 16, shnSnow);
			FloorSealRoomBig     = sprite(p + "sprFloorSealRoomBig", 25, 16, 16);
			SnowFloorSealRoomBig = sprite(p + "sprFloorSealRoomBig", 25, 16, 16, shnSnow);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Igloos:
				IglooFrontIdle = sprite(p + "sprIglooFront",     1, 24, 24);
				IglooFrontHurt = sprite(p + "sprIglooFrontHurt", 3, 24, 24);
				IglooFrontDead = sprite(p + "sprIglooFrontDead", 3, 24, 24);
				IglooSideIdle  = sprite(p + "sprIglooSide",      1, 24, 24);
				IglooSideHurt  = sprite(p + "sprIglooSideHurt",  3, 24, 24);
				IglooSideDead  = sprite(p + "sprIglooSideDead",  3, 24, 24);
				
				 // Palanking Statue:
				PalankingStatueIdle  =[sprite(p + "sprPalankingStatue1",     1, 32, 32),
				                       sprite(p + "sprPalankingStatue2",     1, 32, 32),
				                       sprite(p + "sprPalankingStatue3",     1, 32, 32),
				                       sprite(p + "sprPalankingStatue4",     1, 32, 32)];
				PalankingStatueHurt  =[sprite(p + "sprPalankingStatue1",     1, 32, 32, shnHurt),
				                       sprite(p + "sprPalankingStatue2",     1, 32, 32, shnHurt),
				                       sprite(p + "sprPalankingStatue3",     1, 32, 32, shnHurt),
				                       sprite(p + "sprPalankingStatue4",     1, 32, 32, shnHurt)];
				PalankingStatueDead  = sprite(p + "sprPalankingStatueDead",  3, 32, 32);
				PalankingStatueChunk = sprite(p + "sprPalankingStatueChunk", 5, 16, 16);
				
			//#endregion
			
		//#endregion
		
		//#region LABS
		m = "areas/Labs/";
		p = m;
			
			 // Freak Chamber:
			Wall6BotTrans     = sprite(p + "sprWall6BotTrans",     4,  0,  0);
			FreakChamberAlarm = sprite(p + "sprFreakChamberAlarm", 4, 12, 12);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Mutant Vat:
				MutantVatIdle  = sprite(p + "sprMutantVat",      1, 32, 32);
				MutantVatHurt  = sprite(p + "sprMutantVatHurt",  3, 32, 32);
				MutantVatDead  = sprite(p + "sprMutantVatDead",  3, 32, 32);
				MutantVatBack  = sprite(p + "sprMutantVatBack",  6, 32, 32);
				MutantVatLid   = sprite(p + "sprMutantVatLid",   8, 24, 24);
				MutantVatGlass = sprite(p + "sprMutantVatGlass", 4, 6,  6);
				
				 // Button:
				ButtonIdle        = sprite(p + "sprButtonIdle",         1, 16, 16);
				ButtonHurt        = sprite(p + "sprButtonHurt",         3, 16, 16);
				ButtonPressedIdle = sprite(p + "sprButtonPressedIdle",  1, 16, 16);
				ButtonPressedHurt = sprite(p + "sprButtonPressedHurt",  3, 16, 16);
				ButtonDead        = sprite(p + "sprButtonDead",         4, 16, 16);
				ButtonDebris      = sprite(p + "sprButtonDebris",       1, 12, 12);
				ButtonRevive      = sprite(p + "sprButtonRevive",      12, 24, 48);
				ButtonReviveArea  = sprite(p + "sprButtonReviveArea",   8, 20, 20);
				PickupRevive      = sprite(p + "sprPickupRevive",      12, 24, 48);
				PickupReviveArea  = sprite(p + "sprPickupReviveArea",   8, 20, 20);
				
			//#endregion
			
		//#endregion
		
		//#region PALACE
		m = "areas/Palace/";
		p = m;
			
			 // Decals:
			BigTopDecal[?     area_palace] = sprite(p + "sprBigTopDecalPalace", 1, 32, 56);
			msk.BigTopDecal[? area_palace] = sprite(p + "../mskBigTopDecal",    1, 32, 16);
			
			 // Generator Shadows Woooo:
			shd.BigGenerator  = sprite(p + "shdBigGenerator",  1, 48-16, 32);
			shd.BigGeneratorR = sprite(p + "shdBigGeneratorR", 1, 48+16, 32);
			
			 // Inactive Throne Hitbox (Can walk on top, so cool broo):
			msk.NothingInactiveCool = sprite(p + "mskNothingInactiveCool", 1, 150, 100);
			with(msk.NothingInactiveCool){
				mask = [false, 0];
			}
			
			 // Better Game Over Sprite (Big sprite so that the on-hover text is more mandatory):
			NothingDeathCause = sprite(p + "sprNothingDeathCause", 1, 80, 80);
			
			 // Throne Shadow:
			shd.Nothing = sprite(p + "shdNothing", 1, 128, 100);
			
			 // Stairs:
			FloorPalaceStairs       = sprite(p + "sprFloorPalaceStairs",       3, 0, 0);
			FloorPalaceStairsCarpet = sprite(p + "sprFloorPalaceStairsCarpet", 6, 0, 0);
			
			 // Shrine Floors:
			FloorPalaceShrine          = sprite(p + "sprFloorPalaceShrine",          10, 2, 2);
			FloorPalaceShrineRoomSmall = sprite(p + "sprFloorPalaceShrineRoomSmall",  4, 0, 0);
			FloorPalaceShrineRoomLarge = sprite(p + "sprFloorPalaceShrineRoomLarge",  9, 0, 0);
			
			 // Tiny TopSmalls:
			TopTiny[? sprWall7Trans] = [
				[sprite(p + "sprTopTinyPalace", 8,  0,  0),
				 sprite(p + "sprTopTinyPalace", 8,  0, -8)],
				[sprite(p + "sprTopTinyPalace", 8, -8,  0),
				 sprite(p + "sprTopTinyPalace", 8, -8, -8)]
			];
			
			//#region PROPS
			p = m + "Props/";
				
				 // Palace Altar:
				PalaceAltarIdle   = sprite(p + "sprPalaceAltar",       1, 24, 24);
				PalaceAltarHurt   = sprite(p + "sprPalaceAltarHurt",   3, 24, 24);
				PalaceAltarDead   = sprite(p + "sprPalaceAltarDead",   4, 24, 24);
				PalaceAltarDebris = sprite(p + "sprPalaceAltarDebris", 5,  8,  8);
				
				GroundFlameGreen             = sprite(p + "sprGroundFlameGreen",             8, 4, 6);
				GroundFlameGreenBig          = sprite(p + "sprGroundFlameGreenBig",          8, 6, 8);
				GroundFlameGreenDisappear    = sprite(p + "sprGroundFlameGreenDisappear",    4, 4, 6);
				GroundFlameGreenBigDisappear = sprite(p + "sprGroundFlameGreenBigDisappear", 4, 6, 8);
				
				 // Pillar (Connects to the ground better):
				sprite_replace(sprNuclearPillar,     "sprites/" + p + "sprNuclearPillar.png",     11, 24, 32);
				sprite_replace(sprNuclearPillarHurt, "sprites/" + p + "sprNuclearPillarHurt.png",  3, 24, 32);
				sprite_replace(sprNuclearPillarDead, "sprites/" + p + "sprNuclearPillarDead.png",  3, 24, 32);
				
			//#endregion
			
		//#endregion
		
		//#region VAULT
		m = "areas/Vault/";
		p = m;
			
			 // Tiny TopSmalls:
			TopTiny[? sprWall100Trans] = [
				[sprite(p + "sprTopTinyVault", 12,  0,  0),
				 sprite(p + "sprTopTinyVault", 12,  0, -8)],
				[sprite(p + "sprTopTinyVault", 12, -8,  0),
				 sprite(p + "sprTopTinyVault", 12, -8, -8)]
			];
			
			 // Vault Flower Room:
			VaultFlowerFloor	  = sprite(p + "sprFloorVaultFlower",	   9, 0, 0);
			VaultFlowerFloorSmall = sprite(p + "sprFloorVaultFlowerSmall", 4, 0, 0);
			
			 // Quest Hint Lore Tiles:
			FloorQuest = sprite(p + "sprFloorQuest", 4, 0, 0);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Vault Flower:
				VaultFlowerIdle         = sprite(p + "sprVaultFlower",              4, 24, 24);
				VaultFlowerHurt         = sprite(p + "sprVaultFlowerHurt",          3, 24, 24);
				VaultFlowerDead         = sprite(p + "sprVaultFlowerDead",          3, 24, 24);
				VaultFlowerWiltedIdle   = sprite(p + "sprVaultFlowerWilted",        1, 24, 24);
				VaultFlowerWiltedHurt   = sprite(p + "sprVaultFlowerWiltedHurt",    3, 24, 24);
				VaultFlowerWiltedDead   = sprite(p + "sprVaultFlowerWiltedDead",    3, 24, 24);
				VaultFlowerDebris       = sprite(p + "sprVaultFlowerDebris",       10,  4,  4);
				VaultFlowerWiltedDebris = sprite(p + "sprVaultFlowerWiltedDebris", 10,  4,  4);
				VaultFlowerSparkle      = sprite(p + "sprVaultFlowerSparkle",       4,  3,  3);
				
				 // Quest Props:
				QuestProp1Idle = sprite(p + "sprQuestProp1Idle", 1, 16, 16);
				QuestProp1Hurt = sprite(p + "sprQuestProp1Hurt", 3, 16, 16);
				QuestProp1Dead = sprite(p + "sprQuestProp1Dead", 3, 16, 16);
				QuestProp2Idle = sprite(p + "sprQuestProp2Idle", 1, 16, 16);
				QuestProp2Hurt = sprite(p + "sprQuestProp2Hurt", 3, 16, 16);
				QuestProp2Dead = sprite(p + "sprQuestProp2Dead", 3, 16, 16);
				QuestProp3Idle = sprite(p + "sprQuestProp3Idle", 1, 16, 16);
				QuestProp3Hurt = sprite(p + "sprQuestProp3Hurt", 3, 16, 16);
				QuestProp3Dead = sprite(p + "sprQuestProp3Dead", 3, 16, 16);
				
				 // Ghost Statue:
				GhostStatueIdle   = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAASUExURQAAAH9kQ1RCLDInGq+PagAAAHxMDEMAAAAGdFJOU///////ALO/pL8AAAAJcEhZcwAADsMAAA7DAcdvqGQAAAEnSURBVEhL7ZPREoUgCEQF7f9/+e4STSlkNnMf22nSkCMgWbaX+oAVpUCBfBqUAyJ6R+T2UuUuRh6hKJQjmbFIU2ktTysHDiWrmUm1IYRYWm47lViYkOBp6VllAPe+zSlacKbV3VcBbo8gteoqQOcXEYww96wRGYBOVyptdbDxT+XmigrwQ8V1Hw+Vim5ZOqyiaA0OPrrgYX4iBEHWsY7xky0GwIwsUjjZEIGZw58AifA79Z+4OEgJpfopISUZqrh+4d4YgIIpawYM/U3q5qzRW3zIDBNALYJrj8Ci3IHq5opVFnzVFOChYN38znf/S40AU0K555vIHLAWnM9jSiPAvKYRgh5qwI7WtuMNwzQCryY9r8M/AWSwH/0wzACfXjQBlvQBz9q2H25QJL3vdkDHAAAAAElFTkSuQmCC",
				1,  24, 24);
				GhostStatueHurt   = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAJAAAAAwCAYAAAD+WvNWAAAAAXNSR0IArs4c6QAAA25JREFUeJztnLFS4zAQhn9u7gnSeCbp3GQYu2DSQ+HU6dzR5j0yvAftdXTUUEDPUJBh0rgLM2nyCroC1kjCzmEjS5vTflWwHfmf1Wq1WokAgiAIgiAIgiAIgiAcCSeuG1RKKeMFJyfO3zEwyvpb9B9gcAcCjs6J1Go5BwCsqx1u7l+A43KiY9f/7kQ2oTV1RM2mY7VazhXeR7Tob8FLBDJeyD8aKQAoi9y4+DGSAf6j2av+3y4b+06kUUopxk6kVss5zrIp/tw+IEsTnGVTAECWJjQlKPB1Iu/6nRqiy1TF1Inq/OEQV9d3AE8n8q7fmRH65DnMnEhR2L9cXABAPYqB94RUh2FyGkT/r582APRzHmao1XJeG/55vcHzemM8cLm4QJYmdYcwI5h+Jw70v0BGX1c7rKudYWy9Q5g6URD9MoV9ombTMQBgcX76z4cZ5kFB9DtdhR076WRkjE49b6i2+8ZnOBFCvziQBRmdDE6jmavT2PjWL8t4E6UX4JqMznx7wLt+75VogK3zEAoAKJ/Qedq80UfR76qhny7hGTiToV8vxOnTgZ47fCSgRNT6f7SMd1H/CVxDUrPpGGWRf9k7AswpwJ4OyiKnUR61/t7e57rjA0QiVRY5qu3eWPZeXd+hLPLa4LePr0gnIwCfG5I0yuleoJyIhf6oC4lZmtTGtaFinI0+RYRe0nPQH7UD2Qam0dtGWeR2/tDYSb7goL9XHWiIvMXzMQ81m46RpQluH1+NUUhhXl/FUE1FW8XU1xfnp6i2ezxt3nwe82Cjv5MDDZ3wUvsDOlJ92IqMqrNazrGudo330snoYMgvi5zO2gDDORI7/dFVoikHqLb7xvDddcea2qDv2VOEa7jpjzYH6pNAtnVYWyI7JFz0RxeB7GMO6WTUKZHUnw3hONz0RxeBmnar28L+d67rHeJjRcZNf3QOpJOliZFw9vncdmTUBxz0RzeFNdFmvC7XqSO0f5/xRkj9UUcgF1GDUyExRBtRRyA7R+j7mTrBtzNx0B+1A+kbjQC+FODoXtt1ukd/Z2nidQrjoD/aKYyMSqO4qXrbtoqh5JPuNX13aLjoj9aBBDdEN4XRPG8X0Q4V1b5zz1f+w01/p02/oX48yuOPUhmHzm/uX5y8pyzyWv/Ah8uOXb8gCIIgCIIgCIIgCOH4C7CPysIjtKRSAAAAAElFTkSuQmCC", 
				3,  24, 24);
				GhostStatueDead   = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAMAAAAAwCAYAAABHTnUeAAAAAXNSR0IArs4c6QAABBdJREFUeJztnT1OI0EQhZ9XewInSHY2iYVw5JzExGQ+AvdAe489AhnxkpATgSySyQaJZK4wG0ANNeVu/073NPT7JARjz8+r7qruqp6WAAghhBBCCCGEEEIIIeRHM+r7hk3TNJ0HjEa9P4OQvvgV+gE2IAhJiSCjs8vpOROQFAmeAm08kIFAEqJXZ9w33WEQkFQIXgO4YF1AUqG3kfgYp+ZMQIamlxmAIzr5rgySAhGSCr0EAFMZ8l3hDECyhgFAsmaQ9wAA0yaSBtHfBAN0fpIOJzviqUugCQaDtSc1fS726YOU7RhM/0k37Wv9f+Ag6Nhwe3MFAHgp3wEAdw/PvutScqhG674oztq/AaCsajy9vtlrqP+Um/T98mvAIHA2PgDcP64BANeX5+33wpbAAOI5VwMAi9kExXQMAB39wJcNxXTccSyP/th9MLj+34de8INoA1gc2za+5aI4a4PEjlLy/Z+//0Jo9bJazjvafGjbrP4hdAtD6896GXS1nGMxm3gdv5iO25HJh752WweGoqxqlFW9oUXQNvj0DaFbGFr/UQEQYu9P5P1EG8+yjixTrxzLjxxryqrujEqRaBaziTM9k2NrgwvRvphNgP2K0b5IQv9BKVBoJ5X7B6wHGuBj5JeGK6u6U2xZhh7hHXRsECSF2MeGyIFqSUp/djWAFLy28eW37gTb0DpPtZ3l67wQaBtsDXJRnG0U7xaX9pikpD/rGuClfEcxHW90gi/3tw2tzzHBEiWV0Csj9vNd+q12dRwtDUpBf3YzgJ5C7YjuOhfozhaujpHPiukYT69vWMwmeHp9axBoWdEViMfot7Z85tFBtWtdWsdQ+rOcAWTkF44tYF3TsHRCSFx1icsGvcICfKQUco7+LnYKlJL+nAKgub252lrUSqPqznB1gKs2iFRYti/t9LO1Rl2/6BzaBvz15Xn7vWjfteTbA8npzykAWrTDShrkGkW0U9vGlU6wn+uOCYkNOG2Dqxgvqxr3j+uOndZm63QhSUV/VjXA/ePaWXiVVd0WXnZlQp8j5wG764dQ2GXAXS+HxCb523VNzvoPKnRivawK9B6g0fm5HrnLqt4YOXSj2g6wuLZFfO5V6duO1gbf3hmNHVFd+iNqBxLUn1MAAFs6QK8t+5bn7DmCnRk+96UEdaDry/NWj9Xis2GXfpnVYgRAKvqzCwC989M2ps09XR3jQ3dYwAAAlA32hZHeOqB1Abv16/vkpD/LIhjw7y7U6BWhbcVVhNWTo9mlv5iOoxW+xxBaf3YzgGy/FWz+78o7txVtkXNowGGD6PDlzL6t24K1KSf9JwVAX44a+Z9qdDrg7uH5oGetlvPGNv7dw/NotZy3NsR0oEP1395cNcCXbvmc+gkhhBBCCCGEEEIIIeRH8h+PqYjF8m2k/AAAAABJRU5ErkJggg==", 
				4,  24, 24);
				GhostStatueDebris = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAASUExURQAAADInGlRCLH9kQ6+PagAAAMf8Z7sAAAAGdFJOU///////ALO/pL8AAAAJcEhZcwAADsMAAA7DAcdvqGQAAABdSURBVChTdY4BDsAgCAOhyP+/vLa4LTNZowYOKEYf+gEhObpBJjBITyivteBEF5llMdMBWK0CFQRRztyxgWsGnNGIHExmhB6OQevH1Gu4e4AJm14wP5f2xz46QPcF0EUDULbtW08AAAAASUVORK5CYII=",
				1,  8,  8);
				
				 // Ghost:
				GhostIdle   	   = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAMAAAAAwCAYAAABHTnUeAAAAAXNSR0IArs4c6QAAA61JREFUeJzt2k9L22AcB/BvhkjH3ATpIbtMSBGk7GKhGyj23r4DtzcQ8bbbTsb7rsPiC1AQdm3vHR6m0MIYRVZa6C4LQwQ3DyKD7FCf7mnaVNl+NU/0+4GCPg3NN8nzNwlARERERERERERERERERERERERERERERERJY0n+mOc6ABDoZXY6ZfknF/DKHcldTQTzxyuO/A8m8aOb221sbrdRKtjwTy4CoH9wicD88brN/OIjwNNnz/H925cA6B3I1noGADA3O22dnl32tjO0N2L+eMWRX6wBeK6DbK6IZr0aAECpYA98X6n5AMwdkpk/XknPD8914LlOoBzuLgdhh7vLgec6wf7OhnFD8n3IHwQB84eIrAE818Hc7PRAWX7tYGi7/NoBNrfbaNargZ1OSexaxH3JD/R6Vub/S6QBZHNFnJ5dBqWCjaO9lX55+G/10Rc3JtDz6/T86v+k5wdgdP7r6g8gm39K4kea9Wqwud0GMHzSFb1FR20Tl3D+qN5HlTO/rDjrj0gDCFMBx12ISi0ziV2LYP543WZ+kQYwv/DS2lrP9Ick1ZrHKRVsY1bydyl/qWBHVhwd8/eINIBu6xOA4fD6UKVuY930AG/TXck/quGqY0hi/ts4/+JToPAJVweVXxvcTn1vmqgKk4T84yoM848m1gDsdMqq1Pz+nYiolnq0t4JKzUc2V7SA91K7/2/3JT8AbK1nmP+K6JPgxewSjpuNa29PLWaXrONmw5g5KHD1IKbcgec6zB+DuOqP6BTouNkI9HmcPp3QW/TVgkf0PSQJnusM3Y4LT+UAM/Oryj8qf/iavHj1wbgnwcBg/QlPh/TySq0hdv4n8jaoog9hpi28rtObd/Yy6w+YTLuHHkXPP2pubTo9f7hckugIkMuvWlvrmUDv7VXvr+bOAJDNFa1mvSq5azFRD5JMzu+5DnL5VdgPWwPl4SepKv/+zgZMyq8Ln3+VeVLnX7QB/PrR6PeWUT3lk5kpq1mvGjX/DAtPf3ReuWN5rnn560cfh14lSFJ+Xbju6COwdP0RnQK1uudjFzClgo2f57+NeQflX9xkkRmXpExvIgy9yzTqeN68+yq6U/E1wLiLkIQLpGdUF0S/J20qr9yxvHLHqtR8qE/SxFF3pB+EWXY6hVb3fGA0qNR8LMzPWHY6Bf/kQniXovr5X7/9PNDbV2o+7HTKqDs/Os91YKdTePxoykpa9isj6w4AtLrnSag7RERERERERERERERERERERHH7A706lY6CyEQOAAAAAElFTkSuQmCC", 
				4,  24, 24);
				GhostAppear 	   = sprite_add_base64("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", 
				12, 24, 24);
				GhostDisappear	   = sprite_add_base64("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",
				12, 24, 24);
				GhostHaloAppear	   = sprite_add_base64("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", 
				13, 24, 24);
				GhostHaloDisappear = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAYAAAAAwCAMAAAAvpF1MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAPUExURQAAAP///8qmOoBoIgAAAHJ6AHYAAAAFdFJOU/////8A+7YOUwAAAAlwSFlzAAAOwwAADsMBx2+oZAAAAXZJREFUeF7tldkSgyAQBIPw/98cjo1HigrLoaNk+iESSyidZpeXI1AooBIj13aOK1BAb6Kd8ycUYBojSdN6fdQyr4D4W5JRGfcJdp4iYJFria+IWqvhOh4iYDFaA0/jIQLM/bdyI3MJqLR0h8dZAWBmPwNu7202Ad2BX20sK8AuESt/b4B/GxmNZUDcnUvkBCy+40a0H22jMXuisCoBn/Ni/GYesuJxkYwAu36AUUXq0xdfupqxyVcwpldWUwDNB/Z4Y2VyArYK0ATkH5eR00xYdQX0be6cDhTpiH2AsVwL8js0pqPaoLv8NQbC0jL0KB3PTPYQDl1C2x+s71gbxUlrf0sou9zE5AXUIPUSUNTM9nCCFSDXHlK9BOTGL3a+tF1uakYIqENcCXLzf7leADlAAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWAoAIpzb5t6HZ+2Q2FEAAAAAElFTkSuQmCC", 
				8,  24, 24);
				/*
				GhostHurt		   = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAJAAAAAwCAYAAAD+WvNWAAAAAXNSR0IArs4c6QAAAs9JREFUeJzt2rFrE1EcB/DvE5EMgiAZbhMuCFIHUcjSQHYzdFPJH6BeEP8EyQtCcXFTkri4JSDOcQ90sIF2MhQkAbcMHYRS6FB4Ds1L7y6X9Agvee/s9zP17kLuy9279373SwEiIiIiIiIiIiIiIiIiIiIiug7UlO0cq5KBr2TgM/8Vbpj8Mhn4c/uyNIji+evNUaYGko38RgdQmBBC6L+VUippcLlu0C2h3hwBSH44XLeJ/GsZQO3dnbmZ5+6dW5CBn4kb0d7dAQD0+pPZPuZPJq7+SDoy8LH15Cmev/q8dNlqv3soJsdnkK2xqVMbEc4vA19Vyl7kuL4ZXj7H/OugR7ZK4duXN849yTqPDPxZzv3OttrvbEeyy8Bn/hAjS5gMfNSbo9RvXc9eflJePmfi1EZML6ZKenKL1b3IdqXsYXjwg/mnjCxhq75phQttm2TgK11sDrolAPMXXu8HLpcD2Rpf+/xrewvLMn3xwxe9WN2b7Y8/5a7ZZP6bJr5ECCGy1O+Ju3gSC7P8xerizxare5Eb4wKb+Y3MQF8/LkmcATp/peyhUvYWLgPaov222MxvZAb68/unia+xJil/o1YAEJ3uXRs4ms38rIFCwo23pGONWsG55SvMRn4jMxBw0SB8/f5XZuugaYNNAbrgjB4Pb7s4iGzlN9qJfrD1GC/efk81iBq1gnCpG6rzHw0P5/Iv6OoyPwzOQABSDx5XHQ0PI/0UvSQsWxpcYiO/0QH0P9HLgL4R+sYAlwWqyzaV32gR7UpneVWyNRaDbmmuAQe4WffE2chvdAZK20x0rf7Rwv94pS94rz+Z1RChJ5f5p4zNQPXmKNP1D4C5HyIzxkp+9oFC4sVmfNv1AWYjv7ElrFErCADw8jkk9YM6Hx6Jk9NzTI7PTJ3SNAEAB8O/0P0Urdef4P692+Lk9NxOsnSynp+IiIiIiIiIiIiIiMi0f6AZF5c7oztvAAAAAElFTkSuQmCC", 
				3,  24, 24);
				*/
				
			//#endregion
			
		//#endregion
		
		//#region COAST
		m = "areas/Coast/";
		p = m;
			
			 // Floors:
			FloorCoast  = sprite(p + "sprFloorCoast",  4, 2, 2);
			FloorCoastB = sprite(p + "sprFloorCoastB", 3, 2, 2);
			DetailCoast = sprite(p + "sprDetailCoast", 6, 4, 4);
			
			 // Sea:
			CoastTrans    = sprite(p + "sprCoastTrans",    1,   0, 0);
			WaterGradient = sprite(p + "sprWaterGradient", 1, 128, 0);
			WaterStreak   = sprite(p + "sprWaterStreak",   7,   8, 8);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Blooming Cactus:
				BloomingCactusIdle =[sprite(p + "sprBloomingCactus",      1, 12, 12),
				                     sprite(p + "sprBloomingCactus2",     1, 12, 12),
				                     sprite(p + "sprBloomingCactus3",     1, 12, 12)];
				BloomingCactusHurt =[sprite(p + "sprBloomingCactus",      1, 12, 12, shnHurt),
				                     sprite(p + "sprBloomingCactus2",     1, 12, 12, shnHurt),
				                     sprite(p + "sprBloomingCactus3",     1, 12, 12, shnHurt)];
				BloomingCactusDead =[sprite(p + "sprBloomingCactusDead",  4, 12, 12),
				                     sprite(p + "sprBloomingCactus2Dead", 4, 12, 12),
				                     sprite(p + "sprBloomingCactus3Dead", 4, 12, 12)];
				
				 // Big Blooming Cactus:
				BigBloomingCactusIdle = sprite(p + "sprBigBloomingCactus",     1, 16, 16);
				BigBloomingCactusHurt = sprite(p + "sprBigBloomingCactus",     1, 16, 16, shnHurt);
				BigBloomingCactusDead = sprite(p + "sprBigBloomingCactusDead", 4, 16, 16);
				
				 // Buried Car:
				BuriedCarIdle = sprite(p + "sprBuriedCar",     1, 16, 16);
				BuriedCarHurt = sprite(p + "sprBuriedCarHurt", 3, 16, 16);
				
				 // Bush:
				BloomingBushIdle = sprite(p + "sprBloomingBush",     1, 12, 12);
				BloomingBushHurt = sprite(p + "sprBloomingBushHurt", 3, 12, 12);
				BloomingBushDead = sprite(p + "sprBloomingBushDead", 3, 12, 12);
				
				 // Palm:
				PalmIdle     = sprite(p + "sprPalm",         1, 24, 40);
				PalmHurt     = sprite(p + "sprPalmHurt",     3, 24, 40);
				PalmDead     = sprite(p + "sprPalmDead",     4, 24, 40);
				PalmFortIdle = sprite(p + "sprPalmFort",     1, 32, 56);
				PalmFortHurt = sprite(p + "sprPalmFortHurt", 3, 32, 56);
				
				 // Sea/Seal Mine:
				SealMine     = sprite(p + "sprSeaMine", 1, 12, 12);
				SealMineHurt = sprite(p + "sprSeaMine", 1, 12, 12, shnHurt);
				
			p = m + "Decals/";
				
				 // Decal Water Rock Props:
				RockIdle  =[sprite(p + "sprRock1Idle", 1, 16, 16),
				            sprite(p + "sprRock2Idle", 1, 16, 16)];
				RockHurt  =[sprite(p + "sprRock1Idle", 1, 16, 16, shnHurt),
				            sprite(p + "sprRock2Idle", 1, 16, 16, shnHurt)];
				RockDead  =[sprite(p + "sprRock1Dead", 1, 16, 16),
				            sprite(p + "sprRock2Dead", 1, 16, 16)];
				RockBott  =[sprite(p + "sprRock1Bott", 1, 16, 16),
				            sprite(p + "sprRock2Bott", 1, 16, 16)];
				RockFoam  =[sprite(p + "sprRock1Foam", 1, 16, 16),
				            sprite(p + "sprRock2Foam", 1, 16, 16)];
				ShellIdle = sprite(p + "sprShellIdle", 1, 32, 32);
				ShellHurt = sprite(p + "sprShellIdle", 1, 32, 32, shnHurt);
				ShellDead = sprite(p + "sprShellDead", 6, 32, 32);
				ShellBott = sprite(p + "sprShellBott", 1, 32, 32);
				ShellFoam = sprite(p + "sprShellFoam", 1, 32, 32);
				
			//#endregion
			
			 // Strange Creature:
			CreatureIdle = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAACMAAAACgCAMAAADXNXIqAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAAAU9IAxsQWkrGXVgQ/w4ALiVetS/rwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKuM2GgAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGXRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4wLjE3M26fYwAADJxJREFUeF7t24ty20YSQFFlLcv//8VZYNCkAGLwIAYU0c45VSvSeM3dSRWqI1c+/gUASMYAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0WgaYj4k4eCERFuLghURYiIMXEmEhDl5IhIU4eCERFuLglUTZII5dSZQN4tiVRNkgjl1JlA3i2JVE2SCOXUmUDeLYlUTZII5dSZQN4tjZDj03kv6ZiINxyVtFSoSFOBiXvFWkRFiIg3HJW0VKhIU4GJe8VaREWIiDcclbRUqEhTgYl7xXtETZII7FFe8VLVE2iGNxxXtFS5QN4lhc8V7REmWDOBZXvFe0RNkgjsUV7xUtUTaIY3HFe0VLlA3iWFzxVpHyI33PPrBERFLVCxqfoa+NvjZX79sM1LdOXxt9bS7et5V3et9TT1tu+9+3N+6hvjb62ly9bzkw2nqX7JsE6luir42+Jst5o76T3y/7H7W+eeMdLI1x18/R10Zfm6v3LQcOSaVscMG+hw3UN6evjb4mi3mlbJp3Yt/eBy3WdWWxhRM/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",
			14, 80, 80);
			CreatureHurt = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAeAAAACgCAMAAADjJU9/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAAAU9IAxsQXVgQ7iVetS/r////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHiDNaAAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGXRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4wLjE3M26fYwAABYhJREFUeF7tmomS2joURCF2+P8/nmhpBttos9GWpk/VC4MsXXf1GZNJXm4/ghoJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYnI8EP7ZgbSZuW7A2E0jmwVptrs2F0xDYMRZ0dt+CNewYC7IgmQdr2FGN0wPhMQV2jsG1hM5CNOjwFL3znZsGg3mwvzfx7v68GOh4QL4To+CuEBzqSLQ9X5v7FZgOcagjY/KVDoK2M+BkH5LPxu4B8fRWPCxf2RgoOwkOdyDanq8uUKCtEIc7MDBfyRT4ugAGNCZRX6i5X3o9xEPz5WfA1TUwoyWp+gzhx8PT5SEenC83AqIugzHNyNS3AaXtaW54eL7MBGj6AAxqRLQ+FLRhiOHx+dIDIOkjMKoJkf5QzoEBhifIlzwPRR+CYQ041V+MhoZnyJc6DkGfg3m1CfeHXopp9yfiKfIlDsNODTCxLnX6sz/FtjE8R774WbipA2bW5NLnX+CyXWpheJJ80aMwUwtMrcel/kINupX6hmfJFzsJL/XA3FpE+jtfII7UNjxNvshBWKkJJtch1t/lAiv/pdY8+cLn4KQumF2DaH/Jv/mzvF1+FljV8ET5JBgLkwu+nC94DEYqg+EViPeXbs/wvgMrNQXPlK+j4HqGEwXaNlIthgr0hyoanilf6BR8VAfjPybVny3jvaQXbsMO++/cHg+zXk3wVPn4BKf/D6u9vsMsmP4ej1svwZ3zzSS4bFe2QAPK2YFL/qJ9Xde/jnV1980XeHPgTYKp8gVOuXEtwPww2FMgON/fFvv5Zr7/DVjwoDyPazBToBng9uYFz5VvEsHYYcFKnDMF+voMuwZ37TlWex3zQ6C9v2tlwe3z9RRswT324JoHa3HKCzSlYKgpEGuh+kwx67LYDsMlPuurLbhHvt6CHbgRwCLAYoKyAl0dmwKxfEcTW9Zfgi2+6jM7834ny/ceGHdsDG72fjssxynrz/Eq8HkIRWx5/izzxPS47fB221wvETxZvlGCLcG7uQwpThSIkfYPkQ7fwa6wdcEXB0yHrpptfWZzXcGI1zTfSMFBkCJOeYFuHr6+321Tpr1Dfbu3B2yJu+tLXcFd8n2J4MVWZ34P2/VnfktL9ffWr93fSHC7fN8hGPUd+jDv0gUe+l2aCW6YbzrBWcPlBdoG7YvvzoImPPZdssDDRTPENJo1PFk+asGeZXl+BKIJj3uXLPCA6c+MqSnY0zbffIJzhs8WaOoL9Xe6QPuAlDzCk+XjF2yw39kfF+j6CzwiRybLN6HgjOErBQb685wr0P+YmzE8Wb5vEBx8QDzlBbofYWyD9QU3zTej4LThCwW6/sIFFjdoCvRjcoYny/flgssfET/D0lPw5/kCYdHySJAkDGopp16B9tX8lzaMu5bTNF8wK2oeB3LEQDGl/H52BSgvcPOaFjxXvkhWFF0KTu14rrsNCWeZy2FQTRnLglM7bKXPV3wZJHM5DO5cRtN8qW9GX30C7BsF+omDfaNAijjY15Tcp434z5FgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJpubn5x8Du/CP6ZKb1gAAAABJRU5ErkJggg==",
			3, 80, 80);
			CreatureBott = sprite_add_base64("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",
			1, 80, 80);
			CreatureFoam = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAKAAAACgCAYAAACLz2ctAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwAAADsABataJCQAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xNzNun2MAAAIVSURBVHhe7dLBTsIAFERR/v+nMe6voBUGtGeSs7npok3f5Xq9wstkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGd/YrdXzvLmMT/AXVu/9U/9l9W1PkfEB7P+u/vdhGX/BzrW6gR/JeJCdd3UP35LxIDv36ibuyniQnXt1E3dlPMis7uKmjAeZ1V3clPEgs8/VbXwp4y/ZeVf3cFPGB/nLq+/hCTI+0Tus3osXyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhI3r5QPGwQeqRTAO1AAAAABJRU5ErkJggg==",
			1, 80, 80);
			
		//#endregion
		
		//#region OASIS
		m = "areas/Oasis/";
		p = m;
			
			 // Big Bubble:
			BigBubble    = sprite(p + "sprBigBubble",    1, 24, 24);
			BigBubblePop = sprite(p + "sprBigBubblePop", 4, 24, 24);
			
			 // Decals:
			BigTopDecal[? area_oasis] = sprite(p + "sprBigTopDecalOasis", 1, 32, 52);
			BigTopDecal[? "oasis"] = BigTopDecal[? area_oasis];
			
			 // Ground Crack Effect:
			Crack = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAEAAAAAgCAYAAACinX6EAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAZdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAuMTczbp9jAAABk0lEQVRoQ+WVS3KDQAxEOUQ22ed0OUPujhEVTWk6PWK+sSgWrwwPI0/3YHvb9/3RUPkkqHwSVEbg4+f7eOHXZkJlBLAAr5CRsqh8FxLEwq6jE7avz+Plr6+BygiUChAkMKNUkAeVUbCBvOCIFqX3elAZCRr8WDYF3oezGFRGIgvFgqqzmOs4D6EyCmn3C+Eyb6+Z86uvApWt1H7fWsEw6diDlIBzLVQiElDBa8KKAmRmCsLCY9ASx3u89VFZ4j8LqArnYe8/jnG+QqWHhMXAzI0yXICgM34LYGvMTmqQIedg06p1Wgb7sBayIBMorSk7aUVD2zJmgQFG0blYQjroQXcc/Qi6UyzECOwz5DjJHlbsvIIBRsH5CpW1zN59y8ynwFsnlVfoI7SyAAGD9IJzLVS2sLIEmc0CtXC1PipbWVnC+S8Doaqp+JGmMgqy+PMp6Cmh8geaygjgzp1FYMgCV7tuofJd6I4reF0Qz0IL3n0lqIzAVRCvIHQeVEagt4BWqLwLM0qg8k6MlkDlnXh8AWPs2wudfCE+JW5sAwAAAABJRU5ErkJggg==",
			2, 16, 16);
			
		//#endregion
		
		//#region TRENCH
		m = "areas/Trench/";
		p = m;
			
			 // Decals:
			BigTopDecal[?     "trench"] = sprite(p + "sprBigTopDecalTrench", 1, 32, 52);
			msk.BigTopDecal[? "trench"] = sprite(p + "../mskBigTopDecal",    1, 32, 16);
			
			 // Floors:
			FloorTrench      = sprite(p + "sprFloorTrench",      4, 0, 0);
			FloorTrenchB     = sprite(p + "sprFloorTrenchB",     4, 2, 2);
			FloorTrenchExplo = sprite(p + "sprFloorTrenchExplo", 5, 1, 1);
			FloorTrenchBreak = sprite(p + "sprFloorTrenchBreak", 3, 8, 8);
			DetailTrench     = sprite(p + "sprDetailTrench",     6, 4, 4);
			
			 // Walls:
			WallTrenchBot   = sprite(p + "sprWallTrenchBot",   4,  0,  0);
			WallTrenchTop   = sprite(p + "sprWallTrenchTop",   8,  0,  0);
			WallTrenchOut   = sprite(p + "sprWallTrenchOut",   1,  4, 12);
			WallTrenchTrans = sprite(p + "sprWallTrenchTrans", 8,  0,  0);
			DebrisTrench    = sprite(p + "sprDebrisTrench",    4,  4,  4);
			
			 // Decals:
			TopDecalTrench     = sprite(p + "sprTopDecalTrench",      2, 19, 24);
			TopDecalTrenchMine = sprite(p + "sprTopDecalTrenchMine",  1, 16, 24);
			TrenchMineDead     = sprite(p + "sprTrenchMineDead",     12, 12, 36);
			
			 // Proto Statue:
			PStatTrenchIdle   = sprite(p + "sprPStatTrenchIdle",    1, 40, 40);
			PStatTrenchHurt   = sprite(p + "sprPStatTrenchHurt",    3, 40, 40);
			PStatTrenchLights = sprite(p + "sprPStatTrenchLights", 40, 40, 40);
			
			//#region PITS
			p = m + "Pit/";
				
				 // Normal:
				Pit    = sprite(p + "sprPit",    1, 2, 2);
				PitTop = sprite(p + "sprPitTop", 1, 2, 2);
				PitBot = sprite(p + "sprPitBot", 1, 2, 2);
				
				 // Small:
				PitSmall    = sprite(p + "sprPitSmall",    1, 3, 3);
				PitSmallTop = sprite(p + "sprPitSmallTop", 1, 3, 3);
				PitSmallBot = sprite(p + "sprPitSmallBot", 1, 3, 3);
				
			//#endregion
			
			//#region PROPS
			p = m + "Props/";
				
				 // Eel Skeleton (big fat eel edition):
				EelSkullIdle = sprite(p + "sprEelSkeleton",     1, 24, 24);
				EelSkullHurt = sprite(p + "sprEelSkeletonHurt", 3, 24, 24);
				EelSkullDead = sprite(p + "sprEelSkeletonDead", 3, 24, 24);
				
				 // Kelp:
				KelpIdle = sprite(p + "sprKelp",     6, 16, 22);
				KelpHurt = sprite(p + "sprKelpHurt", 3, 16, 22);
				KelpDead = sprite(p + "sprKelpDead", 8, 16, 22);
				
				 // Vent:
				VentIdle = sprite(p + "sprVent",     1, 12, 14);
				VentHurt = sprite(p + "sprVentHurt", 3, 12, 14);
				VentDead = sprite(p + "sprVentDead", 3, 12, 14);
				
			//#endregion
			
		//#endregion
		
		//#region SEWERS
		m = "areas/Sewers/";
		p = m;
			
			 // Decals:
			BigTopDecal[? area_sewers] = sprite(p + "sprBigTopDecalSewers", 8, 32, 56);
			
			 // Fix Decal Not Fully Covering Wall:
			sprite_replace(sprSewerDecal, "sprites/" + p + "sprWallDecalSewer.png", 1, 16, 24);
			
			 // Floors:
			FloorSewerDirt      = sprite(p + "sprFloorSewerDirt",      4, 16, 16);
			FloorSewerLightDirt = sprite(p + "sprFloorSewerLightDirt", 4, 16, 16);
			FloorSewerDrain     = sprite(p + "sprFloorSewerDrain",     1,  0,  0);
			FloorSewerGrate     = sprite(p + "sprFloorSewerGrate",     8,  2,  2);
			FloorSewerWeb       = sprite(p + "sprFloorSewerWeb",       1,  0,  0);
			
			 // Manhole:
			PizzaManhole = [
				sprite(p + "sprPizzaManhole0", 2, 16, 16),
				sprite(p + "sprPizzaManhole1", 2, 16, 16),
				sprite(p + "sprPizzaManhole2", 2, 16, 16)
			];
			
			 // Sewer Pool:
			SewerPool        = sprite(p + "sprSewerPool",     8,  0,  0);
			msk.SewerPool    = sprite(p + "mskSewerPool",     1, 32, 64);
			SewerPoolBig     = sprite(p + "sprSewerPoolBig", 25,  0,  0);
			msk.SewerPoolBig = sprite(p + "mskSewerPoolBig",  1, 80, 80);
			
			//#region PROPS
			p = m + "Props/"
				
				 // Big Pipe:
				BigPipeBottom     = sprite(p + "sprBigPipeBottom", 1, 24, 32);
				BigPipeBottomHurt = sprite(p + "sprBigPipeBottom", 1, 24, 32, shnHurt);
				BigPipeTop        = sprite(p + "sprBigPipeTop",    1, 24, 32);
				BigPipeTopHurt    = sprite(p + "sprBigPipeTop",    1, 24, 32, shnHurt);
				BigPipeHole       = sprite(p + "sprBigPipeHole",   1, 24, 32);
				msk.BigPipe       = sprite(p + "sprBigPipeTop",    1, 24, 24);
				with([BigPipeHole, msk.BigPipe]){
					mask = [false, 0];
				}
				
				 // Sewer Drain:
				SewerDrainIdle = sprite(p + "sprSewerDrain",     8, 32, 38);
				SewerDrainHurt = sprite(p + "sprSewerDrainHurt", 3, 32, 38);
				SewerDrainDead = sprite(p + "sprSewerDrainDead", 5, 32, 38);
				msk.SewerDrain = sprite(p + "mskSewerDrain",     1, 32, 38);
				
				 // Homage:
				GatorStatueIdle = sprite(p + "sprGatorStatue",     1, 16, 16);
				GatorStatueHurt = sprite(p + "sprGatorStatue",     1, 16, 16, shnHurt);
				GatorStatueDead = sprite(p + "sprGatorStatueDead", 4, 16, 16);
				
			//#endregion
			
		//#endregion
		
		//#region PIZZA SEWERS
		m = "areas/Pizza/";
		p = m;
			
			 // Decals:
			BigTopDecal[? area_pizza_sewers] = sprite(p + "sprBigTopDecalPizza", 1, 32, 56);
			BigTopDecal[? "pizza"] = BigTopDecal[? area_pizza_sewers];
			
			 // Fix Decal Not Fully Covering Wall:
			sprite_replace(sprPizzaSewerDecal, "sprites/" + p + "sprWallDecalPizza.png", 1, 16, 24);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Door:
				PizzaDoor       = sprite(p + "sprPizzaDoor",       10, 2, 0);
				PizzaDoorDebris = sprite(p + "sprPizzaDoorDebris",  4, 4, 4);
				
				 // Drain:
				PizzaDrainIdle = sprite(p + "sprPizzaDrain",     8, 32, 38);
				PizzaDrainHurt = sprite(p + "sprPizzaDrainHurt", 3, 32, 38);
				PizzaDrainDead = sprite(p + "sprPizzaDrainDead", 5, 32, 38);
				
				 // Rubble:
				PizzaRubbleIdle = sprite(p + "sprPizzaRubble",     1, 16, 0);
				PizzaRubbleHurt = sprite(p + "sprPizzaRubbleHurt", 3, 16, 0);
				msk.PizzaRubble = sprite(p + "mskPizzaRubble",     1, 16, 0);
				
				 // TV:
				TVHurt = sprite(p + "sprTVHurt", 3, 24, 16);
				
			//#endregion
			
		//#endregion
		
		//#region LAIR
		m = "areas/Lair/";
		p = m;
			
			 // Floors:
			FloorLair      = sprite(p + "sprFloorLair",      4, 0, 0);
			FloorLairB     = sprite(p + "sprFloorLairB",     8, 0, 0);
			FloorLairExplo = sprite(p + "sprFloorLairExplo", 4, 1, 1);
			DetailLair     = sprite(p + "sprDetailLair",     6, 4, 4);
			
			 // Walls:
			WallLairBot   = sprite(p + "sprWallLairBot",   4,  0,  0);
			WallLairTop   = sprite(p + "sprWallLairTop",   4,  0,  0);
			WallLairOut   = sprite(p + "sprWallLairOut",   5,  4, 12);
			WallLairTrans = sprite(p + "sprWallLairTrans", 1,  0,  0);
			DebrisLair    = sprite(p + "sprDebrisLair",    4,  4,  4);
			
			 // Decals:
			TopDecalLair  = sprite(p + "sprTopDecalLair",  2, 16, 16);
			WallDecalLair = sprite(p + "sprWallDecalLair", 1, 16, 24);
			
			 // Manholes:
			Manhole               = sprite(p + "sprManhole",               12, 16, 48);
			ManholeOpen           = sprite(p + "sprManholeOpen",            1, 16, 16);
			BigManhole            = sprite(p + "sprBigManhole",             6, 32, 32);
			BigManholeOpen        = sprite(p + "sprBigManholeOpen",         1, 32, 32);
			BigManholeFloor       = sprite(p + "sprBigManholeFloor",        4,  0,  0);
			BigManholeDebris      = sprite(p + "sprBigManholeDebris",       4,  4,  4);
			BigManholeDebrisChunk = sprite(p + "sprBigManholeDebrisChunk",  3, 12, 12);
			with([ManholeOpen, BigManholeOpen]){
				mask = [false, 0];
			}
			
			//#region PROPS
			p = m + "Props/";
				
				 // Cabinet:
				CabinetIdle = sprite(p + "sprCabinet",     1, 12, 12);
				CabinetHurt = sprite(p + "sprCabinet",     1, 12, 12, shnHurt);
				CabinetDead = sprite(p + "sprCabinetDead", 3, 12, 12);
				Paper       = sprite(p + "sprPaper",       3,  5,  6);
				
				/// Chairs:
					
					 // Side:
					ChairSideIdle  = sprite(p + "sprChairSide",     1, 12, 12);
					ChairSideHurt  = sprite(p + "sprChairSide",     1, 12, 12, shnHurt);
					ChairSideDead  = sprite(p + "sprChairSideDead", 3, 12, 12);
					
					 // Front:
					ChairFrontIdle = sprite(p + "sprChairFront",     1, 12, 12);
					ChairFrontHurt = sprite(p + "sprChairFront",     1, 12, 12, shnHurt);
					ChairFrontDead = sprite(p + "sprChairFrontDead", 3, 12, 12);
					
				 // Couch:
				CouchIdle = sprite(p + "sprCouch",     1, 32, 32);
				CouchHurt = sprite(p + "sprCouch",     1, 32, 32, shnHurt);
				CouchDead = sprite(p + "sprCouchDead", 3, 32, 32);
				
				 // Door:
				CatDoor       = sprite(p + "sprCatDoor",       10, 2, 0);
				CatDoorDebris = sprite(p + "sprCatDoorDebris",  4, 4, 4);
				msk.CatDoor   = sprite(p + "mskCatDoor",        1, 4, 0);
				
				 // Rug:
				Rug = sprite(p + "sprRug", 2, 26, 26);
				
				 // Soda Machine:
				SodaMachineIdle = sprite(p + "sprSodaMachine",     1, 16, 16);
				SodaMachineHurt = sprite(p + "sprSodaMachine",     1, 16, 16, shnHurt);
				SodaMachineDead = sprite(p + "sprSodaMachineDead", 3, 16, 16);
				
				 // Table:
				TableIdle = sprite(p + "sprTable",     1, 16, 16);
				TableHurt = sprite(p + "sprTable",     1, 16, 16, shnHurt);
				TableDead = sprite(p + "sprTableDead", 3, 16, 16);
				
			//#endregion
			
			//#region LIGHTS
			p = m + "Lights/";
				
				 // Ceiling Lights:
				CatLight     = sprite(p + "sprCatLight",     1,  96, 16);
				CatLightBig  = sprite(p + "sprCatLightBig",  1, 128, 16);
				CatLightThin = sprite(p + "sprCatLightThin", 1,  72, 16);
				
			//#endregion
			
		//#endregion
		
		//#region RED
		m = "areas/Crystal/";
		p = m;
			
			 // Floors:
			FloorRed      = sprite(p + "sprFloorCrystal",      1, 2, 2);
			FloorRedB     = sprite(p + "sprFloorCrystalB",     1, 2, 2);
			FloorRedExplo = sprite(p + "sprFloorCrystalExplo", 4, 1, 1);
			FloorRedRoom  = sprite(p + "sprFloorCrystalRoom",  4, 2, 2);
			DetailRed     = sprite(p + "sprDetailCrystal",     5, 4, 4);
			
			 // Walls:
			WallRedBot   = sprite(p + "sprWallCrystalBot",    2, 0,  0);
			WallRedTop   = sprite(p + "sprWallCrystalTop",    4, 0,  0);
			WallRedOut   = sprite(p + "sprWallCrystalOut",    1, 4, 12);
			WallRedTrans = sprite(p + "sprWallCrystalTrans",  4, 1,  1);
			WallRedFake  =[sprite(p + "sprWallCrystalFake1", 16, 0,  0),
			               sprite(p + "sprWallCrystalFake2", 16, 0,  0)];
			DebrisRed    = sprite(p + "sprDebrisCrystal",     4, 4,  4);
			with(WallRedTrans){
				mask = [false, 2, x, y, x + 15, y + 15, 1];
			}
			
			 // Fake Walls:
			WallFakeBot = sprite(p + "sprWallFakeBot", 16, 0, 0);
			WallFakeTop = sprite(p + "sprWallFakeTop",  1, 0, 8);
			WallFakeOut = sprite(p + "sprWallFakeOut",  1, 1, 9);
			
			 // Decals:
			WallDecalRed = sprite(p + "sprWallDecalCrystal", 1, 16, 24);
			
			 // Warp:
			Warp        = sprite(p + "sprWarp",        2, 16, 16);
			WarpOpen    = sprite(p + "sprWarpOpen",    2, 32, 32);
			WarpOpenOut = sprite(p + "sprWarpOpenOut", 4, 32, 32);
			
			 // Misc:
			RedDot          = sprite(p + "sprRedDot",           9,   7,   7);
			RedText         = sprite(p + "sprRedText",         12,  12,   4);
			Starfield       = sprite(p + "sprStarfield",        2, 256, 256);
			SpiralStarfield = sprite(p + "sprSpiralStarfield",  2,  32,  32);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Red Crystals:
				CrystalPropRedIdle = sprite(p + "sprCrystalPropRed",     1, 12, 12);
				CrystalPropRedHurt = sprite(p + "sprCrystalPropRed",     1, 12, 12, shnHurt);
				CrystalPropRedDead = sprite(p + "sprCrystalPropRedDead", 4, 12, 12);
				
				 // White Crystals:
				CrystalPropWhiteIdle = sprite(p + "sprCrystalPropWhite",     1, 12, 12);
				CrystalPropWhiteHurt = sprite(p + "sprCrystalPropWhiteHurt", 3, 12, 12);
				CrystalPropWhiteDead = sprite(p + "sprCrystalPropWhiteDead", 4, 12, 12);
				
			//#endregion
			
		//#endregion
		
		//#region IDPD HQ
		m = "areas/HQ/";
		p = m;
			
			 // Floors:
			Floor106Small        = sprite(p + "sprFloor106Small",    4,  0,  0);
			FloorMiddleSmall     = sprite(p + "sprFloorMiddleSmall", 1, 32, 32);
			msk.FloorMiddleSmall = sprite(p + "mskFloorMiddleSmall", 1, 32, 32);
			with(msk.FloorMiddleSmall){
				mask = [false, 0];
			}
			
		//#endregion
		
		//#region CRIB
		m = "areas/Crib/";
		p = m;
			
			 // TV Shadow:
			shd.VenuzTV = sprite(p + "shdVenuzTV", 1, 129, 96);
			
		//#endregion
		
		//#region CHESTS/PICKUPS
		m = "chests/";
		p = m;
			
			 // Ally Backpack:
			AllyBackpack     = sprite(p + "sprAllyBackpack",     1, 8, 8, shn16);
			AllyBackpackOpen = sprite(p + "sprAllyBackpackOpen", 1, 8, 8);
			
			 // Backpack:
			Backpack           = sprite(p + "sprBackpack",            1, 8, 8, shn16);
			BackpackCursed     = sprite(p + "sprBackpackCursed",      1, 8, 8, shn16);
			BackpackOpen       = sprite(p + "sprBackpackOpen",        1, 8, 8);
			BackpackCursedOpen = sprite(p + "sprBackpackCursedOpen",  1, 8, 8);
			BackpackDebris     = sprite(p + "sprBackpackDebris",     30, 6, 6);
			
			 // Backpacker (Deceased):
			BackpackerIdle = [sprite(p + "sprBackpacker0", 1, 12, 12),
			                  sprite(p + "sprBackpacker1", 1, 12, 12),
			                  sprite(p + "sprBackpacker2", 1, 12, 12)];
			BackpackerHurt = [sprite(p + "sprBackpacker0", 1, 12, 12, shnHurt),
			                  sprite(p + "sprBackpacker1", 1, 12, 12, shnHurt),
			                  sprite(p + "sprBackpacker2", 1, 12, 12, shnHurt)];
			
			 // Bat Chests:
			BatChest              = sprite(p + "sprBatChest",              1, 10, 10, shn20);
			BatChestCursed        = sprite(p + "sprBatChestCursed",        1, 10, 10, shn20);
			BatChestBig           = sprite(p + "sprBatChestBig",           1, 12, 12, shn24);
			BatChestBigCursed     = sprite(p + "sprBatChestBigCursed",     1, 12, 12, shn24);
			BatChestOpen          = sprite(p + "sprBatChestOpen",          1, 10, 10);
			BatChestCursedOpen    = sprite(p + "sprBatChestCursedOpen",    1, 10, 10);
			BatChestBigOpen       = sprite(p + "sprBatChestBigOpen",       1, 12, 12);
			BatChestBigCursedOpen = sprite(p + "sprBatChestBigCursedOpen", 1, 12, 12);
			
			 // Biggest Weapon Chest:
			BiggestWeaponChest     = sprite(p + "sprBiggestWeaponChest",     1, 32, 32, shn64);
			BiggestWeaponChestOpen = sprite(p + "sprBiggestWeaponChestOpen", 1, 32, 32);
			
			 // Bone:
			BonePickup    = array_create(4, -1);
			BonePickupBig = array_create(2, -1);
			for(var i = 0; i < array_length(BonePickup); i++){
				BonePickup[i] = sprite(p + `sprBonePickup${i}`, 1, 4, 4, shn8);
			}
			for(var i = 0; i < array_length(BonePickupBig); i++){
				BonePickupBig[i] = sprite(p + `sprBoneBigPickup${i}`, 1, 8, 8, shn16);
			}
			
			 // Bonus Pickups:
			BonusFX                    = sprite(p + "sprBonusFX",                    13,  4, 12);
			BonusFXPickupOpen          = sprite(p + "sprBonusFXPickupOpen",           6,  8,  8);
			BonusFXPickupFade          = sprite(p + "sprBonusFXPickupFade",           5,  8,  8);
			BonusFXChestOpen           = sprite(p + "sprBonusFXChestOpen",            8, 16, 16);
			BonusHealFX                = sprite(p + "sprBonusHealFX",                 7,  8, 10);
			BonusHealBigFX             = sprite(p + "sprBonusHealBigFX",              8, 12, 24);
			BonusShell                 = sprite(p + "sprBonusShell",                  1,  1,  2);
			BonusShellHeavy            = sprite(p + "sprBonusShellHeavy",             1,  2,  3);
			BonusText                  = sprite(p + "sprBonusText",                  12,  0,  0);
			BonusHUDText               = sprite(p + "sprBonusHUDText",                1,  7,  3);
			BonusAmmoHUD               = sprite(p + "sprBonusAmmoHUD",                1,  2,  3);
			BonusAmmoHUDFill           = sprite(p + "sprBonusAmmoHUDFill",            7,  0,  0);
			BonusAmmoHUDFillDrain      = sprite(p + "sprBonusAmmoHUDFillDrain",       7,  0,  0);
			BonusHealthHUDFill         = sprite(p + "sprBonusHealthHUDFill",          7,  0,  0);
			BonusHealthHUDFillDrain    = sprite(p + "sprBonusHealthHUDFillDrain",     7,  0,  0);
			BonusAmmoPickup            = sprite(p + "sprBonusAmmoPickup",             1,  5,  5, shn10);
			BonusHealthPickup          = sprite(p + "sprBonusHealthPickup",           1,  5,  5, shn10);
			BonusAmmoChest             = sprite(p + "sprBonusAmmoChest",             15,  8,  8);
			BonusAmmoChestOpen         = sprite(p + "sprBonusAmmoChestOpen",          1,  8,  8);
			BonusAmmoChestSteroids     = sprite(p + "sprBonusAmmoChestSteroids",     15, 12, 12);
			BonusAmmoChestSteroidsOpen = sprite(p + "sprBonusAmmoChestSteroidsOpen",  1, 12, 12);
			BonusHealthChest           = sprite(p + "sprBonusHealthChest",           15,  8,  8);
			BonusHealthChestOpen       = sprite(p + "sprBonusHealthChestOpen",        1,  8,  8);
			BonusAmmoMimicIdle         = sprite(p + "sprBonusAmmoMimicIdle",          1, 16, 16);
			BonusAmmoMimicTell         = sprite(p + "sprBonusAmmoMimicTell",         12, 16, 16);
			BonusAmmoMimicHurt         = sprite(p + "sprBonusAmmoMimicHurt",          3, 16, 16);
			BonusAmmoMimicDead         = sprite(p + "sprBonusAmmoMimicDead",          6, 16, 16);
			BonusAmmoMimicFire         = sprite(p + "sprBonusAmmoMimicFire",          4, 16, 16);
			BonusHealthMimicIdle       = sprite(p + "sprBonusHealthMimicIdle",        1, 16, 16);
			BonusHealthMimicTell       = sprite(p + "sprBonusHealthMimicTell",       10, 16, 16);
			BonusHealthMimicHurt       = sprite(p + "sprBonusHealthMimicHurt",        3, 16, 16);
			BonusHealthMimicDead       = sprite(p + "sprBonusHealthMimicDead",        6, 16, 16);
			BonusHealthMimicFire       = sprite(p + "sprBonusHealthMimicFire",        4, 16, 16);
			
			 // Buried Vault:
			BuriedVaultChest       = sprite(p + "sprVaultChest",       1, 12, 12, shn24);
			BuriedVaultChestOpen   = sprite(p + "sprVaultChestOpen",   1, 12, 12);
			BuriedVaultChestDebris = sprite(p + "sprVaultChestDebris", 8, 12, 12);
			BuriedVaultChestBase   = sprite(p + "sprVaultChestBase",   3, 16, 12);
			ProtoChestMerge        = sprite(p + "sprProtoChestMerge",  6, 12, 12);
			
			 // Button Chests:
			ButtonChest        = sprite(p + "sprButtonChest",        1, 9, 9, shn20);
			ButtonChestDebris  = sprite(p + "sprButtonChestDebris",  2, 9, 9);
			ButtonPickup       = sprite(p + "sprButtonPickup",       1, 6, 6, shn12);
			ButtonPickupDebris = sprite(p + "sprButtonPickupDebris", 2, 6, 6);
			
			 // Cat Chest:
			CatChest     = sprite(p + "sprCatChest",     1, 10, 10, shn20);
			CatChestOpen = sprite(p + "sprCatChestOpen", 1, 10, 10);
			
			 // Cat Crates:
			WallCrateBot = sprite(p + "sprWallCrateBot", 2,  2,  2);
			WallCrateTop = sprite(p + "sprWallCrateTop", 4,  4,  4);
			WallCrateOut = sprite(p + "sprWallCrateTop", 4,  4, 12);
			FloorCrate   = sprite(p + "sprFloorCrate",   1, 18, 18);
			
			 // Cursed Ammo Chests:
			CursedAmmoChest             = sprite(p + "sprCursedAmmoChest",              1,  8,  8, shn16);
			CursedAmmoChestOpen         = sprite(p + "sprCursedAmmoChestOpen",          1,  8,  8);
			CursedAmmoChestSteroids     = sprite(p + "sprCursedAmmoChestSteroids",      1, 12, 12, shn20);
			CursedAmmoChestSteroidsOpen = sprite(p + "sprCursedAmmoChestSteroidsOpen",  1, 12, 12);
			CursedMimicIdle             = sprite(p + "sprCursedMimicIdle",              1, 16, 16);
			CursedMimicFire             = sprite(p + "sprCursedMimicFire",              4, 16, 16);
			CursedMimicHurt             = sprite(p + "sprCursedMimicHurt",              3, 16, 16);
			CursedMimicDead             = sprite(p + "sprCursedMimicDead",              6, 16, 16);
			CursedMimicTell             = sprite(p + "sprCursedMimicTell",             12, 16, 16);
			
			 // Orchid Chest:
			OrchidChest       = sprite(p + "sprOrchidChest",       1, 12, 8, shn24);
			OrchidChestWilted = sprite(p + "sprOrchidChestWilted", 1, 12, 8, shn24);
			OrchidChestOpen   = sprite(p + "sprOrchidChestOpen",   1, 12, 8);
			
			 // Rat Chest:
			RatChest      = sprite(p + "sprRatChest",      1, 10, 10, shn20);
			RatChestOpen  = sprite(p + "sprRatChestOpen",  1, 10, 10);
			RadSkillBall  = sprite(p + "sprRadSkillBall",  6, 16, 16);
			RadSkillTrail = sprite(p + "sprRadSkillTrail", 8, 16, 16);
			
			 // Red Ammo:
			RedAmmoChest       = sprite(p + "sprRedAmmoChest",       1, 8, 8, shn16);
			RedAmmoChestOpen   = sprite(p + "sprRedAmmoChestOpen",   1, 8, 8);
			RedAmmoPickup      = sprite(p + "sprRedAmmoPickup",      1, 5, 5, shn10);
			RedAmmoHUD         = sprite(p + "sprRedAmmoHUD",         2, 1, 1);
			RedAmmoHUDAmmo     = sprite(p + "sprRedAmmoHUDAmmo",     2, 1, 2);
			RedAmmoHUDFill     = sprite(p + "sprRedAmmoHUDFill",     2, 0, 0);
			RedAmmoHUDCost     = sprite(p + "sprRedAmmoHUDCost",     2, 2, 2);
			RedAmmoHUDGold     = sprite(p + "sprRedAmmoHUDGold",     2, 1, 1);
			RedAmmoHUDCostGold = sprite(p + "sprRedAmmoHUDCostGold", 2, 2, 2);
			
			 // Red Crystal Chest:
			RedChest           = sprite(p + "sprRedChest",           1,  8,  8, shn16);
			RedChestOpen       = sprite(p + "sprRedChestOpen",       1,  8,  8);
			RedSkillBall       = sprite(p + "sprRedSkillBall",       6, 16, 16);
			RedSkillBallTether = sprite(p + "sprRedSkillBallTether", 4,  0,  1);
			
			 // Rogue Backpack:
			RogueBackpack     = sprite(p + "sprRogueBackpack",     1, 8, 8, shn16);
			RogueBackpackOpen = sprite(p + "sprRogueBackpackOpen", 1, 8, 8);
			
			 // Spirit Pickup:
			SpiritPickup    = sprite(p + "sprSpiritPickup",    1, 5, 5, shn10);
			SpiritChest     = sprite(p + "sprSpiritChest",     1, 8, 8, shn16);
			SpiritChestOpen = sprite(p + "sprSpiritChestOpen", 1, 8, 8);
			
			 // Sunken Chest:
			SunkenChest     = sprite(p + "sprSunkenChest",     1, 12, 12, shn24);
			SunkenChestOpen = sprite(p + "sprSunkenChestOpen", 1, 12, 12);
			SunkenCoin      = sprite(p + "sprCoin",            1,  3,  3, shn8);
			SunkenCoinBig   = sprite(p + "sprCoinBig",         1,  3,  3, shn8);
			
			 // Hammerhead Pickup:
			HammerHeadPickup            = sprite(p + "sprHammerHeadPickup",            1,  5,  5, shn10);
			HammerHeadPickupEffect      = sprite(p + "sprHammerHeadPickupEffect",      3, 16,  8);
			HammerHeadPickupEffectSpawn = sprite(p + "sprHammerHeadPickupEffectSpawn", 9, 16,  8);
			HammerHeadChest             = sprite(p + "sprHammerHeadChest",             1,  8,  8, shn16);
			HammerHeadChestOpen         = sprite(p + "sprHammerHeadChestOpen",         1,  8,  8);
			HammerHeadChestEffect       = sprite(p + "sprHammerHeadChestEffect",       3, 16,  8);
			HammerHeadChestEffectSpawn  = sprite(p + "sprHammerHeadChestEffectSpawn",  9, 16,  8);
			
			 // Lead Ribs Upgraded Rads:
			RadUpg    = sprite(p + "sprRadUpg",    1, 5, 5, shn10);
			BigRadUpg = sprite(p + "sprBigRadUpg", 1, 8, 8, shn16);
			
			 // Quest Chest:
			QuestChest		  = sprite(p + "sprQuestChest", 	   1,  12, 12, shn24);
			QuestChestOpen    = sprite(p + "sprQuestChestOpen",    1,  12, 12);
			QuestChestBig	  = sprite(p + "sprQuestChestBig",	   1,  32, 32, shn64);
			QuestChestBigOpen = sprite(p + "sprQuestChestBigOpen", 1,  32, 32);
			QuestSparkle	  = sprite(p + "sprQuestSparkle",	   4,  6,  6);
			
		//#endregion
		
		//#region RACES
		m = "races/";
			
			var _list = {
				// [Name, Frames, X, Y, Has B Variant]
				
				"parrot" : {
					skin : 2,
					sprt : [
						["Loadout",       2, 16,  16, true],
						["Map",           1, 10,  10, true],
						["Portrait",      1, 20, 221, true],
						["Select",        2,  0,   0, false],
						["UltraIcon",     2, 12,  16, false],
						["UltraHUDA",     1,  8,   9, false],
						["UltraHUDB",     1,  8,   9, false],
						["Idle",          4, 12,  12, true],
						["Walk",          6, 12,  12, true],
						["Hurt",          3, 12,  12, true],
						["Dead",          6, 12,  12, true],
						["GoSit",         3, 12,  12, true],
						["Sit",           1, 12,  12, true],
						["MenuSelected", 10, 16,  16, false],
						["Feather",       1,  3,   4, true],
						["FeatherHUD",    8,  5,   5, true]
					]
				},
				
				"beetle" : {
					skin : 1,
					sprt : [
						["Loadout",       2, 16,  16, true],
						["Map",           1, 10,  10, true],
						["Portrait",      1, 20, 221, true],
						["Select",        2,  0,   0, false],
						["UltraIcon",     2, 12,  16, false],
						["UltraHUDA",     1,  8,   9, false],
						["UltraHUDB",     1,  8,   9, false],
						["Idle",          4, 12,  12, true],
						["Walk",          8, 12,  12, true],
						["Hurt",          3, 12,  12, true],
						["Dead",         10, 12,  12, true],
						["GoSit",         3, 12,  12, true],
						["Sit",           1, 12,  12, true],
						["Menu",          4, 12,  12, false],
						["MenuSelect",    4, 12,  12, false],
						["MenuSelected",  8, 12,  12, false],
						["MenuDeselect", 10, 12,  12, false]
					]
				}/*,
				
				"???" : {
					skin : 2,
					sprt : [
						["Loadout",   2, 16,  16, true],
						["Map",       1, 10,  10, true],
						["Portrait",  1, 40, 243, true],
						["Select",    2,  0,   0, false],
						["UltraIcon", 2, 12,  16, false],
						["UltraHUDA", 1,  8,   9, false],
						["UltraHUDB", 1,  8,   9, false],
						["Idle",      8, 12,  12, true],
						["Walk",      6, 12,  12, true],
						["Hurt",      3, 12,  12, true],
						["Dead",      6, 12,  12, true],
						["GoSit",     3, 12,  12, true],
						["Sit",       1, 12,  12, true]
					]
				}*/
			};
			
			Race = {};
			
			for(var i = 0; i < lq_size(_list); i++){
				var	_race = lq_get_key(_list, i),
					_info = lq_get_value(_list, i);
					
				lq_set(Race, _race, []);
				
				for(var b = 0; b < _info.skin; b++){
					var	_sprt = {},
						n = string_upper(string_char_at(_race, 0)) + string_delete(_race, 1, 1);
						
					p = m + n + "/spr" + n;
					
					with(lq_get_value(_list, i).sprt){
						var	_name = self[0],
							_img  = self[1],
							_x    = self[2],
							_y    = self[3],
							_hasB = self[4];
							
						lq_set(_sprt, _name, sprite(p + ((_hasB && b > 0) ? chr(ord("A") + b) : "") + _name, _img, _x, _y));
					}
					
					array_push(lq_get(Race, _race), _sprt);
				}
			}
			
			 // Parrot Charm:
			p = m + "Parrot/";
			AllyReviveArea      = sprite(p + "sprAllyReviveArea",      4, 35, 45);
			AllyNecroReviveArea = sprite(p + "sprAllyNecroReviveArea", 4, 17, 20);
			
		//#endregion
		
		//#region SKINS
		m = "skins/";
			
			 // Frog Icon ENHANCED:
			p = "sprites/" + m;
			sprite_replace_image(sprLoadoutSkin, p + "sprFrogLoadout.png", 28);
			
			//#region ANGLER FISH
			var p = m + "FishAngler/";
				
				 // Player:
				FishAnglerIdle  = sprite(p + "sprFishAnglerIdle",  4, 12, 12);
				FishAnglerWalk  = sprite(p + "sprFishAnglerWalk",  6, 12, 12);
				FishAnglerHurt  = sprite(p + "sprFishAnglerHurt",  3, 12, 12);
				FishAnglerDead  = sprite(p + "sprFishAnglerDead",  6, 12, 12);
				FishAnglerGoSit = sprite(p + "sprFishAnglerGoSit", 3, 12, 12);
				FishAnglerSit   = sprite(p + "sprFishAnglerSit",   1, 12, 12);
				
				 // Menu:
				FishAnglerPortrait = sprite(p + "sprFishAnglerPortrait", 1, 40, 243);
				FishAnglerLoadout  = sprite(p + "sprFishAnglerLoadout",  2, 16,  16);
				FishAnglerMapIcon  = sprite(p + "sprFishAnglerMapIcon",  1, 10,  10);
				
				 // Eye Trail:
				FishAnglerTrail = sprite(p + "sprFishAnglerTrail", 6, 12, 12);
				
			//#endregion
			
			////#region BAT EYES
			//var p = m + "EyesBat/";
			//	
			//	 // Player:
			//	EyesBatIdle  = sprite(p + "sprEyesBatIdle",  4, 12, 12);
			//	EyesBatWalk  = sprite(p + "sprEyesBatWalk",  6, 12, 16);
			//	EyesBatHurt  = sprite(p + "sprEyesBatHurt",  3, 12, 12);
			//	EyesBatDead  = sprite(p + "sprEyesBatDead",  6, 12, 12);
			//	EyesBatGoSit = sprite(p + "sprEyesBatGoSit", 3, 12, 12);
			//	EyesBatSit   = sprite(p + "sprEyesBatSit",   1, 12, 12);
			//	
			//	 // Menu:
			//	EyesBatPortrait = sprite(p + "sprEyesBatPortrait", 1, 40, 243);
			//	EyesBatLoadout  = sprite(p + "sprEyesBatLoadout",  2, 16,  16);
			//	EyesBatMapIcon  = sprite(p + "sprEyesBatMapIcon",  1, 10,  10);
			//	
			////#endregion
			//
			////#region BONUS ROBOT
			//var p = m + "RobotBonus/";
			//	
			//	 // Player:
			//	RobotBonusIdle  = sprite(p + "sprRobotBonusIdle",  15, 12, 12);
			//	RobotBonusWalk  = sprite(p + "sprRobotBonusWalk",   6, 12, 12);
			//	RobotBonusHurt  = sprite(p + "sprRobotBonusHurt",   3, 12, 12);
			//	RobotBonusDead  = sprite(p + "sprRobotBonusDead",   6, 12, 12);
			//	RobotBonusGoSit = sprite(p + "sprRobotBonusGoSit",  3, 12, 12);
			//	RobotBonusSit   = sprite(p + "sprRobotBonusSit",    1, 12, 12);
			//	
			//	 // Menu:
			//	RobotBonusPortrait = sprite(p + "sprRobotBonusPortrait", 1, 40, 243);
			//	RobotBonusLoadout  = sprite(p + "sprRobotBonusLoadout",  2, 16,  16);
			//	RobotBonusMapIcon  = sprite(p + "sprRobotBonusMapIcon",  1, 10,  10);
			//	
			////#endregion
			//
			////#region COAT Y.V.
			//var p = m + "YVCoat/";
			//	
			//	 // Player:
			//	YVCoatIdle  = sprite(p + "sprYVCoatIdle",  14, 12, 12);
			//	YVCoatWalk  = sprite(p + "sprYVCoatWalk",   6, 12, 12);
			//	YVCoatHurt  = sprite(p + "sprYVCoatHurt",   3, 12, 12);
			//	YVCoatDead  = sprite(p + "sprYVCoatDead",  19, 24, 24);
			//	YVCoatGoSit = sprite(p + "sprYVCoatGoSit",  3, 12, 12);
			//	YVCoatSit   = sprite(p + "sprYVCoatSit",    1, 12, 12);
			//	
			//	 // Menu:
			//	YVCoatPortrait = sprite(p + "sprYVCoatPortrait", 1, 40, 243);
			//	YVCoatLoadout  = sprite(p + "sprYVCoatLoadout",  2, 16,  16);
			//	YVCoatMapIcon  = sprite(p + "sprYVCoatMapIcon",  1, 10,  10);
			//	
			////#endregion
			
			//#region COOL FROG
			var p = m + "FrogCool/";
				
				 // Player:
				FrogCoolIdle  = sprite(p + "sprFrogCoolIdle",  6, 12, 12);
				FrogCoolWalk  = sprite(p + "sprFrogCoolWalk",  6, 12, 12);
				FrogCoolHurt  = sprite(p + "sprFrogCoolHurt",  3, 12, 12);
				FrogCoolDead  = sprite(p + "sprFrogCoolDead",  6, 24, 24);
				FrogCoolGoSit = sprite(p + "sprFrogCoolGoSit", 3, 12, 12);
				FrogCoolSit   = sprite(p + "sprFrogCoolSit",   6, 12, 12);
				
				 // Menu:
				FrogCoolPortrait = sprite(p + "sprFrogCoolPortrait", 1, 40, 243);
				FrogCoolLoadout  = sprite(p + "sprFrogCoolLoadout",  2, 16,  16);
				FrogCoolMapIcon  = sprite(p + "sprFrogCoolMapIcon",  1, 10,  10);
				
			//#endregion
			
			//#region ORCHID PLANT
			var p = m + "PlantOrchid/";
				
				 // Player:
				PlantOrchidIdle  = sprite(p + "sprPlantOrchidIdle",  4, 16, 16);
				PlantOrchidWalk  = sprite(p + "sprPlantOrchidWalk",  4, 16, 16);
				PlantOrchidHurt  = sprite(p + "sprPlantOrchidHurt",  3, 16, 16);
				PlantOrchidDead  = sprite(p + "sprPlantOrchidDead",  9, 16, 16);
				PlantOrchidGoSit = sprite(p + "sprPlantOrchidGoSit", 3, 16, 16);
				PlantOrchidSit   = sprite(p + "sprPlantOrchidSit",   1, 16, 16);
				
				 // Menu:
				PlantOrchidPortrait = sprite(p + "sprPlantOrchidPortrait", 1, 40, 243);
				PlantOrchidLoadout  = sprite(p + "sprPlantOrchidLoadout",  2, 16,  16);
				PlantOrchidMapIcon  = sprite(p + "sprPlantOrchidMapIcon",  1, 10,  10);
				
				 // Snare:
				PlantOrchidTangle     = sprite(p + "sprPlantOrchidTangle",     6, 24, 24);
				PlantOrchidTangleSeed = sprite(p + "sprPlantOrchidTangleSeed", 2,  4,  4);
				
			//#endregion
			
			//#region RED CRYSTAL
			p = m + "CrystalRed/";
				
				 // Player:
				CrystalRedIdle  = sprite(p + "sprCrystalRedIdle",  4, 12, 12);
				CrystalRedWalk  = sprite(p + "sprCrystalRedWalk",  6, 12, 12);
				CrystalRedHurt  = sprite(p + "sprCrystalRedHurt",  3, 12, 12);
				CrystalRedDead  = sprite(p + "sprCrystalRedDead",  6, 12, 12);
				CrystalRedGoSit = sprite(p + "sprCrystalRedGoSit", 3, 12, 12);
				CrystalRedSit   = sprite(p + "sprCrystalRedSit",   1, 12, 12);
				
				 // Menu:
				CrystalRedPortrait = sprite(p + "sprCrystalRedPortrait", 1, 40, 243);
				CrystalRedLoadout  = sprite(p + "sprCrystalRedLoadout",  2, 16,  16);
				CrystalRedMapIcon  = sprite(p + "sprCrystalRedMapIcon",  1, 10,  10);
				
				 // Shield:
				CrystalRedShield          = sprite(p + "sprCrystalRedShield",          4, 32, 42);
				CrystalRedShieldDisappear = sprite(p + "sprCrystalRedShieldDisappear", 6, 32, 42);
				CrystalRedShieldIdleFront = sprite(p + "sprCrystalRedShieldIdleFront", 1, 32, 42);
				CrystalRedShieldWalkFront = sprite(p + "sprCrystalRedShieldWalkFront", 8, 32, 42);
				CrystalRedShieldIdleBack  = sprite(p + "sprCrystalRedShieldIdleBack",  1, 32, 42);
				CrystalRedShieldWalkBack  = sprite(p + "sprCrystalRedShieldWalkBack",  8, 32, 42);
				CrystalRedTrail           = sprite(p + "sprCrystalRedTrail",           5,  8,  8);
				
			//#endregion
			
			//#region WEAPONS
			m += "Weapons/";
				
				 // Angler:
				p = m + "Angler/";
				AnglerAssaultRifle    = sprite(p + "sprAnglerAssaultRifle",    1,  4,  3, shnWep);
				AnglerBazooka         = sprite(p + "sprAnglerBazooka",         1, 10,  7, shnWep);
				AnglerCrossbow        = sprite(p + "sprAnglerCrossbow",        1,  2,  3, shnWep);
				AnglerDiscGun         = sprite(p + "sprAnglerDiscGun",         1, -2,  3, shnWep);
				AnglerGrenadeLauncher = sprite(p + "sprAnglerGrenadeLauncher", 1,  2,  3, shnWep);
				AnglerGuitar          = sprite(p + "sprAnglerGuitar",          1,  2,  7, shnWep);
				AnglerLaserPistol     = sprite(p + "sprAnglerLaserPistol",     1, -3,  3, shnWep);
				AnglerMachinegun      = sprite(p + "sprAnglerMachinegun",      1,  0,  2, shnWep);
				AnglerNukeLauncher    = sprite(p + "sprAnglerNukeLauncher",    1,  9, 10, shnWep);
				AnglerPlasmaGun       = sprite(p + "sprAnglerPlasmaGun",       1,  1,  4, shnWep);
				AnglerRevolver        = sprite(p + "sprAnglerRevolver",        1, -3,  2, shnWep);
				AnglerScrewdriver     = sprite(p + "sprAnglerScrewdriver",     1, -2,  3, shnWep);
				AnglerShotgun         = sprite(p + "sprAnglerShotgun",         1,  3,  3, shnWep);
				AnglerSlugger         = sprite(p + "sprAnglerSlugger",         1,  1,  3, shnWep);
				AnglerSplinterGun     = sprite(p + "sprAnglerSplinterGun",     1,  2,  3, shnWep);
				AnglerTeleportGun     = sprite(p + "sprAnglerTeleportGun",     1,  6,  6, shnWep);
				AnglerTrident         = sprite(p + "sprAnglerTrident",         1, 12,  7, shnWep);
				AnglerTunneller       = sprite(p + "sprAnglerTunneller",       1, 13,  6, shnWep);
				AnglerTunnellerHUD    = sprite(p + "sprAnglerTunneller",       1, 16,  6, shnWep);
				AnglerWrench          = sprite(p + "sprAnglerWrench",          1,  1,  4, shnWep);
				AnglerBolt            = sprite(p + "sprAnglerBolt",            2,  4,  8);
				AnglerDisc            = sprite(p + "sprAnglerDisc",            2,  7,  7);
				AnglerGrenade         = sprite(p + "sprAnglerGrenade",         1,  3,  3);
				AnglerNuke            = sprite(p + "sprAnglerNuke",            1,  8,  8);
				AnglerRocket          = sprite(p + "sprAnglerRocket",          1,  4,  4);
				
				 // Cool:
				p = m + "Cool/";
				CoolAssaultRifle    = sprite(p + "sprCoolAssaultRifle",    1,  2, 3, shnWep);
				CoolBazooka         = sprite(p + "sprCoolBazooka",         1, 11, 4, shnWep);
				CoolCrossbow        = sprite(p + "sprCoolCrossbow",        1,  2, 3, shnWep);
				CoolDiscGun         = sprite(p + "sprCoolDiscGun",         1, -4, 3, shnWep);
				CoolFrogPistol      = sprite(p + "sprCoolFrogPistol",      1, -3, 4, shnWep);
				CoolGrenadeLauncher = sprite(p + "sprCoolGrenadeLauncher", 1,  2, 2, shnWep);
				CoolLaserPistol     = sprite(p + "sprCoolLaserPistol",     1, -3, 3, shnWep);
				CoolMachinegun      = sprite(p + "sprCoolMachinegun",      1, -1, 1, shnWep);
				CoolNukeLauncher    = sprite(p + "sprCoolNukeLauncher",    1,  8, 6, shnWep);
				CoolPlasmaGun       = sprite(p + "sprCoolPlasmaGun",       1,  1, 4, shnWep);
				CoolRevolver        = sprite(p + "sprCoolRevolver",        1, -3, 2, shnWep);
				CoolScrewdriver     = sprite(p + "sprCoolScrewdriver",     1, -2, 2, shnWep);
				CoolShotgun         = sprite(p + "sprCoolShotgun",         1,  2, 2, shnWep);
				CoolSlugger         = sprite(p + "sprCoolSlugger",         1,  2, 2, shnWep);
				CoolSplinterGun     = sprite(p + "sprCoolSplinterGun",     1,  2, 3, shnWep);
				CoolTeleportGun     = sprite(p + "sprCoolTeleportGun",     1,  6, 6, shnWep);
				CoolTrident         = sprite(p + "sprCoolTrident",         1, 12, 8, shnWep);
				CoolTunneller       = sprite(p + "sprCoolTunneller",       1, 13, 4, shnWep);
				CoolTunnellerHUD    = sprite(p + "sprCoolTunneller",       1, 16, 4, shnWep);
				CoolWrench          = sprite(p + "sprCoolWrench",          1, -1, 3, shnWep);
				CoolBolt            = sprite(p + "sprCoolBolt",            2,  4, 8);
				CoolDisc            = sprite(p + "sprCoolDisc",            2,  7, 7);
				CoolGrenade         = sprite(p + "sprCoolGrenade",         1,  3, 3);
				CoolNuke            = sprite(p + "sprCoolNuke",            1,  8, 8);
				CoolRocket          = sprite(p + "sprCoolRocket",          1,  4, 4);
				
				 // Orchid:
				p = m + "Orchid/";
				OrchidAssaultRifle    = sprite(p + "sprOrchidAssaultRifle",    1,  5, 4, shnWep);
				OrchidBazooka         = sprite(p + "sprOrchidBazooka",         1, 12, 5, shnWep);
				OrchidCrossbow        = sprite(p + "sprOrchidCrossbow",        1,  4, 4, shnWep);
				OrchidDiscGun         = sprite(p + "sprOrchidDiscGun",         1, -3, 4, shnWep);
				OrchidFrogPistol      = sprite(p + "sprOrchidFrogPistol",      1, -4, 4, shnWep);
				OrchidFrogPistolRusty = sprite(p + "sprOrchidFrogPistolRusty", 1, -4, 4, shnWep);
				OrchidGrenadeLauncher = sprite(p + "sprOrchidGrenadeLauncher", 1,  5, 5, shnWep);
				OrchidLaserPistol     = sprite(p + "sprOrchidLaserPistol",     1, -2, 2, shnWep);
				OrchidMachinegun      = sprite(p + "sprOrchidMachinegun",      1,  3, 3, shnWep);
				OrchidNukeLauncher    = sprite(p + "sprOrchidNukeLauncher",    1,  8, 8, shnWep);
				OrchidPlasmaGun       = sprite(p + "sprOrchidPlasmaGun",       1,  3, 4, shnWep);
				OrchidRevolver        = sprite(p + "sprOrchidRevolver",        1, -3, 2, shnWep);
				OrchidScrewdriver     = sprite(p + "sprOrchidScrewdriver",     1, -1, 3, shnWep);
				OrchidShotgun         = sprite(p + "sprOrchidShotgun",         1,  5, 3, shnWep);
				OrchidSlugger         = sprite(p + "sprOrchidSlugger",         1,  4, 4, shnWep);
				OrchidSplinterGun     = sprite(p + "sprOrchidSplinterGun",     1,  3, 4, shnWep);
				OrchidTeleportGun     = sprite(p + "sprOrchidTeleportGun",     1,  5, 6, shnWep);
				OrchidTrident         = sprite(p + "sprOrchidTrident",         1, 12, 7, shnWep);
				OrchidTunneller       = sprite(p + "sprOrchidTunneller",       1, 14, 9, shnWep);
				OrchidTunnellerHUD    = sprite(p + "sprOrchidTunneller",       1, 20, 9, shnWep);
				OrchidWrench          = sprite(p + "sprOrchidWrench",          1,  1, 4, shnWep);
				OrchidBolt            = sprite(p + "sprOrchidBolt",            2,  4, 8);
				OrchidDisc            = sprite(p + "sprOrchidDisc",            2,  6, 6);
				OrchidGrenade         = sprite(p + "sprOrchidGrenade",         1,  3, 3);
				OrchidNuke            = sprite(p + "sprOrchidNuke",            1,  8, 8);
				OrchidRocket          = sprite(p + "sprOrchidRocket",          1,  4, 4);
				
				 // Red:
				p = m + "Red/";
				RedAssaultRifle    = sprite(p + "sprRedAssaultRifle",    1,  4, 3, shnWep);
				RedBazooka         = sprite(p + "sprRedBazooka",         1, 11, 2, shnWep);
				RedCrossbow        = sprite(p + "sprRedCrossbow",        1,  2, 5, shnWep);
				RedDiscGun         = sprite(p + "sprRedDiscGun",         1, -3, 4, shnWep);
				RedGrenadeLauncher = sprite(p + "sprRedGrenadeLauncher", 1,  1, 2, shnWep);
				RedLaserPistol     = sprite(p + "sprRedLaserPistol",     1, -2, 2, shnWep);
				RedMachinegun      = sprite(p + "sprRedMachinegun",      1,  1, 0, shnWep);
				RedNukeLauncher    = sprite(p + "sprRedNukeLauncher",    1,  7, 6, shnWep);
				RedPlasmaGun       = sprite(p + "sprRedPlasmaGun",       1,  3, 3, shnWep);
				RedRevolver        = sprite(p + "sprRedRevolver",        1, -2, 2, shnWep);
				RedScrewdriver     = sprite(p + "sprRedScrewdriver",     1, -2, 3, shnWep);
				RedShotgun         = sprite(p + "sprRedShotgun",         1,  4, 2, shnWep);
				RedSlugger         = sprite(p + "sprRedSlugger",         1,  2, 2, shnWep);
				RedSplinterGun     = sprite(p + "sprRedSplinterGun",     1,  2, 4, shnWep);
				RedTeleportGun     = sprite(p + "sprRedTeleportGun",     1,  6, 5, shnWep);
				RedTrident         = sprite(p + "sprRedTrident",         1, 12, 7, shnWep);
				RedTunneller       = sprite(p + "sprRedTunneller",       1, 14, 7, shnWep);
				RedTunnellerHUD    = sprite(p + "sprRedTunneller",       1, 18, 8, shnWep);
				RedWrench          = sprite(p + "sprRedWrench",          1,  1, 3, shnWep);
				RedBolt            = sprite(p + "sprRedBolt",            2,  4, 8);
				RedDisc            = sprite(p + "sprRedDisc",            2,  6, 6);
				RedGrenade         = sprite(p + "sprRedGrenade",         1,  3, 3);
				RedNuke            = sprite(p + "sprRedNuke",            1,  8, 8);
				RedRocket          = sprite(p + "sprRedRocket",          1,  4, 4);
				
			//#endregion
			
		//#endregion
		
		//#region PETS
		m = "pets/";
			
			 // General:
			PetArrow = sprite(m + "sprPetArrow", 1, 3,  0);
			PetLost  = sprite(m + "sprPetLost",  7, 8, 16);
			
			 // Scorpion:
			p = m + "Desert/";
			PetScorpionIcon   = sprite(p + "sprPetScorpionIcon",   1,  6,  6);
			PetScorpionIdle   = sprite(p + "sprPetScorpionIdle",   4, 16, 16);
			PetScorpionWalk   = sprite(p + "sprPetScorpionWalk",   6, 16, 16);
			PetScorpionHurt   = sprite(p + "sprPetScorpionHurt",   3, 16, 16);
			PetScorpionDead   = sprite(p + "sprPetScorpionDead",   6, 16, 16);
			PetScorpionFire   = sprite(p + "sprPetScorpionFire",   6, 16, 16);
			PetScorpionShield = sprite(p + "sprPetScorpionShield", 6, 16, 16);
			
			 // Parrot:
			p = m + "Coast/";
			PetParrotNote  = sprite(p + "sprPetParrotNote",   5,  4,  4);
			PetParrotIcon  = sprite(p + "sprPetParrotIcon",   1,  6,  6);
			PetParrotIdle  = sprite(p + "sprPetParrotIdle",   6, 12, 12);
			PetParrotWalk  = sprite(p + "sprPetParrotWalk",   6, 12, 14);
			PetParrotHurt  = sprite(p + "sprPetParrotDodge",  3, 12, 12);
			PetParrotBIcon = sprite(p + "sprPetParrotBIcon",  1,  6,  6);
			PetParrotBIdle = sprite(p + "sprPetParrotBIdle",  6, 12, 12);
			PetParrotBWalk = sprite(p + "sprPetParrotBWalk",  6, 12, 14);
			PetParrotBHurt = sprite(p + "sprPetParrotBDodge", 3, 12, 12);
			
			 // CoolGuy:
			p = m + "Pizza/";
			PetCoolGuyIcon = sprite(p + "sprPetCoolGuyIcon",  1,  6,  6);
			PetCoolGuyIdle = sprite(p + "sprPetCoolGuyIdle",  4, 12, 12);
			PetCoolGuyWalk = sprite(p + "sprPetCoolGuyWalk",  6, 12, 12);
			PetCoolGuyHurt = sprite(p + "sprPetCoolGuyDodge", 3, 12, 12);
			PetPeasIcon    = sprite(p + "sprPetPeasIcon",     1,  6,  6);
			PetPeasIdle    = sprite(p + "sprPetPeasIdle",     4, 12, 12);
			PetPeasWalk    = sprite(p + "sprPetPeasWalk",     6, 12, 12);
			PetPeasHurt    = sprite(p + "sprPetPeasDodge",    3, 12, 12);
			
			 // BabyShark:
			p = m + "Oasis/";
			PetSlaughterIcon  = sprite(p + "sprPetSlaughterIcon",   1,  6,  6);
			PetSlaughterIdle  = sprite(p + "sprPetSlaughterIdle",   4, 12, 12);
			PetSlaughterWalk  = sprite(p + "sprPetSlaughterWalk",   6, 12, 12);
			PetSlaughterHurt  = sprite(p + "sprPetSlaughterHurt",   3, 12, 12);
			PetSlaughterDead  = sprite(p + "sprPetSlaughterDead",  10, 24, 24);
			PetSlaughterSpwn  = sprite(p + "sprPetSlaughterSpwn",   7, 24, 24);
			PetSlaughterBite  = sprite(p + "sprPetSlaughterBite",   6, 12, 12);
			SlaughterBite     = sprite(p + "sprSlaughterBite",      6,  8, 12);
			SlaughterPropIdle = sprite(p + "sprSlaughterPropIdle",  1, 12, 12);
			SlaughterPropHurt = sprite(p + "sprSlaughterPropHurt",  3, 12, 12);
			SlaughterPropDead = sprite(p + "sprSlaughterPropDead",  3, 12, 12);
			
			 // Octopus:
			p = m + "Trench/";
			PetOctoIcon     = sprite(p + "sprPetOctoIcon",      1,  7,  7);
			PetOctoIdle     = sprite(p + "sprPetOctoIdle",     16, 12, 12);
			PetOctoHurt     = sprite(p + "sprPetOctoDodge",     3, 12, 12);
			PetOctoHide     = sprite(p + "sprPetOctoHide",     30, 12, 12);
			PetOctoHideIcon = sprite(p + "sprPetOctoHideIcon",  1,  7,  6);
			
			 // Salamander:
			p = m + "Scrapyards/";
			PetSalamanderIcon = sprite(p + "sprPetSalamanderIcon", 1,  6,  6);
			PetSalamanderIdle = sprite(p + "sprPetSalamanderIdle", 6, 16, 16);
			PetSalamanderWalk = sprite(p + "sprPetSalamanderWalk", 8, 16, 16);
			PetSalamanderHurt = sprite(p + "sprPetSalamanderHurt", 3, 16, 16);
			PetSalamanderChrg = sprite(p + "sprPetSalamanderChrg", 3, 16, 16);
			
			 // Golden Chest Mimic:
			p = m + "Mansion/";
			PetMimicIcon = sprite(p + "sprPetMimicIcon",   1,  6,  6);
			PetMimicIdle = sprite(p + "sprPetMimicIdle",  16, 16, 16);
			PetMimicWalk = sprite(p + "sprPetMimicWalk",   6, 16, 16);
			PetMimicHurt = sprite(p + "sprPetMimicDodge",  3, 16, 16);
			PetMimicOpen = sprite(p + "sprPetMimicOpen",   1, 16, 16);
			PetMimicHide = sprite(p + "sprPetMimicHide",   1, 16, 16);
			
			 // Spider
			p = m + "Caves/";
			PetSpiderIcon       = sprite(p + "sprPetSpiderIcon",        1,  6,  6);
			PetSpiderIdle       = sprite(p + "sprPetSpiderIdle",        8, 16, 16);
			PetSpiderWalk       = sprite(p + "sprPetSpiderWalk",        6, 16, 16);
			PetSpiderHurt       = sprite(p + "sprPetSpiderDodge",       3, 16, 16);
			PetSpiderWeb        = sprite(p + "sprPetSpiderWeb",         1,  0,  0);
			PetSpiderWebBits    = sprite(p + "sprWebBits",              5,  4,  4);
			PetSparkle          = sprite(p + "sprPetSparkle",           5,  8,  8);
			PetSpiderCursedIcon = sprite(p + "sprPetSpiderCursedIcon",  1,  6,  6);
			PetSpiderCursedIdle = sprite(p + "sprPetSpiderCursedIdle",  8, 16, 16);
			PetSpiderCursedWalk = sprite(p + "sprPetSpiderCursedWalk",  6, 16, 16);
			PetSpiderCursedHurt = sprite(p + "sprPetSpiderCursedDodge", 3, 16, 16);
			PetSpiderCursedKill = sprite(p + "sprPetSpiderCursedKill",  6, 16, 16);
			
			 // Prism:
			p = m + "Cursed Caves/";
			PetPrismIcon = sprite(p + "sprPetPrismIcon", 1,  6,  6);
			PetPrismIdle = sprite(p + "sprPetPrismIdle", 6, 12, 12);
			
			 // Mantis:
			p = m + "Vault/";
			PetOrchidIcon = sprite(p + "sprPetOrchidIcon",  1,  6,  6);
			PetOrchidIdle = sprite(p + "sprPetOrchidIdle", 28, 12, 12);
			PetOrchidWalk = sprite(p + "sprPetOrchidWalk",  6, 12, 12);
			PetOrchidHurt = sprite(p + "sprPetOrchidHurt",  3, 12, 12);
			PetOrchidBall = sprite(p + "sprPetOrchidBall",  2, 12, 12);
			
			 // Weapon Chest Mimic:
			p = m + "Weapon/";
			PetWeaponIcon       = sprite(p + "sprPetWeaponIcon",        1,  6,  6);
			PetWeaponChst       = sprite(p + "sprPetWeaponChst",        1,  8,  8);
			PetWeaponHide       = sprite(p + "sprPetWeaponHide",        8, 12, 12);
			PetWeaponSpwn       = sprite(p + "sprPetWeaponSpwn",       16, 12, 12);
			PetWeaponIdle       = sprite(p + "sprPetWeaponIdle",        8, 12, 12);
			PetWeaponWalk       = sprite(p + "sprPetWeaponWalk",        8, 12, 12);
			PetWeaponHurt       = sprite(p + "sprPetWeaponHurt",        3, 12, 12);
			PetWeaponDead       = sprite(p + "sprPetWeaponDead",        6, 12, 12);
			PetWeaponStat       = sprite(p + "sprPetWeaponStat",        1, 20,  5);
			PetWeaponCursedIcon = sprite(p + "sprPetWeaponIconCursed",  1,  6,  6);
			PetWeaponCursedChst = sprite(p + "sprPetWeaponChstCursed",  1,  8,  8);
			PetWeaponCursedHide = sprite(p + "sprPetWeaponHideCursed",  8, 12, 12);
			PetWeaponCursedSpwn = sprite(p + "sprPetWeaponSpwnCursed", 16, 12, 12);
			PetWeaponCursedIdle = sprite(p + "sprPetWeaponIdleCursed",  8, 12, 12);
			PetWeaponCursedWalk = sprite(p + "sprPetWeaponWalkCursed",  8, 12, 12);
			PetWeaponCursedHurt = sprite(p + "sprPetWeaponHurtCursed",  3, 12, 12);
			PetWeaponCursedDead = sprite(p + "sprPetWeaponDeadCursed",  6, 12, 12);
			
			 // Twins:
			p = m + "Red/";
			PetTwinsIcon        = sprite(p + "sprPetTwinsIcon",        1,  6,  6);
			PetTwinsStat        = sprite(p + "sprPetTwinsStat",        6, 12, 12);
			PetTwinsRedIcon     = sprite(p + "sprPetTwinsRedIcon",     1,  6,  6);
			PetTwinsRed         = sprite(p + "sprPetTwinsRed",         6, 12, 12);
			PetTwinsRedEffect   = sprite(p + "sprPetTwinsRedEffect",   6,  8,  8);
			PetTwinsWhiteIcon   = sprite(p + "sprPetTwinsWhiteIcon",   1,  6,  6);
			PetTwinsWhite       = sprite(p + "sprPetTwinsWhite",       6, 12, 12);
			PetTwinsWhiteEffect = sprite(p + "sprPetTwinsWhiteEffect", 6,  8,  8);
			CrystalWhiteTrail   = sprite(p + "sprCrystalWhiteTrail",   5,  8,  8);
			
			 // Cuz:
			p = m + "Crib/";
			PetCuzIcon = sprite(p + "sprPetCuzIcon", 1, 6, 6);
			
			 // Guardian:
			p = m + "HQ/";
			PetGuardianIcon 		   = sprite(p + "sprPetGuardianIcon", 			 1,  6,  7);
			PetGuardianIdle 		   = sprite(p + "sprPetGuardianIdle", 			 4,  16, 16);
			PetGuardianHurt			   = sprite(p + "sprPetGuardianHurt",			 3,	 16, 16);
			PetGuardianDashStart	   = sprite(p + "sprPetGuardianDashStart",		 2,  16, 16);
			PetGuardianDash			   = sprite(p + "sprPetGuardianDash",			 2,  16, 16);
			PetGuardianDashEnd		   = sprite(p + "sprPetGuardianDashEnd",		 3,  16, 16);
			PetGuardianAppear		   = sprite(p + "sprPetGuardianAppear",			 6,  16, 16);
			PetGuardianDisappear	   = sprite(p + "sprPetGuardianDisappear",		 6,  16, 16);
			PetGuardianShield		   = sprite(p + "sprPetGuardianShield",			 6,  16, 16);
			PetGuardianShieldDisappear = sprite(p + "sprPetGuardianShieldDisappear", 6,  16, 16);
			
		//#endregion
	}
	
	 // SOUNDS //
	snd = {};
	with(snd){
		var	m = "sounds/enemies/",
			p;
			
		 // Palanking:
		p = m + "Palanking/";
		PalankingHurt  = sound_add(p + "sndPalankingHurt.ogg");
		PalankingDead  = sound_add(p + "sndPalankingDead.ogg");
		PalankingCall  = sound_add(p + "sndPalankingCall.ogg");
		PalankingSwipe = sound_add(p + "sndPalankingSwipe.ogg");
		PalankingTaunt = sound_add(p + "sndPalankingTaunt.ogg");
		sound_volume(PalankingHurt, 0.6);
		
		 // SawTrap:
		p = m + "SawTrap/";
		SawTrap = sound_add(p + "sndSawTrap.ogg");
		
		 // Music:
		mus = {};
		with(mus){
			var p = "sounds/music/";
			amb = {};
			
			 // Areas:
			Coast   = sound_add(p + "musCoast.ogg");
			CoastB  = sound_add(p + "musCoastB.ogg");
			Trench  = sound_add(p + "musTrench.ogg");
			TrenchB = sound_add(p + "musTrenchB.ogg");
			Lair    = sound_add(p + "musLair.ogg");
			Red     = sound_add(p + "musRed.ogg");
			
			 // Bosses:
			SealKing      = sound_add(p + "musSealKing.ogg");
			BigShots      = sound_add(p + "musBigShots.ogg");
			PitSquid      = sound_add(p + "musPitSquid.ogg");
			PitSquidIntro = sound_add(p + "musPitSquidIntro.ogg");
			Tesseract     = sound_add(p + "musTesseract.ogg");
		}
	}
	
	 // SAVE FILE //
	save_data = {};
	save_auto = false;
	if(fork()){
		var _path = save_path;
		
		 // Defaulterize Options:
		with([
			["option:shaders",       true],
			["option:reminders",     true],
			["option:footprints",    true],
			["option:intros",        2],
			["option:outline:pets",  2],
			["option:outline:charm", 2],
			["option:quality:main",  1],
			["option:quality:minor", 1]
		]){
			save_set(self[0], self[1]);
		}
		
		 // Load Existing Save:
		file_load(_path);
		while(!file_loaded(_path)){
			wait 0;
		}
		if(file_exists(_path)){
			var _save = json_decode(string_load(_path));
			
			 // Copy Loaded Save's Values:
			if(is_object(_save)){
				for(var i = 0; i < lq_size(_save); i++){
					lq_set(save_data, lq_get_key(_save, i), lq_get_value(_save, i));
				}
				
				 // Shader Override:
				if(!save_get("shaders_option_reset", false)){
					save_set("shaders_option_reset", true);
					option_set("shaders", true);
				}
			}
			
			 // Save File Corrupt:
			else{
				var _pathCorrupt = string_insert("CORRUPT", _path, string_pos(".", _path));
				string_save(string_load(_path), _pathCorrupt);
				if(fork()){
					while(mod_exists("mod", "teloader")){
						wait 0;
					}
					wait 1;
					trace_color(`NTTE | Something isn't right with your save file... creating a new one and moving old to '${_pathCorrupt}'.`, c_red);
					exit;
				}
			}
		}
		file_unload(_path);
		
		 // Re-Save:
		ntte_save();
		save_auto = true;
		
		exit;
	}
	
	 // Script Binding, Surface, Shader Storage:
	global.bind        = ds_map_create();
	global.bind_hold   = ds_map_create();
	global.surf        = ds_map_create();
	global.shad        = ds_map_create();
	global.shad_active = "";
	
	 // Mod Lists:
	ntte_mods = {
		"mod"    : [],
		"area"   : [],
		"race"   : [],
		"skin"   : [],
		"skill"  : [],
		"crown"  : [],
		"weapon" : []
	};
	ntte_mods_call = {
		"begin_step"   : [],
		"step"         : [],
		"end_step"     : [],
		"draw_shadows" : [],
		"draw_bloom"   : [],
		"draw_dark"    : []
	};
	
	 // Shared Mod Variables:
	ntte_vars = {
		"mods"      : ntte_mods,
		"mods_call" : ntte_mods_call,
		"version"   : ntte_version
	};
	
	 // Object Setup Script Binding:
	global.bind_setup             = ds_map_create();
	global.bind_setup_object_list = [];
	for(var i = 0; object_exists(i); i++){
		array_push(global.bind_setup_object_list, noone);
	}
	
	 // Cloned Starting Weapons:
	global.loadout_wep_clone = ds_list_create();
	
	 // Math Epsilon:
	global.epsilon = 1;
	for(var i = 0; i <= 16; i++){
		global.epsilon = power(10, -i);
		if(global.epsilon == 0){
			break;
		}
	}
	
	 // Projectile Sprite Team Variants:
	global.sprite_team_variant_table = [
		[["EnemyBullet",               EnemyBullet4  ], [sprBullet1,            Bullet1        ], [sprIDPDBullet,           IDPDBullet    ]], // Bullet
		[[sprEnemyBulletHit                          ], [sprBulletHit                          ], [sprIDPDBulletHit                       ]], // Bullet Hit
		[["EnemyHeavyBullet",          "CustomBullet"], [sprHeavyBullet,        HeavyBullet    ], ["IDPDHeavyBullet",       "CustomBullet"]], // Heavy Bullet
		[["EnemyHeavyBulletHit"                      ], [sprHeavyBulletHit                     ], ["IDPDHeavyBulletHit"                   ]], // Heavy Bullet Hit
		[[sprLHBouncer,                LHBouncer     ], [sprBouncerBullet,      BouncerBullet  ], [                                       ]], // Bouncer Bullet
		[[sprLHBouncer,                LHBouncer     ], [sprBouncerShell,       BouncerBullet  ], [                                       ]], // Bouncer Bullet 2
		[[sprEnemyBullet1,             EnemyBullet1  ], [sprAllyBullet,         AllyBullet     ], [                                       ]], // Bandit Bullet
		[[sprEnemyBulletHit                          ], [sprAllyBulletHit                      ], [sprIDPDBulletHit                       ]], // Bandit Bullet Hit
		[[sprEnemyBullet4,             EnemyBullet4  ], ["AllySniperBullet",    AllyBullet     ], [                                       ]], // Sniper Bullet
		[[sprEBullet3,                 EnemyBullet3  ], [sprBullet2,            Bullet2        ], [                                       ]], // Shell
		[[sprEBullet3Disappear,        EnemyBullet3  ], [sprBullet2Disappear,   Bullet2        ], [                                       ]], // Shell Disappear
		[["EnemySlug",                 "CustomShell" ], [sprSlugBullet,         Slug           ], [sprPopoSlug,             PopoSlug      ]], // Slug
		[["EnemySlugDisappear",        "CustomShell" ], [sprSlugDisappear,      Slug           ], [sprPopoSlugDisappear,    PopoSlug      ]], // Slug Disappear
		[["EnemySlugHit"                             ], [sprSlugHit                            ], [sprIDPDBulletHit                       ]], // Slug Hit
		[["EnemySlug",                 "CustomShell" ], [sprHyperSlug,          Slug           ], [sprPopoSlug,             PopoSlug      ]], // Hyper Slug
		[["EnemySlugDisappear",        "CustomShell" ], [sprHyperSlugDisappear, Slug           ], [sprPopoSlugDisappear,    PopoSlug      ]], // Hyper Slug Disappear
		[["EnemyHeavySlug",            "CustomShell" ], [sprHeavySlug,          HeavySlug      ], [                                       ]], // Heavy Slug
		[["EnemyHeavySlugDisappear",   "CustomShell" ], [sprHeavySlugDisappear, HeavySlug      ], [                                       ]], // Heavy Slug Disappear
		[["EnemyHeavySlugHit"                        ], [sprHeavySlugHit,                      ], [                                       ]], // Heavy Slug Hit
		[[sprEFlak,                    "CustomFlak"  ], [sprFlakBullet,         FlakBullet     ], [                                       ]], // Flak
		[[sprEFlakHit                                ], [sprFlakHit                            ], [                                       ]], // Flak Hit
		[["EnemySuperFlak",            "CustomFlak"  ], [sprSuperFlakBullet,    SuperFlakBullet], [                                       ]], // Super Flak
		[["EnemySuperFlakHit"                        ], [sprSuperFlakHit                       ], [                                       ]], // Super Flak Hit
		[[sprEFlak,                    EFlakBullet   ], [sprFlakBullet,         "CustomFlak"   ], [                                       ]], // Gator Flak
		[[sprTrapFire                                ], [sprWeaponFire                         ], [sprFireLilHunter                       ]], // Fire
		[[sprSalamanderBullet                        ], [sprDragonFire                         ], [sprFireLilHunter                       ]], // Fire 2
		[[sprTrapFire                                ], [sprCannonFire                         ], [sprFireLilHunter                       ]], // Fire 3
	//	[[sprFireBall                                ], [sprFireBall                           ], [                                       ]], // Fire Ball
	//	[[sprFireShell                               ], [sprFireShell                          ], [                                       ]], // Fire Shell
		[[sprEnemyLaser,               EnemyLaser    ], [sprLaser,              Laser          ], [                                       ]], // Laser
		[[sprEnemyLaserStart                         ], [sprLaserStart                         ], [                                       ]], // Laser Start
		[[sprEnemyLaserEnd                           ], [sprLaserEnd                           ], [                                       ]], // Laser End
		[[sprLaserCharge                             ], ["AllyLaserCharge"                     ], [                                       ]], // Laser Particle
		[[sprEnemyLightning,           EnemyLightning], [sprLightning,          Lightning      ], [                                       ]], // Lightning
	//	[[sprLightningHit                            ], [sprLightningHit                       ], [                                       ]], // Lightning Hit
	//	[[sprLightningSpawn                          ], [sprLightningSpawn                     ], [                                       ]], // Lightning Particle
		[["EnemyPlasmaBall",           "CustomPlasma"], [sprPlasmaBall,         PlasmaBall     ], [sprPopoPlasma,           PopoPlasmaBall]], // Plasma
		[["EnemyPlasmaBig",            "CustomPlasma"], [sprPlasmaBallBig,      PlasmaBig      ], [                                       ]], // Plasma Big
		[["EnemyPlasmaHuge",           "CustomPlasma"], [sprPlasmaBallHuge,     PlasmaHuge     ], [                                       ]], // Plasma Huge
		[["EnemyPlasmaImpact"                        ], [sprPlasmaImpact                       ], [sprPopoPlasmaImpact                    ]], // Plasma Impact
		[["EnemyPlasmaImpactSmall"                   ], ["PlasmaImpactSmall"                   ], ["PopoPlasmaImpactSmall"                ]], // Plasma Impact Small
		[["EnemyPlasmaTrail"                         ], [sprPlasmaTrail                        ], [sprPopoPlasmaTrail                     ]], // Plasma Particle
		[["EnemyVlasmaBullet"                        ], ["VlasmaBullet"                        ], ["PopoVlasmaBullet"                     ]], // Vector Plasma
		[["EnemyVlasmaCannon"                        ], ["VlasmaCannon"                        ], ["PopoVlasmaCannon"                     ]], // Vector Plasma Cannon
		[[sprEnemySlash                              ], [sprSlash                              ], [sprEnemySlash                          ]]  // Slash
		// Devastator
		// Lightning Cannon
		// Hyper Slug (kinda)
	];
	
	 // Reminders:
	global.remind = [];
	if(fork()){
		while(mod_exists("mod", "teloader")){
			wait 0;
		}
		
		trace_color("NT:TE | Finished loading!", c_yellow);
		repeat(20 * (game_height / 240)) trace("");
		
		if(option_get("reminders")){
			global.remind = [
				{	"x"      : -85,
					"y"      : -2,
					"text"   : "Turn em on!",
					"object" : GameMenuButton,
					"active" : (!UberCont.opt_bossintros && save_get("option:intros", 1) >= 2)
					},
				{	"x"      : -85,
					"y"      : 29,
					"text"   : "Pump it up!",
					"object" : AudioMenuButton,
					"active" : (!UberCont.opt_bossintros)
					}
			];
			
			with(global.remind){
				text_inst = noone;
				time = 0;
			}
			
			 // Chat Reminder:
			var _text = "";
			if(global.remind[0].active){
				_text = "enable boss intros and music";
			}
			else{
				_text = "make sure music is on";
			}
			if(_text != ""){
				trace_color("NT:TE | For the full experience - " + _text + "!", c_yellow);
			}
		}
		
		 // FPS Warning:
		if(room_speed > 30){
			trace_color("NT:TE | WARNING - Playing on higher than 30 FPS will likely cause lag!", c_red);
		}
		
		exit;
	}
	
	 // Color/Alpha-Unblending Shader for Copying Drawn Stuff:
	try{
		if(!null){} // GMS1 only for now
	}
	catch(_error){
		shader_add("Unblend",
			
			/* Vertex Shader */"
			struct VertexShaderInput
			{
				float2 vTexcoord : TEXCOORD0;
				float4 vPosition : POSITION;
			};
			
			struct VertexShaderOutput
			{
				float2 vTexcoord : TEXCOORD0;
				float4 vPosition : SV_POSITION;
			};
			
			uniform float4x4 matrix_world_view_projection;
			
			VertexShaderOutput main(VertexShaderInput INPUT)
			{
				VertexShaderOutput OUT;
				
				OUT.vTexcoord = INPUT.vTexcoord; // (x,y)
				OUT.vPosition = mul(matrix_world_view_projection, INPUT.vPosition); // (x,y,z,w)
				
				return OUT;
			}
			",
			
			/* Fragment/Pixel Shader */"
			struct PixelShaderInput
			{
				float2 vTexcoord : TEXCOORD0;
			};
			
			sampler2D s0;
			
			uniform float blendPower;
			
			float4 main(PixelShaderInput INPUT) : SV_TARGET
			{
				float4 RGBA = tex2D(s0, INPUT.vTexcoord);
				if(RGBA.a > 0.0){
					float RGBFactor = pow(abs(RGBA.a), 1.0 - blendPower);
					return float4(
						RGBA.r / RGBFactor,
						RGBA.g / RGBFactor,
						RGBA.b / RGBFactor,
						pow(abs(RGBA.a), blendPower)
					);
				}
				return RGBA;
			}
			"
		);
	}
	
#define cleanup
	 // Reset Starting Weapons:
	loadout_wep_reset();
	ds_list_destroy(global.loadout_wep_clone);
	
	 // Save Game:
	if(save_auto){
		ntte_save();
	}
	
	 // Clear Surfaces, Shaders, Script Bindings:
	with(ds_map_values(global.surf)) if(surf != -1) surface_destroy(surf);
	with(ds_map_values(global.shad)) if(shad != -1) shader_destroy(shad);
	with(ds_map_values(global.bind)) with(self) with(id) instance_destroy();
	with(ds_map_values(global.bind_hold)) with(self) if(instance_exists(self)) instance_destroy();
	
	 // No Crash:
	with(ntte_mods.race){
		with(instances_matching([CampChar, CharSelect], "race", self)){
			repeat(8) with(instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Dust)){
				motion_add(random(360), random(random(8)));
			}
			instance_delete(self);
		}
	}
	
#macro call script_ref_call

#macro obj global.obj
#macro scr global.scr
#macro spr global.spr
#macro snd global.snd
#macro msk spr.msk
#macro mus snd.mus
#macro lag global.debug_lag

#macro ntte_vars      global.vars
#macro ntte_mods      global.mods
#macro ntte_mods_call global.mods_call
#macro ntte_version   global.version

#macro spr_load     global.spr_load
#macro spr_load_num 20 // How many sprites to load per frame

#macro shnNone false
#macro shnWep  true
#macro shn8    spr.Shine8
#macro shn10   spr.Shine10
#macro shn12   spr.Shine12
#macro shn16   spr.Shine16
#macro shn20   spr.Shine20
#macro shn24   spr.Shine24
#macro shn64   spr.Shine64
#macro shnHurt spr.ShineHurt
#macro shnSnow spr.ShineSnow

#macro save_data global.save
#macro save_auto global.save_auto
#macro save_path "save.sav"

#macro area_campfire     0
#macro area_desert       1
#macro area_sewers       2
#macro area_scrapyards   3
#macro area_caves        4
#macro area_city         5
#macro area_labs         6
#macro area_palace       7
#macro area_vault        100
#macro area_oasis        101
#macro area_pizza_sewers 102
#macro area_mansion      103
#macro area_cursed_caves 104
#macro area_jungle       105
#macro area_hq           106
#macro area_crib         107

#macro infinity
	/*
		Infinity
		!!! Not supported by some functions in GMS1 versions, like 'min' and 'max'
	*/
	
	1/0
	
#macro game_scale_nonsync
	/*
		The local screen's pixel scale
	*/
	
	game_screen_get_width_nonsync() / game_width
	
#define ntte_init(_ref)
	/*
		Called by NT:TE mods from their 'init' script to run general setup code
	*/
	
	var	_type = _ref[0],
		_name = _ref[1];
		
	 // Set Global Variables:
	mod_variable_set(_type, _name, "scr",       scr);
	mod_variable_set(_type, _name, "obj",       obj);
	mod_variable_set(_type, _name, "spr",       spr);
	mod_variable_set(_type, _name, "snd",       snd);
	mod_variable_set(_type, _name, "debug_lag", false);
	mod_variable_set(_type, _name, "ntte_vars", ntte_vars);
	mod_variable_set(_type, _name, "epsilon",   global.epsilon);
	mod_variable_set(_type, _name, "mod_type",  _type);
	
	 // Bind Object Setup Scripts:
	var _list = [];
	for(var _objectIndex = array_length(global.bind_setup_object_list) - 1; _objectIndex >= 0; _objectIndex--){
		if(mod_script_exists(_type, _name, "ntte_setup_" + object_get_name(_objectIndex))){
			array_push(_list, ntte_bind_setup(script_ref_create_ext(_type, _name, "ntte_setup_" + object_get_name(_objectIndex)), _objectIndex));
		}
	}
	global.bind_setup[? _name + "." + _type] = _list;
	
	 // Add to Mod List:
	if(_type in ntte_mods){
		var _list = lq_get(ntte_mods, _type);
		if(array_find_index(_list, _name) < 0){
			array_push(_list, _name);
		}
		
		 // Compile NT:TE Script References:
		if((_name + "." + _type) != "ntte.mod"){
			var _modList = [];
			for(var i = 0; i < lq_size(ntte_mods); i++){
				var _modType = lq_get_key(ntte_mods, i);
				with(lq_get_value(ntte_mods, i)){
					array_push(_modList, _modType + ":" + self);
				}
			}
			for(var i = lq_size(ntte_mods_call) - 1; i >= 0; i--){
				if(mod_script_exists(_type, _name, "ntte_" + lq_get_key(ntte_mods_call, i))){
					var	_refAdd  = [_type, _name],
						_refList = lq_get_value(ntte_mods_call, i);
						
					 // Ensure Consistency Between Mod Reloads:
					for(var j = 0; j < array_length(_refList); j++){
						var _refCur = _refList[j];
						if(array_find_index(_modList, array_join(_refAdd, ":")) < array_find_index(_modList, array_join(_refCur, ":"))){
							_refList[j] = _refAdd;
							_refAdd     = _refCur;
						}
					}
					
					 // Add:
					array_push(_refList, _refAdd);
				}
			}
		}
	}
	
	 // Mod-Specific:
	switch(_type){
		
		case "race":
			
			 // Loadout Fix:
			with(Loadout){
				instance_destroy();
				with(loadbutton){
					instance_destroy();
				}
			}
			
			break;
			
		case "weapon":
			
			 // Weapon Sprite Setup:
			if(fork()){
				wait 0;
				
				var _spr = mod_variable_get(_type, _name, "sprWep");
				
				if(is_real(_spr) && sprite_exists(_spr)){
					 // Wait for Sprite to Load:
					var	_waitMax = 90,
						_waitBox = [sprite_get_bbox_left(_spr), sprite_get_bbox_top(_spr), sprite_get_bbox_right(_spr), sprite_get_bbox_bottom(_spr)];
						
					while(_waitMax-- > 0 && array_equals(_waitBox, [sprite_get_bbox_left(_spr), sprite_get_bbox_top(_spr), sprite_get_bbox_right(_spr), sprite_get_bbox_bottom(_spr)])){
						wait 0;
					}
					
					 // Locked Weapons:
					if(mod_variable_get(_type, _name, "sprWepLocked") == sprTemp){
						var	_sprX = sprite_get_xoffset(_spr) + 1,
							_sprY = sprite_get_yoffset(_spr) + 1;
							
						with(surface_setup("sprWepLocked", sprite_get_width(_spr) + 2, sprite_get_height(_spr) + 2, 1)){
							surface_set_target(surf);
							draw_clear_alpha(c_black, 0);
							
							with(UberCont){
								 // Outline:
								draw_set_fog(true, c_white, 0, 0);
								for(var _d = 0; _d < 360; _d += 90){
									draw_sprite(_spr, 1, _sprX + dcos(_d), _sprY + dsin(_d));
								}
								
								 // Main:
								draw_set_fog(true, c_black, 0, 0);
								draw_sprite(_spr, 1, _sprX, _sprY);
								draw_set_fog(false, 0, 0, 0);
							}
							
							 // Done:
							surface_reset_target();
							surface_save(surf, name + ".png");
							mod_variable_set(_type, _name, "sprWepLocked", sprite_add_weapon(name + ".png", _sprX, _sprY));
							free = true;
						}
					}
					
					 // Manually Split Bat Disc Sprites:
					var _list = mod_variable_get(_type, _name, "sprWepImage");
					if(is_array(_list) && !array_length(_list)){
						var	_sprX = sprite_get_xoffset(_spr),
							_sprY = sprite_get_yoffset(_spr);
							
						with(surface_setup("sprWepImage", sprite_get_width(_spr), sprite_get_height(_spr), 1)){
							surface_set_target(surf);
							
							 // Load Each Frame as a Weapon Sprite:
							for(var i = 0; i < sprite_get_number(_spr); i++){
								draw_clear_alpha(c_black, 0);
								with(UberCont){
									draw_sprite(_spr, i, _sprX, _sprY);
								}
								surface_save(surf, name + ".png");
								array_push(_list, sprite_add_weapon(name + ".png", _sprX, _sprY));
							}
							
							 // Done:
							surface_reset_target();
							sprite_delete(_spr);
							free = true;
						}
						
						mod_variable_set(_type, _name, "sprWep", _list[array_length(_list) - 1]);
					}
				}
				
				exit;
			}
			
			break;
			
	}
	
#define ntte_cleanup(_ref)
	/*
		Called by NT:TE mods from their 'cleanup' script to execute general unload code
	*/
	
	var	_type = _ref[0],
		_name = _ref[1];
		
	 // Remove NT:TE Script References:
	for(var i = lq_size(ntte_mods_call) - 1; i >= 0; i--){
		var	_list    = lq_get_value(ntte_mods_call, i),
			_listNew = [];
			
		with(_list){
			if(self[0] != _type || self[1] != _name){
				array_push(_listNew, self);
			}
		}
		
		if(!array_equals(_list, _listNew)){
			lq_set(ntte_mods_call, lq_get_key(ntte_mods_call, i), _listNew);
		}
	}
	
	 // Unbind Scripts:
	var _bindKey = _name + ":" + _type;
	if(ds_map_exists(global.bind, _bindKey)){
		global.bind_hold[? _bindKey] = [];
		with(global.bind[? _bindKey]){
			with(id){
				script = [];
				array_push(global.bind_hold[? _bindKey], self);
			}
		}
		ds_map_delete(global.bind, _bindKey);
	}
	
	 // Unbind Object Setup Scripts:
	var _bindKey = _name + "." + _type;
	if(ds_map_exists(global.bind_setup, _bindKey)){
		with(global.bind_setup[? _bindKey]){
			ntte_unbind(self);
		}
		ds_map_delete(global.bind_setup, _bindKey);
	}
	
	 // Race Mod Loadout Fix:
	if(_type == "race"){
		with(Loadout){
			instance_destroy();
			with(loadbutton){
				instance_destroy();
			}
		}
	}
	
#define ntte_save()
	/*
		Sends NT:TE's save data to the save file
	*/
	
	string_save(json_encode(save_data), save_path);
	
#define save_get(_name, _default)
	/*
		Returns the value stored at the given name in NTTE's save file
		Returns the given default value if nothing was found
		
		Ex:
			save_get("option:shaders")
			save_get("stat:pet:Baby.examplepet.mod:found")
	*/
	
	var	_path = string_split(_name, ":"),
		_save = save_data;
		
	with(_path){
		if(self not in _save){
			return _default;
		}
		_save = lq_get(_save, self);
	}
	
	return _save;
	
#define save_set(_name, _value)
	/*
		Stores the given value at the given name in NTTE's save file
		
		Ex:
			save_set("stat:time", save_get("stat:time") + 1)
			save_set("unlock:coolWeapon", true)
	*/
	
	var	_path = string_split(_name, ":"),
		_save = save_data;
		
	with(array_slice(_path, 0, array_length(_path) - 1)){
		if(!is_object(lq_get(_save, self))){
			lq_set(_save, self, {});
		}
		_save = lq_get(_save, self);
	}
	
	lq_set(_save, _path[array_length(_path) - 1], _value);
	
#define option_get(_name)
	/*
		Returns the value associated with a given option's name, which may be altered from the raw value for simpler usage
		Returns 1 if nothing was found
		
		Ex:
			option_get("shaders")
	*/
	
	var _value = save_get("option:" + _name, 1);
	
	 // Type-Specific Conditions:
	var _split = string_split(_name, ":");
	switch(_split[0]){
		case "intros": // Auto Intros
			if(_value >= 2){
				_value = (UberCont.opt_bossintros == true);
			}
			break;
			
		case "outline": // Auto Outlines
			if(_value >= 2){
				var _local = player_find_local_nonsync();
				_value = (
					player_is_active(_local)
					? player_get_outlines(_local)
					: false
				);
			}
			break;
			
		case "quality": // Surface Quality
			_value = lerp(1/3, game_scale_nonsync, _value);
			break;
	}
	
	return _value;
	
#define option_set(_name, _value)
	/*
		Sets the given option to the given value
		
		Ex:
			option_set("shaders", false)
	*/
	
	save_set("option:" + _name, _value);
	
#define stat_get(_name)
	/*
		Returns the value associated with a given stat's name
		Returns 0 if nothing was found
		
		Ex:
			stat_get("time")
	*/
	
	var _default = 0;
	
	 // Old Stat Names:
	switch(_name){
		case "race:parrot:best:area" : _default = stat_get("race:parrot:bestArea"); break;
		case "race:parrot:best:kill" : _default = stat_get("race:parrot:bestKill"); break;
		
		default:
			if(string_pos("found:", _name) == 1){
				_default = unlock_get(string_replace(_name, ":", "(") + ")");
			}
	}
	
	return save_get("stat:" + _name, _default);
	
#define stat_set(_name, _value)
	/*
		Sets the given stat to the given value
		
		Ex:
			stat_set("time", stat_get("time") + 1)
	*/
	
	save_set("stat:" + _name, _value);
	
#define unlock_get(_name)
	/*
		Returns the value associated with a given unlock's name
		Returns 'false' if nothing was found
		
		Ex:
			unlock_get("race:parrot")
	*/
	
	var _default = false;
	
	 // Old Unlock Names:
	switch(_name){
		case "race:parrot"         : _default = unlock_get("parrot");     break;
		case "skin:parrot:1"       : _default = unlock_get("parrotB");    break;
		case "pack:coast"          : _default = unlock_get("coastWep");   break;
		case "pack:oasis"          : _default = unlock_get("oasisWep");   break;
		case "pack:trench"         : _default = unlock_get("trenchWep");  break;
		case "pack:lair"           : _default = unlock_get("lairWep");    break;
		case "crown:crime"         : _default = unlock_get("lairCrown");  break;
		case "loadout:crown:crime" : _default = unlock_get("crownCrime"); break;
		case "wep:trident"         : _default = unlock_get("trident");    break;
		case "wep:scythe"          : _default = unlock_get("boneScythe"); break;
	}
	
	return save_get("unlock:" + _name, _default);
	
#define unlock_set(_name, _value)
	/*
		Sets the given unlock to the given value
		Plays unlock FX if the given value isn't already equal to the the unlock's value
		Returns 'true' if the unlock was set to a new value, 'false' otherwise
		
		Layout:
			pack    : Unlocks multiple things
			race    : Unlocks a character
			skin    : Unlocks a skin
			wep     : Unlocks a weapon
			crown   : Unlocks a crown (to appear in the crown vault)
			loadout : Unlocks an item on the loadout menu
			
		Ex:
			unlock_set("pack:lair",           true)
			unlock_set("race:parrot",         true)
			unlock_set("skin:red crystal",    true) // for skin mods
			unlock_set("skin:parrot:1",       true) // for race mods
			unlock_set("crown:crime",         false)
			unlock_set("loadout:crown:crime", false)
	*/
	
	if(unlock_get(_name) != _value){
		save_set("unlock:" + _name, _value);
		
		 // Unlock FX:
		if("unlock_get_name" in scr){
			var _unlockName = call(scr.unlock_get_name, _name);
			if(_unlockName != ""){
				var	_unlocked     = (!is_real(_value) || _value),
					_unlockText   = (_unlocked ? call(scr.unlock_get_text, _name) : "LOCKED"),
					_unlockSprite = -1,
					_unlockSound  = -1,
					_split        = string_split(_name, ":");
					
				 // Type-Specifics:
				if(array_length(_split) >= 2){
					switch(_split[0]){
						
						case "pack": // PACK
							
							sound_play(_unlocked ? sndGoldUnlock : sndCursedChest);
							
							break;
							
						case "race": // CHARACTER
							
							sound_play_pitchvol(_unlocked ? sndGoldUnlock : sndCursedChest, 0.9, 0.9);
							
							if(_unlocked){
								var _race = _split[1];
								_unlockSprite = mod_script_call("race", _race, "race_portrait", 0, 0);
								_unlockSound  = mod_script_call("race", _race, "race_menu_confirm");
							}
							
							break;
							
						case "skin": // SKIN
							
							sound_play(_unlocked ? sndMenuBSkin : sndMenuASkin);
							
							if(_unlocked){
								var	_race = "",
									_skin = _split[1];
								
								 // Race Mod:
								if(array_length(_split) > 2){
									_race         = _skin;
									_skin         = real(_split[2]);
									_unlockSprite = mod_script_call("race", _race, "race_portrait", 0, _skin);
								}
								
								 // Skin Mod:
								else if(mod_exists("skin", _skin)){
									_race         = mod_script_call("skin", _skin, "skin_race");
									_unlockSprite = mod_script_call("skin", _skin, "skin_portrait", 0);
								}
								
								 // Sound:
								_unlockSound = mod_script_call("race", _race, "race_menu_confirm");
							}
							
							break;
							
						case "loadout": // LOADOUT
							
							if(_split[1] == "wep"){
								sound_play(_unlocked ? sndGoldUnlock : sndCursedChest);
							}
							
							break;
							
					}
				}
				if(!is_real(_unlockSprite)) _unlockSprite = -1;
				if(!is_real(_unlockSound )) _unlockSound  = -1;
				
				 // Splat:
				with(call(scr.unlock_splat, _unlockName, _unlockText, _unlockSprite, _unlockSound)){
					 // Append "-SKIN" to GameOver Splat:
					if(array_length(_split) >= 2 && _split[1] == "skin"){
						with(_unlockSplat){
							nam[0] += "-SKIN";
						}
					}
					
					 // UNLOCKED:
					if(is_real(_value) && _value){
						nam[0] += " UNLOCKED";
					}
				}
			}
		}
		
		return true;
	}
	
	return false;
	
#define surface_setup(_name, _w, _h, _scale)
	/*
		Assigns a surface to the given name and stores it in 'global.surf' for future calls
		Automatically recreates the surface it doesn't exist or match the given width/height
		Destroys the surface if it hasn't been used for 30 frames, to free up memory
		Returns a LWO containing the surface itself and relevant vars
		
		Args:
			name  - The name used to store & retrieve the shader
			w, h  - The width/height of the surface
			        Use 'null' to not update the surface's width/height
			scale - The scale or quality of the surface
			        Use 'null' to not update the surface's scale
			
		Vars:
			name  - The name used to store & retrieve the surface
			surf  - The surface itself
			time  - # of frames until the surface is destroyed, not counting when the game is paused
			        Is set to 30 frames by default, set -1 to disable the timer
			free  - Set to 'true' if you aren't going to use this surface anymore (removes it from the list when 'time' hits 0)
			reset - Is set to 'true' when the surface is created or the game pauses
			scale - The scale or quality of the surface
			w, h  - The drawing width/height of the surface
			x, y  - The drawing position of the surface, you can set this manually
			
		Ex:
			with(surface_setup("Test", game_width, game_height, game_scale_nonsync)){
				x = view_xview_nonsync;
				y = view_yview_nonsync;
				
				 // Setup:
				if(reset){
					reset = false;
					surface_set_target(surf);
					draw_clear_alpha(c_black, 0);
					draw_circle((w / 2) * scale, (h / 2) * scale, 50 * scale, false);
					surface_reset_target();
				}
				
				 // Draw Surface:
				draw_surface_scale(surf, x, y, 1 / scale);
			}
	*/
	
	 // Retrieve Surface:
	if(!mod_variable_exists("mod", mod_current, "surf")){
		global.surf = ds_map_create();
	}
	var _surf = global.surf[? _name];
	
	 // Initialize Surface:
	if(_surf == undefined){
		_surf = {
			"name"  : _name,
			"surf"  : -1,
			"time"  : 0,
			"reset" : false,
			"free"  : false,
			"scale" : 1,
			"w"     : 1,
			"h"     : 1,
			"x"     : 0,
			"y"     : 0
		};
		global.surf[? _name] = _surf;
		
		 // Auto-Management:
		if(fork()){
			with(_surf){
				while(true){
					 // Deactivate Unused Surfaces:
					if((time > 0 || free) && --time <= 0){
						time = 0;
						surface_destroy(surf);
						
						 // Remove From List:
						if(free){
							ds_map_delete(global.surf, name);
							break;
						}
					}
					
					 // Game Paused:
					else for(var i = 0; i < maxp; i++){
						if(button_pressed(i, "paus")){
							reset = true;
							break;
						}
					}
					
					wait 0;
				}
			}
			exit;
		}
	}
	
	 // Surface Setup:
	with(_surf){
		if(is_real(_w    )) w     = _w;
		if(is_real(_h    )) h     = _h;
		if(is_real(_scale)) scale = _scale;
		
		 // Create / Resize Surface:
		if(
			!surface_exists(surf)
			|| surface_get_width(surf)  != max(1, w * scale)
			|| surface_get_height(surf) != max(1, h * scale)
		){
			surface_destroy(surf);
			surf = surface_create(max(1, w * scale), max(1, h * scale));
			reset = true;
		}
		
		 // Active For 30 Frames:
		if(time >= 0){
			time = max(time, 30);
		}
	}
	
	return _surf;
	
#define shader_setup(_name, _texture, _args)
	/*
		Performs general and shader-specific setup code, and enables the given shader
		Returns 'true' if the shader exists and was enabled for drawing, 'false' otherwise
		Use 'shader_add()' to initialize the shader before calling this script
		
		Args:
			name    - The name used to store & retrieve the shader
			texture - The texture to stage for drawing with the shader
			args    - An array of arguments for shader-specific setup
			
		Ex:
			if(shader_setup("Charm", sprite_get_texture(_spr, _img), [])){
				draw_sprite(_spr, _img, x, y);
				shader_reset();
			}
	*/
	
	if(mod_variable_exists("mod", mod_current, "shad") && ds_map_exists(global.shad, _name)){
		if(global.shad_active == ""){
			global.shad_active = _name;
		}
		with(global.shad[? _name]){
			if(shad != -1){
				 // Enable Shader & Stage Texture:
				shader_set(shad);
				texture_set_stage(0, _texture);
				
				 // Matrix:
				shader_set_vertex_constant_f(0, matrix_multiply(matrix_multiply(matrix_get(matrix_world), matrix_get(matrix_view)), matrix_get(matrix_projection)));
				
				 // Shader-Specific:
				switch(name){
					case "Charm":
						var	_w = _args[0],
							_h = _args[1];
							
						shader_set_fragment_constant_f(0, [1 / _w, 1 / _h]);
						break;
						
					case "SludgePool":
						var	_w     = _args[0],
							_h     = _args[1],
							_color = _args[2];
							
						shader_set_fragment_constant_f(0, [1 / _w, 1 / _h]);
						shader_set_fragment_constant_f(1, [color_get_red(_color) / 255, color_get_green(_color) / 255, color_get_blue(_color) / 255]);
						break;
						
					case "Unblend":
						var _blendNum = _args[0];
						
						shader_set_fragment_constant_f(0, [1 / power(2, _blendNum)]);
						break;
				}
				
				return true;
			}
		}
	}
	
	return false;
	
#define shader_add(_name, _vertex, _fragment)
	/*
		Initializes and stores a shader in the global shader list
		To prevent crashes, the shader is not created until the 'Menu' object no longer exists and the player has shaders enabled in NTTE's options
		Returns a LWO containing the shader itself and relevant vars
		
		Args:
			name     - The name used to store & retrieve the shader
			vertex   - The shader's vertex code
			fragment - The shader's fragment code
			
		Vars:
			name - The name used to store & retrieve the shader
			shad - The shader itself
			vert - The shader's vertex code
			frag - The shader's fragment code
			
		Ex:
			shader_add("Charm", "VERTEX SHADER CODE", "FRAGMENT SHADER CODE");
	*/
	
	 // Retrieve Shader:
	if(!mod_variable_exists("mod", mod_current, "shad")){
		global.shad = ds_map_create();
	}
	var _shad = global.shad[? _name];
	
	 // Initialize Shader:
	if(_shad == undefined){
		var _beta = false;
		
		 // Partial Beta Fix:
		try{
			if(!null){
				_beta = true;
			}
		}
		catch(_error){}
		
		 // Add:
		_shad = {
			"name" : _name,
			"shad" : -1,
			"vert" : _vertex,
			"frag" : _fragment
		};
		global.shad[? _name] = _shad;
		
		 // Auto-Management:
		if(fork()){
			with(_shad){
				while(true){
					 // Create Shaders:
					if(option_get("shaders") && (!_beta || (global.shad_active == name && !instance_exists(Menu)))){
						if(shad == -1 && !instance_exists(Menu)){
							try{
								// GMS2
								shad = script_execute(
									shader_create,
									string_replace_all(string_replace_all(vert, "matrix_world_view_projection;", "_gm_Matrices[5];"), "matrix_world_view_projection", "transpose(_gm_Matrices[4])"),
									frag,
									shader_kind_hlsl
								);
							}
							catch(_error){
								// GMS1
								shad = shader_create(vert, frag);
							}
						}
					}
					
					 // Shaders Disabled:
					else{
						if(shad != -1){
							shader_destroy(shad);
							shad = -1;
						}
						if(global.shad_active == name){
							global.shad_active = "";
						}
					}
					
					wait 0;
				}
			}
			exit;
		}
	}
	
	 // Shader Reset:
	else with(_shad){
		if(shad != -1){
			shader_destroy(shad);
			shad = -1;
		}
		vert = _vertex;
		frag = _fragment;
	}
	
	return _shad;
	
#define script_bind(_modRef, _scriptObj, _scriptRef, _depth, _visible)
	/*
		Binds the given script to the given event
		Automatically ensures that the script object always exists, and deletes it when the parent mod is unloaded
		
		Args:
			scriptObj - The event type: CustomStep, CustomBeginStep, CustomEndStep, CustomDraw
			scriptRef - The script's reference to call
			depth     - The script's default depth
			visible   - The script's default visibility, basically "will this event run all the time"
			
		Ex:
			script_bind(script_ref_create(0), CustomDraw, script_ref_create(draw_thing, true), -8, true)
	*/
	
	var	_modType = _modRef[0],
		_modName = _modRef[1],
		_bindKey = _modName + ":" + _modType,
		_bind    = {
			"object"  : _scriptObj,
			"script"  : _scriptRef,
			"depth"   : _depth,
			"visible" : _visible,
			"id"      : noone
		};
		
	 // Storage Setup:
	if(!ds_map_exists(global.bind, _bindKey)){
		global.bind[? _bindKey] = [];
	}
	
	 // Controller Setup / Retrieval:
	var	_bindHold    = (ds_map_exists(global.bind_hold, _bindKey) ? global.bind_hold[? _bindKey] : []),
		_bindHoldPos = array_length(global.bind[? _bindKey]);
		
	if(_bindHoldPos >= 0 && _bindHoldPos < array_length(_bindHold) && instance_exists(_bindHold[_bindHoldPos])){
		_bind.id = _bindHold[_bindHoldPos];
	}
	else{
		_bind.id = instance_create(0, 0, _bind.object);
		with(_bind.id){
			depth      = _bind.depth;
			visible    = _bind.visible;
			persistent = true;
		}
	}
	with(_bind.id){
		script = _bind.script;
	}
	
	 // Store:
	array_push(global.bind[? _bindKey], _bind);
	
	return _bind;
	
#define ntte_bind_step(_scriptRef)
	/*
		
	*/
	
	_scriptRef = array_clone(_scriptRef);
	
	
	return _scriptRef;
	
#define ntte_bind_begin_step(_scriptRef)
	/*
		
	*/
	
	_scriptRef = array_clone(_scriptRef);
	
	
	return _scriptRef;
	
#define ntte_bind_end_step(_scriptRef)
	/*
		
	*/
	
	_scriptRef = array_clone(_scriptRef);
	
	
	return _scriptRef;
	
#define ntte_bind_draw(_scriptRef, _depth)
	/*
		
	*/
	
	_scriptRef = array_clone(_scriptRef);
	
	
	return _scriptRef;
	
#define ntte_bind_setup(_scriptRef, _obj)
	/*
		Binds the given script reference to a setup event for the given object
		Calls the script with an array of newly created instances of that object
		The array can be empty, as other setup scripts may destroy the instances
	*/
	
	_scriptRef = array_clone(_scriptRef);
	
	var	_objectRefList   = global.bind_setup_object_list,
		_objectChildList = array_create(array_length(_objectRefList), noone);
		
	 // Link Objects to Their Children:
	for(var i = array_length(_objectChildList) - 1; i >= 0; i--){
		var _parent = object_get_parent(i);
		if(object_exists(_parent)){
			var _childList = _objectChildList[_parent];
			if(_childList == noone){
				_childList                = [];
				_objectChildList[_parent] = _childList;
			}
			array_push(_childList, i);
		}
	}
	
	 // Link Script Reference to Object(s) & Their Children:
	var	_objectList    = (is_array(_obj) ? array_clone(_obj) : [_obj]),
		_objectListMax = array_length(_objectList);
		
	for(var i = 0; i < _objectListMax; i++){
		var	_object    = _objectList[i],
			_childList = _objectChildList[_object],
			_refList   = _objectRefList[_object];
			
		 // Add Children to List:
		if(_childList != noone){
			with(_childList){
				if(array_find_index(_objectList, self) < 0){
					array_push(_objectList, self);
					_objectListMax++;
				}
			}
		}
		
		 // Store Script Reference:
		if(_refList == noone){
			_refList                = [];
			_objectRefList[_object] = _refList;
		}
		array_push(_refList, _scriptRef);
	}
	
	return _scriptRef;
	
#define ntte_unbind(_ref)
	/*
		Unbinds the given NT:TE script reference from its event
	*/
	
	var _objectIndex = 0;
	
	with(global.bind_setup_object_list){
		if(self != noone){
			var _refList = call(scr.array_delete_value, self, _ref);
			global.bind_setup_object_list[_objectIndex] = (
				array_length(_refList)
				? _refList
				: noone
			);
		}
		_objectIndex++;
	}
	
#define sprite /// sprite(_path, _img, _x, _y, _shine = shnNone)
	var _path = argument[0], _img = argument[1], _x = argument[2], _y = argument[3];
var _shine = argument_count > 4 ? argument[4] : shnNone;
	
	spr_load = [[spr, 0]];
	
	return {
		path  : "sprites/" + _path,
		img   : _img,
		x     : _x,
		y     : _y,
		ext   : "png",
		mask  : [],
		shine : _shine
	};
	
#define trace_error(_error)
	trace(_error);
	trace_color(" ^ Screenshot that error and post it on NT:TE's itch.io page, thanks!", c_yellow);
	
#define game_start
	 // Autosave:
	if(save_auto){
		ntte_save();
	}
	
	 // Reset Active Shader (Beta Fix):
	global.shad_active = "";
	
#define step
	if(lag) trace_time();
	
	 // Sprite Loading:
	if(array_length(spr_load)){
		repeat(spr_load_num){
			while(array_length(spr_load)){
				var	_num   = array_length(spr_load) - 1,
					_load  = null,
					_list  = spr_load[_num, 0],
					_index = spr_load[_num, 1];
					
				spr_load[_num, 1]++;
				
				 // Grab Value:
				if(is_array(_list)){
					if(_index < array_length(_list)){
						_load = _list[_index];
					}
				}
				else if(is_object(_list)){
					if(_index < lq_size(_list)){
						_load = lq_get_value(_list, _index);
					}
				}
				else if(ds_map_valid(_list)){
					if(_index < ds_map_size(_list)){
						_load = ds_map_values(_list)[_index];
					}
				}
				
				 // Process Value:
				if(_load != undefined){
					 // Load Sprites:
					if(is_object(_load) && "path" in _load){
						var	_spr    = mskNone,
							_img    = lq_defget(_load, "img",   1),
							_x      = lq_defget(_load, "x",     0),
							_y      = lq_defget(_load, "y",     0),
							_ext    = lq_defget(_load, "ext",   "png"),
							_mask   = lq_defget(_load, "mask",  []),
							_shine  = lq_defget(_load, "shine", shnNone),
							_path   = _load.path + "." + _ext;
							
						if(fork()){
							switch(_shine){
								case shnWep: // Basic Shine
									_spr = sprite_add_weapon(_path, _x, _y);
									break;
									
								default:
									_spr = sprite_add(_path, _img, _x, _y);
									
									 // Semi-Manual Shine (sprite_add_weapon is wack with taller sprites)
									if(_shine != shnNone && sprite_exists(_shine)){
										 // Wait for Sprite to Load:
										var	_waitMax = 90,
											_waitBox = [sprite_get_bbox_left(_spr), sprite_get_bbox_top(_spr), sprite_get_bbox_right(_spr), sprite_get_bbox_bottom(_spr)];
											
										while(_waitMax-- > 0 && array_equals(_waitBox, [sprite_get_bbox_left(_spr), sprite_get_bbox_top(_spr), sprite_get_bbox_right(_spr), sprite_get_bbox_bottom(_spr)])){
											wait 0;
										}
										
										 // Add Shine:
										var _lastSpr = _spr;
										_spr = sprite_shine(_spr, _shine);
										sprite_delete(_lastSpr);
									}
							}
							
							 // Store Sprite:
							if(is_array(_list)){
								_list[_index] = _spr;
							}
							else if(is_object(_list)){
								lq_set(_list, lq_get_key(_list, _index), _spr);
							}
							else if(ds_map_valid(_list)){
								_list[? ds_map_keys(_list)[_index]] = _spr;
							}
							
							 // Precise Hitboxes:
							if(array_length(_mask) > 0){
								 // Wait for Sprite to Load:
								var	_waitMax = 90,
									_waitBox = [sprite_get_bbox_left(_spr), sprite_get_bbox_top(_spr), sprite_get_bbox_right(_spr), sprite_get_bbox_bottom(_spr)];
									
								while(_waitMax-- > 0 && array_equals(_waitBox, [sprite_get_bbox_left(_spr), sprite_get_bbox_top(_spr), sprite_get_bbox_right(_spr), sprite_get_bbox_bottom(_spr)])){
									wait 0;
								}
								
								 // Collision Time:
								while(array_length(_mask) < 9){
									array_push(_mask, 0);
								}
								sprite_collision_mask(_spr, _mask[0], _mask[1], _mask[2], _mask[3], _mask[4], _mask[5], _mask[7], _mask[8]);
							}
							
							exit;
						}
						
						break;
					}
					
					 // Search Deeper:
					else array_push(spr_load, [_load, 0]);
				}
				
				 // Go Back:
				else spr_load = array_slice(spr_load, 0, _num);
			}
		}
	}
	
	 // Ensure Script Bindings Exist:
	with(ds_map_values(global.bind)){
		with(self){
			if(!instance_exists(id)){
				id = instance_create(0, 0, object);
				with(id){
					script     = other.script;
					depth      = other.depth;
					visible    = other.visible;
					persistent = true;
				}
			}
		}
	}
	
	 // Autosave (Return to Character Select):
	if(instance_exists(Menu) && save_auto){
		with(instances_matching(Menu, "ntte_autosave", null)){
			ntte_autosave = true;
			ntte_save();
		}
	}
	
	if(lag) trace_time(mod_current + "_step");
	
#define draw_pause
	 // Remind Player:
	if(option_get("reminders")){
		var	_vx       = view_xview_nonsync,
			_vy       = view_yview_nonsync,
			_gw       = game_width,
			_gh       = game_height,
			_timeTick = 1;
			
		with(global.remind){
			if(active){
				var	_x = (_gw / 2),
					_y = (_gh / 2) - 40;
					
				 // Reminding:
				if(instance_exists(object)){
					_x += x;
					_y += y;
					
					if(time > 0){
						time -= _timeTick * current_time_scale;
						_timeTick = 0;
						
						 // Done:
						if(time <= 0){
							active = false;
							
							 // Text:
							text_inst = instance_create(_x, _y, PopupText);
							with(text_inst){
								text     = other.text;
								friction = 0.1;
							}
						}
					}
				}
				
				 // Lead Player to Button:
				else{
					time = 20;
					
					 // Settings Screen:
					if(instance_exists(OptionMenuButton)){
						_x -= 38;
						switch(object){
							case VisualsMenuButton:
								_y += 24;
								break;
								
							case GameMenuButton:
								_y += 48;
								break;
								
							case ControlMenuButton:
								_x -= 26;
								_y += 72;
								break;
						}
					}
					
					 // Main Pause Screen:
					else if(instance_number(PauseButton) > 2){
						var _break = false;
						with(PauseButton){
							if(alarm_get(0) > 0){
								_break = true;
							}
						}
						if(_break) break;
						
						_x = game_width - 124;
						_y = game_height - 78;
					}
					
					else continue;
				}
				
				 // Draw Icon:
				with(other){
					draw_sprite(sprNew, 0, _vx + _x, _vy + _y + sin(current_frame / 10));
				}
			}
			
			 // Draw Text:
			if(instance_exists(text_inst)){
				_timeTick = 0.5;
				
				draw_set_font(fntM);
				draw_set_halign(fa_center);
				draw_set_valign(fa_top);
				with(instances_matching(text_inst, "visible", true)){
					draw_text_nt(_vx + x, _vy + y, text);
				}
			}
		}
	}
	
#define sprite_shine(_spr, _shine)
	/*
		Returns a new sprite made by overlaying the given shine sprite on top of the other given normal sprite
	*/
	
	var	_sprX   = sprite_get_xoffset(_spr),
		_sprY   = sprite_get_yoffset(_spr),
		_sprW   = sprite_get_width(_spr),
		_sprH   = sprite_get_height(_spr),
		_sprImg = max(sprite_get_number(_spr), sprite_get_number(_shine)),
		_shineW = sprite_get_width(_shine),
		_shineH = sprite_get_height(_shine);
		
	_sprX += max(0, floor((_shineW - _sprW) / 2));
	_sprY += max(0, floor((_shineH - _sprH) / 2));
	
	_sprW = max(_sprW, _shineW);
	_sprH = max(_sprH, _shineH);
	
	with(surface_setup("sprShine", _sprW * _sprImg, _sprH, 1)){
		surface_set_target(surf);
		draw_clear_alpha(c_black, 0);
		
		with(UberCont){
			for(var _img = 0; _img < _sprImg; _img++){
				var	_x = _sprW * _img,
					_y = 0;
					
				 // Normal Sprite:
				draw_sprite(_spr, _img, _x + _sprX, _y + _sprY);
				
				 // Overlay Shine:
				draw_set_color_write_enable(true, true, true, false);
				draw_sprite_stretched(_shine, _img, _x, _y, _sprW, _sprH);
				draw_set_color_write_enable(true, true, true, true);
			}
		}
		
		 // Done:
		surface_reset_target();
		free = true;
		
		 // Add Sprite:
		surface_save(surf, name + ".png");
		return sprite_add(name + ".png", _sprImg, _sprX, _sprY);
	}
	
#define merge_weapon_sprite(_wepSpriteList)
	/*
		Returns a sprite of slices from the given weapon sprites combined sequentially
	*/
	
	var	_mergeWepSpriteName = array_join(_wepSpriteList, ":"),
		_mergeWepSprite     = ds_map_find_value(spr.MergeWep, _mergeWepSpriteName);
		
	 // Initial Setup:
	if(_mergeWepSprite == undefined){
		var	_mergeStockSlice        = undefined,
			_mergeFrontSlice        = undefined,
			_mergeWepSpriteY1       =  infinity,
			_mergeWepSpriteY2       = -infinity,
			_mergeWepSpriteWidth    = 0,
			_mergeWepSpriteImageNum = 0,
			_mergeWepSpriteList     = ds_map_values(spr.MergeWep),
			_mergeWepSpriteKeyList  = ds_map_keys(spr.MergeWep);
			
		 // Unmerge Sprites:
		while(true){
			var _newWepSpriteList = [];
			with(_wepSpriteList){
				var _mergeWepSpriteIndex = array_find_index(_mergeWepSpriteList, self);
				if(_mergeWepSpriteIndex >= 0){
					with(string_split(_mergeWepSpriteKeyList[_mergeWepSpriteIndex], ":")){
						array_push(_newWepSpriteList, real(self));
					}
				}
				else array_push(_newWepSpriteList, self);
			}
			if(array_equals(_wepSpriteList, _newWepSpriteList)){
				break;
			}
			else{
				_wepSpriteList = _newWepSpriteList;
			}
		}
		
		 // Setup Sprite Slices:
		var	_wepSpriteNum   = 0,
			_wepSpriteCount = array_length(_wepSpriteList);
			
		with(_wepSpriteList){
			var	_wepSprite  = self,
				_mergeSlice = {
					"sprite_index"   : _wepSprite,
					"sprite_width"   : sprite_get_width(_wepSprite),
					"sprite_height"  : sprite_get_height(_wepSprite),
					"sprite_xoffset" : sprite_get_xoffset(_wepSprite),
					"sprite_yoffset" : sprite_get_yoffset(_wepSprite),
					"sprite_bbox_y1" : sprite_get_bbox_top(_wepSprite)        - sprite_get_yoffset(_wepSprite),
					"sprite_bbox_y2" : sprite_get_bbox_bottom(_wepSprite) + 1 - sprite_get_yoffset(_wepSprite),
					"image_number"   : sprite_get_number(_wepSprite),
					"x1"             : 0,
					"x2"             : 0,
					"next_slice"     : undefined
				};
				
			 // Manual Adjustments:
			switch(_wepSprite){
				case sprToxicBow:
					_mergeSlice.sprite_yoffset += 2;
					break;
					
				case sprSuperCrossbow:
				case sprGatlingSlugger:
					_mergeSlice.sprite_yoffset += 1;
					break;
					
				case sprAutoShotgun:
				case sprPartyGun:
					_mergeSlice.sprite_yoffset -= 1;
					break;
					
				case mskNone:
					_mergeSlice.sprite_height  = 1;
					_mergeSlice.sprite_yoffset = 0;
					_mergeSlice.sprite_bbox_y1 = infinity;
					_mergeSlice.sprite_bbox_y2 = infinity * ((_wepSpriteNum > 0) ? 1 : -1);
					_mergeSlice.x2             = 3;
					break;
			}
			
			 // Determine Slice Dimensions:
			if(_wepSprite != mskNone){
				var	_sliceX1 = sprite_get_bbox_left(_wepSprite) + 1,
					_sliceX3 = sprite_get_bbox_right(_wepSprite),
					_sliceX2 = round(lerp(_sliceX1, _sliceX3, 0.4));
					
				for(var _sliceSide = 0; _sliceSide <= 1; _sliceSide++){
					var _sliceX = 0;
					if(_wepSpriteNum == (_wepSpriteCount - 1) * _sliceSide){
						_sliceX = _mergeSlice.sprite_width * _sliceSide;
					}
					else{
						var _sliceAmount = (_wepSpriteNum / _wepSpriteCount) + (_sliceSide / min(2, _wepSpriteCount));
						_sliceX = ceil(lerp(
							lerp(
								_sliceX1,
								_sliceX2,
								clamp(2 * _sliceAmount, 0, 1)
							),
							_sliceX3,
							clamp(2 * (_sliceAmount - 0.5), 0, 1)
						));
					}
					lq_set(_mergeSlice, `x${_sliceSide + 1}`, _sliceX);
				}
			}
			
			 // Merged Sprite Dimensions:
			var _mergeSliceSpriteY1 = -_mergeSlice.sprite_yoffset,
				_mergeSliceSpriteY2 = _mergeSliceSpriteY1 + _mergeSlice.sprite_height;
				
			if(_mergeSliceSpriteY1 < _mergeWepSpriteY1) _mergeWepSpriteY1 = _mergeSliceSpriteY1;
			if(_mergeSliceSpriteY2 > _mergeWepSpriteY2) _mergeWepSpriteY2 = _mergeSliceSpriteY2;
			
			_mergeWepSpriteWidth += _mergeSlice.x2 - _mergeSlice.x1;
			
			 // Merged Sprite Frame Count:
			if(_mergeSlice.image_number > _mergeWepSpriteImageNum){
				_mergeWepSpriteImageNum = _mergeSlice.image_number;
			}
			
			 // Add to List:
			if(_mergeFrontSlice == undefined){
				_mergeStockSlice = _mergeSlice;
			}
			else{
				_mergeFrontSlice.next_slice = _mergeSlice;
			}
			_mergeFrontSlice = _mergeSlice;
			_wepSpriteNum++;
		}
		
		 // Create Merged Sprite:
		var	_mergeWepSpriteHeight  = _mergeWepSpriteY2 - _mergeWepSpriteY1,
			_mergeWepSpriteXOffset = _mergeStockSlice.sprite_xoffset,
			_mergeWepSpriteYOffset = -_mergeWepSpriteY1;
			
		with(surface_setup(
			"sprMerge",
			_mergeWepSpriteWidth * _mergeWepSpriteImageNum,
			_mergeWepSpriteHeight,
			1
		)){
			free = true;
			
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			
			for(var _outline = 1; _outline >= 0; _outline--){
				for(var _mergeWepSpriteImage = 0; _mergeWepSpriteImage < _mergeWepSpriteImageNum; _mergeWepSpriteImage++){
					var	_slice        = _mergeStockSlice,
						_sliceXOffset = _mergeWepSpriteWidth * _mergeWepSpriteImage,
						_lastSlice    = undefined;
						
					while(_slice != undefined){
						var	_nextSlice = _slice.next_slice,
							_isFlash   = (_mergeWepSpriteImage == min(1, _mergeWepSpriteImageNum - 1)),
							_spr       = _slice.sprite_index,
							_img       = (_isFlash ? 1 : (_slice.image_number * (_mergeWepSpriteImage / _mergeWepSpriteImageNum))),
							_l         = _slice.x1,
							_r         = _slice.x2,
							_w         = _r - _l,
							_t         = 0,
							_h         = _slice.sprite_height,
							_x         = _sliceXOffset,
							_y         = _mergeWepSpriteYOffset - _slice.sprite_yoffset;
							
						with(UberCont){
							if(_outline == 1){
								if(!_isFlash){
									draw_set_fog(true, c_black, 0, 0);
								}
								if(_lastSlice != undefined){
									draw_sprite_part(_spr, _img, _l, _t, 1, ((_slice.sprite_bbox_y2 < _lastSlice.sprite_bbox_y2) ? ceil(_h / 2) : _h), _x - 1, _y);
								//	if(_slice.sprite_bbox_y1 <= _lastSlice.sprite_bbox_y1) draw_sprite_part(_spr, _img, _l, _t,                1,  ceil(_h / 2), _x - 1, _y);
								//	if(_slice.sprite_bbox_y2 >= _lastSlice.sprite_bbox_y2) draw_sprite_part(_spr, _img, _l, _t + ceil(_h / 2), 1, floor(_h / 2), _x - 1, _y + ceil(_h / 2));
								}
								if(_nextSlice != undefined){
									draw_sprite_part(_spr, _img, _r - 1, _t, 1, ((_slice.sprite_bbox_y2 <= _nextSlice.sprite_bbox_y2) ? ceil(_h / 2) : _h), _x + _w, _y);
								//	if(_slice.sprite_bbox_y1 < _nextSlice.sprite_bbox_y1) draw_sprite_part(_spr, _img, _r - 1, _t,                1,  ceil(_h / 2), _x + _w, _y);
								//	if(_slice.sprite_bbox_y2 > _nextSlice.sprite_bbox_y2) draw_sprite_part(_spr, _img, _r - 1, _t + ceil(_h / 2), 1, floor(_h / 2), _x + _w, _y + ceil(_h / 2));
								}
								if(!_isFlash){
									draw_set_fog(false, 0, 0, 0);
								}
							}
							else draw_sprite_part(_spr, _img, _l, _t, _w, _h, _x, _y);
						}
						
						_sliceXOffset += _w;
						
						_lastSlice = _slice;
						_slice     = _nextSlice;
					}
				}
			}
			
			surface_reset_target();
			
			 // Add Sprite:
			surface_save(surf, name + ".png");
			_mergeWepSprite = sprite_add(
				name + ".png",
				_mergeWepSpriteImageNum,
				_mergeWepSpriteXOffset,
				_mergeWepSpriteYOffset
			);
			
			 // Store Sprite:
			spr.MergeWep[? _mergeWepSpriteName] = _mergeWepSprite;
		}
	}
	
	return _mergeWepSprite;
	
#define merge_weapon_loadout_sprite(_wepLoadoutSpriteList)
	/*
		Returns a sprite of slices from the given weapon loadout sprites combined sequentially
		circular cut offset some amount towards 20 degrees 
	*/
	
	var	_mergeWepLoadoutSpriteName = array_join(_wepLoadoutSpriteList, ":"),
		_mergeWepLoadoutSprite     = ds_map_find_value(spr.MergeWepLoadout, _mergeWepLoadoutSpriteName);
		
	 // Initial Setup:
	if(_mergeWepLoadoutSprite == undefined){
		var	_loadoutSpriteAngle            = 15,
			_loadoutSpriteXFactor          = 1 / dcos(_loadoutSpriteAngle),
			_mergeStockSlice               = undefined,
			_mergeFrontSlice               = undefined,
			_mergeSliceXOffset             = 0,
			_mergeSliceYOffset             = 0,
			_mergeWepLoadoutSpriteX1       =  infinity,
			_mergeWepLoadoutSpriteY1       =  infinity,
			_mergeWepLoadoutSpriteX2       = -infinity,
			_mergeWepLoadoutSpriteY2       = -infinity,
			_mergeWepLoadoutSpriteImageNum = 0,
			_mergeWepLoadoutSpriteList     = ds_map_values(spr.MergeWepLoadout),
			_mergeWepLoadoutSpriteKeyList  = ds_map_keys(spr.MergeWepLoadout);
			
		 // Unmerge Sprites:
		while(true){
			var _newWepLoadoutSpriteList = [];
			with(_wepLoadoutSpriteList){
				var _mergeWepLoadoutSpriteIndex = array_find_index(_mergeWepLoadoutSpriteList, self);
				if(_mergeWepLoadoutSpriteIndex >= 0){
					with(string_split(_mergeWepLoadoutSpriteKeyList[_mergeWepLoadoutSpriteIndex], ":")){
						array_push(_newWepLoadoutSpriteList, real(self));
					}
				}
				else array_push(_newWepLoadoutSpriteList, self);
			}
			if(array_equals(_wepLoadoutSpriteList, _newWepLoadoutSpriteList)){
				break;
			}
			else{
				_wepLoadoutSpriteList = _newWepLoadoutSpriteList;
			}
		}
		
		 // Setup Sprite Slices:
		var	_wepLoadoutSpriteNum   = 0,
			_wepLoadoutSpriteCount = array_length(_wepLoadoutSpriteList);
			
		with(_wepLoadoutSpriteList){
			var	_wepLoadoutSprite = self,
				_mergeSlice       = {
					"sprite_index"   : _wepLoadoutSprite,
					"sprite_width"   : sprite_get_width(_wepLoadoutSprite),
					"sprite_height"  : sprite_get_height(_wepLoadoutSprite),
					"sprite_xoffset" : sprite_get_xoffset(_wepLoadoutSprite),
					"sprite_yoffset" : sprite_get_yoffset(_wepLoadoutSprite),
					"image_number"   : sprite_get_number(_wepLoadoutSprite),
					"sprite_length1" : 0,
					"sprite_length2" : 0,
					"length1"        : 0,
					"length2"        : 0,
					"next_slice"     : undefined
				};
				
			 // Determine Slice Dimensions:
			if(_wepLoadoutSprite != mskNone){
				var	_sliceDis1 = floor(((sprite_get_bbox_left(_mergeSlice.sprite_index)  + 2) - _mergeSlice.sprite_xoffset) * _loadoutSpriteXFactor) - 4,
					_sliceDis3 =  ceil(((sprite_get_bbox_right(_mergeSlice.sprite_index) - 1) - _mergeSlice.sprite_xoffset) * _loadoutSpriteXFactor) - 4,
					_sliceDis2 = /*round*/(lerp(_sliceDis1, _sliceDis3, 0.4));
					
				_mergeSlice.sprite_length1 = _sliceDis1;
				_mergeSlice.sprite_length2 = _sliceDis3;
				
				for(var _sliceSide = 0; _sliceSide <= 1; _sliceSide++){
					var _sliceDis = 0;
					if(_wepLoadoutSpriteNum == (_wepLoadoutSpriteCount - 1) * _sliceSide){
						_sliceDis = (
							(_sliceSide == 0)
							? _sliceDis1
							: _sliceDis3
						);
					}
					else{
						var _sliceAmount = (_wepLoadoutSpriteNum / _wepLoadoutSpriteCount) + (_sliceSide / min(2, _wepLoadoutSpriteCount));
						_sliceDis = /*ceil*/(lerp(
							lerp(
								_sliceDis1,
								_sliceDis2,
								clamp(2 * _sliceAmount, 0, 1)
							),
							_sliceDis3,
							clamp(2 * (_sliceAmount - 0.5), 0, 1)
						));
					}
					lq_set(_mergeSlice, `length${_sliceSide + 1}`, _sliceDis);
				}
			}
			else{
				_mergeSlice.sprite_width   = 1;
				_mergeSlice.sprite_height  = 1;
				_mergeSlice.sprite_xoffset = 0;
				_mergeSlice.sprite_yoffset = 0;
				_mergeSlice.length1        = -11;
				_mergeSlice.length2        = -5;
				_mergeSlice.sprite_length1 = _mergeSlice.length1;
				_mergeSlice.sprite_length2 = _mergeSlice.length2;
			}
			
			 // Merged Sprite Dimensions:
			var	_mergeSliceSpriteX1 =  ceil(_mergeSliceXOffset) - _mergeSlice.sprite_xoffset,
				_mergeSliceSpriteY1 = floor(_mergeSliceYOffset) - _mergeSlice.sprite_yoffset,
				_mergeSliceSpriteX2 = _mergeSliceSpriteX1 + _mergeSlice.sprite_width,
				_mergeSliceSpriteY2 = _mergeSliceSpriteY1 + _mergeSlice.sprite_height;
				
			if(_mergeSliceSpriteX1 < _mergeWepLoadoutSpriteX1) _mergeWepLoadoutSpriteX1 = _mergeSliceSpriteX1;
			if(_mergeSliceSpriteY1 < _mergeWepLoadoutSpriteY1) _mergeWepLoadoutSpriteY1 = _mergeSliceSpriteY1;
			if(_mergeSliceSpriteX2 > _mergeWepLoadoutSpriteX2) _mergeWepLoadoutSpriteX2 = _mergeSliceSpriteX2;
			if(_mergeSliceSpriteY2 > _mergeWepLoadoutSpriteY2) _mergeWepLoadoutSpriteY2 = _mergeSliceSpriteY2;
			
			_mergeSliceXOffset += lengthdir_x(_mergeSlice.length2 - _mergeSlice.length1, _loadoutSpriteAngle);
			_mergeSliceYOffset += lengthdir_y(_mergeSlice.length2 - _mergeSlice.length1, _loadoutSpriteAngle);
			
			 // Merged Sprite Frame Count:
			if(_mergeSlice.image_number > _mergeWepLoadoutSpriteImageNum){
				_mergeWepLoadoutSpriteImageNum = _mergeSlice.image_number;
			}
			
			 // Add to List:
			if(_mergeFrontSlice == undefined){
				_mergeStockSlice = _mergeSlice;
			}
			else{
				_mergeFrontSlice.next_slice = _mergeSlice;
			}
			_mergeFrontSlice = _mergeSlice;
			_wepLoadoutSpriteNum++;
		}
		
		 // Create Merged Sprite:
		var	_mergeWepLoadoutSpriteWidth   = _mergeWepLoadoutSpriteX2 - _mergeWepLoadoutSpriteX1,
			_mergeWepLoadoutSpriteHeight  = _mergeWepLoadoutSpriteY2 - _mergeWepLoadoutSpriteY1,
			_mergeWepLoadoutSpriteXOffset = -_mergeWepLoadoutSpriteX1,
			_mergeWepLoadoutSpriteYOffset = -_mergeWepLoadoutSpriteY1;
		
		with(surface_setup(
			"sprMergeLoadout",
			_mergeWepLoadoutSpriteWidth * _mergeWepLoadoutSpriteImageNum,
			_mergeWepLoadoutSpriteHeight,
			1
		)){
			free = true;
			
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			surface_reset_target();
			
			for(var _mergeWepLoadoutSpriteImage = 0; _mergeWepLoadoutSpriteImage < _mergeWepLoadoutSpriteImageNum; _mergeWepLoadoutSpriteImage++){
				var	_slice        = _mergeStockSlice,
					_sliceXOffset = _mergeWepLoadoutSpriteXOffset + lengthdir_x(_slice.length1, _loadoutSpriteAngle) + (_mergeWepLoadoutSpriteWidth * _mergeWepLoadoutSpriteImage),
					_sliceYOffset = _mergeWepLoadoutSpriteYOffset + lengthdir_y(_slice.length1, _loadoutSpriteAngle);
					
				while(_slice != undefined){
					var	_nextSlice = _slice.next_slice,
						_spr       = _slice.sprite_index,
						_sprImg    = _slice.image_number * (_mergeWepLoadoutSpriteImage / _mergeWepLoadoutSpriteImageNum),
						_sprX      = _slice.sprite_xoffset,
						_sprY      = _slice.sprite_yoffset;
						
					with(UberCont){
						var	_maskSurface  = surface_create(_slice.sprite_width, _slice.sprite_height),
							_sliceSurface = surface_create(_slice.sprite_width, _slice.sprite_height);
							
						 // Draw Sprite to Surface:
						surface_set_target(_sliceSurface);
						draw_clear_alpha(c_black, 0);
						switch(_spr){
							case sprGoldScrewdriverLoadout:
								draw_sprite_ext(_spr, _sprImg, _sprX, _sprY, 1, 1, _loadoutSpriteAngle - 45, c_white, 1);
								break;
								
							default:
								draw_sprite(_spr, _sprImg, _sprX, _sprY);
						}
						surface_reset_target();
						
						 // Trim Sprite's Head:
						if(_slice.length2 < _slice.sprite_length2){
							 // Create Trim Mask:
							surface_set_target(_maskSurface);
							draw_clear_alpha(c_black, 0);
							draw_circle(
								_sprX +  ceil(lengthdir_x(_slice.sprite_length2, _loadoutSpriteAngle)),
								_sprY + floor(lengthdir_y(_slice.sprite_length2, _loadoutSpriteAngle)),
								ceil(_slice.length2 - _slice.sprite_length2),
								false
							);
							draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
							draw_set_alpha(0.5);
							draw_circle(
								_sprX +  ceil(lengthdir_x(_slice.length2 - 10, _loadoutSpriteAngle)),
								_sprY + floor(lengthdir_y(_slice.length2 - 10, _loadoutSpriteAngle)),
								6 + 10,
								false
							);
							draw_set_alpha(1);
							draw_set_blend_mode(bm_normal);
							surface_reset_target();
							
							 // Trim:
							surface_set_target(_sliceSurface);
							draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
							draw_surface(_maskSurface, 0, 0);
							draw_set_blend_mode(bm_normal);
							surface_reset_target();
						}
						
						 // Trim Sprite's Back:
						if(_slice.length1 > _slice.sprite_length1){
							 // Create Trim Mask:
							surface_set_target(_maskSurface);
							draw_clear_alpha(c_black, 0);
							draw_circle(
								_sprX +  ceil(lengthdir_x(_slice.length2, _loadoutSpriteAngle)),
								_sprY + floor(lengthdir_y(_slice.length2, _loadoutSpriteAngle)),
								ceil(_slice.length2 - _slice.length1),
								false
							);
							surface_reset_target();
							
							 // Trim:
							surface_set_target(_sliceSurface);
							draw_set_blend_mode_ext(bm_zero, bm_src_alpha);
							draw_surface(_maskSurface, 0, 0);
							draw_set_blend_mode(bm_normal);
							surface_reset_target();
						}
						
						 // Draw Sliced Sprite:
						surface_set_target(other.surf);
						draw_surface(
							_sliceSurface,
							 ceil(_sliceXOffset - lengthdir_x(_slice.length1, _loadoutSpriteAngle)) - _sprX,
							floor(_sliceYOffset - lengthdir_y(_slice.length1, _loadoutSpriteAngle)) - _sprY
						);
						surface_reset_target();
						
						 // Destroy Surfaces:
						surface_destroy(_maskSurface);
						surface_destroy(_sliceSurface);
					}
					
					 // Next Slice:
					_sliceXOffset += lengthdir_x(_slice.length2 - _slice.length1, _loadoutSpriteAngle);
					_sliceYOffset += lengthdir_y(_slice.length2 - _slice.length1, _loadoutSpriteAngle);
					_slice = _nextSlice;
				}
			}
			
			 // Add Sprite:
			surface_save(surf, name + ".png");
			_mergeWepLoadoutSprite = sprite_add(
				name + ".png",
				_mergeWepLoadoutSpriteImageNum,
				_mergeWepLoadoutSpriteXOffset,
				_mergeWepLoadoutSpriteYOffset
			);
			
			 // Store Sprite:
			spr.MergeWepLoadout[? _mergeWepLoadoutSpriteName] = _mergeWepLoadoutSprite;
		}
	}
	
	return _mergeWepLoadoutSprite;
	
#define weapon_merge_subtext(_stock, _front)
	/*
		Used to create merged weapon pickup indicator banner sprites
		Returns a new sprite of the "Stock Name + Front Name" in fntSmall over a transparent banner
		Doing this here so that the sprite doesnt get unloaded with ntte.mod
	*/
	
	var _sprName = sprite_get_name(_stock) + "|" + sprite_get_name(_front);
	
	if(ds_map_exists(spr.MergeWepText, _sprName)){
		return spr.MergeWepText[? _sprName];
	}
	
	 // Initial Setup:
	else{
		draw_set_font(fntSmall);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		
		var	_text     = weapon_get_name(_stock) + " + " + weapon_get_name(_front),
			_topSpace = 2,
			_surfW    = string_width(_text) + 4,
			_surfH    = string_height(_text) + 2 + _topSpace;
			
		with(surface_setup("sprMergeText", _surfW, _surfH, 1)){
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			
			 // Background:
			var	_x1 = -1,
				_y1 = -1,
				_x2 = _x1 + w,
				_y2 = _y1 + h;
				
			draw_set_alpha(0.8);
			draw_set_color(c_black);
			draw_roundrect_ext(_x1, _y1 + _topSpace, _x2, _y2, 5, 5, false);
			draw_set_alpha(1);
			
			 // Text:
			draw_text_nt(floor(w / 2), floor((h + _topSpace) / 2), _text);
			
			 // Done:
			surface_reset_target();
			free = true;
			
			 // Add Sprite:
			surface_save(surf, name + ".png");
			spr.MergeWepText[? _sprName] = sprite_add(name + ".png", 1, w / 2, h / 2);
			
			return spr.MergeWepText[? _sprName];
		}
	}
	
	return -1;
	
#define sprite_add_toptiny(_spr)
	/*
		Returns a new "TopTiny" corner tile sprite list created from the given TopSmall sprite
	*/
	
	var	_sprList = [[0, 0], [0, 0]],
		_sprImg  = sprite_get_number(_spr),
		_sprW    = sprite_get_width(_spr),
		_sprH    = sprite_get_height(_spr),
		_sprX    = sprite_get_xoffset(_spr),
		_sprY    = sprite_get_yoffset(_spr);
		
	with(surface_setup("sprTopTiny", (_sprW / 2) * _sprImg, (_sprH / 2), 1)){
		free = true;
		for(var _x = 0; _x < array_length(_sprList[0]); _x++){
			for(var _y = 0; _y < array_length(_sprList[1]); _y++){
				surface_set_target(surf);
				draw_clear_alpha(c_black, 0);
				
				with(UberCont){
					for(var _img = 0; _img < _sprImg; _img++){
						draw_sprite_part(
							_spr,
							_img,
							(_sprW / 2) * (1 - _x),
							(_sprH / 2) * (1 - _y),
							(_sprW / 2),
							(_sprH / 2),
							(_sprW / 2) * _img,
							0
						);
					}
				}
				
				surface_reset_target();
				
				 // Add Sprite:
				surface_save(surf, name + ".png");
				_sprList[_x, _y] = sprite_add(
					name + ".png",
					_sprImg,
					(_sprX - 8) * _x,
					(_sprY - 8) * _y
				);
			}
		}
	}
	
	return _sprList;
	
#define loadout_wep_save(_race, _name)
	/*
		Saves a LWO starting weapon's variables to restore them later on mod unload/game_start
	*/
	
	var _wep = unlock_get(`loadout:wep:${_race}:${_name}`);
	
	if(is_object(_wep)){
		ds_list_add(global.loadout_wep_clone, [_race, _name, _wep, lq_clone(_wep)]);
	}
	
#define loadout_wep_reset()
	/*
		Restores all of a LWO starting weapon's original variables
	*/
	
	with(ds_list_to_array(global.loadout_wep_clone)){
		var	_race    = self[0],
			_name    = self[1],
			_wep     = self[2],
			_wepSave = unlock_get(`loadout:wep:${_race}:${_name}`);
			
		if(_wep == _wepSave){
			var _wepCopy = self[3];
			save_set(`unlock:loadout:wep:${_race}:${_name}`, _wepCopy);
		}
	}
	
	ds_list_clear(global.loadout_wep_clone);