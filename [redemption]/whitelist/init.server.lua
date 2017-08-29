WhiteList = {}

function loadWhiteList ()
  local results = MySQL.Sync.fetchAll('SELECT * FROM whitelist')

  for i=1, #results, 1 do
    table.insert(WhiteList, tostring(results[i].identifier))
    print ("[WHITELISTED] : " ..results[i].identifier)
  end
end

TriggerEvent('es:addGroupCommand', 'loadWhitelist', 'admin', function(source, args, user)
  loadWhiteList()
end, { help = 'Recharger la Whitelist'})

AddEventHandler('onMySQLReady', function ()
  loadWhiteList()
end)

AddEventHandler('playerConnecting', function (playerName, setKickReason)
  if (WhiteList == {}) then
    Citizen.Wait(1000)
  end

  local whitelisted = false
  local steamID = GetPlayerIdentifiers(source)[1] or false

  if steamID == false then
    setKickReason(_U('steamid_error'))
    CancelEvent()
  end

  for i=1, #WhiteList, 1 do
    if (tostring(WhiteList[i]) == tostring(steamID)) then
      whitelisted = true
    end
  end

  if whitelisted == false then
    setKickReason(_U('not_whitelisted'))
    CancelEvent()
  end
end)
