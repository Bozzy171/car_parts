ESX = nil
ESX = exports["es_extended"]:getSharedObject()

local activeStashes = {}
-- Function to create a temporary stash with random items
local function createTempStash(playerId, stashId, items)
    -- Create a temporary stash using ox_inventory
    local mystash = exports.ox_inventory:CreateTemporaryStash({
        label = stashId,
        slots = Config.StashSize,
        maxWeight = 0,
        items = items
    })

    if mystash then
        exports.ox_inventory:forceOpenInventory(playerId, 'stash', mystash)
    else
        print("Error creating stash")
    end
end

-- Event to handle player interaction
RegisterNetEvent('car_parts:interact')
AddEventHandler('car_parts:interact', function(propHash, propCoords, items)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    -- Check player proximity to the prop
    local playerCoords = GetEntityCoords(GetPlayerPed(_source))
    if #(playerCoords - propCoords) < 3.0 then
        -- Generate a unique stash ID
        local stashId = 'car_parts_' .. _source .. '_' .. propHash

        -- Create the temporary stash
        local mystash = exports.ox_inventory:CreateTemporaryStash({
            label = stashId,
            slots = Config.StashSize,
            maxWeight = 0,
            items = items
        })

        if mystash then
            exports.ox_inventory:forceOpenInventory(_source, 'stash', mystash)
        else
            print("Error creating stash")
        end
    end
end)

RegisterServerEvent('car_parts:createStash')
AddEventHandler('car_parts:createStash', function(stashId, items)
    local xPlayer = ESX.GetPlayerFromId(source)
    local stashName = stashId

    if activeStashes[stashId] then
        print("Duplicate stash creation attempt detected: " .. stashId)
        return
    end

    activeStashes[stashId] = true

    local formattedItems = {}
    for _, item in ipairs(items) do
        local formattedItem = { item.name, item.count }
        table.insert(formattedItems, formattedItem)
    end

    if not stashId then
        activeStashes[stashId] = nil
        return
    end

    local mystash = exports.ox_inventory:CreateTemporaryStash({
        label = stashName,
        slots = Config.StashSize,
        maxWeight = 0,
        items = formattedItems,
    })
    if mystash then
        exports.ox_inventory:forceOpenInventory(source, 'stash', mystash)
    else
        print("Error creating stash")
    end

    activeStashes[stashId] = nil
end)
