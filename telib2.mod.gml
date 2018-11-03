#define init
    global.spr = mod_variable_get("mod", "teassets", "spr");
    global.snd = mod_variable_get("mod", "teassets", "snd");
    global.mus = mod_variable_get("mod", "teassets", "mus");

    global.catLight = [];

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus global.mus

#macro current_frame_active ((current_frame mod 1) < current_time_scale)
#macro anim_end (image_index > image_number - 1 + image_speed)

#define Cabinet_death
    repeat(irandom_range(8,16))
        with obj_create(x,y,"Paper")
            motion_set(irandom(359),random_range(2,8));
    
#define Cat_step
    enemyAlarms(2);
    enemySprites();
    enemyWalk(walkspd, maxspd);

    if instance_exists(hole) && place_meeting(x,y,hole) || (!array_length_1d(instances_matching(instances_matching(CustomObject,"name","Cathole"),"cat",self)) && !place_meeting(x,y,Floor)){
        canfly = true;
        alarm0 = -1;
        alarm1 = -1;
        x = 0;
        y = 0;
        var _a = instances_matching(CustomObject,"name","Cathole"),
            _t = target,
            _dest = nearest_instance(_t.x,_t.y,_a),
            _dist = 10000;
        
         // Find nearest canhole to player:
        with(_a){
            var _mydist = point_distance(x,y,_t.x,_t.y);
            if _mydist < _dist && !collision_line(x,y,_t.x,_t.y,Wall,0,0){
                _dist = _mydist;
                _dest = self;
            }
        }
        with(hole){
            image_index = 1;
            image_speed = 0.4;
        }
        hole = noone;
        with(_dest){
            alarm0 = 30;
            cat = other;
        }
    }
    
     // Sound fix
    if fork(){
        wait(0) if !instance_exists(self) sound_stop(sndFlamerLoop);
        exit;
    }

#define Cat_alrm0
    alarm0 = 20 + irandom(20);
    
    if(ammo > 0) {
        repeat(2)
        with(scrEnemyShoot(ToxicGas, gunangle + orandom(6), 4)) {
            friction = 0.12;
        }
        gunangle += 12;
        ammo--;
        if(ammo = 0) {
            alarm0 = 40;
            repeat(3) {
                var _dir = orandom(16);
                with(instance_create(x, y, AcidStreak)) {
                    motion_add(other.gunangle + _dir, 3);
                    image_angle = direction;
                }
            }
            wkick += 6;
            sound_play_pitch(sndEmpty, random_range(0.75, 0.9));
            sound_stop(sndFlamerLoop);
        } else {
            alarm0 = 2;
            wkick += 1;
        }
    } else {
        target = instance_nearest(x, y, Player);
        if(target_is_visible()) {
            var _targetDir = point_direction(x, y, target.x, target.y);
            
            if(target_in_distance(0, 140) and random(3) < 1) {
                scrRight(_targetDir);
                gunangle = _targetDir - 45;
                ammo = 10;
                with(instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), BloodGamble)) {
                    sprite_index = spr.AcidPuff;
                    image_angle = other.gunangle;
                }
                sound_play(sndToxicBoltGas);
                sound_play(sndEmpty);
                sound_loop(sndFlamerLoop);
                wkick += 4;
                alarm0 = 4;
            } else {
                alarm0 = 20 + irandom(20);
                scrWalk(20 + irandom(5), _targetDir + orandom(20));
                scrRight(gunangle);
            }
        } else {
            if instance_exists(hole){
                 // Move towards nearest cathole
                alarm0 = 60 + irandom(30);
                scrWalk(alarm0,point_direction(x,y,hole.x+16,hole.y+16));
            } else {
                 // Wander
                alarm0 = 30 + irandom(20); // 3-4 Seconds
                scrWalk(20 + irandom(10), irandom(360));
                scrRight(gunangle);
            }
        }
    }
    
