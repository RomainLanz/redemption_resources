ESX = nil
maxErrors = 6 -- Change the amount of Errors allowed for the player to pass the driver test, any number above this will result in a failed test


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local options = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    scale = 0.4,
    font = 0,
    menu_title = "Auto-école",
    menu_subtitle = "Categories",
    color_r = 0,
    color_g = 128,
    color_b = 255,
}

local dmvped = {
  {type=4, hash=0x9AD32FE9, x=-828.746948242188, y=-696.640625, z=27.0565605163574, a=89.5493240356445},
}

local dmvpedpos = {
	{ ['x'] =-828.746948242188, ['y'] =-696.640625, ['z'] =28.0565605163574 },
}

--[[Locals]]--

local dmvschool_location = {-827.746948242188, -699.640625, 28.0565605163574}

local kmh = 3.6
local VehSpeed = 0

local speed_limit_resi = 50.0
local speed_limit_town = 80.0
local speed_limit_freeway = 120
local speed = kmh

local DTutOpen = false
local monitorPed

--[[Events]]--

--[[AddEventHandler("playerSpawned", function()
	ESX.TriggerServerCallback('dmv:LicenseStatus', function(data)
    if (data == "Required") then
            TriggerEvent('dmv:CheckLicStatus')
        end
end)
end)
]]--


AddEventHandler("playerSpawned", function()
	Wait(1000)
	TriggerServerEvent('dmv:getlicence')
end)



RegisterNetEvent('dmv:getlicense_client')
AddEventHandler('dmv:getlicense_client', function(data)
--Check if player has completed theory test
	--DrawMissionText2(data, 5000)	
	if (data == "Required") then
            TriggerEvent('dmv:CheckLicStatus')
    end
end)




TestDone = 0

RegisterNetEvent('dmv:CheckLicStatus')
AddEventHandler('dmv:CheckLicStatus', function()
--Check if player has completed theory test
	TestDone = 1
end)




--[[Functions]]--

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function DrawMissionText2(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function LocalPed()
	return GetPlayerPed(-1)
end

function GetCar() 
	return GetVehiclePedIsIn(GetPlayerPed(-1),false) 
end

function Chat(debugg)
    TriggerEvent("chatMessage", '', { 0, 0x99, 255 }, tostring(debugg))
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

--[[Arrays]]--

onTestEvent = 0
onTtest = 0
testblock = 0
DamageControl = 0
SpeedControl = 0
CruiseControl = 0
Error = 0

function startttest()

        if TestDone == 0 or testblock == 1 then
        	
			DrawMissionText2("~r~Repassez plus tard", 5000)			
		else
			TriggerServerEvent('dmv:ttcharge')
			openGui()
			Menu.hidden = not Menu.hidden
		end
end

function startptest()
        if  TestDone == 1 then
			DrawMissionText2("~r~Repassez plus tard", 5000)
		else
		    TriggerServerEvent('dmv:dtcharge')
			onTestBlipp = AddBlipForCoord(-845.306335449219,-750.004150390625, 22.9157829284668)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		    onTestEvent = 1
			DamageControl = 1
			SpeedControl = 1
			onTtest = 3
			DTut()
		end
end

function EndDTest()
        if Error >= maxErrors then
			drawNotification("\nVoici vos mauvais points ".. Error..".")
			EndTestTasks()
		else
			TriggerServerEvent('dmv:successconduite')
			drawNotification("Bravo, Vous avez obtenu votre permis\nMauvais points ".. Error..".")	
			EndTestTasks()
		end
end

function EndTestTasks()
		onTestBlipp = nil
		onTestEvent = 0
		DamageControl = 0
		Error = 0
		TaskLeaveVehicle(GetPlayerPed(-1), veh, 0)
		Wait(1000)
		CarTargetForLock = GetPlayersLastVehicle(GetPlayerPed(-1))
		lockStatus = GetVehicleDoorLockStatus(CarTargetForLock)
		SetVehicleDoorsLocked(CarTargetForLock, 2)
		SetVehicleDoorsLockedForPlayer(CarTargetForLock, PlayerId(), false)
		SetEntityAsMissionEntity(CarTargetForLock, true, true)
		Wait(2000)
		Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( CarTargetForLock ) )
		SetPedAsNoLongerNeeded(monitorPed)
		

end


function SpawnTestCar()
	Citizen.Wait(0)
	local myPed = GetPlayerPed(-1)
	local player = PlayerId()
	local vehicle = GetHashKey('blista')

    RequestModel(vehicle)

