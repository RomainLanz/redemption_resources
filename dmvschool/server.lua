ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



function getDvmLicense(identifier)
    return MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
end




RegisterServerEvent("dmv:getlicence")
AddEventHandler("dmv:getlicence", function()

    local xPlayer = ESX.GetPlayerFromId(source)
    local result = getDvmLicense(xPlayer.identifier)
    TriggerClientEvent('dmv:getlicense_client',source,result[1].licenses)
      

end)




--[[DMV TheoryTest]]--
RegisterServerEvent("dmv:success")
AddEventHandler("dmv:success", function()
    local _source        = source
    local xPlayer        = ESX.GetPlayerFromId(_source)
	
	MySQL.Async.execute(
		'UPDATE users SET licenses = "Passed" WHERE identifier = @identifier',
		{
			['@identifier']    = xPlayer.identifier
		}
	)
        
end)

RegisterServerEvent("dmv:successconduite")
AddEventHandler('dmv:successconduite', function(permis)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local permisQuantity = xPlayer.getInventoryItem('permis').count
	

    xPlayer.addInventoryItem('permis', 1)
end)

RegisterServerEvent("dmv:ttcharge")
AddEventHandler("dmv:ttcharge", function()
  TriggerEvent('es:getPlayerFromId', source, function(xPlayer)
    local ttest = 200  
      xPlayer.removeMoney((ttest))    
    end)
end)

RegisterServerEvent("dmv:dtcharge")
AddEventHandler("dmv:dtcharge", function()
  TriggerEvent('es:getPlayerFromId', source, function(xPlayer)
    local dtest = 500      
      xPlayer.removeMoney((dtest))    
    end)
end)

ESX.RegisterServerCallback("dmv:LicenseStatus", function(source , cb)
	local _source        = source
	local xPlayer        = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll(
        'SELECT * FROM users WHERE identifier = @identifier',
        {
            ['@identifier'] = xPlayer.identifier
        },
        function(result)
                cb(result[1].licenses)
        end
    )
end)

