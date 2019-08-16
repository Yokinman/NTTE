#define init
    global.sprBabyIdle = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAGAAAAAYCAYAAAAF6fiUAAAABmJLR0QAAAAAAAD5Q7t/AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4gUcDh44s6rdNQAAAexJREFUaN7tmD1uwkAQhd+iVWqiWBTcwBKdU4YOKT4EuYU7pwwdtyCHgNoUFHEXyTdwgYxwTSxNCsd/McZ/u0FJ9kk0u/a39rzZ8SyAkpKSkpKSkpKSktJ/E+twD/W8/6+rVXwGLcG0342BtdSHz/9kryGc2zY+g6Zgb6nBsDkO2xMAwLA5BL4EASDD5pBosKwE6hWfui1Chs3hTqPzs6aQMkRYA967hvkxxOvtEPokgOFwuItIDB+At5TCp69An49Rg/iwJsGBCRAR2IYV4EQExlifl5DOl5xAdGk3NTF5UFcSUqdYmXFurGUdlsVP5U6j2MxHKgWfiPqU0Sw+Ffy3l49aCK+a8JYa7h5uMAp9pNsMEfbDcXzBDhiFfpJFrSWZT0kddhFlZq6FJlCZ1YF/6QpazYAnqzi4H46xefZxb2rQJ0GfbSyTTwWDnaxOpwajYPDV+LxuAYR+YeKwPeHe1Hp3DpL5TLcCWs0AWOUPZGIwJtfnV5Yg3Qri0jAtjs+PoZDeTTL/1yQQv1Sa3EWUfuUNJ+4m8m4bTlZjO5zAqdQxiOOXDE74IhMIAL7Hpy2fN+4mFsVA5Dukrts4b7BgfimBCl2RmAQqf4xNpDzD5o349eeAJgv3OQf8LF/kf2JVfCbw+ZWUlJRk6hPy8zg/RZIATAAAAABJRU5ErkJggg==", 4, 12, 12);
    global.sprBabyWalk = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAJAAAAAYCAYAAAAVpXQNAAAABmJLR0QAAAAAAAD5Q7t/AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4gUcDh8F8tmgZQAAAr1JREFUaN7tmD+O00AYxd+sRtRBWClyA0vpjAQF7pAwBTfIMdKZdjsX3AFuQIG3DkWadCv5Bikso3WNLH0U9vhPPInXnpmYwDwpcrQrfTPze/M+zwSwsrKysrKysrKysrKy+s+V7ldAbDn8s2xMLSKJHHghBwBqfSybik1V92bZGDPYC3kHTrpfEWJzkEyYbMpgL+Qd5rfI5hoGEwBKIoe8kFMSOYQY5IVcKygTAbiCwTUbxM0TABHR7AFgIxaBJHKwecrx7eUC7jqDt+M43Bdj6khreyHHwS/k/w2gWh91/aBcR7pfYZkftdRus3HXGZLH8okAICLGmFJ5qjannI8mNgBwuC8msWFzGpxEDtxtRoghgIM9sE5tIkJlAtNhsuYAGDNYsGlt/h4f+qCXzZQA3A22NQEnKCd8Cqhqo1N6KQlA9W6WTFYxwY3JMeCuMxz8ogR0zvQxLb/SOT462chY6GLjhbxmIp6IAcbY4Nzv5jQ4iRz8+LQ8PUsgXazKj+KBzmAAjBvcZnORz8wB4EODvHr3Asv82LwrUSBdVBPfo/2+HCvmbjP6+h7Att8NHj4f8TpwgPX0dLnbrDz/oGgMjfUEQLD5+D3tniVO+bw9qrF5I39F1nwU2fRYxOPY8DkNFiYg70L+9fO3CpxrBMC4wWLuX6oNCqA8s/mFFj66AsDnNLhOgd/9++Yp70JD8bd1OOMGyzrEwS/g7Tg2yFXRawsAGzqdy25g3u5kYdNuMr3bnTBANs6EMajdgTrpe2zAiBvH2Nqd1J6ZswKbi7c8MYZCbWp3IFFb8O/w2WYXx2CDoGIMGqyykLp+MPg7xWSTDQVAanCbka7fyepvfVZMpaaOADBVgxUX0gbEBgFO6HKGA3D2lqKw8Z87lo6a0gCMCRa78oTn0HOv6MzQmOyG+dyq51ZWVlZWVkP6AyN1NyA777poAAAAAElFTkSuQmCC", 6, 12, 12);
    global.sprBabyHurt = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAEgAAAAYCAYAAABZY7uwAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAACxIAAAsSAdLdfvwAAAAHdElNRQfiBRwOHi8weVjyAAAAGXRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4wLjE3M26fYwAAAVJJREFUWEftlMttwzAMhnXICDllgtybEbpVFuihW2SJjNANukOXYPiQFFaWgZgyARvhRxC2lOjnQ5ZSEARBELwPAFA9UOjGeDbo7+eU0j0PHHDT//0+po/rgV6pM8VXY7f6LCodZ1GAC34+6wVo9XGHAce70SdYDODMjSlPtnWCsA7uMGAx/KQC6D3/Noqr/rMZPRsPIInSjvZ8y/p0ZpHaCCKPxETcHKTq50RZf5r8ZvVlYduMntkCyLo2WVUA7fzAMfDWl7umXsjKaK44z9gC8F1QLsyaLL7TXHEuZpv6DMAXLm6Mm4Pz9bK2B4DbJ66lJJVT4jRPBQ4W4KrPDeh/QTQvzjO2AP92WDvNFx8owFs/L3zVlgeRNSrxcgTKcdDj/P8leOtXdBvmzR6gW4QeDxYw0WvHg/pM24g5t/JMeqqp3Yq3PrOa0Ax71w+CwEJKD4GhfQGUB08sAAAAAElFTkSuQmCC", 3, 12, 12);
    
    /*
    ADDING A PET:
        Adding a pet is simple. Just create a mod file and paste in the "pet_create(x, y, name)" script.
        Once you've created your file, just pick a name for your pet and create scripts like the examples below.
        
    SPAWNING A PET:
        Spawning a pet is also simple. All the setup required is handled by
        pet_create in telib.mod.gml (case sensitive), so just call the script with 
        the proper arguments (see this mod's step event) and you're all done!
        
    USEFUL VARIABLES:
        pet             = The pet's name. Mainly controls the event names that NTTE looks for.
        spr_idle        = The pet's idle sprite.
        spr_walk        = The pet's walk sprite.
        spr_hurt        = The pet's hurt OR dodge sprite.
        spr_dead        = The pet's death sprite, only used if the pet takes damage.
        right           = Determines if the pet is facing left(-1) or right(1).
        leader          = The current leader (Player ID).
        can_take        = Determines if a player can take the pet. Set to false when a leader exists.
        can_path        = Determines if the pet can attempt to pathfind to their leader.
        path            = An array of points leading the pet to its leader.
        path_dir        = The direction to reach the next point on the path.
        path_wall       = An array of objects that the pet pathfinds around (Default - [Wall, InvisiWall]).
        maxhealth       = The pet's max HP, set this if you want the pet to take damage.
        walk            = Time in frames that the pet can move.
        walkspd         = Walking acceleration.
        maxspeed        = Maximum walking speed.
        light           = Determines if NTTE should draw the pet's light on dark levels.
        light_radius    = A 2 element array representing the pet's light radius. [Inner, Outer]
        push            = How much the pet gets pushed around by the player/other pets.
        alarm0          = Time in frames until the pet's _alrm0 script will be run again.
        
    SCRIPTS:
        (any script can be left undefined to use default pet behavior)
        
        <Name>_create - Runs once when the pet is created.
            Set sprites and important variables in here.
        <Name>_anim - Runs every frame. Handles animations.
            Leave this alone unless you want to change how the pet sets its sprites.
        <Name>_step - Runs every frame. The pet's step event.
        <Name>_draw - Runs every frame. The pet's draw event.
            Called with all 9 arguments of draw_sprite_ext().
        <Name>_alrm0 - Runs when the alarm0 timer reaches 0.
            Handles main movement patterns and behavior.
            Arguments: (Direction to leader, Distance to leader)
        <Name>_hurt - Runs when the pet comes in contact with damage.
            Leave this alone unless you want to change how the pet dodges/takes damage.
            Arguments: (Damage, Knockback amount, Knockback direction)
        <Name>_death - Runs on pet death, only used if the pet takes damage.
    
    SPRITES:
        If you're worried about consistency, the effect on the first frame of the pet
        hurt sprite is achieved by adding opaque white to the sprite on a layer with
        blending set to overlay.
    */
    
