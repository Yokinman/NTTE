#define init
	global.sprCrownIcon	   = sprite_add("../sprites/crowns/Crime/sprCrownCrimeIcon.png",     1, 12, 16);
	global.sprCrownIdle	   = sprite_add("../sprites/crowns/Crime/sprCrownCrimeIdle.png",    20,  8,  8);
	global.sprCrownWalk	   = sprite_add("../sprites/crowns/Crime/sprCrownCrimeWalk.png",     6,	 8,  8);
	global.sprCrownLoadout = sprite_add("../sprites/crowns/Crime/sprCrownCrimeLoadout.png",  2, 16, 16);
	
#define crown_name        return "CROWN OF CRIME";
#define crown_text        return "FIND @wSMUGGLED GOODS#@sA @rPRICE @sON YOUR HEAD";
#define crown_tip         return choose("THE @wFAMILY@s DOESN'T FORGIVE", "THE @rBAT'S@s EXPERIMENTS", "THE @rCAT'S@s RESOURCES", "THE WASTELAND WEAPON TRADE");
#define crown_avail       return unlock_get("lairCrown");
#define crown_menu_avail  return unlock_get(`loadout:crown:${mod_current}`) || unlock_get("crownCrime"); // crownCrime old unlock name
#define crown_loadout     return global.sprCrownLoadout;

#define crown_menu_button
	sprite_index = crown_loadout();
	image_index = !crown_menu_avail();
	dix = -1;
	diy = 0;
	
#define crown_button
	sprite_index = global.sprCrownIcon;
	
#define crown_object
	 // Visual:
	spr_idle = global.sprCrownIdle;
	spr_walk = global.sprCrownWalk;
	sprite_index = spr_idle;
	
	 // Vars:
	ntte_crown = "crime";
	enemy_time = 0;
	enemies = 0;
	
	 // Sound:
	if(instance_is(other, CrownIcon)){
		sound_play_pitch(sndCrownLove, 1.1);
		sound_play_pitchvol(sndBigWeaponChest, 0.2, 1.5);
	}
	
	
/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'telib', 'unlock_get', _unlock);