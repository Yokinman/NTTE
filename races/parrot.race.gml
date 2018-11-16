#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.chest_list = [];
    global.chest_vars = [];

    while(true){
         // Chests Give Feathers:
        if(!instance_exists(GenCont)){
            with(instances_matching(chestprop, "feather_storage", null)){
                feather_storage = obj_create(x, y, "ParrotChester");
    
                 // Vars:
                with(feather_storage){
                    creator = other;
                    switch(other.object_index){
                        case BigWeaponChest:
                        case BigCursedChest:
                            num = 36; break;
                        case GiantWeaponChest:
                        case GiantAmmoChest:
                            num = 72; break;
                    }
                }
            }
        }
        wait 1;
    }

#macro spr global.spr

#define race_name           return "PARROT";
#define race_text           return "MANY FRIENDS#BIRDS OF A @rFEATHER@w";
#define race_tb_text        return "@rFEATHERS@s LAST LONGER";
#define race_portrait       return spr.ParrotPortrait;
#define race_mapicon        return spr.ParrotMap;
#define race_menu_button    sprite_index = spr.ParrotSelect;

#define race_ttip
    if(GameCont.level == 10 && random(5) < 1){
        return choose("migration formation", "charmed, i'm sure", "adventuring party", "free as a bird");
    }
    else{
        return choose("hitchhiker", "birdbrain", "parrot is an expert traveler", "wind under my wings", "parrot likes camping", "macaw works too", "chests give you @rfeathers@s");
    }

#define race_ultra_name
    switch (argument0) {
        case 1: return "FLOCK TOGETHER";
        case 2: return "UNFINISHED";
        default: return "";
    }
    
#define race_ultra_text
    switch (argument0) {
        case 1: return "CORPSES SPAWN @rFEATHERS@s";
        case 2: return "N/A";
        default: return "";
    }


#define create
    feather_ammo = 0;
    feather_load = 0;

    spr_idle = spr.ParrotIdle;
    spr_walk = spr.ParrotWalk;
    spr_hurt = spr.ParrotHurt;
    spr_dead = spr.ParrotDead;

    parrot_bob = [0, 1, 1, 0]; // Pet thing

#define game_start
    if(fork()){
        do wait 1;
        until !instance_exists(GenCont);

         // Starting Feather Ammo:
        repeat(12) with(obj_create(x + orandom(16), y + orandom(16), "ParrotFeather")){
            target = other;
            creator = other;
            speed *= 3;
        }
        
        with(Pet_create(x, y, "Parrot")) {
            leader = other;
            array_insert(other.pet, 0, self);
        }
        
        exit;
    }

#define step
     /// ACTIVE : Charm
    if(feather_load <= 0 || button_pressed(index, "spec")){
        var n = 3;
        if((button_check(index, "spec") || usespec > 0) && feather_ammo >= n){
            feather_ammo -= n;
            feather_load = 3;

             // Shooty Charm Feathers:
            var t = nearest_instance(mouse_x[index], mouse_y[index], instances_matching([enemy, RadMaggotChest], "", null));
            repeat(n){
                with(obj_create(x + orandom(4), y + orandom(4), "ParrotFeather")){
                    creator = other;
                    target = t;
                }
            }

             // Effects:
            sound_play_pitchvol(sndSharpTeeth, 3 + random(3), 0.4);
        }
    }
    else feather_load -= current_time_scale;

     /// ULTRA A: Flock Together
     // probably incredibly busted
    if(ultra_get(mod_current, 1)) {
        with(instances_matching(Corpse, "flock_together", null)) {
            flock_together = 1;
            // Hacky but me lazy:
            with(other) {
                with(obj_create(other.x + orandom(8), other.y + orandom(8), "ParrotFeather")){
                    target = other;
                    creator = other;
                }
            }
        }
    }

#define draw
    if(button_check(index, "spec")){
        draw_text_nt(x, y - 32, string(feather_ammo));
    }

#define nearest_instance(_x, _y, _instances)                                            return  mod_script_call("mod", "teassets", "nearest_instance", _x, _y, _instances);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call("mod", "telib", "obj_create", _x, _y, _obj);
#define orandom(n)                                                                      return  mod_script_call("mod", "teassets", "orandom", n);
#define Pet_create(_x, _y, _pet)                                                        return  mod_script_call("mod", "telib", "Pet_create", _x, _y, _pet);