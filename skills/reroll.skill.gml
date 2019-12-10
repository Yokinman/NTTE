#define init
	global.sprSkillHUD  = sprite_add("../sprites/skills/Reroll/sprSkillRerollHUD.png",  1,  8,  8);
	game_start();
	
#define game_start
	global.index = 0;

#macro skill mod_variable_get("mod", "tepickups", "vFlowerSkill")
#macro index mod_variable_get("mod", "tepickups", "vFlowerIndex")
	
#define skill_name      return "FLOWER'S BLESSING";
#define skill_text      return `@sREROLL @w${skill_get_name(skill)}`;
#define skill_avail 	return false;
#define skill_icon      return global.sprSkillHUD;

#define step
	if(skill_get_at(index + 1)){
		skill_set(mod_current, 0);
	}


/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'telib', 'unlock_get', _unlock);