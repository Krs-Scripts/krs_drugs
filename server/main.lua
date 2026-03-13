local config = require 'shared.server'
local shared = require 'shared.config'

local cooldown = {}

---@param action string
---@param src number
---@param drug string
---@param amount number
local function logToDiscord(action, src, drug, amount)
    if config.DiscordWebhook == "" then return end

    local player = exports.qbx_core:GetPlayer(src)
    if not player then return end

    local charinfo = player.PlayerData.charinfo
    local citizenid = player.PlayerData.citizenid
    local name = charinfo.firstname .. " " .. charinfo.lastname

    local identifiers = GetPlayerIdentifiers(src)

    local license, discord

    for _, id in pairs(identifiers) do
        if id:find("license:") then
            license = id
        elseif id:find("discord:") then
            discord = id:gsub("discord:", "")
        end
    end

    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)

    local embed = {
        {
            title = "KRS Drugs Logger",
            color = 12975872,
            fields = {
                {name="Player",value=name,inline=true},
                {name="ID",value=tostring(src),inline=true},
                {name="CitizenID",value=citizenid,inline=true},
                {name="License",value=license or "N/A",inline=false},
                {name="Discord",value=discord and ("<@"..discord..">") or "N/A",inline=true},
                {name="Drug",value=drug,inline=true},
                {name="Amount",value=tostring(amount),inline=true},
                {name="Action",value=action,inline=true},
                {name="Coords",value=("%.2f %.2f %.2f"):format(coords.x,coords.y,coords.z)}
            },
            footer = { text = os.date("%Y-%m-%d %H:%M:%S") }
        }
    }

    PerformHttpRequest(config.DiscordWebhook,function() end,'POST',json.encode({
        username="Drugs Logger",
        embeds=embed
    }),{['Content-Type']='application/json'})
end

---@param src number
local function onCooldown(src)
    local time = GetGameTimer()

    if cooldown[src] and (time - cooldown[src]) < (config.Cooldown * 1000) then
        exports.qbx_core:Notify(src,"You must wait before doing this again.","error")
        return true
    end

    cooldown[src] = time
    return false
end

local function isNear(src, coords)
    local ped = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(ped)

    return #(playerCoords - coords) < config.DistanceCheck
end

local function isInsideCollectZone(drug, coords)
    local zone = shared.Drugs[drug].collect.zone
    return #(coords - zone.center) <= zone.radius + 2.0
end

local function isNearProcessPed(drug, src)
    local ped = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(ped)

    local pedCoords = shared.Drugs[drug].process.ped.coords

    return #(playerCoords - vec3(pedCoords.x,pedCoords.y,pedCoords.z)) < config.DistanceCheck
end

RegisterNetEvent('krs_drugs:server:collect',function(drug,coords)

    local src = source

    if onCooldown(src) then return end

    local data = shared.Drugs[drug]
    if not data then return end

    if not isNear(src,coords) then
        print(("EXPLOIT: %s collect distance"):format(src))
        DropPlayer(src,"Exploit detected")
        return
    end

    if not isInsideCollectZone(drug,coords) then
        print(("EXPLOIT: %s outside collect zone"):format(src))
        DropPlayer(src,"Exploit detected")
        return
    end

    local amount = math.random(
        data.collect.amount.min,
        data.collect.amount.max
    )

    exports.ox_inventory:AddItem(src,data.collect.item,amount)

    exports.qbx_core:Notify(src,
        ("You collected %sx %s"):format(amount,data.collect.item),
        "success"
    )

    logToDiscord("Collect",src,data.collect.item,amount)

end)

RegisterNetEvent('krs_drugs:server:process',function(drug,amount)

    local src = source

    if onCooldown(src) then return end

    local data = shared.Drugs[drug]
    if not data then return end

    if amount > 5 or amount <= 0 then
        print(("EXPLOIT: %s invalid amount"):format(src))
        DropPlayer(src,"Exploit detected")
        return
    end

    if not isNearProcessPed(drug,src) then
        print(("EXPLOIT: %s process distance"):format(src))
        DropPlayer(src,"Exploit detected")
        return
    end

    local count = exports.ox_inventory:GetItem(src,data.process.input,nil,true)

    if count < amount then
        print(("EXPLOIT: %s invalid item count"):format(src))
        DropPlayer(src,"Exploit detected")
        return
    end

    exports.ox_inventory:RemoveItem(src,data.process.input,amount)
    exports.ox_inventory:AddItem(src,data.process.output,amount)

    exports.qbx_core:Notify(src,
        ("You processed %sx %s"):format(amount,data.process.output),
        "success"
    )

    logToDiscord("Process",src,data.process.output,amount)

end)