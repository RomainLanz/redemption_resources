Citizen.CreateThread(function ()

  TriggerEvent('es:setDefaultSettings', {
    pvpEnabled = true,
    debugInformation = true,
    startingCash = 2000,
    nativeMoneySystem = false,
    enableLogging = true
  })

end)
