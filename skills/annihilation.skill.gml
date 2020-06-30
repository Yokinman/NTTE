#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	
	 // Sprites:
	global.sprSkillHUD = sprite_add("../sprites/skills/Annihilation/sprSkillAnnihilationHUD.png", 1, 9, 9);
	
#macro spr global.spr

#macro annihilation_list variable_instance_get(GameCont, "annihilation_list", [])

#define skill_name   return "ANNIHILATION";
#define skill_icon   return global.sprSkillHUD;
#define skill_avail  return false;

#define skill_text
	var	_text = `@(color:${area_get_back_color("red")})DESTROY`,
		_list = [];
		
	 // Get Annihilated Enemies:
	with(annihilation_list){
		array_push(_list, " @w" + string_upper(text));
	}
	
	 // Compile Text:
	var _max = array_length(_list);
	if(_max > 0){
		_text += "S @sALL";
		
		 // Enemy List:
		if(_max > 1){
			_list[_max - 1] = " @sAND" + _list[_max - 1];
			if(_max == 2){
				_text += "#";
			}
			else for(var i = 1; i < _max; i += 2){
				_list[i] = "#" + _list[i];
			}
		}
		_text += array_join(_list, ((_max > 2) ? "," : "")) + "#@s";
		
		 // Duration:
		var _num = skill_get(mod_current);
		if(_num > 2){
			_text += `FOR THE NEXT @w${_num - 1} LEVELS`;
		}
		else if(_num > 1){
			_text += "THROUGH THE @wNEXT LEVEL";
		}
		else{
			_text += "UNTIL THE @wNEXT LEVEL";
		}
	}
	
	return _text;
	
#define skill_tip
	var _text = choose("GOODBYE", "SO LONG", "FAREWELL");
	
	if(array_length(annihilation_list) > 0){
		_text += ", " + `@(color:${area_get_back_color("red")})` + annihilation_list[irandom(array_length(annihilation_list) - 1)].text;
	}
	
	return _text;
	
#define skill_lose
	GameCont.annihilation_list = [];
	
#define step
	 // Reduce Counters Between Levels:
	with(instances_matching(GenCont, "annihilation_check", null)){
		annihilation_check = true;
		
		var _num = 0;
		
		with(annihilation_list){
			if(ammo > 0 && --ammo <= 0){
				GameCont.annihilation_list = mod_script_call_nc("mod", "telib", "array_delete_value", annihilation_list, self);
			}
			_num = max(_num, ammo);
		}
		
		if(skill_get(mod_current) > 0){
			skill_set(mod_current, max(0, _num));
		}
	}
	
	 // Kill:
	with(annihilation_list){
		with(instances_matching((custom ? instances_matching(object_index, "name", name) : object_index), "annihilation_check", null)){
			annihilation_check = true;
			
			 // Less Rads:
			if("raddrop" in self){
				raddrop = round(raddrop / 2);
			}
			
			 // Annihilate:
			with(obj_create(x + orandom(1), y + orandom(1), "RedExplosion")){
				target = other;
				other.nexthurt = 0;
				damage = min(damage, max(10, other.my_health));
				event_perform(ev_collision, other.object_index);
			}
		}
	}
	
#define enemy_annihilate(_inst, _num)
	/*
		Kills a given enemy for a given numbers of levels, only takes an instance argument right now
	*/
	
	if("annihilation_list" not in GameCont){
		GameCont.annihilation_list = [];
	}
	
	 // Add Enemy Info to List:
	with(_inst){
		with({
			"object_index" : object_index,
			"custom"       : (string_pos("Custom", object_get_name(object_index)) == 1),
			"name"         : variable_instance_get(self, "name"),
			"text"         : string_plural(string_replace_all(string_lower(instance_get_name(self)), "@q", "")),
			"ammo"         : _num
		}){
			var _add = true;
				
			 // Update Old Entries:
			with(annihilation_list){
				if(object_index == other.object_index && name == other.name){
					if(other.ammo > ammo){
						text = other.text;
						ammo = other.ammo;
					}
					_add = false;
				}
			}
			
			 // Reset:
			with(instances_matching_ne((custom ? instances_matching(object_index, "name", name) : object_index), "annihilation_check", null)){
				if(annihilation_check){
					annihilation_check = null;
				}
			}
			
			 // Add:
			if(_add){
				array_push(annihilation_list, self);
			}
		}
	}
	
	 // Activate:
	if(skill_get(mod_current) >= 0 && skill_get(mod_current) < _num){
		skill_set(mod_current, _num);
	}
	