#define Cat_alrm1
    if GameCont.area != sewers{
        alarm1 = -1;
        exit;
    }
    alarm1 = 90 + irandom(60); // 3-5 seconds
    if my_health < maxhealth{
         // Locate nearest cathole:
        if (!target_is_visible() || !target_in_distance(0,128)) {
            hole = noone;
            var _array = instances_matching(CustomObject,"name","Cathole"),
                _dist = 10000;
                
             // Bootleg nearest_instance() to find the nearest visible cathole
            with(_array) if !collision_line(other.x,other.y,x,y,Wall,0,0) && !instance_exists(cat){
                var _mydist = point_distance(x,y,other.x,other.y);
                if _mydist < _dist{
                    _dist = _mydist;
                    other.hole = self;
                }
            }
        }
    }
    
#define Cat_draw
    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();


#define CatBoss_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd, maxspd);
    

#define CatBoss_alrm0
    alarm0 = 20 + random(20);
    
    if(ammo > 0) {
        with(scrEnemyShoot(ToxicGas, gunangle + orandom(8), 4)) {
            friction = 0.2;
        }
        gunangle += 24;
        ammo--;
        if(ammo = 0) {
            alarm0 = 40;
            
            repeat(3) {
                var _dir = orandom(16);
                with(instance_create(x, y, AcidStreak)) {
                    motion_add(other.gunangle + _dir, 3);
                    image_angle = direction;
                }
            }
            
            target = instance_nearest(x, y, Player);
            var _targetDir = point_direction(x, y, target.x, target.y);
            
            with(scrEnemyShootExt(x - (2 * right), y, "CatGrenade", _targetDir, 3)){
                z += 12;
                depth = 12;
                zspeed = (point_distance(x, y - z, other.target.x, other.target.y) / 8) + orandom(1);
                right = other.right;
            }
            
            gunangle = _targetDir;
            wkick += 6;
            sound_play_pitch(sndEmpty, random_range(0.75, 0.9));
            sound_play_pitch(sndToxicLauncher, random_range(0.75, 0.9));
            sound_stop(sndFlamerLoop);
        } else {
            alarm0 = 1;
            wkick += 1;
        }
    } else {
        target = instance_nearest(x, y, Player);
        if(target_is_visible()) {
            var _targetDir = point_direction(x, y, target.x, target.y);
            
            if(target_in_distance(0, 140) and random(3) < 1) {
                if(random(3) < 3) {
                    scrRight(_targetDir);
                    gunangle = _targetDir - 45;
                    ammo = 20;
                    with(instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), BloodGamble)) {
                        sprite_index = spr.AcidPuff;
                        image_angle = other.gunangle;
                    }
                    sound_play(sndToxicBoltGas);
                    sound_play(sndEmpty);
                    var s = sndFlamerLoop;
                    sound_loop(sndFlamerLoop);
                    sound_pitch(sndFlamerLoop, random_range(1.8, 1.4));
                    wkick += 4;
                    alarm0 = 4;
                }
            } else {
                alarm0 = 20 + random(20);
                scrWalk(20 + random(5), _targetDir + orandom(20));
                scrRight(gunangle);
            }
        } else {
            alarm0 = 30 + random(20); // 3-4 Seconds
            scrWalk(20 + random(10), random(360));
            scrRight(gunangle);
        }
    }
    
#define CatBoss_draw
    if(gunangle >  180) draw_self_enemy();
    draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
    if(gunangle <= 180) draw_self_enemy();

#define CatBoss_death
    sound_stop(sndFlamerLoop); // Stops infinite flamer loop until you leave
    pickup_drop(100, 20);
    pickup_drop(60, 0);


