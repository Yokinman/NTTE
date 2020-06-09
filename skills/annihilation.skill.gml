#define init
	global.sprSkillHUD = sprite_add("../sprites/skills/Annihilation/sprSkillAnnihilationHUD.png", 1, 9, 9);
	
	 // List of Vanilla HitID Text Components:
	global.enemyHitidText = [
		"bandit", 
		"maggot", 
		"rad maggot", 
		"big maggot", 
		"scorpion", 
		"golden scorpion", 
		"big bandit", 
		"rat", 
		"big rat", 
		"green rat", 
		"gator", 
		"frog", 
		"super frog", 
		"mom", 
		"assassin", 
		"raven", 
		"salamander", 
		"sniper", 
		"big dog", 
		"spider", 
		"new cave thing", 
		"laser crystal", 
		"hyper crystal", 
		"snow bandit", 
		"snowbot", 
		"wolf", 
		"snowtank", 
		"lil hunter", 
		"freak", 
		"explo freak", 
		"rhino freak", 
		"necromancer", 
		"turret", 
		"technomancer", 
		"guardian", 
		"explo guardian", 
		"dog guardian", 
		"throne", 
		"throne II", 
		"bonefish", 
		"crab", 
		"turtle", 
		"molefish", 
		"molesarge", 
		"fireballer", 
		"super fireballer", 
		"jock", 
		"@p@qc@qu@qr@qs@qe@qd @qs@qp@qi@qd@qe@qr", 
		"@p@qc@qu@qr@qs@qe@qd @qc@qr@qy@qs@qt@qa@ql", 
		"mimic", 
		"health mimic", 
		"grunt", 
		"inspector", 
		"shielder", 
		"crown guardian", 
		"explosion", 
		"small explosion", 
		"fire trap", 
		"shield", 
		"toxic", 
		"horror", 
		"barrel", 
		"toxic barrel", 
		"golden barrel", 
		"car", 
		"venus car", 
		"venus car fixed", 
		"venus car 2", 
		"icy car", 
		"thrown car", 
		"mine", 
		"crown of death", 
		"rogue strike", 
		"blood launcher", 
		"blood cannon", 
		"blood hammer", 
		"disc", 
		"@p@qc@qu@qr@qs@qe", 
		"big dog missile", 
		"halloween bandit", 
		"lil hunter fly", 
		"throne death", 
		"jungle bandit", 
		"jungle assassin", 
		"jungle fly", 
		"crown of hatred", 
		"ice flower", 
		"@p@qc@qu@qr@qs@qe@qd @qa@qm@qm@qo @qp@qi@qc@qk@qu@qp", 
		"electrocution", 
		"elite grunt", 
		"blood gamble", 
		"elite shielder", 
		"elite inspector", 
		"captain", 
		"van", 
		"buff gator", 
		"generator", 
		"lightning crystal", 
		"golden snowtank", 
		"green explosion", 
		"small generator", 
		"golden disc", 
		"big dog explosion", 
		"popo freak", 
		"throne II death", 
		"big fish"
	];
	
	/*
	global.enemyAdjacents = [
		[[BigMaggot, null],		[BigMaggotBurrow, null]],
		[[Generator, null],		[GeneratorInactive, null]],
		[[MeleeBandit, null],	[MeleeFake, null]],
		[[Raven, null], 		[RavenFly, null],			[CustomEnemy, "TopRaven"]],
		[[ScrapBoss, null], 	[BecomeScrapBoss, null]]
	];
	*/
	
	/*
		TODO:
		- program enemy adjacents so the code treats objects the player
		  percieves as the same in the same manner
		- rewrite display name pluralizer code to account for multi-character 
		  endings
		- lower priority, but make the skill ttip condense excess enemy entries 
		  into an "and X more" type deal
		- fix softlocks with:
			- pitsquid post death
			- palanking phase change infinite summons
			- deleting the throne intro mask
		- fix bugs with:
			- red heart/sewer and pizza drains spawning levels without enemies 
			  or chests (blacklist them from the recursive cleanup)
		
	*/
	
	global.color = `@(color:${make_color_rgb(235, 0, 67)})`;
	
	game_start();
	
