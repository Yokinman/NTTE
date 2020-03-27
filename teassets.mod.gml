#define init
	 // SPRITES //
	spr = {};
	sprLoad = [[spr, 0]];
	with(spr){
		var m, p;
		msk = {};
		shd = {};
		
		 // Shine:
		p = "sprites/chests/";
		Shine8  = sprite_add(p + "sprShine8.png",  7,  4,  4); // Rads
		Shine10 = sprite_add(p + "sprShine10.png", 7,  5,  5); // Pickups
		Shine12 = sprite_add(p + "sprShine12.png", 7,  6,  6); // Big Rads
		Shine16 = sprite_add(p + "sprShine16.png", 7,  8,  8); // Normal Chests
		Shine20 = sprite_add(p + "sprShine20.png", 7, 10, 10); // Heavy Chests (Steroids)
		Shine24 = sprite_add(p + "sprShine24.png", 7, 12, 12); // Big Chests
		Shine64 = sprite_add(p + "sprShine64.png", 7, 32, 32); // Giant Chests (YV)
		
		 // Big Decals:
		BigTopDecal = {
			"1"     : sprite("areas/Desert/sprDesertBigTopDecal",       1, 32, 24),
			"2"     : sprite("areas/Sewers/sprSewersBigTopDecal",       8, 32, 24),
			"3"     : sprite("areas/Scrapyard/sprScrapyardBigTopDecal", 1, 32, 24),
			"4"     : sprite("areas/Caves/sprCavesBigTopDecal",         1, 32, 24),
			"7"     : sprite("areas/Palace/sprPalaceBigTopDecal",       1, 32, 24),
			"104"   : sprite("areas/Caves/sprCursedCavesBigTopDecal",   1, 32, 24),
			"pizza" : sprite("areas/Pizza/sprPizzaBigTopDecal",         1, 32, 24),
			"oasis" : sprite("areas/Oasis/sprOasisBigTopDecal",         1, 32, 24),
			"trench": sprite("areas/Trench/sprTrenchBigTopDecal",       1, 32, 24)
		};
		NestDebris		  = sprite("areas/Scrapyard/sprNestDebris", 16,     4,  4);
		msk.BigTopDecal	  = sprite("areas/Desert/mskBigTopDecal",    1,    32, 24);
		shd.BigGenerator  = sprite("areas/Palace/shdBigGenerator",   1, 48-16, 32);
		shd.BigGeneratorR = sprite("areas/Palace/shdBigGeneratorR",  1, 48+16, 32);
		
		//#region MENU / HUD
			
			 // Open Options:
			p = "menu/";
			OptionNTTE = sprite(p + "sprOptionNTTE", 1, 32, 12);
			MenuNTTE   = sprite(p + "sprMenuNTTE",   1, 20,  9);
			
			 // LoadoutCrown System:
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
			Bone	  = sprite(p + "sprBone",      1, 6, 6);
			BoneShard = sprite(p + "sprBoneShard", 1, 3, 2, shnWep);
			
			 // Trident:
			Trident            = sprite(p + "sprTrident",            1, 11,  6, shnWep);
			GoldTrident        = sprite(p + "sprGoldTrident",        1, 11,  6, shnWep);
			TridentLoadout     = sprite(p + "sprTridentLoadout",     1, 24, 24);
			GoldTridentLoadout = sprite(p + "sprGoldTridentLoadout", 1, 24, 24);
			msk.Trident        = sprite(p + "mskTrident",            1, 11,  6);
			
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
			
			 // Clam Shield Slash:
			ClamShieldSlash     = sprite(p + "sprClamShieldSlash", 4, 12, 12);
			msk.ClamShieldSlash = sprite(p + "mskClamShieldSlash", 4, 12, 12);
			
			 // Electroplasma:
			ElectroPlasma       = sprite(p + "sprElectroPlasma",       7, 12, 12);
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
			msk.PlasmaImpactSmall  = sprite(p + "mskPlasmaImpactSmall",      7, 16, 16);
			with(msk.PlasmaImpactSmall){
				mask = [true, 0];
			}
			
			 // Portal Guardian:
			PortalBullet      = sprite(p + "sprPortalBullet",      4, 12, 12);
			PortalBulletSpawn = sprite(p + "sprPortalBulletSpawn", 7, 26, 26);
			
			 // Quasar Beam:
			QuasarBeam      = sprite(p + "sprQuasarBeam",      2,  0, 16);
			QuasarBeamStart = sprite(p + "sprQuasarBeamStart", 2, 32, 16);
			QuasarBeamEnd   = sprite(p + "sprQuasarBeamEnd",   2,  0, 16);
			QuasarBeamHit   = sprite(p + "sprQuasarBeamHit",   6, 24, 24);
			QuasarBeamTrail = sprite(p + "sprQuasarBeamTrail", 3,  4,  4);
			msk.QuasarBeam  = sprite(p + "mskQuasarBeam",      1, 32, 16);
			
			 // Small Green Explo:
			SmallGreenExplosion = sprite(p + "sprSmallGreenExplosion", 7, 12, 12);
			
			 // Vector Plasma:
			VlasmaBullet      = sprite(p + "sprVlasmaBullet",      5, 8, 8);
			EnemyVlasmaBullet = sprite(p + "sprEnemyVlasmaBullet", 5, 8, 8);
			
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
			
		//#endregion
		
		//#region ALERTS
		p = "enemies/Alerts/";
			
			 // Alert Indicators:
			AlertIndicator            = sprite(p + "sprAlertIndicator",            1, 1, 6);
			AlertIndicatorMystery     = sprite(p + "sprAlertIndicatorMystery",     1, 2, 6);
			AlertIndicatorPopoAmbush  = sprite(p + "sprAlertIndicatorPopoAmbush",  1, 4, 4);
			AlertIndicatorOrchidSkill = sprite(p + "sprAlertIndicatorOrchidSkill", 1, 4, 4);
			
			 // Alert Icons:
			AllyAlert        = sprite(p + "sprAllyAlert",        1, 7, 7);
			BanditAlert      = sprite(p + "sprBanditAlert",      1, 7, 7);
			FlyAlert         = sprite(p + "sprFlyAlert",         1, 7, 7);
			GatorAlert       = sprite(p + "sprGatorAlert",       1, 7, 7);
			GatorAlbinoAlert = sprite(p + "sprAlbinoGatorAlert", 1, 7, 7);
			SealAlert        = sprite(p + "sprSealAlert",        1, 7, 7);
			SealArcticAlert  = sprite(p + "sprArcticSealAlert",  1, 7, 7);
			SkealAlert       = sprite(p + "sprSkealAlert",       1, 7, 7);
			SludgePoolAlert  = sprite(p + "sprSludgePoolAlert",  1, 7, 7);
			VanAlert         = sprite(p + "sprVanAlert",         1, 7, 7);
			PopoAmbushAlert  = sprite(p + "sprPopoAmbushAlert",  3, 9, 9);
			
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
			CatWeap	 = sprite(p + "sprCatToxer",     1,  3,  4);
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
			CatBossWeapChrg = sprite(p + "sprCatBossToxerChrg",	12,  1,  7);
			BossHealFX      = sprite(p + "sprBossHealFX",       10,  9,  9);
			
			 // Crab Tank:
			CrabTankIdle = sprCrabIdle;
			CrabTankWalk = sprCrabWalk;
			CrabTankHurt = sprCrabHurt;
			CrabTankDead = sprCrabDead;
			
			 // Crystal Brain:
			p = m + "CrystalBrain/";
			CrystalBrainIdle     = sprite(p + "sprCrystalBrainIdle",      6, 24, 24);
			CrystalBrainHurt     = sprite(p + "sprCrystalBrainHurt",      3, 24, 24);
			CrystalBrainDead     = sprite(p + "sprCrystalBrainDead",      7, 24, 24);
			CrystalBrainChunk    = sprite(p + "sprCrystalBrainChunk",     4,  8,  8);
			CrystalBrainEffect   = sprite(p + "sprCrystalBrainEffect",   10,  8,  8);
			CrystalBrainSurfMask = sprite(p + "sprCrystalBrainSurfMask",  1,  0,  0);
			
			CloneOverlay       = sprite(p + "sprCloneOverlay",       8, 0, 0);
			CloneOverlayCorpse = sprite(p + "sprCloneOverlayCorpse", 8, 0, 0);
			
			 // Crystal Heart:
			p = m + "CrystalHeart/";
			CrystalHeartIdle = sprite(p + "sprCrystalHeartIdle", 10, 24, 24);
			CrystalHeartHurt = sprite(p + "sprCrystalHeartHurt",  3, 24, 24);
			CrystalHeartDead = sprite(p + "sprCrystalHeartDead", 22, 24, 24);
			CrystalHeartProj = sprite(p + "sprCrystalHeartProj",  2, 10, 10);
			
			 // Diver:
			p = m + "Diver/";
			DiverIdle  = sprite(p + "sprDiverIdle",       4, 12, 12);
			DiverWalk  = sprite(p + "sprDiverWalk",       6, 12, 12);
			DiverHurt  = sprite(p + "sprDiverHurt",       3, 12, 12);
			DiverDead  = sprite(p + "sprDiverDead",       9, 16, 16);
			HarpoonGun = sprite(p + "sprDiverHarpoonGun", 1,  8,  8);
			
			 // Eel:
			p = m + "Eel/";
			EelIdle	   =[sprite(p + "sprEelIdleBlue",    8, 16, 16),
			             sprite(p + "sprEelIdlePurple",  8, 16, 16),
			             sprite(p + "sprEelIdleGreen",   8, 16, 16)];
			EelHurt	   =[sprite(p + "sprEelHurtBlue",    3, 16, 16),
			             sprite(p + "sprEelHurtPurple",  3, 16, 16),
			             sprite(p + "sprEelHurtGreen",   3, 16, 16)];
			EelDead	   =[sprite(p + "sprEelDeadBlue",    9, 16, 16),
			             sprite(p + "sprEelDeadPurple",  9, 16, 16),
			             sprite(p + "sprEelDeadGreen",   9, 16, 16)];
			EelTell	   =[sprite(p + "sprEelTellBlue",    8, 16, 16),
			             sprite(p + "sprEelTellPurple",  8, 16, 16),
			             sprite(p + "sprEelTellGreen",   8, 16, 16)];
			EeliteIdle = sprite(p + "sprEelIdleElite",   8, 16, 16);
			EeliteHurt = sprite(p + "sprEelHurtElite",   3, 16, 16);
			EeliteDead = sprite(p + "sprEelDeadElite",   9, 16, 16);
			WantEel	   = sprite(p + "sprWantEel",       16, 16, 16);
			
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
			
			 // Hammerhead:
			p = m + "Hammer/";
			HammerheadIdle = sprite(p + "sprHammerheadIdle",  6, 24, 24);
			HammerheadHurt = sprite(p + "sprHammerheadHurt",  3, 24, 24);
			HammerheadDead = sprite(p + "sprHammerheadDead", 10, 24, 24);
			HammerheadChrg = sprite(p + "sprHammerheadDash",  2, 24, 24);
			
			 // Jellyfish (0 = blue, 1 = purple, 2 = green, 3 = elite):
			p = m + "Jellyfish/";
			JellyFire	   = sprite(p + "sprJellyfishFire",        6, 24, 24);
			JellyEliteFire = sprite(p + "sprJellyfishEliteFire",   6, 24, 24);
			JellyIdle	   =[sprite(p + "sprJellyfishBlueIdle",    8, 24, 24),
			                 sprite(p + "sprJellyfishPurpleIdle",  8, 24, 24),
			                 sprite(p + "sprJellyfishGreenIdle",   8, 24, 24)
			                 sprite(p + "sprJellyfishEliteIdle",   8, 24, 24)];
			JellyHurt	   =[sprite(p + "sprJellyfishBlueHurt",    3, 24, 24),
			                 sprite(p + "sprJellyfishPurpleHurt",  3, 24, 24),
			                 sprite(p + "sprJellyfishGreenHurt",   3, 24, 24)
			                 sprite(p + "sprJellyfishEliteHurt",   3, 24, 24)];
			JellyDead	   =[sprite(p + "sprJellyfishBlueDead",   10, 24, 24),
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
			
			 // Pelican:
			p = m + "Pelican/";
			PelicanIdle   = sprite(p + "sprPelicanIdle",   6, 24, 24);
			PelicanWalk   = sprite(p + "sprPelicanWalk",   6, 24, 24);
			PelicanHurt   = sprite(p + "sprPelicanHurt",   3, 24, 24);
			PelicanDead   = sprite(p + "sprPelicanDead",   6, 24, 24);
			PelicanHammer = sprite(p + "sprPelicanHammer", 1,  6,  8);
			
			 // Pit Squid:
			p = m + "Pitsquid/";
				
				 // Eyes:
				PitSquidCornea  = sprite(p + "sprPitsquidCornea", 1, 19, 19);
				PitSquidPupil   = sprite(p + "sprPitsquidPupil",  1, 19, 19);
				PitSquidEyelid  = sprite(p + "sprPitsquidEyelid", 3, 19, 19);
				
				 // Tentacles:
				TentacleSpwn = sprite(p + "sprTentacleSpwn",           6, 20, 28);
				TentacleIdle = sprite(p + "sprTentacleIdle",           8, 20, 28);
				TentacleHurt = sprite(p + "sprTentacleHurt",           3, 20, 28);
				TentacleDead = sprite(p + "sprTentacleDead",           6, 20, 28);
				TentacleWarn = sprite(p + "sprTentacleWarn",          15, 12, 12);
				TentacleDash =[sprite(p + "sprTentacleBackwards",      2, 20, 20),
				               sprite(p + "sprTentacleForwards",       2, 20, 20)];
				SquidCharge  = sprite(p + "Particles/sprSquidCharge",  5, 24, 24);
				
				 // Maw:
				PitSquidMawBite = sprite(p + "sprPitsquidMawBite", 14, 19, 19);
				PitSquidMawSpit = sprite(p + "sprPitsquidMawSpit", 10, 19, 19);
				
				 // Spark:
				p += "Particles/";
				PitSpark = [
					sprite(p + "sprPitSpark1", 5, 16, 16),
					sprite(p + "sprPitSpark2", 5, 16, 16),
					sprite(p + "sprPitSpark3", 5, 16, 16),
					sprite(p + "sprPitSpark4", 5, 16, 16),
					sprite(p + "sprPitSpark5", 5, 16, 16),
				];
				TentacleWheel = sprite(p + "sprTentacleWheel", 2, 40, 40);
				
			 // Portal Guardian:
			p = m + "PortalGuardian/";
			PortalGuardianIdle      = sprite(p + "sprPortalGuardianIdle",      4, 16, 16);
			PortalGuardianHurt      = sprite(p + "sprPortalGuardianHurt",      3, 16, 16);
			PortalGuardianDead      = sprite(p + "sprPortalGuardianDead",      9, 32, 32);
			PortalGuardianAppear    = sprite(p + "sprPortalGuardianAppear",    5, 32, 32);
			PortalGuardianDisappear = sprite(p + "sprPortalGuardianDisappear", 4, 32, 32);
			
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
			SealWeap[1] = sprite(p + "sprHookPole",     1, 18,  2);
			SealWeap[2] = sprite(p + "sprSabre",        1, -2,  1);
			SealWeap[3] = sprite(p + "sprBlunderbuss",  1,  7,  1);
			SealWeap[4] = sprite(p + "sprRepeater",     1,  6,  2);
			SealWeap[5] = sprBanditGun;
			SealDisc	= sprite(p + "sprSealDisc",		2,	7,	7);
			ClamShield  = sprite(p + "sprClamShield",  14,  0,  7);
			SkealIdle   = sprite(p + "sprSkealIdle",    6, 12, 12);
			SkealWalk   = sprite(p + "sprSkealWalk",    7, 12, 12);
			SkealHurt   = sprite(p + "sprSkealHurt",    3, 12, 12);
			SkealDead   = sprite(p + "sprSkealDead",   10, 16, 16);
			SkealSpwn   = sprite(p + "sprSkealSpwn",    8, 16, 16);
			
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
				BigNightCactusIdle = sprite(p + "sprBigNightCactusIdle", 1, 16, 16);
				BigNightCactusHurt = sprite(p + "sprBigNightCactusHurt", 3, 16, 16);
				BigNightCactusDead = sprite(p + "sprBigNightCactusDead", 4, 16, 16);
				
			//#endregion
			
		//#endregion
		
		//#region DESERT
		m = "areas/Desert/";
		p = m;
			
			 // Fly:
			FlySpin = sprite(p + "sprFlySpin", 16, 4, 4);
			
			 // Wall Rubble:
			Wall1TopRubble = sprite(p + "sprWall1TopRubble", 3, 0, 0);
			
			 // Wall Bro:
			WallBandit = sprite(p + "sprWallBandit", 9, 8, 8);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Camp:
				BanditCampfire     = sprite(p + "sprBanditCampfire",     1, 26, 26);
				BanditTentIdle     = sprite(p + "sprBanditTentIdle",     1, 24, 24);
				BanditTentHurt     = sprite(p + "sprBanditTentHurt",     3, 24, 24);
				BanditTentDead     = sprite(p + "sprBanditTentDead",     3, 24, 24);
				BanditTentWallIdle = sprite(p + "sprBanditTentWallIdle", 1, 24, 24);
				BanditTentWallHurt = sprite(p + "sprBanditTentWallHurt", 3, 24, 24);
				BanditTentWallDead = sprite(p + "sprBanditTentWallDead", 3, 24, 24);
				
				 // Big Cactus:
				BigCactusIdle = sprite(p + "sprBigCactusIdle", 1, 16, 16);
				BigCactusHurt = sprite(p + "sprBigCactusHurt", 3, 16, 16);
				BigCactusDead = sprite(p + "sprBigCactusDead", 4, 16, 16);
				
				 // Scorpion Rock:
				ScorpionRockEnemy   = sprite(p + "sprScorpionRockEnemy",  6, 16, 16);
				ScorpionRockFriend  = sprite(p + "sprScorpionRockFriend", 6, 16, 16);
				ScorpionRockHurt    = sprite(p + "sprScorpionRockHurt",   3, 16, 16);
				ScorpionRockDead    = sprite(p + "sprScorpionRockDead",   3, 16, 16);
				
			//#endregion
			
		//#endregion
		
		//#region SCRAPYARD
		m = "areas/Scrapyard/";
		p = m;
			
			 // Decals:
			TopDecalScrapyardAlt = sprite(p + "sprTopDecalScrapyardAlt", 1, 16, 16);
			
			 // Sludge Pool:
			SludgePool          = sprite(p + "sprSludgePool",      4,  0,  0);
			msk.SludgePool      = sprite(p + "mskSludgePool",      1, 32, 32);
			msk.SludgePoolSmall = sprite(p + "mskSludgePoolSmall", 1, 16, 16);
			
			 // Fire Pit Scorch Details:
			FirePitScorch = sprite(p + "sprFirePitScorch", 3, 16, 16);
			
		//#endregion
		
		//#region CRYSTAL CAVES
		m = "areas/Caves/";
		p = m;
			
			 // Wall Spiders:
			WallSpider          = sprite(p + "sprWallSpider",          2, 8, 8);
			WallSpiderBot       = sprite(p + "sprWallSpiderBot",       2, 0, 0);
			WallSpiderling      = sprite(p + "sprWallSpiderling",      4, 8, 8);
			WallSpiderlingTrans	= sprite(p + "sprWallSpiderlingTrans", 4, 8, 8);
			
		//#endregion
		
		//#region FROZEN CITY
		m = "areas/City/";
		p = m;
			
			//#region PROPS
			p = m + "Props/";
				
				 // Igloos:
				IglooFrontIdle = sprite(p + "sprIglooFrontIdle", 1, 24, 24);
				IglooFrontHurt = sprite(p + "sprIglooFrontHurt", 3, 24, 24);
				IglooFrontDead = sprite(p + "sprIglooFrontDead", 3, 24, 24);
				IglooSideIdle  = sprite(p + "sprIglooSideIdle",  1, 24, 24);
				IglooSideHurt  = sprite(p + "sprIglooSideHurt",  3, 24, 24);
				IglooSideDead  = sprite(p + "sprIglooSideDead",  3, 24, 24);
				
				 // Palanking Statue:
				PalankingStatueIdle  =[sprite(p + "sprPalankingStatue1Idle", 1, 32, 32),
				                       sprite(p + "sprPalankingStatue2Idle", 1, 32, 32),
				                       sprite(p + "sprPalankingStatue3Idle", 1, 32, 32),
				                       sprite(p + "sprPalankingStatue4Idle", 1, 32, 32)];
				PalankingStatueHurt  =[sprite(p + "sprPalankingStatue1Hurt", 3, 32, 32),
				                       sprite(p + "sprPalankingStatue2Hurt", 3, 32, 32),
				                       sprite(p + "sprPalankingStatue3Hurt", 3, 32, 32),
				                       sprite(p + "sprPalankingStatue4Hurt", 3, 32, 32)];
				PalankingStatueDead  = sprite(p + "sprPalankingStatueDead",  3, 32, 32);
				PalankingStatueChunk = sprite(p + "sprPalankingStatueChunk", 5, 16, 16);
				
			//#endregion
			
		//#endregion
		
		//#region PALACE
		m = "areas/Palace/";
		p = m;
			
			 // Shrine Floors:
			FloorPalaceShrine          = sprite(p + "sprFloorPalaceShrine",          10, 2, 2);
			FloorPalaceShrineRoomSmall = sprite(p + "sprFloorPalaceShrineRoomSmall",  4, 0, 0);
			FloorPalaceShrineRoomLarge = sprite(p + "sprFloorPalaceShrineRoomLarge",  9, 0, 0);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Palace Altar:
				PalaceAltarIdle   = sprite(p + "sprPalaceAltarIdle",   1, 24, 24);
				PalaceAltarHurt   = sprite(p + "sprPalaceAltarHurt",   3, 24, 24);
				PalaceAltarDead   = sprite(p + "sprPalaceAltarDead",   4, 24, 24);
				PalaceAltarDebris = sprite(p + "sprPalaceAltarDebris", 5,  8,  8);
				
				GroundFlameGreen             = sprite(p + "sprGroundFlameGreen",             8, 4, 6);
				GroundFlameGreenBig          = sprite(p + "sprGroundFlameGreenBig",          8, 6, 8);
				GroundFlameGreenDisappear    = sprite(p + "sprGroundFlameGreenDisappear",    4, 4, 6);
				GroundFlameGreenBigDisappear = sprite(p + "sprGroundFlameGreenBigDisappear", 4, 6, 8);
				
			//#endregion
			
		//#endregion
		
		//#region VAULT
		m = "areas/Vault/";
		p = m;
			
			 // Vault Flower Room:
			VaultFlowerFloor = sprite(p + "sprVaultFlowerFloor", 9, 0, 0);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Vault Flower:
				VaultFlowerIdle         = sprite(p + "sprVaultFlowerIdle",          4, 24, 24);
				VaultFlowerHurt         = sprite(p + "sprVaultFlowerHurt",          3, 24, 24);
				VaultFlowerDead         = sprite(p + "sprVaultFlowerDead",          3, 24, 24);
				VaultFlowerWiltedIdle   = sprite(p + "sprVaultFlowerWiltedIdle",    1, 24, 24);
				VaultFlowerWiltedHurt   = sprite(p + "sprVaultFlowerWiltedHurt",    3, 24, 24);
				VaultFlowerWiltedDead   = sprite(p + "sprVaultFlowerWiltedDead",    3, 24, 24);
				VaultFlowerDebris       = sprite(p + "sprVaultFlowerDebris",       10,  4,  4);
				VaultFlowerWiltedDebris = sprite(p + "sprVaultFlowerWiltedDebris", 10,  4,  4);
				VaultFlowerSparkle      = sprite(p + "sprVaultFlowerSparkle",       4,  3,  3);
				
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
			CoastTrans  = sprite(p + "sprCoastTrans",  1, 0, 0);
			WaterStreak = sprite(p + "sprWaterStreak", 7, 8, 8);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Blooming Cactus:
				BloomingCactusIdle =[sprite(p + "sprBloomingCactus",      1, 12, 12),
				                     sprite(p + "sprBloomingCactus2",     1, 12, 12),
				                     sprite(p + "sprBloomingCactus3",     1, 12, 12)];
				BloomingCactusHurt =[sprite(p + "sprBloomingCactusHurt",  3, 12, 12),
				                     sprite(p + "sprBloomingCactus2Hurt", 3, 12, 12),
				                     sprite(p + "sprBloomingCactus3Hurt", 3, 12, 12)];
				BloomingCactusDead =[sprite(p + "sprBloomingCactusDead",  4, 12, 12),
				                     sprite(p + "sprBloomingCactus2Dead", 4, 12, 12),
				                     sprite(p + "sprBloomingCactus3Dead", 4, 12, 12)];
				
				 // Big Blooming Cactus:
				BigBloomingCactusIdle = sprite(p + "sprBigBloomingCactusIdle", 1, 16, 16);
				BigBloomingCactusHurt = sprite(p + "sprBigBloomingCactusHurt", 3, 16, 16);
				BigBloomingCactusDead = sprite(p + "sprBigBloomingCactusDead", 4, 16, 16);
				
				 // Buried Car:
				BuriedCarIdle = sprite(p + "sprBuriedCarIdle", 1, 16, 16);
				BuriedCarHurt = sprite(p + "sprBuriedCarHurt", 3, 16, 16);
				
				 // Bush:
				BloomingBushIdle = sprite(p + "sprBloomingBushIdle", 1, 12, 12);
				BloomingBushHurt = sprite(p + "sprBloomingBushHurt", 3, 12, 12);
				BloomingBushDead = sprite(p + "sprBloomingBushDead", 3, 12, 12);
				
				 // Palm:
				PalmIdle     = sprite(p + "sprPalm",         1, 24, 40);
				PalmHurt     = sprite(p + "sprPalmHurt",     3, 24, 40);
				PalmDead     = sprite(p + "sprPalmDead",     4, 24, 40);
				PalmFortIdle = sprite(p + "sprPalmFortIdle", 1, 32, 56);
				PalmFortHurt = sprite(p + "sprPalmFortHurt", 3, 32, 56);
				
				 // Sea/Seal Mine:
				SealMine	 = sprite(p + "sprSeaMine",     1, 12, 12);
				SealMineHurt = sprite(p + "sprSeaMineHurt", 3, 12, 12);
				
			p = m + "Decals/";
				
				 // Decal Water Rock Props:
				RockIdle  =[sprite(p + "sprRock1Idle", 1, 16, 16),
				            sprite(p + "sprRock2Idle", 1, 16, 16)];
				RockHurt  =[sprite(p + "sprRock1Hurt", 3, 16, 16),
				            sprite(p + "sprRock2Hurt", 3, 16, 16)];
				RockDead  =[sprite(p + "sprRock1Dead", 1, 16, 16),
				            sprite(p + "sprRock2Dead", 1, 16, 16)];
				RockBott  =[sprite(p + "sprRock1Bott", 1, 16, 16),
				            sprite(p + "sprRock2Bott", 1, 16, 16)];
				RockFoam  =[sprite(p + "sprRock1Foam", 1, 16, 16),
				            sprite(p + "sprRock2Foam", 1, 16, 16)];
				ShellIdle = sprite(p + "sprShellIdle", 1, 32, 32);
				ShellHurt = sprite(p + "sprShellHurt", 3, 32, 32);
				ShellDead = sprite(p + "sprShellDead", 6, 32, 32);
				ShellBott = sprite(p + "sprShellBott", 1, 32, 32);
				ShellFoam = sprite(p + "sprShellFoam", 1, 32, 32);
				
			//#endregion
			
			 // Strange Creature:
			CreatureIdle = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAACMAAAACgCAMAAADXNXIqAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAAAU9IAxsQWkrGXVgQ/w4ALiVetS/rwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKuM2GgAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGXRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4wLjE3M26fYwAADJxJREFUeF7t24ty20YSQFFlLcv//8VZYNCkAGLwIAYU0c45VSvSeM3dSRWqI1c+/gUASMYAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0WgaYj4k4eCERFuLghURYiIMXEmEhDl5IhIU4eCERFuLglUTZII5dSZQN4tiVRNkgjl1JlA3i2JVE2SCOXUmUDeLYlUTZII5dSZQN4tjZDj03kv6ZiINxyVtFSoSFOBiXvFWkRFiIg3HJW0VKhIU4GJe8VaREWIiDcclbRUqEhTgYl7xXtETZII7FFe8VLVE2iGNxxXtFS5QN4lhc8V7REmWDOBZXvFe0RNkgjsUV7xUtUTaIY3HFe0VLlA3iWFzxVpHyI33PPrBERFLVCxqfoa+NvjZX79sM1LdOXxt9bS7et5V3et9TT1tu+9+3N+6hvjb62ly9bzkw2nqX7JsE6luir42+Jst5o76T3y/7H7W+eeMdLI1x18/R10Zfm6v3LQcOSaVscMG+hw3UN6evjb4mi3mlbJp3Yt/eBy3WdWWxhRM/vYX62uhrc/2+pcC+bx54pb7aBuqb0tdGX5vFvC6tknde367HLO9eSasF/ugW6mujr83V+7rAyJkpJdXAa/Qtb+A/P5enr5G+Nrn7qnln9e14ykpdPe3mh7ZQXxt9ba7etxoYKVVX7/upCUtfG31t9K3YfsZKXWdhvAo/sYP62uhrc/m+1cCubznwRyaY9b7VDdTX0ddGX5v1vi5vue+M99/WIza2L0TP3Mt3UF8bfW3+jr7FQH36muhr83f0Rc1ce9/GE/ZtXy+KHr14B/W10dfm7+lbCNS3VwQ90LdXBD3Qt1cEPbhMX/Q8au5bf8BiXyw/8pYd1NdGX5u0ffOYq/dN/0PMb/qqYvURfXP62jzRV0vutfat3r/QF0s/qh9/5d/D6Wujr03SvoXAhcP6ZmLlB/oe6WvzV/UtHW7sW7u93hcL7/a6N7S+Nvra5Ox7NvDH+54M1PcoFt5J36NYeCd9D2LdvRr7Vu6u98Wy+/3zqh3U10Zfm5x9Twdeve9lb2h9bfS1ydkXiz6hrW/55iN9tdPdsZfsoL42+trk7NsIrOhuuXRft4H6vsWiT9A3Fos+Qd9IrPmE7p6WvsV7j+3f/Hy55QU7qK+NvjZJ+zYCK6f1TQyLLtF3o69N0r5hzUXn9y3deqyvEjjcc/oO6mujr03Svq3A+QXX6qttYP9DXyhLrtA30Ndmoa+suGJ+xXDkeN/CnYf3byHw7L+H09dGX5usfduB8XmXo+/sN7S+NvraZO0ra61Z6Dv+fqnfeHz/FgJPfgPqa6OvTdq+7cD4vNM3URZboa+nr03avrLWmtP76vctB240zk+3Blbpa6OvTdq+7cD4vLv1nRrY0Pd4Wt+Evj30tVns28pb7juaV71vdf9WC+dnb0fO3EB9bfS1ydvXBw7rLZid1jehbwd9bfL2dcv9cF/1tpXADfMrbjf90AZu0NfT1yZv36HA4UNfr6y1Ql9HX5u8fWWpFfNLbkeO9tVuW9m/frG1ysr/heGm7uO0HdTXRl+bzH0bgcMFE3HoGn1dRny5u92kr+iXKuvW6dPXaq2vX6ksWzdcMXG762Bf7a6NDSw/FszPdUc+fv3+3T3zp/4Blx8L5ue6I/pG9G1K3VcCY+25cn6iO3Khvnlgd0DfmL4t+tqs9lUSRubnuiNNfZW71vdv9a+5hguGz6+vP4Ovr4/fv399bAZ+FPGHFfrq9OkrtgOHmrnh/PDl6xZY+ro3zObSewOP95XA2+eor7wB9Q30bdBXd1Jfp7RU3E/2n5HX9zW8/yp3HeyLc4Nb3OCrvvZYd7pc+rr9i3MDfWuiaCrODfStiaKpODd4b181ME6FSWDp23jB7A/UV6NvQt+aSJqIU+GtfVE0FecGk7yh7+D7r3LXjg28+/j4VfTrx6HONK9XEuP5FVH352vH/umb06fv7pm+euDTfU8FPtk3BOq70zen75p9UTfNe75vJa9y1/7Aj/53y70+MI5V6jpfX5+fi423vO6qHfun75E+fSP7+yaBcej+m+eJW98ZgU/0lb8eL777qhu4s+/8F7S+GX2P/qt91fff8333vNrrZX7Hvr6y2j3wOy+Wmvi6qUZ+715/4Vn7VxbSV6EvFgp/W9+hwF+3m+pvl/C5HfjqvtoGRl1H311ZSF+FvlgovKSvrHPP+37/1V4wEdfnVfomefO+efC+/et1S5UB8Ptf3+p18W3QZY4bPz6+T3997tlAffoG+mqe6iuB/W94hyM7+iIwFnsIPLfvtoHfffXXc3wJfcRCX3dO3yN9i/RV7O+LvKfff+P3yziv+v6bBz+xgQ/6paY9XUyludPvYb/0ePf+dBef+w/4gb6evo6+irLWLDC+PYi+aWD3hnllX3k9T/u6JePLA30VZQ19h5U19B3VL9XljVbsp5X4OrX//TcPPhrYl0x3b/H1POgjHy9/4QbqG+gL+ibmfRuBfd8s8OV9D4ErfeUlPTmvT5++u3f3Pf/+q/TNgw8Fdq/WzjRoo6+/YHK+63vZBuq703ej767WdyTwtX3deuMFn+3rr9f3Td9u+u4a+qY9z+bV33/z4COBt7xJX/eH9cDZ9r1sA/V903ej76b09YGxVnEk8Mp9Lxyw9H3Td6cvRF9fdHckr9I3D34+cNi7XixV9H9YDXw42fd1yZs7qC/oC/rGzuo7FHjlvu4h+kb07aRv7Ky+I3mVvnnv04Gfn7dfEcVSRfnDauBU6esec/4G6pvQV6Vv2ncs8MJ9w4Cl70bfTvomTuo7lFfpm/c+G9jlnbF/pe8VG6hvSl+VvoeYg4Gb/wr3rr6YAPUFffvomzqp71jevG+e+2xg54T9i74XbGBH34i+Gn2PLU8GvmyA6XSPnQce7NucAPXV6YuFgr7dhrxpy7G8+ftlnns4MFYa2x9Y4rq39M+9oHv6dtE38l/qeyKwa/vs+173AoyFJvb39TvYbWD3mI1AfXX6KvTtsdi3P6+8Xsr75aFvXvt8YP/Y1v0rfaXw/A3UN6avRl9jYJ928b4SqG9M3w76xs7s25831FX65rUHAsujY6WpvYXd9pWHdF6wgcNza/TtoG/sb+2rpuzt6wuHp3R3rAee27c78HsH9X3Tt4O+sXP74nPTbYDpTPPmsUcDY6WpvYHlCeFFGxgrTenbQd/Y39rXFjgq1Deib5u+sf9U39684QmDaV8lNpbdbwiMpaaeCixf+h/rOxir7qdvIlbdT99ErLpfjr62wFJYProfV+0rgd3/9N3p26ZvIlbdb6Vvb979AeXnuK/aGgvvtRa4s/B+Xflc30B9c/r0fYt194q+emB8brndXT4v2He/UN+Evm36HsS6e0Xf8Pyp+tG5+3Xly7hvoTWW3ufzM+4aK833L+Vb1cbpBbHyPvpmYuV99M3Eyvuk7CsL3z7ja83G6QWx8j5NfXE+/rBXrLyPvplYeR99M7HyPin77quWLyvrb5xeG7Zi/WVx3btExbK47l2iYllc9y5RsSyue5eoWBbXvUtULIvr3iUqlsV17xIVy+K6d4mKZXHdu0TFsrjuXaJiWVz3LlGxLK57l6hYFte9S1Qsi+teauu3RQAAl2OAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAZP799/9U6bLI9L+tDwAAAABJRU5ErkJggg==",
			14, 80, 80);
			CreatureHurt = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAeAAAACgCAMAAADjJU9/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAAAU9IAxsQXVgQ7iVetS/r////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHiDNaAAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGXRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4wLjE3M26fYwAABYhJREFUeF7tmomS2joURCF2+P8/nmhpBttos9GWpk/VC4MsXXf1GZNJXm4/ghoJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYnI8EP7ZgbSZuW7A2E0jmwVptrs2F0xDYMRZ0dt+CNewYC7IgmQdr2FGN0wPhMQV2jsG1hM5CNOjwFL3znZsGg3mwvzfx7v68GOh4QL4To+CuEBzqSLQ9X5v7FZgOcagjY/KVDoK2M+BkH5LPxu4B8fRWPCxf2RgoOwkOdyDanq8uUKCtEIc7MDBfyRT4ugAGNCZRX6i5X3o9xEPz5WfA1TUwoyWp+gzhx8PT5SEenC83AqIugzHNyNS3AaXtaW54eL7MBGj6AAxqRLQ+FLRhiOHx+dIDIOkjMKoJkf5QzoEBhifIlzwPRR+CYQ041V+MhoZnyJc6DkGfg3m1CfeHXopp9yfiKfIlDsNODTCxLnX6sz/FtjE8R774WbipA2bW5NLnX+CyXWpheJJ80aMwUwtMrcel/kINupX6hmfJFzsJL/XA3FpE+jtfII7UNjxNvshBWKkJJtch1t/lAiv/pdY8+cLn4KQumF2DaH/Jv/mzvF1+FljV8ET5JBgLkwu+nC94DEYqg+EViPeXbs/wvgMrNQXPlK+j4HqGEwXaNlIthgr0hyoanilf6BR8VAfjPybVny3jvaQXbsMO++/cHg+zXk3wVPn4BKf/D6u9vsMsmP4ej1svwZ3zzSS4bFe2QAPK2YFL/qJ9Xde/jnV1980XeHPgTYKp8gVOuXEtwPww2FMgON/fFvv5Zr7/DVjwoDyPazBToBng9uYFz5VvEsHYYcFKnDMF+voMuwZ37TlWex3zQ6C9v2tlwe3z9RRswT324JoHa3HKCzSlYKgpEGuh+kwx67LYDsMlPuurLbhHvt6CHbgRwCLAYoKyAl0dmwKxfEcTW9Zfgi2+6jM7834ny/ceGHdsDG72fjssxynrz/Eq8HkIRWx5/izzxPS47fB221wvETxZvlGCLcG7uQwpThSIkfYPkQ7fwa6wdcEXB0yHrpptfWZzXcGI1zTfSMFBkCJOeYFuHr6+321Tpr1Dfbu3B2yJu+tLXcFd8n2J4MVWZ34P2/VnfktL9ffWr93fSHC7fN8hGPUd+jDv0gUe+l2aCW6YbzrBWcPlBdoG7YvvzoImPPZdssDDRTPENJo1PFk+asGeZXl+BKIJj3uXLPCA6c+MqSnY0zbffIJzhs8WaOoL9Xe6QPuAlDzCk+XjF2yw39kfF+j6CzwiRybLN6HgjOErBQb685wr0P+YmzE8Wb5vEBx8QDzlBbofYWyD9QU3zTej4LThCwW6/sIFFjdoCvRjcoYny/flgssfET/D0lPw5/kCYdHySJAkDGopp16B9tX8lzaMu5bTNF8wK2oeB3LEQDGl/H52BSgvcPOaFjxXvkhWFF0KTu14rrsNCWeZy2FQTRnLglM7bKXPV3wZJHM5DO5cRtN8qW9GX30C7BsF+omDfaNAijjY15Tcp434z5FgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJpubn5x8Du/CP6ZKb1gAAAABJRU5ErkJggg==",
			3, 80, 80);
			CreatureBott = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAKAAAACgCAYAAACLz2ctAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4wYVETYBV3z5JQAAAB1pVFh0Q29tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUHAAAB+UlEQVR42u3bzU3DMBgGYAf10i1A6hQdgGmQmIUDq3BggGyBGCNHc2wrxX9tgxN4ngtIbZLP9usvrZSGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUGXYVLX7Y0y+No2D5RTA9uCsxT0CvIVx/tZcdA3gX1kIFg/nIHj0DOMgfPQM4oPZo2fzEUC6EkC6dkEBRAfk/3ZBAUQH5P92QQFEB0QAYeMB9DgUOiDdNTYiAaRb+EJY4nlAT8UIX4PdAqV8LTTEeMOGaT02hq39XGH5uU7PyTQerr3QboGdcAj748dMh80N6vzv+XFx5v/URJwfGxMdPibOHWZqCJU1hcz75841ZMYfMudN1Zi77pC4Rm6DpdYpJNbqJsvt8v3xbWW7+m6TtoKae47l8trT+LrOAJ6C+FLoPjGzU0Omm5V2bix0nZquGTO7vvacNV2oNObSfIUrulvuTlKq9TS+aXxfdwAvw/ic2cG5W1bs3AFramvpVqlbeGmNYqG+mjG2zmv6/dP4ud5bcHs4H6/odDHz+aj0Wa9l59/jC1CpEw8NXb1UW7pjT+N3xVo8Jc9fc/wmA3hbeEtfjNZf45prBwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACg5AeYQa0I8Pr3rQAAAABJRU5ErkJggg==",
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
			
			 // Ground Crack Effect:
			Crack = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAEAAAAAgCAYAAACinX6EAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAZdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAuMTczbp9jAAABk0lEQVRoQ+WVS3KDQAxEOUQ22ed0OUPujhEVTWk6PWK+sSgWrwwPI0/3YHvb9/3RUPkkqHwSVEbg4+f7eOHXZkJlBLAAr5CRsqh8FxLEwq6jE7avz+Plr6+BygiUChAkMKNUkAeVUbCBvOCIFqX3elAZCRr8WDYF3oezGFRGIgvFgqqzmOs4D6EyCmn3C+Eyb6+Z86uvApWt1H7fWsEw6diDlIBzLVQiElDBa8KKAmRmCsLCY9ASx3u89VFZ4j8LqArnYe8/jnG+QqWHhMXAzI0yXICgM34LYGvMTmqQIedg06p1Wgb7sBayIBMorSk7aUVD2zJmgQFG0blYQjroQXcc/Qi6UyzECOwz5DjJHlbsvIIBRsH5CpW1zN59y8ynwFsnlVfoI7SyAAGD9IJzLVS2sLIEmc0CtXC1PipbWVnC+S8Doaqp+JGmMgqy+PMp6Cmh8geaygjgzp1FYMgCV7tuofJd6I4reF0Qz0IL3n0lqIzAVRCvIHQeVEagt4BWqLwLM0qg8k6MlkDlnXh8AWPs2wudfCE+JW5sAwAAAABJRU5ErkJggg==",
			2, 16, 16);
			
		//#endregion
		
		//#region TRENCH
		m = "areas/Trench/";
		p = m;
			
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
			TopDecalTrench     = sprite(p + "sprTopDecalTrench",      1, 19, 24);
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
				EelSkullIdle = sprite(p + "sprEelSkeletonIdle", 1, 24, 24);
				EelSkullHurt = sprite(p + "sprEelSkeletonHurt", 3, 24, 24);
				EelSkullDead = sprite(p + "sprEelSkeletonDead", 3, 24, 24);
				
				 // Kelp:
				KelpIdle = sprite(p + "sprKelpIdle", 6, 16, 22);
				KelpHurt = sprite(p + "sprKelpHurt", 3, 16, 22);
				KelpDead = sprite(p + "sprKelpDead", 8, 16, 22);
				
				 // Vent:
				VentIdle = sprite(p + "sprVentIdle", 1, 12, 14);
				VentHurt = sprite(p + "sprVentHurt", 3, 12, 14);
				VentDead = sprite(p + "sprVentDead", 3, 12, 14);
				
			//#endregion
			
		//#endregion
		
		//#region SEWERS
		m = "areas/Sewers/";
		p = m;
			
			 // Sewer Pool:
			SewerPool     = sprite(p + "sprSewerPool", 8,  0,  0);
			msk.SewerPool = sprite(p + "mskSewerPool", 1, 32, 64);
			
			 // Secret:
			FloorSewerWeb   = sprite(p + "sprFloorSewerWeb",   1, 0, 0);
			FloorSewerDrain = sprite(p + "sprFloorSewerDrain", 1, 0, 0);
			
			//#region PROPS
			p = m + "Props/"
				
				 // Sewer Drain:
				SewerDrainIdle = sprite(p + "sprSewerDrainIdle", 8, 32, 38);
				SewerDrainHurt = sprite(p + "sprSewerDrainHurt", 3, 32, 38);
				SewerDrainDead = sprite(p + "sprSewerDrainDead", 5, 32, 38);
				
				 // Homage:
				GatorStatueIdle = sprite(p + "sprGatorStatueIdle", 1, 16, 16);
				GatorStatueHurt = sprite(p + "sprGatorStatueHurt", 3, 16, 16);
				GatorStatueDead = sprite(p + "sprGatorStatueDead", 4, 16, 16);
				
			//#endregion
			
		//#endregion
		
		//#region PIZZA SEWERS
		m = "areas/Pizza/";
		p = m;
			
			//#region PROPS
			p = m + "Props/";
				
				 // Door:
				PizzaDoor       = sprite(p + "sprPizzaDoor",       10, 2, 0);
				PizzaDoorDebris = sprite(p + "sprPizzaDoorDebris",  4, 4, 4);
				
				 // Drain:
				PizzaDrainIdle = sprite(p + "sprPizzaDrain",     8, 32, 38);
				PizzaDrainHurt = sprite(p + "sprPizzaDrainHurt", 3, 32, 38);
				PizzaDrainDead = sprite(p + "sprPizzaDrainDead", 5, 32, 38);
				msk.PizzaDrain = sprite(p + "mskPizzaDrain",     1, 32, 38);
				
				 // Manhole:
				PizzaManhole = [
					sprite(p + "sprPizzaManholeA", 2, 0, 0),
					sprite(p + "sprPizzaManholeB", 2, 0, 0),
					sprite(p + "sprPizzaManholeC", 2, 0, 0)
				];
				
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
			
			 // Walls:
			WallLairBot   = sprite(p + "sprWallLairBot",   4,  0,  0);
			WallLairTop   = sprite(p + "sprWallLairTop",   4,  0,  0);
			WallLairOut   = sprite(p + "sprWallLairOut",   5,  4, 12);
			WallLairTrans = sprite(p + "sprWallLairTrans", 1,  0,  0);
			DebrisLair    = sprite(p + "sprDebrisLair",    4,  4,  4);
			
			 // Decals:
			TopDecalLair  = sprite(p + "sprTopDecalLair",  2, 16, 16);
			WallDecalLair = sprite(p + "sprWallDecalLair", 1, 16, 16);
			
			 // Manholes:
			ManholeBottom      = sprite(p + "sprManholeBottom",       1, 16, 48);
			Manhole            = sprite(p + "sprManhole",            12, 16, 48);
			BigManholeBot      = sprite(p + "sprBigManholeBot",       1, 32, 32);
			BigManholeTop      = sprite(p + "sprBigManholeTop",       6, 32, 32);
			ManholeDebrisSmall = sprite(p + "sprManholeDebrisSmall",  4,  4,  4);
			ManholeDebrisBig   = sprite(p + "sprManholeDebrisBig",    3, 12, 12);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Cabinet:
				CabinetIdle = sprite(p + "sprCabinetIdle", 1, 12, 12);
				CabinetHurt = sprite(p + "sprCabinetHurt", 3, 12, 12);
				CabinetDead = sprite(p + "sprCabinetDead", 3, 12, 12);
				Paper       = sprite(p + "sprPaper",       3,  5,  6);
				
				/// Chairs:
					
					 // Side:
					ChairSideIdle  = sprite(p + "sprChairSideIdle",  1, 12, 12);
					ChairSideHurt  = sprite(p + "sprChairSideHurt",  3, 12, 12);
					ChairSideDead  = sprite(p + "sprChairSideDead",  3, 12, 12);
					
					 // Front:
					ChairFrontIdle = sprite(p + "sprChairFrontIdle", 1, 12, 12);
					ChairFrontHurt = sprite(p + "sprChairFrontHurt", 3, 12, 12);
					ChairFrontDead = sprite(p + "sprChairFrontDead", 3, 12, 12);
					
				 // Couch:
				CouchIdle = sprite(p + "sprCouchIdle", 1, 32, 32);
				CouchHurt = sprite(p + "sprCouchHurt", 3, 32, 32);
				CouchDead = sprite(p + "sprCouchDead", 3, 32, 32);
				
				 // Door:
				CatDoor         = sprite(p + "sprCatDoor",          10, 2, 0);
				CatDoorDebris   = sprite(p + "sprCatDoorDebris",     4, 4, 4);
				msk.CatDoor     = sprite(p + "mskCatDoor",           1, 4, 0);
				msk.CatDoorLOS  = sprite(p + "mskCatDoorLOS",        1, 4, 0);
				with(msk.CatDoorLOS){
					mask = [false, 1];
				}
				
				 // Rug:
				Rug = sprite(p + "sprRug", 1, 26, 26);
				
				 // Soda Machine:
				SodaMachineIdle = sprite(p + "sprSodaMachineIdle", 1, 16, 16);
				SodaMachineHurt = sprite(p + "sprSodaMachineHurt", 3, 16, 16);
				SodaMachineDead = sprite(p + "sprSodaMachineDead", 3, 16, 16);
				
				 // Table:
				TableIdle = sprite(p + "sprTableIdle", 1, 16, 16);
				TableHurt = sprite(p + "sprTableHurt", 3, 16, 16);
				TableDead = sprite(p + "sprTableDead", 3, 16, 16);
				
			//#endregion
			
		//#endregion
		
		//#region RED
		m = "areas/Crystal/";
		p = m;
			
			 // Floors:
			FloorRed      = sprite(p + "sprFloorCrystal",      1, 2, 2);
			FloorRedB     = sprite(p + "sprFloorCrystalB",     1, 2, 2);
			FloorRedExplo = sprite(p + "sprFloorCrystalExplo", 4, 1, 1);
			DetailRed     = sprite(p + "sprDetailCrystal",     5, 4, 4);
			
			 // Walls:
			WallRedBot	 = sprite(p + "sprWallCrystalBot",   2, 0,  0);
			WallRedTop	 = sprite(p + "sprWallCrystalTop",   4, 0,  0);
			WallRedOut	 = sprite(p + "sprWallCrystalOut",   1, 4, 12);
			WallRedTrans = sprite(p + "sprWallCrystalTrans", 4, 0,  0);
			DebrisRed    = sprite(p + "sprDebrisCrystal",    4, 4,  4);
			
			 // Decals:
			WallDecalRed = sprite(p + "sprWallDecalCrystal", 1, 16, 24);
			
			 // Misc:
			Starfield       = sprite(p + "sprStarfield",       2, 256, 256);
			SpiralStarfield = sprite(p + "sprSpiralStarfield", 2,  32,  32);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Red Crystals:
				CrystalPropRedIdle = sprite(p + "sprCrystalPropRedIdle", 1, 12, 12);
				CrystalPropRedHurt = sprite(p + "sprCrystalPropRedHurt", 3, 12, 12);
				CrystalPropRedDead = sprite(p + "sprCrystalPropRedDead", 4, 12, 12);
				
				 // White Crystals:
				CrystalPropWhiteIdle = sprite(p + "sprCrystalPropWhiteIdle", 1, 12, 12);
				CrystalPropWhiteHurt = sprite(p + "sprCrystalPropWhiteHurt", 3, 12, 12);
				CrystalPropWhiteDead = sprite(p + "sprCrystalPropWhiteDead", 4, 12, 12);
				
			//#endregion
			
		//#endregion
		
		//#region CHESTS/PICKUPS
		m = "chests/";
		p = m;
			
			 // Cursed Ammo Chests:
			CursedAmmoChest	            = sprite(p + "sprCursedAmmoChest",              1,  8,  8, shn16);
			CursedAmmoChestOpen         = sprite(p + "sprCursedAmmoChestOpen",          1,  8,  8);
			CursedAmmoChestSteroids 	= sprite(p + "sprCursedAmmoChestSteroids",      1, 12, 12, shn20);
			CursedAmmoChestSteroidsOpen = sprite(p + "sprCursedAmmoChestSteroidsOpen",  1, 12, 12);
			CursedMimicIdle             = sprite(p + "sprCursedMimicIdle",              1, 16, 16);
			CursedMimicFire             = sprite(p + "sprCursedMimicFire",              4, 16, 16);
			CursedMimicHurt             = sprite(p + "sprCursedMimicHurt",              3, 16, 16);
			CursedMimicDead             = sprite(p + "sprCursedMimicDead",              6, 16, 16);
			CursedMimicTell             = sprite(p + "sprCursedMimicTell",             12, 16, 16);
			
			 // Backpack:
			Backpack           = sprite(p + "sprBackpack",           1, 8, 8, shn16);
			BackpackCursed     = sprite(p + "sprBackpackCursed",     1, 8, 8, shn16);
			BackpackOpen       = sprite(p + "sprBackpackOpen",       1, 8, 8);
			BackpackCursedOpen = sprite(p + "sprBackpackCursedOpen", 1, 8, 8);
			
			 // Deceased Backpacker:
			Backpacker = sprite(p + "sprBackpacker", 3, 12, 12);
			
			 // Bat/Cat Chests:
			BatChest              = sprite(p + "sprBatChest",              1, 10, 10, shn20);
			BatChestCursed        = sprite(p + "sprBatChestCursed",        1, 10, 10, shn20);
			BatChestBig           = sprite(p + "sprBatChestBig",           1, 12, 12, shn24);
			BatChestBigCursed     = sprite(p + "sprBatChestBigCursed",     1, 12, 12, shn24);
			CatChest              = sprite(p + "sprCatChest",              1, 10, 10, shn20);
			BatChestOpen          = sprite(p + "sprBatChestOpen",          1, 10, 10);
			BatChestCursedOpen    = sprite(p + "sprBatChestCursedOpen",    1, 10, 10);
			BatChestBigOpen       = sprite(p + "sprBatChestBigOpen",       1, 12, 12);
			BatChestBigCursedOpen = sprite(p + "sprBatChestBigCursedOpen", 1, 12, 12);
			CatChestOpen          = sprite(p + "sprCatChestOpen",          1, 10, 10);
			
			 // Bone:
			BonePickup	  =[sprite(p + "sprBonePickup0",    1, 4, 4, shn8),
			                sprite(p + "sprBonePickup1",    1, 4, 4, shn8),
			                sprite(p + "sprBonePickup2",    1, 4, 4, shn8),
			                sprite(p + "sprBonePickup3",    1, 4, 4, shn8)];
			BonePickupBig =[sprite(p + "sprBoneBigPickup0", 1, 8, 8, shn16),
			                sprite(p + "sprBoneBigPickup1", 1, 8, 8, shn16)];
			
			 // Buried Vault:
			BuriedVaultTopTiny     = sprite(p + "sprVaultTopTiny",     12,  0,  0);
			BuriedVaultChest       = sprite(p + "sprVaultChest",        1, 12, 12, shn24);
			BuriedVaultChestOpen   = sprite(p + "sprVaultChestOpen",    1, 12, 12);
			BuriedVaultChestDebris = sprite(p + "sprVaultChestDebris",  8, 12, 12);
			BuriedVaultChestBase   = sprite(p + "sprVaultChestBase",    3, 16, 12);
			ProtoChestMerge        = sprite(p + "sprProtoChestMerge",   6, 12, 12);
			
			 // Orchid Chest:
			OrchidChest     = sprite(p + "sprOrchidChest",     1, 13, 8);
			OrchidChestOpen = sprite(p + "sprOrchidChestOpen", 1, 13, 8);
			
			 // Overstock/Overheal:
			BonusShell                 = sprite(p + "sprBonusShell",                  1,  1,  2);
			BonusShellHeavy            = sprite(p + "sprBonusShellHeavy",             1,  2,  3);
			BonusText                  = sprite(p + "sprBonusText",                  12,  0,  0);
			OverhealFX                 = sprite(p + "sprOverhealFX",                  7,  8, 10);
			OverhealBigFX              = sprite(p + "sprOverhealBigFX",               8, 12, 24);
			OverstockFX                = sprite(p + "sprOverstockFX",                13,  4, 12);
			OverhealPickup             = sprite(p + "sprOverhealPickup",              1,  5,  5, shn10);
			OverstockPickup            = sprite(p + "sprOverstockPickup",             1,  5,  5, shn10);
			OverhealChest              = sprite(p + "sprOverhealChest",              15,  8,  8);
			OverstockChest             = sprite(p + "sprOverstockChest",             15,  8,  8);
			OverstockChestSteroids     = sprite(p + "sprOverstockChestSteroids",     15, 12, 12);
			OverhealChestOpen          = sprite(p + "sprOverhealChestOpen",           1,  8,  8);
			OverstockChestOpen         = sprite(p + "sprOverstockChestOpen",          1,  8,  8);
			OverstockChestSteroidsOpen = sprite(p + "sprOverstockChestSteroidsOpen",  1, 12, 12);
			OverhealMimicIdle          = sprite(p + "sprOverhealMimicIdle",           1, 16, 16);
			OverhealMimicTell          = sprite(p + "sprOverhealMimicTell",          10, 16, 16);
			OverhealMimicHurt          = sprite(p + "sprOverhealMimicHurt",           3, 16, 16);
			OverhealMimicDead          = sprite(p + "sprOverhealMimicDead",           6, 16, 16);
			OverhealMimicFire          = sprite(p + "sprOverhealMimicFire",           4, 16, 16);
			OverstockMimicIdle         = sprite(p + "sprOverstockMimicIdle",          1, 16, 16);
			OverstockMimicTell         = sprite(p + "sprOverstockMimicTell",         12, 16, 16);
			OverstockMimicHurt         = sprite(p + "sprOverstockMimicHurt",          3, 16, 16);
			OverstockMimicDead         = sprite(p + "sprOverstockMimicDead",          6, 16, 16);
			OverstockMimicFire         = sprite(p + "sprOverstockMimicFire",          4, 16, 16);
			
			 // Spirit Pickup:
			SpiritPickup = sprite(p + "sprSpiritPickup", 1, 5, 5, shn10);
			
			 // Hammerhead Pickup:
			HammerHeadPickup		= sprite(p  + "sprHammerHeadPickup",		1, 5, 5, shn10);
			HammerHeadPickupEffect	= sprite(p + "sprHammerHeadPickupEffect",	3, 16, 8);
			
			 // Sunken Chest:
			SunkenChest     = sprite(p + "sprSunkenChest",     1, 12, 12, shn24);
			SunkenChestOpen = sprite(p + "sprSunkenChestOpen", 1, 12, 12);
			SunkenCoin      = sprite(p + "sprCoin",            1,  3,  3, shn8);
			SunkenCoinBig   = sprite(p + "sprCoinBig",         1,  3,  3, shn8);
			
			 // Merged Weapon Sprite Storage:
			MergeWep = {};
			MergeWepLoadout = {};
			MergeWepText = {};
			
		//#endregion
		
		//#region RACES
		m = "races/";
			
			var _list = {
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
						["FeatherHUD",    1,  5,   5, false]
					]
				},
					
				"bee" : {
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
				}
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
			AllyNecroReviveArea	= sprite(p + "sprAllyNecroReviveArea", 4, 17, 20);
			
		//#endregion
		
		//#region SKINS
		m = "skins/";
			
			 // Red Crystal:
			p = m + "CrystalRed/";
			CrystalRedPortrait        = sprite(p + "sprCrystalRedPortrait",        1, 20, 229);
			CrystalRedIdle            = sprite(p + "sprCrystalRedIdle",            4, 12,  12);
			CrystalRedWalk            = sprite(p + "sprCrystalRedWalk",            6, 12,  12);
			CrystalRedHurt            = sprite(p + "sprCrystalRedHurt",            3, 12,  12);
			CrystalRedDead            = sprite(p + "sprCrystalRedDead",            6, 12,  12);
			CrystalRedGoSit           = sprite(p + "sprCrystalRedGoSit",           3, 12,  12);
			CrystalRedSit             = sprite(p + "sprCrystalRedSit",             1, 12,  12);
			CrystalRedLoadout         = sprite(p + "sprCrystalRedLoadout",         2, 16,  16);
			CrystalRedMapIcon         = sprite(p + "sprCrystalRedMapIcon",         1, 10,  10);
			CrystalRedShield          = sprite(p + "sprCrystalRedShield",          4, 32,  42);
			CrystalRedShieldDisappear = sprite(p + "sprCrystalRedShieldDisappear", 6, 32,  42);
			CrystalRedShieldIdleFront = sprite(p + "sprCrystalRedShieldIdleFront", 1, 32,  42);
			CrystalRedShieldWalkFront = sprite(p + "sprCrystalRedShieldWalkFront", 8, 32,  42);
			CrystalRedShieldIdleBack  = sprite(p + "sprCrystalRedShieldIdleBack",  1, 32,  42);
			CrystalRedShieldWalkBack  = sprite(p + "sprCrystalRedShieldWalkBack",  8, 32,  42);
			CrystalRedTrail           = sprite(p + "sprCrystalRedTrail",           5,  8,   8);
			
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
			PetOrchidIcon   = sprite(p + "sprPetOrchidIcon",    1,  6,  6);
			PetOrchidIdle   = sprite(p + "sprPetOrchidIdle",   28, 12, 12);
			PetOrchidWalk   = sprite(p + "sprPetOrchidWalk",    6, 12, 12);
			PetOrchidHurt   = sprite(p + "sprPetOrchidHurt",    3, 12, 12);
			PetOrchidCharge = sprite(p + "sprPetOrchidCharge",  2, 12, 12);
			
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
			PetWeaponIconCursed = sprite(p + "sprPetWeaponIconCursed",  1,  6,  6);
			PetWeaponChstCursed = sprite(p + "sprPetWeaponChstCursed",  1,  8,  8);
			PetWeaponHideCursed = sprite(p + "sprPetWeaponHideCursed",  8, 12, 12);
			PetWeaponSpwnCursed = sprite(p + "sprPetWeaponSpwnCursed", 16, 12, 12);
			PetWeaponIdleCursed = sprite(p + "sprPetWeaponIdleCursed",  8, 12, 12);
			PetWeaponWalkCursed = sprite(p + "sprPetWeaponWalkCursed",  8, 12, 12);
			PetWeaponHurtCursed = sprite(p + "sprPetWeaponHurtCursed",  3, 12, 12);
			PetWeaponDeadCursed = sprite(p + "sprPetWeaponDeadCursed",  6, 12, 12);
			
			 // Twins:
			p = m + "Red/";
			PetTwinsIcon  = sprite(p + "sprPetTwinsIcon",  1,  6,  6);
			PetTwinsStat  = sprite(p + "sprPetTwinsStat",  6,  12, 12);
			PetTwinsRed	  = sprite(p + "sprPetTwinsRed",   6,  12, 12);
			PetTwinsWhite = sprite(p + "sprPetTwinsWhite", 6,  12, 12);
			
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
	}
	
	 // MUSIC //
	mus = {};
	with(mus){
		var p = "sounds/music/";
		amb = {};
		
		Placeholder     = sound_add(p + "musPlaceholder.ogg");
		amb.Placeholder = sound_add(p + "musPlaceholder.ogg");
		
		 // Areas:
		Coast  = sound_add(p + "musCoast.ogg");
		Trench = sound_add(p + "musTrench.ogg");
		Lair   = sound_add(p + "musLair.ogg");
		Red    = sound_add(p + "musRed.ogg");
		
		 // Bosses:
		SealKing      = sound_add(p + "musSealKing.ogg");
		BigShots      = sound_add(p + "musBigShots.ogg");
		PitSquid      = sound_add(p + "musPitSquid.ogg");
		PitSquidIntro = sound_add(p + "musPitSquidIntro.ogg");
	}
	
	 // SAVE FILE //
	global.sav_auto = false;
	sav = {
		option : {
			"allowShaders"     : true,
			"remindPlayer"     : true,
			"intros"           : 2,
			"outlinePets"      : 2,
			"outlineCharm"     : 2,
			"waterQualityMain" : 1,
			"waterQualityTop"  : 1
		}
	};
	
	if(fork()){
		 // Load Existing Save:
		var _path = savPath;
		wait file_load(_path);
		
		if(file_loaded(_path) && file_exists(_path)){
			var _save = json_decode(string_load(_path));
			if(_save != json_error){
				 // Defaulterize Options:
				if("option" in _save){
					for(var j = 0; j < lq_size(opt); j++){
						var _name = lq_get_key(opt, j);
						if(_name not in _save.option){
							lq_set(_save.option, _name, lq_get_value(opt, j));
						}
					}
				}
				
				 // Copy Vars From Save File:
				for(var i = 0; i < lq_size(_save); i++){
					lq_set(global.sav, lq_get_key(_save, i), lq_get_value(_save, i));
				}
				
				global.sav_auto = true;
				exit;
			}
			
			 // Save File Corrupt:
			else{
				string_save(string_load(_path), "saveCORRUPT.sav");
				if(fork()){
					while(mod_exists("mod", "teloader")) wait 0;
					wait 1;
					trace_color("NTTE | Something isn't right with your save file... creating a new one and moving old to 'saveCORRUPT.sav'.", c_red);
					exit;
				}
			}
		}
		
		 // New Save File:
		save();
		global.sav_auto = true;
		exit;
	}
	
	 // Surface Storage:
	surfList = [];
	
	 // Shader Storage:
	shadList = [];
	
	 // Mod Lists:
	areaList = ["coast", "oasis", "lair", "pizza", "red", "trench"];
	raceList = ["parrot", "bee"];
	crwnList = ["bonus", "crime", "red"];
	wepsList = ["bat disc cannon", "bat disc launcher", "bat tether", "big throw", "bubble cannon", "bubble minigun", "bubble rifle", "bubble shotgun", "clam shield", "crabbone", "electroplasma rifle", "electroplasma shotgun", "harpoon launcher", "hyper bubbler", "lightring launcher", "merge", "net launcher", "quasar blaster", "quasar cannon", "quasar rifle", "red rifle", "scythe", "super lightring launcher", "tesla coil", "trident"];
	
	 // Reminders:
	global.remind = [];
	if(fork()){
		while(mod_exists("mod", "teloader")) wait 0;
		
		trace_color("NTTE | Finished loading!", c_yellow);
		repeat(20 * (game_height / 240)) trace("");
		
		if(lq_defget(opt, "remindPlayer", true)){
			global.remind = [
				{   "pos" : [-85, -2],
					"but" : GameMenuButton,
					"txt" : "Turn em on!",
					"rem" : (!UberCont.opt_bossintros && opt.intros >= 2)
					},
				{   "pos" : [-85, 29],
					"but" : AudioMenuButton,
					"txt" : "Pump it up!",
					"rem" : (!UberCont.opt_bossintros)
					}
			];
			
			with(global.remind){
				txt_inst = noone;
				tim = 0;
			}
			
			 // Chat Reminder:
			var _text = "";
			if(global.remind[0].rem){
				_text = "enable boss intros and music";
			}
			else{
				_text = "make sure music is on";
			}
			if(_text != ""){
				trace_color("NTTE | For the full experience - " + _text + "!", c_yellow);
			}
		}
		exit;
	}
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.sav
#macro opt sav.option

