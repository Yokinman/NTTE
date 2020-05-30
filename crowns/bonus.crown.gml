#define init
	global.sprCrownIcon	   = sprite_add("../sprites/crowns/Bonus/sprCrownBonusIcon.png",     1, 12, 16);
	global.sprCrownIdle	   = sprite_add("../sprites/crowns/Bonus/sprCrownBonusIdle.png",    15,  8,  8);
	global.sprCrownWalk	   = sprite_add("../sprites/crowns/Bonus/sprCrownBonusWalk.png",     6,  8,  8);
	global.sprCrownLoadout = sprite_add("../sprites/crowns/Bonus/sprCrownBonusLoadout.png",  2, 16, 16);
	
#define crown_name        return "CROWN OF BONUS";
#define crown_text        return "@bBONUS PICKUPS#@sLOWER @wDROP RATE";
#define crown_tip         return "ALL EXTRA";
#define crown_avail       return (GameCont.loops <= 0);//unlock_get(`crown:${mod_current}`);
#define crown_menu_avail  return unlock_get(`loadout:crown:${mod_current}`);
#define crown_loadout     return global.sprCrownLoadout;

#define crown_menu_button
	sprite_index = crown_loadout();
	image_index = !crown_menu_avail();
	dix = -1;
	diy = 1;
	
#define crown_button
	sprite_index = global.sprCrownIcon;
	
#define crown_object
	 // Visual:
	spr_idle = global.sprCrownIdle;
	spr_walk = global.sprCrownWalk;
	sprite_index = spr_idle;
	
	 // Sound:
	if(instance_is(other, CrownIcon)){
		sound_play_pitch(sndCrownProtection, 0.9);
		sound_play_pitchvol(sndRogueCanister, 0.7, 1.4);
	}
	
#define step
	script_bind_step(post_step, 0);
	
#define post_step
	instance_destroy();
	
	 // Only Bonus Ammo/HP:
	if(!instance_exists(GenCont) && !instance_exists(MenuGen)){
		 // Ammo:
		with(instances_matching(AmmoPickup, "sprite_index", sprAmmo)){
			var _num = 0;
			
			 // Get Average Bonus Ammo:
			with(instances_matching_gt(Player, "bonus_ammo", 0)){
				_num += bonus_ammo;
			}
			_num /= instance_number(Player);
			
			 // Chance to Spawn:
			if(chance(1, _num / 48)){
				obj_create(x, y, "BonusAmmoPickup");
			}
			
			instance_delete(id);
		}
		with(instances_matching(AmmoChest, "sprite_index", sprAmmoChest, sprAmmoChestSteroids, sprAmmoChestMystery, sprIDPDChest)){
			chest_create(x, y, "BonusAmmoChest");
			instance_delete(id);
		}
		with(instances_matching(Mimic, "spr_idle", sprMimicIdle)){
			chest_create(x, y, "BonusAmmoMimic");
			instance_delete(id);
		}
		
		 // Health:
		with(instances_matching(HPPickup, "sprite_index", sprHP)){
			var _num = 0;
			
			 // Get Average Bonus Ammo:
			with(instances_matching_gt(Player, "bonus_health", 0)){
				_num += bonus_health;
			}
			_num /= instance_number(Player);
			
			 // Chance to Spawn:
			if(chance(1, _num / 4)){
				obj_create(x, y, "BonusHealthPickup");
			}
			
			instance_delete(id);
		}
		with(instances_matching(HealthChest, "sprite_index", sprHealthChest)){
			chest_create(x, y, "BonusHealthChest");
			instance_delete(id);
		}
		with(instances_matching(SuperMimic, "spr_idle", sprSuperMimicIdle)){
			chest_create(x, y, "BonusHealthMimic");
			instance_delete(id);
		}
	}
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define chest_create(_x, _y, _obj)                                                      return  mod_script_call_nc('mod', 'telib', 'chest_create', _x, _y, _obj);