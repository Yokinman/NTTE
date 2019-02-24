#define init
     // SPRITES //
    global.spr = {};
    with(global.spr){
        msk = {};

         // Top Decals:
        TopDecal = {
            "trench" : sprite_add("sprites/areas/Trench/sprTopDecalTrench.png", 1, 19, 24)
        }

    	 // Big Decals:
    	BigTopDecal = {
    	    "1"     : sprite_add("sprites/areas/Desert/sprDesertBigTopDecal.png", 1, 32, 24),
    	    "2"     : sprite_add("sprites/areas/Sewers/sprSewersBigTopDecal.png", 1, 32, 24),
    	    "pizza" : sprite_add("sprites/areas/Pizza/sprPizzaBigTopDecal.png",   1, 32, 24),
    	    "trench": sprite_add("sprites/areas/Trench/sprTrenchBigTopDecal.png", 1, 32, 24)
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

         // Harpoon:
        Harpoon      = sprite_add_weapon("sprites/weps/projectiles/sprHarpoon.png", 4, 3);
        NetNade      = sprite_add("sprites/weps/projectiles/sprNetNade.png", 1, 3, 3);
        NetNadeBlink = sprite_add("sprites/weps/projectiles/sprNetNadeBlink.png", 2, 3, 3);

         // Bubble Bombs:
    	BubbleBomb      = sprite_add("sprites/enemies/projectiles/sprBubbleBomb.png",     30,  8,  8);
    	BubbleExplode   = sprite_add("sprites/enemies/projectiles/sprBubbleExplode.png",   9, 24, 24);
    	BubbleCharge    = sprite_add("sprites/enemies/projectiles/sprBubbleCharge.png",   12, 12, 12);

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
        //#endregion

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
        	HarpoonGun = sprite_add("sprites/enemies/Diver/sprDiverHarpoonGunDischarged.png", 1, 8, 8);
        	//HarpoonGunEmpty = sprite_add("sprites/enemies/Diver/sprDiverHarpoonGunDischarged.png", 1, 8, 8);

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
        	CreatureIdle = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAACMAAAACgCAMAAADXNXIqAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAAAU9IAxsQWkrGXVgQ/w4ALiVetS/rwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKuM2GgAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGXRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4wLjE3M26fYwAADJxJREFUeF7t24ty20YSQFFlLcv//8VZYNCkAGLwIAYU0c45VSvSeM3dSRWqI1c+/gUASMYAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0WgaYj4k4eCERFuLghURYiIMXEmEhDl5IhIU4eCERFuLglUTZII5dSZQN4tiVRNkgjl1JlA3i2JVE2SCOXUmUDeLYlUTZII5dSZQN4tjZDj03kv6ZiINxyVtFSoSFOBiXvFWkRFiIg3HJW0VKhIU4GJe8VaREWIiDcclbRUqEhTgYl7xXtETZII7FFe8VLVE2iGNxxXtFS5QN4lhc8V7REmWDOBZXvFe0RNkgjsUV7xUtUTaIY3HFe0VLlA3iWFzxVpHyI33PPrBERFLVCxqfoa+NvjZX79sM1LdOXxt9bS7et5V3et9TT1tu+9+3N+6hvjb62ly9bzkw2nqX7JsE6luir42+Jst5o76T3y/7H7W+eeMdLI1x18/R10Zfm6v3LQcOSaVscMG+hw3UN6evjb4mi3mlbJp3Yt/eBy3WdWWxhRM/vYX62uhrc/2+pcC+bx54pb7aBuqb0tdGX5vFvC6tknde367HLO9eSasF/ugW6mujr83V+7rAyJkpJdXAa/Qtb+A/P5enr5G+Nrn7qnln9e14ykpdPe3mh7ZQXxt9ba7etxoYKVVX7/upCUtfG31t9K3YfsZKXWdhvAo/sYP62uhrc/m+1cCubznwRyaY9b7VDdTX0ddGX5v1vi5vue+M99/WIza2L0TP3Mt3UF8bfW3+jr7FQH36muhr83f0Rc1ce9/GE/ZtXy+KHr14B/W10dfm7+lbCNS3VwQ90LdXBD3Qt1cEPbhMX/Q8au5bf8BiXyw/8pYd1NdGX5u0ffOYq/dN/0PMb/qqYvURfXP62jzRV0vutfat3r/QF0s/qh9/5d/D6Wujr03SvoXAhcP6ZmLlB/oe6WvzV/UtHW7sW7u93hcL7/a6N7S+Nvra5Ox7NvDH+54M1PcoFt5J36NYeCd9D2LdvRr7Vu6u98Wy+/3zqh3U10Zfm5x9Twdeve9lb2h9bfS1ydkXiz6hrW/55iN9tdPdsZfsoL42+trk7NsIrOhuuXRft4H6vsWiT9A3Fos+Qd9IrPmE7p6WvsV7j+3f/Hy55QU7qK+NvjZJ+zYCK6f1TQyLLtF3o69N0r5hzUXn9y3deqyvEjjcc/oO6mujr03Svq3A+QXX6qttYP9DXyhLrtA30Ndmoa+suGJ+xXDkeN/CnYf3byHw7L+H09dGX5usfduB8XmXo+/sN7S+NvraZO0ra61Z6Dv+fqnfeHz/FgJPfgPqa6OvTdq+7cD4vNM3URZboa+nr03avrLWmtP76vctB240zk+3Blbpa6OvTdq+7cD4vLv1nRrY0Pd4Wt+Evj30tVns28pb7juaV71vdf9WC+dnb0fO3EB9bfS1ydvXBw7rLZid1jehbwd9bfL2dcv9cF/1tpXADfMrbjf90AZu0NfT1yZv36HA4UNfr6y1Ql9HX5u8fWWpFfNLbkeO9tVuW9m/frG1ysr/heGm7uO0HdTXRl+bzH0bgcMFE3HoGn1dRny5u92kr+iXKuvW6dPXaq2vX6ksWzdcMXG762Bf7a6NDSw/FszPdUc+fv3+3T3zp/4Blx8L5ue6I/pG9G1K3VcCY+25cn6iO3Khvnlgd0DfmL4t+tqs9lUSRubnuiNNfZW71vdv9a+5hguGz6+vP4Ovr4/fv399bAZ+FPGHFfrq9OkrtgOHmrnh/PDl6xZY+ro3zObSewOP95XA2+eor7wB9Q30bdBXd1Jfp7RU3E/2n5HX9zW8/yp3HeyLc4Nb3OCrvvZYd7pc+rr9i3MDfWuiaCrODfStiaKpODd4b181ME6FSWDp23jB7A/UV6NvQt+aSJqIU+GtfVE0FecGk7yh7+D7r3LXjg28+/j4VfTrx6HONK9XEuP5FVH352vH/umb06fv7pm+euDTfU8FPtk3BOq70zen75p9UTfNe75vJa9y1/7Aj/53y70+MI5V6jpfX5+fi423vO6qHfun75E+fSP7+yaBcej+m+eJW98ZgU/0lb8eL777qhu4s+/8F7S+GX2P/qt91fff8333vNrrZX7Hvr6y2j3wOy+Wmvi6qUZ+715/4Vn7VxbSV6EvFgp/W9+hwF+3m+pvl/C5HfjqvtoGRl1H311ZSF+FvlgovKSvrHPP+37/1V4wEdfnVfomefO+efC+/et1S5UB8Ptf3+p18W3QZY4bPz6+T3997tlAffoG+mqe6iuB/W94hyM7+iIwFnsIPLfvtoHfffXXc3wJfcRCX3dO3yN9i/RV7O+LvKfff+P3yziv+v6bBz+xgQ/6paY9XUyludPvYb/0ePf+dBef+w/4gb6evo6+irLWLDC+PYi+aWD3hnllX3k9T/u6JePLA30VZQ19h5U19B3VL9XljVbsp5X4OrX//TcPPhrYl0x3b/H1POgjHy9/4QbqG+gL+ibmfRuBfd8s8OV9D4ErfeUlPTmvT5++u3f3Pf/+q/TNgw8Fdq/WzjRoo6+/YHK+63vZBuq703ej767WdyTwtX3deuMFn+3rr9f3Td9u+u4a+qY9z+bV33/z4COBt7xJX/eH9cDZ9r1sA/V903ej76b09YGxVnEk8Mp9Lxyw9H3Td6cvRF9fdHckr9I3D34+cNi7XixV9H9YDXw42fd1yZs7qC/oC/rGzuo7FHjlvu4h+kb07aRv7Ky+I3mVvnnv04Gfn7dfEcVSRfnDauBU6esec/4G6pvQV6Vv2ncs8MJ9w4Cl70bfTvomTuo7lFfpm/c+G9jlnbF/pe8VG6hvSl+VvoeYg4Gb/wr3rr6YAPUFffvomzqp71jevG+e+2xg54T9i74XbGBH34i+Gn2PLU8GvmyA6XSPnQce7NucAPXV6YuFgr7dhrxpy7G8+ftlnns4MFYa2x9Y4rq39M+9oHv6dtE38l/qeyKwa/vs+173AoyFJvb39TvYbWD3mI1AfXX6KvTtsdi3P6+8Xsr75aFvXvt8YP/Y1v0rfaXw/A3UN6avRl9jYJ928b4SqG9M3w76xs7s25831FX65rUHAsujY6WpvYXd9pWHdF6wgcNza/TtoG/sb+2rpuzt6wuHp3R3rAee27c78HsH9X3Tt4O+sXP74nPTbYDpTPPmsUcDY6WpvYHlCeFFGxgrTenbQd/Y39rXFjgq1Deib5u+sf9U39684QmDaV8lNpbdbwiMpaaeCixf+h/rOxir7qdvIlbdT99ErLpfjr62wFJYProfV+0rgd3/9N3p26ZvIlbdb6Vvb979AeXnuK/aGgvvtRa4s/B+Xflc30B9c/r0fYt194q+emB8brndXT4v2He/UN+Evm36HsS6e0Xf8Pyp+tG5+3Xly7hvoTWW3ufzM+4aK833L+Vb1cbpBbHyPvpmYuV99M3Eyvuk7CsL3z7ja83G6QWx8j5NfXE+/rBXrLyPvplYeR99M7HyPin77quWLyvrb5xeG7Zi/WVx3btExbK47l2iYllc9y5RsSyue5eoWBbXvUtULIvr3iUqlsV17xIVy+K6d4mKZXHdu0TFsrjuXaJiWVz3LlGxLK57l6hYFte9S1Qsi+teauu3RQAAl2OAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAZP799/9U6bLI9L+tDwAAAABJRU5ErkJggg==",
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
             // Big Bubble:
            BigBubble    = sprite_add("sprites/areas/Oasis/sprBigBubble.png",    1, 24, 24);
            BigBubblePop = sprite_add("sprites/areas/Oasis/sprBigBubblePop.png", 4, 24, 24);

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
                        ["Loadout",  2, 16,  16, true],
                        ["Map",      1, 10,  10, true],
                        ["Portrait", 1, 20, 221, true],
                        ["Select",   2,  0,   0, false],
                        ["Idle",     4, 12,  12, true],
                        ["Walk",     6, 12,  12, true],
                        ["Hurt",     3, 12,  12, true],
                        ["Dead",     6, 12,  12, true],
                    ];

                Parrot[i] = {};
                with(_sprt){
                    var _name = self[0],
                        _img = self[1],
                        _x = self[2],
                        _y = self[3],
                        _hasB = self[4];

                    lq_set(other.Parrot[i], _name, sprite_add("sprites/races/Parrot/sprParrot" + (_hasB ? ["", "B"][i] : "") + _name + ".png", _img, _x, _y));
                }
            }

             // Parrot Feather:
            ParrotFeather = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAABmJLR0QAAAAAAAD5Q7t/AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4gccEhAKigKoTwAAAF5JREFUGNNjYMADipi4/hOUZEQWXMQi+J+BgYHhwr+fDH3/vjEyMDAwMCFLWkn+Y7jw7yeDARM7XBNcgZXkP4ZpT38zZEmzYtq3iEXwfxET1/87svz/YdagAJwSxAAAEiYfBSYTcvYAAAAASUVORK5CYII=", 1, 4, 4);
        //#endregion

        //#region PETS
             // Parrot:
            PetParrotIdle = sprite_add("sprites/pets/Coast/sprPetParrotIdle.png",   6, 12, 12);
            PetParrotWalk = sprite_add("sprites/pets/Coast/sprPetParrotWalk.png",   6, 12, 14);
            PetParrotHurt = sprite_add("sprites/pets/Coast/sprPetParrotDodge.png",  3, 12, 12);

             // CoolGuy:
            PetCoolGuyIdle = sprite_add("sprites/pets/Pizza/sprPetCoolGuyIdle.png",    4, 12, 12);
            PetCoolGuyWalk = sprite_add("sprites/pets/Pizza/sprPetCoolGuyWalk.png",    6, 12, 12);
            PetCoolGuyHurt = sprite_add("sprites/pets/Pizza/sprPetCoolGuyIdle.png",    4, 12, 12);

             // Golden Chest Mimic:
            PetMimicIdle = sprite_add("sprites/pets/Mansion/sprPetMimicIdle.png",       16, 16, 16);
            PetMimicWalk = sprite_add("sprites/pets/Mansion/sprPetMimicWalk.png",       6,  16, 16);
            PetMimicHurt = sprite_add("sprites/pets/Mansion/sprPetMimicHurt.png",       3,  16, 16);
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

             // Floor Chunks (Pit Squid):
            FloorTrenchBreak = sprite_add("sprites/areas/Trench/sprFloorTrenchBreak.png", 4, 12, 12);

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
            PitSquidCornea  = sprite_add("sprites/enemies/Pitsquid/sprPitsquidCornea.png",   1, 19, 19);
            PitSquidPupil   = sprite_add("sprites/enemies/Pitsquid/sprPitsquidPupil.png",    1, 19, 19);
            PitSquidEyelid  = sprite_add("sprites/enemies/Pitsquid/sprPitsquidEyelid.png",   3, 19, 19);
            PitSquidMaw     = sprite_add("sprites/enemies/Pitsquid/sprPitsquidMaw.png",     14, 19, 19);
            TentacleSpwn    = sprite_add("sprites/enemies/Pitsquid/sprTentacleSpwn.png",     6, 20, 28);
            TentacleIdle    = sprite_add("sprites/enemies/Pitsquid/sprTentacleIdle.png",     8, 20, 28);
            TentacleHurt    = sprite_add("sprites/enemies/Pitsquid/sprTentacleHurt.png",     3, 20, 28);
            TentacleDead    = sprite_add("sprites/enemies/Pitsquid/sprTentacleDead.png",     6, 20, 28);
            TentacleWarn    = sprite_add("sprites/enemies/PitSquid/sprTentacleWarn.png",    15, 12, 12);

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
            BatBossWeap     = sprite_add_weapon("sprites/enemies/BatBoss/sprBatBossWeap.png", 4,  8);
            VenomFlak       = sprite_add("sprites/enemies/BatBoss/sprVenomFlak.png", 2, 12, 12);

             // Cat:
            CatIdle = sprite_add("sprites/enemies/Cat/sprCatIdle.png",    4, 12, 12);
            CatWalk = sprite_add("sprites/enemies/Cat/sprCatWalk.png",    6, 12, 12);
            CatHurt = sprite_add("sprites/enemies/Cat/sprCatHurt.png",    3, 12, 12);
            CatDead = sprite_add("sprites/enemies/Cat/sprCatDead.png",    6, 12, 12);
            CatWeap = sprite_add("sprites/enemies/Cat/sprCatToxer.png",   1,  3,  4);
            AcidPuff = sprite_add("sprites/enemies/Cat/sprAcidPuff.png",  4, 16, 16);

             // Cat Boss:
            CatBossWeap = sprite_add("sprites/enemies/CatBoss/sprCatBossToxer.png", 1, 4, 7);

             // Door:
            CatDoor         = sprite_add("sprites/areas/Sewers/props/sprCatDoor.png",       10, 2, 0);
            msk.CatDoor     = sprite_add("sprites/areas/Sewers/props/mskCatDoor.png",        1, 4, 0);
            msk.CatDoorLOS  = sprite_add("sprites/areas/Sewers/props/mskCatDoorLOS.png",     1, 4, 0);
            if(fork()){
                wait 30;
                sprite_collision_mask(msk.CatDoorLOS, false, 1, 0, 0, 0, 0, 0, 0);
                exit;
            }

             // Drain:
            PizzaDrainIdle = sprite_add("sprites/areas/Pizza/sprPizzaDrain.png",     1, 24, 38);
            PizzaDrainHurt = sprite_add("sprites/areas/Pizza/sprPizzaDrainHurt.png", 3, 24, 38);
            PizzaDrainDead = mskNone;

             // Manholes:
            ManholeBottom = sprite_add("sprites/areas/Lair/sprManholeBottom.png", 1, 0, 0);
            Manhole = sprite_add("sprites/areas/Sewers/sprManhole.png",12,16,48);
            BigManhole = sprite_add("sprites/areas/Sewers/sprBigManhole.png",2,0,0);

             // Furniture:
                 // Rug:
                Rug = [
                    sprite_add("sprites/areas/Lair/Props/sprRugBot.png", 9, 0, 0),
                    sprite_add("sprites/areas/Lair/Props/sprRugTop.png", 9, 0, 0)];

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

        	 // Cursed mortar:
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
        //#endregion

        OptionNTTE = sprite_add("sprites/menu/sprOptionNTTE.png", 1, 32, 12);
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
        Placeholder = sound_add("music/musPlaceholder.ogg");

         // Areas:
        Coast   = sound_add("music/musCoast.ogg");
        Oasis   = mus101;
        Trench  = musBoss5;

         // Bosses:
        SealKing = sound_add("music/musSealKing.ogg");
    }

     // SAVE FILE //
    global.save = {
        option : {
            "allowShaders"     : true,
            "WaterQualityMain" : 1,
            "WaterQualityTop"  : 1
        }
    };

    if(fork()){
         // Load Existing Save:
        var _path = SavePath;
        wait file_load(_path);

        if(file_exists(_path)){
            var _save = json_decode(string_load(_path));
            if(_save != json_error){
                for(var i = 0; i < lq_size(_save); i++){
                    var k = lq_get_key(_save, i);
                    lq_set(global.save, k, lq_get(_save, k));
                }
                exit;
            }
        }

         // New Save File:
        string_save(json_encode(global.save), _path);
        exit;
    }

    global.surfCharm = -1;
    global.eye_shader = -1;
    global.charm = ds_list_create();
    global.charm_step = noone;

