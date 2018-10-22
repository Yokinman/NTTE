#define init
    //#region SPRITES

    	 // Big Decals:
    	global.sprBigTopDecal = {
    	    "1"     : sprite_add("sprites/areas/Desert/sprDesertBigTopDecal.png", 1, 32, 40),
    	    "2"     : sprite_add("sprites/areas/Sewers/sprSewersBigTopDecal.png", 1, 32, 40),
    	    "102"   : sprite_add("sprites/areas/Pizza/sprPizzaBigTopDecal.png",   1, 32, 40)
    	}
    	global.mskBigTopDecal = sprite_add("sprites/areas/Desert/mskBigTopDecal.png", 1, 32, 24);

    	 // Big Fish:
    	global.sprBigFishBecomeIdle = sprite_add("sprites/enemies/CoastBoss/sprBigFishBuild.png",      4, 40, 38);
    	global.sprBigFishBecomeHurt = sprite_add("sprites/enemies/CoastBoss/sprBigFishBuildHurt.png",  4, 40, 38);
    	global.sprBigFishSpwn =       sprite_add("sprites/enemies/CoastBoss/sprBigFishSpawn.png",     11, 32, 32);
    	global.sprBigFishLeap =       sprite_add("sprites/enemies/CoastBoss/sprBigFishLeap.png",      11, 32, 32);
    	global.sprBigFishSwim =       sprite_add("sprites/enemies/CoastBoss/sprBigFishSwim.png",       8, 24, 24);
    	global.sprBigFishRise =       sprite_add("sprites/enemies/CoastBoss/sprBigFishRise.png",       5, 32, 32);
    	global.sprBigFishSwimFrnt =   sprite_add("sprites/enemies/CoastBoss/sprBigFishSwimFront.png",  6,  4,  1);
    	global.sprBigFishSwimBack =   sprite_add("sprites/enemies/CoastBoss/sprBigFishSwimBack.png",  11,  5,  1);
    	global.sprBubbleBomb =        sprite_add("sprites/enemies/projectiles/sprBubbleBomb.png",     30,  8,  8);
    	global.sprBubbleExplode =     sprite_add("sprites/enemies/projectiles/sprBubbleExplode.png",   9, 24, 24);

         // Bone:
        global.sprBone = sprite_add("sprites/weps/sprBone.png", 1, 6, 6);
        global.sprBoneShard = sprite_add("sprites/weps/projectiles/sprBoneShard.png", 1, 3, 2);

         // Harpoon:
        global.sprHarpoon = sprite_add_weapon("sprites/weps/projectiles/sprHarpoon.png", 4, 3);
        global.sprNetNade = sprite_add("sprites/weps/projectiles/sprNetNade.png", 1, 3, 3);

        //#region COAST
             // Blooming Cactus:
        	global.sprBloomingCactusIdle[0] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus.png",     1, 12, 12);
        	global.sprBloomingCactusHurt[0] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactusHurt.png", 3, 12, 12);
        	global.sprBloomingCactusDead[0] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactusDead.png", 4, 12, 12);

        	global.sprBloomingCactusIdle[1] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus2.png",     1, 12, 12);
        	global.sprBloomingCactusHurt[1] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus2Hurt.png", 3, 12, 12);
        	global.sprBloomingCactusDead[1] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus2Dead.png", 4, 12, 12);

        	global.sprBloomingCactusIdle[2] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus3.png",     1, 12, 12);
        	global.sprBloomingCactusHurt[2] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus3Hurt.png", 3, 12, 12);
        	global.sprBloomingCactusDead[2] = sprite_add("sprites/areas/Coast/Props/sprBloomingCactus3Dead.png", 4, 12, 12);
        	
        	 // Buried Car:
        	global.sprBuriedCarIdle = sprite_add("sprites/areas/Coast/Props/sprBuriedCarIdle.png",1,16,16);
        	global.sprBuriedCarHurt = sprite_add("sprites/areas/Coast/Props/sprBuriedCarHurt.png",3,16,16);

             // Decal Big Shell Prop:
    	    global.sprShellIdle = sprite_add("sprites/areas/Coast/Decals/sprShellIdle.png", 1, 32, 32);
    	    global.sprShellHurt = sprite_add("sprites/areas/Coast/Decals/sprShellHurt.png", 3, 32, 32);
    	    global.sprShellDead = sprite_add("sprites/areas/Coast/Decals/sprShellDead.png", 6, 32, 32);
    	    global.sprShellBott = sprite_add("sprites/areas/Coast/Decals/sprShellBott.png", 1, 32, 32);
    	    global.sprShellFoam = sprite_add("sprites/areas/Coast/Decals/sprShellFoam.png", 1, 32, 32);

             // Decal Water Rock Props:
            global.sprRockIdle[0] = sprite_add("sprites/areas/Coast/Decals/sprRock1Idle.png", 1, 16, 16);
            global.sprRockHurt[0] = sprite_add("sprites/areas/Coast/Decals/sprRock1Hurt.png", 3, 16, 16);
            global.sprRockDead[0] = sprite_add("sprites/areas/Coast/Decals/sprRock1Dead.png", 1, 16, 16);
            global.sprRockBott[0] = sprite_add("sprites/areas/Coast/Decals/sprRock1Bott.png", 1, 16, 16);
            global.sprRockFoam[0] = sprite_add("sprites/areas/Coast/Decals/sprRock1Foam.png", 1, 16, 16);
            global.sprRockIdle[1] = sprite_add("sprites/areas/Coast/Decals/sprRock2Idle.png", 1, 16, 16);
            global.sprRockHurt[1] = sprite_add("sprites/areas/Coast/Decals/sprRock2Hurt.png", 3, 16, 16);
            global.sprRockDead[1] = sprite_add("sprites/areas/Coast/Decals/sprRock2Dead.png", 1, 16, 16);
            global.sprRockBott[1] = sprite_add("sprites/areas/Coast/Decals/sprRock2Bott.png", 1, 16, 16);
            global.sprRockFoam[1] = sprite_add("sprites/areas/Coast/Decals/sprRock2Foam.png", 1, 16, 16);

             // Diver:
        	global.sprDiverIdle = sprite_add("sprites/enemies/Diver/sprDiverIdle.png", 4, 12, 12);
        	global.sprDiverWalk = sprite_add("sprites/enemies/Diver/sprDiverWalk.png", 6, 12, 12);
        	global.sprDiverHurt = sprite_add("sprites/enemies/Diver/sprDiverHurt.png", 3, 12, 12);
        	global.sprDiverDead = sprite_add("sprites/enemies/Diver/sprDiverDead.png", 9, 16, 16);
        	global.sprHarpoonGun = sprite_add("sprites/enemies/Diver/sprDiverHarpoonGun.png", 1, 8, 8);
        	global.sprHarpoonGunEmpty = sprite_add("sprites/enemies/Diver/sprDiverHarpoonGunDischarged.png", 1, 8, 8);

        	 // Gull:
        	global.sprGullIdle = sprite_add("sprites/enemies/Gull/sprGullIdle.png", 4, 12, 12);
        	global.sprGullWalk = sprite_add("sprites/enemies/Gull/sprGullWalk.png", 6, 12, 12);
        	global.sprGullHurt = sprite_add("sprites/enemies/Gull/sprGullHurt.png", 3, 12, 12);
        	global.sprGullDead = sprite_add("sprites/enemies/Gull/sprGullDead.png", 6, 16, 16);
        	global.sprGullSword = sprite_add("sprites/enemies/Gull/sprGullSword.png", 1, 6, 8);

             // Palanking:
            global.sprPalankingBott = sprite_add("sprites/enemies/Palanking/sprPalankingBase.png",      1, 40, 24);
            global.sprPalankingTaunt = sprite_add("sprites/enemies/Palanking/sprPalankingTaunt.png",   31, 40, 24);
            global.sprPalankingCall = sprite_add("sprites/enemies/Palanking/sprPalankingCall.png",      9, 40, 24);
            global.sprPalankingIdle = sprite_add("sprites/enemies/Palanking/sprPalankingIdle.png",     16, 40, 24);
            global.sprPalankingWalk = sprite_add("sprites/enemies/Palanking/sprPalankingWalk.png",     16, 40, 24);
            global.sprPalankingHurt = sprite_add("sprites/enemies/Palanking/sprPalankingHurt.png",      3, 40, 24);
            global.sprPalankingDead = sprite_add("sprites/enemies/Palanking/sprPalankingDead.png",      1, 40, 24);
            global.sprPalankingBurp = sprite_add("sprites/enemies/Palanking/sprPalankingBurp.png",      5, 40, 24);
            global.sprPalankingFoam = sprite_add("sprites/enemies/Palanking/sprPalankingFoam.png",      1, 40, 24);
            global.mskPalanking     = sprite_add("sprites/enemies/Palanking/mskPalanking.png",          1, 40, 24);
            global.sprGroundSlash   = sprite_add("sprites/enemies/projectiles/sprGroundSlash.png",      3,  0, 21);
            global.sprPalankingSlash = sprite_add("sprites/enemies/projectiles/sprPalankingSlash.png",      5, 36, 36);
            if(fork()){
                wait 30;
                sprite_collision_mask(global.mskPalanking, false, 0, 0, 0, 0, 0, 0, 0);
                exit;
            }

             // Palm:
        	global.sprPalmIdle      = sprite_add("sprites/areas/Coast/Props/sprPalm.png",         1, 24, 40);
        	global.sprPalmHurt      = sprite_add("sprites/areas/Coast/Props/sprPalmHurt.png",     3, 24, 40);
        	global.sprPalmDead      = sprite_add("sprites/areas/Coast/Props/sprPalmDead.png",     4, 24, 40);
        	global.sprPalmFortIdle  = sprite_add("sprites/areas/Coast/Props/sprPalmFortIdle.png", 1, 32, 56);
        	global.sprPalmFortHurt  = sprite_add("sprites/areas/Coast/Props/sprPalmFortHurt.png", 3, 32, 56);

             // Pelican:
            global.sprPelicanIdle   = sprite_add("sprites/enemies/Pelican/sprPelicanIdle.png",   6, 24, 24);
            global.sprPelicanWalk   = sprite_add("sprites/enemies/Pelican/sprPelicanWalk.png",   6, 24, 24);
            global.sprPelicanHurt   = sprite_add("sprites/enemies/Pelican/sprPelicanHurt.png",   3, 24, 24);
            global.sprPelicanDead   = sprite_add("sprites/enemies/Pelican/sprPelicanDead.png",   6, 24, 24);
            global.sprPelicanHammer = sprite_add("sprites/enemies/Pelican/sprPelicanHammer.png", 1,  6,  8);

             // Seal:
            global.sprSealIdle[0] = sprite_add("sprites/enemies/Seal/sprSealIdle.png",      6, 12, 12);
            global.sprSealWalk[0] = sprite_add("sprites/enemies/Seal/sprSealWalk.png",      6, 12, 12);
            global.sprSealHurt[0] = sprite_add("sprites/enemies/Seal/sprSealHurt.png",      3, 12, 12);
            global.sprSealDead[0] = sprite_add("sprites/enemies/Seal/sprSealDead.png",      6, 12, 12);
            global.sprSealSpwn[0] = sprite_add("sprites/enemies/Seal/sprSealSpwn.png",      6, 12, 12);
            global.sprSealWeap[0] = mskNone;
            global.sprSealIdle[1] = sprite_add("sprites/enemies/Seal/sprSealIdle1.png",     6, 12, 12);
            global.sprSealWalk[1] = sprite_add("sprites/enemies/Seal/sprSealWalk1.png",     6, 12, 12);
            global.sprSealHurt[1] = sprite_add("sprites/enemies/Seal/sprSealHurt1.png",     3, 12, 12);
            global.sprSealDead[1] = sprite_add("sprites/enemies/Seal/sprSealDead1.png",     6, 12, 12);
            global.sprSealSpwn[1] = sprite_add("sprites/enemies/Seal/sprSealSpwn1.png",     6, 12, 12);
            global.sprSealWeap[1] = sprite_add("sprites/enemies/Seal/sprHookPole.png",      1, 18,  2);
            global.sprSealIdle[2] = sprite_add("sprites/enemies/Seal/sprSealIdle2.png",     6, 12, 12);
            global.sprSealWalk[2] = sprite_add("sprites/enemies/Seal/sprSealWalk2.png",     6, 12, 12);
            global.sprSealHurt[2] = sprite_add("sprites/enemies/Seal/sprSealHurt2.png",     3, 12, 12);
            global.sprSealDead[2] = sprite_add("sprites/enemies/Seal/sprSealDead2.png",     6, 12, 12);
            global.sprSealSpwn[2] = sprite_add("sprites/enemies/Seal/sprSealSpwn2.png",     6, 12, 12);
            global.sprSealWeap[2] = sprite_add("sprites/enemies/Seal/sprSabre.png",         1, -2,  1);
            global.sprSealIdle[3] = sprite_add("sprites/enemies/Seal/sprSealIdle3.png",     6, 12, 12);
            global.sprSealWalk[3] = sprite_add("sprites/enemies/Seal/sprSealWalk3.png",     6, 12, 12);
            global.sprSealHurt[3] = sprite_add("sprites/enemies/Seal/sprSealHurt3.png",     3, 12, 12);
            global.sprSealDead[3] = sprite_add("sprites/enemies/Seal/sprSealDead3.png",     6, 12, 12);
            global.sprSealSpwn[3] = sprite_add("sprites/enemies/Seal/sprSealSpwn3.png",     6, 12, 12);
            global.sprSealWeap[3] = sprite_add("sprites/enemies/Seal/sprBlunderbuss.png",   1,  7,  1);
            global.sprClamShield  = sprite_add("sprites/enemies/Seal/sprClamShield.png",   14,  7,  1);

             // Seal (Heavy):
            global.sprSealHeavySpwn = sprite_add("sprites/enemies/SealHeavy/sprHeavySealSpwn.png",   6, 16, 17);
            global.sprSealHeavyIdle = sprite_add("sprites/enemies/SealHeavy/sprHeavySealIdle.png",  10, 16, 17);
            global.sprSealHeavyWalk = sprite_add("sprites/enemies/SealHeavy/sprHeavySealWalk.png",   8, 16, 17);
            global.sprSealHeavyHurt = sprite_add("sprites/enemies/SealHeavy/sprHeavySealHurt.png",   3, 16, 17);
            global.sprSealHeavyDead = sprite_add("sprites/enemies/SealHeavy/sprHeavySealDead.png",   7, 16, 17);
            global.sprSealHeavyTell = sprite_add("sprites/enemies/SealHeavy/sprHeavySealTell.png",   2, 16, 17);
            global.sprSealAnchor    = sprite_add("sprites/enemies/SealHeavy/sprHeavySealAnchor.png", 1,  0, 12);

             // Sea/Seal Mine:
            global.sprSealMine      = sprite_add("sprites/areas/Coast/props/sprSeaMine.png",      1, 12, 12);
            global.sprSealMineHurt  = sprite_add("sprites/areas/Coast/props/sprSeaMineHurt.png",  3, 12, 12);

             // Traffic Crab:
            global.sprCrabIdle = sprite_add("sprites/enemies/Crab/sprTrafficCrabIdle.png", 5, 24, 24);
            global.sprCrabWalk = sprite_add("sprites/enemies/Crab/sprTrafficCrabWalk.png", 6, 24, 24);
            global.sprCrabHurt = sprite_add("sprites/enemies/Crab/sprTrafficCrabHurt.png", 3, 24, 24);
            global.sprCrabDead = sprite_add("sprites/enemies/Crab/sprTrafficCrabDead.png", 9, 24, 24);
            global.sprCrabFire = sprite_add("sprites/enemies/Crab/sprTrafficCrabFire.png", 2, 24, 24);

             // Strange Creature:
        	global.sprCreatureIdle = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAACMAAAACgCAMAAADXNXIqAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAAAU9IAxsQWkrGXVgQ/w4ALiVetS/rwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKuM2GgAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGXRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4wLjE3M26fYwAADJxJREFUeF7t24ty20YSQFFlLcv//8VZYNCkAGLwIAYU0c45VSvSeM3dSRWqI1c+/gUASMYAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0WgaYj4k4eCERFuLghURYiIMXEmEhDl5IhIU4eCERFuLglUTZII5dSZQN4tiVRNkgjl1JlA3i2JVE2SCOXUmUDeLYlUTZII5dSZQN4tjZDj03kv6ZiINxyVtFSoSFOBiXvFWkRFiIg3HJW0VKhIU4GJe8VaREWIiDcclbRUqEhTgYl7xXtETZII7FFe8VLVE2iGNxxXtFS5QN4lhc8V7REmWDOBZXvFe0RNkgjsUV7xUtUTaIY3HFe0VLlA3iWFzxVpHyI33PPrBERFLVCxqfoa+NvjZX79sM1LdOXxt9bS7et5V3et9TT1tu+9+3N+6hvjb62ly9bzkw2nqX7JsE6luir42+Jst5o76T3y/7H7W+eeMdLI1x18/R10Zfm6v3LQcOSaVscMG+hw3UN6evjb4mi3mlbJp3Yt/eBy3WdWWxhRM/vYX62uhrc/2+pcC+bx54pb7aBuqb0tdGX5vFvC6tknde367HLO9eSasF/ugW6mujr83V+7rAyJkpJdXAa/Qtb+A/P5enr5G+Nrn7qnln9e14ykpdPe3mh7ZQXxt9ba7etxoYKVVX7/upCUtfG31t9K3YfsZKXWdhvAo/sYP62uhrc/m+1cCubznwRyaY9b7VDdTX0ddGX5v1vi5vue+M99/WIza2L0TP3Mt3UF8bfW3+jr7FQH36muhr83f0Rc1ce9/GE/ZtXy+KHr14B/W10dfm7+lbCNS3VwQ90LdXBD3Qt1cEPbhMX/Q8au5bf8BiXyw/8pYd1NdGX5u0ffOYq/dN/0PMb/qqYvURfXP62jzRV0vutfat3r/QF0s/qh9/5d/D6Wujr03SvoXAhcP6ZmLlB/oe6WvzV/UtHW7sW7u93hcL7/a6N7S+Nvra5Ox7NvDH+54M1PcoFt5J36NYeCd9D2LdvRr7Vu6u98Wy+/3zqh3U10Zfm5x9Twdeve9lb2h9bfS1ydkXiz6hrW/55iN9tdPdsZfsoL42+trk7NsIrOhuuXRft4H6vsWiT9A3Fos+Qd9IrPmE7p6WvsV7j+3f/Hy55QU7qK+NvjZJ+zYCK6f1TQyLLtF3o69N0r5hzUXn9y3deqyvEjjcc/oO6mujr03Svq3A+QXX6qttYP9DXyhLrtA30Ndmoa+suGJ+xXDkeN/CnYf3byHw7L+H09dGX5usfduB8XmXo+/sN7S+NvraZO0ra61Z6Dv+fqnfeHz/FgJPfgPqa6OvTdq+7cD4vNM3URZboa+nr03avrLWmtP76vctB240zk+3Blbpa6OvTdq+7cD4vLv1nRrY0Pd4Wt+Evj30tVns28pb7juaV71vdf9WC+dnb0fO3EB9bfS1ydvXBw7rLZid1jehbwd9bfL2dcv9cF/1tpXADfMrbjf90AZu0NfT1yZv36HA4UNfr6y1Ql9HX5u8fWWpFfNLbkeO9tVuW9m/frG1ysr/heGm7uO0HdTXRl+bzH0bgcMFE3HoGn1dRny5u92kr+iXKuvW6dPXaq2vX6ksWzdcMXG762Bf7a6NDSw/FszPdUc+fv3+3T3zp/4Blx8L5ue6I/pG9G1K3VcCY+25cn6iO3Khvnlgd0DfmL4t+tqs9lUSRubnuiNNfZW71vdv9a+5hguGz6+vP4Ovr4/fv399bAZ+FPGHFfrq9OkrtgOHmrnh/PDl6xZY+ro3zObSewOP95XA2+eor7wB9Q30bdBXd1Jfp7RU3E/2n5HX9zW8/yp3HeyLc4Nb3OCrvvZYd7pc+rr9i3MDfWuiaCrODfStiaKpODd4b181ME6FSWDp23jB7A/UV6NvQt+aSJqIU+GtfVE0FecGk7yh7+D7r3LXjg28+/j4VfTrx6HONK9XEuP5FVH352vH/umb06fv7pm+euDTfU8FPtk3BOq70zen75p9UTfNe75vJa9y1/7Aj/53y70+MI5V6jpfX5+fi423vO6qHfun75E+fSP7+yaBcej+m+eJW98ZgU/0lb8eL777qhu4s+/8F7S+GX2P/qt91fff8333vNrrZX7Hvr6y2j3wOy+Wmvi6qUZ+715/4Vn7VxbSV6EvFgp/W9+hwF+3m+pvl/C5HfjqvtoGRl1H311ZSF+FvlgovKSvrHPP+37/1V4wEdfnVfomefO+efC+/et1S5UB8Ptf3+p18W3QZY4bPz6+T3997tlAffoG+mqe6iuB/W94hyM7+iIwFnsIPLfvtoHfffXXc3wJfcRCX3dO3yN9i/RV7O+LvKfff+P3yziv+v6bBz+xgQ/6paY9XUyludPvYb/0ePf+dBef+w/4gb6evo6+irLWLDC+PYi+aWD3hnllX3k9T/u6JePLA30VZQ19h5U19B3VL9XljVbsp5X4OrX//TcPPhrYl0x3b/H1POgjHy9/4QbqG+gL+ibmfRuBfd8s8OV9D4ErfeUlPTmvT5++u3f3Pf/+q/TNgw8Fdq/WzjRoo6+/YHK+63vZBuq703ej767WdyTwtX3deuMFn+3rr9f3Td9u+u4a+qY9z+bV33/z4COBt7xJX/eH9cDZ9r1sA/V903ej76b09YGxVnEk8Mp9Lxyw9H3Td6cvRF9fdHckr9I3D34+cNi7XixV9H9YDXw42fd1yZs7qC/oC/rGzuo7FHjlvu4h+kb07aRv7Ky+I3mVvnnv04Gfn7dfEcVSRfnDauBU6esec/4G6pvQV6Vv2ncs8MJ9w4Cl70bfTvomTuo7lFfpm/c+G9jlnbF/pe8VG6hvSl+VvoeYg4Gb/wr3rr6YAPUFffvomzqp71jevG+e+2xg54T9i74XbGBH34i+Gn2PLU8GvmyA6XSPnQce7NucAPXV6YuFgr7dhrxpy7G8+ftlnns4MFYa2x9Y4rq39M+9oHv6dtE38l/qeyKwa/vs+173AoyFJvb39TvYbWD3mI1AfXX6KvTtsdi3P6+8Xsr75aFvXvt8YP/Y1v0rfaXw/A3UN6avRl9jYJ928b4SqG9M3w76xs7s25831FX65rUHAsujY6WpvYXd9pWHdF6wgcNza/TtoG/sb+2rpuzt6wuHp3R3rAee27c78HsH9X3Tt4O+sXP74nPTbYDpTPPmsUcDY6WpvYHlCeFFGxgrTenbQd/Y39rXFjgq1Deib5u+sf9U39684QmDaV8lNpbdbwiMpaaeCixf+h/rOxir7qdvIlbdT99ErLpfjr62wFJYProfV+0rgd3/9N3p26ZvIlbdb6Vvb979AeXnuK/aGgvvtRa4s/B+Xflc30B9c/r0fYt194q+emB8brndXT4v2He/UN+Evm36HsS6e0Xf8Pyp+tG5+3Xly7hvoTWW3ufzM+4aK833L+Vb1cbpBbHyPvpmYuV99M3Eyvuk7CsL3z7ja83G6QWx8j5NfXE+/rBXrLyPvplYeR99M7HyPin77quWLyvrb5xeG7Zi/WVx3btExbK47l2iYllc9y5RsSyue5eoWBbXvUtULIvr3iUqlsV17xIVy+K6d4mKZXHdu0TFsrjuXaJiWVz3LlGxLK57l6hYFte9S1Qsi+teauu3RQAAl2OAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAZP799/9U6bLI9L+tDwAAAABJRU5ErkJggg==",
        	14, 80, 80);
        	global.sprCreatureHurt = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAeAAAACgCAMAAADjJU9/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAAAU9IAxsQXVgQ7iVetS/r////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHiDNaAAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGXRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4wLjE3M26fYwAABYhJREFUeF7tmomS2joURCF2+P8/nmhpBttos9GWpk/VC4MsXXf1GZNJXm4/ghoJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYnI8EP7ZgbSZuW7A2E0jmwVptrs2F0xDYMRZ0dt+CNewYC7IgmQdr2FGN0wPhMQV2jsG1hM5CNOjwFL3znZsGg3mwvzfx7v68GOh4QL4To+CuEBzqSLQ9X5v7FZgOcagjY/KVDoK2M+BkH5LPxu4B8fRWPCxf2RgoOwkOdyDanq8uUKCtEIc7MDBfyRT4ugAGNCZRX6i5X3o9xEPz5WfA1TUwoyWp+gzhx8PT5SEenC83AqIugzHNyNS3AaXtaW54eL7MBGj6AAxqRLQ+FLRhiOHx+dIDIOkjMKoJkf5QzoEBhifIlzwPRR+CYQ041V+MhoZnyJc6DkGfg3m1CfeHXopp9yfiKfIlDsNODTCxLnX6sz/FtjE8R774WbipA2bW5NLnX+CyXWpheJJ80aMwUwtMrcel/kINupX6hmfJFzsJL/XA3FpE+jtfII7UNjxNvshBWKkJJtch1t/lAiv/pdY8+cLn4KQumF2DaH/Jv/mzvF1+FljV8ET5JBgLkwu+nC94DEYqg+EViPeXbs/wvgMrNQXPlK+j4HqGEwXaNlIthgr0hyoanilf6BR8VAfjPybVny3jvaQXbsMO++/cHg+zXk3wVPn4BKf/D6u9vsMsmP4ej1svwZ3zzSS4bFe2QAPK2YFL/qJ9Xde/jnV1980XeHPgTYKp8gVOuXEtwPww2FMgON/fFvv5Zr7/DVjwoDyPazBToBng9uYFz5VvEsHYYcFKnDMF+voMuwZ37TlWex3zQ6C9v2tlwe3z9RRswT324JoHa3HKCzSlYKgpEGuh+kwx67LYDsMlPuurLbhHvt6CHbgRwCLAYoKyAl0dmwKxfEcTW9Zfgi2+6jM7834ny/ceGHdsDG72fjssxynrz/Eq8HkIRWx5/izzxPS47fB221wvETxZvlGCLcG7uQwpThSIkfYPkQ7fwa6wdcEXB0yHrpptfWZzXcGI1zTfSMFBkCJOeYFuHr6+321Tpr1Dfbu3B2yJu+tLXcFd8n2J4MVWZ34P2/VnfktL9ffWr93fSHC7fN8hGPUd+jDv0gUe+l2aCW6YbzrBWcPlBdoG7YvvzoImPPZdssDDRTPENJo1PFk+asGeZXl+BKIJj3uXLPCA6c+MqSnY0zbffIJzhs8WaOoL9Xe6QPuAlDzCk+XjF2yw39kfF+j6CzwiRybLN6HgjOErBQb685wr0P+YmzE8Wb5vEBx8QDzlBbofYWyD9QU3zTej4LThCwW6/sIFFjdoCvRjcoYny/flgssfET/D0lPw5/kCYdHySJAkDGopp16B9tX8lzaMu5bTNF8wK2oeB3LEQDGl/H52BSgvcPOaFjxXvkhWFF0KTu14rrsNCWeZy2FQTRnLglM7bKXPV3wZJHM5DO5cRtN8qW9GX30C7BsF+omDfaNAijjY15Tcp434z5FgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJpubn5x8Du/CP6ZKb1gAAAABJRU5ErkJggg==",
        	3, 80, 80);
        	global.sprCreatureBott = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAKAAAACgCAYAAACLz2ctAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwgAADsIBFShKgAAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xNzNun2MAAAKjSURBVHhe7dJBbiNXFATB2fpKvv+95JUB4yMtUU1NacSORWwSJFHNfr/e3t7g22SElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZ/1S//vr77f+cn+VnyPjV6mD+NOfmK+p3f6LzuX6njM+qh+I1nO/6WRmvqsG8rvP9X5HxihrIPZy38BkZr6hh3Md5D4/KeEWN4j7Oe3hUxitqFPdy3sQjMl5Rg7iX8yYekfGKGsT9nHfxkYxX1Bju57yLj2S8osZwT+dtvCfjFTWEezpv4z0Zr6gh3NN5G+/JeEUN4Z7O23hPxqtqDPdz3sV7Ml5VY7iX8yY+kvGqGsR9nPfwiIzPqGG8vvMOHpXxGTWO13bewGdkfFaN5HWd7/8zMn6FGsrrOd/7Z2X8SjWa13G+78/K+LvUA/Bzne/3iozfoR6Qr3f+76W+96/zs8/K+NPUH/Vf5+e/Q+16xPk7ryYjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCCsZYSUjrGSElYywkhFWMsJKRljJCBtvv/4Bi0CUPGa5758AAAAASUVORK5CYII=",
        	1, 80, 80);
        	global.sprCreatureFoam = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAKAAAACgCAYAAACLz2ctAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwAAADsABataJCQAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xNzNun2MAAAIVSURBVHhe7dLBTsIAFERR/v+nMe6voBUGtGeSs7npok3f5Xq9wstkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGd/YrdXzvLmMT/AXVu/9U/9l9W1PkfEB7P+u/vdhGX/BzrW6gR/JeJCdd3UP35LxIDv36ibuyniQnXt1E3dlPMis7uKmjAeZ1V3clPEgs8/VbXwp4y/ZeVf3cFPGB/nLq+/hCTI+0Tus3osXyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhI3r5QPGwQeqRTAO1AAAAABJRU5ErkJggg==",
        	1, 80, 80);
    	//#endregion

        //#region OASIS
             // Hammerhead:
            global.sprHammerheadIdle = sprite_add("sprites/enemies/Hammer/sprHammerheadIdle.png",  6, 24, 24);
            global.sprHammerheadHurt = sprite_add("sprites/enemies/Hammer/sprHammerheadHurt.png",  3, 24, 24);
            global.sprHammerheadDead = sprite_add("sprites/enemies/Hammer/sprHammerheadDead.png", 10, 24, 24);
            global.sprHammerheadChrg = sprite_add("sprites/enemies/Hammer/sprHammerheadDash.png",  2, 24, 24);

             // Puffer:
            global.sprPufferIdle       = sprite_add("sprites/enemies/Puffer/sprPufferIdle.png",     6, 15, 16);
            global.sprPufferHurt       = sprite_add("sprites/enemies/Puffer/sprPufferHurt.png",     3, 15, 16);
            global.sprPufferDead       = sprite_add("sprites/enemies/Puffer/sprPufferDead.png",    11, 15, 16);
            global.sprPufferChrg       = sprite_add("sprites/enemies/Puffer/sprPufferChrg.png",     9, 15, 16);
            global.sprPufferFire[0, 0] = sprite_add("sprites/enemies/Puffer/sprPufferBlow0.png",    2, 15, 16);
            global.sprPufferFire[0, 1] = sprite_add("sprites/enemies/Puffer/sprPufferBlowB0.png",   2, 15, 16);
            global.sprPufferFire[1, 0] = sprite_add("sprites/enemies/Puffer/sprPufferBlow1.png",    2, 15, 16);
            global.sprPufferFire[1, 1] = sprite_add("sprites/enemies/Puffer/sprPufferBlowB1.png",   2, 15, 16);
            global.sprPufferFire[2, 0] = sprite_add("sprites/enemies/Puffer/sprPufferBlow2.png",    2, 15, 16);
            global.sprPufferFire[2, 1] = sprite_add("sprites/enemies/Puffer/sprPufferBlowB2.png",   2, 15, 16);
            global.sprPufferFire[3, 0] = sprite_add("sprites/enemies/Puffer/sprPufferBlow3.png",    2, 15, 16);
            global.sprPufferFire[3, 1] = sprite_add("sprites/enemies/Puffer/sprPufferBlowB3.png",   2, 15, 16);

             // Ground Crack Effect:
            global.sprCrack = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAEAAAAAgCAYAAACinX6EAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAZdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAuMTczbp9jAAAB6klEQVRoQ+WTUW7DMAxDc4j97H+n2xl292wyykBmaMuOndZYPx4QS65EMum27/tbI4sr8vHzvXu4z7TcMWTxVdQMci0yGPWBLL4aJX77+sxqdqdkEr1S3yOLK2DizXQvbDwKQRZXozeMqQFEA56FMhph2qcEYMPwjPozYWO91HTLoiIadBd4AYk/uVVwr4DSnx0ibAjXFH7RaGiHATZbAvcFwwHgbXCN8X2+z/B95jDARiPwO+I0nwsRfogS3xuAUQrB6kk4m+vhYRzwjuzQQjTQaLnDmFnAv5fGenHzsMf2SjEMLuOZh6EHeBHgex7f9/Olmas8ZmJP2uUPNZQJLxR9g5e04Gf7udLICKTteGihFgDj77XiAzxgA6OQtkxARCkAX4cBnK+AudLAKKQtW9yCf0McCOAlvRw7WPwMRgMANZOlYHo5iZ8Aa8sW9lAKwBasHMBpBxdawCfKRmcZB2kPGRiFd2SHVtL/02FCZ5sHbGCU03wutADjvnZXAICNXOU0lwuK9CkGb/zuAJIGMnMFnpsdavAbN7xpFcpM1BenDEb4GUZ2qFEK4G7jhtoN2CBgTSWd2aHG3SYZ22fGjdruyDjD/ay5El5oawCReWP5AEwg8DU8M7VeC7K4CioM5l8H8Axk8X3Yt1/rleuAjYarfgAAAABJRU5ErkJggg==",
            2, 16, 16);
        //#endregion
        
        //#region TRENCH
             // Jellyfish:
                  // Blue:
                global.sprJellyfishBlueIdle = sprite_add("sprites/enemies/Jellyfish/sprJellyfishBlueIdle.png",10,32,48);
                global.sprJellyfishBlueHurt = sprite_add("sprites/enemies/Jellyfish/sprJellyfishBlueHurt.png",3,32,48);
                global.sprJellyfishBlueDead = sprite_add("sprites/enemies/Jellyfish/sprJellyfishBlueDead.png",10,32,48);
                  // Purple:
                global.sprJellyfishPurpleIdle = sprite_add("sprites/enemies/Jellyfish/sprJellyfishPurpleIdle.png",10,32,48);
                global.sprJellyfishPurpleHurt = sprite_add("sprites/enemies/Jellyfish/sprJellyfishPurpleHurt.png",3,32,48);
                global.sprJellyfishPurpleDead = sprite_add("sprites/enemies/Jellyfish/sprJellyfishPurpleDead.png",10,32,48);
                  // Green:
                global.sprJellyfishGreenIdle = sprite_add("sprites/enemies/Jellyfish/sprJellyfishGreenIdle.png",10,32,48);
                global.sprJellyfishGreenHurt = sprite_add("sprites/enemies/Jellyfish/sprJellyfishGreenHurt.png",3,32,48);
                global.sprJellyfishGreenDead = sprite_add("sprites/enemies/Jellyfish/sprJellyfishGreenDead.png",10,32,48);
             // Kelp:
            global.sprKelpIdle = sprite_add("sprites/areas/Trench/Props/sprKelpIdle.png",6,16,22);
            global.sprKelpHurt = sprite_add("sprites/areas/Trench/Props/sprKelpHurt.png",3,16,22);
            global.sprKelpDead = sprite_add("sprites/areas/Trench/Props/sprKelpDead.png",8,16,22);
             // Vent
            global.sprVentIdle = sprite_add("sprites/areas/Trench/Props/sprVentIdle.png",1,12,14);
            global.sprVentHurt = sprite_add("sprites/areas/Trench/Props/sprVentHurt.png",3,12,14);
            global.sprVentDead = sprite_add("sprites/areas/Trench/Props/sprVentDead.png",6,12,14);
             // Yeti Crab:
            global.sprYetiCrabIdle = sprite_add("sprites/enemies/YetiCrab/sprYetiCrab.png",1,12,12);
            global.sprKingCrabIdle = sprite_add("sprites/enemies/YetiCrab/sprKingCrab.png",1,12,12);
        //#endregion

        //#region SEWERS
             // Cat:
            global.sprCatIdle = sprite_add("sprites/enemies/Cat/sprCatIdle.png", 4, 12, 12);
            global.sprCatWalk = sprite_add("sprites/enemies/Cat/sprCatWalk.png", 6, 12, 12);
            global.sprCatHurt = sprite_add("sprites/enemies/Cat/sprCatHurt.png", 3, 12, 12);
            global.sprCatDead = sprite_add("sprites/enemies/Cat/sprCatDead.png", 6, 12, 12);
            global.sprAcidPuff = sprite_add("sprites/enemies/Cat/sprAcidPuff.png", 4, 16, 16);
        //#endregion

        //#region CRYSTAL CAVES
        	 // Mortar:
        	global.sprMortarIdle = sprite_add("sprites/enemies/Mortar/sprMortarIdle.png", 4, 22, 24);
        	global.sprMortarWalk = sprite_add("sprites/enemies/Mortar/sprMortarWalk.png", 8, 22, 24);
        	global.sprMortarFire = sprite_add("sprites/enemies/Mortar/sprMortarFire.png", 16, 22, 24);
        	global.sprMortarHurt = sprite_add("sprites/enemies/Mortar/sprMortarHurt.png", 3, 22, 24);
        	global.sprMortarDead = sprite_add("sprites/enemies/Mortar/sprMortarDead.png", 14, 22, 24);
        	global.sprMortarPlasma = sprite_add("sprites/enemies/Mortar/sprMortarPlasma.png", 1, 4, 4);
        	global.sprMortarImpact = sprite_add("sprites/enemies/Mortar/sprMortarImpact.png", 7, 16, 16);
        	global.sprMortarTrail = sprite_add("sprites/enemies/Mortar/sprMortarTrail.png", 3, 4, 4);
        //#endregion
    //#endregion

    //#region SOUNDS
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
    //#endregion

    //#region MUSIC
        global.mus = {};
        with(global.mus){
            SealKing = sound_add("music/musSealKing.ogg");
        }
    //#endregion

     // Refresh Big Decals on Mod Load:
    with(instances_named(CustomObject, "BigDecal")){
        sprite_index = lq_defget(global.sprBigTopDecal, string(GameCont.area), mskNone);
    }

     // Harpoon Ropes:
    global.poonRope = [];

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)

