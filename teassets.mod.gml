#define init
     // SPRITES //
    global.spr = {};
    with(global.spr){
        msk = {};

    	 // Big Decals:
    	BigTopDecal = {
    	    "1"     : sprite_add("sprites/areas/Desert/sprDesertBigTopDecal.png", 1, 32, 40),
    	    "2"     : sprite_add("sprites/areas/Sewers/sprSewersBigTopDecal.png", 1, 32, 40),
    	    "102"   : sprite_add("sprites/areas/Pizza/sprPizzaBigTopDecal.png",   1, 32, 40)
    	}
    	msk.BigTopDecal = sprite_add("sprites/areas/Desert/mskBigTopDecal.png", 1, 32, 24);

    	 // Big Fish:
    	BigFishBecomeIdle = sprite_add("sprites/enemies/CoastBoss/sprBigFishBuild.png",      4, 40, 38);
    	BigFishBecomeHurt = sprite_add("sprites/enemies/CoastBoss/sprBigFishBuildHurt.png",  4, 40, 38);
    	BigFishSpwn =       sprite_add("sprites/enemies/CoastBoss/sprBigFishSpawn.png",     11, 32, 32);
    	BigFishLeap =       sprite_add("sprites/enemies/CoastBoss/sprBigFishLeap.png",      11, 32, 32);
    	BigFishSwim =       sprite_add("sprites/enemies/CoastBoss/sprBigFishSwim.png",       8, 24, 24);
    	BigFishRise =       sprite_add("sprites/enemies/CoastBoss/sprBigFishRise.png",       5, 32, 32);
    	BigFishSwimFrnt =   sprite_add("sprites/enemies/CoastBoss/sprBigFishSwimFront.png",  6,  4,  1);
    	BigFishSwimBack =   sprite_add("sprites/enemies/CoastBoss/sprBigFishSwimBack.png",  11,  5,  1);
    	BubbleBomb =        sprite_add("sprites/enemies/projectiles/sprBubbleBomb.png",     30,  8,  8);
    	BubbleExplode =     sprite_add("sprites/enemies/projectiles/sprBubbleExplode.png",   9, 24, 24);

         // Bone:
        Bone = sprite_add("sprites/weps/sprBone.png", 1, 6, 6);
        BoneShard = sprite_add("sprites/weps/projectiles/sprBoneShard.png", 1, 3, 2);

         // Harpoon:
        Harpoon = sprite_add_weapon("sprites/weps/projectiles/sprHarpoon.png", 4, 3);
        NetNade = sprite_add("sprites/weps/projectiles/sprNetNade.png", 1, 3, 3);

        //#region COAST
             // Blooming Cactus:
        	BloomingCactusIdle[0] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus.png",     1, 12, 12);
        	BloomingCactusHurt[0] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactusHurt.png", 3, 12, 12);
        	BloomingCactusDead[0] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactusDead.png", 4, 12, 12);
        	BloomingCactusIdle[1] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus2.png",     1, 12, 12);
        	BloomingCactusHurt[1] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus2Hurt.png", 3, 12, 12);
        	BloomingCactusDead[1] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus2Dead.png", 4, 12, 12);
        	BloomingCactusIdle[2] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus3.png",     1, 12, 12);
        	BloomingCactusHurt[2] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus3Hurt.png", 3, 12, 12);
        	BloomingCactusDead[2] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus3Dead.png", 4, 12, 12);

        	 // Buried Car:
        	BuriedCarIdle = sprite_add("sprites/areas/Coast/Props/sprBuriedCarIdle.png",1,16,16);
        	BuriedCarHurt = sprite_add("sprites/areas/Coast/Props/sprBuriedCarHurt.png",3,16,16);

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
        	HarpoonGunEmpty = sprite_add("sprites/enemies/Diver/sprDiverHarpoonGunDischarged.png", 1, 8, 8);

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
            GroundSlash     = sprite_add("sprites/enemies/projectiles/sprGroundSlash.png",      3,  0, 21);
            PalankingSlash  = sprite_add("sprites/enemies/projectiles/sprPalankingSlash.png",   3,  0, 24);
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
        	CreatureBott = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAKAAAACgCAYAAACLz2ctAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwgAADsIBFShKgAAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xNzNun2MAAAKjSURBVHhe7dJBbiNXFATB2fpKvv+95JUB4yMtUU1NacSORWwSJFHNfr/e3t7g22SElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZ/1S//vr77f+cn+VnyPjV6mD+NOfmK+p3f6LzuX6njM+qh+I1nO/6WRmvqsG8rvP9X5HxihrIPZy38BkZr6hh3Md5D4/KeEWN4j7Oe3hUxitqFPdy3sQjMl5Rg7iX8yYekfGKGsT9nHfxkYxX1Bju57yLj2S8osZwT+dtvCfjFTWEezpv4z0Zr6gh3NN5G+/JeEUN4Z7O23hPxqtqDPdz3sV7Ml5VY7iX8yY+kvGqGsR9nPfwiIzPqGG8vvMOHpXxGTWO13bewGdkfFaN5HWd7/8zMn6FGsrrOd/7Z2X8SjWa13G+78/K+LvUA/Bzne/3iozfoR6Qr3f+76W+96/zs8/K+NPUH/Vf5+e/Q+16xPk7ryYjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCBtvv/4Bi0CUPGa5758AAAAASUVORK5CYII=",
        	1, 80, 80);
        	CreatureFoam = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAKAAAACgCAYAAACLz2ctAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwAAADsABataJCQAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xNzNun2MAAAIVSURBVHhe7dLBTsIAFERR/v+nMe6voBUGtGeSs7npok3f5Xq9wstkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGd/YrdXzvLmMT/AXVu/9U/9l9W1PkfEB7P+u/vdhGX/BzrW6gR/JeJCdd3UP35LxIDv36ibuyniQnXt1E3dlPMis7uKmjAeZ1V3clPEgs8/VbXwp4y/ZeVf3cFPGB/nLq+/hCTI+0Tus3osXyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhI3r5QPGwQeqRTAO1AAAAABJRU5ErkJggg==",
        	1, 80, 80);

             // Water Streak:
            WaterStreak = sprite_add("sprites/areas/Coast/sprWaterStreak.png", 7, 8, 8);
    	//#endregion

        //#region OASIS
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
            Crack = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAEAAAAAgCAYAAACinX6EAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAZdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAuMTczbp9jAAAB6klEQVRoQ+WTUW7DMAxDc4j97H+n2xl292wyykBmaMuOndZYPx4QS65EMum27/tbI4sr8vHzvXu4z7TcMWTxVdQMci0yGPWBLL4aJX77+sxqdqdkEr1S3yOLK2DizXQvbDwKQRZXozeMqQFEA56FMhph2qcEYMPwjPozYWO91HTLoiIadBd4AYk/uVVwr4DSnx0ibAjXFH7RaGiHATZbAvcFwwHgbXCN8X2+z/B95jDARiPwO+I0nwsRfogS3xuAUQrB6kk4m+vhYRzwjuzQQjTQaLnDmFnAv5fGenHzsMf2SjEMLuOZh6EHeBHgex7f9/Olmas8ZmJP2uUPNZQJLxR9g5e04Gf7udLICKTteGihFgDj77XiAzxgA6OQtkxARCkAX4cBnK+AudLAKKQtW9yCf0McCOAlvRw7WPwMRgMANZOlYHo5iZ8Aa8sW9lAKwBasHMBpBxdawCfKRmcZB2kPGRiFd2SHVtL/02FCZ5sHbGCU03wutADjvnZXAICNXOU0lwuK9CkGb/zuAJIGMnMFnpsdavAbN7xpFcpM1BenDEb4GUZ2qFEK4G7jhtoN2CBgTSWd2aHG3SYZ22fGjdruyDjD/ay5El5oawCReWP5AEwg8DU8M7VeC7K4CioM5l8H8Axk8X3Yt1/rleuAjYarfgAAAABJRU5ErkJggg==",
            2, 16, 16);
        //#endregion
        
        //#region TRENCH
             // Eel (0 = blue, 1 = purple, 2 = green):
            EelIdle = [
                sprite_add("sprites/enemies/Eel/sprEelIdleBlue.png",8,16,16),
                sprite_add("sprites/enemies/Eel/sprEelIdlePurple.png",8,16,16),
                sprite_add("sprites/enemies/Eel/sprEelIdleGreen.png",8,16,16)];
            EelHurt = [
                sprite_add("sprites/enemies/Eel/sprEelHurtBlue.png",3,16,16),
                sprite_add("sprites/enemies/Eel/sprEelHurtPurple.png",3,16,16),
                sprite_add("sprites/enemies/Eel/sprEelHurtGreen.png",3,16,16)];
            EelDead = [
                sprite_add("sprites/enemies/Eel/sprEelDeadBlue.png",9,16,16),
                sprite_add("sprites/enemies/Eel/sprEelDeadPurple.png",9,16,16),
                sprite_add("sprites/enemies/Eel/sprEelDeadGreen.png",9,16,16)];
            EelTell = [
                sprite_add("sprites/enemies/Eel/sprEelTellBlue.png",8,16,16),
                sprite_add("sprites/enemies/Eel/sprEelTellPurple.png",8,16,16),
                sprite_add("sprites/enemies/Eel/sprEelTellGreen.png",8,16,16)];

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
            PitsquidCornea  = sprite_add("sprites/enemies/Pitsquid/sprPitsquidCornea.png", 1, 19, 19);
            PitsquidPupil   = sprite_add("sprites/enemies/Pitsquid/sprPitsquidPupil.png", 1, 19, 19);
            PitsquidEyelid  = sprite_add("sprites/enemies/Pitsquid/sprPitsquidEyelid.png", 3, 19, 19);
            PitsquidMaw     = sprite_add("sprites/enemies/Pitsquid/sprPitsquidMaw.png", 14, 19, 19);

             // Vent
            VentIdle = sprite_add("sprites/areas/Trench/Props/sprVentIdle.png", 1, 12, 14);
            VentHurt = sprite_add("sprites/areas/Trench/Props/sprVentHurt.png", 3, 12, 14);
            VentDead = sprite_add("sprites/areas/Trench/Props/sprVentDead.png", 6, 12, 14);

             // Yeti Crab:
            YetiCrabIdle = sprite_add("sprites/enemies/YetiCrab/sprYetiCrab.png",   1, 12, 12);
            KingCrabIdle = sprite_add("sprites/enemies/YetiCrab/sprKingCrab.png",   1, 12, 12);
        //#endregion

        //#region SEWERS
             // Cat:
            CatIdle = sprite_add("sprites/enemies/Cat/sprCatIdle.png",    4, 12, 12);
            CatWalk = sprite_add("sprites/enemies/Cat/sprCatWalk.png",    6, 12, 12);
            CatHurt = sprite_add("sprites/enemies/Cat/sprCatHurt.png",    3, 12, 12);
            CatDead = sprite_add("sprites/enemies/Cat/sprCatDead.png",    6, 12, 12);
            AcidPuff = sprite_add("sprites/enemies/Cat/sprAcidPuff.png",  4, 16, 16);

             // Drain:
            PizzaDrainIdle = sprite_add("sprites/areas/Pizza/sprPizzaDrain.png",     1, 24, 38);
            PizzaDrainHurt = sprite_add("sprites/areas/Pizza/sprPizzaDrainHurt.png", 3, 24, 38);
            PizzaDrainDead = mskNone;

             // Manholes:
            Manhole = sprite_add("sprites/areas/Sewers/sprManhole.png",12,16,48);
            BigManhole = sprite_add("sprites/areas/Sewers/sprBigManhole.png",2,0,0);
            PizzaManhole = sprite_add("sprites/areas/Sewers/sprPizzaManhole.png",2,0,0);

             // Furniture:
                 // Rug:
                Rug = [
                    sprite_add("sprites/areas/Sewers/Props/sprRugBot.png", 9, 0, 0),
                    sprite_add("sprites/areas/Sewers/Props/sprRugTop.png", 9, 0, 0)];

                 // Table:
                TableIdle = sprite_add("sprites/areas/Sewers/Props/sprTableIdle.png", 1, 16, 16);
                TableHurt = sprite_add("sprites/areas/Sewers/Props/sprTableHurt.png", 3, 16, 16);
                TableDead = sprite_add("sprites/areas/Sewers/Props/sprTableDead.png", 3, 16, 16);

                 // Chairs:
                    ChairDead       = sprite_add("sprites/areas/Sewers/Props/sprChairDead.png",         3, 12, 12);

                     // Side:
                    ChairSideIdle   = sprite_add("sprites/areas/Sewers/Props/sprChairSideIdle.png",     1, 12, 12);
                    ChairSideHurt   = sprite_add("sprites/areas/Sewers/Props/sprChairSideHurt.png",     3, 12, 12);

                     // Front:
                    ChairFrontIdle  = sprite_add("sprites/areas/Sewers/Props/sprChairFrontIdle.png",    1, 12, 12);
                    ChairFrontHurt  = sprite_add("sprites/areas/Sewers/Props/sprChairFrontHurt.png",    3, 12, 12);

                 // Cabinet:
                CabinetIdle = sprite_add("sprites/areas/Sewers/Props/sprCabinetIdle.png", 1, 12, 12);
                CabinetHurt = sprite_add("sprites/areas/Sewers/Props/sprCabinetHurt.png", 3, 12, 12);
                CabinetDead = sprite_add("sprites/areas/Sewers/Props/sprCabinetDead.png", 3, 12, 12);

                 // Couch:
                CouchIdle = sprite_add("sprites/areas/Sewers/Props/sprCouchIdle.png", 1, 32, 32);
                CouchHurt = sprite_add("sprites/areas/Sewers/Props/sprCouchHurt.png", 3, 32, 32);
                CouchDead = sprite_add("sprites/areas/Sewers/Props/sprCouchDead.png", 3, 32, 32);

             // FX:
            Paper = sprite_add("sprites/areas/Sewers/Props/sprPaper.png", 3, 5, 6);
        //#endregion

        //#region CRYSTAL CAVES
        	 // Mortar:
        	MortarIdle    = sprite_add("sprites/enemies/Mortar/sprMortarIdle.png",    4, 22, 24);
        	MortarWalk    = sprite_add("sprites/enemies/Mortar/sprMortarWalk.png",    8, 22, 24);
        	MortarFire    = sprite_add("sprites/enemies/Mortar/sprMortarFire.png",   16, 22, 24);
        	MortarHurt    = sprite_add("sprites/enemies/Mortar/sprMortarHurt.png",    3, 22, 24);
        	MortarDead    = sprite_add("sprites/enemies/Mortar/sprMortarDead.png",   14, 22, 24);
        	MortarPlasma  = sprite_add("sprites/enemies/Mortar/sprMortarPlasma.png",  1,  4,  4);
        	MortarImpact  = sprite_add("sprites/enemies/Mortar/sprMortarImpact.png",  7, 16, 16);
        	MortarTrail   = sprite_add("sprites/enemies/Mortar/sprMortarTrail.png",   3,  4,  4);
        	 // Spiderling:
        	SpiderlingIdle = sprite_add("sprites/enemies/Spiderling/sprSpiderlingIdle.png", 4, 8, 8);
        	SpiderlingWalk = sprite_add("sprites/enemies/Spiderling/sprSpiderlingWalk.png", 4, 8, 8);
        	SpiderlingHurt = sprite_add("sprites/enemies/Spiderling/sprSpiderlingHurt.png", 3, 8, 8);
        	SpiderlingDead = sprite_add("sprites/enemies/Spiderling/sprSpiderlingDead.png", 7, 8, 8);
        //#endregion
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
    }

     // MUSIC //
    global.mus = {};
    with(global.mus){
        Placeholder = sound_add("music/musPlaceholder.ogg");

         // Areas:
        Coast   = sound_add("music/musCoast.ogg");
        Oasis   = mus101;
        Trench  = musBoss5;

         // Bosses:
        SealKing = sound_add("music/musSealKing.ogg");
    }

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus

 /// HELPER SCRIPTS ///
