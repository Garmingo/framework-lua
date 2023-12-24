-- Copyright (c) 2023 Garmingo
-- All rights reserved.
-- Unauthorized use, reproduction, and distribution of this source code is strictly prohibited.

Framework = {}
Framework.__index = Framework

function Framework:new()
    local self = setmetatable({}, Framework)
    self.config = json.decode(LoadResourceFile(GetCurrentResourceName(), "framework.json"))

    if not self.config.Framework then
        print("No framework selected. Please select a framework in framework.json")
        return
    end

    print("Framework: " .. self.config.Framework .. " is selected. Initializing...")

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

function Framework:getPlayerJobName()
    local jobName = ""
    if self.config.Framework == "ESX Legacy" or self.config.Framework == "ESX Infinity" then
        jobName = self.framework.GetPlayerData().job.name
    elseif self.config.Framework == "QBCore" then
        jobName = self.framework.functions.GetPlayerData().job.name
    elseif self.config.Framework == "Custom" then
        jobName = exports[self.config.ExportResource].GetPlayerJobName()
    end
    return jobName
end

function Framework:getPlayerJobGrade()
    local jobGrade = 0
    if self.config.Framework == "ESX Legacy" or self.config.Framework == "ESX Infinity" then
        jobGrade = self.framework.GetPlayerData().job.grade
    elseif self.config.Framework == "QBCore" then
        jobGrade = self.framework.functions.GetPlayerData().job.grade
    elseif self.config.Framework == "Custom" then
        jobGrade = exports[self.config.ExportResource].GetPlayerJobGrade()
    end
    return jobGrade
end

function Framework:getInventoryItemCount(item)
    local itemCount = 0
    if self.config.Framework == "ESX Legacy" or self.config.Framework == "ESX Infinity" then
        for _, i in pairs(self.framework.GetPlayerData().inventory) do
            if i.name == item then
                itemCount = i.count
                break
            end
        end
    elseif self.config.Framework == "QBCore" then
        itemCount = self.framework.Functions.GetPlayerData().Functions.GetItemsByName(item).amount
    elseif self.config.Framework == "Custom" then
        itemCount = exports[self.config.ExportResource].GetInventoryItemCount(item)
    end
    return itemCount
end

function Framework:addCarKeys(plate)
    if self.config.Framework == 'QBCore' then
        TriggerEvent("qb-vehiclekeys:client:AddKeys", plate)
    end
end
