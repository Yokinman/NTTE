#define init
     // SPRITES //
    global.spr = {};
    with(global.spr){
        msk = {};

         // Top Decals:
        TopDecal = {
            "trench" : sprite_add("sprites/areas/Trench/sprTopDecalTrench.png", 2, 19, 24)
        }
        TopDecalMine = sprite_add("sprites/areas/Trench/sprTopDecalMine.png", 12, 12, 36);
        NestDebris = sprite_add("sprites/areas/Scrapyard/sprNestDebris.png", 16, 4, 4);

         // Backpack:
        Backpack            = sprite_add("sprites/chests/sprBackpack.png",            1, 8, 8);
        BackpackOpen        = sprite_add("sprites/chests/sprBackpackOpen.png",        1, 8, 8);
        BackpackCursed      = sprite_add("sprites/chests/sprBackpackCursed.png",      1, 8, 8);
        BackpackCursedOpen  = sprite_add("sprites/chests/sprBackpackCursedOpen.png",  1, 8, 8);
        
         // Bat Discs:
        BatDisc         = sprite_add("sprites/weps/projectiles/sprBatDisc.png",         2,  9,  9);
        BatDiscBig      = sprite_add("sprites/weps/projectiles/sprBatDiscBig.png",      2, 14, 14);
        BigDiscTrail    = sprite_add("sprites/weps/projectiles/sprBigDiscTrail.png",    3, 12, 12);
        
         // Bat Lightning:
        BatLightning        = sprite_add("sprites/weps/projectiles/sprBatLightning.png",        4,  0,  1);
        BatLightningHit     = sprite_add("sprites/weps/projectiles/sprBatLightningHit.png",     4, 12, 12);

    	 // Big Decals:
    	BigTopDecal = {
    	    "1"     : sprite_add("sprites/areas/Desert/sprDesertBigTopDecal.png",       1, 32, 24),
    	    "2"     : sprite_add("sprites/areas/Sewers/sprSewersBigTopDecal.png",       8, 32, 24),
    	    "3"     : sprite_add("sprites/areas/Scrapyard/sprScrapyardBigTopDecal.png", 1, 32, 24),
    	    "4"     : sprite_add("sprites/areas/Caves/sprCavesBigTopDecal.png",         1, 32, 24),
    	    "104"   : sprite_add("sprites/areas/Caves/sprCursedCavesBigTopDecal.png",   1, 32, 24),
    	    "pizza" : sprite_add("sprites/areas/Pizza/sprPizzaBigTopDecal.png",         1, 32, 24),
    	    "oasis" : sprite_add("sprites/areas/Oasis/sprOasisBigTopDecal.png",         1, 32, 24),
    	    "trench": sprite_add("sprites/areas/Trench/sprTrenchBigTopDecal.png",       1, 32, 24)
    	}
    	msk.BigTopDecal = sprite_add("sprites/areas/Desert/mskBigTopDecal.png", 1, 32, 24);

    	 // Big Fish:
    	BigFishBecomeIdle   = sprite_add("sprites/enemies/CoastBoss/sprBigFishBuild.png",      4, 40, 38);
    	BigFishBecomeHurt   = sprite_add("sprites/enemies/CoastBoss/sprBigFishBuildHurt.png",  4, 40, 38);
    	BigFishSpwn         = sprite_add("sprites/enemies/CoastBoss/sprBigFishSpawn.png",     11, 32, 32);
    	BigFishLeap         = sprite_add("sprites/enemies/CoastBoss/sprBigFishLeap.png",      11, 32, 32);
    	BigFishSwim         = sprite_add("sprites/enemies/CoastBoss/sprBigFishSwim.png",       8, 24, 24);
    	BigFishRise         = sprite_add("sprites/enemies/CoastBoss/sprBigFishRise.png",       5, 32, 32);
    	BigFishSwimFrnt     = sprite_add("sprites/enemies/CoastBoss/sprBigFishSwimFront.png",  6,  4,  1);
    	BigFishSwimBack     = sprite_add("sprites/enemies/CoastBoss/sprBigFishSwimBack.png",  11,  5,  1);

         // Bone:
        Bone = sprite_add("sprites/weps/sprBone.png", 1, 6, 6);
        BoneShard = sprite_add("sprites/weps/projectiles/sprBoneShard.png", 1, 3, 2);
        
         // Electroplasma:
        ElectroPlasma       = sprite_add("sprites/weps/projectiles/sprElectroPlasma.png",       5,  12, 12);
        ElectroPlasmaTrail  = sprite_add("sprites/weps/projectiles/sprElectroPlasmaTrail.png",  3,  4,  4);
        ElectroPlasmaImpact = sprite_add("sprites/weps/projectiles/sprElectroPlasmaImpact.png", 7,  12, 12);
        ElectroPlasmaTether = sprite_add("sprites/weps/projectiles/sprElectroPlasmaTether.png", 4,  0,  1);

         // Fly:
        FlySpin = sprite_add("sprites/misc/sprFlySpin.png", 16, 4, 4);

         // Harpoon:
        Harpoon      = sprite_add_weapon("sprites/weps/projectiles/sprHarpoon.png", 4, 3);
        NetNade      = sprite_add("sprites/weps/projectiles/sprNetNade.png", 1, 3, 3);
        NetNadeBlink = sprite_add("sprites/weps/projectiles/sprNetNadeBlink.png", 2, 3, 3);

         // Bubble Bombs:
    	BubbleBomb      = sprite_add("sprites/enemies/projectiles/sprBubbleBomb.png",     30,  8,  8);
    	BubbleExplode   = sprite_add("sprites/enemies/projectiles/sprBubbleExplode.png",   9, 24, 24);
    	BubbleCharge    = sprite_add("sprites/enemies/projectiles/sprBubbleCharge.png",   12, 12, 12);
    	BubbleBombBig   = sprite_add("sprites/weps/projectiles/sprBubbleBombBig.png",     46, 16, 16);

         // Menu:
        OptionNTTE = sprite_add("sprites/menu/sprOptionNTTE.png", 1, 32, 12);
        MenuNTTE   = sprite_add("sprites/menu/sprMenuNTTE.png",   1, 20,  9);

         // Quasar Beam:
        QuasarBeam      = sprite_add("sprites/weps/projectiles/sprQuasarBeam.png",      2,  0, 10);
        QuasarBeamStart = sprite_add("sprites/weps/projectiles/sprQuasarBeamStart.png", 2, 32, 16);
        QuasarBeamEnd   = sprite_add("sprites/weps/projectiles/sprQuasarBeamEnd.png",   2,  0, 16);
        QuasarBeamHit   = sprite_add("sprites/weps/projectiles/sprQuasarBeamHit.png",   6,  24, 24);
        QuasarBeamTrail = sprite_add("sprites/weps/projectiles/sprQuasarBeamTrail.png", 3,  4,  4);
        msk.QuasarBeam  = sprite_add("sprites/weps/projectiles/mskQuasarBeam.png",      1, 32, 16);

         // Small Green Explo:
        SmallGreenExplosion = sprite_add("sprites/weps/projectiles/sprSmallGreenExplosion.png", 7, 12, 12);

         // Trident:
    	Trident     = sprite_add_weapon("sprites/weps/sprTrident.png",          11, 6);
    	msk.Trident = sprite_add("sprites/weps/projectiles/mskTrident.png",  1, 11, 6);

         // Bonus Ammo Shell:
        BonusShell      = sprite_add("sprites/misc/sprBonusShell.png",      1, 1, 2);
        BonusShellHeavy = sprite_add("sprites/misc/sprBonusShellHeavy.png", 1, 2, 3);

        //#region CAMPFIRE
             // Big Cactus:
            BigNightCactusIdle = sprite_add("sprites/areas/Campfire/Props/sprBigNightCactusIdle.png", 1, 16, 16);
            BigNightCactusHurt = sprite_add("sprites/areas/Campfire/Props/sprBigNightCactusHurt.png", 3, 16, 16);
            BigNightCactusDead = sprite_add("sprites/areas/Campfire/Props/sprBigNightCactusDead.png", 4, 16, 16);
        //#endregion

        //#region DESERT
             // Baby Scorpion:
        	BabyScorpionIdle = sprite_add("sprites/enemies/BabyScorpion/sprBabyScorpionIdle.png", 4, 16, 16);
        	BabyScorpionWalk = sprite_add("sprites/enemies/BabyScorpion/sprBabyScorpionWalk.png", 6, 16, 16);
        	BabyScorpionHurt = sprite_add("sprites/enemies/BabyScorpion/sprBabyScorpionHurt.png", 3, 16, 16);
        	BabyScorpionDead = sprite_add("sprites/enemies/BabyScorpion/sprBabyScorpionDead.png", 6, 16, 16);
        	BabyScorpionFire = sprite_add("sprites/enemies/BabyScorpion/sprBabyScorpionFire.png", 6, 16, 16);

        	 // Golden Baby Scorp:
        	BabyScorpionGoldIdle = sprite_add("sprites/enemies/BabyScorpionGold/sprBabyScorpionGoldIdle.png", 4, 16, 16);
        	BabyScorpionGoldWalk = sprite_add("sprites/enemies/BabyScorpionGold/sprBabyScorpionGoldWalk.png", 6, 16, 16);
        	BabyScorpionGoldHurt = sprite_add("sprites/enemies/BabyScorpionGold/sprBabyScorpionGoldHurt.png", 3, 16, 16);
        	BabyScorpionGoldDead = sprite_add("sprites/enemies/BabyScorpionGold/sprBabyScorpionGoldDead.png", 6, 16, 16);
        	BabyScorpionGoldFire = sprite_add("sprites/enemies/BabyScorpionGold/sprBabyScorpionGoldFire.png", 6, 16, 16);

        	 // Big Cactus:
        	BigCactusIdle = sprite_add("sprites/areas/Desert/Props/sprBigCactusIdle.png", 1, 16, 16);
        	BigCactusHurt = sprite_add("sprites/areas/Desert/Props/sprBigCactusHurt.png", 3, 16, 16);
        	BigCactusDead = sprite_add("sprites/areas/Desert/Props/sprBigCactusDead.png", 4, 16, 16);

             // Big Maggot Nest:
            BigMaggotSpawnIdle = sprite_add("sprites/enemies/BigMaggotNest/sprBigMaggotNestIdle.png", 4, 32, 32);
            BigMaggotSpawnHurt = sprite_add("sprites/enemies/BigMaggotNest/sprBigMaggotNestHurt.png", 3, 32, 32);
            BigMaggotSpawnDead = sprite_add("sprites/enemies/BigMaggotNest/sprBigMaggotNestDead.png", 3, 32, 32);
            BigMaggotSpawnChrg = sprite_add("sprites/enemies/BigMaggotNest/sprBigMaggotNestChrg.png", 4, 32, 32);
            
        	 // Scorpion Rock:
        	ScorpionRockEnemy   = sprite_add("sprites/areas/Desert/Props/sprScorpionRockEnemy.png",     6, 16, 16);
        	ScorpionRockFriend  = sprite_add("sprites/areas/Desert/Props/sprScorpionRockFriend.png",    6, 16, 16);
        	ScorpionRockHurt    = sprite_add("sprites/areas/Desert/Props/sprScorpionRockHurt.png",      3, 16, 16);
        	ScorpionRockDead    = sprite_add("sprites/areas/Desert/Props/sprScorpionRockDead.png",      6, 16, 16);
        //#endregion

        //#region COAST
             // Blooming Cactus:
        	BloomingCactusIdle[0] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus.png",      1, 12, 12);
        	BloomingCactusHurt[0] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactusHurt.png",  3, 12, 12);
        	BloomingCactusDead[0] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactusDead.png",  4, 12, 12);
        	BloomingCactusIdle[1] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus2.png",     1, 12, 12);
        	BloomingCactusHurt[1] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus2Hurt.png", 3, 12, 12);
        	BloomingCactusDead[1] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus2Dead.png", 4, 12, 12);
        	BloomingCactusIdle[2] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus3.png",     1, 12, 12);
        	BloomingCactusHurt[2] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus3Hurt.png", 3, 12, 12);
        	BloomingCactusDead[2] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus3Dead.png", 4, 12, 12);
        	
        	 // Big Blooming Cactus:
        	BigBloomingCactusIdle = sprite_add("sprites/areas/Coast/Props/sprBigBloomingCactusIdle.png", 1, 16, 16);
        	BigBloomingCactusHurt = sprite_add("sprites/areas/Coast/Props/sprBigBloomingCactusHurt.png", 3, 16, 16);
        	BigBloomingCactusDead = sprite_add("sprites/areas/Coast/Props/sprBigBloomingCactusDead.png", 4, 16, 16);

        	 // Buried Car:
        	BuriedCarIdle = sprite_add("sprites/areas/Coast/Props/sprBuriedCarIdle.png",1,16,16);
        	BuriedCarHurt = sprite_add("sprites/areas/Coast/Props/sprBuriedCarHurt.png",3,16,16);

             // Bush:
            BloomingBushIdle = sprite_add("sprites/areas/Coast/props/sprBloomingBushIdle.png", 1, 12, 12);
            BloomingBushHurt = sprite_add("sprites/areas/Coast/props/sprBloomingBushHurt.png", 3, 12, 12);
            BloomingBushDead = sprite_add("sprites/areas/Coast/props/sprBloomingBushDead.png", 3, 12, 12);

             // Bush Assassin:
            BloomingAssassinHide = sprite_add("sprites/enemies/BloomingAss/sprBloomingAssassinHide.png", 41, 16, 16);
            BloomingAssassinIdle = sprite_add("sprites/enemies/BloomingAss/sprBloomingAssassinIdle.png",  6, 16, 16);
            BloomingAssassinWalk = sprite_add("sprites/enemies/BloomingAss/sprBloomingAssassinWalk.png",  6, 16, 16);
            BloomingAssassinHurt = sprite_add("sprites/enemies/BloomingAss/sprBloomingAssassinHurt.png",  3, 16, 16);
            BloomingAssassinDead = sprite_add("sprites/enemies/BloomingAss/sprBloomingAssassinDead.png",  6, 16, 16);

             // Decal Big Shell Prop:
    	    ShellIdle = sprite_add("sprites/areas/Coast/Decals/sprShellIdle.png", 1, 32, 32);
    	    ShellHurt = sprite_add("sprites/areas/Coast/Decals/sprShellHurt.png", 3, 32, 32);
    	    ShellDead = sprite_add("sprites/areas/Coast/Decals/sprShellDead.png", 6, 32, 32);
    	    ShellBott = sprite_add("sprites/areas/Coast/Decals/sprShellBott.png", 1, 32, 32);
    	    ShellFoam = sprite_add("sprites/areas/Coast/Decals/sprShellFoam.png", 1, 32, 32);

             // Decal Water Rock Props:
            RockIdle[0] = sprite_add("sprites/areas/Coast/Decals/sprRock1Idle.png", 1, 16, 16);
            RockHurt[0] = sprite_add("sprites/areas/Coast/Decals/sprRock1Hurt.png", 3, 16, 16);
            RockDead[0] = sprite_add("sprites/areas/Coast/Decals/sprRock1Dead.png", 1, 16, 16);
            RockBott[0] = sprite_add("sprites/areas/Coast/Decals/sprRock1Bott.png", 1, 16, 16);
            RockFoam[0] = sprite_add("sprites/areas/Coast/Decals/sprRock1Foam.png", 1, 16, 16);
            RockIdle[1] = sprite_add("sprites/areas/Coast/Decals/sprRock2Idle.png", 1, 16, 16);
            RockHurt[1] = sprite_add("sprites/areas/Coast/Decals/sprRock2Hurt.png", 3, 16, 16);
            RockDead[1] = sprite_add("sprites/areas/Coast/Decals/sprRock2Dead.png", 1, 16, 16);
            RockBott[1] = sprite_add("sprites/areas/Coast/Decals/sprRock2Bott.png", 1, 16, 16);
            RockFoam[1] = sprite_add("sprites/areas/Coast/Decals/sprRock2Foam.png", 1, 16, 16);

             // Diver:
        	DiverIdle = sprite_add("sprites/enemies/Diver/sprDiverIdle.png", 4, 12, 12);
        	DiverWalk = sprite_add("sprites/enemies/Diver/sprDiverWalk.png", 6, 12, 12);
        	DiverHurt = sprite_add("sprites/enemies/Diver/sprDiverHurt.png", 3, 12, 12);
        	DiverDead = sprite_add("sprites/enemies/Diver/sprDiverDead.png", 9, 16, 16);
        	HarpoonGun = sprite_add("sprites/enemies/Diver/sprDiverHarpoonGun.png", 1, 8, 8);

        	 // Gull:
        	GullIdle = sprite_add("sprites/enemies/Gull/sprGullIdle.png", 4, 12, 12);
        	GullWalk = sprite_add("sprites/enemies/Gull/sprGullWalk.png", 6, 12, 12);
        	GullHurt = sprite_add("sprites/enemies/Gull/sprGullHurt.png", 3, 12, 12);
        	GullDead = sprite_add("sprites/enemies/Gull/sprGullDead.png", 6, 16, 16);
        	GullSword = sprite_add("sprites/enemies/Gull/sprGullSword.png", 1, 6, 8);

             // Palanking:
            PalankingBott   = sprite_add("sprites/enemies/Palanking/sprPalankingBase.png",      1, 40, 24);
            PalankingTaunt  = sprite_add("sprites/enemies/Palanking/sprPalankingTaunt.png",    31, 40, 24);
            PalankingCall   = sprite_add("sprites/enemies/Palanking/sprPalankingCall.png",      9, 40, 24);
            PalankingIdle   = sprite_add("sprites/enemies/Palanking/sprPalankingIdle.png",     16, 40, 24);
            PalankingWalk   = sprite_add("sprites/enemies/Palanking/sprPalankingWalk.png",     16, 40, 24);
            PalankingHurt   = sprite_add("sprites/enemies/Palanking/sprPalankingHurt.png",      3, 40, 24);
            PalankingDead   = sprite_add("sprites/enemies/Palanking/sprPalankingDead.png",     11, 40, 24);
            PalankingBurp   = sprite_add("sprites/enemies/Palanking/sprPalankingBurp.png",      5, 40, 24);
            PalankingFire   = sprite_add("sprites/enemies/Palanking/sprPalankingFire.png",     11, 40, 24);
            PalankingFoam   = sprite_add("sprites/enemies/Palanking/sprPalankingFoam.png",      1, 40, 24);
            PalankingChunk  = sprite_add("sprites/enemies/Palanking/sprPalankingChunk.png",     5, 16, 16);
            GroundSlash     = sprite_add("sprites/enemies/Palanking/sprGroundSlash.png",        3,  0, 21);
            PalankingSlash  = sprite_add("sprites/enemies/Palanking/sprPalankingSlash.png",     3,  0, 29);
            msk.Palanking   = sprite_add("sprites/enemies/Palanking/mskPalanking.png",          1, 40, 24);
            if(fork()){
                wait 30;
                sprite_collision_mask(msk.Palanking, false, 0, 0, 0, 0, 0, 0, 0);
                exit;
            }

             // Palm:
        	PalmIdle      = sprite_add("sprites/areas/Coast/Props/sprPalm.png",         1, 24, 40);
        	PalmHurt      = sprite_add("sprites/areas/Coast/Props/sprPalmHurt.png",     3, 24, 40);
        	PalmDead      = sprite_add("sprites/areas/Coast/Props/sprPalmDead.png",     4, 24, 40);
        	PalmFortIdle  = sprite_add("sprites/areas/Coast/Props/sprPalmFortIdle.png", 1, 32, 56);
        	PalmFortHurt  = sprite_add("sprites/areas/Coast/Props/sprPalmFortHurt.png", 3, 32, 56);

             // Pelican:
            PelicanIdle   = sprite_add("sprites/enemies/Pelican/sprPelicanIdle.png",   6, 24, 24);
            PelicanWalk   = sprite_add("sprites/enemies/Pelican/sprPelicanWalk.png",   6, 24, 24);
            PelicanHurt   = sprite_add("sprites/enemies/Pelican/sprPelicanHurt.png",   3, 24, 24);
            PelicanDead   = sprite_add("sprites/enemies/Pelican/sprPelicanDead.png",   6, 24, 24);
            PelicanHammer = sprite_add("sprites/enemies/Pelican/sprPelicanHammer.png", 1,  6,  8);

             // Seal:
            SealIdle[0] = sprite_add("sprites/enemies/Seal/sprSealIdle.png",      6, 12, 12);
            SealWalk[0] = sprite_add("sprites/enemies/Seal/sprSealWalk.png",      6, 12, 12);
            SealHurt[0] = sprite_add("sprites/enemies/Seal/sprSealHurt.png",      3, 12, 12);
            SealDead[0] = sprite_add("sprites/enemies/Seal/sprSealDead.png",      6, 12, 12);
            SealSpwn[0] = sprite_add("sprites/enemies/Seal/sprSealSpwn.png",      6, 12, 12);
            SealWeap[0] = mskNone;
            SealIdle[1] = sprite_add("sprites/enemies/Seal/sprSealIdle1.png",     6, 12, 12);
            SealWalk[1] = sprite_add("sprites/enemies/Seal/sprSealWalk1.png",     6, 12, 12);
            SealHurt[1] = sprite_add("sprites/enemies/Seal/sprSealHurt1.png",     3, 12, 12);
            SealDead[1] = sprite_add("sprites/enemies/Seal/sprSealDead1.png",     6, 12, 12);
            SealSpwn[1] = sprite_add("sprites/enemies/Seal/sprSealSpwn1.png",     6, 12, 12);
            SealWeap[1] = sprite_add("sprites/enemies/Seal/sprHookPole.png",      1, 18,  2);
            SealIdle[2] = sprite_add("sprites/enemies/Seal/sprSealIdle2.png",     6, 12, 12);
            SealWalk[2] = sprite_add("sprites/enemies/Seal/sprSealWalk2.png",     6, 12, 12);
            SealHurt[2] = sprite_add("sprites/enemies/Seal/sprSealHurt2.png",     3, 12, 12);
            SealDead[2] = sprite_add("sprites/enemies/Seal/sprSealDead2.png",     6, 12, 12);
            SealSpwn[2] = sprite_add("sprites/enemies/Seal/sprSealSpwn2.png",     6, 12, 12);
            SealWeap[2] = sprite_add("sprites/enemies/Seal/sprSabre.png",         1, -2,  1);
            SealIdle[3] = sprite_add("sprites/enemies/Seal/sprSealIdle3.png",     6, 12, 12);
            SealWalk[3] = sprite_add("sprites/enemies/Seal/sprSealWalk3.png",     6, 12, 12);
            SealHurt[3] = sprite_add("sprites/enemies/Seal/sprSealHurt3.png",     3, 12, 12);
            SealDead[3] = sprite_add("sprites/enemies/Seal/sprSealDead3.png",     6, 12, 12);
            SealSpwn[3] = sprite_add("sprites/enemies/Seal/sprSealSpwn3.png",     6, 12, 12);
            SealWeap[3] = sprite_add("sprites/enemies/Seal/sprBlunderbuss.png",   1,  7,  1);
            ClamShield  = sprite_add("sprites/enemies/Seal/sprClamShield.png",   14,  7,  1);

             // Seal (Heavy):
            SealHeavySpwn = sprite_add("sprites/enemies/SealHeavy/sprHeavySealSpwn.png",   6, 16, 17);
            SealHeavyIdle = sprite_add("sprites/enemies/SealHeavy/sprHeavySealIdle.png",  10, 16, 17);
            SealHeavyWalk = sprite_add("sprites/enemies/SealHeavy/sprHeavySealWalk.png",   8, 16, 17);
            SealHeavyHurt = sprite_add("sprites/enemies/SealHeavy/sprHeavySealHurt.png",   3, 16, 17);
            SealHeavyDead = sprite_add("sprites/enemies/SealHeavy/sprHeavySealDead.png",   7, 16, 17);
            SealHeavyTell = sprite_add("sprites/enemies/SealHeavy/sprHeavySealTell.png",   2, 16, 17);
            SealAnchor    = sprite_add("sprites/enemies/SealHeavy/sprHeavySealAnchor.png", 1,  0, 12);
            SealChain     = sprite_add("sprites/enemies/SealHeavy/sprChainSegment.png",    1,  0, 0);

             // Sea/Seal Mine:
            SealMine      = sprite_add("sprites/areas/Coast/props/sprSeaMine.png",      1, 12, 12);
            SealMineHurt  = sprite_add("sprites/areas/Coast/props/sprSeaMineHurt.png",  3, 12, 12);

             // Traffic Crab:
            CrabIdle = sprite_add("sprites/enemies/Crab/sprTrafficCrabIdle.png", 5, 24, 24);
            CrabWalk = sprite_add("sprites/enemies/Crab/sprTrafficCrabWalk.png", 6, 24, 24);
            CrabHurt = sprite_add("sprites/enemies/Crab/sprTrafficCrabHurt.png", 3, 24, 24);
            CrabDead = sprite_add("sprites/enemies/Crab/sprTrafficCrabDead.png", 9, 24, 24);
            CrabFire = sprite_add("sprites/enemies/Crab/sprTrafficCrabFire.png", 2, 24, 24);

             // Strange Creature:
        	CreatureIdle = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAACMAAAACgCAMAAADXNXIqAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAAAU9IAxsQWkrGXVgQ/w4ALiVetS/rwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKuM2GgAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGXRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4wLjE3M26fYwAADJxJREFUeF7t24ty20YSQFFlLcv//8VZYNCkAGLwIAYU0c45VSvSeM3dSRWqI1c+/gUASMYAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0WgaYj4k4eCERFuLghURYiIMXEmEhDl5IhIU4eCERFuLglUTZII5dSZQN4tiVRNkgjl1JlA3i2JVE2SCOXUmUDeLYlUTZII5dSZQN4tjZDj03kv6ZiINxyVtFSoSFOBiXvFWkRFiIg3HJW0VKhIU4GJe8VaREWIiDcclbRUqEhTgYl7xXtETZII7FFe8VLVE2iGNxxXtFS5QN4lhc8V7REmWDOBZXvFe0RNkgjsUV7xUtUTaIY3HFe0VLlA3iWFzxVpHyI33PPrBERFLVCxqfoa+NvjZX79sM1LdOXxt9bS7et5V3et9TT1tu+9+3N+6hvjb62ly9bzkw2nqX7JsE6luir42+Jst5o76T3y/7H7W+eeMdLI1x18/R10Zfm6v3LQcOSaVscMG+hw3UN6evjb4mi3mlbJp3Yt/eBy3WdWWxhRM/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",
        	14, 80, 80);
        	CreatureHurt = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAeAAAACgCAMAAADjJU9/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAAAU9IAxsQXVgQ7iVetS/r////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHiDNaAAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGXRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4wLjE3M26fYwAABYhJREFUeF7tmomS2joURCF2+P8/nmhpBttos9GWpk/VC4MsXXf1GZNJXm4/ghoJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYnI8EP7ZgbSZuW7A2E0jmwVptrs2F0xDYMRZ0dt+CNewYC7IgmQdr2FGN0wPhMQV2jsG1hM5CNOjwFL3znZsGg3mwvzfx7v68GOh4QL4To+CuEBzqSLQ9X5v7FZgOcagjY/KVDoK2M+BkH5LPxu4B8fRWPCxf2RgoOwkOdyDanq8uUKCtEIc7MDBfyRT4ugAGNCZRX6i5X3o9xEPz5WfA1TUwoyWp+gzhx8PT5SEenC83AqIugzHNyNS3AaXtaW54eL7MBGj6AAxqRLQ+FLRhiOHx+dIDIOkjMKoJkf5QzoEBhifIlzwPRR+CYQ041V+MhoZnyJc6DkGfg3m1CfeHXopp9yfiKfIlDsNODTCxLnX6sz/FtjE8R774WbipA2bW5NLnX+CyXWpheJJ80aMwUwtMrcel/kINupX6hmfJFzsJL/XA3FpE+jtfII7UNjxNvshBWKkJJtch1t/lAiv/pdY8+cLn4KQumF2DaH/Jv/mzvF1+FljV8ET5JBgLkwu+nC94DEYqg+EViPeXbs/wvgMrNQXPlK+j4HqGEwXaNlIthgr0hyoanilf6BR8VAfjPybVny3jvaQXbsMO++/cHg+zXk3wVPn4BKf/D6u9vsMsmP4ej1svwZ3zzSS4bFe2QAPK2YFL/qJ9Xde/jnV1980XeHPgTYKp8gVOuXEtwPww2FMgON/fFvv5Zr7/DVjwoDyPazBToBng9uYFz5VvEsHYYcFKnDMF+voMuwZ37TlWex3zQ6C9v2tlwe3z9RRswT324JoHa3HKCzSlYKgpEGuh+kwx67LYDsMlPuurLbhHvt6CHbgRwCLAYoKyAl0dmwKxfEcTW9Zfgi2+6jM7834ny/ceGHdsDG72fjssxynrz/Eq8HkIRWx5/izzxPS47fB221wvETxZvlGCLcG7uQwpThSIkfYPkQ7fwa6wdcEXB0yHrpptfWZzXcGI1zTfSMFBkCJOeYFuHr6+321Tpr1Dfbu3B2yJu+tLXcFd8n2J4MVWZ34P2/VnfktL9ffWr93fSHC7fN8hGPUd+jDv0gUe+l2aCW6YbzrBWcPlBdoG7YvvzoImPPZdssDDRTPENJo1PFk+asGeZXl+BKIJj3uXLPCA6c+MqSnY0zbffIJzhs8WaOoL9Xe6QPuAlDzCk+XjF2yw39kfF+j6CzwiRybLN6HgjOErBQb685wr0P+YmzE8Wb5vEBx8QDzlBbofYWyD9QU3zTej4LThCwW6/sIFFjdoCvRjcoYny/flgssfET/D0lPw5/kCYdHySJAkDGopp16B9tX8lzaMu5bTNF8wK2oeB3LEQDGl/H52BSgvcPOaFjxXvkhWFF0KTu14rrsNCWeZy2FQTRnLglM7bKXPV3wZJHM5DO5cRtN8qW9GX30C7BsF+omDfaNAijjY15Tcp434z5FgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJpubn5x8Du/CP6ZKb1gAAAABJRU5ErkJggg==",
        	3, 80, 80);
        	CreatureBott = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAKAAAACgCAYAAACLz2ctAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4wYVETYBV3z5JQAAAB1pVFh0Q29tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUHAAAB+UlEQVR42u3bzU3DMBgGYAf10i1A6hQdgGmQmIUDq3BggGyBGCNHc2wrxX9tgxN4ngtIbZLP9usvrZSGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUGXYVLX7Y0y+No2D5RTA9uCsxT0CvIVx/tZcdA3gX1kIFg/nIHj0DOMgfPQM4oPZo2fzEUC6EkC6dkEBRAfk/3ZBAUQH5P92QQFEB0QAYeMB9DgUOiDdNTYiAaRb+EJY4nlAT8UIX4PdAqV8LTTEeMOGaT02hq39XGH5uU7PyTQerr3QboGdcAj748dMh80N6vzv+XFx5v/URJwfGxMdPibOHWZqCJU1hcz75841ZMYfMudN1Zi77pC4Rm6DpdYpJNbqJsvt8v3xbWW7+m6TtoKae47l8trT+LrOAJ6C+FLoPjGzU0Omm5V2bix0nZquGTO7vvacNV2oNObSfIUrulvuTlKq9TS+aXxfdwAvw/ic2cG5W1bs3AFramvpVqlbeGmNYqG+mjG2zmv6/dP4ud5bcHs4H6/odDHz+aj0Wa9l59/jC1CpEw8NXb1UW7pjT+N3xVo8Jc9fc/wmA3hbeEtfjNZf45prBwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACg5AeYQa0I8Pr3rQAAAABJRU5ErkJggg==",
        	1, 80, 80);
        	CreatureFoam = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAKAAAACgCAYAAACLz2ctAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwAAADsABataJCQAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xNzNun2MAAAIVSURBVHhe7dLBTsIAFERR/v+nMe6voBUGtGeSs7npok3f5Xq9wstkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGd/YrdXzvLmMT/AXVu/9U/9l9W1PkfEB7P+u/vdhGX/BzrW6gR/JeJCdd3UP35LxIDv36ibuyniQnXt1E3dlPMis7uKmjAeZ1V3clPEgs8/VbXwp4y/ZeVf3cFPGB/nLq+/hCTI+0Tus3osXyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhI3r5QPGwQeqRTAO1AAAAABJRU5ErkJggg==",
        	1, 80, 80);

             // Water Streak:
            WaterStreak = sprite_add("sprites/areas/Coast/sprWaterStreak.png", 7, 8, 8);
    	//#endregion

        //#region OASIS
             // Big Bubble:
            BigBubble    = sprite_add("sprites/areas/Oasis/sprBigBubble.png",    1, 24, 24);
            BigBubblePop = sprite_add("sprites/areas/Oasis/sprBigBubblePop.png", 4, 24, 24);

             // Fish Freaks:
            FishFreakIdle = sprite_add("sprites/areas/Oasis/sprFishFreakIdle.png",  6, 12, 12);
            FishFreakWalk = sprite_add("sprites/areas/Oasis/sprFishFreakWalk.png",  6, 12, 12);
            FishFreakHurt = sprite_add("sprites/areas/Oasis/sprFishFreakHurt.png",  3, 12, 12);
            FishFreakDead = sprite_add("sprites/areas/Oasis/sprFishFreakDead.png", 11, 12, 12);

             // Hammerhead:
            HammerheadIdle = sprite_add("sprites/enemies/Hammer/sprHammerheadIdle.png",  6, 24, 24);
            HammerheadHurt = sprite_add("sprites/enemies/Hammer/sprHammerheadHurt.png",  3, 24, 24);
            HammerheadDead = sprite_add("sprites/enemies/Hammer/sprHammerheadDead.png", 10, 24, 24);
            HammerheadChrg = sprite_add("sprites/enemies/Hammer/sprHammerheadDash.png",  2, 24, 24);

             // Puffer:
            PufferIdle       = sprite_add("sprites/enemies/Puffer/sprPufferIdle.png",     6, 15, 16);
            PufferHurt       = sprite_add("sprites/enemies/Puffer/sprPufferHurt.png",     3, 15, 16);
            PufferDead       = sprite_add("sprites/enemies/Puffer/sprPufferDead.png",    11, 15, 16);
            PufferChrg       = sprite_add("sprites/enemies/Puffer/sprPufferChrg.png",     9, 15, 16);
            PufferFire[0, 0] = sprite_add("sprites/enemies/Puffer/sprPufferBlow0.png",    2, 15, 16);
            PufferFire[0, 1] = sprite_add("sprites/enemies/Puffer/sprPufferBlowB0.png",   2, 15, 16);
            PufferFire[1, 0] = sprite_add("sprites/enemies/Puffer/sprPufferBlow1.png",    2, 15, 16);
            PufferFire[1, 1] = sprite_add("sprites/enemies/Puffer/sprPufferBlowB1.png",   2, 15, 16);
            PufferFire[2, 0] = sprite_add("sprites/enemies/Puffer/sprPufferBlow2.png",    2, 15, 16);
            PufferFire[2, 1] = sprite_add("sprites/enemies/Puffer/sprPufferBlowB2.png",   2, 15, 16);
            PufferFire[3, 0] = sprite_add("sprites/enemies/Puffer/sprPufferBlow3.png",    2, 15, 16);
            PufferFire[3, 1] = sprite_add("sprites/enemies/Puffer/sprPufferBlowB3.png",   2, 15, 16);

             // Ground Crack Effect:
            Crack = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAEAAAAAgCAYAAACinX6EAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAZdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAuMTczbp9jAAABk0lEQVRoQ+WVS3KDQAxEOUQ22ed0OUPujhEVTWk6PWK+sSgWrwwPI0/3YHvb9/3RUPkkqHwSVEbg4+f7eOHXZkJlBLAAr5CRsqh8FxLEwq6jE7avz+Plr6+BygiUChAkMKNUkAeVUbCBvOCIFqX3elAZCRr8WDYF3oezGFRGIgvFgqqzmOs4D6EyCmn3C+Eyb6+Z86uvApWt1H7fWsEw6diDlIBzLVQiElDBa8KKAmRmCsLCY9ASx3u89VFZ4j8LqArnYe8/jnG+QqWHhMXAzI0yXICgM34LYGvMTmqQIedg06p1Wgb7sBayIBMorSk7aUVD2zJmgQFG0blYQjroQXcc/Qi6UyzECOwz5DjJHlbsvIIBRsH5CpW1zN59y8ynwFsnlVfoI7SyAAGD9IJzLVS2sLIEmc0CtXC1PipbWVnC+S8Doaqp+JGmMgqy+PMp6Cmh8geaygjgzp1FYMgCV7tuofJd6I4reF0Qz0IL3n0lqIzAVRCvIHQeVEagt4BWqLwLM0qg8k6MlkDlnXh8AWPs2wudfCE+JW5sAwAAAABJRU5ErkJggg==",
            2, 16, 16);
        //#endregion

        //#region PARROT
            Parrot = array_create(2);
            for(var i = 0; i < array_length(Parrot); i++){
                var _sprt = [
                        ["Loadout",       2, 16,  16, true],
                        ["Map",           1, 10,  10, true],
                        ["Portrait",      1, 20, 221, true],
                        ["Select",        2,  0,   0, false],
                        ["UltraIcon",	  2, 12,  16, false],
                        ["UltraHUDB",	  1,  8,   9, false],
                        ["Idle",          4, 12,  12, true],
                        ["Walk",          6, 12,  12, true],
                        ["Hurt",          3, 12,  12, true],
                        ["Dead",          6, 12,  12, true],
                        ["GoSit",         3, 12,  12, true],
                        ["Sit",           1, 12,  12, true],
                        ["MenuSelected", 10, 16,  16, false],
                        ["Feather",       1,  4,   4, true]
                    ];

                Parrot[i] = {};
                with(_sprt){
                    var _name = self[0],
                        _img  = self[1],
                        _x    = self[2],
                        _y    = self[3],
                        _hasB = self[4];

                    lq_set(other.Parrot[i], _name, sprite_add("sprites/races/Parrot/sprParrot" + (_hasB ? ["", "B"][i] : "") + _name + ".png", _img, _x, _y));
                }
            }
        //#endregion

        //#region PETS
             // Scorpion:
            PetScorpionIdle     = sprite_add("sprites/pets/Desert/sprPetScorpionIdle.png",      4, 16, 16);
            PetScorpionWalk     = sprite_add("sprites/pets/Desert/sprPetScorpionWalk.png",      6, 16, 16);
            PetScorpionHurt     = sprite_add("sprites/pets/Desert/sprPetScorpionHurt.png",      3, 16, 16);
            PetScorpionDead     = sprite_add("sprites/pets/Desert/sprPetScorpionDead.png",      6, 16, 16);
            PetScorpionFire     = sprite_add("sprites/pets/Desert/sprPetScorpionFire.png",      6, 16, 16);
            PetScorpionShield   = sprite_add("sprites/pets/Desert/sprPetScorpionShield.png",    6, 16, 16);
            
             // Spider
            PetSpiderIdle = sprite_add("sprites/pets/Caves/sprPetSpiderIdle.png",   8, 16, 16);
            PetSpiderWalk = sprite_add("sprites/pets/Caves/sprPetSpiderWalk.png",   6, 16, 16);
            PetSpiderHurt = sprite_add("sprites/pets/Caves/sprPetSpiderDodge.png",  3, 16, 16);
            PetSparkle =    sprite_add("sprites/pets/Caves/sprPetSparkle.png",      5,  8,  8);
            
            SpiderTangle            = sprite_add("sprites/pets/Caves/sprSpiderTangle.png",          2,  4,  4);
            SpiderTangleAppear      = sprite_add("sprites/pets/Caves/sprSpiderTangleAppear.png",    6,  24, 24);
            SpiderTangleDisappear   = sprite_add("sprites/pets/Caves/sprSpiderTangleDisappear.png", 5,  24, 24);
            
             // Parrot:
            PetParrotIdle = sprite_add("sprites/pets/Coast/sprPetParrotIdle.png",   6, 12, 12);
            PetParrotWalk = sprite_add("sprites/pets/Coast/sprPetParrotWalk.png",   6, 12, 14);
            PetParrotHurt = sprite_add("sprites/pets/Coast/sprPetParrotDodge.png",  3, 12, 12);

             // BabyShark:
            PetSlaughterIdle = sprite_add("sprites/pets/Oasis/sprPetSlaughterIdle.png",  4, 12, 12);
            PetSlaughterWalk = sprite_add("sprites/pets/Oasis/sprPetSlaughterWalk.png",  6, 12, 12);
            PetSlaughterHurt = sprite_add("sprites/pets/Oasis/sprPetSlaughterHurt.png",  3, 12, 12);
            PetSlaughterDead = sprite_add("sprites/pets/Oasis/sprPetSlaughterDead.png", 10, 24, 24);
            PetSlaughterBite = sprite_add("sprites/pets/Oasis/sprPetSlaughterBite.png",  6, 12, 12);
            SlaughterBite    = sprite_add("sprites/pets/Oasis/sprSlaughterBite.png",     6,  8, 12);

             // Octopus:
            PetOctoIdle = sprite_add("sprites/pets/Trench/sprPetOctoIdle.png",  20, 12, 12);
            PetOctoHurt = sprite_add("sprites/pets/Trench/sprPetOctoDodge.png",  3, 12, 12);
            PetOctoHide = sprite_add("sprites/pets/Trench/sprPetOctoHide.png",  30, 12, 12);

             // CoolGuy:
            PetCoolGuyIdle = sprite_add("sprites/pets/Pizza/sprPetCoolGuyIdle.png",    4, 12, 12);
            PetCoolGuyWalk = sprite_add("sprites/pets/Pizza/sprPetCoolGuyWalk.png",    6, 12, 12);
            PetCoolGuyHurt = sprite_add("sprites/pets/Pizza/sprPetCoolGuyDodge.png",   3, 12, 12);

             // Golden Chest Mimic:
            PetMimicIdle = sprite_add("sprites/pets/Mansion/sprPetMimicIdle.png",      16, 16, 16);
            PetMimicWalk = sprite_add("sprites/pets/Mansion/sprPetMimicWalk.png",       6,  16, 16);
            PetMimicHurt = sprite_add("sprites/pets/Mansion/sprPetMimicDodge.png",      3,  16, 16);
            PetMimicOpen = sprite_add("sprites/pets/Mansion/sprPetMimicOpen.png",       1,  16, 16);
            PetMimicHide = sprite_add("sprites/pets/Mansion/sprPetMimicHide.png",       1,  16, 16);

            // Prism:
            PetPrismIdle = sprite_add("sprites/pets/Cursed Caves/sprPetPrismIdle.png", 6, 12, 12);

        //#endregion

        //#region TRENCH
             // Angler:
            AnglerIdle       = sprite_add("sprites/enemies/Angler/sprAnglerIdle.png",      8, 32, 32);
            AnglerWalk       = sprite_add("sprites/enemies/Angler/sprAnglerWalk.png",      8, 32, 32);
            AnglerHurt       = sprite_add("sprites/enemies/Angler/sprAnglerHurt.png",      3, 32, 32);
            AnglerDead       = sprite_add("sprites/enemies/Angler/sprAnglerDead.png",      7, 32, 32);
            AnglerAppear     = sprite_add("sprites/enemies/Angler/sprAnglerAppear.png",    4, 32, 32);
            AnglerTrail      = sprite_add("sprites/enemies/Angler/sprAnglerTrail.png",     8, 32, 32);
            AnglerLight      = sprite_add("sprites/enemies/Angler/sprAnglerLight.png",     4, 80, 80);
            msk.AnglerHidden =[sprite_add("sprites/enemies/Angler/mskAnglerHidden1.png",   1, 32, 32),
                               sprite_add("sprites/enemies/Angler/mskAnglerHidden2.png",   1, 32, 32)];

             // Eel (0 = blue, 1 = purple, 2 = green):
            EelIdle = [
                sprite_add("sprites/enemies/Eel/sprEelIdleBlue.png",           8, 16, 16),
                sprite_add("sprites/enemies/Eel/sprEelIdlePurple.png",         8, 16, 16),
                sprite_add("sprites/enemies/Eel/sprEelIdleGreen.png",          8, 16, 16)];
            EelHurt = [
                sprite_add("sprites/enemies/Eel/sprEelHurtBlue.png",           3, 16, 16),
                sprite_add("sprites/enemies/Eel/sprEelHurtPurple.png",         3, 16, 16),
                sprite_add("sprites/enemies/Eel/sprEelHurtGreen.png",          3, 16, 16)];
            EelDead = [
                sprite_add("sprites/enemies/Eel/sprEelDeadBlue.png",           9, 16, 16),
                sprite_add("sprites/enemies/Eel/sprEelDeadPurple.png",         9, 16, 16),
                sprite_add("sprites/enemies/Eel/sprEelDeadGreen.png",          9, 16, 16)];
            EelTell = [
                sprite_add("sprites/enemies/Eel/sprEelTellBlue.png",           8, 16, 16),
                sprite_add("sprites/enemies/Eel/sprEelTellPurple.png",         8, 16, 16),
                sprite_add("sprites/enemies/Eel/sprEelTellGreen.png",          8, 16, 16)];

            EeliteIdle = sprite_add("sprites/enemies/Eel/sprEelIdleElite.png", 8, 16, 16);
            EeliteHurt = sprite_add("sprites/enemies/Eel/sprEelHurtElite.png", 3, 16, 16);
            EeliteDead = sprite_add("sprites/enemies/Eel/sprEelDeadElite.png", 9, 16, 16);

             // Eel Skeleton (big fat eel edition):
            EelSkullIdle = sprite_add("sprites/areas/Trench/Props/sprEelSkeletonIdle.png", 1, 24, 24);
            EelSkullHurt = sprite_add("sprites/areas/Trench/Props/sprEelSkeletonHurt.png", 3, 24, 24);
            EelSkullDead = sprite_add("sprites/areas/Trench/Props/sprEelSkeletonDead.png", 6, 24, 24);

             // Floor Chunks (Pit Squid):
            FloorTrenchBreak = sprite_add("sprites/areas/Trench/sprFloorTrenchBreak.png", 3, 8, 8);

             // Jellyfish (0 = blue, 1 = purple, 2 = green, 3 = elite):
            JellyFire =         sprite_add("sprites/enemies/Jellyfish/sprJellyfishFire.png",        6, 24, 24);
            JellyEliteFire =    sprite_add("sprites/enemies/Jellyfish/sprJellyfishEliteFire.png",   6, 24, 24);
            JellyIdle = [
                sprite_add("sprites/enemies/Jellyfish/sprJellyfishBlueIdle.png",    8, 24, 24),
                sprite_add("sprites/enemies/Jellyfish/sprJellyfishPurpleIdle.png",  8, 24, 24),
                sprite_add("sprites/enemies/Jellyfish/sprJellyfishGreenIdle.png",   8, 24, 24)
                sprite_add("sprites/enemies/Jellyfish/sprJellyfishEliteIdle.png",   8, 24, 24)];
            JellyHurt = [
                sprite_add("sprites/enemies/Jellyfish/sprJellyfishBlueHurt.png",    3, 24, 24),
                sprite_add("sprites/enemies/Jellyfish/sprJellyfishPurpleHurt.png",  3, 24, 24),
                sprite_add("sprites/enemies/Jellyfish/sprJellyfishGreenHurt.png",   3, 24, 24)
                sprite_add("sprites/enemies/Jellyfish/sprJellyfishEliteHurt.png",   3, 24, 24)];
            JellyDead = [
                sprite_add("sprites/enemies/Jellyfish/sprJellyfishBlueDead.png",   10, 24, 24),
                sprite_add("sprites/enemies/Jellyfish/sprJellyfishPurpleDead.png", 10, 24, 24),
                sprite_add("sprites/enemies/Jellyfish/sprJellyfishGreenDead.png",  10, 24, 24),
                sprite_add("sprites/enemies/Jellyfish/sprJellyfishEliteDead.png",  10, 24, 24)];

             // Kelp:
            KelpIdle = sprite_add("sprites/areas/Trench/Props/sprKelpIdle.png", 6, 16, 22);
            KelpHurt = sprite_add("sprites/areas/Trench/Props/sprKelpHurt.png", 3, 16, 22);
            KelpDead = sprite_add("sprites/areas/Trench/Props/sprKelpDead.png", 8, 16, 22);

             // Pit Squid:
                 // Eyes:
                PitSquidCornea  = sprite_add("sprites/enemies/Pitsquid/sprPitsquidCornea.png",   1, 19, 19);
                PitSquidPupil   = sprite_add("sprites/enemies/Pitsquid/sprPitsquidPupil.png",    1, 19, 19);
                PitSquidEyelid  = sprite_add("sprites/enemies/Pitsquid/sprPitsquidEyelid.png",   3, 19, 19);
                
                 // Tentacles:
                TentacleSpwn    = sprite_add("sprites/enemies/Pitsquid/sprTentacleSpwn.png",     6, 20, 28);
                TentacleIdle    = sprite_add("sprites/enemies/Pitsquid/sprTentacleIdle.png",     8, 20, 28);
                TentacleHurt    = sprite_add("sprites/enemies/Pitsquid/sprTentacleHurt.png",     3, 20, 28);
                TentacleDead    = sprite_add("sprites/enemies/Pitsquid/sprTentacleDead.png",     6, 20, 28);
                TentacleWarn    = sprite_add("sprites/enemies/PitSquid/sprTentacleWarn.png",    15, 12, 12);
                TentacleDash    = [
                    sprite_add("sprites/enemies/Pitsquid/sprTentacleBackwards.png", 2, 20, 20),
                    sprite_add("sprites/enemies/Pitsquid/sprTentacleForwards.png",  2, 20, 20)
                ];
                SquidCharge     = sprite_add("sprites/enemies/Pitsquid/Particles/sprSquidCharge.png", 5, 24, 24);
                
                 // Maw:
                PitSquidMawBite = sprite_add("sprites/enemies/Pitsquid/sprPitsquidMawBite.png", 14, 19, 19);
                PitSquidMawSpit = sprite_add("sprites/enemies/Pitsquid/sprPitsquidMawSpit.png", 10, 19, 19);
                
                 // Spark:
                PitSpark = [
                    sprite_add("sprites/enemies/Pitsquid/Particles/sprPitSpark1.png", 5, 16, 16),
                    sprite_add("sprites/enemies/Pitsquid/Particles/sprPitSpark2.png", 5, 16, 16),
                    sprite_add("sprites/enemies/Pitsquid/Particles/sprPitSpark3.png", 5, 16, 16),
                    sprite_add("sprites/enemies/Pitsquid/Particles/sprPitSpark4.png", 5, 16, 16),
                    sprite_add("sprites/enemies/Pitsquid/Particles/sprPitSpark5.png", 5, 16, 16),
                ];
                TentacleWheel = sprite_add("sprites/enemies/Pitsquid/Particles/sprTentacleWheel.png", 2, 40, 40);

             // Vent
            VentIdle = sprite_add("sprites/areas/Trench/Props/sprVentIdle.png", 1, 12, 14);
            VentHurt = sprite_add("sprites/areas/Trench/Props/sprVentHurt.png", 3, 12, 14);
            VentDead = sprite_add("sprites/areas/Trench/Props/sprVentDead.png", 6, 12, 14);

             // Yeti Crab:
            YetiCrabIdle = sprite_add("sprites/enemies/YetiCrab/sprYetiCrab.png",   1, 12, 12);
            KingCrabIdle = sprite_add("sprites/enemies/YetiCrab/sprKingCrab.png",   1, 12, 12);
        //#endregion

        //#region SEWERS
             // Bat:
            BatWeap         = sprite_add_weapon("sprites/enemies/Bat/sprBatWeap.png", 2,  6);
            BatIdle         = sprite_add("sprites/enemies/Bat/sprBatIdle.png",    24, 16, 16);
            BatWalk         = sprite_add("sprites/enemies/Bat/sprBatWalk.png",    12, 16, 16);
            BatHurt         = sprite_add("sprites/enemies/Bat/sprBatHurt.png",     3, 16, 16);
            BatDead         = sprite_add("sprites/enemies/Bat/sprBatDead.png",     6, 16, 16);
            BatYell         = sprite_add("sprites/enemies/Bat/sprBatYell.png",     6, 16, 16);
            BatScreech      = sprite_add("sprites/enemies/Bat/sprBatScreech.png",  8, 48, 48);
            msk.BatScreech  = sprite_add("sprites/enemies/Bat/mskBatScreech.png",  8, 48, 48);

             // Bat Boss:
            BatBossIdle     = sprite_add("sprites/enemies/BatBoss/sprBigBatIdle.png",           12, 24, 24);
            BatBossWalk     = sprite_add("sprites/enemies/BatBoss/sprBigBatWalk.png",            8, 24, 24);
            BatBossHurt     = sprite_add("sprites/enemies/BatBoss/sprBigBatHurt.png",            3, 24, 24);
            BatBossDead     = sprite_add("sprites/enemies/BatBoss/sprBigBatDead.png",            6, 24, 24);
            BatBossYell     = sprite_add("sprites/enemies/BatBoss/sprBigBatYell.png",            6, 24, 24);
            BatBossWeap     = sprite_add_weapon("sprites/enemies/BatBoss/sprBatBossWeap.png",        4,  8);
            VenomFlak       = sprite_add("sprites/enemies/BatBoss/sprVenomFlak.png",             2, 12, 12);

             // Bat Chest:
            BatChest     = sprite_add("sprites/chests/sprBatChest.png",     1, 10, 10);
            BatChestOpen = sprite_add("sprites/chests/sprBatChestOpen.png", 1, 10, 10);

             // Cat:
            CatIdle = sprite_add("sprites/enemies/Cat/sprCatIdle.png",      4, 12, 12);
            CatWalk = sprite_add("sprites/enemies/Cat/sprCatWalk.png",      6, 12, 12);
            CatHurt = sprite_add("sprites/enemies/Cat/sprCatHurt.png",      3, 12, 12);
            CatDead = sprite_add("sprites/enemies/Cat/sprCatDead.png",      6, 12, 12);
            CatSit1 =[sprite_add("sprites/enemies/Cat/sprCatGoSit.png",     3, 12, 12),
                      sprite_add("sprites/enemies/Cat/sprCatGoSitSide.png", 3, 12, 12)];
            CatSit2 =[sprite_add("sprites/enemies/Cat/sprCatSit.png",       1, 12, 12),
                      sprite_add("sprites/enemies/Cat/sprCatSitSide.png",   1, 12, 12)];
            CatWeap = sprite_add("sprites/enemies/Cat/sprCatToxer.png",     1,  3,  4);
            AcidPuff = sprite_add("sprites/enemies/Cat/sprAcidPuff.png",    4, 16, 16);

             // Cat Boss:
            CatBossIdle     = sprite_add("sprites/enemies/CatBoss/sprBigCatIdle.png",           12, 24, 24);
            CatBossWalk     = sprite_add("sprites/enemies/CatBoss/sprBigCatWalk.png",            6, 24, 24);
            CatBossHurt     = sprite_add("sprites/enemies/CatBoss/sprBigCatHurt.png",            3, 24, 24);
            CatBossDead     = sprite_add("sprites/enemies/CatBoss/sprBigCatDead.png",            6, 24, 24);
            CatBossWeap     = sprite_add("sprites/enemies/CatBoss/sprCatBossToxer.png",          2,  4,  7);
            CatBossWeapChrg = sprite_add("sprites/enemies/CatBoss/sprCatBossToxerChrg.png",     12,  1,  7);
            
             // Cat Chest:
            CatChest     = sprite_add("sprites/chests/sprCatChest.png",     1, 10, 10);
            CatChestOpen = sprite_add("sprites/chests/sprCatChestOpen.png", 1, 10, 10);

             // Door:
            CatDoor         = sprite_add("sprites/areas/Lair/Props/sprCatDoor.png",          10, 2, 0);
            CatDoorDebris   = sprite_add("sprites/areas/Lair/Props/sprCatDoorDebris.png",     4, 4, 4);
            PizzaDoor       = sprite_add("sprites/areas/Pizza/Props/sprPizzaDoor.png",       10, 2, 0);
            PizzaDoorDebris = sprite_add("sprites/areas/Pizza/Props/sprPizzaDoorDebris.png",  4, 4, 4);
            msk.CatDoor     = sprite_add("sprites/areas/Lair/Props/mskCatDoor.png",           1, 4, 0);
            msk.CatDoorLOS  = sprite_add("sprites/areas/Lair/Props/mskCatDoorLOS.png",        1, 4, 0);
            if(fork()){
                wait 30;
                sprite_collision_mask(msk.CatDoorLOS, false, 1, 0, 0, 0, 0, 0, 0);
                exit;
            }

             // Drain:
            PizzaDrainIdle = sprite_add("sprites/areas/Pizza/Props/sprPizzaDrain.png",     1, 32, 38);
            PizzaDrainHurt = sprite_add("sprites/areas/Pizza/Props/sprPizzaDrainHurt.png", 3, 32, 38);
            PizzaDrainDead = mskNone;
            msk.PizzaDrain = sprite_add("sprites/areas/Pizza/Props/mskPizzaDrain.png",     1, 32, 38);
            
             // Lair turret reskin:
            LairTurretIdle      = sprite_add("sprites/enemies/LairTurret/sprLairTurretIdle.png",    1,  12, 12);
            LairTurretHurt      = sprite_add("sprites/enemies/LairTurret/sprLairTurretHurt.png",    3,  12, 12);
            LairTurretDead      = sprite_add("sprites/enemies/LairTurret/sprLairTurretDead.png",    6,  12, 12);
            LairTurretFire      = sprite_add("sprites/enemies/LairTurret/sprLairTurretFire.png",    3,  12, 12);
            LairTurretAppear    = sprite_add("sprites/enemies/LairTurret/sprLairTurretAppear.png",  11, 12, 12);

             // Manholes:
            ManholeBottom = sprite_add("sprites/areas/Lair/sprManholeBottom.png",  1, 16, 48);
            Manhole       = sprite_add("sprites/areas/Lair/sprManhole.png",       12, 16, 48);
             // Big one:
            BigManholeBot       = sprite_add("sprites/areas/Lair/sprBigManholeBot.png",         1,  32,  32);
            BigManholeTop       = sprite_add("sprites/areas/Lair/sprBigManholeTop.png",         6,  32,  32);
            ManholeDebrisSmall  = sprite_add("sprites/areas/Lair/sprManholeDebrisSmall.png",    4,  4,  4);
            ManholeDebrisBig    = sprite_add("sprites/areas/Lair/sprManholeDebrisBig.png",      3,  12, 12);

             // Furniture:
                 // Rug:
                Rug = sprite_add("sprites/areas/Lair/Props/sprRug.png", 1, 26, 26);

                 // Table:
                TableIdle = sprite_add("sprites/areas/Lair/Props/sprTableIdle.png", 1, 16, 16);
                TableHurt = sprite_add("sprites/areas/Lair/Props/sprTableHurt.png", 3, 16, 16);
                TableDead = sprite_add("sprites/areas/Lair/Props/sprTableDead.png", 3, 16, 16);

                 // Chairs:
                    ChairDead       = sprite_add("sprites/areas/Lair/Props/sprChairDead.png",         3, 12, 12);

                     // Side:
                    ChairSideIdle   = sprite_add("sprites/areas/Lair/Props/sprChairSideIdle.png",     1, 12, 12);
                    ChairSideHurt   = sprite_add("sprites/areas/Lair/Props/sprChairSideHurt.png",     3, 12, 12);

                     // Front:
                    ChairFrontIdle  = sprite_add("sprites/areas/Lair/Props/sprChairFrontIdle.png",    1, 12, 12);
                    ChairFrontHurt  = sprite_add("sprites/areas/Lair/Props/sprChairFrontHurt.png",    3, 12, 12);

                 // Cabinet:
                CabinetIdle = sprite_add("sprites/areas/Lair/Props/sprCabinetIdle.png", 1, 12, 12);
                CabinetHurt = sprite_add("sprites/areas/Lair/Props/sprCabinetHurt.png", 3, 12, 12);
                CabinetDead = sprite_add("sprites/areas/Lair/Props/sprCabinetDead.png", 3, 12, 12);

                 // Couch:
                CouchIdle = sprite_add("sprites/areas/Lair/Props/sprCouchIdle.png", 1, 32, 32);
                CouchHurt = sprite_add("sprites/areas/Lair/Props/sprCouchHurt.png", 3, 32, 32);
                CouchDead = sprite_add("sprites/areas/Lair/Props/sprCouchDead.png", 3, 32, 32);

                 // Soda Machine:
                SodaMachineIdle = sprite_add("sprites/areas/Lair/Props/sprSodaMachineIdle.png", 1, 16, 16);
                SodaMachineHurt = sprite_add("sprites/areas/Lair/Props/sprSodaMachineHurt.png", 3, 16, 16);
                SodaMachineDead = sprite_add("sprites/areas/Lair/Props/sprSodaMachineDead.png", 3, 16, 16);

             // FX:
            Paper = sprite_add("sprites/areas/Lair/Props/sprPaper.png", 3, 5, 6);

             // Pizza TV:
            TVHurt = sprite_add("sprites/areas/Pizza/Props/sprTVHurt.png", 3, 24, 16);
        //#endregion

		//#region SCRAPYARD
			 // Saw Trap:
			SawTrap		= sprite_add("sprites/enemies/SawTrap/sprSawTrap.png",		1, 20, 20);
			SawTrapHurt = sprite_add("sprites/enemies/SawTrap/sprSawTrapHurt.png",	3, 20, 20);
		//#endregion

        //#region CRYSTAL CAVES
        	 // Mortar:
        	MortarIdle    = sprite_add("sprites/enemies/Mortar/sprMortarIdle.png",    4, 22, 24);
        	MortarWalk    = sprite_add("sprites/enemies/Mortar/sprMortarWalk.png",    8, 22, 24);
        	MortarFire    = sprite_add("sprites/enemies/Mortar/sprMortarFire.png",   16, 22, 24);
        	MortarHurt    = sprite_add("sprites/enemies/Mortar/sprMortarHurt.png",    3, 22, 24);
        	MortarDead    = sprite_add("sprites/enemies/Mortar/sprMortarDead.png",   14, 22, 24);
        	MortarPlasma  = sprite_add("sprites/enemies/Mortar/sprMortarPlasma.png",  8,  8,  8);
        	MortarImpact  = sprite_add("sprites/enemies/Mortar/sprMortarImpact.png",  7, 16, 16);
        	MortarTrail   = sprite_add("sprites/enemies/Mortar/sprMortarTrail.png",   3,  4,  4);

        	 // Cursed Mortar:
        	InvMortarIdle    = sprite_add("sprites/enemies/InvMortar/sprInvMortarIdle.png",    4, 22, 24);
        	InvMortarWalk    = sprite_add("sprites/enemies/InvMortar/sprInvMortarWalk.png",    8, 22, 24);
        	InvMortarFire    = sprite_add("sprites/enemies/InvMortar/sprInvMortarFire.png",   16, 22, 24);
        	InvMortarHurt    = sprite_add("sprites/enemies/InvMortar/sprInvMortarHurt.png",    3, 22, 24);
        	InvMortarDead    = sprite_add("sprites/enemies/InvMortar/sprInvMortarDead.png",   14, 22, 24);

        	 // Spiderling:
        	SpiderlingIdle = sprite_add("sprites/enemies/Spiderling/sprSpiderlingIdle.png", 4, 8, 8);
        	SpiderlingWalk = sprite_add("sprites/enemies/Spiderling/sprSpiderlingWalk.png", 4, 8, 8);
        	SpiderlingHurt = sprite_add("sprites/enemies/Spiderling/sprSpiderlingHurt.png", 3, 8, 8);
        	SpiderlingDead = sprite_add("sprites/enemies/Spiderling/sprSpiderlingDead.png", 7, 8, 8);
        	
        	 // Spider Walls:
        	SpiderWallMainBot   = sprite_add("sprites/areas/Caves/sprSpiderWallMainBot.png",    2, 0, 0);
        	SpiderWallMainTop   = sprite_add("sprites/areas/Caves/sprSpiderWallMainTop.png",    2, 0, 0);
        	SpiderWallFakeTop   = sprite_add("sprites/areas/Caves/sprSpiderWallFakeTop.png",    4, 0, 0);
        	SpiderWallTrans     = sprite_add("sprites/areas/Caves/sprSpiderWallTrans.png",      4, 0, 0);
        	 
        //#endregion

        MergeWep = {};
        
         // Semi-Manual Shine (sprite_add_weapon is wack with taller sprites):
        Shine10 = sprite_add("sprites/chests/sprShine10.png", 7,  5,  5); // Pickups
        Shine16 = sprite_add("sprites/chests/sprShine16.png", 7,  8,  8); // Normal Chests
        Shine20 = sprite_add("sprites/chests/sprShine20.png", 7, 10, 10); // Heavy Chests (Steroids)
        Shine24 = sprite_add("sprites/chests/sprShine24.png", 7, 12, 12); // Big Chests
        Shine64 = sprite_add("sprites/chests/sprShine64.png", 7, 32, 32); // Giant Chests (YV)
        with(other) if(fork()){
            wait 30;

             // Backpack:
            spr.Backpack       = sprite_shine(spr.Backpack,       spr.Shine16);
            spr.BackpackCursed = sprite_shine(spr.BackpackCursed, spr.Shine16);

             // Cat/Bat Chests:
            spr.BatChest = sprite_shine(spr.BatChest, spr.Shine20);
            spr.CatChest = sprite_shine(spr.CatChest, spr.Shine20);

            exit;
        }
    }

     // SOUNDS //
    global.snd = {};
    with(global.snd){
         // Palanking:
        PalankingHurt  = sound_add("sounds/enemies/Palanking/sndPalankingHurt.ogg");
        PalankingDead  = sound_add("sounds/enemies/Palanking/sndPalankingDead.ogg");
        PalankingCall  = sound_add("sounds/enemies/Palanking/sndPalankingCall.ogg");
        PalankingSwipe = sound_add("sounds/enemies/Palanking/sndPalankingSwipe.ogg");
        PalankingTaunt = sound_add("sounds/enemies/Palanking/sndPalankingTaunt.ogg");
        sound_volume(PalankingHurt, 0.6);

         // Cat:
    }

     // MUSIC //
    global.mus = {};
    with(global.mus){
        amb = {};

        Placeholder = sound_add("music/musPlaceholder.ogg");
        amb.Placeholder = sound_add("music/musPlaceholder.ogg");

         // Areas:
        Coast   = sound_add("music/musCoast.ogg");
        Oasis   = mus101;
        Trench  = musBoss5;

         // Bosses:
        SealKing = sound_add("music/musSealKing.ogg");
    }

     // SAVE FILE //
    global.save_auto = false;
    global.save = {
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
        var _path = SavePath;
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
                    lq_set(global.save, lq_get_key(_save, i), lq_get_value(_save, i));
                }

                global.save_auto = true;
                exit;
            }
        }

         // New Save File:
        string_save(json_encode(global.save), _path);
        global.save_auto = true;
        exit;
    }

     // Surface Storage:
    global.surf = [];

     // Reminders:
    global.remind = [];
    if(fork()){
        while(mod_exists("mod", "teloader")) wait 0;

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
                trace_color("NTTE | For the full experience, " + _text + "!", c_yellow);
            }
        }
        exit;
    }

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.save
#macro opt sav.option