#macro EyeShader global.eye_shader
#macro surfCharm global.surfCharm

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus
#macro sav global.save
#macro opt sav.option

#macro SavePath "save.sav"

#define step
    if(!instance_exists(global.charm_step)){
        global.charm_step = script_bind_end_step(charm_step, 0);
        with(global.charm_step) persistent = true;
    }


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
        if(_spd <= 0) direction = _dir;
        else motion_add(_dir, _spd);
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

#define unlock_get(_unlock)
    var u = lq_defget(sav, "unlock", {});
    return lq_defget(u, _unlock, false);

#define unlock_set(_unlock, _value)
    if(!lq_exists(sav, "unlock")) sav.unlock = {};
    lq_set(sav.unlock, _unlock, _value);

#define scrPickupIndicator(_text)
    return mod_script_call("mod", "ntte", "scrPickupIndicator", _text);

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

#define scrCharm(_instance, _charm)
    var c = {
            "instance"  : _instance,
            "charmed"   : false,
            "target"    : noone,
            "alarm"     : [],
            "team"      : -1,
            "time"      : 0,
            "walk"      : 0
        };

    with(_instance){
        if("charm" not in self) charm = c;

        if(_charm != charm.charmed){
             // Charm:
            if(_charm){
                if("team" in self){
                    charm.team = team;
                    team = 2;
                }
                for(var i = 0; i <= 10; i++){
                    charm.alarm[i] = alarm_get(i);
                    alarm_set(i, -1);
                }
                ds_list_add(global.charm, charm);
            }

             // Uncharm:
            else{
                if("canmelee" in self && canmelee){
                    alarm11 = 30;
                    canmelee = false;
                }
                if(charm.team != -1){
                    team = charm.team;
                    charm.team = -1;
                }
                for(var i = 0; i <= 10; i++) alarm_set(i, charm.alarm[i]);

                 // Effects:
                sound_play_pitch(sndAssassinGetUp, 0.7);
                instance_create(x, bbox_top, AssassinNotice);
                for(var a = direction; a < direction + 360; a += (360 / 10)){
                    with(instance_create(x, y, Dust)) motion_add(a, 3);
                }
            }
        }
        charm.charmed = _charm;
        c = charm;
    }
    if(!_charm){
        var _charmList = ds_list_to_array(global.charm);
        with(_charmList){
            if(instance == _instance){
                ds_list_remove(global.charm, self);
                break;
            }
        }
    }
    return c;

