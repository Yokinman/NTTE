#define init
	global.sprSkillIcon = sprite_add("../sprites/skills/Compassion/sprSkillCompassionIcon.png", 1, 12, 16);
	global.sprSkillHUD  = sprite_add("../sprites/skills/Compassion/sprSkillCompassionHUD.png",  1,  8,  8);
	game_start();
	
#define game_start
    global.last = skill_get(mod_current);
	
#define skill_name      return "COMPASSION";
#define skill_text      return "EXTRA @wPET @sSLOT";
#define skill_tip       return "NEW BEST FRIEND";
#define skill_icon      return global.sprSkillHUD;
#define skill_button    sprite_index = global.sprSkillIcon;

#define skill_avail
     // Only Appears w/ a Player at Max Pets:
    with(Player){
        var _pet = variable_instance_get(self, "ntte_pet", []),
            _num = 0,
            _max = array_length(_pet);
            
        if(_max > 0){
            with(_pet) _num += instance_exists(self);
            if(_num >= _max) return true;
        }
    }
    return false;
    
#define skill_take(_num)
    mod_variable_set("mod", "ntte", "pet_max", mod_variable_get("mod", "ntte", "pet_max") + (_num - global.last));
    with(instances_matching_ne(Player, "ntte_pet_max", null)) ntte_pet_max += (_num - global.last);
    global.last = _num;
    
     // Sound:
    if(instance_exists(SkillIcon)){
        sound_play(sndMut);
        sound_play_pitch(sndMutLuckyShot, 1.2);
    }
    
#define skill_lose
    skill_take(0);