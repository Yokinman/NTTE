#define init
	 // Sprites:
	global.sprWep		= sprite_add_weapon("../sprites/weps/sprAnnihilator.png",		   8, 2);
	global.sprWepHUD1	= sprite_add(		"../sprites/weps/sprAnnihilatorHUD1.png",	1, 0, 3);
	global.sprWepHUD2   = sprite_add(		"../sprites/weps/sprAnnihilatorHUD2.png",	1, 0, 3);
	global.sprWepLocked = mskNone;
	
	global.color = `@(color:${make_color_rgb(235, 0, 67)})`;
	
#define weapon_sprt		return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_name 	return (weapon_avail() ? "ANNIHILATOR" : "LOCKED");
#define weapon_text 	return `@wBEND @sTHE ${global.color}CONTINUUM`;
#define weapon_swap 	return sndSwapHammer;
#define weapon_area 	return (weapon_avail() ? 21 : -1); // L1 3-1
#define weapon_type 	return type_melee;
#define weapon_load 	return 20; // 0.66 Seconds
#define weapon_avail	return true; // unlock_get("pack:red");
#define weapon_red		return 5;
#define weapon_melee	return (variable_instance_get(self, "redammo", 0) < weapon_red());

#define weapon_sprt_hud(w)	
	if(instance_is(self, Player) && (instance_is(other, TopCont) || instance_is(other, UberCont))){
		var _primary = (wep == w);
		if(player_get_show_hud(index, player_find_local_nonsync())){
			if(!instance_exists(menubutton) || index == player_find_local_nonsync()){
				var	_x = view_xview_nonsync + (_primary ? 42 : 86),
					_y = view_yview_nonsync + 21;
					
				var _active = 0;
				for(var i = 0; i < maxp; i++) _active += player_is_active(i);
				if(_active > 1) _x -= 19;
				
				 // Determine Color:
				var _col = "w";
				if(redammo > 0){
					if(_primary || (race == "steroids")){
						if(redammo < weapon_red()){
							_col = "r";
						}
					}
					else{
						_col = "s";
					}
				}
				else{
					_col = "d";
				}
				
				var _txt = string(redammo),
					_num = string_length(_txt);
					
				if(array_length(instances_matching_gt(instances_matching(projectile, "creator", id), "redammo_cost", 0)) > 0){
					_txt = "";
					repeat(_num){
						_txt += choose("?", "?", "?", "?", "$", "%", "&", "_");
					}
				}
				
				 // !!!
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);
				draw_set_projection(2, index);
				draw_text_nt(_x, _y, "@" + _col + _txt);
				draw_reset_projection();
			}
		}
		
		
		 // Curse Outline:
		if(variable_instance_get(id, (_primary ? "" : "b") + "curse")){
			return global.sprWepHUD1;
		}
	}
	
	 // Red Outline:
	return global.sprWepHUD2;

#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
		
	var _cost = weapon_red();
	if(redammo >= _cost){
		redammo -= _cost;
		
		 // Fire:
		with(obj_create(x, y, "AnnihilatorBullet")){
			creator  = other;
			team	 = other.team;
			motion_set(other.gunangle, 16);
			
			image_angle	 = direction;
			redammo_cost = _cost
		}
		
		 // Effects:
		wkick = 10;
		var d = gunangle + 180;
		move_contact_solid(d, 4);
		motion_add(d, 4);
		sleep(40);
		
		 // Sounds:
		sound_play(sndEnergyScrewdriver);
	}
	else{
		
		 // Fire:
		var _skill = skill_get(mut_long_arms),
			_lngth = lerp(0, 20, _skill);
			
		with(obj_create(x + lengthdir_x(_lngth, gunangle), y + lengthdir_y(_lngth, gunangle), "AnnihilatorSlash")){
			creator  = other;
			team	 = other.team;
			motion_set(other.gunangle, lerp(2, 5, _skill));
			
			image_angle  = direction;
			image_yscale = sign(other.wepangle);
		}
		
		 // Effects:
		wkick = 4;
		move_contact_solid(gunangle, 2);
		motion_add(gunangle, 3);
		sleep(10);
		
		 // Sounds:
		sound_play(sndScrewdriver);
	}

	
/// SCRIPTS
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define wepfire_init(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepfire_init', _wep);
#define wepammo_draw(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_draw', _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_fire', _wep);
#define draw_ammo(_index, _primary, _ammo, _ammoMax, _steroids)							return  mod_script_call(   'mod', 'telib', 'draw_ammo', _index, _primary, _ammo, _ammoMax, _steroids);