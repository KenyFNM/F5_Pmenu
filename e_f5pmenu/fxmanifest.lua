fx_version 'adamant'

game 'gta5'

dependency 'es_extended'

client_scripts {
	'@es_extended/locale.lua',
	'menu/dependencies/menu.lua',
	'cl_menu.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
    'menu/sv_deco.lua'
}
