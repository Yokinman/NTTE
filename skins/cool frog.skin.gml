#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#define skin_race      return "frog";
#define skin_name      return ((argument_count <= 0 || argument0) ? "COOL" : skin_lock());
#define skin_lock      return `REACH @q@(color:${make_color_rgb(255, 110, 25)})COMBO x100`;
#define skin_unlock    return `REACHED @q@(color:${make_color_rgb(255, 110, 25)})COMBO x100`;
#define skin_avail     return unlock_get("skin:" + mod_current);
#define skin_portrait  return skin_sprite(sprBigPortrait);
#define skin_mapicon   return skin_sprite(sprMapIcon);

#define skin_ttip
	return (
		(chance(1, 5) && GameCont.level >= 10)
		? choose(
			"SLIME TIME",
			"TOO MUCH PIZZA",
			"MAKE SURE YOU FLUSH",
			"WANNA SEE A FROG?",
			`@q@(color:${choose(make_color_rgb(255, 230, 70), make_color_rgb(50, 210, 255), make_color_rgb(255, 110, 25), make_color_rgb(255, 110, 150))})COMBO x${GameCont.kills}`
		)
		: choose(
			"JUST A COOL FROG",
			"WHAT THE COOL",
			"TOO COOL FOR SCHOOL",
			"STRAIGHT FROM THE SEWERS",
			"ROCKIN' THE SHADES",
			"FROGGING AROUND",
			(
				array_length(instances_matching(instances_matching(CustomHitme, "name", "Pet"), "pet", "CoolGuy"))
				? `@(color:${make_color_rgb(255, 110, 150)})FUNKY`
				: ""
			)
		)
	);
	
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