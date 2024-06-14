ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj 
end)

local afkEarningsPerSecond = 1 
local discordWebhookURL = ""

RegisterServerEvent("afk:claimEarnings")
AddEventHandler("afk:claimEarnings", function(amount, afkTime)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        xPlayer.addAccountMoney('bank', amount)
        TriggerClientEvent("mythic_notify:client:SendAlert", _source, { type = "success", text = "Afk süresi boyunca kazanılan $" .. amount .. " banka hesabınıza eklendi.", length = 5000 })
        local playerName = GetPlayerName(_source)
        local message = string.format("**%s** isimli oyuncu afk modundan çıktı. **Kazanılan para:** $%s **[ReaineR Logs]**", playerName, amount)
        SendDiscordMessage(message)
    end
end)

function SendDiscordMessage(message)
    PerformHttpRequest(discordWebhookURL, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end