#define CatDoor_step
     // Opening & Closing:
    var s = 0,
        _open = false;

    if(distance_to_object(Player) <= 0 || distance_to_object(enemy) <= 0 || distance_to_object(Ally) <= 0){
        with(instances_matching_ne(hitme, "team", team)){
            if(distance_to_object(other) <= 0){
                var _sx = lengthdir_x(hspeed, other.image_angle),
                    _sy = lengthdir_y(vspeed, other.image_angle);
    
                s = 3 * (_sx + _sy);
                _open = true;
            }
        }
    }
    if(_open){
        if(s != 0){
            if(abs(openang) < abs(s) && abs(openang) < 4){
                var _vol = clamp(40 / (distance_to_object(Player) + 1), 0, 1);
                if(_vol > 0.2){
                    sound_play_pitchvol(sndMeleeFlip, 1 + random(0.4), 0.8 * _vol);
                    sound_play_pitchvol(((openang > 0) ? sndAmmoChest : sndWeaponChest), 0.4 + random(0.2), 0.5 * _vol);
                }
            }
            openang += s;
        }
        openang = clamp(openang, -90, 90);
    }
    else openang *= 0.8;

     // Collision:
    if(abs(openang) > 20) mask_index = mskNone;
    else mask_index = msk.CatDoor;

     // Block Line of Sight:
    if(!instance_exists(my_wall)) my_wall = instance_create(0, 0, Wall);
    with(my_wall){
        x = other.x;
        y = other.y;
        if(other.mask_index == mskNone) mask_index = -1;
        else mask_index = msk.CatDoorLOS;
        image_angle = other.image_angle;
        sprite_index = -1;
        visible = 0;
        topspr = -1;
        outspr = -1;
    }

     // Death:
    if(my_health <= 0){
        sound_play(snd_dead);

        repeat(4) with(instance_create(x, y, Shell)){
            sprite_index = sprDebris102; // Temporary duh
            image_index = random(image_number);
            image_speed = 0;
            motion_add(other.direction + orandom(20), other.speed);
        }
        repeat(4) with(instance_create(x, y, Dust)){
            motion_add(other.direction + orandom(20), other.speed / 2);
        }

        instance_destroy();
    }

     // Stay Still:
    else speed = 0;

#define CatDoor_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    motion_add(_hitdir, _hitvel);	// Knockback
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);	// Sound

     // Push Open Force:
    var _sx = lengthdir_x(other.hspeed, image_angle),
        _sy = lengthdir_y(other.vspeed, image_angle);

    openang += (_sx + _sy);

#define CatDoor_draw
    var h = (nexthurt > current_frame + 3);
    if(h) d3d_set_fog(1, c_white, 0, 0);
    for(var i = 0; i < image_number; i++){
        draw_sprite_ext(sprite_index, i, x, y - i, image_xscale, image_yscale, image_angle + (openang * image_yscale), image_blend, image_alpha);
    }
    if(h) d3d_set_fog(0, 0, 0, 0);

#define CatDoor_destroy
    instance_delete(my_wall);


#define CatGrenade_step
     // Rise & Fall:
    z_engine();
    depth = max(-z, -12);

     // Trail:
    if(random(2) < 1){
        with(instance_create(x + orandom(4), y - z + orandom(4), PlasmaTrail)) {
            sprite_index = sprToxicGas;
            image_xscale = 0.25;
            image_yscale = image_xscale;
            image_angle = random(360);
            image_speed = 0.4;
            depth = other.depth;
        }
    }

     // Hit:
    if(z <= 0) instance_destroy();

#define CatGrenade_destroy
    with(instance_create(x, y, Explosion)){
        team = other.team;
        creator = other.creator;
        hitid = other.hitid;
    }
    
    repeat(18) {
        with(scrEnemyShoot(ToxicGas, random(360), 4)) {
            friction = 0.2;
        }
    }

     // Sound:
    sound_play(sndGrenade);
    sound_play(sndToxicBarrelGas);

#define CatGrenade_draw
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale * right, image_angle - (speed * 2) + (max(zspeed, -8) * 8), image_blend, image_alpha);

#define CatGrenade_hit
    // nada

#define CatGrenade_wall
    // nada


