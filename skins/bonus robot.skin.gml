#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#define skin_race      return "robot";
#define skin_name      return ((argument_count <= 0 || argument0) ? "BONUS" : skin_lock());
#define skin_lock      return "???";
#define skin_unlock    return "???";
#define skin_ttip      return "???";
#define skin_avail     return unlock_get("skin:" + mod_current) || 1;
#define skin_portrait  return skin_sprite(sprBigPortrait);
#define skin_mapicon   return skin_sprite(sprMapIcon);

#define skin_button
	sprite_index = skin_sprite(sprLoadoutSkin);
	image_index  = !skin_avail();
	
#define skin_sprite(_spr)
	switch(_spr){
		case sprMutant8Idle  : return spr.RobotBonusIdle;
		case sprMutant8Walk  : return spr.RobotBonusWalk;
		case sprMutant8Hurt  : return spr.RobotBonusHurt;
		case sprMutant8Dead  : return spr.RobotBonusDead;
		case sprMutant8GoSit : return spr.RobotBonusGoSit;
		case sprMutant8Sit   : return spr.RobotBonusSit;
		case sprBigPortrait  : return spr.RobotBonusPortrait;
		case sprLoadoutSkin  : return spr.RobotBonusLoadout;
		case sprMapIcon      : return spr.RobotBonusMapIcon;
	}
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define area_get_name(_area, _subarea, _loop)                                           return  mod_script_call_nc('mod', 'telib', 'area_get_name', _area, _subarea, _loop);