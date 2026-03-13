local shared = require 'shared.config'
local spawnedPlants = {}

---@param model number
---@param coords vector3
---@return number
local function spawnPlant(model, coords)
    lib.requestModel(model)

    local entity = CreateObject(model, coords.x, coords.y, coords.z, false, true, false)

    FreezeEntityPosition(entity, true)
    PlaceObjectOnGroundProperly(entity)

    return entity
end

---@param entity number
---@param drug string
local function createTarget(entity, drug)
    local data = shared.Drugs[drug].collect

    exports.ox_target:addLocalEntity(entity, {
        {
            name = 'collect_' .. drug,
            icon = data.icon,
            label = data.label,
            distance = 2.0,

            onSelect = function()
                local coords = GetEntityCoords(entity)

                local success = lib.progressCircle({
                    duration = 5000,
                    label = data.label,
                    position = 'middle',
                    disable = {
                        move = true,
                        combat = true,
                    },
                    anim = {
                        dict = 'amb@prop_human_parking_meter@male@idle_a',
                        clip = 'idle_a'
                    }
                })

                if not success then return end

                DeleteEntity(entity)

                TriggerServerEvent('krs_drugs:server:collect', drug, coords)

                respawnPlant(drug, coords)
            end
        }
    })
end

---@param drug string
local function spawnPlants(drug)
    local data = shared.Drugs[drug].collect

    for i = 1, data.plants do
        local coords = vec3(
            data.zone.center.x + math.random(-data.zone.radius, data.zone.radius),
            data.zone.center.y + math.random(-data.zone.radius, data.zone.radius),
            data.zone.center.z
        )

        local plant = spawnPlant(data.prop, coords)

        createTarget(plant, drug)

        spawnedPlants[#spawnedPlants + 1] = plant
    end
end

local function deletePlants()
    for i = 1, #spawnedPlants do
        local entity = spawnedPlants[i]

        if DoesEntityExist(entity) then
            exports.ox_target:removeLocalEntity(entity)
            DeleteEntity(entity)
        end
    end

    spawnedPlants = {}
end

---@param drug string
---@param coords vector3
function respawnPlant(drug, coords)
    CreateThread(function()
        Wait(Config.RespawnTime * 1000)

        local data = shared.Drugs[drug].collect

        local plant = spawnPlant(data.prop, coords)

        createTarget(plant, drug)

        spawnedPlants[#spawnedPlants + 1] = plant
    end)
end

---@param drug string
function createProcessPed(drug)
    local data = shared.Drugs[drug].process

    if not data.ped then return end

    local model = joaat(data.ped.model)
    lib.requestModel(model)

    local ped = CreatePed(
        0,
        model,
        data.ped.coords.x,
        data.ped.coords.y,
        data.ped.coords.z - 1.0,
        data.ped.coords.w,
        false,
        true
    )

    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    if data.ped.scenario then
        TaskStartScenarioInPlace(ped, data.ped.scenario, 0, true)
    end

    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'process_' .. drug,
            icon = data.icon,
            label = data.label,
            distance = 2.0,

            onSelect = function()
                local count = exports.ox_inventory:Search('count', data.input)

                if count <= 0 then
                    exports.qbx_core:Notify("You don't have " .. data.input, 'error')
                    return
                end

                TaskTurnPedToFaceEntity(cache.ped, ped, 1000)
                Wait(500)

                local success = lib.progressCircle({
                    duration = data.duration,
                    label = data.label,
                    position = 'middle',
                    canCancel = true,
                    disable = {
                        move = true,
                        car = true,
                        combat = true
                    },
                    anim = {
                        dict = 'mp_common',
                        clip = 'givetake1_a'
                    }
                })

                if success then
                    TriggerServerEvent('krs_drugs:server:process', drug, 1)
                end
            end
        }
    })
end


for drug, data in pairs(shared.Drugs) do
    createProcessPed(drug)

    lib.zones.sphere({
        coords = data.collect.zone.center,
        radius = Config.SpawnDistance,
        debug = false,

        onEnter = function()
            spawnPlants(drug)
        end,

        onExit = function()
            deletePlants()
        end
    })
end