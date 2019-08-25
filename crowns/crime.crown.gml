#define init
	global.sprCrownCrimeIcon	= sprite_add("../sprites/crowns/Crime/sprCrownCrimeIcon.png",		1, 12, 16);
	global.sprCrownCrimeIdle	= sprite_add("../sprites/crowns/Crime/sprCrownCrimeIdle.png",	   20,  8,	8);
	global.sprCrownCrimeWalk	= sprite_add("../sprites/crowns/Crime/sprCrownCrimeWalk.png",		6,	8,	8);
	global.sprCrownCrimeLoadout	= sprite_add("../sprites/crowns/Crime/sprCrownCrimeLoadout.png",	2, 16, 16);

#define crown_name			return "CROWN OF CRIME";
#define crown_text			return "FIND @wSMUGGLED GOODS#@sA @rPRICE @sON YOUR HEAD";
#define crown_tip			return choose("THE @wFAMILY@s DOESN'T FORGIVE", "THE @rBAT'S@s EXPERIMENTS", "THE @rCAT'S@s RESOURCES", "THE WASTELAND WEAPON TRADE");
#define crown_avail			return unlock_get("lairCrown");
#define crown_menu_avail	return unlock_get("crownCrime");

#define crown_menu_button
    sprite_index = global.sprCrownCrimeLoadout;
    image_index = !crown_menu_avail();
    dix = 0;
    diy = -1;

#define crown_button
	sprite_index = global.sprCrownCrimeIcon;

#define crown_object
	 // Visual:
	spr_idle = global.sprCrownCrimeIdle;
	spr_walk = global.sprCrownCrimeWalk;
	sprite_index = spr_idle;

	 // Vars:
	ntte_crown = "crime";
	enemy_time = 0;
	enemies = 0;
	
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
	
/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)															return  random(_denom) < _numer;
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);
#define scrPortalPoof()                                                                 return  mod_script_call("mod", "telib", "scrPortalPoof");