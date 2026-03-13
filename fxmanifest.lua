fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'
name 'krs_drugs'
author 'karos7804'
description 'Krs Drugs'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
    'shared/config.lua'
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client/main.lua'
}

server_scripts {
    'shared/server.lua',
    'server/main.lua'
}

dependencies {
    'ox_lib',
    'ox_target',
    'ox_inventory',
    'qbx_core'
}