#macro snd global.snd
#macro mus global.mus

#define obj_create(_x, _y, obj_name)
    var o = noone,
        _name = string_upper(string(obj_name));

    switch(obj_name){
    	case "BigDecal":
    	    var a = string(GameCont.area);
    	    if(lq_exists(global.sprBigTopDecal, a)){
        	    o = instance_create(_x, _y, CustomObject);
        		with(o){
        		     // Visual:
        		    sprite_index = lq_get(global.sprBigTopDecal, a);
        			image_xscale = choose(-1, 1);
        			image_speed = 0;
        			depth = -8;

            		mask_index = global.mskBigTopDecal;

        		    if(place_meeting(x, y, TopPot)) instance_destroy();
                	else{
                         // TopSmalls:
                		var _off = 16,
                		    s = _off * 3;

                		for(var _ox = -s; _ox <= s; _ox += _off){
                		    for(var _oy = -s; _oy <= s; _oy += _off){
                		        if(random(2) < 1) instance_create(x + _ox, y + _oy, TopSmall);
                		    }
                		}
        		    }
        		}
    	    }
    	    break;

        case "Bone":
            o = instance_create(_x, _y, CustomProjectile);
            with(o){
                 // Visual:
                sprite_index = global.sprBone;
                hitid = [sprite_index, _name];

                 // Vars:
                mask_index = mskFlakBullet;
                friction = 1;
                damage = 50;
                force = 1;
                typ = 1;
                creator = noone;
                rotation = 0;
                rotspeed = (1 / 3) * choose(-1, 1);
                broken = false;

                 // Annoying Fix:
                if(place_meeting(x, y, PortalShock)) Bone_destroy();
            }
            break;

        case "BoneSpawner":
            o = instance_create(_x, _y, CustomObject);
            with(o) creator = noone;
            break;

    	case "BubbleBomb":
    	    o = instance_create(_x, _y, CustomProjectile);
    	    with(o){
    	         // Visual:
    	        sprite_index = global.sprBubbleBomb;
    	        image_speed = 0.5;
    	        depth = -2;

    	         // Vars:
    	        mask_index = mskSuperFlakBullet;
    	        z = 0;
    	        zspeed = -0.5;
    	        zfric = -0.02;
    	        friction = 0.4;
    	        damage = 0;
    	        force = 2;
    	        typ = 1;
    	        my_projectile = noone;
    	    }
    	    break;

        case "BubbleExplosion":
            o = instance_create(_x, _y, PopoExplosion);
            with(o){
                sprite_index = global.sprBubbleExplode;
                mask_index = mskExplosion;
                hitid = [sprite_index, "BUBBLE EXPLO"];
                damage = 3;
                force = 1;
                alarm0 = -1; // No scorchmark
            }

             // Effects:
            repeat(10) instance_create(_x, _y, Bubble);
            sound_play_pitch(sndExplosionS, 2);
            sound_play_pitch(sndOasisExplosion, 1 + random(1));
             // Crown of Explosions:
            if GameCont.crown == 2
                if fork(){
                    wait(0);
                    repeat(choose(2,3))
                        with obj_create(_x,_y,"SmallBubbleExplosion") if instance_exists(o)
                            team = o.team;
                    exit;
                }
            break;
            
        case "SmallBubbleExplosion":
            o = instance_create(_x, _y, SmallExplosion);
            with(o){
                sprite_index = global.sprBubbleExplode;
                mask_index = mskExplosion;
                image_xscale = 0.5;
                image_yscale = 0.5;
                hitid = [sprite_index,"BUBBLE EXPLO"];
                damage = 3;
                force = 1;
                alarm0 = -1; // No scorchmark
            }
             // Effects:
            repeat(10) instance_create(_x, _y, Bubble);
            sound_play_pitch(sndOasisExplosionSmall, 1 + random(2));
            break;

        case "CoastBossBecome":
            o = instance_create(_x, _y, CustomProp);
            with(o){
                 // Visual:
                spr_idle = global.sprBigFishBecomeIdle;
                spr_hurt = global.sprBigFishBecomeHurt;
                spr_dead = sprBigSkullDead;
                spr_shadow = shd32;
                image_speed = 0;
                depth = -1;

                 // Sound:
                snd_hurt = sndHitRock;
                snd_dead = -1;

                 // Vars:
                mask_index = mskScorpion;
                maxhealth = 50 + (100 * GameCont.loops);
                my_health = maxhealth;
                size = 2;
                part = 0;
            }
            break;

    	case "CoastBoss":
    	    o = instance_create(_x, _y, CustomEnemy);
    	    with(o){
    	         // For Sani's bosshudredux:
    	        boss = 1;
    	        bossname = "BIG FISH";
    	        col = c_red;

    	        /// Visual:
    	            spr_spwn = global.sprBigFishSpwn;
        	        spr_idle = sprBigFishIdle;
        			spr_walk = sprBigFishWalk;
        			spr_hurt = sprBigFishHurt;
        			spr_dead = sprBigFishDead;
    			    spr_weap = mskNone;
    			    spr_shad = shd48;
        			spr_shadow = spr_shad;
        			hitid = [spr_idle, "BIG FISH"];
        			sprite_index = spr_spwn;
    			    depth = -2;
        			
        			 // Fire:
        			spr_chrg = sprBigFishFireStart;
        			spr_fire = sprBigFishFire;
        			spr_efir = sprBigFishFireEnd;

        			 // Swim:
        			spr_dive = global.sprBigFishLeap;
        			spr_rise = global.sprBigFishRise;

                 // Sound:
        		snd_hurt = sndOasisBossHurt;
        		snd_dead = sndOasisBossDead;

    			 // Vars:
        		mask_index = mskBigMaggot;
    			maxhealth = scrBossHP(150);
    			raddrop = 50;
    			size = 3;
    			meleedamage = 3;
    			walk = 0;
    			walkspd = 0.8;
    			maxspd = 3;
    			ammo = 4;
    			swim = 0;
    			gunangle = random(360);
    			direction = gunangle;
    			intro = false;
    			swim_ang_frnt = direction;
    			swim_ang_back = direction;
    			shot_wave = 0;
    			swimx = x;
    			swimy = y;

    			 // Alarms:
    			alarm0 = 60 + irandom(40);
    			alarm1 = -1;
    			alarm2 = -1;
    	    }
    	    break;

        case "CustomChest":
            o = instance_create(_x, _y, chestprop);
            with(o){
                 // Visual:
                sprite_index = sprAmmoChest;
                spr_open = sprAmmoChestOpen;

                 // Sound:
                snd_open = sndAmmoChest;

                on_step = script_bind_step(CustomChest_step, 0, id);
                on_open = ["", "", ""];
            }
            break;

        case "Harpoon":
            o = instance_create(_x, _y, CustomProjectile);
            with(o){
                sprite_index = global.sprHarpoon;
                image_speed = 0;
                mask_index = mskBolt;

                 // Vars:
				creator = noone;
				target = noone;
				rope = noone;
				pull_speed = 0;
				canmove = 1;
				damage = 3;
				force = 8;
				typ = 1;
				blink = 30;
            }
            break;

        case "NetNade":
            o = instance_create(_x, _y, CustomProjectile);
            with(o){
                sprite_index = global.sprNetNade;
                image_speed = 0.4;
                mask_index = sprGrenade;

                 // Vars:
                friction = 0.4;
                creator = noone;
                lasthit = noone;
                damage = 10;
                force = 4;
                typ = 1;
                
                alarm0 = 60;
            }
            break;

        //#region COAST
            case "BloomingCactus":
                o = instance_create(_x, _y, Cactus);
                with(o){
                    var s = irandom(array_length(global.sprBloomingCactusIdle) - 1);
                    spr_idle = global.sprBloomingCactusIdle[s];
                    spr_hurt = global.sprBloomingCactusHurt[s];
                    spr_dead = global.sprBloomingCactusDead[s];
                }
                break;
                
            case "BuriedCar":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = global.sprBuriedCarIdle;
                    spr_hurt = global.sprBuriedCarHurt;
                    spr_dead = mskNone;
                    spr_shadow = mskNone;

                     // Sound:
                    snd_hurt = sndHitMetal;

                     // Vars:
                    size = 2;
                    maxhealth = 20;
                    my_health = maxhealth;
                    my_floor = instance_nearest(x - 16, y - 16, Floor);
                }
                break;

            case "CoastBigDecal":
                return CoastDecal_create(_x, _y, 1);

            case "CoastDecal":
                return CoastDecal_create(_x, _y, 0);

            case "Creature":
        	    o = instance_create(_x, _y, CustomHitme);
        	    with(o){
        	         // visual
        	        spr_idle = global.sprCreatureIdle;
        	        spr_walk = spr_idle;
        	        spr_hurt = global.sprCreatureHurt;
        	        spr_bott = global.sprCreatureBott;
        	        spr_foam = global.sprCreatureFoam;
        	        sprite_index = spr_idle;
        	        image_speed = 0.4;
        	        depth = -3;
        	        
        	         // sounds
        	        snd_hurt = sndOasisBossHurt;
        	        
        	         // variables
        	        mask_index = spr_foam;
        	        friction = 0.4;
        	        maxhealth = 999999999;
        	        my_health = maxhealth;
        	        size = 8;
        	        team = 1;
        	        nowade = true;
        	        right = choose(-1, 1);
        	        walk = 0;
        			walkspd = 1.2;
        			maxspd = 2.6;
        			scared = false;

        			 // alarms
        			alarm0 = 30;
        	    }
        	    break;

        	case "Diver":
        	    o = instance_create(_x, _y, CustomEnemy);
        		with(o){
                     // Visual:
        			spr_idle = global.sprDiverIdle;
        			spr_walk = global.sprDiverWalk;
        			spr_hurt = global.sprDiverHurt;
        			spr_dead = global.sprDiverDead;
        			spr_weap = global.sprHarpoonGun;
        			spr_shadow = shd24;
        			hitid = [spr_idle, _name];
        			sprite_index = spr_idle;
        			depth = -2;

        			 // Sound:
        			snd_hurt = sndHitMetal;
        			snd_dead = sndAssassinDie;
    
        			 // Vars:
        			mask_index = mskBandit;
        			maxhealth = 12;
        			raddrop = 8;
        			size = 1;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 3;
        			gunangle = random(360);
        			direction = gunangle;
    
                     // Alarms:
        			alarm0 = 60 + irandom(30);
        		}
            	break;

            case "DiverHarpoon":
    			o = instance_create(_x, _y, CustomProjectile);
    			with(o){
                     // Visual:
    			    sprite_index = sprBolt;
    
                     // Vars:
    			    mask_index = mskBolt;
    				creator = noone;
    				damage = 4;
    				force = 8;
    				typ = 2;
    			}
        		break;

        	case "Gull": 
        	    o = instance_create(_x, _y, CustomEnemy);
        		with(o){
                     // Visual:
        			spr_idle = global.sprGullIdle;
        			spr_walk = global.sprGullWalk;
        			spr_hurt = global.sprGullHurt;
        			spr_dead = global.sprGullDead;
        			spr_weap = global.sprGullSword;
        			spr_shadow = shd24;
        			hitid = [spr_idle, _name];
        			sprite_index = spr_idle;
        			depth = -2;
    
                     // Sound:
                    snd_hurt = sndRavenHit;
                    snd_dead = sndAllyDead;
    
                     // Vars:
        			mask_index = mskBandit;
        			maxhealth = 8;
        			raddrop = 6;
        			size = 1;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 3.5;
        			gunangle = random(360);
        			direction = gunangle;
        			wepangle = choose(-140, 140);
    
                     // Alarms:
        			alarm0 = 60 + irandom(60);
        			alarm1 = -1;
        		}
            	break;

            case "Palanking":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // For Sani's bosshudredux:
        	        boss = 1;
        	        bossname = "PALANKING";
        	        col = c_red;

        	         // Visual:
    	            spr_bott = global.sprPalankingBott;
    	            spr_taun = global.sprPalankingTaunt;
    	            spr_call = global.sprPalankingCall;
        	        spr_idle = global.sprPalankingIdle;
        			spr_walk = global.sprPalankingWalk;
        			spr_hurt = global.sprPalankingHurt;
        			spr_dead = global.sprPalankingDead;
        			spr_burp = global.sprPalankingBurp;
        			spr_foam = global.sprPalankingFoam;
    			    spr_shadow_hold = shd64B; // Actually a good use for this shadow hell yeah
    			    spr_shadow = mskNone;
                    spr_shadow_y = 24;
        			hitid = [spr_idle, "SEAL KING"];
        			sprite_index = spr_idle;
    			    depth = -3;

                     // Sound:
            		snd_hurt = snd.PalankingHurt;
            		snd_dead = snd.PalankingDead;

        			 // Vars:
            		mask_index = mskNone;
            		mask_hold = global.mskPalanking;
        			maxhealth = scrBossHP(350);
        			raddrop = 80;
        			size = 4;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 2;
        			ammo = 0;
        			canmelee = 0;
        			meleedamage = 4;
        			ground_smash = 0;
        			gunangle = random(360);
        			direction = gunangle;
        			nowade = true;
        			active = false;
        			intro = false;
        			intro_pan = 0;
        			intro_pan_x = x;
        			intro_pan_y = y;
                    seal = [];
                    seal_x = [];
                    seal_y = [];
                    seal_max = 4 + (2 * GameCont.loops);
                    seal_spawn = 0;
                    seal_spawn_x = x;
                    seal_spawn_y = y;
                    tauntdelay = 40;
                    phase = -1;
        	        z = 0;
        	        zspeed = 0;
        	        zfric = 1;
        	        zgoal = 0;
                }
                break;

            case "Palm":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = global.sprPalmIdle;
                    spr_hurt = global.sprPalmHurt;
                    spr_dead = global.sprPalmDead;
                    spr_shadow = -1;
                    depth = -2 - (y / 20000);

                     // Sound:
                    snd_hurt = sndHitRock;
                    snd_dead = sndHitPlant;

                     // Vars:
                    mask_index = mskStreetLight;
                    maxhealth = 30;
                    my_health = maxhealth;
                    size = 1;
                    my_enemy = noone;
                    my_enemy_mask = mskNone;

                     // Fortify:
                    if(random(8) < 1){
                        my_enemy = obj_create(x, y, "Diver");
                        with(my_enemy) depth = -3;

                         // Visual:
                        spr_idle = global.sprPalmFortIdle;
                        spr_hurt = global.sprPalmFortHurt;

                         // Sound:
                        snd_dead = sndGeneratorBreak;

                         // Vars:
                        maxhealth = 40;
                        my_health = maxhealth;
                    }
                }
                break;

        	case "Pelican":
        	    o = instance_create(_x, _y, CustomEnemy);
        		with(o) {
                     // Visual:
        			spr_idle = global.sprPelicanIdle;
        			spr_walk = global.sprPelicanWalk;
        			spr_hurt = global.sprPelicanHurt;
        			spr_dead = global.sprPelicanDead;
        			spr_weap = global.sprPelicanHammer;
        			spr_shadow = shd32;
        			spr_shadow_y = 6;
        			hitid = [spr_idle, _name];
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
        			alarm0 = 30 + irandom(60);
        		}
            	break;

            case "Seal":
                 // Elite Spawn:
                if(random(16) < 1){
                    return obj_create(_x, _y, "SealHeavy");
                }

                 // Normal Spawn:
                else{
                    o = instance_create(_x, _y, CustomEnemy);
                    with(o){
                         // Visual:
                        spr_spwn = global.sprSealSpwn[0];
                        spr_idle = global.sprSealIdle[0];
                        spr_walk = global.sprSealWalk[0];
                        spr_hurt = global.sprSealHurt[0];
                        spr_dead = global.sprSealDead[0];
                        spr_weap = global.sprSealWeap[0];
                        spr_shadow = shd24;
                        hitid = [spr_idle, _name];
                        sprite_index = spr_spwn;
                        depth = -2;
    
                         // Sound:
                        var _male = irandom(1);
                        snd_hurt = (_male ? sndFireballerHurt : sndFreakHurt);
                        snd_dead = (_male ? sndFireballerDead : sndFreakDead);
    
                         // Vars:
                        mask_index = mskBandit;
                        maxhealth = 12;
                        raddrop = 1;
                        size = 1;
                        walk = 0;
                        walkspd = 0.8;
                        maxspd = 3.5;
                        type = 0;
                        hold = false;
                        hold_x = 0;
                        hold_y = 0;
                        creator = noone;
                        wepangle = 0;
                        gunangle = random(360);
                        direction = gunangle;
                        slide = 0;
                        scared = false;
                        shield = choose(true, false);
                        shield_ang = gunangle;
                        shield_draw = true;
                        surfClamShield = -1;
    
                        alarm0 = 20 + random(20);
                    }
                }
                break;

            case "SealAnchor":
                o = instance_create(_x, _y, CustomSlash);
                with(o){
                     // Visual:
                    sprite_index = global.sprSealAnchor;
                    image_speed = 0;
                    depth = -2;

                     // Vars:
                    mask_index = -1;
                    damage = 4;
                    force = 6;
                    team = 1;
                    last_x = [x, x];
                    last_y = [y, y];
                }
                break;

            case "SealHeavy":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
                    spr_spwn = global.sprSealHeavySpwn;
                    spr_idle = global.sprSealHeavyIdle;
                    spr_walk = global.sprSealHeavyWalk;
                    spr_hurt = global.sprSealHeavyHurt;
                    spr_dead = global.sprSealHeavyDead;
                    spr_chrg = global.sprSealHeavyTell;
                    spr_weap = global.sprSealAnchor;
                    spr_shadow = shd24;
                    hitid = [spr_idle, "HEAVY SEAL"];
                    sprite_index = spr_spwn;
                    depth = -2;

                     // Sound:
                    snd_hurt = sndJockHurt;
                    snd_dead = sndJockDead;

                     // Vars:
                    mask_index = mskBandit;
                    maxhealth = 40;
                    raddrop = 12;
                    size = 2;
                    walk = 0;
                    walkspd = 0.8;
                    maxspd = 3;
                    wepangle = 0;
                    gunangle = random(360);
                    direction = gunangle;
                    my_mine = noone;
                    my_mine_ang = gunangle;
                    my_mine_spin = 0;
                    target_x = x;
                    target_y = y;
                    anchor = noone;
                    anchor_swap = false;
                    anchor_spin = 0;
                    anchor_throw = 0;
                    anchor_retract = 0;

                    alarm0 = 40 + random(30);
                }
                break;

            case "SealMine":
                o = instance_create(_x, _y, CustomHitme);
                with(o){
                     // Visual:
                    spr_idle = global.sprSealMine;
                    spr_hurt = global.sprSealMineHurt;
                    spr_dead = sprScorchmark;
                    spr_shadow = shd24;
                    hitid = [spr_idle, "WATER MINE"];
                    depth = -5;
                    image_speed = 0.4;

                     // Sound:
                    snd_hurt = sndHitMetal;

                     // Vars:
                    mask_index = mskNone;
                    friction = 0;
                    maxhealth = 10;
                    my_health = maxhealth;
                    creator = noone;
                    canfly = true;
                    size = 2;
                    team = 0;
        	        z = 0;
        	        zspeed = 0;
        	        zfric = 1;
        	        right = choose(-1, 1);

        	        motion_add(random(360), 3);
                }
                break;

            case "TrafficCrab":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
                    spr_idle = global.sprCrabIdle;
                    spr_walk = global.sprCrabWalk;
                    spr_hurt = global.sprCrabHurt;
                    spr_dead = global.sprCrabDead;
                    spr_fire = global.sprCrabFire;
                    spr_shadow = shd48;
                    hitid = [spr_idle, "Traffic Crab"];
                    sprite_index = spr_idle;
                    mask_index = mskScorpion;
                    depth = -2;
    
                     // Sound:
                    snd_hurt = sndSpiderHurt;
                    snd_dead = sndPlantTBKill;
                    snd_mele = sndGoldScorpionMelee;
    
                     // Vars:
                    maxhealth = 20;
                    raddrop = 10;
                    size = 2;
                    meleedamage = 4;
                    walk = 0;
                    walkspd = 1;
                    maxspd = 2.5;
        			gunangle = random(360);
        			direction = gunangle;
        			sweep_spd = 10;
                    sweep_dir = right;
                    ammo = 0;
    
                     // Alarms:
                    alarm0 = 30 + random(90);
                }
                break;

            case "TrafficCrabVenom":
                o = instance_create(_x, _y, CustomProjectile);
                with(o){
                     // Visual:
                    sprite_index = sprScorpionBullet;
                    mask_index = mskEnemyBullet1;
                    depth = -3;
    
                     // Vars:
                    friction = 0.75;
                    damage = 2;
                    force = 4;
                    typ = 2;
                }
                break;
    	//#endregion

        //#region OASIS
            case "ClamChest":
                with(obj_create(_x, _y, "CustomChest")){
                     // Visual:
                    sprite_index = sprClamChest;
                    spr_open = sprClamChestOpen;

                     // Sound:
                    snd_open = sndOasisChest;

                    on_open = script_ref_create(ClamChest_open);
                }
                break;

            case "Hammerhead":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
        			spr_idle = global.sprHammerheadIdle;
        			spr_walk = global.sprHammerheadIdle;
        			spr_hurt = global.sprHammerheadHurt;
        			spr_dead = global.sprHammerheadDead;
        			spr_chrg = global.sprHammerheadChrg;
        			spr_shadow = shd48;
        			spr_shadow_y = 2;
        			hitid = [spr_idle, _name];
        			sprite_index = spr_idle;
        			depth = -2;
    
                     // Sound:
        			snd_hurt = sndOasisHurt;
        			snd_dead = sndOasisDeath;
        			snd_mele = sndBigBanditMeleeHit;
    
        			 // Vars:
        			mask_index = mskScorpion;
        			maxhealth = 40;
        			raddrop = 12;
        			size = 2;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 4;
        			meleedamage = 4;
        			direction = random(360);
        			rotate = 0;
        			charge = 0;
        			charge_dir = 0;
        			charge_wait = 0;
    
        			 // Alarms:
        			alarm0 = 40 + random(20);
        		}
                break;

            case "Puffer":
                o = instance_create(_x, _y, CustomEnemy);
                with(o){
                     // Visual:
        			spr_idle = global.sprPufferIdle;
        			spr_walk = global.sprPufferIdle;
        			spr_hurt = global.sprPufferHurt;
        			spr_dead = global.sprPufferDead;
        			spr_chrg = global.sprPufferChrg;
        			spr_fire = global.sprPufferFire[0, 0];
        			spr_shadow = shd16;
        			spr_shadow_y = 7;
        			hitid = [spr_idle, _name];
        			depth = -2;

                     // Sound:
                    snd_hurt = sndOasisHurt;
                    snd_dead = sndOasisDeath;

                     // Vars:
        			mask_index = mskFreak;
                    maxhealth = 10;
        			raddrop = 6;
        			size = 1;
        			walk = 0;
        			walkspd = 0.8;
        			maxspd = 3;
        			meleedamage = 2;
        			direction = random(360);
        			blow = 0;

                     // Alarms:
                    alarm0 = 40 + random(80);
                }
                break;

            case "Crack":
                o = instance_create(_x, _y, CustomObject);
                with(o){
                     // Visual:
                    sprite_index = global.sprCrack;
                    image_speed = 0;
                    mask_index = mskWepPickup;
                }
                break;
        //#endregion
        
        //#region TRENCH
            case "Jellyfish":
            o = instance_create(_x, _y, CustomEnemy);
                with(o) {
                     // Visual:
                    var c = irandom_range(1, 3);
                    if(c = 1) { // Blue:
                        spr_idle = global.sprJellyfishBlueIdle;
                        spr_walk = spr_idle;
                        spr_hurt = global.sprJellyfishBlueHurt;
                        spr_dead = global.sprJellyfishBlueDead;
                    } else if(c = 2) {
                        spr_idle = global.sprJellyfishPurpleIdle;
                        spr_walk = spr_idle;
                        spr_hurt = global.sprJellyfishPurpleHurt;
                        spr_dead = global.sprJellyfishPurpleDead;
                    } else if(c = 3) {
                        spr_idle = global.sprJellyfishGreenIdle;
                        spr_walk = spr_idle;
                        spr_hurt = global.sprJellyfishGreenHurt;
                        spr_dead = global.sprJellyfishGreenDead;
                    }
                    spr_weap = mskNone;
                    spr_shadow = shd24;
                    spr_shadow_y = 6;
                    hitid = [spr_idle, _name];
                    sprite_index = spr_idle;
                    mask_index = mskLaserCrystal;
                    depth = -4;
                    
                     // Sound:
                    snd_hurt = sndHitPlant;
                    snd_dead = sndEnemyDie;
                    
                     // Vars:
                    maxhealth = 52;
                    my_health = maxhealth;
                    raddrop = 16;
                    size = 2;
                    walk = 0;
                    walkspd = 1;
                    maxspd = 2;
                    meleedamage = 2;
                    direction = random(360);
                    
                     // Alarms:
                    alarm0 = 40 + irandom(20);
                    
                     // Always on the move:
                    walk = alarm0;
                }
                break;
            case "Kelp":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = global.sprKelpIdle;
                    spr_hurt = global.sprKelpHurt;
                    spr_dead = global.sprKelpDead;
                    sprite_index = spr_idle;
                    image_speed = 0.2;
                     
                     // Sounds:
                    snd_hurt = sndOasisHurt;
                    snd_dead = sndOasisDeath;
                    
                     // Vars:
                    depth = -2;
                }
                break;
            case "Vent":
                o = instance_create(_x, _y, CustomProp);
                with(o){
                     // Visual:
                    spr_idle = global.sprVentIdle;
                    spr_hurt = global.sprVentHurt;
                    spr_dead = global.sprVentDead;
                    spr_shadow = mskNone;
                    sprite_index = spr_idle;
                    
                     // Sounds
                    snd_hurt = sndOasisHurt;
                    snd_dead = sndOasisExplosionSmall;
                    
                     // Vars:
                    depth = -2;
                    maxhealth = 12;
                    my_health = maxhealth;
                }
                break;       
            case "YetiCrab":
            o = instance_create(_x, _y, CustomEnemy);
                with(o) {
                     // Visual:
                    spr_idle = global.sprYetiCrabIdle;
                    spr_walk = global.sprYetiCrabIdle;
                    spr_hurt = global.sprYetiCrabIdle;
                    spr_dead = global.sprYetiCrabIdle;
                    spr_weap = mskNone;
                    spr_shadow = shd24;
                    spr_shadow_y = 6;
                    hitid = [spr_idle, _name];
                    sprite_index = spr_idle;
                    mask_index = mskFreak;
                    depth = -2;
                    
                     // Sound:
                    snd_hurt = sndScorpionHit;
                    snd_dead = sndScorpionDie;
                    
                     // Vars:
                    maxhealth = 12;
                    my_health = maxhealth;
                    raddrop = 3;
                    size = 1;
                    walk = 0;
                    walkspd = 1;
                    maxspd = 4;
                    meleedamage = 2;
                    is_king = 0; // Decides leader
                    direction = random(360);
                    
                     // Alarms:
                    alarm0 = 20 + irandom(10);
                }
                break;
        //#endregion

        //#region SEWERS
        	case "Cat":
        	    o = instance_create(_x, _y, CustomEnemy);
        		with(o){
                     // Visual:
        			spr_idle = global.sprCatIdle;
        			spr_walk = global.sprCatWalk;
        			spr_hurt = global.sprCatHurt;
        			spr_dead = global.sprCatDead;
        			spr_weap = sprToxicThrower;
        			spr_shadow = shd24;
        			hitid = [spr_idle, _name];
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
        		}
        	break;
        	
        	case "CatBoss":
        	    o = instance_create(_x, _y, CustomEnemy);
        		with(o){
        		     // For Sani's bosshudredux:
        	        boss = 1;
        	        bossname = "BIG CAT";
        	        col = c_green;
        		    
                     // Visual:
        			spr_idle = global.sprCatIdle;
        			spr_walk = global.sprCatWalk;
        			spr_hurt = global.sprCatHurt;
        			spr_dead = global.sprCatDead;
        			spr_weap = sprToxicThrower;
        			spr_shadow = shd24;
        			hitid = [spr_idle, _name];
        			sprite_index = spr_idle;
        			mask_index = mskBandit;
        			depth = -2;
        			image_xscale *= 1.5;
        			image_yscale *= 1.5
    
                     // Sound:
        			snd_hurt = sndScorpionHit;
        			snd_dead = sndSalamanderDead;
    
        			 // Vars:
        			maxhealth = 80 * (1 + ((1/3) * GameCont.loops));
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
        		}
        	break;
        	
        	case "CatGrenade":
        	    o = instance_create(_x, _y, CustomProjectile);
        	    with(o){
                     // Visual:
        	        sprite_index = sprToxicGrenade;
        	        mask_index = mskNone;
    
        	         // Vars:
        	        z = 1;
        	        zspeed = 0;
        	        zfric = 0.8;
        	        damage = 0;
        	        force = 0;
        	        right = choose(-1, 1);
        	    }
        	break;
        //#endregion

        //#region CRYSTAL CAVES
        	case "Mortar":
        	    o = instance_create(_x, _y, CustomEnemy);
        	    with(o) {
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
        			hitid = [spr_idle, _name];
        			sprite_index = spr_idle;
        			depth = -4;
    
                     // Sound:
        			snd_hurt = sndLaserCrystalHit;
        			snd_dead = sndLaserCrystalDeath;
    
        			 // Vars:
        			maxhealth = 75;
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
        	    }
        	break;

        	case "MortarPlasma":
        	    o = instance_create(_x, _y, CustomProjectile);
        	    with(o){
                     // Visual:
        	        sprite_index = global.sprMortarPlasma;
        	        mask_index = mskNone;
    
        	         // Vars:
        	        z = 1;
        	        zspeed = 0;
        	        zfric = 0.8;
        	        damage = 0;
        	        force = 0;
        	        right = choose(-1, 1);
        	    }
        	break;

        	case "NewCocoon":
        	    o = instance_create(_x, _y, CustomProp);
        		with(o){
                     // Visual:
        			spr_idle = sprCocoon;
        			spr_hurt = sprCocoonHurt;
        			spr_dead = sprCocoonDead;
        			spr_shadow = shd24;
    
                     // Sound:
        			snd_dead = sndCocoonBreak;
    
                     // Vars:
        			maxhealth = 6;
        			nexthurt = current_frame;
        			size = 1;
        		}
        	break;
    	//#endregion

    	default:
    		return ["BigDecal", "Bone", "BoneSpawner", "BubbleBomb", "BubbleExplosion", "CoastBossBecome", "CoastBoss", "CustomChest", "Harpoon", "NetNade",
    		        "BloomingCactus", "BuriedCar", "CoastBigDecal", "CoastDecal", "Creature", "Diver", "DiverHarpoon", "Gull", "Palanking", "Palm", "Pelican", "Seal", "SealAnchor", "SealHeavy", "SealMine", "TrafficCrab", "TrafficCrabVenom",
    		        "ClamChest", "Hammerhead", "Puffer", "Crack",
    		        "Jellyfish", "Kelp", "Vent", "YetiCrab",
    		        "Cat", "CatBoss", "CatGrenade",
    		        "Mortar", "MortarPlasma", "NewCocoon"
    		        ];
    }

     /// Auto Assign Name + Scripts:
    var _scrt = ["step", "begin_step", "end_step", "draw", "destroy", "hurt", "death", "hit", "wall", "anim", "grenade", "projectile", "alrm0", "alrm1", "alrm2", "alrm3", "alrm4", "alrm5", "alrm6", "alrm7", "alrm8", "alrm9", "alrm10", "alrm11"];
    with(o){
        if("name" not in self) name = string(obj_name);

         // Scripts:
        for(var i = 0; i < array_length(_scrt); i++){
            var v = "on_" + _scrt[i];
            if(v not in self || is_undefined(variable_instance_get(id, v))){
                var s = name + "_" + _scrt[i];
                if(mod_script_exists("mod", mod_current, s)){
                    variable_instance_set(id, v, ["mod", mod_current, s]);
                }
    
                 // Exceptions:
                else switch(v){
                    case "on_hurt":
                        on_hurt = enemyHurt; break;
                    case "on_death":
                        on_death = scrDefaultDrop; break;
                }
            }
        }
    }
    return o;

