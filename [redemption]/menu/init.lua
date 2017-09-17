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

local GUI = {}

ESX = nil
GUI.Time  = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

Citizen.CreateThread(function ()
  while true do
  Citizen.Wait(0)
    if IsPedUsingAnyScenario(GetPlayerPed(-1)) then
      if IsControlJustPressed(1, 34) or IsControlJustPressed(1, 32) or IsControlJustPressed(1, 8) or IsControlJustPressed(1, 9) then
        ClearPedTasks(GetPlayerPed(-1))
      end
    end

  end
end)

function showGlobalMenu ()
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'Redemption',
    {
      title     = 'Redemption',
      align     = 'left',
      elements  = {
        { label = 'Téléphone',    value = 'phone' },
        -- { label = 'Inventaire',   value = 'inventory' },
        -- { label = 'Factures',     value = 'billings' },
        { label = 'Animations',   value = 'animations' },
      },
    },
    function (data, menu)
      if data.current.value == 'phone' then
        ESX.UI.Menu.Open('phone', 'esx_phone', 'main')
      end

      if data.current.value == 'inventory' then
        ESX.UI.Menu.Open('default', 'es_extended', 'inventory')
      end

      if data.current.value == 'billings' then
        ESX.UI.Menu.Open('default', 'esx_billing', 'billing')
      end

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
        { label = 'Animations de Salutations', value = 'animsSalute' },
        { label = "Animations d'Humeurs", value = 'animsHumor' },
        -- { label = 'Animations de Travail', value = 'animsWork' },
        { label = 'Animations Festives', value = 'animsFestives' },
        { label = 'Animations Diverses', value = 'animsOthers' },
      }
    },
    function (data, menu)
      if data.current.value == 'animsSalute' then
        showAnimationSaluteMenu()
      elseif data.current.value == 'animsHumor' then
        showAnimationHumorMenu()
      elseif data.current.value == 'animsFestives' then
        showAnimationFestiveMenu()
      elseif data.current.value == 'animsOthers' then
        showAnimationOtherMenu()
      end
    end,
    function(data, menu)
      menu.close()
    end
  )
end

function showAnimationSaluteMenu ()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'AnimationSalute',
    {
      title = 'Animations de Salutations',
      align = 'left',
      elements = {
        { label = 'Saluer', type = 'animsAction', value = { lib = 'gestures@m@standing@casual', anim = 'gesture_hello' } },
        { label = "Serrer la main", type = 'animsAction', value = { lib = "mp_common", anim = "givetake1_a" } },
        { label = 'Tape en 5', type = 'animsAction', value = { lib = "mp_ped_interaction", anim = "highfive_guy_a" } },
        { label = 'Salut Militaire', type = 'animsAction', value = { lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute" } },
      }
    },
    function (data, menu)
      playAnimation(data.current.type, data.current.value)
    end,
    function(data, menu)
      menu.close()
    end
  )
end

function showAnimationHumorMenu ()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'AnimationHumor',
    {
      title = "Animations d'Humeur",
      align = 'left',
      elements = {
        { label = 'Féliciter', type = 'animsActionScenario', value = { anim = 'WORLD_HUMAN_CHEERING' } },
        { label = "Super", type = 'animsAction', value = { lib = 'anim@mp_player_intcelebrationmale@thumbs_up', anim = 'thumbs_up' } },
        { label = 'Calme-toi', type = 'animsAction', value = { lib = 'gestures@m@standing@casual', anim = 'gesture_easy_now' } },
        { label = 'Avoir peur', type = 'animsAction', value = { lib = 'amb@code_human_cower_stand@female@idle_a', anim = 'idle_c' } },
        { label = "C'est pas Possible!", type = 'animsAction', value = { lib = 'gestures@m@standing@casual', anim = 'gesture_damn' } },
        { label = 'Enlacer', type = 'animsAction', value = { lib = 'mp_ped_interaction', anim = 'kisses_guy_a' } },
        { label = "Doigt d'honneur", type = 'animsAction', value = { lib = 'mp_player_int_upperfinger', anim = 'mp_player_int_finger_01_enter' } },
        { label = 'Branleur', type = 'animsAction', value = { lib = 'mp_player_int_upperwank', anim = 'mp_player_int_wank_01' } },
        { label = 'Balle dans la tete', type = 'animsAction', value = { lib = 'mp_suicide', anim = 'pistol' } },

      }
    },
    function (data, menu)
      playAnimation(data.current.type, data.current.value)
    end,
    function(data, menu)
      menu.close()
    end
  )
