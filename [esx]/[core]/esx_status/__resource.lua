resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Status'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/classes/status.lua',
	'client/main.lua'
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/css/app.css',
  'html/fonts/pdown.ttf',
	'html/scripts/app.js'
}