#define obj_create(_x, _y, _obj)
    return mod_script_call("mod", "telib", "obj_create", _x, _y, _obj);

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
    _dir = (_dir + 360) mod 360;
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

#define enemySprites()
     // Not Hurt:
    if(sprite_index != spr_hurt){
        if(speed <= 0) sprite_index = spr_idle;
    	else if(sprite_index == spr_idle) sprite_index = spr_walk;
    }

     // Hurt:
    else if(image_index > image_number - 1){
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

#define scrDefaultDrop
    pickup_drop(16, 0); // Bandit drop-ness

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

#define z_engine()
    z += zspeed * current_time_scale;
    zspeed -= zfric * current_time_scale;

#define lightning_connect(_x1, _y1, _x2, _y2, _arc)
    var _lastx = _x1,
        _lasty = _y1,
        _x = _lastx,
        _y = _lasty,
        o = max(point_distance(_x1, _y1, _x2, _y2) / 8, 10),
        a = 0,
        r = [];

    while(point_distance(_x, _y, _x2, _y2) > 2 * o){
        var _dir = point_direction(_x, _y, _x2, _y2);
        _x += lengthdir_x(o, _dir);
        _y += lengthdir_y(o, _dir);

        var _off = 4 * sin((point_distance(_x, _y, _x2, _y2) / 8) + (current_frame / 6)),
            m = point_distance(_x, _y, _x2, _y2) / point_distance(_x1, _y1, _x2, _y2),
            _ox = _x + lengthdir_x(_off, _dir - 90) + (_arc * sin(m * pi)),
            _oy = _y + lengthdir_y(_off, _dir - 90) + (_arc * sin(m * pi/2));

        array_push(r, scrLightning(_lastx, _lasty, _ox, _oy, true));
        _lastx = _ox;
        _lasty = _oy;
    }
    array_push(r, scrLightning(_lastx, _lasty, _x2, _y2, true));

    for(var i = 0; i < array_length(r); i++){
        with(r[i]) ammo = (array_length(r) - 1) - i;
    }

    return r;

#define scrLightning(_x1, _y1, _x2, _y2, _enemy)
    with(instance_create(_x2, _y2, (_enemy ? EnemyLightning : Lightning))){
        image_xscale = -point_distance(_x1, _y1, _x2, _y2) / 2;
        image_angle = point_direction(_x1, _y1, _x2, _y2);
        direction = image_angle;
        return id;
    }

#define scrBossHP(_hp)
    var n = 0;
    for(var i = 0; i < maxp; i++) n += player_is_active(i);
    return round(_hp * (1 + ((1/3) * GameCont.loops)) * (1 + (0.5 * (n - 1))));

#define scrBossIntro(_name, _sound, _music)
    mod_script_call("mod", "ntte", "scrBossIntro", _name, _sound, _music);

#define scrWaterStreak(_x, _y, _dir, _spd)
    with(instance_create(_x, _y, AcidStreak)){
        sprite_index = spr.WaterStreak;
        motion_add(_dir, _spd);
        vspeed -= 2;
        image_angle = direction;
        image_speed = 0.4 + random(0.2);
        depth = 0;

        return id;
    }

#define scrRadDrop(_x, _y, _raddrop, _dir, _spd)
	while(_raddrop > 0){
		var r = (_raddrop > 15);
		repeat(r ? 1 : _raddrop){
			if(r) _raddrop -= 10;
			with(instance_create(_x, _y, (r ? BigRad : Rad))){
				speed = _spd;
				direction = _dir;
				motion_add(random(360), random(_raddrop / 2) + 2);
				speed *= power(0.9, speed);
			}
		}
		if(!r) break;
	}

#define orandom(n) // For offsets
    return random_range(-n, n);

#define floor_ext(_num, _round)
    return floor(_num / _round) * _round;

#define array_count(_array, _value)
    var c = 0;
    for(var i = 0; i < array_length(_array); i++){
        if(_array[i] == _value) c++;
    }
    return c;

#define array_flip(_array)
    var a = array_clone(_array),
        m = array_length(_array);

    for(var i = 0; i < m; i++){
        _array[@i] = a[(m - 1) - i];
    }

#define instances_named(_object, _name)
    return instances_matching(_object, "name", _name);

#define nearest_instance(_x, _y, _instances)
	var	_nearest = noone,
		d = 1000000;

	with(_instances) if(instance_exists(self)){
		var _dis = point_distance(_x, _y, x, y);
		if(_dis < d){
			_nearest = id;
			d = _dis;
		}
	}

	return _nearest;

#define instances_seen(_obj, _ext)
    var _vx = view_xview_nonsync,
        _vy = view_yview_nonsync,
        o = _ext;

    return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _vx - o), "bbox_left", _vx + game_width + o), "bbox_bottom", _vy - o), "bbox_top", _vy + game_height + o);