while not HasModelLoaded(vehicle) do
	Wait(1)
end
colors = table.pack(GetVehicleColours(veh))
extra_colors = table.pack(GetVehicleExtraColours(veh))
plate = math.random(100, 900)
local spawned_car = CreateVehicle(vehicle, -812.180969238281,-748.602844238281,22.1563491821289, true, false)
SetVehicleColours(spawned_car,4,5)
SetVehicleExtraColours(spawned_car,extra_colors[1],extra_colors[2])
--SetEntityHeading(spawned_car, 317.64)
SetEntityHeading(spawned_car, 85.069953918457)
SetVehicleOnGroundProperly(spawned_car)
SetPedIntoVehicle(myPed, spawned_car, - 1)
SetModelAsNoLongerNeeded(vehicle)
Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
CruiseControl = 0
DTutOpen = false
SetEntityVisible(myPed, true)
--SetVehicleDoorsLocked(GetCar(), 4)
SetVehicleDoorsLocked(GetCar(), 1)
FreezeEntityPosition(myPed, false)
SetVehicleNumberPlateText(GetCar(), "Permis"..math.random(0,1000).." ")

RequestModel(GetHashKey("A_M_Y_BusiCas_01"))
	while not HasModelLoaded(GetHashKey("A_M_Y_BusiCas_01")) do
		Wait(1)
	end

	monitorPed = CreatePed(4, 0x9AD32FE9,-811.237243652344, -746.732299804688,  22.4649505615234, 183.998657226563, true, true)
	SetPedMaxHealth(monitorPed, 100)
	SetPedRelationshipGroupHash(monitorPed, GetHashKey("CIVFEMALE")) -- GANG_1 ?
	--TaskStartScenarioInPlace(monitorPed, "WORLD_HUMAN_GUARD_STAND_PATROL", 0, true)
	--SetPedCanRagdoll(monitorPed, false)
	--SetPedDiesWhenInjured(monitorPed, false)
	TaskEnterVehicle(monitorPed, spawned_car, -1, 0, 2.0001, 1)
end

