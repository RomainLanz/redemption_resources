TriggerEvent('es:addCommand', 'displayPos', function (source, args, user)
  TriggerClientEvent('red:displayPos', source)
end, { help = 'Display your position' })

TriggerEvent('es:addGroupCommand', 'tp', 'dev', function (source, args, user)
  TriggerClientEvent('esx:teleport', source, { x = args[2], y = args[3], z = args[4] })
end, { help = 'Teleport your player' })

TriggerEvent('es:addGroupCommand', 'notify', 'dev', function (source, args, user)
  TriggerClientEvent('sly:notify', source, {
    type = 'info',
    message = 'Test de notification'
  })
end, { help = 'Teleport your player' })
