local ox = exports.ox_inventory

local cannabis = 'cannabis'
local weed = 'weed'

RegisterNetEvent('krs_droga:raccolta', function()
    local krs = ESX.GetPlayerFromId(source)
    local randomCount = math.random(1, 3) 
    
    ox:AddItem(source, cannabis, randomCount)
    krs.showNotification("Hai raccolto: " .. randomCount .. " " .. cannabis .. ".")
    TriggerEvent('krs:discordLog', source, 'raccolta') 
end)

RegisterNetEvent('krs_droga:processo', function()
    local krs = ESX.GetPlayerFromId(source)
    local processo = ox:Search(source, 'count', cannabis)
    if processo >= 3 then  
        ox:AddItem(source, weed, 1)
        ox:RemoveItem(source, cannabis, 3)
        krs.showNotification("Hai processato la cannabis")
        TriggerEvent('krs:discordLog', source, 'processo') 
    else
        krs.showNotification("Per processare la weed ti serviranno almeno [3] piantine di cannabis.")
    end
end)

lib.callback.register('krs_droga:getPoliceOnline', function(source)

	local cops = 0
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			cops = cops + 1
		end
	end
	return cops
end)

RegisterNetEvent("krs_droga:vendita", function(item, number)
    local krs = ESX.GetPlayerFromId(source)
    local vendita = ox:Search(source, 'count', item)
 
    local percentuale = Karos.money["random"] * number

    if vendita >= 1 then
        print("Richiesta di vendita:", item, number or 1)
        ox:RemoveItem(source, item, number or 1)
        ox:AddItem(source, "money", percentuale)
        krs.showNotification("Hai venduto la weed")
        TriggerEvent('krs:discordLog', source, "vendita") 
    else
        krs.showNotification("Non possiedi la weed da vendere")
    end
end)

RegisterServerEvent('krs:discordLog', function(source, action)
    local xPlayer = ESX.GetPlayerFromId(source)
    local nome = xPlayer.getName()
    local webhook
    local message

    if action == "raccolta" then
        webhook = Karos.webhookRaccolta
        message = 'Il Giocatore **' .. nome .. '** ha raccolto la cannabis.'
    elseif action == "processo" then
        webhook = Karos.webhookProcesso
        message = 'Il Giocatore **' .. nome .. '** ha processato la cannabis.'
    elseif action == "vendita" then
        webhook = Karos.webhookVendita
        message = 'Il Giocatore **' .. nome .. '** ha venduto la cannabis.'
    else
        return 
    end

    local embedData = {
        {
            ['title'] = Karos.webhookTitle,
            ['color'] = Karos.webhookColor,
            ['footer'] = {
                ['text'] = 'Data: ' .. os.date(Karos.webhookDateFormat) .. ' | Ora: ' .. os.date(Karos.webhookTimeFormat),
            },
            ['description'] = message,
            ['author'] = {
                ['name'] = Karos.webhookNameServer,
                ['icon_url'] = Karos.webhookImageUrl,
            },
        }
    }

    local jsonData = json.encode({embeds = embedData})

    PerformHttpRequest(webhook, function(statusCode, text, headers)
    end, 'POST', jsonData, { ['Content-Type'] = 'application/json' })
end)