function DTut()
	Citizen.Wait(0)
	local myPed = GetPlayerPed(-1)
	DTutOpen = true
		SetEntityCoords(myPed,238.70791625977, -1394.7208251953, -1394.7208251953,true, false, false,true)
	    SetEntityHeading(myPed, 314.39)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>Instructeur:</b> <br /><br /> Nous préparons actuellement votre véhicule pour le test, pendant ce temps, vous devriez lire ces quelques points importants.<br /><br /><b style='color:#87CEFA'>Limitation de vitesse:</b><br />- Faites attention au trafic et restez sous <b style='color:#A52A2A'>la vitesse</b> maximale<br /><br />- À l'heure actuelle, vous devriez connaître les bases, mais nous essaierons de vous rappeler chaque fois que vous <b style='color:#DAA520'>entrez/sortez</b> d'une zone avec une limite de vitesse affichée",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })
		Citizen.Wait(16500)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>Instructeur:</b> <br /><br /> Utilisez le <b style='color:#DAA520'>Régulateur de vitesse</b> pour éviter <b style='color:#87CEFA'>les excès de vitesse</b>, Activez-le pendant le test en appuyant sur le bouton <b style='color:#20B2AA'>X</b> Bouton sur votre clavier A sur votre manette.<br /><br /><b style='color:#87CEFA'>Evaluation:</b><br />- Essayez de ne pas abîmer le véhicule ou de dépasser les limitations de vitesse. Vous allez recevoir des <b style='color:#A52A2A'>Mauvais Points</b> Chaque fois que vous ne respectez pas ces règles<br /><br />- Trop <b style='color:#A52A2A'>de Mauvais Points</b> entraînera un <b style='color:#A52A2A'>Echec</b>",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })
		Citizen.Wait(16500)
		SpawnTestCar()
		DTutOpen = false
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local veh = GetVehiclePedIsUsing(GetPlayerPed(-1))
		local ped = GetPlayerPed(-1)
		if HasEntityCollidedWithAnything(veh) and DamageControl == 1 then
		TriggerEvent("pNotify:SendNotification",{
            text = "Le véhicule est <b style='color:#B22222'>Endommagé!</b><br /><br />...!",
            type = "alert",
            timeout = (2000),
            layout = "bottomCenter",
            queue = "global"
        })			
			Citizen.Wait(1000)
			Error = Error + 1	
		elseif(IsControlJustReleased(1, 23)) and DamageControl == 1 then
			drawNotification("Vous ne pouvez pas quitter le véhicule pendant le test")
    	end
		
	if onTestEvent == 1 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -847.753601074219,-750.023193359375, 21.8757934570313, true) > 4.0001 then
		   DrawMarker(1,-847.753601074219,-750.023193359375, 21.8757934570313,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-856.54638671875,-679.34375,26.6601066589355)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			DrawMissionText2("Faîte un rapide ~r~stop~s~ et regardez sur votre ~y~Gauche~s~ avant de rentrer dans le traffic", 5000)
			PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
			FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), true) -- Freeze Entity
			Citizen.Wait(6000)
			FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), false) -- Freeze Entity
			DrawMissionText2("~g~Parfait!~s~ maintenant à ~y~DROITE~s~ et prenez votre couloir", 5000)
			drawNotification("Zone: ~y~ville\n~s~limite de vitesse: ~y~70 km/h\n~s~Erreur: ~y~".. Error.."/6")
			SpeedControl = 2
			onTestEvent = 2
		end
	end
	
	if onTestEvent == 2 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-856.54638671875,-679.34375,26.6601066589355, true) > 4.0001 then
		   DrawMarker(1,-856.54638671875,-679.34375,26.6601066589355,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-762.498229980469,-665.869384765625, 27.9939460754395)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		    DrawMissionText2("Si vous tournez à ~y~Droite~s~, ne tenez pas compte du feu, cela compte comme ~r~ceder le passage~s~", 5000)
			PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
			FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), true) -- Freeze Entity
			Citizen.Wait(2000)
			FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), false) -- Freeze Entity
			onTestEvent = 3		
		end
	end
	
	if onTestEvent == 3 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-762.498229980469,-665.869384765625, 28.9939460754395, true) > 4.0001 then
		   DrawMarker(1,-762.498229980469,-665.869384765625, 28.9939460754395,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-657.403442382813, -663.372009277344,  30.5197086334229)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		    DrawMissionText2("Respectez les feux de signalisation !", 5000)
			onTestEvent = 4
		end
	end	
	
	if onTestEvent == 4 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-657.403442382813, -663.372009277344,  30.5197086334229, true) > 4.0001 then
		   DrawMarker(1,-657.403442382813, -663.372009277344,  30.5197086334229,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-623.419555664063, -567.777893066406,  33.7929573059082)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			DrawMissionText2("Pensez a vos ~y~Clignotant~s~ ", 5000)
			onTestEvent = 5
		end
	end	
	
	if onTestEvent == 5 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-623.419555664063, -567.777893066406,  33.7929573059082, true) > 4.0001 then
		   DrawMarker(1,-623.419555664063, -567.777893066406,  33.7929573059082,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-740.115173339844, -1703.5439453125,  28.0816287994385)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		    DrawMissionText2("Allons sur la Freeway! La zone est limitée a ~r~120 kmh~s~, mais restez prudent", 5000)
			drawNotification("Zone: ~y~Freeway\n~s~limite de vitesse: ~y~120 km/h\n~s~Erreur: ~y~".. Error.."/6")
			SpeedControl = 3
			onTestEvent = 6
		end
	end	

	if onTestEvent == 6 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-740.115173339844, -1703.5439453125,  28.0816287994385, true) > 4.0001 then
		   DrawMarker(1,-740.115173339844, -1703.5439453125,  28.0816287994385,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-725.74267578125, -1618.35229492188,  23.125280380249)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			DrawMissionText2("Toujours en vie ? sortons de la Freeway, la limite redeviens de ~r~70 kmh~s~", 5000)
			drawNotification("Zone: ~y~Freeway\n~s~limite de vitesse: ~y~70 km/h\n~s~Erreur: ~y~".. Error.."/6")
			SpeedControl = 2
			onTestEvent = 7
		end
	end		
		
	
	if onTestEvent == 7 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-725.74267578125, -1618.35229492188,  23.125280380249, true) > 4.0001 then
		   DrawMarker(1,-725.74267578125, -1618.35229492188,  23.125280380249,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-633.262268066406, -1317.45849609375,  9.477876663208)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		    DrawMissionText2("Encore une fois, on respecte les feux !", 5000)
			onTestEvent = 8
		end
	end		
		
	
	if onTestEvent == 8 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-633.262268066406, -1317.45849609375,  9.477876663208, true) > 4.0001 then
		   DrawMarker(1,-633.262268066406, -1317.45849609375,  9.477876663208,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-761.5107421875, -1131.142578125,  9.5143232345581)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			onTestEvent = 9
		end
	end

	if onTestEvent == 9 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-761.5107421875, -1131.142578125,  9.5143232345581, true) > 4.0001 then
		   DrawMarker(1,-761.5107421875, -1131.142578125,  9.5143232345581,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-937.99462890625, -1202.6533203125,  3.93371725082397)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			onTestEvent = 10
		end
	end

	if onTestEvent == 10 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-937.99462890625, -1202.6533203125,  3.93371725082397, true) > 4.0001 then
		   DrawMarker(1,-937.99462890625, -1202.6533203125,  3.93371725082397,0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-998.661865234375, -1126.78796386719,  0.98231542110443)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			DrawMissionText2("vous entrez dans une zone residentielle, la vitesse est limitée a  ~r~50 kmh~s~!", 5000)
			drawNotification("Zone: ~y~residentielle\n~s~limite de vitesse: ~y~50 km/h\n~s~Erreur: ~y~".. Error.."/6")
			SpeedControl = 1
			onTestEvent = 11
		end
	end

	if onTestEvent == 11 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-998.661865234375, -1126.78796386719,  0.98231542110443, true) > 4.0001 then
		   DrawMarker(1,-998.661865234375, -1126.78796386719,  0.98231542110443,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-1050.96118164063, -1035.25903320313,  0.93113338947296)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			DrawMissionText2("Marquez l'arret sur un ~r~Stop~s~", 5000)
			PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
			FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), true) -- Freeze Entity
			Citizen.Wait(3000)
			FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), false) -- Freeze Entity
			onTestEvent = 12
		end
	end

	if onTestEvent == 12 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-1050.96118164063, -1035.25903320313,  0.93113338947296, true) > 4.0001 then
		   DrawMarker(1,-1050.96118164063, -1035.25903320313,  0.93113338947296,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-1110.10119628906, -936.233520507813,  1.42584228515625)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		 	DrawMissionText2("Marquez un second arrêt au ~r~Stop~s~", 5000)
			PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
			FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), true) -- Freeze Entity
			Citizen.Wait(3000)
			FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), false) -- Freeze Entity
			onTestEvent = 13
		end
	end

	if onTestEvent == 13 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-1110.10119628906, -936.233520507813,  1.42584228515625, true) > 4.0001 then
		   DrawMarker(1,-1110.10119628906, -936.233520507813,  1.42584228515625,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-1158.01416015625, -859.518493652344,  12.9024276733398)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			DrawMissionText2("Attention, il y a un ~r~feu de signalisation~s~", 5000)
			PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
			FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), true) -- Freeze Entity
			Citizen.Wait(1000)
			FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), false) -- Freeze Entity
			onTestEvent = 14
		end
	end
	
	if onTestEvent == 14 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-1158.01416015625, -859.518493652344,  12.9024276733398, true) > 4.0001 then
		   DrawMarker(1,-1158.01416015625, -859.518493652344,  12.9024276733398,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-1088.89758300781, -783.330444335938,  18.0743675231934)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			drawNotification("Zone: ~y~ville\n~s~limite de vitesse: ~y~70 km/h\n~s~Erreur: ~y~".. Error.."/6")
			SpeedControl = 2
			onTestEvent = 15
		end
	end	
	
	if onTestEvent == 15 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-1088.89758300781, -783.330444335938,  18.0743675231934, true) > 4.0001 then
		   DrawMarker(1,-1088.89758300781, -783.330444335938,  18.0743675231934,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-834.398132324219, -1004.77203369141,  12.326639175415)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			DrawMissionText2("~r~Ceder le passage~s~ puis tournez a droite", 5000)
			onTestEvent = 16
		end
	end	
	
	if onTestEvent == 16 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-834.398132324219, -1004.77203369141,  12.326639175415, true) > 4.0001 then
		   DrawMarker(1,-834.398132324219, -1004.77203369141,  12.326639175415,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-742.745422363281, -856.58349609375,  21.3169403076172)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			DrawMissionText2("Nous somme bientôt à la fin de l'épreuve", 5000)
			onTestEvent = 17
		end
	end		
	

	if onTestEvent == 17 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-742.840270996094, -856.149597167969,  21.3244380950928, true) > 4.0001 then
		   DrawMarker(1,-742.840270996094, -856.149597167969,  21.3244380950928,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-815.881408691406, -742.369506835938,  22.5532207489014)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			DrawMissionText2("Bien, l'épreuve presque est finie, quel sera le verdict?", 5000)
			onTestEvent = 18
		end
	end

	if onTestEvent == 18 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-815.881408691406, -742.369506835938,  22.5532207489014, true) > 4.0001 then
		   DrawMarker(1,-815.881408691406, -742.369506835938,  22.5532207489014,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			forgive = 0
			EndDTest()
		end
	end
	
end
end)

