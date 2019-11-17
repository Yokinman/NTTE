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