#define Cathole_step
    enemyAlarms(1);
    if !image_index image_speed = 0;
    if floor(image_index) == 6 && !place_meeting(x,y,ImpactWrists){
        instance_create(x,y,ImpactWrists);//repeat(irandom_range(2,4)) with instance_create(x,y,MeleeHitWall) image_angle = irandom(359);
        Cathole_effects();
    }
    
#define Cathole_alrm0
    if instance_exists(cat){
        //Cathole_effects();
         // Players standing on top keep cats in
        if place_meeting(x,y,Player){
            with instance_nearest(x,y,Player) motion_add(point_direction(other.x,other.y,x,y),2);
            alarm0 = 30 + irandom(20);
            image_index = 6;
            image_speed = 0.4;

        }
         // Release cats
        else{
            image_index = 1;
            image_speed = 0.4;
            var _team = cat.team;
            with instance_create(x,y,PortalClear) team = _team;
            with(cat){
                canfly = false;
                alarm0 = 10;
                alarm1 = 90 + irandom(60);
                x = other.x;
                y = other.y;
                hole = noone;
            }
            cat = noone;
        }
    }
    else cat = noone;
    
#define Cathole_effects
    view_shake_at(x,y,10);
    sound_play_pitchvol(sndHitMetal,0.5,1);

#define CatLight_draw(_x, _y, _w1, _w2, _h1, _h2, _offset)
     // Trapezoid Bit:
    var _x1a = _x - (_w1 / 2),
        _x2a = _x1a + _w1,
        _y1 = _y,
        _x1b = _x - (_w2 / 2) + _offset,
        _x2b = _x1b + _w2,
        _y2 = _y + _h1;

    draw_trapezoid(_x1a, _x2a, _y1, _x1b, _x2b, _y2);

     // Half Oval Bit:
    var _segments = 8,
        _cw = _w2 / 2,
        _cx = _x1b + _cw,
        _cy = _y2;

    draw_primitive_begin(pr_trianglefan);
    draw_vertex(_cx, _cy);
    for(var i = 0; i <= _segments; i++){
        var a = (i / _segments) * -180;
        draw_vertex(_cx + lengthdir_x(_cw, a), _cy + lengthdir_y(_h2, a));
    }
    draw_primitive_end();

#define draw_trapezoid(_x1a, _x2a, _y1, _x1b, _x2b, _y2)
    draw_primitive_begin(pr_trianglestrip);
    draw_vertex(_x1a, _y1);
    draw_vertex(_x1b, _y2);
    draw_vertex(_x2a, _y1);
    draw_vertex(_x2b, _y2);
    draw_primitive_end();


#define PizzaDrain_step
     // Stay Still:
    if(instance_exists(target)){
        x = target.x;
        y = target.y + 16;
    }
    else{
        x = xstart;
        y = ystart;
    }
    speed = 0;

     // Animate:
    if(sprite_index != spr_idle){
        if(anim_end) sprite_index = spr_idle;
    }

     // Death:
    if(my_health <= 0) instance_destroy();

#define PizzaDrain_destroy
    sound_play(snd_dead);

     // Corpse:
    with(instance_create(x, y, Corpse)){
        sprite_index = other.spr_dead;
        mask_index = other.mask_index;
        image_xscale = other.image_xscale;
        size = other.size;
    }

    /// Entrance:
        var _sx = (floor(x / 32) * 32) - 16,
            _sy = (floor(y / 32) * 32) - 16;

         // Borderize Area:
        var _borderY = _sy - 248;
        area_border(_borderY, string(GameCont.area), background_color);

         // Path Gen:
        var _dir = 90,
            _path = [];

        instance_create(_sx + 16, _sy + 16, PortalClear);
        while(_sy >= _borderY - 224){
            with(instance_create(_sx, _sy, Floor)) array_push(_path, id);
    
            if(_sy >= _borderY + 32) _dir = 90;
            else{
                _dir += choose(0, 0, 0, -90, 90);
                if(((_dir + 360) mod 360) == 270) _dir = 90;
            }
    
            _sx += lengthdir_x(32, _dir);
            _sy += lengthdir_y(32, _dir);
        }

         // Generate the Realm:
        area_generate(_sx, _sy, sewers);

         // Finish Path:
        with(_path){
            sprite_index = area_get_sprite(sewers, sprFloor1B);
            scrFloorWalls();
        }
        floor_reveal(_path, 2);