#define scrCharmTarget()
    with(instance){
        var _x = x,
            _y = y;

        if(instance_is(self, enemy)){
            other.target = nearest_instance(_x, _y, instances_matching_ne(enemy, "team", team));
        }
        else other.target = instance_nearest(_x, _y, enemy);
    }

#define scrBossHP(_hp)
    var n = 0;
    for(var i = 0; i < maxp; i++) n += player_is_active(i);
    return round(_hp * (1 + ((1/3) * GameCont.loops)) * (1 + (0.5 * (n - 1))));

#define scrBossIntro(_name, _sound, _music)
    mod_script_call("mod", "ntte", "scrBossIntro", _name, _sound, _music);

#define scrUnlock(_name, _text, _sprite, _sound)
    return mod_script_call("mod", "ntte", "scrUnlock", _name, _text, _sprite, _sound);

#define scrTopDecal(_x, _y, _area)
    _area = string(_area);
    var _topDecal = {
        "0"   : TopDecalNightDesert,
        "1"   : TopDecalDesert,
        "2"   : TopDecalSewers,
        "3"   : TopDecalScrapyard,
        "4"   : TopDecalCave,
        "5"   : TopDecalCity,
        "7"   : TopDecalPalace,
        "102" : TopDecalPizzaSewers,
        "104" : TopDecalInvCave,
        "105" : TopDecalJungle,
        "106" : TopPot,
        "pizza" : TopDecalPizzaSewers
        };

    if(lq_exists(_topDecal, _area)){
        return instance_create(_x, _y, lq_get(_topDecal, _area));
    }
    else if(lq_exists(spr.TopDecal, _area)){
        with(instance_create(_x, _y, TopPot)){
            sprite_index = lq_get(spr.TopDecal, _area);
            image_index = irandom(image_number - 1);

             // Area-Specifics:
            switch(_area){
                case "trench":
                    right = choose(-1, 1);
                    break;
            }

            return id;
        }
    }
    return noone;

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

