#define init
	global.sprSkillHUD  = sprite_add("../sprites/skills/Toad Breath/sprToadBreathHUD.png",  1,  8,  8);
	
#define skill_name    return "TOAD BREATH";
#define skill_text    return "@wIMMUNITY @sTO @gTOXIC GAS"; // #@sTOXIC GAS @wHEALS" // maybe??;
#define skill_tip     return "CORROSION";
#define skill_icon    return global.sprSkillHUD;

#define skill_avail	 
	 // No Wild Encounters:
	return !instance_is(other, LevCont);
	
#define step
	if(instance_exists(Player)){
		with(Player){
			notoxic = true;
			
			 // Effects:
			if(chance_ct(1, 90)){
				with(instance_create(x, y, Breath)){
					image_alpha  = 1;
					image_blend  = make_color_rgb(108, 195, 4);
					image_xscale = other.right;
				}
			}
		}
	}
	
#define skill_lose
	with(Player){
		
		 // Probably a terrible way to do this but:
		if(race != "frog"){
			notoxic = false;
		}
	}
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));