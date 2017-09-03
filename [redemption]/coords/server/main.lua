TriggerEvent('es:addCommand', 'displayPos', function (source, args, user)
  TriggerClientEvent('red:displayPos', source)
end, { help = 'Display your position' })