#macro sprLoad global.spr_load

#macro shnWep true
#macro shn8   spr.Shine8
#macro shn10  spr.Shine10
#macro shn12  spr.Shine12
#macro shn16  spr.Shine16
#macro shn20  spr.Shine20
#macro shn24  spr.Shine24
#macro shn64  spr.Shine64

#macro areaList global.area
#macro raceList global.race
#macro crwnList global.crwn
#macro wepsList global.weps

#macro surfList global.surf
#macro shadList global.shad

#macro savPath "save.sav"

#define save()
	if(player_is_local_nonsync(player_find_local_nonsync())){
		string_save(json_encode(sav), savPath);
	}
	
#define surflist_set(_name, _x, _y, _width, _height)
	var _surf = surflist_get(_name);
	
	_width  = max(1, _width);
	_height = max(1, _height);
	
	 // Add to List:
	if(_surf == noone){
		_surf = {
			name    : _name,
			active  : true,
			surf    : -1,
			wave	: 0,
			x       : 0,
			y       : 0,
			w       : 0,
			h       : 0
		};
		array_push(surfList, _surf);
	}
	
	 // Set Vars:
	with(_surf){
		x = _x;
		y = _y;
		w = _width;
		h = _height;
	}
	
	return _surf;
	
#define surflist_get(_name)
	with(surfList) if(name == _name) return self;
	return noone;
	
