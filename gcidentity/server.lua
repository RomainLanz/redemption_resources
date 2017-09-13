--====================================================================================
-- ORIGINAL Author: Jonathan D & Charlie @ charli62128
-- 
-- Developed for the n3mtv community
--      https://www.twitch.tv/n3mtv
--      https://twitter.com/n3m_tv
--      https://www.facebook.com/lan3mtv
--====================================================================================

--====================================================================================
-- GCIdentity edited and fixed by Ark. None of this would be possible without the work
-- of the original authors, so I do not want to take the credit that they deserve away
-- from them.
--====================================================================================

--====================================================================================
--  GCIdentity Information Checks
--====================================================================================
function hasIdentity(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    local result = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM characters WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })

    return result[1] ~= nil
end

function getIdentity(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    local result = MySQL.Sync.fetchAll("SELECT firstname, lastname, dateofbirth FROM characters WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })

	if result[1] ~= nil then
        local user = result[1]
    	
    	return {
    		firstname = user['firstname'],
    		lastname = user['lastname'],
    		dateofbirth = user['dateofbirth']
    	}
	else
		return nil
    end
end

--====================================================================================
--  GCIdentity Set Identity
--====================================================================================
function setIdentity(identifier, data)
    MySQL.Async.fetchAll("INSERT INTO characters (identifier, firstname, lastname, dateofbirth) VALUES (@identifier, @firstname, @lastname, @dateofbirth)",  {
        ['@firstname'] = data.firstname,
        ['@lastname'] = data.lastname,
        ['@dateofbirth'] = data.dateofbirth,
        ['@identifier'] = identifier
    })
end

AddEventHandler('es:playerLoaded', function(source)
    local result = hasIdentity(source)

    if result == false then
		Wait(1000)
        TriggerClientEvent('gcIdentity:showRegisterIdentity', source, {})
    end
end)

RegisterServerEvent('gcIdentity:setIdentity')
AddEventHandler('gcIdentity:setIdentity', function(data)
    setIdentity(GetPlayerIdentifiers(source)[1], data)
end)

function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

--====================================================================================
--  GCIdentity Commands
--====================================================================================
TriggerEvent('es:addCommand', 'checkid', function(source, args, user)
	local identity = getIdentity(source)
	
	TriggerClientEvent('chatMessage', source, "CheckID", {255, 0, 0}, "NAME: " .. identity.firstname .. " " .. identity.lastname)
	TriggerClientEvent('chatMessage', source, "CheckID", {255, 0, 0}, "DOB(YYYY/MM/DD): " .. identity.dateofbirth)
end)

TriggerEvent('es:addCommand', 'register', function(source, args, user)
	local identity = getIdentity(source)
	print(identity.name .. ' used the GCIdentity register command.')
	TriggerClientEvent('gcIdentity:showRegisterIdentity', source, {})
end)

