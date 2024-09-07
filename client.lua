-- Function to handle interaction prompt
local function showHelpText(text)
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Function to find props with specified hashes
local function findProps()
    local props = {}
    for _, hash in ipairs(Config.PropHashes) do
        local prop = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 100.0, hash, false, false, false)
        if prop and DoesEntityExist(prop) then
            table.insert(props, prop)
        end
    end
    return props
end

-- Function to get random items
local function getRandomItems()
    local items = {}
    for i = 1, Config.StashSize do
        local randomItem = Config.ScrapItems[math.random(#Config.ScrapItems)]
        local count = math.random(randomItem.min, randomItem.max)
        
        if randomItem and randomItem.item and count > 0 then
            table.insert(items, { name = randomItem.item, count = count })
        end
    end
    return items
end


-- Cooldown tracker
local propCooldowns = {}
local playerCooldown = 0

-- Function to check if prop is on cooldown
local function isPropOnCooldown(prop)
    local propCoords = GetEntityCoords(prop)
    local propHash = GetEntityModel(prop)
    local propKey = tostring(propHash) .. ':' .. tostring(propCoords.x) .. ':' .. tostring(propCoords.y) .. ':' .. tostring(propCoords.z)
    
    if propCooldowns[propKey] then
        if GetGameTimer() < propCooldowns[propKey] then
            return true
        else
            propCooldowns[propKey] = nil -- Cooldown expired, remove it
        end
    end
    return false
end

-- Function to set prop cooldown
local function setPropCooldown(prop)
    local propCoords = GetEntityCoords(prop)
    local propHash = GetEntityModel(prop)
    local propKey = tostring(propHash) .. ':' .. tostring(propCoords.x) .. ':' .. tostring(propCoords.y) .. ':' .. tostring(propCoords.z)
    propCooldowns[propKey] = GetGameTimer() + Config.CooldownDuration * 60 * 1000 -- Convert seconds to milliseconds
end

-- Function to check if player is on cooldown
local function isPlayerOnCooldown()
    return GetGameTimer() < playerCooldown
end

-- Function to set player cooldown
local function setPlayerCooldown()
    playerCooldown = GetGameTimer() + Config.PlayerCooldownDuration * 60 * 1000 -- Convert seconds to milliseconds
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerCoords = GetEntityCoords(PlayerPedId())
        local props = findProps()
        for _, prop in ipairs(props) do
            local propCoords = GetEntityCoords(prop)
            local propHash = GetEntityModel(prop)

            -- Check player proximity to the prop
            if #(playerCoords - propCoords) < 3.0 then
                if not isPropOnCooldown(prop) then
                    if not isPlayerOnCooldown() then
                        -- showHelpText('Press ~INPUT_CONTEXT~ to scrap the prop')
                        DrawText(propCoords.x, propCoords.y, propCoords.z, "[~g~E~w~] Search")

                        if IsControlJustReleased(1, 38) then -- 38 is the key E
                            local stashId = 'car_scraps_' .. math.random(1000, 9999)

                            local items = {}
                            local itemCount = math.random(1, #Config.ScrapItems) -- Number of different items to add
                            
                            -- Track the total number of items added
                            local totalItemsAdded = 0
                            local maxItemsAllowed = 2
                            
                            for i = 1, itemCount do
                                if totalItemsAdded >= maxItemsAllowed then
                                    break
                                end
                            
                                local item = Config.ScrapItems[math.random(1, #Config.ScrapItems)]
                                local rarity_val = math.random()
                                if rarity_val <= item.rarity then
                                    local amount = math.random(item.min, item.max)
                            
                                    -- Check if the item is already in the items table and if the item.max is 1
                                    local alreadyExists = false
                                    for _, existingItem in ipairs(items) do
                                        if existingItem.name == item.name then
                                            alreadyExists = true
                                            break
                                        end
                                    end
                            
                                    if not alreadyExists or item.max > 1 then
                                        table.insert(items, {name = item.name, count = amount})
                                        totalItemsAdded = totalItemsAdded + 1
                                    end
                                end
                            end



                            local data = {
                                time = Config.SearchTime,
                                label = 'Searching..',
                                event = 'car_parts:createStash',
                                event_val_1 = stashId,
                                event_val_2 = items,
                                type = 'server',
                                lib = 'amb@prop_human_bum_bin@idle_a',
                                anim = 'idle_a',
                                prop = nil
                            } 

                            local progress = exports['car_parts']:lib_timer(data)
                            if progress then
                                TriggerServerEvent('car_parts:createStash', stashId, items)
                            else
                                print('cancelled')
                            end
                            
                            setPropCooldown(prop) -- Set the cooldown for the prop
                            setPlayerCooldown() -- Set the cooldown for the player
                        end
                    else
                    end
                else
                end
            end
        end
    end
end)