#define BigDecal_step
    if(place_meeting(x, y, FloorExplo)){
    	instance_destroy();
    	exit;
    }
    if(place_meeting(x, y, Floor) || place_meeting(x, y, Bones)){
        instance_delete(id);
    }


#define Bone_step
     // Spin:
    rotation += speed * rotspeed;

     // Into Portal:
    if(place_meeting(x, y, Portal)){
        if(speed > 0){
            sound_play_pitchvol(sndMutant14Turn, 0.6 + random(0.2), 0.8);
            repeat(3) instance_create(x, y, Smoke);
        }
        instance_destroy();
    }

     // Turn Back Into Weapon:
    else if(speed <= 0 || place_meeting(x + hspeed, y + vspeed, PortalShock)){
         // Don't Get Stuck on Wall:
        mask_index = mskWepPickup;
        if(place_meeting(x, y, Wall)){
            instance_create(x, y, Dust);

            var w = instance_nearest(x, y, Wall),
                _dir = point_direction(w.x, w.y, x, y);

            while(place_meeting(x, y, w)){
                x += lengthdir_x(4, _dir);
                y += lengthdir_y(4, _dir);
            }
        }

        instance_destroy();
    }

#define Bone_draw
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, rotation, image_blend, image_alpha);

#define Bone_hit
     // Secret:
    if("name" in other && other.name == "CoastBossBecome"){
        with(other){
            part++;

             // Hit:
            sound_play_hit(snd_hurt, 0.3);
            sprite_index = spr_hurt;
            image_index = 0;
        }

         // Effects:
        sound_play_hit(sndMutant14Turn, 0.2);
        repeat(3){
            instance_create(x + orandom(4), y + orandom(4), Bubble);
            with(instance_create(x, y, Smoke)){
                motion_add(random(360), 1);
                depth = -2;
            }
        }

        instance_delete(id);
        exit;
    }

    projectile_hit_push(other, damage, speed * force);

     // Bounce Off Enemy:
    direction = point_direction(other.x, other.y, x, y);
    speed /= 2;
    rotspeed *= -1;

     // Sound:
    sound_play_pitchvol(sndBloodGamble, 1.2 + random(0.2), 0.8);

     // Break:
    broken = true;
    instance_destroy();