----Theory Test NUI Operator

-- ***************** Open Gui and Focus NUI
function openGui()
  onTtest = 1
  SetNuiFocus(true)
  SendNUIMessage({openQuestion = true})
end

-- ***************** Close Gui and disable NUI
function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({openQuestion = false})
end

-- ***************** Disable controls while GUI open
Citizen.CreateThread(function()
  while true do
    if onTtest == 1 then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
      if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
        SendNUIMessage({type = "click"})
      end
    end
    Citizen.Wait(0)
  end
end)

-- ***************** NUI Callback Methods
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) and TestDone == 1 and onTtest == 0 then
		DrawMissionText2("~r~Vous conduisez sans permis", 2000)			
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
		CarSpeed = GetEntitySpeed(GetCar()) * speed
        if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) and SpeedControl == 1 and CarSpeed >= speed_limit_resi then
		TriggerEvent("pNotify:SendNotification",{
            text = "Vous allez trop vite ! <b style='color:#B22222'>Ralentissez!</b><br /><br />vous etes dans une zone à <b style='color:#DAA520'>50 km/h</b>",
            type = "alert",
            timeout = (2000),
            layout = "bottomCenter",
            queue = "global"
        })
			Error = Error + 1	
			Citizen.Wait(10000)
		elseif(IsPedInAnyVehicle(GetPlayerPed(-1), false)) and SpeedControl == 2 and CarSpeed >= speed_limit_town then
		TriggerEvent("pNotify:SendNotification",{
            text = "Vous allez trop vite ! <b style='color:#B22222'>Ralentissez!</b><br /><br />vous etes dans une zone à <b style='color:#DAA520'>70 km/h</b>",
            type = "alert",
            timeout = (2000),
            layout = "bottomCenter",
            queue = "global"
        })
			Error = Error + 1
			Citizen.Wait(10000)
		elseif(IsPedInAnyVehicle(GetPlayerPed(-1), false)) and SpeedControl == 3 and CarSpeed >= speed_limit_freeway then
		TriggerEvent("pNotify:SendNotification",{
            text = "Vous allez trop vite ! <b style='color:#B22222'>Ralentissez!</b><br /><br />vous etes dans une zone à <b style='color:#DAA520'>120 km/h</b>",
            type = "alert",
            timeout = (2000),
            layout = "bottomCenter",
            queue = "global"
        })
			Error = Error + 1
			Citizen.Wait(10000)
		end
	end