#define InvMortar_hurt(_hitdmg, _hitvel, _hitdir)
    if random(1) < _hitdmg / 25{
        var _a = instances_matching(enemy, "object_index", InvLaserCrystal, InvSpider),
            _n = array_length_1d(_a),
            _x = x,
            _y = y;
        if _n
            with _a[irandom(_n-1)] if distance_to_object(instance_nearest(x,y,Player)) > 32{
                other.x = x;
                other.y = y;
                x = _x;
                y = _y;
            }
    }
    Mortar_hurt(_hitdmg, _hitvel, _hitdir);
    
#define Mortar_step
    enemyAlarms(2);

     // Animate:
    if(sprite_index != spr_hurt and sprite_index != spr_fire){
    	if(speed <= 0) sprite_index = spr_idle;
    	else if(sprite_index == spr_idle) sprite_index = spr_walk;
    }
    else{
         // End Hurt Sprite:
        if(sprite_index = spr_hurt and image_index > 2) sprite_index = spr_idle;

         // End Fire Sprite:
        if(sprite_index = spr_fire && (image_index > sprite_get_number(spr_fire) - 1)){
            sprite_index = spr_idle;
        }
    }
    
     // Charging effect:
    if sprite_index == spr_fire && random(5) < current_time_scale{
        var _x = x + 6 * right,
            _y = y - 16,
            _l = irandom_range(16, 24),
            _d = irandom(359);
        with instance_create(_x + lengthdir_x(_l, _d), _y + lengthdir_y(_l, _d), LaserCharge){
            depth = other.depth - 1;
            motion_set(_d + 180, random_range(1,2));
            alarm0 = point_distance(x, y, _x, _y) / speed;
        }
    }

    enemyWalk(walkspd, maxspd);

#define Mortar_alrm0
    alarm0 = 80 + irandom(20);
    target = instance_nearest(x, y, Player);

     // Near Target:
    if(target_in_distance(0, 240)){
        var _targetDir = point_direction(x, y, target.x, target.y);

         // Attack:
        if(random(3) < 1){
            ammo = 4;
            alarm1 = 26;
            sprite_index = spr_fire;
            sound_play(sndCrystalJuggernaut);
        }

         // Move Towards Target:
        else{
            walk = 15 + random(30);
            direction = _targetDir + orandom(15);
            alarm0 = 40 + irandom(40);
        }

         // Facing:
        scrRight(_targetDir);
    }

     // Passive Movement:
    else{
        walk = 10;
        alarm0 = 50 + irandom(30);
        direction = random(360);
        scrRight(direction);
    }

#define Mortar_alrm1
    if(ammo > 0){
        target = instance_nearest(x, y, Player);
        
        if(target < 0)
        exit;

        var _targetDir = point_direction(x, y, target.x, target.y) + orandom(6);

         // Sound:
        sound_play(sndCrystalTB);
        sound_play(sndPlasma);

         // Facing:
        scrRight(_targetDir);
        
         // Shoot Mortar:
        with(scrEnemyShootExt(x - (2 * right), y, "MortarPlasma", _targetDir, 3)){
            z += 18;
            depth = 12;
            zspeed = (point_distance(x, y - z, other.target.x, other.target.y) / 8) + orandom(1);
            right = other.right;
        }

        alarm1 = 4;
        ammo--;
    }

#define Mortar_hurt(_hitdmg, _hitvel, _hitdir)
    my_health -= _hitdmg;			// Damage
    motion_add(_hitdir, _hitvel);	// Knockback
    nexthurt = current_frame + 6;	// I-Frames
    sound_play_hit(snd_hurt, 0.3);	// Sound

     // Hurt Sprite:
    if(sprite_index != spr_fire){
        sprite_index = spr_hurt;
        image_index = 0;
    }

