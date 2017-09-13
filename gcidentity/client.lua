--====================================================================================
-- #Author: Jonathan D @ Gannon
-- 
-- Developed for the n3mtv community
--====================================================================================
-- GCIdentity edited and fixed by Ark. None of this would be possible without the work
-- of the original authors, so I do not want to take the credit that they deserve away
-- from them. 
--====================================================================================
local KeyToucheClose = 177 -- PhoneCancel
-- menuIsOpen variable | 0 = closed | 1 = (Not In Use) | 2 = register
local menuIsOpen = 0 
local myIdentity = {}
 
--====================================================================================
--  TEMPORARY thread interaction
--====================================================================================
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if menuIsOpen ~= 0 then
      if IsControlJustPressed(1, KeyToucheClose) and menuIsOpen == 1 then
        closeGui()
      elseif menuIsOpen == 2 then
        local ply = GetPlayerPed(-1)
        DisableControlAction(0, 1, true)
        DisableControlAction(0, 2, true)
        DisableControlAction(0, 24, true)
        DisablePlayerFiring(ply, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 106, true)
        DisableControlAction(0,KeyToucheClose,true)
        if IsDisabledControlJustReleased(0, 142) then
          SendNUIMessage({method = "clickGui"})
        end
      end
    end
  end
end)
 
--====================================================================================
--  Server Event Management
--====================================================================================

RegisterNetEvent("gcIdentity:showRegisterIdentity")
AddEventHandler("gcIdentity:showRegisterIdentity", function()
  openGuiRegisterIdentity()
end)
 
RegisterNetEvent("gcIdentity:setIdentity")
AddEventHandler("gcIdentity:setIdentity", function(identity)
  myIdentity = data
end)
 
RegisterNUICallback('register', function(data, cb)
    closeGui()
    TriggerServerEvent('gcIdentity:setIdentity', data)
    myIdentity = data
    cb()
	Wait (500)
	TriggerEvent('esx_skin:openSaveableMenu')
end)
 
--====================================================================================
--  UI Management
--====================================================================================
function openGuiIdentity(data)
  --SetNuiFocus(true)
  SendNUIMessage({method = 'openGuiIdentity',  data = data})
  Citizen.Trace('Data : ' .. json.encode(data))
  menuIsOpen = 1
end
 
function openGuiRegisterIdentity()
  SetNuiFocus(true)
  SendNUIMessage({method = 'openGuiRegisterIdentity'})
  menuIsOpen = 2
end
 
function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({method = 'closeGui'})
  menuIsOpen = 0
end