end)


local speedLimit = 0
Citizen.CreateThread( function()
    while true do 
        Citizen.Wait( 0 )   
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local vehicleModel = GetEntityModel(vehicle)
        local speed = GetEntitySpeed(vehicle)
        local inVehicle = IsPedSittingInAnyVehicle(ped)
        local float Max = GetVehicleMaxSpeed(vehicleModel)
        if ( ped and inVehicle and DamageControl == 1 ) then
            if IsControlJustPressed(1, 73) then
                if (GetPedInVehicleSeat(vehicle, -1) == ped) then
                    if CruiseControl == 0 then
                        speedLimit = speed
                        SetEntityMaxSpeed(vehicle, speedLimit)
						drawNotification("~y~Régulateur de vitesse: ~g~Activé\n~s~Vitesse maximale ".. math.floor(speedLimit*3.6).."kmh")
						Citizen.Wait(1000)
				        DisplayHelpText("Ajustez votre vitesse maximale avec ~INPUT_CELLPHONE_UP~ ~INPUT_CELLPHONE_DOWN~")
						PlaySound(-1, "COLLECTED", "HUD_AWARDS", 0, 0, 1)
                        CruiseControl = 1
                    else
                        SetEntityMaxSpeed(vehicle, Max)
						drawNotification("~y~Régulateur de vitesse: ~r~Desactivé")						
                        CruiseControl = 0
                    end
                else
				    drawNotification("Vous devez conduire pour effectuer cette action")						
                end
            elseif IsControlJustPressed(1, 27) then
                if CruiseControl == 1 then
                    speedLimit = speedLimit + 0.45
                    SetEntityMaxSpeed(vehicle, speedLimit)
					PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					DisplayHelpText("Vitesse maximum ajustée à ".. math.floor(speedLimit*3.6).. "kmh")
                end
            elseif IsControlJustPressed(1, 173) then
                if CruiseControl == 1 then
                    speedLimit = speedLimit - 0.45
                    SetEntityMaxSpeed(vehicle, speedLimit)
					PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)	
					DisplayHelpText("Vitesse maximum ajustée à ".. math.floor(speedLimit*3.6).. "kmh")
                end
            end
        end
    end
