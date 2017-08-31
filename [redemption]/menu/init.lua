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

ESX = nil
local GUI = {}
GUI.Time  = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

function showMenu ()
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'Redemption',
    {
      title    = 'Redemption',
      align = 'left',
      elements = {
        { label = 'Animations', value = 'animations' },
      },
    },
    function (data, menu)
      if data.current.value == 'animations' then
        showAnimationMenu()
      end
    end,
    function(data, menu)
      menu.close()
    end
  )
end

function showAnimationMenu ()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'Animations',
    {
      title = 'Animations',
      align = 'left',
      elements = {
        { label = 'Salut', value = 'wave' },
        { label = 'Oui', value = 'yes' },
        { label = 'Non', value = 'no' },
        { label = 'Avion', value = 'plane' },
        { label = 'WTF', value = 'wtf' },
        { label = 'Damn', value = 'damn' },
        { label = 'Tranquille', value = 'ez' },
        { label = 'Triste', value = 'depressed' },
        { label = 'Peur', value = 'fear' },
      }
    },
    function (data, menu)
      playAnimation(data.current.value)
    end,
    function(data, menu)
      menu.close()
    end
  )
end

function playAnimation (animationId)
  if animationId == 'no' then
    TriggerEvent('red:playAnimation', animationId)
  elseif animationId == 'wave' then
    TriggerEvent('red:playWave')
  elseif animationId == 'yes' then
    TriggerEvent('Yes')
  elseif animationId == 'plane' then
    TriggerEvent('T')
  elseif animationId == 'wtf' then
    TriggerEvent('Wtf')
  elseif animationId == 'damn' then
    TriggerEvent('Damn')
  elseif animationId == 'ez' then
    TriggerEvent('Ez')
  elseif animationId == 'depressed' then
    TriggerEvent('Depressed')
  elseif animationId == 'fear' then
    TriggerEvent('Fear')
  end
end


Citizen.CreateThread(function()
  while true do

    Wait(0)

    if IsControlPressed(0, Keys["F3"]) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'Redemption') and (GetGameTimer() - GUI.Time) > 150 then
      showMenu()
      GUI.Time  = GetGameTimer()
    end

  end
end)


