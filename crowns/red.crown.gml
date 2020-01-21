#define init
	global.sprCrownIcon	    = sprite_add("../sprites/crowns/Red/sprCrownRedIcon.png",		  1, 12, 16);
	global.sprCrownIdle	    = sprite_add("../sprites/crowns/Red/sprCrownRedIdle.png",	   10,  8,	8);
	global.sprCrownWalk	    = sprite_add("../sprites/crowns/Red/sprCrownRedWalk.png",		  6,	8,	8);
	global.sprCrownLoadout	= sprite_add("../sprites/crowns/Red/sprCrownRedLoadout.png",  2, 16, 16);
	global.newLevel = true;
	global.Spawned = false;

#define crown_name			return "RED CROWN";
#define crown_text			return "MORE @rHEARTS# qsSMALLER @wAREAS";
#define crown_tip			return "";
#define crown_avail			return true;//unlock_get("lairCrown");
#define crown_menu_avail	return true;//unlock_get("crownRed");

#define crown_menu_button
    sprite_index = global.sprCrownLoadout;
    image_index = !crown_menu_avail();
    dix = 3;
    diy = -1;

#define crown_button
	sprite_index = global.sprCrownIcon;

#define crown_object
	 // Visual:
	spr_idle = global.sprCrownIdle;
	spr_walk = global.sprCrownWalk;
	sprite_index = spr_idle;

	 // Sound:
	if(instance_exists(CrownIcon)){
		if(fork()){
			wait 0;
			if(!instance_exists(CrownIcon)){
				sound_play_pitch(sndCrownLove, 0.95);
			}
			exit;
		}
	}

#define step
	 // Make areas smaller:
	with instances_matching_ne(FloorMaker, "crowned", true){
		crowned = true;
		goal = round(goal * .35);
		global.Spawned = false;
	}

	 // Spawn the hearts:
	while(global.Spawned = false){
		wait(1);
		if(instance_exists(GenCont)) global.newLevel = 1;
		else if(global.newLevel){
			global.newLevel = 0;
			var _heart_amount = 1 + (irandom(2) = 0 ? 1 : 0),
								_floorq = ds_list_create(),
			         			 _i = 0;

			 // Add eligible floor tiles to the list:
			with Floor
			{
				var _wall = false;
				if instance_exists(Wall){
					if distance_to_object(instance_nearest(x, y, Wall)) < 34{
						_wall = true;
					}
				}
				else{
					_wall = true;
				}
				if instance_exists(Player) && distance_to_object(Player) > 128 && _wall = true && !place_meeting(x, y, prop) && !place_meeting(x, y, hitme) && self != FloorExplo
				{
					_floorq[| _i] = self;
					_i++;
				}
			}
			ds_list_shuffle(_floorq);

			repeat(_heart_amount){
				with obj_create(_floorq[| 0].x + 16, _floorq[| 0].y + 18, "CrystalHeart"){
					do{
						if place_meeting(x, y, Wall)
						{
							with instance_nearest(x, y, Wall){
									instance_create(x, y, FloorExplo);
									instance_destroy();
							}
						}
					}until(!place_meeting(x, y, Wall))
				}
				ds_list_delete(_floorq, 0);
				ds_list_shuffle(_floorq);
			}
			ds_list_clear(_floorq);
			global.Spawned = true;
		}
	}

/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'telib', 'unlock_get', _unlock);
