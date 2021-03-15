#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprSkillHUD = sprite_add("../sprites/skills/Bat Ears/sprBatEarsHUD.png", 1, 8, 8);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define skill_name   return "BAT EARS";
#define skill_text   return "SEE BETTER IN THE @dDARK";
#define skill_tip    return "ECHOLOCATION IS UNDERRATED";
#define skill_icon   return global.sprSkillHUD;
#define skill_avail  return false;
#define skill_rat    return true;

#define skill_sound
	audio_sound_pitch(
		sound_play_gun(sndMutant3Valt, 0, 0.3),
		1.5
	);
	return sndMutLastWish;
	
#define skill_take(_num)
	 // Sound:
	if(_num > 0 && instance_exists(LevCont)){
		sound_play_gun(skill_sound(), 0, 0.3);
	}
	
#define ntte_draw_dark(_type)
	if(skill_get(mod_current) > 0){
		switch(_type){
			
			case "normal":
				
				 // Extended Vision:
				draw_clear(draw_get_color());
				
				break;
				
			case "end":
				
				 // Extended Vision:
				with(Player){
					draw_circle(
						x,
						y,
						((130 * (1 + (race == "eyes"))) + random(4)) * skill_get(mod_current),
						false
					);
				}
				
				break;
		}
	}
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));