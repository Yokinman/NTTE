#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep            = spr.Tunneller;
	global.sprWepGold        = spr.GoldTunneller;
	global.sprWepLoadout     = spr.TunnellerLoadout;
	global.sprWepGoldLoadout = spr.GoldTunnellerLoadout;
	global.sprWepHUD         = spr.TunnellerHUD;
	global.sprWepHUDRed      = spr.TunnellerHUDRed;
	global.sprWepLocked      = sprTemp;
	
	 // LWO:
	global.lwoWep = {
		"wep"      : mod_current,
		"gold"     : false,
		"chrg"     : false,
		"chrg_num" : 0,
		"chrg_max" : 15
	};
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr

#define weapon_name(_wep)     return (weapon_avail(_wep) ? ((weapon_gold(_wep) != 0) ? "GOLDEN " : "") + "TUNNELLER" : "LOCKED");
#define weapon_text(_wep)     return ((weapon_gold(_wep) != 0) ? choose("GOLDEN GOD", `@(color:${call(scr.area_get_back_color, "red")})KEY @sTO THE @wMULTIVERSE`) : choose(`@wUNLOCK @sTHE @(color:${call(scr.area_get_back_color, "red")})CONTINUUM`, "FULL CIRCLE", `YET ANOTHER @(color:${call(scr.area_get_back_color, "red")})RED KEY`));
#define weapon_sprt(_wep)     return (weapon_avail() ? ((weapon_gold(_wep) == 0) ? global.sprWep : global.sprWepGold) : global.sprWepLocked);
#define weapon_loadout(_wep)  return ((argument_count > 0 && weapon_gold(_wep) != 0) ? global.sprWepGoldLoadout : global.sprWepLoadout);
#define weapon_area(_wep)     return ((argument_count > 0 && weapon_avail(_wep) && weapon_gold(_wep) == 0) ? 22 : -1); // L1 3-1
#define weapon_gold(_wep)     return ((argument_count > 0 && lq_defget(_wep, "gold", false)) ? -1 : 0);
#define weapon_load           return 24; // 0.8 Seconds
#define weapon_burst(_wep)    return ((lq_defget(_wep, "chrg", false) || lq_defget(_wep, "chrg_num", 0) >= lq_defget(_wep, "chrg_max", 1)) ? 1 : 3);
#define weapon_burst_time     return 4; // 0.13 Seconds
#define weapon_auto           return true;
#define weapon_melee          return false;
#define weapon_avail          return call(scr.unlock_get, "pack:" + weapon_ntte_pack());
#define weapon_ntte_pack      return "red";
#define weapon_shrine         return [mut_long_arms, mut_laser_brain];
#define weapon_red            return 1;
#define weapon_chrg(_wep)     return (argument_count > 0 && "red_ammo" in self && red_ammo >= call(scr.weapon_get, "red", _wep));

#define weapon_type
	 // Weapon Pickup Ammo Outline:
	if(instance_is(self, WepPickup) && instance_is(other, WepPickup)){
		if(image_index > 1 && ammo > 0){
			for(var i = 0; i < 360; i += 90){
				draw_sprite_ext(sprite_index, 1, x + dcos(i), y - dsin(i), 1, 1, rotation, image_blend, image_alpha);
			}
		}
	}
	
	 // Type:
	return type_melee;
	
#define weapon_sprt_hud(_wep)
	 // Normal Outline:
	if(
		weapon_get_gold(_wep) != 0 ||
		weapon_get_rads(_wep) > 0  ||
		(instance_is(self, Player) && ((wep == _wep && curse > 0) || (bwep == _wep && bcurse > 0)))
	){
		return global.sprWepHUD;
	}
	
	 // Red Outline:
	return global.sprWepHUDRed;
	
#define weapon_swap
	sound_set_track_position(
		sound_play_pitchvol(sndHyperCrystalChargeExplo, 0.6, 0.5),
		1.55
	);
	return sndSwapSword;
	