#define string_plural(_string)
	/*
		Returns the plural form of the given string, assuming that it ends with a singular noun
		Doesn't support wild stuff like 'person/people' cause english sucks wtf
	*/
	
	var _length = string_length(_string);
	
	if(_length > 0){
		var _lower = string_lower(_string);
		
		 // Wacky Exceptions:
		with(["deer", "fish", "sheep"]){
			if(string_delete(_lower, 1, string_length(_lower) - string_length(self)) == self){
				return _string;
			}
		}
		
		 // Pluralize:
		var _char  = string_char_at(_lower, _length);
		switch(_char){
			case "s":
			case "x":
			case "z":
			case "h":
				if(_char != "h" || array_find_index(["c", "s"], string_char_at(_lower, _length - 1)) >= 0){
					_string += "e";
				}
				break;
				
			case "y":
			case "o":
				if(array_find_index(["a", "e", "i", "o", "u"], string_char_at(_lower, _length - 1)) < 0){
					if(_char == "y"){
						_string = string_copy(_string, 1, _length - 1) + "i";
					}
					_string += "e";
				}
				break;
				
			case "f":
				if(string_char_at(_lower, _length - 1) == "l"){
					_string = string_copy(_string, 1, _length - 1) + "ve";
				}
				break;
				
			case "e":
				if(
					string_char_at(_lower, _length - 2) == "i" &&
					string_char_at(_lower, _length - 1) == "f"
				){
					_string = string_copy(_string, 1, _length - 2) + "ve";
				}
				break;
		}
		_string += "s";
	}
	
	return _string;
	
#define instance_get_name(_inst)
	/*
		Returns a displayable name for a given instance or object
	*/
	
	var	_name = "",
		_canSpace = true;
		
	 // Object:
	if(object_exists(_inst)){
		_name = object_get_name(_inst);
	}
	
	 // Instance:
	else if(instance_exists(_inst)){
		 // Enemies and Projectiles:
		if("hitid" in _inst){
			var _hitid = _inst.hitid;
			if(is_real(_inst.hitid)){
				_hitid = death_cause(_inst.hitid);
			}
			if(is_array(_hitid) && array_length(_hitid) > 1){
				_name = string(_hitid[1]);
				if(_name != "") _canSpace = false;
			}
		}
		
		 // Normal:
		if(_name == ""){
			_name = object_get_name(_inst.object_index);
			
			 // Custom:
			if("name" in _inst && string_pos("Custom", _name) == 1){
				_name = string(_inst.name);
			}
		}
	}
	
	 // Auto-Space:
	if(_canSpace && string_pos(" ", _name) <= 0){
		var	_char     = "",
			_charLast = "",
			_charNext = "";
			
		for(var i = 0; i <= string_length(_name); i++){
			_charNext = string_char_at(_name, i + 1);
			
			if(
				(_char != string_lower(_char) && (_charLast != string_upper(_charLast) || (_charLast != string_lower(_charLast) && _charNext != string_upper(_charNext))))
				|| (string_digits(_char) != "" && string_letters(_charLast) != "")
				|| (string_letters(_char) != "" && string_digits(_charLast) != "") 
			){
				_name = string_insert(" ", _name, i);
				i++;
			}
			
			_charLast = _char;
			_char = _charNext;
		}
		
		_name = string_replace_all(_name, "_", " ");
	}
	
	return _name;
	
