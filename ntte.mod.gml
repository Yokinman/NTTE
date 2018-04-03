#define init
global.generating = 0;

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
    	
    	with(Player) {
    		if("wading" in self) {
    			wading = 0;
    			image_alpha = 1;
    			if("shd_" in self) {
    				spr_shadow = shd_;
    			}
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
    else if(instance_exists(GenCont))
    {
    	with(Player) {
    		if("wading" in self) {
    			wading = 0;
    			image_alpha = 1;
    			if("shd_" in self) {
    				spr_shadow = shd_;
    			}
    		}
    	}
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
	with(Corpse) {
		do_portal = 0;
	}

	if(instance_exists(Floor)) {
		with(hitme) if instance_exists(self) {
			var n = instance_nearest(x - sprite_get_width(n.sprite_index)/2, y - sprite_get_height(n.sprite_index)/2, Floor);
			var d = point_distance(n.x + sprite_get_width(n.sprite_index)/2, n.y + sprite_get_height(n.sprite_index)/2, x, y);
			if(d > sprite_get_width(n.sprite_index) - 4 and d > sprite_get_height(n.sprite_index) - 4) { 
				if("wading" in self) {
					if(wading = 0) {
						image_alpha = 0;
						wading = 1;
						if(spr_shadow != mskNone) {
							shd_ = spr_shadow;
							spr_shadow = mskNone;
						}
						instance_create(x, y, RainSplash);
						repeat(irandom_range(4, 8)) {
							instance_create(x, y, Bubble);
						}
						repeat(irandom_range(2, 4)) {
							instance_create(x, y, Dust);
						}
					}
					else
					{
						if(!instance_exists(Portal) and object_index = Player and d >= 120) {
							with instance_create(x, y, Portal) { image_alpha = 0; };
						}
					}
					
					if(instance_exists(enemy) and d >= 80) {
						motion_add(point_direction(x, y, n.x, n.y), 3);
					}
				}
				else
				{
					wading = 0;
				}
			}
			else if("wading" in self and wading = 1)
			{
				if("shd_" in self) {
					spr_shadow = shd_;
				}
				image_alpha = 1;
				wading = 0;
			}
		}
	}

	with(instances_matching(enemy, "canfly", 0)) { // things die bc of the missing walls
		canfly = 1;
	}
}

#define draw
if(instance_exists(Floor)) { // i stole this from blaac's hardmode
	with(instances_matching(hitme, "wading", 1)) { // i hate this a lot but whatever. swimmin i guess
		var n = instance_nearest(x - sprite_get_width(n.sprite_index)/2, y - sprite_get_height(n.sprite_index)/2, Floor);
		var d = point_distance(n.x + sprite_get_width(n.sprite_index)/2, n.y + sprite_get_height(n.sprite_index)/2, x, y);
		if object_index = Player{ 
			if bwep != 0{ 
				if race_id != 7
					draw_sprite_ext(weapon_get_sprt(bwep),0,x-right*2,y+ + ((d - 16) * 0.2),1,bwepflip*right*-1,90+15*right,c_silver,1)
				else
					draw_sprite_ext(weapon_get_sprt(bwep),0,x+lengthdir_x(bwkick*-1,gunangle),y+lengthdir_y(bwkick*-1,gunangle) + ((d - 16) * 0.2),1,right*-1,gunangle+wepangle,c_white,1);
				}
			if gunangle < 180{
				draw_sprite_ext(weapon_get_sprt(wep),0,x+lengthdir_x(wkick,gunangle),y+lengthdir_y(wkick,gunangle) + ((d - 16) * 0.2),1,right,gunangle+wepangle,c_white,1);
			}
			draw_sprite_part_ext(sprite_index, image_index, 0, 0, sprite_width, sprite_height - ((d - 16) * 0.2), x - (sprite_width/2) * right, y + ((d - 16) * 0.2) - sprite_height/2, right, image_yscale, image_blend, 1);
			if gunangle >= 180
			draw_sprite_ext(weapon_get_sprt(wep),0,x+lengthdir_x(wkick*-1,gunangle),y+lengthdir_y(wkick*-1,gunangle) + ((d - 16) * 0.2),1,right,gunangle+wepangle,c_white,1);
		}
		else
		{
			draw_sprite_part_ext(sprite_index, image_index, 0, 0, sprite_width, sprite_height - ((d - 16) * 0.2), x - (sprite_width/2) * right, y + ((d - 16) * 0.2) - sprite_height/2, right, image_yscale, image_blend, 1);
		}
	}
}

#define draw_shadows
with instances_matching(CustomProjectile, "name", "MORTARPLASMA") // i should prolly make this better but fuck that
{
	draw_sprite(shd24, 0, x, y);
}

#define obj_create(_x, _y, object_name)
return mod_script_call("mod", "telib", "obj_create", _x, _y, object_name);