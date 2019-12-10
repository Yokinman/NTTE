#define init
    global.sprWep		= sprite_add_weapon("../sprites/weps/sprWepClamShield.png", 	8,	8);
    global.sprWepHUD	= sprite_add("../sprites/weps/sprWepClamShieldHUD.png", 	1,	0,	6);
    global.sprWepHeld	= sprite_add("../sprites/enemies/Seal/sprClamShield.png",	14, 7,	7);
    global.sprWepShine	= sprite_add("../sprites/chests/sprShine64.png",			7,	0,	0);
    global.sprWepLocked = mskNone;
    
    global.lwoWep = {
    	wep : mod_current,
    	
    	my_inst : noone,	// Associated slash
    	my_surf : noone,	// Associated surface
    	
    	length : 20,		// Radial offset
    	height : 5,			// Vertical offset
    	kick : 0,			// Wkick
    	ang : 270,			// Angle of slash
    	myx : 0,			// X coordinate
    	myy : 0,			// Y coordinate
    	
    	last_drawn : 0		// Last frame drawn
    }
	
#macro lwoWep global.lwoWep

#macro surfW 64
#macro surfH 64
#macro surfCenterW floor(surfW / 2)
#macro surfCenterH floor(surfH / 2)

#define weapon_name(w)	
	 // Jsburg's Magic Brain:
	if(instance_is(self, WepPickup) && ((instance_is(other, Player) || instance_is(other, ThrownWep)) && other.wep == w)){
		if(lq_get(w, "wep") == mod_current){
			instance_delete(w.my_inst);
			surface_destroy(w.my_surf);
		}
	}
	 
	 // Name Time:
	return (weapon_avail() ? "CLAM SHIELD" : "LOCKED");
	
#define weapon_text     return "ROYAL GUARD";
#define weapon_auto     return true;
#define weapon_type(w)
     // Return Other Weapon's Ammo Type:
    if(instance_is(self, AmmoPickup) && instance_is(other, Player)){
        with(other) return weapon_get_type((w == wep) ? bwep : wep);
    }
    return 0; // Melee

#define weapon_load     return 30; // 1 Second
#define weapon_area     return (weapon_avail() ? 6 : -1); // 3-2
#define weapon_swap     return sndSwapHammer;
#define weapon_melee	return false;
#define weapon_avail    return unlock_get("coastWep");
#define weapon_sprt(w)	
	if(weapon_avail()){
		if(instance_is(self, Player) && lq_get(w, "wep") == mod_current && surface_exists(w.my_surf)){
			var _l = w.length - w.kick,
				_x = x + lengthdir_x(_l, w.ang) - surfCenterW,
				_y = y + lengthdir_y(_l, w.ang) - surfCenterH + w.height;
			
			d3d_set_fog(true, c_fuchsia, 0, 0);
			draw_sprite_ext(w.my_inst.mask_index, 0, _x + surfCenterW, _y + surfCenterH, 1, 1, w.ang, c_white, 1);
			
			d3d_set_fog(true, c_black, 0, 0);
			for(var i = 0; i < 360; i += 90){
				draw_surface(w.my_surf, _x + lengthdir_x(1, i), _y + lengthdir_y(1, i));
			}
			d3d_set_fog(false, c_white, 0, 0);
			
			if(w.ang < 180 ^^ (!back && wep == w)) draw_surface(w.my_surf, _x, _y);
			
			return mskNone;
		}
		
		 // Default Sprite:
		return global.sprWep;
	}
	
	 // Locked Sprite:
	return global.sprWepLocked;
	
#define weapon_sprt_hud return global.sprWepHUD;

#define weapon_fire(w)
    var f = wepfire_init(w);
    w = f.wep;
	
	 // Effects:
	sound_play_hit(sndCrystalJuggernaut, 0);
	sound_play_hit(sndOasisMelee, 0);
	
	weapon_post(-12, 4, 0);
	sleep(40);
	motion_add(w.ang, 3);
	
	 // Slash:
	var _len = w.length + (20 * skill_get(mut_long_arms)),
		_x = x + lengthdir_x(_len, w.ang),
		_y = y + lengthdir_y(_len, w.ang);
		
	with(instance_create(_x, _y, Slash)){
		creator = other;
		team	= other.team;
		direction = w.ang;
		image_angle = direction;
		image_xscale = 0.3;
		image_yscale = 0.5;
		motion_set(direction, 2 + (3 * skill_get(mut_long_arms)));
	}