#define Bone_wall
     // Bounce Off Wall:
    if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
    if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;
    speed /= 2;
    rotspeed *= -1;

     // Effects:
    sound_play_hit(sndHitWall, 0.2);
    instance_create(x, y, Dust);

#define Bone_destroy
    instance_create(x, y, Dust);

     // Darn:
    if(broken){
        sound_play_pitch(sndHitRock, 1.4 + random(0.2));
        repeat(2) with(instance_create(x, y, Shell)){
            sprite_index = global.sprBoneShard;
            motion_add(random(360), 2);
        }
    }

     // Pickupable:
    else with(instance_create(x, y, WepPickup)){
        wep = "crabbone";
        rotation = other.rotation;
    }


#define BoneSpawner_step
    if(instance_exists(creator)){
         // Follow Creator:
        x = creator.x;
        y = creator.y;
    }
    else{
         // Enter the bone zone:
        with(instance_create(x, y, WepPickup)){
            wep = "crabbone";
            motion_add(random(360), 3);
        }

         // Effects:
        repeat(2) with(instance_create(x, y, Dust)){
            motion_add(random(360), 3);
        }

        with(instances_named(object_index, name)) instance_destroy();
        instance_destroy();
    }


#define BubbleBomb_step
     // Float Up:
    z_engine();
    image_angle += (sin(current_frame / 8) * 10) * current_time_scale;
    depth = min(depth, -z);

     // Collision:
    if(place_meeting(x, y, Player)) with(Player){
        if(place_meeting(x, y, other)) with(other){
            motion_add(point_direction(other.x, other.y, x, y), 1.5);
        }
    }
    if(place_meeting(x, y, object_index)){
        with(nearest_instance(x, y, instances_matching_ne(instances_named(object_index, name), "id", id))){
            if(place_meeting(x, y, other)){
                with(other) motion_add(point_direction(other.x, other.y, x, y), 0.5);
            }
        }
    }

     // Baseball:
    if(place_meeting(x, y, projectile)){
        var _slash = [Slash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, CustomSlash],
            _meeting = false;
    
        for(var i = 0; i < array_length(_slash); i++){
            if(place_meeting(x, y, _slash[i])){
                var s = instance_nearest(x, y, _slash[i]);
                direction = s.direction;
                speed = 8;
                break;
            }
        }
    }

     // Charged:
    if(current_frame_active){
        image_blend = c_white;
        if(random(image_number - image_index + 8) < 1){
            image_blend = c_black;
            var o = image_index / 3;
            instance_create(x + orandom(o), y + orandom(o), PortalL);
        }
    }

#define BubbleBomb_end_step
     // Hold Projectile:
    if(instance_exists(my_projectile)) with(my_projectile){
        //speed += friction * current_time_scale;
        other.x += (hspeed / 4);
        other.y += (vspeed / 4);

        var s = (current_frame / 1.5) + direction;
        x = other.x;
        y = other.y - other.z;
    }

     // Grab Projectile:
    else if(place_meeting(x, y, projectile)){
        with(instances_matching_ne(instances_matching_ne(instances_matching_ne(instances_matching(projectile, "bubble_bombed", null, false), "team", team), "typ", 0), "name", name)){
            if(place_meeting(x, y, other)){
                if(object_index == Flame || object_index == Bolt || object_index == Splinter || object_index == HeavyBolt || object_index == UltraBolt){
                    with(other) instance_destroy();
                }
                else{
                    bubble_bombed = true;
                    other.my_projectile = id;
                    with(other){
                        x = other.x;
                        y = other.y + z;
                        motion_add(other.direction, min(other.speed / 2, other.force));

                         // Effects:
                        instance_create(x, y, Dust);
                        repeat(4) instance_create(x, y, Bubble);
                        sound_play(sndOasisHurt);
                    }
                }

                break;
            }
        }
    }

#define BubbleBomb_draw
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    //draw_sprite_ext(asset_get_index(`sprPortalL${(x mod 5) + 1}`), image_index, x, y - z, image_xscale, image_yscale, image_angle / 3, image_blend, image_alpha);

#define BubbleBomb_hit
    if(other.team != 0){
         // Knockback:
        if(random(2) < 1){
            speed *= 0.9;
            with(other) motion_add(other.direction, other.force);
        }

         // Speed Up:
        if(team == 2) image_index += image_speed * 2;
    }

#define BubbleBomb_wall
    if(speed > 0){
        sound_play(sndBouncerBounce);
        move_bounce_solid(false);
        speed *= 0.5;
    }

#define BubbleBomb_anim
    with(my_projectile) instance_destroy();

     // Explode:
    with(obj_create(x, y, "BubbleExplosion")){
        team = other.team;
        var c = other.creator;
        if(instance_exists(c)){
            if(c.object_index == Player) team = 2;
            else if(team == 2) team = -1; // Popo nade logic
        }
        hitid = other.hitid;
    }
    instance_destroy();

#define BubbleBomb_destroy
     // Pop:
    sound_play_pitchvol(sndLilHunterBouncer, 2 + random(0.5), 0.5);
    with(instance_create(x, y - z, BulletHit)){
        sprite_index = sprPlayerBubblePop;
        image_angle = other.image_angle;
        image_xscale = 0.5 + (0.01 * other.image_index);
        image_yscale = image_xscale;
    }


#define CoastBossBecome_step
     // Animate:
    image_index = part;
    if(nexthurt > current_frame + 3) sprite_index = spr_hurt;
    else if(sprite_index == spr_hurt) sprite_index = spr_idle;

     // Skeleton Rebuilt:
    if(part >= sprite_get_number(spr_idle) - 1){
        with(obj_create(x - (image_xscale * 8), y - 6, "CoastBoss")){
            x = xstart;
            y = ystart;
            right = other.image_xscale;
        }
        with(Portal) instance_destroy();
        with(WantBoss) instance_destroy();
        with(BanditBoss) my_health = 0;
        instance_delete(id);
    }

#define CoastBossBecome_death
     // Death Effects:
    if(part > 0){
        sound_play(sndOasisDeath);
        repeat(part * 2) instance_create(x, y, Bubble);
    }
    else for(var a = direction; a < direction + 360; a += (360 / 10)){
        with(instance_create(x, y, Dust)) motion_add(a, 3);
    }


#define CoastBoss_step
    enemyAlarms(3);

     // Animate:
    if(
        sprite_index != spr_hurt &&
        sprite_index != spr_spwn &&
        sprite_index != spr_dive &&
        sprite_index != spr_rise &&
        sprite_index != spr_efir &&
        sprite_index != spr_fire &&
        sprite_index != spr_chrg 
    ){
        if(speed <= 0) sprite_index = spr_idle;
    	else if(sprite_index == spr_idle) sprite_index = spr_walk;
    }
    else if(anim_end){
        var _lstspr = sprite_index;
        if(fork()){
            if(sprite_index == spr_spwn) {
                sprite_index = spr_idle;

                 // Spawn FX:
                hspeed += 2 * right;
                vspeed += orandom(2);
                view_shake_at(x, y, 15);
                sound_play(sndOasisBossIntro);
                instance_create(x, y, PortalClear);
                repeat(10) with(instance_create(x, y, Dust)){
                    motion_add(random(360), 5);
                }

                 // Intro:
                if(!intro){
                    intro = true;
                    scrBossIntro("", sndOasisBossIntro, musBoss1);
                    with(MusCont) alarm_set(3, -1);
                }
                exit; }

            if(sprite_index = spr_dive) {
                sprite_index = spr_idle;

                 // Start Swimming:
                swim = true;
                direction = 90 - (right * 90);
                swim_ang_frnt = direction;
                swim_ang_back = direction;
                exit; }

            if(sprite_index = spr_hurt || sprite_index == spr_efir){
                sprite_index = spr_idle;
                exit; }

            if(sprite_index = spr_rise){
                sprite_index = spr_idle;
                spr_shadow = spr_shad;
                exit; }

            if(sprite_index = spr_chrg){
                sprite_index = spr_fire;
                exit; }

            if(sprite_index = spr_fire && ammo <= 0){
                sprite_index = spr_efir;
                exit; }
        }
        if(sprite_index != _lstspr) image_index = 0;
    }

     // Movement:
    enemyWalk(walkspd, maxspd);

     // Swimming:
    if(swim){
        speed += 0.8 * current_time_scale;

         // Follow Player:
        direction += (angle_difference(point_direction(x, y, swimx, swimy), direction) / 10) * current_time_scale;

         // Turn Fins:
        swim_ang_frnt += (angle_difference(direction, swim_ang_frnt) / 3) * current_time_scale;
        swim_ang_back += (angle_difference(swim_ang_frnt, swim_ang_back) / 10) * current_time_scale;

         // Break Walls:
        if(place_meeting(x + hspeed, y + vspeed, Wall)){
            speed /= 2;

             // Effects:
            var w = instance_nearest(x, y, Wall);
            with(instance_create(w.x, w.y, MeleeHitWall)){
                motion_add(point_direction(x, y, other.x, other.y), 1);
                image_angle = direction + 180;
            }
            sound_play_pitchvol(sndHammerHeadProc, 1.4 + random(0.2), 0.5);

             // Break Wall:
            with(w){
                instance_create(x, y, FloorExplo);
                instance_destroy();
            }
        }

         // Visual:
        spr_shadow = mskNone;
        if(current_frame_active){
            var _cx = x,
                _cy = bbox_bottom;

             // Debris:
            if((place_meeting(x, y, FloorExplo) && random(30) < 1) || random(40) < 1){
                repeat(irandom(2)){
                    with(instance_create(_cx, _cy, Debris)){
                        speed /= 2;
                    }
                }
            }

             // Ripping Through Ground:
            var _oDis = [16, -4],
                _oDir = [swim_ang_frnt, swim_ang_back],
                _ang = [20, 30];

            for(var o = 0; o < array_length(_oDis); o++){
                for(var i = -1; i <= 1; i += 2){
                    var _x = _cx + lengthdir_x(_oDis[o], _oDir[o]),
                        _y = _cy + lengthdir_y(_oDis[o], _oDir[o]),
                        a = (i * _ang[o]);

                     // Cool Trail FX:
                    if(speed > 1) with(instance_create(_x, _y, BoltTrail)){
                        motion_add(_oDir[o] + 180 + a, (other.speed + random(other.speed)) / 2);
                        image_xscale = speed * 2;
                        image_yscale = (skill_get(mut_bolt_marrow) ? 0.6 : 1);
                        image_angle = direction;
                        hspeed += other.hspeed;
                        vspeed += other.vspeed;
                        friction = random(0.5);
                        //image_blend = make_color_rgb(110, 184, 247);
                    }

                     // Kick up Dust:
                    if(random(20) < 1){
                        with(instance_create(_x, _y, Dust)){
                            hspeed += other.hspeed / 2;
                            vspeed += other.vspeed / 2;
                            motion_add(_oDir[o] + 180 + (2 * a), other.speed);
                            image_xscale *= .75;
                            image_yscale = image_xscale;
                        }
                    }
                }
            }

             // Quakes:
            if(random(3) < 1) view_shake_at(_cx, _cy, 4);
        }
    }

#define CoastBoss_hurt(_hitdmg, _hitvel, _hitdir)
     // Can't be hurt while swimming:
    if(swim){
        with(other) if("typ" in self && typ != 0){
             // Effects:
            sound_play_pitch(sndCrystalPropBreak, 0.7);
            sound_play_pitchvol(sndShielderDeflect, 1.5, 0.5);
            repeat(5) with(instance_create(x, y, Dust)){
                motion_add(random(360), 3);
            }

             // Destroy (1 frame delay to prevent errors):
            if(fork()){
                wait 1;
                if(instance_exists(self)) instance_destroy();
                exit;
            }
        }
    }
    else{
        my_health -= _hitdmg;           // Damage
        nexthurt = current_frame + 6;	// I-Frames

         // Sound:
        sound_play_hit(swim ? sndBigMaggotHit : snd_hurt, 0.3);

         // Knockback:
        if(!swim){
            motion_add(_hitdir, _hitvel);
        }

         // Hurt Sprite:
        if(
            sprite_index != spr_fire &&
            sprite_index != spr_chrg &&
            sprite_index != spr_efir &&
            sprite_index != spr_dive &&
            sprite_index != spr_rise
        ){
            sprite_index = spr_hurt;
            image_index = 0;
        }
    }

#define CoastBoss_draw
    var h = (nexthurt > current_frame + 3);

    if(swim){
        if(h) d3d_set_fog(1, c_white, 0, 0);

        var _cx = x,
            _cy = bbox_bottom;
    
        for(var a = 0; a < 4; a++){
            var _x = _cx,
                _y = _cy,
                _xscale = image_xscale,
                _yscale = image_yscale,
                _blend = image_blend,
                _alpha = image_alpha,
                _swimSpd = (current_frame / 3),
                _spr = [global.sprBigFishSwimFrnt,      global.sprBigFishSwimBack           ],
                _ang = [swim_ang_frnt,                  swim_ang_back                       ],
                _dis = [10 * _xscale,                   10 * _xscale                        ], // Offset Distance
                _dir = [_ang[0] + (5 * sin(_swimSpd)),  _ang[1] + 180 + (5 * sin(_swimSpd))], // Offset Direction
                _trn = [15 * cos(_swimSpd),             -25 * cos(_swimSpd)                 ];
    
             // Outline:
            if(a < 3){
                _blend = c_black;
                _x += lengthdir_x(1, a * 90);
                _y += lengthdir_y(1, a * 90);
            }
    
             // Draw Front & Back Fins:
            for(var j = 0; j < array_length(_spr); j++){
                var s = _spr[j],
                    _drawx = _x + lengthdir_x(_dis[j], _dir[j]),
                    _drawy = _y + lengthdir_y(_dis[j], _dir[j]);
    
                for(var i = 0; i < sprite_get_number(s); i++){
                    draw_sprite_ext(s, i, _drawx, _drawy - (i * _yscale), _xscale, _yscale, _ang[j] + _trn[j], _blend, _alpha);
                }
            }
        }
    }

     // Normal Self:
    else{
        if(h && sprite_index != spr_hurt) d3d_set_fog(1, c_white, 0, 0);
        draw_self_enemy();
    }

    if(h) d3d_set_fog(0, 0, 0, 0);

#define CoastBoss_alrm0
    alarm0 = 60 + irandom(20);
    target = instance_nearest(x, y, Player);
    if(target_in_distance(0, 160)) {
        var _targetDir = point_direction(x, y, target.x, target.y);
    
         // Bubble Attack:
        if(random(3) < 2) {
            image_index = 0;
            sprite_index = spr_chrg;
            sound_play_pitch(sndOasisBossFire, 1 + orandom(0.2));

            gunangle = _targetDir;
            ammo = 4 * (GameCont.loops + 2);

            alarm1 = 3;
            alarm0 = -1;
        }
    
         // Dive:
        else if(random(4) < 1) alarm2 = 6;
    
         // Move Towards Target:
        else{
            scrWalk(30 + random(10), _targetDir + orandom(15));
            alarm0 = walk + random(10);
        }

        scrRight(_targetDir);
    }

     // Dive:
    else if(instance_exists(target)) alarm2 = 6;

     // Passive Movement:
    else{
        alarm0 = 40 + irandom(20);
        scrWalk(20, random(360));
    }

#define CoastBoss_alrm1
     // Fire Bubble Bombs:
    repeat(irandom_range(1, 2)){
        if(ammo > 0){
            alarm1 = 2;

             // Blammo:
            sound_play(sndOasisShoot);
            scrEnemyShoot("BubbleBomb", gunangle + (sin(shot_wave / 4) * 24), 8 + random(4));
            shot_wave += alarm1;
            walk++;

             // End:
            if(--ammo <= 0){
                alarm0 = 40;
            }
        }
    }

#define CoastBoss_alrm2
    target = instance_nearest(x, y, Player);

     // Dive:
    var _notSwimming = (sprite_index != spr_dive && !swim);
    if(_notSwimming || (instance_exists(target) && (point_distance(x, y, target.x, target.y) > 80 || random(2) < 1))){
        if(_notSwimming){
            sprite_index = spr_dive;
            image_index = 0;
            spr_shadow = mskNone;
            sound_play(sndOasisBossMelee);
        }

        swimx = target.x + orandom(48);
        swimy = target.y + orandom(48);

        alarm2 = 15;
        alarm0 = alarm2 + 10;
    }

     // Un-Dive:
    else{
        swim = false;
        image_index = 0;
        sprite_index = spr_rise;
        scrRight(direction);
        speed = 0;

         // Babbies:
        if(GameCont.loops > 0) repeat(GameCont.loops * 3){
            with(instance_create(x, y, BoneFish)) kills = 0;
        }

         // Effects:
        instance_create(x, y, PortalClear);
        sound_play_pitchvol(sndFootOrgSand1, 0.5, 5);
        sound_play_pitchvol(sndToxicBoltGas, 0.5 + random(0.2), 0.5);
        repeat(10){
            var _dis = 12,
                _dir = random(360);

            with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Dust)){
                motion_add(_dir, 3);
            }
        }
    }

#define CoastBoss_death
     // Coast Entrance:
    instance_create(x, y, Portal);
    GameCont.area = "coast";
    GameCont.subarea = 0;
    with(enemy) my_health = 0;

     // Boss Win Music:
    with(MusCont) alarm_set(1, 1);


#define CustomChest_step(_inst)
    if(instance_exists(_inst)) with(_inst){
         // Open Chest:
        var c = [Player, PortalShock];
        for(var i = 0; i < array_length(c); i++) if(place_meeting(x, y, c[i])){
            with(instance_nearest(x, y, c[i])) with(other){
                 // Call Chest Open Event:
                var e = on_open;
                if(mod_script_exists(e[0], e[1], e[2])){
                    mod_script_call(e[0], e[1], e[2], (i == 0));
                }

                 // Effects:
                with(instance_create(x, y, ChestOpen)) sprite_index = other.spr_open;
                instance_create(x, y, FXChestOpen);
                sound_play(snd_open);

                instance_destroy();
            }
            break;
        }
    }
    else instance_destroy();


#define Harpoon_end_step
     // Trail:
    var _x1 = x,
        _y1 = y,
        _x2 = xprevious,
        _y2 = yprevious;

    with(instance_create(x, y, BoltTrail)){
        image_yscale = 0.6;
        image_xscale = point_distance(_x1, _y1, _x2, _y2);
        image_angle = point_direction(_x1, _y1, _x2, _y2);
        creator = other.creator;
    }

