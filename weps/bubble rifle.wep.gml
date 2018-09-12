#define init
global.sprBubbleRifle = sprite_add_weapon("../sprites/weps/sprBubbleRifle.png",3,5);
#define weapon_name return "BUBBLE RIFLE";
#define weapon_type return 4;                   // Not melee
#define weapon_cost return 1;
#define weapon_load return 6;
#define weapon_area return -1;                  // Doesn't spawn normally
#define weapon_auto return false;
#define weapon_sprt return global.sprBubbleRifle;
#define weapon_text return "REFRESHING";
#define weapon_reloaded
instance_create(x+lengthdir_x(sprite_get_width(global.sprBubbleRifle),gunangle),y+lengthdir_y(sprite_get_width(global.sprBubbleRifle),gunangle),Bubble)
return sound_play_pitchvol(sndOasisExplosionSmall,1.3,.4);
#define weapon_fire(_wep)
repeat(2)
{
  var _pitch = random_range(.8,1.2);
  sound_play_pitch(sndOasisCrabAttack,.7*_pitch);
  sound_play_pitch(sndOasisExplosionSmall,.7*_pitch);
  sound_play_pitch(sndToxicBoltGas,.8*_pitch);
  sound_play_pitch(sndHyperRifle,1.7*_pitch);
  weapon_post(5,-5,10)
  with mod_script_call("mod","telib","obj_create",x,y,"BubbleBomb")
  {
    move_contact_solid(other.gunangle,6)
    motion_add(other.gunangle+random_range(-12,12)*other.accuracy,9);
    friction *= random_range(.8,1.2);
    team = other.team;
    creator = other;
  }
  wait(2);
  if !instance_exists(self){exit}
}
