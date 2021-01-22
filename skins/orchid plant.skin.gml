#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#define skin_race      return "plant";
#define skin_name      return ((argument_count <= 0 || argument0) ? "GILDED" : skin_lock());
#define skin_lock      return "REROLL ???";
#define skin_unlock    return "FOR REROLLING HEAVY HEART";
#define skin_ttip      return choose("YOU LOOK SO GOOD", "MILLION DOLLAR SMILE", "SHINY LIKE A LIMOUSINE", "ALL THAT TWINKLES IS GOLD", "PUMP YOUR VEINS WITH GUSHING GOLD");
#define skin_avail     return unlock_get("skin:" + mod_current);
#define skin_portrait  return skin_sprite(sprBigPortrait);
#define skin_mapicon   return skin_sprite(sprMapIcon);

#define skin_button
	sprite_index = skin_sprite(sprLoadoutSkin);
	image_index  = !skin_avail();
	
#define skin_sprite(_spr)
	switch(_spr){
		case sprMutant5Idle  : return spr.PlantOrchidIdle;
		case sprMutant5Walk  : return spr.PlantOrchidWalk;
		case sprMutant5Hurt  : return spr.PlantOrchidHurt;
		case sprMutant5Dead  : return spr.PlantOrchidDead;
		case sprMutant5GoSit : return spr.PlantOrchidGoSit;
		case sprMutant5Sit   : return spr.PlantOrchidSit;
		case sprBigPortrait  : return spr.PlantOrchidPortrait;
		case sprLoadoutSkin  : return spr.PlantOrchidLoadout;
		case sprMapIcon      : return spr.PlantOrchidMapIcon;
		case sprTangle       : return spr.PlantOrchidTangle;
		case sprTangleSeed   : return spr.PlantOrchidTangleSeed;
	}
	
#define skin_weapon_sprite(_spr, _wep)
	switch(_spr){
		case sprGoldARifle       : return spr.PlantOrchidAssaultRifle;
		case sprGoldBazooka      : return spr.PlantOrchidBazooka;
		case sprGoldCrossbow     : return spr.PlantOrchidCrossbow;
		case sprGoldDiscgun      : return spr.PlantOrchidDiscGun;
		case sprGoldFrogBlaster  : return spr.PlantOrchidFrogPistol;
		case sprFrogBlaster      : return spr.PlantOrchidFrogPistolRusty;
		case sprGoldNader        : return spr.PlantOrchidGrenadeLauncher;
		case sprGoldLaserGun     : return spr.PlantOrchidLaserPistol;
		case sprGoldMachinegun   : return spr.PlantOrchidMachinegun;
		case sprGoldNukeLauncher : return spr.PlantOrchidNukeLauncher;
		case sprGoldPlasmaGun    : return spr.PlantOrchidPlasmaGun;
		case sprGoldRevolver     : return spr.PlantOrchidRevolver;
		case sprGoldScrewdriver  : return spr.PlantOrchidScrewdriver;
		case sprGoldShotgun      : return spr.PlantOrchidShotgun;
		case sprGoldSlugger      : return spr.PlantOrchidSlugger;
		case sprGoldSplinterGun  : return spr.PlantOrchidSplinterGun;
		case sprGoldWrench       : return spr.PlantOrchidWrench;
		
		default: // Modded
			if(_spr == spr.GoldTrident) return spr.PlantOrchidTrident;
	}
	return _spr;
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define area_get_name(_area, _subarea, _loop)                                           return  mod_script_call_nc('mod', 'telib', 'area_get_name', _area, _subarea, _loop);