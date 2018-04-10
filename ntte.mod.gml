#define init
    global.generating = 0;
    global.surfSwim = -1;
    global.surfSwimSize = 1000;

#define step
{ // GENERATION CODE //
    if((!instance_exists(GenCont) and !instance_exists(menubutton)) and global.generating = 1)
    {
    	if(GameCont.area = 1)
    	{
    		with(instance_create(0, 0, AmmoChest))
    		{
    			visible = 0;
    			mask_index = mskNone;
    		}
    	}
    	
    	if(GameCont.area != "coast") {
    		with(instances_matching(CustomDraw, "darksea_draw", 0)) {
    			instance_destroy();
    		}
    	}
    	
    	with(LaserCrystal) {
    	    if(random(4) < 1) {
    	        obj_create(x, y, "Mortar");
    	        instance_delete(self);
    	    }
    	}
    	
    	with(instances_matching(TopSmall, "bigdecal", null)) {
    	    bigdecal = 1;
    	    if(random(200) < 1) {
				with(obj_create(x, y, "Decal")){
				    sprite_index = mod_variable_get("mod", "telib", "sprDesertBigTopDecal");
				}
    	    }
    	}
    	
    	global.generating = 0;
    }
    else if(instance_exists(GenCont)){
    	global.generating = 1;
    }
} // GENERATION CODE //

with(Cocoon) { 
	obj_create(x, y, "NewCocoon");
	instance_delete(self);
}

with(instances_matching(Spider, "corpse", 0)) {
	if(my_health <= 0) {
		var c = instance_create(x, y, Corpse);
		c.sprite_index = spr_dead;
		c.image_xscale = image_xscale;
		c.image_yscale = image_yscale;
	}
}

if(GameCont.area = "coast") {
     // No Portals:
	with(Corpse) do_portal = 0;

	if(instance_exists(Floor)){
         // Destroy Projectiles Too Far Away:
        with(instances_matching_gt(projectile, "speed", 0)) if(distance_to_object(Floor) > 1000){
            instance_destroy();
        }

         // Water Wading:
        var v = [];
		with(instances_matching([hitme, Corpse, WepPickup, Grenade, HPPickup, AmmoPickup, chestprop, ChestOpen], "", null)){
		    if("wading" not in self) wading = 0;

			var o = (object_index == Player),
			    _splashvol = (o ? 1 : clamp(1 - (distance_to_object(Player) / 150), 0.1, 1));

			if(distance_to_object(Floor) > 4){
				 // Splash:
				if(wading <= 0){
					instance_create(x, y, RainSplash);
					repeat(irandom_range(4, 8)) instance_create(x, y, Sweat/*Bubble*/);
                    sound_play_pitchvol(choose(sndOasisChest, sndOasisMelee), 1.5 + random(0.5), _splashvol);
				}
				wading = distance_to_object(Floor);

				 // Push Back to Shore:
				if(
				    wading >= 80                    &&
				    (!o || instance_exists(enemy))  && // Don't push player if enemies exist
				    !instance_is(self, Corpse)      && // Don't push corpses
                    !instance_is(self, projectile)     // Don't push projectiles
				){
    			    var n = instance_nearest(x - 16, y - 16, Floor);
    				motion_add(point_direction(x, y, n.x, n.y), 4);
    			}

				if(visible){
				     // Set visibility:
				    v[array_length(v)] = id;

                     // Set Drawing Script:
    				var d = depth - 0.01,
			            _bind = 1;

                    with(instances_matching(CustomDraw, "name", "swim_draw")) if(round(100 * depth) / 100 == d){ // Add to existing script
                        inst[array_length(inst)] = other;
                        _bind = 0;
                        break;
                    }
                    if(_bind) with(script_bind_draw(swim_draw, d)){ // Make new script
				        name = script[2];
				        inst = [other];
				    }
				}
			}
			else if(wading > 0){
			    wading = 0;

			     // Sploosh:
                sound_play_pitchvol(choose(sndOasisChest, sndOasisMelee, sndOasisHurt), 1 + random(0.25), _splashvol);
				repeat(5 + random(5)) with(instance_create(x, y, Sweat)){
				    motion_add(other.direction, other.speed);
				}
			}
		}

		 // Set Visibility of Objects Before Drawing Events:
    	if(v != []) script_bind_step(reset_visible, 0, v);

         // Walk into Sea:
        if(!instance_exists(enemy)) with(instances_matching_ge(Player, "wading", 120)){
            if(!instance_exists(Portal)) with(instance_create(x, y, Portal)){
                with(PortalL) instance_destroy();
                sound_stop(sndPortalOpen);
                sound_play(sndOasisPortal);
                image_alpha = 0;
            }
            with(Portal){
                x = other.x;
                y = other.y;
                xprevious = x;
                yprevious = y;
                instance_create(x, y, Bubble);
            }
        }

         // Water Wading Surface:
        if(!surface_exists(global.surfSwim)){
            global.surfSwim = surface_create(global.surfSwimSize, global.surfSwimSize);
        }
	}

     // things die bc of the missing walls
	with(instances_matching(enemy, "canfly", 0)) canfly = 1;
}