#define Harpoon_step
     // Stuck in Target:
    var _targ = target;
    if(instance_exists(_targ)){
        if(canmove){
            var _odis = 16,
                _odir = image_angle;
    
            x = _targ.x - lengthdir_x(_odis, _odir);
            y = _targ.y - lengthdir_y(_odis, _odir);
            xprevious = x;
            yprevious = y;
            visible = _targ.visible;
        }

         // Pickup-able:
        if(alarm0 < 0){
            image_index = 0;

            var _pickup = 1;
            with(rope) if(!broken) _pickup = 0;
            if(_pickup){
                alarm0 = 200 + random(20);
                if(GameCont.crown == crwn_haste) alarm0 /= 3;
            }
        }
        else if(instance_exists(Player)){
             // Shine:
            image_speed = (image_index < 1 ? random(0.04) : 0.4);

             // Attraction:
            var p = instance_nearest(x, y, Player);
            if(point_distance(x, y, p.x, p.y) < (skill_get(mut_plutonium_hunger) ? 100 : 50)){
                canmove = 0;

                var _dis = 10,
                    _dir = point_direction(x, y, p.x, p.y);

                x += lengthdir_x(_dis, _dir);
                y += lengthdir_y(_dis, _dir);
                xprevious = x;
                yprevious = y;

                 // Pick Up Bolt Ammo:
                if(place_meeting(x, y, p) || place_meeting(x, y, Portal)){
                    with(p){
                        ammo[3] = min(ammo[3] + 1, typ_amax[3]);
                        instance_create(x, y, PopupText).text = "+1 BOLTS";
                        sound_play(sndAmmoPickup);
                    }
                    instance_destroy();
                }
            }
        }
    }

    else{
         // Rope Length:
        with(rope) if(!harpoon_stuck){
            if(instance_exists(link1) && instance_exists(link2)){
                length = point_distance(link1.x, link1.y, link2.x, link2.y);
            }
        }

        if(speed > 0){
             // Bolt Marrow:
            if(skill_get(mut_bolt_marrow)){
                var n = instance_nearest(x, y, enemy);
                if(distance_to_object(n) < 16 && !place_meeting(x, y, n)){
                    direction = point_direction(x, y, n.x, n.y);
                    image_angle = direction;
                }
            }

             // Stick in Chests:
            var c = instance_nearest(x, y, chestprop);
            if(place_meeting(x, y, c)) scrHarpoonStick(c);
        }

        else instance_destroy();
    }

    if(instance_exists(self)) enemyAlarms(1);

#define Harpoon_hit
    if(speed > 0){
        if(projectile_canhit(other)){
            projectile_hit_push(other, damage, force);

             // Stick in enemies that don't die:
            if(other.my_health > 0){
                if(
                    (instance_is(other, prop) && other.object_index != RadChest)
                    ||
                    ("name" in other && name == "CoastDecal")
                ){
                    canmove = 0;
                }
                scrHarpoonStick(other);
            }
        }
    }

#define Harpoon_wall
    if(speed > 0){
        move_contact_solid(direction, 16);
        instance_create(x, y, Dust);
        sound_play(sndBoltHitWall);

         // Stick in Wall:
        canmove = 0;
        scrHarpoonStick(other);
    }

#define Harpoon_alrm0
     // Blinking:
    if(blink-- > 0){
        alarm0 = 2;
        visible = !visible;
    }
    else instance_destroy();

#define Harpoon_destroy
    scrHarpoonUnrope(rope);


#define NetNade_step
    if(alarm0 > 0 && alarm0 < 15) sprite_index = sprGrenadeBlink;
    enemyAlarms(1);

#define NetNade_hit
    if(speed > 0 && projectile_canhit(other)){
        lasthit = other;
        projectile_hit_push(other, damage, force);
        if(alarm0 > 1) alarm0 = 1;
    }

#define NetNade_wall
    if(alarm0 > 1) alarm0 = 1;

#define NetNade_alrm0
    instance_destroy();

#define NetNade_destroy
     // Effects:
    repeat(8) instance_create(x, y, Dust);
    sound_play(sndUltraCrossbow);
    sound_play(sndFlakExplode);
    view_shake_at(x, y, 20);

     // Break Walls:
    while(distance_to_object(Wall) < 32){
        with(instance_nearest(x, y, Wall)){
            instance_create(x, y, FloorExplo);
            instance_destroy();
        }
    }

     // Harpoon-Splosion:
    var _num = 10,
        _ang = random(360),
        o = 8, // Spawn Offset
        f = noone, // First Harpoon Created
        h = noone; // Latest Harpoon Created

    for(var a = _ang; a < _ang + 360; a += (360 / _num)){
        with(obj_create(x + lengthdir_x(o, a), y + lengthdir_y(o, a), "Harpoon")){
            motion_add(a + orandom(5), 22);
            image_angle = direction;
            team = other.team;
            creator = other.creator;
            if(direction > 90 && direction < 270) image_yscale = -1;

             // Explosion Effect:
            with(instance_create(x, y, MeleeHitWall)){
                motion_add(other.direction, 1 + random(2));
                image_angle = direction + 180;
                image_speed = 0.6;
            }

             // Link harpoons to each other:
            if(!instance_exists(f)) f = id;
            if(instance_exists(h)) scrHarpoonRope(id, h);
            h = id;
        }
    }
    scrHarpoonRope(f, h);


#define Creature_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd,maxspd);
     // Run away when hurt:
    if nexthurt > current_frame && !scared{
        scared = true;
        instance_create(x+right*65,y-24,AssassinNotice);
    }
    
     // Pushed away from floors:
    var _f = instance_nearest(x,y,Floor);
    if point_distance(x,y,_f.x,_f.y) <= 128
        motion_add_ct(point_direction(_f.x,_f.y,x,y),3);

     // Push Player:
    if(place_meeting(x, y, Player)){
        with(Player) if(place_meeting(x, y, other)){
            motion_add_ct(point_direction(other.x,other.y,x,y), 3);
        }
    }

#define Creature_draw
    draw_self_enemy();
    
#define Creature_alrm0
    alarm0 = 30;
    if instance_exists(Player){
         // finds the nearest wading player
        var _p = noone,
            _bigdist = 10000;
        with(Player) if !collision_line(x,y,other.x,other.y,Floor,0,0){
            var _distance = point_distance(x,y,other.x,other.y);
            if _distance < _bigdist{
                _p = self;
                _bigdist = _distance;
            }
        }
        if !scared{
            if instance_exists(_p){
                 // investigate wading player
                if point_distance(x,y,_p.x,_p.y) > 128
                    scrWalk(20+irandom(10),point_direction(x,y,_p.x,_p.y));
                else if random(4) < 1
                    instance_create(x+right*65,y-24,HealFX);
                scrRight(point_direction(x,y,_p.x,_p.y));
            }
            else{
                 // wander
                scrWalk(20+irandom(10),direction+random(20));
                scrRight(direction);
            }
        }
        else{
            if instance_exists(_p)
                scrWalk(999999999, point_direction(_p.x, _p.y, x, y));
            else{
                _p = instance_nearest(x,y,Player);
                scrWalk(20+irandom(10),point_direction(_p.x, _p.y, x, y));
            }
            scrRight(direction);
        }
    }

#define BuriedCar_step
    if(instance_exists(my_floor)){
        x = my_floor.x + 16;
        y = my_floor.y + 16;
    }
    else instance_destroy();

#define BuriedCar_death
     // Explosion:
    repeat(2) instance_create(x + orandom(3), y + orandom(3), Explosion);
    repeat(2) instance_create(x + orandom(3), y + orandom(3), SmallExplosion);
    sound_play(sndExplosionCar);

     // Break Floor:
    if(instance_exists(my_floor)){
        mod_variable_set("area", "coast", "surfFloorReset", true);
        with(my_floor){
            if(place_meeting(x, y, Detail)){
                with(Detail) if(place_meeting(x, y, other)){
                    instance_destroy();
                }
            }
            instance_destroy();
        }
        repeat(4) instance_create(x + orandom(8), y + orandom(8), Debris);
    }


#define CoastDecal_create(_x, _y, _shell)
    with(instance_create(_x, _y, CustomHitme)){
        name = "CoastDecal";

        shell = _shell;

         // Visual:
        if(shell){
            type = 0;
            spr_idle = global.sprShellIdle;
            spr_hurt = global.sprShellHurt;
            spr_dead = global.sprShellDead;
            spr_bott = global.sprShellBott;
            spr_foam = global.sprShellFoam;
        }
        else{
            type = irandom(array_length(global.sprRockIdle) - 1);
            spr_idle = global.sprRockIdle[type];
            spr_hurt = global.sprRockHurt[type];
            spr_dead = global.sprRockDead[type];
            spr_bott = global.sprRockBott[type];
            spr_foam = global.sprRockFoam[type];
        }
        spr_walk = spr_idle;
        image_xscale = choose(-1, 1);
        image_speed = 0.4;
        spr_shadow = mskNone;
        depth = (shell ? -2 : 0) + (-y / 20000);
        friction = 3;

         // Sound:
        snd_hurt = sndHitRock;
        snd_dead = (shell ? sndHyperCrystalHurt : sndWallBreakRock);

         // Vars:
        mask_index = (shell ? mskScrapBoss : mskBandit);
        mask_floor = (shell ? mskSalamander : mskAlly);
        maxhealth = (shell ? 100 : 50);
        my_health = maxhealth;
        size = (shell ? 4 : 3);
        team = 0;

         // Offset:
        x += orandom(10);
        y += orandom(10);

         // Doesn't Use Coast Wading System:
        nowade = true;

        on_step = CoastDecal_step;
        on_hurt = CoastDecal_hurt;

        return id;
    }

#define CoastDecal_step
     // Animate:
    if(anim_end){
        if(sprite_index != spr_dead) sprite_index = spr_idle;
        else{
            image_speed = 0;
            image_index = image_number - 1;
        }
    }

     // Pushing:
    if(place_meeting(x, y, hitme)){
        with(instances_matching_lt(hitme, "size", size)){
            if(place_meeting(x, y, other)){
                motion_add(point_direction(other.x, other.y, x, y), 1);
            }
        }
        if(!shell) with(instances_matching_ge(hitme, "size", size)){
            if(place_meeting(x, y, other) && object_index != Player){
                with(other) motion_add(point_direction(other.x, other.y, x, y), 4);
            }
        }
        with(Player){
            if(place_meeting(x, y, other)){
                motion_add(point_direction(other.x, other.y, x, y), 1);
            }
        }
    }

#define CoastDecal_hurt(_hitdmg, _hitvel, _hitdir)
    nexthurt = current_frame + 6;   // I-Frames
    sound_play_hit(snd_hurt, 0.3);  // Sound

     // Hurt Sprite:
    sprite_index = spr_hurt;
    image_index = 0;

     // Splashy FX:
    repeat(1 + (_hitdmg / 5)){
        var _dis = (shell ? 24 : 8),
            _dir = _hitdir + 180 + orandom(30);

        with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Sweat)){
            speed = random(speed);
            direction = _dir;
        }
    }

     // Damage:
    if(my_health > 0){
        my_health -= _hitdmg;

         // Break:
        if(my_health <= 0){
            mask_index = mskNone;
            sprite_index = spr_dead;
            team = 2;

             // Can Stand On Corpse:
            with(instance_create(0, 0, Floor)){
                x = other.x;
                y = other.y;
                visible = 0;
                mask_index = other.mask_floor;
            }

             // Weapon Drop:
            //pickup_drop(0, 100);

             // Visual Stuff:
            depth = (shell ? 0 : 1);
            with(instances_matching(BoltStick, "target", id)) instance_destroy();

             // Water Rock Debris:
            if(!shell){
                var _ang = random(360);
                for(var a = _ang; a < _ang + 360; a += 360 / 3){
                    with(instance_create(x, y, MeleeHitWall)) image_angle = a + orandom(10);
                }
                repeat(choose(2, 3)){
                    with(instance_create(x + orandom(2), y + orandom(2), Debris)){
                        motion_set(_hitdir + orandom(10), (speed + _hitvel) / 2);
                    }
                }
            }

             // Break Sound:
            sound_play_pitch(snd_dead, 1 + random(0.2));
        }
    }


#define Diver_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);

#define Diver_alrm0
    alarm0 = 60 + irandom(30);
    target = instance_nearest(x, y, Player);
    if(target_is_visible()) {
        var _targetDir = point_direction(x, y, target.x, target.y);

    	if(target_in_distance(60, 320) || array_length(instances_matching(instances_named(CustomProp, "Palm"), "my_enemy", id)) > 0){
    	     // Shoot Harpoon:
    		if(spr_weap = global.sprHarpoonGun && random(4) < 1){
    			gunangle = _targetDir + orandom(10);
    			scrEnemyShoot("DiverHarpoon", gunangle, 12);

                wkick = 8;
                sound_play(sndCrossbow);
    			spr_weap = global.sprHarpoonGunEmpty;
    		}

             // Reload Harpoon:
    		else if(spr_weap = global.sprHarpoonGunEmpty){
    			sound_play_hit(sndCrossReload,0);
    			spr_weap = global.sprHarpoonGun;
    			wkick = 2;
    		}

    		alarm0 = 30 + irandom(30);
    	}

         // Move Away From Target:
    	else{
    		alarm0 = 45 + irandom(30);
    		direction = _targetDir + 180 + orandom(30);
    		gunangle = direction + orandom(15);
    		walk = 15 + irandom(15);
    	}

    	 // Facing:
    	scrRight(_targetDir);
    }

     // Passive Movement:
    else{
    	direction = random(360);
    	gunangle = direction + orandom(15);
    	walk = 30;
    	scrRight(direction);
    }

#define Diver_draw
    if(gunangle <= 180) draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
    draw_self_enemy();
    with(instances_matching(instances_named(CustomProp, "Palm"), "my_enemy", id)) draw_self();
    if(gunangle > 180) draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);


#define DiverHarpoon_end_step
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

#define DiverHarpoon_alrm0
    instance_destroy();

#define DiverHarpoon_hit
    var _inst = other;
    if(speed > 0 && projectile_canhit(_inst) && ("my_enemy" not in other || other.my_enemy != creator)){
        var _hp = _inst.my_health;

         // Damage:
        projectile_hit_push(_inst, damage, force);

         // Stick in Player:
        with(instance_create(x, y, BoltStick)){
            image_angle = other.image_angle;
            target = _inst;
        }
        instance_destroy();
    }

#define DiverHarpoon_wall
     // Stick in Wall:
    if(speed > 0){
        speed = 0;
        sound_play_hit(sndBoltHitWall,.1);
        move_contact_solid(direction, 16);
        instance_create(x, y, Dust);
        alarm0 = 30;
    }

#define DiverHarpoon_anim
    image_speed = 0;
    image_index = image_number - 1;


#define Gull_step
    enemyAlarms(2);
    enemySprites();
    enemyWalk(walkspd, maxspd);

#define Gull_alrm0
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
        		direction = _targetDir + orandom(20);
        		gunangle = direction + orandom(15);
    		}
    	}

         // Move Toward Target:
    	else{
    		alarm0 = 30 + irandom(10);
    		walk = 10 + irandom(20);
    		direction = _targetDir + orandom(20);
    		gunangle = direction + orandom(15);
    	}

    	 // Facing:
    	scrRight(direction);
    }

     // Passive Movement:
    else{
    	walk = 30;
    	direction = random(360);
    	gunangle = direction + orandom(15);
    	scrRight(direction);
    }

#define Gull_alrm1
     // Slash:
    gunangle = point_direction(x, y, target.x, target.y) + orandom(10);
    with(scrEnemyShoot(EnemySlash, gunangle, 4)) damage = 2;

     // Visual/Sound Related:
    wkick = -3;
    wepangle = -wepangle;
    motion_add(gunangle, 4);
    sound_play(sndChickenSword);
    scrRight(gunangle);

#define Gull_draw
    if(gunangle <= 180) draw_weapon(spr_weap, x, y, gunangle, wepangle, wkick, 1, image_blend, image_alpha);
    draw_self_enemy();
    if(gunangle > 180) draw_weapon(spr_weap, x, y, gunangle, wepangle, wkick, 1, image_blend, image_alpha);


#define Palanking_step
    enemyAlarms(4);
    if(z <= 0) walk = 0;
    enemyWalk(walkspd, maxspd);

     // Seals:
    var _sealNum = (seal_max - array_count(seal, noone)),
        _holdx = seal_x,
        _holdy = seal_y,
        _holding = [0, 0];

    for(var i = 0; i < array_length(seal); i++){
        if(instance_exists(seal[i])){
            var _x = _holdx[i] + (1.5 * right),
                _y = _holdy[i];

            with(seal[i]){
                if(hold){
                    if(sprite_index == spr_spwn){
                        hold_x = _x;
                        hold_y = _y;
                    }
                    else{
                        _holding[_holdx[i] > 0]++;
                        if(_sealNum > 1){
                            if(hold_x != _x){
                                hspeed = random(clamp(_x - hold_x, -maxspd, maxspd));
                                hold_x += hspeed;
                            }
                            if(hold_y != _y){
                                vspeed = random(clamp(_y - hold_y, -maxspd, maxspd));
                                hold_y += vspeed;
                            }
                        }
                    }
                }
                else{
                    hold_x = x - other.x;
                    hold_y = y - other.y;
                    motion_add(point_direction(x, y, other.x + _x, other.y + _y) + orandom(10), walkspd);
                    if(distance_to_point(_x, _y) < 8 || distance_to_object(other) < 8) hold = true;
                }
            }
        }
        else if(seal[i] != noone){
            seal[i] = noone;
            _sealNum--;
        }
    }

     // Fight Time:
    if(active){
         // Seals Run Over to Lift:
        if(_sealNum < seal_max){
            with(instances_named(CustomEnemy, "Seal")){
                if(!seal_exists(other, id)){
                    seal_add(other, id);
                    break;
                }
            }
        }

         // Not Enough Seals Holding:
        if(_holding[0] + _holding[1] <= 1){
            if(zgoal != 0){
                zgoal = 0;
                zspeed = 6;
            }
        }
        else{
             // Make Sure Seals on Both Sides:
            for(var i = 0; i < 2; i++) if(_holding[i] <= 0){
                for(var j = 0; j < array_length(seal); j++){
                    if(seal[j] != noone && ((j + !i) % 2)){
                        if(random(3) < 1){
                            var s = seal[j];
                            seal[j] = noone;

                            var o = (2 * !i) - 1;
                            if(j + o < 0) o = 1;
                            if(j + o >= array_length(seal)) o = -1;
                            seal[j + o] = s;
                        }
                    }
                }
            }

             // Lifted Up:
            if(zgoal == 0) zgoal = 12;
        }

         // Push to Shore:
        if(instance_exists(Floor)){
            if(distance_to_object(Floor) >= 80 && zspeed == 0){
                var f = instance_nearest(x - 16, y - 16, Floor);
                motion_add(point_direction(x, y, f.x, f.y), 1);
            }
        }
    }

     // Pre-Intro Stuff:
    else{
        x = xstart;
        y = ystart;

         // Begin Intro:
        if(alarm0 < 0){
            if(instance_number(enemy) - instance_number(Van) <= 1){
                alarm0 = 30;
                phase++;
            }
        }

        else{
             // Freeze Enemies:
            with(Seal) alarm0 = 30 + random(120);
            if(current_frame_active) with(WantRevivePopoFreak) alarm0++;

            if(instance_exists(Player) && intro_pan != 0){
                 // Disable Shooting:
                with(Player){
                    clicked = false;
                    can_shoot = false;
                    bcan_shoot = false;
                    reload = max(reload, 2);
                    breload = max(breload, 2);
                }

                 // Attract Pickups:
                with(Pickup) if(object_index != WepPickup && speed <= 0){
                    var t = instance_nearest(x, y, Player);
                    if(point_distance(x, y, t.x, t.y) > 30){
                        var _dis = 6,
                            _dir = point_direction(x, y, t.x, t.y);

                        if(object_index == Rad || object_index == BigRad) _dis *= 2;

                        x += lengthdir_x(_dis, _dir);
                        y += lengthdir_y(_dis, _dir);
                    }
                }
            }
        }
    }

     // Pan Intro Camera:
    if(intro_pan > 0){
        intro_pan -= current_time_scale;

        var s = UberCont.opt_shake,
            _px = intro_pan_x,
            _py = intro_pan_y;
    
        UberCont.opt_shake = 1;
        for(var i = 0; i < maxp; i++){
            view_object[i] = id;
            view_pan_factor[i] = 10000;
            if(intro_pan <= 0) view_pan_factor[i] = null;
            with(player_find(i)){
                var g = gunangle,
                    _x = other.x,
                    _y = other.y;

                gunangle = point_direction(_x, _y, _px, _py);
                weapon_post(wkick, point_distance(_x, _y, _px, _py) / 1.5, 0);
                gunangle = g;
            }
        }
        UberCont.opt_shake = s;
    }
    else for(var i = 0; i < maxp; i++){
        if(view_object[i] == id) view_object[i] = noone;
    }

     // Z-Axis:
    z += zspeed * current_time_scale;
    if(z <= zgoal){
        if(z < zgoal && zspeed == 0){
            if(zgoal <= 0) z = zgoal;
            else zspeed = (zgoal - z) / 2;
        }
        if(zspeed <= 0){
             // Held in Air:
            if(zgoal > 0){
                z = zgoal + zspeed;
                zspeed *= 0.8;
            }

             // Ground Landing:
            else if(zspeed < 0){
                 // Ground Smash:
                if(zspeed < -5){
                    alarm2 = 1;
                    sound_play_hit_big(sndBigBanditMeleeHit, 0.3);
                }

                zspeed *= -0.2;
            }

            if(abs(zspeed) < zfric){
                zspeed = 0;
                z = zgoal;
            }
        }
    }
    else zspeed -= zfric * current_time_scale;

     // Death Taunt:
    if(tauntdelay > 0 && !instance_exists(Player)){
        tauntdelay -= current_time_scale;
        if(tauntdelay <= 0){
            image_index = 0;
            sprite_index = spr_taun;
            sound_play(snd.PalankingTaunt);
        }
    }

     // Animate:
    if(sprite_index != spr_burp){
        if(sprite_index != spr_hurt && sprite_index != spr_call && sprite_index != spr_taun){
            if(speed <= 0) sprite_index = spr_idle;
            else sprite_index = spr_walk;
        }
        else if(anim_end) sprite_index = spr_idle;
    }
    else if(anim_end) image_index = 1;

     // Smack Smack:
    if(sprite_index == spr_call){
        var _img = floor(image_index);
        if(image_index < _img + image_speed && (_img == 4 || _img == 7)){
            sound_play_pitchvol(sndHitRock, 0.8 + orandom(0.2), 0.6);
        }
    }

     // Hitbox/Shadow:
    if(z <= 4){
        mask_index = mask_hold;
        if(spr_shadow != mskNone){
            spr_shadow_hold = spr_shadow;
            spr_shadow = mskNone;
        }
    }
    else{
        spr_shadow = spr_shadow_hold;
        if(mask_index != mskNone){
            mask_hold = mask_index;
            mask_index = mskNone
        }

         // Plant Snare:
        mask_index = mask_hold;
        if(place_meeting(x, y, Tangle)){
            x -= (hspeed * 0.5);
            y -= (vspeed * 0.5);
        }
        mask_index = mskNone;
    }

#macro Seal instances_matching(CustomEnemy, "name", "Seal", "SealHeavy")

#define seal_exists(_palanking, _inst)
    return (instance_exists(_palanking) && array_find_index(_palanking.seal, _inst) >= 0);

