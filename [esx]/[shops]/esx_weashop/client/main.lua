ESX                           = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
    
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('onClientMapStart', function()
	
	ESX.TriggerServerCallback('esx_weashop:requestDBItems', function(ShopItems)
		for k,v in pairs(ShopItems) do
			Config.Zones[k].Items = v
		end
	end)

end)

function OpenBuyLicenseMenu (zone)
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'shop_license',
    {
      title = "Acheter une license de port d'arme ?",
      align = 'left',
      elements = {
        { label = 'Oui ($5000)', value = 'yes' },
        { label = 'Non', value = 'no' },
      },
    },
    function (data, menu)        
      if data.current.value == 'yes' then
        TriggerEvent('esx:showNotification', 'You said yes!')
        TriggerServerEvent('red:buyLicense', 'weapon', 5000)
      end

      menu.close()
    end,
    function (data, menu)
      menu.close()
    end
  )
end

function OpenShopMenu(zone)

	local elements = {}

	for i=1, #Config.Zones[zone].Items, 1 do

		local item = Config.Zones[zone].Items[i]

		table.insert(elements, {
			label     = item.label .. ' - $' .. item.price,
			realLabel = item.label,
			value     = item.name,
			price     = item.price
		})

	end


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'shop',
		{
			title  = _U('shop'),
      align  = 'left',
			elements = elements
		},
		function(data, menu)				
			TriggerServerEvent('esx_weashop:buyItem', data.current.value, data.current.price, zone)
		end,
		function(data, menu)
			
			menu.close()
			
			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('shop_menu')
			CurrentActionData = {zone = zone}
		end
	)
end

AddEventHandler('esx_weashop:hasEnteredMarker', function(zone)
	
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = _U('shop_menu')
	CurrentActionData = {zone = zone}

end)

AddEventHandler('esx_weashop:hasExitedMarker', function(zone)

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()

end)

-- Create Blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Zones) do
	if v.legal==0 then
  	for i = 1, #v.Pos, 1 do
		local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
		SetBlipSprite (blip, 110)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.9)
		SetBlipColour (blip, 4)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('map_blip'))
		EndTextCommandSetBlipName(blip)
		end
		end
	end
end)

-- Display markers
Citizen.CreateThread(function()
  while true do    
    Wait(0)
    local coords = GetEntityCoords(GetPlayerPed(-1))      
    for k,v in pairs(Config.Zones) do
      for i = 1, #v.Pos, 1 do
        if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.DrawDistance) then
          DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
        end
      end      
    end
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.Size.x) then
					isInMarker  = true
					ShopItems   = v.Items
					currentZone = k
					LastZone    = k
				end
			end
		end
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_weashop:hasEnteredMarker', currentZone)
		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_weashop:hasExitedMarker', LastZone)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if CurrentAction ~= nil then
      
      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)
      
      if IsControlJustReleased(0, 38) then        
        
        if CurrentAction == 'shop_menu' then
          ESX.TriggerServerCallback('red:getPlayerLicenses', function (licenses)
            local weaponLicense = false

            for i = 1, #licenses, 1 do
              if (licenses[i].name == 'weapon') then
                weaponLicense = true
              end
            end

            if weaponLicense and Config.Zones[zoneCurrentActionData.zone].legal == 1 then
              OpenShopMenu(CurrentActionData.zone)
            else
              OpenBuyLicenseMenu()
            end
          end)
        end
        
        CurrentAction = nil         
      
      end

    end
  end
end)