local ox = exports.ox_inventory

for k, v in pairs(Karos.raccolta) do
    local raccolta = lib.points.new({
        coords = v.coords,
        distance = 5,
    })

    function raccolta:onEnter()
        lib.showTextUI(tostring(v.raccoltaTextUi))
    end

    function raccolta:onExit()
        lib.hideTextUI()
    end

    function raccolta:nearby()
        DrawMarker(21, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 8, 127, 91, 255, false, true, 2, false, nil, nil, false)

        if self.currentDistance < 3 and IsControlJustReleased(0, 38) then
            local forbici = ox:Search('count', v.itemRichiestoRaccolta) 
            if forbici < 1 then
                ESX.ShowNotification('Non possiedi le ' .. v.itemRichiestoRaccolta .. ' per procedere con la raccolta.')
                return
            end
            lib.callback('krs_droga:getPoliceOnline', false, function(policeCount)
                print(policeCount)
                if type(policeCount) == "number" and policeCount >= v.policeRichiesti then
                    if not cache.vehicle then
                        if lib.progressCircle({
                            duration = v.duration,
                            label = v.label,
                            position = v.position,
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                car = true,
                                move = true
                            },
                            anim = {
                                dict = v.dict,
                                clip = v.clip
                            },
                        }) then
                            TriggerServerEvent('krs_droga:raccolta')
                        end
                    end
                else
                    ESX.ShowNotification('Non ci sono abbastanza poliziotti online, minimo richiesto: ' .. v.policeRichiesti .. ' per procedere con la raccolta.')
                end
            end)
        end
    end
end


for k, v in pairs(Karos.processo) do
    local processo = lib.points.new({
        coords = v.coords,
        distance = 5,
    })

    function processo:onEnter()
        lib.showTextUI(tostring(v.processoTextUi))
    end

    function processo:onExit()
        lib.hideTextUI()
    end

    function processo:nearby()
        DrawMarker(21, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 8, 127, 91, 255, false, true, 2, false, nil, nil, false)

        if self.currentDistance < 3 and IsControlJustReleased(0, 38) then
            local bustine = ox:Search('count', v.itemRichiestoProcesso) 
            if bustine < 1 then
                ESX.ShowNotification('Non possiedi le ' .. v.itemRichiestoProcesso .. ' per procedere con il processo.')
                return
            end
            lib.callback('krs_droga:getPoliceOnline', false, function(policeCount)
                print(policeCount)
                if type(policeCount) == "number" and policeCount >= v.policeRichiesti then
                    if not cache.vehicle then
                        if lib.progressCircle({
                            duration = v.duration,
                            label = v.label,
                            position = v.position,
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                car = true,
                                move = true
                            },
                            anim = {
                                dict = v.dict,
                                clip = v.clip
                            },
                        }) then
                            TriggerServerEvent('krs_droga:processo')
                        end
                    end
                else
                    ESX.ShowNotification('Non ci sono abbastanza poliziotti online, minimo richiesto: ' .. v.policeRichiesti .. ' per procedere con il processo.')
                end
            end)
        end
    end
end

CreateThread(function()

    for k, v in pairs(Karos.vendita) do

        local blip = AddBlipForCoord(v.blip.posizione.x, v.blip.posizione.y, v.blip.posizione.z)
        SetBlipSprite(blip, v.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, v.blip.scale)
        SetBlipColour(blip, v.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.blip.nameText)
        EndTextCommandSetBlipName(blip)

        local point = lib.points.new({
            coords = v.markerVendita,
            distance = 5,
        })
        
        function point:onEnter()
            lib.showTextUI(tostring(v.venditaTextUi))
        end
        
        function point:onExit()
            lib.hideTextUI()
        end
        
        function point:nearby()
            DrawMarker(29, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 8, 127, 91, 255, false, true, 2, false, nil, nil, false)
            if self.currentDistance < 3 and IsControlJustReleased(0, 38) then
                vendita()
            end
        end
    end
end)

function vendita()

        local options = {}

        for k, v in pairs(Karos.vendita) do

            print(ESX.DumpTable(v))

            for c, d in pairs(v.venditaDroga) do

                options[#options+1] = {

                    label = d.label,
                    value = d.value
                }
            end

        local input = lib.inputDialog('Vendita Menu', {
            {type = 'select', label = 'vendita', description = 'Qui puoi vendere la tua droga', icon = 'fa-solid fa-dollar', options = options  

            },

            {type = 'number', label = 'quantità', min = 1, description = 'Qui puoi mettere la quantità', icon = 'fa-solid fa-cannabis'},  
        
        })
        
        if input and #input > 0 then
            TriggerServerEvent('krs_droga:vendita',  input[1], input[2])
        end
    end
end