#define game_start
	global.newLevel = false;
	global.enemyList = [];
	
	/*
	if(chance(1, 3)) skill_init(obj_create(0, 0, Bandit),			1 + irandom(4));
	if(chance(1, 3)) skill_init(obj_create(0, 0, HyperCrystal),		1 + irandom(4));
	if(chance(1, 3)) skill_init(obj_create(0, 0, SuperFireBaller),	1 + irandom(4));
	if(chance(1, 3)) skill_init(obj_create(0, 0, "BanditHiker"), 	1 + irandom(4));
	if(chance(1, 3)) skill_init(obj_create(0, 0, "TrafficCrab"), 	1 + irandom(4));
	*/
	
#define skill_name return "ANNIHILATION";
#define skill_text   
	var _text = `${global.color}DESTROY @sALL `,
		_ammo = infinity;
	
	 // Generate Text:	
	var n = array_length(global.enemyList);
	for(var i = 0; i < n; i++){
		with(global.enemyList[i]){
			
			 // Punctuatiom:
			var p = "@s",
				c = " @sAND";
				
			if(n > 1 && i < (n - 1)){
				if(n <= 2){
					p = c;
				}
				else{
					
					 // The Oxford Comma:
					if(i >= (n - 2)){
						p = "," + c;
					}
					else{
						p = ",@s";
					}
				}
			}
			
			 // Find Lowest Duration:
			if(ammo < _ammo){
				_ammo = ammo;
			}
			
			_text += `@w${display_name}${p} `;
		}
	}
	
	 // Ending:
	if(_ammo > 2){
		_text += `FOR THE NEXT @w${_ammo - 1} LEVELS`;
	}
	else{
		if(_ammo > 1){
			_text += "THROUGH THE @wNEXT LEVEL";
		}
		else{
			_text += "UNTIL THE @wNEXT LEVEL";
		}
	}
	
	 // Format Text:
	var _textSplit = string_split(_text, " "),
		_stringLen = 0,
		_maxLength = 24;
		
	_text = "";
	for(var i = 0; i < array_length(_textSplit); i++){
		var s = _textSplit[i],
			l = string_length(string_letters(s));
			
		_stringLen += l;
		if(_stringLen >= _maxLength){
			_stringLen = l;
			_text += "#";
		}
		else{
			_text += " ";
		}
		
		_text += s;
	}
	
	/*
	 // Debug:
	_text += "#@b";
	with(global.enemyList){
		_text += `${ammo} `;
	}
	*/
	
	return _text;
	
#define skill_tip
	var _text = choose("GOODBYE", "SO LONG", "FAREWELL") + ", ";
	with(global.enemyList[irandom(array_length(global.enemyList) - 1)]){
		_text += global.color + display_name;
	}
	
	return _text;
	
#define skill_icon   return global.sprSkillHUD;
#define skill_util	 return true;
#define skill_avail  return false;
	
#define step
	if(instance_exists(GenCont)){
		global.newLevel = true;
	}
	else{
		if(global.newLevel){
			global.newLevel = false;
			
			 // Decrement:
			var _newEnemyList = [];
			with(global.enemyList){
				ammo--;
				if(ammo > 0){
					array_push(_newEnemyList, self);
				}
			}
			global.enemyList = _newEnemyList;
		}
		
		 // Goodbye:
		if(array_length(global.enemyList) <= 0){
			skill_set(mod_current, 0);
		}
	}
	
	 // Part II:
	script_bind_end_step(end_step, 0);
	
#define end_step
	 // Annihilation Time:
	if(skill_get(mod_current) > 0){
		enemy_annihilate();
	}
	
	 // Goodbye:
	instance_destroy();
	
