local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}



RegisterNetEvent("Wave")
AddEventHandler("Wave", function()
  local lPed = GetPlayerPed(-1)
  if DoesEntityExist(lPed) then
    Citizen.CreateThread(function()
      RequestAnimDict("friends@frj@ig_1")
      while not HasAnimDictLoaded("friends@frj@ig_1") do
        Citizen.Wait(100)
      end

      if IsEntityPlayingAnim(lPed, "friends@frj@ig_1", "wave_a", 3) then
        ClearPedSecondaryTask(lPed)
        SetEnableWave(lPed, false)
      else
        TaskPlayAnim(lPed, "friends@frj@ig_1", "wave_a", 8.0, -8, -1, 16, 0, 0, 0, 0)
        SetEnableWave(lPed, true)
      end
    end)
  end
end)

RegisterNetEvent("No")
AddEventHandler("No", function()
  local lPed = GetPlayerPed(-1)
  if DoesEntityExist(lPed) then
    Citizen.CreateThread(function()
      RequestAnimDict("gestures@m@standing@casual")
      while not HasAnimDictLoaded("gestures@m@standing@casual") do
        Citizen.Wait(100)
      end

      if IsEntityPlayingAnim(lPed, "gestures@m@standing@casual", "gesture_head_no", 3) then
        ClearPedSecondaryTask(lPed)
        SetEnableNo(lPed, false)
      else
        TaskPlayAnim(lPed, "gestures@m@standing@casual", "gesture_head_no", 8.0, -8, -1, 16, 0, 0, 0, 0)
        SetEnableNo(lPed, true)
      end
    end)
  end
end)

RegisterNetEvent("Yes")
AddEventHandler("Yes", function()
  local lPed = GetPlayerPed(-1)
  if DoesEntityExist(lPed) then
    Citizen.CreateThread(function()
      RequestAnimDict("gestures@m@standing@casual")
      while not HasAnimDictLoaded("gestures@m@standing@casual") do
        Citizen.Wait(100)
      end

      if IsEntityPlayingAnim(lPed, "gestures@m@standing@casual", "gesture_pleased", 3) then
        ClearPedSecondaryTask(lPed)
        SetEnableYes(lPed, false)
      else
        TaskPlayAnim(lPed, "gestures@m@standing@casual", "gesture_pleased", 8.0, -8, -1, 16, 0, 0, 0, 0)
        SetEnableYes(lPed, true)
      end
    end)
  end
end)

RegisterNetEvent("Point")
AddEventHandler("Point", function()
  local lPed = GetPlayerPed(-1)
  if DoesEntityExist(lPed) then
    Citizen.CreateThread(function()
      RequestAnimDict("gestures@m@standing@casual")
      while not HasAnimDictLoaded("gestures@m@standing@casual") do
        Citizen.Wait(100)
      end

      if IsEntityPlayingAnim(lPed, "gestures@m@standing@casual", "gesture_point", 3) then
        ClearPedSecondaryTask(lPed)
        SetEnablePoint(lPed, false)
      else
        TaskPlayAnim(lPed, "gestures@m@standing@casual", "gesture_point", 8.0, -8, -1, 16, 0, 0, 0, 0)
        SetEnablePoint(lPed, true)
      end
    end)
  end
end)

RegisterNetEvent("Wtf")
AddEventHandler("Wtf", function()
  local lPed = GetPlayerPed(-1)
  if DoesEntityExist(lPed) then
    Citizen.CreateThread(function()
      RequestAnimDict("gestures@m@standing@casual")
      while not HasAnimDictLoaded("gestures@m@standing@casual") do
        Citizen.Wait(100)
      end

      if IsEntityPlayingAnim(lPed, "gestures@m@standing@casual", "gesture_shrug_hard", 3) then
        ClearPedSecondaryTask(lPed)
        SetEnableWtf(lPed, false)
      else
        TaskPlayAnim(lPed, "gestures@m@standing@casual", "gesture_shrug_hard", 8.0, -8, -1, 16, 0, 0, 0, 0)
        SetEnableWtf(lPed, true)
      end
    end)
  end
end)

