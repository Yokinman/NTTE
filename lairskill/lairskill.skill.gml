#define init
	global.sprLairSkillIcon = sprite_add("sprLairSkillIcon.png", 1, 12, 16);
	global.sprLairSkillHUD = sprite_add("sprLairSkillHUD.png", 1, 8, 8);
	
	global.forceSpawn = false;
	
#define game_start
	global.forceSpawn = false;
	
#define skill_name	return "SMUGGLER SENSE";
#define skill_text	return "BETTER @yCHESTS";
#define skill_tip	return "THE WASTELAND'S FINEST";
#define skill_avail return false;

#define skill_icon		return global.sprLairSkillHUD;
#define skill_button	sprite_index = global.sprLairSkillIcon;