#define seal_add(_palanking, _inst)
    with(_palanking){
         // Generate Hold Positions:
        if(array_length(seal) != seal_max){
            seal = array_create(seal_max, noone);

             // Manual Placement:
            if(seal_max <= 4){
                seal_x = [33.5, -33.5, 30.5, -30.5];
                seal_y = [16, 16, 28, 28];
            }
    
             // Auto-Placement:
            else{
                seal_x = [];
                var o = 33.5;
                for(var i = 0; i < seal_max; i++){
                    var a = ((floor(i / 2) + 1) * (180 / (ceil(seal_max / 2) + 1))) - 90;
                    seal_x[i] = lengthdir_x(o, a)
                    seal_y[i] = 16 + (lengthdir_y(o, a) / 2);
                    o *= -1;
                }
            }
        }

         // Add Seal:
        var p = max(array_find_index(seal, noone), 0);
        seal[p] = _inst;
    }

#define Palanking_end_step
    with(seal) if(instance_exists(self) && hold){
        x = other.x + hold_x;
        y = other.y + hold_y;
        xprevious = x;
        yprevious = y;
        hspeed = other.hspeed;
        vspeed = other.vspeed;
        depth = other.depth + (0.1 * dsin(point_direction(0, 24, hold_x, hold_y)));
    }


#define Palanking_alrm0
    if(intro_pan == 0){
        alarm0 = 60;

        intro_pan = 10;
        intro_pan_x = x;
        intro_pan_y = y;

         // Call for Seals:
        if(fork()){
            wait 15;
            if(instance_exists(self)){
                sprite_index = spr_call;
                image_index = 0;
                sound_play(snd.PalankingCall);
            }
            exit;
        }

         // "Safety":
        with(Player) instance_create(x, y, PortalShock);
    }
    else{
        switch(phase){
            case 0: // Wave of Seals:
                var _groups = 5;
                if(array_length(Seal) < seal_max * _groups){
                    var _x = 10016,
                        _y = 10016;

                    scrSealSpawn(_x, _y, point_direction(_x, _y, seal_spawn_x, seal_spawn_y) + (360 / _groups), 15);
                    intro_pan_x = seal_spawn_x;
                    intro_pan_y = seal_spawn_y;

                    alarm0 = (seal_max * 8) + 10;
                }
                break;

            case 1:
                if(!active){
                    if(array_length(seal) < seal_max || array_count(seal, noone) > 0){
                         // Seal Plop:
                        //repeat(4) instance_create(other.x + x, other.y + y, Sweat);
                        sound_play_pitch(choose(sndOasisHurt, sndOasisMelee, sndOasisShoot, sndOasisChest, sndOasisCrabAttack), 0.8 + random(0.4));
                
                         // Spawn Seals:
                        var _seal = obj_create(x, y, "Seal");
                        seal_add(id, _seal);
                        with(_seal){
                            hold = true;
                            creator = other;
                            scared = true;
                        }

                        if(array_count(seal, noone) <= 0) alarm0 = 16;
                        else alarm0 = 8;
                    }
        
                     // Lift Palanking:
                    else{
                        active = true;
                        zgoal = 12;
                        alarm0 = 30;
                    }
                }
                else{
                    alarm1 = 60 + irandom(40);

                     // Boss Intro:
                    if(!intro){
                        intro = true;
                        scrBossIntro("Palanking", sndBigDogIntro, mus.SealKing);
                    }
        
                     // Walk Towards Player:
                    target = instance_nearest(x, y, Player);
                    if(instance_exists(target)){
                        scrWalk(90, point_direction(x, y, target.x, target.y));
                    }
                }
                break;
        }
    }

     // Pan Camera:
    intro_pan += alarm0;

#define Palanking_alrm1
    alarm1 = 40 + random(20);

    target = instance_nearest(x, y, Player);

     // Bubble Bomb Burp:
    if(ammo > 0){
        alarm1 = 4;
        with(scrEnemyShootExt(x, y - z + 2, "BubbleBomb", gunangle + orandom(10), 8 + random(4))){
            depth = other.depth - 1;
        }
        motion_add(gunangle + 180, 0.5);

         // Effects:
        sound_play_pitchvol(sndRatkingCharge, 0.4 + random(0.4), 1.4);
        repeat(irandom(2)) with(instance_create(x, y - z + 2, Bubble)){
            motion_add(other.gunangle + orandom(20), 2 + random(2));
            depth = other.depth - 1;
            image_xscale = random_range(0.7, 0.8);
            image_yscale = image_xscale;
            image_speed *= 1.5;
            gravity /= 2;
            coast_water = false;
        }

         // End:
        if(--ammo <= 0){
            alarm1 = 40 + random(20);
            sound_play_pitch(snd_hurt, 0.6);
            sprite_index = spr_hurt;
            image_index = 0;
        }
    }

     // Normal AI:
    else if(target_is_visible()){
        var _targetDir = point_direction(x, y, target.x, target.y);

         // Kingly Bash:
        if(target_in_distance(0, 80) && random(1) < 1){
            alarm1 = 60 + random(20);

            gunangle = _targetDir;
            scrWalk(20, gunangle);
            with(scrEnemyShoot(EnemySlash, gunangle, 4)){
                sprite_index = global.sprPalankingSlash;
                depth = other.depth - 1;
                damage = 0;
            }
        }

        else{
            scrWalk(60, _targetDir + orandom(30));
    
             // Call for Seals:
            if(z <= 0 || random(array_length(Seal)) < 1){
                sprite_index = spr_call;
                image_index = 0;
                sound_play(snd.PalankingCall);
                scrSealSpawn(x, y, random(360), 30);
                alarm1 = alarm3 + random(8);
            }

             // Begin Burp Attack:
            else if(random(2) < 1){
                if(target_in_distance(0, 192)){
                    gunangle = _targetDir;
                    alarm1 = 5;
                    ammo = 10;
        
                    sprite_index = spr_burp;
                    image_index = 0;
        
                    sound_play_pitchvol(sndRhinoFreakMelee, 0.5, 1);
                    sound_play_pitchvol(sndExplosion, 0.3, 0.25);
                    sound_play_pitch(sndBigGeneratorHurt, 0.4);
                    sound_play_pitch(sndRatKingVomit, 0.9);
                }
            }
        }
    }

#define Palanking_alrm2
    var m = 2;
    if(ground_smash++ < m){
        alarm2 = 5;

        view_shake_at(x, y, 40 / ground_smash);

        sound_play_pitch(sndOasisExplosion, 1.6 + random(0.4));
        sound_play_pitch(sndWallBreakBrick, 0.6 + random(0.2));

        var _dis = (ground_smash * 24);
        for(var a = 0; a < 360; a += (360 / 16)){
             // Ground Smash Slash:
            with(scrEnemyShootExt(x + lengthdir_x(_dis, a), y + 28 + lengthdir_y(_dis * 0.66, a), EnemySlash, a, 1)){
                sprite_index = global.sprGroundSlash;
                image_speed = 0.5;
                mask_index = -1;
                damage = 10;
                depth = 0;
                team = -1;
            }

             // Effects:
            if(random(4) < 1){
                var o = 16;
                with(instance_create(x + lengthdir_x(_dis + o, a), y + 32 + lengthdir_y((_dis + o) * 0.66, a), MeleeHitWall)){
                    motion_add(90 - (30 * dcos(a)), 1 + random(2));
                    image_angle = direction + 180;
                    image_speed = random_range(0.3, 0.6);
                }
            }
            repeat(irandom(2)){
                with(instance_create(x + orandom(8) + lengthdir_x(_dis, a), y + random_range(20, 32) + lengthdir_y(_dis, a), Dust)){
                    motion_add(a, random(5));
                }
            }
        }
    }
    else ground_smash = 0;

#define Palanking_alrm3
    sound_play_pitch(choose(sndOasisHurt, sndOasisMelee, sndOasisShoot, sndOasisChest, sndOasisCrabAttack), 0.8 + random(0.4));

     // Spawn Seals:
    var _dis = 16 + random(24),
        _dir = (seal_spawn * 90) + orandom(40),
        _x = seal_spawn_x + lengthdir_x(_dis, _dir),
        _y = seal_spawn_y + lengthdir_y(_dis, _dir),
        o = obj_create(_x, _y, "Seal");

    with(o){
         // Randomize Type:
        if(name == "Seal"){
            var _pick = [];
            for(var i = 0; i < array_length(seal_chance); i++){
                if(seal_chance[i] > 0) repeat(seal_chance[i]){
                    array_push(_pick, i);
                }
            }
            type = _pick[irandom(array_length(_pick) - 1)];
    
             // Set Sprites:
            spr_idle = global.sprSealIdle[type];
            spr_walk = global.sprSealWalk[type];
            spr_hurt = global.sprSealHurt[type];
            spr_dead = global.sprSealDead[type];
            spr_spwn = global.sprSealSpwn[type];
            spr_weap = global.sprSealWeap[type];
            sprite_index = spr_spwn;
        }

         // Important Stuff:
        creator = other;
        if(other.active) kills = 0;
        array_push(mod_variable_get("area", "coast", "swimInstVisible"), id);
    }

    if(--seal_spawn > 0) alarm3 = 4 + random(4);

#define scrSealSpawn(_xstart, _ystart, _dir, _delay)
    alarm3 = _delay;
    seal_spawn = seal_max;

     // Find Spawn Location:
    seal_spawn_x = _xstart;
    seal_spawn_y = _ystart;
    var _dis = 40 + random(16);
    if(instance_exists(Floor)){
        with(instance_create(_xstart, _ystart, GameObject)){
            while(distance_to_object(Floor) < _dis + 8 || distance_to_object(prop) < 32){
                x += lengthdir_x(12, _dir);
                y += lengthdir_y(12, _dir);
            }
            other.seal_spawn_x = x;
            other.seal_spawn_y = y;
            instance_destroy();
        }
    }

#define Palanking_hurt(_hitdmg, _hitvel, _hitdir)
    nexthurt = current_frame + 6;	// I-Frames
    if(active){
        my_health -= _hitdmg;			// Damage
        motion_add(_hitdir, _hitvel);	// Knockback
        sound_play_hit(snd_hurt, 0.3);	// Sound

         // Hurt Sprite:
        if(sprite_index != spr_call && sprite_index != spr_burp){
            sprite_index = spr_hurt;
            image_index = 0;
        }
    }

     // Laugh:
    else if(sprite_index == spr_idle && point_seen_ext(x, y, 16, 16, -1)){
        sound_play(snd.PalankingTaunt);
        sprite_index = spr_taun;
        image_index = 0;

         // Sound:
        sound_play_hit(sndHitWall, 0.3);
    }

     // Effects:
    if(instance_exists(other) && instance_is(other, projectile)){
        with(instance_create(other.x, other.y, Dust)){
            coast_water = 1;
            if(y > other.y + 12) depth = other.depth - 1;
        }
        if(random(8) < other.damage) with(other){
            sound_play_hit(sndHitRock, 0.3);
            with(instance_create(x, y, Debris)){
                motion_set(_hitdir + 180 + orandom(other.force * 4), 2 + random(other.force / 2));
            }
        }
    }

#define Palanking_draw
    var h = (nexthurt > current_frame + 3 && active);

     // Palanquin Bottom:
    if(z > 4 || place_meeting(x, y, Floor)){
        if(h) d3d_set_fog(1, c_white, 0, 0);
        draw_sprite_ext(spr_bott, image_index, x, y - z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
        if(h) d3d_set_fog(0, 0, 0, 0);
    }

     // Self:
    h = (h && sprite_index != spr_hurt);
    if(h) d3d_set_fog(1, c_white, 0, 0);
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
    if(h) d3d_set_fog(0, 0, 0, 0);

#define Palanking_death
    repeat(3) pickup_drop(50, 0);

     // Boss Win Music:
    with(MusCont) alarm_set(1, 1);


#define Palm_step
    with(my_enemy){
        x = other.x;
        y = other.y - 44;
        walk = 0;
        speed = 0;
        sprite_index = spr_idle;
        if(mask_index != mskNone){
            other.my_enemy_mask = mask_index;
            mask_index = mskNone;
        }
    }

#define Palm_death
    with(my_enemy){
        y += 8;
        vspeed += 10;
        mask_index = other.my_enemy_mask;
    }

     // Leaves:
    repeat(15) with(instance_create(x + orandom(15), y - 30 + orandom(10), Feather)){
        sprite_index = sprLeaf;
        image_yscale = random_range(1, 3);
        motion_add(point_direction(other.x, other.y, x, y), 1 + random(1));
        vspeed += 2;
    }


#define Pelican_step
    enemyAlarms(2);
    enemySprites();
    enemyWalk(walkspd, maxspd);

     // Dash:
    if(dash > 0){
        motion_add(direction, dash * dash_factor);
        dash -= current_time_scale;

         // Dusty:
        instance_create(x + orandom(3), y + random(6), Dust);
        with(instance_create(x + orandom(3), y + random(6), Dust)){
            motion_add(other.direction + orandom(45), (4 + random(1)) * other.dash_factor);
        }
    }

#define Pelican_alrm0
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
            scrWalk(5, _targetDir + 180 + orandom(10));

             // Warn:
            instance_create(x, y, AssassinNotice).depth = -3;
            sound_play_pitch(sndRavenHit, 0.5 + random(0.1));
        }

         // Move Toward Target:
        else scrWalk(20 + random(10), _targetDir + orandom(10));

         // Aim Towards Target:
        gunangle = _targetDir;
        scrRight(gunangle);
    }

     // Passive Movement:
    else{
        alarm0 = 90 + random(30); // 3-4 Seconds
        scrWalk(10 + random(5), random(360));
    }

#define Pelican_alrm1
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

#define Pelican_draw
    var _charge = ((alarm1 > 0) ? alarm1 : 0),
        _angOff = sign(wepangle) * (60 * (_charge / chrg_time));

    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, wepangle - _angOff, wkick, 1, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();

#define Pelican_death
    pickup_drop(80, 0);
    pickup_drop(60, 5);

     // Hmm:
    if(place_meeting(x, y, WepPickup)){
        with(instance_nearest(x, y, WepPickup)){
            if(wep == wep_sledgehammer){
                sprite_index = other.spr_weap;

                var _dis = 16,
                    _dir = rotation;

                instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), ThrowHit).image_speed = 0.35;
            }
        }
    }


#define Seal_step
    enemyWalk((hold ? 0 : walkspd), maxspd);
    enemyAlarms(2);

     // Slide:
    if(slide > 0){
        speed += min(slide, 2) * current_time_scale;
        
        var _turn = 5 * sin(current_frame / 10) * current_time_scale;
        direction += _turn;
        gunangle += _turn;

         // Effects:
        with(instance_create(x + orandom(3), y + 6, Dust)){
            direction = other.direction;
        }

        slide -= current_time_scale;
    }

     // Type Step:
    switch(type){
        case seal_hookpole:
             // About to Stab:
            if(alarm1 > 0) wkick += 2 * current_time_scale;

             // Decrease wkick Faster:
            else if(wkick < 0){
                wkick -= (wkick / 20) * current_time_scale;
            }
            break;

        case seal_shield:
             // Shield Mode:
            if(shield){
                 // Turn:
                var t = angle_difference(gunangle, shield_ang) / 8;
                shield_ang += t;

                 // Draw Shield:
                if(t != 0 && point_seen_ext(x, y, 16, 16, -1)){
                    shield_draw = true;
                }

                 // Reflect Projectiles:
                var o = 6,
                    r = 12,
                    _x = x + lengthdir_x(o, shield_ang),
                    _y = y + lengthdir_y(o, shield_ang);

                if(collision_circle(_x, _y, r * 2, projectile, false, false)){
                    with(instances_matching_gt(instances_matching_ne(instances_matching_ne(projectile, "team", team), "typ", 0), "speed", 0)){
                        if(point_in_circle(x + hspeed, y + vspeed, _x, _y, r + (speed / 2))){
                            other.wkick = 8 + orandom(1);
                            speed += friction * 3;
    
                             // Knockback:
                            if(force > 3){
                                with(other) motion_add(shield_ang + 180, min(other.damage / 3, 3));
                            }
    
                             // Reflect:
                            var _reflectLine = other.shield_ang;
                            direction = _reflectLine - clamp(angle_difference(direction + 180, _reflectLine), -40, 40);
                            image_angle = direction;
    
                             // Effects:
                            sound_play(sndShielderDeflect);
                            with(instance_create(x, y, Deflect)) image_angle = _reflectLine;
                            instance_create(x, y, Dust);
    
                             // Destroyables:
                            if(typ == 2) instance_destroy();
                        }
                    }
                }
            }

             // Sword Stabby Mode:
            else{
                if(wepangle == 0) wepangle = choose(-120, 120);
                shield_ang = 90;
            }

             // Draw 3D Shield to Surface:
            if(shield_draw){
                shield_draw = false;

                var _shielding = shield,
                    _spr = global.sprClamShield,
                    _dis = 10 + (_shielding ? wkick : 0),
                    _dir = shield_ang,
                    _surfw = surfClamShieldW,
                    _surfh = surfClamShieldH,
                    _surfx = surfClamShieldX,
                    _surfy = surfClamShieldY;
        
                if(!surface_exists(surfClamShield)) surfClamShield = surface_create(_surfw, _surfh);
                surface_set_target(surfClamShield);
                draw_clear_alpha(0, 0);
        
                var n = sprite_get_number(_spr) - 1,
                    _dx = x - _surfx + lengthdir_x(_dis, _dir),
                    _dy = y - _surfy + lengthdir_y(_dis, _dir);

                for(var i = 0; i <= n; i++){
                    var _ox = 0,
                        _oy = -i;

                    if(_shielding){
                        _oy *= 3/4;
                        var o = 2 * (1 - sqr((i - 4) / (n / 2)));
                        _ox += lengthdir_x(o, _dir);
                        _oy += lengthdir_y(o, _dir);
                    }

                    draw_sprite_ext(_spr, i, _dx + _ox, _dy + _oy, 1, (_shielding ? 1.5 : 1), _dir - 90, image_blend, image_alpha);
                }
        
                surface_reset_target();
            }
            break;

        case seal_blunderbuss:
             // Powder Smoke:
            if(alarm1 > 0 && current_frame_active){
                sound_play(asset_get_index(`sndFootPlaSand${1 + irandom(5)}`));
                with(instance_create(x, y, Smoke)){
                    motion_set(other.gunangle + (other.right * 120) + orandom(20), 1 + random(1));
                    image_xscale /= 2;
                    image_yscale = image_xscale;
                    growspeed -= 0.01;
                    depth = other.depth + (dsin(other.gunangle) * 0.1);
                }
            }
            break;

        default:
            if(walk > 0) direction += orandom(10);
    }

     // Animate:
    if(sprite_index != spr_spwn){
        image_index += random(0.1) * current_time_scale;
        enemySprites();
    }
    else{
        if(anim_end) sprite_index = spr_idle;
        if(image_index < 2) y -= image_index * current_time_scale;
    }

#macro seal_none 0
#macro seal_hookpole 1
#macro seal_shield 2
#macro seal_blunderbuss 3
#macro seal_chance [0, 6, 3, 4]

#macro surfClamShieldW 100
#macro surfClamShieldH 100
#macro surfClamShieldX x - (surfClamShieldW / 2)
#macro surfClamShieldY y - (surfClamShieldH / 2)

#define Seal_alrm0
    alarm0 = 30 + random(30);

    trident_dist = 0;

    target = instance_nearest(x, y, Player);
    if(target_is_visible()){
        var _targetDir = point_direction(x, y, target.x, target.y);

         // Seal Types:
        switch(type){
            case seal_hookpole:
                alarm0 = 10 + random(15);
        
                 // Too Close:
                if(target_in_distance(0, 20)){
                    scrWalk(10, _targetDir + 180 + orandom(60));
                }

                else{
                    if(random(5) < 4){
                         // Attack:
                        if(target_in_distance(0, 70)){
                            alarm0 = 30;
                            alarm1 = 10;
                            trident_dist = point_distance(x, y, target.x, target.y) - 24;
                        }

                         // Too Far:
                        else{
                            scrWalk(10, _targetDir + orandom(20));
                            if(random(10) < 1) slide = 10;
                        }
                    }

                     // Side Step:
                    else{
                        scrWalk(15, _targetDir + choose(-80, 80));
                        if(random(2) < 1) slide = 5 + random(10);
                    }
                }
                break;

            case seal_shield:
                if(shield){
                    alarm0 = 15 + random(5);
                    if(target_in_distance(0, 80) && wkick == 0){
                        scrWalk(4 + random(4), _targetDir + orandom(10));
    
                         // Dagger Time:
                        shield = false;
                        shield_draw = true;
                        alarm0 = 20;
    
                         // Swap FX:
                        var o = 8;
                        instance_create(x + lengthdir_x(o, gunangle), y + lengthdir_y(o, gunangle), WepSwap);
                        sound_play(sndSwapSword);
                    }
                    else if(random(3) < 2){
                        scrWalk(6 + random(6), _targetDir + orandom(50));
                    }
                }

                 // Sword Stabby Mode:
                else{
                    alarm0 = 20 + random(10);
                    if(target_in_distance(0, 120)){
                        scrWalk(5 + random(5), _targetDir + choose(0, 0, 180) + orandom(20));
    
                        if(target_in_distance(0, 80)){
                             // Stabby:
                            gunangle = _targetDir;
                            with(scrEnemyShoot(Shank, gunangle, 3)) damage = 2;

                            motion_add(gunangle, 2);
    
                             // Effects:
                            wkick = -5;
                            wepangle *= -1;
                            sound_play(sndMeleeFlip);
                            sound_play(sndScrewdriver);
                            sound_play_pitchvol(sndSwapGold, 1.25 + random(0.5), 0.4);
                            instance_create(x, y, Dust);
                        }
    
                         // Slide Away:
                        else{
                            direction = _targetDir + 180;
                            slide = 10;
                        }
                    }
                    else{
                        shield = true;
                        shield_ang = _targetDir;
                        shield_draw = true;
                        wkick = 2;
    
                         // Swap FX:
                        var o = 8;
                        instance_create(x + lengthdir_x(o, gunangle), y + lengthdir_y(o, gunangle), WepSwap);
                        sound_play(sndSwapHammer);
                    }
                }
                break;

            case seal_blunderbuss:
                 // Slide Away:
                if(target_in_distance(0, 80)){
                    direction = _targetDir + 180;
                    slide = 15;
                    alarm0 = slide + random(10);
                }
                
                 // Good Distance Away:
                else{
                     // Aim & Ignite Powder:
                    if(target_in_distance(0, 192) && random(3) < 2){
                        alarm0 = alarm1 + 90;

                        gunangle = _targetDir;
                        alarm1 = 15;
                        
                         // Effects:
                        sound_play_pitchvol(sndEmpty, 2.5, 0.5);
                        wkick = -2;
                    }

                     // Reposition:
                    else{
                        scrWalk(10, _targetDir + orandom(90));
                        if(random(2) < 1) slide = 15;
                    }

                     // Important:
                    if(random(3) < 1){
                        instance_create(x, y, CaveSparkle).depth = depth - 1;
                    }
                }
            	break;

            default:
                if(instance_exists(creator) && creator.active){
                    scrWalk(10 + random(10), point_direction(x, y, creator.x, creator.y));
                }
                else{
                     // Don't kill me!
                    if(scared){
                        if(point_distance(x, y, target.x, target.y) < 120 || random(array_length(instances_named(object_index, name))) < 2){
                            scrWalk(20 + random(10), _targetDir + 180 + orandom(50));
                            if(random(3) < 1) slide = walk - 5;
                            alarm0 = walk;
                        }
                        else{
                            scrWalk(5 + random(5), random(360));
                            scrRight(_targetDir);
                        }
                    }

                     // Passive:
                    else{
                        scrWalk(5 + random(5), point_direction(x, y, xstart + orandom(24), ystart + orandom(24)));
                        if(target_in_distance(0, 120)) scrRight(_targetDir);
                    }
                }
        }

         // Face Target:
        if(type != seal_none){
            gunangle = _targetDir;
            scrRight(gunangle);
        }

         // Slide FX:
        if(slide > 0){
            if(hold) slide = 0;
            else{
                sound_play_hit(sndRoll, 0.4);
                sound_play_pitch(sndBouncerBounce, 0.4 + random(0.1));
                repeat(5) with(instance_create(x, y, Dust)){
                    motion_add(random(360), 3);
                }
            }
        }
    }

     // Passive Movement:
    else{
        scrWalk(5 + random(20), random(360));
        alarm0 += walk;
    }

