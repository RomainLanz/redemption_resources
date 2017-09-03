Citizen.CreateThread(function ()

  TriggerEvent('es:setDefaultSettings', {
    pvpEnabled = true,
    debugInformation = false,
    startingCash = 2000,
    nativeMoneySystem = false,
    enableLogging = false
  })

end)