#define step
     // Spawn Pet:
    if(!instance_exists(GenCont)){
        with(instances_matching(RadChest, "has_baby", undefined)){
            has_baby = true;
            
             // Here he comes:
            pet_create(x, y, "Baby");
        }
    }

#define Baby_create(_x, _y)
     // Visual:
    spr_idle = global.sprBabyIdle;
    spr_walk = global.sprBabyWalk;
    spr_hurt = global.sprBabyHurt;
    spr_shadow = shd16;
    spr_shadow_y = 5;
    
     // Vars:
    walkspd = 0.8;
    maxspeed = 3;
    
#define Baby_step
     // He's crying:
    if(!instance_exists(leader) && random(10) < current_time_scale){
        instance_create(x, y, Sweat);
    }

#define Baby_hurt(_hitdmg, _hitvel, _hitdir)
     // Hurt/Dodge Sprite:
    sprite_index = spr_hurt;
    image_index = 0;

     // Effects:
    instance_create(x, y, Dust);
    motion_set(_hitdir, _hitvel);
    
#define Baby_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
    draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
    
#define Baby_alrm0(_leaderDir, _leaderDis)
    alarm0 = 30 + random(30);
    /*
    Remember to reset the alarm, else the script won't run again. You can also set the alarm by
    returning a value, but doing this will end the script.
    */

    if(instance_exists(leader)){
         // Follow Leader:
        if(_leaderDis > 64 || collision_line(x, y, leader.x, leader.y, Wall, false, false)){
             // Pathfinding:
            if(path_dir != null){
                direction = path_dir;
                walk = 5 + random(5);
            }

             // Toward Leader:
            else{
                direction = _leaderDir;
                walk = 20 + random(20);
                /*
                Walking is handled automatically by NTTE's systems, so all you
                need to do is set walk to a positive number and set
                direction to where you want them to go.
                */
            }

             // Return a value to set the alarm and end the script:
            scrRight(direction);
            return walk + random(10);
        }
        
         // Affection:
        else if(random(3) < 1){
            instance_create(x, y, HealFX);
            scrRight(_leaderDir);
        }
    }
        
     // Wander:
    else{
        direction = random(360);
        walk = 20 + random(20);
        
        scrRight(direction);
        return walk + random(10);
    }
    
#define scrRight(_dir)
    /*
    A very handy script to have. Sets the pet's right variable according
    to a given angle. Put this wherever the pet will change directions.
    */
    _dir = (_dir + 360) mod 360;
    if(_dir < 90 || _dir > 270) right = 1;
    if(_dir > 90 && _dir < 270) right = -1;

#define pet_create(_x, _y, _pet)
    return mod_script_call("mod", "telib", "pet_create", _x, _y, _pet, "mod", mod_current);