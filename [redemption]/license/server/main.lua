ESX = nil
Licenses = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function loadLicenses ()
  local results = MySQL.Sync.fetchAll('SELECT * FROM licenses')

  for i = 1, #results, 1 do
    table.insert(Licenses, tostring(results[i].name))
  end
end

MySQL.ready(function ()
  loadLicenses()
end)

ESX.RegisterServerCallback('red:getPlayerLicenses', function (source, callback)
  local xPlayer  = ESX.GetPlayerFromId(source)
  local licenses = MySQL.Sync.fetchAll('SELECT * FROM user_licenses WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }) or {}

  callback(licenses)
end)

RegisterNetEvent('red:buyLicense')
AddEventHandler('red:buyLicense', function (name, price)
  local xPlayer  = ESX.GetPlayerFromId(source)

  if xPlayer.get('money') >= price then
    MySQL.Sync.execute(
      'INSERT INTO user_licenses (identifier, name, since) VALUES (@identifier, @name, NOW())',
      {
        ['@identifier'] = xPlayer.identifier,
        ['@name'] = name,
      }
    )

    xPlayer.removeMoney(price)
    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez acheté la license ' .. Licenses[name].label)
  else
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('not_enough'))
  end
end)
