#define init
	spr = mod_variable_get("mod", "teassets", "spr");

	global.sprCrownIcon	   = sprite_add("../sprites/crowns/Bonus/sprCrownBonusIcon.png",		1, 12, 16);
	global.sprCrownIdle	   = sprite_add("../sprites/crowns/Bonus/sprCrownBonusIdle.png",	 15,  8,  8);
	global.sprCrownWalk	   = sprite_add("../sprites/crowns/Bonus/sprCrownBonusWalk.png",		6,	 8,	8);
	global.sprCrownLoadout = sprite_add("../sprites/crowns/Bonus/sprCrownBonusLoadout.png", 2, 16, 16);

#define crown_name			return "CROWN OF BONUS";
#define crown_text			return "@yPICKUPS @sARE @wBETTER# @sBUT SCARCE";
#define crown_tip			return "ALL EXTRA";
#define crown_avail			return true;//unlock_get("lairCrown");
#define crown_menu_avail	return true;//unlock_get("crownBonus");

#define crown_menu_button
    sprite_index = global.sprCrownLoadout;
    image_index = !crown_menu_avail();
    dix = 3;
    diy = -1;

#define crown_button
	sprite_index = global.sprCrownIcon;

#define crown_object
	 // Visual:
	spr_idle = global.sprCrownIdle;
	spr_walk = global.sprCrownWalk;
	sprite_index = spr_idle;

	 // Sound:
	if(instance_exists(CrownIcon)){
		if(fork()){
			wait 0;
			if(!instance_exists(CrownIcon)){
				sound_play_pitch(sndCrownLove, 0.95);
			}
			exit;
		}
	}

#define step
	if !instance_exists(GenCont)
	{
		 // Only Bonus Ammo/HP:
		 with(instances_matching(CustomObject, "sprite_index", spr.CursedAmmoChest)){
 			obj_create(x, y, "OverstockChest");
 			instance_delete(id);
 		}
		with(instances_matching(AmmoChest, "sprite_index", sprIDPDChest)){
			obj_create(x, y, "OverstockChest");
			instance_delete(id);
		}
		with(instances_matching(AmmoChest, "sprite_index", sprAmmoChest, sprAmmoChestSteroids, sprAmmoChestMystery)){
			obj_create(x, y, "OverstockChest");
			instance_delete(id);
		}
		with(instances_matching(HealthChest, "sprite_index", sprHealthChest)){
			obj_create(x, y, "OverhealChest");
			instance_delete(id);
		}
	}
	with(instances_matching(HPPickup, "sprite_index", sprHP)){
		if (!irandom(2)) obj_create(x, y, "OverstockPickup");
		instance_delete(id);
	}
	with(instances_matching(AmmoPickup, "sprite_index", sprAmmo, sprCursedAmmo)){
		var _ammo_bonus = 0,
				_mult       = 0,
				_chance     = 50;
		for (var i = 0; i < maxp; i++){
			with instances_matching_gt(Player, "ammo_bonus", 0){
				_ammo_bonus += ammo_bonus;
				_mult++;
			}
		}
		_chance += min(39, 39 * ((_ammo_bonus / _mult) / 120) - (skill_get(mut_rabbit_paw) * 15));
		if (irandom(99) > _chance) obj_create(x, y, "OverstockPickup");
		instance_delete(id);
	}

	 // Give Mimics a new paint job:
	with instances_matching(Mimic, "spr_idle", sprMimicIdle){
		obj_create(x, y, "OverstockMimic");
		instance_delete(id);
	}
	with instances_matching(SuperMimic, "spr_idle", sprSuperMimicIdle){
		obj_create(x, y, "OverhealMimic");
		instance_delete(id);
	}

/// Scripts
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'telib', 'unlock_get', _unlock);
