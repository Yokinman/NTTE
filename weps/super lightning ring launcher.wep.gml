#define init
    global.sprSuperLightningRingLauncher = sprite_add_weapon("../sprites/weps/sprSuperLightningRingLauncher.png", 7, 4);

#define weapon_name return "SUPER LIGHTNING RING LAUNCHER";
#define weapon_text return "THEY POPULATE QUCKLY";
#define weapon_type return 5;   // Energy
#define weapon_cost return 10;  // 10 Ammo
#define weapon_load return 80;  // 2.67 Seconds
#define weapon_area return -1;  // Doesn't spawn normally
#define weapon_swap return sndSwapEnergy;
#define weapon_sprt return global.sprSuperLightningRingLauncher;
#macro current_frame_active ((current_frame mod 1) < current_time_scale)

#define weapon_fire
var _ang = -20
var _i = _ang * -1
repeat(5)
{
  o = instance_create(x, y, CustomProjectile);
  with(o){
       // Visual:
      sprite_index = sprLightning;
      image_speed = 0.4;
      depth = -3;

       // Vars:
      team = other.team;
      creator = other;
      mask_index = mskWepPickup;
      rotspeed = random_range(10, 20) * choose(-1, 1);
      rotation = 0;
      radius = 10;
      charge = 1;
      ammo = 10+skill_get(mut_laser_brain)*4;
      typ = 0;
      i = _i
      direction = other.gunangle + i + random_range(-3,3) * other.accuracy;
      image_xscale = 0;
      image_yscale = 0;
      on_step = LightningDisc_step
      on_draw = LightningDisc_draw
      on_wall = LightningDisc_wall
      on_hit  = LightningDisc_hit
  }
  _i += -20/2.5
}

#define LightningDisc_step
rotation += rotspeed;

 // Charge Up:
if(image_xscale < charge){
    image_xscale += 0.03 * current_time_scale;
    image_yscale = image_xscale;
    if(instance_exists(creator)){
        with creator weapon_post(other.image_xscale*6,other.image_xscale*-3,1)
        x = creator.x + lengthdir_x(16,creator.gunangle);
        y = creator.y + lengthdir_y(16,creator.gunangle);
        if place_meeting(x,y,Wall){x = creator.x;y = creator.y}
    }
    x -= hspeed * current_time_scale;
    y -= vspeed * current_time_scale;

     // Effects:
    sound_play_pitch(sndLightningHit, image_xscale);
    sound_play_pitch(sndPlasmaReload, image_xscale*3);
}
else if(charge > 0){
    charge = 0;
    with creator
    {
      weapon_post(12,0,30)
      motion_add(gunangle-180,4)
    }
    motion_add(creator.gunangle + i + random_range(-3,3) * creator.accuracy,8)
    var _p = random_range(.8,1.2)
    sound_play_pitch(sndLightningCannonEnd, 2 * _p);
    if skill_get(mut_laser_brain) = true
    {
      sound_play_pitch(sndLightningShotgunUpg, 1.2 * _p);
      sound_play_pitch(sndLightningCannonUpg, 1.6 * _p);
    }
    else
    {
      sound_play_pitch(sndLightningShotgun, 1.2 * _p);
      sound_play_pitch(sndLightningCannon, 1.6 * _p);
    }
    instance_create(x, y, GunWarrantEmpty);
}

 // Slow:
var _maxSpd = 2;
if(charge <= 0 && speed > _maxSpd) speed -= current_time_scale;

 // Particles:
if(current_frame_active){
    if(random(30) < image_xscale || (charge <= 0 && speed > _maxSpd && random(3) < image_xscale)){
        var d = random(360),
            r = random(radius),
            _x = x + lengthdir_x(r * image_xscale, d),
            _y = y + lengthdir_y(r * image_yscale, d);

        with(instance_create(_x, _y, PortalL)){
            motion_add(random(360), 1);
            if(other.charge <= 0){
                hspeed += other.hspeed;
                vspeed += other.vspeed;
            }
        }
    }
}

 // Shrink:
if(charge <= 0){
    var q = .8
    if skill_get(mut_laser_brain) = 1 q = .5
    var s = 1/160 * current_time_scale /.7;
    image_xscale -= s;
    image_yscale -= s;
    if(image_xscale <= 0 || image_yscale <= 0){
        sound_play_hit(sndLightningHit, 0.5);
        instance_create(x, y, LightningHit);
        instance_destroy();
    }
}

#define LightningDisc_hit
    if(projectile_canhit_melee(other)){
         // Slow:
        x -= hspeed;
        y -= vspeed;
        direction += orandom(30);

         // Electricity Field:
        var _tx = other.x,
            _ty = other.y,
            d = random(360),
            r = radius,
            _x = x + lengthdir_x(r * image_xscale, d),
            _y = y + lengthdir_y(r * image_yscale, d);

        with(instance_create(_x, _y, Lightning)){
            ammo = other.image_xscale + random(other.image_xscale * 2);
            direction = point_direction(x, y, _tx, _ty) + orandom(12);
            image_angle = direction;
            team = other.team;
            hitid = other.hitid;
            creator = other.creator;
            event_perform(ev_alarm, 0);
        }

         // Effects:
        with(other) instance_create(x, y, Smoke);
        sound_play(sndLightningHit);
    }

#define LightningDisc_wall
     // Bounce:
    if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
    if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;

    with(other){
         // Bounce Effect:
        var _x = x + 8,
            _y = y + 8,
            _dis = 8,
            _dir = point_direction(_x, _y, other.x, other.y);

        instance_create(_x + lengthdir_x(_dis, _dir), _y + lengthdir_y(_dis, _dir), PortalL);
        sound_play(sndLightningHit);

         // Too Powerful:
        if(other.image_xscale > 1.2 || other.image_yscale > 1.2){
            instance_create(x, y, FloorExplo);
            instance_destroy();
        }
    }

#define LightningDisc_draw
    scrDrawLightningDisc(sprite_index, image_index, x, y, ammo, radius, 1, image_xscale, image_yscale, image_angle + rotation, image_blend, image_alpha);

    #define scrDrawLightningDisc(_spr, _img, _x, _y, _num, _radius, _stretch, _xscale, _yscale, _angle, _blend, _alpha)
        var _off = (360 / _num),
            _ysc = _stretch * (0.5 + random(1));

        for(var d = _angle; d < _angle + 360; d += _off){
            var _ro = random(2),
                _rx = (_radius * _xscale) + _ro,
                _ry = (_radius * _yscale) + _ro,
                _x1 = _x + lengthdir_x(_rx, d),
                _y1 = _y + lengthdir_y(_ry, d),
                _x2 = _x + lengthdir_x(_rx, d + _off),
                _y2 = _y + lengthdir_y(_ry, d + _off),
                _xsc = point_distance(_x1, _y1, _x2, _y2) / 2,
                _ang = point_direction(_x1, _y1, _x2, _y2);

            draw_sprite_ext(_spr, _img, _x1, _y1, _xsc, _ysc, _ang, _blend, _alpha);
        }

#define orandom(n) return  mod_script_call("mod", "teassets", "orandom", n);