#define scrSwap()
	var _swap = ["wep", "curse", "reload", "wkick", "wepflip", "wepangle", "can_shoot"];
	for(var i = 0; i < array_length(_swap); i++){
		var	s = _swap[i],
			_temp = [variable_instance_get(id, "b" + s), variable_instance_get(id, s)];

		for(var j = 0; j < array_length(_temp); j++) variable_instance_set(id, chr(98 * j) + s, _temp[j]);
	}

	wepangle = (weapon_is_melee(wep) ? choose(120, -120) : 0);
	can_shoot = (reload <= 0);
	clicked = 0;

#define scrPortalPoof()
     // Get Rid of Portals (but make it look cool):
    if(instance_exists(Portal)){
        var _spr = sprite_duplicate(sprPortalDisappear);
        with(Portal) if(endgame >= 100){
            mask_index = mskNone;
            sprite_index = _spr;
            image_index = 0;
            if(fork()){
                while(instance_exists(self)){
                    if(anim_end) instance_destroy();
                    wait 1;
                }
                exit;
            }
        }
    }

#define scrPickupPortalize()
    var _scrt = "scrPickupPortalize";
    if(!instance_is(self, CustomEndStep) || script[2] != _scrt){
        with(CustomEndStep) if(script[2] == _scrt) exit;
        script_bind_end_step(scrPickupPortalize, 0);
    }

     // Attract Pickups:
    else{
        instance_destroy();
        if(instance_exists(Player) && !instance_exists(Portal)){
            var _pluto = skill_get(mut_plutonium_hunger);

             // Normal Pickups:
            var _attractDis = 30 + (40 * _pluto);
            with(instances_matching([AmmoPickup, HPPickup, RoguePickup], "", null)){
                var p = instance_nearest(x, y, Player);
                if(point_distance(x, y, p.x, p.y) >= _attractDis){
                    var _dis = 6 * current_time_scale,
                        _dir = point_direction(x, y, p.x, p.y),
                        _x = x + lengthdir_x(_dis, _dir),
                        _y = y + lengthdir_y(_dis, _dir);

                    if(place_free(_x, y)) x = _x;
                    if(place_free(x, _y)) y = _y;
                }
            }

             // Rads:
            var _attractDis = 80 + (60 * _pluto),
                _attractDisProto = 170;

            with(instances_matching([Rad, BigRad], "speed", 0)){
                var s = instance_nearest(x, y, ProtoStatue);
                if(distance_to_object(s) >= _attractDisProto || collision_line(x, y, s.x, s.y, Wall, false, false)){
                    if(distance_to_object(Player) >= _attractDis){
                        var p = instance_nearest(x, y, Player),
                            _dis = 12 * current_time_scale,
                            _dir = point_direction(x, y, p.x, p.y),
                            _x = x + lengthdir_x(_dis, _dir),
                            _y = y + lengthdir_y(_dis, _dir);

                        if(place_free(_x, y)) x = _x;
                        if(place_free(x, _y)) y = _y;
                    }
                }
            }
        }
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

#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)
    return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "x", _x1), "x", _x2), "y", _y1), "y", _y2);

