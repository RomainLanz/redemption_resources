-- -
-- Redemption Server Source Code
--
-- @version 2017.08.27
--

resource_type 'gametype' { name = 'Redemption 1.0' }

client_scripts {
  'client/spawn.lua',
  'client/pointing.lua',
  'client/handsup.lua',
}

server_scripts {
  'server/start.lua',
}