#define shadlist_set(_name, _vertex, _fragment)
	var _shad = shadlist_get(_name);
	
	if(_shad == noone){
		_shad = {
			name : _name,
			shad : -1,
			vert : "",
			frag : ""
		};
		array_push(shadList, _shad);
	}
	
	with(_shad){
		shad = -1;
		vert = _vertex;
		frag = _fragment;
	}
	
	return _shad;
	
#define shadlist_get(_name)
	with(shadList) if(name == _name) return self;
	return noone;
	
#define sprite /// sprite(_path, _img, _x, _y, _shine = false)
	var _path = argument[0], _img = argument[1], _x = argument[2], _y = argument[3];
var _shine = argument_count > 4 ? argument[4] : false;
	
	sprLoad = [[spr, 0]];
	
	return {
		path  : "sprites/" + _path,
		img	  : _img,
		x     : _x,
		y     : _y,
		ext	  : "png",
		mask  : [],
		shine : _shine
	};
	
#define step
	 // Sprite Loading:
	if(array_length(sprLoad) > 0){
		repeat(20){
			while(array_length(sprLoad) > 0){
				var	m = array_length(sprLoad) - 1,
					_list = sprLoad[m, 0],
					_index = sprLoad[m, 1];
					
				if(_index < lq_size(_list) || _index < array_length(_list)){
					sprLoad[m, 1]++;
					
					var _spr = null;
					if(is_object(_list)){
						_spr = lq_get_value(_list, _index);
					}
					else if(is_array(_list)){
						_spr = _list[_index];
					}
					
					 // Load Sprite:
					if(is_object(_spr) && "path" in _spr){
						var	_img	= lq_defget(_spr, "img",	1),
							_x		= lq_defget(_spr, "x",		0),
							_y		= lq_defget(_spr, "y",		0),
							_ext	= lq_defget(_spr, "ext",	"png"),
							_mask	= lq_defget(_spr, "mask",	[]),
							_shine	= lq_defget(_spr, "shine",	false),
							_path	= _spr.path + "." + _ext,
							s;
							
						if(fork()){
							if(!_shine){
								s = sprite_add(_path, _img, _x, _y);
							}
							
							 // Add Shine:
							else{
								 // Normal:
								if(!sprite_exists(_shine) || _shine == true){
									s = sprite_add_weapon(_path, _x, _y);
								}
								
								 // Semi-Manual Shine (sprite_add_weapon is wack with taller sprites):
								else{
									 // Wait for Sprite to Load:
									var	_base = sprite_add(_path, _img, _x, _y),
										_waitTex = sprite_get_texture(_base, 0),
										_waitMax = 150;
										
									while(_waitMax-- > 0 && sprite_get_texture(_base, 0) == _waitTex){
										wait 0;
									}
									
									 // Add Shine:
									s = sprite_shine(_base, _shine);
									sprite_delete(_base);
								}
							}
							
							 // Store Sprite:
							if(is_object(_list)){
								lq_set(_list, lq_get_key(_list, _index), s);
							}
							else{
								_list[_index] = s;
							}
							
							 // Precise Hitboxes:
							if(array_length(_mask) > 0){
								 // Wait for Sprite to Load:
								var	_waitTex = sprite_get_texture(s, 0),
									_waitMax = 150;
									
								while(_waitMax-- > 0 && sprite_get_texture(s, 0) == _waitTex){
									wait 0;
								}
								
								 // Collision Time:
								while(array_length(_mask) < 9) array_push(_mask, 0);
								sprite_collision_mask(s, _mask[0], _mask[1], _mask[2], _mask[3], _mask[4], _mask[5], _mask[7], _mask[8]);
							}
							
							exit;
						}
						
						break;
					}
					
					 // Search Deeper:
					else if(is_object(_spr) || is_array(_spr)){
						array_push(sprLoad, [_spr, 0]);
					}
				}
				
				 // Go Back:
				else sprLoad = array_slice(sprLoad, 0, m);
			}
		}
	}
	
	 // Locked Weapon Spriterize:
	with(wepsList){
		var _name = self;
		if(mod_variable_get("weapon", _name, "sprWepLocked") == mskNone){
			var _spr = mod_variable_get("weapon", _name, "sprWep");
			if(sprite_get_number(_spr) != 1 || sprite_get_width(_spr) != 16 || sprite_get_height(_spr) != 16){
				with(other) mod_variable_set("weapon", _name, "sprWepLocked", wep_locked_sprite(_spr));
			}
		}
	}
	
	 // Autosave:
	if(global.sav_auto){
		with(instances_matching(GameCont, "ntte_autosave", null)){
			save();
			ntte_autosave = true;
		}
	}
	
