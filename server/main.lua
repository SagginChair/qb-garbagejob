local Bail = {}

QBCore.Functions.CreateCallback('qb-garbagejob:server:HasMoney', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    -- if Player.PlayerData.money.cash >= Config.BailPrice then
    --     Bail[CitizenId] = "cash"
    --     Player.Functions.RemoveMoney('cash', Config.BailPrice)
    --     cb(true)
    -- else
        if Player.PlayerData.money.bank >= Config.BailPrice then
        Bail[CitizenId] = "bank"
        Player.Functions.RemoveMoney('bank', Config.BailPrice)
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('qb-garbagejob:server:CheckBail', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    if Bail[CitizenId] ~= nil then
        Player.Functions.AddMoney(Bail[CitizenId], Config.BailPrice)
        Bail[CitizenId] = nil
        cb(true)
    else
        cb(false)
    end
end)

local Materials = {
    "metalscrap",
    "plastic",
    "copper",
    "iron",
    "aluminum",
    "steel",
    "glass",
    "dirt",
    "stone",
}

RegisterNetEvent('qb-garbagejob:server:nano')
AddEventHandler('qb-garbagejob:server:nano', function()
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
local elec = math.random(1,2)
	xPlayer.Functions.AddItem("electronics", elec, false)
	TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["electronics"], "add")

local Luck = math.random(1, 10)
local Odd = math.random(1, 10)
if Luck == Odd then
    local random = math.random(5, 10)
    Player.Functions.AddItem("markedbills", random)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["markedbills"], 'add')
end
end)

RegisterServerEvent('qb-garbagejob:server:PayShit')
AddEventHandler('qb-garbagejob:server:PayShit', function(amount, location)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if amount > 0 then
        Player.Functions.AddMoney('bank', amount)

        if location == #Config.Locations["trashcan"] then
            for i = 1, math.random(2, 5), 1 do
                local item = Materials[math.random(1, #Materials)]
                Player.Functions.AddItem(item, math.random(150, 180))
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
                Citizen.Wait(500)
            end
        end

        TriggerClientEvent('QBCore:Notify', src, "You have $"..amount..",- got paid to your bank account!", "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "You have earned nothing..", "error")
    end
end)