#define frame_active(_interval)
    return ((current_frame mod _interval) < current_time_scale);

#define area_generate(_sx, _sy, _area)
    GameCont.area = _area;

     // Store Player Positions:
    var _px = [], _py = [], _vx = [], _vy = [];
    with(Player){
        _px[index] = x;
        _py[index] = y;
        _vx[index] = view_xview[index];
        _vy[index] = view_yview[index];
    }

     // No Duplicates:
    with(instances_matching([TopCont, SubTopCont, BackCont], "", null)) instance_destroy();

     // Exclude These:
    var _oldFloor = instances_matching(Floor, "", null),
        _oldChest = [],
        _chest = [WeaponChest, AmmoChest, RadChest, RogueChest, HealthChest];

    for(var i = 0; i < array_length(_chest); i++){
        _oldChest[i] = instances_matching(_chest[i], "", null);
    }

     // Generate Level:
    with(instance_create(0, 0, GenCont)){
        var _hard = GameCont.hard;
        spawn_x = _sx + 16;
        spawn_y = _sy + 16;

         // FloorMaker Fixes:
        goal += instance_number(Floor);
        var _floored = instance_nearest(10000, 10000, Floor);
        with(FloorMaker){
            goal = other.goal;
            if(!position_meeting(x, y, _floored)){
                with(instance_nearest(x, y, Floor)) instance_destroy();
            }
            x = _sx;
            y = _sy;
            instance_create(x, y, Floor);
        }

         // Floor & Chest Gen:
        while(instance_exists(FloorMaker)){
            with(FloorMaker) if(instance_exists(self)){
                event_perform(ev_step, ev_step_normal);
            }
        }

         // Find Newly Generated Things:
        var f = instances_matching(Floor, "", null),
            _newFloor = array_slice(f, 0, array_length(f) - array_length(_oldFloor)),
            _newChest = [];

        for(var i = 0; i < array_length(_chest); i++){
            var c = instances_matching(_chest[i], "", null);
            _newChest[i] = array_slice(c, 0, array_length(c) - array_length(_oldChest[i]));
        }

         // Make Walls:
        with(_newFloor) scrFloorWalls();

         // Spawn Enemies:
        with(_newFloor){
            if(random(_hard + 10) < _hard){
                if(!place_meeting(x, y, chestprop) && !place_meeting(x, y, RadChest)){
                    // (distance to spawn coordinates > 120) check
                    mod_script_call("area", _area, "area_pop_enemies");
                }
            }
        }
        with(_newFloor){
             // Minimum Enemy Count:
            if(instance_number(enemy) < (3 + (_hard / 1.5))){
                if(!place_meeting(x, y, chestprop) && !place_meeting(x, y, RadChest)){
                    // (distance to spawn coordinates > 120) check
                    mod_script_call("area", _area, "area_pop_enemies");
                }
            }
             
              // Crown of Blood:
            if(GameCont.crown = crwn_blood){
                if(random(_hard + 8) < _hard){
                    if(!place_meeting(x, y, chestprop) && !place_meeting(x, y, RadChest)){
                        // (distance to spawn coordinates > 120) check
                        mod_script_call("area", _area, "area_pop_enemies");
                    }
                }
            }
            
             // Props:
            mod_script_call("area", _area, "area_pop_props");
        }

         // Find # of Chests to Keep:
        gol = 1;
        wgol = 0;
        agol = 0;
        rgol = 0;
        if(skill_get(mut_open_mind)){
            var m = choose(0, 1, 2);
            switch(m){
                case 0: wgol++; break;
                case 1: agol++; break;
                case 2: rgol++; break;
            }
        }
        mod_script_call("area", _area, "area_pop_chests");

         // Clear Extra Chests:
        var _extra = [wgol, agol, rgol, rgol, 0];
        for(var i = 0; i < array_length(_newChest); i++){
            var n = array_length(_newChest[i]);
            if(n > 0 && gol + _extra[i] > 0){
                while(n-- > gol + _extra[i]){
                    instance_delete(nearest_instance(_sx + random_range(-250, 250), _sy + random_range(-250, 250), _newChest[i]));
                }
            }
        }

         // Crown of Love:
        if(GameCont.crown = crwn_love){
            for(var i = 0; i < array_length(_newChest); i++) with(_newChest[i]){
                if(instance_exists(self)){
                    instance_create(x, y, AmmoChest);
                    instance_delete(id);
                }
            }
        }

         // Rad Can -> Health Chest:
        else{
            var _lowHP = false;
            with(Player) if(my_health < maxhealth / 2) _lowHP = true;
            with(_newChest[2]) if(instance_exists(self)){
                if((_lowHP && random(2) < 1) || (GameCont.crown == crwn_life && random(3) < 2)){
                    array_push(_newChest[4], instance_create(x, y, HealthChest));
                    instance_destroy();
                    break;
                }
            }
        }

         // Mimics:
        with(_newChest[1]) if(instance_exists(self) && random(11) < 1){
            instance_create(x, y, Mimic);
            instance_delete(id);
        }
        with(_newChest[4]) if(instance_exists(self) && random(51) < 1){
            instance_create(x, y, SuperMimic);
            instance_delete(id);
        }

         // Extras:
        mod_script_call("area", _area, "area_pop_extras");

         // Done + Fix Random Wall Spawn:
        var _wall = instances_matching(Wall, "", null);

        event_perform(ev_alarm, 1);

        if(instance_number(Wall) > array_length(_wall)){
            with(Wall.id) instance_delete(id);
        }
    }

     // Remove Portal FX:
    with(instances_matching([Spiral, SpiralCont], "", null)) instance_destroy();
    repeat(4) with(instance_nearest(10016, 10016, PortalL)) instance_destroy();
    with(instance_nearest(10016, 10016, PortalClear)) instance_destroy();
    sound_stop(sndPortalOpen);

     // Reset Player & Camera Pos:
    var s = UberCont.opt_shake;
    UberCont.opt_shake = 1;
    with(Player){
        sound_stop(snd_wrld);

        x = _px[index];
        y = _py[index];

        var g = gunangle,
            _x = _vx[index],
            _y = _vy[index];

        gunangle = point_direction(0, 0, _x, _y);
        weapon_post(wkick, point_distance(0, 0, _x, _y), 0);
        gunangle = g;
    }
    UberCont.opt_shake = s;