#define instances_seen(_obj, _ext)
    var _vx = view_xview_nonsync,
        _vy = view_yview_nonsync,
        o = _ext;

    return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _vx - o), "bbox_left", _vx + game_width + o), "bbox_bottom", _vy - o), "bbox_top", _vy + game_height + o);

#define instance_random(_obj)
	if(is_array(_obj) || instance_exists(_obj)){
		var i = instances_matching(_obj, "", undefined);
		return i[irandom(array_length(i) - 1)];
	}
	return noone;

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
    with(TopCont) instance_destroy();
    with(SubTopCont) instance_destroy();
    with(BackCont) instance_destroy();

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
         // Sprite Fixes:
        var o = instances_matching(Wall, "cat_border_fix", null);
        if(array_length(o) > 0){
            var _spr = [area_get_sprite(_area, sprWall1Bot), area_get_sprite(_area, sprWall1Top), area_get_sprite(_area, sprWall1Out)];
            with(o){
                cat_border_fix = true;
                if(y >= _y){
                    sprite_index = _spr[0];
                    topspr = _spr[1];
                    outspr = _spr[2];
                }
            }
        }
        var o = instances_matching(TopSmall, "cat_border_fix", null);
        if(array_length(o) > 0){
            var _spr = area_get_sprite(_area, sprWall1Trans);
            with(o){
                cat_border_fix = true;
                if(y >= _y) sprite_index = _spr;
            }
        }
        var o = instances_matching(FloorExplo, "cat_border_fix", null);
        if(array_length(o) > 0){
            var _spr = area_get_sprite(_area, sprFloor1Explo);
            with(o){
                cat_border_fix = true;
                if(y >= _y) sprite_index = _spr;
            }
        }
        var o = instances_matching(Debris, "cat_border_fix", null);
        if(array_length(o) > 0){
            var _spr = area_get_sprite(_area, sprDebris1);
            with(o){
                cat_border_fix = true;
                if(y >= _y) sprite_index = _spr;
            }
        }

         // Background:
        var _vx = view_xview_nonsync,
            _vy = view_yview_nonsync;

        draw_set_color(_color);
        draw_rectangle(_vx, _y, _vx + game_width, max(_y, _vy + game_height), 0);
    }
    else script_bind_draw(area_border, 10000, _y, _area, _color);

