function displayPermissionIssue ()
  TriggerClientEvent('chatMessage', source, 'SYSTEM', { 255, 0, 0 }, 'Insufficienct permissions!')
end

TriggerEvent('es:addGroupCommand', 'whitelist:load', 'admin', function (source, args, user)
  loadWhiteList()
end, function (source, args, user)
  displayPermissionIssue(source)
end, { help = 'Recharger la Whitelist'})

TriggerEvent('es:addGroupCommand', 'whitelist:add', 'admin', function (source, args, user)
  local steamID = 'steam:' .. args[2]

  MySQL.Sync.execute('INSERT INTO whitelist (identifier) VALUES (@identifier)', { ['@identifier'] = tostring(args[2]) })
  print('SteamID ajouté !')
  loadWhiteList()
end, function (source, args, user)
  displayPermissionIssue(source)
end, { help = "Ajouter quelqu'un dans la Whitelist", params = { steam = 'SteamID', help = 'SteamID already formated to hex' }})
