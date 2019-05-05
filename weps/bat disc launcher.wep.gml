#define init
    global.sprBatDiscLauncher = sprite_add_weapon("../sprites/weps/sprBatDiscLauncher.png", 6, 5);
    global.sprBatDisc = sprite_add("../sprites/weps/projectiles/sprBatDisc.png", 1, 9, 9);

#macro wepLWO {wep : mod_current, ammo : maxAmmo, buff : muscle}
#macro maxAmmo (3 + buffAmmo * muscle)
#macro wepCost 1
#macro buffAmmo 3

#macro muscle skill_get(mut_back_muscle)

#define weapon_name return "BAT DISC LAUNCHER";
#define weapon_text return "SMARTER THAN YOUR AVERAGE DISC";
#define weapon_auto return true;
#define weapon_type return 0; // None
#define weapon_load return 8; // 0.26 Seconds
#define weapon_area return (unlock_get("lairWep") ? 10 : -1); // 5-2
#define weapon_melee return false;
#define weapon_swap return sndSwapShotgun;
#define weapon_sprt return lwo_wep_sprt(argument0, lq_defget(argument0, "ammo", maxAmmo), maxAmmo, global.sprBatDiscLauncher);

#define step(_pwep)
     // Back muscle:
    var _wep = variable_instance_get(id, ["bwep", "wep"][_pwep]);
    if(is_object(_wep)){
        if(_wep.buff != muscle){
            
            var _unbuff = round(buffAmmo * _wep.buff)
            
             // Account for preexisting projectiles:
            with(instances_matching(instances_matching(CustomProjectile, "name", "BatDisc"), "my_lwo", _wep)){
                _unbuff -= ammo;
                ammo = 0;
                
                if(_unbuff <= _wep.ammo) break;
            }
            
            _wep.ammo -= _unbuff;
            _wep.buff = muscle;
            _wep.ammo += round(buffAmmo * muscle);
        }
    }

#define weapon_fire
    if(!is_object(wep)) wep = wepLWO;
    
     // Fire:
    if(lwo_wep_ammo(wep, wepCost, (button_pressed(index, "fire") || (button_pressed(index, "spec") && specfiring)))){
         // Projectile:
        with(obj_create(x, y, "BatDisc")){
            projectile_init(other.team, other);
            my_lwo = other.wep;
            ammo = (other.infammo == 0) * wepCost;
            
            motion_set(other.gunangle + orandom(12) * other.accuracy, maxspeed);
        }
        
         // Effects:
        weapon_post(8, 8, 8);
        motion_set(gunangle, -4);
        
        repeat(3 + irandom(3)) with(instance_create(x, y, Smoke)) motion_set(other.gunangle + orandom(24), random(6));
        
         // Sounds:
        sound_play_pitchvol(sndSuperDiscGun,    0.8 + random(0.4), 0.6);
        sound_play_pitchvol(sndRocket,          1.0 + random(0.6), 0.8);
    }

#define lwo_wep_ammo /// lwo_wep_ammo(_weapon, _cost, ?_emptyFX = undefined)
    var _weapon = argument[0], _cost = argument[1];
var _emptyFX = argument_count > 2 ? argument[2] : undefined;
    
     // Infinite ammo:
    if(infammo != 0) return true;
    
     // Subtract cost:
    with(_weapon) if(_cost <= ammo){
        ammo -= _cost;
        
         // Can fire:
        return true;
    }
    
     // Empty effects:
    if(!is_undefined(_emptyFX) && _emptyFX){
        wkick = -3;
        
        with(instance_create(x, y, PopupText)){
            target = other.index;
            mytext = "EMPTY";
        }
        
        sound_play(sndEmpty);
    }
    
     // Not enough ammo:
    return false;

#define lwo_wep_sprt(_weapon, _ammo, _maxAmmo, _sprite)
    var a = ["wep", "bwep"],
        p = player_find(player_find_local_nonsync());
    
    if(instance_exists(p)){
        var _steroids = p.race == "steroids";
        
        with(instances_matching(other, "object_index", TopCont, UberCont)){
            for(var i = 0; i <= 1; i++){
                if(variable_instance_get(p, a[i]) == _weapon){
                    var c = "@w",
                        _xoffset = (i ? 86 : 42),
                        _yoffset = 21;
                        
                     // Determine color:
                    if(!i || _steroids){
                        if(_ammo <= ceil(_maxAmmo * 0.2)) c = "@r";
                    }
                    else c = "@s";
                    if(_ammo <= 0) c = "@d";
                    
                     // Set projection:
                    draw_set_halign(fa_left);
                    draw_set_valign(fa_top);
                    
                     // Draw text:
                    draw_text_nt(view_xview_nonsync + _xoffset, view_yview_nonsync + _yoffset, c + string(_ammo));
                    
                    draw_reset_projection();
                }
            }
        }
    }
    
     // Return weapon sprite:
    return _sprite;

/// Scripts:
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call("mod", "telib", "obj_create", _x, _y, _obj);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);
#define ammo_draw(_index, _primary, _ammo, _steroids)                                   return  mod_script_call("mod", "ntte", "ammo_draw", _index, _primary, _ammo, _steroids);