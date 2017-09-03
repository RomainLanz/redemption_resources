RegisterNetEvent('red:displayPos')
AddEventHandler('red:displayPos', function ()
  local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))

  TriggerEvent('esx:showNotification', 'x=' .. x ..' y=' .. y .. ' z=' .. z)
end)
