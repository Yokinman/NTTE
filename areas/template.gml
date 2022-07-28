#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	/*
		- Copy this file, rename it, and delete this note to make a new area
		- All code in a script should be indented one extra so that it stands out
		- Try to keep all scripts in the order that this file has them
	*/
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro area_active variable_instance_get(GameCont, "ntte_active_" + mod_current, false) && (GameCont.area == mod_current || GameCont.lastarea == mod_current)
#macro area_visits variable_instance_get(GameCont, "ntte_visits_" + mod_current, 0)

#define area_subarea           return 3;
#define area_goal              return 110;
#define area_next              return [area_sewers, 1];
#define area_music             return mus1;
#define area_music_boss        return musBoss1;
#define area_ambient           return amb1;
#define area_background_color  return make_color_rgb(175, 143, 106);
#define area_shadow_color      return c_black;
#define area_darkness          return false;
#define area_secret            return false;

#define area_name(_subarea, _loops)
	return "1-" + string(_subarea);
	
#define area_text
	return choose(
		"tip1",
		"tip2",
		"tip3"
	);
	
#define area_mapdata(_lastX, _lastY, _lastArea, _lastSubarea, _subarea, _loops)
	return [
		0,
		0,
		true,
		true
	];
	
#define area_sprite(_spr)
	switch(_spr){
		 // Floors:
		case sprFloor1      : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return sprFloor1;
		case sprFloor1B     : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return sprFloor1B;
		case sprFloor1Explo : return sprFloor1Explo;
		case sprDetail1     : return sprDetail1;
		
		 // Walls:
		case sprWall1Bot    : return sprWall1Bot;
		case sprWall1Top    : return sprWall1Top;
		case sprWall1Out    : return sprWall1Out;
		case sprWall1Trans  : return sprWall1Trans;
		case sprDebris1     : return sprDebris1;
		
		 // Decals:
		case sprTopPot      : return -1;
		case sprBones       : return -1;
	}
	
#define area_setup
	goal             = area_goal();
	background_color = area_background_color();
	BackCont.shadcol = area_shadow_color();
	TopCont.darkness = area_darkness();
	
#define area_setup_floor
	 // Fix Depth:
	if(styleb) depth = 8;
	
	 // Footsteps:
	material = (styleb ? 4 : 1);
	
#define area_start
	 // Enable Area:
	variable_instance_set(GameCont, "ntte_active_" + mod_current, true);
	
#define area_finish
	 // Remember:
	variable_instance_set(GameCont, "ntte_visits_" + mod_current, area_visits + 1);
	
	 // Next Subarea:
	if(subarea < area_subarea()){
		subarea++;
	}
	
	 // Next Area:
	else{
		var _next = area_next();
		area    = _next[0];
		subarea = _next[1];
	}
	
#define area_transit
	 // Disable Area:
	variable_instance_set(GameCont, "ntte_active_" + mod_current, false);
	
#define area_make_floor
	var	_x = x,
		_y = y,
		_outOfSpawn = (point_distance(_x, _y, 10000, 10000) > 48);
		
	/// Make Floors:
		 // Special - 2x2 Fill:
		if(chance(1, 2)){
			call(scr.floor_fill, _x + 16, _y + 16, 2);
		}
		
		 // Normal:
		else instance_create(_x, _y, Floor);
		
	/// Turn:
		var _trn = 0;
		if(chance(5, 14)){
			_trn = choose(90, 90, -90, -90, 180);
		}
		direction += _trn;
		
	/// Chests & Branching:
		 // Weapon Chests:
		if(_outOfSpawn && _trn == 180){
			instance_create(_x + 16, _y + 16, WeaponChest);
		}
		
		 // Ammo Chests + End Branch:
		var n = instance_number(FloorMaker);
		if(!chance(20, 19 + n)){
			if(_outOfSpawn){
				instance_create(_x + 16, _y + 16, AmmoChest);
			}
			instance_destroy();
		}
		
		 // Branch:
		if(chance(1, 8)){
			instance_create(_x, _y, FloorMaker);
		}
		
#define area_pop_enemies
	var	_x = x + 16,
		_y = y + 16;
		
	instance_create(_x, _y, choose(Bandit, Maggot));
	
#define area_pop_props
	var	_x = x + 16,
		_y = y + 16,
		_spawnDis = point_distance(_x, _y, 10016, 10016);
		
	if(_spawnDis > 48 && chance(1, 12)){
		if(chance(1, 60)){
			instance_create(_x, _y, BigSkull);
		}
		else instance_create(_x, _y, Cactus);
	}
	
#define area_pop_extras
	with(chestprop){
		instance_create(x, y, Bandit);
	}
	
#define area_effect
	alarm0 = irandom_range(1, 60);
	
	for(var i = 0; i < maxp; i++){
		if(player_is_active(i)){
			 // Pick Random Player's Screen:
			do i = irandom(maxp - 1);
			until player_is_active(i);
			
			 // Wind:
			with(call(scr.instance_random, call(scr.instances_seen, Floor, 0, 0, i))){
				instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Wind);
			}
			
			break;
		}
	}
	
#define ntte_begin_step
	if(area_active){
		
	}
	
#define ntte_step
	if(area_active){
		
	}
	
#define ntte_end_step
	if(area_active){
		
	}
	
	
