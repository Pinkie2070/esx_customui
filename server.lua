RegisterServerEvent('syncData')
AddEventHandler('syncData', function(playerId)
	TriggerClientEvent('syncFacial', -1, playerId)
end)

RegisterServerEvent('unsyncData')
AddEventHandler('unsyncData', function(playerId)
	TriggerClientEvent('stopsyncFacial', -1, playerId)
end)