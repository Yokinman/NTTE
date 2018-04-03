#define init
{ //sprites
	global.sprCoastTrans = sprite_add("../sprites/areas/Coast/sprCoastTrans.png", 1, 0, 0);
	global.sprFloorCoast = sprite_add("../sprites/areas/Coast/sprFloorCoast.png", 4, 0, 0);
	global.sprFloorCoastTrans = sprite_add("../sprites/areas/Coast/sprFloorCoastTrans.png", 4, 0, 0);
	global.sprFloorCoastB = sprite_add("../sprites/areas/Coast/sprFloorCoastB.png", 3, 0, 0);
	global.sprDetailCoast = sprite_add("../sprites/areas/Coast/sprDetailCoast.png", 6, 4, 4);

	global.sprBloomingCactus1 = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactus.png", 1, 12, 12);
	global.sprBloomingCactus1Hurt = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactusHurt.png", 3, 12, 12);
	global.sprBloomingCactus1Dead = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactusDead.png", 4, 12, 12);

	global.sprBloomingCactus2 = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactus2.png", 1, 12, 12);
	global.sprBloomingCactus2Hurt = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactus2Hurt.png", 3, 12, 12);
	global.sprBloomingCactus2Dead = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactus2Dead.png", 4, 12, 12);

	global.sprBloomingCactus3 = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactus3.png", 1, 12, 12);
	global.sprBloomingCactus3Hurt = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactus3Hurt.png", 3, 12, 12);
	global.sprBloomingCactus3Dead = sprite_add("../sprites/areas/Coast/Props/sprBloomingCactus3Dead.png", 4, 12, 12);

	global.sprPalm = sprite_add("../sprites/areas/Coast/Props/sprPalm.png", 1, 24, 40);
	global.sprPalmHurt = sprite_add("../sprites/areas/Coast/Props/sprPalmHurt.png", 3, 24, 40);
	global.sprPalmDead = sprite_add("../sprites/areas/Coast/Props/sprPalmDead.png", 4, 24, 40);
}

global.sfx = 7500
global.sfy = 7500
global.sf = surface_create(5000,5000)
global.foamsurface = surface_create(5000,5000)
global.foamsubsurface = surface_create(5000,5000)

if GameCont.area = mod_current{
	with(instances_matching(CustomDraw, "name", "darksea_draw")) {
		instance_destroy();
	}
	with(script_bind_draw(darksea_draw, 10)){
		name = "darksea_draw";
		image_alpha = 0.12;
	}
}

#define area_name
return "COAST-@1(sprInterfaceIcons)";

#define area_secret
return 1;

#define area_sprite(q)
switch(q) {
    case sprFloor1: return global.sprFloorCoast;
    case sprFloor1B: return global.sprFloorCoastB;
    case sprFloor1Explo: return mskNone;
    case sprWall1Trans: return sprWall1Trans;
    case sprWall1Bot: return sprWall1Bot;
    case sprWall1Out: return sprWall1Out;
    case sprWall1Top: return sprWall1Top;
    case sprDebris1: return sprDebris1;
	case sprDetail1: return global.sprDetailCoast;
}

#define area_start
with(Wall){ instance_delete(self); }
with(Top){ instance_delete(self); }
with(TopSmall){ instance_delete(self); }
//this doesnt work but the customdraws get destroyed when the level ends anyway so meh
with(instances_matching(CustomDraw, "name", "darksea_draw")) {
	instance_destroy();
}
with(script_bind_draw(darksea_draw, 10)){
	name = "darksea_draw";
	image_alpha = 0.12;
}

#define area_setup
goal = 100;
BackCont.shadcol = c_black;

#define area_make_floor
instance_create(x, y, Floor);

var turn = choose(0, 0, 0, 0, 0, 0, 0, 0, 0, 90, -90, 90, -90, 180);
direction += turn;
if (turn == 180 && point_distance(x, y, 10016, 10016) > 48) {
    // turnarounds - weapon chests spawn in such
    instance_create(x, y, Floor);
    instance_create(x + 16, y + 16, WeaponChest);
}
if (random(2) < 1) {
	// big splotches of land
	for(_x = 0; _x < 3; _x++)
	{
		for(_y = 0; _y < 3; _y++)
		{
			instance_create(x + _x * 32, y + _y * 32, Floor);
		}
	}
}
if (random(19 + instance_number(FloorMaker)) > 22) {
    // dead ends - ammo chests spawn in such
    if (point_distance(x, y, 10016, 10016) > 48) {
        instance_create(x + 16, y + 16, AmmoChest);
        instance_create(x, y, Floor);
    }
    instance_destroy();
} else if (random(4) < 1) {
    // branching
    instance_create(x, y, FloorMaker);
}

/*#define area_transit
if (lastarea != "coast" && area = "bigfish") { //hacky way to make sure you go to the right area
    area = "coast";
}*/

#define area_finish
if(lastarea = "coast" and subarea = 3) {
	area = 101;
	subarea = 1;
}
else
{
	lastarea = area;
	subarea++;
}

