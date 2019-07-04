#define init
    global.sprLoad = sprite_add("sprites/menu/sprNTTELoading.png", 2, 32, 8);

     // Loading Vars:
    global.load = 0;
    global.load_hudy = 0;
    global.load_hudb = 0;
    global.list = [ // [mod, delay]
        ["teassets.mod.gml",                        5],
        ["ntte.mod.gml",                            1],
        ["telib.mod.gml",                           1],
        ["petlib.mod.gml",                          1],
        ["objects/tegeneral.mod.gml",               0],
        ["objects/tedesert.mod.gml",                0],
        ["objects/tecoast.mod.gml",                 1],
        ["objects/teoasis.mod.gml",                 0],
        ["objects/tetrench.mod.gml",                0],
        ["objects/tesewers.mod.gml",                1],
        ["objects/tescrapyard.mod.gml",             0],
        ["objects/tecaves.mod.gml",                 2],
        ["areas/coast.area.gml",                    1],
        ["areas/oasis.area.gml",                    1],
        ["areas/pizza.area.gml",                    1],
        ["areas/lair.area.gml",                     1],
        ["areas/trench.area.gml",                   1],
        ["races/parrot.race.gml",                   1],
        ["weps/merge.wep.gml",                      1],
        ["weps/crabbone.wep.gml",                   1],
        ["weps/scythe.wep.gml",                     1],
        ["weps/bat disc launcher.wep.gml",          1],
        ["weps/bat disc cannon.wep.gml",            1],
        ["weps/harpoon launcher.wep.gml",           1],
        ["weps/net launcher.wep.gml",               1],
        ["weps/trident.wep.gml",                    1],
        ["weps/bubble rifle.wep.gml",               1],
        ["weps/bubble shotgun.wep.gml",             1],
        ["weps/bubble minigun.wep.gml",             1],
        ["weps/bubble cannon.wep.gml",              1],
        ["weps/lightring launcher.wep.gml",         1],
        ["weps/super lightring launcher.wep.gml",   1],
        ["weps/tesla coil.wep.gml",                 1],
        ["weps/electroplasma rifle.wep.gml",        1],
        ["weps/electroplasma shotgun.wep.gml",      1],
        ["weps/quasar blaster.wep.gml",             1],
        ["weps/quasar rifle.wep.gml",               1],
        ["weps/quasar cannon.wep.gml",              1],
        ["crowns/crime.crown.gml",                  1]
    ];

     // Wait for /allowmod:
    while(!mod_sideload()) wait 0;

     // Wait for Loading Bar to Appear:
    sound_play_pitchvol(sndMeleeFlip, 1.4 + random(0.1), 0.25);
    sound_play_pitchvol(sndHitMetal,  1.4 + random(0.1), 0.25);
    while(global.load_hudy < 0.99) wait 0;

     // Load Mods:
    with(global.list){
        var _load = self[0],
            _wait = self[1];

        mod_load(_load);

        global.load += 1 + random(0.2);

        if(_wait > 0) wait _wait;
    }

     // Finished:
    trace_color("NTTE | Finished loading!", c_yellow);
    repeat(20 * (game_height / 240)) trace("");
    sound_play_pitchvol(sndEXPChest, 1.5 + random(0.1), 0.6);
    sound_play_pitchvol(sndNoSelect, 0.6 + random(0.1), 0.5);

     // Wait for Loading Bar to Go Away:
    while(global.load_hudy > 0) wait 0;

     // Unload teloader.mod:
    mod_loadtext("main3.txt");

#define draw_gui
     // Hiding/Showing Loading Bar:
    if(global.load < array_length(global.list)){
        global.load_hudy += (1 - global.load_hudy) * 0.3;
    }
    else{
        if(global.load_hudb < 2){
            global.load_hudb += 0.15;
        }
        else global.load_hudy -= 0.4;
    }

     // Loading Bar:
    var _x = round(game_width / 2),
        _y = round(22 * global.load_hudy),
        _spr = global.sprLoad,
        _load = (global.load / array_length(global.list));

    draw_sprite(_spr, 0, _x, _y);

    for(var i = 0; i <= 1; i++){
        var _bloom = clamp(global.load_hudb, 0.4, i),
            _xsc = 1 + (0.15 * _bloom),
            _ysc = 1 + (0.5 * _bloom),
            _alp = ((i <= 0) ? 1 : (0.25 - (0.025 * global.load_hudb)));

        if(_alp > 0){
            if(i > 0) draw_set_blend_mode(bm_add);

            draw_sprite_part_ext(
                _spr,
                1,
                0,
                0,
                (sprite_get_width(_spr) * _load) + i,
                sprite_get_height(_spr),
                _x - (_xsc * sprite_get_xoffset(_spr)),
                _y - (_ysc * sprite_get_yoffset(_spr)),
                _xsc,
                _ysc,
                c_white,
                _alp
            );
        }
    }
    draw_set_blend_mode(bm_normal);
    
     // Text:
    draw_set_font(fntM);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_nt(_x + (string_width("%") / 4), _y, `${round(_load * 100)}%`);