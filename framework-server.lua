Framework = {}
Framework.__index = Framework

function Framework:new()
    local self = setmetatable({}, Framework)
    self.config = json.decode(LoadResourceFile(GetCurrentResourceName(), "framework.json"))

    if not self.config.Framework then
        print("No framework selected. Please select a framework in framework.json")
        return
    end

    print("Framework: " .. self.config.Framework .. " is selected. AutoDetect: " .. (self.config.AutoDetect and "Enabled" or "Disabled") .. ". Initializing...")

    if self.config.AutoDetect then
        print("WARNING: AutoDetect is currently not supported in this build. Please set AutoDetect to false in framework.json and select a framework manually.")
    end

    if self.config.Framework == "None" then
        self.framework = {}
        return
    end

    -- Initialize Framework
    repeat
        if self.config.Framework == "ESX Legacy" then
            self.framework = exports.es_extended.getSharedObject()
        elseif self.config.Framework == "ESX Infinity" then
            TriggerEvent(self.config.ESXEvent, function(obj)
                self.framework = obj
            end)
        elseif self.config.Framework == "QBCore" then
            self.framework = exports["qb-core"].GetCoreObject()
        elseif self.config.Framework == "Custom" then
            self.framework = {}
        end
    until self.framework

    -- Initialize Framework
    return self
end

function Framework:getConfig()
    return self.config
end

function Framework:isInitialized()
    return self.framework ~= nil
end

function Framework:getFramework()
    return self.framework
end

function Framework:getFrameworkName()
    return self.config.Framework
end

function Framework:getPlayerWalletMoney(player)
    local money = 0
    if self.config.Framework == "ESX Legacy" or self.config.Framework == "ESX Infinity" then
        money = self.framework.GetPlayerFromId(player).getMoney()
    elseif self.config.Framework == "QBCore" then
        money = self.framework.Functions.GetPlayer(player).PlayerData.money["cash"] or self.framework.Functions.GetPlayer(player).PlayerData.money.cash
    elseif self.config.Framework == "Custom" then
        money = exports[self.config.ExportResource].GetPlayerWalletMoney(player)
    end
    return money
end

function Framework:getPlayerAccountMoney(player, account)
    local money = 0
    if self.config.Framework == "ESX Legacy" then
        money = self.framework.GetPlayerFromId(player).getAccount(account)
    elseif self.config.Framework == "ESX Infinity" then
        money = self.framework.GetPlayerFromId(player).getAccount(account) or self.framework.GetPlayerFromId(player).GetAccountMoney(account) or (self.framework.GetPlayerFromId(player).accounts.find(function(x) return x.name == account end) or {}).money or 0
    elseif self.config.Framework == "QBCore" then
        money = self.framework.Functions.GetPlayer(player).PlayerData.money[account]
    elseif self.config.Framework == "Custom" then
        money = exports[self.config.ExportResource].GetPlayerAccountMoney(player, account)
    end
    return money
end

function Framework:addPlayerWalletMoney(player, amount)
    if self.config.Framework == 'ESX Legacy' or self.config.Framework == 'ESX Infinity' then
        self.framework.GetPlayerFromId(player).addMoney(amount)
    elseif self.config.Framework == 'QBCore' then
        self.framework.Functions.GetPlayer(player).Functions.AddMoney("cash", amount)
    elseif self.config.Framework == 'Custom' then
        exports[self.config.ExportResource].AddPlayerWalletMoney(player, amount)
    end
end

function Framework:removePlayerWalletMoney(player, amount)
    if self.config.Framework == 'ESX Legacy' or self.config.Framework == 'ESX Infinity' then
        self.framework.GetPlayerFromId(player).removeMoney(amount)
    elseif self.config.Framework == 'QBCore' then
        self.framework.Functions.GetPlayer(player).Functions.RemoveMoney("cash", amount)
    elseif self.config.Framework == 'Custom' then
        exports[self.config.ExportResource].RemovePlayerWalletMoney(player, amount)
    end
end

function Framework:addPlayerAccountMoney(player, account, amount)
    if self.config.Framework == 'ESX Legacy' then
        self.framework.GetPlayerFromId(player).addAccountMoney(account, amount)
    elseif self.config.Framework == 'ESX Infinity' then
        self.framework.GetPlayerFromId(player).addAccountMoney(account, amount)
    elseif self.config.Framework == 'QBCore' then
        self.framework.Functions.GetPlayer(player).Functions.AddMoney(account, amount)
    elseif self.config.Framework == 'Custom' then
        exports[self.config.ExportResource].AddPlayerAccountMoney(player, amount, account)
    end
end

function Framework:removePlayerAccountMoney(player, account, amount)
    if self.config.Framework == 'ESX Legacy' then
        self.framework.GetPlayerFromId(player).removeAccountMoney(account, amount)
    elseif self.config.Framework == 'ESX Infinity' then
        self.framework.GetPlayerFromId(player).removeAccountMoney(account, amount)
    elseif self.config.Framework == 'QBCore' then
        self.framework.Functions.GetPlayer(player).Functions.RemoveMoney(account, amount)
    elseif self.config.Framework == 'Custom' then
        exports[self.config.ExportResource].RemovePlayerAccountMoney(player, amount, account)
    end
end

function Framework:addPlayerInventoryItem(player, item, amount)
    if amount <= 0 then
        return
    end

    if self.config.Framework == 'ESX Legacy' then
        self.framework.GetPlayerFromId(player).addInventoryItem(item, amount)
    elseif self.config.Framework == 'ESX Infinity' then
        self.framework.GetPlayerFromId(player).addInventoryItem(item, amount)
    elseif self.config.Framework == 'QBCore' then
        self.framework.Functions.GetPlayer(player).Functions.AddItem(item, amount)
    elseif self.config.Framework == 'Custom' then
        exports[self.config.ExportResource].AddPlayerInventoryItem(player, item, amount)
    end
end

function Framework:removePlayerInventoryItem(player, item, amount)
    if amount <= 0 then
        return
    end

    if self.config.Framework == 'ESX Legacy' then
        self.framework.GetPlayerFromId(player).removeInventoryItem(item, amount)
    elseif self.config.Framework == 'ESX Infinity' then
        self.framework.GetPlayerFromId(player).removeInventoryItem(item, amount)
    elseif self.config.Framework == 'QBCore' then
        self.framework.Functions.GetPlayer(player).Functions.RemoveItem(item, amount)
    elseif self.config.Framework == 'Custom' then
        exports[self.config.ExportResource].RemovePlayerInventoryItem(player, item, amount)
    end
end

function Framework:getPlayerInventoryItemCount(player, item)
    local itemCount = 0
    if self.config.Framework == 'ESX Legacy' or self.config.Framework == 'ESX Infinity' then
        itemCount = self.framework.GetPlayerFromId(player).getInventoryItem(item).count
    elseif self.config.Framework == 'QBCore' then
        itemCount = self.framework.Functions.GetPlayer(player).Functions.GetItemByName(item).amount
    elseif self.config.Framework == 'Custom' then
        itemCount = exports[self.config.ExportResource].GetPlayerInventoryItemCount(player, item)
    end
    return itemCount
end
