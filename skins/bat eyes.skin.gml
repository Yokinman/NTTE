#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#define skin_race      return "eyes";
#define skin_name      return ((argument_count <= 0 || argument0) ? "BAT" : skin_lock());
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
		case sprMutant3Idle  : return spr.EyesBatIdle;
		case sprMutant3Walk  : return spr.EyesBatWalk;
		case sprMutant3Hurt  : return spr.EyesBatHurt;
		case sprMutant3Dead  : return spr.EyesBatDead;
		case sprMutant3GoSit : return spr.EyesBatGoSit;
		case sprMutant3Sit   : return spr.EyesBatSit;
		case sprBigPortrait  : return spr.EyesBatPortrait;
		case sprLoadoutSkin  : return spr.EyesBatLoadout;
		case sprMapIcon      : return spr.EyesBatMapIcon;
	}
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define area_get_name(_area, _subarea, _loop)                                           return  mod_script_call_nc('mod', 'telib', 'area_get_name', _area, _subarea, _loop);