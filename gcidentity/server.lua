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
    local result = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
    local user = result[1]
    return not (user['firstname'] == '' or user['lastname'] == '')
end

function getIdentity(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    local result = MySQL.Sync.fetchAll("SELECT firstname, lastname, sex, dateofbirth, height, name FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
	if result[1] ~= nil then
    local user = result[1]
	
	return {
		firstname = user['firstname'],
		lastname = user['lastname'],
		dateofbirth = user['dateofbirth'],
		sex = user['sex'],
		height = user['height'],
		name = user['name']
	}
	else
		return nil
    end
end

--====================================================================================
--  GCIdentity Set Identity
--====================================================================================
function setIdentity(identifier, data)
    MySQL.Async.fetchAll("UPDATE users SET firstname = @firstname, lastname = @lastname, dateofbirth = @dateofbirth, sex = @sex, height = @height WHERE identifier = @identifier",  {
        ['@firstname'] = data.firstname,
        ['@lastname'] = data.lastname,
        ['@dateofbirth'] = data.dateofbirth,
        ['@sex'] = data.sex,
        ['@height'] = data.height,
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
	local sex = ""
	local heightFeet = tonumber(string.format("%.0f",identity.height / 12, 0))
	local heightInches = identity.height % 12
	
	if identity.sex == "m" then
		sex = "Male"
	else
		sex = "Female"
	end
	TriggerClientEvent('chatMessage', source, "CheckID", {255, 0, 0}, "NAME: " .. identity.firstname .. " " .. identity.lastname)
	TriggerClientEvent('chatMessage', source, "CheckID", {255, 0, 0}, "SEX: " .. sex)
	TriggerClientEvent('chatMessage', source, "CheckID", {255, 0, 0}, "DOB(YYYY/MM/DD): " .. identity.dateofbirth)
	TriggerClientEvent('chatMessage', source, "CheckID", {255, 0, 0}, "HEIGHT: " .. heightFeet .. "\' " .. heightInches .. "\"")
	TriggerClientEvent('chatMessage', source, "CheckID", {255, 0, 0}, "ID: " .. identity.name)

end)

TriggerEvent('es:addCommand', 'register', function(source, args, user)
	local identity = getIdentity(source)
	print(identity.name .. ' used the GCIdentity register command.')
	TriggerClientEvent('gcIdentity:showRegisterIdentity', source, {})
end)

