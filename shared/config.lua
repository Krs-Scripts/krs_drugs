
Karos = {}

Karos.webhookRaccolta = '' -- Webhook Raccolta

Karos.webhookProcesso = '' -- Webhook Processo

Karos.webhookVendita = '' -- Webhook Vendita

Karos.webhookTitle = 'Krs Log' -- Scrivi il nome del bot desiderato

Karos.webhookNameServer = 'Nome Server' -- Scrivi il nome del tuo server

Karos.webhookColor = 1867478 -- https://www.spycolor.com/

Karos.webhookDateFormat = "%d/%m/%Y" -- https://www.lua.org/pil/22.1.html

Karos.webhookTimeFormat = "%H:%M" -- https://www.lua.org/pil/22.1.html

Karos.webhookImageUrl = '' -- Webhook Image Url

Karos.raccolta = {
    {
        raccoltaTextUi = '[E] - Raccolta',
        duration = 5000,
        label = 'Raccogliendo la weed',
        position = 'middle',
        dict = 'mini@repair',
        clip = 'fixing_a_ped',
        coords = vector3(244.2037, -765.7497, 30.7909),
        policeRichiesti = 0,
        itemRichiestoRaccolta = 'forbici'
    },
    -- {
    --     raccoltaTextUi = '[E] - Raccolta',
    --     duration = 5000,
    --     label = 'Raccogliendo la weed',
    --     position = 'middle',
    --     dict = 'mini@repair',
    --     clip = 'fixing_a_ped',
    --     coords = vector3(244.2037, -765.7497, 30.7909),
    --     policeRichiesti = 0,
    --     itemRichiestoRaccolta = 'forbici'
    -- },
    
}

Karos.processo = {
    {
        processoTextUi = '[E] - Processo',
        duration = 5000,
        label = 'Processando la cannabis',
        position = 'middle',
        dict = 'anim@amb@business@weed@weed_inspecting_lo_med_hi@',
        clip = 'weed_crouch_checkingleaves_idle_03_inspector',
        coords = vector3(244.2307, -777.1072, 30.6546),
        policeRichiesti = 0,
        itemRichiestoProcesso = 'bustine'
    },
    -- {
    --     processoTextUi = '[E] - Processo',
    --     duration = 5000,
    --     label = 'Processando la cannabis',
    --     position = 'middle',
    --     dict = 'anim@amb@business@weed@weed_inspecting_lo_med_hi@',
    --     clip = 'weed_crouch_checkingleaves_idle_03_inspector',
    --     coords = vector3(244.2307, -777.1072, 30.6546),
    --     policeRichiesti = 0,
    --     itemRichiestoProcesso = 'bustine'
    -- },
    
}


Karos.money = {
    ["random"] = 200,
}

Karos.vendita = {

    {
        venditaTextUi = '[E] - Vendita',
        markerVendita = vector3(233.1704, -773.9330, 30.7384), 
        blip = {
           
            posizione = vector3(233.1704, -773.9330, 30.7384),
            sprite = 272,
            scale = 0.8,
            color = 0,
            nameText = 'Vendita Droga'
        },
        venditaDroga = {
            { label= "Weed", value= "weed"},
        },
    }
}