#define area_pop_enemies
if (random(4) < 1) obj_create(x + 16, y + 16, "Diver")

#define darksea_draw
//transition tiles
if array_length_1d(instances_matching(Floor,"coasttrans",null)) || !surface_exists(global.sf){
	if !surface_exists(global.sf) global.sf = surface_create(5000,5000)
	surface_set_target(global.sf)
	//water color
	draw_clear(make_color_rgb(27,118,184))
	with Floor{
		coasttrans = 1
		for var a = 0; a < 360; a+=45{
			//the main bit where it draws shit around floors
			draw_sprite(global.sprFloorCoastTrans,irandom(3),x-global.sfx+lengthdir_x(32,a),y-global.sfy+lengthdir_y(32,a))
		    var floors = 0; 
		    //some weird thing i used to fill in gaps that im not entirely sure still works but meh
		    //it kinda works, it doesnt account for the additional distance required for diangonals though
			for var i = 1; i <= 10; i++{
				if !position_meeting(x+lengthdir_x(32*i,a),y+lengthdir_y(32*i,a),Floor) floors++
				else break
		    }
		    if floors<=5{
		    	for var i = 1; i<= floors; i++{
		    		draw_sprite(global.sprFloorCoastTrans,irandom(3),x-global.sfx+lengthdir_x(32*i,a),y-global.sfy+lengthdir_y(32*i,a))
		    	}
		    }
		}
	}
	surface_reset_target()
}
if array_length_1d(instances_matching(Floor,"coastfoam",null)) || !surface_exists(global.foamsurface){
	if !surface_exists(global.foamsurface) global.foamsurface = surface_create(5000,5000)
	surface_set_target(global.foamsurface)
	draw_clear_alpha(c_black,0)
	d3d_set_fog(1,c_white,1,1)
	with Floor{
		coastfoam = 1
		draw_sprite(global.sprFloorCoast,image_index,x-global.sfx,y-global.sfy)
	}
	d3d_set_fog(0,0,0,0)
	surface_set_target(global.foamsubsurface)
	draw_clear_alpha(c_black,0)
	surface_reset_target()
}

if !surface_exists(global.foamsubsurface){
	global.foamsubsurface = surface_create(5000,5000)
}
	surface_set_target(global.foamsubsurface)
	var sfoff = 10;
	//interval
	var num = 30
	//scalers
	var num2 = .5
	var num4 = .3
	//wave length
	var num3 = 8
	//dont touch this
	var off = round(current_frame mod num * num2);
	//change the -5 for the thickness of the waves 
	var off2 = round((current_frame -(5 * num4/num2)) mod num * num4);
	if off < num3 
		for var i = 0; i< 360; i+=45{
			draw_surface(global.foamsurface,sfoff+lengthdir_x(off,i),sfoff+lengthdir_y(off,i))
		}
	if off2 < num3 {
		draw_set_blend_mode(bm_subtract)
		for var i = 0; i< 360; i+=45{
			draw_surface(global.foamsurface,sfoff+lengthdir_x(off2,i),sfoff+lengthdir_y(off2,i))
		}
	}
	draw_set_blend_mode(bm_normal)
	surface_reset_target()

draw_surface(global.sf,global.sfx,global.sfy)

draw_set_alpha(.4)
draw_sprite_tiled(global.sprCoastTrans, 0, 0 + sin(current_frame * 0.02) * 4, 0 + sin(current_frame * 0.05) * 2)
draw_set_alpha(1)

draw_surface(global.foamsubsurface,global.sfx - sfoff,global.sfy - sfoff)


draw_sprite_tiled_ext(mskFloor, 0, 0, 0, 1, 1, c_black, image_alpha);

if(!instance_exists(enemy)) {
	if(image_alpha > 0)
	image_alpha -= 0.02;
}

#define area_pop_props
if(random(12) < 1) {
    var o;
    o = choose(Cactus, Cactus, Cactus, StreetLight);
    with(instance_create(x + sprite_width/2, y + sprite_height/2, o)) {
        if(o = StreetLight) {
            spr_idle = global.sprPalm;
            spr_hurt = global.sprPalmHurt;
            spr_dead = global.sprPalmDead;

            snd_hurt = sndHitPlant;
            snd_dead = sndHitPlant;

            my_health = 40;
        } else {
            var s;
            s = irandom_range(1, 3);
            if(s = 1) {
                spr_idle = global.sprBloomingCactus1;
                spr_hurt = global.sprBloomingCactus1Hurt;
                spr_dead = global.sprBloomingCactus1Dead;
            } else if(s = 2) {
                spr_idle = global.sprBloomingCactus2;
                spr_hurt = global.sprBloomingCactus2Hurt;
                spr_dead = global.sprBloomingCactus2Dead;
            } else {
                spr_idle = global.sprBloomingCactus3;
                spr_hurt = global.sprBloomingCactus3Hurt;
                spr_dead = global.sprBloomingCactus3Dead;
            }
        }

        sprite_index = spr_idle;
    }
}

#define obj_create(_x, _y, object_name)
return mod_script_call("mod", "telib", "obj_create", _x, _y, object_name);