#define death_cause(_cause)
	/*
		Returns the death cause associated with a given index as an array containing [Sprite, Name]
	*/
	
	_cause = floor(_cause);
	
	 // Normal:
	var _loc = `CauseOfDeath:${_cause}`;
	switch(_cause){
		case   0 : return [sprBanditIdle,           loc(_loc, "bandit"                                              )];
		case   1 : return [sprMaggotIdle,           loc(_loc, "maggot"                                              )];
		case   2 : return [sprRadMaggot,            loc(_loc, "rad maggot"                                          )];
		case   3 : return [sprBigMaggotIdle,        loc(_loc, "big maggot"                                          )];
		case   4 : return [sprScorpionIdle,         loc(_loc, "scorpion"                                            )];
		case   5 : return [sprGoldScorpionIdle,     loc(_loc, "golden scorpion"                                     )];
		case   6 : return [sprBanditBossIdle,       loc(_loc, "big bandit"                                          )];
		case   7 : return [sprRatIdle,              loc(_loc, "rat"                                                 )];
		case   8 : return [sprRatkingIdle,          loc(_loc, "big rat"                                             )];
		case   9 : return [sprFastRatIdle,          loc(_loc, "green rat"                                           )];
		case  10 : return [sprGatorIdle,            loc(_loc, "gator"                                               )];
		case  11 : return [sprExploderIdle,         loc(_loc, "frog"                                                )];
		case  12 : return [sprSuperFrogIdle,        loc(_loc, "super frog"                                          )];
		case  13 : return [sprFrogQueenIdle,        loc(_loc, "mom"                                                 )];
		case  14 : return [sprMeleeIdle,            loc(_loc, "assassin"                                            )];
		case  15 : return [sprRavenIdle,            loc(_loc, "raven"                                               )];
		case  16 : return [sprSalamanderIdle,       loc(_loc, "salamander"                                          )];
		case  17 : return [sprSniperIdle,           loc(_loc, "sniper"                                              )];
		case  18 : return [sprScrapBossIdle,        loc(_loc, "big dog"                                             )];
		case  19 : return [sprSpiderIdle,           loc(_loc, "spider"                                              )];
		case  20 : return [sprBanditIdle,           loc(_loc, "new cave thing"                                      )];
		case  21 : return [sprLaserCrystalIdle,     loc(_loc, "laser crystal"                                       )];
		case  22 : return [sprHyperCrystalIdle,     loc(_loc, "hyper crystal"                                       )];
		case  23 : return [sprSnowBanditIdle,       loc(_loc, "snow bandit"                                         )];
		case  24 : return [sprSnowBotIdle,          loc(_loc, "snowbot"                                             )];
		case  25 : return [sprWolfIdle,             loc(_loc, "wolf"                                                )];
		case  26 : return [sprSnowTankIdle,         loc(_loc, "snowtank"                                            )];
		case  27 : return [sprLilHunter,            loc(_loc, "lil hunter"                                          )];
		case  28 : return [sprFreak1Idle,           loc(_loc, "freak"                                               )];
		case  29 : return [sprExploFreakIdle,       loc(_loc, "explo freak"                                         )];
		case  30 : return [sprRhinoFreakIdle,       loc(_loc, "rhino freak"                                         )];
		case  31 : return [sprNecromancerIdle,      loc(_loc, "necromancer"                                         )];
		case  32 : return [sprTurretIdle,           loc(_loc, "turret"                                              )];
		case  33 : return [sprTechnoMancer,         loc(_loc, "technomancer"                                        )];
		case  34 : return [sprGuardianIdle,         loc(_loc, "guardian"                                            )];
		case  35 : return [sprExploGuardianIdle,    loc(_loc, "explo guardian"                                      )];
		case  36 : return [sprDogGuardianWalk,      loc(_loc, "dog guardian"                                        )];
		case  37 : return [sprNothingOn,            loc(_loc, "throne"                                              )];
		case  38 : return [sprNothing2Idle,         loc(_loc, "throne II"                                           )];
		case  39 : return [sprBoneFish1Idle,        loc(_loc, "bonefish"                                            )];
		case  40 : return [sprCrabIdle,             loc(_loc, "crab"                                                )];
		case  41 : return [sprTurtleIdle,           loc(_loc, "turtle"                                              )];
		case  42 : return [sprMolefishIdle,         loc(_loc, "molefish"                                            )];
		case  43 : return [sprMolesargeIdle,        loc(_loc, "molesarge"                                           )];
		case  44 : return [sprFireBallerIdle,       loc(_loc, "fireballer"                                          )];
		case  45 : return [sprSuperFireBallerIdle,  loc(_loc, "super fireballer"                                    )];
		case  46 : return [sprJockIdle,             loc(_loc, "jock"                                                )];
		case  47 : return [sprInvSpiderIdle,        loc(_loc, "@p@qc@qu@qr@qs@qe@qd @qs@qp@qi@qd@qe@qr"             )];
		case  48 : return [sprInvLaserCrystalIdle,  loc(_loc, "@p@qc@qu@qr@qs@qe@qd @qc@qr@qy@qs@qt@qa@ql"          )];
		case  49 : return [sprMimicTell,            loc(_loc, "mimic"                                               )];
		case  50 : return [sprSuperMimicTell,       loc(_loc, "health mimic"                                        )];
		case  51 : return [sprGruntIdle,            loc(_loc, "grunt"                                               )];
		case  52 : return [sprInspectorIdle,        loc(_loc, "inspector"                                           )];
		case  53 : return [sprShielderIdle,         loc(_loc, "shielder"                                            )];
		case  54 : return [sprOldGuardianIdle,      loc(_loc, "crown guardian"                                      )];
		case  55 : return [sprExplosion,            loc(_loc, "explosion"                                           )];
		case  56 : return [sprSmallExplosion,       loc(_loc, "small explosion"                                     )];
		case  57 : return [sprTrapGameover,         loc(_loc, "fire trap"                                           )];
		case  58 : return [sprShielderShieldAppear, loc(_loc, "shield"                                              )];
		case  59 : return [sprToxicGas,             loc(_loc, "toxic"                                               )];
		case  60 : return [sprEnemyHorrorIdle,      loc(_loc, "horror"                                              )];
		case  61 : return [sprBarrel,               loc(_loc, "barrel"                                              )];
		case  62 : return [sprToxicBarrel,          loc(_loc, "toxic barrel"                                        )];
		case  63 : return [sprGoldBarrel,           loc(_loc, "golden barrel"                                       )];
		case  64 : return [sprCarIdle,              loc(_loc, "car"                                                 )];
		case  65 : return [sprVenusCar,             loc(_loc, "venus car"                                           )];
		case  66 : return [sprVenusCarFixed,        loc(_loc, "venus car fixed"                                     )];
		case  67 : return [sprVenuzCar2,            loc(_loc, "venus car 2"                                         )];
		case  68 : return [sprFrozenCar,            loc(_loc, "icy car"                                             )];
		case  69 : return [sprFrozenCarThrown,      loc(_loc, "thrown car"                                          )];
		case  70 : return [sprWaterMine,            loc(_loc, "mine"                                                )];
		case  71 : return [sprCrown1Idle,           loc(_loc, "crown of death"                                      )];
		case  72 : return [sprPopoExplo,            loc(_loc, "rogue strike"                                        )];
		case  73 : return [sprBloodNader,           loc(_loc, "blood launcher"                                      )];
		case  74 : return [sprBloodCannon,          loc(_loc, "blood cannon"                                        )];
		case  75 : return [sprBloodHammer,          loc(_loc, "blood hammer"                                        )];
		case  76 : return [sprDisc,                 loc(_loc, "disc"                                                )];
		case  77 : return [sprCurse,                loc(_loc, "@p@qc@qu@qr@qs@qe"                                   )];
		case  78 : return [sprScrapBossMissileIdle, loc(_loc, "big dog missile"                                     )];
		case  79 : return [sprSpookyBanditIdle,     loc(_loc, "halloween bandit"                                    )];
		case  80 : return [sprLilHunterHurt,        loc(_loc, "lil hunter fly"                                      )];
		case  81 : return [sprNothingDeathLoop,     loc(_loc, "throne death"                                        )];
		case  82 : return [sprJungleBanditIdle,     loc(_loc, "jungle bandit"                                       )];
		case  83 : return [sprJungleAssassinIdle,   loc(_loc, "jungle assassin"                                     )];
		case  84 : return [sprJungleFlyIdle,        loc(_loc, "jungle fly"                                          )];
		case  85 : return [sprCrown1Idle,           loc(_loc, "crown of hatred"                                     )];
		case  86 : return [sprIceFlowerIdle,        loc(_loc, "ice flower"                                          )];
		case  87 : return [sprCursedAmmo,           loc(_loc, "@p@qc@qu@qr@qs@qe@qd @qa@qm@qm@qo @qp@qi@qc@qk@qu@qp")];
		case  88 : return [sprLightningDeath,       loc(_loc, "electrocution"                                       )];
		case  89 : return [sprEliteGruntIdle,       loc(_loc, "elite grunt"                                         )];
		case  90 : return [sprKillsIcon,            loc(_loc, "blood gamble"                                        )];
		case  91 : return [sprEliteShielderIdle,    loc(_loc, "elite shielder"                                      )];
		case  92 : return [sprEliteInspectorIdle,   loc(_loc, "elite inspector"                                     )];
		case  93 : return [sprLastIdle,             loc(_loc, "captain"                                             )];
		case  94 : return [sprVanDrive,             loc(_loc, "van"                                                 )];
		case  95 : return [sprBuffGatorIdle,        loc(_loc, "buff gator"                                          )];
		case  96 : return [sprBigGenerator,         loc(_loc, "generator"                                           )];
		case  97 : return [sprLightningCrystalIdle, loc(_loc, "lightning crystal"                                   )];
		case  98 : return [sprGoldTankIdle,         loc(_loc, "golden snowtank"                                     )];
		case  99 : return [sprGreenExplosion,       loc(_loc, "green explosion"                                     )];
		case 100 : return [sprSmallGenerator,       loc(_loc, "small generator"                                     )];
		case 101 : return [sprGoldDisc,             loc(_loc, "golden disc"                                         )];
		case 102 : return [sprBigDogExplode,        loc(_loc, "big dog explosion"                                   )];
		case 103 : return [sprPopoFreakIdle,        loc(_loc, "popo freak"                                          )];
		case 104 : return [sprNothing2Death,        loc(_loc, "throne II death"                                     )];
		case 105 : return [sprOasisBossIdle,        loc(_loc, "big fish"                                            )];
	}
	
	 // Sprite:
	if(sprite_exists(_cause)){
		return [_cause, sprite_get_name(_cause)];
	}
	
	 // None:
	return [mskNone, ""];
	
	
/// SCRIPTS
#macro  infinity																				1/0
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define area_get_back_color(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_back_color', _area);