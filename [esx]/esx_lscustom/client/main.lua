ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local lsMenuIsShowed = false
local isInLSMarker	 = false
local PlayerData	= {}
local myCar 		 = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx_lscustom:installMod')
AddEventHandler('esx_lscustom:installMod', function()
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	myCar = ESX.Game.GetVehicleProperties(vehicle)
	TriggerServerEvent('esx_lscustom:refreshOwnedVehicle', myCar)
end)

RegisterNetEvent('esx_lscustom:cancelInstallMod')
AddEventHandler('esx_lscustom:cancelInstallMod', function()
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	ESX.Game.SetVehicleProperties(vehicle, myCar)
end)

function OpenLSMenu(elems, menuname, menutitle, parent)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), menuname,
		{
			title = menutitle,
			align = 'left',
			elements = elems
		},
		function(data, menu) -- on validate
			local isRimMod = false
			if data.current.modType == "modFrontWheels" then
				isRimMod = true
			end
			local found = false
			for k,v in pairs(Config.Menus) do
				if k == data.current.modType or isRimMod then
					if data.current.label == _U('by_default') or string.match(data.current.label, _U('installed')) then
						ESX.ShowNotification(_U('already_own') .. data.current.label)
					else
						if isRimMod then
							TriggerServerEvent("esx_lscustom:buyMod", data.current.price)
						else
							TriggerServerEvent("esx_lscustom:buyMod", v.price)
						end
					end
					menu.close()
					found = true
					break
				end
			end
			if not found then
				GetAction(data.current)
			end
		end,
		function(data, menu) -- on cancel
			menu.close()
			TriggerEvent('esx_lscustom:cancelInstallMod')
			if parent == nil then
				lsMenuIsShowed = false
				local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
				FreezeEntityPosition(vehicle, false)
				myCar = nil
			end
		end,
		function(data, menu) -- on change
			UpdateMods(data.current)
		end
	)
end

function UpdateMods(data)
	if data.modType ~= nil then
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		local props = {}

		--Citizen.Trace('modType: ' .. data.modType)
		--Citizen.Trace('modNum: ' .. json.encode(data.modNum))

		if data.wheelType ~= nil then
			props['wheels'] = data.wheelType
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'neonColor' then
			props['neonEnabled'] = {true, true, true, true}
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'tyreSmokeColor' then
			props['modSmokeEnabled'] = true
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		end
		props[data.modType] = data.modNum
		ESX.Game.SetVehicleProperties(vehicle, props)
	end
end

