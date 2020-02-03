#define init
	global.sprCrownIcon	   = sprite_add("../sprites/crowns/Bonus/sprCrownBonusIcon.png",     1, 12, 16);
	global.sprCrownIdle	   = sprite_add("../sprites/crowns/Bonus/sprCrownBonusIdle.png",    15,  8,  8);
	global.sprCrownWalk	   = sprite_add("../sprites/crowns/Bonus/sprCrownBonusWalk.png",     6,  8,  8);
	global.sprCrownLoadout = sprite_add("../sprites/crowns/Bonus/sprCrownBonusLoadout.png",  2, 16, 16);
	
#define crown_name      	return "CROWN OF BONUS";
#define crown_text      	return "@bBONUS PICKUPS#@sLOWER @wDROP RATE";
#define crown_tip       	return "ALL EXTRA";
#define crown_avail     	return (GameCont.loops <= 0);//unlock_get("lairCrown");
#define crown_menu_avail	return true;//unlock_get("crownBonus");

#define crown_menu_button
    sprite_index = global.sprCrownLoadout;
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
	script_bind_step(step_post, 0);
	
#define step_post
	instance_destroy();
	
	 // Only Bonus Ammo/HP:
	if(!instance_exists(GenCont) && !instance_exists(MenuGen)){
		 // Overheal:
		with(instances_matching(HPPickup, "sprite_index", sprHP)){
			if(chance(1, 2)){
				obj_create(x, y, "OverhealPickup");
			}
			instance_delete(id);
		}
		with(instances_matching(HealthChest, "sprite_index", sprHealthChest)){
			obj_create(x, y, "OverhealChest");
			instance_delete(id);
		}
		with(instances_matching(SuperMimic, "spr_idle", sprSuperMimicIdle)){
			obj_create(x, y, "OverhealMimic");
			instance_delete(id);
		}
		
		 // Overstock:
		with(instances_matching(AmmoPickup, "sprite_index", sprAmmo, sprCursedAmmo)){
			 // Get Average Bonus Ammo:
			var _ammoBonus = 0;
			with(instances_matching_gt(Player, "ammo_bonus", 0)){
				_ammoBonus += ammo_bonus;
			}
			_ammoBonus /= instance_number(Player);
			
			 // Chance to Spawn:
			var _chance = 50 - min(40, (_ammoBonus / 3) - (15 * skill_get(mut_rabbit_paw)));
			if(chance(_chance, 100)){
				obj_create(x, y, "OverstockPickup");
			}
			
			instance_delete(id);
		}
		with(instances_matching(AmmoChest, "sprite_index", sprAmmoChest, sprAmmoChestSteroids, sprAmmoChestMystery, sprIDPDChest)){
			obj_create(x, y, "OverstockChest");
			instance_delete(id);
		}
		with(instances_matching(Mimic, "spr_idle", sprMimicIdle)){
			obj_create(x, y, "OverstockMimic");
			instance_delete(id);
		}
	}
	
	
/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'telib', 'unlock_get', _unlock);
