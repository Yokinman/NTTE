#define init
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprRogueCarbine.png", 8, 5);
	global.sprWepLocked = mskNone;
	
#define weapon_name   return "CARBINE";
#define weapon_text   return "THERE'S NO TALKING TO THEM";
#define weapon_swap   return sndSwapMachinegun;
#define weapon_sprt   return global.sprWep;
#define weapon_area   return -1;
#define weapon_type   return type_bullet;
#define weapon_cost   return 4;
#define weapon_load   return 6; // 0.4 Seconds
#define weapon_melee  return false;

#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Burst Fire:
	if(fork()){
		repeat(2) {
			with(projectile_create(
				x,
				y,
				"CustomBullet",
				gunangle + (orandom(2) * accuracy),
				16
			)) {
				name = "PopoHeavyBullet";
				
				 // Sprites:
				sprite_index = spr.PopoHeavyBullet;
				spr_dead     = spr.PopoHeavyBulletHit;
				
				 // On-hit variables:
				damage = 7;
				force  = 12;
				
				on_hit = script_ref_create(PopoHeavyBullet_hit);
			}
			
			 // Sounds:
			sound_play_pitch(sndHeavyMachinegun, 1.4 + random(0.2));
			sound_play_pitch(sndRogueRifle,      0.6 + random(0.5));
			sound_play_pitch(sndGruntFire,       0.6 + random(0.2));
			sound_play_pitch(sndIDPDNadeLoad,    2.4 + random(0.4));
			
			
			 // Effects:
			weapon_post(4, 3, 4);
			with(instance_create(x, y, Shell)) {
				sprite_index = sprHeavyShell;
				motion_add(other.gunangle - 90 + orandom(20), 4 + random(3));
			}
			
			
			 // Delay:
			wait(2);
			if(!instance_exists(self)){
				break;
			}
		}
		exit;
	}
	
#define PopoHeavyBullet_hit
	projectile_hit_push(other, damage, force);
	
	var _gland = skill_get(mut_recycle_gland) + (10 * skill_get("recycleglandx10"));
	if(chance(60 + _gland, 100)) {
		instance_create(x, y, RecycleGland);
		sound_play(sndRecGlandProc);
		with(creator) if(instance_is(self, Player)) {
			ammo[1] = min(ammo[1] + 2, typ_amax[1]);
		}
	}
	
	 // Goodbye:
	with(instance_create(x, y, BulletHit)){
		sprite_index = other.spr_dead;
	}
	instance_destroy();
	

/// SCRIPTS
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  spr 																					mod_variable_get("mod", "teassets", "spr");
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define projectile_create(_x, _y, _obj, _dir, _spd)                                     return  mod_script_call_self('mod', 'telib', 'projectile_create', _x, _y, _obj, _dir, _spd);
#define weapon_fire_init(_wep)                                                          return  mod_script_call     ('mod', 'telib', 'weapon_fire_init', _wep);
#define weapon_ammo_fire(_wep)                                                          return  mod_script_call     ('mod', 'telib', 'weapon_ammo_fire', _wep);
#define weapon_ammo_hud(_wep)                                                           return  mod_script_call     ('mod', 'telib', 'weapon_ammo_hud', _wep);
#define weapon_get_red(_wep)                                                            return  mod_script_call_self('mod', 'telib', 'weapon_get_red', _wep);
#define wep_raw(_wep)                                                                   return  mod_script_call_nc  ('mod', 'telib', 'wep_raw', _wep);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);