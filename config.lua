Config = {}

-- Discord Webhook Configuration
Config.DiscordWebHook = 'https://discord.com/api/webhooks/XXXXX'

-- Data Storage Configuration
Config.Storage = {
    method = 'json', -- Options: 'json', 'kvp'
    vehicleTable = 'vehicles' -- Database table name (must have 'model' column)
}

-- Vehicle Data Source Configuration
Config.VehicleSource = {
    useSQL = true, -- Use MySQL async to fetch vehicles
    fallbackTable = QBCore and QBCore.Shared and QBCore.Shared.Vehicles or {} -- Fallback vehicle table
}

-- Vehicle Filtering Configuration
Config.Filtering = {
    category = 'all' -- Vehicle category filter ('all' to include all categories)
}

-- Permissions Configuration
Config.Permissions = {
    owners = {
        ['license:XXXX'] = true,
        -- Add more license identifiers here:
        -- ['license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'] = true,
    }
}

-- Optional: Category-specific settings (if not using 'all')
-- Config.Filtering.categories = {
--     'compacts',
--     'sedans', 
--     'suvs',
--     'coupes',
--     'muscle',
--     'sports',
--     'super',
--     'motorcycles',
--     'offroad',
--     'industrial',
--     'utility',
--     'vans',
--     'cycles',
--     'boats',
--     'helicopters',
--     'planes',
--     'service',
--     'emergency',
--     'military',
--     'commercial',
--     'trains'
-- }