/// SCRIPTS
#macro  call                                                                                    script_ref_call
#macro  scr                                                                                     global.scr
#macro  obj                                                                                     global.obj
#macro  spr                                                                                     global.spr
#macro  snd                                                                                     global.snd
#macro  msk                                                                                     spr.msk
#macro  mus                                                                                     snd.mus
#macro  lag                                                                                     global.debug_lag
#macro  ntte                                                                                    global.ntte_vars
#macro  epsilon                                                                                 global.epsilon
#macro  mod_current_type                                                                        global.mod_type
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  area_campfire                                                                           0
#macro  area_desert                                                                             1
#macro  area_sewers                                                                             2
#macro  area_scrapyards                                                                         3
#macro  area_caves                                                                              4
#macro  area_city                                                                               5
#macro  area_labs                                                                               6
#macro  area_palace                                                                             7
#macro  area_vault                                                                              100
#macro  area_oasis                                                                              101
#macro  area_pizza_sewers                                                                       102
#macro  area_mansion                                                                            103
#macro  area_cursed_caves                                                                       104
#macro  area_jungle                                                                             105
#macro  area_hq                                                                                 106
#macro  area_crib                                                                               107
#macro  infinity                                                                                1/0
#macro  instance_max                                                                            instance_create(0, 0, DramaCamera)
#macro  current_frame_active                                                                    ((current_frame + epsilon) % 1) < current_time_scale
#macro  game_scale_nonsync                                                                      game_screen_get_width_nonsync() / game_width
#macro  anim_end                                                                                (image_index + image_speed_raw >= image_number) || (image_index + image_speed_raw < 0)
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed == 0) ? spr_idle : spr_walk) : sprite_index
#macro  enemy_boss                                                                              ('boss' in self) ? boss : ('intro' in self || array_find_index([Nothing, Nothing2, BigFish, OasisBoss], object_index) >= 0)
#macro  player_active                                                                           visible && !instance_exists(GenCont) && !instance_exists(LevCont) && !instance_exists(SitDown) && !instance_exists(PlayerSit)
#macro  target_visible                                                                          !collision_line(x, y, target.x, target.y, Wall, false, false)
#macro  target_direction                                                                        point_direction(x, y, target.x, target.y)
#macro  target_distance                                                                         point_distance(x, y, target.x, target.y)
#macro  bbox_width                                                                              (bbox_right + 1) - bbox_left
#macro  bbox_height                                                                             (bbox_bottom + 1) - bbox_top
#macro  bbox_center_x                                                                           (bbox_left + bbox_right + 1) / 2
#macro  bbox_center_y                                                                           (bbox_top + bbox_bottom + 1) / 2
#macro  FloorNormal                                                                             instances_matching(Floor, 'object_index', Floor)
#macro  alarm0_run                                                                              alarm0 && !--alarm0 && !--alarm0 && (script_ref_call(on_alrm0) || !instance_exists(self))
#macro  alarm1_run                                                                              alarm1 && !--alarm1 && !--alarm1 && (script_ref_call(on_alrm1) || !instance_exists(self))
#macro  alarm2_run                                                                              alarm2 && !--alarm2 && !--alarm2 && (script_ref_call(on_alrm2) || !instance_exists(self))
#macro  alarm3_run                                                                              alarm3 && !--alarm3 && !--alarm3 && (script_ref_call(on_alrm3) || !instance_exists(self))
#macro  alarm4_run                                                                              alarm4 && !--alarm4 && !--alarm4 && (script_ref_call(on_alrm4) || !instance_exists(self))
#macro  alarm5_run                                                                              alarm5 && !--alarm5 && !--alarm5 && (script_ref_call(on_alrm5) || !instance_exists(self))
#macro  alarm6_run                                                                              alarm6 && !--alarm6 && !--alarm6 && (script_ref_call(on_alrm6) || !instance_exists(self))
#macro  alarm7_run                                                                              alarm7 && !--alarm7 && !--alarm7 && (script_ref_call(on_alrm7) || !instance_exists(self))
#macro  alarm8_run                                                                              alarm8 && !--alarm8 && !--alarm8 && (script_ref_call(on_alrm8) || !instance_exists(self))
#macro  alarm9_run                                                                              alarm9 && !--alarm9 && !--alarm9 && (script_ref_call(on_alrm9) || !instance_exists(self))
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < _numer * current_time_scale;
#define pround(_num, _precision)                                                        return  (_precision == 0) ? _num : round(_num / _precision) * _precision;
#define pfloor(_num, _precision)                                                        return  (_precision == 0) ? _num : floor(_num / _precision) * _precision;
#define pceil(_num, _precision)                                                         return  (_precision == 0) ? _num :  ceil(_num / _precision) * _precision;
#define frame_active(_interval)                                                         return  ((current_frame + epsilon) % _interval) < current_time_scale;
#define lerp_ct(_val1, _val2, _amount)                                                  return  lerp(_val2, _val1, power(1 - _amount, current_time_scale));
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define angle_lerp_ct(_ang1, _ang2, _num)                                               return  _ang2 + (angle_difference(_ang1, _ang2) * power(1 - _num, current_time_scale));
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define enemy_walk(_dir, _num)                                                                  direction = _dir; walk = _num; if(speed < friction_raw) speed = friction_raw;
#define enemy_face(_dir)                                                                        _dir = ((_dir % 360) + 360) % 360; if(_dir < 90 || _dir > 270) right = 1; else if(_dir > 90 && _dir < 270) right = -1;
#define enemy_look(_dir)                                                                        _dir = ((_dir % 360) + 360) % 360; if(_dir < 90 || _dir > 270) right = 1; else if(_dir > 90 && _dir < 270) right = -1; if('gunangle' in self) gunangle = _dir;
#define enemy_target(_x, _y)                                                                    target = (instance_exists(Player) ? instance_nearest(_x, _y, Player) : ((instance_exists(target) && target >= 0) ? target : noone)); return (target != noone);
#define script_bind(_scriptObj, _scriptRef, _depth, _visible)                           return  call(scr.script_bind, script_ref_create(script_bind), _scriptObj, (is_real(_scriptRef) ? script_ref_create(_scriptRef) : _scriptRef), _depth, _visible);