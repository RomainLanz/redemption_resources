RegisterNetEvent('sly:Notify')
AddEventHandler('sly:Notify', function (options) {
  SendNUIMessage({ options = options })
}
