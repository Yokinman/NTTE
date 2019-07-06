#define init
	global.sprCrownCrimeIcon = sprite_add("../sprites/crowns/Crime/sprCrownCrimeIcon.png",	1,	12, 16);
	global.sprCrownCrimeIdle = sprite_add("../sprites/crowns/Crime/sprCrownCrimeIdle.png",	20, 8,	8);
	global.sprCrownCrimeWalk = sprite_add("../sprites/crowns/Crime/sprCrownCrimeWalk.png",	6,	8,	8);

#define crown_name	return "CROWN OF CRIME";
#define crown_text	return "FIND SMUGGLED GOODS#A PRICE ON YOUR HEAD";
#define crown_tip	return choose("THE @wFAMILY@s DOESN'T FORGIVE", "THE @rBAT'S@s EXPERIMENTS", "THE @rCAT'S@s RESOURCES", "THE WASTELAND WEAPON TRADE");
#define crown_avail	return unlock_get("lairCrown");

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

#define crown_take
	sound_play(sndCrownLove);
	
#define step
	 // Crown Step:
	with(instances_matching(Crown, "ntte_crown", "crime")){
		 // Watch where you're going bro:
		if(hspeed != 0) image_xscale = abs(image_xscale) * sign(hspeed);
		
		 // Spawn Enemies:
		if(enemies > 0){
			enemy_time -= current_time_scale;
			scrPortalPoof();
			
			if(enemy_time <= 0){
				var f = instance_furthest(x, y, Floor),
					l = irandom_range(360, 420),
					d = point_direction(f.x, f.y, x, y);
				
				while(enemies > 0){
					enemies -= 1;
					obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "TopEnemy");
				}
				
				 // Effects:
				with(instance_create(x + lengthdir_x(8, d), y + lengthdir_y(8, d), AssassinNotice)) motion_set(d, 1);
				sound_play(sndIDPDNadeAlmost);
			}
		}
	}


/// Scripts
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)															return  random(_denom) < _numer;
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);
#define scrPortalPoof()                                                                 return  mod_script_call("mod", "telib", "scrPortalPoof");