#define area_get_sprite(_area, _spr)
    return mod_script_call("area", _area, "area_sprite", _spr);

#define floor_at(_x, _y)
    with(instances_matching(instances_matching(Floor, "x", floor(_x / 16) * 16), "y", floor(_y / 16) * 16)){
        if(position_meeting(_x, _y, self)){
            return self;
        }
    }
    with(instances_matching(instances_matching(Floor, "x", (floor((_x + 16) / 32) * 32) - 16), "y", (floor((_y + 16) / 32) * 32) - 16)){
        if(position_meeting(_x, _y, self)){
            return self;
        }
    }
    return noone;

#define in_range(_num, _lower, _upper)
    return (_num >= _lower && _num <= _upper);

#define wep_get(_wep)
    if(is_object(_wep)){
        return wep_get(lq_defget(_wep, "wep", 0));
    }
    return _wep;

#define path_create(_xstart, _ystart, _xtarget, _ytarget)
     // Auto-Determine Grid Size:
    var _tileSize = 16,
        _areaWidth = (ceil(abs(_xtarget - _xstart) / _tileSize) * _tileSize) + 320,
        _areaHeight = (ceil(abs(_ytarget - _ystart) / _tileSize) * _tileSize) + 320;

    _areaWidth = max(_areaWidth, _areaHeight);
    _areaHeight = max(_areaWidth, _areaHeight);

    var _triesMax = 4 * ceil((_areaWidth + _areaHeight) / _tileSize);

     // Clamp Path X/Y:
    _xstart = floor(_xstart / _tileSize) * _tileSize;
    _ystart = floor(_ystart / _tileSize) * _tileSize;
    _xtarget = floor(_xtarget / _tileSize) * _tileSize;
    _ytarget = floor(_ytarget / _tileSize) * _tileSize;

     // Grid Setup:
    var _gridw = ceil(_areaWidth / _tileSize),
        _gridh = ceil(_areaHeight / _tileSize),
        _gridx = round((((_xstart + _xtarget) / 2) - (_areaWidth / 2)) / _tileSize) * _tileSize,
        _gridy = round((((_ystart + _ytarget) / 2) - (_areaHeight / 2)) / _tileSize) * _tileSize,
        _grid = ds_grid_create(_gridw, _gridh),
        _gridCost = ds_grid_create(_gridw, _gridh);

    ds_grid_clear(_grid, -1);

     // Mark Walls:
    with(instance_rectangle(_gridx, _gridy, _gridx + _areaWidth, _gridy + _areaHeight, Wall)){
        _grid[# ((x - _gridx) / _tileSize), ((y - _gridy) / _tileSize)] = -2;
    }

     // Pathing:
    var _x1 = (_xtarget - _gridx) / _tileSize,
        _y1 = (_ytarget - _gridy) / _tileSize,
        _x2 = (_xstart - _gridx) / _tileSize,
        _y2 = (_ystart - _gridy) / _tileSize,
        _searchList = [[_x1, _y1, 0]],
        _tries = _triesMax;

    while(_tries-- > 0){
        var _search = _searchList[0],
            _sx = _search[0],
            _sy = _search[1],
            _sp = _search[2];

        if(_sp >= 1000000) break; // No more searchable tiles
        _search[2] = 1000000;

         // Sort Through Neighboring Tiles:
        var _costSoFar = _gridCost[# _sx, _sy];
        for(var i = 0; i < 2*pi; i += pi/2){
            var _nx = _sx + cos(i),
                _ny = _sy - sin(i),
                _nc = _costSoFar + 1;

            if(_grid[# _nx, _ny] == -1){
                if(_nx >= 0 && _ny >= 0){
                    if(_nx < _gridw && _ny < _gridh){
                        _gridCost[# _nx, _ny] = _nc;
                        _grid[# _nx, _ny] = point_direction(_nx, _ny, _sx, _sy);

                         // Add to Search List:
                        array_push(_searchList, [
                            _nx,
                            _ny,
                            point_distance(_x2, _y2, _nx, _ny) + (abs(_x2 - _nx) + abs(_y2 - _ny)) + _nc
                            ]);
                    }
                }
            }

             // Path Complete:
            if(_nx == _x2 && _ny == _y2){
                _tries = 0;
                break;
            }
        }

         // Next:
        array_sort_sub(_searchList, 2, true);
    }

     // Pack Path into Array:
    var _x = _xstart,
        _y = _ystart,
        _path = [[_x + (_tileSize / 2), _y + (_tileSize / 2)]],
        _tries = _triesMax;

    while(_tries-- > 0){
        var _dir = _grid[# ((_x - _gridx) / _tileSize), ((_y - _gridy) / _tileSize)];
        if(_dir >= 0){
            _x += lengthdir_x(_tileSize, _dir);
            _y += lengthdir_y(_tileSize, _dir);
            array_push(_path, [_x + (_tileSize / 2), _y + (_tileSize / 2)]);
        }
        else{
            _path = []; // Couldn't find path
            break;
        }

         // Done:
        if(_x == _xtarget && _y == _ytarget){
            break;
        }
    }
    if(_tries <= 0) _path = []; // Couldn't find path

    ds_grid_destroy(_grid);
    ds_grid_destroy(_gridCost);

    return _path;

#define race_get_sprite(_race, _sprite)
    var i = race_get_id(_race),
        n = race_get_name(_race);

    if(i < 17){
        var a = string_upper(string_char_at(n, 1)) + string_lower(string_delete(n, 1, 1));
        switch(_sprite){
            case sprMutant1Idle:        return asset_get_index(`sprMutant${i}Idle`);
            case sprMutant1Walk:        return asset_get_index(`sprMutant${i}Walk`);
            case sprMutant1Hurt:        return asset_get_index(`sprMutant${i}Hurt`);
            case sprMutant1Dead:        return asset_get_index(`sprMutant${i}Dead`);
            case sprMutant1GoSit:       return asset_get_index(`sprMutant${i}GoSit`);
            case sprMutant1Sit:         return asset_get_index(`sprMutant${i}Sit`);
            case sprFishMenu:           return asset_get_index("spr" + a + "Menu");
            case sprFishMenuSelected:   return asset_get_index("spr" + a + "MenuSelected");
            case sprFishMenuSelect:     return asset_get_index("spr" + a + "MenuSelect");
            case sprFishMenuDeselect:   return asset_get_index("spr" + a + "MenuDeselect");
        }
    }
    if(mod_script_exists("race", n, "race_sprite")){
        var s = mod_script_call("race", n, "race_sprite", _sprite);
        if(!is_undefined(s)) return s;
    }
    return -1;

#define cleanup
    with(global.charm_step) instance_destroy();

     // Save Save:
    string_save(json_encode(sav), SavePath);