RegisterNetEvent("Damn")
AddEventHandler("Damn", function()
  local lPed = GetPlayerPed(-1)
  if DoesEntityExist(lPed) then
    Citizen.CreateThread(function()
      RequestAnimDict("gestures@m@standing@casual")
      while not HasAnimDictLoaded("gestures@m@standing@casual") do
        Citizen.Wait(100)
      end

      if IsEntityPlayingAnim(lPed, "gestures@m@standing@casual", "gesture_damn", 3) then
        ClearPedSecondaryTask(lPed)
        SetEnableDamn(lPed, false)
      else
        TaskPlayAnim(lPed, "gestures@m@standing@casual", "gesture_damn", 8.0, -8, -1, 16, 0, 0, 0, 0)
        SetEnableDamn(lPed, true)
      end
    end)
  end
end)

RegisterNetEvent("Ez")
AddEventHandler("Ez", function()
  local lPed = GetPlayerPed(-1)
  if DoesEntityExist(lPed) then
    Citizen.CreateThread(function()
      RequestAnimDict("gestures@m@standing@casual")
      while not HasAnimDictLoaded("gestures@m@standing@casual") do
        Citizen.Wait(100)
      end

      if IsEntityPlayingAnim(lPed, "gestures@m@standing@casual", "gesture_easy_now", 3) then
        ClearPedSecondaryTask(lPed)
        SetEnableEz(lPed, false)
      else
        TaskPlayAnim(lPed, "gestures@m@standing@casual", "gesture_easy_now", 8.0, -8, -1, 16, 0, 0, 0, 0)
        SetEnableEz(lPed, true)
      end
    end)
  end
end)

RegisterNetEvent("T")
AddEventHandler("T", function()
  local lPed = GetPlayerPed(-1)
  if DoesEntityExist(lPed) then
    Citizen.CreateThread(function()
      RequestAnimDict("nm@hands")
      while not HasAnimDictLoaded("nm@hands") do
        Citizen.Wait(100)
      end

      if IsEntityPlayingAnim(lPed, "nm@hands", "flail", 3) then
        ClearPedSecondaryTask(lPed)
        SetEnableT(lPed, false)
      else
        TaskPlayAnim(lPed, "nm@hands", "flail", 8.0, -8, -1, 49, 0, 0, 0, 0)
        SetEnableT(lPed, true)
      end
    end)
  end
end)

RegisterNetEvent("Fear")
AddEventHandler("Fear", function()
  local lPed = GetPlayerPed(-1)
  if DoesEntityExist(lPed) then
    Citizen.CreateThread(function()
      RequestAnimDict("amb@code_human_cower_stand@male@idle_a")
      while not HasAnimDictLoaded("amb@code_human_cower_stand@male@idle_a") do
        Citizen.Wait(100)
      end

      if IsEntityPlayingAnim(lPed, "amb@code_human_cower_stand@male@idle_a", "idle_b", 3) then
        ClearPedSecondaryTask(lPed)
        SetEnableFear(lPed, false)
      else
        TaskPlayAnim(lPed, "amb@code_human_cower_stand@male@idle_a", "idle_b", 8.0, -8, -1, 16, 0, 0, 0, 0)
        SetEnableFear(lPed, true)
      end
    end)
  end
end)

RegisterNetEvent("Depressed")
AddEventHandler("Depressed", function()
  local lPed = GetPlayerPed(-1)
  if DoesEntityExist(lPed) then
    Citizen.CreateThread(function()
      RequestAnimDict("amb@world_human_bum_standing@depressed@idle_a")
      while not HasAnimDictLoaded("amb@world_human_bum_standing@depressed@idle_a") do
        Citizen.Wait(100)
      end

      if IsEntityPlayingAnim(lPed, "amb@world_human_bum_standing@depressed@idle_a", "idle_a", 3) then
        ClearPedSecondaryTask(lPed)
        SetEnableDepressed(lPed, false)
      else
        TaskPlayAnim(lPed, "amb@world_human_bum_standing@depressed@idle_a", "idle_a", 8.0, -8, -1, 16, 0, 0, 0, 0)
        SetEnableDepressed(lPed, true)
      end
    end)
  end
end)

Citizen.CreateThread(function()
  while true do
    Wait(0)

    if IsControlPressed(0, Keys["B"]) then
      TriggerEvent('Point')
    end
  end
end)
