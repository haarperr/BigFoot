                                                                    

SpawnedBigFoot = false

function MissionText(text,time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function SpawnBigFoot1()
    local ped = GetPlayerPed(-1)
    local pedSource = GetPlayerPed(source)
    local x, y, z = table.unpack(GetEntityCoords(ped, true))
    local model = 1641334641  -- Hash of BigFoot
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end
    BigFoot = CreatePed(9, model, -635.18, 5155.70, 109.26, 2.05, true, true) --Location : South of the Sawmill
    TaskCombatPed(BigFoot, ped, 0, 16)
    TaskCombatHatedTargetsAroundPed(ped, 10, 0)
    SetEntityAsMissionEntity(BigFoot, true, true)

    local BigFootBlip = AddBlipForEntity(BigFoot)
    SetBlipSprite(BigFootBlip, 153)
    SetBlipColour(BigFootBlip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Big Foot')      -- Blip Text
    EndTextCommandSetBlipName(BigFootBlip)

end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local playerPos = GetEntityCoords(ped)
        local distanceToBigFootZone = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, -618.84, 5126.85, 117.08, true)
        local distanceToBigFootSpawn1 = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, -635.18, 5155.70, 109.26, true)
        local uur = GetClockHours()
        if distanceToBigFootZone < 250 then
            if uur >= 20 and uur <= 23 then -- Only Spawns between these hours
                MissionText("Volgens de Legende loopt ~r~BigFoot~w~ hier ergens rond! ~b~Probeer hem niet te voeren!!") -- Message when entering zone (nearby Bigfoot)
                if distanceToBigFootSpawn1 < 25 then 
                    if not IsPedDeadOrDying(ped, 1) and not IsPlayerDead(ped) and not IsPedInAnyVehicle(ped, true) then
                        SpawnBigFoot1()
                        SpawnedBigFoot = true
                    end
                    if SpawnedBigFoot == true then
                        break
                    end
                end
            end
        end
    end
end)