#define init
	global.sprCrownIcon	    = sprite_add("../sprites/crowns/Crime/sprCrownCrimeIcon.png",		1, 12, 16);
	global.sprCrownIdle	    = sprite_add("../sprites/crowns/Crime/sprCrownCrimeIdle.png",	   20,  8,	8);
	global.sprCrownWalk	    = sprite_add("../sprites/crowns/Crime/sprCrownCrimeWalk.png",		6,	8,	8);
	global.sprCrownLoadout	= sprite_add("../sprites/crowns/Crime/sprCrownCrimeLoadout.png",	2, 16, 16);

#define crown_name			return "CROWN OF BONUS";
#define crown_text			return "???";
#define crown_tip			return "";
#define crown_avail			return true;//unlock_get("lairCrown");
#define crown_menu_avail	return unlock_get("crownBonus");

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
	 // Only Bonus Ammo/HP:
	with(instances_matching(HPPickup, "sprite_index", sprHP)){
		obj_create(x, y, "OverhealPickup");
		instance_delete(id);
	}
	with(instances_matching(AmmoPickup, "sprite_index", sprAmmo, sprCursedAmmo)){
		obj_create(x, y, "OverstockPickup");
		instance_delete(id);
	}
	
	
/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'telib', 'unlock_get', _unlock);