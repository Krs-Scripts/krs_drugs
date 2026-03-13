Config = {}

Config.SpawnDistance = 80
Config.DespawnDistance = 100
Config.RespawnTime = 10
Config.DistanceCheck = 5.0

Config.Drugs = {
    marijuana = {
        collect = {
            prop = "prop_weed_02",
            zone = {
                center = vec3(2204.9163, 5576.4150, 53.7820),
                radius = 5
            },
            plants = 10,
            item = "cannabis",
            amount = {
                min = 1,
                max = 3
            },
            label = "Collect Cannabis",
            icon = "fa-solid fa-cannabis"
        },

        process = {
            ped = {
                model = "csb_hao",
                coords = vec4(1559.5298, 3598.9426, 38.7752, 102.8646),
                scenario = "WORLD_HUMAN_DRUG_DEALER"
            },

            input = "cannabis",
            output = "marijuana_baggy",
            duration = 4000,
            label = "Process Cannabis",
            icon = "fa-solid fa-flask"
        }
    }
}

return Config