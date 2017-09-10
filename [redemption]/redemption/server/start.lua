Citizen.CreateThread(function ()

  TriggerEvent('es:setDefaultSettings', {
    pvpEnabled = true,
    debugInformation = true,
    startingCash = 500,
    nativeMoneySystem = false,
    enableLogging = true,
  })

end)