#define Seal_alrm1
    switch(type){
        case seal_hookpole:
             // Hookpole Stabby:
            var _dis = 24 + trident_dist,
                _dir = gunangle;
        
            with(scrEnemyShootExt(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Shank, _dir + 180, 2)){
                damage = 3;
                image_angle = _dir;
                image_xscale = 0.5;
                depth = -3;
                force = 12;
            }
        
             // Effects:
            sound_play(sndMeleeFlip);
            sound_play(sndJackHammer);
            sound_play(sndScrewdriver);
            repeat(5) with(instance_create(x, y, Dust)){
                motion_add(other.gunangle + orandom(30), random(5));
            }
        
             // Forward Push:
            x += lengthdir_x(4, gunangle);
            y += lengthdir_y(4, gunangle);
            wkick = -trident_dist;
        
             // Walk Backwards:
            var g = gunangle;
            scrWalk(6 + random(4), gunangle + 180 + orandom(20));
            gunangle = g;
            scrRight(g);

            break;

        case seal_blunderbuss:
             // Blammo:
        	repeat(6){
        	    scrEnemyShoot(EnemyBullet1, gunangle + orandom(6), 6 + random(2));
        	}

             // Effects:
            for(var i = 0; i < 6; i++){
                with(instance_create(x, y, Dust)){
                    motion_add(random(360), 3);
                }
                with(instance_create(x, y + 1, Dust)){
                    motion_add(other.gunangle + orandom(6), 2 + i);
                }
            }
        	sound_play_pitchvol(sndDoubleShotgun, 1.5, 0.8);
        	motion_add(other.gunangle + 180, 4);
        	wkick = 10;

            break;
    }

#define Seal_hurt(_hitdmg, _hitvel, _hitdir)
    enemyHurt(_hitdmg, _hitvel, _hitdir);

     // Alert:
    if(type == seal_none){
        with(instances_named(object_index, name)){
            if(!scared && type == other.type){
                if(point_distance(x, y, other.x, other.y) < 80){
                    scared = true;
                    instance_create(x, y, AssassinNotice);
                }
            }
        }
    }

#define Seal_draw
    var _drawWep = (sprite_index != spr_spwn || image_index > 2);

     // Sliding Visuals:
    if(slide > 0){
        var _lastAng = image_angle,
            _lastY = y;

        image_angle = direction - 90;
        y += 2;
    }

     // Item on Back:
    if(type == seal_shield && _drawWep){
         // Back Dagger:
        if(shield){
            draw_sprite_ext(spr_weap, 0, x + 2 - (8 * right), y - 16, 1, 1, 270 + (right * 25), c_white, image_alpha);
        }

         // Back Shield:
        else if(surface_exists(surfClamShield)){
            var _surfx = surfClamShieldX,
                _surfy = surfClamShieldY + 16;
        
            d3d_set_fog(1, c_black, 0, 0);
            for(var a = 0; a < 360; a += 90){
                draw_surface(surfClamShield, _surfx + lengthdir_x(1, a), _surfy + lengthdir_y(1, a));
            }
            d3d_set_fog(0, 0, 0, 0);
            draw_surface(surfClamShield, _surfx, _surfy);
        }
    }

     // Self Behind:
    if(gunangle >  180) draw_self_enemy();

    if(_drawWep){
         // 3D Shield + Auto-Outline:
        if(type == seal_shield && shield){
            if(surface_exists(surfClamShield)){
                var _surfx = surfClamShieldX,
                    _surfy = surfClamShieldY + 5;
        
                d3d_set_fog(1, c_black, 0, 0);
                for(var a = 0; a < 360; a += 90){
                    draw_surface(surfClamShield, _surfx + lengthdir_x(1, a), _surfy + lengthdir_y(1, a));
                }
                d3d_set_fog(0, 0, 0, 0);
        
                draw_surface(surfClamShield, _surfx, _surfy);
            }
        }

         // Weapon:
        else draw_weapon(spr_weap, x, y, gunangle, wepangle, wkick, ((wepangle == 0) ? right : sign(wepangle)), image_blend, image_alpha);
    }

     // Self:
    if(gunangle <= 180) draw_self_enemy();

     // Reset Vars:
    if(slide > 0){
        image_angle = _lastAng;
        y = _lastY;
    }

#define Seal_death
    pickup_drop(60, 0);


#define SealAnchor_step
    if(instance_exists(creator)){
        x = creator.x;
        y = creator.y;
        with(creator){
            x += other.hspeed / 20;
            y += other.vspeed / 20;
        }
    }
    else{
        if(friction <= 0){
            sound_play_pitch(sndSwapSword, 2.4);
            friction = 0.6;
            speed /= 3;
            typ = 1;
        }

         // Explode:
        if(speed < 1){
            var o = 8;
            obj_create(x + lengthdir_x(o, image_angle), y + lengthdir_y(o, image_angle), "BubbleExplosion");
            sound_play_pitchvol(sndWallBreakBrick, 1.2 + random(0.1), 0.7);
            sound_play_pitchvol(sndSwapHammer, 1.3, 0.6);
            instance_destroy();
        }
    }

#define SealAnchor_end_step
     // Effects:
    var _dis = [2, sprite_width - 2],
        _dir = direction;

    for(var i = 0; i < array_length(_dis); i++){
        var _x = x + lengthdir_x(_dis[i], _dir),
            _y = y + lengthdir_y(_dis[i], _dir);

        with(instance_create(_x, _y, BoltTrail)){
            image_angle = point_direction(x, y, other.last_x[i], other.last_y[i]);
            image_xscale = point_distance(x, y, other.last_x[i], other.last_y[i]);
            image_yscale = 0.6;
        }

        last_x[i] = _x;
        last_y[i] = _y;
    }

#define SealAnchor_draw
    if(instance_exists(creator)){
        draw_set_color(c_black);
        draw_line(x, y, creator.x, creator.y);
    }
    draw_self();

#define SealAnchor_hit
    if(projectile_canhit_melee(other)){
        projectile_hit_push(other, damage, force);
    }

#define SealAnchor_projectile
    if(team != other.team){
        with(other){
            if(typ == 1){
                direction = other.image_angle;
                image_angle = direction;
            }
            else if(typ == 2) instance_destroy()
        }
    }


#define SealHeavy_step
    enemyWalk(walkspd, maxspd);
    enemyAlarms(1);

     // Animate:
    if(sprite_index != spr_spwn) enemySprites();
    else{
        if(anim_end) sprite_index = spr_idle;
        if(image_index < 2) y -= image_index * current_time_scale;
    }

     // Anchor Flail:
    if(anchor_spin != 0){
        gunangle += anchor_spin + current_time_scale;
        gunangle = ((gunangle + 360) mod 360);
        speed = max(speed, 1.5);

         // Spinning Anchor:
        var _ang = gunangle;
        scrRight(_ang);

        if(instance_exists(anchor)){
            sprite_index = spr_walk;
            with(anchor){
                direction = _ang;
                image_angle = direction;
            }

             // Throw Out Anchor:
            if(anchor_throw > 0){
                anchor.speed += anchor_throw * current_time_scale;
                anchor_throw -= current_time_scale;
            }

             // Retract Anchor:
            if(anchor_retract){
                anchor.speed -= 0.5 * current_time_scale;
                if(anchor.speed <= 0){
                    with(anchor) instance_destroy();
                    anchor = noone;
                }
            }
        }

        else{
            if(alarm0 < 20) sprite_index = spr_chrg;

             // Stop Spinning:
            if(anchor_retract){
                anchor_spin *= 0.8;
                if(abs(anchor_spin) < 1){
                    anchor_spin = 0;
                    anchor_throw = 0;
                    anchor_retract = false;
                }
            }

             // Build Up Speed:
            else{
                anchor_spin += sign(anchor_spin) * 0.4 * current_time_scale;
                var c = 20;
                anchor_spin = clamp(anchor_spin, -c, c);
            }
        }

         // Effects:
        if(current_frame_active){
            with(instance_create(x, y, Dust)){
                motion_add(_ang, 2);
            }

             // Swoop Sounds:
            if(((_ang + 360) mod 360) < abs(anchor_spin)){
                var _snd = 1.5;
                if(instance_exists(anchor)) _snd = 8;
                sound_play_pitchvol(sndMeleeFlip, 0.1 + random(0.1), _snd);
            }
        }
    }

    else{
         // Unequip Anchor:
        if(anchor_swap){
            anchor_swap = false;
            sound_play(sndMeleeFlip);
            instance_create(x, y, WepSwap);
        }

         // Spin Mine:
        if(instance_exists(my_mine)){
             // Turn Gradually:
            if(my_mine_spin == 0){
                my_mine_ang += angle_difference(gunangle, my_mine_ang) / 5;
            }

             // Spinny Momentum:
            else{
                my_mine_ang += my_mine_spin * current_time_scale;
                my_mine_ang = ((my_mine_ang + 360) mod 360);
                scrRight(my_mine_ang);
    
                my_mine_spin += 1.5 * sign(my_mine_spin) * current_time_scale;
    
                 // Animate:
                sprite_index = spr_chrg;
            }
    
             // Holding:
            with(my_mine){
                var _dis = 16,
                    _dir = other.my_mine_ang;
    
                x = other.x + lengthdir_x(_dis, _dir);
                y = other.y + lengthdir_y(_dis, _dir);
    
                if(other.my_mine_spin != 0){
                    image_angle += other.my_mine_spin / 3;
    
                     // Starting to Toss:
                    if(other.alarm0 < 5){
                        z = sqr(5 - other.alarm0);
                        zspeed = 0;
                    }
    
                     // FX:
                    if(current_frame_active){
                        instance_create(x, y, Dust);
                    }
                }
            }
        }
    
         // Pick Up Mines:
        else{
            my_mine = noone;
            if(place_meeting(x, y, CustomHitme)){
                with(instances_named(CustomHitme, "SealMine")){
                    if(place_meeting(x, y, other)){
                        with(other){
                            alarm0 = 20;
                            my_mine = other;
                            my_mine_ang = point_direction(x, y, other.x, other.y);
                            scrRight(my_mine_ang);
                        }
                        creator = other;
                        hitid = other.hitid;
    
                         // Effects:
                        sound_play_pitchvol(sndSwapHammer, 0.6 + orandom(0.1), 0.8);
                        for(var a = direction; a < direction + 360; a += (360 / 20)){
                            with(instance_create(x, y, Dust)){
                                motion_add(a, 4);
                            }
                        }

                        break;
                    }
                }
            }
        }
    }

#define SealHeavy_alrm0
    alarm0 = 90 + random(30);
    
    target = instance_nearest(x, y, Player);

     // Lob Mine:
    if(my_mine != noone && my_mine_spin != 0){
        sprite_index = spr_idle;
        with(my_mine){
            zspeed = 10;
            direction = point_direction(x, y, other.target_x, other.target_y);
            speed = ((point_distance(x, y, other.target_x, other.target_y) - z) * zfric) / (zspeed * 2);
        }
        my_mine = noone;
        my_mine_spin = 0;

        scrWalk(5, gunangle);

         // Effects:
        sound_play_pitch(sndAssassinGetUp, 0.5 + orandom(0.2));
        sound_play_pitchvol(sndAssassinAttack, 0.8 + orandom(0.1), 0.8);
    }

    else{
         // Spinning Anchor:
        if(anchor_spin != 0){
             // Throw Out Anchor:
            if(!instance_exists(anchor)){
                alarm0 = 60;
                anchor = scrEnemyShoot("SealAnchor", gunangle, 0);
                anchor_throw = 8;
                if(instance_exists(target)) direction = point_direction(x, y, target.x, target.y);

                 // Effects:
                sound_play_pitch(sndHammer, 0.8 + orandom(0.1));
                repeat(5) with(instance_create(x, y, Dust)){
                    motion_add(other.gunangle, 4);
                }
            }

             // Retract Anchor:
            else{
                alarm0 = 120 + random(30);
                anchor_retract = true;
            }
        }

        else if(target_is_visible()){
            var _targetDir = point_direction(x, y, target.x, target.y);

            target_x = target.x;
            target_y = target.y;
    
             // Not Holding Mine:
            if(my_mine == noone){
                 // Pick Up Mine:
                if(distance_to_object(Floor) > 24 && random(4) < 3){
                    alarm0 = 20;
                    gunangle = _targetDir;
                    my_mine = obj_create(x, y, "SealMine");
                    my_mine_ang = gunangle;
                    with(my_mine){
                        zspeed = 5;
                        creator = other;
                        hitid = other.hitid;
                    }
                }
    
                 // On Land:
                else{
                     // Start Spinning Anchor:
                    if((target_in_distance(0, 180) && random(4) < 3) || target_in_distance(0, 100)){
                        alarm0 = 45;
                        gunangle = _targetDir;
                        anchor_spin = choose(-1, 1) * 5;
                        sound_play_pitch(sndRatMelee, 0.5 + orandom(0.1));

                         // Equip Anchor:
                        anchor_swap = true;
                        sound_play(sndSwapHammer);
                        instance_create(x, y, WepSwap);
                    }

                     // Walk Closer:
                    else alarm0 = 30 + random(30);
                    scrWalk(8 + random(16), _targetDir + orandom(30));
                }
            }
    
             // Holding Mine:
            else{
                if(instance_exists(my_mine)){
                    alarm0 = 20;
        
                    if(target_in_distance(0, 144)){
                         // Too Close:
                        if(target_in_distance(0, 48)){
                            scrWalk(20, _targetDir + 180);
                            gunangle = _targetDir;
                        }
        
                         // Start Toss:
                        else{
                            gunangle = _targetDir;
                            my_mine_ang = _targetDir;
                            my_mine_spin = choose(-1, 1);
        
                            sound_play_pitch(sndRatMelee, 0.5 + orandom(0.1));
                            sound_play_pitch(sndSteroidsUpg, 0.75 + orandom(0.1));
                            repeat(5) with(instance_create(target_x, target_y, Dust)){
                                motion_add(random(360), 3);
                            }
                        }
                    }
        
                     // Out of Range:
                    else scrWalk(10 + random(10), _targetDir + orandom(20));
                }
                else my_mine = noone;
            }
        }

         // Passive Movement:
        else scrWalk(5, random(360));
    }

#define SealHeavy_draw
    var _drawWep = (sprite_index != spr_spwn || image_index > 2);

     // Back Anchor:
    if(!anchor_swap && _drawWep){
        draw_sprite_ext(spr_weap, 0, x + right, y + 6, 1, 1, 90 + (right * 30), image_blend, image_alpha);
    }

    if(gunangle >  180) draw_self_enemy();

    if(anchor_swap && _drawWep && !instance_exists(anchor)){
        draw_weapon(spr_weap, x, y, gunangle, 0, wkick, 1, image_blend, image_alpha);
    }

    if(gunangle <= 180) draw_self_enemy();


#define SealMine_step
     // Animate:
    if(sprite_index != spr_hurt || anim_end){
        sprite_index = spr_idle;
    }

     // Z-Axis:
    z_engine();
    image_angle -= sign(hspeed) * (abs(vspeed / 2) + abs(hspeed));
    if(z <= 0){
        friction = 0.4;
        mask_index = mskWepPickup;
        
         // Movement:
        if(speed > 0){
            var m = 4;
            if(speed > m) speed = m;
            
             // Effects:
            if(current_frame_active && random(5) < 1){
                instance_create(x, y + 8, Dust);
                if(place_meeting(x, y, Floor)){
                    sound_play_pitchvol(asset_get_index(`sndFootPla${choose("Rock", "Sand", "Metal")}${irandom(5) + 1}`), 0.6, 0.6);
                }
            }
        }

         // Impact:
        if(zspeed < -10){
            if(distance_to_object(Floor) < 20 || place_meeting(x, y, Player)){
                my_health = 0;
            }

             // Splash FX:
            else{
                var _ang = orandom(20);
                for(var a = _ang; a < _ang + 360; a += (360 / 2)){
                    with(scrWaterStreak(x, y, a, 4)){
                        hspeed += other.hspeed / 2;
                        vspeed += other.vspeed / 2;
                    }
                }
                sound_play_pitch(sndOasisExplosionSmall, 2);
            }
        }

         // On Land:
        if(place_meeting(x, y, Floor)) friction *= 1.5;

         // Floating in Water:
        else{
            nowade = false;
            image_angle += sin(current_frame / 20) * 0.5;
        }

        zspeed = 0;
        z = 0;
    }

     // In Air:
    else{
        friction = 0;
        mask_index = mskNone;
        nowade = true;
        wading = 0;
    }

     // Push:
    if(place_meeting(x, y, hitme)){
        with(instances_matching_ne(hitme, "id", creator)) if(place_meeting(x, y, other)){
            with(other){
                motion_add(point_direction(other.x, other.y, x, y), other.size / 5);
            }
            if(!instance_is(self, prop)){
                motion_add(point_direction(other.x, other.y, x, y), other.size / 2);
            }
        }
    }

    if(my_health <= 0) instance_destroy();

#define SealMine_draw
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

#define SealMine_destroy
     // Explode:
    with(instance_create(x, y, Explosion)) hitid = other.hitid;
    sound_play(sndExplosion);

     // Shrapnel:
    for(var a = direction; a < direction + 360; a += (360 / 6)){
        with(instance_create(x, y, EnemyBullet3)){
            motion_add(a + orandom(20), 7 + random(4));
            creator = other.creator;
            hitid = other.hitid;
        }
    }
    sound_play_hit(sndFlakExplode, 0.2);


#define TrafficCrab_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);

     // Attack Sprite:
    if(ammo > 0){
        sprite_index = spr_fire;
        image_index = 0;
    }

#define TrafficCrab_alrm0
     // Spray Venom:
    if(ammo > 0){
        alarm0 = 2;
        walk = 1;

        sound_play(sndOasisCrabAttack);
        sound_play_pitchvol(sndFlyFire, 2 + random(1), 0.5);

         // Venom:
        var _x = x + (right * (4 + (sweep_dir * 10))),
            _y = y + 4;

        repeat(choose(2, 3)){
            scrEnemyShootExt(_x, _y, "TrafficCrabVenom", gunangle + orandom(10), 10 + random(2));
        }
        gunangle += (sweep_dir * sweep_spd);

         // End:
        if(--ammo <= 0){
            alarm0 = 30 + random(20);
            sprite_index = spr_idle;

             // Move Towards Player:
            var _dir = (instance_exists(target) ? point_direction(x, y, target.x, target.y) : random(360));
            scrWalk(15, _dir);

             // Switch Claws:
            sweep_dir *= -1;
        }
    }

     // Normal AI:
    else{
        alarm0 = 35 + random(15);
        target = instance_nearest(x, y, Player);

        if(target_is_visible()){
            var _targetDir = point_direction(x, y, target.x, target.y);

             // Attack:
            var _max = 128;
            if(target_in_distance(0, _max)){
                scrWalk(1, _targetDir + (sweep_dir * random(90)));

                alarm0 = 1;
                ammo = 10;
                gunangle = _targetDir - (sweep_dir * (sweep_spd * (ammo / 2)));

                sound_play_pitch(sndScorpionFireStart, 0.8);
                sound_play_pitch(sndGoldScorpionFire, 1.5);
            }

             // Move Towards Player:
            else scrWalk(30, _targetDir + (random_range(20, 40) * choose(-1, 1)));

             // Facing:
            scrRight(_targetDir);
        }

         // Passive Movement:
        else scrWalk(10, random(360));
    }

#define TrafficCrab_draw
    draw_self_enemy();

#define TrafficCrab_death
    pickup_drop(10, 10);

     // Splat:
    var _ang = random(360);
    for(var a = _ang; a < _ang + 360; a += (360 / 3)){
        with(instance_create(x, y, MeleeHitWall)){
            motion_add(a, 1);
            image_angle = direction + 180;
            image_blend = make_color_rgb(174, 58, 45);//make_color_rgb(133, 249, 26);
        }
    }


#define TrafficCrabVenom_step
    if(speed <= 0) instance_destroy();

#define TrafficCrabVenom_hit
    if(projectile_canhit_melee(other)){
        projectile_hit_push(other, damage, force);
    }

#define TrafficCrabVenom_anim
    image_speed = 0;
    image_index = image_number - 1;

#define TrafficCrabVenom_destroy
    with(instance_create(x, y, BulletHit)) sprite_index = sprScorpionBulletHit;


#define ClamChest_open(_player)
    var w = ["harpoon", "bubble rifle", "bubble shotgun"],
        _wep = "";

     // Random Cool Wep:
    var m = 0;
    do _wep = w[irandom(array_length(w) - 1)];
    until (mod_exists("weapon", _wep) || ++m > 200);

    if(mod_exists("weapon", _wep)){
        with(instance_create(x, y, WepPickup)){
            wep = _wep;
            ammo = true;
        }
    }

     // Angry puffer cause you dont have cool weapons loaded
    else with(obj_create(x, y, "Puffer")){
        instance_create(x, y, AssassinNotice);
    }