#define scrFloorWalls() /// this is gross but dont blame me it runs faster than a for loop which is important
    if(!position_meeting(x - 16, y - 16, Floor)) instance_create(x - 16, y - 16, Wall);
    if(!position_meeting(x,      y - 16, Floor)) instance_create(x,      y - 16, Wall);
    if(!position_meeting(x + 16, y - 16, Floor)) instance_create(x + 16, y - 16, Wall);
    if(!position_meeting(x + 32, y - 16, Floor)) instance_create(x + 32, y - 16, Wall);
    if(!position_meeting(x + 32, y,      Floor)) instance_create(x + 32, y,      Wall);
    if(!position_meeting(x + 32, y + 16, Floor)) instance_create(x + 32, y + 16, Wall);
    if(!position_meeting(x - 16, y,      Floor)) instance_create(x - 16, y,      Wall);
    if(!position_meeting(x - 16, y + 16, Floor)) instance_create(x - 16, y + 16, Wall);
    if(!position_meeting(x - 16, y + 32, Floor)) instance_create(x - 16, y + 32, Wall);
    if(!position_meeting(x,      y + 32, Floor)) instance_create(x,      y + 32, Wall);
    if(!position_meeting(x + 16, y + 32, Floor)) instance_create(x + 16, y + 32, Wall);
    if(!position_meeting(x + 32, y + 32, Floor)) instance_create(x + 32, y + 32, Wall);

