fx_version 'adamant'
game 'gta5'
lua54 'yes'
description 'Car Scraps Script for FiveM ESX'

shared_scripts {
    '@es_extended/locale.lua',
    '@ox_lib/init.lua',
    'shared.lua',
    'config.lua',

}

server_scripts {
    '@es_extended/locale.lua',
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    'drawtext.lua',
    'config.lua',
    'client.lua'
}
