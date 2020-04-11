#define init
	global.sprWep = sprite_add_weapon("../sprites/weps/sprBubbleRifle.png", 2, 5);
	global.sprWepLocked = mskNone;
	
#define weapon_name   return (weapon_avail() ? "RED RIFLE" : "LOCKED");
#define weapon_text   return "SEE RED";
#define weapon_type   return 5;  // Energy
#define weapon_cost   return 2;  // 2 Ammo
#define weapon_load   return 25; // 0.83 Seconds
#define weapon_area   return (weapon_avail() ? 6 : -1); // 3-1
#define weapon_swap   return sndSwapExplosive;
#define weapon_sprt   return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_avail  return unlock_get("pack:oasis");

#define weapon_fire(w)
	var f = wepfire_init(w);
	w = f.wep;
	
	 // Burst Fire:
	repeat(4) if(instance_exists(self)){
		 // Projectile:
		with(obj_create(x, y, "VlasmaBullet")){
			//move_contact_solid(other.gunangle, 6);
			motion_add(other.gunangle + (orandom(36) * other.accuracy), 8);
			mask_index = mskBullet1;
			image_angle = direction;
			image_speed = 0;
			image_index = image_number - 1;
			
			creator = f.creator;
			team = other.team;
			target = instance_nearest_matching_ne(mouse_x[creator.index], mouse_y[creator.index], hitme, "team", other.team);
			target_x = mouse_x[creator.index];
			target_y = mouse_y[creator.index];
			
			var	_wall = collision_line(creator.x, creator.y, mouse_x[creator.index], mouse_y[creator.index], Wall, 0, 0),
				_minlength = 100;
				
			if target = -4{
					if _wall != noone{
						target_x = _wall.x;
						target_y = _wall.y;
				}
				else{
					if point_distance(creator.x, creator.y, target_x, target_y) < _minlength{
						target_x = creator.x + lengthdir_x(_minlength, creator.gunangle);
						target_y = creator.y + lengthdir_y(_minlength, creator.gunangle);
						target = collision_line(creator.x,creator.y,creator.x + lengthdir_x(_minlength, creator.gunangle), creator.y + lengthdir_y(_minlength, creator.gunangle),Wall,0,0);
					}
				}
			}
		}
		
		 // Effects:
		weapon_post(5, -5, 10);
		
		var	l = 14,
			d = gunangle;
			
		 // Sound:
		var _pitch = random_range(0.8, 1.2);
		sound_play_pitch(sndPlasmaBigExplode, 1.4 * _pitch);
		
		wait 2;
	}
	
#define instance_nearest_matching_ne(_x,_y,obj,varname,value)
	var num = instance_number(obj),
	    man = instance_nearest(_x,_y,obj),
	    mans = [],
	    n = 0,
	    found = -4;
	if instance_exists(obj) && collision_line(creator.x, creator.y, obj.x, obj.y, Wall, 0, 0) = -4{
	    while ++n <= num && variable_instance_get(man,varname) = value || (instance_is(man,prop) && !instance_is(man,Generator)){
	        man.x += 10000
	        array_push(mans,man)
	        man = instance_nearest(_x,_y,obj)
	    }
	    if variable_instance_get(man,varname) != value && (!instance_is(man,prop) || instance_is(man,Generator)) found = man
	    with mans x-= 10000
	}
	return found;
	
	
/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define wepfire_init(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepfire_init', _wep);
#define wepammo_draw(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_draw', _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_fire', _wep);