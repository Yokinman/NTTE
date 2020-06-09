#define init
	global.sprWep = sprite_add_weapon("../sprites/weps/sprHarpoonLauncher.png", 3, 4);
	global.sprWepLocked = mskNone;
	
	lwoWep = {
		wep  : mod_current,
		rope : noone
	};
	
#macro lwoWep global.lwoWep

#define weapon_name   return (weapon_avail() ? "HARPOON LAUNCHER" : "LOCKED");
#define weapon_text   return "REEL IT IN";
#define weapon_swap   return sndSwapBow;
#define weapon_sprt   return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area   return (weapon_avail() ? 4 : -1); // 1-3
#define weapon_type   return type_bolt;
#define weapon_cost   return 1;
#define weapon_load   return 5; // 0.17 Seconds
#define weapon_avail  return unlock_get("pack:coast");

#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
	
	 // Effects:
	weapon_post(6, 8, -20);
	sound_play(sndCrossbow);
	sound_play_pitch(sndNadeReload, 0.8);
	
	 // Projectile:
	with(obj_create(x, y, "Harpoon")){
		motion_add(other.gunangle + orandom(3 * other.accuracy), 22);
		image_angle = direction;
		creator = f.creator;
		team = other.team;
		
		 // Link Harpoon:
		if(f.wepheld){
			if(!instance_exists(lq_defget(w.rope, "link1", noone)) || lq_defget(w.rope, "broken", true)){
				w.rope = Harpoon_rope(id, f.creator);
			}
			else{
				array_push(rope, w.rope);
				w.rope.break_timer = 60;
				w.rope.link2 = id;
				w.rope = noone;
			}
		}
	}
	
	
/// SCRIPTS
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define wepfire_init(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepfire_init', _wep);
#define wepammo_draw(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_draw', _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_fire', _wep);
#define Harpoon_rope(_link1, _link2)                                                    return  mod_script_call(   'mod', 'tecoast', 'Harpoon_rope', _link1, _link2);