#define step(_primary)
    var b = (_primary ? "" : "b"),
        w = variable_instance_get(self, b + "wep");

     // LWO Setup:
    if(!is_object(w)){
        w = lq_clone(lwoWep);
        variable_instance_set(self, b + "wep", w);
    }
    
    var p = self;
    with(w){
	    
	     // Adopt Leader Variables:
	    myx = p.x;
	    myy = p.y;
	    kick = variable_instance_get(p, b + "wkick");
	    
	     // Retarget:
	    var _goalDir = p.gunangle,
	    	_turnSpd = 15,
	    	_angDiff = 0;
	    if(!_primary ^^ (p.race == "steroids" && wep_get(p.wep) != mod_current)){
	    	_goalDir += 180;
	    	_turnSpd = 10;
	    }
	    _angDiff = angle_difference(_goalDir, ang);
	    ang += min(abs(_angDiff), _turnSpd) * sign(_angDiff);
	    ang = (ang + 360) % 360;
			    	
	     // Create Slash:
	    if(!instance_exists(my_inst)){
	    	my_inst = obj_create(myx, myy, "ClamShield");
	    	with(my_inst){
	    		creator = p;
	    		team	= p.team;
	    		wep 	= w;
	    	}
	    }
	    
	     // Slash Code:
	    with(my_inst){
	    	x = w.myx + lengthdir_x(w.length, w.ang);
	    	y = w.myy + lengthdir_y(w.length, w.ang);
	    	direction = w.ang;
	    	image_angle = direction;
	    }
	    
	     // Drawing:
	    if(last_drawn < current_frame){
	    	last_drawn = current_frame;
	    	
	    	if(!surface_exists(my_surf)) my_surf = surface_create(surfW, surfH);
	    	surface_set_target(my_surf);
	    	draw_clear_alpha(c_black, 0);
	    	
	    	var s = global.sprWepHeld,
	    		n = sprite_get_number(s);
	    		
	    	for(var i = 0; i < n; i++){
	    		var _o = 2 * (1 - sqr((i - 4) / (n / 2))),
	    			_ox = 0 + lengthdir_x(_o, ang),
	    			_oy = (i * (3/4) * -1) + lengthdir_y(_o, ang);
	    			
	    		draw_sprite_ext(s, i, surfCenterW + _ox, surfCenterH + _oy, 1.5, 1, ang, c_white, 1);
	    	}
	    	
	    	 // Shining:
	    	draw_set_color_write_enable(1, 1, 1, 0);
	    	draw_sprite(global.sprWepShine, p.gunshine, 0, 0);
	    	draw_set_color_write_enable(1, 1, 1, 1);
	    	
	    	surface_reset_target();
	    	
	    	 // Depth Sorting Fix:
	    	if(ang >= 180 ^^ (_primary && !p.back)) script_bind_draw(draw_held, p.depth - 0.1, (myx + p.hspeed), (myy + p.vspeed), w);
	    }
    }
    
#define draw_held(_x, _y, w)
	if(surface_exists(w.my_surf)){
		var _l = w.length - w.kick;
		
		_x += lengthdir_x(_l, w.ang) - surfCenterW;
		_y += lengthdir_y(_l, w.ang) - surfCenterH + w.height;
		
		d3d_set_fog(true, c_black, 0, 0);
		for(var i = 0; i < 360; i += 90){
			draw_surface(w.my_surf, _x + lengthdir_x(1, i), _y + lengthdir_y(1, i));
		}
		d3d_set_fog(false, c_white, 0, 0);
		
		draw_surface(w.my_surf, _x, _y);
	}
	
	 // Goodbye:
	instance_destroy();

/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'telib', 'unlock_get', _unlock);
#define wepfire_init(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepfire_init', _wep);
#define wepammo_draw(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_draw', _wep);
#define wepammo_fire(_wep)                                                              return  mod_script_call(   'mod', 'telib', 'wepammo_fire', _wep);
#define wep_get(_wep)                                                                   return  mod_script_call(   'mod', 'telib', 'wep_get', _wep);