#macro surfList global.surf

#macro SavePath "save.sav"

#define save()
    if(player_is_local_nonsync(player_find_local_nonsync())){
        string_save(json_encode(sav), SavePath);
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

#define step
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

	 // Autosave:
	if(global.save_auto){
		with(instances_matching(GameCont, "ntte_autosave", null)){
			save();
			ntte_autosave = true;
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
                var _x = (game_width  / 2),
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

	var _ox = sprite_get_xoffset(_spr),
	    _oy = sprite_get_yoffset(_spr),
	    _surfw = sprite_get_width(_spr),
		_surfh = sprite_get_height(_spr),
		_surf = surface_create(_surfw * _img, _surfh);

	surface_set_target(_surf);
	draw_clear_alpha(0, 0);

	for(var i = 0; i < _img; i++){
		var _x = (_surfw * i),
			_y = 0;

		draw_sprite(_spr, i, _x + _ox, _y + _oy);

		 // Overlay Shine:
		var _shineSiz = max(_surfw, _surfh),
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

#define sprite_merge(_stock, _front) // Doing this here so that the sprite doesnt get unloaded with merge.wep
    var _sprName = sprite_get_name(_stock) + "|" + sprite_get_name(_front);
    if(lq_exists(spr.MergeWep, _sprName)){
        return lq_get(spr.MergeWep, _sprName);
    }
    else{
        var _spr = [_stock, _front],
            _sprW = [],
            _sprH = [];

        for(var i = 0; i < array_length(_spr); i++){
            _sprW[i] = sprite_get_width(_spr[i]);
            _sprH[i] = sprite_get_height(_spr[i]);
        }

        var _surfW = max(_sprW[0], _sprW[1]),
            _surfH = max(_sprH[0], _sprH[1]),
            _surf = surface_create(_surfW, _surfH);

        surface_set_target(_surf);
        draw_clear_alpha(0, 0);
    
        with(other){
    		for(var b = false; b <= true; b++){
    			var _dx = 0,
    				_dy = _surfH / 3;
    	
    			for(var i = 0; i <= 1; i++){
    				var _cut = (ceil(_sprW[i] / 2) + 2) - ceil(_sprW[i] / 8),
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

#define cleanup
    if(global.save_auto) save();

     // Clear Surfaces:
    with(surfList) surface_destroy(surf);

     // No Crash:
    with(["parrot"]){
        with(instances_matching([CampChar, CharSelect], "race", self)) instance_delete(id);
    }