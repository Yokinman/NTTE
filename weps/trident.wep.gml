#define init
global.sprTrident = sprite_add_weapon("../sprites/weps/sprTrident.png", 11, 6)
global.mskTrident = sprite_add("../sprites/weps/projectiles/mskTrident.png", 0, 11, 6)

#define weapon_name
return "TRIDENT"

#define weapon_type
return 0

#define weapon_cost
return 0

#define weapon_area
return -1

#define weapon_chrg
return 1

#define weapon_load
return 1

#define weapon_swap
return sndSwapSword

#define weapon_auto
return 1

#define weapon_melee
return false

#define weapon_laser_sight
return false

#define weapon_reloaded

#define weapon_sprt
return global.sprTrident

#define weapon_text
return "SCEPTER OF THE @bSEA"

#define weapon_fire
with instance_create(x,y,CustomObject)
{
  with instances_matching(CustomObject, "name", "trident charge")
  {
    if !charged charge += 4
    with other
    {
      instance_delete(self)
      exit
    }
  }
  sound   = sndMeleeFlip
	name    = "trident charge"
	creator = other
  curse   = other.curse
	charge    = 0
  maxcharge = 30
	charged = 0
	depth  = TopCont.depth
	index  = creator.index
	reload = -1
	btn  = other.specfiring ? "spec" : "fire"
  on_step  = tridentcharge_step
}

#define tridentcharge_step
if !instance_exists(creator){instance_delete(self); exit}
if (btn = "spec" && creator.bwep != mod_current) || (btn = "fire" && creator.wep != mod_current){instance_delete(self); exit}
creator.reload = weapon_get_load(mod_current)
if charge < maxcharge
{
  sound_play_pitch(sndOasisMelee,1 / (1 - charge / maxcharge * .25))
}
if charge > maxcharge
{
  charge = maxcharge
  charged = 1
  var _o    = 16,
      _odir = creator.gunangle;
  instance_create(creator.x + lengthdir_x(_o, _odir), creator.y + lengthdir_y(_o, _odir), ThrowHit)
  instance_create(creator.x + lengthdir_x(_o, _odir), creator.y + lengthdir_y(_o, _odir), ImpactWrists)
  sleep(5)
  sound_play_pitch(sndCrystalRicochet, 3)
  sound_play_pitch(sndSewerDrip,       3)
}
if charge = maxcharge
{
  if current_frame mod 12 = 0
  {
    creator.gunshine = 1
  }
}
with creator
{
  weapon_post(9 * other.charge / other.maxcharge, 8 * other.charge / other.maxcharge, 0)
}
if button_released(index, btn)
{
  with instance_create(creator.x, creator.y, CustomProjectile)
  {
    creator = other.creator
    team    = creator.team
    sprite_index = global.sprTrident
    mask_index   = global.mskTrident
    image_speed  = 0
    damage = 24
    force = 5
    text  = noone
    target     = noone
    prevtarget = target
    canmove = true
    curse   = other.curse
    motion_add(creator.gunangle, 18)
    image_angle = direction
    on_hit      = trident_hit
    on_wall     = trident_wall
    on_step     = trident_step
    on_anim     = trident_anim
    on_draw     = trident_draw
    on_end_step = trident_end_step
  }
  with creator
  {
    if other.btn = "fire"
    {
      wep = bwep
      bwep = 0
      reload = 10
    }
    else
    {
      bwep = 0
    }
    curse = 0
    weapon_post(0, 50, 5)

    var _p = random_range(.8, 1.2);
    sound_play_pitchvol(sndAssassinAttack     , 1.3  * _p, 1.6);
    sound_play_pitchvol(sndOasisDeath         , 1.2  * _p, .8);
    sound_play_pitchvol(sndOasisExplosionSmall, .7   * _p, .7);
    sound_play_pitchvol(sndOasisMelee         , 1    * _p, 1);
    with instance_create(x + lengthdir_x(24, direction), y + lengthdir_y(24, direction), Bubble){motion_set(other.direction + random_range(-30, 30), choose(1, 2, 2, 3, 3))}
  }
  sleep(15)
  instance_delete(self)
}

#define trident_hit
if canmove = true && target = -4 && current_frame mod 4
{
  with instance_create(x + lengthdir_x(12, direction), y + lengthdir_y(12, direction), BubblePop){image_index = 1}
  projectile_hit(other, damage, force, direction)
  if other.my_health > 0
  {
    if !skill_get(mut_long_arms)
    {
      target = other
      sound_play_pitch(sndAssassinAttack, 2);
    }
  }
  else
  {
    x -= lengthdir_x(6, direction)
    y -= lengthdir_y(6, direction)
  }
  repeat(3){with instance_create(x + lengthdir_x(24, direction), y + lengthdir_y(24, direction), Bubble){motion_set(other.direction + random_range(-30, 30), choose(1, 2, 2, 3, 3))}}
  sleep(17 * clamp(other.size, 1, 5))
  view_shake_at(x, y, 11 * clamp(other.size, 1, 5))
}

