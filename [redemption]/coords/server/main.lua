TriggerEvent('es:addCommand', 'displayPos', function (source, args, user)
  TriggerClientEvent('red:displayPos', source)
end, { help = 'Display your position' })

TriggerEvent('es:addGroupCommand', 'tp', 'dev', function (source, args, user)
  TriggerClientEvent('esx:teleport', source, { x = args[2], y = args[3], z = args[4] })
end, { help = 'Teleport your player' })
