#define init
	 // Sprites:
	global.sprWep		= sprite_add_weapon("../sprites/weps/sprAnnihilator.png",		   8, 2);
	global.sprWepHUD	= sprite_add(		"../sprites/weps/sprAnnihilatorHUD.png",	1, 0,  3);
	// global.sprWepDamage = sprite_add_weapon("../sprites/weps/sprAnnihilatorDamage.png",	   8, 0);
	// global.sprWepBroken = sprite_add_weapon("../sprites/weps/sprAnnihilatorBroken.png",    4, 4);
	global.sprWepLocked = mskNone;
	
	global.color = `@(color:${make_color_rgb(235, 0, 67)})`;
	
	 // LWO:
	lwoWep = {
		wep   : mod_current,
		ammo  : 1,
		amax  : 55,
		anam  : "CHARGE",
		cost  : 0,
		buff  : false,
		proj  : noone
	};
	 
#macro lwoWep global.lwoWep
	
#define weapon_name 	return (weapon_avail() ? "ANNIHILATOR" : "LOCKED");
#define weapon_text 	return `@wBEND @sTHE ${global.color}CONTINUUM`;
#define weapon_swap 	return sndSwapHammer;
#define weapon_area 	return (weapon_avail() ? 21 : -1); // L1 3-1
#define weapon_type 	return type_melee;
#define weapon_load 	return 20; // 0.66 Seconds
#define weapon_melee(w)	return (lq_defget(w, "ammo", 1) <= 0);
#define weapon_avail	return true; // unlock_get("pack:red");
#define weapon_red		return true;

#define weapon_sprt_hud(w)	
	if(instance_is(self, Player) && (instance_is(other, TopCont) || instance_is(other, UberCont))){
		var _primary = (w == wep);
			
		 // Copy-Pasted Code Time:
		if(player_get_show_hud(index, player_find_local_nonsync())){
			if(!instance_exists(menubutton) || index == player_find_local_nonsync()){
				var	_x = view_xview_nonsync + (_primary ? 42 : 86),
					_y = view_yview_nonsync + 21;
					
				var _active = 0;
				for(var i = 0; i < maxp; i++) _active += player_is_active(i);
				if(_active > 1) _x -= 19;
				
				 // Determine Color:
				var _col = "@w";
				if(lq_defget(w, "ammo", 1) > 0){
					if(instance_exists(lq_defget(w, "proj", noone))){
						_col = `@q${global.color}`;
					}
					else{
						if(!_primary && race != "steroids"){
							_col = "@s";
						}
					}
				}
				else{
					_col = "@d";
				}
				
				 // !!!
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);
				draw_set_projection(2, index);
				draw_text_nt(_x, _y, _col + string(lq_defget(w, "ammo", 1)));
				draw_reset_projection();
			}
		}
	}
	
	return global.sprWepHUD;

#define weapon_sprt
	
	/*
	var _sprite = global.sprWepLocked;
	if(weapon_avail()){
		if(lq_defget(w, "ammo", 1) > 0){
			_sprite = global.sprWep;
		}
		else{
			
			 // Melee Mode:
			_sprite = global.sprWepBroken;
		}
	}
	*/
	
	/*
	 // Uncomment for a Lightshow:
	if(instance_is(self, Player) && wep == w){
		for(var i = 0; i < 3; i ++){
			draw_set_color_write_enable((i == 0), (i == 1), (i == 2), 1);
			
			var _wepAngle = (wepangle * weapon_melee(w));
			draw_sprite_ext(_sprite, 0, x + orandom(3), y + orandom(3), image_xscale, image_yscale * right, gunangle + _wepAngle, image_blend, image_alpha);
			
		}
		draw_set_color_write_enable(1, 1, 1, 1);
	}
	*/
	
	return (weapon_avail() ? global.sprWep : global.sprWepLocked);

#define step(_primary)
	var	b = (_primary ? "" : "b"),
		w = variable_instance_get(self, b + "wep");
	
	 // LWO Setup:
	if(!is_object(w)){
		w = lq_clone(lwoWep);
		variable_instance_set(self, b + "wep", w);
	}
	
	 // Dynamic Reload:
	if(instance_exists(w.proj)){
		variable_instance_set(id, b + "reload", weapon_load());
	}

#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
	
	if(w.ammo > 0){
		with(obj_create(x, y, "AnnihilatorBullet")){
			creator = other;
			team	= other.team;
			speed	= 16;
			direction	= other.gunangle;
			image_angle	= direction;
			
			 // Remember Each Other:
			my_lwo = w;
			w.proj = id;
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
		 // Effects:
		wkick = 4;
		move_contact_solid(gunangle, 2);
		motion_add(gunangle, 3);
		sleep(10);
		
		 // Fire:
		var _skill = skill_get(mut_long_arms);
		with(obj_create(x, y, "AnnihilatorSlash")){
			creator = other;
			team	= other.team;
			speed	= lerp(2, 5, _skill);
			direction	= other.gunangle;
			image_angle = direction;
			
			image_yscale = sign(other.wepangle);
			
			var _len = lerp(0, 20, _skill);
			x += lengthdir_x(_len, direction);
			y += lengthdir_y(_len, direction);
		}
		
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