end)

----Theory Test NUI Operator

-- ***************** Open Gui and Focus NUI
function openGui()
  onTtest = 1
  SetNuiFocus(true)
  SendNUIMessage({openQuestion = true})
end

-- ***************** Close Gui and disable NUI
function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({openQuestion = false})
end

-- ***************** Disable controls while GUI open
Citizen.CreateThread(function()
  while true do
    if onTtest == 1 then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
      if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
        SendNUIMessage({type = "click"})
      end
    end
    Citizen.Wait(0)
  end
end)

Citizen.CreateThread(function()
  while true do
    if DTutOpen then
      local ply = GetPlayerPed(-1)
      local active = true
	  SetEntityVisible(ply, false)
	  FreezeEntityPosition(ply, true)
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
    end
    Citizen.Wait(0)
  end
end)


-- ***************** NUI Callback Methods
-- Callbacks pages opening
RegisterNUICallback('question', function(data, cb)
  SendNUIMessage({openSection = "question"})
  cb('ok')
end)

-- Callback actions triggering server events
RegisterNUICallback('close', function(data, cb)
  -- if question success
  closeGui()
  cb('ok')
  TriggerServerEvent('dmv:success')
  DrawMissionText2("~b~Félicitations ! Vous avez votre code ! Vous pouvez maintenant passer au test de conduite", 2000)	
  TestDone = 0
  onTtest = 3
end)

RegisterNUICallback('kick', function(data, cb)
    closeGui()
    cb('ok')
    DrawMissionText2("~r~Vous avez raté votre code ! Vous pourrez réessayer une autre fois !", 2000)	
    onTtest = 0
	testblock = 1
end)

---------------------------------- DMV PED ----------------------------------

Citizen.CreateThread(function()

  RequestModel(GetHashKey("A_M_Y_BusiCas_01"))
  while not HasModelLoaded(GetHashKey("A_M_Y_BusiCas_01")) do
    Wait(1)
  end

  RequestAnimDict("missexile3@trevor_idle@base")
  while not HasAnimDictLoaded("missexile3@trevor_idle@base") do
    Wait(1)
  end

 	    -- Spawn the DMV Ped
  for _, item in pairs(dmvped) do
    dmvmainped =  CreatePed(item.type, item.hash, item.x, item.y, item.z, item.a, false, true)
    SetEntityHeading(dmvmainped, 120.069953918457)
    FreezeEntityPosition(dmvmainped, true)
	SetEntityInvincible(dmvmainped, true)
	SetBlockingOfNonTemporaryEvents(dmvmainped, true)
    TaskPlayAnim(dmvmainped,"missexile3@trevor_idle@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end)

local talktodmvped = true
--DMV Ped interaction
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		for k,v in ipairs(dmvpedpos) do
			if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 1.0)then
				DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour discuter avec votre  ~y~Instructeur")
				if(IsControlJustReleased(1, 38))then
						if talktodmvped then
						    Notify("~b~Bienvenue à ~h~l'Auto-école!")
						    Citizen.Wait(500)
							DMVMenu()
							Menu.hidden = false
							talktodmvped = false
						else
							talktodmvped = true
						end
				end
				Menu.renderGUI(options)
			end
		end
	end
end)

------------
------------ DRAW MENUS
------------
function DMVMenu()
	ClearMenu()
    options.menu_title = "Auto-école"
	Menu.addButton("Obtenir un permis de conduire","VehLicenseMenu",nil)
    Menu.addButton("Fermer","CloseMenu",nil) 
end

function VehLicenseMenu()
    ClearMenu()
    options.menu_title = "Examens"
	Menu.addButton("Code de la route      200€","startttest",nil)
	Menu.addButton("Examen de conduite    500€","startptest",nil)
    Menu.addButton("Fermer","DMVMenu",nil) 
end

function CloseMenu()
		Menu.hidden = true
end

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(true, true)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

----------------
----------------blip
----------------



Citizen.CreateThread(function()
	pos = dmvschool_location
	local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
	SetBlipSprite(blip,408)
	SetBlipColour(blip,11)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Auto-école')
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
end)