#define Hammerhead_step
    enemyAlarms(1);
    if(sprite_index != spr_chrg) enemySprites();
    enemyWalk(walkspd, maxspd);

     // Swim in a circle:
    if(rotate != 0){
        rotate -= clamp(rotate, -1, 1) * current_time_scale;
        direction += rotate;
        if(speed > 0) scrRight(direction);
    }

     // Charge:
    if(charge > 0 || charge_wait > 0){
        direction += angle_difference(charge_dir + (sin(charge / 5) * 20), direction) / 3;
        scrRight(direction);
    }
    if(charge_wait > 0){
        charge_wait -= current_time_scale;

        x += orandom(1);
        y += orandom(1);
        x -= lengthdir_x(charge_wait / 5, charge_dir);
        y -= lengthdir_y(charge_wait / 5, charge_dir);
        sprite_index = choose(spr_hurt, spr_chrg);

         // Start Charge:
        if(charge_wait <= 0){
            sound_play_pitch(sndRatkingCharge, 0.4 + random(0.2));
            view_shake_at(x, y, 15);
        }
    }
    else if(charge > 0){
        charge -= current_time_scale;

        if(sprite_index != spr_hurt) sprite_index = spr_chrg;

         // Fast Movement:
        motion_add(direction, 3);
        scrRight(direction);

         // Break Walls:
        if(place_meeting(x + hspeed, y + vspeed, Wall)){
            with(Wall) if(place_meeting(x - other.hspeed, y - other.vspeed, other)){
                 // Effects:
                if(random(2) < 1) with(instance_create(x + 8, y + 8, Hammerhead)){
                    motion_add(random(360), 1);
                }
                instance_create(x, y, Smoke);
                sound_play_pitchvol(sndHammerHeadProc, 0.75, 0.5);

                instance_create(x, y, FloorExplo);
                instance_destroy();
            }
        }

         // Effects:
        if(current_frame_active){
            with(instance_create(x + orandom(8), y + 8, Dust)){
                motion_add(random(360), 1)
            }
        }
        if !(charge mod 5) view_shake_at(x, y, 10);

         // Charge End:
        if(charge <= 0){
            sprite_index = spr_idle;
            sound_play_pitch(sndRatkingChargeEnd, 0.6);
        }
    }

#define Hammerhead_alrm0
    alarm0 = 30 + random(20);

    target = instance_nearest(x, y, Player);
    if(target_in_distance(0, 256)){
        var _targetDir = point_direction(x, y, target.x, target.y);
        if(target_is_visible()){
             // Close Range Charge:
            if(target_in_distance(0, 96) && random(3) < 2){
                charge = 15 + random(10);
                charge_wait = 15;
                charge_dir = _targetDir;
                sound_play_pitchvol(sndHammerHeadEnd, 0.6, 0.25);
            }

             // Move Towards Target:
            else{
                scrWalk(30, _targetDir + orandom(20));
                rotate = orandom(20);
            }
        }

        else{
             // Charge Through Walls:
            if(my_health < maxhealth && random(3) < 1){
                charge = 30;
                charge_wait = 15;
                charge_dir = _targetDir;
                alarm0 = charge + charge_wait + random(10);
                sound_play_pitchvol(sndHammerHeadEnd, 0.6, 0.25);
            }

             // Movement:
            else{
                rotate = orandom(30);
                scrWalk(20 + random(10), _targetDir + orandom(90));
            }
        }
    }

     // Passive Movement:
    else{
        scrWalk(30, direction);
        scrRight(direction);
        rotate = orandom(30);
        alarm0 += random(walk);
    }

    scrRight(direction);

#define Hammerhead_draw
    draw_self_enemy();


#define Puffer_step
    enemyAlarms(1);
    enemyWalk(walkspd, maxspd);

     // Animate:
    if(sprite_index != spr_fire){
        if(sprite_index != spr_chrg) enemySprites();

         // Charged:
        else if(anim_end) blow = 1;
    }

     // Puffering:
    if(blow > 0){
        blow -= 0.03 * current_time_scale;

         // Blowing:
        motion_add_ct(direction + (10 * sin(current_frame / 6)), 2);
        scrRight(direction + 180);

         // Effects:
        if(current_frame_active && random(4) < 3){
            var l = 8, d = direction + 180;
            with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), Bubble)){
                motion_add(d, 3);
            }
            sound_play_pitchvol(sndRoll, 1.2 + random(0.4), 0.6);
        }

         // Animate:
        var _sprFire = global.sprPufferFire,
            _blowLvl = clamp(floor(blow * array_length(_sprFire)), 0, array_length(_sprFire) - 1),
            _back = (direction > 180);

        spr_fire = _sprFire[_blowLvl, _back];
        sprite_index = spr_fire;
    }
    else if(sprite_index == spr_fire) sprite_index = spr_idle;

#define Puffer_alrm0
    alarm0 = 20 + random(30);
    target = instance_nearest(x, y, Player);

    if(blow <= 0){
        if(instance_exists(target)){
            var _targetDir = point_direction(x, y, target.x, target.y);

             // Puff Time:
            if(target_is_visible() && target_in_distance(0, 256) && random(2) < 1){
                alarm0 = 30;

                scrWalk(8, _targetDir);
                scrRight(direction + 180);
                sprite_index = spr_chrg;
                image_index = 0;

                 // Effects:
                repeat(3) instance_create(x, y, Dust);
                sound_play_pitch(sndOasisCrabAttack, 0.8);
                sound_play_pitchvol(sndBouncerBounce, 0.6 + orandom(0.2), 2);
            }

             // Get Closer:
            else scrWalk(alarm0, _targetDir + orandom(20));
        }

         // Passive Movement:
        else scrWalk(10, random(360));
    }

#define Puffer_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    motion_add(_hitdir, _hitvel);	// Knockback
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);  // Sound

     // Hurt Sprite:
    if(sprite_index != spr_fire && sprite_index != spr_chrg){
        sprite_index = spr_hurt;
        image_index = 0;
    }

#define Puffer_draw
    var h = (sprite_index != spr_hurt && nexthurt > current_frame + 3);
    if(h) d3d_set_fog(1, c_white, 0, 0);
    draw_self_enemy();
    if(h) d3d_set_fog(0, 0, 0, 0);

#define Puffer_death
    pickup_drop(50, 0);

     // Powerful Death:
    var _num = 3;
    if(blow > 0) _num *= ceil(blow * 4);
    if(sprite_index == spr_chrg) _num += image_index;
    if(_num > 3){
        sound_play_pitch(sndOasisExplosionSmall, 1 + random(0.2));
        sound_play_pitchvol(sndOasisExplosion, 0.8 + random(0.4), _num / 15);
    }
    while(_num-- > 0){
        with(instance_create(x, y, Bubble)){
            motion_add(random(360), _num / 2);
            hspeed += other.hspeed / 3;
            vspeed += other.vspeed / 3;
            friction *= 2;
        }
    }


#define Crack_step
    if !image_index && place_meeting(x,y,Player){
        image_index = 1;
        with instance_create(x,y,Portal){
            image_alpha = 0;
        }
        sound_stop(sndPortalOpen);
        sound_play_pitchvol(sndNothingHurtMid,0.6,0.7);
        sound_play_pitchvol(sndNothingBeamEnd,0.4,1);
        with(GameCont){
            area = "trench";
            subarea = 0;
        }
        repeat(10) instance_create(x+orandom(8),y+orandom(8),Bubble);
        repeat(10) with instance_create(x,y,Debris){
            motion_add(irandom(359),3+random(3));
        }
    }


#define Vent_step
    if random(5) < current_time_scale{
        with instance_create(x,y,Bubble){
            friction = 0.2;
            motion_set(irandom_range(85,95),random_range(4,7));
        }
        // with instance_create(x,y-8,Smoke){
        //     motion_set(irandom_range(65,115),random_range(10,100));
        // }
    }

#define Vent_death
    obj_create(x,y,"BubbleExplosion");

#define Cat_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);

#define Cat_alrm0
    alarm0 = 20 + random(20);
    
    if(ammo > 0) {
        repeat(2)
        with(scrEnemyShoot(ToxicGas, gunangle + orandom(6), 4)) {
            friction = 0.1;
        }
        gunangle += 12;
        ammo--;
        if(ammo = 0) {
            alarm0 = 40;
            repeat(3) {
                var _dir = orandom(16);
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
                scrWalk(20 + random(5), _targetDir + orandom(20));
                scrRight(gunangle);
            }
        } else {
            alarm0 = 30 + random(20); // 3-4 Seconds
            scrWalk(20 + random(10), random(360));
            scrRight(gunangle);
        }
    }
    
#define Cat_draw
    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();


#define Mortar_step
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

#define Mortar_alrm0
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
            direction = _targetDir + orandom(15);
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

#define Mortar_alrm1
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
        with(scrEnemyShootExt(x - (2 * right), y, "MortarPlasma", _targetDir, 3)){
            z += 18;
            depth = 12;
            zspeed = (point_distance(x, y - z, other.target.x, other.target.y) / 8) + orandom(1);
            right = other.right;
        }

        alarm1 = 4;
        ammo--;
    }

#define Mortar_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    motion_add(_hitdir, _hitvel);	// Knockback
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);	// Sound

     // Hurt Sprite:
    if(sprite_index != spr_fire){
        sprite_index = spr_hurt;
        image_index = 0;
    }

#define Mortar_draw
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


#define MortarPlasma_step
     // Rise & Fall:
    z_engine();
    depth = max(-z, -12);

     // Trail:
    if(random(2) < 1){
        with(instance_create(x + orandom(4), y - z + orandom(4), PlasmaTrail)) {
            sprite_index = global.sprMortarTrail;
            depth = other.depth;
        }
    }

     // Hit:
    if(z <= 0) instance_destroy();

#define MortarPlasma_destroy
    with(instance_create(x, y, PlasmaImpact)){
        sprite_index = global.sprMortarImpact;
        team = other.team;
        creator = other.creator;
        hitid = other.hitid;
        damage = 1;
    }

     // Sound:
    sound_play(sndPlasmaHit);

#define MortarPlasma_draw
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale * right, image_angle - (speed * 2) + (max(zspeed, -8) * 8), image_blend, image_alpha);

#define MortarPlasma_hit
    // nada

#define MortarPlasma_wall
    // nada


#define NewCocoon_death
     // Hatch 1-3 Spiders:
    repeat(irandom_range(1, 3)) {
    	with(instance_create(x, y, Spider)) {
    		maxhealth = round(maxhealth / 4.5);
    		my_health = maxhealth;
    		spr_shadow = shd16;
    		corpse = 0;
    		
    		image_xscale = 0.6;
    		image_yscale = image_xscale;
    	}
    }

#define CatBoss_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);
    

#define CatBoss_alrm0
    alarm0 = 20 + random(20);
    
    if(ammo > 0) {
        with(scrEnemyShoot(ToxicGas, gunangle + orandom(8), 4)) {
            friction = 0.2;
        }
        gunangle += 24;
        ammo--;
        if(ammo = 0) {
            alarm0 = 40;
            
            repeat(3) {
                var _dir = orandom(16);
                with(instance_create(x, y, AcidStreak)) {
                    motion_add(other.gunangle + _dir, 3);
                    image_angle = direction;
                }
            }
            
            target = instance_nearest(x, y, Player);
            var _targetDir = point_direction(x, y, target.x, target.y);
            
            with(scrEnemyShootExt(x - (2 * right), y, "CatGrenade", _targetDir, 3)){
                z += 12;
                depth = 12;
                zspeed = (point_distance(x, y - z, other.target.x, other.target.y) / 8) + orandom(1);
                right = other.right;
            }
            
            gunangle = _targetDir;
            wkick += 6;
            sound_play_pitch(sndEmpty, random_range(0.75, 0.9));
            sound_play_pitch(sndToxicLauncher, random_range(0.75, 0.9));
            sound_stop(sndFlamerLoop);
        } else {
            alarm0 = 1;
            wkick += 1;
        }
    } else {
        target = instance_nearest(x, y, Player);
        if(target_is_visible()) {
            var _targetDir = point_direction(x, y, target.x, target.y);
            
            if(target_in_distance(0, 140) and random(3) < 1) {
                if(random(3) < 3) {
                    scrRight(_targetDir);
                    gunangle = _targetDir - 45;
                    ammo = 20;
                    with(instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), BloodGamble)) {
                        sprite_index = global.sprAcidPuff;
                        image_angle = other.gunangle;
                    }
                    sound_play(sndToxicBoltGas);
                    sound_play(sndEmpty);
                    var s = sndFlamerLoop;
                    sound_loop(sndFlamerLoop);
                    sound_pitch(sndFlamerLoop, random_range(1.8, 1.4));
                    wkick += 4;
                    alarm0 = 4;
                }
            } else {
                alarm0 = 20 + random(20);
                scrWalk(20 + random(5), _targetDir + orandom(20));
                scrRight(gunangle);
            }
        } else {
            alarm0 = 30 + random(20); // 3-4 Seconds
            scrWalk(20 + random(10), random(360));
            scrRight(gunangle);
        }
    }
    
#define CatBoss_draw
    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();

#define CatBoss_death
sound_stop(sndFlamerLoop); // Stops infinite flamer loop until you leave
pickup_drop(100, 20);
pickup_drop(60, 0);

#define CatGrenade_step
     // Rise & Fall:
    z_engine();
    depth = max(-z, -12);

     // Trail:
    if(random(2) < 1){
        with(instance_create(x + orandom(4), y - z + orandom(4), PlasmaTrail)) {
            sprite_index = sprToxicGas;
            image_xscale = 0.25;
            image_yscale = image_xscale;
            image_angle = random(360);
            image_speed = 0.4;
            depth = other.depth;
        }
    }

     // Hit:
    if(z <= 0) instance_destroy();

#define CatGrenade_destroy
    with(instance_create(x, y, Explosion)){
        team = other.team;
        creator = other.creator;
        hitid = other.hitid;
    }
    
    repeat(18) {
        with(scrEnemyShoot(ToxicGas, random(360), 4)) {
            friction = 0.2;
        }
    }

     // Sound:
    sound_play(sndGrenade);
    sound_play(sndToxicBarrelGas);

#define CatGrenade_draw
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale * right, image_angle - (speed * 2) + (max(zspeed, -8) * 8), image_blend, image_alpha);

#define CatGrenade_hit
    // nada

#define CatGrenade_wall
    // nada

#define YetiCrab_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);
    
    

#define YetiCrab_alrm0
    alarm0 = 30 + random(10);
    target = instance_nearest(x, y, Player);

    if(is_king = 0) { // Is a follower: 
        if(instance_exists(nearest_instance(x, y, instances_matching(CustomEnemy, "is_king", 1)))) { // Track king:
            var nearest_king = nearest_instance(x, y, instances_matching(CustomEnemy, "is_king", 1)); 
            var king_dir = point_direction(x, y, nearest_king.x, nearest_king.y);
            if(point_distance(x, y, nearest_king.x, nearest_king.y) > 16 and point_distance(x, y, target.x, target.y) < point_distance(x, y, nearest_king.x, nearest_king.y)) { // Check distance from king:
                scrRight(king_dir);
                
                 // Follow king in a jittery manner:
                scrWalk(5, king_dir + orandom(5));
                alarm0 = 5 + random(5);
            }
            
             // Chase player instead:
            else if(target_is_visible()) {
                var _targetDir = point_direction(x, y, target.x, target.y);
                scrRight(_targetDir);
                
                 // Chase player:
                scrWalk(30, _targetDir + orandom(10));
                scrRight(direction);
            } else { 
                 // Crab rave:
                scrWalk(30, random(360));
                scrRight(direction);
            }
        }
         // No leader to follow:
        else if(target_is_visible()) {
            var _targetDir = point_direction(x, y, target.x, target.y);
            
             // Sad chase :( :
            if(fork()) {
                repeat(irandom_range(4, 10)) {
                    wait random_range(1, 3);
                    if(!instance_exists(other)) exit; else instance_create(x, y, Sweat); // Its tears shhh
                }
                
                exit;
            }
            scrWalk(30, _targetDir + orandom(10));
            scrRight(direction);
        } else { 
             // Crab rave:
            scrWalk(30, random(360));
            scrRight(direction);
        }
    } 
    
     // Is a leader:
    else {
        var _targetDir = point_direction(x, y, target.x, target.y);
        
         // Chase player:
        scrWalk(30, _targetDir + orandom(10));
        scrRight(direction);
    }
    
#define YetiCrab_draw
    draw_self_enemy();

#define Jellyfish_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);
    
    if(place_meeting(x + hspeed, y + vspeed, Wall)) {
        move_bounce_solid(false);
    }
    
#define Jellyfish_alrm0
    alarm0 = 30 + random(10);
    walk = alarm0; // Always on the move
    target = instance_nearest(x, y, Player);

#define Jellyfish_draw
    draw_self_enemy();

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

#define enemySprites
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

#define scrDefaultDrop
    pickup_drop(16, 0); // Bandit drop-ness

#define z_engine
    z += zspeed * current_time_scale;
    zspeed -= zfric * current_time_scale;

#define chance_frame(_percent)
    return random(100) <= _percent * current_time_scale;

#define instances_named(_object, _name)
    return instances_matching(_object, "name", _name);


#define draw_bloom
    draw_set_blend_mode(bm_add);
    with(instances_named(CustomProjectile, "MortarPlasma")){
        draw_sprite_ext(sprite_index, image_index, x, y - z, 2 * image_xscale, 2 * image_yscale * right, image_angle - (speed * 2) + (max(zspeed, -8) * 8), image_blend, 0.1 * image_alpha);
    }
    with(instances_named(CustomProjectile, "TrafficCrabVenom")){
        draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.2 * image_alpha);
    }
    with(instances_named(CustomProjectile, "BubbleBomb")){
        //draw_sprite_ext(sprite_index, image_index, x, y - z, 1.5 * image_xscale, 1.5 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
    }
    draw_set_blend_mode(bm_normal);

#define draw_shadows
    with(instances_named(CustomProjectile, ["MortarPlasma", "CatGrenade"])) if(visible){
        draw_sprite(shd24, 0, x, y);
    }


#define step
     // Harpoon Connections:
    for(var i = 0; i < array_length(global.poonRope); i++){
        var _rope = global.poonRope[i],
            _link1 = _rope.link1,
            _link2 = _rope.link2;

        if(instance_exists(_link1) && instance_exists(_link2)){
            var _length = _rope.length,
                _linkDis = point_distance(_link1.x, _link1.y, _link2.x, _link2.y) - _length,
                _linkDir = point_direction(_link1.x, _link1.y, _link2.x, _link2.y);

             // Pull Link:
            if(_linkDis > 0) with([_link1, _link2]){
                if("name" in self && name == "Harpoon"){
                    if(canmove) with(target){
                        var _pull = other.pull_speed,
                            _drag = min(_linkDis / 3, 10 / (("size" in self) ? (size * 2) : 2));

                        hspeed += lengthdir_x(_pull, _linkDir);
                        vspeed += lengthdir_y(_pull, _linkDir);
                        x += lengthdir_x(_drag, _linkDir);
                        y += lengthdir_y(_drag, _linkDir);
                    }
                }
                _linkDir += 180;
            }

             // Deteriorate Rope:
            var _deteriorate = (_rope.deteriorate_timer == 0);
            if(_deteriorate) _rope.length *= 0.9;
            else if(_rope.deteriorate_timer > 0){
                _rope.deteriorate_timer -= min(1, _rope.deteriorate_timer);
            }

             // Rope Stretching:
            with(_rope){
                break_force = max(_linkDis, 0);

                 // Break:
                if(break_timer > 0) break_timer -= current_time_scale;
                else if(break_force > 100 || (_deteriorate && _length <= 1)){
                    if(_deteriorate) with([_link1, _link2]) image_index = 1;
                    else sound_play_pitch(sndHammerHeadEnd, 2);
                    scrHarpoonUnrope(_rope);
                }
            }

             // Draw Rope:
            script_bind_draw(draw_rope, 0, _rope);
        }
        else scrHarpoonUnrope(_rope);
    }
    
    with(Player) {
        if(button_pressed(index, "horn")) {
            with(obj_create(mouse_x[index], mouse_y[index], "YetiCrab")) {
                spr_idle = global.sprKingCrabIdle;
                spr_walk = global.sprKingCrabIdle;
                spr_hurt = global.sprKingCrabIdle;
                spr_dead = global.sprKingCrabIdle;
                
                maxspd = 3.5;
                is_king = 1;
            }
            
            repeat(irandom_range(2, 4)) {
                obj_create(mouse_x[index], mouse_y[index], "YetiCrab");
            }
        }
    }

#define draw_rope(_rope)
    with(_rope) if(instance_exists(link1) && instance_exists(link2)){
        var _x1 = link1.x,
            _y1 = link1.y,
            _x2 = link2.x,
            _y2 = link2.y,
            _wid = clamp(length / point_distance(_x1, _y1, _x2, _y2), 0.1, 2),
            _col = merge_color(c_white, c_red, (0.25 + clamp(0.5 - (break_timer / 45), 0, 0.5)) * clamp(break_force / 100, 0, 1));

        draw_set_color(_col);
        draw_line_width(_x1, _y1, _x2, _y2, _wid);
    }
    instance_destroy();

#define scrHarpoonStick(_instance) /// Called from Harpoon
    speed = 0;
    target = _instance;

     // Set Rope Vars:
    pull_speed = (("size" in target) ? (2 / target.size) : 2);
    with(rope){
        harpoon_stuck = 1;

         // Deteriorate rope if only stuck in unmovable objects:
        var m = 1;
        with([link1, link2]) if("canmove" not in self || canmove) m = 0;
        if(m){
            deteriorate_timer = 60;
            length = point_distance(link1.x, link1.y, link2.x, link2.y);
        }
    }

#define scrHarpoonRope(_link1, _link2)
    var r = {
        link1 : _link1,
        link2 : _link2,
        length : 0,
        harpoon_stuck : 0,
        break_force : 0,
        break_timer : 90,
        creator : noone,
        deteriorate_timer : -1,
        broken : 0
    }
    global.poonRope[array_length(global.poonRope)] = r;
    with([_link1, _link2]) rope[array_length(rope)] = r;

    return r;

#define scrHarpoonUnrope(_rope)
    with(_rope){
        broken = 1;

        var i = 0,
            a = [],
            _ropeIndex = array_find_index(global.poonRope, self);
    
        for(var j = 0; j < array_length(global.poonRope); j++){
            if(j != _ropeIndex) a[i++] = global.poonRope[j];
        }
    
        global.poonRope = a;
    }

#define array_flip(_array)
    var a = array_clone(_array),
        m = array_length(_array);

    for(var i = 0; i < m; i++){
        _array[@i] = a[(m - 1) - i];
    }

#define scrBossHP(_hp)
    var n = 0;
    for(var i = 0; i < maxp; i++) n += player_is_active(i);
    return round(_hp * (1 + ((1/3) * GameCont.loops)) * (1 + (0.5 * (n - 1))));

#define scrBossIntro(_name, _sound, _music)
    mod_script_call("mod", "ntte", "scrBossIntro", _name, _sound, _music);

#define scrWaterStreak(_x, _y, _dir, _spd)
    return mod_script_call("area", "coast", "scrWaterStreak", _x, _y, _dir, _spd);

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

#define nearest_instance(_x, _y, _instances)
	var	_nearest = noone,
		d = 1000000;

	with(_instances){
		var _dis = point_distance(_x, _y, x, y);
		if(_dis < d){
			_nearest = id;
			d = _dis;
		}
	}

	return _nearest;

#define frame_active(_interval)
    return ((current_frame mod _interval) < current_time_scale);
    
#define draw_dark
    //draw_set_blend_mode_ext(11,4); // blend mode for color on darkness, thanks jsburg
    draw_set_color(c_gray);
    with instances_matching(CustomProp,"name","Kelp"){
        draw_circle(x,y,32+orandom(1),0);
    }
    draw_set_color(c_white);