#define skill_lose
	global.enemyList = [];
	
#define skill_init(_inst, _num)
	skill_set(mod_current, 1);
	
	 // Add Enemy Info to List:
	var _info = {};
	with(_info){
		display_name = string_replace_all(instance_get_name(_inst, true), "@Q", ""); // shaky text looks gross here, sorry
		object_index = variable_instance_get(_inst, "object_index");
		name = variable_instance_get(_inst, "name");
		ammo = _num;
	}
	array_push(global.enemyList, _info);
	
	 // Perish:
	with(_inst){
		enemy_annihilate();
	}

#define enemy_annihilate
	var _lag = false;
	if(_lag) trace_time();
	
	with(global.enemyList){
		var _array = instances_matching(object_index, "name", name),
			_minID = GameObject.id;
			
		with(_array){
			enemy_annihilate_destroy(id);
		}
		
		 // Recursive Cleanup:
		if(array_length(_array)){
			var _array = [Effect, Explosion, LastDie, Pickup, becomenemy, chestprop, enemy, projectile],
				_tries = 100; // Confirmed exit in the event of an infinite loop:
				
			while(array_length(instances_matching_gt(_array, "id", _minID)) > 0 && _tries-- > 0){
				with(instances_matching_gt(_array, "id", _minID)){
					enemy_annihilate_destroy(id);
				}
			}
		}
	}
	
	if(_lag) trace_time("enemy_annihilate")
	
#define enemy_annihilate_destroy(_inst)
	if(instance_exists(_inst)){
		with(_inst){
			with(_inst){
				
				 // Kill:
				if(instance_is(id, hitme) && "my_health" in id){
					projectile_hit_raw(id, my_health, false);
				}
				
				 // Custom Death Scripts:
				if(array_length(variable_instance_get(id, "on_death", [])) >= 3){
					if(mod_script_exists(on_death[0], on_death[1], on_death[2])){
						mod_script_call(on_death[0], on_death[1], on_death[2]);
					}
				}
			}
			
			 // Goodbye:
			instance_destroy();
		}
	}

#define instance_get_name(_inst, _plural)
	var _string = null;
	
	 // Get Name:
	if(instance_exists(_inst)){
		var _name = variable_instance_get(_inst, "name");
		
		 // Enemies and Projectiles:
		if("hitid" in _inst){
			var _hitid = _inst.hitid;
				
			 // Return Custom HitID Name:
			if(is_array(_hitid) && array_length(_hitid) >= 1){
				_string = _hitid[1];
			}
			else{
				
				 // Return Hardcoded Vanilla Names:
				if(is_real(_hitid) && is_undefined(_name)){
					_string = loc("CauseOfDeath:" + string(_hitid), global.enemyHitidText[_hitid]);
				}
			}
		}
		
		 // Generate Name from Instance Variables:
		if(is_undefined(_string)){
			_string = "";
			if(is_undefined(_name)){
				_name = object_get_name(_inst.object_index);
			}
			
			for(var i = 1; i <= string_length(_name); i++){
				var _char = string_char_at(_name, i);
				if(i > 1){
					
					 // Add Spaces:
					if(string_length(string_lettersdigits(_char)) > 0 && _char == string_upper(_char)){
						_string += " ";
					}
				}
				_string += _char;
			}
		}
	
		 // Final Touches:
		_string = string_upper(_string);
		
		 // The Most Epic Pluralizer of All Time:
		if(_plural){
			var _len = string_length(_string),
				_end = "";
				
			switch(string_char_at(_string, _len)){
				case "S":
					_string += "ES"; // miss u cactues
					break;
					
				case "Y": 
					_string = string_copy(_string, 1, _len - 1) + "IES"; 
					break;
					
				default:
					_string += "S";
			}
		}
	}
	
	 // Delivery:
	return _string;
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  infinity																				1/0
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));