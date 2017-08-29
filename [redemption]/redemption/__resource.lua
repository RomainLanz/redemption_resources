-- -
-- Redemption Server Source Code
--
-- @version 2017.08.27
--

resource_type 'gametype' { name = 'Redemption v0.0.1' }

client_scripts {
  'client/spawn.lua',
}

server_scripts {
  'server/start.lua',
}
