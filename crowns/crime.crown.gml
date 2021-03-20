#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprCrownIcon	   = sprite_add("../sprites/crowns/Crime/sprCrownCrimeIcon.png",     1, 12, 16);
	global.sprCrownIdle	   = sprite_add("../sprites/crowns/Crime/sprCrownCrimeIdle.png",    20,  8,  8);
	global.sprCrownWalk	   = sprite_add("../sprites/crowns/Crime/sprCrownCrimeWalk.png",     6,	 8,  8);
	global.sprCrownLoadout = sprite_add("../sprites/crowns/Crime/sprCrownCrimeLoadout.png",  2, 16, 16);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr

#define crown_name        return "CROWN OF CRIME";
#define crown_text        return "FIND @wSMUGGLED GOODS#@sA @rPRICE @sON YOUR HEAD";
#define crown_tip         return choose("THE @wFAMILY@s DOESN'T FORGIVE", "THE @rBAT'S@s EXPERIMENTS", "THE @rCAT'S@s RESOURCES", "THE WASTELAND WEAPON TRADE");
#define crown_unlock      return "STOLEN FROM THIEVES";
#define crown_avail       return (unlock_get(`crown:${mod_current}`) && GameCont.loops <= 0);
#define crown_menu_avail  return unlock_get(`loadout:crown:${mod_current}`);
#define crown_loadout     return global.sprCrownLoadout;
#define crown_ntte_pack   return "crown";

#define crown_sound
	var _snd = sound_play_gun(sndBigWeaponChest, 0, 0.3);
	audio_sound_pitch(_snd, 0.2);
	audio_sound_gain(_snd,  1.5, 0);
	return sndCrownLove;
	
#define crown_menu_button
	sprite_index = crown_loadout();
	image_index  = !crown_menu_avail();
	dix          = -1;
	diy          = 0;
	
#define crown_button
	sprite_index = global.sprCrownIcon;
	
#define crown_object
	 // Visual:
	spr_idle     = global.sprCrownIdle;
	spr_walk     = global.sprCrownWalk;
	sprite_index = spr_idle;
	
	 // Vars:
	ntte_crown = mod_current;
	enemy_time = 0;
	enemies    = 0;
	
	 // Sound:
	if(instance_is(other, CrownIcon)){
		sound_play_gun(crown_sound(), 0, 0.3);
	}
	
#define step
	 // Bounty Hunters:
	if(!(GameCont.area == 7 && GameCont.subarea == 3)){
		with(instances_matching(Crown, "ntte_crown", "crime")){
			 // Spawn Enemies:
			if(enemies > 0){
				enemy_time -= current_time_scale;
				
				if(enemy_time <= 0){
					var	_spawnX = x,
						_spawnY = y,
						_spawnDis = 240,
						_spawnDir = random(360);
						
					with(instance_furthest(_spawnX - 16, _spawnY - 16, Floor)){                                                                           
						_spawnDir = point_direction((bbox_left + bbox_right + 1) / 2, (bbox_top + bbox_bottom + 1) / 2, _spawnX, _spawnY);
					}
					
					 // Effects:
					var	l = 4,
						d = _spawnDir;
						
					with(instance_create(x + lengthdir_x(l, d), y + 8 + lengthdir_y(l, d), AssassinNotice)){
						hspeed = other.hspeed;
						vspeed = other.vspeed;
						motion_add(d, 2);
						friction = 0.2;
						depth = -9;
					}
					repeat(3) with(instance_create(x, y, Smoke)){
						image_xscale /= 2;
						image_yscale /= 2;
						hspeed += other.hspeed / 2;
						vspeed += other.vspeed / 2;
					}
					sound_play_pitch(sndIDPDNadeAlmost, 0.8);
					
					 // Spawn:
					var _pool = [
						[Gator,         5],
						["BabyGator",   2],
						[BuffGator,     3 * (GameCont.hard >= 4)],
						["BoneGator",   3 * (GameCont.hard >= 6)],
						["AlbinoGator", 2 * (GameCont.hard >= 8)]
					];
					while(enemies > 0){
						enemies--;
						
						portal_poof();
						
						with(top_create(_spawnX, _spawnY, pool(_pool), _spawnDir, _spawnDis)){
							jump_time = 1;
							idle_time = 0;
							
							_spawnX = x;
							_spawnY = y;
							_spawnDir = random(360);
							_spawnDis = -1;
							
							with(target){
								 // Type-Specific:
								switch(object_index){
									case "BabyGator":
										 // Babies Stick Together:
										var n = 1 + irandom(1 + GameCont.loops);
										repeat(n) with(top_create(x, y, "BabyGator", random(360), -1)){
											jump_time = 1;
										}
										break;
										
									case FastRat: // maybe?
										 // The Horde:
										var n = 3 + irandom(3 + GameCont.loops);
										repeat(n) with(top_create(x, y, FastRat, random(360), -1)){
											jump_time = 1;
										}
										
										 // Large and in Charge:
										with(top_create(x, y, RatkingRage, random(360), -1)){
											jump_time = 1;
										}
										break;
								}
								
								 // Poof:
								repeat(3){
									with(instance_create(x + orandom(8), y + orandom(8), Dust)){
										depth = other.depth - 1;
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
#define crime_alert(_x, _y)
	/*
		Displays the Crown of Crime's current bounty level near the given position
	*/
	
	var _target = noone;
	
	 // Target Nearby Crown:
	if(instance_exists(Crown)){
		var _disMax = 1/0;
		with(instances_matching(Crown, "visible", true)){
			var _dis = point_distance(x, y, _x, _y);
			if(_dis < _disMax){
				if(point_in_rectangle(x, y, _x - 160, _y - 128, _x + 160, _y + 128)){
					_disMax = _dis;
					_target = self;
				}
			}
		}
	}
	
	 // Target Player:
	if(!instance_exists(_target) && instance_exists(Player)){
		_target = instance_nearest(_x, _y, Player);
	}
	
	 // Create Alert:
	with(_target){
		if("ntte_crime_alert" not in self || !instance_exists(ntte_crime_alert)){
			ntte_crime_alert = alert_create(self, spr.CrimeBountyAlert);
			with(ntte_crime_alert){
				flash = 6;
			}
		}
		with(ntte_crime_alert){
			sprite_index = (variable_instance_get(GameCont, "ntte_crime_active", false) ? spr.CrimeBountyActiveAlert : spr.CrimeBountyAlert);
			image_index  = clamp(variable_instance_get(GameCont, "ntte_crime_bounty", 0), 0, image_number - 1);
			image_speed  = 0;
			visible      = true;
			depth        = -7;
			alert        = {};
			blink        = 30;
			alarm0       = 120;
			snd_flash    = sndAppear;
		}
		return ntte_crime_alert;
	}
	
	return noone;
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc  ('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define top_create(_x, _y, _obj, _spawnDir, _spawnDis)                                  return  mod_script_call_nc  ('mod', 'telib', 'top_create', _x, _y, _obj, _spawnDir, _spawnDis);
#define portal_poof()                                                                   return  mod_script_call_nc  ('mod', 'telib', 'portal_poof');
#define pool(_pool)                                                                     return  mod_script_call_nc  ('mod', 'telib', 'pool', _pool);
#define alert_create(_inst, _sprite)                                                    return  mod_script_call_self('mod', 'telib', 'alert_create', _inst, _sprite);