#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	var _charge = (_wep.chrg_num / _wep.chrg_max);
	
	 // Charging:
	if(_wep.chrg){
		 // Pullback:
		var _kick = -8 * _charge;
		if(wkick != _kick){
			weapon_post(_kick, 8 * _charge * current_time_scale, 0);
		}
		
		 // Effects:
		if((current_frame % 5) < current_time_scale){
			var	_l = random(16) - wkick,
				_d = gunangle + (wepangle * (1 - (wkick / 20)));
				
			call(scr.obj_create, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "CrystalBrainEffect");
		}
		if(_wep.chrg == 1){
			 // Sound:
			sound_set_track_position(
				sound_play_pitchvol(sndHyperCrystalChargeExplo, 0.4 + (0.2 * _charge), 0.5),
				1.55
			);
			sound_play_pitchvol(sndCrystalTB, 1 / (1 - (0.25 * _charge)), 1);
			
			 // Full:
			if(_charge >= 1){
				 // Sound:
				sound_play_pitch(sndGoldUnlock,        2.5 + orandom(0.2));
				sound_play_pitch(sndCrystalJuggernaut, 2);
				
				 // Flash:
				var	_l = 24,
					_d = gunangle + wepangle;
					
				with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), PlasmaTrail)){
					sprite_index = sprThrowHit;
					image_speed  = 0.4;
					image_angle  = random(360);
					image_blend  = call(scr.area_get_back_color, "red");
					depth        = other.depth - 1;
					with(instance_create(x, y, PlasmaTrail)){
						sprite_index = other.sprite_index;
						image_speed  = 1;
						image_angle  = other.image_angle;
						depth        = other.depth - 1;
					}
				}
				view_shake_at(x, y, 10);
				sleep(5);
			}
		}
	}
	
	 // Fire:
	else{
		 // Red:
		var _cost = call(scr.weapon_get, "red", _wep);
		if(_charge >= 1 && "red_ammo" in _fire.creator && _fire.creator.red_ammo >= _cost && _fire.burst == 1){
			_fire.creator.red_ammo -= _cost;
			
			var _skill = skill_get(mut_laser_brain);
			
			 // Chaos Ball:
			with(call(scr.projectile_create, x, y, "CrystalHeartBullet", gunangle + orandom(4 * accuracy), 4)){
				image_xscale += 0.15 * _skill;
				image_yscale += 0.15 * _skill;
				
				 // Area:
				area_goal  = irandom_range(8, 12)/* + (4 * _skill)*/ + (4 * (weapon_gold(_wep) != 0));
				area_chaos = chance(1, 2);
				area_chest = [];
				
				 // No Guarantees:
				if(chance(3, 5)){
					var _type = "normal";
					if(chance(1, 10)){
						_type = call(scr.pool, {
							"mutation" : 1,
							"orchid"   : call(scr.save_get, "orchid:seen", false),
							"lair"     : call(scr.unlock_get, "crown:crime")
						});
					}
					switch(_type){
						
						case "mutation":
							
							area_chest = [call(scr.pool, [
								["SpiritChest",     1],
								["HammerHeadChest", 1]
							])];
							
							break;
							
						case "orchid":
							
							area_chest_pos = "random";
							area_chest     = array_create(irandom_range(1, 4), "OrchidChest");
							
							break;
							
						case "lair":
							
							area_chest = call(scr.pool, [
								[["CatChest", "BatChest"], 2],
								[["CatChest", "RatChest"], 1],
								[["BatChest", "RatChest"], 1]
							]);
							
							break;
							
						default:
							
							area_chest = [call(scr.pool, [
								[AmmoChest,          5],
								[WeaponChest,        5],
								["Backpack",         3],
								["BonusAmmoChest",   2],
								["BonusHealthChest", 2]
							])];
							
					}
				}
				
				 // Bonus Chance of Red Ammo:
				if(chance(1, 15)){
					array_push(area_chest, "RedAmmoChest");
				}
				
				 // Default:
				if(!array_length(area_chest)){
					array_push(area_chest, RadChest);
				}
				
				 // Open Mind:
				var _mind = round(skill_get(mut_open_mind));
				if(_mind != 0){
					var _chestNum = array_length(area_chest);
					repeat(abs(_mind)){
						if(_mind > 0){
							array_push(area_chest, area_chest[irandom(_chestNum - 1)]);
						}
						else if(_chestNum > 0){
							area_chest = call(scr.array_delete, area_chest, irandom(_chestNum - 1));
							_chestNum--;
						}
						else break;
					}
				}
				
				 // Effect:
				with(instance_create(x, y, ThrowHit)){
					image_blend = call(scr.area_get_back_color, other.area);
				}
			}
			
			 // Sounds:
			var _pitch = random_range(0.8, 1.2);
			sound_play_pitch(sndHyperCrystalSearch, ((_skill > 0) ? 1.2 : 1.4) * _pitch);
			sound_play_pitch(((weapon_gold(_wep) == 0) ? sndUltraGrenade : sndGoldPlasmaUpg), 1.0 * _pitch);
			sound_play_pitch(sndGammaGutsKill, 1.4 * _pitch);
			sound_set_track_position(
				sound_play_pitch(((_skill > 0) ? sndDevastatorUpg : sndDevastator), 0.8 * _pitch),
				0.6
			);
			
			 // Effects:
			weapon_post(12, 24, 12);
			motion_add(gunangle + 180, 4);
			move_contact_solid(gunangle + 180, 4);
			if(_skill > 0 && _cost > 0){
				repeat(_cost){
					with(instance_create(x, y, LaserBrain)){
						creator = other;
					}
				}
			}
			sleep(20);
		}
		
		 // Normal:
		else{
			var	_skill = skill_get(mut_long_arms),
				_dis   = 10 * _skill,
				_dir   = gunangle;
				
			 // Shank:
			with(call(scr.projectile_create,
				x + lengthdir_x(_dis, _dir),
				y + lengthdir_y(_dis, _dir),
				"RedShank",
				_dir + orandom(10 * accuracy),
				lerp(3, 6, _skill)
			)){
				if(weapon_gold(_wep) != 0){
					sprite_index = spr.RedShankGold; // it's awesome
				}
			}
			
			 // Sounds:
			sound_play_gun(((weapon_gold(_wep) == 0) ? sndScrewdriver : sndGoldScrewdriver), 0.2, 0.6);
			sound_set_track_position(
				sound_play_pitchvol(sndHyperCrystalChargeExplo, 1 + random(0.5), 0.4),
				1.5
			);
			
			 // Effects:
			weapon_post(-9, 8, 2);
			motion_add(_dir, 3);
		}
	}
	
	
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