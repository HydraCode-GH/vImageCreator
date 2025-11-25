local resultVehicles = {}
local thumbs = {}

local CONFIG = {
    save = Config.save or 'kvp',
    useSQLvehicle = Config.useSQLvehicle or false,
    vehicle_table = Config.vehicle_table or 'vehicles',
    Category = Config.Category or 'all',
    SqlVehicleTable = Config.SqlVehicleTable or {},
    owners = Config.owners or {}
}

local function HasPermission(source)
    for i = 0, GetNumPlayerIdentifiers(source) do
        local identifier = GetPlayerIdentifier(source, i)
        if identifier and CONFIG.owners[identifier] then
            return true
        end
    end
    return false
end

local function LoadThumbnails()
    if CONFIG.save == 'kvp' then
        return json.decode(GetResourceKvpString('thumbnails') or '[]') or {}
    else
        return json.decode(LoadResourceFile('vImageCreator', 'thumbnails.json') or '[]') or {}
    end
end

local function SaveThumbnails(thumbnails)
    if CONFIG.save == 'kvp' then
        SetResourceKvp('thumbnails', json.encode(thumbnails))
    else
        SaveResourceFile("vImageCreator", "thumbnails.json", json.encode(thumbnails), -1)
    end
end

local function LoadVehicles()
    if CONFIG.useSQLvehicle then
        return MySQL.Sync.fetchAll('SELECT * FROM ' .. CONFIG.vehicle_table) or {}
    else
        return CONFIG.SqlVehicleTable or {}
    end
end

local function FilterVehiclesByCategory(vehicles)
    if CONFIG.Category == 'all' then
        return vehicles
    end

    local filtered = {}
    for _, vehicle in ipairs(vehicles) do
        if vehicle.category == CONFIG.Category then
            filtered[#filtered + 1] = vehicle
        end
    end
    return filtered
end

local function NormalizeThumbnails(thumbnails)
    local normalized = {}
    local count = 0

    for modelHash, imageUrl in pairs(thumbnails) do
        normalized[tostring(modelHash)] = imageUrl
        count = count + 1
    end

    return normalized, count
end

-- Command Handlers
RegisterCommand('getperms', function(source)
    if not source or source == 0 then return end

    if HasPermission(source) then
        local playerState = Player(source).state
        playerState.screenshotperms = true

        print(("Player ID: %d Granted Permission to use Screenshot Vehicle\nCommands:\nStart Screen Shot Vehicle /startscreenshot\nReset screenshot index (last vehicle number for continuation purpose) /resetscreenshot"):format(source))
    end
end)

-- Event Handlers
RegisterNetEvent("renzu_vehthumb:save", function(data)
    if not data or not data.model then return end

    local modelHash = tostring(GetHashKey(data.model))
    thumbs[modelHash] = data.img

    SaveThumbnails(thumbs)
    GlobalState.VehicleImages = thumbs

    print(("Vehicle thumbnail saved for model: %s"):format(data.model))
end)

-- Initialization
CreateThread(function()
    -- Load thumbnails
    thumbs = LoadThumbnails()

    -- Load vehicles
    resultVehicles = LoadVehicles()

    -- Filter vehicles by category if needed
    local filteredVehicles = FilterVehiclesByCategory(resultVehicles)
    GlobalState.VehiclesFromDB = filteredVehicles

    -- Normalize and set thumbnails
    local normalizedThumbs, thumbCount = NormalizeThumbnails(thumbs)
    GlobalState.VehicleImages = normalizedThumbs

    print(("Initialization complete - %d vehicles loaded, %d thumbnails cached"):format(#filteredVehicles, thumbCount))
end)