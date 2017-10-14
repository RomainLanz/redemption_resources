ESX               = nil
local ItemsLabels = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(source)
  TriggerEvent('esx_license:getLicenses', source, function (licenses)
    TriggerClientEvent('esx_weashop:loadLicenses', source, licenses)
  end)
end)

ESX.RegisterServerCallback('esx_weashop:requestDBItems', function (source, cb)

	MySQL.Async.fetchAll(
		'SELECT * FROM weashops',
		{},
		function(result)

			local shopItems  = {}

			for i=1, #result, 1 do

				if shopItems[result[i].name] == nil then
					shopItems[result[i].name] = {}
				end

				table.insert(shopItems[result[i].name], {
					name  = result[i].item,
					price = result[i].price,
					label = ESX.GetWeaponLabel(result[i].item)
				})

			end

			cb(shopItems)

		end
	)

end)

RegisterServerEvent('esx_weashop:buyLicense')
AddEventHandler('esx_weashop:buyLicense', function ()
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(source)

  if xPlayer.get('money') >= 5000 then
    xPlayer.removeMoney(5000)

    TriggerEvent('esx_license:addLicense', _source, 'weapon', function ()
      TriggerEvent('esx_license:getLicenses', _source, function (licenses)
        TriggerClientEvent('esx_weashop:loadLicenses', _source, licenses)
      end)
    end)
  else
    TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
  end
end)

RegisterServerEvent('esx_weashop:buyItem')
AddEventHandler('esx_weashop:buyItem', function(itemName, price, zone)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	if xPlayer.get('money') >= price then

		xPlayer.removeMoney(price)
		xPlayer.addWeapon(itemName, 42)

		TriggerClientEvent('esx:showNotification', _source, _U('buy') .. ESX.GetWeaponLabel(itemName))
	else
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
	end

end)
