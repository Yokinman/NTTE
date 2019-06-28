#define init
    global.sprScythe = sprite_add_weapon_base64("iVBORw0KGgoAAAANSUhEUgAAABoAAAAWCAYAAADeiIy1AAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwgAADsIBFShKgAAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xNzNun2MAAAEbSURBVEhLtZPRjcIwEEQj2qEbOqACiqAMugA6IPwSGkLGs2Ks8cYJip1EejL27s6zpbsuhLAq8fuA0bk/qIWCy/mIzbSIjVr8B2cABZMiHIL3814lUsHpsE/gTPPwmQSwQcNKoAegn7MeitnLQTv0xVI4UIH247eCPL54FMSiBgDs9cY+bOivqGc9cc4yLJ8iJ0wBOujlCsV6AZynXJUoGgIw/HrYrbO/LKy81NDfDO6zPg2fAwMeX9PXUMy+UWANCNNwvoqrXaQ0uITft4tkL1IhasXhJciX/nc2EREVUbKpCOvmIqKiuI/luGjzGqiIr7Fz39iKiiixc21qBcF4hX+N1bSxFYq8xGq6aYUiL7GaP2gBgpIkhNB9AX8lwdEEbipzAAAAAElFTkSuQmCC", 5, 7);

#define weapon_name return "bone scythe";
#define weapon_text return "reassembled";
#define weapon_type return 0;   // Melee
#define weapon_load return 12;  // 0.4 Seconds
#define weapon_area return -1;  // Doesn't spawn normally
#define weapon_auto return true;
#define weapon_swap return sndBloodGamble;
#define weapon_sprt return global.sprScythe;

#define weapon_fire(w)
	wepangle *= -1;
	wkick = 3;
	
	 // Projectile:
	var _skill = skill_get(mut_long_arms),
	    l = 20 * _skill,
	    d = gunangle + orandom(8) * accuracy;
	with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), Slash)){
	    team = other.team;
	    creator = other;
	    damage = 24;
	    
	    direction = d;
	    speed = 2 + 3 * _skill;
	    image_angle = d;
	}
	
	 // Sounds:
	sound_play_pitch(sndBlackSword, 0.8 + random(0.4));

/// Scripts:
#define orandom(n)                                                                      return  random_range(-n, n);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc("mod", "telib", "obj_create", _x, _y, _obj));
#define scrSwap()                                                                       return  mod_script_call("mod", "telib", "scrSwap");
#define wep_get(_wep)                                                                   return  mod_script_call("mod", "telib", "wep_get", _wep);
#define unlock_get(_unlock)                                                             return  mod_script_call("mod", "telib", "unlock_get", _unlock);
#define wepammo_draw(_wep)                                                              return  mod_script_call("mod", "telib", "wepammo_draw", _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call("mod", "telib", "wepammo_fire", _wep);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call(   "mod", "telib", "instances_meeting", _x, _y, _obj);