#define swim_draw()
    var _surfw = global.surfSwimSize,
        _surfh = global.surfSwimSize,
        _surf = global.surfSwim;

    with(inst) if(instance_exists(self)){
        var _z = 2,
            _wh = _z + (sprite_height - sprite_get_bbox_bottom(sprite_index)) + ((wading - 16) * 0.2), // Wade/Water Height
            _surfx = x - (_surfw / 2),
            _surfy = y - (_surfh / 2);

         // Clamping:
        if(object_index == Van) _wh = min(_wh, 40);
        else if(object_index != Player || instance_exists(enemy)){
            _wh = min(_wh, sprite_yoffset);
        }

         // Bobbing:
        if(wading > sprite_height || !instance_is(self, hitme)){
            var _bobspd = 1 / 10,
                _bobmax = min(wading / sprite_height, 2),
                _bob = _bobmax * sin((current_frame + x + y) * _bobspd);

            _z += _bob;
            _wh += _bob;
        }

         // Call Draw Event to Surface:
        surface_set_target(_surf);
        draw_clear_alpha(0, 0);

        x -= _surfx;
        y -= _surfy;
        
        var c = 0;
        if(object_index == Player && canscope){
            c = canscope;
            canscope = 0;
             // Manually Draw Laser Sights Here:
            
        }

        if("right" in self || "rotation" in self) event_perform(ev_draw, 0);
        else draw_self();
        x += _surfx;
        y += _surfy;
        if(c) canscope = c;

        surface_reset_target();

         // Draw Transparent:
        var _yoff = (_surfh / 2) - (sprite_height - sprite_yoffset),
            _surfz = _surfy + _z,
            t = _surfh - _yoff - _wh,
            h = _surfh - t,
            _y = _surfz + t;

        draw_set_alpha(0.5);
        draw_surface_part(_surf, 0, t, _surfw, h, _surfx, _y);
        draw_set_alpha(1);

         // Water Interference Line Thing:
        d3d_set_fog(1, c_white, 0, 0);
        draw_surface_part_ext(_surf, 0, t, _surfw, 1, _surfx, _y, 1, 1, c_white, 0.5);
        d3d_set_fog(0, 0, 0, 0);

         // Draw Normal:
        var t = 0,
            h = _surfh - t - _yoff - _wh,
            _y = _surfz + t;

        draw_surface_part(_surf, 0, t, _surfw, h, _surfx, _y);

        visible = 1;
    }
    instance_destroy();

#define reset_visible(_inst)
    with(_inst) if(instance_exists(self)){
        if(!visible) with(instances_matching(CustomDraw, "name", "swim_draw")){
            if(inst == other || array_find_index(inst, other)) instance_destroy();
        }
        else visible = 0;
    }
    instance_destroy();

#define draw_shadows
with instances_matching(CustomProjectile, "name", "MORTARPLASMA") // i should prolly make this better but fuck that
{
	draw_sprite(shd24, 0, x, y);
}

#define obj_create(_x, _y, object_name)
return mod_script_call("mod", "telib", "obj_create", _x, _y, object_name);