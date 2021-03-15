#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprSkillHUD = sprite_add("../sprites/skills/Lead Ribs/sprLeadRibsHUD.png", 1, 8, 8);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr

#define skill_name   return "LEAD RIBS";
#define skill_text   return "MORE @gRADS @sFROM @wENEMIES";
#define skill_tip    return "HIGHER THRESHOLD";
#define skill_icon   return global.sprSkillHUD;
#define skill_avail  return false;
#define skill_rat    return true;

#define skill_sound
	sound_play_gun(sndSewerPipeBreak, 0, 0.3);
	sound_play_gun(sndBigMaggotDie,   0, 0.3);
	return sndMutPlutoniumHunger;
	
#define skill_take(_num)
	 // Sound:
	if(_num > 0 && instance_exists(LevCont)){
		sound_play_gun(skill_sound(), 0, 0.3);
	}
	
#define step
	 // More Rads!!!!!
	if(instance_exists(enemy)){
		var _inst = instances_matching(instances_matching_le(enemy, "my_health", 0), "leadribs_check", null);
		if(array_length(_inst)) with(_inst){
			leadribs_check = true;
			var _num = ceil(raddrop * 0.2 * skill_get(mod_current));
			if(_num > 0){
				with(rad_drop(x, y, _num, direction, speed / 4)){
					sprite_index = (
						instance_is(self, BigRad)
						? spr.BigRadUpg
						: spr.RadUpg
					);
				}
			}
			else raddrop += _num;
		}
	}
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define rad_drop(_x, _y, _raddrop, _dir, _spd)                                          return  mod_script_call_nc  ('mod', 'telib', 'rad_drop', _x, _y, _raddrop, _dir, _spd);