#define trident_step
// Stuck in Target:
if curse{instance_create(x + random_range(-6, 6),y + random_range(-6, 6), Curse)}
if(instance_exists(target))
{
  canmove = false
  speed = 0
  var _odis = 24,
      _odir = image_angle;
  x = target.x - lengthdir_x(_odis, _odir);
  y = target.y - lengthdir_y(_odis, _odir);
  if("z" in target)
  {
    if(target.object_index == RavenFly || target.object_index == LilHunterFly)
    {
      y += target.z;
    }
    else y -= target.z;
  }
  xprevious = x;
  yprevious = y;
  visible = target.visible;
}
else if(instance_exists(Player) && prevtarget > -4)
{
  with instance_create(x, y, WepPickup)
  {
    wep = mod_current
    curse = other.curse
    image_angle = other.image_angle
  }
  instance_delete(self)
  exit
}
if(speed > 0)
{
  // Bolt Marrow:
  if(skill_get(mut_bolt_marrow) > 0)
  {
    var n = nearest_instance(x, y, instances_matching_ne(instances_matching_ne(hitme, "team", team, 0), "mask_index", mskNone, sprVoid));
    if(distance_to_object(n) < (14 * skill_get(mut_bolt_marrow)))
    {
      if(!place_meeting(x, y, n))
      {
        if(in_sight(n))
        {
          x = n.x - lengthdir_x(speed, direction)
          y = n.y - lengthdir_y(speed, direction)
          sleep(5)
        }
      }
    }
  }
}

if (place_meeting(x, y, PortalShock) || instance_exists(PortalL)) && canmove = false
{
  with instance_create(x, y, WepPickup)
  {
    wep = mod_current
    curse = other.curse
    image_angle = other.image_angle
  }
  instance_delete(self)
  exit
}

// Wepshine:
if canmove = false
{
  if current_frame mod 70 = 0
  {
    image_speed = .35
  }
}
else
{
  with instances_matching_ne(projectile, "team", other.team)
  {
    if distance_to_object(other) <= 8
    {
      sleep(2)
      instance_destroy()
    }
  }
}

// Pick Up:
prevtarget = target
var p = instance_nearest(x, y, Player);
if place_meeting(x, y, p) && canmove = false
{
  if text = noone
  {
    text = instance_create(x, y, CustomObject)
    with text
    {
      depth = TopCont.depth - 2
      index = other.creator.index
      creator = other
      on_draw = text_draw
    }
  }
  if button_pressed(p.index, "pick")
  {
    with(p)
    {
      if wep = 0
      {
        mod_script_call("weapon", mod_current, "trident_pick")
      }
      else
      {
        if bwep = 0
        {
          bwep = wep
          mod_script_call("weapon", mod_current, "trident_pick")
        }
        else
        {
          if curse = false
          {
            with instance_create(x, y, WepPickup)
            {
              curse = other.curse
              wep   = other.wep
            }
            mod_script_call("weapon", mod_current, "trident_pick")
          }
          else
          {
            if other.curse = true
            {
              with instance_create(x, y, WepPickup)
              {
                curse = other.curse
                wep   = other.wep
              }
              mod_script_call("weapon", mod_current, "trident_pick")
            }
            else
            {
              sound_play(sndCursedReminder)
            }
          }
        }
      }
    }
  }
}
else
{
  if text != noone
  {
    with text
    {
      instance_destroy()
    }
    text = noone
  }
}

#define trident_pick
sound_play(sndSwapSword);
wep = mod_current
curse = other.curse
with instance_create(x, y, PopupText)
{
  mytext = weapon_get_name(mod_current) + "!"
}
with instances_matching(WepPickup, "wep", 0){instance_delete(self)}
instance_delete(other)
exit

#define trident_anim
image_speed = 0;

#define trident_draw
draw_self()

#define trident_wall
if(speed > 0)
{
  move_contact_solid(direction, 16);
  instance_create(x, y, Dust);
  sound_play(sndBoltHitWall);
  speed = 0
  repeat(3)
  {
    with instance_create(x + lengthdir_x(24, direction), y + lengthdir_y(24, direction), Bubble)
    {
      motion_set(other.direction + random_range(-30, 30), choose(1, 2, 2))
    }
  }
  instance_create(x, y, Debris)
  sound_play_pitchvol(sndExplosionS, 1.5, .7)
  sound_play_pitchvol(sndBoltHitWall,  1, .7)
  with instance_create(x + lengthdir_x(18, direction), y + lengthdir_y(18, direction), BubblePop){image_index = 1}
  // Stick in Wall:
  canmove = false;
}

#define trident_end_step
 // Trail:
var _x1 = x,
    _y1 = y,
    _x2 = xprevious,
    _y2 = yprevious;
with(instance_create(x, y, BoltTrail))
{
  image_yscale = 1;
  image_xscale = point_distance(_x1, _y1, _x2, _y2);
  image_angle = point_direction(_x1, _y1, _x2, _y2);
  creator = other.creator;
}

#define text_draw
if !instance_exists(creator)
{
  instance_destroy()
  exit
}
var _index = 0;
repeat(4)
{
  if _index = index
  {
    draw_set_visible(index, true)
  }
  else
  {
    draw_set_visible(index, false)
  }
  draw_text_nt(x, y-35, weapon_get_name(mod_current))
  draw_sprite(sprEPickup, 0, x, y-10)
  _index++;
}

#define in_sight(_inst)																	return  mod_script_call("mod", "telib", "in_sight", _inst);
#define scrWaterStreak(_x, _y, _dir, _spd)              return  mod_script_call(   "mod", "telib", "scrWaterStreak", _x, _y, _dir, _spd);
#define nearest_instance(_x, _y, _instances)            return  mod_script_call("mod", "telib", "nearest_instance", _x, _y, _instances);
