#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = spr.UltraQuasarBlaster; // sprite_add_weapon("../sprites/weps/sprUltraQuasarBlaster.png", 20, 12);
	global.sprWepLocked = sprTemp;
	
	 // LWO:
	global.lwoWep = {
		"wep" : mod_current
	};
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name         return (weapon_avail() ? "ULTRA QUASAR BLASTER" : "LOCKED");
#define weapon_text         return choose("THE GREEN SUN", "ROCKET POWERED RECOIL DAMPENING");
#define weapon_swap         return sndSwapEnergy;
#define weapon_sprt         return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area         return -1; // Doesn't spawn naturally
#define weapon_type         return type_energy;
#define weapon_cost(_wep)   return 12;
#define weapon_rads(_wep)   return 42;
#define weapon_load(_wep)   return 50;
#define weapon_auto         return false;
#define weapon_avail        return call(scr.unlock_get, "pack:" + weapon_ntte_pack());
#define weapon_ntte_pack    return "trench";
#define weapon_ntte_quasar  return true;

#define weapon_ntte_eat
	if(!instance_is(self, Portal)){
		
		 // I guess robots really can eat anything, wow:
		with(call(scr.projectile_create, x, y, "QuasarRing", gunangle)){
			image_yscale   = 0;
			sprite_index   = spr.UltraQuasarBeam;
			spr_trail	   = spr.UltraQuasarBeamTrail;
			follow_creator = true;
			ultra		   = true;
			scale_goal     = 1;
			ring_size      = 1.2 * power(1.2, skill_get(mut_laser_brain));
			shrink_delay   = 300;
		}
		
		 // Debris:
		var _spr = spr.UltraQuasarBlasterEat;
		for(var _img = 0; _img < sprite_get_number(_spr); _img++){
			with(instance_create(x, y, ScrapBossCorpse)){
				motion_set(random(360), 4 + random(4));
				sprite_index = _spr;
				image_index  = _img;
				image_angle  = random(360);
			}
		}
		
		 // Sounds:
		sound_play_pitch(sndUltraLaserUpg, 0.4 + random(0.1));
		sound_play_pitch(sndPlasmaHugeUpg, 1.2 + random(0.2));
		sound_play(sndMutant8Thrn);
	}

#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	var o = 30;
	for(var i = -2; i <= 2; i++){
		var d = gunangle + (o * i) * accuracy;
		with(call(scr.projectile_create, x, y, "UltraQuasarBeam", d)){
			image_yscale = 0;
			scale_goal   = 0.8;
			offset_dis   = 16;
			offset_ang   = angle_difference(other.gunangle, d);
			shrink_delay = 30;
		}
	}
	
	 // Sound:
	var _brain = skill_get(mut_laser_brain);
	sound_play_pitch((_brain ? sndUltraLaserUpg : sndUltraLaser), 0.4 + random(0.1));
	sound_play_pitch((_brain ? sndPlasmaUpg     : sndPlasma),     1.2 + random(0.2));
	sound_play_pitchvol(sndExplosion, 1.5, 0.5);
	
	 // Effects:
	weapon_post(32, -16, 32);
	motion_add(gunangle + 180, 4);
	move_contact_solid(direction, speed);
	
	
/// SCRIPTS
#macro  call                                                                                    script_ref_call
#macro  obj                                                                                     global.obj
#macro  scr                                                                                     global.scr
#macro  spr                                                                                     global.spr
#macro  snd                                                                                     global.snd
#macro  msk                                                                                     spr.msk
#macro  mus                                                                                     snd.mus
#macro  lag                                                                                     global.debug_lag
#macro  ntte                                                                                    global.ntte_vars
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  current_frame_active                                                                    ((current_frame + global.epsilon) % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        if(((_primary ? '' : 'b') + _name) in self) variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);