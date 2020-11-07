#define init
	global.sprSkillHUD  = sprite_add("../sprites/skills/Bat Ears/sprBatEarsHUD.png",  1,  8,  8);
	
#define skill_name    return "BAT EARS";
#define skill_text    return "@wSEE BETTER @sIN THE @wDARK";
#define skill_tip     return "ECHOLOCATION IS UNDERRATED";
#define skill_icon    return global.sprSkillHUD;

#define skill_avail
	 // No Wild Encounters:
	return (variable_instance_get(TopCont, "darkness", false) && !instance_is(other, LevCont));
	
#define ntte_dark(_type)
	switch(_type){
		case "normal":
			draw_clear(draw_get_color());
			
			break;
		
		case "end":
		
			 // Extended Radius:
			var _playerIndex = player_find_local_nonsync();
			if(player_get_race(_playerIndex) == "eyes"){
				draw_clear(draw_get_color());
			}
			else{
				var _localPlayer = player_find(_playerIndex);
				if(instance_exists(_localPlayer)){
					with(_localPlayer){
						draw_circle(x, y, (80 + irandom(2)), false);
					}
				}
			}
			
			break;
	}
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));