#define draw_gui_end
	 // Surface Setup:
	with(surfList){
		 // Create/Resize:
		if(active){
			if(!surface_exists(surf) || surface_get_width(surf) != w || surface_get_height(surf) != h){
				surface_destroy(surf);
				surf = surface_create(w, h);
				if("reset" in self) reset = true;
			}
		}
		
		 // Not Being Used, Destroy:
		else if(surface_exists(surf)){
			surface_destroy(surf);
		}
	}
	
	 // Shader Setup:
	if(lq_defget(opt, "allowShaders", true)){
		if(!instance_exists(Menu)){
			with(shadList){
				if(shad == -1){
					try{
						shad = shader_create(vert, frag);
					}
					catch(_error){
						trace(shad);
						trace(_error);
						shad = -1;
					}
				}
			}
		}
	}
	else with(shadList){
		if(shad != -1){
			shader_destroy(shad);
			shad = -1;
		}
	}
	
#define draw_pause
	 // Reset Surfaces:
	with(surfList) if(active && "reset" in self){
		reset = true;
	}
	
	
	draw_set_projection(0);
	
	 // Remind Player:
	if(lq_defget(opt, "remindPlayer", false)){
		var d = current_time_scale;
		with(global.remind){
			if(rem){
				var	_x = (game_width  / 2),
					_y = (game_height / 2) - 40;
					
				if(instance_exists(but)){
					_x += pos[0];
					_y += pos[1];
					
					if(tim > 0){
						tim -= d;
						d = 0;
						if(tim <= 0){
							rem = false;
							
							txt_inst = instance_create(_x, _y, PopupText);
							with(txt_inst){
								text = other.txt;
								friction = 0.1;
							}
						}
					}
				}
				
				else{
					tim = 20;
					
					if(instance_exists(OptionMenuButton)){
						_x -= 38;
						switch(but){
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
					
					else if(instance_number(PauseButton) > 2){
						var b = false;
						with(PauseButton) if(alarm_get(0) > 0) b = true;
						if(b) break;
						
						_x = game_width - 124;
						_y = game_height - 78;
					}
					
					else continue;
				}
				
				with(other) draw_sprite(sprNew, 0, _x, _y + sin(current_frame / 10));
			}
			
			 // Text:
			if(instance_exists(txt_inst)){
				d = 0.5 * current_time_scale;
				
				draw_set_font(fntM);
				draw_set_halign(fa_center);
				draw_set_valign(fa_top);
				with(txt_inst) if(visible){
					draw_text_nt(x, y, text);
				}
			}
		}
	}
	
	draw_reset_projection();
	
#define sprite_shine(_spr, _sprShine)
	var _img = sprite_get_number(_spr);
	if(_img <= 1) _img = sprite_get_number(_sprShine);
	
	var	_ox = sprite_get_xoffset(_spr),
		_oy = sprite_get_yoffset(_spr),
		_surfw = sprite_get_width(_spr),
		_surfh = sprite_get_height(_spr),
		_surf = surface_create(_surfw * _img, _surfh);
		
	surface_set_target(_surf);
	draw_clear_alpha(0, 0);
	
	for(var i = 0; i < _img; i++){
		var	_x = (_surfw * i),
			_y = 0;
			
		draw_sprite(_spr, i, _x + _ox, _y + _oy);
		
		 // Overlay Shine:
		var	_shineSiz = max(_surfw, _surfh),
			_shineImg = i,
			s = 2;
			
		if(i >= s){
			_shineImg = lerp(s, sprite_get_number(_sprShine), (i - s) / (_img - s));
		}
		
		draw_set_color_write_enable(true, true, true, false);
		draw_sprite_stretched(_sprShine, _shineImg, _x, _y, _shineSiz, _shineSiz);
		draw_set_color_write_enable(true, true, true, true);
	}
	
	surface_reset_target();
	surface_save(_surf, "sprShine.png");
	surface_destroy(_surf);
	
	return sprite_add("sprShine.png", _img, _ox, _oy);
	
#define weapon_merge_sprite(_stock, _front) // Doing this here so that the sprite doesnt get unloaded with merge.wep
	var _sprName = sprite_get_name(_stock) + "|" + sprite_get_name(_front);
	if(lq_exists(spr.MergeWep, _sprName)){
		return lq_get(spr.MergeWep, _sprName);
	}
	
	 // Initial Setup:
	else if(sprite_exists(_stock) && sprite_exists(_front)){
		var	_spr = [_stock, _front],
			_sprW = [],
			_sprH = [];
			
		for(var i = 0; i < array_length(_spr); i++){
			_sprW[i] = sprite_get_width(_spr[i]);
			_sprH[i] = sprite_get_height(_spr[i]);
		}
		
		var	_surfW = max(_sprW[0], _sprW[1]),
			_surfH = max(_sprH[0], _sprH[1]),
			_surf = surface_create(_surfW, _surfH);
			
		surface_set_target(_surf);
		draw_clear_alpha(0, 0);
		
		with(other){
			for(var b = false; b <= true; b++){
				var	_dx = 0,
					_dy = _surfH / 3;
					
				for(var i = 0; i <= 1; i++){
					var	_cut = (ceil(_sprW[i] / 2) + 2) - ceil(_sprW[i] / 8),
						l = _cut * i,
						w = (i ? _sprW[i] - _cut : _cut),
						t = 0,
						h = _sprH[i],
						_x = _dx,
						_y = _dy - sprite_get_yoffset(_spr[i]);
						
					switch(_spr[i]){
						case sprAutoShotgun:
							_y += 1;
							break;
							
						case sprAutoCrossbow:
						case sprSuperCrossbow:
						case sprGatlingSlugger:
							_y -= 1;
							break;
							
						case sprToxicBow:
							_y -= 2;
							break;
					}
					
					if(b){
						draw_sprite_part_ext(_spr[i], 0, l, t, w, h, _x, _y, 1, 1, c_white, 1);
					}
					else{
						draw_sprite_part_ext(_spr[i], 0, _cut - !i, t, 1, h, _x + (_cut - l) - i, _y, 1, 1, c_black, 1);
					}
					_dx += _cut;
				}
			}
		}
		
		surface_reset_target();
		surface_save(_surf, "sprMerge.png");
		surface_destroy(_surf);
		
		var s = sprite_add_weapon("sprMerge.png", 2, _surfH / 3);
		lq_set(spr.MergeWep, _sprName, s);
		return s;
	}
	
	return -1;
	
#define weapon_merge_sprite_loadout(_stock, _front) // Doing this here so that the sprite doesnt get unloaded with merge.wep
	var _sprName = sprite_get_name(_stock) + "|" + sprite_get_name(_front);
	if(lq_exists(spr.MergeWepLoadout, _sprName)){
		return lq_get(spr.MergeWepLoadout, _sprName);
	}
	
	 // Initial Setup:
	else if(sprite_exists(_stock) && sprite_exists(_front) && _stock > 0 && _front > 0){
		var	_spr = [_stock, _front],
			_sprW = array_create(array_length(_spr), 0),
			_sprH = array_create(array_length(_spr), 0),
			_surfW = 0,
			_surfH = 0;
			
		for(var i = 0; i < array_length(_spr); i++){
			_sprW[i] = sprite_get_width(_spr[i]);
			_sprH[i] = sprite_get_height(_spr[i]);
			_surfW = max(_surfW, _sprW[i]);
			_surfH = max(_surfH, _sprH[i]);
		}
		
		var _surf = surface_create(_surfW, _surfH);
		surface_set_target(_surf);
		draw_clear_alpha(0, 0);
		
		draw_set_color(c_white);
		
		 // Draw Sprite Halves:
		for(var i = 0; i < array_length(_spr); i++){
			var	_uvs = sprite_get_uvs(_spr[i], 0),
				_uvsExists = (_uvs[0] != 0 || _uvs[1] != 0 || _uvs[2] != 1 || _uvs[3] != 1),
				_x = floor(_surfW / 2) - sprite_get_xoffset(_spr[i]) + (_uvsExists ? _uvs[4] : sprite_get_bbox_left(_spr[i])),
				_y = floor(_surfH / 2) - sprite_get_yoffset(_spr[i]) + (_uvsExists ? _uvs[5] : sprite_get_bbox_top(_spr[i])),
				_w = (_uvsExists ? (_sprW[i] * _uvs[6]) : (sprite_get_bbox_right(_spr[i]) - sprite_get_bbox_left(_spr[i]))),
				_h = (_uvsExists ? (_sprH[i] * _uvs[7]) : (sprite_get_bbox_bottom(_spr[i]) - sprite_get_bbox_top(_spr[i]))),
				_cutDis = _w / 3,
				_cutDir = 20,
				_ox = (_h / 2) * dtan(_cutDir);
				
			if(i == 1){
				_cutDis = _w - _cutDis;
			}
			_cutDis += 2;
			
			draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(_spr[i], 0));
			
			with([ // [x, y]
				[0,             0 ],
				[_cutDis - _ox, 0 ],
				[0,             _h],
				[_cutDis + _ox, _h]
			]){
				var _pos = self;
				
				 // Flip:
				if(i == 1){
					_pos[0] = _w - _pos[0];
					_pos[1] = _h - _pos[1];
				}
				
				 // Draw Vertex:
				var	_dx = _pos[0] + _x,
					_dy = _pos[1] + _y;
					
				draw_vertex_texture(_dx, _dy, _pos[0] / _w, _pos[1] / _h);
			}
			
			draw_primitive_end();
		}
		
		 // Save Sprite:
		surface_reset_target();
		surface_save(_surf, "sprMergeLoadout.png");
		surface_destroy(_surf);
		
		 // Add Sprite:
		var s = sprite_add_weapon("sprMergeLoadout.png", _surfW / 2, _surfH / 2);
		lq_set(spr.MergeWepLoadout, _sprName, s);
		
		return s;
	}
	
	return -1;
	
#define weapon_merge_subtext(_stock, _front) // Doing this here so that the sprite doesnt get unloaded with ntte.mod
	var _sprName = sprite_get_name(_stock) + "|" + sprite_get_name(_front);
	if(lq_exists(spr.MergeWepText, _sprName)){
		return lq_get(spr.MergeWepText, _sprName);
	}
	
	 // Initial Setup:
	else{
		draw_set_font(fntSmall);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		
		var	_text = weapon_get_name(_stock) + " + " + weapon_get_name(_front),
			_topSpace = 2,
			_surfw = string_width(_text) + 4,
			_surfh = string_height(_text) + 2 + _topSpace,
			_surf = surface_create(_surfw, _surfh);
			
		surface_set_target(_surf);
		draw_clear_alpha(0, 0);
		
		 // Background:
		var	_x1 = -1,
			_y1 = -1,
			_x2 = _x1 + _surfw,
			_y2 = _y1 + _surfh;
			
		draw_set_alpha(0.8);
		draw_set_color(c_black);
		draw_roundrect_ext(_x1, _y1 + _topSpace, _x2, _y2, 5, 5, false);
		draw_set_alpha(1);
		
		 // Text:
		draw_text_nt(floor(_surfw / 2), floor((_surfh + _topSpace) / 2), _text);
		
		 // Save Sprite:
		surface_reset_target();
		surface_save(_surf, "sprMergeText.png");
		surface_destroy(_surf);
		var s = sprite_add("sprMergeText.png", 1, (_surfw / 2), (_surfh / 2));
		lq_set(spr.MergeWepText, _sprName, s);
		
		return s;
	}

#define wep_locked_sprite(_sprite)
	var	_surfW = sprite_get_width(_sprite) + 2,
		_surfH = sprite_get_height(_sprite) + 2,
		_surf = surface_create(_surfW, _surfH),
		_x = sprite_get_xoffset(_sprite) + 1,
		_y = sprite_get_yoffset(_sprite) + 1;
		
	surface_set_target(_surf);
	
	 // Outline:
	d3d_set_fog(true, c_white, 0, 0);
	for(var d = 0; d < 360; d += 90){
		draw_sprite(_sprite, 0, _x + dcos(d), _y + dsin(d));
	}
	
	 // Main:
	d3d_set_fog(true, c_black, 0, 0);
	draw_sprite(_sprite, 0, _x, _y);
	d3d_set_fog(false, 0, 0, 0);
	
	 // Save Sprite:
	surface_reset_target();
	surface_save(_surf, "sprLockedWep.png");
	surface_destroy(_surf);
	return sprite_add_weapon("sprLockedWep.png", _x, _y);
	
#define cleanup
	if(global.sav_auto) save();
	
	 // Clear Surfaces/Shaders:
	with(surfList) if(surf != -1) surface_destroy(surf);
	with(shadList) if(shad != -1) shader_destroy(shad);
	
	 // No Crash:
	with(raceList){
		with(instances_matching([CampChar, CharSelect], "race", self)){
			repeat(8) with(instance_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), Dust)){
				motion_add(random(360), random(random(8)));
			}
			instance_delete(id);
		}
	}