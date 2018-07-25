#define init
    global.newLevel = instance_exists(GenCont);
    global.area = ["coast"];

#define level_start // game_start but every level
	if(GameCont.area == 1){
         // Disable Oasis Skip:
		with(instance_create(0, 0, AmmoChest)){
			visible = 0;
			mask_index = mskNone;
		}

	     // Spawn Sharky Skull on 1-3:
		with(BigSkull) instance_delete(id);
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
        for(var i = 0; i < array_length(global.area); i++){
            if(GameCont.area == global.area[i]){
                mod_script_call("area", global.area[i], "area_step");
            }
        }
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