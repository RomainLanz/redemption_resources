-- -
-- Redemption Server Source Code
--
-- @version 2017.09.03
--

client_scripts {
  'client/main.lua',
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  '@es_extended/locale.lua',
  'locales/fr.lua',
  'Config.lua',
  'server/main.lua',
}
