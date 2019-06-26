#define init
    while(!mod_sideload()) wait 1;

    with([ // [mod, delay]
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
        ["objects/tecaves.mod.gml",                 2],
        ["areas/coast.area.gml",                    1],
        ["areas/oasis.area.gml",                    1],
        ["areas/pizza.area.gml",                    1],
        ["areas/lair.area.gml",                     1],
        ["areas/trench.area.gml",                   1],
        ["races/parrot.race.gml",                   1],
        ["weps/merge.wep.gml",                      1],
        ["weps/crabbone.wep.gml",                   0],
        ["weps/bat disc launcher.wep.gml",          0],
        ["weps/bat disc cannon.wep.gml",            0],
        ["weps/bat tether.wep.gml",                 0],
        ["weps/harpoon launcher.wep.gml",           0],
        ["weps/net launcher.wep.gml",               0],
        ["weps/trident.wep.gml",                    0],
        ["weps/bubble rifle.wep.gml",               0],
        ["weps/bubble shotgun.wep.gml",             0],
        ["weps/bubble minigun.wep.gml",             0],
        ["weps/bubble cannon.wep.gml",              0],
        ["weps/lightring launcher.wep.gml",         0],
        ["weps/super lightring launcher.wep.gml",   0],
        ["weps/tesla coil.wep.gml",                 0],
        ["weps/electroplasma rifle.wep.gml",        0],
        ["weps/electroplasma shotgun.wep.gml",      0],
        ["weps/quasar blaster.wep.gml",             0],
        ["weps/quasar rifle.wep.gml",               0],
        ["weps/quasar cannon.wep.gml",              1]
    ]){
        var _load = self[0],
            _wait = self[1];

        mod_load(_load);

        if(_wait > 0) wait _wait;
    }

    mod_loadtext("main3.txt");