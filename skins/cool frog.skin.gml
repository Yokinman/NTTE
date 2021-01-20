#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#define skin_race      return "frog";
#define skin_name      return ((argument_count <= 0 || argument0) ? "COOL" : skin_lock());
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
		case sprMutant15Idle  : return spr.FrogCoolIdle;
		case sprMutant15Walk  : return spr.FrogCoolWalk;
		case sprMutant15Hurt  : return spr.FrogCoolHurt;
		case sprMutant15Dead  : return spr.FrogCoolDead;
		case sprMutant15GoSit : return spr.FrogCoolGoSit;
		case sprMutant15Sit   : return spr.FrogCoolSit;
		case sprBigPortrait   : return spr.FrogCoolPortrait;
		case sprLoadoutSkin   : return spr.FrogCoolLoadout;
		case sprMapIcon       : return spr.FrogCoolMapIcon;
	}
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define area_get_name(_area, _subarea, _loop)                                           return  mod_script_call_nc('mod', 'telib', 'area_get_name', _area, _subarea, _loop);