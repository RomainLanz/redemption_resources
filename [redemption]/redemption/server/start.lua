Citizen.CreateThread(function ()

  TriggerEvent('es:setDefaultSettings', {
    pvpEnabled = true,
    debugInformation = false,
    startingCash = 500,
    nativeMoneySystem = false,
    enableLogging = false,
  })

end)