end

function showAnimationFestiveMenu ()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'AnimationFestive',
    {
      title = "Animations Festives",
      align = 'left',
      elements = {
        { label = 'Danser', type = 'animsAction', value = { lib = 'amb@world_human_partying@female@partying_beer@base', anim = 'base' } },
        { label = 'Jouer de la musique', type = 'animsActionScenario', value = { anim = 'WORLD_HUMAN_MUSICIAN' } },
        { label = 'Boire une bière', type = 'animsActionScenario', value = { anim = 'WORLD_HUMAN_DRINKING' } },
        { label = 'Air Guitar', type = 'animsAction', value = { lib = 'anim@mp_player_intcelebrationfemale@air_guitar', anim = 'air_guitar' } },
      }
    },
    function (data, menu)
      playAnimation(data.current.type, data.current.value)
    end,
    function(data, menu)
      menu.close()
    end
  )
end

function showAnimationOtherMenu ()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'AnimationFestive',
    {
      title = "Animations Festives",
      align = 'left',
      elements = {
        { label = 'Fumer une clope', type = 'animsActionScenario', value = { anim = 'WORLD_HUMAN_SMOKING' } },
        { label = "S'asseoir", type = 'animsAction', value = { lib = 'anim@heists@prison_heistunfinished_biztarget_idle', anim = 'target_idle' } },
        { label = "S'asseoir (Par terre)", type = 'animsActionScenario', value = { anim = 'WORLD_HUMAN_PICNIC' } },
        { label = 'Attendre', type = 'animsActionScenario', value = { anim = 'world_human_leaning' } },
        { label = 'Nettoyer quelque chose', type = 'animsActionScenario', value = { anim = 'world_human_maid_clean' } },
        { label = 'Position de Fouille', type = 'animsAction', value = { lib = 'mini@prostitutes@sexlow_veh', anim = 'low_car_bj_to_prop_female' } },
        { label = "Se gratter les parties intimes", type = 'animsAction', value = { lib = 'mp_player_int_uppergrab_crotch', anim = 'mp_player_int_grab_crotch' } },
        { label = "Prendre un selfie", type = 'animsActionScenario', value = { anim = 'world_human_tourist_mobile' } },
      }
    },
    function (data, menu)
      playAnimation(data.current.type, data.current.value)
    end,
    function(data, menu)
      menu.close()
    end
  )
end

function playAnimation (type, animation)
  if type == 'animsAction' then
    animsAction(animation)
  elseif type == 'animsActionScenario' then
    animsActionScenario(animation)
  end
end

function animsAction (animation)
  RequestAnimDict( animation.lib )

  while not HasAnimDictLoaded( animation.lib ) do
    Citizen.Wait(0)
  end

  if HasAnimDictLoaded( animation.lib ) then
    TaskPlayAnim( GetPlayerPed(-1), animation.lib , animation.anim ,8.0, -8.0, -1, 0, 0, false, false, false )
  end
end

function animsActionScenario (animation)
  local ped = GetPlayerPed(-1);

  if ped then
    local pos = GetEntityCoords(ped);
    local head = GetEntityHeading(ped);
    --TaskStartScenarioAtPosition(ped, animObj.anim, pos['x'], pos['y'], pos['z'] - 1, head, -1, false, false);
    TaskStartScenarioInPlace(ped, animation.anim, 0, false)
    if IsControlJustPressed(1,188) then
    end

  end
end

function animsWithModelsSpawn (object)
  local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))

  RequestModel(object.object)
  while not HasModelLoaded(object.object) do
    Wait(1)
  end

  local object = CreateObject(object.object, x, y+2, z, true, true, true)
  -- local vX, vY, vZ = table.unpack(GetEntityCoords(object,  true))

  -- AttachEntityToEntity(object, PlayerId(), GetPedBoneIndex(PlayerId()), vX,  vY,  vZ, -90.0, 0, -90.0, true, true, true, false, 0, true)
  PlaceObjectOnGroundProperly(object)
end


Citizen.CreateThread(function ()
  while true do

    Wait(0)

    if IsControlPressed(0, Keys["F3"]) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'Redemption') and (GetGameTimer() - GUI.Time) > 150 then
      showGlobalMenu()
      GUI.Time  = GetGameTimer()
    end

  end
end)