#define Mortar_draw
     // Flash White w/ Hurt While Firing:
    if(
        sprite_index == spr_fire &&
        nexthurt > current_frame &&
        (nexthurt + current_frame) mod (room_speed/10) = 0
    ){
        d3d_set_fog(true, c_white, 0, 0);
        draw_self_enemy();
        d3d_set_fog(false, c_black, 0, 0);
    }

     // Normal Self:
    else draw_self_enemy();


#define MortarPlasma_step
     // Rise & Fall:
    z_engine();
    depth = max(-z, -12);

     // Trail:
    if(random(2) < 1){
        with(instance_create(x + orandom(4), y - z + orandom(4), PlasmaTrail)) {
            sprite_index = spr.MortarTrail;
            depth = other.depth;
        }
    }

     // Hit:
    if(z <= 0) instance_destroy();

#define MortarPlasma_destroy
    view_shake_at(x, y, 8);
    with(instance_create(x, y, PlasmaImpact)){
        sprite_index = spr.MortarImpact;
        team = other.team;
        creator = other.creator;
        hitid = other.hitid;
        damage = 1;
    }

     // Sound:
    sound_play(sndPlasmaHit);

#define MortarPlasma_draw
    var _maxtilt = 45,
        _angle = 90 - clamp(hspeed * 20, -_maxtilt, _maxtilt);
    draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale * right, _angle, image_blend, image_alpha);

#define MortarPlasma_hit
    // nada

#define MortarPlasma_wall
    // nada


#define NewCocoon_death
     // Hatch 1-3 Spiders:
    repeat(irandom_range(1, 3)) {
    	obj_create(x,y,"Spiderling");
    }

#define Spiderling_step
    enemyAlarms(1);
    enemySprites();
    enemyWalk(walkspd,maxspd);
    
#define Spiderling_alrm0
    alarm0 = 10 + irandom(10);
    target = instance_nearest(x,y,Player);
    
    if target_is_visible() && target_in_distance(0, 96){
        scrWalk(14, point_direction(x, y, target.x, target.y) + orandom(20));
    }
    else scrWalk(12, direction + orandom(20));
    scrRight(direction);



#define step
     // Reset Lights:
    with(instances_matching(GenCont, "catlight_reset", null)){
        catlight_reset = true;
        global.catLight = [];
    }

#define draw_dark // Drawing Grays
    draw_set_color(c_gray);

     // Cat Light:
    with(global.catLight){
        offset = random_range(-1, 1);

         // Flicker:
        if(current_frame_active){
            if(random(60) < 1) active = false;
            else active = true;
        }

        if(active){
            var b = 2; // Border Size
            CatLight_draw(x, y, w1 + b, w2 + (3 * (2 * b)), h1 + (2 * b), h2 + b, offset);
        }
    }

     // TV:
    with(TV) draw_circle(x, y, 64 + random(2), 0);

    draw_set_color(c_white);

#define draw_dark_end // Drawing Clear
    draw_set_color(c_black);

     // Cat Light:
    with(global.catLight) if(active){
        CatLight_draw(x, y, w1, w2, h1, h2, offset);
    }

     // TV:
    with(TV){
        var o = orandom(1);
        CatLight_draw(x + 1, y - 6, 12 + abs(o), 48 + o, 48, 8 + o, 0);
    }



 /// HELPER SCRIPTS /// 