#define floor_reveal(_floors, _maxTime)
    if(instance_is(self, CustomDraw) && script[2] == "floor_reveal"){
        if(array_length(_floors) > num){
            var _yOffset = 8;
            draw_set_color(area_get_background_color(102));
    
             // Hiding Floors:
            with(array_slice(_floors, num + 1, array_length(_floors) - (num + 1))){
                draw_rectangle(x - 15, y - _yOffset, x + 32 + 15, y + 31 - _yOffset, 0);
            }
    
             // Revealing Floor:
            if(time-- > 0){
                var a = (time / _maxTime);
                _yOffset += 4 * a;
    
                draw_set_alpha(a);
                draw_set_color(merge_color(draw_get_color(), c_white, a));
                with(_floors[num]){
                    draw_rectangle(x - 15, y - _yOffset, x + 32 + 15, y + 31 - _yOffset, 0);
                }
                draw_set_alpha(1);
            }
    
             // Next Floor:
            else{
                num++;
                time = _maxTime;
            }
        }
        else instance_destroy();
    }
    else with(script_bind_draw(floor_reveal, -7, _floors, _maxTime)){
        time = _maxTime;
        num = 0;
    }

#define area_border(_y, _area, _color)
    if(instance_is(self, CustomDraw) && script[2] == "area_border"){
         // Wall Fixes:
        with(instances_matching(Wall, "cat_border_fix", null)){
            cat_border_fix = true;
            if(y >= _y){
                sprite_index = area_get_sprite(_area, sprWall1Bot);
                topspr = area_get_sprite(_area, sprWall1Top);
                outspr = area_get_sprite(_area, sprWall1Out);
            }
        }
        with(instances_matching(TopSmall, "cat_border_fix", null)){
            cat_border_fix = true;
            if(y >= _y){
                sprite_index = area_get_sprite(_area, sprWall1Trans);
            }
        }
    
         // Background:
        draw_set_color(_color);
        draw_rectangle(0, _y, 20000, 20000, 0);
    }
    else script_bind_draw(area_border, 10000, _y, _area, _color);

#define area_get_sprite(_area, _spr)
    return mod_script_call("area", _area, "area_sprite", _spr);