function GetAction(data)
	local elements  = {}
	local menuname  = ''
	local menutitle = ''
	local parent    = nil

	local playerPed = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	local currentMods = ESX.Game.GetVehicleProperties(vehicle)

	for k,v in pairs(Config.Menus) do

		if data.value == k then

			menuname  = k
			menutitle = v.label
			parent    = v.parent

			if v.modType ~= nil then

				if v.modType == 22 then
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = false})
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then
					local num = myCar[v.modType]
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = num})
				else
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = -1})
        end

        if v.modType == 17 then
          table.insert(elements, {label = " " .. _U('no_turbo'), modType = k, modNum = false})
        end

				if v.modType == 14 then -- HORNS
					for j = 0, 51, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = GetHornName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed' .. '</span>')
						else
							_label = GetHornName(j) .. ' -  <span style="color:green;">$' .. v.price .. '</span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 'plateIndex' then -- PLATES
					for j = 0, 4, 1 do
						local _label = ''
						if j == currentMods.plateIndex then
							_label = GetPlatesName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							_label = GetPlatesName(j) .. ' - <span style="color:green;">$' .. v.price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 22 then -- XENON
					local _label = ''
					if currentMods.modXenon then
						_label = 'Xénon - <span style="color:cornflowerblue;">' .. _U('installed') .. '</span>'
					else
						_label = 'Xénon - <span style="color:green;">$' .. v.price .. ' </span>'
					end
					table.insert(elements, {label = _label, modType = k, modNum = true})
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then -- NEON & SMOKE COLOR
					local neons = GetNeons()
					for i=1, #neons, 1 do
						table.insert(elements,
							{
								label = '<span style="color:rgb(' .. neons[i].r .. ',' .. neons[i].g .. ',' .. neons[i].b .. ');">' .. neons[i].label .. ' </span>',
								modType = k,
								modNum = { neons[i].r, neons[i].g, neons[i].b }
							}
						)
					end
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then -- RESPRAYS
					local colors = GetColors(data.color)
					for j = 1, #colors, 1 do
						local _label = ''
						_label = colors[j].label .. ' - <span style="color:green;">$' .. v.price .. ' </span>'
						table.insert(elements, {label = _label, modType = k, modNum = colors[j].index})
					end
				elseif v.modType == 'windowTint' then -- WINDOWS TINT
					for j = 1, 5, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = GetWindowName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							_label = GetWindowName(j) .. ' - <span style="color:green;">$' .. v.price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 23 then -- WHEELS RIM & TYPE
					local props = {}

					props['wheels'] = v.wheelType
					ESX.Game.SetVehicleProperties(vehicle, props)

					local modCount = GetNumVehicleMods(vehicle, v.modType)
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName ~= nil then
							local _label = ''
							if j == currentMods.modFrontWheels then
								_label = GetLabelText(modName) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								_label = GetLabelText(modName) .. ' - <span style="color:green;">$' .. v.price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = 'modFrontWheels', modNum = j, wheelType = v.wheelType, price = v.price})
						end
					end
				elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- UPGRADES
					for j = 0, modCount-1, 1 do
						local _label = ''
						if j == currentMods[k] then
							_label = 'Niveau ' .. j .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							_label = 'Niveau ' .. j .. ' - <span style="color:green;">$' .. v.price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
          end
        elseif v.modType == 17 then -- TURBO
          local _label = ''
          if currentMods.modTurbo then
            _label = 'Turbo - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
          else
            _label = 'Turbo - <span style="color:green;">$' .. v.price .. ' </span>'
          end
          table.insert(elements, {label = _label, modType = k, modNum = true})
				else
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- BODYPARTS
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName ~= nil then
							local _label = ''
							if j == currentMods[k] then
								_label = GetLabelText(modName) .. ' -  <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
							end
							table.insert(elements, {label = _label, modType = k, modNum = j})
						end
					end
				end
			else
				if data.value == 'primaryRespray' or data.value == 'secondaryRespray' or data.value == 'pearlescentRespray' or data.value == 'modFrontWheelsColor' then
					for i=1, #Config.Colors, 1 do
						if data.value == 'primaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color1', color = Config.Colors[i].value})
						elseif data.value == 'secondaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color2', color = Config.Colors[i].value})
						elseif data.value == 'pearlescentRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'pearlescentColor', color = Config.Colors[i].value})
						elseif data.value == 'modFrontWheelsColor' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'wheelColor', color = Config.Colors[i].value})
						end
					end
				else
					for l,w in pairs(v) do
						if l ~= 'label' and l ~= 'parent' then
							table.insert(elements, {label = w, value = l})
						end
					end
				end
			end
			break
		end
	end

	table.sort(elements, function(a, b)
		return a.label < b.label
	end)

	OpenLSMenu(elements, menuname, menutitle, parent)
end

-- Blips
-- Citizen.CreateThread(function()
-- 	for k,v in pairs(Config.Zones)do
-- 		local blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)
-- 		SetBlipSprite(blip, 72)
-- 		SetBlipScale(blip, 0.8)
-- 		SetBlipColour(blip, 4)
-- 		SetBlipAsShortRange(blip, true)
-- 		BeginTextCommandSetBlipName("STRING")
-- 		AddTextComponentString(v.Name)
-- 		EndTextCommandSetBlipName(blip)
-- 	end
-- end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		Wait(0)

		if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
			local playerPed = GetPlayerPed(-1)
			if IsPedInAnyVehicle(playerPed, false) then
				local coords      = GetEntityCoords(GetPlayerPed(-1))
				local currentZone = nil
				local zone 		  = nil
				local lastZone    = nil

				for k,v in pairs(Config.Zones) do
					if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
						isInLSMarker  = true

						SetTextComponentFormat("STRING")
						AddTextComponentString(v.Hint)
						DisplayHelpTextFromStringLabel(0, 0, 1, -1)

						break
					else
						isInLSMarker  = false
					end
				end

				if IsControlJustReleased(0, 38) and not lsMenuIsShowed and isInLSMarker then
					lsMenuIsShowed = true

					local vehicle = GetVehiclePedIsIn(playerPed, false)

					--SetVehicleUndriveable(vehicle, true)
					FreezeEntityPosition(vehicle, true)

					myCar = ESX.Game.GetVehicleProperties(vehicle)

					ESX.UI.Menu.CloseAll()
					GetAction({value = 'main'})
				end

				if isInLSMarker and not hasAlreadyEnteredMarker then
					hasAlreadyEnteredMarker = true
				end

				if not isInLSMarker and hasAlreadyEnteredMarker then
					hasAlreadyEnteredMarker = false
					--lsMenuIsShowed = false
					--ESX.UI.Menu.CloseAll()
				end

			end
		end
	end
end)

--char GET_MOD_SLOT_NAME(Vehicle vehicle, int modType)

--int GET_NUM_VEHICLE_MODS(Vehicle vehicle, int modType)

--char *GET_MOD_TEXT_LABEL(Vehicle vehicle, int modType, int modValue)

 --_GET_LABEL_TEXT to get the part name in the games language

--local Veh = GetVehiclePedIsIn(GetPlayerPed(-1), true)
--local VehType = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(Veh)))