#define draw_self_enemy()                                                                       mod_script_call("mod", "teassets", "draw_self_enemy");
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call("mod", "teassets", "draw_weapon", _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define scrWalk(_walk, _dir)                                                                    mod_script_call("mod", "teassets", "scrWalk", _walk, _dir);
#define scrRight(_dir)                                                                          mod_script_call("mod", "teassets", "scrRight", _dir);
#define scrEnemyShoot(_object, _dir, _spd)                                              return  mod_script_call("mod", "teassets", "scrEnemyShoot", _object, _dir, _spd);
#define scrEnemyShootExt(_x, _y, _object, _dir, _spd)                                   return  mod_script_call("mod", "teassets", "scrEnemyShootExt", _x, _y, _object, _dir, _spd);
#define enemyAlarms(_maxAlarm)                                                                  mod_script_call("mod", "teassets", "enemyAlarms", _maxAlarm);
#define enemyWalk(_spd, _max)                                                                   mod_script_call("mod", "teassets", "enemyWalk", _spd, _max);
#define enemySprites()                                                                          mod_script_call("mod", "teassets", "enemySprites");
#define enemyHurt(_hitdmg, _hitvel, _hitdir)                                                    mod_script_call("mod", "teassets", "enemyHurt", _hitdmg, _hitvel, _hitdir);
#define scrDefaultDrop()                                                                        mod_script_call("mod", "teassets", "scrDefaultDrop");
#define target_in_distance(_disMin, _disMax)                                            return  mod_script_call("mod", "teassets", "target_in_distance", _disMin, _disMax);
#define target_is_visible()                                                             return  mod_script_call("mod", "teassets", "target_is_visible");
#define z_engine()                                                                              mod_script_call("mod", "teassets", "z_engine");
#define lightning_connect(_x1, _y1, _x2, _y2, _arc)                                     return  mod_script_call("mod", "teassets", "lightning_connect", _x1, _y1, _x2, _y2, _arc);
#define scrLightning(_x1, _y1, _x2, _y2, _enemy)                                        return  mod_script_call("mod", "teassets", "scrLightning", _x1, _y1, _x2, _y2, _enemy);
#define scrBossHP(_hp)                                                                  return  mod_script_call("mod", "teassets", "scrBossHP", _hp);
#define scrBossIntro(_name, _sound, _music)                                                     mod_script_call("mod", "teassets", "scrBossIntro", _name, _sound, _music);
#define scrWaterStreak(_x, _y, _dir, _spd)                                              return  mod_script_call("mod", "teassets", "scrWaterStreak", _x, _y, _dir, _spd);
#define scrRadDrop(_x, _y, _raddrop, _dir, _spd)                                        return  mod_script_call("mod", "teassets", "scrRadDrop", _x, _y, _raddrop, _dir, _spd);
#define orandom(n)                                                                      return  mod_script_call("mod", "teassets", "orandom", n);
#define floor_ext(_num, _round)                                                         return  mod_script_call("mod", "teassets", "floor_ext", _num, _round);
#define array_count(_array, _value)                                                     return  mod_script_call("mod", "teassets", "array_count", _array, _value);
#define array_flip(_array)                                                              return  mod_script_call("mod", "teassets", "array_flip", _array);
#define instances_named(_object, _name)                                                 return  mod_script_call("mod", "teassets", "instances_named", _object, _name);
#define nearest_instance(_x, _y, _instances)                                            return  mod_script_call("mod", "teassets", "nearest_instance", _x, _y, _instances);
#define instances_seen(_obj, _ext)                                                      return  mod_script_call("mod", "teassets", "instances_seen", _obj, _ext);
#define frame_active(_interval)                                                         return  mod_script_call("mod", "teassets", "frame_active", _interval);
#define area_generate(_x, _y, _area)                                                    return  mod_script_call("mod", "teassets", "area_generate", _x, _y, _area);
#define scrFloorWalls()                                                                 return  mod_script_call("mod", "teassets", "scrFloorWalls");
#define floor_reveal(_floors, _maxTime)                                                 return  mod_script_call("mod", "teassets", "floor_reveal", _floors, _maxTime);
#define area_border(_y, _area, _color)                                                  return  mod_script_call("mod", "teassets", "area_border", _y, _area, _color);
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call("mod", "teassets", "area_get_sprite", _area, _spr);
#define obj_create(_x, _y, _obj)                                                        return  mod_script_call("mod", "telib", "obj_create", _x, _y, _obj);
#macro sewers "secret"