local isAfk = false
local afkTime = 0
local totalAfkTime = 0 

local allowedCoords = { x = 151.854, y = -567.93, z = 43.8932 }
local allowedRadius = 5.0 

function Notify(message, type)
    TriggerEvent('mythic_notify:client:SendAlert', { type = type, text = message, length = 5000 })
end

RegisterCommand("afk", function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    local distance = #(vector3(playerCoords.x, playerCoords.y, playerCoords.z) - vector3(allowedCoords.x, allowedCoords.y, allowedCoords.z))
    
    if distance > allowedRadius then
        Notify("Bu komutu kullanmak için AFK Oyun bölgesinde olmanız gerekmektedir.", "error")
        return
    end
    
    if isAfk then 
        TriggerServerEvent("afk:claimEarnings", afkTime) 
        afkTime = 0 
        isAfk = false 
        SetEntityInvincible(playerPed, false) 
        FreezeEntityPosition(playerPed, false) 
        Notify("Afk modundan çıktınız.", "error")
    else
        if vehicle == 0 then 
            isAfk = true 
            SetEntityInvincible(playerPed, true) 
            FreezeEntityPosition(playerPed, true) 
            Notify("Afk moduna geçtiniz.", "success")
        else
            Notify("Araç içindeyken afk moduna geçemezsiniz.", "error")
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) 

        if isAfk then
            afkTime = afkTime + 1 
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) 

        if isAfk then
            SetTextRightJustify(true)
            SetTextWrap(0.0, 1.0)
            SetTextScale(0.4, 0.4)
            SetTextEntry("STRING")
            AddTextComponentString("Afk süresi: " .. afkTime .. " saniye")
            DrawText(0.95, 0.95) 
        end    
    end
end)
